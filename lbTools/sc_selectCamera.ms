------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script selectCamera.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: selectCamera | Contiene el struct del script selectCamera.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_selectCamera
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Select Camera",	--@var: description | Descripcion del script.
		
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
			-- Avisar si el framerate es incorrecto
			if framerate != 24 do messageBox  ("El framerate actual (" + (framerate as string) + "fps) no es correcto.") title:"Warning!"

			for i=1 to viewport.numViews do (
				cam = viewport.getCamera index:i
				if cam != undefined do (
					select cam
					hideByCategory.cameras = false
					exit
				)
			)
			toolMode.coordsys #gimbal
			--max zoomext sel all
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
			lb.addScript this --a�ade el script a la libreria principal
		)
		
	)--sc_selectCamera
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_selectCamera() --crea el script
)