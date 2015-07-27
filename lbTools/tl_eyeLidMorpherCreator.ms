------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta eyeLidMorpherCreator.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta eyeLidMorpherCreator.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Eye Lid Morpher Creator"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 170		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 130	--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		checkbutton chkCreateGuideSpline "Create Guide Spline" pos:[10,10] width:150 height:25 tooltip:"Create Guide Spline" checked:false
		button btnSetPoints "Set Points Inital State" pos:[10,50] width:150 height:25 enabled:true
		button btnCreateMorphs "Create Morphs" pos:[10,90] width:150 height:25 enabled:false

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
		--@fn: undefined | updateUI | Actualiza el estado de la interfaz.
		------------------------------------------------
		fn updateUI = 
		(
			_checked = (isValidNode parent.splineEyeLid and parent.splinePoints.count == 8)

			chkCreateGuideSpline.checked = _checked
			btnCreateMorphs.enabled = _checked
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

			-----------------------  Callbacks  -----------------------
			callbacks.addscript #filePostOpenProcess "lb.eyeLidMorpherCreator.callbackExecution()" id:_id
			callbacks.addscript #filePostMerge "lb.eyeLidMorpherCreator.callbackExecution()" id:_id
			callbacks.addscript #systemPostReset "lb.eyeLidMorpherCreator.callbackExecution()" id:_id			
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

		on chkCreateGuideSpline changed state do
		(
			if state then parent.createEyeLidSystem()
			else parent.removeEyeLidSystem()	

			updateUI()		
		)

		on btnCreateMorphs pressed do
		(	
			if parent.searchEyeLidSystemInScene() then
			(
				_answer = lb.message.show "Morphs exist in scene. Do you want to delete them and create new morphs ?" type:#query pos:undefined size:[300,75] modal:true

				if _answer then 
				(
					--Borramos nodos
					delete parent.morphsHZ
					delete parent.morphsFR
					delete parent.morphsDWUP
					delete parent.morphsHZinv
					delete parent.morphsFRinv
					delete parent.morphsDWUPinv
					delete parent.eyeLidText
					delete parent.eyeLidRectangle

					--Borramos arrays
					parent.morphsHZ = #()
					parent.morphsFR = #()
					parent.morphsDWUP = #()
					parent.morphsHZinv = #()
					parent.morphsFRinv = #()
					parent.morphsDWUPinv = #()
					parent.eyeLidRectangle = undefined
					parent.eyeLidText = undefined

					parent.createMorphs()					
				)
			)
			else
			(
				parent.createMorphs()
			)
		)

		on btnSetPoints pressed do
		(
			lb.controller.freezeTransform parent.splinePoints #all
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
			parent.searchEyeLidSystemInScene()
			lb.eyeLidMorpherCreator.rollMain.updateUI()

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
	--@struct: eyeLidMorpherCreator | Contiene la herramienta eyeLidMorpherCreator.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_eyeLidMorpherCreator
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Eye Lid Morpher Creator",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		morphsFR = #(),
		morphsHZ = #(),
		morphsDWUP = #(),

		morphsFRinv = #(),
		morphsHZinv = #(),
		morphsDWUPinv = #(),

		splineEyeLid = undefined,
		splinePoints = #(),	
		splineEyeLidLayer = undefined,

		eyeLidrectangle = undefined,
		eyeLidtext = undefined,
		skinPoint = undefined,

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

		fn morphMirror otherMesh originalMesh =
		(
			_objTargetMirror = undefined

			_objMorphMirror = copy originalMesh pos:[0,0,0]
			_objTargetOriginal = otherMesh
			_objTargetMirror = copy originalMesh pos:[0,0,0]

			addModifier _objMorphMirror (Morpher ())
			_objMorphMirror.modifiers[#Morpher].Autoload_of_targets = 1
			WM3_MC_BuildFromNode _objMorphMirror.morpher 1 _objTargetOriginal
			scale _objMorphMirror [-1,1,1]

			addModifier _objTargetMirror (Skin_Wrap ())
			_objTargetMirror.modifiers[#Skin_Wrap].falloff = 0.001
			_objTargetMirror.modifiers[#Skin_Wrap].engine = 0
			_objTargetMirror.modifiers[#Skin_Wrap].meshList [1] = _objMorphMirror		
			completeRedraw()			

			WM3_MC_SetValue _objMorphMirror.modifiers[#morpher] 1 100.00
		
			convertToPoly _objTargetMirror
			delete _objMorphMirror

			_objTargetMirror	
		),

		fn createMorph morphName morphIndex originalMesh splinePoint morphPos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1 =
		(
			
 			splinePoint.position.controller[2].controller[moveXYZ].value -= movePointValue 
 			_newHead = undefined
 			_newHead = snapShot originalMesh  
 			convertToPoly _newHead                               
 			_newHead.wirecolor = color 138 8 110
 			_newHead.name = morphName
 			splinePoint.position.controller[2].controller[moveXYZ].value += movePointValue 

 			_newHeadInv = this.morphMirror _newHead originalMesh
			_newHeadInv.wirecolor = color 138 8 110
			_newHeadInv.name = substituteString morphName "_l_" "_r_"

 			_newHead.pos = morphPos
 			morphPos[1] = -morphPos[1]
 			_newHeadInv.pos = morphPos

 			case arrayToSaveIndex of
 			(
 				1: 
 				(
 					this.morphsHZ[morphIndex] = _newHead
 					this.morphsHZinv[morphIndex] = _newHeadInv
 				)
 				2: 
 				(
 					this.morphsFR[morphIndex] = _newHead
 					this.morphsFRinv[morphIndex] = _newHeadInv
 				)
 				3: 
 				(
 					this.morphsDWUP[morphIndex] = _newHead
 					this.morphsDWUPinv[morphIndex] = _newHeadInv
 				)
 			)
		),

		------------------------------------------------
		--@fn: undefined | createMorphs | Utilizamos la función para crear los morphs.
		------------------------------------------------
		fn createMorphs =
		(
			this.eyeLidRectangle = Rectangle length:437 width:576 cornerRadius:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,370]) isSelected:on()
			this.eyeLidRectangle.name = "eyeLidRectangle"
			this.eyeLidRectangle.wirecolor = green
			this.splineEyeLidLayer.addNode this.eyeLidRectangle

			this.eyeLidText = text size:20 kerning:0 leading:0 transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,370]) isSelected:on
			this.eyeLidText.text = ("EyeLids Parts")
			this.eyeLidText.name = "eyeLidText"
			this.eyeLidText.wirecolor = green
			deselect this.eyeLidText
			this.splineEyeLidLayer.addNode this.eyeLidText

			--Buscamos en la escena la cabeza.
			_headToMorph = undefined										
			for obj in objects where (matchPattern obj.name pattern:"chr_*_mesh_x_head_*_*") do _headToMorph = obj

			if _headToMorph != undefined then 
			(
				_prefix = (filterString _headToMorph.name "_")[1] + "_" + (filterString _headToMorph.name "_")[2]
				
				for i=1 to 8 do
				(
				 	case this.splinePoints[i].name of
				 	(
				 		"l_eld_sideExt"	:
				 		(
				 			_pos = [250, 0, 120]
				 			this.createMorph (_prefix + "_morph_l_eld-sideExt-hz-r_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1 
	 			
				 			------------------------------

				 			_pos = [250, 0, 280]
				 			this.createMorph (_prefix + "_morph_l_eld-sideExt-hz-fr_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:2 movePointValue:1 arrayToSaveIndex:2 

							--------------------------------

				 			_pos = [250, 0, 430]
				 			this.createMorph (_prefix + "_morph_l_eld-sideExt-vt-up_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:3 movePointValue:-1 arrayToSaveIndex:3 
				 		)

						"l_eld_upperExt":
						(
							_pos = [205, 0, 150]
				 			this.createMorph (_prefix + "_morph_l_eld-upperExt-hz-r_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1

						 	------------------------------

						 	_pos = [205, 0, 310]
				 			this.createMorph (_prefix + "_morph_l_eld-upperExt-hz-fr_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:2 movePointValue:1 arrayToSaveIndex:2

						 	------------------------------

				 			_pos = [205, 0, 466]
				 			this.createMorph (_prefix + "_morph_l_eld-upperExt-vt-dw_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:3 movePointValue:1 arrayToSaveIndex:3
						) 

						"l_eld_upperMid": 
						(
							_pos = [165, 0, 150]
				 			this.createMorph (_prefix + "_morph_l_eld-upperMid-hz-r_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1

							------------------------------

						 	_pos = [165, 0, 310]
				 			this.createMorph (_prefix + "_morph_l_eld-upperMid-hz-fr_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:2 movePointValue:1 arrayToSaveIndex:2

						 	------------------------------

				 			_pos = [165, 0, 466]
				 			this.createMorph (_prefix + "_morph_l_eld-upperMid-vt-dw_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:3 movePointValue:1 arrayToSaveIndex:3
						)

						"l_eld_upperInt": 
						(
							_pos = [122, 0, 150]
				 			this.createMorph (_prefix + "_morph_l_eld-upperInt-hz-r_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1

						 	------------------------------

						 	_pos = [122, 0, 310]
				 			this.createMorph (_prefix + "_morph_l_eld-upperInt-hz-fr_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:2 movePointValue:1 arrayToSaveIndex:2

						 	------------------------------

				 			_pos = [122, 0, 466]
				 			this.createMorph (_prefix + "_morph_l_eld-upperInt-vt-dw_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:3 movePointValue:1 arrayToSaveIndex:3			 			
						)

						"l_eld_sideInt"	: 
						(
							_pos = [83, 0, 120]
				 			this.createMorph (_prefix + "_morph_l_eld-sideInt-hz-r_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1 
	 			
				 			------------------------------

				 			_pos = [83, 0, 280]
				 			this.createMorph (_prefix + "_morph_l_eld-sideInt-hz-fr_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:2 movePointValue:1 arrayToSaveIndex:2

							--------------------------------

				 			_pos = [83, 0, 430]
				 			this.createMorph (_prefix + "_morph_l_eld-sideInt-vt-up_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:3 movePointValue:-1 arrayToSaveIndex:3
						)

						"l_eld_lowerInt": 
						(
							_pos = [122, 0, 87]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerInt-hz-r_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1

						 	------------------------------

						 	_pos = [122, 0, 250]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerInt-hz-fr_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:2 movePointValue:1 arrayToSaveIndex:2

						 	------------------------------

				 			_pos = [122, 0, 400]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerInt-vt-up_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:3 movePointValue:-1 arrayToSaveIndex:3 	
						)

						"l_eld_lowerMid": 
						(
							_pos = [165, 0, 87]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerMid-hz-r_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1

							------------------------------

						 	_pos = [165, 0, 250]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerMid-hz-fr_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:2 movePointValue:1 arrayToSaveIndex:2

						 	------------------------------

				 			_pos = [165, 0, 400]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerMid-vt-up_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:3 movePointValue:-1 arrayToSaveIndex:3
						)

						"l_eld_lowerExt": 
						(
							_pos = [205, 0, 87]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerExt-hz-r_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:1 movePointValue:1 arrayToSaveIndex:1

						 	------------------------------

						 	_pos = [205, 0, 250]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerExt-hz-fr_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:2 movePointValue:1 arrayToSaveIndex:2

						 	------------------------------

				 			_pos = [205, 0, 400]
				 			this.createMorph (_prefix + "_morph_l_eld-lowerExt-vt-up_x_x") i _headToMorph this.splinePoints[i] _pos moveXYZ:3 movePointValue:-1 arrayToSaveIndex:3
						)
					)--case
				)--for
			)
		),

		------------------------------------------------
		--@fn: undefined | callbackExecution | Utilizamos la función para actualizar el estado de la UI a traves de los callbacks.
		------------------------------------------------
		fn callbackExecution =
		(
			lb.eyeLidMorpherCreator.searchEyeLidSystemInScene()
			lb.eyeLidMorpherCreator.rollMain.updateUI()
		),

		------------------------------------------------
		--@fn: undefined | searchEyeLidSystemInScene | Utilizamos la función para saber si existe la spline, los points y la capa que los contiene.
		------------------------------------------------
		fn searchEyeLidSystemInScene = 
		(
			this.splineEyeLidLayer = lb.layer.getLayerbyName "_auxObj-eyeLidMorpherCreator_"
			if this.splineEyeLidLayer != undefined then
			(
				_nodes = lb.layer.getLayerNodes this.splineEyeLidLayer
				for n in _nodes do
				(
				 	case n.name of
				 	(
				 		"eyeLidsMorphShape" : this.splineEyeLid = n
				 		"l_eld_sideExt"		: this.splinePoints[1] = n
						"l_eld_upperExt"	: this.splinePoints[2] = n
						"l_eld_upperMid"	: this.splinePoints[3] = n
						"l_eld_upperInt"	: this.splinePoints[4] = n
						"l_eld_sideInt"		: this.splinePoints[5] = n
						"l_eld_lowerInt"	: this.splinePoints[6] = n
						"l_eld_lowerMid"	: this.splinePoints[7] = n
						"l_eld_lowerExt"	: this.splinePoints[8] = n
						"eyeLidSkinPoint"	: this.skinPoint = n 
						"eyeLidText"		: this.eyeLidText = n
						"eyeLidRectangle"	: this.eyeLidRectangle = n
					)--case

					if (matchPattern n.name pattern:"chr_*_morph_l_eld-sideExt-hz-r_*_*") then (this.morphsHZ[1] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-sideExt-hz-fr_*_*") then (this.morphsFR[1] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-sideExt-vt-up_*_*") then (this.morphsDWUP[1] = n)

					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperExt-hz-r_*_*") then (this.morphsHZ[2] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperExt-hz-fr_*_*") then(this.morphsFR[2] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperExt-vt-dw_*_*") then(this.morphsDWUP[2] = n)

					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperMid-hz-r_*_*") then (this.morphsHZ[3] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperMid-hz-fr_*_*") then (this.morphsFR[3] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperMid-vt-dw_*_*") then (this.morphsDWUP[3] = n)

					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperInt-hz-r_*_*") then (this.morphsHZ[4] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperInt-hz-fr_*_*") then (this.morphsFR[4] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-upperInt-vt-dw_*_*") then (this.morphsDWUP[4] = n)

					if (matchPattern n.name pattern:"chr_*_morph_l_eld-sideInt-hz-r_*_*") then (this.morphsHZ[5] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-sideInt-hz-fr_*_*") then (this.morphsFR[5] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-sideInt-vt-up_*_*") then (this.morphsDWUP[5] = n)

					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerInt-hz-r_*_*") then (this.morphsHZ[6] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerInt-hz-fr_*_*") then (this.morphsFR[6] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerInt-vt-up_*_*") then (this.morphsDWUP[6] = n)

					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerMid-hz-r_*_*") then (this.morphsHZ[7] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerMid-hz-fr_*_*") then (this.morphsFR[7] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerMid-vt-up_*_*") then (this.morphsDWUP[7] = n)

					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerExt-hz-r_*_*") then (this.morphsHZ[8] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerExt-hz-fr_*_*") then (this.morphsFR[8] = n)
					if (matchPattern n.name pattern:"chr_*_morph_l_eld-lowerExt-vt-up_*_*") then (this.morphsDWUP[8] = n)

					if (matchPattern n.name pattern:"chr_*_morph_r_eld-sideExt-hz-r_*_*") then (this.morphsHZinv[1] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-sideExt-hz-fr_*_*") then (this.morphsFRinv[1] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-sideExt-vt-up_*_*") then (this.morphsDWUPinv[1] = n)

					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperExt-hz-r_*_*") then (this.morphsHZinv[2] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperExt-hz-fr_*_*") then(this.morphsFRinv[2] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperExt-vt-dw_*_*") then(this.morphsDWUPinv[2] = n)

					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperMid-hz-r_*_*") then (this.morphsHZinv[3] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperMid-hz-fr_*_*") then (this.morphsFRinv[3] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperMid-vt-dw_*_*") then (this.morphsDWUPinv[3] = n)

					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperInt-hz-r_*_*") then (this.morphsHZinv[4] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperInt-hz-fr_*_*") then (this.morphsFRinv[4] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-upperInt-vt-dw_*_*") then (this.morphsDWUPinv[4] = n)

					if (matchPattern n.name pattern:"chr_*_morph_r_eld-sideInt-hz-r_*_*") then (this.morphsHZinv[5] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-sideInt-hz-fr_*_*") then (this.morphsFRinv[5] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-sideInt-vt-up_*_*") then (this.morphsDWUPinv[5] = n)

					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerInt-hz-r_*_*") then (this.morphsHZinv[6] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerInt-hz-fr_*_*") then (this.morphsFRinv[6] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerInt-vt-up_*_*") then (this.morphsDWUPinv[6] = n)

					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerMid-hz-r_*_*") then (this.morphsHZinv[7] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerMid-hz-fr_*_*") then (this.morphsFRinv[7] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerMid-vt-up_*_*") then (this.morphsDWUPinv[7] = n)

					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerExt-hz-r_*_*") then (this.morphsHZinv[8] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerExt-hz-fr_*_*") then (this.morphsFRinv[8] = n)
					if (matchPattern n.name pattern:"chr_*_morph_r_eld-lowerExt-vt-up_*_*") then (this.morphsDWUPinv[8] = n)

				)--for
				_tmpMorphs = (this.morphsHZ+this.morphsFR+this.morphsDWUP+this.morphsFRinv+this.morphsHZinv+this.morphsDWUPinv)
				--Devolvemos si existen morphs o no
				(_tmpMorphs.count > 0)
			)--if
		),

		------------------------------------------------
		--@fn: undefined | createEyeLidSystem | Utilizamos la función para crear todo el sistema de la spline con los ikControls.
		------------------------------------------------
		fn createEyeLidSystem =
		(
			_layerExist = lb.layer.getLayerbyName "_auxObj-eyeLidMorpherCreator_"

			if _layerExist != undefined then this.splineEyeLidLayer = _layerExist

			else
			(
				this.splineEyeLidLayer = lb.layer.newLayer name:"_auxObj-eyeLidMorpherCreator_"

				this.skinPoint = Point transform:(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]) isSelected:on size:20
				this.skinPoint.box = on
				this.skinPoint.wirecolor = green
				this.skinPoint.name = "eyeLidSkinPoint"

				this.splineEyeLidLayer.addNode this.skinPoint
				
				if isValidNode this.splineEyeLid then delete this.splineEyeLid
				this.splineEyeLid = lb.shapes.shapeEyeLidMorphs()

				this.splineEyeLidLayer.addNode this.splineEyeLid

				--Buscamos en la escena el ojo izquierdo.
				_leftEye	= undefined
				for obj in objects where (matchPattern obj.name pattern:"chr_*_mesh_l_eye_*_*") do _leftEye = obj

				--Calculamos el punto medio del bounding box del ojo.
				_bboxEye = nodeGetBoundingBox _leftEye (matrix3 1)
				_bboxMidPos = (_bboxEye[1] + _bboxEye [2])/2

				--Movemos la spline hasta el punto medio del ojo.
				this.splineEyeLid.rotation.controller.value = (eulerAngles 90 0 0) as quat
				this.splineEyeLid.position = _bboxMidPos
				this.splineEyeLid.position.controller[2].controller[2].value -= 3
				setTransformLockFlags this.splineEyeLid #all
				lb.controller.freezeTransform this.splineEyeLid #all

				--Añadimos el modificador Spline IK Control, creamos los helpers en cada knot y los guardamos en el array que hemos declarado y metemos los points en nuestra capa auxObj.
				_ikControl = Spline_IK_Control helper_size:1 linkTypes: 2
				addModifier this.splineEyeLid _ikControl
				numV = numKnots this.splineEyeLid 
				_ikControl.createHelper (numV)
				this.splinePoints = _ikControl.helper_list as array

				lb.controller.freezeTransform this.splineEyeLid #all

				--Renombramos los points basandonos en la careta de animación.
				for i = 1 to this.splinePoints.count do this.splinePoints[i].name = (i as string)

				this.splinePoints[1].name = "l_eld_sideExt"
				this.splinePoints[2].name = "l_eld_upperExt"
				this.splinePoints[3].name = "l_eld_upperMid"
				this.splinePoints[4].name = "l_eld_upperInt"
				this.splinePoints[5].name = "l_eld_sideInt"
				this.splinePoints[6].name = "l_eld_lowerInt"
				this.splinePoints[7].name = "l_eld_lowerMid"
				this.splinePoints[8].name = "l_eld_lowerExt"

				--Añadimos los points a la capa con la que estamos trabajando.
				for p in this.splinePoints do (this.splineEyeLidLayer.addNode p)
			)
		),

		------------------------------------------------
		--@fn: undefined | removeEyeLidSystem | Utilizamos la función para borrar el sistema creado..
		------------------------------------------------
		fn removeEyeLidSystem =
		(
			delete this.splinePoints
			delete this.skinPoint

			if isValidNode this.splineEyeLid then delete this.splineEyeLid
			
			if this.splineEyeLidLayer != undefined then lb.layer.deleteLayerByName "_auxObj-eyeLidMorpherCreator_"

			this.splineEyeLid = undefined
			this.splinePoints = #()
			this.splineEyeLidLayer = undefined
			this.skinPoint = undefined
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
	)--tl_eyeLidMorpherCreator
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_eyeLidMorpherCreator() --crea la herramienta
)