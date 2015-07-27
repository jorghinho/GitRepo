------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Root Circle"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 205	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 110	--@var: minRollHeight | Minimun tool height.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local rootCtrl = undefined
		local nodeRoot = undefined
		local rad = undefined
		local iconpath = if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/"		-- ruta de los iconos de Max.		

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label lblRootCircle "<--- click to create root circle" pos:[40,5] width:180
		checkButton chkCreateRootCtrl "" pos:[5,5] width:30 height:30 toolTip:"Create root circle" images:#(iconpath + "Splines_24i.bmp",undefined,11,2,2,2,2,true)
		
		label lblRadius "Rad" pos:[50,45]
		spinner spnRadius "" pos:[5,45] width:40 height:15 range:[1,100,1] enabled:false
		-- 		
		label lblThickness "Thickness" pos:[50,65]
		spinner spnThickness "" pos:[5,65] width:40 height:15 range:[0,100,0] enabled:false
		-- 		
		spinner spnRotY "Rot Y" pos:[185,25] width:50 height:15 range:[-180,180,0] enabled:false scale:0.1
		spinner spnPosY "Pos Y" pos:[185,45] width:50 height:15 range:[-100,100,0] enabled:false
		spinner spnPosZ "Pos Z" pos:[185,65] width:50 height:15 range:[-100,100,0] enabled:false
		-- 		
		button btnApply "Apply" pos:[5,85] width:230 height:20 toolTip:"Attach circle to root" enabled:false
		
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
		--@fn: undefined | getAssetChrRootNode | obtiene de asset de tipo chr, la pieza root
		------------------------------------------------	
		fn getAssetChrRootNode asset =
		(
			nodeRoot = undefined
			
			if asset != undefined then
			(
				assetFullName = asset.fullName
				nodeRoot = (execute ("$'" + assetFullName + "_" + lb.nc.NC_classAnim + "_*_root_*_*'"))[1]		
			)
			
			nodeRoot 						
		)

		------------------------------------------------
		--@fn: undefined | getRadiusBoundBox | obtiene el radio en base al bounding box del root, calcula la distancia entre. dos puntos del bounding y lo divide entre 2 para sacar el radio.
		------------------------------------------------		
		fn getRadiusBoundBox obj =
		(
			rad = 20.0
			
			if isValidNode obj then
			(	
				bb = nodeLocalBoundingBox obj
				auxP = [bb[1].x, bb[1].y, bb[2].z]
				
				rad = (distance auxP bb[2])/2
			)				
			
			rad
		)

		------------------------------------------------
		--@fn: undefined | createRootCtrl | crea el control del root alineado con el root (rig)
		------------------------------------------------		
		fn createRootCtrl =
		(
				ast = (lb.asset.getSceneAssets type:#Chr)[1]
			
				nodeRoot = getAssetChrRootNode ast
				
				rad = getRadiusBoundBox nodeRoot
					
 				if isValidNode nodeRoot then
				(		
					nameParts = filterString nodeRoot.name "_"
					rootCtrlName = "<<" + nameParts[1] + "_" + nameParts[2] + "_tempCircleRoot>>"
					
					rootCtrl = execute ("$'" + rootCtrlName + "'")
					
					if not isValidNode rootCtrl then
						rootCtrl = circle render_displayRenderMesh: true radius:rad steps:1 render_sides: 3 thickness:2.5 wirecolor:[0,255,255]
					
					if classof rootCtrl == Circle then
					(
						spnRadius.value = rad
						spnThickness.value = 2.5
					)
					
					rootCtrl.transform = nodeRoot.transform
					rootCtrl.pos.y = 0
					
					rootCtrl.name = rootCtrlName
					
					lblRootCircle.caption = rootCtrl.name
				)
		)

		------------------------------------------------
		--@fn: undefined | attachRoot | funcion para atachar el control del root nuevo creado a la pieza de root obtenida, en modo subobjeto
		------------------------------------------------				
		fn attachRoot =
		(
			select nodeRoot 
			
			max modify mode
			
			-- variable para comprobar si tiene el mod puppet
			_found = false
			
			--recorremos los modificadores para comprobar si ya tiene el mod puppet
			for m in nodeRoot.modifiers where classOf m == edit_Poly do
			(	
				if m.name == "Puppet" then
					_found = true
			)
			
			-- si lo encuentra atacha el root, sino lo encuentra añade un mod puppet y lo atacha.
			if _found then
			(
				modpanel.setCurrentObject nodeRoot.modifiers[#Puppet]
				nodeRoot.modifiers[#Puppet].Attach rootCtrl editPolyNode:nodeRoot
			)
			else
			(
				--creamos una edit poly y le cambiamos el nombre al final
				poly = edit_poly()							
				poly.name = "Puppet"
					
				addModifier nodeRoot poly before:nodeRoot.modifiers.count	
				
				modpanel.setCurrentObject nodeRoot.modifiers[#Puppet]
				nodeRoot.modifiers[#Puppet].Attach rootCtrl editPolyNode:nodeRoot
			)
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
		--COMMON
		------------------------------------------------

		------------------------------------------------
		--@event: changed | crea el control de root, y activa todos los operadores para trabjar con ellos.
		------------------------------------------------
		on chkCreateRootCtrl changed state do
		(
			-- Activado el checkbutton entra en modo de edicion para crear el root,
			-- y habilita opciones de ui, al salir se borra para evitar dejar objetos perdidos.
			
			if state then
			(
				createRootCtrl()
				completeRedraw() -- actualiza el viewport por fallo de redibujadp.
				if isValidNode rootCtrl  then
				(
					spnPosY.enabled = true
					spnPosZ.enabled = true
					spnRotY.enabled = true
					spnThickness.enabled = true
					spnRadius.enabled = true
					btnApply.enabled = true
				)
			)
			else
			(
				if isValidNode rootCtrl  then
				(
					delete rootCtrl
					
					spnPosY.enabled = false
					spnPosZ.enabled = false
					spnRotY.enabled = false
					spnThickness.enabled = false
					spnRadius.enabled = false
					btnApply.enabled = false
					lblRootCircle.caption = "<- click to create root circle"
				)
			)--else		
		)

		------------------------------------------------
		--@event: changed | manipula la posicion en PosY del objeto
		------------------------------------------------		
		on spnPosY changed val do
		(
			if isValidNode rootCtrl  then
				rootCtrl.position.y = val
		)	
			
		------------------------------------------------
		--@event: changed | manipula la posicion en Posx del objeto
		------------------------------------------------				
		on spnPosZ changed val do
		(
			if isValidNode rootCtrl then
				rootCtrl.position.Z = nodeRoot.pos.z + val
		)

		------------------------------------------------
		--@event: changed | manipula el radio del objeto
		------------------------------------------------	
		on spnRadius changed val do
		(
			if isValidNode rootCtrl then
				rootCtrl.radius = val
		)

		------------------------------------------------
		--@event: changed | manipula el grosor del objeto
		------------------------------------------------
		on spnThickness changed val do
		(	
			if isValidNode rootCtrl then
				rootCtrl.thickness = val
		)

		------------------------------------------------
		--@event: changed | manipula la rotacion en RotY del objeto
		------------------------------------------------
		on spnRotY changed val do
		(
			if isValidNode rootCtrl then
				in coordsys gimbal rootCtrl.rotation.Y = val
		)

		------------------------------------------------
		--@event: pressed | atacha al root y confirma las modificaciones echas anteriormente, descastiva tambien todos los parametros del rollout y resetea los valores 
		------------------------------------------------
		on btnApply pressed do
		(
			disableSceneRedraw()
			attachRoot()
			if not isValidNode rootCtrl  then
			(
				chkCreateRootCtrl.checked = false
				
				spnPosY.enabled = false
				spnPosZ.enabled = false
				spnRotY.enabled = false
				spnThickness.enabled = false
				spnRadius.enabled = false
				btnApply.enabled = false
				spnthickness.value = 0
				spnPosY.value = 0
				spnPosZ.value = 0
				spnRotY.value = 0
				spnRadius.value = 0
				lblRootCircle.caption = "<- click to create root circle"
			)
			enableSceneRedraw()
		)	

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
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_rootCircle
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Root Circle",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_rootCircle
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_rootCircle() --crea la herramienta
)