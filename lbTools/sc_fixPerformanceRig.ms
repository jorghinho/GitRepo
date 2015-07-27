------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fixPerformanceRig_V01
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
			-- Obtetos para arreglar el rendimiento
			_objectTongue = execute "$'chr_*_facial_m_tongue??-shp_x_*"
			
			_sepTransform = #(#(#separator, "Separator01", false, "Transform"))
			_sep = #(#(#separator, "Separator01", false, ""))
			

			for o in _objectTongue do
			(
				o.scale.controller[#Zero_Scale_XYZ].x_scale.controller = bezier_float()
				o.scale.controller[#Zero_Scale_XYZ].y_scale.controller = bezier_float()
				o.scale.controller[#Zero_Scale_XYZ].z_scale.controller = bezier_float()
				
				lb.animInfo.setAnimTracks o (_sepTransform + (lb.rig.solutions.prepareAnimTracks o.position.controller[#Zero_Pos_XYZ] #all ) + _sep + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_Euler_XYZ] #all ) + _sep + (lb.rig.solutions.prepareAnimTracks o.scale.controller[#Zero_Scale_XYZ] #all )) 
			)

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
			messageBox "Fix Performance Rig V01"
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
	
	sc_fixPerformanceRig_V01() --crea el script
)