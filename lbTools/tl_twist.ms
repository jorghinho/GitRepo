------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Twist.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta Twist.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Twist" width:270 height:120
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 270		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 120		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local _pointControl = #() --contiene los point creados para el efecto de strech.
		local _twistNumber = #()  --contiene el número de twist dado en la pestaña. 
		Local _twistIK = #()	  --contiene las Ik de los twist de la parte de Lower.
		local _LengthTwist = #()  --contiene el tamaño de cada hueso en relación al número de twist.
		local _twistBones = #()	  --contiene los huesos de twist.
		local _exposeHLpLower = #() --contiene el expose de la parte de lower.
		local _exposeHLpUpper = #() --contiene el expose de la parte de upper.
		local _nameTwist = #()	  --contiene las partes del nombre para los twist.
		local _twistBonesExtra = #() --contiene el hueso extra para la parte de upper.
		local _twistBonesExtraEnd = #() --contiene el hueso extraEnd para la parte de upper.
		local _pointLowerExtra = #() --contiene el point de referencia para el strech en lower.
		local _pointUpperExtra = #() --contiene el point de referencia para el strech en upper.
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--@control | controlName | Plantilla de comentario para controles
		groupBox grp1TwistIk "Twist" pos:[8,8] width:255 height:105
		spinner spnNumTwist "Num. Twist  " pos:[70,27] width:60 height:50 range:[1,50,4] type:#integer
		button btnCreateTwistSystem "Create Twist System" pos:[20,53] width:110 height:24
		button btnDeleteTwist "Delete Twist System" pos:[20,82] width:110 height:24
		checkbox ckbAutoStretch "autoStrech" pos:[160,25] width:100 height:15 checked: true
		checkbox ckbUpperTwist "upper Twist" pos:[160,45] width:100 height:15 checked: false
		checkbox ckbLowerTwist "lower Twist" pos:[160,65] width:100 height:15 checked: false
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		--@fn: undefined | createBonTwist | Función para crear los huesos de twist y colocarlos según si es upper o lower, configuración del streching.
		--@gets: node | _boneSelection |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		fn createBonTwist _k =
		(
			_twistNumber = spnNumTwist.value --Obtención del valor puesto en el número de twist.
			
			--Recorremos la selección hecha de huesos para crearle el sistema de twist a cada uno de los huesos.
			_newBone = #()
			_LengthTwist = #()
			_twistBones = #()
			
			_LengthTwist = _k.length/_twistNumber --Obtención del tamaño de cada twist en relación al hueso base y el número de twist.
			_child = _k.children
			
			for _o=1 to (_twistNumber + 1) do -- bucle en el que se crean los huesos de twist, según el número de estos.
			(	
				_newBone = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1] -- creación de 'newBone' en coordenadas absolurtas 0,0,0 en dirección Z positiva y con na longitud igual a 'newLength'.
				
				--Filtramos el nombre y nombramos los huesos creados según la selección hecha.
				_nameTwist = filterstring _k.name "_"
				_newBone.name = _nameTwist[1] + "_" + _nameTwist[2] + "_" + _nameTwist[3] + "_" + _nameTwist[4] + "_" + _nameTwist[5] + "-Twist-bon-0" + (_o as String) + "_" + _nameTwist[6] + "_" + lb.nc.NC_skinFlag
				
				-- Parámetros de los huesos Twist.
				_newBone.length = _LengthTwist
				_newBone.wirecolor = color 255 255 0 -- Yellow
				_newBone.Taper = 0
				_newBone.width =  _k.width * 2
				_newBone.height = _k.height * 2
				_newBone.sidefins = false
				
				if  _k.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
				(
					_newBone.transform = _k.transform
					_newBone.objectOffsetScale = _k.objectOffsetScale -- iguala objectOffsetScale con hueso X
				)
				else
				(
					_newBone.transform = _k.transform --colocamos los huesos en la posicion del hueso seleccionado.
				)
				
				in coordSys Local move _newBone [(_k.objectoffsetscale.x)*(_newBone.length*(_o-1)),0,0] -- mueve el hueso twist al final del hueso twist anterior.
				
				append _twistBones _newBone -- añade los huesos de twist en un array
				
				if _o == (_twistNumber +1) then  --Selección del hueso final para cambiar sus propiedades.
				(
					_newBone.length = _newBone.height
					_newBone.Taper = 90
				)
				
				if _o > 1 then _twistBones[_o].parent = _twistBones[_o-1] -- Emparentado de huesos de twist.
				
				for _o in _twistBones do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
				
				if _o == 1 then
				(
					_twistBones[_o].parent = _k
				)
			)
			
			if ckbAutoStretch.checked == true then  --Si upper Twist esta act. entra en el bucle.
			(
				_pointControl = lb.rig.createStretchBoneChain _twistBones  --creación de los point de streching y su configuración de constraint.
				for _o in _pointControl do _o.size = _k.width * 5	   --Tamaño de los point.
				
				for i=1 to  _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso.
				(
					if i > 1 then
					(			
						lb.controller.setActiveController  _pointControl[i] #all #frozen
						_pointControl[i].parent =  _pointControl[i-1] --Emparentamos las IK entre si.
						lb.controller.setActiveController  _pointControl[i] #all #zero
					)
				)
				for _o in  _pointControl do lb.controller.freezeTransform _o #all  --freezeamos las piezas de Ik.
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | exposeLower | Función para crear el expose y elementos necesarios para su configuración, para los twist Lower
		--@gets: node | bon |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		mapped fn exposeLower bon =
		(
			_childLower = bon.children
			
			_filterPart = filterString bon.name "_"
			
			_pointLower = point()
			_pointLower.cross = false
			_pointLower.box = true
			_pointLower.size =  bon.width * 5
			_pointLower.wirecolor = color 255 255 0 -- Yellow
			_pointLower.transform = _childLower[1].transform
			_pointLower.parent = bon
			_pointLower.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeForearm" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _pointLower #all
			
			_pointLowerExtra = point()
			_pointLowerExtra.cross = false
			_pointLowerExtra.box = true
			_pointLowerExtra.size =  bon.width * 5
			_pointLowerExtra.wirecolor = color 255 255 0 -- Yellow
			_pointLowerExtra.transform = bon.transform
			_pointLowerExtra.parent = bon
			_pointLowerExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeForearmExtra" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _pointLowerExtra #all
			
			_exposeHLpLower = ExposeTm()
			_exposeHLpLower.centermarker = true
			_exposeHLpLower.axistripod = true
			_exposeHLpLower.cross = false
			_exposeHLpLower.size =  bon.width * 5
			_exposeHLpLower.wirecolor = color 255 255 0 -- Yellow
			_exposeHLpLower.transform = _childLower[1].transform
			_exposeHLpLower.parent = _childLower[1]
			_exposeHLpLower.exposeNode = _childLower[1]
			_exposeHLpLower.useParent = false
			_exposeHLpLower.localReferenceNode = _pointLower
			_exposeHLpLower.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-Expose" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _exposeHLpLower #all
		)		
		------------------------------------------------------------------------------
		--@fn: undefined | exposeUpper | Función para crear el expose y los huesos extras para formar la IkLimb en la parte de upper.
		--@gets: node | bon |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		mapped fn exposeUpper bon =
		(
			_filterPart = filterString bon.name "_"
			
			--creación del point auxiliar para el codo y configuración.
			_pointUpperExtra = point()		
			_pointUpperExtra.cross = false
			_pointUpperExtra.box = true
			_pointUpperExtra.size =  bon.width * 6
			_pointUpperExtra.wirecolor = color 255 255 0 -- Yellow
			_pointUpperExtra.transform = bon.transform
			_pointUpperExtra.position = bon.children[1].position
			_pointUpperExtra.parent = bon
			_pointUpperExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeUpperArm" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _pointUpperExtra #all
			
			--creación de los huesos extras para montar la IkLimb en la parte de upper
			_twistBonesExtra = #()
			_newBoneExtra = #()
			_twistBonesExtraEnd = #()
			_newBoneExtra = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1] -- creación de 'newBone' en coordenadas absolurtas 0,0,0 en dirección Z positiva y con na longitud igual a 'newLength'.
						
			--Filtramos el nombre y nombramos los huesos creados según la selección hecha.
			_newBoneExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-bon-Extra" + "_" + _filterPart[6] + "_" +lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag			
			-- Parámetros de los huesos Twist.
			if _twistNumber == 1 then
			(
				_newBoneExtra.length = _LengthTwist/3
			)
			else
			(
				_newBoneExtra.length = _LengthTwist
			)
			_newBoneExtra.wirecolor = color 255 255 0 -- Yellow
			_newBoneExtra.Taper = 90
			_newBoneExtra.width = bon.width * 2
			_newBoneExtra.height = bon.height * 2
			_newBoneExtra.sidefins = true
			_newBoneExtra.sidefinssize = bon.width * 2
			
			if  bon.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
			(
				_newBoneExtra.transform =  bon.transform
				_newBoneExtra.objectOffsetScale =  bon.objectOffsetScale -- iguala objectOffsetScale con hueso X
			)
			else
			(
				_newBoneExtra.transform =  bon.transform --colocamos los huesos en la posicion del hueso seleccionado.
			)
			
			append _twistBonesExtra _newBoneExtra -- añade los huesos de twist en un array
			
			for _o in _twistBonesExtra do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
			
			_twistBonesExtraEnd = #()
			-- creación de hueso End.
			_newBoneExtraEnd = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1]
			_newBoneExtraEnd.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-bon-ExtraEnd" + "_" + _filterPart[6] + "_" +lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag			
			
			-- Parámetros del huesoEnd Twist.
			_newBoneExtraEnd.length = _newBoneExtra.height
			_newBoneExtraEnd.wirecolor = color 255 255 0 -- Yellow
			_newBoneExtraEnd.Taper = 90
			_newBoneExtraEnd.width = bon.width * 2
			_newBoneExtraEnd.height = bon.height * 2
			_newBoneExtraEnd.sidefins = true
			_newBoneExtraEnd.sidefinssize = bon.width * 2
			
			if  bon.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
			(
				_newBoneExtraEnd.transform =  bon.transform
				_newBoneExtraEnd.objectOffsetScale =  bon.objectOffsetScale -- iguala objectOffsetScale con hueso X
			)
			else
			(
				_newBoneExtraEnd.transform =  bon.transform --colocamos los huesos en la posicion del hueso seleccionado.
			)
			
			in coordSys Local move _newBoneExtraEnd [(bon.objectoffsetscale.x)*(_newBoneExtra.length),0,0] -- mueve el hueso twist al final del hueso twist anterior.
			
			append _twistBonesExtraEnd _newBoneExtraEnd -- añade los huesos de twist en un array
			
			_twistBonesExtraEnd[1].parent = _twistBonesExtra[1]
			for _o in _twistBonesExtraEnd do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
			
			--creación del expose para la parte de upper
			_exposeHLpUpper = ExposeTm()
			_exposeHLpUpper.centermarker = true
			_exposeHLpUpper.axistripod = true
			_exposeHLpUpper.cross = false
			_exposeHLpUpper.size = bon.width * 5
			_exposeHLpUpper.wirecolor = color 255 255 0 -- Yellow
			_exposeHLpUpper.transform = bon.transform
			_exposeHLpUpper.parent = _twistBonesExtra[1]
			_exposeHLpUpper.exposeNode = bon
			_exposeHLpUpper.useParent = false
			_exposeHLpUpper.localReferenceNode = _twistBonesExtra[1]
			_exposeHLpUpper.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-expose" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
			lb.controller.freezeTransform _exposeHLpUpper #all
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | rotationTwist | Función para generar la configuración necesaria para la rotacion del twist.
		--@gets: node | bon |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		fn rotationTwist bon =
		(
			_FloatExprTwist = #()
			_FloatExprStrech = #()
			
			_scaleRoot = lb.rig.solutions.getRootNode type:#skin
			
			if ckbLowerTwist.checked == true then  --Si Lower Twist esta act. entra en el bucle.
			(	
				for _k in bon do
				(
					createBonTwist _k
					exposeLower _k --Creación del point y del expose, para las piezas lower.
					
					for i=1 to  _pointControl.count do --Recorre los objetos del array de los huesos de twist.
					(
						if i == 1 then
						(
							lb.controller.setActiveController  _pointControl[i] #all #frozen
							_pointControl[i].parent = _pointLowerExtra
							lb.controller.setActiveController  _pointControl[i] #all #zero
						)
					)
					
					if _k.objectOffsetScale.x == -1 then
					(
						for i=1 to _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
						(
							if i != 1 then
							(
								--Rotación de twist añadimos el float Expresion en la pista rotX y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" _exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/" + ((_twistNumber)as string))
								
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" _k.length
								_FloatExprStrech.AddNode "scale" _scaleRoot
								_FloatExprStrech.AddNode "point01" _exposeHLpLower
								_FloatExprStrech.AddNode "point02" _pointLowerExtra
								_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
							)
							
							if i == _pointControl.count-1 then	--excepción para que el primer hueso rote a la ver que rota la muñeca
							(
								--Rotación de twist añadimos el float Expresion en la pista rotX y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" _exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/1.5")
							)
						)
					)
					else
					(
						for i=1 to _twistBones.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
						(
							if i != 1 then
							(
								--Rotación de twist añadimos el float Expresion en el swivel angle y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" _exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/" + ((_twistNumber)as string))
								
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" _k.length
								_FloatExprStrech.AddNode "scale" _scaleRoot
								_FloatExprStrech.AddNode "point01" _exposeHLpLower
								_FloatExprStrech.AddNode "point02" _pointLowerExtra
								_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
							)
							
							if i == _pointControl.count-1 then	--excepción para que el primer hueso rote a la ver que rota la muñeca
							(
								--Rotación de twist añadimos el float Expresion en la pista rotX y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" _exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/1.5")
							)
						)
					)
				)
			)
			if ckbUpperTwist.checked == true then  --Si upper Twist esta act. entra en el bucle.
			(
				for _k in bon do
				(
					createBonTwist _k
					exposeUpper _k --Creación del point y del expose, para las piezas Upper.
					
					_twistBonesExtra[1].parent = _k.parent  --linka el hueso extra de la Ik al hombro.
					lb.controller.freezeTransform _twistBonesExtra[1] #all
					
					_CreateIkLimb = iksys.ikchain _twistBonesExtra[1] _twistBonesExtraEnd[1] "IKLimb"  --creación de la IkLimb del hueso extra al huesoExtraEnd
					_CreateIkLimb.transform = _k.transform				--coloca la IK Limb en el ultimo hueso de los twist en la zona del codo.
					_CreateIkLimb.position = _k.children[1].position
					_filterPart = filterString _k.name "_"
					_CreateIkLimb.name =  _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-IkLimb-Extra" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
					
					_CreateIkLimb.parent = _pointUpperExtra
					lb.controller.freezeTransform _CreateIkLimb #all
					
					for i=1 to  _pointControl.count do --Recorre los objetos del array de los huesos de twist.
					(
						if i == 1 then
						(
							lb.controller.setActiveController  _pointControl[i] #all #frozen
							_pointControl[i].parent = _exposeHLpUpper
							lb.controller.setActiveController  _pointControl[i] #all #zero
						)
					)
					
					if _k.objectOffsetScale.x == -1 then
					(
						for i=1 to _pointControl.count do --Recorre los point de strech y les mete un float expresion en la rotación eje X, y en posicion eje X.
						(
							for _o in _pointControl do
							(
								--Rotación de twist añadimos el float Expresion en el swivel angle y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "UpperTwist" _exposeHLpUpper.LocalEulerX.controller
								_FloatExprTwist.setExpression ("UpperTwist/" + ((_twistNumber)as string))
							)
							
							if i != 1 then
							(
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" _k.length
								_FloatExprStrech.AddNode "scale" _scaleRoot
								_FloatExprStrech.AddNode "point01" _exposeHLpUpper
								_FloatExprStrech.AddNode "point02" _pointUpperExtra
								_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
							)
						)
					)
					else
					(
						for i=1 to _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
						(
							for _o in _pointControl do
							(
								--Añadimos el float Expresion en el swivel angle y lo configuramos.
								_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "UpperTwist" _exposeHLpUpper.LocalEulerX.controller
								_FloatExprTwist.setExpression ("UpperTwist/" + ((_twistNumber)as string))
							)
							
							if i != 1 then
							(
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" _k.length
								_FloatExprStrech.AddNode "scale" _scaleRoot
								_FloatExprStrech.AddNode "point01" _exposeHLpUpper
								_FloatExprStrech.AddNode "point02" _pointUpperExtra
								_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
							)
						)
					)
					_pointUpperExtra.pos.controller.Available.controller = Position_Constraint ()
					_pointUpperExtra.pos.controller.Position_Constraint.controller.appendTarget _k.children[1] 100
					_pointUpperExtra.pos.controller.Position_Constraint.controller.RELATIVE = on
				)
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | deleteTwistSystem | Función para borrar las soluciones twist.
		--@gets: node | _boneSelection |  pasa la selección de huesos que se han de meter twist.
		------------------------------------------------------------------------------
		fn deleteTwistSystem _boneSelection =
		(
			for _k in _boneSelection do
			(
				_nameTwist = #()
				
				if _k != undefined and isValidNode _k then
				(
					_nameTwist = filterString _k.name "_"
					_filterNameTwist = filterstring _nameTwist[5] "-"
					
					if _filterNameTwist[2] != undefined then
					(
						_filtername = _nameTwist[1] + "_" + _nameTwist[2] + "_" + lb.nc.NC_classSkin + "_" + _nameTwist[4] + "_" + _filterNameTwist[1] + "-" +_filterNameTwist[2] + "-" + "*" + "-" + "*" + "_" + "*" + "_" + "*"
						
						for _o in lb.asset.getSceneAssets() do
						(
							_objetSkin = _o.skinNodesAll
							
							for _m in _objetSkin do
							(
								if matchpattern _m.name pattern:_filtername then
								(
									if classof _m.position.controller[#Zero_Pos_XYZ][#x_Position].controller == float_script then
										delete _m
								)
							)
						)							
						for _o in lb.asset.getSceneAssets() do
						(
							_objetSkin = _o.skinNodesAll
					
							for _m in _objetSkin do
							(
								if matchpattern _m.name pattern:_filtername then
								(
									delete _m
								)
							)
						)
					)
				)
			)
		)
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
		--COMMON
		------------------------------------------------
		
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
		---------------------------------------------------------------------------------------------------------------
		--Evento que verifica si el upper esta activado o no y desactiva el lower.
		---------------------------------------------------------------------------------------------------------------
		on ckbUpperTwist changed UpperRefChkState do
		(
			if ckbUpperTwist.checked == true then
			(
				ckbLowerTwist.enabled = false
				ckbLowerTwist.checked = false
			)
			else
			(
				ckbLowerTwist.enabled = true
			)
		)
		
		---------------------------------------------------------------------------------------------------------------
		--Evento que verifica si el lower esta activado o no y desactiva el upper.
		---------------------------------------------------------------------------------------------------------------
		on ckbLowerTwist changed LowerRefChkState do
		(
			if ckbLowerTwist.checked == true then
			(
				ckbUpperTwist.enabled = false
				ckbUpperTwist.checked = false
			)
			else
			(
				ckbUpperTwist.enabled = true
			)
		)
		
		---------------------------------------------------------------------------------------------------------------
		-- añade los huesos de twist.
		---------------------------------------------------------------------------------------------------------------
		on btnCreateTwistSystem pressed do
		(
			_boneSelection = #()
			_boneSelection = getCurrentSelection()
			
			setCommandPanelTaskMode #create		--activa la parte del command panel create.
			-- si no hay huesos seleccionados salta un mensaje
			if _boneSelection.count == 0 then
			(
				MessageBox "You must have some bones selected"
			)
			else
			(
				_pointControl = #()
					
-- 				createBonTwist _boneSelection		--creacion de los huesos de twist.
				rotationTwist _boneSelection		--configuración de twist.
			)
		)
		
		---------------------------------------------------------------------------------------------------------------
		--Elimina los twist creados y sus objetos auxiliares.
		---------------------------------------------------------------------------------------------------------------
		on btnDeleteTwist pressed do
		(
			_boneSelection = #()
			_boneSelection = getCurrentSelection()
			
			setCommandPanelTaskMode #create		--activa la parte del command panel create.	
			-- si no hay huesos seleccionados salta un mensaje
			if _boneSelection.count == 0 then
			(
				MessageBox "You must have some bonesTwist selected"
			)
			else
			(
				deleteTwistSystem _boneSelection
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
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
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
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_Twist
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Twist Ik",		--@var: description | Descripcion de la tool.
		
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
		------------------------------------------------------------------------------
		--@fn: undefined | deleteTwistSystem | Función para crear la solución twist.
		--@gets: node | bon | pasarle el hueso al que se quiere hacer el twist.
		--@gets: name | type | tipo de configuración que se quiere #upper o #lower.
		--@gets: integer | twistNumber |  pasar el número de huesos de twist necesarios.
		------------------------------------------------------------------------------
		fn createTwist bon type twistNumber =
		(
			--Recorremos la selección hecha de huesos para crearle el sistema de twist a cada uno de los huesos.
			_newBone = #()
			_LengthTwist = #()
			_twistBones = #()
			
			_LengthTwist = bon.length/twistNumber --Obtención del tamaño de cada twist en relación al hueso base y el número de twist.
			_child = bon.children
			
			for _o=1 to (twistNumber + 1) do -- bucle en el que se crean los huesos de twist, según el número de estos.
			(	
				_newBone = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1] -- creación de 'newBone' en coordenadas absolurtas 0,0,0 en dirección Z positiva y con na longitud igual a 'newLength'.
				
				--Filtramos el nombre y nombramos los huesos creados según la selección hecha.
				_nameTwist = filterstring bon.name "_"
				_newBone.name = _nameTwist[1] + "_" + _nameTwist[2] + "_" + _nameTwist[3] + "_" + _nameTwist[4] + "_" + _nameTwist[5] + "-Twist-bon-0" + (_o as String) + "_" + _nameTwist[6] + "_" + lb.nc.NC_skinFlag
				
				-- Parámetros de los huesos Twist.
				_newBone.length = _LengthTwist
				_newBone.wirecolor = color 255 255 0 -- Yellow
				_newBone.Taper = 0
				_newBone.width =  bon.width * 2
				_newBone.height = bon.height * 2
				_newBone.sidefins = false
				
				if  bon.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
				(
					_newBone.transform = bon.transform
					_newBone.objectOffsetScale = bon.objectOffsetScale -- iguala objectOffsetScale con hueso X
				)
				else
				(
					_newBone.transform = bon.transform --colocamos los huesos en la posicion del hueso seleccionado.
				)
				
				in coordSys Local move _newBone [(bon.objectoffsetscale.x)*(_newBone.length*(_o-1)),0,0] -- mueve el hueso twist al final del hueso twist anterior.
				
				append _twistBones _newBone -- añade los huesos de twist en un array
				
				if _o == (twistNumber +1) then  --Selección del hueso final para cambiar sus propiedades.
				(
					_newBone.length = _newBone.height
					_newBone.Taper = 90
				)
				
				if _o > 1 then _twistBones[_o].parent = _twistBones[_o-1] -- Emparentado de huesos de twist.
				
				for _o in _twistBones do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
				
				if _o == 1 then
				(
					_twistBones[_o].parent = bon
				)
			)
			
			_pointControl = lb.rig.createStretchBoneChain _twistBones  --creación de los point de streching y su configuración de constraint.
			for _o in _pointControl do _o.size = bon.width * 5	   --Tamaño de los point.
			
			for i=1 to  _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso.
			(
				if i > 1 then
				(			
					lb.controller.setActiveController  _pointControl[i] #all #frozen
					_pointControl[i].parent =  _pointControl[i-1] --Emparentamos las IK entre si.
					lb.controller.setActiveController  _pointControl[i] #all #zero
				)
			)
			for _o in  _pointControl do lb.controller.freezeTransform _o #all  --freezeamos las piezas de Ik.
			
			-------------------------------------------------------------------------------------------------------------------------------			
			--LOWER  --Creación de los point  y expose necesarios para una configuración tipo lower.
			-------------------------------------------------------------------------------------------------------------------------------	
			if type == #lower then
			(
				_childLower = bon.children
				
				_filterPart = filterString bon.name "_"
				
				_pointLower = point()
				_pointLower.cross = false
				_pointLower.box = true
				_pointLower.size =  bon.width * 5
				_pointLower.wirecolor = color 255 255 0 -- Yellow
				_pointLower.transform = _childLower[1].transform
				_pointLower.parent = bon
				_pointLower.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeForearm" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
				lb.controller.freezeTransform _pointLower #all
				
				_pointLowerExtra = point()
				_pointLowerExtra.cross = false
				_pointLowerExtra.box = true
				_pointLowerExtra.size =  bon.width * 5
				_pointLowerExtra.wirecolor = color 255 255 0 -- Yellow
				_pointLowerExtra.transform = bon.transform
				_pointLowerExtra.parent = bon
				_pointLowerExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeForearmExtra" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
				lb.controller.freezeTransform _pointLowerExtra #all
				
				_exposeHLpLower = ExposeTm()
				_exposeHLpLower.centermarker = true
				_exposeHLpLower.axistripod = true
				_exposeHLpLower.cross = false
				_exposeHLpLower.size =  bon.width * 5
				_exposeHLpLower.wirecolor = color 255 255 0 -- Yellow
				_exposeHLpLower.transform = _childLower[1].transform
				_exposeHLpLower.parent = _childLower[1]
				_exposeHLpLower.exposeNode = _childLower[1]
				_exposeHLpLower.useParent = false
				_exposeHLpLower.localReferenceNode = _pointLower
				_exposeHLpLower.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-Expose" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
				lb.controller.freezeTransform _exposeHLpLower #all
			)
			
			-------------------------------------------------------------------------------------------------------------------------------			
			--UPPER  --Creación de los point  y expose necesarios para una configuración tipo upper.
			-------------------------------------------------------------------------------------------------------------------------------	
			if type == #upper then
			(	
				_filterPart = filterString bon.name "_"
				
				--creación del point auxiliar para el codo y configuración.
				_pointUpperExtra = point()		
				_pointUpperExtra.cross = false
				_pointUpperExtra.box = true
				_pointUpperExtra.size =  bon.width * 6
				_pointUpperExtra.wirecolor = color 255 255 0 -- Yellow
				_pointUpperExtra.transform = bon.transform
				_pointUpperExtra.position = bon.children[1].position
				_pointUpperExtra.parent = bon
				_pointUpperExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeUpperArm" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
				lb.controller.freezeTransform _pointUpperExtra #all
				
				--creación de los huesos extras para montar la IkLimb en la parte de upper
				_twistBonesExtra = #()
				_newBoneExtra = #()
				_twistBonesExtraEnd = #()
				_newBoneExtra = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1] -- creación de 'newBone' en coordenadas absolurtas 0,0,0 en dirección Z positiva y con na longitud igual a 'newLength'.
							
				--Filtramos el nombre y nombramos los huesos creados según la selección hecha.
				_newBoneExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-bon-Extra" + "_" + _filterPart[6] + "_" +lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag			
				-- Parámetros de los huesos Twist.
				if _twistNumber == 1 then
				(
					_newBoneExtra.length = _LengthTwist/3
				)
				else
				(
					_newBoneExtra.length = _LengthTwist
				)
				_newBoneExtra.wirecolor = color 255 255 0 -- Yellow
				_newBoneExtra.Taper = 90
				_newBoneExtra.width = bon.width * 2
				_newBoneExtra.height = bon.height * 2
				_newBoneExtra.sidefins = true
				_newBoneExtra.sidefinssize = bon.width * 2
				
				if  bon.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
				(
					_newBoneExtra.transform =  bon.transform
					_newBoneExtra.objectOffsetScale =  bon.objectOffsetScale -- iguala objectOffsetScale con hueso X
				)
				else
				(
					_newBoneExtra.transform =  bon.transform --colocamos los huesos en la posicion del hueso seleccionado.
				)
				
				append _twistBonesExtra _newBoneExtra -- añade los huesos de twist en un array
				
				for _o in _twistBonesExtra do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
				
				_twistBonesExtraEnd = #()
				-- creación de hueso End.
				_newBoneExtraEnd = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1]
				_newBoneExtraEnd.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-bon-ExtraEnd" + "_" + _filterPart[6] + "_" +lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag			
				
				-- Parámetros del huesoEnd Twist.
				_newBoneExtraEnd.length = _newBoneExtra.height
				_newBoneExtraEnd.wirecolor = color 255 255 0 -- Yellow
				_newBoneExtraEnd.Taper = 90
				_newBoneExtraEnd.width = bon.width * 2
				_newBoneExtraEnd.height = bon.height * 2
				_newBoneExtraEnd.sidefins = true
				_newBoneExtraEnd.sidefinssize = bon.width * 2
				
				if  bon.objectOffsetScale.x == -1 then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
				(
					_newBoneExtraEnd.transform =  bon.transform
					_newBoneExtraEnd.objectOffsetScale =  bon.objectOffsetScale -- iguala objectOffsetScale con hueso X
				)
				else
				(
					_newBoneExtraEnd.transform =  bon.transform --colocamos los huesos en la posicion del hueso seleccionado.
				)
				
				in coordSys Local move _newBoneExtraEnd [(bon.objectoffsetscale.x)*(_newBoneExtra.length),0,0] -- mueve el hueso twist al final del hueso twist anterior.
				
				append _twistBonesExtraEnd _newBoneExtraEnd -- añade los huesos de twist en un array
				
				_twistBonesExtraEnd[1].parent = _twistBonesExtra[1]
				for _o in _twistBonesExtraEnd do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
				
				--creación del expose para la parte de upper
				_exposeHLpUpper = ExposeTm()
				_exposeHLpUpper.centermarker = true
				_exposeHLpUpper.axistripod = true
				_exposeHLpUpper.cross = false
				_exposeHLpUpper.size = bon.width * 5
				_exposeHLpUpper.wirecolor = color 255 255 0 -- Yellow
				_exposeHLpUpper.transform = bon.transform
				_exposeHLpUpper.parent = _twistBonesExtra[1]
				_exposeHLpUpper.exposeNode = bon
				_exposeHLpUpper.useParent = false
				_exposeHLpUpper.localReferenceNode = _twistBonesExtra[1]
				_exposeHLpUpper.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeUpper" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
				lb.controller.freezeTransform _exposeHLpUpper #all
			)
			
			-------------------------------------------------------------------------------------------------------------------------------			
			--Creación de floats y demás.
			-------------------------------------------------------------------------------------------------------------------------------	
			_FloatExprTwist = #()
			_FloatExprStrech = #()
			
			_scaleRoot = lb.rig.solutions.getRootNode type:#skin
			
			if type == #lower then  --Si Lower Twist esta act. entra en el bucle.
			(	
				for i=1 to  _pointControl.count do --Recorre los objetos del array de los huesos de twist.
				(
					if i == 1 then
					(
						lb.controller.setActiveController  _pointControl[i] #all #frozen
						_pointControl[i].parent = _pointLowerExtra
						lb.controller.setActiveController  _pointControl[i] #all #zero
					)
				)
				
				if bon.objectOffsetScale.x == -1 then
				(
					for i=1 to _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
					(
						if i != 1 then
						(
							--Rotación de twist añadimos el float Expresion en la pista X Rot y lo configuramos.
							_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
							_FloatExprTwist.AddScalarTarget "LowerTwist" _exposeHLpLower.LocalEulerX.controller
							_FloatExprTwist.setExpression ("LowerTwist/" + ((twistNumber)as string))
							
							--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
							_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
							_FloatExprStrech.AddConstant "cons" bon.length
							_FloatExprStrech.AddNode "scale" _scaleRoot
							_FloatExprStrech.AddNode "point01" _exposeHLpLower
							_FloatExprStrech.AddNode "point02" _pointLowerExtra
							_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
						)
					)
				)
				else
				(
					for i=1 to _twistBones.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
					(
						if i != 1 then
						(
							--Rotación de twist añadimos el float Expresion en el swivel angle y lo configuramos.
							_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
							_FloatExprTwist.AddScalarTarget "LowerTwist" _exposeHLpLower.LocalEulerX.controller
							_FloatExprTwist.setExpression ("LowerTwist/" + ((twistNumber)as string))
							
							--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
							_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
							_FloatExprStrech.AddConstant "cons" bon.length
							_FloatExprStrech.AddNode "scale" _scaleRoot
							_FloatExprStrech.AddNode "point01" _exposeHLpUpper
							_FloatExprStrech.AddNode "point02" _pointUpperExtra
							_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
						)
					)
				)
			)
			
			if type == #upper then  --Si upper Twist esta act. entra en el bucle.
			(
				_twistBonesExtra[1].parent = bon.parent  --linka el hueso extra de la Ik al hombro.
				lb.controller.freezeTransform _twistBonesExtra[1] #all
				
				_CreateIkLimb = iksys.ikchain _twistBonesExtra[1] _twistBonesExtraEnd[1] "IKLimb"  --creación de la IkLimb del hueso extra al huesoExtraEnd
				_CreateIkLimb.transform = bon.transform				--coloca la IK Limb en el ultimo hueso de los twist en la zona del codo.
				_CreateIkLimb.position = bon.children[1].position
				_filterPart = filterString bon.name "_"
				_CreateIkLimb.name =  _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-IkLimb-Extra" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
				
				_CreateIkLimb.parent = _pointUpperExtra
				lb.controller.freezeTransform _CreateIkLimb #all
				
				for i=1 to  _pointControl.count do --Recorre los objetos del array de los huesos de twist.
				(
					if i == 1 then
					(
						lb.controller.setActiveController  _pointControl[i] #all #frozen
						_pointControl[i].parent = _exposeHLpUpper
						lb.controller.setActiveController  _pointControl[i] #all #zero
					)
				)
				
				if bon.objectOffsetScale.x == -1 then
				(
					for i=1 to _pointControl.count do --Recorre los point de strech y les mete un float expresion en la rotación eje X, y en posicion eje X.
					(
						for _o in _pointControl do
						(
							--Rotación de twist añadimos el float Expresion en el swivel angle y lo configuramos.
							_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
							_FloatExprTwist.AddScalarTarget "UpperTwist" _exposeHLpUpper.LocalEulerX.controller
							_FloatExprTwist.setExpression ("UpperTwist/" + ((twistNumber)as string))
						)
						
						if i != 1 then
						(
							--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
							_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
							_FloatExprStrech.AddConstant "cons" bon.length
							_FloatExprStrech.AddNode "scale" _scaleRoot
							_FloatExprStrech.AddNode "point01" _exposeHLpUpper
							_FloatExprStrech.AddNode "point02" _pointUpperExtra
							_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
						)
					)
				)
				else
				(
					for i=1 to _pointControl.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
					(
						for _o in _pointControl do
						(
							--Añadimos el float Expresion en el swivel angle y lo configuramos.
							_FloatExprTwist = _pointControl[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
							_FloatExprTwist.AddScalarTarget "UpperTwist" _exposeHLpUpper.LocalEulerX.controller
							_FloatExprTwist.setExpression ("UpperTwist/" + ((twistNumber)as string))
						)
						
						if i != 1 then
						(
							--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
							_FloatExprStrech = _pointControl[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
							_FloatExprStrech.AddConstant "cons" bon.length
							_FloatExprStrech.AddNode "scale" _scaleRoot
							_FloatExprStrech.AddNode "point01" _exposeHLpUpper
							_FloatExprStrech.AddNode "point02" _pointUpperExtra
							_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)/scale.scale.z))/" + ((_twistNumber)as string))
						)
					)
				)
				_pointUpperExtra.pos.controller.Available.controller = Position_Constraint ()
				_pointUpperExtra.pos.controller.Position_Constraint.controller.appendTarget bon.children[1] 100
				_pointUpperExtra.pos.controller.Position_Constraint.controller.RELATIVE = on
			)
		),
		
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
			createDialog this.rollMain lockwidth:false lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_templateTool
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_Twist() --crea la herramienta
)