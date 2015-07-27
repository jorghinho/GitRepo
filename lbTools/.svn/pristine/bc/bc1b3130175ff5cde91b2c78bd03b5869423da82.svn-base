------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: UI para el override de renderer. Mental ray. Sampling Quality
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollMentalSamplingQualityDef | Rollout de Sampign Quality de mental ray.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollMentalSamplingQualityDef "Sampling Quality"
(
	------------------------------------------------------------------------------------------------
	--COMMON
	------------------------------------------------------------------------------------------------
	
	local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento.
	
	local editCA = undefined --@var : editCA| Variable de atajo para el CA de edit.

	------------------------------------------------------------------------------------------------
	--VARIABLES
	------------------------------------------------------------------------------------------------
	
	local visibilityArray = #("1", "4", "9", "16", "25", "36", "49", "64", "81", "100", "121", "144", "169", "196", "225")
	local samplingModesArray = #("Unified / Raytraced (Recommended)", "Classic / Raytraced", "Rasterizer / Scanline")
	local samplesArray = #("1/64","1/16","1/4","1","4","16","64","256","1024")
	local filtersArray = #("Box","Gauss","Triangle","Mitchell","Lanczos")

	------------------------------------------------------------------------------------------------
	--CONTROLS
	------------------------------------------------------------------------------------------------
	
	--override active
	checkbox chkOverrideMentalSamplingQuality "override" pos:[5,5] checked:false --@control | chkOverrideMentalSamplingQuality | Indica si hacer override de esos parametros.

	--Sampling Mode
	groupbox grpSamplingMode "Sampling Mode" pos:[5,25] width:327 height:45
	dropdownList ddlSamplingMode "" pos:[10,42] items:#() width:317 --@control | ddlSamplingMode | Dropdownlist de opciones de modo de sampleado
	
	--Samples
	groupbox grpSamplesPerPixel "Samples per Pixel" pos:[5,75] width:158 height:80

	label lblQuality "Quality: " pos:[16,92] width:50
	spinner spnQuality "" pos:[75,92] width:75 range:[0.01,20.0,0.25] type:#float scale:0.01
	
	label lblMinimumSamples "Minimum: " pos:[16,111] width:55
	spinner spnMinimun "" pos:[75,112] width:75 range:[0.1,64.0,1.0] type:#float scale:0.1
	dropdownList ddlMinimumSamples "" pos:[76,107] items:#() width:75 --@control | ddlMinimumSamples | Dropdownlist de samples mínimos por pixel.
	spinner spnShading "" pos:[75,112] width:75 range:[0.1,64.0,2.0] type:#float scale:0.1

	label lblMaximumSamples "Maximum: " pos:[16,131] width:55
	spinner spnMaximun "" pos:[75,132] width:75 range:[1,100000,128] type:#integer scale:1.
	dropdownList ddlMaximumSamples "" pos:[76,128] items:#() width:75 --@control | ddlMaximumSamples | Dropdownlist de samples máximos por pixel.
	dropdownList ddlVisibility "" pos:[76,128] items:#() width:75
			
	----Filter
	groupbox grpFilter "Filter" pos:[168,75] width:164 height:80		
	
	label lblFilterType "Type: " pos:[178,95]
	dropdownList ddlFilterType "" pos:[231,92] width:90 --@control | ddlMinimumSamples | Dropdownlist del tipo de filtro
	label lblWidth "Width: " pos:[178,114]
	spinner spnWidth "" pos:[230,113] width:90 range:[0.0,8.0,2.0] type:#float scale:0.1 --@control | spnWidth| Spinner de ancho del filtro
	label lblHeight "Height: " pos:[178,130]
	spinner spnHeight "" pos:[230,130] width:90 range:[0.0,8.0,2.0] type:#float scale:0.1 --@control | spnHeight | Spinner de alto del filtro
	
	----Spatial Contrast
	groupbox grpSpatialContrast "Spatial Contrast" pos:[5,160] width:327 height:45

	spinner spnR "R:" pos:[25,180] width:55 fieldWidth:40 range:[0.0,1.0,0.5] type:#float scale:0.01
	spinner spnG "G:" pos:[95,180] width:55 fieldWidth:40 range:[0.0,1.0,0.5] type:#float scale:0.01
	spinner spnB "B:" pos:[165,180] width:55 fieldWidth:40 range:[0.0,1.0,0.5] type:#float scale:0.01
	spinner spnA "A:" pos:[235,180] width:55 fieldWidth:40 range:[0.0,1.0,1.0] type:#float scale:0.01
	colorpicker clrSpatial "" pos:[300,180] width:22 height:15 color:(color 127 127 127) alpha:true modal:true
	
	----Options
	groupbox grpOptions "Options" pos:[5,210] width:327 height:85
	checkbox chkLockSamples "Lock Samples" pos:[16,227] checked:true
	checkbox chkJitter "Jitter" pos:[16,245] checked:true
	label lblBucketWidth "Bucket Width:" pos:[150,227]
	spinner spnBucketWidth "" pos:[225,227] width:45 range:[4,512,48] type:#integer scale:2
	label lblBucketOrder "Bucket Order:" pos:[150,247]
	dropdownList ddlBucketOrder "" pos:[225,245] width:95 items:#("Hilbert (best)", "Spiral", "Left to right", "Right to left", "Top-down", "Bottom-up")
	label lblBufferType "Frame Buffer Type:" pos:[16,267]
	dropdownList ddlBufferType "" pos:[150,265] width:170 items:#("Iteger (16 bits per channel)", "Floating-Point (32 bits per channel)")
	
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
	--@fn: undefined | updateUIControlsByOverrideEnabledState | habilita o deshabilita los controles del override en funcion de si está activo o no.
	------------------------------------------------
	fn updateUIControlsByOverrideEnabledState disableOnly:false =
	(
		if not disableOnly then --si esta en el modo en que se permite habilitar y desahbilitar
		(
			for _cntrl in rollMentalSamplingQualityDef.controls where _cntrl.name != "chkOverrideMentalSamplingQuality" do _cntrl.enabled = editCA.overrideMentalSamplingQuality
			chkOverrideMentalSamplingQuality.checked = editCA.overrideMentalSamplingQuality
		)
		else if not editCA.overrideMentalSamplingQuality then --so solo se permite desahbilitar solo entra si está desactivado el override
		(
			for _cntrl in rollMentalSamplingQualityDef.controls where _cntrl.name != "chkOverrideMentalSamplingQuality" do _cntrl.enabled = false
			chkOverrideMentalSamplingQuality.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		------------------------------------------------
		--Sampling Mode

		ddlSamplingMode.items = samplingModesArray
		ddlSamplingMode.selection = if editCA.UnifiedEnable then 1 else if editCA.ScanlineEnable then 3 else 2
		
		spnQuality.enabled = (ddlSamplingMode.selection == 1)
		
		lblMinimumSamples.text = if ddlSamplingMode.selection != 3 then "Minimun:" else "Shading:"
		lblMaximumSamples.text = if ddlSamplingMode.selection != 3 then "Maximum:" else "Visibility:"
			
		spnMinimun.visible = (ddlSamplingMode.selection == 1)
		spnMaximun.visible = (ddlSamplingMode.selection == 1)
		
		ddlMinimumSamples.visible = (ddlSamplingMode.selection == 2)
		ddlMaximumSamples.visible = (ddlSamplingMode.selection == 2)
		
		spnShading.visible = (ddlSamplingMode.selection == 3)
		ddlVisibility.visible = (ddlSamplingMode.selection == 3)
		
		spnR.enabled = (ddlSamplingMode.selection != 3)
		spnG.enabled = (ddlSamplingMode.selection != 3)
		spnB.enabled = (ddlSamplingMode.selection != 3)
		spnA.enabled = (ddlSamplingMode.selection != 3)
		clrSpatial.enabled = (ddlSamplingMode.selection != 3)
		------------------------------------------------
		
		------------------------------------------------
		--Samples
		
		spnQuality.value = editCA.UnifiedQuality
		spnMinimun.value = editCA.UnifiedMinSamples
		spnMaximun.value = editCA.UnifiedMaxSamples
		
		ddlMinimumSamples.items = samplesArray
		ddlMaximumSamples.items = samplesArray
		ddlMinimumSamples.selection = editCA.MinimumSamples + 4
		ddlMaximumSamples.selection = editCA.MaximumSamples + 4
		
		spnShading.value = editCA.RapidShadingSamples
		ddlVisibility.items = visibilityArray
		ddlVisibility.selection = editCA.RapidCollectRate			
		------------------------------------------------
		
		------------------------------------------------
		--Filters
		
		ddlFilterType.items = filtersArray
		ddlFilterType.selection = editCA.FilterType + 1
		
		case filtersArray[editCA.FilterType + 1] of
		(
			"Box":
			(
				spnWidth.value = editCA.BoxFilterWidth
				spnHeight.value = editCA.BoxFilterHeight  
			)
			
			"Gauss":
			(
				spnWidth.value = editCA.GaussFilterWidth  
				spnHeight.value = editCA.GaussFilterHeight
			)
			
			"Triangle":
			(
				spnWidth.value = editCA.TriangleFilterWidth
				spnHeight.value = editCA.TriangleFilterHeight
			)
			
			"Mitchell":
			(
				spnWidth.value = editCA.MitchellFilterWidth
				spnHeight.value = editCA.MitchellFilterHeight
			)
			
			"Lanczos":
			(
				spnWidth.value = editCA.LanczosFilterWidth  
				spnHeight.value = editCA.LanczosFilterHeight
			)
		)--case			
		------------------------------------------------
		
		------------------------------------------------
		--Spatial Contrast
		
		spnR.value = editCA.RedSpatialContrast
		spnG.value = editCA.GreenSpatialContrast
		spnB.value = editCA.BlueSpatialContrast
		spnA.value = editCA.AlphaSpatialContrast
		clrSpatial.color = (color (255*spnR.value) (255*spnG.value) (255*spnB.value) (255*spnA.value))			
		------------------------------------------------
		
		------------------------------------------------
		--Options
		
		chkLockSamples.checked = editCA.LockSamples
		chkJitter.checked = editCA.Jitter
		spnBucketWidth.value = editCA.TaskSize
		ddlBucketOrder.selection = editCA.TaskOrder + 1
		ddlBufferType.selection = editCA.FrameBufferType  + 1			
		------------------------------------------------
	)

	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(
		chkOverrideMentalSamplingQuality.checked = editCA.overrideMentalSamplingQuality
		updateUIControlsByOverrideEnabledState()
		loadOverrideInfo()
		updateUIControlsByOverrideEnabledState disableOnly:true
	)

	------------------------------------------------
	--@fn: undefined | updateRelatedRollouts | Actualiza el estado de los controles de rollouts relacionados.
	------------------------------------------------
	fn updateRelatedRollouts =
	(
		parent.rollMentalRenderingAlgorithms.updateUI()
		parent.rollMentalShadowsAndDisplacement.updateUI()
		parent.rollMentalCameraEffects.updateUI()
	)

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
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlSamplingMode | Dropdown de modo de sampleado
	------------------------------------------------
	on ddlSamplingMode selected index do
	(
		--cambia los parámetros relacionados con este area
		editCA.UnifiedEnable = (index == 1)
		editCA.ScanlineEnable = (index == 3)

		--cambia los parametros de otras areas relacionadas que sea incompatibles
		if (index == 3) then editCA.Autovolume = false
		else editCA.RaytraceEnable = true
		
		---------------------
		--actualiza el ui propio y los relacionados
		loadOverrideInfo()
		updateRelatedRollouts()
		---------------------
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnQuality | Spinner que cambia de valor.
	------------------------------------------------
	on spnQuality changed newValue do
	(
		editCA.UnifiedQuality = newValue
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnMinimun | Spinner que cambia de valor.
	------------------------------------------------
	on spnMinimun changed newValue do
	(
		editCA.UnifiedMinSamples = newValue
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnMaximun | Spinner que cambia de valor.
	------------------------------------------------
	on spnMaximun changed newValue do
	(
		editCA.UnifiedMaxSamples = newValue
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnShading | Spinner que cambia de valor.
	------------------------------------------------
	on spnShading changed newValue do
	(
		editCA.RapidShadingSamples = newValue
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlVisibility | Dropdown que cambia de seleccion.
	------------------------------------------------
	on ddlVisibility selected index do
	(
		editCA.RapidCollectRate = index
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la seleccion.
	--@control: dropdownlist | ddlFilterType | Dropdown de tipo de filtro
	------------------------------------------------
	on ddlFilterType selected index do
	(
		--Guardamos los samples mínimos
		editCA.FilterType = index - 1
		
		case filtersArray[index] of
		(
			"Box":
			(
				spnWidth.value = editCA.BoxFilterWidth
				spnHeight.value = editCA.BoxFilterHeight  
			)
			
			"Gauss":
			(
				spnWidth.value = editCA.GaussFilterWidth  
				spnHeight.value = editCA.GaussFilterHeight
			)
			
			"Triangle":
			(
				spnWidth.value = editCA.TriangleFilterWidth
				spnHeight.value = editCA.TriangleFilterHeight
			)
			
			"Mitchell":
			(
				spnWidth.value = editCA.MitchellFilterWidth
				spnHeight.value = editCA.MitchellFilterHeight
			)
			
			"Lanczos":
			(
				spnWidth.value = editCA.LanczosFilterWidth  
				spnHeight.value = editCA.LanczosFilterHeight
			)
		)--case
	)		
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnWidth | Spinner de ancho del filtro.
	------------------------------------------------
	on spnWidth changed newValue do
	(
		case filtersArray[editCA.FilterType + 1] of
		(
			"Box":
			(
				editCA.BoxFilterWidth = newValue
			)
			
			"Gauss":
			(
				editCA.GaussFilterWidth = newValue
			)
			
			"Triangle":
			(
				editCA.TriangleFilterWidth = newValue
			)
			
			"Mitchell":
			(
				editCA.MitchellFilterWidth = newValue
			)
			
			"Lanczos":
			(
				editCA.LanczosFilterWidth = newValue
			)
		)--case
	)
		
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnHeight | Spinner de alto del filtro.
	------------------------------------------------
	on spnHeight changed newValue do
	(
		case filtersArray[editCA.FilterType + 1] of
		(
			"Box":
			(
				editCA.BoxFilterHeight = newValue
			)
			
			"Gauss":
			(
				editCA.GaussFilterHeight = newValue
			)
			
			"Triangle":
			(
				editCA.TriangleFilterHeight = newValue
			)
			
			"Mitchell":
			(
				editCA.MitchellFilterHeight = newValue
			)
			
			"Lanczos":
			(
				editCA.LanczosFilterHeight = newValue
			)
		)--case
	)
		
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la opcion.
	--@control: dropdownlist | ddlMinimumSamples | Dropdown de samples mínimos
	------------------------------------------------
	on ddlMinimumSamples selected index do
	(
		--Guardamos los samples mínimos
		editCA.MinimumSamples = index - 4
		
		--Modificamos el de máximos para que nunca sea menor que el de minimos
		if index > ddlMaximumSamples.selection then
		(
			ddlMaximumSamples.selection = index
			editCA.MaximumSamples = index - 4
		)
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la opcion.
	--@control: dropdownlist | ddlMaximumSamples | Dropdown de samples máximos
	------------------------------------------------
	on ddlMaximumSamples selected index do
	(
		--Guardamos los samples maximos
		editCA.MaximumSamples = index - 4
		
		--Modificamos el de minimos para que nunca sea menor que el de minimos
		if index < ddlMinimumSamples.selection then
		(
			ddlMinimumSamples.selection = index
			editCA.MinimumSamples = index - 4
		)
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnR | Spinner que cambia de valor.
	------------------------------------------------
	on spnR changed val do
	(
		editCA.RedSpatialContrast = val
		clrSpatial.color = (color (255*spnR.value) (255*spnG.value) (255*spnB.value) (255*spnA.value))
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnG | Spinner que cambia de valor.
	------------------------------------------------
	on spnG changed val do
	(
		editCA.GreenSpatialContrast = val
		clrSpatial.color = (color (255*spnR.value) (255*spnG.value) (255*spnB.value) (255*spnA.value))
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnB | Spinner que cambia de valor.
	------------------------------------------------
	on spnB changed val do
	(
		editCA.BlueSpatialContrast = val
		clrSpatial.color = (color (255*spnR.value) (255*spnG.value) (255*spnB.value) (255*spnA.value))
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnA | Spinner que cambia de valor.
	------------------------------------------------
	on spnA changed val do
	(
		editCA.AlphaSpatialContrast = val
		clrSpatial.color = (color (255*spnR.value) (255*spnG.value) (255*spnB.value) (255*spnA.value))
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el color.
	--@control: colorPicker | clrSpatial | Color que cambia
	------------------------------------------------
	on clrSpatial changed val do
	(
		spnR.value = val.r/255.0
		spnG.value = val.g/255.0
		spnB.value = val.b/255.0
		spnA.value = val.a/255.0
		
		editCA.RedSpatialContrast = val.r/255.0
		editCA.GreenSpatialContrast = val.g/255.0
		editCA.BlueSpatialContrast= val.b/255.0
		editCA.AlphaSpatialContrast = val.a/255.0
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkLockSamples | checkbox que cambia de estado.
	------------------------------------------------
	on chkLockSamples changed state do
	(
		editCA.LockSamples = state
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkJitter | checkbox que cambia de estado.
	------------------------------------------------
	on chkJitter changed state do
	(
		editCA.Jitter = state
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el spinner.
	--@control: spinner | spnBucketWidth | Spinner que cambia de valor.
	------------------------------------------------
	on spnBucketWidth changed val do
	(
		editCA.TaskSize = val
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la opcion.
	--@control: dropdownlist | ddlBucketOrder | Dropdown que cambia de opcion
	------------------------------------------------
	on ddlBucketOrder selected index do
	(
		editCA.TaskOrder = index - 1
	)
	
	------------------------------------------------
	--@event: selected | Evento que se lanza al cambiar la opcion.
	--@control: dropdownlist | ddlBufferType | Dropdown que cambia de opcion
	------------------------------------------------
	on ddlBufferType selected index do
	(
		editCA.FrameBufferType  = index - 1
	)		

	------------------------------------------------
	--COMMON
	------------------------------------------------
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estadp.
	--@control: checkbox | chkOverrideMentalSamplingQuality | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideMentalSamplingQuality changed state do
	(
		editCA.overrideMentalSamplingQuality = state
		updateUI()
		parent.updateRendererTabsColor()
	)

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalSamplingQualityDef | rollout actual.
	------------------------------------------------
	on rollMentalSamplingQualityDef open do
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
	--@control: rollout | rollMentalSamplingQualityDef | rollout actual.
	------------------------------------------------
	on rollMentalSamplingQualityDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollMentalSamplingQualityDef