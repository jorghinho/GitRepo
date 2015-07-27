------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Renamer.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta Renamer.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Renamer"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 570		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 400		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local mode = ""	--modos de trabajo del editor. 
						--mode = "NC"   Interactua con el editor de Naming Convention
						--mode = "General"   Renamer básico
		
		local listNames = #() --objetos listados. Array de objData
		
		local bitmapsFolder = "" --Carpeta de texturas de los assets
		
		local allBitmaps = #() --todos los bitmaps de los assets
		local allBitmapsNames = #() --todos los nombres simples de los bitmaps
		local allBitmapsRenamable = #() --array de flags que indican si los  bitmaps son renombrables o no
		local allBitmapsReadOnly = #() --array de flags para saber si un bitmaps es solo read only
			
		local lastState = 1 --ultimo estado del rdoSource
		
		struct objData
		(
			name,					--nombre
			index,					--indice
			renamable = true,		--indica si se puede o no renombrarlo
			
			--si es un bitmap
			originalPath = "",		--almacena el path original del bitmap
			originalName = "",		--almacena el nombre corto original del path
			modified = false		--indica se esta en estado original o ha sido modificado
		)							-- datos de los objetos listados
		
		local graphicFormats = #("tga", "yuv", "ifl", "bmp", "jpg", "jpeg", "avi", "rla", "rpf", "mpg", "gif", "tif", "tiff", "eps", "psd", "hdr", "dds", "exr", "cmb", "sgi", "cin", "png", "rgb") --formatos graficos
		
		local colorModified = (dotNetClass "System.Drawing.Color").yellow
		local colorNotRenamable = (dotNetClass "System.Drawing.Color").red
		local colorBackSelected = (dotNetClass "System.Drawing.Color").midnightblue
		local colorBackUnselected = (dotNetClass "System.Drawing.Color").white
		local colorFore = (dotNetClass "System.Drawing.Color").black
		
		local lastSize = [0,0] --ultimo tamaño del rollout
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpSource "Source" pos:[5,5] width:95 height:75	
		radioButtons rdoSource "" pos:[30,18] width:65 height:48 labels:#("Objects", "Layers", "Materials", "Bitmaps") columns:1
		button btnNChelp "?" pos:[10,20] width:15 height:55 tooltip:"Show Naming Convention Info"
		
		groupBox grpParts "" pos:[105,5] width:460 height:75
		
		label lblPrefix "Prefix" pos:[115,15] width:35 height:15
		edittext edtPrefix "" pos:[110,30] width:140 height:17
		
		label lblBase "Base" pos:[250,15] width:35 height:15
		edittext edtBase "" pos:[250,30] width:170 height:17
		
		label lblSuffix "Suffix" pos:[420,15] width:35 height:15
		edittext edtSuffix "" pos:[420,30] width:140 height:17
		
		label lblRemoveFirst "Remove first" pos:[115,55] width:65 height:15
		spinner spnRemoveFirst "" pos:[180,55] width:40 height:16 type:#integer
		label lblChars1 "chars." pos:[225,55] width:30 height:15
		
		label lblRemoveLast "Remove last" pos:[425,55] width:60 height:15
		spinner spnRemoveLast "" pos:[485,55] width:40 height:16 type:#integer
		label lblChars2 "chars." pos:[530,55] width:30 height:15
		
		groupBox grpReplace "Replace" pos:[5,85] width:320 height:57
		label lblFindWhat "Find what" pos:[30,102] width:50 height:15
		label lblReplaceWith "Replace with" pos:[15,121] width:65 height:15
		edittext edtFindWhat "" pos:[80,100] width:160 height:17
		edittext edtReplaceWith "" pos:[80,120] width:160 height:17
		checkbox chkMatchCase "Match case" pos:[245,102] width:75 height:15
				
		groupBox grpNumbered "" pos:[335,85] width:105 height:57
		checkbox chkNumbered "Numbered" pos:[343,82] width:70 height:20
		spinner spnStart "Start" pos:[360,102] width:70 height:16 enabled:false range:[-100000,100000,0] type:#integer
		spinner spnStep "Step" pos:[360,121] width:70 height:16 enabled:false range:[-100000,100000,1] type:#integer 
		
		button btnApply "Apply" pos:[450,92] width:115 height:25
		button btnRevert "Revert" pos:[450,117] width:115 height:25

		button btnSelectAll "All" pos:[5,145] width:20 height:20 tooltip:"select all" images:#(iconsPath + "displayIcons001_24i.bmp", undefined, 50, 1, 1, 1, 1, false)
		button btnSelectNone "None" pos:[25,145] width:20 height:20 tooltip:"select none" images:#(iconsPath + "displayIcons001_24i.bmp", undefined, 50, 2, 2, 2, 2, false)
		button btnSelectInvert "Invert" pos:[45,145] width:20 height:20 tooltip:"invert selection" images:#(iconsPath + "displayIcons001_24i.bmp", undefined, 50, 3, 3, 3, 3, false)

		button btnSelect "Select" pos:[70,145] width:40 height:20
		
		checkbox chkSelected "Selected" pos:[120,145] width:66 height:15 checked:true
		checkbox chkVisible "Visible" pos:[190,145] width:54 height:15 checked:true
		checkbox chkNcOkFail "Only ncOK fail" pos:[245,145] width:95 height:15 checked:false

		button btnRefresh "Refresh" pos:[510,145] width:55 height:20

		dotNetControl lvBefore "System.Windows.Forms.ListView" pos:[5,165] width:560 height:205

		colorpicker clrLeyendNotRenamable "" color:(color 255 0 0) pos:[85,375] height:15 fieldWidth:15 enabled:false
		label lblLeyendNotRenamable "not renamable (reference lost, external folder, invalid nodeInfo...)" pos:[107,375]
		colorpicker clrLeyendModified "" color:(color 255 255 0) pos:[5,375] height:15 fieldWidth:15 enabled:false
		label lblLeyendModified "read only" pos:[27,375]
			
		button btnOk "Ok" pos:[455,375] width:55 height:20
		button btnCancel "Cancel" pos:[510,375] width:55 height:20
		
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
		--@fn: undefined | findText | Busca un cadena de caracteres str en el texto txt y devuelve un array con las coincidencias
		------------------------------------------------
		fn findText txt str cutLength:0 matchCase:false =
		(
			_pos = #()
			_p = findstring txt str 
			if _p != undefined then 
			(
				n = _p + str.count
				anotar = true
				if matchCase and (substring txt _p str.count) != str then anotar = false
				if anotar then append _pos (_p + cutLength)
						
				join _pos (findText (substring txt n txt.count) str cutLength:(cutLength + n - 1) matchCase:matchCase)
			)
			return _pos
		)

		------------------------------------------------
		--@fn: undefined | replaceText | Reemplaza la str en el texto txt por strnew
		------------------------------------------------
		fn replaceText txt str strnew matchCase:false = 
		(
			_p = findText txt str matchCase:matchCase
			_inc = 0
			_newTxt = txt
			for i = 1 to _p.count do	
			(
				_newTxt = replace _newTxt (_p[i]+_inc) str.count strNew
				_inc += strNew.count - str.count
			)
			return _newTxt
		)

		------------------------------------------------
		--@fn: undefined | initListView | Inicia el listView pasado por parámetro
		------------------------------------------------
		fn initListView lv =
		(
			lv.columns.clear()
			
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = colorBackUnselected
			lv.foreColor = colorFore
			lv.scrollable = true
			lv.labelEdit = true
			
			--lv.headerStyle = none	-- sin columnas de encabezado
			
			lv.columns.add "Before" (lv.width/2)
			lv.columns.add "After" (lv.width/2)
		)

		------------------------------------------------
		--@fn: undefined | round | redondea el número N al valor entero más cercano. Devuelve un float.
		------------------------------------------------
		fn round n =
		(
			if mod n 1 >= 0.5 then ceil n else floor n
		)

		-----------------------------------------------
		--@fn: undefined | compareListNameItems | compara elementos de tipo listName
		------------------------------------------------
		fn compareListNameItems l1 l2 =
		(
			l1 = tolower l1.name
			l2 = tolower l2.name
			
			if l1 == l2 then
				0
			else
			(
				order = sort #(l1, l2)
				
				if order[1] == l1 then
					-1
				else
					1
			)
		)

		-----------------------------------------------
		--@fn: undefined | sortListNamesAlphabetical | ordena el array ListNames alfabéticamente
		------------------------------------------------
		fn sortListNamesAlphabetical list =
		(
			_listNamesTMP = #()

			for i = 1 to list.count do
			(
				encontrado = false
				j = round (_listNamesTMP.count as float / 2)
				start = 1
				end = _listNamesTMP.count
				
				if end == 0 then -- si aún no hay elementos en _listNamesTMP lo añadimos directamente
				(
					append _listNamesTMP list[i]
				)
				else
				(
					while not encontrado  do
					(
						if /*(compareListNameItems list[i] _listNamesTMP[j]) < 0 then --*/(toLower list[i].name < toLower _listNamesTMP[j].name) then
							end = j
						else
							start = j

						j = start + round ((end - start) as float / 2)
						if end - start < 2 then encontrado = true
					)
					
					if /*(compareListNameItems list[i] _listNamesTMP[start]) < 0 then--*/(toLower list[i].name < toLower _listNamesTMP[start].name) then
						insertitem list[i] _listNamesTMP start
					else 
						if /*(compareListNameItems list[i] _listNamesTMP[end]) < 0 then --*/(toLower list[i].name < toLower _listNamesTMP[end].name) then
							insertitem list[i] _listNamesTMP end
						else
							insertitem list[i] _listNamesTMP (end+1)
				)
			)

			_listNamesTMP
		)

		-----------------------------------------------
		--@fn: undefined | fillBeforeList | Rellena el listView BeforeList
		------------------------------------------------
		fn fillBeforeList = 
		(
			-- Modo con sincronización con rollNC
			if mode == "NC" then
			(
				rdoSource.enabled = false
				rdoSource.state = 1
				
				for i=1 to rollNC.lvNaming.selectedItems.count do
				(
					if (rollNc.editMode == 0) then 
						lvBefore.items.add rollNC.lvNaming.selectedItems.item[i-1].text "_"
					
					if (rollNc.editMode == 1) then
						if (lb.nc.ncOK rollNC.lvNaming.selectedItems.item[i-1].text) then
						(
							n = filterstring	rollNC.lvNaming.selectedItems.item[i-1].text "_"
							lvBefore.items.add n[2]
						)
					
					if (rollNc.editMode == 2) then
						if (lb.nc.ncOK rollNC.lvNaming.selectedItems.item[i-1].text) then
						(
							n = filterstring	rollNC.lvNaming.selectedItems.item[i-1].text "_"
							lvBefore.items.add n[5]
						)
						else
							lvBefore.items.add rollNC.lvNaming.selectedItems.item[i-1].text "_"
				)
				
				for i = 1 to lvBefore.items.count do
					append listNames (objData objects[i].name i)
			)
			
			-- Modo sin sincronización con rollNC
			if mode == "General" then 
			(
				if rdoSource.state == 1 then	-- Objects
				(
					chkSelected.enabled = true
					chkVisible.enabled = true
					btnRevert.enabled = false
					
					for i = 1 to objects.count do
					(
						add = true
						if chkSelected.checked and not objects[i].isSelected then add = false
						if chkVisible.checked and objects[i].isHidden then add = false
						if chkNcOkFail.checked and lb.nc.ncOK objects[i].name then add = false
						if add then append listNames (objData objects[i].name i)
					)
				)--1
				
				if rdoSource.state == 2 then	-- Layers
				(
					chkSelected.enabled = false
					chkVisible.enabled = false
					btnRevert.enabled = false
					
					for i = 1 to (layerManager.count - 1) do
					(
						add = true
						layer = layerManager.getLayer i
						if chkNcOkFail.checked and lb.nc.ncOK layer.name type:#layer then add = false
						if add then append listNames (objData layer.name i)
					)
				)--2
				
				if rdoSource.state == 3 then	-- Scene Materials
				(
					chkSelected.enabled = false
					chkVisible.enabled = false
					btnRevert.enabled = false
					
					sceneMats = lb.materials.getSceneMaterials includeSubmaterials:false
					
					for i = 1 to sceneMats.count do --sceneMaterials.count do
					(
						add = true
						mat = sceneMats[i]--sceneMaterials[i]
						if chkNcOkFail.checked and lb.nc.ncOK mat.name type:#material then add = false						
						if add then append listNames (objData mat.name i)
					)
				)--3
				
				if rdoSource.state == 4 then	-- Scene Bitmaps----------------------------------------------------
				(
					chkSelected.enabled = false
					chkVisible.enabled = false
					btnRevert.enabled = false
					
					setWaitCursor()
					
					if listNames.count == 0 then --si el listado esta vacio lo tiene que rellenar por primera vez
					(
						bitmapsFolder = "" --vacia la ruta del asset almacenada
						
						assets = lb.asset.getSceneAssets() --obtiene los assets de la escena
						
						--Buscamos el substring de "version" en la ruta (si no no es una ruta de asset válida)
						if maxfilepath != "" and (findstring maxfilepath "version" )!=undefined then
						(

							--_trimIndex = ((findstring maxfilepath "version" ) - 1) As Number
							bitmapsFolder = (substring maxfilepath 1 ((findstring maxfilepath "version" ) - 1)) + "texture\\"
							--Si resulta que es un archivo de draft, las texturas tendrán que estar en la carpeta draft
							if maxfilename != undefined and (findString maxfilename lb.nc.NC_draftFileName) != undefined then
								bitmapsFolder += "draft\\"
						)
						else
						(
							bitmapsFolder = ""
						)
						
						-- if objects.count != 0 then --así puedes renombrar bitmaps aunque no esten organizadas las piezas en assets
						-- (	
						-- 	stop = false
						-- 	cont = 1
								
						-- while not stop and cont <= objects.count do
						-- (
						-- 	if lb.nodeInfo.hasNodeInfo objects[cont] then
						-- (
							--bitmapsFolder = (lb.nodeInfo.getNodeAssetFolder objects[cont]) + "\\texture\\"
							--bitmapsFolder = substituteString bitmapsFolder (bitmapsFolder[1] + bitmapsFolder[2]) (toUpper (bitmapsFolder[1] + bitmapsFolder[2]))
							--bitmapsFolder = substituteString bitmapsFolder "\\\\" "\\"
						-- 			
								--stop = true	
						--  )
						-- 		
						-- 		cont += 1
						-- 	)
						-- )

						
												
							allBitmaps = #() --vaica el array
							allBitmapsNames = #() --vacia el array
							allBitmapsRenamable = #() --vacia el array
							allBitmapsReadOnly = #() --vacia el array
							
							tempBitmaps = #() --array temporal de bitmaps
							
							_stop = false
							for o in objects where not _stop do --ast.nodes do --recorre los nodos de los assets, recopila los bitmaps
							(
								_stop = if keyboard.escPressed then (queryBox "Do you really want to cancel?") else false
								
								if not _stop then
								(
									mat = o.material
									
									if classof mat == XRef_Material then
										mat = mat.getSourceMaterial true
									
									if mat != undefined then
										join tempBitmaps (lb.materials.getBitmaps mat)
									
									if o.modifiers.count != 0 then
										join tempBitmaps (lb.materials.getBitmaps o)
								)--if
							)--for
							
							if _stop then tempBitmaps = #() --lo vacía si se ha cancelado
							
							tempBitmaps = makeUniqueArray tempBitmaps
							
							for i = tempBitmaps.count to 1 by -1 where tempBitmaps[i] == undefined do
								deleteItem tempBitmaps i
							
							sort tempBitmaps --ordena los bitmaps alfabeticamente
						
							for m in tempBitmaps do --recorre los bitmaps leidos quedandose con los que interesa y rellenando el resto de informacion
							(
								add = true
								
								if chkNcOkFail.checked then
								(
									bitmapName = filterstring m "\\"
									bitmapName = bitmapName[bitmapName.count]
									bitmapName = getFilenameFile bitmapName
									
									if (lb.nc.ncOK bitmapName type:#bitmap) then add = false	
								)
								
								if add then
									append allBitmaps m
							)
							
							allBitmaps = sort allBitmaps
							
							--obtiene el nombre a mostrar de cada bitmap y rellena el struct
							for i=1 to allBitmaps.count do
							(
								bitmapName = filterstring allBitmaps[i] "\\"
								bitmapName = bitmapName[bitmapName.count]
								
								bitmapFolder = substituteString allBitmaps[i] bitmapName ""
								allBitmapsRenamable[i] = (bitmapFolder == bitmapsFolder and doesFileExist allBitmaps[i]) 
								allBitmapsReadOnly[i] = if doesFileExist allBitmaps[i] then (getFileAttribute allBitmaps[i] #readOnly) else false
								bitmapName = getFilenameFile bitmapName
								
								
								allBitmapsNames[i] = bitmapName
								
								append listNames (objData allBitmapsNames[i] i allBitmapsRenamable[i] allBitmaps[i] allBitmapsNames[i] allBitmapsReadOnly[i])
							)
							
					)--if listNames.count == 0
					
					setArrowCursor()
				)--4--------------------------------------------------------------------------------------------------------------
				
				if rdoSource.state != 4 then
					listNames = sortListNamesAlphabetical listNames
				
				for i = 1 to listNames.count do
				(
					lvBefore.items.add listNames[i].name
					
					if listNames[i].modified then --si ha sido modificado ya pone la fila en amarillo
						lvBefore.items.item[i-1].backColor = colorModified
					
					if not listNames[i].renamable then --si no es renombrable pone la fila en rojo
					(
						lvBefore.items.item[i-1].backColor = colorNotRenamable
						lvBefore.items.item[i-1].foreColor = colorBackUnselected
					)
				)
			)
		)

		-----------------------------------------------
		--@fn: undefined | fillAfterList | Rellena el listView AfterList
		------------------------------------------------
		fn fillAfterList = 
		(
			_numItem = 0
			for  i= 1 to lvBefore.items.count do
			(
				if (lvBefore.selectedItems.count == 0 or lvBefore.items.item[i-1].selected) then
				(
					n = lvBefore.items.item[i-1].text
					
					if listNames[i].renamable then --si se puede renombrar
					(
						txtFindWhat = edtFindWhat.text
						txtReplaceWith = edtReplaceWith.text
						nombre = n
						
						------- Replace text -------
						if edtFindWhat.text != "" then nombre = replaceText nombre txtFindWhat txtReplaceWith matchCase:chkMatchCase.checked
						
						n = nombre
										
						------- Remove first/last -------
						if spnRemoveFirst.value != 0 then n = substring n (spnRemoveFirst.value +1) n.count
						if spnRemoveLast.value != 0 then  -- comprobamos que no se intenta borrar más caracteres de los que hay. Si no se comporta mal.
						(
							r = spnRemoveLast.value 
							if r > n.count then r = n.count
							n = substring n 1 (n.count - r)
						)
						
						------- Prefix / Base name / Suffix -------
						if edtBase.text != "" then n = edtBase.text
						if edtPrefix.text != "" then n = edtPrefix.text + n
						if edtSuffix.text != "" then n = n + edtSuffix.text
						
						
						------- Numeración -------
						_numItem += 1	-- necesario como índice para la numeración de objetos correcta
						if chkNumbered.checked then 
						(
							num = ((spnStart.value + ((_numItem-1)*(spnStep.value))) as string)
							if num.count == 1 then num = "0" + num
							if num.count == 2 and num[1] == "-" then num = "-0" + num[2]
							n = n + num
						)
					)--if renamable
					
					if lvBefore.items.item[i-1].subitems.count > 1 then
						lvBefore.items.item[i-1].subitems.item[1].text = n
					else		
						lvBefore.items.item[i-1].subitems.add n
				)
				else	-- si no hay que renombrar el elmento se deja su nombre tal cual
					lvBefore.items.item[i-1].subitems.item[1].text = lvBefore.items.item[i-1].subitems.item[0].text 
			)--for
		)

		-----------------------------------------------
		--@fn: undefined | setRowColor | Aplica el color al visualizador
		------------------------------------------------
		fn setRowColor item notSelected:false =
		(
			_readOnly = listNames[item.index + 1].modified
			_renamable = listNames[item.index + 1].renamable
			
			if item.selected and not notSelected then 
			(
					if item.backColor != colorBackSelected then item.backColor = colorBackSelected
					if item.foreColor != colorBackUnselected then item.foreColor = colorBackUnselected
			)
			else --si no esta seleccionado
			(
				if _renamable then --si es renombrable
				(
					if not _readOnly then
					(
						if item.backColor != colorBackUnselected then item.backColor = colorBackUnselected
					)
					else
					(
						if item.backColor != colorModified then item.backColor = colorModified
					)
						
					if item.foreColor != colorFore then item.foreColor = colorFore					
				)
				else --si no es renombrable
				(
					if item.backColor != colorNotRenamable then item.backColor = colorNotRenamable
					if item.foreColor != colorBackUnselected then item.foreColor = colorBackUnselected
				)
			)
		)

		-----------------------------------------------
		--@fn: undefined | resetListView | Reinicia el listView pasado como parámetro
		------------------------------------------------
		fn resetListView lv resetList:true =
		(
			if lv.name == "lvBefore" then 
			(
				lv.items.clear()
				
				if resetList then
					listNames = #()
				
				fillBeforeList()
				fillAfterList()
			)
		)

		-----------------------------------------------
		--@fn: undefined | ApplyChanges | Actualiza los nombres de las piezas, definitive indica que para el caso en el que se renombren bitmaps se apliquen lo cambios
		------------------------------------------------
		fn ApplyChanges definitive:false =
		(
			_renombrado = false
			
			if mode == "NC" then
			(
				for i = 1 to rollNC.lvNaming.selectedItems.count do
				(
					index = rollNC.lvNaming.selectedItems.item[i-1].index + 1
					
					-- edición nombre completo
					if rollNC.editMode == 0 then
						nombre = lvBefore.items.item[i-1].subitems.item[1].text
					
					-- edición de la entidad
					if rollNC.editMode == 1 then
					(
						if (lb.nc.ncOK rollNC.lvNaming.selectedItems.item[i-1].text) then
						(
							n = filterstring	rollNC.lvNaming.selectedItems.item[i-1].text "_"
							n[2] = lvBefore.items.item[i-1].subitems.item[1].text
							nombre = ""
							for i in n do append nombre (i + "_")
							nombre = substring nombre 1 (nombre.count-1)
						)
						else
							nombre = lvBefore.items[i-1].item[1].text
					)
					
					-- edición solo del nombre
					if rollNC.editMode == 2 then
					(
						if (lb.nc.ncOK rollNC.lvNaming.selectedItems.item[i-1].text) then
						(
							n = filterstring	rollNC.lvNaming.selectedItems.item[i-1].text "_"
							n[5] = lvBefore.items.item[i-1].subitems.item[1].text
							nombre = ""
							for i in n do append nombre (i + "_")
							nombre = substring nombre 1 (nombre.count-1)
						)
						else
							nombre = lvBefore.items.item[i-1].subitems.item[1].text
					)
					
					rollNC.listNames[index].name = nombre
					rollNC.newNames[rollNC.listNames[index].index] = nombre
				)
				
				rollNC.sortListNames()
				rollNC.refreshListView()
				rollNC.restoreSelection()
				
				_renombrado = true
			)
			
			if mode == "General" then
			(
				-- eliminamos temporalmente el callback para que funcione correctamente el _renombrado
				parent.rollMain.removeSceneEvents()
				duplicados = false
				namesConflict = false
				conflictiveNames = #()
				
				--obtenemos los bitmaps de la carpeta de texturas
				bitmapsInFolder = #()
				for ext in graphicFormats do
					bitmapsInFolder += getFiles (bitmapsFolder + "\\*." + ext)
				
				for i=1 to bitmapsInFolder.count do
				(
					bitmapsInFolder[i] = substituteString bitmapsInFolder[i] (bitmapsFolder + "\\") ""
					bitmapsInFolder[i] = getFilenameFile bitmapsInFolder[i] 
				)
				
				if rdoSource.state > 1 then	-- si estamos renombrando layers, materiales o bitmaps comprobamos que no haya nombres duplicados
				(
					for i = 1 to lvBefore.items.count do
					(
						item1 = lvBefore.items.item[i-1].subitems.item[1].text
						item0 = lvBefore.items.item[i-1].subitems.item[0].text
						
						--mira si no estamos creando nombres duplicados
						for j = 1 to lvBefore.items.count do
							if j != i then 
							(
								item2 = lvBefore.items.item[j-1].subitems.item[1].text
								if item1 == item2 then	duplicados = true
							)
							
						if (item1 != item0) and (findItem bitmapsInFolder item1 != 0) then
						(
							namesConflict = true
							append conflictiveNames item1
						)
					)
				)
				
				if not duplicados and not namesConflict then
				(
					sceneMats = lb.materials.getSceneMaterials includeSubmaterials:false
					
					if rdoSource.state != 4 then --si no son bitmaps
					(
						undo "Rename" on
						(
							for i = 1 to lvBefore.items.count do
							(
								newName = lvBefore.items.item[i-1].subitems.item[1].text
								index = listNames[i].index
								case rdoSource.state of
								(
									1: objects[index].name = newName
									
									2: if index < layerManager.count then (layerManager.getLayer index).setname newName
									
									3: sceneMats[index].name = newName
								)--case
							)--for
						)--undo
						
						_renombrado = true
					)
					else --si son bitmaps -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					(-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
						if true then --definitive then --si los cambios en los nombres vana a ser aplicados definitivamente
						(
							if queryBox "This operation has no undo, do you want to continue? Remember that you are going to rename external files names." then
							(
								_renombrado = true
								beforeRename = #()--array para almacenarlas rutas antes de renombrar
								afterRename = #()--array para las rutas despues de renombrar
								foldersToCommit = #() --array para almacenar los folders que hay que hacer commit
								changeList = #() --array de ficheros que tenemos que hacer commit
								
								for i=1 to lvBefore.items.count do
								(
									newName = lvBefore.items.item[i-1].subitems.item[1].text
									
									if listNames[i].name != newName then
									(
										listNames[i].name = newName
										listNames[i].modified = (listNames[i].originalName != newName)
									)
								)
								
								for i=1 to listNames.count do --lvBefore.items.count do
								(
									newName = /*listNames[i].name --*/lvBefore.items.item[i-1].subitems.item[1].text
									
									--if listNames[i].modified then --if newName != allBitmapsNames[i] then --solo renombra si el nombre ha cambiado
									if newName != listNames[i].originalName then --solo renombra si el nombre ha cambiado
									(
										if doesFileExist listNames[i].originalPath then --si existe la textura
											if not getFileAttribute listNames[i].originalPath #readOnly then --si no es readonly
											(
												newName = substituteString listNames[i].originalPath listNames[i].originalName newName --listNames[i].name --allBitmaps[i] allBitmapsNames[i] newName
										
												if not renameFile listNames[i].originalPath /*allBitmaps[i]*/ newName then --intenta renombrar el archivo
													_renombrado = false
												else
												(
													append beforeRename listNames[i].originalPath --allBitmaps[i]
													append afterRename newName
													listNames[i].originalPath = newName
												)
											)
									)
								)--for
								
								--ahora hay que redireccionar los bitmaps que se han _renombrado-------------------------
								for i=1 to beforeRename.count do
									lb.materials.redirectBitmap objects beforeRename[i] afterRename[i]
								-----------------------------------------------------------------------------------------------
								
							)--if querybox
						)--if definitive
						
					)--if state
				)
				else
				(
					if duplicados then
						messageBox "No se puede aplicar los cambios. Generaría nombres duplicados.\nCambie las opciones para solucionar el problema."
					else if namesConflict then
					(
						message = "No se puede aplicar los cambios. Generaría conflicto de nombres ya que existen texturas con esos nombres en la carpeta.\n"
						for n in conflictiveNames do message += "\n" + n
						messageBox message
					)					
					
					_renombrado = false
				)
				
				callbacks.addscript #selectionSetChanged "lb.renamer.rollMain.checkChangedSelection()" id:#Renamer
			)--if mode general
			
			_renombrado
		)

		-----------------------------------------------
		--@fn: undefined | clearControls | Limpia todos los controles
		------------------------------------------------
		fn clearControls =
		(
			edtPrefix.text = edtSuffix.text = edtBase.text =  ""
			spnRemoveFirst.value = spnRemoveLast.value = 0
			edtFindWhat.text = edtReplaceWith.text  = ""
			chkNumbered.checked = false
			chkMatchCase.checked = false
		)

		-----------------------------------------------
		--@fn: undefined | checkChangedSelection | aclualiza el listado cuando cambia la selección de objetos en viewport
		------------------------------------------------
		fn checkChangedSelection =
		(
			if chkSelected.checked and rdoSource.state == 1 then
			(
				resetListView lvBefore
			)
		)

		-----------------------------------------------
		--@fn: undefined | selectItems | selecciona los elementos marcados en el listado de distintas formas, dependiendo de si son objetos, layers o materiales
		------------------------------------------------
		fn selectItems =
		(
			case rdoSource.state of
			(
				1:	-- si es uno o varios objetos lo seleccionamos
					(
						_OBJs = #()
						for i = 1 to lvBefore.selectedItems.count do
						(
							index = listNames[lvBefore.selectedItems.item[i-1].index + 1].index
							append _OBJs objects[index]
						)
						select _OBJs
					)
				3:	-- si es un material lo mostramos en el editor de materiales
					(
						_sceneMats = lb.materials.getSceneMaterials includeSubmaterials:false
						for i = 1 to lvBefore.selectedItems.count do
						(
							index = listNames[lvBefore.selectedItems.item[i-1].index + 1].index
							meditmaterials[i] = _sceneMats[index]
						)
						medit.setActiveMtlSlot 1 false
						max mtledit
					)
				
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
		
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			callbacks.removescripts  id:#Renamer
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

			lvBefore.width = rollMainDef.width - 10
			lvBefore.height = rollMainDef.height - 190

			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				initListView lvBefore
				resetListView lvBefore

				grpParts.width = size.x - 110
				increment = (size.x - 570)
				
				edtPrefix.width = 135 + increment/3.0
				
				lblBase.pos.x = edtBase.pos.x = 255 + increment/3.0
				edtBase.width = 165 + increment/3.0
				
				lblRemoveLast.pos.x = lblSuffix.pos.x = edtSuffix.pos.x = 425 + increment/1.5
				edtSuffix.width = 135 + increment/3
				
				spnRemoveLast.pos.x = 515 + increment/1.5
				lblChars2.pos.x = 530 + increment/1.5
				
				grpReplace.width = size.x - 250
				edtFindWhat.width = size.x - 414
				edtReplaceWith.width = size.x - 414
				chkMatchCase.pos.x = size.x - 325			
				
				grpNumbered.pos.x = size.x - 235
				chkNumbered.pos.x = size.x - 228
				spnStart.pos.x = size.x - 152
				spnStep.pos.x = size.x - 152
				
				btnApply.pos.x = size.x - 120
				btnRevert.pos.x = size.x - 120
				
				btnRefresh.pos.x = size.x - 60
				
				btnOk.pos.x = size.x - 115
				btnCancel.pos.x = size.x - 60		
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				for c in rollMainDef.controls where (c.pos.y > lvBefore.pos.y) do
					c.pos.y = rollMainDef.height - 25
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
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		on rdoSource changed val do
		(
			case rdoSource.state of
			(
				1: (btnSelect.text = "Select"; btnSelect.enabled = true)
				2: (btnSelect.text = "Select"; btnSelect.enabled = false)
				3: (btnSelect.text = "View"; btnSelect.enabled = true)
				4: (btnSelect.text = "Select"; btnSelect.enabled = false)
			)
			
			resetListView lvBefore
		)

		on btnRefresh pressed do
		(
			mode = ""
			if rollNC != undefined and rollNC.open then
			(
				mode = "NC" 
				chkSelected.visible = false
				chkVisible.visible = false
				btnSelect.visible = false
			)
			else 
				mode = "General"
			
			initListView lvBefore
			lvBefore.name = "lvBefore"
			resetListView lvBefore
		)

		on edtPrefix changed val do fillAfterList()

		on edtBase changed val do fillAfterList()

		on edtSuffix changed val do fillAfterList()

		on chkNumbered changed val do
		(
			spnStart.enabled = spnStep.enabled = val
			fillAfterList()
		)

		on spnStart changed val do fillAfterList()

		on spnStep changed val do fillAfterList()

		on spnRemoveFirst changed val do fillAfterList()

		on spnRemoveLast changed val do fillAfterList()

		on edtFindWhat changed val do fillAfterList()

		on edtReplaceWith changed val do fillAfterList()

		on chkMatchCase changed val do fillAfterList()

		on btnOk pressed do
		(
			setWaitCursor()
			
			if applyChanges definitive:true then
				destroyDialog rollMainDef
			
			setArrowCursor()
		)

		on btnCancel pressed do
		(
			destroyDialog rollMainDef
		)
		
		on btnApply pressed do
		(
			setWaitCursor()
			
			if applyChanges() then
			(
				clearControls()
				
				--if rdoSource.state != 4 then
					resetListView lvBefore
				--else
				--resetListView lvBefore resetList:false
			)
			
			setArrowCursor()
		)

		on btnRevert pressed do
		(
			for i=1 to listNames.count do
				if (lvBefore.selectedItems.count == 0 or lvBefore.items.item[i-1].selected) then
				(
					listNames[i].name = listNames[i].originalName
					listNames[i].modified = false
				)
			
			resetListView lvBefore resetList:false
		)

		on lvBefore afterLabelEdit events do
		(
			if events.label != "" and events.label != undefined then
			(
				index = listNames[events.item + 1].index
				lvBefore.selectedItems.item[0].text = events.label				-- necesario porque en ese punto aún no se ha actualizado el contenido del listview
				listNames[events.item + 1].name = events.label
				sceneMats = lb.materials.getSceneMaterials includeSubmaterials:false
				case rdoSource.state of
				(
					1: objects[index].name = events.label
					2: (layerManager.getlayer index).setname events.label
					3: sceneMats[index].name = events.label
				)
				
				fillAfterList()
				lvBefore.refresh()
			)
		)

		on lvBefore mouseDown events do 
		(
			if not keyboard.controlPressed and not keyboard.shiftPressed then
			for i = 1 to lvBefore.items.count do setRowColor lvBefore.items.item[i-1] notSelected:true				
		)		
			
		on lvBefore mouseUp events do btnSelect.enabled = (lvBefore.selectedItems.count > 0)

		on lvBefore doubleClick events do
		(
			if (mode == "General") then selectItems()
		)

		on lvBefore keyDown events do
		(
			_key = events.keyData.tostring()
			case _key of 
			(
				"F2" : if lvbefore.selecteditems.count > 0 then lvbefore.selecteditems.item[0].beginedit()
			)
		)
								
		on lvBefore lostFocus events do
		(
			for i = 1 to lvBefore.items.count do setRowColor lvBefore.items.item[i-1]
		)

		on lvBefore mouseUp events do
		(
			if mode == "General" and (events.button.toString()) == "Right" then
			(
				rcmenu rollMainDef_rmenu
				(
					menuitem rSelect "Select/view" 
					
					on rSelect picked do selectItems()
				)
				
				if rdoSource.state != 2 then
					popupmenu rollMainDef_rmenu
			)
			
			fillAfterList()
		)

		on chkSelected changed val do resetListView lvBefore

		on chkVisible changed val do resetListView lvBefore
			
		on chkNcOkFail changed val do
		(
			--change = true
			--if rdoSource.state == 4 then
			--change = queryBox "All bitmaps name changes will be lost. Do you want to continue?"
			--if change then
			resetListView lvBefore
			--else
			--chkNcOkFail.checked = not val
		)

		on btnSelect pressed do selectItems()

		on btnSelectAll pressed do
		(
			for i = 1 to lvBefore.items.count do
			(
				lvBefore.items.item[i-1].selected = true
				setRowColor lvBefore.items.item[i-1]
			)
			
			fillAfterList()
		)

		on btnSelectNone pressed do
		(
			for i = 1 to lvBefore.items.count do
			(
				lvBefore.items.item[i-1].selected = false
				setRowColor lvBefore.items.item[i-1]
			)
			
			fillAfterList()
		)

		on btnSelectInvert pressed do
		(
			for i = 1 to lvBefore.items.count do
			(
				lvBefore.items.item[i-1].selected = not lvBefore.items.item[i-1].selected
				setRowColor lvBefore.items.item[i-1]
			)
			
			fillAfterList()
		)

		---------------------------------------------------------------
		--muestra la informacion de namingo convention
		---------------------------------------------------------------
		on btnNChelp pressed do
		(
			lb.namingConventionInfo.run()
			-- 		case rdoSource.state of
			-- 		(
			-- 			1: showNChelp()
			-- 			2: showNChelp type:#layer
			-- 			3: showNChelp type:#material
			-- 			4: showNChelp type:#bitmap
			-- 		)--case
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

			mode = ""
			if rollNC != undefined and rollNC.open then
			(
				mode = "NC" 
				chkSelected.visible = false
				chkVisible.visible = false
				btnSelect.visible = false
			)
			else 
				mode = "General"

			if mode == "General" then
				callbacks.addscript #selectionSetChanged "lb.renamer.rollMain.checkChangedSelection()" id:#Renamer
			
			initListView lvBefore
			lvBefore.name = "lvBefore"
			resetListView lvBefore	

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
	--@struct: Renamer | Contiene la herramienta Renamer.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_renamer
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Renamer",		--@var: description | Descripcion de la tool.
		
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
	)--tl_renamer
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_renamer() --crea la herramienta
)