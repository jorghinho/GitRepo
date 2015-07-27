------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria superIsolate
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: superIsolate | Contiene la libreria superIsolate.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_superIsolate
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de funciones superIsolate",	--@var: description | Descripcion de la libreria.
		
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

		------------------------------------------------------------------------------------------------
		--@fn: undefined | isolate | Hace un isolate de la seleccion o de la opciones que pinchemos.
		------------------------------------------------------------------------------------------------
		fn isolate file dependents:true includeLinks:true includeCameras:true includeLights:false = 
		(
			_success = true
			
			lb.superIsolateUI.setInfo "getting assets from selection..."
			
			--busca los objetos que sean necesarios para isolar --------------------
			assetsToWork = lb.asset.getAssetsFromNodes selection --obtiene los assets en funcion de los objetos seleccionados
			
			lb.superIsolateUI.setProgress 35 --progreso
				
			auxSceneAssets = undefined
			
			if dependents then --si tiene que utilizar tambien los dependientes -------------------------
			(
				lb.superIsolateUI.setInfo "getting dependent assets..."
				
				auxSceneAssets = lb.asset.getSceneAssets()
				
				deps = #() --array con todos los assets, los seleccionados y los dependientes
				for ast in assetsToWork do
				(
					deps += lb.asset.getDependencygroup ast auxSceneAssets
				)--for
				
				assetsToWork = makeUniqueArray deps --sustituye el array
			)--if dependents --------------------------------------------------------------------------------------
			
			
			lb.superIsolateUI.setProgress 50 --progreso
			lb.superIsolateUI.setInfo "getting objects from assets..."
			
			assetsToWorkObjs = #() --objetos de los assets que dejar isolados
			for ast in assetsToWork do
				assetsToWorkObjs += ast.nodes
			
			lb.superIsolateUI.setProgress 60 --progreso
			lb.superIsolateUI.setInfo "getting selected objects..."
			
			--añade los objetos de la seleccion al array
			assetsToWorkObjs += selection as array
			assetsToWorkObjs = makeUniqueArray assetsToWorkObjs			
			---------------------------------------------------------------------------
			
			lb.superIsolateUI.setProgress 60 --progreso
			
			if includeLinks then --si tiene que llevarse los objetos que tienen link constraint ----------
			(
				lb.superIsolateUI.setInfo "getting linked objects/assets..."
				
				if auxSceneAssets == undefined then auxSceneAssets = lb.asset.getSceneAssets()
				
				for a in assetsToWork do
					assetsToWorkObjs += lb.asset.getAssetDependentLinkedObjects a allAssets:auxSceneAssets
				
				for a in assetsToWork do
					assetsToWorkObjs += lb.asset.getAssetParentLinkedObjects a allAssets:auxSceneAssets
				
				assetsToWorkObjs = makeUniqueArray assetsToWorkObjs
			)--if includelinks -------------------------------------------------------------------------------------
			
			lb.superIsolateUI.setProgress 70 --progreso
			
			--añade las camaras a los objetos que llevarse------------------------
			if includeCameras then
			(
				lb.superIsolateUI.setInfo "getting cameras..."
				assetsToWorkObjs += cameras as array
			)
			--------------------------------------------------------------------------
			
			lb.superIsolateUI.setProgress 73 --progreso
			
			--añade las camaras a los objetos que llevarse------------------------
			if includeLights then
			(
				lb.superIsolateUI.setInfo "getting lights..."
				assetsToWorkObjs += lights as array
			)
			--------------------------------------------------------------------------
			
			lb.superIsolateUI.setProgress 76 --progreso
			
			lb.superIsolateUI.setInfo "getting objects to delete..."
			
			--busca los objetos de la escena para borrar--------------------------
			_objsToDelete = deepcopy (objects as array)
			
			for obj in assetsToWorkObjs do
			(
				_index = findItem _objsToDelete obj
				if _index != 0 then deleteItem  _objsToDelete _index
			)
			---------------------------------------------------------------------------
			
			--borra los assets no seleccionados y que sean sets------------------
			if auxSceneAssets == undefined then auxSceneAssets = lb.asset.getSceneAssets()
			
			for ast in auxSceneAssets where findItem assetsToWork ast == 0 and ast.isXrefScene do
				lb.asset.deleteAsset ast
			---------------------------------------------------------------------------
			
			lb.superIsolateUI.setProgress 80 --progreso
			lb.superIsolateUI.setInfo "deleting unnecessary objects..."
			
			--elimina los objetos innecesarios--------------------------------------
			delete _objsToDelete
			---------------------------------------------------------------------------
			
			lb.superIsolateUI.setProgress 85 --progreso
			lb.superIsolateUI.setInfo "saving isolated file..."
			
			_success = saveMaxFile file quiet:true --intenta guardar el archivo
			
			--elimina las capas vacias-----------------------------------------------
			(LayerManager.getLayer 0).current = true
			for i=LayerManager.count - 1 to 1 by -1 do
				LayerManager.deleteLayerByName  (LayerManager.getLayer i).name
			---------------------------------------------------------------------------
			
			lb.superIsolateUI.setProgress 95 --progreso
			
			_success
		),


		------------------------------------------------------------------------------------------------
		--@fn: undefined | mergeIsolation | Hace un merge del archivo.
		------------------------------------------------------------------------------------------------
		fn mergeIsolation originalFile fileToMerge =
		(
			lb.superIsolateUI.setInfo "loading procedence file..."
			
			_success = true
			
			lb.superIsolateUI.setProgress 40 --progreso
			
			_success = loadMaxFile originalFile useFileUnits:true quiet:true
			if _success then
			(
				lb.superIsolateUI.setInfo "getting objects to delete..."
				
				lb.superIsolateUI.setProgress 60 --progreso
				
				_objsToDelete = #()
				_objsToDeleteNames = getMAXFileObjectNames fileToMerge quiet:true
				
				lb.superIsolateUI.setProgress 70 --progreso
				
				for obj in objects where findItem _objsToDeleteNames obj.name != 0 do
					append _objsToDelete obj
				
				lb.superIsolateUI.setProgress 80 --progreso
				lb.superIsolateUI.setInfo "deleting objects to substitute..."
				
				delete _objsToDelete
				
				lb.superIsolateUI.setProgress 85 --progreso
				lb.superIsolateUI.setInfo "merging isolated file..."
				
				_objectsBefore = objects as array --almacena los objetos antes del merge
				
				_success = mergeMAXFile fileToMerge #deleteOldDups #useSceneMtlDups #alwaysReparent
				
				lb.superIsolateUI.setProgress 90 --progreso
				lb.superIsolateUI.setInfo "updating Xref merged objects..."
				
				_objectsAfter = objects as array --almacena los objetos 
				_process = true --flag de parada
				selBckp = getCurrentSelection()	
				
				for obj in _objectsAfter where _process and findItem _objectsBefore obj == 0 and classof obj == XRefObject do
				(
					select obj
					max modify mode
					modPanel.setCurrentObject obj.baseObject
					_process = false
				)
				
				select selBckp
				
				lb.superIsolateUI.setProgress 95 --progreso
			)

			
			_success
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
		
	)--lib_superIsolate
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_superIsolate() --crea la libreria
)