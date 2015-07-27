------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de funciones de skin y skinMorph
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: skinVertData | Estructura de información de vértices de skin
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strSkinVertData 
	(
		numVert, posVert = [0,0,0], 
		numAsignaciones = 0, 
		bonesArray = #(), 
		weightArray = #()
	)
		
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: skinVertData | Estructura de información de cross sections de envolventes de skin
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strSkinCrossSectionData 
	(
		innerRadius, 
		outerRadius, 
		Upos
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: skinEnvData | Estructura de información de envolventes de skin. CrossSectionInfo es un array de structs de tipo skinCrossSectionData
	------------------------------------------------------------------------------------------------------------------------------------------------		
	struct strSkinEnvData 
	(
		startPoint = [0,0,0], 
		endPoint = [0,0,0], 
		envelopeName, 
		numberCrossSections, 
		crossSectionInfo = #()
	)
		
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: skin | Contiene la libreria de plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_skin
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de skin y skinMorph",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		skinVertData = strSkinVertData,
		skinCrossSectionData = strSkinCrossSectionData,
		skinEnvData = strSkinEnvData,
		
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
		--@fn: undefined | getSkinFilesFromAsset | Devuelve los archivos de skin de un asset.
		------------------------------------------------
		fn getSkinFilesFromAsset ast fileName:#all =
		(
			
			
			
			
		),

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		------------------------------------------------
		--@fn: undefined | resetSkinAlwaysDeform | Resetea el parametro alwaysDeform del skin. Trabaja sobre la seleccion, si no hay nada seleccionado trabajas sobre todos los objetos de la escena que tengan skin.
		------------------------------------------------
		fn resetSkinAlwaysDeform =
		(
			_objsToWork = #() --array con los objetos con los que trabajar. Inicialmente vacio
			
			----------------------------------------------------------------------------------------------------
			--EJECUCION
			----------------------------------------------------------------------------------------------------

			--Mira si hay objetos seleccionados o no en la escena.
			if selection.count != 0 then
				_objsToWork = getCurrentSelection()
			else
				_objsToWork = (geometry as array)
			
			--captura el número frame en el que se esta.
			 saveTime = slidertime
			
			--te pasa al frame 0
			sliderTime = 0f
			
			--activa el autokey
			animButtonState = true

			--obtiene los assets de la escena de tipo "chr" y de hay los que son de "rig" hace un "transform to zero".
			_assets = lb.asset.getSceneAssets type:"chr"
			_assetRigNodes = lb.asset.getAssetAnimNodes _assets[1] "rig"
				for o in _assetRigNodes do lb.controller.transformtozero o #all
			
			--desactiva el autokey.
			animButtonState = false
			
			--activa y desactiva el always deform del skin este seleccionado o no.
			for o in _objsToWork do
				for m in o.modifiers where classof m == skin do
				(	
					m.always_deform = false
					m.always_deform = true
				)
				
			--te vuelve a dejar el timeline en el frame en el que estabas.
			slidertime = saveTime	
		),
		
		-------------------------------------------------------------------------------------
		--@fn: modifier | addSkinModifier | Añade el modificador Skin a la seleccion de objetos. Necesita que el viewport y el command panel esten activos.
		--@gets: node | obj | Objeto a añadir el modificador. Mapeada.
		-------------------------------------------------------------------------------------
		mapped fn addSkinModifier obj = 
		(	
			-- guardamos en variables los modificadores que queremos que este por encima del Skin, y por debajo.
			_modifiersOnTopOfSkin = #(turbosmooth, meshSmooth, tessellate, optimize, proOptimizer, shell, skin_morph, Mesh_Select, Poly_Select, edit_poly, edit_mesh)	
			_modifiersUnderSkin = #(morpher, XForm)
			_skinModifier = skin()
			_skinModIndex = 0
			_spaceWarpModifiers = for i = obj.modifiers.count to 1 by -1 where superClassof obj.modifiers[i] == SpacewarpModifier collect obj.modifiers[i] 
			
			--excepcion para cuando se trata de la cabeza de un personaje, los modificadores mesh_select y poly_Select deben ir por debajo del skin, para cuando se haga una deformacion del punto de pivote de un xform, se desfasa.
			if lb.nc.ncOk obj.name and (lb.nc.getNamePart obj.name 5) == lb.nc.NC_anim_head then
			(
				_index = findItem _modifiersOnTopOfSkin Mesh_Select
				deleteitem _modifiersOnTopOfSkin _index

				_index = findItem _modifiersOnTopOfSkin Poly_Select
				deleteitem _modifiersOnTopOfSkin _index

				append _modifiersUnderSkin Mesh_Select
				append _modifiersUnderSkin Poly_Select
			)

			-- localizamos si existe un modificador skin o modificadores SpacewarpModifier y lo eliminamos
			for i = obj.modifiers.count to 1 by -1 where (classOf obj.modifiers[i]== skin) or (superClassOf obj.modifiers[i] == SpacewarpModifier) do
				deleteModifier obj obj.modifiers[i]
			
			_skinModIndex = obj.modifiers.count
			
			for i = obj.modifiers.count to 1 by -1 where (finditem _modifiersUnderSkin (classof obj.modifiers[i])) != 0 do _skinModIndex = i - 1
			
			-- buscamos de las variables de los mod guardadas alguna coincidencia con los que ya tenemos,
			-- y si encuentra alguna, el skin lo pone por encima
			for i = 1 to obj.modifiers.count where (finditem _modifiersOnTopOfSkin (classof obj.modifiers[i])) != 0 do _skinModIndex = i

			--excepcion para cuando se trata de la cabeza y hay un monton de poly_Select y mesh_select y xform. El skin se debe forzar a poner encima del poly_Select que se llame Clear_selection
			if lb.nc.ncOk obj.name and (lb.nc.getNamePart obj.name 5) == lb.nc.NC_anim_head then
				for i = obj.modifiers.count to 1 by -1 where obj.modifiers[i].name == "Clear_selection" do _skinModIndex = i - 1
						
			addModifier obj _skinModifier before:_skinModIndex
			
			--	restauramos los modificadores de tipo SpacewarpModifier
			for _mod in _spaceWarpModifiers do
				addModifier obj _mod
			
			_skinModifier
		),
		
		-------------------------------------------------------------------------------------
		--@fn: modifier | addSkinMorphModifier | Añade el modificador skinMorph a la seleccion justo despues del modificador skin. Necesita que el viewport y el command panel esten activos.
		--@gets: node | obj | Objeto a añadir el modificador. Mapeada.
		-------------------------------------------------------------------------------------
		mapped fn addSkinMorphModifier obj =
		(
			_modifiersUnderSkinMorph = #(skin)
			_findSkinMorph = false -- variable que recoge el resultado del messageBox a la hora de contrastar si existe modificador skinmorph. False por defecto
			_skinMorphModifier = undefined
			_skinMorphIndex = -1
			_spaceWarpModifiers = for i = obj.modifiers.count to 1 by -1 where superClassof obj.modifiers[i] == SpacewarpModifier collect obj.modifiers[i] 
			
			-- localizamos si existe un modificador skinMorph o modificadores SpacewarpModifier y lo eliminamos
			for i = obj.modifiers.count to 1 by -1 where (classOf obj.modifiers[i]== skin_morph) or (superClassOf obj.modifiers[i] == SpacewarpModifier) do
				deleteModifier obj obj.modifiers[i]
			
			-- buscamos de las variables de los mod guardadas alguna coincidencia con los que ya tenemos,
			-- y si encuentra alguna, el skinMorph lo pone por encima	
			--anticipamos false por si existe un skinmorph pero no un skin
			for i = obj.modifiers.count to 1 by -1 do
			(
				if (finditem _modifiersUnderSkinMorph (classof obj.modifiers[i])) != 0  then
					_skinMorphIndex = i - 1
			)
			
			if _skinMorphIndex != -1 then
			(
				_skinMorphModifier = Skin_Morph()
				addModifier obj _skinMorphModifier before:_skinMorphIndex
			)
			
			--	restauramos los modificadores de tipo SpacewarpModifier
			for _mod in _spaceWarpModifiers do
				addModifier obj _mod
			
			_skinMorphModifier
		),
		
		-------------------------------------------------------------------------------------
		--@fn: undefined | addSkinBonesSelected | Añade los huesos seleccionados a la lista del skin al objeto capturado. Se comprueba que los huesos que queremos añadir no esten en la lista para que no se dupliquen.
		--@gets: modifier | skinModifier | Modificador al cual añdir el listado de huesos.
		--@gets: array | bonesArray | Array de huesos a añadir en el listado.
		-------------------------------------------------------------------------------------
		fn addSkinBonesSelected skinModifier bonesArray =
		(	
			if classof skinModifier == Skin and classof bonesArray == Array then
			(
				-- entramos en el panel de modificadores y seleccionamos el skin
				max modify mode
				modPanel.setCurrentObject skinModifier
				
				-- obtenemos el numero de huesos que hay en la lista 
				_numBones = skinOps.GetNumberBones skinModifier
				
				-- array para comparar los huesos de la lista con los seleccionaos
				boneNamesArray= #()
				
				-- guardamos en nombre de los huesos capturados anteriormente
				for i = 1 to _numBones do
				(
					boneName = this.getBoneName skinModifier i
					append boneNamesArray boneName
				)
				
				-- array para comparar los huesos de la lista con los seleccionados, solo si no hay coincidencias se añaden
				for b = 1 to bonesArray.count do
				(
					index = findItem boneNamesArray bonesArray[b].name
					
					if index == 0 then
					(
						skinOps.AddBone skinModifier bonesArray[b] -1
					)
				)
			)
		),
		

		
		-------------------------------------------------------------------------------------
		--@fn: boolean | addSkinMorphModifier |  Determina si los pesos del vértice INDEX están normalizados
		--@gets: modifier | skinMod | Modificador del cual obtener el peso de los verices.
		--@gets: bitarray | vertIndex | Array que contiene todos los indices de vertices.
		----------------------------------------------------------------------------------------------
		fn isWeightNormalized skinMod vertIndex = 
		(
			w = 0.0

			for i = 1 to (skinops.getvertexweightcount skinMod vertIndex) do
			(
				w += skinops.getvertexweight skinMod vertIndex i
			)
			
			(w == 1.0)
		),
		
		----------------------------------------------------------------------------------------------
		--@fn: boolean | addSkinMorphModifier |  Se asegura de dejar seleccionado el objeto que tiene el skin para poder trabajar con él. 
		--@gets: modifier | skinMod | Modificador que tiene que seleccionar.
		--@opt: boolean | subobject | Si le pasamos el parámetro SUBOBJECT como true, entrará en modo subobjeto, en false no entrará
		----------------------------------------------------------------------------------------------
		fn selectSkinModifier skinMod subobject:true =
		(	
			_success = false
			
			_node = (refs.dependentNodes skinMod)[1]
			
			if $ != _node then select _node
			
			if skinMod == undefined and selection.count == 1 then skinMod = lb.modifiers.getNodeModifier selection[1] skin 
			
			if skinMod != undefined then
			(
				max modify mode
				
				if modPanel.getCurrentObject() != skinMod then
					modPanel.setCurrentObject skinMod
				
				if subObject and subobjectLevel != 1 then
				(				
					if subobject then
					(
						resumeEditing()
						subobjectLevel = 1
					)
				)				
				_success = true
			)
			else
			(
				_success = false
			)
			
			
			_success
		),
		
		-------------------------------------------------------------------------------------
		--@fn: integer | findClosestVertex |  Localiza en el vértice más cercano a la posición POS de entre todas las posiciones  que van definidas en VERTPOSARRAY. Devuelve el índice de la posicón más cercana.
		--@gets: array | vertPosArray | Array de posición de vertices.
		--@gets: point3 | pos  | Posición a buscar.
		-------------------------------------------------------------------------------------	
		fn findClosestVertex vertDataArray vertLength closestTMP:undefined =
		(
			_closestVertex = undefined
			_arr1 = for i = 1 to (vertDataArray.count/2) collect vertDataArray[i]
			_lastItem = _arr1[_arr1.count]
			
			if _lastItem[1] > vertLength then
			(
				if _arr1.count > 1 then
					_closestVertex = findClosestVertex _arr1 vertLength closestTMP:_lastItem
				else
					_closestVertex =  if (closestTMP != undefined) and (abs (_arr1[1][1] - vertLength)) > (abs (closestTMP[1] - vertLength)) then closestTMP else _arr1[1]
			)
			else if _lastItem[1] < vertLength then
			(
				_arr2 = for i = (vertDataArray.count/2 + 1) to vertDataArray.count collect vertDataArray[i]
				
				if _arr2.count > 1 then
					_closestVertex = findClosestVertex _arr2 vertLength closestTMP:_lastItem
				else
					_closestVertex = if (closestTMP != undefined) and (abs (_arr2[1][1] - vertLength)) > (abs (closestTMP[1] - vertLength)) then closestTMP else _arr2[1]
			)
			else
				_closestVertex = _lastItem
			
			_closestVertex
		),
		
		----------------------------------------------------------------------------------------------
		--@fn: integer | findBonesInScene |  Busca en el array sceneNodes los huesos cuyo nombre coincida con alguno del array boneNames
		--@gets: array | boneNames | Array de nombres de huesos.
		--@gets: array | sceneNodes | Array de nodos de entre los que buscar.
		----------------------------------------------------------------------------------------------
		fn findBonesInScene boneNames sceneNodes =
		(
			_bonesFound = #()		-- huesos encontrados en la escena que coinciden en nombre con los pasados en boneNames
			_realBoneNames = #()	--	nombres de los huesos que se quieren encontrar sin prefijos ni sufijos de asset
			
			-- Si el rollout de skin está abierto lo vamos actualizando
			rollSkinOpen = try rollSkinControl.open catch false
			
			-- obtenemos los nombres reales de los huesos que se quieren buscar en la escena
			for b in boneNames do
				append _realBoneNames (lb.nc.getNameWithNoPrefix b noFlags:true)
			
			for o in sceneNodes do
			(
				_objectName = (lb.nc.getNameWithNoPrefix o.name noFlags:true)
				_itemNum = finditem _realBoneNames _objectName		--	buscamos cada objeto en el array _realBoneNames
				if _itemNum != 0 then 								--	si lo encontramos lo añadimos a huesos encontrados y lo eliminamos de _realBoneNames para no encontrar duplicados
				(
					append _bonesFound o
					deleteitem _realBoneNames _itemNum
				)
			)
			
			_bonesFound
		),
			
		----------------------------------------------------------------------------------------------
		--@fn: integer | getFullBonesList | obtiene un listado real completo de los huesos contenidos en un modificador skin, incluídos aquellos que hayan podido ser borrados
		--@gets: skinModifier | skinMod | Modificador skin con el que operar.
		----------------------------------------------------------------------------------------------
		fn getSortedBonesList skinMod =
		(
			_bonesList = #()
			
			try  
				_bonesList = (for i = 1 to skinOps.getNumberBones skinMod collect skinOps.getBoneName skinMod i 1) 
			catch
				_bonesList = (for i = 1 to skinOps.getNumberBones skinMod collect skinOps.getBoneListById skinMod i 1)
			
			sort _bonesList
			
			_bonesList
		),
		
		----------------------------------------------------------------------------------------------
		--@fn: integer | getBoneName | obtiene un listado real completo de los huesos contenidos en un modificador skin, incluídos aquellos que hayan podido ser borrados
		--@gets: skinModifier | skinMod | Modificador skin con el que operar.
		--@gets: integer | boneId | Índice del hueso que se quiere consultar
		----------------------------------------------------------------------------------------------
		fn getBoneName skinMod boneId = 
		(
			(this.getSortedBonesList skinMod)[boneId]
		),
		
		----------------------------------------------------------------------------------------------
		--@fn: integer | setSkinBones |  actualiza el listado de huesos actual del modificador skin por el pasado en BONESLIST. Si REPLACE vale FALSE simplemente se añaden a los que hay.
		--@gets: skinModifier | skinMod | Modificador skin con el que operar.
		--@gets: skinModifier | bonesList | listado de huesos a asignar
		--@opt: boolean | replace | Si vale TRUE indica que hay que reemplazar el listado anterior. FALSE indica que se añaden los huesos al listado
		----------------------------------------------------------------------------------------------
		fn setSkinBones skinMod bonesList replace:true =
		(
			-- primero eliminamos todos los huesos si se ha indicado
			if replace then
				for i = skinops.getNumberBones skinMod to 1 by -1 do
					skinops.removeBone skinMod i
				
			for b in bonesList do
				skinOps.addBone skinMod b 0
			
			completeRedraw()
		),

		----------------------------------------------------------------------------------------------
		--@fn: integer | setSkinNumBonesPerVertex | Deja asignados por cada vértice un máximo del número de huesos indicado en MAXBONES. Elimina las asignaciones de menos peso.
		--@gets: skinModifier | skinMod | Modificador skin con el que operar.
		--@gets: integer | maxBones | Número máximo de huesos que quedarán asignados a un vértice
		----------------------------------------------------------------------------------------------
		fn setSkinNumBonesPerVertex skinMod maxBones =
		(
			nVerts = skinops.getNumberVertices skinMod
			
			-- Si el rollout de skin está abierto lo vamos actualizando
			rollSkinOpen = try rollSkinControl.open catch false
			
			if rollSkinOpen then rollSkinControl.lblLoading.caption = "Calculando..."

			for i=1 to nVerts do
			(
				if skinops.isVertexSelected skinMod i == 1 then
				(
					if rollSkinOpen then rollSkinControl.pbCalculating.value = i*100/nVerts
					
					_numBones = skinops.getvertexweightcount skinMod i
					
					if _numBones > maxBones then --solo eliminamos huesos si sobran
					(
						weightarray = #()
						bonesarray = #()
						
						for j=1 to _numBones do
							if (skinops.getvertexweight skinMod i j) != 0.0 then
								append weightarray (skinops.getvertexweight skinMod i j)
						
						sort weightarray --ordenamos de menor a mayor

						for j=1 to (_numBones - maxBones) do 
							if (weightarray.count > 0) then deleteItem weightarray 1 --eliminamos los valores que sobran (los más pequeños)
						
						weightTot = 0
						
						for k=1 to weightarray.count do
							for j=1 to _numBones do --añadimos como huesos nuevos solo los de mayor valor comparándolos con la tabla weightarray
								if (skinops.getvertexweight skinMod i j == weightarray[k]) and --comprobamos que no haya más huesos que
								   (bonesarray.count < weightarray.count) and 								 --las dos tablas deben ser del mismo tamaño
								   (skinops.getvertexweight skinMod i j != 0) then
								(
									append bonesarray (skinops.getvertexweightboneid skinMod i j)
									weightTot += (skinops.getvertexweight skinMod i j)
								)
						
						for i = 1 to weightarray.count do -- normalización de los pesos tras borrar el hueso
						(
							weightarray[i] /= weightTot
						)
						
						skinops.replacevertexweights skinMod i bonesarray weightarray
					)
				)
			)
			
			if rollSkinOpen then rollSkinControl.resetInfoUI()
		),

		----------------------------------------------------------------------------------------------
		--@fn: integer | setSkinEnvelopes | asigna a las envolventes del modificador SKINMOD la información incluida en envelopes (variable de tipo envData).
		--@gets: skinModifier | skinMod | Modificador skin con el que operar.
		--@gets: envData array | envelopes | Envolventes a asignar al skin.
		----------------------------------------------------------------------------------------------
		fn setSkinEnvelopes skinMod envelopes =
		(
			-- Si el rollout de skin está abierto lo vamos actualizando
			rollSkinOpen = try rollSkinControl.open catch false
			numBonesInSkin = skinops.getNumberBones skinMod
			
			if rollSkinOpen then rollSkinControl.lblLoading.caption = "Calculando envolventes..."
			
			for i = 1 to numBonesInSkin do
			(
				numBone = 0			-- Hueso con el que vamos a trabajar
				existeHueso=false
				
				-- buscamos el hueso en el que tenemos que cargar los datos de la envolvente
				while (numBone < numBonesInSkin) and not existeHueso do
				(
					numBone += 1
					nombre = lb.nc.getNameWithNoPrefix (this.getBoneName skinMod numBone) noFlags:true
					envName = lb.nc.getNameWithNoPrefix envelopes[numBone].envelopeName noFlags:true
					if nombre ==  envName then existeHueso = true
				)

				if existeHueso then
				(
					skinops.setStartPoint skinMod numBone envelopes[numBone].startPoint
					skinops.setEndPoint skinMod numBone envelopes[numBone].endPoint
					
					-- Comprobamos si hay definidas más cross sections de las que tenemos actualmente en la envolvente
					nCrossSections = skinops.getNumberCrossSections skinMod numBone
					if envelopes[numBone].numberCrossSections > nCrossSections then
					(
						-- Generamos las envolventes nuevas que hagan falta
						for k = nCrossSections to envelopes[numBone].numberCrossSections do
						(
							skinops.addCrossSection skinMod numBone (k/envelopes[numBone].numberCrossSections) 10 10
						)
					)
					
					for j=1 to envelopes[numBone].numberCrossSections do
					(
						skinops.setinnerRadius skinMod numBone j envelopes[numBone].crossSectionInfo[j].innerRadius
						skinops.setouterRadius skinMod numBone j envelopes[numBone].crossSectionInfo[j].outerRadius
						if envelopes[numBone].crossSectionInfo[j].Upos != undefined then
							skinops.setCrossSectionU skinMod numBone j envelopes[numBone].crossSectionInfo[j].Upos
					)
				)
			)
		),

		----------------------------------------------------------------------------------------------
		--@fn: integer | setSkinWeights | Asigna a los vértices del modificador SKINMOD la información de asignación contenida en vertexInfo (variable de tipo vertexData). 
		--@gets: skinModifier | skinMod | Modificador skin con el que operar.
		--@gets: vertexData array | vertexInfo | Información de vértices a asignar.
		--@gets: name | type | tipo de carga. Puede valer #bySpaceCoords o #byVertexNumber. #bySpaceCoords: busca el vértice más cercano al que se está cargando. #byVertexNumber carga por número de vértice
		--@opt: boolean | selVertsOnly | indica si hay que cargar la información solo a los vértices seleccionados en viewport
		----------------------------------------------------------------------------------------------
		fn setSkinWeights skinMod vertexInfo type selVertsOnly:false =
		(
			objMesh = (refs.dependentNodes skinMod)[1]			-- objeto al que pertenece el modificador skin
			skinBoneNames = #()											--	Nombres reales de los huesos del modificador skin
			vertPosArray = for v in vertexInfo collect v.posVert	--	Array con las posiciones de todos los vértices que vienen definidas en el fichero
			
			skinMod.enabled = false
			endResultState = showEndResult
			showEndResult = false
			
			--	Si el rollout de skin está abierto lo vamos actualizando
			rollSkinOpen = try rollSkinControl.open catch false
			if rollSkinOpen then rollSkinControl.lblLoading.caption = "Calculando pesos..."
			
			--	obtenemos los nombres reales de los huesos del modificador skin
			skinBoneNames = (for i = 1 to skinops.getNumberBones skinMod collect (lb.nc.getNameWithNoPrefix (skinops.getBoneName skinMod i 1) noFlags:true))
			-- 			skinBoneNames = for boneName in skinBoneNamesTMP collect (lb.nc.getNameWithNoPrefix boneName noFlags:true)
			
			i = 1
			cancel = false
			numVerts = skinops.getNumberVertices skinMod
			
			undo "Load Weights" on
			(
				while (i <= numVerts) and not cancel do
				(
					-- comprobamos si está seleccionada la opción de asignar a selección
					skipVert = false
					if selVertsOnly and not (skinops.isVertexSelected skinMod i == 1) then skipVert = true
					
					if not skipVert then
					(
						numVertice = i		--	número de vértice de vertexInfo del que obtenemos información para cargársela al vértice I del modificador skin
						
						--	Según el tipo de carga elegida obtenemos la información del vértice más cercano o del número de vértice que toque
						case type of 
						(
							#bySpaceCoords: numVertice = this.findClosestVertex vertPosArray objMesh.verts[i].pos
							
							#byVertexNumber: numVertice = (if i <= vertexInfo.count then i else vertexInfo.count)	-- Si hay más vértices que información en vertInfo nos quedamos siempre con el último.
						)
						
						--	De todos los pesos que tiene asignados el vértice, puede que algunos no se carguen porque
						-- 	no exista el hueso. Buscamos cuáles hay que cargar y cuáles no
						bonesIndexArray = #()
						weightsArray = #()
						
						for j = 1 to vertexInfo[numVertice].bonesarray.count do
						(
							bName = lb.nc.getNameWithNoPrefix vertexInfo[numVertice].bonesarray[j] noFlags:true
							index = findItem skinBoneNames bName
							
							-- Si el hueso está en el modificador skin lo añadimos al array de huesos y pesos a cargar
							if index != 0 then 
							(
								append bonesIndexArray index
								append weightsArray vertexInfo[numVertice].weightArray[j]
							)
						)
						
						skinops.replacevertexweights skinMod i bonesIndexArray weightsArray
					)
					
					if keyboard.escPressed then 
						if queryBox ("¿Seguro que desea cancelar la asignación de pesos?\n"+
										"Cancelar este paso puede provocar errores en el skin.") then cancel = true
					i += 1
				)
			)
			
			skinMod.enabled = true
			showEndResult = endResultState
			
			if rollSkinOpen then rollSkinControl.resetInfoUI()
			
			-- devolvemos true si no hemos cancelado la carga. False en caso contrario
			return not cancel
		),

		fn compareVertexLength a b =
		(
			case of 
			(
				(a[1] > b[1]):  1
				(a[1] < b[1]): -1
				default: 0 
			)
		),
		
		----------------------------------------------------------------------------------------------
		--  Desactiva los modificadores que modifican la topología para que no afecten 
		--	a operaciones de skin. Devuelve un struct con el estado previo de todas las 
		--	propiedades del modificador
		----------------------------------------------------------------------------------------------
		fn disableModsForSkinOperations node =
		(
			struct _strModState (modifier, enabled, enabledInViews, enabledInRenders)
			_modClassesToDisable = #(skin, skin_morph, turbosmooth, meshSmooth, tessellate, optimize, proOptimizer, shell)
			_oldStates = #()
			
			for _m in node.modifiers where findItem _modClassesToDisable (classof _m) != 0 do 
			(
				append _oldStates (_strModState modifier:_m enabled:_m.enabled enabledInViews:_m.enabledInViews enabledInRenders:_m.enabledInRenders)
				_m.enabled = false
				_m.enabledInViews = false
			)
			
			_oldStates
		),
		
		----------------------------------------------------------------------------------------------
		--  Restaura el estado de las propiedades enabled, enabledInViews y enabledInRenders 
		--	de los modificadores contenidos en stateList
		----------------------------------------------------------------------------------------------
		fn setModsState stateList =
		(
			for _state in stateList do
			(
				_mod = _state.modifier
				if _mod != undefined then
				(
					_mod.enabled = _state.enabled
					_mod.enabledInViews = _state.enabledInViews
					_mod.enabledInRenders = _state.enabledInRenders
				)
			)
		),
		
		----------------------------------------------------------------------------------------------
		--  Devuelve la información básica de skin almacenada en el fichero FILENAME
		----------------------------------------------------------------------------------------------
		fn readSkinInfo filename =
		(
			struct _str_skinInfo (formatVersion, numVerts, numBones)
			_skinInfo = undefined
			
			_f = openFile filename mode:"rt"
			
			if _f != undefined then
			(
				_header = readLine _f
				
				_header = subString _header 2 ((findstring _header ">") - 2)
				_header = substituteString _header "\"" ""
				_headerParts = filterString _header " "
				_skinInfo = _str_skinInfo()
				
				_skinInfo.formatVersion = (filterString _headerParts[2] "=")[2] as float
				_skinInfo.numBones = (filterString _headerParts[3] "=")[2] as integer
				_skinInfo.numVerts = (filterString _headerParts[4] "=")[2] as integer
			)
			
			_skinInfo
		),
		
		----------------------------------------------------------------------------------------------
		--  Realiza todo el proceso de carga de los datos de skin según las 
		--	opciones indicadas. Devuelve TRUE o FALSE indicando si se hizo la carga
		--	loadVertexType: indica el tipo de carga
		----------------------------------------------------------------------------------------------
		fn loadSkin filename skinMod loadVertexData:true loadEnvelopeData:true replaceBones:true loadVertexType:#byVertexNumber bySpaceCoordsTolerance:2.0 loadSelectedVertsOnly:false alwaysDeformRefFrame:0 = 
		(
			_fileLoaded = false
			
			_xmlDoc = lb.xml.load filename
			_xmlRootNode = _xmlDoc.root
			_formatVersion = 0
			_numVertex = 0
			_numBones = 0
			
			_notLoadedBones = #()

			_selfNode = (refs.dependentNodes skinMod)[1]
			
			--------------------------------------------
			--es necesario descongelar el objeto porque si no, falla la carga de skin, ya que no se puede seleccionar el modificador en el command panel.
			--esto es un nuevo bug maravilloso de max
			_isFrozenBackup = _selfNode.isfrozen
			_selfNode.isfrozen = false
			--------------------------------------------

			setwaitcursor()
			disableSceneRedraw()
			suspendEditing()
			
			gc()
			
			if _xmlDoc != undefined then
			(
				with undo off
				(
					--antes de nada hay que desactivar cierto tipo de modificadores
					_modifiersStateList = this.disableModsForSkinOperations _selfNode
					
					--	capturamos la malla del nodo. IMPORTANTE HACERLO TRAS HABER DESHABILITADO LOS MODIFICADORES
					_selfNodeMesh = try (_selfNode.mesh) catch (undefined)
					
					if _selfNodeMesh != undefined then
					(
						-- Leemos el número de versión y el número de huesos y vértices
						------------------------------------------------------------------------------------------------
						_xmlSkinNode = _xmlRootNode.getNode "skin"
						_formatVersion = (_xmlSkinNode.getProperty "formatVersion") as float
						_numVerts = (_xmlSkinNode.getProperty "numVerts" as integer)
						_numBones = (_xmlSkinNode.getProperty "numBones" as integer)
						_xmlBoneNodes = _xmlSkinNode.getNodes "bones/bone"
						
						--	Leemos los huesos y añadimos los User Properties en el nodo auxiliar que va a llevar la información de skin
						_channelsBoneNames = #()
						_boneNames = #()
						
						_assetName = lb.nc.getNamePart _selfNode.name 2
						
						for i = 1 to _xmlBoneNodes.count do
						(
							_boneName = _xmlBoneNodes[i].getProperty "name"
							
							
							if lb.nc.ncOk _boneName then _boneName = lb.nc.replaceNamePart _boneName 2 _assetName
							_boneName = lb.nc.getSimpleObjectName _boneName
							append _boneNames _boneName
						)
						
						--	Añadimos todos los vertex maps que hacen falta en el nodo destino
						--	OJO! Se están nombrando automáticamente los submaps por haber rellenado ya los User Properties
						_xmlVertexMapsNodes = _xmlDoc.getNodes "skin/vertexMaps/vertexMap" 
						_numVertexMaps = _xmlVertexMapsNodes.count

						--	Si se ha elegido reemplazar los huesos creamos un nuevo modificador de skin
						if replaceBones then
							skinMod = this.addSkinModifier _selfNode subobject:false
						
						--	Habilitamos temporalmente el panel de modificadores para añadir los huesos al skin. Si no no funciona.
						resumeEditing()
						
						this.selectSkinModifier skinMod subobject:false
						
						--	Añadimos los huesos al modificador de skin y al User Definned del skinDataNode
						for _boneName in _boneNames do
						(
							_boneNode = (execute ("$'" + _boneName + "_*'"))[1]	-- como las piezas de la escena no han perdido los sufijos los tenemos en cuenta
	 						--if _boneNode == undefined then _boneNode = (execute ("$'" + _boneName + "'"))	--	Si no se encuentra puede que la pieza no cumpliera NC. Buscamos el nombre tal cual
							
							if _boneNode != undefined then
								skinOps.addBone skinMod _boneNode 0
							else
								append _notLoadedBones _boneName
						)
						
						--	Si solo había un hueso asignado hemos terminado. Todos los vértices quedan asignados a él.
						--	Si no cargamos los pesos
						if _boneNames.count > 1 then
						(
							suspendEditing()
							
							--	añadimos un editMesh antes del skin para que siempre se carguen los datos con respecto a este tipo de pieza
							_skinModIndex = -1
							_auxEditMesh = edit_mesh()
							for i = 1 to _selfNode.modifiers.count where _selfNode.modifiers[i] == skinMod do _skinModIndex = i
							addmodifier _selfNode _auxEditMesh before:_selfNode.modifiers.count
							
							--	Clonado del nodo para crear otro auxiliar donde cargaremos los datos de skin
							_objectsBefore = objects as array
							skinUtils.extractSkinData _selfNode
							_skinDataNode = undefined
							for o in objects where findItem _objectsBefore o == 0 do _skinDataNode = o
							
							--	Iniciamos el número de vertex maps
							meshOp.setNumMaps _skinDataNode _numVertexMaps
							
							--	Por si algún canal se queda con un número de vértices distinto
							--	de los que tiene la geometría, los iniciamos.
							for i = 1 to meshOp.getNumMaps _skinDataNode do
								meshOp.setNumMapVerts _skinDataNode (i-1) _skinDataNode.verts.count
							----------------------------------------------------------------------------
							----------------------------------------------------------------------------
							--en caso de carga por proximidad hay que rehacer al vuelo los vertexmaps en funcion de los salvados y las posiciones de los vertices nuevos
							if loadVertexType == #bySpaceCoords then
							(
								-----------------------------
								_vertsNodes = _xmlDoc.getNodes "skin/verts/vertex" --obtiene los vertices almacenados
								_vertUtils = dotnetObject "vertexUtilities.vertexUtils" --crea el objeto de dontnet vertexutils para almacenar los vertices viejos y poder hacer calculos rápidos para buscar vertices cercanos
								------------------------------

								for i=1 to _vertsNodes.count do
								(
									--añade al vertUtils los vertices viejos
									_pos = execute (_vertsNodes[i].getProperty "pos")								
									_vertUtils.addVertex _pos[1] _pos[2] _pos[3]

								)--for

								------------------------------
								--obtiene el numero de vértices actual y los recorre averiguando sus equivalentes o los más cercanos por distancia en la malla antigua guardada en skin
								--_equivalenceVertexArray = #()
								_equivalenceNearestVerticesArray = #()
								for i=1 to _selfNodeMesh.verts.count do
								(
									_pos = _selfNodeMesh.verts[i].pos
									_auxVert = dotnetObject "vertexUtilities.vertex" _pos[1] _pos[2] _pos[3]
									_nearestVerts = _vertUtils.getNearestVertices _auxVert _vertUtils.vertexList bySpaceCoordsTolerance
									_equivalenceNearestVerticesArray[i] = if _nearestVerts.count != 0 then _nearestVerts else #()

								)--for

								------------------------------
								--crea los nuevos vertex maps

								_newVertMapsXmlDoc = lb.xml.newXmlDoc()
								_nvmRoot = _newVertMapsXmlDoc.getRoot()
								_newVertexMapNodes = #()

								for i = 1 to _numVertexMaps do
								(
									_newVertexMapNode = _nvmRoot.newChild (_xmlVertexMapsNodes[i].getName())
									_newVertexMapNode.setProperty "num" (_xmlVertexMapsNodes[i].getProperty "num")

									for j=1 to _equivalenceNearestVerticesArray.count where _equivalenceNearestVerticesArray[j].count != 0 do
									(
										_values = #()

										for k=1 to _equivalenceNearestVerticesArray[j].count do
										(
											_oldVertNum = "v" + (_equivalenceNearestVerticesArray[j].item[k-1].index as string)
											_value = _xmlVertexMapsNodes[i].getProperty _oldVertNum
											if _value != undefined then append _values (execute _value)
										)--for

										if _values.count != 0 then
										(
											_finalValue = [0,0,0]
											for _val in _values do _finalValue += _val
											_finalValue = _finalValue/(_values.count)
											_newVertexMapNode.setProperty ("v" + (j as string)) (_finalValue as string)
										)--if
									)--for

									append _newVertexMapNodes _newVertexMapNode --almacena el nuevo vertex map node
								)--for

								--print (_newVertMapsXmlDoc.toString())
								_xmlVertexMapsNodes = _newVertexMapNodes --sustituye los viejos vertex maps por los nuevos
								------------------------------
							)--if
							----------------------------------------------------------------------------
							----------------------------------------------------------------------------
							
							--	Nombramos los canales
							_mapChannelCount = 0
							for _boneName in _boneNames do
							(
								_mapChannelNum = (_mapChannelCount) / 3
								_mapSubChannelNum = (mod _mapChannelCount 3) as integer
								_userPropName = ("MapChannel:" + (_mapChannelNum as string) + "(" + (_mapSubChannelNum as string) + ")")
								_userPropValue = ("SkinWeight:" + _boneName)
								
								channelInfo.nameSubChannel _skinDataNode 3 _mapChannelNum _mapSubChannelNum _userPropValue
								meshOp.setNumMapVerts _skinDataNode _mapChannelNum _selfNodeMesh.verts.count
								
								_mapChannelCount += 1
							)
							
							--	Nos aseguramos de que los valores de los vértices de todos los canales están a [0,0,0]
							for i = 0 to (meshOp.getNumMaps _skinDataNode - 1) do
							(
								for j = 1 to _selfNodeMesh.verts.count do
								(
									if meshOp.getMapVert _skinDataNode i j != [0,0,0] then
										meshOp.setMapVert _skinDataNode i j [0,0,0]
								)
							)
							
							--	leemos todos los valores de cada vertex channel
							--	Como solo se almacenan los que son distintos de [0,0,0], solo rellenamos esos
							_numMeshVerts = _selfNodeMesh.verts.count
							
							for i = 1 to _numVertexMaps do
							(
								-- cargamos los datos de los vértices que no valen [0,0,0]
								_propNames = _xmlVertexMapsNodes[i].getPropNames()
								
								for _propName in _propNames do
								(
									_vertexNum = (substituteString _propName "v" "") as integer
									
									if (_vertexNum != undefined) and (_vertexNum <= _numMeshVerts) then
									(
										_vertexValue = execute (_xmlVertexMapsNodes[i].getProperty _propName)
										meshOp.setMapVert _skinDataNode (i-1) _vertexNum _vertexValue
									)
								)
							)
							
							--	renombramos todas las piezas de skin para eliminarles la última parte del nombre
							_skinNodes = ($'*_*_skin_*_*_*_*' as array) + ($'*_*_facial_*_*_*_*' as array)
							
							_skinNodesNames = for o in _skinNodes collect o.name
							for o in _skinNodes do o.name = (lb.nc.getSimpleObjectName o.name)
							
							---------------------------------
							--	cargamos el skin
							select #(_selfNode, _skinDataNode)
							skinUtils.ImportSkinDataNoDialog true true true true true 1.0 0
							----------------------------------
							
							--	recuperamos el nombre de las piezas
							for i = 1 to _skinNodes.count do _skinNodes[i].name = _skinNodesNames[i]
								
							--	limpiamos la escena
							delete _skinDataNode
							deleteModifier _selfNode _auxEditMesh
						)
						
						--desactiva y activa el allways deform y le pone el frame de referencia que corresponda
						skinMod.always_deform = false
						skinMod.ref_frame = alwaysDeformRefFrame
						skinMod.always_deform = true

						this.setModsState _modifiersStateList

						_fileLoaded = true
					)
					else
					(
						lb.message.show ("El objeto " + _selfNode.name + " es un xrefObject no resuelto") type:#message pos:undefined size:[300,75] modal:true
					)--if
				)--with undo off
			)--if

			_selfNode.isfrozen = _isFrozenBackup --restablece el estado de congelado del objeto
			
			setArrowCursor()
			enableSceneRedraw()
			resumeEditing()
			
			gc()

			if _notLoadedBones.count != 0 then
			(
				_message = "No se han encontrado algunos huesos en la escena:"
				for _nlb in _notLoadedBones do _message += "\n" + _nlb
				lb.message.show _message type:#message pos:undefined size:[300,75] modal:true
			)
			
			_fileLoaded
		),

		----------------------------------------------------------------------------------------------
		-- Recarga el skin, guarda el skin temporalmante en un archivo borra el skin
		-- añade uno nuevo y carga el skin que tenia guardado temporlamente.
		----------------------------------------------------------------------------------------------
		fn reloadSkin skinMod =
		(
			_node = (refs.dependentNodes skinMod)[1]
			_asset = (lb.asset.getAssetsFromNodes _node)[1]
			
			if _asset != undefined then 
			(
				_assetPath = _asset.folder
				_skinPath = if _assetPath != "" then (_assetPath + @"rig\skin\v" + (formattedprint _asset.version format:"02d") + "\\") else ""
				_objName = _node.nodeInfo.nameHistory[_node.nodeInfo.nameHistory.count] 
				_skinFile = _skinPath + "\\" + _objName + ".skn"
				
				if (doesFileExist _skinFile) then
				(
					setWaitCursor()
					gc()
					
					_skinMod = this.addSkinModifier _node
					this.loadSkin  _skinFile _skinMod
					
					setArrowCursor()
				)
			)
		),
		
		----------------------------------------------------------------------------------------------
		-- Guarda los datos de envolventes y vértices en el fichero _f
		----------------------------------------------------------------------------------------------
		-- 	PENDIENTE: No usar para nada skinOps. Extraer los huesos con una función que recorra los subanims.!!!
		
		fn saveSkin filename skinMod =
		(
			if doesFileExist filename then setFileAttribute filename #readOnly false
			_xmlDoc = lb.xml.newXmlDoc()
			_xmlDoc.path = filename
			_xmlRootNode = _xmlDoc.root
			_fileSaved = true
			_selfNode = (refs.dependentNodes skinMod)[1]
			
			--	Preparamos el stack de modificadores
-- 			skinMod.enabled = false
			endResultState = showEndResult
			showEndResult = false
			
			-- creamos la geometría auxiliar con skinTools de la que se va a extraer la información de skin
			setWaitCursor()
			disableSceneRedraw()
			suspendEditing()
			
			with undo off
			(
				--antes de nada hay que desactivar cierto tipo de modificadores
				_modifiersStateList = this.disableModsForSkinOperations _selfNode
				
				--	capturamos la malla del nodo. IMPORTANTE HACERLO TRAS HABER DESHABILITADO LOS MODIFICADORES
				_selfNodeMesh = _selfNode.mesh
				
				--	añadimos un editMesh antes del skin para que siempre se guarden los datos con respecto a este tipo de pieza
				_skinModIndex = -1
				_auxEditMesh = edit_mesh()
				for i = 1 to _selfNode.modifiers.count where _selfNode.modifiers[i] == skinMod do _skinModIndex = i
				addmodifier _selfNode _auxEditMesh before:_selfNode.modifiers.count
				
				--	Exportamos a un nodo auxiliar la información de skin
				_objectsBefore = objects as array
				skinUtils.extractSkinData _selfNode
				_skinDataNode = undefined
				for o in objects where findItem _objectsBefore o == 0 do _skinDataNode = o
				--_skinDataNode = getNodeByName ("SkinData_" + _selfNode.name)
				
				---------------------------------------------------------------------
				----------------------- guardar vertex maps -----------------------
				---------------------------------------------------------------------
				if _skinDataNode != undefined then
				(
					_numVerts = _selfNodeMesh.verts.count
					_boneNames = filterstring (getUserPropBuffer _skinDataNode) "\n"
					_numBones = _boneNames.count
					
					_xmlSkinNode = _xmlRootNode.newChild "skin"
					_xmlSkinNode.setProperty "formatVersion" "3.0"
					_xmlSkinNode.setProperty "numBones" _numBones
					_xmlSkinNode.setProperty "numVerts" _numVerts
					
					---------------------------------------------------------------------
					------------------------- guardar envelopes ------------------------
					---------------------------------------------------------------------
					_xmlBonesNode = _xmlSkinNode.newChild "bones"
					_xmlBonesNode.setProperty "numBones" _numBones
					
					for i = 1 to (_numBones) do
					(
						_userPropNumber = ((i-1)/3) as string
						_subChannelPropNumber = ((mod (i - 1) 3) as integer) as string
						_userPropName = "MapChannel:" + _userPropNumber + "(" + _subChannelPropNumber + ")"
						
						_userPropValue =  (getUserProp _skinDataNode _userPropName)
						
						if _userPropValue != undefined then
						(
							_userPropValue = (filterstring _userPropValue ":")[2]
							_xmlBoneNode = _xmlBonesNode.newChild "bone" 
							_xmlBoneNode.setProperty "num" i
							_xmlBoneNode.setProperty "name" _userPropValue
						)
					)
					
					---------------------------------------------------------------------
					------------------------ guardar vertex maps -------------------------
					---------------------------------------------------------------------
					_xmlVertsNode = _xmlSkinNode.newChild "verts"
					_xmlVertsNode.setProperty "numVerts" _numVerts
					
					--	Guardado de la posición de los vértices
					for i=1 to _numVerts do
					(
						_xmlVertNode = _xmlVertsNode.newChild "vertex"
						_xmlVertNode.setProperty "num" i
						_xmlVertNode.setProperty "pos" [_selfNodeMesh.verts[i].pos.x, _selfNodeMesh.verts[i].pos.y, _selfNodeMesh.verts[i].pos.z]
					)
					
					--	Guardado de los vertexMaps
					_numVertexMaps = (meshOp.getNumMaps _skinDataNode)
					
					_xmlVertexMapsNode = _xmlSkinNode.newChild "vertexMaps" 
					_xmlVertexMapsNode.setProperty "numVertexMaps" _numVertexMaps
					
					_cancelSave = false
					
					for i = 0 to (_numVertexMaps - 1) where not _cancelSave do
					(
						_xmlMapNode = _xmlVertexMapsNode.newChild "vertexMap"
						_xmlMapNode.setProperty "num" i
						_numMapVerts = try  (meshOp.getNumMapVerts _skinDataNode i) catch 0
						
						for j = 1 to _numMapVerts where not _cancelSave do
						(
							_mapValue = meshOp.getMapVert _skinDataNode i j
							
							if _mapValue != [0,0,0] then 
								_xmlMapNode.setProperty ("v" + (j as string)) _mapValue
							
							if keyboard.escPressed then _cancelSave = true
						)
					)
					
					_xmlDoc.save()
					
					delete _skinDataNode
					deleteModifier _selfNode _auxEditMesh
						
					_fileSaved = true
				)
				
				--al final se dejan los modificadores como estaban
				this.setModsState _modifiersStateList
			)
			
-- 			skinMod.enabled = true
			showEndResult = endResultState
			enableSceneRedraw()
			resumeEditing()
			setArrowCursor()
			completeRedraw()
			
			_fileSaved
		),

		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------- FUNCIONES SKIN MORPH ----------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------
		-- Recarga el skinMorph, guarda el skinMorph temporalmante en un archivo borra el skinMorph
		-- añade uno nuevo y carga el skinMorph que tenia guardado temporlamente.
		----------------------------------------------------------------------------------------------
		fn reloadSkinMorph skinMorphMod =
		(
			_node = (refs.dependentNodes skinMorphMod)[1]
			_asset = (lb.asset.getAssetsFromNodes _node)[1]
			
			if _asset != undefined then 
			(
				_assetPath = _asset.folder
				_skinMorphPath = if _assetPath != "" then (_assetPath + @"rig\skin\v" + (formattedprint _asset.version format:"02d") + "\\") else ""
				_objName = _node.nodeInfo.nameHistory[_node.nodeInfo.nameHistory.count] 
				_skinMorphFile = _skinMorphPath + "\\" + _objName + ".smd"
				
				if (doesFileExist _skinMorphFile) then
				(
					setWaitCursor()
					gc()
					
					_smMod = lb.skin.addSkinMorphModifier _node
					lb.skin.loadSkinMorph _smMod _skinMorphFile
					
					setArrowCursor()
				)
			)
		),-- end



		-------------------------------------------------------------------------------------
		-- Skin Morph Data Save
		-------------------------------------------------------------------------------------
		fn saveSkinMorph skinMorphMod filename =
		(
			if doesFileExist filename then setFileAttribute filename #readOnly false
			_xmlDoc = lb.xml.newXmlDoc()
			_xmlDoc.path = filename
			_rootNode = _xmlDoc.root
			_node = (refs.dependentNodes skinMorphMod)[1]		-- objeto que tiene el modificador Skin Morph
			_numBones = skinMorphMod.bones.count				-- Número total de huesos del modificador
			_editMeshMod = undefined
			
			--antes de nada hay que desactivar cierto tipo de modificadores
			_modifiersStateList = this.disableModsForSkinOperations _node
			
			--	capturamos la malla del nodo. IMPORTANTE HACERLO TRAS HABER DESHABILITADO LOS MODIFICADORES
			_nodeMesh = _node.mesh
			_numVerts = _nodeMesh.numverts				-- Número total de vértices en la geometría
			
			--si el objeto que lleva el skin es un shape le añade un editmesh
			if superclassof _node == shape and _node.modifiers.count != 0 then
				if (classof _node.modifiers[_node.modifiers.count] != edit_mesh) and classof (_node.modifiers[_node.modifiers.count] != edit_poly) then
				(
					_editMeshMod = edit_mesh()
					addmodifier _node _editMeshMod before:(_node.modifiers.count  + 1)
				)
			
			--	Desactivamos primero el modificador para deshacer sus transformaciones
			skinMorphModState = skinMorphMod.enabled
			skinMorphMod.enabled = false
			
			_skinMorphNode = _rootNode.newChild "skinMorph"
			_skinMorphNode.setProperty "formatVersion" "2.0"
			_skinMorphNode.setProperty "numBones" _numBones
			_skinMorphNode.setProperty "numVerts" _numVerts
			
			-- Sección de huesos
			_bonesNode = _skinMorphNode.newChild "bones"
			
			for i = 1 to skinMorphMod.bones.count where (skinMorphMod.bones[i] != undefined) do
			(
				_bone = skinMorphMod.bones[i]						-- Hueso actual que estamos tratando
				_numMorphs = skinMorphMod.boneGetNumberOfMorphs _bone	-- numero de morphs definidos para el hueso actual
				_morphIndex = #()									-- array con los índices de los morphs definidos que no han sido borrados
				
				-- Iniciamos numMorphs contando solo los Morphs que no han sido borrados
				for i = 1 to _numMorphs where not (skinMorphMod.boneGetMorphIsDead _bone i) do append _morphIndex i
				
				--	Nuevo hueso en el documento
				_boneNode = _bonesNode.newChild "bone"
				
				_boneNode.setProperty "name" _bone.name
				_boneNode.setProperty "numMorphs" _morphIndex.count
				
				-- recorremos los morphs que no han sido borrados
				for j = 1 to _morphIndex.count do
				(
					_index = _morphIndex[j]		-- extraemos el índice del morph a tratar
					_vertsPos = #()			-- Array con las posiciones relativas de todos los vértices que forman parte del morph
					_vertsSpacePos = #()	-- Array con las posiciones reales de todos los vértices que forman parte del morph
					
					-- rellenamos todos los datos a guardar
					_morphEnabled 	= 		skinMorphMod.boneGetMorphEnabled 		_bone 	_index		-- Morph activo o apagado
					_morphName 		= 		skinMorphMod.boneGetMorphName			_bone 	_index		-- nombre del morph
					_boneTM			= 		skinMorphMod.boneGetMorphTM 			_bone 	_index		-- Transformación del hueso actual
					_boneParentTM	=		skinMorphMod.boneGetMorphParentTM		_bone	_index		-- Transformación del padre del hueso actual
					_influenceAngle = 		skinMorphMod.boneGetMorphAngle 			_bone 	_index		-- ángulo a partir del que actua el morph
					_morphFalloff 	= 		skinMorphMod.boneGetMorphFalloff 		_bone 	_index		-- tipo de falloff
					_numVerts 		= 		skinMorphMod.boneGetMorphNumPoints		_bone 	_index		-- Número de vértices modificados en el morph
					
					for _numVert = 1 to _numVerts do
					(
						_vID = skinMorphMod.boneGetMorphVertID _bone _index _numVert
						append _vertsPos (skinMorphMod.boneGetMorphVecInParentSpace _bone _index _numVert)
						append _vertsSpacePos (_nodeMesh.verts[_vID].pos)
					)
					
					_morphNode = _boneNode.newChild "morph"
					
					_morphNode.setProperty "name" 			_morphName
					_morphNode.setProperty "enabled" 		_morphEnabled
					_morphNode.setProperty "boneTM" 		_boneTM
					_morphNode.setProperty "boneParentTM" 	_boneParentTM
					_morphNode.setProperty "influenceAngle" _influenceAngle
					_morphNode.setProperty "morphFalloff" 	_morphFalloff
					_morphNode.setProperty "numVerts" 		_numVerts
					
					_vertexIds = _morphNode.newChild "vertexIds"
					_vertexPos = _morphNode.newChild "vertexPos"
					_vertexSourcePos = _morphNode.newChild "vertexSourcePos"

					_vertexIds.setProperty "numVertex" _numVerts
					_vertexPos.setProperty "numVertex" _numVerts
					_vertexSourcePos.setProperty "numVertex" _numVerts

					for k = 1 to _numVerts do
					(
						_vertID = (skinMorphMod.boneGetMorphVertID _bone _index k)
						_vertexIds.setProperty ("id" + (k as string)) _vertID
						_vertexPos.setProperty ("p" + (k as string)) _vertsPos[k]
						_vertexSourcePos.setProperty ("sp" + (k as string)) (formattedPrint _vertsSpacePos[k] format:"0.10f")	--	guardamos 
					)
				)		
			)

			--almacena los vertices originales y su posicion
			_xmlVertsNode = _skinMorphNode.newChild "verts"
			_xmlVertsNode.setProperty "numVerts" _numVerts
			
			--	Guardado de la posición de los vértices
			_selfNodeMesh = _node.mesh
			_numVerts = _selfNodeMesh.numverts
			for i=1 to _numVerts do
			(
				_xmlVertNode = _xmlVertsNode.newChild "vertex"
				_xmlVertNode.setProperty "num" i
				_xmlVertNode.setProperty "pos" [_selfNodeMesh.verts[i].pos.x, _selfNodeMesh.verts[i].pos.y, _selfNodeMesh.verts[i].pos.z]
			)
			
			skinMorphMod.enabled = skinMorphModState
			
			--	Si se añadió un editMesh se elimina
			if _editMeshMod != undefined then 
				deleteModifier _node _editMeshMod
			
			--al final se dejan los modificadores como estaban
			this.setModsState _modifiersStateList

			
			_xmlDoc.save()
		),

		-------------------------------------------------------------------------------------
		-- Devuelve la longitud desde el 0 de la posición pasada en POS
		-------------------------------------------------------------------------------------
		fn getVertexLength pos =
		(
			(length pos) * (lb.math.sign pos.x)
		),
		
		-------------------------------------------------------------------------------------
		-- Skin Morph Data Load
		-------------------------------------------------------------------------------------
		fn loadSkinMorph skinMorphMod filename loadType:#byVertexNumber bySpaceCoordsTolerance:1.0 replaceBones:true quiet:false =
		(
			_notLoadedBones = #()

			_xmlDoc = lb.xml.load filename
			_node = (refs.dependentNodes skinMorphMod)[1]	-- objeto que tiene el modificador skin pasado por parámetro
			
			--esto es necesario para que se pueda seleccionar el modificador en el command panel. Si no da error
			_isFrozenBackup = _node.isfrozen
			_node.isfrozen = false

			_assetName = (lb.nc.getNamePart _node.name 2)
			
			_editMeshMod = undefined
			_t = timestamp()
			
			--antes de nada hay que desactivar cierto tipo de modificadores
			_modifiersStateList = this.disableModsForSkinOperations _node
			
			--	capturamos la malla del nodo. IMPORTANTE HACERLO TRAS HABER DESHABILITADO LOS MODIFICADORES
			_nodeMesh = _node.mesh
			
			--	Hay que seleccionar el nodo y tener visible el panel de modificadores para que funcione la carga
			if selection.count != 1 or not _node.isSelected then
				select _node
			max modify mode
			
			--si el objeto que lleva el skin es un shape le añade un editmesh
			if superclassof _node == shape and _node.modifiers.count != 0 then
				if (classof _node.modifiers[_node.modifiers.count] != edit_mesh) and classof (_node.modifiers[_node.modifiers.count] != edit_poly) then
				(
					_editMeshMod = edit_mesh()
					addmodifier _node _editMeshMod before:(_node.modifiers.count  + 1)
				)
			
			_originVertUtils = dotnetObject "vertexUtilities.vertexUtils"
			_originalVerts = _xmlDoc.getNodes "skinMorph/verts/vertex"
			for i=1 to _originalVerts.count do
			(
					--añade al vertUtils los vertices viejos
					_pos = execute (_originalVerts[i].getProperty "pos")
					_originVertUtils.addVertex i _pos[1] _pos[2] _pos[3]
					
					--print i
					--print _pos
					--print "-------------"
			)--for			

			_boneNodes = _xmlDoc.getNodes "skinMorph/bones/bone"
			_objNames = #()														-- nombres de los objetos de la escena sin prefijos ni sufijos de asset
			_vertPosArray = for _vert in _nodeMesh.verts collect _vert.pos		--	Array con las posiciones de todos los vértices que vienen definidas en el fichero
			_vertDataArray = #()
			_closestVertIDArray = #()
			_skinMorphLoaded = false
			
			skinMorphMod.useSoftSelection = false			-- Desactivamos el soft selection para evitar problemas de asignación de vértices
			
			-- Si hemos elegido reemplazar los huesos del modificador, primero borramos todos los que pudiera haber
			if replaceBones then 
			(
				_objNames = for o in objects collect lb.nc.getSimpleObjectName o.name
				_index = lb.modifiers.getNodeModifierIndex _node skin_morph
				
				if _index != 0 then
				(
					deleteModifier _node _index
					addModifier _node (skin_morph()) before:(_index - 1)
					skinMorphMod = _node.modifiers[_index]
				)
			)
			
			if loadType == #bySpaceCoords then
			(
				_vertDataArray = for _v in _node.mesh.verts collect #(getVertexLength _v.pos, _v.index)
				qsort _vertDataArray this.compareVertexLength
				_sortedVertIndexArray = for _v in _vertDataArray collect _v[2]
			)
			
			--	Cargamos los pesos
			for i = 1 to _boneNodes.count do
			(
				_boneName = _boneNodes[i].getProperty "name"
				_bone = undefined	-- Nodo que buscamos dentro del skinMorph o en la escena con nombre boneName
				
				-- Si no hemos elegido reemplazar el hueso, lo buscamos entre los cargados en el modificador
				if not replaceBones then
				(
					for _bn in skinMorphMod.bones do
						if (lb.nc.getNameWithNoPrefix _bn.name noFlags:true) == (lb.nc.getNameWithNoPrefix _boneName noFlags:true) then _bone = _bn
				)
				else	-- si se eligió reemplazar el hueso lo buscamos en la escena
				(
					_searchName = lb.nc.replaceNamePart (lb.nc.getSimpleObjectName _boneName) 2 _assetName
					_objIndex = findItem _objNames _searchName
					
					if _objIndex != 0 then 
					(
						_bone = objects[_objIndex]
						skinMorphMod.addBone _bone
					)
				)
					
				-- Si hemos encontrado el hueso cargamos sus datos

				if _bone != undefined then
				(
					_morphNodes = _boneNodes[i].getNodes "morph"
					
					-- recorremos los morphs que no han sido borrados
					for numMorph = 1 to _morphNodes.count do
					(
						_morphName 		= _morphNodes[numMorph].getProperty "name"
						_morphEnabled 	= execute (_morphNodes[numMorph].getProperty "enabled")
						_boneTM 		= execute (_morphNodes[numMorph].getProperty "boneTM") 
						_boneParentTM	= execute (_morphNodes[numMorph].getProperty "boneParentTM")
						_influenceAngle = execute (_morphNodes[numMorph].getProperty "influenceAngle")
						_morphFalloff 	= execute (_morphNodes[numMorph].getProperty "morphFalloff")
						_numVerts 		= execute (_morphNodes[numMorph].getProperty "numVerts")
							
						skinMorphMod.createMorph _bone
						_numMorphs = skinMorphMod.boneGetNumberOfMorphs _bone		-- previous morphs could be already created or deleted
						
						-- iniciamos los valores del skinMorph
						skinMorphMod.boneSetMorphName		_bone 	_numMorphs	_morphName		-- asignamos el nombre correcto del morph
						skinMorphMod.boneSetMorphEnabled 	_bone 	_numMorphs	_morphEnabled	-- Morph activo o apagado
						skinMorphMod.boneSetMorphTM 		_bone 	_numMorphs	_boneTM			-- Transformación del hueso actual
						skinMorphMod.boneSetMorphParentTM 	_bone 	_numMorphs	_boneTM			-- Transformación del hueso actual
						skinMorphMod.boneSetMorphAngle 		_bone 	_numMorphs	_influenceAngle	-- ángulo a partir del que actua el morph
						skinMorphMod.boneSetMorphFalloff 	_bone 	_numMorphs	_morphFalloff	-- tipo de falloff

						-- Asignación de vértices				
						skinMorphMod.selectVertices _node #{(_node.mesh.verts.count + 1)}		--  con esto borramos la selección de vértices actual. No se encontró otra forma.
						
						_vertexIds = _morphNodes[numMorph].getNode "vertexIds"
						_vertexPos = _morphNodes[numMorph].getNode "vertexPos"
						_vertexSourcePos = _morphNodes[numMorph].getNode "vertexSourcePos"

						_numVerts = (_vertexIds.getProperty "numVertex") as integer

						--si el modo de carga es por proximidad
						if loadType == #bySpaceCoords then
						(
							--print _morphName

							_vertUtils = dotnetObject "vertexUtilities.vertexUtils" --crea el objeto de dontnet vertexutils para los vertices viejos y poder hacer calculos rápidos para buscar vertices cercanos
							
							for k = 1 to _numVerts do
							(
								--añade al vertUtils los vertices viejos
								--_id = _vertexIds.getProperty ("id" + (k as string)) as integer
								_pos = execute (_vertexSourcePos.getProperty ("sp" + (k as string)))
								_vertUtils.addVertex k _pos[1] _pos[2] _pos[3]
							)--for

							_selfNodeMesh = _node.mesh --obtiene la malla nueva
							_equivalenceIndexes = #()
							_equivalenceSrcPos = #()
							_equivalenceNearestVerticesArray = #() --array de equivalencias entre vertices actuales y viejos
							
							--recorre los vertices de la malla nueva buscando el aquivalente en los viejos
							for j=1 to _selfNodeMesh.verts.count do
							(
								_pos = _selfNodeMesh.verts[j].pos
								_auxVert = dotnetObject "vertexUtilities.vertex" j _pos[1] _pos[2] _pos[3]
								_nearestVerts = _vertUtils.getNearestVertices _auxVert _vertUtils.vertexList bySpaceCoordsTolerance
								_nearestOriginVerts = _originVertUtils.getNearestVertices _auxVert _originVertUtils.vertexList 0.01

								-----------------------------------------
								--si en la malla original existia el vertice actual, hay que mirar que se moviera.
								--si en los nearest hay mas de un vertice es que no se movía.
								--si en los nearest hay solo uno, hay que mirar si es el mismo
								_vertHasToMove = _nearestVerts.count != 0

								--print _nearestVerts.count
								--print _nearestOriginVerts.count

								if _vertHasToMove and _nearestOriginVerts.count == 1 then
								(									
									if _nearestVerts.count > 1 then _vertHasToMove = false
									if _vertHasToMove and _nearestVerts.count == 1 then
									(
										_xdis = abs (_nearestVerts.item[0].x - _nearestOriginVerts.item[0].x)
										_ydis = abs (_nearestVerts.item[0].y - _nearestOriginVerts.item[0].y)
										_zdis = abs (_nearestVerts.item[0].z - _nearestOriginVerts.item[0].z)

										if _xdis > 0.01 or _ydis > 0.01 or _zdis > 0.01 then
										(
											_vertHasToMove = false

											--print (_nearestVerts.item[0].toString())
											--print (_nearestOriginVerts.item[0].toString())
											--print "----------------------"
										)--if
									)--if
								)
								
								--print "---------------------------------------------------"
								-----------------------------------------

								if _vertHasToMove then
								(
									append _equivalenceIndexes j
									append _equivalenceSrcPos _pos
									append _equivalenceNearestVerticesArray _nearestVerts									
								)--if
							)--for

							--print "-----------------------------------------"

							--crea un nuevo documento de xml en memoria para crear los nodos de información que remplacen a los viejos
							_newVertInfoDoc = lb.xml.newXmlDoc()
							_nviRoot = _newVertInfoDoc.getRoot()

							_newVertIds = _nviRoot.newChild "vertexIds" --nuevo nodo de información de vertex Ids
							_newVertPos = _nviRoot.newChild "vertexPos" --nuevo nodo de información de vertex Ids
							_newVertSrcPos = _nviRoot.newChild "vertexSourcePos" --nuevo nodo de información de vertex Ids

							_newVertIds.setProperty "numVertex" _equivalenceNearestVerticesArray.count
							_newVertPos.setProperty "numVertex" _equivalenceNearestVerticesArray.count
							_newVertSrcPos.setProperty "numVertex" _equivalenceNearestVerticesArray.count

							for j=1 to _equivalenceIndexes.count do
							(
								_newVertIds.setProperty ("id" + (j as string)) _equivalenceIndexes[j]
								_newVertSrcPos.setProperty ("sp" + (j as string)) (_equivalenceSrcPos[j] as string)

								--print _equivalenceIndexes[j]
								--print (_selfNodeMesh.verts[(_equivalenceIndexes[j])].pos)
								--print "- - - -"

								-------------------------
								--calcula la posicion media de los vertices mas cercanos obtenidos y la almacena como nueva posicion del skinmorph

								_defPos = [0,0,0]

								if _equivalenceNearestVerticesArray[j].count == 1 then
								(
									_eqId = _equivalenceNearestVerticesArray[j].item[0].index
									_defPos = execute (_vertexPos.getProperty ("p" + (_eqId as string)))
								)
								else
								(
									for l=1 to _equivalenceNearestVerticesArray[j].count do
									(
										_eqId = _equivalenceNearestVerticesArray[j].item[l-1].index
										--print _eqId

										_tmpPos = execute (_vertexPos.getProperty ("p" + (_eqId as string)))
										--print _tmpPos

										_defPos += _tmpPos				
									)--for
									_defPos = _defPos/_equivalenceNearestVerticesArray[j].count
								)--if else

								--print _defPos
								--print "------------------------"
								_newVertPos.setProperty ("p" + (j as string)) (_defPos as string)
								-------------------------
							)--for

							--print (_vertexIds.toString())
							--print (_vertexPos.toString())
							--print (_vertexSourcePos.toString())

							--print "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

							--print (_newVertIds.toString())
							--print (_newVertPos.toString())
							--print (_newVertSrcPos.toString())
							--print "------------------------------------------------------------------------------------"

							--sustituye los viejos nodos de xml con los nuevos y hace que se carguen por numero de vertice, ya que las equivalencias de proximidad ya se han calculado
							_numVerts = _equivalenceNearestVerticesArray.count
							_vertexIds = _newVertIds
							_vertexPos = _newVertPos
							_vertexSourcePos = _newVertSrcPos
							--loadType = #byVertexNumber
						)--if

						
						for k = 1 to _numVerts where not keyboard.escPressed do
						(
							_vertID = 0	-- número de vértice que se va a añadir al skinMorph
							
							/*case loadType of
							(
								#bySpaceCoords: 
								(
									_vertSpacePos = execute (_vertexSourcePos.getProperty ("sp" + (k as string)))
									_vertLength = getVertexLength _vertSpacePos
									_incomingVertID = (_vertexIds.getProperty ("id" + (k as string))) as integer
									
 									--if _closestVertIDArray[_incomingVertID] == undefined then
 									--	_closestVertIDArray[_incomingVertID] = (this.findClosestVertex _vertDataArray _vertLength)[2]
									
									_vertID = (this.findClosestVertex _vertDataArray _vertLength)[2]--_closestVertIDArray[_incomingVertID]
									
									if _incomingVertID != _vertID then
									(
										--print _incomingVertID
										--print _vertID
										--print "--------"
									)
								)
								
								#byVertexNumber: _vertID = (_vertexIds.getProperty ("id" + (k as string))) as integer
							)*/

							_vertID = (_vertexIds.getProperty ("id" + (k as string))) as integer							
							_vertPos = execute (_vertexPos.getProperty ("p" + (k as string)))
							
							skinMorphMod.selectVertices _node #{_vertID}			-- seleccionamos el vértice actual
							skinMorphMod.moveVerts [0,0,0]				-- al mover el vértice lo añadimos al morph y coge el índice correcto
 							--skinMorphMod.update()
							skinMorphMod.boneSetMorphVecInParentSpace _bone numMorph k _vertPos
						)
					)
				)
				else
				(
					append _notLoadedBones _boneName
				)
			)
				
			_skinMorphLoaded = true
			--print (timestamp() - _t)
			--elimina el editmesh añadido
			if _editMeshMod != undefined then 
				deleteModifier _node _editMeshMod
			
			--al final se dejan los modificadores como estaban
			this.setModsState _modifiersStateList

			_node.isfrozen = _isFrozenBackup --restaura el estado de congelado del objeto

			if _notLoadedBones.count != 0 then
			(
				_message = "No se han encontrado algunos huesos en la escena:"
				for _nlb in _notLoadedBones do _message += "\n" + _nlb
				lb.message.show _message type:#message pos:undefined size:[300,75] modal:true
			)
			
			_skinMorphLoaded	
		),-- loadSkinMorph

		-------------------------------------------------------------------------------------
		-- Salta al hueso padre de la jerarquia de skin, dentro del modificador skin
		-------------------------------------------------------------------------------------
		fn jumpToParentSkinBone skinMod =
		(
			--pone el modificador de skin activo, si no lo estaba ya------------------------
			if getCommandPanelTaskMode() != #modify then
				setCommandPanelTaskMode mode:#modify
					
			if modPanel.getCurrentObject() != skinMod then
			(
				modPanel.setCurrentObject skinMod
				subobjectLevel = 1
				skinMod.envelopesAlwaysOnTop = on
			)
			------------------------------------------------------------------------------------
				
			currentBoneIndex = skinOps.GetSelectedBone skinMod
			currentBoneName = this.getBoneName skinMod currentBoneIndex
			
			--obtiene el hueso actualmente seleccionado en skin
			currentBone = execute ("$'" + currentBoneName + "'")
			
			if currentBone != undefined then --si ha obtenido un hueso seleccionado
			(
				stop = false --flag para parar el bucle cuando no interese
				auxBone = currentBone
				
				
				--busca el primer hueso que encuentre por encima de el en la jerarquia y que ademas esté incluido en el skin
				while not stop do
				(
					auxBoneVparent = lb.rig.getVirtualParent auxBone --obtiene el virtualParent
					if not isValidNode auxBoneVparent then --si no tenia padre virtual
						auxBone = auxBone.parent --obtiene el hueso padre del seleccionado. hueso con el que trabajar
					else
						auxBone = auxBoneVparent		
					
					if auxBone != undefined then --si ha obtenido un hueso padre lo busca en el skin
					(
						--busca el hueso en el modificador de skin
						for i=1 to (skinOps.GetNumberBones skinMod) where auxBone.name == (this.getBoneName skinMod i) do
						(
							skinOps.SelectBone skinMod i --selecciona el hueso en el modificador de skin
							stop = true --activa el flag de parada
						)
						
						--if not stop then auxBone = auxBone.parent --
					)
					else stop = true
				)--while
					
			)--if currentBone
			
		),-- jumpToParentSkinBone

		-------------------------------------------------------------------------------------
		-- Salta al hueso padre de la jerarquia de skin, dentro del modificador skin
		-------------------------------------------------------------------------------------
		fn jumpToChildrenSkinBone skinMod =
		(
			--pone el modificador de skin activo, si no lo estaba ya------------------------
			if getCommandPanelTaskMode() != #modify then
				setCommandPanelTaskMode mode:#modify
					
			if modPanel.getCurrentObject() != skinMod then
			(
				modPanel.setCurrentObject skinMod
				subobjectLevel = 1
				skinMod.envelopesAlwaysOnTop = on
			)
			------------------------------------------------------------------------------------
				
			currentBoneIndex = skinOps.GetSelectedBone skinMod
			currentBoneName = this.getBoneName skinMod currentBoneIndex
			
			--obtiene el hueso actualmente seleccionado en skin
			currentBone = execute ("$'" + currentBoneName + "'")
			
			if currentBone != undefined then --si ha obtenido un hueso seleccionado
			(
				stop = false --flag para parar el bucle cuando no interese
				auxBone = currentBone
				hLevels = lb.rig.getHierarchySubLevelsFromNode currentBone
				
				--busca el primer hueso que encuentre por encima de el en la jerarquia y que ademas esté incluido en el skin
				cont = 2
				if hLevels.count < 2 then stop = true --si no hay mas que  un nivel no hace nada
				while not stop and cont <= hLevels.count do
				(
					
					--busca el hueso en el modificador de skin
					for obj in hLevels[cont] where not stop do
						for i=1 to (skinOps.GetNumberBones skinMod) where (obj.name == (this.getBoneName skinMod i)) and not stop do
						(
							skinOps.SelectBone skinMod i --selecciona el hueso en el modificador de skin
							stop = true --activa el flag de parada
						)
					
					cont += 1
				)--while
					
			)--if currentBone
			
		),-- jumpToChildrenSkinBone

		-------------------------------------------------------------------------------------
		-- Salta al siguiente hueso hermano de la jerarquia de skin, dentro del modificador skin
		-------------------------------------------------------------------------------------
		fn jumpToBrotherSkinBoneR skinMod =
		(
			--pone el modificador de skin activo, si no lo estaba ya------------------------
			if getCommandPanelTaskMode() != #modify then
				setCommandPanelTaskMode mode:#modify
					
			if modPanel.getCurrentObject() != skinMod then
			(
				modPanel.setCurrentObject skinMod
				subobjectLevel = 1
				skinMod.envelopesAlwaysOnTop = on
			)
			------------------------------------------------------------------------------------
				
			currentBoneIndex = skinOps.GetSelectedBone skinMod
			currentBoneName = this.getBoneName skinMod currentBoneIndex
			
			--obtiene el hueso actualmente seleccionado en skin
			currentBone = execute ("$'" + currentBoneName + "'")
			
			if currentBone != undefined then --si ha obtenido un hueso seleccionado
			(
				stop = false --flag para parar el bucle cuando no interese
				auxBone = currentBone
				
				--busca el primer hueso que encuentre por encima de el en la jerarquia y que ademas esté incluido en el skin
				subLevel = 1 --para saber en que nivel de subjerarquia a partir del antecesor se encuentra el nodo actual y sus posibles hermanos
				while not stop do
				(
					auxParent = lb.rig.getVirtualParent auxBone --obtiene el virtualParent
					if not isValidNode auxParent then --si no tenia padre virtual
						auxBone = auxBone.parent --obtiene el hueso padre del seleccionado. hueso con el que trabajar
					else
						auxBone = auxParent		
					
					if auxBone != undefined then --si ha obtenido un hueso padre obtiene susu hijos hasta el nivel que toque
					(
						subLevel += 1 --incrementa el subnivel en el que buscar
						brothers = lb.rig.getHierarchySubLevelsFromNode auxBone depth:subLevel
						
						--busca el hueso en el modificador de skin
						index = findItem brothers[subLevel] currentBone
						if index != 0 then
						(
							for i=(index + 1) to brothers[subLevel].count where not stop do
								for j=1 to (skinOps.GetNumberBones skinMod) where brothers[subLevel][i].name == (this.getBoneName skinMod j) do
								(
									skinOps.SelectBone skinMod j --selecciona el hueso en el modificador de skin
									stop = true --activa el flag de parada
								)
							
							if not stop then
								for i=1 to (index - 1) where not stop do
									for j=1 to (skinOps.GetNumberBones skinMod) where brothers[subLevel][i].name == (this.getBoneName skinMod j) do
									(
										skinOps.SelectBone skinMod j --selecciona el hueso en el modificador de skin
										stop = true --activa el flag de parada
									)
						)
						--else stop = true
						
					)
					else stop = true
				)--while
				
			)--if currentBone
		),

		-------------------------------------------------------------------------------------
		-- Salta al anterior hueso hermano de la jerarquia de skin, dentro del modificador skin
		-------------------------------------------------------------------------------------
		fn jumpToBrotherSkinBoneL skinMod =
		(
			--pone el modificador de skin activo, si no lo estaba ya------------------------
			if getCommandPanelTaskMode() != #modify then
				setCommandPanelTaskMode mode:#modify
					
			if modPanel.getCurrentObject() != skinMod then
			(
				modPanel.setCurrentObject skinMod
				subobjectLevel = 1
				skinMod.envelopesAlwaysOnTop = on
			)
			------------------------------------------------------------------------------------
				
			currentBoneIndex = skinOps.GetSelectedBone skinMod
			currentBoneName = this.getBoneName skinMod currentBoneIndex
			
			--obtiene el hueso actualmente seleccionado en skin
			currentBone = execute ("$'" + currentBoneName + "'")
			
			if currentBone != undefined then --si ha obtenido un hueso seleccionado
			(
				stop = false --flag para parar el bucle cuando no interese
				auxBone = currentBone
				
				--busca el primer hueso que encuentre por encima de el en la jerarquia y que ademas esté incluido en el skin
				subLevel = 1 --para saber en que nivel de subjerarquia a partir del antecesor se encuentra el nodo actual y sus posibles hermanos
				while not stop do
				(
					auxParent = lb.rig.getVirtualParent auxBone --obtiene el virtualParent
					if not isValidNode auxParent then --si no tenia padre virtual
						auxBone = auxBone.parent --obtiene el hueso padre del seleccionado. hueso con el que trabajar
					else
						auxBone = auxParent		
					
					if auxBone != undefined then --si ha obtenido un hueso padre obtiene susu hijos hasta el nivel que toque
					(
						subLevel += 1 --incrementa el subnivel en el que buscar
						brothers = lb.rig.getHierarchySubLevelsFromNode auxBone depth:subLevel
						
						--busca el hueso en el modificador de skin
						index = findItem brothers[subLevel] currentBone
						if index != 0 then
						(
							for i=(index - 1) to 1 by -1 where not stop do
								for j=1 to (skinOps.GetNumberBones skinMod) where brothers[subLevel][i].name == (this.getBoneName skinMod j) do
								(
									skinOps.SelectBone skinMod j --selecciona el hueso en el modificador de skin
									stop = true --activa el flag de parada
								)
							
							if not stop then
								for i=brothers[subLevel].count to (index + 1) by -1 where not stop do
									for j=1 to (skinOps.GetNumberBones skinMod) where brothers[subLevel][i].name == (this.getBoneName skinMod j) do
									(
										skinOps.SelectBone skinMod j --selecciona el hueso en el modificador de skin
										stop = true --activa el flag de parada
									)
						)
						--else stop = true
						
					)
					else stop = true
				)--while
				
			)--if currentBone
		),

		-------------------------------------------------------------------------------------
		-- Salta al anterior hueso hermano de la jerarquia de skin, dentro del modificador skin
		-------------------------------------------------------------------------------------
		fn jumpToOppositeSkinBone skinMod =
		(
			--pone el modificador de skin activo, si no lo estaba ya------------------------
			if getCommandPanelTaskMode() != #modify then
				setCommandPanelTaskMode mode:#modify
					
			if modPanel.getCurrentObject() != skinMod then
			(
				modPanel.setCurrentObject skinMod
				subobjectLevel = 1
				skinMod.envelopesAlwaysOnTop = on
			)
			------------------------------------------------------------------------------------
				
			currentBoneIndex = skinOps.GetSelectedBone skinMod
			currentBoneName = this.getBoneName skinMod currentBoneIndex
			
			--obtiene el hueso actualmente seleccionado en skin
			currentBone = execute ("$'" + currentBoneName + "'")
			
			if currentBone != undefined then --si ha obtenido un hueso seleccionado
			(
				op = lb.rig.getOppositeObject currentBone --obtiene el hueso opuesto
				
				if op != undefined then --si ha obtenido un hueso padre lo busca en el skin
					for i=1 to (skinOps.GetNumberBones skinMod) where op.name == (this.getBoneName skinMod i) do --busca el hueso en el modificador de skin
						skinOps.SelectBone skinMod i --selecciona el hueso en el modificador de skin
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
		
	)--lib_skin
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_skin() --crea la libreria
)