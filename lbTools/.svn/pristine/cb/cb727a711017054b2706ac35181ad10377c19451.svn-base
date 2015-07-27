------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta splineIkSolutions.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta splineIkSolutions.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Spline Ik Solutions"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 250		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		--local boneSelected = #()
		local pointScripts = undefined
		local autoStrech = false 
		local rollOpen = false 
		local splineSelectedOption = undefined
		local ikSpline = undefined
		local bonesSelected = #()
		local splineSelectedOptionHelperList = undefined
		local ss = undefined
		local pointsSubControlArray = #()
		local splineReturn =undefined
		local pointStart = undefined	
		local pointEnd = undefined
		local pointUpnodeIkSpline  = undefined

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		radiobuttons rdoCreationType "" pos:[25,25] width:98 height:32 labels:#("Refine Bone", "Selected Bones") columns:1
		spinner spnNumBones "" pos:[130,25] width:56 height:16 range:[1,100,3] type:#integer range:[1,100,3] 
		checkbox chkDynamicRotation "Dynamic Rotation" pos:[30,80] width:120 height:20
		GroupBox grpIkSplineOptions "ik Spline Options" pos:[16,60] width:189 height:125
		GroupBox grpTwistBoneOptions "Twist Bones Options" pos:[8,8] width:205 height:232
		checkbox chkAutoStrech "AutoStrech" pos:[30,140] width:100 height:16 enabled:false
		label lblSubControls "SubControls" pos:[40,160] width:64 height:16 
		spinner spnSubControlsNumber "" pos:[130,160] width:57 height:16 range:[0,100,3] type:#integer
		
		button btnCreate "Create" pos:[44,190] width:136 height:40
		
		radioButtons rdoSubControlsType "" pos:[50,100] width:141 height:32 labels:#("Instance SubControls", "Constraints SubControls") enabled:false
		
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

		------------------------------------------------------------------------------
		--funcion para crear una spline para la opcion "refine bone"
		------------------------------------------------------------------------------
		fn drawLineBetweenTwoPoints pointA pointB refBone =
		(
			ss = SplineShape rotation: refBone pos:pointA
			addNewSpline ss
			addKnot ss 1 #corner #line PointA
			addKnot ss 1 #corner #line PointB
			updateShape ss
			ss
		)
		
		------------------------------------------------------------------------------
		--funcion para crear una spline para la opcion "selected bones"
		------------------------------------------------------------------------------
		fn createSplineToSelection bonesSelected =
		(
			bonesSelected = getCurrentSelection()
			
			ss = SplineShape pos:bonesSelected[1].pos
			addNewSpline ss
			
			for i = 1 to bonesSelected.count do
				addKnot ss 1 #corner #line bonesSelected[i].pos
			
			ss.steps = 0
			ss.optimize = false

			lb.misc.renameFromObj ss bonesSelected[1].name lb.nc.NC_classAnim sufix:"Line" flags:(lb.nc.NC_automaticFlag  + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			
			updateShape ss
			ss
		)
		
		------------------------------------------------------------------------------	
		--divide la spline por el numero de vertices que tenga
		------------------------------------------------------------------------------
		fn splineRefine splineObj numSeg =
		(
			subdivideSegment splineObj 1 1 numSeg
			splineKnots = numKnots splineObj
			
			for i = 1 to splineKnots do
				setKnotType splineObj 1 i #smooth
		)
		
		------------------------------------------------------------------------------	
		--funcion para crear un point donde guardaremos todos los script de la solucion
		------------------------------------------------------------------------------
		fn pointCreation = 
		(
			pointScripts = undefined
			if bonesSelected.count > 0 then -- Selection Comprovation
			(
				finalName = bonesSelected[1].name + "pointScripts"
				
				if lb.nc.ncOK bonesSelected[1].name then
				(
					objNameArray = filterString bonesSelected[1].name "_"
					finalName = objNameArray[1] + "_" + objNameArray[2]  + "_rig_m_scripts_x_x"
				)
				
				pointScripts = undefined
				
				flag = false
				for x in objects do -- Find Point in Scene
				(
					if (findString x.name "_rig_m_scripts_x_x") != undefined then
					(
						flag = true
						pointScripts = x
					)
				)
				
				if not flag then
				(
					--crea el point de los scripts
					pointScripts = Point pos:[0,0,0]
					pointScripts.cross = on
					pointScripts.Box = off
					
					pointScripts.pos.controller = position_list ()
					pointScripts.pos.controller.delete 1
					
					-- Change name of point
					--finalName = objNameArray[1] + "_" + objNameArray[2]  + "_rig_m_scripts_x_x"
					pointScripts.name = finalName
					-- Adjust Point
					pointScripts.size = 20
					-- Change Color
					pointScripts.wirecolor = color 255 255 0 -- Yellow
				)
			)
		)	

		------------------------------------------------------------------------------		
		--crea el sistema de ik spline para la opcion "refine" del macro
		------------------------------------------------------------------------------		
		fn ikSplineMaker shapeSpline baseBone startBone finalBone numCtrls =
		(
			splineRefine shapeSpline numCtrls
			
			struct ikObjects (ikChain, helperList)
			
			ikReturn = ikObjects ikChain:undefined helperList:#()
			
			-- ik Chain Creation
			ikReturn.ikChain = iksys.IKChain  startBone finalBone "SplineIKSolver"
			ikReturn.ikChain.transform.controller.goalSize = 5
			
			-- Asign Spline as controller to IkChainS
			ikReturn.ikChain.transform.controller.pickShape = shapeSpline
			
			-- Add Spline_Ik_controller to Spline to deform with points
			AddModifier shapeSpline (Spline_IK_Control())
			
			ikReturn.helperList = shapeSpline.modifiers[1].helper_list
			
			-- Creation of Helpers in pline. One by every knot
			shapeSpline.modifiers[1].createhelper (0)
			shapeSpline.modifiers[#Spline_IK_Control].linkTypes = 2
			
			ikReturn.helperList[1].transform = startBone.transform
			ikReturn.helperList[ikReturn.helperList.count].transform = finalBone.transform

			ikReturn.ikChain.transform = shapeSpline.modifiers[1].helper_list[shapeSpline.modifiers[1].helper_list.count].transform
		
				
			for j = 1 to ikReturn.helperList.count do
			(
				if baseBone.objectoffsetscale.x == -1 then -- Flip Axis for Fliped Bones
				(
					pH = ikReturn.helperList[j]
			-- 					pH.transform = matrix3 -pH.transform[1] pH.transform[2] -pH.transform[3] pH.transform[4]
				)
				ikReturn.helperList[j].size = 5
				CoordSys gimbal ikReturn.helperList[j].rotation = ikReturn.helperList[1].rotation
			)
			
			shapeSpline.modifiers[#Spline_IK_Control].linkTypes = 1
			
			-- Parent
			ikReturn.helperList[1].parent = baseBone
			
			
			-- Selection and assign Up Node to first Helper of the Spline
			helperObj = ikReturn.helperList[1]
			
			--select helperObj
			ikReturn.ikChain.controller.upnode = helperObj
			
			ikReturn
		)
			
		------------------------------------------------------------------------------		
		--funcion para montar el sistema completo de ikSpline para la opción"refine bone"e
		--tambien creamos el sistema autoStrech
		------------------------------------------------------------------------------	
		fn boneRefine bonesToRefine num numCtrls=
		(
			struct boneParams (refinedBones, newLine)
			
			boneReturn = boneParams refinedBones:#() newLine:undefined
			
			for x in bonesToRefine do
			(
				-- Variables
				OB_length = x.length
				newLength = OB_length/num
				boneReturn.refinedBones = #()
				
				-- Refine Bones Creation
				for k=1 to (num + 1) do
				(
					newBone=BoneSys.createBone [0,0,0] [newLength,0,0] [0,0,1]
					
					newBone.wirecolor = color 255 255 0 -- Yellow
					newBone.Taper = 0
					newBone.frontfin = off
					newBone.backfin = off
					newBone.sidefins = off
					newBone.width = 3
					newBone.height = 3
					newBone.length = newLength
					
					
					if x.objectoffsetscale.x == -1 then -- para huesos invertidos
					(
						newBone.objectoffsetscale =  x.objectoffsetscale
						in coordSys Local move newBone [-(newBone.length*(k-1)),0,0]
					)
					else
						in coordSys Local move newBone [(newBone.length*(k-1)),0,0]
					
					-- Change name of bone
					--rename newBone x.name k "Twist"
					lb.misc.renameFromObj newBone x.name lb.nc.NC_classAnim sufix:("Twist" + (if k < 10 then  "0" + (k as string) else (k as string))) flags:(lb.nc.NC_automaticFlag + lb.nc.NC_frozenFlag)

					
					append boneReturn.refinedBones newBone
					
					if k > 1 then
					(
						boneReturn.refinedBones[k].parent = boneReturn.refinedBones[k-1]
					)
					
					if k == (num +1) then
					(
						newBone.length = newBone.height
						newBone.Taper = 90
					)
					
					-- Freeze Bones
					for y in boneReturn.refinedBones do
						lb.controller.freezeTransform y #all
				)
				
				--creacion de ikSpline
				firstPoint = boneReturn.refinedBones[1]
				endPoint = boneReturn.refinedBones[boneReturn.refinedBones.count]
				
				boneReturn.newLine = drawLineBetweenTwoPoints [0,0,0] [x.length,0,0] firstPoint.rotation
				
				boneReturn.newLine.wirecolor = color 255 255 0 -- Yellow
				
				splineReturn = ikSplineMaker boneReturn.newLine x firstPoint endPoint  numCtrls-- ikSpline creation Function
				
				
				
				---------------------------------------------------------------------------------------------------------
				-- Strech Creation
				---------------------------------------------------------------------------------------------------------
				if chkAutoStrech.checked == true then
				(
					pointCreation() -- Point Object function creation
					
					
					-- Controller exist comprovation
					nameController = ""
					if pointScripts.pos.controller.count > 0 then
						nameController = pointScripts.pos.controller.getName pointScripts.pos.controller.count
					
					-- final name for Controller
					objNameArray = filterString x.name "_"
					ctrlName = objNameArray[4] + "_" + objNameArray[5] + "Strech"
					
					if nameController == ctrlName then
					(
						-- Delete Script Controller
						pointScripts.pos.controller.delete (pointScripts.pos.controller.count)
					)
					
					-- add script controller to Point Object.
					pointScripts.pos.controller.available.controller = Position_Script()
					
					-- Controller Name change
					objNameArray = filterString x.name "_"
					ctrlName = objNameArray[4] + "_" + objNameArray[5] + "Strech"
					pointScripts.pos.controller.setName (pointScripts.pos.controller.count) ctrlName
					
					-- Variables
					scriptCtrl = pointScripts.pos.controller[pointScripts.pos.controller.count]
					
					originalLength = curveLength boneReturn.newLine
					
					scriptCtrl.addObject #spline boneReturn.newLine
					
					-- variable creation for number of bone twist
					for i=1 to boneReturn.refinedBones.count do
					(
						if i <10 then
						(
							nameBone = "Bone0" + i as string
						)
						else
						(
							nameBone = "Bone" + i as string
						)
						scriptCtrl.addObject nameBone boneReturn.refinedBones[i]
					)
					
					-- original curveLength value calculation
					originalLength = curveLength boneReturn.newLine
					
					-- add script to Script controller
					auxScriptString = 	"originalLength = "+ (originalLength as string) + "\n"+
												"newLineLength = curveLength spline\n"+
												"diferenceLength = newLineLength - originalLength\n"
					
					for i=1 to boneReturn.refinedBones.count do
					(
						index = if i < 10 then ("0" + i as string) else (i as string)
						auxScriptString = auxScriptString + "bone" + index + ".position.controller[2].controller[1].value = diferenceLength / " + (boneReturn.refinedBones.count - 1) as string + "\n"
					)
					
					scriptCtrl.script = auxScriptString + "[ 0, 0, 0 ]"
				) -- End Strech
				
				-- Change names
			--	rename boneReturn.newLine x.name undefined "Line"
				lb.misc.renameFromObj boneReturn.newLine x.name lb.nc.NC_classAnim sufix:"Line" flags:(lb.nc.NC_automaticFlag + lb.nc.NC_hiddenFlag + lb.nc.NC_frozenFlag)

				
				lb.misc.renameFromObj splineReturn.ikChain x.name lb.nc.NC_classAnim sufix:"IkChain" flags:(lb.nc.NC_automaticFlag + lb.nc.NC_hiddenFlag + lb.nc.NC_frozenFlag)
				
				for l =1 to splineReturn.helperList.count do
				(
					lb.misc.renameFromObj splineReturn.helperList[l] x.name lb.nc.NC_classAnim sufix:("Helper" + (if l < 10 then  "0" + (l as string) else (l as string))) flags:(lb.nc.NC_automaticFlag  + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					splineReturn.helperList[l].wirecolor = color 255 130 0 -- Orange
				)
				
				-- Move structure to BaseBone transformations
				splineReturn.helperList[1].transform = x.transform
				
				-- Parents
				splineReturn.ikChain.parent = splineReturn.helperlist[splineReturn.helperlist.count]
				boneReturn.newLine.parent = splineReturn.helperList[1]
				
				-- Freeze transformations
				for k in splineReturn.helperList do
					lb.controller.freezeTransform k #all
				
				lb.controller.freezeTransform splineReturn.ikChain #all
				
				splineReturn.ikChain.transform = splineReturn.helperlist[splineReturn.helperlist.count].transform
				
				splineReturn.ikChain.parent = splineReturn.helperlist[splineReturn.helperlist.count]
				
				lb.controller.freezeTransform boneReturn.newLine #all
				
				-- Instancing Controllers
				for m = 2 to (splineReturn.helperList.count - 1) do
				(
					splineReturn.helperList[m].position.controller.available.controller = splineReturn.helperList[1].position.controller[2].controller
					splineReturn.helperList[m].position.controller.setName 3 "InitPosition"
					splineReturn.helperList[m].position.controller.weight[splineReturn.helperList[m].position.controller.count] = ((100/(splineReturn.helperList.count - 1))*(splineReturn.helperList.count - m))
					
					splineReturn.helperList[m].position.controller.available.controller = splineReturn.helperList[splineReturn.helperList.count].position.controller[2].controller
					splineReturn.helperList[m].position.controller.setName 4 "EndPosition"
					splineReturn.helperList[m].position.controller.weight[splineReturn.helperList[m].position.controller.count] = ((100/(splineReturn.helperList.count - 1))*(m - 1))	
				)
			-- 					
				-- Wireparamiter Twist x_Rotation
				expresion = "X_Rotation"
				if x.objectoffsetscale.x == -1 then
					expresion = "-" + expresion
				
				paramWire.connect  splineReturn.helperList[splineReturn.helperList.count].rotation.controller[2].controller[1] splineReturn.ikChain.transform.controller[#Twist_End_Angle] expresion
				
			--Instancia las pistas de del helper inicial al resto diviendo su valor entre el numero de huesos que halla, para que se muevan aditivamente
				boneReturn.refinedBones[1].pos.controller.Available.controller = Position_Constraint ()
			
				boneReturn.refinedBones[1].pos.controller[boneReturn.refinedBones[1].pos.controller.count].appendTarget splineReturn.helperlist[1] 100.0
			-- 				
				boneReturn.refinedBones[1].transform = x.transform				
			)
		
			boneReturn
		)

		-----------------------------------------------------------------------------------
		--creacion de los points donde se colacara el ikSpline pasandole una seleccion de huesos.
		--Tambien añadimos el constraint de posicion a los huesos.
		-----------------------------------------------------------------------------------
		fn createPointsSelectedBones bonesSelected =
		(
			pointsIkSpline = #()
			
			--Creamos points de la seleccion de huesos
			bonesSelected = (lb.rig.getHierarchiesFromNodes bonesSelected)[1] 
			
			--los guardamos, freezeamos y cambiamos su color
			pointsIkSpline = lb.rig.createPointsFromHierarchy bonesSelected
			
			for i = 1 to pointsIkSpline.count do
			(
				pointsIkSpline[i].wirecolor = color 255 0 0
				pointsIkSpline[i].isHidden = true
				pointsIkSpline[i].size = 5
				lb.controller.freezeTransform pointsIkSpline[i] #all
				--renombramos los points en base a los huesos
				lb.misc.renameFromObj pointsIkSpline[i] bonesSelected[i].name lb.nc.NC_classAnim sufix:"BaseHelper" flags:(lb.nc.NC_automaticFlag  + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			)

			--para cada hueso añadimos ya un constraint de posicion con su target, que sear y peso correspondiente
			for i = 1 to bonesSelected.count do
			(
				posCons = position_constraint()
				
				bonesSelected[i].pos.controller.available.controller = posCons --añade constraint
				bonesSelected[i].pos.controller["Position_Constraint"].controller.appendTarget pointsIkSpline[i] 100 --añade target con peso a 100
				bonesSelected[i].pos.controller["Position_Constraint"].controller.relative = on -- opcion kepp initial offset activada
			)
		
			pointUpnodeIkSpline = point cross:false box:true size:4 wirecolor: [255,255,0]
			lb.misc.renameFromObj pointUpnodeIkSpline bonesSelected[1].name lb.nc.NC_classAnim sufix:"IkChainUpnode" flags:(lb.nc.NC_automaticFlag  + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)

			pointsIkSpline
		)
		
		-----------------------------------------------------------------------------------
		--creacion de ikSpline para la opcion "selected bones" del macro, y points base donde
		-- se creara la ikSpline.
		-----------------------------------------------------------------------------------
		
		fn selectedBonesIkspline pointsIkSpline =
		(
			--creamos la ikSpline en los nuevos points creados y los renombramos
			ikSpline = ikSys.ikChain pointsIkSpline[1] pointsIkSpline[pointsIkSpline.count] "SplineIKSolver"
			ikSpline.transform.controller.goalSize = 10
			lb.misc.renameFromObj ikSpline pointsIkSpline[1].name lb.nc.NC_classAnim sufix:"Goal" flags:(lb.nc.NC_automaticFlag  + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			
			ikSpline.isHidden = true
			--freezeamos la spline
			lb.controller.freezeTransform ikSpline #all

			ikSpline
		)
		
		------------------------------------------------------------------------------
		--creacion de subControls para la opcion de "selectBones" del macro
		------------------------------------------------------------------------------
		fn createSubControlsSelectBones ss bonesSelected numCtrls =
		(
			pointsSubControlArray=#()
			
			splinePercent = (100.0/ (numCtrls - 1))
			
			mergeMAXFile chrShapesPath #("chr_chrName_rig_x_sphereShapeTrans_x_c")
			cntrShape = execute ("$'chr_chrName_rig_x_sphereShapeTrans_x_c'")	
			cntrShape.name = "cntrShape"
				
			mergeMAXFile chrShapesPath #("chr_chrName_rig_x_sphereShapeTrans_x_c")		
			cntrShapeSmall = execute ("$'chr_chrName_rig_x_sphereShapeTrans_x_c'")	
			cntrShapeSmall.name = "cntrShapeSmall"	
				
			rotate cntrShape (eulerAngles 0 90 0) --lo ratamos 90 grados para que als copias este bien alineadas
			--cntrShape.scale = [1.1,1.1,1.1]	
				
			rotate cntrShapeSmall (eulerAngles 0 90 0) --lo ratamos 90 grados para que als copias este bien alineadas
			--cntrShapeSmall.scale = [0.9,0.9,0.9]	
				
			lb.controller.freezeTransform cntrShape #all --hacemos freeze transform del obj
			lb.controller.freezeTransform cntrShapeSmall #all --hacemos freeze transform del obj
				
			resetXform cntrShape --hacemos resetXform para mantener ejes
			resetXform cntrShapeSmall --hacemos resetXform para mantener ejes
				
			collapseStack cntrShape--colpasamos el modificador	
			collapseStack cntrShapeSmall--colpasamos el modificador	
				
			for i=1 to numCtrls do
			(

				if isValidNode cntrShape then
				(
					pointSubControl = copy cntrShapeSmall
					pointSubControl.wirecolor = color 0 255 0
				)	
				else
				(
					pointSubControl = point wirecolor:[0,255,0] cross:true box:true size:25
				)
					
				lb.misc.renameFromObj pointSubControl bonesSelected[1].name lb.nc.NC_classAnim sufix:("SubControl" + (if i < 10 then  "0" + (i as string) else (i as string)))  flags:(lb.nc.NC_controlFlag)
	
				pointPos = lengthInterp ss 1 ((splinePercent*(i-1))/100)
				
				pointSubControl.pos = pointPos
				
				minDistance = 100000
				boneMoreNear = undefined
				
				for j=1 to bonesSelected.count do
				(
					newDistance = distance pointSubControl.pos bonesSelected[j].center
		
					if minDistance > newDistance then 
					(
						minDistance = newDistance
						boneMoreNear = bonesSelected[j]
					)
				)
				
				--alineamos su matrix3 con el hueso que hemos detectado que esta mas cercano
				pointTrans = pointSubControl.transform
				boneTrans = boneMoreNear.transform
				
				pointTrans.row1 = boneTrans.row1
				pointTrans.row2 = boneTrans.row2
				pointTrans.row3 = boneTrans.row3
				
				pointSubControl.transform = pointTrans
				
				append pointsSubControlArray pointSubControl
				 				
				lb.controller.freezeTransform 	pointsSubControlArray[i] #all
				)
				
				--creacion de points de inicio y final
				if isValidNode cntrShape then
				(
					pointStart = copy cntrShape wirecolor:[25,175,25]
					pointEnd = copy cntrShape wirecolor:[25,175,25]
				)
				else
				(
					pointStart = point wirecolor:[0,215,255] cross:false box:true size:35
					pointEnd = point wirecolor:[0,215,255] cross:false box:true size:35
				)

				lb.misc.renameFromObj pointStart bonesSelected[1].name lb.nc.NC_classAnim sufix:("RootCntrl") flags:(lb.nc.NC_controlFlag)
				lb.misc.renameFromObj pointEnd bonesSelected[1].name lb.nc.NC_classAnim sufix:("RootEnd") flags:(lb.nc.NC_controlFlag)
				
				pointStart.transform = pointsSubControlArray[1].transform
				pointEnd.transform  = pointsSubControlArray[pointsSubControlArray.count].transform 
				
				pointEnd.parent = pointStart
				
				lb.controller.freezeTransform pointEnd #all
				lb.controller.freezeTransform pointStart #all
				
				for i = 1 to (pointsSubControlArray.count - 1) do
				(
					pointsSubControlArray[i].controller.position.controller.setActive 1
					pointsSubControlArray[i].parent = pointStart
					pointsSubControlArray[1].isHidden = true
					
					pointsSubControlArray[pointsSubControlArray.count].parent = pointEnd
					
					--pointsSubControlArray[pointsSubControlArray.count].isHidden = true
					
					pointsSubControlArray[i].controller.position.controller.setActive 2
				)	
				
			--creamos el target para el upnode del ikSpline, alineamos en posicion y emparentamos
			pointUpnodeIkSpline.pos = pointStart.pos
			pointUpnodeIkSpline.parent = pointStart
			pointUpnodeIkSpline.isHidden = true	
			
			lb.controller.freezeTransform pointUpnodeIkSpline #all
				
			--activamos las transofrmacion al controlador frozen para emparentar
			bonesSelected[1].controller.position.controller.setActive 1
			bonesSelected[1].controller.rotation.controller.setActive 1
			bonesSelected[1].controller.scale.controller.setActive 1
			
			bonesSelected[1].parent = pointUpnodeIkSpline

			--activamos el zero de nuevo
			bonesSelected[1].controller.position.controller.setActive 2
			bonesSelected[1].controller.rotation.controller.setActive 2
			bonesSelected[1].controller.scale.controller.setActive 2

			delete cntrShape
			delete cntrShapeSmall
			
			pointsSubControlArray			
		)

		------------------------------------------------------------------------------------
		--añade el modificador ik Spline a la spline y creamos los helpers necesarios
		------------------------------------------------------------------------------------
		fn addModifierIkSplineAndCreateHelpers splineSelectedOption pointsIkSpline bonesSelected =
		(
			AddModifier splineSelectedOption (Spline_IK_Control())
		
			splineSelectedOptionHelperList = splineSelectedOption.modifiers[1].helper_list				
			splineSelectedOption.modifiers[1].createhelper (0)
			splineSelectedOption.modifiers[#Spline_IK_Control].linkTypes = 2
			
				
			for h = 1 to splineSelectedOptionHelperList.count do
			(
				if bonesSelected[1].objectoffsetscale.x == -1 then -- Flip Axis for Fliped Bones
					pH = splineSelectedOptionHelperList[h]
				
				splineSelectedOptionHelperList[h].size = 10
				
					boneTrans = bonesSelected[h].transform
					pointTrans = splineSelectedOptionHelperList[h].transform
				
				splineSelectedOptionHelperList[h].transform = matrix3 (boneTrans.row1) (boneTrans.row2) (boneTrans.row3) (boneTrans.row4)
				splineSelectedOptionHelperList[h].isHidden = true 
			)

			splineSelectedOption.modifiers[#Spline_IK_Control].linkTypes = 2
			
			--freezeamos los helpers creados, renombramos y cambiamos su color a naranja	
			for i =1 to splineSelectedOptionHelperList.count do
			(
			-- 				splineSelectedOptionHelperList[i].parent = pointStart
			-- 				splineSelectedOptionHelperList[splineSelectedOptionHelperList.count].parent = pointEnd
				
				lb.controller.freezeTransform splineSelectedOptionHelperList[i] #all
				lb.misc.renameFromObj splineSelectedOptionHelperList[i] bonesSelected[i].name lb.nc.NC_classAnim sufix:("HelperSplineIk" + (if i < 10 then  "0" + (i as string) else (i as string))) flags:(lb.nc.NC_automaticFlag  + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				splineSelectedOptionHelperList[i].wirecolor = color 255 130 0	
					
			)

			--creamos los points donde los huesos deberan de llevar el upnode del lookAt
			--y lo guardamos en el array
			pointsUpNode = #()
			
			--version que alineaba con los points del ikSpline
			-- 			for i = 1 to splineSelectedOptionHelperList.count do
			-- 			(
			-- 				points = lb.rig.createPointFromObj splineSelectedOptionHelperList[i]
			-- 				append pointsUpNode points
			-- 			)	
			
			-- 			--version que alinea con los points de posconstraint y lookat
			for i = 1 to pointsIkSpline.count do
			(
				points = lb.rig.createPointFromObj pointsIkSpline[i]
				append pointsUpNode points
			)	

			-- freezeamos los points, los renombramos cogiendo el nombre de los helpers de la ikSpline
			--cambiamos su color, su tamaño y lo emparentamos con su helper correspondiente, y los ocultamos
			for i = 1 to pointsUpNode.count do
			(
				
				pointsUpnode[i].size = 7
				pointsUpnode[i].isHidden = true
				lb.misc.renameFromObj pointsUpnode[i] bonesSelected[i].name lb.nc.NC_classAnim sufix:("HelperUpnode" + (if i < 10 then  "0" + (i as string) else (i as string))) flags:(lb.nc.NC_automaticFlag  + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				pointsUpnode[i].wirecolor = color 255 255 0	
					
				pointsUpnode[i].parent = pointsIkSpline[i] -- emparentamos a los helpers de la ikSpline
								
				lb.controller.freezeTransform pointsUpnode[i] #all
			)
			
			--seleccionamos el target del ikSpline
			-- 			ikSpline.controller.upnode = pointUpnodeIkSpline

			cont = 2 --contador
			
			--añadimos por cada hueso el controlador lookAt con las pociones necesarias, y le añadimos su upnode
			for i = 1 to (bonesSelected.count - 1) do
			(
				lookAtCons = lookAt_constraint()
				
				bonesSelected[i].rotation.controller.available.controller = lookAt_Constraint () --añade constraint
				bonesSelected[i].rotation.controller["LookAt_constraint"].controller.appendTarget pointsIkSpline[cont] 100 --añade target con peso a 100
				bonesSelected[i].rotation.controller["LookAt_constraint"].controller.relative = on -- opcion kepp initial offset activada
					
				bonesSelected[i].rotation.controller["LookAt_constraint"].controller.lookat_vector_length = 0--quitamos el vector de longitud visual
						
				bonesSelected[i].rotation.controller["LookAt_constraint"].controller.upnode_world = off--desastivamos el upnode al mundo
				bonesSelected[i].rotation.controller["LookAt_constraint"].controller.pickUpNode = pointsUpnode[cont]--seleccionamos el upnode del array
				
				cont +=1
			)
			
			
			--emparentamos el primer point de la splineIk a un point auxiliar
			
			--activamos las transofrmacion al controlador frozen para emparentar
			pointsIkSpline[1].position.controller.setActive 1
			pointsIkSpline[1].rotation.controller.setActive 1
			pointsIkSpline[1].scale.controller.setActive 1
			-- 			
			pointsIkSpline[1].parent = pointUpnodeIkSpline

			--activamos el zero de nuevo
			pointsIkSpline[1].position.controller.setActive 2
			pointsIkSpline[1].rotation.controller.setActive 2
			pointsIkSpline[1].scale.controller.setActive 2

			cont
			
			pointsUpNode
		)

		------------------------------------------------------------------------------
		--creacion de intancia para controles naranjas con los subControles
		------------------------------------------------------------------------------
		fn instanceSubControlsToControlsIkSpline pointsIkSpline ikChain splineIkModifier helperListIkSpline pointsSubControl =
		(
			
			--emparentamos los helper de la ikSpline con el pointStart y el ultimo con el pointFinal
			for i =1 to helperListIkSpline.count do 
			(
				--activamos las transofrmacion al controlador frozen para emparentar
				helperListIkSpline[i].controller.position.controller.setActive 1
				helperListIkSpline[i].controller.rotation.controller.setActive 1
				helperListIkSpline[i].controller.scale.controller.setActive 1
				
				helperListIkSpline[i].parent = pointStart
	 			helperListIkSpline[splineSelectedOptionHelperList.count].parent = pointsSubControl[pointsSubControl.count]--emparentamos el ultimo con el ultimo Subcontrol		

				--activamos el zero de nuevo
				helperListIkSpline[i].controller.position.controller.setActive 2
				helperListIkSpline[i].controller.rotation.controller.setActive 2
				helperListIkSpline[i].controller.scale.controller.setActive 2
			)

			helperListIkSpline
						
			-- 			helperListIkSpline[1].rotation.controller.available.controller = pointsSubControl[1].rotation.controller["Zero_Euler_XYZ"].controller 
			-- 			helperListIkSpline[1].position.controller.available.controller = pointsSubControl[1].position.controller["Zero_Pos_XYZ"].controller 

			-- calculamos el rango de distancia, la longitud de la spline entre 3, por defecto 
			rangeDistance = (curveLength splineIkModifier / (helperListIkSpline.count/2)) 
			
			-- 			for i=1 to (helperListIkSpline.count - 1) do
			-- 				helperListIkSpline[i].parent = pointStart
		
			-- 			helperListIkSpline[helperListIkSpline.count].parent = pointEnd 
						
			--freezeamos  el primer hueso para instanciar su pista con el point subControl 1
			lb.controller.freezeTransform pointsIkSpline #all 
			
			pointsIkSpline = pointsIkSpline.position.controller.available.controller = Position_Constraint()
			pointsIkSpline.appendTarget pointStart 100
			
			--emparentamos la spline y el ik chain de la spline
			splineIkModifier.parent = pointsSubControl[1]
			ikChain.parent = pointsSubControl[pointsSubControl.count]
			-- 			
			--emparentamos el subControl final a la Point Padre final
			pointsSubControl[pointsSubControl.count].controller.position.controller.setActive 1
			pointsSubControl[pointsSubControl.count].parent = pointEnd
			pointsSubControl[pointsSubControl.count].controller.position.controller.setActive 2
			
			--freezeamos de nuevo los subControles para evitar fallos al instanciar las pistas
			for i = 1 to pointsSubControlArray.count do
				lb.controller.freezeTransform 	pointsSubControlArray[i] #all
			
			-- Conectamos por wireparameter el ultimo helper con el twistEnd Angle

			lb.controller.freezeTransform pointEnd #all
			lb.controller.freezeTransform pointStart #all
			

			expresion = "X_Rotation"
			if bonesSelected[1].objectoffsetscale.x == -1 then
				expresion = "-" + expresion

			paramWire.connect  pointEnd.rotation.controller.Zero_Euler_XYZ.controller[#X_Rotation] ikChain.transform.controller[#Twist_End_Angle] expresion

			--instanciamos los controladores de los helper de la ik a los subcontroles
			for h = 2 to (helperListIkSpline.count - 1) do --lo hacemos por cada helper de la ikSpline
			(
			
				for i=2 to pointsSubControl.count do -- e instanciamos a partir del 2º cntrl
				(
					newDistance = distance helperListIkSpline[h].pos pointsSubControl[i].pos--calculamos la distancia de cada helper a cada subCntrl
					
					--calculamos el porcentaje a reparitr por cada helper
					if  newDistance <= rangeDistance then
					(
						nameParts = filterString  pointsSubControl[i].name "_"
						percentPartial = ((1 - (newDistance / rangeDistance)) * 100)
						
						--instanciamos todos los controles excepto el ultimo que instanciamos el pointEnd grande
						if i == pointsSubControl.count then
						(
							helperListIkSpline[h].position.controller.available.controller = pointEnd.position.controller["Zero_Pos_XYZ"].controller
							helperListIkSpline[h].position.controller.weights[helperListIkSpline[h].position.controller.count].value = percentPartial
						)
						else
						(
							helperListIkSpline[h].position.controller.available.controller = pointsSubControl[i].position.controller["Zero_Pos_XYZ"].controller
							helperListIkSpline[h].position.controller.weights[helperListIkSpline[h].position.controller.count].value = percentPartial
						)
						
						if lb.nc.ncOK pointsSubControl[i].name then
							helperListIkSpline[h].position.controller.setName helperListIkSpline[h].position.controller.count nameParts[5]
					)
				)
			)
		)	

		------------------------------------------------------------------------------
		--creacion de PosConstraint para controles naranjas con los subControles 
		------------------------------------------------------------------------------
		fn instanceSubControlsPositionConstraint pointsIkSpline ikChain splineIkModifier helperListIkSpline pointsSubControl =
		(
			--emparentamos los helper de la ikSpline con el pointStart y el ultimo con el pointFinal
			for i =1 to helperListIkSpline.count do 
			(
				--activamos las transofrmacion al controlador frozen para emparentar
				helperListIkSpline[i].controller.position.controller.setActive 1
				helperListIkSpline[i].controller.rotation.controller.setActive 1
				helperListIkSpline[i].controller.scale.controller.setActive 1
				
				helperListIkSpline[i].parent = pointStart
	 			helperListIkSpline[splineSelectedOptionHelperList.count].parent = pointsSubControl[pointsSubControl.count]--emparentamos el ultimo con el ultimo Subcontrol		

				--activamos el zero de nuevo
				helperListIkSpline[i].controller.position.controller.setActive 2
				helperListIkSpline[i].controller.rotation.controller.setActive 2
				helperListIkSpline[i].controller.scale.controller.setActive 2

			)

			-- 			helperListIkSpline
						
			-- 			helperListIkSpline[1].rotation.controller.available.controller = pointsSubControl[1].rotation.controller["Zero_Euler_XYZ"].controller 
			-- 			helperListIkSpline[1].position.controller.available.controller = pointsSubControl[1].position.controller["Zero_Pos_XYZ"].controller 

			-- calculamos el rango de distancia, la longitud de la spline entre 3, por defecto 
			rangeDistance = (curveLength splineIkModifier / (helperListIkSpline.count/2)) 
			
			-- 			for i=1 to (helperListIkSpline.count - 1) do
			-- 				helperListIkSpline[i].parent = pointStart
		
			-- 			helperListIkSpline[helperListIkSpline.count].parent = pointEnd 
						
			--freezeamos  el primer hueso para instanciar su pista con el point subControl 1
			lb.controller.freezeTransform pointsIkSpline #all 
			
			pointsIkSpline = pointsIkSpline.position.controller.available.controller = Position_Constraint()
			pointsIkSpline.appendTarget pointStart 100
			
			--emparentamos la spline y el ik chain de la spline
			splineIkModifier.parent = pointsSubControl[1]
			ikChain.parent = pointsSubControl[pointsSubControl.count]

			--emparentamos el subControl final a la Point Padre final
			pointsSubControl[pointsSubControl.count].controller.position.controller.setActive 1
			pointsSubControl[pointsSubControl.count].parent = pointEnd
			pointsSubControl[pointsSubControl.count].controller.position.controller.setActive 2
			
			
			
			--freezeamos de nuevo los subControles para evitar fallos al instanciar las pistas
			for i = 1 to pointsSubControlArray.count do
				lb.controller.freezeTransform 	pointsSubControlArray[i] #all
	

			-- Conectamos por wireparameter el ultimo helper con el twistEnd Angle

			lb.controller.freezeTransform pointEnd #all
			lb.controller.freezeTransform pointStart #all
			

			expresion = "X_Rotation"
			if bonesSelected[1].objectoffsetscale.x == -1 then
				expresion = "-" + expresion

			paramWire.connect  pointEnd.rotation.controller.Zero_Euler_XYZ.controller[#X_Rotation] ikChain.transform.controller[#Twist_End_Angle] expresion

			--guardamos la posicion de los helpers de la ikSpline en un array para evitar fallos
			--al ejecutar las siguiente lineas
			positions = for h in helperListIkSpline collect h.pos
				
			--instanciamos los controladores de los helper de la ik a los subcontroles
			for h = 2 to (positions.count - 1) do --lo hacemos por cada helper de la ikSpline
			(
				-- añadimos el constraint a todos los helpers de la ikSpline
				
				helperListIkSplineConstraint = helperListIkSpline[h].position.controller.available.controller = Position_Constraint() 
				
				for i=1 to pointsSubControl.count do -- e instanciamos a partir del 2º cntrl
				(
					newDistance = distance positions[h] pointsSubControl[i].pos--calculamos la distancia de cada helper a cada subCntrl

					--calculamos el porcentaje a reparitr por cada helper
					if  newDistance <= rangeDistance then
					(
						nameParts = filterString  pointsSubControl[i].name "_"
						percentPartial = ((1 - (newDistance / rangeDistance)) * 100)
			-- 						
			-- 						--instanciamos todos los controles excepto el ultimo que instanciamos el pointEnd grande
						if i == pointsSubControl.count then
						( 							
							helperListIkSplineConstraint.appendTarget pointsSubControl[i] percentPartial
							helperListIkSpline[h].position.controller.weights[helperListIkSpline[h].position.controller.count].value = 100
						)
						else
						(
							helperListIkSplineConstraint.appendTarget pointsSubControl[i] percentPartial
							helperListIkSpline[h].position.controller.weights[helperListIkSpline[h].position.controller.count].value = 100
						)
					)
				)
				--marcamos la casilla keepInitialOffset
				helperListIkSpline[h].position.controller["Position_Constraint"].controller.relative = on
			)		
		)
		
		------------------------------------------------------------------------------
		--añade la funcion dinamycRotation para el sistema de la opcion selectedBones
		--en la opcion del macro.
		------------------------------------------------------------------------------
		fn applyDynamicRotation boneArray pointsSubControlArray pointsUpNode =
		(
			pointScripts = undefined
			
			--ponemos la condicion si existe el point en la escena no cremoas el point
			--y añadimos el script en un availabe y si existe lo creamos
			if bonesSelected.count > 0 then -- Selection Comprovation
			(
				finalName = bonesSelected[1].name + "pointScripts"
				cont = 0
				flag = false
				
				if lb.nc.ncOK bonesSelected[1].name then
				(
					objNameArray = filterString bonesSelected[1].name "_"
					finalName = objNameArray[1] + "_" + objNameArray[2]  + "_rig_m_scripts_x_fh"
			
				--buscamos un point script por el nombre del personaje

					for x in objects do -- Find Point in Scene
					(
						if (findString x.name ("chr_" + objNameArray[2] + "_rig_m_scripts_x_fh")) != undefined then
						(
							flag = true
							pointScripts = x
						)
					)
				
				)
				
				if not flag then
				(
					--crea el point de los scripts
					pointScripts = Point pos:[0,0,0]
					pointScripts.cross = on
					pointScripts.Box = off
					
					pointScripts.pos.controller = position_list ()
					pointScripts.pos.controller.delete 1
					
					objNameArray = filterString bonesSelected[1].name "_"

					-- Change name of point
			-- 					finalName = objNameArray[1] + "_" + objNameArray[2]  + "_rig_m_scripts_x_x"
					
					pointScripts.name = finalName
					-- Adjust Point
					pointScripts.size = 20
					-- Change Color
					pointScripts.wirecolor = color 255 255 0 -- Yellow
				)
			)	
	
			-- 			lb.controller.freezeTransform pointScript #all
			pointScripts.pos.controller.Available.controller = Position_Script ()
			
			--comprobamos si cumple el Nc, si es asi renombramos el controlador con la parte que nos interesa de la pieza
			--sino ponemos un nombre generico
			if lb.nc.ncOK bonesSelected[1].name then
			(
				boneName = filterString bonesSelected[1].name "_"
				pointScriptsName  = boneName[4] + "_" + boneName[5] + "script"
			)	
			else
				pointScriptsName = "rig_x_script"
				
			posController = pointScripts.pos.controller
				
			pointScripts.pos.controller.setName pointScripts.pos.controller.count pointScriptsName

			--variable donde guardamos la expresion
			expression = "" 
			
			expression += "boneArray = #(" -- vamos añadiendo una parte de la expresion
			
			for i = 1 to boneArray.count do
			(
			-- creamos las variables y añadimos los bones como nodos en el positionScript	
				numberString = (if i < 10 then  "0" else "") + (i as string) -- para añadir un 0 si es menor que diez en el string 
				pointScripts.position.controller[pointScriptsName].AddNode ("boneRot" + numberString) boneArray[i]
				
			-- añadimos el array de huesos a la expresion
				expression+=("boneRot" + (if i < 10 then  "0" else "") + (i as string) + (if i < boneArray.count then  "," else ""))
			)
			expression +=")\n"
						
			-- creamos la expresion y le pasamos los points que se guardaran en el array
			expression += "pointsArray = #("
			
			for i=1 to pointsSubControlArray.count do
			(
				pointScripts.position.controller[pointScriptsName].AddNode ("point" + (if i < 10 then  "0" else "") + (i as string)) pointsSubControlArray[i]
				expression+=("point" + (if i < 10 then  "0" else "") + (i as string) + (if i < pointsSubControlArray.count then  "," else ""))	
			)
			expression +=")\n"

			
			--creamos array de points, de rotacion que controlan el upnode del lookAt de los huesos 
			expression +="\npointsUpNode = #("
			
			for i=1 to pointsUpNode.count do
			(
				pointScripts.position.controller[pointScriptsName].AddNode ("pointUpnode" + (if i < 10 then  "0" else "") + (i as string)) pointsUpNode[i]
				expression+=("pointUpnode" + (if i < 10 then  "0" else "") + (i as string) + (if i < pointsUpNode.count then  "," else ""))	
			)

			expression +=")\n"
			
			--calculamos la maxima distancia haciendo la suma de las distancias de los points,
			expression +="\nmaxDistance = 0.0\n" -- establecemos la variable de maxima distancia de huesos poniendola por defecto a 0
			
			expression += "\nfor i= 1 to (boneArray.count - 1) do"
			expression += "\n(\n"
			expression +=		"\tmaxDistance += boneArray[i].length\n"
			expression += "\n)\n"


			
			--establecemos un rango de influencia para la rotacion de huesos
			expression +="searchRadius = maxDistance/(boneArray.count/2)\n"
			
			expression +="cont = 2\n"
			
			--bucle para recorrer los huesos del array y trabajar con ellos
			expression +="\nfor b in boneArray do\n(\n"

			expression +=		"\tfinalValue = 0\n"
			expression +=		"\n\tfor  i = 1 to pointsArray.count do\n"
			
			--calculamos la distancia que hay de cada huesos a cada point ( calculo de multiples operacion muy pesado )
			expression +=		"\t(\n"
			expression +=			"\t\tdistancesAux = distance b.center pointsArray[i].pos\n"	
			expression +=			"\t\tif distancesAux <= searchRadius then\n	"
			
			--calculamos el tanto por ciento que deberemos de pasar a cada huesos para su rotacion aditiva y se lo pasamos
			expression +=			"\t(\n"
			expression +=				"\t\t\tpercentPartial = (1 - (distancesAux / searchRadius))\n"
			expression +=				"\t\t\tfinalValue += (pointsArray[i].rotation.controller[\"Zero_Euler_XYZ\"][\"X_Rotation\"].controller.value * percentPartial)\n"
			expression +=			"\t\t)\n"
			
			expression +=		"\t)\n\n"
			
			--le añadimos la rotacion del padre para contrarestar la doble transofrmacion
			-- 			expression +=		"\tfor i=1 to parentRot.count do\n"
			-- 			expression +=		"\t(\n"
			-- 			expression +=			"\t\tfinalValue += -parentRot[i]\n"
			-- 			expression +=		"\t)\n\n"

			expression += "if cont <= boneArray.count then\n"
			expression +=		"\tpointsUpNode[cont].controller[\"Rotation\"][\"Zero_Euler_XYZ\"][\"X_Rotation\"].controller.value = finalValue\n\n"
			-- 			expression +=		"\tappend parentRot finalValue\n"
			expression +=	"cont += 1\n"
			expression +=")\n\n"


			expression += "[ 0, 0, 0 ]"
			

			print pointScripts.pos.controller.count
			
				pointScripts.position.controller[pointScriptsName].SetExpression expression
		)			
		

		------------------------------------------------------------------------------
		--añade la funcion dinamycRotation para el sistema de twist en la opcion refine Bone
		--del macro
		------------------------------------------------------------------------------
		fn applyDynamicRotationRefine boneArray splineIkHelpers =
		(
			-- creamos array para la seleccion activa
			--boneArray = deepcopy (selection as array)
			
			-- creamos point donde almacenar el scriptController
			pointScript = Point pos:[0,20,0] wirecolor:[255,255,0] cross:true box:false size:10
			
			--freezeamos el point y le añadimos el position script y la variables constante
			lb.controller.freezeTransform pointScript #all
			pointScript.pos.controller.Available.controller = Position_Script ()
			pointScript.position.controller["Position_Script"].AddConstant "SearchRange" 3
			
			--variable donde guardamos la expresion
			expression = "" 

			expression += "boneArray = #(" -- vamos añadiendo una parte de la expresion
			
			for i = 1 to boneArray.count do
			(
			--instanciamos los controladores de rotation x para manipular los huesos

				boneArray[i].controller["Preferred_Rotation_X"].controller = boneArray[i].controller["FK_Sub_Control"]["Rotation"]["Zero_Euler_XYZ"]["X_Rotation"].controller	
				
			-- creamos las variables y añadimos los bones como nodos en el positionScript	
				numberString = (if i < 10 then  "0" else "") + (i as string) -- para añadir un 0 si es menor que diez en el string 
				pointScript.position.controller["Position_Script"].AddNode ("boneRot" + numberString) boneArray[i]
				
			-- añadimos el array de huesos a la expresion
				expression+=("boneRot" + (if i < 10 then  "0" else "") + (i as string) + (if i < boneArray.count then  "," else ""))
			)
			expression +=")\n"
			
			-- creamos la variable donde guardaremos los helpers de la spline ik
			--splineIkHelpers = $chr_aaa_rig_x_spineLine_x_a.modifiers["Spline_IK_Control"].helper_list
			
			-- creamos la expresion y le pasamos los points que se guardaran en el array
			expression += "pointsArray = #("
			
			for i=1 to splineIkHelpers.count do
			(
				pointScript.position.controller["Position_Script"].AddNode ("point" + (if i < 10 then  "0" else "") + (i as string)) splineIkHelpers[i]
				expression+=("point" + (if i < 10 then  "0" else "") + (i as string) + (if i < splineIkHelpers.count then  "," else ""))	
			)
			expression +=")\n"
			
			--creamos array de rotacion de huesos padre para restar la doble transformacion que se provoca por la jerarquia
			expression +="\nparentRot = #()\n"
			
			expression +="\nmaxDistance = 0.0\n" -- establecemos la variable de maxima distancia de huesos poniendola por defecto a 0
			
			--calculamos la maxima distancia haciendo la suma de las distancias de los points,
			expression+="maxDistance = ("

			for i=1 to (splineIkHelpers.count - 1) do
			(
				expression+= ("(distance point" + (if i < 10 then  "0" else "") + (i as string) +".pos "+ "point" +(if i < 10 then  "0" else "") + ((i+1) as string) + ".pos)" + (if i < (splineIkHelpers.count - 1) then " + " else ""))
			)
			expression +=")\n"
			
			--establecemos un rango de influencia para la rotacion de huesos
			expression +="searchRadius = maxDistance/searchRange\n"
			
			--bucle para recorrer los huesos del array y trabajar con ellos
			expression +="\nfor b in boneArray do\n(\n"

			expression +=		"\tfinalValue = 0\n"
			expression +=		"\n\tfor  i = 1 to pointsArray.count do\n"
			
			--calculamos la distancia que hay de cada huesos a cada point ( calculo de multiples operacion muy pesado )
			expression +=		"\t(\n"
			expression +=			"\t\tdistancesAux = distance b.center pointsArray[i].pos\n"	
			expression +=			"\t\tif distancesAux <= searchRadius then\n	"
			
			--calculamos el tanto por ciento que deberemos de pasar a cada huesos para su rotacion aditiva y se lo pasamos
			expression +=			"\t(\n"
			expression +=				"\t\t\tpercentPartial = (1 - (distancesAux / searchRadius))\n"
			expression +=				"\t\t\tfinalValue += (pointsArray[i].rotation.controller[\"Zero_Euler_XYZ\"][\"X_Rotation\"].controller.value * percentPartial)\n"
			expression +=			"\t\t)\n"
			
			expression +=		"\t)\n\n"
			
			--le añadimos la rotacion del padre para contrarestar la doble transofrmacion
			expression +=		"\tfor i=1 to parentRot.count do\n"
			expression +=		"\t(\n"
			expression +=			"\t\tfinalValue += -parentRot[i]\n"
			expression +=		"\t)\n\n"
			expression +=		"\tb.controller[\"FK_Sub_Control\"][\"Rotation\"][\"Zero_Euler_XYZ\"][\"X_Rotation\"].controller.value = finalValue\n\n"
			expression +=		"\tappend parentRot finalValue\n"
			expression +=")\n\n"


			expression += "[ 0, 0, 0 ]"
			
			pointScript.position.controller["Position_Script"].SetExpression expression		
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
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		-- AutoStrech activation
		on chkAutoStrech changed chkAutoStrechState do
		(
			if chkAutoStrech.checked == true then
				autoStrech = true
			else
				autoStrech = false
		)
	
		------------------------------------------------------------------------------			
 		on chkDynamicRotation changed state do
		(
			if chkDynamicRotation.checked then
				rdoSubControlsType.enabled = true 
			else
				rdoSubControlsType.enabled = false 
		)
		
		------------------------------------------------------------------------------	
		on btnCreate pressed do
		(
			max create mode
			--cambiamos el tipo de seleccion
			if rdoCreationType.state == 1 then
			(	
				boneSelected = getCurrentSelection ()
					-- Bone selection comprovation
					if boneSelected.count != 0 then
						boneSelected = getCurrentSelection ()
					else
						lb.message.show "Select Bones First" type:#message pos:undefined size:[300,75] modal:true
				
				boneTwist = boneRefine boneSelected spnNumBones.value spnSubControlsNumber.value
					
					if chkDynamicRotation.checked then
					(			
						applyDynamicRotationRefine boneTwist.refinedBones splineReturn.helperList

					)
			)		
			else
			(
				bonesSelected = getCurrentSelection ()
				isFrozenFlag = true
				
				if bonesSelected.count >1 then
				(	
					for i = 1 to bonesSelected.count do
					(
						if not lb.controller.isTransformFrozen bonesSelected[i] #rotation or not lb.controller.isTransformFrozen bonesSelected[i] #position then
							isFrozenFlag= false	
					)
						
					
					if bonesSelected.count != 0 and isFrozenFlag then
					(
			-- 						if spnSubControlsNumber.value < bonesSelected.count then
			-- 						(							
							ss = createSplineToSelection bonesSelected 
							pointsIkSpline = createPointsSelectedBones bonesSelected
							ikSplineSelectedOption = selectedBonesIkspline pointsIkSpline
							
							ikSplineSelectedOption.transform.controller.pickShape = ss
							
							ikSpline = addModifierIkSplineAndCreateHelpers ss pointsIkSpline bonesSelected
						
							pointsSubControlArray = createSubControlsSelectBones ss bonesSelected spnSubControlsNumber.value
							

							if chkDynamicRotation.checked then
							(	
								if rdoSubControlsType.state == 1 then
									instanceSubControlsToControlsIkSpline pointsIkSpline[1] ikSplineSelectedOption ss splineSelectedOptionHelperList pointsSubControlArray
								else
									instanceSubControlsPositionConstraint pointsIkSpline[1] ikSplineSelectedOption ss splineSelectedOptionHelperList pointsSubControlArray

								applyDynamicRotation bonesSelected pointsSubControlArray ikSpline
							)
	
			-- 						)
			-- 						else
							--lb.message.show "Number of subControls must be less than number of bones" type:#message pos:undefined size:[300,75] modal:true
					)
					else
					
						if bonesSelected.count == 0 then 
							lb.message.show "Select Bones First" type:#message pos:undefined size:[300,75] modal:true
						else
							lb.message.show "Bones Must Be Frozen" type:#message pos:undefined size:[300,75] modal:true						
				)	
				else
					if bonesSelected.count <=2 then
					lb.message.show "More Bones Must Be Selected " type:#message pos:undefined size:[300,75] modal:true	
			)	
		)
			
		------------------------------------------------------------------------------	
		on rdoCreationType changed state do
		(
			if state == 1 then
				spnNumBones.enabled = true
			else
				spnNumBones.enabled = false
		)

		on btnClose pressed do
		(
			saveSettings()
			DestroyDialog rollSplineIkSolutions --elimina la ventana
			rollOpen = false
			updateToolbarButtons()
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
	--@struct: splineIkSolutions | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_splineIkSolutions
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Spline Ik Solutions",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_tsplineIkSolutions
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_splineIkSolutions() --crea la herramienta
)