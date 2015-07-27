------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de IO
------------------------------------------------------------------------------------------------------------------------------------------------
(		
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: io | Contiene todas las funciones de entrada/salida
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_io
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de input/output",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		allowedImageOutputTypes = #(".avi", ".bmp", ".cin", "eps", ".ps", ".exr", ".fxr", ".hdr", ".pic", ".jpg", ".jpe", ".jpeg", ".png", ".mov", ".rgb", ".rgba", ".sgi", ".int", ".inta", ".bw", ".rla", ".rpf", ".tga", ".vda", ".jcb", ".rst", ".tif", ".tiff", ".dds"), --tipos de extension admitidos como salida de render

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
		--Devuelve el nombre de un archivo a partir de un path completo sin ruta y sin extension.
		--Esta funcion es necesaria debido a que si la ruta lleva puntos se equivoca la funcion original.
		--Necesita un string con el path.
		------------------------------------------------
		fn getFileName fullPath =
		(
			_fileName = substituteString fullPath (getFilenamePath fullPath) ""
			
			_extensionParts = FilterString _fileName "."
			_type = if _extensionParts.count != 0 then "." + _extensionParts[_extensionParts.count] else ""

			if findItem this.allowedImageOutputTypes _type != 0 then _fileName = substituteString _fileName _type ""

			_fileName
		),

		------------------------------------------------
		--Devuelve la extension de un archivo a partir de un path completo sin ruta y sin nombre. Solo la extension.
		--Esta funcion es necesaria debido a que si la ruta lleva puntos se equivoca la funcion original.
		--Necesita un string con el path.
		------------------------------------------------
		fn getFileType fullPath =
		(
			_type = ""
			_fileName = substituteString fullPath (getFilenamePath fullPath) ""
			
			_extensionParts = FilterString _fileName "."
			if _extensionParts.count != 0 then _type = "." + _extensionParts[_extensionParts.count]

			if findItem this.allowedImageOutputTypes _type == 0 then _type = ""

			_type
		),

		------------------------------------------------
		--@fn: array{string} | getSubfolders | Función recursiva que devuelve un array de strings con los subfolders del folder indicado.
		--@gets: string | theFolder | Folder del que obtener sus subfolders de forma recursiva.
		--@opt: array{string} | ignoreList | array vacío | Array con los patrones de folders a ignorar.
		------------------------------------------------
		fn getSubfolders theFolder ignoreList:#() =
		(	
			--LA FUNCIONALIDAD DE IGNORELIST NO ESTA HECHA
			
			_folders = #() --array para almacenar los folders que devolver
			
			if classof theFolder == String and theFolder != "" then
			(
				append _folders theFolder --añade el propio folder
				
				_subFolders = getDirectories (theFolder + "*") --busca los subdirectorios del actual
				
				if _subFolders.count != 0 then --si ha conseguido obtener subcarpetas
				(	
					for f in _subFolders where findString f ".svn" == undefined do --recorre los subfolders
						_folders += this.getSubfolders f --añade los subfolders
				)--if
			)--if
			
			_folders --devuelve los folders
		),		
		
		------------------------------------------------
		--@fn: array{string} | getFilesFromSubFolders | Función recursiva que devuelve un array de strings con los archivos de los subfolders del folder indicado.
		--@gets: string | theFolder | Folder del que obtener sus archivos de forma recursiva.
		--@opt: array{string} | ignoreList | array vacío | Array con los patrones de folders a ignorar.
		--@opt: string | extension | .* | extension de archivos que se quiere obtener, por defecto devuelve todos los tipos.
		------------------------------------------------
		fn getFilesFromSubFolders theFolder ignoreList:#() extension:".*" =
		(
			--LA FUNCIONALIDAD DE IGNORELIST NO ESTA HECHA
			
			_files = #() --array con los archivos
			
			if classof theFolder == String and theFolder != "" then
			(
			   _folders = this.getSubfolders theFolder ignoreList:ignoreList --obtiene todos los folders
			   sort _folders --ordena el array
			   
			   for f in _folders do --recorre los folders buscando los files
				_files += getFiles (f + "*" + extension)
			)--if

			_files --devuelve los archivos
		),

		------------------------------------------------
		--@fn: "string" | getDirName | Devuelve el directorio superior del path pasado por parámetro
		--@gets: string | path | Path.
		------------------------------------------------
		fn getDirName path =
		(
			array = lb.str.split path "\\"
			if array.count > 1 do array = for i=1 to array.count-1 collect array[i]
			return lb.str.join array "\\"
		),

		------------------------------------------------
		--@fn: "string" | getBaseName | Devuelve el fichero del path pasado por parámetro
		--@gets: string | path | Path.
		------------------------------------------------
		fn getBaseName path =
		(
			array = lb.str.split path "\\"
			if array.count > 0 then
				return array[array.count]
			else
				return ""
		),
		
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
		
	)--lib_io
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_io() --crea la libreria
)