------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. IBL.
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalIBLDef | Rollout de IBL de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalIBLDef "Skylights & Enviroment Lighting (IBL)"
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
	checkbox chkOverrideMentalIBL "override" pos:[5,5] checked:false --@control | chkOverrideMentalIBL | Indica si hacer override de esos parametros.

	groupBox grpSkylightMode "Skylight Mode" pos:[5,25] width:327 height:100
	radiobuttons rdoSkylightMode "" pos:[13,45] labels:#("Skylight Illumination from Final Gather (FG)", "Skylight Illumination from IBL") columns:1 default:2
	label lblShadowQuality "Shadow Quality:" pos:[31,80] width:100
	spinner spnShadowsQuality "" pos:[255,80] width:70 height:30 range:[0.0, 10.0, 0.5] type:#float scale:0.01
	label lblShadowMode "Shadow Mode:" pos:[31,100] width:100
	dropdownlist ddlShadowMode "" pos:[150,98] height:30 width:175 items:#("Transparent (More Accurate)", "Opaque (Faster)") 

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
			for _cntrl in rollMentalIBLDef.controls where _cntrl.name != "chkOverrideMentalIBL" do _cntrl.enabled = editCA.overrideMentalIBL
			chkOverrideMentalIBL.checked = editCA.overrideMentalIBL
		)
		else if not editCA.overrideMentalIBL then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalIBLDef.controls where _cntrl.name != "chkOverrideMentalIBL" do _cntrl.enabled = false
			chkOverrideMentalIBL.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		rdoSkylightMode.state = if editCA.IBLEnable then 2 else 1
		lblShadowQuality.enabled = lblShadowMode.enabled = spnShadowsQuality.enabled = ddlShadowMode.enabled = editCA.IBLEnable
		spnShadowsQuality.value = editCA.IBLQuality
		ddlShadowMode.selection = editCA.IBLShadows + 1
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalIBL.checked = editCA.overrideMentalGlobalTuningParams
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
	--@event: changed | Evento que se lanza al cambiar el radiobuttons.
	--@control: radiobuttons | rdoSkylightMode | Radiobuttons del modo IBL.
	--@gets: integer | state | Nuevo estado.
	------------------------------------------------
	on rdoSkylightMode changed state do
	(
		editCA.IBLEnable = (state == 2)
		updateUI()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | spnShadowsQuality | Spinner del valor de calidad de sombras de IBL.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnShadowsQuality changed value do
	(
		editCA.IBLQuality = value		
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el dropdownlist.
	--@control: dropdownlist | ddlShadowMode | Dropdown de modo de sombras de IBL.
	------------------------------------------------
	on ddlShadowMode selected index do
	(
		editCA.IBLShadows = index - 1
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideMentalIBL | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalIBL changed state do
	(
		editCA.overrideMentalIBL = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalIBLDef | rollout actual.
	------------------------------------------------
	on rollMentalIBLDef open do
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
	--@control: rollout | rollMentalIBLDef | rollout actual.
	------------------------------------------------
	on rollMentalIBLDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalIBLDef