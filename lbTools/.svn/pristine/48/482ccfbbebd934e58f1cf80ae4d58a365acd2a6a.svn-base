------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta queueManagerSender.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollQueueSenderFilesManagerDef | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollQueueSenderFilesManagerDef "Queue Sender Files Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 700		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 520		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local allFiles = #() --array con todos los archivos .max de una arbol de directorio		

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpFilters "Filters" pos:[5,5] width:690 height:45
		
		label lblFolderFilters "Folder / Files:" pos:[14,23] width:65 height:15
		edittext edtFolderFilters "" pos:[80,23] width:609 height:15
				
		groupBox grpFiles "Files" pos:[5,55] width:690 height:460
		
		label lblRootFolder "Root folder:" pos:[14,75] width:60 height:15
		editText edtRootFolder "" pos:[80,73] width:595 height:15
		button btnRootFolderGet "..." pos:[675,74] width:15 height:15
		
		button btnAddFile "Add selected" pos:[10,490] width:70 height:20
		button btnAddAllFiles "Add all" pos:[80,490] width:40 height:20
		dotNetControl lvFileList "System.Windows.Forms.ListView" pos:[10,90] width:680 height:400
		
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
		--@fn: undefined | initListView | Inicia el listView pasado por parámetro
		------------------------------------------------
		fn initListView lv =
		(
			lv.clear()
				
			lv.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5
			lv.gridLines = false
			lv.view = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = (dotnetclass "system.drawing.color").fromArgb 40 40 40
			lv.foreColor = (dotnetclass "system.drawing.color").fromArgb 200 200 200
			lv.scrollable = true
			lv.labelEdit = true
			lv.hideSelection = false
			lv.labelEdit = false
			
			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").None

			lv.columns.add "Files" (lv.width - 20)		
		)--fn initListView

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
		--@fn: undefined | resetUI | inicia el UI de la herramienta
		------------------------------------------------
		fn resetUI =
		(
			--if edtRootFolder.text == "" then edtRootFolder.text = "Z:\\" --si no hay unidad definida pone C
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
			if size.x < minRollWidth then (size.x = minRollWidth; rollQueueSenderFilesManagerDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollQueueSenderFilesManagerDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				grpFilters.width = grpFiles.width = size.x - 10
				edtFolderFilters.width = 609 + _increment.x-- = edtFileFilters.width
				edtRootFolder.width = 591 + _increment.x
				btnRootFolderGet.pos.x = 675 + _increment.x
				lvFileList.width = 680 + _increment.x
				lvFileList.columns.item[0].width = 660 + _increment.x
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				grpFiles.height = 460 + _increment.y
				btnAddFile.pos.y = btnAddAllFiles.pos.y = 490 + _increment.y
				lvFileList.height = 400 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/pos") "x" (((getDialogPos rollQueueSenderFilesManagerDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/pos") "y" (((getDialogPos rollQueueSenderFilesManagerDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/size") "width" (rollQueueSenderFilesManagerDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/size") "height" (rollQueueSenderFilesManagerDef.height as string)

			lb.xml.setAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/rootFolder") "path" (edtRootFolder.text)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--opciones del interfaz
			edtRootFolder.text = lb.xml.getAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/rootFolder") "path"

			--tamaño
			_width = (lb.xml.getAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("tool/rollQueueSenderFilesManager/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollQueueSenderFilesManagerDef.width = _width
			rollQueueSenderFilesManagerDef.height = _height
			setDialogPos rollQueueSenderFilesManagerDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | añade los elementos seleccionados del listado al listado de archivos a los que hacer job en rollqueueManagerSender.
		------------------------------------------------
		on btnAddFile pressed do
		(
			_itemsToAdd = parent.rollMain.lbxJobFiles.items --obtiene los items actuales
			
			for i=1 to lvFileList.selectedItems.count do
				appendIfUnique _itemsToAdd (lvFileList.selectedItems.item[i-1].text)
			
			sort _itemsToAdd --ordena el array alfabeticamente
			parent.rollMain.lbxJobFiles.items = _itemsToAdd --sobreescribe los items
		)--btnAddFile

		------------------------------------------------
		--@event: pressed | añade toda la lista al listado de archivos a los que hacer job en rollqueueManagerSender
		------------------------------------------------		
		on btnAddAllFiles pressed do
		(
			_itemsToAdd = rollMain.lbxJobFiles.items --obtiene los items actuales
			
			for i=1 to lvFileList.items.count do
				appendIfUnique _itemsToAdd (lvFileList.items.item[i-1].text)
			
			sort _itemsToAdd --ordena el array alfabeticamente
			rollMain.lbxJobFiles.items = _itemsToAdd --sobreescribe los items
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
		on rollQueueSenderFilesManagerDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollQueueSenderFilesManagerDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			resetUI()

			if parent.rolljobFilesManager != undefined then resize [parent.rolljobFilesManager.width, parent.rolljobFilesManager.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollQueueSenderFilesManagerDef close do
		(
			removeSceneEvents() --elimina los callbacks
			parent.rollMain.ckbAddFiles.checked = false --desactiva el boton que abre este rollout en la ventana principal
			saveSettings()
		)
	)--rollQueueSenderFilesManagerDef	

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta queueManagerSender.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Queue Manager Sender"
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
		
		button btnJobRepository "Job Repository: " pos:[5,5] width:85 height:15
		label lblJobRepository "" pos:[95,5] width:1500

		groupBox grpJobFiles "Job Files" pos:[5,23] width:440 height:130
		
		listbox lbxJobFiles "" pos:[10,38] width:430 height:7
		checkbutton ckbAddFiles "+" pos:[10,134] width:16 height:15
		button btnRemoveFiles "-" pos:[26,134] width:16 height:15
		button btnRemoveAllFiles "x" pos:[42,134] width:16 height:15
		
		groupBox grpJobActions "Job Actions" pos:[5,155] width:440 height:293
		
		listbox lbxAvailableActions " Available Actions" pos:[10,170] width:200 height:19
		listbox lbxSelectedActions "Selected Actions" pos:[240,170] width:200 height:19
		button btnAdd ">" pos:[215,250] width:20 height:60
		button btnRemove "<" pos:[215,315] width:20 height:60
		button btnRemoveAll "<<" pos:[215,395] width:20 height:40
		button btnUp "UP" pos:[360,170] width:40 height:15
		button btnDown "DOWN" pos:[400,170] width:40 height:15
		
		groupBox grpJobOptions "Job Options" pos:[5,450] width:440 height:43
		
		checkbox chkSvnUpdate "SVN Update" pos:[12,470] checked:false
		checkbox chkSave "Save Changes" pos:[115,470] checked:false
		checkbox chkSvnCommit "SVN Commit" pos:[225,470] checked:false enabled:false
		checkbox chkJobPerAction "One job per action" pos:[330,470] checked:false

		button btnSend "SEND" pos:[5,496] width:440 height:20
		
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
		--@fn: undefined | fillAvailableActions | rellena el listado de funciones de job disponibles
		------------------------------------------------
		fn fillAvailableActions =
		(
			_actionsNames = for _sc in lb.getScripts() collect _sc.className

			--elimina antes los que ya estenb cargados en el de seleccionados
			for i=_actionsNames.count to 1 by -1 where (findItem lbxSelectedActions.items _actionsNames[i]) != 0 do deleteItem _actionsNames i
			sort _actionsNames

			lbxAvailableActions.items = _actionsNames
		)--fillAvailableActions

		------------------------------------------------
		--@fn: undefined | updateUI | actualiza el UI
		------------------------------------------------		
		fn updateUI =
		(
			lblJobRepository.text = if doesFileExist parent.jobRepository then parent.jobRepository else ""

			chkSvnCommit.enabled = chkSave.checked
			if not chkSave.checked then chkSvnCommit.checked = false
		)

		------------------------------------------------
		--envia los trabajos a la cola
		------------------------------------------------
		fn sendJobs =
		(
			_success = false

			_msgPos = (getDialogPos parent.rollMain) + [parent.rollMain.width, parent.rollMain.height]/2 - [300,75]/2

			if doesFileExist parent.jobRepository then
			(
				if lbxJobFiles.items.count != 0 and lbxSelectedActions.items.count != 0 then
				(
					_success = true
					setWaitCursor()

					--crea un trabajo por cada archivo
					for _file in lbxJobFiles.items where _success do
					(
						_fileParts = FilterString _file "\\"
						_jobName = substituteString _fileParts[_fileParts.count] ".max" ""

						--si hay que crear un trabajo con todas las acciones
						if not chkJobPerAction.checked then
						(
							_success = lb.queueManager.newJob _jobName parent.jobRepository _file (lbxSelectedActions.items) status:"waiting" save:chkSave.checked svnUpdate:chkSvnUpdate.checked svnCommit:chkSvnCommit.checked
						)
						else --si hay que crear un trabajo por cada accion
						(
							for _action in lbxSelectedActions.items where _success do
							(
								_success = lb.queueManager.newJob _jobName parent.jobRepository _file #(_action) status:"waiting" save:chkSave.checked svnUpdate:chkSvnUpdate.checked svnCommit:chkSvnCommit.checked
							)--for
						)--if else
					)--for

					setArrowCursor()

					if _success then lb.message.show "All jobs successfully sent." pos:_msgPos
					else lb.message.show "One or more jobs where sent with errors." pos:_msgPos
				)
				else
				(				
					lb.message.show "You must have one file and one action selected at least to send a job." pos:_msgPos
				)--if else
			)
			else
			(				
				lb.message.show "You must indicate a valid job repository first." pos:_msgPos
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
				grpJobOptions.width = grpJobActions.width = grpJobFiles.width = size.x - 10
					
				lbxJobFiles.width = 430 + _increment.x
				
				lbxSelectedActions.pos.x = 240 + _increment.x/2
				btnAdd.pos.x = btnRemove.pos.x = btnRemoveAll.pos.x = 215 + _increment.x/2
				lbxAvailableActions.width = lbxSelectedActions.width = 200 + _increment.x/2
				btnUp.pos.x = 360 + _increment.x
				btnDown.pos.x = 400 + _increment.x
		
				chkJobPerAction.pos.x = 330 + _increment.x

				btnSend.pos.x = 10 + (_increment.x/2)
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
			--almacena el repositorio
			lb.xml.setAttribute parent.cfgFile ("tool/jobRepository") "path" (parent.jobRepository)

			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/size") "height" (rollMainDef.height as string)

			------------------------------------------------
			--almacena los archivos de job del listado

			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/jobFiles") "count" (lbxJobFiles.items.count as string)
			_xmlDoc = lb.xml.load parent.cfgFile
			_jobFilesNode = _xmlDoc.getNode "tool/rollMain/jobFiles"
			_jobFilesNode.removeChildren()

			for _path in lbxJobFiles.items do
			(
				_newFile = _jobFilesNode.newChild "file"
				_newFile.setproperty "path" _path
			)--for

			_xmlDoc.save()
			------------------------------------------------

			------------------------------------------------
			--almacena las acciones

			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/jobActions") "count" (lbxSelectedActions.items.count as string)
			_xmlDoc = lb.xml.load parent.cfgFile
			_jobActionsNode = _xmlDoc.getNode "tool/rollMain/jobActions"
			_jobActionsNode.removeChildren()

			for _act in lbxSelectedActions.items do
			(
				_newFile = _jobActionsNode.newChild "action"
				_newFile.setproperty "name" _act
			)--for

			_xmlDoc.save()
			------------------------------------------------
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--lee el path del repositorio
			_repo = lb.xml.getAttribute parent.cfgFile ("tool/jobRepository") "path"
			if doesFileExist _repo then parent.jobRepository = _repo

			_width = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]

			--restaura los items que habia la ultima vez en el listado de job files
			_xmlDoc = lb.xml.load parent.cfgFile
			if _xmlDoc != undefined then
			(
				_tempItems = _xmlDoc.getNodes "tool/rollMain/jobFiles/file"
				_tempItems = for n in _tempItems collect substituteString (n.getProperty "path") "\\\\" "\\"
				lbxJobFiles.items = _tempItems
			)--if

			--restaura los items que habia la ultima vez en el listado de acciones
			_xmlDoc = lb.xml.load parent.cfgFile
			if _xmlDoc != undefined then
			(
				_tempItems = _xmlDoc.getNodes "tool/rollMain/jobActions/action"
				_tempItems = for n in _tempItems collect (n.getProperty "name")

				_actionsNames = for _sc in lb.getScripts() collect _sc.className
				for i=_tempItems.count to 1 by -1 where (findItem _actionsNames _tempItems[i]) == 0 do deleteItem _tempItems i

				lbxSelectedActions.items = _tempItems
			)--if
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--Establece el repositorio de trabajos.
		------------------------------------------------
		on btnJobRepository pressed do
		(
			_newPath = getSavePath caption:"Job Repository" initialDir:(parent.jobRepository)
			if _newPath != undefined and doesFileExist _newPath then parent.jobRepository = _newPath
			updateUI()
		)

		------------------------------------------------
		--@event: pressed | Envia los trabajos.
		------------------------------------------------
		on btnSend pressed do
		(
			sendJobs()
		)--on

		------------------------------------------------
		--@event: changed | abre la herramienta que busca los archivos a los que hacer job
		------------------------------------------------			
		on ckbAddFiles changed state do
		(
			if state and not parent.rolljobFilesManager.open then
			(	
				createDialog parent.rolljobFilesManager lockwidth:false lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
			)

			else if parent.rolljobFilesManager.open then
			(
				destroyDialog parent.rolljobFilesManager
			)
		)

		------------------------------------------------
		--@event: pressed | elimina el item seleccionado del listado de archivos a los que hacer job
		------------------------------------------------		
		on btnRemoveFiles pressed do
		(
			_items = lbxJobFiles.items --obtiene el listado
			_selIndex = lbxJobFiles.selection
			
			if _selIndex != 0 then --elimina el item seleccionado
				deleteItem _items _selIndex
			
			lbxJobFiles.items = _items --sbreescribe el lsitado
			
			if _items.count >= _selIndex then lbxJobFiles.selection = _selIndex
			else if _items.count == (_selIndex - 1) then lbxJobFiles.selection = (_selIndex	- 1)
			else if _items.count != 0 then lbxJobFiles.selection = 1
		)

		------------------------------------------------
		--@event: pressed | elimina todos los items del listado de archivos a los que hacer job
		------------------------------------------------		
		on btnRemoveAllFiles pressed do
		(
			lbxJobFiles.items = #()
		)

		------------------------------------------------
		--@event: pressed | pasa un elemento del listado de la izquierda al de la derecha
		------------------------------------------------			
		on btnAdd pressed do
		(
			if lbxAvailableActions.items.count != 0 then
			(
				_selBackup = lbxAvailableActions.selection

				--añade el elemento al listado de la derecha
				items = lbxSelectedActions.items + #(lbxAvailableActions.selected)
				lbxSelectedActions.items = items
				
				--elimina el elemento del listado de la izquierda
				items = lbxAvailableActions.items
				deleteItem items lbxAvailableActions.selection
				lbxAvailableActions.items = items
				
				------------------------------------------------
				--matiene la seleccion
				if lbxAvailableActions.items.count >= _selBackup then lbxAvailableActions.selection = _selBackup
				else if lbxAvailableActions.items.count != 0 then lbxAvailableActions.selection = _selBackup - 1
				else lbxAvailableActions.selection = 1

				lbxSelectedActions.selection = lbxSelectedActions.items.count
				------------------------------------------------
			)--if
		)

		------------------------------------------------
		--@event: pressed | pasa un elemento del listado de la derecha al de la izquierda
		------------------------------------------------		
		on btnRemove pressed do
		(
			if lbxSelectedActions.items.count != 0 then
			(
				_selBackup = lbxSelectedActions.selection

				--añade el elemento al listado de la izquierda
				_itemToPass = lbxSelectedActions.selected
				items = lbxAvailableActions.items + #(lbxSelectedActions.selected)
				sort items
				lbxAvailableActions.items = items
				
				--elimina el elemento del listado de la derecha
				items = lbxSelectedActions.items
				deleteItem items lbxSelectedActions.selection
				lbxSelectedActions.items = items
				
				------------------------------------------------
				--matiene la seleccion
				if lbxSelectedActions.items.count >= _selBackup then lbxSelectedActions.selection = _selBackup
				else if lbxSelectedActions.items.count != 0 then lbxSelectedActions.selection = _selBackup - 1
				else lbxSelectedActions.selection = 1

				_index = findItem lbxAvailableActions.items _itemToPass
				if _index != 0 then lbxAvailableActions.selection = _index else lbxAvailableActions.selection = 1
				------------------------------------------------
			)--if
		)

		------------------------------------------------
		--@event: pressed | pasa todos los elementos del listado de la derecha al de la izquierda
		------------------------------------------------		
		on btnRemoveAll pressed do
		(
			if lbxSelectedActions.items.count != 0 then
			(
				--añade el elemento al listado de la izquierda
				items = lbxAvailableActions.items + lbxSelectedActions.items
				sort items
				lbxAvailableActions.items = items
				
				--limpia listado de la derecha
				lbxSelectedActions.items = #()
				
				------------------------------------------------
				--matiene la seleccion

				lbxAvailableActions.selection = 1
				------------------------------------------------
			)--if
		)

		------------------------------------------------
		--@event: pressed | sube elementos en el listado
		------------------------------------------------			
		on btnUp pressed do
		(
			if lbxSelectedActions.items.count != 0 and lbxSelectedActions.selection != 1 then
			(
				_defItems = #()
				_defItems = for i=1 to (lbxSelectedActions.selection - 2) collect lbxSelectedActions.items[i]
				append _defItems lbxSelectedActions.items[lbxSelectedActions.selection]
				append _defItems lbxSelectedActions.items[lbxSelectedActions.selection - 1]
				for i=(lbxSelectedActions.selection + 1) to lbxSelectedActions.items.count do append _defItems lbxSelectedActions.items[i]

				lbxSelectedActions.items = _defItems
				lbxSelectedActions.selection = lbxSelectedActions.selection - 1
			)--if
		)

		------------------------------------------------
		--@event: pressed | baja elementos en el listado
		------------------------------------------------			
		on btnDown pressed do
		(
			if lbxSelectedActions.items.count != 0 and lbxSelectedActions.selection != lbxSelectedActions.items.count then
			(
				_defItems = #()
				_defItems = for i=1 to (lbxSelectedActions.selection - 1) collect lbxSelectedActions.items[i]
				append _defItems lbxSelectedActions.items[lbxSelectedActions.selection + 1]
				append _defItems lbxSelectedActions.items[lbxSelectedActions.selection]
				for i=(lbxSelectedActions.selection + 2) to lbxSelectedActions.items.count do append _defItems lbxSelectedActions.items[i]

				lbxSelectedActions.items = _defItems
				lbxSelectedActions.selection = lbxSelectedActions.selection + 1
			)--if
		)

		------------------------------------------------
		--indica si el trabajo tiene que salvar el archivo o no.
		------------------------------------------------
		on chkSave changed state do
		(
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
			fillAvailableActions() --rellena las funciones de job en el listado
			updateUI()
			
			createSceneEvents() --crea los callbacks
			updateToolbarButtons()
	
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

			if parent.rolljobFilesManager.open do destroyDialog parent.rolljobFilesManager
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: queueManagerSender | Contiene la herramienta queueManagerSender.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_queueManagerSender
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "job Manager",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		jobRepository = "", --repositorio de trabajos

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollMain | Almacena el rollout principal de la herramienta.
		rolljobFilesManager = rollQueueSenderFilesManagerDef,
			
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
		
	)--tl_queueManagerSender
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_queueManagerSender() --crea la herramienta
)