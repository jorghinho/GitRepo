------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de material
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideMaterialInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideMaterialInfo = attributes overrideMaterialInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.1
			CA_description	type:#string	default:"Almacena la informacion de un override de material."
				
			--informacion espec�fica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"material" --(lb.overrides.getFileOverrideName (getThisScriptFilename() as string))	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--Par�metros de backup
			nodes			type:#nodeTab		tabsizevariable:true --@var | nodes | objetos de la escena de los que se hace backup de los materiales.
			materials		type:#materialTab	tabsizevariable:true --@var | materials | materiales de la escena de los que se hace backup por cada objeto.
			subAnimChains	type:#stringTab		tabsizevariable:true --@var | subAnimChains | String con la cadena de subanims a seguir para llegar donde se encuentra almacenado el material
			properties		type:#stringTab		tabsizevariable:true --@var | properties | Nombre de la propiedad en la que se encuentra almacenado el material.
			------------------------------------------------
			
			--Par�metros de apply y backup
			------------------------------------------------
			
			------------------------------------------------
			--Par�metros de apply
			mat		type:#material	--@var | type | Material de override del override.
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Material Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var: editCA | Variable que almacena el custom attribute de edici�n
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local materialEditorModeBckp = #basic --@var : materialEditorModeBckp | Modo del editor de materiales al abrirse para no perderlo.	
		local materialEditorSlotsBckp = undefined --@var : materialEditorSlotsBckp | Materiales que estaban almacenado en el slot 1 del editor de materiales para no perderlos.
		local materialEditorStateBckp = false --@var : materialEditorStateBckp | Estado de abierto/cerrado del editor de materiales.		
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
			
		checkbutton ckbMatEdit "<material>" pos:[5,5] width:190 --@control | btnMatEdit | Para elegir el material de override.

		button btnOk "OK" pos:[5,75] width:95 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[100,75] width:95 --@control | btnCancel | Cancela los cambios y cierra.
		
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
			--salva los estados de los materiales del editor de materiales y del mismo editor
			materialEditorModeBckp = MatEditor.mode
			materialEditorStateBckp = MatEditor.isOpen()
			materialEditorSlotsBckp = for i=1 to 24 collect meditMaterials[i]
			
			for i=1 to 24 do meditMaterials[i] = Standardmaterial()
			
			--Ponemos en el slot 1 nuestro material
			setMeditMaterial 1 (if editCA.mat != undefined then (copy editCA.mat) else (Standardmaterial()))
			
			--pone al boton el nombre del material actual del override
			ckbMatEdit.caption = if editCA.mat != undefined then editCA.mat.name else "<pick material>"
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			for i=1 to 24 do meditMaterials[i] = materialEditorSlotsBckp[i] --restaura los materiales que habia en el editor
			medit.SetActiveMtlSlot 1 true
			MatEditor.close()
			MatEditor.mode = materialEditorModeBckp --restaura el modo del editor de materiales
			if materialEditorStateBckp then MatEditor.open() --si eleditor estaba abierto lo abre
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuraci�n de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--no carga settings
		)
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuraci�n de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--no guarda settings
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: changed | Evento que se lanza al presionar el boton para elegir material
		--@control: checkbutton | ckbMatEdit | Boton para elegir material.
		--@gets: boolean | state | Estado presionado o no.
		------------------------------------------------
		on ckbMatEdit changed state do
		(
			if state then
			(
				if materialEditorStateBckp then MatEditor.close() --si eleditor estaba abierto inicialmente lo cierra
				MatEditor.mode = #basic
				MatEditor.Open() --abre el editor de materiales para modificar el material de override
				setMeditMaterial 1 (if editCA.mat != undefined then (copy editCA.mat) else (Standardmaterial())) --coloca el material de override en el editor		
				medit.SetActiveMtlSlot 1 true
			)
			else
			(
				editCA.mat = getMeditMaterial 1 --salva el nuevo material de override
				ckbMatEdit.caption = editCA.mat.name
				MatEditor.close()
				if materialEditorStateBckp then MatEditor.Open()
			)--if else
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(			
			editCA.mat = getMeditMaterial 1 --salva el nuevo material de override
			
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
		--@control: rollout | rollMainDef | El elemento que sufre la redimensi�n. El rollout principal de la herramienta.
		--@gets: point2 | size | tama�o al que se ha redimensionado el rollout
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
			
			editCA = parent.editBackupNode.custAttributes[#overrideMaterialInfo]
			
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
	--@struct: override | Contiene todas las funciones de un override de Material.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideMaterial
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
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la informaci�n del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,							--@var | infoCA | Variable que almacena el custom attribute de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma r�pida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override espec�fico.
		
		overrideInfo = ca_overrideMaterialInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideMaterialInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
		--@fn: node | getInfoNode | Devuelve el nodo f�sico de la escena que contiene la informaci�n del override.
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
		--@fn: material | getMaterial | Devuelve el material del override.
		------------------------------------------------
		fn getMaterial =
		(
			this.infoNodeCA.mat
		),
		
		------------------------------------------------
		--@fn: string | getInfo | Devuelve la informacion que se debe mostrar en el UI.
		------------------------------------------------
		fn getInfo =
		(
			if this.getMaterial() != undefined then (this.getMaterial()).name else "undefined"
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok
			
			if (this.getMaterial()) == undefined then
			(
				_state = #warning
				stateMessage = "You must assign a material for the override"
			)--if
			
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
		--@fn: undefined | setMaterial | Sustituye el material de override por el nuevo proporcionado.
		--@gets: material | newMaterial | Nuevo material de override.
		------------------------------------------------
		fn setMaterial newMaterial =
		(
			this.infoNodeCA.mat = newMaterial
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | redirect | Realiza redireccion de sources en el override.
		--@gets: string | sourcePattern | Parte del path que sustituir.
		--@gets: string | mappedPattern | Parte del path por la cual sustituir.
		------------------------------------------------
		fn redirect sourcePattern mappedPattern =
		(
			lb.materials.redirectMatBitmaps (this.infoNodeCA.mat) sourcePattern mappedPattern
		),

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
				if backupNode.custAttributes[#overrideMaterialInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le a�ade el atributo
				
				backupNode.custAttributes[#overrideMaterialInfo].nodes = #()
				backupNode.custAttributes[#overrideMaterialInfo].materials = #()
				backupNode.custAttributes[#overrideMaterialInfo].subAnimChains = #()
				backupNode.custAttributes[#overrideMaterialInfo].properties = #()
				
				--almacena los nodos y sus materiales
				for o in objects where (o != backupNode) do
				(
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
						append backupNode.custAttributes[#overrideMaterialInfo].nodes (_matInfo.rootNode)
						append backupNode.custAttributes[#overrideMaterialInfo].materials (getProperty _node _property)
						append backupNode.custAttributes[#overrideMaterialInfo].subAnimChains (lb.str.join _subAnimChain ",")
						append backupNode.custAttributes[#overrideMaterialInfo].properties (_property as string)
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
				if backupNode.custAttributes[#overrideMaterialInfo] != undefined then
				(
					for i=1 to backupNode.custAttributes[#overrideMaterialInfo].nodes.count do
					(
						_node = backupNode.custAttributes[#overrideMaterialInfo].nodes[i]
						_subAnimChains = backupNode.custAttributes[#overrideMaterialInfo].subAnimChains[i]
						_property = backupNode.custAttributes[#overrideMaterialInfo].properties[i] as name
						_material = backupNode.custAttributes[#overrideMaterialInfo].materials[i]

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
			_success = false
			
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			_parentContainer = this.getParentContainer() --primero hay que averiguar el contenedor de overrides del que cuelga
			
			if _parentContainer != undefined then
			(
				--en el caso de un override de material, lo que se necesita es el container inmedietamente superior
				_objectSetContainer = _parentContainer.getParent()
				
				--si existe el contenedor del que debe colgar, obtiene sus nodeSets y les aplica el material
				if _objectSetContainer != undefined then
				(
					if _objectSetContainer.getSubtype() == #ObjectSet then 
					(
						_nodeSets = _objectSetContainer.getNodeSets()
						_nodeSetsStates = _objectSetContainer.getNodeSetEnabledStates() 
						
						_materialInfos = #()
						for i=1 to _nodeSets.count where _nodeSetsStates[i] do
							for _n in (_nodeSets[i].getNodes()) do
								_materialInfos += lb.materials.getMaterialsRecursiveExt _n

						for _matInfo in _materialInfos do
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
							setProperty _node _property (this.getMaterial()) --sustituye el material
						)
					)
					else if _objectSetContainer.getSubtype() == #pass then 
					(
						_ch = _objectSetContainer.getChildren()
						for _child in _ch where _child.getSubtype() == #ObjectSet do 
						(
							_nodeSets = _child.getNodeSets()
							_nodeSetsStates = _child.getNodeSetEnabledStates() 

							_materialInfos = #()
							for i=1 to _nodeSets.count where _nodeSetsStates[i] do
								for _n in (_nodeSets[i].getNodes()) do
									_materialInfos += lb.materials.getMaterialsRecursiveExt _n
	
							for _matInfo in _materialInfos do
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
								setProperty _node _property (this.getMaterial()) --sustituye el material
							)
						)
					)
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
				if this.editBackupNode.custAttributes[#overrideMaterialInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideMaterialInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideMaterialInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideMaterialInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le a�ade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideMaterialInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [200, 100]
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
			--limpia las variables de backup
			this.infoNodeCA.nodes = #()
			this.infoNodeCA.materials = #()
			this.infoNodeCA.subAnimChains = #()
			this.infoNodeCA.properties = #()
			
			--ESTOS PARAMETROS NO SE DEBEN PISAR PORQUE SE ESTROPEA LA CONFIGURACION DEL OVERRIDE
			--No se sabr�a de que objeto/s coger el material
			--this.infoNodeCA.mat = undefined
		),
		
		------------------------------------------------
		--@fn: undefined | construct | Rellena la informaci�n del override y crea el objeto fisico en la escena que contendr� la informaci�n.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la informaci�n la coge de el.
			if isValidNode this.infoNode then
			(	
				--Si se esta construyendo el objeto no tendra el CA aplicado, con lo cual hay que ponerselo. Si ya lo tiene no.
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideMaterialInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le a�ade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideMaterialInfo]	
					this.storeSceneValues()
				)
				
				--Almacenamos el custom attribute de info en la variable infoNodeCA
				this.infoNodeCA = this.infoNode.custAttributes[#overrideMaterialInfo]
				
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
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrer�as en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librer�a.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librer�as hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event | create | Ejecuci�n al crearse la instancia del struct.
		on create do
		(
			this.construct() --genera toda la informaci�n necesaria y el nodo de la escena donde almacenarla en paralelo, o lee el ya existente en la escena.
		)
		
	)--str_overrideMaterial
	
	lb.overrides.add "material" str_overrideMaterial --a�ade el override al listado de overrides disponibles
	
	ok
)