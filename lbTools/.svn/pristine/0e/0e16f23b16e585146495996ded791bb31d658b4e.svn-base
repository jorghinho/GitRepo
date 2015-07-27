------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Preanim composer.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta Preanim Composer.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Pre-anim Scene Composer"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 810		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 727		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local cameraToExportColor = (dotNetClass "System.Drawing.Color").fromargb 255 255 255
		local cameraToIgnoreColor = (dotNetClass "System.Drawing.Color").fromargb 150 150 150
		local cameraFailedColor = (dotNetClass "System.Drawing.Color").fromargb 255 0 0 
		local cameraExportedColor = (dotNetClass "System.Drawing.Color").fromargb 0 255 0

		-- Estructura de datos que contiene los personajes relacionados para cada personaje
		local _charList = #() -- Sera una lista de charListItems
		struct _charListItem ( char = "" , relatedChars = #() ) -- related chars es una lista de parejas charListItemData
		struct _charListItemData ( charName = "" , charPath = "" )

		local _charsFolder = "y:\\asset\\chr\\"
		local nonListableFolders = #("auxiliary","doc","lib")

		-- Parejas de union entre un personaje de layout y animacion. Y las posiciones en layout para la camara para el personaje
		struct charLink ( layout = "", animation = "", layoutPos = undefined )
		-- La camara, la lista de enlaces de personajes para esa camara, y un booleano que indica que se ha completado la lista
		-- de enlaces con todos los personajes. Esto se comprueba antes de exportar.
		struct camLinkageInfo (	cam = "", linkList = #()) 
		local _camLinkageList = #() -- contains a list camLinkageInfos

		local _noneText = "None"
		local _logPath = ""

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		GroupBox grp1 "Scene Cameras" pos:[13,16] width:114 height:678
		GroupBox grp3 "Layout to Animation Character Linker" pos:[136,16] width:350 height:707
		GroupBox grp4 "Export Process" pos:[496,18] width:303 height:705

		dotNetControl _cameraListView "System.Windows.Forms.ListView" pos:[25,35] width:89 height:649 across:3
		dotNetControl _charListView "System.Windows.Forms.ListView" pos:[149,57] width:324 height:146 
		
		dotNetControl _tbCharListTabs "System.Windows.Forms.TabControl" pos:[147,231] width:327 height:290
		dotNetControl _relatedCharList "System.Windows.Forms.ListView" pos:[149,255] width:320 height:262
		dotNetControl _fullCharTree "System.Windows.Forms.TreeView" pos:[149,255] width:320 height:262

		dotNetControl _linkedListView "System.Windows.Forms.ListView" pos:[149,549] width:326 height:165

		label lbl1 "Current Scene Characters" pos:[250,39] width:150 height:16
		button _updateCharBtn "Update" pos:[420,39] width:50 height:16

		button _addBtn "Create Link" pos:[160,523] width:150 height:20
		button _deleteBtn "Unlink" pos:[320,523] width:150 height:20
		
		label lbl2 "Available Characters" pos:[256,215] width:104 height:16
		label lbl3 "Process Log" pos:[615,142] width:64 height:17
		button _exportBtn "START EXPORT" pos:[508,87] width:277 height:44
		
		dotNetControl _log "System.Windows.Forms.TextBox" pos:[506,165] width:284 height:550 
 
		radiobuttons _overwriteRadioBtn "" pos:[526,40] width:245 height:16 enabled:true labels:#("skip existing", "overwrite existing") default:1 columns:2
		checkbox _chkUseTempPresets "Speed up with temp files" pos:[526,60] width:120 height:16 enabled:true checked:true
		checkbox _chkKeepLastTempPresets "Keep existing temp files" pos:[670,60] width:120 height:16 enabled:true checked:false
		button _helpBtn "TOOL HELP" pos:[12,698] width:116 height:21 toolTip:"Opens the documentation about this tool."


		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------

		------------------------------------------------------------------------------
		--@fn: array{string} | getFolderDirectories | devuelve todas las carpetas encontradas en la ruta FOLDER exceptuando las ".svn" de SubVersion
		------------------------------------------------------------------------------
		fn getFolderDirectories folder dirs:#() =
		(
			_dirs = getDirectories folder
			
			--	Eliminamos todos los directorios que no hay que listar
			for i = _dirs.count to 1 by -1 do 
			(
				_folderParts = filterstring _dirs[i] "\\"
				_lastFolderPart = _folderParts[_folderParts.count]
				
				if findItem nonListableFolders _lastFolderPart != 0 then 
					deleteItem _dirs i
			)
			
			_dirs
		)


		fn getBaseNodeFromName charName =
		(
			-- TODO: Usar el naming convention y evitar hacer esto de la manera bestia : buscar todos los assets de
			-- escena, buscar sus infos, hacer bucle, buscar el root de cada uno. Eso es lento para este proceso que es largo.
			-- Hay que buscar otra solución rápida, como esta.
 			
			-- ejemplo: char_anim_m_base_x_c
 			_baseNodeName = charName + "_" 
 			_baseNodeName += lb.nc.NC_classAnim  + "_" 
 			_baseNodeName += lb.nc.NC_locationMiddle + "_" 
 			_baseNodeName += lb.nc.NC_ANIM_base + "_" 
 			_baseNodeName += lb.nc.NC_nonSpecifiedCache + "_" 
 			_baseNodeName += lb.nc.NC_controlFlag

 			getNodeByName (charName + "_" + lb.nc.NC_classAnim + "_m_base_x_c")
		)

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		fn addToLog textToAdd =
		(
			_log.text += (textToAdd + "\r\n")
		)

		fn addLogSeparator =
		(
			addToLog "\n---------------------------\n"	
		)

		fn getTimeString =
		(
			_time = getLocalTime()
			_timeTxt = (_time[1] as string) + "_"
			_timeTxt += (_time[2] as string) + "_"
			_timeTxt += (_time[3] as string) + "_"
			_timeTxt += (_time[4] as string) + "_"
			_timeTxt += (_time[5] as string) + "_"
			_timeTxt += (_time[6] as string) + "_"
			_timeTxt += (_time[7] as string)
			_timeTxt
		)

		fn createNewLogPath =
		(
			_timeTxt = getTimeString()

			-- obtengo la ruta
			local dirMax = filterstring maxfilepath "\\" 
			_basePath =  (dirMax[1] + "\\" + dirMax[2] + "\\" + dirMax[3] + "\\" + dirMax[4] + "\\doc\\preanim_exporter\\" ) as string
			_logPath = (_basePath + _timeTxt + "\\")
	
			-- Crear el directorio si no existe aun
			if not doesFileExist _logPath do 
				makeDir _logPath

			if not doesFileExist _logPath then 
			(
				_logPath = ""
				addToLog "Error: Unnable to create path for log files:"
				addToLog _basePath
			)
			else 
			(
				addToLog "Log files exported in folder:"
				addToLog _basePath
			)
		)

		fn saveSettingsToLogFolder = 
		(
			if _logPath == "" do return 0

            -- Creamos un nuevo archivo
			local newFile = (_logPath + "exportSettings.txt") as string

			-- Si no existe el archivo lo creamos
			if not doesFileExist newFile then
			    txt_stream = createfile newFile
 			-- abrimos el archivo
			else 
				txt_stream = openFile newFile mode:"w"

			-- Si existe el stream del archivo, escribimos la configuracion actual
		    if txt_stream != undefined do 
			(
				format "\nStarted export on : %\n" localTime to:txt_stream

				-- Leemos la informacion de linkado de personajes y camaras
				for _linkInfo in _camLinkageList do 
				(
					format "\n%\n" _linkInfo.cam to:txt_stream

					for _link in _linkInfo.linkList do 
					(
						format "% <--> " _link.layout to:txt_stream
						format "%\n" _link.animation to:txt_stream
					)
				)
				
				flush txt_stream
		   		close txt_stream
		   	)			
		)

		fn saveLogToFile =
		(
			if _logPath == "" do return 0

			_timeTxt = getTimeString()

			-- Creamos un nuevo archivo
			local newFile = (_logPath + "animExport_" + _timeTxt + ".txt") as string

			-- Si no existe el archivo lo creamos
			if not doesFileExist newFile then
			    txt_stream = createfile newFile
 			-- abrimos el archivo
			else 
				txt_stream = openFile newFile mode:"w"

			-- Si existe el stream del archivo, escribimos el contenido del log actual
		    if txt_stream != undefined do 
			(
				format "%" _log.text to:txt_stream
				flush txt_stream
		   		close txt_stream
		   	)

		)

		fn getLinkageInfoFromCam _cam = 
		(
			info = undefined
			counter = 1

			while info == undefined and counter <= _camLinkageList.count do 
			(
				curInfo = _camLinkageList[counter]

				if (curInfo.cam == _cam) do
					info = curInfo

				counter += 1
			)

			info
		)

		fn updateCharLinkInCam cam _layoutChar _animCharPath = 
		(
		    -- creamos una estructura de link
			_linkInfo = getLinkageInfoFromCam cam
			
			if _linkInfo != undefined then
			(
				found = false
				foundIndex = 1
				index = 1

				-- Buscamos el link del personaje de layout y lo actualizamos
				for link in _linkInfo.linkList do 
				(
					-- si existe un link del personaje de layout, lo modificamos por el nuevo
					if (link.layout == _layoutChar) do 
					(
						link.animation = _animCharPath
						found = true
						foundIndex = index
					)
					index += 1
				)

				-- Si existe el enlace y se quiere eliminar, lo eliminamos de la lista
				if found and _animcharPath == _noneText do 
					deleteItem _linkInfo.linkList foundIndex

				-- Si no existia ningun link entre personajes y no queremos eliminarlo, lo creamos
				if not found and _animCharPath != _noneText do 
				(
					-- Obtenemos el transform del nodo root
					_transform = undefined
					_charBaseNode = getBaseNodeFromName _layoutChar

					-- Obtenemos la transformacion del nodo base
					if (_charBaseNode != undefined) then
						_transform = _charBaseNode.transform
					else 
						addToLog ("WARNING: Base node for character not available: " + (_charBaseNode.name as string) + ". Character will not be positioned in the right place after export...")

					 -- creamos una estructura de link
					_charLink = charLink _layoutChar _animCharPath _transform

					-- lo añadimos a la lista
					append _linkInfo.linkList _charLink
				)

			)
			else 
				addToLog ("ERROR: Link information for camera " + (cam as string) + " not available.")

		)

		-- elimina capas vacias
		fn deleteEmptyLayers = 
		(
			-- Contamos cuantas capas hay antes de borrar
			deletedLayerCount = layermanager.count 

			-- Borramos capas vacias
			lb.layer.deleteEmptyLayers()

			-- Vemos cuantas hemos eliminado
			deletedLayerCount -= layermanager.count 

			-- Si se ha borrado alguna lo mostramos
			if deletedLayerCount > 0 do 
				addToLog ("Deleted " + (DeletedLayerCount as string) + " empty layers.")
		)

		-- Bloquea las transformaciones de las cámaras
		fn blockCameras =
		(
			-- localizamos la capa que contiene las cámaras y accedemos a ellas
			camLayer = LayerManager.getLayerFromName "_cam_"
			camLayer.nodes &theNodes
			for o in theNodes do 
			(
				-- checkeamos que es de la clase camara
				if (superclassof o) == Camera do
				(
					-- conjelamos, ocultamos y blockeamos sus transformaciones
					setTransformLockFlags o #all
					o.isFrozen = true
					o.isHidden = true
				)
			)

			--messagebox "- Revisar que no tenga keys de más \n- Coprobar previos con skins\n- Release lock"
		)

		fn importAudios = 
		(
			-- Borrar audios anteriores
			ntracks = prosound.NumTracks()
			for i=1 to ntracks do 
				prosound.delete 1

			-- Obtener rango de inicio del plano
			start = 0
			if cameras.count > 0 do
			(
				if isproperty cameras[1] "recStart" do
				(
					start = cameras[1].recStart
				)
			)

			_sound_path = maxfilepath + "..\\sound\\"
			_sounds = getFiles (_sound_path + "*.wav")
			if _sounds.count > 0 do addToLog "Added sound:"
			index = 1
			for _sound in _sounds do
			(
				prosound.append _sound
				prosound.shift index start
				_pathParts = filterstring _sound "\\"
				_fileName =  _pathParts[_pathParts.count]
				addToLog _fileName
				index += 1
			)

		)

		fn loadCharacter charPath mergeIfAvailable:true = 
		(
			-- comprobar que esta checked 
			if (lb.presets.getPresetCheckedState charPath) != #checked do
				addToLog "Warning! : Preset is not checked."

			if mergeIfAvailable and _chkUseTempPresets.checked then 
			(
				-- Hay una carpeta provisional donde importamos personajes en una escena suelta.
				-- La proxima vez que se carga el personaje en la exportacion, ya estara creado y solo hay que mergear
				 _preanimCharsTempPath = (lb.presets.getTempAndPresetTempPath charPath)[2]

				-- Si no existe lo cargamos de manera normal
				if not doesFileExist _preanimCharsTempPath then
				(
					print ("Importing character (slower)... " + charPath)
					res = lb.presets.load charPath
					--TODO: USar res
				)

				-- Si existe , lo mergeamos
				else 
				(
					print ("Merging character from temp folder (faster)... " + charPath)
					res = mergeMaxFile _preanimCharsTempPath #skipDups 
					res
				)
			)
			-- Si no queremos mergear, simplemente lo importamos normalmente.
			else
			(
				print ("Importing character (slower)... " + charPath)
				res = lb.presets.load charPath -- TODO: USAR RES. ahora no funciona res
			)

			true

		)

		fn getCharNameFromPath path =
		(		
			_pathParts = filterstring path "\\"
			_fileName =  _pathParts[_pathParts.count]
			_fileNameParts = filterstring _fileName "_"
			_fileName = _fileNameParts[1] + "_" + _fileNameParts[2]
			_fileName
		)

		fn moveCharacterToCharacter animChar layoutCharTransform = 
		(
			if layoutCharTransform != undefined do 
			(
				_rootAnimNode = getBaseNodeFromName animChar
				if _rootAnimNode != undefined and _rootAnimNode.transform != undefined do
					_rootAnimNode.transform = layoutCharTransform
			)
		)


		fn loadCharacters linkList =
		(
			if maxFileName != "" do 
			(
			    -- Para cada elemento de link de la camara elegida, cargamos el personaje de animacion y lo movemos
				for link in linkList do 
				(
					addToLog ("Loading Char: " + link.animation)
					res = loadCharacter link.animation
					if res then
					(
						if (link.layoutPos != undefined) then 
						(
							animCharName = getCharNameFromPath link.animation
							moveCharacterToCharacter animCharName link.layoutPos
						)
						else
							addToLog "Error moving character..."
					) 
					else 
						addToLog "Error loading character..."
				)
			)
		)

		------------------------------------------------------------------------------
		--@fn:  undefined | getHighestVersionPath | Obtiene del path aportado, de la misma carpeta la ruta al de la version superior
		------------------------------------------------------------------------------	
		fn getHighestVersionPath _path = 
		(
			-- obtengo el numero de version de la ruta
			_fileParts = filterString _path "_"
			_currVersion = _fileParts[_fileParts.count]
			_currVersion = (FilterString _currVersion ".")[1]
			_currVersion = substituteString _currVersion "v" ""

			-- rehago la ruta de nuevo como patron
			_fileParts[_fileParts.count] = "v??.prt"
			_FilePattern = lb.str.join _fileParts "_"

			-- Obtengo los archivos que siguen ese patron
			_Files = getFiles _FilePattern

			-- Obtenemos de la lista la que tenga la version más grande
			_highestVersion = "00"
			for _File in _Files do
			(
				_fileParts = FilterString _File "_"
				_FileVersion = (FilterString _fileParts[_fileParts.count] ".")[1]
				_FileVersion = substituteString _FileVersion "v" ""
				if (_FileVersion as integer) > (_highestVersion as integer) do 
					_highestVersion = _FileVersion
			)

			-- obtengo la ruta del archivo mayor
			if _highestVersion != "00" then
			( 
				_fileParts[_fileParts.count] = "v" + _highestVersion +".prt"
				_assetPath = lb.str.join _fileParts "_"
			)
			else 
				_assetPath = ""

			_assetPath

		)

		------------------------------------------------------------------------------
		--@fn:  undefined | createTreeViewNodes | Crea todos los nodos del treeView a partir de la ruta inicial indicada en FOLDERS. Cada nodo equivale a una carpeta. 
		------------------------------------------------------------------------------	
		fn createTreeViewNodes treeNodeCollection paths  = 
		(
			for _path in paths do
			(
				--Saco en un array las partes del directorio
				_pathParts = filterstring _path "\\"
				
				--Cogemos el nombre de la carpeta actual
				_pathName =  _pathParts[_pathParts.count]

				-- Obtenemos el nodo nuevo para el arbol
				_newNode = dotnetObject "System.Windows.Forms.TreeNode" _pathName
				_newNode.name = _path
				treeNodeCollection.add _newNode

				-- Si estamos dentro de una carpeta de personaje, nos metemos en Version -> Preset , directamente			
				if (doesFileExist (_path + "\\" + lb.nc.NC_versionFolderName)) then
				(
					-- Obtengo el item de la lista de personajes que le corresponde, si lo hay.
					currentChar = undefined
					i = 1
					while i <= _charList.count and currentChar == undefined do 
					(
						_char = _charList[i]
						if (MatchPattern _char.char.fullname pattern:(_pathName + "*")) do 
							currentChar = _char

						i += 1
					)

					-- Saco la lista de items de ultima version para añadir al arbol y a la lista de relacionados
					filesBetter = #()
					_presetFilesPath = _path + "\\" + lb.nc.NC_versionFolderName + "\\" + lb.nc.NC_presetFolderName + "\\*_anim_*.prt"
					files = getFiles (_presetFilesPath)
					for file in files do 
					(
						_highestVersionPath = getHighestVersionPath file
						if _highestVersionPath != "" do 
						(
							if appendIfUnique filesBetter _highestVersionPath do 
							(
                                -- Si tenemos un personaje asociado, añadimos a la lista de relacionados los que hay dentro
								if currentChar != undefined do 
								(
									--Cogemos el nombre del archivo
									_pathParts = filterstring _highestVersionPath "\\"
									_fileName = _pathParts[_pathParts.count]

                                    -- Construimos el nombre base del personaje actual (ej: chr_amy)
									_baseName = (filterString _fileName "{}")[2]

									-- Creamos una pareja de datos para meter en la lista relacionados del personaje
									_newItem = _charListItemData charName:_baseName charPath:_highestVersionPath
									
									-- Lo añadimos a la lista de relacionados
									append currentChar.relatedChars _newItem
								)
							)
						)
					)
					
					-- Añadimos los nodos hoja en el siguiente paso de recursion
					createTreeViewNodes _newNode.nodes filesBetter

				)

				-- Si no estamos en una carpeta de personaje, seguimos bajando
				else
				(
					_subDirs = getFolderDirectories (_path + "*")
					createTreeViewNodes _newNode.nodes _subDirs
				)
			
			)
		)

		------------------------------------------------------------------------------
		--@fn: undefined | initList | Inicializa las listas con parametros comunes a todas
		------------------------------------------------------------------------------
		fn initList list multiselection =
		(
			lv = list
			lv.columns.clear()
			lv.multiSelect = multiselection
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.HideSelection = off
			lv.BackColor = (dotnetclass "System.Drawing.SystemColors").Menu
			lv.scrollable = true
			lv.labelWrap = True
			lv.labelEdit = false
			lv.columns.add "lista" lv.width
			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").None
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | updateCharacterStructsAndUI | Actualiza el arbol con todos los items de disco descargados en asset y las listas de relacionados
		------------------------------------------------------------------------------
		fn updateCharacterStructsAndUI =
		(
			--Limpiamos los nodos del árbol para poder volver a rellenarlos, y la otra lista, por si acaso
			_fullCharTree.nodes.clear()
			
			-- Limpiamos la lista de relacionados visual
			_relatedCharList.items.clear()

			-- Liberamos solamente las listas de personajes relacionados
			for _char in _charList do 
			(
				free _char.relatedChars
				_char.relatedChars = #()
			)

			--Cogemos los directorios del path inicial salvo el de .svn
			_dirs = getFolderDirectories (_charsFolder + "*")
			
			--Rellenamos los nodos del arbol con los directorios que hemos cogido antes
			createTreeViewNodes _fullCharTree.nodes _dirs
		)


		------------------------------------------------------------------------------
		--@fn: undefined | updateCameraList | Actualiza la lista de cámaras con las que hay actualmente en la escena
		------------------------------------------------------------------------------
		fn updateCameraList =
		(
			_cameraListView.items.clear()
			_camLinkageList = #()

			for item in cameras do 	
			(	
				if (classof item != Targetobject) do
				(	
					-- Creamos una estructura de datos para la camara
					info = camLinkageInfo cam:item.name
					append _camLinkageList info

					-- Creamos el elemento de la lista
					_cameraListView.items.add item.name
				)
			)
		)

		------------------------------------------------------------------------------
		--@fn: undefined | updateCharacterList | Carga la lista de personajes actualmente en la escena
		------------------------------------------------------------------------------
		fn updateCharacterList = 
		(
			free _charList
			_charList = #()

			charList = lb.asset.getSceneAssets type:lb.nc.NC_chrPrefix
			for ch in charList do 
			(
				newCharItem = _charListItem char:ch relatedChars:#() -- La lista se rellenara al actualizar el arbol
				append _charList newCharItem
			)

			-- hacemos una copia de los nombres de los personajes actuales
			_oldCharsList = #()
			for i = 0 to _charListView.items.count - 1 do 
			(
				_item = _charListView.items.item[i]
				append _oldCharsList _item.text
			)

			-- Vacio y relleno de nuevo la lista de personajes
			_charListView.items.clear()
			for item in _charList do 
				_charListView.items.add (item.char).fullname

			-- Comprobamos si se ha eliminado alguno. En ese caso puede haber errores y hay que avisarlo
			for char in _oldCharsList do 
			(
				charFound = False
				-- miramos si el elemento esta en la lista. No podemos comparar con ==
				for i = 0 to _charListView.items.count - 1 do
				(
					_item = _charListView.items.item[i]
					if _item.text == char do 
						charFound = True
				)

				if not charFound do 
					addToLog ("Character " + char + " deleted. Please reopen the tool, updating information of deleted characters is still not supported.")
			)

			-- Hay que recargar las listas de personajes relacionados
			updateCharacterStructsAndUI()

		)

		------------------------------------------------------------------------------
		--@fn: undefined | updateLinkedList | Actualiza la lista de conexiones entre personajes de layout y animacion para la/s camaras seleccionadas
		------------------------------------------------------------------------------
		fn updateLinkedList =
		(
			-- Vaciar la lista en la interfaz
			_linkedListView.items.clear()

			-- Si hay solo una camara seleccionada
			_selCams = _cameraListView.selectedItems
			if _selCams.count == 1 then
			(
				-- Obtenemos la informacion de la camara seleccionada
				_camInfo = getLinkageInfoFromCam _selCams.item[0].text

				-- Para cada elemento de la lista
				for link in _camInfo.linkList do 
				(
					-- TODO : hacer esto con funciones comunes: "From path to filename"
					_animChar = (filterstring (link.animation) "\\") --obtenemos lista
					_animChar = _animChar[_animChar.count] -- Obtenemos el nombre del archivo
					_animChar = (Filterstring(_animChar) "_")[2]
				
					_layoutChar = (filterstring (link.layout) "_")[2]
					_newLink = (_layoutChar + "<-->" + _animChar)
					_linkedListView.items.add _newLink
				)

			)
			else if _selCams.count > 1 then 
			(
				_text = "Multiple camera."
				_linkedListView.items.add _text
				_text = "Any modification will edit all cameras."
				_linkedListView.items.add _text
			)
		
		)

		------------------------------------------------------------------------------
		--@fn: undefined | exportCam | Realiza las tareas de exportacion para la camara pasada. True si salio bien, false si no.
		------------------------------------------------------------------------------
		fn exportCam cam = 
		(
			_camLinksInfo = (getLinkageInfoFromCam cam)

			_cam = execute ("$'" + cam + "'")
			_skip = true

			-- Create animation file (same export as the camera sequencer)
			if _overwriteRadioBtn.state == 2 do
				_skip = false

			-- Exportar la camara
			res = lb.cameraFunctions.exportLayoutCameraToAnim _cam ignoreChecked:true returnErrorLog:true skipExisting:_skip
			if res != "" then 
			( 
				addToLog res 
				return false
			)
			
			-- Creamos las rutas para poder cargar el archivo actual y el de animacion
			_basePath = substituteString maxFilePath "\\layout\\" ("\\cam\\" + (substituteString cam "_" "") + "\\")
			_filenameParts = filterstring maxFileName "_" -- #("seq", "030d-frank", "layout.max")
			_layoutFileName = maxFilePath + "\\" + maxFileName 
			_animFileName = _basePath + "anim\\" + _filenameParts[1] + "_" + _filenameParts[2] + "_" + (substituteString cam "_" "") + "_" +  lb.nc.NC_animFileName + ".max"

			-- Abre el archivo de animacion que acaba de crear para modificarlo
			-- comprobar si existe el archivo aun habiendo finalizado el proceso correctamente
			if not doesFileExist _animFileName do 
			(
				addToLog "IMPORTANT ERROR: File does not exist but process ended successfully!."
				addToLog _animFileName
				return false
			)

			-- Cargo el archivo de animacion que creamos			
			print ("Loading animation file " + _animFileName)
			loadMaxFile _animFileName quiet:true

			-- Empezamos las tareas en el archivo de animacion
			lb.lights.deleteAllLights()
			blockCameras()
			deleteEmptyLayers()
			importAudios()
			loadCharacters _camLinksInfo.linkList

			-- Guarda el archivo que acabamos de modificar
			print ("Saving animation file " + _animFileName) -- para que el usuario sepa lo que esta pasando
			saveMaxFile _animFileName quiet:true

			-- Regresamos al archivo de layout para volver al estado original y continuar
			print ("Returning (reloading) layout file " + _layoutFileName) -- para que el usuario sepa lo que esta pasando
			loadMaxFile _layoutFileName quiet:true
		
			return true
		)

		fn createPresetTempFiles charPaths = 
		(
			-- Recargamos la escena porque despues del proceso se pierde donde estabamos
			_currentScenePath = maxFilePath + maxFileName 

			for charPath in charPaths do 
			(
				animCharName = getCharNameFromPath charPath
				print ("Generating temp file for char: " + animCharName)

				res = lb.presets.savePresetInTempMaxFile charPath overwrite:(not _chkKeepLastTempPresets.checked)

				if not res do 
					addToLog("Error generating file. Please check console for more info...")
			)

			-- Vaciamos la escena
			resetMaxFile(#noPrompt)

			-- Recargamos la escena anterior si es posible
			if doesFileExist _currentScenePath do
				loadMaxFile _currentScenePath quiet:true
		)

		fn updateLinkButtons = 
		(
			camSelected = _cameraListView.selectedItems.count > 0
			charSelected = _charListView.selectedItems.count > 0
			relatedTabOpened = _tbCharListTabs.selectedIndex == 0
			selectedItemsInRelatedTab = _relatedCharList.selectedItems.count == 1
			selectedItemsInFullList = _fullCharTree.selectedNode != undefined


			_addBtn.enabled = camSelected and charSelected and ( (relatedTabOpened and selectedItemsInRelatedTab) or (not relatedTabOpened and selectedItemsInFullList) )
			_deleteBtn.enabled = camSelected and charSelected
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
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
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
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
		
			initList _cameraListView True
			_cameraListView.Sorting = (dotNetClass "System.Windows.Forms.SortOrder").Ascending
			_cameraListView.CheckBoxes = true
		
			_tbCharListTabs.itemSize = dotNetObject "System.Drawing.Size" 200 20
			_tbCharListTabs.padding = dotNetObject "System.Drawing.Point" 40
			_tbCharListTabs.tabPages.add "Related Presets"
			_tbCharListTabs.tabPages.add "All Characters"
			_tbCharListTabs.tabPages.item[0].width = 200
			_tbCharListTabs.tabPages.item[1].width = 200
			_tbCharListTabs.SelectedIndex = 0

			initList _charListView True
			initList _relatedCharList False
			initList _linkedListView False
			_fullCharTree.HideSelection = off

			-- Añadimos a cada tab su contenido
			_tbCharListTabs.tabPages.item[0].Controls.add _relatedCharList
			_tbCharListTabs.tabPages.item[1].Controls.add _fullCharTree
	
			_log.Clear()
			_log.Multiline = True
			_log.ScrollBars = (dotNetClass "System.Windows.Forms.ScrollBars").Vertical
			_log.ReadOnly = True
			_log.WordWrap = True
		
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		
			updateCharacterList()
		
			-- OJO: EL UPDATE DE CAMARAS DEBE IR DESPUES DE LA CARGA DE PERSONAJES
			updateCameraList() 
		
			-- Desactivo el boton de añadir link si no hay camaras seleccionadas
			_addBtn.enabled = false
			_deleteBtn.enabled = false

			-- no podemos desactivar y activar el boton porque no hay evento para cambiar el estado check de algun item de la lista de cams
			--_exportBtn.enabled = false
			
			updateCharacterStructsAndUI()
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

		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef resized size do
		(
			resize size
		)

		------------------------------------------------
		--@event: selectIndexChanged | Evento que se lanza al cambiar la seleccion en la lista de camaras
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on _cameraListView SelectedIndexChanged events do
		(
			-- Desactivo el boton de anyadir link si no hay camaras seleccionadas
			updateLinkButtons()
				
			-- Movemos al principio del rango para esa camara si solo hay una seleccionada
			if (_cameraListView.selectedItems.count == 1) do 
			(
				cam = _cameraListView.selectedItems.item[0].text
				camNode = getNodeByName cam
				if (lb.camerafunctions.hasCamInfo camNode) then
				(
					lb.cameraFunctions.setViewportCamera viewport.activeViewport camNode
					lb.cameraFunctions.setAnimRangeFromCamera camNode goToStart:true
				)
				else 
					addToLog "Warning: Camera has no recStart parameter. Characters will be put in a wrong position for this camera in the animation file."
			)

			-- mostrar informacion de linkado segun la camara
			updateLinkedList()
		)

		on _cameraListView DoubleClick events do 
		(
			if (_cameraListView.selectedItems.item[0] != undefined) do 
			(
				_camName = _cameraListView.selectedItems.item[0].text
				_camNum = (filterstring _camName "_")[2]
				_path = maxFilePath + "..\\cam\\cam" + _camNum + "\\anim\\"

				if (doesFileExist _path) do
					ShellLaunch "explorer.exe" _path
			)
		)

		on _charListView SelectedIndexChanged events do
		(
			-- Vaciamos la lista de personajes relacionados en cualquier caso
			_relatedCharList.items.clear()

			-- Movemos al principio del rango para esa camara si solo hay una seleccionada
			if (_charListView.selectedItems.count == 1) do 
			(
				-- obtengo el personaje
				char = _charListView.selectedItems.item[0].text

				-- busco el item en la lista de relacionados
				for item in _charList do 
				(
					if item.char.fullname == char do 
					(
						for relatedChar in item.relatedChars do 
						(
							newItem = dotNetObject ("System.Windows.Forms.ListViewItem") relatedChar.charName -- el nombre del item es el nombre del personaje
							newItem.name = relatedChar.charPath -- guardamos oculto el path junto al item
							_relatedCharList.items.add newItem -- Lo añadimos a la lista de la UI
						)
					)
				)

			)

			updateLinkButtons()
		)	

		on _relatedCharList SelectedIndexChanged events do
		(	
			updateLinkButtons()
		)

		on _exportBtn pressed do
		(
			_currentScenePath = maxFilePath + maxFileName

			-- Si no tenemos rutas, no funcionara el proceso
			if maxFilePath == undefined do 
				false 

			-- Limpio la seleccion de la lista de camaras para que se vea el resultado de colores claramente al terminar
			_cameraListView.selectedItems.clear()

			-- comprobamos el salvado del archivo
			_needsSave = getSaveRequired()
			_saveNow = false

			if _needsSave then 
				_saveNow = lb.message.show "File is not saved. Do you want to save now?" type:#query modal:true
			
			if _saveNow then
				if not (saveMaxFile (maxFilePath + maxFileName)) do
					return undefined

			-- Inicializo texto que se muestra en el log
			_log.text = ""
			addToLog ("Export process started... " + localTime)
		    
		    -- Creamos una carpeta de log nueva para ir guardando los logs de este proceso
			createNewLogPath()
			saveSettingsToLogFolder()

			-- Obtenemos las camaras que estan marcadas con check
			_checkedCams = _cameraListView.checkedItems
			_checkedCamsCount = _checkedCams.count - 1

			setWaitCursor()

			----------------------------------------------------------------------------------------------
			-- CREACION DE ARCHIVOS TEMPORALES PARA LOS PERSONAJES para acelerar la carga haciendo merge en vez de import
			----------------------------------------------------------------------------------------------

			if _chkUseTempPresets.checked do
			(
				addToLog ("Generating temp files to speed up preset load... ")

				_time = timeStamp()

				-- Vacio la carpeta temporal para que los personajes se actualicen la primera vez que se importan
				if not _chkKeepLastTempPresets.checked do 
					lb.presets.purgePresetTempFile()

				_charListPath = #()
				for i = 0 to _checkedCamsCount do
				(
					camItem = _checkedCams.item[i]

					-- Obtenemos info de la camara actual
					linkageInfo = (getLinkageInfoFromCam camItem.text)

					-- Guardamos los path a presets a cargar unicos en la lista
					for link in linkageInfo.linkList do 
						appendIfUnique _charListPath link.animation
				)

				-- Crea la lista de personajes temporales. Este proceso es lento.
				createPresetTempFiles _charListPath

				-- volvemos a escribir sobre el tiempo tardado
				_time = (( timeStamp() - _time ) / 1000.0 ) / 60.0
				addToLog ("Process took " + (_time as string) + " minutes")

			) 

			-------------------------------------------------
			-- EXPORTACION DE LAS CAMARAS UNA A UNA
			-------------------------------------------------

			_cancelExport = false

			-- Mientras no se cancele la exportacion 
			-- Visitamos camara a camara exportando cada una
			for i = 0 to _checkedCamsCount where not _cancelExport do
			(
				exportOK = true

				addLogSeparator()

				-- Obtenemos info de la camara actual
				camItem = _checkedCams.item[i]
				camName = camItem.text

				-- Añadimos datos del tiempo actual
				addToLog localTime
				_time = timeStamp()
				addToLog (camItem.text + "\n")

				-- si existe la camara la exportamos
				_cam = execute ("$'" + camName + "'")
				if _cam != undefined then
				(
					res = exportCam camName
					if not res do 
						exportOK = false
				)
				else 
				(
					addToLog (camName + " not existing.")
					exportOK = false
				)
				
				-- Segun el resultado de la exportacion cambia el color de la camara
				if exportOK then 
				(
					camItem.BackColor = cameraExportedColor
					addToLog "\nExport OK\n"
				)
				else 
				(
					camItem.BackColor = cameraFailedColor
					addToLog "\nFailed Export.\n"
				)

				-- volvemos a escribir sobre el tiempo tardado
				_time = (( timeStamp() - _time ) / 1000.0 ) / 60.0
				addToLog ("Process took " + (_time as string) + " minutes")

				-- guardamos todo el texto para esta camara y las anteriores
				-- en un archivo para evitar que se pierda la informacion
				-- en mitad del proceso en un error
				saveLogToFile()

				-- comprobamos que la tecla escape no esté pulsada justo ahora
				if keyboard.escPressed do 
					_cancelExport = queryBox "Cancel export process?"
			
				if _cancelExport do 
				(
					addLogSeparator()
					addToLog ("\nProcess cancelled... " + localTime)
				)

			)

			setArrowCursor()	
		
			addLogSeparator()
		
			addToLog ("\n\nExport process finished..." + localTime)

			-- Vacio la carpeta temporal para que los personajes se actualicen la primera vez que se importan
			--if not _chkKeepLastTempPresets.checked do 
			--	lb.presets.purgePresetTempFile()

			-- Hacemos el último salvado, si hemos llegado hasta el final sin errores
			saveLogToFile()
		
		)
		on _helpBtn pressed do
		(
			ShellLaunch "C:\\Program Files\\Internet Explorer\\iexplore.exe" @"http://www.toolslb.com/doku.php?id=tools:preanimcomposer"
			--shellLaunch "chrome.exe" @"http://www.toolslb.com/doku.php?id=tools:preanimcomposer"
		)

		on _updateCharBtn pressed do 
		(
			updateCharacterList()
			updateLinkedList()
		)

		on _addBtn pressed do
		(
			_errorText = "Error: Please select one item from the characters from the current scene, and one from the available characters to make a link."
		
			-- Si hay al menos algun elemento de la lista de personajes elegido
			if  _charListView.selectedItems.count > 0 then  
			(
				_animChar = ""
				_animCharPath = ""

     			-- Si estamos en el modo de la lista de assets relacionados solamente
				if _tbCharListTabs.selectedIndex == 0 and _relatedCharList.selectedItems.count > 0 then 
				(
					_animChar = _relatedCharList.selectedItems.item[0].text
					_animCharPath = _relatedCharList.selectedItems.item[0].name
				)

				-- Si estamos en el modo del arbol completo
				else if _tbCharListTabs.selectedIndex != 0 and _fullCharTree.selectedNode != undefined then 
				(
					_animChar = _fullCharTree.selectedNode.text
					_animCharPath = _fullCharTree.selectedNode.name
				)
	
				-- Si tenemos una ruta correcta para el personaje 
				if ( MatchPattern _animCharPath pattern:"*_anim_*.prt") then --or ( _animChar == _noneText ) then
				(
					-- Para cada camara seleccionada
					_selIts = _cameraListView.selectedItems
					counter = _selIts.count - 1
					for i = 0 to counter do 
					(
		                --Obtenemos la camara
						_cam = _selIts.item[i].text
					
						-- Si hay varias camaras seleccionadas 
						-- movemos al principio del rango para esta camara
						if (_selIts.count > 1) do --and (_animChar != _noneText) do 
						(		
							camNode = getNodeByName _cam
							if (lb.camerafunctions.hasCamInfo camNode) then
							(
								lb.cameraFunctions.setViewportCamera viewport.activeViewport camNode
								lb.cameraFunctions.setAnimRangeFromCamera camNode goToStart:true
							)
							else 
								addToLog "Warning: Camera has no recStart parameter. Character will be moved to a wrong position for this camera after export."
						)

						-- Para cada personaje seleccionado
						for i = 0 to _charListView.selectedItems.count - 1 do 
						(
							_layoutCharFullName = _charListView.selectedItems.item[i].text
							updateCharLinkInCam _cam _layoutCharFullName _animCharPath
						)
					)

					updateLinkedList()
				)
				else 
					addToLog _errorText
			)
			else 
				addToLog _errorText	

			updateLinkButtons()
		)

		-- Para borrar un enlace entre un personaje y otro
		on _deleteBtn pressed do 
		(
			_selIts = _cameraListView.selectedItems

			-- Para cada camara seleccionada
			for i = 0 to _selIts.count - 1 do 
			(
				_cam = _selIts.item[i].text

	      		-- para cada personaje seleccionado
				for i = 0 to _charListView.selectedItems.count - 1 do 
				(
					_layoutCharFullName = _charListView.selectedItems.item[i].text
					
					-- Le decimos que no lo enganche
					updateCharLinkInCam _cam _layoutCharFullName _noneText
				)
			)

			updateLinkedList()
			updateLinkButtons()
		)
		

	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_preanimComposer
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Herramienta para exportar camaras y montar una escena de pre-anim",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
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


		
	)--tl_templateTool
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_preanimComposer() --crea la herramienta
)