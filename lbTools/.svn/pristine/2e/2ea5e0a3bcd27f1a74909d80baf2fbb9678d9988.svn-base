------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script de fix para mapas de hair que apuntan a carpetas que no debe.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: fixHairTextureMapsWrongPaths | Contiene el struct del script de fix para mapas de hair que apuntan a carpetas que no debe.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fixHairTextureMapsWrongPaths
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
			setWaitCursor()

			_assets = lb.asset.getSceneAssets()

			for _ast in _assets do
			(
				_bitmaps = #()

				--obtiene las rutas donde apuntan los bitmaps de mapas de materiales y de modificadores
				_matObjects = _ast.meshNodesAll + _ast.hairNodesAll
				for o in _matObjects do _bitmaps += lb.materials.getBitmapPaths o
				for o in _matObjects where o.material != undefined do _bitmaps += lb.materials.getBitmapPaths o.material
				_bitmaps = makeUniqueArray _bitmaps

				--recorre los paths que sean diferentes al del asset
				for _path in _bitmaps where (toLower _path) != (toLower (_ast.folder + lb.nc.NC_textureFolderName + "\\")) do
				(
					for o in _matObjects do lb.materials.redirectMatBitmaps o _path (_ast.folder + lb.nc.NC_textureFolderName + "\\") lower:true
				)--for
			)--for

			setArrowCursor()
			lb.message.show "Wrong asset material and modifiers bitmaps paths redirected successfully."
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
		
	)--sc_fixHairTextureMapsWrongPaths
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_fixHairTextureMapsWrongPaths() --crea el script
)