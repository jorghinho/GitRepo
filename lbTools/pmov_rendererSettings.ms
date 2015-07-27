------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de Renderer
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideRendererInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideRendererSettingsInfo = attributes overrideRendererSettingsInfo   
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.1
			CA_description	type:#string	default:"Almacena la informacion de un override de Renderer Settings."
			
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"rendererSettings"	--@var | subType | Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
				
			-----------------------------------------------------------
			-- Parámetros de backup

			-----------------------------------------------------------
			
			-----------------------------------------------------------
			-- Parámetros de backup y apply
									
			------------------------------------------------
			--GENERAL

			currentRenderer type:#string	default:"" --@var | currentRenderer | Renderer seleccionado en el override.
			------------------------------------------------

			------------------------------------------------
			--SCANLINE

				------------------------------------------------
				--SCANLINE GENERAL PARAMS

					overrideScanlineGeneralParams type:#boolean default:false --@var | overrideScanlineGeneralParams | Habilita o deshabilita override de estos parámetros.
					
					antiAliasing		type:#boolean	default:true
					antiAliasFilter		type:#maxObject
					filterMaps			type:#boolean	default:true
					antiAliasFilterSize	type:#float	default:1.5

				--SCANLINE GENERAL PARAMS END
				------------------------------------------------

			--SCANLINE END
			------------------------------------------------			

			------------------------------------------------
			--MENTAL RAY

				------------------------------------------------
				--MENTAL SAMPLING QUALITY

					overrideMentalSamplingQuality type:#boolean default:false --@var | overrideMentalSamplingQuality | Habilita o deshabilita override de estos parámetros.

					------------------------------------------------
					--Sampling Mode
					
					UnifiedEnable	type:#boolean	default:true --@var | UnifiedEnable | Indica la opcion uno del desplegable de Sampling Mode.
					UnifiedQuality	type:#float	default:0.25 --@var | UnifiedQuality | Spinner de calidad.
					UnifiedMinSamples	type:#float	default:1.0 --@var | UnifiedMinSamples | Samples minimos.
					UnifiedMaxSamples	type:#integer	default:128 --@var | UnifiedMaxSamples | Samples máximos.
					
					ScanlineEnable	type:#boolean	default:false --@var | ScanlineEnable | Indica si esta habilitado Scanline.
					RapidCollectRate  	type:#integer 	default:4 		--@var | RapidCollectRate | Parámetro de glossy refraction
					RapidShadingSamples type:#float 	default:2.0 	--@var | RapidShadingSamples | Parámetro de samples de shading
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
				
				--MENTAL SAMPLING QUALITY END
				------------------------------------------------

				------------------------------------------------
				--MENTAL RENDERING ALGORITHMS

					overrideMentalRenderingAlgorithms type:#boolean default:false --@var | overrideMentalRenderingAlgorithms | Habilita o deshabilita override de estos parámetros.

					--YA DEFINIDO EN EL OVERRIDE DE SAMPLING /*ScanlineEnable 		type:#boolean 	default:false*/ 	--@var | ScanlineEnable | Precisión de las sombras.
					ScanlineMethod 		type:#integer 	default:0	 	--@var | ScanlineMethod | Parámetro de glossy reflection.
					--YA DEFINIDO EN EL OVERRIDE DE SAMPLING /*RapidCollectRate  	type:#integer 	default:4*/ 		--@var | RapidCollectRate |
					--YA DEFINIDO EN EL OVERRIDE DE SAMPLING /*RapidShadingSamples type:#float 	default:2.0*/ 	--@var | RapidShadingSamples |
					RaytraceEnable  	type:#boolean 	default:true 	--@var | RaytraceEnable |
					Autovolume  		type:#boolean 	default:false 	--@var | Autovolume |
					RaytraceMethod  	type:#float 	default:0.0 	--@var | RaytraceMethod |
					BSPSize    			type:#float 	default:0.0 	--@var | BSPSize |
					BSPDepth   			type:#float 	default:0.0 	--@var | BSPDepth |
					MaximumTraceDepth 	type:#integer 	default:6		--@var | MaximumTraceDepth |
					MaximumReflections 	type:#integer 	default:4 		--@var | MaximumReflections |
					MaximumRefractions 	type:#integer 	default:6 		--@var | MaximumRefractions |
					ReflectionsEnable 	type:#boolean 	default:true 	--@var | ReflectionsEnable |
					RefractionsEnable 	type:#boolean 	default:true 	--@var | RefractionsEnable |
					ShadowMethod		type:#integer 	default:0 	--@var | ShadowMethod | Parámetro Shadow Mode.
					enable_subset_pixel_rendering 	type:#boolean 	default:false 	--@var | RefractionsEnable |

				--MENTAL RENDERING ALGORITHMS END
				------------------------------------------------

				------------------------------------------------
				--MENTAL CAMERA EFFECTS

					overrideMentalCameraEffects type:#boolean default:false --@var | overrideMentalCameraEffects | Habilita o deshabilita override de estos parámetros.

					MotionBlurEnable		type:#boolean 	default:false
					MotionBlurAllObjects	type:#boolean 	default:true
					Shutter					type:#float 	default:0.5
					MotionBlurOffset		type:#float 	default:0.25
					Segments				type:#integer 	default:1
					TimeSamples				type:#integer 	default:5
					RapidMotionResample		type:#integer 	default:1

					EnableContours			type:#boolean 		default:false
					Contour_Contrast_Shader	type:#texturemap
					Contour_Store_Shader	type:#texturemap
					Contour_Output_Shader	type:#texturemap

					Enable_Camera_Lens_Shader	type:#boolean	default:true
					Camera_Lens_Shader			type:#maxObject
					Enable_Camera_Output_Shader	type:#boolean	default:false
					Camera_Output_Shader		type:#texturemap
					Enable_Camera_Volume_Shader	type:#boolean	default:true
					Camera_Volume_Shader		type:#maxObject

					DepthOfFieldEnable	type:#boolean	default:false
					DepthOfFieldMode	type:#integer 	default:0
					FocusPlane			type:#float 	default:100.0
					fStop				type:#float 	default:1.0	
					NearFocus			type:#float 	default:90.0
					FarFocus			type:#float 	default:110.0

				--MENTAL CAMERA EFFECTS END
				------------------------------------------------

				------------------------------------------------
				--MENTAL SHADOWS AND DISPLACEMENT

					overrideMentalShadowsAndDisplacement type:#boolean default:false --@var | overrideMentalShadowsAndDisplacement | Habilita o deshabilita override de estos parámetros.

					ShadowsEnable	type:#boolean 	default:true
					--YA DEFINIDO EN EL OVERRIDE DE RENDERING ALGORITHMS/*ShadowMethod	type:#integer 	default:0*/

					EnableShadowMaps	type:#boolean 	default:true
					MotionBlurShadowMapsEnable	type:#boolean 	default:true
					ShadowMapRebuild	type:#boolean 	default:true
					UseShadowMapFile	type:#boolean 	default:false
					ShadowMapFilename	type:#string 	default:""

					view			type:#boolean 	default:true
					Smooth			type:#boolean 	default:true
					Edge_Length		type:#float default:2.0
					Max_Displace	type:#float default:20.0
					Max_Level		type:#integer 	default:6

				--MENTAL SHADOWS AND DISPLACEMENT END
				------------------------------------------------

				------------------------------------------------
				--MENTAL GLOBAL TUNING PARAMS

					overrideMentalGlobalTuningParams type:#boolean default:false --@var | overrideMentalGlobalTuningParams | Habilita o deshabilita override de estos parámetros.

					softShadowsPrecision type:#float default:0.0 --@var | softshadowsprecision | Precisión de las sombras
					glossyReflectionsPrecision  type:#float default:0.0 --@var | glossyreflectionsprecision | Parámetro de glossy reflection
					glossyRefractionsPrecision  type:#float default:0.0 --@var | glossyrefractionsprecision | Parámetro de glossy refraction

				--MENTAL GLOBAL TUNING PARAMS END
				------------------------------------------------

				------------------------------------------------
				--MENTAL IBL

					overrideMentalIBL type:#boolean default:false --@var | overrideMentalIBL | Habilita o deshabilita override de estos parámetros.

					IBLEnable type:#boolean default:true --@var | IBLEnable | Activa el modo IBL si se usa TRUE y lo desactiva si se usa FALSE.
					IBLQuality type:#float default:0.5 --@var | IBLQuality | Caldad del IBL.
					IBLShadows type:#integer default:1 --@var | IBLShadows | Shadow cast de IBL. 0 transparent, 1 Opaque.

				--MENTAL IBL END
				------------------------------------------------				

				-----------------------------------------------
				--MENTAL FINAL GATHER

					overrideMentalFinalGather type:#boolean default:true --@var | overrideMentalFinalGather | Habilita o deshabilita override de estos parámetros.

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

				--MENTAL FINAL GATHER END
				------------------------------------------------

				-----------------------------------------------
				--MENTAL CAUSTICS

					overrideMentalCaustics type:#boolean default:false --@var | overrideMentalCaustics | Habilita o deshabilita override de estos parámetros.

					CausticsEnable type:#boolean default:false
					CausticMultiplierScalar type:#float default:1.0
					CausticMultiplierColor type:#color default:(color 255 255 255)
					CausticAccuracy type:#integer default:100
					UseCausticRadius type:#boolean default:false
					CausticRadius type:#float default:1.0
					CausticsFilter type:#integer default:0
					Kernel type:#float default:1.1
					CausticOpaqueShadows type:#boolean default:false
					
					GlobalIllumEnable type:#boolean default:false
					GIMultiplierScalar type:#float default:1.0
					GIMultiplierColor type:#color default:(color 255 255 255)
					GlobalIllumAccuracy type:#integer default:500
					UseGlobalIllumRadius type:#boolean default:false
					GlobalIllumRadius type:#float default:1.0
					UseGIPhotonMergeDistance type:#boolean default:false
					GIPhotonMergeDistance type:#float default:0.0
					OptimizeForFinalGather type:#boolean default:false

					VolumeAccuracy type:#integer default:100
					UseVolumeRadius type:#boolean default:false
					VolumeRadius type:#float default:1.0

					GIMaximumTraceDepth type:#integer default:5
					GIMaximumReflections type:#integer default:5
					GIMaximumRefractions type:#integer default:5

					GlobalLightCausticPhotons type:#integer default:20000
					GlobalLightGIPhotons type:#integer default:20000
					GlobalLightDecay type:#float default:2.0

					OverrideIIObjProps type:#boolean default:false

				--MENTAL CAUSTICS END
				-----------------------------------------------

				-----------------------------------------------
				--MENTAL REUSE FINAL GATHER

					overrideMentalReuseFG type:#boolean default:false --@var | overrideMentalReuseFG | Habilita o deshabilita override de estos parámetros.

					IlluminationCacheMode type:#integer default:0
					SkipFinalRender type:#boolean default:false
					
					UseFinalGatherFile type:#boolean default:false
					FinalGatherFreeze type:#boolean default:false
					FGInterpolateNFrames type:#integer default:2
					FinalGatherFilename type:#string default:""
					FinalGatherTempFilename type:#string default:""
						
					PhotonMapUseFile type:#boolean default:false
					PhotonFreeze type:#boolean default:false			
					PhotonMapFilename type:#string default:""
					FinalGatherOnly type:#boolean default:false
					PhotonsOnly type:#boolean default:false

				--MENTAL REUSE FINAL GATHER END
				------------------------------------------------

				-----------------------------------------------
				--MENTAL TRANSLATOR OPTIONS

					overrideMentalTranslatorOptions type:#boolean default:false --@var | overrideMentalReuseFG | Habilita o deshabilita override de estos parámetros.
					
					Use_Placeholders type:#boolean default:false
					Conserve_Memory type:#boolean default:false
					mental_ray_Manages_Maps type:#boolean default:false

					EnableGeometryCache type:#boolean default:false --ClearGeometryCache() --usar esta funcion para limpiar el cache en el apply
					LockGeometryCache type:#boolean default:false

					Enable_Material_Override type:#boolean default:false
					Override_Material type:#material

					Skip_Texture_Maps type:#boolean default:false

				--MENTAL TRANSLATOR OPTIONS END
				-----------------------------------------------

			--MENTAL RAY END
			------------------------------------------------

			-----------------------------------------------------------
			
			-----------------------------------------------------------
			-- Parámetros de apply

			-----------------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--FUNCION DE CARGAR DE LOS ROLLOUTS DE UI PARA EL OVERRIDE
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	------------------------------------------------
	--@fn: undefined | loadRollUIs | Carga los rollouts que necesita el override.
	------------------------------------------------	
	fn loadRollUIs =
	(
		_path = getFilenamePath (getThisScriptFilename() as string)
		_file = (lb.overrides.getFileOverrideName (getThisScriptFilename() as string))

		_uiRollsFiles = getFiles (_path + "pmovUI_" + _file + "-*")
		for _uiFile in _uiRollsFiles do filein _uiFile		
	)

	loadRollUIs()
	------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollExampleDef1 | Rollout de ejmplo 1.
	------------------------------------------------------------------------------------------------------------------------------------------------
	/*rollout rollExampleDef1 "Example rollout 1"
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
		
		--@control | controlName | plantilla de comentario de control.
		
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
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			--sin operaciones			
		)
		
		------------------------------------------------
		--@fn: undefined | updateUIControlsByOverrideEnabledState | habilita o deshabilita los controles del override en funcion de si está activo o no.
		------------------------------------------------
		fn updateUIControlsByOverrideEnabledState disableOnly:false =
		(
			--sin operaciones. mirar un UI de override de render creado
		)

		------------------------------------------------
		--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
		------------------------------------------------
		fn updateUI =
		(
			--sin operaciones
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
		--@event: open | Evento lanzado al abrirse el rollout.
		--@control: rollout | rollExampleDef1 | rollout actual.
		------------------------------------------------
		on rollExampleDef1 open do
		(
			parent = lb.passManager.getCurrentEditInstance()
			editCA = parent.editBackupNode.custAttributes[#overrideRendererSettingsInfo]
			loadOverrideInfo()
			loadSettings()
			createSceneEvents()

			resize() --redimensiona los componentes del UI una vez abierto
		)
		
		------------------------------------------------
		--@event: close | Evento lanzado al cerrarse el rollout.
		--@control: rollout | rollExampleDef1 | rollout actual.
		------------------------------------------------
		on rollExampleDef1 close do
		(
			removeSceneEvents()
			onCloseOperations()
			saveSettings()		
		)
	)--rollExampleDef1*/

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Renderer Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento.
		
		local editCA = undefined --@var : editCA| Variable de atajo para el CA de edit.
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 600	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local opening = false --@var: opening | Flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label lblRenderers "Select Renderer:" pos:[5,8]
		dropdownlist ddlRenderers "" pos:[90,5] items:#() height:20 width:255

		dotNetControl tbSettingsCategories "DevExpress.XtraTab.XtraTabControl" pos:[0,35] width:350 height:22 --25

		button btnOk "OK" pos:[5,575] width:170 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[175,575] width:170 --@control | btnCancel | Cancela los cambios y cierra.
		
		------------------------------------------------------------------------------------------------
		--SUBROLLOUTS
		------------------------------------------------------------------------------------------------

		subrollout subRollContainer1 "subRollouts" pos:[0,57] width:minRollWidth height:514 --@control | subRollContainer1 | SubRollouts container.

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
		--@fn: undefined | initUI | Inicializa los controles del UI.
		------------------------------------------------
		fn initUI =
		(	
			tbSettingsCategories.paintstylename = "PropertyView"
			tbSettingsCategories.borderStyle = (dotnetclass "DevExpress.XtraEditors.Controls.BorderStyles").noBorder
			tbSettingsCategories.TabPageWidth = 100			
			
			tbSettingsCategories.Appearance.BackColor = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbSettingsCategories.Appearance.BackColor2 = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbSettingsCategories.Appearance.BorderColor = (dotnetclass "system.drawing.color").fromArgb 100 100 100

			--showProperties tbSettingsCategories.Appearance
		)

		------------------------------------------------
		--@fn: undefined | resetRendererSpecificUI | Resetea el UI en funcion del motor de render elegido.
		------------------------------------------------
		fn resetRendererSpecificUI =
		(
			parent.addRendererTabs()
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
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			_renderersList = #()

			--obtiene los renderers instalados
			for i=1 to RendererClass.classes.count
			where (not (matchPattern (RendererClass.classes[i] As string) pattern:"Missing*")) and (not (matchPattern (RendererClass.classes[i] As String) pattern:"VUE*")) do
				append _renderersList (RendererClass.classes[i] As String)

			ddlRenderers.items = _renderersList --los añade al listado

			--selecciona el que sea el actual del override
			for i=1 to _renderersList.count where _renderersList[i] == editCA.currentRenderer do ddlRenderers.selection = i

			resetRendererSpecificUI() --configura los tabs y los subrollouts
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
			_heightBckp = rollMainDef.height --hace backup del tamaño actual de la ventana
			_posBckp = getDialogPos rollMainDef --hace backup de la posicion del rollout

			--tamaño
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
			--establece minimos
			if _height < minRollHeight then _height = minRollHeight

			--si el tamaño varía en altura, hay que ajustar la posicion vertical del rollout para centrarlo en la herramienta dede la que se ha abierto
			_increment = _height - _heightBckp
			if _increment != 0 then _posBckp.y = _posBckp.y - (_increment/2.0)
			if _posBckp.y < 0 then _posBckp.y = 0

			--aplica los valores
			rollMainDef.height = _height
			setDialogPos rollMainDef _posBckp

			parent.selectedTabIndex = (lb.xml.getAttribute parent.cfgFile "rollMain/options" "selectedTabIndex") as integer
			if parent.selectedTabIndex < 1 then parent.selectedTabIndex = 1
		)
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--stores size
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "selectedTabIndex" (parent.selectedTabIndex as string)
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | ddlRenderers | Dropdown de motores de render.
		--@gets: integer | index | Indice del elemento del listado seleccionado.
		------------------------------------------------
		on ddlRenderers selected index do
		(
			--Guardar el motor seleccionado
			editCA.currentRenderer = ddlRenderers.items[index]
			resetRendererSpecificUI() --configura los tabs y los subrollouts si el renderer ha cambiado
		)

		------------------------------------------------
		--@event: selectedPageChanged | Evento que se lanza al cambiar de tab.
		--@control: DevExpress.XtraTab.XtraTabControl | tbSettingsCategories | Tabs de categorias de motores de render.
		--@gets: event | events | Objeto devuelto por el evento.
		------------------------------------------------
		on tbSettingsCategories selectedPageChanged events do
		(
			if not opening then
			(
				parent.selectedTabIndex = tbSettingsCategories.selectedTabPageIndex + 1
				if parent.selectedTabIndex < 1 then parent.selectedTabIndex = 1
				parent.addTabRollouts()
			)--if
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			parent.removeAllTabRollouts() --primero se eliminan los subrollouts 

			parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
			
			DestroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Cancela los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnCancel pressed do
		(
			DestroyDialog parent.rollMain
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
			------------------------------------------------------------------------------
			--si el tamaño es menor que el minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento de tamaño
			_increment = [size.x - minRollWidth, size.y - minRollHeight]

			------------------------------------------------------------------------------
			--redimension en horizonal
			
			------------------------------------------------------------------------------

			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				--zona de subRollouts
				subRollContainer1.height = 514 + _increment.y

				--botones de abajo
				btnOk.pos.y = 575 + _increment.y
				btnCancel.pos.y = 575 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			opening = true --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg

			parent = lb.passManager.getCurrentEditInstance()
			
			editCA = parent.editBackupNode.custAttributes[#overrideRendererSettingsInfo]
			initUI() --inicializa el UI
			loadSettings()
			loadOverrideInfo()
			createSceneEvents()			

			opening = false --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(				
			removeSceneEvents()
			onCloseOperations()
			saveSettings()			
		)	
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: override | Contiene todas las funciones de un override de Material.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideRendererSettings
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = (getFileNamePath (getThisScriptFilename() as string)) + "pmov_rendererSettings.ms",	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		cfgFile = (lb.config.getToolsIniPath()) + "overrideRendererSettings.cfg",	--@var: cfgFile | Archivo de configuracion del override.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		type = "override",		--@var | type | Indica que es un override.
		subType = lb.overrides.getFileOverrideName (getThisScriptFilename() as string),	--@var | subType | Indica que tipo de override concreto almacena.
		relatedTypes = #(), --#("mentalFinalGather", "mentalGlobalTuningParams", "mentalRenderingAlgorithms", "mentalReuseFG", "mentalSamplingQuality","scanlineAntialiasing"), --@var | relatedTypes | Tipos de overrides relacionados.
		
		stateMessage = "", --@var | stateMessage | Mensaje del estado actual del override.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,						--@var | infoNodeCA | Variable de atajo para el CA de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideRendererSettingsInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideRendererSettingsInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
		tabForeColor = (dotnetclass "system.drawing.color").fromArgb 189 189 189,
		tabBorderColor = (dotnetclass "system.drawing.color").fromArgb 30 30 30,
		tabBackColor = (dotnetclass "system.drawing.color").fromArgb 60 60 60,
		tabBackColorActive = (dotnetclass "system.drawing.color").fromArgb 90 90 90,
		tabBackColor2 = (dotnetclass "system.drawing.color").fromArgb 55 55 55,
		tabBackColorActive2 = (dotnetclass "system.drawing.color").fromArgb 60 60 60,
		tabBackColorOverrided = (dotnetclass "system.drawing.color").fromArgb 85 246 22,
		tabForeColorOverridedActive = (dotnetclass "system.drawing.color").fromArgb 85 246 22,

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		--rollExample1 = rollExampleDef1,	--@var: rollExample1 | Example rollout.
		rollScanlineGeneralParams = rollScanlineGeneralParamsDef, --@var: rollScanlineGeneralParams | Rollout de parametros generales de scanline.
		rollMentalSamplingQuality = rollMentalSamplingQualityDef, --@var: rollMentalSamplingQuality | Rollout de sampling quality de mental ray.
		rollMentalRenderingAlgorithms = rollMentalRenderingAlgorithmsDef, --@var: rollMentalRenderingAlgorithms | Rollout de algoritmos de render de mental ray.
		rollMentalCameraEffects = rollMentalCameraEffectsDef, --@var: rollMentalCameraEffects | Rollout de efectos de camara de mental ray.
		rollMentalShadowsAndDisplacement = rollMentalShadowsAndDisplacementDef, --@var: rollMentalShadowsAndDisplacement | Rollout de sompbras y desplazamiento de mental ray.
		rollMentalGlobalTuningParams = rollMentalGlobalTuningParamsDef, --@var: rollMentalGlobalTuningParamsDef | Rollout de global tuning params de mental ray.
		rollMentalIBL = rollMentalIBLDef, --@var: rollMentalIBL | Rollout de IBL de mental ray.
		rollMentalFinalGather = rollMentalFinalGatherDef, --@var: rollMentalFinalGather | Rollout de FInal Gather de mental ray.
		rollMentalCaustics = rollMentalCausticsDef, --@var: rollMentalCaustics | Rollout de Casuticas de mental ray.
		rollMentalReuseFG = rollMentalReuseFGDef, --@var: rollMentalReuseFG | Rollout de mapas de calculo de final gather.
		rollMentalTranslatorOptions = rollMentalTranslatorOptionsDef, --@var: rollMentalTranslatorOptions | Rollout de translator options de mental ray.

		rollMain = rollMainDef,	--@var: rollMain | Main tool rollout.
		
		subRolloutsContainer = this.rollMain.subRollContainer1, --@var: subRolloutsContainer | contenedor de subrollouts.
		
		--titulos de los tabs de cada motor de render
		scanlineTabNames = #("Renderer", "Raytracer", "Advanced Lighting"), --@var: mentalrayTabNames | Tabs de scanline.
		mentalrayTabNames = #("Renderer", "Global Illumination", "Processing"), --@var: scanlineTabNames | Tabs de mental ray.
		quicksilverTabNames = #("Renderer"), --@var: quicksilverTabNames | Tabs de quicksilver.
		irayTabNames = #("Renderer"), --@var: irayTabNames | Tabs de iray.

		--rollouts de cada tab de cada motor de render
		scanlineRollouts = #(#(rollScanlineGeneralParams), #(), #()), --@var: mentalrayTabNames | Rollots de cada tab de scanline.
		mentalrayRollouts = #(#(rollMentalSamplingQuality, rollMentalRenderingAlgorithms, rollMentalCameraEffects, rollMentalShadowsAndDisplacement, rollMentalGlobalTuningParams), #(rollMentalIBL, rollMentalFinalGather, rollMentalCaustics, rollMentalReuseFG), #(rollMentalTranslatorOptions)), --@var: scanlineTabNames | Rollots de cada tab de mental ray.
		quicksilverRollouts = #(#()), --@var: quicksilverTabNames | Rollots de cada tab de quicksilver.
		irayRollouts = #(#()), --@var: irayTabNames | Rollots de cada tab de iray.

		--estado de desplegado o plegado de cada rollout de cada tab
		scanlineRolloutsRolledUp = #(#(false), #(), #()), --@var: mentalrayTabNames | Estado de desplegado/plegado de cada rollout de cada tab de scanline.
		mentalrayRolloutsRolledUp = #(#(true, true, true, true, true), #(true, true, true, true), #(false)), --@var: scanlineTabNames | Estado de desplegado/plegado de cada rollout de cada tab de mental ray.
		quicksilverRolloutsRolledUp = #(#()), --@var: quicksilverTabNames | Estado de desplegado/plegado de cada rollout de cada tab de quicksilver.
		irayRolloutsRolledUp = #(#()), --@var: irayTabNames | Estado de desplegado/plegado de cada rollout de cada tab de iray.

		selectedTabIndex = 1, --@var: selectedTabIndex | Estado de desplegado/plegado de cada rollout de cada tab de iray.

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
			(this.infoNodeCA.currentRenderer As String)
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok
			
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
		--@fn: undefined | redirect | Realiza redireccion de sources en el override.
		--@gets: string | sourcePattern | Parte del path que sustituir.
		--@gets: string | mappedPattern | Parte del path por la cual sustituir.
		------------------------------------------------
		fn redirect sourcePattern mappedPattern =
		(
			_path = substituteString (toLower (getFilenamePath this.infoNodeCA.FinalGatherFilename)) (toLower sourcePattern) (toLower mappedPattern)
			this.infoNodeCA.FinalGatherFilename = _path + (getFilenameFile this.infoNodeCA.FinalGatherFilename) + (getFilenameType this.infoNodeCA.FinalGatherFilename)
			
			_path = substituteString (toLower (getFilenamePath this.infoNodeCA.PhotonMapFilename)) (toLower sourcePattern) (toLower mappedPattern)
			this.infoNodeCA.PhotonMapFilename = _path + (getFilenameFile this.infoNodeCA.PhotonMapFilename) + (getFilenameType this.infoNodeCA.FinalGatherFilename)
		),

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

			if saveLogs then lb.log.add ("BACKUP process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				_backupCA = backupNode.custAttributes[#overrideRendererSettingsInfo]

				--si el nodo de backup no tiene el CA de backup se lo pone
				if _backupCA == undefined then
				(
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
					_backupCA = backupNode.custAttributes[#overrideRendererSettingsInfo]
				)
				
				------------------------------------------------
				--GENERAL

				_backupCA.currentRenderer = ((classof renderers.current) As String) --establece el motor de render
				------------------------------------------------

				------------------------------------------------
				--SCANLINE

				if (classof renderers.current) == Default_Scanline_Renderer then
				(
					------------------------------------------------
					--SCANLINE GENERAL PARAMS

					if (this.infoNodeCA.overrideScanlineGeneralParams) then
					(
						_backupCA.antiAliasing = renderers.current.antiAliasing
						_backupCA.antiAliasFilter = renderers.current.antiAliasFilter
						_backupCA.filterMaps = renderers.current.filterMaps
						_backupCA.antiAliasFilterSize = renderers.current.antiAliasFilterSize
					)--if

					--SCANLINE GENERAL PARAMS END
					------------------------------------------------
				)
				
				--SCANLINE END
				------------------------------------------------

				------------------------------------------------
				--MENTAL RAY

				if (classof renderers.current) == mental_ray_renderer then
				(
					if saveLogs then lb.log.add ("Backup: Mental ray parameters") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)

					------------------------------------------------
					--MENTAL SAMPLING QUALITY

					if (this.infoNodeCA.overrideMentalSamplingQuality) then
					(
						if saveLogs then lb.log.add ("Backup: Mental Sampling Quality") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 2)

						--Samplig mode
						if (maxVersion())[1] >= 16000 then
						(
							_backupCA.UnifiedEnable = renderers.current.UnifiedEnable
							_backupCA.UnifiedQuality = renderers.current.UnifiedQuality
							_backupCA.UnifiedMinSamples = renderers.current.UnifiedMinSamples
							_backupCA.UnifiedMaxSamples = renderers.current.UnifiedMaxSamples
							
							_backupCA.ScanlineEnable = renderers.current.ScanlineEnable
							_backupCA.RapidShadingSamples = renderers.current.RapidShadingSamples
							_backupCA.RapidCollectRate = renderers.current.RapidCollectRate
						)
						
						--Samples
						_backupCA.MinimumSamples = renderers.current.MinimumSamples
						_backupCA.MaximumSamples = renderers.current.MaximumSamples
						
						--Filters
						_backupCA.FilterType = renderers.current.Filter
						case this.rollMentalSamplingQuality.filtersArray[renderers.current.Filter + 1] of
						(
							"Box":
							(
								_backupCA.BoxFilterWidth  = renderers.current.BoxFilterWidth
								_backupCA.BoxFilterHeight  = renderers.current.BoxFilterHeight						
							)
							
							"Gauss":
							(
								_backupCA.GaussFilterWidth  = renderers.current.GaussFilterWidth
								_backupCA.GaussFilterHeight  = renderers.current.GaussFilterHeight
							)
							
							"Triangle":
							(
								_backupCA.TriangleFilterWidth  = renderers.current.TriangleFilterWidth
								_backupCA.TriangleFilterHeight  = renderers.current.TriangleFilterHeight
							)
							
							"Mitchell":
							(
								_backupCA.MitchellFilterWidth  = renderers.current.MitchellFilterWidth
								_backupCA.MitchellFilterHeight  = renderers.current.MitchellFilterHeight
							)
							
							"Lanczos":
							(
								_backupCA.LanczosFilterWidth  = renderers.current.LanczosFilterWidth
								_backupCA.LanczosFilterHeight  = renderers.current.LanczosFilterHeight
							)
						)
						
						--Spatial Contest
						_backupCA.RedSpatialContrast = renderers.current.RedSpatialContrast
						_backupCA.GreenSpatialContrast = renderers.current.GreenSpatialContrast
						_backupCA.BlueSpatialContrast = renderers.current.BlueSpatialContrast
						_backupCA.AlphaSpatialContrast = renderers.current.AlphaSpatialContrast
							
						--Options
						_backupCA.LockSamples = renderers.current.LockSamples
						_backupCA.Jitter = renderers.current.Jitter
						_backupCA.TaskSize = renderers.current.TaskSize
						_backupCA.TaskOrder = renderers.current.TaskOrder
						_backupCA.FrameBufferType = renderers.current.FrameBufferType

						if saveLogs then lb.log.add ("Backup End: Mental Sampling Quality") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 2)
					)--if

					--MENTAL SAMPLING QUALITY END
					------------------------------------------------

					------------------------------------------------
					--MENTAL RENDERING ALGORITHMS

					if (this.infoNodeCA.overrideMentalRenderingAlgorithms) then
					(
						_backupCA.ScanlineEnable = renderers.current.scanlineEnable
						_backupCA.ScanlineMethod = renderers.current.ScanlineMethod
						_backupCA.RapidCollectRate = renderers.current.RapidCollectRate
						_backupCA.RapidShadingSamples = renderers.current.RapidShadingSamples
						
						_backupCA.RaytraceEnable = renderers.current.RaytraceEnable
						_backupCA.Autovolume = renderers.current.Autovolume
						_backupCA.RaytraceMethod = renderers.current.RaytraceMethod
						_backupCA.BSPSize = renderers.current.BSPSize
						_backupCA.BSPDepth = renderers.current.BSPDepth
						
						_backupCA.ReflectionsEnable = renderers.current.ReflectionsEnable
						_backupCA.RefractionsEnable = renderers.current.RefractionsEnable
						_backupCA.MaximumTraceDepth = renderers.current.MaximumTraceDepth
						_backupCA.MaximumReflections = renderers.current.MaximumReflections
						_backupCA.MaximumRefractions = renderers.current.MaximumRefractions
						
						_backupCA.enable_subset_pixel_rendering = renderers.current.enable_subset_pixel_rendering
						
						_backupCA.ShadowMethod = renderers.current.ShadowMethod
					)--if

					--MENTAL RENDERING ALGORITHMS END
					------------------------------------------------

					------------------------------------------------
					--MENTAL CAMERA EFFECTS
					if (this.infoNodeCA.overrideMentalCameraEffects) then
					(

						_backupCA.MotionBlurEnable = renderers.current.MotionBlurEnable
						_backupCA.MotionBlurAllObjects = renderers.current.MotionBlurAllObjects
						_backupCA.Shutter = renderers.current.Shutter
						_backupCA.MotionBlurOffset = renderers.current.MotionBlurOffset
						_backupCA.Segments = renderers.current.Segments
						_backupCA.TimeSamples = renderers.current.TimeSamples
						_backupCA.RapidMotionResample = renderers.current.RapidMotionResample

						_backupCA.EnableContours = renderers.current.EnableContours
						_backupCA.Contour_Contrast_Shader = renderers.current.Contour_Contrast_Shader
						_backupCA.Contour_Output_Shader = renderers.current.Contour_Output_Shader
						_backupCA.Contour_Store_Shader = renderers.current.Contour_Store_Shader

						_backupCA.Enable_Camera_Lens_Shader = renderers.current.Enable_Camera_Lens_Shader
						_backupCA.Camera_Lens_Shader = renderers.current.Camera_Lens_Shader
						_backupCA.Enable_Camera_Output_Shader = renderers.current.Enable_Camera_Output_Shader
						_backupCA.Camera_Output_Shader = renderers.current.Camera_Output_Shader
						_backupCA.Enable_Camera_Volume_Shader = renderers.current.Enable_Camera_Volume_Shader
						_backupCA.Camera_Volume_Shader = renderers.current.Camera_Volume_Shader

						_backupCA.DepthOfFieldEnable = renderers.current.DepthOfFieldEnable
						_backupCA.DepthOfFieldMode = renderers.current.DepthOfFieldMode
						_backupCA.FocusPlane = renderers.current.FocusPlane
						_backupCA.fStop = renderers.current.fStop
						_backupCA.NearFocus = renderers.current.NearFocus
						_backupCA.FarFocus = renderers.current.FarFocus
					)

					--MENTAL CAMERA EFFECTS END
					------------------------------------------------

					------------------------------------------------
					--MENTAL SHADOWS AND DISPLACEMENT
					
					if (this.infoNodeCA.overrideMentalShadowsAndDisplacement) then
					(
						_backupCA.ShadowsEnable = renderers.current.ShadowsEnable
						_backupCA.ShadowMethod = renderers.current.ShadowMethod

						_backupCA.EnableShadowMaps = renderers.current.EnableShadowMaps
						_backupCA.MotionBlurShadowMapsEnable = renderers.current.MotionBlurShadowMapsEnable
						_backupCA.ShadowMapRebuild = renderers.current.ShadowMapRebuild
						_backupCA.UseShadowMapFile = renderers.current.UseShadowMapFile
						_backupCA.ShadowMapFilename = renderers.current.ShadowMapFilename

						_backupCA.view = renderers.current.view
						_backupCA.Smooth = renderers.current.Smooth
						_backupCA.Edge_Length	= renderers.current.Edge_Length
						_backupCA.Max_Displace = renderers.current.Max_Displace
						_backupCA.Max_Level = renderers.current.Max_Level
					)

					--MENTAL SHADOWS AND DISPLACEMENT END
					------------------------------------------------

					------------------------------------------------
					--MENTAL GLOBAL TUNING PARAMS

					if (this.infoNodeCA.overrideMentalGlobalTuningParams) then
					(
						_backupCA.softShadowsPrecision = renderers.current.softShadowsPrecision
						_backupCA.glossyReflectionsPrecision = renderers.current.glossyReflectionsPrecision
						_backupCA.glossyRefractionsPrecision = renderers.current.glossyRefractionsPrecision
					)--if

					--MENTAL GLOBAL TUNING PARAMS END
					------------------------------------------------

					------------------------------------------------
					--MENTAL IBL

					if (this.infoNodeCA.overrideMentalIBL) then
					(						
						_backupCA.IBLEnable = renderers.current.IBLEnable
						_backupCA.IBLQuality = renderers.current.IBLQuality
						_backupCA.IBLShadows = renderers.current.IBLShadows
					)--if

					--MENTAL IBL END
					------------------------------------------------

					------------------------------------------------
					--MENTAL FINAL GATHER

					if (this.infoNodeCA.overrideMentalFinalGather) then
					(
						_backupCA.FinalGatherEnable2 = renderers.current.FinalGatherEnable2
						_backupCA.FGMultiplierScalar = renderers.current.FGMultiplierScalar
						_backupCA.FGMultiplierColor = renderers.current.FGMultiplierColor
						
						_backupCA.FGProjectionMode = renderers.current.FGProjectionMode
						_backupCA.FGProjectionModeNumSegments = renderers.current.FGProjectionModeNumSegments
						_backupCA.FinalGatherDensity = renderers.current.FinalGatherDensity
						_backupCA.FinalGatherAccuracy = renderers.current.FinalGatherAccuracy
						_backupCA.FinalGatherInterpolationSamples = renderers.current.FinalGatherInterpolationSamples
						_backupCA.FinalGatherBounces = renderers.current.FinalGatherBounces
						_backupCA.FinalGatherBounceMultiplier = renderers.current.FinalGatherBounceMultiplier
						
						_backupCA.FinalGatherFilter = renderers.current.FinalGatherFilter
						_backupCA.FinalGatherPreview = renderers.current.FinalGatherPreview
						
						_backupCA.FinalGatherTraceDepth = renderers.current.FinalGatherTraceDepth
						_backupCA.FinalGatherReflectionDepth = renderers.current.FinalGatherReflectionDepth
						_backupCA.FinalGatherRefractionDepth = renderers.current.FinalGatherRefractionDepth
						_backupCA.FinalGatherFalloff = renderers.current.FinalGatherFalloff
						_backupCA.FinalGatherFalloffStart = renderers.current.FinalGatherFalloffStart
						_backupCA.FinalGatherFalloffStop = renderers.current.FinalGatherFalloffStop
						
						_backupCA.FinalGatherUseRadiusInterpolation = renderers.current.FinalGatherUseRadiusInterpolation
						_backupCA.FinalGatherView = renderers.current.FinalGatherView
						_backupCA.UseFinalGatherRadius = renderers.current.UseFinalGatherRadius
						_backupCA.UseFinalGatherMinRadius = renderers.current.UseFinalGatherMinRadius
						_backupCA.FinalGatherRadius = renderers.current.FinalGatherRadius
						_backupCA.FinalGatherMinRadius = renderers.current.FinalGatherMinRadius
						_backupCA.FinalGatherRadius_View = renderers.current.FinalGatherRadius_View
						_backupCA.FinalGatherMinRadius_View = renderers.current.FinalGatherMinRadius_View
					)--if
						
					--MENTAL FINAL GATHER END
					------------------------------------------------

					-----------------------------------------------
					--MENTAL CAUSTICS

					if (this.infoNodeCA.overrideMentalCaustics) then
					(
						_backupCA.CausticsEnable = renderers.current.CausticsEnable
						_backupCA.CausticMultiplierScalar = renderers.current.CausticMultiplierScalar
						_backupCA.CausticMultiplierColor = renderers.current.CausticMultiplierColor
						_backupCA.CausticAccuracy = renderers.current.CausticAccuracy
						_backupCA.UseCausticRadius = renderers.current.UseCausticRadius
						_backupCA.CausticRadius = renderers.current.CausticRadius
						_backupCA.CausticsFilter = renderers.current.CausticsFilter
						_backupCA.Kernel = renderers.current.Kernel
						_backupCA.CausticOpaqueShadows = renderers.current.CausticOpaqueShadows
						
						_backupCA.GlobalIllumEnable = renderers.current.GlobalIllumEnable
						_backupCA.GIMultiplierScalar = renderers.current.GIMultiplierScalar
						_backupCA.GIMultiplierColor = renderers.current.GIMultiplierColor
						_backupCA.GlobalIllumAccuracy = renderers.current.GlobalIllumAccuracy
						_backupCA.UseGlobalIllumRadius = renderers.current.UseGlobalIllumRadius
						_backupCA.GlobalIllumRadius = renderers.current.GlobalIllumRadius
						_backupCA.GIPhotonMergeDistance = renderers.current.GIPhotonMergeDistance

						_backupCA.VolumeAccuracy = renderers.current.VolumeAccuracy
						_backupCA.UseVolumeRadius = renderers.current.UseVolumeRadius
						_backupCA.VolumeRadius = renderers.current.VolumeRadius

						_backupCA.GIMaximumTraceDepth = renderers.current.GIMaximumTraceDepth
						_backupCA.GIMaximumReflections = renderers.current.GIMaximumReflections
						_backupCA.GIMaximumRefractions = renderers.current.GIMaximumRefractions

						_backupCA.GlobalLightCausticPhotons = renderers.current.GlobalLightCausticPhotons
						_backupCA.GlobalLightGIPhotons = renderers.current.GlobalLightGIPhotons
						_backupCA.GlobalLightDecay = renderers.current.GlobalLightDecay

						_backupCA.OverrideIIObjProps = renderers.current.OverrideIIObjProps
					)--if

					--MENTAL CAUSTICS END
					-----------------------------------------------

					------------------------------------------------
					--MENTAL REUSE FINAL GATHER

					if (this.infoNodeCA.overrideMentalReuseFG) then
					(
						_backupCA.IlluminationCacheMode = renderers.current.IlluminationCacheMode
						_backupCA.SkipFinalRender = renderers.current.SkipFinalRender
						
						_backupCA.UseFinalGatherFile = renderers.current.UseFinalGatherFile
						_backupCA.FinalGatherFreeze = renderers.current.FinalGatherFreeze
						_backupCA.FGInterpolateNFrames = renderers.current.FGInterpolateNFrames
						_backupCA.FinalGatherFilename = renderers.current.FinalGatherFilename
						_backupCA.FinalGatherTempFilename = renderers.current.FinalGatherTempFilename
							
						_backupCA.PhotonMapUseFile = renderers.current.PhotonMapUseFile
						_backupCA.PhotonFreeze = renderers.current.PhotonFreeze
						_backupCA.PhotonMapFilename = renderers.current.PhotonMapFilename
						_backupCA.FinalGatherOnly = renderers.current.FinalGatherOnly
						_backupCA.PhotonsOnly = renderers.current.PhotonsOnly
					)--if
						
					--MENTAL REUSE FINAL GATHER END
					------------------------------------------------

					------------------------------------------------
					--MENTAL TRANSLATOR OPTIONS

					if (this.infoNodeCA.overrideMentalTranslatorOptions) then
					(
						_backupCA.Use_Placeholders = renderers.current.Use_Placeholders
						_backupCA.Conserve_Memory = renderers.current.Conserve_Memory
						_backupCA.mental_ray_Manages_Maps = renderers.current.mental_ray_Manages_Maps

						_backupCA.EnableGeometryCache = renderers.current.EnableGeometryCache
						_backupCA.LockGeometryCache = renderers.current.LockGeometryCache

						_backupCA.Enable_Material_Override = renderers.current.Enable_Material_Override
						_backupCA.Override_Material = renderers.current.Override_Material

						_backupCA.Skip_Texture_Maps = renderers.current.Skip_Texture_Maps
					)--if

					--MENTAL TRANSLATOR OPTIONS END
					------------------------------------------------			

					if saveLogs then lb.log.add ("Backup End: Mental ray parameters") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)
				)--if

				--MENTAL RAY END
				------------------------------------------------

				--Proceso completado
				if saveLogs then lb.log.add ("BACKUP process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				_success = true
			)--if
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup Node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				_success = false
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

			if saveLogs then lb.log.add ("RESTORE process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(
				_backupCA = backupNode.custAttributes[#overrideRendererSettingsInfo]

				if _backupCA != undefined then
				(
					------------------------------------------------
					--GENERAL

					--restaura el motor de render
					if (classof renderers.current) as string != _backupCA.currentRenderer then renderers.current = execute (_backupCA.currentRenderer + "()")
					------------------------------------------------

					------------------------------------------------
					--SCANLINE

					if (classof renderers.current) == Default_Scanline_Renderer then
					(
						------------------------------------------------
						--SCANLINE GENERAL PARAMS

						if (this.infoNodeCA.overrideScanlineGeneralParams) then
						(
							renderers.current.antiAliasing = _backupCA.antiAliasing
							renderers.current.antiAliasFilter = _backupCA.antiAliasFilter
							renderers.current.filterMaps = _backupCA.filterMaps
							renderers.current.antiAliasFilterSize = _backupCA.antiAliasFilterSize
						)--if

						--SCANLINE GENERAL PARAMS END
						------------------------------------------------
					)
					
					--SCANLINE END
					------------------------------------------------

					------------------------------------------------
					--MENTAL RAY

					if (classof renderers.current) == mental_ray_renderer then
					(
						if saveLogs then lb.log.add ("Restore: Mental ray parameters") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)

						------------------------------------------------
						--MENTAL SAMPLING QUALITY

						if (this.infoNodeCA.overrideMentalSamplingQuality) then
						(
							if saveLogs then lb.log.add ("Restore: Mental Sampling Quality") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 2)

							--Samplig mode
							if (maxVersion())[1] >= 16000 then
							(
								renderers.current.UnifiedEnable = _backupCA.UnifiedEnable
								renderers.current.UnifiedQuality = _backupCA.UnifiedQuality
								renderers.current.UnifiedMinSamples = _backupCA.UnifiedMinSamples
								renderers.current.UnifiedMaxSamples = _backupCA.UnifiedMaxSamples
								
								renderers.current.ScanlineEnable = _backupCA.ScanlineEnable
								renderers.current.RapidShadingSamples = _backupCA.RapidShadingSamples
								renderers.current.RapidCollectRate = _backupCA.RapidCollectRate
							)--if
							
							--Samples
							renderers.current.MinimumSamples = _backupCA.MinimumSamples
							renderers.current.MaximumSamples = _backupCA.MaximumSamples
							
							--Filters
							renderers.current.Filter = _backupCA.FilterType
							case this.rollMentalSamplingQuality.filtersArray[renderers.current.Filter + 1] of
							(
								"Box":
								(
									renderers.current.BoxFilterWidth = _backupCA.BoxFilterWidth  
									renderers.current.BoxFilterHeight = _backupCA.BoxFilterHeight 						
								)
								
								"Gauss":
								(
									renderers.current.GaussFilterWidth = _backupCA.GaussFilterWidth  
									renderers.current.GaussFilterHeight = _backupCA.GaussFilterHeight 
								)
								
								"Triangle":
								(
									renderers.current.TriangleFilterWidth = _backupCA.TriangleFilterWidth
									renderers.current.TriangleFilterHeight = _backupCA.TriangleFilterHeight
								)
								
								"Mitchell":
								(
									renderers.current.MitchellFilterWidth = _backupCA.MitchellFilterWidth
									renderers.current.MitchellFilterHeight = _backupCA.MitchellFilterHeight
								)
								
								"Lanczos":
								(
									renderers.current.LanczosFilterWidth = _backupCA.LanczosFilterWidth
									renderers.current.LanczosFilterHeight = _backupCA.LanczosFilterHeight
								)
							)
							
							--Spatial Contest
							renderers.current.RedSpatialContrast = _backupCA.RedSpatialContrast
							renderers.current.GreenSpatialContrast = _backupCA.GreenSpatialContrast
							renderers.current.BlueSpatialContrast = _backupCA.BlueSpatialContrast
							renderers.current.AlphaSpatialContrast = _backupCA.AlphaSpatialContrast
								
							--Options
							renderers.current.LockSamples  = _backupCA.LockSamples
							renderers.current.Jitter = _backupCA.Jitter
							renderers.current.TaskSize  = _backupCA.TaskSize
							renderers.current.TaskOrder = _backupCA.TaskOrder
							renderers.current.FrameBufferType  = _backupCA.FrameBufferType

							if saveLogs then lb.log.add ("Restore End: Mental Sampling Quality") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 2)
						)

						--MENTAL SAMPLING QUALITY END
						------------------------------------------------

						------------------------------------------------
						--MENTAL RENDERING ALGORITHMS

						if (this.infoNodeCA.overrideMentalRenderingAlgorithms) then
						(
							renderers.current.ScanlineEnable = _backupCA.ScanlineEnable
							renderers.current.ScanlineMethod = _backupCA.ScanlineMethod
							renderers.current.RapidCollectRate = _backupCA.RapidCollectRate
							renderers.current.RapidShadingSamples = _backupCA.RapidShadingSamples
							
							renderers.current.RaytraceEnable = _backupCA.RaytraceEnable
							renderers.current.Autovolume = _backupCA.Autovolume
							renderers.current.RaytraceMethod = _backupCA.RaytraceMethod
							renderers.current.BSPSize = _backupCA.BSPSize
							renderers.current.BSPDepth = _backupCA.BSPDepth
							
							renderers.current.ReflectionsEnable = _backupCA.ReflectionsEnable
							renderers.current.RefractionsEnable = _backupCA.RefractionsEnable
							renderers.current.MaximumTraceDepth = _backupCA.MaximumTraceDepth
							renderers.current.MaximumReflections = _backupCA.MaximumReflections
							renderers.current.MaximumRefractions = _backupCA.MaximumRefractions
							
							renderers.current.enable_subset_pixel_rendering = _backupCA.enable_subset_pixel_rendering
							
							renderers.current.ShadowMethod = _backupCA.ShadowMethod
						)--if
						
						--MENTAL RENDERING ALGORITHMS END
						------------------------------------------------

						------------------------------------------------
						--MENTAL CAMERA EFFECTS
						if (this.infoNodeCA.overrideMentalCameraEffects) then
						(

							renderers.current.MotionBlurEnable = _backupCA.MotionBlurEnable
							renderers.current.MotionBlurAllObjects = _backupCA.MotionBlurAllObjects
							renderers.current.Shutter = _backupCA.Shutter
							renderers.current.MotionBlurOffset = _backupCA.MotionBlurOffset
							renderers.current.Segments = _backupCA.Segments
							renderers.current.TimeSamples = _backupCA.TimeSamples
							renderers.current.RapidMotionResample = _backupCA.RapidMotionResample

							renderers.current.EnableContours = _backupCA.EnableContours
							renderers.current.Contour_Contrast_Shader = _backupCA.Contour_Contrast_Shader
							renderers.current.Contour_Output_Shader = _backupCA.Contour_Output_Shader
							renderers.current.Contour_Store_Shader = _backupCA.Contour_Store_Shader

							renderers.current.Enable_Camera_Lens_Shader = _backupCA.Enable_Camera_Lens_Shader
							renderers.current.Camera_Lens_Shader = _backupCA.Camera_Lens_Shader
							renderers.current.Enable_Camera_Output_Shader = _backupCA.Enable_Camera_Output_Shader
							renderers.current.Camera_Output_Shader = _backupCA.Camera_Output_Shader
							renderers.current.Enable_Camera_Volume_Shader = _backupCA.Enable_Camera_Volume_Shader
							renderers.current.Camera_Volume_Shader = _backupCA.Camera_Volume_Shader

							renderers.current.DepthOfFieldEnable = _backupCA.DepthOfFieldEnable
							renderers.current.DepthOfFieldMode = _backupCA.DepthOfFieldMode
							renderers.current.FocusPlane = _backupCA.FocusPlane
							renderers.current.fStop = _backupCA.fStop
							renderers.current.NearFocus = _backupCA.NearFocus
							renderers.current.FarFocus = _backupCA.FarFocus
						)

						--MENTAL CAMERA EFFECTS END
						------------------------------------------------
						
						------------------------------------------------
						--MENTAL SHADOWS AND DISPLACEMENT
						
						if (this.infoNodeCA.overrideMentalShadowsAndDisplacement) then
						(
							renderers.current.ShadowsEnable = _backupCA.ShadowsEnable
							renderers.current.ShadowMethod = _backupCA.ShadowMethod

							renderers.current.EnableShadowMaps = _backupCA.EnableShadowMaps
							renderers.current.MotionBlurShadowMapsEnable = _backupCA.MotionBlurShadowMapsEnable
							renderers.current.ShadowMapRebuild = _backupCA.ShadowMapRebuild
							renderers.current.UseShadowMapFile = _backupCA.UseShadowMapFile
							renderers.current.ShadowMapFilename = _backupCA.ShadowMapFilename

							renderers.current.view = _backupCA.view
							renderers.current.Smooth = _backupCA.Smooth
							renderers.current.Edge_Length = _backupCA.Edge_Length
							renderers.current.Max_Displace = _backupCA.Max_Displace
							renderers.current.Max_Level = _backupCA.Max_Level
						)

						--MENTAL SHADOWS AND DISPLACEMENT END
						------------------------------------------------

						------------------------------------------------
						--MENTAL GLOBAL TUNING PARAMS

						if (this.infoNodeCA.overrideMentalGlobalTuningParams) then
						(
							renderers.current.softShadowsPrecision = _backupCA.softShadowsPrecision
							renderers.current.glossyReflectionsPrecision = _backupCA.glossyReflectionsPrecision
							renderers.current.glossyRefractionsPrecision = _backupCA.glossyRefractionsPrecision
						)--if

						--MENTAL GLOBAL TUNING PARAMS END
						------------------------------------------------

						------------------------------------------------
						--MENTAL IBL

						if (this.infoNodeCA.overrideMentalIBL) then
						(
							renderers.current.IBLEnable = _backupCA.IBLEnable
							renderers.current.IBLQuality = _backupCA.IBLQuality
							renderers.current.IBLShadows = _backupCA.IBLShadows
						)--if

						--MENTAL IBL END
						------------------------------------------------						

						------------------------------------------------
						--MENTAL FINAL GATHER

						if (this.infoNodeCA.overrideMentalFinalGather) then
						(
							renderers.current.FinalGatherEnable2 = _backupCA.FinalGatherEnable2
							renderers.current.FGMultiplierScalar = _backupCA.FGMultiplierScalar
							renderers.current.FGMultiplierColor = _backupCA.FGMultiplierColor
							
							renderers.current.FGProjectionMode = _backupCA.FGProjectionMode
							renderers.current.FGProjectionModeNumSegments = _backupCA.FGProjectionModeNumSegments
							renderers.current.FinalGatherDensity = _backupCA.FinalGatherDensity
							renderers.current.FinalGatherAccuracy = _backupCA.FinalGatherAccuracy
							renderers.current.FinalGatherInterpolationSamples = _backupCA.FinalGatherInterpolationSamples
							renderers.current.FinalGatherBounces = _backupCA.FinalGatherBounces
							renderers.current.FinalGatherBounceMultiplier = _backupCA.FinalGatherBounceMultiplier
							
							renderers.current.FinalGatherFilter = _backupCA.FinalGatherFilter
							renderers.current.FinalGatherPreview = _backupCA.FinalGatherPreview
							
							renderers.current.FinalGatherTraceDepth = _backupCA.FinalGatherTraceDepth
							renderers.current.FinalGatherReflectionDepth = _backupCA.FinalGatherReflectionDepth
							renderers.current.FinalGatherRefractionDepth = _backupCA.FinalGatherRefractionDepth
							renderers.current.FinalGatherFalloff = _backupCA.FinalGatherFalloff
							renderers.current.FinalGatherFalloffStart = _backupCA.FinalGatherFalloffStart
							renderers.current.FinalGatherFalloffStop = _backupCA.FinalGatherFalloffStop
							
							renderers.current.FinalGatherUseRadiusInterpolation = _backupCA.FinalGatherUseRadiusInterpolation
							renderers.current.FinalGatherView = _backupCA.FinalGatherView
							renderers.current.UseFinalGatherRadius = _backupCA.UseFinalGatherRadius
							renderers.current.UseFinalGatherMinRadius = _backupCA.UseFinalGatherMinRadius
							renderers.current.FinalGatherRadius = _backupCA.FinalGatherRadius
							renderers.current.FinalGatherMinRadius = _backupCA.FinalGatherMinRadius
							renderers.current.FinalGatherRadius_View = _backupCA.FinalGatherRadius_View
							renderers.current.FinalGatherMinRadius_View = _backupCA.FinalGatherMinRadius_View
						)--if
							
						--MENTAL FINAL GATHER END
						------------------------------------------------

						-----------------------------------------------
						--MENTAL CAUSTICS

						if (this.infoNodeCA.overrideMentalCaustics) then
						(
							renderers.current.CausticsEnable = _backupCA.CausticsEnable
							renderers.current.CausticMultiplierScalar = _backupCA.CausticMultiplierScalar
							renderers.current.CausticMultiplierColor = _backupCA.CausticMultiplierColor
							renderers.current.CausticAccuracy = _backupCA.CausticAccuracy
							renderers.current.UseCausticRadius = _backupCA.UseCausticRadius
							renderers.current.CausticRadius = _backupCA.CausticRadius
							renderers.current.CausticsFilter = _backupCA.CausticsFilter
							renderers.current.Kernel = _backupCA.Kernel
							renderers.current.CausticOpaqueShadows = _backupCA.CausticOpaqueShadows
							
							renderers.current.GlobalIllumEnable = _backupCA.GlobalIllumEnable
							renderers.current.GIMultiplierScalar = _backupCA.GIMultiplierScalar
							renderers.current.GIMultiplierColor = _backupCA.GIMultiplierColor
							renderers.current.GlobalIllumAccuracy = _backupCA.GlobalIllumAccuracy
							renderers.current.UseGlobalIllumRadius = _backupCA.UseGlobalIllumRadius
							renderers.current.GlobalIllumRadius = _backupCA.GlobalIllumRadius
							renderers.current.GIPhotonMergeDistance = _backupCA.GIPhotonMergeDistance

							renderers.current.VolumeAccuracy = _backupCA.VolumeAccuracy
							renderers.current.UseVolumeRadius = _backupCA.UseVolumeRadius
							renderers.current.VolumeRadius = _backupCA.VolumeRadius

							renderers.current.GIMaximumTraceDepth = _backupCA.GIMaximumTraceDepth
							renderers.current.GIMaximumReflections = _backupCA.GIMaximumReflections
							renderers.current.GIMaximumRefractions = _backupCA.GIMaximumRefractions

							renderers.current.GlobalLightCausticPhotons = _backupCA.GlobalLightCausticPhotons
							renderers.current.GlobalLightGIPhotons = _backupCA.GlobalLightGIPhotons
							renderers.current.GlobalLightDecay = _backupCA.GlobalLightDecay

							renderers.current.OverrideIIObjProps = _backupCA.OverrideIIObjProps
						)--if

						--MENTAL CAUSTICS END
						-----------------------------------------------

						------------------------------------------------
						--MENTAL REUSE FINAL GATHER

						if (this.infoNodeCA.overrideMentalReuseFG) then
						(
							renderers.current.IlluminationCacheMode = _backupCA.IlluminationCacheMode
							renderers.current.SkipFinalRender = _backupCA.SkipFinalRender
							
							renderers.current.UseFinalGatherFile = _backupCA.UseFinalGatherFile
							renderers.current.FinalGatherFreeze = _backupCA.FinalGatherFreeze
							renderers.current.FGInterpolateNFrames = _backupCA.FGInterpolateNFrames
							renderers.current.FinalGatherFilename = _backupCA.FinalGatherFilename
							renderers.current.FinalGatherTempFilename = _backupCA.FinalGatherTempFilename
								
							renderers.current.PhotonMapUseFile = _backupCA.PhotonMapUseFile
							renderers.current.PhotonFreeze = _backupCA.PhotonFreeze
							renderers.current.PhotonMapFilename = _backupCA.PhotonMapFilename
							renderers.current.FinalGatherOnly = _backupCA.FinalGatherOnly
							renderers.current.PhotonsOnly = _backupCA.PhotonsOnly
						)--if
							
						--MENTAL REUSE FINAL GATHER END
						------------------------------------------------

						------------------------------------------------
						--MENTAL TRANSLATOR OPTIONS

						if (this.infoNodeCA.overrideMentalTranslatorOptions) then
						(
							renderers.current.Use_Placeholders = _backupCA.Use_Placeholders
							renderers.current.Conserve_Memory = _backupCA.Conserve_Memory
							renderers.current.mental_ray_Manages_Maps = _backupCA.mental_ray_Manages_Maps

							renderers.current.ClearGeometryCache()
							renderers.current.EnableGeometryCache = _backupCA.EnableGeometryCache
							renderers.current.LockGeometryCache = _backupCA.LockGeometryCache

							renderers.current.Enable_Material_Override = _backupCA.Enable_Material_Override
							renderers.current.Override_Material = _backupCA.Override_Material

							renderers.current.Skip_Texture_Maps = _backupCA.Skip_Texture_Maps
						)--if

						--MENTAL TRANSLATOR OPTIONS END
						------------------------------------------------

						if saveLogs then lb.log.add ("Restore End: Mental ray parameters") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)
					)--if

					--MENTAL RAY END
					------------------------------------------------					


					if saveLogs then lb.log.add ("RESTORE process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel					
					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("RESTORE process error. CA #overrideRendererSettingsInfo is undefined.") sender:("override." + (this.getSubType())) type:#error level:logLevel
					
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("RESTORE process error. Backup Node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				
				_success = false
			)

			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1=
		(
			_success = false
			
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			------------------------------------------------
			--GENERAL

			if (classof renderers.current) as string != (this.infoNodeCA.currentRenderer) then
			(				
				--aplica el motor de render
				renderers.current = execute (this.infoNodeCA.currentRenderer + "()")
				
				--restaura las propiedades de ese motor que tuviera la escena
				_parentContainer = this.getParentContainer() --primero hay que averiguar el contenedor de overrides del que cuelga
				_passTree = _parentContainer.getRootContainer() --obtiene el nodo raiz del arbol de pases del que cuelga el override
				lb.passManager.restoreRendererSceneSettingsBackup (classOf renderers.current) _passTree --restablece el backup de settings del render solicitado del arbol de pases actual
			
				_success = true
			)
			else
			(
				_success = true
			)
			------------------------------------------------

			------------------------------------------------
			--SCANLINE

			if (classof renderers.current) == Default_Scanline_Renderer then
			(
				------------------------------------------------
				--SCANLINE GENERAL PARAMS

				if (this.infoNodeCA.overrideScanlineGeneralParams) then
				(
					renderers.current.antiAliasing = this.infoNodeCA.antiAliasing
					renderers.current.antiAliasFilter = this.infoNodeCA.antiAliasFilter
					renderers.current.filterMaps = this.infoNodeCA.filterMaps
					renderers.current.antiAliasFilterSize = this.infoNodeCA.antiAliasFilterSize
				)--if

				--SCANLINE GENERAL PARAMS END
				------------------------------------------------
			)

			--SCANLINE END
			------------------------------------------------

			------------------------------------------------
			--MENTAL RAY

			if (classof renderers.current) == mental_ray_renderer then
			(
				if saveLogs then lb.log.add ("Apply: Mental ray parameters") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)

				------------------------------------------------
				--MENTAL SAMPLING QUALITY

				if (this.infoNodeCA.overrideMentalSamplingQuality) then
				(
					if saveLogs then lb.log.add ("Apply: Mental Sampling Quality") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 2)

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
					case this.rollMentalSamplingQuality.filtersArray[renderers.current.Filter + 1] of
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

					if saveLogs then lb.log.add ("Apply End: Mental Sampling Quality") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 2)
				)--if

				--MENTAL SAMPLING QUALITY END
				------------------------------------------------

				------------------------------------------------
				--MENTAL RENDERING ALGORITHMS

				if (this.infoNodeCA.overrideMentalRenderingAlgorithms) then
				(				
					renderers.current.ScanlineEnable = this.infoNodeCA.ScanlineEnable
					renderers.current.ScanlineMethod = this.infoNodeCA.ScanlineMethod
					renderers.current.RapidCollectRate = this.infoNodeCA.RapidCollectRate
					renderers.current.RapidShadingSamples = this.infoNodeCA.RapidShadingSamples
					
					renderers.current.RaytraceEnable = this.infoNodeCA.RaytraceEnable
					renderers.current.Autovolume = this.infoNodeCA.Autovolume
					renderers.current.RaytraceMethod = this.infoNodeCA.RaytraceMethod
					renderers.current.BSPSize = this.infoNodeCA.BSPSize
					renderers.current.BSPDepth = this.infoNodeCA.BSPDepth
					
					renderers.current.ReflectionsEnable = this.infoNodeCA.ReflectionsEnable
					renderers.current.RefractionsEnable = this.infoNodeCA.RefractionsEnable
					renderers.current.MaximumTraceDepth = this.infoNodeCA.MaximumTraceDepth
					renderers.current.MaximumReflections = this.infoNodeCA.MaximumReflections
					renderers.current.MaximumRefractions = this.infoNodeCA.MaximumRefractions
					
					--Si cuelga del passtree entonces forzaremos que esté apagado.
					if ((getParentContainer()).getCaption()) == "settings" then
						this.infoNodeCA.enable_subset_pixel_rendering = false
					
					renderers.current.enable_subset_pixel_rendering = this.infoNodeCA.enable_subset_pixel_rendering
						
					if renderers.current.enable_subset_pixel_rendering and Selection.count == 0 then
						lb.message.show "Render changes to selected objects only is checked, but no elements are selected in scene. Nothing will be rendered."
						
					--esta propiedad sólo se aplica si esta activado el Autovolume. No pertenece realmente al override
	 				renderers.current.ShadowMethod = if renderers.current.Autovolume then this.infoNodeCA.ShadowMethod else 0
				)--if

				--MENTAL RENDERING ALGORITHMS END
				------------------------------------------------

				------------------------------------------------
				--MENTAL CAMERA EFFECTS
				if (this.infoNodeCA.overrideMentalCameraEffects) then
				(

					renderers.current.MotionBlurEnable = this.infoNodeCA.MotionBlurEnable
					renderers.current.MotionBlurAllObjects = this.infoNodeCA.MotionBlurAllObjects
					renderers.current.Shutter = this.infoNodeCA.Shutter
					renderers.current.MotionBlurOffset = this.infoNodeCA.MotionBlurOffset
					renderers.current.Segments = this.infoNodeCA.Segments
					renderers.current.TimeSamples = this.infoNodeCA.TimeSamples
					renderers.current.RapidMotionResample = this.infoNodeCA.RapidMotionResample

					renderers.current.EnableContours = this.infoNodeCA.EnableContours
					renderers.current.Contour_Contrast_Shader = this.infoNodeCA.Contour_Contrast_Shader
					renderers.current.Contour_Output_Shader = this.infoNodeCA.Contour_Output_Shader
					renderers.current.Contour_Store_Shader = this.infoNodeCA.Contour_Store_Shader

					renderers.current.Enable_Camera_Lens_Shader = this.infoNodeCA.Enable_Camera_Lens_Shader
					renderers.current.Camera_Lens_Shader = this.infoNodeCA.Camera_Lens_Shader
					renderers.current.Enable_Camera_Output_Shader = this.infoNodeCA.Enable_Camera_Output_Shader
					renderers.current.Camera_Output_Shader = this.infoNodeCA.Camera_Output_Shader
					renderers.current.Enable_Camera_Volume_Shader = this.infoNodeCA.Enable_Camera_Volume_Shader
					renderers.current.Camera_Volume_Shader = this.infoNodeCA.Camera_Volume_Shader

					renderers.current.DepthOfFieldEnable = this.infoNodeCA.DepthOfFieldEnable
					renderers.current.DepthOfFieldMode = this.infoNodeCA.DepthOfFieldMode
					renderers.current.FocusPlane = this.infoNodeCA.FocusPlane
					renderers.current.fStop = this.infoNodeCA.fStop
					renderers.current.NearFocus = this.infoNodeCA.NearFocus
					renderers.current.FarFocus = this.infoNodeCA.FarFocus
				)

				--MENTAL CAMERA EFFECTS END
				------------------------------------------------

				------------------------------------------------
				--MENTAL SHADOWS AND DISPLACEMENT
				
				if (this.infoNodeCA.overrideMentalShadowsAndDisplacement) then
				(
					renderers.current.ShadowsEnable = this.infoNodeCA.ShadowsEnable
					renderers.current.ShadowMethod = this.infoNodeCA.ShadowMethod

					renderers.current.EnableShadowMaps = this.infoNodeCA.EnableShadowMaps
					renderers.current.MotionBlurShadowMapsEnable = this.infoNodeCA.MotionBlurShadowMapsEnable
					renderers.current.ShadowMapRebuild = this.infoNodeCA.ShadowMapRebuild
					renderers.current.UseShadowMapFile = this.infoNodeCA.UseShadowMapFile
					renderers.current.ShadowMapFilename = this.infoNodeCA.ShadowMapFilename

					renderers.current.view = this.infoNodeCA.view
					renderers.current.Smooth = this.infoNodeCA.Smooth
					renderers.current.Edge_Length = this.infoNodeCA.Edge_Length
					renderers.current.Max_Displace = this.infoNodeCA.Max_Displace
					renderers.current.Max_Level = this.infoNodeCA.Max_Level
				)

				--MENTAL SHADOWS AND DISPLACEMENT END
						------------------------------------------------

				------------------------------------------------
				--MENTAL GLOBAL TUNING PARAMS

				if (this.infoNodeCA.overrideMentalGlobalTuningParams) then
				(
					renderers.current.softShadowsPrecision = this.infoNodeCA.softShadowsPrecision 
					renderers.current.glossyReflectionsPrecision = this.infoNodeCA.glossyReflectionsPrecision
					renderers.current.glossyRefractionsPrecision = this.infoNodeCA.glossyRefractionsPrecision
				)--if

				--MENTAL GLOBAL TUNING PARAMS END
				------------------------------------------------

				------------------------------------------------
				--MENTAL IBL

				if (this.infoNodeCA.overrideMentalIBL) then
				(
					renderers.current.IBLEnable = this.infoNodeCA.IBLEnable
					renderers.current.IBLQuality = this.infoNodeCA.IBLQuality
					renderers.current.IBLShadows = this.infoNodeCA.IBLShadows
				)--if

				--MENTAL IBL END
				------------------------------------------------

				------------------------------------------------
				--MENTAL FINAL GATHER

				if (this.infoNodeCA.overrideMentalFinalGather) then
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
				)--if
					
				--MENTAL FINAL GATHER END
				------------------------------------------------

				-----------------------------------------------
				--MENTAL CAUSTICS

				if (this.infoNodeCA.overrideMentalCaustics) then
				(
					renderers.current.CausticsEnable = this.infoNodeCA.CausticsEnable
					renderers.current.CausticMultiplierScalar = this.infoNodeCA.CausticMultiplierScalar
					renderers.current.CausticMultiplierColor = this.infoNodeCA.CausticMultiplierColor
					renderers.current.CausticAccuracy = this.infoNodeCA.CausticAccuracy
					renderers.current.UseCausticRadius = this.infoNodeCA.UseCausticRadius
					renderers.current.CausticRadius = this.infoNodeCA.CausticRadius
					renderers.current.CausticsFilter = this.infoNodeCA.CausticsFilter
					renderers.current.Kernel = this.infoNodeCA.Kernel
					renderers.current.CausticOpaqueShadows = this.infoNodeCA.CausticOpaqueShadows
					
					renderers.current.GlobalIllumEnable = this.infoNodeCA.GlobalIllumEnable
					renderers.current.GIMultiplierScalar = this.infoNodeCA.GIMultiplierScalar
					renderers.current.GIMultiplierColor = this.infoNodeCA.GIMultiplierColor
					renderers.current.GlobalIllumAccuracy = this.infoNodeCA.GlobalIllumAccuracy
					renderers.current.UseGlobalIllumRadius = this.infoNodeCA.UseGlobalIllumRadius
					renderers.current.GlobalIllumRadius = this.infoNodeCA.GlobalIllumRadius
					renderers.current.GIPhotonMergeDistance = this.infoNodeCA.GIPhotonMergeDistance

					renderers.current.VolumeAccuracy = this.infoNodeCA.VolumeAccuracy
					renderers.current.UseVolumeRadius = this.infoNodeCA.UseVolumeRadius
					renderers.current.VolumeRadius = this.infoNodeCA.VolumeRadius

					renderers.current.GIMaximumTraceDepth = this.infoNodeCA.GIMaximumTraceDepth
					renderers.current.GIMaximumReflections = this.infoNodeCA.GIMaximumReflections
					renderers.current.GIMaximumRefractions = this.infoNodeCA.GIMaximumRefractions

					renderers.current.GlobalLightCausticPhotons = this.infoNodeCA.GlobalLightCausticPhotons
					renderers.current.GlobalLightGIPhotons = this.infoNodeCA.GlobalLightGIPhotons
					renderers.current.GlobalLightDecay = this.infoNodeCA.GlobalLightDecay

					renderers.current.OverrideIIObjProps = this.infoNodeCA.OverrideIIObjProps
				)--if

				--MENTAL CAUSTICS END
				-----------------------------------------------

				------------------------------------------------
				--MENTAL REUSE FINAL GATHER

				if (this.infoNodeCA.overrideMentalReuseFG) then
				(
					renderers.current.IlluminationCacheMode = this.infoNodeCA.IlluminationCacheMode
					renderers.current.SkipFinalRender = this.infoNodeCA.SkipFinalRender
					
					renderers.current.UseFinalGatherFile = this.infoNodeCA.UseFinalGatherFile
					renderers.current.FinalGatherFreeze = this.infoNodeCA.FinalGatherFreeze
					renderers.current.FGInterpolateNFrames = this.infoNodeCA.FGInterpolateNFrames
					renderers.current.FinalGatherFilename = this.infoNodeCA.FinalGatherFilename
					renderers.current.FinalGatherTempFilename = this.infoNodeCA.FinalGatherTempFilename
						
					renderers.current.PhotonMapUseFile = this.infoNodeCA.PhotonMapUseFile
					renderers.current.PhotonFreeze = this.infoNodeCA.PhotonFreeze
					renderers.current.PhotonMapFilename = this.infoNodeCA.PhotonMapFilename
					renderers.current.FinalGatherOnly = this.infoNodeCA.FinalGatherOnly
					renderers.current.PhotonsOnly = this.infoNodeCA.PhotonsOnly
				)--if
					
				--MENTAL REUSE FINAL GATHER END
				------------------------------------------------

				------------------------------------------------
				--MENTAL TRANSLATOR OPTIONS

				if (this.infoNodeCA.overrideMentalTranslatorOptions) then
				(
					renderers.current.Use_Placeholders = this.infoNodeCA.Use_Placeholders
					renderers.current.Conserve_Memory = this.infoNodeCA.Conserve_Memory
					renderers.current.mental_ray_Manages_Maps = this.infoNodeCA.mental_ray_Manages_Maps

					renderers.current.ClearGeometryCache()
					renderers.current.EnableGeometryCache = this.infoNodeCA.EnableGeometryCache
					renderers.current.LockGeometryCache = this.infoNodeCA.LockGeometryCache

					renderers.current.Enable_Material_Override = this.infoNodeCA.Enable_Material_Override
					renderers.current.Override_Material = this.infoNodeCA.Override_Material

					renderers.current.Skip_Texture_Maps = this.infoNodeCA.Skip_Texture_Maps
				)--if

				--MENTAL TRANSLATOR OPTIONS END
				------------------------------------------------

				if saveLogs then lb.log.add ("Apply End: Mental ray parameters") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)
			)--if

			--MENTAL RAY END
			------------------------------------------------					
			
			if saveLogs then lb.log.add ("APPLY process complete.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
			
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
				if this.editBackupNode.custAttributes[#overrideRendererSettingsInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideRendererSettingsInfo]) _prop))
					)--undo
					
					this.editBackupNode = undefined --hace que el override no tenga backup de edicion almacenado
					
					this.updateUIinfo() --actualiza la infirmacion en el UI si ha cambiado
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello.		
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
						if this.editBackupNode.custAttributes[#overrideRendererSettingsInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideRendererSettingsInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideRendererSettingsInfo]) _prop (getProperty (this.infoNodeCA) _prop))
					)--if
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | updateRendererTabsColor | Actualiza el color de los tabs del motor de render elegido
		------------------------------------------------
		fn updateRendererTabsColor =
		(
			--en funcion del motor de render, se actualizan unos rolls u otros
			_rollsByTab = #()
			case this.rollMain.editCA.currentRenderer of
			(
				"Default_Scanline_Renderer": _rollsByTab = this.scanlineRollouts
				"mental_ray_renderer": _rollsByTab = this.mentalrayRollouts
				"iray_Renderer": _rollsByTab = this.irayRollouts
				"Quicksilver_Hardware_Renderer": _rollsByTab = this.quicksilverRollouts
			)--case			

			--actualiza los tabs
			for i=1 to this.rollMain.tbSettingsCategories.tabPages.count do
			(
				_overridedTab = false --flag para saber si hay algun override activo

				--avrigua si para cada tab hay overrides activos
				for roll in _rollsByTab[i] do
				(
					roll.title = substituteString roll.title " (*)" "" --devolvemos el nombre a su estado normal
					_overrideProperty = substituteString (substituteString roll.name "roll" "override") "Def" ""
					if getProperty this.rollMain.editCA _overrideProperty do
					(
						_overridedTab = true
						roll.title = (roll.title + " (*)")
					)
				)--for

				--si tiene overrides añade (*) al nombre del tab
				if _overridedTab then
				(
					if findString this.rollMain.tbSettingsCategories.tabPages.item[i-1].text " (*)" == undefined then
						this.rollMain.tbSettingsCategories.tabPages.item[i-1].text = (this.rollMain.tbSettingsCategories.tabPages.item[i-1].text) + " (*)"
				)
				else this.rollMain.tbSettingsCategories.tabPages.item[i-1].text = substituteString this.rollMain.tbSettingsCategories.tabPages.item[i-1].text " (*)" ""

				--configura los colores de los tabs
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.ForeColor = if _overridedTab then this.tabForeColorOverridedActive else this.tabForeColor
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.BackColor = this.tabBackColor
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.BackColor2 = this.tabBackColor2
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.Header.BorderColor = this.tabBorderColor
				
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 8
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.ForeColor = if _overridedTab then this.tabForeColorOverridedActive else this.tabForeColor
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.BackColor = this.tabBackColorActive
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.BackColor2 = this.tabBackColorActive2
				this.rollMain.tbSettingsCategories.tabPages.item[i-1].Appearance.HeaderActive.BorderColor = this.tabBorderColor
			)--for
		),

		------------------------------------------------
		--@fn: undefined | addRendererTabs | Añade los tabs del motor de render elegido.
		------------------------------------------------
		fn addRendererTabs =
		(
			--elimina los tabs actuales
			this.rollMain.tbSettingsCategories.tabPages.clear()

			--array para almacenar los tabs a utilizar
			_tabsToUse = #()

			--en funcion del motor de render, se añaden unos tabs u otros y en funcion de esos tabs, los rollouts de propiedades
			case this.rollMain.editCA.currentRenderer of
			(
				"Default_Scanline_Renderer": _tabsToUse = this.scanlineTabNames
				"mental_ray_renderer": _tabsToUse = this.mentalrayTabNames
				"iray_Renderer": _tabsToUse = this.irayTabNames
				"Quicksilver_Hardware_Renderer": _tabsToUse = this.quicksilverTabNames
			)--case			

			--añade los tabs
			for i=1 to _tabsToUse.count do
				this.rollMain.tbSettingsCategories.tabPages.add _tabsToUse[i] --añade el tab
			
			--selecciona el tab que estaba seleccionado la ultima vez que se abrio el override
			if this.rollMain.tbSettingsCategories.tabPages.count >= this.selectedTabIndex then
			(
				this.rollMain.tbSettingsCategories.SelectedTabPage = this.rollMain.tbSettingsCategories.tabPages.item[this.selectedTabIndex - 1]
			)

			this.addTabRollouts()			
		),

		------------------------------------------------
		--@fn: undefined | removeAllTabRollouts | Elimina todos los subrollouts actuales
		------------------------------------------------
		fn removeAllTabRollouts =
		(
			--elimina los subRollouts actuales
			while this.subRolloutsContainer.rollouts.count != 0 do RemoveSubRollout this.subRolloutsContainer this.subRolloutsContainer.rollouts[1]
		),

		------------------------------------------------
		--@fn: undefined | addTabRollouts | Añade los rollouts del tab del motor de render elegido
		------------------------------------------------
		fn addTabRollouts =
		(
			--elimina los subRollouts actuales
			this.removeAllTabRollouts()

			_subrolloutsToUse = #() --array para meter los rollouts del tab actual
			_subrolloutsToUseRolledUp = #() --array para los estados de desplegado o plegado de cada subrollout

			_tabIndex = this.rollMain.tbSettingsCategories.SelectedTabPageIndex + 1
			if _tabIndex < 1 then _tabIndex = 1

			--en funcion del motor de render, se añaden unos tabs u otros y en funcion de esos tabs, los rollouts de propiedades
			case this.rollMain.editCA.currentRenderer of
			(
				"Default_Scanline_Renderer":
				(
					_subrolloutsToUse = this.scanlineRollouts[_tabIndex]
					_subrolloutsToUseRolledUp = this.scanlineRolloutsRolledUp[_tabIndex]
				)

				"mental_ray_renderer":
				(
					_subrolloutsToUse = this.mentalrayRollouts[_tabIndex]
					_subrolloutsToUseRolledUp = this.mentalrayRolloutsRolledUp[_tabIndex]
				)

				"iray_Renderer":
				(
					_subrolloutsToUse = this.irayRollouts[_tabIndex]
					_subrolloutsToUseRolledUp = this.irayRolloutsRolledUp[_tabIndex]
				)

				"Quicksilver_Hardware_Renderer":
				(
					_subrolloutsToUse = this.quicksilverRollouts[_tabIndex]
					_subrolloutsToUseRolledUp = this.quicksilverRolloutsRolledUp[_tabIndex]
				)
			)--case
			
			--añade los subRollouts
			for i=1 to _subrolloutsToUse.count do AddSubRollout this.subRolloutsContainer _subrolloutsToUse[i] rolledUp:_subrolloutsToUseRolledUp[i]

			this.updateRendererTabsColor() --actualiza los colores de los tabs
		),

		------------------------------------------------
		--@fn: undefined | edit | Muestra el dialogo de edicion del override.
		--@opt: Point2 | pos | [0,0] | Posicion en la que aparecera el rollout de edicion del override.
		------------------------------------------------
		fn edit pos:[0,0] =
		(
			this.createEditBackup() --crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello 			
			
			lb.passManager.setCurrentEditInstance this
			
			_size = [350, 600]			
			_pos = pos - (_size/2)
			
			createDialog this.rollMain lockwidth:true lockheight:false pos:_pos width:_size.x height:_size.y modal:true style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		--@fn: undefined | upgrade | Actualiza la version del override
		--@opt: float | previousVersion | Versión en la que se encontraba previamente
		------------------------------------------------
		fn upgrade previousVersion:0.0 =
		(
			if previousVersion < 1.1 do
			(
				this.infoNodeCA.FinalGatherFilename = toLower this.infoNodeCA.FinalGatherFilename
				this.infoNodeCA.FinalGatherFilename = substituteString this.infoNodeCA.FinalGatherFilename "lbbackup2" "lbdata002"
				this.infoNodeCA.FinalGatherFilename = substituteString this.infoNodeCA.FinalGatherFilename "lbbackup" "lbdata001"
				
				this.infoNodeCA.PhotonMapFilename = toLower this.infoNodeCA.PhotonMapFilename
				this.infoNodeCA.PhotonMapFilename = substituteString this.infoNodeCA.PhotonMapFilename "lbbackup2" "lbdata002"
				this.infoNodeCA.PhotonMapFilename = substituteString this.infoNodeCA.PhotonMapFilename "lbbackup" "lbdata001"
			)
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
				if (lb.customAttributes.hasAttribute this.infoNode #overrideRendererSettingsInfo) then
				(
					this.infoNodeCA = this.infoNode.custAttributes[#overrideRendererSettingsInfo] --Rellena la variable de atajo para usarla de forma más cómoda
				)
				else
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false
					this.infoNodeCA = this.infoNode.custAttributes[#overrideRendererSettingsInfo] --Rellena la variable de atajo para usarla de forma más cómoda

					------------------------------------------------
					--Parametros del CA que se obtienen en funcion del motor de render actual
					
					------------------------------------------------
					--GENERAL

					--almacena el tipo del render actual
					if (not (matchPattern (renderers.current As string) pattern:"Missing*")) and (not (matchPattern (renderers.current As String) pattern:"VUE*")) then
						this.infoNodeCA.currentRenderer = ((classof renderers.current) As String)
					else
						this.infoNodeCA.currentRenderer = "mental_ray_renderer"
					------------------------------------------------

					------------------------------------------------
					--SCANLINE

						--renderer del que obtener los parámetros
						_renderer = if classof renderers.current == Default_Scanline_Renderer then renderers.current else Default_Scanline_Renderer()

						------------------------------------------------
						--SCANLINE GENERAL PARAMS
						(
							this.infoNodeCA.overrideScanlineGeneralParams = false --override deshabilitado

							this.infoNodeCA.antiAliasing = _renderer.antiAliasing
							this.infoNodeCA.antiAliasFilter = _renderer.antiAliasFilter
							this.infoNodeCA.filterMaps = _renderer.filterMaps
							this.infoNodeCA.antiAliasFilterSize = _renderer.antiAliasFilterSize
						)
						--SCANLINE GENERAL PARAMS END
						------------------------------------------------

					--SCANLINE END
					------------------------------------------------
					
					------------------------------------------------
					--MENTAL RAY

						--renderer del que obtener los parámetros
						_renderer = if classof renderers.current == mental_ray_renderer then renderers.current else mental_ray_renderer()

						------------------------------------------------
						--MENTAL SAMPLING QUALITY
						(							
							this.infoNodeCA.overrideMentalSamplingQuality = true --override habilitado para el passTree, desactivar si es hijo

							------------------------------------------------
							--Sampling Quality							

							if (maxVersion())[1] >= 16000 then --solo de 3ds max 2014 en adelante
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
							
							this.infoNodeCA.FilterType = 2 --Triangle
							--this.infoNodeCA.FilterType = _renderer.Filter
							this.infoNodeCA.BoxFilterWidth  = _renderer.BoxFilterWidth
							this.infoNodeCA.BoxFilterHeight  = _renderer.BoxFilterHeight						
							this.infoNodeCA.GaussFilterWidth  = _renderer.GaussFilterWidth
							this.infoNodeCA.GaussFilterHeight  = _renderer.GaussFilterHeight
							this.infoNodeCA.TriangleFilterWidth  = _renderer.TriangleFilterWidth
							this.infoNodeCA.TriangleFilterHeight  = _renderer.TriangleFilterHeight
							this.infoNodeCA.MitchellFilterWidth  = _renderer.MitchellFilterWidth
							this.infoNodeCA.MitchellFilterHeight  = _renderer.MitchellFilterHeight
							this.infoNodeCA.LanczosFilterWidth  = _renderer.LanczosFilterWidth
							this.infoNodeCA.LanczosFilterHeight  = _renderer.LanczosFilterHeight
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

						)
						--MENTAL SAMPLING QUALITY END
						------------------------------------------------

						------------------------------------------------
						--MENTAL RENDERING ALGORITHMS
						(							
							this.infoNodeCA.overrideMentalRenderingAlgorithms = true --override habilitado para el passTree, desactivar si es hijo

							this.infoNodeCA.ScanlineEnable = _renderer.scanlineEnable
							this.infoNodeCA.ScanlineMethod = _renderer.ScanlineMethod
							this.infoNodeCA.RapidCollectRate = _renderer.RapidCollectRate
							this.infoNodeCA.RapidShadingSamples = _renderer.RapidShadingSamples
							
							this.infoNodeCA.RaytraceEnable = _renderer.RaytraceEnable
							this.infoNodeCA.Autovolume = _renderer.Autovolume
							this.infoNodeCA.RaytraceMethod = _renderer.RaytraceMethod
							this.infoNodeCA.BSPSize = _renderer.BSPSize
							this.infoNodeCA.BSPDepth = _renderer.BSPDepth
							
							this.infoNodeCA.ReflectionsEnable = _renderer.ReflectionsEnable
							this.infoNodeCA.RefractionsEnable = _renderer.RefractionsEnable
							this.infoNodeCA.MaximumTraceDepth = _renderer.MaximumTraceDepth
							this.infoNodeCA.MaximumReflections = 1
							--this.infoNodeCA.MaximumReflections = _renderer.MaximumReflections
							this.infoNodeCA.MaximumRefractions = _renderer.MaximumRefractions
							
							this.infoNodeCA.enable_subset_pixel_rendering = _renderer.enable_subset_pixel_rendering
							this.infoNodeCA.ShadowMethod = if _renderer.Autovolume then infoNodeCA.ShadowMethod else 0
						)
						--MENTAL RENDERING ALGORITHMS END
						------------------------------------------------

						------------------------------------------------
						--MENTAL CAMERA EFFECTS
						(
							this.infoNodeCA.overrideMentalCameraEffects = true --override habilitado para el passTree, desactivar si es hijo

							this.infoNodeCA.MotionBlurEnable = _renderer.MotionBlurEnable
							this.infoNodeCA.MotionBlurAllObjects = _renderer.MotionBlurAllObjects
							this.infoNodeCA.Shutter = _renderer.Shutter
							this.infoNodeCA.MotionBlurOffset = _renderer.MotionBlurOffset
							this.infoNodeCA.Segments = _renderer.Segments
							this.infoNodeCA.TimeSamples = _renderer.TimeSamples
							this.infoNodeCA.RapidMotionResample = _renderer.RapidMotionResample

							this.infoNodeCA.EnableContours = _renderer.EnableContours
							this.infoNodeCA.Contour_Contrast_Shader = _renderer.Contour_Contrast_Shader
							this.infoNodeCA.Contour_Output_Shader = _renderer.Contour_Output_Shader
							this.infoNodeCA.Contour_Store_Shader = _renderer.Contour_Store_Shader

							this.infoNodeCA.Enable_Camera_Lens_Shader = _renderer.Enable_Camera_Lens_Shader
							this.infoNodeCA.Camera_Lens_Shader = _renderer.Camera_Lens_Shader
							this.infoNodeCA.Enable_Camera_Output_Shader = _renderer.Enable_Camera_Output_Shader
							this.infoNodeCA.Camera_Output_Shader = _renderer.Camera_Output_Shader
							this.infoNodeCA.Enable_Camera_Volume_Shader = _renderer.Enable_Camera_Volume_Shader
							this.infoNodeCA.Camera_Volume_Shader = _renderer.Camera_Volume_Shader

							this.infoNodeCA.DepthOfFieldEnable = _renderer.DepthOfFieldEnable
							this.infoNodeCA.DepthOfFieldMode = _renderer.DepthOfFieldMode
							this.infoNodeCA.FocusPlane = _renderer.FocusPlane
							this.infoNodeCA.fStop = _renderer.fStop
							this.infoNodeCA.NearFocus = _renderer.NearFocus
							this.infoNodeCA.FarFocus = _renderer.FarFocus
						)
						--MENTAL CAMERA EFFECTS END
						------------------------------------------------

						------------------------------------------------
						--MENTAL SHADOWS AND DISPLACEMENT
						(
							this.infoNodeCA.overrideMentalShadowsAndDisplacement = true --override habilitado para el passTree, desactivar si es hijo

							this.infoNodeCA.ShadowsEnable = _renderer.ShadowsEnable
							this.infoNodeCA.ShadowMethod = _renderer.ShadowMethod

							this.infoNodeCA.EnableShadowMaps = _renderer.EnableShadowMaps
							this.infoNodeCA.MotionBlurShadowMapsEnable = _renderer.MotionBlurShadowMapsEnable
							this.infoNodeCA.ShadowMapRebuild = _renderer.ShadowMapRebuild
							this.infoNodeCA.UseShadowMapFile = _renderer.UseShadowMapFile
							this.infoNodeCA.ShadowMapFilename = _renderer.ShadowMapFilename

							this.infoNodeCA.view = _renderer.view
							this.infoNodeCA.Smooth = _renderer.Smooth
							this.infoNodeCA.Edge_Length	= _renderer.Edge_Length
							this.infoNodeCA.Max_Displace = _renderer.Max_Displace
							this.infoNodeCA.Max_Level = _renderer.Max_Level
						)
						--MENTAL SHADOWS AND DISPLACEMENT END
						------------------------------------------------

						------------------------------------------------
						--MENTAL GLOBAL TUNING PARAMS
						(
							this.infoNodeCA.overrideMentalGlobalTuningParams = true --override habilitado para el passTree, desactivar si es hijo

							this.infoNodeCA.softShadowsPrecision = _renderer.softShadowsPrecision
							this.infoNodeCA.glossyReflectionsPrecision= _renderer.glossyReflectionsPrecision
							this.infoNodeCA.glossyRefractionsPrecision= _renderer.glossyRefractionsPrecision
						)
						--MENTAL GLOBAL TUNING PARAMS END
						------------------------------------------------

						------------------------------------------------
						--MENTAL IBL
						(
							this.infoNodeCA.overrideMentalIBL = true --override habilitado para el passTree, desactivar si es hijo

							this.infoNodeCA.IBLEnable = _renderer.IBLEnable
							this.infoNodeCA.IBLQuality = _renderer.IBLQuality
							this.infoNodeCA.IBLShadows = _renderer.IBLShadows + 1 --Inicialización del dropdownlist a Opaque (opción 1)
						)
						--MENTAL IBL END
						------------------------------------------------

						------------------------------------------------
						--MENTAL FINAL GATHER
						(
							this.infoNodeCA.overrideMentalFinalGather = true
							--this.infoNodeCA.overrideMentalFinalGather = fase --Cambio en la linea superior para inicializarlo a true
							--this.infoNodeCA.overrideMentalFinalGather = true --override habilitado para el passTree, desactivar si es hijo

							--this.infoNodeCA.FinalGatherEnable2 = _renderer.FinalGatherEnable2
							this.infoNodeCA.FinalGatherEnable2 = false

							this.infoNodeCA.FGMultiplierScalar = _renderer.FGMultiplierScalar
							this.infoNodeCA.FGMultiplierColor = _renderer.FGMultiplierColor
							
							this.infoNodeCA.FGProjectionMode = _renderer.FGProjectionMode
							this.infoNodeCA.FGProjectionModeNumSegments = _renderer.FGProjectionModeNumSegments
							this.infoNodeCA.FinalGatherDensity = _renderer.FinalGatherDensity
							this.infoNodeCA.FinalGatherAccuracy = _renderer.FinalGatherAccuracy
							this.infoNodeCA.FinalGatherInterpolationSamples = _renderer.FinalGatherInterpolationSamples
							this.infoNodeCA.FinalGatherBounces = _renderer.FinalGatherBounces
							this.infoNodeCA.FinalGatherBounceMultiplier = _renderer.FinalGatherBounceMultiplier
							
							this.infoNodeCA.FinalGatherFilter = _renderer.FinalGatherFilter
							this.infoNodeCA.FinalGatherPreview = _renderer.FinalGatherPreview
							
							this.infoNodeCA.FinalGatherTraceDepth = _renderer.FinalGatherTraceDepth
							this.infoNodeCA.FinalGatherReflectionDepth = _renderer.FinalGatherReflectionDepth
							this.infoNodeCA.FinalGatherRefractionDepth = _renderer.FinalGatherRefractionDepth
							this.infoNodeCA.FinalGatherFalloff = _renderer.FinalGatherFalloff
							this.infoNodeCA.FinalGatherFalloffStart = _renderer.FinalGatherFalloffStart
							this.infoNodeCA.FinalGatherFalloffStop = _renderer.FinalGatherFalloffStop
							
							this.infoNodeCA.FinalGatherUseRadiusInterpolation = _renderer.FinalGatherUseRadiusInterpolation
							this.infoNodeCA.FinalGatherView = _renderer.FinalGatherView
							this.infoNodeCA.UseFinalGatherRadius = _renderer.UseFinalGatherRadius
							this.infoNodeCA.UseFinalGatherMinRadius = _renderer.UseFinalGatherMinRadius
							this.infoNodeCA.FinalGatherRadius = _renderer.FinalGatherRadius
							this.infoNodeCA.FinalGatherMinRadius = _renderer.FinalGatherMinRadius
							this.infoNodeCA.FinalGatherRadius_View = _renderer.FinalGatherRadius_View
							this.infoNodeCA.FinalGatherMinRadius_View = _renderer.FinalGatherMinRadius_View
						)
						--MENTAL FINAL GATHER END
						------------------------------------------------

						-----------------------------------------------
						--MENTAL CAUSTICS
						(
							this.infoNodeCA.overrideMentalCaustics = true --override habilitado para el passTree, desactivar si es hijo

							this.infoNodeCA.CausticsEnable = _renderer.CausticsEnable
							this.infoNodeCA.CausticMultiplierScalar = _renderer.CausticMultiplierScalar
							this.infoNodeCA.CausticMultiplierColor = _renderer.CausticMultiplierColor
							this.infoNodeCA.CausticAccuracy = _renderer.CausticAccuracy
							this.infoNodeCA.UseCausticRadius = _renderer.UseCausticRadius
							this.infoNodeCA.CausticRadius = _renderer.CausticRadius
							this.infoNodeCA.CausticsFilter = _renderer.CausticsFilter
							this.infoNodeCA.Kernel = _renderer.Kernel
							this.infoNodeCA.CausticOpaqueShadows = _renderer.CausticOpaqueShadows
							
							this.infoNodeCA.GlobalIllumEnable = _renderer.GlobalIllumEnable
							this.infoNodeCA.GIMultiplierScalar = _renderer.GIMultiplierScalar
							this.infoNodeCA.GIMultiplierColor = _renderer.GIMultiplierColor
							this.infoNodeCA.GlobalIllumAccuracy = _renderer.GlobalIllumAccuracy
							this.infoNodeCA.UseGlobalIllumRadius = _renderer.UseGlobalIllumRadius
							this.infoNodeCA.GlobalIllumRadius = _renderer.GlobalIllumRadius
							this.infoNodeCA.UseGIPhotonMergeDistance = false
							this.infoNodeCA.GIPhotonMergeDistance = _renderer.GIPhotonMergeDistance
							this.infoNodeCA.OptimizeForFinalGather = false

							this.infoNodeCA.VolumeAccuracy = _renderer.VolumeAccuracy
							this.infoNodeCA.UseVolumeRadius = _renderer.UseVolumeRadius
							this.infoNodeCA.VolumeRadius = _renderer.VolumeRadius

							this.infoNodeCA.GIMaximumTraceDepth = _renderer.GIMaximumTraceDepth
							this.infoNodeCA.GIMaximumReflections = _renderer.GIMaximumReflections
							this.infoNodeCA.GIMaximumRefractions = _renderer.GIMaximumRefractions

							this.infoNodeCA.GlobalLightCausticPhotons = _renderer.GlobalLightCausticPhotons
							this.infoNodeCA.GlobalLightGIPhotons = _renderer.GlobalLightGIPhotons
							this.infoNodeCA.GlobalLightDecay = _renderer.GlobalLightDecay

							this.infoNodeCA.OverrideIIObjProps = _renderer.OverrideIIObjProps
						)
						--MENTAL CAUSTICS END
						-----------------------------------------------

						------------------------------------------------
						--MENTAL REUSE FINAL GATHER
						(
							this.infoNodeCA.overrideMentalReuseFG = true --override habilitado para el passTree, desactivar si es hijo

							this.infoNodeCA.IlluminationCacheMode = _renderer.IlluminationCacheMode 
							this.infoNodeCA.SkipFinalRender = _renderer.SkipFinalRender 
							
							this.infoNodeCA.UseFinalGatherFile = _renderer.UseFinalGatherFile 
							this.infoNodeCA.FinalGatherFreeze = _renderer.FinalGatherFreeze 
							this.infoNodeCA.FGInterpolateNFrames = _renderer.FGInterpolateNFrames 
							this.infoNodeCA.FinalGatherFilename = _renderer.FinalGatherFilename 
							this.infoNodeCA.FinalGatherTempFilename = _renderer.FinalGatherTempFilename 
								
							this.infoNodeCA.PhotonMapUseFile = _renderer.PhotonMapUseFile 
							this.infoNodeCA.PhotonFreeze = _renderer.PhotonFreeze 
							this.infoNodeCA.PhotonMapFilename = _renderer.PhotonMapFilename 
							this.infoNodeCA.FinalGatherOnly = _renderer.FinalGatherOnly 
							this.infoNodeCA.PhotonsOnly = _renderer.PhotonsOnly
						)
						--MENTAL REUSE FINAL GATHER END
						------------------------------------------------

						------------------------------------------------
						--MENTAL TRANSLATOR OPTIONS
						(
							this.infoNodeCA.overrideMentalTranslatorOptions = true --override habilitado para el passTree, desactivar si es hijo
						
							this.infoNodeCA.Use_Placeholders = _renderer.Use_Placeholders
							this.infoNodeCA.Conserve_Memory = _renderer.Conserve_Memory
							this.infoNodeCA.mental_ray_Manages_Maps = true
							--this.infoNodeCA.mental_ray_Manages_Maps = _renderer.mental_ray_Manages_Maps

							this.infoNodeCA.EnableGeometryCache = _renderer.EnableGeometryCache
							this.infoNodeCA.LockGeometryCache = _renderer.LockGeometryCache

							this.infoNodeCA.Enable_Material_Override = _renderer.Enable_Material_Override
							this.infoNodeCA.Override_Material = _renderer.Override_Material

							this.infoNodeCA.Skip_Texture_Maps = _renderer.Skip_Texture_Maps
						)
						--MENTAL TRANSLATOR OPTIONS END
						------------------------------------------------

						------------------------------------------------
						--ANCESTOR VALUES
						_parentContainer = this.getParentContainer()
						if _parentContainer != undefined do _parentContainer = _parentContainer.getParent()
						if _parentContainer != undefined and _parentContainer.getSubType() != #passTree do
						(
							_rendererArray = #()
							_parentContainer = _parentContainer.getParent() --Nos saltamos un nivel porque se habrá aplicado antes (en MENTAL RAY)
							while _parentContainer != undefined do --rellenar _rendererArray
							(
								_subType = _parentContainer.getSubType()
								if (_subType == #passGroup or _subType == #passTree) do
								(
									--obtiene el contenedor de overrides del padre
									_overridesNode = undefined
									for _ch in _parentContainer.getChildren() where _ch.getSubType() == #overrides do _overridesNode = _ch
									
									--si encuentra el contenedor de overrides
									if _overridesNode != undefined then
									(
										_overrides = _overridesNode.getOverrides() --obtiene los overrides
										for i = _overrides.count to 1 by -1 where _overrides[i].getSubType() == "rendererSettings" do
											insertItem _overrides[i].infoNode.custAttributes[#overrideRendererSettingsInfo] _rendererArray 1 --insertamos al principio para aplicarlos en orden
									)--if						

								)--if
								_parentContainer = _parentContainer.getParent()
							)--while _rendererArray relleno

							--_myProperties = getPropNames this.infoNodeCA
							for _renderer in _rendererArray do
							(
								for _propName in (getPropNames _renderer) where isProperty this.infoNodeCA _propName do
								(
									setProperty this.infoNodeCA _propName (getProperty _renderer _propName)
								)--for
							)--for
							--Deshabilitar overrides

							for _overrideEnable in #(	#overrideMentalSamplingQuality, #overrideMentalRenderingAlgorithms, #overrideMentalCameraEffects, #overrideMentalShadowsAndDisplacement,
														#overrideMentalGlobalTuningParams, #overrideMentalIBL, #overrideMentalFinalGather, #overrideMentalCaustics, #overrideMentalReuseFG,
														#overrideMentalTranslatorOptions) where isProperty this.infoNodeCA _overrideEnable do
							(
								setProperty this.infoNodeCA _overrideEnable false
							)
						)--if
						--ANCESTOR VALUES END
						------------------------------------------------

					--MENTAL RAY END
					------------------------------------------------

					------------------------------------------------
				)--if else			
				
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
		
	)--str_overrideRendererSettings
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideRendererSettings --añade el override al listado de overrides disponibles
	
	ok
)