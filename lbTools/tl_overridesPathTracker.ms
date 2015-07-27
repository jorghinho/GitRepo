------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Overrides Path Tracker. Muestra un resumen de todas las rutas que
-- hay en la herramienta.Se aplica a los siguientes overrides:
-- RendererOverride/mental_ray_render/global illumination/reuse/Final Gather Map
-- -- RendererOverride/mental_ray_render/global illumination/reuse/Caustics
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta presetInfoManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Overrides Path Tracker"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 800		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 300		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local disabledColor = (dotNetClass "System.Drawing.Color").fromArgb 255 100 100 100
		local backColor = (dotNetClass "System.Drawing.Color").fromArgb 255 50 50 50
		local backColorLight = (dotNetClass "System.Drawing.Color").fromArgb 255 40 40 40
		local foreColor = (dotNetClass "System.Drawing.Color").fromArgb 255 200 200 200

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		dotNetControl lvInfo "System.Windows.Forms.ListView" pos:[0,0] width:800 height:300

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
		struct pathStruct
		(
			override = undefined,
			breadcrumb = ""
		)


		fn initInfoListView =
		(
			--Settings del listview
			lv = lvInfo
			lv.columns.clear()
			lv.multiSelect = false
			lv.gridLines = false
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").None
			lv.fullRowSelect = true
			lv.backColor = backColor
			lv.foreColor = foreColor
			lv.scrollable = true
			lv.labelEdit = false

			--800 sin scroll
			lv.columns.add "Override" 300
			lv.columns.add "Type" 190
			lv.columns.add "Path" 310

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		
		fn fillInfoListView = 
		(
			_overrides = #()

			for _passTree in parent.passTrees do
				_overrides += lb.overrides.getOverridesByType _passTree #("rendererSettings","outputPath")
			_counter = 0
			for _ov in _overrides do
			(
				case _ov.customOverride.getSubType() of
				(
					"rendererSettings":
					(
						if _ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].currentRenderer == "mental_ray_renderer" then
						(
							--FinalGatherFile
							lvInfo.items.add (_ov.getTrace separator:" -> ")
							lvInfo.items.item[_counter].SubItems.add (_ov.customOverride.getSubType() + " -> " + "FinalGatherFile")
							lvInfo.items.item[_counter].SubItems.add (_ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].FinalGatherFilename)
							
							if (not _ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].overrideMentalReuseFG) or (not _ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].UseFinalGatherFile) then
							(
								for i=0 to (lvInfo.items.item[_counter].SubItems.Count - 1) do
								(
									lvInfo.items.item[_counter].SubItems.item[i].foreColor = disabledColor
								)
							)
							else
							(
								for i=0 to (lvInfo.items.item[_counter].SubItems.Count - 1) do
								(
									lvInfo.items.item[_counter].SubItems.item[i].foreColor = foreColor
								)
							)
							_counter += 1

							--PhotoMapFile
							lvInfo.items.add (_ov.getTrace separator:" -> ")
							lvInfo.items.item[_counter].SubItems.add (_ov.customOverride.getSubType() + " -> " + "PhotonMapFile")
							lvInfo.items.item[_counter].SubItems.add (_ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].PhotonMapFilename)
							
							if (not _ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].overrideMentalReuseFG) or (not _ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].PhotonMapUseFile) then
							(
								for i=0 to (lvInfo.items.item[_counter].SubItems.Count - 1) do
								(
									lvInfo.items.item[_counter].SubItems.item[i].foreColor = disabledColor
								)
							)
							else
							(
								for i=0 to (lvInfo.items.item[_counter].SubItems.Count - 1) do
								(
									lvInfo.items.item[_counter].SubItems.item[i].foreColor = foreColor
								)
							)
							_counter += 1

							--Rutas de SHADOWS (Shadow Map file)
							lvInfo.items.add (_ov.getTrace separator:" -> ")
							lvInfo.items.item[_counter].SubItems.add (_ov.customOverride.getSubType() + " -> " + "ShadowMapFile")
							lvInfo.items.item[_counter].SubItems.add (_ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].ShadowMapFilename)
									
							if (not _ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].overrideMentalShadowsAndDisplacement) or (not _ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].UseShadowMapFile) or (not _ov.customOverride.infoNode.custAttributes[#overrideRendererSettingsInfo].ShadowsEnable)then
							(
								for i=0 to (lvInfo.items.item[_counter].SubItems.Count - 1) do
								(
									lvInfo.items.item[_counter].SubItems.item[i].foreColor = disabledColor
								)
							)
							else
							(
								for i=0 to (lvInfo.items.item[_counter].SubItems.Count - 1) do
								(
									lvInfo.items.item[_counter].SubItems.item[i].foreColor = foreColor
								)
							)
							_counter += 1
						)
						
					)
					"outputPath":
					(
						lvInfo.items.add (_ov.getTrace separator:" -> ")
						lvInfo.items.item[_counter].SubItems.add (_ov.customOverride.getSubType())
						lvInfo.items.item[_counter].SubItems.add (_ov.customOverride.infoNode.custAttributes[#overrideOutputPathInfo].outputPath)
						_counter += 1
					)
				)--case
			)--for
			
			--Repintar fondos por fila
			for i=0 to lvInfo.Items.Count-1 do
			(
				if (mod i 2) == 0 then
					lvInfo.items.item[i].backColor = backColor
				else
					lvInfo.items.item[i].backColor = backColorLight
			)

		)

		

		fn resetUI = 
		(
			fillInfoListView()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				grpPresetFile.width = _increment.x + 800	
				
				lvInfo.width = _increment.x + 800

				if lvInfo.columns.count != 0 then lvInfo.Columns.Item[0].width = _increment.x + 300
				
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				lvInfo.height = _increment.y + 300
			)--if
			------------------------------------------------------------------------------
		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		on lvInfo mouseUp events do
		(
				
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks

			initInfoListView()

			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			resetUI()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()

			--parent.updateRelatedTools()

			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: overridesPathTracker | Contiene la herramienta overridesPathTracker.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_overridesPathTracker
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Preset Info Manager",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
		
		parent = undefined, 	--@var: parent | Almacena la herramienta padre, en este caso passManagerUI
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		presetFile = "",
		passTrees = undefined,
		--presetFile = @"Y:\asset\chr\main\chr_mike\version\preset\chr_mike{clown-std}_mesh_v01.prt",	
		--presetFile = @"Y:\asset\chr\main\chr_mike\version\preset\chr_mike{std-std}_anim_v01.prt",
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollMain | Almacena el rollout principal de la herramienta.
			
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
		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
		------------------------------------------------
		fn isOpen =
		(
			this.opened
		),
		
		------------------------------------------------
		--@fn: undefined | refreshInterface | Refresca el interface inicial de la herramienta
		------------------------------------------------
		fn refreshInterface =
		(
			--refresca el interface de la herramienta
		),
		
		------------------------------------------------
		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
		------------------------------------------------
		fn createInterface =
		(

			--crea el interface, lo redimensiona y lo reposiciona
			createDialog this.rollMain lockwidth:false lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
		------------------------------------------------
		fn destroyInterface =
		(
			destroyDialog this.rollMain --cierra la herramienta.			
		),--destroyInterface
		
		------------------------------------------------
		--@fn: undefined | run | Lanza la herramienta.
		------------------------------------------------
		fn run passTrees:undefined =
		(
			this.passTrees = passTrees
			this.parent = (lb.getTool "passManagerUI")
			
			this.createInterface() --crea el interface.
			this.opened = true --indica que la herramienta está abierta
		),--execute
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
		------------------------------------------------
		fn close =
		(
			this.destroyInterface() --destruye el interface.
			this.opened = false --indica que la herramienta está cerrada.
		),
		
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
		--@event: create | Ejecución al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addTool this --añade la tool a la libreria principal	
		)		
		
	)--tl_presetInfoManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_overridesPathTracker() --crea la herramienta
)