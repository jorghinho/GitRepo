------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta characterSlicer.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta characterSlicer.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Character Slicer"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 380		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 800		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		label lblCharName "" pos:[10,5] width:300 height:15 style_sunkenedge:true

		label lblCharHead "" pos:[10,32] width:100 height:15
		label lblCharUpper "" pos:[10,177] width:100 height:15
		label lblCharLower "" pos:[10,322] width:100 height:15
		label lblCharBody "" pos:[10,467] width:100 height:15
		label lblCharHeadHeair "" pos:[10,612] width:100 height:15

		label lblCharHeadEnd ")" pos:[105,32] width:100 height:15
		label lblCharUpperEnd ")" pos:[110,177] width:100 height:15
		label lblCharLowerEnd ")" pos:[110,322] width:100 height:15
		label lblCharBodyEnd ")" pos:[105,467] width:100 height:15
		label lblCharHeadHeairEnd ")" pos:[125,612] width:100 height:15

		edittext edtHead "" pos:[50,30] text:"std" width:50 height:10 enabled:true
		edittext edtUpper "" pos:[55,175] text:"std" width:50 height:10 enabled:true
		edittext edtLower "" pos:[55,320] text:"std" width:50 height:10 enabled:true
		edittext edtBody "" pos:[50,465] text:"std" width:50 height:10 enabled:true
		edittext edtHeadHeair "" pos:[70,610] text:"std" width:50 height:10 enabled:true

		bitmap bitMapHead bitmap:(bitmap 30 15 color:(color 255 255 0)) pos:[140,28]
		bitmap bitMapUpper bitmap:(bitmap 30 15 color:(color 0 0 255)) pos:[140,173]
		bitmap bitMapLower bitmap:(bitmap 30 15 color:(color 0 255 0)) pos:[140,318]
		bitmap bitMapBody bitmap:(bitmap 30 15 color:(color 0 255 255)) pos:[140,463]
		bitmap bitMapHeadHair bitmap:(bitmap 30 15 color:(color 255 0 255)) pos:[140,608]

		bitmap bitNotAssigned bitmap:(bitmap 30 15 color:(color 0 0 0)) pos:[10,750]
		button btnNotAssigned "Not Assigned" pos:[40,750] width:80 height:20

		bitmap bitShared bitmap:(bitmap 30 15 color:(color 255 0 0)) pos:[140,750]
		button btnShared "Shared" pos:[170,750] width:80 height:20

		listBox lbxHead "" pos:[10,50] width:300 height:8 enabled:true		--@control: lbxTargets | Listbox para los objetos que van a ser modificados.
		listBox lbxUpper "" pos:[10,195] width:300 height:8 enabled:true	--@control: lbxTargets | Listbox para los objetos que van a ser modificados.
		listBox lbxLower "" pos:[10,340] width:300 height:8 enabled:true	--@control: lbxTargets | Listbox para los objetos que van a ser modificados.
		listBox lbxBody "" pos:[10,485] width:300 height:8 enabled:true		--@control: lbxTargets | Listbox para los objetos que van a ser modificados.
		listBox lbxHeadHair "" pos:[10,630] width:300 height:8 enabled:true	--@control: lbxTargets | Listbox para los objetos que van a ser modificados.
		
		button btnHeadPublish "Publish" pos:[311,140] width:60 height:20
		button btnAddSelecHead "Add Sel." pos:[200,30] width:50 height:20
		button btnRemoveHead "-" pos:[250,30] width:30 height:20
		button btnDeleteHead "X" pos:[280,30] width:30 height:20

		button btnUpperPublish "Publish" pos:[311,285] width:60 height:20
		button btnAddSelecUpper "Add Sel." pos:[200,175] width:50 height:20
		button btnRemoveUpper "-" pos:[250,175] width:30 height:20
		button btnDeleteUpper "X" pos:[280,175] width:30 height:20

		button btnLowerPublish "Publish" pos:[311,430] width:60 height:20
		button btnAddSelecLower "Add Sel." pos:[200,320] width:50 height:20
		button btnRemoveLower "-" pos:[250,320] width:30 height:20
		button btnDeleteLower "X" pos:[280,320] width:30 height:20

		button btnBodyPublish "Publish" pos:[311,575] width:60 height:20
		button btnAddSelecBody "Add Sel." pos:[200,465] width:50 height:20
		button btnRemoveBody "-" pos:[250,465] width:30 height:20
		button btnDeleteBody "X" pos:[280,465] width:30 height:20

		button btnHeadHairPublish "Publish" pos:[311,720] width:60 height:20
		button btnAddSelecHeadHair "Add Sel." pos:[200,610] width:50 height:20
		button btnRemoveHeadHair "-" pos:[250,610] width:30 height:20
		button btnDeleteHeadHair "X" pos:[280,610] width:30 height:20

		button btnPublishAll "Publish All" pos:[10,775] width:362 height:20

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

		fn initControls =
		(
			if maxfilename != "" then
			(
				_charName = filterString maxfilename "{("
				lblCharName.caption = "Char Name: " + _charName[1] + "(part - partVersion)"				
			)
			
			lblCharHead.caption = "(" + " head" + " -"
			lblCharUpper.caption = "(" + " upper" + " -"
			lblCharLower.caption = "(" + " lower" + " -"
			lblCharBody.caption = "(" + " body" + " -"
			lblCharHeadHeair.caption = "(" + " headHair" + " -"
		)

		fn addSelection part =
		(
			----------------------------------------
			_targets = #() --objetos que agregar a la lista
			
			_otherListsTargets = #() --objetos de las otras listas
			_otherListsTargets = lbxHead.items + lbxUpper.items + lbxLower.items + lbxBody.items + lbxHeadHair.items

			case part of
			(
				"head": _targets = lbxHead.items
				"upper": _targets = lbxUpper.items
				"lower": _targets = lbxLower.items
				"body": _targets = lbxBody.items
				"headHair": _targets = lbxHeadHair.items
			)

			for i=_otherListsTargets.count to 1 by -1 do
			(
				_index = findItem _targets _otherListsTargets[i]
				if _index != 0 then deleteItem _otherListsTargets _index
			)
			----------------------------------------

			----------------------------------------
			for obj in selection do
			(
				if findItem _otherListsTargets obj.name != 0 then
				(
					_option = lb.message.show "This object is in other lists. Do you want to remove it from the others? If you choose NO, this object will be in several lists at same time." type:#yesnocancel

					case _option of
					(
						#yes:
						(
							--head
							_trgts = lbxHead.items
							_index = findItem _trgts obj.name
							if _index != 0 then deleteItem _trgts _index
							lbxHead.items = _trgts

							--upper
							_trgts = lbxUpper.items
							_index = findItem _trgts obj.name
							if _index != 0 then deleteItem _trgts _index
							lbxUpper.items = _trgts

							--lower
							_trgts = lbxLower.items
							_index = findItem _trgts obj.name
							if _index != 0 then deleteItem _trgts _index
							lbxLower.items = _trgts

							--body
							_trgts = lbxBody.items
							_index = findItem _trgts obj.name
							if _index != 0 then deleteItem _trgts _index
							lbxBody.items = _trgts

							--headHair 
							_trgts = lbxHeadHair.items
							_index = findItem _trgts obj.name
							if _index != 0 then deleteItem _trgts _index
							lbxHeadHair.items = _trgts

							appendIfUnique _targets obj.name
						)

						#no:
						(
							appendIfUnique _targets obj.name
						)
					)
				)
				else
				(
					appendIfUnique _targets obj.name
				)				
			)--for
			----------------------------------------

			----------------------------------------
			case part of
			(
				"head": lbxHead.items = _targets
				"upper": lbxUpper.items = _targets
				"lower": lbxLower.items = _targets
				"body": lbxBody.items = _targets
				"headHair": lbxHeadHair.items = _targets
			)
			----------------------------------------
		)

		fn deleteSelection part =
		(
			_listBox = undefined

			case part of
			(
				"head": _listBox = lbxHead
				"upper": _listBox = lbxUpper
				"lower": _listBox = lbxLower 
				"body": _listBox = lbxBody
				"headHair": _listBox = lbxHeadHair
			)

			if _listBox != undefined and _listBox.items != 0 and _listBox.selection !=0 then
			(
				_items = _listBox.items

				if _items.count != 0 then 
				(
					deleteItem _items _listBox.selection
					_listBox.items = _items
				)
			)
		)

		fn deleteAll part = 
		(
			case part of
			(
				"head": lbxHead.items = #()
				"upper": lbxUpper.items = #()
				"lower": lbxLower .items = #()
				"body": lbxBody.items = #()
				"headHair": lbxHeadHair.items = #()
			)
		)
		
		fn publish nodesNames part subpart =
		(
			if nodesNames.count > 0 then
			(
				_saveRequired = getSaveRequired()
				_saved = true
				_originalPathNameFile = maxfilepath + maxfilename

				if _saveRequired then 
				(
					_gonaSave = lb.message.show "File has changes. Do you want to save it now? If you say NO process will continue without saving but you can lose work." type:#query

					if _gonaSave then
					(
						_saved = saveMaxFile _originalPathNameFile useNewFile:true quiet:true
					  	if not _saved then lb.message.show "File couldn't be saved, check if the file is readOnly. Process will not continue." type:#message
					)				
				)

				if _saved then 
				(
					_originalPathParts = filterString _originalPathNameFile "\\"

					if (_originalPathParts[6] != lb.nc.NC_versionFolderName) and (_originalPathParts[7] != lb.nc.NC_baseFolderName) then
					(
						lb.message.show "File isn't in version/base folder. Process will not continue." type:#message
					)
					else
					(
						_fileName = maxfilename
						if matchpattern _fileName pattern: (lb.nc.NC_chrPrefix + "_" + "*{*-*}" + "_" + lb.nc.NC_meshFileName + "_" + "v??.max") or matchpattern _fileName pattern: (lb.nc.NC_chrPrefix + "_" + "*(*-*)" + "_" + lb.nc.NC_meshFileName + "_" + "v??.max") then
						(
							_fileNameParts = filterString _fileName "{("
							_layerName = _fileNameParts[1] + "(" + part + "-" + subpart + ")" 
							_newLayer = lb.layer.newLayer name:_layerName

							for i=1 to nodesNames.count do
							(
								_nodes = lb.misc.getNodeByPattern nodesNames[i]
								_newLayer.addNode _nodes
							)

							for i=objects.count to 1 by -1 where (findItem nodesNames objects[i].name == 0) do delete objects[i]

							_layerNodes = lb.layer.getLayerNodes _newLayer
							for o in _layerNodes do
							(
								_nameParts = filterString o.name "_"
								_objName = o.name
								--_fileNameParts = filterString maxfilename "{("
								if lb.nc.ncOK o.name or _nameParts.count == 7 then
								(
									o.name = _fileNameParts[1] + "(" + part + "-" + subpart + ")" + "_" + lb.nc.NC_classMesh + "_" + _nameParts[4] + "_" + _nameParts[5] + "_" + lb.nc.NC_pcCache + "_" + lb.nc.NC_frozenFlag
								)
								else if _nameParts.count == 2 then
								(
									if (toLower _nameParts[1]) == "l" then
									(
										_objName = _fileNameParts[1] + "(" + part + "-" + subpart + ")" + "_" + lb.nc.NC_classMesh + "_" + (toLower _nameParts[1]) + "_" + _nameParts[2] + "_" + lb.nc.NC_pcCache + "_" + lb.nc.NC_frozenFlag
										o.name = _objName										
									)

									if (toLower _nameParts[1]) == "r" then
									(
										_objName = _fileNameParts[1] + "(" + part + "-" + subpart + ")" + "_" + lb.nc.NC_classMesh + "_" + (toLower _nameParts[1]) + "_" + _nameParts[2] + "_" + lb.nc.NC_pcCache + "_" + lb.nc.NC_frozenFlag
										o.name = _objName										
									)
								)
								else
								(
									_newName = o.name
									_newNameParts = filterString _newName " _"
									_finalName = ""
									for i=1 to _newNameParts.count do
									(
										_newNameParts[i][1] = if i==1 then toLower _newNameParts[i][1] else toUpper _newNameParts[i][1]
										_finalName += _newNameParts[i]
									)

									o.name = _fileNameParts[1] + "(" + part + "-" + subpart + ")" + "_" + lb.nc.NC_classMesh + "_" + lb.nc.NC_nonSpecifiedCache + "_" + _finalName + "_" + lb.nc.NC_pcCache + "_" + lb.nc.NC_frozenFlag
								)						
							)

							(LayerManager.getLayerFromName "0").current = true
							_layerNames = lb.layer.getLayersNames()
							for i=1 to _layerNames.count where _layerNames[i] != _layerName do lb.layer.deleteLayerByName _layerNames[i]

							_newPath = maxfilepath
							_newPathParts = filterString _newPath "\\"
							_newPath = substituteString _newPath _newPathParts[7] lb.nc.NC_partFolderName

							_newFileName = maxfilename
							_newFileNameParts = filterString _newFileName "{(_"
							_newFileName = _newFileNameParts[1] + "_" + _newFileNameParts[2] + "(" + part + "-" + subpart + ")" + "_" + lb.nc.NC_classMesh + "_" + _newFileNameParts[5]

							setWaitCursor()
							_defFileName = _newPath + _newFileName

							--PONEMOS POR DEFAULT ALGUNOS VALORES
							units.DisplayType = #metric
							units.MetricType = #centimeters
							frameRate = 24
							IDisplayGamma.gamma = 1.84

							--RENOMBRAMOS LAS PIEZAS
							for obj in objects do 
							(
								_fNameParts = filterString maxfilename "{"
								_objName = obj.name
								_objNameParts = filterString _objName "_"
								if _objNameParts.count == 7 then 
								(
									if ((toLower _objNameParts[4]) != "l") and ((toLower _objNameParts[4]) != "r") then
									(
										_objName = _fNameParts[1] + "(" + part + "-" + subpart + ")" + "_" + lb.nc.NC_classMesh + "_" + lb.nc.NC_locationNotSpecified + "_" + _objNameParts[5] + "_" + lb.nc.NC_pcCache + "_" + lb.nc.NC_frozenFlag
										obj.name = _objName
									) 
								)
								else
								(
									_newObjName = obj.name
									_newObjNameParts = filterString _newObjName "_"
									_finalObjName = ""

									for i=1 to _newObjNameParts.count do
									(
										_newObjNameParts[i][1] = if i==1 then toLower _newObjNameParts[i][1] else toUpper _newObjNameParts[i][1]
										_finalObjName += _newObjNameParts[i]
									)
									_newObjName = _fNameParts[1] + "(" + part + "-" + subpart + ")" + "_" + lb.nc.NC_classMesh + "_" + lb.nc.NC_locationNotSpecified + "_" + _finalObjName + "_" + lb.nc.NC_pcCache + "_" + lb.nc.NC_frozenFlag 
									obj.name = _newObjName
								)	
							)
							
							--RENOMBRAMOS EL MATERIAL
							_matMaxName = maxfilename
							_matMaxNameParts = filterString _matMaxName "{_"

							_objMats = lb.materials.getSceneMaterials()
							
							for j=1 to _objMats.count do
							(
								_matName = _objMats[j].name
								_matNameParts = filterString _matName "_"

								if _matNameParts.count == 3 then
								(
									if (tolower _matNameParts[1]) != (tolower _matMaxNameParts[1]) or (tolower _matNameParts[2]) != (tolower _matMaxNameParts[2]) then	
										_matName = _matMaxNameParts[1] + "_" + _matMaxNameParts[2] + "(" + part + "-" + subpart + ")" + "_" + _matNameParts[3]

										_objMats[j].name = _matName
								)
								else if _matNameParts.count == 0 then
								(
									_matName = _matMaxNameParts[1] + "_" + _matMaxNameParts[2] + "(" + part + "-" + subpart + ")" + "_" + "noName"
									_objMats[j].name = _matName
								)
								else
								(
									_newMatName = _objMats[j].name
									_newMatNameParts = filterString _newMatName "_"
									_finalMatName = ""
									for i=1 to _newMatNameParts.count do
									(
										_newMatName = substituteString _newMatName " " ""
										_newMatName = substituteString _newMatName "_" ""
										_newMatNameParts[i][1] = if i==1 then toLower _newMatNameParts[i][1] else toUpper _newMatNameParts[i][1]
										_finalMatName += _newMatNameParts[i]
									)
									_defMatName = _matMaxNameParts[1] + "_" + _matMaxNameParts[2] + "(" + part + "-" + subpart + ")" + "_" + _finalMatName 
									_objMats[j].name = _defMatName
								)
							)

							if doesFileExist _defFileName then
							(
								_saveOverwrite = lb.message.show "File exist. Do you want to overwrite this file?" type:#query
								if _saveOverwrite then
								(
									setFileAttribute _defFileName #readOnly false
									deleteFile _defFileName
									_newFileSaved = saveMaxFile _defFileName useNewFile:true quiet:true
								)
								else
								 lb.message.show "Process canceled." 
							)
							else
							(
								_newFileSaved = saveMaxFile _defFileName useNewFile:true quiet:true	
							)

							loadMaxFile _originalPathNameFile useFileUnits:true quiet:true --Cargamos el archivo _original
							setArrowCursor()
						)
						else
						(
							lb.message.show "File name doesn't fulfill naming convention rules. Process will not continue." type:#message
						)
					)
				)	
			)  
		)
		
		fn setMeshWireColor = 
		(	
			_notAssignedColor = color 0 0 0
			_sharedColor = color 255 0 0
			_headColor = color 255 255 0
			_upperColor = color 0 0 255
			_lowerColor = color 0 255 0
			_bodyColor = color 0 255 255
			_headHairColor = color 255 0 255

			_assignedObjects = #()

			for o in objects do 
			(
				--primero como no asignado
				o.wirecolor = _notAssignedColor

				--head
				_index = findItem lbxHead.items o.name
				if _index != 0 then
				(
					o.wirecolor = if finditem _assignedObjects o == 0 then _headColor else _sharedColor
					appendIfUnique _assignedObjects o
				)--if

				--upper
				_index = findItem lbxUpper.items o.name
				if _index != 0 then
				(
					o.wirecolor = if finditem _assignedObjects o == 0 then _upperColor else _sharedColor
					appendIfUnique _assignedObjects o
				)--if

				--lower
				_index = findItem lbxLower.items o.name
				if _index != 0 then
				(
					o.wirecolor = if finditem _assignedObjects o == 0 then _lowerColor else _sharedColor
					appendIfUnique _assignedObjects o
				)--if

				--body
				_index = findItem lbxBody.items o.name
				if _index != 0 then
				(
					o.wirecolor = if finditem _assignedObjects o == 0 then _bodyColor else _sharedColor
					appendIfUnique _assignedObjects o
				)--if

				--headHair
				_index = findItem lbxHeadHair.items o.name
				if _index != 0 then
				(
					o.wirecolor = if finditem _assignedObjects o == 0 then _headHairColor else _sharedColor
					appendIfUnique _assignedObjects o
				)--if	
			)--for
		)

		------------------------------------------------
		--@fn: undefined | resetUI | Hace un reset de la herramienta.
		------------------------------------------------
		fn resetUI =
		(
			lbxHead.items = #()
			lbxUpper.items = #()
			lbxLower .items = #()
			lbxBody.items = #()
			lbxHeadHair.items = #()
			initControls()
		)


		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.addscript #filePostOpenProcess "lb.characterSlicer.rollMain.resetUI()" id:_id			
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.removescripts id:_id			
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
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		on btnNotAssigned pressed do
		(
			_objsAssigned = #()
			_notAssigned = ""
			_objsAssigned = (lbxHead.items + lbxUpper.items + lbxLower.items + lbxBody.items + lbxHeadHair.items)
			if _objsAssigned.count != 0 then
			(
				for _obj in objects do
				(
					if findItem _objsAssigned _obj.name == 0 then
					(
						_notAssigned += _obj.name + " \n"
					)
				)
				messageBox ("Some objects are not assigned:\n" + _notAssigned) title:"NOT ASSIGNED!"
			)
		)

		on btnShared pressed do
		(
			_objsShared = #()
			_shared = ""
			_objsShared = (lbxHead.items + lbxUpper.items + lbxLower.items + lbxBody.items + lbxHeadHair.items)

			if _objsShared.count != 0 then
			(
				for _obj in objects do
				(
					if not findItem _objsShared _obj.name == 0 then
					(
						_shared += _obj.name + " \n"
					)
				)
				messageBox ("Some objects are shared in lists:\n" + _shared) title:"SHARED IN MORE THAN ONE LIST!"
			)
		)

		on btnAddSelecHead pressed do		
		(
			addSelection "head"
			setMeshWireColor()
		)

		on btnAddSelecUpper pressed do		
		(
			addSelection "upper"
			setMeshWireColor()
		)

		on btnAddSelecLower pressed do		
		(
			addSelection "lower"
			setMeshWireColor()
		)

		on btnAddSelecBody pressed do		
		(
			addSelection "body"
			setMeshWireColor()
		)

		on btnAddSelecHeadHair pressed do		
		(
			addSelection "headHair"
			setMeshWireColor()
		)

		on btnRemoveHead pressed do 
		(
			deleteSelection "head"
			setMeshWireColor()
		)

		on btnRemoveUpper pressed do 
		(
			deleteSelection "upper"
			setMeshWireColor()
		)

		on btnRemoveLower pressed do 
		(
			deleteSelection "lower"
			setMeshWireColor()
		)

		on btnRemoveBody pressed do 
		(
			deleteSelection "body"
			setMeshWireColor()
		)

		on btnRemoveHeadHair pressed do 
		(
			deleteSelection "headHair"
			setMeshWireColor()
		)

		on btnDeleteHead pressed do
		(
			deleteAll "head"
			setMeshWireColor()
		)

		on btnDeleteUpper pressed do
		(
			deleteAll "upper"
			setMeshWireColor()
		)

		on btnDeleteLower pressed do
		(
			deleteAll "lower"
			setMeshWireColor()
		)

		on btnDeleteBody pressed do
		(
			deleteAll "body"
			setMeshWireColor()
		)

		on btnDeleteHeadHair pressed do
		(
			deleteAll "headHair"
			setMeshWireColor()
		)

		on btnHeadPublish pressed do
		(
			publish lbxHead.items "head" edtHead.text
		)
		on btnUpperPublish pressed do
		(
			publish lbxUpper.items "upper" edtUpper.text
		)
		on btnLowerPublish pressed do
		(
			publish lbxLower.items "lower" edtLower.text
		)
		on btnBodyPublish pressed do
		(
			publish lbxBody.items "body" edtBody.text
		)
		on btnHeadHairPublish pressed do
		(
			publish lbxHeadHair.items "headHair" edtHeadHeair.text
		)

		on btnPublishAll pressed do 
		(
			removeSceneEvents()
			publish lbxHead.items "head" edtHead.text
			publish lbxUpper.items "upper" edtUpper.text
			publish lbxLower.items "lower" edtLower.text
			publish lbxBody.items "body" edtBody.text
			publish lbxHeadHair.items "headHair" edtHeadHeair.text
			createSceneEvents()
		)

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
			initControls()
			--setMeshWireColor()
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
	--@struct: characterSlicer | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_characterSlicer
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool plantilla",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_characterSlicer
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_characterSlicer() --crea la herramienta
)