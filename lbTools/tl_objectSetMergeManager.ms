------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta objectSetMergeManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	global _rollMergeOps
	global _answer
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene el rollout principal de la herramienta.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMergeOpsDef "Merge Conflicts" width:600 height:65
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label lblMessage "Some objectSets to load share names with local scene objectSets. What do you want to do with conflictive objectSets?" pos:[25,10]
		button btnUseMerged "Use Merged" pos:[135,35] width:100 height:25			--@control | btnUseMerged | Selecciona la opcion de usar los mergeados.
		button btnUseScene "Don't Merge Conflicts" pos:[240,35] width:120 height:25	--@control | btnUseScene | Selecciona la opcion de usar los de la escena.
		button btnCancel "Cancel" pos:[365,35] width:100 height:25					--@control | btnCancel | Seleciona la opcion de cancel.
			
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
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Selecciona la respuesta.
		--@control: button | btnUseMerged | Boton presionado.
		------------------------------------------------
		on btnUseMerged pressed do
		(		
			_answer = #useMerged
			destroyDialog _rollMergeOps
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Selecciona la respuesta.
		--@control: button | btnUseScene | Boton presionado.
		------------------------------------------------
		on btnUseScene pressed do
		(
			_answer = #useScene
			destroyDialog _rollMergeOps
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Selecciona la respuesta.
		--@control: button | btnCancel | Boton presionado.
		------------------------------------------------
		on btnCancel pressed do
		(
			_answer = #cancel
			destroyDialog _rollMergeOps
		)

		------------------------------------------------
		--@event | MouseUp | Evento que se lanza al levantar el raton despues de hacer click o click derecho.
		--@control: CodersLab.Windows.Controls.TreeView | trvObjectSets | Arbol de objectSets.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		on trvObjectSets MouseUp events do
		(
			_button = events.button.ToString() --averigua si es boton izquierdo, derecho o central
			_tool = (lb.getTool "nodeSetManager" category:#common)
			
			--en función del boton pulsado ha de realizar unas operaciones u otras
			case _button of
			(
				"Right": --boton derecho
				(
					_level = -1 --nivel del arbol en el que se han seleccionado nodos
					
					_clickedNode = trvObjectSets.GetNodeAt events.Location --mira en que nodo se ha hecho click
					if _clickedNode != undefined then --si se ha hecho click en un nodo averigua el nivel del nodo
					(
						--si hay nodos seleccionados, comprueba de que nivel son para mostrar un menu u otro
						if trvObjectSets.selectedNodes.count != 0 then 
						(
							if trvObjectSets.selectedNodes.count == 1 then --si solo hay uno seleccionado comprueba que se ha hecho click en el y no fuera
							(
								if _clickedNode.text == (trvObjectSets.selectedNodes.item[0]).text then --si es el mismo
									_level = (trvObjectSets.selectedNodes.item[0]).level								
							)
							else --si hay varios seleccionados averigua el nivel de la seleccion
							(
								_level = (trvObjectSets.selectedNodes.item[0]).level
							)--if
						)--if
					)--if					
					
					case _level of
					(
						0: createRMenu mouse.screenPos #objectSets --lanza el menu de boton derecho de objectSets
						1: createRMenu mouse.screenPos #nodes --lanza el menu de boton derecho de nodos en los objectSets
						default: createRMenu mouse.screenPos #default --lanza el menu de boton derecho general
					)--case
				)--Right
			)--case			
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMergeOpsDef open do
		(
			global _answer = #cancel --inicializa la respuesta
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMergeOpsDef close do
		(
			--ejecucion al cerrarse
		)
	)--rollMergeOpsDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene el rollout principal de la herramienta.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Object Sets to Merge"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
			
		local minRollWidth = 200		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 300		--@var: minRollHeight | Alto mínimo de la herramienta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
			
		dotNetControl lvObjectSetsList "System.Windows.Forms.ListView" pos:[5,5] width:190 height:240 --@control | lvObjectSetsList | Listado de objectSets a cargar del archivo.
		button btnSelectAll "Select All" pos:[75,250]	--@control | btnSelectAll | Selecciona todos los objectSets para mergear en el listado.
		button btnLoad "Merge" pos:[5,275] width:190	--@control | btnLoad | Carga los objectSets seleccionados.
			
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
		--@fn: undefined | Establece los parametros y aspecto inicial del listado
		------------------------------------------------
		fn initListView =
		(
			--configura el aspecto del listado
			lvObjectSetsList.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5
			lvObjectSetsList.view = (dotNetClass "System.Windows.Forms.View").details
			lvObjectSetsList.headerStyle = (dotnetclass "System.Windows.Forms.ColumnHeaderStyle").none
			lvObjectSetsList.gridLines = false
			lvObjectSetsList.fullRowSelect = true
			lvObjectSetsList.backColor = (dotNetClass "System.Drawing.Color").fromargb 50 50 50
			lvObjectSetsList.foreColor = (dotNetClass "System.Drawing.Color").lightgray
			lvObjectSetsList.labelEdit = false
			lvObjectSetsList.columns.add "Object Sets" (lvObjectSetsList.width - 10)
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
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMai/size") "height") as integer
				
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
		--@event: pressed | Evento que se lanza al presionar el boton. Selecciona todo el listado.
		--@control: button | btnSelectAll | Boton presionado.
		------------------------------------------------
		on btnSelectAll pressed do
		(
			--selecciona todo el listado
			for i=1 to lvObjectSetsList.items.count do lvObjectSetsList.items.item[i-1].selected = true
			setFocus lvObjectSetsList
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Almacena los nombres de la seleccion en la tool y llama al proceso de merge de la tool.
		--@control: button | btnSelectAll | Boton presionado.
		------------------------------------------------
		on btnLoad pressed do
		(	
			--obtiene los nombres de la seleccion del listado y los almacena en la tool
			parent.objectSetsToMergeNames = (for i=1 to lvObjectSetsList.items.count where lvObjectSetsList.items.item[i-1].selected collect (lvObjectSetsList.items.item[i-1].text))
			parent.loadObjectSets() --llama al proceso de merge
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
				lvObjectSetsList.width = minRollWidth - 10 + _increment.x
				btnSelectAll.pos.x = 75 + _increment.x/2.0
				btnLoad.pos.x = 5 + _increment.x/2.0
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				lvObjectSetsList.height = 240 + _increment.y
				btnSelectAll.pos.y = 250 + _increment.y
				btnLoad.pos.y = 275 + _increment.y
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
			initListView() --stablece los parametros y aspecto inicial del listado
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			parent.sourceFile = undefined --vacia el archivo source del padre para que si se ejecuta otra vez no te coja una ruta residual
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: objectSetMergeManager | Contiene la herramienta de carga de objectSets de otra escena.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_objectSetMergeManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool de carga de objectSets de otro archivo",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.		
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		lastPath = "",				--@var: lastPath | Ultimo path usado para cargar o salvar objectSets.
		sourceFile = undefined,		--@var: sourceFile | Archivo del cual cargar los objectSets.
		objectSetsToMergeNames = #(),	--@var: objectSetsToMergeNames | Nombres de los objectSets que hay que mergear del archivo
		mergeOption = #useMerged,	--@var: mergeOption | Opcion del merge #useMerged, #useScene o #cancel.
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,			--@var: rollMain | Almacena el rollout principal de la herramienta.
		rollMergeOps = rollMergeOpsDef,	--@var: rollMergeOps | Almacena el rollout popup de pregunta por la opcion de merge.
		
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
		--@fn: boolean | loadObjectSets | Intenta cargar los objectSets del archivo. Devuelve TRUE si lo consigue y FALSE si no.
		------------------------------------------------
		fn loadObjectSets =
		(
			_success = false --para saber si tiene exito o no
			
			_sourceFileBckp = this.sourceFile --hace un backup del archivo source porque al cerrar el rollMain se limpia
			destroyDialog this.rollMain --cierra el dialogo del listado  primero
			this.sourceFile = _sourceFileBckp --restaura 
			
			--averigua si va a haber algun conflicto en la carga para poder preguntar que hacer
			_stop = false
			for _os in lb.objectSets.getAll() where not _stop and findItem this.objectSetsToMergeNames _os.caption != 0 do _stop = true
				
			this.mergeOption = #useMerged --por si hay conflicto de nombres, para almacenar la respuesta de la pregunta obvia sobre que hacer con los duplicados
				
			--si hay conflictos hay que decidir que hacer	
			global _rollMergeOps = this.rollMergeOps
			if _stop then
			(
				createDialog this.rollMergeOps modal:true
				this.mergeOption = _answer
			)
			
			_process = true --para saber si cargar los nodos del archivo especificado o no
			if this.mergeOption == #cancel then _process = false --si se ha cancelado la operacion no hace nada mas
				
			if _process then --si se puede proceder
			(
				setWaitCursor() --pone el cursor de modo de trabajo
					
				case this.mergeOption of
				(
					#useMerged: lb.objectSets.loadObjectSetsFromFile this.sourceFile captions:this.objectSetsToMergeNames overWriteDuplicated:true
					#useScene: lb.objectSets.loadObjectSetsFromFile this.sourceFile captions:this.objectSetsToMergeNames overWriteDuplicated:false
				)--case
					
				setArrowCursor() --pone el cursor de modo normal
				_success = true 
			)--if
			
			this.sourceFile = undefined --despues del proceso de merge se limpia el archivo origen
			
			--actualiza todas las intancias del objectSet Manager para que redibujen el listado
			_objectSetManagerInstances = lb.getToolInstances "objectSetManager"
			for _ins in _objectSetManagerInstances do _ins.rollMain.fillInfo()
			
			_success
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
			--rellena el listado
			for _name in this.objectSetsToMergeNames do
			(
				row = dotNetObject "System.Windows.Forms.ListViewItem" _name
				this.rollMain.lvObjectSetsList.items.add row
			)--for
			
			this.objectSetsToMergeNames = #() --vacia el array para que se rellene de nuevo a partir de la seleccion
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
		------------------------------------------------
		fn run =
		(
			--si no se ha establecido el archivo que mergear lo pide
			if this.sourceFile == undefined or not doesFileExist this.sourceFile then
				this.sourceFile = getOpenFileName filename:this.lastPath types:"ObjectSets(*.objs)|*.objs|"
				
			--solo si tiene archivo del que cargar objectSets abre la herramienta, si no, no tiene sentido
			if this.sourceFile != undefined and doesFileExist this.sourceFile then
			(
				this.lastPath = getFilenamePath this.sourceFile --guarda el path del archivo actual como el ultimo usado
				this.objectSetsToMergeNames = #() --vacia el array de nombres de nodos a mergear en cada ejecucion
				this.objectSetsToMergeNames = sort (lb.objectSets.getFileObjectSetCaptions this.sourceFile) --averigua los nombres de los objectSets del archivo a cargar
				this.createInterface() --crea el interface.
				this.opened = true --indica que la herramienta está abierta
				this.refreshInterface() --redibuja el interface de usuario
			)--if
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
		
	)--tl_objectSetMergeManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_objectSetMergeManager() --crea la herramienta
)