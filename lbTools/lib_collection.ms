------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: librería de colecciones
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: treeElement | Contiene todas las funciones de elementos de arboles
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_treeElement
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		parent = undefined,					--@var: treeElement | parent | Elemento padre del actual
		
		elementName = "",					--@var: string | elementName | Nombre del nodo
		content = undefined,				--@var: generic | content | Contenido del elemento
		
		nodes = #(),						--@var: array | nodes | Nodos hijos del elemento
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: treeElement | getParent | Consulta el padre del elemento
		--@returns: treeElement | undefined | Devuelve el elemento padre si lo hay, si no, devuelve undefined.
		------------------------------------------------
		fn getParent = this.parent,
			
		------------------------------------------------
		--@fn: string | getName | Consulta el nombre del elemento
		--@returns: string | undefined | Devuelve el nombre del elemento 
		------------------------------------------------		
		fn getName = this.elementName,
		
		------------------------------------------------
		--@fn: content | getContent | Consulta el contenido del elemento. El contenido puede ser de cualquier tipo, es generico
		--@returns: content | undefined | Devuelve el contenido del elemento 
		------------------------------------------------			
		fn getContent = this.content,
		
		------------------------------------------------
		--@fn: treeElement | getChildByName | Consulta el primer elemento hijo que tenga el nombre pasado por parametro.
		--@gets: string | childName | El nombe del nodo hijo a buscar.
		--@returns: treeElement | undefined | Devuelve el un treeElement con el nodo hijo (El primero que encuentra por el nombre). Devuelve undefined si no lo encuentra.
		------------------------------------------------		
		fn getChildByName childName =
		(
			_theChild = undefined
			
			_stop = false			
			for ch in this.nodes where (ch.getName() == childName) and not _stop do (_theChild = ch; _stop = true)
				
			_theChild
		),
		
		------------------------------------------------
		--@fn: array{treeElement} | getChildrenByName | Devuelve los elementos hijos que tengan el nombre pasado por parametro en un array. Si no hay devuelve un array vacio.
		--@gets: string | childName | Nombre de los elementos hijos solicitados.
		--@returns: array{treeElement} | _theChildren | Devuelve un array que contiene todos los nodos con el nombre especificado.
		------------------------------------------------
		fn getChildrenByName childName =
		(
			_theChildren = #()
				
			for ch in this.nodes where (ch.getName() == childName) do append _theChildren ch
				
			_theChildren
		),
		
		------------------------------------------------
		--@fn: treeElement | getNode | Consulta si existe algun elemento que cumpla la jerarquia pasada por parámetro.
		--@usage: firstElement4 = elemento1.getNode "elemento1/elemento2/elemento4" devuelve el nodo nieto de elemento1 y que se llama elemento4 si existe
		--@gets: string | nodeTreePath | Patrón de jerarquía de elemento que se solicita. Ejemplo: "elemento1/elemento2/elemento4"
		--@returns: treeElement | _theNode | Devuelve el primer elemento que ocupa el lugar marcado por el parametro 'nodeTreePath'.
		------------------------------------------------
		fn getNode nodeTreePath = 
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
				if i == _levelParts.count and _found then
				(
					_stop = true
					_theNode = _currElement
				)--if
			)--for
			
			_theNode --devuelve el nodo
		),

		------------------------------------------------
		--@fn: array{treeElement} | getNodes | Consulta todos los elementos que cumplan la jerarquia pasada por parámetro.
		--@usage: allElement4 = elemento1.getNodes "elemento1/elemento2/elemento4" devuelve los nodos nietos de elemento1 y que se llamen elemento4 si existen
		--@gets: string | nodeTreePath | Patrón de jerarquía de los elementos que se solicitan. Ejemplo: "elemento1/elemento2/elemento4"
		--@returns: array{treeElement} | _theNodes | Devuelve el primer elemento que ocupa el lugar marcado por el parametro 'nodeTreePath'.
		------------------------------------------------		
		fn getNodes nodeTreePath = 
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

			_getNodesByPattern = undefined --libera la funcion
			
			_theNodes --devuelve los nodos
		),
		
		------------------------------------------------
		--@fn: array{treeElement} | getChildren | Consulta los elementos hijos de un nodo.
		--@returns: array{treeElement} | undefined | Devuelve una array con todos los elementos hijos del nodo des del que se llama la función.
		------------------------------------------------
		fn getChildren = this.nodes,
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setParent | Almacena el elemento padre.
		--@gets: treeElement | newParent | Nuevo elemento padre.
		------------------------------------------------
		fn setParent newParent = (this.parent = newParent),
		
		------------------------------------------------
		--@fn: undefined | setName | Almacena el nombre del elemento.
		--@gets: string | newName | Nuevo nombre del elemento.
		------------------------------------------------
		fn setName newName = (this.elementName = newName),
		
		------------------------------------------------
		--@fn: undefined | setContent | Almacena el contenido del elemento.
		--@gets: object | newContent | Nuevo contenido del elemento.
		------------------------------------------------
		fn setContent newContent = (this.content = newContent),
		
		------------------------------------------------
		--@fn: undefined | setChildren | Almacena los elementos hijos del elemento.
		--@gets: array{treeElement} | newNodes | Nuevo array de elementos hijos.
		------------------------------------------------
		fn setChildren newNodes = (this.nodes = newNodes),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | addNode | Añade un nuevo elemento hijo.
		--@gets: treeElement | childElement | Nuevo elemento hijo.
		------------------------------------------------
		fn addNode childElement =
		(
			append this.nodes childElement
			childElement.setParent this --le dice que su padre es el nodo actual.
		),
		
		------------------------------------------------
		--@fn: undefined | newChild | Crea un nuevo elemento hijo
		--@gets: string | childName | Nombre del nuevo hijo.
		--@gets: (opt)object | content | undefined | Contenido del nuevo hijo. Por defecto undefined
		--@returns: treeElement | _newChild | El elemento hijo creado.
		------------------------------------------------
		fn newChild childName content:undefined =
		(
			_newChild = this.def() --this.treeElement() --crea el nuevo nodo
			--_newChild.treeElement = this.treeElement --le pasa al nodo la defincion de elementos de arbol para que pueda crearle subnodos
			_newChild.init() --inicializa el nodo
			_newChild.setName childName --le pone el nombre
			if content != undefined then _newChild.setContent content --le añade el contenido
			_newChild.setParent this --le dice que su padre es el nodo actual
			append this.nodes _newChild --añade el hijo al conjunto de nodos actual
			
			_newChild
		),
		
		------------------------------------------------
		--@fn: undefined | removeChild | Elimina el elemento hijo que ocupe el indice indicado
		--@gets: integer | index | Indice del elemento hijo que se quiere eliminar.
		------------------------------------------------
		fn removeChild index =
		(
			if index > 0 and index <= this.nodes.count do deleteItem this.nodes index
		),
		
		------------------------------------------------
		--@fn: undefined | clear | Vacía la rama de nodos que tenga por debajo
		------------------------------------------------
		fn clear =
		(
			this.nodes = #()
		),
		
		------------------------------------------------
		--@fn: string | toString | Consulta la información del nodo y sus subnodos recursivamente. 
		--@gets: (opt)integer | level | 1 | Numero de niveles que debe profundizar las funcion de forma recursiva extrayendo la informacion de los hijos.
		--@gets: (opt)boolean | childrenExplicitNode | false | Indica si tiene que poner un nodo expecial llamado children del que cuelguen todos los hijos, o que los hijos cuelguen directamente del padre.
		--@returns: string | _theString | Devuelve una string con la información solicitada.
		------------------------------------------------
		fn toString level:1 childrenExplicitNode:false childrenExplicitNodeLabel:"children" =
		(
			_theString = ""
			
			_initialSpaces = ""
			for i=1 to (level - 1) do _initialSpaces += "  " --añade tabuladores segun el nivel
				
			_theString += _initialSpaces + "<" + this.elementName + ">" --añade el nombre del nodo
			
			_addInitialSpacesAtEnd = false --indica si añadir tabuladores antes del cierre del bloque
			
			if this.content != undefined and this.content != "" then
			(
				_types = lb.utilities.getBasicDataTypes() + lb.utilities.getTimeDataTypes() + lb.utilities.getCollectionDataTypes()
				
				if findItem _types (classof this.content) != 0 then --si es un tipo nativo lo procesa como testo
					_theString += (this.content as string) --añade el contenido del nodo
				else --si es un tipo personalizado, llama a su funcion toString
				(
					_theString += (this.content.toString level:(level+1)) --añade el contenido del nodo
					_addInitialSpacesAtEnd = true
				)
			)
			
			if this.nodes.count != 0 then --si tiene hijos los añade
			(
				if childrenExplicitNode then _theString += "\n" + _initialSpaces + "  <" + childrenExplicitNodeLabel + ">"
				for n in this.nodes do _theString += "\n" + (n.toString level:(level+(if childrenExplicitNode then 2 else 1)) childrenExplicitNode:childrenExplicitNode childrenExplicitNodeLabel:childrenExplicitNodeLabel)
				_addInitialSpacesAtEnd = true
				if childrenExplicitNode then _theString += "\n" + _initialSpaces + "  </" + childrenExplicitNodeLabel + ">"
			)			
			
			if _addInitialSpacesAtEnd do _theString += "\n" + _initialSpaces
			_theString += "</" + this.elementName + ">" --añade el nombre del nodo
			
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
			this.clear() --limpia el nodo al iniciarse
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
	)--lb_treeElement
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lib_tree | Contiene todas las funciones de arboles.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_tree
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		root = undefined,					--@var: treeElement | root | Elemento raiz del arbol.
		
		treeElement = lib_treeElement,		--@var: treeElement | treeElement | Almacena la definicion del struct de elementos de arboles.
		
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
		--@fn: treeElement | getRoot | Devuelve el nodo raiz del arbol.
		------------------------------------------------
		fn getRoot =
		(
			this.root
		),
		
		------------------------------------------------
		--@fn: treeElement | getNode | Consulta si existe algun elemento que cumpla la jerarquia pasada por parámetro.
		--@usage: firstElement4 = elemento1.getNode "elemento1/elemento2/elemento4" devuelve el nodo nieto de elemento1 y que se llama elemento4 si existe
		--@gets: string | nodeTreePath | Patrón de jerarquía de elemento que se solicita. Ejemplo: "elemento1/elemento2/elemento4"
		--@returns: treeElement | _theNode | Devuelve el primer elemento que ocupa el lugar marcado por el parametro 'nodeTreePath'.
		------------------------------------------------			
		fn getNode nodeTreePath = 
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
					_theNode = _currElement
				)--if
			)--for
			
			_theNode --devuelve el nodo
		),
		
		------------------------------------------------
		--@fn: array{treeElement} | getNodes | Consulta todos los elementos que cumplan la jerarquia pasada por parámetro.
		--@usage: allElement4 = elemento1.getNodes "elemento1/elemento2/elemento4" devuelve los nodos nietos de elemento1 y que se llamen elemento4 si existen
		--@gets: string | nodeTreePath | Patrón de jerarquía de los elementos que se solicitan. Ejemplo: "elemento1/elemento2/elemento4"
		--@returns: array{treeElement} | _theNodes | Devuelve el primer elemento que ocupa el lugar marcado por el parametro 'nodeTreePath'.
		------------------------------------------------
		fn getNodes nodeTreePath = 
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
			
			_theNodes = _getNodesByPattern this.root nodeTreePath

			_getNodesByPattern = undefined --libera la funcion
			
			_theNodes --devuelve los nodos
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setRoot | Sustituye el nodo raiz del arbol por uno nuevo.
		--@gets: treeElement | newRoot | Nuevo elemento de árbol para hacer de raiz.
		------------------------------------------------
		fn setRoot newRoot =
		(
			this.root = newRoot
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | clear | Vacía el arbol.
		------------------------------------------------
		fn clear =
		(
			this.root = this.treeElement() --crea el nodo root
			--this.root.treeElement = this.treeElement --le pasa al nodo root la defincion de elementos de arbol para que pueda crearle subnodos
			this.root.init() --inicializa el nodo raiz
			this.root.setName "root" --le pone el nombre raiz genérico
		),
			
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la representacion del arbol.
		--@returns: string | undefined | String con la representación del arbol
		------------------------------------------------
		fn toString childrenExplicitNode:false childrenExplicitNodeLabel:"children" =
		(
			this.root.toString childrenExplicitNode:childrenExplicitNode childrenExplicitNodeLabel:childrenExplicitNodeLabel
		),
		
		------------------------------------------------
		--@fn: undefined | saveToXml | Almacena el contenido del arbol en un archivo en formato xml
		--@gets: string | file | Ruta completa del archivo donde se almacenará el arbol. Sobreescribe siempre.
		------------------------------------------------
		fn saveToXml file =
		(
			f = openFile file mode:"w"
			format (this.toString()) to:f
			close f
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
			this.clear()
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
	)--lib_tree
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: stack | Contiene todas las funciones de pilas.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_stack
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		elements = #(),						--@var: array{generic} | elements | Elementos de la pila.
					
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
		--@fn: integer | count | Consulta el numero de elementos de una pila.
		--@returns: integer | undefined | Numero de elementos de la pila
		------------------------------------------------
		fn count = this.elements.count,
		
		------------------------------------------------
		--@fn: undefined | clear | Vacía la pila.
		------------------------------------------------
		fn clear = this.elements = #(),
		
		------------------------------------------------
		--@fn: undefined | push | Añade un elemento en la cima de la pila.
		--@gets: object | theElement | Elemento que colocar en la cima de la pila
		------------------------------------------------
		fn push theElement =
		(
			if theElement != undefined then
				this.elements = #(theElement) + this.elements
		),
		
		------------------------------------------------
		--@fn: generic | pull | Elimina el elemento en la cima de la pila y lo devuelve. El elemento puede ser de cualquier tipo.
		--@returns: generic | _theElement | El elemento de la cima de la pila.
		------------------------------------------------
		fn pull =
		(
			_theElement = this.elements[1]
			if this.elements.count != 0 then this.elements = deleteItem this.elements 1
			_theElement
		),
		
		------------------------------------------------
		--@fn: generic | top | Devuelve el elemento en la cima de la pila. El elemento puede ser de cualquier tipo.
		--@returns: generic | _theElement | El elemento de la cima de la pila.
		------------------------------------------------
		fn top = this.elements[1],
		
		------------------------------------------------
		--@fn: string | toString | Consulta los elementos que pueblan la lista.
		--@returns: string | _theString | Devuelve un string con los elementos de la pila.
		------------------------------------------------
		fn toString =
		(
			_theString = ""
			for element in this.elements do _theString += (element as string) + "\n"
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
		
	)--lib_stack
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lib_queue | Contiene todas las funciones de colas.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_queue
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		elements = #(),						--@var: generic | elements | Elementos de la cola.
			
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
		--@fn: integer | count | Consulta el numero de elementos de la cola.
		--@returns: integer | undefined | Devuelve el numero de elementos de la cola.
		------------------------------------------------
		fn count = this.elements.count,
		
		------------------------------------------------
		--@fn: undefined | clear | Vacía la cola.
		------------------------------------------------
		fn clear = this.elements = #(),
		
		------------------------------------------------
		--@fn: undefined | enqueue | Añade un elemento en el inicio de la cola.
		--@gets: object | theElement | Elemento que colocar en el inicio de la cola.
		------------------------------------------------
		fn enqueue theElement =
		(
			if theElement != undefined then
				this.elements = #(theElement) + this.elements
		),
		
		------------------------------------------------
		--@fn: generic | dequeue | Elimina el elemento en el final de la cola y lo devuelve.
		--@returns: generic | _theElement | Devuelve el elemento eliminado de la cola
		------------------------------------------------
		fn dequeue =
		(
			_theElement = undefined
				
			if this.elements.count != 0 then
			(
				_theElement = this.elements[this.elements.count]
				this.elements = deleteItem this.elements (this.elements.count)
			)
			
			_theElement
		),
		
		------------------------------------------------
		--@fn: generic | first | Consulta el primer elemento de la cola
		--@returns: generic | undefined | Devuelve el primer elemento de la cola
		------------------------------------------------
		fn first = (if this.elements.count != 0 then this.elements[this.elements.count] else undefined),
			
		------------------------------------------------
		--@fn: string | toString | Consulta los elementos de la cola
		--@returns: string | undefined | Devuelve un string con todos los elementos de la cola
		------------------------------------------------
		fn toString =
		(
			_theString = ""
			for element in this.elements do _theString = (element as string) + "\n" + _theString
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
		
	)--lib_queue	
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: collection | Contiene todas las funciones de colecciones.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_collection
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,													--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Libreria de colecciones",							--@var: string | description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		stack = lib_stack,				--@var: struct | stack | Almacena la definicion del struct de pilas.
		queue = lib_queue,				--@var: struct | queue | Almacena la definicion del struct de colas.
		tree = lib_tree,				--@var: struct | tree | Almacena la definicion del struct de arboles.
		treeElement = lib_treeElement,	--@var: struct | treeElement | Almacena la definicion del struct de elementos de arboles.
		
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
		--@fn: stack | newStack | Crea una nueva pila vacía
		--@returns: stack | _theStack | La pila creada
		------------------------------------------------
		fn newStack =
		(
			_theStack = this.stack() --crea la pila.
			_theStack --devuelve la pila
		),
		
		------------------------------------------------
		--@fn: queue | newQueue | Crea una nueva cola vacía y la devuelve.
		--@returns: queue | _theQueue | La cola creada
		------------------------------------------------
		fn newQueue =
		(
			_theQueue = this.queue() --crea la cola.
			_theQueue --devuelve la cola.
		),
		
		------------------------------------------------
		--@fn: tree | newTree | Crea un nuevo arbol vacío y lo devuelve.
		--@returns: tree | _theTree | El arbol creado
		------------------------------------------------
		fn newTree =
		(
			_theTree = this.tree() --crea el arbol.
			--_theTree.treeElement = this.treeElement --le pasa al arbol la definicion del struct de elementos del arbol para que los pueda crear
			_theTree.init() --inicializa el arbol
			
			_theTree --devuelve el arbol.			
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
		
	)--lib_collection
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_collection() --crea la libreria
)