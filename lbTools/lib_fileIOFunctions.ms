------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de fileIOFunctions
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: fileIOFunctions | Contiene la libreria de fileIOFunctions.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_fileIOFunctions
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria file IO Functions",	--@var: description | Descripcion de la libreria.
		
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

		---------------------------------------------------------------------------
		--abre y cierra ficheros max pasados por parametro
		--antes de cerrarlos los vuelve a guardar
		---------------------------------------------------------------------------
		fn resaveMaxFile maxFile =
		(
			local success = false
			
			if (loadMaxFile maxFile useFileUnits:true quiet:true) then
				success = saveMaxFile maxFile quiet:true
			
			success
		),	

		---------------------------------------------------------------------------
		--recorre el directorio pasado por parametro de forma recursiva
		--busca carpetas que se llamen version
		--dentro de las carpetas version llama a la funcion de abrir los ficheros y resalvarlos
		---------------------------------------------------------------------------
		fn resaveMaxFiles folder folderFilter recursive:true=
		(
			local directories = getDirectories (folder + "\\*") --busca los directorios
			local versionDirectories = getDirectories (folder + "\\" + folderFilter) --busca los directorios especificos
			
			local cont = 0 --contador de ficheros  abiertos
			
			for v in versionDirectories do --recorre los directorios especificos
			(
				local maxFiles = getFiles (v + "*.max") --obtiene los .max de las carpetas especificas
				
				for mx in maxFiles do --recorre los .max encontrados y los resalva
				(
					addNotification ("Resaving -> " + mx)
					if resaveMaxFile mx then
						addNotification ("Resaved -> " + mx)
				)
			)
			
			--llamada recursiva para buscar mas directorios dentro de los directorios encontrados
			if recursive then
				for d in directories do
					resaveMaxFiles d folderFilter
		),

		------------------------------------------------
		--@fn: undefined | getAllSubfolders | devuelve los subfolders de ultimo nivel a partir de uno dado, si no hay devuelve un array vacio
		------------------------------------------------
		fn getAllSubfolders folder =
		(	
			_folders = #() --array para almacenar los folders que devolver
			
			if folder != "" then
			(
				append _folders folder --a�ade el propio folder a la lista
				
				_subFolders = getDirectories (folder + "*") --busca los subdirectorios del actual				
				for f in _subFolders where findString f ".svn" == undefined do _folders += getAllSubfolders f --a�ade los subfolders
			)--if
			
			_folders --devuelve los folders
		),--getAllSubfolders

		------------------------------------------------
		--@fn: undefined | getAllFilesFromSubFolders | devuelve los archivos de ultimo nivel a partir de un folder dado buscando en los subfolders, si no hay devuelve un array vacio
		------------------------------------------------
		fn getAllFilesFromSubFolders folder extension:".max" =
		(
			_files = #() --array con los archivos
			
			if (classof folder == String) and (folder != "") then
			(
				_folders = getAllSubfolders folder --obtiene todos los folders
				sort _folders --ordena el array
				--print _folders		
				for f in _folders do --recorre los folders buscando los files
				(
					_pattern = (f + "*" + extension)
					
					_files += getFiles _pattern
				)
			)--if
			
			_files --devuelve los archivos
		),--getAllFilesFromSubFolders


		------------------------------------------------
		--@fn: undefined | doesFolderExist | devuelve un booleano conforme el directorio solicitado existe o no
		--@gets string | f | el path del folder 
		--@gets boolean | create | en el caso de no existir el fichero, se crea el directorio si el parametro esta a true.
		------------------------------------------------
		fn doesFolderExist f create:false =
		(
		 	local val
		 	val = if (doesFileExist f) and (getfileattribute f #directory) then true else false
		 	if not val and create then
		 	(
		 		val = makeDir f
		 	)
		 	val
		 ),

		------------------------------------------------
		--COMMON
		------------------------------------------------
			
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
			lb.addLibrary this --a�ade la libreria a la principal
		)	
	)--lib_fileIOFunctions
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_fileIOFunctions() --crea la libreria
)