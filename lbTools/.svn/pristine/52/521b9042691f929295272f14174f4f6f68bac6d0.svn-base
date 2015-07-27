------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de MentalFinalGather
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute:overrideMentalFinalGatherInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideMentalFinalGatherInfo = attributes overrideMentalFinalGatherInfo   
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de MentalFinalGather."
			
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"mentalFinalGather" --(lb.overrides.getFileOverrideName (getThisScriptFilename() as string))	--@var | subType | Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--Parámetros de backup
			
			------------------------------------------------

			------------------------------------------------
			--Parámetros de backup y apply
			
			FinalGatherEnable2 type:#boolean default:false
			FGMultiplierScalar type:#float default:1.0
			FGMultiplierColor type:#color default:(color 255 255 255)
			
			FGProjectionMode type:#integer default:0
			FGProjectionModeNumSegments type:#integer default:9
			FinalGatherDensity type:#float default:1.0
			FinalGatherAccuracy type:#integer default:250
			FinalGatherInterpolationSamples type:#integer default:27
			FinalGatherBounces type:#integer default:0
			FinalGatherBounceMultiplier type:#float default:1.0
			
			FinalGatherFilter type:#integer default:1
			FinalGatherPreview type:#boolean default:false
			
			FinalGatherTraceDepth type:#integer default:5
			FinalGatherReflectionDepth type:#integer default:5
			FinalGatherRefractionDepth type:#integer default:5
			FinalGatherFalloff type:#boolean default:false
			FinalGatherFalloffStart type:#float default:0.0
			FinalGatherFalloffStop type:#float default:0.0
			
			FinalGatherUseRadiusInterpolation type:#boolean default:false
			FinalGatherView type:#boolean default:false
			UseFinalGatherRadius type:#boolean default:false
			UseFinalGatherMinRadius type:#boolean default:false
			FinalGatherRadius type:#float default:1.0
			FinalGatherMinRadius type:#float default:1.0
			FinalGatherRadius_View type:#float default:5.0
			FinalGatherMinRadius_View type:#float default:5.0
			
			------------------------------------------------
			
			------------------------------------------------
			--Parámetros de apply

			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Final Gather Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = false --@var : editCA | Almacena el customAttribute de edición.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpBasic "Basic" pos:[5,0] width:290 height:215
		
		checkbox chkEnableFinalGather "Enable Final Gather" pos:[15,15] width:120 height:15 checked:true
		spinner spnMultiplier "Multiplier:    " pos:[175,15] width:95 height:16 range:[0,999999995904,1] type:#float scale:0.1
		colorPicker clrTint "" pos:[270,15] width:20 height:20
		
		groupBox grpFGprecision "FG Precision Presets:" pos:[10,33] width:280 height:47
		
		slider sldFGpresets "" pos:[20,45] width:145 height:20 ticks:4 range:[0,100,0] type:#integer
		editText edtFGpresets "" pos:[160,55] width:125 height:20 readonly:true
		
		dropDownList ddlProject "" pos:[10,85] width:280 height:21 selection:1 items:#("Project FG Points From Camera Position (Best for Stills)", "Project FG Points From Positions Along Camera Path")
		
		label lblDivide "Divide Camera Path by Num. Segments:" pos:[10,110] width:195 height:15
		dropDownList ddlSegments "" pos:[220,105] width:70 height:21 selection:3 items:#("1", "4", "9", "16", "25", "36", "49", "64", "81", "100")
		
		label lblInitialFGdensity "Initial FG Point Density:" pos:[10,130] width:195 height:15
		spinner spnFGpointDensity "" pos:[220,130] width:70 height:16 range:[0,100,0.1] type:#float scale:0.1
		
		label lblRaysPerFGPoint "Rays per FG Point:" pos:[10,150] width:195 height:15
		spinner spnRaysPerFGpoint "" pos:[220,150] width:70 height:16 range:[1,1000000,50] type:#integer scale:1
		
		label lblInterpolateOver "Interpolate Over Num. FG Points:" pos:[10,170] width:195 height:15
		spinner spnInterpolateOver "" pos:[220,170] width:70 height:16 range:[0,1000,30] type:#integer scale:1
		
		label lblBounces "Diffuse Bounces" pos:[10,190] width:80 height:15
		spinner spnBounces "" pos:[100,190] width:70 height:16 range:[0,1000000,0] type:#integer scale:1
		
		label lblWeight "Weight:" pos:[180,190] width:40 height:15
		spinner spnWeight "" pos:[220,190] width:70 height:16 range:[0,1,1] type:#float scale:0.1
		
		groupBox grpAdvanced "Advanced" pos:[5,220] width:290 height:245
		
		label lblNoise "Noise Filtering (Speckle Reduction):" pos:[15,235] width:175 height:15
		dropDownList ddlNoiseFilter "" pos:[195,230] width:95 height:21 selection:2 items:#("None", "Standard", "High", "Very High", "Extremely High")
		checkbox chkDraftMode "Draft Mode (No Precalculations)" pos:[15,255] width:175 height:15 checked:false
		
		groupBox grpTraceDepth "Trace Depth" pos:[10,275] width:280 height:105
		
		spinner spnMaxDepth "Max. Depth:" pos:[60,295] width:70 height:16 range:[0,1000000,5] type:#integer scale:1
		spinner spnMaxRefl "Max. Reflections: " pos:[195,295] width:90 height:16 range:[0,1000000,2] type:#integer scale:1
		spinner spnMaxRefr "Max. Refractions: " pos:[195,315] width:90 height:16 range:[0,1000000,5] type:#integer scale:1
		
		checkbox chkUseFalloff "Use Falloff (Limits Ray Distance)" pos:[20,335] width:175 height:15 checked:false
		spinner spnStart "Start:          " pos:[60,355] width:70 height:16 range:[0,1000000,0] type:#float scale:0.1
		spinner spnStop "Stop:                    " pos:[195,355] width:90 height:16 range:[0,1000000,0] type:#float scale:0.1
		
		groupBox grpFGpointInterpolation "FG Point Interpolation" pos:[10,385] width:280 height:75
		
		checkbox chkRadiusInterpolation "Use Radius Interpolation Method" pos:[20,400] width:180 height:15 checked:false
		checkbox chkRadPixels "Radii in Pixels" pos:[20,440] width:85 height:15 checked:false
		checkbox chkRadius "Radius:" pos:[145,420] width:80 height:15 checked:false
		spinner spnRadius "" pos:[225,420] width:60 height:16 range:[0,1000000,0.3] type:#float scale:0.1
		checkbox chkMinRadius "Min. Radius:" pos:[145,440] width:80 height:15 checked:false
		spinner spnMinRadius "" pos:[225,440] width:60 height:16 range:[0,1000000,0] type:#float scale:0.1
		
		button btnOk "OK" pos:[5,475] width:145 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[150,475] width:145 --@control | btnCancel | Cancela los cambios y cierra.
		
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
		--@fn: undefined | refreshUI | Refresca el estado de los controles del preset de FG.
		------------------------------------------------
		fn refreshPresetSliderUI onlyText:false =
		(
			_currentValues = #(spnFGpointDensity.value, spnRaysPerFGpoint.value, spnInterpolateOver.value) as string
			
			case _currentValues of
			(
				"#(0.1, 50, 30)":
				(
					if not onlyText then sldFGpresets.value = 0
					edtFGpresets.text = "Draft"
				)
				
				"#(0.4, 150, 30)":
				(
					if not onlyText then sldFGpresets.value = 25
					edtFGpresets.text = "Low"
				)
				
				"#(0.8, 250, 30)":
				(
					if not onlyText then sldFGpresets.value = 50
					edtFGpresets.text = "Medium"
				)
				
				"#(1.5, 500, 30)":
				(
					if not onlyText then sldFGpresets.value = 75
					edtFGpresets.text = "High"
				)
				
				"#(4.0, 10000, 100)":
				(
					if not onlyText then sldFGpresets.value = 100
					edtFGpresets.text = "Very High"
				)
				
				default:
				(
					if not onlyText then sldFGpresets.value = 100
					edtFGpresets.text = "Custom"
				)
			)--case
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | refreshUI | Refresca el estado de los controles en funcion de sus valores.
		------------------------------------------------
		fn refreshUI =
		(
			_state = chkEnableFinalGather.checked
			
			spnMultiplier.enabled = _state
			clrTint.enabled = _state
			
			sldFGpresets.enabled = _state
			edtFGpresets.enabled = _state
			
			ddlProject.enabled = _state
			ddlSegments.enabled = _state and (ddlProject.selection == 2)
			spnFGpointDensity.enabled = _state
			spnRaysPerFGpoint.enabled = _state
			spnInterpolateOver.enabled = _state and not chkRadiusInterpolation.checked
			spnBounces.enabled = _state
			spnWeight.enabled = _state
			
			ddlNoiseFilter.enabled = _state
			chkDraftMode.enabled = _state
			
			spnMaxDepth.enabled = _state
			spnMaxRefl.enabled = _state
			spnMaxRefr.enabled = _state
			
			chkUseFalloff.enabled = _state
			spnStart.enabled = _state and chkUseFalloff.checked
			spnStop.enabled = _state and chkUseFalloff.checked
			
			chkRadiusInterpolation.enabled = _state
			chkRadPixels.enabled = _state and chkRadiusInterpolation.checked
			chkRadius.enabled = _state and chkRadiusInterpolation.checked
			spnRadius.enabled = _state and chkRadiusInterpolation.checked
			chkMinRadius.enabled = _state and chkRadiusInterpolation.checked and chkRadius.checked
			spnMinRadius.enabled = _state and chkRadiusInterpolation.checked and chkRadius.checked
		)
		
		------------------------------------------------
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			_backupCA = editCA
			
			chkEnableFinalGather.checked = _backupCA.FinalGatherEnable2
			spnMultiplier.value = _backupCA.FGMultiplierScalar
			clrTint.color = _backupCA.FGMultiplierColor
			
			ddlProject.selection = _backupCA.FGProjectionMode + 1
			ddlSegments.selection = findItem ddlSegments.items (_backupCA.FGProjectionModeNumSegments as string)
			spnFGpointDensity.value = _backupCA.FinalGatherDensity
			spnRaysPerFGpoint.value = _backupCA.FinalGatherAccuracy
			spnInterpolateOver.value = _backupCA.FinalGatherInterpolationSamples
			spnBounces.value = _backupCA.FinalGatherBounces
			spnWeight.value = _backupCA.FinalGatherBounceMultiplier
			
			ddlNoiseFilter.selection = _backupCA.FinalGatherFilter + 1
			chkDraftMode.checked = _backupCA.FinalGatherPreview
			
			spnMaxDepth.value = _backupCA.FinalGatherTraceDepth
			spnMaxRefl.value = _backupCA.FinalGatherReflectionDepth
			spnMaxRefr.value = _backupCA.FinalGatherRefractionDepth
			
			chkUseFalloff.checked = _backupCA.FinalGatherFalloff
			spnStart.value = _backupCA.FinalGatherFalloffStart
			spnStop.value = _backupCA.FinalGatherFalloffStop
			
			chkRadiusInterpolation.checked = _backupCA.FinalGatherUseRadiusInterpolation
			chkRadPixels.checked = _backupCA.FinalGatherView
			chkRadius.checked = _backupCA.UseFinalGatherRadius
			spnRadius.value = if not chkRadPixels.checked then _backupCA.FinalGatherRadius else _backupCA.FinalGatherRadius_View
			chkMinRadius.checked = _backupCA.UseFinalGatherMinRadius
			spnMinRadius.value = if not chkRadPixels.checked then _backupCA.FinalGatherMinRadius else _backupCA.FinalGatherMinRadius_View
			
			refreshPresetSliderUI()			
			refreshUI()			
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
		--@event: changed | Evento que se lanza al cambiar el estado.
		--@control: checkBox | chkEnableFinalGather | checkBox que cambia de estado
		--@gets: boolean | state | Nuevo estado.
		------------------------------------------------
		on chkEnableFinalGather changed state do
		(
			_backupCA = editCA
			_backupCA.FinalGatherEnable2 = state
			refreshUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnMultiplier | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnMultiplier changed val do
		(
			_backupCA = editCA
			_backupCA.FGMultiplierScalar = val
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el color.
		--@control: colorPicker | clrTint | colorPicker que cambia de color.
		--@gets: color | vale | Nuevo color.
		------------------------------------------------
		on clrTint changed val do
		(
			_backupCA = editCA
			_backupCA.FGMultiplierColor = val
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el slider.
		--@control: slider | sldFGpresets | Slider que cambia de valor.
		--@gets: integer | vale | Nuevo valor.
		------------------------------------------------
		on sldFGpresets changed val do
		(
			_backupCA = editCA
			
			if val < 13 then sldFGpresets.value = 0
			else if val < 38 then sldFGpresets.value = 25
			else if val < 63 then sldFGpresets.value = 50
			else if val < 88 then sldFGpresets.value = 75
			else sldFGpresets.value = 100
			
			case sldFGpresets.value of
			(
				0:
				(
					spnFGpointDensity.value = 0.1
					spnRaysPerFGpoint.value = 50
					spnInterpolateOver.value = 30
				)
				
				25:
				(
					spnFGpointDensity.value = 0.4
					spnRaysPerFGpoint.value = 150
					spnInterpolateOver.value = 30
				)
				
				50:
				(
					spnFGpointDensity.value = 0.8
					spnRaysPerFGpoint.value = 250
					spnInterpolateOver.value = 30
				)
				
				75:
				(
					spnFGpointDensity.value = 1.5
					spnRaysPerFGpoint.value = 500
					spnInterpolateOver.value = 30
				)
				
				100:
				(
					spnFGpointDensity.value = 4.0
					spnRaysPerFGpoint.value = 10000
					spnInterpolateOver.value = 100
				)
			)--case
			
			_backupCA.FinalGatherDensity = spnFGpointDensity.value
			_backupCA.FinalGatherAccuracy = spnRaysPerFGpoint.value
			_backupCA.FinalGatherInterpolationSamples = spnInterpolateOver.value
			
			refreshPresetSliderUI onlyText:true
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el listado.
		--@control: dropdownlist | ddlProject | Dropdown que cambia de seleccion
		--@gets: integer | index | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlProject selected index do
		(
			_backupCA = editCA
			_backupCA.FGProjectionMode = index - 1
			refreshUI()
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el listado.
		--@control: dropdownlist | ddlSegments | Dropdown que cambia de seleccion
		--@gets: integer | index | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlSegments selected index do
		(
			_backupCA = editCA
			_backupCA.FGProjectionModeNumSegments = ddlSegments.items[index] as integer
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnFGpointDensity | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnFGpointDensity changed val do
		(
			_backupCA = editCA
			_backupCA.FinalGatherDensity = val
			refreshPresetSliderUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnRaysPerFGpoint | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnRaysPerFGpoint changed val do
		(
			_backupCA = editCA
			_backupCA.FinalGatherAccuracy = val
			refreshPresetSliderUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnInterpolateOver | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnInterpolateOver changed val do
		(
			_backupCA = editCA
			_backupCA.FinalGatherInterpolationSamples = val
			refreshPresetSliderUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnBounces | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnBounces changed val do
		(
			_backupCA = editCA
			_backupCA.FinalGatherBounces = val
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnWeight | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnWeight changed val do
		(
			_backupCA = editCA
			_backupCA.FinalGatherBounceMultiplier = val
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el listado.
		--@control: dropdownlist | ddlNoiseFilter | Dropdown que cambia de seleccion.
		--@gets: integer | index | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlNoiseFilter selected index do
		(
			_backupCA = editCA
			_backupCA.FinalGatherFilter = index - 1
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado.
		--@control: checkBox | chkDraftMode | checkBox que cambia de estado.
		--@gets: boolean | state | Nuevo estado.
		------------------------------------------------
		on chkDraftMode changed state do
		(
			_backupCA = editCA
			_backupCA.FinalGatherPreview = state
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnMaxDepth | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnMaxDepth changed val do
		(
			_backupCA = editCA
			_backupCA.FinalGatherTraceDepth = val
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnMaxRefl | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnMaxRefl changed val do
		(
			_backupCA = editCA
			_backupCA.FinalGatherReflectionDepth = val
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnMaxRefr | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnMaxRefr changed val do
		(
			_backupCA = editCA
			_backupCA.FinalGatherRefractionDepth = val
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado.
		--@control: checkBox | chkUseFalloff | checkBox que cambia de estado.
		--@gets: boolean | state | Nuevo estado.
		------------------------------------------------
		on chkUseFalloff changed state do
		(
			_backupCA = editCA
			_backupCA.FinalGatherFalloff = state
			refreshUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnStart | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnStart changed val do
		(
			_backupCA = editCA
			
			_backupCA.FinalGatherFalloffStart = val
			if val > spnStop.value then
			(
				spnStop.value = val
				_backupCA.FinalGatherFalloffStop = val
			)
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnStop | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnStop changed val do
		(
			_backupCA = editCA
			
			_backupCA.FinalGatherFalloffStop = val
			if val < spnStart.value then
			(
				spnStart.value = val
				_backupCA.FinalGatherFalloffStart = val
			)
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado.
		--@control: checkBox | chkRadiusInterpolation | checkBox que cambia de estado.
		--@gets: boolean | state | Nuevo estado.
		------------------------------------------------
		on chkRadiusInterpolation changed state do
		(
			_backupCA = editCA
			_backupCA.FinalGatherUseRadiusInterpolation = state
			refreshUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado.
		--@control: checkBox | chkRadPixels | checkBox que cambia de estado.
		--@gets: boolean | state | Nuevo estado.
		------------------------------------------------
		on chkRadPixels changed state do
		(
			_backupCA = editCA
			_backupCA.FinalGatherView = state
			
			spnRadius.value = if not chkRadPixels.checked then _backupCA.FinalGatherRadius else _backupCA.FinalGatherRadius_View
			spnMinRadius.value = if not chkRadPixels.checked then _backupCA.FinalGatherMinRadius else _backupCA.FinalGatherMinRadius_View
				
			refreshUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado.
		--@control: checkBox | chkRadius | checkBox que cambia de estado.
		--@gets: boolean | state | Nuevo estado.
		------------------------------------------------
		on chkRadius changed state do
		(
			_backupCA = editCA
			_backupCA.UseFinalGatherRadius = state
			refreshUI()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado.
		--@control: checkBox | chkMinRadius | checkBox que cambia de estado.
		--@gets: boolean | state | Nuevo estado.
		------------------------------------------------
		on chkMinRadius changed state do
		(
			_backupCA = editCA
			_backupCA.UseFinalGatherMinRadius = state
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnRadius | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnRadius changed val do
		(
			_backupCA = editCA
			
			if not chkRadPixels.checked then _backupCA.FinalGatherRadius = val else _backupCA.FinalGatherRadius_View = val
			if val < spnMinRadius.value then
			(
				spnMinRadius.value = val
				if not chkRadPixels.checked then _backupCA.FinalGatherMinRadius = val else _backupCA.FinalGatherMinRadius_View = val
			)
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnMinRadius | spinner que cambia de valor.
		--@gets: float | vale | Nuevo valor.
		------------------------------------------------
		on spnMinRadius changed val do
		(
			_backupCA = editCA
			
			if not chkRadPixels.checked then _backupCA.FinalGatherMinRadius = val else _backupCA.FinalGatherMinRadius_View = val
			if val > spnRadius.value then
			(
				spnRadius.value = val
				if not chkRadPixels.checked then _backupCA.FinalGatherRadius = val else _backupCA.FinalGatherRadius_View = val				
			)
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
			
			editCA = parent.editBackupNode.custAttributes[#overrideMentalFinalGatherInfo]
			
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
	struct str_overrideMentalFinalGather
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		--state = #ok, --@var: state | Almacena el estado del override. Puede ser #ok, #warning y #error
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		type = "override",		--@var | type | Indica que es un override.
		subType = lb.overrides.getFileOverrideName (getThisScriptFilename() as string),	--@var | subType | Indica que tipo de override concreto almacena.
		relatedTypes = #("mentalReuseFG"), --@var | relatedTypes | Tipos de overrides relacionados.
		
		stateMessage = "", --@var | stateMessage | Mensaje del estado actual del override.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,						--@var | infoNodeCA | Almacena el customAttribute de apply
		
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideMentalFinalGatherInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideMentalFinalGatherInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef, --@var: rollMain | Almacena el rollout de edicion del override.
		
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
			_info = ""
			
 			_info += this.infoNodeCA.FinalGatherEnable2 as string
			
			_info
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
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("BACKUP process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideMentalFinalGatherInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				if (classof renderers.current) == mental_ray_renderer then
				(
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherEnable2 = renderers.current.FinalGatherEnable2
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FGMultiplierScalar = renderers.current.FGMultiplierScalar
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FGMultiplierColor = renderers.current.FGMultiplierColor
					
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FGProjectionMode = renderers.current.FGProjectionMode
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FGProjectionModeNumSegments = renderers.current.FGProjectionModeNumSegments
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherDensity = renderers.current.FinalGatherDensity
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherAccuracy = renderers.current.FinalGatherAccuracy
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherInterpolationSamples = renderers.current.FinalGatherInterpolationSamples
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherBounces = renderers.current.FinalGatherBounces
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherBounceMultiplier = renderers.current.FinalGatherBounceMultiplier
					
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFilter = renderers.current.FinalGatherFilter
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherPreview = renderers.current.FinalGatherPreview
					
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherTraceDepth = renderers.current.FinalGatherTraceDepth
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherReflectionDepth = renderers.current.FinalGatherReflectionDepth
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRefractionDepth = renderers.current.FinalGatherRefractionDepth
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloff = renderers.current.FinalGatherFalloff
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloffStart = renderers.current.FinalGatherFalloffStart
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloffStop = renderers.current.FinalGatherFalloffStop
					
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherUseRadiusInterpolation = renderers.current.FinalGatherUseRadiusInterpolation
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherView = renderers.current.FinalGatherView
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].UseFinalGatherRadius = renderers.current.UseFinalGatherRadius
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].UseFinalGatherMinRadius = renderers.current.UseFinalGatherMinRadius
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRadius = renderers.current.FinalGatherRadius
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherMinRadius = renderers.current.FinalGatherMinRadius
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRadius_View = renderers.current.FinalGatherRadius_View
					backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherMinRadius_View = renderers.current.FinalGatherMinRadius_View
					
					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("Mental ray is not the current renderer") sender:("override." + (this.getSubType())) type:#warning level:(logLevel + 1)					
					_success = true
				)				
			)--if
			else
			(
				if saveLogs then lb.log.add ("Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node is not valid")
				_success = false
			)
			
			if saveLogs then
			(
				if _success then lb.log.add ("BACKUP process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("BACKUP process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("RESTORE process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(
				if backupNode.custAttributes[#overrideMentalFinalGatherInfo] != undefined then
				(				
					if (classof renderers.current) == mental_ray_renderer then
					(
						renderers.current.FinalGatherEnable2 = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherEnable2
						renderers.current.FGMultiplierScalar = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FGMultiplierScalar
						renderers.current.FGMultiplierColor = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FGMultiplierColor
						
						renderers.current.FGProjectionMode = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FGProjectionMode
						renderers.current.FGProjectionModeNumSegments = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FGProjectionModeNumSegments
						renderers.current.FinalGatherDensity = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherDensity
						renderers.current.FinalGatherAccuracy = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherAccuracy
						renderers.current.FinalGatherInterpolationSamples = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherInterpolationSamples
						renderers.current.FinalGatherBounces = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherBounces
						renderers.current.FinalGatherBounceMultiplier = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherBounceMultiplier
						
						renderers.current.FinalGatherFilter = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFilter
						renderers.current.FinalGatherPreview = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherPreview
						
						renderers.current.FinalGatherTraceDepth = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherTraceDepth
						renderers.current.FinalGatherReflectionDepth = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherReflectionDepth
						renderers.current.FinalGatherRefractionDepth = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRefractionDepth
						renderers.current.FinalGatherFalloff = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloff
						renderers.current.FinalGatherFalloffStart = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloffStart
						renderers.current.FinalGatherFalloffStop = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloffStop
						
						renderers.current.FinalGatherUseRadiusInterpolation = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherUseRadiusInterpolation
						renderers.current.FinalGatherView = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherView
						renderers.current.UseFinalGatherRadius = backupNode.custAttributes[#overrideMentalFinalGatherInfo].UseFinalGatherRadius
						renderers.current.UseFinalGatherMinRadius = backupNode.custAttributes[#overrideMentalFinalGatherInfo].UseFinalGatherMinRadius
						renderers.current.FinalGatherRadius = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRadius
						renderers.current.FinalGatherMinRadius = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherMinRadius
						renderers.current.FinalGatherRadius_View = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRadius_View
						renderers.current.FinalGatherMinRadius_View = backupNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherMinRadius_View
						
						_success = true
					)
					else
					(
						if saveLogs then lb.log.add ("Mental ray is not the current renderer") sender:("override." + (this.getSubType())) type:#warning level:(logLevel + 1)
						_success = true
					)
				)
				else
				(
					if saveLogs then lb.log.add ("Backup node with no custom attribute") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node with no custom attribute")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)				
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not valid.")
				_success = false
			)
			
			if saveLogs then
			(
				if _success then lb.log.add ("RESTORE process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("RESTORE process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			if (classof renderers.current) == mental_ray_renderer then
			(
				renderers.current.FinalGatherEnable2 = this.infoNodeCA.FinalGatherEnable2
				renderers.current.FGMultiplierScalar = this.infoNodeCA.FGMultiplierScalar
				renderers.current.FGMultiplierColor = this.infoNodeCA.FGMultiplierColor
				
				renderers.current.FGProjectionMode = this.infoNodeCA.FGProjectionMode
				renderers.current.FGProjectionModeNumSegments = this.infoNodeCA.FGProjectionModeNumSegments
				renderers.current.FinalGatherDensity = this.infoNodeCA.FinalGatherDensity
				renderers.current.FinalGatherAccuracy = this.infoNodeCA.FinalGatherAccuracy
				renderers.current.FinalGatherInterpolationSamples = this.infoNodeCA.FinalGatherInterpolationSamples
				renderers.current.FinalGatherBounces = this.infoNodeCA.FinalGatherBounces
				renderers.current.FinalGatherBounceMultiplier = this.infoNodeCA.FinalGatherBounceMultiplier
				
				renderers.current.FinalGatherFilter = this.infoNodeCA.FinalGatherFilter
				renderers.current.FinalGatherPreview = this.infoNodeCA.FinalGatherPreview
				
				renderers.current.FinalGatherTraceDepth = this.infoNodeCA.FinalGatherTraceDepth
				renderers.current.FinalGatherReflectionDepth = this.infoNodeCA.FinalGatherReflectionDepth
				renderers.current.FinalGatherRefractionDepth = this.infoNodeCA.FinalGatherRefractionDepth
				renderers.current.FinalGatherFalloff = this.infoNodeCA.FinalGatherFalloff
				renderers.current.FinalGatherFalloffStart = this.infoNodeCA.FinalGatherFalloffStart
				renderers.current.FinalGatherFalloffStop = this.infoNodeCA.FinalGatherFalloffStop
				
				renderers.current.FinalGatherUseRadiusInterpolation = this.infoNodeCA.FinalGatherUseRadiusInterpolation
				renderers.current.FinalGatherView = this.infoNodeCA.FinalGatherView
				renderers.current.UseFinalGatherRadius = this.infoNodeCA.UseFinalGatherRadius
				renderers.current.UseFinalGatherMinRadius = this.infoNodeCA.UseFinalGatherMinRadius
				renderers.current.FinalGatherRadius = this.infoNodeCA.FinalGatherRadius
				renderers.current.FinalGatherMinRadius = this.infoNodeCA.FinalGatherMinRadius
				renderers.current.FinalGatherRadius_View = this.infoNodeCA.FinalGatherRadius_View
				renderers.current.FinalGatherMinRadius_View = this.infoNodeCA.FinalGatherMinRadius_View
				
				_success = true
			)
			else
			(
				if saveLogs then lb.log.add ("Mental ray is not the current renderer") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)	
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"APPLY process error. Mental ray is not the current renderer.")
				_success = false
			)
			
			if saveLogs then
			(
				if _success then lb.log.add ("APPLY process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("APPLY process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
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
				if this.editBackupNode.custAttributes[#overrideMentalFinalGatherInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideMentalFinalGatherInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideMentalFinalGatherInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideMentalFinalGatherInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideMentalFinalGatherInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [300, 500]
			
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
					
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherEnable2 = _renderer.FinalGatherEnable2
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FGMultiplierScalar = _renderer.FGMultiplierScalar
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FGMultiplierColor = _renderer.FGMultiplierColor
			
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FGProjectionMode = _renderer.FGProjectionMode
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FGProjectionModeNumSegments = _renderer.FGProjectionModeNumSegments
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherDensity = _renderer.FinalGatherDensity
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherAccuracy = _renderer.FinalGatherAccuracy
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherInterpolationSamples = _renderer.FinalGatherInterpolationSamples
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherBounces = _renderer.FinalGatherBounces
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherBounceMultiplier = _renderer.FinalGatherBounceMultiplier
			
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFilter = _renderer.FinalGatherFilter
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherPreview = _renderer.FinalGatherPreview
			
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherTraceDepth = _renderer.FinalGatherTraceDepth
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherReflectionDepth = _renderer.FinalGatherReflectionDepth
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRefractionDepth = _renderer.FinalGatherRefractionDepth
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloff = _renderer.FinalGatherFalloff
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloffStart = _renderer.FinalGatherFalloffStart
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherFalloffStop = _renderer.FinalGatherFalloffStop
			
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherUseRadiusInterpolation = _renderer.FinalGatherUseRadiusInterpolation
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherView = _renderer.FinalGatherView
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].UseFinalGatherRadius = _renderer.UseFinalGatherRadius
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].UseFinalGatherMinRadius = _renderer.UseFinalGatherMinRadius
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRadius = _renderer.FinalGatherRadius
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherMinRadius = _renderer.FinalGatherMinRadius
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherRadius_View = _renderer.FinalGatherRadius_View
			this.infoNode.custAttributes[#overrideMentalFinalGatherInfo].FinalGatherMinRadius_View = _renderer.FinalGatherMinRadius_View
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideMentalFinalGatherInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalFinalGatherInfo]

					this.storeSceneValues()
				)--if
				
				this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalFinalGatherInfo]				
				
				this.purge() --primero mira si hay cambios en la escena que afecten al override y lo limpia
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
		
	)--str_overrideGBuffer
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideMentalFinalGather --añade el override al listado de overrides disponibles
	
	ok
)