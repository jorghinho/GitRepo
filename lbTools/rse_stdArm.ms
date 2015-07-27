------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de brazo de edición de fkIk
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rse_standardArm | Contiene la solución del brazo de anim.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rse_standardArm
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #arm,					--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #AnimEdit,				--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,							--@var: index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de brazo de rig de ediciíon fkIk",							--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		solutionParameters = lb.rig.solutions.params,
		
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
				
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: array{nodes} | createSolution | Añadimos la informacion de los nodos de la parte de la solucion para crear el esqueleto de skin, o de rig.
		--@opt: boolean | extraBons | Para indicar si queremos que nos cree todos los huesos incluidos extras
		------------------------------------------------
		fn createAuxChain nodes root excludeIndexBones:false =
		(
			-- Array donde guaradaremos todos los bons creados.
			_AnimEditBones = #()
			
			-- Base del personaje si existe
			_base = lb.rig.solutions.getBaseNode type:#AnimEdit
			
			-- Variables para guardar los helpers del rig de edición, para construir los huesos.
			_clavicleHLP = undefined
			_upperarmHLP = undefined
			_forearmHLP = undefined
			_handHLP = undefined
			_fingersHLP = #()
			
			-- Variables para guardar los huesos  genereados, del rig de edición.
			_clavicleBON = undefined
			_upperarmBON = undefined
			_forearmBON = undefined
			_handBON = undefined
			_fingersBON = #()
			
			
			-- Recorremos los nombres de todos los objetos para filtrar y guardarlo en variables.
			for o in nodes do
			(
				_namePart = filterString o.node.name "_"
				
				for p in _namePart do
				(
					_filterPart5 = filterString _namePart[5] "-"

					for fp in _filterPart5 do
					(
						case fp of
						(
							"clavicle": _clavicleHLP = o.node
							
							"upperarm": _upperarmHLP = o.node
							
							"forearm": _forearmHLP = o.node
							
							"hand": _handHLP = o.node
						)--case p of

					)--for
					
					-- Buscamos los inicios de jerarquias de los dedos para añadirlos al array de hlps finger y luego crearlos
					if not excludeIndexBones then 
						if (matchPattern p pattern:"finger*0") then append _fingersHLP o					
				)--for p in _namePart do 
			)--for o in
			
			
			-- Creamos la cadena de huesos y cambiamos de nombre.
			(
				-- CLAVICLE, 
				_clavicleBON = lb.rig.createNewBone _clavicleHLP.pos _upperarmHLP.pos _clavicleHLP
				_clavicleBON.name = _clavicleHLP.name
				
				lb.nc.replaceNamePart _clavicleBON.name 7 lb.nc.NC_frozenFlag

				append _AnimEditBones _clavicleBON
				
				-- UPPEARM
				_upperarmBON = lb.rig.createNewBone _upperarmHLP.pos _forearmHLP.pos _upperarmHLP
				_upperarmBON.name = _upperarmHLP.name
				_upperarmBON.transform = _upperarmHLP.transform
				
				
				lb.nc.replaceNamePart _upperarmBON.name 7 lb.nc.NC_frozenFlag
				_upperarmBON.parent = _clavicleBON
				
				append _AnimEditBones _upperarmBON
				
				-- FOREARM
				_forearmBON = lb.rig.createNewBone _forearmHLP.pos _handHLP.pos _forearmHLP
				_forearmBON.name = _forearmHLP.name
				_forearmBON.transform = _forearmHLP.transform
				
				_forearmBON.parent = _upperarmBON
				
				lb.nc.replaceNamePart _forearmBON.name 7 lb.nc.NC_frozenFlag
				
				append _AnimEditBones _forearmBON
				
				-- HAND
				_handBON = lb.rig.createNewBone _handHLP.pos _handHLP.pos _handHLP
				_handBON.name = _handHLP.name
				_handBON.transform = _handHLP.transform 
				
				_handBON.parent = _forearmBON
				
				lb.nc.replaceNamePart _handBON.name 7 lb.nc.NC_frozenFlag
			
				_handBON.transform = _handHLP.transform
								
				append _AnimEditBones _handBON
				
				-- FINGERS
				-- Creamos los huesos y los emparentamos con el hueso de la mano.
				for h in _fingersHLP do _fingersBON += (lb.rig.createBonesFromHierarchy h.node) --boneParent:_handBON)
				
				for h in _fingersBON where h.children.count == 0 do
				(				
					_endBone = (lb.rig.smartCreateEnd h)
					
					_endBone.name = lb.nc.replaceNamePart _endBone.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					
					_fingersBON += _endBone
-- 					print h.name
				)
				
				
				_animEditBones = _AnimEditBones + _fingersBON
			)
			
			(
				-- Hacemos un fix del ikPlane para terminar de corregir el angulo y que no falle después en el snap.
				lb.rig.fixIKplane _upperarmBON  _handBON
				
				lb.controller.unFreezeTransform _upperarmBON #all
				lb.controller.unFreezeTransform _forearmBON #all
				lb.controller.unFreezeTransform _handBON #all
				
				-- Flipeamos los ejes ya que al resetear el plano de ik se cambian.
				-- Invertimos el eje x a valor -1 para poder utilizar la funcionalidad de simetria del rig.
				if root.node.solutionInfo.solutionSide == lb.nc.NC_locationRight then
				(
					lb.rig.flipAxis #(_clavicleBON, _upperarmBON,_forearmBON) true true false
					lb.rig.flipVis #(_clavicleBON, _upperarmBON,_forearmBON) false true false
					
					for _b in _fingersBON do
					(
						lb.rig.flipAxis #(_b) true false true
						lb.rig.flipVis #(_b) false false true						
					)						

					
					for _b in _AnimEditBones do
					(				
						_bkpParent = _b.parent					
						_b.parent = undefined	
						
						_b.objectOffsetScale = [-1,1,1]
		
						
						_b.parent = _bkpParent
					)
				)
			)

			-- Cambio de propiedades de tamaño, y emparentamientos
			(
				-- ARM
				-- Multiplicamos un tamaño por defecto de huesos para si escalamos el personaje se mantenga.
				_AnimEditBones.width = (2 * _base.scale[1])
				_AnimEditBones.height = (2 * _base.scale[1])
				_AnimEditBones.taper = 90
				
				-- MANO
				-- Cambiamos el tamaño de la mano ya que es especifico.
				_handBON.taper = 0
				_handBON.width = (6 * _base.scale[1])--lb.math.round (((distance _forearmHLP _handHLP) / 4) * _base.scale[1])
				_handBON.height = (2 * _base.scale[1])--lb.math.round (_handBON.width / 3)
				_handBON.length = (2.5 * _base.scale[1])--lb.math.round (_handBON.width / 2)
				
				-- Restauramos la escala del hueso de la mano.
				_handBON.scale = [1,1,1]
				
				-- FINGERS
				_fingersBON.taper = 90
				_fingersBON.width = (1.5 * _base.scale[1])
				_fingersBON.height = (1.5 * _base.scale[1])
				
-- 				-- Sumamos todos los objetos a un solo array
-- 				_AnimEditBones = _AnimEditBones + _fingersBON
				
				-- Quitamos todas las aletas.
				_AnimEditBones.frontFin = false
				_AnimEditBones.sideFins = false
				_AnimEditBones.backFin = false
			)
						
			-- Cambio de color
			if root.node.solutionInfo.solutionSide == lb.nc.NC_locationLeft then
				_AnimEditBones.wirecolor = (color 0 252 252)
			else
				_AnimEditBones.wirecolor = (color 0 252 0)
			
			-- Freezeamos todas los huesos nuevos y quitamos los sideFins.
			for b in _AnimEditBones do lb.controller.freezeTransform b #all
				
			-- Freezeamos todas los huesos nuevos y quitamos los sideFins.
			for _b in _AnimEditBones do 
			(
				lb.controller.freezeTransform _b #all
				
				_b.scale.controller[1].controller.value = [1,1,1]
				_b.scale.controller[2].controller.value = [1,1,1]
			)
			
			for h in _fingersBON where h.parent == undefined do
			(	
				lb.controller.setActiveController h #all #frozen
				h.parent = _handBON
				lb.controller.setActiveController h #all #zero
			)
			
			_AnimEditBones
		),
		
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn addSolutionInfo solutionRoot =
		(
			if solutionRoot.custAttributes[#solutionInfo] != undefined then 
				custAttributes.delete solutionRoot (custAttributes.getdef solutionRoot.solutionInfo) baseobject:false
			
			custAttributes.add solutionRoot (lb.rig.solutions.ca_solutionInfo()) #unique baseobject:false
			
			custAttributes.add solutionRoot.solutionInfo solutionParameters #unique baseobject:false
			
			-- Rellenamos los parametros expecificos, nombre de solución, y connectionID
			solutionRoot.solutionInfo.solutionName = (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	
			solutionRoot.solutionInfo.connectionId = "anthropomorphic"	
				
			-- Los inicializamos con los parametros que puede rellenar	
			solutionRoot.solutionInfo.init()
			solutionRoot.solutionInfo.params.init()
		),			

		------------------------------------------------
		--@fn: boolean | remove | Elimina la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn create solutionRoot =
		(
			-- Elimina la solución respecto al padre de la solución.
		),
		
		------------------------------------------------
		--@fn: boolean | remove | Elimina la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn remove solutionRoot =
		(
			-- Elimina la solución respecto al padre de la solución.
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
		
	)--rse_standardArm
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rse_standardArm() --crea la libreria
)