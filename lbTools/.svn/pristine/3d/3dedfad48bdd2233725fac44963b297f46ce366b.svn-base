------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de utiidades
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: utilities | Contiene todas las funciones de utilidades.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_utilities
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de utilidades",	--@var: description | Descripcion de la libreria.
		
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
		--@fn: array{type} | getBasicDataTypes | Devuelve un array con los tipos de datos básicos del sistema
		------------------------------------------------
		fn getBasicDataTypes =
		(
			#(integer, float, double, integer64, integerPtr, string, name, booleanClass, color, point3, point2, ray, quat, angleaxis, eulerAngles, matrix3, bigMatrix, box2, bitarray, arrayParameter)
		),
		
		------------------------------------------------
		--@fn: array{type} | getTimeDataTypes | Devuelve un array con los tipos de datos de tiempo del sistema
		------------------------------------------------
		fn getTimeDataTypes =
		(
			#(time, interval)
		),
		
		------------------------------------------------
		--@fn: array{type} | getCollectionDataTypes | Devuelve un array con los tipos de datos de colecciones del sistema.
		------------------------------------------------
		fn getCollectionDataTypes =
		(
			#(array, pathname, objectset, selectionSet, selectionSetArray, nodeChildrenArray, vertexSelection, faceSelection, edgeSelection, MAXKeyArray, MAXNoteKeyArray, MAXModifierArray, MaterialLibrary, NURBSSet)
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | reloadScripts | Recarga de nuevo en memoria todas las librerías. Esto es necesario a veces por el orden de evaluación mientras se desarrolla.
		------------------------------------------------
		fn reloadScripts =
		(
			_scriptsFolder = getFileNamePath this.defFile --folder que contiene los scripts
			
			_scriptFiles = lb.io.getFilesFromSubFolders _scriptsFolder extension:"*.ms" --getFiles (_scriptsFolder + "*.ms")
			_scriptFiles += lb.io.getFilesFromSubFolders _scriptsFolder extension:"*.mse" --getFiles (_scriptsFolder + "*.mse")
			
			for _script in _scriptFiles do
			(
				fileIn _script
			)--for
			
			lb.init() --tiene que llamar a la reinicializacion de forma recursiva de todos los scripts
		),
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
			
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
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_utilities
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_utilities() --crea la librería	
)