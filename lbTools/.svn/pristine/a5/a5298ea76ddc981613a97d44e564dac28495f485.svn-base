------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de Background
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideScanlineAntialiasingInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideScanlineAntialiasingInfo = attributes overrideScanlineAntialiasingInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de efectos."
				
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"scanlineAntialiasing" --@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--Parámetros de backup

			------------------------------------------------

			------------------------------------------------
			--Parámetros de apply y backup
			
			antiAliasing type:#boolean
			antiAliasFilter type:#maxObject
			filterMaps type:#boolean
			antiAliasFilterSize type:#float
			------------------------------------------------

			------------------------------------------------
			--Parámetros de apply			

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
		
		local sectionsIds = #() --@var: sectionsIds | Variable que almacena un id para asociar un nombre a cada valor del array de sectionsControls
		local sectionsControls = #() --@var: sectionsControls | Array de arrays que almacena los controles de cada sección para agruparlos y ocultarlos/desocultarlos con facilidad.
		local sectionsSizes = #() --@var: sectionsSizes | Array con los altos de cada sección (sin incluir los botones de OK y CANCEL, 20 píxeles más.)
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		groupBox grpAntialiasing "Antialiasing:" pos:[5,0] width:310 height:107
		checkbox chkAntialiasing "Antialiasing" pos:[12,20]
		checkbox chkFilterMaps "Filter Maps" pos:[12,45]

		label lblFilter "Filter:" pos:[140,23]
		dropdownlist ddlFilter pos:[170,20] width:138
		
		spinner spnFilterSize	"Filter Size:" range:[1.0,20.0,1.5] type:#float scale:0.1 pos:[200,47] fieldWidth:45
		spinner spnBlendValue	"Blend:       " range:[0.0,1.0,0.3] type:#float scale:0.01 pos:[200,67] fieldWidth:45
		spinner spnMNBlur		"Blur:         " range:[0.0,1.0,0.333] type:#float scale:0.01 pos:[200,67] fieldWidth:45
		spinner spnMNRinging	"Ringing:    " range:[0.0,1.0,0.333] type:#float scale:0.01 pos:[200,87] fieldWidth:45

		button btnOk "OK" pos:[5,107] width:155
		button btnCancel "Cancel" pos:[160,107] width:155

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
			ddlFilter.items = sort #("Area","Quadratic","cubic", "Catmull_Rom", "Blackman", "Sharp_Quadratic", "Video", "Plate_Match_MAX_R2", "Cook_Variable", "Soften", "Mitchell_Netravali", "Blendfilter")
			ddlFilter.selection = finditem ddlFilter.items ((classof editCA.antiAliasFilter) As String)

			chkAntialiasing.checked = editCA.antiAliasing
			chkFilterMaps.checked = editCA.filterMaps
			spnFilterSize.value = editCA.antiAliasFilterSize

			case ((classof editCA.antiAliasFilter) As String) of
			(
				"Area":
				(
					spnFilterSize.enabled = true

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)				

				"Quadratic":
				(
					spnFilterSize.enabled = false

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"cubic":
				(
					spnFilterSize.enabled = false

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Catmull_Rom":
				(
					spnFilterSize.enabled = true

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Blackman":
				(
					spnFilterSize.enabled = true

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Sharp_Quadratic":
				(
					spnFilterSize.enabled = false

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Video":
				(
					spnFilterSize.enabled = false

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Plate_Match_MAX_R2":
				(
					spnFilterSize.enabled = true

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Cook_Variable":
				(
					spnFilterSize.enabled = true

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Soften":
				(
					spnFilterSize.enabled = true

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Mitchell_Netravali":
				(
					spnFilterSize.enabled = false

					spnBlendValue.visible = false
					spnMNBlur.visible = true
					spnMNBlur.value = editCA.antiAliasFilter.Blur
					spnMNRinging.visible = true
					spnMNRinging.value = editCA.antiAliasFilter.Ringing
				)

				"Blendfilter":
				(
					spnFilterSize.enabled = true

					spnBlendValue.visible = true
					spnBlendValue.value = editCA.antiAliasFilter.Blend
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)
			)
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
		
		on ddlFilter selected item do
		(
			case ddlFilter.items[item] of
			(
				"Area":
				(
					spnFilterSize.enabled = true
					spnFilterSize.value = 1.5

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Quadratic":
				(
					spnFilterSize.enabled = false
					spnFilterSize.value = 3.0

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"cubic":
				(
					spnFilterSize.enabled = false
					spnFilterSize.value = 4.0

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Catmull_Rom":
				(
					spnFilterSize.enabled = true
					spnFilterSize.value = 4.0

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Blackman":
				(
					spnFilterSize.enabled = true
					spnFilterSize.value = 4.0

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Sharp_Quadratic":
				(
					spnFilterSize.enabled = false
					spnFilterSize.value = 2.8

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Video":
				(
					spnFilterSize.enabled = false
					spnFilterSize.value = 4.0

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Plate_Match_MAX_R2":
				(
					spnFilterSize.enabled = true
					spnFilterSize.value = 1.5

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Cook_Variable":
				(
					spnFilterSize.enabled = true
					spnFilterSize.value = 2.5

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Soften":
				(
					spnFilterSize.enabled = true
					spnFilterSize.value = 6.0

					spnBlendValue.visible = false
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)

				"Mitchell_Netravali":
				(
					spnFilterSize.enabled = false
					spnFilterSize.value = 4.0

					spnBlendValue.visible = false
					spnMNBlur.visible = true
					spnMNBlur.value = 0.333
					spnMNRinging.visible = true
					spnMNRinging.value = 0.333
				)

				"Blendfilter":
				(
					spnFilterSize.enabled = true
					spnFilterSize.value = 8.0

					spnBlendValue.visible = true
					spnBlendValue.value = 0.3
					spnMNBlur.visible = false
					spnMNRinging.visible = false
				)
			)--case
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			((classof editCA.antiAliasFilter) As String)

			editCA.antiAliasing = chkAntialiasing.checked
			editCA.filterMaps = chkFilterMaps.checked
			editCA.antiAliasFilterSize = spnFilterSize.value 

			--Aplicamos los valores del interfaz al custom attribute en editCA
			case ddlFilter.selected of
			(
				"Area":
				(
					editCA.antiAliasFilter = Area()
				)

				"Quadratic":
				(
					editCA.antiAliasFilter = Quadratic()
				)

				"cubic":
				(
					editCA.antiAliasFilter = cubic()
				)

				"Catmull_Rom":
				(
					editCA.antiAliasFilter = Catmull_Rom()
				)

				"Blackman":
				(
					editCA.antiAliasFilter = Blackman()
				)

				"Sharp_Quadratic":
				(
					editCA.antiAliasFilter = Sharp_Quadratic()
				)

				"Video":
				(
					editCA.antiAliasFilter = Video()
				)

				"Plate_Match_MAX_R2":
				(
					editCA.antiAliasFilter = Plate_Match_MAX_R2()
				)

				"Cook_Variable":
				(
					editCA.antiAliasFilter = Cook_Variable()
				)

				"Soften":
				(
					editCA.antiAliasFilter = Soften()
				)

				"Mitchell_Netravali":
				(
					editCA.antiAliasFilter = Mitchell_Netravali()
					editCA.antiAliasFilter.Blur = spnMNBlur.value
					editCA.antiAliasFilter.Ringing = spnMNRinging.value
				)

				"Blendfilter":
				(
					editCA.antiAliasFilter = Blendfilter()
					editCA.antiAliasFilter.Blend = spnBlendValue.value
				)
			)--case

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
			
			editCA = parent.editBackupNode.custAttributes[#overrideScanlineAntialiasingInfo]
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
	struct str_overrideScanlineAntialiasing
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
		
		overrideInfo = ca_overrideScanlineAntialiasingInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideScanlineAntialiasingInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			((classof this.infoNodeCA.antiAliasFilter) As String)
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok

			--busca el override de render precedente obligatorio
			_rendererOverride = (this.getOverrideManager()).getRelativeAncestorOverride "renderer"
			
			if _rendererOverride != undefined then --si lo encuentra
			(
				--si el renderer no es mental ray, lo marca como erroneo ya que no va a poder aplicar los parametros
				_renderer = (_rendererOverride.customOverride.infoNodeCA.currentRenderer)
				if _renderer != "Default_Scanline_Renderer" then
				(
					_state = #error
					this.stateMessage = "Previous 'renderer' override in the tree must be set to 'Default Scanline Renderer'"
				)
			)
			else --si no lo encuentra
			(
				this.stateMessage = "There must be a previows 'renderer' override in the tree"
				_state = #error
			)--if else

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
				if backupNode.custAttributes[#overrideScanlineAntialiasingInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo

				if (classof renderers.current) == Default_Scanline_Renderer then
				(
					_backupCA = backupNode.custAttributes[#overrideScanlineAntialiasingInfo]

					_backupCA.antiAliasing = renderers.current.antiAliasing
					_backupCA.antiAliasFilter = renderers.current.antiAliasFilter
					_backupCA.filterMaps = renderers.current.filterMaps
					_backupCA.antiAliasFilterSize = renderers.current.antiAliasFilterSize
				
					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("Scanline is not the current renderer") sender:("override." + (this.getSubType())) type:#warning level:(logLevel + 1)					
					_success = true
				)
			)
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)					
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup Node is not valid.")
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
				if backupNode.custAttributes[#overrideScanlineAntialiasingInfo] != undefined then
				(
					if (classof renderers.current) == Default_Scanline_Renderer then
					(
						_backupCA = backupNode.custAttributes[#overrideScanlineAntialiasingInfo]

						renderers.current.antiAliasing = _backupCA.antiAliasing
						renderers.current.antiAliasFilter = _backupCA.antiAliasFilter
						renderers.current.filterMaps = _backupCA.filterMaps
						renderers.current.antiAliasFilterSize = _backupCA.antiAliasFilterSize
					
						_success = true
					)
					else
					(
						if saveLogs then lb.log.add ("Scanline is not the current renderer") sender:("override." + (this.getSubType())) type:#warning level:(logLevel + 1)					
						_success = true
					)
				)
				else
				(
					if saveLogs then lb.log.add ("Backup node with no custom attribute") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Custom attribute is undefined.")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup Node is not valid.")
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
			
			if (classof renderers.current) == Default_Scanline_Renderer then
			(
				renderers.current.antiAliasing = this.infoNodeCA.antiAliasing
				renderers.current.antiAliasFilter = this.infoNodeCA.antiAliasFilter
				renderers.current.filterMaps = this.infoNodeCA.filterMaps
				renderers.current.antiAliasFilterSize = this.infoNodeCA.antiAliasFilterSize
			
				_success = true
			)
			else
			(
				if saveLogs then lb.log.add ("Scanline is not the current renderer") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)					
				_success = true
			)
			
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
				if this.editBackupNode.custAttributes[#overrideScanlineAntialiasingInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideScanlineAntialiasingInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideScanlineAntialiasingInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideScanlineAntialiasingInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideScanlineAntialiasingInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [320, 130]
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
			--Aquí rellenamos los parámetros del override al principio (todos con los que vienen en la escena)
			this.infoNodeCA.antiAliasing = true
			this.infoNodeCA.antiAliasFilter = Area()
			this.infoNodeCA.filterMaps = true
			this.infoNodeCA.antiAliasFilterSize = 1.5
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideScanlineAntialiasingInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideScanlineAntialiasingInfo]

					this.storeSceneValues()
				)
				
				this.infoNodeCA = this.infoNode.custAttributes[#overrideScanlineAntialiasingInfo]
								
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
		
	)--str_overrideScanlineAntialiasing
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideScanlineAntialiasing --añade el override al listado de overrides disponibles
	
	ok
)