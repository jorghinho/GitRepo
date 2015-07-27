--NOTA IMPORTANTE, LA TOOL NO FUNCIONA PORQUE HAY QUE ADAPTAR EL GETFILEINFO
------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta totalChecker.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	---------------------------------------------------------------------------------------------------------------
	--STRUCTS DE LOS CHECKS
	--------------------------------------------------------------------------------------------------------------- 

	-----------------------------------------------------------------------------------
	--variables donde almacenar las camaras, sus paths, el estado de sus checks y su log.
	--state puede ser: #WAITING, #OK, #ERROR, #WARNING
	--struct para las camaras. dentro guarda un array de struct de checks pasados para cada camara
	struct camTask
	(
		name = "",
		path = "",
		state = #WAITING,
		log = "",
		checkTasks = #(),
		maxFiles = #(),
		maxFilesInfo = #(),
		camSvnInfoLocal = undefined,
		camSvnInfoNetwork = undefined
	)
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--COMMON CHECKS--
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba la integridad de la informacion extra
	struct checkTask_ExtraInfoCorrupt
	(
		id = lb.totalChecker.rollMain.TCH_ExtraInfoCorrupt, --id de la tarea
		name = "Extra info correcto: Extra info no debe estar corrupto. [*******ARREGLAR EN PRIMER LUGAR*******]", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_files = maxFiles
			if maxfiles.count == 0 then
			(
				--paths de la camara que pueden contener archivos .max
				_animPath = path + "anim\\*"
				_cachePath = path + "cache\\*"
				_renderPath = path + "render\\*"
				
				--segun el tipo de archivo al que queramos pasar los checks busca los max en una carpeta u otra
				_filesPath = if ckbOptionAnim.checked then _animPath else if ckbOptionCache.checked then _cachePath else _renderPath
				_files = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".max"
			)--if
			
			for i=1 to _files.count do
			(
				_isCorrupt = isFileInfoCorrupt _files[i] info:maxFilesInfo[i] --comprueba si la informacion extra esta corrupta	
				
				if _isCorrupt then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> tiene el extra info corrupto.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "CORREGIR ANTES QUE EL RESTO DE CHECKS PARA PREVENIR FALSOS ERRORES\n"
				log += "El EXTRA INFO de los archivos de max, debe ser correcto. (Está corrupto.)\n"
				log += "En caso de estar corrupto, la solucion es abrir el archivo, pasar los checks y guardarlo de nuevo.\n"
				log += "Hay un check específico que lo detecta (ASSET CHECKER).\n"
				log += "Todo esto era debido a objetos que tienen un salto de linea en el nombre.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_ExtraInfoCorrupt
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que este actualizada la carpeta de caches en local
	struct checkTask_SVNlocalCachePathUpdated
	(
		id = lb.totalChecker.rollMain.TCH_SVNlocalCachePathUpdated, --id de la tarea
		name = "SVN: path de caches de la camara versionado y actualizado. (local)", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene el path de render
			_filesPath = (path + "cache\\")
			_filesSubPaths = #() --subpaths de caches
			_files = #() --array para los archivos de cada subpath
			
			_filesSubPaths = lb.fileIOFunctions.getAllSubfolders _filesPath --obtiene los subpaths
			_files = for p in _filesSubPaths collect ((getFiles (p + "*.max")) + (getFiles (p + "*.xaf")) + (getFiles (p + "*.pc2")) + (getFiles (p + "*.xml")) + (getFiles (p + "*.mc"))) --obtiene los archivos de cada path
				
			if doesFileExist _filesPath then --si existe el path
			(
				--averigua si esta actualizado preguntandole a svn
				if camSvnInfoLocal == undefined then _svnInfo = lb.svn.svnGetFolderStatus _filesPath donotwait:true sleepTime:0.5
				else _svnInfo = camSvnInfoLocal
				
				if not lb.svn.svnIsFolderVersioned _filesPath then --si no está versionado te avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está versionado.\n"
				)
				else --si esta actualizado sigue comprobando
				(
					--mira si esta actualizado
					_isUpdated = false
					for i=_svnInfo.count to 1 by -1 where (not _isUpdated and ((tolower _svnInfo[i].path) == (tolower _filesPath))) do
						_isUpdated = (_svnInfo[i].state == "U")
						
					if _isUpdated then --si dice que esta actualizadoo ahora busca cualquier archivo que no lo esté, porque a veces falla
						for i=1 to _svnInfo.count where _isUpdated do
							if (_svnInfo[i].state == "!") or (_svnInfo[i].state == "*") then
								_isUpdated = false
						
					if not _isUpdated then --si no está actualizada avisa
					(
						_fail = true --falla
						log += _filesPath + " -> No está actualizado.\n"
					)
					else --si está actualizado debe recorrer los subfolders comprobando su estado.
					(
						for i=1 to _filesSubPaths.count do --recorre los subpaths y luego todos sus archivos comprobando su estado de version
						(
							for j=1 to _files[i].count do --recorre los archivos del path buscando lo que necesiten un commit
							(
								_notVersioned = not lb.svn.svnIsFileVersioned _files[i][j] donotwait:true statusInfo:_svnInfo --mira si está versionado
								if _notVersioned then
								(
									_fail = true --falla
									log += _files[i][j] + " -> No está versionado.\n"
								)
								else --si esta versionade mira el estado concreto
								(
									_status = lb.svn.svnGetFileStatus _files[i][j] statusInfo:_svnInfo --obtiene el estado de ese archivo
									_needsCommit = (_status == "A") or (_status == "D") or (_status == "G") or (_status == "M") or (_status == "R") --mira si necesita un commit
									if _needsCommit then --si necesita un commit te lo dice
									(
										_fail = true --falla
										log += _files[i][j] + " -> Necesita un commit.\n"
									)
								)
							)--for _files
						)--for _filesSubPaths
					)--if else _isUpdated
				)--if else versioned
			)
			else --si no existe puede que no esté creado o que la carpeta de la camara no este actualizada
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que aún no se haya creado, o que el path de la cámara no esté actualizado.\n"
			)--if else exist
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de caches de la camara (local) debe existir\n"
				log += "El path de caches de la camara (local) debe estar versionado\n"
				log += "El path de caches de la camara (local) debe estar actualizado\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de caches (local), es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_SVNlocalCachePathUpdated
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que este actualizada la carpeta de caches en network
	struct checkTask_SVNnetworkCachePathUpdated
	(
		id = lb.totalChecker.rollMain.TCH_SVNnetworkCachePathUpdated, --id de la tarea
		name = "SVN: path de caches de la camara versionado y actualizado. (network)", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene el path de render
			_filesPath = substituteString (tolower (path + "cache\\")) "z:" @"\\lbdata001\z"
							
			if doesFileExist _filesPath then --si existe el path
			(
				--averigua si esta actualizado preguntandole a svn
				if camSvnInfoNetwork == undefined then _svnInfo = lb.svn.svnGetFolderStatus _filesPath donotwait:true sleepTime:0.5
				else _svnInfo = camSvnInfoNetwork
				
				if not lb.svn.svnIsFolderVersioned _filesPath then --si no está versionado te avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está versionado.\n"
				)
				else --si esta actualizado sigue comprobando
				(
					--mira si esta actualizado
					_isUpdated = false
					for i=_svnInfo.count to 1 by -1 where (not _isUpdated and ((tolower _svnInfo[i].path) == (tolower _filesPath))) do
						_isUpdated = (_svnInfo[i].state == "U")
						
					if _isUpdated then --si dice que esta actualizadoo ahora busca cualquier archivo que no lo esté, porque a veces falla
						for i=1 to _svnInfo.count where _isUpdated do
							if (_svnInfo[i].state == "!") or (_svnInfo[i].state == "*") then
								_isUpdated = false
						
					if not _isUpdated then --si no está actualizada avisa
					(
						_fail = true --falla
						log += _filesPath + " -> No está actualizado.\n"
					)--if
				)--if else versioned
			)
			else --si no existe puede que no esté creado o que la carpeta de la camara no este actualizada
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que el path de la cámara no esté actualizado en network (en el servidor).\n"
			)--if else exist
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de caches de la camara (network) debe existir\n"
				log += "El path de caches de la camara (network) debe estar actualizado\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_SVNnetworkCachePathUpdated
	----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--RENDER CHECKS--
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que se hayan pasado los checks en los .max de render
	struct checkTask_CheckedRenderMaxFiles
	(
		id = lb.totalChecker.rollMain.TCH_CheckedRenderMaxFiles, --id de la tarea
		name = "Asset Checker: los archivos de max han pasado los checks", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"render\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = getFiles (_filesPath + ".max")
						
			for i=1 to _files.count do
			(
				_checked = getFileInfoIsChecked _files[i] info:maxFilesInfo[i]
					
				if not _checked then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> ERROR: no ha pasado el assetChecker.\n"
				)--if
				else --si ha pasado los checks, da warning si hay checks nuevos
				(						
					--Obtenemos el array que hay en el archivo, lo hacemos único y lo ordenamos.
					_fileChecks = getFileInfoChecksArray _files[i] info:maxFilesInfo[i]
					_fileChecks = makeUniqueArray _fileChecks
					sort _fileChecks
					
					--Obtenemos el array del listado de checks actual
					_checksArrayName = getFileInfoChecksArrayName _files[i] info:maxFilesInfo[i]
					if _checksArrayName == "" then _checksArrayName = "#()"
					_currentChecks = deepCopy (execute _checksArrayName)
					for i=_currentChecks.count to 1 by -1 where classof _currentChecks[i] == String do deleteItem _currentChecks i --Le quitamos los titulos
					_currentChecks = makeUniqueArray _currentChecks --Lo hacemos único
					sort _currentChecks --Lo ordenamos
					
					--Si el array de checks que pasó el archivo resulta ser igual que el actual entonces será ok sino lanzaremos un warning
					if not (lb.misc.areArraysEqual _currentChecks _fileChecks) then
					(
						if not _fail then state = warningMessage --pone el mensaje de warning
						log += _files[i] + " -> WARNING: ha pasado los checks, pero hay checks nuevos sin pasar.\n"
					)
				)
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de max de la camara deben haber pasado los checks del Asset Checker\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de render de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
			else if state == warningMessage then
			(
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "Hay archivos de max que pasaron los checks en su momento, pero posteriormente se han creado nuevos checks.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_CheckedRenderMaxFiles
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el naming convention de los .max de render
	struct checkTask_NCrenderMaxFiles
	(
		id = lb.totalChecker.rollMain.TCH_NCrenderMaxFiles, --id de la tarea
		name = "Naming Convention: Correcto en archivos .max de render", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"render\*")
			_files = getFiles (_filesPath + ".max")
				
			for i=1 to _files.count do
			(
				_fileInfo = getFileInfo _files[i]
				_filePath = getFileNamePath _files[i] --obtiene el path
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				_filePathMatchPattern = matchPattern _filePath pattern:lb.nc.NC_seqRenderPathPattern --comprueba que cumple el NC de path
				
				--En función de la versión de lpm miraremos si el archivo tiene que tener un nc u otro.
				if _fileInfo.lpmVersion == 1 then 
					_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqRenderNamePattern --comprueba que cumple el NC de archivo
				else
				(
					--Comprueba que cumple el NC de archivo con el patron nuevo, que no hay más que un guión entre paréntesis 
					--y que su tipo de su archivo esta entre los permitidos (segunda parte del paréntesis)
					_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqRenderNameNewPattern \
					and (filterString (filterString  _fileName "_")[5] "-").count == 2 \
					and finditem lb.nc.NC_seqRenderFileTypes (filterString _fileName "_(-).")[6] != 0
				)
				
				if not _filePathMatchPattern then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de path de render de max.\n"
				)--if
				
				if not _fileNameMatchPattern then --si no cumple el NC de archivo
				(
					--Si resulta que es de renderFx pasaremos del archivo
					if not matchPattern _fileName pattern:"seq_???*_cam???_renderFx_*.max" then
					(
						_fail = true
						log += _files[i] + " -> no cumple el NC de archivo de render de max.\n"
					)
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de render de max debe cumplir el patron: " + lb.nc.NC_seqRenderPathPattern + "\n"
				log += "El archivo de render de max debe cumplir este patron para escenas viejas: " + lb.nc.NC_seqRenderNamePattern + "\n"
				log += "El archivo de render de max debe cumplir este patron para escenas nuevas: " + lb.nc.NC_seqRenderNameNewPattern + "\n"
				log += "Ej: seq_001_cam010_render_fg(lit-all).max\n"
				log += "Ej: seq_015_cam080_render_(all).max\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de render de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NCrenderMaxFiles
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba el naming convention de los .max de render
	struct checkTask_NCrenderFxMaxFiles
	(
		id = lb.totalChecker.rollMain.TCH_NCrenderFxMaxFiles, --id de la tarea
		name = "Naming Convention: Correcto en archivos .max de renderFx", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"render\*")
			_files = getFiles (_filesPath + ".max")
				
			for i=1 to _files.count do
			(
				_fileInfo = getFileInfo _files[i]
				_filePath = getFileNamePath _files[i] --obtiene el path
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				_filePathMatchPattern = matchPattern _filePath pattern:lb.nc.NC_seqRenderFxPathPattern --comprueba que cumple el NC de path
				
				--En función de la versión de lpm miraremos si el archivo tiene que tener un nc u otro.
				if _fileInfo.lpmVersion == 1 then 
					_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqRenderFxNamePattern --comprueba que cumple el NC de archivo
				else
				(
					--Comprueba que cumple el NC de archivo con el patron nuevo, que no hay más que un guión entre paréntesis 
					--y que su tipo de su archivo esta entre los permitidos (segunda parte del paréntesis)
					_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqRenderFxNameNewPattern \
					and (filterString (filterString  _fileName "_")[5] "-").count == 2 \
					and finditem lb.nc.NC_seqRenderFileTypes (filterString _fileName "_(-).")[6] != 0
				)
				
				if not _filePathMatchPattern then --si no cumple el NC de path
				(
					
					_fail = true
					log += _files[i] + " -> no cumple el NC de path de renderFx de max.\n"
					
				)--if
				
				if not _fileNameMatchPattern then --si no cumple el NC de archivo
				(
					--Si resulta que es de render pasaremos del archivo
					if not matchPattern _fileName pattern:"seq_???*_cam???_render_*.max" then
					(
						_fail = true
						log += _files[i] + " -> no cumple el NC de archivo de renderFx de max.\n"
					)
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de render de max debe cumplir el patron: " + lb.nc.NC_seqRenderFxPathPattern + "\n"
				log += "El archivo de render de max debe cumplir este patron para escenas viejas: " + lb.nc.NC_seqRenderFxNamePattern + "\n"
				log += "El archivo de render de max debe cumplir este patron para escenas nuevas: " + lb.nc.NC_seqRenderFxNamePattern + "\n"
				log += "Ej: seq_001_cam010_renderFx_fg(lit-all).max\n"
				log += "Ej: seq_015_cam080_renderFx_(all).max\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de renderFx de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NCrenderFxMaxFiles
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba el naming convention de los .comp de fusion
	struct checkTask_NCpostFusionFiles
	(
		id = lb.totalChecker.rollMain.TCH_NCpostFusionFiles, --id de la tarea
		name = "Naming Convention: Correcto en archivos .comp de fusion", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + ".comp")
			
			for i=1 to _files.count do
			(
				_filePath = getFileNamePath _files[i] --obtiene el path
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				_filePathMatchPattern = matchPattern _filePath pattern:lb.nc.NC_seqPostPathPattern --comprueba que cumple el NC de path
				_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqPostFusionNamePattern --comprueba que cumple el NC de archivo
				
				if not _filePathMatchPattern then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de path de post de fusion.\n"
				)--if
				
				if not _fileNameMatchPattern then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de archivo de post de fusion.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de post de la secuencia debe cumplir el patron: " + lb.nc.NC_seqPostPathPattern + "\n"
				log += "El archivo de post de fusion debe cumplir el patron: " + lb.nc.NC_seqPostFusionNamePattern + "\n"
				log += "Ej: seq_007_cam020_post_v02.comp\n"
				log += "**************************************************************************************\n\n"
			)--if				
		)--executeFN
	)--checkTask_NCpostFusionFiles
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el naming convention de los .comp de fusion
	struct checkTask_NCpostNukeFiles
	(
		id = lb.totalChecker.rollMain.TCH_NCpostNukeFiles, --id de la tarea
		name = "Naming Convention: Correcto en archivos .nk de nuke", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + ".nk")
			
			for i=1 to _files.count do
			(
				_filePath = getFileNamePath _files[i] --obtiene el path
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				_filePathMatchPattern = matchPattern _filePath pattern:lb.nc.NC_seqPostPathPattern --comprueba que cumple el NC de path
				_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqPostNukeNamePattern --comprueba que cumple el NC de archivo
				
				if not _filePathMatchPattern then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de path de post de fusion.\n"
				)--if
				
				if not _fileNameMatchPattern then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de archivo de post de fusion.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de post de la secuencia debe cumplir el patron: " + lb.nc.NC_seqPostPathPattern + "\n"
				log += "El archivo de post de nuke debe cumplir el patron: " + lb.nc.NC_seqPostNukeNamePattern + "\n"
				log += "Ej: seq_007_cam020_post_v02.nk\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCpostNukeFiles
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el naming convention de los frames 
	struct checkTask_NCframeFiles
	(
		id = lb.totalChecker.rollMain.TCH_NCframeFiles, --id de la tarea
		name = "Naming Convention: Correcto en los frames del servidor de datos.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			--_filesPath = ((substituteString (tolower path) "z:\\sequence" "\\\\lbdata001\z\frame") + "*")
			_filesPath = ((substituteString (tolower path) "z:\\sequence" "\\\\lbdata002\z\frame") + "*")
			_files = getFiles (_filesPath + ".*")
			
			--los archivos de frames que lleven al final los 4 digitos de numero de frame, hay que agruaprlos por nombre y quedarnos solo con uno de ellos para las comprobaciones
			for i=_files.count to 1 by -1 do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				if matchPattern _fileName pattern:"*_????.*" then --si lleva numero de fotogramas al final
				(
					--Quitaremos aquellos que sean de render pero no de renderfx
					if not matchPattern _filename pattern:"seq_???*_cam???_renderFx_*.*" then
					(
						_frameNumber = (filterString (filterString _fileName "_")[(filterString _fileName "_").count] ".")[1]
						if lb.math.isNumeric _frameNumber then _files[i] = substituteString _files[i] ("_" + _frameNumber) "_####"
					)
					else
						deleteItem _files i
				)--if matchPattern
				else if matchPattern _fileName pattern: "*.db" then
					deleteItem _files i	
			)--for
			
			--limpia y ordena el array
			_files = makeUniqueArray _files
			sort _files
			
			for i=1 to _files.count do
			(
				_filePath = getFileNamePath _files[i] --obtiene el path
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				_filePathMatchPattern = matchPattern _filePath pattern:lb.nc.NC_seqFramePathPattern --comprueba que cumple el NC de path
				
				--Comprobamos el naming convention del nombre de archivo
				_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqFrameNamePattern \
				and (filterString _fileName "_").count == 6
				
				if not _filePathMatchPattern then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de path de frames.\n"
				)--if
				
				if not _fileNameMatchPattern then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de archivo de frames.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de frames de la secuencia debe cumplir el patron: " + lb.nc.NC_seqFramePathPattern + "\n"
				log += "Los archivos de frames deben cumplir el patron: " + lb.nc.NC_seqFrameNamePattern + "\n"
				log += "Ej: seq_001_cam020_bt(lit-all)_0534.png\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay frames de esta camara, es posible que no se hayan creado aún.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NCframeFiles
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba el naming convention de los frames de fx
	struct checkTask_NCFxFrameFiles
	(
		id = lb.totalChecker.rollMain.TCH_NCFxFrameFiles, --id de la tarea
		name = "Naming Convention: Correcto en los frames de fx del servidor de datos.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			--_filesPath = ((substituteString (tolower path) "z:\\sequence" "\\\\lbdata001\z\frame") + "*")
			_filesPath = ((substituteString (tolower path) "z:\\sequence" "\\\\lbdata002\z\frame") + "*")
			_files = getFiles (_filesPath + ".*")
			
			--los archivos de frames que lleven al final los 4 digitos de numero de frame, hay que agruaprlos por nombre y quedarnos solo con uno de ellos para las comprobaciones
			for i=_files.count to 1 by -1 do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				if matchPattern _fileName pattern:"*_????.*" then --si lleva numero de fotogramas al final
				(
					--Quitaremos aquellos que sean de render pero no de renderfx
					if not matchPattern _filename pattern:"seq_???*_cam???_render_*.*" then
					(
						_frameNumber = (filterString (filterString _fileName "_")[(filterString _fileName "_").count] ".")[1]
						if lb.math.isNumeric _frameNumber then _files[i] = substituteString _files[i] ("_" + _frameNumber) "_####"
					)
					else
						deleteItem _files i
				)--if matchPattern
				else if matchPattern _fileName pattern: "*.db" then
					deleteItem _files i
			)--for
			
			--limpia y ordena el array
			_files = makeUniqueArray _files
			sort _files
			print _files[1]
			for i=1 to _files.count do
			(
				
				_filePath = getFileNamePath _files[i] --obtiene el path
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				_filePathMatchPattern = matchPattern _filePath pattern:lb.nc.NC_seqFramePathPattern --comprueba que cumple el NC de path
				--Comprobamos el naming convention del nombre de archivo
				_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqFrameFxNamePattern \
				and (filterString _fileName "_").count == 6
				
				if not _filePathMatchPattern then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de path de frames.\n"
				)--if
				
				if not _fileNameMatchPattern then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de archivo de frames.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de frames de la secuencia de fx debe cumplir el patron: " + lb.nc.NC_seqFramePathPattern + "\n"
				log += "Los archivos de frames de fx deben cumplir el patron: " + lb.nc.NC_seqFrameFxNamePattern + "\n"
				log += "Ej: seq_001_cam020_renderFx_(lit-all)_0534.png\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay frames de esta camara, es posible que no se hayan creado aún.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NCFxFrameFiles
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba el naming convention del RootDir de lpm (donde se guardan los frames)
	struct checkTask_NClpmRootDir
	(
		id = lb.totalChecker.rollMain.TCH_NClpmRootDir, --id de la tarea
		name = "Naming Convention: RootDir de almacenamiento de frames de LPM correcto", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_files = maxFiles
			if maxfiles.count == 0 then
			(			
				--obtiene los archivos
				_filesPath = (path + @"render\*")
				_files = getFiles (_filesPath + ".max")
			)--if
				
			for i=1 to _files.count do
			(
				_lpmRootDir = getFileInfoLPMrootDir _files[i] info:maxFilesInfo[i]
				
				if _lpmRootDir == undefined then --si tiene almacenado el root dir de lpm
				(
					_fail = true
					log += _files[i] + " -> no tiene almacenado el RootDir de output LPM.\n"
				)
				else
				(
					_NCfail = not (matchPattern _lpmRootDir pattern:(lb.nc.NC_seqFramePathPattern + "*"))
					
					if _NCfail then --si falla saca mensaje
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".max - " + _lpmRootDir + " -> no cumple el NC de RootDir de LPM.\n"
					)--if 
				)--if else
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El RootDir de LPM debe cumplr el siguiente patron: " + lb.nc.NC_seqFramePathPattern + "\n"
				--log += @"Ej: \\lbdata001\Z\frame\seq_075\cam\cam020\" + "\n"
				--log += @"Ej: \\lbdata001\Z\frame\seq_011b\cam\cam010\" + "\n"
				log += @"Ej: \\lbdata002\Z\frame\seq_075\cam\cam020\" + "\n"
				log += @"Ej: \\lbdata002\Z\frame\seq_011b\cam\cam010\" + "\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de render de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NClpmRootDir
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el naming convention de las capas de lpm
	struct checkTask_NClpmLayers
	(
		id = lb.totalChecker.rollMain.TCH_NClpmLayers, --id de la tarea
		name = "Naming Convention: Correcto en capas de LPM", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			_lpmRootVersion = #() --para almacenar la version de LPM de cada file
			
			--obtiene los archivos
			_files = maxFiles
			if maxfiles.count == 0 then
			(			
				--obtiene los archivos
				_filesPath = (path + @"render\*")
				_files = getFiles (_filesPath + ".max")
			)--if
				
			for i=1 to _files.count do
			(
				_lpmLayers = getFileInfoLPMpasses _files[i] info:maxFilesInfo[i]
				_lpmRootVersion[i] = getFileInfoLPMversion _files[i] info:maxFilesInfo[i]
				
				if _lpmLayers.count == 0 then --si no tiene capas de lom lo considera erroneo
				(
					--si es un archivo de GI source, da igual si no tiene capas de LPM, ya que no se saca render de ellas.
					_fileName = getFileNameFile _files[i]
					_isGIsource =  matchPattern _fileName pattern:"*(*source*)"
					
					if not _isGIsource then --solo si no es GIsource falla
					(
						_fail = true
						log += _files[i] + " -> no tiene capas de LPM.\n"
					)
				)
				else
				(
					if _lpmRootVersion[i] < 2.0 then --si es a version antigua del NC de LPM
					(
						for _lpmLayer in _lpmLayers do --reocrre las capas mirando las que fallen
						(
							--mira si no cumplen los patrones
							_NCfail = not ((matchPattern _lpmLayer pattern:"(*)") or \
							(matchPattern _lpmLayer pattern:"bg(*)") or \
							(matchPattern _lpmLayer pattern:"fg(*)") or \
							(matchPattern _lpmLayer pattern:"x(*)") or \
							(matchPattern _lpmLayer pattern:"bg-*(*)") or \
							(matchPattern _lpmLayer pattern:"fg-*(*)") or \
							(matchPattern _lpmLayer pattern:"x-*(*)"))
							
							if _NCfail then --si falla saca mensaje
							(
								_fail = true
								log += (getFileNameFile _files[i]) + ".max - " + _lpmLayer + " -> no cumple el NC de capa de LPM.\n"
							)--if 
						)--for
					)
					else --si es la version nueva de NC de LPM
					(
						for _lpmLayer in _lpmLayers do --reocrre las capas mirando las que fallen
						(
							if matchPattern _lpmLayer pattern:lb.nc.NC_lpmPassPattern then --si cumple el patron establecido para las capas de LPM
							(
								_passParts = filterString _lpmLayer "-()" --obtiene las partess del pase
								
								--si las partes son validas y entran dentro de las contempladas
								_index = findItem lb.nc.NC_LPMpassContents _passParts[1]
								if _index != 0 then _index = findItem lb.nc.NC_LPMpassTypes _passParts[2]
								if _index != 0 then _index = findItem lb.nc.NC_LPMpassTypeSubtypes _passParts[3]
								
								if _index == 0 then --si alguna parte no esta en las contempladas da error
								(
									_fail = true
									log += ((getFileNameFile _files[i]) + ".max - " + _lpmLayer + " -> no cumple el NC de capa de LPM, hay partes que no tienen un valor válido.\n")
								)
								else --si estan en lo contemplado pero hay mala combinacion
								(
									_nonCorresponding = false --flag para saber si se corresponden los tipos
									
									--las capas de LIT solo pueden tener los tipos adeuados a ellas
									--las capas de PASS solo pueden tener los tipos adeuados a ellas
									if _passParts[2] == lb.nc.NC_LPMpassTypeLIT then
									(
										_index = findItem lb.nc.NC_LPMpassTypeLITSubtypes _passParts[3]
										if _index == 0 then _nonCorresponding = true
									)
									else if _passParts[2] == lb.nc.NC_LPMpassTypePASS then
									(
										_index = findItem lb.nc.NC_LPMpassTypePASSSubtypes _passParts[3]
										if _index == 0 then _nonCorresponding = true
									)--if else
									
									if _nonCorresponding then
									(
										_fail = true
										log += ((getFileNameFile _files[i]) + ".max - " + _lpmLayer + " -> no cumple el NC de capa de LPM, la tercera parte no es un valor válido para la segunda.\n")
									)
								)--if else
							)
							else --si no cumple el patron
							(
								_fail = true
								log += ((getFileNameFile _files[i]) + ".max - " + _lpmLayer + " -> no cumple el NC de capa de LPM.\n")
							)--if else
						)--for _lpmLayer
					)--if _lpmRootVersion
				)--if else
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				log = "**************************************************************************************\n\n" + log
				
				_thereIsLPMversion1 = false
				_thereIsLPMversion2 = false
				for i=1 to _lpmRootVersion.count do
					if _lpmRootVersion[i] < 2.0 then _thereIsLPMversion1 = true
					else _thereIsLPMversion2 = true
				
				if _thereIsLPMversion1 then --si es a version antigua del NC de LPM
				(
					--completa el log
					log += "\nAYUDA:\n"
					log += "El nombre de las capas de LPM debe cumplir el patron: (*) o fg(*) o bg(*) o x(*) o fg-*(*) o bg-*(*) o x-*(*)\n"
					log += "Ej: bg(lit-ambTopGi)\n"
					log += "Ej: fg(pass-motionBlur)\n"
					log += "Ej: (pass-mask)\n"
					log += "Ej: x(lit-tadeo-rimYellow)\n"
					log += "Ej: bg-mountains(lit-ambTopGi)\n"
					log += "Ej: fg-chr(pass-motionBlur)\n"
					log += "Ej: x-plants(lit-tadeo-rimYellow)\n"
					log += "**************************************************************************************\n\n"
				)
				
				if _thereIsLPMversion2 then
				(
					log += "\nAYUDA:\n"
					log +=  "LPM -> Render Dialog -> Path, debe cumplir el siguiente patron: seq_###_cam###_render_$Pass_\n"
					log +=  "o para renderFx: seq_###_cam###_renderFx_$Pass_\n"
					log +=  ("(Para los archivos nuevos con nuevo NC de LPM) El nombre de las capas de LPM debe seguir el siguiente patron: " + lb.nc.NC_lpmPassPattern + "\n")
					log +=  ("La parte 1 puede tener los siguientes valores: " + (lb.nc.NC_LPMpassContents as string) + "\n")
					log +=  ("La parte 2 puede tener los siguientes valores: " + (lb.nc.NC_LPMpassTypes as string) + "\n")
					log +=  ("Si la parte 2 tiene el valor " + lb.nc.NC_LPMpassTypeLIT + ", la parte 3 puede tener los siguientes valores: " + (lb.nc.NC_LPMpassTypeLITSubtypes as string) + "\n")
					log +=  ("Si la parte 2 tiene el valor " + lb.nc.NC_LPMpassTypePASS + ", la parte 3 puede tener los siguientes valores: " + (lb.nc.NC_LPMpassTypePASSsubtypes as string) + "\n")
					log +=  "Ejemplos:\n"
					log +=  "bg(lit-noGI-keyTadeo)\n"
					log +=  "fg(lit-GI-ambtRocks)\n"
					log +=  "all(pass-AO-chrs)\n"
					log +=  "fg(pass-element-chrShadows)\n"
					log += "**************************************************************************************\n\n"
				)
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de render de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NClpmLayers
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el path de los finalGather de las capas de LPM
	struct checkTask_NClpmLayersFGMcorrect
	(
		id = lb.totalChecker.rollMain.TCH_NClpmLayersFGMcorrect, --id de la tarea
		name = "Naming Convention: Paths de finalGatherMap correctos", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_files = maxFiles
			if maxfiles.count == 0 then
			(			
				--obtiene los archivos
				_filesPath = (path + @"render\*")
				_files = getFiles (_filesPath + ".max")
			)--if
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			for i=1 to _files.count do
			(
				_lpmFGMpaths = getFileInfoFinalGatherMaps _files[i] info:maxFilesInfo[i]
				_lpmFGMpathsPass = getFileInfoFinalGatherMapsLPMpasses _files[i] info:maxFilesInfo[i]
				
				for j=1 to _lpmFGMpaths.count do --reocrre los fgms
				(
					_fgm = _lpmFGMpaths[j]
					_fgmPass = _lpmFGMpathsPass[j]
					
					if _fgmPass != undefined then --si el fgm se usa en un pase de LPM
					(
						if not matchPattern _fgm pattern:(lb.nc.NC_seqRenderGIpathPattern + "*") then --si el archivo no esta en la carpeta correcta
						(
							_fail = true
							log += (getFileNameFile _files[i]) + ".max : " + _fgmPass + " : " + _fgm + " -> No se encuentra en la carpeta render/source de la camara.\n"
						)
						else
						(
							_fgmParts = filterString (getFileNamePath _fgm) "\\"
							_fgmSeq = ""
							_fgmCam = ""
							
							for part in _fgmParts do --recorre las partes y obtiene el numero de camara y de secuencia
							(
								if matchPattern part pattern:"seq_???*" then _fgmSeq = substituteString part "seq_" ""
								else if matchPattern part pattern:"cam???" then _fgmCam = substituteString part "cam" ""
							)--for
							
							if (_seqNumber != _fgmSeq) or (_camNumber != _fgmCam) then
							(
								_fail = true
								log += (getFileNameFile _files[i]) + ".max : " + _fgmPass + " : " + _fgm + " -> El numero de secuencia y/o de camara no coincide con el de la escena.\n"
							)--if
						)--if else
					)
					else --si es el FGM general de la escena
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".max : " + _fgm + " -> La configuracion de render general de la escena debe tener desactivado el uso de mapa de final gather.\n"
					)--if else
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de Final Gather Map FGM, deben apuntar a la carpeta render/source de la cámara.\n"
				log += "La configuracion de render general de la escena debe tener desactivado el uso de mapa de final gather.\n"
				log += "Ej: z:\sequence\seq_001\cam\cam010\render\source\seq_001_cam010_render_bg(lit-ambTopGi).fgm\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de render de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NClpmLayersFGMcorrect
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que la secuencia y la camara coincide con el path de los .max de render
	struct checkTask_NCrenderMaxFilesSeqAndCamOK
	(
		id = lb.totalChecker.rollMain.TCH_NCrenderMaxFilesSeqAndCamOK, --id de la tarea
		name = "Naming Convention: Numero de secuencia y camara correcto en archivos .max de render", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"render\*")
			_files = getFiles (_filesPath + ".max")
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			for i=1 to _files.count do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				_fileNameMatchSeqAndCam = matchPattern _fileName pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_render_*.max") --comprueba que cumple el NC de archivo
				
				if not _fileNameMatchSeqAndCam then
				(
					--Si no es de render miramos si es de renderFx
					_fileNameMatchSeqAndCam = matchPattern _filename pattern:("seq_???*_cam???_renderFx_*.max") 
				)
				
				
				--tiene que tener 3 o 4 caracteres y los 3 primeros ser numericos, si no falla
				if (filterString _seqNumber "-")[1].count ==3 or (filterString _seqNumber "-")[1].count == 4 then --si tiene 3 o 4 caracteres para la secuencia
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _seqNumber[1] or not lb.math.isNumeric _seqNumber[2] or not lb.math.isNumeric _seqNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de secuencia debe tener los tres primeros caracteres numéricos (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
					)
					
					--si tiene cuarto caracter
					if (filterString _seqNumber "-")[1].count == 4 and lb.math.isNumeric _seqNumber[4] then
					(
						_fail = true
						log += _files[i] + " -> si el numero de secuencia va seguido de otro caracter, no debe ser numérico (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
					)
				)
				else --si tiene menos de 3 o mas de 4 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia debe tener 3 digitos y opcionalmente una letra (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
				)
				
				--tiene que tener 3 caracteres y ser numericos, si no falla
				if _camNumber.count ==3 then --si tiene 3 caracteres para la camara
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _camNumber[1] or not lb.math.isNumeric _camNumber[2] or not lb.math.isNumeric _camNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de camara debe tener los caracteres numéricos.\n"
					)
				)
				else --si tiene menos de 3 o mas de 3 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de camara debe tener 3 digitos numéricos.\n"
				)
				
				if not _fileNameMatchSeqAndCam then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia o de camara no coincide con el path.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El archivo de render de max debe coincidir en numero de secuencia y camara con la ruta del archivo.\n"
				log += "Ej: seq_001_cam050_render_fg(lit).max\n"
				log += "Ej: seq_017b_cam010_render_(passes).max\n"
				log += "Ej(teaser): seq_054c-ts1_cam010_render_(passes).max\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCrenderMaxFilesSeqAndCamOK
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que la secuencia y la camara coincide con el path de los .max de render
	struct checkTask_NCRenderFxMaxFilesSeqAndCamOK
	(
		id = lb.totalChecker.rollMain.TCH_NCRenderFxMaxFilesSeqAndCamOK, --id de la tarea
		name = "Naming Convention: Numero de secuencia y camara correcto en archivos .max de renderFx", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"render\*")
			_files = getFiles (_filesPath + ".max")
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			for i=1 to _files.count do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				_fileNameMatchSeqAndCam = matchPattern _fileName pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_renderFx_*.max") --comprueba que cumple el NC de archivo
				if not _fileNameMatchSeqAndCam then
				(
					--Si no es de render miramos si es de renderFx
					_fileNameMatchSeqAndCam = matchPattern _filename pattern:("seq_???*_cam???_render_*.max") 
				)
				
				--tiene que tener 3 o 4 caracteres y los 3 primeros ser numericos, si no falla
				if (filterString _seqNumber "-")[1].count ==3 or (filterString _seqNumber "-")[1].count == 4 then --si tiene 3 o 4 caracteres para la secuencia
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _seqNumber[1] or not lb.math.isNumeric _seqNumber[2] or not lb.math.isNumeric _seqNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de secuencia debe tener los tres primeros caracteres numéricos (si es una secuencia de teaser, hablamos de los caracteres de antes del guión - ).\n"
					)
					
					--si tiene cuarto caracter
					if (filterString _seqNumber "-")[1].count == 4 and lb.math.isNumeric _seqNumber[4] then
					(
						_fail = true
						log += _files[i] + " -> si el numero de secuencia va seguido de otro caracter, no debe ser némerico (si es una secuencia de teaser, hablamos de los caracteres de antes del guión - ).\n"
					)
				)
				else --si tiene menos de 3 o mas de 4 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia debe tener 3 digitos y opcionalmente una letra (si es una secuencia de teaser, hablamos de los caracteres de antes del guión - ).\n"
				)
				
				--tiene que tener 3 caracteres y ser numericos, si no falla
				if _camNumber.count ==3 then --si tiene 3 caracteres para la camara
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _camNumber[1] or not lb.math.isNumeric _camNumber[2] or not lb.math.isNumeric _camNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de camara debe tener los caracteres numéricos.\n"
					)
				)
				else --si tiene menos de 3 o mas de 3 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de camara debe tener 3 digitos numéricos.\n"
				)
				
				if not _fileNameMatchSeqAndCam then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia o de camara no coincide con el path.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El archivo de render de max debe coincidir en numero de secuencia y camara con la ruta del archivo.\n"
				log += "Ej: seq_001_cam050_renderFx_fg(lit).max\n"
				log += "Ej: seq_017b_cam010_renderFx_(passes).max\n"
				log += "Ej(teaser): seq_325b-ts2_cam111_renderFx_(passes).max\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCRenderFxMaxFilesSeqAndCamOK
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que la secuencia y la camara coincide con el path de los comp de fusion
	struct checkTask_NCpostFusionFilesSeqAndCamOK
	(
		id = lb.totalChecker.rollMain.TCH_NCpostFusionFilesSeqAndCamOK, --id de la tarea
		name = "Naming Convention: Numero de secuencia y camara correcto en archivos .comp de fusion", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + ".comp")
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			for i=1 to _files.count do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				_fileNameMatchSeqAndCam = matchPattern _fileName pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_post*.comp") --comprueba que cumple el NC de archivo
				
				--tiene que tener 3 o 4 caracteres y los 3 primeros ser numericos, si no falla
				if (filterString _seqNumber "-")[1].count ==3 or (filterString _seqNumber "-")[1].count == 4 then --si tiene 3 o 4 caracteres para la secuencia
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _seqNumber[1] or not lb.math.isNumeric _seqNumber[2] or not lb.math.isNumeric _seqNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de secuencia debe tener los tres primeros caracteres numéricos (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
					)
					
					--si tiene cuarto caracter
					if (filterString _seqNumber "-")[1].count == 4 and lb.math.isNumeric _seqNumber[4] then
					(
						_fail = true
						log += _files[i] + " -> si el numero de secuencia va seguido de otro caracter, no debe ser némerico (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
					)
				)
				else --si tiene menos de 3 o mas de 4 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia debe tener 3 digitos y opcionalmente una letra (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
				)
				
				--tiene que tener 3 caracteres y ser numericos, si no falla
				if _camNumber.count ==3 then --si tiene 3 caracteres para la camara
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _camNumber[1] or not lb.math.isNumeric _camNumber[2] or not lb.math.isNumeric _camNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de camara debe tener los caracteres numéricos.\n"
					)
				)
				else --si tiene menos de 3 o mas de 3 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de camara debe tener 3 digitos numéricos.\n"
				)
				
				if not _fileNameMatchSeqAndCam then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia o de camara no coincide con el path.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El archivo de post de fusion debe coincidir en numero de secuencia y camara con la ruta del archivo.\n"
				log += "Ej: seq_001_cam050_post_v01.comp\n"
				log += "Ej: seq_017b_cam010_post_v02.comp\n"
				log += "Ej(teaser): seq_102a-ts2_cam010_post_v02.comp\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCpostFusionFilesSeqAndCamOK
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que la secuencia y la camara coincide con el path de los comp de fusion
	struct checkTask_NCpostNukeFilesSeqAndCamOK
	(
		id = lb.totalChecker.rollMain.TCH_NCpostNukeFilesSeqAndCamOK, --id de la tarea
		name = "Naming Convention: Numero de secuencia y camara correcto en archivos .nk de nuke", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + ".nk")
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			for i=1 to _files.count do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				_fileNameMatchSeqAndCam = matchPattern _fileName pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_post*.nk") --comprueba que cumple el NC de archivo
				
				--tiene que tener 3 o 4 caracteres y los 3 primeros ser numericos, si no falla
				if (filterString _seqNumber "-")[1].count ==3 or (filterString _seqNumber "-")[1].count == 4 then --si tiene 3 o 4 caracteres para la secuencia
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _seqNumber[1] or not lb.math.isNumeric _seqNumber[2] or not lb.math.isNumeric _seqNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de secuencia debe tener los tres primeros caracteres numéricos (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
					)
					
					--si tiene cuarto caracter
					if (filterString _seqNumber "-")[1].count == 4 and lb.math.isNumeric _seqNumber[4] then
					(
						_fail = true
						log += _files[i] + " -> si el numero de secuencia va seguido de otro caracter, no debe ser numérico (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
					)
				)
				else --si tiene menos de 3 o mas de 4 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia debe tener 3 digitos y opcionalmente una letra (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
				)
				
				--tiene que tener 3 caracteres y ser numericos, si no falla
				if _camNumber.count ==3 then --si tiene 3 caracteres para la camara
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _camNumber[1] or not lb.math.isNumeric _camNumber[2] or not lb.math.isNumeric _camNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de camara debe tener los caracteres numéricos.\n"
					)
				)
				else --si tiene menos de 3 o mas de 3 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de camara debe tener 3 digitos numéricos.\n"
				)
				
				if not _fileNameMatchSeqAndCam then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia o de camara no coincide con el path.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El archivo de post de nuke debe coincidir en numero de secuencia y camara con la ruta del archivo.\n"
				log += "Ej: seq_001_cam050_post_v01.nk\n"
				log += "Ej: seq_017b_cam010_post_v02.nk\n"
				log += "Ej(teaser): seq_102a-ts2_cam010_post_v02.nk\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCpostNukeFilesSeqAndCamOK
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que la secuencia y la camara coincide con el path de los frames
	struct checkTask_NCframeFilesSeqAndCamOK
	(
		id = lb.totalChecker.rollMain.TCH_NCframeFilesSeqAndCamOK, --id de la tarea
		name = "Naming Convention: Numero de secuencia y camara correcto en los frames", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos de render de max
			--_filesPath = ((substituteString (tolower path) "z:\\sequence" "\\\\lbdata001\z\frame") + "*")
			_filesPath = ((substituteString (tolower path) "z:\\sequence" "\\\\lbdata002\z\frame") + "*")
			_files = getFiles (_filesPath + ".*")
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
				
			--los archivos de frames que lleven al final los 4 digitos de numero de frame, hay que agruaprlos por nombre y quedarnos solo con uno de ellos para las comprobaciones
			for i=_files.count to 1 by -1 do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				if matchPattern _fileName pattern:"*_????.*" then --si lleva numero de fotogramas al final
				(
					_frameNumber = (filterString (filterString _fileName "_")[(filterString _fileName "_").count] ".")[1]
					if lb.math.isNumeric _frameNumber then _files[i] = substituteString _files[i] ("_" + _frameNumber) "_####"
				)--if matchPattern
				else if matchPattern _fileName pattern: "*.db" then
					deleteItem _files i
			)--for
			
			--limpia y ordena el array
			_files = makeUniqueArray _files
			sort _files
			
			--Ahora quitaremos todas aquellas que sean de renderFx
			for i=_files.count to 1 by -1 do
			(
				if (filterString (getFilenameFile _files[i]) "_").count > 4 and (filterString (getFilenameFile _files[i]) "_")[4] == "renderFx" then
				(
					deleteItem _files i
				)
			)
			
			for i=1 to _files.count do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				_fileNameMatchSeqAndCam = matchPattern _fileName pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_render_*.*") --comprueba que cumple el NC de archivo
				
				--tiene que tener 3 o 4 caracteres y los 3 primeros ser numericos, si no falla
				if (filterString _seqNumber "-")[1].count ==3 or (filterString _seqNumber "-")[1].count == 4 then --si tiene 3 o 4 caracteres para la secuencia
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _seqNumber[1] or not lb.math.isNumeric _seqNumber[2] or not lb.math.isNumeric _seqNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de secuencia debe tener los tres primeros caracteres numéricos (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
					)
					
					--si tiene cuarto caracter
					if (filterString _seqNumber "-")[1].count == 4 and lb.math.isNumeric _seqNumber[4] then
					(
						_fail = true
						log += _files[i] + " -> si el numero de secuencia va seguido de otro caracter, no debe ser numérico (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
					)
				)
				else --si tiene menos de 3 o mas de 4 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia debe tener 3 digitos y opcionalmente una letra (si la secuencia es de teaser entonces nos referimos a la parte de antes del guión - ).\n"
				)
				
				--tiene que tener 3 caracteres y ser numericos, si no, falla
				if _camNumber.count ==3 then --si tiene 3 caracteres para la camara
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _camNumber[1] or not lb.math.isNumeric _camNumber[2] or not lb.math.isNumeric _camNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de camara debe tener los caracteres numéricos.\n"
					)
				)
				else --si tiene menos de 3 o mas de 3 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de camara debe tener 3 digitos numéricos.\n"
				)
				
				if not _fileNameMatchSeqAndCam then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia o de camara no coincide con el path.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El frame debe coincidir en numero de secuencia y camara con la ruta del archivo.\n"
				log += "Ej: seq_001_cam050_render_fg(lit-all)_0522.png\n"
				log += "Ej: seq_017b_cam010_render_bg(chr-all)_1234.jpg\n"
				log += "Ej(teaser): seq_234a-ts34_cam010_render_bg(chr-all)_1234.jpg\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCframeFilesSeqAndCamOK
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que la secuencia y la camara coincide con el path de los frames
	struct checkTask_NCFxFrameFilesSeqAndCamOK
	(
		id = lb.totalChecker.rollMain.TCH_NCFxFrameFilesSeqAndCamOK, --id de la tarea
		name = "Naming Convention: Numero de secuencia y camara correcto en los frames de Fx", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos de render de max
			--_filesPath = ((substituteString (tolower path) "z:\\sequence" "\\\\lbdata001\z\frame") + "*")
			_filesPath = ((substituteString (tolower path) "z:\\sequence" "\\\\lbdata002\z\frame") + "*")
			_files = getFiles (_filesPath + ".*")
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
				
			--los archivos de frames que lleven al final los 4 digitos de numero de frame, hay que agruaprlos por nombre y quedarnos solo con uno de ellos para las comprobaciones
			for i=_files.count to 1 by -1 do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				if matchPattern _fileName pattern:"*_????.*" then --si lleva numero de fotogramas al final
				(
					_frameNumber = (filterString (filterString _fileName "_")[(filterString _fileName "_").count] ".")[1]
					if lb.math.isNumeric _frameNumber then _files[i] = substituteString _files[i] ("_" + _frameNumber) "_####"
				)--if matchPattern
				else if matchPattern _fileName pattern: "*.db" then
					deleteItem _files i
			)--for
			
			--limpia y ordena el array
			_files = makeUniqueArray _files
			sort _files
			
			--Ahora quitaremos todas aquellas que sean de renderFx
			for i=_files.count to 1 by -1 do
			(
				if (filterString (getFilenameFile _files[i]) "_").count > 4 and (filterString (getFilenameFile _files[i]) "_")[4] == "render" then
				(
					deleteItem _files i
				)
			)
			
			for i=1 to _files.count do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				_fileNameMatchSeqAndCam = matchPattern _fileName pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_renderFx_*.*") --comprueba que cumple el NC de archivo
				
				--tiene que tener 3 o 4 caracteres y los 3 primeros ser numericos, si no falla
				if _seqNumber.count ==3 or _seqNumber.count == 4 then --si tiene 3 o 4 caracteres para la secuencia
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _seqNumber[1] or not lb.math.isNumeric _seqNumber[2] or not lb.math.isNumeric _seqNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de secuencia debe tener los tres primeros caracteres numéricos.\n"
					)
					
					--si tiene cuarto caracter
					if _seqNumber.count == 4 and lb.math.isNumeric _seqNumber[4] then
					(
						_fail = true
						log += _files[i] + " -> si el numero de secuencia va seguido de otro caracter, no debe ser numérico.\n"
					)
				)
				else --si tiene menos de 3 o mas de 4 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia debe tener 3 digitos y opcionalmente una letra.\n"
				)
				
				--tiene que tener 3 caracteres y ser numericos, si no, falla
				if _camNumber.count ==3 then --si tiene 3 caracteres para la camara
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _camNumber[1] or not lb.math.isNumeric _camNumber[2] or not lb.math.isNumeric _camNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de camara debe tener los caracteres numéricos.\n"
					)
				)
				else --si tiene menos de 3 o mas de 3 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de camara debe tener 3 digitos numéricos.\n"
				)
				
				if not _fileNameMatchSeqAndCam then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia o de camara no coincide con el path.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El frame de Fx debe coincidir en numero de secuencia y camara con la ruta del archivo.\n"
				log += "Ej: seq_001_cam050_renderFx_fg(lit-all)_0522.png\n"
				log += "Ej: seq_017b_cam010_renderFx_bg(chr-all)_1234.jpg\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCFxFrameFilesSeqAndCamOK
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que este actualizada la carpeta de render
	struct checkTask_SVNrenderPathUpdated
	(
		id = lb.totalChecker.rollMain.TCH_SVNrenderPathUpdated, --id de la tarea
		name = "SVN: path de render versionado y actualizado. (Avisa tambien de los commit sin hacer).", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene el path de render
			_filesPath = (path + "render\\")
			_files = getFiles (_filesPath + "*.max")
			
			if doesFileExist _filesPath then --si existe el path
			(
				_svnInfo = #()
				
				if not lb.svn.svnIsFolderVersioned _filesPath then --si no está versionado te avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está versionado.\n"
				)
				else --si esta versionado se comprueba que esté actualizado.
				(
					--averigua si esta actualizado preguntandole a svn
					_svnInfo = lb.svn.svnGetFolderStatus _filesPath donotwait:true sleepTime:0.5
					_isUpdated = if _svnInfo.count == 1 then (_svnInfo[_svnInfo.count].state == "U") else false
					
					if _isUpdated then --si dice que esta actualizadoo ahora busca cualquier archivo que no lo esté, porque a veces falla
						for i=1 to _svnInfo.count where _isUpdated do
							if (_svnInfo[i].state == "!") or (_svnInfo[i].state == "*") then
								_isUpdated = false
					
					if not _isUpdated then --si no está actualizada avisa
					(
						_fail = true --falla
						log += _filesPath + " -> No está actualizado.\n"
					)
					
					for i=1 to _files.count do --recorre los archivos del path buscando lo que necesiten un commit
					(
						_notVersioned = not lb.svn.svnIsFileVersioned _files[i] donotwait:true statusInfo:_svnInfo --mira si está versionado
						if _notVersioned then
						(
							_fail = true --falla
							log += _files[i] + " -> No está versionado.\n"
						)
						
						_status = lb.svn.svnGetFileStatus _files[i] statusInfo:_svnInfo --obtiene el estado de ese archivo
						_needsCommit = (_status == "A") or (_status == "D") or (_status == "G") or (_status == "M") or (_status == "R") --mira si necesita un commit
						if _needsCommit then
						(
							_fail = true --falla
							log += _files[i] + " -> Necesita un commit.\n"
						)
					)--for _files	
				)--if else				
			)
			else --si no existe puede que no esté creado o que la carpeta de la camara no este actualizada
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que aún no se haya creado, o que el path de la cámara no esté actualizado.\n"
			)--if else
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de render de max debe existir\n"
				log += "El path de render de max debe estar versionado\n"
				log += "El path de render de max debe estar actualizado (en local)\n"
				log += "**************************************************************************************\n\n"
			)--if
		-- 				else if _files.count == 0 then --si no hay archivos avisa con un warning
		-- 				(
		-- 					state = warningMessage --pone el mensaje de warning
		-- 					
		-- 					--completa el log
		-- 					log = "**************************************************************************************\n\n"
		-- 					log += "No hay archivos de render de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
		-- 					log += "**************************************************************************************\n\n"
		-- 				)
		)--executeFN
	)--checkTask_SVNRenderPathUpdated
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que este actualizada la carpeta de post
	struct checkTask_SVNpostPathUpdated
	(
		id = lb.totalChecker.rollMain.TCH_SVNpostPathUpdated, --id de la tarea
		name = "SVN: path de post versionado y actualizado. (Avisa tambien de los commit sin hacer).", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene el path de render
			_filesPath = (path + "post\\")
			_files = #() --array para los archivos
			
			if doesFileExist _filesPath then --si existe el path
			(
				if not lb.svn.svnIsFolderVersioned _filesPath then --si no está versionado te avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está versionado.\n"
				)
				else --si esta versionado se comprueba que esté actualizado.
				(
					--averigua si esta actualizado preguntandole a svn
					_svnInfo = lb.svn.svnGetFolderStatus _filesPath donotwait:true sleepTime:0.5
					_isUpdated = if _svnInfo.count == 1 then (_svnInfo[_svnInfo.count].state == "U") else false
					
					if _isUpdated then --si dice que esta actualizadoo ahora busca cualquier archivo que no lo esté, porque a veces falla
						for i=1 to _svnInfo.count where _isUpdated do
							if (_svnInfo[i].state == "!") or (_svnInfo[i].state == "*") then
								_isUpdated = false
					
					if not _isUpdated then --si no está actualizada avisa
					(
						_fail = true --falla
						log += _filesPath + " -> No está actualizado.\n"
					)
					
					_files = getFiles (_filesPath + @"*.nk") + getFiles (_filesPath + @"*.comp") --obtiene los archivos del path
					for i=1 to _files.count do --recorre los archivos del path buscando lo que necesiten un commit
					(
						_notVersioned = not lb.svn.svnIsFileVersioned _files[i] donotwait:true statusInfo:_svnInfo --mira si está versionado
						if _notVersioned then
						(
							_fail = true --falla
							log += _files[i] + " -> No está versionado.\n"
						)
						
						_status = lb.svn.svnGetFileStatus _files[i] statusInfo:_svnInfo --obtiene el estado de ese archivo
						_needsCommit = (_status == "A") or (_status == "D") or (_status == "G") or (_status == "M") or (_status == "R") --mira si necesita un commit
						if _needsCommit then
						(
							_fail = true --falla
							log += _files[i] + " -> Necesita un commit.\n"
						)
					)--for _files
				)--if else versioned
			)
			else --si no existe puede que no esté creado o que la carpeta de la camara no este actualizada
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que aún no se haya creado, o que el path de la cámara no esté actualizado.\n"
			)--if else exist
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de post de la camara debe existir\n"
				log += "El path de post de la camara debe estar versionado\n"
				log += "El path de post de la camara debe estar actualizado (en local)\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de composicion, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_SVNPostPathUpdated
	-----------------------------------------------------------------------------------
		
	-----------------------------------------------------------------------------------
	--comprueba que este actualizada la carpeta de texturas en local
	struct checkTask_SVNlocalTexturePathUpdated
	(
		id = lb.totalChecker.rollMain.TCH_SVNlocalTexturePathUpdated, --id de la tarea
		name = "SVN: path de texturas (local) versionado y actualizado. (Avisa tambien de los commit sin hacer).", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene el path de render
			_pathParts = filterString path "\\"
			_filesPath = ""
			_stop = false
			for i=1 to _pathParts.count where not (matchPattern _pathParts[i] pattern:"cam*") do _filesPath += _pathParts[i] + "\\"
						
			_filesPath = (_filesPath + "texture\\")
			_files = getFiles (_filesPath + "*.*")
			_files += getFiles (_filesPath + @"1x1\*.*")
			_files += getFiles (_filesPath + @"1x2\*.*")
			_files += getFiles (_filesPath + @"1x3\*.*")
			_files += getFiles (_filesPath + @"1x4\*.*")
			_files += getFiles (_filesPath + @"1x8\*.*")
			
			if doesFileExist _filesPath then --si existe el path
			(
				_svnInfo = #()
				
				if not lb.svn.svnIsFolderVersioned _filesPath then --si no está versionado te avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está versionado.\n"
				)
				else --si esta versionado se comprueba que esté actualizado.
				(
					--averigua si esta actualizado preguntandole a svn
					_svnInfo = lb.svn.svnGetFolderStatus _filesPath donotwait:true sleepTime:0.5
					_isUpdated = if _svnInfo.count == 1 then (_svnInfo[_svnInfo.count].state == "U") else false
					
					if _files.count == 0 then
					(
						_fail = true --falla
						log += _filesPath + " -> No tiene ninguna textura.\n"
					)
					else
					(
						for i=1 to _files.count do --recorre los archivos del path buscando lo que necesiten un commit
						(
							_notVersioned = not lb.svn.svnIsFileVersioned _files[i] donotwait:true statusInfo:_svnInfo --mira si está versionado
							if _notVersioned then
							(
								_fail = true --falla
								log += _files[i] + " -> No está versionado, puede que necesite ser añadido, o solo sea temporal.\n"
							)
							
							_status = lb.svn.svnGetFileStatus _files[i] statusInfo:_svnInfo --obtiene el estado de ese archivo
							
							_needsCommit = (_status == "A") or (_status == "D") or (_status == "G") or (_status == "M") or (_status == "R") --mira si necesita un commit
							if _needsCommit then
							(
								_fail = true --falla
								log += _files[i] + " -> Necesita un commit.\n"
							)
							
							--mira si no está actualizado
							if (_status == "!") or (_status == "*") then _isUpdated = false
						)--for _files	
					)--if else _files
				)--if else
				
				if not _isUpdated then --si no está actualizada avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está actualizado.\n"
				)
			)
			else --si no existe puede que no esté creado o que la carpeta de la camara no este actualizada
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que aún no se haya creado, o que el path de la cámara no esté actualizado.\n"
			)--if else
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de texturas (local) de la secuencia debe existir\n"
				log += "El path de texturas (local) de la secuencia debe estar versionado\n"
				log += "El path de texturas (local) de la secuencia debe estar actualizado (en local)\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_SVNlocalTexturePathUpdated
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que este actualizada la carpeta de texturas en local
	struct checkTask_SVNnetworkTexturePathUpdated
	(
		id = lb.totalChecker.rollMain.TCH_SVNnetworkTexturePathUpdated, --id de la tarea
		name = "SVN: path de texturas (network) versionado y actualizado. (Avisa tambien de los commit sin hacer).", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene el path de render
			_pathParts = filterString path "\\"
			_filesPath = ""
			_stop = false
			for i=1 to _pathParts.count where not (matchPattern _pathParts[i] pattern:"cam*") do _filesPath += _pathParts[i] + "\\"
			_filesPath = substituteString (tolower _filesPath) "z:" @"\\lbdata001\z"
			
			_filesPath = (_filesPath + "texture\\")
			_files = getFiles (_filesPath + "*.*")
			_files += getFiles (_filesPath + @"1x1\*.*")
			_files += getFiles (_filesPath + @"1x2\*.*")
			_files += getFiles (_filesPath + @"1x3\*.*")
			_files += getFiles (_filesPath + @"1x4\*.*")
			_files += getFiles (_filesPath + @"1x8\*.*")
			
			for i=_files.count to 1 by -1 where findString _files[i] "thumbs.db" != undefined do deleteItem _files i
			
			if doesFileExist _filesPath then --si existe el path
			(
				_svnInfo = #()
				
				if not lb.svn.svnIsFolderVersioned _filesPath then --si no está versionado te avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está versionado.\n"
				)
				else --si esta versionado se comprueba que esté actualizado.
				(
					--averigua si esta actualizado preguntandole a svn
					_svnInfo = lb.svn.svnGetFolderStatus _filesPath donotwait:true sleepTime:0.5
					_isUpdated = if _svnInfo.count == 1 then (_svnInfo[_svnInfo.count].state == "U") else false
					
					if _files.count == 0 then
					(
						_fail = true --falla
						log += _filesPath + " -> No tiene ninguna textura.\n"
					)
					else
					(
						for i=1 to _files.count do --recorre los archivos del path buscando lo que necesiten un commit
						(
							_notVersioned = not lb.svn.svnIsFileVersioned _files[i] donotwait:true statusInfo:_svnInfo --mira si está versionado
							if _notVersioned then
							(
								_fail = true --falla
								log += _files[i] + " -> No está versionado, puede que necesite ser añadido, o solo sea temporal.\n"
							)
							
							_status = lb.svn.svnGetFileStatus _files[i] statusInfo:_svnInfo --obtiene el estado de ese archivo
							
							_needsCommit = (_status == "A") or (_status == "D") or (_status == "G") or (_status == "M") or (_status == "R") --mira si necesita un commit
							if _needsCommit then
							(
								_fail = true --falla
								log += _files[i] + " -> Necesita un commit.\n"
							)
							
							--mira si no está actualizado
							if (_status == "!") or (_status == "*") then _isUpdated = false
						)--for _files	
					)--if else _files
				)--if else
				
				if not _isUpdated then --si no está actualizada avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está actualizado.\n"
				)
			)
			else --si no existe puede que no esté creado o que la carpeta de la camara no este actualizada
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que aún no se haya creado, o que el path de la cámara no esté actualizado.\n"
			)--if else
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de texturas (network) de la secuencia debe existir\n"
				log += "El path de texturas (network) de la secuencia debe estar versionado\n"
				log += "El path de texturas (network) de la secuencia debe estar actualizado (en local)\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_SVNnetworkTexturePathUpdated
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que este actualizada la carpeta de post
	struct checkTask_framePathExist
	(
		id = lb.totalChecker.rollMain.TCH_framePathExist, --id de la tarea
		name = "Frames: El path de frames de la camara debe existir.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (substituteString (tolower path) "z:\\sequence" "\\\\lbdata002\z\frame")
			_files = getFiles (_filesPath + "*.*")
			
			--los archivos de frames que lleven al final los 4 digitos de numero de frame, hay que agruaprlos por nombre y quedarnos solo con uno de ellos para las comprobaciones
			for i=_files.count to 1 by -1 do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				if matchPattern _fileName pattern:"*_????.*" then --si lleva numero de fotogramas al final
				(
					_frameNumber = (filterString (filterString _fileName "_")[(filterString _fileName "_").count] ".")[1]
					if lb.math.isNumeric _frameNumber then _files[i] = substituteString _files[i] ("_" + _frameNumber) "_####"
				)--if matchPattern
				else if matchPattern _fileName pattern: "*.db" then
					deleteItem _files i	
			)--for
			
			--limpia y ordena el array
			_files = makeUniqueArray _files
			sort _files
			
			if not doesFileExist _filesPath then --si no existe puede que no esté creado aún
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que aún no se haya creado.\n"
			)--if else exist
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de frames de la camara debe existir\n"
				log += "Ej: \\\\lbdata002\\z\\frame\\seq_002\\cam\\cam120\\\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay frames en el path, puede que no se hayan lanzado renders aun de esta cámara.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_framePathExist
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba la coherencia entre fotogramas, archivos de max con LPM y archivos de post
	struct checkTask_frameUsageCoherence
	(
		id = lb.totalChecker.rollMain.TCH_frameUsageCoherence, --id de la tarea
		name = "Frames: Coherencia entre outputs de LPM, Frames y Loaders de Postproduccion (.nuke y .comp)", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			-------------------------------------------------------------------------------------------
			--obtiene la informacion de los outputs -------------------------------------
			
			-------------------------------------------------------------------------------
			struct renderOutputInfo --struct para la informacion de ouputs de la camara
			(
				path = "", --el path del output
				fileExist = false, --indica si existe
				
				--para comprobar si la secuencia y la camara coinciden en el path y el nombre del frame. Tambien para compararlo con el path del check
				pathSeq = "",
				pathCam = "",
				fileSeq = "",
				fileCam = "",
				
				hasFrame = false, --para saber si el render esta hecho
				
				hasLPMpass = false, --para saber si viene de un pase de LPM
				lpmPassName = "", --para saber el nombre del pase de lpm del que viene
				maxFile = "", --para saber el nombre del max del que viene
					
				hasNukeRead = false, --para saber si hay un nodo read de nuke que lo contenga
				nukeReadName = "", --para guardar el nombre del nodo read
				nukeFile = "", --para saber el archivo de nuke del que viene
				
				hasFusionLoader = false, --para saber si hay un nodo loader de fusion que lo contenga
				fusionLoaderName = "", --para guardar el nombre del nodo loader
				fusionFile = "", --para saber el archivo de fusion del que viene
				
				state = #(0,0,0,0) --arrays de estados posibles #(fileExist, hasLPMpass, hasNukeRead, hasFusionLoader)
			)--renderOutputInfo
			-------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--arrays de informacion
			_renderOutputInfo = #() --para almacenar un array de structs de informacion de outputs de render
			
			_renderMaxFilesPath = (path + @"render\*")
			_renderMaxFiles = if maxFiles.count != 0 then maxFiles else getFiles (_renderMaxFilesPath + ".max")
			_renderMaxLPMpasses = #() --para guardar un array de nombres de capa de lpm por cada archivo max
			_renderMaxLPMpassesOpts = #() --para guardar un array de ouputs por cada archivo max
			
			_postFilesPath = (path + @"post\*") --path de post
			_postFusionFiles = getFiles (_postFilesPath + ".comp") --arhivos de fusion
			_postFusionIptsNames = #() --para guardar el nombre del nodo que lleva cada input de post
			_postFusionIpts = #() --para guardar un array de inputs por cada arhivo de post
			_postNukeFiles = getFiles (_postFilesPath + ".nk") --archivos de nuke
			_postNukeIptsNames = #() --para guardar el nombre del nodo que lleva cada input de post
			_postNukeIpts = #() --para guardar un array de inputs por cada arhivo de post
			
			_framesPath = (substituteString (tolower (path + @"*")) @"z:\sequence" @"\\lbdata002\z\frame")
			_frameOpts = getFiles (_framesPath + ".*") --almacena todos los outputs de fotogramas
			-------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--FRAMES
			--los archivos de frames que lleven al final los 4 digitos de numero de frame, hay que agruaprlos por nombre y quedarnos solo con uno de ellos para las comprobaciones
			for i=_frameOpts.count to 1 by -1 do
			(
				_fileName = (getFileNameFile _frameOpts[i]) + (getFileNameType _frameOpts[i]) --obtiene el nombre del archivo
				
				if matchPattern _fileName pattern:"*_????.*" then --si lleva numero de fotogramas al final
				(
					_frameNumber = (filterString (filterString _fileName "_")[(filterString _fileName "_").count] ".")[1]
					if lb.math.isNumeric _frameNumber then _frameOpts[i] = substituteString _frameOpts[i] ("_" + _frameNumber) "_####"
				)--if matchPattern
				else if matchPattern _fileName pattern: "*.db" then
					deleteItem _frameOpts i	
			)--for
			
			--limpia y ordena el array
			_frameOpts = makeUniqueArray _frameOpts 
			sort _frameOpts
			------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--LPM
			--obtiene los opts de LPM por cada max
			for i=1 to _renderMaxFiles.count do
			(
				_renderMaxLPMpasses[i] = (getFileInfoLPMpasses _renderMaxFiles[i] info:maxFilesInfo[i])
				_renderMaxLPMpassesOpts[i] = deepCopy (getFileInfoLPMpassesOutputs _renderMaxFiles[i] info:maxFilesInfo[i])
				
				for j=1 to _renderMaxLPMpassesOpts[i].count do
				(
					_renderMaxLPMpassesOpts[i][j] = substituteString _renderMaxLPMpassesOpts[i][j] (getFileNameFile _renderMaxLPMpassesOpts[i][j]) ((getFileNameFile _renderMaxLPMpassesOpts[i][j]) + "####")
					--_renderMaxLPMpassesOpts[i][j] = ((tolower (getFileNamePath _renderMaxLPMpassesOpts[i][j])) + (getFileNameFile _renderMaxLPMpassesOpts[i][j]) + (getFileNameType _renderMaxLPMpassesOpts[i][j]))
				)
			)--for
			-------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
				
			-------------------------------------------------------------------------------
			-------------------------------------------------------------------------------
			--rellena la informacion de los outputs en el array de structs
			
			--funcion para saber el indice de un struct de output
			fn _getRenderOutputInfoIndex path _renderOutputInfo =
			(
				_index = 0
				for i=1 to _renderOutputInfo.count where (tolower _renderOutputInfo[i].path) == (tolower path) do _index = i
				_index
			)
			
			--rellena OUTPUTS con la informacion de NUKE
			for i=1 to _postNukeFiles.count do
				for j=1 to _postNukeIpts[i].count do
				(
					_index = _getRenderOutputInfoIndex _postNukeIpts[i][j] _renderOutputInfo --mira si el output ya esta almacenado
					
					if _index != 0 then
					(
						_renderOutputInfo[_index].hasNukeRead = true
						_renderOutputInfo[_index].nukeReadName = _postNukeIptsNames[i][j]
						_renderOutputInfo[_index].nukeFile = _postNukeFiles[i]
					)
					else
					(
						_roi = renderOutputInfo path:_postNukeIpts[i][j] hasNukeRead:true nukeReadName:_postNukeIptsNames[i][j] nukeFile:_postNukeFiles[i] --fileExist:(doesFileExist _postNukeIpts[i][j])
						append _renderOutputInfo _roi
					)
				)--for
				
			--rellena OUTPUTS con la informacion de FUSION
			for i=1 to _postFusionFiles.count do
				for j=1 to _postFusionIpts[i].count do
				(
					_index = _getRenderOutputInfoIndex _postFusionIpts[i][j] _renderOutputInfo --mira si el output ya esta almacenado
					
					if _index != 0 then --si ya estaba almaenado, completa parametros
					(
						_renderOutputInfo[_index].hasFusionLoader = true
						_renderOutputInfo[_index].fusionLoaderName = _postFusionIptsNames[i][j]
						_renderOutputInfo[_index].fusionFile = _postFusionFiles[i]
					)							
					else --si no estaba, añade una entrada nueva
					(
						_roi = renderOutputInfo path:_postFusionIpts[i][j] hasFusionLoader:true fusionLoaderName:_postFusionIptsNames[i][j] fusionFile:_postFusionFiles[i] --fileExist:(doesFileExist _postFusionIpts[i][j])
						append _renderOutputInfo _roi
					)--if else
				)--for
				
			--rellena OUTPUTS con la informacion de LPM
			for i=1 to _renderMaxFiles.count do
				for j=1 to _renderMaxLPMpassesOpts[i].count do
				(
					_index = _getRenderOutputInfoIndex _renderMaxLPMpassesOpts[i][j] _renderOutputInfo --mira si el output ya esta almacenado
					
					if _index != 0 then --si ya estaba almaenado, completa parametros
					(
						_renderOutputInfo[_index].hasLPMpass = true
						_renderOutputInfo[_index].lpmPassName = _renderMaxLPMpasses[i][j]
						_renderOutputInfo[_index].maxFile = _renderMaxFiles[i]
					)							
					else --si no estaba, añade una entrada nueva
					(
						_roi = renderOutputInfo path:_renderMaxLPMpassesOpts[i][j] hasLPMpass:true lpmPassName:_renderMaxLPMpasses[i][j] maxFile:_renderMaxFiles[i] --fileExist:(doesFileExist _renderMaxLPMpassesOpts[i][j])
						append _renderOutputInfo _roi
					)--if else
				)--for
			
			--rellena OUTPUTS con la informacion de FRAMES
			for i=1 to _frameOpts.count do
			(
				_index = _getRenderOutputInfoIndex _frameOpts[i] _renderOutputInfo --mira si el output ya esta almacenado
				
				if _index != 0 then --si ya estaba almaenado, completa parametros
					_renderOutputInfo[_index].hasFrame = true
				else --si no estaba, añade una entrada nueva
				(
					_roi = renderOutputInfo path:_frameOpts[i] hasFrame:true --fileExist:(doesFileExist _frameOpts[i])
					append _renderOutputInfo _roi
				)--if else
			)--for
			
			--rellena la informacion de si el path EXISTE y el estado STATE #(1,0,1,1)
			--tambien relena los numeros de camara y de secuencia
			for i=1 to _renderOutputInfo.count do
			(
				_roi = _renderOutputInfo[i] --elemento actual
				_roi.fileExist = ((getFiles (substituteString _roi.path "####" "*")).count != 0)
				_roi.state = #((if _roi.fileExist then 1 else 0), (if _roi.hasLPMpass then 1 else 0), (if _roi.hasNukeRead then 1 else 0), (if _roi.hasFusionLoader then 1 else 0))
				
				_pathParts = filterString (getFileNamePath _roi.path) "\\"
				_fileParts = filterString (getFileNameFile _roi.path) "_"
				
				for p in _pathParts do --rellena la secuencia y la camara del path
				(
					p = tolower p
					if matchPattern p pattern:"seq_???*" then _roi.pathSeq = p
					else if matchPattern p pattern:"cam???" then _roi.pathCam = p
				)--for
				
				for j=1 to _fileParts.count do --rellena la secuencua y la camara del nombre del archivo
				(
					p = tolower _fileParts[j]
					if matchPattern p pattern:"cam???" then _roi.fileCam = p
					else if (p == "seq") and (_fileParts[j+1] != undefined) and (lb.math.isNumeric (substring _fileParts[j+1] 1 3)) then _roi.fileSeq = ("seq_" + _fileParts[j+1])						
				)--for
			)--for
			
			--funcion para ordenar los ouputs por su estado
			fn _compareRenderOutputState roi1 roi2 =
			(
				_result = 0
				
				_stop = false
				for i=1 to roi1.state.count where not _stop do
					if roi1.state[i] < roi2.state[i] then (_stop = true; _result = -1) else if roi1.state[i] > roi2.state[i] then (_stop = true; _result = 1)
				
				_result
			)--fn
			
			--ordena los resultados
			qsort _renderOutputInfo _compareRenderOutputState
			-------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = part
				else if matchPattern part pattern:"cam???" then _camNumber = part
			)--for
			
			-------------------------------------------------------------------------------------------
			--Ahora, con la informacion de los oputputs, ya se puede establecer lo que es erróneo y lo que no
			for i=1 to _renderOutputInfo.count do
			(
				_roi = _renderOutputInfo[i] --elemento actual
				
				if _roi.pathSeq == "" or _roi.pathCam == "" then (_fail = true; log += _roi.path + " -> El path del frame no cumple el naming convention.\n")
				if _roi.fileSeq == "" or _roi.fileCam == "" then (_fail = true; log += _roi.path + " -> El nombre del frame no cumple el naming convention.\n")
				
				if _roi.pathSeq != _roi.fileSeq then (_fail = true; log += _roi.path + " -> El numero de secuencia no coincide entre el path del frame y el frame.\n")
				if _roi.pathCam != _roi.fileCam then (_fail = true; log += _roi.path + " -> El numero de camara no coincide entre el path del frame y el frame.\n")	
				
				if _roi.pathSeq != _seqNumber then (_fail = true; log += _roi.path + " -> El numero de secuencia del path del frame no coincide con el del path de la camara.\n")
				if _roi.pathCam != _camNumber then (_fail = true; log += _roi.path + " -> El numero de camara del path del frame no coincide con el del path de la camara.\n")
				
				if _roi.fileSeq != _seqNumber then (_fail = true; log += _roi.path + " -> El numero de secuencia del nombre del frame no coincide con el del path de la camara.\n")
				if _roi.fileCam != _camNumber then (_fail = true; log += _roi.path + " -> El numero de camara del nombre del frame no coincide con el del path de la camara.\n")
					
			)
			
			if _fail then log += "\n"
			
			-------------------------------------------------------------------------------------------
			--Ahora, con la informacion de los oputputs, ya se puede establecer lo que es erróneo y lo que no
			for i=1 to _renderOutputInfo.count do
			(
				_roi = _renderOutputInfo[i] --elemento actual
				
				--mira caso a caso que se considere un fallo y genera el log correspondiente al mismo
				case (_roi.state as string) of
				(
					"#(0, 0, 0, 0)": (_fail = true; log += _roi.path + " - > ESTE CASO NO SE PUEDE DAR.\n")
					"#(0, 0, 0, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > pero no existe ni viene de ninguna capa de LPM.\n")
					"#(0, 0, 1, 0)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > pero no existe ni viene de ninguna capa de LPM.\n")
					"#(0, 0, 1, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > y además Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > (no debe usarse al mismo tiempo en NUKE y en FUSION).\n")
					
					"#(0, 1, 0, 0)": (_fail = true; log += _roi.path + " - > Procede de la capa de LPM:< " + _roi.lpmPassName + " > del archivo de MAX:< " + (getFileNameFile _roi.maxFile) + ".max > pero no se esta usando en ningún archivo de composicion, ni los frames existen, puede que no se haya hecho el render, se les haya cambiado el nombre o esten obsoletos.\n")
					"#(0, 1, 0, 1)": (_fail = true; log += _roi.path + " - > Procede de la capa de LPM:< " + _roi.lpmPassName + " > del archivo de MAX:< " + (getFileNameFile _roi.maxFile) + ".max > pero los frames no existen, puede que no se haya hecho el render, se les haya cambiado el nombre o esten obsoletos.\n")
					"#(0, 1, 1, 0)": (_fail = true; log += _roi.path + " - > Procede de la capa de LPM:< " + _roi.lpmPassName + " > del archivo de MAX:< " + (getFileNameFile _roi.maxFile) + ".max > pero los frames no existen, puede que no se haya hecho el render, se les haya cambiado el nombre o esten obsoletos.\n")
					"#(0, 1, 1, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > y además Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > (no debe usarse al mismo tiempo en NUKE y en FUSION).\n")
					
					"#(1, 0, 0, 0)": (_fail = true; log += _roi.path + " - > Los frames existen pero no vienen de ninguna capa de LPM ni se usan en composicion. Puede que estén obsoletos o no estén actualizadas las carpetas RENDER y POST.\n")
					"#(1, 0, 0, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > pero los frames existen y no vienen de ninguna capa de LPM. Puede que estén obsoletos o no esté actualizada la carpeta RENDER.\n")
					"#(1, 0, 1, 0)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > pero los frames existen y no vienen de ninguna capa de LPM. Puede que estén obsoletos o no esté actualizada la carpeta RENDER.\n")
					"#(1, 0, 1, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > y además Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > (no debe usarse al mismo tiempo en NUKE y en FUSION).\n")
					
					"#(1, 1, 0, 0)": (_fail = true; log += _roi.path + " - > Los frames existen, proceden de la capa de LPM:< " + _roi.lpmPassName + " > del archivo de MAX:< " + (getFileNameFile _roi.maxFile) + ".max > pero no se estan usando en ningún archivo de composicion.\n")
					"#(1, 1, 1, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > y además Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > (no debe usarse al mismo tiempo en NUKE y en FUSION).\n")
				)--case
			)--for				
			-------------------------------------------------------------------------------------------
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los output de las capas de LPM deben tener sus frames correspondientes renderizados.\n"
				log += "Los frames renderizados deben provenir de una capa de LPM.\n"
				log += "Los frames renderizados deben usarse en al menos un archivo de composicion.\n"
				log += "**************************************************************************************\n\n"
			)--if

		)--executeFN
	)--checkTask_frameUsageCoherence
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que las texturas estan en la carpeta de la secuencia
	struct checkTask_bitmapsInSequenceTexturePath
	(
		id = lb.totalChecker.rollMain.TCH_bitmapsInSequenceTexturePath, --id de la tarea
		name = "Textures: Las texturas de los archivos .max deben apuntar a la carpeta texture de la secuencia.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"render\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = getFiles (_filesPath + ".max")
			
			--obtiene el path de render
			_pathParts = filterString path "\\"
			_texturePath = ""
			_stop = false
			for i=1 to _pathParts.count where not (matchPattern _pathParts[i] pattern:"cam*") do _texturePath += _pathParts[i] + "\\"
			_texturePath = tolower (_texturePath + @"texture\*")
			
			for i=1 to _files.count do
			(
				_bitmaps = getFileInfoBitmaps _files[i] info:maxFilesInfo[i]
								
				for j=1 to _bitmaps.count do --recorre los bitmaps del archivo mirando cuales apuntan a carpetas externas a 
				(
					if not matchPattern (tolower (_bitmaps[j].path)) pattern:_texturePath then
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".max : " + _bitmaps[j].path + " -> No apunta a la carpeta texture de la secuencia.\n"
					)
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Las texturas que use cada .max deben estar en la carpeta texture de la secuencia\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de render de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)				
		)--executeFN
	)--checkTask_bitmapsInSequenceTexturePath
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que las texturas existen
	struct checkTask_bitmapsExist
	(
		id = lb.totalChecker.rollMain.TCH_bitmapsExist, --id de la tarea
		name = "Textures: Las texturas de los archivos .max deben existir.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"render\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = getFiles (_filesPath + ".max")
			
			for i=1 to _files.count do --recorre los .max
			(
				_bitmaps = getFileInfoBitmaps _files[i] info:maxFilesInfo[i]
				
				for j=1 to _bitmaps.count where not doesFileExist _bitmaps[j].path do --recorre los bitmaps del archivo mirando cuales apuntan a carpetas externas a 
				(
					_fail = true
					
					if _bitmaps[j].isBitmapProxy then --si es un proxy
						log += (getFileNameFile _files[i]) + ".max : " + _bitmaps[j].path + " -> No existe, puede que haya que actualizar o no se hayan generado aun los bitmap proxies.\n"
					else --si es un bitmap normal
						log += (getFileNameFile _files[i]) + ".max : " + _bitmaps[j].path + " -> No existe, puede que haya que actualizar.\n"
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Las texturas que use cada .max deben existir.\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de render de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)				
		)--executeFN
	)--checkTask_bitmapsExist
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que todos los nodos de nuke esten activos
	struct checkTask_postNukeFilesNodesActive
	(
		id = lb.totalChecker.rollMain.TCH_postNukeFilesNodesActive, --id de la tarea
		name = "Post: Los nodos de los .nk de nuke deben estar todos activos", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + ".nk")
			
			for i=1 to _files.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_nukeNodesNames = #() --para los nombres de los nodos
				_nukeNodesClass = #() --para la clase de nodo
				_nukeNodesDisabled = #() --para el estado de habilitado o deshabilitado
				
				--estados de busqueda
				_searchState = #node
				--#node --buscando nodos
				--#name --buscando el nombre del nodo
				--#disabled --buscando si el nodo esta activo o no
				
				_f = openfile _files[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#node: --ESTADO DE BUSQUEDA DE NODO
						(
							if matchPattern _l pattern:"* {*" then
							(
								_nodeClass = (filterString _l " 	{")[1]
								append _nukeNodesClass _nodeClass
								_searchState = #name
							)--if
						)--#node
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL NODO
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_name = substituteString _l " name " ""
								append _nukeNodesNames _name --añade el name al array
								_searchState = #disabled
							)
						)--#name
						
						#disabled: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "disable " != undefined then --almacena si esta deshabilitado y pasa al siguiente estado
							(
								_disabled = (filterString _l " 	")[2]
								append _nukeNodesDisabled (_disabled == "true")
								_searchState = #node
							)
							else if matchPattern _l pattern:"*}*" then
							(
								append _nukeNodesDisabled false
								_searchState = #node
							)
						)--#file
					)--case ESTADOS						
				)--while not eof
				
				close _f
				
				for j=1 to _nukeNodesDisabled.count where _nukeNodesDisabled[j] do
				(
					_fail = true
					log += (getFileNameFile _files[i]) + ".nk -> El nodo \"" + _nukeNodesNames[j] + "\" de tipo \"" + _nukeNodesClass[j] + "\" está deshabilitado y no debe haber nodos deshabilitados.\n"
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los nodos de la composicion del archivo nuke deben estar todos activos\n"
				log += "Si hay alguno inactivo puede ser porque ser por error o porque ese nodo no haga falta y debe ser eliminado\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postNukeFilesNodesActive
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que todos los nodos de nuke tengan la salida bien puesta
	struct checkTask_postNukeFilesOutputCorrect
	(
		id = lb.totalChecker.rollMain.TCH_postNukeFilesOutputCorrect, --id de la tarea
		name = "Post: Los output de los .nk de nuke deben apuntar a la carpeta final de la camara", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_*.nk")
			
			for i=1 to _files.count do
			(
				_nukeWriteNodes = #() --nodos write del nuke
				_nukeWriteNodesPaths = #() --paths de los write
				
				--estados de busqueda
				_searchState = #write
				--#write --buscando los writes
				--#name --buscando el nombre del nodo
				--#path --buscando la ruta del nodo
				
				_f = openfile _files[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#write: --ESTADO DE BUSQUEDA DE NODO WRITE
						(
							if matchPattern _l pattern:"*Write {*" then
							(
								_searchState = #path
							)--if
						)--#write
						
						#path: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "file " != undefined then --almacena el path y pasa al siguiente estado
							(
								_path = substituteString _l " file " ""
								append _nukeWriteNodesPaths _path --añade el path al array
								append _nukeWriteNodes "" --añade el name vacio al array
								_searchState = #name
							)
						)--#path
						
						#name: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_name = substituteString _l " name " ""
								_nukeWriteNodes[_nukeWriteNodes.count] = _name --añade el name al array
								_searchState = #write
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
				
				for j=1 to _nukeWriteNodes.count do --recorre los nodos write
				(
					--mira si cumple los patrones de path y nombre de archivo, secuencia y numero de camara
					
					_pathMatchNC = matchPattern (getFileNamePath _nukeWriteNodesPaths[j]) pattern:(lb.nc.NC_seqFramePathPattern + "final\\*")
					_pathMatchSeqAndCam = true
					_pathParts = filterString (getFileNamePath _nukeWriteNodesPaths[j]) "\\/"
					
					for p in _pathParts where _pathMatchSeqAndCam and matchPattern p pattern:"seq_???*" and (substituteString p "seq_" "") != _seqNumber do _pathMatchSeqAndCam = false
					for p in _pathParts where _pathMatchSeqAndCam and matchPattern p pattern:"cam???" and (substituteString p "cam" "") != _camNumber do _pathMatchSeqAndCam = false
					
					_fileNameMatchNC = matchPattern (getFileNameFile _nukeWriteNodesPaths[j] + getFileNameType _nukeWriteNodesPaths[j]) pattern:("seq_???*_cam???_final_####.tif*") --comprueba que cumple el NC de archivo
					_fileNameMatchSeqAndCam = matchPattern (getFileNameFile _nukeWriteNodesPaths[j] + getFileNameType _nukeWriteNodesPaths[j]) pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_final_####.tif*") --comprueba que la secuencia y la camara coinciden
					
					if not _pathMatchNC then --la ruta no cumple el NC de salida
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" : \"" + (getFileNamePath _nukeWriteNodesPaths[j]) + "\" no cumple el path de salida de frames finales.\n"
					)--if
						
					if not _pathMatchSeqAndCam then --la ruta no coincide en numero de secuencia o en camara
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" : \"" + (getFileNamePath _nukeWriteNodesPaths[j]) + "\" no coincide en numero de secuencia y/o camara.\n"
					)--if
					
					if not _fileNameMatchNC then --el archivo no cumple el NC de salida
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" : \"" + (getFileNameFile _nukeWriteNodesPaths[j] + getFileNameType _nukeWriteNodesPaths[j]) + "\" no cumple el nombre de salida de frames finales.\n"
					)--if
					
					if not _fileNameMatchNC then --el archivo no coincide en numero de secuencia o en camara
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" : \"" + (getFileNameFile _nukeWriteNodesPaths[j] + getFileNameType _nukeWriteNodesPaths[j]) + "\" no coincide en numero de secuencia y/o camara.\n"
					)--if						
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los nodos write de la composicion del archivo nuke deben tener el path de output correcto a la carpeta final de la camara.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postNukeFilesOutputCorrect
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que todos los nodos de nuke tengan la salida en formato de compresion LZW
	struct checkTask_postNukeFilesOutputCompression
	(
		id = lb.totalChecker.rollMain.TCH_postNukeFilesOutputCompression, --id de la tarea
		name = "Post: Los output de los .nk de nuke deben estar con compresion LZW", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + ".nk")
			
			for i=1 to _files.count do
			(
				_nukeWriteNodes = #() --nodos write del nuke
				_nukeWriteNodesCompression = #() --paths de los write
				
				--estados de busqueda
				_searchState = #write
				--#write --buscando los writes
				--#compression --buscando la ruta del nodo
				--#name --buscando el nombre del nodo
				
				_f = openfile _files[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#write: --ESTADO DE BUSQUEDA DE NODO WRITE
						(
							if matchPattern _l pattern:"*Write {*" then
							(
								_searchState = #compression
							)--if
						)--#write
						
						#compression: --ESTADO DE BUSQUEDA DEL TIPO DE COMPRESION
						(
							if findString _l "compression " != undefined then --almacena el path y pasa al siguiente estado
							(
								_compr = substituteString _l " compression " ""
								append _nukeWriteNodesCompression _compr --añade el tipo de compresion
								append _nukeWriteNodes "" --añade el name vacio al array
								_searchState = #name
							)
						)--#compression
						
						#name: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_name = substituteString _l " name " ""
								_nukeWriteNodes[_nukeWriteNodes.count] = _name --añade el name al array
								_searchState = #write
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
				
				for j=1 to _nukeWriteNodes.count where _nukeWriteNodesCompression[j] != "LZW" do
				(
					_fail = true
					log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" no tiene compresion LZW activada.\n"
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los nodos write de la composicion del archivo nuke deben tener la compresion en formato LZW\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postNukeFilesOutputCompression
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que todos los nodos de fusion esten activos
	struct checkTask_postFusionFilesNodesActive
	(
		id = lb.totalChecker.rollMain.TCH_postFusionFilesNodesActive, --id de la tarea
		name = "Post: Los nodos de los .comp de fusion deben estar todos activos", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + ".comp")
			
			for i=1 to _files.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_fusionNodesNames = #() --para los nombres de los nodos
				_fusionNodesClass = #() --para la clase de nodo
				_fusionNodesDisabled = #() --para el estado de habilitado o deshabilitado
				_lastState = 0 --ultimo estado
				_bracketCount = 0 --contador de llaves abiertas
				
				--estados de busqueda
				_searchState = #tools
				--#tools --buscando nodos dentro del bloque de tools
				--#node --buscado el siguiente nodo
				--#disabled --buscando si el nodo esta activo o no
				
				_stop = false --flag de parada
				_f = openfile _files[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not _stop and not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#tools: --ESTADO DE BUSQUEDA DE TOOLS
						(
							if matchPattern _l pattern:"*Tools = {*" then
							(
								_bracketCount += 1 --incrementa el numero de brackets
								_searchState = #node
							)
						)--#tools
						
						#node: --ESTADO DE BUSQUEDA DE NODO
						(
							if findString _l "{" != undefined then --incrementa el contador y pasa de estado
							(
								_bracketCount += 1 --incrementa el contador
								_lineParts = filterString _l "	 =" --obtiene el nombre y la case del nodo
								append _fusionNodesNames _lineParts[1]
								append _fusionNodesClass _lineParts[2]
								append _fusionNodesDisabled false
								
								_searchState = #disabled --pasa de estado
							)
							
							if findString _l "}" != undefined then _bracketCount -= 1 --decrementa el contador
							
							if _bracketCount == 0 then _stop = true
						)--#node
						
						#disabled: --ESTADO DE BUSQUEDA DE DISABLED
						(
							if findString _l "{" != undefined then _bracketCount += 1 --incrementa el contador
							if findString _l "PassThrough = true" != undefined then _fusionNodesDisabled[_fusionNodesNames.count] = true
							if findString _l "}" != undefined then _bracketCount -= 1 --decrementa el contador
								
							if _bracketCount == 1 then _searchState = #node
						)--#disabled
					)--case
				)--while
				
				close _f
				
				for j=1 to _fusionNodesDisabled.count where _fusionNodesDisabled[j] do
				(
					_fail = true
					log += (getFileNameFile _files[i]) + ".comp -> El nodo \"" + _fusionNodesNames[j] + "\" de tipo \"" + _fusionNodesClass[j] + "\" está deshabilitado y no debe haber nodos deshabilitados.\n"
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los nodos de la composicion del archivo fusion deben estar todos activos\n"
				log += "Si hay alguno inactivo puede ser porque ser por error o porque ese nodo no haga falta y debe ser eliminado\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postFusionFilesNodesActive
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que todos los nodos de fusion tengan la salida bien puesta
	struct checkTask_postFusionFilesOutputCorrect
	(
		id = lb.totalChecker.rollMain.TCH_postFusionFilesOutputCorrect, --id de la tarea
		name = "Post: Los output de los .comp de fusion deben apuntar a la carpeta final de la camara", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*post*")
			_files = getFiles (_filesPath + ".comp")
			
			
			for i=1 to _files.count do
			(
				_fusionSaverNodes = #() --nodos save del nuke
				_fusionSaverNodesPaths = #() --paths de los save
				
				--estados de busqueda
				_searchState = #saver
				--#saver --buscando nodos saver
				--#filename --buscando el path de salida
									
				_f = openfile _files[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#saver: --ESTADO DE BUSQUEDA DE NODO SAVER
						(
							if matchPattern _l pattern:"*= Saver {*" then
							(
								append _fusionSaverNodes (filterString _l "	 =")[1] --añade el nombre del nodo saver al array
								append _fusionSaverNodesPaths "" --añade un path vacio
								_searchState = #filename
							)--if
						)--#saver
						
						#filename: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "Filename =" != undefined then --almacena el path y pasa al siguiente estado
							(
								_path = (filterString (substituteString _l "Filename =" "") "	 \",")[1] --obtiene el path
								_fusionSaverNodesPaths[_fusionSaverNodesPaths.count] = (substituteString _path "\\\\" "\\")
								
								_searchState = #saver
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
				
				
				for j=1 to _fusionSaverNodes.count do --recorre los nodos write
				(
					print _fusionSaverNodesPaths[j]
					--mira si cumple los patrones de path y nombre de archivo, secuencia y numero de camara
					
					_pathMatchNC = matchPattern (getFileNamePath _fusionSaverNodesPaths[j]) pattern:(lb.nc.NC_seqFramePathPattern + "final\\*")
					_pathMatchSeqAndCam = true
					_pathParts = filterString (getFileNamePath _fusionSaverNodesPaths[j]) "\\/"
					
					for p in _pathParts where _pathMatchSeqAndCam and matchPattern p pattern:"seq_???*" and (substituteString p "seq_" "") != _seqNumber do _pathMatchSeqAndCam = false
					for p in _pathParts where _pathMatchSeqAndCam and matchPattern p pattern:"cam???" and (substituteString p "cam" "") != _camNumber do _pathMatchSeqAndCam = false
					
					_fileNameMatchNC = matchPattern (getFileNameFile _fusionSaverNodesPaths[j] + getFileNameType _fusionSaverNodesPaths[j]) pattern:("seq_???*_cam???_final_.tif*") --comprueba que cumple el NC de archivo
					_fileNameMatchSeqAndCam = matchPattern (getFileNameFile _fusionSaverNodesPaths[j] + getFileNameType _fusionSaverNodesPaths[j]) pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_final_.tif*") --comprueba que la secuencia y la camara coinciden
					
					
					if not _pathMatchNC then --la ruta no cumple el NC de salida
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".comp -> El nodo write \"" + _fusionSaverNodes[j] + "\" : \"" + (getFileNamePath _fusionSaverNodesPaths[j]) + "\" no cumple el path de salida de frames finales.\n"
					)--if
						
					if not _pathMatchSeqAndCam then --la ruta no coincide en numero de secuencia o en camara
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".comp -> El nodo write \"" + _fusionSaverNodes[j] + "\" : \"" + (getFileNamePath _fusionSaverNodesPaths[j]) + "\" no coincide en numero de secuencia y/o camara.\n"
					)--if
					
					if not _fileNameMatchNC then --el archivo no cumple el NC de salida
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".comp -> El nodo write \"" + _fusionSaverNodes[j] + "\" : \"" + (getFileNameFile _fusionSaverNodesPaths[j] + getFileNameType _fusionSaverNodesPaths[j]) + "\" no cumple el nombre de salida de frames finales.\n"
					)--if
					
					if not _fileNameMatchNC then --el archivo no coincide en numero de secuencia o en camara
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".comp -> El nodo write \"" + _fusionSaverNodes[j] + "\" : \"" + (getFileNameFile _fusionSaverNodesPaths[j] + getFileNameType _fusionSaverNodesPaths[j]) + "\" no coincide en numero de secuencia y/o camara.\n"
					)--if						
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los nodos saver de la composicion del archivo fusion deben tener el path de output correcto a la carpeta final de la camara\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postFusionFilesOutputCorrect
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que todos los nodos de fusion tengan la salida bien puesta para compos de fx
	struct checkTask_postFxFusionFilesOutputCorrect
	(
		id = lb.totalChecker.rollMain.TCH_postFxFusionFilesOutputCorrect, --id de la tarea
		name = "Post: Los output de los .comp de fusion de fx deben apuntar a la carpeta final de la camara", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*postFx*")
			_files = getFiles (_filesPath + ".comp")
			
			for i=1 to _files.count do
			(
				_fusionSaverNodes = #() --nodos save del nuke
				_fusionSaverNodesPaths = #() --paths de los save
				
				--estados de busqueda
				_searchState = #saver
				--#saver --buscando nodos saver
				--#filename --buscando el path de salida
									
				_f = openfile _files[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#saver: --ESTADO DE BUSQUEDA DE NODO SAVER
						(
							if matchPattern _l pattern:"*= Saver {*" then
							(
								append _fusionSaverNodes (filterString _l "	 =")[1] --añade el nombre del nodo saver al array
								append _fusionSaverNodesPaths "" --añade un path vacio
								_searchState = #filename
							)--if
						)--#saver
						
						#filename: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "Filename =" != undefined then --almacena el path y pasa al siguiente estado
							(
								_path = (filterString (substituteString _l "Filename =" "") "	 \",")[1] --obtiene el path
								_fusionSaverNodesPaths[_fusionSaverNodesPaths.count] = (substituteString _path "\\\\" "\\")
								
								_searchState = #saver
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
				
				for j=1 to _fusionSaverNodes.count do --recorre los nodos write
				(
					--mira si cumple los patrones de path y nombre de archivo, secuencia y numero de camara
					
					_pathMatchNC = matchPattern (getFileNamePath _fusionSaverNodesPaths[j]) pattern:(lb.nc.NC_seqFramePathPattern + "final\\*")
					_pathMatchSeqAndCam = true
					_pathParts = filterString (getFileNamePath _fusionSaverNodesPaths[j]) "\\/"
					
					for p in _pathParts where _pathMatchSeqAndCam and matchPattern p pattern:"seq_???*" and (substituteString p "seq_" "") != _seqNumber do _pathMatchSeqAndCam = false
					for p in _pathParts where _pathMatchSeqAndCam and matchPattern p pattern:"cam???" and (substituteString p "cam" "") != _camNumber do _pathMatchSeqAndCam = false
					
					_fileNameMatchNC = matchPattern (getFileNameFile _fusionSaverNodesPaths[j] + getFileNameType _fusionSaverNodesPaths[j]) pattern:("seq_???*_cam???_final_.tif*") --comprueba que cumple el NC de archivo
					_fileNameMatchSeqAndCam = matchPattern (getFileNameFile _fusionSaverNodesPaths[j] + getFileNameType _fusionSaverNodesPaths[j]) pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_final_.tif*") --comprueba que la secuencia y la camara coinciden
					
					if not _pathMatchNC then --la ruta no cumple el NC de salida
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".comp -> El nodo write \"" + _fusionSaverNodes[j] + "\" : \"" + (getFileNamePath _fusionSaverNodesPaths[j]) + "\" no cumple el path de salida de frames finales.\n"
					)--if
						
					if not _pathMatchSeqAndCam then --la ruta no coincide en numero de secuencia o en camara
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".comp -> El nodo write \"" + _fusionSaverNodes[j] + "\" : \"" + (getFileNamePath _fusionSaverNodesPaths[j]) + "\" no coincide en numero de secuencia y/o camara.\n"
					)--if
					
					if not _fileNameMatchNC then --el archivo no cumple el NC de salida
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".comp -> El nodo write \"" + _fusionSaverNodes[j] + "\" : \"" + (getFileNameFile _fusionSaverNodesPaths[j] + getFileNameType _fusionSaverNodesPaths[j]) + "\" no cumple el nombre de salida de frames finales.\n"
					)--if
					
					if not _fileNameMatchNC then --el archivo no coincide en numero de secuencia o en camara
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".comp -> El nodo write \"" + _fusionSaverNodes[j] + "\" : \"" + (getFileNameFile _fusionSaverNodesPaths[j] + getFileNameType _fusionSaverNodesPaths[j]) + "\" no coincide en numero de secuencia y/o camara.\n"
					)--if						
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los nodos saver de la composicion del archivo fusion de fx, deben tener el path de output correcto a la carpeta final de la camara\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postFxFusionFilesOutputCorrect
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que todos los nodos de nuke tengan la salida bien puesta
	struct checkTask_postFxNukeFilesOutputCorrect
	(
		id = lb.totalChecker.rollMain.TCH_postFxNukeFilesOutputCorrect, --id de la tarea
		name = "Post: Los output de los .nk de nuke para fx deben apuntar a la carpeta final de la camara", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_postFx_*.nk")
			
			for i=1 to _files.count do
			(
				_nukeWriteNodes = #() --nodos write del nuke
				_nukeWriteNodesPaths = #() --paths de los write
				
				--estados de busqueda
				_searchState = #write
				--#write --buscando los writes
				--#name --buscando el nombre del nodo
				--#path --buscando la ruta del nodo
				
				_f = openfile _files[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#write: --ESTADO DE BUSQUEDA DE NODO WRITE
						(
							if matchPattern _l pattern:"*Write {*" then
							(
								_searchState = #path
							)--if
						)--#write
						
						#path: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "file " != undefined then --almacena el path y pasa al siguiente estado
							(
								_path = substituteString _l " file " ""
								append _nukeWriteNodesPaths _path --añade el path al array
								append _nukeWriteNodes "" --añade el name vacio al array
								_searchState = #name
							)
						)--#path
						
						#name: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_name = substituteString _l " name " ""
								_nukeWriteNodes[_nukeWriteNodes.count] = _name --añade el name al array
								_searchState = #write
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
				
				for j=1 to _nukeWriteNodes.count do --recorre los nodos write
				(
					--mira si cumple los patrones de path y nombre de archivo, secuencia y numero de camara
					
					_pathMatchNC = matchPattern (getFileNamePath _nukeWriteNodesPaths[j]) pattern:(lb.nc.NC_seqFramePathPattern + "final\\*")
					_pathMatchSeqAndCam = true
					_pathParts = filterString (getFileNamePath _nukeWriteNodesPaths[j]) "\\/"
					
					for p in _pathParts where _pathMatchSeqAndCam and matchPattern p pattern:"seq_???*" and (substituteString p "seq_" "") != _seqNumber do _pathMatchSeqAndCam = false
					for p in _pathParts where _pathMatchSeqAndCam and matchPattern p pattern:"cam???" and (substituteString p "cam" "") != _camNumber do _pathMatchSeqAndCam = false
					
					_fileNameMatchNC = matchPattern (getFileNameFile _nukeWriteNodesPaths[j] + getFileNameType _nukeWriteNodesPaths[j]) pattern:("seq_???*_cam???_final_####.tif*") --comprueba que cumple el NC de archivo
					_fileNameMatchSeqAndCam = matchPattern (getFileNameFile _nukeWriteNodesPaths[j] + getFileNameType _nukeWriteNodesPaths[j]) pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_final_####.tif*") --comprueba que la secuencia y la camara coinciden
					
					if not _pathMatchNC then --la ruta no cumple el NC de salida
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" : \"" + (getFileNamePath _nukeWriteNodesPaths[j]) + "\" no cumple el path de salida de frames finales.\n"
					)--if
						
					if not _pathMatchSeqAndCam then --la ruta no coincide en numero de secuencia o en camara
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" : \"" + (getFileNamePath _nukeWriteNodesPaths[j]) + "\" no coincide en numero de secuencia y/o camara.\n"
					)--if
					
					if not _fileNameMatchNC then --el archivo no cumple el NC de salida
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" : \"" + (getFileNameFile _nukeWriteNodesPaths[j] + getFileNameType _nukeWriteNodesPaths[j]) + "\" no cumple el nombre de salida de frames finales.\n"
					)--if
					
					if not _fileNameMatchNC then --el archivo no coincide en numero de secuencia o en camara
					(
						_fail = true
						log += (getFileNameFile _files[i]) + ".nk -> El nodo write \"" + _nukeWriteNodes[j] + "\" : \"" + (getFileNameFile _nukeWriteNodesPaths[j] + getFileNameType _nukeWriteNodesPaths[j]) + "\" no coincide en numero de secuencia y/o camara.\n"
					)--if						
				)--for
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los nodos write de la composicion del archivo nuke para fx deben tener el path de output correcto a la carpeta final de la camara.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postFxNukeFilesOutputCorrect
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Post: Los nukes y fusions v01 tienen cargados frames existentes y leen de la carpeta camYYY
	struct checkTask_postNodesFilesExist
	(
		id = lb.totalChecker.rollMain.TCH_postNodesFilesExist, --id de la tarea
		name = "Post: Los nukes y fusions v01 tienen cargados frames existentes y leen de la carpeta camYYY", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_v01.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					if matchPattern (tolower (getFilenamePath _postNukeIpts[i][j])) pattern:"\\\\lbdata002\\z\\frame\\seq_???*\\cam\\cam???\\" then
					(
						--Saco los frames para cada input y miro si cumplen el naming convention
						_frames = (getFiles (substituteString _postNukeIpts[i][j] "#" "?"))
						if _frames.count == 0 then
						(
							_fail = true
							if _firstError then
							(
								_firstError = false
								log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
							)
							
							log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames <" + _postNukeIpts[i][j] + "> que no están renderizados en " + (getFilenamePath _postNukeIpts[i][j])  + "\n"
						)
					)
					else
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene una ruta no válida: " + (getFilenamePath _postNukeIpts[i][j])  + "\n"
						
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para indicar si hemos fallado por primera vez para ese archivo
			_firstError = true
			
			--Recorro los inputs de cada archivo de fusion en busca de frames que no apunten a la carpeta cam o que simplemente no existan.
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					--Si no cumplen la ruta de la cámara
					if matchPattern (tolower (getFilenamePath _postFusionIpts[i][j])) pattern:"\\\\lbdata002\\z\\frame\\seq_???*\\cam\\cam???\\" then
					(
						_frames = (getFiles (substituteString _postFusionIpts[i][j] "#" "?"))
						if _frames.count == 0 then
						(
							if _firstError then
							(
								_firstError = false
								log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
							)
							
							log += "-> El nodo de fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames <" + _postFusionIpts[i][j] + "> que no están renderizados en " + (getFilenamePath _postFusionIpts[i][j])  + "\n"
							
						)
					)
					else
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene una ruta no válida: " + (getFilenamePath _postFusionIpts[i][j])  + "\n"
						
						
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de iluminación (que tienen v01 en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen que estar apuntado a una ruta de lbdata002 similar a la del ejemplo:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\\n\n"
				log += "Además tiene que existir al menos un frame por nodo para que este check se pase correctamente.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postNodesFilesExist
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Post: Los nukes y fusions v02 tienen cargados frames existentes y leen de la carpeta camYYY
	struct checkTask_compoNodesFilesExist
	(
		id = lb.totalChecker.rollMain.TCH_compoNodesFilesExist, --id de la tarea
		name = "Post: Los nukes y fusions v02 tienen cargados frames existentes y leen de la carpeta camYYY", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_v02.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					if matchPattern (tolower (getFilenamePath _postNukeIpts[i][j])) pattern:"\\\\lbdata002\\z\\frame\\seq_???*\\cam\\cam???\\" then
					(
						--Saco los frames para cada input y miro si cumplen el naming convention
						_frames = (getFiles (substituteString _postNukeIpts[i][j] "#" "?"))
						
						if _frames.count == 0 then
						(
							_fail = true
							if _firstError then
							(
								_firstError = false
								log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
							)
							
							log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> con ruta  " + (_postNukeIpts[i][j])  + " tiene cargados frames que no están renderizados.\n"
							
							l
						)
					)
					else
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene una ruta no válida: " + (getFilenamePath _postNukeIpts[i][j])  + "\n"
						
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para indicar si hemos fallado por primera vez para ese archivo
			_firstError = true
			
			--Recorro los inputs de cada archivo de fusion en busca de frames que no apunten a la carpeta cam o que simplemente no existan.
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					--Si no cumplen la ruta de la cámara
					if matchPattern (tolower (getFilenamePath _postFusionIpts[i][j])) pattern:"\\\\lbdata002\\z\\frame\\seq_???*\\cam\\cam???\\" then
					(
						_frames = (getFiles (substituteString _postFusionIpts[i][j] "#" "?"))
						if _frames.count == 0 then
						(
							if _firstError then
							(
								_firstError = false
								log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
							)
							
							log += "-> El nodo de fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> con ruta " + (_postFusionIpts[i][j])  + " tiene cargados frames que no están renderizados.\n"
							
							
						)
					)
					else
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene una ruta no válida: " + (getFilenamePath _postFusionIpts[i][j])  + "\n"
						
						
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de composición (que tienen v02 en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen que estar apuntado a una ruta de lbdata002 similar a la del ejemplo:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\\n\n"
				log += "Además tiene que existir al menos un frame por nodo para que este check se pase correctamente.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_compoNodesFilesExist
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--PostFx: Los nukes y fusions tienen cargados frames existentes y leen de la carpeta camYYY
	struct checkTask_postFxNodesFilesExist
	(
		id = lb.totalChecker.rollMain.TCH_postFxNodesFilesExist, --id de la tarea
		name = "PostFx: Los nukes y fusions tienen cargados frames existentes y leen de la carpeta camYYY", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_postFx.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					if matchPattern (tolower (getFilenamePath _postNukeIpts[i][j])) pattern:"\\\\lbdata002\\z\\frame\\seq_???*\\cam\\cam???\\" then
					(
						--Saco los frames para cada input y miro si cumplen el naming convention
						_frames = (getFiles (substituteString _postNukeIpts[i][j] "#" "?"))
						
						if _frames.count == 0 then
						(
							_fail = true
							if _firstError then
							(
								_firstError = false
								log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
							)
							
							log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames que no están renderizados en " + (getFilenamePath _postNukeIpts[i][j])  + "\n"
							
						)
					)
					else
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene una ruta no válida: " + (getFilenamePath _postNukeIpts[i][j])  + "\n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para indicar si hemos fallado por primera vez para ese archivo
			_firstError = true
			
			--Recorro los inputs de cada archivo de fusion en busca de frames que no apunten a la carpeta cam o que simplemente no existan.
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					--Si no cumplen la ruta de la cámara
					if matchPattern (tolower (getFilenamePath _postFusionIpts[i][j])) pattern:"\\\\lbdata002\\z\\frame\\seq_???*\\cam\\cam???\\" then
					(
						_frames = (getFiles (substituteString _postFusionIpts[i][j] "#" "?"))
						if _frames.count == 0 then
						(
							_fail = true
							if _firstError then
							(
								_firstError = false
								log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
							)
							
							log += "-> El nodo de fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames que no están renderizados en " + (getFilenamePath _postFusionIpts[i][j])  + "\n"
						)
					)
					else
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene una ruta no válida: " + (getFilenamePath _postFusionIpts[i][j])  + "\n"
						
						
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de fx (que tienen postFx en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen que estar apuntado a una ruta de lbdata002 similar a la del ejemplo:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\\n\n"
				log += "Además tiene que existir al menos un frame por nodo para que este check se pase correctamente.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postFxNodesFilesExist
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Post: Los nukes y fusion v01 tienen cargados frames que cumplen el naming convention
	struct checkTask_postNodesNCOk
	(
		id = lb.totalChecker.rollMain.TCH_postNodesNCOk, --id de la tarea
		name = "Post: Los nukes y fusion v01 tienen cargados frames que cumplen el naming convention", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_v01.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					if (filterString (filenameFromPath _postNukeIpts[i][j]) "_").count != 6 or (not (matchPattern (tolower (filenameFromPath _postNukeIpts[i][j])) pattern:lb.nc.NC_seqFrameNamePattern) and not (matchPattern (tolower (filenameFromPath _postNukeIpts[i][j])) pattern:lb.nc.NC_seqFrameNameNewPattern)) then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames que no cumplen el naming convention: " + _postNukeIpts[i][j] + " \n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames cumplen el naming convention
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					if (filterString (filenameFromPath _postFusionIpts[i][j]) "_").count != 6 or (not (matchPattern (tolower (filenameFromPath _postFusionIpts[i][j])) pattern:lb.nc.NC_seqFrameNamePattern) and not (matchPattern (tolower (filenameFromPath _postFusionIpts[i][j])) pattern:lb.nc.NC_seqFrameNameNewPattern)) then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames que no cumplen el naming convention: " + _postFusionIpts[i][j] + " \n"
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de iluminación (que tienen v01 en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen tener añadidos frames que cumplan el naming convention nuevo o viejo:\n"
				log += "ANTIGUO (este no se puede usar ya pero esta soportado):seq_???*_cam???_render_*(*)_????.*\n"
				log += "NUEVO: seq_???*_cam???_render_*(*-*-*)_????.*\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postNodesNCOk
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Post: Los nukes y fusion v02 tienen cargados frames que cumplen el naming convention
	struct checkTask_compoNodesNCOk
	(
		id = lb.totalChecker.rollMain.TCH_compoNodesNCOk, --id de la tarea
		name = "Post: Los nukes y fusion v02 tienen cargados frames que cumplen el naming convention", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_v02.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					
					if (filterString (filenameFromPath _postNukeIpts[i][j]) "_").count != 6 \
					or (not (matchPattern (tolower (filenameFromPath _postNukeIpts[i][j])) pattern:lb.nc.NC_seqFrameNamePattern) \
					and not (matchPattern (tolower (filenameFromPath _postNukeIpts[i][j])) pattern:lb.nc.NC_seqFrameNameNewPattern) \
					and not (matchPattern (tolower (filenameFromPath _postNukeIpts[i][j])) pattern:lb.nc.NC_seqFrameFxNamePattern) \
					and not (matchPattern (tolower (filenameFromPath _postNukeIpts[i][j])) pattern:lb.nc.NC_seqFrameFxNameNewPattern)) then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames que no cumplen el naming convention: " + _postNukeIpts[i][j] + " \n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames cumplen el naming convention
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					if (filterString (filenameFromPath _postFusionIpts[i][j]) "_").count != 6 \
					or (not (matchPattern (tolower (filenameFromPath _postFusionIpts[i][j])) pattern:lb.nc.NC_seqFrameNamePattern) \
					and not (matchPattern (tolower (filenameFromPath _postFusionIpts[i][j])) pattern:lb.nc.NC_seqFrameNameNewPattern) \
					and not (matchPattern (tolower (filenameFromPath _postFusionIpts[i][j])) pattern:lb.nc.NC_seqFrameFxNamePattern) \
					and not (matchPattern (tolower (filenameFromPath _postFusionIpts[i][j])) pattern:lb.nc.NC_seqFrameFxNameNewPattern)) then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames que no cumplen el naming convention: " + _postFusionIpts[i][j] + " \n"
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de composición (que tienen v02 en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen tener añadidos frames que cumplan el naming convention nuevo o viejo:\n"
				log += "ANTIGUO (este no se puede usar ya pero esta soportado):seq_???*_cam???_render_*(*)_????.* ó seq_???*_cam???_renderFx_*(*)_????.*\n"
				log += "NUEVO: seq_???*_cam???_render_*(*-*-*)_????.* ó seq_???*_cam???_renderFx_*(*-*-*)_????.*\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_compoNodesNCOk
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--PostFx: Los nukes y fusion tienen cargados frames que cumplen el naming convention
	struct checkTask_postFxNodesNCOk
	(
		id = lb.totalChecker.rollMain.TCH_postFxNodesNCOk, --id de la tarea
		name = "PostFx: Los nukes y fusion tienen cargados frames que cumplen el naming convention", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_postFx.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					if (filterString (filenameFromPath _postNukeIpts[i][j]) "_").count != 6 or (not (matchPattern (tolower (filenameFromPath _postNukeIpts[i][j])) pattern:lb.nc.NC_seqFrameFxNamePattern) and not (matchPattern (tolower (filenameFromPath _postNukeIpts[i][j])) pattern:lb.nc.NC_seqFrameFxNameNewPattern)) then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames que no cumplen el naming convention: " + _postNukeIpts[i][j] + " \n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames cumplen el naming convention
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					if (filterString (filenameFromPath _postFusionIpts[i][j]) "_").count != 6 or (not (matchPattern (tolower (filenameFromPath _postFusionIpts[i][j])) pattern:lb.nc.NC_seqFrameFxNamePattern) and not (matchPattern (tolower (filenameFromPath _postFusionIpts[i][j])) pattern:lb.nc.NC_seqFrameFxNameNewPattern)) then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "\n*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames que no cumplen el naming convention: " + _postFusionIpts[i][j] + " \n"
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de fx (que tienen postFx en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen tener añadidos frames que cumplan el naming convention nuevo o viejo:\n"
				log += "ANTIGUO (este no se puede usar ya pero esta soportado):seq_???*_cam???_renderFx_*(*)_????.*\n"
				log += "NUEVO: seq_???*_cam???_renderFx_*(*-*-*)_????.*\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postFxNodesNCOk
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--Post: Los nukes y fusions v01 tienen cargados frames de la secuencia y cámara correctos
	struct checkTask_postNodesCamAndSeqOk
	(
		id = lb.totalChecker.rollMain.TCH_postNodesCamAndSeqOk, --id de la tarea
		name = "Post: Los nukes y fusions v01 tienen cargados frames de la secuencia y cámara correctos", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_postNodesNCOk), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_v01.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					
					if findString  (getFilenamePath _postNukeIpts[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _postNukeIpts[i][j]) ("cam"+_camNumber) == undefined then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames cuyo path apunta a otra secuencia y/o cámara: " + (getFilenamePath _postNukeIpts[i][j]) + " \n"
					)
					if (filterString (filenameFromPath _postNukeIpts[i][j]) "_")[2] != _seqNumber or (substituteString (filterString (filenameFromPath _postNukeIpts[i][j]) "_")[3] "cam" "") != _camNumber then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames tienen mal el numero de secuencia y/o cámara: " + (filenameFromPath _postNukeIpts[i][j]) + " \n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					
					if findString  (getFilenamePath _postFusionIpts[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _postFusionIpts[i][j]) ("cam"+_camNumber) == undefined then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames cuyo path apunta a otra secuencia y/o cámara: " + (getFilenamePath _postFusionIpts[i][j]) + " \n"
					)
					if (filterString (filenameFromPath _postFusionIpts[i][j]) "_")[2] != _seqNumber or (substituteString (filterString (filenameFromPath _postFusionIpts[i][j]) "_")[3] "cam" "") != _camNumber then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames tienen mal el numero de secuencia y/o cámara: " + (filenameFromPath _postFusionIpts[i][j]) + " \n"
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de iluminación (que tienen v01 en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen tener añadidos frames que estén en la ruta de la secuencia y cámara\n"
				log += "sobre la que estemos trabajando. Si apuntan en la ruta o el nombre del frame a otra secuencia y/o cámara saltará.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postNodesCamAndSeqOk
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Post: Los nukes y fusions v02 tienen cargados frames de la secuencia y cámara correctos
	struct checkTask_compoNodesCamAndSeqOk
	(
		id = lb.totalChecker.rollMain.TCH_compoNodesCamAndSeqOk, --id de la tarea
		name = "Post: Los nukes y fusions v02 tienen cargados frames de la secuencia y cámara correctos", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_compoNodesNCOk), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_v02.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					
					if findString  (getFilenamePath _postNukeIpts[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _postNukeIpts[i][j]) ("cam"+_camNumber) == undefined then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames cuyo path apunta a otra secuencia y/o cámara: " + (getFilenamePath _postNukeIpts[i][j]) + " \n"
					)
					if (filterString (filenameFromPath _postNukeIpts[i][j]) "_")[2] != _seqNumber or (substituteString (filterString (filenameFromPath _postNukeIpts[i][j]) "_")[3] "cam" "") != _camNumber then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames tienen mal el numero de secuencia y/o cámara: " + (filenameFromPath _postNukeIpts[i][j]) + " \n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					
					if findString  (getFilenamePath _postFusionIpts[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _postFusionIpts[i][j]) ("cam"+_camNumber) == undefined then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames cuyo path apunta a otra secuencia y/o cámara: " + (getFilenamePath _postFusionIpts[i][j]) + " \n"
					)
					if (filterString (filenameFromPath _postFusionIpts[i][j]) "_")[2] != _seqNumber or (substituteString (filterString (filenameFromPath _postFusionIpts[i][j]) "_")[3] "cam" "") != _camNumber then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames tienen mal el numero de secuencia y/o cámara: " + (filenameFromPath _postFusionIpts[i][j]) + " \n"
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de composición (que tienen v02 en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen tener añadidos frames que estén en la ruta de la secuencia y cámara\n"
				log += "sobre la que estemos trabajando. Si apuntan en la ruta o el nombre del frame a otra secuencia y/o cámara saltará.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_compoNodesCamAndSeqOk
	-----------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------------------
	--Post: Los nukes y fusions v01 tienen cargados frames de la secuencia y cámara correctos
	struct checkTask_postFxNodesCamAndSeqOk
	(
		id = lb.totalChecker.rollMain.TCH_postFxNodesCamAndSeqOk, --id de la tarea
		name = "PostFx: Los nukes y fusions tienen cargados frames de la secuencia y cámara correctos", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_postFxNodesNCOk), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_postFx.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					
					if findString  (getFilenamePath _postNukeIpts[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _postNukeIpts[i][j]) ("cam"+_camNumber) == undefined then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames cuyo path apunta a otra secuencia y/o cámara: " + (getFilenamePath _postNukeIpts[i][j]) + " \n"
					)
					if (filterString (filenameFromPath _postNukeIpts[i][j]) "_")[2] != _seqNumber or (substituteString (filterString (filenameFromPath _postNukeIpts[i][j]) "_")[3] "cam" "") != _camNumber then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames tienen mal el numero de secuencia y/o cámara: " + (filenameFromPath _postNukeIpts[i][j]) + " \n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					
					if findString  (getFilenamePath _postFusionIpts[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _postFusionIpts[i][j]) ("cam"+_camNumber) == undefined then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "\n*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames cuyo path apunta a otra secuencia y/o cámara: " + (getFilenamePath _postFusionIpts[i][j]) + " \n"
					)
					if (filterString (filenameFromPath _postFusionIpts[i][j]) "_")[2] != _seqNumber or (substituteString (filterString (filenameFromPath _postFusionIpts[i][j]) "_")[3] "cam" "") != _camNumber then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "\n*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames tienen mal el numero de secuencia y/o cámara: " + (filenameFromPath _postFusionIpts[i][j]) + " \n"
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de fx (que tienen postFx en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen tener añadidos frames que estén en la ruta de la secuencia y cámara\n"
				log += "sobre la que estemos trabajando. Si apuntan en la ruta o el nombre del frame a otra secuencia y/o cámara saltará.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postFxNodesCamAndSeqOk
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Post: Los nukes y fusions v01 no tienen frames de fx cargados
	struct checkTask_postNodesNoFx
	(
		id = lb.totalChecker.rollMain.TCH_postNodesNoFx, --id de la tarea
		name = "Post: Los nukes y fusions v01 no tienen frames de fx cargados", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_v01.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
								
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					if (matchPattern (getFilenameFile _postNukeIpts[i][j]) pattern: "*_renderFx_*") then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames de fx: " + (filenameFromPath _postNukeIpts[i][j]) + " \n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					if (matchPattern (getFilenameFile _postFusionIpts[i][j]) pattern: "*_renderFx_*") then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames de fx: " + (filenameFromPath _postFusionIpts[i][j]) + " \n"
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de iluminación (que tienen v01 en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen tener añadidos frames que estén en la ruta de la secuencia y cámara\n"
				log += "sobre la que estemos trabajando. Si apuntan en la ruta o el nombre del frame a otra secuencia y/o cámara saltará.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postNodesNoFx
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Post: Los nukes y fusions v01 no tienen frames de fx cargados
	struct checkTask_postFxNodesNoRender
	(
		id = lb.totalChecker.rollMain.TCH_postFxNodesNoRender, --id de la tarea
		name = "PostFx: Los nukes y fusions no tienen frames de render cargados.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_postFx.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			_postNukeIptsNames = #()
			_postNukeIpts = #()
			
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								
								_path = substituteString _path "Ã±" "ñ"
								
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postNukeIpts.count do
			(
				for j=1 to _postNukeIpts[i].count do
				(
					if (matchPattern (getFilenameFile _postNukeIpts[i][j]) pattern: "*_render_*") then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + filenameFromPath _postNukeIptsNames[i][j] + "> tiene cargados frames de render: " + (filenameFromPath _postNukeIpts[i][j]) + " \n"
					)
				)
			)
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			_postFusionIptsNames = #()
			_postFusionIpts = #()
			
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			--Me creo un flag para ver si ha fallado por primera vez en el archivo y poner el titulo en el log
			_firstError = true
			--Recorro los inputs de cada archivo de nuke para ver si sus frames existen y apuntan a la carpeta correcta.
			for i=1 to _postFusionIpts.count do
			(
				for j=1 to _postFusionIpts[i].count do
				(
					if (matchPattern (getFilenameFile _postFusionIpts[i][j]) pattern: "*_render_*") then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "\n*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de Fusion <" + filenameFromPath _postFusionIptsNames[i][j] + "> tiene cargados frames de render: " + (filenameFromPath _postFusionIpts[i][j]) + " \n"
					)
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de iluminación (que tienen v01 en el nombre)\n"
				log += "Los nodos de estos archivos de fusion o nuke tienen tener añadidos frames que estén en la ruta de la secuencia y cámara\n"
				log += "sobre la que estemos trabajando. Si apuntan en la ruta o el nombre del frame a otra secuencia y/o cámara saltará.\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postFxNodesNoRender
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Post: El nodo write de nukes y fusions v01 apunta a camYYY/final y su patron de frames es correcto
	struct checkTask_postWriteNodeOk
	(
		id = lb.totalChecker.rollMain.TCH_postWriteNodeOk, --id de la tarea
		name = "Post: El nodo write de nukes y fusions v01 apunta a camYYY/final y su patron de frames es correcto", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			--obtiene los archivos
			_filesPath = (path + @"post\*")
			_files = getFiles (_filesPath + "*_post_v01.*")
			
			_postNukeFiles = #()
			_postFusionFiles = #()
			
			for i=1 to _files.count do
			(
				if getFilenameType _files[i] == ".nk" then
					append _postNukeFiles _files[i]
				else if getFilenameType _files[i] == ".comp" then
					append _postFusionFiles _files[i]
			)
			
			_nukeFilesOutputs = #()
			_nukeFilesOutputsNames = #()
			-------------------------------------------------------------------------------
			--NUKE
			for i=1 to _postNukeFiles.count do
			(
				_nukeWriteNodes = #() --nodos write del nuke
				_nukeWriteNodesPaths = #() --paths de los write
				
				--estados de busqueda
				_searchState = #write
				--#write --buscando los writes
				--#name --buscando el nombre del nodo
				--#path --buscando la ruta del nodo
				
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#write: --ESTADO DE BUSQUEDA DE NODO WRITE
						(
							if matchPattern _l pattern:"*Write {*" then
							(
								_searchState = #path
							)--if
						)--#write
						
						#path: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "file " != undefined then --almacena el path y pasa al siguiente estado
							(
								_path = substituteString _l " file " ""
								append _nukeWriteNodesPaths _path --añade el path al array
								append _nukeWriteNodes "" --añade el name vacio al array
								_searchState = #name
							)
						)--#path
						
						#name: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_name = substituteString _l " name " ""
								_nukeWriteNodes[_nukeWriteNodes.count] = _name --añade el name al array
								_searchState = #write
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
				
				append _nukeFilesOutputs _nukeWriteNodesPaths
				append _nukeFilesOutputsNames _nukeWriteNodes
			)
			
			_firstError = true
			for i=1 to _nukeFilesOutputs.count do
			(
				for j=1 to _nukeFilesOutputs[i].count do
				(
					--Los nodos tienen que apuntar a la carpeta camYYY/final de la secuencia y cámara correcta
					if findString (getFilenamePath _nukeFilesOutputs[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _nukeFilesOutputs[i][j]) ("cam"+_camNumber) == undefined then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de nuke <" + _nukeFilesOutputsNames[i][j] + "> no apunta a la secuencia y cámara correctos: " + (getFilenamePath _nukeFilesOutputs[i][j]) + " \n"
					)
					else
					(
						if not matchpattern (substituteString (tolower _nukeFilesOutputs[i][j]) "/" "\\") pattern:("\\\\lbdata002\\z\\frame\\seq_"+_seqNumber+"\\cam\\cam"+_camNumber+"\\final\\*") then
						(
							_fail = true
							if _firstError then
							(
								_firstError = false
								log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
							)
							
							log += "-> El nodo de nuke <" + _nukeFilesOutputsNames[i][j] + "> no apunta a la carpeta " + (getFilenamePath _nukeFilesOutputs[i][j]) + " \n"
						)
						else
						(
							if not matchpattern (filenameFromPath (substituteString (tolower _nukeFilesOutputs[i][j]) "/" "\\")) pattern:lb.nc.NC_seqFrameFinalPattern then
							(
								_fail = true
								if _firstError then
								(
									_firstError = false
									log += "*********** File: " + filenameFromPath _postNukeFiles[i] + " ***********\n"
								)
								
								log += "-> El nodo de nuke <" + _nukeFilesOutputsNames[i][j] + "> no tiene el patrón de los frames finales bien escrito (ver ayuda más abajo).\n"
							)
						)
					)-- if findString (getFilenamePath _nukeFilesOutputs[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _nukeFilesOutputs[i][j]) ("cam"+_camNumber) == undefined then
				)-- for j=1 to _nukeFilesOutputs[i].count do
			)-- for i=1 to _nukeFilesOutputs.count do
			
			_fusionFilesOutputs = #()
			_fusionFilesOutputsNames = #()
			
			for i=1 to _postFusionFiles.count do
			(
				_fusionSaverNodes = #() --nodos save del nuke
				_fusionSaverNodesPaths = #() --paths de los save
				
				--estados de busqueda
				_searchState = #saver
				--#saver --buscando nodos saver
				--#filename --buscando el path de salida
									
				_f = openfile _files[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#saver: --ESTADO DE BUSQUEDA DE NODO SAVER
						(
							if matchPattern _l pattern:"*= Saver {*" then
							(
								append _fusionSaverNodes (filterString _l "	 =")[1] --añade el nombre del nodo saver al array
								append _fusionSaverNodesPaths "" --añade un path vacio
								_searchState = #filename
							)--if
						)--#saver
						
						#filename: --ESTADO DE BUSQUEDA DEL PATH DE SALIDA
						(
							if findString _l "Filename =" != undefined then --almacena el path y pasa al siguiente estado
							(
								_path = (filterString (substituteString _l "Filename =" "") "	 \",")[1] --obtiene el path
								_fusionSaverNodesPaths[_fusionSaverNodesPaths.count] = (substituteString _path "\\\\" "\\")
								
								_searchState = #saver
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
				
				append _fusionFilesOutputs _fusionSaverNodesPaths
				append _fusionFilesOutputsNames _fusionSaverNodes
			)--for
			
			
			_firstError = true
			for i=1 to _fusionFilesOutputs.count do
			(
				for j=1 to _fusionFilesOutputs[i].count do
				(
					--Los nodos tienen que apuntar a la carpeta camYYY/final de la secuencia y cámara correcta
					if findString (getFilenamePath _fusionFilesOutputs[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _fusionFilesOutputs[i][j]) ("cam"+_camNumber) == undefined then
					(
						_fail = true
						if _firstError then
						(
							_firstError = false
							log += "*********** File: " + filenameFromPath _postfusionFiles[i] + " ***********\n"
						)
						
						log += "-> El nodo de fusion <" + _fusionFilesOutputsNames[i][j] + "> no apunta a la secuencia y cámara correctos: " + (getFilenamePath _fusionFilesOutputs[i][j]) + " \n"
					)
					else
					(
						if not matchpattern (tolower _fusionFilesOutputs[i][j]) pattern:("\\\\lbdata002\\z\\frame\\seq_"+_seqNumber+"\\cam\\cam"+_camNumber+"\\final\\*") then
						(
							_fail = true
							if _firstError then
							(
								_firstError = false
								log += "*********** File: " + filenameFromPath _postfusionFiles[i] + " ***********\n"
							)
							
							log += "-> El nodo de fusion <" + _fusionFilesOutputsNames[i][j] + "> con ruta <" + _fusionFilesOutputs[i][j] + "> no apunta a la carpeta \\\\lbdata002\\z\\frame\\seq_"+_seqNumber+"\\cam\\cam"+_camNumber+"\\final\\ \n"
						)
						else
						(
							if not matchpattern (tolower (filenameFromPath _fusionFilesOutputs[i][j])) pattern:lb.nc.NC_seqFrameFinalPattern then
							(
								_fail = true
								if _firstError then
								(
									_firstError = false
									log += "*********** File: " + filenameFromPath _postFusionFiles[i] + " ***********\n"
								)
								
								log += "-> El nodo de Fusion <" + _fusionFilesOutputsNames[i][j] + "> con valor <" + (filenameFromPath _fusionFilesOutputs[i][j]) + "> no tiene el patrón de los frames finales bien escrito (ver ayuda más abajo).\n"
							)
						)
					)-- if findString (getFilenamePath _fusionFilesOutputs[i][j]) ("seq_"+_seqNumber) == undefined or findString (getFilenamePath _fusionFilesOutputs[i][j]) ("cam"+_camNumber) == undefined then
				)-- for j=1 to _fusionFilesOutputs[i].count do
			)-- for i=1 to _fusionFilesOutputs.count do
			
			
			-------------------------------------------------------------------------------
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check se aplica a los archivos de compo montados en el departamento de iluminación (que tienen v01 en el nombre)\n"
				log += "Los nodos de salida de los frames de fusion y nuke (aquellos que dicen donde se guardan los frames que salen al renderizar)\n"
				log += "tienen que apuntar a la carpeta \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\final\\.\n"
				log += "Por otra parte los frames que salgan tendrán que llamarse:\n"
				log += "seq_XXX_camYYY_final_0000.tiff ó .tif\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_postWriteNodeOk
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que no hay frames obsoletos
	struct checkTask_NotObsoleteFrames
	(
		id = lb.totalChecker.rollMain.TCH_NotObsoleteFrames, --id de la tarea
		name = "Frames: No debe haber frames obsoletos en la carpeta de la secuencia", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = true, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_SVNrenderPathUpdated, lb.totalChecker.rollMain.TCH_SVNpostPathUpdated, lb.totalChecker.rollMain.TCH_postNukeFilesNodesActive, lb.totalChecker.rollMain.TCH_postFusionFilesNodesActive, lb.totalChecker.rollMain.TCH_framePathExist), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			-------------------------------------------------------------------------------------------
			--obtiene la informacion de los outputs -------------------------------------
			
			-------------------------------------------------------------------------------
			struct renderOutputInfo --struct para la informacion de ouputs de la camara
			(
				path = "", --el path del output
				fileExist = false, --indica si existe
				
				--para comprobar si la secuencia y la camara coinciden en el path y el nombre del frame. Tambien para compararlo con el path del check
				pathSeq = "",
				pathCam = "",
				fileSeq = "",
				fileCam = "",
				
				hasFrame = false, --para saber si el render esta hecho
				
				hasLPMpass = false, --para saber si viene de un pase de LPM
				lpmPassName = "", --para saber el nombre del pase de lpm del que viene
				maxFile = "", --para saber el nombre del max del que viene
					
				hasNukeRead = false, --para saber si hay un nodo read de nuke que lo contenga
				nukeReadName = "", --para guardar el nombre del nodo read
				nukeFile = "", --para saber el archivo de nuke del que viene
				
				hasFusionLoader = false, --para saber si hay un nodo loader de fusion que lo contenga
				fusionLoaderName = "", --para guardar el nombre del nodo loader
				fusionFile = "", --para saber el archivo de fusion del que viene
				
				state = #(0,0,0,0) --arrays de estados posibles #(fileExist, hasLPMpass, hasNukeRead, hasFusionLoader)
			)--renderOutputInfo
			-------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--arrays de informacion
			_renderOutputInfo = #() --para almacenar un array de structs de informacion de outputs de render
			
			_renderMaxFilesPath = (path + @"render\*")
			_renderMaxFiles = if maxFiles.count != 0 then maxFiles else getFiles (_renderMaxFilesPath + ".max")
			_renderMaxLPMpasses = #() --para guardar un array de nombres de capa de lpm por cada archivo max
			_renderMaxLPMpassesOpts = #() --para guardar un array de ouputs por cada archivo max
			
			_postFilesPath = (path + @"post\*") --path de post
			_postFusionFiles = getFiles (_postFilesPath + ".comp") --arhivos de fusion
			_postFusionIptsNames = #() --para guardar el nombre del nodo que lleva cada input de post
			_postFusionIpts = #() --para guardar un array de inputs por cada arhivo de post
			_postNukeFiles = getFiles (_postFilesPath + ".nk") --archivos de nuke
			_postNukeIptsNames = #() --para guardar el nombre del nodo que lleva cada input de post
			_postNukeIpts = #() --para guardar un array de inputs por cada arhivo de post
			
			_framesPath = (substituteString (tolower (path + @"*")) @"z:\sequence" @"\\lbdata002\z\frame")
			_frameOpts = getFiles (_framesPath + ".*") --almacena todos los outputs de fotogramas
			-------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--FRAMES
			--los archivos de frames que lleven al final los 4 digitos de numero de frame, hay que agruaprlos por nombre y quedarnos solo con uno de ellos para las comprobaciones
			for i=_frameOpts.count to 1 by -1 do
			(
				_fileName = (getFileNameFile _frameOpts[i]) + (getFileNameType _frameOpts[i]) --obtiene el nombre del archivo
				
				if matchPattern _fileName pattern:"*_????.*" then --si lleva numero de fotogramas al final
				(
					_frameNumber = (filterString (filterString _fileName "_")[(filterString _fileName "_").count] ".")[1]
					if lb.math.isNumeric _frameNumber then _frameOpts[i] = substituteString _frameOpts[i] ("_" + _frameNumber) "_####"
				)--if matchPattern
				else if matchPattern _fileName pattern: "*.db" then
					deleteItem _frameOpts i	
			)--for
			
			--limpia y ordena el array
			_frameOpts = makeUniqueArray _frameOpts 
			sort _frameOpts
			------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--LPM
			--obtiene los opts de LPM por cada max
			for i=1 to _renderMaxFiles.count do
			(
				_renderMaxLPMpasses[i] = (getFileInfoLPMpasses _renderMaxFiles[i] info:maxFilesInfo[i])
				_renderMaxLPMpassesOpts[i] = deepCopy (getFileInfoLPMpassesOutputs _renderMaxFiles[i] info:maxFilesInfo[i])
				
				for j=1 to _renderMaxLPMpassesOpts[i].count do
				(
					_renderMaxLPMpassesOpts[i][j] = substituteString _renderMaxLPMpassesOpts[i][j] (getFileNameFile _renderMaxLPMpassesOpts[i][j]) ((getFileNameFile _renderMaxLPMpassesOpts[i][j]) + "####")
					--_renderMaxLPMpassesOpts[i][j] = ((tolower (getFileNamePath _renderMaxLPMpassesOpts[i][j])) + (getFileNameFile _renderMaxLPMpassesOpts[i][j]) + (getFileNameType _renderMaxLPMpassesOpts[i][j]))
				)
			)--for
			-------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--FUSION
			--obtiene los reader de nuke, su nombre y su input
			for i=1 to _postFusionFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postFusionIptsNames[i] = #()
				_postFusionIpts[i] = #()
				
				--estados de busqueda
				_searchState = #loader
				--#loader --buscando nodos loader
				--#filename --buscando el input del loader
					
				_f = openfile _postFusionFiles[i] mode:"r" --abre el archivo de fusion en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
						(
							if findString _l " = Loader {" != undefined then
							(
								_searchState = #filename
								
								_name = substituteString _l " = Loader {" ""
								_name = substituteString _name "	" ""
								
								append _postFusionIptsNames[i] _name --añade el nombre al array
							)
						)--#loader
						
						#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
						(
							if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #loader
								
								_path = (filterString _l "\"")[2]
								_path = substituteString _path "\\\\" "\\"
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
								
								append _postFusionIpts[i] _path
							)
						)--#filename							
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postFusionFiles
			-------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------
			--NUKE
			--obtiene los reader de nuke, su nombre y su input
			for i=1 to _postNukeFiles.count do
			(
				--inicializa los arrays de informacion para ese archivo
				_postNukeIptsNames[i] = #()
				_postNukeIpts[i] = #()
				
				--estados de busqueda
				_searchState = #read
				--#read --buscando nodos read
				--#file --buscando el input del read
				--#name --buscando el nombre del nodo read
									
				_f = openfile _postNukeFiles[i] mode:"r" --abre el archivo de nuke en modo lectura
				
				while not eof _f do --recorre el archivo hasta el final
				(
					_l = readLine _f
					
					case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
					(
						#read: --ESTADO DE BUSQUEDA DE NODO READ
						(
							if findString _l "Read {" != undefined then _searchState = #file
						)--#read
						
						#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
						(
							if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
							(
								_searchState = #name
								
								_path = substituteString _l " file " ""
								_path = substituteString _path "/" "\\"
								if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
								
								_fParts = filterString (getFileNameFile _path) "_"
								if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
								else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
								
								append _postNukeIpts[i] _path
							)
						)--#file
						
						#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
						(
							if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
							(
								_searchState = #read
								
								_name = substituteString _l " name " ""
									
								append _postNukeIptsNames[i] _name --añade el name al array
							)
						)--#name
					)--case ESTADOS						
				)--while not eof
				
				close _f
			)--for _postNukeFiles
			-------------------------------------------------------------------------------
				
			-------------------------------------------------------------------------------
			-------------------------------------------------------------------------------
			--rellena la informacion de los outputs en el array de structs
			
			--funcion para saber el indice de un struct de output
			fn _getRenderOutputInfoIndex path _renderOutputInfo =
			(
				_index = 0
				for i=1 to _renderOutputInfo.count where (tolower _renderOutputInfo[i].path) == (tolower path) do _index = i
				_index
			)
			
			--rellena OUTPUTS con la informacion de NUKE
			for i=1 to _postNukeFiles.count do
				for j=1 to _postNukeIpts[i].count do
				(
					_index = _getRenderOutputInfoIndex _postNukeIpts[i][j] _renderOutputInfo --mira si el output ya esta almacenado
					
					if _index != 0 then
					(
						_renderOutputInfo[_index].hasNukeRead = true
						_renderOutputInfo[_index].nukeReadName = _postNukeIptsNames[i][j]
						_renderOutputInfo[_index].nukeFile = _postNukeFiles[i]
					)
					else
					(
						_roi = renderOutputInfo path:_postNukeIpts[i][j] hasNukeRead:true nukeReadName:_postNukeIptsNames[i][j] nukeFile:_postNukeFiles[i] --fileExist:(doesFileExist _postNukeIpts[i][j])
						append _renderOutputInfo _roi
					)
				)--for
				
			--rellena OUTPUTS con la informacion de FUSION
			for i=1 to _postFusionFiles.count do
				for j=1 to _postFusionIpts[i].count do
				(
					_index = _getRenderOutputInfoIndex _postFusionIpts[i][j] _renderOutputInfo --mira si el output ya esta almacenado
					
					if _index != 0 then --si ya estaba almaenado, completa parametros
					(
						_renderOutputInfo[_index].hasFusionLoader = true
						_renderOutputInfo[_index].fusionLoaderName = _postFusionIptsNames[i][j]
						_renderOutputInfo[_index].fusionFile = _postFusionFiles[i]
					)							
					else --si no estaba, añade una entrada nueva
					(
						_roi = renderOutputInfo path:_postFusionIpts[i][j] hasFusionLoader:true fusionLoaderName:_postFusionIptsNames[i][j] fusionFile:_postFusionFiles[i] --fileExist:(doesFileExist _postFusionIpts[i][j])
						append _renderOutputInfo _roi
					)--if else
				)--for
				
			--rellena OUTPUTS con la informacion de LPM
			for i=1 to _renderMaxFiles.count do
				for j=1 to _renderMaxLPMpassesOpts[i].count do
				(
					_index = _getRenderOutputInfoIndex _renderMaxLPMpassesOpts[i][j] _renderOutputInfo --mira si el output ya esta almacenado
					
					if _index != 0 then --si ya estaba almaenado, completa parametros
					(
						_renderOutputInfo[_index].hasLPMpass = true
						_renderOutputInfo[_index].lpmPassName = _renderMaxLPMpasses[i][j]
						_renderOutputInfo[_index].maxFile = _renderMaxFiles[i]
					)							
					else --si no estaba, añade una entrada nueva
					(
						_roi = renderOutputInfo path:_renderMaxLPMpassesOpts[i][j] hasLPMpass:true lpmPassName:_renderMaxLPMpasses[i][j] maxFile:_renderMaxFiles[i] --fileExist:(doesFileExist _renderMaxLPMpassesOpts[i][j])
						append _renderOutputInfo _roi
					)--if else
				)--for
			
			--rellena OUTPUTS con la informacion de FRAMES
			for i=1 to _frameOpts.count do
			(
				_index = _getRenderOutputInfoIndex _frameOpts[i] _renderOutputInfo --mira si el output ya esta almacenado
				
				if _index != 0 then --si ya estaba almaenado, completa parametros
					_renderOutputInfo[_index].hasFrame = true
				else --si no estaba, añade una entrada nueva
				(
					_roi = renderOutputInfo path:_frameOpts[i] hasFrame:true --fileExist:(doesFileExist _frameOpts[i])
					append _renderOutputInfo _roi
				)--if else
			)--for
			
			--rellena la informacion de si el path EXISTE y el estado STATE #(1,0,1,1)
			--tambien relena los numeros de camara y de secuencia
			for i=1 to _renderOutputInfo.count do
			(
				_roi = _renderOutputInfo[i] --elemento actual
				_roi.fileExist = ((getFiles (substituteString _roi.path "####" "*")).count != 0)
				_roi.state = #((if _roi.fileExist then 1 else 0), (if _roi.hasLPMpass then 1 else 0), (if _roi.hasNukeRead then 1 else 0), (if _roi.hasFusionLoader then 1 else 0))
				
				_pathParts = filterString (getFileNamePath _roi.path) "\\"
				_fileParts = filterString (getFileNameFile _roi.path) "_"
				
				for p in _pathParts do --rellena la secuencia y la camara del path
				(
					p = tolower p
					if matchPattern p pattern:"seq_???*" then _roi.pathSeq = p
					else if matchPattern p pattern:"cam???" then _roi.pathCam = p
				)--for
				
				for j=1 to _fileParts.count do --rellena la secuencua y la camara del nombre del archivo
				(
					p = tolower _fileParts[j]
					if matchPattern p pattern:"cam???" then _roi.fileCam = p
					else if (p == "seq") and (_fileParts[j+1] != undefined) and (lb.math.isNumeric (substring _fileParts[j+1] 1 3)) then _roi.fileSeq = ("seq_" + _fileParts[j+1])						
				)--for
			)--for
			
			--funcion para ordenar los ouputs por su estado
			fn _compareRenderOutputState roi1 roi2 =
			(
				_result = 0
				
				_stop = false
				for i=1 to roi1.state.count where not _stop do
					if roi1.state[i] < roi2.state[i] then (_stop = true; _result = -1) else if roi1.state[i] > roi2.state[i] then (_stop = true; _result = 1)
				
				_result
			)--fn
			
			--ordena los resultados
			qsort _renderOutputInfo _compareRenderOutputState
			-------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = part
				else if matchPattern part pattern:"cam???" then _camNumber = part
			)--for
			
			-------------------------------------------------------------------------------------------
			--Ahora, con la informacion de los oputputs, ya se puede establecer lo que es erróneo y lo que no
			for i=1 to _renderOutputInfo.count do
			(
				_roi = _renderOutputInfo[i] --elemento actual
				
				if _roi.pathSeq == "" or _roi.pathCam == "" then (_fail = true; log += _roi.path + " -> El path del frame no cumple el naming convention.\n")
				if _roi.fileSeq == "" or _roi.fileCam == "" then (_fail = true; log += _roi.path + " -> El nombre del frame no cumple el naming convention.\n")
				
				if _roi.pathSeq != _roi.fileSeq then (_fail = true; log += _roi.path + " -> El numero de secuencia no coincide entre el path del frame y el frame.\n")
				if _roi.pathCam != _roi.fileCam then (_fail = true; log += _roi.path + " -> El numero de camara no coincide entre el path del frame y el frame.\n")	
				
				if _roi.pathSeq != _seqNumber then (_fail = true; log += _roi.path + " -> El numero de secuencia del path del frame no coincide con el del path de la camara.\n")
				if _roi.pathCam != _camNumber then (_fail = true; log += _roi.path + " -> El numero de camara del path del frame no coincide con el del path de la camara.\n")
				
				if _roi.fileSeq != _seqNumber then (_fail = true; log += _roi.path + " -> El numero de secuencia del nombre del frame no coincide con el del path de la camara.\n")
				if _roi.fileCam != _camNumber then (_fail = true; log += _roi.path + " -> El numero de camara del nombre del frame no coincide con el del path de la camara.\n")
					
			)
			
			if _fail then log += "\n"
			
			-------------------------------------------------------------------------------------------
			--Ahora, con la informacion de los oputputs, ya se puede establecer lo que es erróneo y lo que no
			for i=1 to _renderOutputInfo.count do
			(
				_roi = _renderOutputInfo[i] --elemento actual
				
				--mira caso a caso que se considere un fallo y genera el log correspondiente al mismo
				case (_roi.state as string) of
				(
					-- 						"#(0, 0, 0, 0)": (_fail = true; log += _roi.path + " - > ESTE CASO NO SE PUEDE DAR.\n")
					-- 						"#(0, 0, 0, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > pero no existe ni viene de ninguna capa de LPM.\n")
					-- 						"#(0, 0, 1, 0)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > pero no existe ni viene de ninguna capa de LPM.\n")
					-- 						"#(0, 0, 1, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > y además Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > (no debe usarse al mismo tiempo en NUKE y en FUSION).\n")
					-- 						
					-- 						"#(0, 1, 0, 0)": (_fail = true; log += _roi.path + " - > Procede de la capa de LPM:< " + _roi.lpmPassName + " > del archivo de MAX:< " + (getFileNameFile _roi.maxFile) + ".max > pero no se esta usando en ningún archivo de composicion, ni los frames existen, puede que no se haya hecho el render, se les haya cambiado el nombre o esten obsoletos.\n")
					-- 						"#(0, 1, 0, 1)": (_fail = true; log += _roi.path + " - > Procede de la capa de LPM:< " + _roi.lpmPassName + " > del archivo de MAX:< " + (getFileNameFile _roi.maxFile) + ".max > pero los frames no existen, puede que no se haya hecho el render, se les haya cambiado el nombre o esten obsoletos.\n")
					-- 						"#(0, 1, 1, 0)": (_fail = true; log += _roi.path + " - > Procede de la capa de LPM:< " + _roi.lpmPassName + " > del archivo de MAX:< " + (getFileNameFile _roi.maxFile) + ".max > pero los frames no existen, puede que no se haya hecho el render, se les haya cambiado el nombre o esten obsoletos.\n")
					-- 						"#(0, 1, 1, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > y además Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > (no debe usarse al mismo tiempo en NUKE y en FUSION).\n")
					-- 						
					"#(1, 0, 0, 0)":
					(
						_fail = true
						log += _roi.path + " - > Los frames existen pero no vienen de ninguna capa de LPM ni se usan en composicion. Puede que estén obsoletos o no estén actualizadas las carpetas RENDER y POST. USAR SOLO EL FIX SI ESTA TOTALMENTE SEGURO DE QUE SON OBSOLETOS.\n"
						
						if fix then --si tiene que hacer fix
						(
							_filesToMove = getFiles (substituteString _roi.path "####" "*")
								
							if _filesToMove.count != 0 then
							(
								if not doesFileExist ((getFileNamePath _roi.path) + "old\\") then makeDir ((getFileNamePath _roi.path) + "old\\")
								
								for _file in _filesToMove do
									renamefile _file ((getFileNamePath _file) + "old\\" + (getFileNameFile _file) + (getFileNameType _file))
							)--if
						)--if fix
					)
					-- 						"#(1, 0, 0, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > pero los frames existen y no vienen de ninguna capa de LPM. Puede que estén obsoletos o no esté actualizada la carpeta RENDER.\n")
					-- 						"#(1, 0, 1, 0)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > pero los frames existen y no vienen de ninguna capa de LPM. Puede que estén obsoletos o no esté actualizada la carpeta RENDER.\n")
					-- 						"#(1, 0, 1, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > y además Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > (no debe usarse al mismo tiempo en NUKE y en FUSION).\n")
					-- 						
					-- 						"#(1, 1, 0, 0)": (_fail = true; log += _roi.path + " - > Los frames existen, proceden de la capa de LPM:< " + _roi.lpmPassName + " > del archivo de MAX:< " + (getFileNameFile _roi.maxFile) + ".max > pero no se estan usando en ningún archivo de composicion.\n")
					-- 						"#(1, 1, 1, 1)": (_fail = true; log += _roi.path + " - > Se está usando en el READ:< " + _roi.nukeReadName + " > del archivo de NUKE:< " + (getFileNameFile _roi.nukeFile) + ".nk > y además Se está usando en el LOADER:< " + _roi.fusionLoaderName + " > del archivo de FUSION:< " + (getFileNameFile _roi.fusionFile) + ".comp > (no debe usarse al mismo tiempo en NUKE y en FUSION).\n")
				)--case					
			)--for				
			-------------------------------------------------------------------------------------------
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				_bckpLog = log
				
				--completa el log
				log = "**************************************************************************************\n"
				log += "ESTE CHECK TIENE FIX PERO ES PELIGROSO HACERLO. HAY QUE ESTAR TOTALMENTE SEGURO DE QUE LOS FRAMES SON OBSOLETOS ANTES DE HACERLO.\n"
				log += "Para que el check se habilite, deben estar en estado OK los checks: 14, 15, 20, 24 y 27.\n"
				log += "**************************************************************************************\n\n" + _bckpLog
				log += "\nAYUDA:\n"
				log += "Los frames que estan obsoletos y ya no se usen en ningun archivo de composicion, deben moverse a la carpeta 'old' de la camara.\n"
				log += "Ej: \\\\lbdata001\\z\\frame\\seqXXX\\cam\\camYYY\\old\\.\n"
				log += "**************************************************************************************\n\n"
			)--if

		)--executeFN
	)--checkTask_NotObsoleteFrames
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que los frames de una secuencia no estén corruptos, sacará warning pero no error.
	struct checkTask_findMissingFrames
	(
		id = lb.totalChecker.rollMain.TCH_findMissingFrames, --id de la tarea
		name = "Frames: Comprobacion de existencia de frames.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
		-- 				print ("Path de la camara: " + path)
			
			--obtiene los archivos
			_filesPath = (path + @"render\*render_*")
			
			if maxfiles.count == 0 then maxfiles = getFiles (_filesPath + ".max")
			
		-- 				print ("Numero de archivos de max: " + maxFiles.count As String)
			
			--Primero sacaremos los outputs de los pases y los rangos de los pases 
			for i=1 to maxFiles.count do
			(
		-- 					print ("Extrainfo del archivo " + maxFiles[i])
		-- 					_start = timeStamp()
				
				_passesNames = getFileInfoLPMpasses maxFiles[i] info:maxFilesInfo[i]
				_passesOutputs = getFileInfoLPMPassesOutputs maxFiles[i] info:maxFilesInfo[i] 
				_passesRanges = getFileInfoLPMPassesRenderRange maxFiles[i] info:maxFilesInfo[i]
				
		-- 					_time = ((timeStamp() - _start)/1000.0)
		-- 					print (_time as string)
		-- 					_start = timeStamp()
				
				--Si tenemos extrainfo de outputs
				if _passesOutputs.count != 0 then
				(
				
					if _passesRanges.count != 0 then
					(
						--Ahora recorreremos todos los pases
						for j=1 to _passesRanges.count do
						(
								--De manera preventiva sustituiremos lbdata001 por lbdata002
							if findString (tolower _passesOutputs[j]) "\\\\lbdata002\\" == 0 then
								_passesOutputs[j] = substituteString (tolower _passesOutputs[j]) "lbdata001" "lbdata002"
		-- 								print _passesOutputs[j]
							--Sacaremos el tamaño medio de todos los archivos por pase y miraremos si hay alguno que se va mucho de tamaño a la baja.
							_outputPattern = (filterString _passesOutputs[j] ".")[1] + "*." +  (filterString _passesOutputs[j] ".")[2]
							_framesCount = 0 
							_missingFrames = #()
							
							--En este bucle saco el tamaño total de todos los frames
							for k=_passesRanges[j].start to (_passesRanges[j].end) do
							(
								_outputFrame = (filterString _passesOutputs[j] ".")[1] + formattedPrint ((k As Integer)/ticksperframe) format:"04d" +"." +  (filterString _passesOutputs[j] ".")[2]
								--_outputFrame = substituteString (tolower _outputFrame) "\\\\lbdata001\\z" "z:\\"
								--_outputFrame = substituteString (tolower _outputFrame) "\\\\lbdata002\\z" "z:\\"
								
								if doesfileexist _outputFrame then
								(
									_framesCount += 1
								)
								else
								(
									append _missingFrames ((k As Integer)/ticksperframe)
								)
							)-- for k=_passesRanges[j].start to (_passesRanges[j].end + 1) do
							
							--Una vez tengo la lista de frames miro si hay fallos.
							if _framesCount == 0 then
							(
								log += "PASE: " + _passesNames[j] + " de rango [" + _passesRanges[j].start As String + "," + _passesRanges[j].end As String +"]\n"
								log += "y salida: " + _passesOutputs[j] + "\n" 
								_fail = true
								log += "Error: El pase <" + _passesNames[j] + "> no tiene frames del rango renderizados.\n"
							)
							else
							(
								if _missingFrames.count > 0 then
								(
									_fail = true
									log += "PASE: " + _passesNames[j] + " de rango [" + _passesRanges[j].start As String + "," + _passesRanges[j].end As String +"]\n"
									
									_output = (_missingFrames As bitArray) As String
									_output = substituteString _output "#" ""
									_output = substituteString _output ".." "-"
									_output = substituteString _output "{" "("
									_output = substituteString _output "}" ")"
									
									log += "Faltan estos frames: " + _output
									log += "\n"
								)
							)-- if _framesCount == 0 then
							
							
							--Ahora miraremos si hay frames fuera del rango.
							_passFrames = getFiles ((filterString _passesOutputs[j] ".")[1] + "*.*")
							
		-- 								print _passesNames[j]
							
							
							--Recorro todos los archivos de frames de la carpeta hasta que de con alguno que se salga de rango
							_framesOutOfRange = #()
							for k=1 to _passFrames.count do
							(
		-- 									if _passesNames[j] == "fg(main-char-bnc)" then
		-- 										print _passFrames[k]
								_frameNumber = (filterString (getFilenameFile _passFrames[k]) "_")[6] As Number
								if _frameNumber < _passesRanges[j].start or _frameNumber > _passesRanges[j].end then
								(
									append _framesOutOfRange _frameNumber
								)
							)
							
							--Si hay frames fuera de rango doy un error
							if _framesOutOfRange.count > 0 then
							(
								_fail = true
								
								--Primero miro si antes ha habido algún error para poner el titulo o no del pase en el que estamos
								if _framesCount > 0 and _missingFrames.count == 0 then
								(
									log += "PASE: " + _passesNames[j] + " de rango [" + _passesRanges[j].start As String + "," + _passesRanges[j].end As String +"]\n"
								)
								
								_output = (_framesOutOfRange As bitArray) As String
								_output = substituteString _output "#" ""
								_output = substituteString _output ".." "-"
								_output = substituteString _output "{" "("
								_output = substituteString _output "}" ")"
								
								log += "Error: Hay frames renderizados que estan fuera del rango del pase.\n"
								log += "Frames fuera de rango: " + _output
								log += "\n"
								
							)
							
							--Al final del todo añado un \n adicional si ha habido errores en el pase.
							if _framesCount == 0 or _missingFrames.count > 0 or _framesOutOfRange.count > 0 then
							(
								log += "\n"
							)
							
						)-- for j=1 to _passesRanges.count do
					)-- if _passesRanges != #() then
					else
					(
						if not _fail then
						(
							_warning = true
						)
						log += "**ARCHIVO <" + maxFiles[i] + ">\n"
						log += "Warning: El archivo <" + (filenameFromPath maxFiles[i]) + "> no tiene informacion de rangos de capas de LPM, puede que la información extra sea antigua, esté corrupta o el archivo no tenga capas de LPM. La comprobación de si faltan frames por renderizar, se debe hacer a mano o se debe resalvar el archivo .max para que se almacene la información correcta.\n\n"
					)
				)-- if _passesOutputs != #() then
				else
				(
					if not _fail then
					(
						_warning = true
					)
					log += "**ARCHIVO <" + maxFiles[i] + ">\n"
					log += "Warning: El archivo <" + (filenameFromPath maxFiles[i]) + "> no tiene informacion de capas de LPM, puede que la información extra sea antigua, esté corrupta o el archivo no tenga capas de LPM. La comprobación de si faltan frames por renderizar, se debe hacer a mano o se debe resalvar el archivo .max para que se almacene la información correcta.\n\n"
				)
		-- 					print ("GetFiles del archivo " + maxFiles[i])
		-- 					_time = ((timeStamp() - _start)/1000.0)
		-- 					print (_time as string)
			)
			
			if _warning then
				state = warningMessage
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Las capas tienen que tener renderizados los frames correspondientes a su rango.\n"
				log += "Las capas tienen que tener frames renderizados dentro del rango de la capa.\n"
				log += "Las capas tienen que tener al menos un frame renderizado.\n"
				log += "**************************************************************************************\n\n"
			)--if

		)--executeFN
	)--checkTask_findMissingFrames
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que los frames de una secuencia no estén corruptos, sacará warning pero no error.
	struct checkTask_findMissingFxFrames
	(
		id = lb.totalChecker.rollMain.TCH_findMissingFxFrames, --id de la tarea
		name = "Frames: Comprobacion de existencia de frames de fx.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
		-- 				print ("Path de la camara: " + path)
			
			--obtiene los archivos
			_filesPath = (path + @"render\*renderFx_*")
			
			if maxfiles.count == 0 then maxfiles = getFiles (_filesPath + ".max")
			
		-- 				print ("Numero de archivos de max: " + maxFiles.count As String)
			
			--Primero sacaremos los outputs de los pases y los rangos de los pases 
			for i=1 to maxFiles.count do
			(
		-- 					print ("Extrainfo del archivo " + maxFiles[i])
		-- 					_start = timeStamp()
				
				_passesNames = getFileInfoLPMpasses maxFiles[i] info:maxFilesInfo[i]
				_passesOutputs = getFileInfoLPMPassesOutputs maxFiles[i] info:maxFilesInfo[i] 
				_passesRanges = getFileInfoLPMPassesRenderRange maxFiles[i] info:maxFilesInfo[i]
				
		-- 					_time = ((timeStamp() - _start)/1000.0)
		-- 					print (_time as string)
		-- 					_start = timeStamp()
				
				--Si tenemos extrainfo de outputs
				if _passesOutputs.count != 0 then
				(
				
					if _passesRanges.count != 0 then
					(
						--Ahora recorreremos todos los pases
						for j=1 to _passesRanges.count do
						(
								--De manera preventiva sustituiremos lbdata001 por lbdata002
							_passesOutputs[j] = substituteString (tolower _passesOutputs[j]) "lbdata001" "lbdata002"
		-- 								print _passesOutputs[j]
							--Sacaremos el tamaño medio de todos los archivos por pase y miraremos si hay alguno que se va mucho de tamaño a la baja.
							_outputPattern = (filterString _passesOutputs[j] ".")[1] + "*." +  (filterString _passesOutputs[j] ".")[2]
							_framesCount = 0 
							_missingFrames = #()
							
							--En este bucle saco el tamaño total de todos los frames
							for k=_passesRanges[j].start to (_passesRanges[j].end) do
							(
								_outputFrame = (filterString _passesOutputs[j] ".")[1] + ((k As Integer)/ticksperframe) As String +"." +  (filterString _passesOutputs[j] ".")[2]
								--_outputFrame = substituteString (tolower _outputFrame) "\\\\lbdata001\\z" "z:\\"
								--_outputFrame = substituteString (tolower _outputFrame) "\\\\lbdata002\\z" "z:\\"
								
								if doesfileexist _outputFrame then
								(
									_framesCount += 1
								)
								else
								(
									append _missingFrames ((k As Integer)/ticksperframe)
								)
							)-- for k=_passesRanges[j].start to (_passesRanges[j].end + 1) do
							
							--Una vez tengo la lista de frames miro si hay fallos.
							if _framesCount == 0 then
							(
								log += "PASE: " + _passesNames[j] + " de rango [" + _passesRanges[j].start As String + "," + _passesRanges[j].end As String +"]\n"
								_fail = true
								log += "Error: El pase <" + _passesNames[j] + "> no tiene frames del rango renderizados.\n"
							)
							else
							(
								if _missingFrames.count > 0 then
								(
									_fail = true
									log += "PASE: " + _passesNames[j] + " de rango [" + _passesRanges[j].start As String + "," + _passesRanges[j].end As String +"]\n"
									
									_output = (_missingFrames As bitArray) As String
									_output = substituteString _output "#" ""
									_output = substituteString _output ".." "-"
									_output = substituteString _output "{" "("
									_output = substituteString _output "}" ")"
									
									log += "Faltan estos frames: " + _output
									log += "\n"
								)
							)-- if _framesCount == 0 then
							
							
							--Ahora miraremos si hay frames fuera del rango.
							_passFrames = getFiles ((filterString _passesOutputs[j] ".")[1] + "*.*")
							
		-- 								print _passesNames[j]
							
		-- 								if _passesNames[j] == "fg(main-char-bnc)" then
		-- 									print ((filterString _passesOutputs[j] ".")[1] + "*.*")
							
							--Recorro todos los archivos de frames de la carpeta hasta que de con alguno que se salga de rango
							_framesOutOfRange = #()
							for k=1 to _passFrames.count do
							(
		-- 									if _passesNames[j] == "fg(main-char-bnc)" then
		-- 										print _passFrames[k]
								_frameNumber = (filterString (getFilenameFile _passFrames[k]) "_")[6] As Number
								if _frameNumber < _passesRanges[j].start or _frameNumber > _passesRanges[j].end then
								(
									append _framesOutOfRange _frameNumber
								)
							)
							
							--Si hay frames fuera de rango doy un error
							if _framesOutOfRange.count > 0 then
							(
								_fail = true
								
								--Primero miro si antes ha habido algún error para poner el titulo o no del pase en el que estamos
								if _framesCount > 0 and _missingFrames.count == 0 then
								(
									log += "PASE: " + _passesNames[j] + " de rango [" + _passesRanges[j].start As String + "," + _passesRanges[j].end As String +"]\n"
								)
								
								_output = (_framesOutOfRange As bitArray) As String
								_output = substituteString _output "#" ""
								_output = substituteString _output ".." "-"
								_output = substituteString _output "{" "("
								_output = substituteString _output "}" ")"
								
								log += "Error: Hay frames renderizados que estan fuera del rango del pase.\n"
								log += "Frames fuera de rango: " + _output
								log += "\n"
								
							)
							
							--Al final del todo añado un \n adicional si ha habido errores en el pase.
							if _framesCount == 0 or _missingFrames.count > 0 or _framesOutOfRange.count > 0 then
							(
								log += "\n"
							)
							
						)-- for j=1 to _passesRanges.count do
					)-- if _passesRanges != #() then
					else
					(
						_warning = true
						log += "Warning: El archivo .max no tiene informacion rangos de capas de LPM, puede que la información extra sea antigua. La comprobación de si faltan frames por renderizar, se debe ahcer a mano o se debe resalvar el archivo .max para que se almacene la información correcta.\n\n"
					)
				)-- if _passesOutputs != #() then
				else
				(
					_warning = true
					log += "Warning: El archivo .max no tiene informacion de capas de LPM, puede que la información extra sea antigua, esté corrupta o el archivo no tenga capas de LPM. La comprobación de si faltan frames por renderizar, se debe ahcer a mano o se debe resalvar el archivo .max para que se almacene la información correcta.\n\n"
				)
		-- 					print ("GetFiles del archivo " + maxFiles[i])
		-- 					_time = ((timeStamp() - _start)/1000.0)
		-- 					print (_time as string)
			)
			
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				if _warning then
					state = warningMessage
				else
					state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Las capas tienen que tener renderizados los frames correspondientes a su rango.\n"
				log += "Las capas tienen que tener frames renderizados dentro del rango de la capa.\n"
				log += "Las capas tienen que tener al menos un frame renderizado.\n"
				log += "**************************************************************************************\n\n"
			)--if

		)--executeFN
	)--checkTask_findMissingFxFrames
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que los frames de una secuencia no estén corruptos, sacará warning pero no error.
	struct checkTask_findCorruptedFrames
	(
		id = lb.totalChecker.rollMain.TCH_findCorruptedFrames , --id de la tarea
		name = "Frames: Comprobación de frames corruptos.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_findMissingFrames), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			if maxFiles.count == 0 then
			(
				maxFiles = getFiles(path + @"render\*render_*")
				maxFilesInfo = for mf in maxFiles collect getFileInfo mf
			)
			
			struct graphVariation
			(
				ramp = false,
				valley = false,
				frames = #()
			)
		
			--Primero sacaremos los outputs de los pases y los rangos de los pases
			for i=1 to maxFiles.count do
			(
				_passesOutputs = getFileInfoLPMPassesOutputs maxFiles[i] info:maxFilesInfo[i]
				_passesRanges = getFileInfoLPMPassesRenderRange maxFiles[i] info:maxFilesInfo[i]
				_passesNames = getFileInfoLPMpasses maxFiles[i] info:maxFilesInfo[i]
				
				--Ahora recorreremos todos los pases
				for j=1 to _passesOutputs.count do
				(
		-- 						print _passesNames[j]
					if matchpattern _passesOutputs[j] pattern:"\\\\lbdata001\\z\\*" then
						_passesOutputs[j] = substituteString (tolower _passesOutputs[j]) "\\\\lbdata001\\z\\" "z:\\"
					
		-- 						print _passesOutputs[j]
					
					--Sacaremos el tamaño medio de todos los archivos por pase y miraremos si hay alguno que se va mucho de tamaño a la baja.
					_passFiles = getFiles ((filterString _passesOutputs[j] ".")[1] + "*." +  (filterString _passesOutputs[j] ".")[2])
					_totalSize = 0
					
					/*--En este bucle saco el tamaño total de todos los frames
					for k=1 to _passFiles.count do
						_totalSize += (getFileSize _passFiles[k])
					
					--Obtengo la media y la tolerancia
					_avgSize = _totalSize / _passFiles.count*/
					_variation = 0.5
					_variations = #()
					_currentVariation = #()
					_increments = 0
					_decrements = 0
					_valley = undefined
					_novariation = true
					
					--Si hay un solo frame o no hay no miraré la variación.
					if _passFiles.count <= 1 then
						_novariation = false
					
					for k=1 to _passFiles.count do
					(
						_currentSize = getFileSize _passFiles[k]
						
						--Primero miraremos las variaciones, siempre miraremos el anterior.
						if k > 1 then
						(
							_lastSize = getFileSize _passFiles[k-1]
							
							--En cuanto los tamaños son distintos, ya habrá variación.
							if _currentSize != _lastSize then
								_novariation = false
							
							--Si se supera la variación que hemos definido
							if abs (_currentSize - _lastSize) > (_lastSize * _variation) then
							(
								if _currentSize < _lastSize then
								(
									_decrements += 1
									if _valley == undefined then
										_valley = true
								)
								else
								(
									_increments += 1
									if _valley == undefined then
										_valley = false
								)
							)
							
							--Si hay ya incrementos o decrementos añadimos el siguiente por si es meseta.
							if _increments > 0 or _decrements > 0 then
								append _currentVariation _passFiles[k]
							
							--Si hay una subida y una bajada es una meseta o un pico
							if _increments == 1 and _decrements == 1 then
							(
								--Si es un pico solo habrá 2 elementos en el array (el de la primera variación brusca y el actual que sería el de bajada)
								if _currentVariation.count == 2 then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									append _peak.frames _currentVariation[1]
									append _variations _peak 
									_valley = undefined
									_increments = 0
									_decrements = 0
								)
								--En esta caso será una meseta
								else
								(
									deleteItem _currentVariation _currentVariation.count
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									_mesa.frames = _currentVariation
									append _variations _mesa
									_valley = undefined
									_increments = 0
									_decrements = 0
								)
							)
							--Si hay varias subidas seguidas y una bajada entonces será una rampa de subida seguida de un pico o una meseta.
							else if _increments > 1 and _decrements == 1 then
							(
								--Lo que haremos será poner en la rampa todos los frames de subida
								_ramp = graphVariation()
								_ramp.ramp = true
								_ramp.valley = _valley
								
								for l=1 to _increments do
									append _ramp.frames _currentVariation[l]
								
								append _variations _ramp
								
								--Si hay tantos frames almacenados como incrementos y decrementos sumados entonces tendremos un pico tras la rampa
								if _currentVariation.count == (_increments + _decrements) then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									--Luego como pico el último frame de subida
									append _peak.frames _currentVariation[_increments]
									append _variations _peak
								)
								--En este caso tendremos una meseta tras la rampa
								else
								(
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									for l=_increments to (_currentVariation.count - _decrements) do
										append _mesa.frames _currentVariation[l]
									append _variations _mesa
								)
								
								--Si es el último frame entonces apilaremos el último como un pico.
								if k == _passFiles.count then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									append _peak.frames _currentVariation[_currentVariation.count]
									append _variations _peak
									
									_currentVariation = #()
									_increments = 0
									_decrements = 0
									_valley = undefined
								)
								else
								(
									--Por último incluiremos el ultimo frame como un descenso y dejaremos el incremento a cero
									--el decremento no lo tocaremos porque estará a 1
									_increments = 0
									_valley = true
									_currentVariation = #(_currentVariation[_currentVariation.count])										
								)
							)
							--Si hay varias subidas seguidas y una bajada entonces será una rampa de subida seguida de un pico o una meseta.
							else if _decrements > 1 and _increments == 1 then
							(
								--Lo que haremos será poner en la rampa todos los frames de subida
								_ramp = graphVariation()
								_ramp.valley = _valley
								_ramp.ramp = true
								
								for l=1 to _decrements do
									append _ramp.frames _currentVariation[l]
								
								append _variations _ramp
								
								--Si hay tantos frames almacenados como incrementos y decrementos sumados entonces tendremos un pico tras la rampa
								if _currentVariation.count == (_increments + _decrements) then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									--Luego como pico el último frame de subida
									append _peak.frames _currentVariation[_decrements]
								)
								--En este caso tendremos una meseta tras la rampa
								else
								(
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									for l=_decrements to (_currentVariation.count - _increments) do
										append _mesa.frames _currentVariation[l]
									append _variations _mesa
								)
								
								--Si es el último frame entonces apilaremos el último como un pico.
								if k == _passFiles.count then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									append _peak.frames _currentVariation[_currentVariation.count]
									_currentVariation = #()
									_increments = 0
									_decrements = 0
									_valley = undefined
								)
								else
								(
									--Por último incluiremos el ultimo frame como un descenso y dejaremos el incremento a cero
									--el decremento no lo tocaremos porque estará a 1
									_decrements = 0
									_valley = false
									_currentVariation = #(_currentVariation[_currentVariation.count])
								)
							)
							--Si tenemos una subida continuada y no hay decrementos puede que tengamos una rampa, luego una meseta y otra subida.
							else if _increments > 1 and _decrements == 0 then
							(
								--Si el numero de subidas es inferior al numero de frames eso quiere decir que enmedio de la rampa hay una meseta
								if _currentVariation.count > _increments then
								(
									--Si hay mas de dos entonces tendremos una rampa antes de la meseta.
									if _increments > 2 then
									(
										_ramp = graphVariation()
										_ramp.valley = _valley
										_ramp.ramp = true
										
										--Primero entonces apilaremos la bajada en las rampas.
										for l=1 to _increments-1 do
											append _ramp.frames _currentVariation[l]
										
										append _variations _ramp
									)
									
									--En todos los casos habrá una meseta (porque entre los incrementos hay frames que no han variado)
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									
									for l=(_increments-1) to (_currentVariation.count-1) do
										append _mesa.frames _currentVariation[l]
									append _variations _mesa
									
									_currentVariation = #(_currentVariation[_currentVariation.count])
									_increments = 1
									
									--Si es el último frame entonces sacaremos una meseta y el último como un pico.
									if k == _passFiles.count then
									(
										_peak = graphVariation()
										_peak.valley = _valley
										_peak.frames = _currentVariation
										
										append _variations _peak
										_currentVariation = #()
										_increments = 0
										_valley = undefined
									)
								)--else if _increments > 1 and _decrements == 0 then
								--Caso para el de una subida continuada.
								else if _increments == _currentVariation.count then
								(
									--Si es el último frame entonces apilaremos toda la rampa y fuera
									if k == _passFiles.count then
									(
										_ramp = graphVariation()
										_ramp.valley = _valley
										_ramp.ramp = true
										_ramp.frames = _currentVariation
										append _variations _ramp
										
										_currentVariation = 0
										_increments = 0 
										_valley = undefined
									)
								)-- else if _increments == _currentVariation.count then
								else
								(
									print "ERROR: Si el software llega a este punto es que hay algo mal en el cálculo de incrementos/decrementos.\n"
									print "ERROR: No puede haber un número de incrementos o decrementos mayor que el de frames almacenados como incrementados.\n"
								)--if _currentVariation.count > _increments then
							)--else if _increments > 1 and _decrements == 0
							--Si tenemos una bajada continuada y no hay incrementos puede que tengamos una rampa, luego una meseta y otra subida.
							else if _decrements > 1 and _increments == 0 then
							(
								--Si el numero de bajadas es inferior al numero de frames eso quiere decir que enmedio de la rampa hay una meseta
								if _currentVariation.count > _decrements then
								(
									--Si hay mas de dos entonces tendremos una rampa antes de la meseta.
									if _decrements > 2 then
									(
										_ramp = graphVariation()
										_ramp.valley = _valley
										_ramp.ramp = true
										
										--Primero entonces apilaremos la bajada en las rampas.
										for l=1 to _decrements-1 do
											append _ramp.frames _currentVariation[l]
										
										append _variations _ramp
									)
									
									--En todos los casos habrá una meseta (porque entre los descensos hay frames que no han variado)
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									
									for l=(_decrements-1) to (_currentVariation.count-1) do
										append _mesa.frames _currentVariation[l]
									append _variations _mesa
									
									_currentVariation = #(_currentVariation[_currentVariation.count])
									_decrements = 1
									
									--Si es el último frame entonces sacaremos una meseta y el último como un pico.
									if k == _passFiles.count then
									(
										_peak = graphVariation()
										_peak.valley = _valley
										_peak.frames = _currentVariation
										
										append _variations _peak
										_currentVariation = #()
										_decrements = 0
										_valley = undefined
									)
								)--if _currentVariation.count > _decrements then
								--Caso para el de una bajada continuada.
								else if _decrements == _currentVariation.count then
								(
									--Si es el último frame entonces apilaremos toda la rampa y fuera
									if k == _passFiles.count then
									(
										_ramp = graphVariation()
										_ramp.valley = _valley
										_ramp.ramp = true
										_ramp.frames = _currentVariation 
										append _variations _ramp
										
										_currentVariation = 0
										_decrements = 0 
										_valley = undefined
									)
								)
								else
								(
									print "ERROR: Si el software llega a este punto es que hay algo mal en el cálculo de incrementos/decrementos.\n"
									print "ERROR: No puede haber un número de incrementos o decrementos mayor que el de frames almacenados como incrementados.\n"
								)--if _currentVariation.count > _decrements then
							)--else if _decrements > 1 and _increments == 0
						)-- if k > 1 then
					)-- for k=1 to _passFiles.count do
					
					--Si no hay variación entre frames entonces
					if _novariation then
					(
						_fail = true
					)
					
					--Si hay variaciones entonces guardaremso información en el log
					if _variations.count > 0 then
					(
						_fail = true
						log += "*********************************** PASE: " + _passesNames[j] + " *****************************************\n"
						for k=1 to _variations.count do
						(
							_direction = ""
							if _variations[k].valley then _direction = "descenso" else _direction = "aumento"
								
							if _variations[k].frames.count == 1 then
							(
								log += "(PICO) Hay un " + _direction + " significativo de tamaño en el frame: " + (getFilenameFile _variations[k].frames[1])  + (getFileNameType _variations[k].frames[1]) + "\n\n"
							)
							else
							(
								if _variations[k].ramp then
								(
									log += "(RAMPA) Hay un " + _direction + " significativo de tamaño en el rango de frames [ " + (filterString (getFilenameFile _variations[k].frames[1]) "_")[6]
									log += " - " + (filterString (getFilenameFile _variations[k].frames[_variations[k].frames.count]) "_")[6] + " ]\n\n"
								)
								else
								(
									log += "(MESETA) Un grupo de frames experimenta un " + _direction + " significativo de tamaño, son los pertenecientes al rango: [ " + (filterString (getFilenameFile _variations[k].frames[1]) "_")[6]
									log += " - " + (filterString (getFilenameFile _variations[k].frames[_variations[k].frames.count]) "_")[6] + " ]\n\n"
								)
							)
							
						)
					)
					else
					(
						--Si no hay variación entre frames entonces
						if _novariation then
						(
							_fail = true
							log += "*********************************** PASE: " + _passesNames[j] + " *****************************************\n\n"
							log += "Este pase tiene todos los frames del mismo tamaño, es probable que haya salido todo corrupto o en negro.\n\n"
						)
						
					)
					
					
				)--for j=1 to _passesOutputs.count do
			)-- for i=1 to maxFiles.count do
			
			
			if _fail then --si falla añade informacion de ayuda y warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los frames renderizados pueden tener frames corruptos que se pueden detectar en función de variaciones bruscas de tamaño.\n"
				log += "Este check es orientativo e indica que cambios bruscos nos podemos encontrar en los tamaños de los frames renderizados.\n"
				log += "Leyenda:\n"
				log += "PICO: un frame varía bruscamente de tamaño respecto de su predecesor y su siguiente.\n"
				log += "Esto puede indicar un frame en negro entre otros que no lo son (ejemplo).\n"
				log += "MESETA: un grupo de frames de similar tamaño entre sí varían de tamaño respecto a los demás de alrededor.\n"
				log += "Esto puede indicar un grupo de frames corruptos.\n"
				log += "RAMPA: dos o más frames forman parte de un brusco cambio de tamaño entre ellos y los que tienen alrededor.\n"
				log += "Esto pueden ser frames corruptos con partes en negro cada vez más grandes.\n"
				log += "Todas estas denominaciones pueden responder a causas lógicas dentro de una escena como aparición/desaparición de elementos en cámara \n"
				log += "animados a mucha velocidad o una escena inicialmente a oscuras que de repente tiene una luz encendida.\n"
				log += "Por ello este check es ORIENTATIVO y todo lo que indica son estimaciones.\n"
				log += "**************************************************************************************\n\n"
			)--if

		)--executeFN
	)--checkTask_findCorruptedFrames
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que los frames de una secuencia no estén corruptos, sacará warning pero no error.
	struct checkTask_findCorruptedFxFrames
	(
		id = lb.totalChecker.rollMain.TCH_findCorruptedFxFrames , --id de la tarea
		name = "Frames: Comprobación de frames de fx corruptos.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_findMissingFxFrames), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			if maxFiles.count == 0 then
			(
				maxFiles = getFiles(path + @"render\*renderFx_*")
				maxFilesInfo = for mf in maxFiles collect getFileInfo mf
			)
			
			struct graphVariation
			(
				ramp = false,
				valley = false,
				frames = #()
			)
		
			--Primero sacaremos los outputs de los pases y los rangos de los pases
			for i=1 to maxFiles.count do
			(
				_passesOutputs = getFileInfoLPMPassesOutputs maxFiles[i] info:maxFilesInfo[i]
				_passesRanges = getFileInfoLPMPassesRenderRange maxFiles[i] info:maxFilesInfo[i]
				_passesNames = getFileInfoLPMpasses maxFiles[i] info:maxFilesInfo[i]
				
				--Ahora recorreremos todos los pases
				for j=1 to _passesOutputs.count do
				(
		-- 						print _passesNames[j]
					if matchpattern _passesOutputs[j] pattern:"\\\\lbdata001\\z\\*" then
						_passesOutputs[j] = substituteString (tolower _passesOutputs[j]) "\\\\lbdata001\\z\\" "z:\\"
					
		-- 						print _passesOutputs[j]
					
					--Sacaremos el tamaño medio de todos los archivos por pase y miraremos si hay alguno que se va mucho de tamaño a la baja.
					_passFiles = getFiles ((filterString _passesOutputs[j] ".")[1] + "*." +  (filterString _passesOutputs[j] ".")[2])
					_totalSize = 0
					
					/*--En este bucle saco el tamaño total de todos los frames
					for k=1 to _passFiles.count do
						_totalSize += (getFileSize _passFiles[k])
					
					--Obtengo la media y la tolerancia
					_avgSize = _totalSize / _passFiles.count*/
					_variation = 0.5
					_variations = #()
					_currentVariation = #()
					_increments = 0
					_decrements = 0
					_valley = undefined
					_novariation = true
					
					--Si hay un solo frame o no hay no miraré la variación.
					if _passFiles.count <= 1 then
						_novariation = false
					
					for k=1 to _passFiles.count do
					(
						_currentSize = getFileSize _passFiles[k]
						
						--Primero miraremos las variaciones, siempre miraremos el anterior.
						if k > 1 then
						(
							_lastSize = getFileSize _passFiles[k-1]
							
							--En cuanto los tamaños son distintos, ya habrá variación.
							if _currentSize != _lastSize then
								_novariation = false
							
							--Si se supera la variación que hemos definido
							if abs (_currentSize - _lastSize) > (_lastSize * _variation) then
							(
								if _currentSize < _lastSize then
								(
									_decrements += 1
									if _valley == undefined then
										_valley = true
								)
								else
								(
									_increments += 1
									if _valley == undefined then
										_valley = false
								)
							)
							
							--Si hay ya incrementos o decrementos añadimos el siguiente por si es meseta.
							if _increments > 0 or _decrements > 0 then
								append _currentVariation _passFiles[k]
							
							--Si hay una subida y una bajada es una meseta o un pico
							if _increments == 1 and _decrements == 1 then
							(
								--Si es un pico solo habrá 2 elementos en el array (el de la primera variación brusca y el actual que sería el de bajada)
								if _currentVariation.count == 2 then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									append _peak.frames _currentVariation[1]
									append _variations _peak 
									_valley = undefined
									_increments = 0
									_decrements = 0
								)
								--En esta caso será una meseta
								else
								(
									deleteItem _currentVariation _currentVariation.count
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									_mesa.frames = _currentVariation
									append _variations _mesa
									_valley = undefined
									_increments = 0
									_decrements = 0
								)
							)
							--Si hay varias subidas seguidas y una bajada entonces será una rampa de subida seguida de un pico o una meseta.
							else if _increments > 1 and _decrements == 1 then
							(
								--Lo que haremos será poner en la rampa todos los frames de subida
								_ramp = graphVariation()
								_ramp.ramp = true
								_ramp.valley = _valley
								
								for l=1 to _increments do
									append _ramp.frames _currentVariation[l]
								
								append _variations _ramp
								
								--Si hay tantos frames almacenados como incrementos y decrementos sumados entonces tendremos un pico tras la rampa
								if _currentVariation.count == (_increments + _decrements) then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									--Luego como pico el último frame de subida
									append _peak.frames _currentVariation[_increments]
									append _variations _peak
								)
								--En este caso tendremos una meseta tras la rampa
								else
								(
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									for l=_increments to (_currentVariation.count - _decrements) do
										append _mesa.frames _currentVariation[l]
									append _variations _mesa
								)
								
								--Si es el último frame entonces apilaremos el último como un pico.
								if k == _passFiles.count then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									append _peak.frames _currentVariation[_currentVariation.count]
									append _variations _peak
									
									_currentVariation = #()
									_increments = 0
									_decrements = 0
									_valley = undefined
								)
								else
								(
									--Por último incluiremos el ultimo frame como un descenso y dejaremos el incremento a cero
									--el decremento no lo tocaremos porque estará a 1
									_increments = 0
									_valley = true
									_currentVariation = #(_currentVariation[_currentVariation.count])										
								)
							)
							--Si hay varias subidas seguidas y una bajada entonces será una rampa de subida seguida de un pico o una meseta.
							else if _decrements > 1 and _increments == 1 then
							(
								--Lo que haremos será poner en la rampa todos los frames de subida
								_ramp = graphVariation()
								_ramp.valley = _valley
								_ramp.ramp = true
								
								for l=1 to _decrements do
									append _ramp.frames _currentVariation[l]
								
								append _variations _ramp
								
								--Si hay tantos frames almacenados como incrementos y decrementos sumados entonces tendremos un pico tras la rampa
								if _currentVariation.count == (_increments + _decrements) then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									--Luego como pico el último frame de subida
									append _peak.frames _currentVariation[_decrements]
								)
								--En este caso tendremos una meseta tras la rampa
								else
								(
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									for l=_decrements to (_currentVariation.count - _increments) do
										append _mesa.frames _currentVariation[l]
									append _variations _mesa
								)
								
								--Si es el último frame entonces apilaremos el último como un pico.
								if k == _passFiles.count then
								(
									_peak = graphVariation()
									_peak.valley = _valley
									append _peak.frames _currentVariation[_currentVariation.count]
									_currentVariation = #()
									_increments = 0
									_decrements = 0
									_valley = undefined
								)
								else
								(
									--Por último incluiremos el ultimo frame como un descenso y dejaremos el incremento a cero
									--el decremento no lo tocaremos porque estará a 1
									_decrements = 0
									_valley = false
									_currentVariation = #(_currentVariation[_currentVariation.count])
								)
							)
							--Si tenemos una subida continuada y no hay decrementos puede que tengamos una rampa, luego una meseta y otra subida.
							else if _increments > 1 and _decrements == 0 then
							(
								--Si el numero de subidas es inferior al numero de frames eso quiere decir que enmedio de la rampa hay una meseta
								if _currentVariation.count > _increments then
								(
									--Si hay mas de dos entonces tendremos una rampa antes de la meseta.
									if _increments > 2 then
									(
										_ramp = graphVariation()
										_ramp.valley = _valley
										_ramp.ramp = true
										
										--Primero entonces apilaremos la bajada en las rampas.
										for l=1 to _increments-1 do
											append _ramp.frames _currentVariation[l]
										
										append _variations _ramp
									)
									
									--En todos los casos habrá una meseta (porque entre los incrementos hay frames que no han variado)
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									
									for l=(_increments-1) to (_currentVariation.count-1) do
										append _mesa.frames _currentVariation[l]
									append _variations _mesa
									
									_currentVariation = #(_currentVariation[_currentVariation.count])
									_increments = 1
									
									--Si es el último frame entonces sacaremos una meseta y el último como un pico.
									if k == _passFiles.count then
									(
										_peak = graphVariation()
										_peak.valley = _valley
										_peak.frames = _currentVariation
										
										append _variations _peak
										_currentVariation = #()
										_increments = 0
										_valley = undefined
									)
								)--else if _increments > 1 and _decrements == 0 then
								--Caso para el de una subida continuada.
								else if _increments == _currentVariation.count then
								(
									--Si es el último frame entonces apilaremos toda la rampa y fuera
									if k == _passFiles.count then
									(
										_ramp = graphVariation()
										_ramp.valley = _valley
										_ramp.ramp = true
										_ramp.frames = _currentVariation
										append _variations _ramp
										
										_currentVariation = 0
										_increments = 0 
										_valley = undefined
									)
								)-- else if _increments == _currentVariation.count then
								else
								(
									print "ERROR: Si el software llega a este punto es que hay algo mal en el cálculo de incrementos/decrementos.\n"
									print "ERROR: No puede haber un número de incrementos o decrementos mayor que el de frames almacenados como incrementados.\n"
								)--if _currentVariation.count > _increments then
							)--else if _increments > 1 and _decrements == 0
							--Si tenemos una bajada continuada y no hay incrementos puede que tengamos una rampa, luego una meseta y otra subida.
							else if _decrements > 1 and _increments == 0 then
							(
								--Si el numero de bajadas es inferior al numero de frames eso quiere decir que enmedio de la rampa hay una meseta
								if _currentVariation.count > _decrements then
								(
									--Si hay mas de dos entonces tendremos una rampa antes de la meseta.
									if _decrements > 2 then
									(
										_ramp = graphVariation()
										_ramp.valley = _valley
										_ramp.ramp = true
										
										--Primero entonces apilaremos la bajada en las rampas.
										for l=1 to _decrements-1 do
											append _ramp.frames _currentVariation[l]
										
										append _variations _ramp
									)
									
									--En todos los casos habrá una meseta (porque entre los descensos hay frames que no han variado)
									_mesa = graphVariation()
									_mesa.valley = _valley
									_mesa.ramp = false
									
									for l=(_decrements-1) to (_currentVariation.count-1) do
										append _mesa.frames _currentVariation[l]
									append _variations _mesa
									
									_currentVariation = #(_currentVariation[_currentVariation.count])
									_decrements = 1
									
									--Si es el último frame entonces sacaremos una meseta y el último como un pico.
									if k == _passFiles.count then
									(
										_peak = graphVariation()
										_peak.valley = _valley
										_peak.frames = _currentVariation
										
										append _variations _peak
										_currentVariation = #()
										_decrements = 0
										_valley = undefined
									)
								)--if _currentVariation.count > _decrements then
								--Caso para el de una bajada continuada.
								else if _decrements == _currentVariation.count then
								(
									--Si es el último frame entonces apilaremos toda la rampa y fuera
									if k == _passFiles.count then
									(
										_ramp = graphVariation()
										_ramp.valley = _valley
										_ramp.ramp = true
										_ramp.frames = _currentVariation 
										append _variations _ramp
										
										_currentVariation = 0
										_decrements = 0 
										_valley = undefined
									)
								)
								else
								(
									print "ERROR: Si el software llega a este punto es que hay algo mal en el cálculo de incrementos/decrementos.\n"
									print "ERROR: No puede haber un número de incrementos o decrementos mayor que el de frames almacenados como incrementados.\n"
								)--if _currentVariation.count > _decrements then
							)--else if _decrements > 1 and _increments == 0
						)-- if k > 1 then
					)-- for k=1 to _passFiles.count do
					
					--Si no hay variación entre frames entonces
					if _novariation then
					(
						_fail = true
					)
					
					--Si hay variaciones entonces guardaremso información en el log
					if _variations.count > 0 then
					(
						_fail = true
						log += "*********************************** PASE: " + _passesNames[j] + " *****************************************\n"
						for k=1 to _variations.count do
						(
							_direction = ""
							if _variations[k].valley then _direction = "descenso" else _direction = "aumento"
								
							if _variations[k].frames.count == 1 then
							(
								log += "(PICO) Hay un " + _direction + " significativo de tamaño en el frame: " + (getFilenameFile _variations[k].frames[1])  + (getFileNameType _variations[k].frames[1]) + "\n\n"
							)
							else
							(
								if _variations[k].ramp then
								(
									log += "(RAMPA) Hay un " + _direction + " significativo de tamaño en el rango de frames [ " + (filterString (getFilenameFile _variations[k].frames[1]) "_")[6]
									log += " - " + (filterString (getFilenameFile _variations[k].frames[_variations[k].frames.count]) "_")[6] + " ]\n\n"
								)
								else
								(
									log += "(MESETA) Un grupo de frames experimenta un " + _direction + " significativo de tamaño, son los pertenecientes al rango: [ " + (filterString (getFilenameFile _variations[k].frames[1]) "_")[6]
									log += " - " + (filterString (getFilenameFile _variations[k].frames[_variations[k].frames.count]) "_")[6] + " ]\n\n"
								)
							)
							
						)
					)
					else
					(
						--Si no hay variación entre frames entonces
						if _novariation then
						(
							_fail = true
							log += "*********************************** PASE: " + _passesNames[j] + " *****************************************\n\n"
							log += "Este pase tiene todos los frames del mismo tamaño, es probable que haya salido todo corrupto o en negro."
						)
						
					)
					
					
				)--for j=1 to _passesOutputs.count do
			)-- for i=1 to maxFiles.count do
			
			
			if _fail then --si falla añade informacion de ayuda y warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los frames renderizados pueden tener frames corruptos que se pueden detectar en función de variaciones bruscas de tamaño.\n"
				log += "Este check es orientativo e indica que cambios bruscos nos podemos encontrar en los tamaños de los frames renderizados.\n"
				log += "Leyenda:\n"
				log += "PICO: un frame varía bruscamente de tamaño respecto de su predecesor y su siguiente.\n"
				log += "Esto puede indicar un frame en negro entre otros que no lo son (ejemplo).\n"
				log += "MESETA: un grupo de frames de similar tamaño entre sí varían de tamaño respecto a los demás de alrededor.\n"
				log += "Esto puede indicar un grupo de frames corruptos.\n"
				log += "RAMPA: dos o más frames forman parte de un brusco cambio de tamaño entre ellos y los que tienen alrededor.\n"
				log += "Esto pueden ser frames corruptos con partes en negro cada vez más grandes.\n"
				log += "Todas estas denominaciones pueden responder a causas lógicas dentro de una escena como aparición/desaparición de elementos en cámara \n"
				log += "animados a mucha velocidad o una escena inicialmente a oscuras que de repente tiene una luz encendida.\n"
				log += "Por ello este check es ORIENTATIVO y todo lo que indica son estimaciones.\n"
				log += "**************************************************************************************\n\n"
			)--if
		
		)--executeFN
	)--checkTask_findCorruptedFxFrames
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que los frames de una secuencia no estén corruptos, sacará warning pero no error.
	struct checkTask_findReferenceFrames
	(
		id = lb.totalChecker.rollMain.TCH_findReferenceFrames, --id de la tarea
		name = "Frames: Un frame de referencia por capa.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			
			--obtiene los archivos
			_filesPath = (path + @"render\*render*")
			
			if maxfiles.count == 0 then maxfiles = getFiles (_filesPath + ".max")
			
			
			--Primero sacaremos los outputs de los pases y los rangos de los pases 
			for i=1 to maxFiles.count do
			(
				
				_passesNames = getFileInfoLPMpasses maxFiles[i] info:maxFilesInfo[i]
				_passesOutputs = getFileInfoLPMPassesOutputs maxFiles[i] info:maxFilesInfo[i] 
				
				--Si tenemos extrainfo de outputs
				if _passesOutputs.count != 0 then
				(
					if tolower (filterString _passesOutputs[1] "\\")[1] != "lbdata002" then
						--Ahora montaremos la ruta de los pases de referencia y el wildcard del frame
						_refPath = (getFilenamePath (substituteString (tolower _passesOutputs[1]) "lbdata001" "lbdata002")) + "ref\\"
					else
						_refPath = (getFilenamePath _passesOutputs[1]) + "ref\\"
					
					--Si existe la carpeta de referencias seguiremos
					if doesFileExist _refPath then
					(
						_firstFail = true
						--Ahora recorreremos todos los pases
						for j=1 to _passesNames.count do
						(
							if tolower (filterString _passesOutputs[1] "\\")[1] != "lbdata002" then
								--De manera preventiva sustituiremos lbdata001 por lbdata002
								_passesOutputs[j] = substituteString (tolower _passesOutputs[j]) "lbdata001" "lbdata002"
							
							--Montaremos wildcard del frame
							_frameWildcard = getFilenameFile (_passesOutputs[j]) + "*.*"
							
							--Ahora haremos un findString de cada output de cada pase en el fichero de referencias, y si no obtenemos nada daremos error
							_refFrames = getFiles(_refPath + _frameWildcard)
							
							
							--Si no hay frames de referencia entonces daremos error
							if _refFrames.count == 0 then
							(
								_fail = true
								if _firstFail then
								(
									log += "**ARCHIVO <" + maxFiles[i] + ">\n"
									_firstFail = false
								)
								log += "PASE: " + _passesNames[j] + "\n"
								log += "Error: El pase <" + _passesNames[j] + "> no tiene frames de referencia sacados.\n"
								log += "El frame de esta capa deberá llamarse así:\n"
								log += getFilenameFile (_passesOutputs[j]) + "XXXX.png ó .tiff \n\n"
							)
						)-- for j=1 to _passesRanges.count do
					) --if doesFileExist _refPath
					else
					(
						_fail = true
						log += "La carpeta de referencias " + _refPath + " no está creada."
					)
				)-- if _passesOutputs != #() then
				else
				(
					if not _fail then
					(
						_warning = true
					)
					log += "**ARCHIVO <" + maxFiles[i] + ">\n"
					log += "Warning: El archivo <" + (filenameFromPath maxFiles[i]) + "> no tiene informacion de capas de LPM, puede que la información extra sea antigua, esté corrupta o el archivo no tenga capas de LPM. La comprobación de si faltan frames por renderizar, se debe hacer a mano o se debe resalvar el archivo .max para que se almacene la información correcta.\n\n"
				)
				
			)
			
			if _warning then
				state = warningMessage
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Las capas tienen que tener frames en la carpeta de referencias de su cámara.\n"
				log += "Ejemplo: \\\\lbdata002\\Z\\frame\\seq_XXX\\cam\\camYYY\\ref\n"
				log += "**************************************************************************************\n\n"
			)--if

		)--executeFN
	)--checkTask_findRefereneFrames
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que haya frames de render en la carpeta de los frames de la cámara
	struct checkTask_framesInCamFolderExist
	(
		id = lb.totalChecker.rollMain.TCH_framesInCamFolderExist, --id de la tarea
		name = "Frames: Hay frames de render en la carpeta de la cámara.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = (substituteString (filterString path "\\_")[6] "cam" "")
			
			_framesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			_framesWildcard = "seq_" + _seqNumber + "_cam" + _camNumber + "_render_*.*"
			
			_files = getFiles (_framesPath + _framesWildcard)
			
			if _files.count == 0 then 
			(
				log += "ERROR: No hay frames en la carpeta " + _framesPath + "\n\n"
				_fail = true
			)
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de render tienen que tener al menos un frame en su carpeta de cámara en lbdata002:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\cam_YYY\\ \n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInCamFolderExist
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Hay frames de renderFx en la carpeta de la cámara
	struct checkTask_fxFramesInCamFolderExist
	(
		id = lb.totalChecker.rollMain.TCH_fxFramesInCamFolderExist, --id de la tarea
		name = "Frames: Hay frames de renderFx en la carpeta de la cámara.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = (substituteString (filterString path "\\_")[6] "cam" "")
			
			_framesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			_framesWildcard = "seq_" + _seqNumber + "_cam" + _camNumber + "_renderFx_*.*"
			
			_files = getFiles (_framesPath + _framesWildcard)
			
			if _files.count == 0 then 
			(
				log += "ERROR: No hay frames en la carpeta " + _framesPath + "\n\n"
				_fail = true
			)
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de renderFx tienen que tener al menos un frame en su carpeta de cámara en lbdata002:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\cam_YYY\\ \n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_fxFramesInCamFolderExist
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que haya frames de render en la carpeta ref de la cámara
	struct checkTask_framesInRefFolderExist
	(
		id = lb.totalChecker.rollMain.TCH_framesInRefFolderExist, --id de la tarea
		name = "Frames: Hay frames de render en la carpeta de referencia de la cámara.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = (substituteString (filterString path "\\_")[6] "cam" "")
			
			_framesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\ref\\"
			_framesWildcard = "seq_" + _seqNumber + "_cam" + _camNumber + "_render_*.*"
			
			_files = getFiles (_framesPath + _framesWildcard)
			
			if _files.count == 0 then 
			(
				log += "ERROR: No hay frames en la carpeta " + _framesPath + "\n\n"
				_fail = true
			)
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de render tienen que tener al menos un frame en su carpeta de cámara en lbdata002:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\cam_YYY\\ref\\ \n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInRefFolderExist
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que haya frames de render en la carpeta de los frames de la cámara
	struct checkTask_framesInCamNC
	(
		id = lb.totalChecker.rollMain.TCH_framesInCamNC, --id de la tarea
		name = "Frames: Frames de la carpeta de la cámara cumplen el Naming Convention.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_framesInCamFolderExist), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = (substituteString (filterString path "\\_")[6] "cam" "")
			
			_framesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			_framesWildcard = "*.*"
			
			_files = getFiles (_framesPath + _framesWildcard)
			--Miro si cumplen el naming convention de archivos de render para lpm viejo o nuevo.
			for j=1 to _files.count where tolower ((getFilenameFile _files[j]) + (getFilenameType _files[j])) != "thumbs.db" do
			(
				if not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:lb.nc.NC_seqFrameNamePattern\
				and not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:lb.nc.NC_seqFrameNameNewPattern do
				(
					log += "ERROR: " + (getFilenameFile _files[j]) + (getFilenameType _files[j]) + " no cumple el naming convention.\n\n"
					_fail = true
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los frames renderizados de la carpeta de la cámara tienen que cumplir el naming convention para este tipo de archivos:\n"
				log += "Carpeta donde mira el check: \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\\n"
				log += "Ejemplos:\n"
				log += "Frames sacados con la versión antigua de LPM --> " + lb.nc.NC_seqFrameNamePattern + "\n"
				log += "Frames sacados con la versión nueva de LPM --> "  + lb.nc.NC_seqFrameNameNewPattern +  "\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInCamNC
	-----------------------------------------------------------------------------------

	----------------------------------------------------------------------------------
	--Los frames de renderFx de la carpeta de la cámara cumplen el NC.
	struct checkTask_fxFramesInCamNC
	(
		id = lb.totalChecker.rollMain.TCH_fxFramesInCamNC, --id de la tarea
		name = "Frames: Los frames de renderFx de la carpeta de la cámara cumplen el NC.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = (substituteString (filterString path "\\_")[6] "cam" "")
			
			_framesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			_framesWildcard = "seq_" + _seqNumber + "_cam" + _camNumber + "_renderFx_*.*"
			
			_files = getFiles (_framesPath + _framesWildcard)
		-- 					print (_framesPath + _framesWildcard)
			--Miro si cumplen el naming convention de archivos de render para lpm viejo o nuevo.
			for j=1 to _files.count where tolower(filenameFromPath _files[j]) != "thumbs.db" do
			(
		-- 						print _files[j]
				if (filterString (getFilenameFile _files[j]) "_").count != 6 or (not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:lb.nc.NC_seqFrameFxNamePattern\
				and not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:lb.nc.NC_seqFrameFxNameNewPattern) do
				(
					log += "ERROR: " + (getFilenameFile _files[j]) + (getFilenameType _files[j]) + " no cumple el naming convention.\n\n"
					_fail = true
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los frames de Fx renderizados de la carpeta de la cámara tienen que cumplir el naming convention para este tipo de archivos:\n"
				log += "Carpeta donde mira el check: \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\\n"
				log += "Ejemplos:\n"
				log += "Frames de Fx sacados con la versión antigua de LPM --> " + lb.nc.NC_seqFrameFxNamePattern + "\n"
				log += "Frames de Fx sacados con la versión nueva de LPM --> "  + lb.nc.NC_seqFrameFxNameNewPattern +  "\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_fxFramesInCamNC
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--comprueba que haya frames de render en la carpeta de referencia de  los frames de la cámara
	struct checkTask_framesInRefNC
	(
		id = lb.totalChecker.rollMain.TCH_framesInRefNC, --id de la tarea
		name = "Frames: Los frames de la carpeta de ref de la cámara cumplen el NC.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_framesInRefFolderExist), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = (substituteString (filterString path "\\_")[6] "cam" "")
			
			_framesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\ref\\"
			_framesWildcard = "*.*"
			
			_files = getFiles (_framesPath + _framesWildcard)
			
			--Miro si cumplen el naming convention de archivos de render para lpm viejo o nuevo.
			for j=1 to _files.count where tolower((getFilenameFile _files[j]) + (getFilenameType _files[j])) != "thumbs.db" do
			(
				if not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:lb.nc.NC_seqFrameNamePattern\
				and not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:lb.nc.NC_seqFrameNameNewPattern do
				(
					log += "ERROR: " + (getFilenameFile _files[j]) + (getFilenameType _files[j]) + " no cumple el naming convention.\n\n"
					_fail = true
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los frames renderizados de la carpeta ref tienen que cumplir el naming convention para este tipo de archivos:\n"
				log += "Carpeta donde mira el check: \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ref\\\n"
				log += "Ejemplos:\n"
				log += "Frames sacados con la versión antigua de LPM --> " + lb.nc.NC_seqFrameNamePattern + "\n"
				log += "Frames sacados con la versión nueva de LPM --> "  + lb.nc.NC_seqFrameNameNewPattern +  "\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInRefNC
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Hay al menos un frame en la carpeta ref\final y cumple el naming convention.
	struct checkTask_framesInFinalRefExist
	(
		id = lb.totalChecker.rollMain.TCH_framesInFinalRefExist, --id de la tarea
		name = "Frames: Hay al menos un frame en la carpeta ref\\final y cumple el naming convention.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = (substituteString (filterString path "\\_")[6] "cam" "")
			
			_framesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\ref\\final\\"
			_framesWildcard = "ref-seq_" + _seqNumber + "_cam" + _camNumber + "_final_*.*"
			print (_framesPath + _framesWildcard)
			_files = getFiles (_framesPath + _framesWildcard)
			print _files.count
			--Flag para indicar que existe al menos uno que cumple el naming convention.
			_exist = false
			
			--Miro si cumplen el naming convention para frames de referencia al menos uno de ellos
			for j=1 to _files.count where ((getFilenameFile _files[j]) + (getFilenameType _files[j])) != "thumbs.db" do
			(
				if matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:lb.nc.NC_seqFrameRefFinalPattern do
				(
					_exist = true
				)
			)
			
			if not _exist then
			(
				log += "ERROR: La carpeta " + _framesPath + " no contiene ningún frame de referencia válido.\n\n"
				_fail = true
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los frames de referencia finales de la carpeta:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ref\\final \n"
				log += "Ha de tener al menos un frame que cumpla el patrón:\n"
				log += "ref-seq_XXX_camYYY_final_????.tif ó .tiff"+ "\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInFinalRefExist
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Tiene que haber al menos un frame de referencia de compo en camYYY/refComp/
	struct checkTask_refCompFramesExist
	(
		id = lb.totalChecker.rollMain.TCH_refCompFramesExist, --id de la tarea
		name = "Frames: Tiene que haber al menos un frame de referencia de compo en camYYY/refComp/.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			
			--obtiene los archivos
			_filesPath = (path + @"render\*render_*")
			
			_seqNumber = (filterString (filterString (path) "\\")[3] "_")[2]
			_camNumber = (substituteString (filterString (path) "\\")[5] "cam" "")
			
			_framesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\refComp\\"
			_framesWildcard = "refComp-seq_" + _seqNumber + "_cam" + _camNumber + "_final_????.tif*"
			
			_files = getFiles (_framesPath + _framesWildcard)
			
			if _files.count == 0  then
			(
				log += "ERROR: La carpeta " + _framesPath + " no contiene ningún frame de referencia de compo válido.\n\n"
				_fail = true
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los frames de referencia finales de compo de la carpeta:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\refComp\\ \n"
				log += "Ha de tener al menos un frame que cumpla el patrón:\n"
				log += "refComp-seq_XXX_camYYY_final_????.tif ó .tiff"+ "\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_refCompFramesExist
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Hay al menos un frame en la carpeta ref\final y cumple el naming convention.
	struct checkTask_framesMatchCamAndSeq
	(
		id = lb.totalChecker.rollMain.TCH_framesMatchCamAndSeq, --id de la tarea
		name = "Frames: Los frames de cam, ref y ref//final coinciden con la cámara y secuencia de la ruta.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_framesInCamNC, lb.totalChecker.rollMain.TCH_framesInRefNC), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			
			--obtiene los archivos
			_filesPath = (path + @"render\*render_*")
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" "" 
			
			--Obtengo todas las rutas				
			_cameraFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			_refFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\ref\\"
			_refFinalFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\ref\\final\\"
			
			
			----Ahora analizaremos la carpeta de la cámara----
			--Primero saco los archivos de con el patron de frames viejos
			_files = getFiles (_cameraFramesPath + lb.nc.NC_seqFrameNamePattern)
			
			--Luego los del patron de frames nuevos.
			_files += getFiles (_cameraFramesPath + lb.nc.NC_seqFrameNameNewPattern)
			
			_files = makeUniqueArray _files
			
			--Flag que se activa con el primer error de cada capa y así poder poner el título.
			_error = false
			
			--Miro si cumplen el naming convention para frames de referencia al menos uno de ellos
			for j=1 to _files.count where ((getFilenameFile _files[j]) + (getFilenameType _files[j])) != "thumbs.db" do
			(
				if not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:("seq_"+_seqNumber+"_cam"+_camNumber+"_*") do
				(
					if not _error then
						log += "\n******* Carpeta: " + _cameraFramesPath + " *********\n"
					
					log += "ERROR: El frame " + _files[j] + " no pertenece a esta cámara y/o secuencia.\n\n"
					_fail = true
					_error = true
				)
			)
			
			----Ahora analizaremos la carpeta de referencia de la cámara----
			_error = false
			
			--Primero saco los archivos de con el patron de frames viejos
			_files = getFiles (_refFramesPath + lb.nc.NC_seqFrameNamePattern)
			
			--Luego los del patron de frames nuevos.
			_files += getFiles (_refFramesPath + lb.nc.NC_seqFrameNameNewPattern)
			
			--Miro si cumplen el naming convention para frames de referencia al menos uno de ellos
			for j=1 to _files.count where ((getFilenameFile _files[j]) + (getFilenameType _files[j])) != "thumbs.db" do
			(
				if not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:("seq_"+_seqNumber+"_cam"+_camNumber+"_*") do
				(
					if not _error then
						log += "\n******* Carpeta: " + _refFramesPath + " *********\n"
					
					log += "ERROR: El frame " + _files[j] + " no pertenece a esta cámara y/o secuencia.\n\n"
					_fail = true
					_error = true
				)
			)
			
			
			----Por último miraremos la carpeta de ref/final----
			_error = false
			
			--Primero saco los archivos de con el patron de frames viejos
			_files = getFiles (_refFinalFramesPath + lb.nc.NC_seqFrameRefFinalPattern)
			
			--Miro si cumplen el naming convention para frames de referencia al menos uno de ellos
			for j=1 to _files.count where ((getFilenameFile _files[j]) + (getFilenameType _files[j])) != "thumbs.db" do
			(
				if not matchPattern ((getFilenameFile _files[j]) + (getFilenameType _files[j])) pattern:("ref-seq_"+_seqNumber+"_cam"+_camNumber+"_*") do
				(
					if not _error then
						log += "\n******* Carpeta: " + _refFinalFramesPath + " *********\n"
					
					log += "ERROR: El frame " + _files[j] + " no pertenece a esta cámara y/o secuencia.\n\n"
					_fail = true
					_error = true
				)
			)
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba que los frames se corresponden con la secuencia\n"
				log += " y cámara de las siguientes carpetas:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ \n\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ref\\ \n\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ref\\final\\ \n\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesMatchCamAndSeq
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--Hay al menos un frame en la carpeta ref\final y cumple el naming convention.
	struct checkTask_fxFramesSeqAndCamOk
	(
		id = lb.totalChecker.rollMain.TCH_fxFramesSeqAndCamOk, --id de la tarea
		name = "Frames: Los frames de renderFx en cam coinciden con la cámara y secuencia de la ruta.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			
			--obtiene los archivos
			_filesPath = (path + @"render\*renderFx_*")
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" "" 
			
			--Obtengo todas las rutas				
			_cameraFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
		
			
			----Ahora analizaremos la carpeta de la cámara----
			--Primero saco los archivos de con el patron de frames viejos
			_files = getFiles (_cameraFramesPath + lb.nc.NC_seqFrameFxNamePattern)
			
			--Luego los del patron de frames nuevos.
			_files += getFiles (_cameraFramesPath + lb.nc.NC_seqFrameFxNameNewPattern)
			
			_files = makeUniqueArray _files
			
			--Flag que se activa con el primer error de cada capa y así poder poner el título.
			_error = false
			
			--Miro si cumplen el naming convention para frames de referencia al menos uno de ellos
			for j=1 to _files.count where (tolower (filenameFromPath _files[j])) != "thumbs.db" do
			(
		-- 					print _files[j] 
				if not matchPattern (filenameFromPath _files[j]) pattern:("seq_"+_seqNumber+"_cam"+_camNumber+"_*") do
				(
					if not _error then
						log += "\n******* Carpeta: " + _cameraFramesPath + " *********\n"
					
					log += "ERROR: El frame " + _files[j] + " no pertenece a esta cámara y/o secuencia.\n\n"
					_fail = true
					_error = true
				)
			)
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba que los frames de fx se corresponden con la secuencia\n"
				log += " y cámara en esta carpeta:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ \n\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesMatchCamAndSeq
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Los frames de cam y ref vienen de capas existentes en el archivo .max
	struct checkTask_framesInCamAndRefHaveLayer
	(
		id = lb.totalChecker.rollMain.TCH_framesInCamAndRefHaveLayer, --id de la tarea
		name = "Frames: Los frames de cam y ref vienen de capas existentes en el archivo .max", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			if maxFiles.count == 0 then
			(
				maxFiles = getFiles(path + @"render\*render_*")
				maxFilesInfo = for mf in maxFiles collect getFileInfo mf
			)
			
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" "" 
			
			--Obtengo todas las rutas				
			_cameraFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			_refFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\ref\\"
			
			_passesOutputs = #()
			
			--Recorro los archivos y cojo sus patterns de frames
			for i=1 to maxFiles.count do
			(
				_passesOutputs += getFileInfoLPMpassesOutputs maxFiles[i] file:maxFilesInfo[i]
			)
			
			_passesOutputs = makeUniqueArray _passesOutputs
			
			--Primero repasaré la carpeta de frames
			_files = getFiles(_cameraFramesPath + "*.*")
			
			--Me creo un flag que se activa cuando hay un error por primera vez para poner el título.
			_error = false
			for i=1 to _files.count where tolower(filenamefrompath _files[i]) != "thumbs.db" and not matchPattern (getFilenameFile _files[i]) pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_renderFx_*") do
			(	
				_hasMatch = false
				for j=1 to _passesOutputs.count do
				(
					--Modificamos el patrón para poder hacer el pase
					_pattern = (getFilenameFile _passesOutputs[j]) + "????" + (getFilenameType _passesOutputs[j])
					if matchPattern ((getFilenameFile _files[i]) + (getFilenameType _files[i])) pattern:_pattern then
						_hasMatch = true
				)
				
				if not _hasMatch then
				(
					if not _error then
					(
						_error = true
						log += "********************* CARPETA " + _cameraFramesPath + " ************************\n\n"
					)
					
					log += "ERROR: " + (getFilenameFile _files[i]) + (getFilenameType _files[i]) + " no pertenece a ninguna capa de ningún archivo .max de la cámara.\n\n"
					_fail = true
				)
			)
			
			--Ahora toca la carpeta de frames de referencia.
			_files = getFiles(_refFramesPath + "*.*")
			
			--Me creo un flag que se activa cuando hay un error por primera vez para poner el título.
			_error = false
			for i=1 to _files.count where (tolower (filenamefrompath _files[i])) != "thumbs.db" and not matchPattern (getFilenameFile _files[i]) pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_renderFx_*")  do
			(	
				_hasMatch = false
				for j=1 to _passesOutputs.count do
				(
					--Modificamos el patrón para poder hacer el pase
					_pattern = (getFilenameFile _passesOutputs[j]) + "????" + (getFilenameType _passesOutputs[j])
					if matchPattern ((getFilenameFile _files[i]) + (getFilenameType _files[i])) pattern:_pattern then
						_hasMatch = true
				)
				
				if not _hasMatch then
				(
					if not _error then
					(
						_error = true
						log += "********************* CARPETA " + _refFramesPath + " ************************\n\n"
					)
					
					log += "ERROR: " + (getFilenameFile _files[i]) + (getFilenameType _files[i]) + " no pertenece a ninguna capa de ningún archivo .max de la cámara.\n\n"
					_fail = true
				)
			)
			
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba en estas dos carpetas:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ \n\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ref\\ \n\n"
				log += "Que todos los frames que contienen pertenecen a alguna capa de LPM de los archivos de render de la cámara.\n\n"
				log += "Lo que quiere decir que si hay un frame cuya capa no existe en ningun archivo .max este check dará error.\n\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInCamFolderExistInComp
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Frames: Los frames de renderFx en cam vienen de capas existentes en el archivo .max
	struct checkTask_fxFramesInCamHaveLayer
	(
		id = lb.totalChecker.rollMain.TCH_fxFramesInCamHaveLayer, --id de la tarea
		name = "Frames: Los frames de renderFx en cam vienen de capas existentes en el archivo .max", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			if maxFiles.count == 0 then
			(
				maxFiles = getFiles(path + @"render\*renderFx_*")
				maxFilesInfo = for mf in maxFiles collect getFileInfo mf
			)
			
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" "" 
			
			--Obtengo todas las rutas				
			_cameraFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			
			_passesOutputs = #()
			
			--Recorro los archivos y cojo sus patterns de frames
			for i=1 to maxFiles.count do
			(
				_passesOutputs += getFileInfoLPMpassesOutputs maxFiles[i] file:maxFilesInfo[i]
			)
			
			_passesOutputs = makeUniqueArray _passesOutputs
			
			--Primero repasaré la carpeta de frames
			_files = getFiles(_cameraFramesPath + "*.*")
			
			--Me creo un flag que se activa cuando hay un error por primera vez para poner el título.
			_noMatch = #()
			for i=1 to _files.count where tolower(filenamefrompath _files[i]) != "thumbs.db" and not matchPattern (getFilenameFile _files[i]) pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_render_*") do
			(	
				_hasMatch = false
				for j=1 to _passesOutputs.count do
				(
					--Modificamos el patrón para poder hacer el pase
					_pattern = (getFilenameFile _passesOutputs[j]) + "????" + (getFilenameType _passesOutputs[j])
					if matchPattern ((getFilenameFile _files[i]) + (getFilenameType _files[i])) pattern:_pattern then
						_hasMatch = true
				)
				
				if not _hasMatch then
					append _noMatch _files[i]
			)
			
			for i=1 to _noMatch.count do
			(
				--Si tienen las 4 últimas cifras numéricas las sustituiremos por ####
				if lb.math.isNumeric (substring(getFilenameFile _noMatch[i]) ((getFilenameFile _noMatch[i]).count - 3) (getFilenameFile _noMatch[i]).count) then
					_noMatch[i] = (getFilenamePath _noMatch[i]) + (substring(getFilenameFile _noMatch[i]) 1 ((getFilenameFile _noMatch[i]).count - 4)) + "####" +  (getFilenameType _noMatch[i])
			)
			
			_noMatch = makeUniqueArray _noMatch
			
			for i=1 to _noMatch.count do
			(
				log += "ERROR: <" + _noMatch[i] + "> no pertenece a ninguna capa de LPM de ningún archivo de renderFx .max de esta secuencia y cámara.\n\n"
				_fail = true
			)
			
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba en esta carpeta:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ \n"
				log += "Que todos los frames de renderFx que contienen pertenecen a alguna capa de LPM de los archivos de renderFx de la cámara.\n\n"
				log += "Lo que quiere decir que si hay un frame cuya capa no existe en ningun archivo .max este check dará error.\n\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_fxFramesInCamHaveLayer
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Los frames de la carpeta cam se leen desde algun archivo  nuke o fusion
	struct checkTask_framesInCamFolderExistInComp
	(
		id = lb.totalChecker.rollMain.TCH_framesInCamFolderExistInComp, --id de la tarea
		name = "Frames: Los frames de la carpeta cam se leen desde algun archivo nuke o fusion.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" ""
			
			--Obtengo la ruta del archivo de post				
			_postPath = "z:\\sequence\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\post\\"
			
			
			--Obtendré primero los readers de nuke y fusion.
			-------------------------------------------------------------------------------
			
			if doesFileExist (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_post_v01.comp")) then
			(
				_currentPostFile = (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_post_v01.comp"))
			)
			else if doesFileExist (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_post_v01.nk")) then
			(
				_currentPostFile = (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_post_v01.nk"))
			)
			else
				_currentPostFile = ""
			
			
			if _currentPostFile != "" then
			(
				--inicializa los arrays de informacion para ese archivo
				_postIptsNames = #()
				_postIpts = #()
				
				if getFilenameType _currentPostFile == ".comp" then
				(
					--FUSION
					--obtiene los reader de nuke, su nombre y su input					
					
					--estados de busqueda
					_searchState = #loader
					--#loader --buscando nodos loader
					--#filename --buscando el input del loader
					
					_f = openfile _currentPostFile mode:"r" --abre el archivo de fusion en modo lectura
					
					while not eof _f do --recorre el archivo hasta el final
					(
						_l = readLine _f
						
						case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
						(
							#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
							(
								if findString _l " = Loader {" != undefined then
								(
									_searchState = #filename
									
									_name = substituteString _l " = Loader {" ""
									_name = substituteString _name "	" ""
									
									append _postIptsNames _name --añade el nombre al array
								)
							)--#loader
							
							#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
							(
								if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
								(
									_searchState = #loader
									
									_path = (filterString _l "\"")[2]
									_path = substituteString _path "\\\\" "\\"
									
									_fParts = filterString (getFileNameFile _path) "_"
									if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
									
									append _postIpts _path
								)
							)--#filename							
						)--case ESTADOS						
					)--while not eof
					
					close _f
				)
				else
				(
					-------------------------------------------------------------------------------
					
					-------------------------------------------------------------------------------
					--NUKE
					--obtiene los reader de nuke, su nombre y su input
					
					--estados de busqueda
					_searchState = #read
					--#read --buscando nodos read
					--#file --buscando el input del read
					--#name --buscando el nombre del nodo read
										
					_f = openfile _currentPostFile mode:"r" --abre el archivo de nuke en modo lectura
					
					while not eof _f do --recorre el archivo hasta el final
					(
						_l = readLine _f
						
						case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
						(
							#read: --ESTADO DE BUSQUEDA DE NODO READ
							(
								if findString _l "Read {" != undefined then _searchState = #file
							)--#read
							
							#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
							(
								if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
								(
									_searchState = #name
									
									_path = substituteString _l " file " ""
									_path = substituteString _path "/" "\\"
									
									_path = substituteString _path "Ã±" "ñ"
									
									if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
									
									_fParts = filterString (getFileNameFile _path) "_"
									if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
									else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
									
									append _postIpts _path
								)
							)--#file
							
							#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
							(
								if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
								(
									_searchState = #read
									
									_name = substituteString _l " name " ""
										
									append _postIptsNames _name --añade el name al array
								)
							)--#name
						)--case ESTADOS						
					)--while not eof
					
					close _f
					
					-------------------------------------------------------------------------------
				)
				
				--Sacaremos la ruta de lbdata001 2 de los archivos de cámara.
				_cameraFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
				_renderFrames = "seq_" + _seqNumber + "_cam" + _camNumber + "_render_*.*"
				
				_filePasses = getFiles (_cameraFramesPath + _renderFrames)
				
				for i=1 to _filePasses.count do
				(
					_filePasses[i] = (getFilenamePath _filePasses[i]) + (subString (getFilenameFile _filePasses[i]) 1 ((getFilenameFile _filePasses[i]).count - 4)) + "????" + (getFilenameType _filePasses[i])
				)
				
				_filePasses = makeUniqueArray _filePasses
				
				for i=1 to _filePasses.count do
				(
		-- 						print _filePasses[i]
					_found = false
					for j=1 to _postIpts.count do
					(
						if matchPattern _postIpts[j] pattern:_filePasses[i] then
							_found = true
					)
					
					if not _found then
					(
						_fail = true
						log += "ERROR: Los frames de la capa " + (filterString (filenameFromPath _filePasses[i]) "_")[5] + " no aparecen en ningún nodo de lectura de frames del archivo.\n" 
					)
				)
			)
			else
			(
				log += "ERROR: No encontramos ningún archivo de post válido para realizar este check, revise la carpeta de post.\n\n"
				_fail = true
			)
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba que los frames en \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\:\n"
				log += "Están presentes en los nodos de lectura de frames del archivo de post v01 (del departamento de iluminación)\n"
				log += "Dicho archivo podrá tomar dos nombres en función de si es de fusion o de nuke:\n"
				log += "FUSION: seq_xxx_camyyy_post_v01.comp\n"
				log += "NUKE: seq_xxx_camyyy_post_v01.nk\n\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInCamFolderExistInComp
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Los frames de la carpeta cam se leen desde algun archivo  nuke o fusion
	struct checkTask_framesInCamFolderExistInCompV2
	(
		id = lb.totalChecker.rollMain.TCH_framesInCamFolderExistInCompV2, --id de la tarea
		name = "Frames: Los frames de la carpeta cam se leen desde algun archivo nuke o fusion de compo.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" ""
			
			--Obtengo la ruta del archivo de post				
			_postPath = "z:\\sequence\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\post\\"
			
			
			--Obtendré primero los readers de nuke y fusion.
			-------------------------------------------------------------------------------
			
			if doesFileExist (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_post_v02.comp")) then
			(
				_currentPostFile = (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_post_v02.comp"))
			)
			else if doesFileExist (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_post_v02.nk")) then
			(
				_currentPostFile = (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_post_v02.nk"))
			)
			else
				_currentPostFile = ""
			
			if _currentPostFile != "" then
			(
				--inicializa los arrays de informacion para ese archivo
				_postIptsNames = #()
				_postIpts = #()
				
				if getFilenameType _currentPostFile == ".comp" then
				(
					--FUSION
					--obtiene los reader de nuke, su nombre y su input					
					
					--estados de busqueda
					_searchState = #loader
					--#loader --buscando nodos loader
					--#filename --buscando el input del loader
					
					_f = openfile _currentPostFile mode:"r" --abre el archivo de fusion en modo lectura
					
					while not eof _f do --recorre el archivo hasta el final
					(
						_l = readLine _f
						
						case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
						(
							#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
							(
								if findString _l " = Loader {" != undefined then
								(
									_searchState = #filename
									
									_name = substituteString _l " = Loader {" ""
									_name = substituteString _name "	" ""
									
									append _postIptsNames _name --añade el nombre al array
								)
							)--#loader
							
							#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
							(
								if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
								(
									_searchState = #loader
									
									_path = (filterString _l "\"")[2]
									_path = substituteString _path "\\\\" "\\"
									
									_fParts = filterString (getFileNameFile _path) "_"
									if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
									
									append _postIpts _path
								)
							)--#filename							
						)--case ESTADOS						
					)--while not eof
					
					close _f
				)
				else
				(
					-------------------------------------------------------------------------------
					
					-------------------------------------------------------------------------------
					--NUKE
					--obtiene los reader de nuke, su nombre y su input
					
					--estados de busqueda
					_searchState = #read
					--#read --buscando nodos read
					--#file --buscando el input del read
					--#name --buscando el nombre del nodo read
										
					_f = openfile _currentPostFile mode:"r" --abre el archivo de nuke en modo lectura
					
					while not eof _f do --recorre el archivo hasta el final
					(
						_l = readLine _f
						
						case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
						(
							#read: --ESTADO DE BUSQUEDA DE NODO READ
							(
								if findString _l "Read {" != undefined then _searchState = #file
							)--#read
							
							#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
							(
								if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
								(
									_searchState = #name
									
									_path = substituteString _l " file " ""
									_path = substituteString _path "/" "\\"
									
									_path = substituteString _path "Ã±" "ñ"
									
									if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
									
									_fParts = filterString (getFileNameFile _path) "_"
									if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
									else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
									
									append _postIpts _path
								)
							)--#file
							
							#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
							(
								if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
								(
									_searchState = #read
									
									_name = substituteString _l " name " ""
										
									append _postIptsNames _name --añade el name al array
								)
							)--#name
						)--case ESTADOS						
					)--while not eof
					
					close _f
					
					-------------------------------------------------------------------------------
				)
				
				--Sacaremos la ruta de lbdata001 2 de los archivos de cámara.
				_cameraFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
				_renderFrames = "seq_" + _seqNumber + "_cam" + _camNumber + "_render*_*.*"
				
				_files = getFiles (_cameraFramesPath + _renderFrames)
				
		-- 					for i=1 to _files.count do print _files[i]
		-- 					
		-- 					for i=1 to _postIpts.count do print _postIpts[i]
				_notFound = #()
				for i=1 to _files.count do 
				(
					--Me creo un flag para almacenar si este frame esta en algun read del archivo de post.
					_isInRead = false
					for j=1 to _postIpts.count do
					(
						_pattern = (substituteString (tolower(_postIpts[j])) "#" "?") 
						
						if matchPattern _files[i] pattern:_pattern then
						(
							_isInRead = true
						)
					)
					
					if not _isInRead then
						append _notFound _files[i]
				)
				
				for i=1 to _notFound.count do
				(
					--Si tienen las 4 últimas cifras numéricas las sustituiremos por ####
					if lb.math.isNumeric (substring(getFilenameFile _notFound[i]) ((getFilenameFile _notFound[i]).count - 3) (getFilenameFile _notFound[i]).count) then
						_notFound[i] = (getFilenamePath _notFound[i]) + (substring(getFilenameFile _notFound[i]) 1 ((getFilenameFile _notFound[i]).count - 4)) + "####" +  (getFilenameType _notFound[i])
				)
				
				_notFound = makeUniqueArray _notFound
				
				for i=1 to _notFound.count do
				(
					_fail = true
					log += "ERROR: El frame <" + _notFound[i] + "> no aparece en ningún nodo de lectura de frames del archivo " + (filenameFromPath _currentPostFile) + "\n\n"
				)
			)
			else
			(
				log += "ERROR: No encontramos ningún archivo de post válido para realizar este check, revise la carpeta de post.\n\n"
				_fail = true
			)
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba que los frames en \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\:\n\n"
				log += "Están presentes en los nodos de lectura de frames del archivo de post v01 (del departamento de iluminación)\n\n"
				log += "Dicho archivo podrá tomar dos nombres en función de si es de fusion o de nuke:\n"
				log += "FUSION: seq_xxx_camyyy_post_v01.comp\n"
				log += "NUKE: seq_xxx_camyyy_post_v01.nk\n\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInCamFolderExistInCompV2
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Los frames de renderFx la carpeta cam se leen desde algun archivo nuke o fusion
	struct checkTask_fxFramesInCamFolderExistInComp
	(
		id = lb.totalChecker.rollMain.TCH_fxFramesInCamFolderExistInComp, --id de la tarea
		name = "Frames: Los frames de renderFx la carpeta cam se leen desde algun archivo nuke o fusion.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" ""
			
			--Obtengo la ruta del archivo de post				
			_postPath = "z:\\sequence\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\post\\"
			
			
			--Obtendré primero los readers de nuke y fusion.
			-------------------------------------------------------------------------------
			
			if doesFileExist (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_postFx.comp")) then
			(
				_currentPostFile = (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_postFx.comp"))
			)
			else if doesFileExist (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_postFx.nk")) then
			(
				_currentPostFile = (_postPath + ("seq_" + _seqNumber + "_cam" + _camNumber +"_postFx.nk"))
			)
			else
				_currentPostFile = ""
			
			if _currentPostFile != "" then
			(
				--inicializa los arrays de informacion para ese archivo
				_postIptsNames = #()
				_postIpts = #()
				
				if getFilenameType _currentPostFile == ".comp" then
				(
					--FUSION
					--obtiene los reader de nuke, su nombre y su input					
					
					--estados de busqueda
					_searchState = #loader
					--#loader --buscando nodos loader
					--#filename --buscando el input del loader
					
					_f = openfile _currentPostFile mode:"r" --abre el archivo de fusion en modo lectura
					
					while not eof _f do --recorre el archivo hasta el final
					(
						_l = readLine _f
						
						case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
						(
							#loader: --ESTADO DE BUSQUEDA DE NODO LOADER
							(
								if findString _l " = Loader {" != undefined then
								(
									_searchState = #filename
									
									_name = substituteString _l " = Loader {" ""
									_name = substituteString _name "	" ""
									
									append _postIptsNames _name --añade el nombre al array
								)
							)--#loader
							
							#filename: --ESTADO DE BUSQUEDA DEL INPUT DEL LOADER
							(
								if findString _l "Filename = " != undefined then --almacena el input y pasa al siguiente estado
								(
									_searchState = #loader
									
									_path = (filterString _l "\"")[2]
									_path = substituteString _path "\\\\" "\\"
									
									_fParts = filterString (getFileNameFile _path) "_"
									if lb.math.isNumeric _fParts[_fParts.count] then (_path = substituteString _path _fParts[_fParts.count] "####")
									
									append _postIpts _path
								)
							)--#filename							
						)--case ESTADOS						
					)--while not eof
					
					close _f
				)
				else
				(
					-------------------------------------------------------------------------------
					
					-------------------------------------------------------------------------------
					--NUKE
					--obtiene los reader de nuke, su nombre y su input
					
					--estados de busqueda
					_searchState = #read
					--#read --buscando nodos read
					--#file --buscando el input del read
					--#name --buscando el nombre del nodo read
										
					_f = openfile _currentPostFile mode:"r" --abre el archivo de nuke en modo lectura
					
					while not eof _f do --recorre el archivo hasta el final
					(
						_l = readLine _f
						
						case _searchState of --EN FUNCION DEL ESTADO ACTUAL DE BUSQUEDA
						(
							#read: --ESTADO DE BUSQUEDA DE NODO READ
							(
								if findString _l "Read {" != undefined then _searchState = #file
							)--#read
							
							#file: --ESTADO DE BUSQUEDA DEL INPUT DEL READ
							(
								if findString _l "file " != undefined then --almacena el input y pasa al siguiente estado
								(
									_searchState = #name
									
									_path = substituteString _l " file " ""
									_path = substituteString _path "/" "\\"
									
									_path = substituteString _path "Ã±" "ñ"
									
									if _path != "" and _path[1] == " " then while _path[1] == " " do _path = substring _path 2 _path.count
									
									_fParts = filterString (getFileNameFile _path) "_"
									if lb.math.isNumeric _fParts[_fParts.count] then _path = substituteString _path _fParts[_fParts.count] "####"
									else if _fParts[_fParts.count] == "#" or _fParts[_fParts.count] == "##" or _fParts[_fParts.count] == "###" then _path = substituteString _path _fParts[_fParts.count] "####"
									
									append _postIpts _path
								)
							)--#file
							
							#name: --ESTADO DE BUSQUEDA DEL NOMBRE DEL READ
							(
								if findString _l "name " != undefined then --almacena el name y pasa al siguiente estado
								(
									_searchState = #read
									
									_name = substituteString _l " name " ""
										
									append _postIptsNames _name --añade el name al array
								)
							)--#name
						)--case ESTADOS						
					)--while not eof
					
					close _f
					
					-------------------------------------------------------------------------------
				)
				
				--Sacaremos la ruta de lbdata001 2 de los archivos de cámara.
				_cameraFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
				_renderFrames = "seq_" + _seqNumber + "_cam" + _camNumber + "_renderFx_*.*"
				
				_files = getFiles (_cameraFramesPath + _renderFrames)
				_notFound = #()
				for i=1 to _files.count do 
				(
					--Me creo un flag para almacenar si este frame esta en algun read del archivo de post.
					_isInRead = false
					for j=1 to _postIpts.count do
					(
						_pattern = (substituteString (tolower(getFilenameFile _postIpts[j])) "#" "?") + tolower(getFilenameType _postIpts[j])
						if matchPattern _files[i] pattern:_pattern then
							_isInRead = true
					)
					
					if not _isInRead then
						append _notFound _files[i]
				)
				
				for i=1 to _notFound.count do
				(
					--Si tienen las 4 últimas cifras numéricas las sustituiremos por ####
					if lb.math.isNumeric (substring(getFilenameFile _notFound[i]) ((getFilenameFile _notFound[i]).count - 3) (getFilenameFile _notFound[i]).count) then
						_notFound[i] = (getFilenamePath _notFound[i]) + (substring(getFilenameFile _notFound[i]) 1 ((getFilenameFile _notFound[i]).count - 4)) + "####" +  (getFilenameType _notFound[i])
				)
				
				_notFound = makeUniqueArray _notFound
				
				for i=1 to _notFound.count do
				(
					_fail = true
					log +="ERROR: El frame <" + _notFound[i] + "> no aparece en ningún nodo de lectura de frames del archivo " + (filenameFromPath _currentPostFile) + "\n\n"
				)
			)
			else
			(
				log += "ERROR: No encontramos ningún archivo de post válido para realizar este check, revise la carpeta de post.\n\n"
				_fail = true
			)
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba que los frames en \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\:\n"
				log += "Están presentes en los nodos de lectura de frames del archivo de post v01 (del departamento de iluminación)\n"
				log += "Dicho archivo podrá tomar dos nombres en función de si es de fusion o de nuke:\n"
				log += "FUSION: seq_xxx_camyyy_postFx.comp\n"
				log += "NUKE: seq_xxx_camyyy_postFx.nk\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_fxFramesInCamFolderExistInComp
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Los frames de la carpeta cam/final cumplen el naming convention.
	struct checkTask_framesInFinalFolderNC
	(
		id = lb.totalChecker.rollMain.TCH_framesInFinalFolderNC, --id de la tarea
		name = "Frames: Los frames de la carpeta cam/final cumplen el naming convention.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(lb.totalChecker.rollMain.TCH_findMissingFrames), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" ""
			
			--Obtengo la ruta del archivo de post				
			_framesPath = "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\final\\"
			
			_files = getFiles (_framesPath + "*.*")
			
			if _files.count != 0 then
			(
				for i=1 to _files.count where tolower (filenameFromPath _files[i]) != "thumbs.db" do
				(
					if not matchPattern (filenameFromPath _files[i]) pattern:lb.nc.NC_seqFrameFinalPattern then
					(
						_fail = true
						log += "-> "+(filenameFromPath _files[i])+" no cumple el naming convention para archivos de render finales.\n"
					)
				)
			)
			else
			(
				_fail = true
				log += "-> <"+_framesPath+"> No hay archivos de render finales a los que pasar el naming convention.\n"
			)
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba que los frames en \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\final\\\n"
				log += "cumplen el siguiente naming convention:\n"
				log += "seq_XXX_camYYY_final_####.tiff o .tif \n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInFinalFolderNC
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Los frames de cam y cam/final tienen el numero de secuencia y cámara correcto
	struct checkTask_framesInCamAndFinalCamAndSeqOk
	(
		id = lb.totalChecker.rollMain.TCH_framesInCamAndFinalCamAndSeqOk, --id de la tarea
		name = "Frames: Los frames de cam y cam/final tienen el numero de secuencia y cámara correcto", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(/*TCH_framesInCamNC, TCH_framesInFinalFolderNC*/), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" ""
			
			--Primero miro los archivos de render de cam
			_framesPath = "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			
			_files = getFiles (_framesPath + "*_render_*.*")
			
			_firstError = true
			for i=1 to _files.count where tolower (filenameFromPath _files[i]) != "thumbs.db" do
			(
				if (filterString (getFilenameFile _files[i]) "_")[2] != _seqNumber or (filterString (getFilenameFile _files[i]) "_")[3] != ("cam"+_camNumber) then
				(
					if _firstError then
					(
						_firstError = false
						log += "CARPETA: " + (getFilenamePath _files[i]) +  "\n"
					)
					_fail = true
					log += "-> "+(filenameFromPath _files[i])+" no coincide en el número de secuencia y/o cámara con el de su ruta.\n"
				)
			)
			
			--Luego miro los archivos de render de cam\\final
			_framesPath = "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\final\\"
			
			_files = getFiles (_framesPath + "*.*")
			
			_firstError = true
			for i=1 to _files.count where tolower (filenameFromPath _files[i]) != "thumbs.db" do
			(
				if (filterString (getFilenameFile _files[i]) "_")[2] != _seqNumber or (filterString (getFilenameFile _files[i]) "_")[3] != ("cam"+_camNumber) then
				(
					if _firstError then
					(
						_firstError = false
						log += "\nCARPETA: " + (getFilenamePath _files[i]) +  "\n"
					)
					_fail = true
					log += "-> "+(filenameFromPath _files[i])+" no coincide en el número de secuencia y/o cámara con el de su ruta.\n"
				)
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba que los frames en \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ y \\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\final\\\n"
				log += "coinciden en número de secuencia y cámara con la ruta en la que están ubicados.:\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInCamAndFinalCamAndSeqOk
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--Los frames de cam y ref vienen de capas existentes en el archivo .max
	struct checkTask_framesInCamHaveLayer
	(
		id = lb.totalChecker.rollMain.TCH_framesInCamHaveLayer, --id de la tarea
		name = "Frames: Los frames de cam corresponden con una capa de LPM", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			if maxFiles.count == 0 then
			(
				maxFiles = getFiles(path + @"render\*render_*")
				maxFilesInfo = for mf in maxFiles collect getFileInfo mf
			)
			
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" "" 
			
			--Obtengo todas las rutas				
			_cameraFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\"
			
			_passesOutputs = #()
			
			--Recorro los archivos y cojo sus patterns de frames
			for i=1 to maxFiles.count do
			(
				_passesOutputs += getFileInfoLPMpassesOutputs maxFiles[i] file:maxFilesInfo[i]
			)
			
			_passesOutputs = makeUniqueArray _passesOutputs
			
			--Primero repasaré la carpeta de frames
			_files = getFiles(_cameraFramesPath + "*.*")
			
			--Me creo un array para almacenar los frames que no están en ninguna capa.
			_noMatch = #()
			for i=1 to _files.count where tolower(filenamefrompath _files[i]) != "thumbs.db" and not matchPattern (getFilenameFile _files[i]) pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_renderFx_*") do
			(	
				_hasMatch = false
				for j=1 to _passesOutputs.count do
				(
					--Modificamos el patrón para poder hacer el pase
					_pattern = (getFilenameFile _passesOutputs[j]) + "????" + (getFilenameType _passesOutputs[j])
					if matchPattern ((getFilenameFile _files[i]) + (getFilenameType _files[i])) pattern:_pattern then
						_hasMatch = true
				)
				
				if not _hasMatch then
					append _noMatch _files[i]
			)
			
			for i=1 to _noMatch.count do
			(
				--Si tienen las 4 últimas cifras numéricas las sustituiremos por ####
				if lb.math.isNumeric (substring(getFilenameFile _noMatch[i]) ((getFilenameFile _noMatch[i]).count - 3) (getFilenameFile _noMatch[i]).count) then
					_noMatch[i] = (getFilenamePath _noMatch[i]) + (substring(getFilenameFile _noMatch[i]) 1 ((getFilenameFile _noMatch[i]).count - 4)) + "####" +  (getFilenameType _noMatch[i])
			)
			
			_noMatch = makeUniqueArray _noMatch
			
			for i=1 to _noMatch.count do
			(
				log += "ERROR: <" + _noMatch[i] + "> no pertenece a ninguna capa de LPM de ningún archivo .max de esta secuencia y cámara.\n\n"
				_fail = true
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba en esta carpeta:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\ \n\n"
				log += "Que todos los frames que contienen pertenecen a alguna capa de LPM de los archivos de render de la cámara.\n\n"
				log += "Lo que quiere decir que si hay un frame cuya capa no existe en ningun archivo .max este check dará error.\n\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_framesInCamHaveLayer
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	--todos los frames finales han sido renderizados
	struct checkTask_allFinalFramesRendered
	(
		id = lb.totalChecker.rollMain.TCH_allFinalFramesRendered, --id de la tarea
		name = "Frames: Todos los frames finales han sido renderizados", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			_warning = false
			
			if maxFiles.count == 0 then
			(
				maxFiles = getFiles(path + @"render\*render_*")
				maxFilesInfo = for mf in maxFiles collect getFileInfo mf
			)
			
			--Obtengo el rango más amplio
			_minRange = 10000000f
			_maxRange = -10000000f
			
			for i=1 to maxFilesInfo.count do 
			(
				if maxFilesInfo[i].renderRange.start < _minRange then
					_minRange = maxFilesInfo[i].renderRange.start 
				if maxFilesInfo[i].renderRange.end > _maxRange then
					_maxRange = maxFilesInfo[i].renderRange.end
			)
			
			_minRange = (_minRange As Integer) / 200
			_maxRange = (_maxRange As Integer) / 200
			
			--Saco el numero de cámara y de secuencia del path
			_seqNumber = (filterString path "\\_")[4]
			_camNumber = substituteString (filterString path "\\_")[6] "cam" "" 
			
			--Obtengo todas las rutas				
			_finalFramesPath= "\\\\lbdata002\\z\\frame\\seq_" + _seqNumber + "\\cam\\cam" + _camNumber + "\\final\\"
			
			--Primero repasaré la carpeta de frames
			_files = getFiles(_finalFramesPath + "*.*")
			
			--Montamos el nombre que tiene que tener un frame final para luego agregarle el numero.
			_finalFrameName = "seq_" + _seqNumber + "_cam" + _camNumber + "_final_"
			
			_failedFrames = #{}
			
			for i=_minRange to _maxRange do
			(
				
				if not doesFileExist(_finalFramesPath + (_finalFrameName As String) + (formattedPrint i format:"04d") + ".tif" ) and not doesFileExist(_finalFramesPath + (_finalFrameName As String) + (formattedPrint i format:"04d")+ ".tiff" ) then
				(
					_failedFrames[i] = true 
					_fail = true
				)
			)
			
			if _fail then
			(
				_failedFrames = _failedFrames As String
				_failedFrames = substituteString _failedFrames "#" ""
				_failedFrames = substituteString _failedFrames "{" "["
				_failedFrames = substituteString _failedFrames "}" "]"
				_failedFrames = substituteString _failedFrames ".." "-"
				log += "ERROR: Rango de frames finales que no han sido renderizados: " + _failedFrames + " \n"
			)
			
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Este check comprueba que todos los frames finales han sido renderizados en la carpeta:\n"
				log += "\\\\lbdata002\\z\\frame\\seq_XXX\\cam\\camYYY\\final\\ \n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_allFinalFramesRendered
	-----------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------
	--ANIM CHECKS--
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que se hayan pasado los checks en los .max de anim
	struct checkTask_CheckedAnimMaxFiles
	(
		id = lb.totalChecker.rollMain.TCH_CheckedAnimMaxFiles, --id de la tarea
		name = "Asset Checker: los archivos de max han pasado los checks", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"anim\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = getFiles (_filesPath + ".max")
						
			for i=1 to _files.count do
			(
				_checked = getFileInfoIsChecked _files[i] info:maxFilesInfo[i]
					
				if not _checked then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> ERROR: no ha pasado el assetChecker.\n"
				)--if
				else --si ha pasado los checks, da warning si hay checks nuevos
				(						
					--Obtenemos el array que hay en el archivo, lo hacemos único y lo ordenamos.
					_fileChecks = getFileInfoChecksArray _files[i] info:maxFilesInfo[i]
					_fileChecks = makeUniqueArray _fileChecks
					sort _fileChecks
					
					--Obtenemos el array del listado de checks actual
					_checksArrayName = getFileInfoChecksArrayName _files[i] info:maxFilesInfo[i]
					if _checksArrayName == "" then _checksArrayName = "#()"
					_currentChecks = deepCopy (execute _checksArrayName)
					for i=_currentChecks.count to 1 by -1 where classof _currentChecks[i] == String do deleteItem _currentChecks i --Le quitamos los titulos
					_currentChecks = makeUniqueArray _currentChecks --Lo hacemos único
					sort _currentChecks --Lo ordenamos
					
					--Si el array de checks que pasó el archivo resulta ser igual que el actual entonces será ok sino lanzaremos un warning
					if not (lb.misc.areArraysEqual _currentChecks _fileChecks) then
					(
						if not _fail then state = warningMessage --pone el mensaje de warning
						log += _files[i] + " -> WARNING: ha pasado los checks, pero hay checks nuevos sin pasar.\n"
					)
				)
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de max de la camara deben haber pasado los checks del Asset Checker\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de anim de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
			else if state == warningMessage then
			(
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "Hay archivos de max que pasaron los checks en su momento, pero posteriormente se han creado nuevos checks.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_CheckedAnimMaxFiles
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el naming convention de los .max de anim
	struct checkTask_NCanimMaxFiles
	(
		id = lb.totalChecker.rollMain.TCH_NCanimMaxFiles, --id de la tarea
		name = "Naming Convention: Correcto en archivos .max de anim", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"anim\*")
			_files = getFiles (_filesPath + ".max")
				
			for i=1 to _files.count do
			(
				_filePath = getFileNamePath _files[i] --obtiene el path
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				_filePathMatchPattern = matchPattern _filePath pattern:lb.nc.NC_seqAnimPathPattern --comprueba que cumple el NC de path
				_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqAnimNamePattern --comprueba que cumple el NC de archivo
				if not _fileNameMatchPattern then _fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqAnimExtrasNamePattern --comprueba que cumple el NC de archivo
				
				if not _filePathMatchPattern then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de path de anim de max.\n"
				)--if
				
				if not _fileNameMatchPattern then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de archivo de anim de max.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de anim de max debe cumplir el patron: '" + lb.nc.NC_seqAnimPathPattern + "'\n"
				log += "El archivo de anim de max debe cumplir el patron: '" + lb.nc.NC_seqAnimNamePattern + "' o el patron: '" + lb.nc.NC_seqAnimExtrasNamePattern + "'\n"
				log += "Ej: seq_001_cam010_anim.max\n"
				log += "Ej: seq_015_cam080_anim-extras.max\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de anim de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NCanimMaxFiles
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que la secuencia y la camara coincide con el path de los .max de anim
	struct checkTask_NCanimMaxFilesSeqAndCamOK
	(
		id = lb.totalChecker.rollMain.TCH_NCanimMaxFilesSeqAndCamOK, --id de la tarea
		name = "Naming Convention: Numero de secuencia y camara correcto en archivos .max de anim", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"anim\*")
			_files = getFiles (_filesPath + ".max")
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			for i=1 to _files.count do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				_fileNameMatchSeqAndCam = matchPattern _fileName pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_anim*.max") --comprueba que cumple el NC de archivo
				
				--tiene que tener 3 o 4 caracteres y los 3 primeros ser numericos, si no falla, miraremos la primera parte dividida por guion (por si nos encontramos con un teaser)
				if (filterString _seqNumber "-")[1].count == 3 or (filterString _seqNumber "-")[1].count == 4 then --si tiene 3 o 4 caracteres para la secuencia
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _seqNumber[1] or not lb.math.isNumeric _seqNumber[2] or not lb.math.isNumeric _seqNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de secuencia debe tener los tres primeros caracteres numéricos.\n"
					)
					
					--si tiene cuarto caracter
					if (filterString _seqNumber "-")[1].count == 4 and lb.math.isNumeric _seqNumber[4] then
					(
						_fail = true
						log += _files[i] + " -> si el numero de secuencia va seguido de otro caracter, no debe ser numérico.\n"
					)
				)
				else --si tiene menos de 3 o mas de 4 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia debe tener 3 digitos y opcionalmente una letra, si se trata de un teaser ha de cumplirlo antes del guión.\n"
				)
				
				--tiene que tener 3 caracteres y ser numericos, si no falla
				if _camNumber.count ==3 then --si tiene 3 caracteres para la camara
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _camNumber[1] or not lb.math.isNumeric _camNumber[2] or not lb.math.isNumeric _camNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de camara debe tener los caracteres numéricos.\n"
					)
				)
				else --si tiene menos de 3 o mas de 3 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de camara debe tener 3 digitos numéricos.\n"
				)
				
				if not _fileNameMatchSeqAndCam then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia o de camara no coincide con el path.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El archivo de anim de max debe coincidir en numero de secuencia y camara con la ruta del archivo.\n"
				log += "Ej: seq_001_cam050_anim.max\n"
				log += "Ej: seq_017b_cam010_anim-extras.max\n"
				log += "Ej (teaser): seq_019-ts3_cam010_anim.max\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCanimMaxFilesSeqAndCamOK
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que este actualizada la carpeta de render
	struct checkTask_SVNanimPathUpdated
	(
		id = lb.totalChecker.rollMain.TCH_SVNanimPathUpdated, --id de la tarea
		name = "SVN: path de anim versionado y actualizado. (Avisa tambien de los commit sin hacer).", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene el path de render
			_filesPath = (path + "anim\\")
			_files = getFiles (_filesPath + "*.max")
			
			if doesFileExist _filesPath then --si existe el path
			(
				_svnInfo = #()
				
				if not lb.svn.svnIsFolderVersioned _filesPath then --si no está versionado te avisa
				(
					_fail = true --falla
					log += _filesPath + " -> No está versionado.\n"
				)
				else --si esta versionado se comprueba que esté actualizado.
				(
					--averigua si esta actualizado preguntandole a svn
					_svnInfo = lb.svn.svnGetFolderStatus _filesPath donotwait:true sleepTime:0.5
					_isUpdated = if _svnInfo.count == 1 then (_svnInfo[_svnInfo.count].state == "U") else false
					
					if _isUpdated then --si dice que esta actualizadoo ahora busca cualquier archivo que no lo esté, porque a veces falla
						for i=1 to _svnInfo.count where _isUpdated do
							if (_svnInfo[i].state == "!") or (_svnInfo[i].state == "*") then
								_isUpdated = false
					
					if not _isUpdated then --si no está actualizada avisa
					(
						_fail = true --falla
						log += _filesPath + " -> No está actualizado.\n"
					)
					
					for i=1 to _files.count do --recorre los archivos del path buscando lo que necesiten un commit
					(
						_notVersioned = not lb.svn.svnIsFileVersioned _files[i] donotwait:true statusInfo:_svnInfo --mira si está versionado
						if _notVersioned then
						(
							_fail = true --falla
							log += _files[i] + " -> No está versionado.\n"
						)
						
						_status = lb.svn.svnGetFileStatus _files[i] statusInfo:_svnInfo --obtiene el estado de ese archivo
						_needsCommit = (_status == "A") or (_status == "D") or (_status == "G") or (_status == "M") or (_status == "R") --mira si necesita un commit
						if _needsCommit then
						(
							_fail = true --falla
							log += _files[i] + " -> Necesita un commit.\n"
						)
					)--for _files	
				)--if else				
			)
			else --si no existe puede que no esté creado o que la carpeta de la camara no este actualizada
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que aún no se haya creado, o que el path de la cámara no esté actualizado.\n"
			)--if else
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de anim de max debe existir\n"
				log += "El path de anim de max debe estar versionado\n"
				log += "El path de anim de max debe estar actualizado (en local)\n"
				log += "**************************************************************************************\n\n"
			)--if
		-- 				else if _files.count == 0 then --si no hay archivos avisa con un warning
		-- 				(
		-- 					state = warningMessage --pone el mensaje de warning
		-- 					
		-- 					--completa el log
		-- 					log = "**************************************************************************************\n\n"
		-- 					log += "No hay archivos de anim de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
		-- 					log += "**************************************************************************************\n\n"
		-- 				)
		)--executeFN
	)--checkTask_SVNanimPathUpdated
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el rango de animacion de los .max de anim
	struct checkTask_NCanimMaxFilesAnimRangeAsCamRange
	(
		id = lb.totalChecker.rollMain.TCH_NCanimMaxFilesAnimRangeAsCamRange, --id de la tarea
		name = "Animation Range: Igual que el de la camara en archivos .max de anim", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"anim\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = getFiles (_filesPath + ".max")
						
			for i=1 to _files.count do
			(
				_sceneAnimRange = getFileInfoAnimationRange _files[i] info:maxFilesInfo[i]
				_cams = getFileInfoCameras _files[i] info:maxFilesInfo[i]
				_camsRange = getFileInfoCamerasRange _files[i] info:maxFilesInfo[i]
					
				if _cams.count != 1 then --si hay mas de una camara o ninguna
				(
					_fail = true
					
					if _cams.count != 0 then --si hay mas de una camara
						log += _files[i] + " -> ERROR: hay más de una camara en la escena.\n"
					else --si no hay camara
						log += _files[i] + " -> ERROR: no hay camara en la escena.\n"
				)--if
				else --si ha pasado los checks, da warning si hay checks nuevos
				(						
					--averigua si el rango es correcto
					_isRangeOk = (_camsRange[1].start == _sceneAnimRange.start) and (_camsRange[1].end == _sceneAnimRange.end)
											
					--si el rango no es correcto falla
					if not _isRangeOk then
					(
						_fail = true
						log += _files[i] + " -> ERROR: el rango de animacion de la escena no coincide con el de su camara.\n"
					)
				)
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de max de la camara deben tener el mismo rango de animación que de camara.\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de anim de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)			
		)--executeFN
	)--checkTask_NCanimMaxFilesAnimRangeAsCamRange
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que no haya luces en los .max de anim
	struct checkTask_animMaxFilesWithoutLights
	(
		id = lb.totalChecker.rollMain.TCH_animMaxFilesWithoutLights, --id de la tarea
		name = "Lights: los archivos de max de anim no deben tener luces.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"anim\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = getFiles (_filesPath + ".max")
						
			for i=1 to _files.count do
			(
				_lights = getFileInfoLightsNames _files[i] info:maxFilesInfo[i]
					
				if _lights.count != 0 then --si hay luces
				(
					_fail = true
					log += _files[i] + " -> WARNING: Hay luces en la escena.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de anim de la camara no deben tener luces.\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de anim de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_animMaxFilesWithoutLights
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que no haya objetos de stamps en los .max de anim
	struct checkTask_animMaxFilesWithoutStamps
	(
		id = lb.totalChecker.rollMain.TCH_animMaxFilesWithoutStamps, --id de la tarea
		name = "Misc: los archivos de max de anim no deben haberse guardado con los Stamps activos.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"anim\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = getFiles (_filesPath + ".max")
						
			for i=1 to _files.count do
			(
				_objsLayer = getFileInfoObjectsLayer _files[i] info:maxFilesInfo[i]
					
				if findItem _objsLayer "__stampLayer__" != 0 then --si hay objetos de la capa "__stampLayer__"
				(
					_fail = true
					log += _files[i] + " -> ERROR: Hay stamps en la escena.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de anim de la camara no deben haberse guardado con los stamps activos.\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de anim de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_animMaxFilesWithoutStamps
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que no haya objetos de layout en los .max de anim
	struct checkTask_animMaxFilesWithoutLayout
	(
		id = lb.totalChecker.rollMain.TCH_animMaxFilesWithoutLayout, --id de la tarea
		name = "Misc: los archivos de max de anim no deben tener objetos de layout.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"anim\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = getFiles (_filesPath + ".max")
						
			for i=1 to _files.count do
			(
				_objsLayer = getFileInfoObjectsLayer _files[i] info:maxFilesInfo[i]
					
				if findItem _objsLayer "_layout_" != 0 then --si hay objetos de la capa "_layout_"
				(
					_fail = true
					log += _files[i] + " -> ERROR: Hay objetos de layout en la escena.\n"
				)--if
				else
				(
					_objs = getFileInfoObjectsNames _files[i] info:maxFilesInfo[i]
					_stop = false
					for obj in _objs where not _stop and findString obj "LAY" != undefined do _stop = true
					
					if _stop then
					(
						_fail = true
						log += _files[i] + " -> ERROR: Hay objetos de layout en la escena.\n"
					)
				)
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de anim de la camara no deben tener objetos de layout.\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de anim de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_animMaxFilesWithoutLayout
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------
	--CACHE CHECKS--
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que se hayan pasado los checks en los .max de cache
	struct checkTask_CheckedCacheMaxFiles
	(
		id = lb.totalChecker.rollMain.TCH_CheckedCacheMaxFiles, --id de la tarea
		name = "Asset Checker: los archivos de max han pasado los checks", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"cache\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".max"
						
			for i=1 to _files.count do
			(
				_checked = getFileInfoIsChecked _files[i] info:maxFilesInfo[i]
					
				if not _checked then --si no esta checkeado
				(
					_fail = true
					log += _files[i] + " -> ERROR: no ha pasado el assetChecker.\n"
				)--if
				else --si ha pasado los checks, da warning si hay checks nuevos
				(						
					--Obtenemos el array que hay en el archivo, lo hacemos único y lo ordenamos.
					_fileChecks = getFileInfoChecksArray _files[i] info:maxFilesInfo[i]
					_fileChecks = makeUniqueArray _fileChecks
					sort _fileChecks
					
					--Obtenemos el array del listado de checks actual
					_checksArrayName = getFileInfoChecksArrayName _files[i] info:maxFilesInfo[i]
					if _checksArrayName == "" then _checksArrayName = "#()"
					_currentChecks = deepCopy (execute _checksArrayName)
					for i=_currentChecks.count to 1 by -1 where classof _currentChecks[i] == String do deleteItem _currentChecks i --Le quitamos los titulos
					_currentChecks = makeUniqueArray _currentChecks --Lo hacemos único
					sort _currentChecks --Lo ordenamos
					
					--Si el array de checks que pasó el archivo resulta ser igual que el actual entonces será ok sino lanzaremos un warning
					if not (lb.misc.areArraysEqual _currentChecks _fileChecks) then
					(
						if not _fail then state = warningMessage --pone el mensaje de warning
						log += _files[i] + " -> WARNING: ha pasado los checks, pero hay checks nuevos sin pasar.\n"
					)
				)
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de max de la camara deben haber pasado los checks del Asset Checker\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de cache de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
			else if state == warningMessage then
			(
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "Hay archivos de max que pasaron los checks en su momento, pero posteriormente se han creado nuevos checks.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_CheckedCacheMaxFiles
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el naming convention de los .max de cache
	struct checkTask_NCcacheMaxFiles
	(
		id = lb.totalChecker.rollMain.TCH_NCcacheMaxFiles, --id de la tarea
		name = "Naming Convention: Correcto en archivos .max de cache", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"cache\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".max"
				
			for i=1 to _files.count do
			(
				_filePath = getFileNamePath _files[i] --obtiene el path
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				
				_filePathMatchPattern = matchPattern _filePath pattern:lb.nc.NC_seqCachePath --comprueba que cumple el NC de path
				_fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqCacheNamePattern --comprueba que cumple el NC de archivo
				if not _fileNameMatchPattern then _fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqCacheFxNamePattern --comprueba que cumple el NC de archivo
				if not _fileNameMatchPattern then _fileNameMatchPattern = matchPattern _fileName pattern:lb.nc.NC_seqCacheExtrasNamePattern --comprueba que cumple el NC de archivo
				
				if not _filePathMatchPattern then --si no cumple el NC de path
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de path de cache de max.\n"
				)--if
				
				if not _fileNameMatchPattern then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> no cumple el NC de archivo de cache de max.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El path de cache de max debe cumplir el patron: '" + lb.nc.NC_seqCachePath + "'\n"
				log += "El archivo de cache de max debe cumplir el patron: '" + lb.nc.NC_seqCacheNamePattern + "' o el patron: '" + lb.nc.NC_seqCacheFxNamePattern + "' o: '" + lb.nc.NC_seqCacheExtrasNamePattern + "'\n"
				log += "Ej: seq_001_cam010_cache.max\n"
				log += "Ej: seq_015_cam080_cache-extras.max\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if _files.count == 0 then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n"
				log += "No hay archivos de cache de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_NCcacheMaxFiles
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que la secuencia y la camara coincide con el path de los .max de cache
	struct checkTask_NCcacheMaxFilesSeqAndCamOK
	(
		id = lb.totalChecker.rollMain.TCH_NCcacheMaxFilesSeqAndCamOK, --id de la tarea
		name = "Naming Convention: Numero de secuencia y camara correcto en archivos .max de cache", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"cache\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".max"
			
			--para comparar el numero de secuencia y camara
			_seqNumber = ""
			_camNumber = ""
			
			_pathParts = filterString path "\\" --separa el path en partes
			for part in _pathParts do --recorre las partes y obtiene el numero de camara y de secuencia
			(
				if matchPattern part pattern:"seq_???*" then _seqNumber = substituteString part "seq_" ""
				else if matchPattern part pattern:"cam???" then _camNumber = substituteString part "cam" ""
			)--for
			
			for i=1 to _files.count do
			(
				_fileName = (getFileNameFile _files[i]) + (getFileNameType _files[i]) --obtiene el nombre del archivo
				_fileNameMatchSeqAndCam = matchPattern _fileName pattern:("seq_" + _seqNumber + "_cam" + _camNumber + "_cache*.max") --comprueba que cumple el NC de archivo
				
				--tiene que tener 3 o 4 caracteres y los 3 primeros ser numericos, si no falla. En el caso del teaser tendremos que mirar la primera parte antes del guion.
				if (filterString _seqNumber "-")[1].count ==3 or (filterString _seqNumber "-")[1].count == 4 then --si tiene 3 o 4 caracteres para la secuencia
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _seqNumber[1] or not lb.math.isNumeric _seqNumber[2] or not lb.math.isNumeric _seqNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de secuencia debe tener los tres primeros caracteres numéricos. Si es un teaser estos irán antes del guión.\n"
					)
					
					--si tiene cuarto caracter
					if (filterString _seqNumber "-")[1].count == 4 and lb.math.isNumeric _seqNumber[4] then
					(
						_fail = true
						log += _files[i] + " -> si el numero de secuencia va seguido de otro caracter, no debe ser numérico. Si es un teaser estos irán antes del guión.\n"
					)
				)
				else --si tiene menos de 3 o mas de 4 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia debe tener 3 digitos y opcionalmente una letra. Si es un teaser estos irán antes del guión.\n"
				)
				
				--tiene que tener 3 caracteres y ser numericos, si no falla
				if _camNumber.count ==3 then --si tiene 3 caracteres para la camara
				(
					--los tres primeros caracteres deben ser numericos
					if not lb.math.isNumeric _camNumber[1] or not lb.math.isNumeric _camNumber[2] or not lb.math.isNumeric _camNumber[3] then
					(
						_fail = true
						log += _files[i] + " -> el numero de camara debe tener los caracteres numéricos.\n"
					)
				)
				else --si tiene menos de 3 o mas de 3 no es correcto
				(
					_fail = true
					log += _files[i] + " -> el numero de camara debe tener 3 digitos numéricos.\n"
				)
				
				if not _fileNameMatchSeqAndCam then --si no cumple el NC de archivo
				(
					_fail = true
					log += _files[i] + " -> el numero de secuencia o de camara no coincide con el path.\n"
				)--if
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "El archivo de cache de max debe coincidir en numero de secuencia y camara con la ruta del archivo.\n"
				log += "Ej: seq_001_cam050_cache.max\n"
				log += "Ej: seq_017b_cam010_cache-extras.max\n"
				log += "Ej (Teaser): seq_078b-ts4_cam010_cache-extras.max\n"
				log += "**************************************************************************************\n\n"
			)--if
		)--executeFN
	)--checkTask_NCcacheMaxFilesSeqAndCamOK
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba el rango de animacion de los .max de cache
	struct checkTask_NCcacheMaxFilesAnimRangeAsCamRange
	(
		id = lb.totalChecker.rollMain.TCH_NCcacheMaxFilesAnimRangeAsCamRange, --id de la tarea
		name = "Animation Range: Igual que el de la camara en archivos .max de cache", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"cache\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".max"
						
			for i=1 to _files.count do
			(
				_sceneAnimRange = getFileInfoAnimationRange _files[i] info:maxFilesInfo[i]
				_cams = getFileInfoCameras _files[i] info:maxFilesInfo[i]
				_camsRange = getFileInfoCamerasRange _files[i] info:maxFilesInfo[i]
					
				if _cams.count != 1 then --si hay mas de una camara o ninguna
				(
					_fail = true
					
					if _cams.count != 0 then --si hay mas de una camara
						log += _files[i] + " -> ERROR: hay más de una camara en la escena.\n"
					else --si no hay camara
						log += _files[i] + " -> ERROR: no hay camara en la escena.\n"
				)--if
				else --si solo hay una camara
				(						
					--averigua si el rango es correcto
					_isRangeOk = (_camsRange[1].start == _sceneAnimRange.start) and (_camsRange[1].end == _sceneAnimRange.end)
											
					--si el rango no es correcto falla
					if not _isRangeOk then
					(
						_fail = true
						log += _files[i] + " -> ERROR: el rango de animacion de la escena no coincide con el de su camara.\n"
					)
				)
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de max de la camara deben tener el mismo rango de animación que de camara.\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de cache de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)			
		)--executeFN
	)--checkTask_NCcacheMaxFilesAnimRangeAsCamRange
	-----------------------------------------------------------------------------------		
	
	-----------------------------------------------------------------------------------
	--comprueba que los .max de cache tienen sus camaras con transform cache
	struct checkTask_NCcacheMaxFilesCamsWithTC
	(
		id = lb.totalChecker.rollMain.TCH_NCcacheMaxFilesCamsWithTC, --id de la tarea
		name = "Misc: La camara en archivos .max de cache debe llevar transform cache.", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"cache\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".max"
						
			for i=1 to _files.count do
			(
				_cams = getFileInfoCameras _files[i] info:maxFilesInfo[i]
					
				if _cams.count != 1 then --si hay mas de una camara o ninguna
				(
					_fail = true
					
					if _cams.count != 0 then --si hay mas de una camara
						log += _files[i] + " -> ERROR: hay más de una camara en la escena.\n"
					else --si no hay camara
						log += _files[i] + " -> ERROR: no hay camara en la escena.\n"
				)--if
				else --si ha pasado los checks, da warning si hay checks nuevos
				(						
					_tcObjs = getFileInfoTransformCacheObjects _files[i] info:maxFilesInfo[i]
					
					if findItem _tcObjs _cams[1] == 0 then --si la camara no lleva transform cache
					(
						_fail = true
						log += _files[i] + " : " + _cams[1] + " -> WARNING: la camara en la escena no tiene transform cache generado.\n"
					)
				)
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = warningMessage --errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de max de la camara deben tener la camara con transform cache.\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de cache de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)			
		)--executeFN
	)--checkTask_NCcacheMaxFilesCamsWithTC
	-----------------------------------------------------------------------------------	
	
	-----------------------------------------------------------------------------------
	--comprueba que no haya SETs en los .max de cache
	struct checkTask_cacheMaxFilesWithoutSETs
	(
		id = lb.totalChecker.rollMain.TCH_cacheMaxFilesWithoutSETs, --id de la tarea
		name = "Misc: los archivos de max de cache no pueden llevar assets de tipo SET", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
		
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene los archivos
			_filesPath = (path + @"cache\*")
			_files = maxFiles
			if maxfiles.count == 0 then _files = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".max"
						
			for i=1 to _files.count do
			(
				_assets = getFileInfoAssets _files[i] info:maxFilesInfo[i]
					
				if _assets.count == 0 then --si no esta checkeado
				(
					_fail = true
					log += _files[i] + " -> ERROR: El archivo no tiene assets o su extraInfo está corrupto.\n"
				)--if
				else --si tiene assets, comprobamos que ninguno sea un SET
				(						
					--da fallo con cualquier asset de tipo set
					for _ast in _assets where findString _ast "set_" != undefined do
					(
						_fail = true
						log += _files[i] + " : " + _ast + " -> ERROR: Es un asset de tipo SET y no deberia estar en el achivo.\n"
					)
				)
			)--for
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Los archivos de cache de la camara no deben tener assets de tipo SET.\n"
				log += "**************************************************************************************\n\n"
			)--if
			else if (_files.count == 0) then --si no hay archivos avisa con un warning
			(
				state = warningMessage --pone el mensaje de warning
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "No hay archivos de cache de max, es posible que no se hayan creado aún o el path no esté actualizado.\n\n"
				log += "**************************************************************************************\n\n"
			)
		)--executeFN
	)--checkTask_cacheMaxFilesWithoutSETs
	-----------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------
	--comprueba que solo haya point caches de un tipo en los source de cada camara
	struct checkTask_nonEqualSourcePointCacheFileTypes
	(
		id = lb.totalChecker.rollMain.TCH_nonEqualSourcePointCacheFileTypes, --id de la tarea
		name = "Cache: Solo puede haber caches de un tipo (.pc2 o .mc) en los source de la camara", --descripcion de la tarea
		path = "", --path de la camara
		state = #WAITING , --estado del check
		log = "", --log del check
		fixable = false, --indica si el check tiene fix
		precedence = #(), --array de precedencia de checks
		
		maxFiles = #(), --archivos max
		maxFilesInfo = #(), --file info de los archivos max
			
		camSvnInfoLocal = undefined, --para almacenar la informacion de svn de la camara en local
		camSvnInfoNetwork = undefined, --para almacenar la informacion de svn de la camara en red
		
		fn executeFN fix:false =
		(
			_fail = false --flag que indica si el check falla
			log = "" --vacía el log
			state = okMessage --pone el mensaje de ok
			
			--obtiene el path de render
			_filesPath = (path + "cache\\")
				
			_pc2Files = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".pc2"
			_mcFiles = lb.fileIOFunctions.getAllFilesFromSubFolders _filesPath extension:".mc"
			
			if doesFileExist _filesPath then --si existe el path
			(
				if (_pc2Files.count != 0) and (_mcFiles.count != 0) then --comprueba que haya archivos de los dos tipos
				(
					_fail = true --falla
					log += _filesPath + " -> Tiene archivos de tipo '.mc' y '.pc2' en los source.\n"
				)
			)
			else --si no existe puede que no esté creado o que la carpeta de la camara no este actualizada
			(
				_fail = true --falla
				log += _filesPath + " -> No existe. Puede que aún no se haya creado, o que el path de la cámara no esté actualizado.\n"
			)--if else exist
			
			if _fail then --si falla añade informacion de ayuda y error
			(
				state = errorMessage --pone el mensaje de error
				
				--completa el log
				log = "**************************************************************************************\n\n" + log
				log += "\nAYUDA:\n"
				log += "Solo puede haber caches de un tipo en las carpetas source de la camara, '.mc' o '.pc2'.\n"
				log += "**************************************************************************************\n\n"
			)--if			
		)--executeFN
	)--checkTask_nonEqualSourcePointCacheFileTypes
	-----------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta totalChecker.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Total Checker"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 658		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 705		--@var: minRollHeight | Alto mínimo de la herramienta.

		local currentRootPath = "" --path inicial de la herramienta donde buscar camaras
		
		local overallCamResult = #WAITING --estado global inicial para las camaras
		local overallChecksResult = #WAITING --estado global inicial para los checks de cada camara
		
		--mensajes de estado---------------------------------
		local waitingMessage = #WAITING
		local notRequiredMessage = #NOTREQUIRED
		local okMessage = #OK
		local warningMessage = #WARNING
		local precedenceErrorMessage = #PRECEDENCE
		local errorMessage = #ERROR	

		local camTaskList = #() --array para almacenar los struct de tipo camara
		local checkTaskList = #() --array para almacenar los struct de tipo check según el tipo de archivo que se quiera checkear (anim, render...)	

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local dgBackColor = (dotNetClass "System.Drawing.Color").beige								-- fondo
		local dgForeColor = (dotNetClass "System.Drawing.Color").gray								-- texto
		local dgSelBackColor = (dotNetClass "System.Drawing.Color").midnightblue				-- fondo de items seleccionados
		local dgSelForeColor = (dotNetClass "System.Drawing.Color").white							-- texto de items seleccionados
		
		local okColor = (dotNetClass "System.Drawing.Color").fromargb 80 255 80					-- color texto check OK
		local notRequiredColor = (dotNetClass "System.Drawing.Color").fromargb 180 255 115	-- color texto check NOT REQUIRED
		local errorColor = (dotNetClass "System.Drawing.Color").fromargb 255 80 80 				-- color texto error encontrado
		local warningColor = (dotNetClass "System.Drawing.Color").fromargb 250 250 100		-- color texto warning encontrado
		local waitingColor = (dotNetClass "System.Drawing.Color").fromargb 255 189 61			-- color texto waiting task
		local precedenceColor = (dotNetClass "System.Drawing.Color").fromargb 177 70 19		-- color texto precedence task
		
		--ExtraInfo checks
		local TCH_ExtraInfoCorrupt 									=	1
		local TCH_CheckedRenderMaxFiles							=	2
		local TCH_CheckedAnimMaxFiles								=	3
		local TCH_CheckedCacheMaxFiles							=	4
		
		--Naming Convention
		local TCH_NCanimMaxFiles										=	1001
		local TCH_NCanimMaxFilesSeqAndCamOK					=	1002
		local TCH_NCanimMaxFilesAnimRangeAsCamRange		=	1003
		local TCH_NCcacheMaxFilesSeqAndCamOK				=	1004
		local TCH_NCcacheMaxFiles									=	1005
		local TCH_NCrenderMaxFiles 									=	1006
		local TCH_NCpostFusionFiles 									=	1007
		local TCH_NCpostNukeFiles 									=	1008
		local TCH_NCframeFiles 										=	1009
		local TCH_NClpmRootDir 										=	1010
		local TCH_NClpmLayers 										=	1011
		local TCH_NClpmLayersFGMcorrect 						=	1012
		local TCH_NCrenderMaxFilesSeqAndCamOK				=	1013
		local TCH_NCpostFusionFilesSeqAndCamOK 				=	1014
		local TCH_NCpostNukeFilesSeqAndCamOK 				=	1015
		local TCH_NCframeFilesSeqAndCamOK						=	1016
		local TCH_NCcacheMaxFilesAnimRangeAsCamRange	=	1017
		local TCH_NCcacheMaxFilesCamsWithTC					=	1018
		local TCH_NCrenderFxMaxFiles								=	1019
		local TCH_NCFxFrameFiles										=	1020
		local TCH_NCRenderFxMaxFilesSeqAndCamOK			=	1021
		local TCH_NCFxFrameFilesSeqAndCamOK					=	1022
		
		--SVN Checks
		local TCH_SVNanimPathUpdated								=	2001
		local TCH_SVNrenderPathUpdated							=	2002
		local TCH_SVNpostPathUpdated 							=	2003
		local TCH_SVNlocalCachePathUpdated						=	2004
		local TCH_SVNnetworkCachePathUpdated				=	2005
		local TCH_SVNlocalTexturePathUpdated					=	2006
		local TCH_SVNnetworkTexturePathUpdated				=	2007
		local TCH_SVNlocalCachePathUpdated						=	2008
		local TCH_SVNnetworkCachePathUpdated				=	2009
		
		--Max Files Checks
		local TCH_animMaxFilesWithoutLights						=	3001
		local TCH_animMaxFilesWithoutStamps					=	3002
		local TCH_animMaxFilesWithoutLayout						=	3003
		local TCH_cacheMaxFilesWithoutSETs						=	3004
		local TCH_nonEqualSourcePointCacheFileTypes			=	3005
		
		--Bitmap Checks
		local TCH_bitmapsInSequenceTexturePath				=	4001
		local TCH_bitmapsExist											=	4002
		
		--Compo Files Checks
		local TCH_postNukeFilesNodesActive						=	5001
		local TCH_postNukeFilesOutputCorrect					=	5002
		local TCH_postNukeFilesOutputCompression				=	5003
		local TCH_postFusionFilesNodesActive						=	5004
		local TCH_postFusionFilesOutputCorrect					=	5005
		local TCH_postFxFusionFilesOutputCorrect				=	5006
		local TCH_postFxNukeFilesOutputCorrect					=	5007
		local TCH_postNodesFilesExist 								=	5008
		local TCH_postNodesNCOk									=	5009
		local TCH_postNodesCamAndSeqOk						=	5010
		local TCH_postNodesNoFx										=	5011
		local TCH_postWriteNodeOk									=	5012
		local TCH_postFxNodesFilesExist							=	5013
		local TCH_postFxNodesNCOk									=	5014
		local TCH_postFxNodesCamAndSeqOk						=	5015
		local TCH_postFxNodesNoRender							=	5016
		local TCH_compoNodesFilesExist								=	5017
		local TCH_compoNodesNCOk									=	5018
		local TCH_compoNodesCamAndSeqOk						=	5019
		
		
		--Frames Checks
		local TCH_framePathExist										=	6001
		local TCH_frameUsageCoherence							=	6002
		local TCH_NotObsoleteFrames								=	6003
		local TCH_findMissingFrames									=	6004
		local TCH_findCorruptedFrames								=	6005
		local TCH_findReferenceFrames								=	6006
		local TCH_findMissingFxFrames								=	6007
		local TCH_findCorruptedFxFrames							=	6008
		local TCH_framesInCamFolderExist							=	6009
		local TCH_framesInRefFolderExist							=	6010
		local TCH_framesInCamNC										=	6011
		local TCH_framesInRefNC										=	6012
		local TCH_framesInFinalRefExist								=	6013
		local TCH_framesMatchCamAndSeq							=	6014
		local TCH_framesInCamAndRefHaveLayer					=	6015
		local TCH_framesInCamFolderExistInComp				=	6016
		local TCH_framesInFinalFolderNC							=	6017
		local TCH_framesInCamAndFinalCamAndSeqOk			=	6018
		local TCH_framesInCamHaveLayer							=	6019
		local TCH_allFinalFramesRendered							= 	6020
		local TCH_fxFramesInCamFolderExist						=  6021
		local TCH_fxFramesInCamNC									=	6022
		local TCH_fxFramesSeqAndCamOk							=	6023
		local TCH_fxFramesInCamHaveLayer						=	6024
		local TCH_fxFramesInCamFolderExistInComp				=	6025
		local TCH_refCompFramesExist								=	6026
		local TCH_framesInCamFolderExistInCompV2				=	6027		
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		checkbutton ckbOptionAnim "Anim" pos:[5,2] width:108 height:20
		checkbutton ckbOptionCache "Cache" pos:[113,2] width:108 height:20
		checkbutton ckbOptionLighting "Lighting" pos:[221,2] width:108 height:20
		checkbutton ckbOptionRender "Render" pos:[329,2] width:108 height:20
		checkbutton ckbOptionRenderFx "RenderFx" pos:[437,2] width:108 height:20
		checkbutton ckbOptionCompositing "Compositing" pos:[545,2] width:108 height:20
		
		groupBox grpSequenceFolder "" pos:[5,20] width:648 height:45
		label lblSequencePath "Sequence root path:" pos:[10,30] width:100 height:15
		editText edtSequenceRootPath "" pos:[110,30] width:520 height:15
		button btnSequenceRootBrowse "..." pos:[633,31] width:15 height:15
		label lblCamNumberFilters "Cam number filters:" pos:[10,46] width:95 height:15
		editText edtCamNumberFilters "" pos:[110,46] width:520 height:15
		button btnCamHelp "?" pos:[633,47] width:15 height:15
		
		label lblCamList "Cam list:" pos:[6,70] width:50 height:15
		dotNetControl dgCamList "System.Windows.Forms.DataGridView" pos:[5,85] width:324 height:280
		
		label lblCheckList "Check list:" pos:[330,70] width:50 height:15
		dotNetControl dgCheckList "System.Windows.Forms.DataGridView" pos:[330,85] width:324 height:280
		
		button btnCamCheckAll "Check All" pos:[5,365] width:50 height:20
		button btnCamCheckSelected "Check Selected" pos:[55,365] width:80 height:20
		label lblCheckCamResult "Result:" pos:[209,368] width:65 height:15
		dotNetControl txtCheckCamResult "System.Windows.Forms.textBox" pos:[249,365] width:80 height:20 visible:true
		
		button btnCheckAll "Check All" pos:[331,365] width:50 height:20
		button btnCheckSelected "Check Selected" pos:[381,365] width:80 height:20
		button btnFixSelected "Fix Selected" pos:[461,365] width:80 height:20
		label lblCheckResult "Result:" pos:[530,368] width:65 height:15
		dotNetControl txtCheckResult "System.Windows.Forms.textBox" pos:[570,365] width:80 height:20 visible:true
		
		dotNetControl txtLog "System.Windows.Forms.richTextBox" pos:[5,400] width:648 height:300
		
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
		-----------------------------------------------

		------------------------------------------------
		--@fn: undefined | compareChecks | Hace la comparación entre dos checks y devuelve un valor < 0 si el primero es menor y un valor > 0 si el menor es el segundo.
		------------------------------------------------
		fn compareChecks firstCheck secondCheck =
		(
			_result = 0
			if firstCheck.id <= secondCheck.id then
				_result = -1
			else
				_result = 1
		)

		------------------------------------------------
		--@fn: undefined | sortChecks | Reordena los arrays de checks por id.
		------------------------------------------------		
		fn sortChecks = 
		(
			--Ordenamos el check de anim
			qsort parent.checkTaskList_anim compareChecks
			--Ordenamos el check de cache
			qsort parent.checkTaskList_cache compareChecks
			--Ordenamos el check de lighting
			qsort parent.checkTaskList_lighting compareChecks
			--Ordenamos el check de render
			qsort parent.checkTaskList_render compareChecks
			--Ordenamos el check de renderFx
			qsort parent.checkTaskList_renderFx compareChecks
			--Ordenamos el check de renderFx
			qsort parent.checkTaskList_compositing compareChecks
		)

		------------------------------------------------
		--@fn: undefined | initDataGridView | inicializa el gridview de listados
		------------------------------------------------			
		fn initDataGridView dg =
		(
			dg.rows.clear()
			dg.columns.clear()
			
			dg.allowUsertoaddRows = false
			dg.allowUserToResizeRows = false
			dg.allowUserToResizeColumns = true
			
			dg.columnHeadersVisible = false	--para que las colunas tengan titulo
			dg.rowheadersvisible = false		--para que las filas no tengan titulo
			
			dg.foreColor = (dotNetClass "System.Drawing.Color").black
			dg.backgroundcolor = dgForeColor									-- color del fondo
			dg.rowsdefaultcellstyle.backcolor = dgForeColor				-- color por defecto de las celdas
			dg.GridColor = dgForeColor
			
			dg.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5
			
			dg.readonly = true
			dg.showCellTooltips = false
			
			dg.selectionMode = (dotnetClass "System.Windows.Forms.DataGridViewSelectionMode").FullRowSelect
			
			dg.columns.add "" "Cam" --pone una columna
			dg.columns.item[0].width = dgCamList.width - 100 --hace la columna del ancho del listado
			
			dg.columns.add "" "checkState" --pone una columna
			dg.columns.item[1].width = 80 --hace la columna del ancho del listado
		)

		------------------------------------------------
		--@fn: undefined | fillCamList | rellena el listado de camaras del UI con las camaras del array de tareas. Tambien muestra el estado de la tarea.
		------------------------------------------------		
		fn fillCamList =
		(
			dgCamList.rows.clear() --borra las filas
			
			--rocorre las tareas rellenando con su nombre y su estado cada fila
			for i=1 to camTaskList.count do
			(
				--crea una nueva fila---------------------------------------------------------------------
				row = (dotnetobject "System.Windows.Forms.DataGridViewRow")
				row.height = 15
				
				bgColor = dgBackColor
 				row.defaultCellStyle.BackColor = bgColor
				--------------------------------------------------------------------------------------------
				
				--añade la fila-----------------------------------------------------------------------------
				dgCamList.rows.add row
				
				--rellena la fila----------------------------------------------------------------------------
				(dgCamList.item 0 (i-1)).value = camTaskList[i].name + ":    " + camTaskList[i].path --rellena la celda 1 de cada fila con la camara.
				(dgCamList.item 1 (i-1)).value = camTaskList[i].state as string --rellena la celda 2 de cada fila con el estado.
				
				--segun el estado, le pone un color u otro a la celda de estado.
				_cellColor = 	dgBackColor
				case camTaskList[i].state of
				(
					#WAITING:			_cellColor = waitingColor
					#NOTREQUIRED:	_cellColor = notRequiredColor
					#WARNING:			_cellColor = warningColor
					#OK:					_cellColor = okColor
					#ERROR:				_cellColor = errorColor
				)
					
				_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
				_cellStyle.backColor = _cellColor
				_alignment = (dotnetClass "System.Windows.Forms.DataGridViewContentAlignment")
				_cellStyle.Alignment = _alignment.MiddleCenter
				
				(dgCamList.item 1 (i-1)).style = _cellStyle
				
			)--for camTaskList
			
			if dgCamList.rows.count != 0 then (dgCamList.item 0 0).selected = false
		)

		------------------------------------------------
		--@fn: undefined | fillCamListOverallState | calcula el estado global del check de camaras
		------------------------------------------------		
		fn fillCamListOverallState =
		(
			overallCamResult = #WAITING
			
			for i=1 to camTaskList.count do --recorre los tasks
			(
				_camTaskState = camTaskList[i].state --obtiene el estado del task
				
				case _camTaskState of
				(
					#OK:			if overallCamResult == #WAITING then overallCamResult = #OK
					#WARNING:	if overallCamResult == #WAITING or overallCamResult == #OK then overallCamResult = #WARNING
					#ERROR:		overallCamResult = #ERROR
				)--case
			)--for
			
			txtCheckCamResult.text = overallCamResult as string --coloca el texto del estado general
			
			case overallCamResult of --pone el color de fondo al control segun el estado.
			(
				#WAITING:	txtCheckCamResult.backColor = waitingColor
				#OK:			txtCheckCamResult.backColor = okColor
				#WARNING:	txtCheckCamResult.backColor = warningColor
				#ERROR:		txtCheckCamResult.backColor = errorColor
			)--case
		)

		------------------------------------------------
		--@fn: undefined | fillCheckList | rellena el listado de checks y su estado para la camara seleccionada.
		------------------------------------------------		
		fn fillCheckList =
		(
			dgCheckList.rows.clear() --borra las filas
			_currentCamChecks = #() --para almacenar los checks de la fila seleccionada del listado de camaras
			
			if dgCamList.rows.count !=0 then --obtiene el indice de la fila seleccionada y coge los checks correspondientes
			(
				_selIndex = -1
				for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _selIndex = i
				if _selIndex != -1 then _currentCamChecks = camTaskList[_selIndex].checkTasks
			)
			
			--recorre las tareas rellenando con su nombre y su estado cada fila
			for i=1 to _currentCamChecks.count do
			(
				--crea una nueva fila---------------------------------------------------------------------
				row = (dotnetobject "System.Windows.Forms.DataGridViewRow")
				row.height = 15
				
				bgColor = dgBackColor
 				row.defaultCellStyle.BackColor = bgColor
				--------------------------------------------------------------------------------------------
				
				--añade la fila-----------------------------------------------------------------------------
				dgCheckList.rows.add row
				
				--rellena la fila----------------------------------------------------------------------------
				(dgCheckList.item 0 (i-1)).value = ((formattedPrint _currentCamChecks[i].id format:"04d") as string) + ":    " + _currentCamChecks[i].name --rellena la celda 1 de cada fila con la tarea.
				(dgCheckList.item 1 (i-1)).value = _currentCamChecks[i].state as string --rellena la celda 2 de cada fila con el estado.
				
				--segun el estado, le pone un color u otro a la celda de estado.
				_cellColor = 	dgBackColor
				case _currentCamChecks[i].state of
				(
					#WAITING:			_cellColor = waitingColor
					#NOTREQUIRED:	_cellColor = notRequiredColor
					#WARNING:			_cellColor = warningColor
					#OK:					_cellColor = okColor
					#ERROR:				_cellColor = errorColor
					#PRECEDENCE:	_cellColor = precedenceColor
				)
				
				_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
				_cellStyle.backColor = _cellColor
				_alignment = (dotnetClass "System.Windows.Forms.DataGridViewContentAlignment")
				_cellStyle.Alignment = _alignment.MiddleCenter
				(dgCheckList.item 1 (i-1)).style = _cellStyle
				
			)--for camTaskList
			
			if dgCheckList.rows.count != 0 then (dgCheckList.item 0 0).selected = false
		)

		------------------------------------------------
		--@fn: undefined | fillCheckListOverallState | rellena el estado global de los checks de la camara seleccionada
		------------------------------------------------		
		fn fillCheckListOverallState =
		(
			overallChecksResult = #WAITING
			
			_currentCamChecks = #() --para almacenar los checks de la fila seleccionada del listado de camaras
			
			if dgCamList.rows.count !=0 then --obtiene el indice de la fila seleccionada y coge los checks correspondientes
			(
				_selIndex = -1
				for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _selIndex = i
				if _selIndex != -1 then _currentCamChecks = camTaskList[_selIndex].checkTasks
			)
			
			for i=1 to _currentCamChecks.count do --recorre los tasks
			(
				_checkTaskState = _currentCamChecks[i].state --obtiene el estado del task
				
				case _checkTaskState of
				(
					#OK:					if overallChecksResult == #WAITING then overallChecksResult = #OK
					#WARNING:			if overallChecksResult == #WAITING or overallChecksResult == #OK then overallChecksResult = #WARNING
					#PRECEDENCE: 	overallcheckResult = #ERROR
					#ERROR:				overallChecksResult = #ERROR
				)--case
			)--for
			
			txtCheckResult.text = overallChecksResult as string --coloca el texto del estado general
			
			case overallChecksResult of --pone el color de fondo al control segun el estado.
			(
				#WAITING:	txtCheckResult.backColor = waitingColor
				#OK:			txtCheckResult.backColor = okColor
				#WARNING:	txtCheckResult.backColor = warningColor
				#ERROR:		txtCheckResult.backColor = errorColor
			)--case
		)

		------------------------------------------------
		--@fn: undefined | initUI | inicializa los componentes del UI necesarios
		------------------------------------------------		
		fn initUI =
		(
			txtLog.DetectUrls = false --desactiva el uso de urls en el log
			
			_textAlign = (dotNetClass "System.Windows.Forms.HorizontalAlignment")
			txtCheckCamResult.TextAlign = _textAlign.Center
			txtCheckResult.TextAlign = _textAlign.Center
			
			initDataGridView dgCamList
			initDataGridView dgCheckList
		)

		------------------------------------------------
		--@fn: undefined | filterFiles | filtra un array de archivos pasados por parametro. Devuelve el array filtrado.
		------------------------------------------------		
		fn filterFiles files filters filterMode:#or =
		(
			_filteredFiles = deepCopy files
			
			if classof filters != Array then filters = #() --si el parametro filters no es del tipo correcto lo sobreescribe con un array vacio.
			
			if _filteredFiles.count != 0 then --si hay archivos con los que trabajar
			(
				if filters.count != 0 then --si hay filtros
				(
					for i=_filteredFiles.count to 1 by -1 do --recorre los archivos en orden inverso
					(
						_delete = false --flag para saber si eliminar el archivo del listado
							
						case filterMode of
						(
							#or:
							(
								_filterFound = false --flag para saber si el archiv cumple alguno de los filtrols
								
								for fp in filters where not _filterFound and findString _filteredFiles[i] fp != undefined do
									_filterFound = true
								
								_delete = not _filterFound --si no cumple ningun filtro lo marca para eliminar
							)--or
							
							#and:
							(
								for fp in filters where findString _filteredFiles[i] fp == undefined do
									_delete = true
							)--and
						)--case
						
						if _delete then deleteItem _filteredFiles i --elimina el archivo del listado
					)--for _filteredFiles					
				)--if filters
			)--if _filteredFiles
			
			_filteredFiles
		)

		------------------------------------------------
		--@fn: undefined | getSequenceCamList | busca las carpetas cam de una secuencuia y las devuelve en un array
		------------------------------------------------		
		fn getSequenceCamList sequenceRootPath =
		(
			_camPaths = #()
			
			--_ignoreList = #("anim", "cache", "cloth", "frame", "fx", "hair", "layout", "post", "reference", "render", "sound", "storyboard", "texture", "video")
			_subFolders = lb.fileIOFunctions.getAllSubfolders sequenceRootPath --ignoreList:_ignoreList
			
			--recolecta los subfolders de tipo camara
			_camPaths = for sf in _subFolders where matchPattern sf pattern:"Z:\\sequence\\seq_???*\\cam\\cam???\\" collect sf
			
			---------------------------------------------------------------------------------------------------------------
			--si se ha puesto filtros de camaras, solo nos quedamos las que coincidan-------------------------------
			_camFilters = filterString edtCamNumberFilters.text ",; " --obtiene los filtros de camara
			
			if _camFilters.count != 0 then --si hay filtros
			(
				for i=_camPaths.count to 1 by -1 do --recorre los paths de las camaras
				(
					cp = _camPaths[i]
					
					_camNumber = (substituteString ((filterString cp "\\")[(filterString cp "\\").count]) "cam" "") as integer --obtiene el numero de la camara
					
					_found = false --flag para saber si la camara esta dentro de los filtros
					
					for _camFilter in _camFilters where not _found do
					(
						if lb.math.isNumeric _camFilter then --si es numerico, mira a ver si coincide con la camara
						(
							if (_camFilter as integer) == _camNumber then _found = true --si coincide la da por encontrada
						)							
						else --si no es numerico puede ser un rango de camaras. Ej: 050-110
						(
							_rangeLimits = filterString _camFilter "-" --divide el rango
							
							--si no tiene dos partes, minimo y maximo, no puede ser un rango.
							--si los limites no son numericos tampoco puede ser un rango
							if _rangeLimits.count == 2 and lb.math.isNumeric _rangeLimits[1] and lb.math.isNumeric _rangeLimits[2] then
							(
								if (_rangeLimits[1] as integer) <= _camNumber and _camNumber <= (_rangeLimits[2] as integer) then
									_found =  true
							)--if
						)--if else
					)--for
					
					if not _found then deleteItem _camPaths i --si no cumple los filtros lo elimina
				)--for
			)--if
			---------------------------------------------------------------------------------------------------------------
			
			_camPaths
		)

		------------------------------------------------
		--@fn: undefined | fillCheckTaskList | rellena el array de structs de checks según el tipo de archivo sobre el que se quieran pasar los checks
		------------------------------------------------		
		fn fillCheckTaskList =
		(
			_checkFileTypeOption = ""
			
			if ckbOptionAnim.checked then _checkFileTypeOption = "anim"
			if ckbOptionCache.checked then _checkFileTypeOption = "cache"
			if ckbOptionLighting.checked then _checkFileTypeOption = "lighting"
			if ckbOptionRender.checked then _checkFileTypeOption = "render"
			if ckbOptionRenderFx.checked then _checkFileTypeOption = "renderFx"
			if ckbOptionCompositing.checked then _checkFileTypeOption = "compositing"
			
			
			case _checkFileTypeOption of
			(
				"anim": checkTaskList = parent.checkTaskList_anim --rellena el array de checks con los checks de animacion
				"cache": checkTaskList = parent.checkTaskList_cache --rellena el array de checks con los checks de caches
				"lighting": checkTaskList = parent.checkTaskList_lighting --rellena el array de checks con los checks de lighting
				"render": checkTaskList = parent.checkTaskList_render -- rellena el array de checks con los checks de render
				"renderFx": checkTaskList = parent.checkTaskList_renderFx -- rellena el array de checks con los checks de renderFx
				"compositing": checkTaskList = parent.checkTaskList_compositing -- rellena el array de checks con los checks de compositing
				default: checkTaskList = parent.checkTaskList_lighting --por omisión rellena el array de checks con los checks de lighting
			)--case
			
			-- 			for i=1 to checkTaskList.count do checkTaskList[i].id = i --rellena el array de Ids con numeros consecutivos
		)

		------------------------------------------------
		--@fn: undefined | fillCamTaskList | rellena el array de structs de camara con la informacion inicial, a partir de un array de paths de camaras
		------------------------------------------------		
		fn fillCamTaskList camPathArray =
		(
			camTaskList = #() --vacia el array de structs de tareas de camara
			
			for cp in camPathArray do
			(
				_camName = (filterString cp "\\")[(filterString cp "\\").count] --obtiene el nombre de la camara

				_camTask = parent.camT name:_camName path:cp checkTasks:(deepCopy checkTaskList) --rellena el struct de camara con sus checks preparados
				for check in _camTask.checkTasks do check.path = _camTask.path --almacena dentro de cada check la informacion de la propia camara
				
				append camTaskList _camTask
			)--for
			
			camTaskList --devuelve el array
		)

		------------------------------------------------
		--@fn: undefined | updateFixButtonState | actualiza el estado del boton de fix
		------------------------------------------------		
		fn updateFixButtonState =
		(
			_camIndex = 0
			_index = 0
			
			--averigua el indice de la camara actual y del check
			if dgCamList.SelectedRows.count > 0 then _camIndex = dgCamList.SelectedRows.item[0].index + 1
			if dgCheckList.SelectedRows.count > 0 then _index = dgCheckList.SelectedRows.item[0].index + 1
			
			if _camIndex != 0 and _index != 0 then
			(
				--decide si debe tener fix o no
				_hasFix = (camTaskList[_camIndex].checkTasks[_index].fixable and (camTaskList[_camIndex].checkTasks[_index].state == errorMessage))
				
				/*--hay algunos fix que son muy peligrosos, y dependen de que otros checks esten OK
				if ckbOptionLighting.checked then --si son los checks de render
				(
					case _index of --mira que check es
					(
						TCH_NotObsoleteFrames: --si es el check TCH_NotObsoleteFrames, depende del check: 2002, 2003, 6001, 5001, 5004
						(
							if _hasFix then _hasFix = (camTaskList[_camIndex].checkTasks[TCH_SVNrenderPathUpdated].state == okMessage)
							if _hasFix then _hasFix = (camTaskList[_camIndex].checkTasks[TCH_SVNpostPathUpdated].state == okMessage)
							if _hasFix then _hasFix = (camTaskList[_camIndex].checkTasks[TCH_framePathExist].state == okMessage)
							if _hasFix then _hasFix = (camTaskList[_camIndex].checkTasks[TCH_postNukeFilesNodesActive].state == okMessage)
							if _hasFix then _hasFix = (camTaskList[_camIndex].checkTasks[TCH_postFusionFilesNodesActive].state == okMessage)							
						)-----------------------------------------------------------------
					)--case
				)--if ckbOptionLighting*/
					
				--aplica el resultado	
				btnFixSelected.enabled = _hasFix
			)--if
		)

		------------------------------------------------
		--@fn: undefined | resetUI | inicia el UI de la herramienta
		------------------------------------------------	
		fn resetUI =
		(
			_camList = getSequenceCamList edtSequenceRootPath.text --obtiene los paths de las camaras de la secuencia
			
			fillCheckTaskList() --rellena el array de checks para las camaras
			fillCamTaskList _camList --rellena el array de tareas de path de camara
			
			fillCamList() --rellena el listado de camaras
			if dgCamList.rows.count != 0 then (dgCamList.item 0 0).selected = true --selecciona la primera camara
			fillCamListOverallState() --rellena el estado general de camaras
			
			fillCheckList() --rellena el listado de checks
			if dgCheckList.rows.count != 0 then (dgCheckList.item 0 0).selected = true --selecciona la primera tarea
			fillCheckListOverallState() --rellena el estado general de checks
		)

		------------------------------------------------
		--@fn: undefined | checkSequenceNC | comprueba que el path pasado por parametro cumple el NC de secuencia
		------------------------------------------------		
		fn checkSequenceNC sequencePath showMessageBox:true =
		(
			_success = true
			
			--mira a ver si cumple el patron de path de secuencia
			--se ha añadido tambien el patron de los tipos de secuencia fuera de producción (seq_xxx-???)
			_success = (matchPattern sequencePath pattern:"Z:\\sequence\\seq_???") or (matchPattern sequencePath pattern:"Z:\\sequence\\seq_????")
			if not _success then _success = (matchPattern sequencePath pattern:"Z:\\sequence\\seq_???-???") or (matchPattern sequencePath pattern:"Z:\\sequence\\seq_????-???")
			
			if _success then --si cumple el patron hay que comprobar alguna cosa más.
			(
				_seqNumber = substituteString sequencePath "Z:\\sequence\\seq_" ""
				
				if _seqNumber.count == 3 then --si tiene 3 cifras ha de ser numerico
					_success = lb.math.isNumeric _seqNumber --debe ser numerica
				else --si tiene 4 cifras, las 3 primeras han de ser numericas y la 4 no
					_success = (lb.math.isNumeric ((_seqNumber[1]) + (_seqNumber[2]) + (_seqNumber[3]))) and (not lb.math.isNumeric (_seqNumber[4]))
			)
			
			if not _success and showMessageBox then
				lb.message.show (sequencePath + " -> no cumple el naming convention de raiz de una secuencia.\nEjemplo:'Z:\\sequence\\seq_082'") type:#message pos:undefined size:[600,75] modal:true
			
			_success
		)

		------------------------------------------------
		--@fn: undefined | checkPrecedence | Pasa todos los checks precedentes al que tengamos, para ver si éste puede ser pasado.
		------------------------------------------------		
		fn checkPrecedence checkTask taskList =
		(
			_result = true
			
			--Si el check tiene algún precedente entonces
			if checkTask.precedence.count > 0 then
			(
				checkTask.log = "*************************************************************\n"
				checkTask.log += "** Este check necesita que se pasen los siguientes checks antes de ser lanzado:\n"
				
				--Por cada precedente que tenga
				for i=1 to checkTask.precedence.count do
				(
					--Lo buscaremos en la lista de tareas y si su estado es distinto a OK, ya no pasaremos el test de precedencia.
					for j=1 to taskList.count do
					(
						if taskList[j].id == checkTask.precedence[i] then
						(
							if taskList[j].state != #OK and taskList[j].state != #WARNING then
							(
								checkTask.log += "-> " + taskList[j].id As String + ": " + taskList[j].name + "\n"
								
								_result = false
							)
						)
					)
				)
				
				checkTask.log += "*************************************************************\n"
			)
			
			--Si ha pasado el test borramos el log
			if _result then
			(
				checkTask.log = ""
				checkTask.state = #WAITING
			)
			else
			(
				checkTask.state = #PRECEDENCE
			)
			
			--Devolvemos la tarea
			checkTask
		)

		------------------------------------------------
		--@fn: undefined | makeCheck | Pasa el check. averigua el estado de un check pasado por parametro
		------------------------------------------------				
		fn makeCheck checkTask taskList fix:false =--maxFiles:#() maxFilesInfo:#() =
		(
			checkTask = checkPrecedence checkTask taskList
			--Primero miraremos si los precedentes están a ok.
			if checkTask.state != #precedence then
			(
				if not checkTask.fixable then fix = false
				checkTask.executeFN fix:fix --checkTask --pasa el check
			)
			else
			(
				checkTask.state = #precedence
			)
			checkTask --devuelve el check modificado
		)

		------------------------------------------------
		--@fn: undefined | makeCamChecks | Pasa los checks. averigua el estado de la tarea de camara pasada por parametro
		------------------------------------------------		
		fn makeCamChecks camTask fillProgressBar:false =
		(
			camTask.state = waitingMessage --resetea el estado de la tarea de la camara a la espera
			
			if fillProgressBar then txtLog.text = ""
			
			--------------------------------------------------------------------------
			--Hay que obtener primero los fileInfo de los .max, para que no lo haga despues por cada check y pierda tiempo
			
			--paths de la camara que pueden contener archivos .max
			_animPath = camTask.path + "anim\\"
			_cachePath = camTask.path + "cache\\"
			_renderPath = camTask.path + "render\\"
			
			--segun el tipo de archivo al que queramos pasar los checks busca los max en una carpeta u otra
			_searchPath = if ckbOptionAnim.checked then _animPath else if ckbOptionCache.checked then _cachePath else _renderPath
			_maxFiles = lb.fileIOFunctions.getAllFilesFromSubFolders _searchPath extension:".max"
			
			if _searchPath == _renderPath then
			(
				--Primero haremos la criba de archivos que estén en la carpeta history.
				for i=_maxFiles.count to 1 by -1 do
					if findItem (filterString (getFilenamePath _maxFiles[i]) "\\") "history" != 0 then
						deleteItem _maxFiles i
				
				--Si estamos en renderFx quitaremos de la llista todos los de render.
				if ckbOptionRenderFx.checked then
				(
					for i = _maxFiles.count to 1 by -1 do
						if matchPattern (getFilenameFile _maxFiles[i]) pattern:"*_render_*" then
							deleteItem _maxFiles i
				)
				else
				(
					for i = _maxFiles.count to 1 by -1 do
						if matchPattern (getFilenameFile _maxFiles[i]) pattern:"*_renderFx_*" then
							deleteItem _maxFiles i
				)
			)
			
			
			_maxFilesInfo = #()
			_maxFilesInfo = for mf in _maxFiles collect getFileInfo mf
			
			--rellena los parametros de maxfiles y maxfilesInfo de la camara
			camTask.maxFiles = _maxFiles
			camTask.maxFilesInfo = _maxFilesInfo
			--------------------------------------------------------------------------
			
			--------------------------------------------------------------------------
			--averigua el svnInfo para no hacerlo despues por cada check que lo requiera
			-- 			_svnInfo = lb.svn.svnGetFolderStatus camTask.path donotwait:true sleepTime:0.5
			-- 			_svnInfoNetwork = lb.svn.svnGetFolderStatus (substituteString (tolower camTask.path) "z:" @"\\lbdata001\z") donotwait:true sleepTime:0.5
			-- 			
			-- 			camTask.camSvnInfoLocal = _svnInfo
			-- 			camTask.camSvnInfoNetwork = _svnInfoNetwork
			--------------------------------------------------------------------------
			
			for i=1 to camTask.checkTasks.count do --ejecuta todos los checks para esa camara
			(
				--rellena los parametros de maxfiles y maxfilesInfo de los checks de la camara
				camTask.checkTasks[i].maxFiles = _maxFiles
				camTask.checkTasks[i].maxFilesInfo = _maxFilesInfo
				
				--rellena los parametros de svn de los checks de la camara
			-- 				camTask.checkTasks[i].camSvnInfoLocal = _svnInfo
			-- 				camTask.checkTasks[i].camSvnInfoNetwork = _svnInfoNetwork
			-- 				if i==28 or i==29 or i==30 then
			-- 				(
			-- 					print "******************"
			-- 					print camTask.checkTasks[28].state
			-- 					print camTask.checkTasks[28].name
			-- 					
			-- 					print "******************"
			-- 					print camTask.checkTasks[29].state
			-- 					print camTask.checkTasks[29].name 					
			-- 				)
				--ejecuta el check y lo sobreescribe con el resultado
				camTask.checkTasks[i] = makeCheck camTask.checkTasks[i] camTask.checkTasks --maxFiles:_maxFiles maxFilesInfo:_maxFilesInfo
				
				--segun el estado del check que se va devolviendo, se rellena el estado de la camara en conjunto
				_taskState = camTask.checkTasks[i].state
				case camTask.state of --rellena con orden de precedencia el estado de la camara
				(
					waitingMessage: camTask.state = _taskState
					okMessage: if _taskState == errorMessage or _taskState == warningMessage then camTask.state = _taskState
					warningMessage: if _taskState == errorMessage then camTask.state = _taskState
					notRequiredMessage: if _taskState != waitingMessage then camTask.state = _taskState
				)--case
				
				if fillProgressBar then txtLog.text = "********************* " + (formattedPrint (((100.0/camTask.checkTasks.count)*i) as integer) format:"02d") + "% *********************" --rellena el progreso
			)--for
			
			camTask --devuelve la tarea de camara rellena con la informacion
		)

		------------------------------------------------
		--@fn: undefined | makeCamChecks_old | averigua el estado de la tarea de camara pasada por parametro
		------------------------------------------------		
		fn makeCamChecks_old camTask =
		(
			camTask.log = ""
			camTask.state = #OK --pone el estado a OK por defecto
			
			struct filePathInfo --struct para almacenar la informacion
			(
				name = "",						--nombre
				filePath = "",					--path completo
				sourceFile = "",				--archivo de origen donde se esta usando el path
				maxFile = #(),				--archivo max del que ha salido el path
				matchNC = false,				--indica si cumple el naming convention para ese tipo de path
				matchSeq = false,			--indica si la secuencia del path coincide con la de la ruta donde esta almacenado el archivo
				matchCam = false,			--indica si la camara del path coincide con la de la ruta donde esta almacenado el archivo
				isLPMpath = false,			--indica si el output es de una capa de LPM
				isRenderElement = false,	--indica si el output es de una capa de LPM
				isComLoader = false			--indice si es un output utilizado en una composicion
			)
			
			--define los paths dentro de la carpeta cam, de donde obtener la informacion de capas, frames...
			--_framePath = camTask.path + "frame\\"
			--_finalFramePath = camTask.path + "frame\\final\\"
			_framePath = substituteString camTask.path "Z:\\sequence" "\\\\lbdata001\\Z\\frame"
			_finalFramePath = _framePath + "final\\"
			--_framePattern = lb.nc.NC_seqFramePathPattern + lb.nc.NC_seqFrameNamePattern --"seq_???*_cam???_render_*_????.*"
			_framePattern = lb.nc.NC_seqFramePathPattern + "seq_???*_cam???_render_*_*.*"
			_maxRenderFilePattern = lb.nc.NC_seqRenderPathPattern + lb.nc.NC_seqRenderNamePattern --"seq_???*_cam???_render_*.max"
			_postPath = camTask.path + "post\\"
			_renderPath = camTask.path + "render\\"
			_seq = "" --variable para almacenar la secuencia
			_cam = "" --variable para almacenar la camaran
			
			------------------------------------------------------------------------------------
			--busca la secuencia y la camara en el path
			------------------------------------------------------------------------------------
			_renderPathParts = filterString _renderPath "\\"
			_seq = _renderPathParts[3]
			_cam = _renderPathParts[5]
			------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------
			--obtiene la información de capas de LPM y de render elements de los .max de la carpeta render.
			------------------------------------------------------------------------------------
			_renderMaxFiles = getFiles (_renderPath+ "*.max") --obtiene todos los max
			_ncFailMaxFiles = #() --ficheros de max que no cuplen el ncaming convention
			_renderElementsOutputs = #() --array para almaceanr todos los outputs de render elements
			_LPMoutputs = #() --array para almacenar todos los outputs de LPM
			
			for rmf in _renderMaxFiles do --recorre los .max
			(
				if not matchPattern rmf pattern:_maxRenderFilePattern then --si no cumple el naming convention el archivo max
					append _ncFailMaxFiles rmf
				else --si cumple el naming convention recopila el resto de informacion
				(
					_outPutsNames = getFileInfoRenderElementsNames rmf --obtiene los nombres de los renderElements
					_outPuts = getFileInfoRenderElementsOutputs rmf --ontiene los renderElements
					
					for i=1 to _outPuts.count do --recorre los outputs obtenidos y los almacena
						append _renderElementsOutputs (filePathInfo name:_outPutsNames[i] filePath:_outPuts[i] sourceFile:rmf maxFile:#((getFileNameFile rmf + getFileNameType rmf)) matchNC:(matchPattern _outPuts[i] pattern:_framePattern) matchSeq:(findString (getFileNameFile _outPuts[i]) (_seq + "_") != undefined) matchCam:(findString (getFileNameFile _outPuts[i]) ("_" + _cam) != undefined) isRenderElement:true)
					
					_outPutsNames = getFileInfoLPMpasses rmf --obtiene los nombres de los pases de LPM
					_outPuts = getFileInfoLPMpassesOutputs rmf --obtiene los pases de LPM
					
					for i=1 to _outPuts.count do --recorre los outputs obtenidos y los almacena
						append _LPMoutputs (filePathInfo name:_outPutsNames[i] filePath:_outPuts[i] sourceFile:rmf maxFile:#((getFileNameFile rmf + getFileNameType rmf)) matchNC:(matchPattern _outPuts[i] pattern:_framePattern) matchSeq:(findString (getFileNameFile _outPuts[i]) (_seq + "_") != undefined) matchCam:(findString (getFileNameFile _outPuts[i]) ("_" + _cam) != undefined) isLPMpath:true)
				)--if else
			)--for
			------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------
			--obtiene la información de los frames que hay en la carpeta frame de la camara
			------------------------------------------------------------------------------------
			_camFrameFiles = getFiles (_framePath+ "*.*") --obtiene todos los frames
			for i = _camFrameFiles.count to 1 by -1 where matchPattern (tolower _camFrameFiles[i]) pattern:"*thumbs.db" do deleteItem _camFrameFiles i
			_frameFiles = #() --array para almacenar los frames
			
			for i=1 to _camFrameFiles.count do --recorre los frames
				append _frameFiles (filePathInfo name:(getFileNameFile _camFrameFiles[i]) filePath:_camFrameFiles[i] matchNC:(matchPattern _camFrameFiles[i] pattern:_framePattern) matchSeq:(findString (getFileNameFile _camFrameFiles[i]) (_seq + "_") != undefined) matchCam:(findString (getFileNameFile _camFrameFiles[i]) ("_" + _cam) != undefined))
				
			for i=1 to _frameFiles.count where _frameFiles[i].matchNC do --recorre los validos y quita el numero de frame del path
			(
				_frameParts = filterString (getFileNameFile _frameFiles[i].filePath) "_" --divide las partes
				if _frameParts.count == 6 then
				(
					_frameFiles[i].name = substituteString (getFileNameFile _camFrameFiles[i]) _frameParts[6] "" --quita la parte 6, es decir el numero de frame
					_frameFiles[i].filePath = substituteString _frameFiles[i].filePath (_frameParts[6] + ".") "." --quita la parte 6, es decir el numero de frame
				)--if
			)--for
			
			--elimina los elementos duplicados del array
			for i=_frameFiles.count to 2 by -1 where _frameFiles[i].filePath == _frameFiles[i-1].filePath do
				deleteItem _frameFiles i
			
			--_frameFiles = makeUniqueArray _frameFiles --elimina los elementos duplicados del array
			------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------
			--lee los archivos .comp de fusion para en ver los loader que paths usan
			------------------------------------------------------------------------------------
			_compFiles = getFiles (_postPath+ "seq_???*_cam???_post_v??.comp") --obtiene todos los .comp
			
			--solo tenemos que comprobar un comp, el que cumpla el NC de comp y tenga el ultimo numero de version.
			_index = 0
			_maxVersion = -1
			
			for i=1 to _compFiles.count do
			(
				_version = (substituteString (filterString (getFileNameFile _compFiles[i]) "_")[(filterString (getFileNameFile _compFiles[i]) "_").count] "v" "") as integer
				if _version > _maxVersion then (_maxVersion = _version; _index = i)
			)--for
			
			if _index != 0 then _compFiles = #(_compFiles[_index]) else _compFiles = #()			
			
			_ncFailCompFiles = getFiles (_postPath+ "*.comp") --obtiene todos los .comp que no cumplen el NC
			if _compFiles.count != 0 then for i=_ncFailCompFiles.count to 1 where _ncFailCompFiles[i] == _compFiles[1] do deleteItem _ncFailCompFiles i
			
			_loaderNodes = #() --array para almacenar los paths a los que aapuntan los nodos loader
			
			for cmp in _compFiles do --recorre los archivos de comp buscando los paths de loader
			(
				f = openFile cmp mode:"r" --intenta abrir el fichero comp en modo lectura
				
				if f != undefined then --si consigue abrir el fichero
				(
					_stop = false --restauramos el flag de stop para volver a usarlo
					_lookingForLoader = true --flag para saber si se esta buscando un loader
					_lookingForPath = false --flag para saber si se esta buscando el path de un loader
					_currLoader = undefined
					
					while not _stop and not eof f do --recorre el archivo linea a linea
					(
						l = readLine f --lee una linea nueva
						
						if _lookingForLoader then --esta buscando un loader
						(
							if matchPattern l pattern:"*= Loader {*" then --detecta el inicio de un bloque de loader
							(
								--prepara los flags para ponerse a buscar el path del loader
								_lookingForLoader = false
								_lookingForPath = true
								
								--almacena el nombre del loader y el .comp en el que está
								_currLoader = undefined
								_loaderName = (substituteString (filterString l "=")[1] " " "")
								_loaderName = (substituteString (filterString l "=")[1] "	" "")
								_currLoader = filePathInfo name:_loaderName sourceFile:cmp maxFile:#((getFileNameFile cmp + getFileNameType cmp)) isComLoader:true
							)--if
						)							
						else if _lookingForPath then --esta buscando el path de un loader
						(
							if matchPattern l pattern:"*Filename =*" then --detecta el path de un loader
							(
								--prepara los flags para ponerse a buscar un nuevo loader
								_lookingForLoader = true
								_lookingForPath = false
								
								--almacena el path del loader
								_loaderPath = (getFileNamePath (filterString l "\"")[2]) + (getFileNameFile (filterString l "\"")[2]) + (getFileNameType (filterString l "\"")[2]) --obtiene el nombre del loader
								_loaderPath = substituteString _loaderPath "\\\\" "\\"
								
								_nParts = filterString (getFileNameFile _loaderPath) "_" --lo divide en partes "_"
								if _nParts.count == 6 then _loaderPath = substituteString _loaderPath _nParts[6] "" --si el path tiene numero de frame lo quita
								
								_currLoader.filePath = _loaderPath --almacena el loader
								
								_currLoader.matchNC = (matchPattern _currLoader.filePath pattern:_framePattern)
								_currLoader.matchSeq = (findString (getFileNameFile _currLoader.filePath) (_seq + "_") != undefined)
								_currLoader.matchCam = (findString (getFileNameFile _currLoader.filePath) ("_" + _cam) != undefined)
								
								append _loaderNodes _currLoader --guarda el loader en el array de loaders
							)--if
						)--if else
						
						if matchPattern l pattern:"*Views = {*" then _stop = true --para saber si han acabado las tools
					)--while
				)--if
				
				close f --cierra el archivo
			)--for
			------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------
			--se rellena el estado de la camara y el log en caso de fallar.
				
			------------------------------------------------------------------------------------
			if _frameFiles.count == 0 or _renderMaxFiles.count == 0 or _compFiles.count == 0 then
			(
				camTask.state = #ERROR
				camTask.log += "************************EXISTENCIA DE ARCHIVOS********************************\n"
			)
			
			--si no hay frames en la carpeta frame, lo dice en el log
			if _frameFiles.count == 0 then
			(
				camTask.state = #ERROR
				camTask.log += "------------------------------------------------------------------------\n"
				camTask.log += "No hay frames en la carpeta de frame.\n"
				camTask.log += "------------------------------------------------------------------------\n"
			)--if
			
			------------------------------------------------------------------------------------
			--si no hay .max en la carpeta render lo dice en el log
			if _renderMaxFiles.count == 0 then
			(
				camTask.state = #ERROR
				camTask.log += "------------------------------------------------------------------------\n"
				camTask.log += "No hay archivos .max en la carpeta render.\n"
				camTask.log += "------------------------------------------------------------------------\n"
			)--if
				
			--si no hay .comp en la carpeta post, lo dice en el log
			if _compFiles.count == 0 then
			(
				camTask.state = #ERROR
				camTask.log += "------------------------------------------------------------------------\n"
				camTask.log += "No hay archivo .comp en la carpeta post o los que hay no cumplen el naming convention.\n"
				camTask.log += "------------------------------------------------------------------------\n"
			)--if
			------------------------------------------------------------------------------------			
			
			------------------------------------------------------------------------------------
			--log para los frames
			if _frameFiles.count != 0 then --si no hay frames no comprueba nada
			(
				camTask.log += "\n\n*******************************FRAMES***************************************\n"
				_overallFail = false --si uno falla almacena que esa seccion ha fallado
				
				for frm in _frameFiles do
				(
					_errorPartMessage = "\tINCORRECTO:\n"
					_okPartMessage = "CORRECTO:\n"
					_fail = false --flag que indica si hay algun parametro que falla.
						
					-----------------------------------------------------------------
					--comprueba el naming convention
					if not frm.matchNC then
					(
						_fail = true
						_errorPartMessage += "\t\tNo cumple el naming convention.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--comprueba la secuencia
					if not frm.matchSeq then
					(
						_fail = true
						_errorPartMessage += "\t\tEl numero de secuencia del nombre del frame no coincide con la de la ruta de la secuencia.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--comprueba la camara
					if not frm.matchCam then
					(
						_fail = true
						_errorPartMessage += "\t\tEl numero de camara del nombre del frame no coincide con la de la ruta de la camara.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--averigua si viene de un output o no				
					_found = false --flag para saber si ha encontrado un output.	
					
					for opt in (_LPMoutputs + _renderElementsOutputs) where not _found do --recorre los outputs
						if (tolower frm.filePath) == (tolower opt.filePath) then _found = true
						
					if not _found then
					(
						_fail = true
						_errorPartMessage += "\t\tNo procede de ningun output de max (LPM pass/Render element).'Puede que esté obsoleto'.\n"
					)--if
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--averigua si se está usando en un loader de fusion o no
					_found = false --flag para saber si ha encontrado un output.	
					
					for opt in _loaderNodes where not _found do --recorre los outputs
						if (tolower frm.filePath) == (tolower opt.filePath) then _found = true
						
					if not _found then
					(
						_fail = true
						_errorPartMessage += "\t\tNo está cargado en ningún loader del archivo de composicion (*.comp).'Puede que esté obsoleto o que el archivo de composicion no haya sido creado aún'.\n"
					)--if
					-----------------------------------------------------------------
					
					if _fail then 
					(
						camTask.state = #ERROR
						_overallFail = true
						
						camTask.log += "-----------------------------------------------------------------------------\n"
						camTask.log += frm.filePath + "\n"
						camTask.log += _errorPartMessage
					)--if
				)--for
				
				--si ha fallado alguno de esta seccion
				if not _overallFail then camTask.log += "Todo OK.\n"
			)--if _frameFiles.count != 0
			------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------
			--log para los LPM passes
			if _LPMoutputs.count != 0 then --si no hay LPM passes no comprueba nada
			(
				camTask.log += "\n\n*****************************LPM PASSES**************************************\n"
				_overallFail = false --si uno falla almacena que esa seccion ha fallado
				
				for frm in _LPMoutputs do
				(
					_errorPartMessage = "\tINCORRECTO:\n"
					_okPartMessage = "CORRECTO:\n"
					_fail = false --flag que indica si hay algun parametro que falla.
						
					-----------------------------------------------------------------
					--comprueba el naming convention
					if not frm.matchNC then
					(
						_fail = true
						_errorPartMessage += "\t\tNo cumple el naming convention.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--comprueba la secuencia
					if not frm.matchSeq then
					(
						_fail = true
						_errorPartMessage += "\t\tEl numero de secuencia del LPM PASS no coincide con la de la ruta de la secuencia.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--comprueba la camara
					if not frm.matchCam then
					(
						_fail = true
						_errorPartMessage += "\t\tEl numero de camara del LPM PASS no coincide con la de la ruta de la camara.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--averigua si se ha hecho el render o no
					_found = false --flag para saber si hay un frame equivalente al pase
					
					for opt in _frameFiles where not _found do --recorre los frames
						if (tolower frm.filePath) == (tolower opt.filePath) then _found = true
						
					if not _found then
					(
						_fail = true
						_errorPartMessage += "\t\tNo hay ningun frame en la carpeta frame que coincida con este pase.'Puede que esté obsoleto o que no se haya hecho el render aún'.\n"
					)--if
					-----------------------------------------------------------------
					
					if _fail then 
					(
						camTask.state = #ERROR
						_overallFail = true
						
						camTask.log += "-----------------------------------------------------------------------------\n"
						camTask.log += frm.maxFile[1] + " :\n" + frm.filePath + "\n"
						camTask.log += _errorPartMessage
					)--if
				)--for
				
				--si ha fallado alguno de esta seccion
				if not _overallFail then camTask.log += "Todo OK.\n"
			)--if _LPMoutputs.count != 0
			------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------
			--log para los render elements
			if _renderElementsOutputs.count != 0 then --si no hay render elements no comprueba nada
			(
				camTask.log += "\n\n***************************RENDER ELEMENTS************************************\n"
				_overallFail = false --si uno falla almacena que esa seccion ha fallado
				
				for frm in _renderElementsOutputs do
				(
					_errorPartMessage = "\tINCORRECTO:\n"
					_okPartMessage = "CORRECTO:\n"
					_fail = false --flag que indica si hay algun parametro que falla.
						
					-----------------------------------------------------------------
					--comprueba el naming convention
					if not frm.matchNC then
					(
						_fail = true
						_errorPartMessage += "\t\tNo cumple el naming convention.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--comprueba la secuencia
					if not frm.matchSeq then
					(
						_fail = true
						_errorPartMessage += "\t\tEl numero de secuencia del render element no coincide con la de la ruta de la secuencia.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--comprueba la camara
					if not frm.matchCam then
					(
						_fail = true
						_errorPartMessage += "\t\tEl numero de camara del render element no coincide con la de la ruta de la camara.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--averigua si se ha hecho el render o no
					_found = false --flag para saber si hay un frame equivalente al render element
					
					for opt in _frameFiles where not _found do --recorre los frames
						if frm.filePath == opt.filePath then _found = true
						
					if not _found then
					(
						_fail = true
						_errorPartMessage += "\t\tNo hay ningun frame en la carpeta frame que coincida con este render element.'Puede que esté obsoleto o que no se haya hecho el render aún'.\n"
					)--if
					-----------------------------------------------------------------
					
					if _fail then 
					(
						camTask.state = #ERROR
						_overallFail = true
						
						camTask.log += "-----------------------------------------------------------------------------\n"
						camTask.log += frm.maxFile[1] + " :\n" + frm.filePath + "\n"
						camTask.log += _errorPartMessage
					)--if
					
						
				)--for
				
				--si ha fallado alguno de esta seccion
				if not _overallFail then camTask.log += "Todo OK.\n"			
			)--if _renderElementsOutputs.count != 0
			------------------------------------------------------------------------------------
				
			------------------------------------------------------------------------------------
			--log para los loader de los comp de fusion
			if _loaderNodes.count != 0 then --si no hay comp files no comprueba nada
			(
				camTask.log += "\n\n**************************COMP FILE LOADERS***********************************\n"
				_overallFail = false --si uno falla almacena que esa seccion ha fallado
				
				for frm in _loaderNodes do
				(
					_errorPartMessage = "\tINCORRECTO:\n"
					_okPartMessage = "CORRECTO:\n"
					_fail = false --flag que indica si hay algun parametro que falla.
						
					-----------------------------------------------------------------
					--comprueba el naming convention
					if not frm.matchNC then
					(
						_fail = true
						_errorPartMessage += "\t\tNo cumple el naming convention.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--comprueba la secuencia
					if not frm.matchSeq then
					(
						_fail = true
						_errorPartMessage += "\t\tEl numero de secuencia del frame del loader no coincide con la de la ruta de la secuencia.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--comprueba la camara
					if not frm.matchCam then
					(
						_fail = true
						_errorPartMessage += "\t\tEl numero de camara del render element no coincide con la de la ruta de la camara.\n"
					)
					-----------------------------------------------------------------
					
					-----------------------------------------------------------------
					--averigua si el frame cargado está en la carpeta frame o si existe
					_found = false --flag para saber si hay un frame equivalente en la carpeta frame
					
					for opt in _frameFiles where not _found do --recorre los frames
						if (tolower frm.filePath) == (tolower opt.filePath) then _found = true
						
					if not _found then
					(
						_fail = true
						_errorPartMessage += "\t\tNo hay ningun frame en la carpeta frame que coincida con el cargado en el loader.'Puede que esté obsoleto, se haya eliminado, haya cambiado de nombre o se encuentre en la carpeta equivocada'.\n"
					)--if
					-----------------------------------------------------------------
					
					if _fail then 
					(
						camTask.state = #ERROR
						_overallFail = true
						
						camTask.log += "-----------------------------------------------------------------------------\n"
						camTask.log += frm.maxFile[1] + " :\n" + frm.filePath + "\n"
						camTask.log += _errorPartMessage
					)--if
					
						
				)--for
				
				--si ha fallado alguno de esta seccion
				if not _overallFail then camTask.log += "Todo OK.\n"
			)--if _loaderNodes.count != 0			
			------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------
			--log para los LPM passes y Render elements duplicados en uno o varios archivos max
			if (_LPMoutputs.count != 0) or (_renderElementsOutputs.count != 0) then
			(
				_allOutputs = deepCopy (_LPMoutputs + _renderElementsOutputs)
				_duplicatedOutputs = #()
				
				cont = 1 --contador de duplicados
				_addedIndexes = #() --indices utilizados
				for i=1 to _allOutputs.count where (_allOutputs[i].matchNC and _allOutputs[i].matchSeq and _allOutputs[i].matchCam) do
					for j=(i+1) to _allOutputs.count where (_allOutputs[j].matchNC and _allOutputs[j].matchSeq and _allOutputs[j].matchCam) do
						if (findItem _addedIndexes j == 0) and (_allOutputs[i].filePath == _allOutputs[j].filePath) then
						(
							if _duplicatedOutputs[cont] == undefined then (_duplicatedOutputs[cont] = #(_allOutputs[i]); appendIfUnique _addedIndexes i)
							
							append _duplicatedOutputs[cont] _allOutputs[j]
							appendIfUnique _addedIndexes j
						)--if
				
				if _duplicatedOutputs.count != 0 then --si hay duplicados debe avisar
				(
					camTask.log += "\n\n***************LPM PASSES y/o RENDER ELEMENTS DUPLICADOS***********************\n"
					_overallFail = false --si uno falla almacena que esa seccion ha fallado
					
					for frm in _duplicatedOutputs do
					(
						_errorPartMessage = "\tINCORRECTO:\n"
						_okPartMessage = "CORRECTO:\n"
						_fail = false --flag que indica si hay algun parametro que falla.
							
						-----------------------------------------------------------------
						--Recopila los archivos donde está duplicado
						_fail = true
						_errorPartMessage += "\t\tEl output está duplicado en varios archivos max o varias veces en el mismo y se puede sobreescribir:\n"
						
						for dpo in frm do --añaqde los archivos max donde se encuentra duplicado
							_errorPartMessage += "\t\t\t" + (if dpo.isLPMpath then "LPM_pass" else if dpo.isRenderElement then "Render element") + " -> " + dpo.name + ": " + dpo.sourceFile + "\n"
						-----------------------------------------------------------------
						
						if _fail then 
						(
							camTask.state = #ERROR
							_overallFail = true
							
							camTask.log += "-----------------------------------------------------------------------------\n"
							camTask.log += frm[1].filePath + "\n"
							camTask.log += _errorPartMessage
						)--if
					)--for
					
					--si ha fallado alguno de esta seccion
					if not _overallFail then camTask.log += "Todo OK.\n"
				)--if _duplicatedOutputs.count != 0
			)--if (_LPMoutputs.count != 0) or (_renderElementsOutputs.count != 0)
			------------------------------------------------------------------------------------
			
			-----------------------------------------------------------
			--HELP GENERAL
			-----------------------------------------------------------
			--si hay error o warning, añade una ayuda
			if camTask.state == #ERROR or camTask.state == #WARNING then
			(
				camTask.log += "\n\n***************************AYUDA GENERAL************************************\n"
				
				camTask.log += "\nTanto los outputs de render elements, como los de los pases de LPM, como los frames de la carpeta frame deben cumplir el siguiente patrón:\n"
				camTask.log += "Z:\\sequence\\seq_???*\\cam\\cam???\\frame\\seq_???*_cam???_render_<nombre de la capa>_.extension\n"
				camTask.log += "Ejemplos:\n"
				camTask.log += "Z:\\sequence\\seq_011b\\cam\\cam020\\frame\\seq_011b_cam020_render_fg(pass-fg-reflection)_.exr\n"
				camTask.log += "Z:\\sequence\\seq_082\\cam\\cam250\\frame\\seq_082_cam250_render_bg(matte-bg)_.exr\n"
				
				camTask.log += "\nTiene que haber archivos .max de render en la carpeta render.\n"
				camTask.log += "Tiene que haber frames en la carpeta frame.\n"
				camTask.log += "Tiene que haber un .comp en la carpeta post.\n"
				
				camTask.log += "\nCada output de .max, tiene que tener un frame en la carpeta frame.\n"
				camTask.log += "Cada output de .max, tiene que coincidir en secuencia y en camara con el path y el nombre del .max.\n"
				
				camTask.log += "\nCada frame de la carpeta frame, tiene que venir de un output de .max\n"
				camTask.log += "Cada output de .max, tiene que coincidir en secuencia y en camara con el path de la secuencia.\n"
				camTask.log += "No puede haber dos .max con el mismo output, ya que se pisarían.\n"
				
				camTask.log += "\nCada frame o grupo de frames de los Loader de Fusion, tiene que existir en la carpeta frame\n"
				camTask.log += "Cada frame de la carpeta frame, debe estar usandose en un Loader de Fusion.\n"
				
				camTask.log += "\n*****************************************************************************\n"
			)--if
			-----------------------------------------------------------
			------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------
			
			camTask
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

			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				ckbOptionCompositing.pos.x = 545 + 5*(_increment.x/5)
				ckbOptionRenderFx.pos.x = 437 + 4*(_increment.x/5)
				ckbOptionRender.pos.x = 329 + 3*(_increment.x/5)
				ckbOptionLighting.pos.x = 221 + 2*(_increment.x/5)
				ckbOptionCache.pos.x = 113 + (_increment.x/5)
				
				edtSequenceRootPath.width = edtCamNumberFilters.width = size.x - 135 - 5
				btnSequenceRootBrowse.pos.x = btnCamHelp.pos.x = 633 + _increment.x
				grpSequenceFolder.width = txtLog.width = size.x - 10
				
				dgCamList.width = (size.x - 10)/2
				if dgCamList.rows.count != 0 then dgCamList.columns.item[0].width = dgCamList.width - 100
				lblCheckCamResult.pos.x = 209 + (_increment.x/2)
				txtCheckCamResult.pos.x = 249 + (_increment.x/2)
				
				lblCheckList.pos.x = 331 + (_increment.x/2)
				dgCheckList.pos.x = 330 + (_increment.x/2)
				dgCheckList.width = (size.x - 20)/2
				if dgCheckList.rows.count != 0 then  dgCheckList.columns.item[0].width = dgCheckList.width - 100
				
				btnCheckAll.pos.x = 331 + (_increment.x/2)
				btnCheckSelected.pos.x = 381 + (_increment.x/2)
				btnFixSelected.pos.x = 461 + (_increment.x/2)
				lblCheckResult.pos.x = 530 + _increment.x
				txtCheckResult.pos.x = 570 + _increment.x			
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				txtLog.pos.y = 400 + _increment.y
				btnFixSelected.pos.y = btnCamCheckAll.pos.y = btnCamCheckSelected.pos.y = txtCheckCamResult.pos.y = btnCheckAll.pos.y = btnCheckSelected.pos.y = txtCheckResult.pos.y = 365 + _increment.y
				lblCheckCamResult.pos.y = lblCheckResult.pos.y = 368 + _increment.y
				dgCamList.height = dgCheckList.height = 280 + _increment.y	
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

			_checkFileTypeOption = ""
			if ckbOptionAnim.checked then _checkFileTypeOption = "anim"
			if ckbOptionCache.checked then _checkFileTypeOption = "cache"
			if ckbOptionLighting.checked then _checkFileTypeOption = "lighting"
			if ckbOptionRender.checked then _checkFileTypeOption = "render"
			if ckbOptionRenderFx.checked then _checkFileTypeOption = "renderFx"
			if ckbOptionCompositing.checked then _checkFileTypeOption = "compositing"

			lb.xml.setAttribute parent.cfgFile ("rollMain/fileTypeOption") "option" _checkFileTypeOption

			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "sequenceRootPath" (edtSequenceRootPath.text)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "camNumberFilters" (edtCamNumberFilters.text)

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

			--lee la opcion de tipo de archivo

			_checkFileTypeOption = (lb.xml.getAttribute parent.cfgFile ("rollMain/fileTypeOption") "option")

			ckbOptionAnim.checked = ckbOptionCache.checked = ckbOptionLighting.checked = ckbOptionRender.checked = ckbOptionRenderFx.checked = false
			case _checkFileTypeOption of
			(
				"anim": ckbOptionAnim.checked = true
				"cache": ckbOptionCache.checked = true
				"lighting": ckbOptionLighting.checked = true
				"render": ckbOptionRender.checked = true
				"renderFx": ckbOptionRenderFx.checked = true
				"compositing": ckbOptionCompositing.checked = true
				default: ckbOptionLighting.checked = true
			)--case
															
			currentRootPath =  edtSequenceRootPath.text = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "sequenceRootPath")
			edtCamNumberFilters.text = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "camNumberFilters")
			
			setWaitCursor()
			
			--fillCheckArrays() --rellena los arrays de checks
			initUI() --inicializa las propiedades de algunos componentes.
			sortChecks()-- Ordena los checks por su id
			resetUI() --resetea el interface y lo vuelve a rellenar
			
			setArrowCursor()
				
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

		----------------------------------------------------------------------------------------------------------------
		--cambia de opcion de tipo de archivo
		----------------------------------------------------------------------------------------------------------------
		on ckbOptionAnim changed state do
		(
			if not state then
				ckbOptionAnim.checked = true
			else
			(
				ckbOptionCache.checked = false
				ckbOptionLighting.checked = false
				ckbOptionRender.checked = false
				ckbOptionRenderFx.checked = false
				ckbOptionCompositing.checked = false
				
				resetUI()
			)
		)
		
		on ckbOptionCache changed state do
		(
			if not state then
				ckbOptionCache.checked = true
			else
			(
				ckbOptionAnim.checked = false
				ckbOptionLighting.checked = false
				ckbOptionRender.checked = false
				ckbOptionRenderFx.checked = false
				ckbOptionCompositing.checked = false
				
				resetUI()
			)
		)
		
		on ckbOptionLighting changed state do
		(
			if not state then
				ckbOptionLighting.checked = true
			else
			(
				ckbOptionCache.checked = false
				ckbOptionAnim.checked = false
				ckbOptionRender.checked = false
				ckbOptionRenderFx.checked = false
				ckbOptionCompositing.checked = false
				
				resetUI()
			)
		)
		
		on ckbOptionRender changed state do
		(
			if not state then
				ckbOptionRender.checked = true
			else
			(
				ckbOptionCache.checked = false
				ckbOptionAnim.checked = false
				ckbOptionLighting.checked = false
				ckbOptionRenderFx.checked = false
				ckbOptionCompositing.checked = false
				
				resetUI()
			)
		)
		
		on ckbOptionRenderFx changed state do
		(
			if not state then
				ckbOptionRenderFx.checked = true
			else
			(
				ckbOptionCache.checked = false
				ckbOptionAnim.checked = false
				ckbOptionLighting.checked = false
				ckbOptionRender.checked = false
				ckbOptionCompositing.checked = false
				
				resetUI()
			)
		)
		
		on ckbOptionCompositing changed state do
		(
			if not state then
				ckbOptionCompositing.checked = true
			else
			(
				ckbOptionCache.checked = false
				ckbOptionAnim.checked = false
				ckbOptionLighting.checked = false
				ckbOptionRender.checked = false
				ckbOptionRenderFx.checked = false
				
				resetUI()
			)
		)
		
		----------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------
		
		----------------------------------------------------------------------------------------------------------------
		--abre el folder de la camara seleccionada
		----------------------------------------------------------------------------------------------------------------
		on dgCamList CellMouseDoubleClick events do
		(
			_index = events.rowIndex + 1
			shellLaunch "explorer.exe" camTaskList[_index].path
		)
		

		----------------------------------------------------------------------------------------------------------------
		--habilita o no el boton de fix
		----------------------------------------------------------------------------------------------------------------
		on dgCheckList SelectionChanged events do
		(
			updateFixButtonState()
		)
		
		
		----------------------------------------------------------------------------------------------------------------
		--actualiza la camara  seleccionada.
		----------------------------------------------------------------------------------------------------------------
		on btnUpdateSelected pressed do
		(
			setWaitCursor()
			_index = 0 --indice de la camara seleccionada
			for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _index = i --busca el indice
			lb.svn.svnUpdate (camTaskList[_index].path) hidden:false donotwait:true
			setArrowCursor()
		)
			
		----------------------------------------------------------------------------------------------------------------
		--muestra la ayuda de la herramienta
		----------------------------------------------------------------------------------------------------------------
		on btnCamHelp pressed do
		(
			txtLog.text = "Tool Guide:\n\n"
			
			txtLog.text += "Sequence Root Path: Es la ruta raiz de una secuencia. Se puede buscar con el boton de browse (...) o se puede introducir a mano en el campo.\n\n"
			txtLog.text += "Cam Number Filters: Se pueden especificar numeros (150) o rangos de camara (010-260), para que no te muestre todos. Los numeros y rangos se deben separar por comas o por punto y coma.\n\n"
			
			txtLog.text += "Cam List: Muestra la lista de camaras filtradas de la secuencia.\n"
			txtLog.text += "Check All: Pasa el checkeo a todas las camaras listadas.\n"
			txtLog.text += "Check Selected: Pasa el checkeo a la secuencia seleccionada\n\n"
			
			txtLog.text += "Update Selected Cam: Actualiza por subversion la camara seleccionada.\n\n"
			
			txtLog.text += "En el listado de cámaras, si das doble click en una se abre su folder.\n\n"
		)
		
		----------------------------------------------------------------------------------------------------------------
		--cuando se pulsa el boton de hacer el FIX en la tarea seleccionada
		----------------------------------------------------------------------------------------------------------------
		on btnFixSelected pressed do
		(
			_start = timeStamp()
			
			setWaitCursor()
			
			_index = 0 --indice de la camara seleccionada
			for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _index = i --busca el indice
			
			_indexCheck = 0 --indice del check seleccionada
			for i=1 to dgCheckList.rows.count where (dgCheckList.item 0 (i-1)).selected do _indexCheck = i --busca el indice	
				
			if _index != 0 and _indexCheck != 0 then
			(
				makeCheck camTaskList[_index].checkTasks[_indexCheck] camTaskList[_index].checkTasks fix:true --hace el FIX seleccionado
				camTaskList[_index].checkTasks[_indexCheck] = makeCheck camTaskList[_index].checkTasks[_indexCheck] camTaskList[_index].checkTasks --pasa el check seleccionado
				
				camTaskList[_index].state = warningMessage	
				for i=1 to camTaskList[_index].checkTasks.count do --ejecuta todos los checks para esa camara
				(
					--segun el estado del check va rellenando el de la camara
					
					_taskState = camTaskList[_index].checkTasks[i].state
					case camTaskList[_index].state of --rellena con orden de precedencia el estado de la camara
					(
						waitingMessage: camTaskList[_index].state = _taskState
						okMessage: if _taskState == errorMessage or _taskState == warningMessage then camTaskList[_index].state = _taskState
						warningMessage: if _taskState == errorMessage then camTaskList[_index].state = _taskState
						notRequiredMessage: if _taskState != waitingMessage then camTaskList[_index].state = _taskState
					)--case
				)--for
				
				(dgCamList.item 1 (_index-1)).value = camTaskList[_index].state as string --rellena el estado en el listado
				(dgCheckList.item 1 (_indexCheck-1)).value = camTaskList[_index].checkTasks[_indexCheck].state as string --rellena el estado en el listado
					
				--------------------------------------------------------------------
				--segun el estado, le pone un color u otro a la celda de estado de la camara.
				_cellColor = dgBackColor
				case camTaskList[_index].state of
				(
					#WAITING:			_cellColor = waitingColor
					#NOTREQUIRED:	_cellColor = notRequiredColor
					#WARNING:			_cellColor = warningColor
					#OK:					_cellColor = okColor
					#ERROR:				_cellColor = errorColor
				)
					
				_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
				_cellStyle.backColor = _cellColor
				_alignment = (dotnetClass "System.Windows.Forms.DataGridViewContentAlignment")
				_cellStyle.Alignment = _alignment.MiddleCenter
				(dgCamList.item 1 (_index-1)).style = _cellStyle
				--------------------------------------------------------------------
				
				--------------------------------------------------------------------
				--segun el estado, le pone un color u otro a la celda de estado del check.
				_cellColor = dgBackColor
				case camTaskList[_index].checkTasks[_indexCheck].state of
				(
					#WAITING:			_cellColor = waitingColor
					#NOTREQUIRED:	_cellColor = notRequiredColor
					#WARNING:			_cellColor = warningColor
					#OK:					_cellColor = okColor
					#ERROR:				_cellColor = errorColor
				)
					
				_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
				_cellStyle.backColor = _cellColor
				_alignment = (dotnetClass "System.Windows.Forms.DataGridViewContentAlignment")
				_cellStyle.Alignment = _alignment.MiddleCenter
				(dgCheckList.item 1 (_indexCheck-1)).style = _cellStyle
				--------------------------------------------------------------------	
					
				fillCamListOverallState() --rellena el estado general de checks de las camaras	
				fillCheckListOverallState() --rellena el estado general de checks
					
				--rellena el cuadro de log con el de la camara seleccionada.
				txtLog.text = ""
				txtLog.text += camTaskList[_index].checkTasks[_indexCheck].log
			)
			
			updateFixButtonState()
			
			setArrowCursor()
			
			_time = ((timeStamp() - _start)/1000.0)
			print (_time as string)
		)
		
		----------------------------------------------------------------------------------------------------------------
		--cuando se pulsa el boton de pasar la tarea seleccionada
		----------------------------------------------------------------------------------------------------------------
		on btnCheckSelected pressed do
		(
			_start = timeStamp()
			
			setWaitCursor()
			
			_index = 0 --indice de la camara seleccionada
			for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _index = i --busca el indice
			
			_indexCheck = 0 --indice del check seleccionada
			for i=1 to dgCheckList.rows.count where (dgCheckList.item 0 (i-1)).selected do _indexCheck = i --busca el indice	
				
			if _index != 0 and _indexCheck != 0 then
			(
				camTaskList[_index].checkTasks[_indexCheck] = makeCheck camTaskList[_index].checkTasks[_indexCheck] camTaskList[_index].checkTasks --pasa el check seleccionado
				
				camTaskList[_index].state = warningMessage	
				for i=1 to camTaskList[_index].checkTasks.count do --ejecuta todos los checks para esa camara
				(
					--segun el estado del check va rellenando el de la camara
					
					_taskState = camTaskList[_index].checkTasks[i].state
					case camTaskList[_index].state of --rellena con orden de precedencia el estado de la camara
					(
						waitingMessage: camTaskList[_index].state = _taskState
						okMessage: if _taskState == errorMessage or _taskState == warningMessage then camTaskList[_index].state = _taskState
						warningMessage: if _taskState == errorMessage then camTaskList[_index].state = _taskState
						notRequiredMessage: if _taskState != waitingMessage then camTaskList[_index].state = _taskState
					)--case
				)--for
				
				(dgCamList.item 1 (_index-1)).value = camTaskList[_index].state as string --rellena el estado en el listado
				(dgCheckList.item 1 (_indexCheck-1)).value = camTaskList[_index].checkTasks[_indexCheck].state as string --rellena el estado en el listado
					
				--------------------------------------------------------------------
				--segun el estado, le pone un color u otro a la celda de estado de la camara.
				_cellColor = dgBackColor
				case camTaskList[_index].state of
				(
					#WAITING:			_cellColor = waitingColor
					#NOTREQUIRED:	_cellColor = notRequiredColor
					#WARNING:			_cellColor = warningColor
					#OK:					_cellColor = okColor
					#ERROR:				_cellColor = errorColor
				)
					
				_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
				_cellStyle.backColor = _cellColor
				_alignment = (dotnetClass "System.Windows.Forms.DataGridViewContentAlignment")
				_cellStyle.Alignment = _alignment.MiddleCenter
				(dgCamList.item 1 (_index-1)).style = _cellStyle
				--------------------------------------------------------------------
				
				--------------------------------------------------------------------
				--segun el estado, le pone un color u otro a la celda de estado del check.
				_cellColor = dgBackColor
				case camTaskList[_index].checkTasks[_indexCheck].state of
				(
					#WAITING:			_cellColor = waitingColor
					#NOTREQUIRED:	_cellColor = notRequiredColor
					#WARNING:			_cellColor = warningColor
					#OK:					_cellColor = okColor
					#PRECEDENCE:	_cellColor = precedenceColor
					#ERROR:				_cellColor = errorColor
				)
					
				_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
				_cellStyle.backColor = _cellColor
				_alignment = (dotnetClass "System.Windows.Forms.DataGridViewContentAlignment")
				_cellStyle.Alignment = _alignment.MiddleCenter
				(dgCheckList.item 1 (_indexCheck-1)).style = _cellStyle
				--------------------------------------------------------------------	
					
				fillCamListOverallState() --rellena el estado general de checks de las camaras	
				fillCheckListOverallState() --rellena el estado general de checks
					
				--rellena el cuadro de log con el de la camara seleccionada.
				txtLog.text = ""
				txtLog.text += camTaskList[_index].checkTasks[_indexCheck].log
			)
			
			updateFixButtonState()
			
			setArrowCursor()
			
			_time = ((timeStamp() - _start)/1000.0)
			print (_time as string)
		)
		
		----------------------------------------------------------------------------------------------------------------
		--cuando se pulsa el boton de pasar todas las tareas de una camara, comprueba que sea todo correcto
		----------------------------------------------------------------------------------------------------------------
		on btnCheckAll pressed do
		(
			_start = timeStamp()
			
			setWaitCursor()
			
			_index = 0 --indice de la camara seleccionada
			for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _index = i --busca el indice
			
			if _index != 0 then
			(
				camTaskList[_index] = makeCamChecks camTaskList[_index] fillProgressBar:true --rellena el estado de la camara
					
				(dgCamList.item 1 (_index-1)).value = camTaskList[_index].state as string --rellena el estado en el listado
				--------------------------------------------------------------------
				--segun el estado, le pone un color u otro a la celda de estado.
				_cellColor = dgBackColor
				case camTaskList[_index].state of
				(
					#WAITING:			_cellColor = waitingColor
					#NOTREQUIRED:	_cellColor = notRequiredColor
					#WARNING:			_cellColor = warningColor
					#OK:					_cellColor = okColor
					#ERROR:				_cellColor = errorColor
				)
					
				_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
				_cellStyle.backColor = _cellColor
				_alignment = (dotnetClass "System.Windows.Forms.DataGridViewContentAlignment")
				_cellStyle.Alignment = _alignment.MiddleCenter
				(dgCamList.item 1 (_index-1)).style = _cellStyle
				--------------------------------------------------------------------
				
				fillCamListOverallState() --rellena el estado general de checks de las camaras	
				fillCheckList() --rellena el listado de checks
				fillCheckListOverallState() --rellena el estado general de checks
					
				--rellena el cuadro de log con el de la camara seleccionada.
				txtLog.text = ""
				for i=1 to camTaskList[_index].checkTasks.count where camTaskList[_index].checkTasks[i].log != "" do
					txtLog.text += camTaskList[_index].checkTasks[i].log + "\n\n"
			)
			
			updateFixButtonState()
			
			setArrowCursor()
			
			_time = ((timeStamp() - _start)/1000.0)
			print (_time as string)
		)
		
		----------------------------------------------------------------------------------------------------------------
		--cuando se pulsa el boton de pasar todas las tareas, comprueba que sea todo correcto
		----------------------------------------------------------------------------------------------------------------
		on btnCamCheckAll pressed do
		(
			_start = timeStamp()
			
			setWaitCursor()
			
			txtLog.text = "" --vacia el log
			
			for i=1 to camTaskList.count do
			(
				camTaskList[i] = makeCamChecks camTaskList[i] --rellena el estado de todas las camaras
				txtLog.text = "********************* " + (formattedPrint (((100.0/camTaskList.count)*i) as integer) format:"02d") + "% *********************" --rellena el progreso
			)
				
			fillCamList() --rellena el listado de nuevo
			(dgCamList.item 0 0).selected = true --selecciona la primera camara
			fillCamListOverallState() --rellena el estado general
			
			fillCheckList() --rellena el listado de checks
			fillCheckListOverallState() --rellena el estado general de checks
			
			--rellena el cuadro de log con el de la camara seleccionada.
			_index = 0 --indice de la camara seleccionada
			for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _index = i --busca el indice
			txtLog.text = ""
			for i=1 to camTaskList[_index].checkTasks.count where camTaskList[_index].checkTasks[i].log != "" do
				txtLog.text += camTaskList[_index].checkTasks[i].log
			
			updateFixButtonState()
			
			setArrowCursor()
			
			_time = ((timeStamp() - _start)/1000.0)
			print (_time as string)
		)
		
		----------------------------------------------------------------------------------------------------------------
		--cuando se pulsa el boton de checkear una tarea seleccionada, comprueba que todo sea correcto en esa camara
		----------------------------------------------------------------------------------------------------------------
		on btnCamCheckSelected pressed do
		(
			_start = timeStamp()
			
			_index = 0 --indice de la camara seleccionada
			for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _index = i --busca el indice
			
			setWaitCursor()	
				
			if _index != 0 then --si no hay camara seleccionada no debe hacer nada
			(
				camTaskList[_index] = makeCamChecks camTaskList[_index] fillProgressBar:true --averigua el estado de esa camara
				
				fillCamList() --rellena el listado de nuevo
				(dgCamList.item 0 (_index-1)).selected = true --reselecciona la fila seleccionada
				fillCamListOverallState() --rellena el estado general
				
				fillCheckList() --rellena el listado de checks
				fillCheckListOverallState() --rellena el estado general de checks
					
				--rellena el cuadro de log con el de la camara seleccionada.
				txtLog.text = ""
				for i=1 to camTaskList[_index].checkTasks.count where camTaskList[_index].checkTasks[i].log != "" do
					txtLog.text += camTaskList[_index].checkTasks[i].log
			)
			
			updateFixButtonState()
			
			setArrowCursor()
			
			_time = ((timeStamp() - _start)/1000.0)
			print (_time as string)
		)
		
		----------------------------------------------------------------------------------------------------------------
		--cuando se selecciona una camara en el listado muestra su log
		----------------------------------------------------------------------------------------------------------------
		on dgCamList cellMouseUp events do
		(
			--deselecciona todas las celdas-------------------------------------------------------
			for i=1 to dgCamList.rows.count do
				(dgCamList.item 0 (i-1)).selected = false
					
			--reselecciona la fila pulsada---------------------------------------------------------
			(dgCamList.item (events.columnIndex) (events.rowIndex)).selected = true
			fillCheckList() --rellena los checks de la camara seleccionada
			fillCheckListOverallState() --rellena el estado general de checks
				
			--rellena el cuadro de log con el de la camara seleccionada.
			txtLog.text = ""
			for i=1 to camTaskList[events.rowIndex + 1].checkTasks.count where camTaskList[events.rowIndex + 1].checkTasks[i].log != "" do
				txtLog.text += camTaskList[events.rowIndex + 1].checkTasks[i].log
		)
		
		----------------------------------------------------------------------------------------------------------------
		--cuando se selecciona una tarea en el listado muestra su log
		----------------------------------------------------------------------------------------------------------------
		on dgCheckList cellMouseUp events do
		(
			--deselecciona todas las celdas-------------------------------------------------------
			for i=1 to dgCheckList.rows.count do
				(dgCheckList.item 0 (i-1)).selected = false
					
			--reselecciona la fila pulsada---------------------------------------------------------
			(dgCheckList.item (events.columnIndex) (events.rowIndex)).selected = true
							
			--rellena el cuadro de log con el de la tarea seleccionada.
			_index = 0 --indice de la camara seleccionada
			for i=1 to dgCamList.rows.count where (dgCamList.item 0 (i-1)).selected do _index = i --busca el indice
			if _index != 0 then txtLog.text = camTaskList[_index].checkTasks[events.rowIndex + 1].log else txtLog.text = "" --rellena el log
		)
		
		----------------------------------------------------------------------------------------------------------------
		--abre un browser para buscar secuencias.
		----------------------------------------------------------------------------------------------------------------
		on btnSequenceRootBrowse pressed do
		(
			--obtiene un nuevo path de secuencia
			_newPath = getSavePath caption:"Sequence root path" initialDir:(if (filterString edtSequenceRootPath.text ";, ")[1] != undefined then (filterString edtSequenceRootPath.text ";, ")[1] else "")
			
			if _newPath != "" and _newPath != undefined then --si hay path nuevo
			(
				if checkSequenceNC _newPath then --si no cumple el NC de secuencia no hace nada
				(
					currentRootPath = edtSequenceRootPath.text = _newPath
					setWaitCursor()
					resetUI()
					setArrowCursor()
				)--if
			)--if
		)
		
		----------------------------------------------------------------------------------------------------------------
		--si la ruta se mete a mano, hay que actualizar el listado.
		----------------------------------------------------------------------------------------------------------------
		on edtSequenceRootPath entered text do
		(
			_newPath = edtSequenceRootPath.text --nuevo texto
			
			if checkSequenceNC _newPath then --si no cumple el NC de secuencia no hace nada
			(
				currentRootPath = edtSequenceRootPath.text = _newPath
				setWaitCursor()
				resetUI()
				setArrowCursor()
			)
			else --si no cumple el NC restaura el path que había antes
				edtSequenceRootPath.text = currentRootPath
		)
		
		----------------------------------------------------------------------------------------------------------------
		--si la ruta se mete a mano, hay que actualizar el listado.
		----------------------------------------------------------------------------------------------------------------
		on edtCamNumberFilters entered text do
		(
			if checkSequenceNC currentRootPath then --si no cumple el NC de secuencia no hace nada
			(
				setWaitCursor()
				resetUI()
				setArrowCursor()
			)--if
		)

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
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_totalChecker
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Total Checker",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		---------------------------------------------------------------------------
		---------------------------------------------------------------------------
		--rellena los arrays de checks
		
		--checks para animacion	
		checkTaskList_anim = #(),

		--checks para cache	
		checkTaskList_cache = #(),
		
		--checks para lighting	
		checkTaskList_lighting = #(),
		
		--render
		checkTaskList_render = #(),

		--renderFx
		checkTaskList_renderFx = #(),    
	
		--Compositing
		checkTaskList_compositing = #(), 

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollMain | Almacena el rollout principal de la herramienta.

		camT = camTask, 
		ExtraInfoCorrupt = checkTask_ExtraInfoCorrupt,
		SVNlocalCachePathUpdated = checkTask_SVNlocalCachePathUpdated,
		SVNnetworkCachePathUpdated = checkTask_SVNnetworkCachePathUpdated,
		CheckedRenderMaxFiles = checkTask_CheckedRenderMaxFiles,
		NCrenderMaxFiles = checkTask_NCrenderMaxFiles,
		NCrenderFxMaxFiles = checkTask_NCrenderFxMaxFiles,
		NCpostFusionFiles = checkTask_NCpostFusionFiles,
		NCpostNukeFiles = checkTask_NCpostNukeFiles,
		NCframeFiles = checkTask_NCframeFiles,
		NCFxFrameFiles = checkTask_NCFxFrameFiles,
		NClpmRootDir = checkTask_NClpmRootDir,
		NClpmLayers = checkTask_NClpmLayers,
		NClpmLayersFGMcorrect = checkTask_NClpmLayersFGMcorrect,
		NCrenderMaxFilesSeqAndCamOK = checkTask_NCrenderMaxFilesSeqAndCamOK,
		NCRenderFxMaxFilesSeqAndCamOK = checkTask_NCRenderFxMaxFilesSeqAndCamOK,
		NCpostFusionFilesSeqAndCamOK = checkTask_NCpostFusionFilesSeqAndCamOK,
		NCpostNukeFilesSeqAndCamOK = checkTask_NCpostNukeFilesSeqAndCamOK,
		NCframeFilesSeqAndCamOK = checkTask_NCframeFilesSeqAndCamOK,
		NCFxFrameFilesSeqAndCamOK = checkTask_NCFxFrameFilesSeqAndCamOK,
		SVNrenderPathUpdated = checkTask_SVNrenderPathUpdated,
		SVNpostPathUpdated = checkTask_SVNpostPathUpdated,
		SVNlocalTexturePathUpdated = checkTask_SVNlocalTexturePathUpdated,
		SVNnetworkTexturePathUpdated = checkTask_SVNnetworkTexturePathUpdated,
		framePathExist = checkTask_framePathExist,
		frameUsageCoherence = checkTask_frameUsageCoherence,
		bitmapsInSequenceTexturePath = checkTask_bitmapsInSequenceTexturePath,
		bitmapsExist = checkTask_bitmapsExist,
		postNukeFilesNodesActive = checkTask_postNukeFilesNodesActive,
		postNukeFilesOutputCorrect = checkTask_postNukeFilesOutputCorrect,
		postNukeFilesOutputCompression = checkTask_postNukeFilesOutputCompression,
		postFusionFilesNodesActive = checkTask_postFusionFilesNodesActive,
		postFusionFilesOutputCorrect = checkTask_postFusionFilesOutputCorrect,
		postFxFusionFilesOutputCorrect = checkTask_postFxFusionFilesOutputCorrect,
		postFxNukeFilesOutputCorrect = checkTask_postFxNukeFilesOutputCorrect,
		postNodesFilesExist = checkTask_postNodesFilesExist,
		compoNodesFilesExist = checkTask_compoNodesFilesExist,
		postFxNodesFilesExist = checkTask_postFxNodesFilesExist,
		postNodesNCOk = checkTask_postNodesNCOk,
		compoNodesNCOk = checkTask_compoNodesNCOk,
		postFxNodesNCOk = checkTask_postFxNodesNCOk,
		postNodesCamAndSeqOk = checkTask_postNodesCamAndSeqOk,
		compoNodesCamAndSeqOk = checkTask_compoNodesCamAndSeqOk,
		postFxNodesCamAndSeqOk = checkTask_postFxNodesCamAndSeqOk,
		postNodesNoFx = checkTask_postNodesNoFx,
		postFxNodesNoRender = checkTask_postFxNodesNoRender,
		postWriteNodeOk = checkTask_postWriteNodeOk,
		NotObsoleteFrames = checkTask_NotObsoleteFrames,
		findMissingFrames = checkTask_findMissingFrames,
		findMissingFxFrames = checkTask_findMissingFxFrames,
		findCorruptedFrames = checkTask_findCorruptedFrames,
		findCorruptedFxFrames = checkTask_findCorruptedFxFrames,
		findReferenceFrames = checkTask_findReferenceFrames,
		framesInCamFolderExist = checkTask_framesInCamFolderExist,
		fxFramesInCamFolderExist = checkTask_fxFramesInCamFolderExist,
		framesInRefFolderExist = checkTask_framesInRefFolderExist,
		framesInCamNC = checkTask_framesInCamNC,
		fxFramesInCamNC = checkTask_fxFramesInCamNC,
		framesInRefNC = checkTask_framesInRefNC,
		framesInFinalRefExist = checkTask_framesInFinalRefExist,
		refCompFramesExist = checkTask_refCompFramesExist,
		framesMatchCamAndSeq = checkTask_framesMatchCamAndSeq,
		fxFramesSeqAndCamOk = checkTask_fxFramesSeqAndCamOk,
		framesInCamAndRefHaveLayer = checkTask_framesInCamAndRefHaveLayer,
		fxFramesInCamHaveLayer = checkTask_fxFramesInCamHaveLayer,
		framesInCamFolderExistInComp = checkTask_framesInCamFolderExistInComp,
		framesInCamFolderExistInCompV2 = checkTask_framesInCamFolderExistInCompV2,
		fxFramesInCamFolderExistInComp = checkTask_fxFramesInCamFolderExistInComp,
		framesInFinalFolderNC = checkTask_framesInFinalFolderNC,
		framesInCamAndFinalCamAndSeqOk = checkTask_framesInCamAndFinalCamAndSeqOk,
		framesInCamHaveLayer = checkTask_framesInCamHaveLayer,
		allFinalFramesRendered = checkTask_allFinalFramesRendered,
		CheckedAnimMaxFiles = checkTask_CheckedAnimMaxFiles,
		NCanimMaxFiles = checkTask_NCanimMaxFiles,
		NCanimMaxFilesSeqAndCamOK = checkTask_NCanimMaxFilesSeqAndCamOK,
		SVNanimPathUpdated = checkTask_SVNanimPathUpdated,
		NCanimMaxFilesAnimRangeAsCamRange = checkTask_NCanimMaxFilesAnimRangeAsCamRange,
		animMaxFilesWithoutLights = checkTask_animMaxFilesWithoutLights,
		animMaxFilesWithoutStamps = checkTask_animMaxFilesWithoutStamps,
		animMaxFilesWithoutLayout = checkTask_animMaxFilesWithoutLayout,
		CheckedCacheMaxFiles = checkTask_CheckedCacheMaxFiles,
		NCcacheMaxFiles = checkTask_NCcacheMaxFiles,
		NCcacheMaxFilesSeqAndCamOK = checkTask_NCcacheMaxFilesSeqAndCamOK,
		NCcacheMaxFilesAnimRangeAsCamRange = checkTask_NCcacheMaxFilesAnimRangeAsCamRange,
		NCcacheMaxFilesCamsWithTC = checkTask_NCcacheMaxFilesCamsWithTC,
		cacheMaxFilesWithoutSETs = checkTask_cacheMaxFilesWithoutSETs,
		nonEqualSourcePointCacheFileTypes = checkTask_nonEqualSourcePointCacheFileTypes,

		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@fn: undefined | fillCheckListArrays | rellena los arrays de los checkslists
		------------------------------------------------
		fn fillCheckListArrays =
		(
			--rellena los arrays de checks
			--checks para animacion	
			this.checkTaskList_anim = #(this.ExtraInfoCorrupt(), this.CheckedAnimMaxFiles(), this.NCanimMaxFiles(), this.NCanimMaxFilesSeqAndCamOK(), 	this.SVNanimPathUpdated(), this.NCanimMaxFilesAnimRangeAsCamRange(), this.animMaxFilesWithoutLights(), this.animMaxFilesWithoutStamps(), this.animMaxFilesWithoutLayout())

			--checks para cache	
			this.checkTaskList_cache = #(this.ExtraInfoCorrupt(), this.CheckedCacheMaxFiles(), this.NCcacheMaxFiles(), this.NCcacheMaxFilesSeqAndCamOK(), this.SVNlocalCachePathUpdated(), this.SVNnetworkCachePathUpdated(), this.NCcacheMaxFilesAnimRangeAsCamRange(),this.NCcacheMaxFilesCamsWithTC(), this.cacheMaxFilesWithoutSETs(), this.nonEqualSourcePointCacheFileTypes())
			
			--checks para lighting	
			this.checkTaskList_lighting = #(this.ExtraInfoCorrupt(), this.CheckedRenderMaxFiles(), this.NCrenderMaxFiles(), this.NCpostFusionFiles(), this.NCpostNukeFiles(), this.NCframeFiles(), this.NClpmRootDir(), this.NClpmLayers(), this.NClpmLayersFGMcorrect(), this.NCrenderMaxFilesSeqAndCamOK(), this.NCpostFusionFilesSeqAndCamOK(), this.NCpostNukeFilesSeqAndCamOK(), this.NCframeFilesSeqAndCamOK(), this.SVNrenderPathUpdated(), this.SVNpostPathUpdated(), this.SVNlocalCachePathUpdated(), this.SVNnetworkCachePathUpdated(), this.SVNlocalTexturePathUpdated(), this.SVNnetworkTexturePathUpdated(), this.framePathExist(), this.frameUsageCoherence(), this.bitmapsInSequenceTexturePath(), this.bitmapsExist(), this.postNukeFilesNodesActive(), this.postNukeFilesOutputCorrect(), this.postNukeFilesOutputCompression(), this.postFusionFilesNodesActive(), this.postFusionFilesOutputCorrect(), this.NotObsoleteFrames(),this.findReferenceFrames(), this.framesInCamFolderExist(), this.framesInRefFolderExist(), this.framesInCamNC(), this.framesInRefNC(), this.framesInFinalRefExist(), this.framesMatchCamAndSeq(), this.framesInCamAndRefHaveLayer(), this.framesInCamFolderExistInComp(), this.postNodesFilesExist(), this.postNodesNCOk(), this.postNodesCamAndSeqOk(), this.postNodesNoFx(), this.postWriteNodeOk())
			
			--render
			this.checkTaskList_render = #(this.ExtraInfoCorrupt(), this.NClpmRootDir(), this.NClpmLayers(), this.NCframeFiles(), this.NCframeFilesSeqAndCamOK(), this.SVNrenderPathUpdated(), this.SVNpostPathUpdated(), this.SVNlocalCachePathUpdated(), this.SVNnetworkCachePathUpdated(), this.SVNlocalTexturePathUpdated(), this.SVNnetworkTexturePathUpdated(), this.findMissingFrames(), this.findCorruptedFrames(), this.framesInCamFolderExist(), this.framesInCamNC(), this.framesInFinalFolderNC(), this.framesInCamAndFinalCamAndSeqOk(), this.framesInCamHaveLayer(),this.framesInCamFolderExistInComp(), this.allFinalFramesRendered(), this.postNodesFilesExist(), this.postNodesNCOk(), this.postNodesCamAndSeqOk(), this.postNodesNoFx(), this.postWriteNodeOk())

			--renderFx
			this.checkTaskList_renderFx = #(this.ExtraInfoCorrupt(), this.NCFxFrameFiles(), this.NClpmRootDir(), this.NClpmLayers(),this.NCrenderFxMaxFiles(), this.NCRenderFxMaxFilesSeqAndCamOK(), this.NCFxFrameFilesSeqAndCamOK(), this.SVNrenderPathUpdated(), this.SVNlocalCachePathUpdated(), this.SVNnetworkCachePathUpdated(), this.framePathExist(), this.findMissingFxFrames(), this.findCorruptedFxFrames(), this.postFxFusionFilesOutputCorrect(), this.postFxNukeFilesOutputCorrect(), this.fxFramesInCamFolderExist(), this.fxFramesInCamNC(), this.fxFramesSeqAndCamOk(), this.fxFramesInCamHaveLayer(), this.fxFramesInCamFolderExistInComp(), this.postFxNodesFilesExist(), this.postFxNodesNCOk(), this.postFxNodesCamAndSeqOk(), this.postFxNodesNoRender())
		
			--Compositing
			this.checkTaskList_compositing = #( this.ExtraInfoCorrupt(), this.refCompFramesExist(), this.framesInCamFolderExistInCompV2(), this.compoNodesFilesExist(), this.compoNodesNCOk(), this.compoNodesCamAndSeqOk()) 
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
			this.fillCheckListArrays()
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
	)--tl_totalChecker
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_totalChecker() --crea la herramienta
)