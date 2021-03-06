-- (	
-- 	( -- OBJECT SETS ARM
-- 		-- Nodos de arm
-- 		_clavicle = (execute "$'chr_*_anim_*_clavicle_x_d'") as array
-- 		_upperArm = (execute "$'chr_*_anim_*_upperarm_x_d'") as array
-- 		_foreArm = (execute "$'chr_*_anim_*_forearm_x_d'") as array
-- 		_hand = (execute "$'chr_*_anim_*_hand_x_d'") as array
-- 		_fkIkArmSHP = (execute "$'chr_*_anim_*_fkIkArm_x_c'") as array
-- 		_elbowSHP = (execute "$'chr_*_anim_*_elbow_x_c'") as array
-- 		_handSHP = (execute "$'chr_*_anim_*_handCross_x_c'") as array
-- 		_breakElbow = (execute "$'chr_*_anim_*_breakElbow_x_c'") as array
-- 		_fingers = (execute "$'chr_*_anim_*_finger*_x_d'") as array
-- 		
-- 		_tempNodes = (_clavicle + _upperArm + _foreArm + _hand + _fkIkArmSHP + _elbowSHP + _handSHP + _breakElbow + _fingers)
-- 		
-- 		_nodesArmL = #()
-- 		_nodesArmR = #()
-- 		
-- 		for _o in _tempNodes do
-- 		(
-- 			_filterName = filterString _o.name "_"
-- 			
-- 			if _filterName[4] == NC_locationLeft then
-- 			(
-- 				append _nodesArmL _o
-- 			)

-- 			if _filterName[4] == NC_locationRight then
-- 			(
-- 				append _nodesArmR _o
-- 			)
-- 			
-- 			_o.objectSets.names = #()
-- 		)	
-- 		
-- 		-- Montamos el nombre del selectionset de la cabeza-cuello, spine, pelvis, y root.
-- 		_filterName = filterString _nodesArmL[1].name "_"
-- 		_selSetArmName = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] +"_" + _filterName[4] + "_arm"
-- 		
-- 		-- A�adimos las piezas a su selection set correspondiente.
-- 		lb.objectsets.add _nodesArmL _selSetArmName
-- 		
-- 		-- Montamos el nombre del selectionset de la cabeza-cuello, spine, pelvis, y root.
-- 		_filterName = filterString _nodesArmR[1].name "_"
-- 		_selSetArmName = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] +"_" + _filterName[4] + "_arm"
-- 		
-- 		lb.objectsets.add _nodesArmR _selSetArmName	
-- 	)
-- 	
-- 	( -- OBJECT SETS  LEG
-- 		-- Nodos de leg
-- 		_thigh = (execute "$'chr_*_anim_*_thigh_x_d'") as array
-- 		_calf = (execute "$'chr_*_anim_*_calf_x_d'") as array
-- 		_foot = (execute "$'chr_*_anim_*_foot_x_d'") as array
-- 		_toeCap = (execute "$'chr_*_anim_*_toeCap_x_d'") as array
-- 		_toeCapPivot = (execute "$'chr_*_anim_*_toeCapPivot_x_d'") as array
-- 		_fkIkLegSHP = (execute "$'chr_*_anim_*_fkIk_x_c'") as array
-- 		_kneeSHP = (execute "$'chr_*_anim_*_knee_x_c'") as array
-- 		_footStep = (execute "$'chr_*_anim_*_footStep_x_c'") as array
-- 		_breakKnee = (execute "$'chr_*_anim_*_breakKnee_x_c'") as array
-- 		
-- 		_tempNodes = (_thigh + _calf + _foot + _toeCap + _toeCapPivot + _fkIkLegSHP + _kneeSHP + _footStep + _breakKnee)
-- 		
-- 		_nodesLegL = #()
-- 		_nodesLegR = #()
-- 		
-- 		for _o in _tempNodes do
-- 		(
-- 			_filterName = filterString _o.name "_"
-- 			
-- 			if _filterName[4] == NC_locationLeft then
-- 			(
-- 				append _nodesLegL _o
-- 			)

-- 			if _filterName[4] == NC_locationRight then
-- 			(
-- 				append _nodesLegR _o
-- 			)
-- 			
-- 			_o.objectSets.names = #()
-- 		)	
-- 		
-- 		-- Montamos el nombre del selectionset de la cabeza-cuello, spine, pelvis, y root.
-- 		_filterName = filterString _nodesLegL[1].name "_"
-- 		_selSetLegName = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] +"_" + _filterName[4] + "_leg"
-- 		
-- 		-- A�adimos las piezas a su selection set correspondiente.
-- 		lb.objectsets.add _nodesLegL _selSetLegName
-- 		
-- 		-- Montamos el nombre del selectionset de la cabeza-cuello, spine, pelvis, y root.
-- 		_filterName = filterString _nodesLegR[1].name "_"
-- 		_selSetLegName = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] +"_" + _filterName[4] + "_leg"
-- 		
-- 		lb.objectsets.add _nodesLegR _selSetLegName	
-- 		
-- 	)	
-- 	
-- 	( -- OBJECT SETS  SPINE
-- 		-- Nodos de leg
-- 		_pelvis = (execute "$'chr_*_anim_*_pelvis_x_d'") as array
-- 		_root = (execute "$'chr_*_anim_*_root_x_*'") as array
-- 		_neck = (execute "$'chr_*_anim_*_neck_x_d'") as array
-- 		_head = (execute "$'chr_*_anim_*_head_x_d'") as array
		/*_helmet = (execute "$'chr_*_anim_*_helmet-bon_x_d'") as array*/
-- 		_spine = (execute "$'chr_*_anim_*_spine*_x_d'") as array
-- 		_base = (execute "$'chr_*_anim_*_base_x_c'") as array
-- 		
-- 		_tempNodes = (_pelvis + _root + _neck + _head /*+ _helmet*/+ _spine + _base)
-- 		
-- 		_nodesSpine = #()
-- 		
-- 		for _o in _tempNodes do
-- 		(
-- 			_o.objectSets.names = #()
-- 		)	
-- 		
-- 		-- Montamos el nombre del selectionset de la cabeza-cuello, spine, pelvis, y root.
-- 		_filterName = filterString _head[1].name "_"
-- 		_selSetHead = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] +"_" + _filterName[4] + "_" + (_filterName[5] + "-neck")
-- 		
-- 		_filterName = filterString _spine[1].name "_"
-- 		_selSetSpine = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] + "_" + _filterName[4] + "_" + _filterName[5]
-- 		
-- 		_filterName = filterString _pelvis[1].name "_"
-- 		_selSetPelvis = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] + "_" + _filterName[4] + "_" + _filterName[5]
-- 		
-- 		_filterName = filterString _root[1].name "_"
-- 		_selSetRoot = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] + "_" + _filterName[4] + "_" + _filterName[5]
-- 		
-- 		_filterName = filterString _base[1].name "_"
-- 		_selSetBase = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] + "_" + _filterName[4] + "_" + _filterName[5]		
-- 		
-- 		-- A�adimos las piezas a su selection set correspondiente.
-- 		lb.objectsets.add (_head + _neck/* + _helmet*/) _selSetHead
-- 		lb.objectsets.add _spine _selSetSpine
-- 		lb.objectsets.add _pelvis _selSetPelvis
-- 		lb.objectsets.add _root _selSetRoot
-- 		lb.objectsets.add _base _selSetBase		
-- 	)

-- )