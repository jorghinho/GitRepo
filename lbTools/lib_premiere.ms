------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Librería de funciones para trabajar con ficheros de Premiere
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: premiere | Contiene la libreria de funciones de Premiere.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_premiere
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria para trabajar con ficheros de Premiere",	--@var: description | Descripcion de la libreria.
		
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
		fn getEdlFromMaxFile file:undefined =
		(
			/*
			DECIDIR SI EL FICHERO EDL SE PILLA AUTOMATICAMENTE O SI SE SACA UNA VENTANA DE EXPLORADOR
			
			¿QUÉ PASA CUANDO HAY VARIOS FICHEROS DE LAYOUT POR SECUENCIA?
			*/
			
		-- 	edlFile = undefined
		-- 	sequencePattern = "seq_\d{3}.?(-[^_]+)?"
		-- 	filePattern = "[aZ]:\\sequence(\\movie)?\\" + sequencePattern + "\\layout\\" + sequencePattern 
		-- 	
		-- 	maxFile = file if file != undefined else (maxfilepath + maxfilename)
		-- 	m = lb.re.match maxFile 
		-- 	if 
			
			edlFile = "Y:\\sequence\\movie\\seq_030d-frank\\video\\edit\\seq_030d-frank_edit.edl"
			
			return edlFile
		),


		fn getVideoFullPath videoFile =
		(
			videoPath = undefined
			
			m = lb.re.match videoFile "_(cam\d{3})_"
			if m != false do
			(
				f = maxfilepath + "..\\cam\\" + m[1] + "\\video\\" + videoFile
				if doesFileExist f do
					videoPath = f
			)
			
			return videoPath
		),

		fn getClipsFromEdl edlFile =
		(
			camVideos = #()
			struct camVideo (cam, filename, videoDuration, videoRecStart, videoRecEnd, clips)
			struct clip (premiereDuration, premiereStart, premiereEnd, trimIn, trimOut)
			
			timecodePattern = "(\d{2}:\d{2}:\d{2}:\d{2})"
			videoPattern = "^\d{3}\s+AX\s+V\s+C\s+" + timecodePattern + " " + timecodePattern + " " + timecodePattern + " " + timecodePattern -- 001  AX       V     C        00:00:00:00 00:00:05:18 00:00:00:00 00:00:05:18
			clipPattern = "^\* FROM CLIP NAME:\s+(seq_\d{3}.?(-[^_]+)?_cam[^\d]?(\d{3})_.+)" -- * FROM CLIP NAME: seq_030d-frank_cam010_layout.mov

			f = openFile edlFile mode:"rt"
			while not eof f do
			(
				v = undefined
				_line = readLine f
				m = lb.re.match _line videoPattern
				if m != false do
				(
					-- Traducir timecodes a frames para ver cuánto se ha trimado en Premiere
					c = clip()
					c.trimIn = this.timecodeToFrames(m[1])
					c.premiereDuration = this.timecodeToFrames(m[2]) - c.trimIn
					c.premiereStart = this.timecodeToFrames(m[3])
					c.premiereEnd = this.timecodeToFrames(m[4]) - 1
					
					-- Leer siguiente linea para ver a qué clip pertenecen los datos
					_line = readLine f
					m2 = lb.re.match _line clipPattern
					if m2 != false do
					(
						-- Obtener número de cámara y nombre de fichero de video a partir de la regex
						videoFile = m2[1]
						camNumber = m2[3]
						
						-- Buscar si ya hemos creado datos de clip para este video, en tal caso añadir el nuevo clip. Si no, crear datos del video y añadir el primer clip
						camVideoExists = false
						for vid in camVideos do
						(
							if vid.cam == camNumber do
							(
								v = vid
								camVideoExists = true
								break
							)
						)
						
						-- Si no se ha encontrado datos para este video, creamos una nueva instancia de camVideo
						if not camVideoExists do
						(
							v = camVideo()
							v.cam = camNumber
							v.filename = videoFile
							v.clips = #()
							
							-- Obtener el resto de datos a partir de la información del video
							videoPath = getVideoFullPath videoFile
							info = lb.video.getVideoInfo videoPath
							v.videoRecStart = info.recStart
							v.videoRecEnd = info.recEnd
							v.videoDuration = info.duration
						)
						
						-- Obtener frames trimados de salida en Premiere a partir de la duración del video, la duración del clip en Premiere y la cantidad de frames de entrada
						c.trimOut = v.videoDuration - c.trimIn - c.premiereDuration
						
						-- Añadir clip a camVideo correspondiente (un video puede estar dividido en varios clips si se ha partido en la edición).
						append v.clips c
						
						-- Añadir camVideo si no había ya uno para este video
						if not camVideoExists do append camVideos v			
					)
				)
			)
			close f
			
			return camVideos
		),


		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		------------------------------------------------
		--@fn: integer | timecodeToFrames | Convierte una cadena de formato timecode a cantidad de frames
		--@gets: string | timecode | Cadena en formato timecode "HH:MM:SS:FF". Ej: 00:01:23:12
		--@returns: integer | Cantidad de frames que representa ese timecode
		------------------------------------------------
		fn timecodeToFrames timecode =
		(
			local timeParts = filterstring timecode ":" -- el formato de entrada es HH:MM:SS:FF. Ej: 00:01:20:17
			h = timeParts[1] as integer
			m = timeParts[2] as integer
			s = timeParts[3] as integer
			f = timeParts[4] as integer
			
			-- Calcular duración real en frames a partir de la duración en hh:mm:ss:ff y el framerate
			local seconds = h * 60 * 60 -- horas a segundos
			seconds += m * 60 -- minutos a segundos
			seconds += s -- añadir segundos
			frames = (seconds * framerate) + f -- multiplicar segundos por framerate y sumar frames adicionales
			return frames
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
		
	)--lib_premiere
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_premiere()
)