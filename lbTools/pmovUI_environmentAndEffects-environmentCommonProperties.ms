------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de environment and effects. Environment. Common Properties.
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollEnvironmentCommonPropertiesDef | Rollout de Common Properties de Environment.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollEnvironmentCommonPropertiesDef "Common Parameters"
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

	local lastEditMap = undefined
	local lastEditControl = undefined

	local contourContrastItems = #("None", "Contour Contrast Function Levels")
	local contourStoreItems = #("None", "Contour Store Function")
	local contourOutputItems = #("None", "Contour Composite", "Contour Only", "Contour Post Script")

	local cameraLensItems = #("None", "Depth of Field / Bokeh", "Distortion", "Gamma & Gain", "mr Physical Sky", "Night", "Render Subset of Scene/Masking", "Shader List (Lens)", "WrapAround")
	local cameraOutputItems = #("None", "Glare", "HDR Image Motion Blur", "Motion Vector Export", "Shader List (Output)")
	local cameraVolumeItems = #("None", "Beam", "Material to Shader", "Mist", "mr Physical Sky", "Parti Volume", "Shader List (Volume)", "Submerge")

	------------------------------------------------------------------------------------------------
	--CONTROLS
	------------------------------------------------------------------------------------------------
	
	--override active
	checkbox chkOverrideCommonProperties "override" pos:[5,5] checked:false --@control | chkOverrideMentalCameraEffects | Indica si hacer override de esos parametros.
	
	groupBox grpBackground "Background:" pos:[5,25] width:327 height:70
	label lblColor "Color:" pos:[15,48]
	colorpicker clrColor pos:[15,68] color:[0,0,0] width:60 height:20
	
	label lblEnvironmentMap "Environment Map:" pos:[88,48]
	checkbox chkUseMap "Use Map" pos:[250,48]
	checkbutton ckbEnvironmentMap "None" pos:[88,68] width:235 height:20
	
	groupBox grpGlobalLighting "Global Lighting:" pos:[5,95] width:327 height:70
	label lblTint "Tint:" pos:[15,118]
	colorpicker clrTint pos:[15,138] color:[255,255,255] width:60 height:20
	
	label lblLevel "Level:" pos:[100,118]
	spinner spnLevel "" pos:[100,140] width:70 height:20 range:[0.0,9999.0,0.1] type:#float scale:0.1 height:20
	
	label lblAmbient "Ambient:" pos:[250,118]
	colorpicker clrAmbient pos:[247,138] color:[0,0,0] width:60 height:20
	

	------------------------------------------------------------------------------------------------
	--FUNCTIONS
	------------------------------------------------------------------------------------------------
	------------------------------------------------
	--@fn: undefined | matEditorBackup | Hace backup del editor de materiales.
	------------------------------------------------
	fn matEditorBackup =
	(
		--salva los estados de los materiales del editor de materiales y del mismo editor
		materialEditorModeBckp = MatEditor.mode
		materialEditorStateBckp = MatEditor.isOpen()
		materialEditorSlotsBckp = for i=1 to 24 collect meditMaterials[i]
		
		for i=1 to 24 do meditMaterials[i] = Standardmaterial()
	)

	------------------------------------------------
	--@fn: undefined | matEditorRestore | Hace restore del editor de materiales.
	------------------------------------------------
	fn matEditorRestore =
	(
		for i=1 to 24 do meditMaterials[i] = materialEditorSlotsBckp[i] --restaura los materiales que habia en el editor
		medit.SetActiveMtlSlot 1 true
		MatEditor.close()
		MatEditor.mode = materialEditorModeBckp --restaura el modo del editor de materiales
		if materialEditorStateBckp then MatEditor.open() --si eleditor estaba abierto lo abre
	)
	
	------------------------------------------------
	--@fn: undefined | editMap | Edita el mapa solicitado.
	--@gets: name | mapClass | Opcion de mapa solicitado para saber que control y mama editar
	------------------------------------------------
	fn editMap mapClass state =
	(
		_updateDropDownStates = true
	
		if state then
		(
			_process = false
			
			case mapClass of
			(
				#environmentMap: (if editCA.environmentMap != undefined then _process = true)
			)--case
			
			if _process then
			(
				if mapClass != #environmentMap and ckbEnvironmentMap.checked then
				(
					editCA.environmentMap = getMeditMaterial 1
					ckbEnvironmentMap.checked = false
				)--if
				
				if materialEditorStateBckp then MatEditor.close() --si eleditor estaba abierto inicialmente lo cierra
				MatEditor.mode = #basic
				MatEditor.Open() --abre el editor de materiales para modificar el material de override
				
				case mapClass of
				(
					#environmentMap: setMeditMaterial 1 (copy editCA.environmentMap)
				)--case
				
				medit.SetActiveMtlSlot 1 true
			)
			else
			(
				case mapClass of
				(
					#environmentMap: ckbEnvironmentMap.checked = false
				)--case
			)--if else
		)
		else
		(
			case mapClass of
			(
				#environmentMap: (editCA.environmentMap = getMeditMaterial 1; ckbEnvironmentMap.checked = false)
			)--case

			MatEditor.close()
			if materialEditorStateBckp then MatEditor.Open()		
		)--if else
	)
	
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
			for _cntrl in rollEnvironmentCommonPropertiesDef.controls where _cntrl.name != "chkOverrideCommonProperties" do _cntrl.enabled = editCA.overrideEnvironmentCommonProperties
			chkOverrideCommonProperties.checked = editCA.overrideEnvironmentCommonProperties
		)
		else if not editCA.overrideEnvironmentCommonProperties then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollEnvironmentCommonPropertiesDef.controls where _cntrl.name != "chkOverrideCommonProperties" do _cntrl.enabled = false
			chkOverrideCommonProperties.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		clrColor.color = editCA.backgroundColor
		chkUseMap.checked = editCA.useEnvironmentMap
		if editCA.environmentMap != undefined then
			ckbEnvironmentMap.caption = editCA.environmentMap.name
		else
			ckbEnvironmentMap.caption = "None"
		
		clrTint.color = editCA.lightTintColor
		spnLevel.value = editCA.lightLevel
		clrAmbient.color = editCA.ambientColor
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(		
		chkOverrideCommonProperties.checked = editCA.overrideEnvironmentCommonProperties
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
	--COMMON
	------------------------------------------------
	
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al modificar el spinner de Level.
	--@control: spinner | spnLevel | Spinner de level.
	--@gets: float | newValue | Nuevo valor del spinner
	------------------------------------------------
	on spnLevel changed newValue do
	(
		editCA.lightLevel = newValue
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: colorpicker | clrColor | Selector de color de background color
	--@gets: Color | newColor | Nuevo color
	------------------------------------------------
	on clrColor changed newColor do
	(
		editCA.backgroundColor = newColor
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: colorpicker | clrAmbient | Selector de color de ambient
	--@gets: Color | newColor | Nuevo color
	------------------------------------------------
	on clrAmbient changed newColor do
	(
		editCA.ambientColor = newColor
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: colorpicker | clrTint | Selector de color de tint
	--@gets: Color | newColor | Nuevo color
	------------------------------------------------
	on clrTint changed newColor do
	(
		editCA.lightTintColor = newColor
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al marcar el checkbutton de use map
	--@control: checkButton | chkUseMap | Checkbox de use map
	--@gets: boolean | newState | Nuevo estado del botón
	------------------------------------------------
	on chkUseMap changed newState do
	(
		editCA.useEnvironmentMap = newState
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: checkbutton | ckbEnvironmentMap | Boton para elegir mapa.
	--@gets: boolean | state | Estado presionado o no.
	------------------------------------------------
	on ckbEnvironmentMap changed state do
	(
		--editMap #environmentMap state
		if state then
		(
			if materialEditorStateBckp then MatEditor.close() --si eleditor estaba abierto inicialmente lo cierra
			MatEditor.mode = #basic
			MatEditor.Open() --abre el editor de materiales para modificar el material de override
			setMeditMaterial 1 (if editCA.environmentMap != undefined then (copy editCA.environmentMap) else (Bitmaptexture())) --coloca el mapa de override en el editor		
			medit.SetActiveMtlSlot 1 true
		)
		else
		(
			if superClassOf (getMeditMaterial 1) == textureMap then
			(
				editCA.environmentMap = getMeditMaterial 1 --salva el nuevo mapa de override
				ckbEnvironmentMap.caption = editCA.environmentMap.name
			)--if
			else
			(
				lb.message.show "Only maps are allowed, not materials. Create a map on the first slot of Material Editor." type:#message pos:undefined modal:true
			)
			
			MatEditor.close()
			if materialEditorStateBckp then MatEditor.Open()
		)--if else
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkOverrideMentalCameraEffects | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideCommonProperties changed state do
	(
		editCA.overrideEnvironmentCommonProperties = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalCameraEffectsDef | rollout actual.
	------------------------------------------------
	on rollEnvironmentCommonPropertiesDef open do
	(
		parent = lb.passManager.getCurrentEditInstance()
		editCA = parent.editBackupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]
		
		matEditorBackup()
		updateUI()
		
		loadSettings()
		createSceneEvents()
		
		resize() --redimensiona los componentes del UI una vez abierto
	)
	
	------------------------------------------------
	--@event: close | Evento lanzado al cerrarse el rollout.
	--@control: rollout | rollMentalCameraEffectsDef | rollout actual.
	------------------------------------------------
	on rollEnvironmentCommonPropertiesDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		matEditorRestore()
		saveSettings()		
	)
)--rollEnvironmentCommonPropertiesDef