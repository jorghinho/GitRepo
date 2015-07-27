------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de twist
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strSkinNodes | Contiene las piezas de twist de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strSkinNodes
	(
		twistSolutionHLP				= undefined,	--  Nodo de rig padre de la solución.
		strechHlps						= #(),		--contiene los point creados para el efecto de strech.
		exposeHLpLower					= undefined, 	-- Nodo expsoe
		bonChild						= undefined		-- Nodo hijo del objeto.	
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: template | Contiene la solución de twist.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rss_twist
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #twist,					--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #skin,				--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #editRig
		conectionId = #anthropomorphic,				--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,								--@var: index | Indice para ordenar
		
		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de Twists",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		solutionParameters = lb.rig.solutions.params, 			--@var | self | Almacena el ca especifico de la solución.
		
		skinNodes 						= strSkinNodes(),		--@var: skinNodes | Nodos de la cadena de hueso de rig.
		side							= lb.nc.NC_locationLeft,
		
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
				
		------------------------------------------------
		--COMMON
		------------------------------------------------
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | bon | pasarle el hueso en el que se quieren los twist.
		--@gets: node | side | pasarle el lado correspondiente "lb.nc.NC_locationLeft" o "lb.nc.NC_locationRight".
		--@gets: node | location | pasarle si es "#upper" o "#lower".
		------------------------------------------------
		fn createConnections bon side location numTwist = 
		(
			------------------------------------------------------------------------------------------------------------------------------------
			--POINT SOLUTION creamos un point que contiene toda la información de la solución.
			------------------------------------------------------------------------------------------------------------------------------------
			(
				_baseAnimEdit = lb.rig.solutions.getBaseNode type:#AnimEdit	--obtenemos la base.
				
				this.skinNodes.twistSolutionHLP = lb.rig.createPointFromObj bon --se crea el point.
				
				-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
				_filterName = filterString this.skinNodes.twistSolutionHLP.name "_"
				_filterPart = filterString _filterName[5] "#"
				this.skinNodes.twistSolutionHLP.name = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] + "_" + _filterName[4] + "_" + _filterPart[1] +"Twist-solution-root" + "_" + _filterName[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
				this.skinNodes.twistSolutionHLP.size = 12 * _baseAnimEdit.scale[1]
				this.skinNodes.twistSolutionHLP.cross = false
				this.skinNodes.twistSolutionHLP.wirecolor = red
				
				lb.controller.freezeTransform this.skinNodes.twistSolutionHLP #all
				
				if location == #upper then
				(
					this.skinNodes.twistSolutionHLP.parent = bon.parent
				)
				else
				(
					this.skinNodes.twistSolutionHLP.parent = bon
				)
			)
			
			----------------------------------------------------
			--CREACIÓN DE HUESOS AUXILIARES
			----------------------------------------------------
			(
				this.side = side -- Le pasamos el lado del brazo para crear la solución necesaria.
				
				_newBone = #()		--variable temporal con los huesos que se van creando.
				_LengthTwist = #()	--tamaño del twist.
				_twistBones = #()	--variable contenedora con todos los huesos creados de twist.
				
				_LengthTwist = bon.length/numTwist --Obtención del tamaño de cada twist en relación al hueso base y el número de twist.
				
				--Recorremos la selección hecha de huesos para crearle el sistema de twist a cada uno de los huesos.
				for _o=1 to (numTwist + 1) do -- bucle en el que se crean los huesos de twist, según el número de estos (número de twists + 1).
				(	
					_newBone = BoneSys.createBone [0,0,0] [_LengthTwist,0,0] [0,0,1] -- creación de 'newBone' en coordenadas absolurtas 0,0,0 en dirección Z positiva y con na longitud igual a 'newLength'.
					
					--Filtramos el nombre y nombramos los huesos creados según la selección hecha.
					_nameTwist = filterstring bon.name "_"
					_newBone.name = _nameTwist[1] + "_" + _nameTwist[2] + "_" + _nameTwist[3] + "_" + _nameTwist[4] + "_" + _nameTwist[5] + "-Twist-bon-0" + (_o as String) + "_" + _nameTwist[6] + "_" + lb.nc.NC_skinFlag

					if _o == (numTwist + 1) then
						_newBone.name = _nameTwist[1] + "_" + _nameTwist[2] + "_" + _nameTwist[3] + "_" + _nameTwist[4] + "_" + _nameTwist[5] + "-Twist-bon-0" + (_o as String) + "_" + _nameTwist[6] + "_" + (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					
					-- Parámetros de los huesos Twist.
					_newBone.length = _LengthTwist
					_newBone.wirecolor = color 255 255 0 -- Yellow
					_newBone.Taper = 0
					_newBone.width =  bon.width * 2
					_newBone.height = bon.height * 2
					_newBone.sidefins = false
					_newBone.frontfin = false
					_newBone.backfin = false
					_newBone.transform = bon.transform
					
					if side == lb.nc.NC_locationRight then --Si el objeto es simetrico cambia el offset de la escala para que los huesos se construyan bien.
						_newBone.objectOffsetScale = bon.objectOffsetScale -- iguala objectOffsetScale con hueso X.
					
					in coordSys Local move _newBone [(bon.objectOffSetScale.x)*(_newBone.length*(_o-1)),0,0] -- mueve el hueso twist al final del hueso twist anterior.
					
					append _twistBones _newBone -- añade los huesos de twist en un array.
					
					if _o == (numTwist + 1) then  --Selección del hueso final para cambiar sus propiedades (número de twists + 1) el +1 es el hueso final.
					(
						_newBone.length = _newBone.height
						_newBone.Taper = 90
					)
					
					if _o > 1 then _twistBones[_o].parent = _twistBones[_o-1] -- Emparentado de huesos de twist.
					
					for _o in _twistBones do lb.controller.freezeTransform _o #all --Freezear los huesos de twist.
					
					if _o == 1 then
						_twistBones[_o].parent = this.skinNodes.twistSolutionHLP
				)
				
				this.skinNodes.strechHlps = lb.rig.createStretchBoneChain _twistBones  --creación de los point de streching y su configuración de constraint.
				for _o in this.skinNodes.strechHlps do 
				(
					_o.size = bon.width * 5	   --Tamaño de los point.
					_filterName = filterString _o.name "_"
					_filterPart = filterString _filterName[5] "-"
					_filterPoint = filterString _filterPart[4] "Point"
					_o.name = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] + "_" + _filterName[4] + "_" +_filterPart[1] + "-" + _filterPart[2] + "-" + "hlp" + "-" + _filterPoint[1] + "_" + _filterName[6] + "_" +  _filterName[7]

				)
				
				for i=1 to this.skinNodes.strechHlps.count do --Recorre los objetos del array que son los point de cada hueso.
				(
					if i > 1 then
					(			
						lb.controller.setActiveController  this.skinNodes.strechHlps[i] #all #frozen
						this.skinNodes.strechHlps[i].parent =  this.skinNodes.strechHlps[i-1] --Emparentamos los point entre si.
						lb.controller.setActiveController  this.skinNodes.strechHlps[i] #all #zero
					)
				)
				for _o in  this.skinNodes.strechHlps do lb.controller.freezeTransform _o #all  --freezeamos las piezas de point.
			)
			
			----------------------------------------------------
			--CONFIGURACIÓN DE LOS TWIST.
			----------------------------------------------------
			(
				_FloatExprTwist = #()
				_FloatExprStrech = #()
				
				_scaleRoot = lb.rig.solutions.getRootNode type:#skin
				
				if location == #lower then  --Si Lower Twist esta act. entra en el bucle.
				(	
					(	--creacion de helpers para lower (point, expose).
						this.skinNodes.bonChild = bon.children[1]
						
						_filterPart = filterString bon.name "_"
						
						_pointLower = point()
						_pointLower.cross = false
						_pointLower.box = true
						_pointLower.size =  bon.width * 5
						_pointLower.wirecolor = color 255 255 0 -- Yellow
						_pointLower.transform = this.skinNodes.bonChild.transform
						_pointLower.parent = this.skinNodes.twistSolutionHLP
						_pointLower.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeForearm" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
						lb.controller.freezeTransform _pointLower #all
						
						_pointLowerExtra = point()
						_pointLowerExtra.cross = false
						_pointLowerExtra.box = true
						_pointLowerExtra.size =  bon.width * 5
						_pointLowerExtra.wirecolor = color 255 255 0 -- Yellow
						_pointLowerExtra.transform = bon.transform
						_pointLowerExtra.parent = this.skinNodes.twistSolutionHLP
						_pointLowerExtra.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-exposeForearmExtra" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
						lb.controller.freezeTransform _pointLowerExtra #all
						
						this.skinNodes.exposeHLpLower = ExposeTm()
						
						this.skinNodes.exposeHLpLower.centermarker = true
						this.skinNodes.exposeHLpLower.axistripod = true
						this.skinNodes.exposeHLpLower.cross = false
						this.skinNodes.exposeHLpLower.size =  bon.width * 5
						this.skinNodes.exposeHLpLower.wirecolor = color 255 255 0 -- Yellow
						this.skinNodes.exposeHLpLower.transform = this.skinNodes.bonChild.transform
						this.skinNodes.exposeHLpLower.parent = this.skinNodes.twistSolutionHLP
						this.skinNodes.exposeHLpLower.exposeNode = this.skinNodes.bonChild
						this.skinNodes.exposeHLpLower.useParent = false
						this.skinNodes.exposeHLpLower.localReferenceNode = _pointLower
						this.skinNodes.exposeHLpLower.name = _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-twist-hlp-Expose" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
						lb.controller.freezeTransform this.skinNodes.exposeHLpLower #all
						
					)
					
					for i=1 to  this.skinNodes.strechHlps.count do --Recorre los objetos del array de los huesos de twist.
					(
						if i == 1 then
						(
							lb.controller.setActiveController  this.skinNodes.strechHlps[i] #all #frozen
							this.skinNodes.strechHlps[i].parent = _pointLowerExtra
							lb.controller.setActiveController  this.skinNodes.strechHlps[i] #all #zero
						)
					)
					
					if side == lb.nc.NC_locationRight then
					(
						for i=1 to this.skinNodes.strechHlps.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
						(
							if i != 1 then
							(
								--Rotación de twist añadimos el float Expresion en la pista rotX y lo configuramos.
								_FloatExprTwist = this.skinNodes.strechHlps[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" this.skinNodes.exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/" + ((numTwist)as string))
								
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = this.skinNodes.strechHlps[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" bon.length
								
								if _scaleRoot != undefined then 
									_FloatExprStrech.AddNode "root" _scaleRoot
									
								_FloatExprStrech.AddNode "point01" this.skinNodes.exposeHLpLower
								_FloatExprStrech.AddNode "point02" _pointLowerExtra
								if _scaleRoot != undefined then 
									_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)/root.scale.z))/" + ((numTwist)as string))
								else
									_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)))/" + ((numTwist)as string))
							)
							
							if i == this.skinNodes.strechHlps.count-1 then	--excepción para que el primer hueso rote a la ver que rota la muñeca
							(
								--Rotación de twist añadimos el float Expresion en la pista rotX y lo configuramos.
								_FloatExprTwist = this.skinNodes.strechHlps[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" this.skinNodes.exposeHLpLower.LocalEulerX.controller
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
								_FloatExprTwist = this.skinNodes.strechHlps[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" this.skinNodes.exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/" + ((numTwist)as string))
								
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = this.skinNodes.strechHlps[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" bon.length
								
								if _scaleRoot != undefined then _FloatExprStrech.AddNode "root" _scaleRoot
									
								_FloatExprStrech.AddNode "point01" this.skinNodes.exposeHLpLower
								_FloatExprStrech.AddNode "point02" _pointLowerExtra
								
								if _scaleRoot != undefined then
									_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)/root.scale.z))/" + ((numTwist)as string))
								else
									_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)))/" + ((numTwist)as string))
							)
							
							if i == this.skinNodes.strechHlps.count-1 then	--excepción para que el primer hueso rote a la ver que rota la muñeca
							(
								--Rotación de twist añadimos el float Expresion en la pista rotX y lo configuramos.
								_FloatExprTwist = this.skinNodes.strechHlps[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "LowerTwist" this.skinNodes.exposeHLpLower.LocalEulerX.controller
								_FloatExprTwist.setExpression ("LowerTwist/1.5")
							)
						)
					)
				)
				
				if location == #upper then  --Si upper Twist esta act. entra en el bucle.
				(
					(	--creación de helpers para upper (point, expose).
						_filterPart = filterString bon.name "_"
						
						--creación del point auxiliar para el codo y configuración.
						_pointUpperExtra = point()		
						_pointUpperExtra.cross = false
						_pointUpperExtra.box = true
						_pointUpperExtra.size =  bon.width * 6
						_pointUpperExtra.wirecolor = color 255 255 0 -- Yellow
						_pointUpperExtra.transform = bon.transform
						_pointUpperExtra.position = bon.children[1].position
						_pointUpperExtra.parent = this.skinNodes.twistSolutionHLP
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
							_newBoneExtra.length = _LengthTwist/numTwist
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
						_newBoneExtra.transform =  bon.transform   --colocamos los huesos en la posicion del hueso seleccionado.
						
						if side == lb.nc.NC_locationRight then --Si el objeto es del lado derecho cambia el offset de la escala para que los huesos se construyan bien.
							_newBoneExtra.objectOffsetScale = bon.objectOffsetScale -- iguala objectOffsetScale con hueso X.
						
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
						_newBoneExtraEnd.transform =  bon.transform  --colocamos los huesos en la posicion del hueso seleccionado.
						
						if side == lb.nc.NC_locationRight then --Si el objeto es del lado derecho cambia el offset de la escala para que los huesos se construyan bien.
							_newBoneExtraEnd.objectOffsetScale = bon.objectOffsetScale -- iguala objectOffsetScale con hueso X.
						
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
					
					_twistBonesExtra[1].parent = this.skinNodes.twistSolutionHLP  --linka el hueso extra de la Ik al hombro.
					lb.controller.freezeTransform _twistBonesExtra[1] #all
					
					_CreateIkLimb = iksys.ikchain _twistBonesExtra[1] _twistBonesExtraEnd[1] "IKLimb"  --creación de la IkLimb del hueso extra al huesoExtraEnd
					_CreateIkLimb.transform = bon.transform				--coloca la IK Limb en el ultimo hueso de los twist en la zona del codo.
					_CreateIkLimb.position = bon.children[1].position
					---_filterPart = filterString bon.name "_"
					_CreateIkLimb.name =  _filterPart[1] + "_" + _filterPart[2] + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "-Twist-IkLimb-Extra" + "_" + _filterPart[6] + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag
					
					_CreateIkLimb.parent = _pointUpperExtra
					lb.controller.freezeTransform _CreateIkLimb #all
					
					for i=1 to this.skinNodes.strechHlps.count do --Recorre los objetos del array de los huesos de twist.
					(
						if i == 1 then
						(
							lb.controller.setActiveController  this.skinNodes.strechHlps[i] #all #frozen
							this.skinNodes.strechHlps[i].parent = _exposeHLpUpper
							lb.controller.setActiveController  this.skinNodes.strechHlps[i] #all #zero
						)
					)
					
					if side == lb.nc.NC_locationRight then
					(
						for i=1 to this.skinNodes.strechHlps.count do --Recorre los point de strech y les mete un float expresion en la rotación eje X, y en posicion eje X.
						(
							for _o in this.skinNodes.strechHlps do
							(
								--Rotación de twist añadimos el float Expresion en el swivel angle y lo configuramos.
								_FloatExprTwist = this.skinNodes.strechHlps[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "UpperTwist" _exposeHLpUpper.LocalEulerX.controller
								_FloatExprTwist.setExpression ("UpperTwist/" + ((numTwist)as string))
							)
							
							if i != 1 then
							(
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = this.skinNodes.strechHlps[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" bon.length
								
								if _scaleRoot != undefined then _FloatExprStrech.AddNode "root" _scaleRoot
									
								_FloatExprStrech.AddNode "point01" _exposeHLpUpper
								_FloatExprStrech.AddNode "point02" _pointUpperExtra
								
								if _scaleRoot != undefined then
									_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)/root.scale.z))/" + ((numTwist)as string))
								else
									_FloatExprStrech.setExpression ("(cons - (length(point02.transform.pos - point01.transform.pos)))/" + ((numTwist)as string))
							)
						)
					)
					else
					(
						for i=1 to this.skinNodes.strechHlps.count do --Recorre los objetos del array que son las IK de cada hueso para añadirle los float.
						(
							for _o in this.skinNodes.strechHlps do
							(
								--Añadimos el float Expresion en el swivel angle y lo configuramos.
								_FloatExprTwist = this.skinNodes.strechHlps[i].rotation.controller[#Zero_Euler_XYZ][#X_rotation].controller = Float_Expression() --Añadimos el Float Expression.
								_FloatExprTwist.AddScalarTarget "UpperTwist" _exposeHLpUpper.LocalEulerX.controller
								_FloatExprTwist.setExpression ("UpperTwist/" + ((numTwist)as string))
							)
							
							if i != 1 then
							(
								--Para sacar el Strech añadimos el float Expresion en la pista  posX  de los huesos de twist y lo configuramos.
								_FloatExprStrech = this.skinNodes.strechHlps[i].position.controller[#Zero_Pos_XYZ][#X_Position].controller = Float_script()  --Añadimos el Float Expression.
								_FloatExprStrech.AddConstant "cons" bon.length
								
								if _scaleRoot != undefined then _FloatExprStrech.AddNode "root" _scaleRoot
									
								_FloatExprStrech.AddNode "point01" _exposeHLpUpper
								_FloatExprStrech.AddNode "point02" _pointUpperExtra
								
								if _scaleRoot != undefined then
									_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)/root.scale.z))/" + ((numTwist)as string))
								else
									_FloatExprStrech.setExpression ("-(cons - (length(point02.transform.pos - point01.transform.pos)))/" + ((numTwist)as string))
							)
						)
					)
					
					-- Añadimos constraint de posición.
					lb.rig.addConstraint _pointUpperExtra #Pos bon.children[1] "PC_Forearm" keepInitOffset: true
				)
			)
			
			-- Array para almacenar los nodos creados.
			_chrNodes = (lb.rig.getAllChildren this.skinNodes.twistSolutionHLP) + this.skinNodes.twistSolutionHLP 
			
			(	
				(
					if (LayerManager.getLayer 1) == undefined then _chrLayer = lb.layer.newAssetLayer "chrName" else _chrLayer = (LayerManager.getLayer 1)
					
					lb.layer.activeLayer _chrLayer
					
					-- Renombramos los objetos a la capa chrName y los añadimos.
					for o in _chrNodes do 
					(
						o.name = lb.nc.replaceNamePart o.name 2 "chrName"
						_chrLayer.addNode o
					)
				)
			)
		),
		
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | bon | pasarle el hueso en el que se quieren los twist.
		--@gets: node | side | pasarle el lado correspondiente "lb.nc.NC_locationLeft" o "lb.nc.NC_locationRight".
		--@gets: node | location | pasarle si es "#upper" o "#lower".
		--@gets: node | numTwist | pasarle el número de twist que se quiere.
		------------------------------------------------
		fn create bon side:lb.nc.NC_locationLeft location:#lower numTwist:3 =
		(
			undo off  --apaga la opción de undo (operaciones que se van haciendo) para que no ocupe memoria.
				createConnections bon side location numTwist
			
			lb.rig.solutions.addSolutionInfo this.skinNodes.twistSolutionHLP (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	solutionParameters 1.0

			-- Cambiamos el emparentamiento del expose del lower para que nos funcione el autosTRech; 
			-- lo hacemos después de añadir la solución para que se nos queden los nodos guardados en el solRoot

			if (isValidNode this.skinNodes.exposeHLpLower) then
			(
				lb.controller.setActiveController this.skinNodes.exposeHLpLower #all #frozen
				this.skinNodes.exposeHLpLower.parent = this.skinNodes.bonChild
				lb.controller.setActiveController this.skinNodes.exposeHLpLower #all #Zero
			)	
		),			

		------------------------------------------------
		--@fn: boolean | remove | Elimina la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn remove solutionRoot =
		(

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
			lb.rig.solutions.addSolution this --añade la solución a la principal
		)
		
	)--rs_template
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rss_twist() --crea la libreria
)