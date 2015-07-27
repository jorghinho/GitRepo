------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. FInal Gather.
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalFinalGatherDef | Rollout de final gather de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalFinalGatherDef "Final Gathering (FG)"
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
	checkbox chkOverrideMentalFinalGather "override" pos:[5,5] checked:true --@control | chkOverrideMentalFinalGather | Indica si hacer override de esos parametros.

	groupBox grpBasic "Basic" pos:[5,25] width:327 height:215
		
	checkbox chkEnableFinalGather "Enable Final Gather" pos:[15,40] width:120 height:15 checked:false
	spinner spnMultiplier "Multiplier:    " pos:[212,40] width:95 height:16 range:[0,999999995904,1] type:#float scale:0.1
	colorPicker clrTint "" pos:[307,40] width:20 height:20
	
	groupBox grpFGprecision "FG Precision Presets:" pos:[10,58] width:317 height:47
	
	slider sldFGpresets "" pos:[20,70] width:182 height:20 ticks:4 range:[0,100,0] type:#integer
	editText edtFGpresets "" pos:[197,80] width:125 height:20 readonly:true
	
	dropDownList ddlProject "" pos:[10,110] width:317 height:21 selection:1 items:#("Project FG Points From Camera Position (Best for Stills)", "Project FG Points From Positions Along Camera Path")
	
	label lblDivide "Divide Camera Path by Num. Segments:" pos:[10,135] width:195 height:15
	dropDownList ddlSegments "" pos:[257,130] width:70 height:21 selection:3 items:#("1", "4", "9", "16", "25", "36", "49", "64", "81", "100")
	
	label lblInitialFGdensity "Initial FG Point Density:" pos:[10,155] width:195 height:15
	spinner spnFGpointDensity "" pos:[257,155] width:70 height:16 range:[0,100,0.1] type:#float scale:0.1
	
	label lblRaysPerFGPoint "Rays per FG Point:" pos:[10,175] width:195 height:15
	spinner spnRaysPerFGpoint "" pos:[257,175] width:70 height:16 range:[1,1000000,50] type:#integer scale:1
	
	label lblInterpolateOver "Interpolate Over Num. FG Points:" pos:[10,195] width:195 height:15
	spinner spnInterpolateOver "" pos:[257,195] width:70 height:16 range:[0,1000,30] type:#integer scale:1
	
	label lblBounces "Diffuse Bounces" pos:[10,215] width:80 height:15
	spinner spnBounces "" pos:[100,215] width:70 height:16 range:[0,1000000,0] type:#integer scale:1
	
	label lblWeight "Weight:" pos:[217,215] width:40 height:15
	spinner spnWeight "" pos:[257,215] width:70 height:16 range:[0,1,1] type:#float scale:0.1
	
	groupBox grpAdvanced "Advanced" pos:[5,245] width:327 height:245
	
	label lblNoise "Noise Filtering (Speckle Reduction):" pos:[15,260] width:175 height:15
	dropDownList ddlNoiseFilter "" pos:[232,255] width:95 height:21 selection:2 items:#("None", "Standard", "High", "Very High", "Extremely High")
	checkbox chkDraftMode "Draft Mode (No Precalculations)" pos:[15,280] width:175 height:15 checked:false
	
	groupBox grpTraceDepth "Trace Depth" pos:[10,300] width:317 height:105
	
	spinner spnMaxDepth "Max. Depth:" pos:[60,320] width:70 height:16 range:[0,1000000,5] type:#integer scale:1
	spinner spnMaxRefl "Max. Reflections: " pos:[232,320] width:90 height:16 range:[0,1000000,2] type:#integer scale:1
	spinner spnMaxRefr "Max. Refractions: " pos:[232,340] width:90 height:16 range:[0,1000000,5] type:#integer scale:1
	
	checkbox chkUseFalloff "Use Falloff (Limits Ray Distance)" pos:[20,360] width:175 height:15 checked:false
	spinner spnStart "Start:          " pos:[60,380] width:70 height:16 range:[0,1000000,0] type:#float scale:0.1
	spinner spnStop "Stop:                    " pos:[232,380] width:90 height:16 range:[0,1000000,0] type:#float scale:0.1
	
	groupBox grpFGpointInterpolation "FG Point Interpolation" pos:[10,410] width:317 height:75
	
	checkbox chkRadiusInterpolation "Use Radius Interpolation Method" pos:[20,425] width:180 height:15 checked:false
	checkbox chkRadPixels "Radii in Pixels" pos:[20,465] width:85 height:15 checked:false
	checkbox chkRadius "Radius:" pos:[182,445] width:80 height:15 checked:false
	spinner spnRadius "" pos:[262,445] width:60 height:16 range:[0,1000000,0.3] type:#float scale:0.1
	checkbox chkMinRadius "Min. Radius:" pos:[182,465] width:80 height:15 checked:false
	spinner spnMinRadius "" pos:[262,465] width:60 height:16 range:[0,1000000,0] type:#float scale:0.1

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
			for _cntrl in rollMentalFinalGatherDef.controls where _cntrl.name != "chkOverrideMentalFinalGather" do _cntrl.enabled = editCA.overrideMentalFinalGather
			chkOverrideMentalFinalGather.checked = editCA.overrideMentalFinalGather
		)
		else if not editCA.overrideMentalFinalGather then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalFinalGatherDef.controls where _cntrl.name != "chkOverrideMentalFinalGather" do _cntrl.enabled = false
			chkOverrideMentalFinalGather.checked = false
		)
	)

	------------------------------------------------
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
	)
		
	------------------------------------------------
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
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		chkOverrideMentalFinalGather.checked = editCA.overrideMentalFinalGather

		chkEnableFinalGather.checked = editCA.FinalGatherEnable2
		spnMultiplier.value = editCA.FGMultiplierScalar
		clrTint.color = editCA.FGMultiplierColor
		
		ddlProject.selection = editCA.FGProjectionMode + 1
		ddlSegments.selection = findItem ddlSegments.items (editCA.FGProjectionModeNumSegments as string)
		spnFGpointDensity.value = editCA.FinalGatherDensity
		spnRaysPerFGpoint.value = editCA.FinalGatherAccuracy
		spnInterpolateOver.value = editCA.FinalGatherInterpolationSamples
		spnBounces.value = editCA.FinalGatherBounces
		spnWeight.value = editCA.FinalGatherBounceMultiplier
		
		ddlNoiseFilter.selection = editCA.FinalGatherFilter + 1
		chkDraftMode.checked = editCA.FinalGatherPreview
		
		spnMaxDepth.value = editCA.FinalGatherTraceDepth
		spnMaxRefl.value = editCA.FinalGatherReflectionDepth
		spnMaxRefr.value = editCA.FinalGatherRefractionDepth
		
		chkUseFalloff.checked = editCA.FinalGatherFalloff
		spnStart.value = editCA.FinalGatherFalloffStart
		spnStop.value = editCA.FinalGatherFalloffStop
		
		chkRadiusInterpolation.checked = editCA.FinalGatherUseRadiusInterpolation
		chkRadPixels.checked = editCA.FinalGatherView
		chkRadius.checked = editCA.UseFinalGatherRadius
		spnRadius.value = if not chkRadPixels.checked then editCA.FinalGatherRadius else editCA.FinalGatherRadius_View
		chkMinRadius.checked = editCA.UseFinalGatherMinRadius
		spnMinRadius.value = if not chkRadPixels.checked then editCA.FinalGatherMinRadius else editCA.FinalGatherMinRadius_View
		
		refreshPresetSliderValue()			
		refreshUIcontrolsState()
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalFinalGather.checked = editCA.overrideMentalFinalGather
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
	--@control: checkBox | chkEnableFinalGather | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkEnableFinalGather changed state do
	(
		editCA.FinalGatherEnable2 = state
		refreshUIcontrolsState()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMultiplier | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMultiplier changed val do
	(
		editCA.FGMultiplierScalar = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el color.
	--@control: colorPicker | clrTint | colorPicker que cambia de color.
	--@gets: color | vale | Nuevo color.
	------------------------------------------------
	on clrTint changed val do
	(
		editCA.FGMultiplierColor = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el slider.
	--@control: slider | sldFGpresets | Slider que cambia de valor.
	--@gets: integer | vale | Nuevo valor.
	------------------------------------------------
	on sldFGpresets changed val do
	(
		if val < 13 then sldFGpresets.value = 0
		else if val < 38 then sldFGpresets.value = 25
		else if val < 63 then sldFGpresets.value = 50
		else if val < 88 then sldFGpresets.value = 75
		else sldFGpresets.value = 100
		
		case sldFGpresets.value of
		(
			0:
			(
				spnFGpointDensity.value = 0.1
				spnRaysPerFGpoint.value = 50
				spnInterpolateOver.value = 30
			)
			
			25:
			(
				spnFGpointDensity.value = 0.4
				spnRaysPerFGpoint.value = 150
				spnInterpolateOver.value = 30
			)
			
			50:
			(
				spnFGpointDensity.value = 0.8
				spnRaysPerFGpoint.value = 250
				spnInterpolateOver.value = 30
			)
			
			75:
			(
				spnFGpointDensity.value = 1.5
				spnRaysPerFGpoint.value = 500
				spnInterpolateOver.value = 30
			)
			
			100:
			(
				spnFGpointDensity.value = 4.0
				spnRaysPerFGpoint.value = 10000
				spnInterpolateOver.value = 100
			)
		)--case
		
		editCA.FinalGatherDensity = spnFGpointDensity.value
		editCA.FinalGatherAccuracy = spnRaysPerFGpoint.value
		editCA.FinalGatherInterpolationSamples = spnInterpolateOver.value
		
		refreshPresetSliderValue onlyText:true
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el listado.
	--@control: dropdownlist | ddlProject | Dropdown que cambia de seleccion
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlProject selected index do
	(
		editCA.FGProjectionMode = index - 1
		refreshUIcontrolsState()
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el listado.
	--@control: dropdownlist | ddlSegments | Dropdown que cambia de seleccion
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlSegments selected index do
	(
		editCA.FGProjectionModeNumSegments = ddlSegments.items[index] as integer
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnFGpointDensity | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnFGpointDensity changed val do
	(
		editCA.FinalGatherDensity = val
		refreshPresetSliderValue()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnRaysPerFGpoint | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnRaysPerFGpoint changed val do
	(
		editCA.FinalGatherAccuracy = val
		refreshPresetSliderValue()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnInterpolateOver | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnInterpolateOver changed val do
	(
		editCA.FinalGatherInterpolationSamples = val
		refreshPresetSliderValue()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnBounces | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnBounces changed val do
	(
		editCA.FinalGatherBounces = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnWeight | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnWeight changed val do
	(
		editCA.FinalGatherBounceMultiplier = val
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el listado.
	--@control: dropdownlist | ddlNoiseFilter | Dropdown que cambia de seleccion.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlNoiseFilter selected index do
	(
		editCA.FinalGatherFilter = index - 1
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkDraftMode | checkBox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkDraftMode changed state do
	(
		editCA.FinalGatherPreview = state
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxDepth | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxDepth changed val do
	(
		editCA.FinalGatherTraceDepth = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxRefl | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxRefl changed val do
	(
		editCA.FinalGatherReflectionDepth = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxRefr | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMaxRefr changed val do
	(
		editCA.FinalGatherRefractionDepth = val
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkUseFalloff | checkBox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkUseFalloff changed state do
	(
		editCA.FinalGatherFalloff = state
		refreshUIcontrolsState()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnStart | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnStart changed val do
	(
		editCA.FinalGatherFalloffStart = val
		if val > spnStop.value then
		(
			spnStop.value = val
			editCA.FinalGatherFalloffStop = val
		)
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnStop | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnStop changed val do
	(
		editCA.FinalGatherFalloffStop = val
		if val < spnStart.value then
		(
			spnStart.value = val
			editCA.FinalGatherFalloffStart = val
		)
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkRadiusInterpolation | checkBox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkRadiusInterpolation changed state do
	(
		editCA.FinalGatherUseRadiusInterpolation = state
		refreshUIcontrolsState()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkRadPixels | checkBox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkRadPixels changed state do
	(
		editCA.FinalGatherView = state
		
		spnRadius.value = if not chkRadPixels.checked then editCA.FinalGatherRadius else editCA.FinalGatherRadius_View
		spnMinRadius.value = if not chkRadPixels.checked then editCA.FinalGatherMinRadius else editCA.FinalGatherMinRadius_View
			
		refreshUIcontrolsState()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkRadius | checkBox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkRadius changed state do
	(
		editCA.UseFinalGatherRadius = state
		refreshUIcontrolsState()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkMinRadius | checkBox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkMinRadius changed state do
	(
		editCA.UseFinalGatherMinRadius = state
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnRadius | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnRadius changed val do
	(
		if not chkRadPixels.checked then editCA.FinalGatherRadius = val else editCA.FinalGatherRadius_View = val
		if val < spnMinRadius.value then
		(
			spnMinRadius.value = val
			if not chkRadPixels.checked then editCA.FinalGatherMinRadius = val else editCA.FinalGatherMinRadius_View = val
		)
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMinRadius | spinner que cambia de valor.
	--@gets: float | vale | Nuevo valor.
	------------------------------------------------
	on spnMinRadius changed val do
	(
		if not chkRadPixels.checked then editCA.FinalGatherMinRadius = val else editCA.FinalGatherMinRadius_View = val
		if val > spnRadius.value then
		(
			spnRadius.value = val
			if not chkRadPixels.checked then editCA.FinalGatherRadius = val else editCA.FinalGatherRadius_View = val				
		)
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideMentalFinalGather | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalFinalGather changed state do
	(
		editCA.overrideMentalFinalGather = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalFinalGatherDef | rollout actual.
	------------------------------------------------
	on rollMentalFinalGatherDef open do
	(
		parent = lb.passManager.getCurrentEditInstance()
		editCA = parent.editBackupNode.custAttributes[#overrideRendererSettingsInfo]
		-------------------------------------------------------------------------
		--editCA.overrideMentalFinalGather = chkOverrideMentalFinalGather.checked
		--editCA.FinalGatherEnable2 = chkEnableFinalGather.checked
		-------------------------------------------------------------------------
		updateUI()
		
		loadSettings()
		createSceneEvents()

		resize() --redimensiona los componentes del UI una vez abierto
	)
	
	------------------------------------------------
	--@event: close | Evento lanzado al cerrarse el rollout.
	--@control: rollout | rollMentalFinalGatherDef | rollout actual.
	------------------------------------------------
	on rollMentalFinalGatherDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalFinalGatherDef