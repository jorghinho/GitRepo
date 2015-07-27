------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta FreezeTransforms.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollFreezeTransformsDef | Contiene la herramienta Freeze Transforms.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollFreezeTransformsDef "Freeze Transforms"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 220		--@var: minWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 275		--@var: minHeight | Alto mínimo de la herramienta.		
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local controllerType = #frozen		-- tipo de controlador que queremos activar al manipulas los controles de Set Active Controller

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpFreeze "Freeze" pos:[5,5] width:70 height:145
		button btnFrzPos "Pos" pos:[10,21] width:60 height:25
		button btnFrzRot "Rot" pos:[10,51] width:60 height:25
		button btnFrzSca "Sca" pos:[10,81] width:60 height:25 --enabled:false
		button btnFrzAll "All" pos:[10,120] width:60 height:25
		
		label lblkeepPos "____________________________________________" pos:[75,19] width:65 enabled:false
		label lblkeepRot "____________________________________________" pos:[75,49] width:65 enabled:false
		label lblkeepSca "____________________________________________" pos:[75,79] width:65 enabled:false
		
		checkbox chkPosition "keep" pos:[85,25] width:42 height:15 checked:false toolTip:"Keep previous controllers and add a Zero controller on top"
		checkbox chkRotation "keep" pos:[85,55] width:42 height:15 checked:false toolTip:"Keep previous controllers and add a Zero controller on top"
		checkbox chkScale "keep" pos:[85,85] width:42 height:15 checked:false toolTip:"Keep previous controllers and add a Zero controller on top" --enabled:false
		
		groupBox grpUnfreeze "Unfreeze" pos:[140,5] width:70 height:145
		button btnUnfrzAll "All" pos:[147,120] width:60 height:25
		button btnUnfrzPos "Pos" pos:[147,20] width:60 height:25
		button btnUnfrzRot "Rot" pos:[147,50] width:60 height:25
		button btnUnfrzSca "Sca" pos:[147,80] width:60 height:25
		
		groupBox grpSetActiveController "Set active controller to" pos:[5,155] width:205 height:95
		radiobuttons rdoSetActiveController "" pos:[10,177] width:120 height:32 labels:#("Frozen", "Number", "Zero", "Find str") columns:2
		spinner spnControllerNumber "" pos:[130,176] width:45 height:16 enabled:false range:[1,10,2] type:#integer
		editText edtStringToFind "" pos:[126,193] width:79 height:15 enabled:false
		button btnSetPosActiveController "Pos" pos:[10,215] width:35 height:25 checked:true
		button btnSetRotActiveController "Rot" pos:[50,215] width:35 height:25 checked:true
		button btnSetScaActiveController "Sca" pos:[90,215] width:35 height:25 checked:true
		button btnSetAllActiveController "All" pos:[135,215] width:70 height:25
		
		editText edtLog text:"<log>" pos:[0,255] width:210 readonly:true
		timer clock interval:1500
		
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
			if size.x < minRollWidth then (size.x = minRollWidth; rollFreezeTransformsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollFreezeTransformsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollFreezeTransforms/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollFreezeTransforms/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | Evento para freezear la posicion.
		------------------------------------------------
		on btnFrzPos pressed do
		(
			suspendEditing()
			undo "Freeze position" on
			(
				--Comprobamos que no haya objetos con attachObjectToFace.
				_attachProObjects = #()
				
				--Recorro toda la seleccion apilando en un array todos los objetos que tengamos con attachObjectToFace
				for o in selection do
				(
					_attachProControllers = #()
					_attachProControllers = lb.attachObjectToFaceFunctions.getAttachProControllers o
					if _attachProControllers[1] != undefined and _attachProControllers[2] != undefined and _attachProControllers[3] != undefined then
					(
						append _attachProObjects o
					)
				)
				
				--Creo un flag para almacenar si vamos a preservar los attachObjectToFace.
				_preserveAttachs = false
				--Si hay objetos de attach object to face  miraremos si hay un solo tick (de posicion o rotación) marcado para preguntar, si estan los dos guardaremos sin preguntar 
				--y si no hay ninguno haremos override sin preguntar tampoco
				if _attachProObjects.count > 0 then
				(
					if ((chkPosition.checked and not chkRotation.checked) or (not chkPosition.checked and chkRotation.checked)) then

						_preserveAttachs = lb.message.show "There are some nodes with attach object to face controllers. To preserve them, keep position is needed. Do you want to activate them for these objects?" type:#query pos:undefined size:[300,75] modal:true
					else if (chkPosition.checked and chkRotation.checked) then
						_preserveAttachs = true
					else
						_preserveAttachs = false
				)
				
				--Si hemos decidido preservar, para todos los objetos que tengan attachObjectToFace tendremos que forzar el keep de posicion y de rotacion.
				for o in selection do 
				(
					if _preserveAttachs and finditem _attachProObjects o != 0 then
					(
						lb.controller.freezeTransform o #position keepPos:true
					)
					else
					(
						lb.controller.unFreezeTransform o #position keepPos:chkPosition.checked
					)
				)
				
				for o in selection do lb.controller.unfreezePose o #position
			)
			
			edtLog.text = (selection.count as string + " objects frozen")
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			clock.active = true
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | Evento para freezear la rotacion.
		------------------------------------------------
		on btnFrzRot pressed do
		(
			suspendEditing()
			undo "Freeze rotation" on
			(
				--Comprobamos que no haya objetos con attachObjectToFace.
				_attachProObjects = #()
				
				--Recorro toda la seleccion apilando en un array todos los objetos que tengamos con attachObjectToFace
				for o in selection do
				(
					_attachProControllers = #()
					_attachProControllers = lb.attachObjectToFaceFunctions.getAttachProControllers o
					if _attachProControllers[1] != undefined and _attachProControllers[2] != undefined and _attachProControllers[3] != undefined then
					(
						append _attachProObjects o
					)
				)
				
				--Creo un flag para almacenar si vamos a preservar los attachObjectToFace.
				_preserveAttachs = false
				
				--Si hay objetos de attach object to face  miraremos si hay un solo tick (de posicion o rotación) marcado para preguntar, si estan los dos guardaremos sin preguntar 
				--y si no hay ninguno haremos override sin preguntar tampoco
				if _attachProObjects.count > 0 then
				(
					if ((chkPosition.checked and not chkRotation.checked) or (not chkPosition.checked and chkRotation.checked)) then

						_preserveAttachs = lb.message.show "There are some nodes with attach object to face controllers. To preserve them, keep position is needed. Do you want to activate them for these objects?" type:#query pos:undefined size:[300,75] modal:true
					else if (chkPosition.checked and chkRotation.checked) then
						_preserveAttachs = true
					else
						_preserveAttachs = false
				)
				
				--Si hemos decidido preservar, para todos los objetos que tengan attachObjectToFace tendremos que forzar el keep de posicion y de rotacion.
				for o in selection do 
				(
					if _preserveAttachs and finditem _attachProObjects o != 0 then
					(
						lb.controller.freezeTransform o #rotation keepRot:true
					)
					else
					(
						lb.controller.unFreezeTransform o #rotation keepRot:chkRotation.checked
					)
				)
				
				for o in selection do lb.controller.unfreezePose o #rotation 
			)
			
			edtLog.text = (selection.count as string + " objects frozen")
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			clock.active = true
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | Evento para freezear la escala.
		------------------------------------------------
		on btnFrzSca pressed do
		(
			suspendEditing()
			undo "Freeze scale" on
			(
				for o in selection do lb.controller.freezeTransform o #scale keepPos:chkPosition.checked keepRot:chkRotation.checked keepSca:chkScale.checked
				for o in selection do lb.controller.unfreezePose o #scale	
			)
			
			edtLog.text = (selection.count as string + " objects frozen")
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			clock.active = true
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | Evento para freezear pos,sca,rot.
		------------------------------------------------
		on btnFrzAll pressed do
		(
			suspendEditing()
			undo "Freeze all transforms" on
			(
				--Comprobamos que no haya objetos con attachObjectToFace.
				_attachProObjects = #()
				
				--Recorro toda la seleccion apilando en un array todos los objetos que tengamos con attachObjectToFace
				for o in selection do
				(
					_attachProControllers = #()
					_attachProControllers = lb.attachObjectToFaceFunctions.getAttachProControllers o
					if _attachProControllers[1] != undefined and _attachProControllers[2] != undefined and _attachProControllers[3] != undefined then
					(
						append _attachProObjects o
					)
				)
				
				--Creo un flag para almacenar si vamos a preservar los attachObjectToFace.
				_preserveAttachs = false
				
				--Si hay objetos de attach object to face  miraremos si hay un solo tick (de posicion o rotación) marcado para preguntar, si estan los dos guardaremos sin preguntar 
				--y si no hay ninguno haremos override sin preguntar tampoco
				if _attachProObjects.count > 0 then
				(
					if ((chkPosition.checked and not chkRotation.checked) or (not chkPosition.checked and chkRotation.checked)) then

						_preserveAttachs = lb.message.show "There are some nodes with attach object to face controllers. To preserve them, keep position is needed. Do you want to activate them for these objects?" type:#query pos:undefined size:[300,75] modal:true
					else if (chkPosition.checked and chkRotation.checked) then
						_preserveAttachs = true
					else
						_preserveAttachs = false
				)
				
				--Si hemos decidido preservar, para todos los objetos que tengan attachObjectToFace tendremos que forzar el keep de posicion y de rotacion.
				for o in selection do 
				(
					if _preserveAttachs and finditem _attachProObjects o != 0 then
					(
						lb.controller.freezeTransform o #all keepPos:true keepRot:true
					)
					else
					(
						lb.controller.freezeTransform o #all keepPos:chkPosition.checked keepRot:chkRotation.checked keepSca:chkScale.checked
					)
				)
				for o in selection do lb.controller.unfreezePose o #all	
			)
			
			edtLog.text = (selection.count as string + " objects frozen")
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			clock.active = true
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | Evento para unfreezear la posicion.
		------------------------------------------------
		on btnUnFrzPos pressed do
		(
			suspendEditing()
			undo "UnFreeze position" on
			(
				--Comprobamos que no haya objetos con attachObjectToFace.
				_attachProObjects = #()
				
				--Recorro toda la seleccion apilando en un array todos los objetos que tengamos con attachObjectToFace
				for o in selection do
				(
					_attachProControllers = #()
					_attachProControllers = lb.attachObjectToFaceFunctions.getAttachProControllers o
					if _attachProControllers[1] != undefined and _attachProControllers[2] != undefined and _attachProControllers[3] != undefined then
					(
						append _attachProObjects o
					)
				)
				
				--Creo un flag para almacenar si vamos a preservar los attachObjectToFace.
				_preserveAttachs = false
				
				--Si hay objetos de attach object to face  miraremos si hay un solo tick (de posicion o rotación) marcado para preguntar, si estan los dos guardaremos sin preguntar 
				--y si no hay ninguno haremos override sin preguntar tampoco
				if _attachProObjects.count > 0 then
				(
					if ((chkPosition.checked and not chkRotation.checked) or (not chkPosition.checked and chkRotation.checked)) then

						_preserveAttachs = lb.message.show "There are some nodes with attach object to face controllers. To preserve them, keep position is needed. Do you want to activate them for these objects?" type:#query pos:undefined size:[300,75] modal:true
					else if (chkPosition.checked and chkRotation.checked) then
						_preserveAttachs = true
					else
						_preserveAttachs = false
				)
				
				--Si hemos decidido preservar, para todos los objetos que tengan attachObjectToFace tendremos que forzar el keep de posicion y de rotacion.
				for o in selection do 
				(
					if _preserveAttachs and finditem _attachProObjects o != 0 then
					(
						lb.controller.unFreezeTransform o #position keepPos:true
					)
					else
					(
						lb.controller.unFreezeTransform o #position keepPos:chkPosition.checked
					)
				)
			)
			
			edtLog.text = (selection.count as string + " objects unFrozen")
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			clock.active = true
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | Evento para unfreezear la rotacion.
		------------------------------------------------
		on btnUnFrzRot pressed do
		(
			suspendEditing()
			undo "UnFreeze rotation" on
			(
				--Comprobamos que no haya objetos con attachObjectToFace.
				_attachProObjects = #()
				
				--Recorro toda la seleccion apilando en un array todos los objetos que tengamos con attachObjectToFace
				for o in selection do
				(
					_attachProControllers = #()
					_attachProControllers = lb.attachObjectToFaceFunctions.getAttachProControllers o
					if _attachProControllers[1] != undefined and _attachProControllers[2] != undefined and _attachProControllers[3] != undefined then
					(
						append _attachProObjects o
					)
				)
				
				--Creo un flag para almacenar si vamos a preservar los attachObjectToFace.
				_preserveAttachs = false
				
				--Si hay objetos de attach object to face  miraremos si hay un solo tick (de posicion o rotación) marcado para preguntar, si estan los dos guardaremos sin preguntar 
				--y si no hay ninguno haremos override sin preguntar tampoco
				if _attachProObjects.count > 0 then
				(
					if ((chkPosition.checked and not chkRotation.checked) or (not chkPosition.checked and chkRotation.checked)) then

						_preserveAttachs = lb.message.show "There are some nodes with attach object to face controllers. To preserve them, keep position is needed. Do you want to activate them for these objects?" type:#query pos:undefined size:[300,75] modal:true
					else if (chkPosition.checked and chkRotation.checked) then
						_preserveAttachs = true
					else
						_preserveAttachs = false
				)
				
				--Si hemos decidido preservar, para todos los objetos que tengan attachObjectToFace tendremos que forzar el keep de posicion y de rotacion.
				for o in selection do 
				(
					if _preserveAttachs and finditem _attachProObjects o != 0 then
					(
						lb.controller.unFreezeTransform o #rotation keepRot:true
					)
					else
					(
						lb.controller.unFreezeTransform o #rotation keepRot:chkRotation.checked
					)
				)
			)
			
			edtLog.text = (selection.count as string + " objects unFrozen")
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			clock.active = true
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | Evento para unfreezear la escala.
		------------------------------------------------
		on btnUnFrzSca pressed do
		(
			suspendEditing()
			undo "UnFreeze scale" on
			(
				for o in selection do lb.controller.unFreezeTransform o #scale keepPos:chkPosition.checked keepRot:chkRotation.checked keepSca:chkScale.checked
			)
			
			edtLog.text = (selection.count as string + " objects unFrozen")
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			clock.active = true
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | Evento para unfreezear pos,rot,sca.
		------------------------------------------------
		on btnUnFrzAll pressed do
		(
			suspendEditing()
			undo "UnFreeze all transforms" on
			(
				--Comprobamos que no haya objetos con attachObjectToFace.
				_attachProObjects = #()
				
				--Recorro toda la seleccion apilando en un array todos los objetos que tengamos con attachObjectToFace
				for o in selection do
				(
					_attachProControllers = #()
					_attachProControllers = lb.attachObjectToFaceFunctions.getAttachProControllers o
					if _attachProControllers[1] != undefined and _attachProControllers[2] != undefined and _attachProControllers[3] != undefined then
					(
						append _attachProObjects o
					)
				)
				
				--Creo un flag para almacenar si vamos a preservar los attachObjectToFace.
				_preserveAttachs = false
				
				--Si hay objetos de attach object to face  miraremos si hay un solo tick (de posicion o rotación) marcado para preguntar, si estan los dos guardaremos sin preguntar 
				--y si no hay ninguno haremos override sin preguntar tampoco
				if _attachProObjects.count > 0 then
				(
					if ((chkPosition.checked and not chkRotation.checked) or (not chkPosition.checked and chkRotation.checked)) then
					
						_preserveAttachs = lb.message.show "There are some nodes with attach object to face controllers. To preserve them, keep position is needed. Do you want to activate them for these objects?" type:#query pos:undefined size:[300,75] modal:true
					else if (chkPosition.checked and chkRotation.checked) then
						_preserveAttachs = true
					else
						_preserveAttachs = false
				)
				
				--Si hemos decidido preservar, para todos los objetos que tengan attachObjectToFace tendremos que forzar el keep de posicion y de rotacion.
				for o in selection do 
				(
					if _preserveAttachs and finditem _attachProObjects o != 0 then
					(
						lb.controller.unFreezeTransform o #all keepPos:true keepRot:true 
					)
					else
					(
						lb.controller.unFreezeTransform o #all keepPos:chkPosition.checked keepRot:chkRotation.checked keepSca:chkScale.checked
					)
				)
			)
			
			edtLog.text = (selection.count as string + " objects unFrozen")
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			clock.active = true
			resumeEditing()
		)

		on rdoSetActiveController changed state do
		(
			case rdoSetActiveController.state of
			(
				1: controllerType = #frozen
				2: controllerType = spnControllerNumber.value
				3: controllerType = #zero
				4: controllerType = edtStringToFind.text
			)
			
			spnControllerNumber.enabled = (state == 2)
			edtStringToFind.enabled = (state == 4)
		)

		on spnControllerNumber changed val do
		(
			controllerType = val
		)

		on edtStringToFind changed txt do
		(
			controllerType = txt
		)

		on btnSetPosActiveController pressed do
		(
			suspendEditing()
			numObjsChanged = 0
			
			undo "Set Rot Active Controller" on
			(
				for o in selection do 
					if (lb.controller.setActiveController o #position controllerType) then numObjsChanged += 1
			)
			
			edtLog.text = (numObjsChanged as string + " objects updated.")
			clock.active = true
			resumeEditing()
		)

		on btnSetRotActiveController pressed do
		(
			suspendEditing()
			numObjsChanged = 0
			
			undo "Set Rot Active Controller" on
			(
				for o in selection do 
					if (lb.controller.setActiveController o #rotation controllerType) then numObjsChanged += 1
			)
			
			edtLog.text = (numObjsChanged as string + " objects updated.")
			clock.active = true
			resumeEditing()
		)

		on btnSetScaActiveController pressed do
		(
			suspendEditing()
			numObjsChanged = 0
			
			undo "Set Rot Active Controller" on
			(
				for o in selection do 
					if (lb.controller.setActiveController o #scale controllerType) then numObjsChanged += 1
			)
			
			edtLog.text = (numObjsChanged as string + " objects updated.")
			clock.active = true
			resumeEditing()
		)

		on btnSetAllActiveController pressed do
		(
			suspendEditing()
			numObjsChanged = 0
			
			undo "Set Rot Active Controller" on
			(
				for o in selection do 
					if (lb.controller.setActiveController o #all controllerType) then numObjsChanged += 1
			)
			
			edtLog.text = (numObjsChanged as string + " objects updated.")
			clock.active = true
			resumeEditing()
		)

		on clock tick do
		(
			edtLog.text = ""
			clock.active = false
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollFreezeTransformsDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollFreezeTransformsDef open do
		(
			loadSettings()
			createSceneEvents()
			if parent.rollMain != undefined then resize parent.rollMain.size
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollFreezeTransformsDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollFreezeTransformsDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollFreezePoseDef | Contiene la herramienta Freeze Pose.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollFreezePoseDef "Freeze Pose"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 220		--@var: minWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 100		--@var: minHeight | Alto mínimo de la herramienta.		
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpFreeze "Freeze" pos:[5,5] width:203 height:45
		button btnFrzPos "Pos" pos:[10,20] width:35 height:25 
		button btnFrzRot "Rot" pos:[50,20] width:35 height:25
		button btnFrzSca "Sca" pos:[90,20] width:35 height:25
		button btnFrzAll "All" pos:[135,20] width:70 height:25
				
				
		groupBox grpUnfreeze "Unfreeze" pos:[5,55] width:203 height:45
		button btnUnfrzPos "Pos" pos:[10,70] width:35 height:25 
		button btnUnfrzRot "Rot" pos:[50,70] width:35 height:25
		button btnUnfrzSca "Sca" pos:[90,70] width:35 height:25
		button btnUnfrzAll "All" pos:[135,70] width:70 height:25
		
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
			if size.x < minRollWidth then (size.x = minRollWidth; rollFreezePoseDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollFreezePoseDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollFreezeTransforms/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollFreezeTransforms/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | llama a la funcion freezePose en posicion.
		------------------------------------------------		
		on btnFrzPos pressed do
		(	
			suspendEditing()
			undo "Freeze Pos" on
				for o in selection do lb.controller.freezePose o #position
			resumeEditing()
		)	

		------------------------------------------------
		--@event: pressed | llama a la funcion freezePose en rotacion
		------------------------------------------------		
		on btnFrzRot pressed do
		(
			suspendEditing()
			undo "Freeze Rot" on
				for o in selection do lb.controller.freezePose o #rotation
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | llama a la funcion freezePose en escala
		------------------------------------------------		
		on btnFrzSca pressed do
		(	
			suspendEditing()
			undo "Freeze Scale" on
				for o in selection do lb.controller.freezePose o #scale
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | llama a la funcion freezePose en todas las 3 transformaciones
		------------------------------------------------		
		on btnFrzAll pressed do
		(
			suspendEditing()
			undo "Freeze Pose" on
				for o in selection do lb.controller.freezePose o #all
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | llama a la funcion lb.controller.unfreezePose en posicion
		------------------------------------------------		
		on btnUnFrzPos pressed do
		(
			suspendEditing()
			undo "UnFreeze Pos" on
				for o in selection do lb.controller.unfreezePose o #position
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | llama a la funcion lb.controller.unfreezePose en rotacion
		------------------------------------------------		
		on btnUnFrzRot pressed do
		(
			suspendEditing()
			undo "UnFreeze Rot" on
				for o in selection do lb.controller.unfreezePose o #rotation
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | llama a la funcion lb.controller.unfreezePose en escala
		------------------------------------------------		
		on btnUnFrzSca pressed do
		(
			suspendEditing()
			undo "UnFreeze Scale" on
				for o in selection do lb.controller.unfreezePose o #scale
			resumeEditing()
		)

		------------------------------------------------
		--@event: pressed | llama a la funcion lb.controller.unfreezePose en todas las 3 transformaciones
		------------------------------------------------		
		on btnUnFrzAll pressed do
		(
			suspendEditing()
			undo "UnFreeze Pose" on
				for o in selection do lb.controller.unfreezePose o #all
			resumeEditing()
		)
				
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollFreezePoseDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollFreezePoseDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize parent.rollMain.size
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollFreezePoseDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollFreezePoseDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateFltTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_freezeTransforms
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Freeze Transforms",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
		
		minWidth = 225,		--@var: minWidth | Ancho mínimo de la herramienta.
		minHeight = 400,		--@var: minHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollFreezeTransforms = rollFreezeTransformsDef,	--@var: rollFreezeTransforms | Almacena el rollout de ejemplo1 de la herramienta.
		rollFreezePose = rollFreezePoseDef,	--@var: rollFreezePose | Almacena el rollout de ejemplo2 de la herramienta.
		rollMain = undefined,
		
		subRollouts = #(this.rollFreezeTransforms, this.rollFreezePose), --@var: subRollouts | Almacena los rolllouts flotantes.

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
			this.rollMain = newRolloutFloater "Freeze Transforms"  225 400 -10000 0
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
	)--tl_freezeTransforms
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_freezeTransforms() --crea la herramienta
)