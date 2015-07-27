------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Herramienta para el bakeo de animaciones, bakeAnimation.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la interfaz de la herramienta bakeAnimation.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Bake Animation"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 220															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 45															--@var: integer | minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnBakeAnimation "Bake Animation" pos:[10,10] width:95 height:25
		button btnClearBake "Clear Bake" pos:[115,10] width:95 height:25
		
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
		--@fn: undefined | bakeAnimation | vuelca la animacion de cualquier objeto seleccionado, creando un point alineandolo al nodo por cada fotograma y creandole clave para luego copiar la transformacion del mismo point y pegarsela a la pieza. Necesita que se le pase NODES como objeto para operar. Tiene como valores opcionales starFrame y endFrame, por defecto coge el rango de animacion actual.
		--@gets: array{nodes} | nodes | los elementos a los que se le quiere realizar el bakeo.
		--@gets: (opt)time | startFrame | frame de la animación donde se inicia el proceso de bakeo. Por defecto **animationRange.start**
		--@gets: (opt)time | endFrame | frame de la animación donde finaliza el proceso de bakeo. Por defecto **animationRange.end**
		------------------------------------------------			
		fn bakeAnimation nodes startFrame:animationRange.start  endFrame:animationRange.end  =
		(			
			--recorremos los nodos seleccionados
			for i = 1 to nodes.count do 
			(
				pointAnim = point name:"pointBakeAnimation"
				
				--recorremos el rango de animacion y creamos un point por cada objeto y lo alineamos
				--para guardar la animacion de simulacion
				for t in startFrame to endFrame do
					at time t
						with animate on
							pointAnim.transform = nodes[i].transform--backup de la animacion de reactor

				--Desemparentamos las piezas de su padre para que no tenga dependencias.
				nodes[i].parent = undefined	
				
				-- Le copiamos la matriz entera del point auxiliar al nodo. 		
				nodes[i].transform.controller = copy pointAnim.transform.controller
			
				--borramos el points generados
				delete pointAnim
				
				-- Calculo para la barra de progreso				
				lb.progressBar.setProgressBarValue ((100.0/nodes.count)*i)
			)--for
			lb.progressBar.progressBarClose()	
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

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el botón.
		--@control: button | btnBakeAnimation | Vuelca la animacion de las piezas seleccionadas. 
		------------------------------------------------
		on btnBakeAnimation pressed do
		(
			-- Condicion para evitar que intente operar si no hay nada seleccionado.
			if  (getCurrentSelection()).count != 0 then
			(
				lb.progressBar.progressBarOpen() --showSecondaryBar:true	
				
				bakeAnimation (getCurrentSelection())
					
				lb.progressBar.progressBarClose()		
			)--if
		)	

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el botón.
		--@control: button | btnBakeAnimation | Borra la animacion de los objetos.
		------------------------------------------------		
		on btnClearBake pressed do
		(
			nodes = (getCurrentSelection())
			-- Condicion para evitar que intente operar si no hay nada seleccionado.
			if  nodes.count != 0 then
			(
				lb.progressBar.progressBarOpen()
				
				for i = 1 to nodes.count do
				(
					deleteKeys nodes[i].transform.controller
					lb.progressBar.setProgressBarValue ((100.0/nodes.count)*i)
				)
				
				lb.progressBar.progressBarClose()
			)--if
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
			updateToolbarButtons()
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_bakeAnimation
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),														--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),											--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,															--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),			--@var: string | className | Nombre de la tool.
		description = "bakeAnimation",												--@var: string | description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string | cfgFile | Archivo de configuracion de la tool.
			
		opened = false,																--@var: boolean | opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,														--@var: rollout | rollMain | Almacena el rollout principal de la herramienta.
			
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
		--@returns: boolean | undefined | Devuelve **TRUE** si la herramienta se encuentra abierta.
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
			createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_bakeAnimation
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_bakeAnimation() --crea la herramienta
)