(
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- COSAS A REVISAR
	-- **Función lb.rig.hideShowPuppet dentro del riggingFunction. Ahora mismo el nombre no es del todo intuitivo, es necesario revisarla entera, organizar el codigo comentarla.
	-- ** Crear función parecida al lb.rig.hideShowPuppet pero que revise automaticamente el lado al que pertenece y le aplique el color correspondiente ya establecido.
	
	
	
	
	
	
	
	
	
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- Cadena de Fk
-- 	local fkForearm = $'chr_armSolution_rig_r_foreArmFK_x_fh'
-- 	local fkForearmEnd = $'chr_armSolution_rig_r_foreArmFKEnd_x_fh'
-- 	local fkUpperarm = $'chr_armSolution_rig_r_upperArmFK_x_fh'
-- 	local refElbowIK = $'chr_armSolution_rig_r_refElbowIK_x_fh'
-- 	
-- 	-- Cadena final
-- 	local forearm = $'chr_armSolution_rig_r_foreArm_x_d'
-- 	local upperarm = $'chr_armSolution_rig_r_upperArm_x_d'
-- 	
-- 	--Cadena de Ik
-- 	local ikForearm = $'chr_armSolution_rig_r_foreArmIK_x_fh'
-- 	local ikUpperarm = $'chr_armSolution_rig_r_upperArmIK_x_fh'
-- 	local ikHand = $'chr_armSolution_rig_r_handIk_x_c'
-- 	local ikElbow = $'chr_armSolution_rig_r_elbow_x_c'


	----------------------------------------------------------------
	-- Almacenamiento de huesos duplicados finales de RIG
	----------------------------------------------------------------
	struct rigNodes
	(
		clavicle = undefined,
		clavicleEnd = undefined,
		forearm = undefined,
		upperarm = undefined,
		hand = undefined,
		finger = #() -- almacenamiento de dedos.
	)
	
	rigNodes = rigNodes clavicle: undefined clavicleEnd:undefined forearm:undefined upperarm:undefined hand:undefined finger:#()
	
	----------------------------------------------------------------
	-- Almacenamiento de huesos duplicados de FK
	----------------------------------------------------------------
	-- Nodos del esqueleto de rig final
	struct fkNodes
	(
		fkUpperarm = undefined,
		fkForearm = undefined,
		fkHand = undefined,
		refElbowIK = undefined
	)
	
	fkNodes = fkNodes fkUpperarm: undefined fkForearm:undefined fkHand:undefined refElbowIK:undefined
	
	----------------------------------------------------------------
	-- Almacenamiento de huesos duplicados de IK
	----------------------------------------------------------------
	struct ikNodes
	(
		ikUpperarm = undefined,
		ikForearm = undefined,
		ikElbow = undefined,
		ikHand = undefined
	)

	ikNodes = ikNodes ikUpperarm: undefined ikForearm:undefined ikElbow:undefined ikHand:undefined
	
	/*
	---------------------------------------------------------------------------------------------------
	------------------------------------------CUSTOM ATTRIBUTES ------------------------------------------
	----------------------------------------------------------------------------------------------------------------
	
	-- Custom Attribute
	CA_ARS_fkIkArm = attributes fkIkSnaps 
	(
		-- Parametros Ca
		parameters main rollout:rollFkIk
		(
			-- Controles
			fkik type:#float ui:(snpFkIk, sldFkIk)
-- 			followElbow type:#float ui:(spnFollowElbow, sldFollowElbow)
			
			-- Cadena de Fk
			fkForearm type:#maxObject
			fkUpperarm type:#maxObject
			fkForearmEnd type:#maxObject
			refElbowIK type:#maxObject
			
			-- Cadena final
			forearm type:#maxObject
			upperarm type:#maxObject
			
			--Cadena de Ik
			ikForearm type:#maxObject
			ikUpperarm type:#maxObject
			ikHand type:#maxObject
			ikElbow type:#maxObject			
		)
		
		--------------------------
		-- Funciones de snap de fk a ik. Se alinea la cadena de ik (ikhand y ikElbow) con el final de 
		-- la cadena de huesos de fk y el punto de refenrecia del brazo para el swiverAngle de la ik.
		-- Establecemos valor 1 del spinner de fkIk y controlamos la selección de las piezas.
		--------------------------
		fn fkIkSnap =
		(
			ikHand.node.transform = fkForearmEnd.node.transform
			ikElbow.node.transform = refElbowIK.node.transform
			
			upperarm.node.modifiers[#Arm_Controls].fkik = 1.0
			select ikHand.node
		)
		
		--------------------------
		-- Funciones de snap de ik a fk. Se alinea la cadena de fk (foreArm y upperArm) con la cadena de ik.
		-- Establecemos valor 0 del spinner de fkIk y controlamos la selección de las piezas.
		--------------------------
		fn ikFkSnap =
		(
			fkUpperarm.node.transform = ikUpperarm.node.transform
			fkForearm.node.transform = ikForearm.node.transform
			
			upperarm.node.modifiers[#Arm_Controls].fkik = 0
			
			-- Control de selección.
			if selection[1] != ikHand.node then		
				select selection	
			else 
				select forearm.node
		)
		
		------------------------------------------------------------------------------
		----------------------------Rollout -----------------------------------------
		------------------------------------------------------------------------------
		rollout rollFkIk "Arm Controls"
		(
			spinner snpFkIk "FK_IK" range:[0,1,1]
			slider sldFkIk "" range:[0,1,1]
			
-- 			spinner spnFollowElbow "Follow_Elbow" range:[0,1,1] -- offset:[0,5]
-- 			slider sldFollowElbow "" range:[0,1,1]
			
			button btnFkIkSnap "Ninguno" pos:[3,80] width:155 height:30 -- Boton de Fk/Ik Snap que ejecuta la función fkIkSnap.
			
			--------------------------------------------------
			---------- Eventos del custAttribute----------	
			--------------------------------------------------
			on rollFkIk open do
			(
				if upperarm.node.modifiers[#Arm_Controls].fkik > 0 then
					btnFkIkSnap.caption = "Ik to Fk"
				else
					btnFkIkSnap.caption = "Fk to Ik"
			)
			
			on btnFkIkSnap pressed do
			(
				undo "Fk/Ik Snap" on
				(
					if upperarm.node.modifiers[#Arm_Controls].fkik == 1.0 then
						upperarm.node.modifiers[#Arm_Controls].rollFkIk.btnFkIkSnap.caption = "IkToFk"
					else
						upperarm.node.modifiers[#Arm_Controls].rollFkIk.btnFkIkSnap.caption = "FkToIk"
					
					if upperarm.node.modifiers[#Arm_Controls].fkik > 0 then
						ikFkSnap ()
					else -- Fk to Ik
						fkIkSnap ()

				)--undo
			)--on btn	
		)--rollout 
	)--CA
	
	(-- Añadimos modificador

		clearSelection()
		custMod = (EmptyModifier ())	
		custMod.name = "Arm_Controls"
			
		if upperarm.modifiers.count != 0 then deleteModifier upperarm 1
		if forearm.modifiers.count != 0 then deleteModifier forearm 1
		if ikHand.modifiers.count != 0 then deleteModifier ikHand 1	
		if ikElbow.modifiers.count != 0 then deleteModifier ikElbow 1		

		AddModifier upperarm custMod
		AddModifier forearm custMod
		AddModifier ikHand custMod	
		AddModifier ikElbow custMod	
		
		custAttributes.add upperarm.modifiers[#Arm_Controls] CA_ARS_fkIkArm #unique

	)--
	
	------------------------------------------------------------------------	
	-- Función para rellenar los nodos dentro del Custom attribute
	------------------------------------------------------------------------
	fn fillCaParameters =
	(	
-- 		upperarm.modifiers[#Arm_Controls].fkForearm = (nodeTransformMonitor node:fkForearm forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
		upperarm.modifiers[#Arm_Controls].fkUpperarm = (nodeTransformMonitor node:fkUpperarm forwardTransformChangeMsgs:false) 
		upperarm.modifiers[#Arm_Controls].fkForearmEnd = (nodeTransformMonitor node:fkForearmEnd forwardTransformChangeMsgs:false) 
		upperarm.modifiers[#Arm_Controls].refElbowIK = (nodeTransformMonitor node:refElbowIK forwardTransformChangeMsgs:false) 
		
		upperarm.modifiers[#Arm_Controls].forearm = (nodeTransformMonitor node:forearm forwardTransformChangeMsgs:false) 
		upperarm.modifiers[#Arm_Controls].upperarm = (nodeTransformMonitor node:upperarm forwardTransformChangeMsgs:false) 
				
		upperarm.modifiers[#Arm_Controls].ikHand = (nodeTransformMonitor node:ikHand forwardTransformChangeMsgs:false)
		upperarm.modifiers[#Arm_Controls].ikElbow = (nodeTransformMonitor node:ikElbow forwardTransformChangeMsgs:false)
		upperarm.modifiers[#Arm_Controls].ikForearm = (nodeTransformMonitor node:ikForearm forwardTransformChangeMsgs:false)
		upperarm.modifiers[#Arm_Controls].ikUpperarm = (nodeTransformMonitor node:ikUpperarm forwardTransformChangeMsgs:false)
	)		
	
	----------------------------------------------------------------------------------------
	-- Función para conectar los controles del Ca con los constraints de los huesos.
	----------------------------------------------------------------------------------------
	fn setArmControls =
	(
		paramWire.connect upperarm.modifiers[#Arm_Controls].fkIkSnaps[#fkik] upperarm[#transform][#rotation][#weights][#Weight__IK_Controller] "fkik"
		paramWire.connect upperarm.modifiers[#Arm_Controls].fkIkSnaps[#fkik] upperarm[#transform][#rotation][#weights][#Weight__FK_Controller] "1-fkik"
		paramWire.connect forearm.modifiers[#Arm_Controls].fkIkSnaps[#fkik] forearm[#transform][#rotation][#weights][#Weight__IK_Controller] "fkik"
		paramWire.connect forearm.modifiers[#Arm_Controls].fkIkSnaps[#fkik] forearm[#transform][#rotation][#weights][#Weight__FK_Controller] "1-fkik"
		
		ikHand.scale.controller[#Zero_Scale_XYZ].controller.x_scale.controller = upperarm.modifiers[#Arm_Controls].fkik.controller
		ikHand.scale.controller[#Zero_Scale_XYZ].controller.y_scale.controller = upperarm.modifiers[#Arm_Controls].fkik.controller
		ikHand.scale.controller[#Zero_Scale_XYZ].controller.z_scale.controller = upperarm.modifiers[#Arm_Controls].fkik.controller
		
		ikElbow.scale.controller[#Zero_Scale_XYZ].controller.x_scale.controller = upperarm.modifiers[#Arm_Controls].fkik.controller
		ikElbow.scale.controller[#Zero_Scale_XYZ].controller.y_scale.controller = upperarm.modifiers[#Arm_Controls].fkik.controller
		ikElbow.scale.controller[#Zero_Scale_XYZ].controller.z_scale.controller = upperarm.modifiers[#Arm_Controls].fkik.controller
	)
	*/
	
	---------------------------------------------------------------------------------------------------------------------------------
	-- Recorre objects obteniendo los huesos de skin de la escena de la parte indicada y del lado indicado.
	-- PART: puede valer #SPINE, #ARM, #LEG, - indica la parte que queremos obtener
	-- SIDE: puede valer NC_locationLeft, NC_locationRight NC_locationMiddle
	-- ALL: parametro opcional para obtener todos los nodos de una partes, o evitar capturar los nodos indexadas de una parte;
	-- por defecto está a TRUE, pero si solo se quiere obtener el brazo sin dedos se pondría a FALSE,
	--*** EXCLUDE: parametro opcional para poder excluir un array de huesos que no queramos que capture***
	----------------------------------------------------------------------------------------------------------------------------------
	fn getSkinBonesParts part side all:true /*exclude:"boneName"*/ =
	(
		-- Array para guardar los huesos de las partes correspondientes
		local skinBones = #()
		
		for b in objects do
		(
			-- Filtramos el nombre para obtener la clase y el lado correspondiente que se le pase.
			nameParts = filterString b.name "_" 
			if nameParts[3] == NC_classSkin then 
			(
				if nameParts[4] == side then
				(
					case part of
					(	
						-- obtiene los huesos de la spine
						#spine:
						(
							case nameParts[5] of
							(
								"root": append skinBones b
								"pelvis": append skinBones b
								"head": append skinBones b
								"neck": append skinBones b
								-- Para cuando obtener todas las piezas de la spine indexadas.
								default:
									if (findstring nameParts[5] "spine") != undefined and all then
										append skinBones b

							)-- End of case.
						)-- if nameparts 4
						
						-- Obtiene los huesos del brazo
						#arm:
						(	
							case nameParts[5] of
							(
								"clavicle": append skinBones b
								"upperarm": append skinBones b
								"forearm": append skinBones b
								"hand": append skinBones b
								-- Para cuando obtener todas las piezas de la mano indexadas.
								default: 
									if (findstring nameParts[5] "finger") != undefined and all then -- si la parte 5 del nombre contiene "spine" añade el bone al array ARM.
										append skinBones b
							)
						)-- End of case.
-- 						
-- 						-- obtiene los huesos del brazo
						#leg:
						(
							case nameParts[5] of
							(
								"pelvis": append skinBones b
								"thigh": append skinBones b
								"calf": append skinBones b
								"instep": append skinBones b
								"toes": append skinBones b
								
								default: 
									if (findstring nameParts[5] "toe") != undefined and all then -- si la parte 5 del nombre contiene "spine" añade el bone al array ARM.
										append skinBones b
							)
						)-- End of case.
					)-- case part
				)-- if side
			)--is classSkin		
		) -- for b
		
		skinBones
	)-- end fn

	---------------------------------------------------------------------------------------------------------------------------------
	-- Crea las cadenas de huesos de fkIk duplicando la cadena de huesos que se le pase, con su respectiva jerarquia. Después de la
	-- rellena el struct correspondiente de la cadena de huesos.
	-- BONECHAIN: Necesita que se le pase array de huesos
	-- CHAINTYPE: Parametro opcional por si queremos crear solo la cadena de fk o de ik. #ALL para crear las dos cadenas,
	-- parametro por defecto, #FK: cadena de fk, IK: cadena de ik. #RIG
	----------------------------------------------------------------------------------------------------------------------------------
	fn createFkIkChains boneChain chainType:#all =
	(
		_bonesCloned = #()
		_tempBon = #()
		_filterParts = undefined
		
		
		-- Por cada tipo de parametro pasado duplicamos los huesos, los renombramos y los almacenamos en "boneChain"
		-- que utilizaremos más tarde para recorrerlos.
			if chainType == #all or chainType == #rig then
			(
				maxOps.CloneNodes boneChain newNodes: &_tempBon
				
				for b in _tempBon do
				(
					_filterParts = filterString b.name "_"
					_nameParts = _filterParts[1] + "_" + _filterParts[2] + "_" + NC_classAnim + "_" + _filterParts[4] + "_"  + _filterParts[5]+ "_"  + _filterParts[6] + "_"  + NC_duplicatedFlag
					b.name = _nameParts	
				)
					
				-- Aplicamos el color determinado respecto al lado del personaje.
				if _filterParts[4] == NC_locationLeft then
					lb.rig.hideShowPuppet _tempBon clrBlue clrBlueEnd
				else if _filterParts[4] == NC_locationRight then
					lb.rig.hideShowPuppet _tempBon clrGreen clrGreenEnd
 		
				_bonesCloned = ( _bonesCloned + _tempBon)
			)
			
			
			(-- Borramos la clavicula y los dedos ya que no trabajaremos con ellas en las cadenas de fk y de ik.
				_bonToDel = #()
				
				for i = 1 to _tempBon.count do
					if (findString  _tempBon[i].name "clavicle") != undefined or (findString  _tempBon[i].name "finger") != undefined then		
						append _bonToDel i
				
				for i =  _bonToDel.count to 1 by -1 do
					deleteItem _tempBon _bonToDel[i]
			)
			
			-- Se clonan los huesos para formar la cadena de Fk.
			if chainType == #all or chainType == #fk then
			(
				maxOps.CloneNodes _tempBon newNodes: &_tempBon
				
				for b in _tempBon do
				(
					_filterParts = filterString b.name "_"
					_nameParts = _filterParts[1] + "_" + _filterParts[2] + "_" + NC_classAnim + "_" + _filterParts[4] + "_"  + (_filterParts[5] + "Fk")+ "_"  + _filterParts[6] + "_"  + (NC_frozenFlag + NC_hiddenFlag)
					b.name = _nameParts
				)
				
				_tempBon.wirecolor = color 0 252 0 
				_tempBon.backfin = on
				_tempBon.backfinsize = 5

				_bonesCloned = ( _bonesCloned + _tempBon)
			)
			
			-- Se clonan los huesos para formar la cadena de Ik.
			if chainType == #all or chainType == #ik then
			(
				maxOps.CloneNodes _tempBon newNodes: &_tempBon
				
				for b in _tempBon do
				(
					_filterParts = filterString b.name "_"
					_nameParts = _filterParts[1] + "_" + _filterParts[2] + "_" + NC_classAnim + "_" + _filterParts[4] + "_"  + (_filterParts[5] + "Ik")+ "_"  + _filterParts[6] + "_"  + (NC_frozenFlag + NC_hiddenFlag)
					b.name = _nameParts
				)
				
				_tempBon.wirecolor = color 252 0 0
				_tempBon.frontfin = on
				_tempBon.frontfinsize = 5
				_tempBon.backfin = off
				
				_bonesCloned = ( _bonesCloned + _tempBon)
			)
			
		-- Recorremos las cadenas almacenadas de rig, Fk, Ik, para almacenarlas en los structs de las cadenas.
		for b in _bonesCloned do
		(
			_filterParts = filterString b.name "_"
			
			if chainType == #all or chainType == #rig then
			(
				case _filterParts[5] of
				(
					"clavicle": rigNodes.clavicle = b
					"upperarm": rigNodes.upperarm = b
					"forearm": rigNodes.forearm = b
					"hand": rigNodes.hand = b
					
					-- Para cuando obtener todas las piezas de la mano indexadas.
					default: 
						if (findstring _filterParts[5] "finger") != undefined then
						(
							_tempArray= #()
							
							append _tempArray b
-- 							rigNodes.finger = _tempArray
						)
				)
			)
			else if chainType == #all or chainType == #fk then
			(
				case _filterParts[5] of
				(
					"upperarmFk": rigFkNodes.fkUpperarm = b
					"forearmFk": rigFkNodes.fkForearm = b
					"handFk": rigFkNodes.fkHand = b
				)
			)
			else if chainType == #all or chainType == #ik then
			(
				case _filterParts[5] of
				(
					"upperarmIk": rigIkNodes.ikUpperarm = b
					"forearmIk": rigIkNodes.ikForearm = b
					"ikElbow": rigIkNodes.ikElbow = b
					"handIk": rigIkNodes.ikHand = b
				)
			)-- elseIf
		)-- for b
	)-- end fn 

-- 	fillCaParameters()
-- 	setArmControls()
)-- end macro
