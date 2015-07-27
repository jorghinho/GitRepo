------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta picker para layout.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Layout picker"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 382		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 168		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles
		GroupBox grpTool "Link objects to:" pos:[10,7] width:359 height:61
		dotNetControl objForLink "System.Windows.Forms.TextBox" pos:[22,32] width:149 height:25
		dotNetControl objToLink "System.Windows.Forms.TextBox" pos:[207,32] width:149 height:25
		label strTo "=>" pos:[181,36] width:23 height:15
		button linkToObj "Link to object" pos:[10,78] width:360 height:37 enabled:false
		button linkToWorld "Link to World" pos:[10,119] width:360 height:37 enabled:false
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@fn: undefined | selectObjects | Controla las acciones de la tool según el número de seleccion de objetos.
		------------------------------------------------
		fn selectObjects = 
		(
			-- Estado incial
			local s = getcurrentselection()
			objForLink.text = ""
			objToLink.text = ""

			-- si seleccionamos dos objetos.
			if s.count == 2 then 
			(
				objForLink.text = s[1].name
				objToLink.text = s[2].name
				linkToObj.enabled = true
				linkToWorld.enabled = false
				return s
			)
			
			-- si seleccionamos uno solo.
			if s.count == 1 then 
			(
				objForLink.text = s[1].name
				objToLink.text = "World"
				linkToObj.enabled = false
				linkToWorld.enabled = true
				return s
			)

			-- si deseleccionamos.
			else 
			(
				s = undefined
				objForLink.text = ""
				objToLink.text = ""
				linkToObj.enabled = false
				linkToWorld.enabled = false
				return false
			)
		)

		------------------------------------------------
		--@fn: undefined | hideObject | Crea keys para ocultar los objetos a través de la escala.
		--@gets: node | obj | Objeto que se va a escalar para ocultarlo.
		------------------------------------------------
		fn hideObject obj =
		(
			local f = slidertime
			local o = obj.scale.controller
			addnewkey o (f-1)
			addnewkey o f
			local k = o.keys
			k[k.count].value = [0,0,0]
		)

		------------------------------------------------
		--@fn: undefined | showObject | Crea keys para mostrar los objetos a través de la escala.
		--@gets: node | obj | Objeto que se va a escalar para mostrarlo.
		------------------------------------------------
		fn showObject obj =
		(
			if obj.scale.controller.keys.count != 0 do deleteKeys obj.scale.controller.keys #allKeys
			local f = slidertime
			local o = obj.scale.controller
			if f != 0 do addnewkey o 0
			addnewkey o (f-1)
			addnewkey o f
			local k = o.keys
			if f != 0 do k[k.count-2].value = [0,0,0]
			k[k.count-1].value = [0,0,0]
			k[k.count].value = [1,1,1]
		)

		------------------------------------------------
		--@fn: undefined | checklayer | Checkea si existe la capa que almacena los nuevos objetos creados con la tool y si no existe, la crea.
		------------------------------------------------
		fn checklayer =
		(
			if (LayerManager.getLayerFromName "_auxObj-PickObjects_") == undefined then 
			(
				local l = LayerManager.newLayerFromName "_auxObj-PickObjects_"
				l.current = true
				return l
			)
			else 
			(
				local l = LayerManager.getLayerFromName "_auxObj-PickObjects_"
				l.current = true
				return l
			)
		)
		
		------------------------------------------------
		--@fn: undefined | reNameObjectInPicker | Checkea si existe la capa que almacena los nuevos objetos creados con la tool y si no existe, la crea.
		--@gets: node | obj |Objeto que se va a renombrar.
		------------------------------------------------
		fn reNameObjectInPicker obj =
		(
			local oldN = obj.name
			local findN = findString oldN "_auxObj-PickObject_"
			if findN != undefined then 
			(
				st = filterstring oldN "_"
				obj.name = ("_auxObj-PickObject_" + st[2] + "_" + (slidertime) as string)
			)
			else
			(
				obj.name = ("_auxObj-PickObject_" + oldN + "_" + (slidertime) as string)
			)
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
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			------------------------------------------------
			-- Ejecuta la funcion selectObjects para cuando hay cambios de seleccion en la escena.
			-- Activa y desactiva los botones en funcion del numero e objetos seleccionados 
			callbacks.addscript #selectionSetChanged "lb.layoutPicker.rollmain.selectObjects()" id:#selectObjectToPicker
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			------------------------------------------------
			-- Elimina la funcion selectObjects para cuando hay cambios de seleccion en la escena.
			callbacks.removescripts id:#selectObjectToPicker
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
		on linkToObj pressed do
		(
			-- variables
			local l = checklayer() -- Checkea si existe la capa para guardar los objetos pickers y si no la crea.
			local s = getcurrentselection()
			local t = s[1].transform -- Guardamos la transformacion par asegurarnos que la nueva copia ésta donde tiene que estar.

			-- Creamos una copia con las propuedades el objeto, ocultamos el antiguo escalando a 0 y aparece el nuevo tambien con la escala. 
			-- Vinculamos donde corresponde y almacenamos en capa.
			copyObj = snapshot s[1] wirecolor:s[1].wirecolor
			reNameObjectInPicker copyObj
			hideObject s[1]
			copyObj.parent = s[2]
			showObject copyObj
			copyObj.transform = t
			select copyObj
			l.addNode copyObj
			print (">>" + s[1].name + " link to >>" + s[2].name)
		)
		
		on linkToWorld pressed do
		(
			-- variables
			local l = checklayer()
			local s = getcurrentselection()
			local t = s[1].transform

			-- Creamos una copia con las propuedades el objeto, ocultamos el antiguo escalando a 0 y aparece el nuevo tambien con la escala. 
			-- No vinculamos en este caso, almacenamos en capa.
			copyObj = snapshot s[1] wirecolor:s[1].wirecolor
			reNameObjectInPicker copyObj
			hideObject s[1]
			showObject copyObj
			copyObj.parent = undefined
			copyObj.transform = t
			l.addNode copyObj
			clearselection()
			print (">>" + s[1].name + " link to World")
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
	--@struct: layoutPickerTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_layoutPicker
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
		
	)--tl_layoutPickerTool
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_layoutPicker() --crea la herramienta
)