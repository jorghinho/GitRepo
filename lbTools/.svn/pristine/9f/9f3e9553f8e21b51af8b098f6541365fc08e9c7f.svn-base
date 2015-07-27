--------------------------
-- TAREAS PENDIENTES
-------------------------


------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de objectSets
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@custAttribute: undefined | dynConnect | Custom Attribute que se añadirá a los nodos que necesiten conexión en tiempo de carga en la escena
	------------------------------------------------------------------------------------------------------------------------------------------------
	CA_objectSets = attributes objectSets
	(
		parameters main
		(
			--guarda la descripcion del CA y su version
			CA_description	type:#string	animatable:false	default:"Información persistente de los Selection Sets a los que pertenece la pieza"
			CA_version		type:#float		animatable:false	default:1.0
			
			names			type:#stringTab		animatable:false	tabSizeVariable:true
		)
		
		--------------------------------------------------
		on load do
		(
		)
		
		--------------------------------------------------
		on create do
		(
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: objectSets | Contiene la libreria de objectSets.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_objectSets
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Librería objectSets",	--@var: description | Descripcion de la libreria.
		
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

		-----------------------------------------------------------------------------------------------------
		--@fn: get | getAll | Devuelve todos los objectsSets de la escena y dos parametros: name, nodes.
		-----------------------------------------------------------------------------------------------------
		fn getAll = 
		(
			_sceneObjSets = #() --Variable que devuelve el resultado de la funcion 
			_objSetNames = #() --Variable que contiene los nombres de los objectsSets 

			struct strObjectSets
			(
				caption = "",
				nodes = #()
			)

			--Recorre los objetos de la escena para ver si contienen objectSets 
			for obj in objects do 
			( 
				if (this.hasObjectSets obj) then --Si el objeto contiene la propiedad ObjectSets...
				(
					--Obtengo los objectSets del objeto y los almacenamos en un array para utilizarlos luego.
					_objSets = this.get obj
					for _os in _objSets do appendIfUnique _objSetNames _os 
				)--if
			)--for   

			sort _objSetNames

			for _name in _objSetNames do 
			(
				_newObjSet = strObjectSets()
				_newObjSet.caption = _name
 				_newObjSet.nodes = this.getObjectsByObjSetName _name

				append _sceneObjSets _newObjSet
			) --for 

			_sceneObjSets
		),

		-----------------------------------------------------------------------------------------------------
		--@fn:  gets | getObjectsByObjSetName | Funcion que guarda los objectSets de los objetos de la escena y los guarda en un array.
		-----------------------------------------------------------------------------------------------------
		fn getObjectsByObjSetName objSetName =
		( 
			_nodes = #() --Array vacio para guardar los nodos de los objectSets 

			--Recorre los objetos de la escena para ver si contienen objectSets 
			for obj in objects do 
			( 
				if (this.hasObjectSets obj) then 
				(
					--Obtengo los objectSets del objeto y los almacenamos en un array para utilizarlos luego.
					_objSets = this.get obj
					if findItem _objSets objSetName != 0 then append _nodes obj    
				)--if
			)--for   

			_nodes 
		),

		-----------------------------------------------------------------------------------------------------
		--@fn:  array{string} | getObjectSets | Devuelve los Sets a los que pertenece el objeto OBJ
		--@gets: node | obj | nodo al que hay que iniciarle el objectSets
		-----------------------------------------------------------------------------------------------------
		fn get obj =
		(
			_objSets = #()
			if this.hasObjectSets obj do join _objSets obj.objectSets.names
			
			_objSets
		),
		
		-----------------------------------------------------------------------------------------------------
		--@fn: array{node} | getNodesInSameObjectSet | Devuelve un array de objetos que pertenecen a los sets de los que forman parte los nodos OBJs.
		-----------------------------------------------------------------------------------------------------
		fn getNodesInSameObjectSet objs = 
		(
			_objsInSets = #()
			_objetSets = #()		-- sets de los objetos objs
			_candidateNodes = #()	-- objetos de los layers a los que pertenecen objs
			
			if classOf objs != array then objs = #(objs)
			
			-- primero recopilamos todos los nodos de los layers a los que
			-- pertenece cada objeto de OBJs que tenga definido un object set
			for _o in objs do
			(
				if (this.hasObjectSets _o) then
				(
					for _objSet in _o.objectSets.names do appendIfUnique _objetSets _objSet
					_nodes = #()
					(_o.layer).nodes &_nodes
					for _node in _nodes do appendIfUnique _candidateNodes _node
				)
			)

			-- entre todos los nodos resultantes elegimos los que pertenecen a alguno de los sets recopilados
			for _node in _candidateNodes do
				if (this.hasObjectSets _node) then
					for _setName in _node.objectSets.names do
						if (finditem _objetSets _setName != 0) then appendifunique _objsInSets _node
			
			_objsInSets
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: boolean | hasObjectSets | Indica si el objeto especificado tiene objectSets
		--@gets: node | obj | al que preguntar si tiene objectSets
		------------------------------------------------
		fn hasObjectSets obj = 
		(
			lb.customAttributes.hasAttribute obj #objectSets
		),
		
		------------------------------------------------
		--@fn: boolean | add | Añade el objectSets al fichero pasado por parámetro. Devuelve true o false dependiendo si ha conseguido crearlo
		--@gets: node | obj | nodo al que hay que iniciarle el objectSets
		--@opt: boolean | replace | Indica si hay que reemplazar el objectSets anterior o simplemente incrementar su información
		------------------------------------------------
		mapped fn addAttribute obj =
		(
			_added = false
			
			-- Eliminamos primero el customAttribute de la pieza si ya lo tenía y creamos uno nuevo
			this.removeAttribute obj
			custAttributes.add obj CA_objectSets #unique baseobject:false
				
			_added = true
			
			_added
		),
		
		------------------------------------------------
		--@fn: boolean | removeAttribute | Elimina el objectSets al fichero pasado por parámetro
		--@gets: node | obj | nodo al que hay que iniciarle el objectSets
		------------------------------------------------
		mapped fn removeAttribute obj =
		(
			_removed = false
			
			if hasObjectSets obj then 
			(
				custAttributes.delete obj (custAttributes.getdef obj.objectSets) baseobject:false
				_removed = true
			)
			
			_removed
		),
		
		------------------------------------------------
		--@fn:  string array | add | Añade el objectSets al fichero pasado por parámetro. Si no existía el custom attribute lo crea
		--@gets: node | obj | nodo al que hay que iniciarle el objectSets
		--@opt: boolean | replace | Indica si hay que reemplazar el objectSets anterior o simplemente incrementar su información
		------------------------------------------------
		mapped fn add obj objectSetNames replace:false =
		(
			-- si la pieza no tiene objectSets creamos un nuevo custom attribute
			if not (this.hasObjectSets obj) then
				this.addAttribute obj
			
			if classOf objectSetNames != array then objectSetNames = #(objectSetNames)
			
			if replace then this.clear obj

			for _setName in objectSetNames do appendIfUnique obj.objectSets.names _setName
			
			obj.objectSets.names
		),
		
		------------------------------------------------
		--@fn:  string array | remove | Elimina los objectSets indicados en objectSetNames del objeto obj
		--@gets: node | obj | nodo al que hay que iniciarle el objectSets
		--@opt: boolean | replace | Indica si hay que reemplazar el objectSets anterior o simplemente incrementar su información
		------------------------------------------------
		mapped fn remove obj objectSetNames =
		(
			_objectSets = #()
			
			-- si la pieza no tiene objectSets creamos un nuevo custom attribute
			if (this.hasObjectSets obj) then
			(
				for _setName in objectSetNames do
				(
					_index = findItem obj.objectSets.names _setName
					if _index != 0 then
						deleteItem obj.objectSets.names _index
				)
				
				_objectSets = obj.objectSets.names
			)
			
			_objectSets
		),
		
		------------------------------------------------
		--@fn:  string array | removeSets | Añade el objectSets al fichero pasado por parámetro. Si no existía el custom attribute lo crea
		--@gets: node | obj | nodo al que hay que iniciarle el objectSets
		--@opt: boolean | replace | Indica si hay que reemplazar el objectSets anterior o simplemente incrementar su información
		------------------------------------------------
		mapped fn clear obj =
		(
			_cleared = false
			
			-- si la pieza no tiene objectSets creamos un nuevo custom attribute
			if (this.hasObjectSets obj) then
			(
				obj.objectSets.names = #()
				
				_cleared = true
			)
			
			_cleared
		),

		--------------------------------------------------
		----@fn: nodeSet | newNodeSet | Crea un nuevo objectSet personalizado y lo devuelve. 
		--------------------------------------------------
		fn newObjectSet caption:"newObjectSet" nodes:#() replace:true =
		(
			if nodes.count == 0 then nodes = getCurrentSelection() as array --Si no hay ningun objecSet en escena, los nodos pasan a ser la seleccion de la escena.
			if replace then this.removeAttribute nodes --Si se reemplaza por otro object set, eliminamos el attribute

			_sceneObjSets = this.getAll() --Almacenamos todos los nodesets en _sceneObjSets
			
			_captionIndex = 0
			_captionIndexDef = 0

			for os in _sceneObjSets where os.caption == caption or (MatchPattern os.caption pattern:(caption + "#???")) do --Recorre todos los objectSets de la escena y compara los nombres.
			(
				_capParts = FilterString os.caption "#" --Variable que utilizamos para buscar dentro de un string a partir del simbolo #
				
				if _capParts.count == 1 and _captionIndex == 0 then
				(
					_captionIndex += 1
					_captionIndexDef += 1
				)
				else if (_capParts.count == 2) and ((_capParts[2] as integer) >= _captionIndex) then _captionIndexDef = (_capParts[2] as integer) + 1
			)--for
			
			if _captionIndex > 0 and _captionIndexDef > 0 then caption = caption + "#" + (formattedPrint (_captionIndexDef) format: "03d") --Formato de nomenclatura que tendra el nuevo nombre 001..

			this.add nodes caption replace:replace -- La funcion add tambien tiene un parametro replace, utilizamos esta forma para que aplique el replace esta funciion que estamos llamando (add)
		),

	  	--------------------------------------------------
		----@fn: removeByCaption | removeByCaption | Elimina el objectSet seleccionado, y si alguno no tiene ningun objectSet elimina el attribute.
		--------------------------------------------------	
	  	fn removeByCaption caption = 
	  	(	
	  		_sceneObjSets = this.getAll() --Alamacenamos en _sceneObjSets todos los objectSets de la escena.

	  		for os in _sceneObjSets where os.caption == caption do --Recorre los objectSets y compara los nombres de estos.
	  		(
	  			this.remove os.nodes #(caption) --Borra los objectSets con el nombre que le hemos pasado.
	  			for obj in os.nodes do 
	  			(
	  				_objSets = this.get obj  
	  				if _objSets.count == 0 then this.removeAttribute obj --Si los objetos que llevaban el objectSet eliminado no estan en otro objectSets eliminamos el Attribute.  
	  			)
	  		)
	  	),

	  	------------------------------------------------
		--@fn: boolean | exportObjectSetsToSelectionSets | Crea un selection set por cada objectSet. Devuelve TRUE si lo consigue y FALSE si no.
		------------------------------------------------
		fn exportObjectSetsToSelectionSets =
		(
			_success = false

			_selSetsNames = for i=1 to SelectionSets.count collect (getNamedSelSetName i) --array para los nombres de los selectionSets

			_objectSets = this.getAll()
			_objectSetsNames = for os in _objectSets collect os.caption 

			--comprueba si hay nodesets ya creados con los nombres de los selection sets
			_matchingNames = for _osn in _objectSetsNames where findItem _selSetsNames _osn != 0 collect _osn

			_overwrite = #no
			if _matchingNames.count != 0 then _overwrite = yesNoCancelBox "There are coincidences betwen Node Sets names and Selection Sets names.\n\nYES: New node sets will be exported and coincident will be overwriten.\nNO: Only the new node sets will be exported.\n\nDo you want to update the current Selection Sets information?"

			case _overwrite of
			(
				#yes: --crea los que no existen y los que si, los actualiza con el contenido
				(
					for i=1 to _objectSetsNames.count do selectionSets[(_objectSetsNames[i])] = deepCopy (_objectSets[i].nodes)
					_success = true
				)--yes
				
				#no: --crea solo los que no existen ya, y los que si existen no los actualiza
				(
					for i=1 to _objectSetsNames.count where (findItem _matchingNames _objectSetsNames[i] == 0) do selectionSets[(_objectSetsNames[i])] = deepCopy (_objectSets[i].nodes)
					_success = true
				)--no
			)--case

			_success
		),

		------------------------------------------------
		--@fn: boolean | importObjectSetsFromSelectionSets | Crea un nodeSet por cada selectionSet. Devuelve TRUE si lo consigue y FALSE si no.
		------------------------------------------------
		fn importObjectSetsFromSelectionSets =
		(
			_success = false

			_selSetsNames = #() --array para los nombres de los selectionSets
			_selSetsObjects = #() --array para los objetos de los selectionSets

			--recopila los selection sets
			for i=1 to selectionSets.count do
			(
				append _selSetsNames (getNamedSelSetName i)
				append _selSetsObjects (for o in selectionSets[i] collect o)				
			)--for

			--recopila los nodeSets
			--_nodeSetsNames = makeUniqueArray (for ns in this.getAll() collect (FilterString (ns.getCaption()) "#")[1])
			_objectSets = this.getAll()
			_objectSetsNames = for os in _objectSets collect os.caption

			--comprueba si hay nodesets ya creados con los nombres de los selection sets
			_matchingNames = for _ssn in _selSetsNames where findItem _objectSetsNames _ssn != 0 collect _ssn

			_overwirte = #no
			if _matchingNames.count != 0 then _overwirte = yesNoCancelBox "There are coincidences betwen Object Sets names and Selection Sets names.\n\nYES: New selection sets will be imported and coincident will be overwriten.\nNO: Only the new selection sets will be imported.\n\nDo you want to update the current Object Sets information?"

			case _overwirte of
			(
				#yes: --crea los que no existen y los que si, los actualiza con el contenido
				(
					for i=1 to _selSetsNames.count do
					(
						_index = findItem _matchingNames _selSetsNames[i]

						if _index != 0 then --si existe actualiza el contenido
						(
							_osIndex = findItem _objectSetsNames _matchingNames[_index]
							if _osIndex != 0 then
							(
								_objectSet = _objectSets[_osIndex]
								_objectSet.nodes _selSetsObjects[i]
							)--if
						)
						else --si no existe lo crea
						(	
							lb.objectSets.newObjectSet caption:_selSetsNames[i] nodes:_selSetsObjects[i]  
						)--if else

					)--for

					_success = true
				)--yes
				
				#no: --crea solo los que no existen ya, y los que si existen no los actualiza
				(
					for i=1 to _selSetsNames.count where (findItem _matchingNames _selSetsNames[i] == 0) do lb.objectSets.newObjectSet caption:_selSetsNames[i] nodes:_selSetsObjects[i]

					_success = true
				)--no
			)--case

			_success
		),

		------------------------------------------------
		--@fn: boolean | loadObjectSetsFromFile | Carga los objectSets del archivo que se le indique y devuelve TRUE si lo consigue. FALSE si no.
		--@gets: string | file | Path completo del archivo del cual se quieren cargar los objectSets.
		--@opt: array{string} | captions | #() | Nombres específicos de los objectSets de la archivo para cargar solo esos.
		--@opt: boolean | overWriteDuplicated | true | Indica si sobrescribir los duplicados.
		------------------------------------------------
		fn loadObjectSetsFromFile file captions:#() overWriteDuplicated:true =
		(
			_success = false
			
			if doesFileExist file then --si el archivo existe los intenta cargar
			(
				if captions.count == 0 then captions = this.getFileObjectSetCaptions file --Si no hay caption utilizamos la funcion getFileObjectSetCaptions para obtenerlos.

				_xmlDoc = lb.xml.load file --Funcion de la libreria de xml para leer archivos .xml 
				_rootNode = _xmlDoc.getRoot() --Lo utilizamos para saber la raiz de nuestro .xml
				_objSets = _rootNode.getNodes "objectSets/objectSet" --Utilizamos getNodes para sacar nodeTreePath del xml 

				for _os in _objSets where findItem captions (_os.getProperty "caption") !=0 do --Recorremos los nodos que hemos obtenido antes y buscamos en ellos la propiedad caption.
				(	
					_nodes = _os.getNodes "node" --Utilizamos getNodes para obtener el parametro node de dentro del xml
					for ns in _nodes do
					(
						_objName = ns.getProperty "name" --Recorremos "node" dentro del xml y obtenemos el string que hay guardado en name 
						_sceneObjs = for o in objects where o.name == _objName collect o --Recorremos los objects de la escena y guardamos los nombres que sean iguales a los de _objName 

						_caption = (_os.getProperty "caption")
						for obj in _sceneObjs do this.add obj #(_caption) replace:true --Añadimos caption a todos objetos de _sceneObjs 
					) 
				) 

				--for 
			)
			
			_success
		),

		------------------------------------------------
		--@fn: array{string} | getFileObjectSetCaptions | Nombres de los objectSets de un archivo en concreto.
		--@gets: string | file | Path completo del archivo del cual se quieren consultar los objectSets.
		------------------------------------------------
		fn getFileObjectSetCaptions file =
		(
			_objectSetCaptions = #()
			
			--si ele archivo pasado existe, entonces intenta ver los nodeSets que tiene dentro
			if doesFileExist file then
			(	
				_xmlDoc = lb.xml.load file --Funcion de la libreria de xml para leer archivos .xml 
				_rootNode = _xmlDoc.getRoot() --Lo utilizamos para saber la raiz de nuestro .xml
				_objSets = _rootNode.getNodes "objectSets/objectSet" --Utilizamos getNodes para sacar nodeTreePath del xml 
				_objectSetCaptions = for _os in _objSets collect _os.getProperty "caption" --Recorremos los nodos de antes y guardamos la propiedad caption
			)
				
			_objectSetCaptions
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
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_objectSets() --crea la libreria
)