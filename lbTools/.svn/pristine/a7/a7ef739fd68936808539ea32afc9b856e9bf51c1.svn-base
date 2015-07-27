------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta poseManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta poseManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Pose Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 570		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 695		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local iconpath = if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/" --ruta de los iconos de Max.		
		local assetPoseFolder	 = "pose\\"
			
		--expand-contract------------------------------------------------------------------
		local expanded				= true			-- flag para undicar si el ui esta expandido o contraido
		
		local expanding				= false			-- flag para saber si se esta haciando expand o contract con el boton
		local expandWidth			= 570			-- anchura del rollout expandido
		local minWidth				= 160			-- anchura minima del rollout
		local minResize				= 300			--anchura minima de redimensionado a mano
		
		local expandHeight			= 545			-- altura del rollout expandido
		local minHeight				= 695--645			-- altura minima del rollout
		
		local foldersListHeight		= 114				-- altura minima del listado de folders
		local foldersListPosY		= 50				--posicion inicial del listado de folders
		
		local categoryListHeight	= 85			-- altura minima del listado de categorias
		local categoryListPosY		= 205			-- posicion inicial del listado de categorias
		
		local poseListHeight			= 100			-- altura minima del listado de poses
		local poseListPosY			= 310			-- posicion inicial del listado de poses

		--assets and folders-----------------------------------------------------------------
		struct pose
		(
			name				= "",				--nombre abreviado de la pose
			category		= "",				--categoria de la pose
			fullname			= "",				--nombre completo de la pose
			file				= "",				--ruta del archivo de la pose
			thumbnailFile	= ""				--ruta del archivo de la imagen de la pose
		)
		
		local animAssets	= #()				--almacena los assets animables detectados en la escena
		
		local lastAddedFolder = ""				--almacena el ultimo folder añadido
		local addedFolders = #()				--almacena los folders que se van añadiendo
		local poseFolders = #()				--almacena la ruta de todas las carpetas de poses (de assets de la escena, locaFlolder y addedFolders)
		local poseFoldersOwners = #()		--almacena el nombre del listview asociado a cada poseFolders
		
		local clipboardObj = dotNetClass "System.Windows.Forms.Clipboard"  -- crea un clipboard de puntonet
		
		local poseFoldersColor = (dotNetClass "System.Drawing.Color").fromargb 235 150 95
		local addedFoldersColor = (dotNetClass "System.Drawing.Color").fromargb 240 195 125
		
		--array con las categorias que tiene que tener obligatoriamente cada folder
		local standarCategories = #("all", "body","hands","facial","lipsync")
		local standarCategoriesColors = #((dotNetClass "System.Drawing.Color").fromargb 116 140 243, \
													(dotNetClass "System.Drawing.Color").fromargb 211 107 86, \
													(dotNetClass "System.Drawing.Color").fromargb 231 140 60, \
													(dotNetClass "System.Drawing.Color").fromargb 235 199 55, \
													(dotNetClass "System.Drawing.Color").fromargb 253 255 101)
		local customCategories = #() --array con las categorias que no pertenecen a las estandar encontradas en los folders
		--array de colores de las categorias no estandar, supondremos un maximo de 12 categorias personalizadas simultaneas, con lo cual necesitamos un gradiente de 20 colores
		local customCategoriesColors = #( (dotNetClass "System.Drawing.Color").fromargb 192 237 97 , \
														(dotNetClass "System.Drawing.Color").fromargb 130 208 60 , \
														(dotNetClass "System.Drawing.Color").fromargb 82 171 107 , \
														(dotNetClass "System.Drawing.Color").fromargb 81 202 186 , \
														(dotNetClass "System.Drawing.Color").fromargb 67 167 204 , \
														(dotNetClass "System.Drawing.Color").fromargb 59 115 179 , \
														(dotNetClass "System.Drawing.Color").fromargb 67 167 204 , \
														(dotNetClass "System.Drawing.Color").fromargb 81 202 186 , \
														(dotNetClass "System.Drawing.Color").fromargb 82 171 107 , \
														(dotNetClass "System.Drawing.Color").fromargb 130 208 60  )
			
		local poseCategories = #()			--array de arrays con las categorias de poses encontradas en cada folder
		local poses = #()						--array de arrays de arrays con las poses de cada categoria de cada folder
		
		local actualCategories = #()			--array con todas las categorias de los folders seleccionados
		local actualCategoriesPoses = #()	--array con todas las poses de todas las categorias de los folders seleccionados
		
		local actualPoses = #()				--array con las poses de las categorias seleccionadas de los foldes seleccionados
		local selectedPose = undefined		--pose seleccionada actualmente	
		--old selected vars-----------------------------------------------------------------------
		local oldSelectedFolders = #()		--ultimos folders seleccionados del listview de folders
		local oldSelectedCategories = #()	--ultimas categorias seleccionada del listView de catagorias
		local oldSelectedPoses = #()		--ultimas poses seleccionada del listView de poses
		
		--cell vars---------------------------------------------------------------------------
		local oldGridWidth = 0	--ultima anchura del grid despues de redimensionarlo	
			
		local cellWidth = 136--130			--anchura de una celda
		local cellHeight = 136--130			--anchura de una celda
		local numColumns = 0			--numero de columnas del grid
		local numRows = 0				--numero de filas del grid
		local titleCellHeight = 25		--altura de las celdas de titulo de categoria
		
		local lastScrollOffset = 0 --ultimo offset de scroll realizado
			
		--colors------------------------------------------------------------------------------
		local lvBackColor = (dotNetClass "System.Drawing.Color").beige--Gray				-- fondo del listView
		local lvForeColor = (dotNetClass "System.Drawing.Color").black				-- texto del listView
		local lvSelBackColor = (dotNetClass "System.Drawing.Color").midnightblue	-- fondo de items seleccionados
		local lvSelForeColor = (dotNetClass "System.Drawing.Color").white			-- texto de items seleccionados

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label edtInfoTitle "Info:" pos:[5,2] width:25 height:15
		editText edtInfo "" pos:[35,2] width:535 height:15 readOnly:true
		
		button btnAssetIcon ":)" pos:[5,20] width:25 height:25 --images:#(iconpath + "bip_general_i.bmp", undefined, 30, 5, 5, 6, 6,true) toolTip:"change local folder"
		checkbox chkSyncronize "sync" pos:[35,30] width:50 height:15 checked:false toolTip:"syncronize with selected asset"
		button btnRefresh "Refresh" pos:[85,25] width:50 height:20
		
		dotNetControl lvPoseFolders "system.windows.forms.listView" pos:[5,50] width:130 height:114 --height:60
		
		button btnAddPoseFolder "" pos:[5,164] width:20 height:20 images:#(iconpath + "parameterCollector_i.bmp", undefined, 28, 7, 7, 7, 7,true) toolTip:"Add pose folder"	
		button btnDeletePoseFolder "" pos:[25,164] width:20 height:20 images:#(iconpath + "MeditTools_i.bmp", undefined, 44, 7, 7, 8, 8,true) toolTip:"Remove pose folder"	
					
		label lblCategories "Categories:" pos:[5,190] width:130 height:15
		dotNetControl lvCategories "System.Windows.Forms.listView" pos:[5,205] width:130 height:86 --height:100
		
		label lblPoses "Poses:" pos:[5,295] width:50 height:15
		label lblNumPoses "numPoses: 0" pos:[60,295] width:80 height:15
		dotNetControl lvPoseList "System.Windows.Forms.listView" pos:[5,310] width:130 height:100--height:140
		
		label lblCategoryTitle "Edit pose parameters:" pos:[5,415] width:130 height: 15
		label lblCategory "ctgry:" pos:[5,432] width:50 height:15
		dotNetControl ddlPoseCategory "System.Windows.Forms.ComboBox" pos:[39,430] width:96 height:20
		editText edtPoseName "name:" pos:[5,452] height:15 fieldWidth:96
		bitmap bmpSelectedPose "Bitmap" pos:[5,470] width:130 height:130
		button btnCaptureThumbnail "Img" pos:[7,573] width:25 height:25 images:#(iconpath + "TrackViewTools_24i.bmp", undefined, 115, 43, 41, 42, 42,true) toolTip:"capture thumbnail from viewport"
		button btnPrevPose "<" pos:[5,600] width:45 height:15
		button btnNextPose ">" pos:[90,600] width:45 height:15
		spinner spnJumpInterval "" pos:[49,600] width:40 height:14 range:[0,10000,1] scale:1 type:#integer
		
		button btnGetPose					"G" pos:[5,620]		width:20 height:20 tooltip:"Get Pose from selected objects" images:#(iconpath + "bip_copypaste_i.bmp", undefined, 24, 1, 1, 2, 2,true)
		button btnDeletePose				"X" pos:[25,620]		width:20 height:20 images:#(iconpath + "MeditTools_i.bmp", undefined, 44, 7, 7, 8, 8,true) toolTip:"Remove Pose"	
		button btnApplyPose				"A" pos:[50,620]		width:20 height:20 tooltip:"Apply Pose to selected objects" images:#(iconpath + "bip_copypaste_i.bmp", undefined, 24, 11, 11, 12, 12,true)
		button btnApplyPoseOpposite	"O" pos:[70,620]		width:20 height:20 tooltip:"Apply Pose to selected objects opposites" images:#(iconpath + "bip_copypaste_i.bmp", undefined, 24, 13, 13, 14, 14,true)
		button btnReplacePose				"Replace" pos:[95,620]		width:40 height:20 tooltip:"Replace Actual Pose from selected objects" --images:#(iconpath + "bip_copypaste_i.bmp", undefined, 24, 3, 3, 4, 4,true)
		
		groupBox grpPasteOptions "paste options" pos:[5,640] width:130 height:50
		checkbox chkIncludeRoot "include root/base" pos:[10,655] width:100 height:15 checked:false toolTip:"include root/base"
		checkbox chkSelectedOnly "selected only" pos:[10,670] width:100 height:15 checked:false toolTip:"applies pose to selected objects only"
		
		dotNetControl btnExpand "System.Windows.Forms.Button" pos:[555,20] width:15 height:620
		dotNetControl dgPoses "System.Windows.Forms.DataGridView" pos:[140,20] width:410 height:620
		
		groupBox grpSeparator "" pos:[140,20] width:1 height:620 visible:false
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------

		---------------------------------------------------------------------------
		--obtiene el lado predominante de las piezas pasadas por parametro
		--#R si hay mas piezas de lado derecho
		--#L de izquierdo
		--#M centrales o indeterminadas
		---------------------------------------------------------------------------
		fn getSideFromNodes nodes =
		(
			side = #M
			
			rCont = 0
			lCont = 0
			mCont = 0
			
			if classof nodes == Array then
				for n in nodes where lb.nc.ncOK n.name do
				(
					nParts = filterString n.name "_"
					
					case nParts[4] of
					(
						"r":	rCont += 1
						"l":	lCont += 1
						"m":	mCont += 1
						"x":	mCont += 1
					)
				)
			
			if rCont > lCont and rCont > mCont then side = #R
			else if lCont > rCont and lCont > mCont then side = #L
				
			side
		)

		---------------------------------------------------------------------------
		--obtiene el numero de columas que caben el el grid
		---------------------------------------------------------------------------
		fn getNumColumns =
		(
			local newNumColumns = numColumns
			
			gridWidth = dgPoses.width --obtiene el ancho actual del grid
			oldGridWidth = gridWidth --almacena el nuevo ancho
			newNumColumns = gridWidth/(cellWidth + 5) --calcula las columnas que caben
			
			newNumColumns
		)

		---------------------------------------------------------------------------
		--obtiene los folders con poses de los assets de la escena
		---------------------------------------------------------------------------
		fn getPoseFoldersFromAssets assets extraFolders:#() poseSubPath:"pose\\" =
		(
			folders = #() --array donde almacenar todos las rutas diferentes de los assets
							
			for ast in assets do --recorre los assets
				if ast.folder != "" then
					appendIfUnique folders (ast.folder + poseSubPath)
			
			for added in extraFolders do
				appendIfUnique folders added
				
			folders
		)

		---------------------------------------------------------------------------
		--obtiene el nombre del asset deonde esta el folder, para poder ponerlo en el listview
		---------------------------------------------------------------------------
		fn getPoseFoldersOwners folders poseSubPath:"pose\\" =
		(
			owners = #()
			
			for folder in folders do
			(
				pspParts = filterString poseSubPath "\\"
				
				for pspPart in pspParts do
					folder = substituteString folder pspPart ""
				
				parts = filterString folder "\\"
				append owners parts[parts.count]
			)
			
			owners
		)

		------------------------------------------------
		--SETS
		------------------------------------------------

		---------------------------------------------------------------------------
		--actualiza el interface con la informacion de la pose seleccionada
		---------------------------------------------------------------------------
		fn setSelectedPose =
		(
			if oldSelectedPoses.count != 0 then
			(
				--obtiene la pose seleccionada------------------------------------------------------
				selectedPose = undefined
				selectedPose = actualPoses[oldSelectedPoses[1] + 1] --almacena la pose
				
				if selectedPose != undefined then
				(
					--actualizacion del interface-------------------------------------------------------
					ddlPoseCategory.text = selectedPose.category
					ddlPoseCategory.items.clear()
					--rellena el listado de categorias
					for i=2 to actualCategories.count do
						ddlPoseCategory.items.add actualCategories[i]
					
					edtPoseName.text = selectedPose.name
					
					if selectedPose.thumbnailFile != "" then
						bmpSelectedPose.fileName = selectedPose.thumbnailFile
					else
						bmpSelectedPose.bitmap = (bitmap 130 130 color:gray)
					
					btnCaptureThumbnail.visible = true --para que no quede por debajo del thumbnail
					
					spnJumpInterval.value = (oldSelectedPoses[1] + 1)
					---------------------------------------------------------------------------------------
				)
			)
			else
			(
				selectedPose = undefined
				ddlPoseCategory.text = ""
				ddlPoseCategory.items.clear()
				edtPoseName.text = ""
				bmpSelectedPose.bitmap = (bitmap 130 130 color:gray)
				btnCaptureThumbnail.visible = true --para que no quede por debajo del thumbnail
				spnJumpInterval.value = 1
			)
		)

		------------------------------------------------
		--OTHER
		------------------------------------------------

		---------------------------------------------------------------------------
		--inicializa el listview pasado por parametro
		---------------------------------------------------------------------------
		fn initListView lv =
		(
			lv.clear()
			
			lv.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = lvBackColor
			lv.foreColor = lvForeColor
			lv.scrollable = true
			lv.labelEdit = true
			--lv.hideSelection = false
			lv.labelEdit = false
			lv.headerStyle = None
			
			lv.columns.add "" (lv.width - 20)
		)	

		---------------------------------------------------------------------------
		--inicializa el gridview
		---------------------------------------------------------------------------
		fn initGridView =
		(
			dgPoses.rows.clear()
			dgPoses.columns.clear()
			
			dgPoses.allowUsertoaddRows = false
			dgPoses.allowUserToResizeRows = false
			dgPoses.allowUserToResizeColumns = false
			
			dgPoses.ColumnHeadersVisible = false	--para que las colunas no tengan titulo
			dgPoses.rowheadersvisible = false		--para que las filas no tengan titulo
			
			dgPoses.foreColor = (dotNetClass "System.Drawing.Color").black
			dgPoses.backgroundcolor = lvForeColor --lvBackColor						-- color del fondo
			dgPoses.rowsdefaultcellstyle.backcolor = lvForeColor --lvBackColor	-- color por defecto de las celdas
			dgPoses.GridColor = (dotNetClass "System.Drawing.Color").black
								
			dgPoses.readonly = true
			dgPoses.showCellTooltips = false
		)	

		---------------------------------------------------------------------------
		--decide si habilitar o deshabilitar la opcion de obtener pose
		---------------------------------------------------------------------------
		fn enableDisableGetPose =
		(
			local enable1 = false --Flag que sólo es verdad si solo hay un asset seleccionado y si su nombre coincide con el de la carpeta actualmente seleccionada en la herramienta.
			local enable2 = false --Flag que sólo se activa si hay alguna pose seleccionada.
			
			nodes = getCurrentSelection()
			if nodes.count != 0 then --si hay piezas seleccionadas en la escena
			(
				--comprueba que solo hay un folder, una categoria y una pose seleccionada
				if oldSelectedFolders.count == 1 and oldSelectedCategories.count == 1 then
				(
					tempAssets = lb.asset.getAssetsFromNodes nodes
					selectedAssets = #()
					
					--recopila los assets principales a los que pertenece la seleccion
					for ast in tempAssets do --recopila los assets seleccionados
					(
						add = true
						
						if ast.isDependent then --si el asset es dependiente solo lo añade si su asset principal no esta seleccionado
						(
							add = true
							for a in tempAssets where (a.fullname == ast.mainAsset) do
								add = false
						)		
						
						if add then
							appendIfUnique selectedAssets ast
					)--for
					
					--si solo hay un asset seleccionado
					if selectedAssets.count == 1 then
					(
						--si el asset seleccionado coincide con el folder seleccionado en la lista
						if lvPoseFolders.items.item[oldSelectedFolders[1]].text == selectedAssets[1].fullName then
							enable1 = true
						else --sino comprobamos que no sea otro asset el que esta seleccionado
						(
							folderParts = filterString (lvPoseFolders.items.item[oldSelectedFolders[1]].text) "_"
							
							if folderParts.count < 2 or folderParts.count > 2 then --si es un folder personalizado
								enable1 = true
							else if folderParts[1] == lb.nc.NC_chrPrefix or folderParts[1] == lb.nc.NC_prpPrefix or folderParts[1] == lb.nc.NC_sprPrefix then --si no es otro asset
								enable1 = true								
						)--if4
					)--if3
				)--if2
			) --si no hay seleccionado nada en la escena, comprueba que solo hay un folder, una categoria y una pose seleccionada
			-- 				else if oldSelectedFolders.count == 1 and oldSelectedCategories.count == 1 and oldSelectedPoses.count == 1 then
			-- 					enable1 = true
			
			if oldSelectedPoses.count != 0 then
				enable2 = true
			
			--btnGetPose.enabled					= enable1
			
			btnCaptureThumbnail.enabled 	= enable2				
			btnNextPose.enabled				= enable2
			btnPrevPose.enabled				= enable2
			spnJumpInterval.enabled			= enable2
			ddlPoseCategory.enabled			= enable2
			edtPoseName.enabled				= enable2
			btnDeletePose.enabled				= enable2
			btnApplyPose.enabled				= enable2 
			btnApplyPoseOpposite.enabled	= enable2 
			btnReplacePose.enabled			= enable2
			--btnApplyPoseSymmetry.enabled	= enable2
		)

		---------------------------------------------------------------------------
		--actualiza la informacion del label INFO
		---------------------------------------------------------------------------
		fn updateInfo =
		(
			info = ""
			
			if oldSelectedFolders.count != 0 then
			(
				--buscamos el folder al que pertenece la pose
				info += poseFoldersOwners[oldSelectedFolders[1] + 1] + " -> " + poseFolders[oldSelectedFolders[1] + 1]
				
				if oldSelectedCategories.count != 0 then
				(
					if selectedPose != undefined then --buscamos la categoria y la pose
					(
						info += "   || category: " + selectedPose.category
						info += "   || pose: " + selectedPose.fullName
					)
					else if (oldSelectedCategories[1] + 1) <= actualCategories.count then --busca la categoria
					(
						info += "   || category: " + actualCategories[oldSelectedCategories[1] + 1]
					)--if selectedPose
				)--if oldSelectedCategories
			)--if oldSelectedFolders
			
			edtInfo.text = info
		)

		---------------------------------------------------------------------------
		--actualiza el icono del folder seleccionado
		---------------------------------------------------------------------------
		fn updateFolderOwnerIcon folder poseSubPath:"pose\\" iconSubPath:"image\\icon\\"=
		(
			icons = undefined
			
			btnAssetIcon.images = undefined
			
			if classof folder == String then
			(					
				pspParts = filterString poseSubPath "\\"
						
				for pspPart in pspParts do
					folder = substituteString folder pspPart ""
				
				parts = (filterString folder "\\")
				searchString = (folder + iconSubPath + parts[parts.count] + "_icon*" + ".*")
				icons = (getFiles searchString)
				
				if icons.count != 0 then
					btnAssetIcon.images = #(icons[1], icons[2], 1, 1, 1, 1, 1)
			)
			
			icons
		)

		---------------------------------------------------------------------------
		--obtiene la informacion de los folders de los assets de la escena
		--tambien del folder local y de los folders añadidos
		--obtiene las categorias de poses de cada folder
		--obtiene las poses de cada categoria de cada folder
		---------------------------------------------------------------------------
		fn fillFoldersCategoriesPosesInfo =
		(
			customCategories = #()
			animAssets = lb.asset.getSceneAnimAssets()
			poseFolders = getPoseFoldersFromAssets animAssets extraFolders:addedFolders poseSubPath:assetPoseFolder
			poseFoldersOwners = getPoseFoldersOwners poseFolders poseSubPath:assetPoseFolder
			
			--elimina los duplicados, es decir, si un folder añadido a mano coincide en nombre con uno perteneciente a un asset de la escena lo quita del listado
			for i = poseFolders.count to 1 by -1 do --recorre los folders en orden contrario
			(
				index = findItem poseFoldersOwners poseFoldersOwners[i]
				
				if index != i then --si esto ocurre es que esta repetido y hay que eliminarlo
				(
					deleteItem poseFolders i
					deleteItem poseFoldersOwners i
				)
			)
			
			for i=1 to poseFolders.count do --recorre cada folder buscando sus categorias y sus poses
			(
				folder = poseFolders[i] --almacena el folder actual en una variable para que sea mas comodo
				
				poseCategories[i] = deepCopy standarCategories --añade las categorias estandar al array de categorias del folder
				poses[i] = #()
				for j=1 to poseCategories[i].count do	poses[i][j] = #() --inicializa los arrays de poses vacios
					
				allPoses = getFiles (folder + "*.pos") --obtiene todas las poses almacenadas en folder
									
				for ps in allPoses do --recorre las poses encontradas en la ruta y las procesa como struct pose
				(
					nameParts = filterString ps "\\"
					nameParts = nameParts[nameParts.count]
					nameParts = filterString (substituteString nameParts ".pos" "") "_"
					
					------------------------------------------------------------------------------
					--aqui va el codigo que extrae la informacion de los valores de la pose--
					------------------------------------------------------------------------------
						
					--nueva pose procesada
					newPose = (pose name:nameParts[2] category:nameParts[1] fullname:(nameParts[1] + "_" + nameParts[2]) file:ps)
					
					--obtiene el thumbnail de la pose
					thumbnail = (getFiles (substituteString ps ".pos" ".jpg"))[1]
					if thumbnail != undefined then newPose.thumbnailFile = thumbnail
					
					
					--añade la pose a la categoria que le corresponda, si la categoria es nueva, añade primero la categoria---------
					if poseCategories[i][1] == "all" then
						append poses[i][1] newPose
					
					index = findItem poseCategories[i] newPose.category
					
					if index != 0 then
						append poses[i][index] newPose
					else
					(
						append poseCategories[i] newPose.category
						poses[i][(poseCategories[i].count)] = #()
						
						append poses[i][(poseCategories[i].count)] newPose
						
						appendIfUnique customCategories newPose.category --añade la categorias nueva al array de categorias personales
					)				
					------------------------------------------------------------------------------------------------------------------------
				)--for allPoses
				
				customCategories = sort customCategories
			)--for poseFolders 
		)

		---------------------------------------------------------------------------
		--funcion que compara dos poses
		--devuelve 0 si tienen mismo nombre (fullname) y mismo file
		--devuelve -1 si p1 va antes alfabeticamente que p2, si fullname es igual entonces se fija en file para ordenarlos alafabeticamente
		---------------------------------------------------------------------------
		fn comparePoses p1 p2 =
		(
			if p1.fullName < p2.fullname then
				-1
			else if p1.fullName > p2.fullname then
				1
			else
			(
				if p1.file < p2.file then
					-1
				else if p1.file > p2.file then
					1
				else
					0
			)
		)	

		---------------------------------------------------------------------------
		--mira que folders estan seleccionados y obtiene sus categorias y sus poses y las fusiona
		---------------------------------------------------------------------------
		fn fillActualCategoriesAndPoses =
		(
			specialCategories = #()
			
			for index in oldSelectedFolders do --recorre los folders seleccionados obteniendo sus categorias
				for cat in poseCategories[index+1] do
					if findItem standarCategories cat == 0 then appendIfUnique specialCategories cat
				
			actualCategories = join (deepCopy standarCategories) (sort specialCategories)
			actualCategoriesPoses = #()
			for i=1 to actualCategories.count do actualCategoriesPoses[i] = #()
			
			for index in oldSelectedFolders do --recorre los folders seleccionados obteniendo sus poses
				for i=2 to poses[index+1].count do --no tenemos en cuenta las categorias all para no repetir poses
					for ps in poses[index+1][i] do
					(
						catIndex = findItem actualCategories ps.category
						
						if catIndex != 0 then
						(
							append actualCategoriesPoses[1] ps
							append actualCategoriesPoses[catIndex] ps
						)
					)
					
			--for i=2 to actualCategoriesPoses.count do --ordena las poses alfabeticamente
			--	qsort actualCategoriesPoses[i] comparePoses		
		)

		---------------------------------------------------------------------------
		--mira que categorias estan seleccionadas y obtiene sus poses y las fusiona
		---------------------------------------------------------------------------
		fn fillActualPoses =
		(
			actualPoses = #()
			
			if oldSelectedCategories.count != 0 then --si hay categorias seleccionadas
				if oldSelectedCategories[1] == 0 then --si la categoria seleccionada es la que engloba todas
					actualPoses = actualCategoriesPoses[1]
				else --sino, recorre las categorias recopilando sus poses
				(
					for cat in oldSelectedCategories do
						actualPoses = join actualPoses actualCategoriesPoses[cat+1]
					
					--qsort actualPoses comparePoses --rodena las poses alfabeticamente
				)			
		)	

		---------------------------------------------------------------------------
		--rellena el listView de posFolders
		---------------------------------------------------------------------------
		fn fillLvPoseFolders =
		(
			initListView lvPoseFolders
			
			for f in poseFoldersOwners do
			(
				row = dotNetObject "System.Windows.Forms.ListViewItem" f
				--row.UseItemStyleForSubItems = false --hace que el color de cada celda pueda ser diferente
				lvPoseFolders.items.add row
			)
			
			if lvPoseFolders.items.count != 0 then
			(
				index = 0
				
				lvPoseFolders.items.item[index].selected = true
				updateFolderOwnerIcon poseFolders[index + 1]
			)
			
			if poseFolders.count != 0 then
				lastAddedFolder = poseFolders[poseFolders.count]
		)

		---------------------------------------------------------------------------
		--rellena el listview de categorias
		---------------------------------------------------------------------------
		fn fillLvCategories =
		(
			initListView lvCategories --limpiamos el listado de categorias
			
			for cat in actualCategories do
				lvCategories.items.add (dotNetObject "System.Windows.Forms.ListViewItem" cat)
			
			if lvCategories.items.count != 0 then
				lvCategories.items.item[0].selected = true
			
			if actualCategoriesPoses.count != 0 then
				if actualCategoriesPoses[1].count == 0 then --si no hay poses entonces hay que limpiar tambien el listado de poses
				(
					initListView lvPoseList --limpiamos el listado de poses
					oldSelectedPoses = #() --limpia el array de las poses seleccionadas con anterioridad
					setSelectedPose() --actualiza el interface para limpiarlo
				)	
		)

		---------------------------------------------------------------------------
		--rellena el listview de poses
		---------------------------------------------------------------------------
		fn fillLvPoses =
		(
			initListView lvPoseList --limpiamos el listado de poses
			
			for pos in actualPoses do
				lvPoseList.items.add (dotNetObject "System.Windows.Forms.ListViewItem" pos.fullName)
			
			if lvPoseList.items.count != 0 then
				lvPoseList.items.item[0].selected = true
			else
				oldSelectedPoses = #()
			
			lblNumPoses.caption = ("numPoses: " + actualPoses.count as string)
			--setSelectedPose() --actualiza el interface con la pose seleccionada
		)

		---------------------------------------------------------------------------
		--funcion que lanza cada vez que pulsemos uno de los controles del grid
		--actualiza la pose seleccionada en el UI
		---------------------------------------------------------------------------
		fn updateSelectedPose =
		(
			selectedIndex = -1  --indice de la pose correspondiente al control seleccionado
			
			stop = false
			cont = 2
			--Iteramos hasta que encotramos el índice del elemento seleccionado y lo almacenamos en selectedIndex
			while not stop and cont < dgPoses.controls.count do --busca ese indice
			(
				if dgPoses.controls.item[cont].focused then
				(
					selectedIndex = cont - 1
					
					stop = true
				)
				
				cont +=1
			)	
			
			--Deseleccionamos todos los elementos
			for i=1 to dgPoses.rows.count do
				for j = 1 to dgPoses.columns.count do
					(dgPoses.item (j-1) (i-1)).selected = false
			
			--Si no hemos encontrado ningún índice ponemos selectedIndex a 1
			if selectedIndex < 0 then
				selectedIndex = 1
			
			row = (selectedIndex - 1)/numColumns + 1
			col = selectedIndex - ((row - 1)*numColumns)
			
			--Seleccionamos la pose a partir de selectedIndex
			(dgPoses.item (col - 1) (row*2 - 2)).selected = true
			(dgPoses.item (col - 1) (row*2 - 1)).selected = true
			
			lvPoseList.items.item[oldSelectedPoses[1]].selected = false
			--Almacenamos los seleccionados en un array
			oldSelectedPoses = #((selectedIndex - 1))
			lvPoseList.items.item[selectedIndex - 1].selected = true
			lvPoseList.ensureVisible (selectedIndex - 1)
			setSelectedPose()
			--enableDisableGetPose() --hace que se pierda el evento, falla
			updateInfo()
		)

		---------------------------------------------------------------------------
		--rellena el gridview con las poses
		---------------------------------------------------------------------------
		fn updateGridView resizing:false =
		(
			newNumColumns = getNumColumns()
			numPoses = actualPoses.count
			numColumnsChanged = false
			
			if (numPoses == 0) then --si no hay poses
			(
				--print "opcion 1"
									
				dgPoses.rows.clear() --limpia las filas
				dgPoses.columns.clear() --limpia las columnas
				
				for i=2 to dgPoses.controls.count - 1 do
				(
					poseControl = dgPoses.controls.item[i]
					poseControl.text = ""
					poseControl.backColor = lvForeColor--lvBackColor
					poseControl.location.x = 10000
					poseControl.location.y = 10000
				)
				
			)
			else if rollMainDef.width >= minResize then
			(
				--print "opcion 2"
				
				numControls = dgPoses.controls.count - 2
				if dgPoses.columns.count == 0 then numColumns = 0
				
				if ((newNumColumns != numColumns)) then --cambia el numero de columnas que caben
				(
					--print "el numero de columnas que caben ha cambiado"
					
					dgPoses.rows.clear() --limpia las filas
					dgPoses.columns.clear() --limpia las columnas
					numColumns = newNumColumns --numero de columnas
					
					for i=1 to numColumns do --añade las columnas
					(
						dgPoses.columns.add (dotnetobject "System.Windows.Forms.DataGridViewImageColumn")
						dgPoses.columns.item[i-1].width = cellWidth + 5
					)
					
					numColumns = newNumColumns --almacena el nuevo numero de columnas
					numColumnsChanged = true
				)
				
				if numControls != numPoses then --si el numero de controles creados es diferente al numero de poses
				(
					--print "numero diferente de poses"
					
					if numControls < numPoses then
					(
						--print "menos controles que poses"
						numNewControls = numPoses - numControls --numero de controles que faltan
							
						for i=1 to numNewControls do --añada los controles que falten
						(
							newControl = dotnetobject "System.Windows.Forms.Label"
							dgPoses.controls.add newControl
							
							newControl.width = cellWidth - 6
							newControl.height = titleCellHeight - 5
							newControl.textAlign = (dotnetClass "System.Drawing.ContentAlignment").MiddleCenter 
							
							newControl = undefined
						)--for
					)--if menos controles que poses
				)--si el numero de controles es diferente al de poses
				
				numRows = dgPoses.rows.count --numero de filas
				--numCells = numRows*numColumns --numero de celdas
					
				numNeededRows = ((numPoses - 1)/numColumns) + 1 --numero necesario de filas para contener todas la poses
				
				if numRows < numNeededRows then --si faltan filas para poder rellenar todas las poses
				(
					start = if numRows != 0 then numRows + 1 else 1
					
					for i = start to numNeededRows do
					(
						row = (dotnetobject "System.Windows.Forms.DataGridViewRow")
						row.height = titleCellHeight + cellHeight
						row.defaultCellStyle.BackColor = lvForeColor--lvBackColor
							
						dgPoses.rows.add row
					)
				)
				else if numRows > numNeededRows then --si sobran filas
				(
					for i=(numRows - 1) to (numNeededRows) by -1 do
						dgPoses.rows.removeAt i
				)
				
				--rellena las celdas y los controles ---------------------------------
				
				numRows = dgPoses.rows.count --numero de filas
				numCells = numRows*numColumns --numero de celdas
				
				contTotal = 1
				contColumn = 1
				contRow = 0
				
				lastCat = "none"	--variable para detectar si cambiamos de categoria
				numCats = 0		--numero de categorias visualizadas hasta el momento
				actualColor = lvForeColor
				
				if (not resizing) or (resizing and numColumnsChanged) or expanding then
					for i=2 to dgPoses.controls.count - 1 do
					(
						poseControl = dgPoses.controls.item[i]
						poseControl.text = ""
						poseControl.backColor = lvForeColor--lvBackColor
						poseControl.location.x = 10000
						poseControl.location.y = 10000
					)
				
				lastScrollOffset = (dgPoses.VerticalScrollingOffset)
					
				while (contTotal <= numCells) do--actualPoses.count) do
				(
					row = dgPoses.rows.item[contRow] --obtiene la fila actual
					cell = (dgPoses.item (contColumn - 1) contRow)
					
					if actualPoses[contTotal] != undefined then
					(
						actualCat = actualPoses[contTotal].category
						
						if actualCat != lastCat then --hay cambio de categoria
						(
							numCats += 1
							lastCat = actualCat
							
							--actualiza el color que debe poner de fondo de las celdas
							index = findItem standarCategories actualCat
							if index != 0 then
								actualColor = standarCategoriesColors[index]
							else
							(
								index = findItem customCategories actualCat
								
								if index != 0 then
								(
									if index > 10 then index = (index - ((index/10)*10))
									actualColor = customCategoriesColors[index]
								)
							)
						)--if actual cat
						
						if (not resizing) or (resizing and numColumnsChanged) or expanding then
						(
							--label-----------------
							poseControl = dgPoses.controls.item[contTotal + 1]
							poseControl.backColor = actualColor
							poseControl.location.x = (contColumn - 1)*(cellWidth + 5) + 4 + 3
							poseControl.location.y = contRow*(cellHeight + titleCellHeight) + 4 - lastScrollOffset
							poseControl.text = actualPoses[contTotal].fullName
							
							--cell.value = undefined
							--clipboardObj.clear()
							--setClipboardBitmap (b = bitmap 130 130 color:gray)
							--cell.value = clipboardObj.GetImage() -- recupera la imagen del clipboard y la pone en el control

							--celda-----------------
							if openBitMap (actualPoses[contTotal].thumbnailFile) != undefined then
							(
								clipboardObj.clear()
								setClipboardBitmap (openBitMap (actualPoses[contTotal].thumbnailFile)) --mete un bitmap de maxscript en el clipboard
								--print "1"
								--print (actualPoses[contTotal].thumbnailFile)
								
								--_thumbnail = dotnetObject "System.Drawing.Bitmap" (actualPoses[contTotal].thumbnailFile) ((NO VA, se carga ))
							)
							else
							(
								clipboardObj.clear()
								--setClipboardBitmap (b = bitmap 130 130 color:gray)
								--print "2"
							)

							cell.value = clipboardObj.GetImage() -- recupera la imagen del clipboard y la pone en el control

							cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
							cellStyle.padding = (dotNetObject "System.Windows.Forms.Padding" 0 (titleCellHeight) 0 0)
							cellStyle.BackColor = actualColor
							cell.style = cellStyle
						)
						
					)--if pose not undefined
					else
					(
						if (not resizing) or (resizing and numColumnsChanged) or expanding then
						(
							setClipboardBitmap (bitmap 1 1 color:black) --mete un bitmap de maxscript en el clipboard
							--(cellWidth + 5) (titleCellHeight + cellHeight)
							--cell.value = undefined
							cell.value = clipboardObj.GetImage() -- recupera la imagen del clipboard y la pone en el control
							cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"
							cellStyle.BackColor = lvForeColor--lvBackColor
							cell.style = cellStyle
						)
					)--if pose undefined
					
					contTotal += 1 --incrementa el contador de poses añadidas
					contColumn += 1 --incrementa el contador de poses de cada fila
					
					if contColumn > numColumns then
					(
						contColumn = 1 --reinicia el contador para empezar una nueva fila
						contRow += 1 --incrementa una fila
					)--if
				)--while
				
			)		
		)

		---------------------------------------------------------------------------
		--actualiza el icono del folder seleccionado
		---------------------------------------------------------------------------
		fn updateLvPoseFolders =
		(	
			--if chkSyncronize.checked do
			--	syncronize()
			
			--cambio de seleccion
			--actualizacion de los colores del listado y guarda los indices seleccionados ---
			for i=1 to lvPoseFolders.items.count do
			(
				--lvPoseFolders.items.item[i-1].backColor = lvBackColor
				lvPoseFolders.items.item[i-1].foreColor = lvForeColor
				
				if findItem addedFolders poseFolders[i] != 0 then
					lvPoseFolders.items.item[i-1].backColor = addedFoldersColor					
				else
					lvPoseFolders.items.item[i-1].backColor = poseFoldersColor
			)
			
			selItems = lvPoseFolders.selectedItems
			oldSelectedFolders = #()
				
			for i=1 to selItems.count do
			(
				index = selItems.item[i-1].index
				lvPoseFolders.items.item[index].backColor = lvSelBackColor
				lvPoseFolders.items.item[index].foreColor = lvSelForeColor
					
				append oldSelectedFolders index --almacena el indice del folder seleccionado
			)
			--------------------------------------------------------------------------------------
			fillActualCategoriesAndPoses()	--actualiza las catagorias y las poses actuales en funcion de los folders seleccionados
			fillLvCategories()						--actualiza el listado de categorias
			updateInfo()							--actualiza el label Info con la informacion actual
			
			if oldSelectedFolders.count == 0 and lvPoseFolders.items.count != 0 then
				oldSelectedFolders = #(0)
			
			--actualizacion del icono				
			if oldSelectedFolders.count != 0 then
				updateFolderOwnerIcon poseFolders[oldSelectedFolders[1] + 1]
			else
				btnAssetIcon.images = undefined
			
			--actualizacion del grid
			if dgPoses.controls.count > 2 then
			(
				for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
					for j = 1 to dgPoses.columns.count do
						(dgPoses.item (j-1) (i-1)).selected = false
				
				if oldSelectedPoses[1] != undefined then
				(
					row = (oldSelectedPoses[1]/numColumns)
					col = oldSelectedPoses[1] - row*numColumns
					
					(dgPoses.item col row).selected = true
				)
			)
			
			enableDisableGetPose() --decide si debe estar habilitada la opcion de obtener pose
		)

		---------------------------------------------------------------------------
		--se asegura de que siempre haya una categoria seleccionada
		---------------------------------------------------------------------------
		fn updateLvCategories =
		(
			--cambio de seleccion
			
			--actualizacion de los colores del listado y guarda los indices seleccionados ---
			for i=1 to lvCategories.items.count do
			(
				lvCategories.items.item[i-1].backColor = lvBackColor
				lvCategories.items.item[i-1].foreColor = lvForeColor
				
				if i <= standarCategories.count then --si es una categoria estandard
					lvCategories.items.item[i-1].backColor = standarCategoriesColors[i]
				else --si es una categoria personalizada
				(
					index = i - standarCategories.count
					
					if index > 10 then
						index = (index - ((index/10)*10))
						
					lvCategories.items.item[i-1].backColor = customCategoriesColors[index]
				)
			)
			
			selItems = lvCategories.selectedItems
			oldSelectedCategories = #()
				
			for i=1 to selItems.count do
			(
				index = selItems.item[i-1].index
				lvCategories.items.item[index].backColor = lvSelBackColor
				lvCategories.items.item[index].foreColor = lvSelForeColor
					
				append oldSelectedCategories index --almacena el indice del folder seleccionado
			)
			--------------------------------------------------------------------------------------
			lastScrollOffset = 0 --resetea el offset de scroll para que no se descompense
			
			fillActualPoses()			--actualiza las poses actuales en funcion de las categorias seleccionadas
				fillLvPoses()				--actualiza el listado de poses
			setSelectedPose() 		--actualiza el ui con la pose seleccionada
			updateInfo()				--actualiza el label Info con la informacion actual
			updateGridView()			--actualiza el grid de poses
			
				
			--actualizacion del grid
			
			if oldSelectedCategories.count == 0 and lvCategories.items.count != 0 then
			(
				lvCategories.items.item[0].selected = true
				oldSelectedCategories = #(0)
			)
			
			if dgPoses.controls.count > 2 and actualPoses.count != 0 then
			(
				for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
					for j = 1 to dgPoses.columns.count do
						(dgPoses.item (j-1) (i-1)).selected = false
							
				(dgPoses.item 0 0).selected = true
				
			)
			
			enableDisableGetPose() --decide si debe estar habilitada la opcion de obtener pose
		)

		---------------------------------------------------------------------------
		--actualiza el interface con la pose seleccionada actualmente	
		---------------------------------------------------------------------------
		fn updateLvPoseList =
		(
			--cambio de seleccion
			numSelected = lvPoseList.selectedItems.count
			
			if numSelected > 1 then
			(
				firstIndex = lvPoseList.selectedItems.item[0].index
				for i=1 to lvPoseList.items.count do
					lvPoseList.items.item[i-1].selected = false
				lvPoseList.items.item[firstIndex].selected = true
			)
			
			--actualizacion de los colores del listado y guarda los indices seleccionados ---
			for i=1 to lvPoseList.items.count do
			(
				lvPoseList.items.item[i-1].backColor = lvBackColor
				lvPoseList.items.item[i-1].foreColor = lvForeColor
				
				index = findItem standarCategories actualPoses[i].category
					
				if index !=0 then --para categorias estandard
					lvPoseList.items.item[i-1].backColor = standarCategoriesColors[index]
				else --para categorias personalizadas
				(
					index = findItem customCategories actualPoses[i].category
					
					if index > 10 then index = (index - ((index/10)*10))
					
					if index != 0 then
						lvPoseList.items.item[i-1].backColor = customCategoriesColors[index]
				)
			)
			
			selItems = lvPoseList.selectedItems
			oldSelectedPoses = #()
				
			for i=1 to selItems.count do
			(
				index = selItems.item[i-1].index
				lvPoseList.items.item[index].backColor = lvSelBackColor
				lvPoseList.items.item[index].foreColor = lvSelForeColor
					
				append oldSelectedPoses index --almacena el indice de la pose seleccionada
			)
			--------------------------------------------------------------------------------------
			
			if oldSelectedPoses.count == 0 and lvPoseList.items.count != 0 then --si no habia pose seleccionada antes
			(
				lvPoseList.items.item[0].selected = true
				oldSelectedPoses = #(0)
			)
			
			--actualiza el grid
			if dgPoses.controls.count > 2 then
			(
				for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
					for j = 1 to dgPoses.columns.count do
						(dgPoses.item (j-1) (i-1)).selected = false
					
				if oldSelectedPoses.count != 0 then
				(					
					index = oldSelectedPoses[1]
					row = (index/numColumns)
					col = index - row*numColumns
					
					(dgPoses.item col (row)).selected = true
					dgPoses.CurrentCell = (dgPoses.item col row)
				)
			)
				
			setSelectedPose() --actualiza el interface con la pose seleccionada
			enableDisableGetPose() --decide si debe estar habilitada la opcion de obtener pose
			updateInfo()	--actualiza el label Info con la informacion actual
		)

		----------------------------------------------------------------------------------------------------------------
		--sincroniza las piezas seleccionadas de la escena con los assets seleccionados del listado
		--si cambia la seleccion de piezas en la escena se actualiza el asset seleccionado del listado
		----------------------------------------------------------------------------------------------------------------
		fn syncronize =
		(
			selectedAssets = lb.asset.getAssetsFromNodes (getCurrentSelection())
			selectedAssetsNames = #()
				
			for ast in selectedAssets do
				if ast.isDependent then
					appendIfUnique selectedAssetsNames ast.mainAsset
				else
					appendIfUnique selectedAssetsNames ast.fullName
			
			for i=1 to lvPoseFolders.items.count do
			(
				index = findItem selectedAssetsNames lvPoseFolders.items.item[i-1].text
				lvPoseFolders.items.item[i-1].selected = if index != 0 then true else false
			)
				
			-- 				--actualiza el icono
			-- 				index = oldSelectedFolders[1]
			-- 				folderForIcon = undefined
			-- 				
			-- 				if index != undefined then 
			-- 					folderForIcon = poseFolders[index + 1]
			-- 				
			-- 				updateFolderOwnerIcon folderForIcon
			-- 				
			-- 				if dgPoses.controls.count > 2 then
			-- 				(
			-- 					for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
			-- 						for j = 1 to dgPoses.columns.count do
			-- 							(dgPoses.item (j-1) (i-1)).selected = false
			-- 					
			-- 					if oldSelectedPoses[1] != undefined then
			-- 					(
			-- 						row = (oldSelectedPoses[1]/numColumns)
			-- 						col = oldSelectedPoses[1] - row*numColumns
			-- 						
			-- 						(dgPoses.item col row).selected = true
			-- 					)
			-- 				)
			-- 				
			-- 				enableDisableGetPose() --decide si se puede obtener o no una pose	

			updateLvPoseFolders()
			updateLvCategories()
			updateLvPoseList()	
		)

		----------------------------------------------------------------------------------------------------------------
		--crea el callback de cambio de sincronizacion
		----------------------------------------------------------------------------------------------------------------
		fn createSyncronizeChangeHandler =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.addscript #selectionSetChanged "lb.poseManager.rollMain.syncronize()" id:_id
		)
		
		----------------------------------------------------------------------------------------------------------------
		--crea el callback de cambio de seleccion
		----------------------------------------------------------------------------------------------------------------
		fn createSelectionChangeHandler = 
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.addscript #selectionSetChanged "lb.poseManager.rollMain.enableDisableGetPose()" id:_id 
		)

		fn refreshAllInfo =
		(
			lb.poseManager.rollMain.removeSceneEvents()
			dgc = dotnetclass "system.gc"
			dgc.collect()
			gc light:true

			--freescenebitmaps()
			--DESACTIVADO PORQUE SE CARGA LOS MATERIALES SSS EN VIEWPORT SI ESTAN POR XREF. HACE QUE NO SE VEAN LAS TEXTURAS DE LA PIEN EN VIEWPORT Y HAY QUE MERGEAR EL MATERIAL DE XREF PARA QUE VUELVA A VERSE.
			
			--Reinicializacion------------------------
			oldSelectedFolders = #()
			oldSelectedCategories = #()
			oldSelectedPoses = #()
			
			fillFoldersCategoriesPosesInfo()		--obtiene la informacionde folders, poseCategories y poses
			
			initGridView()
			
			fillLvPoseFolders()	--rellena el listado de folders
			updateLvPoseFolders()
			fillLvCategories()
			updateLvCategories()
			fillLvPoses()
			updateLvPoseList()
			
			
			if dgPoses.controls.count > 2 then
			(
				for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
					for j = 1 to dgPoses.columns.count do
						(dgPoses.item (j-1) (i-1)).selected = false
				
				if oldSelectedPoses[1] != undefined then
				(
					row = (oldSelectedPoses[1]/numColumns)
					col = oldSelectedPoses[1] - row*numColumns
					
					(dgPoses.item col (row)).selected = true
					--(dgPoses.item col (row*2)).selected = true
					--(dgPoses.item col (row*2 + 1)).selected = true
				)
			)
			
			if chkSyncronize.checked then --si la sincronizacion debe estar activada la activa
			(
				createSyncronizeChangeHandler()
				bckpSel = getCurrentSelection()
				
				if bckpSel.count == 0 and objects.count != 0 then select objects[1]
				
				clearSelection()
				select bckpSel
			)
			else
				createSelectionChangeHandler()
			
			enableDisableGetPose() --decide si se puede obtener o no una pose
		)

		----------------------------------------------------------------------------
		-- Lanza la carpeta de poses en la que estamos situados actualmente
		-- desde el menu contextual
		----------------------------------------------------------------------------
		fn openCurrentFolder = 
		(
			shellLaunch "explorer.exe" poseFolders[oldSelectedFolders[1] + 1]
		)

		----------------------------------------------------------------------------
		-- Lanza un menú contextual cuando le damos al botón derecho
		-- con la opción de abrir la carpeta del menú.
		----------------------------------------------------------------------------
		fn showContextualMenu =
		(
			--Definimos un menu contextual
			rcmenu rollMainDef_rmenu
			(
				--VARIABLES RCMENU--
				menuitem miGoToFolder "Open in explorer window"
				separator separator01
				
				--EVENTOS RCMENU--
				on miGoToFolder picked do openCurrentFolder()
				
				on rollAssetBrowser_rmenu open do
				(
					--La opción de update de archivo sólo estará presente si hay un solo asset seleccionado.
					miGoToFolder.enabled = (oldSelectedFolders.count == 1)
				)
			)
			popupMenu rollMainDef_rmenu
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			--Creamos los callbacks en las otras funciones porque se llaman de manera diferente.
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
			if size.x < minResize and not expanding and expanded then --si nos pasamos del minimo de anchura
				rollMainDef.width = minResize
			else if not expanded and not expanding then
				rollMainDef.width = minWidth
			
			if size.y < minHeight then --si nos pasamos del minimo de altura
				rollMainDef.height = minHeight
			
			-- ajustes de anchura-------------------------------------
			btnExpand.pos.x = rollMainDef.width - 15
			dgPoses.width = abs(btnExpand.pos.x - dgPoses.pos.x) - 5
			edtInfo.width = rollMainDef.width - 40
			
			if not expanding and rollMainDef.width >= minResize then
				expandWidth = rollMainDef.width
			-------------------------------------------------------------
				
			--ajustes de altura----------------------------------------
			--Si la altura es mayor que la minima definida para la altura.
			if size.y >= minHeight then
			(
				--Me creo 2 valores de altura menores para a partir de ahí calcular lo demás
				Ysize1 = size.y - 75
				Ysize2 = size.y - 95
				
				--Calculo la altura del separador (groupBox)
				grpSeparator.height = Ysize1 + 50
				--Calculo la altura del boton de expandir a la derecha
				btnExpand.height	= Ysize1 + 50
				--Calculo la altura del grid de las poses
				dgPoses.height = Ysize1 + 50
				
				-----Los controles de paste options se quedan fijos abajo.
				--Calculo la posicion del groupBox de paste options
				grpPasteOptions.pos.y = Ysize1 + 20
				--Calculo la posicion del check de include root/base
				chkIncludeRoot.pos.y = Ysize1 + 35
				--Calculo la posicion del check de selected only
				chkSelectedOnly.pos.y = Ysize1 + 50
				
				-----Los botones de copiar,pegar,reemplazar pose, etc. se vah hacia abajo tambien.
				btnGetPose.pos.y = Ysize1
				btnReplacePose.pos.y = Ysize1
				btnDeletePose.pos.y = Ysize1
				btnApplyPose.pos.y = Ysize1
				btnApplyPoseOpposite.pos.y = Ysize1
				
				--Los botones de pose previa pose siguiente y el spinner de saltar pose tb de van hacia abajo
				btnPrevPose.pos.y = Ysize2
				btnNextPose.pos.y = Ysize2
				spnJumpInterval.pos.y = Ysize2
				
				--El boton de capturar pose y el bitmap de detrás suyo de seleccionar pose tb se van hacia abajo
				btnCaptureThumbnail.pos.y = size.y - 122
				bmpSelectedPose.pos.y = size.y - 225
				
				--Los parámetros editables de la pose se van hacia abajo.
				lblCategoryTitle.pos.y = size.y - 280
				lblCategory.pos.y =  size.y - 263
				ddlPoseCategory.pos.y = size.y - 265
				edtPoseName.pos.y = size.y - 243
				
				--Calculamos una constante de altura
				difHeight = (rollMainDef.height - minHeight)/10
				
				fIncrease = (difHeight) 
				cIncrease = (difHeight)*3
				pIncrease = (difHeight)*6
				
				lvPoseFolders.height = foldersListHeight + fIncrease
				btnAddPoseFolder.pos.y = btnDeletePoseFolder.pos.y = foldersListPosY + lvPoseFolders.height
				
				lvCategories.height = categoryListHeight + cIncrease
				lvCategories.pos.y = categoryListPosY + fIncrease
				lblCategories.pos.y = categoryListPosY + fIncrease - 15
				
				lvPoseList.height = poseListHeight + pIncrease
				lvPoseList.pos.y = poseListPosY + fIncrease + cIncrease
				lblPoses.pos.y = poseListPosY + fIncrease + cIncrease - 15
				lblNumPoses.pos.y = poseListPosY + fIncrease + cIncrease - 15
			)
			-------------------------------------------------------------
			
			if rollMainDef.width >= minResize then
				updateGridView resizing:true --rellena el gridView con las poses si hay que actualizarlo, sino no
			
			if expanding then --si se esta expandiendo, seleccionamos la pose que toca en el gird
				if dgPoses.controls.count > 2 then
				(
					for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
						for j = 1 to dgPoses.columns.count do
							(dgPoses.item (j-1) (i-1)).selected = false
					
					if oldSelectedPoses[1] != undefined then
					(
						row = (oldSelectedPoses[1]/numColumns)
						col = oldSelectedPoses[1] - row*numColumns
						
						(dgPoses.item col row).selected = true
						--(dgPoses.item col (row*2)).selected = true
						--(dgPoses.item col (row*2 + 1)).selected = true
					)
				)
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

			lb.xml.setAttribute parent.cfgFile ("rollMain/dimensions") "expanded" (rollMainDef.expanded as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/dimensions") "expandWidth" (rollMainDef.expandWidth as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/dimensions") "expandHeight" (rollMainDef.expandHeight as string)

			lb.xml.setAttribute parent.cfgFile ("rollMain/ui") "syncronize" (chkSyncronize.checked as string)

			lb.xml.setAttribute parent.cfgFile ("rollMain/folders") "addedFolders" (rollMainDef.addedFolders as string)

			lb.xml.setAttribute parent.cfgFile ("rollMain/poseCategories") "standarCategories" (rollMainDef.standarCategories as string)

			lb.xml.setAttribute parent.cfgFile ("rollMain/pasteOptions") "includeRoot" (chkIncludeRoot.checked as string)

			lb.xml.setAttribute parent.cfgFile ("rollMain/pasteOptions") "selectedOnly" (chkSelectedOnly.checked as string)
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

			_expandedSetting = (lb.xml.getAttribute parent.cfgFile ("rollMain/dimensions") "expanded")
			_expandWidthSetting = (lb.xml.getAttribute parent.cfgFile ("rollMain/dimensions") "expandWidth") 
			_expandHeightSetting = (lb.xml.getAttribute parent.cfgFile ("rollMain/dimensions") "expandHeight") 

			if expandedSetting != "" then
			(
				expanded = (_expandedSetting == "true")
				expandWidth = _expandWidthSetting as float
				expandHeight = _expandHeightSetting as float
			)			
			
			btnExpand.text = if expanded then "<" else ">"
			grpSeparator.visible = not expanded
			
			--carga de settings de ui
			chkSyncronize.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/ui") "syncronize") == "true"

			--carga los folders personalizados que cada usuario se ha añadido
			_personalFolders = (lb.xml.getAttribute parent.cfgFile ("rollMain/folders") "addedFolders") 

			_personalFolders = filterString _personalFolders "#(),\""				
			
			if _personalFolders.count != 0 then
				for f in _personalFolders where ((f != "") and (f != " ")) do
					appendIfUnique addedFolders f
			
			chkIncludeRoot.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/pasteOptions") "includeRoot") == "true"
			chkSelectedOnly.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/pasteOptions") "selectedOnly") == "true" 

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

		---------------------------------------------------------------------------
		--sustituye el thumbnail de una pose por un render del viewport
		---------------------------------------------------------------------------
		on btnCaptureThumbnail pressed do
		(
			nodes = getCurrentSelection()	--seleccion actual
			renderProp = #()						--propiedad renderable de cada objeto seleciconado
			
			--guarda el estado de visibilidad de las piezas y oculta las que no deban salir en el thumbnail---------
			selTempAssets = lb.asset.getAssetsFromNodes nodes
			tempAssets = #()
			
			for ast in selTempAssets do
				for a in (lb.asset.getDependencygroup ast (lb.asset.getSceneAssets())) do
					appendIfUnique tempAssets a
			
			objsBckp = #()
			objsBckpIsHidden = #()
			objsBckpBoxMode = #()
			
			--for ast in tempAssets do
				for obj in objects do--(lb.asset.getAssetAnimNodes ast lb.nc.NC_classAnim) do
				(
					if (appendIfUnique objsBckp obj) then
					(
						append objsBckpIsHidden obj.ishidden
						append objsBckpBoxMode obj.boxmode
					)
				)
			
			objsBckp.ishidden = true
			
			-----------------------------------------------------------------------------------------------------------------
			
			--averigua si hay shapes de control facial seleccionadas
			facial = false
			auxNode = undefined
			head = undefined
			for obj in nodes where (findString obj.name lb.nc.NC_classFacial != undefined) do
			(
				facial = true
				auxNode = obj
			)
			
			nodesBckp = deepCopy nodes --backp de los nodos seleccionados
			
			--si es facial hay que seleccionar el mesh de cabeza
			if facial then
			(
				meshNodes = lb.asset.getAssetNodesByType (lb.asset.getAssetsFromNodes #(auxNode))[1] lb.nc.NC_classMesh
				
				nodes = #()
				
				for obj in meshNodes do
				(
					if findString obj.name "head" != undefined then append nodes obj
					if findString obj.name "hair" != undefined then append nodes obj
					if findString obj.name "eye" != undefined then append nodes obj
					if findString obj.name "teeth" != undefined then append nodes obj
					if findString obj.name "tongue" != undefined then append nodes obj
				)
				
				nodes.ishidden = false
			)
			
			hideNodes = false
			
			if facial then
				hideNodes = true
			else
				for obj in nodes where obj.boxmode do
					obj.boxmode = false
			
			if facial then
				nodesBckp.ishidden = hideNodes
			else
				nodes.ishidden = hideNodes
				
			--realiza la captura del thumbnail
			removeSceneEvents()
			clearSelection()
			cap = lb.viewport.genThumbnailViewport nodes [130,130] 45.0 clipPlanes:false view:#viewport --captura el thumbnail
			select nodesBckp
			nodes = nodesBckp
			
			if chkSyncronize.checked then
				createSyncronizeChangeHandler()
			else
				createSelectionChangeHandler()
				
			--restaura el estado de visualizacion de los nodos-----------------------------------------------------------
			for i=1 to objsBckp.count do
			(
				objsBckp[i].ishidden = objsBckpIsHidden[i]
				objsBckp[i].boxmode = objsBckpBoxMode[i]
			)
			-----------------------------------------------------------------------------------------------------------------
			
			if cap != undefined and selectedPose != undefined then
			(
				selPoseFileName = selectedPose.thumbnailFile
				if selPoseFileName == "" then selPoseFileName = substituteString selectedPose.file ".pos" ".jpg"
					
				cap.fileName = selPoseFileName
				save cap
				
				setSelectedPose() --almacena la pose seleccionada actualmente
				updateGridView()
				
				if dgPoses.controls.count > 2 then
				(
					for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
						for j = 1 to dgPoses.columns.count do
							(dgPoses.item (j-1) (i-1)).selected = false
					
					if oldSelectedPoses[1] != undefined then
					(
						row = (oldSelectedPoses[1]/numColumns)
						col = oldSelectedPoses[1] - row*numColumns
						
						(dgPoses.item col row).selected = true
						--(dgPoses.item col (row*2)).selected = true
						--(dgPoses.item col (row*2 + 1)).selected = true
					)
				)
			)
		)

		---------------------------------------------------------------------------
		--captura una nueva pose de las piezas seleccionadas
		---------------------------------------------------------------------------
		on btnGetPose pressed do
		(
			local cap = undefined						--imagen de la pose obtenida
			local nodes = getCurrentSelection()	--seleccion actual
			
			tempAssets = lb.asset.getAssetsFromNodes nodes
			selectedAssets = #()
			
			for ast in tempAssets do --recopila los assets seleccionados
			(
				add = true
				
				if ast.isDependent then --si el asset es dependiente solo lo añade si su asset principal no esta seleccionado
				(
					add = true
					for a in tempAssets where (a.fullname == ast.mainAsset) do
						add = false
				)		
				
				if add then
					appendIfUnique selectedAssets ast
			)
			
			if selectedAssets.count == 1 then
			(
				--creacion de la imagen thumbnail--------------------------------------------------------------------------
				side = getSideFromNodes nodes
				view = #RF
				
				case side of
				(
					#R: view = #RF
					#L: view = #LF
					#M: view = #RF
				)
				
				--guarda el estado de visibilidad de las piezas y oculta las que no deban salir en el thumbnail---------
				objsBckp = #()
				objsBckpIsHidden = #()
				objsBckpBoxMode = #()
				
				selTempAssets = #()
				
				for ast in tempAssets do
					for a in (lb.asset.getDependencygroup ast (lb.asset.getSceneAssets())) do
						appendIfUnique selTempAssets a
				
				--for ast in tempAssets do
				for obj in objects do--(lb.asset.getAssetAnimNodes ast lb.nc.NC_classAnim) do
				(
					if (appendIfUnique objsBckp obj) then
					(
						append objsBckpIsHidden obj.ishidden
						append objsBckpBoxMode obj.boxmode
					)
				)
				
				objsBckp.ishidden = true
				
				-----------------------------------------------------------------------------------------------------------------
				
				--averigua si hay shapes de control facial seleccionadas
				facial = false
				auxNode = undefined
				head = undefined
				for obj in nodes where (findString obj.name lb.nc.NC_classFacial != undefined) do
				(
					facial = true
					auxNode = obj
				)
				
				nodesBckp = deepCopy nodes --backp de los nodos seleccionados
				
				--si es facial hay que seleccionar el mesh de cabeza
				if facial then
				(
					meshNodes = lb.asset.getAssetNodesByType (lb.asset.getAssetsFromNodes #(auxNode))[1] lb.nc.NC_classMesh
						
					nodes = #()
					
					for obj in meshNodes do
					(
						if findString obj.name "head" != undefined then append nodes obj
						if findString obj.name "hair" != undefined then append nodes obj
						if findString obj.name "eye" != undefined then append nodes obj
						if findString obj.name "teeth" != undefined then append nodes obj
						if findString obj.name "tongue" != undefined then append nodes obj
					)
					
					nodes.ishidden = false
				)
									
				hideNodes = false
			
				if facial then
					hideNodes = true
				else
					for obj in nodes where obj.boxmode do
						obj.boxmode = false
				
				if facial then
					nodesBckp.ishidden = hideNodes
				else
					nodes.ishidden = hideNodes
					
				removeSceneEvents()
				clearSelection()
				cap = lb.viewport.genThumbnailViewport nodes [130,130] 45.0 clipPlanes:false view:view --hace el render
				select nodesBckp
				nodes = nodesBckp
				
				if chkSyncronize.checked then
					createSyncronizeChangeHandler()
				else
					createSelectionChangeHandler()
				
				--restaura el estado de visualizacion de los nodos-----------------------------------------------------------
				for i=1 to objsBckp.count do
				(
					objsBckp[i].ishidden = objsBckpIsHidden[i]
					objsBckp[i].boxmode = objsBckpBoxMode[i]
				)
				-----------------------------------------------------------------------------------------------------------------
				
				
				----------------------------------------------------------------------------------------------------------------
				--obtiene la pose y la guarda en un fichero en la ruta correspondiente -----------------------------------
				lb.copyPasteFunctions.copyTracks() --almacena la pose en el buffer global de tracks
				
				--intentamos averiguar como se llamará la nueva pose obtenida y el folder donde guardarla
				--será de la categoria seleccionada del listado, si la seleccionada es "all", será de la categoria "other"
				
				listFold = lvPoseFolders.items.item[oldSelectedFolders[1]].text
				fold = poseFolders[oldSelectedFolders[1] + 1]
				cat = actualCategories[oldSelectedCategories[1] + 1]
				index = 1
				
				--Iteramos entre las que tenemos de la misma categoria que nosotros o en todas si hay "all" seleccionado, además de existir alguna nueva.
				--intenta averiguar
				for pose in actualPoses where (((pose.category == cat) or (cat == "all")) and (findString pose.name "new") != undefined)do
				(
					--Dividimos el nombre de la pose
					poseParts = filterString pose.name "-"
					--Si tiene 2 partes
					if poseParts.count == 2 then
					(
						--Sacamos el indice de la pose
						newIndex = (poseParts[2] as integer)
						--Lo comparamos con el indice que teníamos antes y si es mayor nos quedamos con él.
						if classof newIndex == Integer then
							if newIndex >= index then
								index = (poseParts[2] as integer) + 1
					)
				)					
				
				if cat == "all" or (oldSelectedCategories.count >1) then cat = "other"
				newPoseName = cat + "_new-" + (formattedPrint index format:"03d")
				fileName = fold + newPoseName + ".pos"
				
				--almacena la pose en el folder de poses del personaje, con el nombre que le corresponde
				success = lb.copyPasteFunctions.bufferToFile fileName
				
				if success then --si consigue guardar la pose
				(
					--guarda el thumbnail
					if cap != undefined then
					(
						cap.fileName = substituteString fileName ".pos" ".jpg"
						save cap
					)
					
					--Reinicializa--Obtiene de nuevo las poses de los folders------------------------
					fillFoldersCategoriesPosesInfo()		--obtiene la informacionde folders, poseCategories y poses
						fillLvPoseFolders()	--rellena el listado de folders
					
						--actualiza la informacion cargada
					
					--folders---------------------
					for i=1 to lvPoseFolders.items.count do
						lvPoseFolders.items.item[i-1].selected = (listFold == lvPoseFolders.items.item[i-1].text)
					
					for i=lvPoseFolders.items.count to 1 by -1 do
						if lvPoseFolders.items.item[i-1].selected then
							lvPoseFolders.ensureVisible (i-1)
						
					updateLvPoseFolders()
						
					--categorias--------------------
					for i=1 to lvCategories.items.count do
						lvCategories.items.item[i-1].selected = (cat == lvCategories.items.item[i-1].text)
					
					for i=lvCategories.items.count to 1 by -1 do
						if lvCategories.items.item[i-1].selected then
							lvCategories.ensureVisible (i-1)
					
					updateLvCategories()
						
					--listado de poses---------------
					for i=1 to lvPoseList.items.count do
						lvPoseList.items.item[i-1].selected = (newPoseName == lvPoseList.items.item[i-1].text)
					
					for i=lvPoseList.items.count to 1 by -1 do
						if lvPoseList.items.item[i-1].selected then
							lvPoseList.ensureVisible (i-1)
						
					updateLvPoseList()
					----------------------------------
						
					setSelectedPose() --almacena la pose seleccionada actualmente
					updateInfo()	--actualiza el label Info con la informacion actual
					updateGridView()
					
					if dgPoses.controls.count > 2 then
					(
						for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
							for j = 1 to dgPoses.columns.count do
								(dgPoses.item (j-1) (i-1)).selected = false
						
						if oldSelectedPoses[1] != undefined then
						(
							row = (oldSelectedPoses[1]/numColumns)
							col = oldSelectedPoses[1] - row*numColumns
							
							(dgPoses.item col row).selected = true
							--(dgPoses.item col (row*2)).selected = true
							--(dgPoses.item col (row*2 + 1)).selected = true
						)
					)
						
					enableDisableGetPose() --decide si se puede obtener o no una pose
					---------------------------------------------------------------------------
				)
				else
				(
					lb.message.show "Pose not saved, something fails" type:#message pos:undefined size:[300,75] modal:true
				)
				
				----------------------------------------------------------------------------------------------------------------
				----------------------------------------------------------------------------------------------------------------
			)
			else --si no hay assets seleccionados o hay mas de uno
			(
				if selectedAssets.count == 0 then
					lb.message.show "there are no objects selected, can't get a pose.\nPlease select objects from one asset." type:#message pos:undefined size:[300,75] modal:true
				else
					lb.message.show "there are objects from more than one asset, can't get a pose.\nPlease select only objects from one asset." type:#message pos:undefined size:[300,75] modal:true
			)	
		)	

		---------------------------------------------------------------------------
		--reemplaza una pose ya existente con la nueva
		---------------------------------------------------------------------------
		on btnReplacePose pressed do
		(
			if (queryBox "This operation has no undo ¿Do you want to continue?") then
			(
				if selectedPose != undefined then
				(
					
					local cap = undefined						--imagen de la pose obtenida
					local nodes = getCurrentSelection()	--seleccion actual
					
					--Guardamos los assets obtenidos a partir de los nodos que hemos seleccionado
					tempAssets = lb.asset.getAssetsFromNodes nodes
					selectedAssets = #()
					
					for ast in tempAssets do --recopila los assets seleccionados
					(
						add = true
						
						if ast.isDependent then --si el asset es dependiente solo lo añade si su asset principal no esta seleccionado
						(
							add = true
							for a in tempAssets where (a.fullname == ast.mainAsset) do
								add = false
						)		
						
						if add then
							appendIfUnique selectedAssets ast
					)
					
					if selectedAssets.count == 1 then
					(
						--creacion de la imagen thumbnail--------------------------------------------------------------------------
						side = getSideFromNodes nodes
						view = #RF
						
						case side of
						(
							#R: view = #RF
							#L: view = #LF
							#M: view = #RF
						)
						
						--guarda el estado de visibilidad de las piezas y oculta las que no deban salir en el thumbnail---------
						objsBckp = #()
						objsBckpIsHidden = #()
						objsBckpBoxMode = #()
						
						selTempAssets = #()
						
						for ast in tempAssets do
							for a in (lb.asset.getDependencygroup ast (lb.asset.getSceneAssets())) do
								appendIfUnique selTempAssets a
						
						--for ast in tempAssets do
						for obj in objects do--(lb.asset.getAssetAnimNodes ast lb.nc.NC_classAnim) do
						(
							if (appendIfUnique objsBckp obj) then
							(
								append objsBckpIsHidden obj.ishidden
								append objsBckpBoxMode obj.boxmode
							)
						)
						
						objsBckp.ishidden = true
						
						-----------------------------------------------------------------------------------------------------------------
						
						--averigua si hay shapes de control facial seleccionadas
						facial = false
						auxNode = undefined
						head = undefined
						for obj in nodes where (findString obj.name lb.nc.NC_classFacial != undefined) do
						(
							facial = true
							auxNode = obj
						)
						
						nodesBckp = deepCopy nodes --backp de los nodos seleccionados
						
						--si es facial hay que seleccionar el mesh de cabeza
						if facial then
						(
							meshNodes = lb.asset.getAssetNodesByType (lb.asset.getAssetsFromNodes #(auxNode))[1] lb.nc.NC_classMesh
								
							nodes = #()
							
							for obj in meshNodes do
							(
								if findString obj.name "head" != undefined then append nodes obj
								if findString obj.name "hair" != undefined then append nodes obj
								if findString obj.name "eye" != undefined then append nodes obj
								if findString obj.name "teeth" != undefined then append nodes obj
								if findString obj.name "tongue" != undefined then append nodes obj
							)
							
							nodes.ishidden = false
						)
						
						hideNodes = false
						
						if facial then
							hideNodes = true
						else
							for obj in nodes where obj.boxmode do
								obj.boxmode = false
						
						if facial then
							nodesBckp.ishidden = hideNodes
						else
							nodes.ishidden = hideNodes
							
						removeSceneEvents()
						clearSelection()
						cap = lb.viewport.genThumbnailViewport nodes [130,130] 45.0 clipPlanes:false view:view --hace el render
						select nodesBckp
						nodes = nodesBckp
						
						if chkSyncronize.checked then
							createSyncronizeChangeHandler()
						else
							createSelectionChangeHandler()
						
						--restaura el estado de visualizacion de los nodos-----------------------------------------------------------
						for i=1 to objsBckp.count do
						(
							objsBckp[i].ishidden = objsBckpIsHidden[i]
							objsBckp[i].boxmode = objsBckpBoxMode[i]
						)
						-----------------------------------------------------------------------------------------------------------------
						
						
						----------------------------------------------------------------------------------------------------------------
						--obtiene la pose y la guarda en un fichero en la ruta correspondiente -----------------------------------
						lb.copyPasteFunctions.copyTracks() --almacena la pose en el buffer global de tracks
						cat = selectedPose.category
						listFold = lvPoseFolders.items.item[oldSelectedFolders[1]].text
						fullName = selectedPose.fullName
						
						fileName = selectedPose.file --obtiene la ruta del fichero que tiene que sustituir
						
						--Me creo un flag donde almacenaré el resultado de analizar el estado del archivo a sustituir de cara al repositorio
						_svnFileStatusFlag = false
						--Si el fichero existe
						if doesFileExist fileName then 
						(
							--Si no está versionado lo podemos pisar
							if not (lb.svn.svnIsFileVersioned fileName) then
								_svnFileStatusFlag = true
							else --Si sí está versionado comprobamos que está bloqueado.
							(
								--Para ver si estaba bloqueado probamos a ver si puede desbloquearlo.
								if lb.svn.svnUnlockfile fileName then
								(
									--Lo ponemos como válido
									_svnFileStatusFlag = true
									--Y lo volvemos a bloquear
									lb.svn.svnLockFile fileName
								)
								else
								(
									lb.message.show "Pose has to be locked to replace it." type:#message pos:undefined size:[300,75] modal:true
								)
							)
						)	
							
						if _svnFileStatusFlag then
						(
						--if doesFileExist fileName then --si el fichero existe, intenta cambiar su propiedad readOnly a false
						--setFileAttribute fileName #readOnly false
						
							--almacena la pose en el folder de poses del personaje, con el nombre que le corresponde
							success = lb.copyPasteFunctions.bufferToFile fileName
							
							if success then --si consigue guardar la pose
							(
								--guarda el thumbnail
								if cap != undefined then
								(
									capFileName = substituteString fileName ".pos" ".jpg"
									
									--Primero lo bloqueamos en el svn si existe
									if doesFileExist capFileName then
										lb.svn.svnLockFile capFileName
										--setFileAttribute capFileName #readOnly false
									
									cap.fileName = capFileName
									save cap
								)
								
								--Reinicializa--Obtiene de nuevo las poses de los folders------------------------
								fillFoldersCategoriesPosesInfo()		--obtiene la informacionde folders, poseCategories y poses
								fillLvPoseFolders()	--rellena el listado de folders
								
								--actualiza la informacion cargada
								
								--folders---------------------
								for i=1 to lvPoseFolders.items.count do
									lvPoseFolders.items.item[i-1].selected = (listFold == lvPoseFolders.items.item[i-1].text)
									
								for i=lvPoseFolders.items.count to 1 by -1 do
									if lvPoseFolders.items.item[i-1].selected then
										lvPoseFolders.ensureVisible (i-1)
								
								--Miramos el flag de all antes de hacer el update, ya que nos cambia la seleccion.
								_allSelected = lvCategories.items.item[0].selected
								
								updateLvPoseFolders()
								
								--categorias--------------------
								--cuento el numero de elementos seleccionados en cont
								cont=0
								--Primero miramos si no está all seleccionado
								if not _allSelected do
								(
									lvCategories.items.item[0].selected = false
									for i=1 to lvCategories.items.count do
									(
										if cat == lvCategories.items.item[i-1].text then
										(
											lvCategories.items.item[i-1].selected = true
											cont += 1
										)
										else
										(
											if lvCategories.items.item[i-1].selected do
												cont += 1
										)
									)
									
									--Si no hay ninguna categoría seleccionada que seleccione all
									if cont == 0 then
										lvCategories.items.item[0].selected = true
								)
								
								for i=lvCategories.items.count to 1 by -1 do
									if lvCategories.items.item[i-1].selected then
										lvCategories.ensureVisible (i-1)
								
								updateLvCategories()
								
								--listado de poses---------------
								for i=1 to lvPoseList.items.count do
									lvPoseList.items.item[i-1].selected = (fullName == lvPoseList.items.item[i-1].text)
								
								for i=lvPoseList.items.count to 1 by -1 do
									if lvPoseList.items.item[i-1].selected then
										lvPoseList.ensureVisible (i-1)
									
								updateLvPoseList()
								----------------------------------
									
								setSelectedPose() --almacena la pose seleccionada actualmente
								updateInfo()	--actualiza el label Info con la informacion actual
								updateGridView()
								
								if dgPoses.controls.count > 2 then
								(
									for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
										for j = 1 to dgPoses.columns.count do
											(dgPoses.item (j-1) (i-1)).selected = false
									
									if oldSelectedPoses[1] != undefined then
									(
										row = (oldSelectedPoses[1]/numColumns)
										col = oldSelectedPoses[1] - row*numColumns
										
										(dgPoses.item col row).selected = true
										--(dgPoses.item col (row*2)).selected = true
										--(dgPoses.item col (row*2 + 1)).selected = true
									)
								)
									
								enableDisableGetPose() --decide si se puede obtener o no una pose
								---------------------------------------------------------------------------
							)
							else
							(
								lb.message.show "Pose not saved, something fails" type:#message pos:undefined size:[300,75] modal:true
							)
						)--if _svnFileStatusFlag
						----------------------------------------------------------------------------------------------------------------
						----------------------------------------------------------------------------------------------------------------
					)
					else --si no hay assets seleccionados o hay mas de uno
					(
						if selectedAssets.count == 0 then
							lb.message.show "there are no objects selected, can't get a pose.\nPlease select objects from one asset." type:#message pos:undefined size:[300,75] modal:true
						else
							lb.message.show "there are objects from more than one asset, can't get a pose.\nPlease select only objects from one asset." type:#message pos:undefined size:[300,75] modal:true
					)
					
				)--if selectedPose != undefined
				else
					lb.message.show "There is no pose to replace selected" type:#message pos:undefined size:[300,75] modal:true
				
			)--if querry
		)

		---------------------------------------------------------------------------
		--captura una nueva pose de las piezas seleccionadas
		---------------------------------------------------------------------------
		on btnDeletePose pressed do
		(
			if not (lb.svn.svnIsFileVersioned selectedPose.file) then
			(
				if selectedPose != undefined then
				(
					success = true
					
					--almacena valores para poder restaurar luego el interface con el folder y la categoria actual
					selFoldersBckp = for i=1 to lvPoseFolders.items.count where lvPoseFolders.items.item[i-1].selected collect lvPoseFolders.items.item[i-1].text
					selCategoriesBckp = for i=1 to lvCategories.items.count where lvCategories.items.item[i-1].selected collect lvCategories.items.item[i-1].text
					
					--elimina la pose seleccionada
					if (queryBox "This operation has no undo ¿Do you want to continue?") then
					(
						index = (findItem actualPoses selectedPose) + 1
						
						if not deleteFile selectedPose.file then success = false
						if not deleteFile selectedPose.thumbnailFile then success = false
						
						if success then
						(
							if index > 2 then
							(
								--dgPoses.controls.item[index].image = undefined
								--dgPoses.controls.item[index].Dispose()
								
								while dgPoses.controls.count != 2 do
									dgPoses.controls.clear()
								
								dgc = dotnetclass "system.gc"
								dgc.collect()
								gc light:true

								--freescenebitmaps()
								--DESACTIVADO PORQUE SE CARGA LOS MATERIALES SSS EN VIEWPORT SI ESTAN POR XREF. HACE QUE NO SE VEAN LAS TEXTURAS DE LA PIEN EN VIEWPORT Y HAY QUE MERGEAR EL MATERIAL DE XREF PARA QUE VUELVA A VERSE.
							)
							
							--Reinicializa--Obtiene de nuevo las poses de los folders------------------------
							fillFoldersCategoriesPosesInfo()		--obtiene la informacionde folders, poseCategories y poses
							fillLvPoseFolders()	--rellena el listado de folders
							
							--actualiza la informacion cargada
							for i=1 to lvPoseFolders.items.count do
								lvPoseFolders.items.item[i-1].selected = (findItem selFoldersBckp lvPoseFolders.items.item[i-1].text != 0)
							
							for i=lvPoseFolders.items.count to 1 by -1 do
								if lvPoseFolders.items.item[i-1].selected then
									lvPoseFolders.ensureVisible (i-1)
								
							updateLvPoseFolders()
							
							cont = 0								
							for i=1 to lvCategories.items.count where (findItem selCategoriesBckp lvCategories.items.item[i-1].text != 0) do
							(
								lvCategories.items.item[i-1].selected = true
								cont += 1
							)
							
							if cont == 0 then
								lvCategories.items.item[0].selected = true
								
							for i=lvCategories.items.count to 1 by -1 do
								if lvCategories.items.item[i-1].selected then
									lvCategories.ensureVisible (i-1)
							
							updateLvCategories()
								
							updateLvPoseList()
								
							setSelectedPose() --almacena la pose seleccionada actualmente
							updateInfo()	--actualiza el label Info con la informacion actual
							
							enableDisableGetPose() --decide si se puede obtener o no una pose
							---------------------------------------------------------------------------
						)
						else	
							lb.message.show "Error deleting pose. It could be read only" type:#message pos:undefined size:[300,75] modal:true
						
					)--if querry					
				)--if selected Pose
			)
			else
			(
				lb.message.show "Versioned Poses can't be deleted." type:#message pos:undefined size:[300,75] modal:true
			)
		)

		---------------------------------------------------------------------------
		--aplica la pose
		---------------------------------------------------------------------------
		on btnApplyPose pressed do
		(
			local nodes = getCurrentSelection()	--seleccion actual
			
			selectedAssets = lb.asset.getAssetsFromNodes nodes
			
			if selectedAssets.count > 0 then
			(
				--obtiene la pose de un fichero y la aplica a los assets seleccionados ------------------------------------
				undo "Apply Pose" on
				(
					success = lb.copyPasteFunctions.fileToBuffer (selectedPose.file)	
					if success then
						lb.copyPasteFunctions.pasteTracks assets:selectedAssets applyToSelectionOnly:chkSelectedOnly.checked ignoreRootAndBase:(not chkIncludeRoot.checked) --aplica la pose del buffer global de tracks
					else
						lb.message.show "Pose not Loaded, something fails" type:#message pos:undefined size:[300,75] modal:true
				)
				----------------------------------------------------------------------------------------------------------------
			)					
			else --si no hay assets seleccionados
				lb.message.show "there are no objects selected, can't get a pose.\nPlease select objects from one asset." type:#message pos:undefined size:[300,75] modal:true			
		)

		---------------------------------------------------------------------------
		--aplica la pose al opuesto
		---------------------------------------------------------------------------
		on btnApplyPoseOpposite pressed do
		(
			local nodes = getCurrentSelection()	--seleccion actual
			
			selectedAssets = lb.asset.getAssetsFromNodes nodes
			
			if selectedAssets.count > 0 then
			(
				--obtiene la pose de un fichero y la aplica a los assets seleccionados ------------------------------------
				undo "Apply Pose" on
				(
					success = lb.copyPasteFunctions.fileToBuffer (selectedPose.file)	
					if success then lb.copyPasteFunctions.pasteTracks assets:selectedAssets applyToOpposite:true applyToSelectionOnly:chkSelectedOnly.checked ignoreRootAndBase:(not chkIncludeRoot.checked) --aplica la pose del buffer global de tracks
				)
				----------------------------------------------------------------------------------------------------------------
			)					
			else --si no hay assets seleccionados
				lb.message.show "there are no objects selected, can't get a pose.\nPlease select objects from one asset." type:#message pos:undefined size:[300,75] modal:true		
		)

		---------------------------------------------------------------------------
		-- cambios en el spinner de intervalod e salto
		---------------------------------------------------------------------------
		on spnJumpInterval changed value do
		(
			if value > actualPoses.count then spnJumpInterval.value = 1
			else if value < 1 then spnJumpInterval.value = actualPoses.count
			
			selIndex = spnJumpInterval.value - 1 --pose seleccionada actualmente
			numPoses = lvPoseList.items.count --numero total de poses en el listado
			
			if numPoses != 1 then
			(	
				newSelIndex = (selIndex) - (((selIndex)/numPoses)*numPoses)
				
				for i=1 to numPoses do --deja solamente seleccionada la pose que toca ahora
					lvPoseList.items.item[i-1].selected = ((i-1) == newSelIndex)
				
				updateFlag = false --flag para saber si actualizar o no
				
				--recorre los elementos para ver si la seleccion es diferente
				stop = false
				cont = 1
				
				while (not stop) and (cont <= actualPoses.count) do
				(
					if (lvPoseList.items.item[cont-1].selected) and ((cont - 1) != oldSelectedPoses[1]) then
					(
						updateFlag = true
						stop = true
					)
					
					cont += 1
				)
					
				if updateFlag then --si la seleccion es diferente tiene que actualizar
					updateLvPoseList()	
					
				--actualiza la seleccion en el grid
				if dgPoses.controls.count > 2 then
				(
					for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
						for j = 1 to dgPoses.columns.count do
							(dgPoses.item (j-1) (i-1)).selected = false
					
					row = (newSelIndex/numColumns)
					col = newSelIndex - row*numColumns
					
					(dgPoses.item col row).selected = true
					lvPoseList.ensureVisible (newSelIndex)
					dgPoses.CurrentCell = (dgPoses.item col row)
				)--if
			)--if numPoses > 1
		)

		---------------------------------------------------------------------------
		--expande o contrae el rollout
		---------------------------------------------------------------------------
		--on btnExpand pressed do
		on btnExpand MouseUp e do
		(
			expanding = true
			
			if rollMainDef.width > minWidth then --contraer
			(
				rollMainDef.width = minWidth
				dgPoses.visible = false
				btnExpand.pos.x = minWidth - 15
				btnExpand.text = ">"
				grpSeparator.visible = true
				expanded = false
			)
			else --expandir
			(
				rollMainDef.width = expandWidth
				dgPoses.visible = true
				btnExpand.pos.x = expandWidth - 15
				btnExpand.text = "<"
				grpSeparator.visible = false
				expanded = true
			)
			
			expanding = false
			
		)

		---------------------------------------------------------------------------
		--selecciona la pose siguiente a la seleccionada. El intervalo de salto lo marca el valor del spinner spnJumpInterval
		---------------------------------------------------------------------------
		on btnNextPose pressed do
		(
			jumpInterval = 1--spnJumpInterval.value as integer --intervalo de salto
			
			selIndex = lvPoseList.selectedItems.item[0].index --pose seleccionada actualmente
			numPoses = lvPoseList.items.count --numero total de poses en el listado
			
			if numPoses != 1 then
			(	
				newSelIndex = (selIndex + jumpInterval) - (((selIndex + jumpInterval)/numPoses)*numPoses)
				
				for i=1 to numPoses do --deja solamente seleccionada la pose que toca ahora
					lvPoseList.items.item[i-1].selected = ((i-1) == newSelIndex)
				
				updateFlag = false --flag para saber si actualizar o no
			
				--recorre los elementos para ver si la seleccion es diferente
				stop = false
				cont = 1
				
				while (not stop) and (cont <= actualPoses.count) do
				(
					if (lvPoseList.items.item[cont-1].selected) and ((cont - 1) != oldSelectedPoses[1]) then
					(
						updateFlag = true
						stop = true
					)
					
					cont += 1
				)
					
				if updateFlag then --si la seleccion es diferente tiene que actualizar
					updateLvPoseList()	
				
				--actualiza la seleccion en el grid
				if dgPoses.controls.count > 2 then
				(
					for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
						for j = 1 to dgPoses.columns.count do
							(dgPoses.item (j-1) (i-1)).selected = false
					
					row = (newSelIndex/numColumns)
					col = newSelIndex - row*numColumns
					
					(dgPoses.item col row).selected = true
					lvPoseList.ensureVisible (newSelIndex)
					dgPoses.CurrentCell = (dgPoses.item col row)
				)--if
			)--if numPoses > 1
		)

		---------------------------------------------------------------------------
		--selecciona la pose anterior a la seleccionada. El intervalo de salto lo marca el valor del spinner spnJumpInterval
		---------------------------------------------------------------------------
		on btnPrevPose pressed do
		(
			jumpInterval = 1--spnJumpInterval.value as integer --intervalo de salto
			
			selIndex = lvPoseList.selectedItems.item[0].index --pose seleccionada actualmente
			numPoses = lvPoseList.items.count --numero total de poses en el listado
			
			if numPoses != 1 then
			(	
				newSelIndex = (selIndex - jumpInterval)
				
				while newSelIndex < 0 do
					newSelIndex = numPoses + newSelIndex
					
				for i=1 to numPoses do --deja solamente seleccionada la pose que toca ahora
					lvPoseList.items.item[i-1].selected = ((i-1) == newSelIndex)
				
				updateFlag = false --flag para saber si actualizar o no
				
				--recorre los elementos para ver si la seleccion es diferente
				stop = false
				cont = 1
				
				while (not stop) and (cont <= actualPoses.count) do
				(
					if (lvPoseList.items.item[cont-1].selected) and ((cont - 1) != oldSelectedPoses[1]) then
					(
						updateFlag = true
						stop = true
					)
					
					cont += 1
				)
					
				if updateFlag then --si la seleccion es diferente tiene que actualizar
					updateLvPoseList()	
										
				--actualiza la seleccion en el grid
				if dgPoses.controls.count > 2 then
				(
					for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
						for j = 1 to dgPoses.columns.count do
							(dgPoses.item (j-1) (i-1)).selected = false
					
					row = (newSelIndex/numColumns)
					col = newSelIndex - row*numColumns
					
					(dgPoses.item col row).selected = true
					lvPoseList.ensureVisible (newSelIndex)
					dgPoses.CurrentCell = (dgPoses.item col row)
				)--if
			)--if numPoses > 1	
		)

		---------------------------------------------------------------------------
		--cambia la pose de categoria
		--vuelve a dejar seleccionada esa pose, con lo cual cambiará de categoría
		---------------------------------------------------------------------------
		on ddlPoseCategory keyUp events do
		(
			key = events.keydata.tostring()
			newCategory = ddlPoseCategory.text
			
			if selectedPose != undefined and key == "Return" then --si hay pose seleccionada
			(
				selFoldersBckp = #()			--almacena los folders de poses actualmente seleccionados
				selCategoriesBckp = #()		--almacena las categorías de pose actualmente seleccionadas
				
				for f in oldSelectedFolders do --rellena el array
					append selFoldersBckp poseFoldersOwners[f+1]
				
				for c in oldSelectedCategories do --rellena el array
					append selCategoriesBckp actualCategories[c+1]
				
				--obtiene los nombres viejos de la pose
				oldFullName				= selectedPose.fullName
				oldFileName				= selectedPose.file
				oldThumbnailName	= selectedPose.thumbnailFile
				
				if newCategory != "all" then --si la categoria nueva es "all" no se permite renombrarla
				(
					--calcula los nombre nuevos de la pose
					newFullName			= substituteString oldFullName selectedPose.category newCategory
					newFileName			= substituteString oldFileName oldFullName newFullName
					newThumbnailName	= substituteString oldThumbnailName oldFullName newFullName
						
					--renombra los archivos
					success = renameFile oldFileName newFileName
					
					if success then
					(
						renameFile oldThumbnailName newThumbnailName
					
						--intenta añadir la nueva categoria a las seleccionadas para que aparezca tambien seleccionada
						--si la unica que había seleccionada era la categoria all, no la añade
						if success and selCategoriesBckp.count != 0 then
							if selCategoriesBckp.count > 1 then
								appendIfUnique selCategoriesBckp newCategory
							else if selCategoriesBckp.count == 1 and selCategoriesBckp[1] != "all" then
								appendIfUnique selCategoriesBckp newCategory	
						
						--Reinicializacion------------------------
						fillFoldersCategoriesPosesInfo()		--obtiene la informacion de folders, poseCategories y poses
						fillLvPoseFolders()						--rellena el listado de folders
						
						--actualiza la informacion cargada
						for i=1 to lvPoseFolders.items.count do
							lvPoseFolders.items.item[i-1].selected = (findItem selFoldersBckp lvPoseFolders.items.item[i-1].text != 0)
						
						for i=lvPoseFolders.items.count to 1 by -1 do
							if lvPoseFolders.items.item[i-1].selected then
								lvPoseFolders.ensureVisible (i-1)
							
						updateLvPoseFolders()
						
						for i=1 to lvCategories.items.count do
							lvCategories.items.item[i-1].selected = (findItem selCategoriesBckp lvCategories.items.item[i-1].text != 0)
						
						for i=lvCategories.items.count to 1 by -1 do
							if lvCategories.items.item[i-1].selected then
								lvCategories.ensureVisible (i-1)
						
						updateLvCategories()
							
						for i=1 to lvPoseList.items.count do
							lvPoseList.items.item[i-1].selected = (lvPoseList.items.item[i-1].text == newFullName)
						
						for i=lvPoseList.items.count to 1 by -1 do
							if lvPoseList.items.item[i-1].selected then
								lvPoseList.ensureVisible (i-1)
							
						updateLvPoseList()
							
						setSelectedPose() --almacena la pose seleccionada actualmente
						enableDisableGetPose() --decide si se puede obtener pode o aplicarla
						updateInfo()	--actualiza el label Info con la informacion actual
					)--if success
					else
					(
						lb.message.show "Category change couldn't be done, check there is not a name conflict between two poses." type:#message pos:undefined size:[300,75] modal:true
						ddlPoseCategory.text = selectedPose.category
					)
				)
				else
				(
					ddlPoseCategory.text = selectedPose.category
				)--if all
			)--if pose
		)

		---------------------------------------------------------------------------
		--cambia la pose de categoria
		--vuelve a dejar seleccionada esa pose, con lo cual cambiará de categoría
		---------------------------------------------------------------------------
		on ddlPoseCategory SelectionChangeCommitted events do
		(
			newCategory = (ddlPoseCategory.items.item[ddlPoseCategory.SelectedIndex])
			
			if selectedPose != undefined and newCategory != "" then --si hay pose seleccionada
			(
				selFoldersBckp = #()			--almacena los folders de poses actualmente seleccionados
				selCategoriesBckp = #()		--almacena las categorías de pose actualmente seleccionadas
				
				for f in oldSelectedFolders do --rellena el array
					append selFoldersBckp poseFoldersOwners[f+1]
				
				for c in oldSelectedCategories do --rellena el array
					append selCategoriesBckp actualCategories[c+1]
				
				--obtiene los nombres viejos de la pose
				oldFullName				= selectedPose.fullName
				oldFileName				= selectedPose.file
				oldThumbnailName	= selectedPose.thumbnailFile
				
				if newCategory != "all" then --si la categoria nueva es "all" no se permite renombrarla
				(
					--calcula los nombre nuevos de la pose
					newFullName			= substituteString oldFullName selectedPose.category newCategory
					newFileName			= substituteString oldFileName oldFullName newFullName
					newThumbnailName	= substituteString oldThumbnailName oldFullName newFullName
						
					--renombra los archivos
					success = renameFile oldFileName newFileName
					
					if success then
					(
						renameFile oldThumbnailName newThumbnailName
					
						--intenta añadir la nueva categoria a las seleccionadas para que aparezca tambien seleccionada
						--si la unica que había seleccionada era la categoria all, no la añade
						if success and selCategoriesBckp.count != 0 then
							if selCategoriesBckp.count > 1 then
								appendIfUnique selCategoriesBckp newCategory
							else if selCategoriesBckp.count == 1 and selCategoriesBckp[1] != "all" then
								appendIfUnique selCategoriesBckp newCategory	
						
						--Reinicializacion------------------------
						fillFoldersCategoriesPosesInfo()		--obtiene la informacion de folders, poseCategories y poses
						fillLvPoseFolders()						--rellena el listado de folders
						
						--actualiza la informacion cargada
						for i=1 to lvPoseFolders.items.count do
							lvPoseFolders.items.item[i-1].selected = (findItem selFoldersBckp lvPoseFolders.items.item[i-1].text != 0)
						
						for i=lvPoseFolders.items.count to 1 by -1 do
							if lvPoseFolders.items.item[i-1].selected then
								lvPoseFolders.ensureVisible (i-1)
						
						updateLvPoseFolders()
							
						for i=1 to lvCategories.items.count do
							lvCategories.items.item[i-1].selected = (findItem selCategoriesBckp lvCategories.items.item[i-1].text != 0)
						
						for i=lvCategories.items.count to 1 by -1 do
							if lvCategories.items.item[i-1].selected then
								lvCategories.ensureVisible (i-1)
							
						updateLvCategories()
						
						for i=1 to lvPoseList.items.count do
							lvPoseList.items.item[i-1].selected = (lvPoseList.items.item[i-1].text == newFullName)
						
						for i=lvPoseList.items.count to 1 by -1 do
							if lvPoseList.items.item[i-1].selected then
								lvPoseList.ensureVisible (i-1)
							
						updateLvPoseList()
							
						setSelectedPose() --almacena la pose seleccionada actualmente
						enableDisableGetPose() --decide si se puede obtener pode o aplicarla
						updateInfo()	--actualiza el label Info con la informacion actual
						ddlPoseCategory.text = newCategory
					)--if success
					else
					(
						lb.message.show "Category change couldn't be done, check there is not a name conflict between two poses." type:#message pos:undefined size:[300,75] modal:true
						ddlPoseCategory.text = selectedPose.category
					)
				)
				else
				(
					ddlPoseCategory.text = selectedPose.category
				)--if all
			)--if pose
		)

		---------------------------------------------------------------------------
		--cambia la pose de nombre
		--vuelve a dejar seleccionada esa pose
		---------------------------------------------------------------------------
		on edtPoseName entered newName do
		(
			if selectedPose != undefined then --si hay pose seleccionada
			(
				selFoldersBckp = #()			--almacena los folders de poses actualmente seleccionados
				selCategoriesBckp = #()		--almacena las categorías de pose actualmente seleccionadas
				
				for f in oldSelectedFolders do --rellena el array
					append selFoldersBckp poseFoldersOwners[f+1]
				
				for c in oldSelectedCategories do --rellena el array
					append selCategoriesBckp actualCategories[c+1]
				
				--obtiene los nombres viejos de la pose
				oldFullName				= selectedPose.fullName
				oldFileName				= selectedPose.file
				oldThumbnailName	= selectedPose.thumbnailFile
				
				--calcula los nombre nuevos de la pose
				newFullName			= substituteString oldFullName selectedPose.name newName
				newFileName			= substituteString oldFileName oldFullName newFullName
				newThumbnailName	= substituteString oldThumbnailName oldFullName newFullName
				
				--renombra los archivos
				success = renameFile oldFileName newFileName
				
				if success then
				(
					renameFile oldThumbnailName newThumbnailName
				
					--Reinicializacion------------------------
					fillFoldersCategoriesPosesInfo()		--obtiene la informacionde folders, poseCategories y poses
					fillLvPoseFolders()						--rellena el listado de folders
					
					--actualiza la informacion cargada
					for i=1 to lvPoseFolders.items.count do
						lvPoseFolders.items.item[i-1].selected = (findItem selFoldersBckp lvPoseFolders.items.item[i-1].text != 0)
					
					for i=lvPoseFolders.items.count to 1 by -1 do
						if lvPoseFolders.items.item[i-1].selected then
							lvPoseFolders.ensureVisible (i-1)
						
					updateLvPoseFolders()
					
					for i=1 to lvCategories.items.count do
						lvCategories.items.item[i-1].selected = (findItem selCategoriesBckp lvCategories.items.item[i-1].text != 0)
					
					for i=lvCategories.items.count to 1 by -1 do
						if lvCategories.items.item[i-1].selected then
							lvCategories.ensureVisible (i-1)
						
					updateLvCategories()
						
					for i=1 to lvPoseList.items.count do
						lvPoseList.items.item[i-1].selected = (lvPoseList.items.item[i-1].text == newFullName)
					
					for i=lvPoseList.items.count to 1 by -1 do
						if lvPoseList.items.item[i-1].selected then
							lvPoseList.ensureVisible (i-1)
					
					updateLvPoseList()
						
					setSelectedPose() --almacena la pose seleccionada actualmente
					updateInfo()	--actualiza el label Info con la informacion actual
				)--if success
				else
				(
					lb.message.show "Name change couldn't be done, check there is not a name conflict between two poses." type:#message pos:undefined size:[300,75] modal:true
					edtPoseName.text = selectedPose.name
				)
			)
		)

		---------------------------------------------------------------------------
		--actualiza el icono del folder seleccionado
		---------------------------------------------------------------------------
		on lvPoseFolders mouseUp events do
		(	
			if events.Button.toString() == "Right" then
				showContextualMenu()
			else
			(
				updateFlag = false --flag para saber si actualizar o no
				
				--recorre los elementos para ver si la seleccion es diferente
				for i=1 to lvPoseFolders.items.count do
					if lvPoseFolders.items.item[i-1].selected then
					(
						if findItem oldSelectedFolders (i-1) == 0 then updateFlag = true
					)
					else
					(
						if findItem oldSelectedFolders (i-1) != 0 then updateFlag = true
					)
				
				if lvPoseFolders.items.count != 0 then
					if lvPoseFolders.selectedItems.count == 0 and oldSelectedFolders.count != 0 then
					(
						for oldFold in oldSelectedFolders do
							lvPoseFolders.items.item[oldFold].selected = true
						
						updateFlag = true
					)
					
				if updateFlag then --si la seleccion es diferente tiene que actualizar
				(
					if chkSyncronize.checked then
						syncronize()
					else
					(
						updateLvPoseFolders()
						updateLvCategories()
						updateLvPoseList()
					)
				)
			)
		)

		---------------------------------------------------------------------------
		--se asegura de que siempre haya una categoria seleccionada
		---------------------------------------------------------------------------
		on lvCategories mouseUp events do
		(
			if events.Button.toString() == "Right" then
				showContextualMenu()
			else
			(
				updateFlag = false --flag para saber si actualizar o no
				
				--recorre los elementos para ver si la seleccion es diferente
				for i=1 to lvCategories.items.count do
					if lvCategories.items.item[i-1].selected then
					(
						if findItem oldSelectedCategories (i-1) == 0 then updateFlag = true
					)
					else
					(
						if findItem oldSelectedCategories (i-1) != 0 then updateFlag = true
					)
				
				if lvCategories.items.count != 0 then
					if lvCategories.selectedItems.count == 0 and oldSelectedCategories.count != 0 then
					(
						for oldCat in oldSelectedCategories do
							lvCategories.items.item[oldCat].selected = true
						
						updateFlag = true
					)
					
				if updateFlag then --si la seleccion es diferente tiene que actualizar
				(
					updateLvCategories()
					updateLvPoseList()
				)
			)
		)

		---------------------------------------------------------------------------
		--actualiza el interface con la pose seleccionada actualmente	
		---------------------------------------------------------------------------
		on lvPoseList mouseUp events do
		(
			if events.Button.toString() == "Right" then
				showContextualMenu()
			else
			(
				updateFlag = false --flag para saber si actualizar o no
				
				--recorre los elementos para ver si la seleccion es diferente
				stop = false
				cont = 1
				
				while (not stop) and (cont <= actualPoses.count) do
				(
					if (lvPoseList.items.item[cont-1].selected) and ((cont - 1) != oldSelectedPoses[1]) then
					(
						updateFlag = true
						stop = true
					)
					
					cont += 1
				)
					
				if updateFlag then --si la seleccion es diferente tiene que actualizar
				(
					updateLvPoseList()
				)
			)
		)
		
		---------------------------------------------------------------------------
		--actualiza el interface con la pose seleccionada actualmente	
		---------------------------------------------------------------------------
		on lvPoseList MouseDoubleClick events do
		(
			updateFlag = false --flag para saber si actualizar o no
			
			--recorre los elementos para ver si la seleccion es diferente
			stop = false
			cont = 1
			
			while (not stop) and (cont <= actualPoses.count) do
			(
				if (lvPoseList.items.item[cont-1].selected) and ((cont - 1) != oldSelectedPoses[1]) then
				(
					updateFlag = true
					stop = true
				)
				
				cont += 1
			)
				
			if updateFlag then --si la seleccion es diferente tiene que actualizar
			(
				updateLvPoseList()
			)
			
			local nodes = getCurrentSelection()	--seleccion actual
			
			selectedAssets = lb.asset.getAssetsFromNodes nodes
			
			if selectedAssets.count > 0 then
			(
				--obtiene la pose de un fichero y la aplica a los assets seleccionados ------------------------------------
				undo "Apply Pose" on
				(
					success = lb.copyPasteFunctions.fileToBuffer (selectedPose.file)	
					if success then
						lb.copyPasteFunctions.pasteTracks assets:selectedAssets applyToSelectionOnly:chkSelectedOnly.checked ignoreRootAndBase:(not chkIncludeRoot.checked) applyToOpposite:(keyboard.controlPressed) --aplica la pose del buffer global de tracks
					else
						lb.message.show "Pose not Loaded, something fails" type:#message pos:undefined size:[300,75] modal:true
				)
				----------------------------------------------------------------------------------------------------------------
			)					
			else --si no hay assets seleccionados
				lb.message.show "there are no objects selected, can't get a pose.\nPlease select objects from one asset." type:#message pos:undefined size:[300,75] modal:true
		)

		---------------------------------------------------------------------------
		--detecta si se hace scroll en el grid
		---------------------------------------------------------------------------
		on dgPoses Scroll events do
		(
			scrollOffset = dgPoses.VerticalScrollingOffset
			
			offset = scrollOffset - lastScrollOffset
			
			for i=2 to (dgPoses.controls.count - 1) do
				dgPoses.controls.item[i].location.y -= offset
			
			lastScrollOffset = scrollOffset
		)

		---------------------------------------------------------------------------
		--evento que se lanza cada vez que pulsemos uno de los controles del grid
		--actualiza la pose seleccionada en el UI
		---------------------------------------------------------------------------
		on dgPoses cellMouseUp events do
		(
			if events.Button.toString() == "Right" then
				showContextualMenu()
			else
			(
				for i=1 to dgPoses.rows.count do
					for j = 1 to dgPoses.columns.count do
						(dgPoses.item (j-1) (i-1)).selected = false
					
				(dgPoses.item (events.columnIndex) (events.rowIndex)).selected = true
				
				index = events.rowIndex*numColumns + events.columnIndex + 1
				
				if index < (dgPoses.controls.count - 1) and index < (actualPoses.count + 1) then
				(
					lvPoseList.items.item[oldSelectedPoses[1]].selected = false
					oldSelectedPoses = #((index - 1))
					lvPoseList.items.item[index - 1].selected = true
					lvPoseList.ensureVisible (index - 1)
					setSelectedPose()
					
					updateInfo()
					
			-- 					--actualizacion de los colores del listado y guarda los indices seleccionados ---
					for i=1 to lvPoseList.items.count do
					(
						lvPoseList.items.item[i-1].backColor = lvBackColor
						lvPoseList.items.item[i-1].foreColor = lvForeColor
						
						ind = findItem standarCategories actualPoses[i].category
							
						if ind !=0 then --para categorias estandard
							lvPoseList.items.item[i-1].backColor = standarCategoriesColors[ind]
						else --para categorias personalizadas
						(
							ind = findItem customCategories actualPoses[i].category
							
							if ind > 10 then ind = (ind - ((ind/10)*10))
							
							if ind != 0 then
								lvPoseList.items.item[i-1].backColor = customCategoriesColors[ind]
						)
					)--for
					
					lvPoseList.items.item[index - 1].backColor = lvSelBackColor
					lvPoseList.items.item[index - 1].foreColor = lvSelForeColor
					
				)--if
			)
		)
		
		---------------------------------------------------------------------------
		--evento que se lanza cada vez que hagamos doble click en uno de los controles del grid
		--aplica la pose pulsada
		---------------------------------------------------------------------------
		on dgPoses CellMouseDoubleClick events do
		(
			if doesFileExist selectedPose.file then
			--if (dgPoses.item (events.columnIndex) (events.rowIndex)).value != undefined then
			(
				local nodes = getCurrentSelection()	--seleccion actual
				
				selectedAssets = lb.asset.getAssetsFromNodes nodes
				
				if selectedAssets.count > 0 then
				(
					index = events.rowIndex*numColumns + events.columnIndex + 1
					
					if index < (dgPoses.controls.count - 1) and index < (actualPoses.count + 1) then
					(
						--obtiene la pose de un fichero y la aplica a los assets seleccionados ------------------------------------
						undo "Apply Pose" on
						(
							success = lb.copyPasteFunctions.fileToBuffer (selectedPose.file)	
							if success then lb.copyPasteFunctions.pasteTracks assets:selectedAssets applyToSelectionOnly:chkSelectedOnly.checked ignoreRootAndBase:(not chkIncludeRoot.checked) applyToOpposite:(keyboard.controlPressed)--aplica la pose del buffer global de tracks
						)
						----------------------------------------------------------------------------------------------------------------
					)
				)					
				else --si no hay assets seleccionados
					lb.message.show "there are no objects selected, can't get a pose.\nPlease select objects from one asset." type:#message pos:undefined size:[300,75] modal:true
			)
		)

		---------------------------------------------------------------------------
		--añade un folder de poses al listado, se pierden al guardar la herramienta
		---------------------------------------------------------------------------
		on btnAddPoseFolder pressed do
		(
			
			--El usuario selecciona una carpeta y la guardamos en folder
			_folder = getSavePath initialDir:lastAddedFolder
			
			--Miramos que no haya cancelado la ventana de buscar carpeta
			if _folder != undefined then
			(
				--Dividimos la carpeta en partes para analizarla
				_folderParts = filterString _folder "\\"
				
				--Si es una carpeta de pose la cargamos.
				if finditem lb.nc.NC_assetTypes (filterString _folderParts[_folderParts.count] "_")[1] != 0 then
				(
					--Miramos si tiene una carpeta pose dentro y si es asi se la concatenamos
					if (getDirectories (_folder + "\\pose")).count == 1 do _folder += "\\pose"
					--Ponemos el nombre del asset al que pertenece
					_owner = _folderParts[_folderParts.count]
				)
				else if(_folderParts[_folderParts.count] == "pose") then --Si es una carpeta de pose
					--Ponemos el nombre del padre como owner
					_owner = _folderParts[_folderParts.count-1]
				else
					_owner = undefined
				
				if (_owner != undefined and (findItem poseFolders _folder == 0 and findItem poseFoldersOwners _owner == 0)) then
				(
					_folder += "\\"
					append addedFolders _folder
					refreshAllInfo()
				)
				else
					lb.message.show "This folder is already in the list" type:#message pos:undefined size:[300,75] modal:true
			)
		)
		
		---------------------------------------------------------------------------
		--elimina el folder seleccionado del listado, siempre y cuando sea un added folder
		---------------------------------------------------------------------------
		on btnDeletePoseFolder pressed do
		(
			if oldSelectedFolders.count != 0 then --si hay algun folder seleccionado
			(
				fail = false
				
				for i=oldSelectedFolders.count to 1 by -1 do
				(
					index = findItem addedFolders poseFolders[oldSelectedFolders[i]+1]
					
					if index != 0 then
						deleteItem addedFolders index
					else
						fail = true
				)
				
				--fillFoldersCategoriesPosesInfo()		--obtiene la informacionde folders, poseCategories y poses
				--fillLvPoseFolders()	--rellena el listado de folders
				
				if fail then
					lb.message.show "Some folders couldn't be deleted, only folders added by the user can be deleted" type:#message pos:undefined size:[300,75] modal:true
				else
					refreshAllInfo()
			)
		)

		---------------------------------------------------------------------------
		--activa y desactiva la sincronizacion
		---------------------------------------------------------------------------
		on chkSyncronize changed state do
		(
			removeSceneEvents()
			
			if state then
			(
				createSyncronizeChangeHandler()
				bckpSel = getCurrentSelection()
				
				if bckpSel.count == 0 and objects.count != 0 then select objects[1]
				
				clearSelection()
				select bckpSel
			)
			else
				createSelectionChangeHandler()
		)

		---------------------------------------------------------------------------
		--reactualiza la informacion de toda la herrmienta
		---------------------------------------------------------------------------
		on btnRefresh pressed do
		(
			refreshAllInfo()
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

			dgc = dotNetClass "system.gc"
			dgc.collect()
			gc light:true

			--UI------------------------------------
			btnExpand.BackColor = (dotNetClass "System.Drawing.Color").DarkGray
			ddlPoseCategory.BackColor = (dotNetClass "System.Drawing.Color").fromargb 225 225 225
			loadSettings()
			
			--Inicializacion------------------------
			fillFoldersCategoriesPosesInfo()		--obtiene la informacionde folders, poseCategories y poses
			
			initGridView()
			
			fillLvPoseFolders()	--rellena el listado de folders
			updateLvPoseFolders()
			fillLvCategories()
			updateLvCategories()
			fillLvPoses()
			updateLvPoseList()

			if dgPoses.controls.count > 2 then
			(
				for i=1 to dgPoses.rows.count do --deselecciona todos los elementos del grid
					for j = 1 to dgPoses.columns.count do
						(dgPoses.item (j-1) (i-1)).selected = false
				
				if oldSelectedPoses[1] != undefined then
				(
					row = (oldSelectedPoses[1]/numColumns)
					col = oldSelectedPoses[1] - row*numColumns
					
					(dgPoses.item col (row)).selected = true
					--(dgPoses.item col (row*2)).selected = true
					--(dgPoses.item col (row*2 + 1)).selected = true
				)
			)
			
			removeSceneEvents()
			
			if chkSyncronize.checked then --si la sincronizacion debe estar activada la activa
			(
				createSyncronizeChangeHandler()
				bckpSel = getCurrentSelection()
				
				if bckpSel.count == 0 and objects.count != 0 then select objects[1]
				
				clearSelection()
				select bckpSel
			)
			else
				createSelectionChangeHandler()
			
			enableDisableGetPose() --decide si se puede obtener o no una pose
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

			dgc = dotnetclass "system.gc"
			dgc.collect()
			gc light:true

			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: poseManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_poseManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Pose Manager",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_poseManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_poseManager() --crea la herramienta
)