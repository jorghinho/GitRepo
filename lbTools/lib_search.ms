------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de search
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de search.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_search
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria Search",	--@var: description | Descripcion de la libreria.
		
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

		---------------------------------------------------------------------------
		--busca una definicion de funcion en un string y devuelve el nombre
		---------------------------------------------------------------------------
		fn getFunctionFromString str =
		(
			funct = undefined
			
			if classof str == String then
			(
				stringParts = filterString str " \t"
				
				if stringParts.count > 2 then
					for i=1 to (stringParts.count - 1) do
						if stringParts[i] == "fn" then
							funct = stringParts[i+1]			
			)
			
			funct
		),

		---------------------------------------------------------------------------
		--obtiene las funciones definidas en un fichero
		---------------------------------------------------------------------------
		fn getFunctionsFromFile file =
		(
			functions = #()
			pause = false	--flag para parar cuando ha encontrado un bloque de comentarios
			ignore = false	--flag para ignorar una linea si esta comentada
			
			fStream = openFile file mode:"r" --abre el fichero para lectura
			
			if fStream != undefined then
				while not eof fStream do --recorre el fichero
				(
					newLine = readLine fStream
					funct = undefined --variable donde almacenar la funcion que pueda haber en la linea
					
					if not pause then
					(
						if findString newLine "/*" != undefined then
						(
							pause = true
							newLine = substituteString newLine "/*" "?"
							
							newLine = (filterString newLine "?")[1]
						)
						
						funct = getFunctionFromString newLine
					)	
					else
					(
						if findString newLine "*/" != undefined then
						(
							pause = false
							newLine = substituteString newLine "*/" "?"
							
							newLine = (filterString newLine "?")[2]
							
							funct = getFunctionFromString newLine
						)
					)
					
					if funct != undefined then
						appendIfUnique functions funct
						
				)
			
			functions
		),

		---------------------------------------------------------------------------
		--devuelve el nombre de un fichero ms a partir de su (ruta + nombre.ms)
		---------------------------------------------------------------------------
		fn getMSfileName file =
		(
			fileName = ""
			
			if classof file == String then
			(
				fileName = (filterString file "\\")[(filterString file "\\").count]
								
				if findString fileName ".ms" != undefined then
					fileName = substituteString fileName ".ms" ""
			)
			
			fileName
		),

		---------------------------------------------------------------------------
		--devuelve un string con las funciones de un fichero puestas en formato de globales
		---------------------------------------------------------------------------
		fn getFormatedFunctionsFromFile file =
		(
			formatedString = "\n"
			functs = #()
			fileName = ""
			
			if classof file == String then
			(
				functs = getFunctionsFromFile file
				
				fileName = substituteString (getMSfileName file) "lbTools_" ""
				
				formatedString += "-------------------------------------------\n--"
				formatedString += (filename + "\n-------------------------------------------\n")
			)
			
			if functs.count != 0 then
			(
				for fun in functs do
					formatedString += "global " + fun + "\n"
					
				formatedString += ("\nglobal LB_FNs_" + filename + " = #(")
				
				for i=1 to functs.count do
					formatedString += "#" + functs[i] + (if i < functs.count then "," else "")
				
				formatedString += ")\n-------------------------------------------\n\n"
			)
			
			formatedString
		),

		---------------------------------------------------------------------------
		--devuelve todos los ficheros de una carpeta y sus subcarpetas
		---------------------------------------------------------------------------
		fn getFilesRecursive folder fileType =
		(
			folders = getDirectories (folder + "\\*")
			
			for d in folders do
				join folders (getDirectories (d + "\\*"))
			 
			files = (getFiles (folder + fileType))
			
			for f in folders do
				join files (getFiles (f + fileType))
			
			files 
		),

		---------------------------------------------------------------------------
		--compara dos nombres de fichero
		---------------------------------------------------------------------------
		fn compareFileNames n1 n2 =
		(
			auxFiles = sort #((tolower (getMSfileName(n1))), (tolower (getMSfileName(n2))))
				
			if auxFiles[1] == (tolower (getMSfileName(n1))) then
				-1
			else
				1
		),

		---------------------------------------------------------------------------
		--devuelve un string con todas las funciones de todos los ficheros de una carpeta en formato de globales
		---------------------------------------------------------------------------
		fn getFormatedFunctionsFromFolder folder =
		(	
			formatedString = "\n"
			
			if classof folder == String then
			(
				files = getFilesRecursive folder "*.ms"
				qsort files compareFileNames
				
				for f in files do
					formatedString += (getFormatedFunctionsFromFile f)
			)
			
			formatedString
		),
			
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
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
	)--lib_search
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_search() --crea la libreria
)