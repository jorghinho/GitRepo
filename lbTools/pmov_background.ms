------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de Background
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideBackgroundInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideBackgroundInfo = attributes overrideBackgroundInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.2
			CA_description	type:#string	default:"Almacena la informacion de un override de efectos."
				
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"background" --@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.*/
			
			------------------------------------------------
			--Parámetros de backup
			sceneColor type:#color
			sceneUseMap type:#boolean
			sceneBackgroundMap type:#texturemap
			--Parámetros de apply y backup
			------------------------------------------------
			
			
			------------------------------------------------
			--Parámetros de apply
			overrideColor type:#color --@var | strings | Array de strings con los nombres de los atmosféricos que vamos a aplicar al pase.
			overrideUseMap type:#boolean
			overrideBackgroundMap type:#texturemap
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Background Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var: editCA | Variable que almacena el custom attribute de edición
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local materialEditorModeBckp = #basic --@var : materialEditorModeBckp | Modo del editor de materiales al abrirse para no perderlo.	
		local materialEditorSlotsBckp = undefined --@var : materialEditorSlotsBckp | Materiales que estaban almacenado en el slot 1 del editor de materiales para no perderlos.
		local materialEditorStateBckp = false --@var : materialEditorStateBckp | Estado de abierto/cerrado del editor de materiales.
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		groupBox grpBackground "Background:" pos:[5,0] width:290 height:80 
		
		colorpicker clrColor "Color:" pos:[15,20] color:(color 0 0 0)
		
		checkbutton ckbBgEdit "<map>" pos:[100,20] width:185 --@control | ckbBgEdit | Para elegir el mapa de fondo de override.
		mapbutton mpbEnvironmentalMap "Environment Map" pos:[100,20] width:185 visible:false
		checkbox chkUseMap "Use Map" pos:[100,50]
		
		button btnOk "Ok" pos:[5,85] width:145
		button btnCancel "Cancel" pos:[150,85] width:145
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

			clrColor.color = editCA.overrideColor
			chkUseMap.checked = editCA.overrideUseMap
			ckbBgEdit.caption = \
				if editCA.overrideBackgroundMap != undefined then 
				(
					editCA.overrideBackgroundMap.name
				)
				else
				(
					"<pick map>" --pone al boton el nombre del mapa actual del override
				)

			setFocus 
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
		--@event: changed | Evento que se lanza al presionar el boton para elegir mapa
		--@control: checkbutton | ckbBgEdit | Boton para elegir mapa.
		--@gets: boolean | state | Estado presionado o no.
		------------------------------------------------
		on ckbBgEdit changed state do
		(
			if state then
			(
				if materialEditorStateBckp then MatEditor.close() --si eleditor estaba abierto inicialmente lo cierra
				MatEditor.mode = #basic
				MatEditor.Open() --abre el editor de materiales para modificar el material de override
				setMeditMaterial 1 (
					if editCA.overrideBackgroundMap != undefined then
					(
						(copy editCA.overrideBackgroundMap)
					)
					else (Bitmaptexture())
				) --coloca el mapa o material de override en el editor		
				medit.SetActiveMtlSlot 1 true
			)
			else
			(
				if superClassOf (getMeditMaterial 1) == textureMap then
				(
					editCA.overrideBackgroundMap = getMeditMaterial 1 --salva el nuevo mapa de override
					editCA.overrideBackgroundMaterial = undefined
					ckbBgEdit.caption = editCA.overrideBackgroundMap.name
					MatEditor.close()
					if materialEditorStateBckp then MatEditor.Open()
				)--if
				else
				(
					lb.message.show "Only maps are allowed, not materials. Create a map on the first slot of Material Editor." type:#message pos:undefined modal:true
					editCA.overrideBackgroundMap = undefined
					ckbBgEdit.caption = "None"
				)

			)--if else
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			editCA.overrideColor = clrColor.color
			editCA.overrideUseMap = chkUseMap.checked
			if superClassOf (getMeditMaterial 1) == textureMap then 
			(
				editCA.overrideBackgroundMap = getMeditMaterial 1 --salva el nuevo mapa de override
			)
			else
			(
				lb.message.show "Only maps are allowed, not materials. Create a map on the first slot of Material Editor." type:#message pos:undefined modal:true
				editCA.overrideBackgroundMap = undefined
				ckbBgEdit.caption = "None"
			)

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
			
			editCA = parent.editBackupNode.custAttributes[#overrideBackgroundInfo]
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
	struct str_overrideEffects
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
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,							--@var | infoCA | Variable que almacena el custom attribute de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideBackgroundInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideBackgroundInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			--Si hay mapa entonces mapa
			if (infoNode.overrideUseMap) then
			(
				if (infoNode.overrideBackgroundMap != undefined) then
					(infoNode.overrideBackgroundMap.name)
				else if (infoNode.overrideBackgroundMaterial != undefined) then
					(infoNode.overrideBackgroundMaterial.name)
			)
			else
				(infoNode.overrideColor As String)
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
		--@fn: undefined | redirect | Realiza redireccion de sources en el override.
		--@gets: string | sourcePattern | Parte del path que sustituir.
		--@gets: string | mappedPattern | Parte del path por la cual sustituir.
		------------------------------------------------
		fn redirect sourcePattern mappedPattern =
		(
			lb.materials.redirectMatBitmaps (this.infoNodeCA.overrideBackgroundMap) sourcePattern mappedPattern
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
				if backupNode.custAttributes[#overrideBackgroundInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				backupNode.custAttributes[#overrideBackgroundInfo].sceneColor = backgroundColor 
				backupNode.custAttributes[#overrideBackgroundInfo].sceneUseMap = useEnvironmentMap
				--backupNode.custAttributes[#overrideBackgroundInfo].sceneBackgroundMap = StandardMaterial()
				
				--Si es un material
				backupNode.custAttributes[#overrideBackgroundInfo].sceneBackgroundMap = environmentMap
				
				_success = true
			)
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)					
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node is not valid")
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
				if backupNode.custAttributes[#overrideBackgroundInfo] != undefined then
				(
					backgroundColor = backupNode.custAttributes[#overrideBackgroundInfo].sceneColor
					
					---------------------------					
					--hay una excepcion en este caso, debido a un bug de max. Resulta que cuando se aplica un mapa de enviroment por codigo, le resetea las coordenadas.
					--por eso se le restauran las coordenadas.
					if backupNode.custAttributes[#overrideBackgroundInfo].sceneBackgroundMap != undefined then
					(
						_mappingTypeBackup = 1
						_mappingBackup = 3
						if hasProperty this.infoNodeCA.overrideBackgroundMap #coords then
						(
							_mappingTypeBackup = this.infoNodeCA.overrideBackgroundMap.coords.mappingType
							_mappingBackup = this.infoNodeCA.overrideBackgroundMap.coords.mapping
						)
						environmentMap = backupNode.custAttributes[#overrideBackgroundInfo].sceneBackgroundMap					
						if hasProperty environmentMap #coords then
						(
							environmentMap.coords.mappingType = _mappingTypeBackup
							environmentMap.coords.mapping = _mappingBackup
						)
					)
					else -- Si no le aplicamos el mapa vacío sin mas.
					(
						environmentMap = backupNode.custAttributes[#overrideBackgroundInfo].sceneBackgroundMap
					)

					--esta propiedad se debe aplicar la ultima porque si se aplica lo ultimo el mapa, se activa automaticamente
					useEnvironmentMap = backupNode.custAttributes[#overrideBackgroundInfo].sceneUseMap

					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("Backup node with no custom attribute") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node with no custom attribute.")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node is not valid.")
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
			
			------------------------------------------------
			backgroundColor = this.infoNodeCA.overrideColor
			
			environmentMap = copy this.infoNodeCA.overrideBackgroundMap
			--hay una excepcion en este caso, debido a un bug de max. Resulta que cuando se aplica un mapa de enviroment por codigo, le resetea las coordenadas.
			--por eso se le restauran las coordenadas.
			if hasProperty environmentMap #coords then
			(
				environmentMap.coords.mappingType = this.infoNodeCA.overrideBackgroundMap.coords.mappingType
				environmentMap.coords.mapping = this.infoNodeCA.overrideBackgroundMap.coords.mapping
			)
			
			
			--esta propiedad se debe aplicar la ultima porque si se aplica lo ultimo el mapa, se activa automaticamente
			useEnvironmentMap = this.infoNodeCA.overrideUseMap
			------------------------------------------------
			
			_success = true
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
				if this.editBackupNode.custAttributes[#overrideBackgroundInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideBackgroundInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideBackgroundInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideBackgroundInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideBackgroundInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [300, 110]
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
		--@fn: undefined | storeSceneValues | Almacena los valores de la escena en el override.
		------------------------------------------------
		fn storeSceneValues =
		(
			--Parámetros de apply
			this.infoNodeCA.sceneColor = backgroundColor 
			this.infoNodeCA.sceneUseMap = useEnvironmentMap
			
			
			this.infoNodeCA.sceneBackgroundMap = environmentMap
		
			
			this.infoNodeCA.overrideColor = backgroundColor 
			this.infoNodeCA.overrideUseMap = useEnvironmentMap
			
			this.infoNodeCA.overrideBackgroundMap = environmentMap
			
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideBackgroundInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					
					--Almacenamos el custom attribute de info en la variable infoNodeCA
					this.infoNodeCA = this.infoNode.custAttributes[#overrideBackgroundInfo]

					this.storeSceneValues()
				)
				else
				(
					--Almacenamos el custom attribute de info en la variable infoNodeCA
					this.infoNodeCA = this.infoNode.custAttributes[#overrideBackgroundInfo]
					
				)
				
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
		
	)--str_overrideEffects
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideEffects --añade el override al listado de overrides disponibles
	
	ok
)