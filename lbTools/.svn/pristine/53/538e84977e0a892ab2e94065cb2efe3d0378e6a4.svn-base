------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script maximize Viewport.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: maximizeViewport | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_maximizeViewport
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Maximize Viewport",	--@var: description | Descripcion del script.
		
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
			if viewport.numViews > 1 then 
			( -- si hay más de un viewport maximizamos
				maximized = false -- bandera para indicar si hemos maximizado algún viewport
				currentViewport = viewport.activeViewport -- guardar el viewport activo actual
				
				-- Recorrer todos los viewports
				for i=1 to viewport.numviews do 
				(
					-- Activar el viewport y calcular la posición del ratón con respecto al viewport activo
					viewport.activeViewport = i
					viewX = mouse.pos[1]
					viewY = mouse.pos[2]
					viewW = (getViewSize())[1]
					viewH = (getViewSize())[2]
					
					-- Comprobar si la posición del ratón se encuentra dentro de las coordenadas del viewport activo
					if viewX >= 0 and viewY >= 0 and viewX <= viewW and viewY <= viewH do 
					(
						max tool maximize
						maximized = true
						exit
					)
				)
				
				-- Si no se ha maximizado ningún viewport será porque el ratón está colocado en los separadores de viewports o en otros elementos de la interfaz
				-- en tal caso, restauramos el viewport activo originalmente
				if not maximized do viewport.activeViewport = currentViewport
			) 
			else 
			( -- si sólo hay un viewport restauramos el layout previo
				max tool maximize
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
	)--sc_maximizeViewport
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_maximizeViewport() --crea el script
)