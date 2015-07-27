------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de overrides
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideInfo | Custom attribute para almacenar en los nodos que guarden la información de cada override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideInfo = attributes overrideInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override."
				
			--informacion específica del override
			caption	type:#string	default:""	--@var | caption | Nombre para mostrar del override personalizado.
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:""	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--informacion sobre el contenido almacenado en el override
			enabled type:#boolean default:true --@var | enabled | Indica si el override esta activo o apagado.
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: override | Contiene todas las funciones de un override generico.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_override
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		caption = undefined,	--@var | caption | Nombre del override personalizado. TEMPORAL durante la construcción.
		type = "override",		--@var | type | Indica que es un override.
		subType = undefined,	--@var | subType | Indica que tipo de override concreto almacena.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		parentContainer = undefined,		--@var | parentContainer | Almacena el struct con el contenedor del que cuelga el override.
		customOverride = undefined,			--@var | customOverride | Almacena el struct con el override específico del subTypo al que pertenece.
		
		overrideInfo = ca_overrideInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en los nodos.
		
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
		--@fn: string | getCaption | Devuelve el nombre del override.
		------------------------------------------------
		fn getCaption =
		(
			this.infoNode.custAttributes[#overrideInfo].caption
		),
		
		------------------------------------------------
		--@fn: string | getType | Devuelve el tipo del override.
		------------------------------------------------
		fn getType =
		(
			this.infoNode.custAttributes[#overrideInfo].type
		),
		
		------------------------------------------------
		--@fn: string | getSubType | Devuelve el subtipo del override.
		------------------------------------------------
		fn getSubType =
		(
			this.infoNode.custAttributes[#overrideInfo].subType
		),
		
		------------------------------------------------
		--@fn: boolean | getEnabledState | Devuelve el estado de habilitado/deshabilitado del override.
		------------------------------------------------
		fn getEnabledState =
		(
			this.infoNode.custAttributes[#overrideInfo].enabled
		),
		
		------------------------------------------------
		--@fn: node | getInfoNode | Devuelve el nodo físico de la escena que contiene la información del override.
		------------------------------------------------
		fn getInfoNode =
		(
			this.infoNode
		),
		
		------------------------------------------------
		--@fn: string | getInfo | Devuelve la informacion que se debe mostrar en el UI.
		------------------------------------------------
		fn getInfo =
		(
			if this.customOverride != undefined then (this.customOverride.getInfo()) else "undefined"
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			--if this.customOverride != undefined then _state = (this.customOverride.getState()) else #error
			if this.customOverride != undefined then _state = (if isProperty this.customOverride #getState then (this.customOverride.getState()) else #error) else #error
		),
		
		------------------------------------------------
		--@fn: name | getStateMessage | Devuelve el mensaje del estado actual del override.
		------------------------------------------------
		fn getStateMessage =
		(
			if this.customOverride != undefined then this.customOverride.getStateMessage() else "corrupted override"
		),
		
		------------------------------------------------
		--@fn: dotneObject | getUiObj | Devuelve el objeto de interface .net que controla este objeto.
		------------------------------------------------
		fn getUiObj =
		(
			this.uiObj
		),
		
		------------------------------------------------
		--@fn: container | getParentContainer | Devuelve el contenedor del que cuelga este override.
		------------------------------------------------
		fn getParentContainer =
		(
			this.parentContainer
		),
		
		------------------------------------------------
		--@fn: override | getRelativeAncestorOverride | Obtiene el primer override del tipo solicitado en los ancestros.
		--@gets: string | type | Tipo del override que se solicita.
		------------------------------------------------		
		fn getRelativeAncestorOverride type =
		(
			_relativeOverride = undefined
			
			--si el override cuelga de un contenedor empeizas  buscar el primer 
			_parentContainer = this.getParentContainer()
			if _parentContainer != undefined then
			(
				_overrides = _parentContainer.getOverrides()
				
				if _overrides.count != 0 then
				(
					_index = findItem _overrides this --busca el override actual en la lista de overrides
					
					--busca el override relacionado en los antecesores del mismo padre
					for i = (_index - 1) to 1 by -1 where _relativeOverride == undefined do
						if _overrides[i].getSubType() == type then _relativeOverride = _overrides[i]
					
					--si no lo ha encontrado en el mismo nivel lo busca en los anteriores
					while (_relativeOverride == undefined) and (_parentContainer.getParent() != undefined) do
					(
						_parentContainer = _parentContainer.getParent() --obtiene el contenedor padre
						
						--obtiene el contenedor de overrides del padre
						_overridesNode = undefined
						for _ch in _parentContainer.getChildren() where _ch.getSubType() == #overrides do _overridesNode = _ch
						
						--si encuentra el contenedor de overrides busca en ellos el del tipo solicitado
						if _overridesNode != undefined then
						(
							_overrides = _overridesNode.getOverrides() --obtiene los overrides
							for i = _overrides.count to 1 by -1 where _relativeOverride == undefined and _overrides[i].getSubType() == type do
								_relativeOverride = _overrides[i]
						)--if						
					)--if
				)--if 				
			)--if
			
			_relativeOverride
		),
		
		------------------------------------------------
		--@fn: array{override} | getRelativeDescendantsOverride | Obtiene los overrides descendientes del tipo solicitado.
		--@gets: string | type | Tipo de overrides que se solicitan.
		------------------------------------------------		
		fn getRelativeDescendantsOverride type =
		(
			_relativeOverrides = #()
			
			--si el override cuelga de un contenedor empeizas  buscar el primer 
			_parentContainer = this.getParentContainer()
			if _parentContainer != undefined then
			(
				_overrides = _parentContainer.getOverrides()
				
				if _overrides.count != 0 then
				(
					_index = findItem _overrides this --busca el override actual en la lista de overrides
					
					--busca el override relacionado en los descendientes del mismo padre
					for i = (_index + 1) to _overrides.count where _overrides[i].getSubType() == type do
						append _relativeOverrides (_overrides[i])
					
					--se coloca en el conenedor de pase padre y recopila los hijos que no sean de overrides
					_parentContainer = _parentContainer.getParent()
					_children = for _ch in _parentContainer.getChildren() where _ch.getSubType != "overrides" collect _ch			
					
					for _ch in _children do
					(
						_overridesContainer = undefined
						for _nch in _ch.getChildren() do
						(
							if _nch.getSubType() == #overrides then _overridesContainer = _nch
							else append _children _nch
						)--for
						
						if _overridesContainer != undefined then
							for _ov in (_overridesContainer.getOverrides()) where _ov.getSubType() == type do append _relativeOverrides _ov
					)--for
				)--if 				
			)--if
			
			_relativeOverrides
		),
		
		------------------------------------------------
		--@fn: array{overrides y Containers} | getSignificantAncestors | Obtiene la lista de los ancestros hasta el passtree quitando el contenedor de overrides.
		--@gets: Override | override | Override del cual queremos sacar sus padres.
		------------------------------------------------
		fn getSignificantAncestors =
		(
			_ancestors = #(this.getParentContainer())--.getParentContainer())--El primer ancestro siempre es el abuelo (nos saltamos el contenedor de overrides)
			
			while _ancestors[_ancestors.count].getParent() != undefined do
				_ancestors[_ancestors.count + 1] = _ancestors[_ancestors.count].getParent()
			
			_ancestors
		),
		
		------------------------------------------------
		--@fn: string | getOverrideTrace| Obtiene la traza de los ancestros hasta el passtree quitando el contenedor de overrides.
		--@gets: Override | override | Override del cual queremos sacar su traza.
		------------------------------------------------
		fn getTrace separator:" -> "=
		(
			_ancestors = getSignificantAncestors()
			_trace = ""
			for i=_ancestors.count to 1 by -1 do
			(
				_trace += _ancestors[i].getCaption() + separator
			)
			_trace += this.getCaption()
			_trace
		),

		------------------------------------------------
		--@fn: array{overrides y Containers} | getOverrideSignificantAncestors | Obtiene la lista de los ancestros hasta el passtree quitando el contenedor de overrides.
		--@gets: Override | override | Override del cual queremos sacar sus padres.
		------------------------------------------------
		fn getOverrideSignificantAncestors override =
		(
			_ancestors = #(override.getParentContainer())--.getParentContainer())--El primer ancestro siempre es el abuelo (nos saltamos el contenedor de overrides)
			
			while _ancestors[_ancestors.count].getParent() != undefined do
				_ancestors[_ancestors.count + 1] = _ancestors[_ancestors.count].getParent()
			
			_ancestors
		),
		
		------------------------------------------------
		--@fn: string | getOverrideTrace| Obtiene la traza de los ancestros hasta el passtree quitando el contenedor de overrides.
		--@gets: Override | override | Override del cual queremos sacar su traza.
		------------------------------------------------
		fn getOverrideTrace override =
		(
			_ancestors = getOverrideSignificantAncestors override
			_trace = ""
			for i=_ancestors.count to 1 by -1 do
			(
				_trace += _ancestors[i].getCaption() + " -> "
			)
			_trace += (override.getOverrideManager()).getCaption()
			_trace
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setParent | Sustituye el padre del nodo que representa el override en la escena.
		--@gets: node | newParent | Nuevo objeto padre para el override.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn setParent newParent placeInSceneNodes:false =
		(
			this.infoNode.parent = newParent --le cambia el padre
			
			if placeInSceneNodes then lb.overrides.placeInScene() --recoloca todos los overrides en la escena
		),
		
		------------------------------------------------
		--@fn: undefined | setCaption | Sustituye el nombre al override.
		--@gets: string | newCaption | Nuevo nombre para el override.
		--@opt: array{override} | overridesToWork | #() | Overrides con los que trabajar, si no se suministran la funcion usa todos los de la escena.
		------------------------------------------------
		fn setCaption newCaption overridesToWork:#() =
		(
			_index = 0 --indice del nombre por si ya existe
			_defCaption = newCaption --nombre definitivo
			
			-----------------------------
			--si no tiene padre, hay que renombrarlo teniendo en cuenta todos los overrides de la escena
			if (this.getParentContainer()) == undefined then
			(
				_existingOverrides = if overridesToWork.count != 0 then overridesToWork else lb.overrides.getAll()

				-----------------------------
				--busca el indice			
				for _ov in _existingOverrides do --busca el indice que ponerle al nombre
				(
					if (_ov.getCaption()) == newCaption and _index == 0 then _index = 1
					else if (matchPattern (_ov.getCaption()) pattern:(newCaption + "#???")) then
					(
						_nParts = filterString (_ov.getCaption()) "#"
						_enumeration = _nParts[2] as integer
						if _enumeration >= _index then _index = _enumeration + 1
					)
				)--for
				-----------------------------
			)
			else
			(
				_brothers = (this.getParentContainer()).getOverrides()

				for br in _brothers where br != this do
				(
					if (br.getCaption() == newCaption) then _index = 1
					else if (matchPattern (br.getCaption()) pattern:(newCaption + "#???")) then
					(
						_nParts = filterString (br.getCaption()) "#"
						_enumeration = _nParts[2] as integer
						if _enumeration >= _index then _index = _enumeration + 1
					)--if else if
				)--for
			)--if else
			-----------------------------

			--si hay indice es porque esta repetido y hay que diferenciarlo
			if _index > 0 then _defCaption = newCaption + "#" + (formattedprint _index format:"03d")
			
			--aplica el nuevo nombre
			this.infoNode.custAttributes[#overrideInfo].caption = _defCaption
			this.infoNode.name = this.infoNodePrefix + _defCaption
		),
		
		------------------------------------------------
		--@fn: undefined | setSubType | Sustituye el subtipo de override.
		--@gets: string | setSubType | Nuevo subtipo para el override.
		------------------------------------------------
		fn setSubType newType =
		(
			this.infoNode.custAttributes[#overrideInfo].subType = (newType as string)
		),
		
		------------------------------------------------
		--@fn: undefined | setEnabledState | Sustituye el estado (habilitado/deshabilitado) del override.
		--@gets: boolean | newState | Nuevo estado (habilitado/deshabilitado) para el override.
		------------------------------------------------
		fn setEnabledState newState =
		(
			this.infoNode.custAttributes[#overrideInfo].enabled = newState
		),
		
		------------------------------------------------
		--@fn: undefined | setUiObj | Sustituye el objeto de interface relacionado con el override.
		--@gets: dotNetObject | newUiObj | Nuevo elemento de interface relacionado con el override.
		------------------------------------------------
		fn setUiObj newUiObj =
		(
			this.uiObj = newUiObj
			if this.customOverride != undefined then this.customOverride.setUiObj newUiObj
		),
		
		------------------------------------------------
		--@fn: undefined | setParentContainer | Sustituye el contenedor padre del que cuelga el override.
		--@gets: container | newParentContainer | Nuevo contenedor padre.
		------------------------------------------------
		fn setParentContainer newParentContainer =
		(
			this.parentContainer = newParentContainer
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | redirect | Realiza redireccion de sources en el override si tiene esa propiedad.
		--@gets: string | sourcePattern | Parte del path que sustituir.
		--@gets: string | mappedPattern | Parte del path por la cual sustituir.
		------------------------------------------------
		fn redirect sourcePattern mappedPattern =
		(
			if isProperty this.customOverride #redirect then
				this.customOverride.redirect sourcePattern mappedPattern
		),

		------------------------------------------------
		--@fn: undefined | updateUIinfo | Actualiza la informacion del override en su objeto de UI si tuviera.		
		------------------------------------------------
		fn updateUIinfo =
		(
			this.customOverride.updateUIinfo()
		),
		
		------------------------------------------------
		--@fn: boolean | createBackup | Crea el backup de este override antes de aplicarse. Devuelve TRUE si consigue hacer el backup y FALSE si no.
		--@gets: node | backupNode | Objeto en el que hacer el backup.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("BACKUP process start - override: " + (this.getCaption())) sender:"lb.overrides.override.createBackup" type:#info level:logLevel
			
			_success = this.customOverride.createBackup backupNode saveLogs:saveLogs logLevel:(logLevel + 1)
			
			if saveLogs then
			(
				if _success then lb.log.add ("BACKUP process completed - override: " + (this.getCaption())) sender:"lb.overrides.override.createBackup" type:#ok level:logLevel
				else lb.log.add ("BACKUP process error - override: " + (this.getCaption())) sender:"lb.overrides.override.createBackup" type:#error level:logLevel
			)--if
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup. Devuelve TRUE si consigue restaurar el backup y FALSE si no.
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("RESTORE process start- override: " + (this.getCaption())) sender:"lb.overrides.override.restoreBackup" type:#info level:logLevel
				
			_success = this.customOverride.restoreBackup backupNode saveLogs:saveLogs logLevel:(logLevel + 1)
			
			if saveLogs then
			(
				if _success then lb.log.add ("RESTORE process completed - override: " + (this.getCaption())) sender:"lb.overrides.override.restoreBackup" type:#ok level:logLevel
				else lb.log.add ("RESTORE process error - override: " + (this.getCaption())) sender:"lb.overrides.override.restoreBackup" type:#error level:logLevel
			)--if
				
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes. Devuelve TRUE si consigue aplicarlo y FALSE si no.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("APPLY process start- override: " + (this.getCaption())) sender:"lb.overrides.override.apply" type:#info level:logLevel
			
			--_start = timeStamp()

			_success = this.customOverride.apply saveLogs:saveLogs logLevel:(logLevel + 1) 
			
			--_end = timeStamp()
			--print (this.getSubType())
			--print ((_end - _start)/1000.0)
			--_start = timeStamp()

			if saveLogs then
			(
				if _success then lb.log.add ("APPLY process completed - override: " + (this.getCaption())) sender:"lb.overrides.override.restoreBackup" type:#ok level:logLevel
				else lb.log.add ("APPLY process error - override: " + (this.getCaption())) sender:"lb.overrides.override.restoreBackup" type:#error level:logLevel
			)--if
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Muestra el dialogo de edicion del override especifico.
		------------------------------------------------
		fn edit pos:[0,0] =
		(
			--si cuelga de un contenedor
			if (this.getParentContainer()) != undefined then
			(
				--obtiene el inicio de la jerarquia del arbol de contenedores
				_passTree = (this.getParentContainer()).getRootContainer()
				
				if _passTree != undefined then --si ha conseguido llegar a la raiz
				(
					--obtiene el nodo de backup de edicion de override
					_overridesEditBackupNode = _passTree.getOverridesEditBackupNode()
					if _overridesEditBackupNode == undefined then _overridesEditBackupNode = _passTree.createOverridesEditBackupNode()
					
					--solo edita si hay un nodo donde hacer backup
					if _overridesEditBackupNode != undefined then this.customOverride.edit pos:pos					
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: boolean | remove | Elimina el override. Devuelve TRUE si lo consigue eliminar y FALSE si no.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn remove placeInSceneNodes:false =
		(
			_success = delete (this.infoNode)
			if placeInSceneNodes then lb.overrides.placeInScene()
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | purge | Limpia el override por si se ha cambiado informacion y hay que mantenerla coherente.
		------------------------------------------------
		fn purge =
		(
			_success = false
			
			--TO DO: Aqui hacer el codigo de purga
			
			_success = true
			
			_success
		),
		
		
		------------------------------------------------
		--@fn: undefined | reset | resetea los valores a los que tiene por defecto.
		------------------------------------------------
		fn reset =
		(
			--TO DO: Aqui restaurar los valores a los que tiene por defecto
		),
		
		------------------------------------------------
		--@fn: undefined | createInfoNode | Crea el nodo de la escena que lleva la información del override y lo rellena.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn createInfoNode placeInSceneNodes:false =
		(
			this.infoNode = point size:3.5 box:on cross:off axistripod:off centermarker:off --crea el nuevo nodo para el override
			this.infoNode.wirecolor = color 255 70 105
			this.infoNode.name = this.infoNodePrefix + this.caption
			(lb.overrides.getLayer()).addNode this.infoNode --lo añade a la capa correspondiente
			
			custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
			this.infoNode.custAttributes[#overrideInfo].caption = this.caption; this.caption = undefined
			this.infoNode.custAttributes[#overrideInfo].type = this.type as string; this.type = "default"
			this.infoNode.custAttributes[#overrideInfo].subType = this.subType as string; this.subType = "default"
			
			if placeInSceneNodes then lb.overrides.placeInScene() --recoloca todos los overrides en posiciones adyacentes
		),
		
		------------------------------------------------
		--@fn: undefined | construct | Rellena la información del override y crea el objeto fisico en la escena que contendrá la información.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la información la coge de el.
			if isValidNode this.infoNode then
			(			
				--primero mira si hay cambios en la escena que afecten al override y lo limpia
				this.purge()
				
				--TO DO: Aqui falta hacer que lea propiedades del CA del objeto y las meta en el custom override de memoria.
			)
			else --si se está creando un nuevo override
			(
				-----------------------------------------
				--asigna el nombre al override. Si no se ha pasado nombre se le asigna uno por defecto. Si el que se ha pasado ya existe, se le añade un indice detras.
					
				--si no se ha asignado nombre se le asigna uno por defecto
				if this.caption == undefined then this.caption = "override"
				
				--si se ha asignado un nombre se comprueba que no haya ya un override con el mismo. Si lo hay le añade un indice.
				if this.caption != undefined then
				(
					_existingOverrides = lb.overrides.getAll()
					
					-----------------------------
					--busca el indice
					_defCaption = this.caption
					_index = 0
					for _ov in _existingOverrides do --busca el indice que ponerle al nombre
					(
						if (_ov.getCaption()) == this.caption and _index == 0 then _index = 1
						else if (matchPattern (_ov.getCaption()) pattern:(this.caption + "#???")) then
						(
							_nParts = filterString (_ov.getCaption()) "#"
							_enumeration = _nParts[2] as integer
							if _enumeration >= _index then _index = _enumeration + 1
						)
					)--for
					-----------------------------
					
					--si hay indice es porque esta repetido y hay que diferenciarlo
					if _index > 0 then this.caption = this.caption + "#" + (formattedprint _index format:"03d")
				)--if
				-----------------------------------------
				
				--crea el nodo de la escena que va a llevar la información del nodeSet.
				this.createInfoNode()
			)
			
			--Una vez creado el infoNode hay que crear el override específico del tipo especial al que pertenezca y almacenarlo en el override generico actual
			_overrideDef = lb.overrides.getOverrideDef (this.getSubType())
			this.customOverride = _overrideDef infoNode:(this.infoNode) overrideManager:this
		),
		
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la representacion del contenido del nodeSet.
		------------------------------------------------
		fn toString =
		(	
			--primero mira si hay cambios en la escena que afecten al nodeSet y lo limpia
			this.purge()
			
			_theString = ""
				
			--TO DO: Aqui falta todo el codigo del toString
			
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
		
	)--lib_override
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: overrides | Contiene todas las funciones de overrides personalizados.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_overrides
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria sets de overrides personalizados",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		override = lib_override,			--@var | override | Struct de overrides genericos indivivudales.
		
		overridesTypes = #(),				--@var | overridesTypes | Array para almacenar los nombres de los direrentes tipos de overrides que se pueden crear
		overrides = #(),					--@var | overrides | Array para almacenar los direrentes tipos de overrides que se pueden crear
		
		overrideInfo = ca_overrideInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en los nodos.
		
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		
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
		--@fn: string | getFileOverrideName | Devuelve el nombre del override almacenado en el archivo pasado por parametro.
		--@gets: string | fileName | Path completo del archivo que contiene el override.
		------------------------------------------------
		fn getFileOverrideName fileName =
		(	
			(substituteString (getFileNameFile fileName) "pmov_" "")
		),
		
		------------------------------------------------
		--@fn: LayerProperties | getLayer | Devuelve la capa que contiene los nodos auxiliares con la información de overrides.
		------------------------------------------------
		fn getLayer =
		(
			_theLayer = lb.layer.getLayerByName "aux-overrides" --[[CAMBIAR ESTO POR LA VARIABLE DEL NAMING CONVENTION CORRESPONDIENTE CUANDO ESTE HECHO]]
			if _theLayer == undefined then
			(
				_theLayer = lb.layer.newLayer name:"aux-overrides"
				_theLayer.ishidden = true
				_theLayer.isfrozen = true
			)
			
			_theLayer
		),

		------------------------------------------------
		--@fn: array{node} | getAllInfoNodes | Devuelve los objetos de la escena que contienen informacion de overrides de render
		------------------------------------------------
		fn getAllInfoNodes =
		(
			_infoNodes = lb.layer.getLayerNodes (this.getLayer())
			for i=_infoNodes.count to 1 by -1 where (_infoNodes[i].custAttributes[#overrideInfo] == undefined) do deleteItem _infoNodes i
				
			_infoNodes
		),
		
		------------------------------------------------
		--@fn: array{override} | getAll | Devuelve los overrides de la escena
		------------------------------------------------
		fn getAll =
		(
			_overrideNodes = this.getAllInfoNodes()
				
			_overrides = for _ov in _overrideNodes collect this.newOverride infoNode:_ov --crea un override en memoria por cada uno de la escena
			_overrides = this.sortOverridesByCaption _overrides --los ordena por nombre
			
			_overrides
		),		
		
		------------------------------------------------
		--@fn: array{override} | getByCaption | Devuelve los overrides que tengan el nombre solicitado y cualquiera de sus enumeraciones
		--@gets: string | caption | Nombre del override que se solicita.
		--@opt: boolean | enumerated | false | Indica si devolver todos los overrides derivados del que se solicita mediante su numeracion.
		------------------------------------------------
		fn getByCaption caption enumerated:false =
		(
			_overrides = #()
			
			_allOverrides = this.getAll() --obtiene todos los overrides
			if not enumerated then for _ov in _allOverrides where (_ov.getCaption()) == caption do _theNodeSets = #(_ov) --se queda con el que coincida en nombre
			else for _ov in _allOverrides where (_ov.getCaption()) == caption or matchPattern (_ov.getCaption()) pattern:(caption + "#????") do
				append _overrides _ov --se queda con el que coincida en nombre o cumpla el patron
			_overrides = this.sortOverridesByCaption _overrides --los ordena por nombre
			
			_overrides
		),
		
		------------------------------------------------
		--@fn: array{nodeSet} | getByType | Devuelve los overrides que tengan el tipo solicitado.
		--@gets: string | type | Tipo del override que se solicita.
		------------------------------------------------
		fn getByType type =
		(
			_overrides = #()
			
			_allOverrides = this.getAll() --obtiene todos los overrides
			_overrides = for _ov in _allOverrides where (_ov.getSubType()) == (type as string) collect _ov --se queda con el que coincida en tipo
			_overrides = this.sortOverridesByCaption _overrides --los ordena por nombre
			
			_overrides
		),

		------------------------------------------------
		--@fn: container | getByCaption | Devuelve el container que tenga el infoNode solicitado.
		--@gets: node | infoNodeToFind | infoNode por el cual buscar el contenedor.
		------------------------------------------------
		fn getByInfoNode infoNodeToFind =
		(
			_override = undefined
			
			_allOverrides = this.getAll() --obtiene todos los overrides
			for _ov in _allOverrides where _override == undefined and _ov.getInfoNode() == infoNodeToFind do _override = _ov
			
			_override
		),
		
		------------------------------------------------
		--@fn: overrideDef | getOverrideDef | Devuelve la definicion del override del tipo solicitado si existe, undefined si no.
		--@gets: string | overrideType | Tipo del override que se solicita.
		------------------------------------------------
		fn getOverrideDef overrideType =
		(
			_overrideDef = undefined
			
			_index = findItem this.overridesTypes overrideType
			if _index != 0 then _overrideDef = this.overrides[_index]
				
			_overrideDef
		),
		
		------------------------------------------------
		
		------------------------------------------------
		--@fn: array{string} | getFileOverrideCaptions | Nombres de los overrides de un archivo en concreto.
		--@gets: string | file | Path completo del archivo del cual se quieren consultar los overrides.
		------------------------------------------------
		fn getFileOverrideCaptions file =
		(
			_overrideCaptions = #()
			
			--si ele archivo pasado existe, entonces intenta ver los overrides que tiene dentro
			if doesFileExist file then
			(
				_fileNames = getMAXFileObjectNames file quiet:true
				_overrideCaptions = for _name in _fileNames where matchPattern _name pattern:(this.infoNodePrefix + "*") collect _name
			)
				
			_overrideCaptions
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: boolean | updateOldInfoNodesCA | Devuelve TRUE si ha tenido que actualizar algún CA y FALSE si no hacia falta. Si algun objeto tiene un CA con version anterior lo actualiza con el CA nuevo.
		------------------------------------------------
		fn updateOldInfoNodesCA =
		(
			_updated = false
			
			--obtiene todos los nodos con informacion de overrides
			_infoNodes = this.getAllInfoNodes()
			_nodesToDelete = #()

			--recorre los nodos mirando si tiene que actualizar su CA
			for i=_infoNodes.count to 1 by -1 do
			(
				_infoNode = _infonodes[i]

				_subType = _infoNode.custAttributes[#overrideInfo].subType
				_subTypeString = ("override" + _subType + "Info")

				--obtiene el numero de version mas reciente del CA
				_currentVersion = 0
				_tempOverride = this.newOverride caption:"test" subType:_subType
				_newInfoNode = _tempOverride.getInfoNode()
				_lastVersion = _newInfoNode.custAttributes[_subTypeString].CA_version
				_currentVersion = _infoNode.custAttributes[_subTypeString].CA_version
				
				if _currentVersion < _lastVersion then --si la version ha cambiado
				(
					--establece el viejo nombre y el padre
					_newInfoNode.name = _infoNode.name
					_newInfoNode.parent = _infoNode.parent
					_newInfoNode.custAttributes[#overrideInfo].caption = _infoNode.custAttributes[#overrideInfo].caption

					--copia los valores de las propiedades comunes
					_propNames = getPropNames _infoNode.custAttributes[_subTypeString]
					_propValues = for _prop in _propNames collect (getProperty _infoNode.custAttributes[_subTypeString] _prop)
					for j=1 to _propNames.count where (_propNames[j] != #CA_version) and (_propNames[j] != #_description) and (isProperty (_newInfoNode.custAttributes[_subTypeString]) _propNames[j]) do
						setProperty (_newInfoNode.custAttributes[_subTypeString]) _propNames[j] _propValues[j]

					_override = this.getByInfoNode _newInfoNode
					if hasProperty _override "customOverride" do
						if hasProperty _override.customOverride "upgrade" do
							_override.customOverride.upgrade previousVersion:_currentVersion

					append _nodesToDelete _infoNode
					_updated = true
				)
				else
				(
					this.removeOverride _tempOverride
				)				
			)--for

			delete _nodesToDelete --elimina los nodos originales que tenian el CA viejo.
			
			_updated
		),		

		------------------------------------------------
		--@fn: boolean | isOverride | Devuelve TRUE si el objeto pasado es un nodo de override y FALSE si no.
		--@gets: node | node | Nodo que comprobar si es un override.
		------------------------------------------------
		fn isOverride node =
		(
			(node.custAttributes[#overrideInfo] != undefined)
		),
		
		------------------------------------------------
		--@fn: boolean | doesOverrideExist | Indica si un tipo de override existe.
		--@gets: string | overrideType | Tipo de override que se quiere conocer si existe.
		------------------------------------------------
		fn doesOverrideExist overrideType =
		(
			((findItem this.overridesTypes overrideType) != 0)
		),
		
		------------------------------------------------
		--@fn: undefined | add | Añade un override al array de overrides.
		--@gets: string | newOverrideType | Nuevo tipo de override a añadir.
		--@gets: override | newOverride | Nuevo override a añadir.
		------------------------------------------------
		fn add newOverrideType newOverride =
		(
			if this.doesOverrideExist newOverrideType then this.remove newOverrideType --si el override ya existe lo borra primero para que no se duplique
			append this.overrides newOverride --añade el override
			append this.overridesTypes newOverrideType --añade el tipo de override			
		),
		
		------------------------------------------------
		--@fn: undefined | remove | Elimina un override del array de overrides.
		--@gets: string | overrideType | Nuevo tipo de override a eliminar.
		------------------------------------------------
		fn remove overrideType =
		(
			_index = findItem this.overridesTypes overrideType
			if _index != 0 then (deleteItem this.overridesTypes _index; deleteItem this.overrides _index)
		),
			
		------------------------------------------------
		--@fn: integer | compareOverridesByCaption | Compara dos overrides por nombre. Devuelve 0 si tienen el mismo nombre, -1 si el nombre del primero va antes que el del segundo, 1 si el nombre del segundo va antes. 
		--@gets: node | override1 | Primer override a comparar.
		--@gets: node | override2 | Segundo override a comparar.
		--@opt: boolean | invert | false | Indica si devolver el resultado invertido, para ordenaciones inversas.
		--@opt: boolean | ignoreCase | false | Indica si tener en cuenta mayusculas y minusculas.
		------------------------------------------------
		fn compareOverridesByCaption override1 override2 invert:false ignoreCase:false =
		(			
			--obtiene los nombres de los dos nodos
			caption1 = override1.infoNode.custAttributes[#overrideInfo].caption
			caption2 = override2.infoNode.custAttributes[#overrideInfo].caption
			
			--si no tiene en cuenta mayusculas y minusculas lo pasa todo a minusculas
			if ignoreCase then
			(
				caption1 = tolower override1.infoNode.custAttributes[#overrideInfo].caption
				caption2 = tolower override2.infoNode.custAttributes[#overrideInfo].caption
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
		--@fn: array{override} | sortOverridesByCaption | Ordena los override de un array de forma alfabetica y lo devuelve.
		--@gets: array{override} | overrides | Array de overrides a ordenar.
		--@opt: boolean | invert | false | Indica si devolver el resultado invertido, para ordenaciones inversas.
		--@opt: boolean | ignoreCase | false | Indica si tener en cuenta mayusculas y minusculas.
		--@returns: array{override} | Array de overrides ordenados.
		------------------------------------------------
		fn sortOverridesByCaption overrides invert:false ignoreCase:false =
		(
			qsort overrides this.compareOverridesByCaption invert:invert ignoreCase:ignoreCase
			
			overrides
		),
		
		------------------------------------------------
		--@fn: override | newOverride | Crea un nuevo override personalizado y lo devuelve.
		--@opt: string | caption | undefined | Nombre que se le dará el nuevo override creado. Si ya existe no lo crea y lo devuelve.
		--@opt: string | subType | undefined | Tipo específico de override.
		--@opt: node | infoNode | undefined | Nodo de la escena con la información de un override y a partir del cual generar un override en memoria.
		--@opt: dotNetObject | uiObj | undefined | Objeto de interface que representa el override en una herramienta.
		------------------------------------------------
		fn newOverride caption:undefined subType:undefined infoNode:undefined uiObj:undefined parentContainer:undefined =
		(
			_newOverride = undefined
			
			--crea el nuevo override
			_newOverride = this.override caption:caption subType:subType infoNode:infoNode uiObj:uiObj parentContainer:parentContainer
				
			_newOverride
		),		
		
		------------------------------------------------
		--@fn: undefined | placeInScene | Recoloca los nodos de los overrides en la escena.
		------------------------------------------------
		fn placeInScene =
		(
			--obtiene los overrides ordenados por nombre
			_allOverrides = lb.misc.sortNodesByName (for _ov in (this.getAll()) collect _ov.infoNode)
			
			_overrideParents = #(undefined) --para almacenar los padres de los overrides
			_overridesByParent = #(#()) --para almacenar los overrides correspondientes a cada padre
			
			--recolecta los overrides agrupados por padre
			for _ov in _allOverrides do
			(
				_index = findItem _overrideParents _ov.parent --averigua a que padre corresponde
				
				if _index != 0 then append _overridesByParent[_index] _ov
				else (append _overrideParents _ov.parent; append _overridesByParent #(_ov))
			)--for
			
			--recorre los grupos ordenandolos en la escena
			for i=1 to _overrideParents.count do
			(
				_initPos = if i == 1 then [0,0,-20] else _overrideParents[i].pos
				_increment = [5,0,0]
				
				--excepcion para los overrides que cuelgan directamente de un arbol de pases
				--estos overrides son overrides de backup y por tanto los colocamos en x negativo
				if _overrideParents[i] != undefined and _overrideParents[i].custAttributes[#containerInfo] != undefined then
					if _overrideParents[i].custAttributes[#containerInfo].subType == "passTree" then _increment = [-5,0,0]
				
				for j=1 to _overridesByParent[i].count do _overridesByParent[i][j].pos = _initPos + (_increment*j)
			)--for
		),
		
		------------------------------------------------
		--@fn: undefined | removeAll | Elimina todos los overrides de la escena.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn removeAll placeInSceneNodes:false =
		(
			--obtiene los overrides y los elimina.
			_allOverrides = (for _ov in (this.getAll()) collect _ov.infoNode)
			delete _allOverrides
				
			if placeInSceneNodes then this.placeInScene() --recoloca los nodos en la escena.
		),
		
		------------------------------------------------
		--@fn: boolean | removeOverride | Elimina el override pasado por parametro. Devuelve TRUE si lo consigue eliminar y FALSE si no.
		--@gets: override | overrideToDelete | override que se quiere eliminar.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn removeOverride overrideToDelete placeInSceneNodes:false =
		(
			_success = delete (overrideToDelete.getInfoNode())
				
			if placeInSceneNodes then this.placeInScene() --recoloca los nodos en la escena.
				
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | removeByCaption | Elimina todos los overrides segun el nombre indicado.
		--@gets: string | caption | Nombre del override que se quiere eliminar.
		--@opt: boolean | enumerated | false | Indica si eliminar todos los overrides derivados del que se solicita mediante su numeracion.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn removeByCaption caption enumerated:false placeInSceneNodes:false =
		(
			--obtiene los overrides adecuados y los elimina.
			_theOverrides = (for _ov in (this.getByCaption caption enumerated:enumerated) collect _ov.infoNode)
			delete _theOverrides
			
			if placeInSceneNodes then this.placeInScene() --recoloca los nodos en la escena.
		),
		
		------------------------------------------------
		--@fn: undefined | removeByType | Elimina todos los overrides segun el tipo indicado.
		--@gets: string | type | Tipo de los overrides que se quieren eliminar.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn removeByType type placeInSceneNodes:false =
		(
			--obtiene los overrides adecuados y los elimina.
			_theOverrides = (for _ov in (this.getByType type) collect _ov.infoNode)
			delete _theOverrides
			
			if placeInSceneNodes then this.placeInScene() --recoloca los overrides en la escena.
		),
		
		------------------------------------------------
		--@fn: override | duplicateOverride | Duplica el override indicado y lo devuelve.
		--@gets: override | overrideToDuplicate | Override que se quiere duplicar.
		--@opt: boolean | keepCaption | false | Indica si mantener el mismo nombre en el duplicado.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn duplicateOverride overrideToDuplicate keepCaption:false placeInSceneNodes:false =
		(
			_newOverride = undefined
			
			--suplica el nodo con todos sus atributps
			_copies = #()
			maxOps.CloneNodes #(overrideToDuplicate.getInfoNode()) cloneType:#copy newNodes:&_copies
			_newOverrideNode = _copies[1]
				
			_newOverrideNode.parent = undefined --desemparenta el nodo
			_newOverrideNode.name = (overrideToDuplicate.getInfoNode()).name --luego le pone al nodo el mismo nombre que tenía el original
			
			--crea el nuevo override en memoria a partir del nodo duplicado
			_overrideCaption = (filterString (overrideToDuplicate.getCaption()) "#")[1]
			_newOverride = this.newOverride infoNode:_newOverrideNode
			
			--si se le dice explicitamente que no le ponga un nombre nuevo con un indice, mantiene el original
			if keepCaption then (_newOverride.getInfoNode()).custAttributes[#overrideInfo].caption = overrideToDuplicate.getCaption()
			else _newOverride.setCaption _overrideCaption	

			if placeInSceneNodes then this.placeInScene() --recoloca los overrides en la escena.

			_newOverride
		),
		
		------------------------------------------------
		--@fn: boolean | loadOverridesFromFile | Carga los overrides del archivo que se le indique y devuelve TRUE si lo consigue. FALSE si no.
		--@gets: string | file | Path completo del archivo del cual se quieren cargar los overrides.
		--@opt: array{string} | captions | #() | Nombres específicos de los overrides de la archivo para cargar solo esos.
		--@opt: boolean | overWriteDuplicated | true | Indica si sobrescribir los duplicados.
		--@opt: boolean | placeInSceneNodes | false | Indica si recolocar los nodos en la escena tras el emparentamiento.
		------------------------------------------------
		fn loadOverridesFromFile file captions:#() overWriteDuplicated:true placeInSceneNodes:false =
		(
			_success = false
			
			--si el archivo existe los intenta cargar
			if doesFileExist file then
			(
				_nodesToMerge = (if captions.count != 0 then captions else (this.getFileOverrideCaptions file))
				_success = mergeMAXFile file _nodesToMerge (if overWriteDuplicated then #deleteOldDups else #skipDups) quiet:true
				if _success then for _ov in this.getAll() do _ov.purge()
			)
			
			if placeInSceneNodes then this.placeInScene() --recoloca los nodos en la escena.
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | createBackup | Hace el backup de los parametros de la escena antes de que se apliquen los overrides y se haga un render. Devuelve TRUE si consigue hacer el backup y FALSE si no.
		--@gets: container | passTree | Arbol de pases con el que trabajar.
		--@gets: container array | overridesToBackup | Overrides de los que hacer backup.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn createBackup passTree overridesToBackup saveLogs:false logLevel:1 =
		(
			_success = true
			
			if saveLogs then lb.log.add ("BACKUP process start - passTree: " + (passTree.getCaption())) sender:"lb.overrides.createBackup" type:#info level:logLevel

			--obtiene el nodo de backup de settings y si no existe lo crea
			_settingsBackupNode = passTree.getSettingsBackupNode()
			if _settingsBackupNode == undefined then _settingsBackupNode = passTree.createSettingsBackupNode()
			
			--una vez obtenido o creado, realiza el backup en el
			if _settingsBackupNode != undefined then
			(
				--print "---------------------------------------------------------------------------------"
				--print "BACKUP"
				--_start = timeStamp()

				--_end = timeStamp()
				--print ((_end - _start)/1000.0)
				--_start = timeStamp()

				--hace el backup de cada override
				for _ov in overridesToBackup where _success do
				(
					_success = _ov.createBackup _settingsBackupNode saveLogs:saveLogs logLevel:(logLevel + 1)
					
					--_end = timeStamp()
					--print (_ov.getSubType())
					--print ((_end - _start)/1000.0)
					--_start = timeStamp()
				)--for
			)
			else
			(
				_success = false
				if saveLogs then lb.log.add ("Settings backup node not found - passTree: " + (passTree.getCaption())) sender:"lb.overrides.createBackup" type:#error level:logLevel
			)--if else
			
			if saveLogs then 
			(
				if _success then lb.log.add ("BACKUP process completed - passTree: " + (passTree.getCaption())) sender:"lb.overrides.createBackup" type:#info level:logLevel
				else lb.log.add ("BACKUP process error - passTree: " + (passTree.getCaption())) sender:"lb.overrides.createBackup" type:#error level:logLevel
			)				
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura el backup de los parametros de la escena despues de un render para dejar todo como estaba antes de aplicar los overrides. Devuelve TRUE si consigue restaurar el backup y FALSE si no.
		--@gets: container | passTree | Arbol de pases con el que trabajar.
		--@gets: container array | overridesToRestore | Overrides de los que restaurar el backup.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn restoreBackup passTree overridesToRestore saveLogs:false logLevel:1 =
		(
			_success = true
			
			if saveLogs then lb.log.add ("RESTORE process start - passTree: " + (passTree.getCaption())) sender:"lb.overrides.restoreBackup" type:#info level:logLevel
			
			--obtiene el nodo de backup de settings
			_settingsBackupNode = passTree.getSettingsBackupNode()
				
			--una vez obtenido o creado, realiza el restore backup en el
			if _settingsBackupNode != undefined then
			(
				--print "---------------------------------------------------------------------------------"
				--print "RESTORE"
				--_start = timeStamp()
				
		
				--_end = timeStamp()
				--print ((_end - _start)/1000.0)
				--_start = timeStamp()

				--restaura el backup de cada override de forma inversa
				for i=overridesToRestore.count to 1 by -1 where _success do
				(
					_success = overridesToRestore[i].restoreBackup _settingsBackupNode saveLogs:saveLogs logLevel:(logLevel + 1)
											
					--_end = timeStamp()
					--print (overridesToRestore[i].getSubType())
					--print ((_end - _start)/1000.0)
					--_start = timeStamp()
				)
			)
			else
			(
				_success = false
				if saveLogs then lb.log.add ("Settings backup node not found - passTree: " + (passTree.getCaption())) sender:"lb.overrides.restoreBackup" type:#error level:logLevel
			)--if else
			
			if saveLogs then 
			(
				if _success then lb.log.add ("RESTORE process completed - passTree: " + (passTree.getCaption())) sender:"lb.overrides.restoreBackup" type:#info level:logLevel
				else lb.log.add ("RESTORE process error - passTree: " + (passTree.getCaption())) sender:"lb.overrides.restoreBackup" type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | getOverridesByType | Función recursiva que retorna los overrides de los tipos especificados en el array overrideTypes.
		--@gets: rootContainer | rootContainer | Contenedor del árbol del que partimos para buscar los overrides 
		--@opt: array | overrideTypes | #() | Array con nombres o Strings que identifican los tipos de overrides que queremos buscar, si no sabemos como sacar el tipo
		-- se pueden ver dentro del archivo en el parámetro subtype del custom attribute (está arriba del todo) o generalmente es el nombre del archivo sin el prefijo "pmov_".
		-- Si eres un poco gañán y pones un tipo en vez de un array con un tipo, no te preocupes que se encapsula en un array de manera automática.
		--@returns: array | array(overrides...) | Retorna un array de structs (overrides) de los tipos especificados, o array vacío si no encuentra ninguno.
		------------------------------------------------
		fn getOverridesByType rootContainer overrideTypes = 
		(
			--Por si algún gañán mete un solo valor lo encapsulamos en un array
			if classof overrideTypes != Array then
			(
				overrideTypes = #(overrideTypes)
			)
			
			result = #()
			
			case (rootContainer.getType() As Name) of
			(
				#override:
				(
					if ((finditem overrideTypes (rootContainer.getSubType() As Name)) != 0 or (finditem overrideTypes (rootContainer.getSubType() As String)) != 0) then
					(
						append result rootContainer
					)
				)
				default:
				(
					--Si contiene overrides usaremos getOverrides (no tienen getChildren)
					if ((rootContainer.getSubType()) == #overrides) then
					(
						for i=1 to (rootContainer.getOverrides()).count do
						(
							result += getOverridesByType (rootContainer.getOverrides())[i] overrideTypes
						)
					)
					else
					(
						for i=1 to (rootContainer.getChildren()).count do
						(
							result += getOverridesByType (rootContainer.getChildren())[i] overrideTypes
						)
					)
				)
			)
			result
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

		
	)--lib_overrides
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	_overridesTypesBackup = if lb.overrides != undefined then lb.overrides.overridesTypes else #()
	_overridesBackup = if lb.overrides != undefined then lb.overrides.overrides else #()
	
	lib_overrides() --crea la libreria

	if lb.overrides != undefined and _overridesBackup.count != 0 then
	(
		lb.overrides.overridesTypes = _overridesTypesBackup
		lb.overrides.overrides = _overridesBackup
	)
		
	ok
)