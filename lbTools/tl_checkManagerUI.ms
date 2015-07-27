------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Vista de la herramienta Check Manager	
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollCheckManagerUI | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollCheckManagerUI "Check Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 550	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 810	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local opening = false --@var: opening | Flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		label lblTabRowSeparation "_____________________________________________________________________________________________________________" enabled:false pos:[0,14] width:550 height:21
		dotNetControl tbTabs "DevExpress.XtraTab.XtraTabControl" pos:[0,5] width:550 height:21 --25
		
		label lblSubTabRowSeparation "_____________________________________________________________________________________________________________" enabled:false pos:[0,37] width:550 height:21
		dotNetControl tbSubTabs "DevExpress.XtraTab.XtraTabControl" pos:[0,28] width:550 height:21 --25
	
		------------------------------------------------------------------------------------------------
		--SUBROLLOUTS
		------------------------------------------------------------------------------------------------


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
			tbTabs.paintstylename = "PropertyView"
			tbTabs.borderStyle = (dotnetclass "DevExpress.XtraEditors.Controls.BorderStyles").noBorder
			tbTabs.TabPageWidth = 100			
			
			tbTabs.Appearance.BackColor = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbTabs.Appearance.BackColor2 = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbTabs.Appearance.BorderColor = (dotnetclass "system.drawing.color").fromArgb 100 100 100
			
			--Ponemos los subtabs con las mismas propiedades que los tabs (color, ancho, borde, etc)
			tbSubTabs.paintstylename = "PropertyView"
			tbSubTabs.borderStyle = (dotnetclass "DevExpress.XtraEditors.Controls.BorderStyles").noBorder
			tbSubTabs.TabPageWidth = 100		
			
			tbSubTabs.Appearance.BackColor = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbSubTabs.Appearance.BackColor2 = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbSubTabs.Appearance.BorderColor = (dotnetclass "system.drawing.color").fromArgb 100 100 100
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
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
			rollCheckManagerUI.width = _width
			rollCheckManagerUI.height = _height
			setDialogPos rollCheckManagerUI [_posX,_posY]

			--aplica el tab seleccionado
			parent.selectedTabIndex = (lb.xml.getAttribute parent.cfgFile "rollMain/options" "selectedTabIndex") as integer
			if parent.selectedTabIndex == 0 then parent.selectedTabIndex = 1
		)
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollCheckManagerUI).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollCheckManagerUI).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollCheckManagerUI.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollCheckManagerUI.height as string)

			--almacena las opciones de UI
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "selectedTabIndex" (parent.selectedTabIndex as string)
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
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si el tamaño es menor que el minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollCheckManagerUI.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollCheckManagerUI.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento de tamaño
			_increment = [size.x - minRollWidth, size.y - minRollHeight]

			------------------------------------------------------------------------------
			--redimension en horizonal
			if _increment.x != 0 then --si hay incremento
			(	
				--Tabs de categoría
				tbTabs.width = 550 + _increment.x
				if tbTabs.tabPages.count != 0 then tbTabs.TabPageWidth = (minRollWidth + _increment.x)/(tbTabs.tabPages.count) - 17
				
				--Tabs de subcategoría
				tbSubTabs.width = 550 + _increment.x
				if tbSubTabs.tabPages.count != 0 then tbSubTabs.TabPageWidth = (minRollWidth + _increment.x)/(tbSubTabs.tabPages.count) - 17
			)--if
			------------------------------------------------------------------------------

			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
			)--if
			------------------------------------------------------------------------------

		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: selectedPageChanged | Evento que se lanza al cambiar de tab.
		--@control: DevExpress.XtraTab.XtraTabControl | tbTabs | Tabs.
		--@gets: event | events | Objeto devuelto por el evento.
		------------------------------------------------
		on tbTabs selectedPageChanged events do
		(
			if not opening then
			(
				parent.selectedTabIndex = tbTabs.selectedTabPageIndex + 1
				--Reseteamos los subtabs y ponemos los del actual
				parent.selectedSubtabIndex = 1
				parent.addSubTabs()
			)--if
		)
		
		------------------------------------------------
		--@event: selectedPageChanged | Evento que se lanza al cambiar de tab.
		--@control: DevExpress.XtraTab.XtraTabControl | tbTabs | Tabs.
		--@gets: event | events | Objeto devuelto por el evento.
		------------------------------------------------
		on tbSubTabs selectedPageChanged events do
		(
			if not opening then
			(
				
			)--if
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollCheckManagerUI | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollCheckManagerUI resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollCheckManagerUI | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollCheckManagerUI open do
		(
			opening = true --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg

			initUI() --inicializa el UI
			loadSettings()
			parent.fillTabsRolloutsDefs()
			parent.addTabs()
			createSceneEvents()		
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			opening = false --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollCheckManagerUI | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollCheckManagerUI close do
		(				
			removeSceneEvents()
			saveSettings()

			parent.opened = false
			updateToolbarButtons()		
		)	
	)--rollCheckManagerUI

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: tl_checkManagerUI | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_checkManagerUI
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool plantilla",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
		
		minWidth = 550,		--@var: minWidth | Ancho mínimo de la herramienta.
		minHeight = 810,		--@var: minHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		tabForeColor = (dotnetclass "system.drawing.color").fromArgb 189 189 189,
		tabBorderColor = (dotnetclass "system.drawing.color").fromArgb 30 30 30,
		tabBackColor = (dotnetclass "system.drawing.color").fromArgb 60 60 60,
		tabBackColorActive = (dotnetclass "system.drawing.color").fromArgb 60 130 220,
		tabBackColor2 = (dotnetclass "system.drawing.color").fromArgb 55 55 55,
		tabBackColorActive2 = (dotnetclass "system.drawing.color").fromArgb 60 60 60,		

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------

		
		rollMain = rollCheckManagerUI,	--@var: rollMain | Main tool rollout.
		
		--estos arrays se rellenan en la funcion fillTabsRolloutsDefs, que se llama al abrir la herramienta.
		--esto es solo la defincion de las variables y una ejemplo de estructura que luego se sobrescribe.
		tabNames = #(), --@var: tambNames | Nombres de los tabs.
		subTabNames = #(), --@var: subTabNames | Nombres de los tabs de las subcategorías. 

		selectedTabIndex = 1, --@var: selectedTabIndex | Tab seleccionado. Para usar al abrir y cerrar la herramienta
		selectedSubTabIndex = 1, --@var: selectedSubTabIndex | SubTab seleccionado. Para usar al abrir y cerrar la herramienta

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
		--@fn: undefined | updateTabsColor | Actualiza el color de los tabs.
		------------------------------------------------
		fn updateTabsColor =
		(
			--actualiza los tabs
			for i=1 to this.tabNames.count do
			(
				--configura los colores de los tabs
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.ForeColor = this.tabForeColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BackColor = this.tabBackColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BackColor2 = this.tabBackColor2
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BorderColor = this.tabBorderColor
				
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 8
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.ForeColor = this.tabForeColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor = this.tabBackColorActive
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor2 = this.tabBackColorActive2
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BorderColor = this.tabBorderColor
			)--for
			
			--- Y los subtabs
			for i=1 to this.subTabNames[this.selectedTabIndex].count do
			(
				--configura los colores de los tabs
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.Header.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.Header.ForeColor = this.tabForeColor
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.Header.BackColor = this.tabBackColor
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.Header.BackColor2 = this.tabBackColor2
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.Header.BorderColor = this.tabBorderColor
				
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.HeaderActive.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 8
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.HeaderActive.ForeColor = this.tabForeColor
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor = this.tabBackColorActive
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor2 = this.tabBackColorActive2
				this.rollMain.tbSubTabs.tabPages.item[i-1].Appearance.HeaderActive.BorderColor = this.tabBorderColor
			)--for
		),

		------------------------------------------------
		--@fn: undefined | fillTabsRolloutsDefs | Añade los tabs y las definiciones de los rollouts a los arrays correspondientes para que la herremienta sepa donde están.
		------------------------------------------------
		fn fillTabsRolloutsDefs =
		(
			this.tabNames = #("Tab1", "Tab2", "Tab3","Tab4")
			this.subTabNames = #(#("Tab1_1","Tab1_2","Tab1_3"),#("Tab2_1","Tab2_2","Tab2_3","Tab2_4","Tab2_5"),#("Tab3_1","Tab3_2","Tab3_3"),#("Tab4_1"))
		),
		
		
		
		------------------------------------------------
		--@fn: undefined | addSubTabs | Añade los tabs.
		------------------------------------------------
		fn addSubTabs =
		(
			--quitamos los subtabs actuales
			this.rollMain.tbSubTabs.tabPages.clear()
			
			--añadimos los subtabs con las subcategorías que correspondan.
			for i=1 to this.subTabNames[this.selectedTabIndex].count do
				this.rollMain.tbSubTabs.tabPages.add this.subTabNames[this.selectedTabIndex][i]
			
			if this.rollMain.tbSubTabs.tabPages.count != 0 then this.rollMain.tbSubTabs.TabPageWidth = (this.rollMain.width)/ (this.rollMain.tbSubTabs.tabPages.count) - 17
			
			this.updateTabsColor() --actualiza los colores de los tabs
		),
		
		------------------------------------------------
		--@fn: undefined | addTabs | Añade los tabs.
		------------------------------------------------
		fn addTabs =
		(
			--elimina los tabs actuales
			this.rollMain.tbTabs.tabPages.clear()

			--añade los tabs
			for i=1 to this.tabNames.count do
				this.rollMain.tbTabs.tabPages.add this.tabNames[i] --añade el tab
			
			if this.rollMain.tbTabs.tabPages.count != 0 then this.rollMain.tbTabs.TabPageWidth = (this.rollMain.width)/(this.rollMain.tbTabs.tabPages.count) - 17

			--selecciona el tab que estaba seleccionado la ultima vez que se abrio el override
			if this.rollMain.tbTabs.tabPages.count >= this.selectedTabIndex then
				this.rollMain.tbTabs.SelectedTabPage = this.rollMain.tbTabs.tabPages.item[this.selectedTabIndex - 1]
			
			this.addSubTabs()	--agrega los subtabs
			
			this.updateTabsColor() --actualiza los colores de los tabs
		),


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
		fn run =
		(
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
		
	)--tl_checkManagerUI

	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_checkManagerUI() --crea la herramienta
)