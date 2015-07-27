------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de Environment y Efectos
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideEnvironmentAndEffects | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideEnvironmentAndEffectsInfo = attributes overrideEnvironmentAndEffectsInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de Environment and Effects."
			
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"environmentAndEffects"	--@var | subType | Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
				
			-----------------------------------------------------------
			-- Parámetros de backup

			-----------------------------------------------------------
			
			-----------------------------------------------------------
			-- Parámetros de backup y apply
			
			-----------------------------------------------------------
			-- COMMON PARAMETERS
			overrideEnvironmentCommonProperties type:#boolean default:false --@var | overrideEnvironmentCommonProperties | Parámetro que indica si hay override de Common Properties
			
			-----------------------------------------------------------
			-- Parámetros de backup y apply
			
			--Background
			environmentMap type:#textureMap --@var | environmentMap | Parámetro que indica el mapa de environment que vamos a usar
			useEnvironmentMap type:#boolean default:false --@var | useEnvironmentMap | Parámetro que indica si el mapa de environment va a ser usado o no
			backgroundColor type:#color default:(color 0 0 0) --@var | backgroundColor | Parámetro que indica el color environment Background
			
			--Global Lighting
			lightTintColor type:#color default:(color 255 255 255) --@var | lightTintColor | Parámetro que indica el color de tint de background.
			lightLevel type:#float default:1.0 --@var | lightLevel | Parámetro que indica el nivel de luz.
			ambientColor type:#color default:(color 0 0 0) --@var | ambient | Parámetro que indica el color de ambient.
			
			-----------------------------------------------------------
			-- ATMOSPHERE
			overrideEnvironmentAtmosphere type:#boolean default:false --@var | overrideEnvironmentAtmosphere
			
			-----------------------------------------------------------
			-- Parámetros de apply
			selectedAtmospherics type:#stringTab tabsizevariable:true --@var | strings | Array de strings con los nombres de los atmosféricos que vamos a aplicar al pase.
			
			-----------------------------------------------------------
			
			-----------------------------------------------------------
			-- EFFECTS
			overrideEffects type:#boolean default:false --@var | boolean | Flag para indicar si se hace override de los parámetros de efectos.
			-----------------------------------------------------------
			-- Parámetros de apply
			selectedEffects type:#stringTab tabsizevariable:true --@var | strings | Array de strings con los nombres de los efectos que vamos a aplicar al pase.
			-----------------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--FUNCION DE CARGAR DE LOS ROLLOUTS DE UI PARA EL OVERRIDE
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	------------------------------------------------
	--@fn: undefined | loadRollUIs | Carga los rollouts que necesita el override.
	------------------------------------------------	
	fn loadRollUIs =
	(
		_path = getFilenamePath (getThisScriptFilename() as string)
		_file = (lb.overrides.getFileOverrideName (getThisScriptFilename() as string))

		_uiRollsFiles = getFiles (_path + "pmovUI_" + _file + "-*")
		for _uiFile in _uiRollsFiles do filein _uiFile		
	)

	loadRollUIs()
	------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------

	

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Environment And Effects Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento.
		
		local editCA = undefined --@var : editCA| Variable de atajo para el CA de edit.
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 600	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local opening = false --@var: opening | Flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--label lblRenderers "Select Renderer:" pos:[5,8]
		--dropdownlist ddlRenderers "" pos:[90,5] items:#() height:20 width:255

		dotNetControl tbSettingsCategories "DevExpress.XtraTab.XtraTabControl" pos:[0,5] width:350 height:22 --25

		button btnOk "OK" pos:[5,575] width:170 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[175,575] width:170 --@control | btnCancel | Cancela los cambios y cierra.
		
		------------------------------------------------------------------------------------------------
		--SUBROLLOUTS
		------------------------------------------------------------------------------------------------

		subrollout subRollContainer1 "subRollouts" pos:[0,27] width:minRollWidth height:540 --@control | subRollContainer1 | SubRollouts container.

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
		--@fn: undefined | initUI | Inicializa los controles del UI.
		------------------------------------------------
		fn initUI =
		(	
			tbSettingsCategories.paintstylename = "PropertyView"
			tbSettingsCategories.borderStyle = (dotnetclass "DevExpress.XtraEditors.Controls.BorderStyles").noBorder
			tbSettingsCategories.TabPageWidth = 100			
			
			tbSettingsCategories.Appearance.BackColor = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbSettingsCategories.Appearance.BackColor2 = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbSettingsCategories.Appearance.BorderColor = (dotnetclass "system.drawing.color").fromArgb 100 100 100

			--showProperties tbSettingsCategories.Appearance
		)

		------------------------------------------------
		--@fn: undefined | resetRendererSpecificUI | Resetea el UI en funcion del motor de render elegido.
		------------------------------------------------
		fn resetRendererSpecificUI =
		(
			parent.addRendererTabs()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks de este rollout.
		------------------------------------------------
		fn createSceneEvents =
		(
			--sin operaciones
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Elimina los callbacks de este rollout.
		------------------------------------------------
		fn removeSceneEvents =
		(
			--sin operaciones
		)

		------------------------------------------------
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			--_renderersList = #()

			--obtiene los renderers instalados
			--for i=1 to RendererClass.classes.count
			--where (not (matchPattern (RendererClass.classes[i] As string) pattern:"Missing*")) and (not (matchPattern (RendererClass.classes[i] As String) pattern:"VUE*")) do
			--	append _renderersList (RendererClass.classes[i] As String)

			--ddlRenderers.items = _renderersList --los añade al listado

			--selecciona el que sea el actual del override
			--for i=1 to _renderersList.count where _renderersList[i] == editCA.currentRenderer do ddlRenderers.selection = i

			resetRendererSpecificUI() --configura los tabs y los subrollouts
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
		fn loadSettings = --OK
		(
			_heightBckp = rollMainDef.height --hace backup del tamaño actual de la ventana
			_posBckp = getDialogPos rollMainDef --hace backup de la posicion del rollout

			--tamaño
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
			--establece minimos
			if _height < minRollHeight then _height = minRollHeight

			--si el tamaño varía en altura, hay que ajustar la posicion vertical del rollout para centrarlo en la herramienta dede la que se ha abierto
			_increment = _height - _heightBckp
			if _increment != 0 then _posBckp.y = _posBckp.y - (_increment/2.0)
			if _posBckp.y < 0 then _posBckp.y = 0

			--aplica los valores
			rollMainDef.height = _height
			setDialogPos rollMainDef _posBckp

			parent.selectedTabIndex = (lb.xml.getAttribute parent.cfgFile "rollMain/options" "selectedTabIndex") as integer
			if parent.selectedTabIndex == 0 then parent.selectedTabIndex = 1
		)
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--stores size
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "selectedTabIndex" (parent.selectedTabIndex as string)
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | ddlRenderers | Dropdown de motores de render.
		--@gets: integer | index | Indice del elemento del listado seleccionado.
		------------------------------------------------
		on ddlRenderers selected index do
		(
			--Guardar el motor seleccionado
			editCA.currentRenderer = ddlRenderers.items[index]
			resetRendererSpecificUI() --configura los tabs y los subrollouts si el renderer ha cambiado
		)

		------------------------------------------------
		--@event: selectedPageChanged | Evento que se lanza al cambiar de tab.
		--@control: DevExpress.XtraTab.XtraTabControl | tbSettingsCategories | Tabs de categorias de motores de render.
		--@gets: event | events | Objeto devuelto por el evento.
		------------------------------------------------
		on tbSettingsCategories selectedPageChanged events do
		(
			if not opening then
			(
				parent.selectedTabIndex = tbSettingsCategories.selectedTabPageIndex + 1
				parent.addTabRollouts()
			)--if
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			parent.removeAllTabRollouts() --primero se eliminan los subrollouts 

			parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
			
			DestroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Cancela los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnCancel pressed do
		(
			DestroyDialog parent.rollMain
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
			------------------------------------------------------------------------------
			--si el tamaño es menor que el minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento de tamaño
			_increment = [size.x - minRollWidth, size.y - minRollHeight]

			------------------------------------------------------------------------------
			--redimension en horizonal
			
			------------------------------------------------------------------------------

			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				--zona de subRollouts
				subRollContainer1.height = 514 + _increment.y

				--botones de abajo
				btnOk.pos.y = 575 + _increment.y
				btnCancel.pos.y = 575 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			opening = true --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg

			parent = lb.passManager.getCurrentEditInstance()
			
			editCA = parent.editBackupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]
			initUI() --inicializa el UI
			loadSettings()
			loadOverrideInfo()
			createSceneEvents()			

			opening = false --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(				
			removeSceneEvents()
			onCloseOperations()
			saveSettings()			
		)	
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: override | Contiene todas las funciones del override de Environment y efectos
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideEnvironmentAndEffects
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = (getFileNamePath (getThisScriptFilename() as string)) + "pmov_environmentAndEffects.ms",	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		cfgFile = (lb.config.getToolsIniPath()) + "overrideEnvironmentAndEffects.cfg",	--@var: cfgFile | Archivo de configuracion del override.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		type = "override",		--@var | type | Indica que es un override.
		subType = lb.overrides.getFileOverrideName (getThisScriptFilename() as string),	--@var | subType | Indica que tipo de override concreto almacena.
		relatedTypes = #(), --@var | relatedTypes | Tipos de overrides relacionados.
		
		stateMessage = "", --@var | stateMessage | Mensaje del estado actual del override.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,						--@var | infoNodeCA | Variable de atajo para el CA de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideEnvironmentAndEffectsInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideEnvironmentAndEffectsInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
		tabForeColor = (dotnetclass "system.drawing.color").fromArgb 189 189 189,
		tabBorderColor = (dotnetclass "system.drawing.color").fromArgb 30 30 30,
		tabBackColor = (dotnetclass "system.drawing.color").fromArgb 60 60 60,
		tabBackColorActive = (dotnetclass "system.drawing.color").fromArgb 90 90 90,
		tabBackColor2 = (dotnetclass "system.drawing.color").fromArgb 55 55 55,
		tabBackColorActive2 = (dotnetclass "system.drawing.color").fromArgb 60 60 60,
		tabBackColorOverrided = (dotnetclass "system.drawing.color").fromArgb 85 246 22,
		tabForeColorOverridedActive = (dotnetclass "system.drawing.color").fromArgb 85 246 22,

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		--rollExample1 = rollExampleDef1,	--@var: rollExample1 | Example rollout.
		rollEnvironmentCommonProperties = rollEnvironmentCommonPropertiesDef, --@var: rollMentalSamplingQuality | Rollout de sampling quality de mental ray.
		rollEnvironmentAtmosphere = rollEnvironmentAtmosphereDef,
		rollEffects = rollEffectsDef,

		rollMain = rollMainDef,	--@var: rollMain | Main tool rollout.
		
		subRolloutsContainer = this.rollMain.subRollContainer1, --@var: subRolloutsContainer | contenedor de subrollouts.
		
		--titulos de los tabs
		tabsToUse = #("Environment","Effects"), --@var: mentalrayTabNames | Tabs de environment.
		
		--rollouts de cada tab
		rollsByTab = #(#(rollEnvironmentCommonProperties,rollEnvironmentAtmosphere),#(rollEffects)),
		
		--estado de desplegado o plegado de cada rollout de cada tab
		rolloutsRolledUp = #(#(false,false), #(false)), --@var: scanlineTabNames | Estado de desplegado/plegado de cada rollout de cada tab		
		
		selectedTabIndex = 1, --@var: selectedTabIndex | Estado de desplegado/plegado de cada rollout de cada tab de iray.
		
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

			if this.infoNodeCA.overrideEnvironmentCommonProperties then _info += "common props"
			if this.infoNodeCA.overrideEnvironmentAtmosphere then (if _info != "" then _info += ", "; _info += "atmosphere")
			if this.infoNodeCA.overrideEffects then (if _info != "" then _info += ", "; _info += "effects")

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
		--@fn: undefined | redirect | Realiza redireccion de sources en el override.
		--@gets: string | sourcePattern | Parte del path que sustituir.
		--@gets: string | mappedPattern | Parte del path por la cual sustituir.
		------------------------------------------------
		fn redirect sourcePattern mappedPattern =
		(
			lb.materials.redirectMatBitmaps (this.infoNodeCA.environmentMap) sourcePattern mappedPattern
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
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false

			if saveLogs then lb.log.add ("BACKUP process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				_backupCA = backupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]

				--si el nodo de backup no tiene el CA de backup se lo pone
				if _backupCA == undefined then
				(
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
					_backupCA = backupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]
				)
				
				------------------------------------------------
				--GENERAL
				
				------------------------------------------------
				--ENVIRONMENT COMMON PROPERTIES

				if saveLogs then lb.log.add ("Backup: Environment Common Properties") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)
				
				--Background
				_backupCA.environmentMap = environmentMap
				_backupCA.useEnvironmentMap = useEnvironmentMap
				_backupCA.backgroundColor = backgroundColor
				
				--Global Lighting
				_backupCA.lightTintColor = lightTintColor
				_backupCA.lightLevel = lightLevel
				_backupCA.ambientColor = ambientColor
				
				------------------------------------------------
				--ENVIRONMENT ATMOSPHERE
				
				--Sólo tiene parámetros de apply
				
				------------------------------------------------
				--Proceso completado
				if saveLogs then lb.log.add ("BACKUP process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				_success = true
			)--if
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup Node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not valid.")
				_success = false
			)

			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false

			if saveLogs then lb.log.add ("RESTORE process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(
				_backupCA = backupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]

				if _backupCA != undefined then
				(
					------------------------------------------------------------------------
					-- ENVIRONMENT COMMON PARAMETERS
					
					if saveLogs then lb.log.add ("Restore: Environment Common Properties") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)
					--Background
					environmentMap = _backupCA.environmentMap
					useEnvironmentMap = _backupCA.useEnvironmentMap
					backgroundColor = _backupCA.backgroundColor
					
					--Global Lighting
					lightTintColor = _backupCA.lightTintColor
					lightLevel = _backupCA.lightLevel
					ambientColor = _backupCA.ambientColor
					-------------------------------------------------------------------------
					
					-------------------------------------------------------------------------
					--ENVIRONMENT ATMOSPHERE
					--En este caso haremos si que hay restore desactivando todos los atmosféricos.
					if (this.infoNodeCA.overrideEnvironmentAtmosphere) then
					(
						for i=1 to numAtmospherics do
						(
							if isActive(getAtmospheric i) then
							(
								setActive (getAtmospheric i) false
								if saveLogs then lb.log.add ("Restoring " + (getAtmospheric i).name + " atmospheric.") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 2)
							)
						)
					)

					-------------------------------------------------------------------------
					--EFFECTS
					--En este caso haremos si que hay restore desactivando todos los efectos.
					if (this.infoNodeCA.overrideEffects) then
					(
						for i=1 to numEffects do
						(
							if isActive(getEffect i) then
							(
								setActive (getEffect i) false
								if saveLogs then lb.log.add ("Restoring " + (getEffect i).name + " effect.") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 2)
							)
						)
					)

					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("RESTORE process error. CA #overrideEnvironmentAndEffectsInfo is undefined.") sender:("override." + (this.getSubType())) type:#error level:logLevel
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Custom attribute is not defined.")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("RESTORE process error. Backup Node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not valid.")
				_success = false
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1=
		(
			_success = false
			
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			-------------------------------------------------------------------
			-- ENVIRONMENT COMMON PARAMETERS
			if (this.infoNodeCA.overrideEnvironmentCommonProperties) then
			(
				--Background
				if saveLogs then lb.log.add ("APPLYing Environment Common Parameters") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				environmentMap = this.infoNodeCA.environmentMap
				useEnvironmentMap = this.infoNodeCA.useEnvironmentMap
				backgroundColor = this.infoNodeCA.backgroundColor
				
				--Global Lighting
				lightTintColor = this.infoNodeCA.lightTintColor
				lightLevel = this.infoNodeCA.lightLevel
				ambientColor = this.infoNodeCA.ambientColor
			)
			
			-------------------------------------------------------------------
			-- ENVIRONMENT ATMOSPHERE
			--Al aplicar lo que hacemos es activar los que nos interesan a nosotros y desactivar el resto
			if (this.infoNodeCA.overrideEnvironmentAtmosphere) then
			(
				for i=1 to numAtmospherics do
				(
					if (finditem (infoNodeCA.selectedAtmospherics) (getAtmospheric i).name) != 0 then
					(
						setActive (getAtmospheric i) true
						if saveLogs then lb.log.add ("Atmospheric <" + (getAtmospheric i).name + "> enabled.") sender:("override." + (this.getSubType())) type:#ok level:(logLevel+1)
					)
				)
			)

			-------------------------------------------------------------------
			-- EFFECTS
			if (this.infoNodeCA.overrideEffects) then
				for i=1 to numEffects do
				(
					if (finditem (this.infoNodeCA.selectedEffects) (getEffect i).name) != 0 then
					(
						setActive (getEffect i) true
						
						if _success then lb.log.add ("Effect <" + (getEffect i).name + "> enabled.") sender:("override." + (this.getSubType())) type:#ok level:(logLevel+1)
					)
				)


			_success = true
			
			if saveLogs then lb.log.add ("APPLY process complete.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
			
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
				if this.editBackupNode.custAttributes[#overrideEnvironmentAndEffectsInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideEnvironmentAndEffectsInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]) _prop (getProperty (this.infoNodeCA) _prop))
					)--if
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | updateRendererTabsColor | Actualiza el color de los tabs del motor de render elegido
		------------------------------------------------
		fn updateRendererTabsColor =
		(
			--actualiza los tabs
			for i=1 to tabsToUse.count do
			(
				_overridedTab = false --flag para saber si hay algun override activo

				--avrigua si para cada tab hay overrides activos
				for roll in rollsByTab[i] where not _overridedTab do
				(
					_overrideProperty = substituteString (substituteString roll.name "roll" "override") "Def" ""
					_overridedTab = getProperty this.rollMain.editCA _overrideProperty
				)--for

				--si tiene overrides añade (*) al nombre del tab
				if _overridedTab then
				(
					if findString this.rollMain.tbSettingsCategories.tabPages.item[i-1].text " (*)" == undefined then
						this.rollMain.tbSettingsCategories.tabPages.item[i-1].text = (this.rollMain.tbSettingsCategories.tabPages.item[i-1].text) + " (*)"
				)
				else this.rollMain.tbSettingsCategories.tabPages.item[i-1].text = substituteString this.rollMain.tbSettingsCategories.tabPages.item[i-1].text " (*)" ""

				--configura los colores de los tabs
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.ForeColor = if _overridedTab then this.tabForeColorOverridedActive else this.tabForeColor
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.BackColor = this.tabBackColor
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.BackColor2 = this.tabBackColor2
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.BorderColor = this.tabBorderColor
				
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 8
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.ForeColor = if _overridedTab then this.tabForeColorOverridedActive else this.tabForeColor
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.BackColor = this.tabBackColorActive
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.BackColor2 = this.tabBackColorActive2
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.BorderColor = this.tabBorderColor
			)--for
		),
		
		------------------------------------------------
		--@fn: undefined | addRendererTabs | Añade los tabs del motor de render elegido.
		------------------------------------------------
		fn addRendererTabs =
		(
			--elimina los tabs actuales
			this.rollMain.tbSettingsCategories.tabPages.clear()
			
			--añade los tabs
			for i=1 to tabsToUse.count do
				this.rollMain.tbSettingsCategories.tabPages.add tabsToUse[i] --añade el tab
			
			--selecciona el tab que estaba seleccionado la ultima vez que se abrio el override	
			if this.rollMain.tbSettingsCategories.tabPages.count >= this.selectedTabIndex then
			(
				this.rollMain.tbSettingsCategories.SelectedTabPage = this.rollMain.tbSettingsCategories.tabPages.item[this.selectedTabIndex - 1]
			)

			this.updateRendererTabsColor() --actualiza los colores de los tabs
			
			this.addTabRollouts()			
		),

		------------------------------------------------
		--@fn: undefined | removeAllTabRollouts | Elimina todos los subrollouts actuales
		------------------------------------------------
		fn removeAllTabRollouts =
		(
			--elimina los subRollouts actuales
			while this.subRolloutsContainer.rollouts.count != 0 do RemoveSubRollout this.subRolloutsContainer this.subRolloutsContainer.rollouts[1]
		),

		------------------------------------------------
		--@fn: undefined | addTabRollouts | Añade los rollouts del tab del motor de render elegido
		------------------------------------------------
		fn addTabRollouts =
		(
			--elimina los subRollouts actuales
			this.removeAllTabRollouts()

			_subrolloutsToUse = this.rollsByTab[this.rollMain.tbSettingsCategories.SelectedTabPageIndex + 1]
			_subrolloutsToUseRolledUp = this.rolloutsRolledUp[this.rollMain.tbSettingsCategories.SelectedTabPageIndex + 1]
			
			--añade los subRollouts
			for i=1 to _subrolloutsToUse.count do AddSubRollout this.subRolloutsContainer _subrolloutsToUse[i] rolledUp:_subrolloutsToUseRolledUp[i]
		),

		------------------------------------------------
		--@fn: undefined | edit | Muestra el dialogo de edicion del override.
		--@opt: Point2 | pos | [0,0] | Posicion en la que aparecera el rollout de edicion del override.
		------------------------------------------------
		fn edit pos:[0,0] =
		(
			this.createEditBackup() --crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello 			
			
			lb.passManager.setCurrentEditInstance this
			
			_size = [350, 600]			
			_pos = pos - (_size/2)
			
			createDialog this.rollMain lockwidth:true lockheight:false pos:_pos width:_size.x height:_size.y modal:true style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
			this.infoNodeCA.selectedEffects = #()
			this.infoNodeCA.selectedAtmospherics = #()

			--Aprovechamos el viaje y los desactivamos
			for i=1 to numEffects do setActive(getEffect i) false
			for i=1 to numAtmospherics do setActive (getAtmospheric i) false
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
				if (lb.customAttributes.hasAttribute this.infoNode #overrideEnvironmentAndEffectsInfo) then
				(
					this.infoNodeCA = this.infoNode.custAttributes[#overrideEnvironmentAndEffectsInfo] --Rellena la variable de atajo para usarla de forma más cómoda
				)
				else
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false
					this.infoNodeCA = this.infoNode.custAttributes[#overrideEnvironmentAndEffectsInfo] --Rellena la variable de atajo para usarla de forma más cómoda

					this.storeSceneValues()					
				)--if else			
				
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
		
	)--str_overrideEnvironmentAndEffects
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideEnvironmentAndEffects --añade el override al listado de overrides disponibles
	
	ok
)