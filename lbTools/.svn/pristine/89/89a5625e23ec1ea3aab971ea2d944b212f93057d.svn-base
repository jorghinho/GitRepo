------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta de setup de opciones para los previos.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Preview Setup" width:195 height:145
	(
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 195	--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 145	--@var: minRollHeight | Alto mínimo de la herramienta.
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
			
		checkbox chkIncludeSound "Include Sound" pos:[15,10] width:95 height:20 checked:true --@control | chkIncludeSound | Control para indicar que guarde sonido.
		checkbox chkOpenWhenFinished "Open when finished" pos:[15,35] width:145 height:20 checked:true --@control | chkOpenWhenFinished | Control para indicar que el video se abra al terminar.
		checkbox chkAutoNamePreviewFile "Auto name preview file" pos:[15,60] width:145 height:20 checked:true --@control | chkAutoNamePreviewFile | Control para indicar que se autorenombre el video.
		
		label lblRenderingLevel "Rendering Level" pos:[25,90] width:80 height:15 
		dropdownList ddlRenderingLevel "" pos:[110,85] width:80 height:21 items:#("Realistic", "Shaded") --@control | ddlRenderingLevel | Control para indicar que calidad de render de viewport usar.
		spinner spnSecondsPerFrame "Secons per frame" pos:[40,115] width:150 height:16 range:[0.0, 4.0, 1.5] --@control | spnSecondsPerFrame | Control para indicar el maximo de tiempo de calculo por frame.
		
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
		--@fn: undefined | updateControls | Actualiza el estado de los controles del interface.
		------------------------------------------------
		fn updateControls =
		(
			chkIncludeSound.checked = lb.preview.includeSound
			chkOpenWhenFinished.checked = lb.preview.openWhenFinished
			chkAutoNamePreviewFile.checked = lb.preview.autoNamePreviewFile
			
			_visualStyleIndex = 1
			for i = 1 to ddlRenderingLevel.items.count where ((toLower ddlRenderingLevel.items[i]) == toLower (lb.preview.visualStyle as string)) do _visualStyleIndex = i
						
			ddlRenderingLevel.selection = _visualStyleIndex
			spnSecondsPerFrame.value = (lb.preview.realisticStyleTPF / 1000.0)
			spnSecondsPerFrame.enabled = (ddlRenderingLevel.selected == "Realistic")
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
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
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMai/size") "height") as integer
				
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
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del control.
		--@control: chekbox | chkIncludeSound | El elemento que sufre el cambio de estado.
		--@gets: boolean | state | nuevo estado, activado o desactivado.
		------------------------------------------------
		on chkIncludeSound changed state do
			lb.preview.includeSound = state
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del control.
		--@control: chekbox | chkOpenWhenFinished | El elemento que sufre el cambio de estado.
		--@gets: boolean | state | nuevo estado, activado o desactivado.
		------------------------------------------------
		on chkOpenWhenFinished changed state do
			lb.preview.openWhenFinished = state
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del control.
		--@control: chekbox | chkAutoNamePreviewFile | El elemento que sufre el cambio de estado.
		--@gets: boolean | state | nuevo estado, activado o desactivado.
		------------------------------------------------
		on chkAutoNamePreviewFile changed state do
			lb.preview.autoNamePreviewFile = state
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar la seleccion en el control.
		--@control: dropdownlist | ddlRenderingLevel | El elemento que sufre el cambio de seleccion.
		--@gets: integer | index | Indice del nuevo elemento seleccionado.
		------------------------------------------------
		on ddlRenderingLevel selected index do
		(
			spnSecondsPerFrame.enabled = (ddlRenderingLevel.selected == "Realistic")
			lb.preview.visualStyle = (ddlRenderingLevel.selected as name)
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar valor del control.
		--@control: spinner | spnSecondsPerFrame | El elemento que sufre el cambio de valor.
		--@gets: float | val | nuevo valor del control.
		------------------------------------------------
		on spnSecondsPerFrame changed val do
			lb.preview.realisticStyleTPF = (val * 1000)
		
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
				
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			updateControls()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
		
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: tl_previewSetup | Contiene la herramienta de setup de opciones de videos de previo
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_previewSetup
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #video,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool plantilla",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
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
			--this.run()
		)
		
	)--tl_previewSetup
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EJECUCION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	--try(lb.previewSetup.close())catch()
	tl_previewSetup() --crea la herramienta
)

