------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Log Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 500		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 475		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local currentTimeId = undefined --@var: currentTimeId | Id del tiempo en el que se ha abierto la herramient o se ha hecho clear.
		local lastShownLogTimeId = undefined --@var: lastShownLogTimeId | Id de tiempo del ultimo log mostrado en el listado.
			
		local generalBackColor = (dotNetClass "System.drawing.color").fromArgb 20 20 20 --50 50 50 --@var: generalBackColor | Color de fondo general del listado.
		local generalForeColor = (dotNetClass "System.drawing.color").fromArgb 160 160 160 --200 200 200 --@var: generalForeColor | Color de letra del listado.
		
		local errorBackColor = (dotNetClass "System.drawing.color").fromArgb 20 20 20 --160 20 40 --@var: errorBackColor | Color de fondo de error.
		local errorForeColor = (dotNetClass "System.drawing.color").fromArgb 255 20 20 --160 20 40 --235 235 235 --@var: errorForeColor | Color de letra de error.
		
		local warningBackColor = (dotNetClass "System.drawing.color").fromArgb 20 20 20 --200 80 10 --@var: warningBackColor | Color de fondo de warning.
		local warningForeColor = (dotNetClass "System.drawing.color").fromArgb 255 200 0 ---200 80 10 --235 235 235 --@var: warningForeColor | Color de letra de warning.
			
		local okBackColor = (dotNetClass "System.drawing.color").fromArgb 20 20 20 --20 100 50 --@var: errorBackColor | Color de fondo de error.
		local okForeColor = (dotNetClass "System.drawing.color").fromArgb 20 150 50 --235 235 235 --@var: errorForeColor | Color de letra de error
		
		local sepBackColor = (dotNetClass "System.drawing.color").fromArgb 20 20 20 --0 0 0 --@var: sepBackColor | Color de fondo de error.
		local sepForeColor = (dotNetClass "System.drawing.color").fromArgb 235 235 235 --@var: sepForeColor | Color de letra de error
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label lblSender "Log Sender:" pos:[7,10] width:60 height:15
		dropDownList ddlSender "" pos:[5,30] width:163 height:21 --@control | ddlSender | Lista de procesos que han creado los logs.
		
		label lblType "Log Type:" pos:[170,10] width:60 height:15
		dropDownList ddlType "" pos:[168,30] width:163 height:21 --@control | ddlType | Lista de tipos de log, Error, Warning, Info, etc.
			
		label lblTime "Log Time:" pos:[333,10] width:60 height:15
		dropDownList ddlTime "" pos:[331,30] width:165 height:21 --@control | ddlTime | Lista de opciones de tiempo y de fecha para mostrar los logs.
		
		dotnetControl lvLogs "System.Windows.Forms.ListView" pos:[5,55] width:490 height:395 --@control | lvLogs | Listado de logs.
		
		label lblUpdate "Update on" pos:[7,453] width:60 height:15
		radioButtons rdoUpdate "" pos:[62,453] width:188 height:16 labels:#("Real Time", "Demand") columns:2 --@control | rdoUpdate | Opciones de actualizacion.
		button btnRefresh "Refresh" pos:[195,450] width:60 height:20 enabled:false --@control | btnRefresh | Boton de refresco del listado.
		
		button btnRemove "Remove all log files" pos:[260,450] width:117 height:20 --@control | btnRemove | Boton de borrado de archivos de log.
		button btnClear "Clear" pos:[380,450] width:117 height:20 --@control | btnClear | Boton de limpieza del listado.
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | initLvLogs | Inicia las propiedades del listado de logs.
		------------------------------------------------
		fn initLvLogs =
		(
			lvLogs.View = (dotNetClass "System.Windows.Forms.View").details
			lvLogs.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lvLogs.labelEdit = false
			lvLogs.fullRowSelect = true
			lvLogs.hideSelection = false
			lvLogs.padding.all = 0
			lvLogs.scrollable = true
			lvLogs.gridlines = false
			lvLogs.headerStyle = (dotnetclass "System.Windows.Forms.ColumnHeaderStyle").None --NonClickable
				
			lvLogs.backColor = generalBackColor
			lvLogs.foreColor = generalForeColor
			
			lvLogs.Columns.add "Type" 50
			lvLogs.Columns.add "Time" 120
			lvLogs.Columns.add "Sender" 200
			lvLogs.Columns.add "Log" (lvLogs.width - 390)
		)
		
		------------------------------------------------
		--@fn: undefined | initInterface | Rellena la información necesaria para trabajar y pinta el interface con esos datos.
		------------------------------------------------
		fn initInterface =
		(
			currentTimeId = lb.time.getCurrentTimeId() --establece el id de apertura de la herramienta
			
			--rellena los listados
			ddlSender.items = lb.log.getAllSenders() --rellena las opciones de senders
			ddlType.items = lb.log.typesTags --rellena las opciones de tipos
			ddlTime.items = lb.log.timeOptionsTags --rellena las opciones de tiempo
			
			--coloca los listados en el parametro por defecto que se le haya indicado al padre
			if parent != undefined then
			(
				_items = for _it in ddlSender.items collect tolower _it
				_index = findItem _items (tolower (parent.sender as string))
				if _index == 0 then _index = 1
				ddlSender.selection = _index
				
				_items = for _it in ddlType.items collect tolower _it
				_index = findItem _items (tolower (parent.type as string))
				if _index == 0 then _index = 1
				ddlType.selection = _index
				
				_items = for _it in ddlTime.items collect tolower _it
				_index = findItem _items (tolower (parent.time as string))
				if _index == 0 then _index = 1
				ddlTime.selection = _index
				
				if parent.currentTimeId != undefined then currentTimeId = parent.currentTimeId
			)--if
			
			initLvLogs() --incializa el listado de logs
		)
		
		------------------------------------------------
		--@fn: undefined | appendLog | Añade una linea al listado de logs.
		------------------------------------------------
		fn appendLog newLog =
		(
			_row = dotNetObject "System.Windows.Forms.ListViewItem" (newLog.getProperty "type")
								
			_row.SubItems.add (newLog.getProperty "time")
			_row.SubItems.add (newLog.getProperty "sender")
			_row.SubItems.add (newLog.getText())
				
			_row.UseItemStyleForSubItems = false --hace que el color de cada celda pueda ser diferente
			
			------------------------------------------------
			--casos especiales en los que hay que cambiar de color algunas partes	
			_type = newLog.getProperty "type"
			if _type != "info" then
			(
				_bkColor = generalBackColor
				_frColor = generalForeColor
				
				case _type of
				(
					"error": (_bkColor = errorBackColor; _frColor = errorForeColor)
					"warning": (_bkColor = warningBackColor; _frColor = warningForeColor)
					"ok": (_bkColor = okBackColor; _frColor = okForeColor)
					"sep": (_bkColor = sepBackColor; _frColor = sepForeColor)
				)--case
				
				for i=1 to _row.subitems.count do (_row.subitems.item[i-1].backColor = _bkColor; _row.subitems.item[i-1].foreColor = _frColor)
			)--if
			------------------------------------------------
				
			lvLogs.items.add _row
			(lvLogs.items.item[lvLogs.items.count - 1]).EnsureVisible() --pone el scroll al final
			lastShownLogTimeId = newLog.getProperty "id"
		)
		
		------------------------------------------------
		--@fn: undefined | fillLogsList | Rellena el listado de logs con la opciones indicadas.
		--@opt: boolean | clearList | true | Indica si limpiar el listado antes.
		--@opt: string | refTimeId | undefined | Id de referencia a partir del cual obtener los ids.
		------------------------------------------------
		fn fillLogsList clearList:true refTimeId:undefined =
		(
			if refTimeId == undefined then refTimeId = currentTimeId
			
			--obitiene los logs que cumplan las opciones del interface.
			_sender = ddlSender.selected
			if _sender == "All" then _sender = #all
			_logs = lb.log.getLogs sender:_sender type:(lb.log.types[ddlType.selection]) timeOption:(lb.log.timeOptions[ddlTime.selection]) refTimeId:refTimeId
			
			lvLogs.BeginUpdate() --hace que no este redibujando
			
			if clearList then lvLogs.items.clear() --limpia el listado
			for _log in _logs do appendLog _log --añade los logs
			
			lvLogs.EndUpdate() --indica que ha terminado de hacer operaciones para que redibuje
		)
		
		------------------------------------------------
		--@fn: undefined | removeLogFiles | Elimina los archivos de logs.		
		------------------------------------------------
		fn removeLogFiles =
		(
			lb.log.removeLogFiles()
		)
		
		------------------------------------------------
		--@fn: undefined | updateList | Actualiza el listado con los nuevos logs
		--@opt: log | log | undefined | Log con el cual actualizar el listado.
		------------------------------------------------
		fn updateList log:undefined =
		(
			case rdoUpdate.state of
			(
				1:
				(
					if log != undefined then
					(
						_type = log.getProperty "type"
						_sender = log.getProperty "sender"
						
						if (ddlType.selected == "All") or ((tolower _type) == (tolower ddlType.selected)) then
						(
							if findItem ddlSender.items _sender == 0 then ddlSender.items = ddlSender.items + #(_sender)
							
							if (ddlSender.selected == "All") or ((tolower _sender) == (tolower ddlSender.selected)) then
							(
								lvLogs.BeginUpdate() --hace que no este redibujando
								appendLog log
								lvLogs.EndUpdate() --indica que ha terminado de hacer operaciones para que redibuje
							)--if
						)--if
					)--if
				)--1
				
				2:
				(
					if log == undefined then
					(
						fillLogsList clearList:false refTimeId:lastShownLogTimeId
					)--if
				)--2
			)--case			
		)
		
		------------------------------------------------
		--@fn: undefined | updateUI | Refresca el estado de los controles del interface.
		------------------------------------------------
		fn updateUI =
		(
			btnRefresh.enabled = rdoUpdate.state == 2 --el boton solo esta habilitado cuando la opcion sea bajo demanda
		)	
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
			
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar la seleccion del desplegable.
		--@control: dropDownList | ddlSender | DropDownList cuya seleccion cambia.
		--@gets: integer | newIndex | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlSender selected newIndex do
		(
			fillLogsList() --limpiar y rellenar de nuevo el listado
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar la seleccion del desplegable.
		--@control: dropDownList | ddlType | DropDownList cuya seleccion cambia.
		--@gets: integer | newIndex | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlType selected newIndex do
		(
			fillLogsList() --limpiar y rellenar de nuevo el listado
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar la seleccion del desplegable.
		--@control: dropDownList | ddlTime | DropDownList cuya seleccion cambia.
		--@gets: integer | newIndex | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlTime selected newIndex do
		(
			fillLogsList() --limpiar y rellenar de nuevo el listado
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar de estado el control.
		--@control: radioButtons | rdoUpdate | Control que cambia de estado.
		--@gets: integer | state | Nuevo estado del control.
		------------------------------------------------
		on rdoUpdate changed state do
		(
			updateUI()
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnRefresh | Boton pulsado.		
		------------------------------------------------
		on btnRefresh pressed do
		(			
			updateList() --añade los logs que faltan
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnRemove | Boton pulsado.		
		------------------------------------------------
		on btnRemove pressed do
		(
			if (queryBox "This operation has no undo. Do you want to continue?") then
			(
				ddlTime.selection = 1
				currentTimeId = lb.time.getCurrentTimeId() --establece el id de tiempo de limpieza del listado
				removeLogFiles() --elimina los archivos de los logs
				fillLogsList() --limpiar y rellenar de nuevo el listado
			)--if
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnClear | Boton pulsado.		
		------------------------------------------------
		on btnClear pressed do
		(
			ddlTime.selection = 1
			currentTimeId = lb.time.getCurrentTimeId() --establece el id de tiempo de limpieza del listado
			fillLogsList() --limpiar y rellenar de nuevo el listado
		)	
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				lblType.pos.x = 170 + _increment.x/3.0
				lblTime.pos.x = 333 + _increment.x/1.5
				
				ddlType.pos.x = 168 + _increment.x/3.0
				ddlTime.pos.x = 331 + _increment.x/1.5
				
				ddlSender.width = 163 + _increment.x/3.0
				ddlType.width = 163 + _increment.x/3.0
				ddlTime.width = 165 + _increment.x/3.0
				
				lvLogs.width = 490 + _increment.x
				if lvLogs.columns.count != 0 then lvLogs.columns.item[3].width = (lvLogs.width - 390)
				
				btnRemove.pos.x = 260 + _increment.x
				btnClear.pos.x = 380 + _increment.x
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				lvLogs.height = 395 + _increment.y
				
				lblUpdate.pos.y = 453 + _increment.y
				rdoUpdate.pos.y = 453 + _increment.y
				btnRefresh.pos.y = 450 + _increment.y
				btnRemove.pos.y = 450 + _increment.y
				btnClear.pos.y = 450 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			
			initInterface() --incializa el interface
			fillLogsList() --rellena el listado de logs
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: passManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_logManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool plantilla",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		sender = #all, --@var: sender | Indica el sender para el cual se ha abierto la herramienta. Por defecto esta en all.
		type = #all, --@var: type | Indica el tipo de log para el cual se ha abierto la herramienta. Por defecto esta en all.
		time = #current, --@var: time | Indica el periodo de tiempo de log para el cual se ha abierto la herramienta. Por defecto esta en current.
		currentTimeId = undefined, --@var: currentTimeId | Id de tiempo con el que se indica a la herramienta a partir de que momento mostar los logs.
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollMain | Almacena el rollout principal de la herramienta.
			
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | update | Actualiza el listado con los nuevos logs.
		--@opt: log | log | undefined | Log con el cual actualizar el listado.
		------------------------------------------------
		fn update log:undefined =
		(
			this.rollMain.updateList log:log
		),
		
		------------------------------------------------
		--@fn: undefined | clear | Limpia el listado de logs.
		------------------------------------------------
		fn clear =
		(
			this.rollMain.ddlTime.selection = 1
			this.rollMain.currentTimeId = lb.time.getCurrentTimeId() --establece el id de tiempo de limpieza del listado
			this.rollMain.fillLogsList() --limpiar y rellenar de nuevo el listado
		),
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
		------------------------------------------------
		fn isOpen =
		(
			this.opened
		),
		
		------------------------------------------------
		--@fn: undefined | refreshInterface | Refresca el interface inicial de la herramienta
		------------------------------------------------
		fn refreshInterface =
		(
			--refresca el interface de la herramienta
		),
		
		------------------------------------------------
		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
		------------------------------------------------
		fn createInterface =
		(
			--crea el interface, lo redimensiona y lo reposiciona
			createDialog this.rollMain lockwidth:false lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
		------------------------------------------------
		fn destroyInterface =
		(
			destroyDialog this.rollMain --cierra la herramienta.			
		),--destroyInterface
		
		------------------------------------------------
		--@fn: undefined | run | Lanza la herramienta.
		--@opt: name | sender | #all | Opcion para indicar los logs de que herramienta mostrar.
		--@opt: name | type | #all | Opcion para indicar los logs de que tipo mostrar.
		--@opt: name | timeOption | #current | Opcion para indicar el periodo de tiempo de logs que mostrar.
		--@opt: string | refTimeId | undefined | Id de referencia a partir del cual obtener los ids.
		------------------------------------------------
		fn run sender:#all type:#all time:#current refTimeId:undefined =
		(
			this.sender = sender
			this.type = type
			this.time = time
			this.currentTimeId = refTimeId
			
			this.createInterface() --crea el interface.
			this.opened = true --indica que la herramienta está abierta
		),
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
		------------------------------------------------
		fn close =
		(
			this.destroyInterface() --destruye el interface.
			this.opened = false --indica que la herramienta está cerrada.
		),
		
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrerías en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librería.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librerías hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecución al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addTool this --añade la tool a la libreria principal	
		)		
		
	)--tl_logManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_logManager() --crea la herramienta
	
	ok
)