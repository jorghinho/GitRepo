------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Librerías y structs de manejo de archivos xml
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: xmlElement | Contiene todas las funciones de un elemento xml.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_xmlElement
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		parent = undefined,			--@var: parent | Elemento padre del actual
		
		elementName = "",			--@var: elementName | Nombre del nodo
		text = "",					--@var: text | Texto del elemento
		propertyNames = #(),		--@var: propertyNames | Nombres de las propiedades del elemento
		propertyValues = #(),		--@var: propertyValues | Valores de las propiedades del elemento
		nodes = #(),				--@var: nodes | Nodos hijos del elemento
		
		-------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: xmlElement | getParent | Devuelve el elemento xml padre si lo hay, si no, devuelve undefined.
		------------------------------------------------
		fn getParent = this.parent,
			
		------------------------------------------------
		--@fn: string | getName | Devuelve el nombre del elemento xml
		------------------------------------------------
		fn getName = this.elementName,
		
		------------------------------------------------
		--@fn: string | getText | Devuelve el contenido del elemento xml.
		------------------------------------------------
		fn getText = this.text,
		
		------------------------------------------------
		--@fn: array{string} | getPropNames | Devuelve el un array con los nombres de las propiedades del elemento xml.
		------------------------------------------------
		fn getPropNames = this.propertyNames,
			
		------------------------------------------------
		--@fn: array{object} | getPropValues | Devuelve el un array con los valores de las propiedades del elemento xml.
		------------------------------------------------
		fn getPropValues = this.propertyValues,
			
		------------------------------------------------
		--@fn: object | getPropValues | Devuelve una propiedad por su nombre o indice.
		--@gets: string | propName | Nombre 'string' de la propiedad solicitada en el array de propiedades.
		------------------------------------------------
		fn getProperty propName =
		(
			_theValue = undefined
			
			_index = findItem this.propertyNames propName
			if _index != 0 then _theValue = this.propertyValues[_index]
			
			_theValue
		),
		
		------------------------------------------------
		--@fn: xmlElement | getChildByName | Devuelve el primer elemento xml hijo que tenga el nombre pasado por parametro.
		--@gets: string | childName | Nombre del elemento xml hijo solicitado.
		------------------------------------------------
		fn getChildByName childName =
		(
			_theChild = undefined
			
			_stop = false			
			for ch in this.nodes where (ch.getName() == childName) and not _stop do (_theChild = ch; _stop = true)
				
			_theChild
		),
		
		------------------------------------------------
		--@fn: array{xmlElement} | getChildrenByName | Devuelve los elementos xml hijos que tengan el nombre pasado por parametro.
		--@gets: string | childName | Nombre de los elementos xml hijos solicitados.
		------------------------------------------------
		fn getChildrenByName childName =
		(
			_theChildren = #()
				
			for ch in this.nodes where (ch.getName() == childName) do append _theChildren ch
				
			_theChildren
		),
		
		------------------------------------------------
		--@fn: array{xmlElement} | getChildren | Devuelve todos los elementos xml hijos.
		------------------------------------------------		
		fn getChildren = this.nodes,
		
		------------------------------------------------
		--@fn: xmlElement | getNode | Devuelve el primer elemento xml que ocupe el lugar marcado por el parametro 'nodeTreePath' a partir del elemento actual.
		--@gets: string | nodeTreePath | Patrón de jerarquía de elemento xml que se solicita. Ejemplo: "elemento1/elemento2/elemento4"
		--@opt: string | propertyName | undefined | Porpiedad que debe tener el nodo a ser devueltos.
		--@opt: string | propertyValue | undefined | Valor de la propiedad que debe tener el nodo a ser devuelto.
		--@example: nodeTreePath = "elemento1/elemento2/elemento4" devuelve el nodo nieto de elemento1 y que se llama elemento4 si existe
		--@<elemento1>
		--@  <elemento2>
		--@    <elemento3>test3</elemento3>
		--@    <elemento4>test4</elemento4>
		--@  </elemento2>
		--@</elemento1>
		--@exampleEnd:
		------------------------------------------------
		fn getNode nodeTreePath propertyName:undefined propertyValue:undefined = 
		(
			_theNode = undefined
			
			--descompone los niveles y obtiene el nodo inicial
			_levelParts = FilterString nodeTreePath "/"
			_currElement = this
			
			_level = 1 --nivel actual
			_stop = false --flag de parada
			for i=1 to _levelParts.count where not _stop do
			(
				_found = false
				
				for n in _currElement.getChildren() where not _stop and not _found do
				(
					if n.getName() == _levelParts[i] then
					(
						_currElement = n
						_found = true
					)--if
				)--for
				
				if not _found then _stop = true				
				if i == _levelParts.count then
				(
					_stop = true
					
					--si se ha solicitado un nodo con una propiedad conctreta solo lo devuelve si el nodo encontrado tiene la propiedad
					if propertyName != undefined then
					(
						if (findItem _currElement.propertyNames propertyName) != 0 then --si el nodo tiene la propiedad
						(
							if propertyValue != undefined then --si se exige tambien que coincida el valor de la propiedad
							(
								if (_currElement.getProperty propertyName) == propertyValue then _theNode = _currElement
							)
							else
							(
								_theNode = _currElement
							)--if							
						)--if
					)
					else
					(
						_theNode = _currElement
					)--if
				)--if
			)--for
			
			_theNode --devuelve el nodo
		),
		
		------------------------------------------------
		--@fn: array{xmlElement} | getNodes | Devuelve los elementos xml que ocupen el lugar marcado por el parametro 'nodeTreePath' a partir del elemento actual.
		--@gets: string | nodeTreePath | Patrón de jerarquía de elementos xml que se solicitan. Ejemplo: "elemento1/elemento2/elemento4".
		--@opt: string | propertyName | undefined | Porpiedad que deben tener los nodos a ser devueltos.
		--@opt: string | propertyValue | undefined | Valor de la propiedad que deben tener los nodos a ser devueltos.
		--@example: nodeTreePath = "elemento1/elemento2/elemento4" devuelve los nodos nietos de elemento1 y que se llamen elemento4 si existen.
		--@<elemento1>
		--@  <elemento2>
		--@    <elemento3>test3</elemento3>
		--@    <elemento4>test4</elemento4>
		--@  </elemento2>
		--@  <elemento2>
		--@    <elemento3>test5</elemento3>
		--@    <elemento4>test6</elemento4>
		--@  </elemento2>
		--@</elemento1>
		--@exampleEnd:
		------------------------------------------------
		fn getNodes nodeTreePath propertyName:undefined propertyValue:undefined = 
		(
			_theNodes = #()
			
			global _getNodesByPattern --define la funcion temporal
				
			--funcion recursiva temporal para ir recopilando los nodos que cumplen el patron
			fn _getNodesByPattern theNode thePattern =
			(
				_nodes = #()
				
				--descompone los niveles
				_levelParts = FilterString thePattern "/"
				
				--recorre los hijos mirando si van cumpleindo el patron
				--si es el final del patron recopila los nodos
				for n in theNode.getChildren() where n.getName() == _levelParts[1] do
				(
					if _levelParts.count == 1 then
						append _nodes n
					else
					(
						_newPattern = ""
						for i=2 to _levelParts.count do _newPattern += _levelParts[i] + "/"
						_nodes += _getNodesByPattern n _newPattern
					)
				)
				
				_nodes
			)--getNodesByPattern
			
			_theNodes = _getNodesByPattern this nodeTreePath
			
			--elimina todos los que no tengan la propiedad solicitada si es que se ha solicitado una propiedad
			if propertyName != undefined then
			(
				if propertyValue != undefined then --si aparte de tener la popiedad se exige que cumpla un valor en concreto
				(
					for i = _theNodes.count to 1 by -1 do
					(
						_index = findItem _theNodes[i].propertyNames propertyName
						
						if _index != 0 then --si tiene la propiedad
						(
							--si el valor de la propiedad no coincide lo elimina
							if (_theNodes[i].getProperty propertyName) != propertyValue then deleteItem _theNodes i
						)
						else --si no tiene la propiedad lo elimina
						(
							deleteItem _theNodes i
						)--if else
					)--for
				)
				else --si es suficiente son que tenga la propiedad elimina los que no la tengan
				(
					for i = _theNodes.count to 1 by -1 where (findItem _theNodes[i].propertyNames propertyName) == 0 do deleteItem _theNodes i
				)--if else				
			)--if
			
			_getNodesByPattern = undefined --libera la funcion
			
			_theNodes --devuelve los nodos
		),
			
		------------------------------------------------
		--@fn: xmlElement | getDescendant | Devuelve el subelemento descendiente que cumpla el patron 'ancestorsPath'.
		--@gets: string | knownAncestors | Patron de la jerarquía que se repite periodicamente y hay que obviar.
		--@gets: string | parent | Nombre del parámetro que se busca en cada subnivel.
		--@gets: string | ancestorsPath | Patrón de jerarquía de elemento que se solicita. Ejemplo: "test1/test2/test3"
		--@example: ancestorsPath = "test1/test2/test3" devuelve el nodo nieto de test1 y que se llama test3 si existe
		--@<parts>
		--@  <part>
		--@    <type>test1</type>
		--@    <parts>
		--@      <part>
		--@        <type>test2</type>
		--@          <parts>
		--@            <part>
		--@              <type>test3</type>
		--@            </part>
		--@          </parts>
		--@        </part>
		--@      </parts>
		--@  </part>
		--@</parts>
		--@exampleEnd:
		------------------------------------------------
		fn getDescendant knownAncestors parent partTypePath =
		(
			_thePart = undefined
			
			_hits = filterString partTypePath "//" --separa las partes del path a encontrar
			_current = this --elige como elemento actual la raiz de xml
			_stop = false
			
			for i=1 to _hits.count where not _stop do --recorre todas las partes del path buscando un nivel más profundo cada vez
			(
				_theParts = _current.getNodes knownAncestors --obtiene las subpartes
				_found = false
				
				for _part in _theParts where not _found do --recorre las subpartes  buscando la parte actual
				(
					_type = _part.getNode parent --obtiene el tipo
					if _type.getText() == _hits[i] then (_current = _part; _found = true) --compara a ver si es el buscado
				)--for
				
				if not _found then _stop = true --si se ha parado la busqueda es que no se ha encontrado
			)--for
			
			if not _stop then _thePart = _current --si la busqueda ha llegado al final es que lo ha encontrado
			
			_thePart --devuelve la busqueda
		),
		
		------------------------------------------------
		--@fn: generic | getSubNodeProperty | Devuelve el valor de la propiedad pasada por parametro en el nodo indicado en la jerarquia. Si no tiene esa propiedad devuelve undefined
		--@gets: string | nodeTreePath | Patrón de jerarquía de elementos xml que se solicitan. Ejemplo: "elemento1/elemento2/elemento4".
		--@gets: string | propName | Nombre de la propiedad que se solicita.		
		------------------------------------------------
		fn getSubNodeProperty nodeTreePath propName =
		(
			_propValue = undefined
			
			_node = this.getNode nodeTreePath propertyName:propName --obtiene el subnodo que cumpla el path y que tenga la propiedad
			if _node != undefined then _propValue = (_node.getProperty propName) --obtiene el valor de la propiedad
				
			_propValue
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setParent | Almacena el elemento xml padre.
		--@gets: xmlElement | newParent | Nuevo elemento xml padre.
		------------------------------------------------
		fn setParent newParent = (this.parent = newParent),
		
		------------------------------------------------
		--@fn: undefined | setName | Almacena el nombre del elemento xml.
		--@gets: string | newName | Nuevo nombre del elemento xml.
		------------------------------------------------
		fn setName newName = (this.elementName = newName),
		
		------------------------------------------------
		--@fn: undefined | setText | Almacena el contenido del elemento xml.
		--@gets: string | newText | Nuevo contenido del elemento xml.
		------------------------------------------------
		fn setText newText = (this.text = newText),
		
		------------------------------------------------
		--@fn: undefined | setPropNames | Almacena los nombres de las propiedades del elemento xml.
		--@gets: array{string} | newPropNames | Nuevo array de nombres de propiedades del elemento xml.
		------------------------------------------------
		fn setPropNames newPropNames = (this.propertyNames = newPropNames),
			
		------------------------------------------------
		--@fn: undefined | setPropValues | Almacena los valores de las propiedades del elemento xml.
		--@gets: array{object} | newPropValues | Nuevo array de Valores de propiedades del elemento xml. Pueden ser de cualquier tipo.
		------------------------------------------------
		fn setPropValues newPropValues = (this.propertyValues = newPropValues),
		
		------------------------------------------------
		--@fn: undefined | setProperty | Almacena el valor de una propiedad del elemento xml a partir de su nobre
		--@gets: string | propName | Nombre 'string'  de la propiedad a almacenar
		--@gets: object | propValue | Valor que se quiere almacenar en esa propiedad. Puede ser de cualquier tipo
		------------------------------------------------
		fn setProperty propName propValue =
		(
			_index = findItem this.propertyNames propName
			
			if _index != 0 then --si la propiedad existe la sobrescribe
			(
				this.propertyValues[_index] = propValue
			)
			else --si la propiedad no existita la añade
			(
				append this.propertyNames propName
				append this.propertyValues propValue
			)
		),
		
		------------------------------------------------
		--@fn: undefined | setChildren | Almacena los elementos xml hijos del elemento xml.
		--@gets: array{xmlElement} | newNodes | Nuevo array de elementos xml hijos.
		------------------------------------------------
		fn setChildren newNodes = (this.nodes = newNodes),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
			
		------------------------------------------------
		--@fn: undefined | removeChildren | Elimina todos los hijos del elemento xml.
		------------------------------------------------
		fn removeChildren = (this.nodes = #()),

		------------------------------------------------
		--@fn: undefined | addNode | Añade un nuevo elemento xml hijo.
		--@gets: xmlElement | xmlChildElement | Nuevo elemento xml hijo.
		------------------------------------------------
		fn addNode xmlChildElement =
		(
			appendIfUnique this.nodes xmlChildElement
		),
		
		------------------------------------------------
		--@fn: xmlElement | newChild | Crea un nuevo elemento xml hijo y lo devuelve.
		--@gets: string | childName | Nombre que va a tener el nuevo elemento xml hijo.
		------------------------------------------------
		fn newChild childName =
		(
			_newChild = def elementName:childName
			
			append this.nodes _newChild
			
			_newChild
		),
		
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la información del nodo y sus subnodos recursivamente.
		--@opt: integer | level | 1 | Numero de niveles que debe profundizar las funcion de forma recursiva extrayendo la informacion de los hijos.
		------------------------------------------------
		fn toString level:1 =
		(
			_theString = ""
			
			--añade tabuladores segun el nivel
			for i=1 to (level - 1) do _theString += "  "
			
			--añade el nombre del nodo
			_theString += "<" + this.elementName
			
			--si tiene propiedades internas hay que meterlas
			if this.propertyNames.count != 0 then
				for i=1 to this.propertyNames.count do
					_theString += " " + this.propertyNames[i] + "=\"" + (this.propertyValues[i] as string) + "\""

			if this.nodes.count != 0 then --si tiene hijos los añade
			(
				_theString += ">"
				
				for n in this.nodes do _theString += "\n" + n.toString level:(level+1)
				
				_theString += "\n"
				for i=1 to (level - 1) do _theString += "  " --añade tabuladores segun el nivel
				_theString += "</" + this.elementName + ">" --añade el nombre del nodo
			)
			else if this.text != "" then
			(
				_theString += ">" + this.text --añade el texto del nodo
				_theString += "</" + this.elementName + ">" --añade el nombre del nodo
			)
			else
			(
				if this.propertyNames.count != 0 then _theString += " "
				_theString += "/>"
			)		
			
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
			
		)
		
	)--lib_xmlElement
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: xmlDoc | Contiene todas las funciones de un documento xml.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_xmlDoc
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		path = "", 						--@var: path | Path del documento.
		root = undefined, 				--@var: root | Nodo raiz del documento.
		
		xmlElement = lib_xmlElement,	--@var: self | Struct de elementos xml.
		
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
		--@fn: string | getPath | Devuelve un string con la ruta del archivo xml.
		------------------------------------------------
		fn getPath = this.path,
			
		------------------------------------------------
		--@fn: xmlElement | getRoot | Devuelve el elmento xml raiz del documento.
		------------------------------------------------
		fn getRoot = this.root,
		
		------------------------------------------------
		--@fn: xmlElement | getNode | Devuelve el primer elemento xml que ocupe el lugar marcado por el parametro 'nodeTreePath'.
		--@gets: string | nodeTreePath | Patrón de jerarquía de elemento xml que se solicita. Ejemplo: "elemento1/elemento2/elemento4"
		--@opt: string | propertyName | undefined | Propiedad que debe tener el nodo a ser devuelto.
		--@opt: string | propertyValue | undefined | Valor de la ropiedad que debe tener el nodo a ser devuelto.
		--@example: nodeTreePath = "elemento1/elemento2/elemento4" devuelve el nodo nieto de elemento1 y que se llama elemento4 si existe
		--@<elemento1>
		--@  <elemento2>
		--@    <elemento3>test3</elemento3>
		--@    <elemento4>test4</elemento4>
		--@  </elemento2>
		--@</elemento1>
		--@exampleEnd:
		------------------------------------------------
		fn getNode nodeTreePath propertyName:undefined propertyValue:undefined = 
		(
			_theNode = undefined
			
			--descompone los niveles y obtiene el nodo inicial
			_levelParts = FilterString nodeTreePath "/"
			_currElement = this.root
			
			_level = 1 --nivel actual
			_stop = false --flag de parada
			for i=1 to _levelParts.count where not _stop do
			(
				_found = false
				
				for n in _currElement.getChildren() where not _stop and not _found do
				(
					if n.getName() == _levelParts[i] then
					(
						_currElement = n
						_found = true
					)--if
				)--for
				
				if not _found then _stop = true				
				if i == _levelParts.count then
				(
					_stop = true
					
					--si se ha solicitado un nodo con una propiedad conctreta solo lo devuelve si el nodo encontrado tiene la propiedad
					if propertyName != undefined then
					(
						if (findItem _currElement.propertyNames propertyName) != 0 then --si el nodo tiene la propiedad
						(
							if propertyValue != undefined then --si se exige tambien que coincida el valor de la propiedad
							(
								if (_currElement.getProperty propertyName) == propertyValue then _theNode = _currElement
							)
							else
							(
								_theNode = _currElement
							)--if							
						)--if
					)
					else
					(
						_theNode = _currElement
					)--if
				)--if
			)--for
			
			_theNode --devuelve el nodo
		),
		
		------------------------------------------------
		--@fn: array{xmlElement} | getNodes | Devuelve los elementos xml que ocupen el lugar marcado por el parametro 'nodeTreePath'.
		--@gets: string | nodeTreePath | Patrón de jerarquía de elementos xml que se solicitan. Ejemplo: "elemento1/elemento2/elemento4"
		--@opt: string | propertyName | undefined | Porpiedad que deben tener los nodos a ser devueltos.
		--@opt: string | propertyValue | undefined | Valor de la ropiedad que deben tener los nodos a ser devueltos.
		--@example: nodeTreePath = "elemento1/elemento2/elemento4" devuelve los nodos nietos de elemento1 y que se llamen elemento4 si existen
		--@<elemento1>
		--@  <elemento2>
		--@    <elemento3>test3</elemento3>
		--@    <elemento4>test4</elemento4>
		--@  </elemento2>
		--@  <elemento2>
		--@    <elemento3>test5</elemento3>
		--@    <elemento4>test6</elemento4>
		--@  </elemento2>
		--@</elemento1>
		--@exampleEnd:
		------------------------------------------------
		fn getNodes nodeTreePath propertyName:undefined propertyValue:undefined = 
		(
			_theNodes = #()
			
			global _getNodesByPattern --define la funcion temporal
				
			--funcion recursiva temporal para ir recopilando los nodos que cumplen el patron
			fn _getNodesByPattern theNode thePattern =
			(
				_nodes = #()
				
				--descompone los niveles
				_levelParts = filterString thePattern "/"
				
				--recorre los hijos mirando si van cumpleindo el patron
				--si es el final del patron recopila los nodos
				for n in theNode.getChildren() where n.getName() == _levelParts[1] do
				(
					if _levelParts.count == 1 then
						append _nodes n
					else
					(
						_newPattern = ""
						for i=2 to _levelParts.count do _newPattern += _levelParts[i] + "/"
						_nodes += _getNodesByPattern n _newPattern
					)
				)
				
				_nodes
			)--getNodesByPattern
			
			_theNodes = _getNodesByPattern this.root nodeTreePath
			
			--elimina todos los que no tengan la propiedad solicitada si es que se ha solicitado una propiedad
			if propertyName != undefined then
			(
				if propertyValue != undefined then --si aparte de tener la popiedad se exige que cumpla un valor en concreto
				(
					for i = _theNodes.count to 1 by -1 do
					(
						_index = findItem _theNodes[i].propertyNames propertyName
						
						if _index != 0 then --si tiene la propiedad
						(
							--si el valor de la propiedad no coincide lo elimina
							if (_theNodes[i].getProperty propertyName) != propertyValue then deleteItem _theNodes i
						)
						else --si no tiene la propiedad lo elimina
						(
							deleteItem _theNodes i
						)--if else
					)--for
				)
				else --si es suficiente son que tenga la propiedad elimina los que no la tengan
				(
					for i = _theNodes.count to 1 by -1 where (findItem _theNodes[i].propertyNames propertyName) == 0 do deleteItem _theNodes i
				)--if else				
			)--if
			
			_getNodesByPattern = undefined --libera la funcion
			
			_theNodes --devuelve los nodos
		),
		
		------------------------------------------------
		--@fn: generic | getAttribute | Devuelve el valor de la propiedad pasada por parametro en el nodo indicado en la jerarquia. Si no tiene esa propiedad devuelve undefined
		--@gets: string | nodeTreePath | Patrón de jerarquía de elementos xml que se solicitan. Ejemplo: "elemento1/elemento2/elemento4".
		--@gets: string | propName | Nombre de la propiedad que se solicita.		
		------------------------------------------------
		fn getAttribute nodeTreePath propName =
		(
			_propValue = ""
			
			_node = this.getNode nodeTreePath propertyName:propName --obtiene el subnodo que cumpla el path y que tenga la propiedad
			if _node != undefined then
			(
				_propValue = (_node.getProperty propName) --obtiene el valor de la propiedad
				if _propValue == undefined then _propValue = ""
			)
				
			_propValue
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setPath | Almacena la ruta del documento xml.
		--@gets: string | newPath | Nueva ruta del documento xml.
		------------------------------------------------
		fn setPath newPath reload:false =
		(
			--solo lo almacena si el fichero existe
			this.path = newPath
				
			--no estoy seguro de que sustituir el path deba leer el archivo y pisar el contenido, por eso es en base a un parametro opcional
			if reLoad and doesFileExist newPath then this.reload() --carga de nuevo el contenido del path en el documento
		),
		
		------------------------------------------------
		--@fn: undefined | setString | Rellena el arbol de elementos del documento xml y sus propieades a partir de un string.
		--@gets: string | xmlString | String que contiene el arbol xml.
		------------------------------------------------
		fn setString xmlString =
		(
			this.root = undefined
			_docLines = #() --array para almacenar todas las lineas del documento
				
			------------------------------------------------
			--convierte el string en un stringStream y separa todas sus líneas
			
			f = xmlString as stringStream
			
			if f != undefined then --si lo consigue abrir
			(
				--recorre el archivo linea a linea y lo guarda en un array
				while not eof f do append _docLines (readLine f)
				close f
			)--if
			
			--si el archivo no estaba vacío lo procesa
			if _docLines.count != 0 then
			(
				--array para almacenar una pila de finales de nodo a buscar
				--la parte de arriba de la pila es el elemento 1 del array
				_endStack = #()
				
				_currElement = xmlElement elementName:"root" --elemento actual de proceso del xml para cada iteracion por la lineas del documento
				
				for i=1 to _docLines.count do --recorre todas las lineas buscando nodos
				(
					--elimina los espacios al principio de la linea
					_docLines[i] = lb.str.removeSpaces _docLines[i] onlyInitial:true --while _docLines[i][1] == " " do _docLines[i] = substring _docLines[i] 2 _docLines[i].count
					_docLines[i] = lb.str.removeSpaces _docLines[i] onlyFinal:true --while _docLines[i][_docLines[i].count] == " " do _docLines[i] = substring _docLines[i] 1 (_docLines[i].count - 1)
					
					--si es un elemento de xml. Puede ser inicio de nodo, fin de nodo o nodo completo
					if _docLines[i][1] == "<" then
					(
						_lineParts = FilterString _docLines[i] "<>" --obtiene las partes de la línea
						_lineFisrtPart = (FilterString _lineParts[1] "= 	")[1]
						
						_childElement = xmlElement elementName:_lineParts[1] --crea el nuevo nodo hijo
						_childElement.parent = _currElement --emparenta el hijo al padre
						
						--Si el ultimo caracter de la primera parte es / se quita par que no de problemas al filtrar las propiedades
						--if _lineParts[1][_lineParts[1].count] == "/" then _lineParts[1] = substring _lineParts[1] 1 (_lineParts[1].count - 1)
						
						------------------------------------------------
						--si el nodo tiene propiedades y valores hay que filtrarlos
						_propertiesParts = filterString _lineParts[1] "="
						if _propertiesParts.count > 1 then --solo si hay propiedades
						(
							--primero se extrae el nombre del nodo, que se queda en la primera parte junto al nombre de la primera propiedad
							_firstParts = filterString _propertiesParts[1] " 	"
							_childElement.elementName = _firstParts[1]
							_propertiesParts[1] = _firstParts[2]
							
							_propNames = #() --array para los nombres de las propiedades
							_propValues = #() --array para los valores de las propiedades
							
							for j=1 to _propertiesParts.count do --recorre todas las propiedades y filtra nombre y valor
							(
								if j==1 then
								(
									append _propNames _propertiesParts[1]
								)
								else if j==_propertiesParts.count then
								(	
									--busca las primeras comillas, que deberían estar en el primer lugar
									_index1 = findString _propertiesParts[j] "\""
									_index2 = findString (substring _propertiesParts[j] (_index1 + 1) _propertiesParts[j].count) "\""
									_propVal = (substring _propertiesParts[j] (_index1 + 1) (_index2 - _index1))
									_propVal = (substituteString _propVal "\\x3e" ">")
									_propVal = (substituteString _propVal "\\x3c" "<")

									append _propValues _propVal
								)
								else
								(
									_propParts = filterString _propertiesParts[j] "\""
									
									if _propParts.count > 1 then
									(
										append _propNames (filterString _propParts[2] " 	")[1]

										_propVal = _propParts[1]
										_propVal = (substituteString _propVal "\\x3e" ">")
										_propVal = (substituteString _propVal "\\x3c" "<")

										append _propValues _propVal
									)
									else
									(
										append _propNames (filterString _propParts[1] " 	")[1]
										append _propValues ""
									)
								)								
							)--for
							
							--almacena las propiedades
							_childElement.setPropNames _propNames
							_childElement.setPropValues _propValues
						)--if
						------------------------------------------------
						
						--casos posibles de nodos de xml segun la línea
						case _lineParts.count of
						(
							1: --solo puede ser inicio o fin de nodo
							(
								if findString _lineFisrtPart "/" == undefined and (_lineParts[1][_lineParts[1].count] != "/") then --es un inicio de nodo
								(									
									_endStack = #(_lineFisrtPart) + _endStack --actualiza la pila de busqueda
										
									--si el nodo tiene propiedades y valores hay que filtrar el nombre del nodo para la pila
									_propertiesParts = filterString _lineParts[1] "="
									if _propertiesParts.count > 1 then
									(
										_firstParts = filterString _propertiesParts[1] " 	"
										_endStack[1] = _firstParts[1]
									)--if
									
									_currElement.addNode _childElement --añade el nodo hijo al actual
									_currElement = _childElement --hace que el nodo actual sea el hijo
								)
								else if _lineParts[1][_lineParts[1].count] == "/" then
								(
									_currElement.addNode _childElement --añade el nodo hijo al actual
								)
								else if (_lineParts[1][1] == "/") and ("/" + _endStack[1] == _lineParts[1]) then --es un cierre de nodo
								(
									deleteItem _endStack 1
									_currElement = _currElement.parent
								)
							)
							
							2: --es un nodo completo en una línea, pero sin texto
							(
								_currElement.addNode _childElement --añade el nodo hijo al actual
							)
							
							3: --es un nodo completo en una línea
							(
								_childElement.text = _lineParts[2]
								_currElement.addNode _childElement --añade el nodo hijo al actual
							)
						)--case
					)--if
				)--for _docLines
				
				this.root = _currElement
			)
			else
			(
				this.root = this.xmlElement elementName:"root" --crea un root vacío
			)--if  else _docLines
			------------------------------------------------
		),
		
		------------------------------------------------
		--lee un xmldoc a partir de .net
		------------------------------------------------
		fn readDotNetXmlDoc xmlFile =
		(
			_success = false
			
			if doesFileExist xmlFile and ((getFileSize xmlFile) > 0) then
			(
				this.path = xmlFile

				this.root = undefined
					
				------------------------------------------------
				--crea un xml de .net para hacer una equivalencia
				
				_dotNetXmlDoc = dotNetObject "System.Xml.XmlDocument"
				_dotNetXmlDoc.Load xmlFile
				
				if _dotNetXmlDoc.ChildNodes.count != 0 then --si lo consigue abrir
				(
					global _xmlElementFromDotNetXmlNode
					fn _xmlElementFromDotNetXmlNode xmlNode _parent:undefined =
					(
						_newElement = undefined
						
						if xmlNode.Value != undefined and xmlNode.Name == "#text" and _parent != undefined then _parent.setText xmlNode.Value --esto es porque .net se inventa un nodo de texto hijo
						else
						(
							_newElement = lb.xml.xmlElement elementName:(xmlNode.Name)

							------------------------------------------------
							--obtiene las propiedades
							_attributes = xmlNode.Attributes
							if _attributes.count != 0 then
							(
								for i=1 to _attributes.count do
								(
									_att = _attributes.ItemOf[i-1]
									_newElement.setProperty (_att.Name) (_att.Value as string)							
								)--for
							)--if
							------------------------------------------------

							------------------------------------------------
							for i=1 to xmlNode.ChildNodes.count do --recorre todos los nodos haciendo hijos un espejo en maxscript
							(
								_newChild = _xmlElementFromDotNetXmlNode xmlNode.ChildNodes.item[i-1] _parent:_newElement

								if _newChild != undefined then
								(
									_newChild.setParent _newElement
									_newElement.addNode _newChild
								)--if
							)--for
							------------------------------------------------
						)--if else

						_newElement
					)--fn
								
					this.root = this.xmlElement elementName:"root" --elemento raiz del documento
					
					for i=1 to _dotNetXmlDoc.ChildNodes.count do --recorre todos los nodos haciendo un espejo en maxscript
					(
						_newChild = _xmlElementFromDotNetXmlNode _dotNetXmlDoc.ChildNodes.item[i-1] _parent:this.root

						if _newChild != undefined then
						(
							_newChild.setParent this.root
							this.root.addNode _newChild
						)--if
					)--for

					_xmlElementFromDotNetXmlNode = undefined --limpia la funcion				
				)
				else
				(
					this.root = this.xmlElement elementName:"root" --crea un root vacío
				)--if  else _docLines
				------------------------------------------------
			)
			else
			(
				this.path = xmlFile
				this.root = this.xmlElement elementName:"root"
			)--if else
			
			_success
		),
		
		------------------------------------------------
		--salva el xmlDoc en un archivo mediante .net
		------------------------------------------------
		fn saveDotNetXmlDoc xmlFile =
		(
			_success = false
			
			if this.root.nodes.count != 0 then
			(
				------------------------------------------------
				--crea un xml de .net para hacer una equivalencia
				
				_dotNetXmlDoc = dotNetObject "System.Xml.XmlDocument"

				------------------------------------------------
				global _xmlTreeToDotNet
				fn _xmlTreeToDotNet rootNode dotNetXmlDoc =
				(
					_newElement = dotNetXmlDoc.CreateElement (rootNode.getName())
					if rootNode.getText() != "" then _newElement.InnerText = rootNode.getText()
					for i=1 to rootNode.propertyNames.count do
					(
						_newElement.SetAttribute (rootNode.propertyNames[i]) (rootNode.propertyValues[i] as string)
					)--if

					for _node in rootNode.nodes do
					(
						_childElement = _xmlTreeToDotNet _node dotNetXmlDoc
						_newElement.AppendChild _childElement
					)--for

					_newElement
				)--fn
				------------------------------------------------

				for _node in this.root.nodes do
				(
					_rootXmlDotNetNode = _xmlTreeToDotNet _node _dotNetXmlDoc --hace la traduccion del arbol
					_dotNetXmlDoc.AppendChild _rootXmlDotNetNode --añade el arbol al documento
				)--for

				_xmlTreeToDotNet = undefined --limpia la funcion temporal

				_dotNetXmlDoc.Save xmlFile --lo salva
				
				------------------------------------------------
			)--if
			
			_success
		),

		------------------------------------------------
		--@fn: undefined | setRoot | Almacena el nuevo elemento xml raiz.
		--@gets: string | newRoot | Nuevo elemento xml raiz.
		------------------------------------------------
		fn setRoot newRoot = (this.root = newRoot),
		
		------------------------------------------------
		--@fn: undefined | setAttribute | Almacena una propiedad con un valor en el nodo que se especifica dentro del arbol xml. Si el nodo no existe crea toda la jerarquia hasta llegar a el.
		--@gets: string | nodeTreePath | Patrón de jerarquía de elementos xml para encontrar el nodo donde almacenar la propoiedad. Ejemplo: "elemento1/elemento2/elemento4".
		--@gets: string | propName | Nombre de la propiedad que se quiere almacenar.
		--@gets: string | value | String con el valor de la propiedad que se quiere almacenar.
		------------------------------------------------
		fn setAttribute nodeTreePath propName value =
		(
			--descompone los niveles y obtiene el nodo inicial
			_levelParts = FilterString nodeTreePath "/"
			_currElement = this.root
			
			_level = 1 --nivel actual
			_stop = false --flag de parada
			for i=1 to _levelParts.count where not _stop do --recorre los niveles buscando el nodo. Si algun nivel no exista lo crea
			(
				_found = false
				
				for n in _currElement.getChildren() where not _stop and not _found do
				(
					if n.getName() == _levelParts[i] then
					(
						_currElement = n
						_found = true
					)--if					
				)--for
				
				if not _found then --si esa parte del arbol no existe la crea
				(
					_currElement = _currElement.newChild _levelParts[i]
				)
				
				if i == _levelParts.count then --si ha llegado al ultimo nivel, le pone la propiedad al nodo o se la sobrescribe
				(
					_currElement.setProperty propName value
				)--if
			)--for
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
			
		------------------------------------------------
		--@fn: boolean | read | Rellena el arbol de elementos del documento xml y sus propieades. Devuelve true si el archivo es correcto y lo ha cargado
		--@gets: string | xmlFile | Ruta del documento xml.
		------------------------------------------------
		fn load xmlFile =
		(
			_success = false
			
			if doesFileExist xmlFile then
			(
				this.path = xmlFile
					
				------------------------------------------------
				--solo si el archivo xml existe lo procesa	
				
				f = openFile xmlFile mode:"r" --intenta abrir el archivo para procesarlo
				
				if f != undefined then --si lo consigue abrir
				(
					_fileString = ""
					--recorre el archivo linea a linea y lo guarda en un array
					while not eof f do _fileString += (readLine f) + "\n"
					close f --cierra el archivo para que el sistema lo libere
					
					if _fileString != "" then this.setString _fileString --llama a la funcion que procesa las línes del archivo
					else this.root = this.xmlElement elementName:"root"
					
					_success = true
				)--if f
				------------------------------------------------			
			)
			else
			(
				this.root = this.xmlElement elementName:"root"
			)--if else
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | reload | Recarga toda la información del documento xml. Rellena el arbol de elementos del documento xml y sus propieades
		------------------------------------------------
		fn reload =
		(
			this.readDotNetXmlDoc (this.path)
		),
		
		------------------------------------------------
		--@fn: undefined | clear | Vacía el xml y deja solo el nodo raiz.
		------------------------------------------------
		fn clear =
		(			
			this.root = xmlElement elementName:"root" --vacía el xml y deja solo el nodo raiz
		),
		
		----------------------------
		--@fn: undefined | toString | Devuelve un string con el arbol de nodos.
		--@returns: string | String con el arbol de nodos del documento.
		fn toString =
		(
			_theString = ""
			
			if this.root != undefined then
			(
				for i=1 to this.root.nodes.count do
				(
					if i!=1 then _theString += "\n"
					_theString += this.root.nodes[i].toString()
				)--for
			)--if
			
			_theString
		),
		
		------------------------------------------------
		--@fn: undefined | saveToXml | Almacena el contenido del arbol en un archivo en formato xml
		--@gets: string | file | Ruta completa del archivo donde se almacenará el arbol. Sobreescribe siempre.
		------------------------------------------------
		fn save =
		(
			if not doesFileExist this.path then (f = createFile this.path; close f)
			
			/*f = openFile this.path mode:"w"
			format (this.toString()) to:f
			close f*/

			this.saveDotNetXmlDoc this.path

			ok
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
			
		)
		
	)--lib_xmlDoc
	------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: xml | Contiene todas las funciones de xml.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_xml
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de xml",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		xmlDoc = lib_xmlDoc,				--@var: xmlDoc | Struct de documentos de xml				
		xmlElement = lib_xmlElement,		--Ovar: xmlElement | Struct de elementos xml		
		
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
		--@fn: generic | getAttribute | Devuelve del archivo indicado el valor de la propiedad pasada por parametro en el nodo indicado en la jerarquia. Si no tiene esa propiedad devuelve un string vacio
		--@gets: string | xmlFile | Ruta completa con el nombre de archivo xml del que se quiere leer.
		--@gets: string | nodeTreePath | Patrón de jerarquía de elementos xml que se solicitan. Ejemplo: "elemento1/elemento2/elemento4".
		--@gets: string | propName | Nombre de la propiedad que se solicita.		
		------------------------------------------------
		fn getAttribute xmlFile nodeTreePath propName =
		(
			_propValue = ""
			
			if doesFileExist xmlFile then
			(
				_xmlDoc = this.load xmlFile
				_propValue = _xmlDoc.getAttribute nodeTreePath propName
			)
				
			_propValue
		),
		
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setAttribute | Almacena una propiedad con un valor en el nodo que se especifica dentro del arbol xml. Si el nodo no existe crea toda la jerarquia hasta llegar a el.
		--@gets: string | xmlFile | Ruta completa con el nombre de archivo xml en el que se quiere almacenar la propiedad.
		--@gets: string | nodeTreePath | Patrón de jerarquía de elementos xml para encontrar el nodo donde almacenar la propoiedad. Ejemplo: "elemento1/elemento2/elemento4".
		--@gets: string | propName | Nombre de la propiedad que se quiere almacenar.
		--@gets: string | value | String con el valor de la propiedad que se quiere almacenar.
		------------------------------------------------
		fn setAttribute xmlFile nodeTreePath propName value =
		(
			_xmlDoc = this.load xmlFile makeFile:true
			if doesFileExist xmlFile then
			(		
				_xmlDoc.setAttribute nodeTreePath propName value
				_xmlDoc.save()
			)
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--ESTO ESTA EN 
		--@fn: xmlDoc | read | Rellena el arbol de elementos del documento xml y sus propieades. Devuelve el documento procesado. Si no existe y no se indica crearlo devuelve undefined.
		--@gets: string | xmlFile | Nueva ruta del documento xml.
		--@opt: boolean | makeFile | false | Indica si crear el archivo en caso de que no exista.
		------------------------------------------------
		fn load xmlFile makeFile:false =
		(
			_theXmlDoc = undefined
			
			--si no existe el archivo y así se indica, crea uno nuevo.
			if makeFile and not doesFileExist xmlFile then close (createFile xmlFile)
				
			------------------------------------------------
			--solo si el archivo xml existe lo procesa
			if doesFileExist xmlFile then
			(
				_theXmlDoc = this.xmlDoc()
				_theXmlDoc.xmlElement = this.xmlElement
				_theXmlDoc.readDotNetXmlDoc xmlFile
			)--if doesFileExist
			------------------------------------------------			
			
			_theXmlDoc --devuelve el documento procesado
		),--fn load
		
		------------------------------------------------
		--@fn: xmlDoc | new | Crea un nuevo documento xml. El archivo del documento no se crea hasta que se llama a guardar. Devuelve el xml creado. Si ya exsite lo lee y lo devuelve
		--@gets: string | xmlFile | Nueva ruta del documento xml.
		------------------------------------------------
		fn new xmlFile =
		(
			_theXmlDoc = undefined
			
			--si no existe el archivo y así se indica, crea uno nuevo.
			if not doesFileExist xmlFile then close (createFile xmlFile)
			else
			(
				_f = openFile xmlFile mode:"w"
				close _f
			)
				
			--if doesFileExist xmlFile then _theXmlDoc = this.load xmlFile
			if doesFileExist xmlFile then
			(
				_theXmlDoc = this.xmlDoc()
				_theXmlDoc.readDotNetXmlDoc xmlFile
			)
				
			_theXmlDoc
		),
		
		------------------------------------------------
		--@fn: xmlDoc | newXmlDoc | Crea un nuevo documento xml vacío para ser rellenado a mano o más tarde mediante la funcion load.
		------------------------------------------------
		fn newXmlDoc =
		(
			_theXmlDoc = undefined
			
			_theXmlDoc = this.xmlDoc() --crea un documento xml nuevo
			_theXmlDoc.xmlElement = this.xmlElement
			_theXmlDoc.root = xmlElement elementName:"root" --crea el root
			
			_theXmlDoc
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
		
	)--lib_xml
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_xml() --crea la librería
)