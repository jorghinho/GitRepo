------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Librería de funciones de sistema
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: system | Contiene las funciones de sistema
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_system
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de funciones de sistema",	--@var: description | Descripcion de la libreria.
		
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
		--@fn: array{strProcess} | getSystemProcessList | Mata un proceso de sistema a través de su ID. Devuelve un array de structs de procesos con toda su información.
		--@opt: boolean | id | false | Indica si hay que devolver los identificadores de cada proceso.
		--@opt: boolean | caption | true | Indica si hay que devolver los nombres de cada proceso.
		--@opt: boolean | commandLine | false | Indica si hay que devolver las rutas de los ejecutables de cada proceso.
		------------------------------------------------
		fn getSystemProcessList id:false caption:true commandLine:false =
		(
			struct strProcess
			(
				id = undefined,
				caption = undefined,
				commandLine = undefined
			)
			
			_processList = #()
			_idList = #()
			_fileNamesToProcess = #()
			_processIdFileName = "processIdList.txt"
			_processCaptionFileName = "processCaptionList.txt"
			_processCommandLineFileName = "processCommandLineList.txt"
			
			if id then (HiddenDOSCommand ("WMIC /OUTPUT:\"" + _processIdFileName +  "\" PROCESS get processId"); append _fileNamesToProcess _processIdFileName)
			if caption then (HiddenDOSCommand ("WMIC /OUTPUT:\"" + _processCaptionFileName +  "\" PROCESS get caption"); append _fileNamesToProcess _processCaptionFileName)
			if commandLine then (HiddenDOSCommand ("WMIC /OUTPUT:\"" + _processCommandLineFileName +  "\" PROCESS get commandLine"); append _fileNamesToProcess _processCommandLineFileName)
			
			for i = 1 to _fileNamesToProcess.count do
			(
				_fileName = _fileNamesToProcess[i]
				_fileLines = ((dotNetClass "System.IO.File").ReadAllLines _fileName)
				
				deleteItem _fileLines 1	-- la primera línea es una cabecera. La eliminamos
				
				for j = 1 to _fileLines.count do
				(
					_process = if i == 1 then strProcess() else _processList[j]
					_line = _fileLines[j]
					
					case _fileName of 
					(
						_processIdFileName: _process.id = execute _line
						_processCaptionFileName: _process.caption = _line
						_processCommandLineFileName: _process.commandLine=  _line
					)
					
					_processList[j] = _process
				)
				
				deleteFile _fileName
			)
			
			_processList
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | taskKillById | Mata un proceso de sistema a través de su ID.
		--@gets: string | processId | Identificador del proceso a eliminar.
		------------------------------------------------
		mapped fn taskKillById processId =
		(
			hiddenDOSCommand ("taskKill /PID " + (processId as string))
		),
		
		------------------------------------------------
		--@fn: undefined | taskKillByName | Mata un proceso de sistema a través del nombre de su ejecutable.
		--@gets: string | processName | Nombre del proceso a eliminar.
		------------------------------------------------
		mapped fn taskKillByName processName =
		(
			hiddenDOSCommand ("taskKill /IM " + processName)
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
		
	)--lib_system
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_system() --crea la libreria	
)

