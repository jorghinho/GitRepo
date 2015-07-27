------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta ffdManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta ffdManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Copy FFD"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 185		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------ 

		local FFds -- FFds seleccionados
		local FFDsTrans -- Array con la posicion de FFds
		local FFDsPpos -- Array con la posicion de los puntos de control de FFds

		local FFdsCopy -- Array con las copias, instancias o referencias de los FFDs seleccionados
		local FFDsToWork -- Array con los FFds a los que aplicar las opciones de mirror			
		local okOnExit=0

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox gbMirrorOptions "Mirror Options" pos:[5,5] width:210 height:85
		radioButtons rbMirrorXYZ "" pos:[10,25] width:111 height:32 enabled:true labels:#("X                  ", "Y", "Z", "XY", "YZ", "ZX") default:1 columns:3
		spinner spOffset "" pos:[155,65] range:[-100000,100000,0] width:50 height:16
		label lbOffset "Offset:" pos:[115,66] width:40 height:15
		groupBox gbCloneOptions "Clone Options" pos:[5,95] width:210 height:60
		radioButtons rbCloneOptions "" pos:[10,115] width:146 height:32 enabled:true labels:#("No Clone                            ", "Copy") default:1 columns:2
		button btnOK "OK" pos:[5,160] width:90 height:20
		button btnCancel "Cancel" pos:[125,160] width:90 height:20
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | getFFDpointsPositions | Devuelve un array con la posicion de los points de control del FFD que se pasa por parametro
		------------------------------------------------
		fn getFFDpointsPositions ffdToGetValues =
		(
			local FFDPoints=#()
			
			-- Recorre cada point del FFD y guarda su valor en el array que devuelve la funcion
			for i=1 to ffdToGetValues[4][8].numSubs do -- Numeros de points en el FFD
			(
				FFDPoints[i]=ffdToGetValues[4][8][i].value
			)
			
			FFDPoints
		) -- getFFDpointsPositions		

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | makeFFDpointsAnimatable | Crear una clave de animacion en el frame 0, para todos los puntos de control del FFD para posteriormente borrarla. Requisito para poder mover los puntos de control del FFD
		------------------------------------------------
		fn makeFFDpointsAnimatable ffdToAnimate =
		(
			-- Definimos constantes
			
			local wmUser = 1024 -- Ventanas de interaccion de usuario
			local ccSpinnerChange = wmUser + 600 -- Mensaje para cambio de spinner
			
			-- Seleccionamos el ffd para el que crear las claves, cambiamos a modo modificacion y vamos a la altura de los control points.
			select ffdToAnimate
			max modify mode
			subObjectLevel = 1
			
			-- Seleccionamos todos los puntos de control, vamos a modo transformacion y abrimos el cuadro de dialogo transformacion.
			max select all
			max move
			max tti
			
			-- Buscamos el cuadro de dialogo de Transform Type In
			local desktopHWND = windows.getDesktopHWND()
			local desktopChildren = windows.getChildrenHWND desktopHWND
			local tti
			
			-- Recorremos todas las ventanas comprobando que el nombre sera Transform Type-In, establece la variable tti con el handler de dicha ventana.
			_stop = false
			for child in desktopChildren where not _stop do
			(
				if (child[5] == "Move Transform Type-In") then
				(
					tti = child
					_stop = true
				)
			)
			
			if(tti != undefined) then
			(
				local ttiHWND = tti[1] -- Obtenemos el manejador al cuadro Transform type-in
				local ttiChildren = windows.getChildrenHWND ttiHWND -- Buscamos un spinner entre los elementos de la ventana
				local anySpinner
				_stop = false
				for child in ttiChildren where not _stop do
				(
					if (child[4] == "SpinnerControl") then
					(
						anySpinner = child
						_stop = true
					)
				)
				
				if (anySpinner != undefined) then
				(
					local anySpinnerHWND = anySpinner[1] -- Obtenemos el manejador al spinner
					local anySpinnerDlgID = uiaccessor.GetWindowResourceID anySpinnerHWND -- Obtenemos el id del cuadro de dialogo del spinner
					local anySpinnerParent = uiaccessor.getparentwindow anySpinnerHWND -- Obtenemos el id del padre del cuadro de dialogo del spinner
					
					animButtonState = true -- Activamos autoKey
					local oldSliderTime = sliderTime -- Guardamos la posicion actual del frame					
					sliderTime = 1 -- Cambiamos al frame 1
					windows.sendmessage anySpinnerParent ccSpinnerChange anySpinnerDlgID anySpinnerHWND -- Lanzamos el evento que cambiaria el valor del transform type-in pero sin cambiar el valor
					sliderTime = oldSliderTime -- Volvemos a la posicion de frame original
					animButtonState = false -- Desactivamos el modo autoKey
					
					UIAccessor.CloseDialog ttiHWND -- Cerramos el cuadro de dialogo Transform Type-In
					
					-- Borramos la clave creada
					selectKeys ffdToAnimate[4][8] 0f 1f
					deleteKeys ffdToAnimate[4][8] #selection
					
					-- Salimos del modo modificacion
					subObjectLevel = 0
					deselect ffdToAnimate					
				)
			)
		) -- makeFFDpointsAnimatable

		------------------------------------------------
		--@fn: undefined | storeFFDvalues | Guarda en un array la transformacion de cada uno de los FFDs (local FFDsTrans), Guarda en otro array la posicion de los puntos de control de cada uno de los FFDs (local FFDsPpos)
		------------------------------------------------
		fn storeFFDvalues =
		(
			-- Guardamos la transformacion de cada de los FFds en un array y la posicion de cada punto de control
			FFdsTrans = #()
			FFDsPpos = #()
			
			-- Creamos pista de animacion para poder mover la posicion de los puntos de control
			-- Guardamos en el array de posiciones de los puntos de control de cada FFD el array devuelto por la funcion de obtenicion de posiciones de puntos de control.
			for _FFD in FFds do
			(
				append FFDsTrans _FFD.transform
				makeFFDpointsAnimatable _FFD
				append FFDsPpos (getFFDpointsPositions _FFD)
			)
			
			-- Recuperamos la seleccion inicial
			select FFDs
		) -- storeFFDvalues

		------------------------------------------------
		--@fn: undefined | createCopyOfFFDs | Crea un array de copias de los FFDs seleccionados
		------------------------------------------------
		fn createCopyOfFFDs FFDs copyType =
		(
			_FFDsCopy = #()
			
			if (copyType == 2) then
			(
				for _FFD in FFds do
				(
					_FFDCopy = undefined
					_FFDCopy = copy _FFD -- Crear una copia de cada uno de los FFds y lo añado al array de copias
					append _FFDsCopy _FFDCopy
				)
			)
			
			_FFDsCopy
		) --createCopyOfFFDs

		------------------------------------------------
		--@fn: undefined | getArrayOfAxisToWork | Devuelve un array con los ejes sobre las que se debe aplicar el offset en funcion del radio button Mirror seleccionado.
		------------------------------------------------
		fn getArrayOfAxisToWork state =
		(
			_arrayOfAxis = #(1)
			
			--------------- Se aplica el nuevo offset ----------------------
			case of
			(
				(state < 4): _arrayOfAxis=#(state)
				(state == 4): _arrayOfAxis=#(1,2)
				(state == 5): _arrayOfAxis=#(2,3)
				(state == 6): _arrayOfAxis=#(3,1)
			) --> End case
			
			_arrayOfAxis
		) --getArrayOfAxisToWork

		------------------------------------------------
		--@fn: undefined | resetOffset | Resetea la posicion del FFD a la original
		------------------------------------------------
		fn resetOffset FFDsToResetOffset =
		(
			for i = 1 to FFDsToResetOffset.count do
			(	
				FFDsToResetOffset[i].transform = FFDsTrans[i]
			)
		) --resetOffset

		------------------------------------------------
		--@fn: undefined | getOriginalOffSet | Obtiene la transformacion original del FFD
		------------------------------------------------
		fn getOriginalOffSet FFDIndex axis =
		(
			case axis of
			(
			1: originalOffSet = FFDsTrans[FFDIndex].position.x
			2: originalOffSet = FFDsTrans[FFDIndex].position.y
			3: originalOffSet = FFDsTrans[FFDIndex].position.z 	
			)
			
			originalOffSet
		) --getOriginalOffS

		------------------------------------------------
		--@fn: undefined | applyFFDpositionOffset | Aplicamos el valor del campo offset al FFD
		------------------------------------------------
		fn applyFFDpositionOffset FFDToApplyOffset offSet original axis_index =
		(
			_axis = #("X","Y","Z")
			_axisOffset = _axis[axis_index] as string + "_Position"
			deleteitem _axis axis_index -- Dejamos en el array los dos ejes restantes que no sufren modificacion			
			
			-- Aplicamos el offset al eje indicado
			FFDToApplyOffset.transform.controller.position.controller[_axisOffset].value = original + offSet -- El eje que modificamos
		) --applyFFDpositionOffset

		------------------------------------------------
		--@fn: undefined | getFFDsegments | Obtiene el numero de segmentos del FFD
		------------------------------------------------
		fn getFFDsegments ffdToGetSegments =
		(
			FFDInfo = ffdToGetSegments[4].value as string
			fieldsTotal = filterString FFDInfo " "
			dimension = fieldsTotal[2]
			fieldSegments = filterString dimension "x"
			ySegments = fieldSegments[1] as integer
			xSegments = fieldSegments[2] as integer
			zSegments = fieldSegments[3] as integer
			
			[xSegments,ySegments,zSegments] -- Debolvemos un point 3 con los segmentos en x, y , z
		) --getFFDsegments

		------------------------------------------------
		--@fn: undefined | getInvertedFFDpointsIndex | Crea un array a partir de cual seria el indice del controlador invertido en el eje indicado
		------------------------------------------------
		fn getInvertedFFDpointsIndex zSegments ySegments xSegments axis =
		(
			invertCubeArray= #()
			controlNumber = 1
			for i = 1 to zSegments do
			(
				invertCubeArrayY = #()
				
				for j = 1 to ySegments do
				(
					InvertCubeArrayX = #()
					
					for k = 1 to xSegments do
					(
						if (axis == "x") then invertCubeArrayX[(xSegments + 1) - k] = controlNumber
						else invertCubeArrayX[k] = controlNumber
						controlNumber = controlNumber + 1
					)
					
					if (axis == "y") then invertCubeArrayY[(ySegments + 1) - j] = invertCubeArrayX
					else invertCubeArrayY[j] = invertCubeArrayX
				)
				
				if (axis == "z") then invertCubeArray[(zSegments + 1) - i] = invertCubeArrayY
				else invertcubeArray[i] = invertcubeArrayY
			)
			
			-- Crea un array unidimensional a partir del array cubico
			_invertedPointsIndex = #()
			controlIndex = 1
			for i = 1 to zSegments do
			(
				for j = 1 to ySegments do
				(
					for k = 1 to xSegments do
					(
						_invertedPointsIndex[controlIndex] = invertCubeArray[i][j][k]
						controlIndex = controlIndex + 1
					)
				)
			)
			
			_invertedPointsIndex
		) --getInvertedFFDpointsIndex

		------------------------------------------------
		--@fn: undefined | getInvertFFDpointsPositions | Devuelve un array con la posiciones de los puntos de control invertidas en el eje indicado.
		------------------------------------------------
		fn getInvertFFDpointsPositions FFDpointsPositions zSegments ySegments xSegments invertAxis =
		(
			invertedFFDPoints = #()
			
			_FFDPoints = deepcopy FFDpointsPositions
			
			for i=1 to _FFDPoints.count do -- Numeros de points en el FFD
			(
				invertedFFDPoints[i] = _FFDPoints[i]
				
				case invertAxis of
				(
					"x": invertedFFDPoints[i][1] = 1-(_FFDPoints[i][1])
					"y": invertedFFDPoints[i][2] = 1-(_FFDPoints[i][2])
					"z": invertedFFDPoints[i][3] = 1-(_FFDPoints[i][3])
				)
			)
			----------------------------------------------------------------
			-- Obtiene un array con la equivalencia de los points invertidos
			----------------------------------------------------------------
			_invertedIndexes = getInvertedFFDpointsIndex zSegments ySegments xSegments invertAxis
			_defInvertedFFDPoints = #()
			for i=1 to _invertedIndexes.count do
			(
				_defInvertedFFDPoints[i] = invertedFFDPoints[_invertedIndexes[i]]
			)
			invertedFFDPoints = _defInvertedFFDPoints
			
			----------------------------------------------------------------
			invertedFFDPoints
		) --getInvertFFDpointsPositions

		------------------------------------------------
		--@fn: undefined | setFFDpointsPositions | Asigna al FFD la posicion de los puntos de control pasados por argumento
		------------------------------------------------		
		fn setFFDpointsPositions ffdToSetValues FFDPointsArray =
		(
			-- for i=1 to FFDPointsArray.count do -- Numeros de points en el array
			-- (
			-- 	ffdToSetValues[4][8][i].value = FFDPointsArray[i]
			-- )
			for i=1 to FFDPointsArray.count do -- Numeros de points en el array
			(
				ffdToSetValues[4][8][i].value = FFDPointsArray[i]
			)			
		) --setFFDpointsPositions

		------------------------------------------------
		--@fn: undefined | applyFFDmirror | Aplica al FFD el mirror de posicion de sus puntos de control en el eje indicado
		------------------------------------------------
		fn applyFFDmirror FFDtoApply FFDPpos axis=
		(
			setFFDpointsPositions FFDtoApply FFDPpos -- Dejamos el FFD original con las posiciones por defecto
			_segments = getFFDsegments FFDtoApply -- Obtenemos los segmentos del FFD al que aplicar la inversion
			_FFDsToWorkPpos = deepcopy FFDPpos -- Hamos una copia de las posiciones del FFD originales
			
			case axis of
			(
				1: invertAxis = #("x")
				2: invertAxis = #("y")
				3: invertAxis = #("z")
				4: invertAxis = #("x","y")
				5: invertAxis = #("y","z")
				6: invertAxis = #("z","x")
			)
			
			for axis in invertAxis do
			(
				_FFDPointsInvert=getInvertFFDpointsPositions _FFDsToWorkPpos _segments.x _segments.y _segments.z axis	-- Obtenemos un array con las posiciones invertidas. Tenemos que pasar un array de point Positions del FFD original
				setFFDpointsPositions FFDtoApply _FFDPointsInvert -- Esblecemos el valor de los points en el FFD seleccionado dependiendo de si esta activa la opcion de clone options o no
				_FFDsToWorkPpos = deepcopy _FFDPointsInvert -- Actualizamos las posiciones para la proxima interaccion del for
			)
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

			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "rbMirrorXYZ" (rbMirrorXYZ.state as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "rbCloneOptions" (rbCloneOptions.state as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "spOffset" (spOffset.value as string)
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


			rbMirrorXYZ.state = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "rbMirrorXYZ") as integer	

			if rbMirrorXYZ.state == 0 then
			(
				rbMirrorXYZ.state = 1
			)
									
			rbCloneOptions.state = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "rbCloneOptions") as integer

			if rbCloneOptions.state == 0 then
			(
				rbCloneOptions.state = 1
			)
			
			spOffset.value = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "spOffset") as integer
				
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

		on rbCloneOptions changed state do
		(
			delete FFDsToWork
			resetOffset FFDs -- Hacemos un reset del offset
			FFDsToWork = createCopyOfFFDs FFDs state
			_axisToWork = getArrayOfAxisToWork(rbMirrorXYZ.state) -- Creamos un array con los ejes sobre los aplicar el offset

			-- Creamos una referencia al array de los FFDs originales o al de las copias en funcion de la radio button seleccionado (no clone, copy)
			case rbCloneOptions.state of
			(
				1: _FFDsToWork = FFds 
				2: _FFDsToWork = FFDsToWork
			)
			
			-- Aplicamos a cada uno de los FFDs del array el offset en los ejes requeridos 
			for j = 1 to _FFDsToWork.count do
			(
				setFFDpointsPositions FFDs[j] FFDsPpos[j] -- Aplicamos el mirror al FFD original
				
				for i = 1 to _axisToWork.count do
				(
					-- Aplicamos el mirror al FFD copia
					applyFFDmirror _FFDsToWork[j] FFDsPpos[j] rbMirrorXYZ.state
					originalOffset = getOriginalOffSet j _axisToWork[i]
					applyFFDpositionOffset _FFDsToWork[j] spOffset.value  originalOffset _axisToWork[i]
				)				
			)
		)
		
		on rbMirrorXYZ changed state do
		(
			resetOffset FFDsToWork -- Reseteamos el offset de los FFds copias
			resetOffset FFDs -- Reseteamos el offset de los FFds originales
			_axisToWork = getArrayOfAxisToWork(rbMirrorXYZ.state) -- Creamos un array con los ejes sobre los aplicar el offset
			
			-- Creamos una referencia al array de los FFDs originales o al de las copias en funcion de la radio button seleccionado (no clone, copy)
			case rbCloneOptions.state of
			(
				1: _FFDsToWork = FFds
				2: _FFDsToWork = FFDsToWork
			)
			
			-- Aplicamos a cada uno de los FFDs del array el offset en los ejes requeridos 
			for j = 1 to _FFDsToWork.count do
			(
				setFFDpointsPositions FFDs[j] FFDsPpos[j] -- Aplicamos el mirror al FFD original
				applyFFDmirror _FFDsToWork[j] FFDsPpos[j] rbMirrorXYZ.state -- Aplicamos el mirror al FFD
				
				for i = 1 to _axisToWork.count do
				(
					originalOffset = getOriginalOffSet j _axisToWork[i]
					applyFFDpositionOffset _FFDsToWork[j] spOffset.value  originalOffset _axisToWork[i]
				)					
			)
		)

		on btnOK pressed do 
		(
			saveSettings() -- Salva la posicion de los botones
			okOnExit=1
			destroyDialog rollMainDef -- Cerramos la aplicacion
		)
		
		on btnCancel pressed do 
		(
			destroyDialog rollMainDef -- Finaliza la apliacion
		)
		
		on spOffset changed val do
		(
			_axisToWork = getArrayOfAxisToWork(rbMirrorXYZ.state) -- Creamos un array con los ejes sobre los aplicar el offset
			
			-- Creamos una referencia al array de los FFDs originales o al de las copias en funcion de la radio button seleccionado (no clone, copy)
			case rbCloneOptions.state of
			(
				1: _FFDsToWork = FFds
				2: _FFDsToWork = FFDsToWork
			)
			
			-- Aplicamos a cada uno de los FFDs del array el offset en los ejes requeridos 
			for j = 1 to _FFDsToWork.count do
			(
				for i = 1 to _axisToWork.count do
				(
					originalOffset = getOriginalOffSet j _axisToWork[i]
					applyFFDpositionOffset _FFDsToWork[j] spOffset.value  originalOffset _axisToWork[i]
				)				
			)
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
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			updateToolbarButtons()
			FFds = getCurrentSelection() -- Almacenamos los objetos seleccionados en el un array (ya se ha comprobado que son FFD y que al menos tenemos uno seleccionado)
			storeFFDvalues() -- Guardamos los valores de transformacion y posicion de los puntos de control de cada uno de los FFD seleccionados.
			FFDsToWork = createCopyOfFFDs FFDs rbCloneOptions.state -- Creamos los arrays de copias en funcion de la opcion elegida
			redrawviews()
			_axisToWork = getArrayOfAxisToWork(rbMirrorXYZ.state) -- Creamos un array con los ejes sobre los aplicar el offset
			
			-- Creamos una referencia al array de los FFDs originales o al de las copias en funcion de la radio button seleccionado (no clone, copy)
			case rbCloneOptions.state of
			(
				1: _FFDsToWork = FFds
				2: _FFDsToWork = FFDsToWork
			)
			
			-- Aplicamos a cada uno de los FFDs del array el offset en los ejes requeridos 
			for j = 1 to _FFDsToWork.count do
			(
				applyFFDmirror _FFDsToWork[j] FFDsPpos[j] rbMirrorXYZ.state -- Aplicamos el mirror al FFD
				
				for i = 1 to _axisToWork.count do
				(
					originalOffset = getOriginalOffSet j _axisToWork[i]
					applyFFDpositionOffset _FFDsToWork[j] spOffset.value  originalOffset _axisToWork[i]
				)
				
			)
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
			
			-- Comprobamos si hemos salido haciendo clic en accept o bien en cancel
			if okOnExit == 0 then
			(
				delete FFDsToWork -- Borramos las copias
				resetOffset FFDs -- Resetamos el offset del FFD original
				
				-- Dejamos los vertices de control en la posicion original
				for i=1 to FFDs.count do
				(
					setFFDpointsPositions FFDs[i] FFDsPpos[i]
				)
			)
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_ffdManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "FFD Manager",		--@var: description | Descripcion de la tool.
		
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
		--@fn: undefined | areObjectsFFDs | Comprueba que todos los objetos seleccionados con de tipo FFD
		------------------------------------------------
		fn areObjectsFFDs objectsToCheck =
		(
			_process = true
			
			if (objectsToCheck.count == 0) then -- Comprueba que al menos hayamos seleccionado un objeto
			(
				messageBox "Select at least one FFD before execute this tool."
				_process = false
			)
			else
			(
				-- comprobamos que el tipo de objetos seleccionado es el correcto
				_stop = false
				for obj in (objectsToCheck) where not _stop and (classof obj != SpaceFFDBox) do
				(
					_process = false
					_stop = true
				)
			)
			
			_process
		),	

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
			_FFds = getCurrentSelection() -- Guarda los objetos seleccionados en un array
			
			if (areObjectsFFDs _FFds) then
			(
				--crea el interface, lo redimensiona y lo reposiciona
				createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
				updateToolbarButtons()
			)
			else
			(
				messageBox "All objetcs selected must be FFD type."
			)
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
	)--tl_ffdManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_ffdManager() --crea la herramienta
)