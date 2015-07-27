plugin modifier Transform_Cache 
	name:"Transform Cache" 
	category:"lbTools" 
	classID:#(1465733223, -1393485649)	-- Es necesario crear una clase para el modificador. Números creados automáticamente con "genClassId returnValue:true"
(
	
	----------------------------------------------------------------------------------------------------------------
	-------------------------------------- VARIABLES LOCALES -----------------------------------------------
	----------------------------------------------------------------------------------------------------------------
	
	local creatingModifier = false			-- Indica si se está creando en este momento el modificador
	local keyArraysCreated = false		-- indica si se han creado los arrays de claves
	local OBJ =  undefined					-- Objeto que contiene el modificador
	local rollTC									-- rollout
	
		
	----------------------------------------------------------------------------------------------------------------
	----------------------------------------------- PARÁMETROS -----------------------------------------------
	----------------------------------------------------------------------------------------------------------------
	
	parameters main rollout:rollTC
	(
		originalStart					type:#float 		animatable:false 	default:0.0
		originalEnd						type:#float 		animatable:false 	default:100.0
		originalTransform				type:#matrix3		animatable:false 	default:(matrix3 1)	-- transformación inicial del objeto
		animationTransform				type:#matrix3		animatable:false 	default:(matrix3 1)	-- transformación inicial de la animación cargada
		filename 						type:#filename 		animatable:false 	default:""		-- nombre del fichero de cache que se está manejando
		fileLoaded						type:#boolean		animatable:false 	default:false
		recordStart						type:#integer		animatable:false 	default:0		ui:spnRecordStart
		recordEnd						type:#integer		animatable:false 	default:100		ui:spnRecordEnd
		keysPerFrame					type:#integer		animatable:false 	default:1		ui:spnKeysPerFrame
		loadType 						type:#integer		animatable:false 	
		relativeOffset					type:#boolean		animatable:false 	default:false	ui:chkRelativeOffset
		strength 						type:#float 		animatable:true 	default:1		ui:spnStrength
		playbackType 					type:#integer		animatable:false 	default:0	
		playbackStart 					type:#float 		animatable:false 	default:0 		ui:spnPlaybackStart
		playbackEnd 					type:#float 		animatable:false 	default:100 	ui:spnPlaybackEnd
		loop							type:#boolean		animatable:false	default:false	ui:chkCacheLoop
		cacheFileDate					type:#string		animatable:false 	default:""		-- fecha de modificación del fichero de cache. Se usa para determinar si al cargar la
																												-- escena hay que cargar también el fichero de cache (si no coincide con la fecha del
																												-- fichero de cache en disco)
		
		
		---------------------------------------------------------------------------------
		on filename set val do 
		(
			if not loading then --si no esta cargando ya
			(
				if filename == "" then --si se ha limpiado filename
				(
					if (OBJ != undefined) then this.resetCache()
				)
				else if this.enabled then
				(
					if doesFileExist filename then --si existe el archivo lo utiliza y lo almacena
						this.loadFilename filename
					else if (this.getCacheFileFromSubfolders filename maxFilePath) != undefined then --si no existe pero si en las subcarpetas del archivo max usa ese
						this.loadFilename (this.getCacheFileFromSubfolders filename maxFilePath) storeFilename:false
				)--if else filename
			)--if
		)
		
		---------------------------------------------------------------------------------
		on relativeOffset set val do 
		(
			if OBJ != undefined then
			(
				if val then
					at time -1000000 OBJ.transform = originalTransform
				else
					at time -1000000 OBJ.transform = animationTransform
			)
		)
		
		---------------------------------------------------------------------------------
		on playbackType set val do 
		(
			rollTC.ddlPlaybackType.selection = playbackType + 1
			rollTC.updateControls()
		)
		
		---------------------------------------------------------------------------------
		on playbackStart set val do rollTC.updateKeys()
		
		---------------------------------------------------------------------------------
		on playbackEnd set val do rollTC.updateKeys()
		
		---------------------------------------------------------------------------------
		on strength set val do rollTC.updateKeys()
		
		---------------------------------------------------------------------------------
		on loop set val do
		(
			if val then
			(
				playbackType = 2
				rollTC.updateControls()
			)
			rollTC.updateKeys()
		)
	)
	
	----------------------------------------------------------------------------------------------------------------
	----------------------------------------------- FUNCIONES ------------------------------------------------
	----------------------------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------
	--busca el filename en las subcarpetas inmediatas al punto en el que esta almacenado el archivo .max de forma recursiva
	--devuelve el path del archivo encontrado si existe, y si no existe devuelve undefined
	----------------------------------------------------------------------------------
	fn getCacheFileFromSubfolders filename folder =
	(
		_filename = undefined --variable donde almacenar el path del archivo encontrado
		
		if folder != undefined and folder != "" then --si no hay folder en el que buscar no lo hace
		(
			_folderFiles = getFiles (folder + ((getFileNameFile filename) + (getFileNameType filename)))
			
			if _folderFiles.count != 0 then _filename = _folderFiles[1]
				
			if _filename == undefined then
			(
				_subFolders = getDirectories (folder + "*") --busca los subdirectorios del actual
				
				for _subF in _subFolders where _filename == undefined do --recorre los subfolders
					_filename = getCacheFileFromSubfolders filename _subF
			)--if _filename
		)--if folder
		
		_filename --devuelve el archivo encontrado
	)

	---------------------------------------------------------------------------------------------------
	-- crea un controlador nuevo a la pista T. Si no se indica el nuevo controlador
	-- NEWCONTROLLER se intenta crear uno automáticamente. Devuelve
	-- TRUE o FALSE indicando si ha conseguido crear el controlador
	---------------------------------------------------------------------------------------------------
	fn createControllerTrack t newController:undefined =
	(
		creado = false
		
		if newController != undefined then
			try
			(
				t.controller = newController
			)
			catch()
		else
			case (classof t.value) of
			(
				BooleanClass: 	(t.controller = boolean_float()	; creado = true)
				Float: 			(t.controller = bezier_float()	; creado = true)
				Integer:		 	(t.controller = bezier_float()	; creado = true)
				Color:			(try (t.controller = bezier_color() ; creado = true) catch t.controller = bezier_point4(); creado = true)
				undefined: 		try (t.controller = bezier_color() ; creado = true) catch()
			)
			
		creado
	)

	--devuelve las pistas animadas de un modificador
	----------------------------------------------------------------------------------
	fn getModifierAnimatedTracks mod =
	(
		_modAnimatedTracks = #()
		
		if mod.numSubs != 0 then (for i=1 to mod.numSubs do _modAnimatedTracks += getModifierAnimatedTracks mod[i])
		else if mod.controller != undefined then
			if mod.isAnimated then append _modAnimatedTracks mod
		
		_modAnimatedTracks
	)
		
	----------------------------------------------------------------------------------
	-- 	Establece los controladores de animación correctos de los objetos
	--	de tipo transform cache. Solo actualiza los controladores si el objeto
	--	es de tipo Transform_Cache
	----------------------------------------------------------------------------------
	fn setTCcontrollers =
	(
		if classOf OBJ.controller != lookAt then
			OBJ.controller = prs()
		
		OBJ.position.controller 	= position_xyz()
		if classOf OBJ.controller != lookAt then OBJ.rotation.controller 	= euler_xyz()
		OBJ.scale.controller 		= scalexyz()
		
		OBJ.visibility = bezier_Float()
	)
	
	---------------------------------------------------------------------------------
	-- 	Muestra el diálogo para definir un nuevo fichero en el que grabar el cache
	---------------------------------------------------------------------------------
	fn newCacheFile =
	(
		f = getsavefilename types:"TC file(*.xaf)|*.xaf" filename:OBJ.name
		
		if f != undefined then 
		(
			if doesFileExist f then
				deleteFile f
			
			undo "New TC file" on
			(
					filename = f
			)
			
			rollTC.updateControls()
		)
	)
	
	---------------------------------------------------------------------------------
	-- 	graba la animación de la pieza a través de un objeto auxiliar que adopta 
	--	frame a frame la transformación del objeto original.
	---------------------------------------------------------------------------------
	fn recordCache savefile:undefined ignoreTransforms:false =
	(
		OBJ = (refs.dependentnodes this)[1]
		oldOBJname = OBJ.name
		oldOBJcontroller = OBJ.controller
		oldInTangentType = undefined
		oldOutTangentType = undefined
		
		--	capturamos el antiguo tipo de tangentes y las establecemos como lineales por defecto
		--	para todas las keys individuales que se van a generar a continuación.
		maxOps.getDefaultTangentType &oldInTangentType &oldOutTangentType
		maxOps.setDefaultTangentType #linear #linear
		
		--	creamos un objeto auxiliar para grabar la animación. Dependiendo de si es un mesh o una cámara creamos
		--	una caja o una Cámara como dicho objeto auxiliar. Si es una cámara la creamos del mismo tipo que la original.
		p = undefined
		
		if superClassOf OBJ != camera then
		(
			p = box length:1 width:1 height:1 lengthsegs:1 widthsegs:1 heightsegs:1 name:"animNode" ishidden:true --point isHidden:true name:"animNode" 
			addModifier p (Edit_Poly())
			collapseStack p
		)
		else 
		(
			if classOf OBJ == freeCamera then
			( 
				p = freeCamera isHidden:true name:"animNode"
				p.fov.controller = Bezier_Float()
			)
			else
			(	
				p = freeCamera isHidden:true name:"animNode"
				p.fov.controller = Bezier_Float()
				--p = targetCamera isHidden:true name:"animNode" --target:(targetObject name:"animNode.target")				
				--p.controller = lookAt()
			)
		)
		
		--	iniciamos los controladores
		--if classOf OBJ != targetCamera then
		(
			p.pos.controller = position_xyz()
			p.rotation.controller = euler_xyz()
			p.scale.controller = scalexyz()
		)
		/* else
		(	
			p.controller.RollAngle.controller = bezier_float()
		) */

		------------------------------------------------------------------
		-- añadimos todos los modificadores con el flag "p" que hay que conservar para cachear
		--Al final se ha decidido que se almacenen todos los modificadores
		
		_modifiersToKeep = #()
		_modifiersToKeep_animatedTracks = #()
		
		_modifiersToKeepCopy = #()
		_modifiersToKeepCopy_animatedTracks = #()
		
		for _mod in OBJ.modifiers where (classof _mod != Transform_Cache) /* and (MatchPattern _mod.name pattern:("*:*" + lb.nc.NC_pointCacheModifierFlag + "*"))*/ do insertItem _mod _modifiersToKeep 1
		
		for _mod in _modifiersToKeep do
		(
			_newMod = copy _mod
			_newMod.name = _mod.name
			
			append _modifiersToKeep_animatedTracks (getModifierAnimatedTracks _mod)
			append _modifiersToKeepCopy _newMod
			append _modifiersToKeepCopy_animatedTracks (getModifierAnimatedTracks _newMod)
			
			addModifier p _newMod
		)--for		
		
		for i=1 to _modifiersToKeepCopy_animatedTracks.count do
		(
			for j=1 to _modifiersToKeepCopy_animatedTracks[i].count do createControllerTrack _modifiersToKeepCopy_animatedTracks[i][j]
		)--for
		------------------------------------------------------------------
		
		
		if classOf p.controller != lookAt then
			p.rotation.controller = euler_xyz() 
		
		p.scale.controller = scalexyz()
		
		at time 0
		(
			_bckpVal = if OBJ.visibility then 1.0 else 0.0
			p.visibility = bezier_Float()
			p[1].controller.value = _bckpVal
		)
		
		--	grabamos la animación de las piezas
		with animate on
		(
			for i = recordStart to recordEnd by (1.0/keysPerFrame) do 
				at time i
				(
-- 					if not ignoreTransforms then
						p.transform = OBJ.transform
					
					-- si es un transform cache de cámara también grabamos el fov
					if superClassOf OBJ == camera then
					(
						p.fov = OBJ.fov
						
						--if classOf OBJ == targetCamera then p.controller.RollAngle = OBJ.controller.RollAngle
					)--if
					
					--almacena los valores de visibilidad
					--si el objeto origen tiene pista de visibiidad con controllador lo coge de ella
					if OBJ[1].controller != undefined then
					(
						p[1].controller.value = OBJ[1].controller.value
					)
					else --si no, coge como valor 1 en caso de visible y 0 si no está visible
					(						
						p[1].controller.value = if OBJ.visibility then 1.0 else 0.0
					)					
					
					------------------------------------------------------------------
					-- Recorrer las pistas animables de los modificadores y grabarles clave
					
					for i=1 to _modifiersToKeep_animatedTracks.count do
					(
						for j=1 to _modifiersToKeep_animatedTracks[i].count do
							_modifiersToKeepCopy_animatedTracks[i][j].controller.value = _modifiersToKeep_animatedTracks[i][j].controller.value
					)--for					
					
					------------------------------------------------------------------
				)
			
			at time recordEnd p.transform = OBJ.transform		--	para ciertos valores de keysPerFrame no se guarda el último frame. Lo hacemos a mano
		)
		
		-- borramos la clave del fotograma 0 que se ha creado automáticamente.
		if recordStart > 0 then	
		(
			deletekey p.position.controller 1
			if classOf p.controller != lookAt then 
				deletekey p.rotation.controller 1
			deletekey p.scale.controller 1
			
			if superClassOf OBJ == camera then 
				deletekey p.fov.controller 1
		)
		
		saveInterval = interval recordStart recordEnd
		
		--	Para las cámaras guardamos también la información de pistas como el FOV aunque no esté animado
		saveAnimatedOnly = (superClassOf OBJ != camera)
		
		if savefile != undefined then
			loadSaveAnimation.saveAnimation savefile p #() #() segInterval:saveInterval animatedTracks:saveAnimatedOnly
		else
			loadSaveAnimation.saveAnimation filename p #() #() segInterval:saveInterval animatedTracks:saveAnimatedOnly
		
		--	restauramos el antiguo tipo de tangentes por defecto
		maxOps.setDefaultTangentType oldInTangentType oldOutTangentType
		
		delete p
	)
	
	---------------------------------------------------------------------------------
	-- Carga la animación de cache contenida en el fichero f
	---------------------------------------------------------------------------------
	fn loadFileName f storeFilename:true =
	(
		local loaded = false
		OBJ = (refs.dependentnodes this)[1]
		oldOBJname = OBJ.name
		oldOBJcontroller = OBJ.controller
		
		if f != undefined then 
		(
			if storeFilename then filename = f
			
			p = undefined
		
			if superClassOf OBJ != camera then
			(
				p = box length:1 width:1 height:1 lengthsegs:1 widthsegs:1 heightsegs:1 name:"animNode" ishidden:true --point isHidden:true name:"animNode" 
				addModifier p (Edit_Poly())
				collapseStack p
			)
			else 
			(
				if classOf OBJ == freeCamera then
				(
					p = freeCamera isHidden:true name:"animNode"
					--p.fov.controller = Bezier_Float()					
				)
				else
				(
					p = freeCamera isHidden:true name:"animNode"
					--p.fov.controller = Bezier_Float()

					--p = targetCamera isHidden:true name:"animNode" --target:(targetObject name:"animNode.target")
					--p.controller = lookAt()
				)
			)
			
-- 			try
			(
				if classOf OBJ == targetCamera then 
				(
					OBJ.type = #free
					p.pos.controller = position_xyz()
					p.rotation.controller = euler_xyz() 
					p.scale.controller = scalexyz()
					
					--p.controller = lookAt()
					--p.target = copy OBJ.target
					
					--p.controller.RollAngle.controller = bezier_Float()
				)
				else
				(
					p.pos.controller = position_xyz()
					p.rotation.controller = euler_xyz() 
					p.scale.controller = scalexyz()
				)
				
				p.visibility = bezier_Float()
				p[1].controller.value = 1.0
				
				--------------------------------------------------------------------------
				--crea los controladores necesarios en los modificadores
				
				_modifiersToKeep = #()
				_modifiersToKeep_animatedTracks = #()
				
				for _mod in OBJ.modifiers where (classof _mod != Transform_Cache) /*and (MatchPattern _mod.name pattern:("*:*" + lb.nc.NC_pointCacheModifierFlag + "*"))*/ do
				(
					insertItem _mod _modifiersToKeep 1
				)
				
				for _mod in _modifiersToKeep do
				(
					append _modifiersToKeep_animatedTracks (getModifierAnimatedTracks _mod)
					addModifier p _mod
				)--for
				
				for i=1 to _modifiersToKeep_animatedTracks.count do
				(
					for j=1 to _modifiersToKeep_animatedTracks[i].count do createControllerTrack _modifiersToKeep_animatedTracks[i][j]
				)--for
				
				--------------------------------------------------------------------------

				if (loadsaveanimation.loadAnimation f p relative:false) then		-- cargamos la animación en el objeto auxiliar.
				(
					_hasPC = false
					for m in OBJ.modifiers where classof m == point_cache do _hasPC = true
					
					if not _hasPC then
					(
						--	Portamos la animación de transformación del objeto auxiliar al real
						OBJ.pos.controller = p.pos.controller	

						if classOf OBJ.controller != lookAt then OBJ.rotation.controller = p.rotation.controller
						else OBJ.controller.RollAngle.controller = p.controller.RollAngle.controller
						
						OBJ.scale.controller = p.scale.controller	
					)
					
					--almacena los valores de visibilidad
					OBJ.visibility = bezier_float()
					OBJ[1].controller.value = 1.0
					OBJ[1].controller = p[1].controller
					
					--	En el caso de las cámaras portamos también el FOV y los rangos de animación.
					if superClassOf OBJ == camera then
					(
						c = p.fov.controller

						if c != undefined and c.keys.count != 0 then
						(
							OBJ.fov.controller = p.fov.controller

							if isProperty OBJ #camInfo then
							(
								OBJ.camInfo.recStart = c.keys[1].time
								OBJ.camInfo.recEnd = c.keys[c.keys.count].time
							)--if
						)--if
					)

					------------------------------------------------------------------
					-- Recorrer las pistas animables de los modificadores y copiar el controlador
					
					--ESTO NO HACE FALTA PORQUE AHORA LOS MODIFICADORES DEL OBJETO AUXILIAR Y DEL OBJETO ESTAN INSTANCIADOS Y EL LOADANIMATION YA CARGA LAS CLAVES
					
					/*for i=1 to _modifiersToKeep_animatedTracks.count do
					(
						for j=1 to _modifiersToKeep_animatedTracks[i].count do
							_modifiersToKeep_animatedTracks[i][j].controller = _modifiersToKeepCopy_animatedTracks[i][j].controller
					)--for*/
					
					------------------------------------------------------------------
					
					animationTransform = at time -10000000 OBJ.transform
					if relativeOffset then at time -10000000 OBJ.transform = originalTransform
					
					-- si los controladores de animación de la pieza están bien
					-- se crean las curvas multiplier y ease
					if (rollTC.controllersOK()) then 
					(
						rollTC.removeEaseAndMultiplierCurves()
-- 						rollTC.createEaseCurves()
						rollTC.createMultiplierCurves()
					)
					
					rollTC.getAnimationRange()
					rollTC.updateKeys()
					rollTC.refreshState()
					
					cacheFileDate = getFileModDate f
					fileLoaded = true
				)
				
				rollTC.updateControls()
				
				delete p
				
				loaded = true
			)
-- 			catch		-- si falla el proceso eliminamos la pieza auxiliar
-- 			(
-- 				delete p
-- 				print "Transform cache error: could not load cache file"
-- 			)
		)
		
		loaded
	)
	
	---------------------------------------------------------------------------------
	-- Cargamos de nuevo el fichero de Cache
	---------------------------------------------------------------------------------
	fn reloadCache =
	(
		OBJ = (refs.dependentnodes this)[1]
		
		undo "Reload TC file" on
		(
			filename = filename
		)
	)
	
	---------------------------------------------------------------------------------
	-- Borramos la animación de la pieza pero no eliminamos
	-- la información del fichero de cache
	---------------------------------------------------------------------------------
	fn unloadCache =
	(
		OBJ = (refs.dependentnodes this)[1]
		
		undo "Unload TC file" on
		(
			deleteKeys OBJ #allKeys
			OBJ.transform = originalTransform 
			rollTC.updateControls()
		)
	)
	
	---------------------------------------------------------------------------------
	-- Reseteamos el Cache vaciando su animación
	---------------------------------------------------------------------------------
	fn resetCache =
	(
		OBJ = (refs.dependentnodes this)[1]
		
		undo "Reset TC" on
		(
			filename = ""
			deleteKeys OBJ #allKeys
			OBJ.transform = originalTransform 
			animationTransform = (matrix3 1)
			if (rollTC.controllersOK()) then rollTC.removeEaseAndMultiplierCurves()
			rollTC.updateControls()
		)
	)
	
	
	
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////---
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------------------------------
	----------------------------- ROLLOUT TRANSFORM POINT CACHE ------------------------------------
	----------------------------------------------------------------------------------------------------------------
	rollout rollTC "Transform Point Cache" width:160 height:420
	(
		GroupBox grpfilename "Cache File" pos:[5,5] width:150 height:110
		edittext lblfilename "" pos:[10,25] width:140 height:15 readOnly:true
		button btnFileNew "New" pos:[9,45] width:70 height:20
		button btnFileLoad "Load" pos:[81,45] width:70 height:20
		button btnFileUnload "Unload" pos:[9,68] width:70 height:20
		button btnFileReload "Reload" pos:[81,68] width:70 height:20
		button btnReset "Reset" pos:[10,90] width:140 height:20
					
		GroupBox grpState "State" pos:[5,120] width:150 height:60
		label lblState "Ready" pos:[10,135] width:140 height:40
					
		GroupBox grpRecord "Record" pos:[5,185] width:150 height:105
		--label lblrecordStart "Start frame" pos:[15,205] width:60 height:15
		spinner spnRecordStart "Start frame" pos:[30,205] width:115 height:16 range:[-1e+007,1e+007,0] fieldwidth:65
		--label lblrecordEnd "End frame" pos:[15,225] width:55 height:15
		spinner spnRecordEnd "End frame" pos:[30,225] width:115 height:16 range:[-1e+007,1e+007,100] fieldwidth:65
		spinner spnKeysPerFrame "Keys/Frame" pos:[30,245] width:115 height:16 range:[1,10,1] type:#integer fieldwidth:65
		button btnRecord "Record" pos:[10,265] width:140 height:20
						
		GroupBox grpLoadType "Load Type" pos:[4,295] width:150 height:55
		label lblLoadType "General" pos:[14,318] width:40 height:15
		dropdownList ddlLoadType "" pos:[59,315] width:85 height:21 items:#("Pre-Load")
			
		GroupBox grpPlaybackOptions "Playback options" pos:[5,355] width:150 height:80
		spinner spnStrength "Strength        " pos:[30,375] width:110 height:16 range:[-10,10,1]
		checkbox chkRelativeOffset "Relative offset" pos:[20,395] width:120 height:15
		checkbox chkCacheLoop "Loop" pos:[20,415] width:120 height:15
						
		GroupBox grpPlaybackType "Playback Type" pos:[4,440] width:150 height:115
		dropdownList ddlPlaybackType "" pos:[14,460] width:130 height:21 items:#("Original range", "Custom start", "Custom range", "Playback graph")
		label lblplaybackStart "Start Frame" pos:[14,490] width:55 height:15 enabled:false
		spinner spnplaybackStart "" pos:[74,490] width:70 height:16 enabled:false range:[-1e+007,1e+007,0]  scale:1.0
		label lblplaybackEnd "End Frame" pos:[14,510] width:55 height:15 enabled:false
		spinner spnplaybackEnd "" pos:[74,510] width:70 height:16 enabled:false range:[-1e+007,1e+007,100] scale:1.0
		label lblplaybackFrame "Frame" pos:[14,530] width:55 height:15 enabled:false
		spinner spnplaybackFrame "" pos:[74,530] width:70 height:16 enabled:false range:[-1e+007,1e+007,100] scale:1.0
		
		
		
		----------------------------------------------------------------------------------------------------------------
		---------------------------------------------- FUNCIONES -------------------------------------------------
		----------------------------------------------------------------------------------------------------------------
		
		---------------------------------------------------------------------------------
		-- Elimina todas las pistas multiplicadoras que pueda haber en el objeto
		-- creando un nuevo controlador para las pistas
		---------------------------------------------------------------------------------
		fn removeEaseAndMultiplierCurves =
		(
			OBJ.position.controller.x_position.controller = bezier_float()
			OBJ.position.controller.y_position.controller = bezier_float()
			OBJ.position.controller.z_position.controller = bezier_float()
			if classOf OBJ.controller != lookAt then
			(
				OBJ.rotation.controller.x_rotation.controller = bezier_float()
				OBJ.rotation.controller.y_rotation.controller = bezier_float()
				OBJ.rotation.controller.z_rotation.controller = bezier_float()
			)
			OBJ.scale.controller.x_scale.controller = bezier_float()
			OBJ.scale.controller.y_scale.controller = bezier_float()
			OBJ.scale.controller.z_scale.controller = bezier_float()
			
			if superClassOf OBJ == camera then
				OBJ.fov.controller = bezier_float()
		)	
		
		---------------------------------------------------------------------------------
		-- Devuelve la pista ease del objeto
		---------------------------------------------------------------------------------
		fn getMultiplierCurve = 
		(
			try 
				OBJ.pos.controller.x_position.controller.multipliercurve
			catch 
				undefined
		)	
		
		---------------------------------------------------------------------------------
		-- 	Crea la curva ease en el objeto haciendo que se reproduzca la animación 
		--	tal cual es originalmente
		---------------------------------------------------------------------------------
		fn createMultiplierCurves = 
		(
			bfc = bezier_float()
			controllers = #(OBJ.position.controller.x_position.controller,OBJ.position.controller.y_position.controller,OBJ.position.controller.z_position.controller, \
								OBJ.scale.controller.x_scale.controller,OBJ.scale.controller.y_scale.controller,OBJ.scale.controller.z_scale.controller)
			
			if classOf OBJ.controller != lookAt then 
				join controllers #(OBJ.rotation.controller.x_rotation.controller,OBJ.rotation.controller.y_rotation.controller,OBJ.rotation.controller.z_rotation.controller)	
			else
				join controllers #(OBJ.controller.roll_angle.controller)
			
			if superClassOf OBJ == camera then
				join controllers #(OBJ.fov.controller)
			
			for c in controllers do
				addMultiplierCurve c bfc
			
			OBJ.position.controller.x_position.controller.multipliercurve = 1	-- capturamos e iniciamos el controlador del multiplier curve. Está instanciado en posición, rotación y escala, así que vale cualquera de las nueve pistas
		)
		
		
		---------------------------------------------------------------------------------
		--	Devuelve la pista ease del objeto
		---------------------------------------------------------------------------------
		fn getEaseCurve = 
		(
			try 
				OBJ.position.controller.x_position.controller.ease_curve
			catch 
				undefined
		)	
		
		---------------------------------------------------------------------------------
		-- Crea la curva ease en el objeto haciendo que se reproduzca la animación 
		--	tal cual es originalmente
		---------------------------------------------------------------------------------
		fn createEaseCurves = 
		(
			addEaseCurve OBJ.transform.controller
			
			c = OBJ.position.controller.x_position.controller.easecurve.controller	-- capturamos el controlador del ease curve. Está instanciado en posición, rotación y escala, así que vale cualquera de las nueve pistas
			
			if superClassOf OBJ == camera then
			(
				addEaseCurve OBJ.fov.controller
				OBJ.fov.controller.ease_curve.controller = c
			)
			
			k1 = addNewKey c originalStart
			k2 = addNewKey c originalEnd
			k1.value = originalStart
			k2.value = originalEnd
			k1.inTangentType = k1.outTangentType = #linear
			k2.inTangentType = k2.outTangentType = #linear
			setBeforeORT c #constant
			setAfterORT c #constant
		)
		
		---------------------------------------------------------------------------------
		-- 	Indica si los controladores de la pieza que tiene el modificador
		--	TransformCache son los correctos. Tienen que ser:
		--	Position_xyz, euler_xyz y scalexyz
		---------------------------------------------------------------------------------
		fn controllersOK =
		(
			o = (refs.dependentnodes this)[1]
			if o != undefined then
			(
				t = (	(classof o.pos.controller == Position_XYZ) and \
						(classOf o.controller == lookAt or classof o.rotation.controller == Euler_XYZ) and \
						(classof o.scale.controller == ScaleXYZ))
				t
			)
			else
				false
		)
		
		---------------------------------------------------------------------------------
		-- 	Indica el estado del controlador en un mensaje de texto
		---------------------------------------------------------------------------------
		fn refreshState =
		(
			message = ""
			
-- 			if not controllersOK() then message = "- Transform controllers must be XYZ.\n"
			
			if (filename == "") then 
				append message "- No file loaded.\n"
			else if not (doesFileExist filename) then
			(
				if (getCacheFileFromSubfolders filename maxFilePath) != undefined then
					append message "- Ready: File found in subfolders.\n"
				else
					append message "- File not found.\n"
			)
			else
				append message "- Ready"
			
			lblState.text = message
		)
		
		---------------------------------------------------------------------------------
		-- Devuelve en las variables ORIGINALSTART y ORIGINALEND el primer
		-- y el último fotograma de animación que tiene cargado el objeto
		---------------------------------------------------------------------------------
		fn getAnimationRange =
		(
			if OBJ != undefined then
			(
				minTime = 10000000
				maxTime = -10000000
				
				
				if (controllersOK()) then
				(
					-- Para saber el rango cogemos la primera y la última clave de cualquier pista de posición, rotación o scala.
					-- Actualizamos tanto originalStart como recordStart y oringinalEnd y recordEnd para hacer que funcione
					-- igual que el modificador point_cache
					k = OBJ.pos.controller[1].controller.keys
					if k.count > 0 then
					(
						originalStart = recordStart = k[1].time.frame
						originalEnd = recordEnd = k[k.count].time.frame
					)
					else
					(
						originalStart = recordStart = 0
						originalEnd = recordEnd = 0
					)
				)
			)
		)
		
		
		---------------------------------------------------------------------------------
		-- 	Actualiza las claves del caché cargado en función de las variables
		--	PlaybackStart, PlaybackEnd y strength.
		---------------------------------------------------------------------------------
		fn updateKeys =
		(
			OBJ = (refs.dependentnodes this)[1]
			if OBJ != undefined then
			(
				-- aplicamos a las curvas Multiplier y Ease las operaciones necesarias
				-- para que se cumplan los parámetros de playbackStart y playbackEnd
				try
				(
					ec = OBJ.pos.x_position.controller.easecurve.controller
					
					if ec != undefined then 
					(
						ec.keys[1].time = case playbackType of
													(
														0: originalStart
														1: playbackStart
														2: playbackStart
														3: originalStart
													)
						
						ec.keys[2].time = case playbackType of
													(
														0: originalEnd
														1: originalEnd + (playbackStart - originalStart)
														2: playbackEnd
														3: originalEnd
													)
						
						if playbackType != 3 then
						(
							ec.keys[1].value = originalStart
							ec.keys[2].value = originalEnd
						)
						else
						(
							ec.keys[1].value = spnplaybackFrame.value
							ec.keys[2].value = spnplaybackFrame.value
						)
						
						if loop then
						(
							setAfterORT ec #loop
							setBeforeORT ec #loop
						)
						else
						(
							setBeforeORT ec #constant
							setAfterORT ec #constant
						)
					)
				)
				catch()
				
				try OBJ.pos.controller.x_position.controller.multiplierCurve = strength catch()
			)
		)
		
		---------------------------------------------------------------------------------
		-- 	Establece el estado de los controlles del rollout dependiendo de si
		--	la pieza tiene los controladores correctos o de si está definido o
		--	no el fichero de cache.
		---------------------------------------------------------------------------------
		fn updateControls =
		(
			for c in rollTC.controls do c.enabled = true
			
			if filename != "" then
			(
				lblfilename.text = (getfilenamefile filename) + ".xaf"
				
				ddlPlaybackType.selection = playbackType + 1
				
				case playbackType of
				(
					0: (spnplaybackStart.enabled = lblplaybackStart.enabled = spnplaybackEnd.enabled = lblplaybackEnd.enabled = spnplaybackFrame.enabled = false)
					1: (spnplaybackStart.enabled = lblplaybackStart.enabled = true; spnplaybackEnd.enabled = lblplaybackEnd.enabled = spnplaybackFrame.enabled = false)
					2: (spnplaybackStart.enabled = lblplaybackStart.enabled = spnplaybackEnd.enabled = lblplaybackEnd.enabled = true; spnplaybackFrame.enabled = false)
					3: (spnplaybackStart.enabled = lblplaybackStart.enabled = spnplaybackEnd.enabled = lblplaybackEnd.enabled = false; spnplaybackFrame.enabled = true)
				)
				
				if not fileLoaded then 	-- si no se ha cargado ningún fichero de cache desactivamos los controles que hagan falta
				(
					btnFileUnload.enabled = btnFileReload.enabled = false
					ddlPlaybackType.enabled = spnplaybackStart.enabled = spnplaybackEnd.enabled = spnplaybackFrame.enabled = spnStrength.enabled = chkRelativeOffset.enabled = false
				)
			)
			else
			(
				lblfilename.text = "Not defined"
				btnFileUnload.enabled = btnFileReload.enabled = false
				spnStrength.enabled  = chkRelativeOffset.enabled = false
				ddlPlaybackType.enabled = lblplaybackStart.enabled = lblplaybackEnd.enabled = spnplaybackStart.enabled = spnplaybackEnd.enabled = spnplaybackFrame.enabled = spnStrength.enabled = false
			)
		)
		
		----------------------------------------------------------------------------------------------------------------
		----------------------------------------------- EVENTOS ---------------------------------------------------
		----------------------------------------------------------------------------------------------------------------
		
		--------------------------------------- EVENTOS CONTROLES ---------------------------------------
		
		------------------------------------------ EVENTOS ROLLOUT ------------------------------------------ 
		
		on rollTC open do
		(
			if OBJ == undefined then
				OBJ = (refs.dependentNodes this)[1]		-- objeto al que pertenece el modificador
			
			refreshState()
			updateControls()
		)
		
		---------------------------------------------------------------------------------
		on btnFileNew pressed do
		(
			newCacheFile()
		)
		
		---------------------------------------------------------------------------------
		on btnFileLoad pressed do
		(
			f = getopenfilename types:"TC file(*.xaf)|*.xaf"
			
			if f != undefined then
			(
				undo "Load TC file" on
				(
					if superClassOf OBJ != camera then OBJ.parent = undefined
					setTCcontrollers()
					filename = f
				)
			)
				
			refreshState()
		)
		
		---------------------------------------------------------------------------------
		on btnFileUnload pressed do
		(
			undo "Unload TC file" on
				unloadCache()
			
			refreshState()
		)
		
		---------------------------------------------------------------------------------
		on btnFileReload pressed do
		(		
			reloadCache()
			refreshState()
		)
		
		---------------------------------------------------------------------------------
		on btnReset pressed do
		(
			undo "Reset TC modifier" on
				resetCache()
			
			refreshState()
		)
		
		---------------------------------------------------------------------------------
		on btnRecord pressed do 
		(
			if filename == "" then
				newCacheFile()
			
			if filename != "" then 
			(
				recordCache()
				OBJ.parent = undefined
				setTCcontrollers()
				filename = filename
			)
		)
		
		---------------------------------------------------------------------------------
		on spnplaybackFrame changed val do
		(
			undo "TC Frame Change" on
			(
				updateKeys()
			)
		)
		
		---------------------------------------------------------------------------------
		on ddlPlaybackType selected val do
		(
			undo "TC Playback Change" on
			(
				playbackType = (val - 1)
				updateKeys()
				updateControls()
			)
		)

	)
	
	
	------------------------------------------ EVENTOS PLUGIN ------------------------------------------ 
	
	---------------------------------------------------------------------------------
	on attachedToNode n do 
	(
		OBJ = n
		
		if OBJ != undefined then	-- cuando se clona el objeto también salta este evento, pero no se detecta a qué nodo pertenece
		(
			-- capturamos su transformación inicial
			originalTransform = at time -100000 OBJ.transform
			
			-- el rango de record por defecto es el que se tenga de rango de animación
			recordStart = animationRange.start
			recordEnd 	= animationRange.end
		)
	)
	
	---------------------------------------------------------------------------------
	on load do
	(
		-- Comprobamos si el fichero de cache ha sido modificado. Si es así lo cargamos de nuevo.
		if filename != "" and this.enabled then
		(
			if doesFileExist filename then
			(
				if (getFileModDate filename) != cacheFileDate then loadFileName filename
			)
			else
			(
				if maxFilePath != "" then
				(
					_filename = (getCacheFileFromSubfolders filename maxFilePath)
					if _filename != undefined then loadFileName _filename storeFilename:false
				)
			)
		)--if
	)
)