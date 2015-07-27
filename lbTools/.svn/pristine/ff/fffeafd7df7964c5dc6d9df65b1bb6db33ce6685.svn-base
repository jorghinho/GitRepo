------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Librería de funciones de vídeo
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: video | Contiene la libreria de funciones de video.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_video
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de video",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------		
		
		-- stampFontSize = 30, 					  @ var: fontsize | Linea comentada, el valor de la fuente esta en la linea 171 como variable: _stampFontSize.
		ffmpegDir = lb.config.getExePath(),	--@var: ffmpegDir | Ruta en la que se encuentra el fichero que permite codificar ffmpeg.
		stampOpacity = 0.5,
		stampFontFile = "/Windows/Fonts/consola.ttf",
		stampFontColor = "#ffffff",
		stampFontShadowColor = "#000000",

		
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
		--@fn: | getVideoInfo | Devuelve información del video (duración, codec, etc)
		--@gets: string | videoFile | Fichero de video a analizar
		------------------------------------------------
		fn getVideoInfo videoFile = 
		(
			struct videodata (file, recStart, recEnd, duration, size, framerate, videocodec, bitrate, colorspace, audiocodec, frequency, channels, audiorate)
			_data = videodata()
			_data.file = videoFile
			_hh = _mm = _ss = _cs = 0

			if doesFileExist videoFile then
			(
				-- Copiar al portapapeles la salida del commando de info de ffmpeg. 
				-- "2>&1" convierte la salida de error del comando en salida estándard. "| clip" redirige la salida estándard al portapapeles
				local command = "ffmpeg -i \"" + videoFile + "\" 2>&1 | clip"
				
				-- Activar el directorio de ejecución de FFmpeg, guardar el antiguo
				_oldCurrentDir = sysInfo.currentdir
				sysInfo.currentDir = this.ffmpegDir
				
				-- Ejecutar comando y guardar en portapapeles el resultado
				hiddenDOSCommand command
				result = getclipboardText() -- obtener clipboard
				
				-- Recuperar el anterior directorio de ejecución
				sysInfo.currentdir = _oldCurrentDir
				
				-- Partir el output del comando FFmpeg en líneas para analizarlas
				outputLines = filterstring result "\n"
				for _line in outputLines do
				(
					-- Explorar para ver si la línea es de datos generales del video.
					m = lb.re.match _line "^\s+Duration: (\d{2}):(\d{2}):(\d{2})\.(\d{2}), start: (\d+\.?\d+), bitrate: (\d+)" -- Salida de ffmpeg: "  Duration: 00:00:00.45, start: 0.000000, bitrate: 342929 kb/s"
					if m != false then
					(

						_hh = m[1] as integer -- horas
						_mm = m[2] as integer -- minutos
						_ss = m[3] as integer -- segundos
						_cs = (m[4] as float) / 100 -- centisegundos
						_data.bitrate = m[6] as integer				
					)

					-- Explorar para ver si la línea es de flujo de video.
					-- Salida de ffmpeg para .avi: "        Stream #0:0: Video: rawvideo, bgra, 512x218, 24 tbr, 24 tbn, 24 tbc"
					-- Salida de ffmpeg para .mov"    Stream #0:0(eng): Video: h264 (Constrained Baseline) (avc1 / 0x31637661), yuv420p, 1024x436, 1288 kb/s, 24 fps, 24 tbr, 12288 tbn, 48 tbc (default)"
					m = lb.re.match _line "^\s+Stream.+Video: ([^,]+), ([^,]+), (\d+)x(\d+),.* (\d+) (fps|tbr), .+"
					if m != false then
					(
						_data.videocodec = m[1]
						_data.colorspace = m[2]
						_data.size = #(m[3] as integer, m[4] as integer)
						_data.framerate = m[5] as float	
					)

					-- Explorar para ver si la línea es de flujo de audio.
					m = lb.re.match _line "^\s+Stream.+Audio: ([^,]+), (\d+) Hz, ([^,]+), ([^,]+), (\d+)" -- Salida de ffmpeg: "    Stream #0.1: Audio: pcm_s16le, 44100 Hz, mono, s16, 705 kb/s"
					if m != false then
					(
						_data.audiocodec = m[1]
						_data.frequency = m[2] as integer
						_data.channels = m[3]
						_data.audiorate = m[5] as integer	
					)

					-- Explorar para ver si la línea es de metadata de comentarios.
					m = lb.re.match _line "^\s+comment\s+:\s+((.*))$" -- Salida de ffmpeg: "      comment       : recStart: 100, recStart: 200"
					if m != false then
					(
						local _metadata = filterstring m[1] ","
						for meta in _metadata do
						(
							_keyValue = filterstring meta ":"
							_key = substituteString _keyValue[1] " " ""
							case _key of
							(	
								"recStart": _data.recStart = _keyValue[2] as integer
								"recEnd": _data.recEnd = _keyValue[2] as integer
							)
						)
					)
				)
				
				-- Calcular duración real en frames a partir de la duración en hh:mm:ss.cs y el framerate
				_data.duration = _hh * 60 * 60 -- horas a segundos
				_data.duration += _mm * 60 -- minutos a segundos
				_data.duration += _ss -- añadir segundos
				_data.duration += _cs -- añadir centisegundos
				_data.duration = this.round(_data.duration * _data.framerate) -- multiplicar por el framerate y redondear para obtener frames totales

				-- devolver el objeto de datos de video
				_data
			) else
			(
				print ("Could not find file: " + videoFile)
				undefined
			)
		),


		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		------------------------------------------------
		--@fn: integer | round | Devuelve un número redondeado
		--@gets: integer | n | número a redondear
		--@returns: integer | número redondeado
		------------------------------------------------
		fn round n = 
		(
			return (if n-(floor n) < .5 then (floor n) as integer else (ceil n) as integer)
		),

		------------------------------------------------
		--@fn: string | generateStampsCommand | Crea el comando FFmpeg para generar los stamps de video
		--@opt: array | meta | Array con los datos que aparecerán sobreimpresos (artista, rango de cámara, departamento, etc)
		--@opt: integer | percent | Porcentaje al que se va a reducir el video. Lo necesitamos para ajustar el tamaño de los textos
		--@returns: string | Devuelve la cadena de FFmpeg con el filtro de texto de stamps
		------------------------------------------------
		fn generateStampsCommand meta percent outputFile=
		(
			local _mult = percent * 1.0 / 100
			local _stampFontSize = (renderwidth*0.015)				-- Este valor se modificó por que era absoluto, y no se ajustaba a la resolución del previo, estaba ubicado en la linea 26, como var: stampFontSize = 30,.
			local _horizontalMargin = (renderwidth*0.015) * _mult	-- Este valor se modificó por que era absoluto, 30.
			local _verticalMargin = (renderwidth*0.024) * _mult		-- Este valor se modificó por que era absoluto, 50.
			local _shadowDistance = (renderwidth*0.0009) * _mult	-- Este valor se modificó por que era absoluto, 2.
			local _framesx = 160 * _mult
			local _rangeErrorBarWidth = 5 * _mult
			local _fontProperties = "drawtext=fontsize="+(_stampFontSize * _mult) as string+":fontfile='"+this.stampFontFile+"':fontcolor="+this.stampFontColor+"@"+this.stampOpacity as string+":shadowcolor="+this.stampFontShadowColor+"@"+this.stampOpacity as string+":shadowx="+_shadowDistance as string+":shadowy="+_shadowDistance as string+":"
			local _framenumberProperties = ""
			local _lCommands = #()


			if isProperty meta #sequence == true and meta.sequence != undefined and meta.sequence != "" do
				append _lCommands (_fontProperties + "x="+_horizontalMargin as string+":y=(h-"+_verticalMargin as string+"):text='seq\: "+meta.sequence+"'")

			if isProperty meta #camera == true and meta.camera != undefined and meta.camera != "" do
				append _lCommands (_fontProperties + "x=(w/5):y=(h-"+_verticalMargin as string+"):text='cam\: "+meta.camera+"'")

			if isProperty meta #lens == true and meta.lens != undefined and meta.lens != "" do
				append _lCommands (_fontProperties + "x=(w/3):y=(h-"+_verticalMargin as string+"):text='lens\: "+(meta.lens as string)+" mm'")

			--if isProperty meta #startDate == true and meta.startDate != undefined do
			--	append _lCommands (_fontProperties + "x=(w-text_w*2.8-"+_horizontalMargin as string+"):y=("+_verticalMargin as string+"-text_h):text='Start Date\: "+meta.startDate+"'")

			if isProperty meta #endDate == true and meta.endDate != undefined and meta.endDate != "" do
				append _lCommands (_fontProperties + "x=(w-text_w*1.5-"+_horizontalMargin as string+"):y=("+_verticalMargin as string+"-text_h):text='End Date\: "+meta.endDate+"'")

			if isProperty meta #stage == true and meta.stage != undefined and meta.stage != "" do
				append _lCommands (_fontProperties + "x=(w-text_w-"+_horizontalMargin as string+"):y=("+_verticalMargin as string+"-text_h):text='"+meta.stage+"'")
			
			if isProperty meta #artist == true and meta.artist != undefined and meta.artist != "" do
				append _lCommands (_fontProperties + "x="+_horizontalMargin as string+":y=("+_verticalMargin as string+"-text_h):text='"+meta.artist+"'")

			-- Si se ha definido frame de inicio, crear 4 ifs de FFmpeg para cada cifra (unidad, decena, centena, millar) y usar el parámetro startnumber para el offset de frame
			-- lo hacemos así porque FFMpeg no soporta (todavía) el formateo de strings en los stamps sobreimpresos
			if isProperty meta #recStart == true and meta.recStart != undefined and meta.recStart != "" do
			(
				-- Para número de fotograma real de max
				_framenumberProperties = _fontProperties + "x=(w/2):y=(h-"+_verticalMargin as string+"):start_number="+meta.recStart as string+":expansion=normal:text='fr\: "
				append _lCommands (_framenumberProperties + "0000%{n}':enable='lt(n+"+meta.recStart as string+"\,10)'")
				append _lCommands (_framenumberProperties + "000%{n}':enable='between(n+"+meta.recStart as string+"\,10,99)'")
				append _lCommands (_framenumberProperties + "00%{n}':enable='between(n+"+meta.recStart as string+"\,100,999)'")
				append _lCommands (_framenumberProperties + "0%{n}':enable='between(n+"+meta.recStart as string+"\,1000,9999)'")
				append _lCommands (_framenumberProperties + "%{n}':enable='between(n+"+meta.recStart as string+"\,10000,99999)'")

				-- Para número de fotograma relativo
				_framenumberProperties = _fontProperties + "x=((w/2)+"+_framesx as string+"):y=(h-"+_verticalMargin as string+"):expansion=normal:text='/ "
				append _lCommands (_framenumberProperties + "000%{n}':enable='lt(n\,10)'")
				append _lCommands (_framenumberProperties + "00%{n}':enable='between(n\,10,99)'")
				append _lCommands (_framenumberProperties + "0%{n}':enable='between(n\,100,999)'")
			)
			
			-- Asegurarnos de que hemos pasado un nombre de cámara
			if isProperty meta #camera == true and meta.camera != undefined and meta.camera != "" do
			(
				-- Intentar obtener cámara de la escena para obtener rangos válidos
				cam = getNodeByName ("cam_" + meta.camera)
				if cam != undefined do
				(
					_bStartBar = false
					_bEndBar = false

					-- Comprobar si los rangos del video son los mismos que los de la cámara, puede que el usuario haya movido la linea de tiempo de Max y no coincidan
					
					if isProperty meta #recEnd and meta.recEnd != undefined and meta.recEnd != "" and
					isProperty meta #recStart and meta.recStart != undefined and meta.recStart != "" and
					isProperty meta #stage and meta.stage!=lb.nc.NC_layoutFileName do            --  Aquí comprobar si el archivo es de Layout, no hay que generar las barras laterales amarillas/rojas
					(
						-- Comprobar rango de inicio
						if isProperty cam #recStart do
						(
							-- Si el frame de entrada válido de cámara (cam.recEnd) es menor que el frame de entrada usado para sacar el video (meta.recEnd) marcar linea roja a la derecha durante todo el video
							if cam.recStart < meta.recStart then
							(
								append _lCommands ("drawbox=x=1: y=0: w="+_rangeErrorBarWidth as string+": h=ih: color=red")
								_bStartBar = true
							)
							-- Si el frame de entrada válido de cámara (cam.recEnd) es mayor que el frame de entrada usado para sacar el video (meta.recEnd) marcar linea roja a la derecha durante la diferencia de intervalo					
							else if cam.recStart > meta.recStart do
							(
								startFrame = 0
								endFrame = cam.recStart - meta.recStart - 1
								append _lCommands ("drawbox=enable='between(n,"+startFrame as string+","+endFrame as string+")': x=1: y=0: w="+_rangeErrorBarWidth as string+": h=ih: color=red")
								_bStartBar = true
							)
						)
						
						-- Comprobar rango de fin
						if isProperty cam #recEnd do
						(
							-- Si el frame de salida válido de cámara (cam.recEnd) es mayor que el frame de salida usado para sacar el video (meta.recEnd) marcar linea roja a la derecha durante todo el video
							if cam.recEnd > meta.recEnd then
							(
								append _lCommands ("drawbox=x=iw-"+_rangeErrorBarWidth as string+": y=0: w="+_rangeErrorBarWidth as string+": h=ih: color=red")
								_bEndBar = true
							)
							-- Si el frame de salida válido de cámara (cam.recEnd) es menor que el frame de salida usado para sacar el video (meta.recEnd) marcar linea roja a la derecha durante la diferencia de intervalo					
							else if cam.recEnd < meta.recEnd do
							(
								startFrame = cam.recEnd - meta.recStart + 1
								endFrame = meta.recEnd - meta.recStart
								append _lCommands ("drawbox=enable='between(n,"+startFrame as string+","+endFrame as string+")': x=iw-"+_rangeErrorBarWidth as string+": y=0: w="+_rangeErrorBarWidth as string+": h=ih: color=red")
								_bEndBar = true
							)
						)
					)

					-- Comprobar si los rangos del video son los mismos que los de la cámara, puede que el usuario haya movido la linea de tiempo de Max y no coincidan
					_layoutVideoFile = substituteString outputFile "_anim" "_layout"
					if doesFileExist _layoutVideoFile do
					(
						layoutMeta = getVideoInfo _layoutVideoFile
						if isProperty layoutMeta #recEnd and layoutMeta.recEnd != undefined and layoutMeta.recEnd != "" and
						isProperty layoutMeta #recStart and layoutMeta.recStart != undefined and layoutMeta.recStart != "" do
						(
							-- Comprobar rango de inicio
							if isProperty cam #recStart do
							(
								--- comprobamos que el archivo al que le aplicamos las barras amarillas no es archivo de layout
								local nameScene = (filterString maxFileName "_") as array
								if nameScene[nameScene.count] != "layout.max" do
								(
									-- Si el frame de entrada válido de cámara (cam.recEnd) es menor que el frame de entrada usado para sacar el video (layoutMeta.recEnd) marcar linea roja a la derecha durante todo el video
									if cam.recStart < layoutMeta.recStart then
									(
										startFrame = 0
										endFrame = layoutMeta.recStart - cam.recStart - 1
										if _bStartBar then
											append _lCommands ("drawbox=enable='between(n,"+startFrame as string+","+endFrame as string+")': x=1: y=ih*0.5: w="+_rangeErrorBarWidth as string+": h=ih*0.5: color=yellow")
										else
											append _lCommands ("drawbox=enable='between(n,"+startFrame as string+","+endFrame as string+")': x=1: y=0: w="+_rangeErrorBarWidth as string+": h=ih: color=yellow")
									)
									-- Si el frame de entrada válido de cámara (cam.recEnd) es mayor que el frame de entrada usado para sacar el video (layoutMeta.recEnd) marcar linea roja a la derecha durante la diferencia de intervalo					
									else if cam.recStart > layoutMeta.recStart do
									(
										if _bStartBar then
											append _lCommands ("drawbox=x=1: y=ih*0.5: w="+_rangeErrorBarWidth as string+": h=ih*0.5: color=yellow")
										else
											append _lCommands ("drawbox=x=1: y=0: w="+_rangeErrorBarWidth as string+": h=ih: color=yellow")
									)
								)
							)


							-- Comprobar rango de fin
							if isProperty cam #recEnd do
							(
								--- comprobamos que el archivo al que le aplicamos las barras amarillas no es archivo de layout
								local nameScene = (filterString maxFileName "_") as array
								if nameScene[nameScene.count] != "layout.max" do
								(
									-- Si el frame de salida válido de cámara (cam.recEnd) es mayor que el frame de salida usado para sacar el video (layoutMeta.recEnd) marcar linea roja a la derecha durante todo el video
									if cam.recEnd > layoutMeta.recEnd then
									(
										startFrame = layoutMeta.recEnd - cam.recStart + 1
										endFrame = cam.recEnd - cam.recStart
										if _bEndBar then
											append _lCommands ("drawbox=enable='between(n,"+startFrame as string+","+endFrame as string+")': x=iw-"+_rangeErrorBarWidth as string+": y=ih*0.5: w="+_rangeErrorBarWidth as string+": h=ih*0.5: color=yellow")
										else
											append _lCommands ("drawbox=enable='between(n,"+startFrame as string+","+endFrame as string+")': x=iw-"+_rangeErrorBarWidth as string+": y=0: w="+_rangeErrorBarWidth as string+": h=ih: color=yellow")
									)
									-- Si el frame de salida válido de cámara (cam.recEnd) es menor que el frame de salida usado para sacar el video (layoutMeta.recEnd) marcar linea roja a la derecha durante la diferencia de intervalo					
									else if cam.recEnd < layoutMeta.recEnd do
									(
										if _bEndBar then
											append _lCommands ("drawbox=x=iw-"+_rangeErrorBarWidth as string+": y=ih*0.5: w="+_rangeErrorBarWidth as string+": h=ih*0.5: color=yellow")
										else
											append _lCommands ("drawbox=x=iw-"+_rangeErrorBarWidth as string+": y=0: w="+_rangeErrorBarWidth as string+": h=ih: color=yellow")
									)
								)
							)
						)
					)
				)
			)

			
			if _lCommands.count > 0 do
				return (" -vf \"" + (lb.str.join _lCommands ",") + "\"")

			return ""
		),


		------------------------------------------------
		--@fn: string | encodeVideo | Convierte el vídeo pasado por parámetro a quicktime

		------------------------------------------------
		fn encodeVideo inputVideo videoFileName:undefined outputType:#mov percent:100 size:undefined meta:undefined = 
		(
			local _previewFileType = if outputType == #mov then ".mov" else ".avi"
			local _encodedVideo = if videoFileName != undefined then videoFileName else (lb.preview.previewDir + "_sceneTMP" + _previewFileType)
			local _audioCodecCommand = "-acodec pcm_s16le"
			local _metadataCommand = ""
			local _stampCommand = ""
			local _encodeCommand = ""
			local _sizeCommand = ""
			local _oldCurrentDir = sysInfo.currentdir

			--	Los quicktime entendemos que están preconfigurados en H264. Los AVI los codificamos a mpeg4
			_videoCodecCommand = if outputType == #mov then " -vcodec libx264 -preset fast -profile:v baseline -pix_fmt yuv420p " else " -vcodec mpeg4 "

			-- Añadir metadatos y stamps de video si se han pasado
			if meta != undefined do
			(
				_metadataCommand = " -metadata comment=\""
				props = getPropNames meta
				for i=1 to props.count do
				(
					propValue = getProperty meta props[i]
					if propValue != undefined do
					(
						_metadataCommand += (props[i] as string) + ": " + propValue as string
						if i < props.count do _metadataCommand += ", "
					)
				)
				_metadataCommand += "\" -metadata title=\"" + (filenameFromPath _encodedVideo) + "\""

				_stampCommand = this.generateStampsCommand meta percent _encodedVideo
			)

			-- Nos aseguramos de que las medidas del vídeo son múltiplo de 2 en caso de que se haya especificado el tamaño de video
			-- Hay muchos códecs que solo trabajan con cifras pares
			if size != undefined do
			(
				size.x += (mod size.x 2)
				size.y += (mod size.y 2)
				_sizeCommand = " -s " + (size.x as integer) as string + "x" + (size.y as integer) as string
			)

			-- Ejecutamos la codificación del ffmpeg y juntamos el audio y el vídeo
			_encodeCommand = "ffmpeg -r "+(framerate as string)+" -i \"" + inputVideo + "\" -r "+(framerate as string)+" -y" + _metadataCommand + _stampCommand + _videoCodecCommand + _audioCodecCommand  + _sizeCommand + " \"" + _encodedVideo + "\""
			print _encodeCommand	--	no quitar este print
			
			-- Borrar el video antiguo si existía
			if doesFileExist _encodedVideo then
			(
				setFileAttribute _encodedVideo #readOnly false -- permitir escritura
				if not deleteFile _encodedVideo do print ("Could not delete: " + _encodedVideo)
			)
			
			-- Modificar directorio de ejecución. Salvar configuración de directorio anterior
			sysInfo.currentDir = ffmpegDir
			
			pushPrompt "Encoding Video"
			
			--	Codificación
			hiddenDOSCommand (_encodeCommand) donotwait:false
			
			pushPrompt (_encodedVideo + " successfully created")
			
			--	restauramos los valores antiguos
			sysInfo.currentdir = _oldCurrentDir
			
			return _encodedVideo
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
		
	)--lib_video
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_video()
)

