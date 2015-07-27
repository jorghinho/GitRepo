------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. Caustics.
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalTranslatorOptionsDef | Rollout de causticas de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalTranslatorOptionsDef "Translator Options"
(
	------------------------------------------------------------------------------------------------
	--COMMON
	------------------------------------------------------------------------------------------------
	
	local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento.
	
	local editCA = undefined --@var : editCA| Variable de atajo para el CA de edit.

	------------------------------------------------------------------------------------------------
	--VARIABLES
	------------------------------------------------------------------------------------------------
	
	local materialEditorModeBckp = #basic --@var : materialEditorModeBckp | Modo del editor de materiales al abrirse para no perderlo.	
	local materialEditorSlotsBckp = undefined --@var : materialEditorSlotsBckp | Materiales que estaban almacenado en el slot 1 del editor de materiales para no perderlos.
	local materialEditorStateBckp = false --@var : materialEditorStateBckp | Estado de abierto/cerrado del editor de materiales.

	------------------------------------------------------------------------------------------------
	--CONTROLS
	------------------------------------------------------------------------------------------------
	
	--override active
	checkbox chkOverrideMentalTranslatorOptions "override" pos:[5,5] checked:false --@control | chkOverrideMentalTranslatorOptions | Indica si hacer override de esos parametros.

	groupBox grpMemoryOptions "Memory Options" pos:[5,25] width:327 height:60
		
	checkbox chkUsePlaceHolder "Use PlaceHolder Objects" pos:[15,45] width:150 height:15 checked:false
	checkbox chkUseMentalRayMapManager "Use Mental Ray Map Manager" pos:[15,65] width:180 height:15 checked:false
	checkbox chkConserveMemory "Conserve Memory" pos:[200,65] width:120 height:15 checked:false

	groupBox grpGeometryCaching "Geometry Caching" pos:[5,87] width:327 height:40
	
	checkbox chkEnableGeometryCaching "Enable" pos:[15,105] width:100 height:15 checked:false
	checkbutton ckbLock "Lock" pos:[240,105] width:80 height:15 checked:false

	groupBox grpMaterialOverride "Material Override" pos:[5,130] width:327 height:40
	
	checkbox chkEnableMaterialOverride "Enable" pos:[15,147] width:100 height:15 checked:false
	label lblMaterial "Material:" pos:[125,147] width:50 height:15
	checkbutton ckbMaterial "None" pos:[170,144] width:150 height:20 checked:false

	groupBox grpMapping "Mapping" pos:[5,173] width:327 height:40

	checkbox chkSkipMapsAndTextures "Skip Maps and Textures" pos:[15,192] width:200 height:15 checked:false
	
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
	--@fn: undefined | loadOverrideInfo | Hace Backup del editor de materiales.
	------------------------------------------------
	fn backupMaterialEditor =
	(
		--salva los estados de los materiales del editor de materiales y del mismo editor
		materialEditorModeBckp = MatEditor.mode
		materialEditorStateBckp = MatEditor.isOpen()
		materialEditorSlotsBckp = for i=1 to 24 collect meditMaterials[i]
		
		for i=1 to 24 do meditMaterials[i] = Standardmaterial()
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
		if not disableOnly then --si esta en el modo en que se permite habilitar y deshabilitar
		(
			for _cntrl in rollMentalTranslatorOptionsDef.controls where _cntrl.name != "chkOverrideMentalTranslatorOptions" do _cntrl.enabled = editCA.overrideMentalTranslatorOptions
			chkOverrideMentalTranslatorOptions.checked = editCA.overrideMentalTranslatorOptions
		)
		else if not editCA.overrideMentalTranslatorOptions then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalTranslatorOptionsDef.controls where _cntrl.name != "chkOverrideMentalTranslatorOptions" do _cntrl.enabled = false
			chkOverrideMentalTranslatorOptions.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		chkOverrideMentalTranslatorOptions.checked = editCA.overrideMentalTranslatorOptions

		chkUsePlaceHolder.checked = editCA.Use_Placeholders
		chkUseMentalRayMapManager.checked = editCA.mental_ray_Manages_Maps
		chkConserveMemory.checked = editCA.Conserve_Memory
		
		chkEnableGeometryCaching.checked = editCA.EnableGeometryCache
		ckbLock.enabled = editCA.EnableGeometryCache
		ckbLock.checked = editCA.LockGeometryCache

		chkEnableMaterialOverride.checked = editCA.Enable_Material_Override
		lblMaterial.enabled = ckbMaterial.enabled = editCA.Enable_Material_Override		
		ckbMaterial.caption = if editCA.Override_Material != undefined then editCA.Override_Material.name else "None"

		chkSkipMapsAndTextures.checked = editCA.Skip_Texture_Maps
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalTranslatorOptions.checked = editCA.overrideMentalTranslatorOptions
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
		for i=1 to 24 do meditMaterials[i] = materialEditorSlotsBckp[i] --restaura los materiales que habia en el editor
		medit.SetActiveMtlSlot 1 true
		MatEditor.close()
		MatEditor.mode = materialEditorModeBckp --restaura el modo del editor de materiales
		if materialEditorStateBckp then MatEditor.open() --si eleditor estaba abierto lo abre
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
	--@control: checkBox | chkUsePlaceHolder | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkUsePlaceHolder changed state do
	(
		editCA.Use_Placeholders = state		
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkUseMentalRayMapManager | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkUseMentalRayMapManager changed state do
	(
		editCA.mental_ray_Manages_Maps = state		
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkConserveMemory | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkConserveMemory changed state do
	(
		editCA.Conserve_Memory = state		
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkEnableGeometryCaching | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkEnableGeometryCaching changed state do
	(
		editCA.EnableGeometryCache = state
		updateUI()		
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkButton | ckbLock | checkButton que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on ckbLock changed state do
	(
		editCA.LockGeometryCache = state		
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkEnableMaterialOverride | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkEnableMaterialOverride changed state do
	(
		editCA.Enable_Material_Override = state
		updateUI()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkButton | ckbMaterial | checkButton que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on ckbMaterial changed state do
	(
		if state then
		(
			if materialEditorStateBckp then MatEditor.close() --si eleditor estaba abierto inicialmente lo cierra
			MatEditor.mode = #basic
			MatEditor.Open() --abre el editor de materiales para modificar el material de override
			setMeditMaterial 1 (if editCA.Override_Material != undefined then (copy editCA.Override_Material) else (Standardmaterial())) --coloca el material de override en el editor		
			medit.SetActiveMtlSlot 1 true
		)
		else
		(
			editCA.Override_Material = getMeditMaterial 1 --salva el nuevo material de override
			ckbMaterial.caption = editCA.Override_Material.name
			MatEditor.close()
			if materialEditorStateBckp then MatEditor.Open()
		)--if else
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkBox | chkSkipMapsAndTextures | checkBox que cambia de estado
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkSkipMapsAndTextures changed state do
	(
		editCA.Skip_Texture_Maps = state		
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideMentalTranslatorOptions | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalTranslatorOptions changed state do
	(
		editCA.overrideMentalTranslatorOptions = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalTranslatorOptionsDef | rollout actual.
	------------------------------------------------
	on rollMentalTranslatorOptionsDef open do
	(
		parent = lb.passManager.getCurrentEditInstance()
		editCA = parent.editBackupNode.custAttributes[#overrideRendererSettingsInfo]

		backupMaterialEditor()
		updateUI()
		
		loadSettings()
		createSceneEvents()

		resize() --redimensiona los componentes del UI una vez abierto
	)
	
	------------------------------------------------
	--@event: close | Evento lanzado al cerrarse el rollout.
	--@control: rollout | rollMentalTranslatorOptionsDef | rollout actual.
	------------------------------------------------
	on rollMentalTranslatorOptionsDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalTranslatorOptionsDef