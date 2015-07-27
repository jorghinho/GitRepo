------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de plantilla
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: previewRenderfarm | Contiene la libreria de plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_previewRenderfarm
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #layout,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Preview farm library for common properties and methods",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		renderFarmFolder = "\\\\dalonso-minion\\comparte\\layoutRepository\\",
		jobsFolder = "jobs\\",
		outputFolder = "output\\",
		texturesFolder = "texture\\",
		logFile = "status.log",
		jobInfoFile = "info.xml",
		timecodeFile = "timecode.txt",
		sequencePath = "Y:\\sequence\\",
		sequencerCamNodePrefix = "__sceneCam__",
		aviPreviewFileName = "_scene",
		aviPreviewFileExtension = ".avi",
		quicktimeFileExtension = ".mov",
		videoCameraPrefix = "cam_",
		videoCameraNumberFormat = "03d",
		nitrousPreviewQuality = 64,
		videoWidth = 2048,
		videoHeight = 872,
		timestampFont = "/Windows/Fonts/arial.ttf",
		timestampTimecodeFont = "/Windows/Fonts/courbd.ttf",
		timestampTimecodeFontsize = 40,
		timestampTimecodeLineHeight = 33, --ajustar este valor para corregir el desplazamiento del texto
		timestampTimecodeFile = "timecode.txt", 
		timestampTimecodeFileLinesBetweenNumbers = 50, --número de líneas en blanco entre cada línea de código de tiempo del fichero temporal de códigos
		
		------------------------------------------------------------------------------------------------
		-- CONSTANTES
		------------------------------------------------------------------------------------------------
		STATUS_READY_TO_RENDER = 0,
		STATUS_RENDERING = 1,
		STATUS_FINISHED = 2,
		STATUS_OTHER = 3,
		
		SERVER_IDLE = "ready",
		SERVER_OPENING = "opening...",
		SERVER_RENDERING = "rendering...",
		SERVER_FINISHED = "done.",
		SERVER_STOPPED = "stopped",
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		fn round n = (return (if n-(floor n) < .5 then (floor n) as integer else (ceil n) as integer)),
		
		fn isOdd n = (return (if (mod n 2)==1.0 then true else false)),
			
		fn getPreviewMaxPercent =
		(
			max_percent = floor((gw.getWinSizeX() as float/renderwidth)*100)
			do 
			(
				max_w = this.round(renderwidth*(max_percent/100))
				max_h = this.round(renderheight*(max_percent/100))
				max_percent -= 1
			) while (this.isOdd(max_w) or this.isOdd(max_h))
			return (max_percent+1) as integer
		),
		
		fn loadJobXmlData jobDir =
		(
			struct data (id, sender, file, cams, timest)
			struct cam (name, recStart, recEnd)
			struct timestampInfo (animatorName, frameNumbersStampEnabled, cameraStampEnabled, customStamp, textSize, textColor, cameraName, frameRange)
			
			xml = lb.xml.load(jobDir+this.jobInfoFile)
			root = xml.getNode "job"
			
			id = (root.getNode "id").getText()
			sender = (root.getNode "sender").getText()
			file = (root.getNode "file").getText()
			cameraNode = root.getNode "cameras"
			cams = for c in cameraNode.getNodes "camera" collect (cam (c.getProperty("name")) (c.getProperty("start") as integer) (c.getProperty("end") as integer))
			
			ts = root.getNode "timestamp"
			if (ts.getPropNames()).count > 0 then
			(
				tsAnimatorName = (ts.getProperty "animatorName")
				tsFrameNumbersStampEnabled = execute (ts.getProperty "frameNumbersStampEnabled")
				tsCameraStampEnabled = execute (ts.getProperty "cameraStampEnabled")
				tsCustomStamp = (ts.getProperty "customStamp")
				tsTextSize = (ts.getProperty "textSize") as integer
				tsTextColor = execute (ts.getProperty "textColor")
				tsDetails = timestampInfo (tsAnimatorName) (tsFrameNumbersStampEnabled) (tsCameraStampEnabled) (tsCustomStamp) (tsTextSize) (tsTextColor) "" #() --añadir dos últimos parámetros en blanco para nombre de cámara y framerange
			) else
			(
				tsDetails = false
			)
			
			return (data id sender file cams tsDetails)
		),
		
		fn getJobStatus jobDir =
		(
			struct jobStatus (status, progress)
			f = openFile (jobDir+this.logFile) mode:"r"
			status = (readLine f) as integer
			try
			(
				progress = readLine f
			) catch
			(
				progress = "0%"
			)
			close f
			return (jobStatus status progress)
		),
		
		fn formatDateFromId id =
		(
			year = substring id 1 4
			month = substring id 5 2
			day = substring id 7 2
			hour = substring id 9 2
			minute = substring id 11 2
			second = substring id 13 2
			return (day + "/" + month + "/" + year + " - " + hour + ":" + minute + ":" + second)
		),
		
		fn getAllJobsFromFarm =
		(
			struct job (id, file, sender, date, cams, status, progress)
			
			jobs = #()
			for jobDir in getDirectories(this.renderFarmFolder+this.jobsFolder+"*") do
			(
				data = this.loadJobXmlData(jobDir)
				st = this.getJobStatus(jobDir)
				case st.status of
				(
					STATUS_READY_TO_RENDER: status = "waiting"
					STATUS_RENDERING: status = "rendering"
					STATUS_FINISHED: status = "finished"
					STATUS_OTHER: status = "error"
				)
				append jobs (job (data.id) (data.file) (data.sender) (this.formatDateFromId(data.id)) (data.cams.count as string) status (st.progress))
			)
			return jobs
		),
		
		------------------------------------------------
		--@fn: undefined | moveFolder | Mueve un directorio completo de src a dst
		------------------------------------------------
		fn getAllBitmapsFromScene =
		(
			files = for bm in lb.blur.get_bitmaps_from_maps(lb.blur.get_all_scene_maps()) collect bm.filename
			lb.blur.trim_dups files
			return files
		),
		
		fn moveFolder src dst =
		(
			makeDir dst all:true --crear directorio destino
			files = getFiles(src + "\\*.*")
			for f in files do --mover ficheros contenidos en carpeta
			(
				renameFile f (dst+"\\"+(filenameFromPath f))
			)
			hiddendoscommand("rmDir "+src)
		),
		
		------------------------------------------------
		--@fn: array | getAllSequencerCameras | Devuelve un array con todos los nodos de cámara del sequencer
		------------------------------------------------
		fn getSequencerCameraNodes disabled:false =
		(	
			camNodes = execute("$'"+this.sequencerCamNodePrefix+"*'")
			if not disabled do
			(
				camNodes = for c in camNodes where c.baseObject.custAttributes[#camSequencerInfo].enabled == true collect c
			)
			return camNodes
		),
		
		fn getSequencerCamerasData =
		(
			struct camNode (recStart, recEnd, cam)
			struct camObj (name)
			camsData = #()
			
			--obtener nodos de cámara del sequencer
			cams = this.getSequencerCameraNodes()
			if cams.count > 1 then
			(
				camsData = for c in cams collect c.baseObject.custAttributes[#camSequencerInfo]
			) else --si no hay nodos de cámara del sequencer, obtenerlos de la escena
			(
				try --si las cámaras no tienen las propiedades recStart/recEnd el código petará
				(
					camsData = for c in cameras collect (camNode (c.recStart) (c.recEnd) (camObj (c.name)))
				) catch
				(
					continue
				)
			)
			return camsData
		),
		
		fn makeAviPreview cam =
		(
			-- activamos la cámara y rango de animación que toca 
			viewport.setCamera (execute ("$"+cam.name))
			animationRange = interval cam.recStart cam.recEnd
			
			-- crear previo de Max y devolver ruta al fichero AVI creado
			CreatePreview outputAVI:true percentSize:(this.getPreviewMaxPercent()) dspSafeFrame:true start:cam.recStart end:cam.recEnd skip:1 fps:framerate
		),
		
		fn arrayImplode arr str:"" =
		(
			imploded = arr[1]
			for i=2 to arr.count where arr[i] != "" do imploded += str + arr[i]
			return imploded
		),
		
		fn colorToHex col =
		(
			r = formattedPrint (col.r as integer) format:"02X"
			g = formattedPrint (col.g as integer) format:"02X"
			b = formattedPrint (col.b as integer) format:"02X"
			return ("#"+r+g+b)
		),
		
		fn createFramesFile frameRange =
		(
			--almacenar en cadena los números de frames y los saltos de línea para separar cada número de frame
			framesString = ""
			for i=frameRange[1] to frameRange[2] do
			(
				framesString += (formattedPrint i format:"04d") + "/" + (formattedPrint (i-frameRange[1]) format:"04d")
				for j=1 to this.timestampTimecodeFileLinesBetweenNumbers do framesString += "\n"
			)
			--escribir cadena de números de frames en fichero temporal
			framesFile = sysInfo.tempdir + this.timecodeFile
			f = openFile framesFile mode:"w"
			format framesString to:f
			close f
			return framesFile
		),
		
		fn toFFmpegPath str =
		(
			for i = 1 to str.count do if str[i] == "\\" do str = replace str i 1 "/"
			return (substring str 3 str.count)
		),
		
		fn generateTimecodeCommand frameRange col =
		(
			timecodeFile = toFFmpegPath(this.createFramesFile(frameRange))
			yPos= "(h)-50-("+(this.timestampTimecodeLineHeight*this.timestampTimecodeFileLinesBetweenNumbers) as string+"*n)"
			return ("drawtext=fontsize="+timestampTimecodeFontsize as string+":fontcolor="+col+":fontfile='"+this.timestampTimecodeFont+"':textfile='"+timecodeFile+"':shadowx=2:shadowy=2:x=(w-text_w)/2:y="+yPos)
		),
		
		fn generateTimestampEncodeCommand ts =
		(
			timestampCommand = "-vf \"[in]"
			col = this.colorToHex(ts.textColor)
			drawtextPrefix = "drawtext=fontsize="+(4*ts.textSize) as string+":fontcolor="+col+":shadowx=2:shadowy=2:fontfile='"+this.timestampFont+"':text="
			tsAnimator = if ts.animatorName != "" then drawtextPrefix+"'"+ts.animatorName+"':x=(w-text_w-50):y=(h)-50" else ""
			tsCustom = if ts.customStamp != "" then drawtextPrefix+"'"+ts.customStamp+"':x=(w-text_w-50):y=50" else ""
			tsCamera = if ts.cameraStampEnabled then drawtextPrefix+"'"+ts.cameraName+"':x=50:y=(h)-50" else ""
			tsTimecode = if ts.frameNumbersStampEnabled then this.generateTimecodeCommand ts.frameRange col else ""
			timestampCommand += (this.arrayImplode #(tsAnimator,tsCustom,tsCamera,tsTimecode) str:",")+"[out]\""
			return timestampCommand
		),
		
		fn convertVideo aviFile timest:false =
		(
			quicktimeFile = (getFilenamePath aviFile) + (getFilenameFile aviFile) + this.quicktimeFileExtension
			timestampCommand = if timest != false then this.generateTimestampEncodeCommand timest else ""
			encodeCommand = "ffmpeg -i \"" + aviFile + "\" -y -vcodec libx264 -preset fast -profile:v baseline -pix_fmt yuv420p -s "+this.videoWidth as string+"x"+this.videoHeight as string+" "+timestampCommand+" \"" + quicktimeFile + "\""
			sysInfo.currentDir = lb.preview.ffmpegDir
			print encodeCommand
			hiddenDOSCommand encodeCommand exitCode:&exitCode
			--DOSCommand (encodeCommand+" & pause")
			deleteFile aviFile
			return quicktimeFile
		),
		
		fn configureViewportForRendering =
		(
			(NitrousGraphicsManager.GetActiveViewportSetting()).ViewportViewSettingImpl.VisualStyleMode = #realistic
			actionMan.executeAction -844228238 "6" --iluminar con luces de la escena
			NitrousGraphicsManager.MakePreviewQuality = this.nitrousPreviewQuality --número de pases de renderizado
		),
		
		------------------------------------------------
		--@fn: integer | getTrailingNumberFromString | Dada una cadena str devuelve el número entero que se encuentre al final de la misma
		------------------------------------------------
		fn getTrailingNumberFromString str =
		(
			t = trimRight str "0123456789"
			(substring str (t.count+1) -1) as integer
		),
		
		fn generateCorrectCameraName cam =
		(
			cameraNumber = this.getTrailingNumberFromString cam
			return (this.videoCameraPrefix+(formattedPrint cameraNumber format:this.videoCameraNumberFormat))
		),
		
		fn renameTempPreview cam =
		(
			previewFolder = getDir #preview
			old = previewFolder+"\\"+this.aviPreviewFileName+this.aviPreviewFileExtension
			new = previewFolder+"\\"+(this.generateCorrectCameraName cam.name)+this.aviPreviewFileExtension
			renameFile old new
			return new
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
		
	)--lib_previewRenderfarm
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_previewRenderfarm() --crea la libreria
)