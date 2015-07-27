------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta pointCreator.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta pointCreator.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Point Ultimate Tool"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 467		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local pointsArray = #() -- Array donde van colocados los points con los que trabajamos. Fuera del modo create mode captura los points seleccionados y dentro de este modo captura los points en modo preview (creados desde los objetos seleccionados)
		local objPicked= undefined
		local pointsArraySizes = #() -- los tamaños de los points incluidos en el array pointsArray
		local objTemp =#() -- La selección actual
		local spinnerValue = #() --Valor actual del spinner de size
		local objName = #() -- El nombre de los objetos de la selección actual
		local iconpath = if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/"		-- ruta de los iconos de Max.

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpParameters "Parameters" pos:[5,5] width:100 height:100
		checkbox chkParamCross "Cross" pos:[10,20] width:90 height:18
		checkbox chkParamBox "Box" pos:[10,40] width:90 height:18
		checkbox chkParamAxis "Axis tripod" pos:[10,60] width:90 height:18
		checkbox chkParamMarker "Center marker" pos:[10,80] width:90 height:18
		button btnCreate "Create!" pos:[5,140] width:100 height:25 toolTip:"Confirm point creation with actual values"
		checkbutton ckbCreateMode "Create Mode" pos:[5,110] width:100 height:25 toolTip:"Enter point create mode"
	
		groupBox grpSizeColor "Size and Color" pos:[110,5] width:105 height:160
		spinner spnSize "Size:" pos:[125,29] width:85 height:16 range:[0.1,500,1]
		colorPicker cpColorPicker "Color" pos:[115,55] width:95 height:20 color:(color 252 252 0) default:2
		radiobuttons rdoQuickColor "" pos:[115,82] width:77 height:78 labels:#("custom", "auto", "rig", "skin", "connection") default:1

		groupBox grpCreateMode "Create Mode" pos:[5,167] width:210 height:294 enabled:false
		
		groupBox grpFlags "Flags" pos:[12,183] width:92 height:119 enabled:false
		radiobuttons rdoFlag "Select flag type" pos:[20,204] width:57 height:62 enabled:false labels:#("fh", "afh", "custom") default:0 columns:1
		edittext edtFlag "" pos:[14,271] width:84 height:24 enabled:false
	
		groupBox grpNaming "Base name" pos:[110,183] width:98 height:119 enabled:false
		radiobuttons rdoName "" pos:[120,203] width:78 height:64 enabled:false labels:#("Point", "Parent", "PointParent", "custom") default:0
		edittext edtNaming "" pos:[112,271] width:90 height:24 enabled:false

		groupBox grpFunctions "Point create functions" pos:[11,304] width:198 height:150 enabled:false
		radiobuttons rdoFnLink "Link options" pos:[17,340] width:176 height:62 labels:#("Link object to new point/s", "Link point/s to selected object/s", "No link") default:3 checked:true
		checkbox chkFnFreezeTransform "Freeze transform created points" pos:[16,320] width:183 height:18 checked:true	
		
		groupBox grplinkPoints "Link point/s to..." pos:[16,404] width:188 height:42 enabled:false
		pickButton btnPickObject "pick object" pos:[21,420] width:121 height:20 enabled:false toolTip:"Link new points to selected object"
		button btnReset "reset link" pos:[145,420] width:53 height:20 enabled:false toolTip:"Reset selected link object"
		
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
		--@fn: undefined | updateUIPointsOptions | captura los valores del /de los point/s en la selección y actualiza el interface con estos valores, requiere la entrada del array "pointsArray"
		------------------------------------------------
		fn updateUIPointsOptions pointsArray =
		(
			_box = #none
			_cross = #none
			_color = #none
			_size = undefined
			_axis = #none
			_center = #none
			
			if pointsArray.count != 0 then
			(
				for p in pointsArray do -- comprobamos cada valor por separado y vemos si está checked o no, en caso de haber distintos points con distintas opciones activamos la opción tristate
				(
					objName = #()
					objName = filterstring p.name "_"
						
					if _box == #none then _box = p.box
					else if p.box != _box then _box = #tristate
							
					if _cross == #none then _cross = p.cross
					else if p.cross != _cross then _cross = #tristate
							
					if _color == #none then _color = p.wirecolor
					else if p.wirecolor != _color then _color = #black
							
					if _size == undefined then _size = p.size
					else if p.size != _size then _size = undefined
							
					if _axis == #none then _axis = p.axistripod
					else if p.axistripod != _axis then _axis = #tristate
							
					if _center == #none then _center = p.centermarker
					else if p.centermarker != _center then _center = #tristate
					
				)--for pointsArray
				-- comprobamos el valor de cada propiedad "parameters" y actualizamos su check 
				
				case _box of -- comprobamos el parámetro box
				(
					true: chkParamBox.tristate = 1
					false: chkParamBox.tristate = 0
					#tristate: chkParamBox.tristate = 2
				)	
				
				case _cross of -- comprobamos el parámetro cross
				(
					true: chkParamCross.tristate = 1
					false: chkParamCross.tristate = 0
					#tristate: chkParamCross.tristate = 2
				)
				
				case _axis of -- comprobamos el parámetro axis
				(
					true: chkParamAxis.tristate = 1
					false: chkParamAxis.tristate = 0
					#tristate: chkParamAxis.tristate = 2
				)
				
				case _center of -- comprobamos el parámetro center
				(
					true: chkParamMarker.tristate = 1
					false: chkParamMarker.tristate = 0
					#tristate: chkParamMarker.tristate = 2
				)
				-- colocamos el valor size
				if _size == undefined then spnSize.indeterminate = true
				else spnSize.value = _size
				
				if _color == #black then cpColorPicker.color = (color 255 255 255)
				else cpColorPicker.color = _color
				
			)
			else
			(
				chkParamMarker.checked = false
				chkParamCross.checked = false
				chkParamBox.checked = false
				chkParamAxis.checked = false
				spnSize.indeterminate = true
				edtFlag.text=""
				edtFlag.enabled=false
			)
		)

		------------------------------------------------
		--@fn: undefined | changeValues | lee los valores modificados y los actualiza en los points
		------------------------------------------------
		fn changeValues =
		(
			
			if chkParamCross.state then pointsArray.cross = true
			else pointsArray.cross = false
			
			if chkParamBox.state then pointsArray.box = true
			else pointsArray.box = false
			
			if chkParamAxis.state then pointsArray.axistripod = true
			else pointsArray.axistripod = false
			
			if chkParamMarker.state then pointsArray.centermarker = true
			else pointsArray.centermarker = false
			
			-- pointsArray.size = spnSize.value
			
			-- pointsArray.wirecolor = cpColorPicker.color
		)

		------------------------------------------------
		--@fn: undefined | changeValuesCreate | crea los points definitivos tras el modo preview, requiere la entrada de las variables "objTemp" y "pointsArray"
		------------------------------------------------
		fn changeValuesCreate objTemp pointsArray =
		(
			_flag=undefined
			_name=undefined
			for i=1 to pointsArray.count do
			(
				-- si el check de freeze transform está activo freezeamos la pieza
				if chkFnFreezeTransform.checked then lb.controller.freezeTransform pointsArray[i] #all
				
				-- comprobamos los radio button de linkaje
				if objTemp.count != 0 then
				(
					case rdoFnLink.state of
					(
						1: -- linkamos objeto al point
						(
							-- Comprobamos si los objetos seleccionados están freezeados o no y linkamos dependiendo de su estado.
							if (lb.controller.isTransformFrozen objTemp[i] #all) then
							(	
								lb.controller.setActiveController objTemp[i] #all #frozen
								objTemp[i].parent = pointsArray[i]
								lb.controller.setActiveController objTemp[i] #all #zero
							)
							else
								objTemp[i].parent = pointsArray[i]
						)
						2: -- linkamos point al objeto
						(
							if (lb.controller.isTransformFrozen pointsArray[i] #all) then
							(
								lb.controller.setActiveController pointsArray[i] #all #frozen
								pointsArray[i].parent = objTemp[i]
								lb.controller.setActiveController pointsArray[i] #all #zero
							)
							else
								objTemp[i].parent = pointsArray[i]
						)
						3: -- no linkamos nada
						(
							
						)
					)
					
					--si tenemos un objeto seleccionado en el pickButton los points creados se linkan a este objeto
					if objPicked != undefined then
					(
						if (lb.controller.isTransformFrozen pointsArray[i] #all) then
							(
								lb.controller.setActiveController pointsArray[i] #all #frozen
								pointsArray[i].parent = objPicked
								lb.controller.setActiveController pointsArray[i] #all #zero
							)
							else
								pointsArray[i].parent = objPicked
					)
				)
				
				if lb.nc.ncOK pointsArray[i].name == true then
				(
					_pointName = #()
					_pointName = filterstring objTemp[i].name "_"
					
					--Actualiza el flag de los points
					case rdoFlag.state of
					(
						1:--fh
						(
							_flag = (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
						)
						
						2:--afh
						(
							_flag= (lb.nc.NC_automaticFlag + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
						)
						
						3:--custom
						(
							_flag = edtFlag.text
						)
						
					)
					
					--Actualiza el base name de los points
					case rdoName.state of
					(
						1: -- colocamos point tras el base name
						(
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + _pointName[3] + "_" + _pointName[4] + "_" + _pointName[5] + "-hlp" + "_" + _pointName[6] + "_" + _flag
							_name = "Point"
						)
						
						2: -- colocamos parent tras el base name
						(
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + _pointName[3] + "_" + _pointName[4] + "_" + _pointName[5] + "-parent" + "_" + _pointName[6] + "_" + _flag
							_name = "Parent"
						)
						
						3: -- colocamos pointParent tras el base name
						(
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + _pointName[3] + "_" + _pointName[4] + "_" + _pointName[5] + "-hlp-parent" + "_" + _pointName[6] + "_" + _flag
							_name = "PointParent"
						)
						
						4: -- colocamos el texto entrado tras el base name
						(
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + _pointName[3] + "_" + _pointName[4] + "_" + edtNaming.text + "_" + _pointName[6] + "_" + _flag
							_name = edtNaming.text
						)
					)
					
					--Si el modo auto de color está seleccionado examina el tipo de objeto (rig, skin, mesh) y le coloca su color correspondiente. En caso de marcar rig o skin, también le cambia el nombre
					case rdoQuickColor.state of
					(
						1: --color custom
						(
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + _pointName[3] + "_" + _pointName[4] + "_" + _pointName[5] + _name + "_" + _pointName[6] + "_" + _flag
						)
						
						2: --color automático en base al tipo de objeto
						(
							case _pointName[3] of
							(
								(lb.nc.NC_classSkin):
								(
									pointsArray[i].wirecolor = color 255 255 0
								)
								
								(lb.nc.NC_classAnim):
								(
									pointsArray[i].wirecolor = color 0 255 0
								)
								
								(lb.nc.NC_classMesh):
								(
									pointsArray[i].wirecolor = color 0 0 255
								)
							)
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + _pointName[3] + "_" + _pointName[4] + "_" + _pointName[5] + _name + "_" + _pointName[6] + "_" + _flag
						)
						
						3: -- color tipo rig
						(
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + "rig" + "_" + _pointName[4] + "_" + _pointName[5] + _name + "_" + _pointName[6] + "_" + _flag
						)
						
						4: -- color tipo skin
						(
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + "skin" + "_" + _pointName[4] + "_" + _pointName[5] + _name + "_" + _pointName[6] + "_" + _flag
						)
						
						5: -- color tipo skin
						(
							pointsArray[i].name = _pointName[1] + "_" + _pointName[2] + "_" + "skin" + "_" + _pointName[4] + "_" + _pointName[5] + _name + "_" + _pointName[6] + "_" + _flag
						)
						
					)				
				)
				_pointName = #()
			)
			
			select pointsArray
			
			-- quitamos el frozen de los points creados y vaciamos los array
			pointsArray.isfrozen = false
			pointsArray = #()
			objTemp = #()
		)

		------------------------------------------------
		--@fn: undefined | previewCreatePoints | previsualiza el point antes de crearlo
		------------------------------------------------		
		fn previewCreatePoints objTemp =
		(
			-- si hay selección hecha
			if objTemp.count > 0 then
			(
				delete pointsArray
				pointsArray = #()
				for o in objTemp do
				(
					-- Capturamos la capa del objeto
					_lyName = o.layer.name --nombre de la capa del objeto
					_lyObj = layermanager.getLayerFromName _lyName -- interface de la capa del objeto
					
					-- Creamos variable del point nuevo, creamos point en objeto/s para previsualizar.
					newPoint = undefined
					objName = filterstring o.name "_"
					newPoint = lb.rig.createPointFromObj o
					
					_lyObj.addNode newPoint -- metemos el point nuevo en la capa que tenemos guardada del objeto desde donde se crea este point
										
					-- checkeamos el naming convention para nombrar el nuevo point
					if lb.nc.ncOK o.name == true then
					(
						-- eliminamos el texto #point que crea automaticamente la función lb.rig.createPointFromObj
						_pointName = #()
						_pointName = filterstring newpoint.name "_"
						newpoint.name = _pointName[1] + "_" + objName[2] + "_" + _pointName[3] + "_" + _pointName[4] + "_" + objname[5] + "_" + _pointName[6] + "_" + _pointName[7]
					)
					
					-- filtramos los objetos seleccionados para si encontramos un point, el point nuevo sea 15% menor que el original
					newPoint.size = 20
					if classof o == Point then
					(
						newPoint.size = o.size*1.15
					)
					append pointsArray newPoint
				)	
				pointsArray.isfrozen = true
				pointsArray.showFrozenInGray = off
			)
			-- si no hay nada seleccionado
			else
			(
				delete pointsArray
				pointsArray = #()
				
				newPoint = Point pos:[0,0,0] size: 20 wirecolor:(color 0 255 0) cross:off box:on axistripod:off centermarker:off
					
				append pointsArray newPoint
				pointsArray.isfrozen = true
				pointsArray.showFrozenInGray = off
			)
		)

		------------------------------------------------
		--@fn: undefined | atSelectionChange | coloca la selección actual en el array pointsArray y lanza la fn updateUIPointsOptions
		------------------------------------------------
		fn atSelectionChange =
		(
			if ckbCreateMode.checked then
			(
				objTemp = #()
				objTemp = getCurrentSelection()
				previewCreatePoints objTemp
				changeValues()
				updateUIPointsOptions pointsArray
				
			)
			else
			(
				pointsArray = #()
				_temporalSelectionA = getCurrentSelection()
				for obj in _temporalSelectionA where classof obj == point do append pointsArray obj
				-- capturamos el tamaño de los point seleccionados
				pointsArraySizes = for o in pointsArray where classof obj == point collect o.size
				updateUIPointsOptions pointsArray
			)
		)

		------------------------------------------------
		--@fn: undefined | updateUI | activa o desactiva las opciones del UI en base al botón "create mode"
		------------------------------------------------
		fn updateUI =
		(
			if ckbCreateMode.checked then
			(
				-- desactivamos el botón create! y los chks del apartado crear
				btnCreate.enabled = true
				rdoFnLink.enabled = true
				rdoFnLink.state = 3
				chkFnFreezeTransform.enabled = true
				grpFunctions.enabled=true
			
				--desactivamos el resto de funciones del modo crear (link points to, flags, naming, etc.)
				grpCreateMode.enabled=true
				grpFlags.enabled=true
				edtFlag.enabled=true
				rdoFlag.enabled=true
				grplinkPoints.enabled=true
				btnPickObject.enabled=true
				btnReset.enabled=true
				grpNaming.enabled=true
				rdoName.enabled=true
				edtNaming.enabled=true
				rdoName.state=1
				rdoFlag.state=1
				rdoQuickColor.state=2
				edtFlag.enabled = false
				edtNaming.enabled = false
				cpColorPicker.color = (color 255 255 255)
			)
			else
			(
				-- desactivamos el botón create! y los chks del apartado crear
				btnCreate.enabled = false
				rdoFnLink.enabled = false
				rdoFnLink.state = 0
				chkFnFreezeTransform.enabled = false
				grpFunctions.enabled=false
			
				--desactivamos el resto de funciones del modo crear (link points to, flags, naming, etc.)
				grpCreateMode.enabled=false
				grpFlags.enabled=false
				edtFlag.enabled=false
				rdoFlag.enabled=false
				grplinkPoints.enabled=false
				btnPickObject.enabled=false
				btnReset.enabled=false
				grpNaming.enabled=false
				rdoName.enabled=false
				edtNaming.enabled=false
				rdoName.state=0
				rdoFlag.state=0
				edtFlag.text=""
				edtNaming.text=""
				
				btnPickObject.text = "pick object"
				objPicked = undefined
			)
		)

		------------------------------------------------
		--@fn: undefined | resetUI | función para eliminar el rollout cuando se resetea la escena en modo preview
		------------------------------------------------
		fn resetUI =
		(
			destroyDialog rollMain
			--obtiene la posicion en X e Y donde colocar el rollout
			local posX = (getINISetting (toolsCfgPath + "\\rollMain.ini" ) "pos" "x") as integer
			local posY = (getINISetting (toolsCfgPath + "\\rollMain.ini") "pos" "y") as integer
			
			--crea el rollout principal
			rollFltRolloutFloater = createDialog rollMain pos:[posX,posY]	
			
			rolloutOpen = true
			updateToolbarButtons()
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

			callbacks.addscript #systemPreReset "lb.pointCreator.rollMain.resetUI()" id:_id
			callbacks.addscript #selectionSetChanged "lb.pointCreator.rollMain.atSelectionChange()" id:_id
			callbacks.addscript #sceneUndo "lb.pointCreator.rollMain.atSelectionChange()" id:_id
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
		--@event: pressed | botón crear dentro del modo editar
		------------------------------------------------		
		on btnCreate pressed do
		(
			removeSceneEvents()
			changeValuesCreate objTemp pointsArray
			ckbCreateMode.checked = false
			
			-- desactivamos el botón create! y los chks del apartado crear
			updateUI()
		
			-- Comienza el callback para capturar los datos de los points seleccionados
			createSceneEvents()
		)

		------------------------------------------------
		--@event: changed | Contrastamos el cambio de los parámetros básicos de los point (x4)
		------------------------------------------------			
		on chkParamCross changed state do
		(	
			undo "Point cross" on
			(
				changeValues()
			)
		)

		on chkParamBox changed state do
		(	
			undo "Point box" on
			(
			changeValues()
			)
		)
		
		on chkParamAxis changed state do
		(	
			undo "Point axis tripod" on
			(
			changeValues()
			)
		)
		
		on chkParamMarker changed state do
		(	
			undo "Point center marker" on
			(
				changeValues()
			)
		)	

		------------------------------------------------
		--@event: entered | Spinner para cambio de tamaño
		------------------------------------------------
		on spnSize entered do 
		(
			--pointsArraySizes = for o in pointsArray collect o.size
			if pointsArray.count > 1 and pointsArraySizes.count != 0 then
			(
				for i=1 to pointsArray.count do
				(		
					pointsArray[i].size = pointsArraySizes[i]
				)
				pointsArraySizes = #()
			)
			else
			(
				for i=1 to pointsArray.count do
				(			
					pointsArray[i].size = spnSize.value	
				)
			)
		)

		------------------------------------------------
		--@event: changed | cambiamos el tamaño al introducir un valor
		------------------------------------------------					
		on spnSize changed state do
		(	
			--Evitamos que los objetos cambien de tamaño al modificar otros valores			
				for i=1 to pointsArray.count do
				(				
					if pointsArray.count > 1 and pointsArraySizes.count != 0 then
						pointsArray[i].size = (spnSize.value - spinnerValue) + pointsArraySizes[i]
					else
						pointsArray[i].size = spnSize.value
				)
		)

		------------------------------------------------
		--@event: buttondown | Al pulsar el botón de spinner de tamaño
		------------------------------------------------		
		on spnSize buttondown do
		(	
			undo "point size" on
			(			
				spinnerValue = spnSize.value
				pointsArraySizes = for o in pointsArray collect o.size
			)
		)	

		------------------------------------------------
		--@event: buttonup | Al soltar el botón de spinner de tamaño
		------------------------------------------------		
		on spnSize buttonup do
		(	
			pointsArraySizes = for o in pointsArray collect o.size
		)	

		------------------------------------------------
		--@event: changed | Al pulsar en el color picker cambia el color a los points actuales o del create mode
		------------------------------------------------
		on cpColorPicker changed state do
		(	
			undo "Point changed color" on
			(
				changeValues()
				
				--Evitamos que los objetos queden en color blanco al modificar otros valores
				pointsArray.wirecolor = cpColorPicker.color
			)
		)

		------------------------------------------------
		--@event: changed | Cambio de estado en radio button de linkajes
		------------------------------------------------		
		on rdoFnLink changed state do
		(
			
			if rdoFnLink.state == 2 then
			(
				btnPickObject.enabled=false
				grplinkPoints.enabled=false
				btnReset.enabled=false
			)
			else
			(
				btnPickObject.enabled=true
				grplinkPoints.enabled=true
				btnReset.enabled=true
			)	
		)

		------------------------------------------------
		--@event: changed | si el estado del radio button para tipos de name se modifica, se actualiza el point/s
		------------------------------------------------		
		on rdoName changed state do
		(
			if rdoName.state == 4 then
			(
				edtNaming.enabled = true
			)
			else
			(
				edtNaming.enabled = false
			)
		)

		------------------------------------------------
		--@event: changed | si el estado del radio button para tipos de flag se modifica, se actualiza el point/s
		------------------------------------------------			
		on rdoFlag changed state do
		(
			if rdoFlag.state == 3 then
			(
				edtFlag.enabled = true
			)
			else
			(
				edtFlag.enabled = false
			)
		)

		------------------------------------------------
		--@event: changed | si el estado del radio button para colores cambia fuera del modo create mode
		------------------------------------------------		
		on rdoQuickColor changed state do
		(
			-- creamos un array con el número de elementos del nombre de los points para más tarde poder trabajar con ellos,
			-- ya que algunos point creados con esta herramienta tienen 7 partes, pero no cumplen el NC
			case rdoQuickColor.state of
			(
				1: -- se activa el selector de color
				(
					cpColorPicker.enabled = true
					updateUIPointsOptions pointsArray
				)
				
				2: -- en modo auto se deja en desuso fuera del modo create mode
				(
					cpColorPicker.enabled = false
				)
				
				3: -- se desactiva el selector de color. Se activa el tipo de pieza en rig. Se cambia al color correspondiente y su nombre de tipo de objeto.
				(
					pointsArray.wirecolor = color 0 255 0
					cpColorPicker.enabled = false
					updateUIPointsOptions pointsArray
					for o in pointsArray do
					(
						local nameCount = #()
						nameCount = filterString o.name "_"
						if nameCount.count == 7 then
						(
							objName = filterstring o.name "_"
							o.name = objname[1] + "_" + objname[2] + "_" + "rig" + "_" + objname[4] + "_" + objname[5] + "_" + objname[6] + "_" + objname[7]
						)
					)
				)
				
				4: -- se desactiva el selector de color. Se activa el tipo de pieza en skin. Se cambia al color correspondiente y su nombre de tipo de objeto.
				(
					pointsArray.wirecolor = color 255 255 0
					cpColorPicker.enabled = false
					updateUIPointsOptions pointsArray
					for o in pointsArray do
					(
						local nameCount = #()
						nameCount = filterString o.name "_"
						if nameCount.count == 7 then
						(
							objName = filterstring o.name "_"
							o.name = objname[1] + "_" + objname[2] + "_" + "skin" + "_" + objname[4] + "_" + objname[5] + "_" + objname[6] + "_" + objname[7]
						)
					)
				)
				
				5: -- se desactiva el selector de color. Se activa el tipo de pieza en skin. Se cambia al color correspondiente y su nombre de tipo de objeto.
				(
					pointsArray.wirecolor = color 255 0 0
					cpColorPicker.enabled = false
					updateUIPointsOptions pointsArray
					for o in pointsArray do
					(
						local nameCount = #()
						nameCount = filterString o.name "_"
						if nameCount.count == 7 then
						(
							objName = filterstring o.name "_"
							o.name = objname[1] + "_" + objname[2] + "_" + "skin" + "_" + objname[4] + "_" + objname[5] + "_" + objname[6] + "_" + objname[7]
						)
					)
				)
			)
		)

		------------------------------------------------
		--@event: changed | si el estado del campo de texto para flags cambia se mete en el flag, pero si se deja vacío se mantiene el flag original del objeto desde donde se crea.
		------------------------------------------------
		on edtFlag changed text do
		(
			for i=1 to pointsArray.count do
			(
				if edtFlag.text != "" then
				(	
				
					objName = #()
					objName = filterstring pointsArray[i].name "_"
					pointsArray[i].name = objname[1] + "_" + objname[2] + "_" + objname[3] + "_" + objname[4] + "_" + objname[5] + "_" + objname[6] + "_" + edtFlag.text
				)
				else
				(
					objName = #()
					objName = filterstring pointsArray[i].name "_"
					pointsArray[i].name = objname[1] + "_" + objname[2] + "_" + objname[3] + "_" + objname[4] + "_" + objname[5] + "_" + objname[6] + "_" + objname[7]
				)
			)
		)

		------------------------------------------------
		--@event: changed | Diferentes funciones cuando pulsamos el modo crear y se queda activado, y en else cuando se desactiva, entre otras cosas se cortan o se activan callbacks o funciones de UI.
		------------------------------------------------		
		on ckbCreateMode changed state do
		(
			if state then -- btn create activado
			(
				-- Cortamos el callback mientras creamos points
				btnCreate.enabled = true
				-- quitamos los checks y marcamos la casilla de size en blanco
				chkParamMarker.checked = false
				chkParamCross.checked = false
				chkParamBox.checked = true
				chkParamAxis.checked = false
				spnSize.value = 20
				
				updateUI()
				
				pointsToPreview = #()
				pointsArray = #()
				objTemp = #()
				
				-- reseleccionamos los objetos al hacer click en create mode
				_temporalSelectionA = getCurrentSelection()
				for obj in _temporalSelectionA where classof obj == point do append objTemp obj
				
				-- creamos points en la selección actual
				atSelectionChange()		
			)
		
			else -- btn create desactivado
			(
				-- desactivamos el botón create! y los chks del apartado crear
				updateUI()
				
				delete pointsArray
				pointsArray = #()
		
				_temporalSelectionA = getCurrentSelection()
				for obj in _temporalSelectionA where classof obj == point do append pointsArray obj
				
				-- Borramos los point preview
		
				
				-- Comienza el callback para capturar los datos de los points seleccionados
			)
		)

		------------------------------------------------
		--@event: picked |  evento de captura de objeto para el linkaje de los points creados con este.
		------------------------------------------------		
		on btnPickObject pressed obj do
		(
			btnPickObject.text = obj.name
			btnReset.enabled=true
			objPicked = obj
		)

		------------------------------------------------
		--@event: picked |  evento del botón reset link que elimina el objeto seleccionado en el botón pick object.
		------------------------------------------------		
		on btnReset pressed do
		(
			btnReset.enabled=false
			btnPickObject.text = "pick object"
			objPicked = undefined
		)

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

			updateToolbarButtons()

			atSelectionChange() --capturamos la primera selección
			
			-- Ponemos en gris las opciones que no se necesiten a la hora de editar
			btnCreate.enabled = false
			rdoFnLink.enabled = false
			chkFnFreezeTransform.enabled = false

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

			updateToolbarButtons() --actualiza los botones de la barra de herramientas

			if ckbCreateMode.state then delete pointsArray
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_pointCreator
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Point Creator",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_pointCreator
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_pointCreator() --crea la herramienta
)