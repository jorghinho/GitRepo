------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script makePreview.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: makePreview | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_makePreview
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Make Preview",		--@var: description | Descripcion del script.

		cfgFile = (lb.config.getToolsIniPath()) + "makePreviewSettings.cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
		
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
		--@fn: undefined | run | Lanza la herramienta.
		------------------------------------------------
		fn run =
		(
			--propiedades específicas de la tool
			_percent = (lb.xml.getAttribute this.cfgFile ("rollMain/settings") "percent")
			_style = (lb.xml.getAttribute this.cfgFile ("rollMain/settings") "style")
			_quality = (lb.xml.getAttribute this.cfgFile ("rollMain/settings") "quality")
 
			if _percent != "" then
				_percent = (substituteString _percent "%" "") as integer
			else
				_percent = 100

			if _style != "" then
				_style = execute ("#"+_style)
			else 
				_style = undefined

			if _quality != "" then
			(
				n = finditem lb.preview.qualities _quality
				_quality = 2^(n+1)
			)
			else 
				_quality = undefined



			cam = getActiveCamera()
			if cam != undefined then
				lb.preview.makePreview cam:cam percent:_percent style:_style quality:_quality openWhenFinished:true
			else
				lb.preview.makePreview percent:_percent style:_style quality:_quality openWhenFinished:true
		),--execute
		
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
			lb.addScript this --añade la tool a la libreria principal	
		)		
		
	)--sc_makePreview
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_makePreview() --crea el script
)