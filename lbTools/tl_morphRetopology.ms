------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta morphRetopology.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta morphRetopology.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Morph Retopology"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 230		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 280		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local _modifiedObj = undefined	--@var: modifiedObj | Almacena el objeto modificado para compararlo con el original.	
		local _targets = #()				--@var: targets | Almacena los objetos en los que aplicar la modificación.

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		pickButton pckModified "modified: <object>" pos:[10,10] width:210 height:20	--@control: pckOrigin | Pick button para elegir el objeto original.

		listBox lbxTargets "Target Objects" pos:[10,35] width:210 height:11 enabled:false	--@control: lbxTargets | Listbox para los objetos que van a ser modificados.
		button btnAddSelect "Add selected" pos:[10,205] width:160 height:20 enabled:false		--@control: btnAddSelect | Botón para obtener como targets los objetos seleccionados.
		button btnClear "Clear" pos:[180,205] width:40 height:20 enabled:false				--@control: btnClear | Botón para limpiar el listado de targets.

		button btnApply "Apply" pos:[10,230] width:210 height:40 enabled:false	--@control: btnApply | Botón para propagar las modificaciones a los targets.

		button btnInfo "" pos:[198,30] width:22 height:20 toolTip:"Info" images:#((lb.config.getCustomIconsPath()) + "miscIcons001_16i.bmp", undefined, 50, 25, 25, 26, 26, true) border:false
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
		--@fn: undefined | updateUI | Actualiza los valores de los controles del interface.
		------------------------------------------------
		fn updateUI =
		(
			if _modifiedObj != undefined then --activa los controles del UI
			(
				lbxTargets.enabled = true
				btnAddSelect.enabled = true
				btnClear.enabled = true

				if _targets.count != 0 then
				(
					lbxTargets.items = for o in _targets collect o.name
					btnApply.enabled = true
				)--if
				if isValidNode _modifiedObj then pckModified.caption = _modifiedObj.name
			)
			else --desactiva los controles del UI
			(
				pckModified.caption = "modified: <object>"
				lbxTargets.items = #()
				btnApply.enabled = false
				btnAddSelect.enabled = false
				lbxTargets.enabled = false
				btnClear.enabled = false
			)--if else		
		)

		------------------------------------------------
		--@fn: undefined | reset | Hace un reset de la herramienta.
		------------------------------------------------
		fn reset =
		(
			--vacia las variables
			_modifiedObj = undefined
			_targets = #()
				
			updateUI()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.addscript #filePostOpenProcess "lb.morphRetopology.rollMain.reset()" id:_id	
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.removescripts id:_id		
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
		--COMMON
		------------------------------------------------

		on btnInfo pressed do
		(
			lb.message.show "Modifier edit_poly must be over morpher modifier." type:#message
		)
		
		---------------------------------------------------------------------------------------------------------------
		--@event | pressed | Evento que se lanza al presionar el boton btnApply para propagar las modificaciones en los targets.
		--@control: button | btnApply | Botón para aplicar las modificaciones en los targets.
		---------------------------------------------------------------------------------------------------------------
		on btnApply pressed do
		(	
			for _target in _targets do
			(
	 			_newHead = copy _modifiedObj    
	 			_newHead.pos = _target.pos 
 				_newHead.name = _target.name 

	 			_editPolyIndex = 0
	 			for i=1 to _newHead.modifiers.count where classof _newHead.modifiers[i] == Edit_Poly do
	 				_editPolyIndex = i

	 			addModifier _newHead (Morpher()) before:_editPolyIndex
	 			_newHead.modifiers[#Morpher].Autoload_of_targets = 1
				WM3_MC_BuildFromNode _newHead.morpher 1 _target
				WM3_MC_SetValue _newHead.modifiers[#morpher] 1 100.00
	 			convertToPoly _newHead 
				if isValidNode _target then delete _target
				
				_layerToMoveTargets = _modifiedObj.layer.name
				_layer = lb.layer.getLayerbyName _layerToMoveTargets
				_layer.addNode _newHead
			)

		)		

		------------------------------------------------
		--@event | picked | Evento que se lanza al elegir un objeto como modificado.
		--@control: pickButton | pckModified | pickButton para elegir el objeto modificado.
		--@gets: node | obj | Nodo de la escena elegido como objeto modificado.
		------------------------------------------------
		on pckModified picked obj do
		(	
			_modifiedObj = undefined
			--desactiva el boton de copiar y vacia el listado
			lbxTargets.items = #()
			_targets = #()

			if isValidNode obj and ((classof obj.baseObject == PolyMeshObject) or (classof obj.baseObject == Editable_Poly)) then
				_modifiedObj = obj 
			else
				messageBox "Modified object must be an Editable_Poly"	
			updateUI()
		)

		------------------------------------------------
		--@event | pressed | Evento que se lanza al presionar el boton btnAddSelect para obtener los nodos seleccionados de la escena como targets.
		--@control: button | btnAddSelect | Botón para elegir la selección de nodos de la escena y usarlos como targets.
		------------------------------------------------
		on btnAddSelect pressed do
		(
			_targets = #()			--objetos a los que copiar el modificador
			_targetNames = #()		--nombres de los targets			
				
			for obj in selection where (((classof obj == PolyMeshObject) or (classof obj == Editable_Poly))) and (obj != _modifiedObj) do
			(
				append _targets obj
				append _targetNames obj.name
			)--for

			updateUI()
		)

		------------------------------------------------
		--@event | pressed | Evento que se lanza al presionar el boton btnClear para limpiar el listado de targets.
		--@control: button | btnClear | Botón para limpiar el listado de targets.
		------------------------------------------------
		on btnClear pressed do
		(
			_targets = #()
			lbxTargets.items = #()
			updateUI()
		)

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
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
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
	--@struct: tl_morphRetopology | Contiene la herramienta morphRetopology.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_morphRetopology
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Morph Retopology",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_morphRetopology
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_morphRetopology() --crea la herramienta
)