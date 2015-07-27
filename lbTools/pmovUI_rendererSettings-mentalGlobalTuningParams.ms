------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. Rendering Algorithms
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalGlobalTunigParamsDef | Rollout de Global Tuning Params de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalGlobalTuningParamsDef "Global Tuning Params"
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
	checkbox chkOverrideMentalGlobalTuningParams "override" pos:[5,5] checked:false --@control | chkOverrideMentalGlobalTuningParams | Indica si hacer override de esos parametros.

	groupBox grpGlobalTuningParams "Global Tuning Params" pos:[5,25] width:327 height:83
	label lblSoftShadowsPrecision "Soft Shadows Precision (Multiplier):" pos:[12,44] width:200 --@control | lblSoftShadowsPrecision | Desplegable de precisión de sombras
	dropdownlist ddlSoftShadowsPrecision "" pos:[256,42] items:#("0,125","0,25","0,5","1","2","4","8","16") height:30 width:70 --@control | ddlSoftShadowsPrecision | Desplegable de precisión de sombras
	label lblGlossyReflectionsPrecision "Glossy Reflections Precision (Multiplier):" width:200 pos:[12,65] --@control | lblGlossyReflectionsPrecision | Desplegable de precisión de sombras
	spinner spnGlossyReflectionsPrecision "" pos:[255,65] width:70 height:30 range:[0.0,20.0,0.0] type:#float scale:0.01 --@control | spnGlossyReflectionsPrecision | Desplegable de precisión de reflexión de glossy
	label lblGlossyRefractionsPrecision "Glossy Refractions Precision (Multiplier):" width:200 pos:[12,85] --@control | lblGlossyRefractionsPrecision | Desplegable de precisión de sombras
	spinner spnGlossyRefractionsPrecision "" pos:[255,85] width:70 height:30 range:[0.0,20.0,0.0] type:#float scale:0.01 --@control | spnGlossyRefractionsPrecision | Desplegable de precisión de reflracción de glossy

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
			for _cntrl in rollMentalGlobalTuningParamsDef.controls where _cntrl.name != "chkOverrideMentalGlobalTuningParams" do _cntrl.enabled = editCA.overrideMentalGlobalTuningParams
			chkOverrideMentalGlobalTuningParams.checked = editCA.overrideMentalGlobalTuningParams
		)
		else if not editCA.overrideMentalGlobalTuningParams then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalGlobalTuningParamsDef.controls where _cntrl.name != "chkOverrideMentalGlobalTuningParams" do _cntrl.enabled = false
			chkOverrideMentalGlobalTuningParams.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		--selecciona el elemento correcto del desplegable
		for i=1 to ddlSoftShadowsPrecision.items.count where (editCA.softShadowsPrecision) == ((substituteString ddlSoftShadowsPrecision.items[i] "," ".")  As Float) do
			ddlSoftShadowsPrecision.selection = i
				
		--rellena el valor de los spinners
		spnGlossyReflectionsPrecision.value = editCA.glossyReflectionsPrecision
		spnGlossyRefractionsPrecision.value = editCA.glossyRefractionsPrecision
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalGlobalTuningParams.checked = editCA.overrideMentalGlobalTuningParams
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
		parent.rolloutToupdate.updateUIControlsByOverrideEnabledState()
		parent.rolloutToupdate.loadOverrideInfo()
		parent.rolloutToupdate.updateUIControlsByOverrideEnabledState disableOnly:true
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
	--@event: selected | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | ddlSoftShadowsPrecision | Dropdown precision de sombras.
	------------------------------------------------
	on ddlSoftShadowsPrecision selected index do
	(
		editCA.softshadowsprecision = (substituteString ddlSoftShadowsPrecision.items[index] "," ".") As float
		
	)		
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | spnGlossyReflectionsPrecision | Spinner del valor de glossy reflections precision.
	------------------------------------------------
	on spnGlossyReflectionsPrecision changed newValue do
	(
		editCA.glossyReflectionsPrecision = newValue		
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | spnGlossyRefractionsPrecision | Spinner del valor de glossy refractions precision.
	------------------------------------------------
	on spnGlossyRefractionsPrecision changed newValue do
	(
		editCA.glossyRefractionsPrecision = newValue		
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideMentalGlobalTuningParams | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalGlobalTuningParams changed state do
	(
		editCA.overrideMentalGlobalTuningParams = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalGlobalTuningParamsDef | rollout actual.
	------------------------------------------------
	on rollMentalGlobalTuningParamsDef open do
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
	--@control: rollout | rollMentalGlobalTuningParamsDef | rollout actual.
	------------------------------------------------
	on rollMentalGlobalTuningParamsDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalGlobalTuningParamsDef