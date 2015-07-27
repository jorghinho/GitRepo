------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta maxFileListManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta maxFileListManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "File Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 550		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 705		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local lastUpdatedState = 3 --estado inicial del rdoUpdatedOption	

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpSequenceOptions "" pos:[5,0] width:540 height:135
		edittext edtFilesRoot "Search Root:" pos:[10,10] width:515 height:15
		button btnSequenceRootBrowse "..." pos:[525,11] width:15 height:15		
		edittext edtFilters "Filters:          " pos:[10,26] width:515 height:15
		
		groupBox grpFileTypes "File types:" pos:[10,45] width:315 height:85	
		checkbox chkFileTypeMesh "mesh" pos:[15,65] width:70 height:15
		checkbox chkFileTypeFacial "facial" pos:[15,80] width:70 height:15
		checkbox chkFileTypeAnim "anim" pos:[15,95] width:75 height:15
		checkbox chkFileTypeLayout "layout" pos:[15,110] width:75 height:15
		checkbox chkFileTypeCloth "cloth" pos:[95,65] width:75 height:15
		checkbox chkFileTypeCache "cache" pos:[95,80] width:75 height:15
		checkbox chkFileTypeCacheCloth "cacheCloth" pos:[95,95] width:75 height:15
		checkbox chkFileTypeCacheFx "cacheFx" pos:[95,110] width:75 height:15
		checkbox chkFileTypeRender "render" pos:[175,65] width:75 height:15
		checkbox chkFileTypeFx "fx" pos:[175,80] width:75 height:15
		button btnFileTypesAll "All" pos:[275,55] width:45 height:20
		button btnFileTypesNone "None" pos:[275,80] width:45 height:20
		button btnFileTypesInvert "Invert" pos:[275,105] width:45 height:20
		
		groupBox grpCheckedOption "Show:" pos:[335,45] width:100 height:85
		radiobuttons rdoCheckedOption "" pos:[340,60] width:83 height:48 labels:#("checked", "not checked", "both") default:3 columns:1
		
		groupBox grpUpdatedOption "Show:" pos:[440,45] width:100 height:85
		radiobuttons rdoUpdatedOption "" pos:[445,60] width:80 height:48 labels:#("updated", "not updated", "both") default:3 columns:1

		label lblFileList "File List:" pos:[5,140] width:300 height:15
		listbox lbxSequenceList "" pos:[5,155] width:540 height:40

		button btnOpenSelected "Open Selected" pos:[5,680] width:90 height:20
		checkbox chkOpenInNewWindow "open in new max window" pos:[100,680] width:120 height:15
		button btnUpdateSelected "Update Selected" pos:[455,680] width:90 height:20
		
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
		--@fn: undefined | filterFiles | filtra un array de archivos pasados por parametro. Devuelve el array filtrado.
		------------------------------------------------		
		fn filterFiles files filters filterMode:#or =
		(
			_filteredFiles = deepCopy files
			
			if classof filters != Array then filters = #() --si el parametro filters no es del tipo correcto lo sobreescribe con un array vacio.
			
			if _filteredFiles.count != 0 then --si hay archivos con los que trabajar
			(
				if filters.count != 0 then --si hay filtros
				(
					for i=_filteredFiles.count to 1 by -1 do --recorre los archivos en orden inverso
					(
						_delete = false --flag para saber si eliminar el archivo del listado
							
						case filterMode of
						(
							#or:
							(
								_filterFound = false --flag para saber si el archiv cumple alguno de los filtrols
								
								for fp in filters where not _filterFound and findString _filteredFiles[i] fp != undefined do
									_filterFound = true
								
								_delete = not _filterFound --si no cumple ningun filtro lo marca para eliminar
							)--or
							
							#and:
							(
								for fp in filters where findString _filteredFiles[i] fp == undefined do
									_delete = true
							)--and
						)--case
						
						if _delete then deleteItem _filteredFiles i --elimina el archivo del listado
					)--for _filteredFiles					
				)--if filters
			)--if _filteredFiles
			
			_filteredFiles
		)

		------------------------------------------------
		--@fn: undefined | fillFileList | rellena el listado de Files siguiendo los filtros
		------------------------------------------------		
		fn fillFileList files checkedOption:3 updatedOption:3 =
		(
			lbxSequenceList.items = #() --resetea el listado
			
			_filteredFiles = deepCopy files --hace una copia completa del array de ficheros
			
			if _filteredFiles.count != 0 then --si hay archivos con los que trabajar
			(
				for i=_filteredFiles.count to 1 by -1 do --recorre los archivos en orden inverso
				(
					_delete = false --flag para saber si eliminar el archivo del listado
					_filterFound = false --flag para saber si el archiv cumple alguno de los filtrols
					
					--si solo hay que mostrar los checkeados y el archivo no esta checkeado no lo lista
					if not _delete and checkedOption != 3 then
						if checkedOption == 2 and (getFileInfoIsChecked _filteredFiles[i]) then
							_delete = true
						else if checkedOption == 1 and not (getFileInfoIsChecked _filteredFiles[i]) then
							_delete = true
					
					if not _delete and updatedOption != 3 then
						if updatedOption == 2 and (lb.svn.svnIsFileUpdated _filteredFiles[i]) then
							_delete = true
						else if updatedOption == 1 and not (lb.svn.svnIsFileUpdated _filteredFiles[i]) then
							_delete = true
					
					if _delete then deleteItem _filteredFiles i --elimina el archivo del listado
				)
							
				lbxSequenceList.items = _filteredFiles --rellena el listado
				lblFileList.caption = "File List: " + (_filteredFiles.count as string) + " files."
			)--if _filteredFiles
		)--fillFileList

		------------------------------------------------
		--@fn: undefined | resetUI | inicia el UI de la herramienta
		------------------------------------------------		
		fn resetUI =
		(
			if edtFilesRoot.text == "" then edtFilesRoot.text = "Z:\\sequence\\seq_xxx" --si no hay unidad definida pone Z:\\sequence\\seq_xxx
			
			-------------------------------------------------------------------------------------------------
			--prepara los filtros segun el tipo de secuencia que se quiera consultar
			_fileTypes = #()
			
			if chkFileTypeMesh.checked then append _fileTypes "_mesh"
			if chkFileTypeFacial.checked then append _fileTypes "_facial"
			if chkFileTypeCloth.checked then append _fileTypes "_cloth"
			if chkFileTypeLayout.checked then (append _fileTypes "_layout";append _fileTypes "_layout-")
			if chkFileTypeAnim.checked then append _fileTypes "_anim"
			if chkFileTypeCache.checked then (append _fileTypes "_cache.";append _fileTypes "_cache-")
			if chkFileTypeCacheCloth.checked then append _fileTypes "_cacheCloth"
			if chkFileTypeCacheFx.checked then append _fileTypes "_cacheFx"
			if chkFileTypeFx.checked then append _fileTypes "_fx"
			if chkFileTypeRender.checked then append _fileTypes "_render"
			-------------------------------------------------------------------------------------------------
			
			-------------------------------------------------------------------------------------------------
			--rellena el array de ficheros
			
			_allFiles = #() --array con los archivos de esas rutas
			
			setWaitCursor() --cursor en espera
			if _fileTypes.count != 0 then --si no hay tipos de archivo que buscar no busca nada
			(
				_roots = filterString edtFilesRoot.text ";, " --rutas donde buscar los archivos
				for r in _roots do _allFiles += lb.fileIOFunctions.getAllFilesFromSubFolders r --rellena el array de archivos
				
				--filtra por tipos de archivo
				_allFiles = filterFiles _allFiles _fileTypes filterMode:#or
				
				--filtra por los filtros personalizados
				_filters = filterString edtFilters.text ";, " --filtros que deben cumplir los archivos
				if _filters.count != 0 then _allFiles = filterFiles _allFiles _filters filterMode:#and
			)--if _fileTypes
			-------------------------------------------------------------------------------------------------
			
			--rellena el listado de archivos
			fillFileList _allFiles checkedOption:rdoCheckedOption.state updatedOption:rdoUpdatedOption.state
			
			setArrowCursor() --cursonr en flecha
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

			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "root" (edtFilesRoot.text)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "filters" (edtFilters.text)

			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeAnim" (chkFileTypeAnim.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeCache" (chkFileTypeCache.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeCacheCloth" (chkFileTypeCacheCloth.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeCacheFx" (chkFileTypeCacheFx.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeCloth" (chkFileTypeCloth.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeFacial" (chkFileTypeFacial.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeFx" (chkFileTypeFx.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeLayout" (chkFileTypeLayout.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeMesh" (chkFileTypeMesh.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "fileTypeRender" (chkFileTypeRender.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "checkedOption" (rdoCheckedOption.state as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "updatedOption" (rdoUpdatedOption.state as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "openInNewWindow" (chkOpenInNewWindow.checked as string)
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
								
			edtFilesRoot.text = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "root")
			edtFilters.text = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "filters")
										
			chkFileTypeAnim.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeAnim") == "true"
			chkFileTypeCache.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeCache") == "true"	
			chkFileTypeCacheCloth.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeCacheCloth") == "true"	
			chkFileTypeCacheFx.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeCacheFx") == "true"
			chkFileTypeCloth.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeCloth") == "true"
			chkFileTypeFacial.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeFacial") == "true"
			chkFileTypeFx.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeFx") == "true"		
			chkFileTypeLayout.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeLayout") == "true"		
			chkFileTypeMesh.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeMesh") == "true"
			chkFileTypeRender.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "fileTypeRender") == "true"

			rdoCheckedOption.state = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "checkedOption") as integer
			rdoUpdatedOption.state = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "updatedOption") as integer
			chkOpenInNewWindow.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "openInNewWindow") == "true"
			
			if rdoCheckedOption.state == 0 then rdoCheckedOption.state = 3
			if rdoUpdatedOption.state == 0 then rdoUpdatedOption.state = 3
			
			resetUI()			
				
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
		--@event: changed | cambios en la opciones del interface que hacen que se redibuje la lista	
		------------------------------------------------	
		on chkFileTypeAnim changed state do
			resetUI()
		
		on chkFileTypeCache changed state do
			resetUI()
		
		on chkFileTypeCacheCloth changed state do
			resetUI()
		
		on chkFileTypeCacheFx changed state do
			resetUI()
		
		on chkFileTypeCloth changed state do
			resetUI()
		
		on chkFileTypeFacial changed state do
			resetUI()
		
		on chkFileTypeFx changed state do
			resetUI()
		
		on chkFileTypeLayout changed state do
			resetUI()
		
		on chkFileTypeMesh changed state do
			resetUI()
		
		on chkFileTypeRender changed state do
			resetUI()
			
			
		on btnFileTypesAll pressed do
		(
			chkFileTypeAnim.checked = true
			chkFileTypeCache.checked = true
			chkFileTypeCacheCloth.checked = true
			chkFileTypeCacheFx.checked = true
			chkFileTypeCloth.checked = true
			chkFileTypeFacial.checked = true
			chkFileTypeFx.checked = true
			chkFileTypeLayout.checked = true
			chkFileTypeMesh.checked = true
			chkFileTypeRender.checked = true
			resetUI()
		)
			
		on btnFileTypesNone pressed do
		(
			chkFileTypeAnim.checked = false
			chkFileTypeCache.checked = false
			chkFileTypeCacheCloth.checked = false
			chkFileTypeCacheFx.checked = false
			chkFileTypeCloth.checked = false
			chkFileTypeFacial.checked = false
			chkFileTypeFx.checked = false
			chkFileTypeLayout.checked = false
			chkFileTypeMesh.checked = false
			chkFileTypeRender.checked = false
			resetUI()
		)
			
		on btnFileTypesInvert pressed do
		(
			chkFileTypeAnim.checked = not chkFileTypeAnim.checked
			chkFileTypeCache.checked = not chkFileTypeCache.checked
			chkFileTypeCacheCloth.checked = not chkFileTypeCacheCloth.checked
			chkFileTypeCacheFx.checked = not chkFileTypeCacheFx.checked
			chkFileTypeCloth.checked = not chkFileTypeCloth.checked
			chkFileTypeFacial.checked = not chkFileTypeFacial.checked
			chkFileTypeFx.checked = not chkFileTypeFx.checked
			chkFileTypeLayout.checked = not chkFileTypeLayout.checked
			chkFileTypeMesh.checked = not chkFileTypeMesh.checked
			chkFileTypeRender.checked = not chkFileTypeRender.checked
			resetUI()
		)
			
		on edtFilesRoot entered text do
			resetUI()
			
		on edtFilters entered text do
			resetUI()
			
		on rdoCheckedOption changed state do
			resetUI()
			
		on rdoUpdatedOption changed state do
		(
			if state != 3 then
				if querybox "Using \"updated\" or \"not updated\" option could cause very large search time in big recursive directories like Z:\\sequence\nIs better to specify the sequence. Example: Z:\\sequence\\seq_046\nDo you want to continue?" then
					resetUI()
				else
					rdoUpdatedOption.state = lastUpdatedState
			else
				resetUI()
				
			lastUpdatedState = rdoUpdatedOption.state
		)

		------------------------------------------------
		--@event: pressed | abre la secuencia seleccionada en el mismo Max o en otro Max nuevo.
		------------------------------------------------			
		on btnOpenSelected pressed do
		(
			if chkOpenInNewWindow.checked then
			(
				shellLaunch ((getDir #maxRoot) + "3dsmax.exe") (lbxSequenceList.selected)
			)
			else
			(
				yesNoCancel = #no --el estado por defecto es que no pregunte
				
				if getSaveRequired() then --si algo ha cambiado, pergunta
					yesNoCancel = yesNoCancelBox "The scene has been modified.\nDo you want to save your changes?"
				
				case yesNoCancel of
				(
					#yes:
					(
						proceed = true
						
						if checkForSave() and maxFilePath + maxFileName != "" then
							proceed = saveMaxFile (maxFilePath + maxFileName)
						
						if proceed do
						(
							resetMaxFile #noprompt
							loadMaxFile (lbxSequenceList.selected) quiet:false
						)
					)
					
					#no:
					(
						resetMaxFile #noprompt
						loadMaxFile (lbxSequenceList.selected) quiet:false
					)
				)
			)
		)

		------------------------------------------------
		--@event: pressed | actualiza la secuencia seleccionada.
		------------------------------------------------			
		on btnUpdateSelected pressed do
		(
			setWaitCursor()
			lb.svn.svnUpdate (lbxSequenceList.selected)
			if rdoUpdatedOption.state != 3 then resetUI()
			setArrowCursor()
		)

		------------------------------------------------
		--@event: pressed | abre un browser para buscar secuencias.
		------------------------------------------------			
		on btnSequenceRootBrowse pressed do
		(
			_newPath = getSavePath caption:"Sequence root path" initialDir:(if (filterString edtFilesRoot.text ";, ")[1] != "" then (filterString edtFilesRoot.text ";, ")[1] else "")
			
			if _newPath != "" and _newPath != undefined then
			(
				edtFilesRoot.text = _newPath
				resetUI()
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
			resetUI()
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
	--@struct: maxFileListManager | Contiene la herramienta maxFileListManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_maxFileListManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Max File List Manager",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_maxFileListManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_maxFileListManager() --crea la herramienta
)