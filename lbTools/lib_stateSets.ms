------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de stateSets
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: stateSet | Contiene los parametros y funciones de un stateSet.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_stateSet
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #lighting,				--@var: category | Categoria de la libreria.
		stateName = "stateSet",				--@var: stateName | Nombre de la libreria.
		description = "Libreria de stateSet individual",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		parent = undefined,		--@var:  parent | stateSet padre del actual.
		content = undefined,	--@var: content | Almacena el stateSet real de la escena, este struct sirve como fachada para su utilización.
		
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
		--@fn: stateSet | getParent | Devuelve stateSet padre del actual
		------------------------------------------------
		fn getParent =
		(
			this.parent
		),
		
		------------------------------------------------
		--@fn: string | getName | Devuelve el nombre del estado
		------------------------------------------------
		fn getName =
		(
			this.content.name
		),
		
		------------------------------------------------
		--@fn: array{stateSet} | getChildren | Devuelve un array con los estados hijos del estado pasado por parámetro.
		--@opts: boolean | includeProperties | false | Indica si solo debe buscar los estados hijos o busca también propiedades hijas cambiadas en el estado actual.
		------------------------------------------------
		fn getChildren includeProperties:false =
		(
			_childrenStates = #()
			
			--recopila los estados hijos.
			_limit = this.content.children.count - 1
			if (this.content as string) == "dotNetObject:Autodesk.Max.StateSets.Entities.StateSets.Master" then _limit -= 1
			
			for i=0 to _limit do
			(
				if ((this.content.children.item[i] as string) == ("dotNetObject:Autodesk.Max.StateSets.Entities.StateSets.StateSet")) or includeProperties then
					append _childrenStates this.content.children.item[i]
			)--for
				
			--los mete dentro de contenedores del tipo de este struct.
			for i=1 to _childrenStates.count do _childrenStates[i] = lb.stateSets.newStateSetContainer content:_childrenStates[i] parent:this def:this.def defFile:this.defFile
				
			_childrenStates --devuelve los hijos
		),
		
		------------------------------------------------
		--@fn: stateSet | getSubState | Devuelve el primer subestado que coincida con el partron pasado por parámetro.
		--@gets: string | pattern | Patron de subestados que encontrar en los hijos del estado pasado por parámetro. Ej. 'state01/state03/state07'.
		--@opts: boolean | includeProperties | false | Indica si solo debe buscar un subestado, o busca también propiedades cambiadas en el estado actual.
		------------------------------------------------
		fn getSubState pattern includeProperties:false =
		(
 			_subState = undefined
			
			--descompone los niveles y obtiene el nodo inicial
			_levelParts = filterString pattern "/"
			_currElement = this --elemento actual para ir recorriendo su arbol de descendientes hasta encontrar el que coincida con el patron
			
			_level = 1 --nivel actual
			_stop = false --flag de parada
			
			for i=1 to _levelParts.count where not _stop do --recorre las partes del patron buscado
			(
				_found = false --flag para parar en cuanto se encuentre el descendiente buscado
				_currElementChildren = _currElement.getChildren includeProperties:includeProperties --obtien los hijos del elemento actual
				
				--recorre los hijos buscando el que cumpla la siguiente parte del patrón
				for j=1 to _currElementChildren.count where not _stop and not _found do
				(
					if (_currElementChildren[j].getName()) == _levelParts[i] then --si el nombre del elemento coincide con la parte actual del patrón.
					(
						_currElement = _currElementChildren[j] --sobrescribe el elemento actual
						_found = true --indica que ha encontrado coincidencia con la parte actual del patrón y que hay que saltar al siguiente nivel
					)--if
				)--for
				
				if not _found then _stop = true	 --si no encuentra coincidencia, es que por esta rama del arbol no va bien y para.
				if i == _levelParts.count and _found then --si ha llegado al final del patrón de búsqueda y ha encontrado el elemento, para y lo prepara para devolverlo
				(
					_stop = true
					_subState = _currElement
				)--if
			)--for
			
			--mete el estado en un contenedor de tipo de este struct
			--if _subState != undefined then _subState = lb.stateSets.newStateSetContainer content:_subState parent:this def:this.def defFile:this.defFile
			
 			_subState --devuelve el nodo			
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setParent | Asigna un nuevo padre al estado actual
		--@gets: stateSet | newParent | nuevo estado padre.
		------------------------------------------------
		fn setParent newParent =
		(
			this.parent = newParent
		),
		
		------------------------------------------------
		--@fn: undefined | setName | Cambia el nombre del estado
		--@gets: stateSet | newName | nuevo nombre del estado.
		------------------------------------------------
		fn setName newName =
		(
			this.content.name = newName
		),
		
		------------------------------------------------
		--@fn: undefined | renderState | Renderiza el estado actual.
		------------------------------------------------
		fn renderState = 
		(
			if this.content.parents.count != 0 then
			(
				this.setActive()
				_quietModeBckp = GetQuietMode()
				SetQuietMode true
				max quick render
				SetQuietMode _quietModeBckp
				--this.content.render #(this.content.parents[1])
			)
		),
		
		------------------------------------------------
		--@fn: boolean | setActive | Pone este estado como activo. Devuelve TRUE si lo consigue dejar activo y FALSE si no.
		------------------------------------------------
		fn setActive =
		(
			_success = false
			
			_ancestor = this --almacena el estado actual.
			_ancestorArray = #()
			while _ancestor.getParent() != undefined do
			(
				_ancestorArray = #(_ancestor.content) + _ancestorArray --añade el ancestro actual al inicio del array
				_ancestor = _ancestor.getParent() --recorre los ancestros hasta el último.
			)
			
			--si se ha llegado al estado maestro, le dice a quien poner como activo. Le pasa el array de ancestros en orden.
			if (_ancestor.content as string) == "dotNetObject:Autodesk.Max.StateSets.Entities.StateSets.Master" then 
			(
				--si el primer elemento del array de ancestros es el estado maestro, lo elimina del array
				if (_ancestorArray[1] as string) == "dotNetObject:Autodesk.Max.StateSets.Entities.StateSets.Master" then deleteItem _ancestorArray 1
				
				_ancestor.content.currentState = undefined
				if _ancestorArray.count != 0 then _ancestor.content.currentState = _ancestorArray
				
				_success = true
			)
				
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | setOutput | Almacena el output de render del estado actual.
		--AQUI TE HAS QUEDADO
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | beginRecording | Entra en modo de grabación.
		------------------------------------------------
		fn beginRecording =
		(
			this.setActive()
			this.content.beginRecording()
		),
		
		------------------------------------------------
		--@fn: undefined | endRecording | Sale del modo de grabación.
		------------------------------------------------
		fn endRecording =
		(
			this.content.endRecording()
		),
		
		------------------------------------------------
		--@fn: stateSet | newChild | Crea un nuevo estado hijo y lo devuelve.
		--@opt: string | name | undefined | Nombre para el nuevo hijo.
		------------------------------------------------
		fn newChild name:undefined =
		(
			_theState = this.content.addState() --crea el nuevo estado
			if name != undefined then _theState.name = name --le pone el nombre al nuevo estado
			
			_newStateSet = lb.stateSets.newStateSetContainer content:_theState parent:this def:this.def defFile:this.defFile --lo mete en un contenedor
			_newStateSet --lo devuelve
		),
		
		------------------------------------------------
		--@fn: undefined | remove | Elimina el estado.
		------------------------------------------------
		fn remove =
		(
			if this.parent != undefined then --si tiene padre, lo podremos eliminar desde el padre.
			(
				this.parent.content.removeChild this.content
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | removeChildByIndex | Elimina el estado hijo que ocupa el lugar indicado.
		--@gets: integer | index | Indice del hijo a eliminar.
		------------------------------------------------
		fn removeChildByIndex index =
		(
			_children = this.getChildren() --obtiene todos los estados hijos
			if index <= _children.count then _children[index].remove() --si el indice solicitado para eliminar es válido, elimina el hijo que ocupe ese lugar
		),
		
		------------------------------------------------
		--@fn: undefined | removeChildByName | Elimina el estado hijo que ocupa posea el nombre indicado.
		--@gets: string | childName | Nombre del hijo a eliminar.
		------------------------------------------------
		fn removeChildByName childName =
		(
			_theChild = this.getSubState childName
			if _theChild != undefined then _theChild.remove() --si ha encontrado el hijo con ese nombre lo elimina
		),
		
		------------------------------------------------
		--@fn: undefined | clear | Elimina todos los estados hijos y las propiedades que hayan cambiado en el.
		------------------------------------------------
		fn clear =
		(
			_allChildren = this.getChildren includeProperties:true --obtiene todos los hijos y propiedades hijas
			for ch in _allChildren do ch.remove() --los elimina
		),
		
		------------------------------------------------
		--@fn: undefined | toString | Devuelve un string con la representación del estado de escena
		--@returns: string | Representación del estado de escena.
		fn toString =
		(
			this.getName()
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
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: stateSets | Contiene todas las funciones de manejo de stateSets.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_stateSets
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),					--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),		--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #lighting,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de stateSets",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		stateSet = lib_stateSet,				--@var: stateSet | Almacena la definicion de un stateSet
		
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
		--@fn: Autodesk.Max.StateSets.Plugin | getManager | Devuelve el manejador de stateSets de la escena.
		------------------------------------------------
		fn getManager =
		(
			_stateSetsDotNetObject = dotNetObject "Autodesk.Max.StateSets.Plugin" --carga el plugin de stateSets
			_theManager = _stateSetsDotNetObject.Instance --crea una instancia del plugin
			
			_theManager --devuelve el manager de estados
		),
		
		------------------------------------------------
		--@fn: stateSet | getMasterState | Devuelve el estado principal del manager pasasdo por parámetro.
		--@gets: instance{Autodesk.Max.StateSets.Plugin} | theManager | Instancia del plugin de manejo de estados de escena.
		------------------------------------------------
		fn getMasterState theManager =
		(
			_theMasterState = theManager.entityManager.rootEntity.MasterStateSet --obtiene el estado pincipal.
			_mstrState = this.newStateSetContainer content:_theMasterState def:this.stateSet defFile:this.defFile --crea un nodo propio de estado de escena con el estado maestro dentro.
			_mstrState --devuelve el contenedor
		),		
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: stateSet | newStateSetContainer | Devuelve un contenedor con un nuevo estado de escena y su funcionalidad. Si no se le pasa el estado de escena.
		--@opt: Autodesk.Max.StateSets.Entities.StateSets.StateSet | content | undefined | Estado de escena real que va a contener.
		--@opt: stateSet | parent | undefined | Estado de escena padre del que se está generando.
		--@opt: strcutDef | def | undefined | Definición del struct de stateSet para que pueda generar más estados a partir del nuevo.
		--@opt: path | defFile | undefined | Path del archivo .ms que contiene la deficición del struct.
		------------------------------------------------
		fn newStateSetContainer content:undefined parent:undefined def:undefined defFile:undefined =
		(
			_newStateSet = this.stateSet content:content parent:parent def:this.def defFile:this.defFile --crea el estado
			_newStateSet --lo devuelve
		),
		
		------------------------------------------------
		--@fn: undefined | showMainFrame | Abre la ventana de estados de escena.
		------------------------------------------------
		fn showMainFrame = (this.getManager()).showMainFrame(),
		
		------------------------------------------------
		--@fn: undefined | hideMainFrame | Cierra la ventana de estados de escena.
		------------------------------------------------
		fn hideMainFrame = (this.getManager()).hideMainFrame(),
		
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
	--EJECUCION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_stateSets() --crea la libreria	
)