------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de Nivel de detalle (LOD)
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: lod | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideLodInfo = attributes overrideLodInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.2
			CA_description	type:#string	default:"Almacena la informacion de un override de nivel de detalle."
				
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"lod" --(lb.overrides.getFileOverrideName (getThisScriptFilename() as string))	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--Parámetros de backup
			tsNodesBackup			type:#nodeTab		tabsizevariable:true --@var | tsNodesBackup | objetos de la escena de los que se hace backup.
			turbosmoothBackup		type:#intTab		tabsizevariable:true --@var | turbosmoothBackup | niveles de turbosmooth de los que se hace backup
			matNodesBackup			type:#nodeTab		tabsizevariable:true --@var | matNodesBackup | objetos de la escena de los que se hace backup de los materiales.
			materialsBackup			type:#materialTab	tabsizevariable:true --@var | materialsBackup | materiales de la escena de los que se hace backup por cada objeto.
			matSubAnimChainsBackup	type:#stringTab		tabsizevariable:true --@var | matSubAnimChainsBackup | String con la cadena de subanims a seguir para llegar donde se encuentra almacenado el material
			matPropertiesBackup		type:#stringTab		tabsizevariable:true --@var | matPropertiesBackup | Nombre de la propiedad en la que se encuentra almacenado el material.
			------------------------------------------------
			
			--Parámetros de apply y backup
			------------------------------------------------
			
			------------------------------------------------
			--Parámetros de apply
			turbosmooth	type:#integer	--@var | int | turbosmooth
			textureSize type:#string	--@var | string | textureSize
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "LOD Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var: editCA | Variable que almacena el custom attribute de edición
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		dropdownlist ddlTurboSmooth "TurboSMooth" items:(for i=0 to 6 collect i as string) selection:1 pos:[12,16]
		dropdownlist ddlTextureSize "Texture size" items:#("full", "half", "quarter") selection:1 pos:[12,64]
			
		button btnOk "OK" pos:[5,120] width:95 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[100,120] width:95 --@control | btnCancel | Cancela los cambios y cierra.
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			ddlTurboSmooth.selection = editCA.turbosmooth + 1
			ddlTextureSize.selection = findItem ddlTextureSize.items editCA.textureSize
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--no carga settings
		)
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--no guarda settings
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(			
			editCA.turbosmooth = ddlTurboSmooth.selection - 1
			editCA.textureSize = ddlTextureSize.selected
			
			parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
			
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Cancela los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnCancel pressed do
		(
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMainDef | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			--no se redimensiona
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			parent = lb.passManager.getCurrentEditInstance()
			
			editCA = parent.editBackupNode.custAttributes[#overrideLodInfo]
			
			loadOverrideInfo()
			loadSettings()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(	
			onCloseOperations()
			saveSettings()			
		)
		
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: override | Contiene todas las funciones de un override de nivel de detalle.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_lod
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		type = "override",		--@var | type | Indica que es un override.
		subType = lb.overrides.getFileOverrideName (getThisScriptFilename() as string),	--@var | subType | Indica que tipo de override concreto almacena.
		relatedTypes = #(), --@var | relatedTypes | Tipos de overrides relacionados.
		
		stateMessage = "", --@var | stateMessage | Mensaje del estado actual del override.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,							--@var | infoCA | Variable que almacena el custom attribute de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideLodInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideLodInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef, --@var: rollMain | Almacena el rollout de edicion del override.
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------
			
		------------------------------------------------
		--@fn: string | getType | Devuelve el tipo del override.
		------------------------------------------------
		fn getType =
		(
			this.infoNodeCA.type
		),
			
		------------------------------------------------
		--@fn: string | getSubType | Devuelve el subtipo del override.
		------------------------------------------------
		fn getSubType =
		(
			this.infoNodeCA.subType
		),
		
		------------------------------------------------
		--@fn: node | getInfoNode | Devuelve el nodo físico de la escena que contiene la información del override.
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
		--@fn: override | getOverrideManager | Devuelve el override principal del que cuelga el especifico.
		------------------------------------------------
		fn getOverrideManager =
		(
			this.overrideManager
		),
		
		------------------------------------------------
		--@fn: container | getParentContainer | Devuelve el contenedor del que cuelga este override.
		------------------------------------------------
		fn getParentContainer =
		(
			if this.overrideManager != undefined then this.overrideManager.getParentContainer() else undefined
		),
		
		------------------------------------------------
		--@fn: int | getTurboSmooth | Devuelve la intensidad del turbosmooth
		------------------------------------------------
		fn getTurboSmooth =
		(
			this.infoNodeCA.turbosmooth
		),

		------------------------------------------------
		--@fn: int | getTextureSize | Devuelve el tamaño de las texturas
		------------------------------------------------
		fn getTextureSize =
		(
			this.infoNodeCA.textureSize
		),

		------------------------------------------------
		--@fn: string | getInfo | Devuelve la informacion que se debe mostrar en el UI.
		------------------------------------------------
		fn getInfo =
		(
			"TurboSmooth:" + (this.getTurboSmooth() as string) + ", TextureSize:" + (this.getTextureSize())
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok
			
			_state
		),
		
		------------------------------------------------
		--@fn: name | getStateMessage | Devuelve el mensaje del estado actual del override.
		------------------------------------------------
		fn getStateMessage =
		(
			this.stateMessage
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setUiObj | Sustituye el objeto de interface relacionado con el override.
		--@gets: dotNetObject | newUiObj | Nuevo elemento de interface relacionado con el override.
		------------------------------------------------
		fn setUiObj newUiObj =
		(
			this.uiObj = newUiObj
		),
		
		------------------------------------------------
		--@fn: undefined | setOverrideManager | Sustituye el override principal del que cuelga el especifico.
		--@gets: override | newOverrideManager | Nuevo override principal.
		------------------------------------------------
		fn setOverrideManager newOverrideManager =
		(
			this.overrideManager = newOverrideManager
		),
		
		------------------------------------------------
		--@fn: undefined | setTurboSmooth | Sustituye la intensidad del turbosmooth del override
		--@gets: int | newTurboSmooth | Nueva intensidad para el turbosmooth
		------------------------------------------------
		fn setTurboSmooth newTurboSmooth =
		(
			this.infoNodeCA.turbosmooth = newTurboSmooth
		),

		------------------------------------------------
		--@fn: undefined | setTextureSize | Sustituye la calidad de las texturas
		--@gets: string | newTextureSize | Nueva calidad para las texturas
		------------------------------------------------
		fn setTextureSize newTextureSize =
		(
			this.infoNodeCA.textureSize = newTextureSize
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | updateUIinfo | Actualiza la informacion del override en su objeto de UI si tuviera.		
		------------------------------------------------
		fn updateUIinfo =
		(
			--si hay nodo que actualizar
			if this.getUiObj() != undefined then
			(
				--actualiza los valores de las columnas
				(this.getUiObj()).setValue 1 (this.getInfo())
				(this.getUiObj()).setValue 5 (this.getState() as string)
					
				--actualiza el icono de estado
				lb.passManagerUI.rollMain.updateTrvContainerAppearance mode:#state node:(this.getUiObj())
					
				--actualiza los overrides relacionados
				for _relType in this.relatedTypes do
				(
					_relOverrides = (this.getOverrideManager()).getRelativeDescendantsOverride _relType
					for _relOv in _relOverrides do _relOv.updateUIinfo()
				)--for
			)
		),
		
		------------------------------------------------
		--@fn: boolean | createBackup | Crea el backup de este override antes de aplicarse
		--@gets: node | backupNode | Objeto en el que hacer el backup.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("BACKUP process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideLodInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				backupNode.custAttributes[#overrideLodInfo].tsNodesBackup = #()
				backupNode.custAttributes[#overrideLodInfo].turbosmoothBackup = #()
				--backupNode.custAttributes[#overrideLodInfo].textureSizBackup = #()
				
				--almacena los nodos y sus valores
				for o in objects where (o != backupNode) do
				(
					--TurboSmooth
					tsMod = o.modifiers["TurboSmooth"]
					if tsMod != undefined do
					(
						append backupNode.custAttributes[#overrideLodInfo].tsNodesBackup o
						append backupNode.custAttributes[#overrideLodInfo].turbosmoothBackup tsMod.iterations
					)

					--Materials
					for _matInfo in (lb.materials.getMaterialsRecursiveExt o) do
					(
						_node = _matInfo.rootNode
						_subAnimChain = #()
						if (lb.misc.areArraysEqual _matInfo.subAnimChain #(5)) and _matInfo.property == #value then
						(
							_property = #material
						)
						else
						(
							for subAnimIndex in _matInfo.subAnimChain do
							(
								_node = _node[subAnimIndex]
								append _subAnimChain (subAnimIndex as string)
							)
							_property = _matInfo.property
						)
						append backupNode.custAttributes[#overrideLodInfo].matNodesBackup (_matInfo.rootNode)
						append backupNode.custAttributes[#overrideLodInfo].materialsBackup (_matInfo.material)
						append backupNode.custAttributes[#overrideLodInfo].matSubAnimChainsBackup (lb.str.join _subAnimChain ",")
						append backupNode.custAttributes[#overrideLodInfo].matPropertiesBackup (_property as string)
					)
				)--for
				
				_success = true
			)
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)					
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node is not valid.")
				_success = false
			)
			
			if saveLogs then
			(
				if _success then lb.log.add ("BACKUP process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("BACKUP process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("RESTORE process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(
				if backupNode.custAttributes[#overrideLodInfo] != undefined then
				(
					--TurboSmooth
					for i=1 to backupNode.custAttributes[#overrideLodInfo].tsNodesBackup.count do
					(
						tsMod = backupNode.custAttributes[#overrideLodInfo].tsNodesBackup[i].modifiers["TurboSmooth"]
						if tsMod != undefined do
							tsMod.iterations = backupNode.custAttributes[#overrideLodInfo].turbosmoothBackup[i]
					)
					
					--Materials
					for i=1 to backupNode.custAttributes[#overrideLodInfo].matNodesBackup.count do
					(
						_node = backupNode.custAttributes[#overrideLodInfo].matNodesBackup[i]
						_subAnimChains = backupNode.custAttributes[#overrideLodInfo].matSubAnimChainsBackup[i]
						_property = backupNode.custAttributes[#overrideLodInfo].matPropertiesBackup[i] as name
						_material = backupNode.custAttributes[#overrideLodInfo].materialsBackup[i]

						_subAnimChains = lb.str.split _subAnimChains ","
						_subAnimChains = for i=1 to _subAnimChains.count collect (_subAnimChains[i] as integer)

						for _sa in _subAnimChains do
							_node = _node[_sa]

						setProperty _node _property _material
					)
					
					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("Backup node with no custom attribute") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node with no custom attribute.")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not valid.")
				_success = false
			)
			
			if saveLogs then
			(
				if _success then lb.log.add ("RESTORE process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("RESTORE process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | apply | Aplica el override a los objetos o parametros correspondientes.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			global _collectChildrenNodes
			fn _collectChildrenNodes container =
			(
				_nodes = #()
				_nodeSets = container.getNodeSets()
				_nodeSetsStates = container.getNodeSetEnabledStates()
				_myNodes = container.getNodes()
				_myNodesStates = container.getNodesEnabledStates()
				for i=1 to _nodeSets.count where _nodeSetsStates[i] do _nodes += (_nodeSets[i].getNodes())
				for i=1 to _myNodes.count where _myNodesStates[i] do append _nodes _myNodes[i]


				for _ch in (container.getChildren()) do _nodes += (_collectChildrenNodes _ch)

				_nodes = makeUniqueArray _nodes

				return _nodes
			) 

			_success = false
			
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel

			lb.materials.setBitmapHighSettings #jpeg
			--lb.materials.setBitmapHighSettings #png
			--lb.materials.setBitmapHighSettings #tif
			--lb.materials.setBitmapHighSettings #bmp
			--lb.materials.setBitmapHighSettings #tga
			--lb.materials.setBitmapHighSettings #rla
			--lb.materials.setBitmapHighSettings #rpf
			--lb.materials.setBitmapHighSettings #exr
			
			_parentContainer = this.getParentContainer() --primero hay que averiguar el contenedor de overrides del que cuelga
			
			if _parentContainer != undefined then
			(
				--en el caso de un override de pelo, lo que se necesita es el container inmedietamente superior
				_objectSetContainer = _parentContainer.getParent()
				
				--si existe el contenedor del que debe colgar, obtiene sus nodeSets y les aplica al modificador necesario los valores
				if _objectSetContainer != undefined then
				(
					SuspendEditing()
					DisableSceneRedraw()

					_materialInfos = #()

					for _node in (_collectChildrenNodes _objectSetContainer) do
					(
						--TurboSmooth
						tsMod = _node.modifiers["TurboSmooth"]
						if tsMod != undefined do
							tsMod.iterations = this.getTurboSmooth()
						--Collect Materials
						_materialInfos += lb.materials.getMaterialsRecursiveExt _node
					)

					--Materials
					_origMats = #()
					_infoByMat = #()

					for _matInfo in _materialInfos do
					(
						_index = findItem _origMats _matInfo.material
						if _index == 0 then
						(
							append _origMats _matInfo.material
							_index = _origMats.count
							_infoByMat[_index] = #()
						)
						append _infoByMat[_index] _matInfo
						
					)--for

					for i=1 to _origMats.count do
					(
						_resizedMaterial = copy _origMats[i]
						lb.materials.resizeMaterialTextures _resizedMaterial size:((this.getTextureSize()) as name) method:#unfiltered
						for _matInfo in _infoByMat[i] do
						(
							_node = _matInfo.rootNode
							if (lb.misc.areArraysEqual _matInfo.subAnimChain #(5)) and _matInfo.property == #value then
							(
								_property = #material
							)
							else
							(
								for subAnimIndex in _matInfo.subAnimChain do
									_node = _node[subAnimIndex]
								_property = _matInfo.property
							)
							setProperty _node _property _resizedMaterial --sustituye el material
						)
					)

					EnableSceneRedraw()
					ResumeEditing()

					_success = true					
				)
				else
				(
					if saveLogs then lb.log.add ("APPLY process error. There is no parent container") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"APPLY process error. There is no parent container.")
					_success = false
				)--if else			
			)
			else
			(
				if saveLogs then lb.log.add ("APPLY process error. There is no parent container") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"APPLY process error. There is no parent container")	
				_success = false
			)--if else
			
			if saveLogs then
			(
				if _success then lb.log.add ("APPLY process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("APPLY process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_collectChildrenNodes = undefined --recolector de basura

			_success	
		),
		
		------------------------------------------------
		--@fn: undefined | applyEditChanges | Aplica los cambios que se han hecho en el override durante la edicion.
		------------------------------------------------
		fn applyEditChanges =
		(
			--solo si existe el nodo de backup de override puede hacerlo
			if this.editBackupNode != undefined then
			(
				--le quita el CA del override si lo tuviera
				if this.editBackupNode.custAttributes[#overrideLodInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideLodInfo]) _prop))
					)--undo
					
					this.editBackupNode = undefined --hace que el override no tenga backup de edicion almacenado
					
					this.updateUIinfo() --actualiza la infirmacion en el UI si ha cambiado
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello.		
		------------------------------------------------
		fn createEditBackup =
		(
			--solo si el override cuelga de un contenedor
			if (this.getParentContainer()) != undefined then
			(
				--obtiene el inicio de la jerarquia del arbol de contenedores
				_passTree = (this.getParentContainer()).getRootContainer()
				
				if _passTree != undefined then --si ha conseguido llegar a la raiz
				(
					--obtiene el nodo de backup de edicion de override
					this.editBackupNode = _passTree.getOverridesEditBackupNode()
					
					--solo si existe el nodo de backup de override puede hacerlo
					if this.editBackupNode != undefined then
					(
						--le quita el CA del override si lo tuviera
						if this.editBackupNode.custAttributes[#overrideLodInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideLodInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideLodInfo]) _prop (getProperty (this.infoNodeCA) _prop))
					)--if
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Muestra el dialogo de edicion del override.
		--@opt: Point2 | pos | [0,0] | Posicion en la que aparecera el rollout de edicion del override.
		------------------------------------------------
		fn edit pos:[0,0] =
		(
			this.createEditBackup() --crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello 			
			
			lb.passManager.setCurrentEditInstance this
			
			_size = [200, 150]
			_pos = pos - (_size/2)
			
			createDialog this.rollMain lockwidth:true lockheight:true pos:_pos width:_size.x height:_size.y modal:false style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing) parent:lb.passManagerUI.rollMain.hwnd
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
		--@fn: undefined | storeSceneValues | Almacena los valores de la escena en el override.
		------------------------------------------------
		fn storeSceneValues =
		(
			this.infoNodeCA.turbosmooth = 0
			this.infoNodeCA.textureSize = "full"
			--limpia las variables de backup
			this.infoNodeCA.tsNodesBackup = #()
			this.infoNodeCA.turbosmoothBackup = #()
			this.infoNodeCA.matNodesBackup = #()
			this.infoNodeCA.materialsBackup = #()
			this.infoNodeCA.matSubAnimChainsBackup = #()
			this.infoNodeCA.matPropertiesBackup = #()
			
			--ESTOS PARAMETROS NO SE DEBEN PISAR PORQUE SE ESTROPEA LA CONFIGURACION DEL OVERRIDE
			--No se sabría de que objeto/s coger el valor
		),
		
		------------------------------------------------
		--@fn: undefined | construct | Rellena la información del override y crea el objeto fisico en la escena que contendrá la información.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la información la coge de el.
			if isValidNode this.infoNode then
			(	
				--Si se esta construyendo el objeto no tendra el CA aplicado, con lo cual hay que ponerselo. Si ya lo tiene no.
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideLodInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideLodInfo]	
					this.storeSceneValues()
				)
				
				--Almacenamos el custom attribute de info en la variable infoNodeCA
				this.infoNodeCA = this.infoNode.custAttributes[#overrideLodInfo]
				
				this.purge() --primero mira si hay cambios en la escena que afecten al override y lo limpia
				
				--TO DO: Aqui falta hacer que lea propiedades del CA del objeto y las meta en el custom override de memoria.
			)--if				
		),
		
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la representacion del contenido del override.
		------------------------------------------------
		fn toString =
		(	
			--primero mira si hay cambios en la escena que afecten al override y lo limpia
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
		
	)--str_lod
	
	lb.overrides.add "lod" str_lod --añade el override al listado de overrides disponibles
	
	ok
)