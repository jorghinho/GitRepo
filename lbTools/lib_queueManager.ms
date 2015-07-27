------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de gestion de colas de proceso
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: queueManager | Contiene la libreria de gestion de colas de proceso.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_queueManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de gestion de colas de proceso",	--@var: description | Descripcion de la libreria.
		
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
		--Devuelve todos los trabajos del respositorio en un array de strcts.
		--Si se le indica un status devuelve solo los de ese estado. Estados: "waiting", "processing", "completed", "error"
		------------------------------------------------
		fn getAllJobs jobRepository status:undefined =
		(
			_jobs = #()

			------------------------------------------------
			--struct de cada job			
			struct _jobInfo
			(
				id = "",
				path = "",
				infoFile = ""
			)
			------------------------------------------------

			------------------------------------------------
			--busqueda de trabajos

			if doesFileExist jobRepository then
			(
				--crea si no existe el path de los trabajos
				_jobsPath = jobRepository + "\\jobs\\"
				makeDir _jobsPath

				--obtiene los trabajos y los procesa
				_jobsPaths = getDirectories (_jobsPath + "*")
				for _jobPath in _jobsPaths do
				(
					_jobParts = FilterString _jobPath "\\"

					_newJob = _jobInfo id:(_jobParts[_jobParts.count]) path:_jobPath infoFile:(_jobPath + "jobInfo.xml")
					
					--si se solicita un estado especial de los trabajos se filtra, si no se almacenan todos
					if status != undefined then
					(
						_jobXmlDoc = lb.xml.load _newJob.infoFile
						_status = _jobXmlDoc.getAttribute "job/parameters" "status"
						if (tolower _status) == (tolower status) then append _jobs _newJob
					)
					else append _jobs _newJob
				)--for
			)--if
			------------------------------------------------

			_jobs --devuelve los trabajos
		),

		------------------------------------------------
		--Crea un nuevo trabajo.
		--jobName: String con el nombre del trabajo.
		--repositoryPath: String con el path del repositorio de trabajos.
		--fileName: String con el path del archivo en el que realizar el trabajo.
		--actions: Array de strings con las acciones a realizar
		--status: String con el estado inicial del trabajo. Por defecto "waiting" pero si se le pasa "paused" el trabajo no inicia hasta que se le ponga en estado "waiting".
		--save: Booleano por defecto a false que indica si salvar los cambios en el archivo del trabajo.
		--svnUpdate: Booleano por defecto a false que indica si hacer update del archivo antes de aplicar las acciones.
		--svnCommit: Booleano por defecto a false que indica si hacer commit del archivo una vez aplicadas las acciones y salvado.
		------------------------------------------------
		fn newJob jobName repositoryPath fileName actions status:"waiting" save:false svnUpdate:false svnCommit:false =
		(
			_success = false

			if doesFileExist repositoryPath then
			(
				_newJobPath = repositoryPath + "\\jobs\\" + (lb.time.getCurrentTimeId()) + "-" + jobName + "\\"
				makeDir _newJobPath

				_jobInfoDoc = lb.xml.new (_newJobPath + "jobInfo.xml")
				_jobInfoRoot = _jobInfoDoc.getRoot()

				_jobNode = _jobInfoRoot.newChild "job"

				_jobParams = _jobNode.newChild "parameters"
				_jobParams.setProperty "name" jobName
				_jobParams.setProperty "status" status
				_jobParams.setProperty "save" save
				_jobParams.setProperty "svnUpdate" lb.svn.svnUpdate
				_jobParams.setProperty "svnCommit" lb.svn.svnCommit

				_jobFile = _jobNode.newChild "file"
				_jobFile.setProperty "path" fileName

				_jobActions = _jobNode.newChild "actions"
				for _act in actions do
				(
					_jobAction = _jobActions.newChild "action"
					_jobAction.setProperty "name" _act
				)--for

				_jobInfoDoc.save()
				_success = true
			)--if		

			_success
		),

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
		
	)--lib_queueManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_queueManager() --crea la libreria
)