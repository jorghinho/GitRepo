------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script addCameraNoise.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: addCameraNoise | Contiene el struct del script addCameraNoise.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_addCameraNoise
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Add Camera Noise",	--@var: description | Descripcion del script.
		
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
			$.rotation.controller = rotation_list ()
			$.rotation.controller.Available.controller = Noise_rotation ()
			$.rotation.controller.Noise_Rotation.controller.seed = (random 0 100)
			$.rotation.controller.Noise_Rotation.controller.frequency = 0.03
			$.rotation.controller.Noise_Rotation.controller.fractal = False
			$.rotation.controller.Noise_Rotation.controller.noise_strength = [degtorad(2), degtorad(2), 0]
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
		
	)--sc_addCameraNoise
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_addCameraNoise() --crea el script
)