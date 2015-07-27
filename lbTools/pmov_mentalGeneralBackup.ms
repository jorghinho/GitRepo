------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de MentalGeneralBackup
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideMentalGeneralBackupInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideMentalGeneralBackupInfo = attributes overrideMentalGeneralBackupInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de MentalGeneralBackup."
				
			--informacion específica del override
			type		type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType		type:#string	default:"mentalGeneralBackup" --(lb.overrides.getFileOverrideName (getThisScriptFilename() as string))	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--Parámetros de backup
			
			stored	type:#boolean default:false --@var | stored | Indica si se ha llegado a hacer backup alguna vez de las propiedades  del motor de render
			
			------------------------------------------------

			------------------------------------------------
			--propiedades del motor de render mental ray
				
			_filter	type:#integer	default:0
			_view	type:#boolean	default:true
			_smooth	type:#boolean	default:true
			_MinimumSamples	type:#integer	default:-1
			_MaximumSamples	type:#integer	default:1
			_UnifiedEnable	type:#boolean	default:true
			_UnifiedQuality	type:#float	default:0.25
			_UnifiedMinSamples	type:#float	default:1.0
			_UnifiedMaxSamples	type:#integer	default:128
			_RedSpatialContrast	type:#float	default:0.0509804
			_GreenSpatialContrast	type:#float	default:0.0509804
			_BlueSpatialContrast	type:#float	default:0.0509804
			_AlphaSpatialContrast	type:#float	default:0.05
			_TimeSamples	type:#integer	default:5
			_BoxFilterWidth	type:#float	default:1.0
			_BoxFilterHeight	type:#float	default:1.0
			_GaussFilterWidth	type:#float	default:3.0
			_GaussFilterHeight	type:#float	default:3.0
			_TriangleFilterWidth	type:#float	default:2.0
			_TriangleFilterHeight	type:#float	default:2.0
			_MitchellFilterWidth	type:#float	default:4.0
			_MitchellFilterHeight	type:#float	default:4.0
			_LanczosFilterWidth	type:#float	default:4.0
			_LanczosFilterHeight	type:#float	default:4.0
			_Jitter	type:#boolean	default:true
			_LockSamples	type:#boolean	default:true
			_TaskSizeAuto type:#boolean	default:true
			_TaskSize	type:#integer	default:48
			_TaskOrder	type:#integer	default:0
			_FrameBufferType	type:#integer	default:0
			_ScanlineEnable	type:#boolean	default:true
			_RaytraceEnable	type:#boolean	default:true
			_ReflectionsEnable	type:#boolean	default:true
			_MaximumReflections	type:#integer	default:4
			_RefractionsEnable	type:#boolean	default:true
			_MaximumRefractions	type:#integer	default:6
			_MaximumTraceDepth	type:#integer	default:6
			_ScanlineMethod	type:#integer	default:0
			_Autovolume	type:#boolean	default:false
			_RapidCollectRate	type:#integer	default:4
			_RapidMotionResample	type:#integer	default:1
			_RapidShadingSamples	type:#float	default:2.0
			_BarycentricClipLimitMultiplier	type:#float	default:1.0
			_ShadowsEnable	type:#boolean	default:true
			_ShadowMethod	type:#integer	default:0
			_UseShadowMapFile	type:#boolean	default:false
			_ShadowMapRebuild	type:#boolean	default:true
			_ShadowMapFilename	type:#string	default:""
			_MotionBlurShadowMapsEnable	type:#boolean	default:true
			_EnableShadowMaps	type:#boolean	default:true
			_DepthOfFieldEnable	type:#boolean	default:false
			_FocusPlane	type:#float	default:100.0
			_DepthOfFieldMode	type:#integer	default:0
			_fStop	type:#float	default:1.0
			_NearFocus	type:#float	default:90.0
			_FarFocus	type:#float	default:110.0
			_MotionBlurEnable	type:#boolean	default:false
			_Shutter	type:#float	default:0.5
			_MotionBlurOffset	type:#float	default:-0.25
			_Segments	type:#integer	default:1
			_MotionBlurAllObjects	type:#boolean	default:true
			_CausticsEnable	type:#boolean	default:false
			_CausticAccuracy	type:#integer	default:100
			_UseCausticRadius	type:#boolean	default:false
			_CausticRadius	type:#float	default:1.0
			_CausticsFilter	type:#integer	default:0
			_Kernel	type:#float	default:1.1
			_CausticOpaqueShadows	type:#boolean	default:true
			_GlobalIllumEnable	type:#boolean	default:false
			_GlobalIllumAccuracy	type:#integer	default:500
			_UseGlobalIllumRadius	type:#boolean	default:false
			_GlobalIllumRadius	type:#float	default:1.0
			_GIPhotonMergeDistance	type:#float	default:0.0
			_VolumeAccuracy	type:#integer	default:100
			_UseVolumeRadius	type:#boolean	default:false
			_VolumeRadius	type:#float	default:1.0
			_CausticMultiplierScalar	type:#float	default:1.0
			_CausticMultiplierColor	type:#color	default:(color 255 255 255)
			_GIMultiplierScalar	type:#float	default:1.0
			_GIMultiplierColor	type:#color	default:(color 255 255 255)
			_IBLEnable	type:#boolean	default:true
			_IBLQuality	type:#float	default:0.5
			_IBLLighting	type:#integer	default:1
			_IBLShadows	type:#integer	default:0
			_FinalGatherEnable2	type:#boolean	default:true
			_UseFinalGatherFile	type:#boolean	default:false
			_FinalGatherFreeze	type:#boolean	default:false
			_FinalGatherPreview	type:#boolean	default:false
			_FinalGatherFalloff	type:#boolean	default:false
			_FinalGatherUseRadiusInterpolation	type:#boolean	default:false
			_UseFinalGatherRadius	type:#boolean	default:false
			_UseFinalGatherMinRadius	type:#boolean	default:false
			_FinalGatherView	type:#boolean	default:true
			_FinalGatherAccuracy	type:#integer	default:30
			_FinalGatherInterpolationSamples	type:#integer	default:50
			_FinalGatherBounces	type:#integer	default:0
			_FinalGatherFilter	type:#integer	default:1
			_FinalGatherTraceDepth	type:#integer	default:5
			_FinalGatherReflectionDepth	type:#integer	default:2
			_FinalGatherRefractionDepth	type:#integer	default:5
			_FinalGatherDensity	type:#float	default:0.1
			_FinalGatherBounceMultiplier	type:#float	default:1.0
			_FinalGatherFalloffStart	type:#float	default:0.0
			_FinalGatherFalloffStop	type:#float	default:0.0
			_FinalGatherRadius	type:#float	default:1.0
			_FinalGatherRadius_View	type:#float	default:5.0
			_FinalGatherMinRadius	type:#float	default:0.1
			_FinalGatherMinRadius_View	type:#float	default:0.5
			_FGMultiplierScalar	type:#float	default:1.0
			_FGMultiplierColor	type:#color	default:(color 255 255 255)
			_FinalGatherFilename	type:#string	default:""
			_FinalGatherTempFilename	type:#string	default:""
			_PhotonMapUseFile	type:#boolean	default:false
			_PhotonMapFilename	type:#string	default:""
			_GIMaximumReflections	type:#integer	default:10
			_GIMaximumRefractions	type:#integer	default:10
			_GIMaximumTraceDepth	type:#integer	default:10
			_OverrideIIObjProps	type:#boolean	default:false
			_GlobalLightDecay	type:#float	default:2.0
			_GlobalLightCausticPhotons	type:#integer	default:20000
			_GlobalLightGIPhotons	type:#integer	default:20000
			_FinalGatherOnly	type:#boolean	default:false
			_PhotonFreeze	type:#boolean	default:false
			_PhotonsOnly	type:#boolean	default:false
			_FGInterpolateNFrames	type:#integer	default:2
			_IlluminationCacheMode	type:#integer	default:0
			_SkipFinalRender	type:#boolean	default:false
			_RaytraceMethod	type:#integer	default:0
			_BSPSize	type:#integer	default:10
			_BSPDepth	type:#integer	default:40
			_DistributedEnable	type:#boolean	default:false
			_LocalBitmaps	type:#boolean	default:false
			_SlavesOnly	type:#boolean	default:false
			_DiagnosticGridMethod	type:#integer	default:0
			_DiagnosticGridSize	type:#float	default:1.0
			_DiagnosticPhotonMethod	type:#integer	default:0
			_DiagnosticBSPMethod	type:#integer	default:0
			_DiagnosticsEnabled	type:#boolean	default:false
			_DiagnosticMode	type:#integer	default:0
			_Use_Placeholders	type:#boolean	default:false
			_Memory_Limit	type:#integer	default:650
			_Memory_Limit_Auto	type:#boolean	default:true
			_Export_On_Render	type:#boolean	default:false
			_Incremental_Echo	type:#boolean	default:false
			_Export_Filename	type:#string	default:""
			_Conserve_Memory	type:#boolean	default:false
			_mental_ray_Manages_Maps	type:#boolean	default:false
			_Skip_Texture_Maps	type:#boolean	default:false
			_Export_ASCII	type:#boolean	default:true
			_Edge_Length	type:#float	default:2.0
			_Max_Level	type:#integer	default:6
			_Max_Displace	type:#float	default:20.0
			_EnableContours	type:#boolean	default:false
			_Enable_Material_Override	type:#boolean	default:false
			_Override_Material	type:#maxObject
			_Contour_Contrast_Shader	type:#maxObject
			_Contour_Store_Shader	type:#maxObject
			_Contour_Output_Shader	type:#maxObject
			_Camera_Lens_Shader	type:#maxObject
			_Camera_Output_Shader	type:#maxObject
			_Camera_Volume_Shader	type:#maxObject
			_Enable_Camera_Lens_Shader	type:#boolean	default:true
			_Enable_Camera_Output_Shader	type:#boolean	default:false
			_Enable_Camera_Volume_Shader	type:#boolean	default:true
			_Enable_Subset_Pixel_Rendering	type:#boolean	default:false
			_glossyreflectionsprecision	type:#float	default:1.0
			_glossyrefractionsprecision	type:#float	default:1.0
			_softshadowsprecision	type:#float	default:1.0
			_LockGeometryCache	type:#boolean	default:false
			_EnableGeometryCache	type:#boolean	default:false
			_IsGeometryCacheEmpty	type:#boolean	default:true
			_LastTotalNonRenderTime_ms	type:#integer	default:0
			_LastTotalGeomTranslationTime_ms	type:#integer	default:0
			_FGProjectionMode	type:#integer	default:0
			_FGProjectionModeNumSegments	type:#integer	default:9
			_numFinalGatherPresets	type:#integer	default:6
			
			------------------------------------------------
						
			------------------------------------------------
			--Parámetros de apply

			sampleParam	type:#boolean	default:false --@var | sampleParam | Parametro de ejemplo.

			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | UI para modificar los parametros del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "MentalGeneralBackup Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var : editCA | Almacena el custom attribute de edición
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
			
		checkBox chkSampleParam "Sample Param" pos:[5,5] checked:false --@control | chkSampleParam| Idica si salver el render o no.
		
		button btnOk "OK" pos:[5,25] width:95 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[100,25] width:95 --@control | btnCancel | Cancela los cambios y cierra.
		
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
			chkSampleParam.checked = parent.editBackupNode.custAttributes[#overrideMentalGeneralBackupInfo].sampleParam			
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
		--@event: changed | Evento que se lanza al cambiar el valor del checkbox.
		--@control: checkbox | chkSampleParam | Checkbox cuyo estado cambia.
		--@gets: boolean| state | Nuevo estado del checkbox.
		------------------------------------------------
		on chkSampleParam changed state do
		(
			editCA.sampleParam = state
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
			editCA = parent.editBackupNode.custAttributes[#overrideMentalGeneralBackupInfo]
			
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
	--@struct: overrideMentalGeneralBackup | Contiene todas las funciones de un override de MentalGeneralBackup.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideMentalGeneralBackup
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
		infoNodeCA,							--@var | infoNodeCA | Variable que almacena el custom attribute de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideMentalGeneralBackupInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideMentalGeneralBackupInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			infoNodeCA.type
		),
			
		------------------------------------------------
		--@fn: string | getSubType | Devuelve el subtipo del override.
		------------------------------------------------
		fn getSubType =
		(
			infoNodeCA.subType
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
			infoNodeCA.sampleParam as string
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
				if backupNode.custAttributes[#overrideMentalGeneralBackupInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				--solo si el motor de render activo es mental ray
				if classof renderers.current == mental_ray_renderer then
				(
					--hace global de forma temporal el CA del nodo de backup para poder accader a el
					global _tempBackupCA = backupNode.custAttributes[#overrideMentalGeneralBackupInfo]
					
					_rendererProps = getPropNames renderers.current --obtiene las propiedades del render
					_executeString = "" --string para ejecutar					
					
					--prepara un string para obtener todas las propiedades
					for _rp in _rendererProps do
						_executeString += ("_tempBackupCA._" + (_rp as string) + " = getProperty renderers.current #" + (_rp as string)) + "\n"
					
					execute _executeString
					backupNode.custAttributes[#overrideMentalGeneralBackupInfo].stored = true
					
					_tempBackupCA = undefined
						
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
			
			--solo si se ha pasado un nodo de backup
			if isValidNode backupNode then
			(	
				--si tiene backup de este tipo de override
				if backupNode.custAttributes[#overrideMentalGeneralBackupInfo] != undefined then
				(
					--solo si el motor de render activo es mental ray
					if classof renderers.current == mental_ray_renderer and backupNode.custAttributes[#overrideMentalGeneralBackupInfo].stored then
					(				
						--hace global de forma temporal el CA del nodo de backup para poder accader a el
						global _tempBackupCA = backupNode.custAttributes[#overrideMentalGeneralBackupInfo]
						
						_rendererProps = getPropNames renderers.current --obtiene las propiedades del render
						_executeString = "" --string para ejecutar
						
						--prepara un string para obtener todas las propiedades
						for _rp in _rendererProps do
						(
							_restore = true
							
							--los siguientes casos son para propiedades que son readOnly, por lo tanto no se pueden modificar, solo consultar
							case _rp of
							(
								#IsGeometryCacheEmpty : _restore = false
								#LastTotalNonRenderTime_ms : _restore = false
								#LastTotalGeomTranslationTime_ms : _restore = false
								#numFinalGatherPresets : _restore = false
							)--case
							
							if _restore do _executeString += ("setProperty renderers.current #" + (_rp as string) + " _tempBackupCA._" + (_rp as string)) + "\n"
						)--for
								
						execute _executeString
						_success = true
						
						_tempBackupCA = undefined
					)
					else
					(
						if saveLogs then lb.log.add ("Mental ray is not the current renderer") sender:("override." + (this.getSubType())) type:#warning level:(logLevel + 1)
						_success = true --si el motor de render es otro, debe continuar
					)					
				)
				else
				(
					if saveLogs then lb.log.add ("Backup node with no custom attribute") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					_success = true --si el motor de render es otro, debe continuar
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
				
			_sampleParam = infoNodeCA.sampleParam
			
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
				if this.editBackupNode.custAttributes[#overrideMentalGeneralBackupInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (infoNodeCA)
						for _prop in _propNames do (setProperty (infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideMentalGeneralBackupInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideMentalGeneralBackupInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideMentalGeneralBackupInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (infoNodeCA)
						for _prop in _propNames do (setProperty (infoNodeCA) _prop (getProperty (infoNodeCA) _prop))
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
			
			_size = [200,50]
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
			--ESTE ES UN OVERRIDE ESPECIAL Y NO HACE FALTA
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideMentalGeneralBackupInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					infoNodeCA = this.infoNode.custAttributes[#overrideMentalGeneralBackupInfo]

					this.storeSceneValues()				
				)--if			
				
				--Almacenamos el atributo de apply en una variable
				infoNodeCA = this.infoNode.custAttributes[#overrideMentalGeneralBackupInfo]
				
				this.purge() --primero mira si hay cambios en la escena que afecten al override y lo limpia
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
		
	)--str_overrideMentalGeneralBackup
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideMentalGeneralBackup --añade el override al listado de overrides disponibles
	
	ok
)