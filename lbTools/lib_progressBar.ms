------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de progressBar
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de progressBar.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_progressBar
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria progress Bar",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
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

		---------------------------------------------------------------------------------------------------------------
		--genera el execute del rollout del progressbar con los parametros específicos para cada ejecucion y lo ejecuta
		---------------------------------------------------------------------------------------------------------------
		fn progressBarExecuteGeneration width:500 useCaptions:false captionsWidth:200 =
		(
			_caption = "                                                                                                                                                                                                                                                                               "
			
			rollProgressBarExecute = ""
			rollProgressBarExecute += "rollout rollProgressBar \"Untitled\"\n"
			rollProgressBarExecute += "(\n"
			rollProgressBarExecute += "	local opened = false\n"
			rollProgressBarExecute += "	label lblMain \"" + _caption + "\" pos:[" + ((width - (if useCaptions then captionsWidth else 0)) as string) + ",4] width:1500 visible:" + (useCaptions as string) + "\n"
			rollProgressBarExecute += "	label lblSecondary \"" + _caption + "\" pos:[" + ((width - (if useCaptions then captionsWidth else 0)) as string) + ",18] width:1500 visible:" + (useCaptions as string) + "\n"
			-- 		rollProgressBarExecute += "	label lblMain \"" + _caption + "\" pos:[" + ((width - (if useCaptions then captionsWidth else 0)) as string) + ",4] width:" + ((captionsWidth - 10) as string) + " visible:" + (useCaptions as string) + "\n"
			-- 		rollProgressBarExecute += "	label lblSecondary \"" + _caption + "\" pos:[" + ((width - (if useCaptions then captionsWidth else 0)) as string) + ",18] width:" + ((captionsWidth - 10) as string) + " visible:" + (useCaptions as string) + "\n"
			rollProgressBarExecute += "	progressBar pbMain \"\" pos:[5,5] width:" + ((width - 10 - (if useCaptions then captionsWidth else 0)) as string) + " height:10 color:(color 0 200 170)\n"
			rollProgressBarExecute += "	progressBar pbSecondary \"\" pos:[5,20] width:" + ((width - 10 - (if useCaptions then captionsWidth else 0)) as string) + " height:10 color:(color 0 200 170)\n"
			rollProgressBarExecute += "	on rollProgressBar open do\n"
			rollProgressBarExecute += "		opened = true\n"
			rollProgressBarExecute += "	on rollProgressBar close do\n"
			rollProgressBarExecute += "		opened = false\n"
			rollProgressBarExecute += ")"
			
			execute rollProgressBarExecute
		),

		---------------------------------------------------------------------------------------------------------------
		--abre el rollout de la barra de progreso
		--WIDTH: se le puede pasar un ancho
		--SHOWSECONDARYBAR: se puede mostrar una barra secundaria para subprocesos
		--MAINBARCOLOR: se le puede pasar el color de la barra
		--SECONDARYBARCOLOR: se le puede pasar el color de la barra secundaria
		---------------------------------------------------------------------------------------------------------------
		fn progressBarOpen width:500 mainBarColor:(color 0 87 197) secondaryBarColor:(color 0 87 197) showSecondaryBar:false useCaptions:false captionsWidth:200 =
		(
			_heightOffsetToAdd = 0
			if showSecondaryBar then _heightOffsetToAdd += 15
			
			try (destroyDialog rollProgressBar) catch() --lo elimina primero por si estuviera abierto
			progressBarExecuteGeneration width:width useCaptions:useCaptions captionsWidth:captionsWidth
			createDialog rollProgressBar width:(width) height:(20 + _heightOffsetToAdd) style:#(#style_border) --crea el dialogo
			
			--pone los colores de las barras
			rollProgressBar.pbMain.color = mainBarColor
			rollProgressBar.pbSecondary.color = secondaryBarColor
				
			ok
		),--progressBarOpen

		---------------------------------------------------------------------------------------------------------------
		--pone el valor que se quiera a la barra de progreso
		--VALUE: nuevo valor de 0 a 100
		--USESECONDARY: indica si usar la barra secundaria
		---------------------------------------------------------------------------------------------------------------
		fn setProgressBarValue value useSecondary:false =
		(
			if not rollProgressBar.opened then progressBarOpen showSecondaryBar:useSecondary
			
			if not useSecondary then --si hay que ponerlo en la principal
				rollProgressBar.pbMain.value = value --pone el valor a la barra
			else --si hay que ponerloen la secundaria
				rollProgressBar.pbSecondary.value = value --pone el valor a la barra
			
			ok
		),

		---------------------------------------------------------------------------------------------------------------
		--pone el valor que se quiera a la barra de progreso
		--CAPTION: nuevo valor de 0 a 100
		--USESECONDARY: indica si usar la barra secundaria
		---------------------------------------------------------------------------------------------------------------
		fn setProgressBarCaption caption useSecondary:false =
		(
			if not rollProgressBar.opened then progressBarOpen showSecondaryBar:useSecondary
			
			extraPoints = "..................................................."
			if not useSecondary then --si hay que ponerlo en la principal
				rollProgressBar.lblMain.text = caption + extraPoints --pone el texto al label
			else --si hay que ponerloen la secundaria
				rollProgressBar.lblSecondary.text = caption + extraPoints --pone el texto al label
			
			--como deja ocultas las barras de progreso por un bug de max
			-- 		rollProgressBar.pbMain.visible = false
			-- 		rollProgressBar.pbSecondary.visible = false
			-- 		
			-- 		rollProgressBar.pbMain.visible = true
			-- 		rollProgressBar.pbSecondary.visible = true
			
			ok
		),

		---------------------------------------------------------------------------------------------------------------
		--cierra el rollout de la barra de progreso
		---------------------------------------------------------------------------------------------------------------
		fn progressBarClose =
		(
			try (destroyDialog rollProgressBar) catch() --lo elimina
			
			ok
		),--progressBarClose
		
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
		--@event: create | Ejecución al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_progressBar
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_progressBar() --crea la libreria
)