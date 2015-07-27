------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: animTracksKeyBakerScript | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_animTracksKeyBakerScript
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Script plantilla",	--@var: description | Descripcion del script.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
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
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(
			setWaitCursor()

			_currSel = getCurrentSelection()

			_animTracksNodes = #()
			_animTracksControllers = #()
			_animTracksValues = #()

			for o in _currSel where lb.animInfo.hasAnimTracks o do
			(
				_atracks = lb.animInfo.getAnimTracks o

				append _animTracksNodes o

				_controllers = #()
				_values = #()

				for _track in _atracks where _track.type == #track do
				(
					_controller = _track.track.controller
					append _controllers _controller

					_valsPerFrame = #()
					_time = animationRange.start
					_limit = ((substring ((animationRange.end - animationRange.start) as string) 1 (((animationRange.end - animationRange.start) as string).count - 1)) as integer) + 1
					for i=1 to _limit do
					(
						append _valsPerFrame (at time _time _controller.value)
						_time += 1
					)

					append _values _valsPerFrame
				)--for

				append _animTracksControllers _controllers
				append _animTracksValues _values
			)--for

			for i=1 to _animTracksNodes.count do
			(
				_obj = _animTracksNodes[i]

				for j=1 to _animTracksControllers[i].count do
				(
					_controller = _animTracksControllers[i][j]

					if _controller.keys.count > 0 then
					(
						setBeforeORT _controller #constant
						setAfterORT _controller #constant
					)

					with animate on
					(
						_cont = 1
						_time = animationRange.start
						_limit = ((substring ((animationRange.end - animationRange.start) as string) 1 (((animationRange.end - animationRange.start) as string).count - 1)) as integer) + 1
						for k=1 to _limit do
						(
							at time _time
							(
								_controller.value = _animTracksValues[i][j][k]
							)
							_cont += 1
							_time += 1
						)
					)--with
				)--for
			)--for

			setArrowCursor()
			lb.message.show "All anim track controllers baked successfully."
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
			lb.addScript this --añade el script a la libreria principal
		)
		
	)--sc_animTracksKeyBakerScript
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_animTracksKeyBakerScript() --crea el script
)