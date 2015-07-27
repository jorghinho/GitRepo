------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Scanline Default Params.
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollScanlineGeneralParamsDef | Rollout de IBL de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollScanlineGeneralParamsDef "Default Scanline Renderer"
(
	------------------------------------------------------------------------------------------------
	--COMMON
	------------------------------------------------------------------------------------------------
	
	local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento.
	
	local editCA = undefined --@var : editCA| Variable de atajo para el CA de edit.

	------------------------------------------------------------------------------------------------
	--VARIABLES
	------------------------------------------------------------------------------------------------
	
	local sectionsIds = #() --@var: sectionsIds | Variable que almacena un id para asociar un nombre a cada valor del array de sectionsControls
	local sectionsControls = #() --@var: sectionsControls | Array de arrays que almacena los controles de cada sección para agruparlos y ocultarlos/desocultarlos con facilidad.
	local sectionsSizes = #() --@var: sectionsSizes | Array con los altos de cada sección (sin incluir los botones de OK y CANCEL, 20 píxeles más.)

	------------------------------------------------------------------------------------------------
	--CONTROLS
	------------------------------------------------------------------------------------------------
	
	--override active
	checkbox chkOverrideScanlineGeneralParams "override" pos:[5,5] checked:false --@control | chkOverrideScanlineGeneralParams | Indica si hacer override de esos parametros.

	groupBox grpAntialiasing "Antialiasing:" pos:[5,25] width:327 height:110

	checkbox chkAntialiasing "Antialiasing" pos:[12,48]
	checkbox chkFilterMaps "Filter Maps" pos:[12,70]

	label lblFilter "Filter:" pos:[157,48]
	dropdownlist ddlFilter pos:[187,45] width:138 items:#("Area", "Blackman", "Blend", "Catmull Rom", "Cook Variable", "Cubic", "Mitchell-Netravali", "Plate Match/MAX R2", "Quadratic", "Sharp Quadratic", "Soften", "Video")
	
	label lblFilterSize "Filter Size:" pos:[217,72]
	spinner spnFilterSize "" range:[1.0,20.0,1.5] type:#float scale:0.1 pos:[268,72] fieldWidth:45
	label lblBlend "Blend:" pos:[217,92]
	spinner spnBlendValue "" range:[0.0,1.0,0.3] type:#float scale:0.01 pos:[268,92] fieldWidth:45
	label lblBlur "Blur:" pos:[217,92]
	spinner spnMNBlur "" range:[0.0,1.0,0.333] type:#float scale:0.01 pos:[268,92] fieldWidth:45
	label lblRinging "Ringing:" pos:[217,112]
	spinner spnMNRinging "" range:[0.0,1.0,0.333] type:#float scale:0.01 pos:[268,112] fieldWidth:45

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
			for _cntrl in rollScanlineGeneralParamsDef.controls where _cntrl.name != "chkOverrideScanlineGeneralParams" do _cntrl.enabled = editCA.overrideScanlineGeneralParams
			chkOverrideScanlineGeneralParams.checked = editCA.overrideScanlineGeneralParams
		)
		else if not editCA.overrideScanlineGeneralParams then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollScanlineGeneralParamsDef.controls where _cntrl.name != "chkOverrideScanlineGeneralParams" do _cntrl.enabled = false
			chkOverrideScanlineGeneralParams.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(		
		_filter = ((classOf editCA.antiAliasFilter) as string)
		
		if _filter == "cubic" then _filter = "Cubic"	
		if _filter == "Blendfilter" then _filter = "Blend"
		if _filter == "Mitchell_Netravali" then _filter = "Mitchell-Netravali"
		if _filter == "Plate_Match_MAX_R2" then _filter = "Plate Match/MAX R2"

		_filter = substituteString _filter "_" " "

		ddlFilter.selection = finditem ddlFilter.items _filter

		chkAntialiasing.checked = editCA.antiAliasing
		chkFilterMaps.checked = editCA.filterMaps
		spnFilterSize.value = editCA.antiAliasFilterSize

		lblBlend.visible = false
		spnBlendValue.visible = false

		lblBlur.visible = false
		spnMNBlur.visible = false

		lblRinging.visible = false
		spnMNRinging.visible = false

		spnFilterSize.enabled = (_filter != "Quadratic") and (_filter != "Cubic") and (_filter != "Sharp Quadratic") and (_filter != "Video") and (_filter != "Mitchell-Netravali")
		
		if (_filter == "Blend") then
		(
			lblBlend.visible = true
			spnBlendValue.visible = true
			spnBlendValue.value = editCA.antiAliasFilter.Blend
		)

		if (_filter == "Mitchell-Netravali") then
		(			
			lblBlur.visible = true
			lblRinging.visible = true
			spnMNBlur.visible = true
			spnMNRinging.visible = true
			spnMNBlur.value = editCA.antiAliasFilter.Blur
			spnMNRinging.value = editCA.antiAliasFilter.Ringing
		)
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideScanlineGeneralParams.checked = editCA.overrideMentalGlobalTuningParams
		updateUIControlsByOverrideEnabledState()
		loadOverrideInfo()
		updateUIControlsByOverrideEnabledState disableOnly:true
	)

	------------------------------------------------
	--@fn: undefined | updateRelatedRollouts | Actualiza el estado de los controles de rollouts relacionados.
	------------------------------------------------
	fn updateRelatedRollouts =
	(
		--sin operaciones
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
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkAntialiasing | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkAntialiasing changed state do
	(
		editCA.antiAliasing = state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkFilterMaps | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkFilterMaps changed state do
	(
		editCA.filterMaps = state
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el dropdownlist.
	--@control: dropdownlist | ddlFilter | Dropdown de modo de sombras de IBL.
	------------------------------------------------
	on ddlFilter selected item do
	(
		case ddlFilter.items[item] of
		(
			"Area": editCA.antiAliasFilter = Area()
			"Quadratic": editCA.antiAliasFilter = Quadratic()
			"Cubic": editCA.antiAliasFilter = cubic()
			"Catmull Rom": editCA.antiAliasFilter = Catmull_Rom()
			"Blackman": editCA.antiAliasFilter = Blackman()
			"Sharp Quadratic": editCA.antiAliasFilter = Sharp_Quadratic()
			"Video": editCA.antiAliasFilter = Video()
			"Plate Match/MAX R2": editCA.antiAliasFilter = Plate_Match_MAX_R2()
			"Cook Variable": editCA.antiAliasFilter = Cook_Variable()
			"Soften": editCA.antiAliasFilter = Soften()
			"Mitchell-Netravali": editCA.antiAliasFilter = Mitchell_Netravali()
			"Blend": editCA.antiAliasFilter = Blendfilter()
		)--case

		updateUI()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | spnFilterSize | Spinner que cambia de valor
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnFilterSize changed value do
	(
		editCA.antiAliasFilterSize = value		
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | spnBlendValue | Spinner que cambia de valor
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnBlendValue changed value do
	(
		editCA.antiAliasFilter.Blend = value		
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | spnMNBlur | Spinner que cambia de valor
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnMNBlur changed value do
	(
		editCA.antiAliasFilter.Blur = value		
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | spnMNRinging | Spinner que cambia de valor
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnMNRinging changed value do
	(
		editCA.antiAliasFilter.Ringing = value		
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideScanlineGeneralParams | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideScanlineGeneralParams changed state do
	(
		editCA.overrideScanlineGeneralParams = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollScanlineGeneralParamsDef | rollout actual.
	------------------------------------------------
	on rollScanlineGeneralParamsDef open do
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
	--@control: rollout | rollScanlineGeneralParamsDef | rollout actual.
	------------------------------------------------
	on rollScanlineGeneralParamsDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollScanlineGeneralParamsDef