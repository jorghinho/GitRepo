------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Herramienta docuGenerator, Sirve para generar archivos de documentación de MAX y subirlos directamente a la wiki.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la interfaz visual de la herramienta docuGenerator.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "The Documentator"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 600		--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 600		--@var: integer | minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local toolsFolder = lb.config.getScriptsPath() --@var: string | currDir | Directorio del cual se lee para obtener los elementos a documentar.
		local wikiFilesInFolder = #() --@var: array | wikiFilesInFolder | Array que almacena los archivos en el directorio seleccionado que se encuentran en la wiki.
		local _docuPath = "\\\\jsilvestre\\pages\\" --@var: array | _docuPath | Path al repo donde se encuentra la wiki

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox gbxSearch "Filter" pos:[10,10] width:580 height:40
		editText edtFilter "" pos:[15,25]  width:565 height:20 
		dotNetControl filesLv "System.Windows.Forms.ListView" pos:[10,60] width:580 height:500
		button btnLoadSel "Generate Selected" pos:[50,570] width:125 height:25
		button btnLoadAll "Generate All" pos:[225,570] width:125 height:25
		button btnGenerateWikiStructure "Generate Wiki Structure" pos:[400,570] width:125 height:25 tooltip:"Press when you have added new ms files to LBDATA"
		button btnHalp pos:[560,568] width:25 height:25 tooltip:"Tool help" images:#((lb.config.getCustomIconsPath()) + "miscIcons001_16i.bmp", undefined, 50, 25, 25, 26, 26, true) 
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@fn: undefined | openWikiSelected | Abre la pagina de la wiki para el articulo seleccionado en el listview
		------------------------------------------------			
		fn openWikiSelected = 
		(
			_selectedElemParts =  filterstring filesLv.selectedItems.item[0].text "_."
			_type  = _selectedElemParts[1]
			case _type of 
			(
				"lib": _string = @"http://www.toolslb.com/doku.php?id=Librerias:"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
				"pmov": _string = @"http://www.toolslb.com/doku.php?id=PassManager:"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
				"pmovUI": _string = @"http://www.toolslb.com/doku.php?id=PassManager:UI"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
				"rsa": _string = @"http://www.toolslb.com/doku.php?id=RigSolution:"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
				"rse": _string = @"http://www.toolslb.com/doku.php?id=RigSolution:"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
				"rss": _string = @"http://www.toolslb.com/doku.php?id=RigSolution:"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
				"sc": _string = @"http://www.toolslb.com/doku.php?id=Scripts:"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
				"tl":_string = @"http://www.toolslb.com/doku.php?id=Tools:"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
				default: _string = @"http://www.toolslb.com/doku.php?id=Other:"+_selectedElemParts[_selectedElemParts.count-1] + "_code"
							
			)
		  shellLaunch "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" _string
		)

		------------------------------------------------
		--@fn: undefined | collectFilesInWiki | Obtiene todos los ficheros de txt de la wiki y los guarda en la arraty wikiFilesInFolder
		------------------------------------------------
		fn collectFilesInWiki = 
		(
			wikiFilesInFolder = #()
			
			_folders = getDirectories (_docuPath+"*")
			for _folder in _folders do 
			(
				if( not matchpattern _folder pattern: ("*start*")) and (not matchpattern _folder pattern: ("*playground*")) and (not matchpattern _folder pattern: ("*wiki*")) do 
				(
					_files = getfiles (_folder+"*.txt")
					for _file in _files do 
					(
						_noExtFile = FilterString _file "\\"
						_noExtFile = (FilterString _noExtFile[_noExtFile.count] ".")[1]
						append  wikiFilesInFolder _noExtFile
					)
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | updateLv | Actualiza el contenido de la listview segun el parametro que se le pase
		------------------------------------------------	
		fn updateLv _mode:#update= 
		(
			filesLv.items.clear()
			_files = getfiles (toolsFolder+"*.ms")
			_index = 0
			for _file in _files do 
			(
				_fileParts = FilterString _file "\\"
				_fileName = FilterString _fileParts[_fileParts.count] "_"
				_fileNameExt = (filterString _fileName[_fileName.count] ".")
				if _fileName.count == 2 and _fileNameExt[_fileNameExt.count] == "ms" do 
				(
					case _mode of 
					(
						#update:  
						(
							filesLv.items.add _fileParts[_fileParts.count]
							_found = false 
							_doOnce = true 
							for _element in wikiFilesInFolder do 
							(
								if _fileName[1] == "pmovUI" do 
								(
									if _doOnce do 
									(
										_fileNameExt[1] = "UI"+_fileNameExt[1]
										_doOnce = false
									)
								)

								if _element ==  _fileNameExt[1] do _found = true 
							) 
							if _found then 
							(
								filesLv.items.item[_index].subitems.add "At wiki" 
								filesLv.items.item[_index].subitems.item[1].backColor = (dotnetclass "System.Drawing.Color").fromARGB 200 255 200
							)
							else 
							(
								filesLv.items.item[_index].subitems.add "Not Documentated" 
								filesLv.items.item[_index].subitems.item[1].backColor = (dotnetclass "System.Drawing.Color").fromARGB 255 200 200
							)
							filesLv.items.item[_index].UseItemStyleForSubItems = false 
							_index += 1
						)
						#filter:
						(
							if edtFilter.text == "" then 
							(
								filesLv.items.add _fileParts[_fileParts.count]
								_found = false 
								_doOnce = true 
								for _element in wikiFilesInFolder do 
								(
									if _fileName[1] == "pmovUI" do 
									(
										if _doOnce do 
										(
											_fileNameExt[1] = "UI"+_fileNameExt[1]
											_doOnce = false
										)
									)
	
									if _element ==  _fileNameExt[1] do _found = true 
								) 
								if _found then 
								(
									filesLv.items.item[_index].subitems.add "At wiki" 
									filesLv.items.item[_index].subitems.item[1].backColor = (dotnetclass "System.Drawing.Color").fromARGB 200 255 200
								)
								else 
								(
									filesLv.items.item[_index].subitems.add "Not Found" 
									filesLv.items.item[_index].subitems.item[1].backColor = (dotnetclass "System.Drawing.Color").fromARGB 255 200 200
								)
								filesLv.items.item[_index].UseItemStyleForSubItems = false 
								_index += 1
							)
							else 
							(
								if matchpattern _fileParts[_fileParts.count] pattern:("*" + edtFilter.text + "*") do 
								(
									filesLv.items.add _fileParts[_fileParts.count]
									_found = false 
									_doOnce = true 
									for _element in wikiFilesInFolder do 
									(
										if _fileName[1] == "pmovUI" do 
										(
											if _doOnce do 
											(
												_fileNameExt[1] = "UI"+_fileNameExt[1]
												_doOnce = false
											)
										)
		
										if _element ==  _fileNameExt[1] do _found = true 
									) 
									if _found then 
									(
										filesLv.items.item[_index].subitems.add "At wiki" 
										filesLv.items.item[_index].subitems.item[1].backColor = (dotnetclass "System.Drawing.Color").fromARGB 200 255 200
									)
									else 
									(
										filesLv.items.item[_index].subitems.add "Not Found" 
										filesLv.items.item[_index].subitems.item[1].backColor = (dotnetclass "System.Drawing.Color").fromARGB 255 200 200
									)
									filesLv.items.item[_index].UseItemStyleForSubItems = false 
									_index += 1
								)
							)
						)
					)
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | generateSelectedDoc | Genera la documentación en función del input.
		--@gets: (Opt)boolean | _doitOnAll | Booleano, si es true Genera la documentación sobre todos los elementos de la carpeta, sino solo la genera en los elementos seleccionados del listview.
		------------------------------------------------
		fn generateSelectedDoc _doitOnAll:false= 
		(
			_filesToProcess = #()
			_selectedFiles = undefined
			if _doitOnAll == false then 
			(
				_selectedFiles = filesLv.selecteditems
			) 
			else 
			(
				edtFilter.text = ""
				updateLv()
				_selectedFiles = filesLv.items
			)
			for i=0 to _selectedFiles.count - 1 do 
			(
				append _filesToProcess _selectedFiles.item[i].text
			)
			for _element in _filesToProcess do 
			(
				lb.documentation.generateDoc _resourcePath:(toolsFolder + _element)
			)
			collectFilesInWiki()
			updateLv _mode:#filter
		)

		------------------------------------------------
		--@fn: undefined | initList | inicia y configura el listview de visualizado de ficheros
		------------------------------------------------		
		fn initList list =
		(
			lv = list
			lv.columns.clear()
			lv.multiSelect = true
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.HideSelection = off
			lv.scrollable = true
			lv.labelWrap = True
			lv.labelEdit = false
			lv.columns.add "File" (lv.width*2/3)
			lv.columns.add "Status" (lv.width/3)
			--lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").None
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
				gbxSearch.width = 580 + _increment.x
				edtFilter.width = 565 + _increment.x

				filesLv.width = 580 + _increment.x
				filesLv.Columns.Item[0].width = (580*2/3) + _increment.x/2
				filesLv.Columns.Item[1].width = (580/3) + _increment.x/2

				btnLoadSel.pos.x = 50 + _increment.x/2 
				btnLoadAll.pos.x = 225 + _increment.x/2 
				btnGenerateWikiStructure.pos.x = 400 + _increment.x/2 
				btnHalp.pos.x = 560 + _increment.x/2

			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				filesLv.height = 500 + 	_increment.y
				btnLoadSel.pos.y = 570 + _increment.y
				btnLoadAll.pos.y = 570 + _increment.y
				btnGenerateWikiStructure.pos.y = 570 + _increment.y
				btnHalp.pos.y = 568 + _increment.y
						
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
			_width = undefined 
			_height = undefined 
			_posX = undefined 
			_posY = undefined

			if doesFileExist parent.cfgFile do 
			(
				--------------------------------------------------------------------------------
				--Los parametros de la tool leídos del xml de config van aqui

				-- ancho y alto del rollout
				_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
				_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
					
				--posicion
				_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
				_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer


				--------------------------------------------------------------------------------
			)	
			
			--establece minimos
			if _width == undefined then _width = minRollWidth
			else if _width < minRollWidth then _width = minRollWidth
			
			if _height == undefined then _height = minRollHeight
			else if _height < minRollHeight then _height = minRollHeight
			
			if _posX == undefined then _posX = 0
			else if _posX < 0 then _posX = 0
			
			if _posY == undefined then _posY = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		on edtFilter changed value do 
		(
			updateLv _mode:#filter
		)

		on btnLoadSel pressed do 
		(
			generateSelectedDoc()
		)

		on btnLoadAll pressed do 
		(
			generateSelectedDoc _doitOnAll:true
		)
		
		on btnGenerateWikiStructure pressed do 
		(
			lb.documentation.generateLbToolsFile()
			updateLv()
		)
		on btnHalp pressed do 
		(
 			shellLaunch "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" @"http://www.toolslb.com/doku.php?id=tools:docugenerator"
		)
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		on filesLv doubleClick events do 
		(		
			openWikiSelected()
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
			initList filesLv
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
			collectFilesInWiki()
			updateLv()
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
	--@struct: templateTool | Contiene la herramienta docuGenerator.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_docuGenerator
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la tool.
		description = "Tool docuGenerator",		--@var: string | description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string | cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: boolean | opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollout | rollMain | Almacena el rollout principal de la herramienta.
			
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
		
	)--tl_docuGenerator
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_docuGenerator() --crea la herramienta
)