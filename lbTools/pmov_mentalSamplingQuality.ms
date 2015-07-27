------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de mentalSamplingQuality
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute:overrideMentalSamplingQualityInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideMentalSamplingQualityInfo = attributes overrideMentalSamplingQualityInfo   
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de Renderer."
			
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"mentalSamplingQuality"	--@var | subType | Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--informacion sobre el contenido almacenado en el override
			
			---------------------------------------------------------------
			-- Parámetros de backup
			---------------------------------------------------------------
			
			---------------------------------------------------------------
			-- Parámetros de backup y apply
			
			------------------------------------------------
			--Sampling Mode
			
			UnifiedEnable	type:#boolean	default:true --@var | UnifiedEnable | Indica la opcion uno del desplegable de Sampling Mode.
			UnifiedQuality	type:#float	default:0.25 --@var | UnifiedQuality | Spinner de calidad.
			UnifiedMinSamples	type:#float	default:1.0 --@var | UnifiedMinSamples | Samples minimos.
			UnifiedMaxSamples	type:#integer	default:128 --@var | UnifiedMaxSamples | Samples máximos.
			
			ScanlineEnable	type:#boolean	default:false --@var | ScanlineEnable | Indica si esta habilitado Scanline.
			RapidCollectRate  	type:#integer 	default:4 		--@var | RapidCollectRate | Parámetro de glossy refraction
			RapidShadingSamples type:#float 	default:2.0 	--@var | RapidShadingSamples | Parámetro de glossy refraction
			
			------------------------------------------------
			
			------------------------------------------------
			--Samples per pixel
				
			MinimumSamples type:#integer default:0 --@var | MinimumSamples | Minimos samples por pixel	
			MaximumSamples type:#integer default:0 --@var | MaximumSamples | Máximum samples por pixel
			
			------------------------------------------------
			
			------------------------------------------------	
			--Filter			
				
			FilterType type:#integer default:0 --@var | FilterType | Tipo de filtro de sampleo
			BoxFilterWidth type:#float 	 default:0.0 --@var | BoxFilterWidth | Ancho del filtro de box.
			BoxFilterHeight type:#float  default:0.0 --@var | BoxFilterHeight | Alto del filtro de box.
			GaussFilterWidth type:#float 	 default:0.0 --@var | FilterWidth | Ancho del filtro de gauss.
			GaussFilterHeight type:#float  default:0.0 --@var | FilterHeight | Alto del filtro de Gauss.
			TriangleFilterWidth type:#float 	 default:0.0 --@var | FilterWidth | Ancho del filtro de Triangle.
			TriangleFilterHeight type:#float  default:0.0 --@var | FilterHeight | Alto del filtro de Triangle.
			MitchellFilterWidth type:#float 	 default:0.0 --@var | FilterWidth | Ancho del filtro de Mitchell.
			MitchellFilterHeight type:#float  default:0.0 --@var | FilterHeight | Alto del filtro de Mitchell.
			LanczosFilterWidth type:#float 	 default:0.0 --@var | FilterWidth | Ancho del filtro de Lanczos.
			LanczosFilterHeight type:#float  default:0.0 --@var | FilterHeight | Alto del filtro de Lanczos.
			
			------------------------------------------------
			
			------------------------------------------------
			--Spatial Contrast
			
			RedSpatialContrast type:#float default:0.05
			GreenSpatialContrast type:#float default:0.05
			BlueSpatialContrast type:#float default:0.05
			AlphaSpatialContrast type:#float default:0.05
			
			------------------------------------------------
			
			------------------------------------------------
			--Options
			
			LockSamples type:#boolean default:true
			Jitter type:#boolean default:false
			TaskSize type:#integer default:48
			TaskOrder type:#integer default:0
			FrameBufferType type:#integer default:0
			
			------------------------------------------------
			---------------------------------------------------------------
			
			---------------------------------------------------------------
			-- Parámetros de apply
			---------------------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDefBefore2014 | Contiene el Ui del override para versiones anteriores a 2014
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDefBefore2014 "Sampling Quality Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var : editCA | Almacena el custom attribute de edit.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--Samples
		groupbox grpSamplesPerPixel "Samples per Pixel" pos:[5,0] width:140 height:75
		label lblMinimumSamples "Minimum: " pos:[15,20] width:70
		dropdownList ddlMinimumSamples "" pos:[75,17] items:#() width:65 --@control | ddlMinimumSamples | Dropdownlist de samples mínimos por pixel
		label lblMaximumSamples "Maximum: " pos:[15,41] width:70
		dropdownList ddlMaximumSamples "" pos:[75,38] items:#() width:65 --@control | ddlMaximumSamples | Dropdownlist de samples máximos por pixel
		
		--Filter
		groupbox grpFilter "Filter" pos:[150,0] width:145 height:75		
		label lblFilterType "Type: " pos:[160,20]
		dropdownList ddlFilterType "" pos:[210,17] width:80 --@control | ddlMinimumSamples | Dropdownlist del tipo de filtro
		label lblWidth "Width: " pos:[160,39]
		spinner spnWidth "" pos:[210,38] width:70 range:[0.0,8.0,2.0] type:#float scale:0.1 --@control | spnWidth| Spinner de ancho del filtro
		label lblHeight "Height: " pos:[160,55]
		spinner spnHeight "" pos:[210,55] width:70 range:[0.0,8.0,2.0] type:#float scale:0.1 --@control | spnHeight | Spinner de alto del filtro
		
		--Spatial Contrast
		groupbox grpSpatialContrast "Spatial Contrast" pos:[5,80] width:290 height:45
		spinner spnR "R:" pos:[25,100] width:45 fieldWidth:30 range:[0.0,1.0,0.5] type:#float scale:0.01
		spinner spnG "G:" pos:[85,100] width:45 fieldWidth:30 range:[0.0,1.0,0.5] type:#float scale:0.01
		spinner spnB "B:" pos:[145,100] width:45 fieldWidth:30 range:[0.0,1.0,0.5] type:#float scale:0.01
		spinner spnA "A:" pos:[205,100] width:45 fieldWidth:30 range:[0.0,1.0,1.0] type:#float scale:0.01
		colorpicker clrSpatial "" pos:[255,100] width:30 height:15 color:(color 127 127 127) alpha:true modal:true
		
		--Options
		groupbox grpOptions "Options" pos:[5,130] width:290 height:85
		checkbox chkLockSamples "Lock Samples" pos:[13,147] checked:true
		checkbox chkJitter "Jitter" pos:[13,165] checked:true
		label lblBucketWidth "Bucket Width:" pos:[115,147]
		spinner spnBucketWidth "" pos:[190,147] width:45 range:[4,512,48] type:#integer scale:2
		label lblBucketOrder "Bucket Order:" pos:[115,167]
		dropdownList ddlBucketOrder "" pos:[190,165] width:95 items:#("Hilbert (best)", "Spiral", "Left to right", "Right to left", "Top-down", "Bottom-up")
		label lblBufferType "Frame Buffer Type:" pos:[13,187]
		dropdownList ddlBufferType "" pos:[115,185] width:170 items:#("Iteger (16 bits per channel)", "Floating-Point (32 bits per channel)")
		
		--OK y CANCEL
		button btnOk "OK" pos:[5,225] width:145 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[150,225] width:145 --@control | btnCancel | Cancela los cambios y cierra.
		
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
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			------------------------------------------------
			--Samples
			
			ddlMinimumSamples.items = parent.samplesArray
			ddlMaximumSamples.items = parent.samplesArray
			ddlMinimumSamples.selection = editCA.MinimumSamples + 4
			ddlMaximumSamples.selection = editCA.MaximumSamples + 4 
			------------------------------------------------
			
			------------------------------------------------
			--Filters
			
			ddlFilterType.items = parent.filtersArray
			ddlFilterType.selection = editCA.FilterType + 1
			
			case parent.filtersArray[editCA.FilterType + 1] of
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
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
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
		--@control: dropdownlist | ddlFilterType | Dropdown de tipo de filtro
		------------------------------------------------
		on ddlFilterType selected index do
		(
			--Guardamos los samples mínimos
			editCA.FilterType = index - 1
			
			case parent.filtersArray[index] of
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
			case parent.filtersArray[editCA.FilterType + 1] of
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
			case parent.filtersArray[editCA.FilterType + 1] of
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
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Cancela los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnCancel pressed do
		(
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMainDefBefore2014 | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDefBefore2014 resized size do
		(
			--no se redimensiona
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDefBefore2014 | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDefBefore2014 open do
		(
			parent = lb.passManager.getCurrentEditInstance()
			editCA = parent.editBackupNode.custAttributes[#overrideMentalSamplingQualityInfo]
			loadOverrideInfo()
			loadSettings()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDefBefore2014 | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDefBefore2014 close do
		(	
			onCloseOperations()
			saveSettings()			
		)
		
	)--rollMainDefBefore2014
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Sampling Quality Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var : editCA | Almacena el custom attribute de edit.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--Sampling Mode
		groupbox grpSamplingMode "Sampling Mode" pos:[5,0] width:290 height:45
		dropdownList ddlSamplingMode "" pos:[15,17] items:#() width:275 --@control | ddlSamplingMode | Dropdownlist de opciones de modo de sampleado
		
		--Samples
		groupbox grpSamplesPerPixel "Samples per Pixel" pos:[5,50] width:140 height:75
		
		label lblQuality "Quality: " pos:[15,67] width:50
		spinner spnQuality "" pos:[75,67] width:65 range:[0.01,20.0,0.25] type:#float scale:0.01
		spinner spnMinimun "" pos:[75,87] width:65 range:[0.1,64.0,1.0] type:#float scale:0.1
		spinner spnMaximun "" pos:[75,107] width:65 range:[1,100000,128] type:#integer scale:1
		
		label lblMinimumSamples "Minimum: " pos:[15,86] width:55
		dropdownList ddlMinimumSamples "" pos:[75,82] items:#() width:65 --@control | ddlMinimumSamples | Dropdownlist de samples mínimos por pixel
		label lblMaximumSamples "Maximum: " pos:[15,106] width:55
		dropdownList ddlMaximumSamples "" pos:[75,103] items:#() width:65 --@control | ddlMaximumSamples | Dropdownlist de samples máximos por pixel
		
		spinner spnShading "" pos:[75,87] width:65 range:[0.1,64.0,2.0] type:#float scale:0.1
		dropdownList ddlVisibility "" pos:[75,103] items:#() width:65
		
		--Filter
		groupbox grpFilter "Filter" pos:[150,50] width:145 height:75		
		label lblFilterType "Type: " pos:[160,70]
		dropdownList ddlFilterType "" pos:[210,67] width:75 --@control | ddlMinimumSamples | Dropdownlist del tipo de filtro
		label lblWidth "Width: " pos:[160,89]
		spinner spnWidth "" pos:[210,88] width:75 range:[0.0,8.0,2.0] type:#float scale:0.1 --@control | spnWidth| Spinner de ancho del filtro
		label lblHeight "Height: " pos:[160,105]
		spinner spnHeight "" pos:[210,105] width:75 range:[0.0,8.0,2.0] type:#float scale:0.1 --@control | spnHeight | Spinner de alto del filtro
		
		--Spatial Contrast
		groupbox grpSpatialContrast "Spatial Contrast" pos:[5,130] width:290 height:45
		spinner spnR "R:" pos:[25,150] width:45 fieldWidth:30 range:[0.0,1.0,0.5] type:#float scale:0.01
		spinner spnG "G:" pos:[85,150] width:45 fieldWidth:30 range:[0.0,1.0,0.5] type:#float scale:0.01
		spinner spnB "B:" pos:[145,150] width:45 fieldWidth:30 range:[0.0,1.0,0.5] type:#float scale:0.01
		spinner spnA "A:" pos:[205,150] width:45 fieldWidth:30 range:[0.0,1.0,1.0] type:#float scale:0.01
		colorpicker clrSpatial "" pos:[255,150] width:30 height:15 color:(color 127 127 127) alpha:true modal:true
		
		--Options
		groupbox grpOptions "Options" pos:[5,180] width:290 height:85
		checkbox chkLockSamples "Lock Samples" pos:[13,197] checked:true
		checkbox chkJitter "Jitter" pos:[13,215] checked:true
		label lblBucketWidth "Bucket Width:" pos:[115,197]
		spinner spnBucketWidth "" pos:[190,197] width:45 range:[4,512,48] type:#integer scale:2
		label lblBucketOrder "Bucket Order:" pos:[115,217]
		dropdownList ddlBucketOrder "" pos:[190,215] width:95 items:#("Hilbert (best)", "Spiral", "Left to right", "Right to left", "Top-down", "Bottom-up")
		label lblBufferType "Frame Buffer Type:" pos:[13,237]
		dropdownList ddlBufferType "" pos:[115,235] width:170 items:#("Iteger (16 bits per channel)", "Floating-Point (32 bits per channel)")
		
		--OK y CANCEL
		button btnOk "OK" pos:[5,275] width:145 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[150,275] width:145 --@control | btnCancel | Cancela los cambios y cierra.
		
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
		--@fn: undefined | updateVisibleControls | Hace visbles unos controles u otros en funcion del parametro UnifiedQuality.
		------------------------------------------------
		fn updateUIControlsBySamplingMode =
		(
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
		)
		
		------------------------------------------------
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			------------------------------------------------
			
			--Sampling Mode
			ddlSamplingMode.items = parent.samplingModesArray
			ddlSamplingMode.selection = if editCA.UnifiedEnable then 1 else if editCA.ScanlineEnable then 3 else 2
			
			updateUIControlsBySamplingMode()
			------------------------------------------------
			
			------------------------------------------------
			--Samples
			
			spnQuality.value = editCA.UnifiedQuality
			spnMinimun.value = editCA.UnifiedMinSamples
			spnMaximun.value = editCA.UnifiedMaxSamples
			
			ddlMinimumSamples.items = parent.samplesArray
			ddlMaximumSamples.items = parent.samplesArray
			ddlMinimumSamples.selection = editCA.MinimumSamples + 4
			ddlMaximumSamples.selection = editCA.MaximumSamples + 4
			
			spnShading.value = editCA.RapidShadingSamples
			ddlVisibility.items = parent.visibilityArray
			ddlVisibility.selection = editCA.RapidCollectRate
			
			------------------------------------------------
			
			------------------------------------------------
			--Filters
			
			ddlFilterType.items = parent.filtersArray
			ddlFilterType.selection = editCA.FilterType + 1
			
			case parent.filtersArray[editCA.FilterType + 1] of
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
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
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
			editCA.UnifiedEnable = (index == 1)
			editCA.ScanlineEnable = (index == 3)
			
			updateUIControlsBySamplingMode()
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
			
			case parent.filtersArray[index] of
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
			case parent.filtersArray[editCA.FilterType + 1] of
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
			case parent.filtersArray[editCA.FilterType + 1] of
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
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Cancela los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnCancel pressed do
		(
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMainDef | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			--no se redimensiona
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			parent = lb.passManager.getCurrentEditInstance()
			editCA = parent.editBackupNode.custAttributes[#overrideMentalSamplingQualityInfo]
			loadOverrideInfo()
			loadSettings()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(	
			onCloseOperations()
			saveSettings()			
		)
		
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: override | Contiene todas las funciones de un override de Material.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideMentalSamplingQuality
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		type = "override",		--@var | type | Indica que es un override.
		subType = lb.overrides.getFileOverrideName (getThisScriptFilename() as string),	--@var | subType | Indica que tipo de override concreto almacena.
		relatedTypes = #(), --@var | relatedTypes | Tipos de overrides relacionados.
		
		stateMessage = "", --@var | stateMessage | Mensaje del estado actual del override.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,						--@var | infoNodeCA | Variable de atajo para el CA de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideMentalSamplingQualityInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideMentalSamplingQualityInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
		visibilityArray = #("1", "4", "9", "16", "25", "36", "49", "64", "81", "100", "121", "144", "169", "196", "225"),
		samplingModesArray = #("Unified / Raytraced (Recommended)", "Classic / Raytraced", "Rasterizer / Scanline"),
		samplesArray = #("1/64","1/16","1/4","1","4","16","64","256","1024"),
		filtersArray = #("Box","Gauss","Triangle","Mitchell","Lanczos"),
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = (if (maxVersion())[1] >= 16000 then rollMainDef else rollMainDefBefore2014), --@var: rollMain | Almacena el rollout de edicion del override.
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------
			
		------------------------------------------------
		--@fn: string | getType | Devuelve el tipo del override.
		------------------------------------------------
		fn getType =
		(
			this.infoNodeCA.type
		),
			
		------------------------------------------------
		--@fn: string | getSubType | Devuelve el subtipo del override.
		------------------------------------------------
		fn getSubType =
		(
			this.infoNodeCA.subType
		),
		
		------------------------------------------------
		--@fn: node | getInfoNode | Devuelve el nodo físico de la escena que contiene la información del override.
		------------------------------------------------
		fn getInfoNode =
		(
			this.infoNode
		),
		
		------------------------------------------------
		--@fn: dotneObject | getUiObj | Devuelve el objeto de interface .net que controla este objeto.
		------------------------------------------------
		fn getUiObj =
		(
			this.uiObj
		),
		
		------------------------------------------------
		--@fn: override | getOverrideManager | Devuelve el override principal del que cuelga el especifico.
		------------------------------------------------
		fn getOverrideManager =
		(
			this.overrideManager
		),
		
		------------------------------------------------
		--@fn: container | getParentContainer | Devuelve el contenedor del que cuelga este override.
		------------------------------------------------
		fn getParentContainer =
		(
			if this.overrideManager != undefined then this.overrideManager.getParentContainer() else undefined
		),
		
		
		------------------------------------------------
		--@fn: string | getInfo | Devuelve la informacion que se debe mostrar en el UI.
		------------------------------------------------
		fn getInfo =
		(
			if (maxVersion())[1] >= 16000 then
			(
				if this.infoNodeCA.UnifiedEnable then
				(
					"Quality: " + (this.infoNodeCA.UnifiedQuality as string) + ", " \
					+ "Min: " +  (this.infoNodeCA.UnifiedMinSamples as string) + ", " \
					+ "Max: " +  (this.infoNodeCA.UnifiedMaxSamples as string)
				)
				else
				(
					if not this.infoNodeCA.ScanlineEnable then
					(
						"Min: " + (this.samplesArray[this.infoNodeCA.MinimumSamples + 4]) + ", " \
						+ "Max: " +  (this.samplesArray[this.infoNodeCA.MaximumSamples + 4])
					)
					else
					(
						"Shading: " + (this.infoNodeCA.RapidShadingSamples as string) + ", " \
						+ "Visibility: " +  (this.visibilityArray[this.infoNodeCA.RapidCollectRate])
					)--if else
				)--if else
			)
			else
			(
				"Min: " + (this.samplesArray[this.infoNodeCA.MinimumSamples + 4]) + ", " \
				+ "Max: " +  (this.samplesArray[this.infoNodeCA.MaximumSamples + 4])
			)--if else
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok
			
			--busca el override de render precedente obligatorio
			_rendererOverride = (this.getOverrideManager()).getRelativeAncestorOverride "renderer"
			
			if _rendererOverride != undefined then --si lo encuentra
			(
				--si el renderer no es mental ray, lo marca como erroneo ya que no va a poder aplicar los parametros
				_renderer = (_rendererOverride.customOverride.infoNodeCA.currentRenderer)
				if _renderer != "mental_ray_renderer" then
				(
					_state = #error
					this.stateMessage = "Previous 'renderer' override in the tree must be set to 'mental ray'"
				)
			)
			else --si no lo encuentra
			(
				this.stateMessage = "There must be a previows 'renderer' override in the tree"
				_state = #error
			)--if else
			
			_state
		),
		
		------------------------------------------------
		--@fn: name | getStateMessage | Devuelve el mensaje del estado actual del override.
		------------------------------------------------
		fn getStateMessage =
		(
			this.stateMessage
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setUiObj | Sustituye el objeto de interface relacionado con el override.
		--@gets: dotNetObject | newUiObj | Nuevo elemento de interface relacionado con el override.
		------------------------------------------------
		fn setUiObj newUiObj =
		(
			this.uiObj = newUiObj
		),
		
		------------------------------------------------
		--@fn: undefined | setOverrideManager | Sustituye el override principal del que cuelga el especifico.
		--@gets: override | newOverrideManager | Nuevo override principal.
		------------------------------------------------
		fn setOverrideManager newOverrideManager =
		(
			this.overrideManager = newOverrideManager
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | updateUIinfo | Actualiza la informacion del override en su objeto de UI si tuviera.		
		------------------------------------------------
		fn updateUIinfo =
		(
			--si hay nodo que actualizar
			if this.getUiObj() != undefined then
			(
				--actualiza los valores de las columnas
				(this.getUiObj()).setValue 1 (this.getInfo())
				(this.getUiObj()).setValue 5 (this.getState() as string)
					
				--actualiza el icono de estado
				lb.passManagerUI.rollMain.updateTrvContainerAppearance mode:#state node:(this.getUiObj())
					
				--actualiza los overrides relacionados
				for _relType in this.relatedTypes do
				(
					_relOverrides = (this.getOverrideManager()).getRelativeDescendantsOverride _relType
					for _relOv in _relOverrides do _relOv.updateUIinfo()
				)--for
			)
		),
		
		------------------------------------------------
		--@fn: boolean | createBackup | Crea el backup de este override antes de aplicarse
		--@gets: node | backupNode | Objeto en el que hacer el backup.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("BACKUP process start.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideMentalSamplingQualityInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				if (classof renderers.current) == mental_ray_renderer then
				(
					--Samplig mode
					if (maxVersion())[1] >= 16000 then
					(
						backupNode.custAttributes[#overrideMentalSamplingQualityInfo].UnifiedEnable = renderers.current.UnifiedEnable
						backupNode.custAttributes[#overrideMentalSamplingQualityInfo].UnifiedQuality = renderers.current.UnifiedQuality
						backupNode.custAttributes[#overrideMentalSamplingQualityInfo].UnifiedMinSamples = renderers.current.UnifiedMinSamples
						backupNode.custAttributes[#overrideMentalSamplingQualityInfo].UnifiedMaxSamples = renderers.current.UnifiedMaxSamples
						
						backupNode.custAttributes[#overrideMentalSamplingQualityInfo].ScanlineEnable = renderers.current.ScanlineEnable
						backupNode.custAttributes[#overrideMentalSamplingQualityInfo].RapidShadingSamples = renderers.current.RapidShadingSamples
						backupNode.custAttributes[#overrideMentalSamplingQualityInfo].RapidCollectRate = renderers.current.RapidCollectRate
					)
					
					--Samples
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].MinimumSamples = renderers.current.MinimumSamples
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].MaximumSamples = renderers.current.MaximumSamples
					
					--Filters
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].FilterType = renderers.current.Filter
					case this.filtersArray[renderers.current.Filter + 1] of
					(
						"Box":
						(
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].BoxFilterWidth  = renderers.current.BoxFilterWidth
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].BoxFilterHeight  = renderers.current.BoxFilterHeight						
						)
						
						"Gauss":
						(
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].GaussFilterWidth  = renderers.current.GaussFilterWidth
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].GaussFilterHeight  = renderers.current.GaussFilterHeight
						)
						
						"Triangle":
						(
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].TriangleFilterWidth  = renderers.current.TriangleFilterWidth
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].TriangleFilterHeight  = renderers.current.TriangleFilterHeight
						)
						
						"Mitchell":
						(
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].MitchellFilterWidth  = renderers.current.MitchellFilterWidth
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].MitchellFilterHeight  = renderers.current.MitchellFilterHeight
						)
						
						"Lanczos":
						(
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].LanczosFilterWidth  = renderers.current.LanczosFilterWidth
							backupNode.custAttributes[#overrideMentalSamplingQualityInfo].LanczosFilterHeight  = renderers.current.LanczosFilterHeight
						)
					)
					
					--Spatial Contest
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].RedSpatialContrast = renderers.current.RedSpatialContrast
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].GreenSpatialContrast = renderers.current.GreenSpatialContrast
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].BlueSpatialContrast = renderers.current.BlueSpatialContrast
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].AlphaSpatialContrast = renderers.current.AlphaSpatialContrast
						
					--Options
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].LockSamples = renderers.current.LockSamples
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].Jitter = renderers.current.Jitter
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].TaskSize = renderers.current.TaskSize
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].TaskOrder = renderers.current.TaskOrder
					backupNode.custAttributes[#overrideMentalSamplingQualityInfo].FrameBufferType = renderers.current.FrameBufferType
					
				)
				else
				(
					if saveLogs then lb.log.add ("BACKUP: Mental Ray is not the current renderer.") sender:("override." + (this.getSubType())) type:#warning level:(logLevel+1)
				)
				
				_success = true
			)--if
			else
			(				
				if saveLogs then lb.log.add ("BACKUP process error. Backup node is not valid.") sender:("override." + (this.getSubType())) type:#error level:(logLevel+1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node is not valid.")
				_success = false
			)
			
			if _success then
			(
				if saveLogs then lb.log.add ("BACKUP process complete.") sender:("override." + (this.getSubType())) type:#ok level:(logLevel+1)
			)
			else
			(
				if saveLogs then lb.log.add ("BACKUP process failed.") sender:("override." + (this.getSubType())) type:#warning level:(logLevel+1)
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			if saveLogs then lb.log.add ("RESTORE process start.") sender:("override." + (this.getSubType())) type:#info level:(logLevel)
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(	
				if backupNode.custAttributes[#overrideMentalSamplingQualityInfo] != undefined then
				(
					if (classof renderers.current) == mental_ray_renderer then
					(
						--Samplig mode
						if (maxVersion())[1] >= 16000 then
						(
							renderers.current.UnifiedEnable = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].UnifiedEnable
							renderers.current.UnifiedQuality = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].UnifiedQuality
							renderers.current.UnifiedMinSamples = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].UnifiedMinSamples
							renderers.current.UnifiedMaxSamples = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].UnifiedMaxSamples
							
							renderers.current.ScanlineEnable = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].ScanlineEnable
							renderers.current.RapidShadingSamples = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].RapidShadingSamples
							renderers.current.RapidCollectRate = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].RapidCollectRate
						)--if
						
						--Samples
						renderers.current.MinimumSamples = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].MinimumSamples
						renderers.current.MaximumSamples = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].MaximumSamples
						
						--Filters
						renderers.current.Filter = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].FilterType
						case this.filtersArray[renderers.current.Filter + 1] of
						(
							"Box":
							(
								renderers.current.BoxFilterWidth = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].BoxFilterWidth  
								renderers.current.BoxFilterHeight = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].BoxFilterHeight 						
							)
							
							"Gauss":
							(
								renderers.current.GaussFilterWidth = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].GaussFilterWidth  
								renderers.current.GaussFilterHeight = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].GaussFilterHeight 
							)
							
							"Triangle":
							(
								renderers.current.TriangleFilterWidth = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].TriangleFilterWidth
								renderers.current.TriangleFilterHeight = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].TriangleFilterHeight
							)
							
							"Mitchell":
							(
								renderers.current.MitchellFilterWidth = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].MitchellFilterWidth
								renderers.current.MitchellFilterHeight = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].MitchellFilterHeight
							)
							
							"Lanczos":
							(
								renderers.current.LanczosFilterWidth = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].LanczosFilterWidth
								renderers.current.LanczosFilterHeight = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].LanczosFilterHeight
							)
						)
						
						--Spatial Contest
						renderers.current.RedSpatialContrast = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].RedSpatialContrast
						renderers.current.GreenSpatialContrast = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].GreenSpatialContrast
						renderers.current.BlueSpatialContrast = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].BlueSpatialContrast
						renderers.current.AlphaSpatialContrast = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].AlphaSpatialContrast
							
						--Options
						renderers.current.LockSamples  = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].LockSamples
						renderers.current.Jitter = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].Jitter
						renderers.current.TaskSize  = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].TaskSize
						renderers.current.TaskOrder = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].TaskOrder
						renderers.current.FrameBufferType  = backupNode.custAttributes[#overrideMentalSamplingQualityInfo].FrameBufferType
						
						_success = true
					)
					else
					(
						if saveLogs then lb.log.add ("RESTORE: Mental ray is not the current renderer.") sender:("override." + (this.getSubType())) type:#warning level:(logLevel+1)
						_success = true
					)
				)
				else
				(
					if saveLogs then lb.log.add ("RESTORE process error. CA #overrideMentalSamplingQualityInfo is undefined") sender:("override." + (this.getSubType())) type:#error level:(logLevel+1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Custom Attribute is not defined.")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("RESTORE process error. Backup node is not valid.") sender:("override." + (this.getSubType())) type:#error level:(logLevel+1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not valid.")
				_success = false
			)
			
			if _success then
			(
				if saveLogs then lb.log.add ("RESTORE process complete.") sender:("override." + (this.getSubType())) type:#ok level:(logLevel)
			)
			else
			(
				if saveLogs then lb.log.add ("RESTORE process failed.") sender:("override." + (this.getSubType())) type:#error level:(logLevel)
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			_success = false
			if saveLogs then lb.log.add ("APPLY process start.") sender:("override." + (this.getSubType())) type:#info level:(logLevel)
			if (classof renderers.current) == mental_ray_renderer then
			(
				--Samplig mode
				if (maxVersion())[1] >= 16000 then
				(
					renderers.current.UnifiedEnable = this.infoNodeCA.UnifiedEnable
					renderers.current.UnifiedQuality = this.infoNodeCA.UnifiedQuality
					renderers.current.UnifiedMinSamples = this.infoNodeCA.UnifiedMinSamples
					renderers.current.UnifiedMaxSamples = this.infoNodeCA.UnifiedMaxSamples
					
					renderers.current.ScanlineEnable = this.infoNodeCA.ScanlineEnable
					renderers.current.RapidShadingSamples = this.infoNodeCA.RapidShadingSamples
					renderers.current.RapidCollectRate = this.infoNodeCA.RapidCollectRate
				)--if
				
				--Samples
				renderers.current.MinimumSamples = this.infoNodeCA.MinimumSamples 
				renderers.current.MaximumSamples= this.infoNodeCA.MaximumSamples
				
				--Filters
				renderers.current.Filter = this.infoNodeCA.FilterType
				case this.filtersArray[renderers.current.Filter + 1] of
				(
					"Box":
					(
						renderers.current.BoxFilterWidth = this.infoNodeCA.BoxFilterWidth  
						renderers.current.BoxFilterHeight = this.infoNodeCA.BoxFilterHeight 						
					)
					"Gauss":
					(
						renderers.current.GaussFilterWidth = this.infoNodeCA.GaussFilterWidth  
						renderers.current.GaussFilterHeight = this.infoNodeCA.GaussFilterHeight 
					)
					"Triangle":
					(
						renderers.current.TriangleFilterWidth = this.infoNodeCA.TriangleFilterWidth
						renderers.current.TriangleFilterHeight = this.infoNodeCA.TriangleFilterHeight
					)
					"Mitchell":
					(
						renderers.current.MitchellFilterWidth = this.infoNodeCA.MitchellFilterWidth
						renderers.current.MitchellFilterHeight = this.infoNodeCA.MitchellFilterHeight
					)
					"Lanczos":
					(
						renderers.current.LanczosFilterWidth = this.infoNodeCA.LanczosFilterWidth
						renderers.current.LanczosFilterHeight = this.infoNodeCA.LanczosFilterHeight
					)
				)
				
				--Spatial Contest
				renderers.current.RedSpatialContrast = this.infoNodeCA.RedSpatialContrast
				renderers.current.GreenSpatialContrast = this.infoNodeCA.GreenSpatialContrast
				renderers.current.BlueSpatialContrast = this.infoNodeCA.BlueSpatialContrast
				renderers.current.AlphaSpatialContrast = this.infoNodeCA.AlphaSpatialContrast
					
				--Options
				renderers.current.LockSamples  = this.infoNodeCA.LockSamples
				renderers.current.Jitter = this.infoNodeCA.Jitter
				renderers.current.TaskSize  = this.infoNodeCA.TaskSize
				renderers.current.TaskOrder = this.infoNodeCA.TaskOrder
				renderers.current.FrameBufferType  = this.infoNodeCA.FrameBufferType
				
				_success = true
			)
			else
			(
				if saveLogs then lb.log.add ("APPLY process error. Mental Ray is not the current renderer.") sender:("override." + (this.getSubType())) type:#error level:(logLevel+1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D" + "APPLY process error. Mental Ray is not the current renderer.")
				_success = false
			)
			
			if _success then
			(
				if saveLogs then lb.log.add ("APPLY process complete.") sender:("override." + (this.getSubType())) type:#ok level:(logLevel)
			)
			else
			(
				if saveLogs then lb.log.add ("APPLY process failed.") sender:("override." + (this.getSubType())) type:#error level:(logLevel)
			)
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | applyEditChanges | Aplica los cambios que se han hecho en el override durante la edicion.
		------------------------------------------------
		fn applyEditChanges =
		(
			--solo si existe el nodo de backup de override puede hacerlo
			if this.editBackupNode != undefined then
			(
				--le quita el CA del override si lo tuviera
				if this.editBackupNode.custAttributes[#overrideMentalSamplingQualityInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideMentalSamplingQualityInfo]) _prop))
					)--undo
					
					this.editBackupNode = undefined --hace que el override no tenga backup de edicion almacenado
					
					this.updateUIinfo() --actualiza la infirmacion en el UI si ha cambiado
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | createEditBackup | Crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello.		
		------------------------------------------------
		fn createEditBackup =
		(
			--solo si el override cuelga de un contenedor
			if (this.getParentContainer()) != undefined then
			(
				--obtiene el inicio de la jerarquia del arbol de contenedores
				_passTree = (this.getParentContainer()).getRootContainer()
				
				if _passTree != undefined then --si ha conseguido llegar a la raiz
				(
					--obtiene el nodo de backup de edicion de override
					this.editBackupNode = _passTree.getOverridesEditBackupNode()
					
					--solo si existe el nodo de backup de override puede hacerlo
					if this.editBackupNode != undefined then
					(
						--le quita el CA del override si lo tuviera
						if this.editBackupNode.custAttributes[#overrideMentalSamplingQualityInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideMentalSamplingQualityInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideMentalSamplingQualityInfo]) _prop (getProperty (this.infoNodeCA) _prop))
					)--if
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Muestra el dialogo de edicion del override.
		--@opt: Point2 | pos | [0,0] | Posicion en la que aparecera el rollout de edicion del override.
		------------------------------------------------
		fn edit pos:[0,0] =
		(
			this.createEditBackup() --crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello 			
			
			lb.passManager.setCurrentEditInstance this
			
			_size = [300, 250]
			if (maxVersion())[1] >= 16000 then _size = [300, 300]
			
			_pos = pos - (_size/2)
			
			createDialog this.rollMain lockwidth:true lockheight:true pos:_pos width:_size.x height:_size.y modal:true style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: boolean | purge | Limpia el override por si se ha cambiado informacion y hay que mantenerla coherente.
		------------------------------------------------
		fn purge =
		(
			_success = false
			
			--TO DO: Aqui hacer el codigo de purga
			
			_success = true
			
			_success
		),
		
		
		------------------------------------------------
		--@fn: undefined | reset | resetea los valores a los que tiene por defecto.
		------------------------------------------------
		fn reset =
		(
			--TO DO: Aqui restaurar los valores a los que tiene por defecto
		),

		------------------------------------------------
		--@fn: undefined | storeSceneValues | Almacena los valores de la escena en el override.
		------------------------------------------------
		fn storeSceneValues =
		(
			_renderer = if classof renderers.current ==  mental_ray_renderer then renderers.current else mental_ray_renderer()
					
			------------------------------------------------
			--Sampling Quality
			if (maxVersion())[1] >= 16000 then
			(
				this.infoNodeCA.UnifiedEnable = _renderer.UnifiedEnable
				this.infoNodeCA.UnifiedQuality = _renderer.UnifiedQuality
				this.infoNodeCA.UnifiedMinSamples = _renderer.UnifiedMinSamples
				this.infoNodeCA.UnifiedMaxSamples = _renderer.UnifiedMaxSamples
				
				this.infoNodeCA.ScanlineEnable = _renderer.ScanlineEnable
				this.infoNodeCA.RapidCollectRate = _renderer.RapidCollectRate
				this.infoNodeCA.RapidShadingSamples = _renderer.RapidShadingSamples
			)
			------------------------------------------------
			
			------------------------------------------------
			--Samples
			
			this.infoNodeCA.MinimumSamples = _renderer.MinimumSamples
			this.infoNodeCA.MaximumSamples = _renderer.MaximumSamples
			------------------------------------------------
			
			------------------------------------------------
			--Filters
			
			this.infoNodeCA.FilterType = _renderer.Filter
			this.infoNodeCA.BoxFilterWidth = _renderer.BoxFilterWidth
			this.infoNodeCA.BoxFilterHeight = _renderer.BoxFilterHeight						
			this.infoNodeCA.GaussFilterWidth = _renderer.GaussFilterWidth
			this.infoNodeCA.GaussFilterHeight = _renderer.GaussFilterHeight
			this.infoNodeCA.TriangleFilterWidth = _renderer.TriangleFilterWidth
			this.infoNodeCA.TriangleFilterHeight = _renderer.TriangleFilterHeight
			this.infoNodeCA.MitchellFilterWidth = _renderer.MitchellFilterWidth
			this.infoNodeCA.MitchellFilterHeight = _renderer.MitchellFilterHeight
			this.infoNodeCA.LanczosFilterWidth = _renderer.LanczosFilterWidth
			this.infoNodeCA.LanczosFilterHeight = _renderer.LanczosFilterHeight
			------------------------------------------------
			
			------------------------------------------------
			--Spatial Contrast
			
			this.infoNodeCA.RedSpatialContrast= _renderer.RedSpatialContrast
			this.infoNodeCA.GreenSpatialContrast = _renderer.GreenSpatialContrast
			this.infoNodeCA.BlueSpatialContrast = _renderer.BlueSpatialContrast
			this.infoNodeCA.AlphaSpatialContrast = _renderer.AlphaSpatialContrast
			------------------------------------------------
			
			------------------------------------------------
			--Options
			
			this.infoNodeCA.LockSamples = _renderer.LockSamples
			this.infoNodeCA.Jitter = _renderer.Jitter
			this.infoNodeCA.TaskSize = _renderer.TaskSize
			this.infoNodeCA.TaskOrder = _renderer.TaskOrder
			this.infoNodeCA.FrameBufferType = _renderer.FrameBufferType
			------------------------------------------------
		),
		
		------------------------------------------------
		--@fn: undefined | construct | Rellena la información del override y crea el objeto fisico en la escena que contendrá la información.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la información la coge de el.
			if isValidNode this.infoNode then
			(	
				--Si se esta construyendo el objeto no tendra el CA aplicado, con lo cual hay que ponerselo. Si ya lo tiene no.
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideMentalSamplingQualityInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalSamplingQualityInfo]

					this.storeSceneValues()
				)

				--Rellenamos la variable de atajo
				this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalSamplingQualityInfo]
				
				--primero mira si hay cambios en la escena que afecten al override y lo limpia
				this.purge()
			)--if				
		),
		
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la representacion del contenido del override.
		------------------------------------------------
		fn toString =
		(	
			--primero mira si hay cambios en la escena que afecten al override y lo limpia
			this.purge()
			
			_theString = ""
				
			--TO DO: Aqui falta todo el codigo del toString
			
			_theString
		),
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
			
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrerías en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librería.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librerías hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event | create | Ejecución al crearse la instancia del struct.
		on create do
		(
			this.construct() --genera toda la información necesaria y el nodo de la escena donde almacenarla en paralelo, o lee el ya existente en la escena.
		)
		
	)--str_overrideMentalSamplingQuality
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideMentalSamplingQuality --añade el override al listado de overrides disponibles
	
	ok
)