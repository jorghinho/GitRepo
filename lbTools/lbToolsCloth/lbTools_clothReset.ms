(
	-- FN CAPTURA DE OBJETOS DEL MODIFICADOR CLOTH, devuelve un array de structs
	fn getClothObjectProperties clothMod =
	(
		-- VARIABLES
		_clothObjects = #() --array con los nombres de los objetos en el cloth
		_clothGroups = #() --array con los nombres de los grupos en el cloth
		
		--STRUCTS
		struct clothObj_name
		(
			-- propiedades no listadas en showObjectProperties() pero necesarias tales como el nombre del asset o el tipo de objeto
			clothObj = undefined,
			objectType = undefined,
			
			-- propiedades genéricas del obj
			bend = undefined,
			bCurve = undefined,
			stretch = undefined,
			shear = undefined,
			density = undefined,
			thickness = undefined,
			repulsion = undefined,
			damping = undefined,
			airres = undefined,
			dynFric = undefined,
			staticFric = undefined,
			selfFric = undefined,
			seamForce = undefined,
			uScale = undefined,
			vScale = undefined,
			useEdgeSprings = undefined,
			useSolidFriction = undefined,
			depth = undefined,
			offset = undefined,
			enableCollisions = undefined,
			uBend = undefined,
			vBend = undefined,
			uBCurve = undefined,
			vBCurve = undefined,
			uStretch = undefined,
			vStretch = undefined,
			keepShape = undefined,
			plasticity = undefined,
			layer = undefined,
			compress = undefined,
			uCompress = undefined,
			vCompress = undefined,
			isCutter = undefined,
			pressure = undefined,
			pressure_damp = undefined,
			keep_shape_bend_strength = undefined,
			keep_shape_stretch_strength = undefined,
			track_volume = undefined,
			cap_holes = undefined,
			inherit_velocity = undefined
		)
		
		if classof clothMod == Cloth then --sólo entra si es de cloth
		(
			for i=1 to clothMod.numsubs do  --capturamos los grupos
			(	
				_name = filterstring clothMod[i].name "_"
				if _name[1] == "grp" then 
				(
					append _clothGroups clothMod[i].name
				)
			)
			
			--sacamos los objetos y los metemos en el array _clothObjects
			_numObjs = (clothMod.numsubs - _clothGroups.count)
			for i = 2 to _numObjs do
			(
				append _clothObjects clothMod[i].name
			)
			
			_clothObjsProperties = #() --array con los struct con las propiedades de los objetos asignados al cloth
			
			-------------------------------------
			-- creamos y rellenamos el struct de los objetos según su número, array de structs
			-------------------------------------
			for i=1 to _clothObjects.count do
			(
				append _clothObjsProperties (clothObj_name())--
					
				( -- propiedades no listadas
				--capturamos el nombre del objeto
				_clothObjsProperties[i].clothObj = substituteString _clothObjects[i] "_properties" ""
				--capturamos el tipo de objeto (collision, cloth o inactive)
				_node = "$'" + _clothObjsProperties[i].clothObj + "'"
				_clothObjsProperties[i].objectType = clothMod.getObjectType (execute _node)
				)
				
				( --propiedades listadas en showObjectProperties()
					
				)
			)
			
			
			
		)
		_clothObjsProperties
	)
	
	-- FN CAPTURA DE GRUPOS DEL MODIFICADOR CLOTH, devuelve un array de structs
	fn getClothGroupProperties clothMod =
	(
		--VARIABLES
		_clothGroups = #() --array con los nombres de los grupos en el cloth
		
-- 		struct clothGrp_name
-- 		(
-- 			
-- 		)
		
		if classof clothMod == Cloth then --sólo entra si es de cloth
		(
			for i=1 to clothMod.numsubs do  --capturamos los grupos
			(	
				_name = filterstring clothMod[i].name "_"
				if _name[1] == "grp" then 
				(
					append _clothGroups clothMod[i].name
				)
			)
		)
	)
	
	-- FN CAPTURA DE PROPIEDADES GLOBALES DEL MODIFICADOR CLOTH, devuelve un struct en una variable
	fn getClothGlobalProperties clothMod =
	(
		-- VARIABLES
		_clothProperties = undefined
				
		struct clothProperties_name
		(
			--propiedades generales
			gravity = undefined,
			selfCollision = undefined,
			solidCollision = undefined,
			scale = undefined,
			useSewingSprings = undefined,
			startFrame = undefined,
			timestep = undefined,
			showSewingSprings = undefined,
			subsample = undefined,
			endFrame = undefined,
			enableEndFrame = undefined,
			checkIntersections = undefined,
			clothclothMethod = undefined,
			useGravity = undefined,
			simOnRender = undefined,
			simPriority = undefined,
			advancedPinching = undefined,
			relativeVelocity = undefined,
			timeScale = undefined,
			ignoreBackfacing = undefined,
			simOnMouseDown = undefined,
			showCurrentState = undefined,
			showTargetState = undefined,
			showEnabledSolidCollision = undefined,
			showEnabledClothCollision = undefined,
			showTension = undefined,
			tensionScale = undefined,
			weldMethod = undefined
		)

		if classof clothMod == Cloth then --sólo entra si es de cloth
		(
			-------------------------------------
			-- creamos y rellenamos el struct de propiedades genéricas
			-------------------------------------
			_clothProperties = clothProperties_name() --instanciamos el Struct
			
		   _propNames = getPropNames clothMod
		   
			for _prop in _propNames do
			(
				if isProperty _clothProperties _prop then
				(
					setProperty _clothProperties _prop (getProperty clothMod _prop)
				)
			)
		)
		_clothProperties
	)
	
	-- FN RESETEO MODIFICADOR CLOTH
	fn resetClothModifier obj clothMod =
	(
		--VARIABLES
		_globalProperties = getClothGlobalProperties clothMod
-- 		_groupProperties = getClothGroupProperties clothMod
		_objectProperties = getClothObjectProperties clothMod
		
		if classof clothMod == Cloth then --sólo entra si es de cloth
		(		
			--eliminamos el modificador buscando primero su index
			_modifiers = for m in obj.modifiers collect m
			_index = findItem _modifiers clothMod
			if _index != 0 then deletemodifier obj _index
				
			--añadimos el modificador cloth de nuevo
			lb.cloth.addClothModifier obj
			
			--volcamos las propiedades globales
			(
				_propNames = getPropNames _globalProperties
			   
				for _prop in _propNames do
				(
					if isProperty clothMod _prop then
					(
						setProperty clothMod _prop (getProperty _globalProperties _prop)
					)
				)
			)
		)
		
	)
)