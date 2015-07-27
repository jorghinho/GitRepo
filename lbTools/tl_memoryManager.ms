------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Memory Manager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta Memory Manager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Memory Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 400		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 235		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		local hSize = 0 --variable para guardar el ultimo heapSize medido
		local hFree = 0 --variable para guardar el ultimo heapFree medido
		local hUsed = 0 --variable para guardar el ultimo heapUsed medido		
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles

		timer tmClock interval:1000 active:false
		
		groupbox grpInfo "" pos:[5,0] width:105 height:85
	
		label lblHeapSize "heapSize:100.0MB" pos:[10,15]
		label lblHeapFree "heapFree:00.0MB" pos:[10,35]
		label lblHeapUsed "heapInUse:00.0MB" pos:[10,55]
		
		groupbox grpOptions "Options" pos:[115,0] width:280 height:85
		
		label separator01 "_____________________________________________" pos:[120,22] enabled:false
		
		button btnIncrease "increase" pos:[250,12] width:140 height:20
		button btnGC "gc" pos:[250,37] width:70 height:20
		button btnGClight "gc light" pos:[320,37] width:70 height:20
		
		label lblIncrease "increase heap in:" pos:[120,14]
		spinner spnIncrease "" pos:[200,14] width:40 height:16 range:[10,100,10] scale:5 type:#integer
		label lblMem "MB Variation:" pos:[120,38]
		spinner spnMem "" pos:[200,38] width:40 height:16 range:[0.1,100,1]
		label lblSecs "Interval (secs):" pos:[120,60]
		spinner spnSecs "" pos:[200,60] width:40 height:16 range:[1,100,1]

		checkbox chkInfo "print all messages" pos:[250,62] width:105 checked:false
		button btnClear "Clear" pos:[355,60] width:35 height:20
		
		dotNetControl edtMemNotifications "System.Windows.Forms.richTextBox" pos:[5,90] width:390 height:140
		
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
		--COMMON
		------------------------------------------------
		
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
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
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
				
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
		)

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
		--@event: tick | Ejecución por cada tick.
		------------------------------------------------
		on tmClock tick do
		(
			--obtiene los valores actuales de la memoria
			hSizeTemp = (((heapSize/1000000.0)*10) as integer)/10.0
			hFreeTemp = (((heapFree/1000000.0)*10) as integer)/10.0
			hUsedTemp = (((hSizeTemp - hFreeTemp)*10) as integer)/10.0
			
			--rellena los labels de informacion
			lblHeapSize.text = ("heapSize: " + (hSizeTemp as string) + "MB")
			lblHeapFree.text = ("heapFree: " + (hFreeTemp as string) + "MB")
			lblHeapUsed.text = ("heapInUse: " + (hUsedTemp as string) + "MB")
			
			--si el chk esta pulsado imprime en cada tick, informacion del estado de la memoria acompañado de la hora
			if chkInfo.checked do
			(
				message = localTime + " >>> Size: " + (hSizeTemp as string) + "MB > Free: " + (hFreeTemp as string) + "MB > InUse: " + (hUsedTemp as string) + "MB\n"
				edtMemNotifications.text = message + edtMemNotifications.text
			)
			
			--si hay una perdida de memoria brusca mayor que el valor indicado en memory variation, se produce una alarma
			if (hFreeTemp < (hFree - (spnMem.value))) then
			(
				message = localTime + " >>> Memory Lost. " + ((hFree - hFreeTemp) as string)  + "MB lost\n"
				edtMemNotifications.text = message + edtMemNotifications.text
			)
				
			hSize = hSizeTemp
			hFree = hFreeTemp
			hUsed = hUsedTemp
		)

		------------------------------------------------
		--@event: pressed | Incrementa el heapsize.
		------------------------------------------------
		on btnIncrease pressed do
		(
			heapSize += (spnIncrease.value * 1000000)
			message = localTime + " >>> Heapsize increased in " + (spnIncrease.value as string) + "MB\n"
			edtMemNotifications.text = message + edtMemNotifications.text
		)

		------------------------------------------------
		--@event: pressed | Vacia el log.
		------------------------------------------------
		on btnClear pressed do
			edtMemNotifications.text = ""
		
		------------------------------------------------
		--@event: changed | Actualiza el intervalo.
		------------------------------------------------
		on spnSecs changed value do
			tmClock.interval = (value * 1000)
		
		------------------------------------------------
		--@event: pressed | Limpia la memoria y borra los undos.
		------------------------------------------------
		on btnGC pressed do
		(
			gc()
			message = localTime + " >>> Full Garbage Colector\n"
			edtMemNotifications.text = message + edtMemNotifications.text
		)

		------------------------------------------------
		--@event: pressed | Limpia la memoria conservando los undos.
		------------------------------------------------
		on btnGClight pressed do
		(
			(gc light:true)
			message = localTime + " >>> Light Garbage Colector\n"
			edtMemNotifications.text = message + edtMemNotifications.text
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			tmClock.interval = (spnSecs.value * 1000)
			tmClock.active = true --activa el timer
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			tmClock.active = false --desactiva el timer
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_memoryManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool Memory Manager",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
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
			createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		------------------------------------------------
		fn run =
		(
			this.createInterface() --crea el interface.
			this.opened = true --indica que la herramienta está abierta
		),--execute
		
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
		
	)--tl_memoryManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_memoryManager() --crea la herramienta
)