------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de animación de pierna de fkIk
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------------
	-- CA_solutionArmFkIk: Función que contiene el customAttribute del snap de fkIk
	------------------------------------------------------------------------------------------------------------------------------------------------------
	CA_fkIkLeg = attributes fkIkSnaps 
	(	
		-- Parametros Ca
		parameters main rollout:rollFkIk
		(
			-- Controles
			fkik type:#float ui:(snpFkIk, sldFkIk)
			
			--Lado de cadena
			side type:#string
			
			-- Cadena de Fk
			fkCalf type:#maxObject
			fkThigh type:#maxObject
			fkCalfEnd type:#maxObject
			
			fkInstep type:#maxObject
			fkToeCap type:#maxObject
			fkToeCapPivot type:#maxObject
			
			refKneeIK type:#maxObject
			refPivotFootHeelIK  type:#maxObject
			refPivotFootHeelIKParent type:#maxObject
			
			-- Cadena final
			thigh type:#maxObject
			calf type:#maxObject
			foot type:#maxObject
			
			instep type:#maxObject									
			toeCap type:#maxObject
			toeCapPivot type:#maxObject
			base type:#maxObject
			
			--Cadena de Ik
			fkIkSHP type:#maxObject
			ikCalf type:#maxObject
			ikCalfEnd type:#maxObject
			ikThigh type:#maxObject
			ikToeCapHLP type:#maxObject
			ikAlignRef type:#maxObject
			
			ikInstep type:#maxObject
			ikInstepGoal type:#maxObject

			ikToeCap type:#maxObject
			
			ikFootSHP type:#maxObject
			ikKnee type:#maxObject

			--Cadena de Bb
			bbThigh type:#maxObject
			bbCalf type:#maxObject
			bbCalfEnd type:#maxObject
			bbBreakKneeSHP type:#maxObject

		)
				
		-----------------------------------------------------------------------------------------------------------
		-- Funciones de snap de ik a fk. Se alinea la cadena de fk (foreArm y upperArm) con la cadena de ik.
		-----------------------------------------------------------------------------------------------------------
		fn fkIkSnap = 
		(
			_legSolution = (lb.rig.solutions.getSolutions name:"fkIkLeg")[1]
			
			if fkIkSHP.node.modifiers[#Leg_Controls].fkik.controller.value > 0 then
				_legSolution.ikToFkSnap fkIkSHP
			else
				_legSolution.fkToIkSnap fkIkSHP
		)
		
		-----------------------------------------------------------------------------------------------------------
		-- Funcion que sirve para alinear las cadenas de fkIk sin cambiar el valor 
		-----------------------------------------------------------------------------------------------------------
		fn fkIkMatch = 
		(
			_legSolution = (lb.rig.solutions.getSolutions name:"fkIkLeg")[1]
			
			-- Ik to Fk
			if fkIkSHP.node.modifiers[#Leg_Controls].fkik.controller.value > 0 then
				_legSolution.ikToFkSnap fkIkSHP matchChain:true
			else -- Fk to Ik
				_legSolution.fkToIkSnap fkIkSHP matchChain:true
		)
		
		------------------------------------------------------------------------------
		----------------------------Rollout -----------------------------------------
		------------------------------------------------------------------------------
		rollout rollFkIk "Leg Controls"
		(
			spinner snpFkIk "FK_IK" range:[0,1,1]
			slider sldFkIk "" range:[0,1,1]
			
			button btnFkIkSnap "Ninguno" pos:[3,80] width:155 height:30 
			button btnFkIkMatch "Match Ik and Fk" pos:[3,120] width:155 height:30
			
			--------------------------------------------------
			---------- Eventos del custAttribute----------	
			--------------------------------------------------
			on rollFkIk open do
			(
				if fkIkSHP.node.modifiers[#Leg_Controls].fkik > 0 then
					btnFkIkSnap.caption = "Ik to Fk"
				else
					btnFkIkSnap.caption = "Fk to Ik"
			)
			
			
			--------------------------------------------------
			-- Boton para hacer el snap de fkik
			--------------------------------------------------
			on btnFkIkSnap pressed do
			(
				DisableSceneRedraw()
				
				undo "Fk/Ik Snap" on
					fkIkSnap()
				
				enableSceneRedraw()
				completeRedraw()
			)--on btn	
			
			--------------------------------------------------
			-- Botón para hacer el match de las cadenas de fkIk
			--------------------------------------------------
			on btnFkIkMatch pressed do
			(
				DisableSceneRedraw()

				undo "Match Fk and Ik" on
					fkIkMatch()

				enableSceneRedraw()
				completeRedraw()
			)--on btn	
			
		)--rollout 
	)--CA
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strAnimNodes | Contiene las piezas de anim de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------	
	struct strAnimNodes
	(
		legSolutionHLP							= undefined,				--@var: legSolutionHLP | Helper del cual colgará toda la estructura
		legStructureHLP							= undefined,				--@var: legStructureHLP | Helper del cual colgará toda la estructura
		legSolutionParentHLP					= undefined,				--@var: legStructureHLP | Helper del cual colgará toda la estructura
		pelvis 									= undefined,				--@var: pelvis | Nodo de rig de la clavicula.
		pelvisEnd  								= undefined,				--@var: pelvisEnd | Nodo de rig del hueso end de la clavicula.
		thigh 									= undefined,				--@var: thigh | Nodo de rig del thigh.
		calf									= undefined,				--@var: calf | Nodo de rig del calf.
		calfEnd									= undefined,				--@var: calfEnd | Nodo de rig del final del calf.
		instep 									= undefined,				--@var: instep | Nodo de rig del pie.
		toeCap									= undefined,				--@var: toeCap | Nodo de rig de la puntera.
		toeCapPivot								= undefined,				--@var: toeCapPivot | Nodo de rig del pivote de la puntera.
		foot									= undefined,				--@var: foot | Nodo de rig del pie.
		footOffsetHLP							= undefined,				--@var: footOffsetHLP | Nodo HLP de rig del pie para offset.
		footParentHLP							= undefined,				--@var: footParentHLP | Nodo HLP de rig padre del pie.		
		toes									= #()						--@var: toes | Nodos de los dedos del pie.
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strFkNodes | Contiene las piezas de fk de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strFkNodes
	(
		thigh									= undefined,				--	Nodo de fk del thigh.
		calf 									= undefined,				--	Nodo de fk del calf.
		calfEnd									= undefined,				--	Nodo de rig del final calfEnd.
		instep 									= undefined,				--	Nodo de fk de la instep.
		toeCap									= undefined,				--	Nodo de fk del toeCap.
		toeCapPivot								= undefined,				--	Nodo de rig del toeCapPivot.
		refKneeIKHLP 							= undefined,				--	Nodo de fk de referencia para la alineación del control de ik.
		refPivotFootHeelIKHLP 					= undefined,				--	Nodo de fk de referencia para la alineación del control de ik.
		refPivotFootHeelIKParentHLP				= undefined					--	Nodo de fk de referencia para la alineación del control de ik.
	)		
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strIkNodes | Contiene las piezas de ik de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strIkNodes
	(
		thigh									= undefined,				--	Nodo de ik del upperArm.
		calf 									= undefined,				--	Nodo de ik del forearm.
		calfEnd									= undefined,				--	Nodo de ik  del final forearm.
		
		instep 									= undefined,				--	Nodo de ik  de la mano.
		instepHLP								= undefined,				--	Nodo de ik  de la mano.
			
		toeCap									= undefined,				--	Nodo de ik  de la mano.
		toeCapHLP								= undefined,				--	Nodo de ik  de la mano.
		ikToeCapParentHLP						= undefined,				--	Nodo de ik  de la mano.
		
		toeCapPivot								= undefined,				--	Nodo de ik  de la mano.
		toeCapPivotHLP							= undefined,				--	Nodo de ik  de la mano.
		
		footPosRefHLP							= undefined,				--	Nodo de ik que sirve de padre del shape de la mano.
		ikGoalParentHLP							= undefined,				--	Nodo de ik  padre de la ik.
		
		pivotInside								= undefined,				--	Nodo de ik  padre de la ik.
		pivotOutside							= undefined,				--	Nodo de ik  padre de la ik.
		pivotFootHeel							= undefined,				--	Nodo de ik  padre de la ik.

		fkIkSHP									= undefined,				--  	Conmutador de fkIk.
		footSHP 								= undefined,				--	Nodo de tipo shape de la mano.
		kneeSHP 								= undefined					--	Nodo de tipo shape del codo.
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strBbNodes | Contiene las piezas de breakBones de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strBbNodes
	(			
		thigh 									= undefined,				--	Nodo de bb del upperArm.
		calf									= undefined,				--	Nodo de bb del forearm.
		calfEnd									= undefined,				--	Nodo de bb del final forearm.
		breakKneeSHP							= undefined					--	Nodo de bb del romperodillas

	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strAnimEditNodes | Contiene las piezas de AnimEdit de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strAnimEditNodes
	(			
		pivotInside								= undefined,				--	Nodo de AnimEdit de pivote interior
		pivotOutside							= undefined,				--	Nodo de AnimEdit de pivote exterior
		pivotFootHeel							= undefined,				--	Nodo de AnimEdit de pivote talón.
		footSHP 								= undefined					--	Plantilla de animación.
	)	
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rsa_fkikLeg | Contiene la solución de animación
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rsa_fkikLeg
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		solutionParameters = lb.rig.solutions.params, 										--@var | self | Almacena el ca especifico de la solución.
		
		
		def = (classof this),												--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #leg,													--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #anim,												--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,										--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,																			--@var: index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de animación de pierna de fkIk",							--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		self = undefined,	--@var | self | Almacena la definición del struct.
		selfFile = "",		--@var | selfFile | Almacena la ruta del propio archivo de script que contiene la definición.
		
		side						= lb.nc.NC_locationLeft,
		
		animNodes 					= strAnimNodes(),			--@var: animNodes | Nodos de la cadena de hueso de rig.
		fkNodes						= strFkNodes(),				--@var: fkNodes | Nodos de la cadena de hueso de fk.
		ikNodes						= strIkNodes(),				--@var: ikNodes | Nodos de la cadena de hueso de ik.
		bbNodes   					= strBbNodes(),				--@var: bbNodes | Nodos de la cadena de hueso de bb.
		AnimEditNodes 				= strAnimEditNodes(),		--@var: AnimEditNodes | Nodos de la cadena de hueso de bb.
		
		rigNodesAll 				= #(),						--@var: rigNodesAll | Nodos de todos los objetos de la cadena de rig.
		fkNodesAll					= #(),						--@var: fkNodesAll | Nodos de todos los objetos de la cadena de fk.
		ikNodesAll					= #(),						--@var: ikNodesAll | Nodos de todos los objetos de la cadena de ik.
		bbNodesAll					= #(),						--@var: bbNodesAll | Nodos de todos los objetos de la cadena de bb.
		
		fkIkLegCA					= CA_fkIkLeg,
		
		------------------------------------------------------------------------------------------------ 
		-- CUSTOM ATTRIBUTES
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
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		--------------------------------------------------------------------------------------------------------
		-- Funciones de snap de fk a ik. Se alinea la cadena de ik (ikhand y ikElbow) con el final de 
		-- la cadena de huesos de fk y el punto de refenrecia del brazo para el swiverAngle de la ik.
		-- Establecemos valor 1 del spinner de fkIk y controlamos la selección de las piezas.
		--------------------------------------------------------------------------------------------------------
		fn fkToIkSnap fkIkNode matchChain: false =
		(
			_fkIkNode = fkIkNode.node.modifiers[1]
			_sleepTime = 0.1
			
			if matchChain then
			(
				-- Mostramos las cadenas de fkIk para la función de match y que se tenga refencia de que se han snapeado las cadenas.
				enableSceneRedraw()
				completeRedraw()
				
				_fkIkNode.ikFootSHP.node.isHidden = true
				
				unHide #(_fkIkNode.fkThigh.node, _fkIkNode.fkCalf.node, _fkIkNode.fkInstep.node, _fkIkNode.fkToecap.node)
				unHide #(_fkIkNode.ikThigh.node, _fkIkNode.ikCalf.node, _fkIkNode.ikInstep.node, _fkIkNode.ikToecap.node)
				
				completeRedraw()
				
				-- Pausamos la ejecución durante 1 segundo para ver su estado original.
				sleep _sleepTime
			)

			-- Reseteamos los controladores de ik para evitar cualquier tipo de desfase.
			_fkIkNode.foot.node.rotation.controller[#Zero_IK_Controller].controller.value = (quat 0 0 0 1)
			_fkIkNode.toeCap.node.rotation.controller[#Zero_IK_Controller].controller.value = (quat 0 0 0 1)
			_fkIkNode.toeCapPivot.node.rotation.controller[#Zero_IK_Controller].controller.value = (quat 0 0 0 1)
-- 					ikToeCapHLP.node.position.controller[#Zero_Pos_XYZ].controller.value = [0,0,0]
-- 					
			-- Alineamos la plantilla, el toeCap y la rodilla.
			_bkcpScaIkFootSHP = _fkIkNode.ikFootSHP.node.scale
			_bkcpScaIkKneeSHP = _fkIkNode.ikKnee.node.scale
			
			_fkIkNode.ikFootSHP.node.transform = _fkIkNode.fkCalfEnd.node.transform
			_fkIkNode.ikToeCapHLP.node.transform = _fkIkNode.fkToeCap.node.transform
-- 					ikInstepGoal.node.transform = fkToeCap.node.transform
			_fkIkNode.ikKnee.node.transform = _fkIkNode.refKneeIK.node.transform	
			
-- 					ikFootSHP.node.scale = _bkcpScaIkFootSHP

			if matchChain then
			(
				-- Actualizamos el viewport 
				completeRedraw()
				
				-- Pausamos la ejecución durante 1 segundo para ver su estado actual
				sleep _sleepTime
				
				_fkIkNode.ikFootSHP.node.isHidden = false
				hide #(_fkIkNode.fkThigh.node, _fkIkNode.fkCalf.node, _fkIkNode.fkInstep.node, _fkIkNode.fkToecap.node)
				hide #(_fkIkNode.ikThigh.node, _fkIkNode.ikCalf.node, _fkIkNode.ikInstep.node, _fkIkNode.ikToecap.node)
				
				DisableSceneRedraw()
				completeRedraw()
			)
			
			-- Resetemos la escala a 1 para evitar que se nos de la vuelta al alinearlo conla transformaciñon, ya que los objetos tiene esalas distinas.
			if side == lb.nc.NC_locationRight then
			(
				_fkIkNode.ikToeCapHLP.node.scale.controller[#Zero_Scale_XYZ].controller.value = [1,1,1]
				_fkIkNode.ikKnee.node.scale.controller[#Zero_Scale_XYZ].controller.value = [1,1,1]
				_fkIkNode.ikFootSHP.node.scale.controller[#Zero_Scale_XYZ].controller.value = [1,1,1]
			)
				
			_fkIkNode.fkIkSHP.node.modifiers[#Leg_Controls].autostrech = 0.0
			
			if not matchChain then
			(
				_fkIkNode.fkIkSHP.node.modifiers[#Leg_Controls].fkik = 1.0
				select _fkIkNode.ikFootSHP.node
			)
			
			-- Resetemos la escala a 1 porque al hacer la alineación se queda a 0.
-- 					ikKnee.node.scale.controller[#Zero_Scale_XYZ].controller.value = [1,1,1]
		),
		
		-----------------------------------------------------------------------------------------------------------
		-- Funciones de snap de ik a fk. Se alinea la cadena de fk (foreArm y upperArm) con la cadena de ik.
		-- Establecemos valor 0 del spinner de fkIk y controlamos la selección de las piezas.
		-----------------------------------------------------------------------------------------------------------
		fn ikToFkSnap fkIkNode matchChain: false =
		(		
			_fkIkNode = fkIkNode.node.modifiers[1]
			_sleepTime = 0.1
			
			if matchChain then
			(
				-- Mostramos las cadenas de fkIk para la función de match y que se tenga refencia de que se han snapeado las cadenas.
				enableSceneRedraw()
				completeRedraw()
				
				unHide #(_fkIkNode.fkThigh.node, _fkIkNode.fkCalf.node, _fkIkNode.fkInstep.node, _fkIkNode.fkToeCap.node)
				unHide #(_fkIkNode.ikThigh.node, _fkIkNode.ikCalf.node, _fkIkNode.ikInstep.node, _fkIkNode.ikToeCap.node)
				
				completeRedraw()
				
				-- Pausamos la ejecución durante 1 decima de segundo para ver su estado original.
				sleep _sleepTime
			)
			
			-- Comprobamos si se ha movido el valor Z del BB, para evitar que se nos rompa la pose si se mueve en el eje que no rompe el plano de ik.			
			if _fkIkNode.bbBreakKneeSHP.node.position.controller[#Zero_Pos_XYZ].z_position != 0 then 
				_fkIkNode.bbBreakKneeSHP.node.position.controller[#Zero_Pos_XYZ].z_position = 0

			-- Calculamos el factor de escala respecto a la distance del upperarm y el forearm, para recolocar los huesos cuando tenemos el auotstrech activado.
			_xScaThigh = ((distance _fkIkNode.bbThigh.node _fkIkNode.bbCalf.node)/(_fkIkNode.base.node.scale.controller[#Zero_Scale_XYZ][#X_scale].controller.value/100))/_fkIkNode.fkThigh.node.length
			_xScaCalf = ((distance _fkIkNode.bbCalf.node _fkIkNode.bbCalfEnd.node)/(_fkIkNode.base.node.scale.controller[#Zero_Scale_XYZ][#X_scale].controller.value/100))/_fkIkNode.fkCalf.node.length
			
			-- Alienamos las cadenas de fk a la de ik.
			_fkIkNode.fkThigh.node.transform = _fkIkNode.bbThigh.node.transform
			_fkIkNode.fkCalf.node.transform = _fkIkNode.bbCalf.node.transform
			
			_fkIkNode.bbBreakKneeSHP.node.position.controller[#Zero_Pos_XYZ].value = [0,0,0]
			
			_fkIkNode.fkCalfEnd.node.transform = _fkIkNode.ikAlignRef.node.transform

			-- Resetamos la posición para evitar offset de longitud
			_fkIkNode.fkThigh.node.scale.controller[#Zero_Scale_XYZ][#X_scale][#Float_limit].controller.value = _xScaThigh
			_fkIkNode.fkCalf.node.scale.controller[#Zero_Scale_XYZ][#X_scale][#Float_limit].controller.value =  _xScaCalf
			
			-- Reseteo de posición en X e Y para contrarestar la posición del transform.
			_fkIkNode.fkCalf.node.position.controller[#Zero_Pos_XYZ][#X_Position][#Bezier_float].controller.value = 0
			_fkIkNode.fkCalf.node.position.controller[#Zero_Pos_XYZ][#Y_Position].controller.value = 0
			
			_fkIkNode.fkCalfEnd.node.position.controller[#Zero_Pos_XYZ][#X_Position][#Bezier_float].controller.value = 0
			_fkIkNode.fkCalfEnd.node.position.controller[#Zero_Pos_XYZ][#Y_Position].controller.value = 0
			
			
			-- Reseteamos la posición del instep para evitar un steching raruno en el calfEnd, provocado por el alineamiento entero de la transformación.					
			_fkIkNode.fkInstep.node.transform = _fkIkNode.ikInstep.node.transform
			_fkIkNode.fkInstep.node.position.controller[#Zero_Pos_XYZ].value = [0,0,0]
			
			_fkIkNode.fkToeCap.node.transform = _fkIkNode.ikToeCap.node.transform
			_fkIkNode.fkToeCap.node.position.controller[#Zero_Pos_XYZ].value = [0,0,0]
			
			-- Resteamos el offset de la mano primero recolocando el control de ik y despues poniendo a cero el controlador instanciado.
			_fkIkNode.foot.node.position.controller[#Zero_IK_Controller].value = [0,0,0]
			
			if matchChain then
			(
				-- Actualizamos el viewport 
				completeRedraw()	
				
				-- Pausamos la ejecución durante 1 segundo para ver su estado actual
				sleep _sleepTime

				hide #(_fkIkNode.fkThigh.node, _fkIkNode.fkCalf.node, _fkIkNode.fkInstep.node, _fkIkNode.fkToeCap.node)
				hide #(_fkIkNode.ikThigh.node, _fkIkNode.ikCalf.node, _fkIkNode.ikInstep.node, _fkIkNode.ikToeCap.node)
				
				DisableSceneRedraw()
			)
				
				
			-- Resetemos la escala a 1 para evitar que se nos de la vuelta al alinearlo conla transformaciñon, ya que los objetos tiene esalas distinas.
			_fkIkNode.ikFootSHP.node.scale.controller[#Zero_Scale_XYZ].controller.value = [1,1,1]
			
			if not matchChain then
			(
				_fkIkNode.fkIkSHP.node.modifiers[#Leg_Controls].fkik = 0
				
				-- Control de selección.
				if selection[1] != _fkIkNode.ikFootSHP.node then		
					select selection	
				else 
					select _fkIkNode.foot.node
				
				if selection[1] == _fkIkNode.bbBreakKneeSHP.node then
					select _fkIkNode.calf.node
			)
		),
		
		------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Función para rellenar los arrays y nodos de la solución "strRigSolutionArmFkIk". Busca en la escena todos los huesos de tipo rig
		-- para ir rellenando los nodos de RIG, FK, IK, y sus variables dependientes de cada uno.
		------------------------------------------------------------------------------------------------------------------------------------------------------
		fn fillStructNodes =
		(
			-- Vaciamos los arrays para evitar que se acumulen nodos invalidos.
			this.animNodes.toes = #()
			this.fkNodesAll = #()
			this.ikNodesAll = #()
			this.rigNodesAll = #()
			this.bbNodesAll = #()

			-- Recorremos las cadenas almacenadas de rig, Fk, Ik, para almacenarlas en los structs de las cadenas.
			for o in objects do
			(
				_filterParts = filterString o.name "_"
				
				-- Filtramos para obtener solo las piezas de tipo rig
				if _filterParts[3] == lb.nc.NC_classAnim then
				(
					-- Recorremos los structs y determinanos si es el lado dercho o el izquierdo
					-- para más adelante capturar los nodos de cada cadena e ir rellenando las variables.
					if _filterParts[4] == this.side then
					(
						case _filterParts[5] of
						(
							"pelvis": this.animNodes.pelvis = o
							"thigh": this.animNodes.thigh = o
							"calf": this.animNodes.calf = o
							"instep": this.animNodes.instep = o
							"toeCap": this.animNodes.toeCap = o
							
							-- Para  obtener todas los dedos  indexadas.
							default:
							
								if (findstring _filterParts[5] "toe" != undefined) then
									append this.animNodes.toes o

							"thighFk": this.fkNodes.thigh = o
							"calfFk": this.fkNodes.calf = o
							"instepFk": this.fkNodes.instep = o
							"toeCapFk": this.fkNodes.toeCap = o

							"thighIk": this.ikNodes.thigh = o
							"calfIk": this.ikNodes.calf = o
							"instepIk": this.ikNodes.instep = o
							"toeCapIk": this.ikNodes.toeCap = o
							
							"thighBb": this.bbNodes.thigh = o
							"calfBb": this.bbNodes.calf = o
							"instepBb": this.bbNodes.instep = o
						)
						
						-- Filtramos para rellenar los arrays con las piezas indicadas, ya sea de fk, ik o de rig
						-- Captura todos los nodos de fk
						if (findstring _filterParts[5] "fk" != undefined) then						
							append this.fkNodesAll o
						
						-- Captura todos los nodos de ik
						if (findstring _filterParts[5] "ik" != undefined) then						
							append this.ikNodesAll o	
						
						-- Captura todos los nodos de ik
						if (findstring _filterParts[5] "bb" != undefined) then						
							append this.bbNodesAll o	
						
						-- Captura todos los nodos de rig
						if (findstring _filterParts[5] "ik" == undefined) and (findstring _filterParts[5] "fk" == undefined) and (findstring _filterParts[5] "bb" == undefined)  then						
							append this.rigNodesAll o
						

					)
				)--if filter 3

				-- Filtramos para obtener solo las piezas de tipo rig
				if _filterParts[3] == lb.nc.NC_classAnimEdit then
				(
					-- Recorremos los structs y determinanos si es el lado dercho o el izquierdo
					-- para más adelante capturar los nodos de cada cadena e ir rellenando las variables.
					if _filterParts[4] == this.side then
					(
						case _filterParts[5] of
						(					
							(lb.nc.NC_ANIM_pivotInside):
								this.AnimEditNodes.pivotInside	= o	
							
							(lb.nc.NC_ANIM_pivotOutside):
								this.AnimEditNodes.pivotOutside	= o	
							
							(lb.nc.NC_ANIM_pivotFootHeel):
								this.AnimEditNodes.pivotFootHeel	= o
							
							(lb.nc.NC_ANIM_footStep):
								this.AnimEditNodes.footSHP	= o
						)
					)
				)
				
			)-- for o
			
			this.animNodes.toes = lb.misc.sortNodesByName this.animNodes.toes
		), -- fn fillStructNodes
			
		------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Función para crear constraints, conexiones de rig y la solución en si.
		-- PART: puede valer #SPINE, #ARM, #LEG, - indica la parte que queremos obtener
		-- SIDE: puede valer lb.nc.NC_locationLeft, lb.nc.NC_locationRight lb.nc.NC_locationMiddle
		------------------------------------------------------------------------------------------------------------------------------------------------------
		fn createConnections side = 
		(			
			----------------------------------------------------
			--CREACIÓN DE BASE
			----------------------------------------------------
			-- Buscamos la base, sino existe se crea.
			_base = lb.rig.solutions.getBaseNode()
			_baseAnimEdit = lb.rig.solutions.getBaseNode type:#AnimEdit
			----------------------------------------------------
			--CREACIÓN DE HUESOS AUXILIARES
			----------------------------------------------------
			(
				--*****************/RIG/******************** --
				-- Creamos el final de la cadena del hueso del calf de la cadena de rig, que nos servirá para mantener la orientación del pie con la plantilla de ik.
				this.animNodes.calfEnd = lb.rig.smartCreateEnd this.animNodes.calf
				this.animNodes.calfEnd.name = lb.nc.replaceNamePart this.animNodes.calfEnd.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				-- Creamos el final de la cadena del hueso del calf de la cadena de rig, que nos servirá del padre del pie (como si fuera la mano de la solución del brazo)
				this.animNodes.foot = lb.rig.smartCreateEnd this.animNodes.calf
				this.animNodes.foot.name = lb.nc.replaceNamePart this.animNodes.foot.name 5 "foot"

				
				-- Orientamos el hueso con el instep y resetemos la rotación en y para poderlo manejar comodamente, y que en la posterior creación de points respecto a este hueso no halla que ir 
				-- resteando cada rotación de point.
				_bkpCalfEndScale = this.animNodes.calfEnd.scale
				
				this.animNodes.calfEnd.transform = this.animNodes.instep.transform
				this.animNodes.calfEnd.rotation.y_rotation = 0
				
				this.animNodes.calfEnd.scale = _bkpcalfEndScale 
				
				-- Orientamos el hueso con el instep y resetemos la rotación en y para poderlo manejar comodamente, y que en la posterior creación de points respecto a este hueso no halla que ir 
				-- resteando cada rotación de point.
				_bkpFootScale = this.animNodes.foot.scale
				
				this.animNodes.foot.transform = this.animNodes.instep.transform
				this.animNodes.foot.rotation.y_rotation = 0
				this.animNodes.foot.taper = 0				
				
				this.animNodes.foot.scale = _bkpFootScale
				
				--*****************/FK/******************** --				
				-- Creamos el final de la cadena del hueso del calf de la cadena de rig, que nos servirá para mantener la orientación del pie con la plantilla de ik.
				this.fkNodes.calfEnd = lb.rig.smartCreateEnd this.fkNodes.calf
				this.fkNodes.calfEnd.name = lb.nc.replaceNamePart this.fkNodes.calfEnd.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				

				--*****************/IK/******************** --
				-- Creamos el final de la cadena del hueso del calf de la cadena de rig, que nos servirá para mantener la orientación del pie con la plantilla de ik.
				this.ikNodes.calfEnd = lb.rig.smartCreateEnd this.ikNodes.calf
				this.ikNodes.calfEnd.name = lb.nc.replaceNamePart this.ikNodes.calfEnd.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				--*****************/BB/******************** --
				-- Creamos el final de la cadena del hueso del calf de la cadena de bb que nos servirá para hacer el streching de la cadena.			
				this.bbNodes.calfEnd = lb.rig.smartCreateEnd this.bbNodes.calf
				this.bbNodes.calfEnd.name = lb.nc.replaceNamePart this.bbNodes.calfEnd.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			)--CREACIÓN DE HUESOS AUXILIARES
			
			----------------------------------------------------
			--CREACIÓN DE HELPERS AUXILIARES
			----------------------------------------------------
			(
				--*****************************************************************************/--RIG--/*****************************************************************************--
				-- Creamos el legSolutión, que es de donde colgará toda la solución de la estructura y llevará almacenada la información de versión de la solución.
				this.animNodes.legSolutionHLP = lb.rig.createPointFromObj this.animNodes.thigh
				
				-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
				this.animNodes.legSolutionHLP.name = lb.nc.replaceNamePart this.animNodes.legSolutionHLP.name 5 "leg-solution-root-x"
				this.animNodes.legSolutionHLP.name = lb.nc.replaceNamePart this.animNodes.legSolutionHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.legSolutionHLP.size = 15 * _baseAnimEdit.scale[1]
				this.animNodes.legSolutionHLP.wirecolor = red
				
				-- Creamos el legSolutiónParent, que es de donde se emparentanran objetos que no van directamente emparentados al armSolution y tienen dependencia con la base.
				-- Este point llevara un pos y rot constraint con la base, para puentear las piezas que dependen de esta misma. También situado el punto de pivote en la base.
				this.animNodes.legSolutionParentHLP = lb.rig.createPointFromObj this.animNodes.thigh
				this.animNodes.legSolutionParentHLP.name = lb.nc.replaceNamePart this.animNodes.legSolutionParentHLP.name 5 "leg-solution-parent-x"
				this.animNodes.legSolutionParentHLP.name = lb.nc.replaceNamePart this.animNodes.legSolutionParentHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.legSolutionParentHLP.size = 10 * _baseAnimEdit.scale[1]
				this.animNodes.legSolutionParentHLP.cross = false
				this.animNodes.legSolutionParentHLP.wirecolor = yellow	
				
				-- Creamos el legSoluti, que es donde irán emparentadas las cadenas de huesos para evitar la rotación de la pelvis.
				this.animNodes.legStructureHLP = lb.rig.createPointFromObj this.animNodes.thigh
					
				-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
				this.animNodes.legStructureHLP.name = lb.nc.replaceNamePart this.animNodes.legStructureHLP.name 5 "legStructure"
				this.animNodes.legStructureHLP.name = lb.nc.replaceNamePart this.animNodes.legStructureHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.legStructureHLP.size = 7 * _baseAnimEdit.scale[1]
				
				If side == lb.nc.NC_locationLeft then
					this.animNodes.legStructureHLP.wirecolor = blue
				else if side == lb.nc.NC_locationRight then
					this.animNodes.legStructureHLP.wirecolor = green
							
				-- Creamos el point que será el padre del pie de rig, para que cuando se instancia con el ik para hacer el offset, tenga las mismas coordenadas gimbal.
				this.animNodes.footParentHLP = lb.rig.createPointFromObj this.animNodes.calfEnd
				this.animNodes.footParentHLP.name = lb.nc.replaceNamePart this.animNodes.footParentHLP.name 5 "foot-x-hlp-parent"
				this.animNodes.footParentHLP.name = lb.nc.replaceNamePart this.animNodes.footParentHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.footParentHLP.size = 8 * _baseAnimEdit.scale[1]
				
				If side == lb.nc.NC_locationLeft then
					this.animNodes.footParentHLP.wirecolor = blue
				else if side == lb.nc.NC_locationRight then
					this.animNodes.footParentHLP.wirecolor = green
				
				-- Creamos el point que será el padre del pie de rig, para que cuando se instancia con el ik para hacer el offset, tenga las mismas coordenadas gimbal.
				this.animNodes.footOffsetHLP = lb.rig.createPointFromObj this.animNodes.calfEnd
				this.animNodes.footOffsetHLP.name = lb.nc.replaceNamePart this.animNodes.footOffsetHLP.name 5 "foot-offset-hlp-parent"
				this.animNodes.footOffsetHLP.name = lb.nc.replaceNamePart this.animNodes.footOffsetHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.footOffsetHLP.size = 10 * _baseAnimEdit.scale[1]
				
				If side == lb.nc.NC_locationLeft then
					this.animNodes.footOffsetHLP.wirecolor = blue
				else if side == lb.nc.NC_locationRight then
					this.animNodes.footOffsetHLP.wirecolor = green
				
				
				--*****************************************************************************/--FK--/*****************************************************************************--
				-- Creamos el point de referencia del SwivelAngle, que nos servirá cuando hagamos el snap de fk/ik a alinear el angulo de la rodilla
				this.fkNodes.refKneeIKHLP = lb.rig.createPointFromObj this.animNodes.calf
				this.fkNodes.refKneeIKHLP.name = lb.nc.replaceNamePart this.fkNodes.refKneeIKHLP.name 5 "refKneeIK"
				this.fkNodes.refKneeIKHLP.name = lb.nc.replaceNamePart this.fkNodes.refKneeIKHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.fkNodes.refKneeIKHLP.size = 7 * _baseAnimEdit.scale[1]
				this.fkNodes.refKneeIKHLP.wirecolor = green


				--*****************************************************************************/--IK--/*****************************************************************************--
				-- Creamos el point de referencia "footPosRef" que nos servirá como virtualParent (linkConstraint) de la plantilla de ik y de referencia para la orientación. 
				this.ikNodes.footPosRefHLP = lb.rig.createPointFromObj this.animNodes.calfEnd

				-- Cambia sus propiedas de color, nombre y tamaño.
				this.ikNodes.footPosRefHLP.name = lb.nc.replaceNamePart this.ikNodes.footPosRefHLP.name 5 "footPosRefIk"
				this.ikNodes.footPosRefHLP.name = lb.nc.replaceNamePart this.ikNodes.footPosRefHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.ikNodes.footPosRefHLP.size = 15 * _baseAnimEdit.scale[1]
				this.ikNodes.footPosRefHLP.wirecolor = red
				
				-- Creamos el point que será el padre de la ik, para que cuando se instancia con el hueso del pie para hacer el offset, tenga las mismas coordenadas gimbal.
				this.ikNodes.ikGoalParentHLP = lb.rig.createPointFromObj this.animNodes.foot
				this.ikNodes.ikGoalParentHLP.name = lb.nc.replaceNamePart this.ikNodes.ikGoalParentHLP.name 5 "ikGoalLegParentOffset"
				this.ikNodes.ikGoalParentHLP.name = lb.nc.replaceNamePart this.ikNodes.ikGoalParentHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)				
				this.ikNodes.ikGoalParentHLP.size = 12 * _baseAnimEdit.scale[1]
				this.ikNodes.ikGoalParentHLP.wirecolor = red

				-- Creamos el point que será el padre del elbow, para que cuando se instancia con el hueso de la mano para hacer el offset, tenga las mismas coordenadas gimbal.
				_kneeParent = lb.rig.createPointFromObj this.animNodes.calf
				_kneeParent.name = lb.nc.replaceNamePart _kneeParent.name 5 "kneeParent"
				_kneeParent.name = lb.nc.replaceNamePart _kneeParent.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)				
				_kneeParent.size = 12 * _baseAnimEdit.scale[1]
				_kneeParent.wirecolor = red
				
			)--CREACIÓN DE HELPERS AUXILIARES
			

			
			----------------------------------------------------
			-- MERGEO DE SHAPES DE CONTROL
			----------------------------------------------------
			(
				--*****************/IK/******************** --
				 _tempShapes = (lb.rig.solutions.mergeShape #leg side:side)
				
				-- Cuando mergeamos la plantilla recorremos todos los objetos ya que viene con points para los pivotes de balanceo. Lo guardamos cada uno en su variable.
				for o in _tempShapes do
				(
					_parts = filterString o.name "_"
					
					
					-- Filtramos la quinta parte
					case _parts[5] of
					(
						"footStep":
							this.ikNodes.footSHP	= o	
						
						"pivotInside":
							this.ikNodes.pivotInside	= o	
						
						"pivotOutside":
							this.ikNodes.pivotOutside	= o	
						
						"pivotFootHeel":
							this.ikNodes.pivotFootHeel	= o	
					)
				)
				
				this.ikNodes.footSHP.steps = 2 
				
				-- Mergeamos los controles de las rodillas del swivelAngle, renombramos las piezas, y cambiamos el color segun su lado.
				this.ikNodes.kneeSHP = (lb.rig.solutions.mergeShape #knee)[1]
				this.ikNodes.kneeSHP.name = lb.nc.replaceNamePart this.ikNodes.kneeSHP.name 4 side
				this.ikNodes.kneeSHP.name = lb.nc.replaceNamePart this.ikNodes.kneeSHP.name 5 "knee"

				If side == lb.nc.NC_locationLeft then
					this.ikNodes.kneeSHP.wirecolor = blue
				else if side == lb.nc.NC_locationRight then
					this.ikNodes.kneeSHP.wirecolor = green
				
				this.ikNodes.kneeSHP.steps = 2 
				
				-- Mergeamos el control de fkIk donde irá el customAttribute del Snap
				this.ikNodes.fkIkSHP = (lb.rig.solutions.mergeShape #fkIk)[1]
				this.ikNodes.fkIKSHP.name = lb.nc.replaceNamePart this.ikNodes.fkIKSHP.name 4 side
				
				this.ikNodes.fkIkSHP.length = ((distance this.animNodes.thigh this.animNodes.foot)/4)
				this.ikNodes.fkIkSHP.width = ((distance this.animNodes.thigh this.animNodes.foot)/4)
				
				If side == lb.nc.NC_locationLeft then
					this.ikNodes.fkIKSHP.wirecolor = blue
				else if side == lb.nc.NC_locationRight then
					this.ikNodes.fkIKSHP.wirecolor = green
				
				this.ikNodes.fkIkSHP.steps = 2 
				
				--*****************/BB/******************** --
				(
					-- Creamos el control del rompehuesos del codo. Calculamos el radio con un factor de división para que se adapte siempre según el tamaño del personaje.
					this.bbNodes.breakKneeSHP = (circle radius: ((distance this.animNodes.thigh this.ikNodes.footSHP)/8))
					
					this.bbNodes.breakKneeSHP.steps = 2
					
					-- Le establecemos un nombre con NC para poder cambiarle sus partes
					this.bbNodes.breakKneeSHP.name = this.ikNodes.kneeSHP.name
					
					this.bbNodes.breakKneeSHP.name = lb.nc.replaceNamePart this.bbNodes.breakKneeSHP.name 4 side
					this.bbNodes.breakKneeSHP.name = lb.nc.replaceNamePart this.bbNodes.breakKneeSHP.name 5 "breakKnee"
					
					If side == lb.nc.NC_locationLeft then
						this.bbNodes.breakKneeSHP.wirecolor = blue
					else if side == lb.nc.NC_locationRight then
						this.bbNodes.breakKneeSHP.wirecolor = green
					
					this.bbNodes.breakKneeSHP.steps = 2
				)
			)-- MERGEO DE SHAPES DE CONTROL
			
			
			-------------------------------------------------------
			-- CREACIÓN DE CONEXIONES DE PIERNA
			-------------------------------------------------------
			(
				--*****************************************************************************/--FK--/*****************************************************************************--
				-- Emparentamiento de upperArm de FK al "legStructureHLP" y clavicula al armSolution
				this.fkNodes.thigh.parent = this.animNodes.legStructureHLP
				lb.controller.freezeTransform this.fkNodes.thigh #all
				
				-- Alineamos el calfEnd con el calfEnd de rig.
				this.fkNodes.calfEnd.transform = this.animNodes.calfEnd.transform
				lb.controller.freezeTransform this.fkNodes.calfEnd #all
				
				-- Emparentamos el instep del pie con el calfEnd
				this.fkNodes.instep.parent = this.fkNodes.calfEnd
				lb.controller.freezeTransform this.fkNodes.instep #all
				
				-- Colocamos el punto de referencia para alinear el control del swivelAngle del ik, a una distancia dependiente 
				-- de la longitud de tight y el calf, manteniendola siempre igual, indistintamente de las proporciones.
				lb.controller.freezeTransform this.fkNodes.refKneeIkHLP #all
				
				-- Añadimos un constraint de orientación para tener la rotación media entre el upperArm y foreArm, para evitar un al añadir el swivel angle del ik que provoca al no tener la rot, correcta.
				lb.rig.addConstraint this.fkNodes.refKneeIkHLP #Rot this.fkNodes.thigh "OC_TEMP"
				this.fkNodes.refKneeIkHLP.rotation.controller[#OC_TEMP].appendTarget this.fkNodes.thigh 50
				
				-- Nos guardamos la tranformación para que cuando colapsemos el constraint, corregir el desfase.
				_transformBkp = this.fkNodes.refKneeIkHLP.transform
				
				-- Emparentamos al calf de fk.
				this.fkNodes.refKneeIkHLP.parent = this.fkNodes.calf
				
				-- Freezeamos el control para dejar
				lb.controller.freezeTransform this.fkNodes.refKneeIkHLP #all
				
				-- Freezeamos para dejar la nueva rotación por defecto.
				this.fkNodes.refKneeIkHLP.transform = _transformBkp
				
			
				-- Dependiendo del lado que sea le indicamos que se mueva en valor negativo o positivo en el eje y.
				If side == lb.nc.NC_locationLeft then
				(
					in coordSys local (rotate this.fkNodes.refKneeIkHLP (eulerAngles 0 180 0))
					in coordSys local move this.fkNodes.refKneeIkHLP [0,(distance this.fkNodes.thigh this.fkNodes.calfEnd),0]
				)
				else if side == lb.nc.NC_locationRight then
					in coordSys local move this.fkNodes.refKneeIkHLP [0,-(distance this.fkNodes.thigh this.fkNodes.calfEnd),0]
		
				lb.controller.freezeTransform this.fkNodes.refKneeIkHLP #all
				
				--*****************************************************************************/--IK--/*****************************************************************************--
				-- Emparentamiento de thigh de IK al armSolution
				this.ikNodes.thigh.parent = this.animNodes.legStructureHLP
				lb.controller.freezeTransform this.ikNodes.thigh #all
				
				-- Alineamos el calfEnd con el calfEnd.
				this.ikNodes.calfEnd.transform = this.animNodes.calfEnd.transform
				lb.controller.freezeTransform this.ikNodes.calfEnd #all
				
				-- Lo dejamos orientado con el mundo para el mantener el gimbal correcto. Emparentamos a la base y freezeamos la pieza.
				this.ikNodes.footPosRefHLP.rotation = (quat 0 0 0 0)
				
				--Emparentamos al legsolutionParent
				lb.controller.freezeTransform this.ikNodes.footPosRefHLP #all
				lb.controller.setActiveController this.ikNodes.footPosRefHLP #all #frozen
				this.ikNodes.footPosRefHLP.parent = this.animNodes.legSolutionParentHLP
				lb.controller.setActiveController this.ikNodes.footPosRefHLP #all #zero 
				lb.controller.freezeTransform this.ikNodes.footPosRefHLP #all
				
				-- Invertimos el eje para hacer la simetria del control que está emparentado a este objeto y manejarlo en el CBox
				If side == lb.nc.NC_locationRight then
					this.ikNodes.footPosRefHLP.transform = matrix3 -this.ikNodes.footPosRefHLP.transform[1] this.ikNodes.footPosRefHLP.transform[2] this.ikNodes.footPosRefHLP.transform[3] this.ikNodes.footPosRefHLP.transform[4]
				
				
				-- Alineamos la cruceta de ik con la muñeca de rig y emparentamos a la base. Añadimos el controlador LinkConstraint, más tarde añadiremos el CA_LinkConstraint y su virtualWorld.
				this.ikNodes.footSHP.transform = this.animNodes.calfEnd.transform
				this.ikNodes.footSHP.position.z = 0
				this.ikNodes.footSHP.pivot = this.animNodes.foot.pivot
				this.ikNodes.footSHP.parent = this.ikNodes.footPosRefHLP
				
				lb.controller.freezeTransform this.ikNodes.footSHP #all
				

				-- Centramos su punto de pivote y lo alineamos con el pie.
				CenterPivot this.ikNodes.fkIkSHP
				this.ikNodes.fkIkSHP.transform = this.ikNodes.footSHP.transform
				
				this.ikNodes.fkIkSHP.parent = this.animNodes.foot
				
				lb.controller.freezeTransform this.ikNodes.fkIkSHP #all
				
				-- Creamos el point que será el padre de la mano del codo para hacer la simetria del control que está emparentado a este objeto y manejarlo en el CBox
				_kneeParent.transform = this.fkNodes.refKneeIKHLP.transform
				
				lb.controller.freezeTransform _kneeParent #all
							
				-- Invertimos el eje para hacer la simetria del control que está emparentado a este objeto y manejarlo en el CBox
				If side == lb.nc.NC_locationRight then
				(
					_kneeParent.scale.controller[#Frozen_scale].controller.value = [-1,-1,-1]
					in coordSys local (rotate _kneeParent (eulerAngles 0 180 0))
				)

				
				-- Alineamos el control del swivelAngle con el kneeParent para colocarlo donde lo necesitamos. Emparentamos  y freezeamos.
				this.ikNodes.kneeSHP.transform = _kneeParent.transform
				this.ikNodes.kneeSHP.parent = _kneeParent
				
				lb.controller.freezeTransform this.ikNodes.kneeSHP #all	
					
				-- Creamos sistema de ik y asignamos control de swivelAngle.
				_legIkGoal = IKSys.ikChain this.ikNodes.thigh this.ikNodes.calfEnd "IKHISolver"
				
				-- Renombramos, emparentamos, freezeamos y añadimos el target del swivelAngle.
				_legIkGoal.name = this.ikNodes.calfEnd.name
				_legIkGoal.name = lb.nc.replaceNamePart _legIkGoal.name 5 "legIkGoal"
				_legIkGoal.name = lb.nc.replaceNamePart _legIkGoal.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				_legIkGoal.transform.controller.dispGoal = on
				_legIkGoal.controller.goalSize = 15 * _baseAnimEdit.scale[1] 
				
				_legIkGoal.controller.useVHTarget = true
				_legIkGoal.controller.VHTarget = this.ikNodes.kneeSHP

				_legIkGoal.transform = this.ikNodes.calfEnd.transform
				lb.controller.freezeTransform _legIkGoal #all	
				
				-- Le añadimos in OC para que siga la orientacion de la cruceta y nos sirva para luego alinear el hueso de fk de la mano con este mismo en el snap.
				lb.rig.addConstraint this.ikNodes.calfEnd #Rot this.ikNodes.footSHP "Zero_IK_Controller" keepInitOffset: true
				
				
				--*****************************************************************************/--BB--/*****************************************************************************--
				-- Convertimos la cadena de bb en strechin para manipular el rompecodos.
				_bbPoints = (lb.rig.createStretchBoneChain #(this.bbNodes.thigh, this.bbNodes.calf, this.bbNodes.calfEnd))
				_bbPoints.size = _bbPoints[1].size * _baseAnimEdit.scale[1]	
					

				-- Creamos un point que vaya orientado con el thigh y el calf al 50%, que será padre del breakKnee
				_bKneeParent = lb.rig.createPointFromObj this.ikNodes.calf
				_bKneeParent.size =	_bKneeParent.size * _baseAnimEdit.scale[1]
				_bKneeParent.parent = this.ikNodes.calf	
					
				lb.controller.freezeTransform _bKneeParent #all
				
				-- Invertimos para la simetria
				if side == lb.nc.NC_locationRight then
					lb.rig.flipAxis #(_bKneeParent)  true true true
					
				lb.rig.addConstraint _bKneeParent #Rot this.ikNodes.thigh "OC_calf_thigh" keepInitOffset: true
				_bKneeParent.rotation.controller[#OC_calf_thigh].controller.appendTarget this.ikNodes.calf 50
				
					
				-- Alineamos el control del rompecodos y lo emparentamos con el forearm de la cadena de ik. 
				this.bbNodes.breakKneeSHP.transform = this.fkNodes.refKneeIkHLP.transform
				this.bbNodes.breakKneeSHP.position = _bbPoints[2].position
				this.bbNodes.breakKneeSHP.parent = _bKneeParent
				in coordsys local (rotate this.bbNodes.breakKneeSHP (eulerAngles 0 90 0))
					
				lb.controller.freezeTransform this.bbNodes.breakKneeSHP #all
					
				-- Emparentamos points de la cadena de streching, lo cogemos por indice ya que sabemos que el 1 es el point del upperarm, 2 del forearm, y 3 del hand.
				_bbPoints[1].parent = this.animNodes.legStructureHLP
				lb.controller.freezeTransform _bbPoints[1] #all
				
				_bbPoints[2].parent = this.bbNodes.breakKneeSHP
				lb.controller.freezeTransform _bbPoints[2] #all
				
				_bbPoints[3].parent = this.ikNodes.calfEnd
				lb.controller.freezeTransform _bbPoints[3] #all
				
				-- Cambiamos los target del upnode a los huesos de ik respectivamente
				this.bbNodes.thigh.rotation.controller[#LookAt_Constraint].controller.pickUpNode = this.ikNodes.thigh
				this.bbNodes.calf.rotation.controller[#LookAt_Constraint].controller.pickUpNode = this.ikNodes.calf	
					
				--*****************************************************************************/--RIG--/*****************************************************************************--
				-- Freezeado de "legSolutionHLP", y emparentamiento a la base. 
				this.animNodes.legSolutionHLP.parent = _base
				lb.controller.freezeTransform this.animNodes.legSolutionHLP #all
				
				-- Freezeado de "legStructureHLP", el cual llevará un orientationConstraint al root,
				-- para que cuando se mueva la clavicula no se oriente, pero si cuando se rota el root.
				this.animNodes.legStructureHLP.parent = this.animNodes.legSolutionHLP
				lb.controller.freezeTransform this.animNodes.legStructureHLP #all
				
				-- Freezeado de "legSolutionParentHLP",  emparentamiento al armSolutionHLP,
				-- cambiamos su pivote al de la base y añadimos constraint de rot y pos.
				this.animNodes.legSolutionParentHLP.parent = this.animNodes.legSolutionHLP
				this.animNodes.legSolutionParentHLP.pivot = _base.pos
				WorldAlignPivot this.animNodes.legSolutionParentHLP
				lb.controller.freezeTransform this.animNodes.legSolutionParentHLP #all	

				lb.rig.addConstraint this.animNodes.legSolutionParentHLP #Pos _base "PC_base" keepInitOffset: true
				lb.rig.addConstraint this.animNodes.legSolutionParentHLP #Rot _base "OC_base" keepInitOffset: true
				
				lb.controller.freezeTransform this.ikNodes.footPosRefHLP #all

				-- Emparentamiento de thigh de Rig al "legStructureHLP" y pelvis al "legStructureHLP"
				this.animNodes.thigh.parent = this.animNodes.legStructureHLP
				lb.controller.freezeTransform this.animNodes.thigh #all
				
				-- Emparentamiento del instep con el foot
				this.animNodes.instep.parent = this.animNodes.foot
				lb.controller.freezeTransform this.animNodes.instep #all
				
				-- Añadimos controladores de rotación para instanciarlos con la cadena de FK y constraint de orientación para conectarlos con la cadena de IK.
				-- Controlador de FK de thigh
				this.animNodes.thigh.rotation.available.controller = euler_xyz()
				this.animNodes.thigh.rotation.controller[#Euler_XYZ].controller = this.fkNodes.thigh.rotation.controller[#Zero_Euler_XYZ].controller
				this.animNodes.thigh.rotation.controller.setName (this.animNodes.thigh.rotation.controller.count) "Zero_FK_Controller"
				
				-- Controlador de Ik de thigh
				lb.rig.addConstraint this.animNodes.thigh #Rot this.bbNodes.thigh "Zero_IK_Controller" keepInitOffset: true
							
				-- Controlador de FK de calf
				this.animNodes.calf.rotation.available.controller = euler_xyz()
				this.animNodes.calf.rotation.controller[#Euler_XYZ].controller = this.fkNodes.calf.rotation.controller[#Zero_Euler_XYZ].controller
				this.animNodes.calf.rotation.controller.setName (this.animNodes.calf.rotation.controller.count) "Zero_FK_Controller"
				
				-- Controlador de IK de calf
				lb.rig.addConstraint this.animNodes.calf #Rot this.bbNodes.calf "Zero_IK_Controller" keepInitOffset: true
			
				-- Emparentamos el helper con la base
				this.animNodes.footOffsetHLP.parent = this.animNodes.legSolutionParentHLP
				lb.controller.freezeTransform this.animNodes.footOffsetHLP #all
				
 				-- Añadimos constraint de posición al hueso final del foot para que cuando se mueva no tenga doble transformación la mano.
				lb.rig.addConstraint this.animNodes.footOffsetHLP #Pos this.animNodes.calfEnd "PC_rigCalfEnd" keepInitOffset: true
				
				-- Añadimos constraint de posición al hueso final del calf para que cuando se mueva no tenga doble transformación la mano.
				lb.rig.addConstraint this.animNodes.footOffsetHLP #Rot this.animNodes.calfEnd "OC_rigCalfEnd" keepInitOffset: true
				
				-- Añadimos constraint de posición al hueso final del foot para que cuando se mueva no tenga doble transformación la mano.
				lb.rig.addConstraint this.animNodes.footOffsetHLP #Rot this.ikNodes.footSHP "Zero_IK_Controller" keepInitOffset: true

				this.animNodes.footParentHLP.parent = this.animNodes.footOffsetHLP
				lb.controller.freezeTransform this.animNodes.footParentHLP #all
				
				-- Emparentamos el helper con el footParentHLP
				if side == lb.nc.NC_locationRight then
					lb.rig.flipAxis #(this.animNodes.footParentHLP)  true true true

				this.animNodes.foot.parent = this.animNodes.footParentHLP
				
				lb.controller.freezeTransform this.animNodes.foot #all
				
				-- Controlador de FK de foot
				this.animNodes.foot.rotation.available.controller = euler_xyz()
				this.animNodes.foot.rotation.controller[#Euler_XYZ].controller = this.fkNodes.calfEnd.rotation.controller[#Zero_Euler_XYZ].controller
				this.animNodes.foot.rotation.controller.setName (this.animNodes.foot.rotation.controller.count) "Zero_FK_Controller"
				
				-- Controlador de IK de foot
				this.animNodes.foot.rotation.available.controller = euler_xyz()
				this.animNodes.foot.rotation.controller.setName (this.animNodes.foot.rotation.controller.count) "Zero_IK_Controller"
				
				-- Controlador de FK de calfEnd
				this.animNodes.foot.position.available.controller = position_xyz()
				this.animNodes.foot.position.controller.setName (this.animNodes.foot.position.controller.count) "Zero_IK_Controller"
				this.animNodes.foot.position.controller.setActive (this.animNodes.foot.position.controller.count)

				-- Añadimos constraint de posición al hueso final del foreArm para que cuando se mueva no tenga doble transformación la mano.
				lb.rig.addConstraint this.animNodes.foot #Pos this.animNodes.calfEnd "PC_rigCalfEnd" keepInitOffset: true
				
			)-- CREACIÓN DE CONEXIONES
			
			
			--///////////////////////////////////////////////////////////////////////////////////////////////////--CREACION DE FOOT--///////////////////////////////////////////////////////////////////////////////////////////////////--
			(
				---------------------------------------------------------
				--CREACIÓN DE HUESOS AUXILIARES DEL PIE
				----------------------------------------------------------
				(
					--*****************************************************************************/--RIG--/*****************************************************************************--
					-- Creamos el final del toeCap que nos servirá de puntera para pivotar el pie en ik.
					this.animNodes.toeCapPivot = lb.rig.smartCreateEnd this.animNodes.toeCap
					this.animNodes.toeCapPivot.name = lb.nc.replaceNamePart this.animNodes.toeCapPivot.name 5 "toeCapPivot"
					
					
					--*****************************************************************************/--FK--/*****************************************************************************--
					-- Creamos el final del toeCap que nos servirá de puntera para pivotar el pie en fk.				
					this.fkNodes.toeCapPivot = lb.rig.smartCreateEnd this.fkNodes.toeCap
					this.fkNodes.toeCapPivot.name = lb.nc.replaceNamePart this.fkNodes.toeCapPivot.name 5 "toeCapPivotFk"
					
					
					--*****************************************************************************/--IK--/*****************************************************************************--
					-- Creamos el final de la cadena del hueso de la pelvis de la cadena de rig, que nos servirá para mantener la orientación de la pierna con el root, aunque rotemos la pelvis.
					this.ikNodes.toeCapPivot = lb.rig.smartCreateEnd this.ikNodes.toeCap
					this.ikNodes.toeCapPivot.name = lb.nc.replaceNamePart this.ikNodes.toeCapPivot.name 5 "toeCapPivotIk"
					
					-- Creamos el hueso que nos servira para mantener alienado siempre el foot.
					_alignBone = lb.rig.smartCreateEnd this.ikNodes.calf
					_alignBone.name = lb.nc.replaceNamePart this.ikNodes.toeCapPivot.name 5 "alignRefFootIk"
					
					_alignBone.taper = 0 * _baseAnimEdit.scale[1]
					_alignBone.width = 1 * _baseAnimEdit.scale[1]
					_alignBone.height = 1 * _baseAnimEdit.scale[1]
					
				)--CREACIÓN DE HUESOS AUXILIARES DEL PIE	
				
				------------------------------------------------------------
				--CREACIÓN DE HELPERS AUXILIARES DE PIE
				-----------------------------------------------------------------
				(
					--*****************************************************************************/--IK--/*****************************************************************************--
					-- Creamos el point que será el padre de la ik del INSTEP
					this.ikNodes.instepHLP = lb.rig.createPointFromObj this.animNodes.toeCap
					this.ikNodes.instepHLP.name = lb.nc.replaceNamePart this.ikNodes.instepHLP.name 5 "ikInstepParent"
					this.ikNodes.instepHLP.name = lb.nc.replaceNamePart this.ikNodes.instepHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)				
					this.ikNodes.instepHLP.size = 10 * _baseAnimEdit.scale[1]
					this.ikNodes.instepHLP.wirecolor = red		
					
					-- Creamos el point que será el padre de la ik del TOECAP
					this.ikNodes.toeCapHLP = lb.rig.createPointFromObj this.animNodes.toeCap
					this.ikNodes.toeCapHLP.name = lb.nc.replaceNamePart this.ikNodes.toeCapHLP.name 5 "ikToeCapParent"
					this.ikNodes.toeCapHLP.name = lb.nc.replaceNamePart this.ikNodes.toeCapHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)				
					this.ikNodes.toeCapHLP.size = 7 * _baseAnimEdit.scale[1]
					this.ikNodes.toeCapHLP.wirecolor = red
				
					-- Creamos el point que será el padre de las iks, del pie.
					this.ikNodes.toeCapPivotHLP = lb.rig.createPointFromObj this.animNodes.toeCapPivot
					this.ikNodes.toeCapPivotHLP.name = lb.nc.replaceNamePart this.ikNodes.toeCapPivotHLP.name 5 "iksFootParent"
					this.ikNodes.toeCapPivotHLP.name = lb.nc.replaceNamePart this.ikNodes.toeCapPivotHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)				
					this.ikNodes.toeCapPivotHLP.size = 7 * _baseAnimEdit.scale[1]
					this.ikNodes.toeCapPivotHLP.wirecolor = red	

				)--CREACIÓN DE HELPERS AUXILIARES DE PIE
				
				-------------------------------------------------------
				-- CREACIÓN DE CONEXIONES DE PIE
				-------------------------------------------------------	
				(					
					--*****************************************************************************/--IK--/*****************************************************************************--

					
					-- Emparentamos con el instep del pie de ik
					_alignBone.parent = this.ikNodes.instep
					_alignBone.transform = this.ikNodes.calfEnd.transform
					lb.controller.freezeTransform _alignBone #all
					
					-- Cambiamos los flags a los puntos de pivote.
					this.ikNodes.pivotInside.name = lb.nc.replaceNamePart this.ikNodes.pivotInside.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					this.ikNodes.pivotOutside.name = lb.nc.replaceNamePart this.ikNodes.pivotOutside.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					this.ikNodes.pivotFootHeel.name = lb.nc.replaceNamePart this.ikNodes.pivotFootHeel.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					
					this.ikNodes.pivotInside.size = this.ikNodes.pivotInside.size * _baseAnimEdit.scale[1]
					this.ikNodes.pivotOutside.size = this.ikNodes.pivotOutside.size * _baseAnimEdit.scale[1]
					this.ikNodes.pivotFootHeel.size = this.ikNodes.pivotFootHeel.size * _baseAnimEdit.scale[1]
					
					-- Alineamos los puntos de pivotaje del pie con el esqueleto de edition. Se hacen de padre a hijo para evitar romper la jerarquia.
					-- Desemparentamos para evitar fallos de posición al alinear la escala.
					_backpFootHeelParent = this.ikNodes.pivotFootHeel.parent
					_backpPivotOutsideParent = this.ikNodes.pivotOutside.parent
					_backpPivotInsideHeelParent = this.ikNodes.pivotInside.parent
					
					this.ikNodes.pivotFootHeel.parent = undefined
					this.ikNodes.pivotOutside.parent = undefined
					this.ikNodes.pivotInside.parent = undefined
					
					-- Hacemos backup de la escala para evitar fallos al escalar la base del esqueleto del edición de rig.
					_backPivotFootHeelSca = this.ikNodes.pivotFootHeel.scale
					_backPivotOutsideSca = this.ikNodes.pivotOutside.scale
					_backPivotInsideHeelSca = this.ikNodes.pivotInside.scale
					
					this.ikNodes.pivotFootHeel.transform = this.AnimEditNodes.pivotFootHeel.transform
					this.ikNodes.pivotOutside.transform = this.AnimEditNodes.pivotOutside.transform
					this.ikNodes.pivotInside.transform = this.AnimEditNodes.pivotInside.transform
					
					this.ikNodes.pivotFootHeel.scale = _backPivotFootHeelSca
					this.ikNodes.pivotOutside.scale = _backPivotOutsideSca
					this.ikNodes.pivotInside.scale = _backPivotInsideHeelSca
					
					this.ikNodes.pivotFootHeel.parent = _backpFootHeelParent
					this.ikNodes.pivotOutside.parent = _backpPivotOutsideParent
					this.ikNodes.pivotInside.parent = _backpPivotInsideHeelParent
					
					lb.controller.freezeTransform this.ikNodes.pivotFootHeel #all
					lb.controller.freezeTransform this.ikNodes.pivotOutside #all
					lb.controller.freezeTransform this.ikNodes.pivotInside #all
					
					-- Creamos sistema de ik del INSTEP y le cambiamos el padre espacial al solver plane y le ponemos ikGoal
					_instepIkGoal = IKSys.ikChain this.ikNodes.instep this.ikNodes.toeCap "IKLimb"
					_instepIkGoal.controller.SAParent = 0
					
					-- Reseteamos la rotación del hueso de ik para evitar desfases.
					this.ikNodes.instep.transform.controller.Preferred_Rotation_X = 0
					this.ikNodes.instep.transform.controller.Preferred_Rotation_Y = 0
					this.ikNodes.instep.transform.controller.Preferred_Rotation_Z = 0

					-- Renombramos, emparentamos, freezeamos y añadimos el target del swivelAngle.
					_instepIkGoal.name = this.ikNodes.calfEnd.name
					_instepIkGoal.name = lb.nc.replaceNamePart _instepIkGoal.name 5 "instepIkGoal"
					_instepIkGoal.name = lb.nc.replaceNamePart _instepIkGoal.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					
					_instepIkGoal.transform.controller.dispGoal = on
					_instepIkGoal.controller.goalSize = 10 * _baseAnimEdit.scale[1]
					
					-- Ahora que ya tenemos creado el toeCapPivotHLP emparentamos el kneeparent a el, para que vaya
					-- por defecto el knee con el movimiento del pie.
					lb.controller.setActiveController _kneeParent #all #frozen 
					_kneeParent.parent = this.ikNodes.toeCapPivotHLP
					lb.controller.setActiveController _kneeParent #all #zero
					
					-- Orientamos el ikGoal con su futuro padre y emparentamos.
					_instepIkGoal.parent = this.ikNodes.toeCapPivotHLP
					lb.controller.freezeTransform _instepIkGoal #all
					
					this.ikNodes.instepHLP.parent = this.ikNodes.toeCapPivotHLP
					
					lb.controller.freezeTransform this.ikNodes.instepHLP #all
					
					-- Emparentamos el instep a la ik para evitar que 
					lb.controller.setActiveController this.ikNodes.instep #all #Frozen
					this.ikNodes.instep.parent = _legIkGoal
					lb.controller.setActiveController this.ikNodes.instep #all #Zero		
	
					-- Creamos sistema de ik del TOECAP y le cambiamos el padre espacial al solver plane y le ponemos ikGoal
					_toeCapIkGoal = IKSys.ikChain this.ikNodes.toeCap this.ikNodes.toeCapPivot "IKLimb"
					_toeCapIkGoal.controller.SAParent = 0
					
					-- Reseteamos la rotación del hueso de ik para evitar desfases.
					this.ikNodes.toeCap.transform.controller.Preferred_Rotation_X = 0
					this.ikNodes.toeCap.transform.controller.Preferred_Rotation_Y = 0
					this.ikNodes.toeCap.transform.controller.Preferred_Rotation_Z = 0
									
					-- Renombramos, emparentamos, freezeamos y añadimos el target del swivelAngle.
					_toeCapIkGoal.transform = this.animNodes.toeCapPivot.transform
					_toeCapIkGoal.name = this.ikNodes.calfEnd.name
					_toeCapIkGoal.name = lb.nc.replaceNamePart _toeCapIkGoal.name 5 "toeCapIkGoal"
					_toeCapIkGoal.name = lb.nc.replaceNamePart _toeCapIkGoal.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					
					_instepIkGoal.transform.controller.dispGoal = on
					_instepIkGoal.controller.goalSize = 10 * _baseAnimEdit.scale[1]
					
					-- Orientamos el ikGoal con su futuro padre y emparentamos.
					_toeCapIkGoal.parent = this.ikNodes.toeCapHLP
					lb.controller.freezeTransform _toeCapIkGoal #all
					
					this.ikNodes.toeCapHLP.parent = this.ikNodes.toeCapPivotHLP
					lb.controller.freezeTransform this.ikNodes.toeCapHLP #all
					
					this.ikNodes.ikGoalParentHLP.parent = this.ikNodes.footSHP
					lb.controller.freezeTransform this.ikNodes.ikGoalParentHLP #all
					
					-- Emparentamos el helper con el footParentHLP
					if side == lb.nc.NC_locationRight then
						lb.rig.flipAxis #(this.ikNodes.ikGoalParentHLP)  true true true	
					
					-- Emparentamos el pivote de la puntera con el pivote interior
					this.ikNodes.toeCapPivotHLP.parent = this.ikNodes.pivotInside
					lb.controller.freezeTransform this.ikNodes.toeCapPivotHLP #all
					
					-- Emparentamos la ik de la pierna al pivote centrl para poder rotar del el pie y hacer el footRoll.
					lb.controller.setActiveController _legIkGoal #all #Frozen
					_legIkGoal.parent = this.ikNodes.instepHLP
					lb.controller.setActiveController _legIkGoal #all #Zero
					
					-- Emparentamos el pivote trasero de la plantilla para que cuando se haga el offset se vaya todo junto.
					this.ikNodes.pivotFootHeel.parent = this.ikNodes.ikGoalParentHLP
					lb.controller.freezeTransform this.ikNodes.pivotFootHeel #all
					
					this.ikNodes.pivotFootHeel.rotation.available.controller = euler_xyz()
					this.ikNodes.pivotFootHeel.rotation.controller.setName (this.ikNodes.pivotFootHeel.rotation.controller.count) "IK_alignController"
					
					_bckpName = this.ikNodes.pivotFootHeel.position.controller[#Zero_Pos_XYZ].name
					
					this.ikNodes.pivotFootHeel.position.controller[#Zero_Pos_XYZ].controller = this.animNodes.foot.position.controller[#Zero_IK_Controller].controller
					
					-- Renombramos la pista después de instanciar pya que pierde su nombre.
					this.ikNodes.pivotFootHeel.position.controller.setname 2 _bckpName
					
					--*****************************************************************************/--RIG--/*****************************************************************************--
					this.animNodes.instep.name = lb.nc.replaceNamePart this.animNodes.instep.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					-- Controlador de rig para forzar la alienación de instep
					lb.rig.addConstraint this.animNodes.foot #Rot _alignBone "IK_alignController" keepInitOffset: false
			
					-- Controlador de IK de instep
					lb.rig.addConstraint this.animNodes.instep #Rot this.ikNodes.instep "Zero_IK_controller" keepInitOffset: true
									
					-- Controlador de FK de instep
					this.animNodes.instep.rotation.available.controller = euler_xyz()
					this.animNodes.instep.rotation.controller[#Euler_XYZ].controller = this.fkNodes.instep.rotation.controller[#Zero_Euler_XYZ].controller
					this.animNodes.instep.rotation.controller.setName (this.animNodes.instep.rotation.controller.count) "Zero_FK_Controller"

					-- Controlador de IK de toeCap
					this.animNodes.toeCap.rotation.available.controller = euler_xyz()
					this.animNodes.toeCap.rotation.controller[#Euler_XYZ].controller = this.ikNodes.toeCapHLP.rotation.controller[#Zero_Euler_XYZ].controller
					this.animNodes.toeCap.rotation.controller.setName (this.animNodes.toeCap.rotation.controller.count) "Zero_IK_Controller"
					
					-- Controlador de FK de toeCap
					this.animNodes.toeCap.rotation.available.controller = euler_xyz()
					this.animNodes.toeCap.rotation.controller[#Euler_XYZ].controller = this.fkNodes.toeCap.rotation.controller[#Zero_Euler_XYZ].controller
					this.animNodes.toeCap.rotation.controller.setName (this.animNodes.toeCap.rotation.controller.count) "Zero_FK_Controller"
					
					-- Controlador de IK de toeCap para mantener la alineación.
					lb.rig.addConstraint this.animNodes.toeCap #Rot this.ikNodes.toeCap "IK_alignController" keepInitOffset: false
						
					--Instanciamos el controlador de la punta con el hlp de ik de la punta para poder controlarlo con el hueso de rig.
					this.animNodes.toeCapPivot.rotation.available.controller = euler_xyz()
					this.animNodes.toeCapPivot.rotation.controller[#Euler_XYZ].controller = this.ikNodes.toeCapPivotHLP.rotation.controller[#Zero_Euler_XYZ].controller
					this.animNodes.toeCapPivot.rotation.controller.setName (this.animNodes.toeCapPivot.rotation.controller.count) "Zero_IK_Controller"
					
					-- Controlador de rig para forzar la alienación de toeCapPivot
					lb.rig.addConstraint this.animNodes.toeCapPivot #Rot this.ikNodes.toeCapPivot "IK_alignController" keepInitOffset: false

					--Activamos el controlador de ik.
					this.animNodes.toeCapPivot.rotation.controller.active = 3
				)	
			)
			--///////////////////////////////////////////////////////////////////////////////////////////////////--FINAL CREACION DE FOOT--///////////////////////////////////////////////////////////////////////////////////////////////////--
			
			-------------------------------------------------------------------------------
			--CREACIÓN DE STRECHINGS
			-------------------------------------------------------------------------------
			(
				--************************* -- CONEXIONES DE STRECHING -- ************************* --				
				(
					--//////////////////////////-RIG-////////////////////////// --
					-- Thight--
					-- Bloqueamos el eje x de la escala compensando el valor que se le pasa de forma negativa en otro controlador
					this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ].controller.x_scale.controller = float_list()
					_fltScrpt = this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale].available.controller = float_script()
					this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale].controller.setName 2 "LockScale"
					_fltScrpt.AddObject "thighRig_scaX" this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_fltScrpt.script = "1 - thighRig_scaX.value"
					
					this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller = float_list()
					_floatExprCalf = this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = Float_Expression()
					this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 2 "Strech_FltExpr_X"
					_floatExprCalf.AddScalarConstant "thighRig_length" this.animNodes.thigh.length
					_floatExprCalf.AddScalarTarget "thighRig_scaX" this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_floatExprCalf.setExpression "(thighRig_scaX * thighRig_length) - thighRig_length"
					
					if side == lb.nc.NC_locationRight then
						_floatExprCalf.setExpression "-((thighRig_scaX * thighRig_length) - thighRig_length)"
					
					-- Calf --
					-- Bloqueamos el eje x de la escala compensando el valor que se le pasa de forma negativa en otro controlador
					this.animNodes.calf.scale.controller[#Zero_Scale_XYZ].controller.x_scale.controller = float_list()
					_fltScrpt = this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale].available.controller = float_script()
					this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale].controller.setName 2 "LockScale"
					_fltScrpt.AddObject "calfRig_scaX" this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_fltScrpt.script = "1 - calfRig_scaX.value"
					
					_floatExprCalfEnd = this.animNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller = float_list()
					_floatExprCalfEnd = this.animNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = Float_Expression()	
					this.animNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 2 "Strech_FltExpr_X"
					_floatExprCalfEnd.AddScalarConstant "calfRig_length" this.animNodes.calf.length
					_floatExprCalfEnd.AddScalarTarget "calfRig_scaX" this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_floatExprCalfEnd.setExpression "(calfRig_scaX * calfRig_length) - calfRig_length"
					
					if side == lb.nc.NC_locationRight then
						_floatExprCalfEnd.setExpression "-((calfRig_scaX * calfRig_length) - calfRig_length)"
					
					-- //////////////////////////-FK-////////////////////////// --
					-- Thigh --
					-- Bloqueamos el eje x de la escala compensando el valor que se le pasa de forma negativa en otro controlador
					this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ].controller.x_scale.controller = float_list()
					_fltScrptFkUppearm = this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale].available.controller = float_script()
					this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale].controller.setName 2 "LockScale"
					_fltScrptFkUppearm.AddObject "thighFk_scaX" this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_fltScrptFkUppearm.script = "1 - thighFk_scaX.value"
					

 					-- Creamos un floatExpressión para indicar la posición del hueso en X donde debe de estar respecto a la escala en X del hueso de rig. 
					this.fkNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller = float_list()
					_floatExprtCalf = this.fkNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = Float_Expression()
					this.fkNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 2 "Strech_FltExpr_X"
					_floatExprtCalf.AddScalarConstant "thighRig_length" this.fkNodes.thigh.length
					_floatExprtCalf.AddScalarTarget "thighRig_scaX" this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_floatExprtCalf.setExpression "(thighRig_scaX * thighRig_length) - thighRig_length"
					if side == lb.nc.NC_locationRight then
						_floatExprtCalf.setExpression "-((thighRig_scaX * thighRig_length) - thighRig_length)"
					
					--Forearm--
					-- Bloqueamos el eje x de la escala compensando el valor que se le pasa de forma negativa en otro controlador
					this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ].controller.x_scale.controller = float_list()
					_fltScrptFkCalf = this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale].available.controller = float_script()
					this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale].controller.setName 2 "LockScale"
					_fltScrptFkCalf.AddObject "calfFk_scaX" this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_fltScrptFkCalf.script = "1 - calfFk_scaX.value"
					
					this.fkNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller = float_list()
					_floatExprCalfEnd = this.fkNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = Float_Expression()
					this.fkNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 2 "Strech_FltExpr_X"	
					_floatExprCalfEnd.AddScalarConstant "calfRig_length" this.fkNodes.calf.length
					_floatExprCalfEnd.AddScalarTarget "calfRig_scaX" this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_floatExprCalfEnd.setExpression "(calfRig_scaX * calfRig_length) - calfRig_length"
					
					if side == lb.nc.NC_locationRight then
						_floatExprCalfEnd.setExpression "-((calfRig_scaX * calfRig_length) - calfRig_length)"

					
					--//////////////////////////- IK -////////////////////////// --
						-- thigh--
					-- Bloqueamos el eje x de la escala compensando el valor que se le pasa de forma negativa en otro controlador
					this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ].controller.x_scale.controller = float_list()
					_fltScrptIkThigh = this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale].available.controller = float_script()
					this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale].controller.setName 2 "LockScale"
					_fltScrptIkThigh.AddObject "thighFk_scaX" this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_fltScrptIkThigh.script = "1 - thighFk_scaX.value"

					-- Creamos un floatExpressión para indicar la posición del hueso en X donde debe de estar respecto a la escala en X del hueso de rig. 
					this.ikNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller = float_list()
					_floatExprcalf = this.ikNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = Float_Expression()
					this.ikNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 2 "Strech_FltExpr_X"
					
					_floatExprcalf.AddScalarConstant "thighRig_length" this.ikNodes.thigh.length
					_floatExprcalf.AddScalarTarget "thighRig_scaX" this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_floatExprcalf.setExpression "(thighRig_scaX * thighRig_length) - thighRig_length"
					
					if side == lb.nc.NC_locationRight then
						_floatExprcalf.setExpression "-((thighRig_scaX * thighRig_length) - thighRig_length)"
					
					--calf--
					-- Bloqueamos el eje x de la escala compensando el valor que se le pasa de forma negativa en otro controlador
					this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ].controller.x_scale.controller = float_list()
					_fltScrptIkcalf = this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale].available.controller = float_script()
					this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale].controller.setName 2 "LockScale"
					_fltScrptIkcalf.AddObject "calfFk_scaX" this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_fltScrptIkcalf.script = "1 - calfFk_scaX.value"
					
					this.ikNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller = float_list()
					_floatExprCalfEnd = this.ikNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = Float_Expression()
					this.ikNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 2 "Strech_FltExpr_X"	
					_floatExprCalfEnd.AddScalarConstant "calfRig_length" this.ikNodes.calf.length
					_floatExprCalfEnd.AddScalarTarget "calfRig_scaX" this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float]
					_floatExprCalfEnd.setExpression "(calfRig_scaX * calfRig_length) - calfRig_length"
					
					if side == lb.nc.NC_locationRight then
						_floatExprCalfEnd.setExpression "-((calfRig_scaX * calfRig_length) - calfRig_length)"
				)
				
				--************************* -- CONEXIONES DE AUTOSTRECHING -- ************************* --				
				(
					--//////////////////////////-RIG-////////////////////////// --
					-- Añadimos un controlador nuevo donde metermos un Flt Expr en el x con la fórmula para el autostrech
					_autoStrchExpr = this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = float_expression()
					this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 3 "AutoStrech_FltExpr_X"
					_autoStrchExpr.AddScalarTarget  "baseSca" _base.scale.controller[#Zero_Scale_XYZ][#X_scale] -- Añadimos el eje X de la base para más adelante meterlo en la fórmula cuando se añada el spinner.
					_autoStrchExpr.AddScalarConstant  "refLencalf" this.animNodes.calf.length
					_autoStrchExpr.AddScalarConstant  "refLenthigh" this.animNodes.thigh.length
					_autoStrchExpr.AddScalarTarget "calfXSca" this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_scale][#Bezier_float]
					_autoStrchExpr.AddScalarTarget "thighXSca" this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_scale][#Bezier_float]
					_autoStrchExpr.AddVectorNode "refPos02" this.animNodes.legStructureHLP
					_autoStrchExpr.AddVectorNode  "refPos01" this.ikNodes.footSHP
			
					this.animNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = _autoStrchExpr
					
					--//////////////////////////- IK -////////////////////////// --
					-- Añadimos un controlador nuevo donde metermos un Flt Expr en el x con la fórmula para el autostrech
					_autoStrchExpr = this.ikNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = float_expression()
					this.ikNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 3 "AutoStrech_FltExpr_X"
					_autoStrchExpr.AddScalarTarget  "baseSca" _base.scale.controller[#Zero_Scale_XYZ][#X_scale] -- Añadimos el eje X de la base para más adelante meterlo en la fórmula cuando se añada el spinner.
					_autoStrchExpr.AddScalarConstant  "refLencalf" this.ikNodes.calf.length
					_autoStrchExpr.AddScalarConstant  "refLenthigh" this.ikNodes.thigh.length
					_autoStrchExpr.AddScalarTarget "calfXSca" this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_scale][#Bezier_float]
					_autoStrchExpr.AddScalarTarget "thighXSca" this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_scale][#Bezier_float]
					_autoStrchExpr.AddVectorNode "refPos02" this.animNodes.legStructureHLP
					_autoStrchExpr.AddVectorNode  "refPos01" this.ikNodes.footSHP
			
					this.ikNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = _autoStrchExpr
					
					--//////////////////////////- FK -////////////////////////// --
					-- Añadimos un controlador nuevo donde metermos un Flt Expr en el x con la fórmula para el autostrech
					_autoStrchExpr = this.fkNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = float_expression()
					this.fkNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 3 "AutoStrech_FltExpr_X"
					_autoStrchExpr.AddScalarTarget  "baseSca" _base.scale.controller[#Zero_Scale_XYZ][#X_scale] -- Añadimos el eje X de la base para más adelante meterlo en la fórmula cuando se añada el spinner.
					_autoStrchExpr.AddScalarConstant  "refLencalf" this.fkNodes.calf.length
					_autoStrchExpr.AddScalarConstant  "refLenthigh" this.fkNodes.thigh.length
					_autoStrchExpr.AddScalarTarget "calfXSca" this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_scale][#Bezier_float]
					_autoStrchExpr.AddScalarTarget "thighXSca" this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_scale][#Bezier_float]
					_autoStrchExpr.AddVectorNode "refPos02" this.animNodes.legStructureHLP
					_autoStrchExpr.AddVectorNode  "refPos01" this.ikNodes.footSHP
			
					this.fkNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = _autoStrchExpr
					
				)
				
				--************************* -- CONEXIONES DE ROMPEHUESOS -- ************************* --				
				(
					--//////////////////////////-RIG-////////////////////////// --
					-- Forearm
					-- Añadimos un controlador nuevo donde metermos un Flt Expr en el x con la fórmula para el rompehuesos
					_strechBreakBones = this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = float_expression()
					this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 4 "strechBreakBones_FltExpr_X"
					_strechBreakBones.AddScalarTarget  "baseSca" _base.scale.controller[#Zero_Scale_XYZ][#X_scale] -- Añadimos el eje X de la base para más adelante meterlo en la fórmula cuando se añada el spinner.
					_strechBreakBones.AddVectorNode "refPosBBUp" this.bbNodes.thigh
					_strechBreakBones.AddVectorNode  "refPosIKFor" this.ikNodes.calf
					_strechBreakBones.AddVectorNode  "refPosBBFor" this.bbNodes.calf
					_strechBreakBones.setExpression "((length (refPosBBUp - refPosBBFor))/baseSca - (length (refPosBBUp - refPosIKFor))/baseSca)"
					
					if side == lb.nc.NC_locationRight then
						_strechBreakBones.setExpression "-((length (refPosBBUp - refPosBBFor))/baseSca - (length (refPosBBUp - refPosIKFor))/baseSca)"
					
					-- ForearmEnd
					-- Añadimos un controlador nuevo donde metermos un Flt Expr en el x con la fórmula para el rompehuesos
					_strechBreakBones = this.animNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].available.controller = float_expression()
					this.animNodes.calfEnd.position.controller[#Zero_Pos_XYZ][#X_Position].controller.setName 4 "strechBreakBones_FltExpr_X"
					_strechBreakBones.AddScalarTarget  "baseSca" _base.scale.controller[#Zero_Scale_XYZ][#X_scale] -- Añadimos el eje X de la base para más adelante meterlo en la fórmula cuando se añada el spinner.
					_strechBreakBones.AddVectorNode  "refPosBBFor" this.bbNodes.calf
					_strechBreakBones.AddVectorNode  "refPosIKFor" this.ikNodes.calf
					_strechBreakBones.AddVectorNode "refPosBBHand" this.bbNodes.calfEnd
					_strechBreakBones.setExpression "((length (refPosBBFor - refPosBBHand))/baseSca - (length (refPosIKFor - refPosBBHand))/baseSca)"
					
					if side == lb.nc.NC_locationRight then
						_strechBreakBones.setExpression "-((length (refPosBBFor - refPosBBHand))/baseSca - (length (refPosIKFor - refPosBBHand))/baseSca)"
				)	
				
				--************************* -- LIMITES DE ESCALA -- ************************* --				
				(
					-- Añadimos los limites a las escalas de las piezas e instanciamos con el hueso de rig. Reasignamos el target ya que se pierde en el float expression después de la instancia.
					--//////////////////////////- RIG -////////////////////////// --
					this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float].controller = float_limit upper_limit: 1000000 lower_limit: 0
					this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float].controller = float_limit upper_limit: 1000000 lower_limit: 0		
					
					this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#LockScale].AddObject "thighRig_scaX" this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
					this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#LockScale].AddObject "calfRig_scaX" this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
				
 					--//////////////////////////-FK-///////////////////////////// --
					this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float].controller = float_limit upper_limit: 1000000 lower_limit: 0
					this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float].controller = float_limit upper_limit: 1000000 lower_limit: 0

					this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller = this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
					this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller = this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
					
					this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#LockScale].AddObject "thighFk_scaX" this.fkNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
					this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#LockScale].AddObject "calfFk_scaX" this.fkNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
					
					--//////////////////////////-IK-//////////////////////////// --
					this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float].controller = float_limit upper_limit: 1000000 lower_limit: 0
					this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float].controller = float_limit upper_limit: 1000000 lower_limit: 0
					
					this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller = this.animNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
					this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller = this.animNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller

					this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#LockScale].AddObject "thighFk_scaX" this.ikNodes.thigh.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
					this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#LockScale].AddObject "calfFk_scaX" this.ikNodes.calf.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Float_Limit].controller
					
				)	
			)-- CREACIÓN DE STRECHINGS

			-------------------------------------------------------------------------------
			-- CREACIÓN DE CUSTOMS ATTRIBUTES Y WIREPARAMETERS
			-------------------------------------------------------------------------------
			(
				--//////////////////////////-FKIK SNAP-////////////////////////// --
				-- Creamos el modificador vacio, y añadimos el CA del FkIk Snap.
				_emptyModFkIk = emptyModifier()
				_emptyModFkIk.name = "Leg_Controls"
				custAttributes.add  _emptyModFkIk (this.fkIkLegCA) #unique
				
				-- Creamos el modificador vacio y le añadimo el CA de fkIkArms para luego añadirlo a todas las piezas.
				_emptyModIndFkIk = emptyModifier()
					
				--*****************/IK/******************** --			
				addModifier this.ikNodes.fkIkSHP _emptyModFkIk
				custAttributes.add  this.ikNodes.fkIkSHP.modifiers[#Leg_Controls] (lb.rig.solutions.autoStrechCA) #unique
					
				-- Montaje de controladores de autoStrech y multiplier e instanciado de controladores de fkIk con el controlador de multiplierCurve.
				-- Añadimos el limitController de 0 a 1.
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkik.controller = bezier_float()
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkik.controller = float_limit upper_limit: 1 lower_limit: 0	
				
				-- Añadimos un multiplier curve para poder hacer que el controlador de fkik cuando suba que no afecte al de ,
				-- autostrech pero que si está a cero el autostrech no se pueda manipular
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].autostrechIK.autostrech.controller = bezier_float()					
				addMultiplierCurve this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].autostrechIK.autostrech.controller
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].autostrechIK.autostrech.controller = float_limit upper_limit: 1 lower_limit: 0	
					
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].autostrechIK.autostrech.controller[#Limited_Controller__Bezier_Float].multiplier_curve.controller = this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkik.controller[#Limited_Controller__Bezier_Float].controller
										
				-- Sobreescribimos el script del autostrech para añadir el spinner del autostrech y ponerlo en la formila.	
				this.ikNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.AddScalarTarget "spnAutoStrech" this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].autostrechIK.autostrech.controller
			
				this.ikNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.setExpression "if ((length (refPos02 - refPos01))/baseSca > ((refLencalf) + (refLenthigh)), (((length (refPos02 - refPos01))/baseSca - ((refLencalf ) + (refLenthigh))) /2) * spnAutoStrech , 0 )"
					
				if side == lb.nc.NC_locationRight then		
					this.ikNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.setExpression "if ((length (refPos02 - refPos01))/baseSca > ((refLencalf) + (refLenthigh)), -(((length (refPos02 - refPos01))/baseSca - ((refLencalf ) + (refLenthigh))) /2) * spnAutoStrech , 0 )"

				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].side = side	
					
				-- Rellenamos los nodos del customAttribute
				-- Cadena de IK	
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkIkSHP = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikCalfEnd = (nodeTransformMonitor node:this.ikNodes.calfEnd forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikFootSHP = (nodeTransformMonitor node:this.ikNodes.footSHP forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikKnee = (nodeTransformMonitor node:this.ikNodes.kneeSHP forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikCalf = (nodeTransformMonitor node:this.ikNodes.calf forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikThigh = (nodeTransformMonitor node:this.ikNodes.thigh forwardTransformChangeMsgs:false)
					
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikToeCapHLP = (nodeTransformMonitor node:this.ikNodes.toeCapHLP forwardTransformChangeMsgs:false)				
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikInstep = (nodeTransformMonitor node:this.ikNodes.instep forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikInstepGoal = (nodeTransformMonitor node:_instepIkGoal forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikToeCap = (nodeTransformMonitor node:this.ikNodes.toeCap forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].ikAlignRef = (nodeTransformMonitor node:_alignBone forwardTransformChangeMsgs:false)
				
				
				-- Añadimos el modificador y rellenamos el CustAttrib del IndirectFkIkSnaps
				addModifier this.ikNodes.footSHP (copy _emptyModIndFkIk)
				this.ikNodes.footSHP.modifiers[#Attribute_Holder].name = "Leg_Controls"
				custAttributes.add this.ikNodes.footSHP.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique						
		
				addModifier this.ikNodes.kneeSHP (copy _emptyModIndFkIk)
				this.ikNodes.kneeSHP.modifiers[#Attribute_Holder].name = "Leg_Controls" 
				custAttributes.add this.ikNodes.kneeSHP.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique						
				this.ikNodes.kneeSHP.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				
				for _o in #(this.ikNodes.kneeSHP) do
				(
					-- Ajuste de tamaño de shapes de la cruceta con un xform igualandolo con la escala de la base del esqueleto de edición de rig.
					addModifier _o (xForm()) before: _o.modifiers.count
					
					_o.modifiers[#xForm].gizmo.controller.scale = _baseAnimEdit.scale
					maxOps.CollapseNodeTo _o 2 true   
				)	
				
				--*****************/BB/******************** --
				addModifier this.bbNodes.breakKneeSHP (copy _emptyModIndFkIk)
				this.bbNodes.breakKneeSHP.modifiers[#Attribute_Holder].name = "Leg_Controls" 
				custAttributes.add this.bbNodes.breakKneeSHP.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique						
						
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].bbCalf = (nodeTransformMonitor node:this.bbNodes.calf forwardTransformChangeMsgs:false) 
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].bbThigh = (nodeTransformMonitor node:this.bbNodes.thigh forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].bbCalfEnd = (nodeTransformMonitor node:this.bbNodes.calfEnd forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].bbBreakKneeSHP = (nodeTransformMonitor node:this.bbNodes.breakKneeSHP forwardTransformChangeMsgs:false)

					
				--*****************/RIG/******************** --
				-- Sobreescribimos el script del autostrech para añadir el spinner del autostrech y ponerlo en la formila.						
				this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.AddScalarTarget "spnAutoStrech" this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].autostrechIK.autostrech.controller
			
				this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.setExpression "if ((length (refPos02 - refPos01))/baseSca > ((refLencalf) + (refLenthigh)), (((length (refPos02 - refPos01))/baseSca - ((refLencalf ) + (refLenthigh))) /2) * spnAutoStrech , 0 )"
					
				if side == lb.nc.NC_locationRight then		
					this.animNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.setExpression "if ((length (refPos02 - refPos01))/baseSca > ((refLencalf) + (refLenthigh)), -(((length (refPos02 - refPos01))/baseSca - ((refLencalf ) + (refLenthigh))) /2) * spnAutoStrech , 0 )"
	
					
				-- Rellenamos los nodos del customAttribute
				-- Cadena de RIG	
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].calf = (nodeTransformMonitor node:this.animNodes.calf forwardTransformChangeMsgs:false) 
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].thigh = (nodeTransformMonitor node:this.animNodes.thigh forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].foot = (nodeTransformMonitor node:this.animNodes.foot forwardTransformChangeMsgs:false)
					
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].instep = (nodeTransformMonitor node:this.animNodes.instep forwardTransformChangeMsgs:false) 
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].toeCap = (nodeTransformMonitor node:this.animNodes.toeCap forwardTransformChangeMsgs:false) 
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].toeCapPivot = (nodeTransformMonitor node:this.animNodes.toeCapPivot forwardTransformChangeMsgs:false)
				
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].base = (nodeTransformMonitor node:_base forwardTransformChangeMsgs:false) 
				
				--Añadimos el CA hiddenFkIk Snap.
				for o in this.animNodes.toes do
				(					
					addModifier o (copy _emptyModIndFkIk)
					o.modifiers[#Attribute_Holder].name = "Leg_Controls"
					custAttributes.add o.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique	
					o.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				)
 				
 				-- Añadimos el modificador y rellenamos el CustAttrib del IndirectFkIkSnaps		
			
				addModifier this.animNodes.thigh (copy _emptyModIndFkIk)
				this.animNodes.thigh.modifiers[#Attribute_Holder].name = "Leg_Controls"
				custAttributes.add this.animNodes.thigh.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique						

				addModifier this.animNodes.calf (copy _emptyModIndFkIk)
				this.animNodes.calf.modifiers[#Attribute_Holder].name = "Leg_Controls"
				custAttributes.add this.animNodes.calf.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique						

				addModifier this.animNodes.foot (copy _emptyModIndFkIk)
				this.animNodes.foot.modifiers[#Attribute_Holder].name = "Leg_Controls"
				custAttributes.add this.animNodes.foot.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique

				addModifier this.animNodes.toeCap (copy _emptyModIndFkIk)
				this.animNodes.toeCap.modifiers[#Attribute_Holder].name = "Leg_Controls"
				custAttributes.add this.animNodes.toeCap.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique
					
				addModifier this.animNodes.toeCapPivot (copy _emptyModIndFkIk)
				this.animNodes.toeCapPivot.modifiers[#Attribute_Holder].name = "Leg_Controls"
				custAttributes.add this.animNodes.toeCapPivot.modifiers[#Leg_Controls] (lb.rig.solutions.indirectFkIkSnaps) #unique
					
				this.animNodes.thigh.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				this.animNodes.calf.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				this.animNodes.foot.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				this.animNodes.toeCap.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				this.animNodes.toeCapPivot.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
					

				--*****************/FK/******************** --
				-- Sobreescribimos el script del autostrech para añadir el spinner del autostrech y ponerlo en la formila.						
				this.fkNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.AddScalarTarget "spnAutoStrech" this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].autostrechIK.autostrech.controller
			
				this.fkNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.setExpression "if ((length (refPos02 - refPos01))/baseSca > ((refLencalf) + (refLenthigh)), (((length (refPos02 - refPos01))/baseSca - ((refLencalf ) + (refLenthigh))) /2) * spnAutoStrech , 0 )"
					
				if side == lb.nc.NC_locationRight then		
					this.fkNodes.calf.position.controller[#Zero_Pos_XYZ][#X_Position][#AutoStrech_FltExpr_X].controller.setExpression "if ((length (refPos02 - refPos01))/baseSca > ((refLencalf) + (refLenthigh)), -(((length (refPos02 - refPos01))/baseSca - ((refLencalf ) + (refLenthigh))) /2) * spnAutoStrech , 0 )"
					
					
				-- Rellenamos los nodos del customAttribute			
				-- Cadena de FK
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkCalf = (nodeTransformMonitor node:this.fkNodes.calf forwardTransformChangeMsgs:false)
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkThigh = (nodeTransformMonitor node:this.fkNodes.thigh forwardTransformChangeMsgs:false) 
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkCalfEnd = (nodeTransformMonitor node:this.fkNodes.calfEnd forwardTransformChangeMsgs:false) 
					
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkInstep = (nodeTransformMonitor node:this.fkNodes.instep forwardTransformChangeMsgs:false) 
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkToeCap = (nodeTransformMonitor node:this.fkNodes.toeCap forwardTransformChangeMsgs:false) 
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkToeCapPivot = (nodeTransformMonitor node:this.fkNodes.toeCapPivot forwardTransformChangeMsgs:false) 
					
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].refKneeIK = (nodeTransformMonitor node:this.fkNodes.refKneeIKHLP forwardTransformChangeMsgs:false) 


				--//////////////////////////////////////////////////////////////////////////////////////-LINK CONSTRAINT-////////////////////////////////////////////////////////////////////////////////////////////// --
				
				--*****************/IK/******************** --
				-- Añadimos el CA linkConstraint
				
				this.ikNodes.footSHP.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				
				lb.links.pointConstraint.add this.ikNodes.footSHP
				lb.links.addTarget this.ikNodes.footSHP undefined frameNo:0
		
				-- Añadimos el CA linkConstraint
				this.ikNodes.kneeSHP.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				
				lb.links.pointConstraint.add this.ikNodes.kneeSHP
				lb.links.addTarget this.ikNodes.kneeSHP undefined frameNo:0

				--*****************/BB/******************** --
				-- Añadimos el CA linkConstraint
				this.bbNodes.breakKneeSHP.modifiers[#Leg_Controls].fkIkNode = (nodeTransformMonitor node:this.ikNodes.fkIkSHP forwardTransformChangeMsgs:false)
				
				lb.links.pointConstraint.add this.bbNodes.breakKneeSHP
				lb.links.addTarget this.bbNodes.breakKneeSHP undefined frameNo:0
				
				--//////////////////////////////////////////////////////////////////////////////-WIREPARAMETERS E INSTANCIAS-////////////////////////////////////////////////////////////////////////////////// --
				-- Conectamos el spinner de fkik con el radio del rompehuesos
				_scaFlt = this.bbNodes.breakKneeSHP.scale.controller.available.controller = scale_expression()
				_scaFlt.addScalarTarget "fkIk" this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkik.controller
				_scaFlt.setExpression "[fkIk + 0.00001 ,fkIk + 0.00001,fkIk + 0.00001]"
				
-- 				if side == lb.nc.NC_locationRight then
-- 					_scaFlt.setExpression "[-(fkIk + 0.00001) ,-(fkIk + 0.00001),-(fkIk + 0.00001)]"
-- 				
				this.ikNodes.kneeSHP.scale.controller.available.controller = _scaFlt


				-- Intanciamos la escala del knee y el control del pie al spinner del ik para que se oculte cuando pasamos a F
				-- Añadimos el modificador xForm para poder escalar el shape sin afectar a la escala.			
				addModifier this.ikNodes.footSHP (xForm()) before: this.ikNodes.footSHP.modifiers.count
				this.ikNodes.footSHP.modifiers[#xForm].gizmo.controller.scale.controller = _scaFlt
					
				this.ikNodes.footSHP.modifiers[#xForm].name = "Scale_xForm"
					
				this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller = float_expression()
				this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller.addScalarTarget "fkik" this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkIkSnaps[#fkik].controller
				this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller.setExpression "fkik"
				
				this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_FK_Controller].controller = float_expression()
				this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_FK_Controller].controller.addScalarTarget "fkik" this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkIkSnaps[#fkik].controller
				this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_FK_Controller].controller.setExpression "1 - fkik"
				
				this.animNodes.calf.rotation.controller.weights[#Weight__Zero_IK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller
				this.animNodes.calf.rotation.controller.weights[#Weight__Zero_FK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_FK_Controller].controller
									
				
																				--*****************/FOOT/******************** --
				
				this.animNodes.foot.rotation.controller.weights[#Weight__Zero_IK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller
				this.animNodes.foot.rotation.controller.weights[#Weight__Zero_FK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_FK_Controller].controller
				this.animNodes.foot.rotation.controller.weights[#Weight__IK_alignController].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller
				this.animNodes.footOffsetHLP.rotation.controller.weights[#Weight__Zero_IK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller
				
				this.animNodes.instep.rotation.controller.weights[#Weight__Zero_IK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller
				this.animNodes.instep.rotation.controller.weights[#Weight__Zero_FK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_FK_Controller].controller
				
				this.animNodes.toeCap.rotation.controller.weights[#Weight__Zero_IK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller
				this.animNodes.toeCap.rotation.controller.weights[#Weight__Zero_FK_Controller].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_FK_Controller].controller
				this.animNodes.toeCap.rotation.controller.weights[#Weight__IK_alignController].controller = this.animNodes.thigh.rotation.controller.weights[#Weight__Zero_IK_Controller].controller
					
				this.animNodes.toeCapPivot.scale.controller.available.controller = _scaFlt
				
				-- Ajustamos los tamaños de los shapes.
				lb.rig.snapByShape this.AnimEditNodes.footSHP this.ikNodes.footSHP
				lb.rig.snapByShape _baseAnimEdit _base

			)-- CREACIÓN DE CUSTOMS ATTRIBUTES Y WIREPARAMETERS
			
			-------------------------------------------------------
			-- CREACIÓN DE POINT SCRIPT Y FLOAT EXPRESSION
			-------------------------------------------------------
			(
				--//////////////////////////-- SCRIPTS -////////////////////////// --
				(
					-- Objeto donde añadimos el script
					-- Comprobación de la existencia de Controlador de Script.
					_pointScript = lb.rig.createPointFromObj this.animNodes.legSolutionHLP
					_pointScript.name = lb.nc.replaceNamePart _pointScript.name 5 "legSolution-hlp-scripts"
					_pointScript.size = 2 * _baseAnimEdit.scale[1]
					_pointScript.wirecolor = orange
					
					_pointScript.parent = this.animNodes.legSolutionHLP
					lb.controller.freezeTransform _pointScript #all
					
					-- Añade un controlador 'Position_Script' al HLP padre de la solución.
					_pointScript.pos.controller.available.controller = Position_Script() 
					
					-- Cambio del nombre del controlador.
					_pointScript.pos.controller.setName (_pointScript.pos.controller.count) ("LEG_" + toUpper side + "_FKIK_SC")
					
					_scriptCtrl = _pointScript.pos.controller[_pointScript.pos.controller.count] -- almacenado del último controlador del 'pointScripts' en 'scriptCtrl'.
					

					-- Creación de variables para 'scriptCtrl'.
					_fkIkController = this.ikNodes.fkIKSHP.modifiers[#Leg_Controls].fkik.controller -- almacenado en 'fkIkController' del controlador FKIK 
					
					-- Creación de variables dentro del pointScript
					_scriptCtrl.addObject #fkik this.ikNodes.fkIKSHP.modifiers[#Leg_Controls].fkik.controller
					_scriptCtrl.addObject #thigh this.animNodes.thigh
					_scriptCtrl.addObject #calf this.animNodes.calf
					_scriptCtrl.addObject #foot this.animNodes.foot
					_scriptCtrl.addObject #instep this.animNodes.instep
					_scriptCtrl.addObject #toeCap this.animNodes.toeCap
					_scriptCtrl.addObject #toeCapPivot this.animNodes.toeCap
					
					-- Añadimos el texto que va ir dentro del script
					(
						_scriptCtrl.script = --"handPos = hand.position.controller\n" +
						--"handRot = hand.rotation.controller\n" +
						--"\n" +
						"if fkik.value > 0 and thigh.rotation.controller.active != 4 then\n" +
						
						"(\n" +
						
						"	-- Controlador activo para posición y rotación en Ik\n" +
						--"	handPos.active = 4\n" +
						"	thigh.rotation.controller.active = 4\n" +
						"	calf.rotation.controller.active = 4\n" +
						"	foot.rotation.controller.active = 4\n" +
						"	instep.rotation.controller.active = 4\n" +
						"	toeCap.rotation.controller.active = 4\n" +
						"	toeCapPivot.rotation.controller.active = 3\n" +
						
						"\n" +
						
						"	-- Control de Locks para Ik\n" +
						"	setTransformLockFlags thigh #{1..6,8..9}\n" +
						"	setTransformLockFlags calf #{1..6,8..9}\n" +
						"	setTransformLockFlags foot #{7..9}\n" +
						"	setTransformLockFlags toeCapPivot #{1..3,7..9}\n" +
						
						"\n" +
						
						"	-- Cambio de nombre del boton Fk-Ik\n" +
						
						")\n" +
						"\n" +
						
						"if fkik.value == 0 and (thigh.rotation.controller.active != 3) then\n" +
						
						"(\n" +
						
						"	-- Controlador activo para posición y rotación en Fk\n" +
						"	thigh.rotation.controller.active = 3\n" +
						"	calf.rotation.controller.active = 3\n" +
						"	foot.rotation.controller.active = 3\n" +
						"	instep.rotation.controller.active = 3\n" +
						"	toeCap.rotation.controller.active = 3\n" +
						
						"\n" +
						
						"	-- Control de Locks para Fk\n" +
						"	setTransformLockFlags calf #{1..5,8..9}\n" +
						"	setTransformLockFlags thigh #{1..3,8..9}\n" +
						"	setTransformLockFlags foot #{1..3,7..9}\n" +
						"	setTransformLockFlags instep #{1..3,7..9}\n" +
						"	setTransformLockFlags toeCap #{1..3,7..9}\n" +
						
						"\n" +
						"	-- Cambio de nombre del boton Ik-Fk\n" +
						")\n" +
						"\n" +
						"[ 0, 0, 0 ]"	
					)-- script texto				
				)
				
				--//////////////////////////-- FLOAT EXPRESSION -////////////////////////// --
				(
					
					-- Movimientos predefinidos del pie por Float Expressions:
					-- FootRoll
					_floatExpr = this.ikNodes.pivotFootHeel.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_Expression()
					_floatExpr.AddScalarTarget "footBoneRot" this.animNodes.foot.rotation.controller[#Zero_IK_Controller][#Z_Rotation].controller
					_floatExpr.setExpression "if (footBoneRot > 0, footBoneRot, 0)"
					
					-- Punta/Talón Giro atras
					_floatExpr = this.ikNodes.pivotFootHeel.rotation.controller[#Zero_Euler_XYZ][#Y_Rotation].controller = Float_Expression()
					_floatExpr.AddScalarTarget "footBoneRot" this.animNodes.foot.rotation.controller[#Zero_IK_Controller][#Y_Rotation].controller
					_floatExpr.setExpression "footBoneRot"
					
					-- Punta/Talón Giro Adelante
					_floatExpr = this.ikNodes.instepHLP.rotation.controller[#Zero_Euler_XYZ][#Z_Rotation].controller = Float_Expression()
					_floatExpr.AddScalarTarget "footBoneRot" this.animNodes.foot.rotation.controller[#Zero_IK_Controller][#Z_Rotation].controller
					_floatExpr.setExpression "if (footBoneRot < 0, footBoneRot, 0)"
					
					-- Pivote Lateral Interior
					_floatExpr = this.ikNodes.pivotInside.rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller = Float_Expression()
					_floatExpr.AddScalarTarget "footBoneRot" this.animNodes.foot.rotation.controller[#Zero_IK_Controller][#X_Rotation].controller
					_floatExpr.setExpression "if (footBoneRot > 0, footBoneRot, 0)"
					
					-- Pivote Lateral Interior
					_floatExpr = this.ikNodes.pivotOutside.rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller = Float_Expression()
					_floatExpr.AddScalarTarget "footBoneRot" this.animNodes.foot.rotation.controller[#Zero_IK_Controller][#X_Rotation].controller
					_floatExpr.setExpression "if (footBoneRot < 0, footBoneRot, 0)"
	
				)
				
			)-- CREACIÓN DE POINT SCRIPT
			
			----------------------------------------------------
			--ORDENACIÓN DE EJES
			----------------------------------------------------
			(
				--*****************/RIG/******************** --
				this.animNodes.foot.rotation.controller[#Zero_IK_Controller].controller.axisOrder = 1
				this.animNodes.foot.rotation.controller[#Zero_FK_Controller].controller.axisOrder = 1
				
				--*****************/IK/******************** --
				this.ikNodes.footSHP.transform.controller[#Rotation].controller[#Zero_Euler_XYZ].controller.axisorder = 1
			)--ORDENACIÓN DE EJES
			
			-------------------------------------------------------
			-- CREACION DE ANIMTRACKS
			-------------------------------------------------------
			(
				_sepTransform = #(#(#separator, "Separator01", false, "Transform"))
				_sep = #(#(#separator, "Separator01", false, ""))
				_sepLeg = #(#(#separator, "Separator01", false, "Leg_Controls"))
				_sepIk = #(#(#separator, "Separator01", false, "IK_Controls"))
				_sepFk = #(#(#separator, "Separator01", false, "FK_Controls"))
				_sepAutoStrech = #(#(#separator, "Separator01", false, "AutoStrech_IK"))
					
				--*****************/RIG/******************** --						
				-- Thight
				lb.animInfo.setAnimTracks this.animNodes.thigh (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.thigh.rotation.controller[#Zero_FK_Controller] #all) + _sep + #(#(this.animNodes.thigh[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
					
				-- Calf
				lb.animInfo.setAnimTracks this.animNodes.calf (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.calf.rotation.controller[#Zero_FK_Controller] #z ) + _sep + #(#(this.animNodes.calf[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
					
				-- Foot de posición para el offset en Ik
				lb.animInfo.setAnimTracks this.animNodes.foot (_sepTransform + _sepIk + (lb.rig.solutions.prepareAnimTracks this.animNodes.foot.position.controller[#Zero_IK_Controller] #all) + _sep + (lb.rig.solutions.prepareAnimTracks this.animNodes.foot.rotation.controller[#Zero_IK_Controller] #all) + _sepFk + (lb.rig.solutions.prepareAnimTracks this.animNodes.foot.rotation.controller[#Zero_FK_Controller] #all) + _sep) 
			
				-- ToeCap
				lb.animInfo.setAnimTracks this.animNodes.toeCap (_sepTransform + _sepIk + (lb.rig.solutions.prepareAnimTracks this.animNodes.toeCap.rotation.controller[#Zero_IK_Controller] #all) + _sep + _sepFk + (lb.rig.solutions.prepareAnimTracks this.animNodes.toeCap.rotation.controller[#Zero_FK_Controller] #all)) 
						
				-- ToeCapPivot
				lb.animInfo.setAnimTracks this.animNodes.toeCapPivot (_sepTransform + _sepIk + (lb.rig.solutions.prepareAnimTracks this.animNodes.toeCapPivot.rotation.controller[#Zero_IK_Controller] #all)) 
					
				--*****************/IK/******************** --
				-- FootSHP
				lb.animInfo.setAnimTracks this.ikNodes.footSHP (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.ikNodes.footSHP.position.controller[#Zero_Pos_XYZ] #all) + _sep + (lb.rig.solutions.prepareAnimTracks this.ikNodes.footSHP.rotation.controller[#Zero_Euler_XYZ] #all)) 
				lb.animInfo.setAnimTracks this.ikNodes.kneeSHP (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.ikNodes.kneeSHP.position.controller[#Zero_Pos_XYZ] #all)) 
					
				-- Control de fkIk
				lb.animInfo.setAnimTracks this.ikNodes.fkIkSHP (_sepLeg + #(#(this.ikNodes.fkIkSHP[#Modified_Object][#Leg_Controls].custAttributes[#fkIkSnaps][#fkik], "Modified_Object:Leg_Controls:custAttributes[#fkIkSnaps]:fkik", true, "FkIk", 1)) + _sep +  _sepAutoStrech + #(#(this.ikNodes.fkIkSHP[#Modified_Object][#Leg_Controls].custAttributes[#autoStrechIK][#autoStrech], "Modified_Object:Leg_Controls:custAttributes[#autoStrechIK]::autostrech", true, "AutoStrech_IK", 0)))
				
				-- Cambiamos el valor por defecto el control de FkIk a 0	
				this.ikNodes.fkIkSHP.modifiers[#Leg_Controls].fkIk = 1
				
				--*****************/BB/******************** --	
				--BreakKnee
				lb.animInfo.setAnimTracks this.bbNodes.breakKneeSHP (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.bbNodes.breakKneeSHP.position.controller[#Zero_Pos_XYZ] #all)) 
				
				-- Quitamos los locks en los pesos del pointContraint para evitar fallos de creación de claves con el Cbox
				lb.animation.setlocks this.ikNodes.footSHP.position.controller[#Weights][#Weight__PC_pointConstraint] false
				lb.animation.setlocks this.ikNodes.kneeSHP.position.controller[#Weights][#Weight__PC_pointConstraint] false
				lb.animation.setlocks this.bbNodes.breakKneeSHP.position.controller[#Weights][#Weight__PC_pointConstraint] false	
					
				lb.animation.setlocks this.ikNodes.footSHP.rotation.controller[#Weights][#Weight__OC_pointConstraint] false
				lb.animation.setlocks this.ikNodes.kneeSHP.rotation.controller[#Weights][#Weight__OC_pointConstraint] false
				lb.animation.setlocks this.bbNodes.breakKneeSHP.rotation.controller[#Weights][#Weight__OC_pointConstraint] false	
			)-- CREACION DE ANIMTRACKS
			
			-------------------------------------------------------
			-- CAPAS, LOCKS DE EJES DE PIEZAS, VIRTUAL PARENTS,  Y PROPIEDADES, 
			-------------------------------------------------------
			(
				-- Array para almacenar los nodos creados.
				_chrNodes = (lb.rig.getAllChildren this.animNodes.legSolutionHLP) + this.animNodes.legSolutionHLP + _base
				
				(	
					--*****************/CAPAS/******************** --
					(
						if (LayerManager.getLayer 1) == undefined then _chrLayer = lb.layer.newAssetLayer "chrName" else _chrLayer = (LayerManager.getLayer 1)
						
						lb.layer.activeLayer _chrLayer
						
						-- Renombramos los objetos a la capa chrName y los añadimos.
						for o in _chrNodes do 
						(
							o.name = lb.nc.replaceNamePart o.name 2 "chrName"
							_chrLayer.addNode o
						)
								
						-- Borramos la capa antiguo del esqueleto de rig
						LayerManager.deleteLayerByName "chr_animEdit"
					)
				)
				
				--*****************/LOCKS DE EJES DE PIEZAS/******************** --
				(
					-- Por defecto bloqueamos todos los ejes de todas las piezas, para después ir desbloqueando las piezas que queremos animar.
					_Pos = #{4..9}
					_Rot = #{1..3,7..9}
					_Sca = #{1..6}
					_PosRot = #{7..9}
					
					for o in _chrNodes where (getTransformLockFlags o).isEmpty do
						setTransformLockFlags o #all
					
					-- Grupo de piezas que liberamos solo la posición.
					setTransformLockFlags this.ikNodes.kneeSHP _Pos
					setTransformLockFlags this.bbNodes.breakKneeSHP _Pos
					
					-- Grupo de piezas que liberamos solo la rotación.
					setTransformLockFlags this.animNodes.thigh #{1..3,8..9}
					setTransformLockFlags this.animNodes.calf #{1..3,8..9}
					
					setTransformLockFlags this.animNodes.toeCap _Rot
					setTransformLockFlags this.animNodes.toeCapPivot _Rot
					
					-- Grupo de piezas que liberamos solo la posición y rotación
					setTransformLockFlags this.ikNodes.footSHP _PosRot
					
					-- Grupo de piezas que liberamos solo la rotación.
					setTransformLockFlags _base #none
				)

				--*****************/VIRTUAL PARENTS/******************** --
				(
					lb.rig.linkVirtualParent #(this.animNodes.foot) this.animNodes.calf
					
					lb.rig.linkVirtualParent #(this.animNodes.instep) this.animNodes.foot					
					lb.rig.linkVirtualParent #(this.animNodes.toeCap) this.animNodes.foot
					
					lb.rig.linkVirtualParent #(this.ikNodes.footSHP) _base
					lb.rig.linkVirtualParent #(this.ikNodes.kneeSHP) this.ikNodes.fkIkSHP
					
					lb.rig.linkVirtualParent #(this.bbNodes.breakKneeSHP) this.ikNodes.fkIkSHP

				)
				
				--*****************/PROPIEDADES/******************** --
				(
					_chrNodes.showFrozenInGray = false
					_chrNodes.renderable = false
		
					clearSelection()
				)
				
				-------------------------------------------------------
				-- SELECTION SETS, 
				-------------------------------------------------------
				(
					-- Montamos el nombre del selectionset de la cabeza-cuello, spine, pelvis, y root.
					_filterName = filterString this.animNodes.thigh.name "_"
					_selSetLegName = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] +"_" + _filterName[4] + "_leg"
				
					-- Añadimos las piezas a su selection set correspondiente.
					_objectSet = #(this.animNodes.thigh, this.animNodes.calf, this.animNodes.foot, this.animNodes.toeCap, this.animNodes.toeCapPivot, this.ikNodes.fkIkSHP, this.ikNodes.kneeSHP, this.ikNodes.footSHP, this.ikNodes.footSHP, this.bbNodes.breakKneeSHP)
					
					lb.objectsets.add _objectSet _selSetLegName	
				)-- SELECTION SETS. 

				-------------------------------------------------------
				-- CREACIÖN DE DYNCONNECTION
				-------------------------------------------------------
				(
					_rootNode = (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + lb.nc.NC_ANIM_root + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag)
					_pelvis = (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + lb.nc.NC_ANIM_pelvis + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag)
					_baseNodeName = lb.nc.replaceNamePart _base.name 2 "chrName"
					
					lb.dynConnect.addAttribute this.ikNodes.footPosRefHLP 
					lb.dynConnect.addTarget this.ikNodes.footPosRefHLP  #link _baseNodeName connectOnLoad:false keepInitialOffset:true
					
					lb.dynConnect.addAttribute this.animNodes.legSolutionHLP 
					lb.dynConnect.addTarget this.animNodes.legSolutionHLP #link _pelvis alternateTargetNodes:#(_rootNode, _base) connectOnLoad:false keepInitialOffset:true
					
					lb.dynConnect.addAttribute this.animNodes.legStructureHLP
					lb.dynConnect.addTarget this.animNodes.legStructureHLP #orientationConstraint _rootNode alternateTargetNodes:#(_base) connectOnLoad:false keepInitialOffset:true
				)-- LOCKS DE PIEZAS Y PROPIEDADES
			)
		), -- fn createConnections

		------------------------------------------------
		--COMMON
		------------------------------------------------
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@opt: string | side | Lado del cual queremos crear la solucion.
		------------------------------------------------
		fn create editRoot side:lb.nc.NC_locationLeft =
		(
			-- Le pasamos el lado del brazo para crear la solución necesaria.
			this.side = side

			undo off
			(
				-- Obtenemos los huesos de skin para más tarde crear las cadenas de huesos de fkIk.
				_legTemp = editRoot.solutionInfo.params.createBones()

				lb.rig.solutions.createFkIkChains _legTemp chainType:#anim
				lb.rig.solutions.createFkIkChains _legTemp chainType:#fk
				lb.rig.solutions.createFkIkChains _legTemp chainType:#ik
				lb.rig.solutions.createFkIkChains _legTemp chainType:#bb
							
				-- Rellenamos el struct de la solución con las piezas que se han creado del duplicado.
				this.fillStructNodes()
				
				this.createConnections side
-- 				this.connectSolution()
				
				lb.rig.solutions.addSolutionInfo this.animNodes.legSolutionHLP (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string)) solutionParameters 1.0
				
				delete _legTemp
				gc()
			)	
		),				

		------------------------------------------------
		--@fn: boolean | remove | Elimina la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn remove solutionRoot =
		(

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
			lb.rig.solutions.addSolution this --añade la solución a la principal
		)
		
	)--rs_template
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rsa_fkikLeg() --crea la libreria
)