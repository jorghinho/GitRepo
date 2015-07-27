------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	-- funcion candidata a pasar a una libreria
	fn getFilesRecursive root pattern =
	(
		dir_array = getDirectories (root+"/*")
		for d in dir_array do
  			join dir_array (getDirectories (d+"/*"))
		my_files = #()
		for f in dir_array do
  			join my_files (getFiles (f + pattern))
		my_files
	)
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollAssetsDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollAssetsDef "Rollout Assets" width:350 height:700
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		local assetsPath = "y:/asset"
		

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local lstAssetsPaths = #()
		local lstAssetsTypes = #()
	
		local okColor = (dotNetClass "System.Drawing.Color").fromargb 80 255 80
		local errorColor = (dotNetClass "System.Drawing.Color").fromargb 255 80 80
		local missingColor = (dotNetClass "System.Drawing.Color").fromargb 255 112 0
		local fileInfoChecked = "CHECKED"
		local fileInfoUnChecked = "UNCHECKED"
		local assetFilesInfoData = #()
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles
		--listbox lstTypes "Asset Types" pos:[208,24] width:100 height:10 selection:0 visible:false
		radiobuttons rbnTypes "Asset Types" pos:[220,10] width:38 height:78 labels:#("chr", "prp", "fx", "set") default:0 
		
		checkbox chkAssetFileChecked "CHECKED" pos:[640,8] width:80 height:15 checked:true
		checkbox chkAssetFileUnChecked "UNCHECKED" pos:[640,24] width:80 height:15 checked:true
		
		edittext etxFiltroAsset "" pos:[10,10] width:200 height:17
		listbox lstAssets "Assets" pos:[10,30] width:200 height:38
		label lblSeqProgress "progreso" pos:[10,560] width:200 height:15 style_sunkenedge:true 
		progressBar pbSeq "ProgressBar" pos:[10,580] width:198 height:23
		dotNetControl lvInfoAssets "System.Windows.Forms.ListView" pos:[220,46] width:500 height:560
		
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
			lv = lvInfoAssets
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

			lv.columns.add "File" 416
			--lv.columns.add "Variations" 60
			--lv.columns.add "LoadMode" 110
			lv.columns.add "Checked" 80

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)


		fn getFoldersRecursive folder = 
		(
--  		format "Procesando: %\n" folder
			folders = #()
			append folders folder
			carpetas = getDirectories (folder+"/*")
--  			format "Número de subcarpetas en % : % \n" folder carpetas.count 
--  			format "Carpetas: %\t Total: %\n" carpetas carpetas.count
			if carpetas.count == 0 then 
			(	
--  				format "volviendo...\n"
				
				--return #() 
			)
			else
				(
					for f in carpetas do
					(
--  						format "subcarpeta: %\n" f
						join folders (getFoldersRecursive f)
					)
					--join carpetas subcarpetas
				)
--  			format "Devolviendo : %\n" carpetas
			folders
		)
		

		fn extractFileInfoPartsAsset _path = 
		(
			_extractedFiles = #()
			parts = "version/part/*.max"
			pathParts = _path + parts
			
			maxfiles = getFiles pathParts
			pbSeq.value = 0
			contador = 1
			maximo = (maxfiles.count as float)
			for f in maxfiles do
			(	
				pbSeq.value = (100.0*(contador as float) / maximo) as integer
				lblSeqProgress.text = (contador as string ) + "/" + (maximo as string) + " --> " + ( f as string) 
				_fileData = parent.fileMiniData()
				_fileData.file = f
				if (lb.fileInfo.isFileChecked f) then
						(
							_fileData.checked = "CHECKED"	
						)
						else
						(
							_fileData.checked = "UNCHECKED"
						)
				
				append _extractedFiles _fileData	
				contador += 1			
			)
			pbSeq.value = 0
			
			_extractedFiles
		)

		fn fillCheckFiltersAsset =
		(
			_checksFilters = #()
						
			
			_checksFilters 



		)


		fn fillStatusCheckFiltersAsset = 
		(
			_checksStatusFilters = #()

			_statusFiltros = parent.filtros()
			_statusFiltros.chkButton = chkAssetFileChecked
			_statusFiltros.chkFilter = fileInfoChecked
			append _checksStatusFilters _statusFiltros

			_statusFiltros = parent.filtros()
			_statusFiltros.chkButton = chkAssetFileUnChecked
			_statusFiltros.chkFilter = fileInfoUnChecked
			append _checksStatusFilters _statusFiltros			

			_checksStatusFilters


		)


		fn fillAssetTypeList =
		(	
			lstAssetsTypes = #()
			lstAssetsPaths = #()
			for tipo in lb.nc.NC_assetTypes do
			(
				
				myPath = assetsPath + "/" + tipo
				if  doesFileExist( myPath) then 
				(
					append lstAssetsTypes tipo
					append lstAssetsPaths myPath
				)

			)
			--rbnTypes.labels = tipos
			--lstTypes.items = tipos
		)

		fn initAssetList = 
		(
			fillAssetTypeList()
		)

		fn fillInfoListViewAsset _fileInfoData = 
		(

			--format "hay % ficheros\n" _fileInfoData.count

			lvInfoAssets.items.clear()

			for i = 1 to _fileInfoData.count do
			(

				--format "% -- %\n"  _fileInfoData[i].checked _fileInfoData[i].file
				lvInfoAssets.items.add(filenameFromPath _fileInfoData[i].file)
				lvInfoAssets.items.item[i-1].SubItems.add (_fileInfoData[i].checked)

				if _fileInfoData[i].checked == "CHECKED" then
				(
					lvInfoAssets.items.item[i-1].SubItems.item[1].backColor = okColor
				)
				else if _fileInfoData[i].checked == "UNCHECKED" then
				(
					--print errorColor
					lvInfoAssets.items.item[i-1].SubItems.item[1].backColor = errorColor
				)
				else
				(
					--print missingColor
					lvInfoAssets.items.item[i-1].SubItems.item[1].backColor = missingColor
				)

			)
			lvInfoAssets.update()

		)

		fn filterFileInfosAsset _extractedFileInfos =
		(
			
			struct str_checks ( sufijos = false , QCheck = false)

			--format "fn filterFileInfosAsset _extractedFileInfos _ %\n" _extractedFileInfos

			--checksFilters = fillCheckFiltersAsset()
			checksStatusFilters = fillStatusCheckFiltersAsset()

			_filtered = #()

			for f in _extractedFileInfos do
			(
				filtrado = str_checks()
				checkedMatched = false
				indice = 1 
				while not checkedMatched and indice <= checksStatusFilters.count do
				(
					csf = checksStatusFilters[indice]
					if csf.chkButton.checked then 
					(
						checkedMatched = matchpattern (filenameFromPath f.checked) pattern:(csf.chkFilter)
						if checkedMatched then filtrado.QCheck = true
					)

					indice +=1
				)
				--format "% : % -- %\n" filtrado.sufijos filtrado.QCheck  f.file
				if filtrado.QCheck then append _filtered f

					

				
			)

			--format "______________________________________\n"
			--print _filtered
			_filtered
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
			if size.x < minRollWidth then (size.x = minRollWidth; rollAssetsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollAssetsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollAssets/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollAssets/category") "paramName") as <value type>
		)
		

		fn fillAssetList path aTipo =
		(
			carpetas = getFoldersRecursive path 
			assets = #()
			lstAssetsPaths = #()
			for i in carpetas do
			(
				folder = filenameFromPath i
				patron = aTipo+"_*"
				if (matchpattern folder pattern: patron ) then 	
				(
					
					append lstAssetsPaths i
				)
			)
			sort lstAssetsPaths
			for a in lstAssetsPaths do
			(
				folder = filenameFromPath a
				append assets folder

				)
			lstAssets.items = assets
			lstAssets.selection = 0
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
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------

		on rollAssetsDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
		
			initAssetList()
			initInfoListView()
		
		
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		on rollAssetsDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
		on rollAssetsDef resized size do
		(
			resize size
		)
		on lstTypes selected tipo do
		(
			print "Seleccionado"
			assetTypePath = assetsPath + "/" + lstTypes.items[tipo]
		
		
			lvInfoAssets.items.clear()
			--format  "PATH: % \n" assetTypePath
			fillAssetList assetTypePath  lstTypes.items[tipo]  --if lstAssets.items.count==0 then (
		
		)
		on rbnTypes changed tipo do
		(
			
			assetTypePath = assetsPath + "/" + lstAssetsTypes[tipo]
			--format "fillAssetList: % %\n" assetTypePath lstAssetsTypes[tipo]
			fillAssetList assetTypePath  lstAssetsTypes[tipo]
		
		)
		on etxFiltroAsset changed texto do
		(
			patron = "*"+texto+"*"
			encontrado = false
			indice = 0
			--format "total assets: %\n" lstAssetsPaths.count 
			while not encontrado and indice < lstAssetsPaths.count do
			(	
				indice +=1
				--format "indice: %\n" indice
				encontrado = matchPattern lstAssets.items[indice] pattern:patron
			)
		
			if encontrado then lstAssets.selection = indice
			
		
		)
		on lstAssets selected indice do
		(
			--format "%\n" lstAssetsPaths[indice]
			assetFilesInfoData = extractFileInfoPartsAsset lstAssetsPaths[indice]
			filtredFilesInfoData = filterFileInfosAsset (assetFilesInfoData)
			fillInfoListViewAsset (filtredFilesInfoData)		
		)


		on chkAssetFileChecked changed arg do
		(
			filtredFilesInfoData = filterFileInfosAsset (assetFilesInfoData)
			fillInfoListViewAsset (filtredFilesInfoData)
		)

		on chkAssetFileUnChecked changed arg do
		(
			filtredFilesInfoData = filterFileInfosAsset (assetFilesInfoData)
			fillInfoListViewAsset (filtredFilesInfoData)
		)



		on lstAssets doubleClicked indice do
		(
			shelllaunch (lstAssetsPaths[indice]) ""
		
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollSequencesDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollSequencesDef "Rollout Sequences" width:740 height:620
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
		local lstSequencesPaths = #() 
		local lvColumnsArr=#("Files", "Is checked")
		local seqPath = "y:/sequence/movie"
		local okColor = (dotNetClass "System.Drawing.Color").fromargb 80 255 80
		local errorColor = (dotNetClass "System.Drawing.Color").fromargb 255 80 80
		local missingColor = (dotNetClass "System.Drawing.Color").fromargb 255 112 0
		local fileNameCheckFilters = #(lb.nc.NC_layoutFileName, lb.nc.NC_animFileName, lb.nc.NC_PCfileName, lb.nc.NC_clothFileName,  lb.nc.NC_fxFileName, lb.nc.NC_renderFileName, lb.nc.NC_setPrefix)
		local checksFilters = #()
		local checksStatusFilters = #()
		local seqFilesInfoData = #()
		local filtredFilesInfoData = #()
		local fileInfoChecked = "CHECKED"
		local fileInfoUnChecked = "UNCHECKED"
		local checkedFilesStatus = #(fileInfoChecked,fileInfoUnChecked)
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles

		edittext etxFiltroSeq "" pos:[10,10] width:200 height:17
		listbox lstSequences "Sequences" pos:[10,30] width:200 height:38 selection:0
		label lblSeqProgress "progreso" pos:[10,560] width:200 height:15 style_sunkenedge:true

		checkbox chkSeqFileChecked "CHECKED" pos:[640,8] width:80 height:15 checked:true
		checkbox chkSeqFileUnChecked "UNCHECKED" pos:[640,24] width:80 height:15 checked:true
		checkbox chkLayout "layout" pos:[223,24] width:52 height:15 checked:true
		checkbox chkAnim "anim" pos:[279,24] width:46 height:15 checked:true
		checkbox chkCache "cache" pos:[328,24] width:50 height:15 checked:true
		checkbox chkRender "render" pos:[381,24] width:54 height:15 checked:true
		checkbox chkFx "Fx" pos:[439,24] width:38 height:15 checked:true
		checkbox chkSet "set" pos:[478,24] width:40 height:15 checked:true
		checkbox chkCloth "cloth" pos:[520,24] width:48 height:15 checked:true
		progressBar pbSeq "ProgressBar" pos:[10,580] width:198 height:23

		
		
		--edittext etxFiltroFiles "" pos:[224,24] width:133 height:17
		dotNetControl lvInfoSequences "System.Windows.Forms.ListView" pos:[220,46] width:500 height:560
		button btnSelectAll "Select All" pos:[296,8] width:58 height:15

		local lstBtnChecks = #(chkLayout,chkAnim,chkCache,chkRender,chkFx,chkSet,chkCloth) 
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		-- qui metemos los botones de filtros en una lista
		fn fillCheckFiltersSeq =
		(
			_checksFilters = #()
						
			_filtros = parent.filtros()
			_filtros.chkButton = chkLayout
			_filtros.chkFilter = lb.nc.NC_layoutFileName
			append _checksFilters _filtros
			
			_filtros = parent.filtros()
			_filtros.chkButton = chkAnim
			_filtros.chkFilter = lb.nc.NC_animFileName
			append _checksFilters _filtros
			
			_filtros = parent.filtros()
			_filtros.chkButton = chkCache
			_filtros.chkFilter = lb.nc.NC_PCfileName
			append _checksFilters _filtros
			
			_filtros = parent.filtros()
			_filtros.chkButton = chkCloth
			_filtros.chkFilter = lb.nc.NC_clothFileName
			append _checksFilters _filtros
			
			_filtros = parent.filtros()
			_filtros.chkButton = chkFx
			_filtros.chkFilter = lb.nc.NC_fxFileName
			append _checksFilters _filtros
			
			_filtros = parent.filtros()
			_filtros.chkButton = chkRender
			_filtros.chkFilter = lb.nc.NC_renderFileName
			append _checksFilters _filtros
			
			_filtros = parent.filtros()
			_filtros.chkButton = chkSet
			_filtros.chkFilter = lb.nc.NC_setPrefix
			append _checksFilters _filtros
			

			_checksFilters 



		)

		-- aqui metemos los botones filtros de check o UNCHECKED en una lista

		fn fillStatusCheckFiltersSeq = 
		(
			_checksStatusFilters = #()

			_statusFiltros = parent.filtros()
			_statusFiltros.chkButton = chkSeqFileChecked
			_statusFiltros.chkFilter = fileInfoChecked
			append _checksStatusFilters _statusFiltros

			_statusFiltros = parent.filtros()
			_statusFiltros.chkButton = chkSeqFileUnChecked
			_statusFiltros.chkFilter = fileInfoUnChecked
			append _checksStatusFilters _statusFiltros			

			_checksStatusFilters


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
		fn initInfoSeqListView =
		(
			lvs = lvInfoSequences
			lvs.columns.clear()
			lvs.multiSelect = false
			lvs.gridLines = true
			lvs.View = (dotNetClass "System.Windows.Forms.View").details
			lvs.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lvs.fullRowSelect = true
			lvs.backColor = colorBackUnselected
			lvs.foreColor = colorFore
			lvs.scrollable = true
			lvs.labelEdit = false
			lvs.columns.add "File" 416
			lvs.columns.add "Checked" 80
			lvs.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
			--lstSeqInfo.items = #("items inicializados")
		)

		fn compareFN v1 v2 col: = 
		(
    		case of 
    		(
        		(v1[col]>v2[col]) : 1
        		(v1[col]<v2[col]) : -1
        		default: 0
        	)
    	)

		fn extractFileInfoPartsSeq _path = 
		(
			
			_extractedFiles = #()
			pathParts = _path + lb.nc.NC_camFolder
			maxfiles = getFilesRecursive pathParts "*.max"
			pbSeq.value=0
			contador = 1
			maximo = maxfiles.count as float
			setWaitCursor() 		

			for f in maxfiles do
			(	
				
				progreso = (((100.0*contador / maximo)) as integer)
				pbSeq.value = progreso


				lblSeqProgress.text = (contador as string ) + "/" + (maximo as string) + " --> " + ( f as string) 
				
				_fileData = parent.fileMiniData()
				_fileData.file = f
				if (lb.fileInfo.isFileChecked f) then
					(
						_fileData.checked = fileInfoChecked	
					)
					else
					(
						_fileData.checked = fileInfoUnChecked
					)
				windows.processPostedMessages()
				appendIfUnique _extractedFiles _fileData								
				contador +=1
			)
			pBSeq.value =0
			
			setArrowCursor() 			 
			_extractedFiles
		)

		fn filterFileInfosSeq _extractedFileInfos =
		(
			
			struct str_checks ( sufijos = false , QCheck = false)

			checksFilters = fillCheckFiltersSeq()
			checksStatusFilters = fillStatusCheckFiltersSeq()

			_filtered = #()

			for f in _extractedFileInfos do
			(
				filtrado = str_checks()
				--format "%\n" f.file
				sufixmatched = false
				indice = 1
				while not sufixmatched and indice <= checksFilters.count do
				(	
					cf = checksFilters[indice]	
					if cf.chkButton.checked then 
					(
						sufixmatched = matchpattern (filenameFromPath f.file) pattern:("*"+cf.chkFilter+"*.max")		
						if sufixmatched then filtrado.sufijos = true
					)

					indice +=1
				)

				checkedMatched = false
				indice = 1 
				while not checkedMatched and indice <= checksStatusFilters.count do
				(
					csf = checksStatusFilters[indice]
					if csf.chkButton.checked then 
					(
						checkedMatched = matchpattern (filenameFromPath f.checked) pattern:(csf.chkFilter)
						if checkedMatched then filtrado.QCheck = true
					)

					indice +=1
				)
				--format "% : % -- %\n" filtrado.sufijos filtrado.QCheck  f.file
				if filtrado.sufijos and filtrado.QCheck then append _filtered f

					

				
			)

			--format "______________________________________\n"
			--print _filtered
			_filtered
		)


		-- # mirar como crea las columnas la funcion  "populate"
		fn fillInfoListViewSeq _fileInfoData = 
		(

			--format "hay % ficheros\n" fileInfoData.count
 			lvInfoSequences.items.clear()


			for i = 1 to _fileInfoData.count do
			(

				lvInfoSequences.items.add(filenameFromPath _fileInfoData[i].file)
				lvInfoSequences.items.item[i-1].SubItems.add (_fileInfoData[i].checked)

				if _fileInfoData[i].checked == "CHECKED" then
				(
					lvInfoSequences.items.item[i-1].SubItems.item[1].BackColor = okColor
				)
				else if _fileInfoData[i].checked == "UNCHECKED" then
					(	
						lvInfoSequences.items.item[i-1].SubItems.item[1].BackColor = errorColor
					)
					else
					(
						lvInfoSequences.items.item[i-1].SubItems.item[1].BackColor = missingColor
					)

				--lvInfoSequences.update()

			)
			lvInfoSequences.update()
			
		)




		fn fillSeqList =
		(	
			seqs=#()
			lstSequencesPaths = getdirectories (seqPath + "/" + lb.nc.NC_seqPrefix + "_*(???)")
			sort lstSequencesPaths

			for folder in lstSequencesPaths do
			(
				myfolder = filenameFromPath folder
				append seqs myfolder
			)

			lstSequences.items = seqs
			lstSequences.selection = 0
		)

		fn initSeqList = 
		(
			fillSeqList()
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
			if size.x < minRollWidth then (size.x = minRollWidth; rollSequencesDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollSequencesDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollAssets/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollAssets/category") "paramName") as <value type>
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
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------

		



		button btnSelectNone "Select None" pos:[496,8] width:64 height:15
		button btnInvertSelection "Invert Selection" pos:[384,8] width:88 height:15
		on rollSequencesDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
		
			initSeqList()
			initInfoSeqListView()
		
		
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		
		)
		on rollSequencesDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
		on rollSequencesDef resized size do
		(
			resize size
		)
		on etxFiltroSeq changed texto do
		(
			patron = "*"+texto+"*"
			encontrado = false
			indice = 0
			--format "total assets: %\n" lstSequencesPaths.count  
			while not encontrado and indice < lstSequencesPaths.count do
			(	
				indice +=1
				--format "indice: %\n" indice
				encontrado = matchPattern lstSequences.items[indice] pattern:patron
			)
		
			if encontrado then lstSequences.selection = indice
			
		
		)
		on lstSequences selected indice do
		(
			--format "extractFileInfoPartsSeq %\n" lstSequencesPaths[indice]
			seqFilesInfoData = extractFileInfoPartsSeq lstSequencesPaths[indice]
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			--format "seqFilesInfoData:%\n" filtredFilesInfoData
			fillInfoListViewSeq (filtredFilesInfoData)
		
		)
		on lstSequences doubleClicked indice do
		(
			shelllaunch (lstSequencesPaths[indice]) ""
		
		)
		on chkSeqFileChecked changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on chkSeqFileUnChecked changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on chkLayout changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on chkAnim changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on chkCache changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on chkCloth changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on chkFx changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on chkRender changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on chkSet changed arg do
		(
			filtredFilesInfoData = filterFileInfosSeq (seqFilesInfoData)
			fillInfoListViewSeq (filtredFilesInfoData)
		)
		on btnSelectAll pressed do
		(
			for c in lstBtnChecks do c.checked = on
		)
		on btnSelectNone pressed do
		(
			for c in lstBtnChecks do c.checked = off
		)
		on btnInvertSelection pressed do
		(
			for c in lstBtnChecks do c.checked = not c.checked
		)
		on lvInfoSequences columnClick arg do
		(
		    lvInfoSequences.Clear()
		    addColumns lvInfoSequences lvColumnsArr
		    case arg.Column of (
		        --0: makeshuffle arr --shuffle array
		        1: qsort arr compareFN col:1
		        2: qsort arr compareFN col:2
		        ) 
		    populateList lvInfoSequences arr
		    --for i in olditems do (lv.items.item[i].font=boldfont; lv.items.item[i].Selected=true)
		)
	)
	

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollSequencesDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollAboutDef "About" width:350 height:700
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
		button btnEjemplo "Ejemplo"	pos:[10,10]	
		bitmap bmpAbout "About" filename: "$plugins\\stdscripts\\lbTools\\image\\lbAbout_pipeClub.jpg"
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
			if size.x < minRollWidth then (size.x = minRollWidth; rollAboutDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollAboutDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollAssets/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollAssets/category") "paramName") as <value type>
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
		on rollAboutDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollAboutDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollAboutDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollAboutDef
	




	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Check Verificator 1.0"  width:800 height:800 --width:740 height:620
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 680	--@var: minRollHeight | Minimun tool height.

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
			if _increment.x != 0 then --si hay incremento
			(				
				tbTabs.width = 350 + _increment.x
				if tbTabs.tabPages.count != 0 then tbTabs.TabPageWidth = (minRollWidth + _increment.x)/(tbTabs.tabPages.count) - 17
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

	struct str_fileMiniData(file = "", loadmode = "", checked = "", level = 0, numVariations = 0)

	struct str_filters (chkButton = "", chkFilter = "")

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: checkVerificator | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_checkVerificator
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
		
		minWidth = 800,		--@var: minWidth | Ancho mínimo de la herramienta.
		minHeight = 800,		--@var: minHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		presetFile = "",
		fileMiniData = str_fileMiniData,
		filtros = str_filters,
		statusFiltros = str_filters,
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

		rollAssets = rollAssetsDef,
		rollSequences = rollSequencesDef,
		rollAbout = rollAboutDef,
		
		rollMain = rollMainDef,	--@var: rollMain | Main tool rollout.
		
		subRolloutsContainer = this.rollMain.subRollContainer, --@var: subRolloutsContainer | contenedor de subrollouts.

		--estos arrays se rellenan en la funcion fillTabsRolloutsDefs, que se llama al abrir la herramienta.
		--esto es solo la defincion de las variables y una ejemplo de estructura que luego se sobrescribe.
		tabNames = #("", "", ""), --@var: tambNames | Nombres de los tabs.
		tabRollouts = #(#(undefined), #(undefined), #(undefined, undefined)), --@var: mentalrayTabNames | Rollots de cada tab.
		tabRolloutsRolledUp = #(#(false), #(true), #(false, true)), --@var: tabRolloutsRolledUp | Estado de desplegado/plegado de cada rollout de cada tab.

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
			this.tabNames = #("Assets", "Sequences","about") --, "Tab3"
			this.tabRollouts = #(#(lb.checkVerificator.rollAssets), #(lb.checkVerificator.rollSequences), #(lb.checkVerificator.rollAbout))  --
			this.tabRolloutsRolledUp = #(#(false), #(false), #(true))  --, #()
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
		
	)--tl_checkVerificator

	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_checkVerificator() --crea la herramienta
)