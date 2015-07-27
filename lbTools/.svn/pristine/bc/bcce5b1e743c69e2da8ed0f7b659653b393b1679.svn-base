------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta superIsolate.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta superIsolate.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "superIsolate"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 135		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpIsolate "" pos:[5,0] width:210 height:100
		checkbutton ckbIsolate "Isolate" pos:[10,10] width:200 height:35
		--checkbox chkDependents "dependents" pos:[10,50] width:95 height:15 checked:true
		checkbox chkLinks "include links" pos:[10,50] width:95 height:15 checked:true
		checkbox chkCameras "include cameras" pos:[10,65] width:95 height:15 checked:true
		checkbox chkLights "include lights" pos:[10,80] width:95 height:15 checked:false
		
		--groupBox grpMerge "" pos:[110,0] width:105 height:85
		--button btnMerge "Merge" pos:[115,10] width:95 height:20
		
		label lblInfo "progress info" pos:[5,105] width:210 height:15 style_sunkenedge:true
		progressBar pbIsolate "" pos:[5,120] width:210 height:10
		
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
		--averigua si el archivo tiene hecho un isolated ya o no
		--devuelve TRUE si esta isolado y FALSE en caso contrario
		--si se le pasa un string, extrae la informacion de la ruta de el
		---------------------------------------------------------------------------------------------------------------
		fn isFileIsolated file:"" =
		(
			fileName = maxFileName
			
			if file != "" then --si se ha pasado por parametro una ruta, obtiene de ahi el path y el nombre
			(
				fileName = (filterString file "\\")
				fileName = fileName[fileName.count]
			)
			
			if findString fileName "_isolated" != undefined then true else false
		)	

		---------------------------------------------------------------------------------------------------------------
		--actualiza el estado de los controles del interface
		---------------------------------------------------------------------------------------------------------------
		fn updateUI =
		(
			if (isFileIsolated()) then --si esta Isolado
			(
				ckbIsolate.checked = true
				ckbIsolate.caption = "Exit Isolation Mode"
				--chkDependents.enabled = false
				chkLinks.enabled = false
				chkCameras.enabled = false
				chkLights.enabled = false
			)
			else --si no esta isolado
			(
				ckbIsolate.checked = false
				ckbIsolate.caption = "Isolate"
				--chkDependents.enabled = true
				chkLinks.enabled = true
				chkCameras.enabled = true
				chkLights.enabled = true
			)--if isolated
		)
		
		---------------------------------------------------------------------------------------------------------------
		--hace un isolate del archivo
		---------------------------------------------------------------------------------------------------------------
		fn isolate file /*dependents:true*/ includeLinks:true =
		(
			success = true
			
			lblInfo.caption = "getting assets from selection..."
			
			--busca los objetos que sean necesarios para isolar --------------------
			assetsToWork = lb.asset.getAssetsFromNodes (getCurrentSelection()) --obtiene los assets en funcion de los objetos seleccionados
			
			pbIsolate.value = 35 --progreso
				
			auxSceneAssets = undefined
			
			/*if dependents then --si tiene que utilizar tambien los dependientes -------------------------
			(
				lblInfo.caption = "getting dependent assets..."
				
				auxSceneAssets = lb.asset.getSceneAssets()
				
				deps = #() --array con todos los assets, los seleccionados y los dependientes
				for ast in assetsToWork do
				(
					deps += lb.asset.getDependencyGroup ast auxSceneAssets
				)--for
				
				assetsToWork = makeUniqueArray deps --sustituye el array
			)*/--if dependents --------------------------------------------------------------------------------------
			
			
			pbIsolate.value = 50 --progreso
			lblInfo.caption = "getting objects from assets..."
			
			assetsToWorkObjs = #() --objetos de los assets que dejar isolados
			for ast in assetsToWork do
				assetsToWorkObjs += ast.nodes
			
			pbIsolate.value = 60 --progreso
			lblInfo.caption = "getting selected objects..."
			
			--añade los objetos de la seleccion al array
			assetsToWorkObjs += (getCurrentSelection()) as array
			assetsToWorkObjs = makeUniqueArray assetsToWorkObjs			
			---------------------------------------------------------------------------
			
			pbIsolate.value = 60 --progreso
			
			if includeLinks then --si tiene que llevarse los objetos que tienen link constraint ----------
			(
				lblInfo.caption = "getting linked objects/assets..."
				
				if auxSceneAssets == undefined then auxSceneAssets = lb.asset.getSceneAssets()
				
				for a in assetsToWork do
					assetsToWorkObjs += lb.asset.getAssetDependentLinkedObjects a allAssets:auxSceneAssets
				
				for a in assetsToWork do
					assetsToWorkObjs += lb.asset.getAssetParentLinkedObjects a allAssets:auxSceneAssets
				
				assetsToWorkObjs = makeUniqueArray assetsToWorkObjs
			)--if includelinks -------------------------------------------------------------------------------------
			
			pbIsolate.value = 70 --progreso
			
			--añade las camaras a los objetos que llevarse------------------------
			if chkCameras.checked then
			(
				lblInfo.caption = "getting cameras..."
				assetsToWorkObjs += cameras as array
			)
			--------------------------------------------------------------------------
			
			pbIsolate.value = 73 --progreso
			
			--añade las camaras a los objetos que llevarse------------------------
			if chkLights.checked then
			(
				lblInfo.caption = "getting lights..."
				assetsToWorkObjs += lights as array
			)
			--------------------------------------------------------------------------
			
			pbIsolate.value = 76 --progreso
			
			lblInfo.caption = "getting objects to delete..."
			
			--busca los objetos de la escena para borrar--------------------------
			objsToDelete = deepcopy (objects as array)
			
			for obj in assetsToWorkObjs do
			(
				index = findItem objsToDelete obj
				if index != 0 then deleteItem  objsToDelete index
			)
			---------------------------------------------------------------------------
			
			--borra los assets no seleccionados y que sean sets------------------
			if auxSceneAssets == undefined then auxSceneAssets = lb.asset.getSceneAssets()
			
			for ast in auxSceneAssets where findItem assetsToWork ast == 0 and ast.isXrefScene do
				deleteAsset ast
			---------------------------------------------------------------------------
			
			pbIsolate.value = 80 --progreso
			lblInfo.caption = "deleting unnecessary objects..."
			
			--elimina los objetos innecesarios--------------------------------------
			delete objsToDelete
			---------------------------------------------------------------------------
			
			pbIsolate.value = 85 --progreso
			lblInfo.caption = "saving isolated file..."
			
			disableNotificationsBckp = disableNotifications
			disableNotifications = true
			success = saveMaxFile file quiet:true --intenta guardar el archivo
			disableNotifications = disableNotificationsBckp
			
			--elimina las capas vacias-----------------------------------------------
			(LayerManager.getLayer 0).current = true
			for i=LayerManager.count - 1 to 1 by -1 do
				LayerManager.deleteLayerByName  (LayerManager.getLayer i).name
			---------------------------------------------------------------------------
			
			pbIsolate.value = 95 --progreso
			
			success
		)
		
		---------------------------------------------------------------------------------------------------------------
		--hace un merge del archivo
		---------------------------------------------------------------------------------------------------------------
		fn mergeIsolation originalFile fileToMerge =
		(
			lblInfo.caption = "loading procedence file..."
			
			success = true
			
			disableNotificationsBckp = disableNotifications
			disableNotifications = true
			
			pbIsolate.value = 40 --progreso
			
			success = loadMaxFile originalFile useFileUnits:true quiet:true
			if success then
			(
				lblInfo.caption = "getting objects to delete..."
				
				pbIsolate.value = 60 --progreso
				
				objsToDelete = #()
				objsToDeleteNames = getMAXFileObjectNames fileToMerge quiet:true
				
				pbIsolate.value = 70 --progreso
				
				for obj in objects where findItem objsToDeleteNames obj.name != 0 do
					append objsToDelete obj
				
				pbIsolate.value = 80 --progreso
				lblInfo.caption = "deleting objects to substitute..."
				
				delete objsToDelete
				
				pbIsolate.value = 85 --progreso
				lblInfo.caption = "merging isolated file..."
				
				objectsBefore = objects as array --almacena los objetos antes del merge
				
				success = mergeMAXFile fileToMerge #deleteOldDups #useSceneMtlDups #alwaysReparent
				
				pbIsolate.value = 90 --progreso
				lblInfo.caption = "updating Xref merged objects..."
				
				objectsAfter = objects as array --almacena los objetos 
				stop = false --flag de parada
				selBckp = (getCurrentSelection())	
				
				for obj in objectsAfter where not stop and findItem objectsBefore obj == 0 and classof obj == XRefObject do
				(
					select obj
					max modify mode
					modPanel.setCurrentObject obj.baseObject
					stop = true
				)
				
				select selBckp
				
				pbIsolate.value = 95 --progreso
			)
				
			disableNotifications = disableNotificationsBckp
			
			success
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

		---------------------------------------------------------------------------------------------------------------
		--hace un isolate del archivo o un merge
		---------------------------------------------------------------------------------------------------------------
		on ckbIsolate changed state do
		(
			if state then
			(--isolate			
				lblInfo.caption = "checking selection..."
				
				stop = selection.count == 0 --no sigue si no hay nada seleccionado
					
				--si no hay objetos seleccionados
				if stop then lb.message.show "you must select at least one object to isolate" type:#message
				
				if not stop and getSaveRequired() then --si hay cambios en el archivo que no ha sido guardados aun, pide que salves
				(
					lblInfo.caption = "checking save state..."
					
					--pregunta si queremos guardar los cambios antes de hacer isolate
					stop = not querybox "file has changes, it must be saved to continue isolation. Do you want to save it now?"	
					
					if not stop then
					(
						lblInfo.caption = "saving current file..."
						
						disableNotificationsBckp = disableNotifications
						disableNotifications = true
						stop = not saveMaxFile (maxFilePath + maxFileName) quiet:true --intenta guardar el archivo
						disableNotifications = disableNotificationsBckp
						
						pbIsolate.value = 5 --progreso
						
						if stop then lb.message.show "error saving file" type:#message

					)
				)	
				
				pbIsolate.value = 20 --progreso
				
				if not stop then
				(
					lblInfo.caption = "asking for isolated file name..."
					
					--nombre que tendrá el archivo isolated
					isolatedFileName = (substituteString (maxFilePath + maxFileName) ".max" "") + "_isolated.max"
					
					--cuadro de dialogo para salvar, en el que podemos decidir otro nombre para el archivo
					newFile = getSaveFileName caption:"Save Isolated File" filename:isolatedFileName types:"max file(*.max)|*.max"
					
					pbIsolate.value = 25 --progreso
					
					if newFile != undefined then --si hay una ruta de archivo donde salvar el isolated
					(
						lblInfo.caption = "trying to isolate file..."
						
						setWaitCursor()
						
						with undo off
							success = isolate newFile /*dependents:chkDependents.checked*/ includeLinks:chkLinks.checked --realiza el isolate
						
						setArrowCursor()
						
						if success then (lblInfo.caption = "isolated file created."; updateUI(); gc())
					)--if newFile
				)--if not stop
				
				pbIsolate.value = 100 --progreso
				
				pbIsolate.value = 0 --progreso
				
				lblInfo.caption = "progress info"
			)--isolate
			else
			(--merge
				stop = false --flag para saber si hay que detener la ejecucion
				
				if not stop and getSaveRequired() then --si hay cambios en el archivo que no ha sido guardados aun, pide que salves
				(
					lblInfo.caption = "checking save state..."
					
					--pregunta si queremos guardar los cambios antes de hacer isolate
					stop = not querybox "file has changes, it must be saved to continue merge. Do you want to save it now?"	
					
					pbIsolate.value = 5 --progreso
					
					if not stop then
					(
						lblInfo.caption = "saving isolated file..."
						
						disableNotificationsBckp = disableNotifications
						disableNotifications = true
						stop = not saveMaxFile (maxFilePath + maxFileName) quiet:true --intenta guardar el archivo
						disableNotifications = disableNotificationsBckp
						
						if stop then lb.message.show "error saving file" type:#message
					)
				)	
				
				pbIsolate.value = 20 --progreso
				
				if not stop then
				(
					lblInfo.caption = "looking for procedence file..."
					
					--nombre que tenía el archivo antes de hacer el merge
					currentFileName = (maxFilePath + maxFileName)
					originalFileName = ""
					
					index = findString currentFileName "_isolated"
					if index != undefined then
						originalFileName = (subString currentFileName 1 (index - 1)) + ".max"
					else
						stop = true
						
					pbIsolate.value = 25 --progreso
							
					if not stop and not doesFileExist originalFileName then --si no encuentra el archivo original pide que lo busques
					(
						lblInfo.caption = "asking for procedence file..."
						
						originalFileName = getOpenFileName caption:"Original file not found, choose one" filename:originalFileName types:"max file(*.max)|*.max"
						if originalFileName == undefined then stop = true
					)
					
					pbIsolate.value = 30 --progreso
					
					if not stop then --si se ha encontrado el archivo original
					(
						lblInfo.caption = "trying to merge isolated file into procedence file..."
						
						setWaitCursor()
						
						with undo off
							success = mergeIsolation originalFileName currentFileName --realiza el merge
						
						setArrowCursor()
						
						if success then (lblInfo.caption = "isolated file merged."; updateUI(); gc())
					)
				)--if not stop
				
				pbIsolate.value = 100 --progreso
				
				pbIsolate.value = 0 --progreso
				
				lblInfo.caption = "progress info"
				
				clearSelection() -- limpia la seleccion
			)--merge
			
			updateUI()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
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
			updateUI()
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
	--@struct: superIsolate | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_superIsolateUI
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Super Isolate",		--@var: description | Descripcion de la tool.
		
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
			createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_superIsolateUI
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_superIsolateUI() --crea la herramienta
)