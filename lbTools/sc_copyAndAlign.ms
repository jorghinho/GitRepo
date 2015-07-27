------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Script Para realizar multiples copias de un objeto, alinearlas a las referencias seleccionadas y linkarlas.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: sc_copyAndAlign | Contiene el struct del script copyAndAlign.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_copyAndAlign
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: name | category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: string | className | Nombre del script.
		description = "Script copyAndAlign",	--@var: string | description | Descripcion del script.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		_nodesAndDependent = #(),

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		fn copyandAlign =
		(
			_selection = getCurrentSelection()
			if _selection.count > 1 then 
			(
				for i = 2 to _selection.count do 
				(		
					maxOps.CloneNodes _selection[1] expandHierarchy:on cloneType:#instance actualNodeList:&anl newNodes:&nnl
				 	nnl[1].transform = _selection[i].transform
					nnl[1].parent = _selection[i]
				)
			)
			else lb.message.show "Select at least 2 objects to operate this script."
		),
			

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
			copyandAlign()
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
		
	)--sc_templateScript
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_copyAndAlign() --crea el script
)