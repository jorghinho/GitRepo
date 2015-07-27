------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. Caustics.
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalCausticsDef | Rollout de causticas de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalCausticsDef "Caustics & Photon Mapping (GI)"
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
	checkbox chkOverrideMentalCaustics "override" pos:[5,5] checked:false --@control | chkOverrideMentalCaustics | Indica si hacer override de esos parametros.

	groupBox grpCaustics "Caustics" pos:[5,25] width:327 height:115
		
	checkbox chkEnableCaustics "Enable" pos:[15,40] width:120 height:15 checked:false
	label lblMultiplierCaustics "Multiplier:" pos:[200,40] width:50 height:15
	spinner spnMultiplierCaustics "" pos:[257,40] width:50 height:16 range:[0,999999995904,1] type:#float scale:0.1
	colorpicker clrTintCaustics "" pos:[307,40] width:20 height:17
	
	label lblMaxNumPhotonsCaustics "Maximun Num. Photons per Sample:" pos:[40,60] width:195
	spinner spnMaxNumPhotonsCaustics "" pos:[257,60] width:70 height:16 range:[1,100000000,100] type:#integer scale:1

	checkbox chkMaxSamplignRadiusCaustics "Maximum Sampling Radius:" pos:[40,80] width:195 height:15
	spinner spnMaxSamplingRadiusCaustics "" pos:[257,80] width:70 height:16 range:[0,100000000,1] type:#float scale:0.1

	label lblFilterCaustics "Filter:" pos:[40,100] width:50 height:15
	dropdownlist ddlFilterCaustics "" pos:[100,98] width:60 height:21 selection:1 items:#("Box", "Cone", "Gauss")
	label lblFilterSizeCaustics "Filter Size:" pos:[200,100] width:50 height:15
	spinner spnFilterSizeCaustics "" pos:[257,100] width:70 height:16 range:[0,100000000,1.1] type:#float scale:0.1

	checkbox chkOpaqueShadowsCaustics "Opaque Shadows when Caustics are Enabled" pos:[40,120] width:250 height:15

	groupBox grpPhotonMapping "Photon Mapping (GI):" pos:[5,145] width:327 height:115
	
	checkbox chkEnablePhotonMapping "Enable" pos:[15,160] width:120 height:15 checked:false
	label lblMultiplierPhotonMapping "Multiplier:" pos:[200,160] width:50 height:15
	spinner spnMultiplierPhotonMapping "" pos:[257,160] width:50 height:16 range:[0,999999995904,1] type:#float scale:0.1
	colorpicker clrTintPhotonMapping "" pos:[307,160] width:20 height:17

	label lblMaxNumPhotonsPhotonMapping "Maximun Num. Photons per Sample:" pos:[40,180] width:195
	spinner spnMaxNumPhotonsPhotonMapping "" pos:[257,180] width:70 height:16 range:[1,100000000,500] type:#integer scale:1

	checkbox chkMaxSamplignRadiusPhotonMapping "Maximum Sampling Radius:" pos:[40,200] width:195 height:15
	spinner spnMaxSamplingRadiusPhotonMapping "" pos:[257,200] width:70 height:16 range:[0,100000000,1] type:#float scale:0.1

	checkbox chkMergeNearbyPhotonsPhotonMapping "Merge Nearby Photons (saves memory):" pos:[40,220] width:195 height:15
	spinner spnMergeNearbyPhotonsPhotonMapping "" pos:[257,220] width:70 height:16 range:[0,100000000,0] type:#float scale:0.1

	checkbox chkOptimizeForFinalGaherPhotonMapping "Optimize for Final Gather (Slower GI)" pos:[40,240] width:195 height:15

	groupBox grpVolumes "Volumes" pos:[5,265] width:327 height:60

	label lblMaxNumPhotonsVolumes "Maximun Num. Photons per Sample:" pos:[40,280] width:195
	spinner spnMaxNumPhotonsVolumes "" pos:[257,280] width:70 height:16 range:[1,100000000,100] type:#integer scale:1

	checkbox chkMaxSamplignRadiusVolumes "Maximum Sampling Radius:" pos:[40,300] width:195 height:15
	spinner spnMaxSamplingRadiusVolumes "" pos:[257,300] width:70 height:16 range:[0,100000000,1] type:#float scale:0.1

	groupBox grpTraceDepth "Trace Depth" pos:[5,330] width:327 height:60

	label lblMaxDepthTraceDepth "Max.Depth:" pos:[40,345] width:60
	spinner spnMaxDepthTraceDepth "" pos:[100,345] width:60 height:16 range:[1,100000000,10] type:#integer scale:1

	label lblMaxReflectionsTraceDepth "Max.Reflections:" pos:[182,345] width:80
	spinner spnMaxReflectionsTraceDepth "" pos:[267,345] width:60 height:16 range:[1,100000000,10] type:#integer scale:1
	
	label lblMaxRefractionsTraceDepth "Max.Refractions:" pos:[182,365] width:80
	spinner spnMaxRefractionsTraceDepth "" pos:[267,365] width:60 height:16 range:[1,100000000,10] type:#integer scale:1

	groupBox grpLightProperties "Light Properties" pos:[5,395] width:327 height:80

	label lblAverageCausticPhotonsPerLightLightProperties "Average Caustic Photons per Light:" pos:[40,410] width:195
	spinner spnAverageCausticPhotonsPerLightLightProperties "" pos:[247,410] width:80 height:16 range:[0,1000000000,20000] type:#integer scale:1

	label lblAverageGIPhotonsPerLightLightProperties "Average GI Photons per Light:" pos:[40,430] width:195
	spinner spnAverageGIPhotonsPerLightLightProperties "" pos:[247,430] width:80 height:16 range:[0,1000000000,20000] type:#integer scale:1

	label lblDecayLightProperties "Decay:" pos:[40,450] width:195
	spinner spnDecayLightProperties "" pos:[247,450] width:80 height:16 range:[0,100,2] type:#float scale:0.1

	groupBox grpGeometryProperties "Geometry Properties" pos:[5,480] width:327 height:40
	checkbox chkAllObjectsGenerateAndReceiveGIAndCausticsGeometryProperties "All Objects Generate & Receive GI and Caustics" pos:[40,498] width:250 height:15

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
		if not disableOnly then --si esta en el modo en que se permite habilitar y deshabilitar
		(
			for _cntrl in rollMentalCausticsDef.controls where _cntrl.name != "chkOverrideMentalCaustics" do _cntrl.enabled = editCA.overrideMentalCaustics
			chkOverrideMentalCaustics.checked = editCA.overrideMentalCaustics
		)
		else if not editCA.overrideMentalCaustics then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalCausticsDef.controls where _cntrl.name != "chkOverrideMentalCaustics" do _cntrl.enabled = false
			chkOverrideMentalCaustics.checked = false
		)
	)

	/*------------------------------------------------
	--@fn: undefined | refreshPresetSliderValue | Refresca el estado del slider de presets.
	------------------------------------------------
	fn refreshPresetSliderValue onlyText:false =
	(
		_currentValues = #(spnFGpointDensity.value, spnRaysPerFGpoint.value, spnInterpolateOver.value) as string
		
		case _currentValues of
		(
			"#(0.1, 50, 30)":
			(
				if not onlyText then sldFGpresets.value = 0
				edtFGpresets.text = "Draft"
			)
			
			"#(0.4, 150, 30)":
			(
				if not onlyText then sldFGpresets.value = 25
				edtFGpresets.text = "Low"
			)
			
			"#(0.8, 250, 30)":
			(
				if not onlyText then sldFGpresets.value = 50
				edtFGpresets.text = "Medium"
			)
			
			"#(1.5, 500, 30)":
			(
				if not onlyText then sldFGpresets.value = 75
				edtFGpresets.text = "High"
			)
			
			"#(4.0, 10000, 100)":
			(
				if not onlyText then sldFGpresets.value = 100
				edtFGpresets.text = "Very High"
			)
			
			default:
			(
				if not onlyText then sldFGpresets.value = 100
				edtFGpresets.text = "Custom"
			)
		)--case
	)*/
		
	/*------------------------------------------------
	--@fn: undefined | refreshUIcontrolsState | Refresca el estado de los controles en funcion de sus valores.
	------------------------------------------------
	fn refreshUIcontrolsState =
	(
		_state = chkEnableFinalGather.checked
		
		spnMultiplier.enabled = _state
		clrTint.enabled = _state
		
		sldFGpresets.enabled = _state
		edtFGpresets.enabled = _state
		
		ddlProject.enabled = _state
		ddlSegments.enabled = _state and (ddlProject.selection == 2)
		spnFGpointDensity.enabled = _state
		spnRaysPerFGpoint.enabled = _state
		spnInterpolateOver.enabled = _state and not chkRadiusInterpolation.checked
		spnBounces.enabled = _state
		spnWeight.enabled = _state
		
		ddlNoiseFilter.enabled = _state
		chkDraftMode.enabled = _state
		
		spnMaxDepth.enabled = _state
		spnMaxRefl.enabled = _state
		spnMaxRefr.enabled = _state
		
		chkUseFalloff.enabled = _state
		spnStart.enabled = _state and chkUseFalloff.checked
		spnStop.enabled = _state and chkUseFalloff.checked
		
		chkRadiusInterpolation.enabled = _state
		chkRadPixels.enabled = _state and chkRadiusInterpolation.checked
		chkRadius.enabled = _state and chkRadiusInterpolation.checked
		spnRadius.enabled = _state and chkRadiusInterpolation.checked
		chkMinRadius.enabled = _state and chkRadiusInterpolation.checked and chkRadius.checked
		spnMinRadius.enabled = _state and chkRadiusInterpolation.checked and chkRadius.checked
	)*/

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		chkOverrideMentalCaustics.checked = editCA.overrideMentalCaustics

		chkEnableCaustics.checked = editCA.CausticsEnable
		
		lblMultiplierCaustics.enabled = spnMultiplierCaustics.enabled = clrTintCaustics.enabled = editCA.CausticsEnable
		spnMultiplierCaustics.value = editCA.CausticMultiplierScalar
		clrTintCaustics.color = editCA.CausticMultiplierColor

		lblMaxNumPhotonsCaustics.enabled = spnMaxNumPhotonsCaustics.enabled = editCA.CausticsEnable
		spnMaxNumPhotonsCaustics.value = editCA.CausticAccuracy

		chkMaxSamplignRadiusCaustics.enabled = editCA.CausticsEnable
		chkMaxSamplignRadiusCaustics.checked = editCA.UseCausticRadius
		spnMaxSamplingRadiusCaustics.enabled = editCA.UseCausticRadius and editCA.CausticsEnable
		spnMaxSamplingRadiusCaustics.value = editCA.CausticRadius 

		lblFilterCaustics.enabled = ddlFilterCaustics.enabled = lblFilterSizeCaustics.enabled = spnFilterSizeCaustics.enabled = editCA.CausticsEnable
		ddlFilterCaustics.selection = editCA.CausticsFilter + 1
		spnFilterSizeCaustics.value = editCA.Kernel

		chkOpaqueShadowsCaustics.enabled = editCA.CausticsEnable
		chkOpaqueShadowsCaustics.checked = editCA.CausticOpaqueShadows

		chkEnablePhotonMapping.checked = editCA.GlobalIllumEnable

		lblMultiplierPhotonMapping.enabled = spnMultiplierPhotonMapping.enabled = clrTintPhotonMapping.enabled = editCA.GlobalIllumEnable
		spnMultiplierPhotonMapping.value = editCA.GIMultiplierScalar
		clrTintPhotonMapping.color = editCA.GIMultiplierColor

		lblMaxNumPhotonsPhotonMapping.enabled = spnMaxNumPhotonsPhotonMapping.enabled = editCA.GlobalIllumEnable
		spnMaxNumPhotonsPhotonMapping.value = editCA.GlobalIllumAccuracy 

		chkMaxSamplignRadiusPhotonMapping.enabled = editCA.GlobalIllumEnable
		chkMaxSamplignRadiusPhotonMapping.checked = editCA.UseGlobalIllumRadius 
		spnMaxSamplingRadiusPhotonMapping.enabled = editCA.UseGlobalIllumRadius and editCA.GlobalIllumEnable
		spnMaxSamplingRadiusPhotonMapping.value = editCA.GlobalIllumRadius

		chkMergeNearbyPhotonsPhotonMapping.enabled = editCA.GlobalIllumEnable
		chkMergeNearbyPhotonsPhotonMapping.checked = editCA.UseGIPhotonMergeDistance 
		spnMergeNearbyPhotonsPhotonMapping.enabled = editCA.UseGIPhotonMergeDistance and editCA.GlobalIllumEnable
		spnMergeNearbyPhotonsPhotonMapping.value = editCA.GIPhotonMergeDistance

		chkOptimizeForFinalGaherPhotonMapping.enabled = editCA.GlobalIllumEnable
		chkOptimizeForFinalGaherPhotonMapping.checked = editCA.OptimizeForFinalGather

		lblMaxNumPhotonsVolumes.enabled = spnMaxNumPhotonsVolumes.enabled = editCA.CausticsEnable or editCA.GlobalIllumEnable
		spnMaxNumPhotonsVolumes.value = editCA.VolumeAccuracy

		chkMaxSamplignRadiusVolumes.enabled = editCA.CausticsEnable or editCA.GlobalIllumEnable
		chkMaxSamplignRadiusVolumes.checked = editCA.UseVolumeRadius
		spnMaxSamplingRadiusVolumes.enabled = editCA.UseVolumeRadius and (editCA.CausticsEnable or editCA.GlobalIllumEnable)
		spnMaxSamplingRadiusVolumes.value = editCA.VolumeRadius

		lblMaxDepthTraceDepth.enabled = spnMaxDepthTraceDepth.enabled = editCA.CausticsEnable or editCA.GlobalIllumEnable
		spnMaxDepthTraceDepth.value = editCA.GIMaximumTraceDepth
		lblMaxReflectionsTraceDepth.enabled = spnMaxReflectionsTraceDepth.enabled = editCA.CausticsEnable or editCA.GlobalIllumEnable
		spnMaxReflectionsTraceDepth.value = editCA.GIMaximumReflections
		lblMaxRefractionsTraceDepth.enabled = spnMaxRefractionsTraceDepth.enabled = editCA.CausticsEnable or editCA.GlobalIllumEnable
		spnMaxRefractionsTraceDepth.value = editCA.GIMaximumRefractions

		lblAverageCausticPhotonsPerLightLightProperties.enabled = spnAverageCausticPhotonsPerLightLightProperties.enabled = editCA.CausticsEnable
		spnAverageCausticPhotonsPerLightLightProperties.value = editCA.GlobalLightCausticPhotons		
		lblAverageGIPhotonsPerLightLightProperties.enabled = spnAverageGIPhotonsPerLightLightProperties.enabled = editCA.GlobalIllumEnable
		spnAverageGIPhotonsPerLightLightProperties.value = editCA.GlobalLightGIPhotons
		lblDecayLightProperties.enabled = spnDecayLightProperties.enabled = editCA.CausticsEnable or editCA.GlobalIllumEnable

		chkAllObjectsGenerateAndReceiveGIAndCausticsGeometryProperties.enabled = editCA.CausticsEnable or editCA.GlobalIllumEnable
		chkAllObjectsGenerateAndReceiveGIAndCausticsGeometryProperties.checked = editCA.OverrideIIObjProps
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalCaustics.checked = editCA.overrideMentalCaustics
		updateUIControlsByOverrideEnabledState()
		loadOverrideInfo()
		updateUIControlsByOverrideEnabledState disableOnly:true
	)

	------------------------------------------------
	--@fn: undefined | updateRelatedRollouts | Actualiza el estado de los controles de rollouts relacionados.
	------------------------------------------------
	fn updateRelatedRollouts =
	(
		/*
		parent.rolloutToupdate.updateUI()
		*/
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
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkEnableCaustics | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkEnableCaustics changed state do
	(
		editCA.CausticsEnable = state
		updateUI()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMultiplierCaustics | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMultiplierCaustics changed val do
	(
		editCA.CausticMultiplierScalar = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el color.
	--@control: colorPicker | clrTintCaustics | colorPicker que cambia de color.
	--@gets: color | vale | Nuevo color.
	------------------------------------------------
	on clrTintCaustics changed val do
	(
		editCA.CausticMultiplierColor = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxNumPhotonsCaustics | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxNumPhotonsCaustics changed val do
	(
		editCA.CausticAccuracy = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkMaxSamplignRadiusCaustics | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkMaxSamplignRadiusCaustics changed state do
	(
		editCA.UseCausticRadius = state
		updateUI()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxSamplingRadiusCaustics | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxSamplingRadiusCaustics changed val do
	(
		editCA.CausticRadius = val
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el listado.
	--@control: dropdownlist | ddlProject | Dropdown que cambia de seleccion
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlFilterCaustics selected index do
	(
		editCA.CausticsFilter = index - 1
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnFilterSizeCaustics | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnFilterSizeCaustics changed val do
	(
		editCA.Kernel = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkOpaqueShadowsCaustics | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOpaqueShadowsCaustics changed state do
	(
		editCA.CausticOpaqueShadows = state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkEnablePhotonMapping | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkEnablePhotonMapping changed state do
	(
		editCA.GlobalIllumEnable = state
		updateUI()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMultiplierPhotonMapping | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMultiplierPhotonMapping changed val do
	(
		editCA.GIMultiplierScalar = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el color.
	--@control: colorPicker | clrTintPhotonMapping | colorPicker que cambia de color.
	--@gets: color | vale | Nuevo color.
	------------------------------------------------
	on clrTintPhotonMapping changed val do
	(
		editCA.GIMultiplierColor = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxNumPhotonsPhotonMapping | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxNumPhotonsPhotonMapping changed val do
	(
		editCA.GlobalIllumAccuracy = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkMaxSamplignRadiusPhotonMapping | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkMaxSamplignRadiusPhotonMapping changed state do
	(
		editCA.UseGlobalIllumRadius = state
		updateUI()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxSamplingRadiusPhotonMapping | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxSamplingRadiusPhotonMapping changed val do
	(
		editCA.GlobalIllumRadius = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkMergeNearbyPhotonsPhotonMapping | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkMergeNearbyPhotonsPhotonMapping changed state do
	(
		editCA.UseGIPhotonMergeDistance = state
		updateUI()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMergeNearbyPhotonsPhotonMapping | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMergeNearbyPhotonsPhotonMapping changed val do
	(
		editCA.GIPhotonMergeDistance = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkOptimizeForFinalGaherPhotonMapping | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOptimizeForFinalGaherPhotonMapping changed state do
	(
		editCA.OptimizeForFinalGather = state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxNumPhotonsVolumes | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxNumPhotonsVolumes changed val do
	(
		editCA.VolumeAccuracy = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkMaxSamplignRadiusVolumes | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkMaxSamplignRadiusVolumes changed state do
	(
		editCA.UseVolumeRadius = state
		updateUI()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxSamplingRadiusVolumes | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxSamplingRadiusVolumes changed val do
	(
		editCA.VolumeRadius = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxDepthTraceDepth | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxDepthTraceDepth changed val do
	(
		editCA.GIMaximumTraceDepth = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxReflectionsTraceDepth | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxReflectionsTraceDepth changed val do
	(
		editCA.GIMaximumReflections = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxRefractionsTraceDepth | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxRefractionsTraceDepth changed val do
	(
		editCA.GIMaximumRefractions = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnAverageCausticPhotonsPerLightLightProperties | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnAverageCausticPhotonsPerLightLightProperties changed val do
	(
		editCA.GlobalLightCausticPhotons = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnAverageGIPhotonsPerLightLightProperties | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnAverageGIPhotonsPerLightLightProperties changed val do
	(
		editCA.GlobalLightGIPhotons = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnDecayLightProperties | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnDecayLightProperties changed val do
	(
		editCA.GlobalLightDecay = val
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkAllObjectsGenerateAndReceiveGIAndCausticsGeometryProperties | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkAllObjectsGenerateAndReceiveGIAndCausticsGeometryProperties changed state do
	(
		editCA.OverrideIIObjProps = state
		updateUI()
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideMentalCaustics | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalCaustics changed state do
	(
		editCA.overrideMentalCaustics = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalCausticsDef | rollout actual.
	------------------------------------------------
	on rollMentalCausticsDef open do
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
	--@control: rollout | rollMentalCausticsDef | rollout actual.
	------------------------------------------------
	on rollMentalCausticsDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalCausticsDef