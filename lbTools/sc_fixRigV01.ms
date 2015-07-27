------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fixRigV01
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Script plantilla",	--@var: description | Descripcion del script.
		
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
		--@fn: undefined | fixRigV01 | Ejecuta el script.
		------------------------------------------------	
		fn fixRigV01 =
		(
			-- Hueso de cabeza.
			_headAndNeck = (lb.rig.getAnimNode lb.nc.NC_ANIM_head) + (lb.rig.getAnimNode lb.nc.NC_ANIM_neck)
			
			-- Brazos
			_arms = (lb.rig.getAnimNode lb.nc.NC_ANIM_upperarm)
			_foreArms = (lb.rig.getAnimNode lb.nc.NC_ANIM_forearm)
			_hands = (lb.rig.getAnimNode lb.nc.NC_ANIM_hand)
			_handsIk = (lb.rig.getAnimNode lb.nc.NC_ANIM_handIK)
			
			_armsScripts = (lb.rig.getAnimNode "armSolution-hlp-scripts")

			-- Pies
			_legs = (lb.rig.getAnimNode lb.nc.NC_ANIM_thigh)
			_calfs = (lb.rig.getAnimNode lb.nc.NC_ANIM_calf)
			_toeCap = (lb.rig.getAnimNode lb.nc.NC_ANIM_toeCap)
			_foots = (lb.rig.getAnimNode lb.nc.NC_ANIM_foot) 
			_footsIk = (lb.rig.getAnimNode lb.nc.NC_ANIM_footStep) 
			_legsScripts = (lb.rig.getAnimNode "legSolution-hlp-scripts")
			_pivotInside = (lb.rig.getAnimNode lb.nc.NC_ANIM_pivotInside)
			_pivotOutside = (lb.rig.getAnimNode lb.nc.NC_ANIM_pivotOutside)
			_pivotHeel = (lb.rig.getAnimNode lb.nc.NC_ANIM_pivotFootHeel)
			
			
			-- Añadida excepción por si encuentra el script mal nombrado.
			if _legsScripts.count == 0 then
			(
				_legsScripts = (lb.rig.getAnimNode"logSolution-hlp-scripts")	
				
				for o in _legsScripts do
					o.name = subStituteString o.name "logSolution" "legSolution"
			)
			
			------------------------------------------------	
			-- Actualización de controles de footRoll, bank, con nuevos ejes.
			------------------------------------------------
			-- Pivote Interior		 
			for i = 1 to _pivotInside.count do
			(
				-- Punta/Talón Giro atras
				_floatExpr = _pivotInside[i].rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller
				_floatExpr.AddScalarTarget "footBoneRot" _foots[i].rotation.controller[#Zero_IK_Controller][#X_Rotation].controller
			)				
				
			-- Pivote Lateral Interior
			for i = 1 to _pivotOutside.count do
			(
				_floatExpr = _pivotOutside[i].rotation.controller[#Zero_Euler_XYZ][#X_Rotation].controller
				_floatExpr.AddScalarTarget "footBoneRot" _foots[i].rotation.controller[#Zero_IK_Controller][#X_Rotation].controller
			)
				
			-- Pivote Lateral Interior
			for i = 1 to _pivotHeel.count do
			(
				_floatExpr = _pivotHeel[i].rotation.controller[#Zero_Euler_XYZ][#Y_Rotation].controller
				_floatExpr.AddScalarTarget "footBoneRot" _foots[i].rotation.controller[#Zero_IK_Controller][#Y_Rotation].controller
			)
			
				
			-- Root
			_root = (lb.rig.getAnimNode lb.nc.NC_ANIM_root)[1]
				
			------------------------------------------------	
			-- Ordenación de ejes
			------------------------------------------------
			for o in _headAndNeck do o.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 3
				
			for o in _arms do o.rotation.controller[#Zero_FK_Controller].controller.axisOrder = 2
			
			for o in _hands do o.rotation.controller[#Zero_FK_Controller].controller.axisOrder = 3
				
			for o in _handsIk do o.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 3
			
			for o in _foots do o.rotation.controller[#Zero_FK_Controller].controller.axisOrder = 1 		
				
			for o in _footsIk do o.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 1
				
			_root.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 1
			
			------------------------------------------------	
			-- Ordenación de controladores
			------------------------------------------------
			-- Reordenamos los controladores para evitar que el bloqueo del gimbal por el OC del controlador IK.
			for o in (_arms + _foreArms + _hands) do
			(
				if o.rotation.controller[3].name == "Zero_IK_Controller" then
				(
					_floatBckp = o.rotation.controller.weights[4].controller
					
					o.rotation.controller.cut 4
					o.rotation.controller.paste 3
					
					o.rotation.controller.weights[3].controller = _floatBckp
				)
			)
			
			for o in (_legs + _calfs + _foots + _toeCap) do
			(
				if o.rotation.controller[3].name == "Zero_IK_Controller" then
				(
					_floatBckp = o.rotation.controller.weights[4].controller
					
					o.rotation.controller.cut 4
					o.rotation.controller.paste 3
					
					o.rotation.controller.weights[3].controller = _floatBckp
				)
			)
			
			-- Actualizamos el script
			for o in _armsScripts do
			(				
				-- Añadimos el texto que va ir dentro del script
				(
					o.controller.position.controller[3].script =
					"if fkik.value > 0 and upperarm.rotation.controller.active != 4 then\n" +
 					
					"(\n" +
					
					"	-- Controlador activo para posición y rotación en Ik\n" +

					"	upperarm.rotation.controller.active = 4\n" +
					"	forearm.rotation.controller.active = 4\n" +
					"	hand.rotation.controller.active = 4\n" +
					
					"\n" +
					
					"	-- Control de Locks para Ik\n" +
					"	setTransformLockFlags forearm #{1..6,8..9}\n" +
					"	setTransformLockFlags upperarm #{1..6,8..9}\n\n" +
					"	setTransformLockFlags hand #{4..9}\n" +
					
					"\n" +
					
					"	-- Cambio de nombre del boton Fk-Ik\n" +
					
					")\n" +
					"\n" +
					
					"if fkik.value == 0 and (upperarm.rotation.controller.active != 3) then\n" +
					
					"(\n" +
					
					"	-- Controlador activo para posición y rotación en Fk\n" +

					"	upperarm.rotation.controller.active = 3\n" +
					"	forearm.rotation.controller.active = 3\n" +
					"	hand.rotation.controller.active = 3\n" +
					
					"\n" +
					
					"	-- Control de Locks para Fk\n" +
					"	setTransformLockFlags forearm #{1..5,8..9}\n" +
					"	setTransformLockFlags upperarm #{1..3,8..9}\n" +
					"	setTransformLockFlags hand #{1..3,7..9}\n" +
					
					"\n" +
					"	-- Cambio de nombre del boton Ik-Fk\n" +
					")\n" +
					"\n" +
					"[ 0, 0, 0 ]"	
				)-- script texto		
			)
			
			for o in _legsScripts do
			(
				-- Añadimos el texto que va ir dentro del script
				(
					o.controller.position.controller[3].script = --"handPos = hand.position.controller\n" +
					--"handRot = hand.rotation.controller\n" +
					--"\n" +
					"if fkik.value > 0 and thigh.rotation.controller.active != 4 then\n" +
					
					"(\n" +
					
					"	-- Controlador activo para posición y rotación en Ik\n" +
					"	thigh.rotation.controller.active = 4\n" +
					"	calf.rotation.controller.active = 4\n" +
					"	foot.rotation.controller.active = 4\n" +
					"	instep.rotation.controller.active = 4\n" +
					"	toeCap.rotation.controller.active = 4\n" +
					"	toeCapPivot.rotation.controller.active = 4\n" +
					
					"\n" +
					
					"	-- Control de Locks para Ik\n" +
					"	setTransformLockFlags thigh #{1..6,8..9}\n" +
					"	setTransformLockFlags calf #{1..6,8..9}\n" +
					"	setTransformLockFlags foot #{7..9}\n" +
					"	setTransformLockFlags toeCapPivot #{1..3,7..9}\n" +
					
					"\n" +
					
					"	-- Cambio de nombre del boton Fk-Ik\n" +
					
					")\n" +
					"\n" +
					
					"if fkik.value == 0 and (thigh.rotation.controller.active != 3) then\n" +
					
					"(\n" +
					
					"	-- Controlador activo para posición y rotación en Fk\n" +
					"	thigh.rotation.controller.active = 3\n" +
					"	calf.rotation.controller.active = 3\n" +
					"	foot.rotation.controller.active = 3\n" +
					"	instep.rotation.controller.active = 3\n" +
					"	toeCap.rotation.controller.active = 3\n" +
					
					"\n" +
					
					"	-- Control de Locks para Fk\n" +
					"	setTransformLockFlags calf #{1..5,8..9}\n" +
					"	setTransformLockFlags thigh #{1..3,8..9}\n" +
					"	setTransformLockFlags foot #{1..3,7..9}\n" +
					"	setTransformLockFlags instep #{1..3,7..9}\n" +
					"	setTransformLockFlags toeCap #{1..3,7..9}\n" +
					
					"\n" +
					"PEPE	-- Cambio de nombre del boton Ik-Fk\n" +
					")\n" +
					"\n" +
					"[ 0, 0, 0 ]"	
					
					
				)-- script texto		
			)	
			
			
			------------------------------------------------	
			-- Generaciñon de animtracks.
			------------------------------------------------
			_sepTransform = #(#(#separator, "Separator01", false, "Transform"))
			_sep = #(#(#separator, "Separator01", false, ""))
			_sepLeg = #(#(#separator, "Separator01", false, "Leg_Controls"))
			_sepIk = #(#(#separator, "Separator01", false, "IK_Controls"))
			_sepFk = #(#(#separator, "Separator01", false, "FK_Controls"))
			_sepAutoStrech = #(#(#separator, "Separator01", false, "AutoStrech_IK"))
			
			-- UpperArm
			for o in _headAndNeck do
			(
				--*****************/ANIM/******************** --
				-- Cabeza
				lb.animInfo.setAnimTracks o (_sepTransform + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_Euler_XYZ] #all) + _sep + #(#(o[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
						
				-- Cuello
				lb.animInfo.setAnimTracks o (_sepTransform + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_Euler_XYZ] #all) + _sep + #(#(o[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
			)
				
			-- UpperArm
			for o in _arms do
				lb.animInfo.setAnimTracks o (_sepTransform + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_FK_Controller] #all) + _sep + #(#(o[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
				
			-- ForeArm
			for o in _foreArms do	
				lb.animInfo.setAnimTracks o (_sepTransform + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_FK_Controller] #z )  + _sep + #(#(o[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))		
	
			for o in _hands do		
				lb.animInfo.setAnimTracks o (_sepTransform + _sepIk + (lb.rig.solutions.prepareAnimTracks o.position.controller[#IKoffset_controller] #all) + _sep + _sepFk + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_FK_Controller] #all)) 	
					
			for o in _legs do
				lb.animInfo.setAnimTracks o (_sepTransform + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_FK_Controller] #all) + _sep + #(#(o[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
				
			for o in _calfs do
				lb.animInfo.setAnimTracks o (_sepTransform + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_FK_Controller] #z ) + _sep + #(#(o[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
				
			for o in _foots do
				lb.animInfo.setAnimTracks o (_sepTransform + _sepIk + (lb.rig.solutions.prepareAnimTracks o.position.controller[#Zero_IK_Controller] #all) + _sep + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_IK_Controller] #all) + _sepFk + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_FK_Controller] #all) + _sep) 
				
			for o in _footsIk do
				lb.animInfo.setAnimTracks o (_sepTransform + (lb.rig.solutions.prepareAnimTracks o.position.controller[#Zero_Pos_XYZ] #all) + _sep + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_Euler_XYZ] #all)) 
		
			for o in _toeCap do
				lb.animInfo.setAnimTracks o (_sepTransform + _sepIk + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_IK_Controller] #all) + _sep + _sepFk + (lb.rig.solutions.prepareAnimTracks o.rotation.controller[#Zero_FK_Controller] #all)) 
					
			-- Root
			lb.animInfo.setAnimTracks _root (_sepTransform + (lb.rig.solutions.prepareAnimTracks _root.position.controller[#Zero_Pos_XYZ] #all ) + _sep + (lb.rig.solutions.prepareAnimTracks _root.rotation.controller[#Zero_Euler_XYZ] #all )) 

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
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(		
			this.fixRigV01()
			
			--ejecución del script
			messageBox "Fix Rig V01 executed"
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
			lb.addScript this --añade el script a la libreria principal
		)
		
	)--sc_templateScript
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_fixRigV01() --crea el script
)