------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta quickSet Tangents.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta quickSet Tangents.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Quick Set Tangents"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 110		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 34		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local iconpath = if (maxVersion())[1] >= 16000 then (getdir #maxroot)+@"UI_ln\icons\" else (getDir #ui)+@"icons\"
		local keys = #()	

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnAuto "Auto" pos:[2,2] width:30 height:30 images:#(iconpath + "TrackViewKeyTangents_24i.bmp", undefined, 21, 1, 1, 1, 1,true) toolTip:"Auto tangents" border:false
		button btnSlow "Slow" pos:[34,2] width:30 height:30 images:#(iconpath + "TrackViewKeyTangents_24i.bmp", undefined, 21, 3, 3, 3, 3,true) toolTip:"Slow tangents" border:false
		button btnLinear "Linear" pos:[66,2] width:30 height:30 images:#(iconpath + "TrackViewKeyTangents_24i.bmp", undefined, 21, 6, 6, 6, 6,true) toolTip:"Linear tangents" border:false
		button btnStep "Step" pos:[98,2] width:30 height:30 images:#(iconpath + "TrackViewKeyTangents_24i.bmp", undefined, 21, 5, 5, 5, 5,true) toolTip:"Step tangents" border:false
		
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

		fn getAllTrackbarSelectedKeys obj keys =
		(
			if try(obj.numsubs > 0) catch(false) then
			(
				for i=1 to obj.numsubs do
				(
					ctrl = (getSubAnim obj i).controller
					getAllTrackbarSelectedKeys ctrl keys
				)
			) else 
			(
				try (for i=1 to obj.keys.count do if (isKeySelected obj i) do append keys obj.keys[i]) catch()
			)
		)
		
		fn quickSetKeysTangetsType type =
		(
			keys = #()
			for obj in selection do (getAllTrackbarSelectedKeys obj.controller keys)
			
			for key in keys do
			(
				try
				(
					key.inTangentType = type
					key.outTangentType = type
				) catch()
			)
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
			----almacena posicion
			--lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			--lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			----almacena tamaño
			--lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			--lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			--_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
			----posicion
			--_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			--_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
			----establece minimos
			--if _width < minRollWidth then _width = minRollWidth
			--if _height < minRollHeight then _height = minRollHeight
			--if _posX < 0 then _posX = 0
			--if _posY < 0 then _posY = 0
				
			----aplica los valores
			--rollMainDef.width = _width
			--rollMainDef.height = _height
			--setDialogPos rollMainDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		on btnAuto pressed do
		(
			quickSetKeysTangetsType(#auto)
			try (destroyDialog parent.rollMain) catch()
		)
		
		on btnSlow pressed do
		(
			quickSetKeysTangetsType(#slow)
			try (destroyDialog parent.rollMain) catch()
		)
		
		on btnLinear pressed do
		(
			quickSetKeysTangetsType(#linear)
			try (destroyDialog parent.rollMain) catch()
		)
		
		on btnStep pressed do
		(
			quickSetKeysTangetsType(#step)
			try (destroyDialog parent.rollMain) catch()
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
	--@struct: quickSetTangents | Contiene la herramienta quick Set Tangents.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_quickSetTangents
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Quick Set Tangents",		--@var: description | Descripcion de la tool.
		
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
			pos = mouse.screenpos	
			createDialog this.rollMain lockwidth:true lockheight:true pos:[pos[1]-40, pos[2]-30] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_quickSetTangents
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_quickSetTangents() --crea la herramienta
)