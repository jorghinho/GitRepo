------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Following Camera"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 145		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local _cam 
		local _ref

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		pickbutton pbtPickRef "Pick Reference" pos:[10,10] width:200 height:20 tooltip:"Selecciona el objeto al que seguira la camara"
		groupBox gbCamOptions "Camera" pos:[10,35] width:200 height:70
		checkbutton chbNewCam "New Camera" pos:[20,50] width:85 height:20 
		checkbutton chbExistCam "Existing Camera" pos:[115,50] width:85 height:20 checked:true
		button btnCreateCam "Select Camera" pos:[20,75] width:155 height:20
		button btnDeleteCam "" pos:[180,75] width:20 height:20 tooltip:"Delete Camera" images:#(((lb.config.getIconsPath()) + "bip_branch_i.bmp"), undefined, 2, 1, 1, 1, 1, true)
		checkbutton chbOrbit "Activate Orbit" pos:[10,110] width:200 height:25 
		--pickbutton pbtpickCam "Pick Camera"
		--button btnUnbind "Unbind Camera"
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		fn initializeVars =
		(
			_cam = undefined
			_ref = undefined
		)
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
		
		------------------------------------------------
		--@fn: undefined | SetObjNameAsBtnText | Cambia el nombre del pickbutton en con el nombre del objeto seleccionado.
		------------------------------------------------	
		function SetObjNameAsBtnText obj pbtn =
		(
			if obj != undefined then
			(
				pbtn.text = obj.name
			)
		)

		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al pulsar el boton.
		--@control: rollout | rollMain | Switch entre NewCam ExistingCam
		------------------------------------------------
		on chbNewCam changed state do
		(
			chbNewCam.checked = state 
			chbExistCam.checked = not state 
			if chbNewCam.checked == true do btnCreateCam.text = "Create Camera"
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al pulsar el boton.
		--@control: rollout | rollMain | Switch entre NewCam ExistingCam
		------------------------------------------------
		on chbExistCam changed state do
		(
			chbExistCam.checked = state 
			chbNewCam.checked = not state 
			if chbExistCam.checked == true do btnCreateCam.text = "Select Camera"
		)

		------------------------------------------------
		--@event: picked | Evento que se lanza al seleccionar un elemneto despues de pulsar el boton
		--@control: rollout | rollMain | Switch entre NewCam ExistingCam
		------------------------------------------------
		on pbtPickRef picked obj do
		(
			SetObjNameAsBtnText obj pbtPickRef
			_ref = obj
		)

		------------------------------------------------
		--@event: picked | Evento que se lanza al pulsar el boton
		--@control: rollout | rollMain | Crea la camara segun los parametros del checkbutton
		------------------------------------------------
		on btnCreateCam pressed do
		(
			if chbNewCam.checked then
			(
				if _cam == undefined then
				(
					if _ref != undefined then
					(
						_cam = freeCamera()
						_cam.parent = _ref
					)else lb.message.show "You need a reference to Orbit"
				)else lb.message.show "Cam already exists"
			)
			else
			(
				_sel = getCurrentSelection()
				if _sel.count == 1 then
				(
					if classof _sel[1] == Freecamera then
					(
						if _ref != undefined then
						(
							_cam = _sel[1]
							_cam.parent = _ref
						)else lb.message.show "You need a reference to Orbit"	
					) 
					if classof _sel[1] == Targetcamera then
					(
						_cam = _sel[1]
						_sel[1].Target.position = _ref.position
						_sel[1].Target.parent = _ref
						_cam.parent = _ref
					)else lb.message.show "The selected Camera has to be Freecam"
				)else lb.message.show "Select only one object please"
			)
		)

		------------------------------------------------
		--@event: picked | Evento que se lanza al pulsar el boton
		--@control: rollout | rollMain | Crea la camara segun los parametros del checkbutton
		------------------------------------------------
		on btnDeleteCam pressed do
		(
			if _cam != undefined then
			(
				delete _cam
				_cam = undefined
			) else lb.message.show "No cams to delete"
		)

		------------------------------------------------
		--@event: picked | Evento que se lanza al pulsar el boton
		--@control: rollout | rollMain | Segun el estado activa/desactiva la orbita alrededor de el objeto
		------------------------------------------------
		on chbOrbit changed theState do
		(
			if chbOrbit.state == true then 
			(
				if _cam != undefined then
				(
					select _cam
					--Select and rotate tool
					actionMan.executeAction 0 "50002"
					toolMode.coordsys _ref
					toolMode.transformCenter()
				)else lb.message.show "You need a cam first to orbit"
			)
			else 
			(
				toolMode.pivotCenter()
				toolMode.coordsys #world		
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
			initializeVars()
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
			if _cam != undefined then btnDeleteCam.pressed()
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_followingCamera
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
		
	)--tl_templateTool
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_followingCamera() --crea la herramienta
)