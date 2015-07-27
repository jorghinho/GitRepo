------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta cameraMappingManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollCameraMappingCalculatorDef | Contiene la herramienta cameraMappingManager.
	------------------------------------------------------------------------------------------------------------------------------------------------

	rollout rollCameraMappingCalculatorDef "Camera Mapping Calculator"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 220		--@var: minWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 50		--@var: minHeight | Alto mínimo de la herramienta.		
		local iconpath = if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/" --ruta de los iconos de Max.
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		label lblOld "OLD" pos: [104,5] height:20 width:35
		label lblNew "NEW" pos: [160,5] height:20 width:35
		label lblRenderWidth "Render Width:" pos:[5,25] height:20 width:70 
 		button btnGetRenderValues "GR" pos:[76,25] height:16 width:16 images:#(iconpath + "Classic_16i.bmp", undefined, 78, 69, 69, 70, 70,true) tooltip:"Get scene's render width"
		spinner spnOldRenderWidth "" pos: [92,25] height:20 width:55 range: [0,99999,2048] type: #integer
		spinner spnNewRenderWidth "" pos: [148,25] height:20 width:55 range: [0,99999,2048] type: #integer
		label lblLens "Lens:" pos: [5,45] height:20 width:35
		checkbutton btnGetCameraValues "GC" pos:[76,45] height:16 width:16 images:#(iconpath + "bip_mocap_i.bmp", undefined, 24, 3, 3, 4, 4,true) tooltip:"Get selected camera lens"
		spinner spnOldLens "" pos: [92,45] height:20 width:55 range: [0.1,1000.0,35.0] type: #float
		spinner spnNewLens "" pos: [148,45] height:20 width:55 range: [0.1,1000.0,35.0] type: #float
		groupbox grpCameraDuplicate "Duplicate Camera Options" pos:[5,65] width:195 height:40
		pickbutton pckPickCameraToDuplicate "Pick Cam" height:20 width:50 pos:[10,80] autoDisplay:true filter:rollCameraMappingCalculatorDef.pickCam 
 		button btnDuplicateCamera "Duplicate w lens:" height:20 width:130 pos:[65,80]
		
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
		--@fn: undefined | round | Funcion de redondeo de decimales, le pasamos un valor por medio de precision que se refiere al numero de decimal a partir del que vamos a hacer redondeo
		------------------------------------------------
		fn round oldValue precision:0 =
		(
			--Nos creamos una variable para ir haciendo las operaciones pertinentes.
			--Primero llevamos tantos decimales a la izquierda como valor tenga la precision.
			_tempValue = oldValue * (pow 10 precision)
			--Hacemos el redondeo, si el numero menos su suelo es mayor que 0,4 entonces cogemos el techo
			if (_tempValue - floor(_tempValue))>0.4 then
				_tempValue = ceil _tempValue
			else --Si es menor entonces cogemos el suelo
				_tempValue = floor _tempValue
			(_tempValue / (pow 10 precision))
		)

		------------------------------------------------
		--@fn: undefined | pickCam | Funcion de filtro que pasamos al pickObject para que unicamente deje coger cámaras
		------------------------------------------------
		fn pickCam obj =
		(
			_flag = false
			_flag = (classof obj == Freecamera) or (classof obj == Targetcamera)
		)

		------------------------------------------------
		--@fn: undefined | calculateNewLens | Calcula el nuevo valor de apertura de camara.
		------------------------------------------------
		fn calculateNewLens =
		(
			--Calculamos el valor de la lente nueva con la formula: lenteNueva = (anchoRenderViejo/anchoRenderNuevo) * lenteVieja 
			spnNewLens.value = (((spnOldRenderWidth.value as Float) / (spnNewRenderWidth.value as Float)) * spnOldLens.value)
			--Actualizamos el nombre del botón de duplicar cámara
			btnDuplicateCamera.caption = "Duplicate w lens:" + ((round spnNewLens.value precision:3) as String)
		)

		------------------------------------------------
		--@fn: undefined | calculateNewLens | Calcula el nuevo valor de anchura de render.
		------------------------------------------------
		fn calculateNewRenderWidth =
		(
			--Calculamos el valor del ancho de render nuevo con la formula: anchoRenderNuevo = (anchoRenderViejo/lenteNueva) * lenteVieja
			_newRenderWidth = (((spnOldRenderWidth.value as Float) / (spnNewLens.value as Float)) * spnOldLens.value)
			--Hacemos el redondeo del valor decimal a mano, si es mayor que 0.5 redondeamos hacia arriba (+1) y sino hacia abajo (quitamos los decimales)
			spnNewRenderWidth.value = round _newRenderWidth
			--Actualizamos el nombre del botón de duplicar cámara
			btnDuplicateCamera.caption = "Duplicate w lens:" + ((round spnNewLens.value precision:3) as String)
		)
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
			if size.x < minRollWidth then (size.x = minRollWidth; rollCameraMappingApplicatorDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollCameraMappingApplicatorDef.height = size.y)
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | Evento del botón de duplicar cámara
		------------------------------------------------
		on btnDuplicateCamera pressed do
		(
			--Primero miramos que hay una camara elegida
			if pckPickCameraToDuplicate.object != undefined then
			(
				--Creamos la camara nueva
				_newCam = freeCamera()
				--Hacemos un backup de sus transformaciones
				_transform = pckPickCameraToDuplicate.object.transform
				
				--Miramos si existe la capa "_cams_"
				if (layerManager.getLayerFromName "_cam_") == undefined then
					--Si no existe creamos la capa y le metemos la cámara
					(layerManager.newLayerFromName "_cam_").addNode _newCam
				else
					--Si existe añadimos la cámara dentro
					(layerManager.getLayerFromName "_cam_").addNode _newCam
				
				--Ahora lo que hacemos es volver a poner la transformacion de la camara donde estaba desactivando la animacion
				with animate off
				(
					_newCam.transform = _transform
				)
				
				--Le ponemos el mismo nombre que la camara pero con el sufijo de cmap-(numero de frame)-(subnumero de camara dentro de ese frame)
				_name = pckPickCameraToDuplicate.object.name + "_cmap-" + (sliderTime as String)
				--Sacamos las camaras de la escena que esten en el mismo frame.
				_cams = for c in cameras where (findString c.name _name) != undefined collect c
				--Ahora miramos en que indice nos hemos quedado y definimos como indice inicial el uno en un contador.
				_cont = 1
				--Iteramos por las diferentes camaras.
				for c in _cams do
				(
					--Sacamos la parte del indice de la camara.
					_camIndex = ((filterString c.name "-") [(filterString c.name "-").count]) as Integer
					
					--Si el indice obtenido es un numero y es mayor que el indice ponemos el indice como ese numero + 1
					if(_camIndex != undefined) and (_camIndex >= _cont) do
					(
						_cont = _camIndex + 1
					)
				)
				
				--Sacamos el string del indice que tenemos que poner
				_cont = _cont as String
				--Creamos un string donde vamos a poner los ceros que nos hacen falta
				_zeros = ""
				--Y le añadimos ceros delante hasta llegar a los 3 digitos.
				for i=1 to (3 - _cont.count) do _zeros += "0"
				--Y se los ponermos al nombre
				_newCam.name = _name + "-" + _zeros + _cont
				--Le ponemos el valor de lens que tenemos en la calculadora.
				_newCam.fov = cameraFov.MMtoFOV spnNewLens.value
			)
			else --Si no hay una cámara elegida avisamos al usuario para que escoja una
				messageBox "No camera picked, click on Pick Cam to pick one."
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza cuando cogemos el ancho y alto de render de la escena
		------------------------------------------------
		on btnGetRenderValues pressed do
		(
			--Ponemos el valor de ancho de render de la escena
			spnOldRenderWidth.value = renderWidth
			--Recalculamos la nueva focal
			calculateNewLens()
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza cuando cogemos la lente de una camara seleccionada
		------------------------------------------------
		on btnGetCameraValues changed val do
		(
			--Cogemos la camara con pickObject y la almaceno en una variable
			_cam = pickObject filter:pickCam
			--Si lo que hemos cogido es válido...
			if _cam!=undefined then
			(
				--Ponemos el valor de ancho de render de la escena
				spnOldLens.value = cameraFov.FOVtoMM _cam.fov
				--Recalculamos la nueva focal
				calculateNewLens()
			)
			else --Sacamos un mensaje diciendo que tiene que seleccionar una camara.
				messageBox "A Camera is needed to get lens value."
			
			--Revertimos el boton a su estado inicial
			btnGetCameraValues.checked = false
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza cuando cambiamos el valor de la apertura de camara de render nueva
		------------------------------------------------
		on spnNewLens changed val do
		(
			calculateNewRenderWidth()
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza cuando cambiamos el valor de la anchura de render nueva
		------------------------------------------------
		on spnNewRenderWidth changed val do
		(
			calculateNewLens()
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza cuando cambiamos el valor de la anchura de render antigua
		------------------------------------------------
		on spnOldRenderWidth changed val do
		(
			calculateNewLens()
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza cuando cambiamos el valor de la anchura de render
		------------------------------------------------
		on spnOldLens changed val do
		(
			calculateNewLens()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollCameraMappingCalculatorDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollCameraMappingCalculatorDef open do
		(
			loadSettings()
			createSceneEvents()
			btnDuplicateCamera.caption = "Duplicate w lens:" + ((round spnNewLens.value precision:3) as String)
			if parent.rollMain != undefined then resize parent.rollMain.size
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollCameraMappingCalculatorDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollCameraMappingApplicatorDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollCameraMappingApplicatorDef | Contiene la herramienta cameraMappingManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollCameraMappingApplicatorDef "Camera Mapping Applicator"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 220		--@var: minWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 50		--@var: minHeight | Alto mínimo de la herramienta.		
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local pickedMap = undefined
		local renderWidthBackup = undefined
		local renderHeightBackup = undefined

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		button btnSearchImage "Search Map" height:20 width:95 pos:[105,5]
		pickbutton pckPickCamera "<Pick Camera>" height:20 width:95 pos:[5,5] autoDisplay:true filter:rollCameraMappingApplicatorDef.pickCam
		groupBox grpGeneralOptions "Render Options" height:80 width:95 pos:[5,25]
		checkBox chkSetRenderSize "Final Size" height:20  width:85 pos:[10,40] checked:true
		label lblRenderWidth "Width:" pos:[10,60] height:20 width:40
		spinner spnRenderWidth "" pos: [45,60] height:20 width:50 range: [1,99999,2048] type: #integer scale:1
		label lblRenderHeight "Height:" pos:[10,80] height:20 width:40
		spinner spnRenderHeight "" pos: [45,80] height:20 width:50 range: [1,99999,1108] type: #integer scale:1
		button btnResetOptions "Reset All" height:20 width:95 pos:[5,110]
		groupBox grpMapOptions "Map Options" height:105 width:95 pos:[105,25]
		label lblFiltering "Filtering:" height:20 width:70 pos:[113,40]
		label lblSeparator "______________" height:20 width:85 pos:[110,92]
		radiobuttons rdoMapOptions labels:#("Pyramidal", "Summed Area", "None") pos:[110,55]
		label lblBlur "Blur:" height:15 width:25 pos:[115,111]
		spinner spnMapBlur "" pos: [140,110] height:20 width:50 range: [0.01,100.0,1.0] type: #float scale:0.01
		button btnApply "Apply to Selection" height:20 width:195 pos:[5,135]
		
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
		--@fn: undefined | pickCam | Funcion de filtro que pasamos al pickbutton para que unicamente deje coger cámaras
		------------------------------------------------
		fn pickCam obj =
		(
			_flag = false
			_flag =(classof obj == Freecamera) or (classof obj == Targetcamera)
		)

		------------------------------------------------
		--@fn: undefined | buildMatName | Le pasamos una camara y construye el nombre del material. Si hay materiales con ese nombre, itera hasta hallar el que tiene índice mayor y crea el nuevo nombre con el numero siguiente.
		------------------------------------------------
		fn buildMatName camName =
		(
			--Guardo el nombre de la camara sustituyendo _ por - y con el prefijo mat_ siguiendo el naming convention
			_name = "mat_" + (substitutestring camName "_" "-")
			--Cargo todos los materiales de la escena en un array con una función de finishingFunctions.ms
			_mats = lb.materials.getSceneMaterials()
			--Me creo un numero que contenga el indice por defecto que le vamos a añadir al numero
			_number = "001"
			--Me los recorro mirando si hay alguno con ese nombre miro que indice tenía y si es mayor sobreescribo _number
			for i=1 to _mats.count do
			(
				--Miro si el nombre está en algún material como prefijo (si esta en medio o no existe lo ignoro)
				if (findString _mats[i].name _name) == 1 do
				(
					--Me creo una variable temporal para operar con el nombre del material y sacar su indice.
					_index = (filterString _mats[i].name "_")[3]
					--Miro si el indice existe y si es un numero.
					if (_index != undefined) and ((_index as Number) != undefined) do
						--Lo comparo con el sufijo actual y si es mayor sobreescribo el sufijo incrementando en 1 su valor.
						if (_number as Integer) <= (_index as Integer) do
						(
							--Incremento index y lo sobreescribo como String para ver cuantos digitos se me quedan.
							_index = ((_index as Number)+1) as String
							--Primero miro si el indice incrementado es mayor en longitud de digitos que el numero que teniamos nosotros.
							if _index.count < _number.count then
							(
								--Me creo un String donde voy a poner tantos ceros como haga falta para rellenar el nombre correctamente.
								_zeros = "";
								--Añado tantos ceros como diferencia en el número de dígitos con el valor anterior (_number)
								for i=1 to (_number.count - _index.count) do _zeros += "0"
								
								--Agrego el nuevo indice y los ceros de diferencia.
								_number = _zeros + _index 
							)
							else --Si tiene más digitos o los mismos lo añadimos directamente.
								_number = _index
						)
				)
			)
			--Añado el sufijo al material
			_name += "_" + _number
		)

		------------------------------------------------
		--@fn: undefined | createNewMaterial | reamos un material nuevo con el valor de nombre que le digamos en matName y lo devolvemos. Le añadiremos el bitmap que hayamos seleccionado en el UI en el difuso, sin tiling en x e y, y con los valores de filtering y blur que hayamos puesto en el interfaz. Si el bitmap es erroneo devolvemos undefined.
		------------------------------------------------
		fn createNewMaterial matName =
		(
			--Me creo una variable que será la que almacene el mapa nuevo que acabamos de crear.
			_material = standardMaterial()
			--Lo nombro con el nombre que he recibido en matName
			_material.name = matName
			--Le pongo la autoiluminación a 100
			_material.selfIllumAmount = 100.0
			--Ahora cargo el bitmap que tengo en una textura de tipo bitmap.
			_bmpTex = bitmapTexture()
			--Añade el mapa a la textura
			--Me creo un bitmap a partir del archivo que tengo
			_bmp = openBitMap pickedMap
			if _bmp != undefined then
			(
				--Añado el bitmap a la textura.
				_bmpTex.bitmap = _bmp
				--Añado el nombre a la textura.
				_bmpTex.filename = pickedMap
				--Quito el tiling de la textura
				_bmpTex.coords.U_Tile = false
				_bmpTex.coords.V_Tile = false
				--Ponemos el blur al valor que tenemos en el spinner de blur del interfaz
				_bmpTex.coords.blur = spnMapBlur.value
				--Ponemos los valores de filtering al que tengo seleccionado en el interfaz
				_bmpTex.filtering = rdoMapOptions.state - 1
				--Poner alpha source a None
				_bmpTex.alphasource = 2
				--Añadimos la textura al difuso del material
				_material.diffuseMap = _bmpTex
			)
			else --Devolvemos undefined porque el bitmap no era el correcto
				_material = undefined
			--Devolvemos el material
			_material
		)

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
			if size.x < minRollWidth then (size.x = minRollWidth; rollCameraMappingApplicatorDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollCameraMappingApplicatorDef.height = size.y)
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | Evento lanzado al pulsarse el botón de aplicar a seleccion
		------------------------------------------------
		on btnApply pressed do
		(
			--Sólo podemos empezar el proceso si tenemos algun objeto seleccionado
			if Selection.count > 0 then
			(
				--Tenemos que tener una camara seleccionada.
				if pckPickCamera.object != undefined then
				(
					--Tenemos que tener un mapa seleccionado.
					if pickedMap != undefined then
					(
						--Me creo el nombre del material a partir del de la camara.
						_matName = buildMatName pckPickCamera.object.name
						--Obtengo el del selectionSet quitandole el prefijo "mat_" al nombre del material
						_selSetName = substring _matName 5 (_matName.count - 4)
						--Me creo un flag para marcar si nos hemos encontrado con algún no objeto
						_nonObjectFound = false
						--Me creo un material con el nombre que hemos hallado antes y las propiedades definidas por el UI.
						_mat = createNewMaterial _matName
						--Miramos si hemos podido crear el material deseado
						if _mat != undefined then
						(
							--Añadimos el mapa al editor de materiales (en el primer slot)
							meditMaterials[1] = _mat
							--Nos recorremos toda la seleccion y cogemos la geometría.
							_geometry = for obj in Selection where ((superClassOf obj) as String) == "GeometryClass" collect obj
							--Si hay al menos un objeto de geometría, le aplicamos el mapa.
							if _geometry.count > 0 then
							(
								--Hacemos el backup de los valores de anchura y altura de render
								renderWidthBackup = renderWidth
								renderHeightBackup = renderHeight
								--Ponemos el ancho y el alto del bitmap de la textura en el tamaño de render
								renderWidth = _mat.diffuseMap.bitmap.width
								renderHeight = _mat.diffuseMap.bitmap.height
								--Nos recorremos toda la geometría y le vamos aplicando los mapas y el modificador de camera map.
								for i=1 to _geometry.count do
								(
									--Cargamos el material en el objeto
									_geometry[i].mat = _mat
									--Y después el modificador de camera map
									--Creamos un nuevo modificador de cameraMap
									_camMap = CameraMap()
									--Y se lo añadimos encima de todo los demás. 
									addModifier _geometry[i] _camMap before:0
									--Aplicamos la camara que hemos seleccionado para proyectar el mapeado.
									_camMap.cameraNode = pckPickCamera.object
								)
								
								--Al terminar hacemos el mapa visible en el viewport
								_mat.showInViewPort = true
								--Creamos un selection set con la geometria y el nombre que hemos hallado antes
								selectionSets[_selSetName] = _geometry
								
								--Si tenemos el check de final render activado
								if chkSetRenderSize.checked then
								(
									--Ponemos el ancho y el alto de los controles de render optiones en los de la escena 
									renderWidth = spnRenderWidth.value
									renderHeight = spnRenderHeight.value
								)
								else --Si no está terminado entonces cargamos el que habiamos almacenado en el backup
								(
									renderWidth = renderWidthBackup
									renderHeight = renderHeightBackup
								)
								
								--Reseteamos las variables de backup
								renderWidthBackup = undefined
								renderHeightBackup = undefined
							)
							else --En el caso en el que no tengamos geometría entonces daremos un aviso.
								messageBox "No geometry selected. Select one geometry object at least to proceed."
						)
						else --Si el mapa que hemos intentado cargar es erroneo se lo hacemos saber al usuario.
							messageBox "Selected map isn't a valid map file. Choose another one."
					)
					else --Si no hay mapa seleccionado entonces avisamos al usuario
						messageBox "No map selected, click on Search Map to select one."
				)
				else --Si no hay camara avisamos al usuario
					messageBox "No camera picked, click on <Pick Camera> to pick one." 
			)
			else --Si no hay nada seleccionado lanzamos un mensaje de aviso
				messageBox "No objects selected, select one or more objects to start camera mapping"
		)

		------------------------------------------------
		--@event: pressed | Evento lanzado al pulsarse el botón de abrir imagen
		------------------------------------------------
		on btnSearchImage pressed do
		(
			--Sacamos una ventana para que el usuario seleccione el archivo de imagen
			_filename = getOpenFileName caption: "Open Image File" types: "Image files (*.*)|*.*|All|*.*|"
			--Si el archivo no es nulo y existe.
			if _filename != undefined and doesFileExist _filename then
			(
				--Almacenamos su ruta
				pickedMap = _filename
				--Lo añadimos al nombre del boton y a su tooltip
				btnSearchImage.caption = filenameFromPath _filename
				btnSearchImage.tooltip = filenameFromPath _filename
			)
			else --Reseteamos la variable del mapa y su boton.
			(
				pickedMap = undefined
				btnSearchImage.caption = "Search Map"
				btnSearchImage.tooltip = "Search Map"
			)
		)

		------------------------------------------------
		--@event: changed | Checkbox de activar los controles de render
		------------------------------------------------
		on chkSetRenderSize changed val do
		(
			--Activamos o desactivamos las opciones de render en función del checkbox
			spnRenderWidth.enabled = val
			spnRenderHeight.enabled = val
		)

		------------------------------------------------
		--@event: pressed | Botón de reset de render options y map options
		------------------------------------------------
		on btnResetOptions pressed do
		(
			--Reseteamos las opciones de render
			spnRenderWidth.value = 2048
			spnRenderHeight.value = 1108
			
			--Reseteamos las opciones de map
			rdoMapOptions.state = 1
			spnMapBlur.value = 1.0
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollCameraMappingApplicatorDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollCameraMappingApplicatorDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			lblSeparator.enabled = false
			if parent.rollMain != undefined then resize parent.rollMain.size
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollCameraMappingApplicatorDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollCameraMappingApplicatorDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: cameraMappingManager | Contiene la herramienta cameraMappingManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_cameraMappingManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Camera Mapping Manager",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
		
		minWidth = 220,		--@var: minWidth | Ancho mínimo de la herramienta.
		minHeight = 325,		--@var: minHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------

		rollCameraMappingCalculator = rollCameraMappingCalculatorDef,	--@var: rollExample1 | Almacena el rollout de rollCameraMappingCalculator de la herramienta.
		rollCameraMappingApplicator = rollCameraMappingApplicatorDef,	--@var: rollExample2 | Almacena el rollout de rollCameraMappingApplicator de la herramienta.
		rollMain = undefined,

		subRollouts = #(this.rollCameraMappingCalculator, this.rollCameraMappingApplicator), --@var: subRollouts | Almacena los rolllouts flotantes.

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
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute this.cfgFile ("rollMain/pos") "x" (this.rollMain.pos.x as string)
			lb.xml.setAttribute this.cfgFile ("rollMain/pos") "y" (this.rollMain.pos.y as string)
			
			--almacena tamaño
			lb.xml.setAttribute this.cfgFile ("rollMain/size") "width" (this.rollMain.size.x as string)
			lb.xml.setAttribute this.cfgFile ("rollMain/size") "height" (this.rollMain.size.y as string)
		),
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute this.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute this.cfgFile ("rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute this.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute this.cfgFile ("rollMain/pos") "y") as integer
				
			--establece minimos
			if _width < this.minWidth then _width = this.minWidth
			if _height < this.minHeight then _height = this.minHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			this.rollMain.size.x = _width
			this.rollMain.size.y = _height
			this.rollMain.pos = [_posX,_posY]
		),

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
		--@fn: undefined | addSubRollouts | Añade los subRollouts flotantes de la herramienta.
		------------------------------------------------
		fn addSubRollouts =
		(
			if this.rollMain != undefined then
				for _sbr in this.subRollouts do
					addRollout _sbr this.rollMain --border:false
		),

		------------------------------------------------
		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
		------------------------------------------------
		fn createInterface =
		(
			--crea el interface, lo redimensiona y lo reposiciona
			this.rollMain = newRolloutFloater "Camera Mapping Manager"  220 325 -10000 0
			this.loadSettings()
			this.addSubRollouts()
		),
		
		------------------------------------------------
		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
		------------------------------------------------
		fn destroyInterface =
		(
			if this.rollMain != undefined then
			(
				this.saveSettings()
				closeRolloutFloater this.rollMain --cierra la herramienta.
			)
		),
		
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
	)--tl_cameraMappingManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_cameraMappingManager() --crea la herramienta
)