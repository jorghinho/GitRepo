------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: libreria de animaci�n
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria lib_animation
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_animation
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Animation Functions",	--@var: string | description | Descripcion de la libreria.
		
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
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | setKeysTangents| Funci�n que establece las tangentes de entrada y salida de las claves seleccionadas
		--@gets: array | keys | Array con las keys a las que modificar el tipo
		--@gets: name | type | El tipo de tangente que se va a configurar: #auto, #custom, #fast, #slow, #step, #smooth
		-----------------------------------------------------------------------------------------------------
		fn setKeysTangents keys type =
		(
			_tangentKeys = #()
			
			for k in keys do
				try 
				(
					k.inTangentType = type
					k.outTangentType = type
				)
				catch()
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | deleteAnimation | Elimina la animaci�n de los nodos  subvencionados en el intervalo especificado
		--@gets: node | obj | Los objetos a los que les eliminaremos la animacion
		--@gets: interval | timeInterval | El intervalo de tiempo del que eliminaremos la animaci�n
		-----------------------------------------------------------------------------------------------------
		mapped fn deleteAnimation obj timeInterval =
		(
			deselectKeys obj
			selectKeys obj timeInterval
			deleteKeys obj #selection
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: array | deleteAnimation | Elimina la animaci�n de los nodos  subvencionados en el intervalo especificado
		--@gets: node | obj | Los objetos a los que consultar las keys
		--@gets: (opt)boolean | onlySelected | solo se obtienen las keys de los nodos seleccionados. Por defecto FALSE
		--@returns: array | selKeys | Array que contiene las keys del objeto seleccionado.
		-----------------------------------------------------------------------------------------------------
		fn getKeys obj onlySelected:false=
		(
			selKeys = #() 
			
			-- buscamos custom attributes
			try
			(
				for i = 1 to obj.custAttributes.count do
					join selKeys (getKeys obj.custAttributes[i] onlySelected:onlySelected)
			)
			catch()

			-- Si no hay m�s subobjetos buscamos las keys de la pista
			if obj.numSubs == 0 then 
			(
				if obj.controller != undefined then
				(
					for k in obj.controller.keys where onlySelected == false or k.selected do
						append selKeys k
				)
			)
			else	-- si hay subobjetos buscamos en ellos m�s claves
			(
				for i = 1 to obj.numsubs do
					join selKeys (getKeys obj[i] onlySelected:onlySelected)
			)
			
			selKeys
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: array | getSelectedKeys | Devuelve las keys seleccionadas del objeto OBJ
		--@gets: node | obj | Los objetos a los que les consultaremos la animacion
		--@returns: array | selKeys | Array que contiene las keys del objeto seleccionado.
		-----------------------------------------------------------------------------------------------------
		fn getSelectedKeys obj =
		(
			getKeys obj onlySelected:true
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: interval | getAnimRange | Devuelve el rango de animaci�n de la pieza seleccionada.
		--@gets: node | obj | Los objetos a los que les consultaremos la animacion
		--@gets: (opt)interval | timeRange | El rango del que consultaremos el rango de animacion. Por defecto (animationRange.start, animationRange.end)
		--@gets: (opt)boolean | includePRS | Se a�aden separadores del animTrack para la busqueda. Por defecto TRUE
		--@gets: (opt)boolean | includeMods | Se a�aden los Modifiers y tambi�n sus customAttributes para la busqueda. Por defecto FALSE
		--@returns: interval | interval | Intervalo de animaci�n.
		-----------------------------------------------------------------------------------------------------		
		fn getAnimRange obj timeRange:(interval animationRange.start animationRange.end) includePRS:true includeMods:false =
		(
			_startAnimRange = undefined
			_endAnimRange = undefined
			_animTracks = if lb.animInfo.hasAnimTracks obj then lb.animInfo.getAnimTracks obj else (lb.animInfo.getTracksFromObject obj showPRS:includePRS showMods:includeMods)
			
			--	Si no se han podido capturar los tracks consideramos que no los tiene
			if _animTracks == #error then _animTracks = #()
			
			--	Recorremos todos los animTracks buscando cu�les cambian de valor frame a frame
			for a in _animTracks where a.type != #separator do
			(
				_oldVal = at time timeRange.start a.track.value
				
				_startAnimRangeTMP = undefined
				_endAnimRangeTMP = undefined
				
				--	Para cada frame miramos si el animTrack ha cambiado de valor para determinar el rango.
				for t = timeRange.start to timeRange.end do
				(
					--Obtengo el valor del track para cada fotograma
					_newVal = (at time t a.track.value)
					
					if classof _newVal == Point3 then
						_different = (distance _newVal _oldVal > 0.001)
					else if superclassof _newVal == Number then
						_different = (abs(_newVal - _oldVal) > 0.001)
					else
						_different = (_newVal != _oldVal)
					
					if  _different then
					(
						_oldVal = _newVal
						
						if _startAnimRangeTMP == undefined then
						(
							_startAnimRangeTMP = t - 1
							_endAnimRangeTMP = t 
						)
						else
						(
							if t > _endAnimRangeTMP then _endAnimRangeTMP = t
						)
					)
					
				)
				
				if _startAnimRangeTMP != undefined then
				(
					if _startAnimRange == undefined then
					(
						_startAnimRange =  _startAnimRangeTMP
						_endAnimRange = _endAnimRangeTMP
					)
					else
					(
						if _startAnimRangeTMP < _startAnimRange then 
							_startAnimRange = _startAnimRangeTMP
						
						if _endAnimRangeTMP > _endAnimRange then 
							_endAnimRange = _endAnimRangeTMP
					)
				)
			)
			
			--CASO ESPECIAL CON NOISE--
			--Si no hemos encontrado animaci�n probaremos a ver si tiene Noise.
			if _startAnimRange == undefined then
			(
				_allControllers = lb.controller.getObjControllers obj
				_hasNoise = false
				
				--Recorreremos los controladores en busca de alguno que sea de tipo noise.
				for i=1 to _allControllers.count do
				(
					for j=1 to _allControllers[i].count where (classof _allControllers[i][j]) == SubAnim do
					(
						if classof _allControllers[i][j].parent == Noise_Rotation or classof _allControllers[i][j].parent == Noise_Position then
						(
							_hasNoise = true
						)
					)
				)
				
				if _hasNoise then
				(
					--Para hacer el calculo del rango usar� dos punteros (variables) uno que empezar� a la izquierda  e ir� de inicio a fin de rango
					-- y otro a la derecha que ir� de fin a inicio. En el momento en el que haya un cambio en posici�n o en rotaci�n el puntero se quedar�
					-- fijo, si al final de ambos bucles los punteros han llegado al final de su recorrido, y si se han quedado a mitad entonces ese ser� el rango.
					_leftLimit = timeRange.start
					_rightLimit = timeRange.end
					_time = timeRange.start
					
					--Bucle de inicio a fin con el puntero de la izquierda
					do
					(
						_currentRotation = undefined
						_currentPosition = undefined
						_nextRotation = undefined
						_nextPosition = undefined
						
						at time _time
						(
							_currentRotation = obj.rotation
							_currentPosition = obj.position
						)
						
						at time (_time+1)
						(
							_nextRotation = obj.rotation
							_nextPosition = obj.position
						)
						
						if _currentRotation == _nextRotation and _currentPosition == _nextPosition then
						(
							--Si son iguales movere el limite por la izquierda
							_leftLimit = _time + 1
						)
						
						--Una vez terminado la iteraci�n incrementaremos _time y comprobaremos que no hayamos terminado
						_time += 1
					)
					while (_leftLimit == _time and _time <= timeRange.end)
					
					--Ponemos _time al final para el siguiente bucle
					_time = timeRange.end
					
					--Bucle de fin a inicio con el puntero de la derecha
					do
					(
						_currentRotation = undefined
						_currentPosition = undefined
						_nextRotation = undefined
						_nextPosition = undefined
						
						at time _time
						(
							_currentRotation = obj.rotation
							_currentPosition = obj.position
						)
						
						at time (_time-1)
						(
							_nextRotation = obj.rotation
							_nextPosition = obj.position
						)
						
						if _currentRotation == _nextRotation and _currentPosition == _nextPosition then
						(
							--Si son iguales movere el limite por la izquierda
							_rightLimit = _time - 1
						)
						
						--Una vez terminado la iteraci�n decrementaremos  _time y comprobaremos que no hayamos terminado
						_time -= 1
					)
					while (_rightLimit == _time and _time >= timeRange.end)
					
					if _leftLimit != timeRange.end then
						_startAnimRange = _leftLimit
					
					if _rightLimit != timeRange.start then
						_endAnimRange = _rightLimit
				)-- if _hasNoise.
			)
			
			--	Si no se ha encontrado animaci�n devolvemos un intervalo de 0 frames
			if _startAnimRange == undefined then
			(
				_startAnimRange = timeRange.start
				_endAnimRange = _startAnimRange
			)	
			
			interval _startAnimRange _endAnimRange
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: boolean | makeKeyable | hace que todas las pistas del objeto pasado por parametros sean keyable o nonKeyable
		--@gets: track | obj | Los objetos a los que les modificaremos los tracks
		--@gets: boolean | state | Si es true, las pistas del obj seran keyable, si es false nonKeyable
		-----------------------------------------------------------------------------------------------------	
		mapped fn makeKeyable obj state = 
		(
			if obj.numsubs > 0 then
			(
				for i = 1 to obj.numsubs do
					makeKeyable obj[i] state
				
				--	Actualizamos los custom attributes
				for i = 1 to obj.custattributes.count do
					makeKeyable obj.custAttributes[i] state
			)
			else
			(
				if obj.controller == undefined then
					try lb.controller.createTrackController obj catch()
				
				if obj.controller != undefined then
					obj.controller.keyable = state
				
				--	Actualizamos los custom attributes
				for i = 1 to custattributes.count obj do
					makeKeyable obj.custAttributes[i] state
			)
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: boolean | isLocked | Indica si la pista del objeto pasado por par�metros est� o no bloqueada
		--@gets: node | obj | track del objeto que se quiere comprobar si est� bloqueado
		--@gets: (opt)boolean | considerOverride | indica si se tiene que tener en cuenta o no el track. Por defecto a false
		--@returns: boolean | undefined | True o False, seg�n est� la pista bloqueada o no.
		-----------------------------------------------------------------------------------------------------		
		fn isLocked obj considerOverride:false = 
		(
			LockedTracksMan.getLocked obj obj.parent obj.index considerOverride
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: boolean | isLockedTransform | Indica si la pista de transformacion proprcionada est� o no bloqueada. 
		--@gets: track | obj | track del objeto que se quiere comprobar si est� bloqueado
		--@gets: (opt)boolean | considerOverride | indica si se tiene que tener en cuenta o no el track.
		--@returns: boolean | undefined | True o False, seg�n est� la pista bloqueada o no.
		-----------------------------------------------------------------------------------------------------	
		fn isLockedTransform obj considerOverride:false = 
		(
			_isLocked = false

			if obj.numSubs != 0 then
			(
				for i=1 to obj.numsubs where not _isLocked do
					_isLocked = this.isLockedTransform obj[i] considerOverride:considerOverride
			)
			else
			(
				_isLocked = this.isLocked obj considerOverride:considerOverride
			)

			_isLocked
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | setLocks | Bloquea o desbloquea las pistas de animaci�n de OBJ
		--@gets: node/track | obj | puede ser un nodo o una pista de animaci�n suelta
		--@gets: boolean | state | Indica si hay que bloquear (true) o desbloquear (false)
		--@gets: (opt)boolean | affectChildren | Indica si tambi�n hay que bloquear todas las pistas descendientes. Por defecto, TRUE
		-----------------------------------------------------------------------------------------------------	
		mapped fn setLocks obj state affectChildren:true = 
		(
			if (classOf obj == subAnim and obj.numsubs == 0 and custattributes.count obj == 0) then
				LockedTracksMan.setLocks state obj obj.parent obj.index affectChildren
			
			if (classOf obj == subAnim and obj.controller != undefined and classOf obj.controller == float_limit) then
			(
				LockedTracksMan.setLocks state obj obj.parent obj.index affectChildren
				LockedTracksMan.setLocks state obj[1] obj[1].parent 1 affectChildren
			)
			
			if affectChildren then
			(
				for i = 1 to obj.numsubs do
					setLocks obj[i] state affectChildren:affectChildren
				
				--	Actualizamos los custom attributes
				for i = 1 to custattributes.count obj do
					setLocks obj.custAttributes[i] state affectChildren:affectChildren
			)
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | collapseObjectControllersByTransform | Colapsa un array de capas en posici�n, rotaci�n o escala de un objeto. 
		--@gets: node | obj | El objeto cuyos layers queremos colapsar
		--@gets: name | collapseType | El tipo de transformaci�n (#position,#rotation,#scale)
		--@gets: (opt)array | layersArray | Array con los indices de los layers (respecto de su list controller) que queremos colapsar en un bitarray llamado layersArray. Por defecto, undefined
		-----------------------------------------------------------------------------------------------------
		fn collapseObjectControllersByTransform obj collapseType layersArray:undefined =
		(
			--Primero miramos que tenga un controlador de lista
			--Sacamos el controlador correspondiente a la transformaci�n que hemos seleccionado
			if collapseType == #position then _listController = obj.position.controller
			else if collapseType == #rotation then _listController = obj.rotation.controller
			else if collapseType == #scale then _listController = obj.scale.controller
			
			--Si el controlador es de lista (ha sido freezeado) hacemos la operaci�n.
			if classof _listController == position_list or classof _listController == rotation_list or classof _listController == scale_list then
			(
				--Si no pasamos ningun bitarray de rangos entonces lo rellenamos con todas las capas del objeto
				if layersArray == undefined do
				(
					--En funci�n del controlador tomaremos toda la lista de uno u otro
					layersArray = #{}
					for i=1 to _listController.count do
						layersArray[i] = true
				)
				
				
				-- Si no tenemos layers de animaci�n entonces no tiene sentido que hagamos ningun collapse
				if layersArray.count > 0 then
				(
					--Creo un array vac�o para almacenar los fotogramas en los que hay clave
					_keysArray = #()
					for i=1 to layersArray.count do
						--Si es un layer que hemos seleccionado y existe en el controlador 
						--(lo hago comparando con i porque los dos siguientes al .count son available y weights (si miro comparando con undefined puedo cogerlos por error))
						if layersArray[i] and i <= _listController.count do
							--Agregamos todos los fotogramas de ese layer donde tiene clave.
							for j=1 to _listController[i].keys.count do 
								append _keysArray _listController[i].keys[j].time
					
					--Hago �nico el array de claves y lo ordeno.
					_keysArray = makeUniqueArray _keysArray
					sort _keysArray
					
			-- 			print "Fotogramas de animaci�n en esta transformaci�n."
			-- 			print (_keysArray As string)
					--Creo un array nuevo para almacenar el resultado de las transformaciones.
					_collapsedTransforms = #()
					
					--Si las capas no tienen animaci�n
					if _keysArray.count == 0 then
						append _keysArray 0f
					
					--Voy poniendo el timeline en los frames que est�n animados y voy apilando las transformaciones en el array
					for i=1 to _keysArray.count do
					(
						--Pongo el timeline en la clave para tomar sus valores
						sliderTime = _keysArray[i]
						--Me creo un nuevo registro en el array de transformaciones a cero.
						if collapseType == #rotation then
							append _collapsedTransforms (quat 0 0 0 1)
						else if collapseType == #scale then
							append _collapsedTransforms [1,1,1]
						else
							append _collapsedTransforms [0,0,0]
						
						--Empiezo a colapsar recorriendo los layers y apilando sus propiedades.
						if collapseType != #rotation then
						(
							for j=1 to layersArray.count do
							(
								--Recorro los layers
								if layersArray[j] and i <=_listController.count do
								(
									if collapseType == #position then
									(
										_collapsedTransforms[_collapsedTransforms.count].x += _listController[j].value.x * (_listController.weight[j] / 100.0)
										_collapsedTransforms[_collapsedTransforms.count].y += _listController[j].value.y * (_listController.weight[j] / 100.0)
										_collapsedTransforms[_collapsedTransforms.count].z += _listController[j].value.z * (_listController.weight[j] / 100.0)
									)
									else if collapseType == #scale then
									(
										_collapsedTransforms[_collapsedTransforms.count].x *= _listController[j].value.x * (_listController.weight[j] / 100.0)
										_collapsedTransforms[_collapsedTransforms.count].y *= _listController[j].value.y * (_listController.weight[j] / 100.0)
										_collapsedTransforms[_collapsedTransforms.count].z *= _listController[j].value.z * (_listController.weight[j] / 100.0)
									)
								)
							)
						)
						else
						(
							for j=layersArray.count to 1 by -1 do --las rotaciones en quat se multiplican en orden inverso al orden de los controladores
							(
								--Recorro los layers
								if layersArray[j] and i <=_listController.count do
								(
									_newRotComponent = _listController[j].value
									_layerWeight = (_listController.weight[j] / 100.0)
									
									_newRotComponent.x = (_newRotComponent.x)*_layerWeight
									_newRotComponent.y = (_newRotComponent.y)*_layerWeight
									_newRotComponent.z = (_newRotComponent.z)*_layerWeight
									
									_collapsedTransforms[_collapsedTransforms.count] = _collapsedTransforms[_collapsedTransforms.count]*_newRotComponent
								)
							)
						)--if collapse
					)
					
			-- 			print "Transformaciones:"
			-- 			print (_collapsedTransforms As String)
					--Primero cojo los indices de las capas que tengo que borrar.
					_layerIndexes = #()
					--Ahora lo que voy a hacer es colapsar todas las capas en la que m�s abajo est� de las seleccionadas.
					for i=1 to layersArray.count do
						--Si es un layer que hemos seleccionado y existe en el controlador 
						--(lo hago comparando con i porque los dos siguientes al .count son available y weights (si miro comparando con undefined puedo cogerlos por error))
						if layersArray[i] and i <=_listController.count do
							append _layerIndexes i
					
			-- 			print "Indices de capas que vamos a colapsar"
			-- 			print _layerIndexes As String
					
					--Borramos todos los layers que hemos de colapsar y sus animtracks de atr�s a adelante
					for i=_layerIndexes.count to 2 by -1 do
					(
						_listController.delete _layerIndexes[i]
					)
					
					--Luego cojo la primera de todas las capas seleccionadas y le aplico las claves que hemos obtenido antes.
					
			-- 			print "Nombre y clase de la capa sobre la que vamos a colapsar."
			-- 			print (classof _listController[_layerIndexes[1]])
			-- 			print _listController[_layerIndexes[1]].name
			-- 			print (numKeys _listController[_layerIndexes[1]].controller) As String
					
					--Creamos un controlador vacio
					if collapseType == #position then
						_collapsedController = Position_XYZ()
					else if collapseType == #rotation then
						_collapsedController = Euler_XYZ()
					else
						_collapsedController = ScaleXYZ()
					
					--Borramos todas sus claves
					deleteKeys _listController[_layerIndexes[1]].controller #allKeys
					with animate on
					(
						if _keysArray.count > 0 then
						(
							for i=_keysArray.count to 1 by -1 do
							(
								addNewKey _collapsedController _keysArray[i]
								sliderTime = _keysArray[i]
								_collapsedController.value = _collapsedTransforms[i]
			-- 						print ("Fotograma: " + sliderTime As String)
			-- 						print _collapsedController.value
								
								--print ("Creamos clave en " + _listController[_layerIndexes[1]].name + " fotograma " + _keysArray[i] As String + " con valor " + _collapsedTransforms[i] As String)
								/*--Creamos una nueva clave
								addNewKey _listController[_layerIndexes[1]].controller _keysArray[i]
								
								--Ponemos el slider a la posicion de la clave y le ponemos valor.
								sliderTime = _keysArray[i]
								if collapseType == #position then
								(
									obj.position = _collapsedTransforms[i]
								)
								else if collapseType == #rotation then
									obj.rotation = _collapsedTransforms[i]
								else
									obj.scale = _collapsedTransforms[i]
								_listController[_layerIndexes[1]].controller.value = _collapsedTransforms[i]
								print ("Con valor " + _listController[_layerIndexes[1]].value As String)*/
							)
						)
						else
						(
							_collapsedController.value = _collapsedTransforms[i]
						)
					)
					--Elimino el de m�s abajo
					_listController.delete _layerIndexes[1]
					--Agrego el nuevo a la lista
					_listController.available.controller =  _collapsedController
					
					--Corto el ultimo que he agregado
					_listController.cut (_listController.getCount())
					--Lo pego donde estaba el antiguo
					_listController.paste _layerIndexes[1]
					
			-- 			sliderTime = 0f
			-- 			print "Fotograma 0"
			-- 			print _listController[_layerIndexes[1]].value
			-- 			sliderTime = 100f
			-- 			print "Fotograma 100"			
			-- 			print _listController[_layerIndexes[1]].value
			-- 			sliderTime = 0f
					
				)
			)
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: Boolean | collapseObjectControllers | Colapsa un array de capas en posici�n, rotaci�n o escala de un objeto.
		--@gets: node | obj | El objeto cuyos layers queremos colapsar
		--@gets: name | collapseType | El tipo de transformaci�n (#position,#rotation,#scale,#all)
		--@gets: (opt)array | layersPos | Array donde se guardan las capas de posici�n. Por defecto undefined
		--@gets: (opt)array | layersRot | Array donde se guardan las capas de rotaci�n. Por defecto undefined
		--@gets: (opt)array | layersSca | Array donde se guardan las capas de escaLa. Por defecto undefined
		-----------------------------------------------------------------------------------------------------
		fn collapseObjectControllers obj collapseType layersPos:undefined layersRot:undefined layersSca:undefined =
		(
			--Caso de la posici�n
			if collapseType == #all or collapseType == #position then collapseObjectControllersByTransform obj #position layersArray:layersPos
				
			--Caso de la rotaci�n
			if collapseType == #all or collapseType == #rotation then collapseObjectControllersByTransform obj #rotation layersArray:layersRot
				
			--Caso de la escala
			if collapseType == #all or collapseType == #scale then collapseObjectControllersByTransform obj #scale layersArray:layersSca
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: boolean | isObjectAnimated | Indica si el objeto tiene animaci�n en alguna pista
		--@gets: node | obj | Objeto del que se quiere comprobar si tiene animaci�n.
		--@gets: (opt)node | rootObj | ROOTOBJ es el OBJ inicial antes de empezaar la recursividad. Por defecto undefined 
		--@returns: boolean | anim | True o False, seg�n si el objeto tiene animaci�n o no.
		-----------------------------------------------------------------------------------------------------	
		fn isObjectAnimated obj rootObj:undefined =
		(
			anim = false
			
			if rootObj == undefined then rootObj = obj
			
			if obj.numsubs == 0 and (obj.controller != undefined) and (obj.name != "Link Times") then
			(
				anim = (obj.controller.keys.count > 0)
				
				--si obj es un objeto, no un subanim y tiene point constraint, pude tener una clave de transformacion
				if anim and (isValidNode rootObj) and (rootObj.modifiers.count != 0) \
				and (lb.links.pointConstraint.hasPCAttribute rootObj.modifiers[1]) then
				(
					case (obj as string) of
					(
						"SubAnim:X_Position": anim = false
						"SubAnim:Y_Position": anim = false
						"SubAnim:Z_Position": anim = false
						
						"SubAnim:X_Rotation": anim = false
						"SubAnim:Y_Rotation": anim = false
						"SubAnim:Z_Rotation": anim = false
						
						"SubAnim:X_Scale": anim = false
						"SubAnim:Y_Scale": anim = false
						"SubAnim:Z_Scale": anim = false
						
						"SubAnim:Weight__PC_pointConstraint": anim = false
						"SubAnim:Weight__OC_pointConstraint": anim = false
					)--case
				)--if
			)
			else
			(
				--hay casos en los que podemos tener subanims pero que el padre de ellos sea un controlador animado.
				if(obj.numsubs != 0) and (obj.controller != undefined) and (obj.name != "Link Times") then
				(
					anim = (obj.controller.keys.count > 0)
				)
				
				if not anim then
				(
					i = 1
					while i <= obj.numSubs and not anim do
					(
						anim = isObjectAnimated obj[i] rootObj:rootObj
						i += 1														
					)--while
					
					-- Cuando accedemos al array de custom attributes en seg�n que pistas la propiedad existe pero est� en un estado incorrecto, en el que sus propiedades provocan
					-- excepciones de sistema. Para detectarlos sin usar trys miramos si la propiedad count existe.
					if not anim and (isProperty obj #custAttributes) and (isProperty obj.custAttributes #count) then
					(
						for c in obj.custAttributes where not anim do
							anim = isObjectAnimated c rootObj:rootObj
					)
				)
			)--if else
			
			anim
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: boolean | isLinkConstraintAnimated | indica si el linkConstraint de un objeto tiene mas de una clave, si tiene una sola clave y esta est� en el frame 0 considera que no esta animado
		--@gets: node | obj | Objeto del que se quiere comprobar si tiene LinkConsraints animados.
		--@gets: (opt)boolean | removeKeys | Booleano que indica si se tienen que borrar las llaves de animaci�n en el proceso.
		--@returns: boolean | anim | True o False, seg�n si el linkConstraint del objeto tiene animaci�n o no.
		-----------------------------------------------------------------------------------------------------	
		fn isLinkConstraintAnimated obj removeKeys:false =
		(
			anim = false
			if (obj.numsubs == 0) and (obj.controller != undefined) and (obj.name == "Link Times") then
			(
				numLinkKeys = obj.controller.keys.count
				linkAnimated = (numLinkKeys > 0)
				if linkAnimated then
				(
					if numLinkKeys > 1 then
					(
						if removeKeys then
							for i = numLinkKeys to 2 by -1 do
								obj.parent.deleteTarget i
						else
							anim = true
					)
					else if (numLinkKeys == 1) and ((obj.controller.keys[1].time as integer) != 0) then
						anim = true
				)--if linkAnimated
			)
			else
			(
				i = 1
				while i <= obj.numSubs and not anim do
				(
					anim = isLinkConstraintAnimated obj[i] removeKeys:removeKeys
					i += 1														
				)
			)
			anim
		),
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
			
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrer�as en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librer�a.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librer�as hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecuci�n al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addLibrary this --a�ade la libreria a la principal
		)		
	)--lib_templateLib
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_animation() --crea la libreria
)