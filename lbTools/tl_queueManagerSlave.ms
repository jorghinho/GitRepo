------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta de gestion de colas de render. Parte del slave.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Queue Manager Slave"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 400		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 300		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnJobRepository "Job Repository: " pos:[5,5] width:85 height:15
		label lblJobRepository "" pos:[95,5] width:1500

		label lblStatus "Status: IDLE" pos:[7,22] width:1500
		label lblJob "Job: <Waiting For Job>" pos:[7,37] width:1500
		
		dotNetControl rtbLog "System.Windows.Forms.richTextBox" pos:[5,55] width:390 height:240 visible:true

		timer tmrCheckStatus interval:2500 active:true
		
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
		--@fn: undefined | initUI | Inicializa los controles del UI.
		------------------------------------------------
		fn initUi =
		(
			rtbLog.BorderStyle = (dotnetclass "System.Windows.Forms.BorderStyle").None

			rtbLog.BackColor = (dotnetclass "system.drawing.color").fromArgb 40 40 40
			rtbLog.ForeColor = (dotnetclass "system.drawing.color").fromArgb 200 200 200
		)

		------------------------------------------------
		--Actualiza el estado de los controles del interfaz
		------------------------------------------------
		fn updateUI =
		(
			lblJobRepository.text = if doesFileExist parent.jobRepository then parent.jobRepository else ""
			lblStatus.text = toUpper parent.status
			lblJob.text = "<Waiting For Job>"

			if parent.currentJob != undefined then
			(
				_jobXmlDoc = lb.xml.load parent.currentJob.infoFile
				lblJob.text = _jobXmlDoc.getAttribute "job/parameters" "name"
			)--if
		)

		------------------------------------------------
		--Añade una linea al log
		--logLine: String con la nueva linea de log.
		------------------------------------------------
		fn addLog logLine =
		(
			rtbLog.text += logLine + "\n"
			rtbLog.SelectionStart = rtbLog.text.count
			rtbLog.ScrollToCaret()
		)

		------------------------------------------------
		--Lipia el log
		------------------------------------------------
		fn clearLog =
		(
			rtbLog.text = ""
		)

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
				rtbLog.width = 390 + _increment.x
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				rtbLog.height = 240 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena el repositorio
			lb.xml.setAttribute parent.cfgFile ("tool/jobRepository") "path" (parent.jobRepository)

			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--lee el path del repositorio
			_repo = lb.xml.getAttribute parent.cfgFile ("tool/jobRepository") "path"
			if doesFileExist _repo then parent.jobRepository = _repo

			--tamaño
			_width = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/pos") "y") as integer
				
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
		
		------------------------------------------------
		--Establece el repositorio de trabajos.
		------------------------------------------------
		on btnJobRepository pressed do
		(
			_newPath = getSavePath caption:"Job Repository" initialDir:(parent.jobRepository)
			if doesFileExist _newPath then parent.jobRepository = _newPath
			updateUI()
			clearLog()
		)

		------------------------------------------------
		--Busca trabajos que realizar.
		------------------------------------------------
		on tmrCheckStatus tick do
		(
			parent.searchForJob()
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
			initUi()
			updateUI()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
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
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: queueManagerSlave | Contiene la herramienta de gestion de colas de render. Parte del slave.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_queueManagerSlave
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool de gestion de colas de render. Parte del slave",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		jobRepository = "", --repositorio de trabajos
		status = "IDLE", --estado actual del slave
		currentJob = undefined, --trabajo en ejecucion

		waitingJobs = #(), --lista de trabajos esperando a ser ejecutados

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
		--Busca trabajos que realizar.
		------------------------------------------------
		fn searchForJob =
		(
			--solo realiza esta operacion si el estado es IDLE y hay un repositorio de trabajos
			if doesFileExist this.jobRepository then
			(
				if (tolower this.status) == "idle" then
				(
					--obtiene los trabajos en espera
					this.rollMain.addLog "Looking for jobs..."	
					this.waitingJobs = lb.queueManager.getAllJobs this.jobRepository status:"waiting"
					
					--si hay trabajos en espera procesa el primero en cola
					if this.waitingJobs.count != 0 then
					(
						this.rollMain.addLog ((this.waitingJobs.count as string) + " waiting jobs found.")

						--cambia el estado y establece el job actual
						this.status = "PROCESSING"
						this.currentJob = this.waitingJobs[1]

						--actualiza el interfaz con los cambios
						this.rollMain.updateUI()

						--procesa el trabajo actual
						this.processJob() --procesa el trabajo actual
					)--if					
				)
			)
			else
			(
				this.rollMain.addLog "Job repository not defined or not found."
			)--if else
		),

		------------------------------------------------
		--Procesa el trabajo actual
		------------------------------------------------
		fn processJob =
		(
			_success = true
			this.rollMain.tmrCheckStatus.active = false --desactiva el timer temporalmente

			--si hay trabajo que procesar lo hace			
			if this.currentJob != undefined then
			(
				this.rollMain.addLog "\nProcessing job."

				_jobXmlDoc = lb.xml.load this.currentJob.infoFile --lee el documento de informacion del trabajo

				--procesa los parametros basicos
				_name = _jobXmlDoc.getAttribute "job/parameters" "name"
				_status = _jobXmlDoc.getAttribute "job/parameters" "status"
				_save = (_jobXmlDoc.getAttribute "job/parameters" "save") == "true"
				_svnUpdate = (_jobXmlDoc.getAttribute "job/parameters" "svnUpdate") == "true"
				_svnCommit = (_jobXmlDoc.getAttribute "job/parameters" "svnCommit") == "true"

				_file = _jobXmlDoc.getAttribute "job/file" "path"
				if _file[1] == "." then _file = this.currentJob.path + (substring _file 3 _file.count)

				this.rollMain.addLog ("Job name: " + _name)
				this.rollMain.addLog ("Job file: " + _file)

				--si el archivo que procesar existe lo hace
				if doesFileExist _file then
				(
					--establece el estado del trabajo como en proceso
					_jobXmlDoc.setAttribute "job/parameters" "status" "processing"
					_jobXmlDoc.save()

					--obtiene las acciones a aplicar
					_scripts = _jobXmlDoc.getNodes "job/actions/action"

					--si hay acciones las aplica
					if _scripts.count != 0 then
					(
						------------------------------------------------
						--si se pide que se actualice el archivo antes
						if _svnUpdate then
						(
							try
							(
								this.rollMain.addLog "Trying to update file."
								DOSCommand ("svn update " + _file)
							)
							catch()
						)--if
						------------------------------------------------

						------------------------------------------------
						--si se pide salvar, antes hay que quitar el flag de readonly del archivo
						_readOnlyBckp = getFileAttribute _file #readOnly
						if _save then
						(
							this.rollMain.addLog "Setting readonly to false."
							setFileAttribute _file #readOnly false
						)--if
						------------------------------------------------

						this.rollMain.addLog "Opening file..."

						--abre el archivo donde aplicar las acciones
						_opened = loadMaxFile _file useFileUnits:true quiet:true

						--solo si consigue abrirlo
						if _opened then
						(
							this.rollMain.addLog "File successfully opened."
							this.rollMain.addLog ((_scripts.count as string) + " actions to complete found.")

							--recorre las acciones aplicandolas
							for _sc in _scripts do
							(
								--obtiene el script de la accion
								_scName = (_sc.getProperty "name")
								_scToRun = undefined
								_scToRun = lb.getScript _scName
								
								--solo si el script existe lo ejecuta								
								if _scToRun != undefined then
								(
									this.rollMain.addLog ("Running action '" + _scName + "'.")

									--modo debug para que salten los errores
									if lb.developerModeOn then 
									(
										_scToRun.run() --ejecuta el script
									)
									else --en modo normal impide que falle el slave
									(
										try
										(
											_scToRun.run() --ejecuta el script
										)
										catch
										(
											_success = false
											this.rollMain.addLog ("Action '" + _scName + "'' got an error.")
										)
									)--if else
								)
								else
								(
									_success = false
									this.rollMain.addLog ("Action '" + _scName + "'' not found.")
								)--if else
							)--for

							--si ha tenido exito en la ejecucion
							if _success then
							(
								_saved = false

								if _save then
								(
									this.rollMain.addLog "Saving file with changes"
									_saved = saveMaxFile _file clearNeedSaveFlag:true useNewFile:true quiet:true
								)--if

								if _svnCommit and _saved then
								(
									try
									(
										this.rollMain.addLog "Trying to commit file."
										DOSCommand ("svn commit --message \"queueManager Job\" " + _file)
									)
									catch()
								)--if
							)--if
						)
						else
						(
							_success = false
							this.rollMain.addLog "File could not be opened."
						)--if else

						--vuelve a dejar el estado de readonly como estaba
						if _save then
						(
							this.rollMain.addLog "Setting readonly to original state."
							setFileAttribute _file #readOnly _readOnlyBckp
						)
					)
					else
					(
						_success = false
						this.rollMain.addLog "No actions to complete found."
					)--if else
				)
				else
				(
					_success = false
					this.rollMain.addLog ("File to precess does not exist: " + _file)
				)--if else
			)
			else
			(
				_success = false
				this.rollMain.addLog "No job found."
			)--if else

			--almacena en el trabajo si se ha completado correctamente o no
			if not _success then
			(
				_jobXmlDoc.setAttribute "job/parameters" "status" "error"
				_jobXmlDoc.save()
			)
			else
			(
				this.rollMain.addLog ("Job completed successfully.")
				_jobXmlDoc.setAttribute "job/parameters" "status" "completed"
				_jobXmlDoc.save()
			)

			this.rollMain.addLog ""

			--al final deja el estado en IDLE de nuevo para que siga procesando trabajos
			this.currentJob = undefined
			this.status = "IDLE"
			this.rollMain.updateUI()

			resetMaxFile(#noPrompt) --limpia la escena
			gc() --limpia la memoria
			this.rollMain.tmrCheckStatus.active = true --activa el timer de nuevo
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
		------------------------------------------------
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
			createDialog this.rollMain lockwidth:false lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_queueManagerSlave
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_queueManagerSlave() --crea la herramienta
)