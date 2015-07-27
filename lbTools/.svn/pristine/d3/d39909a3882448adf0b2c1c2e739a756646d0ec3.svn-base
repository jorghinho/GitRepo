------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de geometria
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: geometry | Contiene todas las funciones de geometria.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_geometry
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #geometry,				--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de funciones de geometria",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
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
		--@fn: undefined | getSceneObjectsByID | Devuelve los objetos de la escena con el id pasado por parametro
		------------------------------------------------
		fn getSceneObjectsByID id =
		(
			_objsById = #() --array para almacenar los objetos a devolver
			_sceneObjects = ((geometry as array) + (shapes as array))
			
			for obj in _sceneObjects where obj.gbufferChannel == id do append _objsById obj --rellena el array
			
			_objsById --devuelve los objetos con ese ID
		),--fn getSceneObjectsByID

		----------------------------------------------------------------------------------------------------------------
		--devuelve el bounding box de un conjunto de nodos pasados por parametro
		--necesita NODES, un array de nodos
		--necesita REFTRANSFORM, una matriz de transformacion de referencia sobre la que calcular los puntos a devolver
		----------------------------------------------------------------------------------------------------------------
		fn getNodesBoundingBox nodes refTransform =
		(
			_bball = #([0,0,0] , [0,0,0]) --bounding box de todos los objetos
			_bbmin = [1000000, 1000000, 1000000] --limite ficticio minimo
			_bbmax = [-1000000, -1000000, -1000000] --limite ficticio maximo
			
			if classof refTransform != Matrix3 do refTransform = matrix3 1 --se previene de que le pasen un origen de coordenadas no válido
				
			for o in nodes do --recorre los nodos
			(
				--si tiene un FFD devuelve valores erroneos. INVESTIGAR MAS ADELANTE
				_hasFFD = false
				for m in o.modifiers where classof m == FFD_Binding do _hasFFD = true
				
				if not _hasFFD do
				(
					_bb = nodeGetBoundingBox o refTransform --obtiene el bb de cada nodo
					
					--sustituye los puntos maximo y minimo si algun componente del _bb actual es mayor o menor respectivamente
					if _bb[1].x < _bbmin.x do _bbmin.x = _bb[1].x
					if _bb[1].y < _bbmin.y do _bbmin.y = _bb[1].y
					if _bb[1].z < _bbmin.z do _bbmin.z = _bb[1].z
					
					if _bb[2].x > _bbmax.x do _bbmax.x = _bb[2].x
					if _bb[2].y > _bbmax.y do _bbmax.y = _bb[2].y
					if _bb[2].z > _bbmax.z do _bbmax.z = _bb[2].z
					---------------------------------------------------------------------------------------------------------------------
				)
			)--for
			
			--3464100.0 es la dsitancia entre [1000000, 1000000, 1000000] y [-1000000, -1000000, -1000000]
			if distance _bbmin _bbmax < 3464100.0 do _bball = #(_bbmin, _bbmax)
			
			_bball --devuelve el bounding box completo
		),
		
		----------------------------------------------------------------------------------------------------------------
		--devuelve los seis puntos centrales del bounding box pasado por parámetro
		----------------------------------------------------------------------------------------------------------------
		fn getBoundingBoxFaceCenters bb =
		(
			_theFaceCenters = #()
			
			-----------------------------------
			--cara de abajo
			_theFaceCenters[1] = [(bb[1].x + bb[2].x)/2, (bb[1].y + bb[2].y)/2, bb[1].z]
			-----------------------------------
			
			-----------------------------------
			--cara de arriba
			_theFaceCenters[6] = [_theFaceCenters[1].x, _theFaceCenters[1].y, bb[2].z]
			-----------------------------------
			
			-----------------------------------
			--cara y positiva
			_theFaceCenters[2] = [_theFaceCenters[1].x, bb[1].y, (bb[1].z + bb[2].z)/2]
			-----------------------------------
			
			-----------------------------------
			--cara x positiva
			_theFaceCenters[3] = [bb[2].x, _theFaceCenters[1].y, _theFaceCenters[2].z]
			-----------------------------------
			
			-----------------------------------
			--cara y negativa
			_theFaceCenters[4] = [_theFaceCenters[1].x, bb[2].y, _theFaceCenters[2].z]
			-----------------------------------
			
			-----------------------------------
			--cara x negativa
			_theFaceCenters[5] = [bb[1].x, _theFaceCenters[1].y, _theFaceCenters[2].z]
			-----------------------------------
			
			_theFaceCenters
		),
		
		----------------------------------------------------------------------------------------------------------------
		--devuelve los ocho puntos que forman las esquinas del bounding box pasado por parámetro
		----------------------------------------------------------------------------------------------------------------
		fn getBoundingBoxCorners bb offset:0.0 =
		(
			_theFaceCorners = #()
			
			-----------------------------------
			--esquina: abajo, frontal, izquierda
			_theFaceCorners[1] = bb[1]
			-----------------------------------
			
			-----------------------------------
			--esquina: abajo, frontal, derecha
			_theFaceCorners[2] = [bb[2].x, bb[1].y, bb[1].z]
			-----------------------------------
			
			-----------------------------------
			--esquina: abajo, trasera, derecha
			_theFaceCorners[3] = [bb[2].x, bb[2].y, bb[1].z]
			-----------------------------------
			
			-----------------------------------
			--esquina: abajo, trasera, izquierda
			_theFaceCorners[4] = [bb[1].x, bb[2].y, bb[1].z]
			-----------------------------------
			
			-----------------------------------
			--esquina: arriba, frontal, izquierda
			_theFaceCorners[5] = [bb[1].x, bb[1].y, bb[2].z]
			-----------------------------------
			
			-----------------------------------
			--esquina: arriba, frontal, derecha
			_theFaceCorners[6] = [bb[2].x, bb[1].y, bb[2].z]
			-----------------------------------
			
			-----------------------------------
			--esquina: arriba, trasera, derecha
			_theFaceCorners[7] = bb[2]
			-----------------------------------
			
			-----------------------------------
			--esquina: arriba, trasera, izquierda
			_theFaceCorners[8] = [bb[1].x, bb[2].y, bb[2].z]
			-----------------------------------
			
			--si se pide un offset de los puntos hacia fuera del BB o hacia dentro
			if offset != 0 then
			(
				-----------------------------------
				--esquina: abajo, frontal, izquierda
				_theFaceCorners[1].x -= offset
				_theFaceCorners[1].y -= offset
				_theFaceCorners[1].z -= offset
				-----------------------------------
				
				-----------------------------------
				--esquina: abajo, frontal, derecha
				_theFaceCorners[2].x += offset
				_theFaceCorners[2].y -= offset
				_theFaceCorners[2].z -= offset
				-----------------------------------
				
				-----------------------------------
				--esquina: abajo, trasera, derecha
				_theFaceCorners[3].x += offset
				_theFaceCorners[3].y += offset
				_theFaceCorners[3].z -= offset
				-----------------------------------
				
				-----------------------------------
				--esquina: abajo, trasera, izquierda
				_theFaceCorners[4].x -= offset
				_theFaceCorners[4].y += offset
				_theFaceCorners[4].z -= offset
				-----------------------------------
				
				-----------------------------------
				--esquina: arriba, frontal, izquierda
				_theFaceCorners[5].x -= offset
				_theFaceCorners[5].y -= offset
				_theFaceCorners[5].z += offset
				-----------------------------------
				
				-----------------------------------
				--esquina: arriba, frontal, derecha
				_theFaceCorners[6].x += offset
				_theFaceCorners[6].y -= offset
				_theFaceCorners[6].z += offset
				-----------------------------------
				
				-----------------------------------
				--esquina: arriba, trasera, derecha
				_theFaceCorners[7].x += offset
				_theFaceCorners[7].y += offset
				_theFaceCorners[7].z += offset
				-----------------------------------
				
				-----------------------------------
				--esquina: arriba, trasera, izquierda
				_theFaceCorners[8].x -= offset
				_theFaceCorners[8].y += offset
				_theFaceCorners[8].z += offset
				-----------------------------------
			)
			
			_theFaceCorners
		),

		----------------------------------------------------------------------------------------------------------------
		--devuelve TRUE si el punto THEPOINT pasado por parámetro está contenido en el boundingBox THEBOUINDINGBOX pasado por parámetro.
		----------------------------------------------------------------------------------------------------------------
		fn isPointInBoundingBox thePoint theBoundingBox refMatrix:(Matrix3 1) =
		(
			_isInside = true
			
			_p = thePoint
			_bb = deepCopy theBoundingBox
			
			if (refMatrix as string) != ("(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])") then
			(
				_auxMatrix = Matrix3 1
				_auxMatrix.position = _bb[1]
				_bb[1] = (refMatrix * _auxMatrix).position
				_auxMatrix.position = _bb[2]
				_bb[2] = (refMatrix * _auxMatrix).position
			)
			
			if (_p.x > _bb[2].x) or (_p.x < _bb[1].x) or (_p.y > _bb[2].y) or (_p.y < _bb[1].y) or (_p.z > _bb[2].z) or (_p.z < _bb[1].z) then
				_isInside = false
			
			_isInside
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------

		------------------------------------------------
		--OTHER
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | smartResetXform | Hace un reset XForm de la pieza manteniendo los modificadores actuales intactos. KEEPTRANSFORM es un booleano que indica si se quiere mantener la transformación actual del bounding box.
		------------------------------------------------
		fn smartResetXform obj keepTransform = 
		(
			-- Inhabilitamos la solapa Motion del Command Panel para evitar parpadeos
			--suspendEditing which:#modify 
			
			-- Get the original node transform matrix
			local ntm = obj.transform
			
			p = obj.pos
			r = obj.rotation
			
			-- The new object transform only inherits position
			obj.rotation = (quat 0 0 0 1)
			obj.transform=transMatrix obj.pos
			
			-- Compute the pivot transform matrix
			local piv = obj.objecttransform * inverse obj.transform
			
			-- Reset the object offsets to 0
			obj.objectoffsetPos  = [0,0,0]
			obj.objectoffsetRot = (quat 0 0 0 1)
			obj.objectoffsetScale = [1,1,1]
			
			-- Take the position out of the original node transform matrix since we don't reset position
			ntm.translation=[0,0,0]
			
			-- Apply the pivot transform matrix to the modified original node transform matrix
			-- to get the XForm gizmo transform
			ntm = piv * ntm
			
			-- apply an XForm modifier to the node
			local xformMod=xform()
			max modify mode
			modpanel.setCurrentObject obj.baseobject
			modPanel.addModToSelection xformMod
			
			-- set the XForm modifier's gizmo tranform
			xformMod.gizmo.transform=ntm
			
			obj.pos = p
			
			
			maxops.collapsenodeto obj obj.modifiers.count true
			
			-- Rehabilitamos la solapa Motion del Command Panel
			resumeEditing which:#modify 
			
			-- return value of ok
			true
		),

		----------------------------------------------------------------------------------------------------------------
		--crea una caja en función del boundingbox de un conjunto de nodos pasados por parámetro.
		--necesita NODES, el conjunto de nodos a partir del cual crear la caja
		--devuelve la caja creada, si no consigue crearla devuelve undefined
		----------------------------------------------------------------------------------------------------------------
		fn createBoxFromNodes nodes =
		(
			_theBox = undefined
			
			if nodes.count != 0 then --si hay nodos a partir de los cuales crear la caja
			(
				_bb = getNodesBoundingBox nodes undefined --obtiene el boundingBox de todos los nodos en conjunto.
				
				--dimensiones iniciales para la caja
				_width = abs (_bb[1].x - _bb[2].x)
				_length = abs (_bb[1].y - _bb[2].y)
				_height = abs (_bb[1].z - _bb[2].z)
				
				_theBox = box length:_length width:_width height:_height
				_theBox.pos= [(_bb[1].x + _bb[2].x)/2, (_bb[1].y + _bb[2].y)/2, _bb[1].z]
			)
			
			_theBox
		),--createBoxFromNodes
		
		----------------------------------------------------------------------------------------------------------------
		--crea una caja en función del boundingbox pasado por parámetro.
		--necesita THEBOUNDINGBOX, el boundingbox a partir del cual crear la caja
		--devuelve la caja creada, si no consigue crearla devuelve undefined
		----------------------------------------------------------------------------------------------------------------
		fn createBoxFromBoundingBox theBoundingbox boxToUse:undefined refMatrix:(matrix3 1) =
		(
			_theBox = undefined
			
			_bb = theBoundingbox --acorta el nombre de la varaible para simplificar el codigo
			
			--dimensiones iniciales para la caja
			_width = abs (_bb[1].x - _bb[2].x)
			_length = abs (_bb[1].y - _bb[2].y)
			_height = abs (_bb[1].z - _bb[2].z)
			
			_theBox = if isValidNode boxToUse then boxToUse else box()
				
			_theBox.length = _length
			_theBox.width = _width
			_theBox.height = _height
			
			_theBoundingBoxCenter = (_bb[2] + _bb[1])/2.0
			_theBox.transform = refMatrix
			in coordsys refMatrix (_theBox.center = _theBoundingBoxCenter)
			
			_theBox
		),--createBoxFromBoundingBox

		---------------------------------------------------------------------------------------------------------------
		--	Filtro de selección de geometría
		---------------------------------------------------------------------------------------------------------------
		fn meshFilter obj =
		(
			(superClassOf obj == geometryClass) and (obj != $)
		),

		----------------------------------------------------------------------------------------------------------------
		--funcion para invertir las normales de los objetos pasados por parametro
		--si el objeto tiene un modificador de tipo edit_poly o edit_mesh, hace el flip en el
		--sino actua sobre el objeto base
		----------------------------------------------------------------------------------------------------------------
		fn flipNormals nodesToFlip =
		(
			if (classof nodesToFlip == Array) then --si es un array de nodos
			(
				if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode mode:#modify
				
				undo "Flip Normals" on
				(
					--recorre los objetos a los que se puede haer flip
					for obj in nodesToFlip do--where (this.meshFilter obj) do
					(
						changedInModifier = false
						
						i = 1
						while not changedInModifier and i <= obj.modifiers.count do
						(
							if (classof obj.modifiers[i] == Edit_Poly) then
							(
								modPanel.setCurrentObject obj.modifiers[i]
								subobjectLevel = 5
								max select all
								obj.modifiers[i].ButtonOp #FlipFace
								subobjectLevel = 0		
								changedInModifier = true
							)
							
							i += 1
						)
						
						if not changedInModifier then
							if classof obj == Editable_Poly or classof obj == PolyMeshObject then
							(
								modPanel.setCurrentObject obj
								subobjectLevel = 5
								max select all
								obj.EditablePoly.flipNormals 1
								subobjectLevel = 0		
							)
						
					)--for
				)--undo
			)--if
		),

		------------------------------------------------------------------------------------------------
		--@fn: undefined |  changeId  |  Cambia las Ids de los objetos.
		--@gets: node | obj | Pasarle los objetos que se quieren cambiar las Ids.
		--@gets: node | _number | Pasarle el número de Id.
		------------------------------------------------------------------------------------------------
		mapped fn changeMaterialId obj numberId =
		(
			_meshToWork = undefined		--Variable con los objetos con los que vamos a trabajar.
			_hasPuppet = false			--Booleano para marcar los objetos con puppet.
			_success = false			--Booleano para confirmar el cambio de ID.
			
			--Si la base del objeto es diferente a edit_poly revisa si el objeto tiene puppet.
			if classOf obj.baseObject != editable_Poly then	
			(
				for m in obj.modifiers where (findString m.name "Puppet") != undefined do
				(
					_hasPuppet = true
					_meshToWork = m
				)
				
-- 				if obj.modifiers[1] != undefined then 
-- 				(
-- 					_hasPuppet = true	--Si tiene puppet el booleano pasa a true.
-- 					_meshToWork = obj.modifiers[1]	--Rellenamos la variable con el objeto con puppet.
-- 				)
			)
			--Si la base del objeto es igual a edit_Poly.
			else 
				_meshToWork = obj.EditablePoly 		--Rellenamos la variable con el objeto editablePoly.
				
			--Si la variable se rellena con cualquiera de las opciones anteriores.
			if _meshToWork != undefined then
			(
				max modify mode
				
				_backupSelection = getCurrentSelection()  --Variable con la selección.
				select obj
				
				if _hasPuppet then modPanel.setCurrentObject _meshToWork	--Si booleano es true, accede al modificador puppet.			
				
				subobjectLevel = 5
				_numFace = getNumFaces obj	--Número de caras del objeto.
				_meshToWork.setSelection #face #{1..(_numFace)}	--Selección de todas las caras del objeto a nivel de subobjeto. 
					
				if _hasPuppet then
				(				
					_meshToWork.SetOperation #SetMaterial --activa los materiales.
					_meshToWork.materialIDToSet = (numberId-1)	--Cambia el Id del material para los objetos puppet.
				)			
				else
					_meshToWork.setMaterialIndex numberId 1 --Cambia el Id del material para los objetos editable_Poly.
					
				max create mode
				select _backupSelection 	--Devuelve la selección. 
				
				_success = true
			)
			
			_success
		),
		

		------------------------------------------------
		-- redirecciona los proxies
		------------------------------------------------
		fn redirectMrProxies mrProxy sourcePath targetPath =
		(
			if (findString (tolower mrProxy.filename) (tolower sourcePath)) == 1 then
			(
				mrProxy.filename = substituteString (tolower mrProxy.filename) (tolower sourcePath) (tolower targetPath)
			)
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
			
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
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_geometry
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_geometry() --crea la libreria.
)