------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de plantilla
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: log | Contiene la libreria de plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_log
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria plantilla",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		types = #(#all, #info, #ok, #warning, #error, #sep), --@var: types | Almacena los tipos de log que pueden existir.
		typesTags = #("All", "Info", "Ok", "Warning", "Error", "Sep"), --@var: typesTags | Almacena las etiquetas de los tipos de log que pueden existir.
		
		timeOptions = #(#current, #today, #week, #all), --@var: timeOptions | Almacena las opciones de tiempo que se pueden elegir.
		timeOptionsTags = #("Current", "Today", "Week", "All"), --@var: timeOptions | Almacena las etiquetas de las opciones de tiempo que se pueden elegir.
		
		transactionLogFile = undefined, --@var: transactionLogFile | Documento xml de log ara las transacciones.
		
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
		--@fn: string | getCurrentLogFile | Devuelve la ruta del archivo de logs del dia actual.
		------------------------------------------------
		fn getCurrentLogFile =
		(
			_logPath = lb.config.getLogPath()
			
			_today = (filterString localTime " ")[1]
			_todayParts = filterString _today "/"
			
			_logPath = _logPath + (_todayParts[3] + "-" + _todayParts[2] + "-" + _todayParts[1]) + ".log"
			
			_logPath
		),
			
		------------------------------------------------
		--@fn: array{string} | getWeekLogFiles | Devuelve los archivos de log del dia actual y los seis dias anteriores.
		------------------------------------------------
		fn getWeekLogFiles =
		(
			_weekLogFiles = #()
			
			_allLogFiles = getFiles (lb.config.getLogPath() + "*.log")
			
			------------------------------------------------
			if _allLogFiles.count < 8 then _weekLogFiles = _allLogFiles
			else _weekLogFiles = for i=(_allLogFiles.count - 6) to _allLogFiles.count collect _allLogFiles[i]			
			------------------------------------------------	
			
			_weekLogFiles
		),
		
		------------------------------------------------
		--@fn: array{string} | getAllLogFiles | Devuelve todos los archivos de log existentes.
		------------------------------------------------
		fn getAllLogFiles =
		(
			(getFiles (lb.config.getLogPath() + "*.log"))
		),
		
		------------------------------------------------
		--@fn: string | findNextLogById | Devuelve el indice del primer log que tenga un id posterior al indicado. Devuelve 0 si no lo encuentra o si es posterior al ultimo id
		--@gets: array{log} | logsArray | Array de logs donde buscar.
		--@gets: string | timeId | Id de tiempo que buscar.
		------------------------------------------------
		fn findNextLogById logsArray timeId =
		(
			_index = 0
			
			_ids = for _log in logsArray collect (_log.getProperty "id") --obtiene todos los ids del array de logs
			
			_limit = _ids.count --numero de ids antes de añadir el solicitado
			_ids += #(timeId) --añade el solicitado
			sort _ids --lo ordena
			
			_index = findItem _ids timeId --busca el solicitado
			if _index > _limit then _index = 0 --si es posterior al limie
			
			_index
		),
		
		------------------------------------------------
		--@fn: string | getLogs | Devuelve los logs que cumplen las condiciones.
		--@opt: name | sender | #all | Opcion para indicar los logs de que herramienta mostrar.
		--@opt: name | type | #all | Opcion para indicar los logs de que tipo mostrar.
		--@opt: name | timeOption | #current | Opcion para indicar el periodo de tiempo de logs que mostrar.
		--@opt: string | refTimeId | undefined | Id de referencia a partir del cual obtener los ids.
		------------------------------------------------
		fn getLogs sender:#all type:#all timeOption:#current refTimeId:undefined =
		(
			_logs = #() --array de logs
			
			case timeOption of
			(
				#current:
				(
					_logPath = this.getCurrentLogFile() --path de los log
					
					if doesFileExist _logPath then
					(
						_logDoc = lb.xml.load _logPath makeFile:true --abre el xml del log
						_rootNode = _logDoc.getRoot() --obtiene el root del documento
						
						_tmpLogs = _rootNode.getNodes "logs/log" --obtiene todos los logs del archivo
						
						if refTimeId != undefined then --si se ha pasado un tiempo de referencia a partir del cual mostrar los logs
						(
							_idIndex = this.findNextLogById _tmpLogs refTimeId
							
							if _idIndex != 0 then
							(
								for i=_idIndex to _tmpLogs.count do
								(
									_type = (_tmpLogs[i].getProperty "type")
									_sender = (_tmpLogs[i].getProperty "sender")
									if (type==#all or (type as string)==_type) and (sender==#all or (sender as string)==_sender) then append _logs _tmpLogs[i]
								)--for
							)--if
						)--if
					)--if						
				)--current
				
				#today:
				(
					_logPath = this.getCurrentLogFile() --path de los log
					
					if doesFileExist _logPath then
					(
						_logDoc = lb.xml.load _logPath makeFile:true --abre el xml del log
						_rootNode = _logDoc.getRoot() --obtiene el root del documento
						
						_tmpLogs = _rootNode.getNodes "logs/log" --obtiene todos los logs del archivo
						for i=1 to _tmpLogs.count do
						(
							_type = (_tmpLogs[i].getProperty "type")
							_sender = (_tmpLogs[i].getProperty "sender")
							if (type==#all or (type as string)==_type) and (sender==#all or (sender as string)==_sender) then append _logs _tmpLogs[i]
						)--for
					)--if
				)--today
				
				#week:
				(
					_weekLogFiles = this.getWeekLogFiles()
					
					for _logPath in _weekLogFiles do
					(
						_logDoc = lb.xml.load _logPath --abre el xml del log
						_rootNode = _logDoc.getRoot() --obtiene el root del documento
						
						_tmpLogs = _rootNode.getNodes "logs/log" --obtiene todos los logs del archivo
						for i=1 to _tmpLogs.count do
						(
							_type = (_tmpLogs[i].getProperty "type")
							_sender = (_tmpLogs[i].getProperty "sender")
							if (type==#all or (type as string)==_type) and (sender==#all or (sender as string)==_sender) then append _logs _tmpLogs[i]
						)--for
					)--for
				)--week
				
				#all:
				(
					_allLogFiles = this.getAllLogFiles()
					
					for _logPath in _allLogFiles do
					(
						_logDoc = lb.xml.load _logPath --abre el xml del log
						_rootNode = _logDoc.getRoot() --obtiene el root del documento
						
						_tmpLogs = _rootNode.getNodes "logs/log" --obtiene todos los logs del archivo
						for i=1 to _tmpLogs.count do
						(
							_type = (_tmpLogs[i].getProperty "type")
							_sender = (_tmpLogs[i].getProperty "sender")
							if (type==#all or (type as string)==_type) and (sender==#all or (sender as string)==_sender) then append _logs _tmpLogs[i]
						)--for
					)--for
				)--all
			)--case
			
			_logs
		),
		
		------------------------------------------------
		--@fn: string | getAllSenders | Devuelve todos los senders diferentes de los logs
		------------------------------------------------
		fn getAllSenders =
		(
			_allLogs = this.getLogs timeOption:#all
			_senders = for _log in _allLogs collect _log.getProperty "sender"
			_senders = #("All") + (makeUniqueArray _senders)
			
			_senders
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | add | Añade una nueva linea al log.
		--@opt: string | sender | "unknown" | Indica quien ha guardado el log.
		--@opt: name | type | #all | Tipo de log que se guarda.
		--@opt: integer | level | 1 | Indica el nivel de profundidad.
		--@opt: bollean | forceOpen | false | Indica si forzar a que se abra la herramienta de logs.
		------------------------------------------------
		fn add logText sender:"unknown" type:#info level:1 forceOpen:false =
		(
			_logPath = this.getCurrentLogFile() --path de los log
			
			_logDoc = if this.transactionLogFile != undefined then this.transactionLogFile else lb.xml.load _logPath makeFile:true --abre el xml del log
			_rootNode = _logDoc.getRoot() --obtiene el root del documento
			
			if (_rootNode.getChildren()).count == 0 then
			(
				_logsNode = _rootNode.newChild "logs" --si no hay apartado de logs lo añade
				_logsNode.setProperty "date" (filterString localTime " ")[1]
			)--if
			
			_logsNode = _rootNode.getNode "logs" --obtiene el nodo de logs para añadirle otro
			
			_newLog = _logsNode.newChild "log" --crea una nueva entrada de log
			_newLog.setProperty "id" (lb.time.getCurrentTimeId())
			_newLog.setProperty "time" localTime
			_newLog.setProperty "type" (type as string)
			_newLog.setProperty "sender" sender
				
			for i=1 to (level-1) do logText = "    " + logText
			_newLog.setText logText --añade el texto al log
			
			if this.transactionLogFile == undefined then _logDoc.save()
			
			if lb.logManager.isOpen() or forceOpen then
			(
				if not lb.logManager.isOpen() and forceOpen then lb.logManager.run()
				if lb.logManager.isOpen() then lb.logManager.update log:_newLog --llama a actuaizar la herramienta de logs					
			)--if
		),
		
		------------------------------------------------
		--@fn: boolean | beginTransaction | Inicia un ciclo de operaciones de escritura de log.
		------------------------------------------------
		fn beginTransaction =
		(
			_success = false
			
			if this.transactionLogFile == undefined then
			(
				_logPath = this.getCurrentLogFile() --path de los log
				this.transactionLogFile = lb.xml.load _logPath makeFile:true --abre el xml del log
				if this.transactionLogFile != undefined then _success = true
			)--if
				
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | commit | Salva los cambios hechos al log.
		------------------------------------------------
		fn commit =
		(
			_success = false
			
			if this.transactionLogFile != undefined then
			(
				this.transactionLogFile.save()
				this.transactionLogFile = undefined
				if this.transactionLogFile == undefined then _success = true
			)--if			
				
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | rollback | Descarta los cambios hechos al log.
		------------------------------------------------
		fn rollback =
		(
			_success = false
			
			this.transactionLogFile = undefined
			if this.transactionLogFile == undefined then _success = true
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | removeLogFiles | Elimina los archivos de logs.
		------------------------------------------------
		fn removeLogFiles =
		(
			_logFiles = this.getAllLogFiles()
			
			for i=_logFiles.count to 1 by -1 do deleteFile _logFiles[i]
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
		
	)--lib_log
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_log() --crea la libreria
	
	ok
)