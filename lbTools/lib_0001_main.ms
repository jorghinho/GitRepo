------------------------------------------------------------------------------------------------------------------------------------------------
--Description: Librería de funciones principal que contiene el resto de librerías, tools y sripts
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lib | Contiene todas las libreríias y herramientas.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_main
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var | def | Almacena la definicion del struct.
		defFile = undefined,				--@var | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		className = "lb",						--@var | className | Nombre de la libreria.
		description = "Librería principal",	--@var | description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		libraries = #(),	--@var | libraries | Array de todas las librerias de funciones.
		tools = #(),		--@var | libraries | Array de todas las tools.
		scripts = #(),		--@var | libraries | Array de todos los scripts individuales.
		
		developerModeOn = false,	--@var | developerModeOn | Indica si se está en modo desarrollador
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		--<libraries>
		
		------------------------------------------------------------------------------------------------
		--TOOLS
		------------------------------------------------------------------------------------------------
		
		--<tools>
		
		------------------------------------------------------------------------------------------------
		--SCRIPTS
		------------------------------------------------------------------------------------------------
		
		--<scripts>
			
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: array{library} | getLibraries | Devuelve todas las librerias en un array.
		------------------------------------------------
		fn getLibraries =
		(
			this.libraries 
		),	
		
		------------------------------------------------
		--@fn: array{tool} | getTools | Devuelve todas las herramientas en un array.
		------------------------------------------------
		fn getTools =
		(
			this.tools 
		),
		
		------------------------------------------------
		--@fn: array{script} | getScripts | Devuelve todos los scripts es un array.
		------------------------------------------------
		fn getScripts =
		(
			this.scripts
		),
		
		------------------------------------------------
		--@fn: array{library} | getLibrariesByCategory | Devuelve las librerias de la categoría especificada
		--@opt: name | category | nombre de la categoría a buscar.
		------------------------------------------------
		fn getLibrariesByCategory categoryName =
		(
			_libs = for _lib in this.libraries where _lib.category == categoryName collect _lib
			
			_libs
		),
		
		------------------------------------------------
		--@fn: array{tool} | getToolsByCategory | Devuelve las herramientas de la categoría especificada
		--@opt: name | category | nombre de la categoría a buscar.
		------------------------------------------------
		fn getToolsByCategory categoryName =
		(
			_tools = for _tool in this.tools where _tool.category == categoryName collect _tool
			
			_tools
		),
		
		------------------------------------------------
		--@fn: array{script} | getScriptsByCategory | Devuelve los scripts de la categoría especificada
		--@opt: name | category | nombre de la categoría a buscar.
		------------------------------------------------
		fn getScriptsByCategory categoryName =
		(
			_scripts = for _script in this.scripts where _script.category == categoryName collect _script
				
			_scripts
		),
		
		------------------------------------------------
		--@fn: library | getLibrary | Devuelve la libreria con el nombre que se solicita.
		--@gets: string | libName | Nombre de la libreria que se quiere obtener.
		------------------------------------------------
		fn getLibrary libName =
		(
			_foundLib = undefined
			
			for _lib in this.libraries where _lib.className == libName do _foundLib = _lib
			
			_foundLib
		),
		
		------------------------------------------------
		--@fn: tool | getTool | Devuelve la tool con el nombre que se solicita.
		--@gets: string | toolName | Nombre de la tool que se quiere obtener.
		------------------------------------------------
		fn getTool toolName =
		(
			_foundTool = undefined
			
			for _tool in this.tools where _tool.className == toolName do _foundTool = _tool
			
			_foundTool
		),
		
		------------------------------------------------
		--@fn: script | getScript | Devuelve el script con el nombre que se solicita.
		--@gets: string | scriptName | Nombre del script que se quiere obtener.
		------------------------------------------------
		fn getScript scriptName =
		(
			_foundScript = undefined
			
			for _scr in this.scripts where _scr.className == scriptName do _foundScript = _scr
			
			_foundScript
		),
		
		------------------------------------------------
		--@fn: array{name} | getLibraryCategories | Devuelve las categorias de las librerias.
		------------------------------------------------
		fn getLibraryCategories =
		(
			(makeUniqueArray (for _lib in this.libraries collect _lib.category))
		),
		
		------------------------------------------------
		--@fn: array{name} | getToolCategories | Devuelve las categorias de las tools.
		------------------------------------------------
		fn getToolCategories =
		(
			(makeUniqueArray (for _tool in this.tools collect _tool.category))
		),
		
		------------------------------------------------
		--@fn: array{name} | getScriptCategories | Devuelve las categorias de los scripts.
		------------------------------------------------
		fn getScriptCategories =
		(
			(makeUniqueArray (for _script in this.scripts collect _script.category))
		),
		
		------------------------------------------------
		--@fn: array{tool} | getToolInstances | Devuelve todas las copias de una tool en un array. Se devuelve a si misma en el array tambien.
		--@gets: string | toolName | Nombre de la tool de la que se quiere obtener sus instancias.
		------------------------------------------------
		fn getToolInstances toolName =
		(
			_toolInstances = #()
			
			_toolInstances = for _tool in this.tools where matchPattern _tool.className pattern:(toolName + "__???") collect _tool 
			append _toolInstances (this.getTool toolName)
			
			_toolInstances
		),
		
		------------------------------------------------
		--@fn: string | getFileLibName | Devuelve el nombre de la libreria principal almacenada en el archivo pasado por parametro
		--@gets: string | fileName | Path completo del archivo que contiene la libreria
		------------------------------------------------
		fn getFileLibName fileName =
		(	
			(substituteString (getFileNameFile fileName) "lib_" "")
		),
		
		------------------------------------------------
		--@fn: string | getThisFileToolName | Devuelve el nombre de la tool almacenada en el archivo pasado por parametro
		--@gets: string | fileName | Path completo del archivo que contiene la tool
		------------------------------------------------
		fn getFileToolName fileName =
		(	
			(substituteString (getFileNameFile fileName) "tl_" "")
		),
		
		------------------------------------------------
		--@fn: string | getFileScriptName | Devuelve el nombre del script almacenada en el archivo pasado por parametro
		--@gets: string | fileName | Path completo del archivo que contiene el script
		------------------------------------------------
		fn getFileScriptName fileName =
		(	
			(substituteString (getFileNameFile fileName) "sc_" "")
		),
		
		------------------------------------------------
		--@fn: boolean | getDeveloperMode | Devuelve el estado activado o no, del modod esarrollador
		------------------------------------------------
		fn getDeveloperMode =
		(	
			this.developerModeOn
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
			
		------------------------------------------------
		--@fn: undefined | enableDeveloperMode | Habilita el modo desarrollador.
		------------------------------------------------
		fn enableDeveloperMode = 
		(
			this.developerModeOn = true
		),
		
		------------------------------------------------
		--@fn: undefined | disableDeveloperMode | deshabilita el modo desarrollador.
		------------------------------------------------
		fn disableDeveloperMode = 
		(
			this.developerModeOn = false
		),
		
		------------------------------------------------
		--@fn: boolean | doesLibraryExist | Indica si una libreria existe
		------------------------------------------------
		fn doesLibraryExist libName = 
		(
			((this.getLibrary libName) != undefined)
		),
		
		------------------------------------------------
		--@fn: boolean | doesToolExist | Indica si una tool existe
		------------------------------------------------
		fn doesToolExist toolName = 
		(
			((this.getTool toolName) != undefined)
		),
		
		------------------------------------------------
		--@fn: boolean | doesScriptExist | Indica si un script existe
		------------------------------------------------
		fn doesScriptExist scriptName = 
		(
			((this.getScript scriptName) != undefined)
		),
		
		------------------------------------------------
		--@fn: undefined | addLibrary | Añade una libreria al array de librerias.
		--@gets: library | newLibrary | Libreria que se quiere añadir.
		------------------------------------------------
		fn addLibrary newLibrary =
		(
			--Si la libreria ya existe la borra primero para que no se duplique
			if this.doesLibraryExist newLibrary.className then this.removeLibrary newLibrary.className
			append this.libraries newLibrary --añade la libreria
			
			--si ya existia una variable específica para la libreria la rellena
			if isProperty this (newLibrary.className) then
			(			
				--almacena la libreria en su variable especifica
				global _tmpGlobalLib = newLibrary --hace la libreria global de forma temporal
				execute ("lb." + newLibrary.className + " = _tmpGlobalLib") --almacena la libreria en su variable especifica
				_tmpGlobalLib = undefined --libera la variable temporal
			)
			--si no existia significa que no se ha reiniciado 3ds max tras su creacion, con lo cual recarga todas las tools
			else if (("lib_" + newLibrary.className) == (getFilenameFile newLibrary.defFile)) then
			(
				--reconstruye todas las variables individuales pero manteniendo las librerias, tools y scripts que ya esten cargados
 				this.constructSingleVariables()
			)
		),
		
		------------------------------------------------
		--@fn: undefined | addTool | Añade una tool al array de tools.
		--@gets: tool | newTool | Tool que se quiere añadir.
		------------------------------------------------
		fn addTool newTool =
		(
			--Si la tool ya existe la borra primero para que no se duplique
			if this.doesToolExist newTool.className then this.removeTool newTool.className
			append this.tools newTool --añade la tool
			
			if isProperty this (newTool.className) then
			(		
				--se cierra la tool antes de añadir la nueva version
				if newTool.className != "template" then execute ("if lb." + newTool.className + " != undefined then lb." + newTool.className + ".close()") --cierra la tool
				else if this.developerModeOn then execute ("lb." + newTool.className + ".close()")
				
				--almacena la tool en su variable especifica
				global _tmpGlobalTool = newTool --hace la tool global de forma temporal
				execute ("lb." + newTool.className + " = _tmpGlobalTool") --almacena la tool en su variable especifica
				_tmpGlobalTool = undefined --libera la variable temporal
				
				--si se está en modo desarrollo se abre la tool
				if this.developerModeOn then newTool.run()
			)
			--si no existia significa que no se ha reiniciado 3ds max tras su creacion, con lo cual recarga todas las tools
			else if (("tl_" + newTool.className) == (getFilenameFile newTool.defFile)) then
			(
				--reconstruye todas las variables individuales pero manteniendo las librerias, tools y scripts que ya esten cargados
 				this.constructSingleVariables()
			)
		),
		
		------------------------------------------------
		--@fn: undefined | addScript | Añade un script al array de scripts.
		--@gets: script | newScript | Script que se quiere añadir.
		------------------------------------------------
		fn addScript newScript =
		(
			--Si el script ya existe lo borra primero para que no se duplique
			if this.doesScriptExist newScript.className then this.removeScript newScript.className
			append this.scripts newScript --añade el script
			
			--si ya existia una variable específica para el script la rellena
			if isProperty this (newScript.className) then
			(			
				--almacena el script en su variable especifica
				global _tmpGlobalScript = newScript --hace el script global de forma temporal
				execute ("lb." + newScript.className + " = _tmpGlobalScript") --almacena el script en su variable especifica
				_tmpGlobalScript = undefined --libera la variable temporal
			)
			--si no existia significa que no se ha reiniciado 3ds max tras su creacion, con lo cual recarga todos los scripts
			else if (("sc_" + newScript.className) == (getFilenameFile newScript.defFile)) then
			(
				--reconstruye todas las variables individuales pero manteniendo las librerias, tools y scripts que ya esten cargados
 				this.constructSingleVariables()
			)
		),
		
		------------------------------------------------
		--@fn: undefined | removeLibrary | Elimina una libreria.
		--@gets: string | libName | Nombre de la libreria que se quiere eliminar.		
		------------------------------------------------
		fn removeLibrary libName =
		(
			for i = this.libraries.count to 1 by -1 where this.libraries[i].className == libName do
				deleteItem (this.libraries) i
		),
		
		------------------------------------------------
		--@fn: undefined | removeTool | Elimina una tool.
		--@gets: string | toolName | Nombre de la tool que se quiere eliminar.		
		------------------------------------------------
		fn removeTool toolName =
		(
			for i = this.tools.count to 1 by -1 where this.tools[i].className == toolName do
				deleteItem (this.tools) i
		),
		
		------------------------------------------------
		--@fn: undefined | removeScript | Elimina un script.
		--@gets: string | scriptName | Nombre del script que se quiere eliminar.
		------------------------------------------------
		fn removeScript scriptName =
		(
			for i = this.scripts.count to 1 by -1 where this.scripts[i].className == scriptName do
				deleteItem (this.scripts) i
		),
		
		------------------------------------------------
		--@fn: undefined | constructSingleVariables | Crea una variable individual para cada libreria, tool y script, para poder llamarlos directamente.
		------------------------------------------------
		fn constructSingleVariables =
		(
			--abre el archivo actual para leer linea a linea y añadirle las lineas de cada variable
			--luego lo ejecuta
			if doesFileExist this.defFile then
			(
				_newLibStringDef = "" --string para almacenar la definicion modificada
					
				-----------------------------------------------------
				--busqueda en la carpeta actual de todos los archivos de librerias, tools y scripts
				
				_currFolder = getFileNamePath this.defFile --carpeta actual
				
				_libFiles = getFiles (_currFolder + "lib_*.ms") --archivos de librerias
				_libNames = for _libFile in _libFiles collect (substituteString (getFilenameFile _libFile) "lib_" "")
				if _libNames[1] == "0001_main" then deleteItem _libNames 1
					
				_toolFiles = getFiles (_currFolder + "tl_*.ms") --archivos de tools
				_toolNames = for _toolFile in _toolFiles collect (substituteString (getFilenameFile _toolFile) "tl_" "")
				
				_scriptFiles = getFiles (_currFolder + "sc_*.ms") --archivos de librerias
				_scriptNames = for _scriptFile in _scriptFiles collect (substituteString (getFilenameFile _scriptFile) "sc_" "")
				-----------------------------------------------------
				
				-----------------------------------------------------
				--modificacion del string del archivo
				
				_f = openFile this.defFile
				
				while not eof _f do --recorre el archivo linea a linea
				(
					_line  = readLine _f
					
					--lineas para añadir las variables individuales
					if (filterString _line "	 ")[1] == "--<libraries>" then (for _lib in _libNames do _newLibStringDef += "\t\t" + _lib + " = undefined,\n")
					else if (filterString _line "	 ")[1] == "--<tools>" then (for _tool in _toolNames do _newLibStringDef += "\t\t" + (substituteString _tool "tl_" "") + " = undefined,\n")
					else if (filterString _line "	 ")[1] == "--<scripts>" then (for _script in _scriptNames do _newLibStringDef += "\t\t" + _script + " = undefined,\n")
					--ignora algunas lineas para no entrar en bucle infinito
					else if findString _line "lb.constructSingleVariables ignore:true" != undefined then _newLibStringDef += "\n"
					--añade la linea tal cual
					else _newLibStringDef += _line + "\n"
					
				)--while
				
				close _f --cierra el archivo
				free _f --libera la memoria que ha ocupado
				-----------------------------------------------------
				
				-----------------------------------------------------
				--backups
				
				--hace copias globales de seguridad de las librerias, tools y scripts, por si ya tenian algo para poder restaurarlos
				--_tmpLibraries = deepCopy (lb.getLibraries())
				--_tmpTools = deepCopy (lb.getTools())
				--_tmpScripts = deepCopy (lb.getScripts())
				
				-----------------------------------------------------

				-----------------------------------------------------
				--sustitucion en memoria de la libreria principal mejorada
				--print _newLibStringDef
				execute _newLibStringDef
				-----------------------------------------------------
				
				-----------------------------------------------------
				--restauracion de backups
				
				--restaura las librerias, tools y scripts que ya estuviesen almacenados de antemano
				
				--if _tmpLibraries == undefined then _tmpLibraries = #()
				--if _tmpTools == undefined then _tmpTools = #()
				--if _tmpScripts == undefined then _tmpScripts = #()
				
				--for _lib in _tmpLibraries do lb.addLibrary _lib --restaura las librerias
				--for _tool in _tmpTools do lb.addTool _tool --restaura las tools
				--for _script in _tmpScripts do lb.addScript _script --restaura los scripts
				-----------------------------------------------------
			)			
		),
		
		----------------------------
		--@fn struct{tool} | cloneTool | Duplica una tool. Si no lo consigue devuelve undefined
		--@gets: struct{tool} | toolToClone | Tool que se quiere clonar
		fn cloneTool toolToClone =
		(
			_clonedTool = undefined
			
			--si se ha pasado una tool y existe su archivo origen la intenta duplicar
			if toolToClone != undefined and toolToClone.defFile != undefined and doesFileExist toolToClone.defFile then
			(
				--obtiene el nombre de la tool a copiar y si es una copia ya, obtiene el nombre sin indice de copia
				_toolName = toolToClone.className
				if (matchPattern _toolName pattern:"*__???") then (_toolName = subString _toolName 1 ((findString _toolName "__") - 1))
				
				--obtiene las instancias ya existentes de la tool que se quiere duplicar, para decidir cual es el indice de copia que usar
				_toolInstances = this.getToolInstances _toolName
				_copyNumber = (formattedprint (_toolInstances.count) format:"03d")
				
				------------------------------------------------
				--procesa el string de la tool original y obtiene las palabras a ser sustituidas y el equivalente a sustituir
				
				_executeString = ""
				_originalStrings = #()
				_substituteStrings = #()
				
				_f = openfile toolToClone.defFile
				
				while not eof _f do --recorre las lineas filtrando la informacion
				(
					_line = readLine _f
					_lineParts = filterstring _line " 	" --separa las partes de la linea por espacios y tabuladores
					
					------------------------------------------------
					--hay que añadir las lineas al string de ejecucion, pero hay algunas excepciones
					_addLine = true
					if findString _line "lb.addTool this" != undefined then _addLine = false --quita esta linea para evitar que la tool se añada sola
					if _addLine then _executeString += _line + "\n" --almacena las lineas en un string que sera ejecutado mas tarde					
					------------------------------------------------
					
					if _lineParts.count > 0 then --si la linea tiene varias partes
						case _lineParts[1] of --puede haber varios casos en funcion de la primera palabra
						(
							"rollout":
							(
								--almacena el antiguo nombre del rollout para sustituirlo luego por el nuevo con el numero de copia
								if appendIfUnique _originalStrings _lineParts[2] then append _substituteStrings (_lineParts[2] + "__" + _copyNumber)
							)--rollout
						)--case
				)--while
				
				--cierra el archivo y libera la memoria usada con el
				close _f
				free _f				
				
				--sustituye los nombres por los nuevos con el numero de copia
				for i=1 to _originalStrings.count do
				(
					--sustituye los nombres de los rollouts por los nombre nuevos
					_executeString = substituteString _executeString _originalStrings[i] _substituteStrings[i]
				)--for
				
				/* --convierte el string a ejecutar en un StringStream de nuevo para poder recorrerlo y hacer algunos cambios más
				_executeStringStream = _executeString as StringStream
				_executeString = ""
				
				_searchState = #onOpen --estado de busqueda del automata
				while not eof _executeStringStream do --recorre las lineas filtrando la informacion
				(
					_line = readLine _executeStringStream
					
					--añade la autoasignación de la tool padre en funcion del nuevo indice a todos los rollouts de la herramienta
					--va pasando por los estados hasta llegar al punto de reemplazar
					case _searchState of
					(
						#onOpen: if matchPattern _line pattern:"*on*open do*" then _searchState = #bracket
						#bracket: if matchPattern _line pattern:"*(*" then _searchState = #replace
						#replace: (_executeString += ("\t\t\t" + "parent = lb.getTool \"" + toolToClone.className + "__" + _copyNumber + "\"\n") ; _searchState = #onOpen)
					)
						
					_executeString += _line + "\n"
				) */
				
				------------------------------------------------
				
				------------------------------------------------
				--almacena el contenido en un archivo temporal del mismo nombre que la tool clonada para hacer un flieIn
				_tmpFileName = ((lb.config.getTempPath()) + toolToClone.className + "__" + _copyNumber + ".ms")
				f = createFile _tmpFileName
				close f
				f = openFile _tmpFileName mode:"w"
				format _executeString to:f
				close f				
				------------------------------------------------
				
				--ejecuta el string para duplicar la herramienta y la guarda temporalmente para modificar algunos parametros antes de añadirla al array de tools
				_clonedTool = fileIn _tmpFileName --execute _executeString
				deleteFile _tmpFileName --elimina el archivo temporal

				--aplica los parametros que tiene que heredar de la tool original
				--_clonedTool.className = toolToClone.className + "__" + _copyNumber --le pone el nombre de copia
				_clonedTool.defFile = toolToClone.defFile
				_clonedTool.cfgFile	= toolToClone.cfgFile
-- 				_clonedTool.rollMain.parent = _clonedTool
					
				--añade la tool al array de tools
				append (this.tools) _clonedTool
			)--if
			
			_clonedTool --devuelve la tool clonada
		),
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrerias en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			for _lib in this.libraries do _lib.init() --llama al init de cada libreria
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librería.
		------------------------------------------------
		fn init =
		(
			this.initSubLibraries() --inicialza las librerias hijas
		),
			
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecución al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb = this
		)
	)--lib_main	
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------
	--backup de rutas, librerias, tools y scripts por si se está regenerando la librería principal sin querer reiniciar 3ds max
	global _tmpDefFile = undefined
	global _tmpLibraries = #()
	global _tmpTools = #()
	global _tmpScripts = #()
	
	try
	(
		_tmpDefFile = lb.defFile
		_tmpLibraries = lb.getLibraries()
		_tmpTools = lb.getTools()
		_tmpScripts = lb.getScripts()
	) catch ()
	------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------
	--creacion de la libreria
	lb = lib_main() --pisa la variable de la definicion con la libreria principal. C.rea la libreria en memoria
	------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------
	--restauracion del backup 1
	
	lb.defFile = if _tmpDefFile != undefined then _tmpDefFile else getThisScriptFilename() --restauracion del backup
	
	lb.defFile = if _tmpDefFile != undefined then _tmpDefFile else getThisScriptFilename() --restauracion del backup
	lb.libraries = if _tmpLibraries != undefined then _tmpLibraries else #() --restauracion del backup
	lb.tools = if _tmpTools != undefined then _tmpTools else #() --restauracion del backup
	lb.scripts = if _tmpScripts != undefined then _tmpScripts else #() --restauracion del backup
	------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------
	--construye una variable individual para cada libreria, tool y script
 	lb.constructSingleVariables ignore:true
	------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------
	--restauracion del backup 2
		
	for _lib in _tmpLibraries do lb.addLibrary _lib --restaura las librerias
	for _tool in _tmpTools do lb.addTool _tool --restaura las tools
	for _script in _tmpScripts do lb.addScript _script --restaura los scripts
	------------------------------------------------------------------------------------------------
)