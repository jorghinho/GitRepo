------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de animación de brazo de fkIk
------------------------------------------------------------------------------------------------------------------------------------------------
(	
-- 	_def = (custAttributes.getDef $.modifiers[1].fkIkSnaps)	
	
	CA_fkIkTail = attributes fkIkSnaps --redefine:_def
	(
		-- Parametros Ca
		parameters main rollout:rollFkIk
		(
			-- Controles
			fkik type:#float ui:(snpFkIk, sldFkIk)
			
			--Lado de cadena
			side type:#string
			
			-- Cadena de Fk
			fkTailBones type:#maxObjectTab tabSizeVariable:true
			
			-- Cadena Anim
			fkIkSHP type:#maxObject
			animTailBones type:#maxObjectTab tabSizeVariable:true
			
			--Cadena de Ik
			ikTailBones type:#maxObjectTab tabSizeVariable:true
			ikTailShp type:#maxObjectTab tabSizeVariable:true
			ikMainShp type:#maxObjectTab tabSizeVariable:true
			ikSecShp type:#maxObjectTab tabSizeVariable:true
		)

		-----------------------------------------------------------------------------------------------------------
		-- Funciones de snap de ik a fk. Se alinea la cadena de fk (foreArm y upperArm) con la cadena de ik.
		-----------------------------------------------------------------------------------------------------------
		fn fkIkSnap = 
		(
			_tailSolution = (lb.rig.solutions.getSolutions name:"fkIkTail")[1]
			
			if fkIkSHP.node.modifiers[#Tail_Controls].fkik.controller.value > 0 then
				_tailSolution.ikToFkSnap fkIkSHP
			else
				_tailSolution.fkToIkSnap fkIkSHP
		)
		
		-----------------------------------------------------------------------------------------------------------
		-- Funcion que sirve para alinear las cadenas de fkIk sin cambiar el valor 
		-----------------------------------------------------------------------------------------------------------
		fn fkIkMatch = 
		(
			_tailSolution = (lb.rig.solutions.getSolutions name:"fkIkTail")[1]
			
			-- Ik to Fk
			if fkIkSHP.node.modifiers[#Tail_Controls].fkik.controller.value > 0 then
				_tailSolution.ikToFkSnap fkIkSHP matchChain:true
			else -- Fk to Ik
				_tailSolution.fkToIkSnap fkIkSHP matchChain:true
		)
		
		------------------------------------------------------------------------------
		----------------------------Rollout --------------------------------------
		------------------------------------------------------------------------------
		rollout rollFkIk "Tail Controls"
		(
			spinner snpFkIk "FK_IK" range:[0,1,1]
			slider sldFkIk "" range:[0,1,1]
			
			button btnFkIkSnap "Ninguno" pos:[3,80] width:155 height:30 
			button btnFkIkMatch "Match Ik and Fk" pos:[3,120] width:155 height:30
			
			--------------------------------------------------
			---------- Eventos del custAttribute-----
			--------------------------------------------------
			on rollFkIk open do
			(
				if fkIkSHP.node.modifiers[#Tail_Controls].fkik > 0 then
					btnFkIkSnap.caption = "Ik to Fk"
				else
					btnFkIkSnap.caption = "Fk to Ik"
			)
			
			--------------------------------------------------
			-- Boton para hacer el snap de fkik
			--------------------------------------------------
			on btnFkIkSnap pressed do
			(
				undo "Fk/Ik Snap" on
					fkIkSnap()
				completeRedraw()
			)--on btn	
			
			--------------------------------------------------
			-- Botón para hacer el match de las cadenas de fkIk
			--------------------------------------------------
			on btnFkIkMatch pressed do
			(
				undo "Match Fk and Ik" on
					fkIkMatch()
				completeRedraw()
			)--on btn	
			
		)--rollout 
	)--CA
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strAnimNodes | Contiene las piezas de anim de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strAnimNodes
	(
		tailBones				= undefined				-- Nodo de bb del upperArm.
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strFkNodes | Contiene las piezas de fk de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strFkNodes
	(
		tailBones				= undefined				-- Nodo de bb del upperArm.
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strIkNodes | Contiene las piezas de ik de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strIkNodes
	(
		tailBones				= undefined				-- Nodo de bb del upperArm.
	)	
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strBbNodes | Contiene las piezas de breakBones de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strBbNodes
	(
		tailBones				= undefined				-- Nodo de bb del upperArm.
	)	
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rsa_fkIkArm | Contiene la solución de animación
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rsa_fkikTail
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),					--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),		--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #tail,						--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #anim,					--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		connectionId = #extra,		--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,								--@var: index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de animación de cola de fkIk",										--@var: description | Descripcion de la libreria.
		
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
		bbNodes   					= strBbNodes(),				--@var: bbNodes | Nodos de la cadena de hueso de bb.
		
		rigNodesAll 				= #(),						--@var: rigNodesAll | Nodos de todos los objetos de la cadena de rig.
		fkNodesAll					= #(),						--@var: fkNodesAll | Nodos de todos los objetos de la cadena de fk.
		ikNodesAll					= #(),						--@var: ikNodesAll | Nodos de todos los objetos de la cadena de ik.
		bbNodesAll					= #(),						--@var: bbNodesAll | Nodos de todos los objetos de la cadena de bb.
		
		fkIkTailCA					= CA_fkIkTail,
		
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
		--------------------------
		-- Funciones de snap de fk a ik. Se alinea la cadena de ik (ikhand y ikElbow) con el final de 
		-- la cadena de huesos de fk y el punto de refenrecia del brazo para el swiverAngle de la ik.
		-- Establecemos valor 1 del spinner de fkIk y controlamos la selección de las piezas.
		--------------------------
		fn fkToIkSnap fkIkNode matchChain: false =
		(	
			_fkIkNode = fkIkNode.node.modifiers[1]
			_sleepTime = 0.1
			
			if matchChain then
			(
				-- Mostramos las cadenas de fkIk para la función de match y que se tenga refencia de que se han snapeado las cadenas.
				for o in _fkIkNode.fkTailBones do o.node.isHidden = false
				for o in _fkIkNode.ikTailBones do o.node.isHidden = false
					
				-- Pausamos la ejecución durante 1 segundo para ver su estado original.
				sleep _sleepTime
			)
									-- Alineación de fkNodes con el ikNodes
			for i = 1 to _fkIkNode.fkTailBones.count do
			(
				_getNamePart = lb.nc.getNamePart _fkIkNode.fkTailBones[i].node.name 5
				_getNamePartFilter = filterString  _getNamePart "-"
				_nameToFind = _getNamePartFilter[1] + "-" + "ik" + "-" + _getNamePartFilter[3] + "-" + _getNamePartFilter[4] 
				
				-- Buscamos 
				for j = 1 to _fkIkNode.ikMainShp.count do
				(
					_getIkNamePart = lb.nc.getNamePart _fkIkNode.ikMainShp[j].node.name 5
					_getIkNamePartFilter = filterString  _getIkNamePart "-"
					_nameIkToFind = _getIkNamePartFilter[1] + "-" + _getIkNamePartFilter[2]  + "-" + _getIkNamePartFilter[3] + "-" + _getIkNamePartFilter[4] 
					
					if _nameIkToFind == _nameToFind then
						_fkIkNode.ikMainShp[j].node.transform = _fkIkNode.fkTailBones[i].node.transform
				)
			)
			
			-- Alineación de ikSecNodes a fkNodes
			for i = 1 to _fkIkNode.fkTailBones.count do
			(
				_getNamePart = lb.nc.getNamePart _fkIkNode.fkTailBones[i].node.name 5
				_getNamePartFilter = filterString  _getNamePart "-"
				_nameToFind = _getNamePartFilter[1] + "-" + "ik" + "-" + _getNamePartFilter[3] + "-" + _getNamePartFilter[4] 
				
				-- Buscamos 
				for j = 1 to _fkIkNode.ikSecShp.count do
				(
					_getIkNamePart = lb.nc.getNamePart _fkIkNode.ikSecShp[j].node.name 5
					_getIkNamePartFilter = filterString  _getIkNamePart "-"
					_nameIkToFind = _getIkNamePartFilter[1] + "-" + _getIkNamePartFilter[2]  + "-" + _getIkNamePartFilter[3] + "-" + _getIkNamePartFilter[4] 
					
					if _nameIkToFind == _nameToFind then
						_fkIkNode.ikSecShp[j].node.transform = _fkIkNode.fkTailBones[i].node.transform
				)
			)

				
			-- Resetemos la escala a 1 para evitar que se nos de la vuelta al alinearlo conla transformaciñon, ya que los objetos tiene esalas distinas.
			for o in _fkIkNode.ikTailShp do
			(
				o.node.scale.controller[#Zero_Scale_XYZ].controller.value = [1,1,1]
				o.node.scale = [1,1,1]

			)

			if matchChain then
			(
				completeRedraw()
				
				for o in _fkIkNode.fkTailBones do o.node.isHidden = true
				for o in _fkIkNode.ikTailBones do o.node.isHidden = true
				
				sleep _sleepTime
			)
			
			_fkIkNode.fkIkSHP.node.modifiers[#Tail_Controls].autostrech = 0.0
			
			if not matchChain then
			(
				_fkIkNode.fkIkSHP.node.modifiers[#Tail_Controls].fkik = 1.0
-- 				select _fkIkNode.ikHandSHP.node
			)
			
			
			
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
				completeRedraw()
				
				-- Mostramos las cadenas de fkIk para la función de match y que se tenga refencia de que se han snapeado las cadenas.
				for o in _fkIkNode.fkTailBones do o.node.isHidden = false
				for o in _fkIkNode.ikTailBones do o.node.isHidden = false

				-- Pausamos la ejecución durante 1 segundo para ver su estado original.
				sleep _sleepTime
			)
			
			-- Alineación de fkNodes con el ikNodes
			for i = 1 to _fkIkNode.fkTailBones.count do
				_fkIkNode.fkTailBones[i].node.transform = _fkIkNode.ikTailBones[i].node.transform	
			
			if matchChain then
			(
				completeRedraw()
				
				sleep _sleepTime

				for o in _fkIkNode.fkTailBones do o.node.isHidden = true
				for o in _fkIkNode.ikTailBones do o.node.isHidden = true
			)
			
			if not matchChain then
			(
				_fkIkNode.fkIkSHP.node.modifiers[#Tail_Controls].fkik = 0.0
				
				-- Control de selección.
-- 				if selection[1] != _fkIkNode.ikHandSHP.node then		
-- 					select selection
-- 				else
-- 					select _fkIkNode.hand.node
-- 				
-- 				if selection[1] == _fkIkNode.bbBreakElbowSHP.node then
-- 					select _fkIkNode.forearm.node

			)
		),
		
		------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Función para rellenar los arrays y nodos de la solución "strRigSolutionArmFkIk". Busca en la escena todos los huesos de tipo rig
		-- para ir rellenando los nodos de RIG, FK, IK, y sus variables dependientes de cada uno.
		------------------------------------------------------------------------------------------------------------------------------------------------------
		fn fillStructNodes =
		(
		), -- fn fillStructNodes
		
		------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Función para crear constraints, conexiones de rig y la solución en si.
		-- PART: puede valer #SPINE, #ARM, #LEG, - indica la parte que queremos obtener
		-- SIDE: puede valer lb.nc.NC_locationLeft, lb.nc.NC_locationRight lb.nc.NC_locationMiddle
		------------------------------------------------------------------------------------------------------------------------------------------------------
		fn createConnections side = 
		(			
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
	
	rsa_fkikTail() --crea la libreria
)