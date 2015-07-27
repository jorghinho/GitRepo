------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. Rendering Algorithms
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalShadowsAndDisplacementDef | Rollout de Global Tuning Params de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalShadowsAndDisplacementDef "Shadows & Displacement"
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
	checkbox chkOverrideMentalShadowsAndDisplacement "override" pos:[5,5] checked:false --@control | chkOverrideMentalShadowsAndDisplacement | Indica si hacer override de esos parametros.

	--Shadows
	groupBox grpShadows "Shadows" pos:[5,25] width:327 height:125
	checkbox chkShadowsEnable "Enable" pos:[13,45]
	label lblShadowMethod "Mode: " pos:[210,45] width:35
	dropdownlist ddlShadowMethod "" pos:[245,42] width:80 items:#("Simple", "Sort", "Segments")

	groupBox grpShadowMaps "Shadow Maps" pos:[10,65] width:317 height:80
	checkbox chkEnableShadowMaps "Enable" pos:[18,85]
	checkbox chkMotionBlurShadowMapsEnable "Motion Blur" pos:[245,85]
	checkbox chkShadowMapRebuild "Rebuild (Do Not Re-Use Cache)" pos:[18,103]
	checkbox chkUseShadowMapFile "Use File" pos:[18,121] width:60
	button btnGetShadowMapFile "..." pos:[78,120] width:17 height:17
	label lblShadowMapFile "" pos:[95,121] width:207 height:16 style_sunkenedge:true
	button btnClearShadowMapFile "X" pos:[302,120] width:17 height:17

	--Displacement
	groupBox grpDisplacement "Displacement (Global Settings)" pos:[5,155] width:327 height:80
	checkbox chkView "View" pos:[13,175]
	checkbox chkSmooth "Smoothing" pos:[245,175]
	label lblEdgeLength "Edge Length: " pos:[14,195] width:70
	spinner spnEdgeLength "" pos:[85,195] width:65 range:[0,1000000,2] type:#float scale:0.01
	label lblEdgeLengthUnits "pixels" pos:[155,195] width:70
	label lblMaxDisplace "Max. Displace: " pos:[14,215] width:70
	spinner spnMaxDisplace "" pos:[85,215] width:65 range:[0,1000000,20] type:#float scale:0.01
	label lblMaxLevel "Max. Subdiv:" pos:[175,215] width:70
	dropdownlist ddlMaxLevel "" pos:[245,211] width:80 items:#("4", "16", "64", "256", "1K", "4K", "16K", "64K")

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
			for _cntrl in rollMentalShadowsAndDisplacementDef.controls where _cntrl.name != "chkOverrideMentalShadowsAndDisplacement" do _cntrl.enabled = editCA.overrideMentalShadowsAndDisplacement
			chkOverrideMentalShadowsAndDisplacement.checked = editCA.overrideMentalShadowsAndDisplacement
		)
		else if not editCA.overrideMentalShadowsAndDisplacement then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalShadowsAndDisplacementDef.controls where _cntrl.name != "chkOverrideMentalShadowsAndDisplacement" do _cntrl.enabled = false
			chkOverrideMentalShadowsAndDisplacement.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		--Shadows
		lblShadowMethod.enabled = ddlShadowMethod.enabled = editCA.ShadowsEnable
		grpShadowMaps.enabled = chkEnableShadowMaps.enabled = editCA.ShadowsEnable
		chkMotionBlurShadowMapsEnable.enabled = chkShadowMapRebuild.enabled = editCA.EnableShadowMaps and editCA.ShadowsEnable	
		btnGetShadowMapFile.enabled = lblShadowMapFile.enabled = editCA.EnableShadowMaps and editCA.ShadowsEnable
		chkUseShadowMapFile.enabled = btnClearShadowMapFile.enabled = (editCA.EnableShadowMaps and editCA.ShadowsEnable) and (editCA.ShadowMapFilename != "")

		chkShadowsEnable.checked = editCA.ShadowsEnable
		ddlShadowMethod.selection = (editCA.ShadowMethod + 1)
		chkEnableShadowMaps.checked = editCA.EnableShadowMaps
		chkMotionBlurShadowMapsEnable.checked = editCA.MotionBlurShadowMapsEnable
		chkShadowMapRebuild.checked = editCA.ShadowMapRebuild
		chkUseShadowMapFile.checked = editCA.UseShadowMapFile
		lblShadowMapFile.caption = editCA.ShadowMapFilename

		--Displacement
		chkView.checked = editCA.view
		chkSmooth.checked = editCA.Smooth
		spnEdgeLength.value = editCA.Edge_Length
		lblEdgeLengthUnits.caption = if editCA.view then "pixels" else "cm"
		spnMaxDisplace.value = editCA.Max_Displace
		ddlMaxLevel.selection = (editCA.Max_Level + 1)
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalShadowsAndDisplacement.checked = editCA.overrideMentalShadowsAndDisplacement
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
		parent.rollMentalRenderingAlgorithms.updateUI()
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
	--@control: checkbox | chkShadowsEnable | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkShadowsEnable changed state do
	(
		editCA.ShadowsEnable = state
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | ddlShadowMethod | Dropdown de metodo de sombras.
	--@gets: integer | index | Indice del elemento seleccionado
	------------------------------------------------
	on ddlShadowMethod selected index do
	(
		if index != 3 and editCA.Autovolume then
		(
			_process = queryBox "Autovolume requires the following options:\n\n  scanline off\n  raytracing on\n  shadow mode: segments\n\nChanging this option will disable autovolume. Continue?"
			
			if not _process then index = (editCA.ShadowMethod + 1)
			else editCA.Autovolume = false
		)--if

		editCA.ShadowMethod = (index - 1)
		loadOverrideInfo()
		updateRelatedRollouts()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkEnableShadowMaps | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkEnableShadowMaps changed state do
	(
		editCA.EnableShadowMaps = state
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkMotionBlurShadowMapsEnable | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkMotionBlurShadowMapsEnable changed state do
	(
		editCA.MotionBlurShadowMapsEnable = state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkShadowMapRebuild | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkShadowMapRebuild changed state do
	(
		editCA.ShadowMapRebuild = state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkUseShadowMapFile | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkUseShadowMapFile changed state do
	(
		editCA.UseShadowMapFile = state
	)

	------------------------------------------------
	--@event: pressed | Evento que se lanza al presionar el boton.
	--@control: button | btnGetShadowMapFile | Boton presionado.
	------------------------------------------------
	on btnGetShadowMapFile pressed do
	(
		_filename = getSaveFileName caption:"Shadow Map File" filename:editCA.ShadowMapFilename types:"Shadow Maps (*.zt) | *.zt*"
		if _filename != undefined then
		(
			_simpleFileName = (getFilenamePath _filename) + (FilterString (getFilenameFile _filename) "_")[1] + ".zt"			
			editCA.ShadowMapFilename = _simpleFileName
		)

		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: pressed | Evento que se lanza al presionar el boton.
	--@control: button | btnClearShadowMapFile | Boton presionado.
	------------------------------------------------
	on btnClearShadowMapFile pressed do
	(
		editCA.ShadowMapFilename = ""
		editCA.UseShadowMapFile = false
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkView | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkView changed state do
	(
		editCA.view = state
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkSmooth | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkSmooth changed state do
	(
		editCA.Smooth = state
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnEdgeLength | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnEdgeLength changed value do
	(
		editCA.Edge_Length = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMaxDisplace | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnMaxDisplace changed value do
	(
		editCA.Max_Displace = value
	)

	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlMaxLevel | Dropdown de nivel de displacement.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlMaxLevel selected index do
	(
		editCA.Max_Level = (index - 1)
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkOverrideMentalShadowsAndDisplacement | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalShadowsAndDisplacement changed state do
	(
		editCA.overrideMentalShadowsAndDisplacement = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalShadowsAndDisplacementDef | rollout actual.
	------------------------------------------------
	on rollMentalShadowsAndDisplacementDef open do
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
	--@control: rollout | rollMentalShadowsAndDisplacementDef | rollout actual.
	------------------------------------------------
	on rollMentalShadowsAndDisplacementDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalShadowsAndDisplacementDef