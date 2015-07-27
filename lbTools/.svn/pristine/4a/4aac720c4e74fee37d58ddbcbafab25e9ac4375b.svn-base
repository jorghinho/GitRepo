------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: libreria que contiene las funcionalidades para la creación de archivos de batch
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lib_batch | Contiene la libreria de batch.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_batch
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,													--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Libreria Batch Functions",							--@var: string | description | Descripcion de la libreria.
		
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

		----------------------------------------------------------------------------------
		--@fn: array | getFilesFromFolder| obtiene los archivos de un directorio a partir de una ruta
		--@gets: string | folder | Path a la carpeta donde se buscaran los archivos con la extensión proporcionada
		--@gets: (opt)string | folderFilter | Sirve para filtar a carpetas que se llamen como la string proporcionada. Por defecto "", en este caso no realiza filtro.
		--@gets: (opt)string | fileFilter | <wild_card_filename_string> es un filtro que admite patrones para limitar por nombre los archivos que se buscan. Por defecto ""
		--@gets: (opt)array | ignorelist | es un array de patrones a ignorar en los archivos. Deben ser strings. Por defecto #()
		--Ej: si damos como IGNORELIST #("_batch"), ignora todos los archivos que tengan "_batch" en el nombre
		--@gets: (opt)string | ext |  Extension de los archivos que va a buscar. Por defecto ".max"
		--@gets: (opt)boolean | recursive | Indica que la funcion va a buscar recursivamente los archivos. por defecto true
		--@returns: array | folderFiles | Array con los ficheros que se encuentran en el directorio proporcionado que cumplen los filtros establecidos por parametros.
		----------------------------------------------------------------------------------
		fn getFilesFromFolder folder folderFilter:"" fileFilter:"" ignoreList:#() ext:".max" recursive:true =
		(
			folderFiles = #() --array para guardar los archivos obtenidos en la busqueda
			
			--busca los directorios del actual
			folders = getDirectories (folder + "\\*")
			
			--busca los directorios dentro del actual que cumplan el filtro
			filterFolders = getDirectories (folder + "\\" + (if folderFilter != "" then folderFilter else "") + "*")
			
			--recorre los filterFolders almacenando todos los archivos que cumplan la extension y el filtro de archivo
			for f in filterFolders do --obtiene los archivos de cada folder
				folderFiles += (getFiles (f + "\\" + (if fileFilter != "" then fileFilter else "*") + ext))
			
			if recursive then --si hay que seguir buscando recursivamente
				for f in folders do --recorre los directorios y llama a la funciond e forma recursiva
					folderFiles += (getFilesFromFolder f folderFilter:folderFilter fileFilter:fileFilter recursive:true)
			
			--si hay patrones que ignorar elimina del array de folderFiles los que coincidan.
			for il in ignoreList do
				for i=folderFiles.count to i=1 by -1 do
					if findString folderFiles[i] il != undefined then
						deleteItem folderFiles i
				
			folderFiles --devuelve los archivos obtenidos
		),--fn getFilesFromFolder	

		----------------------------------------------------------------------------------
		--@fn: boolean | batchFile| realiza batch del fichero pasado por parametro
		--@gets: string | file | Path al archivo al que hacer batch
		--@gets: array | batchFunctions | funciones de batch que aplicar en el archivo ()
		--@gets: (ref)boolean | canceled | Sirve para almacenar si el proceso ha sido cancelado
		--@gets: (opt)boolean | updateFirst | Si está a true, se realizará un update del fichero antes de realizar el batch. Por defecto true
		--@gets: (opt)boolean | lock | Si está a true, se realizará un lock del fichero antes de realizar el batch. Por defecto true
		--@gets: (opt)name | saveAsOption | Tipo de batch a realizar. Opciones: #notSave(no lo salva, es solo para simulacion) #sameFile(lo sobreescribe) #versionIncrement(le añade un numero de version) #copy(lo salva como archivo nuevo con el sufijo batch) .Por defecto #sameFile
		--@gets: (opt)boolean | commit | Si está a true, se realizará un commit del fichero una vez realizado el batch. Por defecto true
		--@gets: (opt)boolean | simulationOnly | Si está a true realiza la operación como una simulación.
		--@gets: (opt)string | logFile | Directorio donde guardar el log del proceso, si no se le dice nada lo guarda en el archivod e log por defecto
		--@returns: boolean | _success | Boleano de ejemplo que devuelve si la función se ha realizado correctamente 
		----------------------------------------------------------------------------------
		fn batchFile file batchFunctions &canceled updateFirst:true lock:true saveAsOption:#sameFile commit:true simulationOnly:false logFile:((getDir #temp) + "\\batch.log") logMessage:"" =
		(
			_success = true --flag que se pone a false si alguna función no consigue ejecutarse de forma correcta
			_stop = false --flag de parada
			
			--LOG-------------------------------------------------		
			if logFile == undefined then --si es undefined hay que crearlo y abrirlo en modo escritura
				logFile = (getDir #temp) + "\\batch.log"
			--LOG-------------------------------------------------
			
			if logFile != undefined and logFile != "" then --si el fichero de log es correcto, reliza el batch
			(
				_continueProcess = true --flag para poner a FALSE cuando el proceso no deba continuar
				
				_locked = false --almacena si el archivo (versionado) se ha bloqueado para trabajar con el
				_bckpReadOnly = false --almacena si el archivo era readOnly o no
				_bckpCheckState = true --getFileInfoIsChecked file --almacena el estado actual de checkeado de la escena
				_needsChecks = false --flag que indica si hay que pasar los checks o no
					
				setIniSetting logFile file "require_updateFirst" (updateFirst as string) --almacena si se va a hacer un update antes del proceso
				setIniSetting logFile file "require_lock" (lock as string) --almacena si se va a hacer un lock de los archivos
				setIniSetting logFile file "require_saveAsOption" (saveAsOption as string) --almacena si hay que salvar como copia
				setIniSetting logFile file "require_commitAtEnd" (commit as string) --almacena si hay que hacer commit al final
				setIniSetting logFile file "require_simulationOnly" (simulationOnly as string) --almacena que es una simulación
				
				--DESACTIVADO PORQUE SE CUELGA
			-- 			svnCleanup (getFilenamePath file)
			-- 			_IsFileVersioned = svnIsFileVersioned file --averigua si el archivo está versionado
				_IsFileVersioned = false
				
				--DESACTIVADO PORQUE SE CUELGA
				if updateFirst then
			-- 			if _IsFileVersioned and updateFirst then --si hay que actualizar el archivo antes del proceso
				(
					--DESACTIVADO PORQUE SE CUELGA
			-- 				svnCleanup (getFilenamePath file)
			-- 				if not lb.svn.svnIsFileUpdated file then --si el archivo no está actualizado
			-- 				(
			-- 					setIniSetting logFile file "process_fileAlreadyUpdated" "false" --almacena en el log que el archivo no estaba actualizado
			-- 					svnCleanup (getFilenamePath file)
			-- 					success = (lb.svn.svnUpdate file) --si tiene que actualizarlo y no lo consigue para la ejecucion poniendo el flag a false
			-- 					setIniSetting logFile file "process_fileUpdate" (_updateSuccess as string) --almacena en el log si se consigue hacer la actualizacion o no.
			-- 				)
			-- 				else
						setIniSetting logFile file "process_fileAlreadyUpdated" "true" --almacena en el log que el archivo ya estaba actualizado
				)--if updateFirst
				
				if keyboard.escPressed then _stop = querybox "Do you want to cancel file batch?"
					
				if not _stop and _success then --si el update se ha hecho bien, o bien el update no era requerido
				(
					resetMaxFile(#noPrompt) --resetea el archivo antes de abrir otro
					gc() --limpia la memoria antes de abrir el archivo
						
					if (loadMaxFile file useFileUnits:true quiet:true) then --si consigue abir el archivo
					(	
						gc() --limpia la memoria despues de abrir el archivo por si ha consumido mucha
						
						setIniSetting logFile file "process_separator00" "-----------------------------------------" --separador
						setIniSetting logFile file "process_successOpen" "true" --si consigue abrirlo lo guarda en el log
						
						if keyboard.escPressed then _stop = querybox "Do you want to cancel file batch?"
							
						-----------------------------------------------------------
						--debe comprobar si el archivo esta versionado con subversion
						--si esta versionado. hacer un lock
						--si no lo está, comprobar que no es readOnly
						-----------------------------------------------------------
						if _IsFileVersioned then
						(
							--DESACTIVADO PORQUE SE CUELGA
			-- 						setIniSetting logFile file "process_isVersioned" "true" --almacena en el log que esta versionado
			-- 						
			-- 						if not simulationOnly and lock then --si no es una simulacion y hay que hacer un lock
			-- 						(
			-- 							--DESACTIVADO PORQUE SE CUELGA
			-- 							_locked = svnCleanup (getFilenamePath file)
			-- 							if _locked then _locked = lb.svn.svnLockFile file --intenta bloquear el archivo
			-- 							if not _locked then --si no lo ha conseguido bloquear
			-- 							(
			-- 								setIniSetting logFile file "process_lockSuccess" "false" --almacena en el log que no ha consegido bloquearlo
			-- 								setIniSetting logFile file "process_lockSuccessCause" "file could be locked by other person" --almacena en el log la posible causa
			-- 								_success = false --no ha podido pasar el batch
			-- 							)
			-- 							else --si lo ha conseguido bloquear
			-- 								setIniSetting logFile file "process_lockSuccess" "true" --alacena en el log que si ha conseguido bloquearlo
			-- 						)--if not simulationOnly
						)
						else if not simulationOnly then
						(
							setIniSetting logFile file "process_isVersioned" "false" --almacena en el log que el archivo no está versionado
												
							_bckpReadOnly = getFileAttribute file #readOnly --obtiene si el archivo es readOnly
							
							if _bckpReadOnly then --si el archivo es readOnly lo tiene que poner como no readOnly
							(
								setIniSetting logFile file "process_isReadOnly" "true" --almacena si el archivo es readOnly
								setIniSetting logFile file "process_setToNotReadOnly" "true"  --almacena en el log que va a poner el archivo con readOnly a false
								_aux = (setFileAttribute file #readOnly false) == ok --pone la propiedad readOnly a false
								
								if not _aux then
								(
									setIniSetting logFile file "process_setToNotReadOnly" "false" --almacena en el log que no ha conseguido ponerlo a readOnly false
									_success = false --no ha podido pasar el batch
								)--if
							)
							else
								setIniSetting logFile file "process_isReadOnly" "false" --almacena si el archivo no es readOnly
						)--if else
						setIniSetting logFile file "process_separator01" "-----------------------------------------" --separador
						-----------------------------------------------------------
						
						if keyboard.escPressed then _stop = querybox "Do you want to cancel file batch?"
							
						---------------------------------------------------------------------------------------------------------------
						---------------------------------------------------------------------------------------------------------------
						if not _stop and _success then --solo si ha conseguido ejecutar los pasos previos hace el batch de las funciones
						(
							try
							(
								_cont = 1 --contador
	 							for bf in batchFunctions where _success and not _stop do --recorre las funciones que tiene que ejecutar en el max, pero si una no lo consigue, no hace el resto
								(
									_auxSuccess = bf &_auxNeedsChecks logFile:logFile --ejecuta la funcion
									
									setIniSetting logFile file ("process_" + (bf as string) + "_success") (_auxSuccess as string) --almacena en el log si ha ejecutado con exito la fucion.
									setIniSetting logFile file ("process_" + (bf as string) + "_needsChecks") (_auxNeedsChecks as string) --almacena si la funcion requiere que se pasen los checks después.
									setIniSetting logFile file ("process_" + (bf as string) + "_separator") "----------------" --separador
									
									if not _needsChecks then _needsChecks = _auxNeedsChecks --almacena si tiene que pasar los checks
									if _success then _success = _auxSuccess --almacena si alguna funcion no ha conseguido ejecutarse
										
									lb.progressBar.setProgressBarValue (_cont*(100.0/batchFunctions.count)) useSecondary:true
									
									if keyboard.escPressed then _stop = querybox "Do you want to cancel file batch?"
									
									_cont +=1 --incrementa el contador
									
									gc() --limpia la memoria
								)--for
							)
							catch
							(
								setIniSetting logFile file "process_ERROR" "true" --almacena si ha dado algun fallo en als funciones
							)				
						)--if _success
						---------------------------------------------------------------------------------------------------------------
						---------------------------------------------------------------------------------------------------------------
						
						setIniSetting logFile file "process_success" (_success as string) --almacena si todas las funciones de batch se ha pasado bien para ese archivo
						setIniSetting logFile file "process_needsChecks" (_needsChecks as string) --almacena si el archivo necesita pasar los checks.
						setIniSetting logFile file "process_separator02" "-----------------------------------------" --separador
						
						if keyboard.escPressed then _stop = querybox "Do you want to cancel file batch?"
							
						if _success then --si ha conseguido ejecutar bien todas las funciones
						(
							-----------------------------------------------------------------------------------------------------
							if not _stop then --si no se ha cancelado el proceso
							(
								if _needsChecks then --si hay que pasar los checks
								(
									macros.run "lbTools" "assetChecker" --intenta abrir el asset checker
									
									if rollAssetChecker.rollOpen then --si lo consigue abrir
									(
										setIniSetting logFile file "process_checksOpen" "true" --almacena si se ha abierto el assetChecker correctamente
										
										try
										(
											gc() --limpia la memoria antes de pasar lo checks para que este limpia
											rollAssetChecker.btnCheck.pressed() --pasa los checks
											gc() --vuelve a limpiar la memoria tras pasar los checks
											
											if rollAssetChecker.btnSaveVerified.enabled then --si ha pasado los checks
											(
												setIniSetting logFile file "process_checksOK" "OK" --almacena si se han pasado los checks
												
												if not simulationOnly then --si no es una simulación, intenta resalvar el archivo
												(
													case saveAsOption of
													(
														#sameFile:
														(
															
															rollAssetChecker.saveVerified() --intenta salvarlo verificado
															setIniSetting logFile file "process_saveVerifiedOK" ((getFileInfoIsChecked file) as string) --almacena si el arhivo se ha guardado verificado
														)
														
														#copy:
														(
															_newFile = (filterString file ".")[1] + "_batch." + (filterString file ".")[2] --añade batch al nombre del archivo
															_auxSaveSuccess = saveMaxFile _newFile quiet:true --salva el archivo con nombre de batch
															setFileInfo _newFile checked:true --almacena el estado de check a true
															setIniSetting logFile file "process_saveVerifiedOK" ((getFileInfoIsChecked _newFile) as string) --almacena si el arhivo se ha guardado verificado
														)
														
														#versionIncrement:
														(
															_versionNumber = "v01" --numero de version inicial
															_fileName = getFileNameFile file --se queda solo con el nombre del archivo
															_version = (filterString _fileName "_")[(filterString _fileName "_").count] --se queda con la ultima parte, que se supone que es la de version
															
															if (matchPattern _version pattern:"v??") or (matchPattern _version pattern:"V??") then
															(
																_version = substituteString _version _version[1] "" --quita la v de version en caso de haberla
																
																-------------------------------------------------------------------------
																--averigua la nueva version
																if lb.math.isNumeric _version then
																(
																	if _version[2] == "9" then
																		_version = (((_version as integer) + 1) as string)
																	else
																		_version[2] = (((_version[2] as integer) + 1) as string)
																		
																	_versionNumber = "v" + _version
																	_newFileName = substituteString file ((filterString _fileName "_")[(filterString _fileName "_").count] + ".max") _versionNumber
																)
																else
																(
																	_newFileName = substituteString file ".max" (_versionNumber + ".max")
																)
																-------------------------------------------------------------------------
															)
															else
															(
																_newFileName = substituteString file ".max" (_versionNumber + ".max")
															)
															
															if not doesFileExist _newFileName then
															(
																_auxSaveSuccess = saveMaxFile _newFileName quiet:true --salva el archivo con el nuevo nombre de version
																setFileInfo _newFileName checked:true --almacena el estado de check a true
																setIniSetting logFile file "process_saveVerifiedOK" ((getFileInfoIsChecked _newFileName) as string) --almacena si el arhivo se ha guardado verificado
															)
															else
															(
																_auxSaveSuccess = false
																setIniSetting logFile file "process_newFileNameAlreadyExist" "true" --almacena si el arhivo con el nuevo nombre ya existia
															)
															
														)--#versionIncrement
													)--case
												)--if  not simulationOnly
											)
											else --si no ha pasado los checks
											(
												setIniSetting logFile file "process_checksOK" "ERROR" --almacena si se han pasado los checks
												_success = false --no ha podido pasar el batch
											)--if
										)
										catch
										(
											setIniSetting logFile file "process_checksERROR" "true"
											_success = false --no ha podido pasar el batch
										)
											
										destroyDialog rollAssetChecker --cierra el assetChecker
									)
									else --si no lo consigue abrir
									(
										setIniSetting logFile file "process_assetCheckerOpen" "false" --almacena si se ha abierto el assetChecker correctamente
										_success = false --no ha podido pasar el batch
									)
									
									--------------------------------------------------------------------------------
								)
								else --si no hay que pasar los checks. not _needsChecks
								(
									macros.run "lbTools" "assetChecker" --intenta abrir el asset checker
									_auxSaveSuccess = false --flag inicialmente a false
									_newFile = file --por si se salva con otro nombre
									
									if not simulationOnly then --si no es una simulacion
									(
										case saveAsOption of
										(
											#sameFile:
											(
												rollAssetChecker.overrideVerification = true
			-- 											print "Override desde batchFunctions"
			-- 											print rollAssetChecker.overrideVerification
												rollAssetChecker.saveVerified() --intenta salvarlo verificado
												setIniSetting logFile file "process_saveVerifiedOK" ((getFileInfoIsChecked file) as string) --almacena si el arhivo se ha guardado verificado
											)
											
											#copy:
											(
												_newFile = (filterString file ".")[1] + "_batch." + (filterString file ".")[2] --añade batch al nombre del archivo
												_auxSaveSuccess = saveMaxFile _newFile quiet:true --salva el archivo con nombre de batch
												setFileInfo _newFile checked:true --almacena el estado de check a true
												setIniSetting logFile file "process_saveVerifiedOK" ((getFileInfoIsChecked _newFile) as string) --almacena si el arhivo se ha guardado verificado
											)
											
											#versionIncrement:
											(
												_versionNumber = "v01" --numero de version inicial
												_fileName = getFileNameFile file --se queda solo con el nombre del archivo
												_version = (filterString _fileName "_")[(filterString _fileName "_").count] --se queda con la ultima parte, que se supone que es la de version
												
												if (matchPattern _version pattern:"v??") or (matchPattern _version pattern:"V??") then
												(
													_version = substituteString _version _version[1] "" --quita la v de version en caso de haberla
													
													-------------------------------------------------------------------------
													--averigua la nueva version
													if lb.math.isNumeric _version then
													(
														if _version[2] == "9" then
															_version = (((_version as integer) + 1) as string)
														else
															_version[2] = (((_version[2] as integer) + 1) as string)
															
														_versionNumber = "v" + _version
														_newFileName = substituteString file ((filterString _fileName "_")[(filterString _fileName "_").count] + ".max") _versionNumber
													)
													else
													(
														_newFileName = substituteString file ".max" (_versionNumber + ".max")
													)
													-------------------------------------------------------------------------
												)
												else
												(
													_newFileName = substituteString file ".max" (_versionNumber + ".max")
												)
												
												if not doesFileExist _newFileName then
												(
													_auxSaveSuccess = saveMaxFile _newFileName quiet:true --salva el archivo con el nuevo nombre de version
													setFileInfo _newFileName checked:true --almacena el estado de check a true
													setIniSetting logFile file "process_saveVerifiedOK" ((getFileInfoIsChecked _newFileName) as string) --almacena si el arhivo se ha guardado verificado
												)
												else
												(
													_auxSaveSuccess = false
													setIniSetting logFile file "process_newFileNameAlreadyExist" "true" --almacena si el arhivo con el nuevo nombre ya existia
												)
												
											)--#versionIncrement
										)--case
											
										setIniSetting logFile file "process_saveChanges" (_auxSaveSuccess as string) --almacena si se ha salvado correctamente el archivo
									)--if not simulationOnly
									
									--coloca el estado de checkeado del archivo tal como estuviera al abrirlo.
									if _auxSaveSuccess then
									(
										if (saveAsOption == #versionIncrement) or (saveAsOption == #copy) then --si habia que salvarlo con otro nombre
											setFileInfo _newFile checked:_bckpCheckState --almacena el estado de check tal cual estaba
										else --si habia que salvarlos tal cual
											setFileInfo file checked:_bckpCheckState --almacena el estado de check tal cual estaba
										
										setIniSetting logFile file "process_restoreCheckedState" "true" --almacena que ha restaurado el estado de checkeado del archivo.
									)
									
									destroyDialog rollAssetChecker --cierra el assetChecker
								)--if else _needsChecks
							)--if not _stop
							setIniSetting logFile file "process_separator03" "-----------------------------------------" --separador
							-----------------------------------------------------------------------------------------------------
							
							--si no es una simulacion
							--si se ha resalvado el archivo
							--si estaba versionado y lockeado, debe hacer un commit (poniendo en el commit una etiqueta de batch)
							--si no estaba versionado pero estaba con readOnly, debe ponerle de nuevo ese estado.
							if not simulationOnly and lock then --si no es una simulacion y habia que bloquearlo
							(
								if _locked then --si está bloqueado, se debe hacer un commit
								(
									--DESACTIVADO PORQUE SE CUELGA
			-- 								if commit and not saveAsOption == #sameFile then --si hay que hacer commit, intenta hacer el commit y el unlock
			-- 								(
			-- 									svnCleanup (getFilenamePath file)
			-- 									--_logFunctions = "" --string con el log para el commit
			-- 									--for bf in batchFunctions do _logFunctions += (bf as string) + "; " --rellena el log
			-- 									_aux = lb.svn.svnCommit file logMessage:logMessage --("batchManager: " + _logFunctions) --hace el commit
			-- 									setIniSetting logFile file "process_commitSuccess" (_aux as string) --almacena si se ha conseguido hacer un commit
			-- 									
			-- 									if not _aux then --si no ha conseguido hacer el commit
			-- 										_success = false --no ha podido pasar el batch
			-- 								)--if commit
			-- 								else if saveAsOption != #sameFile then --si se ha salvado como copia
			-- 								(
			-- 									svnCleanup (getFilenamePath file)
			-- 									_aux = lb.svn.svnUnlockfile file --hace un unlock 
			-- 									setIniSetting logFile file "process_unLockSuccess" (_aux as string) --almacena si ha cosnseguido hacer el unlock
			-- 									
			-- 									if not _aux then --si no ha conseguido hacer el unlock
			-- 										_success = false --no ha podido pasar el batch
			-- 								)--if saveAsOption
								)
								else if _bckpReadOnly then --si no esta bloqueado y estaba como readOnly, hay que volver a ponerlo como readOnly a true
								(
									_aux = (setFileAttribute file #readOnly true) == ok --lo pone a true
									setIniSetting logFile file "process_setToReadOnly" (_aux as string) --almacena si se ha conseguido restaurar el estado de readOnly a true
									
									if not _aux then --si ha conseguido hacer el commit
										_success = false --no ha podido pasar el batch
								)--if else
							)--if not simulationOnly
							setIniSetting logFile file "process_separator04" "-----------------------------------------" --separador
							-----------------------------------------------------------------------------------------------------
						)--if success
					)--if loadMaxFile
					else --si no consigue abrir el archivo
					(
						setIniSetting logFile file "process_successOpen" "false" --si no consigue abrirlo lo guarda en el log
						_success = false --no ha podido pasar el batch
					)--if else loadMaxFile
				)--if not _stop and _updateSuccess
				
				if _stop then --si el proceso se ha parado por medio de la tecla ESC
				(
					_success = false --si se ha interrumpido el batch el estado de _success es false
					setIniSetting logFile file "process_CANCELLED" "true" --almacena que el proceso ha sido interrumpido por el usuario	
				)--if _stop			
			)--if logFile != undefined and logFile != ""
			
			canceled = _stop --almacena si el proceso ha sido cancelado o no
			gc() --limpia de uevo la memoria
			
			_success --devuelve si ha tenido exito
		),--fn batchFile

		----------------------------------------------------------------------------------
		--@fn: boolean | batchFiles | realiza batch de los ficheros pasados por parametro
		--@gets: array | files | Array de strings con el path a los archivos a los que hacer batch
		--@gets: array | batchFunctions | funciones de batch que aplicar en el archivo ()
		--@gets: (ref)array | errFiles | Es un parametro por referencia que se rellena con los ficheros que no hayan conseguido pasar el batch
		--@gets: (opt)boolean | updateFirst | Si está a true, se realizará un update del fichero antes de realizar el batch. Por defecto true
		--@gets: (opt)boolean | lock | Si está a true, se realizará un lock del fichero antes de realizar el batch. Por defecto true
		--@gets: (opt)name | saveAsOption | Tipo de batch a realizar. Opciones: #notSave(no lo salva, es solo para simulacion) #sameFile(lo sobreescribe) #versionIncrement(le añade un numero de version) #copy(lo salva como archivo nuevo con el sufijo batch) .Por defecto #sameFile
		--@gets: (opt)boolean | commit | Si está a true, se realizará un commit del fichero una vez realizado el batch. Por defecto true
		--@gets: (opt)boolean | simulationOnly | Si está a true realiza la operación como una simulación.
		--@gets: (opt)string | logFile | Directorio donde guardar el log del proceso, si no se le dice nada lo guarda en el archivod e log por defecto
		--@returns: boolean | _success | Boleano de ejemplo que devuelve si la función se ha realizado correctamente 
		----------------------------------------------------------------------------------		
		fn batchFiles files batchFunctions &errFiles updateFirst:true lock:true saveAsOption:#sameFile commit:true simulationOnly:false logFile:((getDir #temp) + "\\batch.log") logMessage:"" =
		(
			_success = true --flag para saber si ha tenido éxito o no
			errFiles = #() --array para almacenar los archivos que no han conseguido pasar los checks
			_stop = false --flag de parada por si el proceso es cancelado
			
			setWaitCursor() --pone el cursor de espera
			
			--LOG-------------------------------------------------
			--si no se especifica logFile, se coge por defecto el de max
			if logFile == undefined then logFile = (getDir #temp) + "\\batch.log"
			if doesFileExist logFile then deleteFile logFile --elimina el log anterior
			--LOG-------------------------------------------------
			
			----------------------------------------------------------------------------
			--incrementa el heapsize si es necesario
			_heapIncrease = ((files.count/10) + 1)*100
			if _heapIncrease > 500 then _heapIncrease = 500
			_heapIncrease = (_heapIncrease*1000000)	
			if heapSize < _heapIncrease then heapSize = _heapIncrease
			----------------------------------------------------------------------------
			
			----------------------------------------------------------------------------
			--almacena en el log las funciones de batch que se van a pasar
			setIniSetting logFile "batchFunctions" "count" (batchFunctions.count as string) --almacena en el log el numero de funciones que se van a ejecutar
			for i=1 to batchFunctions.count do
				setIniSetting logFile "batchFunctions" ("function" + (i as string)) (batchFunctions[i] as string)
			setIniSetting logFile "batchFunctions" "separator" "---------------------------------------------------------------------" --separador
					
			--almcena en el log en numero de archivos a los que se va a pasar el batch
			setIniSetting logFile "batchFiles" "count" (files.count as string)
			for i=1 to files.count do --recorre los archivos a hacer batch
			(
				f = files[i] --almacena el archivo actual
				setIniSetting logFile "batchFiles" ("file" + i as string) f --almacenamos el nombre del archivo
			)--for
			setIniSetting logFile "batchFiles" "separator" "---------------------------------------------------------------------" --separador
			
			if keyboard.escPressed then _stop = querybox "Do you want to cancel batch?"
			for i=1 to files.count where not _stop do --recorre los archivos a hacer batch
			(
				f = files[i] --almacena el archivo actual
				_exist = doesFileExist f --averigua si el archivo existe o no
				
				setIniSetting logFile f "general_exist" (_exist as string) --almacena si el archivo existe o no
				setIniSetting logFile f "general_success" "undefined" --almacenamos el estado de exito (inicialmente undefined)
				setIniSetting logFile f "general_separator" "-------------------------------------------" --separador
				
				if _exist then --si el archivo existe hace el batch
				(
					disableSceneRedraw() --desactiva el redibujado de viewport
					
					--llama a la funcion de hacer batch en el archivo
					_auxSuccess = batchFile f batchFunctions &_stop updateFirst:updateFirst lock:lock saveAsOption:saveAsOption commit:commit simulationOnly:simulationOnly logFile:logFile logMessage:logMessage
					
					enableSceneRedraw() --vuelve a a cativar el redibujado
					gc() --limpia la memoria porque cada batch puede ser un proceso muy pesado
					
					if _success then _success = _auxSuccess --si algun archivo no consigue hacer el batch, el batch general se considera como fallido
						
					if not _auxSuccess then append errFiles f --almacena el archivo que ha fallado en el batch
					setIniSetting logFile f "general_success" ((_auxSuccess as string) + " - batch file error") --almacena el estado real de exito del fichero
				)--if _exist
				else --if not _exist
				(
					_success = false --el proceso general ya no es correcto, ha fallado un archivo
					setIniSetting logFile f "general_success" "false - file doesn't exist" --almacena el estado real de exito del fichero
				)--if not _exist
				
				lb.progressBar.setProgressBarValue (i*(100.0/files.count))
				--progressUpdate (i*(100.0/files.count))
					
				if not _stop and keyboard.escPressed then _stop = querybox "Do you want to cancel batch?"
					
				setIniSetting logFile f "separator" "---------------------------------------------------------------------" --separador
			)--for
			-----------------------------------------------------------------------------
			
			--almacena en el log que hay archivos que no han hecho el log
			setIniSetting logFile "batchErrorFiles" "count" (errFiles.count as string) --almacena el numero de archivos que no ha pasado el batch
			for i=1 to errFiles.count do --almacena todos los ficheros que no han pasado los batch
				setIniSetting logFile "batchErrorFiles" ("file" + i as string) (errFiles[i] as string) --almacena el fichero que no ha pasado los batch
			setIniSetting logFile "batchErrorFiles" "separator" "---------------------------------------------------------------------" --separador
			
			setArrowCursor() --pone el cursor normal
			
			if _stop then
			(
				_success = false --si se ha interrumpido el batch el estado de _success es false
				setIniSetting logFile "batchFiles" "process_CANCELLED" "true" --almacena que el proceso ha sido interrumpido por el usuario
			)
			
			gc() --limpia de nuevo la memoria
			
			_success --devuelve el resultado
		),--fn batchFiles

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
	)--lib_batch
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_batch() --crea la libreria
)