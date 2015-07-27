------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta idsManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta idsManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "ids Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rollout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 380		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label lblSeparator01 "_______________________________________________" pos:[15,65] width:190 height:15 enabled:false
		label lblSeparator02 "_______________________________________________" pos:[15,205] width:190 height:15 enabled:false
		
		groupBox grpMatIDs "material IDs" pos:[5,5] width:210 height:135
		button btnMatIDsImport "Import" pos:[10,20] width:200 height:20 toolTip:"Imports material IDs from existing .max scene"
		
		groupBox grpMatIDsChange "" pos:[10,40] width:200 height:95
		checkButton ckbAllMaterials "All materials" pos:[15,50] width:65 height:20 
		checkButton ckbMatEditorSelected "Material editor selected" pos:[85,50] width:120 height:20 checked:true
		
		button btnMatIDsRandom "Assign Random" pos:[15,85] width:190 height:20 toolTip:"Assign random material IDs to (all or editor selected) materials and submaterials"
		button btnMatIDsToSubmats "Apply ID from mat to its submaterials" pos:[15,110] width:190 height:20 toolTip:"Assign mat ID to its submaterials"
		
		groupBox grpObjIDs "object IDs" pos:[5,145] width:210 height:230
		button btnObjIDsImport "Import" pos:[10,160] width:200 height:20 toolTip:"Imports material IDs from existing .max scene"
		
		groupBox grpObjsIDchange "" pos:[10,180] width:200 height:110
		checkButton ckbAllObjects "All Objects" pos:[15,190] width:90 height:20
		checkButton ckbSelObjects "Selected Objects" pos:[110,190] width:95 height:20 checked:true
		
		button btnObjIDsRandom "Assign Random" pos:[15,225] width:190 height:20 toolTip:"Assign random material IDs to (all/selected) scene objects"
		
		groupBox grpObjIDsSpecific "specific ID" pos:[15,250] width:190 height:35
		label lblObjID "Id:" pos:[25,265] width:15 height:15
		spinner spnObjID "" pos:[40,265] width:60 height:16 type:#integer range:[0,65535,0]
		button btnObjIDapply "Apply" pos:[105,265] width:95 height:15 toolTip:"Apply specific ID to (all/selected) Objects"
			
		groupBox grpObjIDsSelect "" pos:[10,295] width:200 height:75
		
		groupBox grpObjIDsSelectBySpecific "select objects by" pos:[15,305] width:190 height:35
		label lblObjIDselect "specific Id:" pos:[25,320] width:75 height:15
		spinner spnObjIDselect "" pos:[80,320] width:60 height:16 type:#integer range:[0,65535,0]
		button btnObjIDSelectApply "Select" pos:[145,320] width:55 height:15 toolTip:"Select scene objects with this id"
		
		button btnObjIDsSelect "Select objects with selected objs IDs" pos:[15,345] width:190 height:20 toolTip:"Select scene objects with same id than selected ones."
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | getSceneObjectsByID | Devuelve los objetos de la escena con el id pasado por parametro.Necesita el ID que preguntar.
		------------------------------------------------
		fn getSceneObjectsByID id =
		(
			lb.geometry.getSceneObjectsByID()
		)
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | assignRandomMaterialID | Reasigna IDs de material al material pasado por parametro y a sus submateriales recursivamente intentando repetir los menos posibles. forbiddenIDS: Array de ids que no quieres que se asignen.(Libreria materials)
		------------------------------------------------
		fn assignRandomMaterialID mat forbiddenIDs:#() =
		(
			lb.materials.assignRandomMaterialID mat	
		)
		
		------------------------------------------------
		--@fn: undefined | findMatNameCoincidence | Encuentra en el array de OVERWRITEINFO la primera coincidencia en nombre con el MAT material pasado por parametro y devuelve el nodo de OVERWRITEINFO que coincidia, si no coincide ninguno devuelve UNDEFINED, es una funcion recursiva.
		------------------------------------------------
		fn findMatNameCoincidence mat overWriteInfo firstLevelOnly:false =
		(
			_overWriteNodeCoincidence = undefined --variable para devolver con el nodo de informacion de material buscado
			
			_nextLevelOverWriteInfo = #() --array donde almacenar los nodos de informacion del siguiente nivel
			
			for owi in overWriteInfo do
			(
				if owi.name == mat.name then _overWriteNodeCoincidence = owi --si coincide en nombre devuelve ese nodo
				if owi.children.count != 0 then _nextLevelOverWriteInfo += owi.children --recopila los nodos hijos
			)--for
			
			--si no encuentra coincidencia mira en el siguiente nivel
			if _overWriteNodeCoincidence == undefined and _nextLevelOverWriteInfo.count != 0 and not firstLevelOnly then
				_overWriteNodeCoincidence = findMatNameCoincidence mat _nextLevelOverWriteInfo
			
			_overWriteNodeCoincidence --devuelve el nodo de informacion
		)

		------------------------------------------------
		--@fn: undefined | overWriteMateriasIDsTree | Sobreescribe los IDs del arbol de materiales empezando por el parametro pasado. Necesita MAT material raiz del arbol. Necesita OVERWRITEINFONODE que es la raiz del arbol de los nodos de informacion de materiales, para que funcione correctamente necesita los arboles coincidan. Tambien necesita que exista una variable global que se llame ASSIGNPARENTMATIDTOUNKNOWN.
		------------------------------------------------
		fn overWriteMateriasIDsTree mat overwriteInfoNode =
		(
			_success = true
			
			_subMats = lb.materials.getSubMaterials mat deepLevelLimit:1
			
			--si tienen diferente numero de submateriales no sustituye los IDs
			--if (_subMats.count != overwriteInfoNode.children.count) then _success = false
			
			--si tiene submateriales, llama a la funcion recusivamente
			if _success and ((_subMats.count != 0) and (overwriteInfoNode.children.count != 0)) then
			(
				for i=1 to _subMats.count where _success do
				(
					_owin = findMatNameCoincidence _subMats[i] overwriteInfoNode.children firstLevelOnly:true
					
					if _owin == undefined then --si encuentra coincidencia aplica el ID
					(
						if assignParentMatIDtoUnknown == #undefined then
							assignParentMatIDtoUnknown = queryBox "There are submaterials without coincidence bettween imported and current. Do you want to aplly them its parent material ID?"
						
						if assignParentMatIDtoUnknown then --si no, pregunta si aplicarle el del padre
						(
							_subMatSubMats = lb.materials.getSubMaterials _subMats[i] ignoreSelf:false
							for sbm in _subMatSubMats do sbm.effectsChannel = overwriteInfoNode.effectsChannel
						)	
					)						
					else
						_success = overWriteMateriasIDsTree (_subMats[i]) _owin
					
					--if _subMats[i].name != overwriteInfoNode.children[i].name then _success = false
					--else _success = overWriteMateriasIDsTree (_subMats[i]) (overwriteInfoNode.children[i])
				)--for
			)--if
				
			if _success then mat.effectsChannel = overwriteInfoNode.effectsChannel --sobreescribe el id de material
			
			_success
		)

		------------------------------------------------
		--@fn: undefined | overWriteMateriasIDs | Funcion que sobreescribe los id de material de los materiales pasados por parametro MATERIALSARRAY con los ids de el array de info OVERWRITEINFO.
		------------------------------------------------
		fn overWriteMateriasIDs materialsArray overWriteInfo =
		(
			_success = true
			global assignParentMatIDtoUnknown = #undefined
			
			for i=1 to materialsArray.count where _success do --recorre los materiales
			(
				_overWriteNodeCoincidence = findMatNameCoincidence materialsArray[i] overWriteInfo --busca el material del array de nodos de informacion que coincida con el actual
				_success = (overWriteMateriasIDsTree materialsArray[i] _overWriteNodeCoincidence) --sustituye los ids de ese arbol de materiales
			)--for
			
			assignParentMatIDtoUnknown = undefined
			
			_success
		)--fn overWriteMateriasIDs
				
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
				grpMatIDs.width = 210 + _increment.x
				grpMatIDsChange.pos.x = 10 + _increment.x/2
				btnMatIDsImport.pos.x = 10 + _increment.x/2
				ckbAllMaterials.pos.x = 15 + _increment.x/2
				ckbMatEditorSelected.pos.x = 85 + _increment.x/2
				lblSeparator01.pos.x = 15 + _increment.x/2
				btnMatIDsRandom.pos.x = 15 + _increment.x/2
				btnMatIDsToSubmats.pos.x = 15 + _increment.x/2
				grpObjIDs.width = 210 + _increment.x
				btnObjIDsImport.pos.x = 10 + _increment.x/2
				grpObjsIDchange.pos.x = 10 + _increment.x/2
				ckbAllObjects.pos.x = 15 + _increment.x/2
				ckbSelObjects.pos.x = 110 + _increment.x/2
				lblSeparator02.pos.x = 15 + _increment.x/2
				btnObjIDsRandom.pos.x = 15 + _increment.x/2
				grpObjIDsSpecific.pos.x = 15 + _increment.x/2
				lblObjID.pos.x = 25 + _increment.x/2 
				spnObjID.pos.x = 87 + _increment.x/2
				btnObjIDapply.pos.x = 105 + _increment.x/2
				grpObjIDsSelect.pos.x = 10 + _increment.x/2
				grpObjIDsSelectBySpecific.pos.x = 15 + _increment.x/2
				spnObjIDselect.pos.x = 127 + _increment.x/2
				btnObjIDSelectApply.pos.x = 145 + _increment.x/2
				lblObjIDselect.pos.x = 25 + _increment.x/2
				btnObjIDsSelect.pos.x = 15 + _increment.x/2
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

			--almacena settings
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "matOption" (if ckbAllMaterials.checked then "allMaterials" else "selectedMaterial")
			lb.xml.setAttribute parent.cfgFile ("rollMain/settings") "objOption" (if ckbAllObjects.checked then "allObjects" else "selectedObjects")

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

			--settings
			ckbAllMaterials.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "matOption") == "allMaterials"
			ckbMatEditorSelected.checked = not ckbAllMaterials.checked

			ckbAllObjects.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/settings") "objOption") == "allObjects"
			ckbSelObjects.checked = not ckbAllObjects.checked
				
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

		------------------------------------------------
		--@event: changed | Controla el cambio de opcion de seleccion.
		------------------------------------------------
		on ckbAllMaterials changed state do
			ckbMatEditorSelected.checked = not state
		
		on ckbMatEditorSelected changed state do
			ckbAllMaterials.checked = not state
		
		on ckbAllObjects changed state do
			ckbSelObjects.checked = not state
		
		on ckbSelObjects changed state do
			ckbAllObjects.checked = not state

		------------------------------------------------
		--@event: pressed | Carga los IDs de material de una escena en la actual.
		------------------------------------------------
		on btnMatIDsImport pressed do
		(
			_process = true --flag para saber si realizar el proceso
			_matsToWork = #() --array de materiales a los que sustituir el ID de material
			
			if ckbMatEditorSelected.checked and not matEditor.isOpen() then
			(
				_process = false --si no esta abierto el editor de materiales no deja realizar las operaciones para materiales selecionados en el
				messageBox "You have to open material editor if you want to operate in its selected materials."
			)--if ckbMatEditorSelected
			
			if _process then _matsToWork = if ckbAllMaterials.checked then (lb.materials.getSceneMaterials()) else #(meditMaterials[activeMeditSlot])
			
			--si no hay materiales con los que
			if _matsToWork.count == 0 then
			(
				_process = false --no realiza las operaciones
				messageBox "There are no materials to work with!"
			)
			
			_fileToImport = undefined
			if _process then _fileToImport = getMAXOpenFileName dir:maxFilePath --obtiene el archivo del que importar
			
			--pregunta si se quiere continuar
			if _process then _process = queryBox ((if ckbAllMaterials.checked then "All" else "Selected") + " material and its sumbaterials IDs will be overWritten, do you want to continue?")
			
			if _process then --si no hay impedimento hasta aqui
			(
				if (_fileToImport != undefined) then --si tiene archivo del que importar
				(
					--obtiene los nombres de los objetos de archivo y sus IDs
					_fileMats = getFileInfoMaterials _fileToImport
					
					--sobreescribe los ids de materiales
					_success = overWriteMateriasIDs _matsToWork _fileMats					
					
					if _success then
						messageBox "Material IDs overWritten successfully!"
					else
						messageBox "There is no coincidence between imported material info and scene material tree. Material IDs not overWritten!"
				)--if _fileToImport
			)--if _process
		)
		
		------------------------------------------------
		--@event: pressed | Asigna el de un material a todos sus submateriales.
		------------------------------------------------
		on btnMatIDsToSubmats pressed do
		(
			_process = true --flag para saber si realizar el proceso
			_matsToWork = #() --array de materiales a los que sustituir el ID de material
			
			if ckbMatEditorSelected.checked and not matEditor.isOpen() then
			(
				_process = false --si no esta abierto el editor de materiales no deja realizar las operaciones para materiales selecionados en el
				messageBox "You have to open material editor if you want to operate in its selected materials."
			)--if ckbMatEditorSelected
			
			if _process then _matsToWork = if ckbAllMaterials.checked then (lb.materials.getSceneMaterials()) else #(meditMaterials[activeMeditSlot])
			
			--si no hay materiales con los que
			if _matsToWork.count == 0 then
			(
				_process = false --no realiza las operaciones
				messageBox "There are no materials to work with!"
			)
			
			--pregunta si se quiere continuar
			if _process then _process = queryBox ((if ckbAllMaterials.checked then "All" else "Selected") + " material submaterials IDs will be overWritten with parent ID, do you want to continue?")
			
			if _process then --si no hay impedimento hasta aqui
			(
				for mat in _matsToWork do --recorre los materiales y le asigna a los submateriales el ide del padre
				(
					_matID = mat.effectsChannel --obtiene el id del material
					_subMats = lb.materials.getSubMaterials mat --obtiene los submateriales
					
					for m in _subMats do m.effectsChannel = _matID --sobreescribe el id en los materiales
				)--for
				
				messageBox "Material IDs overWritten successfully from parent material to its submaterials!"
			)--if _process
		)
		
		------------------------------------------------
		--@event: pressed | Asigna un id de material aleatorio a los materiales de la escena o al seleccionado en el editor.
		------------------------------------------------
		on btnMatIDsRandom pressed do
		(
			_process = true --flag para saber si realizar el proceso
			_matsToWork = #() --array de materiales a los que sustituir el ID de material
			
			if ckbMatEditorSelected.checked and not matEditor.isOpen() then
			(
				_process = false --si no esta abierto el editor de materiales no deja realizar las operaciones para materiales selecionados en el
				messageBox "You have to open material editor if you want to operate in its selected materials."
			)--if ckbMatEditorSelected
			
			if _process then _matsToWork = if ckbAllMaterials.checked then (lb.materials.getSceneMaterials()) else #(meditMaterials[activeMeditSlot])
			
			--si no hay materiales con los que
			if _matsToWork.count == 0 then
			(
				_process = false --no realiza las operaciones
				messageBox "There are no materials to work with!"
			)
			
			--pregunta si se quiere continuar
			if _process then _process = queryBox ((if ckbAllMaterials.checked then "All" else "Selected") + " material and its sumbaterials IDs will be overWritten, do you want to continue?")
			
			if _process then --si no hay impedimento hasta aqui
			(
				_usedIds = #(0) --array para los ids que ya se han utilizado
				
				for mat in _matsToWork do --recorre los materiales y les asigna un id nuevo
				(
					if _usedIds.count == 16 then _usedIds = #(0) --resetea el array de IDs usados
					assignRandomMaterialID mat forbiddenIDs:_usedIds --asigna al material y submateriales IDs aleatorios y los mas diferentes posibles
					appendIfUnique _usedIds mat.effectsChannel --almacena el ID nuevo como usado
				)--for
				
				messageBox "Material IDs generated successfully!"
			)--if _process
		)		
		
		------------------------------------------------
		--@event: pressed | Selecciona los objetos con el del spinner.
		------------------------------------------------
		on btnObjIDSelectApply pressed do
		(
			_objsById = getSceneObjectsByID (spnObjIDselect.value) --recopila los objetos con ese id
			
			clearSelection() --limpia la seleccion
			select _objsById --selecciona los objetos con ese id
		)
		
		------------------------------------------------
		--@event: pressed | Selecciona los objetos con los ids de los objetos seleccionados.
		------------------------------------------------
		on btnObjIDsSelect pressed do
		(
			_currSel = getCurrentSelection()
			
			if _currSel.count != 0 then
			(
				_objsById = #() --array para almacenar los objetos a seleccionar
				
				--recopila los objetos con esos ids
				for obj in _currSel do _objsById += (getSceneObjectsByID (obj.gbufferChannel))
				
				clearSelection() --limpia la seleccion
				select _objsById --selecciona los objetos con ese id
			)
			else
				messageBox "You dont have any objects selected! You have to select one object at least."
		)
		
		------------------------------------------------
		--@event: pressed | Importa los ids de objeto de una escena en esta.
		--@note: HAY QUE VOLVER A PROGRAMAR ESTA PARTE, GET INFO FILE (Libreria GetInfo)
		------------------------------------------------
		/*on btnObjIDsImport pressed do
		(
			_objectsToWork =((objects as array) + (shapes as array)) --recopila los objetos a los que aplicarles el id importado
			_objectsToWorkNotInImportFile = #() --array para almacenar los objetos de la escena actual que no estan en la importada
			
			_fileToImport = getMAXOpenFileName dir:maxFilePath --obtiene el archivo del que importar
			
			if (_fileToImport != undefined) then --si tiene archivo del que importar
			(
				--obtiene los nombres de los objetos de archivo y sus IDs
				_fileObjectsNames = getFileInfoObjectsNames _fileToImport
				_fileObjectsIDs = getFileInfoObjectsIDs _fileToImport
				
				for obj in _objectsToWork where (findItem _fileObjectsNames obj.name) == 0 do
					append _objectsToWorkNotInImportFile obj
				
				_process = true --flag para saber si aplicar los IDs importados
				
				if _objectsToWorkNotInImportFile.count == _objectsToWork.count then
				(
					messageBox "There is no object coincidence between current file and import file. Object IDs not loeaded."
					_process = false --impide que se asignen ids
				)
				else
				(
					if _objectsToWorkNotInImportFile.count != 0 then
					(
						_randomAssign = yesNoCancelBox "There are objects in current scene without coincidence in imported file. They could share ID with imported ones. Do you want to assign then a random ID?"
						_process = (_randomAssign != #cancel)
						
						--si se decide asi, asigna a los otros objetos un id aleatorio
						if _randomAssign == #yes then
						(
							seed (timeStamp()) --resetea el seed
							_newID = random 1 65535
							
							_usedIds = deepCopy _fileObjectsIDs --array para almacenar los IDs de los objetos que ya no podemos asignar
								
							for obj in _objectsToWorkNotInImportFile do
							(
								while (findItem _usedIds _newID) != 0 do _newID = random 1 65535
								
								obj.gbufferChannel = _newID
								appendIfUnique _usedIds _newID
							)--for
						)--if _randomAssign
					)--if _objectsToWorkNotInImportFile
				)--if else
				
				if _process then --asigna a cada objeto de la escena el Id que tenia en el archivo importado
				(
					for obj in _objectsToWork do
					(
						_index = findItem _fileObjectsNames obj.name --lo busca en el array de nombres de objetos del archivo de importacion
						if _index != 0 then obj.gbufferChannel = _fileObjectsIDs[_index] --si lo encuentra aplica el ID correspondiente
					)--for _objectsToWork
					
					messageBox "Ids loaded successfully!"
				)--id _process
			)--if _fileToImport
		)*/
		
		------------------------------------------------
		--@event: pressed | Asigna un object id aleatorio a cada objeto de la escena potencialmente renderizable o a los seleccionados.
		------------------------------------------------
		on btnObjIDsRandom pressed do
		(
			if (queryBox ((if ckbAllObjects.checked then "All" else "Selected") + " object IDs will be overWritten. Do you want to continue?")) then
			(
				--recopila los objetos a los que aplicarles un nuevo id de objeto
				_objectsToWork = if ckbAllObjects.checked then ((objects as array) + (shapes as array)) else (getCurrentSelection())
					
				if _objectsToWork.count != 0 then
				(
					--array para almacenar los ids que no se pueden usar
					_usedIds = #(0)
						
					--recopila los ids que no se pueden usar para aplicar en los objetos
					if not ckbAllObjects.checked then
						for obj in ((objects as array) + (shapes as array)) where (findItem _objectsToWork obj) == 0 do
							appendIfUnique _usedIds (obj.gbufferChannel)
						
					seed (timeStamp()) --resetea el seed
					_newID = 0
						
					for obj in _objectsToWork do
					(
						while (findItem _usedIds _newID) != 0 do _newID = random 1 65535
						
						obj.gbufferChannel = _newID
						appendIfUnique _usedIds _newID
					)--for
					
					messageBox "Ids applied successfully!"
				)--if
				else
					messageBox "There are not selected objects"
			)--if
		)--on btnObjIDsRandom
		
		------------------------------------------------
		--@event: pressed | Asigna el object id del spinner al lado de los objetos de la escena o a los seleccionados.
		------------------------------------------------
		on btnObjIDapply pressed do
		(
			if (queryBox ((if ckbAllObjects.checked then "All" else "Selected") + " object IDs will be overWritten. Do you want to continue?")) then
			(
				--recopila los objetos a los que aplicarles un nuevo id de objeto
				_objectsToWork = if ckbAllObjects.checked then ((objects as array) + (shapes as array)) else (getCurrentSelection())
					
				if _objectsToWork.count != 0 then
				(
					--array para almacenar los ids que no se pueden usar
					_usedIds = #()
						
					--recopila los ids que no se pueden usar para aplicar en los objetos
					if not ckbAllObjects.checked then
						for obj in ((objects as array) + (shapes as array)) where (findItem _objectsToWork obj) == 0 do
							appendIfUnique _usedIds (obj.gbufferChannel)
					
					_reassign = #no --opcion por defecto
					
					--si el id lo esta usando otro objeto en la escena, te pregunta que quieres hacer
					if (findItem _usedIds (spnObjID.value)) != 0 then
						_reassign = yesNoCancelBox ("Id:" + (spnObjID.value as string) + " is used in other objects, do you want to reassign them a random id?")
						
					if _reassign == #yes then --reasigna id a los objetos que llevan el que va a usar.
					(
						seed (timeStamp()) --resetea el seed
						_newID = _usedIds[1]	
						while (findItem _usedIds _newID) != 0 do _newID = random 1 65535
						for obj in ((objects as array) + (shapes as array)) where (findItem _objectsToWork obj) == 0 and obj.gbufferChannel == spnObjID.value do obj.gbufferChannel = _newID
					)--if
					
					if _reassign != #cancel then
					(
						_objectsToWork.gbufferChannel = spnObjID.value --asigna el nuevo ID
						messageBox "Id applied successfully!"
					)
				)--if
				else
					messageBox "There are not selected objects"
			)--if
		)--on btnObjIDsRandom

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
	--@struct: idsManager | Contiene la herramienta idsManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_idsManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #lighting,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool idsManager",		--@var: description | Descripcion de la tool.
		
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
			createDialog this.rollMain lockwidth:false lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_idsManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_idsManager() --crea la herramienta
)