------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. Rendering Algorithms
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalCameraEffectsDef | Rollout de Global Tuning Params de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalCameraEffectsDef "Camera Effects"
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
	checkbox chkOverrideMentalCameraEffects "override" pos:[5,5] checked:false --@control | chkOverrideMentalCameraEffects | Indica si hacer override de esos parametros.

	--Motion Blur
	groupBox grpMotionBlur "Motion Blur" pos:[5,25] width:327 height:125
	
	checkbox chkMotionBlurEnable "Enable" pos:[13,45]
	checkbox chkBlurAllObjects "Blur All Objects" pos:[235,45]
	
	label lblShutterDuration "Shutter Duration (frames): " pos:[32,65]
	spinner spnShutterDuration "" pos:[235,65] width:90 range:[0.0,100000000.0,0.5] type:#float scale:0.1
	
	label lblShutterOffset "Shutter Offset (frames): " pos:[32,85]
	spinner spnShutterOffset "" pos:[235,85] width:90 range:[-100000000.0,100000000.0,0.25] type:#float scale:0.1
	
	label lblMotionSegments "Motion Segments: " pos:[32,105]
	spinner spnMotionSegments "" pos:[235,105] width:90 range:[1,15,1] type:#integer scale:1
	
	label lblTimeSamples "Time Samples: " pos:[32,125] width:200
	spinner spnTimeSamples "" pos:[235,125] width:90 range:[0,100,5] type:#integer scale:1
	spinner spnRapidMotionResample "" pos:[235,125] width:90 range:[1,128,1] type:#integer scale:1


	--Contours
	groupBox grpContours "Contours" pos:[5,150] width:327 height:105
	
	checkbox chkContoursEnable "Enable" pos:[13,170]
	
	label lblContourContrast "Contour Contrast:" pos:[32,190]
	dropdownlist ddlContourContrast pos:[125,188] width:160 items:contourContrastItems
	checkbutton ckbContourContrast "Edit" pos:[285,188] width:40 height:20
	
	label lblContourStore "Contour Store:" pos:[32,210]
	dropdownlist ddlContourStore pos:[125,208] width:160 items:contourStoreItems
	checkbutton ckbContourStore "Edit" pos:[285,208] width:40 height:20
	
	label lblContourOutput "Contour Output:" pos:[32,230]
	dropdownlist ddlContourOutput pos:[125,228] width:160 items:contourOutputItems
	checkbutton ckbContourOutput "Edit" pos:[285,228] width:40 height:20


	--Camera Shaders
	groupBox grpCameraShaders "Camera Shaders" pos:[5,255] width:327 height:87

	checkbox chkCameraLens "Lens" pos:[13,277]
	dropdownlist ddlCameraLens pos:[125,275] width:160 items:cameraLensItems
	checkbutton ckbCameraLens "Edit" pos:[285,275] width:40 height:20

	checkbox chkCameraOutput "Output" pos:[13,297]
	dropdownlist ddlCameraOutput pos:[125,295] width:160 items:cameraOutputItems
	checkbutton ckbCameraOutput "Edit" pos:[285,295] width:40 height:20

	checkbox chkCameraVolume "Volume" pos:[13,317]
	dropdownlist ddlCameraVolume pos:[125,315] width:160 items:cameraVolumeItems
	checkbutton ckbCameraVolume "Edit" pos:[285,315] width:40 height:20


	--Depth of Field
	groupBox grpDepthOfField "Depth of Field (Perspective Views Only)" pos:[5,343] width:327 height:87

	checkbox chkDepthOfFieldEnable "Enable" pos:[13,363]
	dropdownlist ddlDepthOfFieldMode pos:[13,383] width:110 items:#("f-Stop", "In Focus Limits")
	label lblFstop "f-Stop: " pos:[15,405] width:40
	spinner spnFstop "" pos:[50,405] width:72 range:[0,100,1] type:#float scale:0.01
	label lblNear "Near: " pos:[15,405] width:40
	spinner spnNearFocus "" pos:[50,405] width:72 range:[0,100000000,90] type:#float scale:0.01
	label lblFocusPlane "Focus Plane: " pos:[170,385] width:80
	spinner spnFocusPlane "" pos:[250,385] width:75 range:[0,100000000,100] type:#float scale:0.01
	label lblFarFocus "Far: " pos:[170,405] width:80
	spinner spnFarFocus "" pos:[250,405] width:75 range:[0,100000000,110] type:#float scale:0.01

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
				#contourContrast: (if editCA.Contour_Contrast_Shader != undefined then _process = true)
				#contourStore: (if editCA.Contour_Store_Shader != undefined then _process = true)
				#contourOutput: (if editCA.Contour_Output_Shader != undefined then _process = true)

				#cameraLens: (if editCA.Camera_Lens_Shader != undefined then _process = true)
				#cameraOutput: (if editCA.Camera_Output_Shader != undefined then _process = true)
				#cameraVolume: (if editCA.Camera_Volume_Shader != undefined then _process = true)
			)--case

			if _process then
			(
				if mapClass != #contourContrast and ckbContourContrast.checked then
				(
					editCA.Contour_Contrast_Shader = getMeditMaterial 1
					ckbContourContrast.checked = false
				)--if

				if mapClass != #contourStore and ckbContourStore.checked then
				(
					editCA.Contour_Store_Shader = getMeditMaterial 1
					ckbContourStore.checked = false
				)--if

				if mapClass != #contourOutput and ckbContourOutput.checked then
				(
					editCA.Contour_Output_Shader = getMeditMaterial 1
					ckbContourOutput.checked = false
				)--if


				if mapClass != #cameraLens and ckbCameraLens.checked then
				(
					editCA.Camera_Lens_Shader = getMeditMaterial 1
					ckbCameraLens.checked = false
				)--if

				if mapClass != #cameraOutput and ckbCameraOutput.checked then
				(
					editCA.Camera_Output_Shader = getMeditMaterial 1
					ckbCameraOutput.checked = false
				)--if

				if mapClass != #cameraVolume and ckbCameraVolume.checked then
				(
					editCA.Camera_Volume_Shader = getMeditMaterial 1
					ckbCameraVolume.checked = false
				)--if


				if materialEditorStateBckp then MatEditor.close() --si eleditor estaba abierto inicialmente lo cierra
				MatEditor.mode = #basic
				MatEditor.Open() --abre el editor de materiales para modificar el material de override
				
				case mapClass of
				(
					#contourContrast: setMeditMaterial 1 (copy editCA.Contour_Contrast_Shader)
					#contourStore: setMeditMaterial 1 (copy editCA.Contour_Store_Shader)
					#contourOutput: setMeditMaterial 1 (copy editCA.Contour_Output_Shader)

					#cameraLens: setMeditMaterial 1 (copy editCA.Camera_Lens_Shader)
					#cameraOutput: setMeditMaterial 1 (copy editCA.Camera_Output_Shader)
					#cameraVolume: setMeditMaterial 1 (copy editCA.Camera_Volume_Shader)
				)--case

				medit.SetActiveMtlSlot 1 true
			)
			else
			(
				case mapClass of
				(
					#contourContrast: ckbContourContrast.checked = false
					#contourStore: ckbContourStore.checked = false
					#contourOutput: ckbContourOutput.checked = false

					#cameraLens: ckbCameraLens.checked = false
					#cameraOutput: ckbCameraOutput.checked = false
					#cameraVolume: ckbCameraVolume.checked = false
				)--case

				_updateDropDownStates = false
			)--if else
		)
		else
		(
			case mapClass of
			(
				#contourContrast: (editCA.Contour_Contrast_Shader = getMeditMaterial 1; ckbContourContrast.checked = false)
				#contourStore: (editCA.Contour_Store_Shader = getMeditMaterial 1; ckbContourStore.checked = false)
				#contourOutput: (editCA.Contour_Output_Shader = getMeditMaterial 1; ckbContourOutput.checked = false)

				#cameraLens: (editCA.Camera_Lens_Shader = getMeditMaterial 1; ckbCameraLens.checked = false)
				#cameraOutput: (editCA.Camera_Output_Shader = getMeditMaterial 1; ckbCameraOutput.checked = false)
				#cameraVolume: (editCA.Camera_Volume_Shader = getMeditMaterial 1; ckbCameraVolume.checked = false)
			)--case

			MatEditor.close()
			if materialEditorStateBckp then MatEditor.Open()		
		)--if else

		if _updateDropDownStates then
		(
			ddlContourContrast.enabled = not state
			ddlContourStore.enabled = not state
			ddlContourOutput.enabled = not state

			ddlCameraLens.enabled = not state
			ddlCameraOutput.enabled = not state
			ddlCameraVolume.enabled = not state
		)--if
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
			for _cntrl in rollMentalCameraEffectsDef.controls where _cntrl.name != "chkOverrideMentalCameraEffects" do _cntrl.enabled = editCA.overrideMentalCameraEffects
			chkOverrideMentalCameraEffects.checked = editCA.overrideMentalCameraEffects
		)
		else if not editCA.overrideMentalCameraEffects then --so solo se permite desahbilitar. Solo entra si está desactivado el override
		(
			for _cntrl in rollMentalCameraEffectsDef.controls where _cntrl.name != "chkOverrideMentalCameraEffects" do _cntrl.enabled = false
			chkOverrideMentalCameraEffects.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		------------------------------------------------
		--Motion Blur

		chkMotionBlurEnable.checked = editCA.MotionBlurEnable
		

		chkBlurAllObjects.enabled = editCA.MotionBlurEnable and editCA.overrideMentalCameraEffects
		chkBlurAllObjects.checked = editCA.MotionBlurAllObjects

		lblShutterDuration.enabled = spnShutterDuration.enabled = editCA.MotionBlurEnable and editCA.overrideMentalCameraEffects
		spnShutterDuration.value = editCA.Shutter

		lblShutterOffset.enabled = spnShutterOffset.enabled = editCA.MotionBlurEnable and editCA.overrideMentalCameraEffects
		spnShutterOffset.value = editCA.MotionBlurOffset

		lblMotionSegments.enabled = spnMotionSegments.enabled = editCA.MotionBlurEnable and editCA.overrideMentalCameraEffects
		spnMotionSegments.value = editCA.Segments

		lblTimeSamples.enabled = spnTimeSamples.enabled = spnRapidMotionResample.enabled = editCA.MotionBlurEnable and editCA.overrideMentalCameraEffects
		if editCA.MotionBlurEnable then
		(
			_process = true

			_unifiedEnable = editCA.UnifiedEnable
			_scanlineEnable = editCA.ScanlineEnable

			if not editCA.overrideMentalSamplingQuality then
			(
				if classof renderers.current != mental_ray_renderer then
					_process = false
				else
				(
					_unifiedEnable = renderers.current.UnifiedEnable
					_scanlineEnable = renderers.current.ScanlineEnable
				)--if else
			)--if

			if _process then
			(
				if _unifiedEnable then --Unified / Raytraced
				(
					lblTimeSamples.enabled = false
					lblTimeSamples.caption = "Time Samples:"
					spnTimeSamples.enabled = false
					spnTimeSamples.visible = true
					spnRapidMotionResample.visible = false
				)
				else if _scanlineEnable then --Rasterizer / Scanline
				(
					lblTimeSamples.enabled = true
					lblTimeSamples.caption = "Time Samples (Fast Rasterizer):"
					spnTimeSamples.visible = false
					spnRapidMotionResample.enabled = true
					spnRapidMotionResample.visible = true
				)
				else --Clasic Raytraced
				(
					lblTimeSamples.enabled = true
					lblTimeSamples.caption = "Time Samples:"
					spnTimeSamples.enabled = true
					spnTimeSamples.visible = true
					spnRapidMotionResample.visible = false
				)--if else if
			)--if
		)--if
	
		------------------------------------------------

		------------------------------------------------
		--Contours

		chkContoursEnable.checked = editCA.EnableContours

		----------------------
		--Contours Contrast
		lblContourContrast.enabled = ddlContourContrast.enabled = ckbContourContrast.enabled = editCA.EnableContours
		if editCA.Contour_Contrast_Shader != undefined then
		(
			_class = (classof editCA.Contour_Contrast_Shader) as string
			_class = substituteString _class "__contour" ""
			_class = substituteString _class "_" " "

			_index = findItem ddlContourContrast.items _class
			if _index != 0 then ddlContourContrast.selection = _index else (editCA.Contour_Contrast_Shader = undefined; ddlContourContrast.selection = 1)
		)
		else
		(
			ddlContourContrast.selection = 1
		)--if else
		----------------------

		----------------------
		--Contours Store
		lblContourStore.enabled = ddlContourStore.enabled = ckbContourStore.enabled = editCA.EnableContours		
		if editCA.Contour_Store_Shader != undefined then
		(
			_class = (classof editCA.Contour_Store_Shader) as string
			_class = substituteString _class "__contour" ""
			_class = substituteString _class "_" " "
			
			_index = findItem ddlContourStore.items _class
			if _index != 0 then ddlContourStore.selection = _index else (editCA.Contour_Store_Shader = undefined; ddlContourStore.selection = 1)
		)
		else
		(
			ddlContourStore.selection = 1
		)--if else
		----------------------

		----------------------
		--Contours Output
		lblContourOutput.enabled = ddlContourOutput.enabled = ckbContourOutput.enabled = editCA.EnableContours		
		if editCA.Contour_Output_Shader != undefined then
		(
			_class = (classof editCA.Contour_Output_Shader) as string
			_class = substituteString _class "__contour" ""
			_class = substituteString _class "_" " "
			_class = substituteString _class "PS" "Post Script"
			
			_index = findItem ddlContourOutput.items _class
			if _index != 0 then ddlContourOutput.selection = _index else (editCA.Contour_Output_Shader = undefined; ddlContourOutput.selection = 1)
		)
		else
		(
			ddlContourOutput.selection = 1
		)--if else
		----------------------

		------------------------------------------------

		------------------------------------------------
		--Camera Shaders

		----------------------
		--Camera Lens
		chkCameraLens.checked = editCA.Enable_Camera_Lens_Shader

		if editCA.Camera_Lens_Shader != undefined then
		(
			_class = (FilterString (editCA.Camera_Lens_Shader as string) ":")[2]

			_index = findItem ddlCameraLens.items _class
			if _index != 0 then ddlCameraLens.selection = _index else (editCA.Camera_Lens_Shader = undefined; ddlCameraLens.selection = 1)
		)
		else
		(
			ddlCameraLens.selection = 1
		)--if else
		----------------------

		----------------------
		--Camera Output
		chkCameraOutput.checked = editCA.Enable_Camera_Output_Shader

		if editCA.Camera_Output_Shader != undefined then
		(
			_class = (FilterString (editCA.Camera_Output_Shader as string) ":")[2]

			_index = findItem ddlCameraOutput.items _class
			if _index != 0 then ddlCameraOutput.selection = _index else (editCA.Camera_Output_Shader = undefined; ddlCameraOutput.selection = 1)
		)
		else
		(
			ddlCameraOutput.selection = 1
		)--if else
		----------------------

		----------------------
		--Camera Volume
		chkCameraVolume.checked = editCA.Enable_Camera_Volume_Shader

		if editCA.Camera_Volume_Shader != undefined then
		(
			_class = (FilterString (editCA.Camera_Volume_Shader as string) ":")[2]

			_index = findItem ddlCameraVolume.items _class
			if _index != 0 then ddlCameraVolume.selection = _index else (editCA.Camera_Volume_Shader = undefined; ddlCameraVolume.selection = 1)
		)
		else
		(
			ddlCameraVolume.selection = 1
		)--if else
		----------------------

		------------------------------------------------

		------------------------------------------------
		--Depth of Field

		chkDepthOfFieldEnable.checked = editCA.DepthOfFieldEnable and editCA.overrideMentalCameraEffects

		ddlDepthOfFieldMode.enabled = editCA.DepthOfFieldEnable and editCA.overrideMentalCameraEffects
		ddlDepthOfFieldMode.selection = editCA.DepthOfFieldMode + 1

		lblFstop.enabled = spnFstop.enabled = editCA.DepthOfFieldEnable and editCA.overrideMentalCameraEffects
		lblFstop.visible = spnFstop.visible = editCA.DepthOfFieldMode == 0
		spnFstop.value = editCA.fStop

		lblNear.enabled = spnNearFocus.enabled = editCA.DepthOfFieldEnable and editCA.overrideMentalCameraEffects
		lblNear.visible = spnNearFocus.visible = editCA.DepthOfFieldMode == 1
		spnNearFocus.value = editCA.NearFocus

		lblFocusPlane.enabled = spnFocusPlane.enabled = editCA.DepthOfFieldEnable and editCA.overrideMentalCameraEffects
		spnFocusPlane.value = editCA.FocusPlane

		lblFarFocus.enabled = spnFarFocus.enabled = (editCA.DepthOfFieldMode == 1) and editCA.DepthOfFieldEnable and editCA.overrideMentalCameraEffects
		spnFarFocus.value = if (editCA.DepthOfFieldMode == 1) then editCA.FarFocus else 0

		------------------------------------------------
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(		
		chkOverrideMentalCameraEffects.checked = editCA.overrideMentalCameraEffects
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
		if ckbContourContrast.checked then editMap #contourContrast false
		if ckbContourStore.checked then editMap #contourStore false
		if ckbContourOutput.checked then editMap #contourOutput false
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
	--@control: checkbox | chkMotionBlurEnable | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkMotionBlurEnable changed state do
	(
		editCA.MotionBlurEnable = state
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkBlurAllObjects | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkBlurAllObjects changed state do
	(
		editCA.MotionBlurAllObjects = state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnShutterDuration | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnShutterDuration changed value do
	(
		editCA.Shutter = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnShutterOffset | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnShutterOffset changed value do
	(
		editCA.MotionBlurOffset = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnMotionSegments | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnMotionSegments changed value do
	(
		editCA.Segments = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnTimeSamples | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnTimeSamples changed value do
	(
		editCA.TimeSamples = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnRapidMotionResample | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnRapidMotionResample changed value do
	(
		editCA.RapidMotionResample = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkContoursEnable | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkContoursEnable changed state do
	(
		editCA.EnableContours = state
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlContourContrast | Dropdown que cambia de seleccion.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlContourContrast selected index do
	(
		_class = (classof editCA.Contour_Contrast_Shader) as string
		_class = substituteString _class "__contour" ""
		_class = substituteString _class "_" " "

		if ddlContourContrast.items[index] == "None" then
		(
			editCA.Contour_Contrast_Shader = undefined
		)
		else if _class != ddlContourContrast.items[index] then
		(
			_executeString = (substituteString (ddlContourContrast.items[index]) " " "_") + "__contour()"
			editCA.Contour_Contrast_Shader = execute _executeString
		)--if else if
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlContourStore | Dropdown que cambia de seleccion.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlContourStore selected index do
	(
		_class = (classof editCA.Contour_Store_Shader) as string
		_class = substituteString _class "__contour" ""
		_class = substituteString _class "_" " "

		if ddlContourStore.items[index] == "None" then
		(
			editCA.Contour_Store_Shader = undefined
		)
		else if _class != ddlContourStore.items[index] then
		(
			_executeString = (substituteString (ddlContourStore.items[index]) " " "_") + "__contour()"
			editCA.Contour_Store_Shader = execute _executeString
		)--if else if
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlContourOutput | Dropdown que cambia de seleccion.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlContourOutput selected index do
	(
		_class = (classof editCA.Contour_Output_Shader) as string
		_class = substituteString _class "__contour" ""
		_class = substituteString _class "_" " "

		if ddlContourOutput.items[index] == "None" then
		(
			editCA.Contour_Output_Shader = undefined
		)
		else if _class != ddlContourOutput.items[index] then
		(
			_selectedClass = ddlContourOutput.items[index]
			_selectedClass = substituteString _selectedClass "Post Script" "PS"

			_executeString = (substituteString _selectedClass " " "_") + "__contour()"
			editCA.Contour_Output_Shader = execute _executeString
		)--if else if
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: checkbutton | ckbContourContrast | Boton para elegir mapa.
	--@gets: boolean | state | Estado presionado o no.
	------------------------------------------------
	on ckbContourContrast changed state do
	(
		editMap #contourContrast state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: checkbutton | ckbContourStore | Boton para elegir mapa.
	--@gets: boolean | state | Estado presionado o no.
	------------------------------------------------
	on ckbContourStore changed state do
	(
		editMap #contourStore state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: checkbutton | ckbContourOutput | Boton para elegir mapa.
	--@gets: boolean | state | Estado presionado o no.
	------------------------------------------------
	on ckbContourOutput changed state do
	(
		editMap #contourOutput state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkCameraLens | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkCameraLens changed state do
	(
		editCA.Enable_Camera_Lens_Shader = state		
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlCameraLens | Dropdown que cambia de seleccion.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlCameraLens selected index do
	(
		_classes = #("undefined", "Depth_of_Field___Bokeh()", "Distortion__lume()", "Utility_Gamma___Gain__mi()", "mr_Physical_Sky()", "Night__lume()", "Render_Subset_of_Scene_Masking__mi()", "Shader_List__Lens()", "WrapAround__lume()")

		_class = (filterString (editCA.Camera_Lens_Shader as string) ":")[2]
		if _class == undefined then _class = "None"
		if _class != ddlCameraLens.items[index] then editCA.Camera_Lens_Shader = execute _classes[index]		
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkCameraOutput | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkCameraOutput changed state do
	(
		editCA.Enable_Camera_Output_Shader = state
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlCameraOutput | Dropdown que cambia de seleccion.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlCameraOutput selected index do
	(
		_classes = #("undefined", "GlaretextureMap()", "HDR_Image_Motion_Blur__mi()", "Motion_Vector_Export__mi()", "Shader_List__Output()")

		_class = (filterString (editCA.Camera_Output_Shader as string) ":")[2]
		if _class == undefined then _class = "None"
		if _class != ddlCameraOutput.items[index] then editCA.Camera_Output_Shader = execute _classes[index]
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkCameraVolume | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkCameraVolume changed state do
	(
		editCA.Enable_Camera_Volume_Shader = state
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlCameraVolume | Dropdown que cambia de seleccion.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlCameraVolume selected index do
	(
		_classes = #("undefined", "Beam__lume()", "Material_to_Shader()", "Mist__lume()", "mr_Physical_Sky()", "Parti_Volume__physics()", "Shader_List__Volume()", "Submerge__lume()")

		_class = (filterString (editCA.Camera_Volume_Shader as string) ":")[2]
		if _class == undefined then _class = "None"
		if _class != ddlCameraVolume.items[index] then editCA.Camera_Volume_Shader = execute _classes[index]
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: checkbutton | ckbCameraLens | Boton para elegir mapa.
	--@gets: boolean | state | Estado presionado o no.
	------------------------------------------------
	on ckbCameraLens changed state do
	(
		editMap #cameraLens state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: checkbutton | ckbCameraOutput | Boton para elegir mapa.
	--@gets: boolean | state | Estado presionado o no.
	------------------------------------------------
	on ckbCameraOutput changed state do
	(
		editMap #cameraOutput state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al presionar el boton para elegir mapa.
	--@control: checkbutton | ckbCameraVolume | Boton para elegir mapa.
	--@gets: boolean | state | Estado presionado o no.
	------------------------------------------------
	on ckbCameraVolume changed state do
	(
		editMap #cameraVolume state
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkDepthOfFieldEnable | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkDepthOfFieldEnable changed state do
	(
		editCA.DepthOfFieldEnable = state
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlDepthOfFieldMode | Dropdown que cambia de seleccion.
	--@gets: integer | index | Nuevo indice seleccionado.
	------------------------------------------------
	on ddlDepthOfFieldMode selected index do
	(
		editCA.DepthOfFieldMode = index - 1
		loadOverrideInfo()
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnFstop | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnFstop changed value do
	(
		editCA.fStop = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnNearFocus | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnNearFocus changed value do
	(
		editCA.NearFocus = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnFocusPlane | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnFocusPlane changed value do
	(
		editCA.FocusPlane = value
	)

	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el valor.
	--@control: spinner | spnFarFocus | Spinner que cambia de valor.
	--@gets: float | value | Nuevo valor.
	------------------------------------------------
	on spnFarFocus changed value do
	(
		editCA.FarFocus = value
	)

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkOverrideMentalCameraEffects | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalCameraEffects changed state do
	(
		editCA.overrideMentalCameraEffects = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalCameraEffectsDef | rollout actual.
	------------------------------------------------
	on rollMentalCameraEffectsDef open do
	(
		parent = lb.passManager.getCurrentEditInstance()
		editCA = parent.editBackupNode.custAttributes[#overrideRendererSettingsInfo]

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
	on rollMentalCameraEffectsDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		matEditorRestore()
		saveSettings()		
	)
)--rollMentalCameraEffectsDef