------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMxrefMeshManagerDef | Contiene la herramienta xref Mesh Manager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMxrefMeshManagerDef "Xref Mesh Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local fileObjects = #()
		local asset = lb.asset.getSceneAnimAssets()
		local fileIndex = undefined
		local iconpath = if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/"		-- ruta de los iconos de Max.
		local xrefNames = #()
		local xrefFiles = #()

		------------------------------------------------
		--@fn: undefined | getXrefFiles | capturamos los archivos de xRef y los colocamos en el multilist que corresponde
		------------------------------------------------
		fn getXrefFiles =
		(
			xrefFiles = #()
			xrefNames = #()
			_xref = undefined
			_xrefName = #()
			_temp = #()
			
			for i=1 to objXRefMgr.recordCount do
			(
				--Capturamos los max file del interface de xref, los filtramos para eliminar la ruta completa y quedarnos sólo con los .max. Finalmente metemos sus nombres en el array _xrefFiles
				_xref = objXRefMgr.GetRecord i
				_xrefName = filterstring _xref.srcFileName "\\"
				_temp = _xrefName.count
				
				-- rellenamos el array xrefNames con los archivos filtrados para visualización 
				append xrefNames _xrefName[_temp]
				-- rellenamos el array xrefFiles con los archivos con ruta completa 
				append xrefFiles _xref.srcFileName
				
			)
			xrefNames
		)

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnAddXrefMesh "Add Xref File" pos:[5,5] width:30 height:30 images:#(iconpath + "bip_copy1paste_i.bmp", undefined, 10, 1, 1, 2, 2,true) toolTip: "Add Xref File"
		button btnDeleteXrefMesh "Delete Xref Files" pos:[35,5] width:30 height:30 images:#(iconpath + "Xrefs_i.bmp", undefined, 16, 2, 2, 2, 2,true) toolTip: "Delete selected Xref File"
		button btnRetargetXrefMesh "Retarget Mesh" pos:[65,5] width:30 height:30 images:#(iconpath + "Xrefs_i.bmp", undefined, 16, 5, 5, 5, 5,true) toolTip: "Retarget Mesh"
		checkbox chkAutoRename "" pos:[105,10] checked:true
		label lblAutoRename "Auto Rename" pos:[125,10] 
		 
		multiListBox mlbxFiles "Xref files in scene" pos:[4,40] width:198 height:4 items: (getXrefFiles()) selection: 0
		multiListBox mlbxObjects "Objects loaded from selected Xref file" pos:[4,120] width:198 height:18
		button btnAddXrefObjs "Add Xref Objects" pos:[5,395] width:30 height:30 images:#(iconpath + "enss_tools_16i.bmp", undefined, 13, 5, 5, 6, 6,true) toolTip: "Add Xref Objects" enabled:false
		button btnDeleteXrefObjs "Del Xref Objects" pos:[35,395] width:30 height:30 images:#(iconpath + "enss_tools_16i.bmp", undefined, 13, 3, 3, 4, 4,true) toolTip: "Delete Xref selected objects" enabled:false
		checkbox chkNotLoaded "Show not loaded objects" pos:[70,400] width:120 height:30 checked:false enabled:false
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------

		-------------------------------------------------
		--@fn: undefined | getSourceFile | lanza el dialogo de obtener un fichero y devuelve la ruta + el nombre del fichero
		-------------------------------------------------
		fn getSourceFile =
		(
			getOpenfileName caption:"Xref File" initialDir:maxFilePath
		)	

		-------------------------------------------------
		--@fn: undefined | getFileObjects | captura los objetos del archivo de xref y los muestra en el multilistbox.Si la casilla de "show not loaded" está marcada, se filtran los objetos no cargados unicament
		-------------------------------------------------
		fn getFileObjects fileIndex =
		(
			
			_nodes = #()
			--comprobamos si la casilla de shownotloaded está activada
			if chkNotLoaded.state then
			(
				btnAddXrefObjs.enabled = true--activamos el btn de añadir si la casilla show not loaded está activada
				fileObjects = getMAXFileObjectNames xrefFiles[fileIndex]
				
				--capturamos todos los nodos de mesh y facial de la escena en un array
				for i=1 to ((objXRefMgr.GetRecord fileIndex).ItemCount #XRefObjectType) do
				(
					append _nodes (((objXRefMgr.GetRecord fileIndex).getItem i #XRefObjectType).srcItemName)
				)				
				--contrastamos la lista de nodos del archivo de xref con los actuales de la escena
				for i=1 to _nodes.count do
				(
					if (findItem fileObjects (_nodes[i])) != 0 then
					(
						deleteItem fileObjects (findItem fileObjects (_nodes[i]))
					)
				)
			)
			else
			(
				fileObjects = #()
				
				if (objXRefMgr.GetRecord fileIndex) != undefined then
					for i=1 to ((objXRefMgr.GetRecord fileIndex).ItemCount #XRefObjectType) do
					(
						append fileObjects (((objXRefMgr.GetRecord fileIndex).getItem i #XRefObjectType).srcItemName)
					)
			-- 			fileObjects = getMAXFileObjectNames xrefFiles[fileIndex]
			)
			mlbxObjects.items = fileObjects
		)

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | resetTool | resetea la tool para cuando saltan los callbacks de reseteo, carga de archivo o mergeo de xref.
		------------------------------------------------
		fn resetTool =
		(
			mlbxObjects.items = #()
			mlbxFiles.items = (getXrefFiles())
			mlbxFiles.selection = 0
			fileIndex = undefined
			asset = lb.asset.getSceneAnimAssets()
			chkNotLoaded.enabled=false
			btnDeleteXrefObjs.enabled=false
			btnAddXrefObjs.enabled=false
		)

		------------------------------------------------
		--@fn: undefined | updateUI | actualiza el UI
		------------------------------------------------
		fn updateUI =
		(
			mlbxObjects.selection = 0
			mlbxObjects
			if chkNotLoaded.state then
			(
				btnAddXrefObjs.enabled=true--activamos el btn de añadir si la casilla show not loaded está activada
				btnDeleteXrefObjs.enabled=false--desactivamos el btn de borrar si la casilla show not loaded está activada
			)
			else
			(
				btnAddXrefObjs.enabled=false--desactivamos el btn de añadir si la casilla show not loaded está desactivada
				btnDeleteXrefObjs.enabled=true--activamos el btn de borrar si la casilla show not loaded está desactivada
			)
			--sólo usamos este check si el valor de fileIndex es distinto de undefined
			if mlbxFiles != 0 then
			(
				chkNotLoaded.enabled=true
			)
			else 
			(
				chkNotLoaded.enabled=false
			)
		)

		------------------------------------------------
		--@fn: undefined | refreshList | al borrar un objeto se actualiza la lista en base a este cambio. Llamada por los callback de eliminar nodos y cargar xrefs
		------------------------------------------------
		fn refreshList =
		(
			mlbxFiles.items = (getXrefFiles())
			_index = mlbxFiles.selection as array
				
			-- 			print mlbxFiles.items.count 				
			if (mlbxObjects.items).count != 0 and (mlbxFiles.items).count != 0 then
			(
			-- 				mlbxFiles.selection = fileIndex
				for i = 1 to _index.count do getFileObjects _index[i]
			-- 				mlbxObjects.selection = 0
			)
			else
			(	
				resetTool()
			)
		)

		------------------------------------------------
		--@fn: undefined | loadSelectedXref | carga los Xrefs seleccionados en la lista
		------------------------------------------------		
		fn loadSelectedXref =
		(
			_nodes = #()
			_selection = #()
			_workingNodes = #() --donde meteremos los nombres de los objetos a mergear en la escena
			_selection = mlbxObjects.selection as array
			_index = mlbxFiles.selection as array
			xRefNodes = lb.xref.getXrefMeshNodesFromAssets (lb.asset.getSceneAssets())

			--filtramos los elementos seleccionados para poder cargarlos a continuación
			for i=1 to _selection.count do append _workingNodes fileObjects[_selection[i]]
			

			--cargamos todos los objetos seleccionados en el array _workingNodes
			objXRefMgr.dupMtlNameAction = #useScene
			_objects = objXRefMgr.AddXRefItemsToRecord (objXRefMgr.GetRecord (_index[1])) objNames:_workingNodes
			objXRefMgr.dupMtlNameAction = #prompt
			lb.materials.deleteDuplicatedMaterials xRefNodes
	
			--metemos controladores XYZ en los objetos recién traídos
			for i=1 to _workingNodes.count do
			(
				if _workingNodes.count !=0 then append _nodes (execute ("$'" + _workingNodes[i] + "'"))
				lb.xref.mergeXrefNodesControllers (_nodes)
			)
			
			-- Renombramos nodos quitandos los parentesis si tienen del nombre y lo dejamos limpio.	
			if chkAutoRename.checked then
			(
				print _nodes[1]
				
				_filterName = filterString _nodes[1].name "()"
				_filterPart = filterString _filterName[1] "_"
				_newAstName = (_filterPart[1] + "_" + _filterPart[2])		
				_astLayer = (layermanager.getLayerFromName _newAstName)
					
				for o in _nodes do o.name = lb.nc.replaceNamePart o.name 2 _filterPart[2]
								
				if _astLayer != undefined then
				(
					print "entra"
					_origLayerName = (_nodes[_nodes.count].layer.name)
					for o in _nodes do _astLayer.addNode o
					LayerManager.deleteLayerByName _origLayerName
				)
				else
					_workingNodes[1].layer.setName _newAstName
				
				
				
			)		
		)

		------------------------------------------------
		--@fn: undefined | refreshXrefFile | refresca los objetos Xrefs de la lista
		------------------------------------------------
		fn refreshXrefFile =
		(	
			objXRefMgr.UpdateAllRecords()
			resetTool()
		)

		------------------------------------------------
		--@fn: undefined | deleteSelectedXref | elimina los objetos Xrefs seleccionados en la lista
		------------------------------------------------
		fn deleteSelectedXref fileIndex=
		(
			_selection = #()
			_workingNodes = #() --donde meteremos los nombres de los objetos a mergear en la escena
			_selection = mlbxObjects.selection as array
			
			--filtramos los elementos seleccionados para poder cargarlos a continuación
			for i=1 to _selection.count do
				append _workingNodes fileObjects[_selection[i]]

			-- Como los objetos se renombran
			for i = 1 to _workingNodes.count do
			(
				_node = execute ("$'" + _workingNodes[i] + "'")
				_name = ("$'" + _workingNodes[i] + "'")
				
				if _node == undefined then
				(
					_filterName = filterString _name "()"
					_name = _filterName[1] + _filterName[3]
				)
				
				_node = execute _name

				if _node != undefined then delete _node
			)
		)

		------------------------------------------------
		--@fn: undefined | deleteXrefFile | elimina los archivos Xrefs seleccionados en la lista
		------------------------------------------------
		fn deleteXrefFile fileIndex =
		(
			objXRefMgr.RemoveRecordFromScene (objXRefMgr.GetRecord fileIndex)
			resetTool()			
		)

		------------------------------------------------
		--@fn: undefined | retargetXrefFile | redirige los archivos Xrefs seleccionados en la lista
		------------------------------------------------
		fn retargetXrefFile index =
		(
				file = undefined
				file = getSourceFile()
				if file != undefined then
					objXRefMgr.SetRecordSrcFile (objXRefMgr.GetRecord index) file 
				
				resetTool()	
		)

		------------------------------------------------
		--@fn: undefined | selectObject | selecciona los objetos en la escena desde el evento doble click en el multi list
		------------------------------------------------
		fn selectObject objIndex =
		(
			if chkNotLoaded.state == false then
			(
				_node = execute ("$'" + fileObjects[objIndex] + "'")
				_name = ("$'" + fileObjects[objIndex] + "'")
				
				if _node == undefined then
				(
					_filterName = filterString _name "()"
					_name = _filterName[1] + _filterName[3]
				)
				
				_node = execute _name
				
				select (_node)
			)
		)	

		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.addscript #filePostOpen "lb.riggingManager.rollRMxrefMeshManager.resetTool()" id:_id
			callbacks.addscript #objectXrefPostMerge "lb.riggingManager.rollRMxrefMeshManager.refreshList()" id:_id
			callbacks.addscript #nodePostDelete "lb.riggingManager.rollRMxrefMeshManager.refreshList()" id:_id	
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.removescripts id:_id		
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMxrefMeshManagerDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMxrefMeshManagerDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | añade el contenido de mesh de un archivo por xRef.
		------------------------------------------------
		on btnAddXrefMesh pressed do
		(
			setWaitCursor()
			file = getSourceFile()
			
			if file != undefined then
			(
				lb.xref.addXrefNodesFromFile file types:#(lb.nc.NC_classMesh, lb.nc.NC_classFacial, lb.nc.NC_classHair)
				xRefNodes = lb.xref.getXrefMeshNodesFromAssets (lb.asset.getSceneAssets())
			
					
				-- Renombramos nodos quitandos los parentesis si tienen del nombre y lo dejamos limpio.	
				if chkAutoRename.checked then
				(
					_filterName = filterString xRefNodes[1].name "()"
					_filterPart = filterString _filterName[1] "_"
					_newAstName = (_filterPart[1] + "_" + _filterPart[2])		
					_astLayer = (layermanager.getLayerFromName _newAstName)
						
						
					for o in xRefNodes do o.name = lb.nc.replaceNamePart o.name 2 _filterPart[2]
									
					if _astLayer != undefined then
					(
						_origLayerName = (xRefNodes[xRefNodes.count].layer.name)
						for o in xRefNodes do _astLayer.addNode o
						LayerManager.deleteLayerByName _origLayerName
					)
					else
						xRefNodes[1].layer.setName _newAstName
				
				)
				
				lb.xref.mergeXrefNodesControllers (xRefNodes)
				lb.materials.deleteDuplicatedMaterials xRefNodes
			)
			
			redrawViews()
			setArrowCursor()
		)	

		------------------------------------------------
		--@event: pressed | elimina los mesh que haya en la escena por xref
		------------------------------------------------
		on btnDeleteXrefMesh pressed do
		(
			xRefNodes = lb.xref.getXrefMeshNodesFromAssets (lb.asset.getSceneAssets())
			_chrLayer = xRefNodes[1].layer	
			
			_index = mlbxFiles.selection as array
			
			if _index.count != 0 then
			(
				for i = _index.count to 1 by -1 do deleteXrefFile _index[i]

				updateUI()			
					
				xRefNodes = lb.xref.getXrefMeshNodesFromAssets (lb.asset.getSceneAssets())
					
				if xRefNodes.count == 0 then		
					LayerManager.deleteLayerByName _chrLayer.name 	
			)
			else
				lb.message.show "Select a Xref file to delete" type:#message pos:undefined size:[300,75] modal:true
		)

		------------------------------------------------
		--@event: pressed | redirige las referencias de xref a otro archivo
		------------------------------------------------		
		on btnRetargetXrefMesh pressed do
		(
			_index = mlbxFiles.selection as array
			
			if _index.count != 0 then
				for i = 1 to _index.count do retargetXrefFile _index[i]
			else
				lb.message.show "Please select a Xref File first" type:#message pos:undefined size:[300,75] modal:true
		)

		------------------------------------------------
		--@event: pressed | refresca los xrefs
		------------------------------------------------		
		on btnRefreshXrefMesh pressed do
		(
			refreshXrefFile()
		)

		------------------------------------------------
		--@event: selectionEnd | actualiza los objetos respecto a los archivos seleccionados
		------------------------------------------------
		on mlbxFiles selectionEnd do
		(
			_index = mlbxFiles.selection as array
				
			for i = 1 to _index.count do getFileObjects _index[i]
				
			updateUI()
		)	

		------------------------------------------------
		--@event: doubleClicked | al hacer doble click en un elemento del multilist selecciona ese objeto en la escena
		------------------------------------------------
		on mlbxObjects doubleClicked objIndex do
		(
			selectObject objIndex
		)

		------------------------------------------------
		--@event: pressed | cargamos los xref seleccionados en la lista
		------------------------------------------------		
		on btnAddXrefObjs pressed do
		(
			loadSelectedXref()
			-- 			_index = mlbxFiles.selection as array
			
			-- 			for i = 1 to _index.count do loadSelectedXref _index[i]	
		)

		------------------------------------------------
		--@event: pressed | borramos los xref seleccionados en la lista
		------------------------------------------------		
		on btnDeleteXrefObjs pressed do
		(
			deleteSelectedXref fileIndex
			
			updateUI()
		)

		------------------------------------------------
		--@event: changed | marcamos para mostrar los objetos no cargados por xref actualmente
		------------------------------------------------
		on chkNotLoaded changed _state do 
		(
			updateUI()
			_index = mlbxFiles.selection as array
			
			for i = 1 to _index.count do getFileObjects _index[i]
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMxrefMeshManagerDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMxrefMeshManagerDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMxrefMeshManagerDef close do
		(	
			xrefNames = #()
			xrefFiles = #()
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMxrefMeshManagerDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMEditionRigDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMEditionRigDef "Edition Rig"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnRigSolutionManager "Open Rig Solution Manager" pos:[5,5] width:195 height:25
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMEditionRigDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMEditionRigDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | Abre la tool rig solution manager 
		------------------------------------------------		
		on btnRigSolutionManager pressed do
		(

			_tool = (lb.getTool "rigSolutionManager")
			if not _tool.isOpen() then _tool.run()
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMEditionRigDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMEditionRigDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMEditionRigDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMEditionRigDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMtwistManagerDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMtwistManagerDef "Twist Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local _pointControl = #() --contiene los point creados para el efecto de strech.
		local _twistNumber = #()  --contiene el número de twist dado en la pestaña. 
		local _twistIK = #()	  --contiene las Ik de los twist de la parte de Lower.
		local _LengthTwist = #()  --contiene el tamaño de cada hueso en relación al número de twist.
		local _twistBones = #()	  --contiene los huesos de twist.
		local _exposeHLpLower = #() --contiene el expose de la parte de lower.
		local _exposeHLpUpper = #() --contiene el expose de la parte de upper.
		local _nameTwist = #()	  --contiene las partes del nombre para los twist.
		local _twistBonesExtra = #() --contiene el hueso extra para la parte de upper.
		local _twistBonesExtraEnd = #() --contiene el hueso extraEnd para la parte de upper.
		local _pointLowerExtra = #() --contiene el point de referencia para el strech en lower.
		local _pointUpperExtra = #() --contiene el point de referencia para el strech en upper.	

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnCreateTwistSystem "Create System" pos:[5,5] width:95 height:25
		button btnDeleteTwist "Delete System" pos:[105,5] width:95 height:25
		
		spinner spnNumTwist "Num. Twist" pos:[40,35] width:60 height:16 range:[1,50,3] type:#integer
		
		checkbox ckbAutoStretch "AutoStrech" pos:[120,35] width:100 height:15 checked:true
		checkbox ckbUpperTwist "Upper Twist" pos:[120,55] width:85 height:15 checked:false
		checkbox ckbLowerTwist "Lower Twist" pos:[120,75] width:100 height:15 checked:false
		
		--checkbox chbAutoCreate "Auto Create" pos:[5,75] width:100 height:15 checked:true

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

		------------------------------------------------------------------------------
		--@fn: undefined | createBonTwist | Función para crear los huesos de twist y colocarlos según si es upper o lower, configuración del streching.
		--@gets: node | _boneSelection |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		fn createBonTwist _k =
		(
			_twistNumber = spnNumTwist.value --Obtención del valor puesto en el número de twist.
			
			--Recorremos la selección hecha de huesos para crearle el sistema de twist a cada uno de los huesos.
			_newBone = #()
			_LengthTwist = #()
			_twistBones = #()
			
			_LengthTwist = _k.length/_twistNumber --Obtención del tamaño de cada twist en relación al hueso base y el número de twist.
			_child = _k.children
			
			for _o=1 to (_twistNumber + 1) do -- bucle en el que se crean los huesos de twist, según el número de estos.
			(	
				_newBone = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1] -- creación de 'newBone' en coordenadas absolurtas 0,0,0 en dirección Z positiva y con na longitud igual a 'newLength'.
				
				--Filtramos el nombre y nombramos los huesos creados según la selección hecha.
				_nameTwist = filterstring _k.name "_"
				_newBone.name = _nameTwist[1] + "_" + _nameTwist[2] + "_" + _nameTwist[3] + "_" + _nameTwist[4] + "_" + _nameTwist[5] + "-Twist-bon-0" + (_o as String) + "_" + _nameTwist[6] + "_" + lb.nc.NC_skinFlag
				
				-- Parámetros de los huesos Twist.
				_newBone.length = _LengthTwist
				_newBone.wirecolor = color 255 255 0 -- Yellow
				_newBone.Taper = 0
				_newBone.width =  _k.width * 2
				_newBone.height = _k.height * 2
				_newBone.sidefins = false
				
				if  _k.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
				(
					_newBone.transform = _k.transform
					_newBone.objectOffsetScale = _k.objectOffsetScale -- iguala objectOffsetScale con hueso X
				)
				else
				(
					_newBone.transform = _k.transform --colocamos los huesos en la posicion del hueso seleccionado.
				)
				
				in coordSys Local move _newBone [(_k.objectoffsetscale.x)*(_newBone.length*(_o-1)),0,0] -- mueve el hueso twist al final del hueso twist anterior.
				
				append _twistBones _newBone -- añade los huesos de twist en un array
				
				if _o == (_twistNumber +1) then  --Selección del hueso final para cambiar sus propiedades.
				(
					_newBone.length = _newBone.height
					_newBone.Taper = 90
				)
				
				if _o > 1 then _twistBones[_o].parent = _twistBones[_o-1] -- Emparentado de huesos de twist.
				
				for _o in _twistBones do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
				
				if _o == 1 then
				(
					_twistBones[_o].parent = _k
				)
			)
			
			if ckbAutoStretch.checked == true then  --Si upper Twist esta act. entra en el bucle.
			(
				_pointControl = lb.rig.createStretchBoneChain _twistBones  --creación de los point de streching y su configuración de constraint.
				for _o in _pointControl do _o.size = _k.width * 5	   --Tamaño de los point.
				
				for i=1 to  _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso.
				(
					if i > 1 then
					(			
						lb.controller.setActiveController  _pointControl[i] #all #frozen
						_pointControl[i].parent =  _pointControl[i-1] --Emparentamos las IK entre si.
						lb.controller.setActiveController  _pointControl[i] #all #zero
					)
				)
				for _o in  _pointControl do lb.controller.freezeTransform _o #all  --freezeamos las piezas de Ik.
			)
		)	

		------------------------------------------------------------------------------
		--@fn: undefined | exposeLower | Función para crear el expose y elementos necesarios para su configuración, para los twist Lower
		--@gets: node | bon |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		mapped fn exposeLower bon =
		(
			_childLower = bon.children
			
			_filterPart = filterString bon.name "_"
			
			_pointLower = point()
			_pointLower.cross = false
			_pointLower.box = true
			_pointLower.size =  bon.width * 5
			_pointLower.wirecolor = color 255 255 0 -- Yellow
			_pointLower.transform = _childLower[1].transform
			_pointLower.parent = bon
			_pointLower.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeForearm" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _pointLower #all
			
			_pointLowerExtra = point()
			_pointLowerExtra.cross = false
			_pointLowerExtra.box = true
			_pointLowerExtra.size =  bon.width * 5
			_pointLowerExtra.wirecolor = color 255 255 0 -- Yellow
			_pointLowerExtra.transform = bon.transform
			_pointLowerExtra.parent = bon
			_pointLowerExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeForearmExtra" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _pointLowerExtra #all
			
			_exposeHLpLower = ExposeTm()
			_exposeHLpLower.centermarker = true
			_exposeHLpLower.axistripod = true
			_exposeHLpLower.cross = false
			_exposeHLpLower.size =  bon.width * 5
			_exposeHLpLower.wirecolor = color 255 255 0 -- Yellow
			_exposeHLpLower.transform = _childLower[1].transform
			_exposeHLpLower.parent = _childLower[1]
			_exposeHLpLower.exposeNode = _childLower[1]
			_exposeHLpLower.useParent = false
			_exposeHLpLower.localReferenceNode = _pointLower
			_exposeHLpLower.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-Expose" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _exposeHLpLower #all
		)	

		------------------------------------------------------------------------------
		--@fn: undefined | exposeUpper | Función para crear el expose y los huesos extras para formar la IkLimb en la parte de upper.
		--@gets: node | bon |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		mapped fn exposeUpper bon =
		(
			_filterPart = filterString bon.name "_"
			
			--creación del point auxiliar para el codo y configuración.
			_pointUpperExtra = point()		
			_pointUpperExtra.cross = false
			_pointUpperExtra.box = true
			_pointUpperExtra.size =  bon.width * 6
			_pointUpperExtra.wirecolor = color 255 255 0 -- Yellow
			_pointUpperExtra.transform = bon.transform
			_pointUpperExtra.position = bon.children[1].position
			_pointUpperExtra.parent = bon
			_pointUpperExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeUpperArm" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _pointUpperExtra #all
			
			--creación de los huesos extras para montar la IkLimb en la parte de upper
			_twistBonesExtra = #()
			_newBoneExtra = #()
			_twistBonesExtraEnd = #()
			_newBoneExtra = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1] -- creación de 'newBone' en coordenadas absolurtas 0,0,0 en dirección Z positiva y con na longitud igual a 'newLength'.
						
			--Filtramos el nombre y nombramos los huesos creados según la selección hecha.
			_newBoneExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-bon-Extra" + "_" + _filterPart[6] + "_" +lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag			
			-- Parámetros de los huesos Twist.
			if _twistNumber == 1 then
			(
				_newBoneExtra.length = _LengthTwist/3
			)
			else
			(
				_newBoneExtra.length = _LengthTwist
			)
			_newBoneExtra.wirecolor = color 255 255 0 -- Yellow
			_newBoneExtra.Taper = 90
			_newBoneExtra.width = bon.width * 2
			_newBoneExtra.height = bon.height * 2
			_newBoneExtra.sidefins = true
			_newBoneExtra.sidefinssize = bon.width * 2
			
			if  bon.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
			(
				_newBoneExtra.transform =  bon.transform
				_newBoneExtra.objectOffsetScale =  bon.objectOffsetScale -- iguala objectOffsetScale con hueso X
			)
			else
			(
				_newBoneExtra.transform =  bon.transform --colocamos los huesos en la posicion del hueso seleccionado.
			)
			
			append _twistBonesExtra _newBoneExtra -- añade los huesos de twist en un array
			
			for _o in _twistBonesExtra do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
			
			_twistBonesExtraEnd = #()
			-- creación de hueso End.
			_newBoneExtraEnd = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1]
			_newBoneExtraEnd.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-bon-ExtraEnd" + "_" + _filterPart[6] + "_" +lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag			
			
			-- Parámetros del huesoEnd Twist.
			_newBoneExtraEnd.length = _newBoneExtra.height
			_newBoneExtraEnd.wirecolor = color 255 255 0 -- Yellow
			_newBoneExtraEnd.Taper = 90
			_newBoneExtraEnd.width = bon.width * 2
			_newBoneExtraEnd.height = bon.height * 2
			_newBoneExtraEnd.sidefins = true
			_newBoneExtraEnd.sidefinssize = bon.width * 2
			
			if  bon.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
			(
				_newBoneExtraEnd.transform =  bon.transform
				_newBoneExtraEnd.objectOffsetScale =  bon.objectOffsetScale -- iguala objectOffsetScale con hueso X
			)
			else
			(
				_newBoneExtraEnd.transform =  bon.transform --colocamos los huesos en la posicion del hueso seleccionado.
			)
			
			in coordSys Local move _newBoneExtraEnd [(bon.objectoffsetscale.x)*(_newBoneExtra.length),0,0] -- mueve el hueso twist al final del hueso twist anterior.
			
			append _twistBonesExtraEnd _newBoneExtraEnd -- añade los huesos de twist en un array
			
			_twistBonesExtraEnd[1].parent = _twistBonesExtra[1]
			for _o in _twistBonesExtraEnd do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
			
			--creación del expose para la parte de upper
			_exposeHLpUpper = ExposeTm()
			_exposeHLpUpper.centermarker = true
			_exposeHLpUpper.axistripod = true
			_exposeHLpUpper.cross = false
			_exposeHLpUpper.size = bon.width * 5
			_exposeHLpUpper.wirecolor = color 255 255 0 -- Yellow
			_exposeHLpUpper.transform = bon.transform
			_exposeHLpUpper.parent = _twistBonesExtra[1]
			_exposeHLpUpper.exposeNode = bon
			_exposeHLpUpper.useParent = false
			_exposeHLpUpper.localReferenceNode = _twistBonesExtra[1]
			_exposeHLpUpper.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-expose" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _exposeHLpUpper #all
		)	

		------------------------------------------------------------------------------
		--@fn: undefined | rotationTwist | Función para generar la configuración necesaria para la rotacion del twist.
		--@gets: node | bon |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		fn rotationTwist bon =
		(
			_FloatExprTwist = #()
			_FloatExprStrech = #()
			
			_scaleRoot = lb.rig.solutions.getRootNode type:#skin
			
			if ckbLowerTwist.checked == true then  --Si Lower Twist esta act. entra en el bucle.
			(	
				for _k in bon do
				(
					createBonTwist _k
					exposeLower _k --Creación del point y del expose, para las piezas lower.
					
					for i=1 to  _pointControl.count do --Recorre los objetos del array de los huesos de twist.
					(
						if i == 1 then
						(
							lb.controller.setActiveController  _pointControl[i] #all #frozen
							_pointControl[i].parent = _pointLowerExtra
							lb.controller.setActiveController  _pointControl[i] #all #zero
						)
					)
					
					if _k.objectOffsetScale.x == -1 then
					(
						for i=1 to _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
						(
							if i != 1 then
							(
								--Rotación de twist añadimos el float Expresion en la pista X Rot y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" _exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/" + ((_twistNumber)as string))
								
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" _k.length
								_FloatExprStrech.AddNode "scale" _scaleRoot
								_FloatExprStrech.AddNode "point01" _exposeHLpLower
								_FloatExprStrech.AddNode "point02" _pointLowerExtra
								_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
							)
						)
					)
					else
					(
						for i=1 to _twistBones.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
						(
							if i != 1 then
							(
								--Rotación de twist añadimos el float Expresion en el swivel angle y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" _exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/" + ((_twistNumber)as string))
								
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" _k.length
								_FloatExprStrech.AddNode "scale" _scaleRoot
								_FloatExprStrech.AddNode "point01" _exposeHLpLower
								_FloatExprStrech.AddNode "point02" _pointLowerExtra
								_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
							)
						)
					)
				)
			)
			if ckbUpperTwist.checked == true then  --Si upper Twist esta act. entra en el bucle.
			(
				for _k in bon do
				(
					createBonTwist _k
					exposeUpper _k --Creación del point y del expose, para las piezas Upper.
					
					_twistBonesExtra[1].parent = _k.parent  --linka el hueso extra de la Ik al hombro.
					lb.controller.freezeTransform _twistBonesExtra[1] #all
					
					_CreateIkLimb = iksys.ikchain _twistBonesExtra[1] _twistBonesExtraEnd[1] "IKLimb"  --creación de la IkLimb del hueso extra al huesoExtraEnd
					_CreateIkLimb.transform = _k.transform				--coloca la IK Limb en el ultimo hueso de los twist en la zona del codo.
					_CreateIkLimb.position = _k.children[1].position
					_filterPart = filterString _k.name "_"
					_CreateIkLimb.name =  _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-IkLimb-Extra" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
					
					_CreateIkLimb.parent = _pointUpperExtra
					lb.controller.freezeTransform _CreateIkLimb #all
					
					for i=1 to  _pointControl.count do --Recorre los objetos del array de los huesos de twist.
					(
						if i == 1 then
						(
							lb.controller.setActiveController  _pointControl[i] #all #frozen
							_pointControl[i].parent = _exposeHLpUpper
							lb.controller.setActiveController  _pointControl[i] #all #zero
						)
					)
					
					if _k.objectOffsetScale.x == -1 then
					(
						for i=1 to _pointControl.count do --Recorre los point de strech y les mete un float expresion en la rotación eje X, y en posicion eje X.
						(
							for _o in _pointControl do
							(
								--Rotación de twist añadimos el float Expresion en el swivel angle y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "UpperTwist" _exposeHLpUpper.LocalEulerX.controller
								_FloatExprTwist.setExpression ("UpperTwist/" + ((_twistNumber)as string))
							)
							
							if i != 1 then
							(
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" _k.length
								_FloatExprStrech.AddNode "scale" _scaleRoot
								_FloatExprStrech.AddNode "point01" _exposeHLpUpper
								_FloatExprStrech.AddNode "point02" _pointUpperExtra
								_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
							)
						)
					)
					else
					(
						for i=1 to _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
						(
							for _o in _pointControl do
							(
								--Añadimos el float Expresion en el swivel angle y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "UpperTwist" _exposeHLpUpper.LocalEulerX.controller
								_FloatExprTwist.setExpression ("UpperTwist/" + ((_twistNumber)as string))
							)
							
							if i != 1 then
							(
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" _k.length
								_FloatExprStrech.AddNode "scale" _scaleRoot
								_FloatExprStrech.AddNode "point01" _exposeHLpUpper
								_FloatExprStrech.AddNode "point02" _pointUpperExtra
								_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
							)
						)
					)
					_pointUpperExtra.pos.controller.Available.controller = Position_Constraint ()
					_pointUpperExtra.pos.controller.Position_Constraint.controller.appendTarget _k.children[1] 100
					_pointUpperExtra.pos.controller.Position_Constraint.controller.RELATIVE = on
				)
			)
		)

		------------------------------------------------------------------------------
		--@fn: undefined | deleteTwistSystem | Función para borrar las soluciones twist.
		--@gets: node | _boneSelection |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		fn deleteTwistSystem _boneSelection =
		(
			for _k in _boneSelection do
			(
				_nameTwist = #()
				
				if _k != undefined and isValidNode _k then
				(
					_nameTwist = filterString _k.name "_"
					_filterNameTwist = filterstring _nameTwist[5] "-"
					
					if _filterNameTwist[2] != undefined then
					(
						_filtername = _nameTwist[1] + "_" + _nameTwist[2] + "_" + lb.nc.NC_classSkin + "_" + _nameTwist[4] + "_" + _filterNameTwist[1] + "-" +_filterNameTwist[2] + "-" + "*" + "-" + "*" + "_" + "*" + "_" + "*"
						
						for _o in lb.asset.getSceneAssets() do
						(
							_objetSkin = _o.skinNodesAll
							
							for _m in _objetSkin do
							(
								if matchpattern _m.name pattern:_filtername then
								(
									if classof _m.position.controller[#Zero_Pos_XYZ][#x_Position].controller == float_script then
										delete _m
								)
							)
						)							
						for _o in lb.asset.getSceneAssets() do
						(
							_objetSkin = _o.skinNodesAll
					
							for _m in _objetSkin do
							(
								if matchpattern _m.name pattern:_filtername then
								(
									delete _m
								)
							)
						)
					)
				)
			)
		)

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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMtwistManagerDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMtwistManagerDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: changed | Evento que verifica si el upper esta activado o no y desactiva el lower.
		------------------------------------------------		
		on ckbUpperTwist changed UpperRefChkState do
		(
			if ckbUpperTwist.checked == true then
			(
				ckbLowerTwist.enabled = false
				ckbLowerTwist.checked = false
			)
			else
			(
				ckbLowerTwist.enabled = true
			)
		)

		------------------------------------------------
		--@event: changed | Evento que verifica si el lower esta activado o no y desactiva el upper.
		------------------------------------------------		
		on ckbLowerTwist changed LowerRefChkState do
		(
			if ckbLowerTwist.checked == true then
			(
				ckbUpperTwist.enabled = false
				ckbUpperTwist.checked = false
			)
			else
			(
				ckbUpperTwist.enabled = true
			)
		)

		------------------------------------------------
		--@event: pressed | añade los huesos de twist.
		------------------------------------------------		
		on btnCreateTwistSystem pressed do
		(
			_boneSelection = #()
			_boneSelection = getCurrentSelection()
			
			setCommandPanelTaskMode #create		--activa la parte del command panel create.
			-- si no hay huesos seleccionados salta un mensaje
			if _boneSelection.count == 0 then
			(
				MessageBox "You must have some bones selected"
			)
			else
			(
				_pointControl = #()
					
			-- 				createBonTwist _boneSelection		--creacion de los huesos de twist.
				rotationTwist _boneSelection		--configuración de twist.
			)
		)

		------------------------------------------------
		--@event: pressed | Elimina los twist creados y sus objetos auxiliares.
		------------------------------------------------			
		on btnDeleteTwist pressed do
		(
			_boneSelection = #()
			_boneSelection = getCurrentSelection()
			
			setCommandPanelTaskMode #create		--activa la parte del command panel create.	
			-- si no hay huesos seleccionados salta un mensaje
			if _boneSelection.count == 0 then
			(
				MessageBox "You must have some bonesTwist selected"
			)
			else
			(
				deleteTwistSystem _boneSelection
			)
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollExample1Def resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollExample1Def open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollExample1Def close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMtwistManagerDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMautoRigDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMautoRigDef "Rig Generator"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnRigSolutionManager "Open Rig Solution Manager" pos:[5,5] width:195 height:25
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMautoRigDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMautoRigDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | Abre la herramienta rig solution manager.
		------------------------------------------------		
		on btnRigSolutionManager pressed do
		(

			_tool = (lb.getTool "rigSolutionManager")
			if not _tool.isOpen() then _tool.run()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMautoRigDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMautoRigDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMautoRigDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMautoRigDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMpuppetManagerDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMpuppetManagerDef "Puppet Tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnMeatSlicer "Puppet Manager" pos:[5,5] width:195 height:20
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMpuppetManagerDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMpuppetManagerDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | abre la herramienta meatSlicer
		------------------------------------------------
		on btnMeatSlicer pressed do
		(
			lb.puppetManager.run()	
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMpuppetManagerDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMpuppetManagerDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMpuppetManagerDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMpuppetManagerDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMmergeFacialRigDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMmergeFacialRigDef "Load Facial Rig"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnRigSolutionManager "Open Rig Solution Manager" pos:[5,5] width:195 height:25
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMmergeFacialRigDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMmergeFacialRigDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		on btnRigSolutionManager pressed do
		(

			_tool = (lb.getTool "rigSolutionManager")
			if not _tool.isOpen() then _tool.run()
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMmergeFacialRigDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMmergeFacialRigDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMmergeFacialRigDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMmergeFacialRigDef

		------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMmergeFacialRigDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMLoadMorphersDef "Load Morphers"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnRigSolutionManager "Open Rig Solution Manager" pos:[5,5] width:195 height:25
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMmergeFacialRigDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMmergeFacialRigDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		on btnRigSolutionManager pressed do
		(

			_tool = (lb.getTool "rigSolutionManager")
			if not _tool.isOpen() then _tool.run()
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMmergeFacialRigDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMLoadMorphersDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMLoadMorphersDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMmergeFacialRigDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMheadSystemModifierDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMheadSystemModifierDef "Head System Modifier"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnAddModifier "Add Modifier" pos:[5,5] width:195 height:20 toolTip:"Add Modifier"	
		
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
		--@fn: undefined | addHeadSystemModifier | funcion para añadir el modificado headSystem ( editPoly)
		------------------------------------------------
		fn addHeadSystemModifier obj =
		(
			-- Creamos el nuevo modificador
			_editPolyMod = edit_poly()
			_editPolyMod.name = "headSystem"
			_tempModifiers = #()
			
			-- intentamos añadir el modificador a la malla
			-- si falla y da error "unexpected" al intentarlo quitamos los modificadores, añadimos el headSystem y lo volvemos a poner
			for j = obj.modifiers.count to 1 by -1 where (classof obj.modifiers[j]) == FFD_Binding  do
			(
				append _tempModifiers obj.modifiers[j] 
				deleteModifier obj obj.modifiers[j]
			)
			
			_indexSkin = lb.modifiers.getNodeModifierIndex obj Skin
			
			addModifier obj _editPolyMod before:(_indexSkin-1)
			
			-- Añadimos el FFD eliminado anteriormente, equivale a un cortar y pegar.
			for m in _tempModifiers do addModifier obj m
				
			_tempModifiers = #()
			
			-- activamos el command panel ya que cuando falla se desactiva.
			resumeEditing()
			
			--entramos en modo subObject y dejamos seleccionados todos los poligonos.
			modPanel.setCurrentObject obj.modifiers[#headSystem]
			subobjectLevel = 4
			max select all	
			enableShowEndRes = false
		)	

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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMheadSystemModifierDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMheadSystemModifierDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: btnAddModifier | añadenel modificador de Head System
		------------------------------------------------
		on btnAddModifier pressed do
		(
			max modify mode
			
			for obj in selection do
				addHeadSystemModifier obj
			lb.message.show "Unselect Visible Polygons.\n\nHide Selecteds with \"Hide Selected button\"." title:"Add HeadSystem Modifer" type:#message pos:undefined size:[300,75] modal:true	
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMheadSystemModifierDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMheadSystemModifierDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMheadSystemModifierDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMheadSystemModifierDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMskinModifierDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMskinModifierDef "Skin Modifier Tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local skinTarget	

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnAddSkinModifier "Add/Replace Skin to Selection" pos:[5,5] width:195 height:20 toolTip:"Add or Replace Skin Mod to Selected Objects "

		button btnResetSkin "Always Deform" pos:[5,30] width:95 height:20
		button btnReloadSkin "Reload Skin" pos:[105,30] width:95 height:20
		
		GroupBox grpAddBonesToSkin "Add Bones To Skin Mod" pos:[5,55] width:200 height:65
		pickbutton pckPickSkinObject "Pick Target" pos:[10,70] width:110 height:20 toolTip:"Pick Object to add Skin Mod or to add Bones"
		button btnClear "Clear" pos:[125,70] width:75 height:20 toolTip:"Clear and Reset Buttons"
		button btnAddBonesToSkin "Add bones selected" pos:[10,95] width:190 height:20 enabled:false toolTip:"Add selected Bones to picked Object"

		GroupBox grpLoad "Load options" pos:[5,155] width:200 height:130
		button btnLoadSkin "Load" pos:[5,130] width:95 height:20
		button btnSaveSkin "Save" pos:[105,130] width:95 height:20

		checkbox chkLoadSkinVertex "Load vertex" pos:[10,170] width:80 height:15 checked:true		
		radiobuttons rdoLoadType "" pos:[20,190] width:124 height:32 labels:#("by space coordinates", "by vertex number") default:2
		spinner spnTolerance "" pos:[145,190] width:55 height:16 range:[0,10000,2] enabled:false scale:0.01
		checkbox chkLoadSelVertsOnly "Load sel. verts. only" pos:[20,223] width:115 height:15 checked:false
		checkbox chkLoadSkinEnvelopes "Load envelopes" pos:[10,245] width:105 height:15 checked:true
		checkbox chkReplaceBones "Replace bones" pos:[10,265] width:85 height:15 checked:true
			
		progressBar pbCalculating "" pos:[5,290] width:200 height:8 value:0
		label lblLoading "" pos:[5,305] width:200 height:13 style_sunkenedge:true
		
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
		--@fn: undefined | updateUi | funcion para actualizar botones de rollout y filtrar el nombre del objeto picado
		------------------------------------------------		
		fn updateUi =
		(
			-- comprobamos si tenemos un nodo valido en la variable
			if isValidNode skinTarget then
			(
				-- si cumple el nc lo filtramos para ponerlo como caption
				if lb.nc.ncOK skinTarget.name then
				(
					-- filtramos el nombre para cojer solo las 6 primeras partes.
					nameParts = filterString skinTarget.name "_"
					skinTargetName = nameParts[1] + "_" + nameParts[2] + "_" + nameParts[3] + "_" + nameParts[4] + "_" + nameParts[5]
					
					pckPickSkinObject.caption = skinTargetName
				)
				else -- sino lo cumple ponemos el nombre del obj directamente.
					pckPickSkinObject.caption = skinTarget.name
				
			)--if
		)	

		------------------------------------------------
		--@fn: undefined | resetInfoUI | Reinicia los controles del panel de información
		------------------------------------------------	
		fn resetInfoUI =
		(
			lblLoading.caption = ""
			pbCalculating.value = 0
		)
		
		------------------------------------------------
		--@fn: undefined | loadSkinProcess | Realiza todo el proceso de carga de los datos de skin según las opciones indicadas. Devuelve TRUE o FALSE indicando si se hizo la carga
		------------------------------------------------
		fn loadSkinProcess filename sknMod = 
		(
			_loadVertexType =  if rdoLoadType.state == 1 then #bySpaceCoords else #byVertexNumber
			
			lb.skin.loadSkin filename sknMod loadVertexData:chkLoadSkinVertex.checked loadEnvelopeData:chkLoadSkinEnvelopes.checked replaceBones:chkReplaceBones.checked loadVertexType:_loadVertexType bySpaceCoordsTolerance:spnTolerance.value loadSelectedVertsOnly:chkLoadSelVertsOnly.checked
		)		

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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMskinModifierDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMskinModifierDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | añade el modificador skin si no lo lleva, y lo remplaza si lo lleva
		------------------------------------------------
		on btnAddSkinModifier pressed do  
		(
			lb.skin.addSkinModifier (getCurrentSelection())
		)

		------------------------------------------------
		--@event: pressed | añade el modificador skin si no lo lleva, y lo remplaza si lo lleva
		------------------------------------------------		
		on btnResetSkin pressed do  
		(
			resetSkinAlwaysDeform()
			lb.message.show "Skin modifier has been reset" type:#message pos:undefined size:[300,75] modal:true
		)
		
		------------------------------------------------
		on chkLoadSkinVertex changed value do
		(
			if not chkLoadSkinVertex.checked and not chkLoadSkinEnvelopes.checked then
				chkLoadSkinVertex.checked = true
			chkLoadSelVertsOnly.enabled = rdoLoadType.enabled = chkLoadSkinVertex.checked
			spnTolerance.enabled = (rdoLoadType.enabled and rdoLoadType.state == 1)
		)
		
		------------------------------------------------
		on chkLoadSkinEnvelopes changed value do
		(
			if not chkLoadSkinVertex.checked and not chkLoadSkinEnvelopes.checked then
				chkLoadSkinEnvelopes.checked = true
		)

		on rdoLoadType changed state do
		(
			spnTolerance.enabled = state == 1
		)
		
		------------------------------------------------
		on btnLoadSkin pressed do
		(
			_selObjs = for o in selection collect o
			_noSkinErrorMsg = "Select one or more nodes with Skin modifier first."
			
			_assets = (lb.asset.getAssetsFromNodes _selObjs)
			_assetPath = if _assets.count > 0 then _assets[1].folder else ""
			_skinPath = if _assetPath != "" then _assetPath = (_assetPath + @"rig\skin\v" + (formattedprint _assets[1].version format:"02d") + "\\") else ""
			
			_assetsSkinConnectionStates = for _asset in _assets collect lb.asset.isSkinConnected _asset
			
			if _selObjs.count == 1 then
			(
				_skinMod = lb.modifiers.getNodeModifier _selObjs[1] skin  
				
				if (_skinMod != undefined) then
				(
					if lb.nodeInfo.hasNodeInfo _selObjs[1] then
						_filename = _selObjs[1].nodeInfo.nameHistory[_selObjs[1].nodeInfo.nameHistory.count]
					else
						_fileName = _selObjs[1].name 
					
					_skinFile = getOpenFileName "Cargar datos de SKIN" types:"Skin weights (*.skn)|*.skn|All formats (*.*)|*.*|" filename:(_skinPath + _filename + ".skn")
					_node = _selObjs[1]
					
					if (_skinFile != undefined) then
					(
						_oldModifierStates = lb.skin.disableModsForSkinOperations _node
						_numVerts = _node.mesh.verts.count 
						_incomingNumVerts = (lb.skin.readSkinInfo _skinFile).numVerts

						_continue = true
						lb.skin.setModsState _oldModifierStates
						
						if _incomingNumVerts != _numVerts then
							_continue = queryBox "The incoming number of vertices does not match the node number of verts. Do you want to continue?"
						
						if _continue then
						(
							_skinLoaded = (loadSkinProcess _skinFile _skinMod) 
							
							--	lanzamos el mensaje que corresponda
							if _skinLoaded then
								lb.message.show "Skin file loaded" type:#message pos:undefined size:[300,75] modal:true
							else
								lb.message.show "Could not load skin file." type:#message pos:undefined size:[300,75] modal:true
						)
					)
				)
				else
					lb.message.show _noSkinErrorMsg type:#message pos:undefined size:[300,75] modal:true
			)
			else if _selObjs.count > 1 then
			(
				
				_folder = getSavePath caption:"Load multiple skin files" initialDir:_skinPath
				
				if _folder != undefined then
				(
					_loadedFiles = 0
					
					_oldSelection = getCurrentSelection()
					_continue = true
					_nodesWithDifferentVertexCount = #()
					_numVertsOK = true 
					
					--	Comprobamos que los números de vértice coinciden con los de las geometrías guardadas
					for o in selection do
					(
						_oldModifierStates = lb.skin.disableModsForSkinOperations o
						
						if lb.nodeInfo.hasNodeInfo _selObjs[1] then
							_objName = o.nodeInfo.nameHistory[o.nodeInfo.nameHistory.count] 
						else
							_objName = o.name
						
						_skinFile = _folder + "\\" + _objName + ".skn"
						_skinFileData = lb.skin.readSkinInfo _skinFile
						
						if _skinFileData != undefined and (o.mesh.verts.count != _skinFileData.numVerts) then
						(
							append _nodesWithDifferentVertexCount o
							_numVertsOK = false
						)
						
						lb.skin.setModsState _oldModifierStates
					)
					
					if not _numVertsOK then
					(
						_errorMessageNodes = ""
						for o in _nodesWithDifferentVertexCount do append _errorMessageNodes (o.name + "\n")
						
						_continue = queryBox ("Some nodes have different number of vertex than the incoming files. Do you want to continue?\n" + _errorMessageNodes)
					)
					
					--	Si todo está bien cargamos los skin.
					if _continue then
					(
						for o in _selObjs do
						(
							_skinMod = lb.modifiers.getNodeModifier o skin
							
							if lb.nodeInfo.hasNodeInfo _selObjs[1] then
								_objName = o.nodeInfo.nameHistory[o.nodeInfo.nameHistory.count] 
							else
								_objName = o.name
							
							_filename = _folder + "\\" + _objName + ".skn"
							
							if (doesFileExist _filename) and (_skinMod != undefined) then
							(
								loadSkinProcess _filename _skinMod
								_loadedFiles += 1
							)
							else 
								print ("No se encontró el fichero para la pieza " + o.name)
						)
						
						--	lanzamos el mensaje 
						lb.message.show (_loadedFiles as string + " skin files loaded.") type:#message pos:undefined size:[300,75] modal:true
					)
				)
			)
			else
			(	
				lb.message.show _noSkinErrorMsg type:#message pos:undefined size:[300,75] modal:true
			)
		)
		
		------------------------------------------------
		on btnSaveSkin pressed do
		(
			_selObjs = for o in selection collect o
			_noSkinErrorMsg = "Select one or more nodes with Skin modifier first."
			
			_assets = (lb.asset.getAssetsFromNodes _selObjs)
			_assetPath = if _assets.count > 0 then _assets[1].folder else ""
			_skinPath = if _assetPath != "" then _assetPath = (_assetPath + @"rig\skin\v" + (formattedprint _assets[1].version format:"02d") + "\\") else ""

			_selObjs = getCurrentSelection()
			
			if _selObjs.count == 1 then
			(
				_sknMod = lb.modifiers.getNodeModifier _selObjs[1] skin  
				
				if (_sknMod != undefined) then
				(
					if lb.nodeInfo.hasNodeInfo _selObjs[1] then
						_filename = _selObjs[1].nodeInfo.nameHistory[_selObjs[1].nodeInfo.nameHistory.count]
					else
						_fileName = _selObjs[1].name
					
					_skinFile = getSaveFileName "Save skin file" types:"Pesos skin (*.skn)|*.skn|Todos los formatos (*.*)|*.*|" filename:(_skinPath + _filename + ".skn")
						if _skinFile != undefined then
							if (lb.skin.saveSkin _skinFile _sknMod) then
								lb.message.show "Skin data saved." type:#message pos:undefined size:[300,75] modal:true
							else
								lb.message.show "Puppets attached successfully" type:#message pos:undefined size:[300,75] modal:true
				)
				else
					lb.message.show "Tiene que seleccionar una pieza con skin." type:#message pos:undefined size:[300,75] modal:true
			)
			else if _selObjs.count > 1 then
			(
				_folder = getSavePath caption:"Load multiple skin files" initialDir:_skinPath
				
				if _folder != undefined then 
				(
					_savedFiles = 0		-- número de ficheros skin que se han guardado
					
					for o in _selObjs do
					(
						if lb.nodeInfo.hasNodeInfo _selObjs[1] then
							_objName = o.nodeInfo.nameHistory[o.nodeInfo.nameHistory.count] 
						else
							_objName = o.name
							
						_sknMod = lb.modifiers.getNodeModifier o skin
						
						if _sknMod != undefined then 
						(
							_skinFile = _folder + "\\" + _objName + ".skn"
							lb.skin.saveSkin _skinFile _sknMod
							_savedFiles += 1
						)
						
					)
					
					if _savedFiles > 0 then
						lb.message.show (_savedFiles as string  + " skin data files saved.") type:#message pos:undefined size:[300,75] modal:true
					else
						lb.message.show "Skin data no saved" type:#message pos:undefined size:[300,75] modal:true
				)
				gc()
			)
			else
				lb.message.show "Select object to save data" type:#message pos:undefined size:[300,75] modal:true
		)

		on btnReloadSkin pressed do
		(
			_selObjs = getCurrentSelection()
			for o in _selObjs where isProperty o #skin do
				lb.skin.reloadSkin o.skin
		)

		------------------------------------------------
		--@event: picked | captura el objeto seleccionado y actualiza los botones dependiendo de la seleccion
		------------------------------------------------		
		on pckPickSkinObject picked obj do
		(
			if obj != undefined  then
			(		
				skinTarget = obj
				updateUi()
				select skinTarget
				pckPickSkinObject.caption = obj.name
				
				-- Comprueba si lleva skin, si no es asi se lo añade.
				hasSkin = false

				for m in obj.modifiers where classof m == Skin do -- busca el mod skin en la pila de modificadores
					hasSkin = true
				
				-- Si no tiene skin 
				if not hasSkin then
				(
					lb.skin.addSkinModifier (getCurrentSelection())
					lb.message.show "Skin modifier added to picked object" type:#message pos:undefined size:[300,75] modal:true
				)
				
				btnAddBonesToSkin.enabled = true
			)--if
		)

		------------------------------------------------
		--@event: pressed | añade los huesos seleccionados al skin del objeto capturado
		------------------------------------------------	
		on btnAddBonesToSkin pressed do  
		(
			bonesArray = getCurrentSelection()
			
			if bonesArray.count != 0 then
			(
				-- guardo el estado del obj que lleva el skin
				frozenBckp = skinTarget.isFrozen
				
				-- lo descongelamos para poder operar
				skinTarget.isFrozen = false
				
				skinMod = undefined
				
				for m in skinTarget.modifiers do
					if classof m == Skin then
						skinMod = m
					
				select skinTarget
				
				lb.skin.addSkinBonesSelected skinMod bonesArray
				
				-- restauramos el valor del estado del isFrozen del  obj	
				skinTarget.isFrozen = frozenBckp	
			)-- if
		)

		------------------------------------------------
		--@event: pressed | limpiamos la variable del objeto picado y resetamos los botones por defecto
		------------------------------------------------		
		on btnClear pressed do  
		(
			pckPickSkinObject.caption = "Pick Target"
			btnAddBonesToSkin.enabled = false
			skinTarget = undefined
		)		

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMskinModifierDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMskinModifierDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMskinModifierDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMskinModifierDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMskinMorphModifierDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMskinMorphModifierDef "Skin Morph Modifier Tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnAddSkinMorphModifier "Add/Replace SkinMorph Mod." pos:[5,5] width:195 height:20 toolTip:"Add/Replace SkinMorph Modifier"
		button btnReloadSkinMorph "Reload SkinMorph" pos:[5,30] width:195 height:20		

		button btnLoadSkinMorph "Load" pos:[5,60] width:95 height:20
		button btnSaveSkinMorph "Save" pos:[105,60] width:95 height:20

		GroupBox grpLoad "Load options" pos:[5,85] width:200 height:65
		radiobuttons rdoSkinMorphLoadType "" pos:[10,100] width:125 height:32 labels:#("By space coordinates", "By vertex number") default:2
		spinner spnTolerance "" pos:[145,100] width:55 height:16 range:[0,10000,1] enabled:false scale:0.01

		checkbox chkLoadReplaceBones "Replace bones" pos:[10,132] width:95 height:15 enabled:false checked:true
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMskinMorphModifierDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMskinMorphModifierDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | añadimos el modificador skinMorph a la seleccion
		------------------------------------------------
		on btnAddSkinMorphModifier pressed do
		(
			_smMod = lb.skin.addSkinMorphModifier (getCurrentSelection())
			if _smMod == undefined  then
				lb.message.show "selected Objects don't have Skin modifier. Please apply it first." type:#message pos:undefined size:[300,75] modal:true
		)

		------------------------------------------------
		--@event: pressed | añadimos el modificador skinMorph a la seleccion
		------------------------------------------------		
		on btnReloadSkinMorph pressed do
		(
			_selObjs = getCurrentSelection()
			for o in _selObjs where isProperty o #skinMorph do
				lb.skin.reloadSkinMorph o.skinMorph
		)
		
		---------------------------------------------------------------
		on btnLoadSkinMorph pressed do
		(
			_assets = (lb.asset.getAssetsFromNodes (getCurrentSelection()))
			_assetPath = if _assets.count > 0 then _assets[1].folder else ""
			_skinMorphPath = if _assetPath != "" then _assetPath = (_assetPath + @"rig\skin\v" + (formattedprint _assets[1].version format:"02d") + "\\") else ""
			_noSkinMorphErrorMsg = "Select one or more nodes with SkinMorph modifier first."
			
			if selection.count == 1 then
			(
				_selObj = selection[1]
				_smMod = lb.modifiers.getNodeModifier _selObj skin_morph
				
				if _smMod != undefined then 
				(
					_filename = _selObj.nodeInfo.nameHistory[_selObj.nodeInfo.nameHistory.count] 
					_skinMorphFile = getOpenFileName caption:"Load File" filename:(_skinMorphPath + _filename + ".smd") types:"Skin Morph Data (*.smd)|*.smd"
					setWaitCursor()
					
					-- Si se ha leído correctamente el fichero seguimos
					if (_skinMorphFile != undefined) then 
					(
						_loadType = undefined
						_oldModifierStates = lb.skin.disableModsForSkinOperations _selObj
						_numVerts = _selObj.mesh.verts.count
						_incomingNumVerts = (lb.skin.readSkinInfo _skinMorphFile).numVerts 
						_continue = true
						
						lb.skin.setModsState _oldModifierStates
						
						if _incomingNumVerts != _numVerts then
							_continue = queryBox "The incoming number of vertices does not match the node number of verts. Do you want to continue?"
						
						if _continue then
						(
							case rdoSkinMorphLoadType.state of 
							(
								1: _loadType = #bySpaceCoords
								2: _loadType = #byVertexNumber
							)
							
							lb.skin.loadSkinMorph _smMod _skinMorphFile loadType:_loadType bySpaceCoordsTolerance:(spnTolerance.value) replaceBones:chkLoadReplaceBones.checked
							lb.message.show  "Skin Morph data loaded" type:#message pos:undefined size:[300,75] modal:true
						)
					)
				)
				else
					lb.message.show _noSkinMorphErrorMsg type:#message pos:undefined size:[300,75] modal:true
			)
			else if selection.count > 1 then
			(
				_filesLoaded = 0 
				
				_folder = getSavePath caption:"Load multiple skinMorph files" initialDir:_skinMorphPath
				
				setWaitCursor()
				
				if (_folder != undefined) then 
				(
					_oldSelection = getCurrentSelection()
					_continue = true
					_nodesWithDifferentVertexCount = #()
					_numVertsOK = true 
					
					--	Comprobamos que los números de vértice coinciden con los de las geometrías
					for o in selection do
					(
						_oldModifierStates = lb.skin.disableModsForSkinOperations o
						_objName = o.nodeInfo.nameHistory[o.nodeInfo.nameHistory.count] 
						_skinMorphFile = _folder + "\\" + _objName + ".smd"
						_skinMorphFileData = lb.skin.readSkinInfo _skinMorphFile
						
						if _skinMorphFileData != undefined and (o.mesh.verts.count != _skinMorphFileData.numVerts) then
						(
							append _nodesWithDifferentVertexCount o
							_numVertsOK = false
						)
						
						lb.skin.setModsState _oldModifierStates
					)
					
					if not _numVertsOK then
					(
						_errorMessageNodes = ""
						for o in _nodesWithDifferentVertexCount do append _errorMessageNodes (o.name + "\n")
						
						_continue = queryBox ("Some nodes have different number of vertex than the incoming files. Do you want to continue?\n" + _errorMessageNodes)
					)
					
					--	Si todo está bien cargamos los skin morph.
					if _continue then
					(
						for o in _oldSelection do
						(
							_objName = o.nodeInfo.nameHistory[o.nodeInfo.nameHistory.count] 
							
							_smMod = lb.modifiers.getNodeModifier o skin_morph 
							_skinMorphFile = _folder + "\\" + _objName + ".smd"
							
							if (_smMod != undefined) and (doesFileExist _skinMorphFile) then 
							(
								_loadType = undefined
								case rdoSkinMorphLoadType.state of 
								(
									1: _loadType = #bySpaceCoords
									2: _loadType = #byVertexNumber
								)
								
								_kk = lb.skin.loadSkinMorph _smMod _skinMorphFile loadType:_loadType replaceBones:chkLoadReplaceBones.checked
								_filesLoaded += 1
							)
						)
						
						completeRedraw()
						
						if _filesLoaded > 0 then
							lb.message.show (_filesLoaded as string + " skinMorph files loaded.") type:#message pos:undefined size:[300,75] modal:true
						else
							lb.message.show "No found skinMorph files" type:#message pos:undefined size:[300,75] modal:true
					)
				)
			)	
			else
				lb.message.show "Select object to load skinMorph data" type:#message pos:undefined size:[300,75] modal:true
			
			setArrowCursor()
		)
		
		---------------------------------------------------------------
		on btnSaveSkinMorph pressed do
		(
			_selObjs = for o in selection collect o
			_noSkinErrorMsg = "Select one or more nodes with Skin modifier first."
			
			_assets = (lb.asset.getAssetsFromNodes _selObjs)
			_assetPath = if _assets.count > 0 then _assets[1].folder else ""
			_skinPath = if _assetPath != "" then _assetPath = (_assetPath + @"rig\skin\v" + (formattedprint _assets[1].version format:"02d") + "\\") else ""
			
			-- si hay un solo objeto seleccionado pedimos ruta y nombre de fichero. Si no solo ruta
			if selection.count == 1 then
			(
				_selObj = selection[1]
				_smMod = lb.modifiers.getNodeModifier _selObj skin_morph 
				if _smMod != undefined then 
				(
					_objName = _selObj.nodeInfo.nameHistory[_selObj.nodeInfo.nameHistory.count] 
					
					_skinMorphFile = getSaveFileName caption:"Save skinMorph file" filename:(_skinPath + _objName + ".smd") types:"Skin Morph Data (*.smd)|*.smd"
					setWaitcursor()
					if _skinMorphFile != undefined then 
					(
						lb.skin.saveSkinMorph _smMod _skinMorphFile
						lb.message.show "SkinMorph file saved" type:#message pos:undefined size:[300,75] modal:true
					)
				)
				else
					lb.message.show "Select object to load skinMorph data" type:#message pos:undefined size:[300,75] modal:true
			)
			-- guardado múltiple
			else if selection.count > 1 then	
			(
				_folder = getSavePath caption:"Load multiple skinMorph files" initialDir:_skinPath
				
				setWaitcursor()
				if _folder != undefined then 
				(
					_filesSaved = 0		-- número de ficheros skin que se han guardado
					_numVertsOK = true
					_nodesWithDifferentVertexCount = #()
					for o in selection do
					(
						
						_objName = o.nodeInfo.nameHistory[o.nodeInfo.nameHistory.count] 
						
						_smMod = lb.modifiers.getNodeModifier o skin_morph 
						if _smMod != undefined then 
						(
							_skinMorphFile = _folder + "\\" + _objName + ".smd"
							lb.skin.saveSkinMorph _smMod _skinMorphFile
							_filesSaved += 1
						)
					)
					
					if _filesSaved > 0 then
						lb.message.show (_filesSaved as string  + " skin Morph data files saved.") type:#message pos:undefined size:[300,75] modal:true
					else
						lb.message.show "SkinMorph data no saved" type:#message pos:undefined size:[300,75] modal:true
				)
			)
			else
				lb.message.show "No found skinMorph files" type:#message pos:undefined size:[300,75] modal:true
			
			setArrowCursor()
		)

		on rdoSkinMorphLoadType changed state do
		(
			spnTolerance.enabled = state == 1
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMskinMorphModifierDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMskinMorphModifierDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMskinMorphModifierDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMskinMorphModifierDef

		------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRMskinMorphModifierDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRMDynConnectDef "Dyn Connect Tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------			
		button btnUnlinkAndAddDynConnect "Unlink and Add DynConnect" pos:[5,5] width:200 height:20	
		
		GroupBox gprSaveAndLoad "Save/Load Options" pos:[5,30] width:200 height:50
			
		button btnSaveDynConnect "Save" pos:[10,50] width:95 height:20
		button btnLoadDynConnect "Load" pos:[105,50] width:95 height:20	

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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRMskinMorphModifierDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRMskinMorphModifierDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@fn: undefined | btnUnlinkAndAddDynConnect | DEsemparenta y 
		------------------------------------------------
		on btnUnlinkAndAddDynConnect pressed do
		(
			_cont = 0
			
			for o in selection where o.parent != undefined do
			(
				_cont += 1
				
				lb.dynConnect.unLinkAndAdd o
				
			)

			
			if _cont > 0 then
				lb.message.show ((_cont as string ) + " dynConnect added") type:#message
			else
				lb.message.show ("No parent in object to add dynConnect") type:#message
		)
		
		------------------------------------------------
		--@fn: undefined | btnLoadDynConnect | Carga el dynConnect en las peizas seleccionadas.
		------------------------------------------------
		on btnLoadDynConnect pressed do
		(
			_selObj = selection[1]
			
			_selObjs = for o in selection collect o
			_assets = (lb.asset.getAssetsFromNodes _selObjs)
			_assetPath = if _assets.count > 0 then _assets[1].folder else ""
			_dynConnectPath = if _assetPath != "" then _assetPath = (_assetPath + @"rig\dynConnect\v" + (formattedprint _assets[1].version format:"02d") + "\\") else ""

			if selection.count == 1 then
			(
				_objName = if classOf _selObj == XRefObject then _selObj.srcItemName else _selObj.name
				
				_file = getOpenFileName caption:"Load File" filename:(_objName + ".dyc") types:"DynConnect Data (*.dyc)|*.dyc"
				
				if not (lb.dynConnect.hasDynConnectInfo _selObj) then
					lb.dynConnect.addAttribute _selObj	
				
				if _file != undefined then 
				(
					lb.dynConnect.load _selObj _file
					lb.dynConnect.connect _selObj
					lb.message.show "DynConnect file loaded" type:#message pos:undefined size:[300,75] modal:true
				)
			)
			else if selection.count > 1 then
			(
				_filesLoaded = 0 
					
				_folder = getSavePath caption:"Load multiple DynConnect files" initialDir:_dynConnectPath
				setWaitCursor()
				
				if (_folder != undefined) then 
				(
					for o in selection do
					(
						_objName = if classOf o == XRefObject then o.srcItemName else o.name
						
						_file = _folder + "\\" + _objName + ".dyc"
						
						if not (lb.dynConnect.hasDynConnectInfo o) then
							lb.dynConnect.addAttribute o	
						
						if _file != undefined then 
						(
							lb.dynConnect.load o _file
							lb.dynConnect.connect o
							_filesLoaded += 1
						)
					)
					
					if _filesLoaded > 0 then
						lb.message.show (_filesLoaded as string + " DynConnect files loaded.") type:#message pos:undefined size:[300,75] modal:true
				)
			)	
		)	
		
		------------------------------------------------
		--@fn: undefined | btnSaveDynConnect | Salva el dynConnect en las peizas seleccionadas.
		------------------------------------------------
		on btnSaveDynConnect pressed do
		(
			_selObjs = for o in selection collect o
			_assets = (lb.asset.getAssetsFromNodes _selObjs)
			_assetPath = if _assets.count > 0 then _assets[1].folder else ""
			_dynConnectPath = if _assetPath != "" then _assetPath = (_assetPath + @"rig\dynConnect\v" + (formattedprint _assets[1].version format:"02d") + "\\") else ""

			-- Si hay un solo objeto seleccionado pedimos ruta y nombre de fichero. Si no solo ruta
			if selection.count == 1 then
			(
				_selObj = selection[1]
				
				-- Buscamos SpaceWarps y guardamos la info
				_FFDbindingNodes = #()

				for i = 1 to _selObj.modifiers.count where (classOf _selObj.modifiers[i] == FFD_Binding) do
				(
					_FFDNode = (refs.dependsOn _selObj.modifiers[i])[1]
					
					if _FFDNode != undefined then
						append _FFDbindingNodes _FFDNode						
				)
				
				if _selObj.parent != undefined or _FFDbindingNodes.count > 0 then 
				(
					if not (lb.dynConnect.hasDynConnectInfo _selObj) then
					(
						lb.dynConnect.addAttribute _selObj
						
						if _selObj.parent != undefined then
							lb.dynConnect.addTarget _selObj "link" _selObj.parent.name connectOnLoad:false keepInitialOffset:true

						for i = 1 to _FFDbindingNodes.count do
							lb.dynConnect.addTarget _selObj "binding" _FFDbindingNodes[i].name connectOnLoad:false keepInitialOffset:true									
					)	
						
					_objName = _selObj.nodeInfo.nameHistory[_selObj.nodeInfo.nameHistory.count]
					
					_file = getSaveFileName caption:"Save DynConnect file" filename:(_dynConnectPath + _objName + ".dyc") types:"DynConnect Data (*.dyc)|*.dyc"
					
					setWaitcursor()
					
					if _file != undefined then 
					(
						lb.dynConnect.save _selObj _file
						lb.message.show "DynConnect file saved" type:#message pos:undefined size:[300,75] modal:true
					)
					
					lb.dynConnect.removeAttribute _selObj
				)
				else
					lb.message.show "No hay información dynConnect que guardar" type:#message pos:undefined size:[300,75] modal:true
			)
			else if selection.count > 1 then
			(
				_filesSaved = 0 
				
				_folder = getSavePath caption:"Save multiple DynConnect files" initialDir:_dynConnectPath
				setWaitCursor()
				
				if (_folder != undefined) then 
				(
					for o in selection do
					(
						if not (lb.dynConnect.hasDynConnectInfo o) then
						(
							lb.dynConnect.addAttribute o
							
							if o.parent != undefined then
								lb.dynConnect.addTarget o "link" o.parent.name connectOnLoad:false keepInitialOffset:true
							
							-- Buscamos SpaceWarps y guardamos la info
							_FFDbinding = #()
		
							print o.name
							print "------"
							
							for i = 1 to o.modifiers.count where (classOf o.modifiers[i] == FFD_Binding) do
								append _FFDbinding o.modifiers[i]
							
							-- Recorremos los ffd de cada objeto y lo añadimos.
							for i = 1 to _FFDbinding.count do
								lb.dynConnect.addTarget o "binding" (refs.dependsOn _FFDbinding[i])[1].name connectOnLoad:false keepInitialOffset:true									
						)
						
						_objName = o.nodeInfo.nameHistory[o.nodeInfo.nameHistory.count]
						
						_file = _folder + "\\" + _objName + ".dyc"
						
						
						if _file != undefined then 
						(
							lb.dynConnect.save o _file
							_filesSaved += 1
						)
						
						lb.dynConnect.removeAttribute o
					)
					
					if _filesSaved > 0 then
						lb.message.show (_filesSaved as string + " DynConnect files saved.") type:#message pos:undefined size:[300,75] modal:true
				)
			)	
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRMDynConnectDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMDynConnectDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRMDynConnectDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRMskinMorphModifierDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollExample1Def | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollExample1Def "Example rollout 1"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollExample1Def.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollExample1Def.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollExample1Def resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollExample1Def open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollExample1Def close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollExample1Def
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollExample2Def | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollExample2Def "Example rollout 2"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollExample2Def.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollExample2Def.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollExample2Def resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollExample2Def open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollExample2Def close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollExample2Def

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Rigging Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 220	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 560	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local opening = false --@var: opening | Flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		dotNetControl tbTabs "DevExpress.XtraTab.XtraTabControl" pos:[0,5] width:350 height:21 --25
	
		------------------------------------------------------------------------------------------------
		--SUBROLLOUTS
		------------------------------------------------------------------------------------------------

		subrollout subRollContainer "subRollouts" pos:[0,26] width:minRollWidth height:574 --@control | subRollContainer | SubRollouts container.

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
		--@fn: undefined | initUI | Inicializa los controles del UI.
		------------------------------------------------
		fn initUI =
		(	
			tbTabs.paintstylename = "PropertyView"
			tbTabs.borderStyle = (dotnetclass "DevExpress.XtraEditors.Controls.BorderStyles").noBorder
			tbTabs.TabPageWidth = 100			
			
			tbTabs.Appearance.BackColor = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbTabs.Appearance.BackColor2 = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbTabs.Appearance.BorderColor = (dotnetclass "system.drawing.color").fromArgb 100 100 100
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
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

			--aplica el tab seleccionado
			parent.selectedTabIndex = (lb.xml.getAttribute parent.cfgFile "rollMain/options" "selectedTabIndex") as integer
			if parent.selectedTabIndex == 0 then parent.selectedTabIndex = 1
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

			--almacena las opciones de UI
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "selectedTabIndex" (parent.selectedTabIndex as string)
		)

		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks de este rollout.
		------------------------------------------------
		fn createSceneEvents =
		(
			--sin operaciones
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Elimina los callbacks de este rollout.
		------------------------------------------------
		fn removeSceneEvents =
		(
			--sin operaciones
		)

		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si el tamaño es menor que el minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento de tamaño
			_increment = [size.x - minRollWidth, size.y - minRollHeight]

			------------------------------------------------------------------------------
			--redimension en horizonal
			
			--forzamos la redimension de los tabs al abrir aunque no haya redimension
			if tbTabs.tabPages.count != 0 then tbTabs.TabPageWidth = (minRollWidth)/(tbTabs.tabPages.count) - 10
			
			if _increment.x != 0 then --si hay incremento
			(			
				tbTabs.width = 350 + _increment.x
				if tbTabs.tabPages.count != 0 then tbTabs.TabPageWidth = (minRollWidth + _increment.x)/(tbTabs.tabPages.count) + 50
				subRollContainer.width = size.x
			)--if
			------------------------------------------------------------------------------

			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				--zona de subRollouts
				subRollContainer.height = 574 + _increment.y				
			)--if
			------------------------------------------------------------------------------

			parent.addTabRollouts()
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: selectedPageChanged | Evento que se lanza al cambiar de tab.
		--@control: DevExpress.XtraTab.XtraTabControl | tbTabs | Tabs.
		--@gets: event | events | Objeto devuelto por el evento.
		------------------------------------------------
		on tbTabs selectedPageChanged events do
		(
			if not opening then
			(
				parent.selectedTabIndex = tbTabs.selectedTabPageIndex + 1
				parent.addTabRollouts()
			)--if
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMainDef | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			opening = true --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg

			initUI() --inicializa el UI
			loadSettings()
			parent.fillTabsRolloutsDefs()
			parent.addTabs()
			createSceneEvents()		
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			opening = false --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(				
			removeSceneEvents()
			saveSettings()

			parent.opened = false
			updateToolbarButtons()		
		)	
	)--rollMainDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: riggingManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_riggingManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Rigging Manager",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.

		minWidth = 220,		--@var: minWidth | Ancho mínimo de la herramienta.
		minHeight = 795,		--@var: minHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		tabForeColor = (dotnetclass "system.drawing.color").fromArgb 189 189 189,
		tabBorderColor = (dotnetclass "system.drawing.color").fromArgb 30 30 30,
		tabBackColor = (dotnetclass "system.drawing.color").fromArgb 60 60 60,
		tabBackColorActive = (dotnetclass "system.drawing.color").fromArgb 90 90 90,
		tabBackColor2 = (dotnetclass "system.drawing.color").fromArgb 55 55 55,
		tabBackColorActive2 = (dotnetclass "system.drawing.color").fromArgb 60 60 60,		

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------

		rollExample1 = rollExample1Def,
		rollExample2 = rollExample2Def,
		rollRMxrefMeshManager = rollRMxrefMeshManagerDef,
		rollRMEditionRig = rollRMEditionRigDef,
		rollRMtwistManager = rollRMtwistManagerDef,
		rollRMautoRig = rollRMautoRigDef,
		rollRMpuppetManager = rollRMpuppetManagerDef,
		rollRMmergeFacialRig = rollRMmergeFacialRigDef,
-- 		rollRMLoadMorphersDef = rollRMLoadMorphersDef
		rollRMheadSystemModifier = rollRMheadSystemModifierDef,
		rollRMskinModifier = rollRMskinModifierDef,
		rollRMskinMorphModifier = rollRMskinMorphModifierDef,
		rollRMDynConnect = rollRMDynConnectDef,
		
		rollMain = rollMainDef,	--@var: rollMain | Main tool rollout.
		
		subRolloutsContainer = this.rollMain.subRollContainer, --@var: subRolloutsContainer | contenedor de subrollouts.

		--estos arrays se rellenan en la funcion fillTabsRolloutsDefs, que se llama al abrir la herramienta.
		--esto es solo la defincion de las variables y una ejemplo de estructura que luego se sobrescribe.
		tabNames = #("", "", ""), --@var: tambNames | Nombres de los tabs.
		tabRollouts = #(#(undefined), #(undefined), #(undefined), #(undefined), #(undefined)), --@var: mentalrayTabNames | Rollots de cada tab.
		tabRolloutsRolledUp = #(#(true), #(true), #(true), #(true), #(true)), --@var: tabRolloutsRolledUp | Estado de desplegado/plegado de cada rollout de cada tab.

		selectedTabIndex = 1, --@var: selectedTabIndex | Tab seleccionado. Para usar al abrir y cerrar la herramienta

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
		--@fn: undefined | updateTabsColor | Actualiza el color de los tabs.
		------------------------------------------------
		fn updateTabsColor =
		(
			--actualiza los tabs
			for i=1 to this.tabNames.count do
			(
				--configura los colores de los tabs
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.ForeColor = this.tabForeColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BackColor = this.tabBackColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BackColor2 = this.tabBackColor2
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BorderColor = this.tabBorderColor
				
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 8
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.ForeColor = this.tabForeColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor = this.tabBackColorActive
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor2 = this.tabBackColorActive2
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BorderColor = this.tabBorderColor
			)--for
		),

		------------------------------------------------
		--@fn: undefined | fillTabsRolloutsDefs | Añade los tabs y las definiciones de los rollouts a los arrays correspondientes para que la herremienta sepa donde están.
		------------------------------------------------
		fn fillTabsRolloutsDefs =
		(
			this.tabNames = #("Xref", "Skin", "Anim", "Facial", "Skin", "DynC")
			this.tabRollouts = #(#(lb.riggingManager.rollRMxrefMeshManager), #(lb.riggingManager.rollRMEditionRig, lb.riggingManager.rollRMtwistManager), #(lb.riggingManager.rollRMautoRig, lb.riggingManager.rollRMpuppetManager), #(lb.riggingManager.rollRMmergeFacialRig, lb.riggingManager.rollRMheadSystemModifier), #(lb.riggingManager.rollRMskinModifier, lb.riggingManager.rollRMskinMorphModifier), #(lb.riggingManager.rollRMDynConnect))
			this.tabRolloutsRolledUp = #(#(false), #(false, false, false), #(false, false, false, false), #(false, false), #(false, false), #(false))
		),

		------------------------------------------------
		--@fn: undefined | addTabs | Añade los tabs.
		------------------------------------------------
		fn addTabs =
		(
			--elimina los tabs actuales
			this.rollMain.tbTabs.tabPages.clear()

			--añade los tabs
			for i=1 to this.tabNames.count do
				this.rollMain.tbTabs.tabPages.add this.tabNames[i] --añade el tab
			
			if this.rollMain.tbTabs.tabPages.count != 0 then this.rollMain.tbTabs.TabPageWidth = (this.rollMain.width)/(this.rollMain.tbTabs.tabPages.count) - 17

			--selecciona el tab que estaba seleccionado la ultima vez que se abrio el override
			if this.rollMain.tbTabs.tabPages.count >= this.selectedTabIndex then
				this.rollMain.tbTabs.SelectedTabPage = this.rollMain.tbTabs.tabPages.item[this.selectedTabIndex - 1]
			
			this.updateTabsColor() --actualiza los colores de los tabs
			
			this.addTabRollouts()			
		),

		------------------------------------------------
		--@fn: undefined | removeAllTabRollouts | Elimina todos los subrollouts actuales
		------------------------------------------------
		fn removeAllTabRollouts =
		(
			--elimina los subRollouts actuales
			while this.subRolloutsContainer.rollouts.count != 0 do RemoveSubRollout this.subRolloutsContainer this.subRolloutsContainer.rollouts[1]
		),

		------------------------------------------------
		--@fn: undefined | addTabRollouts | Añade los rollouts del tab actual.
		------------------------------------------------
		fn addTabRollouts =
		(
			--elimina los subRollouts actuales
			this.removeAllTabRollouts()

			--añade los subRollouts
			for i=1 to this.tabRollouts[this.selectedTabIndex].count where this.tabRollouts[this.selectedTabIndex][i] != undefined do
			(
				AddSubRollout this.subRolloutsContainer this.tabRollouts[this.selectedTabIndex][i] rolledUp:this.tabRolloutsRolledUp[this.selectedTabIndex][i]
				this.tabRollouts[this.selectedTabIndex][i].resize [this.rollMain.width, this.rollMain.height]
			)
		),

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
	)--tl_riggingManager

	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_riggingManager() --crea la herramienta
)