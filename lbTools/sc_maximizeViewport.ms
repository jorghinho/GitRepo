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
			( -- si hay m�s de un viewport maximizamos
				maximized = false -- bandera para indicar si hemos maximizado alg�n viewport
				currentViewport = viewport.activeViewport -- guardar el viewport activo actual
				
				-- Recorrer todos los viewports
				for i=1 to viewport.numviews do 
				(
					-- Activar el viewport y calcular la posici�n del rat�n con respecto al viewport activo
					viewport.activeViewport = i
					viewX = mouse.pos[1]
					viewY = mouse.pos[2]
					viewW = (getViewSize())[1]
					viewH = (getViewSize())[2]
					
					-- Comprobar si la posici�n del rat�n se encuentra dentro de las coordenadas del viewport activo
					if viewX >= 0 and viewY >= 0 and viewX <= viewW and viewY <= viewH do 
					(
						max tool maximize
						maximized = true
						exit
					)
				)
				
				-- Si no se ha maximizado ning�n viewport ser� porque el rat�n est� colocado en los separadores de viewports o en otros elementos de la interfaz
				-- en tal caso, restauramos el viewport activo originalmente
				if not maximized do viewport.activeViewport = currentViewport
			) 
			else 
			( -- si s�lo hay un viewport restauramos el layout previo
				max tool maximize
			)
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
	)--sc_maximizeViewport
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_maximizeViewport() --crea el script
)