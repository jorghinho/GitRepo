------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta mirrorMorphTargets.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	struct str_cPoint (iIndex, pPoints, pWeights)

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta mirrorMorphTargets.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Mirror Morph Targets"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 294		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 365		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		GroupBox grpMesh "Original Mesh" pos:[4,0] width:284 height:56
		pickbutton btnPickOrig "Pick Original" pos:[10,14] width:274 height:16-- filter:PolyFilter
		spinner spnError "" pos:[97,35] width:45 height:16 range:[0,100,0.1]
		label lblError "Error Threshold:" pos:[21,36] width:77 height:13
		spinner spnThres "" pos:[223,35] width:45 height:16 enabled:false range:[0,100,0]
		label lblThres "Threshold:" pos:[172,36] width:51 height:13
		
		GroupBox grpSymm "Symmetry" pos:[167,81] width:120 height:216
		
		GroupBox grpAxis "Axis" pos:[172,95] width:110 height:59
		radiobuttons rdoAxis "" pos:[177,113] width:97 height:16 labels:#("X", "Y", "Z") columns:3
		spinner spnOffset "" pos:[212,133] width:45 height:16 enabled:false range:[0,100,0]
		label lblOffset "Offset:" pos:[179,134] width:32 height:13
		GroupBox grpShow "Show" pos:[172,155] width:110 height:119
		checkbutton btnShowPts "Points" pos:[178,170] width:99 height:16 enabled:false
		GroupBox grpTargets "Morph Targets" pos:[4,56] width:157 height:283
		listbox lstNodes "" pos:[9,70] width:146 height:18
		pickbutton btnPick "Pick" pos:[9,316] width:44 height:16 enabled:false-- filter:PolyFilter
		button btnAdd "Add" pos:[57,316] width:37 height:16 enabled:false
		button btnRemove "Remove" pos:[98,316] width:58 height:16 enabled:false
		
		button btnGo "Go" pos:[7,344] width:47 height:16
		button btnMap "Map Vertices" pos:[172,278] width:110 height:16 enabled:false
		button btnReset "Reset XForm" pos:[172,63] width:108 height:16
		progressBar pbProgress "" pos:[178,189] width:99 height:11 orient:#horizontal
		progressBar pbKeyFoundB "" pos:[181,215] width:14 height:14 value:100 color:(color 0 0 255)
		progressBar pbKeyFoundG "" pos:[181,233] width:14 height:14 value:100 color:(color 0 255 0)
		progressBar pbKeyFoundY "" pos:[181,251] width:14 height:14 value:100 color:(color 255 0 0)
		
		label lblB "Matched (left)" pos:[199,215] width:68 height:14
		label lblG "Matched (right)" pos:[199,233] width:74 height:14
		label lblL "Unmatched" pos:[199,251] width:57 height:14
		groupBox grpKey "Key" pos:[177,200] width:99 height:69
		
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

		fn startDraw =
		(
			if (lb.mirrorMorphTargets.srcObj != undefined) then
				lb.mirrorMorphTargets.drawPoints lb.mirrorMorphTargets.srcObj.transform
		)
		
		fn refreshList =
		(
			dstNames = for dst in lb.mirrorMorphTargets.dstObjs collect dst.name
			lstNodes.items = dstNames
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

		on btnPickOrig picked obj do
		(
			lb.mirrorMorphTargets.srcObj = obj
			
			if (obj != undefined) then
			(
				btnPick.enabled = true
				btnAdd.enabled = true
				btnRemove.enabled = true
				btnShowPts.enabled = true
			)
			
			refreshList()
			
			btnPickOrig.caption = obj.name
		)

		on btnShowPts changed state do
		(
			if btnShowPts.state  then
			(
				if (lb.mirrorMorphTargets.isInvalid lb.mirrorMorphTargets.srcObj) then
					btnShowPts.State = false
				else
				(	
					lb.mirrorMorphTargets.findMirrorPoints lb.mirrorMorphTargets.srcObj spnError.value progress:pbProgress
					
					registerRedrawViewsCallback StartDraw
				)
			)
			else
			(
				unRegisterRedrawViewsCallback StartDraw
				completeRedraw()
			)
				
			redrawViews()
		)
		on btnPick picked obj do
		(
			append lb.mirrorMorphTargets.dstObjs obj
			refreshList()
		)

		on btnAdd pressed do
		(
			if lb.mirrorMorphTargets.srcObj == undefined then return undefined
			
			objs = selectByName buttontext:"Pick" filter:lb.mirrorMorphTargets.ExPolyFilter
			
			if (objs != undefined) then
				lb.mirrorMorphTargets.dstObjs += objs
		
			refreshList()
		)

		on btnRemove pressed do
		(
			deleteItem lb.mirrorMorphTargets.dstObjs lstNodes.selection
			refreshList()
		)

		on btnGo pressed do
		(
			undo "Mirror Morph Targets" on
			(
				lb.mirrorMorphTargets.makeMorphTargets spnThres.value spnError.value progress:pbProgress
			)
		)
		
		on btnReset pressed do
		(
			res = queryBox "This will reset your objects' XForms and collapse their stacks. This cannot be undone.\nDo you want to continue?"
			
			if not res then return undefined
			
			-- Reset XForm and collapse srcObj
			if (lb.mirrorMorphTargets.srcObj != undefined) then
			(
				ResetXForm lb.mirrorMorphTargets.srcObj
				AddModifier lb.mirrorMorphTargets.srcObj (Turn_to_Poly())
				collapseStack lb.mirrorMorphTargets.srcObj
			)
		
			-- Reset XForm and collapse dstObjs
			if (lb.mirrorMorphTargets.dstObjs.count > 0) then
			(
				ResetXForm lb.mirrorMorphTargets.dstObjs
				AddModifier lb.mirrorMorphTargets.dstObjs (Turn_to_Poly())
				collapseStack lb.mirrorMorphTargets.dstObjs
			)
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

			unRegisterRedrawViewsCallback DrawPoints
			lb.mirrorMorphTargets.srcObj = undefined
			lb.mirrorMorphTargets.dstObjs = #()
			lb.mirrorMorphTargets.foundPoints = #()
			completeRedraw()
			
			gc lite:on

			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: mirrorMorphTargets | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_mirrorMorphTargets
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
		cPoint = str_cPoint(),

		srcObj = undefined,
		dstObjs = #(),
		
		foundPoints = #(),
		lostPoints = #(),
		
		colorGreen = (color 27 177 27),	-- wirecolor de las geometrías de lado derecho
		colorBlue = (color 28 28 177),		-- wirecolor de las geometrías de lado izquierdo	

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

		fn distSq p1 p2 =
		(
			return (p1.x-p2.x)^2+(p1.y-p2.y)^2+(p1.z-p2.z)^2
		),
		
		fn isInvalid o =
		(
			return (o == undefined) or (isDeleted o)
		),
		
		fn findMirrorPoints obj error progress:undefined =
		(
			local obj_bo = obj.baseobject
			local po = polyop
			local Get_Vert = po.getVert
			local dist = distance
			local p1
			local p2
			local pts = #()
			local verts = #()
			local bFound = false
			local idx = 0
			local gvts = 0
			local ts
			local iNum = 0
			
			iNumVerts = po.GetNumVerts obj
		
			verts.count = iNumVerts
		
			for i = 1 to iNumVerts do verts[i] = (Get_Vert obj i) * (inverse (obj.transform))
			
			for i = 1 to iNumVerts do
			(
				bFound = false
				
				p1 = verts[i]
				
				for j = 1 to iNumVerts where (not bFound) do
				(
					p2 = verts[j]
					p2 *= [-1, 1, 1]
						
					(
						if dist p1 p2 <= error then
						(
							idx += 1
							append pts #(i, j)
							bFound = true
						)
					)
				)
				
				if (not bFound) then
				(
					idx += 1
					append pts #(i, i)
				)
		
				if progress != undefined then
					progress.value = ((i as float)/iNumVerts) * 100.0
			)
			
			for p in pts do
				append lb.mirrorMorphTargets.foundPoints (str_cPoint p[1] #(p[2]) #(1))
				
			pts
		),

		fn getVecs src dst =
		(
			local Get_Vert = polyop.getVert
			local vecs = #()
			
			if (isInvalid srcObj) then return undefined
		
			numVerts = polyop.getNumVerts src
			
			tm1 = inverse src.transform
			tm2 = inverse dst.transform
			
			for i = 1 to numVerts do
			(
				pos1 = (Get_Vert src i) * tm1
				pos2 = (Get_Vert dst i) * tm2
				
				append vecs ((pos2 - pos1)*[-1,1,1])
			)
			
			return vecs
		),
		
		mapped fn makeMorphTarget obj fZOffset =
		(
			local Set_Vert = polyop.setVert
			if (not isInvalid srcObj) then
			with undo off
			(	
				c = copy srcObj
				
				tm = c.transform	
			
				vecs = GetVecs srcObj obj
				
				for f in lb.mirrorMorphTargets.foundPoints do
					Set_Vert c f.iIndex ((vecs[f.pPoints[1]]+(polyop.getVert c f.iIndex)))
				
				c.pos = obj.pos
				c.pos.z -= fZOffset
				
				case (toLower obj.name[1]) of
				(
					"r": 		(c.name = "L" + substring obj.name 2 obj.name.count; c.wirecolor = colorBlue)
					"l": 		(c.name = "R" + substring obj.name 2 obj.name.count; c.wirecolor = colorGreen)
					default:	c.name = "Mirrored_" + obj.name
				)
			)
		),
		
		fn makeMorphTargets thres errorThres progress:undefined =
		(
			with redraw off
			with undo on
			(
				if (isInvalid lb.mirrorMorphTargets.srcObj) then return undefined
					
				lb.mirrorMorphTargets.findMirrorPoints lb.mirrorMorphTargets.srcObj errorThres
				
				fZOffset = (srcObj.max.Z - srcObj.min.Z) * 1.5
				
				MakeMorphTarget dstObjs fZOffset
			)
		),
		
		fn drawPoints tm =
		(
			if isInvalid srcObj then return undefined
			
			dists = #()

			gw.setTransform (matrix3 1)
			gw.enlargeUpdateRect #whole
			
			-------------------------------
			-- Set points for mirror plane
			size = 20
			
			points = #()
			rgbs = #()
		
			append points ([0,-size,-size]*tm)
			append points ([0, size,-size]*tm)
			append points ([0, size, size]*tm)
			append points ([0,-size, size]*tm)
			
			for p in points do p = p*srcObj.transform
			
			append rgbs (color 255 229 0)
			append rgbs (color 255 229 0)
			append rgbs (color 255 229 0)
			append rgbs (color 255 229 0)
			-------------------------------
			-- Draw mirror plane
			gw.PolyLine points true rgb:rgbs
			
			-------------------------------
			-- Draw Mirror Points	
			rgb = color 0 0 0
			pos = point3 0 0 0

			for f in lb.mirrorMorphTargets.foundPoints do
			(
				pos1 = polyop.getVert srcObj f.iIndex
				pos2 = polyop.getVert srcObj f.pPoints[1]
				
				rgb = green
				
				--gw.polyline #(pos1, pos2) false rgb:#(red, red)
				
				if (f.iIndex == f.pPoints[1]) then
				(
					gw.wMarker (gw.wTransPoint pos2) #hollowBox color:red
					gw.wMarker (gw.wTransPoint pos1) #smallHollowBox color:red
				)
				else if ((pos1*(inverse srcObj.transform)).x < 0) then
				(
					gw.wMarker (gw.wTransPoint pos1) #hollowBox color:green
					gw.wMarker (gw.wTransPoint pos1) #smallHollowBox color:green
				)
				else if ((pos1*(inverse srcObj.transform)).x > 0) then
				(
					gw.wMarker (gw.wTransPoint pos1) #hollowBox color:blue
					gw.wMarker (gw.wTransPoint pos1) #smallHollowBox color:blue
				)
				
			)
			
			gw.enlargeUpdateRect #whole 
			gw.updateScreen() 	
		),
		
		fn polyFilter obj = return (classof obj == Editable_Poly),

		fn exPolyFilter obj = return (classof obj == Editable_Poly) and (obj != srcObj) and (obj.numverts == srcObj.numVerts),	

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
		
	)--tl_mirrorMorphTargets
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_mirrorMorphTargets() --crea la herramienta
)