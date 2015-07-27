------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Librería de funciones de viewport
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: viewport | Contiene la libreria de funciones de viewport.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_viewport
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de viewport",	--@var: description | Descripcion de la libreria.
		
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

		---------------------------------------------------------------------------
		--devuelve una camara nueva preparada para renderizas los objetos pasados por parametro
		--view - indica la vista de camara para el render
		--views:
		-- #viewport
		--
		--#F
		--#K
		--
		--#R
		--#L
		--
		--#T
		--#B
		--
		--se pueden combinar las anteriores por grupos: FT, KB, RB, RBK, FTL...
		---------------------------------------------------------------------------
		fn genThumbnailCam nodes fov renderSize clipPlanes:true view:#F =
	 	( 	
			local cam = undefined
			
			if classof nodes == Array and nodes.count != 0 then
			(
				--calcula el bbox del grupo de nodos pasado
				absMax = [-100000.0,-100000.0,-100000.0]
				absMin = [100000.0,100000.0,100000.0]
				
				for n in nodes do --busca el maximo y el minimo
				(
					if n.max.x > absMax.x then absMax.x = n.max.x
					if n.max.y > absMax.y then absMax.y = n.max.y
					if n.max.z > absMax.z then absMax.z = n.max.z
					
					if n.min.x < absMin.x then absMin.x = n.min.x
					if n.min.y < absMin.y then absMin.y = n.min.y
					if n.min.z < absMin.z then absMin.z = n.min.z
				)
					
				if view == #viewport then --crea la camara desde el vireport en esa posicion
				(
					local targdist = getscreenscalefactor [0,0,0]
						
					local viewfov = getVIewFOV()
					local cXform =  Inverse(viewport.getTM())
					  
					--crea una camara y la coloca orientada con el viewport
					if viewport.Gettype() != #view_camera then
					(
						cam = Freecamera targetDistance:targdist
						cam.fov = viewfov
						cam.orthoProjection = false 
						cam.Transform = cXform 
					)--end then
					else
						cam = copy (getActiveCamera()) --si ya hay una camara, devuelve una copia
				)
				else
				(
					cam = freeCamera name:"thumbnailCam" fov:fov --crea ua camara temporal
					cam.wirecolor = color 0 0 0
					
					-- coloca la camara en los objetos pasados por parametro--------------------------
					cam.transform = (matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
					
					--coloca la camara en el centro de los objetos
					if absMax != [-100000.0,-100000.0,-100000.0] and absMin != [100000.0,100000.0,100000.0] then --si e bbox hayado es valido
						cam.pos = (absMax + absMin)/2	--[(absMax.x + absMin.x)/2, (absMax.y + absMin.y)/2, (absMax.z + absMin.z)/2]
					-----------------------------------------------------------------------------------------
					
					
					local angs = #() --agulos para colocar la camara en rotacion con la vista
					
					case view of
					(
						#R:		angs = #(eulerAngles 0 -90 0)
						#L:		angs = #(eulerAngles 0 90 0)
						#F:		angs = #(eulerAngles 0 0 0)
						#K:		angs = #(eulerAngles 0 180 0)
						#T:		angs = #(eulerAngles -90 0 0)
						#B:		angs = #(eulerAngles 90 0 0)
						
						#RF:		angs = #(eulerAngles 0 -45 0)
						#FR:		angs = #(eulerAngles 0 -45 0)
						
						#RK:		angs = #(eulerAngles 0 -135 0)
						#KR:		angs = #(eulerAngles 0 -135 0)
						
						#RT:		angs = #(eulerAngles 0 -90 0,eulerAngles -45 0 0)
						#TR:		angs = #(eulerAngles 0 -90 0,eulerAngles -45 0 0)
						
						#RB:		angs = #(eulerAngles 0 -90 0,eulerAngles 45 0 0)
						#BR:		angs = #(eulerAngles 0 -90 0,eulerAngles 45 0 0)
						
						#RFT:		angs = #(eulerAngles 0 -45 0,eulerAngles -45 0 0)
						#RTF:		angs = #(eulerAngles 0 -45 0,eulerAngles -45 0 0)
						#FRT:		angs = #(eulerAngles 0 -45 0,eulerAngles -45 0 0)
						#TRF:		angs = #(eulerAngles 0 -45 0,eulerAngles -45 0 0)
						#FTR:		angs = #(eulerAngles 0 -45 0,eulerAngles -45 0 0)
						#TFR:		angs = #(eulerAngles 0 -45 0,eulerAngles -45 0 0)
						
						#RFB:		angs = #(eulerAngles 0 -45 0,eulerAngles 45 0 0)
						#RBF:		angs = #(eulerAngles 0 -45 0,eulerAngles 45 0 0)
						#FRB:		angs = #(eulerAngles 0 -45 0,eulerAngles 45 0 0)
						#BRF:		angs = #(eulerAngles 0 -45 0,eulerAngles 45 0 0)
						#FBR:		angs = #(eulerAngles 0 -45 0,eulerAngles 45 0 0)
						#BFR:		angs = #(eulerAngles 0 -45 0,eulerAngles 45 0 0)
						
						#RKT:		angs = #(eulerAngles 0 -135 0,eulerAngles -45 0 0)
						#RTK:		angs = #(eulerAngles 0 -135 0,eulerAngles -45 0 0)
						#KRT:		angs = #(eulerAngles 0 -135 0,eulerAngles -45 0 0)
						#TRK:		angs = #(eulerAngles 0 -135 0,eulerAngles -45 0 0)
						#KTR:		angs = #(eulerAngles 0 -135 0,eulerAngles -45 0 0)
						#TKR:		angs = #(eulerAngles 0 -135 0,eulerAngles -45 0 0)
						
						#RKB:		angs = #(eulerAngles 0 -135 0,eulerAngles 45 0 0)
						#RBK:		angs = #(eulerAngles 0 -135 0,eulerAngles 45 0 0)
						#KRB:		angs = #(eulerAngles 0 -135 0,eulerAngles 45 0 0)
						#BRK:		angs = #(eulerAngles 0 -135 0,eulerAngles 45 0 0)
						#KBR:		angs = #(eulerAngles 0 -135 0,eulerAngles 45 0 0)
						#BKR:		angs = #(eulerAngles 0 -135 0,eulerAngles 45 0 0)
						
						#LF:		angs = #(eulerAngles 0 45 0)
						#FL:		angs = #(eulerAngles 0 45 0)
						
						#LK:		angs = #(eulerAngles 0 135 0)
						#KL:		angs = #(eulerAngles 0 135 0)
						
						#LT:		angs = #(eulerAngles 0 -90 0,eulerAngles -45 0 0)
						#TL:		angs = #(eulerAngles 0 -90 0,eulerAngles -45 0 0)
						
						#LB:		angs = #(eulerAngles 0 -90 0,eulerAngles 45 0 0)
						#BL:		angs = #(eulerAngles 0 -90 0,eulerAngles 45 0 0)
						
						#LFT:		angs = #(eulerAngles 0 45 0,eulerAngles -45 0 0)
						#LTF:		angs = #(eulerAngles 0 45 0,eulerAngles -45 0 0)
						#FLT:		angs = #(eulerAngles 0 45 0,eulerAngles -45 0 0)
						#TLF:		angs = #(eulerAngles 0 45 0,eulerAngles -45 0 0)
						#FTL:		angs = #(eulerAngles 0 45 0,eulerAngles -45 0 0)
						#TFL:		angs = #(eulerAngles 0 45 0,eulerAngles -45 0 0)
						
						#LFB:		angs = #(eulerAngles 0 45 0,eulerAngles 45 0 0)
						#LBF:		angs = #(eulerAngles 0 45 0,eulerAngles 45 0 0)
						#FLB:		angs = #(eulerAngles 0 45 0,eulerAngles 45 0 0)
						#BLF:		angs = #(eulerAngles 0 45 0,eulerAngles 45 0 0)
						#FBL:		angs = #(eulerAngles 0 45 0,eulerAngles 45 0 0)
						#BFL:		angs = #(eulerAngles 0 45 0,eulerAngles 45 0 0)
						
						#LKT:		angs = #(eulerAngles 0 135 0,eulerAngles -45 0 0)
						#LTK:		angs = #(eulerAngles 0 135 0,eulerAngles -45 0 0)
						#KLT:		angs = #(eulerAngles 0 135 0,eulerAngles -45 0 0)
						#TLK:		angs = #(eulerAngles 0 135 0,eulerAngles -45 0 0)
						#KTL:		angs = #(eulerAngles 0 135 0,eulerAngles -45 0 0)
						#TKL:		angs = #(eulerAngles 0 135 0,eulerAngles -45 0 0)
						
						#LKB:		angs = #(eulerAngles 0 135 0,eulerAngles 45 0 0)
						#LBK:		angs = #(eulerAngles 0 135 0,eulerAngles 45 0 0)
						#KLB:		angs = #(eulerAngles 0 135 0,eulerAngles 45 0 0)
						#BLK:		angs = #(eulerAngles 0 135 0,eulerAngles 45 0 0)
						#KBL:		angs = #(eulerAngles 0 135 0,eulerAngles 45 0 0)
						#BKL:		angs = #(eulerAngles 0 135 0,eulerAngles 45 0 0)
						
						#FT:		angs = #(eulerAngles -45 0 0)
						#TF:		angs = #(eulerAngles -45 0 0)
						
						#FB:		angs = #(eulerAngles 45 0 0)
						#BF:		angs = #(eulerAngles 45 0 0)
						
						#KT:		angs = #(eulerAngles 0 180 0,eulerAngles -45 0 0)
						#TK:		angs = #(eulerAngles 0 180 0,eulerAngles -45 0 0)
						
						#KB:		angs = #(eulerAngles 0 180 0,eulerAngles 45 0 0)
						#BK:		angs = #(eulerAngles 0 180 0,eulerAngles 45 0 0)
					)
					
					in coordsys cam (
						for a in angs do
							rotate cam a
					)
			 
					-- calcula la dsitancia necesaria para abarcar todos los objetos
					local bBoxSize = (absMax - absMin) * 2--1.7
			 
					local distWidth = (bBoxSize.x / 2.) / tan (fov / 2.)
					local distHeight = (bBoxSize.y / 2.) / tan ((this.getVerticalfov fov renderSize:renderSize) / 2.)
					local dist = amax (abs distWidth) (abs distHeight)
			 
					-- muev la camara para ver todos los objetos
					in coordsys cam
						cam.pos.z += dist
					
				)
				
				--calcula los clip planes y los aplica si procede
				if clipPlanes then
				(
					nodesCenter = ((absMax + absMin)/2)
					h = abs (absMax.z - absMin.z)
					w = abs (absMax.x - absMin.x)
					l = abs (absMax.y - absMin.y)
					
					relDistZ = abs (nodesCenter.z - cam.pos.z)
					relDistX = abs (nodesCenter.x - cam.pos.x)
					relDistY = abs (nodesCenter.y - cam.pos.y)
					
					biggerDist = 0
					if relDistZ > biggerDist then biggerDist = relDistZ
					if relDistX > biggerDist then biggerDist = relDistX
					if relDistY > biggerDist then biggerDist = relDistY
						
					cam.clipManually = true
					cam.nearclip = (distance cam.pos nodesCenter) - biggerDist/2
					cam.farclip = (distance cam.pos nodesCenter) + biggerDist/4
				)
				
			)
			
	 		cam
	 	),

		---------------------------------------------------------------------------
		--devuelve el bitmap de captura de viewport de los objetos pasados en nodes
		--view - indica la vista de camara para el render
		--views:
		--#F
		--#K
		--
		--#R
		--#L
		--
		--#T
		--#B
		--
		--se pueden combinar las anteriores por grupos: FT, KB, RB, RBK, FTL...
		---------------------------------------------------------------------------
		fn genThumbnailViewport nodes thumbnailSize fov clipPlanes:true view:#F =
		(
			local cap = undefined
			
			if classof nodes == Array and nodes.count != 0 then
			(
				disableSceneRedraw()
				viewportType = viewport.Gettype()
				
				local camObj = undefined
				local camObjBckp = undefined
				
				-- crea la camara temporal y la de bckp del viewport en funcion de las circusntancias
				camObj = this.genThumbnailCam nodes fov thumbnailSize clipPlanes:clipPlanes view:view
				
				if viewportType == #view_camera then --si ya hay una camara como vista
					camObjBckp = getActiveCamera()
				else
					camObjBckp = this.genThumbnailCam nodes fov thumbnailSize clipPlanes:clipPlanes view:#viewport
							
				enableSceneRedraw()
				
				-- realiza la captura
				viewport.setCamera camObj
				redrawViews()
				tempCap = gw.getViewportDib()
				viewport.setCamera camObjBckp
				redrawViews()
				
				disableSceneRedraw()
				
				width = tempCap.width
				height = tempCap.height
				
				if width > height then --si es mas ancho que alto, hay que recortar anchura
				(
					cap = bitmap thumbnailSize.x thumbnailSize.y color:white
					squareCap = bitmap (tempCap.height) (tempCap.height) color:white
					excess = (width - height)/2
					
					pasteBitmap tempCap squareCap [excess,1] [0,0] --coge el cuadrado central de la captura
					copy squareCap cap
				)
				else
				(
					cap = bitmap thumbnailSize.x thumbnailSize.y color:white
					squareCap = bitmap (tempCap.width) (tempCap.width) color:white
					excess = (height - width)/2
					
					pasteBitmap tempCap squareCap [1,excess] [0,0] --coge el cuadrado central de la captura
					copy squareCap cap
				)
					
				--elimina los objetos auxiliares
				if isValidNode camObj then
					--if viewportType != #view_camera then
						delete camObj
				
				if isValidNode camObjBckp and viewportType != #view_camera then
					delete camObjBckp
				
				enableSceneRedraw()
	 		)
			
	 		cap --devuelve la captura
		),

		---------------------------------------------------------------------------
		--obtiene el fov Vertical teniendo en cuenta el fov horizontal y el tamaño de render
		---------------------------------------------------------------------------
	 	fn getVerticalfov fov renderSize:[renderWidth, renderHeight] =
	 	( 
	 		local r_aspect=(renderSize.x as float)/renderSize.y
	 		
			2.0*atan(tan(fov/2.0)/r_aspect)
	 	),

		---------------------------------------------------------------------------
		--devuelve el render de los objetos pasados en nodes
		--view - indica la vista de camara para el render
		--views:
		--#F
		--#K
		--
		--#R
		--#L
		--
		--#T
		--#B
		--
		--se pueden combinar las anteriores por grupos: FT, KB, RB, RBK, FTL...
		---------------------------------------------------------------------------
		fn genThumbnailRender nodes renderSize fov useSceneLights:false view:#F =
	 	(
			local rend = undefined
			
			if classof nodes == Array and nodes.count != 0 then
			(
				-- crea la camara temporal
				local camObj = this.genThumbnailCam nodes fov renderSize view:view
				
				-- si no se van a usar las luces de la escena sino otras auxiliares
				if not useSceneLights then
				(
					local keyLight = omniLight name:"ContactSheetTempLight" color:white multiplier:1.0
					local fillLight = omniLight name:"ContactSheetTempLight" color:white multiplier:0.5
					
					--calcula el bbox del grupo de nodos pasado------------------------------------------------------
					absMax = [-100000.0,-100000.0,-100000.0]
					absMin = [100000.0,100000.0,100000.0]
					
					for n in nodes do --busca el maximo y el minimo
					(
						if n.max.x > absMax.x then absMax.x = n.max.x
						if n.max.y > absMax.y then absMax.y = n.max.y
						if n.max.z > absMax.z then absMax.z = n.max.z
						
						if n.min.x < absMin.x then absMin.x = n.min.x
						if n.min.y < absMin.y then absMin.y = n.min.y
						if n.min.z < absMin.z then absMin.z = n.min.z
					)
					-----------------------------------------------------------------------------------------------------	
					
					nodesCenter = ((absMax + absMin)/2) --calcula el centro de los nodos
					local dist = distance camObj.pos nodesCenter
					
					in coordsys camObj
					( 
						keyLight.pos = [dist, dist, 0]
						fillLight.pos = [-dist, -dist, 0]
					)
				)
		 
				-- realiza el render
				rend = render camera:camObj outputSize:renderSize renderhiddenobjects:false vfb:false

				--elimina los objetos auxiliares
				
				if isValidNode camObj then
					delete camObj 
		 
				if isValidNode keyLight then
					delete keyLight
				
				if isValidNode fillLight then
					delete fillLight
	 		)
			
	 		rend --devuelve el render
	 	),

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: bitmap | getViewportSafeframeDib | Devuelve una captura de imagen del viewport teniendo en cuenta los safe frames. Extraído de CGSociety
		------------------------------------------------
		fn getViewportSafeframeDib = 
		(
			local _x = _y = 0
			local _v
			local _size = getViewSize()
			local _aspect = getRendImageAspect()
			
			if _aspect < (_size.x/_size.y) then 
			(
				_v = [_size.y * _aspect, _size.y]
				_x = (_size.x - _v.x)/2 + 1
			) 
			else 
			(
				_v = [_size.x, _size.x/_aspect]
				_y = (_size.y - _v.y)/2 + 1
			)
			
			_bmp = bitmap _v.x _v.y
			_bmpAux = (gw.getViewportDib()) 
			pasteBitmap _bmpAux _bmp (box2 _x _y _v.x _v.y) [0,0]
			
			_bmpAux = undefined
			free _bmpAux
			
			_bmp
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
		--@event: create | Ejecución al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_viewport
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_viewport()
)

