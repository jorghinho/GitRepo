------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de svn
------------------------------------------------------------------------------------------------------------------------------------------------
(
	struct str_svnInfo
	(
		path = "",
		type = "file",
		state = ""
	)--str_svnInfo

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de svn.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_svn
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria svn",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		svnInfo = str_svnInfo,

		svnRepositoryPath = "https://lbdata001/svn",

		--svnExe = "\"" + lb.config.getExePath() + "svn_188\\svn.exe\"",
		--svnExe = "svn",
		--svnExe = @"R:\resource\technical\utilities\X001_svn\svn.exe",
		svnExe = "C:\\winapp\\3d\\\"3ds Max 2014\"\\stdplugs\\stdscripts\\lbTools\\exe\\svn_188\\svn.exe", --�nica forma que he encontrado para que funcione

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
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		--------------------------------------------------------------------------------------------------------------- 
		--devuelve TRUE si el folder ha conseguido hacer un cleanup, si no devuelve FALSE
		--------------------------------------------------------------------------------------------------------------- 
		fn svnFolderCleanup folder donotwait:false sleepTime:0.5 =
		(
			err = 0
			HiddenDOSCommand (this.svnExe + " cleanup " + folder) donotwait:donotwait ExitCode:&err
			if donotwait then sleep sleepTime
			err == 0
		),
		
		--------------------------------------------------------------------------------------------------------------- 
		--devuelve TRUE si el folder esta versionado, si no devuelve FALSE
		
		--SLEEPTIME: tiempo de espera inicial antes de coprobar la salida del fichero de svn.
		--TIMEOUT: tiempo m�ximo de espera para SVN
		--CHECKTIMEINTERVAL: tiempo de espera entre comprobaciones de si svn ha terminado de devolver la informacion
		--------------------------------------------------------------------------------------------------------------- 
		fn svnIsFolderVersioned folder donotwait:false sleepTime:0.5 timeout:30.0 checkTimeInterval:0.5 /*statusInfo:undefined*/ =
		(
			_versioned = false
			
			if statusInfo != undefined then
			(
				_status = this.svnGetFileStatus folder donotwait:donotwait sleepTime:sleepTime timeout:timeout checkTimeInterval:checkTimeInterval statusInfo:statusInfo
				_versioned = (_status != "?") and (_status != "-")
			)
			else
			(
				err = 0
				HiddenDOSCommand (this.svnExe + " info " + folder) donotwait:donotwait ExitCode:&err
				if donotwait then sleep sleepTime
					
				_versioned = (err == 0)
			)
			
			_versioned
		),
		
		--------------------------------------------------------------------------------------------------------------- 
		--devuelve TRUE si el fichero esta versionado, si no devuelve FALSE
		
		--SLEEPTIME: tiempo de espera inicial antes de coprobar la salida del fichero de svn.
		--TIMEOUT: tiempo m�ximo de espera para SVN
		--CHECKTIMEINTERVAL: tiempo de espera entre comprobaciones de si svn ha terminado de devolver la informacion
		--------------------------------------------------------------------------------------------------------------- 
		fn svnIsFileVersioned file donotwait:false sleepTime:0.5 timeout:30.0 checkTimeInterval:0.5 statusInfo:undefined =
		(
			_versioned = false
	 		
			if statusInfo != undefined then
			(
				_status = this.svnGetFileStatus file donotwait:donotwait sleepTime:sleepTime timeout:timeout checkTimeInterval:checkTimeInterval statusInfo:statusInfo
				_versioned = (_status != "?") and (_status != "-")
			)
			else
			(
				err = 0
				HiddenDOSCommand (this.svnExe + " info " + file) donotwait:donotwait ExitCode:&err
				if donotwait then sleep sleepTime
				_versioned = (err == 0)
			)
			
			_versioned
		),
		
		---------------------------------------------------------------------------------------------------------------
		--devuelve el estado de los archivos del interior del FOLDER pasado por parametro
		--devuelve un array de structs svnstruct con los archivos o subcarpetas de dentro del folder y su estado
		--Estados que puede devolver de cada archivo de la carpeta
		-- A: File to be added
		-- C: Conflicting changes
		-- D: File to be deleted
		-- G: File to be merged with updates from server
		-- M: File has been modified
		-- R: File to be replaced
		-- G: File to be merged
		-- K: File locked
		-- X: Resource is external to repository (svn:externals)
		-- ?: File/directory not under version control
		-- !: File/directory missing
		-- ~: Versioned item obstructed by some item of a different kind.
		
		--SLEEPTIME: tiempo de espera inicial antes de coprobar la salida del fichero de svn.
		--TIMEOUT: tiempo m�ximo de espera para SVN
		--CHECKTIMEINTERVAL: tiempo de espera entre comprobaciones de si svn ha terminado de devolver la informacion
		---------------------------------------------------------------------------------------------------------------
		fn svnGetFolderStatus folder donotwait:true sleepTime:0.5 timeout:30.0 checkTimeInterval:0.5 =
		(
			_statusArray = #() --variable donde almacenar los estados
			err = 0
			
			--ruta del archivo de salida de informacion
			cmdOutFile = (getDir #maxroot) + "\\stdplugs\\stdscripts\\lbTools\\log\\hiddencmdout.tmp"
			
			if doesFileExist cmdOutFile then
			(
				HiddenDOSCommand ("taskkill /IM \"svn.exe\" /F /T")
				deleteFile cmdOutFile
			)--if doesFileExist cmdOutFile
			
			if not doesFileExist cmdOutFile then
			(--print (this.svnExe + " status -u " + folder + " > \"" + cmdOutFile + "\"")
				--obtiene el estado y lo almacena en hiddencmdout.tmp
				HiddenDOSCommand (this.svnExe + " status -u " + folder + " > \"" + cmdOutFile + "\"") donotwait:donotwait ExitCode:&err
				if donotwait then sleep sleepTime
				
				_start = timeStamp()
				_writeFinish = false
				
				--hace un loop de espera hasta que svn ha terminado de escribir el log
				if donotwait then
					while (not _writeFinish) and ((timeStamp() - _start) < (timeout*1000.0)) do
					(
						_f = openFile cmdOutFile mode:"r" --abre el archivo para ver si se ha terminado de escribir
						
						if _f != undefined then --si lo consigue abrir
						(
							--obtiene la ultima linea
							_lastLine = ""
							while not eof _f do _lastLine = readline _f
							close _f
							
							--si ha terminado de escribirlo para el while, si no, hace un sleep
							if matchPattern _lastLine pattern:"Status against revision:*" then
								_writeFinish = true
							else
								sleep checkTimeInterval
						)--si no lo consigue abrir espera el intervalo
						else sleep checkTimeInterval
					)--while
				
				HiddenDOSCommand ("taskkill /IM \"svn.exe\" /F /T")
				
				if donotwait and not _writeFinish do err = -1 --si ha saltado el timeout antes de que svn termine de devolver la informacion, no la lee porque ser� err�nea.
				
				if err == 0 then -- si no ha fallado
				(
					fstream = openFile cmdOutFile mode:"r" --abre el archivo para leerlo
					
					if fstream != undefined then
					(
						while not eof fstream do
						(
							_currLine = readLine fstream
							
							--print _currLine
							if not matchPattern _currLine pattern:"Status against revision:*" and not matchPattern (tolower _currLine) pattern:"*thumbs.db" then --si no es la linea final
							(
								_lineParts = filterString _currLine " "
								
								if _lineParts.count != 0 then
								(
									_status = (filterString _lineParts[1] " ")[1]
									
									--ANTES---------------------------------------------------------------------------------------
									--Estabamos tratando la O como estado desconocido, cuando en realidad es que alguien lo tiene bloqueado
			 								--case _status of --casos especiales de estado
			 								--(
			 								--	"O": _status = ""
			 								--)--case
			 								
			 								--_path = _lineParts[_lineParts.count]
			 								--_type = if getFileNameType _path == "" then "folder" else "file"
			 								
			 								--append _statusArray (this.svnInfo path:_path type:_type state:_status)
									--------------------------------------------------------------------------------------------------
									
									--AHORA----------------------------------------------------------------------------------------
									--si es O, es porque alguien lo tiene bloqueado, por eso de momento lo ignoramos
									if _status != "O" then
									(
										--Para hallar la ruta buscaremos la primera contrabarra y si lo que hay antes es otra ser� una ruta de red y la sacaremos desde all�, si son dos puntos
										--lo sacaremos desde un caracter antes (ruta local).
										if _currLine[((findString _currLine "\\") - 1)] == "\\" then
										(
											_path = subString _currLine ((findString _currLine "\\") - 1) _currLine.count
										)
										else
										(
											_path = subString _currLine ((findString _currLine "\\") - 2) _currLine.count
										)
										
										_type = if getFileNameType _path == "" then "folder" else "file"
										
										append _statusArray (this.svnInfo path:_path type:_type state:_status)
									)--if
									--------------------------------------------------------------------------------------------------
								)-- if _index
							)
						)--while
						
						close fstream --cierra el archivo
						
						--si el array esta vacio y el folder versionado, lo almacena como actualizado
						if _statusArray.count == 0 and (this.svnIsFolderVersioned folder) then
							append _statusArray (this.svnInfo path:folder type:"folder" state:"U")
						else --si no esta vacio pero no est� el
						(
							_found = false
							for sta in _statusArray where sta.type == "folder" and (tolower sta.path) == (tolower folder) do _found = true
							if not _found then append _statusArray (this.svnInfo path:folder type:"folder" state:"U")
						)
					)--if stream
				)--if
			)--if not doesFileExist
			
			deleteFile cmdOutFile --intenta eliminar el archivo		
			_statusArray --devuelve los estados
		),
		
		---------------------------------------------------------------------------------------------------------------
		--devuelve el estado del archivo segun subversion
		--devueleve un string
		--Estados que puede devolver de cada archivo
		-- -: Doesnt exist
		-- ?: Non versioned
		-- *: Server changes
		-- U: Updated
		-- A: File to be added
		-- C: Conflicting changes
		-- D: File to be deleted
		-- G: File to be merged with updates from server
		-- M: File has been modified
		-- R: File to be replaced
		-- K: File locked
		-- X: Resource is external to repository (svn:externals)
		-- ?: File/directory not under version control
		-- !: File/directory missing
		-- ~: Versioned item obstructed by some item of a different kind.
		--
		--STATUSINFO: si no se quiere que la funcion busque la informacion del archivo en subversion porque para su folder ya se ha preguntado antes, le podemos pasar esa informacion por parametro
		
		--SLEEPTIME: tiempo de espera inicial antes de coprobar la salida del fichero de svn.
		--TIMEOUT: tiempo m�ximo de espera para SVN
		--CHECKTIMEINTERVAL: tiempo de espera entre comprobaciones de si svn ha terminado de devolver la informacion
		---------------------------------------------------------------------------------------------------------------
		fn svnGetFileStatus file donotwait:true sleepTime:0.5 timeout:30.0 checkTimeInterval:0.5 statusInfo:undefined =
		(
			_status = undefined --variable donde almacenar el estado
			
			if statusInfo == undefined then --si no se ha suministrado informacion de svn, hay que buscarla
				statusInfo = this.svnGetFolderStatus (getFilenamePath file) donotwait:donotwait sleepTime:sleepTime timeout:timeout checkTimeInterval:checkTimeInterval
			
			if not doesFileExist file then
			(
				_status = "-"
				
				for sti in statusInfo where _status == "-" and (tolower sti.path) == (tolower file) do
					_status = sti.state
			)
			else if statusInfo.count != 0 then
			(
				_status = ""
				
				for sti in statusInfo where (tolower sti.path) == (tolower file) do
					_status = sti.state
				
				for sti in statusInfo where _status == "" and (sti.type == "folder") and (matchPattern (tolower file) pattern:((tolower sti.path) + "*")) do
					_status = sti.state
				
				--for sti in statusInfo where _status == "" and (sti.type == "file") and (matchPattern (tolower file) pattern:((tolower (getFilenamePath sti.path)) + "*")) do
				--	_status = "U"
			)
			else --si no hay informacion es porque no est� versionado
			(
				if not this.svnIsFileVersioned file then
					_status = "?"
				else
					_status = "U"
			)
			
			_status --devuelve el estado
		),

		--------------------------------------------------------------------------------------------------------------- 
		--devuelve TRUE si el folder esta actualizado
		--si no est� actualizado devuelve FALSE
		
		--SLEEPTIME: tiempo de espera inicial antes de coprobar la salida del fichero de svn.
		--TIMEOUT: tiempo m�ximo de espera para SVN
		--CHECKTIMEINTERVAL: tiempo de espera entre comprobaciones de si svn ha terminado de devolver la informacion
		---------------------------------------------------------------------------------------------------------------
		fn isFolderUpdated folder donotwait:true sleepTime:0.5 timeout:30.0 checkTimeInterval:0.5 statusInfo:undefined =
		(
			if doesFileExist folder then
			(
				_updated = true
				--si no se ha suministrado informacion de svn, hay que buscarla
				if statusInfo == undefined then statusInfo = this.svnGetFolderStatus folder donotwait:donotwait sleepTime:sleepTime timeout:timeout checkTimeInterval:checkTimeInterval
				for _si in statusInfo where _updated and (findString "AUDM?" _si.state == undefined) do _updated = false --averigua si esta actualizado
			)
			else
			(
				_updated = false
			)

			_updated
		),

		--------------------------------------------------------------------------------------------------------------- 
		--devuelve TRUE si el fichero esta actualizado
		--si no est� actualizado devuelve FALSE
		--si hay algun otro conflicto devuelve UNDEFINED
		
		--SLEEPTIME: tiempo de espera inicial antes de coprobar la salida del fichero de svn.
		--TIMEOUT: tiempo m�ximo de espera para SVN
		--CHECKTIMEINTERVAL: tiempo de espera entre comprobaciones de si svn ha terminado de devolver la informacion
		--------------------------------------------------------------------------------------------------------------- 
		fn svnIsFileUpdated file donotwait:true sleepTime:0.5 timeout:30.0 checkTimeInterval:0.5 statusInfo:undefined =
		(
			_updated
			
			_status = this.svnGetFileStatus file donotwait:donotwait sleepTime:sleepTime timeout:timeout checkTimeInterval:checkTimeInterval statusInfo:statusInfo
			_updated = (findString "UAMK" _status) != undefined
			
			_updated
		),
		
		---------------------------------------------------------------------------------------------------------------
		--intenta hacer un lock en un archivo.
		--devuelve TRUE si lo consigue y FALSE sino
		---------------------------------------------------------------------------------------------------------------
	 	fn svnLockFile file donotwait:false sleepTime:0.5 =
		(
			err = 0
			HiddenDOSCommand (this.svnExe + " lock \"" + file +"\"") donotwait:donotwait ExitCode:&err
			if donotwait then sleep sleepTime
			(err == 0) and not (getFileAttribute file #readOnly) --comprueba que no ha habido errores y que el archivo se ha bloqueado
		),
		
		---------------------------------------------------------------------------------------------------------------
		--intenta hacer un unlock en un archivo.
		--devuelve TRUE si lo consigue y FALSE sino
		---------------------------------------------------------------------------------------------------------------
		fn svnUnlockFile file donotwait:false sleepTime:0.5 =
		(
			err = 0
			HiddenDOSCommand (this.svnExe + " unlock \"" + file + "\"") donotwait:donotwait ExitCode:&err
			if donotwait then sleep sleepTime
			(err == 0) and (getFileAttribute file #readOnly) --comprueba que no ha habido errores y que el archivo se ha desbloqueado
		),
		
		---------------------------------------------------------------------------------------------------------------
		--intenta hacer un commit en un archivo o una carpeta
		--FILE puede ser un string con una ruta de archivo o con una ruta de carpeta
		--devuelve TRUE si lo consigue y FALSE sino
		---------------------------------------------------------------------------------------------------------------
		fn svnCommit file changeList:#() donotwait:false logMessage:"" sleepTime:0.5 =
		(
			err = 0
			
			chList = "" --string con la cadena de ficheros a a�adir al changeList
			chListOp = "" --string con la opcion de chList para el commit
			
			if changeList.count != 0 then --si el commit solo debe afectar a determinados elementos los metemos en un changeList
			(
				chListOp = " --changelist chtemp"
				
				for ch in changeList do
					chList += (" " + ch)
				
				HiddenDOSCommand (this.svnExe + " changelist chtemp" + chList) donotwait:donotwait ExitCode:&err
				if donotwait then sleep sleepTime
			)
			
			if err == 0 then
			(
				HiddenDOSCommand (this.svnExe + " commit " + file + " -m \"" + logMessage + "\"" + chListOp) donotwait:donotwait ExitCode:&err
				if donotwait then sleep sleepTime
			)
			
			err == 0
		),
		
		---------------------------------------------------------------------------------------------------------------
		--intenta hacer un update en un archivo o una carpeta
		--FILE puede ser un string con una ruta de archivo o con una ruta de carpeta
		--devuelve TRUE si lo consigue y FALSE sino
		---------------------------------------------------------------------------------------------------------------
		fn svnUpdate file hidden:true donotwait:false sleepTime:0.5 type:#workingCopy =
		(
			err = 0
			_updateType = undefined
			
			case type of
			(
				#workingCopy: _updateType = " update "
				#fullRecursive: _updateType = " up --set-depth infinity "
				#inmediatly: _updateType = " up --set-depth immediates "
			)

			if _updateType != undefined then
				if hidden then
				(
					HiddenDOSCommand (this.svnExe + _updateType + file) donotwait:donotwait ExitCode:&err
					if donotwait then sleep sleepTime
				)
				else DOSCommand (this.svnExe + _updateType + file)
			
			err == 0
		),
		
		---------------------------------------------------------------------------------------------------------------
		--intenta hacer un ADD en un archivo o una carpeta
		--FILE puede ser un string con una ruta de archivo o con una ruta de carpeta
		--devuelve TRUE si lo consigue y FALSE sino
		---------------------------------------------------------------------------------------------------------------
		fn svnAdd file donotwait:false sleepTime:0.5 =
		(
			err = 0
			HiddenDOSCommand (this.svnExe + " add " + file) donotwait:donotwait ExitCode:&err
			if donotwait then sleep sleepTime
			err == 0
		),
		
		---------------------------------------------------------------------------------------------------------------
		--intenta hacer un DELETE en un archivo o una carpeta
		--FILE puede ser un string con una ruta de archivo o con una ruta de carpeta
		--devuelve TRUE si lo consigue y FALSE sino
		---------------------------------------------------------------------------------------------------------------
		fn svnDelete file donotwait:false sleepTime:0.5 =
		(
			err = 0
			HiddenDOSCommand (this.svnExe + " delete " + file) donotwait:donotwait ExitCode:&err
			if donotwait then sleep sleepTime
			err == 0
		),
		
		---------------------------------------------------------------------------------------------------------------
		--intenta hacer un unlock en un archivo o una carpeta
		--OLDFILENAME y NEWFILENAME pueden ser un string con una ruta de archivo o con una ruta de carpeta
		--devuelve TRUE si lo consigue y FALSE sino
		---------------------------------------------------------------------------------------------------------------
		fn svnRename oldfileName newFileName donotwait:false sleepTime:0.5 =
		(
			err = 0
			HiddenDOSCommand (this.svnExe + " rename " + oldfileName + " " + newFileName) donotwait:donotwait ExitCode:&err
			if donotwait then sleep sleepTime
			err == 0
		),	

		---------------------------------------------------------------------------------------------------------------
		--devuelve informaci�n del archivo pasado como par�metro
		--SLEEPTIME: tiempo de espera inicial antes de coprobar la salida del fichero de svn.
		--TIMEOUT: tiempo m�ximo de espera para SVN
		--CHECKTIMEINTERVAL: tiempo de espera entre comprobaciones de si svn ha terminado de devolver la informacion
		---------------------------------------------------------------------------------------------------------------
		fn svnGetInfo file donotwait:true sleepTime:0.5 timeout:30.0 checkTimeInterval:0.5 =
		(
			_return = dotNetObject "System.Collections.Hashtable" --variable donde almacenar los estados
			err = 0
			
			--ruta del archivo de salida de informacion
			cmdOutFile = (getDir #maxroot) + "stdplugs\\stdscripts\\lbTools\\log\\hiddencmdout.tmp"
			
			if doesFileExist cmdOutFile then
			(
				HiddenDOSCommand ("taskkill /IM \"svn.exe\" /F /T")
				deleteFile cmdOutFile
			)--if doesFileExist cmdOutFile
			
			if not doesFileExist cmdOutFile then
			(
				--print (this.svnExe + " info " + file + " > \"" + cmdOutFile + "\"")
				--obtiene el estado y lo almacena en hiddencmdout.tmp
				HiddenDOSCommand ("(" + this.svnExe + " info \"" + file + "\" & echo COMMAND FINISHED) > \"" + cmdOutFile + "\"") donotwait:donotwait ExitCode:&err
				if donotwait then sleep sleepTime
				
				_start = timeStamp()
				_writeFinish = false
				
				--hace un loop de espera hasta que svn ha terminado de escribir el log
				if donotwait then
					while (not _writeFinish) and ((timeStamp() - _start) < (timeout*1000.0)) do
					(
						_f = openFile cmdOutFile mode:"r" --abre el archivo para ver si se ha terminado de escribir
						
						if _f != undefined then --si lo consigue abrir
						(
							_text = ""
							while not eof _f do _text += readline _f
							close _f

							--si ha terminado de escribirlo para el while, si no, hace un sleep
							if matchPattern _text pattern:"*COMMAND FINISHED*" then
								_writeFinish = true
							else
								sleep checkTimeInterval
						)--si no lo consigue abrir espera el intervalo
						else sleep checkTimeInterval
					)--while
				
				HiddenDOSCommand ("taskkill /IM \"svn.exe\" /F /T")
				
				if donotwait and not _writeFinish do err = -1 --si ha saltado el timeout antes de que svn termine de devolver la informacion, no la lee porque ser� err�nea.
				
				if err == 0 then -- si no ha fallado
				(
					fstream = openFile cmdOutFile mode:"r" --abre el archivo para leerlo
					
					if fstream != undefined then
					(
						while not eof fstream do
						(
							_currLine = readLine fstream
								
							_m = lb.re.matchObj _currLine "(?'key'.*): (?'value'.*)"
							if _m.success do
								_return.add (_m.Groups.Item("key")).value (_m.Groups.Item("value")).value
						)--while
						
						close fstream --cierra el archivo
					)--if stream
				)--if
			)--if not doesFileExist
			
			deleteFile cmdOutFile --intenta eliminar el archivo		
			_return --devuelve los estados
		),


		---------------------------------------------------------------------------------------------------------------
		--devuelve informaci�n de los logs del fichero de svn
		--SLEEPTIME: tiempo de espera inicial antes de coprobar la salida del fichero de svn.
		--TIMEOUT: tiempo m�ximo de espera para SVN
		--CHECKTIMEINTERVAL: tiempo de espera entre comprobaciones de si svn ha terminado de devolver la informacion
		---------------------------------------------------------------------------------------------------------------
		fn svnLog file donotwait:true sleepTime:0.5 timeout:30.0 checkTimeInterval:0.5 =
		(
			_return = #()
			err = 0
			
			--ruta del archivo de salida de informacion
			cmdOutFile = (getDir #maxroot) + "stdplugs\\stdscripts\\lbTools\\log\\hiddencmdout.tmp"
			
			if doesFileExist cmdOutFile then
			(
				HiddenDOSCommand ("taskkill /IM \"svn.exe\" /F /T")
				deleteFile cmdOutFile
			)--if doesFileExist cmdOutFile
			
			if not doesFileExist cmdOutFile then
			(
				--print (this.svnExe + " log " + file + " > \"" + cmdOutFile + "\"")
				--obtiene el estado y lo almacena en hiddencmdout.tmp
				HiddenDOSCommand ("(" + this.svnExe + " log \"" + file + "\" & echo COMMAND ENDED) > \"" + cmdOutFile + "\"") donotwait:donotwait ExitCode:&err
				if donotwait then sleep sleepTime
				
				_start = timeStamp()
				_writeFinish = false
				
				--hace un loop de espera hasta que svn ha terminado de escribir el log
				if donotwait then
					while (not _writeFinish) and ((timeStamp() - _start) < (timeout*1000.0)) do
					(
						_f = openFile cmdOutFile mode:"r" --abre el archivo para ver si se ha terminado de escribir
						
						if _f != undefined then --si lo consigue abrir
						(
							_text = ""
							while not eof _f do _text += readline _f
							close _f

							--si ha terminado de escribirlo para el while, si no, hace un sleep
							if matchPattern _text pattern:"*COMMAND ENDED*" then
								_writeFinish = true
							else
								sleep checkTimeInterval
						)--si no lo consigue abrir espera el intervalo
						else sleep checkTimeInterval
					)--while
				
				HiddenDOSCommand ("taskkill /IM \"svn.exe\" /F /T")
				
				if donotwait and not _writeFinish do err = -1 --si ha saltado el timeout antes de que svn termine de devolver la informacion, no la lee porque ser� err�nea.
				
				if err == 0 then -- si no ha fallado
				(
					fstream = openFile cmdOutFile mode:"r" --abre el archivo para leerlo
					
					if fstream != undefined then
					(
						while not eof fstream do
						(
							_currLine = readLine fstream
								
							_m = lb.re.matchObj _currLine "^r(?'revision'\d*) \| (?'user'.*) \| (?'year'\d{4})-(?'month'\d{2})-(?'day'\d{2}) (?'hour'\d{2}):(?'minutes'\d{2}):(?'seconds'\d{2}) .* \| .*$"
							if _m.success then
							(
								_return[_return.count][1] = (_m.Groups.Item("revision")).Value as integer
								_return[_return.count][2] = (_m.Groups.Item("user")).Value
								_return[_return.count][3][1] = (_m.Groups.Item("year")).Value as integer
								_return[_return.count][3][2] = (_m.Groups.Item("month")).Value as integer
								_return[_return.count][3][3] = (_m.Groups.Item("day")).Value as integer
								_return[_return.count][3][4] = 0
								_return[_return.count][3][5] = (_m.Groups.Item("hour")).Value as integer
								_return[_return.count][3][6] = (_m.Groups.Item("minutes")).Value as integer
								_return[_return.count][3][7] = (_m.Groups.Item("seconds")).Value as integer
								_return[_return.count][3][8] = 0
							)
							else if _currLine == "COMMAND ENDED" then
								break
							else if _currLine == "------------------------------------------------------------------------" then
								append _return #(-1, "", getLocalTime(), "")
							else
								_return[_return.count][4] = _currLine
						)--while
						
						close fstream --cierra el archivo
					)--if stream
				)--if
			)--if not doesFileExist

			_return = for i = 1 to _return.count where _return[i][1] != -1 collect _return[i]
			deleteFile cmdOutFile --intenta eliminar el archivo
			_return --devuelve los estados
		),

		---------------------------------------------------------------------------------------------------------------
		--asciende en el �rbol de directorios hasta que encuentra uno que exista en disco
		--devuelve string
		---------------------------------------------------------------------------------------------------------------
		fn firstExistingDir fileName =
		(
			while not doesFileExist fileName do
			(
				_array = lb.str.split fileName "\\"
				_array = for i=1 to _array.count-1 collect _array[i]
				upperFileName = lb.str.join _array "\\"
				if upperFileName == fileName do
					return undefined
				fileName = upperFileName
			)
			fileName
		),		

		---------------------------------------------------------------------------------------------------------------
		--Devuelve la url del repositorio
		--devuelve string
		---------------------------------------------------------------------------------------------------------------
		fn repositoryURL fileName =
		(
			fileName = firstExistingDir fileName
			if fileName != undefined do
			(
				dInfo = svnGetInfo fileName
				if dInfo.ContainsKey("Repository Root") do
					return dInfo.Item("Repository Root")
			)
			return undefined
		),

		---------------------------------------------------------------------------------------------------------------
		--Devuelve la url del fichero
		--devuelve string
		---------------------------------------------------------------------------------------------------------------
		fn fileURL fileName =
		(
			if doesFileExist fileName then
			(
				dInfo = svnGetInfo fileName
				if dInfo.ContainsKey("URL") do
					return dInfo.Item("URL")
			)
			else
			(
				fileDir = firstExistingDir fileName
				dInfo = svnGetInfo fileDir
				if dInfo.ContainsKey("URL") do
					url = substituteString fileName fileDir (dInfo.Item("URL"))
					url = substituteString url "\\" "/"
					return url
			)
			return undefined
		),		

		------------------------------------------------
		--COMMON
		------------------------------------------------
			
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrer�as en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librer�a.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librer�as hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecuci�n al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addLibrary this --a�ade la libreria a la principal
		)
	
	)--lib_svn
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_svn() --crea la libreria
)