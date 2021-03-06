------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta layoutDraftToBlocking.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta layoutDraftToBlocking.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Draft to blocking"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 140		--@var: minRollWidth | Ancho m�nimo de la herramienta.
		local minRollHeight = 220		--@var: minRollHeight | Alto m�nimo de la herramienta.


		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local currentFrame = currenttime.frame as integer
		local gapBetweenCams = 100		--@var: gapBetweenCams | Espacio en frames a dejar entre c�maras
		local defaultCamDuration = 100	--@var: defaultCamDuration | Duraci�n en frames de una c�mara est�ndard	
		local firstCameraStart = 300
		local cameraPrefix = "cam_"
		local cameraNumberIncrement = 10

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		label labSourceCamera "From camera:" pos:[10,10]
		dropdownlist ddlSourceCamera "" items:(for c in cameras collect c.name) width:120 pos:[10,25]
		label labToCamera "To camera: " pos:[10,55]
		label labCamera "" pos:[10,70] width:130
		spinner spnDuration "Duration:" range:[10,1000,100] type:#integer pos:[12,100]
		spinner spnStart "Start:" range:[0,99999,currentFrame] type:#integer pos:[12,130]
		spinner spnEnd "End:" range:[0,99999,currentFrame] type:#integer pos:[18,150]
		button btnCreate "Create camera" width:130 height:30 pos:[5,180]
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		fn createCam name:undefined range:undefined sourceCam:undefined recStart:undefined recEnd:undefined =
		(
			nKeys = range[2]-range[1]
			increment = if nKeys != 0 then (recEnd-recStart)/nKeys else 0
			counter = 0

			-- Crear c�mara 
			_newCam = freeCamera()

			-- Asignar info a la c�mara y dar rango
			lb.cameraFunctions.addCamInfo _newCam
			_newCam.recStart = recStart
			_newCam.recEnd = recEnd
			_newCam.name = name
			
			with animate off _newCam.fov = at time range[1] sourceCam.fov	
			
			for t=range[1] to range[2] do
			(
				-- Dar key a todo lo seleccionado
				max set key keys

				nextKeyAt = if t == range[2] then recEnd else recStart + (counter * increment)
				
				-- Deseleccionar todas las keys y seleccionar s�lo las del frame siguiente
		 		deselectkeys selection
		 		selectKeys selection (interval t t)
				
				-- Mover todas las keys del frame. El desplazamiento es relativo as� que lo obtenemos restando a la siguiente key absoluta la clave actual que vamos a mover
		 		moveKeys selection (nextKeyAt-t) #selection

				-- Copiar animaci�n de la c�mara draft a la nueva c�mara
				with animate on at time nextKeyAt _newCam.transform = at time t sourceCam.transform
				
				counter += 1
			)

			-- Borrar clave de la c�mara en el frame cero (1 = primera clave) que se crea autom�ticamente al haber usado el autokey 
			deleteKey _newCam.controller[1].controller 1
			deleteKey _newCam.controller[2].controller 1
			deleteKey _newCam.controller[3].controller 1
		)


		--------------------------------------------------------------------------------------
		--	Devuelve true o false dependiendo de si el nombre pasado en CAMNAME
		--	cumple el naming convention de las c�maras
		--------------------------------------------------------------------------------------
		fn isCamNameNCOK camName = 
		(
			_parts = filterstring camName "_"
			if (_parts.count == 2) and (_parts[1] == "cam") and (classOf (_parts[2] as integer) == integer) then true else false
		)


		--------------------------------------------------------------------------------------
		--	Devuelve la centena m�s cerca por arriba al n�mero N dado
		--  Ej: n=7 --> 100, n=205 --> 300, n=397 --> 400
		--------------------------------------------------------------------------------------
		fn hundredRound n =
		(
			((n/100)*100) + 100
		)

		--------------------------------------------------------------------------------------
		--	Devuelve el nuevo nombre que le corresponder�a a una c�mara creada en el frame FRAME
		--------------------------------------------------------------------------------------
		fn getNewCamName = 
		(
			struct camInfo (name, start)

			maxRecEnd = -9999
			lastCam = newCam = undefined
			
			for c in cameras where (isProperty c #recEnd) do
			(
				if c.recEnd > maxRecEnd do (
					lastCam = c
					maxRecEnd = c.recEnd
				)
			)

			if lastCam != undefined then
			(
				if isCamNameNCOK lastCam.name then
				(
					lastCamNumber = (filterString lastCam.name "_")[2] as integer
					newCamNumber = lastCamNumber + rollMainDef.cameraNumberIncrement
				) else
				(
					newCamNumber = 10
				)
				newCam = camInfo name:(rollMainDef.cameraPrefix+(formattedprint newCamNumber format:"03d")) start:(hundredRound(lastCam.recEnd)+rollMainDef.gapBetweenCams)
			) else
			(
				newCam = camInfo name:(rollMainDef.cameraPrefix+"010") start:rollMainDef.firstCameraStart
			)

			return newCam
		)


		fn updateNextCam nextCam:undefined =
		(
			rollMainDef.labCamera.text = nextCam.name + " at " + nextCam.start as string + "f"
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
		--@gets: point2 | size | Tama�o nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona m�s peque�a que el m�nimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al m�nimo.
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
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuraci�n de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tama�o
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuraci�n de la misma.
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
		on spnStart changed val do 
		(
			if spnStart.value > spnEnd.value do spnStart.value = spnEnd.value
			if spnStart.value <= spnEnd.value - 1 then
				animationrange = (interval spnStart.value spnEnd.value)
			else if spnStart.value == spnEnd.value do
				animationrange = (interval spnStart.value (spnStart.value+1))
			sliderTime = spnStart.value
		)

		on spnEnd changed val do 
		(
			if spnEnd.value < spnStart.value do spnEnd.value = spnStart.value
			if spnEnd.value >= spnStart.value + 1 do animationrange = (interval spnStart.value spnEnd.value)
			sliderTime = spnEnd.value
		)

		on btnCreate pressed do
		(
			sourceCam =  getNodeByName ddlSourceCamera.selected
			frameRange = #(spnStart.value, spnEnd.value)
			nextCam = getNewCamName()

			-- Deshabilitar repintado para no realentizar la selecci�n de keys
			disableSceneRedraw()


			undo "Create blocking camera" on
			(
				max select all
				deselect cameras
	
				createCam name:nextCam.name range:frameRange sourceCam:sourceCam recStart:nextCam.start recEnd:(nextCam.start+spnDuration.value)
	
				max select none
			)


			-- Reactivar y volver a pintar la UI
			enableSceneRedraw()
			completeRedraw()

			spnStart.value = spnEnd.value = spnEnd.value + 1
			animationrange = (interval spnStart.value (spnStart.value+1))
			sliderTime = spnStart.value

			-- Obtener nombre y rango de la siguiente c�mara a crear
			rollMainDef.updateNextCam nextCam:(getNewCamName())
		)		

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensi�n. El rollout principal de la herramienta.
		--@gets: point2 | size | tama�o al que se ha redimensionado el rollout
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

			-- Actualizar rango de animaci�n al frame activo
			animationrange = (interval currentFrame (currentFrame+1))

			-- Calcular rangos de la siguiente c�mara
			rollMainDef.updateNextCam nextCam:(getNewCamName())
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta est� cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: focusPuller | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_focusPuller
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Focus Puller",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
		
		opened = false,			--@var: opened | Indica si la herramienta est� abierta.
			
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
		--@fn: boolean | isOpen | Devuelve informaci�n true o false, si la herramienta est� abierta o cerrada.
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
			this.opened = true --indica que la herramienta est� abierta
		),--execute
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
		------------------------------------------------
		fn close =
		(
			this.destroyInterface() --destruye el interface.
			this.opened = false --indica que la herramienta est� cerrada.
		),
		
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrer�as en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librer�a.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librer�as hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecuci�n al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addTool this --a�ade la tool a la libreria principal	
		)		
		
	)--tl_focusPuller
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_focusPuller() --crea la herramienta
)