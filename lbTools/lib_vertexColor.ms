------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de vertexColor
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de vertexColor.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_vertexColor
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria vertexColor",	--@var: description | Descripcion de la libreria.
		
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
		--SETS
		------------------------------------------------

		----------------------------------------------------------------------------------------------------------------
		-- crea el canal de Vertex Color al objeto OBJ
		----------------------------------------------------------------------------------------------------------------
		fn createVertexColorChannel obj =
		(
			c = classof obj.baseobject
			if c == editable_mesh 	then meshop.setMapSupport obj.baseobject 0 true
			if (c == editable_poly) or (c == PolyMeshObject)	then polyop.setMapSupport obj.baseobject 0 true
		),

		----------------------------------------------------------------------------------------------------------------
		-- devuelve TRUE o FALSE dependiendo de si el objeto OBJ tiene o no canal Vertex Color
		----------------------------------------------------------------------------------------------------------------
		fn hasVertexColorChannel obj =
		(
			hasVC = false
			
			c = classof obj.baseobject
			if c == editable_mesh then hasVC = meshop.getMapSupport obj.baseobject 0
			if (c == editable_poly) or (c == PolyMeshObject) then hasVC = polyop.getMapSupport obj.baseobject 0
			
			hasVC
		),

		----------------------------------------------------------------------------------------------------------------
		-- aplica el color de vértice pasado en COL al vértice o vertices número
		-- INDEX del objeto OBJ.
		--INDEX, puede ser un bitarray
		----------------------------------------------------------------------------------------------------------------
		fn setVertexColor obj index col =
		(
			-- primero nos aseguramos de que el objeto actual tiene soporte para vertex colors
			if not hasVertexColorChannel obj then createVertexColorChannel obj
			
			if hasVertexColorChannel obj then
			(
				c = classof obj.baseobject
				if c == editable_mesh then meshop.setVertColor obj.baseobject 0 index col
				if (c == editable_poly) or (c == PolyMeshObject) then polyop.setVertColor obj.baseobject 0 index col
			)
		),
		
		----------------------------------------------------------------------------------------------------------------
		-- Hace que la suma de colores del vértice VERTINDEX de todos los objetos OBJs
		-- sumado al color COL de blanco puro [255,255,255]. Esta función se usa cuando se
		-- quiere hacer un reparto de vertex colors para morpher.
		----------------------------------------------------------------------------------------------------------------
		fn setMultipleVertexColors OBJs vertIndex col =
		(
			for o in OBJs do
				if not hasVertexColorChannel o then createVertexColorChannel o
			
			objCols = #()
			
			-- recopilamos los colores de cada vértice
			for o in OBJs do append objCols (getVertColor o.mesh vertIndex)
			
			-- calculamos cuánto queda por repartir para cada objeto
			colRest = (color 255 255 255) - col
			
			-- Asignamos los nuevos colores 
			for j = 1 to OBJs.count do
			(
				finalCol = (color 0 0 0)
				finalCol.r = colRest.r / OBJs.count 
				finalCol.g = colRest.g / OBJs.count
				finalCol.b = colRest.b / OBJs.count
				
				setVertexColor OBJs[j] vertIndex finalCol
			)
		),

		------------------------------------------------
		--OTHER
		------------------------------------------------

		----------------------------------------------------------------------------------------------------------------
		-- Indica si los colores de vértice del objeto están normalizados (mismo número de colores 
		-- de vértice que número de vértices en la geometría).
		----------------------------------------------------------------------------------------------------------------
		fn vertexColorsNormalized obj =
		(
			normalized = true
			c = classOf obj.baseobject		
			
			-- solo tratamos el objeto si es un editable poly o editable mesh
			if ((c == editable_mesh) or (c == editable_poly)) and (hasVertexColorChannel obj) then
				normalized = (getNumCPVverts obj.baseobject.mesh == obj.baseobject.mesh.verts.count)
			
			normalized
		),

		----------------------------------------------------------------------------------------------------------------
		-- reinicia los vertex colors del objeto haciendo coincidir los índices de vertex color con
		-- el número de vértices del objeto. El motivo de esta función se puede estudiar en el apartado
		-- 'Understanding Texture Coordinates' de la ayuda de MaxScript.
		-- IMPORTANTE: si hay vértices aislados se eliminarán.
		----------------------------------------------------------------------------------------------------------------
		fn normalizeVertexColors obj noMessages:false =
		(
			vcColors = #()		-- array final de vertex colors
			modifiers = #()		-- modificadores del objeto
			normalized = false	-- indica si se ha realizado la normalización
			
			c = classOf obj.baseobject		
			
			-- si hay vértices aislados pedimos confirmación de continuar porque hay que borrarlos.
			cont  = true
			if (meshop.getIsoVerts obj.mesh).numberset > 0 and not noMessages then
				cont = queryBox "Se encontraron vértices aislados. Normalizar los Vertex Colors los\neliminará, haciendo cambiar el número de vértices del objeto.\n¿Desea continuar?"
			
			-- solo tratamos el objeto si es un editable poly o editable mesh
			if cont and ((c == editable_mesh) or (c == editable_poly)) then
			(
				-- si el objeto es un edit poly lo convertimos a mesh con un modificador sobre el baseobject y lo colapsamos
				if c == editable_poly then 
				(
					addModifier obj (edit_mesh())
					maxops.collapseNodeTo obj (obj.modifiers.count) true
				)
				
				-- si hay vértices aislados los eliminamos
				if (meshop.getIsoVerts obj.baseobject).numberset > 0 then
					meshop.deleteIsoVerts obj.baseobject
				
				objMesh = obj.baseobject.mesh
				
				vcManagerOpen = try rollVCmanager.open catch false	-- indica si el rollout VCmanager está abierto
				if vcManagerOpen then
				(
					rollVCmanager.btnVCnormalize.visible = false
					rollVCmanager.pbNormalize.visible = true
				)
				
				-- recopilamos los colores de vértice desorganizados
				for i = 1 to obj.baseobject.mesh.faces.count do 
				(
					if vcManagerOpen then rollVCmanager.pbNormalize.value = i * 100 / obj.baseobject.mesh.faces.count
					face = (getface objMesh i)		
					vcFace = getVCface objMesh i
					v1 = face[1]		-- índice del vértice número 1 del triángulo
					v2 = face[2]		-- índice del vértice número 2 de triángulo
					v3 = face[3]		-- índice del vértice número 3 de triángulo
					if vcColors[v1] == undefined then vcColors[v1] = getVertColor objMesh vcFace[1]
					if vcColors[v2] == undefined then vcColors[v2] = getVertColor objMesh vcFace[2]
					if vcColors[v3] == undefined then vcColors[v3] = getVertColor objMesh vcFace[3]
				)
				
				-- borramos el canal de Vertex Color y asignamos uno nuevo ya ordenado
				this.deleteVertexColorChannel obj		
				this.createVertexColorChannel obj
				
				-- asignamos los colores de vértice ordenados
				for i = 1 to vcColors.count do
				(
					-- los vértices aislados no generan soporte para vertex colors, 
					-- así que los que no tengan nada asignado les ponemos color 0 0 0
					if vcColors[i] != undefined then			
						setVertexColor obj i vcColors[i]
					else
						setVertexColor obj i (color 0 0 0)
				)
				
				-- si el objeto es un edit poly lo convertimos a mesh con un modificador sobre el baseobject y lo colapsamos
				if c == editable_poly then 
				(
					addModifier obj (edit_poly())
					maxops.collapseNodeTo obj (obj.modifiers.count) true
				)
				
				if vcManagerOpen then
				(
					rollVCmanager.btnVCnormalize.visible = true
					rollVCmanager.pbNormalize.visible = false
				)
				
				normalized = true
			)
			
			normalized
		),

		----------------------------------------------------------------------------------------------------------------
		-- Asigna por número de vértice los vertex colors 
		-- cargados del fichero elegido
		----------------------------------------------------------------------------------------------------------------
		fn loadVertexColors obj f = 
		(
			fileLoaded = false
			
			if superclassof obj == geometryClass then --si es un objeto geometrico
			(
				if f != undefined then --si existe el fichero
				(
					colors = #() --array para guardar los colores
					bitArrays = #() --arrays para almacenar los bitArrays de los vertices de cada color
					
					numColors = getINISetting f "info" "count" --obtiene el numero de colores almacenados en el fichero
					objName = getINISetting f "info" "obj" --obtiene el nombre del objeto que llevaba esos vertex colors
					
					if numColors != "" and objName == obj.name then --si hay al menos un color almacenado en el fichero
					(
						numColors = numColors as integer
						
						for i=1 to numColors do --carga los colores y los bitarrays de los vertices
						(
							--construye el color
							clr = filterString (getINISetting f ("color_" + i as string) "color") "()color "
							clr = [clr[1] as float, clr[2] as float, clr[3] as float] as color
							append colors clr
							
							--construye el bitarray de vertex
							auxBitArray = #{}
							bits = filterString (getINISetting f ("color_" + i as string) "vertex") "#(){}, "
							for b in bits do
							(
								bParts = filterString b "."
								bitAux = #{}
								if bParts.count == 2 then
									bitAux = #{(bParts[1] as integer)..(bParts[2] as integer)}
								else
									bitAux = #{(bParts[1] as integer)}
								
								auxBitarray = auxBitArray + bitAux
							)
							append bitArrays auxBitArray
						)
						
						--comprueba que ha cargado al menos un color y una seleccion de vertices antes de asignarselo al objeto
						if colors.count != 0 and bitArrays.count != 0 then
						(
							
							--asigna los vertex colors obtenidos a los vertices obtenidos
							for i=1 to colors.count do
								setVertexColor obj bitArrays[i] colors[i]
							-------------------------------------------------------------------
													
							fileLoaded = true --flag para avisar si la carga ha sifo correcta
						)
					)
					
				)
				
			)
			
			fileLoaded
		),

		----------------------------------------------------------------------------------------------------------------
		-- Guarda en el fichero especificado los vertex colors del
		-- objeto OBJ. Se guardan ordenados por número de vértice
		----------------------------------------------------------------------------------------------------------------
		fn saveVertexColors obj f = 
		(
			fileSaved = false
			
			if superclassof obj == geometryClass and hasVertexColorChannel obj then --si es un objeto geometrico
			(
				if f != undefined then --si existe el fichero
				(
					colors = #() --array para guardar los colores
					bitArrays = #() --arrays para almacenar los bitArrays de los vertices de cada color

					--obtiene los colores de los vertex colors y los vertices que tienen cada color
					generalBitArray = #{1..(obj.mesh.verts.count)}
					clss = classof obj--.baseobject
					flag = true
					
					cont = 0
					limit = 15
					
					while (not generalBitArray.isEmpty) and flag and cont < limit do
					(
						index = (generalBitArray as array)[1] --primer elemento del bitarray
						
						clr = undefined
						clr = getVertColor obj.mesh index -- obj.baseobject.mesh index --obtiene el color de ese vertice
						
						if clr != undefined then
						(
							auxBitarray = #{}
							
							if clss == Editable_Mesh then
								auxBitarray = meshop.getVertsByColor obj/*.baseobject*/ clr 1 1 1
							else
							(
								if (clss == Editable_Poly) or (clss == PolyMeshObject) then
									auxBitarray = polyop.getVertsByColor obj/*.baseobject*/ clr 1 1 1
							)
							
							if not auxBitarray.isEmpty then
							(
								append colors clr
								append bitArrays auxBitarray
								
								generalBitArray = generalBitArray - auxBitarray
							)--if auxBitarray
							else
								flag = false
							
						)--if clr
						else
							flag = false
						
						cont += 1
					)
						
					--coloca el color negro y sus vertices al final de los arrays
					index = findItem colors (color 0 0 0)
					if index != 0 and index != colors.count then
					(
						auxColor = colors[index]
						auxVertex = bitArrays[index]
						
						colors[index] = colors[colors.count]
						bitArrays[index] = bitArrays[bitArrays.count]
						
						colors[colors.count] = auxColor
						bitArrays[bitArrays.count] = auxVertex
					)
					
					if colors.count != 0 then
						try (deleteFile f) catch ( print "error saving file" ) --intenta eliminar el fichero si ya existe
					
					--guarda los datos en el fichero
					setINISetting f "info" "obj" obj.name
					setINISetting f "info" "count" (colors.count as string)
					for i=1 to colors.count do
					(
						setINISetting f ("color_" + i as string) "color" (colors[i] as string)
						fileSaved = setINISetting f ("color_" + i as string) "vertex" (bitArrays[i] as string)
					)
					
				)--if f not undefined
			)--if superclass
			
			fileSaved
		),
			
		----------------------------------------------------------------------------------------------------------------
		-- elimina el canal de Vertex Color al objeto OBJ
		----------------------------------------------------------------------------------------------------------------
		fn deleteVertexColorChannel obj =
		(
			c = classof obj.baseobject
			if c == editable_mesh 	then meshop.setMapSupport obj.baseobject 0 false
			if (c == editable_poly) or (c == PolyMeshObject)	then polyop.setMapSupport obj.baseobject 0 false
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
		
	)--lib_vertexColor
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_vertexColor() --crea la libreria
)