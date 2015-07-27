------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. Rendering Algorithms
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalRenderingAlgorithmsDef | Rollout de Rendering Algorithms de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalRenderingAlgorithmsDef "Rendering Algorithms"
(
	------------------------------------------------------------------------------------------------
	--COMMON
	------------------------------------------------------------------------------------------------
	
	local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento.
	
	local editCA = undefined --@var : editCA| Variable de atajo para el CA de edit.

	------------------------------------------------------------------------------------------------
	--VARIABLES
	------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------
	--CONTROLS
	------------------------------------------------------------------------------------------------
	
	--override active
	checkbox chkOverrideMentalRenderingAlgorithms "override" pos:[5,5] checked:false --@control | chkOverrideMentalRenderingAlgorithms | Indica si hacer override de esos parametros.

	GroupBox grpScanline "Scanline" pos:[5,25] width:327 height:150
	checkbox chkScanlineEnable "Enable" pos:[13,45] width:155 height:20
	checkbox chkUseFastRasterizer "Use Fast Rasterizer (Rapid Motion Blur)" pos:[13,65] width:215 height:20
	label lblSamplesPerPixel "Samples per Pixel" pos:[31,90] width:90 height:15 enabled:true
	dropdownList ddlSamplesPerPixel "" pos:[125,85] width:60 height:21 items:#("1", "4", "9", "16", "25", "36", "49", "64", "81", "100", "121", "144", "169", "196", "225")
	label lblShadesPerPixel "Shades per Pixel:" pos:[31,112] width:90 height:15 enabled:true
	spinner spnShadesPerPixel "" pos:[125,110] width:60 height:16 range:[0.1,10000,2.0] type:#float scale:1
	label lblAdvertise "The min/max samples and contrast parameters, from the Sampling Quality rollout, are ignored when using Fast Rasterizer." pos:[10,135] width:315 height:33 style_sunkenedge:true
			
	GroupBox grpRayTracing "Ray Tracing" pos:[5,180] width:327 height:240
	checkbox chkRaytraceEnable "Enable" pos:[15,200] width:125 height:20
	checkbox chkAutovolume "Use Autovolume" pos:[15,220] width:125 height:20
	
	GroupBox grpRaytraceAceleration "Raytrace Aceleration" pos:[10,240] width:317 height:45
	label lblRaytraceAcelerationMethod "Method:" pos:[19,260] width:45 height:15
	dropdownList ddlRaytraceAcelerationMethod "" pos:[65,257] width:50 height:21 items:#("BSP", "BSP2") selection:2
	label lblBSPsize "Size:" pos:[125,260] width:25 height:15
	spinner spnBSPsize "" pos:[150,260] width:60 height:16 range:[1,1e+007,10] type:#integer
	label lblBSPdepth "Depth:" pos:[222,260] width:35 height:15
	spinner spnBSPdepht "" pos:[257,260] width:60 height:16 range:[1,1e+007,10] type:#integer
		
	GroupBox grpReflectionsRefractions "Reflections / Refractions" pos:[10,285] width:317 height:85
	checkbox chkReflectionsEnable "Enable Reflections" pos:[20,325] width:115 height:20
	checkbox chkRefractionsEnable "EnableRefractions" pos:[20,345] width:115 height:20
	spinner spnMaxTraceDepth "Max. Trace Depth:" pos:[172,305] width:145 height:16 range:[0,100000,6] type:#integer fieldwidth:50
	spinner spnMaximumReflections "Max. Reflections:" pos:[182,325] width:135 height:16 range:[0,100000,4] type:#integer fieldwidth:50
	spinner spnMaxRefractions "Max. Refractions:" pos:[182,345] width:135 height:16 range:[0,100000,6] type:#integer fieldwidth:50
	
	GroupBox grpSubsetPixelRendering "Subset Pixel Rendering" pos:[10,372] width:317 height:42
	checkbox chkSubsetPixelRendering "Render changes to selected objects only" pos:[20,390] width:250 height:20

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
					editCA.ScanlineEnable = false
					editCA.RaytraceEnable = true
					editCA.ShadowMethod = 2
				)--enabled
				
				#disabled:
				(
					editCA.Autovolume = false
					editCA.RaytraceEnable = true
				)--disabled
			)--case				

			_setAutovolume = true
		)--if
		
		_setAutovolume
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
	--@fn: undefined | updateUIControlsByOverrideEnabledState | habilita o deshabilita los controles del override en funcion de si está activo o no.
	------------------------------------------------
	fn updateUIControlsByOverrideEnabledState disableOnly:false =
	(
		if not disableOnly then --si esta en el modo en que se permite habilitar y desahbilitar
		(
			for _cntrl in rollMentalRenderingAlgorithmsDef.controls where _cntrl.name != "chkOverrideMentalRenderingAlgorithms" do _cntrl.enabled = editCA.overrideMentalRenderingAlgorithms
			chkOverrideMentalRenderingAlgorithms.checked = editCA.overrideMentalRenderingAlgorithms
		)
		else if not editCA.overrideMentalRenderingAlgorithms then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalRenderingAlgorithmsDef.controls where _cntrl.name != "chkOverrideMentalRenderingAlgorithms" do _cntrl.enabled = false
			chkOverrideMentalRenderingAlgorithms.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		------------------------------------------------
		--Grupo Scanline

		chkScanlineEnable.checked = editCA.ScanlineEnable
		chkUseFastRasterizer.enabled = editCA.ScanlineEnable

		chkUseFastRasterizer.checked = if editCA.ScanlineMethod == 1 then true else false
		
		lblSamplesPerPixel.enabled = lblShadesPerPixel.enabled =  (editCA.ScanlineEnable and chkUseFastRasterizer.checked)
		ddlSamplesPerPixel.enabled = spnShadesPerPixel.enabled = lblAdvertise.enabled = (editCA.ScanlineEnable and chkUseFastRasterizer.checked)

		ddlSamplesPerPixel.selection = editCA.RapidCollectRate
		spnShadesPerPixel.value = editCA.RapidShadingSamples
		------------------------------------------------
		
		------------------------------------------------
		--Grupo Raytrace

		chkRaytraceEnable.enabled = editCA.ScanlineEnable
		chkRaytraceEnable.checked = editCA.RaytraceEnable
		chkAutovolume.enabled = grpRaytraceAceleration.enabled = ddlRaytraceAcelerationMethod.enabled = editCA.RaytraceEnable
		chkAutovolume.checked = editCA.Autovolume

		ddlRaytraceAcelerationMethod.selection = editCA.RaytraceMethod + 1
		lblBSPsize.visible = spnBSPsize.visible = (editCA.RaytraceMethod == 0)
		lblBSPdepth.visible = spnBSPdepht.visible = (editCA.RaytraceMethod == 0)
		spnBSPdepht.enabled = spnBSPsize.enabled = editCA.RaytraceEnable
		spnBSPsize.value = editCA.BSPSize
		spnBSPdepht.value = editCA.BSPDepth
		
		grpReflectionsRefractions.enabled = chkReflectionsEnable.enabled = chkRefractionsEnable.enabled = editCA.RaytraceEnable
		spnMaxTraceDepth.enabled = editCA.RaytraceEnable
		chkReflectionsEnable.checked = editCA.ReflectionsEnable
		chkRefractionsEnable.checked = editCA.RefractionsEnable
		spnMaximumReflections.enabled = (editCA.RaytraceEnable and chkReflectionsEnable.checked)
		spnMaxRefractions.enabled = (editCA.RaytraceEnable and chkRefractionsEnable.checked)			
		spnMaxTraceDepth.value = editCA.MaximumTraceDepth
		spnMaximumReflections.value = editCA.MaximumReflections
		spnMaxRefractions.value = editCA.MaximumRefractions
		------------------------------------------------

		------------------------------------------------
		--Grupo Subset Pixel Rendering
		
		if ((parent.getParentContainer()).getCaption()) == "settings" then
		(
			chkSubsetPixelRendering.enabled = false
			chkSubsetPixelRendering.checked = false
		)
		else
		(
			chkSubsetPixelRendering.enabled = true
			chkSubsetPixelRendering.checked = editCA.enable_subset_pixel_rendering
		)
		
		
		
		------------------------------------------------
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalRenderingAlgorithms.checked = editCA.overrideMentalRenderingAlgorithms
		updateUIControlsByOverrideEnabledState()
		loadOverrideInfo()
		updateUIControlsByOverrideEnabledState disableOnly:true
	)

	------------------------------------------------
	--@fn: undefined | updateRelatedRollouts | Actualiza el estado de los controles de rollouts relacionados.
	------------------------------------------------
	fn updateRelatedRollouts =
	(
		parent.rollMentalSamplingQuality.updateUI()
		parent.rollMentalShadowsAndDisplacement.updateUI()
	)

	------------------------------------------------
	--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
	------------------------------------------------
	fn onCloseOperations =
	(
		--sin operaciones
	)

	------------------------------------------------
	--@fn: undefined | resize | Redimensiona el rollout.
	------------------------------------------------
	fn resize =
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
	--@event: selected | Evento que se lanza al cambiar el checkbox.
	--@control: dropdownlist | ddlSoftShadowsPrecision | Scanline Enable
	------------------------------------------------
	on chkScanlineEnable changed val do
	(
		if not (val and (editCA.Autovolume) and not (setAutovolumeState #disabled)) then
		(
			editCA.ScanlineEnable = val
			if not val then editCA.RaytraceEnable = true
		)		

		---------------------
		--acutaliza el rollout propio y los relacionados
		loadOverrideInfo()
		updateRelatedRollouts()
		---------------------
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el checkbox.
	--@control: dropdownlist | ddlSoftShadowsPrecision | Use Fast Rasterizer
	------------------------------------------------
	on chkUseFastRasterizer changed val do
	(
		editCA.ScanlineMethod = if chkUseFastRasterizer.checked then 1 else 0
		
		---------------------
		--acutaliza el rollout propio y los relacionados
		loadOverrideInfo()
		updateRelatedRollouts()
		---------------------
	)
			
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el dropdown.
	--@control: dropdownlist | ddlSoftShadowsPrecision | Samples Per Pixel
	------------------------------------------------
	on ddlSamplesPerPixel selected val do
	(
		editCA.RapidCollectRate = ddlSamplesPerPixel.selection

		---------------------
		--acutaliza los rollotus relacionados
		updateRelatedRollouts()
		---------------------
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | ddlSoftShadowsPrecision | Shades Per Pixel
	------------------------------------------------
	on spnShadesPerPixel changed val do
	(
		editCA.RapidShadingSamples = spnShadesPerPixel.value

		---------------------
		--acutaliza los rollotus relacionados
		updateRelatedRollouts()
		---------------------
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el checkbox.
	--@control: dropdownlist | ddlSoftShadowsPrecision | Raytrace Enable
	------------------------------------------------
	on chkRaytraceEnable changed val do
	(
		if not (not val and (editCA.Autovolume) and not (setAutovolumeState #disabled)) then
		(
			editCA.RaytraceEnable = val				
		)
		
		---------------------
		--acutaliza el rollout propio y los relacionados
		loadOverrideInfo()
		updateRelatedRollouts()
		---------------------
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el checkbox.
	--@control: dropdownlist | ddlSoftShadowsPrecision | Autovolume
	------------------------------------------------
	on chkAutovolume changed val do
	(
		if not (val and ((editCA.ScanlineEnable) or (editCA.ShadowMethod != 2)) and not (setAutovolumeState #enabled)) then
		(
			editCA.Autovolume = val
		)

		---------------------
		--acutaliza el rollout propio y los relacionados
		loadOverrideInfo()
		updateRelatedRollouts()
		---------------------
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

		loadOverrideInfo()
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
		loadOverrideInfo()
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el checkbox.
	--@control: checkbox | chkRefractionsEnable | Refractions Enable
	------------------------------------------------
	on chkRefractionsEnable changed val do
	(
		editCA.RefractionsEnable = chkRefractionsEnable.checked
		loadOverrideInfo()
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
	--@event: selected | Evento que se lanza al cambiar el checkbox.
	--@control: checkbox | chkSubsetPixelRendering | Subset Pixel Rendering.
	------------------------------------------------
	on chkSubsetPixelRendering changed val do
	(
		editCA.enable_subset_pixel_rendering = val
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideMentalSamplingQuality | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalRenderingAlgorithms changed state do
	(
		editCA.overrideMentalRenderingAlgorithms = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalRenderingAlgorithmsDef | rollout actual.
	------------------------------------------------
	on rollMentalRenderingAlgorithmsDef open do
	(
		parent = lb.passManager.getCurrentEditInstance()
		editCA = parent.editBackupNode.custAttributes[#overrideRendererSettingsInfo]

		updateUI()
		
		loadSettings()
		createSceneEvents()

		resize() --redimensiona los componentes del UI una vez abierto
	)
	
	------------------------------------------------
	--@event: close | Evento lanzado al cerrarse el rollout.
	--@control: rollout | rollMentalRenderingAlgorithmsDef | rollout actual.
	------------------------------------------------
	on rollMentalRenderingAlgorithmsDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalRenderingAlgorithmsDef