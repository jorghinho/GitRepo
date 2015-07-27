------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de animación de pierna de fkIk_simple.
------------------------------------------------------------------------------------------------------------------------------------------------
(		
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
	struct rsa_fkikLeg_simple
	(
		------------------------------------------------------------------------------------------------
		-- COMMON
		------------------------------------------------------------------------------------------------
		solutionParameters = lb.rig.solutions.params,						--@var | self | Almacena el ca especifico de la solución.
		
		def = (classof this),												--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #leg,													--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #anim,												--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,										--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,																			--@var: index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de animación de pierna de fkIk_simple",							--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		self = undefined,	--@var | self | Almacena la definición del struct.
		selfFile = "",		--@var | selfFile | Almacena la ruta del propio archivo de script que contiene la definición.
		
		side						= lb.nc.NC_locationLeft,
		
		animNodes 					= strAnimNodes(),			--@var: animNodes | Nodos de la cadena de hueso de rig.
		fkNodes						= strFkNodes(),				--@var: fkNodes | Nodos de la cadena de hueso de fk.
		ikNodes						= strIkNodes(),				--@var: ikNodes | Nodos de la cadena de hueso de ik.
		AnimEditNodes 				= strAnimEditNodes(),		--@var: AnimEditNodes | Nodos de la cadena de hueso de bb.
		
		rigNodesAll 				= #(),						--@var: rigNodesAll | Nodos de todos los objetos de la cadena de rig.
		fkNodesAll					= #(),						--@var: fkNodesAll | Nodos de todos los objetos de la cadena de fk.
		ikNodesAll					= #(),						--@var: ikNodesAll | Nodos de todos los objetos de la cadena de ik.
		
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
						)
						
						-- Filtramos para rellenar los arrays con las piezas indicadas, ya sea de fk, ik o de rig
						-- Captura todos los nodos de fk
						if (findstring _filterParts[5] "fk" != undefined) then						
							append this.fkNodesAll o
						
						-- Captura todos los nodos de ik
						if (findstring _filterParts[5] "ik" != undefined) then						
							append this.ikNodesAll o	
						
						-- Captura todos los nodos de rig
						if (findstring _filterParts[5] "ik" == undefined) and (findstring _filterParts[5] "fk" == undefined) then						
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
							
				--*****************************************************************************/--IK--/*****************************************************************************--
				-- Creamos el point de referencia "footPosRef" que nos servirá como virtualParent (linkConstraint) de la plantilla de ik y de referencia para la orientación. 
				this.ikNodes.footPosRefHLP = lb.rig.createPointFromObj this.animNodes.calfEnd

				-- Cambia sus propiedas de color, nombre y tamaño.
				this.ikNodes.footPosRefHLP.name = lb.nc.replaceNamePart this.ikNodes.footPosRefHLP.name 5 "footPosRefIk"
				this.ikNodes.footPosRefHLP.name = lb.nc.replaceNamePart this.ikNodes.footPosRefHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.ikNodes.footPosRefHLP.size = 15 * _baseAnimEdit.scale[1]
				this.ikNodes.footPosRefHLP.wirecolor = red

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
							delete o--this.ikNodes.pivotInside	= o	
-- 						
						"pivotOutside":
							delete o--this.ikNodes.pivotOutside	= o	
-- 						
						"pivotFootHeel":
							delete o--this.ikNodes.pivotFootHeel	= o	
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

			)-- MERGEO DE SHAPES DE CONTROL
			
			-------------------------------------------------------
			-- CREACIÓN DE CONEXIONES DE PIERNA
			-------------------------------------------------------
			(
				-- Renombramos el objeto a foot ya que va a ser el unico que tengamos al final del proceso
				this.animNodes.instep.name = this.animNodes.foot.name 
				
				--*****************************************************************************/--IK--/*****************************************************************************--
				--Emparentamos al legsolutionParent
				this.ikNodes.footPosRefHLP.rotation = quat 0 0 0 0
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
				lb.controller.freezeTransform _kneeParent #all
				
				-- Emparentamos el helper con la base
				this.animNodes.footParentHLP.parent = this.animNodes.legSolutionParentHLP
				lb.controller.freezeTransform this.ikNodes.footPosRefHLP #all
				
				-- Invertimos el eje para hacer la simetria del control que está emparentado a este objeto y manejarlo en el CBox
				If side == lb.nc.NC_locationRight then
				(
					_kneeParent.scale.controller[#Frozen_scale].controller.value = [-1,-1,-1]
					in coordSys local (rotate _kneeParent (eulerAngles 0 180 0))
						
					this.ikNodes.footPosRefHLP.scale.controller[#Frozen_scale].controller.value = [-1,-1,-1]
				)
				
				lb.controller.freezeTransform _kneeParent #all	
				lb.controller.freezeTransform this.ikNodes.footPosRefHLP #all	

				-- Creamos el point que será el padre de la mano del codo para hacer la simetria del control que está emparentado a este objeto y manejarlo en el CBox
				_kneeParent.transform = this.animNodes.calf.transform
				
				-- Ahora que ya tenemos creado el toeCapPivotHLP emparentamos el kneeparent a el, para que vaya
				-- por defecto el knee con el movimiento del pie.
				lb.controller.setActiveController _kneeParent #all #frozen 
				_kneeParent.parent = this.ikNodes.footSHP
				lb.controller.freezeTransform _kneeParent #all
				
				-- Alineamos el control del swivelAngle con el kneeParent para colocarlo donde lo necesitamos. Emparentamos  y freezeamos.
				this.ikNodes.kneeSHP.transform = _kneeParent.transform
				this.ikNodes.kneeSHP.parent = _kneeParent
				
				lb.controller.freezeTransform this.ikNodes.kneeSHP #all	
					
				-- Creamos sistema de ik y asignamos control de swivelAngle.
				_legIkGoal = IKSys.ikChain this.animNodes.thigh this.animNodes.calfEnd "IKHISolver"
				
				-- Renombramos, emparentamos, freezeamos y añadimos el target del swivelAngle.
				_legIkGoal.name = this.animNodes.calfEnd.name
				_legIkGoal.name = lb.nc.replaceNamePart _legIkGoal.name 5 "legIkGoal"
				_legIkGoal.name = lb.nc.replaceNamePart _legIkGoal.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				_legIkGoal.transform.controller.dispGoal = on
				_legIkGoal.controller.goalSize = 15 * _baseAnimEdit.scale[1] 
				
				_legIkGoal.controller.useVHTarget = true
				_legIkGoal.controller.VHTarget = this.ikNodes.kneeSHP

				_legIkGoal.transform = this.animNodes.calfEnd.transform
				lb.controller.freezeTransform _legIkGoal #all	
								
				--*****************************************************************************/--RIG--/*****************************************************************************--
 				-- Dependiendo del lado que sea le indicamos que se mueva en valor negativo o positivo en el eje y.
				If side == lb.nc.NC_locationLeft then
				(
					in coordSys local (rotate _kneeParent (eulerAngles 0 90 180 ))
					in coordSys local move _kneeParent [0,-(distance this.animNodes.thigh this.animNodes.calfEnd),0]	
				)
				else if side == lb.nc.NC_locationRight then
				(
					in coordSys local (rotate _kneeParent (eulerAngles 0 90 180))
					in coordSys local move _kneeParent [0,-(distance this.animNodes.thigh this.animNodes.calfEnd),0]

				)
				
				lb.controller.freezeTransform _kneeParent #all
				lb.controller.freezeTransform this.animNodes.footParentHLP #all

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

				-- Emparentamiento de thigh de Rig al "legStructureHLP" y pelvis al "legStructureHLP"
				this.animNodes.thigh.parent = this.animNodes.legStructureHLP
				lb.controller.freezeTransform this.animNodes.thigh #all
				
				-- Emparentamiento del instep con el foot
				this.animNodes.instep.parent = this.animNodes.footParentHLP
				lb.controller.freezeTransform this.animNodes.instep #all
				
				delete this.animNodes.foot

 				-- Añadimos constraint de posición al hueso final del foot para que cuando se mueva no tenga doble transformación la mano.
				lb.rig.addConstraint this.animNodes.footParentHLP #Pos this.animNodes.calfEnd "PC_rigCalfEnd" keepInitOffset: true
				
 				-- Añadimos constraint de posición al hueso final del calf para que cuando se mueva no tenga doble transformación la mano.
				lb.rig.addConstraint this.animNodes.footParentHLP #Rot this.ikNodes.footSHP "OC_rigCalfEnd" keepInitOffset: true



			)-- CREACIÓN DE CONEXIONES
			
			--///////////////////////////////////////////////////////////////////////////////////////////////////--CREACION DE FOOT--///////////////////////////////////////////////////////////////////////////////////////////////////--
			(
				---------------------------------------------------------
				--CREACIÓN DE HUESOS AUXILIARES DEL PIE
				----------------------------------------------------------
				(					
				)--CREACIÓN DE HUESOS AUXILIARES DEL PIE	
				
				------------------------------------------------------------
				--CREACIÓN DE HELPERS AUXILIARES DE PIE
				-----------------------------------------------------------------
				(

				)--CREACIÓN DE HELPERS AUXILIARES DE PIE
				
				-------------------------------------------------------
				-- CREACIÓN DE CONEXIONES DE PIE
				-------------------------------------------------------	
				(					
					--*****************************************************************************/--IK--/*****************************************************************************-			ll
					-- Emparentamos la ik de la pierna al pivote centrl para poder rotar del el pie y hacer el footRoll.
					lb.controller.setActiveController _legIkGoal #all #Frozen
					_legIkGoal.parent = this.ikNodes.footSHP
					lb.controller.setActiveController _legIkGoal #all #Zero
				)	
			)
			--///////////////////////////////////////////////////////////////////////////////////////////////////--FINAL CREACION DE FOOT--///////////////////////////////////////////////////////////////////////////////////////////////////--
			-------------------------------------------------------------------------------
			-- CREACIÓN DE CUSTOMS ATTRIBUTES Y WIREPARAMETERS
			-------------------------------------------------------------------------------
			(
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
				)
				
				--//////////////////////////-- FLOAT EXPRESSION -////////////////////////// --
				(
				)
			)-- CREACIÓN DE POINT SCRIPT
			
			----------------------------------------------------
			--ORDENACIÓN DE EJES
			----------------------------------------------------
			(
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
					
				--*****************/RIG/******************** --
				-- Thight
				lb.animInfo.setAnimTracks this.animNodes.thigh _sep
					
				-- Calf
				lb.animInfo.setAnimTracks this.animNodes.calf _sep
					
				-- ToeCap
				lb.animInfo.setAnimTracks this.animNodes.toeCap (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.toeCap.rotation.controller[#Zero_Euler_XYZ] #all))
					
				-- Instep	
				lb.animInfo.setAnimTracks this.animNodes.instep (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.instep.rotation.controller[#Zero_Euler_XYZ] #all))
						
				--*****************/IK/******************** --
				-- FootSHP
				lb.animInfo.setAnimTracks this.ikNodes.footSHP (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.ikNodes.footSHP.position.controller[#Zero_Pos_XYZ] #all) + _sep + (lb.rig.solutions.prepareAnimTracks this.ikNodes.footSHP.rotation.controller[#Zero_Euler_XYZ] #all)) 
				lb.animInfo.setAnimTracks this.ikNodes.kneeSHP (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.ikNodes.kneeSHP.position.controller[#Zero_Pos_XYZ] #all)) 		
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
					
					-- Grupo de piezas que liberamos solo la rotación.
					setTransformLockFlags this.animNodes.thigh #{1..3,8..9}
					setTransformLockFlags this.animNodes.calf #{1..3,8..9}
					setTransformLockFlags this.animNodes.instep _Rot
					
					setTransformLockFlags this.animNodes.toeCap _Rot
-- 					setTransformLockFlags this.animNodes.toeCapPivot _Rot
					
					-- Grupo de piezas que liberamos solo la posición y rotación
					setTransformLockFlags this.ikNodes.footSHP _PosRot
					
					-- Grupo de piezas que liberamos solo la rotación.
					setTransformLockFlags _base #none
				)

				--*****************/VIRTUAL PARENTS/******************** --
				(
					lb.rig.linkVirtualParent #(this.animNodes.instep) this.animNodes.calf
					lb.rig.linkVirtualParent #(this.ikNodes.footSHP) _base
					lb.rig.linkVirtualParent #(this.ikNodes.kneeSHP) this.ikNodes.footSHP
					
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
					_objectSet = #(this.animNodes.thigh, this.animNodes.calf, this.animNodes.toeCap, this.animNodes.instep, this.ikNodes.kneeSHP, this.ikNodes.footSHP)
					
					lb.objectsets.add _objectSet _selSetLegName	
				)-- SELECTION SETS. 
				
				-------------------------------------------------------
				-- CREACIÖN DE DYNCONNECTION
				-------------------------------------------------------
				(
					_rootNode = (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + lb.nc.NC_ANIM_root + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag)
					_pelvis = (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + lb.nc.NC_ANIM_pelvis + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag)

					lb.dynConnect.addAttribute this.animNodes.legSolutionHLP 
					lb.dynConnect.addTarget this.animNodes.legSolutionHLP #link _pelvis alternateTargetNodes:#(_rootNode, _base) connectOnLoad:false keepInitialOffset:true
					
					lb.dynConnect.addAttribute this.animNodes.legStructureHLP
					lb.dynConnect.addTarget this.animNodes.legStructureHLP #orientationConstraint _rootNode alternateTargetNodes:#(_base) connectOnLoad:false keepInitialOffset:true
				)-- LOCKS DE PIEZAS Y PROPIEDADES
			)-- LOCKS DE PIEZAS Y PROPIEDADES
		), -- fn createConnections
		
		------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Función para conectar solución
		-- OBJ: Objeto con el cual queremos que se emparente la solución. Sino 
		------------------------------------------------------------------------------------------------------------------------------------------------------
		fn connectSolution parent:undefined =
		(
			-- Comprobamos que el objeto que le pasamos existe, sino es asi, emparentamos con la spine03.
			-- Sino no exisitera la spine03 lo emparentamos a la base.
			if parent != undefined then
			(
				-- Activamos el frozen y emparentamos para no perder el zero.
				lb.controller.setActiveController this.animNodes.legStructureHLP #all #frozen 
				this.animNodes.legSolutionHLP.parent = parent
				lb.controller.setActiveController this.animNodes.legStructureHLP #all #zero 
			)
			else
			(
				-- Capturamos la spine de la escena.
				_obj = (lb.rig.getAnimNode lb.nc.NC_ANIM_pelvis)[1]
				_root = (lb.rig.getAnimNode lb.nc.NC_ANIM_root)[1]
				
				-- Si no existe la spine lo enganchamos a la base.
				if _obj == undefined then
					_obj = (lb.rig.solutions.getBaseNode())

				-- Le ponemos el virtualParent a la palvis, si esta la spine a esta, y sino a la base.		
				lb.rig.linkVirtualParent #(this.animNodes.thigh) _obj
						
				-- Enganchamos los padres de estructura de brazos al root para que todo el persona se mueva en conjunto.
				-- cuando rotamos el root.
				if _root != undefined then
					lb.rig.addConstraint this.animNodes.legStructureHLP #Rot _root "OC_Root" keepInitOffset: true
				else
					lb.rig.addConstraint this.animNodes.legStructureHLP #Rot _obj "OC_Root" keepInitOffset: true

				-- Activamos el frozen y emparentamos para no perder el zero.
				lb.controller.setActiveController (this.animNodes.legStructureHLP) #all #frozen
				this.animNodes.legSolutionHLP.parent = _obj
				lb.controller.setActiveController this.animNodes.legStructureHLP #all #zero
				
				
				lb.controller.freezeTransform this.animNodes.legStructureHLP #all
			)--if parent
		), --fn connectSolution
		
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
-- 				lb.rig.solutions.createFkIkChains _legTemp chainType:#fk
-- 				lb.rig.solutions.createFkIkChains _legTemp chainType:#ik
							
				-- Rellenamos el struct de la solución con las piezas que se han creado del duplicado.
				this.fillStructNodes()
				
				this.createConnections side
				
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
	
	rsa_fkikLeg_simple() --crea la libreria
)