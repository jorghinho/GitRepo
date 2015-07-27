--------------------------
-- TAREAS PENDIENTES
-------------------------
-- Convertir lbTools_nodeInfoManager.mcr en una tool que lea el nuevo nodeInfo.

------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de nodeInfo
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@custAttribute: undefined | dynConnect | Custom Attribute que se añadirá a los nodos que necesiten conexión en tiempo de carga en la escena
	------------------------------------------------------------------------------------------------------------------------------------------------
	CA_nodeInfo = attributes nodeInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version
			CA_description	type:#string	animatable:false	default:"Información del nodo"
			CA_version		type:#float		animatable:false	default:2.1
			   
			fileHistory			type:#stringTab		animatable:false	tabSizeVariable:true
			nameHistory			type:#stringTab		animatable:false	tabSizeVariable:true
			layerNameHistory	type:#stringTab		animatable:false	tabSizeVariable:true
			materialNameHistory	type:#stringTab		animatable:false	tabSizeVariable:true
			transformHistory	type:#matrix3Tab	animatable:false	tabSizeVariable:true
			loadModeHistory		type:#stringTab		animatable:false	tabSizeVariable:true
			subVersionHistory	type:#stringTab		animatable:false	tabSizeVariable:true
		)
		
		--------------------------------------------------
		on load do
		(
		)
		
		--------------------------------------------------
		on create do
		(
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: nodeInfo | Contiene la libreria de nodeInfo.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_nodeInfo
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Librería nodeInfo",	--@var: description | Descripcion de la libreria.
		CA_nodeInfoDef = CA_nodeInfo,
		
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
		--@fn: boolean | hasNodeInfo | Indica si el fichero especificado tiene nodeInfo
		--@gets: string | filename | Nombre del fichero al que añadir el nodeInfo
		------------------------------------------------
		fn hasNodeInfo obj = 
		(
			(lb.customAttributes.hasAttribute obj #nodeInfo)
		),
		
		------------------------------------------------
		--@fn: boolean | addAttribute | Añade el nodeInfo al fichero pasado por parámetro. Devuelve true o false dependiendo si ha conseguido crearlo
		--@gets: node | obj | nodo al que hay que iniciarle el nodeInfo
		------------------------------------------------
		mapped fn addAttribute obj =
		(
			this.removeAttribute obj	
			custAttributes.add obj CA_nodeInfo #unique baseobject:false
			
			true
		),
		
		------------------------------------------------
		--@fn: boolean | removeAttribute | Elimina el nodeInfo al fichero pasado por parámetro
		--@gets: node | obj | nodo al que hay que quitarle el nodeInfo
		------------------------------------------------
		mapped fn removeAttribute obj =
		(
			_removed = false
			
			if this.hasNodeInfo obj then 
			(
				custAttributes.delete obj (custAttributes.getdef obj.nodeInfo) baseobject:false
				_removed = true
			)
			
			_removed
		),
		
		------------------------------------------------
		--@fn: boolean | removeAttribute | Elimina el nodeInfo al fichero pasado por parámetro
		--@gets: node | obj | nodo al que hay que quitarle el nodeInfo
		------------------------------------------------
		mapped fn updateAttribute obj =
		(
			_updated = false
			
			if this.hasNodeInfo obj then 
			(
				_propNames = getPropNames obj.nodeInfo --obtiene las propiedades del nodeInfo que lleva puesto la pieza en ese momento
				_propValues = for _prop in _propNames collect getProperty obj.nodeInfo _prop --obtiene los valores de las propiedades
				
				------------------------------------------------
				--casos especiales cuando se pasa de una versiona  otra
				
				--de la version 2.0 a la 2.1
				_loadModeHistoryCount = 0
				if obj.nodeInfo.CA_version == 2 then _loadModeHistoryCount = obj.nodeInfo.fileHistory.count
				------------------------------------------------
				
				--elimina el CA y se lo vuelve a poner
				this.removeAttribute obj
				this.addAttribute obj
				
				--rellena las propiedades tal y como estuvieran antes.
				for i=1 to _propNames.count where _propNames[i] != #CA_version do
					setProperty obj.nodeInfo _propNames[i] _propValues[i]					
				
				------------------------------------------------
				--rellena los casos especiales
				
				--de la version 2.0 a la 2.1
				if obj.nodeInfo.CA_version >= 2 and _loadModeHistoryCount > 0 then
					obj.nodeInfo.loadModeHistory = (for i=1 to _loadModeHistoryCount collect "undefined")
				------------------------------------------------
				
				--pone el numero de version más actualizado
				
				
				_updated = true
			)
			
			_updated
		),
		
		------------------------------------------------
		--@fn: boolean | clear | Borra el contenido del custom attribute nodeInfo sin eliminarlo
		--@gets: node | obj | nodo al que hay que limpiar el nodeInfo
		------------------------------------------------
		mapped fn clear obj = 
		(
			obj.nodeInfo.fileHistory = \
			obj.nodeInfo.nameHistory = \
			obj.nodeInfo.layerNameHistory = \
			obj.nodeInfo.materialNameHistory = \
			obj.nodeInfo.transformHistory = \
			obj.nodeInfo.loadModeHistory = \
			obj.nodeInfo.subVersionHistory = #()
		),
		
		------------------------------------------------
		--@fn: boolean | needsToReplace | Indica si hay que actualizar el nodeInfo a la pieza
		--@gets: node | obj | nodo al que hay que limpiar el nodeInfo
		------------------------------------------------
		fn getAddNodeInfoMode obj =
		(
			_addNodeInfoMode = #add
			
			if (lb.nc.ncOK maxFileName type:#assetFile) or (lb.nc.ncOK maxFileName type:#seqFile) then
			(
				_fileParts = filterString (getFileNameFile maxFileName) "_"
				_fileAssetName = _fileParts[1] + "_" + (filterstring _fileParts[2] "-")[1]
				_fileType = _fileParts[3]
				_objType = (filterString obj.name "_")[3]
				
				if this.hasNodeInfo obj then 
					if obj.nodeInfo.fileHistory.count > 0 then
					(
						_lastFile = obj.nodeInfo.fileHistory[1]
						_lastFileParts = filterString (getFileNameFile _lastFile) "_"
						_lastFileAssetName = _lastFileParts[1] + "_" + (filterstring _lastFileParts[2] "-")[1]
						_lastFileType = _lastFileParts[3]
						
						-- Si el fichero es de tipo asset
						if _fileParts[1] != lb.nc.NC_seqPrefix then
						(
							--para cierto tipo de archivos de asset se reemplaza siempre
							_isReplaceFileType = false
							case _fileType of
							(
								(lb.nc.NC_meshFileName): _isReplaceFileType = true
								(lb.nc.NC_morphFileName): _isReplaceFileType = true
								(lb.nc.NC_draftFileName): _isReplaceFileType = true
								(lb.nc.NC_hairFileName): _isReplaceFileType = true
								(lb.nc.NC_puppetFileName): _isReplaceFileType = true
								(lb.nc.NC_clothFileName): _isReplaceFileType = true
							)--case
							
							if _isReplaceFileType and (classOf obj != xRefObject) then --si se tiene que remplazar
								_addNodeInfoMode = #replaceAll
							else --si no se tiene que remplazar
							(
								-- Si el tipo de objeto es igual que el tipo de fichero y el último registro indica que estamos 
								-- en el mismo fichero estaba registrado entonces reemplazamos el  último registro.
								if (_fileAssetName == _lastFileAssetName) and (_fileType == _lastFileType) then
									_addNodeInfoMode = #replaceLast
								else if (_objType == _fileType) and (classOf obj != xRefObject) then
									_addNodeInfoMode = #replaceLast
							)--if else
						)
						-- En caso de que sea un fichero de secuencia, y si la última entrada del nodeInfo es también una secuencia
						else if _lastFileParts[1] == lb.nc.NC_seqPrefix then
						(
							-- Solo nos interesa guardar el recorrido de la pieza por una secuencia. Si la pieza 
							-- viene por cualquier motivo de otra cámara reemplazamos la última entrada
							if (_fileParts[4] == _lastFileParts[4]) then
								_addNodeInfoMode = #replaceLast
						)
					)
					else
					(
						_addNodeInfoMode = #replaceLast
					)
				else
				(
					_addNodeInfoMode = #replaceAll
				)
			)
			else
				_addNodeInfoMode = #noAdd --si no cumple el naming convention no se añade node info
						
			_addNodeInfoMode
		),
		
		------------------------------------------------
		--@fn: boolean | add | Añade y rellena el nodeInfo al fichero pasado por parámetro. Devuelve TRUE si consigue terminar el proceso
		--@gets: node | obj | nodo al que hay que iniciarle el nodeInfo
		--@opt: boolean | replace | Indica si hay que reemplazar el nodeInfo anterior o simplemente incrementar su información
		------------------------------------------------
		mapped fn add obj replace:false subVersionNumber:undefined =
		(
			_currentFileName = (maxFilePath + maxfilename)
			_selSets = #()
			_turbosmoothMod = undefined
			_addNodeInfoMode = (this.getAddNodeInfoMode obj)
			
			if (classof obj) == PFEngine do --objetos que no pueden tener nodeinfo
				return false

			-- si la pieza no tiene nodeInfo o si lo tiene pero se ha pedido reemplazarlo creamos un nuevo custom attribute
			if not (this.hasNodeInfo obj) or replace then
				this.addAttribute obj
			
			--	Rellenamos los datos del customAttribute. Si no hay que reemplazar la información solo insertamos los nuevos datos
			if replace or (_addNodeInfoMode == #replaceAll) then this.clear obj
			
			if _addNodeInfoMode != #noAdd then --si el modo es no añadir se deja como esté
			(
				--	insertamos nueva información si hemos cambiado de fichero.
				--	No se puede usar la función insertItem con un array de un custom attribute, así que usamos un join
				if _addNodeInfoMode == #add then 
				(
					obj.nodeInfo.fileHistory = join #("") obj.nodeInfo.fileHistory
					obj.nodeInfo.nameHistory = join #("") obj.nodeInfo.nameHistory
					obj.nodeInfo.layerNameHistory = join #("") obj.nodeInfo.layerNameHistory
					obj.nodeInfo.materialNameHistory = join #("") obj.nodeInfo.materialNameHistory
					obj.nodeInfo.transformHistory = join #(matrix3 1) obj.nodeInfo.transformHistory
					obj.nodeInfo.loadModeHistory = join #("") obj.nodeInfo.loadModeHistory
					obj.nodeInfo.subVersionHistory = join #("") obj.nodeInfo.subVersionHistory
				)
				
				obj.nodeInfo.fileHistory[1] = _currentFileName
				obj.nodeInfo.nameHistory[1] = obj.name
				obj.nodeInfo.layerNameHistory[1] = obj.layer.name
				obj.nodeInfo.materialNameHistory[1] = if obj.material != undefined then obj.material.name else "undefined"
				obj.nodeInfo.transformHistory [1] = obj.transform
				obj.nodeInfo.loadModeHistory[1] = if classOf obj == XRefObject then "xRefObject" else "merge"
				obj.nodeInfo.subVersionHistory[1] = if subVersionNumber != undefined then subVersionNumber else this.createSubVersionNumber()
			)
			
			true
		),
		
		------------------------------------------------
		--@fn: boolean | setSubVersion | Establece el valor de subVersion en el nodeInfo de obj. El nodeInfo tiene que estar ya añadido. Si consigue establecer el valor devuelve TRUE, si no FALSE
		--@gets: node | obj | nodo al que hay que establecerle el valor de subVersion el nodeInfo
		--@gets: string | subVersion | Cadena de texto con el número de versión
		------------------------------------------------
		mapped fn setSubVersion obj subVersion =
		(
			_versionChanged = false
			
			if this.hasNodeInfo obj then
				obj.nodeInfo.subVersionHistory[1] = subVersion
			
			_versionChanged
		),
		
		------------------------------------------------
		--@fn: integer | createSubVersionNumber | Devuelve un número de versión basado en la fecha y hora actuales
		------------------------------------------------
		fn createSubVersionNumber =
		(
			_versionString = ""
			_localTimeParts = filterstring localtime " "
			_dateParts = filterString _localTimeParts[1] "/"
			_timeParts = filterString _localTimeParts[2] ":"
			
			for i = _dateParts.count to 1 by -1 do append _versionString _dateParts[i]
			append _versionString "."
			for _part in _timeParts do append _versionString _part
			
			_versionString 
		),
		
		------------------------------------------------
		--@fn: integer | createSubVersionNumber | Devuelve un número basado en la fecha y hora actuales
		--@gets: node | obj | nodo al que hay que establecerle el valor de subVersion el nodeInfo
		--@opt: name | type | Ruta que se quiere obtener. Puede ser la del último fichero por el que pasó la pieza (#actual) en uso o la del original (#original)
		------------------------------------------------
		fn getNodeAssetFolder obj type:#actual =
		(
			_nodeFolder = undefined
			
			_index = obj.nodeInfo.fileHistory.count
			
			--si se busca el folder real del asset, se debe iterar hasta encontrar la primera ruta que sea de asset y no de secuencia
			if type == #actual then
			(
				_stop = false
				for i=1 to obj.nodeInfo.fileHistory.count where not _stop do
				(
					if findString (getFileNameFile obj.nodeInfo.fileHistory[i]) lb.nc.NC_seqPrefix == undefined then
					(
						_pathParts = FilterString obj.nodeInfo.fileHistory[i] "\\"
					 	_pattern =  _pathParts[5] + "*"
					 	if matchpattern obj.name pattern: _pattern do 
					 	(
							_stop = true
							_index = i
					 	)
					)
				)
			)
			
			_filename = undefined
			if _index > 0 then
			(
				_filename = obj.nodeInfo.fileHistory[_index]
			)		
			_path = if _filename != undefined then (getFileNamePath _filename) else ""
			_versionIndex = (findstring _path "version")
			
			if _versionIndex != undefined then
			(
				_versionIndex -= 1
				_nodeFolder = substring _path 1 _versionIndex
			)
			_nodeFolder
		),
		
		------------------------------------------------
		--@fn: integer | createSubVersionNumber | Devuelve un número basado en la fecha y hora actuales
		--@gets: node | obj | nodo al que hay que establecerle el valor de subVersion el nodeInfo
		--@opt: name | type | Ruta que se quiere obtener. Puede ser la del último fichero por el que pasó la pieza (#actual) en uso o la del original (#original)
		------------------------------------------------
		fn getNodeAssetVersion obj type:#actual =
		(
			_nodeVersion = undefined
			
			if this.hasNodeInfo obj then
			(
				_index = if type == #actual then 1 else obj.nodeInfo.fileHistory.count

				_stop = false
				while (_index <= obj.nodeInfo.fileHistory.count) and not _stop do
				(
					_fileName = (getFilenameFile obj.nodeInfo.fileHistory[_index]) + ".max"

					_matchSeq = MatchPattern _fileName pattern:lb.nc.NC_seqGenericNamePattern
					_matchSeqLayout = MatchPattern _fileName pattern:lb.nc.NC_seqLayoutNamePattern
					_matchSeqLayoutCam = MatchPattern _fileName pattern:lb.nc.NC_seqLayoutCameraNamePattern
					_matchSeqLayoutCams = MatchPattern _fileName pattern:lb.nc.NC_seqLayoutCamerasNamePattern

					if _matchSeq or _matchSeqLayout or _matchSeqLayoutCam or _matchSeqLayoutCams then (_index += 1) else (_stop = true)
				)--while

				if _index <= obj.nodeInfo.fileHistory.count then
				(
					_filename = getFileNameFile obj.nodeInfo.fileHistory[_index]

					_fileParts = filterstring _filename "_"
					_nodeVersion = if _fileParts[4] != undefined then (filterstring _fileParts[4] "vV")[1] as integer
				)--if
			)--if
			
			_nodeVersion
		),
		
		-----------------------------------------------------------------------------------------------------
		--@fn:  string | toString | Devuelve un string con todas las propiedades y valores del nodeInfo de la pieza
		--@gets: node | obj | nodo al que hay que iniciarle el nodeInfo
		-----------------------------------------------------------------------------------------------------
		fn toString obj =
		(
			_nodeInfoString = ""
			
			if this.hasNodeInfo obj then
				for _propName in (getPropNames obj.nodeInfo) do
				(
					append _nodeInfoString ((_propName as string) + ": " + ((getProperty obj.nodeInfo _propName) as string) + "\n")
				)
				
			_nodeInfoString
		),

		------------------------------------------------------------------------------------------------------------------
		-- Devuelve el tiempo actual de localtime de max (dd/mm/yyyy hh:mm:ss) pero con formato de nodeInfo yyyymmdd.hhmmss
		------------------------------------------------------------------------------------------------------------------
		fn formatNodeInfoTime myTime=
		(
			_currentTime = myTime
			_parsedTime = (formattedPrint ((filterString (filterString _currentTime " ")[1] "/")[3] As Number) format:"02d") + (formattedPrint ((filterString (filterString _currentTime " ")[1] "/")[2] As Number) format:"02d") + (formattedPrint ((filterString (filterString _currentTime " ")[1] "/")[1] As Number) format:"02d") + "." + (formattedPrint ((filterString (filterString _currentTime " ")[2] ":")[1] As Number) format:"02d") + (formattedPrint ((filterString (filterString _currentTime " ")[2] ":")[2] As Number) format:"02d") + (formattedPrint ((filterString (filterString _currentTime " ")[2] ":")[3] As Number) format:"02d")
			_parsedTime
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
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_nodeInfo() --crea la libreria
)