------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script stereoCamCreator.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script stereoCamCreator.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_stereoCamCreator
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Stereo Cam Creator",	--@var: description | Descripcion del script.
		
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
			if cameras.count != 0 then
			(	
				_cameraR = undefined
				for o in cameras where matchpattern o.name pattern:"*_R" do _cameraR = o 
					
				_process = true
				if _cameraR != undefined then _process = queryBox "camera R found in scene. Do you want to overwrite it ? If you choose [No] the camera won't be created."		
				
				if _process then
				(
					if _cameraR != undefined then delete _cameraR
					_camsToCopy = for c in cameras where (superclassof c == camera and findString c.name "_R" == undefined) collect c
					maxOps.CloneNodes #(_camsToCopy[1]) expandHierarchy:false cloneType:#copy newNodes:&_newNodes
					_newNodes[1].name = _camsToCopy[1].name + "_R"
					for m in _newNodes[1].modifiers where classof m == Transform_Cache do deleteModifier _newNodes[1] m
					sliderTime = animationRange.start
					_newNodes[1].parent = _camsToCopy[1]
					deleteKeys _newNodes[1].transform.controller
					setTransformLockFlags 	_newNodes[1] #{}
					if classof _camsTocopy[1] == targetCamera then _newNodes[1].target.parent = _camsToCopy[1]
				)
			)
			else 
			(
				messageBox "No hay camaras en la escena."
			)
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
		
	)--sc_stereoCamCreator
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_stereoCamCreator() --crea el script
)