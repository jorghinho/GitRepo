------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de pierna de edición de fkIk
------------------------------------------------------------------------------------------------------------------------------------------------
(		
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rse_standardLeg | Contiene la solución del brazo de anim.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rse_standardLeg
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #leg,					--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #AnimEdit,				--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,							--@var: index | Indice para ordenar
		
		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de pierna de rig de ediciíon fkIk",							--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		solutionParameters = lb.rig.solutions.params,
		solutionInfo = lb.rig.solutions.solutionInfo,
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
		------------------------------------------------
		fn createAuxChain nodes root excludeIndexBones:false =
		(
			-- Array donde guaradaremos todos los bons creados.
			_AnimEditBones = #()
			
			-- Base del personaje si existe
			_base = lb.rig.solutions.getBaseNode type:#AnimEdit
			
			-- Variables para guardar los helpers del rig de edición, para construir los huesos.
			_thighHLP = undefined
			_calfHLP = undefined
			_instepHLP = undefined
			_toeCapHLP = undefined
			_toeCapPivotHLP = undefined
			_toesHLP = #()
			
			-- Variables para guardar los huesos  genereados, del rig de edición.
			_thighBON = undefined
			_calfBON = undefined
			_instepBON = undefined
			_toeCapBON = undefined
			_toesBON = #()
			
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
							"thigh": _thighHLP = o.node
							
							"calf": _calfHLP = o.node
							
							"instep": _instepHLP = o.node
							
							"toeCap": _toeCapHLP = o.node
							
							"toeCapPivot": _toeCapPivotHLP = o.node
						)--case p of

					)--for
					
					-- Buscamos los inicios de jerarquias de los dedos del pie para añadirlos al array de hlps toes y luego crearlos
					if not excludeIndexBones then 
						if (matchPattern p pattern:"toe*0") then append _toesHLP o
					
				)--for p in _namePart do 
			)--for o in
			
			-- Creamos la cadena de huesos y cambiamos de nombre.
			(
				-- THIGH, 
				_thighBON = lb.rig.createNewBone _thighHLP.pos _calfHLP.pos _thighHLP
				_thighBON.name = _thighHLP.name
				_thighBON.transform = _thighHLP.transform
				_thighBON.scale = [1,1,1]
				
				
				lb.nc.replaceNamePart _thighBON.name 7 lb.nc.NC_frozenFlag

				append _AnimEditBones _thighBON
				
				-- CALF
				_calfBON = lb.rig.createNewBone _calfHLP.pos _instepHLP.pos _calfHLP
				_calfBON.name = _calfHLP.name
				_calfBON.transform = _calfHLP.transform
				_calfBON.scale = [1,1,1]
				
				lb.nc.replaceNamePart _calfBON.name 7 lb.nc.NC_frozenFlag
				
				-- Corregimos la orientación del tight con el hueso del calf, añadiendole un lookAt para y después emparentamos el calf al tight.
				lb.controller.freezeTransform _thighBON #all
				
				_thighBON.rotation.controller.available.controller = LookAt_Constraint()
				_thighBON.rotation.controller[3].controller.appendTarget _calfBON 100
				_thighBON.rotation.controller[3].controller.upnode_world = false
				_thighBON.rotation.controller[3].controller.pickUpNode = _calfBON
-- 				 
				_bckpTransform = _thighBON.transform 
-- 				 
				lb.controller.freezeTransform _thighBON #all
				_thighBON.transform = _bckpTransform 
-- 				 
				_calfBON.parent = _thighBON
				
				append _AnimEditBones _calfBON
				
				-- INSTEP
				_instepBON = lb.rig.createNewBone _instepHLP.pos _toeCapHLP.pos _instepHLP
				_instepBON.name = _instepHLP.name
				
				if root.node.solutionInfo.solutionSide == lb.nc.NC_locationRight then
				(
					_auxHLP = lb.rig.createPointFromObj _instepBON
					_instepBON.parent = _auxHLP
					
					delete _auxHLP
				)
				
				_instepBON.parent = _calfBON
				
				lb.nc.replaceNamePart _instepBON.name 7 lb.nc.NC_frozenFlag
				
				append _AnimEditBones _instepBON
			
				-- TOECAP
				_toeCapBON = lb.rig.createNewBone _toeCapHLP.pos _toeCapPivotHLP.pos _toeCapHLP
				
				_toeCapBON.name = _toeCapHLP.name
				_toeCapBON.transform = _toeCapHLP.transform
				_toeCapBON.scale = [1,1,1]
				
				if root.node.solutionInfo.solutionSide == lb.nc.NC_locationRight then
				(
					_auxHLP = lb.rig.createPointFromObj _instepBON
					_toeCapBON.parent = _auxHLP
					_toeCapBON.rotation.controller.z_rotation = _toeCapBON.rotation.controller.z_rotation + 180
					
					delete _auxHLP
				)
				
				-- Ajustamos la orientación del toeCap segun el final del esqueleto de edición.
-- 				lb.controller.freezeTransform _toeCapBON #all
-- 				
-- 				_toeCapBON.rotation.controller.available.controller = LookAt_Constraint()
-- 				_toeCapBON.rotation.controller[3].controller.appendTarget _toeCapPivotHLP 100
-- 				_toeCapBON.rotation.controller[3].controller.upnode_world = false
-- 				_toeCapBON.rotation.controller[3].controller.pickUpNode = _toeCapPivotHLP
--  				 
-- 				_bckpTransform = _toeCapBON.transform 
 				 
-- 				print _bckpTransform
				
-- 				lb.controller.freezeTransform _toeCapBON #all
				
-- 				_toeCapBON.transform = _bckpTransform 
				
				_toeCapBON.parent = _instepBON
				
				lb.nc.replaceNamePart _toeCapBON.name 7 lb.nc.NC_frozenFlag
				
				append _animEditBones _toeCapBON
				
				_toeCapEndTEMPBon = lb.rig.smartCreateEnd _toeCapBON
				
				-- TOES
				-- Creamos los huesos y los emparentamos con el hueso toeCap.
				for h in _toesHLP do _toesBON += (lb.rig.createBonesFromHierarchy h.node boneParent:_toeCapBON)
			)
			
			(
				-- Hacemos un fix del ikPlane para terminar de corregir el angulo y que no falle después en el snap.
				lb.rig.fixIKplane _thighBON  _instepBON
				lb.rig.fixIKplane _instepBON _toeCapEndTEMPBon
							
  				-- Flipeamos los ejes ya que al resetear el plano de ik se cambian.
 				-- Invertimos el eje x a valor -1 para poder utilizar la funcionalidad de simetria del rig.
				if root.node.solutionInfo.solutionSide == lb.nc.NC_locationRight then
				(
					-- Array para guardar los nodos padres de los huesos.
					_bckpParents = #()

					-- Desemparentamos para poder operar con ejes y evitar offsets.
					for _b in _AnimEditBones do
					(				
						lb.controller.setActiveController _b #all #Frozen
						append  _bckpParents _b.parent					
						_b.parent = undefined	
					)
					
					-- Hacemos flipeo de ejes e invertimos la escala
					lb.rig.flipAxis #(_thighBON,_calfBON) true true false
					lb.rig.flipVis #(_thighBON,_calfBON) false true false

					lb.rig.flipAxis #(_instepBON,_toeCapBON) true false true
					lb.rig.flipVis #(_instepBON,_toeCapBON) true false false
					
					select _AnimEditBones
					selection.objectOffsetScale = [-1,1,1]
					
					for i = 1 to _AnimEditBones.count do
						_AnimEditBones[i].parent = _bckpParents[i]	
					
-- 					
				)
				else
 				(
					lb.rig.flipAxis #(_instepBON,_toeCapBON) false true true
					lb.rig.flipVis #(_instepBON,_toeCapBON) false false true
				)
 				
				delete _toeCapEndTEMPBon
			)

			-- Cambio de propiedades de tamaño, y emparentamientos
			(
				-- THIGH
				-- Multiplicamos un tamaño por defecto de huesos para si escalamos el personaje se mantenga.
				_AnimEditBones.width = (2 * _base.scale[1])
				_AnimEditBones.height = (2 * _base.scale[1])
				_AnimEditBones.taper = 90
				
 				-- FINGERS
				_toesBON.taper = 90
				_toesBON.width = (1.5 * _base.scale[1])
				_toesBON.height = (1.5 * _base.scale[1])
				
				-- Sumamos todos los objetos a un solo array
				_AnimEditBones = _AnimEditBones + _toesBON
				
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
			for _b in _AnimEditBones do 
			(
				lb.controller.freezeTransform _b #all
				
				_b.scale.controller[1].controller.value = [1,1,1]
				_b.scale.controller[2].controller.value = [1,1,1]
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
			
			custAttributes.add solutionRoot solutionInfo #unique baseobject:false
			
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
		
	)--rse_standardLeg
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rse_standardLeg() --crea la libreria
)