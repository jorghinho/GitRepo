------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta presetInfoManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta presetInfoManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Preset Info Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 800		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 515		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local okColor = (dotNetClass "System.Drawing.Color").fromargb 80 255 80
		local errorColor = (dotNetClass "System.Drawing.Color").fromargb 255 80 80
		local missingColor = (dotNetClass "System.Drawing.Color").fromargb 255 112 0
 
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		groupBox grpPresetFile "" pos:[5,0] width:790 height:35
		label lblPresetFile "Preset File:" pos:[15,13] width:500 height:15
		dotNetControl lvInfo "System.Windows.Forms.ListView" pos:[5,40] width:790 height:205

		groupBox grpVariationsFile "" pos:[5,260] width:790 height:35
		label lblVariationsFile "Variations:" pos:[15,273] width:70 height:15
		dotNetControl lvVariations "System.Windows.Forms.ListView" pos:[5,300] width:790 height:205
		
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

			lv.columns.add "File" 540
			lv.columns.add "Variations" 60
			lv.columns.add "LoadMode" 110
			lv.columns.add "Cheked" 80

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		fn initVariationsListView =
		(
			lv = lvVariations
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

			lv.columns.add "Node" 240
			lv.columns.add "Type" 70
			lv.columns.add "MatID" 50
			lv.columns.add "Morph Channel" 90
			lv.columns.add "Value" 40
			lv.columns.add "Transform" 300

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		

		fn extractFilesRecursively myfile level:0 = 
		(
			_extractedFiles = #()
			_presetInfo = lb.presets.readPresetData myfile
			for _presetFileData in _presetInfo.files do
			(
				_fileData = parent.fileMiniData()
				_fileData.file = _presetFileData.file
				_fileData.loadMode = _presetFileData.loadMode As String
				_fileData.level = level
				_fileData.numVariations = _presetFileData.nodeVariations.count 

				if doesFileExist _presetFileData.file then
				(
					if (getFilenameType _presetFileData.file) == ".prt" then
					(
						_fileData.checked = toUpper ((lb.presets.getPresetCheckedState _presetFileData.file) As String)
						append _extractedFiles _fileData
						_extractedFiles += (extractFilesRecursively _presetFileData.file level:(level+1))
					)
					else
					(
						if (lb.fileInfo.isFileChecked _presetFileData.file) then
						(
							_fileData.checked = "CHECKED"	
						)
						else
						(
							_fileData.checked = "UNCHECKED"
						)

						append _extractedFiles _fileData
					)
				)
				else
				(
					_fileData.checked = "MISSING"
				)
			)
			_extractedFiles
		)

		fn fillInfoListView  = 
		(
			presetInfo = lb.presets.readPresetData parent.presetFile

			_filesData = extractFilesRecursively parent.presetFile
			
			for i=1 to _filesData.count do
			(
				_spaces = ""
				for j=0 to _filesData[i].level do _spaces += "    "
				lvInfo.items.add (_spaces + _filesData[i].file)
				lvInfo.items.item[i-1].SubItems.add (_filesData[i].numVariations As String)
				lvInfo.items.item[i-1].SubItems.add (_filesData[i].loadMode)
				lvInfo.items.item[i-1].SubItems.add (_filesData[i].checked)
				lvInfo.items.item[i-1].UseItemStyleForSubItems = false
				if _filesData[i].checked == "CHECKED" then
				(
					lvInfo.items.item[i-1].SubItems.item[3].backColor = okColor
				)
				else if _filesData[i].checked == "UNCHECKED" then
				(
					lvInfo.items.item[i-1].SubItems.item[3].backColor = errorColor
				)
				else
				(
					lvInfo.items.item[i-1].SubItems.item[3].backColor = missingColor
				)

			)
			/*
			for i=1 to presetInfo.files.count do
			(
				_variations = (presetInfo.files[i].nodeVariations.count + presetInfo.files[i].nodeTransforms.count)

				lvInfo.items.add (presetInfo.files[i].file)
				lvInfo.items.item[i-1].SubItems.add (_variations as string)
				lvInfo.items.item[i-1].SubItems.add (presetInfo.files[i].loadMode as string)

				if doesFileExist presetInfo.files[i].file then
				(
					_testChecked = if lb.fileInfo.isFileChecked presetInfo.files[i].file then "CHECKED" else "UNCHECKED"
					lvInfo.items.item[i-1].SubItems.add _testChecked

					lvInfo.items.item[i-1].UseItemStyleForSubItems = false
					lvInfo.items.item[i-1].SubItems.item[3].backColor = if _testChecked == "CHECKED" then okColor else errorColor
				)
				else
				(
					lvInfo.items.item[i-1].SubItems.add "MISSING"
					lvInfo.items.item[i-1].UseItemStyleForSubItems = false
					lvInfo.items.item[i-1].SubItems.item[3].backColor = missingColor		
				)

			) 
			*/			
		)

		fn fillVariationsListView =
		(
			presetInfo = lb.presets.readPresetData parent.presetFile

			_selIndexes = lvInfo.SelectedIndices

			if _selIndexes.count != 0 then
			(
				_selIndex = _selIndexes.item[0]
				_selFile = presetInfo.files[_selIndex + 1]

				for i=1 to _selFile.nodeVariations.count do
				(
					--Columna node
					lvVariations.items.add (_selFile.nodeVariations[i].node As String)
					--Columna type
					lvVariations.items.item[i-1].SubItems.add (_selFile.nodeVariations[i].type as string)

					case (_selFile.nodeVariations[i].type as Name) of
					(
						#asset:
						(
							lvVariations.items.item[i-1].SubItems.add ""
							lvVariations.items.item[i-1].SubItems.add ""
							lvVariations.items.item[i-1].SubItems.add (_selFile.nodeVariations[i].value as string)
							lvVariations.items.item[i-1].SubItems.add ""
						)
						#Morph:
						(
							lvVariations.items.item[i-1].SubItems.add ""
							_morph = _selFile.nodeVariations[i].morphChannel
							lvVariations.items.item[i-1].SubItems.add (_selFile.nodeVariations[i].morphChannel as string)
							lvVariations.items.item[i-1].SubItems.add ""
							lvVariations.items.item[i-1].SubItems.add ""
						)
						#material:
						(
							_matName = (_selFile.nodeVariations[i].matName As String)
							_subMatName = (_selFile.nodeVariations[i].submatName As String)
							if _matName != "undefined" and _subMatName != "undefined" then
							(
								lvVariations.items.item[i-1].SubItems.add _matName
								lvVariations.items.item[i-1].SubItems.add ""
								lvVariations.items.item[i-1].SubItems.add _subMatName
								lvVariations.items.item[i-1].SubItems.add ""
							)
							else
							(
								lvVariations.items.item[i-1].SubItems.add (_selFile.nodeVariations[i].matID As String)
								lvVariations.items.item[i-1].SubItems.add ""
								lvVariations.items.item[i-1].SubItems.add (_selFile.nodeVariations[i].value As String)
								lvVariations.items.item[i-1].SubItems.add ""
							)
						)
					)
				)

				for i=1 to _selFile.nodeTransforms.count do
				(
					lvVariations.items.add (_selFile.nodeTransforms[i].node)
					lvVariations.items.item[i-1].SubItems.add ("Transform")
					lvVariations.items.item[i-1].SubItems.add ("")
					lvVariations.items.item[i-1].SubItems.add ("")
					lvVariations.items.item[i-1].SubItems.add ("")
					lvVariations.items.item[i-1].SubItems.add (_selFile.nodeTransforms[i].transform as string)
				)

			)
			else lvVariations.items.clear()	

			
		)

		fn resetUI = 
		(
			lblPresetFile.text = ("Preset File: " + parent.presetFile)
			fillInfoListView()
			fillVariationsListView()
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
				grpPresetFile.width = _increment.x + 790	
				grpVariationsFile.width = _increment.x + 790

				lvInfo.width = _increment.x + 790
				lvVariations.width = _increment.x + 790

				if lvInfo.columns.count != 0 then lvInfo.Columns.Item[0].width = _increment.x + 540
				if lvVariations.columns.count != 0 then lvVariations.Columns.Item[5].width = _increment.x + 300
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				lvInfo.height = _increment.y/2 + 205
				lvVariations.height = _increment.y/2 + 205

				grpVariationsFile.pos.y = _increment.y/2 + 260
				lblVariationsFile.pos.y = _increment.y/2 + 273
				lvVariations.pos.y = _increment.y/2 + 300	
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

		on lvInfo mouseUp events do
		(
			lvVariations.items.clear()	
			fillVariationsListView()			
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

			initInfoListView()
			initVariationsListView()

			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			resetUI()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()

			parent.updateRelatedTools()

			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	

	struct str_fileMiniData(file = "", loadmode = "", checked = "", level = 0, numVariations = 0)

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: presetInfoManager | Contiene la herramienta presetInfoManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_presetInfoManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Preset Info Manager",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		presetFile = "",
		fileMiniData = str_fileMiniData,
		--presetFile = @"Y:\asset\chr\main\chr_mike\version\preset\chr_mike{clown-std}_mesh_v01.prt",	
		--presetFile = @"Y:\asset\chr\main\chr_mike\version\preset\chr_mike{std-std}_anim_v01.prt",
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

		fn updateRelatedTools = 
		(
			_assetBrowser = lb.getTool "assetBrowser"

			if _assetBrowser != undefined and _assetBrowser.isOpen() then lb.assetBrowser.rollMain.ckbPresetInfo.checked = false
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
		fn run presetFileName:"" =
		(
			if presetFileName != "" then this.presetFile = presetFileName
			
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
		
	)--tl_presetInfoManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_presetInfoManager() --crea la herramienta
)