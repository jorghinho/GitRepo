------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta meatSlicer.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta meatSlicer.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "meatSlicer"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 245		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 550		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local meatObj = undefined		-- 	objeto a cortar
		local bonesToAssign = #()		-- 	listado de huesos para repartir
		local pickObjectsErrorMsg = "You must select meat to slice and a root bone first"
		local puppetMat	=	undefined	--	material del puppet

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		groupBox grpSourceObjects "Source objects" pos:[5,5] width:235 height:215
		pickbutton btnMeatToSlice "<Meat to slice>" pos:[10,25] width:225 height:25 filter:rollMainDef.GeometryFilter autoDisplay:true
			
		dotNetControl lvBones "System.Windows.Forms.ListView" pos:[10,55] width:225 height:135
		checkbutton btnPickBone "Pick" pos:[10,190] width:40 height:25 toolTip:"Pick bones in viewport"
		button btnAddBone "Add" pos:[50,190] width:40 height:25 toolTip:"Add bones selecting by name"
		button btnAddSelectedBones "Add sel." pos:[90,190] width:45 height:25 toolTip:"Add bones selected in viewport"
		button btnRemoveBone "Delete" pos:[145,190] width:45 height:25 toolTip:"Delete selected bones in list"
		button btnRemoveSelectedBones "Del. sel." pos:[190,190] width:45 height:25 toolTip:"Delete bones selected in viewport"
		
		groupBox grpAssignment "Assignment" pos:[5,225] width:235 height:55
		groupBox grpAssignment2 "" pos:[5,273] width:235 height:147
		button btnLoadIDs "Load IDs" pos:[10,245] width:110 height:25
		button btnSaveIDs "Save IDs" pos:[125,245] width:110 height:25
		label lblOperateOn "Operate on" pos:[10,290] width:55 height:15
		radiobuttons rdoOperateOn "" pos:[75,290] width:164 height:16 enabled:true labels:#("Elements", "Poligons") columns:2
		button btnCalculate "Calculate" pos:[10,310] width:225 height:30
		button btnNewColors "New colors" pos:[10,340] width:110 height:25
		button btnBoneColors "Bone colors" pos:[120,340] width:115 height:25
		
		label lblAssignSelected "Assign selected faces to:" pos:[10,370] width:125 height:15
		pickbutton btnReassign "<not defined>" pos:[9,388] width:155 height:25 filter:rollMainDef.boneFilter autoDisplay:true
		button btnRepeatReassign "Repeat" pos:[169,388] width:65 height:25
		groupBox grpSlice "Slice" pos:[5,425] width:235 height:95
		button btnSlice "Slice" pos:[15,463] width:75 height:45
		radiobuttons rdoSliceOptions "" pos:[100,463] width:127 height:48 labels:#("Attach slices to bones", "Link slices to bones", "Do nothing")
		
		progressBar pbCalculate "" pos:[5,525] width:235 height:20	

		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | getClosestObjectIndex | devuelve el índice del objeto más cercano contenido en el listado OBJLIST al número de polígono del objeto OBJ.
		------------------------------------------------
		fn getClosestObjectIndex obj pos objList =
		(
			_closestObjIndex = undefined	-- objeto más cercano encontrado
			
			(
				_dist = 100000000	-- iniciamos la distancia a un valor máximo
				
				for i = 1 to puppetMat.materialList.count do
				(
					_boneName = puppetMat.materialList[i].name
					boneObject = objList[i]
					
					if (boneObject != undefined) and not (isDeleted boneObject) then
					(
						_d = distance pos boneObject.center
						
						if _d < _dist then
						(
							_dist = _d
							_closestObjIndex = puppetMat.materialIDList[i]
						)
					)
				)
			)
			
			_closestObjIndex
		)

		------------------------------------------------
		--@fn: undefined | getIdFromPuppetMat | Devuelve el ID de material del puppetMat que corresponde al hueso BONEOBJECT
		------------------------------------------------
		fn getIdFromPuppetMat boneObject =
		(
			_id = 0
			
			for i = 1 to puppetMat.materialList.count do
			(
				_n = puppetMat.materialList[i].name
				if _n == boneObject.name then _id = puppetMat.materialIDList[i]
			)
			
			_id
		)

		------------------------------------------------
		--@fn: undefined | getPuppetMaterial | devuelve el material PUPPET si existe en la escena. Si no UNDEFINED
		------------------------------------------------
		fn getPuppetMaterial =
		(
			sceneMaterials[#puppet]
		)

		------------------------------------------------
		--@fn: undefined | getBonesFromMaterial | Devuelve los huesos que están asociados al material puppet pasado en MAT
		------------------------------------------------
		fn getBonesFromMaterial mat = 
		(
			_boneList = #()
			
			for m in mat.materialList do
			(
				obj = execute ("$'" + m.name  + "'")
				
				if (n != "") and (obj != undefined) then appendIfUnique _boneList obj
			)
			
			_boneList
		)

		------------------------------------------------
		--@fn: undefined | getSelectedFaces | devuelve los polígonos seleccionados en el objeto OBJ
		------------------------------------------------
		fn getSelectedFaces obj = 
		(
			_faces = #{}
			if (classof obj == editable_poly) or (classof obj == PolyMeshObject) then
				_faces = polyOp.getFaceSelection obj
			
			if (classof obj == editable_mesh) then
				_faces = getFaceSelection obj
			
			_faces
		)

		------------------------------------------------
		--@fn: undefined | getAllChildren | captura el número total de huesos para los que hay que repartir la geometría
		------------------------------------------------
		fn getAllChildren obj = 
		(
			_children = #()
			
			_currentChildren = (lb.rig.getVirtualChildren obj)
			
			for o in _currentChildren do
			(
				if not o.isHidden and superclassof o == geometryclass then appendifunique _children o
				join _children (getAllChildren o)
			)
			
			_children
		)
		
		------------------------------------------------
		--SETS
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | setControlsState | habilita o inhabilita los controles que dependen de que se haya seleccionado un objeto a cortar. El estado se indica en STATE.
		------------------------------------------------
		fn setControlsState state =
		(
			btnLoadIDs.enabled = btnSaveIDs.enabled =  state
			rdoOperateOn.enabled = btnCalculate.enabled = btnNewColors.enabled = btnBoneColors.enabled = state
			btnReassign.enabled = btnRepeatReassign.enabled = state
		)

		------------------------------------------------
		--@fn: undefined | setMatIdToFace | aplica el ID de material indicado al polígono número FACENUMBER del objeto OBJ, FACENUMBER puede ser un número o un bitarray.
		------------------------------------------------
		fn setMatIdToFace obj faceNumber ID = 
		(
			if classof obj == editable_poly or classof obj == PolyMeshObject then
			(
				polyop.setFaceMatId obj faceNumber ID
			)
			
			if classof obj == editable_mesh then
			(
				setfacematid obj faceNumber ID
			)
		)

		------------------------------------------------
		--@fn: undefined | setPuppetMatDiffuseColors | asigna colores aleatorios al canal difuso de los submateriales del multimaterial MAT
		------------------------------------------------
		fn setPuppetMatDiffuseColors mat type = 
		(
			for m in mat.materiallist do
				case type of
				(
					#random: m.diffuse = (color (random 0 255) (random 0 255) (random 0 255))
					#bone: 
					(
						_boneName = m.name
						_boneObject = execute ("$'" + _boneName + "'")
						if _boneObject != undefined then m.diffuse = _boneObject.wirecolor
					)
				)
		)

		------------------------------------------------
		--OTHER
		------------------------------------------------
		------------------------------------------------
		--@fn: undefined | geometryFilter | Si el objeto OBJ es de tipo geométrico devuelve TRUE. Si no FALSE
		------------------------------------------------
		fn geometryFilter obj = 
		(
			((classof obj == editable_poly) or (classof obj == polyMeshObject)) and (obj.modifiers.count == 0)
		)

		------------------------------------------------
		--@fn: undefined | boneFilter | Si el objeto OBJ es de tipo bone devuelve TRUE. Si no FALSE
		------------------------------------------------
		fn boneFilter obj = 
		(
			((classof obj.baseObject == BoneGeometry) or (classof obj.baseObject == Biped_Object))
		)
		
		
		------------------------------------------------
		--@fn: undefined | initListView | Inicia las propiedades del listado de huesos
		------------------------------------------------
		fn initListView =
		(
			lvBones.clear()
			
			lvBones.gridLines = lvBones.fullRowSelect = true
			lvBones.View = (dotNetClass "System.Windows.Forms.View").details
			lvBones.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lvBones.headerStyle = (dotnetclass "System.Windows.Forms.ColumnHeaderStyle").clickable
			lvBones.backcolor = nonSelBackColor
			lvBones.gridLines = false
			lvBones.scrollable = true
			lvBones.multiSelect = true
			
			lvBones.Columns.add "Bones" 173
			lvBones.Columns.add "ID" 35
			lvBones.labelEdit = true
		)

		------------------------------------------------
		--@fn: undefined | refreshBonesList | Actualiza el listado de huesos asignados según la variable bonesToAssign
		------------------------------------------------
		fn refreshBonesList =
		(
			--qsort bonesToAssign compareObjNames	-- ordenamos alfabéticamente los huesos según su nombre
			lvBones.items.clear()
			
			for b in bonesToAssign do
			(
				lvItem = lvBones.items.add b.name
				if puppetMat != undefined then
				(
					ID = getIdFromPuppetMat b
					lvItem.subitems.add (ID as string)
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | assignFacesToBone | asigna los polígonos FACELIST del objeto OBJ al hueso BONEOBJECT
		------------------------------------------------
		fn assignFacesToBone obj faceList boneObject = 
		(
			_index  = finditem bonesToAssign boneObject
				
			if _index != 0 then
			(
				ID = puppetMat.materialIDlist[_index]
				setMatIdToFace meatObj (getSelectedFaces meatObj) ID
			)
			else
				messageBox "Can't find selected bone in current hierarchy"
		)

		------------------------------------------------
		--@fn: undefined | objectsPicked | devuelve true o false indicando si se han seleccionado los objetos con los que hay que operar (meat y rootBone).
		------------------------------------------------
		fn objectsPicked =
		(
			(btnMeatToSlice.object != undefined)
		)

		------------------------------------------------
		--@fn: undefined | boneFilterIgnoreAssigned | Si el objeto OBJ es de tipo bone devuelve TRUE. Si no FALSE
		------------------------------------------------
		fn boneFilterIgnoreAssigned obj = 
		(
			(boneFilter obj) and (finditem bonesToAssign obj == 0)
		)

		------------------------------------------------
		--@fn: undefined | refreshBonesList | devuelve un multiMaterial con el número de submateriales indicados en NUMSUBMATERIALS. Cada submaterial tiene un color distinto a los demás. 
		------------------------------------------------
		fn createPuppetMaterial numSubMaterials = 
		(
			_mat = multiMaterial name:"puppet" numsubs:numSubMaterials
			
			--	asignamos a cada ID el color y nombre del hueso correspondiente
			for i = 1 to bonesToAssign.count do 
			(
				_mat.materialList[i].diffuseColor = bonesToAssign[i].wirecolor
				_mat.materialList[i].name = bonesToAssign[i].name
			)
			
			_mat
		)

		------------------------------------------------
		--@fn: undefined | updatePuppetMaterial | Actualiza el puppetMat con los nuevos huesos que se hayan podido añadir o quitar del listado
		------------------------------------------------
		fn updatePuppetMaterial =
		(
			if puppetMat != undefined then
			(
				_boneNames = for b in bonesToAssign collect b.name
				_puppetMatNames = for m in puppetMat.materialList collect m.name
				
				--	añadido de nuevos huesos
				for b in bonesToAssign do
				(
					_bName = b.name
					_index = findItem _puppetMatNames _bName
					
					--	si no encontramos un ID para el hueso, añadimos un submaterial más excepto si 
					-- 	solo hay un submaterial que aún no está en uso. Si es así usamos ese para el nuevo hueso
					if _index == 0 then
					(
						if puppetMat.materialList.count == 1 and (findItem _boneNames puppetMat.materialList[1].name == 0) then
						(
							puppetMat.materialList[1].name = _bName
							puppetMat.materialList[1].diffuseColor = b.wirecolor
						)
						else
						(
							--	calculamos el nuevo ID para el material
							_newID = 1
							_found  = false
							while not _found and _newID < 8888 do
							(
								if findItem puppetMat.materialIDlist _newID == 0 then
									_found = true
								else
									_newID += 1
							)
							
							--	creamos el nuevo material con el nuevo ID y su etiqueta correspondiente
							puppetMat.numSubs =  puppetMat.materialList.count + 1
							_matNum = puppetMat.materialList.count
							puppetMat.materialList[_matNum] = standardMaterial diffuseColor:b.wirecolor
							puppetMat.materialIDList[_matNum] = _newID
							puppetMat.materialList[_matNum].name = _bName
						)
					)
				)
				
				--	eliminado de huesos que ya no existen.
				for i = puppetMat.materialList.count to 1 by -1 do
				(
					if findItem _boneNames puppetMat.materialList[i].name == 0 then
					(
						_matNum = puppetMat.materialList.count
						
						--	si solo queda un submaterial le eliminamos la etiqueta
						if _matNum == 1 then puppetMat.materialList[1].name = ""
						
						--	eliminamos el submaterial y movemos el resto de submateriales una posición hacia arriba
						for j = i to (_matNum - 1) do 
						(
							puppetMat.materialList[j] = puppetMat.materialList[j+1]
							puppetMat.materialIDlist[j] = puppetMat.materialIDlist[j+1]
						)
						
						puppetMat.numSubs = _matNum - 1
					)
				)
			)
		)
		
		------------------------------------------------
		--@fn: undefined | assignIDsToObject | asigna a cada polígono del objeto OBJ un ID de material correspondiente al número de hueso del array BONELIST
		------------------------------------------------
		fn assignIDsToObject obj boneList =
		(
			obj.material = puppetMat
			_cancelOperation = false
			
			--	operamos en elementos
			if rdoOperateOn.state == 1 then
			(
				facesArray = #{1..obj.faces.count}
				while not facesArray.isEmpty and not _cancelOperation do
				(
					--	seleccionamos el elemento
					_faceIndex = (facesArray as array)[1]
					setFaceSelection obj #{_faceIndex}
					obj.convertselection #face #element
					_selFaces = getFaceSelection obj
					
					--	calculamos la posición central del elemento
					centerPos = [0,0,0]
					for numFace in _selFaces do
						centerPos += polyop.getfacecenter obj numFace
					centerPos /= _selFaces.numberSet
					
					--	buscamos el objeto más cercano y asignamos el ID que corresponda
					_closestObjIndex = getClosestObjectIndex obj centerPos boneList
					if _closestObjIndex != undefined then
						for numFace in _selFaces do
							setMatIdToFace obj numFace _closestObjIndex
					
					--	Actualizamos el listado de polígonos pendientes.
					--	Si por cualquier motivo no se ha creado una selección, 
					-- 	eliminamos el polígono actual del listado.
					facesArray -= _selFaces
					if _selFaces.numberSet == 0 then facesArray -= #{_faceIndex}
					
					pbCalculate.value = (obj.faces.count - facesArray.numberSet) * 100 / obj.faces.count
					
					if keyboard.escPressed then 
						if querybox "Assignment is not complete.\nReally cancel operation?" then _cancelOperation = true
				)
			)
			--	operamos en polígonos
			else 	
			(
				
				for i = 1 to obj.faces.count where not _cancelOperation do
				(
					pbCalculate.value = i * 100 / obj.faces.count
					centerPos = polyop.getfacecenter obj i
					_closestObjIndex = getClosestObjectIndex obj centerPos boneList
					
					if _closestObjIndex != undefined then
						setMatIdToFace obj i _closestObjIndex
					
					if keyboard.escPressed then
						if querybox "Assignment is not complete.\nReally cancel operation?" then _cancelOperation = true
				)
			)
			
			pbCalculate.value = 0
		)

		------------------------------------------------
		--@fn: undefined | loadBoneAssignments | carga las asociaciones de cada polígono a cada hueso
		------------------------------------------------
		fn loadBoneAssignments filename IDsObject =
		(
			_f = fopen filename "rb"
			
			if _f != undefined then
			(
				setWaitCursor()
				
				--	leemos la versión del formato del fichero
				formatVersion = readString _f
				
				--	leemos el número de huesos y de polígonos almacenados
				_numBones = readShort _f
				_numPolygons = readLong _f
				
				--	creamos el multimaterial para el objeto si no estaba ya creado
				if puppetMat == undefined then 
					puppetMat =  multiMaterial numsubs:1 name:"puppet"
				
				IDsObject.material = puppetMat
				bonesToAssign = #()
				
				--	leemos los nombres de todos los huesos
				--	y sus asignaciones de polígonos
				for i = 1 to _numBones do
				(
					--	leemos el nombre del hueso y comprobamos si está en la escena
					_boneName = readString _f 
					_boneObject = execute ("$'" + _boneName + "'")
					
					--	leemos el color asignado al submaterial
					diffuseColor = [readShort _f, readShort _f, readShort _f]
					
					--	leemos el número de polígonos que usan el ID de ese hueso
					_numPolygonsUsingID = readLong _f
					
					--	si hemos encontrado el hueso en la escena lo tratamos
					if _boneObject != undefined then
					(
						append bonesToAssign _boneObject
						
						updatePuppetMaterial()
						
						puppetMat.materialList[bonesToAssign.count].diffuseColor = diffuseColor
					)
					
					--	leemos el número de cada polígono usando el ID actual y 
					--	lo asignamos solo si existe el hueso en la escena
					for j = 1 to _numPolygonsUsingID do
					(
						--	leemos el número de polígono
						_numPolygon = readLong _f 
						
						--	leemos la posición del polígono
						posPolygon = [readDouble _f, readDouble _f, readDouble _f]
						
						if _boneObject != undefined then
							setMatIDtoFace IDsObject _numPolygon bonesToAssign.count
					)
				)
				
				refreshBonesList()
				
				setArrowCursor()
				fclose _f
			)
		)

		------------------------------------------------
		--@fn: undefined | saveBoneAssignments | guarda las asociaciones de cada polígono a cada hueso, Devuelve TRUE o FALSE dependiendo de si se guardó o no el fichero
		------------------------------------------------
		fn saveBoneAssignments filename IDsObject =
		(
			if (createfile filename) != undefined then
			(
				setWaitCursor()
				
				_f = fopen filename "wb"
				
				-- Escribimos la versión del formato de fichero
				writestring _f "formatVersion=1"
				
				_numBones = puppetMat.materialList.count
				_numPolygons = IDsObject.faces.count
				
				writeshort _f _numBones 		-- escribimos el número total de vértices de la geometría
				writeLong _f _numPolygons	-- escribimos el número total de polígonos
				
				--	escribimos los nombres de todos los huesos
				--	y los números de polígono asociados
				for i = 1 to _numBones do
				(
					--	escribimos el nombre del hueso
					writeString _f puppetMat.materialList[i].name
					
					--	escribimos el color difuso
					writeShort _f puppetMat.materialList[i].diffuseColor.r
					writeShort _f puppetMat.materialList[i].diffuseColor.g
					writeShort _f puppetMat.materialList[i].diffuseColor.b
					
					IDsObject.baseObject.selectByMaterial i
					_polygonsUsingID = polyop.getFaceSelection IDsObject.baseObject
					
					--	escribimos el número de polígonos que usan el ID actual
					writeLong _f _polygonsUsingID.numberSet
					
					--	escribimos el número de cada polígono que usa el ID actual
					for _numPolygon in _polygonsUsingID do
					(
						--	escribimos el número del polígono
						writeLong _f _numPolygon
						
						--	escribimos la posición del polígono
						polygonPos =  polyOp.getFaceCenter IDsObject.baseobject _numPolygon
						writeDouble _f polygonPos.x
						writeDouble _f polygonPos.y
						writeDouble _f polygonPos.z
					)
				)
				
				setArrowCursor()
				fclose _f
			)
		)

		------------------------------------------------
		--@fn: undefined | compareObjNames | Indica si alfabéticamente el nombre del objeto OBJ1 es mayor, menor o igual que OBJ2 devolviendo 1, -1 o 0 respectivamente
		------------------------------------------------
		fn compareObjNames obj1 obj2 = 
		(
			_n1 = obj1.name
			_n2 = obj2.name
			
			case of
			(
				(_n1 > _n2):	1
				(_n1 < _n2):	-1
				default:		0
			)
		)

		------------------------------------------------
		--@fn: undefined | exportMeshToObj | Exporta la malla picada a obj y la vuelve a importar para dejarla totalmente limpia de cualquier error posible y evitar que se bloqueé la herramienta.
		------------------------------------------------
		fn exportMeshToObj =
		(
			-- Capturamos la malla para exportar la selección.
			select btnMeatToSlice.object
			exportFile (GetDir #temp + "/meatSlicer_exportObjTemp") #noPrompt selectedOnly:true using:exporterPlugin.classes[17] 
			
			_objLyr = (btnMeatToSlice.object).layer
			
			-- Borramos el objeto original para evitar duplicados
			_objTemp = btnMeatToSlice.object
			delete _objTemp
			
			importFile (GetDir #temp + "/meatSlicer_exportObjTemp.obj") #noPrompt
			
			meatObj = (getCurrentSelection())[1]
			btnMeatToSlice.object = (getCurrentSelection())[1]
				
			_objLyr.addNode meatObj	
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(	
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
		)
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		on btnMeatToSlice picked obj do
		(
			meatObj = obj
			puppetMat = getPuppetMaterial()
			
			setControlsState (obj != undefined)
			
			if puppetMat == undefined then 
			(
				bonesToAssign = #()
				puppetMat = createPuppetMaterial 1
				meatObj.material = puppetMat
			)
			else
			(
				bonesToAssign = getBonesFromMaterial puppetMat
			)
			
			refreshBonesList()
		)
		
		--------------------------------------------------------------------------------------
		on lvBones doubleClick events do
		(
			index =  lvBones.selectedItems.item[0].index + 1
			undo "Select bone" on
			(
				clearSelection()
				select bonesToAssign[index]
			)
		)
		
		--------------------------------------------------------------------------------------
		on btnPickBone changed state do
		(
			if state then
			(
				_continuePicking = true
				
				while _continuePicking do
				(
					_obj = pickobject filter:boneFilterIgnoreAssigned
					
					if _obj != undefined and _obj != #escape then
					(
						append bonesToAssign _obj
						updatePuppetMaterial()
						refreshBonesList()
					)
					else
						_continuePicking = false
				)
				
				btnPickBone.checked = false
			)
		)
		
		--------------------------------------------------------------------------------------
		on btnAddBone pressed do
		(
			_objs = selectByName filter:boneFilterIgnoreAssigned
			
			if _objs != undefined then
				for o in _objs do
				(
					append bonesToAssign o
				)
			
			updatePuppetMaterial()
			refreshBonesList()
		)
		
		--------------------------------------------------------------------------------------
		on btnAddSelectedBones pressed do
		(
			for o in selection where (boneFilterIgnoreAssigned o) do
			(
				append bonesToAssign o
			)
			
			updatePuppetMaterial()
			refreshBonesList()
		)
		
		--------------------------------------------------------------------------------------
		on btnRemoveBone pressed do
		(
			for i = lvBones.SelectedItems.count to 1 by -1 do
			(
				index = (lvBones.selectedItems.item[i-1].index + 1)
				deleteItem bonesToAssign index
			)
			
			updatePuppetMaterial()
			refreshBonesList()
		)
		
		--------------------------------------------------------------------------------------
		on btnRemoveSelectedBones pressed do
		(
			_bonesDeleted = false
			for o in selection do
			(
				_index = finditem bonesToAssign o
				if _index != 0 then 
				(
					deleteItem bonesToAssign _index
					_bonesDeleted = true
				)
			)
			
			if _bonesDeleted then 
			(
				updatePuppetMaterial()
				refreshBonesList()
			)
		)
		
		--------------------------------------------------------------------------------------
		on btnLoadIDs pressed do
		(
			_filename = getOpenFileName caption:"Load IDs" types:"Puppet Assignments (*.pas)|*.pas" 
			
			if _filename != undefined then
				loadBoneAssignments _filename meatObj 
		)
		
		--------------------------------------------------------------------------------------
		on btnSaveIDs pressed do
		(
			_filename = getSaveFileName caption:"Save IDs" types:"Puppet Assignments (*.pas)|*.pas" 
			
			if _filename != undefined then
				saveBoneAssignments _filename meatObj 
		)
		
		
		--------------------------------------------------------------------------------------
		on btnCalculate pressed do
		(
			if objectsPicked() then
			(
				_obj = btnMeatToSlice.object
				_obj.unhideAll #Face	--	nos aseguramos de que no hay polígonos ocultos en la geometría
				
				undo "Calculate ID Assignment" on
				(
					assignIDsToObject _obj bonesToAssign
				)
				
			--gc light:true
			)
			else
				messageBox pickObjectsErrorMsg
		)
		
		--------------------------------------------------------------------------------------
		on btnNewColors pressed do
		(
			if (classof meatObj.material == multimaterial) then
				setPuppetMatDiffuseColors meatObj.material #random
		)
		
		--------------------------------------------------------------------------------------
		on btnBoneColors pressed do
		(
			if (classof meatObj.material == multimaterial) then
				setPuppetMatDiffuseColors meatObj.material #bone
		)
		
		--------------------------------------------------------------------------------------
		on btnReassign picked boneObject do
		(
			if objectsPicked() then
			(
				undo "Reassign Faces" on
				(
					assignFacesToBone meatObj (getSelectedFaces meatObj) boneObject
				)
			)
			else
			(
				btnReassign.object = undefined
				messageBox pickObjectsErrorMsg
			)
		)
		
		--------------------------------------------------------------------------------------
		on btnRepeatReassign pressed do
		(
			if btnReassign.object != undefined then
			(
				undo "Repat Reassign Faces" on
				(
					assignFacesToBone meatObj (getSelectedFaces meatObj) btnReassign.object
				)
			)
			else
				messageBox pickObjectsErrorMsg
		)
		
		--------------------------------------------------------------------------------------
		on btnSlice pressed do
		(
			if objectsPicked() then
			(
			--if chkExportMesh.checked then
			--objExportTemp = exportMeshToObj()
											
							if (classof meatObj == editable_poly) or (classof meatObj == polyMeshObject) then
							(
								undo "Meat Slice" on
								(
									for i = 1 to bonesToAssign.count do
									(
										pbCalculate.value = i * 100 / bonesToAssign.count
										_currentBone = bonesToAssign[i]
										
										--	seleccionamos los polígonos con los que vamos a trabajar
										meatObj.selectByMaterial i
										
										-- solo cortamos y asignamos polígonos si hay alguno asignado al hueso actual.
										if (getSelectedFaces meatObj as array).count > 0 then
										(
								-- gc light:true
								polyop.detachFaces meatObj (getSelectedFaces meatObj) name:(_currentBone.name + "_slice") delete:true asNode:true --node:newObj
								
								newObj = execute ("$'" + _currentBone.name + "_slice'")
								
								case rdoSliceOptions.state of 
								(
									1:	-- attach del nuevo objeto al hueso
									(
										-- Nos aseguramos de que está abierto el panel de modificadores
										if getCommandPanelTaskMode() != #modify then setCommandPanelTaskMode mode:#modify
										
										-- Creamos el nuevo modificador
										_m = edit_poly()
										
										-- Busca el puppet que este mas arriba en la pila de modificadores
										topPuppetIndex = lb.asset.findPuppet _currentBone
										
										-- Si el hueso ya tiene algun puppet, tiene que añadirlo encima
										if topPuppetIndex != 0 then
										(
											_puppetCount = 0 --variable para almacenar el numero de puppets que lleva el hueso
											
											--incrementa el contador por cada puppet que encuentra
											for _m in _currentBone.modifiers where findString _m.name "Puppet" != undefined do
												_puppetCount += 1
											
											_m.name = "Puppet-" + (_puppetCount as string)
											
											addModifier _currentBone _m before:(topPuppetIndex - 1)
											
											--flip de las normales de la geometria nueva
											newObj.material = undefined
											if _currentBone.objectOffsetScale.x == -1 then
 												lb.geometry.flipNormals #(newObj)
											
											-- Attach con la geometría nueva
											select _currentBone
											modpanel.setCurrentObject _currentBone.modifiers[(_m.name as name)]
									--gc light:true
											_m.setOperation #Attach
											_m.attach newObj editPolyNode:_currentBone
										)
										else -- Si el hueso no tiene puppet, se lo añade y borra el hueso del editPoly
										(
											_m.name = "Puppet"
											addModifier _currentBone _m before:(_currentBone.modifiers.count+1)
											
											-- Borrado de los polígonos originales del hueso y attach con la geometría nueva
											select _currentBone
											modpanel.setCurrentObject _currentBone.modifiers[#Puppet]
											subObjectLevel = 1
											_currentBone.modifiers[#Puppet].select #Vertex #{1.._currentBone.mesh.verts.count}
											_currentBone.modifiers[#Puppet].ButtonOp #DeleteVertex
											subobjectLevel = 0
											newObj.material = undefined
											--gc light:true
											_m.setOperation #Attach
											_m.attach newObj editPolyNode:_currentBone
											
											--	en huesos simétricos invertimos las normales
											if _currentBone.objectOffsetScale.x == -1 then
												lb.geometry.flipNormals (#(_currentBone))
										)
									
									)
									2:	-- lincaje del nuevo objeto al hueso
									(
										newObj.parent = _currentBone
									)
								)
							)
						)
						clearSelection()
						pbCalculate.value = 0
					) -- undo Meat Slice
					
					delete meatObj
				)
				else
					messageBox "Meat object must be an editable_poly."
				-- Borramos el objeto pupeado, el cual se queda vacio.
				
			)
			else
				messageBox pickObjectsErrorMsg
		)-- on btnSlice pressed
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(	
			initListView()
			setControlsState off
			loadSettings()
			createSceneEvents() --crea los callbacks

			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: meatSlicer | Contiene la herramienta meatSlicer.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_meatSlicer
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Meat Slicer",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollMain | Almacena el rollout principal de la herramienta.
			
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
		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
		------------------------------------------------
		fn isOpen =
		(
			this.opened
		),
		
		------------------------------------------------
		--@fn: undefined | refreshInterface | Refresca el interface inicial de la herramienta
		------------------------------------------------
		fn refreshInterface =
		(
			--refresca el interface de la herramienta
		),
		
		------------------------------------------------
		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
		------------------------------------------------
		fn createInterface =
		(
			--crea el interface, lo redimensiona y lo reposiciona
			createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
		------------------------------------------------
		fn destroyInterface =
		(
			destroyDialog this.rollMain --cierra la herramienta.			
		),--destroyInterface
		
		------------------------------------------------
		--@fn: undefined | run | Lanza la herramienta.
		------------------------------------------------
		fn run =
		(
			this.createInterface() --crea el interface.
			this.opened = true --indica que la herramienta está abierta
		),--execute
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
		------------------------------------------------
		fn close =
		(
			this.destroyInterface() --destruye el interface.
			this.opened = false --indica que la herramienta está cerrada.
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
			lb.addTool this --añade la tool a la libreria principal	
		)		
		
	)--tl_meatSlicer
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_meatSlicer() --crea la herramienta
)