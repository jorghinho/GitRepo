------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta batchManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollBatchFilesManagerDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollBatchFilesManagerDef "Batch Files Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 700		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 500		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local allFiles = #() --array con todos los archivos .max de una arbol de directorio		

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpFilters "Filters" pos:[5,5] width:690 height:53
		
		label lblFolderFilters "Folder / Files:" pos:[15,20] width:65 height:15
		editText edtFolderFilters "" pos:[80,20] width:610 height:15
		--label lblFileFilters "File filters:" pos:[15,35] width:65 height:15
		--editText edtFileFilters "" pos:[80,36] width:610 height:15
		
		groupBox grpFiles "Files" pos:[5,60] width:690 height:435
		
		--dotNetControl trvFolders "system.windows.forms.treeView"  pos:[10,75] width:195 height:395
		label lblRootFolder "Root folder:" pos:[12,80] width:60 height:15
		editText edtRootFolder "" pos:[70,78] width:605 height:15
		button btnRootFolderGet "..." pos:[675,79] width:15 height:15
		
		button btnAddFile "Add selected" pos:[10,470] width:70 height:20
		button btnAddAllFiles "Add all" pos:[80,470] width:40 height:20
		dotNetControl lvFileList "System.Windows.Forms.ListView" pos:[10,95] width:680 height:375
		
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
		--@fn: undefined | initTreeView | Inicia el treeView con todas sus propiedades
		------------------------------------------------
		/* fn initTreeView =
		(
			trvFolders.nodes.clear() --Limpiamos los nodos del árbol para poder volver a rellenarlos
			trvFolders.borderStyle = (dotnetclass "system.windows.forms.borderStyle").fixedSingle
		) */

		------------------------------------------------
		--@fn: undefined | initListView | Inicia el listView pasado por parámetro
		------------------------------------------------
		fn initListView lv =
		(
			lv.clear()
				
			lv.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5
			lv.gridLines = true
			lv.view = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = dnBackColor
			lv.foreColor = dnForeColor
			lv.scrollable = true
			lv.labelEdit = true
			lv.hideSelection = false
			lv.labelEdit = false
			
			lv.columns.add "Files" (lv.width - 20)		
		)--fn initListView

		------------------------------------------------
		--@fn: undefined | getFolders | obtiene todos los folders y subfolders a partir de FOLDER que cumplan los patrones de FOLDERFILTERS
		------------------------------------------------
		/* 		fn getFolders folder folderFilters:#() =
		(
			_folders = #() --array para almacenar los folders que devolver
			_subFolders = getDirectories (folder + "\\*") --busca los subdirectorios del actual
			
			for i = _subFolders.count to 1 by -1 where findString _subFolders[i] ".svn" != undefined do
				deleteItem _subFolders i
			
			if folderFilters.count != 0 then
			(
				_tempFilterFolders = #() --folders que cumplen los filtros
				
				for _filter in folderFilters do
					_tempFilterFolders += getDirectories (folder + "\\" + (if _filter != "" then _filter else ""))
				
				for _fold in _subFolders do
					_tempFilterFolders += getFolders _fold folderFilters:folderFilters
						
				_folders = _tempFilterFolders
			)--if
			else
				_folders = _subFolders
			
			makeUniqueArray _folders --devuelve los folders
		) */

		------------------------------------------------
		--@fn: undefined | fillFileList | rellena el listado de Files siguiendo los filtros
		------------------------------------------------
		fn fillFileList =
		(
			lvFileList.items.clear() --resetea el listado
			
			_filteredFiles = deepCopy allFiles --hace una copia completa del array de ficheros
			
			if _filteredFiles.count != 0 then --si hay archivos con los que trabajar
			(
				if edtFolderFilters.text != "" then --si hay filtros de folder
				(
					_filterParts = filterString edtFolderFilters.text ";, "
					
					if _filterParts.count != 0 then --si hay partes que filtrar
						for i=_filteredFiles.count to 1 by -1 do --recorre los archivos en orden inverso
						(
							_delete = false --flag para saber si eliminar el archivo del listado
							
							for fp in _filterParts where findString _filteredFiles[i] fp == undefined do
								_delete = true --si no cumple el filtro lo marca para eliminar
							
							if _delete then deleteItem _filteredFiles i --elimina el archivo del listado
						)
				)--if edtFolderFilters
				
				for i=1 to _filteredFiles.count do
				(
					_row = dotNetObject "System.Windows.Forms.ListViewItem" _filteredFiles[i] --rellena la fila con la ruta del archivo
					lvFileList.items.add _row
				)--for
			)--if _filteredFiles
		)--fillFileList

		------------------------------------------------
		--@fn: undefined | fillTreeView | rellena el arbol con los folders pasados por parametro, se le pasa el nodo del arbol del que debe colgar todo
		------------------------------------------------
		/* fn fillTreeView tvParentNode folders =
		(
			_firstParts = #() --almacena las primeras partes de los folders
			_firstPartFolders = #() --array de arrays que almacena los folders que van con esas primeras partes
			
			for f in folders do --recorre los folders
			(
				_fParts = filterString f "\\" --saca las partes del folder
				appendIfUnique _firstParts _fParts[1] --añade la parte si no está en el array de primeras partes
				index = findItem _firstParts _fParts[1] --busca el indice del array donde se ha añadido
				
				if index != 0 then --si está en el listado de primeras partes
				(
					if _firstPartFolders[index] == undefined then _firstPartFolders[index] = #()
					_newFolder = (substituteString f _firstParts[index] "") --quita la primera parte al folder
					
					--quita todas las barras que haya al principio
					while _newFolder[1] == "\\" do _newFolder = subString _newFolder 2 _newFolder.count
						
					if _newFolder != "" then --si hay mas partes
						append _firstPartFolders[index] _newFolder --añade el folder a los folders a procesar en la siguiente llamada recursiva
				)--if index	
			)--for
			
			for i=1 to _firstParts.count do
			(
				newNode = dotnetObject "System.Windows.Forms.TreeNode" _firstParts[i] --crea un nuevo nodo
				tvParentNode.add newNode --cuelga el arbol en el visor de arboles
				fillTreeView newNode.nodes _firstPartFolders[i] --llama recursivamente para ver los subfolders
			)--for			
		) */

		------------------------------------------------
		--@fn: undefined | fillTreeView | rellena el arbol con los folders pasados por parametro, si no encuentra se le pasan folders, los busca a partir del rooFolder y los filtros
		------------------------------------------------		
		/* fn fillTreeViewFolder =
		(
			_folders = #() --array para almacenar los folders para el arbol
			_folderFilters = filterString edtFolderFilters.text ";, "
				
			if _folderFilters.count != 0 then --si hay filtros de folder
				_folders = getFolders edtRootFolder.text folderFilters:_folderFilters
						
			if _folders.count != 0 then --si hay folders con los que trabajar
			(
				--llama a la funcion recursiva que rellena el arbol con los folders a partir de un nodo dado
				fillTreeView (trvFolders.nodes) _folders
			)--if
		) */

		------------------------------------------------
		--@fn: undefined | resetUI | inicia el UI de la herramienta
		------------------------------------------------
		fn resetUI =
		(
			if edtRootFolder.text == "" then edtRootFolder.text = "Z:\\" --si no hay unidad definida pone Z
			initListView lvFileList --resetea el listado
			
			setWaitCursor()
			allFiles = lb.fileIOFunctions.getAllFilesFromSubFolders edtRootFolder.text --rellena el array de archivos
			fillFileList() --rellena el listado de archivos
			setArrowCursor()
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
			if size.x < minRollWidth then (size.x = minRollWidth; rollBatchFilesManagerDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollBatchFilesManagerDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				grpFilters.width = grpFiles.width = size.x - 10
				edtFolderFilters.width = 605 + _increment.x-- = edtFileFilters.width
				edtRootFolder.width = 600 + _increment.x
				btnRootFolderGet.pos.x = 675 + _increment.x
				lvFileList.width = 680 + _increment.x
				lvFileList.columns.item[0].width = 660 + _increment.x
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				grpFiles.height = 435 + _increment.y
				btnAddFile.pos.y = btnAddAllFiles.pos.y = 470 + _increment.y
				lvFileList.height = 375 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollBatchFilesManager/pos") "x" (((getDialogPos rollBatchFilesManagerDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollBatchFilesManager/pos") "y" (((getDialogPos rollBatchFilesManagerDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollBatchFilesManager/size") "width" (rollBatchFilesManagerDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollBatchFilesManager/size") "height" (rollBatchFilesManagerDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollBatchFilesManager/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollBatchFilesManager/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollBatchFilesManager/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollBatchFilesManager/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollBatchFilesManagerDef.width = _width
			rollBatchFilesManagerDef.height = _height
			setDialogPos rollBatchFilesManagerDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | añade los elementos seleccionados del listado al listado de archivos a los que hacer batch en rollBatchManager.
		------------------------------------------------
		on btnAddFile pressed do
		(
			_itemsToAdd = parent.rollMain.lbxBatchFiles.items --obtiene los items actuales
			
			for i=1 to lvFileList.selectedItems.count do
				appendIfUnique _itemsToAdd (lvFileList.selectedItems.item[i-1].text)
			
			sort _itemsToAdd --ordena el array alfabeticamente
			parent.rollMain.lbxBatchFiles.items = _itemsToAdd --sobreescribe los items
		)--btnAddFile

		------------------------------------------------
		--@event: pressed | añade toda la lista al listado de archivos a los que hacer batch en rollBatchManager
		------------------------------------------------		
		on btnAddAllFiles pressed do
		(
			_itemsToAdd = rollMain.lbxBatchFiles.items --obtiene los items actuales
			
			for i=1 to lvFileList.items.count do
				appendIfUnique _itemsToAdd (lvFileList.items.item[i-1].text)
			
			sort _itemsToAdd --ordena el array alfabeticamente
			rollMain.lbxBatchFiles.items = _itemsToAdd --sobreescribe los items
		)

		------------------------------------------------
		--@event: entered text | cuando se cambia de rootFolder hay que actualizar el interface
		------------------------------------------------				
		on edtRootFolder entered text do
		(
			allFiles = lb.fileIOFunctions.getAllFilesFromSubFolders edtRootFolder.text --rellena el array de archivos
			resetUI() --reseeta el interface
		)

		------------------------------------------------
		--@event: pressed | cambia el root folder por otro
		------------------------------------------------		
		on btnRootFolderGet pressed do
		(
			_newRootFolder = getSavePath caption:"Root Folder" initialDir:edtRootFolder.text
			
			if _newRootFolder != undefined then
			(
				edtRootFolder.text = _newRootFolder --coge el nuevo fichero
				allFiles = lb.fileIOFunctions.getAllFilesFromSubFolders edtRootFolder.text --rellena el array de archivos
				resetUI() --reseeta el interface
			)--if
		)

		------------------------------------------------
		--@event: entered text | si se cambia algun filtro se vuelve a evaluar y a filtrar
		------------------------------------------------		
		on edtFolderFilters entered text do
		(
			setWaitCursor()
			fillFileList() --rellena el listado de archivos con los nuevo filtros
			setArrowCursor()
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollBatchFilesManagerDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollBatchFilesManagerDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			resetUI()

			if parent.rollBatchFilesManager != undefined then resize [parent.rollBatchFilesManager.width, parent.rollBatchFilesManager.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollBatchFilesManagerDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()

			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollBatchFilesManagerDef	

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta batchManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Batch Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 450		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 520		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpFolderFileOptions "Batch Files" pos:[5,5] width:440 height:125
		
		listbox lbxBatchFiles "" pos:[10,17] width:430 height:7
		checkbutton ckbAddFiles "+" pos:[10,113] width:16 height:13
		button btnRemoveFiles "-" pos:[26,113] width:16 height:13
		button btnRemoveAllFiles "x" pos:[42,113] width:16 height:13
		
		groupBox grpBatchFunctions "Batch Functions" pos:[5,135] width:440 height:175
		
		listbox lbxBatchFucntions " Available Batch Functions" pos:[10,150] width:200 height:10
		listbox lbxFunctionsToBatch "Functions to Batch" pos:[240,150] width:200 height:10
		button btnAdd ">" pos:[215,175] width:20 height:60
		button btnRemove "<" pos:[215,235] width:20 height:60
		
		groupBox grpBatch "Batch Process" pos:[5,315] width:440 height:200
		
		label lblSeparator01 "________________________________________________________________________" pos:[10,334] width:430 enabled:false
		label lblSeparator02 "________________________________________________________________________" pos:[10,354] width:430 enabled:false
		label lblSeparator03 "________________________________________________________________________" pos:[10,378] width:430 enabled:false
		
		--DESACTIVADAS LAS OPCIONES DE SVN PARA QUE NO SE CUELGUE
		checkbox chkUpdateFirst "svn update" pos:[12,329] width:80 height:15 checked:false enabled:false
		checkbox chkLockFirst "lock files" pos:[95,329] width:70 height:15 checked:false enabled:false
		checkbox chkCommitAtEnd "commit at end" pos:[165,329] width:85 height:15 checked:false enabled:false
		checkbox chkSimulation "simulation only" pos:[260,329] width:90 height:15 checked:false
		
		--checkbox chkSaveAsCopy "save as:" pos:[12,349] width:65 height:15 checked:false
		label lblSaveAs "Save as:" pos:[15,349] width:65 height:15 checked:false
		radiobuttons rdoSaveAsCopyOption "" pos:[60,349] width:100 height:15 labels:#("same name file", "version increment    ", "batch copy") default:1 columns:3
		
		label lblLogFile "Log File:" pos:[15,372] width:45 height:15
		edittext edtLogFile "" pos:[55,371] width:245 height:15
		button btnLogFileGet "..." pos:[300,372] width:16 height:16
		checkbox chkLogOpen "open log after batch" pos:[320,372] width:115 height:15 checked:true	
		
		--DESACTIVADAS LAS OPCIONES DE SVN PARA QUE NO SE CUELGUE
		label lblLogMessage " Commit Log Message:" pos:[10,393] width:150 enabled:false
		edittext edtLogMessage "" pos:[5,408] width:435 height:80 enabled:false
		
		button btnBatch "Batch" pos:[10,491] width:430 height:20
		
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
		--@fn: undefined | fillAvailableFunctions | rellena el listado de funciones de batch disponibles
		------------------------------------------------
		fn fillAvailableFunctions =
		(
			--recolecta las funciones de batch definidas y las mete en el array de items
			items = for bf in batchFunctionsArray collect (substituteString (bf as string) "batchFunction_" "")
			lbxBatchFucntions.items = items
		)--fillAvailableFunctions

		------------------------------------------------
		--@fn: undefined | updateUI | actualiza el UI
		------------------------------------------------		
		fn updateUI =
		(
			chkCommitAtEnd.enabled = /*chkSaveAsCopy.enabled = */ lblSaveAs.enabled = rdoSaveAsCopyOption.enabled = chkLockFirst.enabled = edtLogMessage.enabled = lblLogMessage.enabled = not chkSimulation.checked
			if chkCommitAtEnd.enabled then chkCommitAtEnd.enabled = chkLockFirst.checked
			if edtLogMessage.enabled then edtLogMessage.enabled = lblLogMessage.enabled = chkCommitAtEnd.checked	
			if edtLogMessage.enabled then edtLogMessage.enabled = lblLogMessage.enabled = chkLockFirst.checked	
		)--resetUI		

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

				grpBatch.width = grpBatchFunctions.width = grpFolderFileOptions.width = size.x - 10
					
				btnBatch.pos.x = 10 + (_increment.x/2)
				
				lbxFunctionsToBatch.pos.x = 240 + _increment.x/2
				btnAdd.pos.x = btnRemove.pos.x = 215 + _increment.x/2
				lbxBatchFucntions.width = lbxFunctionsToBatch.width = 200 + _increment.x/2
				
				edtLogFile.width = 241 + _increment.x
				btnLogFileGet.pos.x = 300 + _increment.x
				chkLogOpen.pos.x = 320 + _increment.x
				
				lbxBatchFiles.width = 430 + _increment.x
				
				edtLogMessage.width = size.x - 20	
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
			_xmlDoc = lb.xml.new parent.cfgFile
			_xmlDoc.save()

			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)

			--almacena los archivos de batch del listado
			_xmlDoc = lb.xml.load parent.cfgFile
			_rollMainNode = _xmlDoc.getNode "rollMain"
			_batchFilesNode = _rollMainNode.newChild "batchFiles"

			for _path in lbxBatchFiles.items do
			(
				_newFile = _batchFilesNode.newChild "file"
				_newFile.setproperty "path" _path
			)
			_xmlDoc.save()
			
			--almacena las opciones de folder y file
			lb.xml.setAttribute parent.cfgFile ("rollMain/folderOptions") "logFile" edtLogFile.text
			lb.xml.setAttribute parent.cfgFile ("rollMain/folderOptions") "openLog" (chkLogOpen.checked as string)
				
			--almacena las opciones del proceso de batch
			lb.xml.setAttribute parent.cfgFile ("rollMain/processOptions") "updateFirst" (chkUpdateFirst.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/processOptions") "lockFirst" (chkLockFirst.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/processOptions") "commitAtEnd" (chkCommitAtEnd.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/processOptions") "simulationOnly" (chkSimulation.checked as string)
				
			--lb.xml.setAttribute parent.cfgFile ("rollMain/processOptions") "saveAsCopy" (chkSaveAsCopy.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/processOptions") "saveAsCopyOption" (rdoSaveAsCopyOption.state as string)

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

			--restaura los items que habia la ultima vez en el listado de batch files
			_xmlDoc = lb.xml.load parent.cfgFile
			_tempItems = _xmlDoc.getNodes "rollMain/batchFiles/file"
			_tempItems = for n in _tempItems collect substituteString (n.getProperty "path") "\\\\" "\\"

			lbxBatchFiles.items = _tempItems

			--restaura las opciones de folder y file						
			edtLogFile.text = (lb.xml.getAttribute parent.cfgFile ("rollMain/folderOptions") "logFile")
			chkLogOpen.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/folderOptions") "openLog") == "true"
			
			--restaura las opciones del proceso de batch
			chkUpdateFirst.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/processOptions") "updateFirst") == "true"	
			chkLockFirst.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/processOptions") "lockFirst") == "true"
			chkCommitAtEnd.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/processOptions") "commitAtEnd") == "true"	
			chkSimulation.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/processOptions") "simulationOnly") == "true"
			
			--chkSaveAsCopy.checked = (getINISetting (toolsCfgPath + "\\rollBatchManager.ini") "processOptions" "saveAsCopy") == "true"	
			rdoSaveAsCopyOption.state = (lb.xml.getAttribute parent.cfgFile ("rollMain/processOptions") "saveAsCopyOption") as integer

			if rdoSaveAsCopyOption.state == 0 then rdoSaveAsCopyOption.state = 1

		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | ejecuta el batch
		------------------------------------------------
		on btnBatch pressed do
		(
			_process = true --inicialmente el flag está a true
			_success = false --flag para saber si se ha realizado correctamente el batch
			
			if lbxBatchFiles.items.count == 0 then --si hay archivos a los que pasar el batch
			(
				_process = false --pone el flag a false
				lb.message.show "Batch cannot be done, there are no files to Batch in list." type:#message pos:undefined size:[300,75] modal:true
			)
			else if edtLogFile.text == "" then --si no hay log no se puede procesar
			(
				_process = false --pone el flag a false
				lb.message.show "Batch cannot be done, there is no file to log." type:#message pos:undefined size:[300,75] modal:true
			)--if else
			
			if _process then --mira a ver el estado de los archivos versionados a hacer el batch y en caso de fallar algo saca un mensaje
			(
				_filesToBatch = lbxBatchFiles.items --archivos a hacer batch
				_svnStatus = #() --estado svn de los folder de los archivos
				
				for f in _filesToBatch do --obtiene el estado de cada folder
					_svnStatus += lb.svn.svnGetFolderStatus (getFileNamePath f) donotwait:true sleepTime:0.5
				
				--flags para averiguar si hace falta un update, un unlock y en que archivos
				_filesToUpdate = #()
				_filesToLock = #()
				
				--mira a ver si estan actualizados y con lock hecho
				for f in _filesToBatch where (svnIsFileVersioned f donotwait:false sleepTime:0.5 statusInfo:_svnStatus) do
				(
					if not lb.svn.svnIsFileUpdated f donotwait:true sleepTime:0.5 statusInfo:_svnStatus then
						append _filesToUpdate f
					else if not (lb.svn.svnGetFileStatus f donotwait:true sleepTime:0.5 statusInfo:_svnStatus) == "K" then
						append _filesToLock f
				)--for
				
				--si hay archivos que actualizar o bloquear lo dice
				if _filesToUpdate.count != 0 or _filesToLock.count != 0 then
				(
					_messageText = ""
					
					if _filesToUpdate.count != 0 then
					(
						_messageText += "\nFiles you need update before batch:\n"
						for i=1 to _filesToUpdate.count where (i < 11) do _messageText += _filesToUpdate[i] + "\n"
						if _filesToUpdate.count > 10 then _messageText += "...\n" else _messageText += "\n"
					)						
					
					if _filesToLock.count != 0 then
					(
						_messageText += "\nFiles you need lock before batch:\n"
						for i=1 to _filesToLock.count where (i < 11) do _messageText += _filesToLock[i] + "\n"
						if _filesToLock.count > 10 then _messageText += "...\n" else _messageText += "\n"
					)						
					
					if not chkSimulation.checked then
					(
						lb.message.show ("Some files are in wrong state. Yo must update and lock the files first.\n" + _messageText) type:#message pos:undefined size:[850,75] modal:true
						_process = false
					)
					else
						_process = querybox ("Some files are in wrong state. Yo must update and lock the files first.\n" + _messageText + "\nDo you want to continue anyway?")
				)--if
			)
				
			if _process then --si se puede processar
			(
				batchFunctions = #() --array de funciones para procesar
				
				for bf in lbxFunctionsToBatch.items do
					for f in batchFunctionsArray where (findString (f as string) bf != undefined) do
						append batchFunctions f
				
				if batchFunctions.count != 0 then
				(
					_process = true --indica si hacer el proceso o no
					if not chkSimulation.checked then --si va a hacer el proceso
						_process = queryBox "Batch process is going to start. Do you want to continue?"
					else --si va a hacer una simulacion.
						_process = queryBox "Batch process is going run a simulation. Do you want to continue?"
					
					if _process then
					(
						if parent.rollBatchFilesManager.open then --trata de cerrar el rollBatchFilesManager
							destroyDialog parent.rollBatchFilesManager
						
						--obtiene los ficheros en los que hacer batch
						--filesToBatch = lb.batch.isPoseFrozen
lb.batch.getFilesFromFolder edtFolder.text folderFilter:edtFolderFilter.text fileFilter:edtFileFilter.text ignoreList:#("_batch") ext:ddlExtension.selected recursive:chkRecursive.checked
						filesToBatch = lbxBatchFiles.items
						
						--hace el batch en los ficheros
						lb.progressBar.progressBarOpen width:600 showSecondaryBar:true --useCaptions:true captionsWidth:100
						--progressStart "Batch process"
						
						_saveAsOption = #notSave --si la opcion de salvar como esta desactivada es porque no hay que salvarlo
						
						if rdoSaveAsCopyOption.enabled then --si está activa hay que ver que opcion de salvar se ha de utilizar
							case rdoSaveAsCopyOption.state of
							(
								1: _saveAsOption = #sameFile
								2: _saveAsOption = #versionIncrement
								3: _saveAsOption = #copy
							)--case
												
						_success = lb.batch.batchFiles filesToBatch batchFunctions &errFiles updateFirst:chkUpdateFirst.checked lock:(chkLockFirst.enabled and chkLockFirst.checked) saveAsOption:_saveAsOption commit:(chkCommitAtEnd.enabled and chkCommitAtEnd.checked) simulationOnly:chkSimulation.checked logFile:edtLogFile.text logMessage:edtLogMessage.text
						
						lb.progressBar.progressBarClose()
						
						if chkLogOpen.checked then --si hay que abrir el log lo lanza
							ShellLaunch edtLogFile.text ""
						
						if _success then
						(
							if not chkSimulation.checked then
								lb.message.show "Batch complete without errors.\n Remember to (commit and unlock files) or (add files) to repository." type:#message pos:undefined size:[300,75] modal:true
							else
							lb.message.show "Batch complete without errors." type:#message pos:undefined size:[300,75] modal:true
						)
						else
						(
							if not chkSimulation.checked then
								lb.message.show "Batch complete. Some files couldn't complete the batch, view log for more information.\n Remember to (commit and unlock files) or (add files) to repository." type:#message pos:undefined size:[300,75] modal:true

							else
								lb.message.show "Batch complete. Some files couldn't complete the batch, view log for more information." type:#message pos:undefined size:[300,75] modal:true
						)
							
					)--if query
				)
				else
					lb.message.show "Batch cannot be done, there are no functions to batch." type:#message pos:undefined size:[300,75] modal:true
			)
		)--on

		------------------------------------------------
		--@event: changed | abre la herramienta que busca los archivos a los que hacer batch
		------------------------------------------------			
		on ckbAddFiles changed state do
		(
			if state and not parent.rollBatchFilesManager.open then
			(	
				createDialog parent.rollBatchFilesManager lockwidth:false lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
			)

			else if parent.rollBatchFilesManager.open then
			(
				destroyDialog parent.rollBatchFilesManager
			)
		)

		------------------------------------------------
		--@event: pressed | elimina el item seleccionado del listado de archivos a los que hacer batch
		------------------------------------------------		
		on btnRemoveFiles pressed do
		(
			_items = lbxBatchFiles.items --obtiene el listado
			_selIndex = lbxBatchFiles.selection
			
			if _selIndex != 0 then --elimina el item seleccionado
				deleteItem _items _selIndex
			
			lbxBatchFiles.items = _items --sbreescribe el lsitado
			
			if _items.count >= _selIndex then lbxBatchFiles.selection = _selIndex
			else if _items.count == (_selIndex - 1) then lbxBatchFiles.selection = (_selIndex	- 1)
			else if _items.count != 0 then lbxBatchFiles.selection = 1
		)

		------------------------------------------------
		--@event: pressed | elimina todos los items del listado de archivos a los que hacer batch
		------------------------------------------------		
		on btnRemoveAllFiles pressed do
			lbxBatchFiles.items = #()

		------------------------------------------------
		--@event: pressed | busca el folder a partir del cual empezar a buscar los archivos
		------------------------------------------------
		/* 		on btnFolderGet pressed do
		(
			--obtiene el folder donde empezar a buscar los archivos para el batch
			savePath = getSavePath caption:"Folder to Batch" initialDir:edtFolder.text
			
			if savePath != undefined then edtFolder.text = savePath
		) */

		------------------------------------------------
		--@event: pressed | busca archivo de log
		------------------------------------------------	
		on btnLogFileGet pressed do
		(
			--obtiene el nombre del log que se va a guardar
			saveFile = getSaveFileName caption:"Log file save name" filename:edtLogFile.text
			if saveFile != undefined then edtLogFile.text = saveFile
			else edtLogFile.text = ((getDir #temp) + "\\batch.log")
		)

		------------------------------------------------
		--@event: pressed | pasa un elemento del listado de la izquierda al de la derecha
		------------------------------------------------			
		on btnAdd pressed do
		(
			if lbxBatchFucntions.items.count != 0 then
			(
				--añade el elemento al listado de la derecha
				items = lbxFunctionsToBatch.items + #(lbxBatchFucntions.selected)
				sort items
				lbxFunctionsToBatch.items = items
				
				--elimina el elemento del listado de la izquierda
				items = lbxBatchFucntions.items
				deleteItem items lbxBatchFucntions.selection
				lbxBatchFucntions.items = items
				
				--deja seleccionado el primer elemento de los que queden en el listado
				if lbxBatchFucntions.items.count != 0 then
					lbxBatchFucntions.selection = 1
			)--if lbxBatchFucntions
		)

		------------------------------------------------
		--@event: pressed | pasa un elemento del listado de la derecha al de la izquierda
		------------------------------------------------		
		on btnRemove pressed do
		(
			if lbxFunctionsToBatch.items.count != 0 then
			(
				--añade el elemento al listado de la izquierda
				items = lbxBatchFucntions.items + #(lbxFunctionsToBatch.selected)
				sort items
				lbxBatchFucntions.items = items
				
				--elimina el elemento del listado de la derecha
				items = lbxFunctionsToBatch.items
				deleteItem items lbxFunctionsToBatch.selection
				lbxFunctionsToBatch.items = items
				
				--deja seleccionado el primer elemento de los que queden en el listado
				if lbxFunctionsToBatch.items.count != 0 then
					lbxFunctionsToBatch.selection = 1
			)--if lbxFunctionsToBatch
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
			updateToolbarButtons()
	
			--pone el archivo de log por defecto
			edtLogFile.text = ((getDir #temp) + "\\batch.log")
			
			fillAvailableFunctions() --rellena las funciones de batch en el listado
			--DESACTIVADAS LAS OPCIONES DE SVN PARA QUE NO SE CUELGUE
			--updateUI() --actualiza el ui
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

			if parent.rollBatchFilesManager.open do destroyDialog parent.rollBatchFilesManager
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: batchManager | Contiene la herramienta batchManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_batchManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Batch Manager",		--@var: description | Descripcion de la tool.
		
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
		rollBatchFilesManager = rollBatchFilesManagerDef,
			
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
		
	)--tl_batchManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_batchManager() --crea la herramienta
)