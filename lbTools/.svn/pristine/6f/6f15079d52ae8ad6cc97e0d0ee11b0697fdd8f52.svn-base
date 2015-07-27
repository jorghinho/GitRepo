------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta dynConnect.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta dynConnectManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Dyn Connect Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 1030		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 510		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local lvRedBackColor = (dotNetClass "System.Drawing.Color").fromargb 255 102 102	-- color fondo Rojo
		local lvGreenBackColor = (dotNetClass "System.Drawing.Color").fromargb 102 255 102	-- color fondo verde
		local lvOrangeColor = (dotNetClass "System.Drawing.Color").fromargb 255 124 7	-- color fondo naranja
		local _originalListValues = #() --Valores originales de la array en modo Edit 


		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		--pickbutton pckObject "Pick Object" pos:[10,450] width:90 height:25

		label lblTypes "Types: " pos:[10,465] width:35 height:35 enabled:true

		dropdownList ddlTypes "" pos:[45,462] width:145 height:20 items:#("link", "binding", "pointconstraint", "linkconstraint", "positionconstraint", "orientationconstraint")
		checkbox ckbConnect "Connect On Load" pos:[200,450] width:100 height:20 
		checkbox ckbKeepOffset "Keep Initial Offset" pos:[200,478] width:120 height:20 

		pickbutton pckTarget "Pick Target" pos:[320,460] width:90 height:25
		button btnAddSelected "Add Selected Alternate Nodes" pos:[430,450] width:180 height:25
		button btnDeleteSelected "Delete Selected Alternate Nodes" pos:[430,480] width:180 height:25

		groupBox grpDynInfo "Dyn Info" pos:[10,10] width:1010 height:190
		dotNetControl lvDynInfo "System.Windows.Forms.listView" pos:[15,30] width:1000 height:160

		groupBox grpDynEdit "Dyn Edit" pos:[10,210] width:1010 height:190
		dotNetControl lvDynEdit "System.Windows.Forms.listView" pos:[15,230] width:1000 height:160

		checkbutton ckbtnEditMode "Edit MODE" pos:[10,410] width:1010 height:25

		button btnAddDynConnect "Add Dyn!" pos:[630,450] width:80 height:25
		button btnRemoveDynConnect "Remove Dyn!" pos:[630,480] width:80 height:25

		button btnConnect "Connect!" pos:[730,450] width:80 height:25
		button btnDisConnect "Disconnect!" pos:[730,480] width:80 height:25

		button btnSave "Save" pos:[830,450] width:90 height:25
		button btnLoad "Load" pos:[930,450] width:90 height:25
		button btnUnlinkAndAdd "Unlink and add Dync" pos:[830,480] width:190 height:25

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

		fn alternateTextPatch _sAlternateNodes =
		(
			_thirdAlternateNodes = #()
			_secondAlternateNodes = filterString _sAlternateNodes ":@$ " 
			_indexesToFind=2

			for i=0 to _secondAlternateNodes.count do
			(
				if i == _indexesToFind then
				(
					append _thirdAlternateNodes _secondAlternateNodes[i]
					_indexesToFind=_indexesToFind+3
				)
			)
			_thirdAlternateNodes = (lb.str.join _thirdAlternateNodes ",")
			return _thirdAlternateNodes
		)


		fn initDynInfoListView =
		(
			lv = lvDynInfo
			lv.columns.clear()
			lv.multiSelect = true
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			--lv.backColor = colorBackUnselected
			--lv.foreColor = colorFore
			lv.scrollable = true
			lv.labelEdit = false
			lv.hideselection = false

			lv.columns.add "Object" 300
			lv.columns.add "Type" 150
			lv.columns.add "Target" 250
			lv.columns.add "Alternate Targets" 300

			lv.Columns.item[0].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center
			lv.Columns.item[1].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center
			lv.Columns.item[2].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center
			lv.Columns.item[3].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		fn initDynEditListView =
		(
			lv = lvDynEdit
			lv.columns.clear()
			lv.multiSelect = true
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			--lv.fullRowSelect = true
			--lv.backColor = colorBackUnselected
			--lv.foreColor = colorFore
			lv.scrollable = true
			lv.labelEdit = false
			lv.hideselection = false

			lv.columns.add "Object" 300
			lv.columns.add "Type" 150
			lv.columns.add "Target" 250
			lv.columns.add "Alternate Targets" 300

			lv.Columns.item[0].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center
			lv.Columns.item[1].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center
			lv.Columns.item[2].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center
			lv.Columns.item[3].textAlign = (dotnetclass "System.Windows.Forms.HorizontalAlignment").center

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable

		)
		
		fn fillDynInfoListView  = 
		(
			if ckbtnEditMode.state == false then
			(
				lvDynInfo.items.clear()
				
				_objectsWithDyn = #()

				_objectsToWork = getCurrentSelection() as array

				for o in _objectsToWork where lb.dynConnect.hasDynConnectInfo o == true do 
				(					
					appendIfUnique _objectsWithDyn o.name
				)--for

				for i=1 to _objectsToWork.count do
				(
					lvDynInfo.items.add (_objectsToWork[i].name)
					if lb.dynConnect.hasDynConnectInfo _objectsToWork[i] then
					(
						lvDynInfo.items.item[i-1].SubItems.add (lb.str.join _objectsToWork[i].dynConnectInfo.types ",")
						lvDynInfo.items.item[i-1].SubItems.add (lb.str.join _objectsToWork[i].dynConnectInfo.targetNodesNames ",")
						_lAlternateNodes = for _a in _objectsToWork[i].dynConnectInfo.getAlternateTargetNodes() collect (for _n in _a collect _n as string)
						_sAlternateNodes = (lb.str.join (lb.str.join _lAlternateNodes "/") ",")
						_thirdAlternateNodes = alternateTextPatch (_sAlternateNodes)
						lvDynInfo.items.item[i-1].SubItems.add _thirdAlternateNodes
					)
				)--for
			)--if
		)

		fn fillDynEditListView _originalListValues=
		(

			lvDynEdit.items.clear()
			_nodeSelection = #()
			
			if lvDynInfo.selectedItems.count != 0 then
			(
				for i=0 to lvDynInfo.selectedItems.count-1 do
						appendIfUnique _nodeSelection lvDynInfo.selectedItems.item[i].text
			)
		
			for i=1 to _nodeSelection.count do
			(
				lvDynEdit.items.add (_nodeSelection[i])

				_nod = getNodeByName _nodeSelection[i]
				if lb.dynConnect.hasDynConnectInfo _nod == true then
				(
					lvDynEdit.items.item[i-1].SubItems.add (lb.str.join _nod.dynConnectInfo.types ",")
					lvDynEdit.items.item[i-1].SubItems.add (lb.str.join _nod.dynConnectInfo.targetNodesNames ",")
					_lAlternateNodes = for _a in _nod.dynConnectInfo.getAlternateTargetNodes() collect (for _n in _a collect _n as string)
					_sAlternateNodes = (lb.str.join (lb.str.join _lAlternateNodes "/") ",")
					_thirdAlternateNodes = alternateTextPatch (_sAlternateNodes)
					lvDynEdit.items.item[i-1].SubItems.add _thirdAlternateNodes
				)
				else
				(

					lvDynEdit.items.item[i-1].subitems.add ("Undefined")
					lvDynEdit.items.item[i-1].subitems.add ("None")
					lvDynEdit.items.item[i-1].subitems.add ("None")
				)	

			)--for
			for i = 0 to lvDynEdit.items.count-1 do
			(
				_listRowElement = #()
				for j=0 to 3 do 
				(
					append _listRowElement lvDynEdit.items.item[i].subitems.item[j].text
				)
				append _originalListValues _listRowElement
			)--for
			
		)
		
		fn updateEditListView itemColumn itemRow content =
		(
			if lvDynInfo.selectedItems.count >= 1 then 
			(
				lvDynEdit.items.item[itemColumn].subitems.item[itemRow].text = content

				--Si modificamos el valor pero es igual al original ->naranja , si modificamos y es distinto al original ->rojo 
				if (_originalListValues[itemColumn+1][itemRow+1] == content) then
				(
					lvDynEdit.items.item[itemColumn].subitems.item[0].BackColor = lvOrangeColor	
				)
				else 
				(
					lvDynEdit.items.item[itemColumn].subitems.item[0].BackColor = lvRedBackColor	
				)
			)
			else
			(
				lb.message.show "Select at least 1 dynnConnect for edit."
			)
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
			callbacks.addscript #selectionSetChanged "lb.dynConnectManager.rollMain.fillDynInfoListView()" id:_id
			callbacks.addscript #filePostOpenProcess "lb.dynConnectManager.rollMain.fillDynInfoListView()" id:_id
			callbacks.addscript #filePostMerge "lb.dynConnectManager.rollMain.fillDynInfoListView()" id:_id		
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
			-----------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(

				lvDynInfo.width = 1000 + _increment.x
				lvDynEdit.width = 1000 + _increment.x
				grpDynInfo.width = 1010 + _increment.x
				grpDynEdit.width = 1010 + _increment.x
				--pckObject.pos.x = 10 + (_increment.x/2)
				lblTypes.pos.x = 10 + (_increment.x/2)
				ddlTypes.pos.x = 45 + (_increment.x/2)
				ckbConnect.pos.x = 200 + (_increment.x/2)
				ckbKeepOffset.pos.x = 200 + (_increment.x/2)
				pckTarget.pos.x = 320 + (_increment.x/2)
				btnAddSelected.pos.x = 430 + (_increment.x/2)
				ckbtnEditMode.pos.x = 10 + (_increment.x/2)
				btnAddDynConnect.pos.x = 630 + (_increment.x/2)
				btnRemoveDynConnect.pos.x = 630 + (_increment.x/2)
				btnConnect.pos.x = 730 + (_increment.x/2)
				btnDisConnect.pos.x = 730 + (_increment.x/2)
				btnSave.pos.x = 830 + (_increment.x/2)
				btnLoad.pos.x = 930 + (_increment.x/2)
				btnUnlinkAndAdd.pos.x = 830 + (_increment.x/2)
				btnDeleteSelected.pos.x =  430 + (_increment.x/2)
				lvDynInfo.Columns.Item[3].width = 300 + _increment.x
				lvDynEdit.Columns.Item[3].width = 300 + _increment.x

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
			if _height < minRollHeight then _height = minRollHeighte

			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]
		)
		------------------------------------------------
		--@fn: undefined | unlinkAndAddDyn | Consulta el linkaje de una pieza y crea un dynConnect 
		------------------------------------------------
		fn unlinkAndAddDyn =
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
			fillDynInfoListView()
		)

		------------------------------------------------
		--@fn: undefined | loadDyn | Carga los dynConnect de las piezas seleccionadas
		------------------------------------------------
		fn loadDyn =
		(
			_selObj = selection[1]
			
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
				
				_initialDir = substituteString maxFilePath "version\\base\\" ""
				_initialDir = _initialDir + "rig\\dynConnect"
				
				if _initialDir == undefined then _initialDir = maxFilePath
				
				_folder = getSavePath caption:"Load multiple DynConnect files" initialDir:_initialDir
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
		--@fn: undefined | saveDyn | Salva el dynConnect en las piezas seleccionadas.
		------------------------------------------------
		fn saveDyn =
		(
			-- Si hay un solo objeto seleccionado pedimos ruta y nombre de fichero. Si no solo ruta
			if selection.count == 1 then
			(
				_selObj = selection[1]
				
				-- Buscamos SpaceWarps y guardamos la info
				_FFDbinding = #()

				for i = 1 to _selObj.modifiers.count where (classOf _selObj.modifiers[i] == FFD_Binding) do
					append _FFDbinding _selObj.modifiers[i]							
				
				if  _selObj.parent != undefined or _FFDbinding.count > 0 then 
				(
					if not (lb.dynConnect.hasDynConnectInfo _selObj) then
					(
						lb.dynConnect.addAttribute _selObj
						
						if _selObj.parent != undefined then
							lb.dynConnect.addTarget _selObj "link" _selObj.parent.name connectOnLoad:false keepInitialOffset:true

						for i = 1 to _FFDbinding.count do
							lb.dynConnect.addTarget _selObj "binding" (refs.dependsOn _FFDbinding[i])[1].name connectOnLoad:false keepInitialOffset:true									
					)	
						
					_objName = _selObj.nodeInfo.nameHistory[_selObj.nodeInfo.nameHistory.count]
					
					_file = getSaveFileName caption:"Save DynConnect file" filename:_objName types:"DynConnect Data (*.dyc)|*.dyc"
					
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
				
				_initialDir = substituteString maxFilePath "version\\base\\" ""
				_initialDir = _initialDir + "rig\\dynConnect"
				
				if _initialDir == undefined then _initialDir = maxFilePath
				
				_folder = getSavePath caption:"Save multiple DynConnect files" initialDir:_initialDir
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
		
							for i = 1 to o.modifiers.count where (classOf o.modifiers[i] == FFD_Binding) do
								append _FFDbinding obj.modifiers[i]
							
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

		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		on ckbtnEditMode changed state do
		(
			if ckbtnEditMode.state == true then
			(
				_nodeSelection = #()
				
				if lvDynInfo.selectedItems.count != 0 then
				(
					for i=0 to lvDynInfo.selectedItems.count-1 do
							appendIfUnique _nodeSelection lvDynInfo.selectedItems.item[i].text
				)
				if _nodeSelection.count != 0 then
				(
					lvDynInfo.enabled = not state
					lvDynEdit.enabled = state
				
					if state then 
					(
						_originalListValues = #()
						fillDynEditListView (_originalListValues)
					)
					else lvDynEdit.items.clear()
				)
				else 
				(
					ckbtnEditMode.state = not state
					lb.message.show "You have to select at least 1 item of DynInfo list view."
				)
			)
			else
			(
				lvDynInfo.enabled = true
				lvDynEdit.enabled = false
				lvDynEdit.items.clear()
				fillDynInfoListView()
			)
			
		)
		
		on ddlTypes selected index do 
		(
			if ckbtnEditMode.state == true then
			(
				_itemIndex = -1
				for i = 0 to lvDynEdit.selectedItems.count-1 do
				(
					_itemIndex = lvDynEdit.selectedItems.item[i].index
					if ddlTypes.items[index] != lvDynEdit.items.item[_itemIndex].subitems.item[1].text then 
					(
						updateEditListView _itemIndex 1 ddlTypes.items[index]
					)	
				)
			)
			else
			(
				lb.message.show "Enable Edit MODE to modify dynConnect settings"
			)
		)

		on pckTarget picked obj do
		(
			if ckbtnEditMode.state == true then
			(
				_itemIndex = -1
				for i = 0 to lvDynEdit.selectedItems.count-1 do
				(
					_itemIndex = lvDynEdit.selectedItems.item[i].index
					if obj.name != lvDynEdit.items.item[_itemIndex].subitems.item[0].text then 
					(
						updateEditListView _itemIndex 2 obj.name
					)	
				)
			)
			else
			(
				lb.message.show "Enable Edit MODE to modify dynConnect settings"
			)
		)

		on btnAddSelected pressed do
		(
			if ckbtnEditMode.state == true then
			(
				_itemIndex = -1
				for i = 0 to lvDynEdit.selectedItems.count-1 do
				(
					_itemIndex = lvDynEdit.selectedItems.item[i].index
					_selection = getCurrentSelection()

					_filteredSelection = #()
					--Filtramos que no se encuentre el nodo del dynConnect en la selección alternativa, así como el target para evitar dependencias ciclicas
					for obj in _selection do
					(
						if ((obj.name != lvDynEdit.items.item[_itemIndex].subitems.item[0].text) and (obj.name != lvDynEdit.items.item[_itemIndex].subitems.item[2].text)) then
						(
							appendIfUnique _filteredSelection obj.name
						)
					)--for
					if _filteredSelection.count !=0 then
					(
						stringFilteredSel = lb.str.join _filteredSelection ","
						updateEditListView _itemIndex 3 stringFilteredSel
					)
					else
					(
						lb.message.show "Make a valid Selection Exclude Self nodes, pick target or empty selections"
					)
				)--for
			)
			else
			(
				lb.message.show "Enable Edit MODE to modify dynConnect settings"
			)
		)
		
		on btnAddDynConnect pressed do
		(
			_failedAdds=0
			if ckbtnEditMode.state == true then
			(
				for i = 0 to lvDynEdit.selectedItems.count-1 do
				(
					_itemIndex = lvDynEdit.selectedItems.item[i].index
					_checkCorrectInput = true
					if lvDynEdit.items.item[_itemIndex].subitems.item[1].text == "Undefined" then
					(
						_checkCorrectInput = false
					)
					if lvDynEdit.items.item[_itemIndex].subitems.item[2].text == "None" then
					(
						_checkCorrectInput = false
					)
					if lvDynEdit.items.item[_itemIndex].subitems.item[3].text == "None" then
					(
						_objAlterNateNodesSelection=#()
					)
					else
					(
						_objAlterNateNodesStr = lvDynEdit.items.item[_itemIndex].subitems.item[3].text 
						_objAlterNateNodes = filterString _objAlterNateNodesStr ","
						_objAlterNateNodesSelection=#()
						for obj in _objAlterNateNodes do
						(
							append _objAlterNateNodesSelection (getNodeByName obj)
						)
					)
					if _checkCorrectInput == false  then
					(
						_failedAdds=_failedAdds+1
					)
					else 
					(
						_dynObj = (getNodeByName lvDynEdit.items.item[_itemIndex].subitems.item[0].text)
						lb.dynConnect.addAttribute _dynObj
						lb.dynConnect.addTarget _dynObj (lvDynEdit.items.item[i].subitems.item[1].text) lvDynEdit.items.item[i].subitems.item[2].text alternateTargetNodes:_objAlterNateNodesSelection connectOnLoad:ckbConnect.checked keepInitialOffset:ckbKeepOffset.checked

						lvDynEdit.items.item[_itemIndex].subitems.item[0].backColor=lvGreenBackColor
					)
				)--for
				lb.message.show ("Added " + (((lvDynEdit.items.count)-(_failedAdds ))as string) +" DynConnect successfully")				
			)
			else
			(
				lb.message.show "Enable Edit MODE to modify dynConnect settings"
			)
		)

		on btnDeleteSelected pressed do
		(
			if ckbtnEditMode.state == true then
			(
				_itemIndex = -1
				for i = 0 to lvDynEdit.selectedItems.count-1 do
				(
					_itemIndex = lvDynEdit.selectedItems.item[i].index
					lvDynEdit.items.item[_itemIndex].subitems.item[3].text = "None"
				)
			)
			else
			(
				lb.message.show "Enable Edit MODE to modify dynConnect settings"
			)
		) 
		on btnRemoveDynConnect pressed do 
		(
			if ckbtnEditMode.state == true then
			(
				_itemIndex = -1
				for i = 0 to lvDynEdit.selectedItems.count-1 do
				(
					_itemIndex = lvDynEdit.selectedItems.item[i].index
					lb.dynConnect.removeAttribute (getNodeByName lvDynEdit.items.item[_itemIndex].subitems.item[0].text)

				)
			)
			else
			(
				lb.message.show "Enable Edit MODE to modify dynConnect settings"
			)
		)

		on btnConnect pressed do 
		(
			if ckbtnEditMode.state == true then
			(
				_itemIndex = -1
				for i = 0 to lvDynEdit.selectedItems.count-1 do
				(
					_itemIndex = lvDynEdit.selectedItems.item[i].index
					lb.dynConnect.connect  (getNodeByName lvDynEdit.items.item[_itemIndex].subitems.item[0].text) connectionType:#all
				)
			)
			else
			(
				lb.message.show "Enable Edit MODE to modify dynConnect settings"
			)
		)

		on btnDisConnect pressed do
		(
			if ckbtnEditMode.state == true then
			(
				_itemIndex = -1
				for i = 0 to lvDynEdit.selectedItems.count-1 do
				(
					_itemIndex = lvDynEdit.selectedItems.item[i].index
					lb.dynConnect.disconnect  (getNodeByName lvDynEdit.items.item[_itemIndex].subitems.item[0].text) connectionType:#all
				)
			)
			else
			(
				lb.message.show "Enable Edit MODE to modify dynConnect settings"
			)
		)

		on btnUnlinkAndAdd pressed do
		(
			unlinkAndAddDyn()
		)

		on btnLoad pressed do
		(
			loadDyn()
		)	

		on btnSave pressed do
		(
			saveDyn()
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
			
			createSceneEvents() --crea los callbacks
			initDynInfoListView()
			initDynEditListView()
			loadSettings()
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			lvDynEdit.enabled = false
			fillDynInfoListView()
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
	--@struct: dynConnectManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_dynConnectManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Dyn Connect Manager",		--@var: description | Descripcion de la tool.
		
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
			createDialog this.rollMain lockwidth:false lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_dynConnectManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_dynConnectManager() --crea la herramienta
)