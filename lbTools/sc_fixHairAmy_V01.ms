------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fixHairAmy_V01
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Fix de pelo de Amy",	--@var: description | Descripcion del script.
		
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
			-- Hueso de pelo de Amy
			_boneHair01 = (execute "$'chr_amy{*}_anim_m_hair-x-bon-01_x_c'")[1]
			_boneHair02 = (execute "$'chr_amy{*}_anim_m_hair-x-bon-02_x_c")[1]
			_boneHair03 = (execute "$'chr_amy{*}_anim_m_hair-x-bon-03_x_c")[1]
			_boneHair04 = (execute "$'chr_amy{*}_anim_m_hair-x-bon-04_x_c")[1]
			_boneHair05 = (execute "$'chr_amy{*}_anim_m_hair-x-bon-05_x_c")[1]
			
			_bonesHair = #(_boneHair01,_boneHair02,_boneHair03,_boneHair04,_boneHair05)
			
			if _boneHair01 != undefined then
			(
				-- Borramos animtracks de coleta si existen.
				for t = _boneHair01.animInfo.trackNames.count to 1 by - 1 where _boneHair01.animInfo.trackNames[t] == "transform:position:Zero_Pos_XYZ:x_position" or _boneHair01.animInfo.trackNames[t] == "transform:position:Zero_Pos_XYZ:y_position" or _boneHair01.animInfo.trackNames[t] == "transform:position:Zero_Pos_XYZ:z_position" do
				(			
					deleteItem _boneHair01.animInfo.trackNames t	
					deleteItem _boneHair01.animInfo.trackIndex t
				)
				
				lockedtracksman.unLockOverride = true
				
				-- Configrado los keyable de nuevo.
				for o in _bonesHair do
				(
					-- Pos
					o[3][1][2][1].controller.keyable = false
					o[3][1][2][2].controller.keyable = false
					o[3][1][2][3].controller.keyable = false
					
					-- Scale
					o[3][3][2][1].controller.keyable = false
					o[3][3][2][2].controller.keyable = false
					o[3][3][2][3].controller.keyable = false
					
					-- Borramos claves de animtracks antiguos.
					deletekeys o[3][1][2].keys
					deletekeys o[3][3][2].keys
					
				)

				lockedtracksman.unLockOverride = false
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
			messageBox "Fix Hair Amy V01 executed"
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
	
	sc_fixHairAmy_V01() --crea el script
)