------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de ayuda
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct : helpElement | Contiene todas las FUNCTIONS de elementos de ayuda.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_helpElement
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		---------------------------------------------		
		type = "",						--@var: type | Tipo de elemento de ayuda. Struct, Var, fn, event...
		elementName = "",				--@var: elementName | Nombre del elemento de ayuda.
		description = "",				--@var: description | Descripcion del elemento de ayuda.
		
		---------------------------------------------
		
		getsTypes = #(),				--@var: getsTypes | Tipos de los parametros de la funcion.
		getsNames = #(),				--@var: getsNames | Nombres de los parametros de la funcion.
		getsDescriptions = #(),			--@var: getsDescriptions | Descripciones de los parametros de la funcion.
		
		optsTypes = #(),				--@var: optsTypes | Tipos de los parametros opcionales de la funcion.
		optsNames = #(),				--@var: optsNames | Nombres de los parametros opcionales de la funcion.
		optsDefaults = #(),				--@var: optsDefaults | Valores por defecto de los parametros opcionales de la funcion.
		optsDescriptions = #(),			--@var: optsDescriptions | Descripciones de los parametros opcionales de la funcion.
		
		controlType = "",				--@var: controlType | Tipo del control de un evento. Elemento que se ve afectado por el evento.
		controlName = "",				--@var: controlName | Nombre del control de un evento. Elemento que se ve afectado por el evento.
		controlDescription = "",		--@var: controlDescription | Descripción del control de un evento. Elemento que se ve afectado por el evento.
		
		returnsType = "",				--@var: returnsType | Tipo del valor devuelto por la funcion.
		returnsDescription = "",		--@var: returnsDescription | Descripcion del valor devuelto por la funcion.
		---------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
	
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: string | getType | Devuelve el tipo del elemento de ayuda.
		------------------------------------------------
		fn getType = this.type,
			
		------------------------------------------------
		--@fn: string | getName | Devuelve el nombre del elemento.
		------------------------------------------------
		fn getName = this.elementName,
		
		------------------------------------------------
		--@fn: description | getDescription | Devuelve la descripcion del elemento.
		------------------------------------------------
		fn getDescription = this.description,
			
		------------------------------------------------
		--@fn: array{string} | getGetsTypes | Devuelve el array de tipos de los gets.
		------------------------------------------------
		fn getGetsTypes = this.getsTypes,
		
		------------------------------------------------
		--@fn: array{string} | getGetsNames | Devuelve el array de nombres de los gets.
		------------------------------------------------
		fn getGetsNames = this.getsNames,
		
		------------------------------------------------
		--@fn: array{string} | getGetsDescriptions | Devuelve el array de descripciones de los gets.
		------------------------------------------------
		fn getGetsDescriptions = this.getsDescriptions,
		
		------------------------------------------------
		--@fn: functionParam | getFunctionParams | Devuelve un struct de los parametros de la funcion.
		------------------------------------------------
		fn getFunctionParams =
		(
			-----------------------------------
			--struct para almacenar los parametros de las funciones y devolverlos
			struct _functionParam
			(
				type = "",
				name = "",
				description = "",				
				
				fn toString =
				(
					_theString = ""
					_theString += "<type>" + this.type + "</type>"
					_theString += "<name>" + this.name + "</name>"
					_theString += "<description>" + this.description + "</description>"
					_theString					
				)
			)--struct
			-----------------------------------
			
			-----------------------------------
			_functParams = #() --array para los parametros de funciones
			
			for i=1 to this.getsTypes.count do --recorre todos lo parametros de la funcion y los rellena
			(
				_fnParam = _functionParam() --crea el struct
				_fnParam.type = this.getsTypes[i] --rellena el tipo
				_fnParam.name = this.getsNames[i] --rellena el nombre
				_fnParam.description = this.getsDescriptions[i] --rellena la descripcion
				append _functParams _fnParam --lo añade al array
			)--for
			------------------------------------
			
			_functParams --los devuelve
		),
		
		------------------------------------------------
		--@fn: array{string} | getOptsTypes | Devuelve el array de tipos de los parametros opcionales.
		------------------------------------------------
		fn getOptsTypes = this.OptsTypes,
		
		------------------------------------------------
		--@fn: array{string} | getOptsNames | Devuelve el array de nombres de los parametros opcionales.
		------------------------------------------------
		fn getOptsNames = this.optsNames,
		
		------------------------------------------------
		--@fn: array{string} | getOptsDefaults | Devuelve el array de valores por defecto de los parametros opcionales.
		------------------------------------------------
		fn getOptsDefaults = this.optsDefaults,
		
		------------------------------------------------
		--@fn: array{string} | getOptsDescriptions | Devuelve el array de descripciones de los parametros opcionales.
		------------------------------------------------
		fn getOptsDescriptions = this.optsDescriptions,
		
		------------------------------------------------
		--@fn: functionOptionalParam | getOptionalFunctionParams | Devuelve un struct de los parametros opcionales de la funcion.
		------------------------------------------------
		fn getOptionalFunctionParams =
		(
			-----------------------------------
			--struct para almacenar los parametros de las funciones y devolverlos
			struct _functionOptionalParam
			(
				type = "",
				name = "",
				default = "",
				description = "",				
				
				fn toString =
				(
					_theString = ""
					_theString += "<type>" + this.type + "</type>"
					_theString += "<name>" + this.name + "</name>"
					_theString += "<default>" + this.default + "</default>"
					_theString += "<description>" + this.description + "</description>"	
					_theString				
				)
			)--struct
			-----------------------------------
			
			-----------------------------------
			_functParams = #() --array para los parametros opcionales de funciones
			
			for i=1 to this.optsTypes.count do --recorre todos lo parametros de la funcion y los rellena
			(
				_fnParam = _functionOptionalParam() --crea el struct
				_fnParam.type = this.optsTypes[i] --rellena el tipo
				_fnParam.name = this.optsNames[i] --rellena el nombre
				_fnParam.default = this.optsDefaults[i] --rellena el valor por defecto
				_fnParam.description = this.optsDescriptions[i] --rellena la descripcion
				append _functParams _fnParam --lo añade al array
			)--for
			------------------------------------
			
			_functParams --los devuelve
		),
		
		------------------------------------------------
		--@fn: string | getControlType | Devuelve el tipo del control del evento.
		------------------------------------------------
		fn getControlType =
		(
			this.controlType
		),
		
		------------------------------------------------
		--@fn: string | getControlName | Devuelve el nombre del control del evento.
		------------------------------------------------
		fn getControlName =
		(
			this.controlName
		),
		
		------------------------------------------------
		--@fn: string | getControlDescription | Devuelve la descripcion del control del evento.
		------------------------------------------------
		fn getControlDescription =
		(
			this.controlDescription
		),
		
		------------------------------------------------
		--@fn: string | getReturnType | Devuelve el tipo del valor devuelto por la funcion.
		------------------------------------------------
		fn getReturnType =
		(
			this.returnsType
		),
		
		------------------------------------------------
		--@fn: string | getReturnDescription | Devuelve la descripcion del valor devuelto por la funcion.
		------------------------------------------------
		fn getReturnDescription =
		(
			this.returnsDescription
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setType | Almacena el tipo del elemento.
		--@gets: string | newType | Nuevo tipo del elemento.
		------------------------------------------------
		fn setType newType = (this.type = newType),
		
		------------------------------------------------
		--@fn: undefined | setName | Almacena el nombre del elemento.
		--@gets: string | newName | Nuevo nombre del elemento.
		------------------------------------------------
		fn setName newName = (this.elementName = newName),
		
		------------------------------------------------
		--@fn: undefined | setContent | Almacena la descripcion del elemento.
		--@gets: string | newDescription | Nuevo contenido del elemento.
		------------------------------------------------
		fn setDescription newDescription = (this.description = newDescription),
		
		------------------------------------------------
		--@fn: undefined | setGetsTypes | Almacena los tipos de los parametros de la funcion.
		--@gets: array{string} | newGetsTypes | Nuevos tipos de los parametros de la funcion.
		------------------------------------------------
		fn setGetsTypes newGetsTypes = (this.getsTypes = newGetsTypes),
		
		------------------------------------------------
		--@fn: undefined | setGetsNames | Almacena los nombres de los parametros de la funcion.
		--@gets: array{string} | newGetsNames | Nuevos nombres de los parametros de la funcion.
		------------------------------------------------
		fn setGetsNames newGetsNames = (this.getsNames = newGetsNames),
		
		------------------------------------------------
		--@fn: undefined | setGetsDescriptions | Almacena las descripciones de los parametros de la funcion.
		--@gets: array{string} | newGetsDescriptions | Nuevas descripciones de los parametros de la funcion.
		------------------------------------------------
		fn setGetsDescriptions newGetsDescriptions = (this.getsDescriptions = newGetsDescriptions),
		
		------------------------------------------------
		--@fn: undefined | setOptsTypes | Almacena los tipos de los parametros opcionales de la funcion.
		--@gets: array{string} | newOptsTypes | Nuevos tipos de los parametros opcionales de la funcion.
		------------------------------------------------
		fn setOptsTypes newOptsTypes = (this.optsTypes = newOptsTypes),
		
		------------------------------------------------
		--@fn: undefined | setOptsNames | Almacena los nombres de los parametros opcionales de la funcion.
		--@gets: array{string} | newOptsNames | Nuevos nombres de los parametros opcionales de la funcion.
		------------------------------------------------
		fn setOptsNames newOptsNames = (this.optsNames = newOptsNames),
		
		------------------------------------------------
		--@fn: undefined | setOptsDefaults | Almacena los valores por defecto de los parametros opcionales de la funcion.
		--@gets: array{string} | newOptsDefaults | Nuevos valores por defecto de los parametros opcionales de la funcion.
		------------------------------------------------
		fn setOptsDefaults newOptsDefaults = (this.optsDefaults = newOptsDefaults),
		
		------------------------------------------------
		--@fn: undefined | setOptsDescriptions | Almacena las descripciones de los parametros opcionales de la funcion.
		--@gets: array{string} | newOptsDescriptions | Nuevas descripciones de los parametros opcionales de la funcion.
		------------------------------------------------
		fn setOptsDescriptions newOptsDescriptions = (this.optsDescriptions = newOptsDescriptions),
			
		------------------------------------------------
		--@fn: undefined | setControlType | Almacena el tipo del control del evento.
		--@gets: string | newControlType | Nuevo tipo del control afectado por el evento.
		------------------------------------------------
		fn setControlType newControlType = (this.controlType = newControlType),
		
		------------------------------------------------
		--@fn: undefined | setControlName | Almacena el nombre del control del evento.
		--@gets: string | newControlName | Nuevo nombre del control afectado por el evento.
		------------------------------------------------
		fn setControlName newControlName = (this.controlName = newControlName),
		
		------------------------------------------------
		--@fn: undefined | setControlDescription | Almacena la descripcion del control del evento.
		--@gets: string | newControlDescription | Nueva descripcion del control afectado por el evento.
		------------------------------------------------
		fn setControlDescription newControlDescription = (this.controlDescription = newControlDescription),
		
		------------------------------------------------
		--@fn: undefined | setReturnType | Almacena el tipo del valor que devuelve la funcion.
		--@gets: string | newReturnType | Nuevo tipo del valor que devuelve la funcion
		------------------------------------------------
		fn setReturnType newReturnType = (this.returnsType = newReturnType),
		
		------------------------------------------------
		--@fn: undefined | setReturnDescription | Almacena la descripcion del valor que devuelve la funcion.
		--@gets: string | newReturnDescription | Nueva descripcion del valor que devuelve la funcion.
		------------------------------------------------
		fn setReturnDescription newReturnDescription = (this.returnsDescription = newReturnDescription),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
			
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la información del nodo y sus subnodos recursivamente.
		--@opt: integer | level | 1 | Numero de niveles que debe profundizar las funcion de forma recursiva extrayendo la informacion de los hijos.
		------------------------------------------------
		fn toString level:1 =
		(
			_theString = ""
			
			_initialSpaces = ""
			for i=1 to (level - 1) do _initialSpaces += "  " --añade tabuladores segun el nivel.
			
			_theString += "\n" + _initialSpaces + "<type>" + this.type + "</type>"
			_theString += "\n" + _initialSpaces + "<name>" + this.elementName + "</name>"
				
			if this.description != "" then _theString += "\n" + _initialSpaces + "<description>" + this.description + "</description>"
			
			--si es un evento con control añade ese apartado
			if this.controlType != "" then
			(
				_theString += "\n" + _initialSpaces + "<control>"
				_theString += "\n  " + _initialSpaces + "<type>" + this.controlType + "</type>"
				_theString += "\n  " + _initialSpaces + "<name>" + this.controlName + "</name>"
				_theString += "\n  " + _initialSpaces + "<description>" + this.controlDescription + "</description>"
				_theString += "\n" + _initialSpaces + "</control>"
			)--if
			
			--si es una funcion a la que se le pasan parámetros añade ese apartado
			if this.getsTypes.count != 0 then
			(				
				for i=1 to this.getsTypes.count do
				(
					_theString += "\n" + _initialSpaces + "<param>"
					_theString += "\n  " + _initialSpaces + "<type>" + this.getsTypes[i] + "</type>"
					_theString += "\n  " + _initialSpaces + "<name>" + this.getsNames[i] + "</name>"
					_theString += "\n  " + _initialSpaces + "<description>" + this.getsDescriptions[i] + "</description>"
					_theString += "\n" + _initialSpaces + "</param>"
				)--for
			)
				
			--si es una funcion a la que se le pasan parámetros opcionales añade ese apartado
			if this.optsTypes.count != 0 then
			(
				for i=1 to this.optsTypes.count do
				(
					_theString += "\n" + _initialSpaces + "<optional>"
					_theString += "\n  " + _initialSpaces + "<type>" + this.optsTypes[i] + "</type>"
					_theString += "\n  " + _initialSpaces + "<name>" + this.optsNames[i] + "</name>"
					_theString += "\n  " + _initialSpaces + "<default>" + this.optsDefaults[i] + "</default>"
					_theString += "\n  " + _initialSpaces + "<description>" + this.optsDescriptions[i] + "</description>"
					_theString += "\n" + _initialSpaces + "</optional>"
				)--for
			)
			
			--si es una función que devuelve un valor añade ese apartado
			if this.returnsType != "" then
			(
				_theString += "\n" + _initialSpaces + "<return>"
				_theString += "\n  " + _initialSpaces + "<type>" + this.returnsType + "</type>"
				_theString += "\n  " + _initialSpaces + "<description>" + this.returnsDescription + "</description>"
				_theString += "\n" + _initialSpaces + "</return>"
			)--if
			
			_theString
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
		
	)--lib_helpElement
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: help | Contiene todas las FUNCTIONS de la ayuda.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_help
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de ayuda",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		helpElement = lib_helpElement,		--@var: helpElement | Almacena la definición del struct de elemento de ayuda para el arbol de ayuda.
		
		helpTree = undefined,				--@var: helpTree | Almacena el árbol de ayuda generado a partir de todos los archivos de ayuda.
					
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
		--@fn: string | getHelpNodeInfo | Devuelve la informacion solicitada del nodo de ayuda pasado por parametro.
		--@gets | treeNode | helpNode | Nodo del arbol de ayuda del que se quiere la información.
		--@gets | name | infoLabel | Parámetro solicitado. Puede ser: all, type, name, description, vars, functions, events, params, optional, default, return
		--@opt: name | filter | all | Filtros para elegir que partes de la ayuda del elemento soicitado se tienen que devolver. Por defecto 'all'; Se pueden solicitar también: vars, libraries, rollouts, functions, events, controls, uiControl.
		------------------------------------------------
		fn getHelpNodeInfo helpNode infoLabel filter:#all =
		(
			_nodeInfo = ""
			
			case (infoLabel as string) of
			(
				"all":
				(
					filter = filter as string --convierte el filtro de tipo name en una cadena de texto
					
					--recopila la información del elemento de ayuda solicitado y encotrado; Y lo presenta en un string legible.
					_elementType =			this.getHelpNodeInfo helpNode #type
					_elementName =			this.getHelpNodeInfo helpNode #name
					_elementDescription =	this.getHelpNodeInfo helpNode #description
					_elementVars =			if filter == "all" or filter == "vars" then this.getHelpNodeInfo helpNode #vars else ""
					_elementLibs =			if filter == "all" or filter == "libraries" then this.getHelpNodeInfo helpNode #libraries else ""
					_elementControls =		if filter == "all" or filter == "controls" then this.getHelpNodeInfo helpNode #controls else ""
					_elementRollouts =		if filter == "all" or filter == "rollouts" then this.getHelpNodeInfo helpNode #rollouts else ""
					_elementFunctions =	if filter == "all" or filter == "functions" then this.getHelpNodeInfo helpNode #functions else ""
					_elementEvents =		if filter == "all" or filter == "events" then this.getHelpNodeInfo helpNode #events else ""
					
					_nodeInfo += _elementName + " | " + _elementDescription --añade la cabecera del elemento
					if _elementVars != "" then _nodeInfo += "\n\nvariables:\n" + _elementVars --añade las variables si hay
					if _elementLibs != "" then _nodeInfo += "\n\nlibraries:\n" + _elementLibs --añade las librerias si hay
					if _elementControls != "" then _nodeInfo += "\n\ncontroles:\n" + _elementControls --añade los controles si hay
					if _elementRollouts != "" then _nodeInfo += "\n\nrollouts:\n" + _elementRollouts --añade los rollouts si hay
					if _elementFunctions != "" then _nodeInfo += "\n\nfunctions:\n" + _elementFunctions --añade las FUNCTIONS si hay
					if _elementEvents != "" then _nodeInfo += (if _elementFunctions != "" then "" else "\n") + "\nevents:\n" + _elementEvents --añade los EVENTS si hay	
				)
				
				"type":
				(
					_helpInfo = helpNode.getNode (infoLabel as string)
					if _helpInfo != undefined then _nodeInfo = _helpInfo.getContent()
				)--type
				
				"name":
				(
					_helpInfo = helpNode.getNode (infoLabel as string)
					if _helpInfo != undefined then _nodeInfo = _helpInfo.getContent()
				)--name
				
				"description":
				(
					_helpInfo = helpNode.getNode (infoLabel as string)
					if _helpInfo != undefined then _nodeInfo = _helpInfo.getContent()
				)--description
				
				"default":
				(
					_helpInfo = helpNode.getNode (infoLabel as string)
					if _helpInfo != undefined then _nodeInfo = _helpInfo.getContent()
				)--default
					
				"vars":
				(
					_helpInfo = helpNode.getNodes "subElements/var"
					for i=1 to _helpInfo.count do --recorre las varaibles buscando las que no sean librerias/sublibrerias.
					(
						_var = _helpInfo[i] --almacena la variable de la iteracion actual del bucle.
						_subElements = _var.getNode "subElements" --recopila los subelementos de la variable para ver si es una libreria.
						
 						if _subElements == undefined then --si no tiene subelementos es porque no es una librería, luego es una variable normal y la procesa.
						(
							_elementType =			this.getHelpNodeInfo _var #type
							_elementName =			this.getHelpNodeInfo _var #name
							_elementDescription =	this.getHelpNodeInfo _var #description
							
							_nodeInfo += (if _nodeInfo != "" then "\n" else "") + "	" + _elementName + " | " + _elementDescription
 						)--if _subElements						
					)--for
				)--vars
				
				"libraries":
				(
					_helpInfo = helpNode.getNodes "subElements/var"
					for i=1 to _helpInfo.count do --recorre las varaibles buscando las que sean librerias/sublibrerias.
					(
						_var = _helpInfo[i] --almacena la variable de la iteracion actual del bucle.
						_subElements = _var.getNode "subElements/struct" --recopila los subelementos de la variable para ver si es una libreria.
						
 						if _subElements != undefined then --si no tiene subelementos es porque no es una librería, luego es una variable normal y la procesa.
						(
							_elementType =			this.getHelpNodeInfo _var #type
							_elementName =			this.getHelpNodeInfo _var #name
							_elementDescription =	this.getHelpNodeInfo _var #description
							
							_nodeInfo += (if _nodeInfo != "" then "\n" else "") + "	" + _elementName + " | " + _elementDescription
 						)--if _subElements						
					)--for
				)--libraries
				
				"controls":
				(
					_helpInfo = helpNode.getNodes "subElements/control"
					for i=1 to _helpInfo.count do
					(
						_var = _helpInfo[i] --almacena la variable de la iteracion actual del bucle.
						
						_elementType =			this.getHelpNodeInfo _var #type
						_elementName =			this.getHelpNodeInfo _var #name
						_elementDescription =	this.getHelpNodeInfo _var #description
						
						_nodeInfo += (if _nodeInfo != "" then "\n" else "") + "	" + _elementName + " | " + _elementDescription
					)--for
				)--controls
				
				"rollouts":
				(
					_helpInfo = helpNode.getNodes "subElements/var"
					for i=1 to _helpInfo.count do --recorre las varaibles buscando las que sean librerias/sublibrerias.
					(
						_var = _helpInfo[i] --almacena la variable de la iteracion actual del bucle.
						_subElements = _var.getNode "subElements/rollout" --recopila los subelementos de la variable para ver si es una libreria.
						
 						if _subElements != undefined then --si no tiene subelementos es porque no es una librería, luego es una variable normal y la procesa.
						(
							_elementType =			this.getHelpNodeInfo _var #type
							_elementName =			this.getHelpNodeInfo _var #name
							_elementDescription =	this.getHelpNodeInfo _var #description
							
							_nodeInfo += (if _nodeInfo != "" then "\n" else "") + "	" + _elementName + " | " + _elementDescription
 						)--if _subElements						
					)--for
				)--rollouts
				
				"functions":
				(
					_helpInfo = helpNode.getNodes "subElements/fn"
					for i=1 to _helpInfo.count do --recorre las FUNCTIONS
					(
						_var = _helpInfo[i] --almacena la variable de la iteracion actual del bucle.
												
 						_elementType =			this.getHelpNodeInfo _var #type
						_elementName =			this.getHelpNodeInfo _var #name
						_elementDescription =	this.getHelpNodeInfo _var #description
						_elementParams =		this.getHelpNodeInfo _var #params --obtiene los parámetros de la función
						_elementOpts =			this.getHelpNodeInfo _var #optional --obtiene los parámetros opcionales de la función
						_elementReturn =		this.getHelpNodeInfo _var #return --obtiene el valor de return de la función
						
						_nodeInfo += (if _nodeInfo != "" then "\n" else "") + "	" + _elementName + " | " + _elementDescription + "\n"
						if _elementParams != "" then _nodeInfo += _elementParams
						if _elementOpts != "" then _nodeInfo += _elementOpts
						if _elementReturn != "" then _nodeInfo += _elementReturn						
					)--for
				)--functions
				
				"events":
				(
					_helpInfo = helpNode.getNodes "subElements/event"
					for i=1 to _helpInfo.count do --recorre los EVENTS
					(
						_var = _helpInfo[i] --almacena la variable de la iteracion actual del bucle.
												
 						_elementType =			this.getHelpNodeInfo _var #type
						_elementName =			this.getHelpNodeInfo _var #name
						_elementDescription =	this.getHelpNodeInfo _var #description
						_elementControls =		this.getHelpNodeInfo _var #control --obtiene el control afectado por el evento.
						_elementParams =		this.getHelpNodeInfo _var #params --obtiene los parámetros del evento.
						
						_nodeInfo += (if _nodeInfo != "" then "\n" else "") + "	" + _elementName + " | " + _elementDescription + "\n"
						if _elementControls != "" then _nodeInfo += _elementControls
						if _elementParams != "" then _nodeInfo += _elementParams						
					)--for
				)--events
				
				"params": --parámetros de FUNCTIONS o EVENTS
				(
					_helpInfo = helpNode.getNodes "param"
					for i=1 to _helpInfo.count do --recorre los parametros
					(
						_var = _helpInfo[i] --almacena la variable de la iteracion actual del bucle.
						
 						_elementType =			this.getHelpNodeInfo _var #type
						_elementName =			this.getHelpNodeInfo _var #name
						_elementDescription =	this.getHelpNodeInfo _var #description
							
						_nodeInfo += "		param: " + _elementName + " | " + _elementType + " | " + _elementDescription + "\n"
					)--for
				)--params
				
				"optional": --parámetros opcionales de FUNCTIONS
				(
					_helpInfo = helpNode.getNodes "optional"
					for i=1 to _helpInfo.count do --recorre los parámetros opcionales
					(
						_var = _helpInfo[i] --almacena la variable de la iteracion actual del bucle.
						
 						_elementType =			this.getHelpNodeInfo _var #type
						_elementName =			this.getHelpNodeInfo _var #name
						_elementDefault =		this.getHelpNodeInfo _var #default
						_elementDescription =	this.getHelpNodeInfo _var #description
							
						_nodeInfo += "		optional: " + _elementName + " | " + _elementType + " | " + _elementDefault + " | " + _elementDescription + "\n"
					)--for
				)--optional
				
				"Control": --elemento afectado por una evento.
				(
					_helpInfo = helpNode.getNode "control"
					if _helpInfo != undefined then --si tiene control
					(
						_elementType =			this.getHelpNodeInfo _helpInfo #type
						_elementName =			this.getHelpNodeInfo _helpInfo #name
						_elementDescription =	this.getHelpNodeInfo _helpInfo #description
							
						_nodeInfo += "		control: " + _elementType + " | " + _elementName + " | " + _elementDescription + "\n"
					)--for
				)--return
				
				"return": --valor que devuelve la función
				(
					_helpInfo = helpNode.getNode "return"
					if _helpInfo != undefined then --si tiene return
					(
						_elementType =			this.getHelpNodeInfo _helpInfo #type
						_elementDescription =	this.getHelpNodeInfo _helpInfo #description
							
						_nodeInfo += "		return: " + _elementType + " | " + _elementDescription + "\n"
					)--for
				)--return
			)--case infoLabel
				
			_nodeInfo
		),
		
		------------------------------------------------
		--@fn: string | getHelp | Devuelve un string con la ayuda de la librería
		--@gets: string | pattern | El patrón indica la jerarquia de ayuda que se solicita. Ejemplo: pattern:"lb.collection" te devolvería la ayuda de la librería collection.
		--@opt: name | filter | all | Filtros para elegir que partes de la ayuda del elemento soicitado se tienen que devolver. Por defecto 'all'; Se pueden solicitar también: vars, libraries, rollouts, functions, events, control.
		------------------------------------------------
		fn getHelp pattern filter:#all =
		(
			if ((classof pattern) != String) or pattern == "" then pattern = "lb"
			
			_helpString = ""
			
			if pattern == "" then --si no hay patron devuelve todo el arbol de ayuda.
			(
				_helpString = this.helpTree.toString()
			)
			else --si hay patron lo filtra.
			(
				_patternParts = filterString pattern "." --divide el patron por subelementos solicitados.
				
				--solo si el nodo raiz del arbol de ayuda coincide con la primera parte del patron solicitado se procede
				if ((this.helpTree.getRoot()).getNode "name").getContent() == _patternParts[1] then
				(
					_currElement = this.helpTree.getRoot() --coge como elemento inicial la raiz del arbol de ayuda.
					
					--recorre las siguientes partes buscando 
					for i=2 to _patternParts.count do
					(
						_subLibraries = _currElement.getNodes "subElements/var/subElements/struct/" --obtiene las sublibrerias
						_subLibraries += _currElement.getNodes "subElements/var/subElements/rollout/" --obtiene los rollouts
						
						_stop = false --flag de parada
						for element in _subLibraries where not _stop do 
						(
							if ((element.getNode "name").getContent()) == _patternParts[i] then
							(
								_currElement = element
							)--if
						)--for
					)--for
					
					--recopila la información del elemento de ayuda solicitado y encotrado; Y lo presenta en un string legible.
					_helpString += this.getHelpNodeInfo _currElement #all filter:filter			
				)--if
			)--if else
			
			_helpString
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createHelpFile | Extrae la información de ayuda del archivo indicado y la almacena en otro. Sobreescribe siempre el target.
		--@gets: string | sourceFile | Ruta del archivo del que extraer la ayuda.
		--@gets: string | targetFile | Ruta del archivo en el que almacenar la ayuda.
		------------------------------------------------
		fn createHelpFile sourceFile targetFile =
		(
			--solo si existe el archivo origen se puede procesar
			if doesFileExist sourceFile then
			(
				---------------------------------------------------------------------
				--lee el archivo completo y lo almacena en un array
				_sourceLines = #() --array para almacenar todo el contenido del script
				f = openfile sourceFile mode:"r"
				while not eof f do append _sourceLines (readLine f)
				close f
				---------------------------------------------------------------------
					
				---------------------------------------------------------------------
				_helpStack = lb.collection.newStack() --crea una pila para poder ir bajando y subiendo niveles en el arbol de ayuda.
				_helpTree = lb.collection.newTree() --crea una pila para ir almacenando la ayuda por niveles.
				
				_currElement = _helpTree.getRoot() --obtiene el nodo root del arbol
				_currElement.setName (getFileNameFile sourceFile)
				_helpStack.push _currElement --almacena el nodo actual en la pila
				
				--estado actual de busqueda. A medida que se profundiza en el arbol de codigo y ayuda, hay que cambiar de estado
				_state = #element 
				
				for _line in _sourceLines do --recorre todas las lineas del documento.
				(
					_trimLine = lb.str.removeSpaces _line onlyInitial:true --elimina los espacios iniciales
					
					if (findString _trimLine "--@" != undefined) and (findString _trimLine "--helpIgnore" == undefined) then --helpIgnore --ignora esta línea al procesar la ayuda para que no se equivoque.
					(
						_lineParts = filterString _trimLine "@" --separa la informacion de la linea para quedarse solo con la de la ayuda
						_helpInfo = if _lineParts.count == 1 then _lineParts[1] else if _lineParts.count == 2 then _lineParts[2] --se queda solo con la parte de la ayuda
						
						_helpInfoParts = filterString _helpInfo "#" --si son varias lineas en una sola las separa en varias
						
						for i=1 to _helpInfoParts.count do --recorre las lineas de ayuda
						(
							_helpInfoParts[i] = lb.str.removeSpaces _helpInfoParts[i] onlyInitial:true --quita los espacios iniciales.
							
							--en funcion del estado de busqueda del recorrido, hay que procesar la linea de una forma u otra
							case _state of
							(
								#element: --estsa buscando un elemento inicial de ayuda (struct, funcion, variable...)
								(
									_elementParts = filterString _helpInfoParts[i] "|" --las partes de la ayuda en elementos estan separadas por |
									_elementParts[1] = lb.str.removeSpaces _elementParts[1] --elimina los espacios de la primera parte
									
									_otherCase = true --flag para los casos que no sean principales
									
									case _elementParts.count of --segun el numero de partes
									(
										3: --struct, var.
										(
											_elementParts[2] = lb.str.removeSpaces _elementParts[2] --elimina los espacios de la segunda parte
											
											--en función del tipo de elemento que sea, hay que saltar a un estado o a otro
											case _elementParts[1] of
											(
												"rollout":
												(
													_helpElement = this.helpElement() --crea el nodo de ayuda.
													_helpElement.setType _elementParts[1] --almacena el tipo del elemento de ayuda
													_helpElement.setName _elementParts[2] --almacena el nombre del elemento de ayuda
													_elementParts[3] = (lb.str.removeSpaces _elementParts[3] onlyInitial:true)
													_elementParts[3] = (lb.str.removeSpaces _elementParts[3] onlyFinal:true)
													_helpElement.setDescription _elementParts[3] --almacena la descripcion del elemento de ayuda
													_currElement = (_helpStack.top()).newChild _elementParts[1] content:_helpElement --añade el elemento de ayuda al árbol.
													_otherCase = false
												)--rollout
												
												"struct":
												(
													_helpElement = this.helpElement() --crea el nodo de ayuda.
													_helpElement.setType _elementParts[1] --almacena el tipo del elemento de ayuda
													_helpElement.setName _elementParts[2] --almacena el nombre del elemento de ayuda
													_elementParts[3] = (lb.str.removeSpaces _elementParts[3] onlyInitial:true)
													_elementParts[3] = (lb.str.removeSpaces _elementParts[3] onlyFinal:true)
													_helpElement.setDescription _elementParts[3] --almacena la descripcion del elemento de ayuda
													_currElement = (_helpStack.top()).newChild _elementParts[1] content:_helpElement --añade el elemento de ayuda al árbol.
													_otherCase = false
												)--struct
												
												"var":
												(
													_helpElement = this.helpElement() --crea el nodo de ayuda.
													_helpElement.setType _elementParts[1] --almacena el tipo del elemento de ayuda
													_helpElement.setName _elementParts[2] --almacena el nombre del elemento de ayuda
													_elementParts[3] = (lb.str.removeSpaces _elementParts[3] onlyInitial:true)
													_elementParts[3] = (lb.str.removeSpaces _elementParts[3] onlyFinal:true)
													_helpElement.setDescription _elementParts[3] --almacena la descripcion del elemento de ayuda
													_currElement = (_helpStack.top()).newChild _elementParts[1] content:_helpElement --añade el elemento de ayuda al árbol.
													_otherCase = false
												)--var
												
												"control":
												(
													_helpElement = this.helpElement() --crea el nodo de ayuda.
													_helpElement.setType _elementParts[1] --almacena el tipo del elemento de ayuda
													_helpElement.setName _elementParts[2] --almacena el nombre del elemento de ayuda
													_elementParts[3] = (lb.str.removeSpaces _elementParts[3] onlyInitial:true)
													_elementParts[3] = (lb.str.removeSpaces _elementParts[3] onlyFinal:true)
													_helpElement.setDescription _elementParts[3] --almacena la descripcion del elemento de ayuda
													_currElement = (_helpStack.top()).newChild _elementParts[1] content:_helpElement --añade el elemento de ayuda al árbol.
													_otherCase = false
												)--control
											)--case _elementParts[1]
										)--3
										
										2: --fn, event.
										(
											_elementParts[2] = lb.str.removeSpaces _elementParts[2] --elimina los espacios de la segunda parte
											
											--en función del tipo de elemento que sea, hay que saltar a un estado o a otro
											case _elementParts[1] of
											(
												"fn":
												(
													_helpElement = this.helpElement() --crea el nodo de ayuda.
													_helpElement.setType _elementParts[1] --almacena el tipo del elemento de ayuda
													_helpElement.setName _elementParts[2] --almacena el nombre del elemento de ayuda													
													_currElement = (_helpStack.top()).newChild _elementParts[1] content:_helpElement --añade el elemento de ayuda al árbol.
													_otherCase = false
												)--fn
												
												"event":
												(
													_helpElement = this.helpElement() --crea el nodo de ayuda.
													_helpElement.setType _elementParts[1] --almacena el tipo del elemento de ayuda
													_helpElement.setName _elementParts[2] --almacena el nombre del elemento de ayuda													
													_currElement = (_helpStack.top()).newChild _elementParts[1] content:_helpElement --añade el elemento de ayuda al árbol.
													_otherCase = false
												)--event
											)--case _elementParts[1]
										)--2
									)--case
									
									--otros casos------------------------------------------
									if _otherCase then
									(
										--desc
										if (matchPattern _helpInfoParts[i] pattern:"desc:*") then
										(
											_desc = lb.str.removeSpaces (substituteString _helpInfoParts[i] "desc:" "") onlyInitial:true
											_desc = lb.str.removeSpaces _desc onlyFinal:true
											(_currElement.getContent()).setDescription _desc
										)--desc
										
										--control
										if (matchPattern _helpInfoParts[i] pattern:"control:*") then
										(
											--separa las partes del returns y quita los espacios que no necesita.
											_control = lb.str.removeSpaces (substituteString _helpInfoParts[i] "control:" "") onlyInitial:true
											_controlParts = filterString _control "|"
											_controlParts[1] = lb.str.removeSpaces _controlParts[1]
											_controlParts[2] = lb.str.removeSpaces _controlParts[2]
											_controlParts[3] = lb.str.removeSpaces _controlParts[3] onlyInitial:true
											_controlParts[3] = lb.str.removeSpaces _controlParts[3] onlyFinal:true
											
											(_currElement.getContent()).setControlType _controlParts[1]
											(_currElement.getContent()).setControlName _controlParts[2]
											(_currElement.getContent()).setControlDescription _controlParts[3]											
										)--control
										
										--gets
										if (matchPattern _helpInfoParts[i] pattern:"gets:*") then
										(
											--separa las partes del get y quita los espacios que no necesita.
											_get = lb.str.removeSpaces (substituteString _helpInfoParts[i] "gets:" "") onlyInitial:true
											_getParts = filterString _get "|"
											_getParts[1] = lb.str.removeSpaces _getParts[1]
											_getParts[2] = lb.str.removeSpaces _getParts[2]
											_getParts[3] = lb.str.removeSpaces _getParts[3] onlyInitial:true
											_getParts[3] = lb.str.removeSpaces _getParts[3] onlyFinal:true
											
											--obtine los parametros actuales del elemento de ayuda para añadirles el que se está procesando en ese momento.
											_getsTypes = (_currElement.getContent()).getGetsTypes()
											_getsNames = (_currElement.getContent()).getGetsNames()
											_getsDescriptions = (_currElement.getContent()).getGetsDescriptions()
											
											(_currElement.getContent()).setGetsTypes (_getsTypes + #(_getParts[1]))
											(_currElement.getContent()).setGetsNames (_getsNames + #(_getParts[2]))
											(_currElement.getContent()).setGetsDescriptions (_getsDescriptions + #(_getParts[3]))
										)--gets
										
										--opts
										if (matchPattern _helpInfoParts[i] pattern:"opt:*") then
										(
											--separa las partes del get y quita los espacios que no necesita.
											_opt = lb.str.removeSpaces (substituteString _helpInfoParts[i] "opt:" "") onlyInitial:true
											_optParts = filterString _opt "|"
											_optParts[1] = lb.str.removeSpaces _optParts[1]
											_optParts[2] = lb.str.removeSpaces _optParts[2]
											_optParts[3] = lb.str.removeSpaces _optParts[3]
											_optParts[4] = lb.str.removeSpaces _optParts[4] onlyInitial:true
											_optParts[4] = lb.str.removeSpaces _optParts[4] onlyFinal:true
											
											--obtine los parametros actuales del elemento de ayuda para añadirles el que se está procesando en ese momento.
											_optsTypes = (_currElement.getContent()).getOptsTypes()
											_optsNames = (_currElement.getContent()).getOptsNames()
											_optsDefaults = (_currElement.getContent()).getOptsDefaults()
											_optsDescriptions = (_currElement.getContent()).getOptsDescriptions()
											
											(_currElement.getContent()).setOptsTypes (_optsTypes + #(_optParts[1]))
											(_currElement.getContent()).setOptsNames (_optsNames + #(_optParts[2]))
											(_currElement.getContent()).setOptsDefaults (_optsDefaults + #(_optParts[3]))
											(_currElement.getContent()).setOptsDescriptions (_optsDescriptions + #(_optParts[4]))
										)--opts
										
										--returns
										if (matchPattern _helpInfoParts[i] pattern:"returns:*") then
										(
											--separa las partes del returns y quita los espacios que no necesita.
											_return = lb.str.removeSpaces (substituteString _helpInfoParts[i] "returns:" "") onlyInitial:true
											_returnParts = filterString _return "|"
											_returnParts[1] = lb.str.removeSpaces _returnParts[1]
											_returnParts[2] = lb.str.removeSpaces _returnParts[2] onlyInitial:true
											_returnParts[2] = lb.str.removeSpaces _returnParts[2] onlyFinal:true
											
											(_currElement.getContent()).setReturnType _returnParts[1]
											(_currElement.getContent()).setReturnDescription _returnParts[2]											
										)--returns
									)
									---------------------------------------------------------
									
								)--#element
							)--case
						)--for
					)
					else --si no es una línea de ayuda hay que mirar si se baja de nivel en el arbol o no en función de los paréntesis del código
					(
						_bracketStack = lb.collection.newStack() --crea una pila para contar paréntesis.
						
						for i=1 to _trimLine.count do
						(
							case _trimLine[i] of
							(
								"(":--apertura de paréntesis
								(
									_helpStack.push _currElement
								)--apertura de paréntesis
								
								")":--cierre de paréntesis
								(
									_currElement = _helpStack.pull()
								)--cierre de paréntesis
							)--case
						)--for
					)--if else
				)--for			
				---------------------------------------------------------------------
				
				---------------------------------------------------------------------
				--crea el archivo de ayuda y escribe dentro en forma de xml la estructura de arbol devuelta por el arbol de ayuda.
				f = openFile targetFile mode:"w"
				format (_helpTree.toString childrenExplicitNode:true childrenExplicitNodeLabel:"subElements") to:f
				close f
				---------------------------------------------------------------------
				
			)--if doesFileExist			
		),
		
		------------------------------------------------
		--@fn: undefined | generateHelpFiles | Crea o sobrescribe todos los archivos de ayuda de las herramientas.
		------------------------------------------------
		fn generateHelpFiles =
		(
			_scriptsFolder = (getFileNamePath this.selfFile) --path de los scripts
			_helpFolder = (getFileNamePath this.selfFile) + "hlp\\" --path para almacenar los archivos de ayuda
			
			--intenta crear el path y si lo consigue o ya existe continua con el proceso
			if makeDir _helpFolder all:true then
			(
				--recopila los archivos de scripts
				_scriptFiles = lb.io.getFilesFromSubFolders _scriptsFolder extension:"*.ms"
				_scriptFiles += lb.io.getFilesFromSubFolders _scriptsFolder extension:"*.mse"
				
				--por cada archivo de script crea un archivo de ayuda
				for _scrptFile in _scriptFiles do
					this.createHelpFile _scrptFile (_helpFolder + (getFileNameFile _scrptFile) + ".hlp")
				
			)--if makeDir
		),
		
		------------------------------------------------
		--@fn: undefined | readHelpFiles | Lee los archivos de ayuda de las librerías y almacena la información en un árbol de ayuda cargado siempre en memoria.
		------------------------------------------------
		fn readHelpFiles =
		(
			_helpFolder = (getFileNamePath this.selfFile) + "hlp\\" --path de los archivos de ayuda.
			_helpFiles = getFiles (_helpFolder + "*.hlp")
			
			----------------------------------------------
			if _helpFiles.count != 0 then
			(
				-----------------------------------------------------
				--rellena un arbol con la información de todos los archivos de ayuda.
				_helpTree = lb.collection.newTree()
				
				for _helpFile in _helpFiles do
				(
					_xmlDoc = lb.xml.load _helpFile
					
					--funcion recursiva que va duplicando el arbol
					global _duplicateTreeContent
					fn _duplicateTreeContent sourceNode targetNode file:"" = 
					(
						targetNode.setName (sourceNode.getName()) --duplica el nombre
						targetNode.setContent (sourceNode.getText()) --duplica el contenido
						
						case (sourceNode.getName()) of
						(
							"struct":	targetNode.newChild "file" content:file
							"rollout":	targetNode.newChild "file" content:file
							"var":	targetNode.newChild "file" content:file
						)--case
							
						for i=1 to (sourceNode.getChildren()).count do
						(
							targetNode.newChild "temp" --crea un nuevo hijo plantilla
							_duplicateTreeContent (sourceNode.getChildren())[i] (targetNode.getChildren())[(targetNode.getChildren()).count] file:file --llama recusivamente con los hijos
						)--for
					)--fn _duplicateTreeContent					
						
					_duplicateTreeContent (_xmlDoc.getRoot()) (_helpTree.getRoot()) file:_helpFile--rellena todos los niveles del arbol de ayuda
					_duplicateTreeContent = undefined --elimina la funcion temporal
				)--for _helpFile			
				-----------------------------------------------------
				
				-----------------------------------------------------
				--a continuación rellena el árbol definitivo buscando las dependencias entre los elementos leidos de los archivos de ayuda.
				_hierarchyHelpTree = lb.collection.newTree()
				
				_mainLibrary = undefined --librería principal padre de todas.
				_parentElements  = #() --array para almacenar los elementos entre los cuales se pueden encontrar los padres de los elementos hijos.
				_childrenElements = #() --array para almacenar los elementos a los que buscar un padre en el array de elementos padres.
				for n in (_helpTree.getRoot()).getChildren() do _childrenElements += (n.getNodes "subElements/struct") + (n.getNodes "subElements/rollout") --recopila todos los structs y rollouts
				
				--busca el struct principal para ponerlo de candidato a padre y lo saca del array de hijos.
				for i=_childrenElements.count to 1 by -1 where ((_childrenElements[i].getNode "name").getContent()) == "lb" do
				(
					_mainLibrary = _childrenElements[i]
					_parentElements = #(_mainLibrary)
					deleteItem _childrenElements i
				)--for
				
				---------------------------------
				--funcion que va cambiando las jerarquías de los structs de forma recursiva.
				global _assignChildrenToParents
				fn _assignChildrenToParents parents children =
				(
					_newParents = #() --array para el nuevo nivel de padres. Para la siguiente llamada recursiva
					
					--recorre los children buscando en los parent una coincidencia por nombre en alguna de sus variables
					for i=children.count to 1 by -1 do
					(
						_chName = ((children[i].getNode "name").getContent()) --obtiene el nombre del hijo
						_chFile = ((children[i].getNode "file").getContent()) --obtiene el archivo en el que está definido el hijo.
						_sameFileParentCandidate = undefined
						_parentCandidates = #()
						
						for j=1 to parents.count do --recorre los padres candidatos mirando sus variables internas para ver si el hijo es suyo
						(
							_vars = parents[j].getNodes "subElements/var" --obtiene las variables del padre actual
							
							for k=1 to _vars.count do --recorre las variables mirando si coinciden con el hijo actual
							(
								_varName = ((_vars[k].getNode "name").getContent()) --obtiene el nombre de la variable
								
								if _varName == _chName then --si coinciden se ha encontrado a su padre
								(
									if ((_vars[k].getNode "file").getContent()) == _chFile then _sameFileParentCandidate = _vars[k]
									append _parentCandidates (_vars[k])									
								)
							)--for
						)--for
						
						--eligue el padre definitivo si hay candidatos. Elige el padre del mismo fichero si existe, si no no.
						_defParent = undefined --padre definitivo.
						if _sameFileParentCandidate != undefined then _defParent = _sameFileParentCandidate
						else if _parentCandidates.count != 0 then _defParent = _parentCandidates[1]
							
						--si hay un padre que utilizar los rejerarquiza.
						if _defParent != undefined then
						(
							append _newParents children[i]
							_subElements = _defParent.newChild "subElements"
							_subElements.addNode children[i]
							deleteItem children i
						)--if
					)--for
					
					--si quedan hijos y hay nuevos candidatos a padre se llama recursivamente
					if _newParents.count != 0 and children.count != 0 then
						_assignChildrenToParents _newParents children
				)--_assignChildrenToParents
				
				_assignChildrenToParents _parentElements _childrenElements --llama a la funcion para que haga la reasignación de jerarquías.
				
				_assignChildrenToParents = undefined --elimina la funcion recursiva temporal.
				---------------------------------
				
				this.helpTree = lb.collection.newTree() --crea al arbol definitivo de ayuda.
				(this.helpTree).setRoot _mainLibrary --coloca la librería principal como padre del arbol de ayuda.
				-----------------------------------------------------				
			)--if _helpFiles
			----------------------------------------------
			
			ok
		),
		
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con el arbol de ayuda si está creado. Si no, devuelve información de la librería.
		------------------------------------------------
		fn toString =
		(
			if this.helpTree != undefined then this.helpTree.toString()
			else ("No help info found")
		),--toString
		
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
		
	)--lib_help
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_help() --crea la libreria
)