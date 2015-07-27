------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de animación de brazo de fkIk_simple
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strAnimNodes | Contiene las piezas de anim de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strAnimNodes
	(
		armSolutionHLP			= undefined,				-- Helper del cual colgará toda la estructura
		armStructureHLP			= undefined,				-- Helper del cual colgará toda la estructura
		armSolutionParentHLP	= undefined,				-- Helper del cual colgará toda la estructura
		clavicle 				= undefined,				-- Nodo de rig de la clavicula.
		clavicleEnd  			= undefined,				-- Nodo de rig del hueso end de la clavicula.
		upperarm 				= undefined,				-- Nodo de rig del upperArm.
		forearm					= undefined,				-- Nodo de rig del forearm.
		forearmEnd				= undefined,				-- Nodo de rig del final forearm.
		hand 					= undefined,				-- Nodo de rig de la mano.
		handOffsetHLP			= undefined,				-- Nodo de rig de la mano.
		handParentHLP			= undefined,				-- Nodo de rig padre de la mano
		fingers					= #(),						-- Nodos de los dedos de la mano.
		fingersEnd				= #()						-- Nodos de los dedos de la mano.
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strFkNodes | Contiene las piezas de fk de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strFkNodes
	(
		upperarm				= undefined,				-- Nodo de fk del upperArm.
		forearm 				= undefined,				-- Nodo de fk del forearm.
		hand 					= undefined,				-- Nodo de fk de la mano.
		refElbowIKHLP 			= undefined					-- Nodo de fk de referencia para la alineación del control de ik.
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strIkNodes | Contiene las piezas de ik de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strIkNodes
	(
		upperarm 				= undefined,				-- Nodo de ik de la mano.
		forearm 				= undefined,				-- Nodo de ik de la forearm.
		hand 					= undefined,				-- Nodo de ik de la mano.
		handPosRefHLP			= undefined,				-- Nodo de ik que sirve de padre del shape de la mano.
		ikGoalParentHLP			= undefined,				-- Nodo de rig padre de la ik.
		fkIkSHP					= undefined,				-- Conmutador de fkIk.
		handSHP 				= undefined,				-- Nodo de tipo shape de la mano.
		elbowSHP 				= undefined					-- Nodo de tipo shape del codo.
	)	
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rsa_fkIkArm | Contiene la solución de animación
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rsa_fkikArm_simple
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),					--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),		--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #arm,						--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #anim,					--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		connectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,								--@var: index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de animación de brazo de fkIk_simple",						--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		solutionParameters = lb.rig.solutions.params, 							--@var | self | Almacena el ca especifico de la solución.
		
		self = undefined,										--@var | self | Almacena la definición del struct.
		selfFile = "",											--@var | selfFile | Almacena la ruta del propio archivo de script que contiene la definición.
		
		side						= lb.nc.NC_locationLeft,
		
		animNodes 					= strAnimNodes(),			--@var: animNodes | Nodos de la cadena de hueso de rig.
		fkNodes						= strFkNodes(),				--@var: fkNodes | Nodos de la cadena de hueso de fk.
		ikNodes						= strIkNodes(),				--@var: ikNodes | Nodos de la cadena de hueso de ik.
		
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
			this.animNodes.fingers = #()
			this.animNodes.fingersEnd = #()
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
							"clavicle": this.animNodes.clavicle = o
							"upperarm": this.animNodes.upperarm = o
							"forearm": this.animNodes.forearm = o
							"hand": this.animNodes.hand = o
							
							-- Para  obtener todas los dedos  indexadas.
							default:
							(
								if (matchpattern _filterParts[5] pattern:"finger??" != false) then
									append this.animNodes.fingers o
							
								if (matchpattern _filterParts[5] pattern:"finger??End" != false) then
									append this.animNodes.fingersEnd o
							)
							
							"upperarmFk": this.fkNodes.upperarm = o
							"forearmFk": this.fkNodes.forearm = o
							"handFk": this.fkNodes.hand = o
							
							"upperarmIk": this.ikNodes.upperarm = o
							"forearmIk": this.ikNodes.forearm = o
							
							"handIk": this.ikNodes.hand = o
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
			)-- for o
			
			this.animNodes.fingers = lb.misc.sortNodesByName this.animNodes.fingers
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
			_rootNode = lb.rig.solutions.getRootNode()
			_spine03 = getNodeByName (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_spine03_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag)

			----------------------------------------------------
			--CREACIÓN DE HUESOS AUXILIARES
			----------------------------------------------------
			(
				--*****************/ANIM/******************** --
				-- Creamos el final de la cadena del hueso de la clavicula de la cadena de rig, que nos servirá para mantener la orientación del brazo con el root, aunque rotemos la clavicula.
				this.animNodes.clavicleEnd = lb.rig.smartCreateEnd this.animNodes.clavicle
				this.animNodes.clavicleEnd.name = lb.nc.replaceNamePart this.animNodes.clavicleEnd.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				-- Creamos el final de la cadena del hueso del forearm de la cadena de rig, que nos servirá para mantener la orientación de la mano con la cruceta de ik.
				this.animNodes.forearmEnd = lb.rig.smartCreateEnd this.animNodes.forearm
				this.animNodes.forearmEnd.name = lb.nc.replaceNamePart this.animNodes.forearmEnd.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				-- Borramos los dedos finales ya que en esta versión no se utiliza el strech.
				delete this.animNodes.fingersEnd
				this.animNodes.fingersEnd = #()
				
			)--CREACIÓN DE HUESOS AUXILIARES
			
			----------------------------------------------------
			--CREACIÓN DE HELPERS AUXILIARES
			----------------------------------------------------
			(
				--*****************/ANIM/******************** --
				-- Creamos el armSolutión, que es de donde colgará toda la solución de la estructura y llevará almacenada la información de versión de la solución.
				this.animNodes.armSolutionHLP = lb.rig.createPointFromObj this.animNodes.clavicle
				
				-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
				this.animNodes.armSolutionHLP.name = lb.nc.replaceNamePart this.animNodes.armSolutionHLP.name 5 "arm-solution-root"
				this.animNodes.armSolutionHLP.name = lb.nc.replaceNamePart this.animNodes.armSolutionHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.armSolutionHLP.size = 15 * _baseAnimEdit.scale[1]
				this.animNodes.armSolutionHLP.cross = false
				this.animNodes.armSolutionHLP.wirecolor = red
			
				-- Creamos el armSolutiónParent, que es de donde se emparentanran objetos que no van directamente emparentados al armSolution y tienen dependencia con la base.
				-- Este point llevara un pos y rot constraint con la base, para puentear las piezas que dependen de esta misma. También situado el punto de pivote en la base.
				this.animNodes.armSolutionParentHLP = lb.rig.createPointFromObj this.animNodes.clavicle
				this.animNodes.armSolutionParentHLP.name = lb.nc.replaceNamePart this.animNodes.armSolutionParentHLP.name 5 "arm-solution-parent"
				this.animNodes.armSolutionParentHLP.name = lb.nc.replaceNamePart this.animNodes.armSolutionParentHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.armSolutionParentHLP.size = 10 * _baseAnimEdit.scale[1]
				this.animNodes.armSolutionParentHLP.cross = false
				this.animNodes.armSolutionParentHLP.wirecolor = yellow		
				
				-- Creamos el armStructure, que es donde irán emparentadas las cadenas de huesos para evitar la rotación de la clavicula.
				this.animNodes.armStructureHLP = lb.rig.createPointFromObj this.animNodes.upperArm
					
				-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
				this.animNodes.armStructureHLP.name = lb.nc.replaceNamePart this.animNodes.armStructureHLP.name 5 "armStructure"
				this.animNodes.armStructureHLP.name = lb.nc.replaceNamePart this.animNodes.armStructureHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.armStructureHLP.size = 7 * _baseAnimEdit.scale[1]
				
				If side == lb.nc.NC_locationLeft then
					this.animNodes.armStructureHLP.wirecolor = blue
				else if side == lb.nc.NC_locationRight then
					this.animNodes.armStructureHLP.wirecolor = green

			)--CREACIÓN DE HELPERS AUXILIARES
			
			----------------------------------------------------
			-- MERGEO Y CREACIÍON DE SHAPES DE CONTROL
			----------------------------------------------------
			(
			)-- MERGEO DE SHAPES DE CONTROL
			
			-------------------------------------------------------
			-- CREACIÓN DE CONEXIONES
			-------------------------------------------------------
			(				
				--*****************/ANIM/******************** --
				-- Freezeado de "armSolutionHLP", y emparentamiento a la base. 
				this.animNodes.armSolutionHLP.parent = _base
				lb.controller.freezeTransform this.animNodes.armSolutionHLP #all
				
				-- Freezeado de "armSolutionParentHLP",  emparentamiento al armSolutionHLP,
				-- cambiamos su pivote al de la base y añadimos constraint de rot y pos.
				this.animNodes.armSolutionParentHLP.parent = this.animNodes.armSolutionHLP
				this.animNodes.armSolutionParentHLP.pivot = _base.pos
				WorldAlignPivot this.animNodes.armSolutionParentHLP
				lb.controller.freezeTransform this.animNodes.armSolutionParentHLP #all	
									
				-- Freezeado de "armStructureHLP", el cual llevará un orientationConstraint al root,
				-- para que cuando se mueva la clavicula no se oriente, pero si cuando se rota el root.
				this.animNodes.armStructureHLP.parent = this.animNodes.armSolutionHLP
				lb.controller.freezeTransform this.animNodes.armStructureHLP #all
				
				lb.rig.addConstraint this.animNodes.armStructureHLP #Pos this.animNodes.clavicleEnd "PC_ClavicleEnd" keepInitOffset: true
				
				-- Emparentamiento de upperArm de Rig al "armStructureHLP" y clavicula al "armSolutionHLP"
				this.animNodes.upperArm.parent = this.animNodes.armStructureHLP
				lb.controller.freezeTransform this.animNodes.upperArm #all
				
				this.animNodes.clavicle.parent = this.animNodes.armSolutionHLP
				lb.controller.freezeTransform this.animNodes.clavicle #all
				
				this.animNodes.hand.parent = this.animNodes.foreArm
				
				lb.controller.freezeTransform this.animNodes.hand #all
								
				-- Creamos un hlp por cada huesos de la mano interior a partir del 3.
				_herarchies = lb.rig.getHierarchiesFromNodes this.animNodes.fingers
				_auxHLPS = #()
				
				-- Generación de helpers a partir de la cuarta falange, ya que sabemos siempre se va a generar desde ese punto la rotación progresiva.
				for i = 4 to  _herarchies.count where _herarchies[i][1] != undefined do
				(
					-- Creación de point y cambios de propiedas
					_auxHLP = (lb.rig.createPointFromObj _herarchies[i][1])
					_auxHLP.wirecolor = blue
					_auxHLP.cross = false
					_auxHLP.size = 2.5 * _baseAnimEdit.scale[1]
					
					-- Emparentamiento de hueso a hlp.
					lb.controller.setActiveController (_herarchies[i][1]) #all #frozen
					_herarchies[i][1].parent = _auxHLP
					lb.controller.setActiveController (_herarchies[i][1]) #all #zero
					
					-- Emparentamiento del helper al hueso anterior para generar jerarquia.
					_auxHLP.parent = _herarchies[i-1][1]
					
					lb.controller.freezeTransform _auxHLP #all
					
					-- Hacemos instancia del hueso al siguiente point para hacer la rotación aditiva.
					_auxHLP.rotation.controller.available.controller =  _herarchies[i-1][1].rotation.controller[#Zero_Euler_XYZ].controller
					_auxHLP.rotation.controller.setName _auxHLP.rotation.controller.count ("Instance_" + (lb.nc.getNamePart _herarchies[i-1][1].name 5))
						
					-- Nombramos el helper correctamente.
					_filterName = lb.nc.getNamePart _herarchies[i][1].name 5
					_auxHLP.name = lb.nc.replaceNamePart _auxHLP.name 5 (_filterName + "-hlp-parent")
					lb.nc.setFlags _auxHLP #(lb.nc.NC_frozenFlag, lb.nc.NC_hiddenFlag) 
					append _auxHLPS _auxHLP
				)
				
				-- Instanciamos de la 3 falange a todos los point empezando por el segundo, ya que el primero ya se ha instanciado anteriormente.
				for i = 2 to _auxHLPS.count do
				(					
					_auxHLPS[i].rotation.controller.available.controller =  _herarchies[3][1].rotation.controller[#Zero_Euler_XYZ].controller
					_auxHLPS[i].rotation.controller.setName _auxHLPS[i].rotation.controller.count ("Instance_" + (lb.nc.getNamePart _herarchies[3][1].name 5))
				)				
			)-- CREACIÓN DE CONEXIONES
			
			-------------------------------------------------------------------------------
			-- CREACIÓN DE CUSTOMS ATTRIBUTES Y WIREPARAMETERS
			-------------------------------------------------------------------------------
			(
				
			)-- CREACIÓN DE POINT SCRIPT
			
			----------------------------------------------------
			--ORDENACIÓN DE EJES
			----------------------------------------------------
			(
				--*****************/RIG/******************** --
				this.animNodes.clavicle.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 2
				this.animNodes.upperArm.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 1
				this.animNodes.hand.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 4
				
				for b in this.animNodes.fingers do
					b.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 4
			)--ORDENACIÓN DE EJES

			
			-------------------------------------------------------
			-- CREACION DE ANIMTRACKS
			-------------------------------------------------------
			(
				_sepTransform = #(#(#separator, "Separator01", false, "Transform"))
				_sep = #(#(#separator, "Separator01", false, ""))
				_sepArm = #(#(#separator, "Separator01", false, "Arm_Controls"))
				_sepFingerInfluence = #(#(#separator, "Separator01", false, "Influence_finger20"))
				_sepAutoStrech =  #(#(#separator, "Separator01", false, "AutoStrech_IK"))
				_sepIk = #(#(#separator, "Separator01", false, "IK_Controls"))
				_sepFk = #(#(#separator, "Separator01", false, "FK_Controls"))
					
				--*****************/ANIM/******************** --
				-- Clavicula
				lb.animInfo.setAnimTracks this.animNodes.clavicle (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.clavicle.rotation.controller[#Zero_Euler_XYZ] #all))
						
				-- UpperArm
				lb.animInfo.setAnimTracks this.animNodes.upperArm (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.upperArm.rotation.controller[#Zero_Euler_XYZ] #all))
					
				-- ForeArm
				lb.animInfo.setAnimTracks this.animNodes.foreArm (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.foreArm.rotation.controller[#Zero_Euler_XYZ] #z ))
					
				-- Hand de posición para el offset en Ik
				lb.animInfo.setAnimTracks this.animNodes.hand (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.hand.rotation.controller[#Zero_Euler_XYZ] #all)) 
				
				_herarchies = lb.rig.getHierarchiesFromNodes this.animNodes.fingers

				for i = 1 to  _herarchies.count do
				(
					if _herarchies[i][1] != undefined then
						if i != 1 then
							lb.animInfo.setAnimTracks _herarchies[i][1]  (_sepTransform + (lb.rig.solutions.prepareAnimTracks _herarchies[i][1].rotation.controller[#Zero_Euler_XYZ] #all))
						else
							lb.animInfo.setAnimTracks _herarchies[i][1] (_sepTransform + (lb.rig.solutions.prepareAnimTracks _herarchies[i][1].rotation.controller[#Zero_Euler_XYZ] #all ))
					
					if _herarchies[i][2] != undefined then
						if i != 1 then
							lb.animInfo.setAnimTracks _herarchies[i][2] (_sepTransform + (lb.rig.solutions.prepareAnimTracks _herarchies[i][2].rotation.controller[#Zero_Euler_XYZ] #all ))
						else
							lb.animInfo.setAnimTracks _herarchies[i][2] (_sepTransform + (lb.rig.solutions.prepareAnimTracks _herarchies[i][2].rotation.controller[#Zero_Euler_XYZ] #z ))

					for j = 3 to _herarchies[i].count do
						lb.animInfo.setAnimTracks _herarchies[i][j] (_sepTransform + (lb.rig.solutions.prepareAnimTracks _herarchies[i][j].rotation.controller[#Zero_Euler_XYZ] #z ))
				)
			)-- CREACION DE ANIMTRACKS
			
			-------------------------------------------------------
			-- CAPAS, LOCKS DE EJES DE PIEZAS, VIRTUAL PARENTS,  Y PROPIEDADES, 
			-------------------------------------------------------
			(
				-- Array para almacenar los nodos creados.
				_chrNodes = (lb.rig.getAllChildren this.animNodes.armSolutionHLP) + this.animNodes.armSolutionHLP + _base
				
				(	
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
-- 					setTransformLockFlags this.ikNodes.elbowSHP _Pos
					
					-- Grupo de piezas que liberamos solo la rotación.
					setTransformLockFlags this.animNodes.clavicle _Rot
					setTransformLockFlags this.animNodes.hand _Rot
					setTransformLockFlags this.animNodes.upperArm #{1..3,8..9} -- Eje x,y,z Libre
					setTransformLockFlags this.animNodes.forearm #{1..5,8..9} -- Eje x Libre
					setTransformLockFlags this.animNodes.fingers #{1..5,8..9}

					-- Dedos
					-- Creamos animtracks por defecto en todos los dedos y después los cambiamos solo a los que necesiten las tres pistas de rotación.
					_herarchies = lb.rig.getHierarchiesFromNodes this.animNodes.fingers

					for i = 1 to  _herarchies.count do
					(
						if _herarchies[i][1] != undefined then
							setTransformLockFlags _herarchies[i][1] _Rot

						if _herarchies[i][2] != undefined then
							if i != 1 then
								setTransformLockFlags _herarchies[i][2] #{1..3,8..9}
							else
								setTransformLockFlags _herarchies[i][2] #{1..5,8..9}

						for j = 3 to _herarchies[i].count do
							setTransformLockFlags _herarchies[i][j] #{1..5,8..9}
					)
					
					-- Grupo de piezas que liberamos todas las transform.
					setTransformLockFlags _base #none
				)
				
				--*****************/VIRTUAL PARENTS/******************** --
				(
					lb.rig.linkVirtualParent #(this.animNodes.hand) this.animNodes.foreArm
					lb.rig.linkVirtualParent #(this.animNodes.upperArm) this.animNodes.clavicle
						
-- 					_spine03Node = getNodeByName _spine03
					
					if _spine03 != undefined then
						lb.rig.linkVirtualParent #(this.animNodes.clavicle) _spine03				
					else
						lb.rig.linkVirtualParent #(this.animNodes.clavicle) _base	
					
					for i = 3 to this.animNodes.fingers.count do lb.rig.linkVirtualParent #(this.animNodes.fingers[i]) this.animNodes.hand
				)
				
				--*****************/PROPIEDADES/******************** --
				(
					_chrNodes.showFrozenInGray = false
					_chrNodes.renderable = false
					
					clearSelection()
				)
				
				-------------------------------------------------------
				-- OBJECT SETS, 
				-------------------------------------------------------
				(
					-- Montamos el nombre del selectionset de la cabeza-cuello, spine, pelvis, y root.
					_filterName = filterString this.animNodes.upperArm.name "_"
					_selSetArmName = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] +"_" + _filterName[4] + "_arm"
					
					-- Añadimos las piezas a su selection set correspondiente.
					_objectSet = #(this.animNodes.clavicle, this.animNodes.upperArm, this.animNodes.foreArm, this.animNodes.hand /*this.ikNodes.fkIkSHP, this.ikNodes.elbowSHP, this.ikNodes.handSHP, this.bbNodes.breakElbowSHP*/) + this.animNodes.fingers
					lb.objectsets.add _objectSet _selSetArmName					
				)-- SELECTION SETS. 
			)-- LOCKS DE PIEZAS Y PROPIEDADES
			
			-------------------------------------------------------
			-- CREACIÖN DE DYNCONNECTION
			-------------------------------------------------------
			(
				
				lb.dynConnect.addAttribute this.animNodes.armSolutionHLP 
				lb.dynConnect.addTarget this.animNodes.armSolutionHLP #link _spine03.name alternateTargetNodes:#(_rootNode, _base) connectOnLoad:false keepInitialOffset:true
				
				lb.dynConnect.addAttribute this.animNodes.armStructureHLP
				lb.dynConnect.addTarget this.animNodes.armStructureHLP #orientationConstraint _rootNode.name alternateTargetNodes:#(_base) connectOnLoad:false keepInitialOffset:true
				
			)
		), -- fn createConnections
			
		------------------------------------------------
		--COMMON
		------------------------------------------------		
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@opt: string | side | Lado del cual queremos crear la solucion.
		------------------------------------------------
		fn create solutionRoot side:lb.nc.NC_locationLeft =
		(
			-- Le pasamos el lado del brazo para crear la solución necesaria.
			this.side = side
			
			undo off
			(
				-- Obtenemos los huesos de skin para más tarde crear las cadenas de huesos de fkIk.
				_armTemp = solutionRoot.solutionInfo.params.createBones()
				
				lb.rig.solutions.createFkIkChains _armTemp chainType:#anim
-- 				lb.rig.solutions.createFkIkChains _armTemp chainType:#fk
-- 				lb.rig.solutions.createFkIkChains _armTemp chainType:#ik
				
				-- Rellenamos el struct de la solución con las piezas que se han creado del duplicado.
				this.fillStructNodes()
				
				this.createConnections side
				
				lb.rig.solutions.addSolutionInfo this.animNodes.armSolutionHLP (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	 solutionParameters 1.0
				
				delete _armTemp
				gc()
			)
		),			

		------------------------------------------------
		--@fn: boolean | remove | Elimina la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn remove =
		(
			lb.rig.solutions.deleteSolution 
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
		
	)--rsa_fkikArm
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rsa_fkikArm_simple() --crea la libreria
)