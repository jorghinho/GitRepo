------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta namingConventionChecking.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	rollout rollNChelpDef "" width:296 height:208
	(
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local topicTxt = ""
		local helpTxt = ""

		dotNetControl lblTopic "system.windows.forms.label" pos:[8,8] width:112 height:16
		dotNetControl edtHelp "system.windows.forms.label" pos:[5,30] width:288 height:140
		button btnClose "Close" pos:[96,176] width:96 height:24
		
		---------------------------------------------------------------------------------------
		on rollNChelpDef open do
		(
			edtHelp.backcolor = (dotNetClass "System.Drawing.Color").fromargb 200 200 200
			edtHelp.borderStyle = (dotnetclass "system.windows.forms.borderStyle").fixedSingle
			
			edtHelp.padding = (dotnetobject "System.Windows.Forms.Padding" 5)
			
			lblTopic.backcolor = (dotNetClass "System.Drawing.Color").fromargb 200 200 200
			lblTopic.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 9 (dotnetclass "system.drawing.fontstyle").bold
		)
		
		---------------------------------------------------------------------------------------
		on btnClose pressed do
			destroyDialog rollNChelpDef
	)

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta namingConventionChecking.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Naming Convention Checking"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 640		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 400		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local NCBackColor = (dotNetClass "System.Drawing.Color").white					-- fondo del listado cuando cumple el NC
		local notNCbackColor = (dotNetClass "System.Drawing.Color").lightsalmon			-- fondo del listado cuando no cumple el NC
		local selColorBg =	(dotNetClass "System.Drawing.Color").fromargb 35 35 105		-- fondo pistas seleccionadas
		local selColorFg =	(dotNetClass "System.Drawing.Color").white					-- texto pistas seleccionadas
		local foreColor = (dotNetClass "System.Drawing.Color").black					-- color texto listado
		local txtColorBg = (dotNetClass "System.Drawing.Color").fromargb 225 225 225	-- color fondo textBox
		
		local newNames = #()						-- Nuevos nombres que se actualizarán en los objetos si pulsamos Ok para salir del panel
													-- Almacena todos los nuevos nombres de todas las piezas de la escena, estén o no listadas.
		struct names (name, index)					-- Estructura que almacena el nombre del objeto y su índice de objeto en la escena
		local listNames = #()						-- Array de Names con los objetos listados actualmente y su índice de objeto en la escena
		local sel = #()								-- índices de objetos seleccionados en el listado. Necesario para restablecer la selección al redibujar el listado
		local editMode = 0							-- parte del nombre que se está editando	0:Todo		1:Entity	2:Name
		local stopEvents = false					-- indica si hay que tener o no en cuenta los eventos de cambios en los controles de nombre
		local flagsUpdateOption = 1					-- indica la opcion al actualizar los flags
														--1 reemplaza los flags por los nuevos
														--2 añade los flags que no tenga ya de esntre los nuevos
															
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpNameEdit "Name editing" pos:[5,5] width:610 height:70
		label lblType "Type" pos:[15,20] width:30 height:15 				
		label lblEntity "Entity" pos:[85,20] width:35 height:15 			
		label lblClass "Class" pos:[165,20] width:40 height:15			
		label lblLocation "Location" pos:[220,20] width:45 height:15	
		label lblNombre "Name" pos:[325,20] width:40 height:15			
		label lblSpecial "Special" pos:[440,20] width:40 height:15
		label lblFlags "Flags" pos:[515,20] width:30 height:15

		dropdownList ddlTypeName "" pos:[15,40] width:45 height:21 items:lb.nc.NC_assetTypes selection:0 					
		button btnEditEntityName ">" pos:[140,40] width:15 height:20 
					
		dotNetControl edtEntityName "System.Windows.Forms.TextBox" pos:[60,40] width:80 height:21 multiline:false 
		dropdownList ddlClassName "" pos:[160,40] width:55 height:21 items:lb.nc.NC_classTypes selection:0 					
		dropdownList ddlLocationName "" pos:[220,40] width:60 height:21 items:lb.nc.NC_locationTypes selection:0 		
					
		dotNetControl edtName "System.Windows.Forms.TextBox" pos:[285,40] width:125 height:21 multiline:false 
		button btnEditName ">" pos:[410,40] width:15 height:20
					
		dropdownList ddlSpecialName "" pos:[435,40] width:65 height:21 items:lb.nc.NC_specialTypes selection:0					
		edittext edtFlags "" pos:[505,40] width:70 height:20 readOnly:true toolTip:"Flags:Unused at the moment"
					
		button btnEditFullName ">" pos:[615,25] width:20 height:50
				
		edittext edtTextSelection "" pos:[1,85] width:514 height:17 
		dotNetControl lvNaming "System.Windows.Forms.ListView" pos:[5,105] width:510 height:260
		groupBox grpFilters "Filters" pos:[525,80] width:110 height:226
		checkbox chkFilterGeometry "Geometry" pos:[535,95] width:88 height:16 checked:true
		checkbox chkFilterShapes "Shapes" pos:[535,112] width:88 height:16 checked:true
		checkbox chkFilterLights "Lights" pos:[535,128] width:88 height:16 checked:true
		checkbox chkFilterCameras "Cameras" pos:[535,144] width:88 height:16 checked:true
		checkbox chkFilterHelpers "Helpers" pos:[535,160] width:88 height:16 checked:true
		checkbox chkFilterWarps "Space Warps" pos:[535,176] width:88 height:16 checked:true
		checkbox chkFilterBones "Bones" pos:[535,192] width:88 height:16 checked:true
		checkbox chkFilterBiped "Biped Bones" pos:[535,208] width:88 height:16 checked:true
					
		button btnFAll "All" pos:[533,226] width:32 height:17	
		button btnFNone "None" pos:[565,226] width:32 height:17
		button btnFInvert "Inv." pos:[597,226] width:32 height:17
					
		checkbox chkFVisible "Visible" pos:[534,248] width:88 height:16 checked:true
		checkbox chkFFrozen "Frozen" pos:[535,266] width:85 height:16 checked:false
		checkbox chkFSelected "Selected" pos:[535,284] width:85 height:16 checked:false
					
		button btnConvert "Convert to NC" pos:[525,310] width:110 height:25
		button btnGetSelection "Get sel." pos:[525,335] width:55 height:25
		button btnSelNonNC "Sel nonNC" pos:[580,335] width:55 height:25
					
		button btnSelAll "All" pos:[5,367] width:85 height:20
		button btnSelNone "None" pos:[90,367] width:85 height:20
		button btnSelInvert "Invert" pos:[175,367] width:85 height:20
					
		checkbox chkSortByType "By type" pos:[280,367] width:59 height:15 checked:false
					
		button btnOk "Ok" pos:[525,367] width:55 height:24
		button btnCancel "Cancel" pos:[580,367] width:55 height:24
				
		button btnHelpType "?" pos:[40,20] width:15 height:15
		button btnHelpEntity "?" pos:[115,20] width:15 height:15
		button btnHelpClass "?" pos:[195,20] width:15 height:15
		button btnHelpLocation "?" pos:[265,20] width:15 height:15
		button btnHelpNombre "?" pos:[355,20] width:15 height:15
		button btnHelpSpecial "?" pos:[480,20] width:15 height:15
		button btnHelpFlags "?" pos:[550,20] width:15 height:15
		button btnHelpGeneral "?" pos:[615,10] width:20 height:15
				
		button btnSetNameFlags ">" pos:[575,40] width:12 height:20 toolTip:"Sets the flags"
		button btnAddNameFlags "+" pos:[587,40] width:12 height:20 toolTip:"Add new flags"
		button btnRemoveNameFlags "x" pos:[599,40] width:12 height:20 toolTip:"Removes all flags"
		
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
		--@fn: undefined | removeString | función que elimina la cadena de caracteres str del texto txt
		------------------------------------------------
		fn removeString txt str =
		(
			_txtTMP = filterstring txt str
			txt = ""
			for i in _txtTMP do append txt i
			return txt
		)

		------------------------------------------------
		--@fn: undefined | initNames | inicializa la variable newNames
		------------------------------------------------
		fn initNames = 
		(
			newNames = #()
			for i=1 to objects.count do newNames[i] = objects[i].name
		)

		------------------------------------------------
		--@fn: undefined | setRowColor | establece el color del texto y del fondo del elemento del listView pasado como parámetro
		------------------------------------------------
		fn setRowColor item notSelected:false =
		(
			_n = item.text
			if item.selected and not notSelected then 
			(
				if item.backColor != selColorBg then item.backColor = selColorBg
				if item.foreColor != selColorFg then item.foreColor = selColorFg
			)
			else
			(
				if item.foreColor != foreColor then item.foreColor = foreColor
				if (not lb.nc.ncOK _n) then 
				(
					if item.backColor != notNCbackColor then item.backColor = notNCbackColor 
				)
				else 
				(
					if item.backColor != backColor then item.backColor = backColor
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | initListView | inicia el ListView con todas sus propiedades principales, sin introducir datos
		------------------------------------------------
		fn initListView =
		(
			lv = lvNaming
			lv.gridLines = false
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.fullRowSelect = true
			lv.gridLines = true
			lv.backColor = ncBackColor
			lv.foreColor = foreColor
			lv.scrollable = true
			
			lv.headerStyle = none	-- sin columnas de encabezado
			
			lv.columns.add "" (lv.width - 5)
		) 

		------------------------------------------------
		--@fn: undefined | round | redondea el número N al valor entero más cercano. Devuelve un float.
		------------------------------------------------
		fn round n =
		(
			if mod n 1 >= 0.5 then ceil n else floor n
		)

		------------------------------------------------
		--@fn: undefined | sortListNamesAlphabetical | ordena el array ListNames alfabéticamente
		------------------------------------------------
		fn sortListNamesAlphabetical list =
		(
			_listNamesTMP = #()

			for i = 1 to list.count do
			(
				_encontrado = false
				j = round (_listNamesTMP.count as float / 2)
				_start = 1
				end = _listNamesTMP.count
				
				if end == 0 then -- si aún no hay elementos en _listNamesTMP lo añadimos directamente
				(
					append _listNamesTMP list[i]
				)
				else
				(
					while not _encontrado do
					(
						if (toLower list[i].name < toLower _listNamesTMP[j].name) then
							end = j
						else
							_start = j

						j = _start + round ((end - _start) as float / 2)
						if end - _start < 2 then _encontrado = true
					)
					
					if (toLower list[i].name < toLower _listNamesTMP[_start].name) then
						insertitem list[i] _listNamesTMP _start
					else 
						if (toLower list[i].name < toLower _listNamesTMP[end].name) then
							insertitem list[i] _listNamesTMP end
						else
							insertitem list[i] _listNamesTMP (end+1)
				)
				
				newNames[list[i].index] = list[i].name
			)
			
			list = _listNamesTMP
		)

		------------------------------------------------
		--@fn: undefined | sortListNamesByType | ordena el array ListNames por tipo de objeto
		------------------------------------------------
		fn sortListNamesByType list =
		(
			_listNamesTMP = #()
			_objsCameras = #() ; _objsGeometry = #() ; _objsHelpers = #()
			_objsHelpers = #() ; _objsLights = #(); _objsShapes = #() ; _objsWarps = #()
			for i = 1 to list.count where superclassof objects[list[i].index] == Camera do append _objsCameras list[i]
			for i = 1 to list.count where superclassof objects[list[i].index] == GeometryClass do append _objsGeometry list[i]
			for i = 1 to list.count where superclassof objects[list[i].index] == Helper do append _objsHelpers list[i]
			for i = 1 to list.count where superclassof objects[list[i].index] == light do append _objsLights list[i]
			for i = 1 to list.count where superclassof objects[list[i].index] == shape do append _objsShapes list[i]
			for i = 1 to list.count where superclassof objects[list[i].index] == SpaceWarpObject do append _objsWarps list[i]
			OBJs = #(_objsCameras, _objsGeometry, _objsHelpers, _objsLights, _objsShapes, _objsWarps)
			
			for o in OBJs where o != #() do
			(
				o = sortListNamesAlphabetical o
				join _listNamesTMP o
			)			
			
			list = _listNamesTMP
		)

		------------------------------------------------
		--@fn: undefined | sortListNames | ordena el array ListNames por tipo de objeto
		------------------------------------------------
		fn sortListNames =
		(
			if chkSortByType.checked then
				listNames = sortListNamesByType listNames
			else
				listNames = sortListNamesAlphabetical listNames

			-- reescribimos el listado
			--lvNaming.items.clear()
			for i=1 to listNames.count do 
			(
				lvNaming.items.item[i-1].text = listNames[i].name
				setRowColor lvNaming.items.item[i-1]
			)	
		)

		------------------------------------------------
		--@fn: undefined | fillListView | rellena el listado según las opciones de los filtros
		------------------------------------------------
		fn fillListView = 
		(
			lv = lvNaming
			superClassFilters = #()
			classFilters = #()
			listNames = #()
			
			if chkFilterGeometry.checked then append superClassFilters geometryclass
			if chkFilterShapes.checked then append superClassFilters shape
			if chkFilterLights.checked then append superClassFilters light
			if chkFilterCameras.checked then append superClassFilters camera
			if chkFilterHelpers.checked then append superClassFilters helper
			if chkFilterWarps.checked then append superClassFilters spacewarpobject

			if chkFilterBones.checked then append classFilters boneGeometry
			if chkFilterBiped.checked then append classFilters Biped_Object

			items = #()
			for i=1 to objects.count do
			(
				c = classof objects[i]
				bipBone = (classof objects[i].controller == bipSlave_control) or (classof objects[i].controller == vertical_horizontal_turn)
				if bipBone then c = Biped_Object
				if (c != boneGeometry and not bipBone and finditem superClassFilters (superclassOf objects[i]) != 0) or (finditem classFilters (classOf objects[i]) != 0) then
				(
					nodeOk = true
					if chkFVisible.checked and objects[i].isHidden then nodeOk = false
					if chkFFrozen.checked and not objects[i].isFrozen then nodeOk = false
					if chkFSelected.checked and not objects[i].isSelected then nodeOk = false
					if nodeOK then
					(
						append items newNames[i]
						append listNames (names index:i name:newNames[i])
					)
				)
			)

			for i = 1 to listNames.count do lvNaming.items.add listNames[i].name

			sortListNames()				
		)

		------------------------------------------------
		--@fn: undefined | disableControls | Inhabilita los controles de edición de nombre
		------------------------------------------------
		fn disableControls =
		(
			for c in rollMainDef.controls where (findstring c.name "Name" != undefined) do c.enabled = false
		)

		------------------------------------------------
		--@fn: undefined | enableControls | Habilita los controles de edición de nombr
		------------------------------------------------
		fn enableControls =
		(
			for c in rollMainDef.controls where (findstring c.name "Name" != undefined) do c.enabled = true
		)

		------------------------------------------------
		--@fn: undefined | fillControls | actualiza los valores de los controles según lo que haya seleccionado en el listado. Todos las partes compartidas del nombre de los objetos seleccionados se escriben en los controles.
		------------------------------------------------
		fn fillControls = 
		(
			stopEvents = true	-- con esto evitamos que salten los eventos por cambios en los controles de texto
			
			items = lvNaming.selectedItems
			numItems = items.count
			sameType = sameEntity = sameClass = sameLocation = sameName = sameSpecial = sameFlags = true
			
			n = if numItems > 0 then filterstring items.item[0].text "_" else undefined
			
			-- solo si hay más de un elemento seleccionado y si el número de partes
			-- de su nombre es igual a 7 pasamos a la siguiente fase
			if numItems > 0 and (n.count == 7) then
			(
				enableControls()
				i = 2
				allFalse = false
				while (i <= numItems) and (allFalse == false) do
				(	
					t = filterstring items.item[i-1].text "_"
					if t[1] != n[1] then sameType = false
					if t[2] != n[2] then sameEntity = false
					if t[3] != n[3] then sameClass = false
					if t[4] != n[4] then sameLocation = false
					if t[5] != n[5] then sameName = false
					if t[6] != n[6] then sameSpecial = false
					if t[7] != n[7] then sameFlags = false
						
					if (sameType == sameEntity == sameClass == sameLocation == sameName == sameSpecial == sameFlags == false) then
						allFalse = true
					i += 1
				)
				
				if sameType then ddlTypeName.selection = finditem ddlTypeName.items n[1] else ddlTypeName.selection = 0
				if sameEntity then edtEntityName.text = n[2] else edtEntityName.text = ""
				if sameClass then ddlClassName.selection = finditem ddlClassName.items n[3] else ddlClassName.selection = 0
				if sameLocation then ddlLocationName.selection = finditem ddlLocationName.items n[4] else ddlLocationName.selection = 0
				if sameName then edtName.text = n[5] else edtName.text = ""
				if sameSpecial then ddlSpecialName.selection = finditem ddlSpecialName.items n[6] else ddlSpecialName.selection = 0
				if sameFlags then edtFlags.text = n[7] else edtFlags.text = ""
			)
			else  -- si no se puede rellenar ningún control los vaciamos
			(
				ddlTypeName.selection = ddlClassName.selection = ddlLocationName.selection = ddlSpecialName.selection = 0
				edtEntityName.text = ""
				
				if numItems > 0 then  -- miramos si al menos coinciden los nombres
				(
 					enableControls()
 					n = items.item[0].text
 					continuar = true
					i = 1
					while i <= items.count and continuar do 
					(
						if items.item[i-1].text != n then continuar = false
						i += 1
					)
					
					if continuar then edtName.text = n else edtName.text = ""
				)
				else -- si no hay nada seleccionado inhabilitamos los controles
				(
					disableControls()
					edtName.text = ""
					edtFlags.text = ""
				)				
			)
			
			stopEvents = false
		)

		------------------------------------------------
		--@fn: undefined | restoreSelection | Vuelve a seleccionar los elementos marcados en la selección
		------------------------------------------------
		fn restoreSelection =
		(
			_selTMP =  #()
			for i = 1 to lvNaming.items.count do
			(
				if finditem sel (listNames[i].index) != 0 then
				(
					lvNaming.items.item[i-1].selected = true 
					append _selTMP listNames[i].index
				)
				else
					lvNaming.items.item[i-1].selected = false
			)
			sel = _selTMP
			if lvNaming.selecteditems.count > 0 then
				lvNaming.ensurevisible lvNaming.selecteditems.item[0].index 
		)

		------------------------------------------------
		--@fn: undefined | resetListView | borra el ListView y lo rellena de nuevo
		------------------------------------------------
		fn resetListView =
		(
			lvNaming.clear()
			initListView()
			fillListView()
			restoreSelection()
			fillControls()
		)

		------------------------------------------------
		--@fn: undefined | refreshListView | reescribe el listado
		------------------------------------------------
		fn refreshListView =
		(
			for i = 1 to listNames.count do
			(
				index = lvNaming.items.item[i-1].index + 1
				lvNaming.items.item[i-1].text = newNames[listNames[index].index]
			)
		)	

		------------------------------------------------
		--@fn: updateNames | resetListView | Actualiza los nombres de los objetos según los datos que vengan de los controles
		------------------------------------------------
		fn updateNames type:0 entity:"_!#!_" nclass:0 location:0 pname:"_!#!_" special:0 flags:"_!#!_" =
		(
			items = lvNaming.selectedItems
			if not stopEvents then
			(
				for i = 1 to items.count do
				(
					n = filterstring items.item[i-1].text "_"
					index = items.item[i-1].index + 1
					
					if n.count == 7 then
					(
						--casos para saber que hacer con los flags, sustituirlos, añadirlos.... ------------
						case flagsUpdateOption of
						(
							2: --obtiene los flags actueles del objeto y añade los nuevos que no tenga
							(
								if  flags != "" and flags != "_!#!_" then
								(
									if n[7] == lb.nc.NC_notSpecifiedFlag then
										n[7] == flags
									else
									(
										auxFlags = #()
										currentFlags = n[7]
										
										for f in lb.nc.NC_flags do
										(
											if findString currentFlags f != undefined then
											(
												appendIfUnique auxFlags f
												currentFlags = substituteString currentFlags f ""
											)
										)
										
										for f in lb.nc.NC_flags do
										(
											if findString flags f != undefined then
											(
												appendIfUnique auxFlags f
												flags = substituteString flags f ""
											)
										)
										
										if auxFlags.count != 0 then
										(
											flags = ""
											for f in auxFlags do
												flags = flags + f
										)
											
									)--if else
								)--if
							)--case2
						)--case of
						---------------------------------------------------------------------------------------
						
						if type != 0 			then n[1] = ddlTypeName.selected 
						if entity != "_!#!_" 	then n[2] = entity
						if nclass != 0 			then n[3] = ddlClassName.selected 
						if location != 0		then n[4] = ddlLocationName.selected 
						if pname != "_!#!_" 	then n[5] = pname
						if special != 0			then n[6] = ddlSpecialName.selected 
						if flags !=  "_!#!_" 	then (if flags != "" then n[7] = flags else n[7] = lb.nc.NC_notSpecifiedFlag)
							
						nameAux = ""
						
						for i=1 to 7 do (append nameAux (n[i] as string); append nameAux "_")
						nameAux = substring nameAux 1 (nameAux.count - 1)	-- quitamos el "_" del final
						
						if (filterstring nameAux "_").count == 7 then
						(
							nameAux = removeString nameAux "\n"	-- eliminamos posibles saltos de línea
							items.item[i-1].text = nameAux
							listNames[index].name = nameAux --actualiza el nombre
							lb.nc.sortFlags listNames[index].name --ordena los flags del objeto
							newNames[listNames[index].index] = nameAux
						)
					)
					else if pname != "_!#!_" then
					(
						items.item[i-1].text = listNames[index].name = newNames[listNames[index].index] = pname
					)
 						
				)
			
				sortListNames()
				restoreSelection()
			)
		)

		-----------------------------------------------
		--@fn: undefined | updaterollRenamer | Actualiza los listViews before y after de rollRenamer
		------------------------------------------------
		fn updaterollRenamer = 
		(
			if lb.renamer.rollMain != undefined and lb.renamer.isOpen() then
			(
				lb.renamer.rollMain.resetListView lb.renamer.rollMain.lvBefore
				lb.renamer.rollMain.resetListView lb.renamer.rollMain.lvAfter
			)
		)

		----------------------------------------------
		--@fn: undefined | showHelp | Actualiza los listViews before y after de lb.renamer.rollMain
		------------------------------------------------
		fn showHelp category = 
		(
			topic = ""
			txt = ""
			case category of
			(
				#type: 		(topic = "Type"; txt = "Specify the type of asset. It must match the filename.\n\nchr - Character\nprp - Prop\nset - Scenery\nspr - Set Prop (the animated parts of a set).")
				#entity: 	(topic = "Entity"; txt = "The name of the asset.")
				#class: 		(topic = "Class"; txt = "Type of object in the scene depending on its function.\n\nIn modelling department always specify \"mesh\".\n\n For rigging department see rigging rules document for more details.")
				#location: 	(topic = "Location"; txt = "Specifies if the object is placed on the left, right, middle, etc. side of something.\n\nMark this only if it's relevant.")
				#name: 		(topic = "Name"; txt = "The name of the object.\n\nExamples:\nupperarm\nlamp\nlamp-button")
				#special: 	(topic = "Special"; txt = "This must be specified only for mesh objects in rigging department.\n\npc: Point Cache (deformable object)\ntpc: Transform Point Cache (non deformable object)")
				#flags: 		(topic = "Flags"; txt = "Flags indicates object properties.\nExamples:\n\"h\":hidden\n\"f\":frozen...")
				#general:	(topic = "Edit full name"; txt = "Use this button to edit the whole name of the object in the general renamer.\n\nThe name of any object must have 7 parts separated by underscores \"_\"\n\nExamples:\nchr_tadeo_mesh_x_body_tpc_x\nchr_fredi_anim_r_upperarm_x_x")
			)

			if txt != "" then 
			(	
				try destroyDialog parent.rollNChelp catch()
				createDialog parent.rollNChelp
				parent.rollNChelp.lblTopic.text = topic
				parent.rollNChelp.edtHelp.text = txt
			)
		)

		----------------------------------------------
		--@fn: undefined | updateFlags | Actualiza los flags
		------------------------------------------------
		fn updateFlags flags =
		(
 			if flags != "" then
			(
				tempFlags = #()
				for f in lb.nc.NC_flags do
					if (findString flags f) != undefined then
					(
						append tempFlags f
						flags = substituteString flags f ""
					)
				--for i=1 to flags.count do
				--	append tempFlags flags[i]
				sort tempFlags
				if tempFlags.count != 0 then
				(
					flags = ""
					for f in tempFlags do
						flags = flags + f
				)
						
				updateNames flags:flags
				edtFlags.text = flags
			)
			
			try destroydialog rollNCflagsManager catch()
		)

		----------------------------------------------
		--@fn: undefined | flagsManagerOpen | Editar los flags 
		------------------------------------------------
		fn flagsManagerOpen =
		(
			rolloutDef = "rollout rollNCflagsManagerDef \"Flags\" width:380\n"
			rolloutDef = rolloutDef + "(\n"
			for i=2 to lb.nc.NC_flags.count do
			(	
				rolloutDef = rolloutDef + "checkbox chkFlag" + ((i-1) as string) + " \"" + (lb.nc.NC_flags[i]) + ": " + (lb.nc.NC_flagsDesc[i]) + "\" pos:[5," + ((5 + 20*(i-2)) as string) + "] width:400 height:15 tooltip:\"" + (lb.nc.NC_flagsDesc[i]) + "\"\n"
			)
			
			rolloutDef = rolloutDef + "button btnOk \"OK\" pos:[5," + ((15 + 20*(lb.nc.NC_flags.count-1)) as string) + "] width:50 height:20\n"
			
			rolloutDef = rolloutDef + "\n"
			rolloutDef = rolloutDef + "on btnOk pressed do (\n"
			rolloutDef = rolloutDef + "		flags = \"\""
			for i=2 to lb.nc.NC_flags.count do
			(
				rolloutDef = rolloutDef + "	if chkFlag" + ((i-1) as string) + ".checked then\n"
				rolloutDef = rolloutDef + "	flags = flags + \"" + (lb.nc.NC_flags[i]) + "\"\n"
			)
			rolloutDef = rolloutDef + "		lb.namingConventionChecking.rollMain.updateFlags flags\n"
			rolloutDef = rolloutDef + "		destroyDialog rollNCflagsManagerDef\n"
			rolloutDef = rolloutDef + ")\n"
			rolloutDef = rolloutDef + ")\n"
			
			try destroyDialog parent.rollNCflagsManager catch()
			parent.rollNCflagsManager = execute rolloutDef
			
			try
			(
				createDialog parent.rollNCflagsManager lockWidth:true style:#(#style_border,#style_resizing,#style_toolwindow,#style_sysmenu) modal:true
				
				items = lvNaming.selectedItems
				
				sameFlags = false
				prevFlags = ""
				for i = 1 to items.count do
				(
					n = filterstring items.item[i-1].text "_"
					index = items.item[i-1].index + 1
					
					if i==1 then
					(
						sameFlags = true
						if n.count == 7 then prevFlags = n[7]
					)
					else
						if n.count == 7 then
							if prevFlags != n[7] then
								sameFlags = false
				)
				
				
				if sameFlags then
				(
					
					index = items.item[0].index + 1
					flags = ""
					if lb.nc.ncOK listNames[index].name then
					(
						flags = (filterString listNames[index].name "_")[7]
						if flags == "x" then flags = ""
					)
					
					for f in lb.nc.NC_flags do
						if (findString flags f) != undefined then
						(
							flags = substituteString flags f ""
							chkIndex = findItem lb.nc.NC_flags f
							if chkIndex != 0 and f != lb.nc.NC_notSpecifiedFlag then
								execute ("rollNCflagsManager.chkFlag" + ((chkIndex - 1) as string) + ".checked = true")
						)
					
				)--if
			)
			catch()
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

			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(

				lvNaming.size = dotNetObject "System.Drawing.Size" 460 (rollMainDef.height - 140)
				btnSelAll.pos.y = btnSelNone.pos.y = btnSelInvert.pos.y = chkSortByType.pos.y = rollMainDef.height - 33
				btnOk.pos.y = btnCancel.pos.y = rollMainDef.height - 33
				
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

		on btnRemoveNameFlags pressed do
		(
			updateNames flags:""
			fillControls()
		)

		on btnSetNameFlags pressed do
		(
			flagsUpdateOption = 1
			try destroyDialog rollNCflagsManager catch()
			try flagsManagerOpen() catch()
			fillControls()
		)

		on btnAddNameFlags pressed do
		(
			flagsUpdateOption = 2
			try destroyDialog rollNCflagsManager catch()
			try flagsManagerOpen() catch()
			fillControls()
		)	
		
		on ddlTypeName selected val do updateNames type:val

		on btnEditEntityName pressed 	do
		(
			try destroyDialog lb.renamer.rollMain catch()
			editMode = 1
			
			posX = (getINISetting (toolsCfgPath + "\\renamer.ini") "pos" "x") as integer
			posY = (getINISetting (toolsCfgPath + "\\renamer.ini") "pos" "y") as integer
				
			pos = [posX, posY]
			
			width = (getINISetting (toolsCfgPath + "\\renamer.ini") "size" "width") as integer
			height = (getINISetting (toolsCfgPath + "\\renamer.ini") "size" "height") as integer
			
			if width == 0 do width = 570
			if height == 0 do height = 400
			
			createDialog lb.renamer.rollMain width height pos:pos lockHeight:false lockWidth:false style:#(#style_border,#style_resizing,#style_toolwindow,#style_sysmenu)			
			
			lb.renamer.rollMain.height = height + 1
			lb.renamer.rollMain.height = height
		)
		
		on edtEntityName TextChanged do updateNames entity:edtEntityName.text	

		on ddlClassName selected val do updateNames nclass:val

		on ddlLocationName selected val do updateNames location:val

		on edtName TextChanged do updateNames pname:edtName.text 

		/*on btnEditName pressed do
		(	
			lb.renamer.close()
			editMode = 2
			lb.renamer.run()
			try destroyDialog rollRenamer catch()
			editMode = 2
			
			posX = (getINISetting (toolsCfgPath + "\\renamer.ini") "pos" "x") as integer
			posY = (getINISetting (toolsCfgPath + "\\renamer.ini") "pos" "y") as integer
				
			pos = [posX, posY]
			
			width = (getINISetting (toolsCfgPath + "\\renamer.ini") "size" "width") as integer
			height = (getINISetting (toolsCfgPath + "\\renamer.ini") "size" "height") as integer
			
			if width == 0 do width = 570
			if height == 0 do height = 400
			
			createDialog rollRenamer width height pos:pos lockHeight:false lockWidth:false style:#(#style_border,#style_resizing,#style_toolwindow,#style_sysmenu)			
			
			rollRenamer.height = height + 1
			rollRenamer.height = height
		)*/

		on ddlSpecialName selected val 	do updateNames special:val

		on btnEditFullName pressed do
		(
			lb.renamer.close()
			editMode = 0
			lb.renamer.run()
			/*try destroyDialog rollRenamer catch()
			editMode = 0
			
			posX = (getINISetting (toolsCfgPath + "\\renamer.ini") "pos" "x") as integer
			posY = (getINISetting (toolsCfgPath + "\\renamer.ini") "pos" "y") as integer
				
			pos = [posX, posY]
			
			width = (getINISetting (toolsCfgPath + "\\renamer.ini") "size" "width") as integer
			height = (getINISetting (toolsCfgPath + "\\renamer.ini") "size" "height") as integer
			
			if width == 0 do width = 570
			if height == 0 do height = 400
			
			createDialog rollRenamer width height pos:pos lockHeight:false lockWidth:false style:#(#style_border,#style_resizing,#style_toolwindow,#style_sysmenu)			
			
			rollRenamer.height = height + 1
			rollRenamer.height = height*/
		)

		on edtTextSelection changed val do
		(
			for i = 1 to lvNaming.items.count do
			(
				item = lvNaming.items.item[i-1]
				if findstring item.text edtTextSelection.text != undefined then
					item.selected = true
				else 
					item.selected = false
			)
			fillControls()
			
			if lvNaming.selectedItems.count > 0 then lvNaming.ensureVisible (lvNaming.selectedItems.item[0].index + 1) 		
		)

		on lvNaming ItemSelectionChanged events do
		(
			setRowColor events.item
			index = events.item.index + 1
			if events.item.selected then
			(
				if finditem sel listNames[index].index == 0 then append sel listNames[index].index 
			)
			else 
				try deleteitem sel (finditem sel listNames[index].index) catch()
		)

		on lvNaming mouseUp events do
		(
			fillControls()
			if lb.renamer != undefined and lb.renamer.isOpen() then
			(
				rollRenamer.resetListView rollRenamer.lvBefore
				rollRenamer.resetListView rollRenamer.lvAfter
			)
		)

		on chkFilterGeometry changed val do resetListView()

		on chkFilterShapes changed val do resetListView()

		on chkFilterLights changed val do resetListView()

		on chkFilterCameras changed val do resetListView()
			
		on chkFilterHelpers changed val do resetListView()

		on chkFilterWarps changed val do resetListView()

		on chkFilterBones changed val do resetListView()

		on chkFilterBiped changed val do resetListView()

		on btnFAll pressed do
		(
			for c in rollMainDef.controls where (findstring c.name "chkFilter" != undefined) do c.checked = true
			resetListView()
		)

		on btnFNone pressed do
		(
			for c in rollMainDef.controls where (findstring c.name "chkFilter" != undefined) do c.checked = false
			resetListView()
		)
		
		on btnFInvert pressed do
		(
			for c in rollMainDef.controls where (findstring c.name "chkFilter" != undefined) do c.checked = not c.checked
			resetListView()
		)

		on chkFVisible changed val do resetListView()

		on chkFFrozen changed val do resetListView()
		
		on chkFSelected changed val do resetListView()
				
		on btnSelAll pressed do
		(
			for i=1 to lvNaming.items.count do lvNaming.items.item[i-1].selected = true
			fillControls()
			updaterollRenamer()
		)

		on btnSelNone pressed do
		(
			for i=1 to lvNaming.items.count do lvNaming.items.item[i-1].selected = false
			fillControls()
			updaterollRenamer()
		)
		
		on btnSelInvert pressed do
		(
			for i=1 to lvNaming.items.count do lvNaming.items.item[i-1].selected = not lvNaming.items.item[i-1].selected 
			fillControls()
			updaterollRenamer()
		)

		on chkSortByType changed val do
		(
			sortListNames()
			restoreSelection()			
		)

		on btnConvert pressed do
		(
			lv = lvNaming
			for i = 1 to lv.selectedItems.count do
			(
				index = lv.selectedItems.item[i-1].index + 1
				
 				if (not lb.nc.ncOK lv.selectedItems.item[i-1].text) and ((filterstring listNames[index].name "_").count != 7) then -- solo convertimos si no se cumple el NC
				(
					n = lv.selectedItems.item[i-1].text
					
					-- eliminamos los posibles "_" que pueda tener el nombre
					nAux =removeString n "_"
					
					bipBone = (classof objects[listNames[index].index].controller == bipSlave_control) or (classof objects[listNames[index].index].controller == vertical_horizontal_turn)

					if not bipBone then
						nAux = "aaa_aaa_aaa_x_" + nAux + "_x_x"
					else
					(
						n2 = "chr_aaa_bip"
						if findString nAux " l " != undefined then 
							n2 += "_r_"
						else if findString nAux " r " != undefined then 
									n2 += "_r_"
								else
									n2 += "_m_"
						n2 += nAux + "_x_x"
						nAux = n2
					)					
					
					listNames[index].name = nAux
					newNames[listNames[index].index] = nAux
					lv.selectedItems.item[i-1].text = nAux
				)	
			)
			--sortListNames()
			restoreSelection()
			fillControls()
		)

		on btnGetSelection pressed do
		(
			for i=1 to listNames.count do
				lvNaming.items.item[i-1].selected = objects[listNames[i].index].isSelected

			fillControls()
		)

		on btnSelNonNC pressed do
		(
			for i=1 to listNames.count do
				lvNaming.items.item[i-1].selected = not lb.nc.ncOK lvNaming.items.item[i-1].text

			fillControls()
		)

		on btnOk pressed do
		(
			undo "NC rename" on
			(
				for i=1 to objects.count do objects[i].name = newNames[i]
			)
			try destroydialog lb.renamer catch()
			destroydialog rollMainDef
		)

		on btnCancel pressed do
		(
			try destroydialog lb.renamer catch()
			destroydialog rollMainDef		
		)

		on btnHelpType pressed do showHelp #type
		on btnHelpEntity pressed do showHelp #entity
		on btnHelpClass pressed do showHelp #class
		on btnHelpLocation pressed do showHelp #location
		on btnHelpNombre pressed do showHelp #name
		on btnHelpSpecial pressed do showHelp #special
		on btnHelpFlags pressed do showHelp #flags
		on btnHelpGeneral pressed do showHelp #general
		
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

			edtName.backColor = txtColorBg
			edtEntityName.backColor = txtColorBg
			edtName.name = "edtName"
			edtEntityName.name = "edtEntityName"

			if lb.renamer != undefined and lb.renamer.isOpen() then lb.renamer.close()

			initNames()
			resetListView()

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
	--@struct: namingConventionChecking | Contiene la herramienta namingConventionChecking.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_namingConventionChecking
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool plantilla",		--@var: description | Descripcion de la tool.
		
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
		rollNChelp = rollNChelpDef,	
		rollNCflagsManager = undefined,

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
	)--tl_namingConventionChecking
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_namingConventionChecking() --crea la herramienta
)