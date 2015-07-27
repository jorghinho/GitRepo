------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta dynamic Solver.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------
	--@attributes: attributes | CA_dynamicSolver | Añadimos la informacion
	------------------------------------------------
	CA_dynamicSolver = attributes dynamicSolver
	(
		------------------------------------------------------------------------------------------------
		--PARAMETERS
		------------------------------------------------------------------------------------------------
		
		parameters main
		(
			------------------------------------------------------------------------------------------------
			--COMMON
			------------------------------------------------------------------------------------------------
			
			CA_version 			type:#float  		animatable:false default: 1.0				-- Control de versiones.
			CA_description 		type:#string 		animatable:false default: "Información del sistema de dynamic solver"  -- Descripción.
			
			------------------------------------------------------------------------------------------------
			--VARIABLES
			------------------------------------------------------------------------------------------------
			
			originalWirecolor 	type:#color 		animatable:false 		--variable para rellenar mas adelante.									
		)
	)
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta dynamic Solver.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "dynamic Solver"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 210		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 280		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		local iconpath = if (maxversion())[1] < 14000 then ((getDir #ui) + @"icons\") else ((getDir #maxroot) + @"UI_ln\Icons\") -- ruta de los iconos de Max.
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		GroupBox grpSpringSystem "Spring System" pos:[5,5] width:200 height:50
		
		button btnCreateDynamic "Create" pos:[10,25] width:95 height:25 toolTip:"Create Spring System"
		button btnRemoveDynamic "Remove" pos:[110,25] width:90 height:25 toolTip:"Remove Spring System"
		
		GroupBox grpColisionObjects "Colision Objects" pos:[5,60] width:200 height:55
		button btnAddSelection "Add Selection" pos:[15,80] width:80 height:24 toolTip:"Add Colision Objects"
		button btnRemoveColision "Remove" pos:[115,80] width:80 height:24 toolTip:"Remove Spring System"
		
		GroupBox grpSpringParams "Spring parameters" pos:[5,120] width:200 height:80
		spinner spnSpring "Spring" pos:[20,140] width:75 height:16 range:[0,10000,100] type:#float fieldwidth:40
		spinner spnDampening "Damper" pos:[20,160] width:75 height:16 range:[0,10000,2] type:#float fieldwidth:40
		spinner spnGravity "Gravity" pos:[20,180] width:75 height:16 range:[-10000,10000,-981] type:#float fieldwidth:40
		checkbox chkGravity "Gravity" pos:[110,180] width:74 height:15 checked:on
		
		
		GroupBox grpCopyPaste "Copy/Paste" pos:[100,130] width:100 height:40
		button btnCopyDynamicParameters "Copy" pos:[110,145] width:20 height:20 toolTip:"Copy" border:false images:#(iconpath + "bip_copypaste_i.bmp", undefined, 24, 1, 1, 2, 2,true)
		button btnPasteDynamicParameters "Paste" pos:[150,145] width:20 height:20 toolTip:"Paste" border:false  images:#(iconpath + "bip_copypaste_i.bmp", undefined, 24, 11, 11, 12, 12,true)					 	
		button btnPasteOppositeDynamicParameters "PasteOpposite" pos:[175,145] width:20 height:20 toolTip:"Paste Opposite" border:false  images:#(iconpath + "bip_copypaste_i.bmp", undefined, 24, 13, 13, 14, 14,true)				 		
		
		GroupBox grpBakeAnimationDynamic "Bake Animation" pos:[5,205] width:200 height:70 
		button btnResetDynamic "Reset" pos:[10,225] width:40 height:40 toolTip:"Resets Simulation" images:#(iconpath + "PhysX_Main_24i.bmp", undefined, 33, 5, 5, 5, 5,true)
		button btnSimulationDynamic "Simulation" pos:[60,225] width:40 height:40 toolTip:"Create Simulation" images:#(iconpath + "PhysX_Main_24i.bmp", undefined, 33, 6, 6, 6, 6,true)
		button btnBakeDynamic "Bake" pos:[110,225] width:40 height:40 toolTip:"Bake Simulation" images:#(iconpath + "PhysX_Main_24i.bmp", undefined, 33, 7, 7, 7, 7,true)
		button btnUnBakeDynamic "Stop" pos:[160,225] width:40 height:40 toolTip:"UnBake Simulation" images:#(iconpath + "PhysX_Main_24i.bmp", undefined, 33, 8, 8, 8, 8,true)
		--@control | controlName | plantilla de comentario para controles
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		--@fn: undefined | createSelectionChangedCallBacks | crea el callback selectionSetChange para cuando haya un cambio de seleccion cree los shapes en esa seleccion
		------------------------------------------------------------------------------
		fn createSelectionChangedCallBacks =
		(
			callbacks.addscript #selectionSetChanged "lb.dynamicSolver.rollMain.selectionChange()" id: #dynamicSolver
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | removeSelectionChangedCallBacks | elimina el callback selectionSetChange
		------------------------------------------------------------------------------
		fn removeSelectionChangedCallBacks =
		(
			callbacks.removeScripts #selectionSetChanged id: #dynamicSolver
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | selectionChange | función para cambiar las selecciones en cualquier momento.
		------------------------------------------------------------------------------
		fn selectionChange =
		(
			_selec = getCurrentSelection()
			
			for _o in _selec do
			(
				if (classof _o.children[1] == UConstraint) then
				(
					spnDampening.value = _o.children[1].swingDamping 
					spnSpring.value = _o.children[1].swingSpring
				)
				
				if (classof _o.children[2] == UConstraint) then
				(
					spnDampening.value = _o.children[2].swingDamping
					spnSpring.value = _o.children[2].swingSpring
				)
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | createDynamicChain | función para añadir los elementos necesarios para las dinamicas.
		--@gets: node | objs |  pasa los objetos seleccionados.
		------------------------------------------------------------------------------
		fn createDynamicChain objs =
		(
			_arrayHierarchy = lb.rig.getHierarchiesFromNodes objs  --obtengo en un array los objetos seleccionados de forma ordenada.
			
			for _o in _arrayHierarchy[1] do 
			(
				addModifier _o (MassFX_RBody())		--Añado el modificador rigid body de dinamicas.
				_o.modifiers[#MassFX_Rigid_Body].meshType = 3
				_o.modifiers[#MassFX_Rigid_Body].meshRadius = 1
				
				--añadimos un custom atribute con la informacion de color, le cambiamos el color para distinguir las piezas a simular.					
				custAttributes.add _o CA_dynamicSolver #unique baseobject:false		
				_o.dynamicSolver.originalWirecolor = _o.wirecolor
				_o.wirecolor = color 85 28 177
					
				if _o == _arrayHierarchy[1][1] then
					_o.modifiers[#MassFX_Rigid_Body].type = 2  	--Cambia el tipo de rigid body a kinematic.
			)
			
			--Añado el UConstraint a todos los objetos menos al ultimo de la jerarquía y le marco la configuración por defecto.
			for _i=1 to _arrayHierarchy[1].count do
			(
				if _i != _arrayHierarchy[1].count then
				(
					_UConstraint = UConstraint()	--creacion de los constraint para la simulacion.
					_UConstraint.helpersize = 2
					_UConstraint.body0 = _arrayHierarchy[1][_i]				--padrre del uconstraint.
					_UConstraint.body1 = _arrayHierarchy[1][_i].children[1]	--hijo del uconstraint.
					_UConstraint.twistMode = 1		--twist locked.
					_UConstraint.swing2Mode = 2
					_UConstraint.swing1Mode = 2
					_UConstraint.swingSpring = spnSpring.value	--valor de spring.
					_UConstraint.swingDamping = spnDampening.value	--valor de damping.
					_UConstraint.transform = _arrayHierarchy[1][_i].children[1].transform		--alineamiento.
					_UConstraint.parent = _arrayHierarchy[1][_i].children[1]		--linkajes.
					hide _UConstraint
					
					--configuracion de naming.
					_UConstraint.name = _arrayHierarchy[1][_i].name			
					_UConstraintName = lb.nc.replaceNamePart _UConstraint.name 5 (_UConstraint.name + "-Uconstraint")
					_UConstraintName = lb.nc.replaceNamePart _UConstraint.name 3 lb.nc.NC_classDynamic
					_UConstraintName = lb.nc.replaceNamePart _UConstraint.name 7 (lb.nc.NC_hiddenFlag + lb.nc.NC_frozenFlag)
					
					--configuración de layer, capturamos la capa que nos interese y añadimos los elementos.
					_typeLayer = _arrayHierarchy[1][_i].layer.name
					_lyChr = layermanager.getLayerFromName _typeLayer
					_lyChr.addNode _UConstraint
				)
			)
		)	
		
		------------------------------------------------------------------------------
		--@fn: undefined | deleteDynamicChain | función para eliminar los elementos añadidos para las dinamicas.
		--@gets: node | objs |  pasa los objetos seleccionados.
		------------------------------------------------------------------------------
		fn deleteDynamicChain objs =
		(
			_arrayHierarchy = lb.rig.getHierarchiesFromNodes objs  --obtengo en un array los objetos seleccionados de forma ordenada, devuelve un array de arrays.
			
			for _arr in _arrayHierarchy do 
			(
				for _i = _arr.count to 1 by -1 do		--recorro los objetos de cada array de atras adelante.
				(
					_o = _arr[_i]  	--variable para sintetizar el nombre.
					
					if _o.modifiers[#MassFX_Rigid_Body] != undefined then
					(
						deleteModifier _o _o.modifiers[#MassFX_Rigid_Body] --elimina el modificador de dinamicas
						
						--borra el custom atribute y devuelve el color original a la pieza.
						_o.wirecolor = _o.dynamicSolver.originalWirecolor
						custAttributes.delete _o (custAttributes.getdef _o.dynamicSolver) baseobject:false
						
						--eliminacion de los constraint sin necesidad de seleccionarlos.
						if (classof _o.children[1] == UConstraint) then
							delete _o.children[1]
						if (classof _o.children[2] == UConstraint) then
							delete _o.children[2]
					)
				)
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | configSpring | función para poder cambiar el valor de spring de los constraint.
		------------------------------------------------------------------------------
		mapped fn configSpring =
		(
			removeSelectionChangedCallBacks()
			_selec = (getCurrentSelection())
			
			for _o in _selec do 
			(
				if (classof _o.children[1] == UConstraint) then
					_o.children[1].swingSpring = spnSpring.value
				
				if (classof _o.children[2] == UConstraint) then
					_o.children[2].swingSpring = spnSpring.value
			)
			createSelectionChangedCallBacks()
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | configDamper | función para poder cambiar el valor de damper de los constraint.
		------------------------------------------------------------------------------
		mapped fn configDamper =
		(
			removeSelectionChangedCallBacks()
			_selec = (getCurrentSelection())
			
			for _o in _selec do 
			(
				if (classof _o.children[1] == UConstraint) then
					_o.children[1].swingDamping = spnDampening.value
				
				if (classof _o.children[2] == UConstraint) then
					_o.children[2].swingDamping = spnDampening.value
			)
			createSelectionChangedCallBacks()
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | configGravity | función para poder cambiar el valor de gravity de los constraint.
		------------------------------------------------------------------------------
		fn configGravity =
		(
			PhysXPanelData.gravity = spnGravity.value
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | noGravity | función para poder anular la gravedad.
		------------------------------------------------------------------------------
		fn noGravity =
		(
			if chkGravity.checked == true then
			(
				spnGravity.enabled = true
				PhysXPanelData.gravityMode = 2
				PhysXPanelData.enableGravity = on
			)
			else
			(
				spnGravity.enabled = false
				PhysXPanelData.gravityMode = 1
				PhysXPanelData.enableGravity = off
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | pickColision | función para poder seleccionar objetos colisionadores concretos.
		--@gets: node | objs |  pasa los objetos seleccionados.
		------------------------------------------------------------------------------
		mapped fn addColision obj =
		(
			obj = (getCurrentSelection ())
				
			for _o in obj do 
			(
				addModifier _o (MassFX_RBody())		--Añado el modificador rigid body de dinamicas.
				_o.modifiers[#MassFX_Rigid_Body].type = 2  	--Cambia el tipo de rigid body a kinematic.
				
				--añadimos un custom atribute con la informacion de color, le cambiamos el color para distinguir las piezas a simular.					
				custAttributes.add _o CA_dynamicSolver #unique baseobject:false		
				_o.dynamicSolver.originalWirecolor = _o.wirecolor
				_o.wirecolor = color 88 88 225
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | removeColision | función para poder eliminar el modificador de colision.
		--@gets: node | objs |  pasa los objetos seleccionados.
		------------------------------------------------------------------------------
		mapped fn removeColision obj =
		(
			obj = (getCurrentSelection ())
				
			for _o in obj do 
			(
				if _o.modifiers[#MassFX_Rigid_Body] != undefined then
				(
					deleteModifier _o _o.modifiers[#MassFX_Rigid_Body] --elimina el modificador de dinamicas
					
					--borra el custom atribute y devuelve el color original a la pieza.
					_o.wirecolor = _o.dynamicSolver.originalWirecolor
					custAttributes.delete _o (custAttributes.getdef _o.dynamicSolver) baseobject:false
				)
			)
		)
	---------------------------------------------------------------------------------------------------
	-- 	Salva los valores de las dinámicas.
	---------------------------------------------------------------------------------------------------

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
		---------------------------------------------------------------------------------------------------	
		--crea todos los elementos necesarios para poder hacer una simulación.
		---------------------------------------------------------------------------------------------------
		on btnCreateDynamic pressed do
		(
			objs = getCurrentSelection()
			if objs.count == 0 then
			(
				lb.message.show "No Selection." type:#message pos:undefined size:[300,75] modal:true
			)
			else
			(
				createDynamicChain objs
				lb.message.show "Create Dynamic." type:#message pos:undefined size:[300,75] modal:true
			)
		)
		
		---------------------------------------------------------------------------------------------------	
		--Elimina todos los elementos necesarios para poder hacer una simulación.
		---------------------------------------------------------------------------------------------------
		on btnRemoveDynamic pressed do
		(
			objs = getCurrentSelection()
			deleteDynamicChain objs
			lb.message.show "Remove Dynamic." type:#message pos:undefined size:[300,75] modal:true
		)
		
		---------------------------------------------------------------------------------------------------	
		--Gestiona el valor de Spring.
		---------------------------------------------------------------------------------------------------
		on spnSpring changed val do 
		(
			configSpring()
		)
		
		---------------------------------------------------------------------------------------------------	
		--Gestiona el valor de Damper.
		---------------------------------------------------------------------------------------------------
		on spnDampening changed val do 
		(
			configDamper()
		)
		
		---------------------------------------------------------------------------------------------------	
		--Gestiona el valor de gravity.
		---------------------------------------------------------------------------------------------------
		on spnGravity changed val do 
		(
			configGravity()
		)
		
		---------------------------------------------------------------------------------------------------	
		--Anula la gravedad.
		---------------------------------------------------------------------------------------------------
		on chkGravity changed theState do
		(
			noGravity()
		)
		
		---------------------------------------------------------------------------------------------------	
		--seleccion de objetos para ser objetos de colision.
		---------------------------------------------------------------------------------------------------
		on btnAddSelection pressed do
		(
			_obj = getCurrentSelection()
			if _obj.count == 0 then
			(
				lb.message.show "No Selection." type:#message pos:undefined size:[300,75] modal:true
			)
			else
			(
				addColision obj
				lb.message.show "Add Colision Objects." type:#message pos:undefined size:[300,75] modal:true
			)
		)
		
		---------------------------------------------------------------------------------------------------	
		--elimina el modificador que hace que el objeto sea de colision.
		---------------------------------------------------------------------------------------------------
		on btnRemoveColision pressed do
		(
			removeColision obj
			lb.message.show "Remove Colision Object." type:#message pos:undefined size:[300,75] modal:true
		)
		
		---------------------------------------------------------------------------------------------------	
		--Crea el preview de la simulacion.
		---------------------------------------------------------------------------------------------------
		on btnSimulationDynamic pressed do
		(
			PxRunSimulation()
		)
		
		---------------------------------------------------------------------------------------------------	
		--Crea el preview de la simulacion.
		---------------------------------------------------------------------------------------------------
		on btnSimulationDynamic pressed do
		(
			nvpx.SetAnimationState(false)
			PxRunSimulation()
			
			global gSimClock
			state = false
			if gSimClock != undefined then state = gSimClock.Enabled
			nvpx.SetButtonCheck 1003 (state)
		)
		
		---------------------------------------------------------------------------------------------------	
		--resetea la simulacion.
		---------------------------------------------------------------------------------------------------
		on btnResetDynamic pressed do
		(
			PxStopSimulation()
		)
		
		---------------------------------------------------------------------------------------------------	
		--bake la simulacion.
		---------------------------------------------------------------------------------------------------
		on btnBakeDynamic pressed do
		(
			pxBakeSelection false
			lb.message.show "Bake Dynamic." type:#message pos:undefined size:[300,75] modal:true
		)
		
		---------------------------------------------------------------------------------------------------	
		--pausa la simulacion.
		---------------------------------------------------------------------------------------------------
		on btnUnBakeDynamic pressed do
		(
			pxBakeSelection true
			lb.message.show "UnBake Dynamic." type:#message pos:undefined size:[300,75] modal:true
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
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
			createSelectionChangedCallBacks()
			updateToolbarButtons()
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
			removeSelectionChangedCallBacks()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: Spring Solver | Contiene la herramienta dynamic solver.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_dynamicSolver
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
		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.		------------------------------------------------
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
		
	)--tl_dynamic Solver
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_dynamicSolver() --crea la herramienta
)