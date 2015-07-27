------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Conjunto de rollouts con funcionalidades diversas para el Lighting manager.
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rollAssetMappingDef | Contiene los arrays rellenables para la tabla del AssetMapping.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strAssetMappingDef
	(
		sceneAsset, 
		sceneAssetName,				
		targetAssetName,
		assetFolder = "",
		newObjectsNames = #(),
		action = #load,	--	puede valer #load, #loadNewObjects, #merge, #append y #none
		updated = true
	)

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollAssetMappingDef | Contiene la herramienta Asset Mapping.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollAssetMappingDef "Asset Mapping"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 685															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 335															--@var: integer | minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local sceneAssets = #()
		local currentFileAssetNames = #()
		local targetFileAssetNames = #()

		local assetMappingList = #()	--	lista de strAssetMapping
		local notFoundLabel = ""	

		local colorLoad 		=  (dotnetclass "System.Drawing.Color").black
		local colorNoAction 	= (dotnetclass "System.Drawing.Color").gray
		local colorMerge 		= (dotnetclass "System.Drawing.Color").green
		local colorDelete 		=  (dotnetclass "System.Drawing.Color").red
		local colorUpdated 		= (dotnetclass "System.Drawing.Color").green
		local colorNotUpdated 	=  (dotnetclass "System.Drawing.Color").red	

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		local rMenu = dotnetObject "System.Windows.Forms.ContextMenuStrip" 					--@var: dotNetObject | rMenu | Menu de boton derecho para las opciones del arbol de nodeSets.
		dotNetControl lvMapping "System.Windows.Forms.ListView" pos:[5,5] width:675 height:230 

		GroupBox grpMappingOptions "Mapping Options" pos:[5,240] width:590 height:60
		dropdownList ddlTargetAssets "" pos:[75,255] width:230 height:21
				
		radiobuttons rdoLoad "" pos:[20,260] width:55 height:16 labels:#("Load") default:0
		radiobuttons rdoMerge "" pos:[20,280] width:64 height:16 labels:#("Merge") default:0
		radiobuttons rdoLoadNewObjects "" pos:[360,255] width:65 height:16 labels:#("Load New Objects") default:0
		radiobuttons rdoDelete "" pos:[360,280] width:65 height:16 labels:#("Delete") default:0
		radiobuttons rdoReplace "" pos:[525,255] width:76 height:16 labels:#("Replace") default:0
		radiobuttons rdoNone "" pos:[525,280] width:57 height:16 labels:#("None") default:0

		button btnLoad "Load" pos:[5,305] width:292 height:25
		button btnCancel "Cancel" pos:[300,305] width:294 height:25

		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------		

		------------------------------------------------
		--@fn: boolean | isAssetFolderUpdated | Comprueba que las carpetas texture y version están actualizadas
		--@gets: string | folder | Ruta al fichero donde se consultará si el asset esta actualizado
		--@returns: boolean | undefined | Devuelve true si el asset se encuentra actualizado, false si no.
		------------------------------------------------
		fn isAssetFolderUpdated folder =
		(
			if doesFileExist folder do
				return (makeUniqueArray (for _subfolder in #("texture", "version") collect lb.svn.isFolderUpdated(folder + "\\" + _subfolder)))[1] == true
			return false
		)

		------------------------------------------------
		--@fn: undefined | menuItemClickedProcess | Ejecuta las acciones todos los menús de la herramienta.
		--@gets: string | menuText | Nombre del item que se está clickando
		------------------------------------------------
		fn menuItemClickedProcess menuText =
		(
			_folder = lvMapping.selectedItems.item[0].subitems.item[4].text
			case menuText of
			(
				"Open In Explorer": shellLaunch _folder ""
				
				"Update":
				(
					--shellLaunch "TortoiseProc" ("/command:update /path:\"" + _folder + "\"  /closeonend:1")
					--HiddenDOSCommand ("TortoiseProc " + ("/command:update /path:\"" + _folder + "\"  /closeonend:1"))
					HiddenDOSCommand ("TortoiseProc " + ("/command:update /path:\"" + _folder + "\\texture*" + _folder + "\\version\"  /closeonend:1"))
					
					_updated = true/*isAssetFolderUpdated (lvMapping.selectedItems.item[0].subitems.item[4].text)*/
					if _updated then
					(
						assetMappingList[lvMapping.selectedItems.item[0].index + 1].updated = true
						lvMapping.selectedItems.item[0].subitems.item[3].text = "updated"
						lvMapping.selectedItems.item[0].subitems.item[3].foreColor = colorUpdated
					)
				)--update
			)--case
		)

		------------------------------------------------
		--@fn: undefined | createRMenu | Rellena el menu de boton derecho en función de la opcion.
		--@gets: point2 | pos | Posición en la que debe dibujarse el menu.
		------------------------------------------------
		fn createRMenu pos =
		(
			_rMenuItems = #() --array para almacenar los items del menu
			
			rMenu.items.clear() --vacía el menú
			rMenu.rendermode = (dotnetclass "System.Windows.Forms.ToolStripRenderMode").system --elige el modo de dibujado del menu
			
			--rellena el array de items con todas las opciones
			append _rMenuItems "Open In Explorer"
			append _rMenuItems "Update"

			--añade todos los items al menú
			for i = 1 to _rMenuItems.count do rMenu.items.add _rMenuItems[i]
					
			rMenu.Show pos.x pos.y --muestra el menú
		)

		------------------------------------------------
		--@fn: undefined | rMenuItemclickedEvent | Funcion que para el evento que se lanza al levantar el raton despues de hacer click o click derecho.
		--@gets: System.Windows.Forms.ContextMenuStrip | self | Posición en la que debe dibujarse el menu.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		fn rMenuItemclickedEvent self events =
		(
			_itemName = (events.clickeditem.tostring())
			menuItemClickedProcess _itemName
		)

		------------------------------------------------
		--@fn: undefined | initControls | Rellena la información necesaria para trabajar y pinta el interface con esos datos
		------------------------------------------------
		fn initControls =
		(
			--añade el evento al menu
			dotnet.addEventHandler rMenu "itemClicked" rollAssetMappingDef.rMenuItemclickedEvent
		)

		----------------------------------------------------------------------------------------
		--@fn: undefined | initListView | inicia el ListView con todas sus propiedades principales, sin introducir datos
		----------------------------------------------------------------------------------------
		fn initListView =
		(
			lv = lvMapping
			
			lv.gridLines = false
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.labelEdit = false
			lv.fullRowSelect = true
			lv.backColor = (dotnetclass "System.Drawing.Color").fromARGB 220 220 220
			lv.hideSelection = false
			lv.multiSelect = true
			lv.padding.all = 0
			lv.scrollable = true
			lv.gridlines = true
			lv.headerStyle = (dotnetclass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
			
			lv.Columns.add "Current File" 186
			lv.Columns.add "Target File" 185
			lv.Columns.add "Action" 100
			lv.Columns.add "SVN Updated" 185
			lv.Columns.add "Asset Folder" 0

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		----------------------------------------------------------------------------------------
		--@fn: undefined | fillListView | rellena el ListView con el contenido del listado assetMappingList
		----------------------------------------------------------------------------------------
		fn fillListView =
		(
			_createList = lvMapping.items.count == 0	-- Indica si hay que crear el listado de elementos o simplemente actualizarlo.
			
			for a in assetMappingList do
			(
				lvMapping.items.add a.sceneAssetName
				lvMapping.items.item[(lvMapping.items.count)-1].UseItemStyleForSubItems = false
				
				item = lvMapping.items.item[lvMapping.items.count-1]
				
				item.subitems.add a.targetAssetName
				item.subitems.add (a.action as string)

				item.subitems.add (if a.updated then "CHECK IF YOU ARE UPDATED!" else "CHECK IF YOU ARE UPDATED!")
				item.subitems.add a.assetFolder
				
				_colorToUse = colorNoAction
				case item.subitems.item[2].text of
				(
					"none": _colorToUse = colorNoAction
					"merge": _colorToUse = colorMerge
					"delete": _colorToUse = colorDelete
				)

				item.subitems.item[0].foreColor = _colorToUse
				item.subitems.item[1].foreColor = _colorToUse
				item.subitems.item[2].foreColor = _colorToUse

				case item.subitems.item[3].text of
				(
					"updated": item.subitems.item[3].foreColor = colorUpdated
					"not updated": item.subitems.item[3].foreColor = colorNotUpdated
				)
			)
		)

		----------------------------------------------------------------------------------------
		--@fn: undefined | refreshListView | refresca el ListView con el contenido del listado assetMappingList sin limpiar el listado
		----------------------------------------------------------------------------------------
		fn refreshListView =
		(
			i = 0
			for a in assetMappingList do
			(
				item = lvMapping.items.item[i]
				item.text = a.sceneAssetName
				item.subitems.item[1].text = a.targetAssetName
				item.subitems.item[2].text = (a.action as string)
				
				case item.subitems.item[2].text of
				(
					"load": item.foreColor = colorLoad
					"none": item.foreColor = colorNoAction
					"merge": item.foreColor = colorMerge
					"delete": item.foreColor = colorDelete
				)
				
				i += 1
			)
		)

		----------------------------------------------------------------------------------------
		--@fn: undefined | initMapping | rellena los datos del ListView 
		----------------------------------------------------------------------------------------
		fn initMapping =
		(
			/*if not (lb.svn.svnIsFileUpdated lb.lightingManagerMini.cacheFile) and not (lb.message.show "Cache file not updated. Continue?" type:#query size:[650,75] pos:((getDialogPos rollAssetMappingDef) + [rollAssetMappingDef.width,rollAssetMappingDef.height]/2 - [325,0])) then
				return false

			_sourceFolder = (lb.io.getDirName lb.lightingManagerMini.cacheFile) + "\\source"

			if not (lb.svn.isFolderUpdated _sourceFolder) and not (lb.message.show "Cache sources not updated. Continue?" type:#query size:[650,75] pos:((getDialogPos rollAssetMappingDef) + [rollAssetMappingDef.width,rollAssetMappingDef.height]/2 - [325,0])) then
				return false*/

			_sceneAssets = #()

			for a in lb.asset.getSceneAssets() do
			(
				if (a.type != lb.nc.NC_setPrefix) and not (matchpattern a.name pattern:"domo*") then
				(
					appendIfUnique _sceneAssets a
				)
			)
			
			currentFileAssetNames = (for a in _sceneAssets collect a.fullName)
			
			--obtiene el file info
			_fileInfo = lb.fileInfo.getFileInfo lb.lightingManagerMini.cacheFile
			_assets = _fileInfo.getNodes "fileInfo/assets/asset"
			_targetFileAssetNames = for _ast in _assets collect _ast.getProperty "fullname"
			targetFolders = for _ast in _assets collect _ast.getProperty "folder"

			--obtiene los nombres de los nodos pertenecientes a cada asset dentro del archivo a cargar
			_fileObjects = getMAXFileObjectNames lb.lightingManagerMini.cacheFile
			_assetsNodesNames = for _ast in _assets collect #()
			for i=1 to _fileObjects.count do
			(
				_nameParts = filterString _fileObjects[i] "_"
				if _nameParts.count > 1 then
				(
					_assetName = _nameParts[1] + "_" + _nameParts[2]
					_index = findItem _targetFileAssetNames _assetName
					if _index != 0 then append _assetsNodesNames[_index] _fileObjects[i]
				)
			)--for
			
			assetMappingList = #()
			
			setWaitCursor()

			--for _ast in _sceneAssets do
			--(
			--	_assetFound = false
			--	for t in targetFileAssetNames where t == _ast.fullName do
			--	(
			--		append assetMappingList (parent.strAssetMapping sceneAsset:_ast sceneAssetName:_ast.fullName targetAssetName:t action:#load updated:true assetFolder:_ast.folder)
			--		_assetFound = true
			--	)--for
				
			--	if not _assetFound then
			--		append assetMappingList (parent.strAssetMapping sceneAsset:_ast sceneAssetName:_ast.fullName targetAssetName:notFoundLabel action:#delete updated:true assetFolder:_ast.folder)
			--)--for
			
			for _ast in _sceneAssets do
			(
				_assetFound = false
				
				if (findItem #("undefined", undefined) _ast.folder) != 0 then
				(
					lb.message.show ("Corrupt file info for " + _ast.name as string + ".\nPlease fix it saving again current file.") type:#message size:[650,75] pos:((getDialogPos rollAssetMappingDef) + [rollAssetMappingDef.width,rollAssetMappingDef.height]/2 - [325,0]) modal:true
					continue
				)
				
				_updated = true /*isAssetFolderUpdated _ast.folder*/

				for i=1 to _targetFileAssetNames.count where _targetFileAssetNames[i] == _ast.fullName do
				(
					_hasNewObjects = false
					_assetNewNodes = #()
					_aNodesNames = for node in _ast.nodes collect node.name --recopila los nombres de los nodos del asset en la escena

					for _nodeName in _assetsNodesNames[i] where findItem _aNodesNames _nodeName == 0 do
					(
						append _assetNewNodes _nodeName
						_hasNewObjects = true
					)--for

					if _hasNewObjects then
					(
						append assetMappingList (parent.strAssetMapping sceneAsset:_ast sceneAssetName:_ast.fullName targetAssetName:_targetFileAssetNames[i] action:#loadNewObjects updated:_updated assetFolder:_ast.folder newObjectsNames:_assetNewNodes)
					)
					else
					(	
						append assetMappingList (parent.strAssetMapping sceneAsset:_ast sceneAssetName:_ast.fullName targetAssetName:_targetFileAssetNames[i] action:#load updated:_updated assetFolder:_ast.folder)
					)--if else

					_assetFound = true
				)--for
				
				if not _assetFound then
					append assetMappingList (parent.strAssetMapping sceneAsset:_ast sceneAssetName:_ast.fullName targetAssetName:notFoundLabel action:#delete updated:_updated assetFolder:_ast.folder)
			)--for*/			
			
			--	Añadimos los assets del fichero destino que no se hayan cargado
			for i=1 to _targetFileAssetNames.count where (findItem currentFileAssetNames _targetFileAssetNames[i] == 0) do
			(
				if (findItem #("undefined", "") targetFolders[i]) != 0 then
				(
					lb.message.show ("Corrupt file info for " + _targetFileAssetNames[i] as string + ".\nPlease fix it saving again cache file.") type:#message size:[650,75] pos:((getDialogPos rollAssetMappingDef) + [rollAssetMappingDef.width,rollAssetMappingDef.height]/2 - [325,0]) modal:true
					continue
				)

				_updated = true /*isAssetFolderUpdated targetFolders[i]*/

				append assetMappingList (parent.strAssetMapping sceneAsset:undefined sceneAssetName:notFoundLabel targetAssetName:_targetFileAssetNames[i] action:#merge updated:_updated assetFolder:targetFolders[i])
				assetFound = true
			)--for
			
			setArrowCursor()

			return true
		)

		----------------------------------------------------------------------------------------
		--@fn: undefined | setAssetsMappingAction | Establece la acción de mapeado para los assets seleccionados
		--@gets: name | action | etiqueta del tipo de acción #load,#merge,#replace
		----------------------------------------------------------------------------------------
		fn setAssetsMappingAction action =
		(
			_selItems = for i = 1 to lvMapping.selectedItems.count collect lvMapping.selectedItems.item[i-1]
			
			for i = 1 to _selItems.count do
			(
				_index = _selItems[i].index + 1
				_amItem = assetMappingList[_index]
				_applyAction = true
				
				if (action == #load or action == #delete)  and _amItem.sceneAssetName == "" then _applyAction = false
				if action == #merge and _amItem.sceneAssetName != ""  then _applyAction = false
				if action == #replace and _amItem.sceneAssetName == ""  then _applyAction = false
					
				if _applyAction then
					assetMappingList[_index].action = action
			)
		)

		----------------------------------------------------------------------------------------
		--@fn: undefined | refreshUI | Actualiza los controles según la selección del listView
		----------------------------------------------------------------------------------------
		fn refreshUI =
		(
			_selItems = for i = 1 to lvMapping.selectedItems.count collect lvMapping.selectedItems.item[i-1]
			
			rdoLoad.state = 0
			rdoMerge.state = 0
			rdoLoadNewObjects.state = 0
			rdoReplace.state = 0
			rdoDelete.state = 0
			rdoNone.state = 0
			
			if _selItems.count > 0 then
			(
				rdoLoad.enabled = true
				rdoMerge.enabled = true
				rdoLoadNewObjects.enabled = true
				rdoReplace.enabled = true
				rdoDelete.enabled = true
				rdoNone.enabled = true
				
				ddlTargetAssets.items = #()
				ddlTargetAssets.enabled = false				
				
				for i = 1 to _selItems.count do
				(
					_index = _selItems[i].index + 1
					_amItem = assetMappingList[_index]
					
					if _selItems.count == 1 then 
					(
						if _amItem.sceneAssetName == "" then 
							(rdoLoad.enabled = rdoLoadNewObjects.enabled = rdoReplace.enabled = rdoDelete.enabled = false)
						else 
							(rdoMerge.enabled = false)
					)--if
					
					case _amItem.action of
					(
						#load: 
						(
							rdoLoad.state = 1
							
							--	Si solo hay un elemento seleccionado habilitamos el selector de mapeado de asset.
							if _selItems.count == 1 then 
							(
								targetIndex = findItem targetFileAssetNames _selItems[1].subitems.item[1].text 
								if targetIndex == 0 then index = 1
									ddlTargetAssets.selection = targetIndex
								
								ddlTargetAssets.items = targetFileAssetNames
								ddlTargetAssets.enabled = true
							)
						)

						#loadNewObjects: 
						(
							rdoLoadNewObjects.state = 1
						)
						
						#merge: 
						(
							rdoMerge.state = 1
						)
						
						#delete: 
						(
							rdoDelete.state = 1
						)
						
						#replace: 
						(
							rdoReplace.state = 1
						)
						
						#none: 
						(
							rdoNone.state = 1
						)
					)
				)--case
				
				if rdoLoad.state + rdoMerge.state + rdoReplace.state + rdoDelete.state + rdoNone.state > 1 then 
				(
					rdoLoad.state = 0
					rdoMerge.state = 0
					rdoLoadNewObjects.state = 0
					rdoReplace.state = 0
					rdoDelete.state = 0
					rdoNone.state = 0
				)--if
			)
			else	--	Si hay más de un elemento seleccionado.
			(
				ddlTargetAssets.items = #()
				ddlTargetAssets.enabled = false
				rdoLoad.enabled = false
				rdoLoadNewObjects.enabled = false
				rdoReplace.enabled = false
				rdoMerge.state = 0
				rdoDelete.enabled = false
				rdoNone.enabled = false
			)
		)

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
			if size.x < minRollWidth then (size.x = minRollWidth; rollAssetMappingDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollAssetMappingDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(	
				lvMapping.width = 590 + _increment.x
				--lvMapping.Columns.item[0].width = 186 + (_increment.x/2)
				--lvMapping.Columns.item[1].width = 185 + (_increment.x/2)

				grpMappingOptions.width = 590 + _increment.x

				btnLoad.pos.x = 5 + (_increment.x/2)
				btnCancel.pos.x = 300 + (_increment.x/2)
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				lvMapping.height = 230 + _increment.y

				grpMappingOptions.pos.y = 240 + _increment.y
				ddlTargetAssets.pos.y = 255 + _increment.y
						
				rdoLoad.pos.y = 255 + _increment.y
				rdoMerge.pos.y = 280 + _increment.y
				rdoLoadNewObjects.pos.y = 255 + _increment.y
				rdoDelete.pos.y = 280 + _increment.y
				rdoReplace.pos.y = 255 + _increment.y
				rdoNone.pos.y = 280 + _increment.y

				btnLoad.pos.y = 305 + _increment.y
				btnCancel.pos.y = 305 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("tool/rollAssetMapping/pos") "x" (((getDialogPos rollAssetMappingDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollAssetMapping/pos") "y" (((getDialogPos rollAssetMappingDef).y) as string)
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("tool/rollAssetMapping/size") "width" (rollAssetMappingDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollAssetMapping/size") "height" (rollAssetMappingDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--tamaño
			_width = (lb.xml.getAttribute parent.cfgFile ("tool/rollAssetMapping/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("tool/rollAssetMapping/size") "height") as integer

			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("tool/rollAssetMapping/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("tool/rollAssetMapping/pos") "y") as integer
			
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollAssetMappingDef.width = _width
			rollAssetMappingDef.height = _height
			setDialogPos rollAssetMappingDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: mouseUp | Refresca el UI
		------------------------------------------------		
		on lvMapping mouseUp events do
		(
			_button = events.button.ToString() --averigua si es boton izquierdo, derecho o central

			--en función del boton pulsado ha de realizar unas operaciones u otras
			case _button of
			(
				"Right": --boton derecho
				(
					createRMenu mouse.screenPos
				)--Right

				default:
				(
					refreshUI()
				)
			)--case				
		)

		------------------------------------------------
		--@event: mouseUp | Cierra el dialogo rollAssetMapping 
		------------------------------------------------
		on btnCancel pressed do
		(
			destroyDialog rollAssetMappingDef
		)

		------------------------------------------------
		--@event: pressed | Carga el cache de la animacion, la camara...
		------------------------------------------------
		on btnLoad pressed do
		(
			_requireUpdate = false
			_assetsToUpdateNames = #()

			for _am in assetMappingList where (not _am.updated) and (_am.action == #merge or _am.action == #replace) do
			(
				_requireUpdate = true
				append _assetsToUpdateNames _am.targetAssetName
			)--for

			if _requireUpdate then --si algun asset a mergear no esta actualizado avisa con un mensaje
			(				
				_message = "Some assets you are trying to merge are not updated. You must update them manually first (Right Click + Update)\n"
				for _ast in _assetsToUpdateNames do _message += "\n" + _ast
				lb.message.show _message size:[650,75] pos:((getDialogPos rollAssetMappingDef) + [rollAssetMappingDef.width,rollAssetMappingDef.height]/2 - [325,0])
			)
			else --si todo es correcto carga los caches
			(
				if lb.lightingManagerMini.cacheFile != undefined then
				(
					lb.cache.loadCachesFromScene lb.lightingManagerMini.cacheFile assetMappingList importCamera:parent.rollCacheLoader.chkImportCamera.checked deleteOldCameras:parent.rollCacheLoader.chkDeleteOldCamera.checked loadMatLib:parent.rollCacheLoader.chkLoadMaterialLibrary.checked 
				)
				else
				(
					lb.message.show "An error ocurred" size:[650,75] pos:((getDialogPos rollAssetMappingDef) + [rollAssetMappingDef.width,rollAssetMappingDef.height]/2 - [325,0])
				)
			)
		)
		
		-----------------------------------------------------------------------------------------------------
		on rdoLoad changed state do
		(
			if state == 1 then
			(
				setAssetsMappingAction #load
				refreshListView()
				refreshUI()
			)
		)
		
		-----------------------------------------------------------------------------------------------------
		on rdoMerge changed state do
		(
			if state == 1 then
			(
				setAssetsMappingAction #merge
				refreshListView()
				refreshUI()
			)
		)

		-----------------------------------------------------------------------------------------------------
		on rdoLoadNewObjects changed state do
		(
			if state == 1 then
			(
				setAssetsMappingAction #loadNewObjects
				refreshListView()
				refreshUI()
			)
		)
		
		-----------------------------------------------------------------------------------------------------
		on rdoReplace changed state do
		(
			if state == 1 then
			(
				setAssetsMappingAction #replace
				refreshListView()
				refreshUI()
			)
		)
		
		-----------------------------------------------------------------------------------------------------
		on rdoDelete changed state do
		(
			if state == 1 then
			(
				setAssetsMappingAction #delete
				refreshListView()
				refreshUI()
			)
		)
		
		-----------------------------------------------------------------------------------------------------
		on rdoNone changed state do
		(
			if state == 1 then
			(
				setAssetsMappingAction #none
				refreshListView()
				refreshUI()
			)
		)

		-----------------------------------------------------------------------------------------------------
		on chkLoadAsset changed state do
		(
			
			_selItems = for i = 1 to lvMapping.selectedItems.count collect lvMapping.selectedItems.item[i-1]
			_
			for item in _selItems do
			(
				_index = item.index + 1
				if state then 
				(
					if assetMappingList[_index].sceneAssetName != notFoundLabel then 
						assetMappingList[_index].action = #load 
					else 
						assetMappingList[_index].action = #merge 
				)
				else 
				(
					assetMappingList[_index].action = if assetMappingList[_index].targetAssetName != "" then #none else #delete
				)
			)
			
			refreshListView()
			refreshUI()
		)
		
		-----------------------------------------------------------------------------------------------------
		on ddlTargetAssets selected val do
		(
			index = lvMapping.selectedItems.item[0].index + 1
			assetMappingList[index].targetAssetName = ddlTargetAssets.selected
			
			refreshListView()
			--lvMapping.items.item[index-1].selected = true
			
			--refreshUI()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rolloutchkImportCamera | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollAssetMappingDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollAssetMappingDef open do
		(	
			initControls()		
			loadSettings()
			initListView()
			if initMapping() then
			(
				fillListView()
				refreshUI()
				createSceneEvents() --crea los callbacks
			)
			else
			(
				destroyDialog rollAssetMappingDef
			)
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollAssetMappingDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollAssetMappingDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: Lighting Import/Export | Contiene la herramienta Lighting Import/Export.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollLightImpExpDef "Lighting Import/Export"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		

		local minRollWidth = 218															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 135															--@var: integer | minRollHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnImportLPMdata "Import" pos:[5,10] width:100 height:21
		button btnExportLPMdata "Export" pos:[105,10] width:95 height:21
		
		groupBox grpImportOptions "Import options" pos:[5,35] width:195 height:45
		checkbox chkImportLights "Lights" pos:[16,55] width:72 height:16 checked:true enabled:false
		checkbox chkImportLPMdata "LPM data" pos:[110,55] width:72 height:16 checked:true enabled:false
		
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
				btnImportLPMdata.pos.x = 5 + _increment.x/2
				btnExportLPMdata.pos.x = 105 + _increment.x/2
				grpImportOptions.pos.x = 5 + _increment.x/2
				chkImportLights.pos.x = 16 + _increment.x/2
				chkImportLPMdata.pos.x = 110 + _increment.x/2
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--lb.xml.setAttribute parent.cfgFile ("tool/rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("tool/rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------------------------------------
		on btnImportLPMdata pressed do
		(
			_message = "The elements listed below will be removed from scene:\n"
			if chkImportLights.checked then append _message "- Scene Lights\n"
			if chkImportLPMdata.checked then append _message "- LPM data\n"
			append _message "\nDo you really want to continue?"
			
			if (queryBox _message) then
			(
				filename = getOpenFileName caption:"Import LPM data" types:"Lighting Data(*.lgt)|*.lgt"
				
				if filename != undefined then
				(
					setWaitCursor()
					parent.importLightingFile filename importLights:chkImportLights.checked importLPMdata:chkImportLPMdata.checked
					setArrowCursor()
				)
			)
		)
		
		-----------------------------------------------------------------------------------------------------		
		on btnExportLPMdata pressed do
		(
			filename = getSaveFileName caption:"Export LPM data" filename:(getFileNameFile maxFileName) types:"LPM Data(*.lgt)|*.lgt"
			
			if filename != undefined then
			(
				setWaitCursor()
				parent.exportLightingFile filename
				setArrowCursor()
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
		on rollLightImpExpDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollLightImpExpDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize parent.rollMain.size
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollLightImpExpDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollLightImpExp

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: Ligh Constrainer | Contiene la herramienta Light Constrainer.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollLightContrainerDef "Light Constrainer"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		

		local minRollWidth = 218															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 135															--@var: integer | minRollHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local _theTarget = undefined
		local _theLight = undefined
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		pickbutton btnSelectTarget "Select Target" pos:[50,10] width:110 height:24 toolTip:"Select the object to be followed"
		pickbutton btnSelectLight "Select Light" pos:[50,60] width:110 height:24 toolTip:"Select the light to be constrained"
		button btnConstraint "Constraint" pos:[50,110] width:110 height:24 toolTip:"Create Constraint"
		label lblTarget "No target selected" pos:[10,40] width:180 height:20
		label lblLight "No light selected" pos:[10,90] width:180 height:20
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--lb.xml.setAttribute parent.cfgFile ("tool/rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("tool/rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		on btnSelectTarget picked obj do
		(
				_theTarget = obj
				lblTarget.caption = obj.name
				btnSelectTarget.caption = "Target selected"
		)

		on btnSelectLight picked obj do
		(
				if superclassof obj == light do
				(
				   _theLight = obj
				   lblLight.caption = obj.name
				   btnSelectLight.caption = "Light selected"
				)
		)


		on btnConstraint pressed do
		(
			if _theTarget != undefined and _theLight != undefined do
			(
				_theLight.pos.controller = Position_Constraint ()
				_theLight.pos.controller = position_list ()
				_theLight.pos.controller.Available.controller = Position_XYZ ()
				_theLight.pos.controller.Position_Constraint.controller.RELATIVE = on
				_theLight.pos.controller.Position_Constraint.appendTarget _theTarget 100.0
				_theLight.pos.controller.setActive 2
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
		on rollLightContrainerDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollLightContrainerDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize parent.rollMain.size
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollLightContrainerDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollLightContrainer	

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: Cache Loader | Contiene la herramienta Cache Loader.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollCacheLoaderDef "Cache Loader"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 218															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 155															--@var: integer | minRollHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		button btnLoadCaches "Load Caches" pos:[5,10] width:195 height:21
		groupBox grpImportOptions "Load options" pos:[5,35] width:195 height:85
		checkbox chkImportCamera "Import Camera" pos:[15,55] width:125 height:16 checked:true	
		checkbox chkDeleteOldCamera "Delete Old Camera" pos:[15,75] width:125 height:16 checked:true	
		checkbox chkLoadMaterialLibrary "Load material library" pos:[15,95] width:125 height:16 checked:false

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
				btnLoadCaches.pos.x = 5 + _increment.x/2
				grpImportOptions.pos.x = 5 + _increment.x/2
				chkImportCamera.pos.x = 15 + _increment.x/2
				chkDeleteOldCamera.pos.x = 15 + _increment.x/2
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--lb.xml.setAttribute parent.cfgFile ("tool/rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("tool/rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		on btnLoadCaches pressed do
		(
			_process = true
			lb.lightingManagerMini.cacheFile = undefined
			lb.lightingManagerMini.cacheFile = getOpenFileName filename:(maxFilePath + "..\\cache\\" + maxFileName) types:"Cache Files(*_cache*.max)|*_cache*.max"

			if lb.lightingManagerMini.cacheFile != undefined then
			(
				if (not lb.fileInfo.isFileChecked (lb.lightingManagerMini.cacheFile)) then
				(
					_process = lb.message.show "The cache file is not checked, \n are you sure you want to continue?" type:#query
				)	
				if _process then
				(
					_width = (lb.xml.getAttribute parent.cfgFile ("rollAssetMapping/size") "width") as integer
					_height = (lb.xml.getAttribute parent.cfgFile ("rollAssetMapping/size") "height") as integer
						
					----posicion
					_posX = (lb.xml.getAttribute parent.cfgFile ("rollAssetMapping/pos") "x") as integer
					_posY = (lb.xml.getAttribute parent.cfgFile ("rollAssetMapping/pos") "y") as integer
						
					--aplica los valores
					rollAssetMappingDef.width = _width
					rollAssetMappingDef.height = _height
					setDialogPos rollAssetMappingDef [_posX,_posY]
					
					createDialog parent.rollAssetMapping pos:[_posX,_posY] lockwidth:false lockheight:false minsize:[500,450] style:#(#style_border,#style_resizing,#style_titlebar, #style_sysmenu) --modal:true
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
		on rollCacheLoader resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollCacheLoader open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize parent.rollMain.size
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollCacheLoader close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollCacheLoader

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: Lighting Import/Export | Contiene la herramienta Lighting Import/Export.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollSetLockUnlockDef "Set Locker / Unlocker"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		

		local minRollWidth = 218															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 135															--@var: integer | minRollHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		button btnUnLock "Unlock tracks" pos:[30,10] width:150 height:25 
	
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--lb.xml.setAttribute parent.cfgFile ("tool/rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("tool/rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------------------------------------

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		on btnUnlock pressed do 
		(
			_sceneAssets = lb.asset.getSceneAssets()
			_numSetAssets = 0
			for _asset in _sceneAssets where _asset.type == lb.nc.NC_setPrefix do 
			(
				for _node in _asset.meshNodesAll do 
				(
					setTransformLockFlags _node #none
					_nodeAnimTracks = lb.animInfo.getTracks _node true
					for t in _nodeAnimTracks where t.type != #separator do
						lb.animation.setLocks t.track false affectChildren:false
				)
			)		
		)

		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollSetLockUnlockDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollSetLockUnlockDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize parent.rollMain.size
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollSetLockUnlockDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollLightImpExp

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lightingManagerMini | Contiene la herramienta lightingManagerMini.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_lightingManagerMini
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),													--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),										--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #lighting,													--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),		--@var: string | className | Nombre de la tool.
		description = "ToollightingManagerMini",								--@var: string | description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string | cfgFile | Archivo de configuracion de la tool.
			
		opened = false,															--@var: boolean | opened | Indica si la herramienta está abierta.
		
		minWidth = 218,															--@var: integer | minWidth | Ancho mínimo de la herramienta.
		minHeight = 135,														--@var: integer | minHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		cacheFile = undefined,
		strAssetMapping = strAssetMappingDef,									--@var: struct | strAssetMapping | Struct de asset mapping para gestion interna de la tool

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollLightImpExp = rollLightImpExpDef,									--@var: rollout | rollLightImpExp | Almacena el rollout Lighting Import/Export
		rollLightContrainer = rollLightContrainerDef,
		rollCacheLoader = rollCacheLoaderDef,									--@var: rollout | rollCacheLoader | Almacena el rollout CacheLoader
		rollAssetMapping = rollAssetMappingDef,									--@var: rollout | rollAssetMapping | Almacena el rollout AssetMapping
		rollMain = undefined,
		rollSetLockUnlock = rollSetLockUnlockDef,								--@var: rollout | rollSetLockUnlock | Almacena el rollout Set Lock/Unlock
		subRollouts = #(this.rollLightImpExp, this.rollLightContrainer, this.rollCacheLoader), 			--@var: array | subRollouts | Almacena los rolllouts flotantes. #(rolloutVariables...)

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

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | removeLPMsceneData | elimina toda la información generada por el LPM en la escena. Básicamente borra todos los nodos LPM y la capa zz-LPM
		-----------------------------------------------------------------------------------------------------
		fn removeLPMsceneData =
		(
			--	eliminamos todos los objetos de LPM
			delete (getLPMobjects())
				
			--	eliminamos el layer de LPM
			(layerManager.getLayer 0).current = true
			layerManager.deleteLayerByName "zz-LPM"
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | exportLightingFile | Proceso de exportación de información de LPM. Es un simple fichero .MAX pero con extensión .lgt. Guarda los nodos de LPM y las luces de la escena añadiéndoles la información auxiliar necesaria para restaurar los nodos a los que afecta cada pase y los includes/excludes de luces.
		--@gets: string | filename | Ruta al fichero que hay que exportar
		-----------------------------------------------------------------------------------------------------
		fn exportLightingFile filename =
		(
			LPM_objs = getLPMobjects()
			sceneLights = lb.lights.getSceneLights()
			
			objsToSave = LPM_objs + sceneLights
			
			--	Generamos en los nodos de LPM la información auxiliar que se necesita para poder
			--	restaurarla en la importación.
			for o in LPM_objs do lb.cache.addLPMauxData o
			for l in sceneLights do lb.cache.addLightauxData l
			
			saveNodes objsToSave filename
			
			-- Al añadir LPMauxData a un nodo se elimina su información real de los nodos a los 
			--	que afecta. La restaruamos y finalmente eliminamos la información auxiliar.
			for o in LPM_objs do lb.cache.restoreLPMnodes o
			for o in LPM_objs do lb.cache.removeLPMauxData o
			for l in sceneLights do lb.cache.removeLightauxData l
		),	

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | importLightingFile | Importa los datos de iluminación almacenados en FILENAME. Trae todas las luces del fichero y la configuración de LPM, y reasigna a los objetos del fichero actual los includes de luces y los pases de LPM
		--@gets: string | filename | Ruta al fichero que hay que importar
		--@gets: (opt)boolean | importLights | Booleano de control para indicar si hay que importar luces o no (Default true)
		--@gets: (opt)boolean | importLPMdata | Booleano de control para indicar si hay que importar los datos del LPM (Default true)
		-----------------------------------------------------------------------------------------------------
		fn importLightingFile filename importLights:true importLPMdata:true =
		(
			--	eliminamos de la escena toda la información de LMP todas las luces
			if importLPMdata then removeLPMsceneData()
			if importLights then delete (lb.lights.getSceneLights())
			
			-- 	importamos los nodos de LMP del fichero especificado. 
			--	El fichero LPM es simplemente un fichero .max con extensión .lgt
			mergeMaxFile filename #select #skipDups #useSceneMtlDups #neverReparent
			
			--	Como se pierden los nodos a los que afecta cada objectSet los restauramos con la 
			--	información extra que se guardó en los nodos de LPM al hacer la exportación.
			LPM_objs = getLPMobjects()
			sceneLights = lb.lights.getSceneLights()
			
			for o in LPM_objs do lb.cache.restoreLPMnodes o
			for l in sceneLights do lb.cache.restoreLightIncludeExcludeList o
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute this.cfgFile ("tool/rollMain/pos") "x" (this.rollMain.pos.x as string)
			lb.xml.setAttribute this.cfgFile ("tool/rollMain/pos") "y" (this.rollMain.pos.y as string)
			
			--almacena tamaño
			lb.xml.setAttribute this.cfgFile ("tool/rollMain/size") "width" (this.rollMain.size.x as string)
			lb.xml.setAttribute this.cfgFile ("tool/rollMain/size") "height" (this.rollMain.size.y as string)
		),
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute this.cfgFile ("tool/rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute this.cfgFile ("tool/rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute this.cfgFile ("tool/rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute this.cfgFile ("tool/rollMain/pos") "y") as integer
				
			--establece minimos
			if _width < this.minWidth then _width = this.minWidth
			if _height < this.minHeight then _height = this.minHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			this.rollMain.size.x = _width
			this.rollMain.size.y = _height
			this.rollMain.pos = [_posX,_posY]
		),

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
		--@fn: undefined | addSubRollouts | Añade los subRollouts flotantes de la herramienta.
		------------------------------------------------
		fn addSubRollouts =
		(
			if this.rollMain != undefined then
				for _sbr in this.subRollouts do
					addRollout _sbr this.rollMain --border:false
		),

		------------------------------------------------
		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
		------------------------------------------------
		fn createInterface =
		(
			--crea el interface, lo redimensiona y lo reposiciona
			--createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
			this.rollMain = newRolloutFloater "Lighting Manager Mini"  218 135 -10000 0
			this.loadSettings()
			this.addSubRollouts()
		),
		
		------------------------------------------------
		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
		------------------------------------------------
		fn destroyInterface =
		(
			if this.rollMain != undefined then
			(
				this.saveSettings()
				closeRolloutFloater this.rollMain --cierra la herramienta.
			)
		),
		
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
		
	)--tl_lightingManagerMini
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_lightingManagerMini() --crea la herramienta
)