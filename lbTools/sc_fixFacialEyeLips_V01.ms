------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fixFacialEyeLips_V01
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Script plantilla",	--@var: description | Descripcion del script.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@fn: undefined | fixRigV01 | Ejecuta el script.
		------------------------------------------------	
		fn fix =
		(
			_assets = lb.asset.getSceneAssets()
			
			-- Obtenemos todos los asset y los recorremos buscando la pieza clave, si no existe se crea el sistema, y asi evitamos duplicarlo.
			for ast in _assets do
			(
				-- Activamos las capa del pesonaje.
				lb.layer.activeLayer ast.name
				
				_found = false
				_facialRoot = undefined
				
				-- Título de animtracks y separador vacio.
				_sepTransform = #(#(#separator, "Separator01", false, "Transform"))	
				_sep = #(#(#separator, "Separator01", false, ""))
					
				-- Variables para capturar los controles de párpados.
				_eldLowerExt = #()
				_eldLowerInt = #()
				_eldUpperExt = #()
				_eldUpperInt = #()
				_eldUpper = #()
				_eldLower = #()
				
				-- Busqueda de objeto en nodos de facial.
				for o in ast.facialNodesAll do
				(
					_sidePart = lb.nc.getNamePart o.name 4
					_namePart = lb.nc.getNamePart o.name 5
					
					if (matchPattern _namePart pattern:"eyeLips-root") then
						_found = true
					
					if (matchPattern _namePart pattern:"root") then
						_facialRoot = o
					
					-- Controles de párpados.
					if (matchPattern _namePart pattern:"eld-lowerExt") then
						append _eldLowerExt o
					
					if (matchPattern _namePart pattern:"eld-lowerInt") then
						append _eldLowerInt o
					
					if (matchPattern _namePart pattern:"eld-upperExt") then
						append _eldUpperExt o
					
					if (matchPattern _namePart pattern:"eld-upperInt") then
						append _eldUpperInt o					
					
					if (matchPattern _namePart pattern:"eld-upper") then
						append _eldUpper o

					if (matchPattern _namePart pattern:"eld-lower") then
						append _eldLower o		
					
				)	
				
				-- Si no lo encuentra creamos el sistema.
				if not _found and _facialRoot != undefined then
				(
					-- ROOT--
					_eyeLipsRoot = rectangle length:1 width:10 cornerRadius:0 transform:_facialRoot.transform wirecolor:black
					_eyeLipsRoot.name = _facialRoot.name 
					_eyeLipsRoot.name = lb.nc.replaceNamePart _eyeLipsRoot.name 5 "eyeLips-root"
					
					_eyeLipsRoot.parent = _facialRoot
					
					-- Ajustamos la posición final del objeto.
					lb.controller.freezeTransform _eyeLipsRoot #all
					
					_eyeLipsRoot.position.controller[2].x_position = 20
					_eyeLipsRoot.position.controller[2].z_position = 5
					
					lb.controller.freezeTransform _eyeLipsRoot #all
					
					-- Rotamos con xForm para no variar rot de pivote
					addModifier _eyeLipsRoot (xForm())
					_eyeLipsRoot.modifiers[#XForm].gizmo.rotation += quat 0.707107 0 0 0.707107
						
					collapseStack _eyeLipsRoot
					
					-- Creación de animtracks
					lb.animInfo.setAnimTracks _eyeLipsRoot _sep
					setTransformLockFlags _eyeLipsRoot #all 	 
						
					-- TITULO --
					_eyeLipsTitle = text size:3.2 kerning:0 leading:0 transform:_eyeLipsRoot.transform wirecolor:black	
					_eyeLipsTitle.name = _facialRoot.name 
					_eyeLipsTitle.name = lb.nc.replaceNamePart _eyeLipsTitle.name 5 "eyeLips-title"	
					
					_eyeLipsTitle.parent = _eyeLipsRoot
					_eyeLipsTitle.text = "EyeLips"						
						
					-- Ajustamos la posición final del objeto.
					lb.controller.freezeTransform _eyeLipsTitle #all
						
					-- Rotamos con xForm para no variar rot de pivote
					addModifier _eyeLipsTitle (xForm())
					_eyeLipsTitle.modifiers[#XForm].gizmo.rotation += quat 0.707107 0 0 0.707107
					collapseStack _eyeLipsTitle

					_eyeLipsTitle.position.controller[2].z_position = 1.2
						
					lb.controller.freezeTransform _eyeLipsTitle #all
					
					-- Creación de animtracks
					lb.animInfo.setAnimTracks _eyeLipsTitle _sep
					setTransformLockFlags _eyeLipsTitle #all 					
						
					-- Circulo de control _
					_shpControl = Circle radius:0.8 transform:_eyeLipsRoot.transform wirecolor:yellow	
					_shpControl.name = _facialRoot.name 
					_shpControl.name = lb.nc.replaceNamePart _shpControl.name 5 "eyeLips-switch"	
						
					_shpControl.parent = _eyeLipsRoot	
						
					lb.controller.freezeTransform _shpControl #all	
						
					-- Rotamos con xForm para no variar rot de pivote
					addModifier _shpControl (xForm())
					_shpControl.modifiers[#XForm].gizmo.rotation += quat 0.707107 0 0 0.707107
					collapseStack _shpControl	
					
					-- Ajustamos posición correcta por defecto.	
					lb.controller.freezeTransform _shpControl #all
						
					_shpControl.position.controller[2].x_position = -5

					lb.controller.freezeTransform _shpControl #all		
						
					_shpControl.position.controller[2].x_position = 10

					-- Añadimos los limites.
					_shpControl.position.controller[#Zero_pos_xyz].controller.x_position.controller = float_limit()
					_shpControl.position.controller[#Zero_pos_xyz].controller.x_position.controller.lower_limit = 0
					_shpControl.position.controller[#Zero_pos_xyz].controller.x_position.controller.upper_limit = 10
					
					-- Creación de animtracks
					lb.animInfo.setAnimTracks _shpControl (_sepTransform + (lb.rig.solutions.prepareAnimTracks _shpControl.position.controller[#Zero_pos_xyz] #x))		
					setTransformLockFlags _shpControl #{2..9}	
					
					-- Solo lo mostramos si está en modo P+H			
					if lb.asset.getAssetVisMode ast != "P+H" then
					(
						_eyeLipsRoot.isHidden = true
						_eyeLipsTitle.isHidden = true
						_shpControl.isHidden = true
					)
						
					-- Configuración de propiedades
					_eyeLipsObjs = #(_eyeLipsRoot, _eyeLipsTitle, _shpControl)
					
					_eyeLipsObjs.showFrozenInGray = false
					_eyeLipsObjs.renderable = false
					_eyeLipsObjs.steps = 2
					_eyeLipsObjs.optimize = false
					
					-- Generación de ObjectSets
					lb.objectSets.add _shpControl ("chr_" + ast.name + "_facial_mask")
					lb.objectSets.add #(_eyeLipsRoot, _eyeLipsTitle) ("chr_" + ast.name + "_facial_root")
					
					-- Modificación de expressión para ajustar porcentaje de párpados.
					for o in _eldLowerExt do
					(
						_sidePart = lb.nc.getNamePart o.name 4
						
						if _sidePart == lb.nc.NC_locationLeft then
						(
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "(if (eldUpperPosZ < 0, ((((eyeRotZ + lookAtRotLocalZ)) * mult) * (1 - eldUpperPosZ)), ((((eyeRotZ + lookAtRotLocalZ)) * mult) / (1 + eldUpperPosZ))))*(switch/10)"
						)
						else
						(
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "(if (eldUpperPosZ < 0, (((-(eyeRotZ + lookAtRotLocalZ)) * mult) * (1 - eldUpperPosZ)), (((-(eyeRotZ + lookAtRotLocalZ)) * mult) / (1 + eldUpperPosZ))))*(switch/10)"
						)
					)

					-- Modificación de expressión para ajustar porcentaje de párpados.
					for o in _eldLowerInt do
					(
						_sidePart = lb.nc.getNamePart o.name 4
						
						if _sidePart == lb.nc.NC_locationLeft then
						(
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "(if (eldUpperPosZ < 0, (((-(eyeRotZ + lookAtRotLocalZ)) * mult) * (1 - eldUpperPosZ)), (((-(eyeRotZ + lookAtRotLocalZ)) * mult) / (1 + eldUpperPosZ))))*(switch/10)"

						)
						else
						(
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "(if (eldUpperPosZ < 0, ((((eyeRotZ + lookAtRotLocalZ)) * mult) * (1 - eldUpperPosZ)), ((((eyeRotZ + lookAtRotLocalZ)) * mult) / (1 + eldUpperPosZ))))*(switch/10)"
						)
					)	

					-- Modificación de expressión para ajustar porcentaje de párpados.
					for o in _eldUpperExt do
					(
						_sidePart = lb.nc.getNamePart o.name 4
						
						if _sidePart == lb.nc.NC_locationLeft then
						(
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "(if (eldUpperPosZ < 0, ((((eyeRotZ + lookAtRotLocalZ)) * mult) * (1 - eldUpperPosZ)), ((((eyeRotZ + lookAtRotLocalZ)) * mult) / (1 + eldUpperPosZ))))*(switch/10)"
						)
						else
						(
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "(if (eldUpperPosZ < 0, (((-(eyeRotZ + lookAtRotLocalZ)) * mult) * (1 - eldUpperPosZ)), (((-(eyeRotZ + lookAtRotLocalZ)) * mult) / (1 + eldUpperPosZ))))*(switch/10)"
						)
					)
					
					-- Modificación de expressión para ajustar porcentaje de párpados.
					for o in _eldUpperInt do
					(
						_sidePart = lb.nc.getNamePart o.name 4
						
						if _sidePart == lb.nc.NC_locationLeft then
						(
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "(if (eldUpperPosZ < 0, (((-(eyeRotZ + lookAtRotLocalZ)) * mult) * (1 - eldUpperPosZ)), (((-(eyeRotZ + lookAtRotLocalZ)) * mult) / (1 + eldUpperPosZ))))*(switch/10)"
						)
						else
						(
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
							o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "(if (eldUpperPosZ < 0, ((((eyeRotZ + lookAtRotLocalZ)) * mult) * (1 - eldUpperPosZ)), ((((eyeRotZ + lookAtRotLocalZ)) * mult) / (1 + eldUpperPosZ))))*(switch/10)"
						)
					)					
					
					-- Modificación de expressión para ajustar porcentaje de párpados.
					for o in _eldLower do
					(
						o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
						o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
						o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "((eyeRotX + lookAtRotLocalX) * mult)*(switch/10)"
					)
					
					-- Modificación de expressión para ajustar porcentaje de párpados.
					for o in _eldUpper do
					(
						o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression 
						o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.AddScalarTarget "switch" _shpControl.position.controller[#Zero_pos_xyz].x_position.controller
						o.position.controller[#Zero_pos_xyz].controller.z_position.controller[#float_expression].controller.setExpression "((((-(eyeRotX + lookAtRotLocalX)) * mult)))*(switch/10)"

					)
					
					print ("Creado sistema de eyelips en asset " + ast.fullname)
					print "__________________________________________"
				)
				else
				(
					print ("El asset " + ast.fullname + " ya tiene sistema eyeLips o no se puede crear")				
					print "__________________________________________"
				)
			)
			
			(layerManager.getLayer 0).current = true
		),			
			
			
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
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(		
			this.fix()
			
			--ejecución del script
			messageBox "Fix Facial EyeLips V01 executed"
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
			lb.addScript this --añade el script a la libreria principal
		)
		
	)--sc_templateScript
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_fixFacialEyeLips_V01() --crea el script
)