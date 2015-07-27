------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de plantilla
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: nodeSet | Contiene todas las funciones de nodeSet personalizado.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_nodeSet
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		caption = undefined,	--@var | caption | Nombre del set de nodos personalizado. TEMPORAL durante la construcción.
		type = "default",	--@var | type | Tipo de set de nodos, indica que tipo de nodos puede almacenar: 'default' - todos; 'geometry' - geometria; 'light' - luces. TEMPORAL durante la construcción.
		nodes = #(),		--@var | nodos | Array de nodos del set. TEMPORAL durante la construcción.
		--nodesNames = #(),		--@var | nodesNames | Array de nombres de los nodos del set. TEMPORAL durante la construcción.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del set de forma permanente.
		infoNodePrefix = "nodeSet-",	--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada nodeSet.
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este nodeSet, para poder buscar la equivalencia de forma rápida entre un nodeSet y el objeto de interface que lo controla.
		
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
		--@fn: nodeSetInfo | getNodeSetCA | Devuelve la definicion del CA que almacena la informacion de nodeSets en los objetos.
		------------------------------------------------
		fn getNodeSetCA =
		(
			--crea la definicion del CA
			_nodeSetInfoCA = attributes nodeSetInfo
			(
				parameters main
				(
					--guarda la descripcion del CA y su version.
					CA_version		type:#float		animatable:false	default:1.0
					CA_description	type:#string	default:"Almacena la informacion de un set de nodos."
						
					--información específica del set de nodos
					caption	type:#string	default:""				--@var | caption | Nombre del set de nodos personalizado.
					type	type:#string	default:""				--@var | type | Tipo de set de nodos, indica que tipo de nodos puede almacenar: 'default' - todos; 'geometry' - geometria; 'light' - luces.
					nodes		type:#nodeTab tabSizeVariable:true		--@var | nodes | Array de nodos del set.
					nodesNames	type:#stringTab tabSizeVariable:true	--@var | nodesNames | Array de nombres de los nodos del set.
				)
			)
			
			_nodeSetInfoCA --devuelve la definicion del CA
		),
		
		------------------------------------------------
		--@fn: string | getCaption | Devuelve el nombre del nodeSet.
		------------------------------------------------
		fn getCaption =
		(
			this.infoNode.custAttributes[#nodeSetInfo].caption
		),
			
		------------------------------------------------
		--@fn: string | getType | Devuelve el tipo del nodeSet.
		------------------------------------------------
		fn getType =
		(
			this.infoNode.custAttributes[#nodeSetInfo].type
		),
			
		------------------------------------------------
		--@fn: array{node} | getNodes | Devuelve los nodos del nodeSet
		--@opt: boolean | purge | true | Indica si hacer limpieza del nodeSet antes de devolver los nombres.
		------------------------------------------------
		fn getNodes purge:true =
		(
			--_theNodes = #()
			
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			if purge then this.purge()
			
			/*----------------------------------------------
			--monta el string
			_executeString = "#("
			for n in this.infoNode.custAttributes[#nodeSetInfo].nodesNames do _executeString += ("$'" + n + "',")
			if _executeString[_executeString.count] == "," then _executeString = substring _executeString 1 (_executeString.count - 1)
			_executeString += ")"
			----------------------------------------------
			
			_theNodes = execute _executeString
			
			_theNodes*/
			
			(this.infoNode.custAttributes[#nodeSetInfo].nodes) as array
		),
		
		------------------------------------------------
		--@fn: array{string} | getNodesNames | Devuelve los nombres de los nodos del nodeSet
		--@opt: boolean | purge | true | Indica si hacer limpieza del nodeSet antes de devolver los nombres.
		------------------------------------------------
		fn getNodesNames purge:true =
		(
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			if purge then this.purge()
			
			this.infoNode.custAttributes[#nodeSetInfo].nodesNames
		),
				
		------------------------------------------------
		--@fn: node | getInfoNode | Devuelve el nodo físico de la escena que contiene la información del nodeSet
		------------------------------------------------
		fn getInfoNode =
		(
			this.infoNode
		),
		
		------------------------------------------------
		--@fn: dotneObject | getUiObj | Devuelve el objeto de interface .net que controla este objeto.
		------------------------------------------------
		fn getUiObj =
		(
			this.uiObj
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setCaption | Sustituye el nombre al nodeSet.
		--@gets: string | newCaption | Nuevo nombre para el nodeSet.
		------------------------------------------------
		fn setCaption newCaption =
		(
			_existingNodeSets = lb.nodeSets.getAll()
			_defCaption = newCaption --nombre definitivo
			
			-----------------------------
			--busca el indice
			_index = 0
			for ns in _existingNodeSets do --busca el indice que ponerle al nombre
			(
				if (ns.getCaption()) == newCaption and _index == 0 then _index = 1
				else if (matchPattern (ns.getCaption()) pattern:(newCaption + "#???")) then
				(
					_nParts = filterString (ns.getCaption()) "#"
					_enumeration = _nParts[2] as integer
					if _enumeration >= _index then _index = _enumeration + 1
				)
			)--for
			-----------------------------
			
			if _index > 0 then --si hay indice es porque esta repetido y hay que diferenciarlo
			(
				_indexString = _index as string
				while _indexString.count < 3 do _indexString = "0" + _indexString
				_defCaption = newCaption + "#" + _indexString
			)--if
			
			--aplica el nuevo nombre
			this.infoNode.custAttributes[#nodeSetInfo].caption = _defCaption
			this.infoNode.name = this.infoNodePrefix + _defCaption
		),
		
		------------------------------------------------
		--@fn: undefined | setType | Sustituye el tipo de objetos que puede almacenar el nodeSet.
		--@gets: name | newType | Nuevo tipo para el nodeSet. #default, #geometry, #light
		------------------------------------------------
		fn setType newType =
		(
			this.infoNode.custAttributes[#nodeSetInfo].type = (newType as string)
		),
		
		------------------------------------------------
		--@fn: undefined | setNodes | Sustituye los nodos almacenados en el nodeSet por otros.
		--@gets: array{node} | newNodes | Array de nodos para sustituir a los actuales.
		------------------------------------------------
		fn setNodes newNodes =
		(
			--si hay nodos procesa los que no sean del tipo que se necesite y los descarta.
			if newNodes.count != 0 then
			(
				case this.type of
				(
					"geometry": for i=newNodes.count to 1 by -1 where superClassOf newNodes[i] != GeometryClass do deleteItem newNodes i
					"light":for i=newNodes.count to 1 by -1 where superClassOf newNodes[i] != light do deleteItem newNodes i
				)--case
				
				--actualiza la informacion en el nodeSet y en su nodo de la escena
				this.infoNode.custAttributes[#nodeSetInfo].nodes = for n in newNodes where not matchPattern n.name pattern:(this.infoNodePrefix + "*") collect n
				this.infoNode.custAttributes[#nodeSetInfo].nodesNames = for n in newNodes where not matchPattern n.name pattern:(this.infoNodePrefix + "*") collect n.name
				
				this.sortNodeSetNodes()
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | setUiObj | Sustituye el objeto de interface relacionado con el container.
		--@gets: dotNetObject | newUiObj | Nuevo elemento de interface relacionado con el container.
		------------------------------------------------
		fn setUiObj newUiObj =
		(
			this.uiObj = newUiObj
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | sortNodeSetNodes | Ordena los nombres de los nodos del nodeSet de forma alfabética
		------------------------------------------------
		fn sortNodeSetNodes =
		(
			/*_nodeSetNodes = (this.infoNode.custAttributes[#nodeSetInfo].nodesNames as array)
			sort _nodeSetNodes
			this.infoNode.custAttributes[#nodeSetInfo].nodesNames = _nodeSetNodes*/
			
			_sortedNodes = lb.misc.sortNodesByName ((this.infoNode.custAttributes[#nodeSetInfo].nodes) as array)
			this.infoNode.custAttributes[#nodeSetInfo].nodes = _sortedNodes
			this.infoNode.custAttributes[#nodeSetInfo].nodesNames = for _n in _sortedNodes collect _n.name
		),
		
		------------------------------------------------
		--@fn: boolean | purge | Limpia los nodeSets por si se han pedido nodos en la escena. Devuelve TRUE si ha tenido que eliminar algun nodo y FALSE si no.
		------------------------------------------------
		fn purge mode:#normal =
		(
			_success = false
			
			--averigua cuantos nodos hay almacenados
			_nodesCount = this.infoNode.custAttributes[#nodeSetInfo].nodes.count
			_nodesNamesCount = this.infoNode.custAttributes[#nodeSetInfo].nodesNames.count
			
			--averigua el limite de recorrido cuando tenga que recorrer nodos o nombres de nodos
			_limit = _nodesCount; if _nodesNamesCount > _limit then _limit = _nodesNamesCount
			
			if _limit > 0 then
			(
				_objectsNames = #()
				_objectsVality = #()
				for _obj in objects do (append _objectsNames _obj.name; append _objectsVality (isValidNode _obj))
				
				--recorre los nodos almacenados para ver si hay incoherencias
				for i=_limit to 1 by -1 do
				(
					
					if not isValidNode this.infoNode.custAttributes[#nodeSetInfo].nodes[i] then
					(--si no encuentra el nodo almacenado
						
						--obtiene el nombre que tenia el nodo para poder buscarlo por nombre
						_name = this.infoNode.custAttributes[#nodeSetInfo].nodesNames[i]
						
						if _name != undefined and _name != "" then
						(--si tiene nombre de nodo
							_index = findItem _objectsNames _name --busca el nombre en la escena
							--if _name == "<Deleted Scene Node>" then _index = 0

							if _index != 0 and _objectsVality[_index] then
							(--si lo encuentra lo restaura
								this.infoNode.custAttributes[#nodeSetInfo].nodes[i] = objects[_index]
							)
							else
							(
								case mode of
								(
									#light:
									(--print "light purge"
										--si no encuentra el nodo, lo elimina de la lista
										this.infoNode.custAttributes[#nodeSetInfo].nodesNames[i] = "<Deleted Scene Node>"
									)

									#normal:
									(--print "normal purge"
										--si no encuentra el nodo, lo elimina de la lista
										deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodes i
										deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames i
									)
								)--case
							)--if else
						)
						else
						(--si tampoco tiene nombre de nodo almacenado, elimina ese indice del array de nodos, porque no puede recuperarlo
							deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodes i
							deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames i
						)
					)
					else
					(--si el nodo esta almacenado, comprueba que se siga llamando igual
						_name = this.infoNode.custAttributes[#nodeSetInfo].nodes[i].name
						
						if this.infoNode.custAttributes[#nodeSetInfo].nodesNames[i] != _name then
							this.infoNode.custAttributes[#nodeSetInfo].nodesNames[i] = _name
					)
				)--for
			)--if

			if mode == #full then
			(--print "full purge"
				_name = this.infoNode.name
				_transform = this.infoNode.transform

				_caption = this.infoNode.custAttributes[#nodeSetInfo].caption
				_type = this.infoNode.custAttributes[#nodeSetInfo].type

				_nodes = for _node in  this.infoNode.custAttributes[#nodeSetInfo].nodes collect _node
				_nodesNames = for _nodeName in  this.infoNode.custAttributes[#nodeSetInfo].nodesNames collect _nodeName

				custAttributes.delete this.infoNode (this.getNodeSetCA()) baseobject:false --le quita el atributo
				delete this.infoNode
				this.infoNode = undefined

				this.infoNode = point size:5 box:on cross:off axistripod:off centermarker:off --crea el nuevo nodo para el nodeSet
				this.infoNode.wirecolor = color 65 200 100
				this.infoNode.name = _name
				(lb.nodeSets.getLayer()).addNode this.infoNode --lo añade a la capa correspondiente
				this.infoNode.transform = _transform
				this.infoNode = this.infoNode

				custAttributes.add this.infoNode (this.getNodeSetCA()) #unique baseobject:false --le añade el atributo
				
				this.infoNode.custAttributes[#nodeSetInfo].caption = _caption
				this.infoNode.custAttributes[#nodeSetInfo].type = _type
			
				this.infoNode.custAttributes[#nodeSetInfo].nodes = deepCopy _nodes
				this.infoNode.custAttributes[#nodeSetInfo].nodesNames = deepCopy _nodesNames
			)--if

			_success
		),
		
		------------------------------------------------
		--@fn: boolean | addNode | Añade un nuevo elemento al nodeSet. Devuelve TRUE si el elemento se consigue añadir. FALSE si ya estaba en la lista
		--@gets: node | item | Elemento que se quiere añadir.
		------------------------------------------------
		fn addNode item =
		(
			_success = false
			_process = true
			
			--si el nodo no es del tipo admitido no lo añade
			case this.type of
			(
				"geometry": if superClassOf item != GeometryClass then _process = false
				"light": if superClassOf item != light then _process = false
			)--case
			
			if matchPattern item.name pattern:(this.infoNodePrefix + "*") then _process = false
			
			if _process then
			(
				--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
				this.purge()
				
				_index = findItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames item.name
				if _index == 0 then
				(
					append this.infoNode.custAttributes[#nodeSetInfo].nodes item
					append this.infoNode.custAttributes[#nodeSetInfo].nodesNames item.name
					this.sortNodeSetNodes()
				)--if
			)--if
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | addNodes | Añade un conjunto de elementos al nodeSet.
		--@gets: array{node} | items | Elementos que se quieren añadir.
		------------------------------------------------
		fn addNodes items =
		(
			if items.count != 0 then
			(
				--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
				this.purge()
				
				for it in items do
				(
					_process = true
					
					case this.type of
					(
						"geometry": if superClassOf it != GeometryClass then _process = false
						"light": if superClassOf it != light then _process = false
					)--case
					
					if matchPattern it.name pattern:(this.infoNodePrefix + "*") then _process = false
						
					if _process then
					(
						if appendIfUnique this.infoNode.custAttributes[#nodeSetInfo].nodesNames it.name then
							append this.infoNode.custAttributes[#nodeSetInfo].nodes it
					)
				)--for
					
				this.sortNodeSetNodes()
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | addNodesNames | Añade un conjunto de nombres de elementos al nodeSet.
		--@gets: array{string} | items | Nombres de los lementos que se quieren añadir.
		------------------------------------------------
		fn addNodesNames theNames =
		(
			if theNames.count != 0 then
			(
				/*--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
				this.purge()
				
				--elimina los nombres que no se deben añadir
				theNames = for n in theNames where not matchPattern n pattern:(this.infoNodePrefix + "*") collect n
				
				this.infoNode.custAttributes[#nodeSetInfo].nodesNames = makeUniqueArray ((this.infoNode.custAttributes[#nodeSetInfo].nodesNames as array) + theNames)
				
				this.sortNodeSetNodes()*/
				
				_items = for o in objects where findItem theNames o.name != 0 collect o
				this.addNodes _items				
			)--if
		),
		
		------------------------------------------------
		--@fn: integer | findNode | Busca el elemento en los nodos del nodeSet. Devuelve 0 si no lo encuentra o el índice del lugar que ocupa el elemento si se encuentra entre sus nodos.
		--@gets: node | item | Elemento que se busca.
		------------------------------------------------
		fn findNode item =
		(
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			this.purge()
			
			findItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames item.name
		),
		
		------------------------------------------------
		--@fn: integer | findNodeByName | Busca el nombre en los nodos del nodeSet. Devuelve 0 si no lo encuentra o el índice del lugar que ocupa el elemento si se encuentra entre sus nodos.
		--@gets: string | itemName | Nombre del elemento que se busca.
		------------------------------------------------
		fn findNodeByName itemName =
		(
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			this.purge()
			
			findItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames itemName
		),
		
		------------------------------------------------
		--@fn: boolean | removeNode | Busca el elemento en los nodos del nodeSet y lo quita del listado. Devuelve TRUE si el elemento estaba en lista y lo consigue eliminar. FALSE si no estaba en lista.
		--@gets: node | item | Elemento que se quiere eliminar.
		------------------------------------------------
		fn removeNode item =
		(
			_success = false
			
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			this.purge()
			
			--si el nodo esta en lista lo quita
			_index = findItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames item.name
			if _index != 0 then
			(
				deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodes _index
				deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames _index
				_success = true
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | removeNodes | Busca el elemento en los nodos del nodeSet y lo quita del listado.
		--@gets: array{node} | items | Elementos que se quieren eliminar.
		------------------------------------------------
		fn removeNodes items =
		(
			if items.count != 0 then
			(
				--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
				this.purge()
				
				for it in items do
				(
					_index = findItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames it.name
					
					if _index != 0 then
					(
						deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodes _index
						deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames _index
					)
				)--for
			)--if
		),
		
		------------------------------------------------
		--@fn: boolean | removeNodeByIndex | Busca el elemento que ocupa el lugar indicado en los nodos del nodeSet y lo quita del listado. Devuelve TRUE si el elemento estaba en lista y lo consigue eliminar. FALSE si no estaba en lista.
		--@gets: integer | index | Indice del elemento que se quiere eliminar.
		------------------------------------------------
		fn removeNodeByIndex index =
		(
			_success = false
			
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			this.purge()
			
			--si el indice está en lista lo quita
			if index > 0 and index <= this.infoNode.custAttributes[#nodeSetInfo].nodesNames.count then
			(
				deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodes index
				deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames index
				_success = true
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | removeNodeByName | Busca el elemento con el nombre indicado en los nodos del nodeSet y lo quita del listado. Devuelve TRUE si el elemento estaba en lista y lo consigue eliminar. FALSE si no estaba en lista.
		--@gets: string | theName | Nombre del elemento que se quiere eliminar.
		------------------------------------------------		
		fn removeNodeByName theName =
		(
			_success = false
			
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			this.purge()
			
			--si el indice está en lista lo quita
			if theName != undefined and theName != "" then
			(
				_index = findItem (this.infoNode.custAttributes[#nodeSetInfo].nodesNames) theName
				if _index != 0 then
				(
					deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodes _index
					deleteItem this.infoNode.custAttributes[#nodeSetInfo].nodesNames _index
					_success = true
				)
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | clear | Vacía los nodos del nodeSet. Lo deja sin nodos almacenados.
		------------------------------------------------
		fn clear =
		(
			this.infoNode.custAttributes[#nodeSetInfo].nodes = #()
			this.infoNode.custAttributes[#nodeSetInfo].nodesNames = #()
		),
		
		------------------------------------------------
		--@fn: undefined | selectNodes | Selecciona los nodos del nodeSet en la ecena.
		------------------------------------------------
		fn selectNodes =
		(
			select (this.getNodes())
		),	
		
		------------------------------------------------
		--@fn: undefined | createInfoNode | Crea el nodo de la escena que lleva la información del nodeSet y lo rellena.
		------------------------------------------------
		fn createInfoNode =
		(
			this.infoNode = point size:5 box:on cross:off axistripod:off centermarker:off --crea el nuevo nodo para el nodeSet
			this.infoNode.wirecolor = color 65 200 100
			this.infoNode.name = this.infoNodePrefix + this.caption
			(lb.nodeSets.getLayer()).addNode this.infoNode --lo añade a la capa correspondiente
			
			custAttributes.add this.infoNode (this.getNodeSetCA()) #unique baseobject:false --le añade el atributo
			this.infoNode.custAttributes[#nodeSetInfo].caption = this.caption; this.caption = undefined
			this.infoNode.custAttributes[#nodeSetInfo].type = this.type as string; this.type = "default"
			
			this.infoNode.custAttributes[#nodeSetInfo].nodes = this.nodes 
			this.infoNode.custAttributes[#nodeSetInfo].nodesNames = (for n in this.nodes collect n.name)
			this.nodes = #()
				
			lb.nodeSets.placeInScene() --recoloca todos los nodeSets en posiciones adyacentes.
		),
		
		------------------------------------------------
		--@fn: undefined | construct | Rellena la información del set de nodos y crea el objeto fisico en la escena que contendrá la información.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la información la coge de el.
			if isValidNode this.infoNode then
			(			
				--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
				this.purge()
			)
			else --si se está creando un nuevo nodeSet
			(
				-----------------------------------------
				--asigna el nombre al nodeSet. Si no se ha pasado nombre se le asigna uno por defecto. Si el que se ha pasado ya existe, se le añade un índice detras.
					
				--si no se ha asignado nombre se le asigna uno por defecto
				if this.caption == undefined then this.caption = "newNodeSet"
				
				--si se ha asignado un nombre se comprueba que no haya ya un nodeSet con el mismo. Si lo hay le añade un indice.
				if this.caption != undefined then
				(
					_existingNodeSets = lb.nodeSets.getAll()
					
					-----------------------------
					--busca el indice
					_defCaption = this.caption
					_index = 0
					for ns in _existingNodeSets do --busca el indice que ponerle al nombre
					(
						if (ns.getCaption()) == this.caption and _index == 0 then _index = 1
						else if (matchPattern (ns.getCaption()) pattern:(this.caption + "#???")) then
						(
							_nParts = filterString (ns.getCaption()) "#"
							_enumeration = _nParts[2] as integer
							if _enumeration >= _index then _index = _enumeration + 1
						)
					)--for
					-----------------------------
					
					--si hay indice es porque esta repetido y hay que diferenciarlo
					if _index > 0 then this.caption = this.caption + "#" + (formattedprint _index format:"03d")
				)--if
				
				-----------------------------------------
				
				--si hay nodos procesa los que no sean del tipo que se necesite y los descarta.
				/*if this.nodesNames.count != 0 then
				(
					case this.type of
					(
						"geometry": for i=this.nodesNames.count to 1 by -1 where superClassOf (this.nodesNames[i]) != GeometryClass do deleteItem this.nodesNames i
						"light":for i=this.nodesNames.count to 1 by -1 where superClassOf (this.nodesNames[i]) != light do deleteItem this.nodesNames i
					)--case
					
					this.nodesNames = for n in this.nodesNames where not matchPattern n.name pattern:(this.infoNodePrefix + "*") collect n.name
					sort this.nodesNames
				)--if	*/
				
				--si hay nodos procesa los que no sean del tipo que se necesite y los descarta.
				if this.nodes.count != 0 then
				(
					case this.type of
					(
						"geometry": for i=this.nodes.count to 1 by -1 where superClassOf (this.nodes[i]) != GeometryClass do deleteItem this.nodes i
						"light":for i=this.nodes.count to 1 by -1 where superClassOf (this.nodes[i]) != light do deleteItem this.nodes i
					)--case
					
					this.nodes = for n in this.nodes where not matchPattern n.name pattern:(this.infoNodePrefix + "*") collect n					
					
					this.nodes = lb.misc.sortNodesByName this.nodes
				)--if	
				
				--crea el nodo de la escena que va a llevar la información del nodeSet.
				this.createInfoNode()
			)			
		),
		
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la representacion del contenido del nodeSet.
		------------------------------------------------
		fn toString =
		(	
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			this.purge()
			
			_theString = ""
				
			_theString += "<nodeSet>\n"
			_theString += "	<name>" + this.infoNode.custAttributes[#nodeSetInfo].caption + "</name>\n"
			_theString += "	<type>" + this.infoNode.custAttributes[#nodeSetInfo].type + "</type>\n"
			_theString += "	<nodes>\n"
			for n in this.infoNode.custAttributes[#nodeSetInfo].nodesNames do _theString += "		<node>" + n + "</node>\n"
			_theString += "	</nodes>\n"
			_theString += "</nodeSet>\n"
			
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
		--@event | create | Ejecución al crearse la instancia del struct.
		on create do
		(
			this.construct() --genera toda la información necesaria y el nodo de la escena donde almacenarla en paralelo, o lee el ya existente en la escena.
		)
		
	)--lib_nodeSet
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: nodeSets | Contiene todas las funciones de nodeSets personalizados.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_nodeSets
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria sets de nodos personalizados",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		nodeSet = lib_nodeSet,				--@var: nodeSet | Struct de nodeSets individuales.
		
		infoNodePrefix = "nodeSet-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada nodeSet.
		
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
		--@fn: LayerProperties | getLayer | Devuelve la capa que contiene los nodos auxiliares con la información de nodeSets.		
		------------------------------------------------
		fn getLayer =
		(
			_theLayer = lb.layer.getLayerByName "aux-nodeSets" --[[CAMBIAR ESTO POR LA VARIABLE DEL NAMING CONVENTION CORRESPONDIENTE CUANDO ESTE HECHO]]
			if _theLayer == undefined then
			(
				_theLayer = lb.layer.newLayer name:"aux-nodeSets"
				_theLayer.ishidden = true
				_theLayer.isfrozen = true
			)
			
			_theLayer
		),
		
		------------------------------------------------
		--@fn: array{node} | getAllInfoNodes | Devuelve los objetos de la escena que contienen informacion de nodeSets
		------------------------------------------------
		fn getAllInfoNodes =
		(
			_infoNodes = lb.layer.getLayerNodes (this.getLayer())
			for i=_infoNodes.count to 1 by -1 where not isValidNode _infoNodes[i] or (_infoNodes[i].custAttributes[#nodeSetInfo] == undefined) do deleteItem _infoNodes i
			
			_infoNodes = lb.misc.sortNodesByName _infoNodes
				
			_infoNodes
		),

		------------------------------------------------
		--@fn: array{nodeSet} | getAll | Devuelve los nodeSets de la escena
		------------------------------------------------
		fn getAll =
		(
			_nodeSetNodes = this.getAllInfoNodes()
				
			_theNodeSets = for n in _nodeSetNodes collect this.newNodeSet infoNode:n --crea un nodeSet en memoria por cada uno de la escena
			_theNodeSets = this.sortNodeSetsByCaption _theNodeSets --los ordena por nombre
			
			_theNodeSets
		),
		
		------------------------------------------------
		--@fn: array{nodeSet} | getByCaption | Devuelve los nodeSets que tengan el nombre solicitado y cualquiera de sus enumeraciones
		--@gets: string | caption | Nombre del nodeSet que se solicita.
		--@opt: boolean | enumerated | false | Indica si devolver todos los nodeSets derivados del que se solicita mediante su numeracion.
		------------------------------------------------
		fn getByCaption caption enumerated:false =
		(
			_theNodeSets = #()
			
			_allNodeSets = this.getAll() --obtiene todos los nodeSets
			if not enumerated then for ns in _allNodeSets where (ns.getCaption()) == caption do _theNodeSets = #(ns) --se queda con el que coincida en nombre
			else for ns in _allNodeSets where (ns.getCaption()) == caption or matchPattern (ns.getCaption()) pattern:(caption + "#????") do
				append _theNodeSets ns --se queda con el que coincida en nombre o cumpla el patron
			_theNodeSets = this.sortNodeSetsByCaption _theNodeSets --los ordena por nombre
			
			_theNodeSets
		),
		
		------------------------------------------------
		--@fn: array{nodeSet} | getByType | Devuelve los nodeSets que tengan el tipo solicitado.
		--@gets: name | type | Nombre del nodeSet que se solicita. #default, #geometry, #light
		------------------------------------------------
		fn getByType type =
		(
			_theNodeSets = #()
			
			_allNodeSets = this.getAll() --obtiene todos los nodeSets
			_theNodeSets = for ns in _allNodeSets where (ns.getType()) == (type as string) collect ns --se queda con el que coincida en tipo
			_theNodeSets = this.sortNodeSetsByCaption _theNodeSets --los ordena por nombre
			
			_theNodeSets
		),
		
		------------------------------------------------
		--@fn: array{string} | getFileNodeSetNames | Nombres de los nodeSets de un archivo en concreto.
		--@gets: string | file | Path completo del archivo del cual se quieren consultar los nodeSets.
		------------------------------------------------
		fn getFileNodeSetCaptions file =
		(
			_nodeSetCaptions = #()
			
			--si ele archivo pasado existe, entonces intenta ver los nodeSets que tiene dentro
			if doesFileExist file then
			(
				_fileNames = getMAXFileObjectNames file quiet:true
				_nodeSetCaptions = for _name in _fileNames where matchPattern _name pattern:(this.infoNodePrefix + "*") collect _name
			)
				
			_nodeSetCaptions
		),
		
		------------------------------------------------
		--@fn: array{node} | getAllnodesetsNodes | Devuelve todos los nodos de todos los nodeSets.
		------------------------------------------------
		fn getAllnodesetsNodes =
		(
			_nodes = #()

			_allNodeSets = this.getAll()
			for _ns in _allNodeSets do _nodes += _ns.getNodes()

			_nodes
		),	

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: integer | compareNodeSetsByCaption | Compara dos nodeSets por nombre. Devuelve 0 si tienen el mismo nombre, -1 si el nombre del primero va antes que el del segundo, 1 si el nombre del segundo va antes. 
		--@gets: node | node1 | Primer nodeSet a comparar.
		--@gets: node | node2 | Segundo nodeSet a comparar.
		--@opt: boolean | invert | false | Indica si devolver el resultado invertido, para ordenaciones inversas.
		--@opt: boolean | ignoreCase | false | Indica si tener en cuenta mayusculas y minusculas.
		------------------------------------------------
		fn compareNodeSetsByCaption node1 node2 invert:false ignoreCase:false =
		(			
			--obtiene los nombres de los dos nodos
			caption1 = node1.infoNode.custAttributes[#nodeSetInfo].caption
			caption2 = node2.infoNode.custAttributes[#nodeSetInfo].caption
			
			--si no tiene en cuenta mayusculas y minusculas lo pasa todo a minusculas
			if ignoreCase then
			(
				caption1 = tolower node1.infoNode.custAttributes[#nodeSetInfo].caption
				caption2 = tolower node2.infoNode.custAttributes[#nodeSetInfo].caption
			)--if
			
			--realiza las comparaciones
			if caption1 == caption2 then --si los nombres son iguales devuelve 0
				0
			else --si nos osn iguales los compara
			(
				auxArray = sort #(caption1, caption2)					
				if caption1 == auxArray[1] then (if invert then 1 else -1)
				else (if invert then -1 else 1)
			)--if else
		),
		
		------------------------------------------------
		--@fn: array{nodeSet} | sortNodeSetsByCaption | Ordena los nodeSets de un array de forma alfabética y lo devuelve.
		--@gets: array{nodeSet} | nodeSets | Array de nodeSets a ordenar.
		--@opt: boolean | invert | false | Indica si devolver el resultado invertido, para ordenaciones inversas.
		--@opt: boolean | ignoreCase | false | Indica si tener en cuenta mayusculas y minusculas.
		--@returns: array{nodeSet} | Array de nodeSets ordenados.
		------------------------------------------------
		fn sortNodeSetsByCaption nodeSets invert:false ignoreCase:false =
		(
			qsort nodeSets this.compareNodeSetsByCaption invert:invert ignoreCase:ignoreCase
			
			nodeSets
		),
		
		------------------------------------------------
		--@fn: nodeSet | newNodeSet | Crea un nuevo set de nodos personalizado y lo devuelve. 
		--@opt: string | caption | undefined | Nombre que se le dará el nuevo nodeSet creado. Si ya existe no lo crea y lo devuelve.
		--@opt: name | type | "default" | Tipo de set de nodos. Indica que tipo de nodos puede almacenar. Por defecto todos. Opciones: #default, #geometry, #light.
		--@opt: array{nodes} | nodes | undefined | Conjunto de nodos que incluir en el nodeSet creado. Si el nodeSet ya existe, incluye los nodos en el si no estuvieran ya.
		--@opt: node | infoNode | undefined | Nodo de la escena con la información de un nodeSet y a partir del cual generar un nodeSet en memoria.
		------------------------------------------------
		fn newNodeSet caption:undefined type:#default nodes:#() infoNode:undefined =
		(
			_theNodeSet = undefined
			
			_theNodeSet = this.nodeSet caption:caption type:(type as string) nodes:nodes infoNode:infoNode --crea el nuevo set de nodos o lee uno de la escena
				
			_theNodeSet
		),
		
		------------------------------------------------
		--@fn: nodeSet | duplicateNodeSet | Duplica un set de nodos pasado por parametro y lo devuelve. Lo nombra igual añadiendo un subindice.
		--@gets: nodeSet | theNodeSet | Set de nodos personalizado que se quiere duplicar
		------------------------------------------------
		fn duplicateNodeSet theNodeSet =
		(
			_theNodeSet = undefined
			
			--crea un set de nodos nuevo con el mismo nombre, tipo y nodos. La funcion de creacion se encarga de ponerle nombre con un índice.
			_theCaption = (filterString (theNodeSet.getCaption()) "#")[1]
			_theNodeSet = this.nodeSet caption:_theCaption type:(theNodeSet.getType()) nodes:(theNodeSet.getNodes()) infoNode:undefined
			
			_theNodeSet
		),
		
		------------------------------------------------
		--@fn: undefined | placeInScene | Recoloca los nodos de los nodeSets en la escena.
		------------------------------------------------
		fn placeInScene =
		(
			--obtiene los nodeSets ordenados por nombre
			_allNodeSets = lb.misc.sortNodesByName (for ns in (this.getAll()) collect ns.infoNode)
				
			_initialPosition = [5,0,-10] --posicion del primero
			_increment = [5,0,0] --incremento de uno a otro
			for i=1 to _allNodeSets.count do _allNodeSets[i].position = _initialPosition + (_increment*(i-1)) --los posiciona
		),
		
		------------------------------------------------
		--@fn: undefined | removeAll | Elimina todos los nodeSets de la escena.
		------------------------------------------------
		fn removeAll =
		(
			--obtiene los nodeSets y los elimina.
			_allNodeSets = (for ns in (this.getAll()) collect ns.infoNode)
			delete _allNodeSets
				
			this.placeInScene() --recoloca los nodos en la escena.
		),
		
		------------------------------------------------
		--@fn: boolean | removeNodeSet | Elimina el nodeSet pasado por parametro. Devuelve TRUE si lo consigue eliminar y FALSE si no.
		--@gets: nodeSet | theNodeSet | nodeSet que se quiere eliminar
		------------------------------------------------
		fn removeNodeSet theNodeSet =
		(
			delete (theNodeSet.getInfoNode())
		),
		
		------------------------------------------------
		--@fn: undefined | removeByCaption | Elimina todos los nodeSets segun el nombre indicado.
		--@gets: string | caption | Nombre del nodeSet que se quiere eliminar.
		--@opt: boolean | enumerated | false | Indica si eliminar todos los nodeSets derivados del que se solicita mediante su numeracion.
		------------------------------------------------
		fn removeByCaption caption enumerated:false =
		(
			--obtiene los nodeSets adecuados y los elimina.
			_theNodeSets = (for ns in (this.getByCaption caption enumerated:enumerated) collect ns.infoNode)
			delete _theNodeSets
			
			this.placeInScene() --recoloca los nodos en la escena.
		),
		
		------------------------------------------------
		--@fn: undefined | removeByType | Elimina todos los nodeSets segun el nombre indicado.
		--@gets: string | type | Tipo del nodeSet que se quiere eliminar.
		------------------------------------------------
		fn removeByType type =
		(
			--obtiene los nodeSets adecuados y los elimina.
			_theNodeSets = (for ns in (this.getByType type) collect ns.infoNode)
			delete _theNodeSets
			
			this.placeInScene() --recoloca los nodos en la escena.
		),
		
		------------------------------------------------
		--@fn: boolean | loadNodeSetsFromFile | Carga los nodeSets del archivo que se le indique y devuelve TRUE si lo consigue. FALSE si no.
		--@gets: string | file | Path completo del archivo del cual se quieren cargar los nodeSets.
		--@opt: array{string} | captions | #() | Nombres específicos de los nodeSets de la archivo para cargar solo esos.
		--@opt: boolean | overWriteDuplicated | true | Indica si sobrescribir los duplicados.
		------------------------------------------------
		fn loadNodeSetsFromFile file captions:#() overWriteDuplicated:true =
		(
			_success = false
			
			--si el archivo existe los intenta cargar
			if doesFileExist file then
			(
				_nodesToMerge = (if captions.count != 0 then captions else (this.getFileNodeSetCaptions file))
				_success = mergeMAXFile file _nodesToMerge (if overWriteDuplicated then #deleteOldDups else #skipDups) quiet:true
				if _success then for _ns in this.getAll() do _ns.purge()
			)
			
			_success
		),

		------------------------------------------------
		--@fn: boolean | importNodeSetsFromSelectionSets | Crea un nodeSet por cada selectionSet. Devuelve TRUE si lo consigue y FALSE si no.
		------------------------------------------------
		fn importNodeSetsFromSelectionSets =
		(
			_success = false

			_selSetsNames = #() --array para los nombres de los selectionSets
			_selSetsNodes = #() --array para los objetos de los selectionSets

			--recopila los selection sets
			for i=1 to selectionSets.count do
			(
				append _selSetsNames (getNamedSelSetName i)
				append _selSetsNodes (for o in selectionSets[i] collect o)				
			)--for

			--recopila los nodeSets
			--_nodeSetsNames = makeUniqueArray (for ns in this.getAll() collect (FilterString (ns.getCaption()) "#")[1])
			_nodeSets = this.getAll()
			_nodeSetsNames = for ns in _nodeSets collect ns.getCaption()

			--comprueba si hay nodesets ya creados con los nombres de los selection sets
			_matchingNames = for _ssn in _selSetsNames where findItem _nodeSetsNames _ssn != 0 collect _ssn

			_overwirte = #no
			if _matchingNames.count != 0 then _overwirte = yesNoCancelBox "There are coincidences betwen Node Sets names and Selection Sets names.\n\nYES: New selection sets will be imported and coincident will be overwriten.\nNO: Only the new selection sets will be imported.\n\nDo you want to update the current Node Sets information?"

			case _overwirte of
			(
				#yes: --crea los que no existen y los que si, los actualiza con el contenido
				(
					for i=1 to _selSetsNames.count do
					(
						_index = findItem _matchingNames _selSetsNames[i]

						if _index != 0 then --si existe actualiza el contenido
						(
							_nsIndex = findItem _nodeSetsNames _matchingNames[_index]
							if _nsIndex != 0 then
							(
								_nodeSet = _nodeSets[_nsIndex]
								_nodeSet.setNodes _selSetsNodes[i]
							)--if
						)
						else --si no existe lo crea
						(
							lb.nodeSets.newNodeSet caption:_selSetsNames[i] nodes:_selSetsNodes[i]
						)--if else

					)--for

					_success = true
				)--yes
				
				#no: --crea solo los que no existen ya, y los que si existen no los actualiza
				(
					for i=1 to _selSetsNames.count where (findItem _matchingNames _selSetsNames[i] == 0) do lb.nodeSets.newNodeSet caption:_selSetsNames[i] nodes:_selSetsNodes[i]

					_success = true
				)--no
			)--case

			_success
		),
		
		------------------------------------------------
		--@fn: boolean | exportNodeSetsToSelectionSets | Crea un selection set por cada nodeSet. Devuelve TRUE si lo consigue y FALSE si no.
		------------------------------------------------
		fn exportNodeSetsToSelectionSets =
		(
			_success = false

			_selSetsNames = for i=1 to selectionSets.count collect (getNamedSelSetName i) --array para los nombres de los selectionSets

			--recopila los nodeSets
			--_nodeSetsNames = makeUniqueArray (for ns in this.getAll() collect (FilterString (ns.getCaption()) "#")[1])
			_nodeSets = this.getAll()
			_nodeSetsNames = for ns in _nodeSets collect ns.getCaption()

			--comprueba si hay nodesets ya creados con los nombres de los selection sets
			_matchingNames = for _nsn in _nodeSetsNames where findItem _selSetsNames _nsn != 0 collect _nsn

			_overwirte = #no
			if _matchingNames.count != 0 then _overwirte = yesNoCancelBox "There are coincidences betwen Node Sets names and Selection Sets names.\n\nYES: New node sets will be exported and coincident will be overwriten.\nNO: Only the new node sets will be exported.\n\nDo you want to update the current Selection Sets information?"

			case _overwirte of
			(
				#yes: --crea los que no existen y los que si, los actualiza con el contenido
				(
					for i=1 to _nodeSetsNames.count do selectionSets[(_nodeSetsNames[i])] = deepCopy (_nodeSets[i].getNodes() as array)
					_success = true
				)--yes
				
				#no: --crea solo los que no existen ya, y los que si existen no los actualiza
				(
					for i=1 to _nodeSetsNames.count where (findItem _matchingNames _nodeSetsNames[i] == 0) do selectionSets[(_nodeSetsNames[i])] = deepCopy (_nodeSets[i].getNodes() as array)
					_success = true
				)--no
			)--case

			_success
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
		
	)--lib_nodeSets
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_nodeSets() --crea la libreria
	
	ok
)