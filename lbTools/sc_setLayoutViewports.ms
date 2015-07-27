------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script setLayoutViewports.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: setLayoutViewports | Contiene el struct del script setLayoutViewports.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_setLayoutViewports
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Set Layout Viewports",	--@var: description | Descripcion del script.
		
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
			-- 2 paneles en vertical
			viewport.setLayout #layout_2v
			-- Si hay cámaras en la escena activar en el panel izquierdo la primera de todas
			if cameras.count > 0 do
			(
				-- Obtener el listado de cámaras ordenado por nombre
				all_cams = sort(for cam in cameras where (findString cam.name ".Target") == undefined collect cam.name)
				
				-- En el primer panel activar la primera cámara, mostrar los safe frames y poner en modo shaded
				viewport.activeViewport = 1
				viewport.setCamera (getnodebyname all_cams[1])
				displaySafeFrames = true -- activar los safe frames
				viewport.SetRenderLevel #smoothhighlights
				
				-- En el segundo panel activamos la perspectiva y el modo shaded
				viewport.activeViewport = 2
				viewport.setType #view_persp_user
				viewport.SetRenderLevel #smoothhighlights
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
		
	)--sc_setLayoutViewports
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_setLayoutViewports() --crea el script
)