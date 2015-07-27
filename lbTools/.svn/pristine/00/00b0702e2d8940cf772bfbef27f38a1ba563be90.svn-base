------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Insert Frames Camera"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 162		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 152		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local _all_cams = #() -- almacena todos los nombres de cámaras de la escena	

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grp_type width:153 height:36 pos:[4,1]
		label lab_type "Insert type:" pos:[10,15]
		dropDownList ddl_item_type items:#("frames", "camera") width:80 pos:[74,12]
		dropDownList ddl_insert_type items:#("before", "after") width:60 pos:[8,45]
		dropDownList ddl_cam width:80 pos:[74,45]
		spinner spn_frames "Duration: " range:[1,999,10] type:#integer width:90 height:17 pos:[22,75]
		label lab_frames "frames" pos:[116,75]
		button btn_ok "Insert" width:153 height:40 pos:[4,105]
		
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
		--@event: pressed | Ejecutar inserción de cámara al pulsar el botón
		------------------------------------------------
		on btn_ok pressed do 
		(
			-- Obtener el índice de lista desplegable de la cámara seleccionada y su duración (cantidad de frames a insertar)
			_cam_index = ddl_cam.selection
			_frames_to_insert = spn_frames.value
			
			-- Si hemos seleccionado el tipo "camera" (ddl_item_type.selection = 2), creamos la nueva cámara
			if ddl_item_type.selection == 2 do
			(
				-- Creamos la nueva cámara y la nombramos correctamente (ej: cam_030, cam_015, cam_007, etc)
				_new_cam = Freecamera()
				_new_cam.name = parent.generateIntermediateCameraNumber _cam_index ddl_cam.items ddl_insert_type.selection
				
				-- Asignamos el rango de tiempos a la nueva cámara
				-- Si el tipo de inserción es "before" (ddl_insert_type.selection = 1) el rango de la nueva cámara comienza donde antes comenzaba la cámara a la que se va a anteponer,
				--   ej: si insertamos antes de cam_030, que comenzaba en el frame 250, la nueva cámara empezará en el frame 250
				-- En cambio, si el tipo de inserción es "after" (ddl_insert_type.selection = 2) el rango de la nueva cámara comienza en el frame siguiente al último frame de la cámara a la que se va a postponer
				--   ej: si insertamos después de cam_050, que terminaba en el frame 394, la nueva cámara comenzará en el frame 395
				_oldcam = getnodebyname ddl_cam.items[_cam_index]
				if ddl_insert_type.selection == 1 then (
					_start_range = _oldcam.recStart
				) else
				(
					_start_range = _oldcam.recEnd + 1
				)
				lb.cameraFunctions.setCameraRange _new_cam _start_range  (_start_range + _frames_to_insert - 1)
			)
			
			-- Si hemos seleccionado la opción "after" aumentamos el índice de cámara en uno para empezar a mover frames desde la siguiente cámara
			if ddl_insert_type.selection == 2 do _cam_index += 1
			
			-- Obtener la cámara a partir de la cual desplazaremos las keys y el rango de inicio
			_cam = getnodebyname ddl_cam.items[_cam_index]
			_start_range = _cam.recStart
			
			-- Seleccionar keys de objetos en el intervalo que va desde el rango de inicio del plano seleccionado
			deselectKeys objects -- deseleccionar todas las keys
			selectKeys objects (interval _start_range 10000000)
			
			-- Mover las keys seleccionadas el número que hayamos introducido en el campo spn_frames
			moveKeys objects _frames_to_insert #selection
			deselectKeys objects -- deseleccionar todas las keys
			
			-- Mover los rangos de todas las cámaras a partir de la seleccionada
			for i=_cam_index to _all_cams.count do
			(
				_cam = getnodebyname ddl_cam.items[i]
				lb.cameraFunctions.setCameraRange _cam (_cam.recStart+_frames_to_insert) (_cam.recEnd+_frames_to_insert)
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

			_all_cams = parent.getLayCameraNames()
			ddl_cam.items = _all_cams

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
	struct tl_insertFramesCamera
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Insert Frames Camera",		--@var: description | Descripcion de la tool.
		
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
		--@fn: undefined | getLayCameraNames | Devuelve el listado de cámaras de la escena
		------------------------------------------------
		fn getLayCameraNames = 
		(
			sort(for cam in cameras where (findString cam.name ".Target") == undefined collect cam.name)
		),

		------------------------------------------------
		--@fn: undefined | getLayCamNumber | Devuelve el número de una cámara dado su nombre (str)
		------------------------------------------------
		fn getLayCamNumber str = 
		(
			(filterstring str "_")[2] as integer
		),

		------------------------------------------------
		--@fn: undefined | getCamMiddleNumber | Obtiene un número intermedio entre (first) y (second)
		------------------------------------------------		
		fn getCamMiddleNumber first second = 
		(
			floor((first+second)/2) as integer
		),
		
		------------------------------------------------
		--@fn: undefined | formatNumber | Formatea un número (n) con (len) ceros a la izquierda. Devuelve una cadena
		------------------------------------------------			
		fn formatNumber n len = (
			a = n as string
			current_len = a.count
			if current_len < len do for i=(current_len+1) to len do a = "0"+a
			a
		),
		
		------------------------------------------------
		--@fn: undefined | generateIntermediateCameraNumber | Genera un nombre de cámara intermedio entre 2 cámaras dado el punto de inserción "index", su zona de inserción "insertion_type" (1 = "before", 2 = "after") y el listado de cámaras "cam_list" 
		------------------------------------------------				
		fn generateIntermediateCameraNumber index cam_list insertion_type	= 
		(
			-- Calcular número de cámara
			-- Si el tipo de inserción es "before" (insertion_type = 1)
			if insertion_type == 1 then 
			(
				-- Comprobamos si estamos insertando antes de la primera cámara
				if index == 1 then 
				(
					-- Insertar antes de la primera cámara. Numeraremos entre 0 y la primera cámara. 
					-- ej: si insertamos antes de la cam_010, la cámara nueva estará numerada entre 0 y 10, por tanto será cam_005
					_first_cam_number = 0			
				) else 
				(
					-- No insertamos antes de la primera cámara. Calculamos el número de cámara entre la cámara seleccionada y la anterior.
					_first_cam_number = parent.getLayCamNumber(cam_list[index-1])
				)
				_second_cam_number = parent.getLayCamNumber(cam_list[index])
				_new_cam_number = parent.getCamMiddleNumber _first_cam_number _second_cam_number
			) else -- en caso contrario, el tipo de inserción es "after" (ddl_insert_type.selection = 2)
			(
				-- Comprobamos si estamos insertando después de la última cámara
				if index ==  cam_list.count then 
				(
					-- Insertar después de la última cámara. Numeraremos 10 unidades más que la última cámara. 
					-- ej: si insertamos después de la cam_130, la cámara nueva será cam_140
					_new_cam_number =  parent.getLayCamNumber(cam_list[index]) + 10
				) else 
				(
					-- No insertamos después de la última cámara. Calculamos el número de cámara entre la cámara seleccionada y la siguiente.
					_first_cam_number = parent.getLayCamNumber(cam_list[index])
					_second_cam_number = parent.getLayCamNumber(cam_list[index+1])
					_new_cam_number = parent.getCamMiddleNumber _first_cam_number _second_cam_number
				)
			)
			
			-- Devolver el nombre de la nueva cámara
			"cam_" + (parent.formatNumber _new_cam_number 3)
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
		
	)--tl_insertFramesCamera
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_insertFramesCamera() --crea la herramienta
)