------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta namingConventionInfo.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta namingConventionInfo.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Naming Convention Info"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 560		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 245		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--Objects------------------------------------------------------------------------------------------------
		GroupBox grpObj "Objects" pos:[5,5] width:550 height:55
		
		label lblObjType "Type" pos:[10,20] width:24 height:15
		dropdownList ddlObjType "" pos:[10,35] width:50 height:21 enabled:true
		button btnObjTypeHelp "?" pos:[45,20] width:15 height:15
		
		label lblObjAsset "Asset" pos:[70,20] width:30 height:15
		editText edtObjAsset "" pos:[65,35] width:110 height:20 enabled:false
		button btnObjAssetHelp "?" pos:[160,20] width:15 height:15
		
		label lblObjClass "Class" pos:[185,20] width:30 height:15
		dropdownList ddlObjClass "" pos:[185,35] width:65 height:21 enabled:true
		button btnObjClassHelp "?" pos:[235,20] width:15 height:15
		
		label lblObjLocation "Location" pos:[260,20] width:45 height:15
		dropdownList ddlObjLocation "" pos:[260,35] width:60 height:21 enabled:true
		button btnObjLocationHelp "?" pos:[305,20] width:15 height:15
		
		label lblName "Name" pos:[330,20] width:30 height:15
		editText edtObjName "" pos:[325,35] width:110 height:20 enabled:false
		button btnObjNameHelp "?" pos:[420,20] width:15 height:15
		
		label lblObjSpecial "Special" pos:[445,20] width:35 height:15
		dropdownList ddlObjSpecial "" pos:[445,35] width:50 height:21 enabled:true
		button btnObjSpecialHelp "?" pos:[480,20] width:15 height:15
		
		label lblObjFlags "Flags" pos:[505,20] width:30 height:15
		dropdownList ddlObjFlags "" pos:[505,35] width:45 height:21 enabled:true
		button btnObjFlagsHelp "?" pos:[535,20] width:15 height:15
		------------------------------------------------------------------------------------------------------------
		
		--Layers------------------------------------------------------------------------------------------------
		GroupBox grpLayer "Layers" pos:[5,65] width:550 height:55
		
		label lblLayerType "Type" pos:[10,80] width:24 height:15
		dropdownList ddlLayerType	"" pos:[10,95] width:50 height:21 enabled:true
		button btnLayerTypeHelp "?" pos:[45,80] width:15 height:15
		
		label lblLayerAsset "Asset" pos:[70,80] width:30 height:15
		editText edtLayerAsset "" pos:[65,95] width:110 height:20 enabled:false
		button btnLayerAssetHelp "?" pos:[160,80] width:15 height:15
		------------------------------------------------------------------------------------------------------------
		
		--Materials------------------------------------------------------------------------------------------------
		GroupBox grpMat "Materials" pos:[5,125] width:550 height:55
		
		label lblMatType "Type" pos:[10,140] width:24 height:15
		dropdownList ddlMatType "" pos:[10,155] width:50 height:21 enabled:true
		button btnMatTypeHelp "?" pos:[45,140] width:15 height:15
		
		label lblMatAsset "Asset" pos:[70,140] width:30 height:15
		editText edtMatAsset "" pos:[65,155] width:110 height:20 enabled:false
		button btnMatAssetHelp "?" pos:[160,140] width:15 height:15
		
		label lblMatName "Name" pos:[185,140] width:30 height:15
		editText edtMatName "" pos:[180,155] width:110 height:20 enabled:false
		button btnMatNameHelp "?" pos:[275,140] width:15 height:15
		------------------------------------------------------------------------------------------------------------
		
		--Bitmaps------------------------------------------------------------------------------------------------
		GroupBox grpBmp "Bitmaps" pos:[5,185] width:550 height:55
		
		label lblBmpType "Type" pos:[10,200] width:24 height:15
		dropdownList ddlBmpType "" pos:[10,215] width:50 height:21 enabled:true
		button btnBmpTypeHelp "?" pos:[45,200] width:15 height:15
		
		label lblBmpAsset "Asset" pos:[70,200] width:30 height:15
		editText edtBmpAsset "" pos:[65,215] width:110 height:20 enabled:false
		button btnBmpAssetHelp "?" pos:[160,200] width:15 height:15
		
		label lblBmpName "Name" pos:[185,200] width:30 height:15
		editText edtBmpName "" pos:[180,215] width:110 height:20 enabled:false
		button btnBmpNameHelp "?" pos:[275,200] width:15 height:15
		
		label lblBmpClass "Class" pos:[300,200] width:30 height:15
		dropdownList ddlBmpClass "" pos:[300,215] width:50 height:21 enabled:true
		button btnBmpClassHelp "?" pos:[335,200] width:15 height:15
		
		label lblBmpDetail "Detail" pos:[360,200] width:30 height:15
		dropdownList ddlBmpDetail "" pos:[360,215] width:45 height:21 enabled:true
		button btnBmpDetailHelp "?" pos:[390,200] width:15 height:15
		
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
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		--OBJECTS
	
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnObjTypeHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica el tipo de asset, debe coincidir con el nombre del archivo.\n"
			
			for i=1 to (lb.nc.NC_assetTypes.count - 1) do
				helpString += "\n - " + lb.nc.NC_assetTypes[i] + ": " + lb.nc.NC_assetTypesDesc[i]
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnObjAssetHelp pressed do
		(
			helpString = "Especifica el nombre del asset, debe coincidir con el nombre del archivo.\n"
			helpString += "\nEj: tadeo, fredi, sara, sara-worker"
			helpString += "\nSe pueden utilizar nombres compuestos, separando las partes con un guión medio"
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnObjClassHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica el tipo de objeto segun la funcion que va a desempeñar.\n"
			
			for i=1 to lb.nc.NC_classTypes.count do
				helpString += "\n - " + lb.nc.NC_classTypes[i] + (if lb.nc.NC_classTypes[i] != lb.nc.NC_classPuppet then ":\t " else ": ") + lb.nc.NC_classTypesDesc[i]
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnObjLocationHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica la localización del objeto. Izquierda, derecha, arriba...\n"
			helpString += "Si no es relevante para algun objeto, se debe usar la localización 'sin especificar'.\n"
			
			for i=1 to lb.nc.NC_locationTypes.count do
				helpString += "\n - " + lb.nc.NC_locationTypes[i] + ":\t" + lb.nc.NC_locationTypesDesc[i]
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnObjNameHelp pressed do
		(
			helpString = "Especifica el nombre del objeto.\n"
			helpString += "\nEj: arm, leg, clavicle..."
			helpString += "\nSe pueden utilizar nombres compuestos, separando las partes con un guión medio"
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnObjSpecialHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica el tipo de cache del objeto.\n"
			helpString += "Solo se especifica para geometrias.\n"
			
			for i=1 to lb.nc.NC_specialTypes.count do
				helpString += "\n - " + lb.nc.NC_specialTypes[i] + ":\t" + lb.nc.NC_specialTypesDesc[i]
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnObjFlagsHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica las propiedades del objeto.\n"
			
			for i=1 to lb.nc.NC_flags.count do
				helpString += "\n - " + lb.nc.NC_flags[i] + ":\t" + lb.nc.NC_flagsDesc[i]
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		
		--LAYERS
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnLayerTypeHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica el tipo de asset, debe coincidir con el nombre del archivo.\n"
			
			for i=1 to (lb.nc.NC_assetTypes.count - 1) do
				helpString += "\n - " + lb.nc.NC_assetTypes[i] + ": " + lb.nc.NC_assetTypesDesc[i]
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnLayerAssetHelp pressed do
		(
			helpString = "Especifica el nombre del asset, debe coincidir con el nombre del archivo.\n"
			helpString += "\nEj: tadeo, fredi, sara, sara-worker"
			helpString += "\nSe pueden utilizar nombres compuestos, separando las partes con un guión medio"
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		
		--MATERIALS
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnMatTypeHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica el tipo de asset, debe coincidir con el nombre del archivo.\n"
			
			for i=1 to (lb.nc.NC_assetTypes.count - 1) do
				helpString += "\n - " + lb.nc.NC_assetTypes[i] + ": " + lb.nc.NC_assetTypesDesc[i]
			
			helpString += "\n - " + lb.nc.NC_matPrefix + ": " + lb.nc.NC_matPrefixDesc
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnMatAssetHelp pressed do
		(
			helpString = "Especifica el nombre del asset, debe coincidir con el nombre del archivo.\n"
			helpString += "\nEj: tadeo, fredi, sara, sara-worker"
			helpString += "\nSe pueden utilizar nombres compuestos, separando las partes con un guión medio"
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnMatNameHelp pressed do
		(
			helpString = "Especifica el nombre del material.\n"
			helpString += "\nEj: body, head, eye..."
			helpString += "\nSe pueden utilizar nombres compuestos, separando las partes con un guión medio"
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		
		--BITMAPS
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnBmpTypeHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica el tipo de asset, debe coincidir con el nombre del archivo.\n"
			
			for i=1 to (lb.nc.NC_assetTypes.count - 1) do
				helpString += "\n - " + lb.nc.NC_assetTypes[i] + ": " + lb.nc.NC_assetTypesDesc[i]
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
			
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnBmpAssetHelp pressed do
		(
			helpString = "Especifica el nombre del asset, debe coincidir con el nombre del archivo.\n"
			helpString += "\nEj: tadeo, fredi, sara, sara-worker"
			helpString += "\nSe pueden utilizar nombres compuestos, separando las partes con un guión medio"
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)	
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnBmpNameHelp pressed do
		(
			helpString = "Especifica el nombre del material.\n"
			helpString += "\nEj: body, head, eye..."
			helpString += "\nSe pueden utilizar nombres compuestos, separando las partes con un guión medio"
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnBmpClassHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica el tipo de mapa\n"
					
			for i=1 to lb.nc.NC_mapTypes.count do
				helpString += "\n - " + lb.nc.NC_mapTypes[i] + ":\t" + lb.nc.NC_mapTypesDesc[i]
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
		)
		
		------------------------------------------------------------------------------------------------------------
		--abre la ventana de ayuda de esa parte del naming convention
		------------------------------------------------------------------------------------------------------------
		on btnBmpDetailHelp pressed do
		(
			helpString = ""
			
			helpString += "Especifica el nivel de detalle del mapa. Si no tiene se debe dejar 'sin especificar'\n"
					
			for i=1 to lb.nc.NC_mapDetailLevels.count do
				helpString += "\n - " + lb.nc.NC_mapDetailLevels[i] + ":\t" + lb.nc.NC_mapDetailLevelsDesc[i]
			
			lb.message.show helpString type:#message pos:undefined size:[500,75] modal:true
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
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_namingConventionInfo
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Naming Convention Info",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_namingConventionInfo
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_namingConventionInfo() --crea la herramienta
)