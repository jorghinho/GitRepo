(
	---------------------------------------------------------------------------
	-------------------- VARIABLES ----------------------------------------
	---------------------------------------------------------------------------
	

	--Variables---------------------------------------------------------------
	local chrName = undefined
	local chrLayer = undefined
	local sidePart = undefined
	local frontBackPart = undefined
	local frontBackPartString = ""
	
	-- Partes Fk Pata. Se rellenan abajo en la función 'prepareSolution'.
	local animalLegPart01 = undefined -- corresponde a partes de hombro(shoulder) o pelvis lateral (pelvis)
	local animalLegPart02 = undefined -- corresponde a partes de upperarm o thigh.
	local animalLegPart03 = undefined -- corresponde a partes de forearm o lower thigh.
	local animalLegPart04 = undefined -- corresponde a partes de pastern o rear pastern.
	local animalLegPart05 = undefined -- corresponde a parte de instep.
	local animalLegPart06 = undefined -- corresponde a parte de toes.
	local animalLegPart07 = undefined -- corresponde a parte de toesEnd.
	local animalLegPartToeIn = undefined -- corresponde a parte de cada uno de los Toes que tenga la zarpa.
	local animalLegPartToeOut = undefined -- corresponde a parte de cada uno de los Toes que tenga la zarpa.

	-- Partes Paw.
	local pawprintPart = "pawprint_"
	local pivotPawHeelPart = "pivotPawHeel_"
	local pivotPawOutsidePart = "pawPivotOutside_"
	local pivotPawInsidePart = "pawPivotInside_"
	
	selectionSet
	
	local bodyParts = #(RS_ARS_animalLegPawFront, RS_ARS_animalLegPawRear)
	
	
	---------------------------------------------------------------------------
	-------------------- INCLUDES ----------------------------------------
	---------------------------------------------------------------------------
	
	
	----------------------------------------------------------------------------------------------------------------
	------------------------------------------CUSTOM ATTRIBUTES ------------------------------------------
	----------------------------------------------------------------------------------------------------------------
	
	CA_ARS_fkIkAnimalLeg = attributes fkIkSnaps -- Custom Attributes FK/IK Snap
	(
		parameters main rollout:rollFkIk
		(
			fkik type:#float ui:(snpFkIk, sldFkIk)
			followJoint type:#float ui:(spnFollowJoint, sldFollowJoint)
			fixAnimalLeg type:#float ui:(spnfixAnimalLeg, sldfixAnimalLeg)
			fkikPaw type:#float ui:(spnFkIkPaw, sldFkIkPaw)
			fixPaw type:#float ui:(spnFixPaw, sldFixPaw)
			
			fkAnimalLegBone02Snap type:#maxObject -- FK Upperarm / thigh
			fkAnimalLegBone03Snap type:#maxObject -- FK Forearm / lowerThigh
			fkAnimalLegBone04Snap type:#maxObject -- FK pastern / rearPastern
			fkPawSnap type:#maxObject -- FK front / rear Paw
			fkAnimalLegBone06Snap type:#maxObject -- FK front / rear Toes.
			fkJointOrientSnap type:#maxObject -- FK front / rear punto de referencia para rodilla.
			fkToesSnap type:#maxObjectTab tabSizeVariable:true
			
			ikAnimalLegBone02Snap type:#maxObject -- IK Upperarm / thigh
			ikAnimalLegBone03Snap type:#maxObject -- IK Forearm / lowerThigh
			ikAnimalLegBone04Snap type:#maxObject -- IK pastern / rearPastern
			ikJointOrientSnap type:#maxObject -- IK elbow / knee control
			ikPasternRotationPointSnap type:#maxObject -- hueso orientación automática de jointOrient.
			ikPawprintSnap type:#maxObject -- IK footStep
			ikAnimalLegBone06Snap type:#maxObject -- IKfront / rear Toes.
			ikAnimalLegBone07Snap type:#maxObject -- IKfront / rear ToesEnd.
			ikToesSnap type:#maxObjectTab tabSizeVariable:true
			
			sidePart type:#string
		)
		
		
		
		fn ikToFkSnap keepSelection:false =
		(
			DisableSceneRedraw() -- Desactivado del redibujado de pantalla para que no se vean en el visor las operaciones que realiza.
			
			-- Almacenado en variables de las transformaciones IK de la pierna.
			ikAnimalLegBone02Trans = ikAnimalLegBone02Snap.node.transform
			ikAnimalLegBone03Trans = ikAnimalLegBone03Snap.node.transform
			ikAnimalLegBone04Trans = ikAnimalLegBone04Snap.node.transform
			ikpawTrans = fkPawSnap.node.transform
			ikAnimalLegBone06Trans = ikAnimalLegBone06Snap.node.transform
			ikJointOrientTrans = ikJointOrientSnap.node.transform
			
			ikPawprintSnap.node.modifiers[#Animal_Leg_Controls].fkik.controller.value = 0.0 -- Asignación de valor 0 al atributo FK/IK fkikLeg.
			
			fkPawSnap.node.position.controller.active = 3
			fkPawSnap.node.rotation.controller.active = 3
			fkAnimalLegBone04Snap.node.rotation.controller.active = 3
			fkAnimalLegBone06Snap.node.rotation.controller.active = 3
			
			
			-- Locks en Fk.
			setTransformLockFlags fkAnimalLegBone02Snap.node #{1..3,7..9}
			setTransformLockFlags fkAnimalLegBone03Snap.node #{1..5,7..9}
			setTransformLockFlags fkAnimalLegBone04Snap.node #{1..5,7..9}
			setTransformLockFlags fkPawSnap.node #{1..3,7..9}
			setTransformLockFlags fkAnimalLegBone06Snap.node #{1..3,7..9}
			
			-- Oculta Huella
			-- hide ikPawprintSnap.node
			
			-- Asigación de las transformaciones almacenadas anteriormente.
			fkAnimalLegBone02Snap.node.transform = ikAnimalLegBone02Trans
			fkAnimalLegBone03Snap.node.transform = ikAnimalLegBone03Trans
			fkAnimalLegBone04Snap.node.transform = ikAnimalLegBone04Trans
			fkPawSnap.node.transform = ikpawTrans
			fkJointOrientSnap.node.transform = ikJointOrientTrans

			if ikPawprintSnap.node.modifiers[#Animal_Leg_Controls].fkIkPaw.controller.value > 0.0 then
				fkAnimalLegBone06Snap.node.transform = ikAnimalLegBone06Trans
			
			-- Controlador activo para posición y rotación en Fk. Forzado del cambio de los controlado y los Locks en el estafo FK, para poder pasarle las nuevas transformaciones.
			-- Cambio de controlador activo.
			
			
			fkPawSnap.node.scale.controller[#Zero_Scale_XYZ].value = [1,1,1]
	-- 		fkPawSnap.node.scale.value = [1,1,1]
			fkAnimalLegBone06Snap.node.position.controller[#Zero_Pos_XYZ].value = [0,0,0]
			fkAnimalLegBone06Snap.node.scale.controller[#Zero_Scale_XYZ].value = [1,1,1]
	-- 		fkAnimalLegBone06Snap.node.scale.value = [1,1,1]
			
			if keepSelection == false then
			(
				if selection[1] == ikPawprintSnap.node or selection[1] == ikJointOrientSnap.node then
					select fkPawSnap.node -- Selección del pie, para tener algún elemento FK seleccionado y poder aplicarle alguna transformación o subier y bajar por la jerarquía FK.			
			)
			
			-- Snap Toes
			for i = 1 to fkToesSnap.count do
			(
				fkToesSnap[i].node.rotation.controller.active = 3
				fkToesSnap[i].node.transform = ikToesSnap[i].node.transform
				
				nameParts = filterString fkToesSnap[i].node.name "_"
				
				if nameParts[4] == "l" then
					fkToesSnap[i].node.scale = [-1,-1,-1]
				else if nameParts[4] == "r" then
					fkToesSnap[i].node.scale = [1,1,1]
			)
			
			enableSceneRedraw() -- Reactivado del redibujado del visor.
			completeRedraw() -- Redibujado.
			
			this.rollFkIk.btnFkIkSnap.caption = "Fk to Ik" -- Cambio del nombre del botón para que muestre el estado actual y el de cambio.
			
		)
		
		
		
		fn fkToIkSnap keepSelection:false =
		(
			local fkToesTransforms = #()
			
			-- Almacenado en variables de las transformaciones FK de la pierna.
			fkPawTrans = fkPawSnap.node.transform
			fkJointOrientTrans = fkJointOrientSnap.node.transform
			fkAnimalLegBone04Trans = fkAnimalLegBone04Snap.node.transform
			fkAnimalLegBone06Trans = fkAnimalLegBone06Snap.node.transform
			-- fkAnimalLegBone04ParentTrans = in coordSys parent fkAnimalLegBone04Snap.node.rotation
			for i = 1 to fkToesSnap.count do
			(
				fkToesTransforms[i] = fkToesSnap[i].node.transform
			)
			
			-- Controlador activo para posición y rotación en Fk. Forzado del cambio de los controlado y los Locks en el estado FK, para poder pasarle las nuevas transformaciones.
			-- Cambio de controlador activo.e
			ikPawprintSnap.node.position.controller.active = 2
			ikPawprintSnap.node.rotation.controller.active = 2
			fkAnimalLegBone04Snap.node.rotation.controller.active = 2
			ikAnimalLegBone06Snap.node.rotation.controller.active = 2
			
			--/*
			for i = 1 to ikToesSnap.count do
			(
 				--fkToeTrans = fkToesSnap[i].node.transform
				ikToesSnap[i].node.rotation.controller.active = 2
				--ikToesSnap[i].node.transform = fkToesSnap[i].node.transform
				fkToesSnap[i].node.rotation.controller[#Zero_Ik_Euler_XYZ].controller.value = fkToesSnap[i].node.rotation.controller[#Zero_Fk_Euler_XYZ].controller.value
			)
			--*/
			
			/*
			-- Snap Toes
			for i = 1 to fkToesSnap.count do
			(
				fkToesSnap[i].node.rotation.controller.active = 3
				fkToesSnap[i].node.transform = ikToesSnap[i].node.transform
				
				nameParts = filterString fkToesSnap[i].node.name "_"
				
				if nameParts[4] == "l" then
					fkToesSnap[i].node.scale = [-1,-1,-1]
				else if nameParts[4] == "r" then
					fkToesSnap[i].node.scale = [1,1,1]
			)
			*/
			
-- 			for b in ikToesSnap do
-- 				b.node.rotation.controller.active = 2
			
			-- Locks en Fk.
			setTransformLockFlags fkAnimalLegBone02Snap.node #{1..3,7..9}
			setTransformLockFlags fkAnimalLegBone03Snap.node #{1..5,7..9}
			setTransformLockFlags fkAnimalLegBone04Snap.node #{1..5,7..9}
			setTransformLockFlags fkPawSnap.node #{1..3,7..9}
			setTransformLockFlags fkAnimalLegBone06Snap.node #{1..3,7..9}
			
			-- Muestra Huella
			-- unhide ikPawprintSnap.node
			
			-- Asignación de las transformaciones almacenadas anteriormente.
			fkJointOrientSnap.node.position.controller[#Zero_Pos_XYZ].value = [0,0,0] -- Position a 0 de la Referencia de la rodilla en FK.
			fkJointOrientSnap.node.rotation.controller[#Zero_Euler_XYZ].value = (quat 0 0 0 1) -- Rotacion a 0 de la Referencia de la rodilla en FK.
			ikPawprintSnap.node.transform = fkPawSnap.node.transform -- Asignación de transformaciones a plantilla.
			
			-- rectificación de escalas en la plantilla por si al pasar la transformación quedan negativas se cambian a positivas.
			if ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#X_Scale].value < 0 then
				ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#X_Scale].value = -ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#X_Scale].value
			
			if ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#Y_Scale].value < 0 then
				ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#Y_Scale].value = -ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#Y_Scale].value
			
			if ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#Z_Scale].value < 0 then
				ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#Z_Scale].value = -ikPawprintSnap.node.scale.controller[#Zero_Scale_XYZ].controller[#Z_Scale].value
			-- Final rectificación escala de la plantilla.
			
			
			fkPawSnap.node.position.controller[#Zero_Ik_Pos_XYZ].value = [0,0,0] -- Puesta a valor 0 de la translación de offset del hueso Paw en IK.
			fkPawSnap.node.rotation.controller[#Zero_Ik_Euler_XYZ].value = (quat 0 0 0 1) -- Puesta a valor 0 de la rotation del hueso Paw en IK.
			ikAnimalLegBone07Snap.node.rotation.controller[#Zero_Euler_XYZ].value = (quat 0 0 0 1) -- Puesta a valor 0 de la rotation del hueso ToesEnd en IK.
			ikJointOrientSnap.node.transform = fkJointOrientTrans -- Asignación de transformaciones a rodilla Ik de los valores almacenados.
			
			if ikPawprintSnap.node.modifiers[#Animal_Leg_Controls].fkIkPaw.controller.value > 0.0 then
			(
				fkAnimalLegBone06Snap.node.rotation.controller[#Zero_Ik_Euler_XYZ].value = fkAnimalLegBone06Snap.node.rotation.controller[#Zero_Fk_Euler_XYZ].value
				
				pasternPointTrans = ikPasternRotationPointSnap.node.transform
				pasternTrans = fkAnimalLegBone04Snap.node.transform
				
				
				pasternPointTrans.row1 = pasternTrans.row1
				pasternPointTrans.row2 = pasternTrans.row2
				pasternPointTrans.row3 = pasternTrans.row3
				
				ikPasternRotationPointSnap.node.transform = pasternPointTrans
			)
			
			ikPawprintSnap.node.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkik].value = 1.0
			
			-- Snap Toes
-- 			for i = 1 to fkToesSnap.count do
-- 			(
-- 				fkToesSnap[i].node.rotation.controller.active = 2
-- 				fkToesSnap[i].node.transform = fkToesTransforms[i]
-- 			)
			
			if keepSelection == false then
			(
				select ikPawprintSnap.node
			)
			
			this.rollFkIk.btnFkIkSnap.caption = "Ik to Fk"
		)
		
		
		
		fn fkIkSnap = -- Funcion que realiza el Snap entre los esqueletos de FK e IK
		(
			-- Ik to Fk
			if ikPawprintSnap.node.modifiers[#Animal_Leg_Controls].fkik.controller.value > 0 then -- Comprueba que el estado del attributo sea superior a  0 para hacer el Snap.
				ikToFkSnap ()
			else -- Fk to Ik
				fkToIkSnap ()
		)
		
		
		rollout rollFkIk "Leg Controls"
		(
			spinner snpFkIk "FK_IK" range:[0,1,1]
			slider sldFkIk "" range:[0,1,1]
			
			spinner spnFkIkPaw "FK_IK_Paw" range:[0,1,1]
			slider sldFkIkPaw "" range:[0,1,1]
			
			spinner spnFixPaw "Fix_Paw" range:[0,1,1] -- offset:[0,5]
			slider sldFixPaw "" range:[0,1,1]
			
			spinner spnFollowJoint "Follow_Joint" range:[0,1,1] -- offset:[0,5]
			slider sldFollowJoint "" range:[0,1,1]
			
			spinner spnFixAnimalLeg "Fix_Animal_Leg" range:[0,1,1] -- offset:[0,5]
			slider sldFixAnimalLeg "" range:[0,1,1]
			
			button btnFkIkSnap "Ninguno" width:155 height:30 -- pos:[3,200] -- Boton de Fk/Ik Snap que ejecuta la función fkIkSnap.
			
			on rollFkIk open do
			(
				if ikPawprintSnap.node.modifiers[1].fkik.controller.value > 0 then
					btnFkIkSnap.caption = "Ik to Fk"
				else
					btnFkIkSnap.caption = "Fk to Ik"
			)
			
			on btnFkIkSnap pressed do
			(
				undo "Fk/Ik Snap" on
				(
					fkIkSnap ()
				)
			) 
		)
	)
	

	---------------------------------------------------------------------------
	-------------------- FUNCIONES --------------------------------------
	---------------------------------------------------------------------------
	
	fn checkSolutionNodes solNodes = 
	(
		local success = false -- flag para saber si ha tenido exito la busqueda de las partes de la pata.
		
		local cont = 1 -- contador 1 para recorrer bodyParts, que contiene los arrays de posibles grupos de objetos para esta solucion.
		
		numeric_chars = #("0","1","2","3","4","5","6","7","8","9") -- array de números para buscar en nameParts[5] como parte numérica.
		
		while not success and cont <= bodyParts.count do -- mientras no encuentra coincidencia (success = false) y haya más arrays en bodyParts, continua buscando.
		(
			contSolNodes = 0
			foundBodyParts = #()
			
			for bodyPart in bodyParts[cont] do -- recorre cada uno de los componentes del array 'bodyParts' en el que se encuentra en ese ciclo del bucle 'while not success'.
				for obj in solNodes do -- recorre objetos de 'solNodes' para ver si se encuentran en el array actual de 'bodyParts'.
				(
					nameParts = filterString obj.name "_" -- filtra nombre de 'obj' por "_".
					
					stop = false -- variable que parará el buccle cuando encuentre correspondencia entre el nombre del objeto actual y el del array 'bodyParts' actual.
					contChar = nameParts[5].count -- variable que almacena el número de carácteres alfanuméricos de la parte 5 del nombre de 'obj'.
					
					while not stop and contChar > 0 do -- Bucle que se ejecuta mientras 'stop' == false y 'contChar' sea mayor que 0. Elimina la parte numérica del nombre.
					(
						if (findItem numeric_chars nameParts[5][contChar]) != 0 then -- compara que el último character de la parte 5 del nombre de 'obj' con los almacenados en el array 'numeric_chars', findItem devuelve 1 si lo encuentra.
						(
							nameParts[5] = subString nameParts[5] 1 (contChar - 1) -- almacena en nameParts[5] todos los caracteres de nameParts[5] menos el último.
						)
						else -- si no tiene parte numerica entra en esta condición.
						(
							stop = true -- para el bucle.
							if nameParts[5] == bodyPart then 
							(
								contSolNodes += 1 -- si lña parte 5 del nombre de 'obj' coincide con la de 'bodyPart' añade 1 a 'contSolNodes'.
								
								index = findItem bodyParts[cont] nameParts[5] --busca el solNode actual en el array de partes de la solucion
								if index != 0 then --si lo encuentra añade el indice, solo si no esta ya, al array de partes encontradas
									appendIfUnique foundBodyParts index --lo añade
							)
						)-- if End
						
						contChar -= 1 -- resta 1 al valor de contChar para que en el siguiente ciclo del bucle mire el caracter anterior al actual.
					)-- while End
				)-- for End
			
			if contSolNodes == solNodes.count and foundBodyParts.count == bodyParts[cont].count then
				success = true -- si cuando termina de recorrer solNodes pone la variable 'success' a true.
			
			cont += 1 -- aumenta en 1 'cont' para que recorra el siguiente array de nombre de objetos para la solucion.
		) -- while End
		
		
		success --devuelve el resultado
	)
	
	
	fn prepareSolution refBone=
	(
		addNotification "\nAutoRig - Animal Leg\t. Building Animal Leg Solution\n"
		
		-- Nombre del Character
		nameParts = filterstring refBone.name "_" -- filtrado de nombres de huesos del brazo por "_". Almacenado en 'nameArray'.
		chrName = nameParts[2] -- nombre del personaje almacenado en 'charName'.
		
		-- Creación de cara de personaje.
		chrLayer = lb.layer.newAssetLayer chrName -- Crea capa para personaje.
		lb.layer.activeLayer chrName -- Activa capa para personaje.
		
		-- Lado de la Extremidad
		sidePart = nameParts[4] -- lado del personaje sobre el que se creará el brazo.
		
		-- ¿ Extremidad delantera o trasera ?
		for i = 1 to bodyParts.count do
		(
			for part in bodyParts[i] where (findString refBone.name part != undefined) do
				case i of
				(
					1:
					(	
						frontBackPart = NC_locationFront
						frontBackPartString = "front"
						
						animalLegPart01 = "shoulder_"
						animalLegPart02 = "upperarm_"
						animalLegPart03 = "forearm_"
						animalLegPart04 = "pastern_"
						animalLegPart05 = "instepFront_"
						animalLegPart06 = "Toes_"
						animalLegPart07 ="toesEnd_"
						animalLegPartToeIn = "toeIn"
						animalLegPartToeOut = "toeOut"
					)
					
					2: 
					(
						frontBackPart = NC_locationBack
						frontBackPartString = "rear"
						
						animalLegPart01 = "pelvis_"
						animalLegPart02 = "thigh_"
						animalLegPart03 = "lowerThigh_"
						animalLegPart04 = "rearPastern_"
						animalLegPart05 = "instepBack_"
						animalLegPart06 = "Toes_"
						animalLegPart07 ="ToesEnd_"
						animalLegPartToeIn = "toeIn"
						animalLegPartToeOut = "toeOut"
					)
				)
		)--for bodyparts
		
	)
	

	----------------------------------------------------------------------------------------------------------------
	-- función para definir los animTracks de Fix Leg al objeto especificado.
	-- OBJ: objet al que va aplicado el animTrack
	----------------------------------------------------------------------------------------------------------------
	fn animTracksfixAnimalLeg obj = -- animTracks de Fix Leg
	(
		aTracksfixAnimalLeg = #() -- Array para almacenado de animTracks de Fix Leg.
		aTracksfixAnimalLeg[1] = #(obj[#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fixAnimalLeg], "Modified_Object:Animal_Leg_Controls:custAttributes[#fkIkSnaps]:fixAnimalLeg", true, "Fix_Animal_Leg", 0.0)
		aTracksfixAnimalLeg
	)



	----------------------------------------------------------------------------------------------------------------
	-- función para definir los animTracks de Follow Joint al objeto especificado.
	-- OBJ: objet al que va aplicado el animTrack
	----------------------------------------------------------------------------------------------------------------
	fn animTracksfollowJoint obj = -- animTracks de Follow Joint
	(
		aTracksfollowJoint = #() -- Array para almacenado de animTracks de Follow Knee.
		aTracksfollowJoint[1] = #(obj[#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#followJoint], "Modified_Object:Animal_Leg_Controls:custAttributes[1]:followJoint", true, "Follow_joint", 1.0)
		aTracksfollowJoint[2] = #(#separator, "Separator01", false, "")
		aTracksfollowJoint
	)



	----------------------------------------------------------------------------------------------------------------
	-- función para definir los animTracks de IK PawBone Rotations
	-- OBJ: objet al que va aplicado el animTrack
	----------------------------------------------------------------------------------------------------------------
	fn animTracksIkPawBoneRot obj = -- animTracks de IK PawBone Rotations
	(
		if obj[#Transform][#Link_Params] != undefined then
		(
			aTracksIkPawBoneRot = #() -- Array para almacenado de animTracks de IK FootBone Rotations.
			aTracksIkPawBoneRot[1] = #(obj[#transform][#Link_Params][#rotation][#Zero_Ik_Euler_XYZ][#x_rotation], "transform:link_params:rotation:Zero_Ik_Euler_XYZ:x_rotation", true, "paw_bank", 0.0)
			aTracksIkPawBoneRot[2] = #(obj[#transform][#Link_Params][#rotation][#Zero_Ik_Euler_XYZ][#y_rotation], "transform:link_params:rotation:Zero_Ik_Euler_XYZ:y_rotation", true, "heel_pivot", 0.0)
			aTracksIkPawBoneRot[3] = #(obj[#transform][#Link_Params][#rotation][#Zero_Ik_Euler_XYZ][#z_rotation], "transform:link_params:rotation:Zero_Ik_Euler_XYZ:z_rotation", true, "paw_roll", 0.0)
			aTracksIkPawBoneRot[4] = #(#separator, "Separator01", false, "")
			aTracksIkPawBoneRot
		)
		else
		(
			aTracksIkPawBoneRot = #() -- Array para almacenado de animTracks de IK FootBone Rotations.
			aTracksIkPawBoneRot[1] = #(obj[#transform][#rotation][#Zero_Ik_Euler_XYZ][#x_rotation], "transform:rotation:Zero_Ik_Euler_XYZ:x_rotation", true, "paw_bank", 0.0)
			aTracksIkPawBoneRot[2] = #(obj[#transform][#rotation][#Zero_Ik_Euler_XYZ][#y_rotation], "transform:rotation:Zero_Ik_Euler_XYZ:y_rotation", true, "heel_pivot", 0.0)
			aTracksIkPawBoneRot[3] = #(obj[#transform][#rotation][#Zero_Ik_Euler_XYZ][#z_rotation], "transform:rotation:Zero_Ik_Euler_XYZ:z_rotation", true, "paw_roll", 0.0)
			aTracksIkPawBoneRot[4] = #(#separator, "Separator01", false, "")
			aTracksIkPawBoneRot
		)
	)



	----------------------------------------------------------------------------------------------------------------
	-- función para definir los animTracks de IK ToesEnd Rotations
	-- OBJ: objet al que va aplicado el animTrack
	----------------------------------------------------------------------------------------------------------------
	fn animTracksToesEndIkRot obj = -- animTracks de IK ToesEnd Rotations
	(
		if obj[#Transform][#Link_Params] != undefined then
		(
			aTracksToesEndIkRot = #() -- Array para almacenado de animTracks de IK ToesEnd Rotations
			aTracksToesEndIkRot[1] = #(obj[#transform][#Link_Params][#rotation][#Zero_Ik_Euler_XYZ][#x_rotation], "transform:link_params:rotation:Zero_Ik_Euler_XYZ:x_rotation", true, "toes_tilt", 0.0)
			aTracksToesEndIkRot[2] = #(obj[#transform][#Link_Params][#rotation][#Zero_Ik_Euler_XYZ][#y_rotation], "transform:link_params:rotation:Zero_Ik_Euler_XYZ:y_rotation", true, "toes_pivot", 0.0)
			aTracksToesEndIkRot[3] = #(obj[#transform][#Link_Params][#rotation][#Zero_Ik_Euler_XYZ][#z_rotation], "transform:link_params:rotation:Zero_Ik_Euler_XYZ:z_rotation", true, "toes_roll", 0.0)
			aTracksToesEndIkRot[4] = #(#separator, "Separator01", false, "")
			aTracksToesEndIkRot
		)
		else
		(
			aTracksToesEndIkRot = #() -- Array para almacenado de animTracks de IK ToesEnd Rotations
			aTracksToesEndIkRot[1] = #(obj[#transform][#rotation][#Zero_Ik_Euler_XYZ][#x_rotation], "transform:rotation:Zero_Ik_Euler_XYZ:x_rotation", true, "toes_tilt", 0.0)
			aTracksToesEndIkRot[2] = #(obj[#transform][#rotation][#Zero_Ik_Euler_XYZ][#y_rotation], "transform:rotation:Zero_Ik_Euler_XYZ:y_rotation", true, "toes_pivot", 0.0)
			aTracksToesEndIkRot[3] = #(obj[#transform][#rotation][#Zero_Ik_Euler_XYZ][#z_rotation], "transform:rotation:Zero_Ik_Euler_XYZ:z_rotation", true, "toes_roll", 0.0)
			aTracksToesEndIkRot[4] = #(#separator, "Separator01", false, "")
			aTracksToesEndIkRot
		)
	)



	----------------------------------------------------------------------------------------------------------------
	-- función para definir los animTracks de Fk-IkFoot al objeto especificado.
	-- OBJ: objet al que va aplicado el animTrack
	----------------------------------------------------------------------------------------------------------------
	fn animTracksFkIkPaw obj = -- animTracks de fkikPaw
	(
		aTracksFkIkPaw = #() -- Array para almacenado de animTracks de Fk-Ik.
		aTracksFkIkPaw[1] = #(obj[#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkikPaw][#float_limit], "Modified_Object:Animal_Leg_Controls:custAttributes[#fkIkSnaps]:fkikPaw:float_limit", true, "Fk_Ik_Paw", 1.0)
		aTracksFkIkPaw[2] = #(#separator, "Separator01", false, "")
		
		aTracksFkIkPaw
	)



	----------------------------------------------------------------------------------------------------------------
	-- función para definir los animTracks de fixPaw al objeto especificado.
	-- OBJ: objet al que va aplicado el animTrack
	----------------------------------------------------------------------------------------------------------------
	fn animTracksfixPaw obj = -- animTracks de fixPaw
	(
		aTracksfixPaw = #() -- Array para almacenado de animTracks de Fk-Ik.
		aTracksfixPaw[1] = #(obj[#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fixPaw], "Modified_Object:Animal_Leg_Controls:custAttributes[#fkIkSnaps]:fixPaw", true, "fix_Paw", 1.0)
	-- 	aTracksfixPaw[2] = #(#separator, "Separator01", false, "")
		
		aTracksfixPaw
	)

	
	
	----------------------------------------------------------------------------------------------------------------
	-- función que genera la solución de twist sobre un hueso
	----------------------------------------------------------------------------------------------------------------
	fn generateSolution solNodes =
	(
		success = false --flag para saber si ha realizado correctamente todas las operaciones
		
		if checkSolutionNodes solNodes then
		(
			hiddenObj = #()
			animBones = #()
			ikBones = #()
			selSetAnimalLeg = #()
			xyzPosObj = #()
			xyzRotObj = #()
			xyzPosRotObj = #()
			zRotObj = #()
			stretchyIkObj = #()
			stretchyFkObj = #()
			FkIkRotObj = #()
			custAttribAnimalLegBones = #()
			
			animalLeg07PosRef = undefined -- corresponde a huesop de referencia para puntera.
			
			prepareSolution solNodes[1]
			
			-- Duplicado de huesos parte Pierna
			animBones = duplicateBoneChain chrName solNodes -- Duplicado de huesos, utilizando la función 'duplicateBoneChain'. Almacenado en array 'animBones'.
			selSetLeg  = deepCopy animBones -- almacenado del array 'animBones' en array ' selSetLeg' para crear los Selection Sets.
			
			
			-- Colocación del Shape Base
			base = getBase chrShapesPath chrName -- importado de objeto Base con la función 'getBase'. Almacenado en 'base'.
			chrLayer.addNode base -- añade 'base' a capa de personaje.
			
			if (classof base.Transform.controller != Link_Constraint) then
				base.Transform.controller = Link_Constraint ()
			
			if base.modifiers[#Link_Controls] == undefined and (classof base.Transform.controller) == Link_Constraint then
			(
				addAttributeHolder base "Link_Controls"
				try custAttributes.delete base base.modifiers[#Link_Controls].custattributes[#linkConstraintInfo] catch()
				custAttributes.add base.modifiers[#Link_Controls] lb.customAttributes.linkConstraintARSCA #unique
			)
			
			clearSelection()
			
			-- Encuentra Hueso 'animalLeg01Bone' (Shoulder / Pelvis).
			index = lb.misc.findObjectByName animBones animalLegPart01 -- posición que ocupa en el array 'animBones' el hueso 'animalLegPart01' utilizando la función 'lb.misc.findObjectByName'.
			animalLeg01Bone = animBones[index] -- almacena en 'animalLeg01Bone' el hueso 'animalLegPart01', shoulder / pelvis.
			append custAttribAnimalLegBones animalLeg01Bone
			append selSetAnimalLeg animalLeg01Bone -- almacena el objeto 'animalLeg01Bone' en array 'selSetAnimalLeg' para creación de Selection Sets.
			
			if frontBackPart == NC_locationFront then
				append xyzPosRotObj animalLeg01Bone -- almacena en 'xyzPosRotObj' el hueso 'animalLeg01Bone' para asignar AnimTracks.
			else if frontBackPart == NC_locationBack then
				append xyzRotObj animalLeg01Bone -- almacena en 'xyzRotObj' el hueso 'animalLeg01Bone' para asignar AnimTracks.
			
			
			-- Encuentra Hueso 'animalLeg02Bone' (upperarm / thigh).
			index = lb.misc.findObjectByName animBones animalLegPart02 -- posición que ocupa en el array 'animBones' el hueso 'animalLegPart02' utilizando la función 'lb.misc.findObjectByName'.
			animalLeg02Bone = animBones[index] -- almacena en 'animalLeg02Bone' el hueso 'animalLegPart02', upperarm / thigh
			append stretchyFkObj animalLeg02Bone -- almacena en 'stretchyFkObj' el hueso 'animalLeg02Bone' para asignar modificador stretchy.
			append custAttribAnimalLegBones animalLeg02Bone
			append selSetAnimalLeg animalLeg02Bone -- almacena el objeto 'animalLeg02Bone' en array 'selSetAnimalLeg' para creación de Selection Sets.
			append xyzRotObj animalLeg02Bone -- almacena en 'xyzRotObj' el hueso 'animalLeg02Bone' para asignar AnimTracks.
			
			-- Encuentra Hueso 'animalLeg03Bone' (Forearm / lowerThigh).
			index = lb.misc.findObjectByName animBones animalLegPart03 -- posición que ocupa en el array 'animBones' el hueso 'animalLegPart03' utilizando la función 'lb.misc.findObjectByName'.
			animalLeg03Bone = animBones[index] -- almacena en 'animalLeg03Bone' el hueso 'animalLegPart03', forearm / lowerThigh.
			append stretchyFkObj animalLeg03Bone -- almacena en 'stretchyFkObj' el hueso 'animalLeg03Bone' para asignar modificador stretchy
			append custAttribAnimalLegBones animalLeg03Bone
			append selSetAnimalLeg animalLeg03Bone -- almacena el objeto 'animalLeg03Bone' en array 'selSetAnimalLeg' para creación de Selection Sets.
			append zRotObj animalLeg03Bone -- almacena en 'zRotObj' el hueso 'animalLeg03Bone' para asignar AnimTracks.
			
			-- Encuentra Hueso 'animalLeg04Bone' (pastern / rearPastern).
			index = lb.misc.findObjectByName animBones animalLegPart04 -- posición que ocupa en el array 'animBones' el hueso 'animalLegPart04' utilizando la función 'lb.misc.findObjectByName'.
			animalLeg04Bone = animBones[index] -- almacena en 'animalLeg04Bone' el hueso 'animalLegPart04'
			append stretchyFkObj animalLeg04Bone -- almacena en 'stretchyFkObj' el hueso 'thighBone' para asignar modificador stretchy.
			append custAttribAnimalLegBones animalLeg04Bone
			append selSetAnimalLeg animalLeg04Bone -- almacena el objeto 'animalLeg04Bone' en array 'selSetAnimalLeg' para creación de Selection Sets.
			append FkIkRotObj animalLeg04Bone -- almacena en 'zRotObj' el hueso 'animalLeg04Bone' para asignar AnimTracks.
			
			-- Encuentra Hueso 'animalLeg05Bone' (frontInstep / rearInstep).
			index = lb.misc.findObjectByName animBones animalLegPart05 -- posición que ocupa en el array 'animBones' el hueso 'instep' utilizando la función 'lb.misc.findObjectByName'.
			animalLeg05Bone = animBones[index] -- almacena en 'animalLeg05Bone' el hueso 'animalLegPart05'.
			animalLeg05Bone.boneEnable=false
			append hiddenObj animalLeg05Bone -- añade 'animalLeg05Bone' al array 'hiddenObj' para ocultarlo más adelante.
			
			-- Encuentra Hueso 'animalLeg06Bone' (frontToes / rearToes)
			index = lb.misc.findObjectByName animBones animalLegPart06 -- posición que ocupa en el array 'animBones' el hueso 'animalLegPart06' utilizando la función 'lb.misc.findObjectByName'.
			animalLeg06Bone = animBones[index] -- almacena en 'animalLeg06Bone' el hueso 'animalLegPart06'.
			if sidePart == NC_locationLeft then
			(
				animalLeg06Bone.sidefins = off
				animalLeg06Bone.frontfin = on
				animalLeg06Bone.backfin = off
				animalLeg06Bone.frontfinsize = 2
			)
			else if sidePart == NC_locationRight then
			(
				animalLeg06Bone.sidefins = off
				animalLeg06Bone.frontfin = off
				animalLeg06Bone.backfin = on
				animalLeg06Bone.backfinsize = 2
			)
 			append custAttribAnimalLegBones animalLeg06Bone
			append selSetAnimalLeg animalLeg06Bone -- almacena el objeto 'animalLeg06Bone' en array 'selSetAnimalLeg' para creación de Selection Sets.
			append FkIkRotObj animalLeg06Bone
			
			-- Encuentra Huesos 'animalLegToes' (frontToe / rearToe)
			animalLegPartToesIn = #()
			animalLegPartToesOut = #()
			
			for bon in animBones do
			(
				nameParts = filterString bon.name "_"
				
				if (findString nameParts[5] animalLegPartToeIn) != undefined then append animalLegPartToesIn bon
				
				if (findString nameParts[5] animalLegPartToeOut) != undefined then append animalLegPartToesOut bon
			)
			
			animalLegPartToesIn = (lb.misc.sortNodesByName animalLegPartToesIn)
			animalLegPartToesOut = (lb.misc.sortNodesByName animalLegPartToesOut)
			
			join custAttribAnimalLegBones animalLegPartToesIn
			join custAttribAnimalLegBones animalLegPartToesOut
			
			animalLegPartToes = animalLegPartToesIn + animalLegPartToesOut
			join FkIkRotObj animalLegPartToes
			
			
			-- creación de hueso End en el hueso 'animalLeg01Bone'. Utilizando la función 'lb.rig.smartCreateEnd' de lbTools_Rigging Functions.
			animalLeg01BoneEnd = lb.rig.smartCreateEnd animalLeg01Bone
			-- parametros de objeto de 'animalLeg01BoneEnd'.
			animalLeg01BoneEnd.sidefins = on
			animalLeg01BoneEnd.sidefinssize = 1
			animalLeg01BoneEnd.frontfin = off
			animalLeg01BoneEnd.backfin = off
			animalLeg01BoneEnd.transform = animalLeg02Bone.transform -- alineación de 'clavicleEnd' con 'animalLeg02Bone'
			
			if frontBackPart == NC_locationBack and animalLeg01BoneEnd.objectOffsetScale.x == -1.0 then
				animalLeg01BoneEnd.objectOffsetScale.x = 1.0
			else if frontBackPart == NC_locationBack  and animalLeg01BoneEnd.objectOffsetScale.x == 1.0 then
				animalLeg01BoneEnd.objectOffsetScale.x = -1.0
			
			lb.controller.freezeTransform animalLeg01BoneEnd #all -- Freeze de transformaciones para 'clavicleEnd', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			append hiddenObj animalLeg01BoneEnd -- añade 'clavicleEnd' al array 'hiddenObj' para ocultarlo más adelante.
			setUserProp animalLeg01BoneEnd "Definition" "Este hueso sirve de referencia de orientación para contraint de Fix Animal Leg" -- definición de función de objeto.
			
			
			-- Creación de hueso Paw con la alineación correcta.
			pawBone = lb.rig.smartCreateEnd animalLeg04Bone -- creación de hueso End en el hueso 'animalLeg04Bone'. Utilizando la función 'lb.rig.smartCreateEnd' de lbTools_Rigging Functions.
			pawBone.taper = 0
			pawBone.dir = animalLeg05Bone.dir -- alineación de la dirección del hueso 'pawBone' con la dirección del hueso 'instep'.
			append selSetLeg pawBone -- almacena el objeto 'pawBone' en array 'selSetLeg' para creación de Selection Sets.
			append custAttribAnimalLegBones pawBone
			append selSetAnimalLeg pawBone -- almacena el objeto 'pawBone' en array 'selSetAnimalLeg' para creación de Selection Sets.
			
			if pawBone.objectoffsetscale.x == -1.0 then -- comprobación si el hueso 'pawBone' tiene la visualización invertida.
				pawBone.transform = matrix3 -pawBone.transform[1] [0,0,-1] (normalize(cross pawBone.transform[1] [0,0,1])) pawBone.pos -- alineación del hueso 'pawBone' para que gire con la orientación correcta para animar.
			else
				pawBone.transform = matrix3 pawBone.transform[1] [0,0,1] (normalize(cross pawBone.transform[1] [0,0,1])) pawBone.pos -- alineación del hueso 'pawBone' para que gire con la orientación correcta para animar.
			
			nameBone = filterstring animalLeg04Bone.name "_" -- filtrado del nombre del hueso 'animalLeg04Bone' por "_".
			nameBone = substituteString animalLeg04Bone.name nameBone[5] (frontBackPartString + "Paw") -- cambio de la parte 5 del nombre por frontBackPart + "Paw".
			pawBone.name = nameBone -- asignación del nuevo nombre a 'pawBone'.
			lb.controller.freezeTransform pawBone #all -- Freeze de transformaciones para 'pawBone', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			append animBones pawBone -- almacenamiento de 'pawBone' al array 'animBones'.
			
			
			-- creación de hueso End en el hueso 'animalLeg04Bone'. Utilizando la función 'lb.rig.smartCreateEnd' de lbTools_Rigging Functions.
			animalLeg04BoneEnd = lb.rig.smartCreateEnd animalLeg04Bone -- creación de hueso End en el hueso 'animalLeg04Bone'. Utilizando la función 'lb.rig.smartCreateEnd' de lbTools_Rigging Functions.
			-- parametros de objeto de 'spineEnd'.
			animalLeg04BoneEnd.sidefins = on
			animalLeg04BoneEnd.sidefinssize = 1
			animalLeg04BoneEnd.transform = pawBone.transform -- alineación de 'forearmEnd' con 'handBone'
			lb.controller.freezeTransform animalLeg04BoneEnd #all -- Freeze de transformaciones para 'forearmEnd', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			append hiddenObj animalLeg04BoneEnd -- añade 'forearmEnd' al array 'hiddenObj' para ocultarlo más adelante.
			setUserProp animalLeg04BoneEnd "Definition" "Este hueso sirve de referencia de orientación para contraint de Fix Paw" -- definición de función de objeto.
			
			
			-- Creación de hueso de referencia para Paw con la alineación correcta para evitar dobles transformaciones en rotación IK.
			b=#() -- array necesario para maxOps.CloneNodes.
			maxOps.CloneNodes #(pawBone) offset:[0,0,0] expandHierarchy:false cloneType:#copy actualNodeList:#(pawBone) newNodes:&b -- clonado del hueso actual del array. "&" es necesario para pasarle la posición en memoria de b.
			pawBoneIkRotRef = b[1]
			lb.misc.renameFromObj pawBoneIkRotRef pawBone.name NC_classAnim sufix:"IkRotRef" -- renombrado de 'footBoneIkRotRef' con la función 'lb.misc.renameFromObj'.
			append hiddenObj pawBoneIkRotRef -- añade 'footBoneIkRotRef' al array 'hiddenObj' para ocultarlo más adelante.
			-- Parametros de 'pawBoneIkRotRef'.
			pawBoneIkRotRef.wirecolor = pawBone.wirecolor
			pawBoneIkRotRef.Taper = 0
			pawBoneIkRotRef.width = 0.5
			pawBoneIkRotRef.height = 0.5
			setUserProp pawBoneIkRotRef "Definition" "Este hueso sirve de referencia de orientación para hueso 'paw' en IK. El hueso 'paw' tiene un constrint para mantener la orientación con este hueso y evitar dobles transformaciones." -- definición de función de objeto.
			
			
			-- Creación hueso de pivote en la puntera
			animalLeg07Bone = lb.rig.smartCreateEnd  animalLeg06Bone -- creación de hueso End en el hueso del pie 'animalLeg06Bone'. Utilizando la función 'lb.rig.smartCreateEnd' de lbTools_Rigging Functions.
			setUserProp animalLeg07Bone "Definition" "Este hueso se utiliza para pivotar el pie en modo IK desde la puntera" -- definición de función de objeto.
			append animBones animalLeg07Bone -- almacenamiento de 'animalLeg07Bone' al array 'animBones'.
			append selSetLeg animalLeg07Bone -- almacenamiento de 'animalLeg07Bone' al array 'selSetLeg' para creación de Selection Sets.
			append custAttribAnimalLegBones animalLeg07Bone
			append selSetAnimalLeg animalLeg07Bone -- almacena el objeto 'animalLeg07Bone' en array 'selSetAnimalLeg' para creación de Selection Sets.
			append xyzRotObj animalLeg07Bone -- almacena en 'xyzRotObj' el hueso 'animalLeg02Bone' para asignar AnimTracks.
			
			
			-- Aplicación de gradiente de color a la jerarquía.
			if sidePart == NC_locationLeft then
				colors = #(color 20 28 178, color 20 28 178, color 50 80 232, color 50 80 232, color 53 116 231, color 91 153 246, color 20 30 200)
			else if sidePart == NC_locationRight then
				colors = #(color 0 114 78, color 0 114 78, color 18 142 76, color 18 142 76, color 39 165 63, color 154 205 0, color 0 151 85)
			
			percents = #(0.0, 0.18, 0.19, 0.33, 0.35, 0.5, 1.0)
 			animBones.ishidden = false
			lb.rig.applyGradientRamp (animBones + hiddenObj) colors percents useVirtualHierarchy:false
			
			
			-- Duplicado huesos Ik:
			ikBones = #(animalLeg02Bone,animalLeg03Bone,animalLeg04Bone,animalLeg05Bone,animalLeg06Bone,animalLeg07Bone)
			
			ikBones = duplicateBoneChain chrName ikBones -- Duplicado de huesos, utilizando la función 'duplicateBoneChain'. Almacenado en array 'animBones'.
			ikToesInBones = duplicateBoneChain chrName animalLegPartToesIn -- Duplicado de huesos, utilizando la función 'duplicateBoneChain'. Almacenado en array 'animalLegPartToesIn'.
			ikToesOutBones = duplicateBoneChain chrName animalLegPartToesOut -- Duplicado de huesos, utilizando la función 'duplicateBoneChain'. Almacenado en array 'animalLegPartToesIn'.
			
			ikToes = ikToesInBones + ikToesOutBones
			
			allIkBones = deepCopy ikBones
			
			allIkBones += ikToesInBones + ikToesOutBones
			
			
			for obj in allIkBones do
				lb.misc.renameFromObj obj obj.name NC_classAnim prefix:"ik"
			
			
			for obj in allIkBones do
			(
				obj.width = 0.5
				obj.height = 0.5
				obj.Taper = 90
				obj.sidefins = off
				obj.frontfin = off
				obj.backfin = off
			)
			
			-- Crea Points Padres de Cadenas
			pointAnimalLegSolution = lb.rig.createPointFromObj animalLeg01Bone classType:NC_classAnim sufix:"" crossOp:on boxOp:on -- creación de point para toda la solución de la pierna.
			
			nameArray = filterString pointAnimalLegSolution.name "_" -- filtrado de nombre de 'pointAnimalLegSolution' por "_".
			pointAnimalLegSolution.name = substituteString pointAnimalLegSolution.name ("_" + nameArray[5])  ("_" + frontBackPartString + "AnimalLegSolution") -- sustitución en el nombre del hueso actual del array 'pointAnimalLegSolution' de la parte 5 por "AnimalLegSolution".
			
			-- Parametros de 'pointAnimalLegSolution'
			pointAnimalLegSolution.wirecolor = color 255 255 0 -- cambio de color de 'pointAnimalLegSolution' a Yellow.
			pointAnimalLegSolution.size = 5
			append hiddenObj pointAnimalLegSolution -- almacenado de 'pointAnimalLegSolution' en el array 'hiddenObj' para ocultarlo más adelante.
			setUserProp pointAnimalLegSolution "Definition" "Point padre para toda la Solución de la pata. Este point se emparentará directamente el hueso de la pelvis." -- definición de función de objeto.	
			
			pointAnimalLeg = lb.rig.createPointFromObj animalLeg02Bone classType:NC_classAnim sufix:"Structure" crossOp:off boxOp:on
			
			nameArray = filterString pointAnimalLeg.name "_" -- filtrado de nombre de 'pointAnimalLegSolution' por "_".
			pointAnimalLeg.name = substituteString pointAnimalLeg.name ("_" + nameArray[5])  ("_" + frontBackPartString + "LegStructure") -- sustitución en el nombre del hueso actual del array 'pointAnimalLeg' de la parte 5 por "legStructure".
			pointAnimalLeg.size = 2.5
			append hiddenObj pointAnimalLeg -- almacenado de 'pointAnimalLeg' en el array 'hiddenObj' para ocultarlo más adelante.
			setUserProp pointAnimalLeg "Definition" "Point padre para toda la estructura de la Pata. Constraint de posición y orientación a hueso End de la pelvis, este último controla Fix Leg en FK. Constraint de Orientación adicional para que en modo FK el centro de masas oriente las patas." -- definición de función de objeto.
			
			pointPaw = lb.rig.createPointFromObj pawBone classType:NC_classAnim sufix:"Structure" crossOp:off boxOp:on -- creación de point padre para toda la estructura de la zarpa.
			nameArray = filterString pointPaw.name "_" -- filtrado de nombre de 'pointAnimalLegSolution' por "_".
			pointPaw.name = substituteString pointPaw.name ("_" + nameArray[5])  ("_" + frontBackPartString + "PawStructure") -- sustitución en el nombre del hueso actual del array 'pointAnimalLeg' de la parte 5 por "legStructure".
			pointPaw.size = 2.5
			append hiddenObj pointPaw -- almacenado de 'pointFoot' en el array 'hiddenObj' para ocultarlo más adelante.
			setUserProp pointPaw "Definition" "Point padre para toda la estructura de la Zarpa. Constraint de posición y orientación a hueso End del hueso Pastern para modo FK, constraint de orientación a la huella para modo IK." -- definición de función de objeto.
			
			
			-- Creación de point para Offset Position desde ChannelBox.
			pointAnimalLeg01BoneOffset = lb.rig.createPointFromObj animalLeg01Bone classType:NC_classAnim crossOp:off boxOp:on
			lb.misc.renameFromObj pointAnimalLeg01BoneOffset animalLeg01Bone.name NC_classAnim sufix:"MirrorChB"
			nameArray = filterString pointAnimalLeg01BoneOffset.name "_" -- filtrado de nombre de 'pointPawOffset' por "_".
			pointAnimalLeg01BoneOffset.name = substituteString pointAnimalLeg01BoneOffset.name "#" ""
			pointAnimalLeg01BoneOffset.size = 2.5
			pointAnimalLeg01BoneOffset.parent = pointAnimalLegSolution
			setUserProp pointAnimalLeg01BoneOffset "Definition" "Point padre de hueso Shoulder para poder mover en Mirror estos huesos desde ChannelBox. Ejes alineados para poder realizar Offset de posición simétrico desde ChannelBox" -- definición de función de objeto.
			append hiddenObj pointAnimalLeg01BoneOffset -- almacenado de 'pointAnimalLeg01BoneOffset' en el array 'hiddenObj' para ocultarlo más adelante.
-- 			lb.controller.freezeTransform pointAnimalLeg01BoneOffset #all  -- Freeze de transformaciones para 'pointAnimalLeg01BoneOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			
			pointPawOffset = lb.rig.createPointFromObj pawBone classType:NC_classAnim sufix:"Offset" crossOp:off boxOp:on
			nameArray = filterString pointPawOffset.name "_" -- filtrado de nombre de 'pointPawOffset' por "_".
			pointPawOffset.name = substituteString pointPawOffset.name "#" ""
			pointPawOffset.size = 4
			pointPawOffset.parent = pointFoot
			setUserProp pointPawOffset "Definition" "Point padre hueso de la Zarpa y a la vez hijo del point Padre de toda la estructura de la Zarpa. Ejes alineados para poder realizar Offset de posición simétrico desde ChannelBox" -- definición de función de objeto.
-- 			lb.controller.freezeTransform pointPawOffset #all  -- Freeze de transformaciones para 'pointFootOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			if sidePart == NC_locationLeft then -- cambio de color de 'pointFootOffset' segun lado del personaje.
			(
				pointPawOffset.wirecolor = color 108 8 136
			)
			else
			(
				pointPawOffset.wirecolor = color 135 59 8
			)
			lb.controller.freezeTransform pointPawOffset #all -- Freeze de transformaciones para 'pointFootOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			append hiddenObj pointPawOffset -- almacenado de 'pointHandOffset' en el array 'hiddenObj' para ocultarlo más adelante.
			
			
			-- Almacenado de las diferentes partes de la pata IK en variables.
			
			index = lb.misc.findObjectByName ikBones (toLower (ikanimalLegPart02 = "ik" + animalLegPart02)) -- posición que ocupa en el array 'ikBones' el hueso 'ikanimalLegPart02' utilizando la función 'lb.misc.findObjectByName'.
			ikAnimalLegBone02 = ikBones[index] -- almacena en 'ikAnimalLegBone02' el hueso 'ikanimalLegPart02'. Upperarm / thigh.
			--append stretchyIkObj ikAnimalLegBone02
			
			index = lb.misc.findObjectByName ikBones (toLower (ikanimalLegPart03 = "ik" + animalLegPart03)) -- posición que ocupa en el array 'ikBones' el hueso 'ikForearm' utilizando la función 'lb.misc.findObjectByName'.
			ikAnimalLegBone03 = ikBones[index] -- almacena en 'ikAnimalLegBone03' el hueso 'ikanimalLegPart03'. Forearm / lowerThigh.
			append stretchyIkObj ikAnimalLegBone03
			
			index = lb.misc.findObjectByName ikBones (toLower (ikanimalLegPart04 = "ik" + animalLegPart04)) -- posición que ocupa en el array 'ikBones' el hueso 'ikAnimalLegBone04' utilizando la función 'lb.misc.findObjectByName'.
			ikAnimalLegBone04 = ikBones[index] -- almacena en 'ikAnimalLegBone04' el hueso 'ikanimalLegPart04'. front pastern / rear pastern.
			append stretchyIkObj ikAnimalLegBone04
			
			index = lb.misc.findObjectByName ikBones (toLower (ikanimalLegPart05 = "ik" + animalLegPart05)) -- posición que ocupa en el array 'ikBones' el hueso 'ikAnimalLegBone05' utilizando la función 'lb.misc.findObjectByName'.
			ikAnimalLegBone05 = ikBones[index] -- almacena en 'ikAnimalLegBone05' el hueso 'ikanimalLegPart05'. frontInstep / rearInstep.
			
			index = lb.misc.findObjectByName ikBones (toLower (ikanimalLegPart06 = "ik" + (if frontBackPart == NC_locationFront then "Front" else "Rear") + animalLegPart06)) -- posición que ocupa en el array 'ikBones' el hueso 'ikAnimalLegBone06' utilizando la función 'lb.misc.findObjectByName'.
			ikAnimalLegBone06 = ikBones[index] -- almacena en 'ikAnimalLegBone06' el hueso 'ikanimalLegPart06'. frontToes/rearToes.
			
			index = lb.misc.findObjectByName ikBones (toLower (ikanimalLegPart07 = "ik" + (if frontBackPart == NC_locationFront then "Front" else "Rear") + animalLegPart07)) -- posición que ocupa en el array 'ikBones' el hueso 'ikAnimalLegBone07' utilizando la función 'lb.misc.findObjectByName'.
			ikAnimalLegBone07 = ikBones[index] -- almacena en 'ikAnimalLegBone07' el hueso 'ikanimalLegPart07'. frontToesEnd / rearToesEnd.
			
			
			ikanimalLeg04BoneEnd = lb.rig.smartCreateEnd ikAnimalLegBone04 -- creación de hueso End en el hueso 'ikAnimalLegBone04'. Utilizando la función 'lb.rig.smartCreateEnd' de lbTools_Rigging Functions.
			ikanimalLeg04BoneEnd.transform = animalLeg04BoneEnd.transform
			ikanimalLeg04BoneEnd.length = animalLeg04BoneEnd.length
			lb.controller.freezeTransform ikanimalLeg04BoneEnd #all -- Freeze de transformaciones para 'ikanimalLeg04BoneEnd', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			append ikBones ikanimalLeg04BoneEnd -- almacenado de 'ikanimalLeg04BoneEnd' en array 'ikLegBones'.
			append stretchyIkObj ikanimalLeg04BoneEnd
			
			join hiddenObj ikBones -- almacena los objetos del array 'ikLegBones' en el array 'hiddenObj' para ocultarlos más adelante.
			
			-- Emparentado de cadenas
			pointAnimalLeg01BoneOffset.parent = pointAnimalLegSolution
			lb.controller.freezeTransform pointAnimalLeg01BoneOffset #all
			if sidePart == NC_locationRight then -- Flip de Axis de 'pointFootOffset' segun lado del personaje.
			(
				lb.rig.flipAxis #(pointAnimalLeg01BoneOffset) true true true
			)
			lb.controller.freezeTransform pointAnimalLeg01BoneOffset #all
			
			animalLeg01Bone.parent = pointAnimalLeg01BoneOffset
			lb.controller.freezeTransform animalLeg01Bone #all
			
			pointPaw.parent = base -- emparentado de 'pointFoot' a 'base'
			lb.controller.freezeTransform pointPaw #all
			
			pointAnimalLeg.parent = base -- emparentado de 'pointAnimalLeg' a 'base'
			lb.controller.freezeTransform pointAnimalLeg #all
			
			pointAnimalLegSolution.parent = base -- emparentado de 'pelvisBone' a 'base'
			lb.controller.freezeTransform pointAnimalLegSolution #all
			
			animalLeg02Bone.parent = pointAnimalLeg -- emparentado de 'thighBone' a 'pointAnimalLeg'
			lb.controller.freezeTransform animalLeg02Bone #all
			
			pointPawOffset.parent = pointPaw -- emparentado de 'pointPawOffset' a 'pointPaw'
			if sidePart == NC_locationLeft then -- Flip de Axis de 'pointFootOffset' segun lado del personaje.
			(
				lb.rig.flipAxis #(pointPawOffset) false false true
			)
			else
			(
				lb.rig.flipAxis #(pointPawOffset) true true false
			)
			lb.controller.freezeTransform pointPawOffset #all
			
			pawBone.parent = pointPawOffset -- emparentado de 'footBone' a 'pointHandOffset'
			lb.controller.freezeTransform pawBone #all
			
			animalLeg05Bone.parent = pawBone
			lb.controller.freezeTransform animalLeg05Bone #all
			
			ikAnimalLegBone02.parent = pointAnimalLeg -- emparentado de 'ikThigh' a 'pointAnimalLeg'
			lb.controller.freezeTransform ikAnimalLegBone02 #all
			
			ikAnimalLegBone05.parent = pointPaw -- emparentado de 'ikAnimalLegBone05' a 'pointFoot'
			lb.controller.freezeTransform ikAnimalLegBone05 #all
			
			ikanimalLeg04BoneEnd.parent = ikAnimalLegBone04 -- emparentado de 'ikCalfEnd' a 'ikCalf'
			lb.controller.freezeTransform ikanimalLeg04BoneEnd #all
			
			pawBoneIkRotRef.parent = ikAnimalLegBone05 -- emparentado de 'pawBoneIkRotRef' a 'ikAnimalLegBone05'
			lb.controller.freezeTransform pawBoneIkRotRef #all
			
			pawBoneIkRotRef.transform = pawBone.transform
			lb.controller.freezeTransform pawBoneIkRotRef #all -- Freeze de transformaciones para 'pawBoneIkRotRef', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
 			
			
			-- Creando Array Partes Pierna
			legStructure = deepCopy animBones -- almacenado de contendo 'animBones' a 'legStructure'.
			
			join legStructure hiddenObj
			
			-- freeze Transform a estructura de la Pierna
			for i in legStructure do -- bucle que recorre todo el array 'legStructure' para relizar lb.controller.freezeTransform.
			(
				lb.controller.freezeTransform i #all -- Freeze de transformaciones para objetos contenidos en array 'legStructure', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			)
			
			
			
			-- Creación de Constraints Estructura y Fix.
			lb.rig.createConstraint pointPaw animalLeg04BoneEnd (frontBackPartString + "pawStructure_To_" + (substituteString animalLegPart04 "_" "End")) pos:true rot:true scl:false keepPos:false keepRot:false keepScl:false
			
			lb.rig.createConstraint pointAnimalLeg animalLeg01BoneEnd (frontBackPartString + "legStruct_To_" + (substituteString animalLegPart01 "_" "End")) pos:true rot:false scl:false keepPos:false keepRot:false keepScl:false -- Constrains para que la pierna se mantenga siempre pegada a la pelvis.
			lb.rig.createConstraint pointAnimalLeg animalLeg01BoneEnd "Fix_Leg" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- Constrains para fijar la rotación de la pierna a la de la pelvis en FK.
			
			
			-- Importar Huella
			pawprintObjs = getPawprint chrShapesPath chrName sidePart -- Mergea Huella para lado correspondiente, almacenado de objetos que forman la huella en el array 'footStepObjs'
			
			for i = 1 to pawprintObjs.count do -- bucle que recorre todos lo objetos que forman la huella, los pone en la capa del personaje y les cambia el flag por 'NC_duplicatedFlag'
			(
				chrLayer.addNode pawprintObjs[i] -- añade 'pawprintObjs[i]' a capa de personaje.
				lb.nc.setFlags pawprintObjs[i] #(NC_controlFlag) -- cambia el último flag de 'pawprintObjs[i]' por el de 'NC_duplicatedFlag'
			)
			
			
			-- Creación de Point para simetría de Posición en ChannelBox
			pawPositionRef = lb.rig.createPointFromObj base classType:NC_classAnim sufix:"PositionRef" crossOp:off boxOp:on 
			lb.misc.renameFromObj pawPositionRef pawBone.name NC_classAnim sufix:"PositionRef"
			substituteString pawPositionRef.name "#" ""
			append hiddenObj pawPositionRef
			setUserProp pawPositionRef "Definition" "Point padre del Shape de la huella del pie. Ejes alineados para poder realizar simetría de posición desde ChannelBox" -- definición de función de objeto.
			
			if sidePart == NC_locationLeft then -- cambio de color de 'pawPositionRef' dependiendo del lado del personaje.
			(
				pawPositionRef.wirecolor = color 0 0 255 -- Lado "l"
			)
			else
			(
				pawPositionRef.wirecolor = color 0 255 0 -- Lado "r"
 				pawPositionRef.transform = matrix3 -pawPositionRef.transform[1] pawPositionRef.transform[2] pawPositionRef.transform[3] pawPositionRef.transform[4] -- cambio de ejes para poder hacer simetría desde channelBox.
			)
			
			-- parametros de 'pawPositionRef'
			pawPositionRef.size = 6
			
			pawPositionRef.parent = base -- emparentado de 'pawPositionRef' a 'base'.
			pawPositionRef.pos = pawBone.pos -- recolocación de 'pawPositionRef' con hueso del pie 'pawBone'.
			lb.controller.freezeTransform pawPositionRef #all -- Freeze de transformaciones para 'pawBone', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			-- Almacenado de plantilla y pivotes del pie
			pawprint = (lb.misc.searchInArrayByString pawprintObjs pawprintPart)[1] -- busca dentro de 'pawprintObjs' el objeto con parte del nombre almacenado en 'pawprintPart' y lo almacena en 'pawprint'
			nameParts = filterString pawprint.name "_"
			pawprint.name = substituteString pawprint.name ("_" + nameParts[5]) ("_" + frontBackPartString + (toUpper(substring nameParts[5] 1 1) + (substring nameParts[5] 2 nameParts[5].count)))
			pawprint.Transform.controller = Link_Constraint ()
			LCpawprint = pawprint.controller
			LCpawprint.addTarget pawPositionRef 0
			
			addScaleShapeMod pawprint -- añade modificador xForm 'Scale_Shape' a 'pawprint'.
			
			
			append selSetAnimalLeg pawprint -- almacena el objeto 'pawprint' en array 'selSetAnimalLeg' para creación de Selection Sets.
			--append xyzPosRotObj pawprint -- almacena el objeto 'footStep' en array 'xyzPosRotObj' para creación de AnimTracks.
			append custAttribAnimalLegBones pawprint
			append xyzPosRotObj pawprint
			
			-- Busqueda de pivotes Zarpa
			pivotPawHeel = (lb.misc.searchInArrayByString pawprintObjs pivotPawHeelPart)[1] -- busca dentro de 'pawprintObjs' el objeto con parte del nombre almacenado en 'pawPivotFootHeelPart' y lo almacena en 'pivotPawHeel'
			nameParts = filterString pivotPawHeel.name "_"
			pivotPawHeel.name = substituteString pivotPawHeel.name ("_" + nameParts[5]) ("_" + frontBackPartString + toUpper (substring nameParts[5] 1 1) + ((substring nameParts[5] 2 nameParts[5].count)))
			
			append hiddenObj pivotPawHeel
			setUserProp pivotPawHeel "Definition" "Point de pivote desde la parte posterior de la zarpa en IK" -- definición de función de objeto.
			
			pawPivotOutside = (lb.misc.searchInArrayByString pawprintObjs pivotPawOutsidePart)[1] -- busca dentro de 'pawprintObjs' el objeto con parte del nombre almacenado en 'pivotPawOutsidePart' y lo almacena en 'pawPivotOutside'
			nameParts = filterString pawPivotOutside.name "_"
			pawPivotOutside.name = substituteString pawPivotOutside.name ("_" + nameParts[5]) ("_" + frontBackPartString + toUpper (substring nameParts[5] 1 1) + ((substring nameParts[5] 2 nameParts[5].count)))
			append hiddenObj pawPivotOutside
			setUserProp pawPivotOutside "Definition" "Point de pivote desde la parte interior del pie en IK" -- definición de función de objeto
			
			pawPivotInside = (lb.misc.searchInArrayByString pawprintObjs pivotPawInsidePart)[1] -- busca dentro de 'pawprintObjs' el objeto con parte del nombre almacenado en 'pivotPawInsidePart' y lo almacena en 'pawPivotInside'
			nameParts = filterString pawPivotInside.name "_"
			pawPivotInside.name = substituteString pawPivotInside.name ("_" + nameParts[5]) ("_" + frontBackPartString + toUpper (substring nameParts[5] 1 1) + ((substring nameParts[5] 2 nameParts[5].count)))
			append hiddenObj pawPivotInside
			setUserProp pawPivotInside "Definition" "Point de pivote desde la parte exterior del pie en IK" -- definición de función de objeto
			
			
			-- Emparentado y alineado de 'pawprint' con 'pawPositionRef' y 'pawBone' para simetría de posición con ChannelBox
			pawprint.parent = pawPositionRef -- emparentado de 'footStep' con 'footPositionRef'.
			pawprint.transform = pawBone.transform -- alineación de 'footStep' con 'footBone'.
			
 			adjustFootstep pawprint pivotPawHeel pawPivotOutside pawPivotInside
			
			pawprint.pivot = pawBone.pos
			
			LCpawprint.addTarget pawPositionRef 0
			
			
			-- Creación de pivotes Pie.
			pivotPawToe = lb.rig.createPointFromObj animalLeg07Bone classType:NC_classAnim sufix:"pivotPawToe" crossOp:off boxOp:on -- Creación de Point 'pivotPawToe' utilizando la función 'lb.rig.createPointFromObj'.
 			nameParts = filterString pivotPawToe.name "_" -- filtrado de nombre de 'pivotFootToe' por "_"
 			pivotPawToe.name = substituteString pivotPawToe.name ("_" + nameParts[5])  ("_" + frontBackPartString + "PivotPawToe") -- cambio de parte 5 del nombre por "pivotPawToe" y asignación a 'pivotPawToe'.
			setUserProp pivotPawToe "Definition" "Point de pivote desde la puntera de la zarpa en IK" -- definición de función de objeto
			append pawprintObjs pivotPawToe -- almacenado de 'pivotPawToe' en el array 'pawprintObjs'
			append hiddenObj pivotPawToe -- almacenado de 'pivotPawToe' en el array 'hiddenObj' para ocultarlo más adelante.
			
			
			pivotPawToe.parent = pawprint -- emparentado de 'pivotPawToe' a 'pawprint'.
			in CoordSys gimbal (pivotPawToe.pos.y = pivotPawHeel.pos.y) -- recolocación de posición de 'pivotPawToe' en eje Y, con posición Y de 'pivotPawHeel' en eje de coordenadas Gimbal.
			pivotPawToe.parent = pawPivotInside -- emparentado de 'pivotPawToe' a 'pawPivotInside'.
			pivotPawToe.size = 2.5
			
			
			pivotToes = lb.rig.createPointFromObj animalLeg06Bone classType:NC_classAnim sufix:"pivotToes" crossOp:off boxOp:on -- Creación de Point 'pivotToes' utilizando la función 'lb.rig.createPointFromObj'.
			nameParts = filterString pivotToes.name "_" -- filtrado de nombre de 'pivotToes' por "_"
			pivotToes.name = substituteString pivotToes.name ("_" + nameParts[5])  ("_" + frontBackPartString + "PivotToes") -- cambio de parte 5 del nombre por "pivotToes" y asignación a 'pivotToes'.
			setUserProp pivotToes "Definition" "Point de pivote para dedos zarpa en IK" -- definición de función de objeto
			append pawprintObjs pivotToes -- almacenamiento de 'pivotToes' en 'footStepObj'
			append hiddenObj pivotToes -- almacenado de 'pivotToes' en el array 'hiddenObj' para ocultarlo más adelante.
			pivotToes.centermarker = on -- marcar punto de pivote en 'pivotToes'.
			pivotToes.parent = pivotPawToe -- emparentado de 'pivotToes' a 'pivotPawToe'.
			pivotToes.size = 2.5
			
			
			--pivotHeel = copy pivotToes -- duplicado de 'pivotToes' y almacenado en 'pivotHeel'.
			pivotHeel = lb.rig.createPointFromObj pivotToes classType:NC_classAnim sufix:"pivotHeel" crossOp:off boxOp:on -- Creación de Point 'pivotToes' utilizando la función 'lb.rig.createPointFromObj'.
			nameParts = filterString pivotHeel.name "_"
			pivotHeel.name = substituteString pivotHeel.name ("_" + nameParts[5])  ("_" + frontBackPartString + "pivotHeel") -- cambio de nombre de parte 5 de 'pivotHeel' por "pivotHeel" y asignado a 'pivotHeel'.
			nameParts = filterString pivotHeel.name "_" -- filtrado de nombre de 'pivotHeel' por "_".
			pivotHeel.size = 3.5 -- cambio de tamaño de 'pivotHeel'.
			setUserProp pivotHeel "Definition" "Point de pivote para talon del pie en IK" -- definición de función de objeto
			append pawprintObjs pivotHeel -- almacenado de 'pivotHeel' en 'footStepObj'.
			append hiddenObj pivotHeel -- almacenado de 'pivotHeel' en el array 'hiddenObj' para ocultarlo más adelante.
			pivotHeel.parent = pivotPawToe -- emparentado de 'pivotHeel' a 'pivotPawToe'.
			
			
			-- Creación de Point para Offset Posición en ChannelBox de IkChain sistema IK
			pointIkChainOffset = lb.rig.createPointFromObj pivotPawHeel classType:NC_classAnim sufix:"IkChainOffset" crossOp:off boxOp:on -- creación de point padre para toda la estructura de la mano.
			pointIkChainOffset.name = substituteString pointIkChainOffset.name "#" ""
			pointIkChainOffset.size = 9
			setUserProp pointIkChainOffset "Definition" "Point padre del pivote pivotFootHeel del sistema Ik de la pierna e hijo de la huella IK. Ejes alineados para poder realizar Offset de posición simétrico desde ChannelBox" -- definición de función de objeto.
			pointIkChainOffset.parent = pawprint
			pointIkChainOffset.transform = pointPawOffset.transform
			pointIkChainOffset.position = pivotPawHeel.position
			append hiddenObj pointIkChainOffset -- almacenamiento de 'pointIkChainOffset' en array 'hiddenObj'.
			pointIkChainOffset.size = 3.5 -- cambio de tamaño de 'pointIkChainOffset'.
			
			if sidePart == NC_locationLeft then -- cambio de color de 'pointHandOffset' segun lado del personaje.
			(
				pointIkChainOffset.wirecolor = color 108 8 136
			)
			else
			(
				pointIkChainOffset.wirecolor = color 135 59 8
				
				-- Cambio de controladores activos en toesEndBone para jerarquizarlo.
				-- lb.rig.flipAxis #(pointIkChainOffset) true true true
				-- lb.rig.flipAxis #(pointPawOffset) true true true -- Flipeado de Axis de 'pointPawOffset' para asegurar su correcta orientación con 'pointIkChainOffset'.
			)
			lb.controller.freezeTransform pointIkChainOffset #all  -- Freeze de transformaciones para 'pointIkChainOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			pivotPawHeel.parent = pointIkChainOffset -- emparentado de 'pivotFootHeel' a 'pointIkChainOffset'.
			lb.controller.freezeTransform pivotPawHeel #all  -- Freeze de transformaciones para 'pivotFootHeel', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			-- lb.controller.freezeTransform a shape y pivotes de la zarpa.
			for i in pawprintObjs do -- bucle que recorre el array que contiene la huella y todos los pivotes auxiliares.
			(
				lb.controller.freezeTransform i #all -- Freeze de transformaciones para los objetos contenidos en 'pawprintObjs', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			)
			
			
			lb.rig.createConstraint ikAnimalLegBone05 ikanimalLeg04BoneEnd (frontBackPartString + "ikAnimalLegBone05_To_" + (substituteString ikanimalLegPart04 "_" "End")) pos:true rot:false scl:false keepPos:false keepRot:false keepScl:false  
			lb.rig.createConstraint pointPaw pawprint "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false 
			
			-- Ajustes 'toesEndBones' para que pivote en local.
			-- creación de hueso de referencia para toesEndBone.
			animalLeg07PosRef = lb.rig.smartCreateEnd animalLeg06Bone
			lb.misc.renameFromObj animalLeg07PosRef animalLeg06Bone.name NC_classAnim sufix:"PosRef" -- renombrado de 'footBoneIkRotRef' con la función 'lb.misc.renameFromObj'.
			nameArray = filterString animalLeg07PosRef.name "_" -- filtrado de nombre de 'pointPawOffset' por "_".
			animalLeg07PosRef.name = substituteString animalLeg07PosRef.name "#" ""
			animalLeg07PosRef.length = 0.5
			animalLeg07PosRef.width = 0.5
			animalLeg07PosRef.height = 0.5
			animalLeg07PosRef.sidefins = on
			animalLeg07PosRef.sidefinssize = 0.5
			append hiddenObj animalLeg07PosRef -- almacenamiento de 'toesEndPosRef' en array 'hiddenObj'.
			
			-- Cambio de controladores activos en toesEndBone para jerarquizarlo.
			lb.controller.setActiveController animalLeg07Bone #all #frozen
			animalLeg07Bone.parent = pawPivotInside
			lb.rig.createConstraint animalLeg07Bone animalLeg07PosRef "toesEnd_To_toesEndPosRef" pos:true rot:false scl:false keepPos:false keepRot:false keepScl:false
			lb.controller.setActiveController animalLeg07Bone #all #Zero
			
			
			pawPivotIk = GeoSphere pos:pawBone.pos radius:0.5 segs: 1 wirecolor: [255,0,0] isSelected:off -- creación de Geoesfera de referencia para pivote de IK y almacenado en 'pawPivotIk'.
			pawPivotIk.showFrozenInGray = false -- desactivado de visualización de objeto congelado en Gris.
			freeze pawPivotIk -- congelado de 'pawPivotIk'
			pawPivotIk.parent = pawPrint -- emparentado de 'pawPivotIk' a 'pawPrint'.
			lb.controller.freezeTransform pawPivotIk #all -- Freeze de transformaciones para 'pawPivotIk', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			lb.misc.renameFromObj pawPivotIk pawBone.name NC_classAnim sufix:"PivotIk" flags:NC_frozenFlag -- renombrado de 'footPivotIk' utilizando la función 'lb.misc.renameFromObj'.
			setUserProp pawPivotIk "Definition" "Esfera de referencia para marcar el punto de pivote del control IK de la zarpa." -- definición de función de objeto.
			
			if sidePart == NC_locationLeft then -- cambio de color de 'pawPivotIk' según lado del cuerpo.
			(
				pawPivotIk.wirecolor = color 135 6 6 -- lado "l" rojo oscuro.
			)
			else
			(
				pawPivotIk.wirecolor = color 255 0 0 -- lado "r" rojo.
			)
			
			
			-- Mergeado de jointOrientShape
			jointOrientShape = getSphereShape chrShapesPath chrName -- mergeado de 'sphereShape' utilizando la función getSphereShape de OM_rigSolutionFunctions.
			jointOrientShape.scale = [0.5,0.5,0.5]
			
			resetXform jointOrientShape --hacemos resetXform para mantener ejes
			
			collapseStack jointOrientShape --colpasamos el modificador	
			
			append xyzPosObj jointOrientShape
			
			jointOrientShape.Transform.controller = Link_Constraint ()
			LCjointOrientShape = jointOrientShape.controller
			
			chrLayer.addNode jointOrientShape -- añade 'jointOrientShape' a capa de personaje.
			lb.misc.renameFromObj jointOrientShape pawBone.name NC_classAnim flags:NC_controlFlag -- renombrado de 'jointOrientShape' utilizando la función 'lb.misc.renameFromObj'.
			nameParts = filterString jointOrientShape.name "_" -- filtrado del nombre de 'jointOrientShape' por "_".
			jointOrientShape.name = substituteString jointOrientShape.name ("_" + nameParts[5])  ("_" + frontBackPartString + "JointOrient") -- sustitución de parte 5 de nombre en 'jointOrientShape' por "jointOrient".
			append selSetAnimalLeg jointOrientShape -- almacena el objeto 'jointOrientShape' en array 'selSetAnimalLeg' para creación de Selection Sets.
			--append xyzPosObj jointOrientShape -- almacena 'jointOrientShape' en el array 'xyzPosObj' para asignar animTracks.
			append custAttribAnimalLegBones jointOrientShape
			
			-- creación de point para Offset y alineación correcta
			jointOrientOffset = lb.rig.createPointFromObj jointOrientShape classType:NC_classAnim sufix:"Offset" crossOp:off boxOp:on -- creación de point utilizando la función 'lb.rig.createPointFromObj'. Almacenado en 'jointOrientOffset'.
			nameParts = filterString jointOrientOffset.name "_" -- filtrado del nombre de 'jointOrientOffset' por "_".
			jointOrientOffset.name = substituteString jointOrientOffset.name ("_" + nameParts[5])  ("_" + frontBackPartString + "JointOrientOffset") -- sustitución de parte 5 de nombre en 'jointOrientShape' por "jointOrient".
			append hiddenObj jointOrientOffset -- almacena 'jointOrientOffset' en el array 'hiddenObj' para ocultarlo más adelante. 
			setUserProp jointOrientOffset "Definition" "Este point es padre del objeto jointOrient, para que mantenga la animación respecto a este point." -- definición de función de objeto.
			jointOrientOffset.size = 4 -- cambio de tamaño de 'jointOrientOffset'.
			
			jointOrientShape.parent = jointOrientOffset -- emparentado de 'jointOrientShape' a 'jointOrientOffset'.
			
			setTransformLockFlags jointOrientShape #{4..9} -- aplica los Locks indicados a 'jointOrientShape'.
			
			
			if frontBackPart == NC_locationFront then
				lb.rig.flipAxis #(jointOrientShape) true true true
			else if frontBackPart == NC_locationBack then
				lb.rig.flipAxis #(jointOrientShape) true false true
			
			LCjointOrientShape.addTarget jointOrientOffset 0
			
			
			jointOrientOffset.pos = animalLeg03Bone.pos -- recolocación de 'jointOrientOffset' con la posición de 'animalLeg03Bone'.
			
			jointOrientOffset.parent = base -- Emparentado 'jointOrientOffset' a 'base'.
			
			
			
			-- Alineación mediante constraints para conseguir una correcta orientación del controlador del codo.
			jointOrientOffset.parent = base -- emparentado de 'jointOrientShape' a 'jointOrientOffset'.
			lb.controller.freezeTransform jointOrientOffset #all -- Freeze de transformaciones para 'jointOrientOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			lb.rig.createConstraint jointOrientOffset ikAnimalLegBone03 "tempOrient" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- creación de constraint de Orientación utilizando la función 'lb.rig.createConstraint'.
			jointOrientOffset.rotation.controller[#tempOrient].appendTarget ikAnimalLegBone02 50 -- añade 'ikAnimalLegBone02' como target en constraint de Orientación con un peso de 50 para conseguir una orientación intermedia entre 'ikForearm' y 'ikAnimalLegBone02'. Así no cambiará la orientación del codo cuando definamos el target de Swivel Angle.
			
			if sidePart == NC_locationRight then -- cambio de Axis de 'jointOrientOffset' según lado del cuerpo.
				lb.rig.flipAxis #(jointOrientOffset) true true true
			
			lb.controller.freezeTransform jointOrientOffset #all -- Freeze de transformaciones para 'jointOrientOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'. De esta forma se elimina el constraint de orientación anterior y se mantiene la orientación que hemos conseguido de forma automática.
			
			-- rotaciones locales de 'jointOrientOffset', alineado de sus ejes de forma correcta para la animación.
			in CoordSys local rotate jointOrientOffset (eulerangles 90 0 0)
			in CoordSys local rotate jointOrientOffset (eulerangles 0 -90 0)
			
			if sidePart == NC_locationRight then -- cambio de Axis de 'jointOrientOffset' según lado del cuerpo.
 				lb.rig.flipAxis #(jointOrientOffset) false true true
			
			if frontBackPart == NC_locationBack then
				lb.rig.flipAxis #(jointOrientShape) false true true
			
			
			lb.controller.freezeTransform jointOrientOffset #all -- Freeze de transformaciones para 'jointOrientOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'. Para asegurar que la nueva orientación queda como transformación por defecto.
			
			-- Recolocación del control del codo para hacerlo más accesible.
			in CoordSys local move jointOrientOffset [-7.5,0,0]
			
			lb.controller.freezeTransform jointOrientOffset #all -- Freeze de transformaciones para 'jointOrientOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'. Para asegurar que la nueva orientación queda como transformación por defecto.
			
			
			-- Creación de Point de referencia de codo para FK/IK Snap
			ikjointOrientRef = lb.rig.createPointFromObj jointOrientShape classType:NC_classAnim sufix:"IkjointOrientRef" crossOp:on boxOp:off -- creación de point utilizando la función 'lb.rig.createPointFromObj'. Almacenado en 'ikjointOrientRef'.
			setUserProp ikjointOrientRef "Definition" "Punto que se utiliza como referencia de posición para el control del codo IK cuando se hace un Snap a FK." -- definición de función de objeto.
			jointOrientOffset.size = 4 -- cambio de tamaño de 'jointOrientOffset'.
			
			ikjointOrientRef.parent = animalLeg03Bone -- Emparentado de 'ikjointOrientRef' a 'animalLeg03Bone'. De esta forma siempre existe una referencia de donde estaría en modo FK el control del codo IK.
			
			ikjointOrientRef.transform = jointOrientShape.transform -- Alineado en Posición y Rotación de 'ikjointOrientRef' con 'jointOrientShape' para definirle la posición por defecto de referencia.
			lb.controller.freezeTransform ikjointOrientRef #all -- Freeze de transformaciones para 'ikjointOrientRef', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'. Para asegurar que las nuevas transformaciones quedan por defecto.
			
			nameParts = filterString ikjointOrientRef.name "_" -- Filtrado de nombre de 'ikjointOrientRef' por "_".
			ikjointOrientRef.name = substituteString ikjointOrientRef.name ("_" + nameParts[5])  ("_" + frontBackPartString + "IkjointOrientRef") -- Sustitución de parte 5 de nombre de 'ikjointOrientRef'.
			append hiddenObj ikjointOrientRef -- almacena 'ikjointOrientRef' en el array 'hiddenObj' para ocultarlo más adelante. 
			
			
			-- Creación de hueso Brazo de Nadador (Chiken Wing) que controla la posición del codo en IK.
			p1 = pointAnimalLeg.transform.pos -- almacenado en 'p1' de la posición de 'pointAnimalLeg' para calculo de plano de transformación del hueso.
-- 			p2 = animalLeg04Bone.transform.pos -- almacenado en 'p2' de la posición de 'pointPaw' para calculo de plano de transformación del hueso.
			p2 = animalLeg04BoneEnd.transform.pos -- almacenado en 'p2' de la posición de 'pointPaw' para calculo de plano de transformación del hueso.
			p3 = jointOrientOffset.transform.pos -- almacenado en 'p3' de la posición de 'jointOrientOffset' para calculo de plano de transformación del hueso.
			
			v1 = p2 - p1 -- calculo de vector 'v1' con los puntos 'p1' y 'p2'.
			v2 = p3 - p1 -- calculo de vector 'v2' con los puntos 'p1' y 'p3'.
			
			dir = normalize (cross v1 v2) -- calculo de la dirección Z que se utilizará para orientar el hueso 'jointOrientBone'.
			
			jointOrientBone = boneSys.createBone p1 p2 dir -- creación de hueso 'jointOrientBone' desde el punto 'p1' al 'p2' con eje Z en dirección 'dir'.
			setUserProp jointOrientBone "Definition" "Hueso padre de control del codo IK, tiene un IKLimb aplicado para mantener siempre la misma orientación del codo." -- definición de función de objeto.
			
			-- parametros de 'jointOrientBone'.
			jointOrientBone.width = 0.25
			jointOrientBone.height = 0.25
			jointOrientBone.sidefins = off
			jointOrientBone.frontfin = on
			jointOrientBone.frontfinsize = 3
			jointOrientBone.backfin = off
			
-- 			if sidePart == NC_locationRight then	
-- 				lb.rig.flipAxis #(jointOrientBone) true false true
			
			append hiddenObj jointOrientBone -- almacena 'jointOrientBone' en el array 'hiddenObj' para ocultarlo más adelante. 
			
			lb.misc.renameFromObj jointOrientBone jointOrientShape.name NC_classAnim flags:(NC_hiddenFlag + NC_frozenFlag) -- renombrado de 'jointOrientBone' utilizando la función 'lb.misc.renameFromObj'.
			nameParts = filterString jointOrientBone.name "_" -- Filtrado de nombre de 'jointOrientBone'
			jointOrientBone.name = substituteString jointOrientBone.name ("_" + nameParts[5])  ("_" + frontBackPartString + "JointOrientBone") -- sustitución de la parte 5 del nombre por "jointOrientBone".
			
			jointOrientBoneEnd = lb.rig.smartCreateEnd jointOrientBone -- creación de hueso End para 'jointOrientBone', almacenado en 'jointOrientBoneEnd'.
			-- parametros de 'jointOrientBoneEnd'.
			jointOrientBoneEnd.frontfin = off
			
			
			-- Creación de hueso para mantener plano de transformación de la pata en IK.
			p1 = pawBone.transform.pos -- almacenado en 'p1' de la posición de 'pointPaw' para calculo de plano de transformación del hueso.
			p2 = pointAnimalLeg.transform.pos -- almacenado en 'p2' de la posición de 'pointAnimalLeg' para calculo de plano de transformación del hueso.
			p3 = jointOrientOffset.transform.pos -- almacenado en 'p3' de la posición de 'jointOrientOffset' para calculo de plano de transformación del hueso.
			
			v1 = p2 - p1 -- calculo de vector 'v1' con los puntos 'p1' y 'p2'.
			v2 = p3 - p1 -- calculo de vector 'v2' con los puntos 'p1' y 'p3'.
			
			dir = normalize (cross v1 v2) -- calculo de la dirección Z que se utilizará para orientar el hueso 'jointOrientBone'.
			
			transformPlaneBone = boneSys.createBone p1 p2 dir -- creación de hueso 'transformPlaneBone' desde el punto 'p1' al 'p2' con eje Z en dirección 'dir'.
			setUserProp transformPlaneBone "Definition" "." -- definición de función de objeto.
			
			-- parametros de 'transformPlaneBone'.
			transformPlaneBone.width = 0.5
			transformPlaneBone.height = 0.5
			transformPlaneBone.sidefins = on
			transformPlaneBone.sidefinssize = 0.5
			transformPlaneBone.frontfin = off
-- 			transformPlaneBone.backfin = on
			transformPlaneBone.backfin = off
			transformPlaneBone.backfinsize = 1
			
-- 			if sidePart == NC_locationRight then	
-- 				lb.rig.flipAxis #(transformPlaneBone) true false true
			
			lb.misc.renameFromObj transformPlaneBone jointOrientShape.name NC_classAnim flags:(NC_hiddenFlag + NC_frozenFlag) -- renombrado de 'transformPlaneBone' utilizando la función 'lb.misc.renameFromObj'.
			nameParts = filterString transformPlaneBone.name "_" -- Filtrado de nombre de 'jointOrientBone'
			transformPlaneBone.name = substituteString transformPlaneBone.name ("_" + nameParts[5])  ("_" + frontBackPartString + "TransformPlane") -- sustitución de la parte 5 del nombre por "transformPlane".
			
			transformPlaneBoneEnd = lb.rig.smartCreateEnd transformPlaneBone -- creación de hueso End para 'transformPlaneBone', almacenado en 'transformPlaneBoneEnd'.
			-- parametros de 'transformPlaneBoneEnd'.
			transformPlaneBoneEnd.frontfin = off
			
			-- pasternRotationPoint = lb.rig.createPointFromObj pawBone classType:NC_classAnim sufix:"pasternRotation" crossOp:off boxOp:on -- creación de point padre para toda la estructura de la mano.
			pasternRotationPoint = lb.rig.createPointFromObj animalLeg04Bone classType:NC_classAnim sufix:"pasternRotation" crossOp:off boxOp:on -- creación de point padre para toda la estructura de la mano.
			pasternRotationPoint.pos = pawBone.pos
			
			
 			in CoordSys local rotate pasternRotationPoint (eulerangles 180 0 0)
-- 			pasternRotationPoint.parent = transformPlaneBone
			pasternRotationPoint.parent = jointOrientBone
			lb.controller.freezeTransform pasternRotationPoint #all -- Freeze de transformaciones para 'pasternRotationPoint', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			nameParts = filterString pasternRotationPoint.name "_" -- Filtrado de nombre de 'jointOrientBone'
			pasternRotationPoint.name = substituteString pasternRotationPoint.name ("_" + nameParts[5])  ("_" + frontBackPartString + "PasternRotation") -- sustitución de la parte 5 del nombre por "pasternRotation".
			pasternRotationPoint.size = 1.5
			
			lb.rig.flipAxis #(pasternRotationPoint) false true true
			
			append hiddenObj pasternRotationPoint -- almacena 'pasternRotationPoint' en el array 'hiddenObj' para ocultarlo más adelante.
			
			
			if sidePart == NC_locationLeft then -- cambio de color de 'jointOrientBone' y 'jointOrientBoneEnd' según lado del personaje al que pertenezcan.
			(
				jointOrientBone.wirecolor = color 105 200 235
				jointOrientBoneEnd.wirecolor = color 105 200 235
				transformPlaneBone.wirecolor = color 105 200 235
				transformPlaneBoneEnd.wirecolor = color 105 200 235
				pasternRotationPoint.wirecolor = color 105 200 235
			)
			else
			(
				jointOrientBone.wirecolor = color 65 255 130
				jointOrientBoneEnd.wirecolor = color 65 255 130
				transformPlaneBone.wirecolor = color 65 255 130
				transformPlaneBoneEnd.wirecolor = color 65 255 130
				pasternRotationPoint.wirecolor = color 65 255 130
			)
			
			
			pointjointOrientBone = lb.rig.createPointFromObj jointOrientBone classType:NC_classAnim sufix:"Parent" crossOp:off boxOp:on -- creación de point padre para toda la estructura de la mano.
			pointjointOrientBone.name = substituteString pointjointOrientBone.name "#" ""
			pointjointOrientBone.size = 1.5
			pointjointOrientBone.parent = transformPlaneBoneEnd
			jointOrientBone.parent = pointjointOrientBone
			transformPlaneBone.parent = pivotHeel
			
			lb.controller.freezeTransform jointOrientBone #all -- Freeze de transformaciones para 'jointOrientBone', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			lb.controller.freezeTransform pointjointOrientBone #all -- Freeze de transformaciones para 'pointjointOrientBone', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			lb.controller.freezeTransform transformPlaneBone #all -- Freeze de transformaciones para 'transformPlaneBone', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			jointOrientOffset.pivot = jointOrientBone.pos -- recolocación de pivote de 'jointOrientOffset' en posición de 'jointOrientBone'
			lb.controller.freezeTransform jointOrientOffset #all -- Freeze de transformaciones para 'jointOrientOffset', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			lb.controller.freezeTransform jointOrientShape #all -- Freeze de transformaciones para 'jointOrientShape', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			
			-- Constraints de follow jointOrient.
			lb.rig.createConstraint jointOrientOffset pointAnimalLeg "Follow_jointPos" pos:true rot:false scl:false keepPos:true keepRot:true keepScl:false -- creación de constraint de Orientación utilizando la función 'lb.rig.createConstraint'.
-- 			lb.rig.createConstraint jointOrientOffset jointOrientBone "Follow_jointOrient" pos:false rot:true scl:false keepPos:true keepRot:true keepScl:false -- creación de constraint de Orientación utilizando la función 'lb.rig.createConstraint'.
			lb.rig.createConstraint jointOrientOffset transformPlaneBone "Follow_jointOrient" pos:false rot:true scl:false keepPos:true keepRot:true keepScl:false -- creación de constraint de Orientación utilizando la función 'lb.rig.createConstraint'.
			--jointOrientOffset.position.controller[#Follow_jointPos].appendTarget pawBone 50 -- añade target 'pawprint' al constraint anterior con un peso de 50.
			
			
			-- ikChains
			-- ikChains jointOrientBone
-- 			jointOrientBoneIkChain = iksys.ikchain jointOrientBone jointOrientBoneEnd "IKLimb" -- creación de IKChain desde hueso 'ikAnimalLegBone04' a 'ikanimalLeg04BoneEnd' y de tipo "IKLimb". Almacenado en 'pasternIkChain'
			jointOrientBoneIkChain = iksys.ikchain jointOrientBone jointOrientBoneEnd "IKHISolver" -- creación de IKChain desde hueso 'ikAnimalLegBone04' a 'ikanimalLeg04BoneEnd' y de tipo "IKLimb". Almacenado en 'pasternIkChain'
			clearSelection()
			lb.misc.renameFromObj jointOrientBoneIkChain jointOrientBone.name NC_classAnim sufix:"IkChain" flags:(NC_hiddenFlag + NC_frozenFlag) -- renombrado de 'jointOrientBone' utilizando la función 'lb.misc.renameFromObj'.
			
			jointOrientBoneIkChain.transform.controller.VHTarget = jointOrientShape
			
-- 			jointOrientBoneIkChain.parent = pasternRotationPoint
			jointOrientBoneIkChain.parent = pivotHeel
			lb.controller.freezeTransform jointOrientBoneIkChain #all

			transformPlaneBoneIkChain = iksys.ikchain transformPlaneBone transformPlaneBoneEnd "IKLimb" -- creación de IKChain desde hueso 'transformPlaneBone' a 'transformPlaneBoneEnd' y de tipo "IKLimb". Almacenado en 'pasternIkChain'
			clearSelection()
			lb.misc.renameFromObj transformPlaneBoneIkChain transformPlaneBone.name NC_classAnim sufix:"IkChain" flags:(NC_hiddenFlag + NC_frozenFlag) -- renombrado de 'jointOrientBone' utilizando la función 'lb.misc.renameFromObj'.
			transformPlaneBoneIkChain.parent = pointAnimalLeg
			transformPlaneBoneIkChain.transform = pointAnimalLeg.transform
			lb.controller.freezeTransform transformPlaneBoneIkChain #all
			
			-- ikChains Pata
			pawIkChain = iksys.ikchain  ikAnimalLegBone02 ikAnimalLegBone04 "IKHISolver" -- creación de IKChain desde hueso 'ikAnimalLegBone02' a 'ikAnimalLegBone04' y de tipo "IKHISolver". Almacenado en 'pawIkChain'
			clearSelection()
			
			pawIkChain.parent = pivotHeel -- emparentado de 'pawIkChain' a 'pivotHeel'
			lb.misc.renameFromObj pawIkChain pawBone.name NC_classAnim sufix:"IkChain" flags:(NC_hiddenFlag + NC_frozenFlag) -- renombrado de 'pawIkChain' utilizando la función 'lb.misc.renameFromObj'.
			
			pawIkChain.transform.controller.VHTarget = jointOrientShape
			
			pawIkChain.transform = animalLeg04Bone.transform -- alineado de 'pawIkChain' con 'pawBone'.
			
			pawIkChain.parent = pasternRotationPoint
			append hiddenObj pawIkChain -- almacenado de 'pawIkChain' en array 'hiddenObj', para ocultarlo mas adelante.
			lb.controller.freezeTransform pawIkChain #all -- Freeze de transformaciones para 'pawIkChain', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			
			pasternIkChain = iksys.ikchain ikAnimalLegBone04 ikanimalLeg04BoneEnd "IKLimb" -- creación de IKChain desde hueso 'ikAnimalLegBone04' a 'ikanimalLeg04BoneEnd' y de tipo "IKLimb". Almacenado en 'pasternIkChain'
			clearSelection()
			
			lb.misc.renameFromObj pasternIkChain animalLeg04Bone.name NC_eeclassRig sufix:"IkChain" flags:(NC_hiddenFlag + NC_frozenFlag) -- renombrado de 'pawIkChain' utilizando la función 'lb.misc.renameFromObj'.
			
			pasternIkChain.parent = pivotHeel
			
			lb.controller.freezeTransform pasternIkChain #all -- Freeze de transformaciones para 'pasternIkChain', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			pasternIkChain.transform.controller.SAParent = 0
			
			
			-- ikChain Empeine
			instepIkChain = iksys.ikchain  ikAnimalLegBone05 ikAnimalLegBone06 "IKHISolver" -- creación de IKChain desde hueso 'ikAnimalLegBone05' a 'ikAnimalLegBone06' y de tipo "IKHISolver". Almacenado en 'instepIkChain'
			clearSelection()
			
			instepIkChain.parent = pivotPawToe -- emparentado de 'instepIkChain' a 'pivotPawToe'.
			-- rename instepIkChain animalLeg05Bone.name NC_classAnim "IkChain" NC_hiddenFlag -- cambio de nombre de 'instepIkChain' utilizando la función 'rename' de OM_rigSolutionFunctions.
			lb.misc.renameFromObj instepIkChain animalLeg05Bone.name NC_classAnim sufix:"IkChain" flags:(NC_hiddenFlag + NC_frozenFlag) -- renombrado de 'instepIkChain' utilizando la función 'lb.misc.renameFromObj'.
			instepIkChain.transform = animalLeg06Bone.transform -- alineado de 'instepIkChain' con 'animalLeg06Bone'.
			instepIkChain.transform.controller.SAParent = 0 -- cambio del parametro de 'instepIkChain' "Parent Space:" a "IK Goal".
			append hiddenObj instepIkChain -- almacenado de 'instepIkChain' en array 'hiddenObj', para ocultarlo mas adelante.
			lb.controller.freezeTransform instepIkChain #all -- Freeze de transformaciones para 'instepIkChain', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			--ikChain Dedos Pie
			toesEndIkChain = iksys.ikchain ikAnimalLegBone06 ikAnimalLegBone07 "IKHISolver" -- creación de IKChain desde hueso 'ikAnimalLegBone06' a 'ikAnimalLegBone07' y de tipo "IKHISolver". Almacenado en 'toesEndIkChain'
			clearSelection()
			
			toesEndIkChain.parent = pivotToes -- emparentado de 'toesEndIkChain' a 'pivotToes'.
			lb.misc.renameFromObj toesEndIkChain animalLeg06Bone.name NC_classAnim sufix:"IkChain" flagqs:(NC_hiddenFlag + NC_frozenFlag) -- renombrado de 'toesEndIkChain' utilizando la función 'lb.misc.renameFromObj'.
			toesEndIkChain.transform = animalLeg07Bone.transform -- alineado de 'toesEndIkChain' con 'animalLeg07Bone'.
			toesEndIkChain.transform.controller.SAParent = 0 -- cambio del parametro de 'toesEndIkChain' "Parent Space:" a "IK Goal".
			append hiddenObj toesEndIkChain -- almacenado de 'toesEndIkChain' en array 'hiddenObj', para ocultarlo mas adelante.
			lb.controller.freezeTransform toesEndIkChain #all -- Freeze de transformaciones para 'toesEndIkChain', utilizando función 'lb.controller.freezeTransform' de lbTools_controllers functions'.
			
			
			-- Constraints Fk-IK
			lb.rig.createConstraint pawBone animalLeg04BoneEnd (frontBackPartString + "PawBone_To_" + (substituteString animalLegPart04 "_" "End")) pos:true rot:false scl:false keepPos:false keepRot:false keepScl:false -- constraint de posición para fijar el pie al tobillo. Utilizando la función 'lb.rig.createConstraint'.
			lb.rig.createConstraint pawBone pawBoneIkRotRef "Force align in IK Rot" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- constraint de orientación para evitar dobles transformaciones en rotaciones de IK del pie. Utilizando la función 'lb.rig.createConstraint'.
			lb.rig.createConstraint animalLeg02Bone ikAnimalLegBone02 "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- constraint de rotación de muslo Fk a muslo IK, es el contraint que hace el cambio de FK a IK. Utilizando la función 'lb.rig.createConstraint'.
			lb.rig.createConstraint animalLeg03Bone ikAnimalLegBone03 "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- constraint de rotación de pantorrilla Fk a pantorrilla IK, es el contraint que hace el cambio de FK a IK. Utilizando la función 'lb.rig.createConstraint'.
			lb.rig.createConstraint animalLeg04Bone ikAnimalLegBone04 "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- constraint de rotación de pantorrilla Fk a pantorrilla IK, es el contraint que hace el cambio de FK a IK. Utilizando la función 'lb.rig.createConstraint'.
			lb.rig.createConstraint animalLeg05Bone ikAnimalLegBone05 "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- constraint de rotación de empeine Fk a empeine IK, es el contraint que hace el cambio de FK a IK. Utilizando la función 'lb.rig.createConstraint'.
			lb.rig.createConstraint animalLeg06Bone ikAnimalLegBone06 "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- constraint de rotación de dedos Fk a dedos IK, es el contraint que hace el cambio de FK a IK. Utilizando la función 'lb.rig.createConstraint'.
			lb.rig.createConstraint animalLeg07Bone ikAnimalLegBone07 "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false -- constraint de rotación de hueso puntera Fk a hueso puntera IK, es el contraint que hace el cambio de FK a IK. Utilizando la función 'lb.rig.createConstraint'.
			
			
			-- Controladores dobles para FK IK
			FkIkControllers pawBone true true -- añade doble controlador de Fk e IK en posición y rotación a 'footBone'.
			FkIkControllers animalLeg04Bone false true -- añade doble controlador de Fk e IK en rotación a 'animalLeg04Bone'.
			FkIkControllers animalLeg06Bone false true -- añade doble controlador de Fk e IK en rotación a 'animalLeg06Bone'.
-- 			animalLeg07Bone.rotation.controller.setName 2 "Zero Ik Euler XYZ" -- Renombrado del controlador para Ik.
			
			-- Instanciado de controlador para offset de la Zarpa con la Huella
			pivotPawHeel.position.controller[#Zero_Pos_XYZ].controller = pawBone.position.controller[#Zero_Ik_Pos_XYZ].controller
			
			-- Custom Attributes Pata.
			-- Añadido de Custom Attributes
			for bon in custAttribAnimalLegBones do
			(
				addAttributeHolder bon "Animal_Leg_Controls" -- añade attribute holder vacio.
				clearSelection() -- es necesario deseleccionar cualquier objeto en este momento para que puedan aplicarse los custom Attributes sin que salte un error.
 				custAttributes.add bon.modifiers[#Animal_Leg_Controls] CA_ARS_fkIkAnimalLeg #unique
				
				-- Asignación de Controlador a Custom Attributes para poder instanciarlo en las diferentes conexiones.
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkik.controller = bezier_float ()
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkik.controller = float_limit upper_limit: 1 lower_limit: 0
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].followJoint.controller = bezier_float ()
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].followJoint.controller = float_limit upper_limit: 1 lower_limit: 0
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixAnimalLeg.controller = bezier_float ()
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixAnimalLeg.controller = float_limit upper_limit: 1 lower_limit: 0
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixPaw.controller = bezier_float ()
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixPaw.controller = float_limit upper_limit: 1 lower_limit: 0
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkikPaw.controller = bezier_float ()
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkikPaw.controller = float_limit upper_limit: 1 lower_limit: 0
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkikPaw.controller = float_list ()
				
				FloatExpr = bon.modifiers[#Animal_Leg_Controls].fkIkSnaps.fkikPaw.controller.Available.controller = Float_Expression ()
				FloatExpr.AddScalarTarget "fkIk" bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkik.controller.Limited_Controller__Bezier_Float.controller
				FloatExpr.AddScalarTarget "fkIkPaw" bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkikPaw.controller.Float_Limit.controller.Limited_Controller__Bezier_Float.controller
				FloatExpr.setExpression "fkIk * fkIkPaw"
				
				bon[#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkikPaw].controller[#weights][#Weight__Float_Expression].value = 0.0
				
				-- Estado de los Controles por defecto
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkik.controller.value = 1
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].followJoint.controller.value = 1
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixAnimalLeg.controller.value = 0
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkikPaw.controller.value = 1
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixPaw.controller.value = 1
				
				
				-- Instanciado de Modificadores de Custom Attributes.
				---animalLegCA = bon.modifiers[#Animal_Leg_Controls] -- Almacenado del modificador en 'legCA'
				
				
				-- Definición de Parameters
				bon.modifiers[#Animal_Leg_Controls].ikAnimalLegBone02Snap = (nodeTransformMonitor node:ikAnimalLegBone02 forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].ikAnimalLegBone03Snap = (nodeTransformMonitor node:ikAnimalLegBone03 forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].ikAnimalLegBone04Snap = (nodeTransformMonitor node:ikAnimalLegBone04 forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].ikJointOrientSnap = (nodeTransformMonitor node:jointOrientShape forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].ikPawprintSnap = (nodeTransformMonitor node:pawprint forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].ikAnimalLegBone06Snap = (nodeTransformMonitor node:ikAnimalLegBone06 forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].ikAnimalLegBone07Snap = (nodeTransformMonitor node:animalLeg07Bone forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].ikPasternRotationPointSnap = (nodeTransformMonitor node:pasternRotationPoint forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				
				bon.modifiers[#Animal_Leg_Controls].fkAnimalLegBone02Snap = (nodeTransformMonitor node:animalLeg02Bone forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].fkAnimalLegBone03Snap = (nodeTransformMonitor node:animalLeg03Bone forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].fkAnimalLegBone04Snap = (nodeTransformMonitor node:animalLeg04Bone forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].fkJointOrientSnap = (nodeTransformMonitor node:ikjointOrientRef forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].fkPawSnap = (nodeTransformMonitor node:pawBone forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				bon.modifiers[#Animal_Leg_Controls].fkAnimalLegBone06Snap = (nodeTransformMonitor node:animalLeg06Bone forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				
				bon.modifiers[#Animal_Leg_Controls].sidePart = (filterString pawprint.name "_")[4]
				
				for b in ikToes do
					append bon.modifiers[#Animal_Leg_Controls].ikToesSnap (nodeTransformMonitor node:b forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
				
				for b in animalLegPartToes do
					append bon.modifiers[#Animal_Leg_Controls].fkToesSnap (nodeTransformMonitor node:b forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false)
			)
			
			
			-- Añadido de'stretchy_Controls'.
			for i=1 to stretchyFkObj.count do
			(
				custAttributes.add stretchyFkObj[i].modifiers[#Animal_Leg_Controls] CA_ARS_stretchy #unique -- añade el CustomAttribute 'CA_ARS_stretchy' a 'stretchyFkObj[i]'.
				stretchyFkObj[i].modifiers[#Animal_Leg_Controls].custAttributes[#stretchy][#stretch].controller = bezier_float()
			)
			
			for bon in custAttribAnimalLegBones do
			(
				custAttributes.add  bon.modifiers[#Animal_Leg_Controls] CA_ARS_autoStretchIk #unique -- añade el CustomAttribute 'CA_ARS_autoStretchIk' a 'stretchyFkObj[i]'.
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#autoStretchIk][#AutoStretch_IK].controller = bezier_float()
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#autoStretchIk][#AutoStretch_IK].controller = float_limit upper_limit: 1 lower_limit: 0
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#autoStretchIk][#adjustAngle].controller = bezier_float()
				bon.modifiers[#Animal_Leg_Controls].custAttributes[#autoStretchIk][#adjustAngle].controller = float_limit lower_limit: 0
			)
			
			-- Asignación de Virtual Worlds a objetos con Link_Constraint.
			try custAttributes.delete pawPrint pawPrint.modifiers[#Animal_Leg_Controls].custattributes[#linkConstraintInfo] catch()
			custAttributes.add pawPrint.modifiers[#Animal_Leg_Controls] lb.customAttributes.linkConstraintARSCA #unique	-- Creación de Point Scripts
			pawPrint.modifiers[#Animal_Leg_Controls].ARS_linkConstraint.worldParent = pawPositionRef
			
			try custAttributes.delete jointOrientShape jointOrientShape.modifiers[#Animal_Leg_Controls].custattributes[#linkConstraintInfo] catch()
			custAttributes.add jointOrientShape.modifiers[#Animal_Leg_Controls] lb.customAttributes.linkConstraintARSCA #unique	-- Creación de Point Scripts
			jointOrientShape.modifiers[#Animal_Leg_Controls].ARS_linkConstraint.worldParent = jointOrientOffset
			
			
			-- AutoStretch Pata.
			autoStretchBoneChain stretchyIkObj stretchyFkObj pointAnimalLeg pawprint #Animal_Leg_Controls base
			
			if sidePart == NC_locationLeft then
			(
				FloatExpr = ikanimalLeg04BoneEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller
				FloatExpr.setExpression ("if (length (refPosFinal - refPosInit)/scale > totalLength, (((length (refPosFinal - refPosInit)/scale - totalLength)/3) *autoStretchCtrl) + adjustAngleCtrl + stretchyCtrl, stretchyCtrl + adjustAngleCtrl)")
				
				FloatExpr = ikAnimalLegBone04.position.controller[#Zero_Pos_XYZ][#X_Position].controller
				FloatExpr.setExpression ("if (length (refPosFinal - refPosInit)/scale > totalLength, (((length (refPosFinal - refPosInit)/scale - totalLength)/3) *autoStretchCtrl) + adjustAngleCtrl + stretchyCtrl, stretchyCtrl + adjustAngleCtrl)")
				
				FloatExpr = ikanimalLegBone03.position.controller[#Zero_Pos_XYZ][#X_Position].controller
				FloatExpr.setExpression ("if (length (refPosFinal - refPosInit)/scale > totalLength, (((length (refPosFinal - refPosInit)/scale - totalLength)/3) *autoStretchCtrl) + adjustAngleCtrl + stretchyCtrl, stretchyCtrl + adjustAngleCtrl)")
			)
			else if sidePart == NC_locationRight then
			(
				FloatExpr = ikanimalLeg04BoneEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller
				FloatExpr.setExpression ("if (length (refPosFinal - refPosInit)/scale > totalLength, (((length (refPosFinal - refPosInit)/scale - totalLength)/3) * - autoStretchCtrl) - adjustAngleCtrl - stretchyCtrl, -stretchyCtrl - adjustAngleCtrl)")
				
				FloatExpr = ikAnimalLegBone04.position.controller[#Zero_Pos_XYZ][#X_Position].controller
				FloatExpr.setExpression ("if (length (refPosFinal - refPosInit)/scale > totalLength, (((length (refPosFinal - refPosInit)/scale - totalLength)/3) * - autoStretchCtrl) - adjustAngleCtrl - stretchyCtrl, -stretchyCtrl - adjustAngleCtrl)")
				
				FloatExpr = ikanimalLegBone03.position.controller[#Zero_Pos_XYZ][#X_Position].controller
				FloatExpr.setExpression ("if (length (refPosFinal - refPosInit)/scale > totalLength, (((length (refPosFinal - refPosInit)/scale - totalLength)/3) * - autoStretchCtrl) - adjustAngleCtrl - stretchyCtrl, -stretchyCtrl - adjustAngleCtrl)")
			)
			
			animalLeg04BoneEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller = ikanimalLeg04BoneEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller
			animalLeg04Bone.position.controller[#Zero_Pos_XYZ][#X_Position].controller = ikAnimalLegBone04.position.controller[#Zero_Pos_XYZ][#X_Position].controller
			animalLeg03Bone.position.controller[#Zero_Pos_XYZ][#X_Position].controller = ikanimalLegBone03.position.controller[#Zero_Pos_XYZ][#X_Position].controller
			
			xPosControl = ikAnimalLegBone04.position.controller[#Zero_Pos_XYZ][#X_Position].controller
			stretchyAnimalLeg03Ctrl = animalLeg03Bone.modifiers[#Animal_Leg_Controls].custAttributes[#stretchy].Stretch.controller
			
			FloatExpr = pawIkChain.position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_Expression()
			
			FloatExpr.AddScalarTarget "xPosControl" xPosControl
			FloatExpr.AddScalarTarget "stretchyAnimalLeg03Ctrl" stretchyAnimalLeg03Ctrl
			
			FloatExpr.setExpression ("-xPosControl + stretchyAnimalLeg03Ctrl")
			
			
			
			pointScripts = undefined
			
			pointScripts = execute ("$'" + "_" + NC_chrPrefix + "_" + chrName + "_" + NC_classAnim + "_" + sidePart + "_" + "scripts" + "_" + NC_locationNotSpecified + "_" + (NC_frozenFlag + NC_hiddenFlag) + "'")
			
			if pointScripts == undefined then pointScripts = createPointScripts base -- Utilización de la función 'createPointScripts'.
			
			append hiddenObj pointScripts -- almacenado de 'pointScripts' en 'hiddenObj' para ocultarlo más adelante.
			
			
			-- Creación de Controller Script.
			----------------------------------------------------------------------------
			-- comprobación de la existencia de Controlador de Script.
			nameController = "" -- variable vacia para almacenar el número del controlador.
			if pointScripts.pos.controller.count > 0 then -- comprobación que existe algún controlador.
			nameController = pointScripts.pos.controller.getName pointScripts.pos.controller.count -- almacenado de nombre del último controlador.
			
			-- nombre final para el último controlador.
			ctrlName = sidePart + "_" + frontBackPartString + "_Leg_Script" -- construcción del nuevo nombre del controlador utilizando parte del nombre de 'thighBone'.
			
			pointScripts.pos.controller.available.controller = Position_Script() -- añade un controlador 'Position_Script' a 'pointScripts'.
			
			-- Cambio del nombre del controlador.
			pointScripts.pos.controller.setName (pointScripts.pos.controller.count) ctrlName -- asigna el nombre almacenado en crtlName al último controlador.
			
			scriptCtrl = pointScripts.pos.controller[pointScripts.pos.controller.count] -- almacenado del último controlador del 'pointScripts' en 'scriptCtrl'.
			
			
			-- Creación de variables para 'scriptCtrl'.
			fkIkController = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkik.controller
			fkIkPawController = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkikPaw.controller[#Float_Limit].controller
			
			-- creación de variables.
			scriptCtrl.addObject #fkik fkIkController
			scriptCtrl.addObject #fkikPaw fkIkPawController
			scriptCtrl.addObject #animalLeg02 animalLeg02Bone
			scriptCtrl.addObject #animalLeg03 animalLeg03Bone
			scriptCtrl.addObject #animalLeg04 animalLeg04Bone
			scriptCtrl.addObject #paw pawBone
			scriptCtrl.addObject #animalLeg05 animalLeg05Bone
			-- scriptCtrl.addObject #toes toesBone
			scriptCtrl.addObject #animalLeg06 animalLeg06Bone
			-- scriptCtrl.addObject #toesEnd toesEndBone
			scriptCtrl.addObject #animalLeg07 animalLeg07Bone
			scriptCtrl.addObject #pawprint pawprint
			scriptCtrl.addObject #base base
			
			for i = 1 to animalLegPartToes.count do
				scriptCtrl.addObject ("toe" + i as String) animalLegPartToes[i]
			
			
			-- Introducción de script como texto al Script controller.
			-- Start Script:
			expression = "pPaw = paw.position.controller\n" +
			"rPaw = paw.rotation.controller\n" +
			"rAnimalLeg04 = animalLeg04.rotation.controller\n" +
			"rAnimalLeg06 = animalLeg06.rotation.controller\n" +
			"toeBones = #("
			
			for i = 1 to animalLegPartToes.count do
				expression += ("toe" + i as String + (if i < animalLegPartToes.count then ", " else ""))
			
			expression += ")\n" +
			"\n" +
			"state = 1\n" +
			"\n" +
			"if pPaw.active == 2 then -- Estado altual Pata IK\n" +
			"(\n" +
			"	if rPaw.active == 2 then -- Estado altual Zarpa IK\n" +
			"		state = 1\n" +
			"	else -- Estado altual Zarpa FK\n" +
			"		state = 2\n" +
			")\n" +
			"else -- Estado altual Pata FK\n" +
			"	state = 3\n" +
			"\n" +
			"if fkik.value > 0 then\n" +
			"(\n" +
			"	if fkikPaw.value > 0 and state != 1 then\n" +
			"	(\n" +
			"		-- Controlador activo para posición y rotación en Ik\n" +
			"		pPaw.active = 2\n" +
			"		rPaw.active = 2\n" +
			"		rAnimalLeg04.active = 2\n" +
			"		rAnimalLeg06.active = 2\n" +
			"		for t in toeBones do\n" +
			"			t.rotation.controller.active = 2\n" +
			"		\n" +
			"		-- Control de Locks para Ik\n" +
			"		setTransformLockFlags animalLeg02 #all\n" +
			"		setTransformLockFlags animalLeg03 #all\n" +
			"		setTransformLockFlags animalLeg04 #{1..5,7..9}\n" +
			"		setTransformLockFlags paw #{7..9}\n" +
			"		setTransformLockFlags animalLeg06 #{1..3,7..9}\n" +
			"		setTransformLockFlags animalLeg07 #{1..3,7..9}\n" +
			"	)\n" +
			"	if fkikPaw.value == 0 and state != 2 then\n" +
			"	(\n" +
			"		-- Controlador activo para posición y rotación en Ik\n" +
			"		pPaw.active = 2\n" +
			"		rPaw.active = 3\n" +
			"		rAnimalLeg04.active = 2\n" +
			"		rAnimalLeg06.active = 3\n" +
			"		for t in toeBones do\n" +
			"			t.rotation.controller.active = 3\n" +
			"		\n" +
			"		-- Control de Locks para Ik\n" +
			"		setTransformLockFlags paw #{7..9}\n" +
			"		setTransformLockFlags animalLeg04 #{1..5,7..9}\n" +
			"		setTransformLockFlags animalLeg06 #{1..3,7..9}\n" +
			"		setTransformLockFlags animalLeg07 #all\n" +
			"	)\n" +
			"	-- Muestra Huella\n" +
			"	-- if base.ishidden == false then pawprint.ishidden = false\n" +
			")\n" +
			"\n" +
			"if fkik.value == 0 and pPaw.active != 3 then\n" +
			"(\n" +
			"	-- Controlador activo para posición y rotación en Fk\n" +
			"	pPaw.active = 3\n" +
			"	rPaw.active = 3\n" +
			"	ranimalLeg04.active = 3\n" +
			"	ranimalLeg06.active = 3\n" +
			"	for t in toeBones do\n" +
			"		t.rotation.controller.active = 3\n" +
			"	\n" +
			"	-- Control de Locks para Fk\n" +
			"	setTransformLockFlags animalLeg02 #{1..3,7..9}\n" +
			"	setTransformLockFlags animalLeg03 #{1..5,7..9}\n" +
			"	setTransformLockFlags animalLeg04 #{1..5,7..9}\n" +
			"	setTransformLockFlags paw #{1..3,7..9}\n" +
			"	setTransformLockFlags animalLeg06 #{1..3,7..9}\n" +
			"	setTransformLockFlags animalLeg07 #{1..3,7..9}\n" +
			"	-- Oculta Huella\n" +
			"	--if base.ishidden == false then pawprint.ishidden = true\n" +
			")\n" +
			"[ 0, 0, 0 ]"
			
			scriptCtrl.script = expression
			-- End Script.
			
			
			
			-- Axis Order Zarpa.
		-- 	footStep.rotation.controller[#Zero_Euler_XYZ].axisOrder = 2 -- axis Order 2 = XZY
			pawBone.rotation.controller[#Zero_Ik_Euler_XYZ].axisOrder = 2 -- axis Order 2 = XZY
			pivotPawHeel.rotation.controller[#Zero_Euler_XYZ].axisOrder = 2 -- axis Order 2 = XZY
			pawBone.rotation.controller[#Zero_Fk_Euler_XYZ].axisOrder = 2 -- axis Order 2 = XZY
			
			
			-- Conexiones e Instanciado de Controladores.
			-- Orient Constraint FK-IK. Instanciado de controlador del spinner FK-IK del modificador Arm_Controls.
			fkIkController = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkik.controller
			followJointOrientController = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].followJoint.controller
			fixAnimalLegController = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixAnimalLeg.controller
			autoStretchController = pawprint.modifiers[#Animal_Leg_Controls].custAttributes[#autoStretchIk][#AutoStretch_IK].controller
			adjustAngleController = pawprint.modifiers[#Animal_Leg_Controls].custAttributes[#autoStretchIk][#adjustAngle].controller
			fkIkPawController = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkikPaw.controller
			fkIkPawExpression = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkikPaw].controller[#Float_Expression].controller
			fixPawController = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixPaw.controller
			
			
			for i = 1 to custAttribAnimalLegBones.count do
			(
				custAttribAnimalLegBones[i].modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkik.controller = fkIkController
				custAttribAnimalLegBones[i].modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].followJoint.controller = followJointOrientController
				custAttribAnimalLegBones[i].modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixAnimalLeg.controller = fixAnimalLegController
				custAttribAnimalLegBones[i].modifiers[#Animal_Leg_Controls].custAttributes[#autoStretchIk][#AutoStretch_IK].controller = autoStretchController
				custAttribAnimalLegBones[i].modifiers[#Animal_Leg_Controls].custAttributes[#autoStretchIk][#adjustAngle].controller = adjustAngleController
				custAttribAnimalLegBones[i].modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fkIkPaw.controller = fkIkPawController
				custAttribAnimalLegBones[i].modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixPaw.controller = fixPawController
			)
			
			
			pawPrint.modifiers[#Scale_Shape].Gizmo.controller.Scale.controller[#X_Scale].controller = fkIkController
			pawPrint.modifiers[#Scale_Shape].Gizmo.controller.Scale.controller[#Y_Scale].controller = fkIkController
			pawPrint.modifiers[#Scale_Shape].Gizmo.controller.Scale.controller[#Z_Scale].controller = fkIkController
			
			
			animalLeg02Bone.rotation.controller.weights[#Weight__FkIkSnaps].controller = fkIkController -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
			animalLeg03Bone.rotation.controller.weights[#Weight__FkIkSnaps].controller = fkIkController -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
			animalLeg04Bone.rotation.controller.weights[#Weight__FkIkSnaps].controller = fkIkController -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
			
			pawBone.rotation.controller.weights[#Weight__Force_align_in_IK_Rot].controller = fkIkPawExpression -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
			animalLeg05Bone.rotation.controller.weights[#Weight__FkIkSnaps].controller = fkIkPawExpression -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
			animalLeg06Bone.rotation.controller.weights[#Weight__FkIkSnaps].controller = fkIkPawExpression -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
			
			
			-- instanciado de controlador para Ik Orient Constraint Weight
			animalLeg04Bone.rotation.controller.weights[#Weight__Zero_Ik_Euler_XYZ].controller = fkIkController -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
			pawBone.rotation.controller.weights[#Weight__Zero_Ik_Euler_XYZ].controller = fkIkPawExpression
			animalLeg06Bone.rotation.controller.weights[#Weight__Zero_Ik_Euler_XYZ].controller = fkIkPawExpression
			
			
			-- instanciado de controlador para Fix Leg Orient Contraint
			pointAnimalLeg.rotation.controller.weights[#Weight__Fix_Leg].controller = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].fixAnimalLeg.controller
			
			
			-- WireParamiters Pesos Controladore. Invierte el peso de los controladores de 'animalLeg04Bone', 'pawBone' y 'animalLeg06Bone'.
			paramWire.connect animalLeg04Bone[#transform][#rotation][#weights][#Weight__Zero_Ik_Euler_XYZ] animalLeg04Bone[#transform][#rotation][#weights][#Weight__Zero_Fk_Euler_XYZ] "1-Weight__Zero_Ik_Euler_XYZ" -- inversión de pesos Orient Constraints IK-FK por wireParamiters, entrando por etiquetas de subanim.
			paramWire.connect pawBone[#transform][#rotation][#weights][#Weight__Zero_Ik_Euler_XYZ] pawBone[#transform][#rotation][#weights][#Weight__Zero_Fk_Euler_XYZ] "1-Weight__Zero_Ik_Euler_XYZ" -- inversión de pesos Orient Constraints IK-FK por wireParamiters, entrando por etiquetas de subanim.
			paramWire.connect animalLeg06Bone[#transform][#rotation][#weights][#Weight__Zero_Ik_Euler_XYZ] animalLeg06Bone[#transform][#rotation][#weights][#Weight__Zero_Fk_Euler_XYZ] "1-Weight__Zero_Ik_Euler_XYZ" -- inversión de pesos Orient Constraints IK-FK por wireParamiters, entrando por etiquetas de subanim..
			
			-- Fix paw.
			pointPaw.rotation.controller.weights[("Weight__" + (frontBackPartString + "pawStructure_To_" + (substituteString animalLegPart04 "_" "End")))].controller = fixPawController
			pointPaw.rotation.controller.weights[#Weight__FkIkSnaps].controller = pawBone.rotation.controller.weights[#Weight__Zero_Ik_Euler_XYZ].controller -- Instanciado de controlador para control de Orientación de PointFoot en IK
			
			-- Follow Joint Contraints. Instanciado de controlador del spinner FollowJoint del modificador Animal_Leg_Controls.
			jointOrientOffset.rotation.controller.weights[#Weight__Follow_jointOrient].controller = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].followJoint.controller
			jointOrientOffset.position.controller.weights[#Weight__Follow_jointPos].controller = animalLeg02Bone.modifiers[#Animal_Leg_Controls].custAttributes[#fkIkSnaps].followJoint.controller
			
			
			-- Conexión Control Pastern.
			pasternRotationPoint.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = animalLeg04Bone.rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
			
			-- Conexiones Controles Pie.
			pivotToes.rotation.controller[#Zero_Euler_XYZ].controller = animalLeg06Bone.rotation.controller[#Zero_Ik_Euler_XYZ].controller -- Instanciado rotaciones Dedos
			pivotPawToe.rotation.controller[#Zero_Euler_XYZ].controller = animalLeg07Bone.rotation.controller[#Zero_Euler_XYZ].controller -- Instanciado rotaciones Puntera
			pivotPawHeel.rotation.controller[#Zero_Euler_XYZ].Y_Rotation.controller = pawBone.rotation.controller[#Zero_Ik_Euler_XYZ].Y_Rotation.controller -- Instanciado rotaciones Zarpa para rotación Talón eje Y
			
			
			-- Movimientos predefinidos de la zarpa por Float Expressions:
			-- Punta/Talón Giro atras
			FloatExpr = pivotPawHeel.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_Expression()
			FloatExpr.AddScalarTarget "pawBoneRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
			FloatExpr.setExpression "if (pawBoneRot > 0, pawBoneRot, 0)"
			-- Punta/Talón Giro Adelante
			FloatExpr = pivotHeel.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_Expression()
			FloatExpr.AddScalarTarget "pawBoneRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
			FloatExpr.setExpression "if (pawBoneRot < 0, pawBoneRot, 0)"
			-- Pivote Lateral Interior
			FloatExpr = pawPivotInside.rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller = Float_Expression()
			FloatExpr.AddScalarTarget "pawBoneRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#X_Rotation].controller
			FloatExpr.setExpression "if (pawBoneRot > 0, pawBoneRot, 0)"
			-- Pivote Lateral Exterior
			FloatExpr = pawPivotOutside.rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller = Float_Expression()
			FloatExpr.AddScalarTarget "pawBoneRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#X_Rotation].controller
			FloatExpr.setExpression "if (pawBoneRot < 0, pawBoneRot, 0)"
			
			
			-- Preparación toes Fk.
			-- Creación de points intermedios para compensación de ejes por las rotaciones del pie.
			-- animalLegPartToes = animalLegPartToesIn + animalLegPartToesOut
			pointFkToesCorrection = undefined
			pointIkToesCorrection = undefined
			pointIkToesOrientation = undefined
			
			pointFkToesCorrection = lb.rig.createPointFromObj animalLeg06Bone classType:NC_classAnim sufix:"FkToesCorrection" crossOp:off boxOp:on -- creación de point 'pointFootCorrection' utilizando la función 'lb.rig.createPointFromObj'.
			if sidePart == NC_locationLeft then pointFkToesCorrection.wirecolor = color 0 252 255
			else if sidePart == NC_locationRight then pointFkToesCorrection.wirecolor = color 0 252 0
			
			pointFkToesCorrection.size = 4
			lb.nc.setFlags pointFkToesCorrection #(NC_frozenFlag, NC_hiddenFlag)
			pointFkToesCorrection.parent = animalLeg05Bone
			lb.controller.freezeTransform pointFkToesCorrection #all
			
			FloatExpr = pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_Expression()
			FloatExpr.AddScalarTarget "footZRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
			FloatExpr.setExpression "-footZRot"
			
			pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_list()
			pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation][#Available].controller = animalLeg06Bone.rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
			pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].setname pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].count "Ik Toes Orientation"
			pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation][#Available].controller = animalLeg06Bone.rotation.controller[#Zero_Fk_Euler_XYZ][#Z_Rotation].controller
			pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].setname pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].count "Fk Toes Orientation"
			
			pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller[#Weights][#Weight__Float_Expression].controller = fkIkController
			pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller[#Weights][#Weight__Ik_Toes_Orientation].controller = fkIkController
			
			paramWire.connect pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller[#Weights][#Weight__Ik_Toes_Orientation] pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller[#Weights][#Weight__Fk_Toes_Orientation] "1-Weight__Ik_Toes_Orientation" -- inversión de pesos.
			
			--pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller[#Weights][#Weight__Fk_Toes_Orientation].controller
			
			
			zRotCorrectionController = pointFkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller
			
			-- pointFkToesCorrection.rotation.controller[#Weights][#Weight__Zero_Euler_XYZ].controller = fkIkController
			
			pointIkToesCorrection = lb.rig.createPointFromObj ikAnimalLegBone06 classType:NC_classAnim sufix:"IkToesCorrection" crossOp:off boxOp:on -- creación de point 'pointFootCorrection' utilizando la función 'lb.rig.createPointFromObj'.
			if sidePart == NC_locationLeft then pointIkToesCorrection.wirecolor = color 0 223 226
			else if sidePart == NC_locationRight then pointFkToesCorrection.wirecolor = color 0 240 0
			pointIkToesCorrection.size = 4.5
			lb.nc.setFlags pointIkToesCorrection #(NC_frozenFlag, NC_hiddenFlag)
			pointIkToesCorrection.parent = ikAnimalLegBone05
			lb.controller.freezeTransform pointIkToesCorrection #all
			pointIkToesCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = zRotCorrectionController
			
			pointIkToesOrientation = lb.rig.createPointFromObj pointIkToesCorrection classType:NC_classAnim sufix:"IkToesOrientation" crossOp:off boxOp:on -- creación de point 'pointFootCorrection' utilizando la función 'lb.rig.createPointFromObj'.
			pointIkToesOrientation.size = 5
			lb.nc.setFlags pointIkToesOrientation #(NC_frozenFlag, NC_hiddenFlag)
			pointIkToesOrientation.parent = pointIkToesCorrection
			lb.controller.freezeTransform pointIkToesOrientation #all
			
			--pointIkToesOrientation.rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller = animalLeg06Bone.rotation.controller[#Zero_Ik_Euler_XYZ].controller[#X_Rotation].controller
			--pointIkToesOrientation.rotation.controller[#Zero_Euler_XYZ][#Y_Rotation].controller = animalLeg06Bone.rotation.controller[#Zero_Ik_Euler_XYZ].controller[#Y_Rotation].controller
			FloatExpr = pointIkToesOrientation.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_Expression()
			FloatExpr.AddScalarTarget "pawBoneZRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
			FloatExpr.setExpression "if (pawBoneZRot < 0, 0, pawBoneZRot)"
			
			
			
			for i = 1 to animalLegPartToes.count do
			(
				pointFootCorrection = lb.rig.createPointFromObj animalLegPartToes[i] classType:NC_classAnim sufix:"FootCorrection" crossOp:off boxOp:on -- creación de point 'pointFootCorrection' utilizando la función 'lb.rig.createPointFromObj'.
				pointFootCorrection.size = 2.5
				pointFootCorrection.parent = pointFkToesCorrection
				--if sidePart == NC_locationLeft then lb.rig.flipAxis #(pointFootCorrection) false false true
				lb.controller.freezeTransform pointFootCorrection #all
				append hiddenObj pointFootCorrection
				
				pointToesCorrection = lb.rig.createPointFromObj animalLegPartToes[i] classType:NC_classAnim sufix:"ToesCorrection" crossOp:off boxOp:on -- creación de point 'pointToesCorrection' utilizando la función 'lb.rig.createPointFromObj'.
				pointToesCorrection.size = 1.75
				pointToesCorrection.parent = pointFootCorrection
				if sidePart == NC_locationLeft then lb.rig.flipAxis #(pointToesCorrection) false false true
				lb.controller.freezeTransform pointToesCorrection #all
				append hiddenObj pointToesCorrection
				
				lb.controller.setActiveController animalLegPartToes[i] #all #frozen
				animalLegPartToes[i].parent = pointToesCorrection
				lb.controller.setActiveController animalLegPartToes[i] #all #zero
				
				/*
				if animalLegPartToes[i].objectOffsetScale.x == -1.0 then -- hueso toe invertido.
				(
					-- lb.rig.flipAxis #(pointToesCorrection) false true true
					
					FloatExpr = pointFootCorrection.rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller = Float_Expression()
					FloatExpr.AddScalarTarget "pawXRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#X_Rotation].controller
					FloatExpr.setExpression "pawXRot"
				)
				else
				(
					FloatExpr = pointFootCorrection.rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller = Float_Expression()
					FloatExpr.AddScalarTarget "pawXRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#X_Rotation].controller
					FloatExpr.setExpression "-pawXRot"
				)
				
				FloatExpr = pointFootCorrection.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_Expression()
				FloatExpr.AddScalarTarget "pawZRot" pawBone.rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
				FloatExpr.setExpression "if (pawZRot < 0, -pawZRot, 0)"
				*/
				
				
				lb.rig.createConstraint pointToesCorrection ikAnimalLegBone06 "Toes Correction" pos:false rot:true scl:false keepPos:false keepRot:true keepScl:false
				
				pointToesCorrection[#transform][#rotation][#weights][#Weight__Toes_Correction].controller = fkIkPawExpression -- instanciado de controlador de slider Fk_Ik_Paw
				
				lb.rig.createConstraint pointToesCorrection animalLeg06Bone "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:true keepScl:false 
				
				paramWire.connect pointToesCorrection[#transform][#rotation][#weights][#Weight__Toes_Correction] pointToesCorrection[#transform][#rotation][#weights][#Weight__FkIkSnaps]  "1-Weight__Toes_Correction" -- inversión de pesos Orient Constraints IK-FK por wireParamiters, entrando por etiquetas de subanim.
			)
			
			
			-- Creación de sistema Ik de toes.
			-- Inside Toes:
			previousToe = undefined
			toeIkChain = undefined
			
			for i=1 to ikToesInBones.count do
			(
				lb.controller.setActiveController ikToesInBones[i] #all #frozen
				
				ikToesInBones[i].parent = pointIkToesCorrection --ikAnimalLegBone05
				
				lb.controller.setActiveController ikToesInBones[i] #all #Zero
				
				lb.controller.freezeTransform ikToesInBones[i] #all
				
				bonEnd = lb.rig.smartCreateEnd ikToesInBones[i]
				
				toeIkChain = iksys.ikchain ikToesInBones[i] bonEnd "IKHISolver" -- creación de IKChain desde hueso 'bon' a 'bonEnd' y de tipo "IKHISolver". Almacenado en 'pasternIkChain'
				toeIkChain.transform.controller.goalSize = 1.5
				toeIkChain.transform = bonEnd.transform
				lb.misc.renameFromObj toeIkChain ikToesInBones[i].name NC_classAnim sufix:"IkChain" -- renombrado de 'footBoneIkRotRef' con la función 'lb.misc.renameFromObj'.
				pointToeIkChain = lb.rig.createPointFromObj ikToesInBones[i] classType:NC_classAnim sufix:"Parent" crossOp:off boxOp:on 
				-- pointToeIkChain.pos = pivotToes.pos
				pointToeIkChain.size = 1
				pointToeIkChain.cross = off
				pointToeIkChain.centermarker = on
				
				append hiddenObj pointToeIkChain
				
				if i != 1 then
				(
					pointToeIkChain.parent = pointIkToesOrientation
					-- pointToeIkChain.parent = ikAnimalLegBone06
					-- pointToeIkChain.parent = previousToe
					-- previousToe = pointToeIkChain
					lb.rig.linkVirtualParent #(animalLegPartToesIn[i]) animalLeg06Bone --animalLegPartToesIn[i-1]
				)
				else
				(
					pointToeIkChain.parent = pointIkToesOrientation
					-- pointToeIkChain.parent = ikAnimalLegBone06
					-- pointToeIkChain.parent = pivotToes
					-- previousToe = pointToeIkChain
					lb.rig.linkVirtualParent #(animalLegPartToesIn[i]) animalLeg06Bone
				)
				
				toeIkChain.transform.controller.SAParent = 0
				
				lb.controller.freezeTransform pointToeIkChain #all
				
				
				pointToeFlipIkChain = lb.rig.createPointFromObj pointToeIkChain classType:NC_classAnim sufix:"FlipIkChainParent" crossOp:off boxOp:on -- creación de point 'pointFootCorrection' utilizando la función 'lb.rig.createPointFromObj'.
				pointToeFlipIkChain.size = 0.75
				pointToeFlipIkChain.parent = pointToeIkChain
				in coordsys local rotate pointToeFlipIkChain (angleaxis 180 [1,0,0])
				lb.nc.setFlags pointToeFlipIkChain #(NC_frozenFlag, NC_hiddenFlag)
				lb.controller.freezeTransform pointToeFlipIkChain #all
				
				lb.controller.setActiveController toeIkChain #all #frozen
				toeIkChain.parent = pointToeFlipIkChain
				lb.controller.setActiveController toeIkChain #all #Zero
				
				lb.controller.freezeTransform toeIkChain #all
				
				lb.rig.createConstraint pointToeIkChain animalLeg06Bone "AutoOrientIkToe" pos:false rot:true scl:false keepPos:false keepRot:true keepScl:false
				movedController = pointToeIkChain.rotation.controller[#Zero_Euler_XYZ].controller
				pointToeIkChain.rotation.controller[#Zero_Euler_XYZ].controller = pointToeIkChain.rotation.controller[#AutoOrientIkToe].controller
				pointToeIkChain.rotation.controller.setname 2 "AutoOrientIkToe"
				pointToeIkChain.rotation.controller[pointToeIkChain.rotation.controller.count].controller = movedController
				pointToeIkChain.rotation.controller.setname (pointToeIkChain.rotation.controller.count) "Zero Euler XYZ"
				
				--ikToesInBones[i].frontfin = on
				
				FkIkControllers animalLegPartToesIn[i] false true -- añade doble controlador de Fk e IK en posición y rotación a 'animalLegPartToesIn[i]'.
				lb.rig.createConstraint animalLegPartToesIn[i] ikToesInBones[i] "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false 
				animalLegPartToesIn[i].rotation.controller.weights[#Weight__FkIkSnaps].controller = fkIkPawExpression -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
				animalLegPartToesIn[i][#transform][#rotation][#weights][#Weight__Zero_Ik_Euler_XYZ].controller = animalLegPartToesIn[i].rotation.controller.weights[#Weight__FkIkSnaps].controller
				paramWire.connect animalLegPartToesIn[i][#transform][#rotation][#weights][#Weight__Zero_Ik_Euler_XYZ] animalLegPartToesIn[i][#transform][#rotation][#weights][#Weight__Zero_Fk_Euler_XYZ] "1-Weight__Zero_Ik_Euler_XYZ" -- inversión de pesos Orient Constraints IK-FK por wireParamiters, entrando por etiquetas de subanim.
				
				-- pointToeIkChain.rotation.controller[#Zero_Euler_XYZ].controller = animalLegPartToesIn[i].rotation.controller[#Zero_Ik_Euler_XYZ].controller
				pointToeIkChain.rotation.controller[#Zero_Euler_XYZ][#Y_Rotation].controller = animalLegPartToesIn[i].rotation.controller[#Zero_Ik_Euler_XYZ][#Y_Rotation].controller
				pointToeIkChain.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = animalLegPartToesIn[i].rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
				--pointToeIkChain.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_list()
				--pointToeIkChain.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation][#Available].controller = animalLeg06Bone.rotation.controller[#Zero_Ik_Euler_XYZ].controller[#Z_Rotation].controller
				
				FloatExpr = toeIkChain.transform.controller.swivelAngle.controller = Float_Expression()
				FloatExpr.AddScalarTarget "xRot" animalLegPartToesIn[i].rotation.controller[#Zero_Ik_Euler_XYZ][#X_Rotation].controller
				if sidePart == NC_locationLeft then FloatExpr.setExpression "-xRot"
					else if sidePart == NC_locationRight then FloatExpr.setExpression "xRot"
				
				append hiddenObj ikToesInBones[i]
				append hiddenObj bonEnd
				append hiddenObj toeIkChain
				append hiddenObj pointToeIkChain
				
			)
			
			-- Outside Toes:
			previousToe = undefined
			toeIkChain = undefined
			
			for i=1 to ikToesOutBones.count do
			(
				lb.controller.setActiveController ikToesOutBones[i] #all #frozen
				
				ikToesOutBones[i].parent = pointIkToesCorrection --ikAnimalLegBone05
				
				lb.controller.setActiveController ikToesOutBones[i] #all #Zero
				
				lb.controller.freezeTransform ikToesOutBones[i] #all
				
				bonEnd = lb.rig.smartCreateEnd ikToesOutBones[i]
				
				toeIkChain = iksys.ikchain ikToesOutBones[i] bonEnd "IKHISolver" -- creación de IKChain desde hueso 'bon' a 'bonEnd' y de tipo "IKHISolver". Almacenado en 'pasternIkChain'
				toeIkChain.transform.controller.goalSize = 1.5
				toeIkChain.transform = bonEnd.transform
				lb.misc.renameFromObj toeIkChain ikToesOutBones[i].name NC_classAnim sufix:"IkChain" -- renombrado de 'footBoneIkRotRef' con la función 'lb.misc.renameFromObj'.
				pointToeIkChain = lb.rig.createPointFromObj ikToesOutBones[i] classType:NC_classAnim sufix:"Parent" crossOp:off boxOp:on 
				-- pointToeIkChain.pos = pivotToes.pos
				pointToeIkChain.size = 1
				pointToeIkChain.cross = off
				pointToeIkChain.centermarker = on
				
				append hiddenObj pointToeIkChain
				
				if i != 1 then
				(
					pointToeIkChain.parent = pointIkToesOrientation
					-- pointToeIkChain.parent = ikAnimalLegBone06
					-- pointToeIkChain.parent = previousToe
					-- previousToe = pointToeIkChain
					lb.rig.linkVirtualParent #(animalLegPartToesOut[i]) animalLeg06Bone --animalLegPartToesOut[i-1]
				)
				else
				(
					pointToeIkChain.parent = pointIkToesOrientation
					-- pointToeIkChain.parent = ikAnimalLegBone06
					-- pointToeIkChain.parent = pivotToes
					-- previousToe = pointToeIkChain
					lb.rig.linkVirtualParent #(animalLegPartToesOut[i]) animalLeg06Bone
				)
				
				toeIkChain.transform.controller.SAParent = 0
				
				lb.controller.freezeTransform pointToeIkChain #all
				
				lb.controller.setActiveController toeIkChain #all #frozen
				toeIkChain.parent = pointToeIkChain
				lb.controller.setActiveController toeIkChain #all #Zero
				
				lb.controller.freezeTransform toeIkChain #all
				
				lb.rig.createConstraint pointToeIkChain animalLeg06Bone "AutoOrientIkToe" pos:false rot:true scl:false keepPos:false keepRot:true keepScl:false
				
				movedController = pointToeIkChain.rotation.controller[#Zero_Euler_XYZ].controller
				pointToeIkChain.rotation.controller[#Zero_Euler_XYZ].controller = pointToeIkChain.rotation.controller[#AutoOrientIkToe].controller
				pointToeIkChain.rotation.controller.setname 2 "AutoOrientIkToe"
				pointToeIkChain.rotation.controller[pointToeIkChain.rotation.controller.count].controller = movedController
				pointToeIkChain.rotation.controller.setname (pointToeIkChain.rotation.controller.count) "Zero Euler XYZ"
				
				--ikToesOutBones[i].frontfin = on
				
				FkIkControllers animalLegPartToesOut[i] false true -- añade doble controlador de Fk e IK en posición y rotación a 'animalLegPartToesIn[i]'.
				lb.rig.createConstraint animalLegPartToesOut[i] ikToesOutBones[i] "FkIkSnaps" pos:false rot:true scl:false keepPos:false keepRot:false keepScl:false 
				animalLegPartToesOut[i].rotation.controller.weights[#Weight__FkIkSnaps].controller = fkIkPawExpression -- instaciado de controladores que controla el peso del Orient Constraint de FK-IK en la Pierna.
				animalLegPartToesOut[i][#transform][#rotation][#weights][#Weight__Zero_Ik_Euler_XYZ].controller = animalLegPartToesOut[i].rotation.controller.weights[#Weight__FkIkSnaps].controller
				paramWire.connect animalLegPartToesOut[i][#transform][#rotation][#weights][#Weight__Zero_Ik_Euler_XYZ] animalLegPartToesOut[i][#transform][#rotation][#weights][#Weight__Zero_Fk_Euler_XYZ] "1-Weight__Zero_Ik_Euler_XYZ" -- inversión de pesos Orient Constraints IK-FK por wireParamiters, entrando por etiquetas de subanim.
				
				--pointToeIkChain.rotation.controller[#Zero_Euler_XYZ].controller = animalLegPartToesOut[i].rotation.controller[#Zero_Ik_Euler_XYZ].controller
				pointToeIkChain.rotation.controller[#Zero_Euler_XYZ][#Y_Rotation].controller = animalLegPartToesOut[i].rotation.controller[#Zero_Ik_Euler_XYZ][#Y_Rotation].controller
				pointToeIkChain.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = animalLegPartToesOut[i].rotation.controller[#Zero_Ik_Euler_XYZ][#Z_Rotation].controller
				--pointToeIkChain.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_list()
				--pointToeIkChain.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation][#Available].controller = animalLeg06Bone.rotation.controller[#Zero_Ik_Euler_XYZ].controller[#Z_Rotation].controller
				
 				FloatExpr = toeIkChain.transform.controller.swivelAngle.controller = Float_Expression()
 				FloatExpr.AddScalarTarget "xRot" animalLegPartToesOut[i].rotation.controller[#Zero_Ik_Euler_XYZ][#X_Rotation].controller
				if sidePart == NC_locationLeft then FloatExpr.setExpression "xRot"
					else if sidePart == NC_locationRight then FloatExpr.setExpression "-xRot"
				
				--toeIkChain.transform.controller.swivelAngle.controller = animalLegPartToesOut[i].rotation.controller[#Zero_Ik_Euler_XYZ][#X_Rotation].controller
				
				append hiddenObj ikToesOutBones[i]
				append hiddenObj bonEnd
				append hiddenObj toeIkChain
				append hiddenObj pointToeIkChain
				
			)
			
			
			-- Escalado controles IK 'jointOrientShape'.
			jointOrientShape.scale.controller.Zero_Scale_XYZ.X_Scale.controller = fkIkController
			jointOrientShape.scale.controller.Zero_Scale_XYZ.Y_Scale.controller = fkIkController
			jointOrientShape.scale.controller.Zero_Scale_XYZ.Z_Scale.controller = fkIkController
			
			-- Escalado controles IK 'toesEndBone'.
			animalLeg07Bone.scale.controller.Zero_Scale_XYZ.X_Scale.controller = fkIkPawExpression
			animalLeg07Bone.scale.controller.Zero_Scale_XYZ.Y_Scale.controller = fkIkPawExpression
			animalLeg07Bone.scale.controller.Zero_Scale_XYZ.Z_Scale.controller = fkIkPawExpression
			
			
			-- Locks
			if frontBackPart == NC_locationFront then
				setTransformLockFlags animalLeg01Bone #{7..9}
			else if frontBackPart == NC_locationBack then
				setTransformLockFlags animalLeg01Bone #{1..3,7..9}
			
			setTransformLockFlags jointOrientShape #{4..9}
			
			
			-- Inherits
			setInheritanceFlags pivotPawHeel #all
			setInheritanceFlags pawPivotInside #all
			setInheritanceFlags pawPivotOutside #all
			
			
			-- Virtual parents
			lb.rig.linkVirtualParent #(animalLeg06Bone) pawBone
			lb.rig.linkVirtualParent #(pawBone) animalLeg04Bone
			lb.rig.linkVirtualParent #(animalLeg02Bone) animalLeg01Bone
			lb.rig.linkVirtualParent #(pawPrint) base
			lb.rig.linkVirtualParent #(jointOrientShape) pawPrint
			
			clearSelection()
			
			
			-- Locks
			for i=1 to hiddenObj.count do -- recorre el array 'hiddenObj' y añade flags "hidden" y "frozen".
			(
				lb.nc.setFlags hiddenObj[i] #(NC_frozenFlag, NC_hiddenFlag)
				setTransformLockFlags hiddenObj[i] #{1..9} -- aplica los Locks indicados a los objetos del array 'hiddenObj'.
			)
			
			-- creación de Selection Set para Pierna
			selectionSets[("chr_" + chrName + "_rig_m_base")] = #(base)
			
			if sidePart == NC_locationLeft then
			(
				selectionSets[("chr_" + chrName + "_rig_" + NC_locationLeft + "_" + frontBackPartString + "AnimalLeg")] = selSetAnimalLeg
			)
			else if sidePart == NC_locationRight then
			(
				selectionSets[("chr_" + chrName + "_rig_" + NC_locationRight + "_" + frontBackPartString + "AnimalLeg")] = selSetAnimalLeg
			)
			
			--/*
			----------------------------------------------------------------------------------------------------------------
			--------------------------------------------- ANIM TRACKS -------------------------------------------------
			----------------------------------------------------------------------------------------------------------------
			-- animTracks de Rotación para ejes XYZ, Fk-Ik, Fk-Ik_Paw, Follow_Joint, Fix_AnimalLeg y Fix_Paw
			for i = 1 to xyzRotObj.count do
			(
				animTracks = #()
				aTracksRot_XYZ = #()
				aTracksFkIk = #()
				aTracksFkIkpaw = #()
				aTracksFixAnimalLeg = #()
				aTracksFixPaw = #()
				aTracksFollowJoint = #()
				aTracksAutoStretch = #()
				
				aTracksRot_XYZ = animTracksRot_xyz xyzRotObj[i]
				aTracksFkIk = animTracksFkIk xyzRotObj[i] "Animal_Leg_Controls" 0.0
				aTracksFkIkPaw = animTracksFkIkPaw xyzRotObj[i]
				aTracksFixAnimalLeg = animTracksfixAnimalLeg xyzRotObj[i]
				aTracksFixPaw = animTracksfixPaw xyzRotObj[i]
				aTracksFollowJoint = animTracksfollowJoint xyzRotObj[i]
				
				animTracks = #(#(#separator, "Separator01", false, "Transforms"))
				join animTracks aTracksRot_XYZ
				sepAnimalLegCtrls = #(#(#separator, "Separator01", false, "Arm Controls"))
				join animTracks sepAnimalLegCtrls
				join animTracks aTracksFkIk
				join animTracks aTracksFkIkPaw
				join animTracks aTracksFixAnimalLeg
				join animTracks aTracksFixPaw
				join animTracks aTracksFollowJoint
				
				index = findItem stretchyFkObj xyzRotObj[i]
				if index == 0 then
				(
					aTracksAutoStretch = animTracksAutoStretch xyzRotObj[i] -- genera el animTracks del AutoStretch
					
					sepAutoStretchCtrls = #(#(#separator, "Separator01", false, "AutoStretch IK Controls"))
					
					join animTracks sepAutoStretchCtrls -- añade a 'spineAnimTracks' los generados en 'sepAutoStretchCtrls'
					join animTracks aTracksAutoStretch -- añade a 'spineAnimTracks' los generados en 'aTracksAutoStretch'
				)
				
				lb.animInfo.setAnimTracks xyzRotObj[i] animTracks -- asigna animTracks a 'xyzRotObj[i]'
				
				if (classof xyzRotObj[i].rotation.controller[#Zero_Euler_XYZ].controller[#X_Rotation].controller) == float_limit then
				(
					xyzRotObj[i].rotation.controller[#Zero_Euler_XYZ].controller[#X_Rotation].controller[#Limited_Controller__Bezier_Float].controller.keyable = true
					xyzRotObj[i].rotation.controller[#Zero_Euler_XYZ].controller[#Y_Rotation].controller[#Limited_Controller__Bezier_Float].controller.keyable = true
					xyzRotObj[i].rotation.controller[#Zero_Euler_XYZ].controller[#Z_Rotation].controller[#Limited_Controller__Bezier_Float].controller.keyable = true
				)
				
				if xyzRotObj[i].rotation.controller[#Euler_XYZ] != undefined then
					if (classof xyzRotObj[i].rotation.controller[#Euler_XYZ].controller[#X_Rotation].controller) == float_limit then
					(
						xyzRotObj[i].rotation.controller[#Euler_XYZ].controller[#X_Rotation].controller[#Limited_Controller__Bezier_Float].controller.keyable = true
						xyzRotObj[i].rotation.controller[#Euler_XYZ].controller[#Y_Rotation].controller[#Limited_Controller__Bezier_Float].controller.keyable = true
						xyzRotObj[i].rotation.controller[#Euler_XYZ].controller[#Z_Rotation].controller[#Limited_Controller__Bezier_Float].controller.keyable = true
					)
				
				xyzRotObj[i][#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkik][#Limited_Controller__Bezier_Float].controller.keyable = true
			)
			
			
			-- animTracks de Rotación para eje Z, Fk-Ik, Fk-Ik_Paw, Follow_Joint, Fix_AnimalLeg y Fix_Paw
			for i = 1 to zRotObj.count do
			(
				animTracks = #()
				aTracksRot_Z = #()
				aTracksFkIk = #()
				aTracksFkIkpaw = #()
				aTracksFixAnimalLeg = #()
				aTracksFixPaw = #()
				aTracksFollowJoint = #()
				aTracksAutoStretch = #()
				
				aTracksRot_Z = animTracksRot_z zRotObj[i]
				aTracksFkIk = animTracksFkIk zRotObj[i] "Animal_Leg_Controls" 1.0
				aTracksFkIkpaw = animTracksFkIkPaw zRotObj[i]
				aTracksFixAnimalLeg = animTracksFixAnimalLeg zRotObj[i]
				aTracksFixPaw = animTracksFixPaw zRotObj[i]
				aTracksFollowJoint = animTracksFollowJoint zRotObj[i]
				
				animTracks = #(#(#separator, "Separator01", false, "Transforms"))
				join animTracks aTracksRot_Z
				sepLegCtrls = #(#(#separator, "Separator01", false, "Leg Controls"))
				join animTracks sepLegCtrls
				join animTracks aTracksFkIk
				join animTracks aTracksFkIkpaw
				join animTracks aTracksFixPaw
				join animTracks aTracksFixAnimalLeg
				join animTracks aTracksFollowJoint
				
				--index = posInArray stretchyFkObj zRotObj[i].name
				index = findItem stretchyFkObj zRotObj[i]
				if index == 0 then
				(
					aTracksAutoStretch = animTracksAutoStretch zRotObj[i] -- genera el animTracks del AutoStretch
					
					sepAutoStretchCtrls = #(#(#separator, "Separator01", false, "AutoStretch IK Controls"))
					join animTracks sepAutoStretchCtrls -- añade a 'spineAnimTracks' los generados en 'sepAutoStretchCtrls'
					join animTracks aTracksAutoStretch -- añade a 'spineAnimTracks' los generados en 'aTracksAutoStretch'
				)
				
				lb.animInfo.setAnimTracks zRotObj[i] animTracks -- asigna animTracks a 'zRotObj[i]'
				
				zRotObj[i][#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkik][#Limited_Controller__Bezier_Float].controller.keyable = true
			)
			
			
			-- animTracks de Posición para ejes XYZ, Fk-Ik, Fk-Ik_Paw, Follow_Joint, Fix_AnimalLeg y Fix_Paw
			for i = 1 to xyzPosObj.count do -- Bucle para asignar animTracks de Posición en XYZ de objetos almacenados en 'xyzPosObj'.
			(
				animTracks = #()
				aTracksPos_XYZ = #()
				aTracksFkIk = #()
				aTracksFkIkPaw = #()
				aTracksFixAnimalLeg = #()
				aTracksFollowJoint = #()
				aTracksFixPaw = #()
				aTracksAutoStretch = #()
				
				aTracksPos_XYZ = animTracksPos_xyz xyzPosObj[i]
				aTracksFkIk = animTracksFkIk xyzPosObj[i] "Animal_Leg_Controls" 1.0
				aTracksFixAnimalLeg = animTracksFixAnimalLeg xyzPosObj[i]
				aTracksFollowJoint = animTracksFollowJoint xyzPosObj[i]
				aTracksFkIkPaw = animTracksFkIkPaw xyzPosObj[i]
				aTracksFixPaw = animTracksFixPaw xyzPosObj[i]
				
				animTracks = #(#(#separator, "Separator01", false, "Transforms"))
				join animTracks aTracksPos_XYZ
				sepLegCtrls = #(#(#separator, "Separator01", false, "Leg Controls"))
				join animTracks sepLegCtrls
				join animTracks aTracksFkIk
				join animTracks aTracksFkIkPaw
				join animTracks aTracksFixPaw
				join animTracks aTracksFixAnimalLeg
				join animTracks aTracksFollowJoint
				
				--index = posInArray stretchyObj xyzPosObj[i].name
				index = findItem stretchyFkObj xyzPosObj[i]
				if index == 0 then
				(
					aTracksAutoStretch = animTracksAutoStretch xyzPosObj[i] -- genera el animTracks del AutoStretch
					
					sepAutoStretchCtrls = #(#(#separator, "Separator01", false, "AutoStretch IK Controls"))
					join animTracks sepAutoStretchCtrls -- añade a 'spineAnimTracks' los generados en 'sepAutoStretchCtrls'
					join animTracks aTracksAutoStretch -- añade a 'spineAnimTracks' los generados en 'aTracksAutoStretch'
				)
				
				lb.animInfo.setAnimTracks xyzPosObj[i] animTracks -- asigna animTracks a 'xyzPosRotObj[i]'
				
				xyzPosObj[i][#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkik][#Limited_Controller__Bezier_Float].controller.keyable = true
			)
			
			
			-- animTracks de Posición y Rotación para ejes XYZ, Fk-Ik, Fk-Ik_Paw, Follow_Joint, Fix_AnimalLeg y Fix_Paw
			for i = 1 to xyzPosRotObj.count do -- Bucle para asignar animTracks de Posición y Rotación en XYZ de objetos almacenados en 'xyzPosRotObj'.
			(
				animTracks = #()
				aTracksPos_XYZ = #()
				aTracksRot_XYZ = #()
				aTracksFkIk = #()
				aTracksFkIkPaw = #()
				aTracksFixAnimalLeg = #()
				aTracksFollowJoint = #()
				aTracksFixPaw = #()
				aTracksAutoStretch = #()
				
				aTracksPos_XYZ = animTracksPos_xyz xyzPosRotObj[i]
				aTracksRot_XYZ = animTracksRot_xyz xyzPosRotObj[i]
				aTracksFkIk = animTracksFkIk xyzPosRotObj[i] "Animal_Leg_Controls" 1.0
				aTracksFkIkPaw = animTracksFkIkPaw xyzPosRotObj[i]
				aTracksFixAnimalLeg = animTracksFixAnimalLeg xyzPosRotObj[i]
				aTracksFollowJoint = animTracksFollowJoint xyzPosRotObj[i]
				aTracksFixPaw = animTracksFixPaw xyzPosRotObj[i]
				
				animTracks = #(#(#separator, "Separator01", false, "Transforms"))
				join animTracks aTracksPos_XYZ
				join animTracks aTracksRot_XYZ
				sepLegCtrls = #(#(#separator, "Separator01", false, "Leg Controls"))
				join animTracks sepLegCtrls
				join animTracks aTracksFkIk
				join animTracks aTracksFkIkPaw
				join animTracks aTracksFixPaw
				join animTracks aTracksFixAnimalLeg
				join animTracks aTracksFollowJoint
				
				-- index = posInArray stretchyFkObj xyzPosRotObj[i].name
				index = findItem stretchyFkObj xyzPosRotObj[i]
				if index == 0 then
				(
					aTracksAutoStretch = animTracksAutoStretch xyzPosRotObj[i] -- genera el animTracks del AutoStretch
					
					sepAutoStretchCtrls = #(#(#separator, "Separator01", false, "AutoStretch IK Controls"))
					join animTracks sepAutoStretchCtrls -- añade a 'spineAnimTracks' los generados en 'sepAutoStretchCtrls'
					join animTracks aTracksAutoStretch -- añade a 'spineAnimTracks' los generados en 'aTracksAutoStretch'
				)
				
				
				lb.animInfo.setAnimTracks xyzPosRotObj[i] animTracks -- asigna animTracks a 'xyzPosRotObj[i]'
				
				xyzPosRotObj[i][#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkik][#Limited_Controller__Bezier_Float].controller.keyable = true
			)
			
			
			-- animTracks de pawBone.
			animTracks = #()
			aTracksIkOffsetPos = #()
			aTracksIkPawBoneRot = #()
			aTracksFkRot_XYZ = #()
			aTracksFkIk = #()
			aTracksFkIkPaw = #()
			aTracksFixPaw = #()
			aTracksFixAnimalLeg = #()
			aTracksFollowJoint = #()
			aTracksAutoStretch = #()
			
			aTracksIkOffsetPos = animTracksIkOffsetPos pawBone
			aTracksIkPawBoneRot = animTracksIkPawBoneRot pawBone
			aTracksFkRot_XYZ = animTracksFkRot_xyz pawBone
			aTracksFkIk = animTracksFkIk pawBone "Animal_Leg_Controls" 1.0
			aTracksFkIkPaw = animTracksFkIkPaw pawBone
			aTracksFixAnimalLeg = animTracksFixAnimalLeg pawBone
			aTracksFollowJoint = animTracksFollowJoint pawBone
			aTracksFixPaw = animTracksFixPaw pawBone
			
			animTracks = #(#(#separator, "Separator01", false, "Transforms"))
			emptySep = #(#separator, "Separator01", false, "")
		-- 	join animTracks emptySep
			sepIkCtrls = #(#(#separator, "Separator01", false, "IK_Controls"))
			join animTracks sepIkCtrls
			join animTracks aTracksIkOffsetPos
			join animTracks aTracksIkPawBoneRot
			sepFkCtrls = #(#(#separator, "Separator01", false, "FK_Controls"))
			join animTracks sepFkCtrls
			join animTracks aTracksFkRot_XYZ
			sepAnimalLegCtrls = #(#(#separator, "Separator01", false, "Leg Controls"))
			join animTracks sepAnimalLegCtrls
			join animTracks aTracksFkIk
			join animTracks aTracksFkIkPaw
			join animTracks aTracksFixPaw
			join animTracks aTracksFixAnimalLeg
			join animTracks aTracksFollowJoint
			
			-- index = posInArray stretchyObj footBone.name
			index = findItem stretchyFkObj pawBone
			if index == 0 then
			(
				aTracksAutoStretch = animTracksAutoStretch pawBone -- genera el animTracks del AutoStretch
				
				sepAutoStretchCtrls = #(#(#separator, "Separator01", false, "AutoStretch IK Controls"))
				join animTracks sepAutoStretchCtrls -- añade a 'spineAnimTracks' los generados en 'sepAutoStretchCtrls'
				join animTracks aTracksAutoStretch -- añade a 'spineAnimTracks' los generados en 'aTracksAutoStretch'
			)
			
			lb.animInfo.setAnimTracks pawBone animTracks -- asigna animTracks a 'pawBone'
			
			pawBone[#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkik][#Limited_Controller__Bezier_Float].controller.keyable = true
			
			
			for i = 1 to FkIkRotObj.count do -- Bucle para asignar animTracks en objetos almacenados en 'FkIkRotObj'.
			(
				-- animTracks de Toes
				animTracks = #()
				aTracksIkRot_XYZ = #()
				aTracksFkRot_XYZ = #()
				aTracksFkIk = #()
				aTracksFkIkPaw = #()
				aTracksFixAnimalLeg = #()
				aTracksFollowJoint = #()
				aTracksFixPaw = #()
				aTracksAutoStretch = #()
				
				aTracksIkRot_XYZ = animTracksIkRot_xyz FkIkRotObj[i]
				aTracksFkRot_XYZ = animTracksFkRot_xyz FkIkRotObj[i]
				aTracksFkIk = animTracksFkIk FkIkRotObj[i] "Animal_Leg_Controls" 1.0
				aTracksFixAnimalLeg = animTracksFixAnimalLeg FkIkRotObj[i]
				aTracksFollowJoint = animTracksFollowJoint FkIkRotObj[i]
				aTracksFkIkPaw = animTracksFkIkPaw FkIkRotObj[i]
				aTracksFixPaw = animTracksFixPaw FkIkRotObj[i]
				
				animTracks = #(#(#separator, "Separator01", false, "Transforms"))
				emptySep = #(#separator, "Separator01", false, "")
			-- 	join animTracks emptySep
				sepIkCtrls = #(#(#separator, "Separator01", false, "IK_Controls"))
				join animTracks sepIkCtrls
				join animTracks aTracksIkRot_XYZ
				sepFkCtrls = #(#(#separator, "Separator01", false, "FK_Controls"))
				join animTracks sepFkCtrls
				join animTracks aTracksFkRot_XYZ
				sepAnimalLegCtrls = #(#(#separator, "Separator01", false, "Leg Controls"))
				join animTracks sepAnimalLegCtrls
				join animTracks aTracksFkIk
				join animTracks aTracksFkIkPaw
				join animTracks aTracksFixPaw
				join animTracks aTracksFixAnimalLeg
				join animTracks aTracksFollowJoint
				
				--index = posInArray stretchyFkObj toesBone.name
				index = findItem stretchyFkObj FkIkRotObj[i]
				if index == 0 then
				(
					aTracksAutoStretch = animTracksAutoStretch FkIkRotObj[i] -- genera el animTracks del AutoStretch
					
					sepAutoStretchCtrls = #(#(#separator, "Separator01", false, "AutoStretch IK Controls"))
					join animTracks sepAutoStretchCtrls -- añade a 'spineAnimTracks' los generados en 'sepAutoStretchCtrls'
					join animTracks aTracksAutoStretch -- añade a 'spineAnimTracks' los generados en 'aTracksAutoStretch'
				)
				
				lb.animInfo.setAnimTracks FkIkRotObj[i] animTracks -- asigna animTracks a 'toesBone'
				
				FkIkRotObj[i][#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkik][#Limited_Controller__Bezier_Float].controller.keyable = true
			)
			
			
			-- animTracks Stretchy
			for i = 1 to stretchyFkObj.count do
			(
				stretchyAnimTracks = #()
				aTracksStretch = #()
				aTracksAutoStretch = #()
				stretchyAnimTracks = lb.animInfo.getAnimTracks stretchyFkObj[i] -- captura los animTracks del hueso 'stretchyObj[i]'
				sepStretchyCtrls = #(#(#separator, "Separator01", false, "Stretchy Controls"))
				aTracksStretch = animTracksStretch stretchyFkObj[i] -- genera el animTracks del Stretchy
				sepAutoStretchCtrls = #(#(#separator, "Separator01", false, "AutoStretch IK Controls"))
				aTracksAutoStretch = animTracksAutoStretch stretchyFkObj[i] -- genera el animTracks del AutoStretch
				
				join stretchyAnimTracks sepStretchyCtrls -- añade a 'spineAnimTracks' los generados en 'sepStretchyCtrls'
				join stretchyAnimTracks aTracksStretch -- añade a 'spineAnimTracks' los generados en 'aTracksStretch'
				join stretchyAnimTracks sepAutoStretchCtrls -- añade a 'spineAnimTracks' los generados en 'sepAutoStretchCtrls'
				join stretchyAnimTracks aTracksAutoStretch -- añade a 'spineAnimTracks' los generados en 'aTracksAutoStretch'
				
				animTracks = stretchyAnimTracks
				
				lb.animInfo.setAnimTracks stretchyFkObj[i] animTracks -- asigna animTracks a 'columnaBones[i]'
				
				stretchyFkObj[i][#Modified_Object][#Animal_Leg_Controls].custAttributes[#fkIkSnaps][#fkik][#Limited_Controller__Bezier_Float].controller.keyable = true
			)
			--*/
			
			success = true
		)--if
		
		success
	)--fn
	

	----------------------------------------------------------------------------------------------------------------
	--limpia las variables globales usadas por la solucion
	----------------------------------------------------------------------------------------------------------------
	fn clearSolutionMemory =
	(
		chrName = undefined
		chrLayer = undefined
		sidePart = undefined
		frontBackPart = undefined
		frontBackPartString = undefined
		
		-- Partes Fk Brazo.
		animalLegPart01 = undefined -- corresponde a partes de hombro(shoulder) o pelvis lateral (pelvis)
		animalLegPart02 = undefined -- corresponde a partes de upperarm o thigh.
		animalLegPart03 = undefined -- corresponde a partes de forearm o lower thigh.
		animalLegPart04 = undefined -- corresponde a partes de pastern o rear pastern.
		animalLegPart05 = undefined -- corresponde a parte de instep.
		animalLegPart06 = undefined -- corresponde a parte de toes.
		animalLegPart07 = undefined -- corresponde a parte de toesEnd.
		
		checkSolutionNodes = undefined
		prepareSolution = undefined
		generateSolution = undefined
		clearSolutionMemory = undefined
		
		CA_ARS_fkIkAnimalLeg = undefined
	)
)