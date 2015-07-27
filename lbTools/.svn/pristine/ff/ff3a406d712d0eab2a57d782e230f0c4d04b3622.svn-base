------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Puppet Tools: Attach/Detach"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 240	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 335	--@var: minRollHeight | Minimun tool height.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local colWidths = #(197,30)		-- Ancho de las columnas del listview
		local rowHeight = 15			-- Alto de cada fila del listView

		local lvSelItems				-- objetos seleccionados en el listview
		local lvSelectedItems = #()		-- copia auxiliar que guarda temporalmente los objetos seleccionados en el listview
		local restoreSelection = false	-- indica si hay que restaurar la selección del listview

		local checkSymbol = "X"
		local uncheckSymbol = "•"

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnLoadPuppet pos:[10,295] width:30 height:30 highlightColor:(color 255 195 0) checked:false enabled:true tooltip:"Load Puppet/s to Rig from .max file" images:#(iconsPath + "miscIcons001_24i.bmp", undefined, 50,3,4,4,4,true)
		button btnSavePuppet pos:[45,295] width:30 height:30 highlightColor:(color 255 195 0) checked:false enabled:true tooltip:"Save Puppet/s from Rig to .max file" images:#(iconsPath + "miscIcons001_24i.bmp", undefined, 50,1,2,2,2,true)
		
		button btnAttachPuppet pos:[105,295] width:30 height:30 highlightColor:(color 255 195 0) checked:false enabled:true tooltip:"Attach Puppet/s to Rig" images:#(iconsPath+"geometryIcons001_24i.bmp",undefined,50,5,6,6,6,true)
		button btnDetachPuppet pos:[140,295] width:30 height:30 highlightColor:(color 255 195 0) checked:false enabled:true tooltip:"Detach Puppet/s from Rig" images:#(iconsPath+"geometryIcons001_24i.bmp",undefined,50,7,8,8,8,true)

		button btnRemovePuppet pos:[200,295] width:30 height:30 highlightColor:(color 255 195 0) checked:false enabled:true tooltip:"Delete Puppet/s from Rig" images:#((lb.config.getIconsPath())+"bip_mixer_i.bmp",undefined,20,2,2,2,2,true)
		
		checkBox chkOnlySelection "Scene Selection" pos:[5,5]
		checkBox chkRenameNoIndex "Rename Without Index" pos:[105,5]
		checkBox chkSelectedList "Selected in List" pos:[12,250]
		checkBox chkSceneSelection "Scene Selection" pos:[12,270]

		groupBox grpAttachDetach "Attach / Detach" pos:[5,235] width:230 height:95
		dotNetControl lvInfo "System.Windows.Forms.ListView" pos:[5,25] width:230 height:205

		local rMenu = dotnetObject "System.Windows.Forms.ContextMenuStrip" --@control: rMenu | Menu de boton derecho para el menu de renombrar.
		local rtbCaptionEditor = dotNetObject "System.Windows.Forms.richtextbox" --@control: rtbCaptionEditor | Cuadro de edicion para los nombres de los Puppets

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

		fn initInfoListView =
		(
			lv = lvInfo
			lv.columns.clear()
			lv.multiSelect = false
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = colorBackUnselected
			lv.foreColor = colorFore
			lv.scrollable = true
			lv.labelEdit = false
			lv.MultiSelect = true
			lv.hideselection = false

			lv.columns.add "Puppet" 185
			lv.columns.add "Hide" 45

			lv.Columns.item[1].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		fn fillInfoListView  = 
		(
			lvInfo.items.clear()
			_puppetNamesMod = #()
			_states = #()
			_objectsToWork = objects as array

			if chkOnlySelection.checked then _objectsToWork = getCurrentSelection() as array

			for o in _objectsToWork do 
			(		
				for i=1 to o.modifiers.count do
				(
					if (classof o.modifiers[i] == Edit_Poly) and (matchpattern o.modifiers[i].name pattern:(lb.nc.NC_puppetPattern)) then
					(									
							if appendIfUnique _puppetNamesMod o.modifiers[i].name then append _states (o.modifiers[i].enabled and o.modifiers[i].enabledInViews)
					)--if
				)--for  
			)--for

			for i=1 to _puppetNamesMod.count do
			(
				lvInfo.items.add (_puppetNamesMod[i])
				lvInfo.items.item[i-1].SubItems.add (if _states[i] then uncheckSymbol else checkSymbol)
			)--for 	

			parent.fillPuppetModifiersNames()
		)

		fn initControls = 
		(
			--añade el evento al menu
			dotnet.addEventHandler rMenu "itemClicked" rollMainDef.rMenuItemclickedEvent

			rtbCaptionEditor.readonly = false
			rtbCaptionEditor.backcolor = (dotNetClass "System.Drawing.Color").white
			rtbCaptionEditor.parent = lvInfo

			global _tempParentNamePuppetAttachDetach = parent.className
			dotnet.removeAllEventHandlers rtbCaptionEditor
			dotnet.addEventHandler rtbCaptionEditor "lostFocus" (fn lostFocusEvent self events = ((lb.getTool _tempParentNamePuppetAttachDetach).rtbCaptionEditorLostFocusEvent self events))
			dotnet.addEventHandler rtbCaptionEditor "keyUp" (fn keyUpEvent self events = ((lb.getTool _tempParentNamePuppetAttachDetach).rtbCaptionEditorKeyUpEvent self events))
				
			rtbCaptionEditor.hide()
		)

		------------------------------------------------
		--@fn: undefined | createRMenu | Rellena el menu de boton derecho en función de la opcion.
		------------------------------------------------
		fn createRMenu pos =
		(
			_rMenuItems = #() --array para almacenar los items del menu
			
			rMenu.items.clear() --vacía el menú
			rMenu.rendermode = (dotnetclass "System.Windows.Forms.ToolStripRenderMode").system --elige el modo de dibujado del menu
			
			--rellena el array de items con todas las opciones
			append _rMenuItems "Rename puppet"
			append _rMenuItems "Delete"

			--añade todos los items al menú
			for i = 1 to _rMenuItems.count do rMenu.items.add _rMenuItems[i]				
			
			rMenu.Show pos.x pos.y --muestra el menú
		)

		------------------------------------------------
		--@fn: undefined | rMenuItemclickedEvent | Utilizamos esta funcion para el rMenu.
		------------------------------------------------
		fn rMenuItemclickedEvent self events =
		(
			_itemName = (events.clickeditem.tostring())
			parent.menuItemClickedProcess _itemName
		)

		------------------------------------------------
		--@fn: undefined | detachPuppets | Funcion que utilizamos para detachar los puppets.
		------------------------------------------------
		fn detachPuppets =
		(
			_success = false
			_assets = (lb.asset.getSceneAssets())
			_puppets = #() -- Piezas de puppet detachadas que vamos a guardar.
			_puppetsNames = #() -- Nombres de los puppets a detachar
			_nodesToDetach = #() -- Piezas con modificadores de puppet
								
			if _assets.count > 0 then
			(
				------------------------------------------------------
				--recopilacion de los objetos a los que detachar el/los puppets

				_animNodes = #()
				for _ast in _assets do _animNodes += _ast.animNodesAll

				--si se pide solo los seleccionados en la escena solo se detachan esos
				_currSel = getCurrentSelection() as array
				if chkSceneSelection.checked then for i=_animNodes.count to 1 by -1 where findItem _currSel _animNodes[i] == 0 do deleteItem _animNodes i
				------------------------------------------------------

				------------------------------------------------------
				--recopila los nombres de los puppet de los objetos a los que guardarselo
				--si alguno de los objetos de los que guardar el puppet no tiene puppets lo ignora

				_selectedInList = #()
				if chkSelectedList.checked then
				(
					_selItems = lvInfo.selectedItems
					for i=1 to _selItems.count do append _selectedInList (_selItems.item[i-1].text)
				)--if

				for obj in _animNodes do
				(
					for m in obj.modifiers where (MatchPattern m.name pattern:lb.nc.NC_puppetPattern) and (classof m == Edit_Poly) do
					(
						if chkSelectedList.checked then
						(
							if findItem _selectedInList m.name != 0 then appendIfUnique _puppetsNames m.name
						)
						else appendIfUnique _puppetsNames m.name
						
						appendIfUnique _nodesToDetach obj
					)--for
				)--for
				------------------------------------------------------

				------------------------------------------------------
				--proceso de detach

				if _nodesToDetach.count != 0 and _puppetsNames.count != 0 then
				(
					-- Preguntamos por si se quiere detachar en y hacer una copia.
					_removePuppet = lb.message.show "Do you want to remove puppets from objects after to detach?" type:#yesNoCancel pos:undefined size:[300,75] modal:true
					
					------------------------------------------------------
					if _removePuppet != #cancel do
					(		
						_detachedPuppets = #() --hace el detach de los puppets necesarios de los objetos
						_removePuppet = (_removePuppet == #yes)

						--si la opcion de detachar solo los seleccionados en el listado esta activa y no hay seleccion en el listado,
						--forzamos a que busque un modificador que no existe y asi no detache nada, porque si no le pasamos nombres de puppets que detachar,
						--detacha todos los puppets del objeto
						if chkSelectedList.checked and _puppetsNames.count == 0 then _puppetsNames = #("undefinedPuppet")

						for _node in _nodesToDetach do _detachedPuppets += lb.rig.puppet.detachPuppets _node puppetNames:_puppetsNames removePuppets:_removePuppet

						select _detachedPuppets --selecciona los puppets nuevos.

						if _detachedPuppets.count != 0 then
						(
							lb.message.show "Puppets detached successfully" type:#message pos:undefined size:[300,75] modal:true
							_success = true
						)
					)
					------------------------------------------------------
				)
				else 
				(
					if _nodesToDetach.count == 0 then
						lb.message.show "No nodes to detach" type:#message pos:undefined size:[300,75] modal:true
					else if _puppetsNames.count == 0 then
					(
						if chkSelectedList.checked then	lb.message.show "No Puppets selected in list to detach" type:#message pos:undefined size:[300,75] modal:true
						else lb.message.show "No Puppets to detach" type:#message pos:undefined size:[300,75] modal:true
					)
				)--if else
				------------------------------------------------------
			)
			else
			(
				lb.message.show "There is not asset in the scene" type:#message pos:undefined size:[300,75] modal:true
			)--if else

			_success
		)

		------------------------------------------------
		--@fn: undefined | attachPuppets | Funcion que utilizamos para attachar los puppets.
		------------------------------------------------
		fn attachPuppets =
		(
			--pone el panel de modificadores
			if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode mode:#modify

			_assets = (lb.asset.getSceneAssets())
			_puppets = #() -- Piezas de puppet detachadas que vamos a atachar a los objetos que les correspondan
			_animNodes = #() --piezas de anim donde atachar los puppets

			------------------------------------------------
			--recopila los nodos de puppet de los assets para poder hacer attach

			for _ast in _assets do
			(
				_puppets += _ast.puppetNodesAll 
				_animNodes += _ast.animNodesAll
			)
			
			--si solo debe atachar los seleccionados, elimina los que no lo estén del array
			if chkSceneSelection.checked then
			(
				_currSel = getCurrentSelection()
				for i=_puppets.count to 1 by -1 where findItem _currSel _puppets[i] == 0 do deleteItem _puppets i
			)--if

			------------------------------------------------

			if _puppets.count != 0 then
			(
				if _animNodes.count != 0 then
				(
					-- Preguntamos por si se quiere eliminar el puppet si hay uno que ya se llame asi en el objeto
					_removePuppet = lb.message.show "Do you want to remove puppets from objects before to attach?" type:#yesNoCancel pos:undefined size:[300,75] modal:true
					
					if _removePuppet != #cancel do
					(
						progressStart "Attaching Puppet..."
						resumeEditing()

						_cont = 0
						_attachedCount = 0

						for _puppet in _puppets do
						(
							if (lb.rig.puppet.attachPuppet _puppet removePuppet:(_removePuppet == #yes)) then _attachedCount += 1
									
							_cont +=1
							progressUpdate ((_cont * 100)/_puppets.count)
						)--for

						progressEnd()
							
						lb.message.show ((_attachedCount as string) + " puppets attached successfully") type:#message pos:undefined size:[300,75] modal:true
					)--if
				)
				else
				(
					lb.message.show "There are no anim objects in scene to attach puppets in" type:#message pos:undefined size:[300,75] modal:true
				)--if else
			)
			else
			(
				lb.message.show "There are no puppets selected in scene" type:#message pos:undefined size:[300,75] modal:true
			)--if else
		)

		------------------------------------------------
		--@fn: undefined | deletePuppets | Elimina los puppets seleccionados en el listado
		------------------------------------------------
		fn deletePuppets =
		(
			_success = false
			_assets = (lb.asset.getSceneAssets())
			_puppets = #() -- Piezas de puppet detachadas que vamos a guardar.
			_puppetsNames = #() -- Nombres de los puppets a detachar
			_nodesToDelete = #() -- Piezas con modificadores de puppet
								
			if _assets.count > 0 then
			(
				------------------------------------------------------
				--recopilacion de los objetos a los que eliminar el/los puppets

				_animNodes = #()
				for _ast in _assets do _animNodes += _ast.animNodesAll

				--si se pide solo los seleccionados en la escena solo se eliminan en esos
				_currSel = getCurrentSelection() as array
				if chkSceneSelection.checked then for i=_animNodes.count to 1 by -1 where findItem _currSel _animNodes[i] == 0 do deleteItem _animNodes i
				------------------------------------------------------

				------------------------------------------------------
				--recopila los nombres de los puppet de los objetos a los que guardarselo
				--si alguno de los objetos de los que guardar el puppet no tiene puppets lo ignora

				_selectedInList = #()
				if chkSelectedList.checked then
				(
					_selItems = lvInfo.selectedItems
					for i=1 to _selItems.count do append _selectedInList (_selItems.item[i-1].text)
				)--if

				for obj in _animNodes do
				(
					for m in obj.modifiers where (MatchPattern m.name pattern:lb.nc.NC_puppetPattern) and (classof m == Edit_Poly) do
					(
						if chkSelectedList.checked then
						(
							if findItem _selectedInList m.name != 0 then appendIfUnique _puppetsNames m.name
						)
						else appendIfUnique _puppetsNames m.name
						
						appendIfUnique _nodesToDelete obj
					)--for
				)--for
				------------------------------------------------------

				------------------------------------------------------
				--proceso de eliminacion
				if _nodesToDelete.count != 0 and _puppetsNames.count != 0 then
				(
					--elimina los puppets 
					for obj in _nodesToDelete do lb.rig.puppet.deletePuppets obj puppetNames:_puppetsNames
					fillInfoListView()
				)
				else 
				(
					if _nodesToDelete.count == 0 then
						lb.message.show "No nodes to delete" type:#message pos:undefined size:[300,75] modal:true
					else if _puppetsNames.count == 0 then
					(
						if chkSelectedList.checked then	lb.message.show "No Puppets selected in list to delete" type:#message pos:undefined size:[300,75] modal:true
						else lb.message.show "No Puppets to delete" type:#message pos:undefined size:[300,75] modal:true
					)
				)--if else
				------------------------------------------------------
			)
			else
			(
				lb.message.show "There is not asset in the scene" type:#message pos:undefined size:[300,75] modal:true
			)--if else

			_success
			
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(	
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.addscript #selectionSetChanged "lb.puppetAttachDetach.rollMain.fillInfoListView()" id:_id
			callbacks.addscript #filePostOpenProcess "lb.puppetAttachDetach.rollMain.fillInfoListView()" id:_id
			callbacks.addscript #filePostMerge "lb.puppetAttachDetach.rollMain.fillInfoListView()" id:_id
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

			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "onlySelectionState" (chkOnlySelection.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "sceneSelectionState" (chkSceneSelection.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "selectedListState" (chkSelectedList.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "renameNoIndex" (chkRenameNoIndex.checked as string)
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

			chkOnlySelection.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "onlySelectionState") == "true" 
			chkSceneSelection.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "sceneSelectionState") == "true"
			chkSelectedList.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "selectedListState") == "true"
			chkRenameNoIndex.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "renameNoIndex") == "true" 

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
		--@event: pressed | atacha el puppet al rig de animacion
		------------------------------------------------
		on btnAttachPuppet pressed do
		(
			attachPuppets()
			fillInfoListView()
		)

		------------------------------------------------
		--@event: pressed | detacha los puppets del rig de animacion
		------------------------------------------------		
		on btnDetachPuppet pressed do
		(
			detachPuppets()
			fillInfoListView()
		)

		------------------------------------------------
		--@event: pressed | guarga una copia de los puppets en un archivo a parte
		------------------------------------------------		
		on btnSavePuppet pressed do
		(	
			_saveRequired = getSaveRequired()
			_saved = true
			_originalPathNameFile = maxfilepath + maxfilename

			--mirar si el archivo esta guardado, tener una variable _saved o algo asi
			if _saveRequired then 
			(
				--si no lo esta preguntar si se quiere guardar
				--si se decide no guardar se pone _saved a false
				--si se decide guardar se guarda y se pone _saved a true
				_process = lb.message.show "File has changes, it must be saved to continue saving puppets. Do you want to save it now?" type:#query--si hay cambios en el archivo que no ha sido guardados aun, pide que salves
				if _process then 
				(
					_saved = true	
					saveMaxFile _originalPathNameFile
				) 
				else _saved = false
			)

			
			if _saved then
			(
				_detachedOK = detachPuppets()

				if _detachedOK then
				(
					_originalAssets = lb.asset.getSceneAssets()
					_puppets = #()
					_objectsToDelete = #()

					--recorrer los assets y guardar todos los puppets de todos en un array
					for _ast in _originalAssets do _puppets += _ast.puppetNodesAll

					for obj in objects do
					(
						if findItem _puppets obj == 0 then append _objectsToDelete obj 
					)

					--borrar todos los objetos de la escena que no esten en ese array de puppets
					delete _objectsToDelete
					
					--obtener los assets de nuevo porque han cambiado
					_assets = lb.asset.getSceneAssets()

					_path = maxfilepath

					_pathParts = FilterString _path "\\"

					_path = substituteString _path _pathParts[_pathParts.count - 1] lb.nc.NC_rigFolderName
					_path = substituteString _path _pathParts[_pathParts.count] lb.nc.NC_puppetFileName

					_maxName = maxfilename
					_maxNameParts = FilterString _maxName "_."

					_success = true 
					for i=1 to _assets.count where _success do
					(
						_maxName = _assets[i].fullName + "_" + lb.nc.NC_puppetFileName + "_" + _maxNameParts[_maxNameParts.count - 1] + ".max"
					
						_filePathName = _path + _maxName

						_saveFileName = getSaveFileName caption:"Saving Puppet" filename:_filePathName historyCategory:"Puppet"
						if _saveFileName != undefined then
						(
							_puppetNodes = _assets[i].puppetNodesAll
							_saveNodes = saveNodes _puppetNodes _saveFileName quiet:true
						)
						else _success = false
					)

					--tanto si todo ha ido bien como si no, volver a cargar el archivo original
					loadMaxFile _originalPathNameFile useFileUnits:true quiet:true

					fillInfoListView()

					if _success then lb.message.show "Puppets saved successfully" type:#message
					else lb.message.show "Some puppets couldn't be saved" type:#message
				)
				else lb.message.show "Puppets couldn't be detached" type:#message
			)
		)
		
		------------------------------------------------
		--@event: pressed | carga una copia de los puppets en un archivo a parte
		------------------------------------------------	
		on btnLoadPuppet pressed do
		(
			_success = true 
			_path = maxfilepath

			--solo lo hace si el archivo esta salvado, en escenas vacíos no puede.
			if _path != "" then
			(
				_pathParts = FilterString _path "\\"

				_path = substituteString _path _pathParts[_pathParts.count - 1] lb.nc.NC_rigFolderName
				_path = substituteString _path _pathParts[_pathParts.count] lb.nc.NC_puppetFileName

				_mergeFile = getOpenFileName filename:_path 

				if _mergeFile != undefined then 
				(
					_success = true 
					_merge = mergeMAXFile _mergeFile #deleteOldDups #useSceneMtlDups #alwaysReparent	
				)
				
				fillInfoListView()

				if _success then attachPuppets() else lb.message.show "Some puppets couldn't be attached" type:#message
			)--if
		)

		------------------------------------------------
		--@event: pressed | elimina los puppets solicitados
		------------------------------------------------
		on btnRemovePuppet pressed do
		(
			deletePuppets()
			fillInfoListView()
		)

		----------------------------------------------------------------------------------------------------------------
		--Evento de hacer click sobre el listview
		----------------------------------------------------------------------------------------------------------------
		on lvInfo mouseUp events do
		(
			case (events.Button.ToString()) of
			(
				"Left":
				(
					if events.location.x > lvInfo.columns.item[0].width then
					(
						_nodesToUse = objects as array
						if chkOnlySelection.checked then _nodesToUse = getCurrentSelection() as array

						suspendEditing()
						disableSceneRedraw()
						
						for i=0 to lvInfo.selectedItems.count-1 do
						(
							_modName = lvInfo.selectedItems.item[i].text
							_symbol = lvInfo.selectedItems.item[i].SubItems.item[1].text

							_state = undefined

							if _symbol == uncheckSymbol then _state = false else if _symbol == checkSymbol then _state = true
									
							for o in _nodesToUse do
							(
								max create mode
								lb.rig.puppet.showpuppets o _modName _state

								if _state then lvInfo.selectedItems.item[i].SubItems.item[1].text = uncheckSymbol else lvInfo.selectedItems.item[i].SubItems.item[1].text = checkSymbol
							)
						) 

						resumeEditing()
						enableSceneRedraw()
					)
				)
				"Right":
				(
					createRMenu mouse.screenPos --lanza el menu de boton derecho
				)
			)
		)

		----------------------------------------------------------------------------------------------------------------
		--Evento que rellena el listview segun el chkOnlySelection.
		----------------------------------------------------------------------------------------------------------------
		on chkOnlySelection changed state do
		(
			lvInfo.items.clear()
			fillInfoListView()
			chkSceneSelection.checked = state
		)

		----------------------------------------------------------------------------------------------------------------
		--Evento que rellena el listview segun el chkOnlySelection.
		----------------------------------------------------------------------------------------------------------------
		on chkSceneSelection changed state do
		(
			chkOnlySelection.checked = state
		)

		------------------------------------------------
		--@event | lvInfo KeyDown | Evento que se lanza al presionar una tecla sobre el listView.
		------------------------------------------------
		on lvInfo KeyDown events do
		(
			_key = events.keyData.tostring()
			
			case _key of 
			(
				"F2":
				(		
					if lvInfo.selectedItems.count == 1 then
					(
						parent.menuItemClickedProcess "Rename puppet"
					)--if
				)--f2
			)--case
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
			parent.initAllowChars()
			initControls()

			initInfoListView()
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			fillInfoListView()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			parent.nameEditing = false

			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_puppetAttachDetach
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Puppet Attach Detach",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		puppetNamesMod = #(),
		nameEditing = false,

		allowedChars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM-#{}1234567890", --@var : allowedNameChars | Caracteres permitidos para los nombres de puppets
		allowCharsMessage = "You can only use: letters a-z, numbers 0-9, and symbols - # {}",
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
		--@fn: undefined | fillPuppetModifiersNames | Alamacena los nombres de los puppets de la escena.
		------------------------------------------------
		fn fillPuppetModifiersNames =
		(
			this.puppetNamesMod = #()

			_objectsToWork = objects as array

			for o in _objectsToWork do 
			(		
				for i=1 to o.modifiers.count do
				(
					if (classof o.modifiers[i] == Edit_Poly) and (matchpattern o.modifiers[i].name pattern:(lb.nc.NC_puppetPattern)) then
					(									
						appendIfUnique puppetNamesMod o.modifiers[i].name 
					)--if
				)--for  
			)
		),

		------------------------------------------------
		--@fn: undefined | initAllowChars | Caracteres que se pueden usar para renombrar.
		------------------------------------------------
		fn initAllowChars =
		(
			this.allowedChars = for i=1 to this.allowedChars.count collect this.allowedChars[i] --Recolectamos todos los caracteres permitidos en un array.
		),

		------------------------------------------------
		--@fn: undefined | beginEditing | Comienza la edicion del nodo seleccionado.
		------------------------------------------------
		fn beginEditing =
		(
			this.nameEditing = true
			this.rtbCaptionEditorShow()
		),

		------------------------------------------------
		--@fn: undefined | menuItemClickedProcess | Ejecuta las acciones todos los menús de la herramienta.
		------------------------------------------------
		fn menuItemClickedProcess menuText =
		(
			case menuText of
			(
				"Rename puppet": this.beginEditing()
				"Delete": this.rollMain.deletePuppets()
			)
		),		

		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorShow | Muestra el cuadro de edicion de nombres de contenedores.
		------------------------------------------------
		fn rtbCaptionEditorShow =
		(
			--obtiene los nodos seleccionados
			_lvInfoSel = this.rollMain.lvInfo.selectedItems

			--si hay mas de un elemento seleccionado no deja renombrar
			if _lvInfoSel.count == 1 then
			(
				----averigua las propiedades de dibujado de la celda pulsada
				_rectangle = this.rollMain.lvInfo.selectedItems.item[0].Bounds

				this.rollMain.rtbCaptionEditor.location = dotnetObject "System.Drawing.Point" _rectangle.x _rectangle.y
				this.rollMain.rtbCaptionEditor.width = this.rollMain.lvInfo.width
				this.rollMain.rtbCaptionEditor.height = _rectangle.height + 1

				--abre el cuadro de edicion con el nombre original
				this.rollMain.rtbCaptionEditor.text = this.rollMain.lvInfo.selectedItems.item[0].text

				this.rollMain.rtbCaptionEditor.show()
				this.rollMain.rtbCaptionEditor.selectAll()
				setfocus this.rollMain.lvInfo
				this.rollMain.rtbCaptionEditor.focus()
			)--if
		),	

		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorLostFocusEvent | Se ejecuta cuando se pierde el foco del cuadro de edicion de nombres.
		------------------------------------------------
		fn rtbCaptionEditorLostFocusEvent self events =
		(
			this.rtbCaptionEditorchangesApply()
		),
		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorKeyUpEvent | Cada vez que se pulsa una tecla en el cuadro de edicion de nombres.
		------------------------------------------------
		fn rtbCaptionEditorKeyUpEvent self events =
		(
			events.handled = true --para evitar perder el control del foco con teclas especiales como Alt y que lo coja el treeview
			
			key = events.keydata.tostring()
			case key of
			(
				"Return":
				(
					this.rtbCaptionEditorChangesApply()
				)
				
				"Escape":
				(
					this.nameEditing = false
					this.rollMain.rtbCaptionEditor.hide()
					setfocus this.rollMain.lvInfo
				)

				default:
				(	
					_newText = this.rollMain.rtbCaptionEditor.text --obtiene el nuevo nombre que aplicar
					_process = true
					_forbiddenChar = ""
					_cursorIndex = 0
					
					_posGen = getDialogPos this.rollMain
					_posX = _posGen.x+10  
					_posY = _posGen.y*1.5 

					--Si el caracter introducido no esta en nuestro array de _allowedChars hacemos saltar un mensaje.
					for i=1 to _newText.count where _process and findItem this.allowedChars _newText[i] == 0 do
					(
						_process = false
						_forbiddenChar = _newText[i]
						_cursorIndex = i-1
						lb.message.show  this.allowCharsMessage pos:[_posX,_posY] size:[325,75]
					)--for

					if not _process then
					(
						_textSubsti = substituteString _newText _forbiddenChar "" --Borramos el ultimo caracter introducido en el edittext del find.
						this.rollMain.rtbCaptionEditor.text = _textSubsti --Substituimos la nueva palabra sin el ultimo valor en el editFind.

						this.rollMain.rtbCaptionEditor.SelectionStart = _cursorIndex
					)--if
				)
			)
		),	

		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorChangesApply | Aplica el cambio de nombre a la seleccion.
		------------------------------------------------
		fn rtbCaptionEditorChangesApply =
		(
			--solo si estaba en modo edicion lo aplica
			if this.nameEditing then
			(
				this.nameEditing = false
				
				_process = true
				_newCaption = this.rollMain.rtbCaptionEditor.text --obtiene el nuevo nombre que aplicar
				
				for i=1 to _newCaption.count where _process and findItem this.allowedChars (tolower _newCaption[i]) == 0 do 
				(
					_posGen = getDialogPos this.rollMain
					_posX = _posGen.x+10  
					_posY = _posGen.y*1.5 

					_process = false
					lb.message.show  this.allowCharsMessage pos:[_posX,_posY] size:[325,75]
				)

				if _process then
				(
					_lvInfoSel = this.rollMain.lvInfo.selectedItems --obtiene los nodos seleccionados
					_oldName = this.rollMain.lvInfo.selectedItems.item[0].text --nombre original
					
					if (_newCaption != "") and (_newCaption != _oldName) then
					(	
						--averigua que puppet se debe renombrar
						_index = _lvInfoSel.item[0].index + 1

						--si cumple todos los requisitos para ser renombrado
						if _process then
						(
							_capIndex = 0
							_newCaptionParts = FilterString _newCaption "#"

							for j=1 to this.puppetNamesMod.count do
							(										
								_puppetParts = FilterString this.puppetNamesMod[j] "#"
								if ((toLower _newCaptionParts[1]) == (toLower _puppetParts[1])) do
								(
									if _puppetParts.count == 1 then _capIndex += 1
									else if ((_puppetParts[2] as integer) >= _capIndex) then _capIndex = (_puppetParts[2] as integer) + 1
								)--if
							)--for

							if _capIndex > 0 and not this.rollMain.chkRenameNoIndex.checked then
								_newCaption = _newCaptionParts[1] + "#" + (formattedprint _capIndex format:"03d")

							this.puppetNamesMod[_index] = _newCaption 

							_objectsToWork = objects as array

							if this.rollMain.chkOnlySelection.checked then _objectsToWork = getCurrentSelection() as array

							for o in _objectsToWork do 
							(		
								for i=1 to o.modifiers.count do
								(
									if (this.rollMain.lvInfo.selectedItems.item[0].text == o.modifiers[i].name) then
									(									
										o.modifiers[i].name = _newCaption 
									)--if
								)--for  
							)							

							this.rollMain.lvInfo.selectedItems.item[0].text = _newCaption

							if _capIndex > 0 and this.rollMain.chkRenameNoIndex.checked then this.rollMain.fillInfoListView()
						)
					)--if
				)--if

				--oculta el editor  devuelve el foco al arbol
				this.rollMain.rtbCaptionEditor.hide()
				setfocus this.rollMain.lvInfo
			)--if
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
		
	)--tl_puppetAttachDetach
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_puppetAttachDetach() --crea la herramienta
)