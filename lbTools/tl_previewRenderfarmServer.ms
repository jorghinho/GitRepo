------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Preview Renderfarm Server"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 345		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 250		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local serverTimer = dotNetObject "System.Windows.Forms.Timer" --crear un Timer
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--@control | controlName | Plantilla de comentario para controles
		label labStatus "Status" offset:[0,0] across:2 align:#left
		editText edtStatus "" text:lb.previewRenderfarm.SERVER_IDLE readOnly:true width:250 offset:[0,0]
		label labJobId "Job ID" offset:[0,0] across:2 align:#left
		editText edtJobId "" caption:"" readOnly:true width:250
		label labFilename "Filename" offset:[0,0] across:2 align:#left
		editText edtFilename "" caption:"" readOnly:true offset:[0,0] width:250
		label labSender "Sender" offset:[0,0] across:2 align:#left
		editText edtSender "" caption:"" readOnly:true offset:[0,0] width:250
		label labCameras "Cameras"  offset:[0,0] across:2 align:#left
		editText edtCameras "" caption:"" readOnly:true offset:[0,0] width:250
		label labCurrentCamera "Current cam"  offset:[0,0] across:2 align:#left
		editText edtCurrentCamera "" caption:"" readOnly:true width:85
		editText edtFrameRange "" caption:"" readOnly:true offset:[182,-22] width:165 align:#right 
		label labProgress "Progress" offset:[0,5] align:#left 
		progressBar pbProgress height:5 width:318
		checkButton ckbStartStop "Stop preview server" width:318 height:40 highlightColor:(color 20 100 40) align:#left offset:[0,20]
		
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		fn timerTick = (if not parent.serverIsRendering then parent.checkForJobs())
		
		fn createTimer =
		(
			dotnet.addEventHandler serverTimer "tick" timerTick --add ON TICK event hander to call the function
			serverTimer.interval = 10000 --set the tick interval to 10 seconds
		)
		
		fn startTimer = 
		(
			serverTimer.start()
			ckbStartStop.text = "Stop preview server"
		)
		
		fn stopTimer = 
		(
			serverTimer.stop()
			ckbStartStop.text = "Start preview server"
		)
		
		fn updateStatus status:undefined jobId:undefined filename:undefined currentCamera:undefined frameRange:undefined cams:undefined progress:undefined sender:undefined =
		(
			if status != undefined do edtStatus.text = status
			if jobId != undefined do edtJobId.text = jobId
			if filename != undefined do edtFilename.text = filename
			if currentCamera != undefined do edtCurrentCamera.text = currentCamera
			if cams != undefined do edtCameras.text = cams
			if sender != undefined do edtSender.text = sender
			if progress != undefined do pbProgress.value = progress
			if frameRange != undefined do
			(
				if (classOf frameRange) == Array then 
				(
					edtFrameRange.text = (frameRange[1] as integer) as string+" - "+(frameRange[2] as integer) as string+" ("+(frameRange[2] as integer-frameRange[1] as integer) as string+" frames)"
				) else
				(
					edtFrameRange.text = frameRange
				)
			)
		)
		
		fn clearStatus =
		(
			updateStatus status:lb.previewRenderfarm.SERVER_IDLE jobId:"" filename:"" currentCamera:"" frameRange:"" cams:"" progress:0 sender:""
		)
		
		
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
		--COMMON
		------------------------------------------------

		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMai/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
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
		on ckbStartStop changed state do
		(
			if state then 
			(
				startTimer()
				updateStatus status:lb.previewRenderfarm.SERVER_IDLE
			) else
			(
				stopTimer()
				updateStatus status:lb.previewRenderfarm.SERVER_STOPPED
			)
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
				
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			createTimer()
			startTimer()
			ckbStartStop.checked = true
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			stopTimer()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: passManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_previewRenderfarmServer
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #layout,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Preview farm server, renders jobs sent from external PCs",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
		
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		serverIsRendering = false,
		stopRequested = false,
		jobData = undefined,
		
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
-- 		fn moveJobCorrectPath f =
-- 		(
-- 			fileName = filenameFromPath f
-- 			filePath = getFilenamePath f
-- 			p = filterString fileName "_"
-- 			sequenceFolder = p[1]+"_"+p[2] -- quitar números de cámara y ´layout´. Ej: seq_500-ts3
-- 			newFolder = lb.previewRenderfarm.sequencePath+sequenceFolder
-- 			correctPath = newFolder+"\\"+fileName
-- 			makeDir newFolder all:true
-- 			renameFile f correctPath
-- 			
-- 			-- Mover texturas
-- 			src = filePath+"\\"+lb.previewRenderfarm.texturesFolder
-- 			dst = newFolder+"\\"+lb.previewRenderfarm.texturesFolder
-- 			lb.previewRenderfarm.moveFolder src dst
-- 			
-- 			return correctPath
-- 		),
		
		fn updateJobStatus jobDir:undefined status:undefined =
		(
			if status != undefined then
			(
				f = openFile (jobDir+lb.previewRenderfarm.logFile) mode:"w"
			) else
			(
				--f = openFile (jobDir+lb.previewRenderfarm.logFile) mode:"a"
			)
			print status to:f
			close f
		),
		
		fn generateQuicktimeFileName filename quicktimeFile =
		(
			p = FilterString filename "_"
			camName = (FilterString (getFilenameFile quicktimeFile) ".")[1]
			if p.count == 4 then
			(
				quicktimeFileName = p[1] + "_" + p[2] + "_" + camName + "_" + p[4] + lb.previewRenderfarm.quicktimeFileExtension
			) else
			(
				quicktimeFileName = filename + "_" + camName + lb.previewRenderfarm.quicktimeFileExtension
			)
			return quicktimeFileName
		),
		
		fn moveVideoToOutputFolder videoFile =
		(
			filename = getFilenameFile(maxfilename)
			outputFolder = lb.previewRenderfarm.renderFarmFolder + lb.previewRenderfarm.outputFolder + filename + "\\"
			makeDir outputFolder
			dst = outputFolder + (this.generateQuicktimeFileName filename videoFile)
			if doesFileExist dst do deleteFile dst
			renameFile videoFile dst
		),
		
		fn getCurrentSequenceNumber =
		(
			sequenceNumber = ""
			p = filterstring (getFilenameFile maxfilename) "_"
			if p.count == 4 do sequenceNumber = p[2]
			return sequenceNumber
		),
		
		fn generateSeqCamString cam =
		(
			seq = this.getCurrentSequenceNumber()
			c = substituteString cam "cam_" ""
			return seq+"_"+c
		),
		
		fn getTotalFramesFromCameras cams =
		(
			frames = 0
			for c in cams do frames += (c.recEnd - c.recStart)
			return frames
		),
		
		fn makePreviews =
		(
			cams = this.jobData.cams
			
			-- configurar las opciones Nitrous del viewport
			lb.previewRenderfarm.configureViewportForRendering()
			
			-- obtener cámaras a renderizar y actualizar interfaz
			this.rollMain.updateStatus cams:(cams.count as string+" ("+this.getTotalFramesFromCameras(cams) as string+" frames)")
			
			-- crear videos para cada cámara
			nCam = 1.0
			for c in cams do
			(
				--añadir datos de cámara y rango de frames al timestamp si estuviera activado
				if this.jobData.timest != false do
				(
					this.jobData.timest.cameraName = this.generateSeqCamString c.name
					this.jobData.timest.frameRange = #(c.recStart,c.recEnd)
				)
				
				--si no se ha interrumpido el proceso de render por interfaz seguimos renderizando cámaras
				if not this.stopRequested do
				(
					this.rollMain.updateStatus currentCamera:c.name frameRange:#(c.recStart,c.recEnd)
					lb.previewRenderfarm.makeAviPreview(c)
					hiddendoscommand("taskkill /F /IM wmplayer.exe") --cargarnos el windows media que se abre automáticamente
					aviFile = lb.previewRenderfarm.renameTempPreview c --renombrar avi temporal para evitar pisarlo
					quicktimeFile = lb.previewRenderfarm.convertVideo aviFile timest:this.jobData.timest
					this.moveVideoToOutputFolder quicktimeFile
					this.rollMain.updateStatus progress:(nCam/cams.count*100)
					nCam += 1
					gc() --liberar memoria
				)
			)
		),
		
		fn getJobIDFromJobDir jobDir =
		(
			p = filterString jobDir "\\"
			return p[p.count]
		),
		
		fn launchRenderProcess jobDir =
		(
			--obtener datos del trabajo contenidos en el fichero XML del directorio del trabajo
			this.jobData = lb.previewRenderfarm.loadJobXmlData jobDir
			maxFiles = getFiles(jobDir+"*.max")
			if maxFiles.count > 0 then
			(
				this.serverIsRendering = true
				this.updateJobStatus jobDir:jobDir status:lb.previewRenderfarm.STATUS_RENDERING
				f = maxFiles[1]
				this.rollMain.updateStatus status:lb.previewRenderfarm.SERVER_OPENING jobId:(this.getJobIDFromJobDir jobDir) filename:(filenameFromPath f) sender:this.jobData.sender cams:(this.jobData.cams.count as string)
				loadMaxFile f quiet:true
				this.rollMain.updateStatus status:lb.previewRenderfarm.SERVER_RENDERING
				this.makePreviews()
				resetMaxFile #noPrompt
				this.rollMain.clearStatus()
				this.updateJobStatus jobDir:jobDir status:lb.previewRenderfarm.STATUS_FINISHED
				this.serverIsRendering = false
				--filePath = moveJobCorrectPath(f)
				--loadMaxFile filePath quiet:true
				--lb.previewRenderfarm.makePreviews()
			) else
			(
				--
				-- MANEJAR ESTA OCURRENCIA
				-- SI NO HAY FICHERO MAX EN LA CARPETA DE TRABAJO MARCAR EL TRABAJO COMO PODRIDO
				--
				throw ("Render job "+jobDir+" does not contain a max file")
			)
		),
		
		fn checkJobStatus jobdir =
		(
			statusFile = jobdir + lb.previewRenderfarm.logFile
			if doesFileExist statusFile then
			(
				f = openFile statusFile mode:"r"
				try
				(
					statusBit = readLine f
				) catch -- si da error es probablemente porque el fichero está vacío
				(
					statusBit = lb.previewRenderfarm.STATUS_OTHER
				)
				close f
				return statusBit as integer
			)
			else return lb.previewRenderfarm.STATUS_OTHER
		),
		
		fn checkForJobs =
		(
			jobFound = false
			jobDirs = getDirectories(lb.previewRenderfarm.renderFarmFolder+lb.previewRenderfarm.jobsFolder+"*")
			i = 1
			while (not jobFound and i<=jobDirs.count) do
			(
				job = jobDirs[i]
				case checkJobStatus(job) of
				(
					(lb.previewRenderfarm.STATUS_READY_TO_RENDER):
					(
						launchRenderProcess(job)
						jobFound = true
					)
					(lb.previewRenderfarm.STATUS_RENDERING): print (job+" is rendering")
					(lb.previewRenderfarm.STATUS_FINISHED): print (job+" is finished")
					(lb.previewRenderfarm.STATUS_OTHER): print (job+" is other")
				)
				i += 1
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
		
	)--tl_previewRenderfarmServer
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_previewRenderfarmServer() --crea la herramienta
)