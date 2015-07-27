------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Herramienta Custom Layout.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta Custom Layout.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Custom Layout" width:285 height:205
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 285		--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 205		--@var: integer | minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		Local _files = #()		--Contiene las rutas enteras de los archivos de layout.
		Local _fileName = #()	--Contiene los nombres del listado.
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--@control | controlName | creación de menú.
		groupBox grp2CustomLayout "Custom Layout" pos:[5,5] width:275 height:195
		dropDownList ddlLayoutList "Layout List" pos:[10,20] width:265 height:40 enabled:true
		
		groupBox grp2SaveLoadParameters "Save/Load Parameters" pos:[25,65] width:230 height:43
		checkbutton btnSaveParameters "Save Parameters" pos:[35,80] width:96 height:20 enabled:false
		checkbutton btnLoadParameters "Load Parameters" pos:[150,80] width:96 height:20 enabled:false
		
		groupBox grp2SelectConfiguration "Select Configuration" pos:[10,112] width:265 height:47
	    checkbutton btnLayout "Layout" pos:[20,130] width:80 height:20 enabled:false
		checkbutton btnLayoutMesh "Layout-mesh" pos:[105,130] width:80 height:20 enabled:false
		checkbutton btnCollapse "Collapse" pos:[190,130] width:80 height:20 enabled:false
		
		button btnDelete "Delete" pos:[15,165] width:115 height:30 enabled:true
		button btnLoad "Load" pos:[155,165] width:115 height:30 enabled:true
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@fn: undefined | getLayoutNamesFromLibrary | Función que gestiona los nombres de los Layout y los mete en un array para listar los nombres mas adelante.
		------------------------------------------------
		fn getLayoutFileNames =
		(
			_fileName = #()
			_folderLayout = (@"W:\asset\chr\extra")
			
			_files = getDirectories (_folderLayout + "\\*")
			for o in _files do
			(
				_filterArchive = filterString o "\\"
				_filterName = filterString _filterArchive[5] "_"
				_filterPart = filterString _filterName[2] "t"
				append _fileName _filterPart[2]
			)
			
			_fileName
		)					
		
		------------------------------------------------
		--@fn: undefined | MergeLayout | Función que mergea el layout seleccionado en el listado.
		------------------------------------------------
		fn mergeLayout =
		(
			_archive = (_files[ddlLayoutList.selection] + "version\preset\chr_layout" + _fileName[ddlLayoutList.selection] + "{std-std}_layout_v01.prt")
			_LoadFile = lb.presets.loadPreset _archive renameParts:true renamePartsMaterials:true loadSkinData:true stackTrace:#()
		)
		
		------------------------------------------------
		--@fn: undefined | DeleteLayout | Función que borrar el layout seleccionado.
		--@fn: node | obj | Se le pasa los objetos seleccionados.
		------------------------------------------------
		fn deleteLayout obj =
		(
			_assets = lb.asset.getAssetsfromNodes obj

			for _asset in _assets do lb.asset.deleteAsset _asset
		)
		
		------------------------------------------------
		--@fn: undefined | MergeLayout | Función que mergea el layout seleccionado en el listado.
		--@fn: node | obj | Se le pasa los objetos seleccionados.
		------------------------------------------------
		fn getLayout obj =
		(
			_selectAsset = lb.asset.getAssetsFromNodes obj
			
			_filterName = filterString _selectAsset[1].fullname "_"
			_filterPart = filterString _filterName[2] ":"
			
			if _filterPart[1] == "layoutStd" then
			(
				print "rellenar con información"
			)
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
		---------------------------------------------------------------------------------------------------------------
		--evento para mergear el layout seleccionado en el listado
		---------------------------------------------------------------------------------------------------------------
		on btnLoad pressed do
		(
			mergeLayout()
		)
		
		---------------------------------------------------------------------------------------------------------------
		--evento para borrar el layout seleccionado.
		---------------------------------------------------------------------------------------------------------------
		on btnDelete pressed do
		(
			_obj = getCurrentSelection()
			deleteLayout _obj
-- 			lb.message.show "scale fail" 
		)
		
		---------------------------------------------------------------------------------------------------------------
		--evento para definir el layout configurado.
		---------------------------------------------------------------------------------------------------------------
		on btnLayout pressed do
		(
-- 			_obj = getCurrentSelection()
-- 			getLayout _obj
-- 			lb.message.show "scale fail" 
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
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
			
			ddlLayoutList.items = getLayoutFileNames() --Rellena el desplegable.getLayoutNames
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
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_customLayout
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la tool.
		description = "Custom Layout",		--@var: string | description | Descripcion de la tool.
		
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
		
	)--tl_templateTool
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_customLayout() --crea la herramienta
)