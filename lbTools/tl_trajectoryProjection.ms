------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta TrajectoryProjection.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta TrajectoryProjection.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "TrajectoryProjection Tool"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 200		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 185		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local _obj = undefined 
		local _p = undefined 
		local _initPos = undefined
		local _initRot = undefined	

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		pickbutton pbtnElement "Pick element" pos:[10,10] width:180 height:25
		groupBox gbxParams "Config Params" pos:[10,40] width:180 height:100
		checkbutton chbEnable "Pre Calculate"  pos:[20,60] width:160 height:25 enabled:false
		spinner spnInitFrame "Start" pos:[30,90] width:70 range:[-99999,99999,1] type:#integer enabled:false 
		spinner spnEndFrame "End" pos:[110,90] width:70 range:[-99999,99999,100] type:#integer enabled:false
		spinner spnValue "Projection at time" pos:[25,112] range:[-99999,99999,0] type:#integer enabled:false
		button btnGenerate "Generate Key" pos:[10,150] width:180 height:25 enabled:false
		
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
			if isvalidNode _p do delete _P
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
		--@fn: undefined | updatePointPos | crea una proyección lineal de la transformación del objeto basada en los parametros.
		--gets node | _obj | el nodo sobre el que se aplicaria la transformacion.
		--gets integer | _start | el frame inicial de la transformacion (como entero)
		--gets integer | _end | el frame final de la transformacion (como entero)
		--gets point3 | _initPos | La posicion inicial del objeto.
		--gets point | _p | El punto de proyección
		--gets integer | _value | el frame hasta el que queremos proyectar la transformación.
		------------------------------------------------		
		fn updatePointPos _obj _start _end _initPos _p _value= 
		(
			_vector = undefined 
			_posI = at time (_start as time) _obj.position
			_posF = at time (_end as time) _obj.position

			_vector = _posF - _posI
			_position = _initPos + (((_value as float)/((_end-_start) as float))*_vector)
			_p.position = _position
		)	
		------------------------------------------------
		--@fn: undefined | getControllerLowTopKeys | Devuelve la primera y ultima keys del objeto.
		--gets controller | _controller | el controlador del cual queremos objtener las keys
		------------------------------------------------
		fn getControllerLowTopKeys _controller =
		(
			_result = #()
			_keys = _controller.keys
			if _keys.count > 0 do 
			(
				if _keys.count == 1 then 
				(
					append _result _keys[1]
					append _result _keys[1]
				)
				else 
				(
					append _result _keys[1] 
					append _result _keys[_keys.count]
				)
			)
			_result
		)
		fn calculatePointRot _obj _start _end _rotI _p _value _createKey= 
		(
			--Conseguir la array de keys, para añadirle una key en el fotograma seleccionado e interpolar la rotacion del canal.
			_rotKeysX =_obj.rotation.controller[1].controller.keys
			_rotKeysY =_obj.rotation.controller[2].controller.keys
			_rotKeysZ =_obj.rotation.controller[3].controller.keys
			
			--averiguar el incremento lineal de rotación para el segmento de tiempo 
			_startRotX = at time (_start as time) _obj.rotation.controller[1].controller.value
			_endRotX = at time (_end as time) _obj.rotation.controller[1].controller.value

			_startRotY = at time (_start as time) _obj.rotation.controller[2].controller.value
			_endRotY = at time (_end as time) _obj.rotation.controller[2].controller.value

			_startRotZ = at time (_start as time) _obj.rotation.controller[3].controller.value
			_endRotZ = at time (_end as time) _obj.rotation.controller[3].controller.value	

			_diffRotX = _endRotX - _startRotX
			_rotationX = _rotI.x + (((_value as float)/((_end-_start) as float))*_diffRotX)
			_diffRotY = _endRotY - _startRotY
			_rotationY = _rotI.y + (((_value as float)/((_end-_start) as float))*_diffRotY)
			_diffRotZ = _endRotZ - _startRotZ
			_rotationZ = _rotI.z + (((_value as float)/((_end-_start) as float))*_diffRotZ)

			if _createKey do 
			(
				addNewKey _obj.rotation.controller (_value as time)

				_rotKeysX =_obj.rotation.controller[1].controller.keys
				_rotKeysY =_obj.rotation.controller[2].controller.keys
				_rotKeysZ =_obj.rotation.controller[3].controller.keys

				for _key in _rotKeysX do 
				(
					if _key.time == _value as time do 
					(
						_key.value = _rotationX
					)
				)
				for _key in _rotKeysY do 
				(
					if _key.time == _value as time do 
					(
						_key.value = _rotationY
					)
				)
				for _key in _rotKeysZ do 
				(
					if _key.time == _value as time do 
					(
						_key.value = _rotationZ
					)
				)
			)
			_rot = eulerAngles -_rotationX -_rotationY -_rotationZ

			_p.rotation = _rot

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

		------------------------------------------------
		--@event: picked | Evento que se lanza al seleccionar un objeto (despues de pulsar el boton.)
		--@control: pickbutton | pbtnElement | El elemento que dispara el evento
		------------------------------------------------
		on pbtnElement picked obj do 
		(
			if obj != undefined then 
			(
				_obj = obj
				pbtnElement.text = obj.name
				chbEnable.enabled = true
				btnGenerate.enabled = true
			)
		)	

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor del spinner
		--@control: spinner | spnValue | El elemento que dispara el evento
		------------------------------------------------
		on spnValue changed value do
		(
			calculatePointRot _obj spnInitFrame.value spnEndFrame.value _initRot _p spnValue.value false 
			updatePointPos _obj spnInitFrame.value spnEndFrame.value _initPos _p spnValue.value 
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor del spinner
		--@control: spinner | spnInitFrame | El elemento que dispara el evento
		------------------------------------------------
		on spnInitFrame changed value do
		(
			calculatePointRot _obj spnInitFrame.value spnEndFrame.value _initRot _p spnValue.value false
			updatePointPos _obj spnInitFrame.value spnEndFrame.value _initPos _p spnValue.value 
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor del spinner
		--@control: spinner | spnEndFrame | El elemento que dispara el evento
		------------------------------------------------
		on spnEndFrame changed value do
		(
			calculatePointRot _obj spnInitFrame.value spnEndFrame.value _initRot _p spnValue.value false
			updatePointPos _obj spnInitFrame.value spnEndFrame.value _initPos _p spnValue.value 
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del boton
		--@control: checkbutton | chbEnable | El elemento que dispara el evento
		------------------------------------------------
		on chbEnable changed state do 
		(
			if state == true then 
			(
				if _obj != undefined then 
				(
					--Init vars
					_keys = getControllerLowTopKeys _obj.position.controller
					if _keys[1] != undefined do spnInitFrame.value = _keys[1].time as integer / TicksPerFrame 
					if _keys[2] != undefined do spnEndFrame.value = _keys[2].time as integer / TicksPerFrame
					spnInitFrame.enabled = true
					spnEndFrame.enabled = true
					spnValue.enabled = true
					--Process
					_p = point()
					_p.box = true
					_p.transform = _obj.transform
					_p.position = _obj.position
					_initPos = _obj.position
					_initRot = _obj.rotation as eulerAngles

					calculatePointRot _obj spnInitFrame.value spnEndFrame.value _initRot _p spnValue.value false
					updatePointPos _obj spnInitFrame.value spnEndFrame.value _initPos _p spnValue.value
				)
			)
			else 
			(
				if isvalidNode _p do delete _P
				_obj = undefined
				_p = undefined 
				_vector = undefined
				_initPos = undefined 
				_initRot = undefined 
				pbtnElement.text = "Pick element"
				spnInitFrame.enabled = false
				spnEndFrame.enabled = false
				spnValue.enabled = false
				btnGenerate.enabled = false
				chbEnable.enabled = false
				

			)
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnGenerate | El elemento que dispara el evento
		------------------------------------------------	
		on btnGenerate pressed do 
		(
			calculatePointRot _obj spnInitFrame.value spnEndFrame.value _initRot _p spnValue.value true
			updatePointPos _obj spnInitFrame.value spnEndFrame.value _initPos _p spnValue.value 
			with animate on 
			(
				at time (spnValue.value as time) _obj.rotation = _p.rotation
				at time (spnValue.value as time) _obj.position = _p.position
			)

			--Reset Tool
			btnGenerate.enabled = false
			spnInitFrame.enabled = false
			spnEndFrame.enabled = false
			spnValue.enabled = false
			chbEnable.checked = false
			chbEnable.enabled = false
			_obj = undefined 
			_vector = undefined
			_initPos = undefined 
			pbtnElement.text = "Pick element"
			if isvalidNode _p do delete _P
			_p = undefined 
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta TrajectoryProjection.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_trajectoryProjection
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool TrajectoryProjection",		--@var: description | Descripcion de la tool.
		
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
	
	tl_trajectoryProjection() --crea la herramienta
)