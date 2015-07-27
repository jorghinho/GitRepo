------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de mentalGlobalTuningParams
------------------------------------------------------------------------------------------------------------------------------------------------
(		
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute:overridementalGlobalTuningParamsInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideMentalGlobalTuningParamsInfo = attributes overridementalGlobalTuningParamsInfo   
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de mentalGlobalTuningParams."
			
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"mentalGlobalTuningParams" --(lb.overrides.getFileOverrideName (getThisScriptFilename() as string))	--@var | subType | Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--Parámetros de apply y backup
			softShadowsPrecision type:#float default:0.0 --@var | softshadowsprecision | Precisión de las sombras
			glossyReflectionsPrecision  type:#float default:0.0 --@var | glossyreflectionsprecision | Parámetro de glossy reflection
			glossyRefractionsPrecision  type:#float default:0.0 --@var | glossyrefractionsprecision | Parámetro de glossy refraction
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Global Tuning Parameters Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = false --@var : editCA| Variable que almacena el valor del custom attribute de edición
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		label lblSoftShadowsPrecision "Soft Shadows Precision (Multiplier)" pos:[5,5] width:200 --@control | lblSoftShadowsPrecision | Desplegable de precisión de sombras
		dropdownList ddlSoftShadowsPrecision "" pos:[235,5] items:#("0,125","0,25","0,5","1","2","4","8","16") height:30 width:60 --@control | ddlSoftShadowsPrecision | Desplegable de precisión de sombras
		label lblGlossyReflectionsPrecision "Glossy Reflections Precision (Multiplier)" width:200 pos:[5,35] --@control | lblGlossyReflectionsPrecision | Desplegable de precisión de sombras
		spinner spnGlossyReflectionsPrecision "" height:30 pos:[232,35] range:[0.0,20.0,0.0] type:#float scale:0.01 fieldWidth:50  --@control | spnGlossyReflectionsPrecision | Desplegable de precisión de reflexión de glossy
		label lblGlossyRefractionsPrecision "Glossy Refractions Precision (Multiplier)" width:200 pos:[5,65] --@control | lblGlossyRefractionsPrecision | Desplegable de precisión de sombras
		spinner spnGlossyRefractionsPrecision "" height:30 pos:[232,65] range:[0.0,20.0,0.0] type:#float scale:0.01 fieldWidth:50 --@control | spnGlossyRefractionsPrecision | Desplegable de precisión de reflracción de glossy
		button btnOk "OK" pos:[5,95] width:145 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[150,95] width:145 --@control | btnCancel | Cancela los cambios y cierra.
		
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
			--Primero el desplegable
			for i=1 to ddlSoftShadowsPrecision.items.count do
			(
				if (editCA.softShadowsPrecision) == \
				((substituteString ddlSoftShadowsPrecision.items[i] "," ".")  As Float) then
				(
					ddlSoftShadowsPrecision.selection = i
				)
			)
			
			--Ahora los spinners
			spnGlossyReflectionsPrecision.value = editCA.glossyReflectionsPrecision
			spnGlossyRefractionsPrecision.value = editCA.glossyRefractionsPrecision
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			--sin operaciones
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--sin operaciones
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
		--@event: selected | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Dropdown precision de sombras.
		------------------------------------------------
		on ddlSoftShadowsPrecision selected index do
		(
			--Guardar el motor seleccionado
			editCA.softshadowsprecision = (substituteString ddlSoftShadowsPrecision.items[index] "," ".") As float
			
		)		
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | spnGlossyReflectionsPrecision | Spinner del valor de glossy reflections precision.
		------------------------------------------------
		on spnGlossyReflectionsPrecision changed newValue do
		(
			--Guardar el motor seleccionado
			editCA.glossyReflectionsPrecision = newValue
			
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | spnGlossyRefractionsPrecision | Spinner del valor de glossy refractions precision.
		------------------------------------------------
		on spnGlossyRefractionsPrecision changed newValue do
		(
			--Guardar el motor seleccionado
			editCA.glossyRefractionsPrecision = newValue
			
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			--Aplicar ids del gbuffer
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
			editCA = parent.editBackupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo]
			
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
	struct str_overrideMentalGlobalTuningParams
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
		relatedTypes = #("mentalFinalGather", "mentalGlobalTuningParams", "mentalRenderingAlgorithms", "mentalReuseFG", "mentalSamplingQuality"), --@var | relatedTypes | Tipos de overrides relacionados.
		
		stateMessage = "", --@var | stateMessage | Mensaje del estado actual del override.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,						--@var | infoNodeCA | Variable que almacena el ca de apply.
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideMentalGlobalTuningParamsInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideMentalGlobalTuningParamsInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			(this.infoNodeCA.softShadowsPrecision As String) + "," \
			+ (this.infoNodeCA.glossyReflectionsPrecision As String) + "," \
			+ (this.infoNodeCA.glossyRefractionsPrecision As String)
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
				if _renderer != "mental_ray_renderer" then
				(
					_state = #error
					this.stateMessage = "Previous 'renderer' override in the tree must be set to 'mental ray'"
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
				if backupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				if (classof renderers.current) == mental_ray_renderer then
				(					
					backupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo].softShadowsPrecision = renderers.current.softShadowsPrecision
					backupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo].glossyReflectionsPrecision = renderers.current.glossyReflectionsPrecision
					backupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo].glossyRefractionsPrecision = renderers.current.glossyRefractionsPrecision
					
					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("Mental ray is not the current renderer") sender:("override." + (this.getSubType())) type:#warning level:(logLevel + 1)
					_success = true
				)
			)--if
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
				if backupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo] != undefined then
				(
					if (classof renderers.current) == mental_ray_renderer then
					(
						renderers.current.softShadowsPrecision = backupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo].softShadowsPrecision 
						renderers.current.glossyReflectionsPrecision = backupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo].glossyReflectionsPrecision
						renderers.current.glossyRefractionsPrecision = backupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo].glossyRefractionsPrecision 
						
						_success = true
					)
					else
					(
						if saveLogs then lb.log.add ("Mental ray is not the current renderer") sender:("override." + (this.getSubType())) type:#warning level:(logLevel + 1)
						_success = true
					)
				)
				else
				(
					if saveLogs then lb.log.add ("Backup node is not defined") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not defined.")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("RESTORE process error. Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D" + "RESTORE process error. Backup node is not valid.")
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
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
				
			if (classof renderers.current) == mental_ray_renderer then
			(
				renderers.current.softShadowsPrecision = this.infoNodeCA.softShadowsPrecision 
				renderers.current.glossyReflectionsPrecision = this.infoNodeCA.glossyReflectionsPrecision
				renderers.current.glossyRefractionsPrecision = this.infoNodeCA.glossyRefractionsPrecision
				
				_success = true
			)
			else
			(
				if saveLogs then lb.log.add ("Mental ray is not the current renderer") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"APPLY process error. Mental ray is not the current renderer.")
				_success = false
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
				if this.editBackupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo]) _prop))
					)--undo
					
					this.editBackupNode = undefined --hace que el override no tenga backup de edicion almacenado
					
					this.updateUIinfo() --actualiza la infirmacion en el UI si ha cambiado
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | createEditBackup | Crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello.		
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
						if this.editBackupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideMentalGlobalTuningParamsInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [300, 120]
			
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
			_renderer = if classof renderers.current ==  mental_ray_renderer then renderers.current else mental_ray_renderer()
					
			--aqui irian los paramentros del CA que se tienen que rellenar en funcion de la escena o de objetosvc
			this.infoNodeCA.softShadowsPrecision = _renderer.softShadowsPrecision
			this.infoNodeCA.glossyReflectionsPrecision= _renderer.glossyReflectionsPrecision
			this.infoNodeCA.glossyRefractionsPrecision= _renderer.glossyRefractionsPrecision
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideMentalGlobalTuningParamsInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalGlobalTuningParamsInfo]

					this.storeSceneValues()					
				)
				
				--Almacenamos el override de apply en su variable
				this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalGlobalTuningParamsInfo]
				
				--primero mira si hay cambios en la escena que afecten al override y lo limpia
				this.purge()
				
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
		
	)--str_overrideGBuffer
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideMentalGlobalTuningParams --añade el override al listado de overrides disponibles
	
	ok
)