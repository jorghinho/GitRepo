------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Librería de funciones de expresiones regulares
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: re | Contiene la libreria de funciones de expresiones regulares.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_re
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de expresiones regulares",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------		
		re = dotnetObject "System.Text.RegularExpressions.Regex" "",
		
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
		--@fn: mixed | match | Ejecuta una expresión regular contra una cadena
		--@gets: string |str | Cadena sobre la que aplicar la expresión regular
		--@gets: string |pattern | Patrón de expresión regular
		--@returns: dotNetObject:System.Text.RegularExpressions.Match | http://msdn.microsoft.com/en-us/library/vstudio/system.text.regularexpressions.match
		------------------------------------------------
		fn matchObj str pattern = 
		(
			return (this.re.Match str pattern)
		),

		------------------------------------------------
		--devuelve las coincidencias multiples del patron en el string
		------------------------------------------------
		fn matchesObjs str pattern = 
		(
			return (this.re.Matches str pattern)
		),

		------------------------------------------------
		--@fn: mixed | match | Ejecuta una expresión regular contra una cadena
		--@gets: string |str | Cadena sobre la que aplicar la expresión regular
		--@gets: string |pattern | Patrón de expresión regular
		--@returns: mixed | Si la expresión regular no concuerda devuelve false. Si concuerda y hay grupos devuelve un array con los grupos encontrados. Si concuerda y no hay grupos devuelve la cadena coincidente.
		------------------------------------------------
		fn match str pattern = 
		(
			result = false

			m = matchObj str pattern
			if m.Success do
			(
				nGroups =  m.Groups.Count
				if nGroups >= 1 and nGroups <= 2 then
					result = (m.Groups.Item(nGroups-1)).Value
				else if nGroups > 2 then
					result = for i=1 to nGroups-1 collect (m.Groups.Item(i)).Value
			)
			
			return result
		),

		------------------------------------------------
		--devuelve las coincidencias multiples del patron en el string
		------------------------------------------------
		fn matches str pattern = 
		(
			_matches = #()
			_matchesCollection = this.matchesObjs str pattern
			
			_matches = for i=1 to _matchesCollection.count collect _matchesCollection.item[(i-1)].value

			_matches
		),

		------------------------------------------------
		--@fn: string | replaceInPattern | Reemplaza en un patrón, los grupos por valores
		--@gets: string | pattern | Patrón en el que reemplazar los grupos
		--@gets: System.Collections.Hashtable | replaces | Hashtable Clave-Valor donde Clave es el nombre del grupo a reemplazar y el Valor el string con el que reemplazarlo
		--@returns: string | Devuelve el patrón con los grupos reemplazados.
		------------------------------------------------
		fn replaceGroupsInPattern pattern replaces =
		(
			result = pattern
			enum = replaces.getEnumerator()
			while enum.moveNext() do
			(
				result = this.re.Replace result ("\\(\\?'" + enum.key + "'.*?\\)") replaces.Item[enum.key]
			)

			return result
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
		
	)--lib_video
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_re()
)