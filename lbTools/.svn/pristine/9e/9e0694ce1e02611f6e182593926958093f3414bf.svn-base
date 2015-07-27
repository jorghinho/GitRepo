------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta cameraStamps.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta cameraStamps.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Video Stamps Setup"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 185		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 250		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		checkbox chkArtist "Artist name:" pos:[7,7] width:95 height:15
		edittext edtArtistName "" pos:[20,25] width:155 height:17
		checkbox chkFrameNumbers "Frame numbers" pos:[7,50] width:98 height:15
		checkbox chkSequence "Sequence" pos:[7,75] width:98 height:15
		checkbox chkCamera "Camera" pos:[7,99] width:90 height:15
		checkbox chkFocallength "Focal length" pos:[7,124] width:90 height:15
		checkbox chkStage "Custom stamp:" pos:[7,149] width:90 height:15
		edittext edtStageText "" pos:[20,166] width:155 height:17
		button btnSave "Save settings" pos:[7,200] width:170 height:40 tooltip:"Save this video stamp settings"
		
		/* -- Deshabilitamos las opciones de configuración de texto de momento
		groupBox grpTextOptions "Text Options" pos:[5,174] width:225 height:75
		spinner spnTextSize "Size" pos:[20,194] width:70 height:16 enabled:true range:[1,10,6] type:#integer
		colorPicker cpTextColor "Text" pos:[97,189] width:55 height:25 color:[0,255,0]
		colorPicker cpFpsColor "Frame" pos:[160,189] width:62 height:25 color:[0,255,0]
		spinner spnDistanceToCamera "Distance to camera:" pos:[58,219] width:100 height:16 enabled:true range:[1,1000,10] type:#integer
		*/
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@fn: string | getStageFromFilename | Devuelve la última parte del nombre de fichero (Ej: "layout", "anim", "cache")
		------------------------------------------------
		fn getStageFromFilename = 
		(
			-- Buscar última cadena con formato "_loquesea"
			return lb.re.match maxfilename ".*_([^_]+)\.max$"
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

			--almacena la informacion de los stamps
			lb.xml.setAttribute parent.cfgFile ("rollMain/stamps") "artist" (chkArtist.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/stamps") "artistName" edtArtistName.text
			lb.xml.setAttribute parent.cfgFile ("rollMain/stamps") "frame" (chkFrameNumbers.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/stamps") "sequence" (chkSequence.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/stamps") "camera" (chkCamera.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/stamps") "focallength" (chkFocallength.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/stamps") "stage" (chkStage.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/stamps") "stageText" edtStageText.text

			--almacena el tamaño de la letra, y el color de la letra y de los frames
			-- lb.xml.setAttribute parent.cfgFile ("rollMain/textSize") "textSize" (spnTextSize.value as string)
			-- lb.xml.setAttribute parent.cfgFile ("rollMain/textColor") "textColor" (cpTextColor.color as string)
			-- lb.xml.setAttribute parent.cfgFile ("rollMain/textColor") "fpsColor" (cpFpsColor.color as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(	
			--carga el tamaño
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
			
			--carga la posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer

			--carga los stamps anteriores
			_artist = (lb.xml.getAttribute parent.cfgFile ("rollMain/stamps") "artist")
			_artistName = (lb.xml.getAttribute parent.cfgFile ("rollMain/stamps") "artistName")
			_stage = (lb.xml.getAttribute parent.cfgFile ("rollMain/stamps") "stage")
			_stageText = (lb.xml.getAttribute parent.cfgFile ("rollMain/stamps") "stageText")
			_camera = (lb.xml.getAttribute parent.cfgFile ("rollMain/stamps") "camera")
			_frameNumbers = (lb.xml.getAttribute parent.cfgFile ("rollMain/stamps") "frame")
			_sequence = (lb.xml.getAttribute parent.cfgFile ("rollMain/stamps") "sequence")
			_focallength = (lb.xml.getAttribute parent.cfgFile ("rollMain/stamps") "focallength")

			--edtArtistName.text = if _artistName != "" then _artistName else sysInfo.username 
			--edtStageText.text = if _stageText != "" then _stageText else getStageFromFilename()
			chkArtist.checked = if _artist != "" then execute _artist else true
			chkStage.checked = if _stage != "" then execute _stage else true
			chkCamera.checked = if _camera != "" then execute _camera else true
			chkFrameNumbers.checked = if _frameNumbers != "" then execute _frameNumbers else true
			chkSequence.checked = if _sequence != "" then execute _sequence else true
			chkFocallength.checked = if _focallength != "" then execute _focallength else true
			
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
		--@event | changed | Evento que activa el check para mostrar nombre del animador.
		------------------------------------------------
		on chkArtist changed state do 
		(

		)
		
	
		------------------------------------------------
		--@event | changed | Evento que activa el check para mostrar la fecha.
		------------------------------------------------
		on chkDate changed state do
		(

		)		
		
		------------------------------------------------
		--@event | changed | Evento que activa el check para mostrar frames.
		------------------------------------------------
		on chkFrameNumbers changed state do 
		(

		)
		
		------------------------------------------------
		--@event | changed | Evento que activa el check para mostrar el camera stamps.
		------------------------------------------------
		on chkCamera changed state do 
		(

		)
		
		------------------------------------------------
		--@event | changed | Evento que activa el text para editar el custom stamp.
		------------------------------------------------
		on edtStageText changed text do 
		(

		)
		
		------------------------------------------------
		--@event | changed | Evento que activa el check para mostrar los Stamps.
		------------------------------------------------
		on chkStage changed val do
		(

		)

				------------------------------------------------
		--@event: pressed | Evento que se lanza al hacer click en el botón de Save settings
		--@control: button | btnSave | Botón que salva los settings y cierra el rollout
		------------------------------------------------
		on btnSave pressed do parent.close()

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
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			saveSettings()
			removeSceneEvents() --elimina los callbacks
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: cameraStamps | Contiene la herramienta cameraStamps.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_cameraStamps
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
			createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_cameraStamps
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_cameraStamps() --crea la herramienta
)