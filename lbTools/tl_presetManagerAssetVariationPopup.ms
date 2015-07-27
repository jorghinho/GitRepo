------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Asset Variation Popup"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 340		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 425		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		local selectionBackcolor = (dotnetclass "System.Drawing.Color").white
		local selectionForecolor = (dotnetclass "System.Drawing.Color").black

		local clipboardObj = dotNetClass "System.Windows.Forms.Clipboard"  -- crea un clipboard de puntonet	
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles
		dotNetControl dgAssetVariations "System.Windows.Forms.DataGridView" pos:[0,0] width:340 height:400
		button btnOK "OK" pos:[100,400] width:70 height:25
		button btnCancel "Cancel" pos:[170,400] width:70 height:25

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
		
		--Inicia los controles de la ventana
		fn initControls = 
		(
			--Ponemos los settings básicos
			dgAssetVariations.allowUsertoaddRows = false
			dgAssetVariations.allowUserToResizeRows = false
			dgAssetVariations.allowUserToResizeColumns = false
			dgAssetVariations.AllowUserToOrderColumns = false
			dgAssetVariations.columnHeadersHeightSizeMode = (dotNetClass "System.Windows.Forms.dataGridViewColumnHeadersHeightSizeMode").disableResizing
			dgAssetVariations.AdvancedColumnHeadersBorderStyle.all = (dotnetclass "System.Windows.Forms.DataGridViewAdvancedCellBorderStyle").outset
			
			dgAssetVariations.columnHeadersVisible = false									--para que las columnas no tengan titulo
			dgAssetVariations.rowheadersvisible = false									--para que las filas no tengan titulo
			
			dgAssetVariations.foreColor = (dotNetClass "System.Drawing.Color").black
			
			dgAssetVariations.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5					
			
			dgAssetVariations.readonly = true
			dgAssetVariations.multiSelect = false
			dgAssetVariations.showCellTooltips = false
			dgAssetVariations.selectionMode = (dotnetClass "System.Windows.Forms.DataGridViewSelectionMode").FullRowSelect
			dgAssetVariations.allowUserToResizeColumns = false

			--Creamos las columnas
			--Icono
			_column = (dotnetobject "System.Windows.Forms.DataGridViewImageColumn")
			_column.width = 25	
			_column.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_column.HeaderText = "Icon"
			dgAssetVariations.columns.add _column
			
			--Archivo
			_column = (dotnetobject "System.Windows.Forms.DataGridViewTextBoxColumn")
			_column.width = 312
			_column.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_column.HeaderText = "File"
			dgAssetVariations.columns.add _column
		)

		--Rellena el dataGridView del listado de variaciones
		fn fillDataGrid =
		(
			--print lb.presetManagerAssetVariationPopup.assetPath
			--print ("-" + (((filterString (getFilenameFile lb.presetManagerAssetVariationPopup.assetPath) "{()}")[2]) "-")[2])
			_assetPath = lb.presetManagerAssetVariationPopup.assetPath

			--solo funciona esta parte para assets, en secuencias no tiene sentido
			if not MatchPattern _assetPath pattern:(lb.nc.NC_seqGenericPathPattern + "*") then
			(
				_assetFile = getFilenameFile _assetPath
				_assetFileParts = FilterString _assetFile "{()}"
				_presetPart = FilterString _assetFileParts[2] "-"

				_wildcard = substituteString _assetPath ("-" + _presetPart[2]) "-*"
				
				_assetVariations = getFiles _wildcard

				for _var in _assetVariations do
				(
					_row = (dotnetobject "System.Windows.Forms.DataGridViewRow") 
					_row.height = 25
					dgAssetVariations.rows.add _row

					_icon = lb.asset.getAssetIconFromPath _var
					--Celda de icono
					if _icon != undefined then
					(
						_row.cells.item[0].value = _icon
					)
					else
					(
						setClipboardBitmap (bitmap 20 20 color:(color 220 220 220 0))
						_row.cells.item[0].value = clipboardObj.GetImage() -- recupera la imagen del clipboard y la pone en el control
						clipboardObj.clear() --limpia el portapapeles
					)

					--Celda de ruta
					_row.cells.item[1].value = _var
				)
			)			
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
		on btnOK pressed do
		(
			if dgAssetVariations.SelectedRows.count > 0 then
			(
				parent.callbackFn dgAssetVariations.SelectedRows.item[0].cells.item[1].value	
			)
			parent.destroyInterface()
		)

		on btnCancel pressed do
		(
			parent.destroyInterface()
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
			initControls()
			if lb.presetManagerAssetVariationPopup.assetPath != "" then --Si no se pasa ruta no se rellena del dataGridView
				fillDataGrid()
			createSceneEvents() --crea los callbacks
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
	--@struct: presetManagerAssetVariationPopup | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_presetManagerAssetVariationPopup
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
		assetPath = "",
		callbackFn = undefined,
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
		fn run assetPath:"" callbackFn:undefined =
		(
			this.callbackFn = callbackFn
			this.assetPath = assetPath
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
		
	)--tl_presetManagerAssetVariationPopup
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_presetManagerAssetVariationPopup() --crea la herramienta
)