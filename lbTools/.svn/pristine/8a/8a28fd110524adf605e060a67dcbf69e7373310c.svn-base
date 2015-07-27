------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de plantilla
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: time | Contiene la libreria de plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_time
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria plantilla",	--@var: description | Descripcion de la libreria.
		
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
		--@fn: string | getCurrentTimeId | Devuelve el identificador unico basado en la fecha y la hora actual como un string de numeros.
		------------------------------------------------
		fn getCurrentTimeId =
		(
			_time = getLocalTime()
			_id = (_time[1] as string) + (formattedPrint _time[2] format:"02d") + (formattedPrint _time[4] format:"02d") + (formattedPrint _time[5] format:"02d")
			_id += (formattedPrint _time[6] format:"02d") + (formattedPrint _time[7] format:"02d") + (formattedPrint _time[8] format:"03d")
			
			_id
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		fn systemToLocalTime mytime = 
		(
			if (filterString mytime " ").count == 3 then
			(
				mytime = (filterString mytime " ")[1] + " " + (filterString mytime " ")[2]
				if (filterString mytime " ")[3] == "PM" and ((filterString (filterString mytime " ")[2] ":")[1] As Number) != 12 then
				(
					mytime = substituteString mytime " 12:" (" "+((((filterString (filterString mytime " ")[2] ":")[1] As Number) + 12) As String) + ":")
				)
			)
			mytime
		),


		------------------------------------------------
		--COMMON
		------------------------------------------------
			
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
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_time
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_time() --crea la libreria
)