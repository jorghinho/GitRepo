(
	---------------------------------------------------------------------------
	-------------------- VARIABLES GLOBALES --------------------------
	---------------------------------------------------------------------------
	
	--Variables---------------------------------------------------------------
	
	--Rollouts----------------------------------------------------------------

	--Funciones--------------------------------------------------------------

	--LB arrays--------------------------------------------------------------
	
	---------------------------------------------------------------------------
	-------------------- INCLUDES ----------------------------------------
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	-------------------- FUNCIONES --------------------------------------
	---------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------------------------------
	-- crea un sistema de pseudomusculos con huesos que hacen stretch
	-- BONECHAIN: array con la cadena de huesos
	-- Devuelve CONTROLPOINTS, que son los puntos de control del sistema
	----------------------------------------------------------------------------------------------------------------
	fn createStretchBoneChain boneChain =
	(
		controlPoints = #() --array deonde almacenar los puntos de control del sistema
		
		p = point box:true cross:false size:5 name:"pointChain-00" --punto de referencia
				
		-- creamos todos los points de la cadena y los colocamos
		for i = 1 to (boneChain.count) do
			if classof boneChain[i] == BoneGeometry then 
			(
				refName = boneChain[i].name
				nameParts = filterString refName "_"
				
				pnt = instance p
				pnt.wirecolor = [255,255,0]
				
				append controlPoints pnt
				
				if lb.nc.ncOK boneChain[i].name then
					controlPoints[i].name = substituteString refName ("_" + nameParts[5] + "_") ("_" + nameParts[5] + "Point" + "_")
				
				controlPoints[i].transform =  boneChain[i].transform
				
				if i > 1 then
					controlPoints[i].parent = controlPoints[1]
				
				lb.nc.setFlags controlPoints[i] #(NC_automaticFlag, NC_frozenFlag, NC_hiddenFlag) -- cambia los últimos flags por los especificados.
				lb.controller.freezeTransform controlPoints[i] #all
			)
		
		delete p --borramos el point de referencia
		
		--emparentamos el primer hueso al primer point
		boneChain[1].parent = controlPoints[1]	
			
		-- asignamos los controladores a cada hueso
		for i = 1 to (boneChain.count) do
			if classof boneChain[i] == BoneGeometry then 
			(
				lb.controller.freezeTransform boneChain[i] #all --freeze del hueso
				
				posCon = boneChain[i].position.controller.available.controller = position_constraint()
				posCon.appendTarget controlPoints[i] 50
				
				if i != boneChain.count then
				(					
					lookAtCon = boneChain[i].rotation.controller.available.controller = lookat_constraint()
					
					if boneChain[i].objectOffsetScale == [-1,1,1] then
						lookAtCon.target_axisFlip = on
							
					lookAtCon.appendtarget controlPoints[i+1] 50
					lookAtCon.lookat_vector_length = 0
					lookAtCon.upnode_world = off
					lookAtCon.pickupnode = controlPoints[i] 				
				)
			)
			
		controlPoints
	)
	----------------------------------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------------------------------
	-- función que genera la solución
	----------------------------------------------------------------------------------------------------------------
	fn generateSolution boneChain =
	(
		success = false --flag para saber si ha realizado correctamente todas las operaciones
		
		proceed = true --flag para saber si aplicar la solucion
		
		--comprobamos que el array es un array de huesos
		if classof boneChain == Array then
		(
			for bon in boneChain do
				if classof bon != BoneGeometry then
					proceed = false
		)
		else
			proceed = false
		
		--si procede genera el sistema
		if proceed then
			createStretchBoneChain boneChain
		
		success	
	)
	
	----------------------------------------------------------------------------------------------------------------
	--limipia las variables globales usadas por la solucion
	----------------------------------------------------------------------------------------------------------------
	fn clearSolution =
	(
		createStretchBoneChain		= undefined
		
		generateSolution					= undefined
		removeSolution					= undefined
		clearSolution						= undefined
	)	
	
	
	---------------------------------------------------------------------------
	-------------------- ROLLOUTS ----------------------------------------
	---------------------------------------------------------------------------

	---------------------------------------------------------------------------
	-------------------- MACROSCRIPTS -----------------------------------
	---------------------------------------------------------------------------

	---------------------------------------------------------------------------
	-------------------- EJECUCION ---------------------------------------
	---------------------------------------------------------------------------

)