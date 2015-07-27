------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de overrideMentalRenderingAlgorithms
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute:overrideMentalRenderingAlgorithmsInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideMentalRenderingAlgorithmsInfo = attributes overrideMentalRenderingAlgorithmsInfo   
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de MentalRenderingAlgorithms."
			
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"mentalRenderingAlogrithms" --@var | subType | Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--Parámetros de backup 
			
			------------------------------------------------
			--Parámetros de backup y apply
			ScanlineEnable 		type:#boolean 	default:false 	--@var | ScanlineEnable | Precisión de las sombras
			ScanlineMethod 		type:#integer 	default:0	 	--@var | ScanlineMethod | Parámetro de glossy reflection
			RapidCollectRate  	type:#integer 	default:4 		--@var | RapidCollectRate | Parámetro de glossy refraction
			RapidShadingSamples type:#float 	default:2.0 	--@var | RapidShadingSamples | Parámetro de glossy refraction
			RaytraceEnable  	type:#boolean 	default:true 	--@var | RaytraceEnable | Parámetro de glossy refraction
			Autovolume  		type:#boolean 	default:false 	--@var | Autovolume | Parámetro de glossy refraction
			RaytraceMethod  	type:#float 	default:0.0 	--@var | RaytraceMethod | Parámetro de glossy refraction
			BSPSize    			type:#float 	default:0.0 	--@var | BSPSize | Parámetro de glossy refraction
			BSPDepth   			type:#float 	default:0.0 	--@var | BSPDepth | Parámetro de glossy refraction
			MaximumTraceDepth 	type:#integer 	default:6		--@var | MaximumTraceDepth | Parámetro de glossy refraction
			MaximumReflections 	type:#integer 	default:4 		--@var | MaximumReflections | Parámetro de glossy refraction
			MaximumRefractions 	type:#integer 	default:6 		--@var | MaximumRefractions | Parámetro de glossy refraction
			ReflectionsEnable 	type:#boolean 	default:true 	--@var | ReflectionsEnable | Parámetro de glossy refraction
			RefractionsEnable 	type:#boolean 	default:true 	--@var | RefractionsEnable | Parámetro de glossy refraction
			ShadowMethod		type:#integer 	default:0 	--@var | ShadowMethod | Parámetro Shadow Mode
			enable_subset_pixel_rendering 	type:#boolean 	default:false 	--@var | RefractionsEnable | Parámetro de glossy refraction
			
			------------------------------------------------
			--Parámetros de apply
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Rendering Algorithms Override" width:325 height:460
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = false --@var : editCA | Almacena el custom attribute de edición.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		GroupBox grpScanline "Scanline" pos:[5,5] width:315 height:160
		checkbox chkScanlineEnable "Enable" pos:[15,25] width:155 height:20
		checkbox chkUseFastRasterizer "Use Fast Rasterizer (Rapid Motion Blur)" pos:[15,45] width:215 height:20
		label lblSamplesPerPixel "Samples per Pixel" pos:[35,70] width:90 height:15 enabled:true
		dropdownList ddlSamplesPerPixel "" pos:[130,65] width:80 height:21 items:#("1", "4", "9", "16", "25", "36", "49", "64", "81", "100", "121", "144", "169", "196", "225")
		label lblShadesPerPixel "Shades per Pixel:" pos:[35,92] width:90 height:15 enabled:true
		spinner spnShadesPerPixel "" pos:[130,90] width:60 height:16 range:[0.1,10000,2.0] type:#float scale:1
		label lblAdvertise "The min/max samples and contrast parameters, from the Sampling Quality rollout, are ignored when using Fast Rasterizer." pos:[40,115] width:255 height:40 style_sunkenedge:true
				
		GroupBox grpRayTracing "Ray Tracing" pos:[5,170] width:315 height:255
		checkbox chkRaytraceEnable "Enable" pos:[15,190] width:125 height:20
		checkbox chkAutovolume "Use Autovolume" pos:[15,210] width:125 height:20
		GroupBox grpRaytraceAceleration "Raytrace Aceleration" pos:[10,230] width:305 height:90
		label lblRaytraceAcelerationMethod "Method:" pos:[25,250] width:55 height:15
		dropdownList ddlRaytraceAcelerationMethod "" pos:[85,245] width:80 height:21 items:#("BSP", "BSP2") selection:2
			
		label lblBSPsize "Size:" pos:[25,270] width:40 height:15
		spinner spnBSPdepht "" pos:[85,290] width:60 height:16 range:[1,1e+007,10] type:#integer
		label lblBSPdepth "Depth:" pos:[25,290] width:40 height:15
		spinner spnBSPsize "" pos:[85,270] width:60 height:16 range:[1,1e+007,10] type:#integer
			
		GroupBox grpReflectionsRefractions "Reflections / Refractions" pos:[10,325] width:305 height:90
		checkbox chkReflectionsEnable "Enable Reflections" pos:[20,365] width:115 height:20
		checkbox chkRefractionsEnable "EnableRefractions" pos:[20,385] width:115 height:20
		spinner spnMaxTraceDepth "Max. Trace Depth:" pos:[160,345] width:145 height:16 range:[0,100000,6] type:#integer fieldwidth:50
		spinner spnMaximumReflections "Max. Reflections:" pos:[170,365] width:135 height:16 range:[0,100000,4] type:#integer fieldwidth:50
		spinner spnMaxRefractions "Max. Refractions" pos:[170,385] width:135 height:16 range:[0,100000,6] type:#integer fieldwidth:50
		
		button btnOk "Ok" pos:[5,430] width:155 height:25
		button btnCancel "Cancel" pos:[165,430] width:155 height:25
		
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
			chkScanlineEnable.checked = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ScanlineEnable
			chkUseFastRasterizer.checked = if parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ScanlineMethod == 1 then true else false
			ddlSamplesPerPixel.selection = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RapidCollectRate -- + 1
			spnShadesPerPixel.value = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RapidShadingSamples
			
			chkRaytraceEnable.checked = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RaytraceEnable
			chkAutovolume.checked = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].Autovolume
			ddlRaytraceAcelerationMethod.selection = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RaytraceMethod + 1
			spnBSPsize.value = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].BSPSize; spnBSPsize.visible = (ddlRaytraceAcelerationMethod.selection == 1)
			spnBSPdepht.value = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].BSPDepth; spnBSPdepht.visible = (ddlRaytraceAcelerationMethod.selection == 1)
			
			chkReflectionsEnable.checked = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ReflectionsEnable
			chkRefractionsEnable.checked = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RefractionsEnable
			spnMaxTraceDepth.value = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumTraceDepth
			spnMaximumReflections.value = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumReflections
			spnMaxRefractions.value = parent.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumRefractions
			
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
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn refreshUI =
		(
			-- Grupo Scanline
			_scanlineEnabled = chkScanlineEnable.checked
			chkUseFastRasterizer.enabled = _scanlineEnabled
			ddlSamplesPerPixel.enabled = spnShadesPerPixel.enabled = lblAdvertise.enabled = (_scanlineEnabled and chkUseFastRasterizer.checked)
			lblSamplesPerPixel.enabled = lblShadesPerPixel.enabled =  (_scanlineEnabled and chkUseFastRasterizer.checked)
			
			-- Grupo dependiente de Use Fast Rasterizer
			lblBSPdepth.visible = lblBSPsize.visible = spnBSPdepht.visible = spnBSPsize.visible = (ddlRaytraceAcelerationMethod.selection == 1)
			
			-- Grupo Ray Tracing
			_raytraceEnabled = chkRaytraceEnable.checked
			chkAutovolume.enabled = grpRaytraceAceleration.enabled = ddlRaytraceAcelerationMethod.enabled = _raytraceEnabled
			lblRaytraceAcelerationMethod.enabled = lblBSPdepth.enabled = lblBSPsize.enabled = _raytraceEnabled
			spnBSPdepht.enabled = spnBSPsize.enabled = _raytraceEnabled
			grpReflectionsRefractions.enabled = chkReflectionsEnable.enabled = chkRefractionsEnable.enabled = _raytraceEnabled
			spnMaxTraceDepth.enabled = _raytraceEnabled
			spnMaximumReflections.enabled = (_raytraceEnabled and chkReflectionsEnable.checked)
			spnMaxRefractions.enabled = (_raytraceEnabled and chkRefractionsEnable.checked)
		)
		
		------------------------------------------------
		--@fn: undefined | setAutovolumeState | Activar el Autovolume necesita activar y desactivar otras opciones. Ésta función las comprueba y activa si se accede a ello.
		------------------------------------------------
		fn setAutovolumeState state =
		(
			_setAutovolume = false
			_message = if state == #enabled then 
							"Autovolume requires the following options:\n\nscanline off\nraytracing on\nshadowmode: segments\n\nContinue and enable these options automatically?"
						else
							"This will disable Autovolume. Are you sure you want to continue?"
			
			if (queryBox _message) then
			(
				case state of
				(
					#enabled:
					(
						chkScanlineEnable.checked = editCA.ScanlineEnable = false
						chkRaytraceEnable.checked = editCA.RaytraceEnable = true
						editCA.ShadowMethod = 2
					)
					
					#disabled:
					(
						chkAutovolume.checked = editCA.Autovolume = false
					)
				)
				
				_setAutovolume = true
			)
			
			_setAutovolume
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el checkbox.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Scanline Enable
		------------------------------------------------
		on chkScanlineEnable changed val do
		(
			if val and (editCA.Autovolume) and not (setAutovolumeState #disabled) then
				chkScanlineEnable.checked = false
			else
			(
				editCA.ScanlineEnable = val
				refreshUI()
			)
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el checkbox.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Use Fast Rasterizer
		------------------------------------------------
		on chkUseFastRasterizer changed val do
		(
			editCA.ScanlineMethod = if chkUseFastRasterizer.checked then 1 else 0
			refreshUI()
		)
				
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el dropdown.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Samples Per Pixel
		------------------------------------------------
		on ddlSamplesPerPixel selected val do
			editCA.RapidCollectRate = ddlSamplesPerPixel.selection -- - 1
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Shades Per Pixel
		------------------------------------------------
		on spnShadesPerPixel changed val do
			editCA.RapidShadingSamples = spnShadesPerPixel.value
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el checkbox.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Raytrace Enable
		------------------------------------------------
		on chkRaytraceEnable changed val do
		(
			if not val and (editCA.Autovolume) and not (setAutovolumeState #disabled) then
				chkScanlineEnable.checked = false
			else
			(
				editCA.RaytraceEnable = chkRaytraceEnable.checked
				refreshUI()
			)
			
			refreshUI()
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el checkbox.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Autovolume
		------------------------------------------------
		on chkAutovolume changed val do
		(
			if val and ((editCA.ScanlineEnable) or (parent.editBackupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ShadowMethod != 2)) and not (setAutovolumeState #enabled) then
				chkAutovolume.checked = false
			else
				editCA.Autovolume = chkAutovolume.checked
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el dropdown.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Dropdown Raytrace Aceleration Method
		------------------------------------------------
		on ddlRaytraceAcelerationMethod selected val do
		(
			_val = ddlRaytraceAcelerationMethod.selection - 1
			if _val > 0 then _val = 4
			editCA.RaytraceMethod = _val
			refreshUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: spinner | spnBSPdepht | BSP depth
		------------------------------------------------
		on spnBSPdepht changed val do
			editCA.BSPDepth = spnBSPdepht.value
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: spinner | spnBSPsize | BSP size
		------------------------------------------------
		on spnBSPsize changed val do
			editCA.BSPSize = spnBSPsize.value
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el checkbox
		--@control: dropdownlist | ddlSoftShadowsPrecision | Reflections Enable
		------------------------------------------------
		on chkReflectionsEnable changed val do
		(
			editCA.ReflectionsEnable = chkReflectionsEnable.checked
			refreshUI()
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el checkbox.
		--@control: dropdownlist | ddlSoftShadowsPrecision | Refractions Enable
		------------------------------------------------
		on chkRefractionsEnable changed val do
		(
			editCA.RefractionsEnable = chkRefractionsEnable.checked
			refreshUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: spinner | spnMaxTraceDepth | Maximum Trace Depht
		------------------------------------------------
		on spnMaxTraceDepth changed val do
			editCA.MaximumTraceDepth = spnMaxTraceDepth.value
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: spinner | spnMaximumReflections | Maximum Reflections
		------------------------------------------------
		on spnMaximumReflections changed val do
			editCA.MaximumReflections = spnMaximumReflections.value
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: spinner | spnMaxRefractions | Maximum Refractions
		------------------------------------------------
		on spnMaxRefractions changed val do
			editCA.MaximumRefractions = spnMaxRefractions.value
		
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
			editCA = parent.editBackupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo]

			loadOverrideInfo()
			loadSettings()
			refreshUI()
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
	struct str_overrideMentalRenderingAlgorithms
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
		infoNodeCA,						--@var | infoNodeCA | Variable que almacena el custom attribute de apply.
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideMentalRenderingAlgorithmsInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideMentalRenderingAlgorithmsInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			"Scanline: " + (this.infoNodeCA.ScanlineEnable As String) + ", " \
			+ "Raytrace: " + (this.infoNodeCA.RaytraceEnable As String)
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
				if backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				if (classof renderers.current) == mental_ray_renderer then
				(				
					--	Guardamos ahora todos los parámetros
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ScanlineEnable = renderers.current.scanlineEnable
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ScanlineMethod = renderers.current.ScanlineMethod
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RapidCollectRate = renderers.current.RapidCollectRate
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RapidShadingSamples = renderers.current.RapidShadingSamples
					
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RaytraceEnable = renderers.current.RaytraceEnable
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].Autovolume = renderers.current.Autovolume
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RaytraceMethod = renderers.current.RaytraceMethod
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].BSPSize = renderers.current.BSPSize
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].BSPDepth = renderers.current.BSPDepth
					
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ReflectionsEnable = renderers.current.ReflectionsEnable
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RefractionsEnable = renderers.current.RefractionsEnable
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumTraceDepth = renderers.current.MaximumTraceDepth
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumReflections = renderers.current.MaximumReflections
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumRefractions = renderers.current.MaximumRefractions
					
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].enable_subset_pixel_rendering = renderers.current.enable_subset_pixel_rendering
					
					backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ShadowMethod = renderers.current.ShadowMethod
					
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
				if saveLogs then lb.log.add ("Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
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
				if backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo] != undefined then
				(
					if (classof renderers.current) == mental_ray_renderer then
					(					
						--Restauramos todos los parámetros
						renderers.current.ScanlineEnable = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ScanlineEnable
						renderers.current.ScanlineMethod = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ScanlineMethod
						renderers.current.RapidCollectRate = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RapidCollectRate
						renderers.current.RapidShadingSamples = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RapidShadingSamples
						
						renderers.current.RaytraceEnable = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RaytraceEnable
						renderers.current.Autovolume = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].Autovolume
						renderers.current.RaytraceMethod = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RaytraceMethod
						renderers.current.BSPSize = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].BSPSize
						renderers.current.BSPDepth = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].BSPDepth
						
						renderers.current.ReflectionsEnable = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ReflectionsEnable
						renderers.current.RefractionsEnable = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].RefractionsEnable
						renderers.current.MaximumTraceDepth = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumTraceDepth
						renderers.current.MaximumReflections = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumReflections
						renderers.current.MaximumRefractions = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].MaximumRefractions
						
						renderers.current.enable_subset_pixel_rendering = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].enable_subset_pixel_rendering
						
						renderers.current.ShadowMethod = backupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo].ShadowMethod
						
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
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			if (classof renderers.current) == mental_ray_renderer then
			(
				
				renderers.current.ScanlineEnable = this.infoNodeCA.ScanlineEnable
				renderers.current.ScanlineMethod = this.infoNodeCA.ScanlineMethod
				renderers.current.RapidCollectRate = this.infoNodeCA.RapidCollectRate
				renderers.current.RapidShadingSamples = this.infoNodeCA.RapidShadingSamples
				
				renderers.current.RaytraceEnable = this.infoNodeCA.RaytraceEnable
				renderers.current.Autovolume = this.infoNodeCA.Autovolume
				renderers.current.RaytraceMethod = this.infoNodeCA.RaytraceMethod
				renderers.current.BSPSize = this.infoNodeCA.BSPSize
				renderers.current.BSPDepth = this.infoNodeCA.BSPDepth
				
				renderers.current.ReflectionsEnable = this.infoNodeCA.ReflectionsEnable
				renderers.current.RefractionsEnable = this.infoNodeCA.RefractionsEnable
				renderers.current.MaximumTraceDepth = this.infoNodeCA.MaximumTraceDepth
				renderers.current.MaximumReflections = this.infoNodeCA.MaximumReflections
				renderers.current.MaximumRefractions = this.infoNodeCA.MaximumRefractions
				
				renderers.current.enable_subset_pixel_rendering = this.infoNodeCA.enable_subset_pixel_rendering
				
				--ésta propiedad sólo la aplicamos si está activado el Autovolume. No pertenece realmente al override
 				renderers.current.ShadowMethod = if renderers.current.Autovolume then this.infoNodeCA.ShadowMethod else 0
				
				_success = true
			)
			else
			(
				if saveLogs then lb.log.add ("Mental ray is not the current renderer") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)	
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"APPLY process error. Mental Ray is not the current renderer.")
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
				if this.editBackupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo] != undefined then
				(
					undo "Rendering Algorithms Override Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [this.rollMain.width, this.rollMain.height]
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
			this.infoNodeCA.ScanlineEnable = _renderer.scanlineEnable
			this.infoNodeCA.ScanlineMethod = _renderer.ScanlineMethod
			this.infoNodeCA.RapidCollectRate = _renderer.RapidCollectRate
			this.infoNodeCA.RapidShadingSamples = _renderer.RapidShadingSamples
			
			this.infoNodeCA.RaytraceEnable = _renderer.RaytraceEnable
			this.infoNodeCA.Autovolume = _renderer.Autovolume
			this.infoNodeCA.RaytraceMethod = _renderer.RaytraceMethod
			this.infoNodeCA.BSPSize = _renderer.BSPSize
			this.infoNodeCA.BSPDepth = _renderer.BSPDepth
			
			this.infoNodeCA.ReflectionsEnable = _renderer.ReflectionsEnable
			this.infoNodeCA.RefractionsEnable = _renderer.RefractionsEnable
			this.infoNodeCA.MaximumTraceDepth = _renderer.MaximumTraceDepth
			this.infoNodeCA.MaximumReflections = _renderer.MaximumReflections
			this.infoNodeCA.MaximumRefractions = _renderer.MaximumRefractions
			
			this.infoNodeCA.enable_subset_pixel_rendering = _renderer.enable_subset_pixel_rendering
			this.infoNodeCA.ShadowMethod = if _renderer.Autovolume then this.infoNodeCA.ShadowMethod else 0
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideMentalRenderingAlgorithmsInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo]

					this.storeSceneValues()					
				)
				
				--Rellenamos la variable infoNodeCA con el customAttribute de apply
				this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalRenderingAlgorithmsInfo]
				
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
		
	)--str_overrideGBuffer
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideMentalRenderingAlgorithms --añade el override al listado de overrides disponibles
	
	ok
)