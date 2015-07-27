------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. Reuse Final Gather.
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalReuseFGDef | Rollout de Rautilizacion de calculos de Final Gather de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalReuseFGDef "Reuse (FG and GI Disk Caching)"
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
	checkbox chkOverrideMentalReuseFG "override" pos:[5,5] checked:false --@control | chkOverrideMentalReuseFG | Indica si hacer override de esos parametros.

	groupbox grpMode "Mode" pos:[5,25] width:327 height:60
	dropdownList ddlMode "" pos:[13,40] height:20 width:312 items:#("Single File Only (Best for Walkthrough and Stills", "One File Per Frame (Best For Animated Objects)")
	checkBox chkSkipFinalRender "Calculate FG/GI and Skip Final Rendering" pos:[15,65] checked:false
	
	groupbox grpFGmap "Final Gather Map" pos:[5,90] width:327 height:85
	dropdownList ddlFinalGatherMap "" pos:[13,105] height:20 width:312 items:#("Off (Do not Cache Map to Disk)", "Incrementally Add FG Points to FG Map Files", "Read FG Points Only from Existing FG Map Files")
	spinner spnInterpolateFrames "Interpolate Over N Frames" pos:[133,130] fieldWidth:50 height:15 range:[1,1000000,2] type:#integer enabled:false
	button btnFGmapChange "..." pos:[15,150] width:20 height:17 enabled:false
	edittext edtFGfile "" pos:[33,150] width:270 readOnly:true enabled:false
	button btnFGmapDelete "X" pos:[305,150] width:20 height:17 enabled:false
	
	groupbox grpCausticsMap "Caustics and Global Illumination Photon Map" pos:[5,180] width:327 height:65
	dropdownList ddlCausticsMap "" pos:[13,195] height:20 width:312 items:#("Off (Do not Cache Map to Disk)", "Read/Write Photons to Photon Map Files", "Read Photons Only from Existing Photon Map Files")
	button btnCusticsMapChange "..." pos:[15,220] width:20 height:17 enabled:false
	edittext edtCausticsFile "" pos:[33,220] width:270 readOnly:true enabled:false
	button btnCausticsDelete "X" pos:[305,220] width:20 height:17 enabled:false

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
			for _cntrl in rollMentalReuseFGDef.controls where _cntrl.name != "chkOverrideMentalReuseFG" do _cntrl.enabled = editCA.overrideMentalReuseFG
			chkOverrideMentalReuseFG.checked = editCA.overrideMentalReuseFG
		)
		else if not editCA.overrideMentalReuseFG then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalReuseFGDef.controls where _cntrl.name != "chkOverrideMentalReuseFG" do _cntrl.enabled = false
			chkOverrideMentalReuseFG.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		------------------------------------------------
		ddlMode.selection = (editCA.IlluminationCacheMode + 1)
		chkSkipFinalRender.checked = editCA.SkipFinalRender
		------------------------------------------------
		
		------------------------------------------------
		if not editCA.UseFinalGatherFile then ddlFinalGatherMap.selection = 1
		else if not editCA.FinalGatherFreeze then ddlFinalGatherMap.selection = 2
		else ddlFinalGatherMap.selection = 3
		
		spnInterpolateFrames.value = editCA.FGInterpolateNFrames
		edtFGfile.text = editCA.FinalGatherFilename
		
		spnInterpolateFrames.enabled = (ddlFinalGatherMap.selection == 3) and (not chkSkipFinalRender.checked) and (ddlMode.selection == 2)
		btnFGmapChange.enabled = ddlFinalGatherMap.selection != 1
		edtFGfile.enabled = ddlFinalGatherMap.selection != 1
		btnFGmapDelete.enabled = ddlFinalGatherMap.selection != 1
		------------------------------------------------
		
		------------------------------------------------
		if not editCA.PhotonMapUseFile then ddlCausticsMap.selection = 1
		else if not editCA.PhotonFreeze then ddlCausticsMap.selection = 2
		else ddlCausticsMap.selection = 3
		
		edtCausticsFile.text = editCA.PhotonMapFilename
		
		btnCusticsMapChange.enabled = ddlCausticsMap.selection != 1
		edtCausticsFile.enabled = ddlCausticsMap.selection != 1
		btnCausticsDelete.enabled = ddlCausticsMap.selection != 1
		------------------------------------------------
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalReuseFG.checked = editCA.overrideMentalReuseFG
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
	--@event: selected | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | ddlMode | Dropdown que cambia de seleccion
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlMode selected index do
	(
		editCA.IlluminationCacheMode = (index - 1)
		updateUI()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkSkipFinalRender | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkSkipFinalRender changed state do
	(
		editCA.SkipFinalRender = state
		updateUI()
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | ddlFinalGatherMap | Dropdown que cambia de seleccion
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlFinalGatherMap selected index do
	(
		case index of
		(
			1:
			(
				editCA.UseFinalGatherFile = false
			)
			
			2:
			(
				editCA.UseFinalGatherFile = true
				editCA.FinalGatherFreeze = false
			)
			
			3:
			(
				editCA.UseFinalGatherFile = true
				editCA.FinalGatherFreeze = true
			)
		)--case
		
		--spnInterpolateFrames.enabled = ddlFinalGatherMap.selection != 1
		--btnFGmapChange.enabled = ddlFinalGatherMap.selection != 1
		--edtFGfile.enabled = ddlFinalGatherMap.selection != 1
		--btnFGmapDelete.enabled = ddlFinalGatherMap.selection != 1

		updateUI()
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnInterpolateFrames | spinner que cambia de valor.
	--@gets: integer | vale | Nuevo valor.
	------------------------------------------------
	on spnInterpolateFrames changed val do
	(
		editCA.FGInterpolateNFrames = val
	)
	
	------------------------------------------------
	--@event: pressed | Evento que se lanza al presionar el boton.
	--@control: button | btnFGmapChange | Boton presionado.
	------------------------------------------------
	on btnFGmapChange pressed do
	(
		_fgMapFile = editCA.FinalGatherFilename
		if ddlFinalGatherMap.selection == 2 then _fgMapFile = getSaveFileName filename:_fgMapFile types:"Final Gather Maps (*.fgm)|*.fgm|"
		else _fgMapFile = getOpenFileName filename:_fgMapFile types:"Final Gather Maps (*.fgm)|*.fgm|"
		
		if _fgMapFile != undefined and _fgMapFile != "" then
		(
			editCA.FinalGatherFilename = _fgMapFile
			--edtFGfile.text = _fgMapFile
		)--if

		updateUI()
	)
	
	------------------------------------------------
	--@event: pressed | Evento que se lanza al presionar el boton.
	--@control: button | btnFGmapDelete | Boton presionado.
	------------------------------------------------
	on btnFGmapDelete pressed do
	(
		editCA.FinalGatherFilename = ""
		--edtFGfile.text = ""
		updateUI()
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar el spinner.
	--@control: dropdownlist | ddlFinalGatherMap | Dropdown que cambia de seleccion
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlCausticsMap selected index do
	(
		case index of
		(
			1:
			(
				editCA.PhotonMapUseFile = false
			)
			
			2:
			(
				editCA.PhotonMapUseFile = true
				editCA.PhotonFreeze = false
			)
			
			3:
			(
				editCA.PhotonMapUseFile = true
				editCA.PhotonFreeze = true
			)
		)--case
		
		--btnCusticsMapChange.enabled = ddlCausticsMap.selection != 1
		--edtCausticsFile.enabled = ddlCausticsMap.selection != 1
		--btnCausticsDelete.enabled = ddlCausticsMap.selection != 1

		updateUI()
	)
	
	------------------------------------------------
	--@event: pressed | Evento que se lanza al presionar el boton.
	--@control: button | btnCusticsMapChange | Boton presionado.
	------------------------------------------------
	on btnCusticsMapChange pressed do
	(
		_casuticsMap = editCA.PhotonMapFilename
		if ddlCausticsMap.selection == 2 then _casuticsMap = getSaveFileName filename:_casuticsMap types:"Photon Maps (*.pmap)|*.pmap|"
		else _casuticsMap = getOpenFileName filename:_casuticsMap types:"Photon Maps (*.pmap)|*.pmap|"
		
		if _casuticsMap != undefined and _casuticsMap != "" then
		(
			editCA.PhotonMapFilename = _casuticsMap
			--edtCausticsFile.text = _casuticsMap
		)--if

		updateUI()
	)
	
	------------------------------------------------
	--@event: pressed | Evento que se lanza al presionar el boton.
	--@control: button | btnCausticsDelete | Boton presionado.
	------------------------------------------------
	on btnCausticsDelete pressed do
	(
		editCA.PhotonMapFilename = ""
		--edtCausticsFile.text = ""
		updateUI()
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideMentalReuseFG | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalReuseFG changed state do
	(
		editCA.overrideMentalReuseFG = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalReuseFGDef | rollout actual.
	------------------------------------------------
	on rollMentalReuseFGDef open do
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
	--@control: rollout | rollMentalReuseFGDef | rollout actual.
	------------------------------------------------
	on rollMentalReuseFGDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalReuseFGDef