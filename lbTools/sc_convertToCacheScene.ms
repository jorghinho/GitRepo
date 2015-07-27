------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script convertToCacheScene.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script convertToCacheScene.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_convertToCacheScene
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "convertToCacheScene",	--@var: description | Descripcion del script.
		
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
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		----------------------------------------------------------------------------------------------
		-- 	Cambia el asset a modo de visualización CONNECTALL y desactiva en viewport 
		--	los Turbosmooth de las piezas de tipo mesh. 
		----------------------------------------------------------------------------------------------
		fn prepareAssetForCacheRecording ast enableCloth:false =
		(
			--	Si el asset no está en modo CONNECTALL se lo activamos.
			_modeToBe = "CA" -- if ast.clothNodesAll.count != 0 then "CA" else "S+B"
				
			if lb.asset.getAssetvismode ast != _modeToBe then
				lb.asset.setAssetConnectAllMode ast enableCloth:enableCloth
			
			--	desactivamos los turbosmooth de las piezas mesh
			for o in ast.meshNodesAll do lb.modifiers.setTurbosmoothState o #disabledInViews
		),

		fn createSceneCache processAssets:true processCaches:true saveNewMaxFile:true deleteOldCacheFiles:true mergeXrefs:false selAssetsOnly:false =
		(
		
			local meshObjs = #()						--	Todas las piezas de tipo mesh de todos los assets
			local cacheFileName 	= undefined		--	Fichero de caches donde se almacena el resultado
			local cachesFolder		= undefined		--	Carpeta donde se almacenarán los ficheros de point cache
			local continueProcess = true				--	Indica si se puede realizar o no la conversión
			
			
			

			disableSceneRedraw()
			suspendEditing()
			setWaitCursor()                                                  
			
			if lb.asset.sceneAssets == undefined then lb.asset.sceneAssets = lb.asset.getSceneAssets()
			--	apagamos Turbosmooths y colocamos cada asset en el modo de visualizacion skin+box
			--  EL PARAMETRO FALSE SE REFIERE A SEL ASSETS ONLY
			assetsToProcess = if selAssetsOnly then (getSelectedAssets()) else lb.asset.sceneAssets
			-- EL PARAMETRO ENABLECLOTH SE REFIERE AL BOTON ENABLE CLOTH IN EXPORT
			for a in assetsToProcess do this.prepareAssetForCacheRecording a enableCloth:false
				
			--lb.convertToCacheScene.run()
			resumeEditing()
			enableSceneRedraw()
			completeRedraw()
		
			--	si se va a guardar un nuevo fichero .max, pedimo un nombre para él y asumimos que, si
			--	se van a grabar también los ficheros de datos de caché, irán a parar a la misma ruta
			--	que el fichero .max pero dentro de una carpeta \source

			-- EL PARAMETRO TRUE SE REFIERE AL BOTON SAVE NEW FILE
			if saveNewMaxFile then
			(
				if findString maxFileName "_anim" != undefined then
					newName = (substituteString maxFileName "_anim" "_cache")
				else if findString maxFileName "_cloth" != undefined then
					newName = (substituteString maxFileName "_cloth" "_cache")
				else if findString maxFileName "_fx" != undefined then
					newName = (substituteString maxFileName "_fx" "_cache")
				else if findString maxFileName "_hair" != undefined then
					newName = (substituteString maxFileName "_hair" "_cache")
				else if findString maxFileName "_cache" != undefined then
					newName = (substituteString maxFileName "_cache" "_cache")
				else
					newName = maxFileName
				
				--intenta que se abra en la carpeta de caches
				 _currentPath = maxfilepath
				if matchPattern _currentPath pattern:"*anim\\" then
					if doesFileExist (substituteString _currentPath "anim\\" "cache\\") then
						_currentPath = (substituteString _currentPath "anim\\" "cache\\")
				
				cacheFileName = (_currentPath + newName) 
				
				if cacheFileName != undefined then
					cachesFolder = ((getFileNamePath cacheFileName) + "source\\")
				else
					continueProcess = false
				
			)
			--	Si no se va a guardar un nuevo .max pero sí se van a tratar los caches pedimos una ruta
			--	donde almacenar los ficheros de datos de cache.

			-- EL PARAMETRO TRUE SE REFIERE AL BOTON PROCESS CACHE
			else if processCaches then
			(
				cachesFolder = _currentPath + "source\\"
			)
			
			--	si no existían ficheros de cache en la carpeta SOURCE comprobamos que 
			--	el formato de exportación elegido sea PC2, que es más óptimo.
			--  LO MAS PROBABLE ES QUE NO HAGA FALTA.
			/*if cachesFolder != undefined and (getFiles (cachesFolder + "*.*")).count == 0 and _fileType != ".pc2" 
					if true then
						ddlCacheFormat.selection = 1*/
						
			--  LO MAS PROBABLE ES QUE NO HAGA FALTA.
			/*if cachesFolder != undefined and (getFiles (cachesFolder + "*.*")).count > 0 then
			(
				_oldCacheFiles = (getFiles (cachesFolder + "*.*"))
				_oldCacheFilesType = undefined
				
				--	revisamos el formato de los ficheros de cache que pudieran existir anteriormente
				for f in _oldCacheFiles where _oldCacheFilesType == undefined do
				(
					_fileType = (toLower (getFileNameType f))
					
					if _fileType == ".xml" then
						_oldCacheFilesType = _fileType
					else if _fileType == ".pc2" then
						_oldCacheFilesType = _oldCacheFilesType
				)
				
				--	Si existían ficheros miramos si el formato que vamos a crear es el mismo que ya existía
				--	Si no coinciden lanzamos un Warning
				_showFormatWarning = false
				
				if _oldCacheFilesType != undefined then
					_showFormatWarning = 	((_oldCacheFilesType == ".xml" and ddlCacheFormat.selected == ".pc2") or \
														(_oldCacheFilesType == ".pc2" and ddlCacheFormat.selected == ".xml"))
				
				if _showFormatWarning then
				(
					messageBox ("Destination SOURCE folder contains " + (toUpper _oldCacheFilesType) + " files and you selected to export " + (toUpper ddlCacheFormat.selected) + " cache files. Can't continue.")
					continueProcess = false
				)
				
				--	Si la carpeta SOURCE no está vacía pedimos confirmación de borrado o sobreescritura de los ficheros.
				if continueProcess then
				(
					if false then
					(
						if not queryBox "Destination SOURCE folder to save caches is not empty. Files will be deleted. Do you want to continue?" then continueProcess = false
					)
					else
					(
						if not queryBox "Destination SOURCE folder to save caches is not empty. Files will be overwriten. Do you want to continue?" then continueProcess = false
					)
				)
			)*/
				
			--	Si todos los pasos han sido correctos realizamos la conversión
			if continueProcess then
			(
				--	si solo vamos a convertir ciertos assets, el resto los borramos.
				for a in lb.asset.sceneAssets where findItem assetsToProcess a == 0 do
					lb.asset.deleteAsset a includeDependents:false
				
				--	conversión de la escena a caches
				-- se ha añadido de parametro desactivar cloth, para que no saque los caches de los objetos con cloth como tick en el ui
				lb.cache.convertSceneToCaches true true cachesFolder:cachesFolder pcFormat:".pc2" deleteOldCacheFiles:true mergeXrefs:false
				
				--	guardamos el nuevo fichero .max si se ha indicado
				-- TRUE HACE REFERENCIA AL SAVE NEW FILE 
				if saveNewMaxFile then saveMaxFile cacheFileName 
				
				--	reiniciamos el listado de assets para mostrar el nuevo estado
			)

			setArrowCursor()
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run processAssets:true processCaches:true saveNewMaxFile:true deleteOldCacheFiles:true mergeXrefs:false selAssetsOnly:false =
		(
			createSceneCache processAssets:processAssets processCaches:processCaches saveNewMaxFile:saveNewMaxFile deleteOldCacheFiles:deleteOldCacheFiles mergeXrefs:mergeXrefs selAssetsOnly:selAssetsOnly
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
			lb.addScript this --añade el script a la libreria principal
		)
		
	)--sc_templateScript
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_convertToCacheScene() --crea el script
)