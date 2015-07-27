------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Timestamp Setup"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 215		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 285		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local iniFile = (toolsCfgPath + "\\quicktimePreview.ini")
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		GroupBox grpStamps "" pos:[5,5] width:205 height:275
		checkbox chkShowStamps "Show Stamps" pos:[15,5] width:89 height:15
		checkbox chkAnimatorName "Animator Name" pos:[15,31] width:95 height:15
		edittext edtAnimatorName "" pos:[30,50] width:170 height:17
		checkbox chkDate "Date/duration" pos:[15,75] width:90 height:15
		checkbox chkFrameNumbers "Frame Numbers" pos:[15,100] width:98 height:15
		checkbox chkCameraStamp "Camera stamp" pos:[15,125] width:90 height:15
		checkbox chkCustomStamp "Custom stamp" pos:[15,150] width:90 height:15
		edittext edtCustomStamp "" pos:[30,170] width:170 height:17
		GroupBox grpTextOptions "Text Options" pos:[10,198] width:195 height:77
		spinner spnTextSize "Size" pos:[25,220] width:70 height:16 enabled:true range:[1,10,10] type:#integer
		colorPicker cpTextColor "Text Color" pos:[15,245] width:80 height:25 color:[0,255,0]
		colorPicker cpFrameNumColor "Frames Color" pos:[105,245] width:92 height:25 color:[0,255,0]
		spinner spnDistanceToCamera "Distance" pos:[110,220] width:90 height:16 enabled:true range:[1,1000,10] type:#integer
		--@control | controlName | Plantilla de comentario para controles
		
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
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadIniConfig =
		(
			_showStampsEnabled = execute (getINIsetting iniFile "stamps" "enabled")
			_animatorNameStampEnabled = execute (getINISetting iniFile "stamps" "animatorNameStampEnabled")
			_animatorName = (getINISetting iniFile "stamps" "animatorName")
			_dateStampEnabled = execute (getINISetting iniFile "stamps" "dateStampEnabled")
			_frameNumbersStampEnabled = execute (getINISetting iniFile "stamps" "frameNumbersStampEnabled")
			_cameraStampEnabled = execute (getINISetting iniFile "stamps" "cameraStampEnabled")
			_customStampEnabled = execute (getINISetting iniFile "stamps" "customStampEnabled")
			_customStamp = (getINISetting iniFile "stamps" "customStamp")
			_txtSize = execute (getINISetting iniFile "stamps" "textSize")
			_txtColor = execute (getINISetting iniFile "stamps" "textColor")
			_txtFrameNumColor = execute (getINISetting iniFile "stamps" "textColor")
			_distanceToCamera = execute (getINISetting iniFile "stamps" "distanceToCamera")
			
			chkShowStamps.checked = if _showStampsEnabled != ok then _showStampsEnabled else false
			chkAnimatorName.checked = if _animatorNameStampEnabled != ok then _animatorNameStampEnabled else false
			edtAnimatorName.text = _animatorName
			chkDate.checked = if _dateStampEnabled != ok then _dateStampEnabled else false
			chkFrameNumbers.checked = if _frameNumbersStampEnabled != ok then _frameNumbersStampEnabled else true
			chkCameraStamp.checked = if _cameraStampEnabled != ok then _cameraStampEnabled else true
			chkCustomStamp.checked = if _customStampEnabled != ok then _customStampEnabled else false
			edtCustomStamp.text = _customStamp 
			spnTextSize.value = if _txtSize != ok then _txtSize else 10
			cpTextColor.color = if _txtColor != ok then _txtColor else [0,255,0]
			cpFrameNumColor.color = if _txtColor != ok then _txtFrameNumColor else [0,255,0]
			spnDistanceToCamera.value = if _distanceToCamera != ok then _distanceToCamera else 10
		)
		
		fn saveIniConfig =
		(
			setINISetting iniFile "stamps" "enabled" (chkShowStamps.checked as string)
			setINISetting iniFile "stamps" "animatorNameStampEnabled" (chkAnimatorName.checked as string)
			setINISetting iniFile "stamps" "animatorName" edtAnimatorName.text
			setINISetting iniFile "stamps" "dateStampEnabled" (chkDate.checked as string)
			setINISetting iniFile "stamps" "frameNumbersStampEnabled" (chkFrameNumbers.checked as string)
			setINISetting iniFile "stamps" "cameraStampEnabled" (chkCameraStamp.checked as string)
			setINISetting iniFile "stamps" "customStampEnabled" (chkCustomStamp.checked as string)
			setINISetting iniFile "stamps" "customStamp" edtCustomStamp.text
			setINISetting iniFile "stamps" "textSize" (spnTextSize.value as string)
			setINISetting iniFile "stamps" "textColor" (cpTextColor.color as string)
			setINISetting iniFile "stamps" "fpsColor" (cpFrameNumColor.color as string)
			setINISetting iniFile "stamps" "distanceToCamera" (spnDistanceToCamera.value as string)
		)
		
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
			
			--TEMPORAL: cargar los ajustes desde el antiguo fichero INI
			saveIniConfig()
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMai/size") "height") as integer
				
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
			
			--TEMPORAL: cargar los ajustes desde el antiguo fichero INI
			loadIniConfig()
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
		on rollMainDef resized size do
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
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
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
	--@struct: passManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_timestampSetup
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
		
	)--tl_timestampSetup
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_timestampSetup() --crea la herramienta
)