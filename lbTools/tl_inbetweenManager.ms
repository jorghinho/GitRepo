------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta de inbetweens de animacion.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta de inbetweens de animacion.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Inbetween Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 340		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 120		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpSelectedObjects "Selected Objects" pos:[5,5] width:330 height:110

		label lblPercent "Key %" pos:[15,25]
		spinner spnPercent  range:[0.0,100.0,50.0] pos:[50,25] width:45
		button btnLess "-10" pos:[100,25] width:28 height:16
		button btnMore "+10" pos:[133,25] width:28 height:16
		
		button btnPrev "Prev key" pos:[10,60] height:20 border:false
		button btnOneFourth "25.0" pos:[65,60] height:20 border:false
		button btnOneThird "33.3" pos:[95,60] height:20 border:false
		button btnInBetween "INBETWEEN" pos:[132,60] height:20
		button btnTwoThird "66.6" pos:[210,60] height:20 border:false
		button btnThreeFourth "75.0" pos:[240,60] height:20 border:false
		button btnNext "Next key" pos:[270,60] height:20 border:false
		slider sldPercent "" pos:[15,80] width:320 range:[0.0,100.0,50.0] ticks:10
		
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
		--cambio de valor
		------------------------------------------------
		on sldPercent changed value do
		(
			spnPercent.value = value
		)

		------------------------------------------------
		--cambio de valor
		------------------------------------------------
		on spnPercent changed value do
		(
			sldPercent.value = value
		)

		------------------------------------------------
		--cambio de valor
		------------------------------------------------
		on spnPercent entered do
		(
			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--cambio de valor
		------------------------------------------------
		on spnPercent buttonUp do
		(
			_value = sldPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--cambio de valor
		------------------------------------------------
		on sldPercent buttonUp do
		(
			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnLess pressed do
		(
			if spnPercent.value < 10 then spnPercent.value = 0.0 else spnPercent.value -= 10.0
			if sldPercent.value < 10 then sldPercent.value = 0.0 else sldPercent.value -= 10.0

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnMore pressed do
		(
			if spnPercent.value > 90 then spnPercent.value = 100.0 else spnPercent.value += 10.0
			if sldPercent.value > 90 then sldPercent.value = 100.0 else sldPercent.value += 10.0

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnPrev pressed do
		(
			spnPercent.value = 0.0
			sldPercent.value = 0.0

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnOneFourth pressed do
		(
			spnPercent.value = 25.0
			sldPercent.value = 25.0

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnOneThird pressed do
		(
			spnPercent.value = 33.3
			sldPercent.value = 33.3

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnInBetween pressed do
		(
			spnPercent.value = 50.0
			sldPercent.value = 50.0

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnTwoThird pressed do
		(
			spnPercent.value = 66.6
			sldPercent.value = 66.6

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnThreeFourth pressed do
		(
			spnPercent.value = 75.0
			sldPercent.value = 75.0

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
		)

		------------------------------------------------
		--boton presionado
		------------------------------------------------
		on btnNext pressed do
		(
			spnPercent.value = 100.0
			sldPercent.value = 100.0

			_value = spnPercent.value/100.0
			parent.setInbetweenValue _value (getCurrentSelection() as array)
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
	--@struct: inbetweenManager | Contiene la herramienta de inbetweens de animacion.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_inbetweenManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool plantilla",		--@var: description | Descripcion de la tool.
		
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
		
		fn sortSelObjs objArray =
		(
			_sortedNodes = #()

			_selHierarchies = lb.rig.getHierarchiesFromNodes objArray
			for _hierachy in _selHierarchies do _sortedNodes += _hierachy

			_sortedNodes
		),

		------------------------------------------------
		--crea un inbetween en los objetos seleccionados
		--necesita el valor y el array de objetos
		------------------------------------------------
		fn setInbetweenValue sliderValue objArray =
		(
			_sortedNodes = this.sortSelObjs objArray

			if _sortedNodes.count != 0 then
			(
				with animate on
				(
					with undo on
					(
						curTime = sliderTime
						k1 = 0f
						k2 = 1000000f
						timeArray = #()

						for obj in _sortedNodes do
						(
							------------------------------------------------
							--check objects properties to see if they have animated keys.  Returns keys as array.
							fn getPropKeys objProps =
							(
								propTimeArray = #()
								propNum = 1

								while objProps[propNum]!= undefined do
								(
									--if isController $.modifiers[modNum][propNum].isAnimated then  --didn't work on morpher
									if isController objProps[propNum].controller then
									(
										--if the controller type is a Position, Rotation and Scale controller (ie. for a subobject gizmo) then
										--get the key values for each of the three (pos, rot and scale).
										if  classof objProps[propNum].controller == prs then
										(
											for i=1 to 3 do
											(
												for k in objProps[propNum].controller[i].controller.keys do
												(
													if (finditem propTimeArray k.time) == 0 then append propTimeArray k.time
												)--for
											)--for
										)--if

										--if not a PRS controller I ASSUME it's a bezier or a position controller and get those keys
										--I also ASSUME that ASSUMING will come back to bite me in the butt.
										for k in objProps[propNum].controller.keys do
										(
											if (finditem propTimeArray k.time) == 0 then append propTimeArray k.time
										)--for
									)--if

									propNum +=1
								)--while

								propTimeArray
							)--fn getPropKeys
							------------------------------------------------

							------------------------------------------------
							--checks the objects for animated custom attributes keys. Returns keys as array.
							fn getCAKeys objCAs =
							(
								cATimeArray = #()
								cAcount = custAttributes.count objCAs

								if cAcount > 0 then
								(
									for c = 1 to cACount do
									(
										cANum = 1
										while objCAs.custAttributes[c][cANum] != undefined do
										(
											if objCAs.custAttributes[c][cANum].isAnimated then
											(
												for k in objCAs.custAttributes[c][cANum].controller.keys do
												(
													if (finditem cATimeArray k.time) == 0 then append cATimeArray k.time
												)--for
											)--if

											cANum +=1
										)--while
									)--for
								)--if

								cATimeArray
							)
							------------------------------------------------

							------------------------------------------------
							--calcultates rotational inbetween value and returns a matrix3 value as the result
							fn calcRotTween r1 r2 sliderValue=
							(
								fn dotQuat q q_prev =
								( 
								   (q.w * q_prev.w + q.x * q_prev.x + q.y * q_prev.y + q.z * q_prev.z) < 0 
								)

								if (dotQuat r1 r2) do r1 *=-1

								tweenRot = slerp (normalize r1) (normalize r2) sliderValue
								tweenRot = tweenRot as matrix3

								tweenRot
							)
							------------------------------------------------

							------------------------------------------------
							--calcultates inbetween value at slider percentage
							fn calcTween v1 v2 sliderValue=
							(
								tweenValue = v1 + (v2-v1)*sliderValue
								tweenValue
							)
							------------------------------------------------

							------------------------------------------------
							--create an array of the baseObject and it's modifiers
							objModArray = #(obj.baseObject)
							if obj.modifiers.count > 0 then
							(
								for i = 1 to obj.modifiers.count do
								(
									append objModArray obj.modifiers[i]
								)--for
							)--if
							------------------------------------------------

							------------------------------------------------
							for objMod in objModArray do
							(
								for pk in (getPropKeys objMod) where (finditem timeArray pk) == 0 do append timeArray pk
								for cak in (getCAKeys objMod) where (finditem timeArray cak) == 0 do append timeArray cak
							)
							------------------------------------------------

							------------------------------------------------
							if classof obj.baseObject == Biped_Object then
							(
								bipCtrller = obj.controller

								--check if it's the biped COM node
								if classOf bipCtrller == Vertical_Horizontal_Turn then
								(
									for h = 1 to 3 do
									(
										for bipkey in bipCtrller[h].controller.keys do
										(
											if (finditem timeArray bipkey.time) == 0 then append timeArray bipkey.time
										)--for
									)--for									
								)
								else 
								(
									for bipkey in bipCtrller.keys do
									(
										if (finditem timeArray bipkey.time) == 0 then append timeArray bipkey.time
									)--for
								)--if else
							)
							else
							(
								--check for position rotation and scale keys on the object.  If the objects using a list controller only get
								--the key times of the active controller.
								--I ASSUME position rotation scale controllers OR list controllers.
								for q = 1 to 3 do
								(
									ListCtrller = #(Position_List, Rotation_List, Scale_List)
									PRScntrller = obj.transform.controller[q].controller
									if classOf PRScntrller != ListCtrller[q] then 
									(
										for prskey in PRScntrller.keys do
										(
											if (finditem timeArray prskey.time) == 0 then append timeArray prskey.time
										)--for
									)
									else 
									(
										for prskey in PRScntrller[PRScntrller.active].controller.keys do
										(
											if (finditem timeArray prskey.time) == 0 then append timeArray prskey.time
										)--for	
									)									
								)--for
							)
							------------------------------------------------

							sort timeArray

							------------------------------------------------
							--Find the previous and next keyframe time based on the current time slider value
							for k in timeArray do
							(
								if k < curTime then k1 = k
								if k > curTime and k < k2 then k2 = k
							)--for
							------------------------------------------------

							------------------------------------------------
							--Set the default in and out tangent type for bezier controllers based on the previous and
							--next keyframe tangent types of the X_rotation of the rotation controller.  
							--The BezierDefaultParams command is available in 3ds Max 2008 and higher. Previously available in the free [AVG] Avguard Extensions.
							
							oldInTangentType = BezierDefaultParams.inTangentType
							oldOutTangentType = BezierDefaultParams.outTangentType

							try
							(
								rotCtrller = obj.transform.controller[2].controller
								
								if classOf rotCtrller != Rotation_List then (rotC = rotCtrller)else(rotC = rotCtrller[rotCtrller.active].controller)
								
								if classOf rotC == Euler_XYZ then
								(
									numK = 0

									for rotkey in rotC.keys do
									(
										objTangType = oldInTangentType
										numK +=1

										if rotkey.time == k1 then	(objTangType = rotC[1].keys[numK].outTangentType)
										if rotkey.time == k2 then (objTangType = rotC[1].keys[numK].inTangentType)
									
										--for some reason BezierDefaultParams.(in and out)TangentType doesn't support the label "#auto" so I
										--had to change that label to "#flat"
										if objTangType == #auto then keyType = #flat
										else keyType = objTangType
										
										if rotkey.time == k1 then	(BezierDefaultParams.inTangentType = keyType)
										if rotkey.time == k2 then (BezierDefaultParams.outTangentType = keyType)
									)--for
								)--if
							)
							catch()
							------------------------------------------------

							------------------------------------------------
							--calculate the inbetween values for all the properties and CAs on the object and it's modifiers
							for objMod in objModArray do
							(
								cAcount = custAttributes.count objMod

								if cACount > 0 then
								(
									for c = 1 to cACount do
									(
										cANum = 1

										while objMod.custAttributes[c][cANum] != undefined do
										(
											try
											(
												v1 = at time k1 objMod.custAttributes[c][cANum].controller.value
												v2 = at time k2 objMod.custAttributes[c][cANum].controller.value
												objMod.custAttributes[c][cANum].controller.value = calcTween v1 v2 sliderValue
												
											)
											catch ()

											cANum +=1
										)--while
									)--for
								)--if

								propNum = 1

								while objMod[propNum] != undefined do
								(
									--Morpher modifier needed it's own special case
									if classOf objMod == Morpher then
									(
										for m = 1 to 100 do
										(
											if objMod[m].controller != undefined then
											(
												v1 = at time k1 objMod[m].controller.value
												v2 = at time k2 objMod[m].controller.value
												objMod[m].controller.value = calcTween v1 v2 sliderValue
											)--if
										)--for
									)
									else
									(
										--didn't work on morpher
										if isProperty objMod[propNum] #isAnimated and objMod[propNum].isAnimated then
										(
											--if the controller type is a Position, Rotation and Scale controller (ie. for a subobject gizmo) then
											--get the key values for each of the three
											if  classof objMod[propNum].controller == prs then
											(
												for i = 1 to 3 do
												(
													v1 = at time k1 objMod[propNum].controller[i].value
													v2 = at time k2 objMod[propNum].controller[i].value

													if i == 2 then objMod[propNum].controller[i].value = calcRotTween v1 v2 sliderValue
													else objMod[propNum].controller[i].value =calcTween v1 v2 sliderValue
												)--for
											)--if

											try
											(
												v1 = at time k1 objMod[propNum].controller.value
												v2 = at time k2 objMod[propNum].controller.value

												objMod[propNum].controller.value = calcTween v1 v2 sliderValue
											)
											catch()
										)--if
									)--if else

									propNum +=1
								)--while								
							)--for 
							------------------------------------------------
							
							------------------------------------------------
							--calculate the inbetween values for the position, rotation and scale of the two matirices
							TM1 = at time k1 obj.transform
							TM2 = at time k2 obj.transform

							if obj.parent != undefined then
							(
								TM1 *= at time k1 inverse obj.parent.transform
								TM2 *= at time k2 inverse obj.parent.transform
							)

							tweenTM = TM1
							
							tweenPos = calcTween TM1.translationPart TM2.translationPart sliderValue
							tweenRot = calcRotTween TM1.rotationPart TM2.rotationPart sliderValue

							--apparently the transform scalePart property does NOT keep negative values of scale....so
							--I need to use the scale controller value to check for negative values cause some people
							--(like me) don't listen to other tech people and include negative scales in thier rigs.
							if classof obj.baseObject == Biped_Object then (tweenScale = calcTween TM1.scalePart TM2.scalePart sliderValue)
							else (tweenScale = calcTween (at time k1 obj.scale.controller.value) (at time k2 obj.scale.controller.value) sliderValue)
							
							tweenTM.row1 = tweenRot.row1
							tweenTM.row2 = tweenRot.row2
							tweenTM.row3 = tweenRot.row3
							
							tweenTM.row4 = tweenPos
							
							tweenTM.row1 *= tweenScale.x
							tweenTM.row2 *= tweenScale.y
							tweenTM.row3 *= tweenScale.z

							if obj.parent != undefined then obj.transform = tweenTM * obj.parent.transform
							else obj.transform = tweenTM
							
							--Set default controller types back to what they were.
							BezierDefaultParams.inTangentType = oldInTangentType 
							BezierDefaultParams.outTangentType = oldOutTangentType
						)--for
					)--undo
				)--animate
			)
			else
			(
				lb.messagebox.show "You must select one object at least"
			)
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
		
	)--tl_inbetweenManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_inbetweenManager() --crea la herramienta
)