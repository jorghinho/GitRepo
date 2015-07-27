------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de string
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: str | Contiene todas las funciones de la plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_str
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de funciones de string",	--@var: description | Descripcion de la libreria.
		
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
		--@fn: string | removeSpaces | Devuelve un string con los espacios eliminados. Se toman como espacios los espacios como tal y los tabuladores.
		--@gets: string | theString | String que procesar para quitarle los espacios.
		--@opt: boolean | onlyInitial | false | Indica si solo se quieren eliminar los espacios que haya al principio del string.
		------------------------------------------------
		fn removeSpaces theString onlyInitial:false onlyFinal:false =
		(
			_defString = theString
			_stop = false
			_i = 1
			_limit = _defString.count
			
			if onlyFinal then
			(	
				while _defString[_defString.count] == " " or _defString[_defString.count] == "	" do _defString = (subString _defString 1 (_defString.count - 1))
			)
			else
			(
				for i=1 to _limit where not _stop do
				(
					if _defString[_i] == " " or _defString[_i] == "	" then
					(
						_defString = (subString _defString 1 (_i-1)) + (subString _defString (_i + 1) (_limit - (_i-1)))
						_i -=1
						_limit -=1
					)--if
					else if onlyInitial then _stop = true
						
					_i += 1
				)--for
			)
			
			_defString
		),
		
		------------------------------------------------
		--@fn: string | reverse | Invierte un string dado
		--@gets: string | theString | String a invertir.
		------------------------------------------------
		fn reverse theString =
		(
			_result = ""
			if theString != undefined then
				for i=theString.count to 1 by -1 do _result += theString[i]
			_result
		),

		
		------------------------------------------------
		--@fn: string | split | Trocea un string 
		--@gets: string | theString | String a trocear.
		--@gets: string | theSplitter | String a usar como divisor
		--@returns: array de strings
		------------------------------------------------
		fn split theString theSplitter =
		(
			filterString theString theSplitter
		),

		------------------------------------------------
		--@fn: string | join | Une un array de strings
		--@gets: string | theStringArray | Array de strings a unir.
		--@gets: string | theJoiner | String a usar como enlace
		--@returns: array
		------------------------------------------------
		fn join theStringArray theJoiner =
		(
			if theStringArray.count == 1 then
				return theStringArray[1]
			else if theStringArray.count == 0 then
				return ""
			else
			(
				newStringArray = for i=2 to theStringArray.count collect theStringArray[i]
				newStringArray[1] = theStringArray[1] + theJoiner + newStringArray[1]
				return join newStringArray theJoiner
			)
		),

		------------------------------------------------
		--@fn: boolean | endsWith | Comprueba si una cadena termina en otra
		--@gets: string | mainString | Cadena principal
		--@gets: string | finalString | Cadena a buscar
		--@returns: array
		------------------------------------------------
		fn endsWith mainString finalString =
		(
			return (substring mainString (mainString.count-finalString.count+1) -1) == finalString
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
		
	)--lib_str
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
 	
	lib_str() --crea la libreria 	
)