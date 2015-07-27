------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script createAndLinkPointFromObject.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script createAndLinkPointFromObject.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_createAndLinkPointFromObject
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Create And Link Point From Object",	--@var: description | Descripcion del script.
		
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
			pointsToSelect = #()
			
			for o in selection do
			(
				-- Creamos variable del point nuevo, creamos point en objeto/s y freezeamos point
				newPoint = undefined
				newPoint = lb.rig.createPointFromObj o crossOp:off
				lb.controller.freezeTransform newPoint #all
			
				-- Comprobamos si los objetos seleccionados están freezeados o no y linkamos dependiendo de su estado.
				if (lb.controller.isTransformFrozen o #all) then
				(
					lb.controller.setActiveController o #all #frozen
					o.parent = newPoint
					lb.controller.setActiveController o #all #zero
				)
				else
					o.parent = newPoint
					
				-- Tamaño del point a 15 y color del point en verde
				newPoint.size = 15
				newPoint.wirecolor = color 0 252 0 
				append pointsToSelect newPoint
			)
			select pointsToSelect
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
		
	)--sc_createAndLinkPointFromObject
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_createAndLinkPointFromObject() --crea el script
)