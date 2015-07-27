------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de RenderingControls
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideRenderingControlsInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideRenderingControlsInfo = attributes overrideRenderingControlsInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de RenderingControls."
				
			--informacion específica del override
			type		type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType		type:#string	default:"renderingControls"	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			-- Parámetros de backup
			nodesList						type:#nodeTab	tabsizevariable:true --@var | nodes | objetos de la escena de los que se hace backup de los parametros.
			renderableList					type:#string	default:"#()" --@var | renderable | propiedad renderable por cada objeto.
			inheritVisibilityList			type:#string	default:"#()" --@var | inheritVisibility | propiedad inheritVisibility por cada objeto.
			visToCameraList					type:#string	default:"#()" --@var | visToCamera | propiedad visToCamera por cada objeto.
			visToReflectionRefractionList	type:#string	default:"#()" --@var | visToReflectionRefraction | propiedad visToReflectionRefraction por cada objeto.
			receiveShadowsList				type:#string	default:"#()" --@var | receiveShadows | propiedad receiveShadows por cada objeto.
			castShadowsList					type:#string	default:"#()" --@var | castShadows | propiedad castShadows por cada objeto.
			applyAtmosphericsList			type:#string	default:"#()" --@var | applyAtmospherics | propiedad applyAtmospherics por cada objeto.
			renderOccludedObjectsList		type:#string	default:"#()" --@var | renderOccludedObjects | propiedad renderOccludedObjects por cada objeto.
			------------------------------------------------
			
			------------------------------------------------
			-- Parámetros de apply			
			renderable					type:#boolean	default:true --@var | renderable | propiedad renderable por cada objeto.
			inheritVisibility			type:#boolean	default:true --@var | inheritVisibility | propiedad inheritVisibility por cada objeto.
			visToCamera					type:#boolean	default:true --@var | visToCamera | propiedad visToCamera por cada objeto.
			visToReflectionRefraction	type:#boolean	default:true --@var | visToReflectionRefraction | propiedad visToReflectionRefraction por cada objeto.
			receiveShadows				type:#boolean	default:true --@var | receiveShadows | propiedad receiveShadows por cada objeto.
			castShadows					type:#boolean	default:true --@var | castShadows | propiedad castShadows por cada objeto.
			applyAtmospherics			type:#boolean	default:true --@var | applyAtmospherics | propiedad applyAtmospherics por cada objeto.
			renderOccludedObjects		type:#boolean	default:false --@var | renderOccludedObjects | propiedad renderOccludedObjects por cada objeto.
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | UI para modificar los parametros del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "RenderingControls Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var : editCA | Variable que almacena el custom attribute de edit.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		checkbox chkRenderable "Renderable" pos:[5,5] checked:true --@control | chkRenderable | Para que los objetos sean renderizables o no.
		checkbox chkInheritVisibility "Inherit Visibility" pos:[5,25] checked:true --@control | chkInheritVisibility | Para que los objetos hereden la visiblididad o no.
		checkbox chkVisToCamera "Visible To Camera" pos:[5,45] checked:true --@control | chkVisToCamera | Para que los objetos sen visibles en camara o no.
		checkbox chkVisToReflectionRefraction "Visible To Reflection/Refraction" pos:[5,65] checked:true --@control | chkVisToReflectionRefraction | Para que los objetos muestren sus reflexiones y refracciones o no.
		checkbox chkReceiveShadows "Receive Shadows" pos:[5,85] checked:true --@control | chkReceiveShadows | Para que los objetos reciban sombras o no.
		checkbox chkCastShadows "Cast Shadows" pos:[5,105] checked:true --@control | chkCastShadows | Para que los objetos proyecten sombras o no.
		checkbox chkApplyAtmospherics "Apply Atmospherics" pos:[5,125] checked:true --@control | chkApplyAtmospherics | Para que los objetos aplique sus efectos atmosfericos o no.
		checkbox chkRenderOccludedObjects "Render Occluded Objects" pos:[5,145] checked:false --@control | chkRenderOccludedObjects | Para que los objetos ocluidos se rendericen o no.
				
		button btnOk "OK" pos:[5,175] width:95 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[100,175] width:95 --@control | btnCancel | Cancela los cambios y cierra.
		
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
			chkRenderable.checked = editCA.renderable
			chkInheritVisibility.checked = editCA.inheritVisibility
			chkVisToCamera.checked = editCA.visToCamera
			chkVisToReflectionRefraction.checked = editCA.visToReflectionRefraction
			chkReceiveShadows.checked = editCA.receiveShadows
			chkCastShadows.checked = editCA.castShadows
			chkApplyAtmospherics.checked = editCA.applyAtmospherics
			chkRenderOccludedObjects.checked = editCA.renderOccludedObjects
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			--TO DO
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
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkRenderable | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkRenderable changed state do
		(
			editCA.renderable = state
		)	
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkInheritVisibility | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkInheritVisibility changed state do
		(
			editCA.inheritVisibility = state
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkVisToCamera | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkVisToCamera changed state do
		(
			editCA.visToCamera = state
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkVisToReflectionRefraction | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkVisToReflectionRefraction changed state do
		(
			editCA.visToReflectionRefraction = state
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkReceiveShadows | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkReceiveShadows changed state do
		(
			editCA.receiveShadows = state
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkCastShadows | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkCastShadows changed state do
		(
			editCA.castShadows = state
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkApplyAtmospherics | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkApplyAtmospherics changed state do
		(
			editCA.applyAtmospherics = state
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkRenderOccludedObjects | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkRenderOccludedObjects changed state do
		(
			editCA.renderOccludedObjects = state
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
			
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Cambia los cambios.
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
			editCA = parent.editBackupNode.custAttributes[#overrideRenderingControlsInfo]
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
	--@struct: overrideRenderingControls | Contiene todas las funciones de un override de RenderingControls.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideRenderingControls
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
		infoNodeCA,						--@var | infoNodeCA | Variable que almacena el CA de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideRenderingControlsInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideRenderingControlsInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
		--@fn: string | getInfo | Devuelve la informacion que se debe mostrar en el UI.
		------------------------------------------------
		fn getInfo =
		(
			_info = ""
			
			_info += if this.infoNodeCA.renderable then "1," else "0,"
			_info += if this.infoNodeCA.inheritVisibility then "1," else "0,"
			_info += if this.infoNodeCA.visToCamera then "1," else "0,"
			_info += if this.infoNodeCA.visToReflectionRefraction then "1," else "0,"
			_info += if this.infoNodeCA.receiveShadows then "1," else "0,"
			_info += if this.infoNodeCA.castShadows then "1," else "0,"
			_info += if this.infoNodeCA.applyAtmospherics then "1," else "0,"
			_info += if this.infoNodeCA.renderOccludedObjects then "1" else "0"
				
			_info	
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
		--@fn: boolean | createBackup | Crea el backup de este override antes de aplicarse. Devuelve TRUE si lo consigue y FALSE si no.
		--@gets: node | backupNode | Objeto en el que hacer el backup.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("BACKUP process start.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideRenderingControlsInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				_backupCA = backupNode.custAttributes[#overrideRenderingControlsInfo]

				_backupCA.nodesList = #()
				_backupCA.renderableList = "#()"
				_backupCA.inheritVisibilityList = "#()"
				_backupCA.visToCameraList = "#()"
				_backupCA.visToReflectionRefractionList = "#()"
				_backupCA.receiveShadowsList = "#()"
				_backupCA.castShadowsList = "#()"
				_backupCA.applyAtmosphericsList = "#()"
				_backupCA.renderOccludedObjectsList = "#()"
				
				--_start = timeStamp()

				_nodes = (objects as array)
				_index = findItem _nodes backupNode
				if _index != 0 then deleteItem _nodes _index

				_renderableList = #()
				_inheritVisibilityList = #()
				_visToCameraList = #()
				_visToReflectionRefractionList = #()
				_receiveShadowsList = #()
				_castShadowsList = #()
				_applyAtmosphericsList = #()
				_renderOccludedObjectsList = #()

				--almacena los nodos y sus propiedades
				for o in _nodes do
				(
					append _renderableList o.renderable
					append _inheritVisibilityList o.inheritVisibility
					append _visToCameraList o.primaryVisibility
					append _visToReflectionRefractionList o.secondaryVisibility
					append _receiveShadowsList o.receiveShadows
					append _castShadowsList o.castShadows
					append _applyAtmosphericsList o.applyAtmospherics
					append _renderOccludedObjectsList o.renderOccluded

					--_end = timeStamp()
					--print ((_end - _start)/1000.0)
					--_start = timeStamp()
				)--for
				
				_backupCA.nodesList = _nodes

				with printAllElements on
				(
					_backupCA.renderableList = _renderableList as string
					_backupCA.inheritVisibilityList = _inheritVisibilityList as string
					_backupCA.visToCameraList = _visToCameraList as string
					_backupCA.visToReflectionRefractionList = _visToReflectionRefractionList as string
					_backupCA.receiveShadowsList = _receiveShadowsList as string
					_backupCA.castShadowsList = _castShadowsList as string
					_backupCA.applyAtmosphericsList = _applyAtmosphericsList as string
					_backupCA.renderOccludedObjectsList = _renderOccludedObjectsList as string
				)--printAllElements

				if saveLogs then lb.log.add ("BACKUP process complete.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				true
			)
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup Node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				false
			)
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup. Devuelve TRUE si lo consigue y FALSE si no.
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("RESTORE process start.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(
				_backupCA = backupNode.custAttributes[#overrideRenderingControlsInfo]

				if _backupCA != undefined then
				(
					_nodes = _backupCA.nodesList as array

					_renderableList = execute _backupCA.renderableList
					_inheritVisibilityList = execute _backupCA.inheritVisibilityList
					_visToCameraList = execute _backupCA.visToCameraList
					_visToReflectionRefractionList = execute _backupCA.visToReflectionRefractionList
					_receiveShadowsList = execute _backupCA.receiveShadowsList
					_castShadowsList = execute _backupCA.castShadowsList
					_applyAtmosphericsList = execute _backupCA.applyAtmosphericsList
					_renderOccludedObjectsList = execute _backupCA.renderOccludedObjectsList

					for i=1 to _nodes.count do
					(
						_nodes[i].renderable = _renderableList[i]
						_nodes[i].inheritVisibility = _inheritVisibilityList[i]
						_nodes[i].primaryVisibility = _visToCameraList[i]
						_nodes[i].secondaryVisibility = _visToReflectionRefractionList[i]
						_nodes[i].receiveShadows = _receiveShadowsList[i]
						_nodes[i].castShadows = _castShadowsList[i]
						_nodes[i].applyAtmospherics = _applyAtmosphericsList[i]
						_nodes[i].renderOccluded = _renderOccludedObjectsList[i]
					)--for

					if saveLogs then lb.log.add ("RESTORE process complete.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
					true
				)
				else
				(
					if saveLogs then lb.log.add ("RESTORE process error. CA #overrideRenderingControlsInfo is undefined") sender:("override." + (this.getSubType())) type:#error level:logLevel
					false
				)
			)
			else
			(
				if saveLogs then lb.log.add ("RESTORE process end. Backup node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				false
			)
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes. Devuelve TRUE si lo consigue y FALSE si no.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("APPLY process start.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			_parentContainer = this.getParentContainer() --primero hay que averiguar el contenedor de overrides del que cuelga
			
			if _parentContainer != undefined then
			(
				--lo que se necesita es el container inmedietamente superior
				_objectSetContainer = _parentContainer.getParent()
				
				--si existe el contenedor del que debe colgar, obtiene sus nodeSets y les aplica las propiedades
				if _objectSetContainer != undefined then
				(
					_nodeSets = _objectSetContainer.getNodeSets()
					_nodeSetsStates = _objectSetContainer.getNodeSetEnabledStates() 
					
					_nodeSetsObjects = #()
					for i=1 to _nodeSets.count where _nodeSetsStates[i] do _nodeSetsObjects += _nodeSets[i].getNodes()
					
					_nodeSetsObjects.renderable = this.infoNodeCA.renderable
					_nodeSetsObjects.inheritVisibility = this.infoNodeCA.inheritVisibility
					_nodeSetsObjects.primaryVisibility = this.infoNodeCA.visToCamera
					_nodeSetsObjects.secondaryVisibility = this.infoNodeCA.visToReflectionRefraction
					_nodeSetsObjects.receiveShadows = this.infoNodeCA.receiveShadows
					_nodeSetsObjects.castShadows = this.infoNodeCA.castShadows
					_nodeSetsObjects.applyAtmospherics = this.infoNodeCA.applyAtmospherics
					_nodeSetsObjects.renderOccluded = this.infoNodeCA.renderOccludedObjects
				)--if
				else
				(
					if saveLogs then lb.log.add ("APPLY: objectSet container not found.") sender:("override." + (this.getSubType())) type:#warning level:logLevel
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("APPLY: parent container not found.") sender:("override." + (this.getSubType())) type:#warning level:logLevel
			)
			if saveLogs then lb.log.add ("APPLY process complete.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
			true
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
				if this.editBackupNode.custAttributes[#overrideRenderingControlsInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideRenderingControlsInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideRenderingControlsInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideRenderingControlsInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideRenderingControlsInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [200, 200]
			_pos = pos - (_size/2)
			
			createDialog this.rollMain lockwidth:true lockheight:true pos:_pos width:_size.x height:_size.y modal:true style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		--@fn: undefined | construct | Rellena la información del override y crea el objeto fisico en la escena que contendrá la información.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la información la coge de el.
			if isValidNode this.infoNode then
			(	
				--Si se esta construyendo el objeto no tendra el CA aplicado, con lo cual hay que ponerselo. Si ya lo tiene no.
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideRenderingControlsInfo) then
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
				
				this.infoNodeCA = this.infoNode.custAttributes[#overrideRenderingControlsInfo]
				
				--primero mira si hay cambios en la escena que afecten al override y lo limpia
				this.purge()
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
		
	)--str_overrideRenderingControls
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideRenderingControls --añade el override al listado de overrides disponibles
	
	ok
)