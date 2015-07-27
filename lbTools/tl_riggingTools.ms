------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta riggingTools.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTVirtualParentDef | Contiene la herramienta Virtual Parent
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTVirtualParentDef "Virtual Parent"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		pickbutton pckVirtualParent "Pick Parent" pos:[5,5] width:95 height:20 tooltip:"Pick Virtual Parent for selected Objects"
		button btnVirtualParentDel "Unlink" pos:[105,5] width:95 height:20 tooltip:"Unlink from Virtual Parent"
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTVirtualParentDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTVirtualParentDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: picked | asigna a la seleccion el padre virtual pasado por parametro
		------------------------------------------------		
		on pckVirtualParent picked obj do
		(
			if isValidNode obj then
				lb.rig.linkVirtualParent (getCurrentSelection()) obj
		)

		------------------------------------------------
		--@event: pressed | Desasigna el padre virtual de los objetos seleccionados
		------------------------------------------------
		on btnVirtualParentDel pressed do
		(
			lb.rig.unlinkVirtualParent (getCurrentSelection())
		)		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTVirtualParentDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTVirtualParentDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTVirtualParentDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTVirtualParentDef	

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTPuppetDef | Contiene la herramienta Master of Puppets
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTPuppetDef "Master of Puppets"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		checkbox  chkPuppetSelection "All Puppets" pos:[110,5] height:15 tooltip:"Aplies the tool to all Character Pieces, or only to Selected Pieces" checked:true
		checkbox  chkPuppetUnify "Unify Puppets" pos:[110,20] height:15 tooltip:"Unifys the visibility of a Character Puppets"
		button btnHideShowPuppet "Hide/Unhide" pos:[5,5] width:95 height:30 tooltip:"Hide/Unhide Puppets. At least one Character Piece must be selected"
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTPuppetDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTPuppetDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | Muestra o oculta los puppets.
		------------------------------------------------
		on btnHideShowPuppet pressed do
		(
			allFlag = chkPuppetSelection.checked			
			unifyFlag = chkPuppetUnify.checked
			
			lb.rig.hideShowPuppet selection allFlag unifyFlag
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTPuppetDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTPuppetDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTPuppetDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTPuppetDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTlocksManagerDef  | Contiene la herramienta Locks Manager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTlocksManagerDef "Locks Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		struct locksInfo
		(
			-- objeto del que almacenamos los locks
			obj = undefined,
			
			-- locks------------------------------------
			
			-- move
			lmX = 0,
			lmY = 0,
			lmZ = 0,
			
			-- rotate
			lrX = 0,
			lrY = 0,
			lrZ = 0,
			
			-- scale
			lsX = 0,
			lsY = 0,
			lsZ = 0,
			---------------------------------------------
			
			-- inherit-----------------------------------
			
			-- move
			imX = 1,
			imY = 1,
			imZ = 1,
			
			-- rotate
			irX = 1,
			irY = 1,
			irZ = 1,
			
			-- scale
			isX = 1,
			isY = 1,
			isZ = 1
			---------------------------------------------
		)--struct
		
		struct globalLocksInfo
		(
			-- locks------------------------------------
			
			-- move
			lmx = -1,
			lmy = -1,
			lmz = -1,
			lm = -1,
			
			-- rotate
			lrx = -1,
			lry = -1,
			lrz = -1,
			lr = -1,
			
			-- scale
			lsx = -1,
			lsy = -1,
			lsz = -1,
			ls = -1,
			
			lall = -1,
			
			-- inherit-----------------------------------
			
			-- move
			imx = -1,
			imy = -1,
			imz = -1,
			im = -1,
			
			-- rotate
			irx = -1,
			iry = -1,
			irz = -1,
			ir = -1,
			
			-- scale
			isx = -1,
			isy = -1,
			isz = -1,
			is = -1,
			
			iall = -1
		)--struct
		
		local actualLocks = #() --array de locksInfo
		local globalLocks = undefined --estado global de los locks en funcion de todos los objetos seleccionados
		local allLocks = undefined --locks globales del todo

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpLocks "Locks" pos:[5,5] width:195 height:90
		
		label lblGuides01 "____________________" pos:[60,30] width:110 height:15 enabled:false
		label lblGuides02 "____________________" pos:[60,50] width:117 height:15 enabled:false
		label lblGuides03 "____________________" pos:[60,70] width:110 height:15 enabled:false
		label lblGuides04 "\\" pos:[170,40] width:10 height:15 enabled:false
		label lblGuides05 "/" pos:[170,70] width:10 height:15 enabled:false
		
		label lblXYZallLocks "X        Y        Z      XYZ     All" pos:[65,20] width:130 height:15
		
		label lblLocksMove "Move:" pos:[15,35] width:35 height:15
		checkbox chkLocksMoveX "" pos:[60,35] width:15 height:15
		checkbox chkLocksMoveY "" pos:[90,35] width:15 height:15
		checkbox chkLocksMoveZ "" pos:[120,35] width:15 height:15
		checkbox chkLocksMoveAll "" pos:[150,35] width:15 height:15
			
		label lblLocksRotate "Rotate:" pos:[15,55] width:35 height:15
		checkbox chkLocksRotateX "" pos:[60,55] width:15 height:15
		checkbox chkLocksRotateY "" pos:[90,55] width:15 height:15
		checkbox chkLocksRotateZ "" pos:[120,55] width:15 height:15
		checkbox chkLocksRotateAll "" pos:[150,55] width:15 height:15
		
		label lblLocksScale "Sale:" pos:[15,75] width:35 height:15
		checkbox chkLocksScaleX "" pos:[60,75] width:15 height:15
		checkbox chkLocksScaleY "" pos:[90,75] width:15 height:15
		checkbox chkLocksScaleZ "" pos:[120,75] width:15 height:15
		checkbox chkLocksScaleAll "" pos:[150,75] width:15 height:15
		
		checkbox chkLocksAll "" pos:[180,55] width:15 height:15
		
		
		groupBox grpInherit "Inherit" pos:[5,100] width:195 height:90
		
		label lblGuides06 "____________________" pos:[60,125] width:110 height:15 enabled:false
		label lblGuides07 "____________________" pos:[60,145] width:117 height:15 enabled:false
		label lblGuides08 "____________________" pos:[60,165] width:110 height:15 enabled:false
		label lblGuides09 "\\" pos:[170,135] width:10 height:15 enabled:false
		label lblGuides10 "/" pos:[170,165] width:10 height:15 enabled:false
		
		label lblXYZallInherit "X        Y        Z      XYZ     All" pos:[65,115] width:130 height:15
		
		label lblInheritMove "Move:" pos:[15,130] width:35 height:15
		checkbox chkInheritMoveX "" pos:[60,130] width:15 height:15
		checkbox chkInheritMoveY "" pos:[90,130] width:15 height:15
		checkbox chkInheritMoveZ "" pos:[120,130] width:15 height:15
		checkbox chkInheritMoveAll "" pos:[150,130] width:15 height:15
		
		label lblInheritRotate "Rotate:" pos:[15,150] width:35 height:15
		checkbox chkInheritRotateX "" pos:[60,150] width:15 height:15
		checkbox chkInheritRotateY "" pos:[90,150] width:15 height:15
		checkbox chkInheritRotateZ "" pos:[120,150] width:15 height:15
		checkbox chkInheritRotateAll "" pos:[150,150] width:15 height:15
		
		label lblInheritScale "Scale:" pos:[15,170] width:35 height:15
		checkbox chkInheritScaleX "" pos:[60,170] width:15 height:15
		checkbox chkInheritScaleY "" pos:[90,170] width:15 height:15
		checkbox chkInheritScaleZ "" pos:[120,170] width:15 height:15
		checkbox chkInheritScaleAll "" pos:[150,170] width:15 height:15
		
		checkbox chkInheritAll "" pos:[180,150] width:15 height:15
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | getSelectionLocks | obtiene los locks de cada nodo de la seleccion
		------------------------------------------------		
		fn getSelectionLocks =
		(
			locksArray = #()
			
			actualSelection = getCurrentSelection()
			
			--recorre la seleccion actual mirando como tiene los locks y almacenandolos
			for obj in actualSelection do
			(
				newLock = (locksInfo obj:obj)
				
				locks = (getTransformLockFlags obj) as array
				inherits = (lb.misc.getNodeInheritanceFlags obj) as array
				
				newLock.lmX = if findItem locks 1 != 0 then 1 else 0
				newLock.lmY = if findItem locks 2 != 0 then 1 else 0
				newLock.lmZ = if findItem locks 3 != 0 then 1 else 0
				
				newLock.lrX = if findItem locks 4 != 0 then 1 else 0
				newLock.lrY = if findItem locks 5 != 0 then 1 else 0
				newLock.lrZ = if findItem locks 6 != 0 then 1 else 0
				
				newLock.lsX = if findItem locks 7 != 0 then 1 else 0
				newLock.lsY = if findItem locks 8 != 0 then 1 else 0
				newLock.lsZ = if findItem locks 9 != 0 then 1 else 0
				
				
				newLock.imX = if findItem inherits 1 != 0 then 1 else 0
				newLock.imY = if findItem inherits 2 != 0 then 1 else 0
				newLock.imZ = if findItem inherits 3 != 0 then 1 else 0
				
				newLock.irX = if findItem inherits 4 != 0 then 1 else 0
				newLock.irY = if findItem inherits 5 != 0 then 1 else 0
				newLock.irZ = if findItem inherits 6 != 0 then 1 else 0
				
				newLock.isX = if findItem inherits 7 != 0 then 1 else 0
				newLock.isY = if findItem inherits 8 != 0 then 1 else 0
				newLock.isZ = if findItem inherits 9 != 0 then 1 else 0
				
				append locksArray newLock
			)
			
			locksArray
		)

		------------------------------------------------
		--@fn: undefined | getGlobalSelectionLocks | obtiene los locks globales a partir de un array de locks de los nodos seleccionados actualmente
		------------------------------------------------		
		fn getGlobalSelectionLocks locksArray =
		(
			gl = (globalLocksInfo lmx:-1)
			
			
			stop = false --flag para parar de recorrer los locks
			cont = 1 --contador
			
			--obtiene los locks globales, recorre todos los locksInfo averiguando el estado global
			while not stop and cont <= locksArray.count do
			(
				if gl.lmx != 2 then (if gl.lmx !=-1 then (if gl.lmx != locksArray[cont].lmX then gl.lmx = 2) else (gl.lmx = locksArray[cont].lmX ))
				if gl.lmy != 2 then (if gl.lmy !=-1 then (if gl.lmy != locksArray[cont].lmY then gl.lmy = 2) else (gl.lmy = locksArray[cont].lmY ))
				if gl.lmz != 2 then (if gl.lmz !=-1 then (if gl.lmz != locksArray[cont].lmZ then gl.lmz = 2) else (gl.lmz = locksArray[cont].lmZ ))
					
				if gl.lrx != 2 then (if gl.lrx !=-1 then (if gl.lrx != locksArray[cont].lrX then gl.lrx = 2) else (gl.lrx = locksArray[cont].lrX ))
				if gl.lry != 2 then (if gl.lry !=-1 then (if gl.lry != locksArray[cont].lrY then gl.lry = 2) else (gl.lry = locksArray[cont].lrY ))
				if gl.lrz != 2 then (if gl.lrz !=-1 then (if gl.lrz != locksArray[cont].lrZ then gl.lrz = 2) else (gl.lrz = locksArray[cont].lrZ ))
					
				if gl.lsx != 2 then (if gl.lsx !=-1 then (if gl.lsx != locksArray[cont].lsX then gl.lsx = 2) else (gl.lsx = locksArray[cont].lsX ))
				if gl.lsy != 2 then (if gl.lsy !=-1 then (if gl.lsy != locksArray[cont].lsY then gl.lsy = 2) else (gl.lsy = locksArray[cont].lsY ))
				if gl.lsz != 2 then (if gl.lsz !=-1 then (if gl.lsz != locksArray[cont].lsZ then gl.lsz = 2) else (gl.lsz = locksArray[cont].lsZ ))
				
				
				if gl.imx != 2 then (if gl.imx !=-1 then (if gl.imx != locksArray[cont].imX then gl.imx = 2) else (gl.imx = locksArray[cont].imX ))
				if gl.imy != 2 then (if gl.imy !=-1 then (if gl.imy != locksArray[cont].imY then gl.imy = 2) else (gl.imy = locksArray[cont].imY ))
				if gl.imz != 2 then (if gl.imz !=-1 then (if gl.imz != locksArray[cont].imZ then gl.imz = 2) else (gl.imz = locksArray[cont].imZ ))
					
				if gl.irx != 2 then (if gl.irx !=-1 then (if gl.irx != locksArray[cont].irX then gl.irx = 2) else (gl.irx = locksArray[cont].irX ))
				if gl.iry != 2 then (if gl.iry !=-1 then (if gl.iry != locksArray[cont].irY then gl.iry = 2) else (gl.iry = locksArray[cont].irY ))
				if gl.irz != 2 then (if gl.irz !=-1 then (if gl.irz != locksArray[cont].irZ then gl.irz = 2) else (gl.irz = locksArray[cont].irZ ))
					
				if gl.isx != 2 then (if gl.isx !=-1 then (if gl.isx != locksArray[cont].isX then gl.isx = 2) else (gl.isx = locksArray[cont].isX ))
				if gl.isy != 2 then (if gl.isy !=-1 then (if gl.isy != locksArray[cont].isY then gl.isy = 2) else (gl.isy = locksArray[cont].isY ))
				if gl.isz != 2 then (if gl.isz !=-1 then (if gl.isz != locksArray[cont].isZ then gl.isz = 2) else (gl.isz = locksArray[cont].isZ ))
				
				cont +=1
			)
			
			--estado global para XYZ
			gl.lm = if (gl.lmx + gl.lmy + gl.lmz) == 3 then 1 else if (gl.lmx + gl.lmy + gl.lmz) ==0 then 0 else 2
			gl.lr = if (gl.lrx + gl.lry + gl.lrz) == 3 then 1 else if (gl.lrx + gl.lry + gl.lrz) == 0 then 0 else 2
			gl.ls = if (gl.lsx + gl.lsy + gl.lsz) == 3 then 1 else if (gl.lsx + gl.lsy + gl.lsz) == 0 then 0 else 2
			
			gl.im = if (gl.imx + gl.imy + gl.imz) == 3 then 1 else if (gl.imx + gl.imy + gl.imz) == 0 then 0 else 2
			gl.ir = if (gl.irx + gl.iry + gl.irz) == 3 then 1 else if (gl.irx + gl.iry + gl.irz) == 0 then 0 else 2
			gl.is = if (gl.isx + gl.isy + gl.isz) == 3 then 1 else if (gl.isx + gl.isy + gl.isz) == 0 then 0 else 2
			
			--estado global para XYZ y move, rotate, scale
			gl.lall = if (gl.lm + gl.lr + gl.ls) == 3 then 1 else if (gl.lm + gl.lr + gl.ls) ==0 then 0 else 2
			gl.iall = if (gl.im + gl.ir + gl.is) == 3 then 1 else if (gl.im + gl.ir + gl.is) ==0 then 0 else 2
			
			gl
		)	

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | updateSelectionLocks | actualiza los locks de cada objeto seleccionado en funcion de los ticks del interface
		------------------------------------------------		
		fn updateSelectionLocks =
		(
			UIlocksArray = #()
			UIinheritsArray = #()
			
			--rellena los arrays de locks---------------------------------------
			append UIlocksArray chkLocksMoveX.tristate
			append UIlocksArray chkLocksMoveY.tristate
			append UIlocksArray chkLocksMoveZ.tristate	
			
			append UIlocksArray chkLocksRotateX.tristate
			append UIlocksArray chkLocksRotateY.tristate
			append UIlocksArray chkLocksRotateZ.tristate	
			
			append UIlocksArray chkLocksScaleX.tristate
			append UIlocksArray chkLocksScaleY.tristate
			append UIlocksArray chkLocksScaleZ.tristate
			
			
			append UIinheritsArray chkInheritMoveX.tristate
			append UIinheritsArray chkInheritMoveY.tristate
			append UIinheritsArray chkInheritMoveZ.tristate	
			
			append UIinheritsArray chkInheritRotateX.tristate
			append UIinheritsArray chkInheritRotateY.tristate
			append UIinheritsArray chkInheritRotateZ.tristate	
			
			append UIinheritsArray chkInheritScaleX.tristate
			append UIinheritsArray chkInheritScaleY.tristate
			append UIinheritsArray chkInheritScaleZ.tristate
			----------------------------------------------------------------------
			
			--actualiza los locks de cada objeto seleccionado
			for lock in actualLocks do
			(
				locksArray = (getTransformLockFlags lock.obj) --obtiene los locks actuales
				inheritsArray = (lb.misc.getNodeInheritanceFlags lock.obj) --obtiene los locks de inherit actuales
				
				--recorre los locks del ui actualizando los locks de los objetos
				for i=1 to 9 do
				(
					case UIlocksArray[i] of
					(
						0: (if findItem locksArray i != 0 then deleteItem locksArray i)
						1: (if findItem locksArray i == 0 then append locksArray i)
					)
					
					case UIinheritsArray[i] of
					(
						0: (if findItem inheritsArray i != 0 then deleteItem inheritsArray i)
						1: (if findItem inheritsArray i == 0 then append inheritsArray i)
					)	
				)--for 1 to 9
				
				--actualiza los flags en ese objeto
				setTransformLockFlags lock.obj locksArray
				lb.misc.setNodeInheritanceFlags lock.obj inheritsArray
				
			)--for actualLocks		
		)

		------------------------------------------------
		--@fn: undefined | updateUI | actualiza el UI
		------------------------------------------------		
		fn updateUI =
		(
			actualLocks = getSelectionLocks() --obtiene los locks de todas las piezas
			globalLocks = getGlobalSelectionLocks actualLocks --obtiene los locks globales para mostrar
			
			if selection.count != 0 then
			(
				--habilita
				chkLocksMoveX.enabled = true
				chkLocksMoveY.enabled = true
				chkLocksMoveZ.enabled = true
				chkLocksMoveAll.enabled = true
				
				chkLocksRotateX.enabled = true
				chkLocksRotateY.enabled = true
				chkLocksRotateZ.enabled = true
				chkLocksRotateAll.enabled = true
				
				chkLocksScaleX.enabled = true
				chkLocksScaleY.enabled = true
				chkLocksScaleZ.enabled = true
				chkLocksScaleAll.enabled = true
				
				chkLocksAll.enabled = true
				
				chkInheritMoveX.enabled = true
				chkInheritMoveY.enabled = true
				chkInheritMoveZ.enabled = true
				chkInheritMoveAll.enabled = true
				
				chkInheritRotateX.enabled = true
				chkInheritRotateY.enabled = true
				chkInheritRotateZ.enabled = true
				chkInheritRotateAll.enabled = true
				
				chkInheritScaleX.enabled = true
				chkInheritScaleY.enabled = true
				chkInheritScaleZ.enabled = true
				chkInheritScaleAll.enabled = true
				
				chkInheritAll.enabled = true
				
				--coloca los valores
				chkLocksMoveX.tristate = globalLocks.lmx
				chkLocksMoveY.tristate = globalLocks.lmy
				chkLocksMoveZ.tristate = globalLocks.lmz
				chkLocksMoveAll.tristate = globalLocks.lm
				
				chkLocksRotateX.tristate = globalLocks.lrx
				chkLocksRotateY.tristate = globalLocks.lry
				chkLocksRotateZ.tristate = globalLocks.lrz
				chkLocksRotateAll.tristate = globalLocks.lr
				
				chkLocksScaleX.tristate = globalLocks.lsx
				chkLocksScaleY.tristate = globalLocks.lsy
				chkLocksScaleZ.tristate = globalLocks.lsz
				chkLocksScaleAll.tristate = globalLocks.ls
				
				chkLocksAll.tristate = globalLocks.lall
				
				chkInheritMoveX.tristate = globalLocks.imx
				chkInheritMoveY.tristate = globalLocks.imy
				chkInheritMoveZ.tristate = globalLocks.imz
				chkInheritMoveAll.tristate = globalLocks.im
				
				chkInheritRotateX.tristate = globalLocks.irx
				chkInheritRotateY.tristate = globalLocks.iry
				chkInheritRotateZ.tristate = globalLocks.irz
				chkInheritRotateAll.tristate = globalLocks.ir
				
				chkInheritScaleX.tristate = globalLocks.isx
				chkInheritScaleY.tristate = globalLocks.isy
				chkInheritScaleZ.tristate = globalLocks.isz
				chkInheritScaleAll.tristate = globalLocks.is
				
				chkInheritAll.tristate = globalLocks.iall
			)
			else
			(
				--deshabilita
				chkLocksMoveX.enabled = false
				chkLocksMoveY.enabled = false
				chkLocksMoveZ.enabled = false
				chkLocksMoveAll.enabled = false
				
				chkLocksRotateX.enabled = false
				chkLocksRotateY.enabled = false
				chkLocksRotateZ.enabled = false
				chkLocksRotateAll.enabled = false
				
				chkLocksScaleX.enabled = false
				chkLocksScaleY.enabled = false
				chkLocksScaleZ.enabled = false
				chkLocksScaleAll.enabled = false
				
				chkLocksAll.enabled =false
				
				chkInheritMoveX.enabled = false
				chkInheritMoveY.enabled = false
				chkInheritMoveZ.enabled = false
				chkInheritMoveAll.enabled = false
				
				chkInheritRotateX.enabled = false
				chkInheritRotateY.enabled = false
				chkInheritRotateZ.enabled = false
				chkInheritRotateAll.enabled = false
				
				chkInheritScaleX.enabled = false
				chkInheritScaleY.enabled = false
				chkInheritScaleZ.enabled = false
				chkInheritScaleAll.enabled = false
				
				chkInheritAll.enabled = false
				
				--coloca valores
				chkLocksMoveX.tristate = 0
				chkLocksMoveY.tristate = 0
				chkLocksMoveZ.tristate = 0
				chkLocksMoveAll.tristate = 0
				
				chkLocksRotateX.tristate = 0
				chkLocksRotateY.tristate = 0
				chkLocksRotateZ.tristate = 0
				chkLocksRotateAll.tristate = 0
				
				chkLocksScaleX.tristate = 0
				chkLocksScaleY.tristate = 0
				chkLocksScaleZ.tristate = 0
				chkLocksScaleAll.tristate = 0
				
				chkLocksAll.tristate = 0
				
				chkInheritMoveX.tristate = 0
				chkInheritMoveY.tristate = 0
				chkInheritMoveZ.tristate = 0
				chkInheritMoveAll.tristate = 0
				
				chkInheritRotateX.tristate = 0
				chkInheritRotateY.tristate = 0
				chkInheritRotateZ.tristate = 0
				chkInheritRotateAll.tristate = 0
				
				chkInheritScaleX.tristate = 0
				chkInheritScaleY.tristate = 0
				chkInheritScaleZ.tristate = 0
				chkInheritScaleAll.tristate = 0
				
				chkInheritAll.tristate = 0
			)
		)

		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(			
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.addscript #selectionSetChanged "lb.riggingTools.rollRTlocksManager.updateUI()" id:_id
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTlocksManagerDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTlocksManagerDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		--move
		on chkLocksMoveX changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksMoveY changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksMoveZ changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksMoveAll changed state do
		(
			chkLocksMoveX.tristate = chkLocksMoveAll.tristate
			chkLocksMoveY.tristate = chkLocksMoveAll.tristate
			chkLocksMoveZ.tristate = chkLocksMoveAll.tristate
			
			updateSelectionLocks()
			updateUI()
		)
		
		--rotate
		on chkLocksRotateX changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksRotateY changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksRotateZ changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksRotateAll changed state do
		(
			chkLocksRotateX.tristate = chkLocksRotateAll.tristate
			chkLocksRotateY.tristate = chkLocksRotateAll.tristate
			chkLocksRotateZ.tristate = chkLocksRotateAll.tristate
			
			updateSelectionLocks()
			updateUI()
		)
		
		--scale
		on chkLocksScaleX changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksScaleY changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksScaleZ changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksScaleAll changed state do
		(
			chkLocksScaleX.tristate = chkLocksScaleAll.tristate
			chkLocksScaleY.tristate = chkLocksScaleAll.tristate
			chkLocksScaleZ.tristate = chkLocksScaleAll.tristate
			
			updateSelectionLocks()
			updateUI()
		)
		
		on chkLocksAll changed state do
		(
			chkLocksMoveAll.tristate = chkLocksAll.tristate
			chkLocksRotateAll.tristate = chkLocksAll.tristate
			chkLocksScaleAll.tristate = chkLocksAll.tristate
			
			chkLocksMoveX.tristate = chkLocksMoveAll.tristate
			chkLocksMoveY.tristate = chkLocksMoveAll.tristate
			chkLocksMoveZ.tristate = chkLocksMoveAll.tristate
			
			chkLocksRotateX.tristate = chkLocksRotateAll.tristate
			chkLocksRotateY.tristate = chkLocksRotateAll.tristate
			chkLocksRotateZ.tristate = chkLocksRotateAll.tristate
			
			chkLocksScaleX.tristate = chkLocksScaleAll.tristate
			chkLocksScaleY.tristate = chkLocksScaleAll.tristate
			chkLocksScaleZ.tristate = chkLocksScaleAll.tristate
			
			updateSelectionLocks()
			updateUI()
		)
		
		--Inherits
		
		--move
		on chkInheritMoveX changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritMoveY changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritMoveZ changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritMoveAll changed state do
		(
			chkInheritMoveX.tristate = chkInheritMoveAll.tristate
			chkInheritMoveY.tristate = chkInheritMoveAll.tristate
			chkInheritMoveZ.tristate = chkInheritMoveAll.tristate
			
			updateSelectionLocks()
			updateUI()
		)
		
		--rotate
		on chkInheritRotateX changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritRotateY changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritRotateZ changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritRotateAll changed state do
		(
			chkInheritRotateX.tristate = chkInheritRotateAll.tristate
			chkInheritRotateY.tristate = chkInheritRotateAll.tristate
			chkInheritRotateZ.tristate = chkInheritRotateAll.tristate
			
			updateSelectionLocks()
			updateUI()
		)
		
		--scale
		on chkInheritScaleX changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritScaleY changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritScaleZ changed tristate do
		(
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritScaleAll changed state do
		(
			chkInheritScaleX.tristate = chkInheritScaleAll.tristate
			chkInheritScaleY.tristate = chkInheritScaleAll.tristate
			chkInheritScaleZ.tristate = chkInheritScaleAll.tristate
			
			updateSelectionLocks()
			updateUI()
		)
		
		on chkInheritAll changed state do
		(
			chkInheritMoveAll.tristate = chkInheritAll.tristate
			chkInheritRotateAll.tristate = chkInheritAll.tristate
			chkInheritScaleAll.tristate = chkInheritAll.tristate
			
			chkInheritMoveX.tristate = chkInheritMoveAll.tristate
			chkInheritMoveY.tristate = chkInheritMoveAll.tristate
			chkInheritMoveZ.tristate = chkInheritMoveAll.tristate
			
			chkInheritRotateX.tristate = chkInheritRotateAll.tristate
			chkInheritRotateY.tristate = chkInheritRotateAll.tristate
			chkInheritRotateZ.tristate = chkInheritRotateAll.tristate
			
			chkInheritScaleX.tristate = chkInheritScaleAll.tristate
			chkInheritScaleY.tristate = chkInheritScaleAll.tristate
			chkInheritScaleZ.tristate = chkInheritScaleAll.tristate
			
			updateSelectionLocks()
			updateUI()
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTlocksManagerDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTlocksManagerDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			updateUI()
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTlocksManagerDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTlocksManagerDef 

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRThierarchyGradientDef | Contiene la herramienta Hierarchy Gradient.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRThierarchyGradientDef "Hierarchy Gradient"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local gradientR = undefined	--variable para almacenar el mapa de gradiente
		
		local gradientColors				--structo con los colores y los porcentajes de un gradient ramp
		
		struct gradientColors
		(
			colors = #(),			--array de colores
			percents = #()		--array de porcentajes
		)	

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnApply "Apply gradient to Selection" pos:[5,30] width:195 height:20 toolTip:"Apply gradient to hierarchies in selected objects"
		button btnCreateGradient "Create gradient in material editor" pos:[5,5] width:195 height:20 toolTip:"Create new gradient in material editor and open it"
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--GETS
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | getColorsAndPercents | Colores y porcentajes de estos en el gradiente
		------------------------------------------------
		fn getColorsAndPercents gradientMap =
		(
			colors = #()		--array para los colores
			percents = #()	--array para los porcentajes
			
			if classof gradientMap == Gradient_Ramp then --se asegura que el mapa pasado es un gradient ramp
			(
				--arrays temporales
				local tempColors = #()
				local tempPercents = #()
				
				--obtiene los colores y los porcentajes---------------------------------------------------
				tempColors[1] = (gradientMap.gradient_ramp)[2].color as color
				tempPercents[1] = 0.0
				
				tempColors[2] = (gradientMap.gradient_ramp)[3].color as color
				tempPercents[2] = 1.0
				
				for i=4 to ((gradientMap.gradient_ramp).numSubs - 2) do
				(
					tempColors[i-1] = (gradientMap.gradient_ramp)[i].color as color
					tempPercents[i-1] = (((gradientMap.gradient_ramp)[i].position)/100.0)
				)
				-----------------------------------------------------------------------------------------------
				
				--ordena los colores segun el porcentaje---------------------------------------------------
				percents = deepCopy tempPercents --copiamos los porcentajes para ordenarlos sin perder como estaban inicialmente
				sort percents --los ordena
				
				for i=1 to percents.count do
				(
					index = findItem tempPercents percents[i]
					colors[i] = tempColors[index]
				)
				-----------------------------------------------------------------------------------------------
			)			
			
			colorsAndPercents = (gradientColors colors:colors percents:percents) --rellena el struct
			
			colorsAndPercents --devuelve los colores y los porcentajes
		)		

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
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRThierarchyGradientDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRThierarchyGradientDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | crea un gradiente en el editor de materiales y lo abre, si ya esta creado lo usa
		------------------------------------------------		
		on btnCreateGradient pressed do
		(
			if classof meditMaterials[1] != Gradient_Ramp then
			(
				gradientR = meditMaterials[1] = Gradient_Ramp()
				gradientR.name = "hierarchy_gradient"
			)
			else
				gradientR = meditMaterials[1]
			
			--for i=2 to 24 do
				--meditMaterials[i] = standardMaterial()
			
			max mtledit --abre el editor
		)

		------------------------------------------------
		--@event: pressed | aplica el gradiente
		------------------------------------------------		
		on btnApply pressed do
		(
			--if gradientR == undefined	then
			--(
				if classof meditMaterials[1] == Gradient_Ramp then
					gradientR = meditMaterials[1]
				else
				(
					gradientR = meditMaterials[1] = Gradient_Ramp()
					gradientR.name = "hierarchy_gradient"
				)
			--)
			
			--for i=2 to 24 do
				--meditMaterials[i] = standardMaterial()
			
			max mtledit --abre el editor
			
			colorsAndPercents = getColorsAndPercents gradientR --obtiene los colores y los porcentajes del gradiente de colores
			
			undo "Apply Gradient Ramp" on
				lb.rig.applyGradientRamp (getCurrentSelection()) colorsAndPercents.colors colorsAndPercents.percents --aplica los colores a la jerarquia
		)		

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRThierarchyGradientDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRThierarchyGradientDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRThierarchyGradientDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRThierarchyGradientDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTbonesFromToPointsDef | Contiene la herramienta Bones From To Points.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTbonesFromToPointsDef "Bones From To Points"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local iconpath = lb.config.getIconsPath()

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnPointsFromBones "" pos:[5,5] width:30 height:30 tooltip:"Create Points from selected Bones" images:#(iconpath+"EditMesh_24i.bmp",undefined,10,1,1,1,1,true)
		label lblClassTypePoints "class:" pos:[40,13]
		dropDownList ddlClassTypePoints "" pos:[70,9] width:45 height:10 items:#("",lb.nc.NC_classAnim, lb.nc.NC_classSkin)
		label lblSufixPoints "sufix:" pos:[117,13]
		edittext edtSufixPoints "" pos:[140,9] width:65 height:20
		
		button btnBonesFromPoints "" pos:[5,40] width:30 height:30 tooltip:"Create Bones from selected Points" images:#(iconpath+"EditMesh_24i.bmp",undefined,10,2,2,2,2,true)
		label lblClassTypeBones "class:" pos:[40,48]
		dropDownList ddlClassTypeBones "" pos:[70,44] width:45 height:10 items:#("",lb.nc.NC_classAnim, lb.nc.NC_classSkin)
		label lblSufixBones "sufix:" pos:[117,48]
		edittext edtSufixBones "" pos:[140,44] width:65 height:20
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTbonesFromToPointsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTbonesFromToPointsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | crea points a partir de los objetos seleccionados
		------------------------------------------------
		on btnPointsFromBones pressed do
		(
			pointHierarchies = #()
			hierarchies = lb.rig.getHierarchiesFromNodes (getCurrentSelection()) --obtenermos las jerarquias contenidas en la seleccion
				
			for i=1 to hierarchies.count do
				pointHierarchies[i] = lb.rig.createPointsFromHierarchy hierarchies[i] classType:ddlClassTypePoints.selected sufix:edtSufixPoints.text
			
			clearSelection()
			for ph in pointHierarchies do
				selectMore ph[1]
		)

		------------------------------------------------
		--@event: pressed | crea huesos a partir de los points seleccionados
		------------------------------------------------		
		on btnBonesFromPoints pressed do
		(
			boneHierarchies = #()
			hierarchies = lb.rig.getHierarchiesFromNodes (getCurrentSelection()) --obtenermos las jerarquias contenidas en la seleccion
			
			for i=1 to hierarchies.count do
				boneHierarchies[i] = lb.rig.createBonesFromPointHierarchy hierarchies[i] classType:ddlClassTypeBones.selected sufix:edtSufixBones.text
			
			clearSelection()
			for b in boneHierarchies do
				selectMore b[1]
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTbonesFromToPointsDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTbonesFromToPointsDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTbonesFromToPointsDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTbonesFromToPointsDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTstretchBoneChainDef | Contiene la herramienta Automatism: Stretch Bone Chain.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTstretchBoneChainDef "Automatism: Stretch Bone Chain"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnCreateStretchBoneChain "Create Stretch Bone Chain" pos:[5,5] height:20 width:195 tooltip:"Create Stretch Bone Chain: You have to select source bone chain"
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTstretchBoneChainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTstretchBoneChainDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | crea el sistema de stretch en la cadena de huesos
		------------------------------------------------		
		on btnCreateStretchBoneChain pressed do
		(
			_sel = getCurrentSelection() --obtiene la seleccion actual
			
			if _sel.count > 1 then
			(
				lb.rig.createStretchBoneChain _sel 			
			)
			else
				lb.message.show "You must select at least two bones" type:#message pos:undefined size:[300,75] modal:true

		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTstretchBoneChainDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTstretchBoneChainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTstretchBoneChainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTstretchBoneChainDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTskinConnectionInfoDef | Contiene la herramienta Skin Connection Info.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTskinConnectionInfoDef "Skin Connection Info"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label lblSeparator_00 "____________________________________" pos:[5,40] width:200 height:15 enabled:false
		label lblSeparator_01 "____________________________________" pos:[5,60] width:200 height:15 enabled:false
		label lblSeparator_03 "____________________________________" pos:[5,80] width:200 height:15 enabled:false
		
		checkbox chkPosConstraint		"Connection Pos"	pos:[5,5]		width:140 height:15
		button btnApplyPosConstraint	"Apply"				pos:[150,5]		width:50 height:15
		checkbox chkRotConstraint		"Connection Rot"	pos:[5,20]		width:140 height:15
		button btnApplyRotConstraint	"Apply"				pos:[150,20]	width:50 height:15
		checkbox chkScaleConstraint		"Connection Sca"	pos:[5,35]		width:140 height:15
		button btnApplyScaleConstraint	"Apply"				pos:[150,35]	width:50 height:15
		
		checkbox chkHeadSystem			"HeadSystem"		pos:[5,55]		width:140 height:15
		button btnApplyHeadSystem		"Apply"				pos:[150,55]	width:50 height:15
		
		checkbox chkKeepConnected		"KeepConnected"		pos:[5,75]		width:140 height:15
		button btnApplyKeepConnected	"Apply"				pos:[150,75]	width:50 height:15
		
		button btnApply					"Apply"				pos:[5,100]		width:50 height:20 tooltip:"Applies skinConnectionInfo. Removes previous Info"
		button btnRemove				"Remove"			pos:[60,100]	width:50 height:20
		button btnAskSelected			"Ask Selected"		pos:[130,100]	width:70 height:20
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTskinConnectionInfoDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTskinConnectionInfoDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | añade o sustituye el valor en custom atribute
		------------------------------------------------	
		on btnApplyPosConstraint pressed do
		(
			for _o in selection do
			(
				if not lb.skinConnectionInfo.hasSkinConnectionInfo _o then
					lb.skinConnectionInfo.addAttribute _o
				
				lb.skinConnectionInfo.setSkinConnectionInfo _o #connectionPos chkPosConstraint.checked 
			)
			
			lb.riggingTools.rollRTskinConnectionInfoCheck.fillLists()
		)

		------------------------------------------------
		--@event: pressed | añade o sustituye el valor en custom atribute
		------------------------------------------------	
		on btnApplyRotConstraint pressed do
		(
			for _o in selection do
			(
				if not lb.skinConnectionInfo.hasSkinConnectionInfo _o then
					lb.skinConnectionInfo.addAttribute _o
				
				lb.skinConnectionInfo.setSkinConnectionInfo _o #connectionRot chkRotConstraint.checked 
			)
			
			lb.riggingTools.rollRTskinConnectionInfoCheck.fillLists()
		)

		------------------------------------------------
		--@event: pressed | añade o sustituye el valor en custom atribute
		------------------------------------------------		
		on btnApplyScaleConstraint pressed do
		(
			for _o in selection do
			(
				if not lb.skinConnectionInfo.hasSkinConnectionInfo _o then
					lb.skinConnectionInfo.addAttribute _o
				
				lb.skinConnectionInfo.setSkinConnectionInfo _o #connectionSca chkScaleConstraint.checked 
			)
			
			lb.riggingTools.rollRTskinConnectionInfoCheck.fillLists()
		)

		------------------------------------------------
		--@event: pressed | añade o sustituye el valor en custom atribute
		------------------------------------------------		
		on btnApplyHeadSystem pressed do
		(
			for _o in selection do
			(
				if not lb.skinConnectionInfo.hasSkinConnectionInfo _o then
					lb.skinConnectionInfo.addAttribute _o
				
				lb.skinConnectionInfo.setSkinConnectionInfo _o #headSystem chkHeadSystem.checked 
			)
			
			lb.riggingTools.rollRTskinConnectionInfoCheck.fillLists()
		)

		------------------------------------------------
		--@event: pressed | añade o sustituye el valor en custom atribute
		------------------------------------------------		
		on btnApplyKeepConnected pressed do
		(
			for _o in selection do
			(
				if not lb.skinConnectionInfo.hasSkinConnectionInfo _o then
					lb.skinConnectionInfo.addAttribute _o
				
				lb.skinConnectionInfo.setSkinConnectionInfo _o #keepConnected chkKeepConnected.checked 
			)
			
			lb.riggingTools.rollRTskinConnectionInfoCheck.fillLists()
		)

		------------------------------------------------
		--@event: pressed | añade o sustituye el custom atribute
		------------------------------------------------		
		on btnApply pressed do
		(
			lb.skinConnectionInfo.addAttribute (getCurrentSelection())
			
			lb.skinConnectionInfo.setSkinConnectionInfo (getCurrentSelection()) #connectionPos chkPosConstraint.checked 
			lb.skinConnectionInfo.setSkinConnectionInfo (getCurrentSelection()) #connectionRot chkRotConstraint.checked 
			lb.skinConnectionInfo.setSkinConnectionInfo (getCurrentSelection()) #connectionSca chkScaleConstraint.checked 
			
			lb.skinConnectionInfo.setSkinConnectionInfo (getCurrentSelection()) #headSystem chkHeadSystem.checked 
			
			lb.skinConnectionInfo.setSkinConnectionInfo (getCurrentSelection()) #keepConnected chkKeepConnected.checked
			
			lb.riggingTools.rollRTskinConnectionInfoCheck.fillLists()
		)

		------------------------------------------------
		--@event: pressed | borra el custom attribute
		------------------------------------------------		
		on btnRemove pressed do
		(
			lb.skinConnectionInfo.removeAttribute (getCurrentSelection())

			lb.riggingTools.rollRTskinConnectionInfoCheck.fillLists()
		)

		------------------------------------------------
		--@event: pressed | consulta el estado del custom attribute para los objetos seleccionados
		------------------------------------------------		
		on btnAskSelected pressed do
		(
			createDialog lb.riggingTools.rollRTskinConnectionInfoCheck style:#(#style_border,#style_titlebar,#style_minimizebox, #style_sysmenu) lockwidth:true lockheight:true pos:[200,100]
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTskinConnectionInfoDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTskinConnectionInfoDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTskinConnectionInfoDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTskinConnectionInfoDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTskinConnectionInfoCheckDef | Contiene la herramienta Skin Connection Info Check.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTskinConnectionInfoCheckDef "Skin Connection Info Check" 
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 585	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		listBox lbxObjects			"Node"						pos:[5,5] width:250 height:10		
		listBox lbxSkinConnection	"posConst    rotConst    scaleConst    headSystem    keepConnected"	pos:[255,5] width:325 height:10
		button btnClose "Close" pos:[5,160] width:575 height:30
		
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
		--@fn: undefined | fillLists | rellena los listados con la informacion de skinConnectionInfo de la seleccion
		------------------------------------------------
		fn fillLists =
		(
			nodes = #()
			items = #()
			cont = 1
			for obj in selection do
			(
				append nodes (cont as string  + " - " + obj.name)
				if lb.skinConnectionInfo.hasSkinConnectionInfo obj then
				(
					info = cont as string + " - "
					info += (obj.skinConnectionInfo.connectionPos as string) + (if (obj.skinConnectionInfo.connectionPos) then " " else "")
					info += "          " + (obj.skinConnectionInfo.connectionRot as string) + (if (obj.skinConnectionInfo.connectionRot) then " " else "")
					info += "          " + (obj.skinConnectionInfo.connectionSca as string) + (if (obj.skinConnectionInfo.connectionSca) then " " else "")
					info += "              " + (obj.skinConnectionInfo.headSystem as string) + (if (obj.skinConnectionInfo.headSystem) then " " else "")
					info += "                 " + (obj.skinConnectionInfo.keepConnected as string) + (if (obj.skinConnectionInfo.keepConnected) then " " else "")
					
					append items info
				)
				else
					append items (cont as string + " ---------          -------          -------              -------                 -------")
				
				cont +=1
			)
			lbxObjects.items = nodes
			lbxSkinConnection.items = items
		)

		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			
			callbacks.addscript #selectionSetChanged "lb.riggingTools.rollRTskinConnectionInfoCheck.fillLists()" id:_id
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTskinConnectionInfoCheckDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTskinConnectionInfoCheckDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | cierra el rollout
		------------------------------------------------
		on btnClose pressed do
		(
			removeSceneEvents()
			destroyDialog lb.riggingTools.rollRTskinConnectionInfoCheck
		)

		------------------------------------------------
		--@event: selected | selecciona un elemento del listado
		------------------------------------------------
		on lbxObjects selected index do
		(
			lbxSkinConnection.selection = index
		)

		------------------------------------------------
		--@event: selected | selecciona un elemento del listado
		------------------------------------------------		
		on lbxSkinConnection selected index do
		(
			lbxObjects.selection = index
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTskinConnectionInfoCheckDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTskinConnectionInfoCheckDef open do
		(
			loadSettings()
			fillLists()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTskinConnectionInfoCheckDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTskinConnectionInfoCheckDef	

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTBoneToolsDef | Contiene la herramienta Bone Tools.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTBoneToolsDef "Bone Tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local created = #()
		local selected = #()
		local checkNonBones = true
		local boneEditModeTurnedOnByMe = false

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		timer tmrCreateBone interval:100 active:true
		timer tmrRefinebone interval:100 active:true
		timer tmrBoneEditMode interval:100 active:true
		
		groupBox grpBoneTools "Bone Tools" pos:[5,5] width:95 height:90
		checkbutton ckbCreateBone "Create Bones" pos:[10,20] width:85 height:20 tooltip:"Create Bones"
		checkbutton ckbRefineBone "Refine" pos:[10,45] width:85 height:20 tooltip:"Enters refine bone mode"
		button btnCreateEnd "Create End" pos:[10,70] width:85 height:20 tooltip:"Create End Bone for selection"
		
		groupBox grpBoneEditMode "Bone Position" pos:[105,5] width:95 height:40
		checkbutton ckbBoneEditMode "Bone Edit Mode" pos:[110,20] width:87 height:20 tooltip:"Toggle Bone Edit Mode"
		
		groupBox grpMirrorBones "Mirror Bones" pos:[5,100] width:197 height:95
		radiobuttons rdoMirrorAxis pos:[10,117] width:90 height:80 labels:#("X", "XY", "Y", "YZ", "Z", "ZX") columns:2
		checkbox  chkOffset "Keep Offset" pos:[100,117] tooltip:"Mantain Offset from [0,0,0]" checked:true
		checkbox  chkFlipAxis "Flip Axis (XZ)" pos:[100,137] tooltip:"Flip Axis" checked:true		
		button btnMirrorPrev "Preview" pos:[10 ,170] width:60 height:20
		button btnMirrorOK "OK" pos:[75 ,170] width:55 height:20 enabled:false
		button btnMirrorCancel "Cancel" pos:[135,170] width:60 height:20 enabled:false
		
		groupBox grpFlipAxis "Flip" pos:[5,200] width:197 height:68
		label lblXYZ "X      Y      Z" pos:[14,215] width:60 height:15
		checkbox  chkXaxis pos:[12,230] checked:true
		checkbox  chkYaxis pos:[37,230] checked:false
		checkbox  chkZaxis pos:[62,230] checked:true
		label lblAxis "Axis" pos:[90,230] width:60 height:15
		checkbox  chkXvis pos:[12,245] checked:true
		checkbox  chkYvis pos:[37,245] checked:false
		checkbox  chkZvis pos:[62,245] checked:false
		label lblVis "Visualization" pos:[90,245] width:60 height:15
		button btnFlip "Flip" pos:[155,230] width:40 height:30 tooltip:"Flip Axis or Visualization"
		
		groupBox grpIKplane "IK Plane" pos:[5,273] width:197 height:45
		checkbutton pckIKbones "pick IK plane components" pos:[28,290] width:150 height:20 tooltip:"Start picking IK plane components"
		
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

		----------------------------------------------------------------------------------------------------------------
		-- Comprueba que el objeto pasado por parametro es un hueso
		fn pickBoneTest obj =
		(
			(classof obj.baseObject) == BoneGeometry
		)--fn pickObjTest		

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
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTBoneToolsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTBoneToolsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: changed | entra en el modo de creacion de huesos
		------------------------------------------------
		on ckbCreateBone changed state do
		(
			if state then
			(
				StartObjectCreation Bones
				tmrCreateBone.active = true
			)
			else if isCreatingObject Bones do 
				StopCreating()
		)
		
		on tmrCreateBone tick do
		(
			if not isCreatingObject Bones then
			(
				ckbCreateBone.checked = false
				tmrCreateBone.active = false
			)
			else
				ckbCreateBone.checked = true
		)

		------------------------------------------------
		--@event: changed | entra en el modo de refinado de huesos
		------------------------------------------------
		on ckbRefineBone changed state do
		(
			bonesys.RefineBone()
			
			if state do tmrRefinebone.active = true
		)

		on tmrRefinebone tick do
		(
			if toolmode.commandmode != #pick and toolmode.commandmode != #viewport do 
			(
				ckbRefineBone.checked = false
				tmrRefinebone.active = false
			)
		)

		------------------------------------------------
		--@event: changed | entra en el modo de refinado de huesos
		------------------------------------------------		
		on ckbBoneEditMode changed state do
		(
			if state then
			(
				boneEditModeTurnedOnByMe = true
				maxops.affectchildren = false
				if isCreatingObject Bones do 
					StopCreating()
			)
			else
			(
				boneEditModeTurnedOnByMe = false
				maxops.affectchildren = true
			)
		)
		
		on tmrBoneEditMode tick do
		(
			if ckbBoneEditMode.state == maxops.affectChildren do 
				ckbBoneEditMode.state = (not maxops.affectChildren)
						
			if ckbBoneEditMode.enabled == animButtonState do
				ckbBoneEditMode.enabled = (not animButtonState)
		)

		------------------------------------------------
		--@event: changed | alinea huesos para formar un plano de ik
		------------------------------------------------
		on pckIKbones changed state do
		(
			if pckIKbones.checked then
			(
				success = false
				IkStart = pickObject filter:lb.rig.pickBoneTest --coge el primer hueso
				IkEnd = undefined

				if IkStart != undefined then IkEnd = pickObject rubberBand:IkStart.pos rubberBandColor:white filter:lb.rig.pickBoneTest --coge el segundo hueso
				if IkStart != undefined and IkEnd != undefined then
				(
					success = lb.rig.fixIKplane IkStart IkEnd --coloca los huesos en el mismo plano de ik
				)

				if not success then --si no lo ha conseguido
					lb.message.show "You haven't selected bones or selected Bones aren't part off a viable three bone IK Plane" type:#message pos:undefined size:[300,75] modal:true
				
				pckIKbones.checked = false
			)
		)

		------------------------------------------------
		--@event: pressed | crea un end en los huesos seleccionados
		------------------------------------------------		
		on btnCreateEnd pressed do
		(
			if selection.count > 0 then
			(
				selBones = getCurrentSelection()
				ends = #()
				undo "Create End" on
				(
					for x in selBones do
					(
						end = lb.rig.smartCreateEnd x
						if end != undefined then
							append ends end
					)
																
					redrawViews()
						
					if ends.count != 0 then
						clearselection()
						for x in ends do
							selectMore x	
				)--undo
			)
		)

		------------------------------------------------
		--@event: pressed | hace flip en los huesos seleccionados
		------------------------------------------------		
		on btnFlip pressed do
		(
			if selection.count > 0 then
			(
				undo "Flip Axis" on
				(
					sel = getCurrentSelection()
					--lb.rig.flipAxis sel chkFlipX.checked chkFlipY.checked chkFlipZ.checked chkFlipVisualOnly.checked
					lb.rig.flipAxis sel chkXaxis.checked chkYaxis.checked chkZaxis.checked
					lb.rig.flipVis sel chkXvis.checked chkYvis.checked chkZvis.checked
				)
			)
		)

		------------------------------------------------
		--@event: pressed | crea la cadena de huesos invertida como preview
		------------------------------------------------		
		on btnMirrorPrev pressed do
		(
			for x in selection do
				append selected x
			
			if selected.count > 0 then
			(
				created = lb.rig.callMirror rdoMirrorAxis.state created chkOffset.checked
				if chkFlipAxis.checked and (rdoMirrorAxis.state==1 or rdoMirrorAxis.state==3 or rdoMirrorAxis.state==5) then
				(
					lb.rig.flipVis created true false false
					lb.rig.flipAxis created true false true
				)
				for x in created do
					lb.controller.freezeTransform x #all
				
				if created.count == 0 then
				(
					btnMirrorOK.enabled = false
					btnMirrorCancel.enabled = false
					btnMirrorPrev.enabled = true
				)
				else
				(
					btnMirrorOK.enabled = true
					btnMirrorCancel.enabled = true
					btnMirrorPrev.enabled = false
				)
			)
		)

		------------------------------------------------
		--@event: pressed | acepta la cadena de huesos inversa
		------------------------------------------------		
		on btnMirrorOK pressed do
		(
			btnMirrorOK.enabled = false
			btnMirrorCancel.enabled = false
			btnMirrorPrev.enabled = true
			
			if selection.count == 0 then
				select selected
			created = #()
			selected= #()
		)	

		------------------------------------------------
		--@event: pressed | cancela la cadena de huesos inversa
		------------------------------------------------				
		on btnMirrorCancel pressed do
		(
			lb.rig.unMirror created selected
			btnMirrorOK.enabled = false
			btnMirrorCancel.enabled = false
			btnMirrorPrev.enabled = true
			created = #()
			selected= #()
		)

		------------------------------------------------
		--@event: changed | cambia los ejes de mirror
		------------------------------------------------				
		on rdoMirrorAxis changed state do
		(
			if btnMirrorOK.enabled then
			(
				lb.rig.unMirror created selected
				created = lb.rig.callMirror rdoMirrorAxis.state created chkOffset.checked
				if chkFlipAxis.checked and (rdoMirrorAxis.state==1 or rdoMirrorAxis.state==3 or rdoMirrorAxis.state==5) then
				(
					lb.rig.flipAxis created true false true
					lb.rig.flipVis created true false false
				)
				for x in created do
					lb.controller.freezeTransform x #all
				if created.count == 0 then
				(
					btnMirrorOK.enabled = false
					btnMirrorCancel.enabled = false
					btnMirrorPrev.enabled = true
				)
			)
		)

		------------------------------------------------
		--@event: changed | indica si se debe mantener el offset o no
		------------------------------------------------
		on chkOffset changed state do
		(
			if btnMirrorOK.enabled then
			(
				lb.rig.unMirror created selected
				created = lb.rig.callMirror rdoMirrorAxis.state created chkOffset.checked
				if chkFlipAxis.checked and (rdoMirrorAxis.state==1 or rdoMirrorAxis.state==3 or rdoMirrorAxis.state==5) then
				(
					lb.rig.flipAxis created true false true
					lb.rig.flipVis created true false false
				)
				for x in created do
					lb.controller.freezeTransform x #all
				if created.count == 0 then
				(
					btnMirrorOK.enabled = false
					btnMirrorCancel.enabled = false
					btnMirrorPrev.enabled = true
				)
			)
		)

		------------------------------------------------
		--@event: changed | indica si se deben invertir los ejes
		------------------------------------------------		
		on chkFlipAxis changed state do
		(
			if btnMirrorOK.enabled then
			(
				lb.rig.unMirror created selected
				created = lb.rig.callMirror rdoMirrorAxis.state created chkOffset.checked
				if chkFlipAxis.checked and (rdoMirrorAxis.state==1 or rdoMirrorAxis.state==3 or rdoMirrorAxis.state==5) then
				(
					lb.rig.flipAxis created true false true
					lb.rig.flipVis created true false false
				)
				for x in created do
					lb.controller.freezeTransform x #all
				if created.count == 0 then
				(
					btnMirrorOK.enabled = false
					btnMirrorCancel.enabled = false
					btnMirrorPrev.enabled = true
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
		on rollRTBoneToolsDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTBoneToolsDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTBoneToolsDef close do
		(
			removeSceneEvents() --elimina los callbacks

			if boneEditModeTurnedOnByMe do
			(
				boneEditModeTurnedOnByMe = false
				maxops.affectchildren = true   
			)

			saveSettings()
		)
	)--rollRTBoneToolsDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTfinAdjustmentToolsDef | Contiene la herramienta Bone Fine Adjustment Tools.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTfinAdjustmentToolsDef "Bone Fine Adjustment Tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpMainProperties "Main Properties" pos:[5,5] width:195 height:65
		
		label lblBoneWidth "Width:" pos:[15,25]
		spinner spnBoneWidth pos:[50,25] width:50 range:[-1e+030,1e+030,5]
		label lblBoneHeight "Height:" pos:[15,45]
		spinner spnBoneHeight pos:[50,45] width:50 range:[-1e+030,1e+030,10]
		label lblBoneTaper "Taper:" pos:[110,25]
		spinner spnBoneTaper pos:[145,25] width:50 range:[-1e+030,1e+030,0.9]
		
		
 		groupBox grpFins "Fins" pos:[5,75] width:195 height:225
		
 		label lblSideSize "Size:" pos:[120,95]
		spinner spnSideSize pos:[145,95] width:50 range:[-1e+030,1e+030,5]
		label lblSideStart "Start Taper:" pos:[85,115]
		spinner spnSideStart pos:[145,115] width:50 range:[-1e+030,1e+030,0.1]
		label lblSideEnd "End Taper:" pos:[90,135]
		spinner spnSideEnd pos:[145,135] width:50 range:[-1e+030,1e+030,0.1]
		
		
 		label lblFrontSize "Size:" pos:[120,165]
		spinner spnFrontSize pos:[145,165] width:50 range:[-1e+030,1e+030,5]
		label lblFrontStart "Start Taper:" pos:[85,185]
		spinner spnFrontStart pos:[145,185] width:50 range:[-1e+030,1e+030,0.1]
		label lblFrontEnd "End Taper:" pos:[90,205]
		spinner spnFrontEnd pos:[145,205] width:50 range:[-1e+030,1e+030,0.1]
		
		
 		label lblBackSize "Size:" pos:[120,235]
		spinner spnBackSize pos:[145,235] width:50 range:[-1e+030,1e+030,5]
		label lblBackStart "Start Taper:" pos:[85,255]
		spinner spnBackStart pos:[145,255] width:50 range:[-1e+030,1e+030,0.1]
		label lblBackEnd "End Taper:" pos:[90,275]
		spinner spnBackEnd pos:[145,275] width:50 range:[-1e+030,1e+030,0.1]
		
		--Cuando vamos navegando por los controles con el tabulador y hay checkboxes max se pierde, así que los pongo al final.
		checkbox chkSideFins "Side Fins" pos:[15,95] width:65 height:15
		checkbox chkFrontFin "Front Fin" pos:[15,165] width:65 height:15
		checkbox chkBackFin "Back Fin" pos:[15,235] width:65 height:15
		
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
		--@fn: undefined | updateUI | actualiza el valor de los controles en funcions de la seleccion
		------------------------------------------------
		fn updateUI =
		(
			--si hay huesos seleccionados
			if selection.count != 0 then
			(
				--habilita los controles---------------------------
				lblBoneWidth.enabled = true
				spnBoneWidth.enabled = true
				lblBoneTaper.enabled = true
				spnBoneTaper.enabled = true
				lblBoneHeight.enabled = true
				spnBoneHeight.enabled = true
				
				chkSideFins.enabled = true
				lblSideSize.enabled = true
				spnSideSize.enabled = true
				lblSideStart.enabled = true
				spnSideStart.enabled = true
				lblSideEnd.enabled = true
				spnSideEnd.enabled = true
				
				chkFrontFin.enabled = true
				lblFrontSize.enabled = true
				spnFrontSize.enabled = true
				lblFrontStart.enabled = true
				spnFrontStart.enabled = true
				lblFrontEnd.enabled = true
				spnFrontEnd.enabled = true
				
				chkBackFin.enabled = true
				lblBackSize.enabled = true
				spnBackSize.enabled = true
				lblBackStart.enabled = true
				spnBackStart.enabled = true
				lblBackEnd.enabled = true
				spnBackEnd.enabled = true
					
				boneCount = 0 --contador de huesos
					
				sumWidth = 0 --suma de ancho de todos los huesos seleccionados
				sumHeight = 0 --suma de altura de todos los huesos seleccionados
				sumTaper = 0 --suma de taper de todos los huesos seleccionados
				
				sumSideSize = 0 --suma...
				sumSideStar = 0 --suma...
				sumSideEnd = 0 --suma...
				
				sumFrontSize = 0 --suma...
				sumFrontStar = 0 --suma...
				sumFrontEnd = 0 --suma...
				
				sumBackSize = 0 --suma...
				sumBackStar = 0 --suma...
				sumBackEnd = 0 --suma...
					
				sideFinsState = 0 --almaena el tristate del check
				frontFinState = 0 --almaena el tristate del check
				backFinState = 0 --almaena el tristate del check
					
				lastBone = undefined --almacena el hueso de la iteracion anterior
					
				--recorre los objetos para luego calcular los valores a aplicar en los controles
				for obj in selection where classof obj.baseObject == BoneGeometry do
				(
					boneCount += 1 --incrementa el contador de huesos
					
					--hace las sumas totales-------------
					sumWidth += obj.width
					sumHeight += obj.height
					sumTaper += obj.taper
					
					sumSideSize += obj.sidefinssize
					sumSideStar += obj.sidefinsstarttaper
					sumSideEnd += obj.sidefinsendtaper
					
					sumFrontSize += obj.frontfinsize
					sumFrontStar += obj.frontfinstarttaper
					sumFrontEnd += obj.frontfinendtaper
					
					sumBackSize += obj.backfinsize
					sumBackStar += obj.backfinstarttaper
					sumBackEnd += obj.backfinendtaper
					
					--si hay hueso anterior con el que comparar
					if lastBone != undefined then
					(
						if sideFinsState != 2 and (obj.sideFins != lastBone.sideFins) then sideFinsState = 2
						if frontFinState != 2 and (obj.frontFin != lastBone.frontFin) then frontFinState = 2
						if backFinState != 2 and (obj.backFin != lastBone.backFin) then backFinState = 2
					)
					else --si o hay hueso anterior
					(
						sideFinsState = if obj.sideFins then 1 else 0
						frontFinState = if obj.frontFin then 1 else 0
						backFinState = if obj.backFin then 1 else 0
					)
					
					lastBone = obj --almacena el hueso actual para la iteracion posterior y asi poder comparar valores
				)--for
				
				if boneCount != 0 then
				(
					--aplica los valores a los controles---------------------------------
					spnBoneWidth.value = sumWidth/boneCount
					spnBoneHeight.value = sumHeight/boneCount
					spnBoneTaper.value = sumTaper/boneCount
					
					spnSideSize.value = sumSideSize/boneCount
					spnSideStart.value = sumSideStar/boneCount
					spnSideEnd.value = sumSideEnd/boneCount
						
					spnFrontSize.value = sumFrontSize/boneCount
					spnFrontStart.value = sumFrontStar/boneCount
					spnFrontEnd.value = sumFrontEnd/boneCount
						
					spnBackSize.value = sumBackSize/boneCount
					spnBackStart.value = sumBackStar/boneCount
					spnBackEnd.value = sumBackEnd/boneCount
					
					chkSideFins.tristate = sideFinsState
					chkFrontFin.tristate = frontFinState
					chkBackFin.tristate = backFinState
				)
				else
				(
					lblBoneWidth.enabled = false
					spnBoneWidth.enabled = false
					lblBoneTaper.enabled = false
					spnBoneTaper.enabled = false
					lblBoneHeight.enabled = false
					spnBoneHeight.enabled = false
					
					chkSideFins.enabled = false
					lblSideSize.enabled = false
					spnSideSize.enabled = false
					lblSideStart.enabled = false
					spnSideStart.enabled = false
					lblSideEnd.enabled = false
					spnSideEnd.enabled = false
					
					chkFrontFin.enabled = false
					lblFrontSize.enabled = false
					spnFrontSize.enabled = false
					lblFrontStart.enabled = false
					spnFrontStart.enabled = false
					lblFrontEnd.enabled = false
					spnFrontEnd.enabled = false
					
					chkBackFin.enabled = false
					lblBackSize.enabled = false
					spnBackSize.enabled = false
					lblBackStart.enabled = false
					spnBackStart.enabled = false
					lblBackEnd.enabled = false
					spnBackEnd.enabled = false
				)--if boneCount
			)
			else
			(
				lblBoneWidth.enabled = false
				spnBoneWidth.enabled = false
				lblBoneTaper.enabled = false
				spnBoneTaper.enabled = false
				lblBoneHeight.enabled = false
				spnBoneHeight.enabled = false
				
				chkSideFins.enabled = false
				lblSideSize.enabled = false
				spnSideSize.enabled = false
				lblSideStart.enabled = false
				spnSideStart.enabled = false
				lblSideEnd.enabled = false
				spnSideEnd.enabled = false
				
				chkFrontFin.enabled = false
				lblFrontSize.enabled = false
				spnFrontSize.enabled = false
				lblFrontStart.enabled = false
				spnFrontStart.enabled = false
				lblFrontEnd.enabled = false
				spnFrontEnd.enabled = false
				
				chkBackFin.enabled = false
				lblBackSize.enabled = false
				spnBackSize.enabled = false
				lblBackStart.enabled = false
				spnBackStart.enabled = false
				lblBackEnd.enabled = false
				spnBackEnd.enabled = false
			)--if selection.count
		)
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.addscript #selectionSetChanged "lb.riggingTools.rollRTfinAdjustmentTools.updateUI()" id:_id
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTfinAdjustmentToolsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTfinAdjustmentToolsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: changed | ancho, alto y taper
		------------------------------------------------	
		on spnBoneWidth changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
			 obj.width = val 			
		)
		
		on spnBoneHeight changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
			 obj.height = val		
		)	

		on spnBoneTaper changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
			 obj.taper = val	
 		)

		------------------------------------------------
		--@event: changed | sidefins
		------------------------------------------------
		on chkSideFins changed state do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do 
			obj.sidefins = (chkSideFins.tristate == 1)	
		)	

		on spnSideSize changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do 
			obj.sidefinssize = val	
		)	

		on spnSideStart changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
 			obj.sidefinsstarttaper = val
		)	

		on spnSideEnd changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
 				obj.sidefinsendtaper = val
 		)

		------------------------------------------------
		--@event: changed | frontfin
		------------------------------------------------					
		on chkFrontFin changed state do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
				obj.frontfin = (chkFrontFin.tristate == 1)
		)	

		on spnFrontSize changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
 			obj.frontfinsize = val
		)	

		on spnFrontStart changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
 			obj.frontfinstarttaper = val
		)

		on spnFrontEnd changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
 			obj.frontfinendtaper = val
 		)

		------------------------------------------------
		--@event: changed | backfin
		------------------------------------------------		
		on chkBackFin changed state do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
			obj.backfin = (chkBackFin.tristate == 1)
		)

		on spnBackSize changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
 			obj.backfinsize = val
		)

		on spnBackStart changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
 			obj.backfinstarttaper = val
		)

		on spnBackEnd changed val do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
 			obj.backfinendtaper = val		
 		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTfinAdjustmentToolsDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTfinAdjustmentToolsDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			updateUI()
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTfinAdjustmentToolsDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTfinAdjustmentToolsDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTbonePropertiesDef | Contiene la herramienta Bone Properties.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTbonePropertiesDef "Bone Properties"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		checkbox chkBoneOn "Bone On" pos:[5,5] width:100
		checkbox chkFreezeLength "Freeze Length" pos:[5,25] width:95
		button btnResetStretch "Reset Stretch" pos:[100,25] width:100 height:15
		
		radiobuttons rdoStretch "Stretch:" pos:[5,55] width:100 labels:#("None", "Scale", "Squash") columns:3
		
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
		--@fn: undefined | updateUI | actualiza el valor de los controles en funcions de la seleccion
		------------------------------------------------
		fn updateUI =
		(
			--si hay huesos seleccionados
			if selection.count != 0 then
			(
				chkBoneOn.enabled = true
				chkFreezeLength.enabled = true
				btnResetStretch.enabled = true
				rdoStretch.enabled = true
				
				boneOnState = 0
				freezeLengthState = 0
				sretchState = 0
				
				lastBone = undefined --hueso procesado en el bucle anterior
				
				for obj in selection where classof obj.baseObject == BoneGeometry do
				(
					--si hay hueso anterior con el que comparar
					if lastBone != undefined then
					(
						if boneOnState != 2 and (obj.boneEnable != lastBone.boneEnable) then boneOnState = 2
						if freezeLengthState != 2 and (obj.boneFreezeLength != lastBone.boneFreezeLength) then freezeLengthState = 2
						if sretchState != 0 and (obj.boneScaleType != lastBone.boneScaleType) then sretchState = 0
					)
					else --si o hay hueso anterior
					(
						boneOnState = if obj.boneEnable then 1 else 0
						freezeLengthState = if obj.boneFreezeLength then 1 else 0
						
						case obj.boneScaleType of
						(
							#none:		sretchState = 1
							#scale:		sretchState = 2
							#squash:	sretchState = 3
						)
					)
					
					lastBone = obj --almacena el hueso actual para la iteracion posterior y asi poder comparar valores
				)
				
				chkBoneOn.tristate = boneOnState
				chkFreezeLength.tristate = freezeLengthState
				
				rdoStretch.state = sretchState
					
				if chkBoneOn.tristate != 1 then
				(
					chkFreezeLength.enabled = false
					btnResetStretch.enabled = false
					rdoStretch.enabled = false
				)
			)
			else --si no hay huesos seleccionados
			(
				chkBoneOn.enabled = false
				chkFreezeLength.enabled = false
				btnResetStretch.enabled = false
				rdoStretch.enabled = false
			)
		)

		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.addscript #selectionSetChanged "lb.riggingTools.rollRTboneProperties.updateUI()" id:_id	
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTbonePropertiesDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTbonePropertiesDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		on chkBoneOn changed state do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
				obj.boneEnable = (chkBoneOn.tristate == 1)
			updateUI()
		)
		
		on chkFreezeLength changed state do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
				obj.boneFreezeLength = (chkFreezeLength.tristate == 1)
		)

		on rdoStretch changed state do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
				case rdoStretch.state of
				(
					1:	obj.boneScaleType = #none
					2:	obj.boneScaleType = #scale
					3:	obj.boneScaleType = #squash
				)
		)

		on btnResetStretch pressed do
		(
			for obj in selection where classof obj.baseObject == BoneGeometry do
				obj.resetBoneStretch()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTbonePropertiesDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTbonePropertiesDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTbonePropertiesDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTbonePropertiesDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTBoneOffsetsDef | Contiene la herramienta Bone Offsets.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTBoneOffsetsDef "Bone Offsets"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local bonesToFix = #()
		local bonesToFixName = #()
		local bonesNewLength = #()
		local iconpath = lb.config.getIconsPath()

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		groupBox grpSearchRange "Offset range" pos:[5,5] width:85 height:60
		spinner spnMin "Min " pos:[10,23] range:[0.0,1,0.001] type:#float scale:0.001 fieldwidth:40
		spinner spnMax "Max" pos:[10,43] range:[0.001,1,0.1] type:#float scale:0.001 fieldwidth:40
		button btnClean "Clean list" pos:[100,12] width:97 height:20 tooltip:"Clean list"
		button btnSearch "Search" pos:[100,43] width:47 height:20 tooltip:"Search bones with length offset"
		pickbutton pckAdd "+" pos:[152,43] width:20 height:20 tooltip:"Pick bone"
		button btnDelete "" pos:[177,43] width:20 height:20 images:#(iconpath + "MeditTools_i.bmp", undefined, 44, 7, 7, 8, 8,true)  tooltip:"Delete selected bone from list"
		listbox lbxOffsetBones pos:[5,70] width:195 height:10 readOnly:false
		button btnFix "Fix" pos:[100,210] width:100 height:30 tooltip:"Fix offset"
		radiobuttons rdoSelection pos:[5,210] width:90 height:25 labels:#("All", "Selected") default:1 columns:1
		
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
		--@fn: undefined | updateUI | habilita o deshabilita los controles segun haya o no elementos en la lista
		------------------------------------------------
		fn updateUI =
		(
			enabled = false
			
			bonesToFixName = #()
			for o in bonesToFix do
			(
				if lb.nc.ncOK o.name then
				(
					nameParts = filterstring o.name "_"
					append bonesToFixName (nameParts[3] + "_" + nameParts[4] + "_" + nameParts[5])
				)
				else
					append bonesToFixName o.name
			)
			
			lbxOffsetBones.items = #()
			lbxOffsetBones.items = for i=1 to bonesToFix.count collect (bonesToFixName[i] + " - " + (abs(bonesToFix[i].length - bonesNewLength[i]) as string))
			
			if lbxOffsetBones.items.count > 0 then
			(
				enabled = true
				lbxOffsetBones.selection = 1
				select bonesToFix[1]
			)
						
			btnDelete.enabled = enabled
			lbxOffsetBones.enabled = enabled
			btnFix.enabled = enabled
			rdoSelection.enabled = enabled
			--chkAll.enabled = enabled
			--chkSelected.enabled = enabled
		)

		------------------------------------------------
		--@fn: undefined | searchOffsetBones | busca los huesos con offset en la longitud
		------------------------------------------------
		fn searchOffsetBones =
		(
			bonesToFix = #()
			bonesToFixName = #()
			bonesNewLength = #()
			
			minOffset = spnMin.value
			maxOffset = spnMax.value
			
			for o in objects do
			(
				newLength = lb.rig.checkOffset o minOffset maxOffset
				if newLength != undefined then
				(
					if appendIfUnique bonesToFix o then
						append bonesNewLength newLength
				)
			)
			
			updateUI()
		)

		------------------------------------------------
		--@fn: undefined | fixOffset | arregla el offset de un hueso
		------------------------------------------------		
		fn fixOffset boneToFix newLength =
		(
			boneToFix.length = newLength
		)				
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
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTBoneOffsetsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTBoneOffsetsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | borra el listado
		------------------------------------------------
		on btnClean pressed do
		(
			bonesToFix = #()
			bonesNewLength = #()
			updateUI()
		)	

		------------------------------------------------
		--@event: pressed | busca los huesos con offset en la longitud
		------------------------------------------------
		on btnSearch pressed do
		(
			searchOffsetBones()
		)	

		------------------------------------------------
		--@event: selected | selecciona el hueso que se corresponde con el elemento seleccionado del listbox
		------------------------------------------------
		on lbxOffsetBones selected index do
		(
			select bonesToFix[index]
		)

		------------------------------------------------
		--@event: doubleClicked | arregla el offset del hueso seleecionado
		------------------------------------------------
		on lbxOffsetBones doubleClicked index do
		(
			fixOffset bonesToFix[index] bonesNewLength[index]
			clearSelection()
			searchOffsetBones()
		)

		on btnFix pressed do
		(
			if rdoSelection.state == 1 then
			(			
				for i=1 to bonesToFix.count do
					fixOffset bonesToFix[i] bonesNewLength[i]
			)
			else
				fixOffset bonesToFix[lbxOffsetBones.selection] bonesNewLength[lbxOffsetBones.selection]
			
			clearSelection()
			searchOffsetBones()
		)

		------------------------------------------------
		--@event: picked | añade un hueso al listado
		------------------------------------------------
		on pckAdd picked obj do
		(
			if (classOf obj.baseObject == BoneGeometry) then --si es un hueso
			(
				minOffset = spnMin.value
				maxOffset = spnMax.value
				
				newLength = lb.rig.checkOffset obj minOffset maxOffset
				if newLength != undefined then
				(
					if appendIfUnique bonesToFix obj then
						append bonesNewLength newLength
				)
				else
				(
					if appendIfUnique bonesToFix obj then
						append bonesNewLength obj.length
				)
			)
			
			updateUI()
		)

		------------------------------------------------
		--@event: pressed | elimina el hueso seleccionado del listado
		------------------------------------------------
		on btnDelete pressed do
		(
			deleteItem bonesToFix lbxOffsetBones.selection
			deleteItem bonesNewLength lbxOffsetBones.selection
			updateUI()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTBoneOffsetsDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTBoneOffsetsDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			updateUI()
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTBoneOffsetsDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTBoneOffsetsDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTPointConstraintDef | Contiene la herramienta Point Constraint.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTPointConstraintDef "Point Constraint" 
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 30	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local linkVirtualWorld	= undefined

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnAdd		"Add to Selection"			pos:[5,5]		width:95 height:20	tooltip:"Adds Point Constraint."
		button btnRemove	"Remove"	pos:[105,5]	width:95 height:20
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTPointConstraintDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTPointConstraintDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: picked | almacena el mundo virtual
		------------------------------------------------
		on pckVirtualWorld picked obj do
		(
			if isValidNode obj then
			(
				linkVirtualWorld = obj
				pckVirtualWorld.caption = obj.name
			)
		)

		------------------------------------------------
		--@event: pressed | crea el link constraint
		------------------------------------------------		
		on btnAdd pressed do
		(
			_nodes = getCurrentSelection()
			
			lb.links.pointConstraint.add _nodes
			
			-- Operación para actualizar el commandPanel solo cuando está el panel modify activado
			if (getCommandPanelTaskMode()) == #modify then 
			(
				max create mode
				max modify mode
			)

			for n in _nodes do
			(
				lb.links.pointConstraint.addTarget n undefined frameNo:0
			)
			lb.message.show "Point constraint applied correctly" type:#message pos:undefined size:[300,75] modal:true	
		)--on

		------------------------------------------------
		--@event: pressed | elimina el link constraint
		------------------------------------------------		
		on btnRemove pressed do
		(	
			_nodes = getCurrentSelection()
			
			lb.links.pointConstraint.remove _nodes	
			lb.message.show "Point constraint deleted correctly" type:#message pos:undefined size:[300,75] modal:true
		)--on

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTPointConstraintDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTPointConstraintDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTPointConstraintDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTPointConstraintDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTpathConstraintDef | Contiene la herramienta Path Constraint.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTpathConstraintDef "Path Constraint Tool"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 30	--@var: minRollHeight | Minimun tool height.

		----------------------------------------------------------------------------------------------------------------
		---------------------------------------------- VARIABLES --------------------------------------------------
		----------------------------------------------------------------------------------------------------------------
		
		local targetObj = undefined 	--objeto a meter el path constraint
		local splinePath = undefined	--spline donde hacer el path constraint
		
		local pathConstraint = undefined --variable donde almacenar el controlador path constraint con el que trabajaremos
		local numVerts = undefined -- variable donde guardar el numero de vertices
		local vertsPercents = undefined -- variable donde almacenar la posicion de los vertices en porcentaje	
		
		----------------------------------------------------------------------------------------------------------------
		---------------------------------------------- CONTROLES -------------------------------------------------
		----------------------------------------------------------------------------------------------------------------
		
		groupBox lblSelectObject "Source Objects" pos:[5,5] width:200 height:55
		pickbutton pckObject "Pick Object" pos:[10,20] width:190 height:15 
		pickbutton pckSpline "Pick Spline" pos:[10,40] width:190 height:15 
		
		spinner spnVertexNumb "Position Vertex" pos:[30,65] width:85 height:15 range:[0,99,1] type:#integer scale:1 fieldWidth:25
		
		button btnOK "OK" pos:[5,90] width:95 height:20 enabled:false
		button btnCancel "Cancel" pos:[105,90] width:95 height:20 enabled:false
		
		----------------------------------------------------------------------------------------------------------------
		---------------------------------------------- FUNCTIONS -------------------------------------------------
		----------------------------------------------------------------------------------------------------------------
		
		--------------------------------------------------------------------------------------
		--	Si el objeto OBJ es de tipo bone o POINT devuelve TRUE. Si no FALSE
		--------------------------------------------------------------------------------------
		fn boneAndPointFilter obj = 
		(
			((boneFilter obj) or (pointFilter obj))
		)

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
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTpathConstraintDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTpathConstraintDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)		

		----------------------------------------------------------------------------------------------------------------
		------------------------------------------------- EVENTS ---------------------------------------------------
		----------------------------------------------------------------------------------------------------------------
		
		----------------------------------------------------------------------------
		-- guarda el objeto bone en una variable y comprueba el nc
		----------------------------------------------------------------------------
		on pckObject picked obj do
		(
			if isValidNode obj then
			(
				targetObj = obj
				pckObject.caption = obj.name
				
				if (isValidNode targetObj and isValidNode splinePath) then
				(
					pathConstraint = lb.rig.addPathConstraint targetObj splinePath
					btnOK.enabled = true
					btnCancel.enabled = true
				)
			)
		)
		
		----------------------------------------------------------------------------
		-- guarda el objeto spline en una variable, comprueba el nc, añade PathConstraint al objeto, 
		-- limita el spinner al num de vert de la spline, y obtiene posicion de vertices
		----------------------------------------------------------------------------
		on pckSpline picked obj do
		(
			if isValidNode obj then
			(
				splinePath = obj
				pckSpline.caption = obj.name
					
				numVerts = numKnots splinePath
				vertsPercents = getseglengths splinePath 1 cum:true byvertex:true
				
				if (isValidNode targetObj and isValidNode splinePath) then
				(
					pathConstraint = lb.rig.addPathConstraint targetObj splinePath
					btnOK.enabled = true
					btnCancel.enabled = true
				)
				
			)
		)
		
		----------------------------------------------------------------------------
		-- cambia el objeto de vertice segun el número definido en el spinner
		----------------------------------------------------------------------------
		on spnVertexNumb changed val do 
		(
			if pathConstraint != undefined then
			(
				if val > numVerts then
					spnVertexNumb.value = 1
				
				if val < 1 then
					spnVertexNumb.value = numVerts
				
				targetObj.position.controller[#Path_Constraint].percent = vertsPercents[spnVertexNumb.value] * 100
			)
		)
		
		----------------------------------------------------------------------------
		--finaliza la accion para poder utilizar de nuevo la herramienta
		----------------------------------------------------------------------------
		on btnOK pressed do
		(
			pckObject.caption = "Pick Object"
			pckSpline.caption = "Pick Spline"
			
			spnVertexNumb.value = 1
			
			targetObj = undefined
			splinePath = undefined
			
			pathConstraint = undefined 
			
			numVerts = undefined 
			vertsPercents = undefined
			
			btnOK.enabled = false
			btnCancel.enabled = false
		)
		
		----------------------------------------------------------------------------
		-- cancela las acciones, vacia las variables y deja el objeto sin PathConatraint
		----------------------------------------------------------------------------		
		on btnCancel pressed do
		(
			try
				for i = 1 to targetObj.position.controller.count do
					if (classof targetObj.position.controller[i].controller) == Path_Constraint then
						targetObj.position.controller.delete i
			catch()
			
			pckObject.caption = "Pick Object"
			pckSpline.caption = "Pick Spline"
			
			spnVertexNumb.value = 1
			
			targetObj = undefined
			splinePath = undefined
			
			pathConstraint = undefined 
			
			numVerts = undefined 
			vertsPercents = undefined
				
			btnOK.enabled = false
			btnCancel.enabled = false
		)	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTpathConstraintDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTpathConstraintDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTpathConstraintDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTlinkConstraintDef | Contiene la herramienta Link Constraint.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTlinkConstraintDef "Link Constraint"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--label lblVirtualWorld "V-World: " pos:[5,5] width:50 height:15
		pickbutton pckVirtualWorld "Pick Virtual World" pos:[5,5] width:195 height:20 tooltip:"Pick Virtual World"
				
		button btnAdd		"Add to Selection"			pos:[5,25]		width:95 height:20	tooltip:"Adds link constraint if selected objects hasn't it yet. If Virtual World is picked, it´s applied or replaced in them."
		button btnRemove	"Remove"	pos:[105,25]	width:95 height:20	
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTlinkConstraintDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTlinkConstraintDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: picked | Almacena el mundo virtual
		------------------------------------------------
		on pckVirtualWorld picked obj do
		(
			if isValidNode obj then
			(
				linkVirtualWorld = obj
				pckVirtualWorld.caption = obj.name
			)
		)

		------------------------------------------------
		--@event: pressed | Crea el link constraint
		------------------------------------------------		
		on btnAdd pressed do
		(
			_nodes = getCurrentSelection()
			
			lb.links.linkConstraint.add _nodes virtualWorld: (if isValidNode pckVirtualWorld.object then pckVirtualWorld.object)
			
			-- Operación para actualizar el commandPanel solo cuando está el panel modify activado
			if (getCommandPanelTaskMode()) == #modify then 
			(
				max create mode
				max modify mode
			)
				
			pckVirtualWorld.object = undefined
			pckVirtualWorld.caption = "Pick Virtual World"
			lb.message.show "Link constraint applied correctly" type:#message pos:undefined size:[300,75] modal:true
		)--on

		------------------------------------------------
		--@event: pressed | Elimina el link constraint
		------------------------------------------------			
		on btnRemove pressed do
		(	
			_nodes = getCurrentSelection()
			
			lb.links.linkConstraint.remove _nodes
			lb.message.show "Link constraint deleted correctly" type:#message pos:undefined size:[300,75] modal:true
		)--on	

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTlinkConstraintDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTlinkConstraintDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTlinkConstraintDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTlinkConstraintDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTconstraintsDef | Contiene la herramienta Constraint Tools.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTconstraintsDef "Constraint Tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local sourceNode = undefined
		local targetNode = undefined

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		pickbutton pckSource "Pick Source" pos:[5,5] width:95 height:15 tooltip:"Pick Source Object"
		pickbutton pckTarget "Pick Target" pos:[105,5] width:95 height:15 tooltip:"Pick Target Object"
		
		checkbox  chkPos			"pos"				pos:[5,25] height:15
		checkbox  chkKeepPos		"keep offset"	pos:[55,25] height:15 checked:true
		
		checkbox  chkRot			"rot"				pos:[5,45] height:15
		checkbox  chkKeepRot		"keep offset"	pos:[55,45] height:15 checked:true
		
		checkbox  chkScale		"scale"			pos:[5,65] height:15
		checkbox  chkKeepScale	"keep offset"	pos:[55,65] height:15 checked:true
		
		edittext edtConstraintName "Constraint Name" pos:[5,85] width:195 height:15 text:"Constraint"
		
		button btnApply "Apply" pos:[5,105] width:195 height:20 tooltip:"Apply Constraints" enabled:false
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTconstraintsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTconstraintsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: picked | almacena el objeto que va a ser objeto de constraint, es decir el esclavo
		------------------------------------------------
		on pckSource picked obj do
		(
			if isValidNode obj then
			(
				sourceNode = obj
				
				if lb.nc.ncOK obj.name then
				(
					nameParts = filterString obj.name "_"
					pckSource.caption = nameParts[3] + "_" + nameParts[4] + "_" + nameParts[5]
				)
				else
					pckSource.caption = obj.name
				
				btnApply.enabled = (isValidNode sourceNode and isValidNode targetNode)
			)
		)

		------------------------------------------------
		--@event: picked | almacena el objeto que va a ser destino del constraint, es decir el master
		------------------------------------------------		
		on pckTarget picked obj do
		(
			if isValidNode obj then
			(
				targetNode = obj
				
				if lb.nc.ncOK obj.name then
				(
					nameParts = filterString obj.name "_"
					pckTarget.caption = nameParts[3] + "_" + nameParts[4] + "_" + nameParts[5]
				)
				else
					pckTarget.caption = obj.name
				
				btnApply.enabled = (isValidNode sourceNode and isValidNode targetNode)
			)
		)

		------------------------------------------------
		--@event: pressed | crea los constraints
		------------------------------------------------		
		on btnApply pressed do
		(
			if isValidNode sourceNode and isValidNode targetNode then
			(
				if edtConstraintName.text == "" then
					edtConstraintName.text = "Constraint"
				
				if not (lb.rig.createConstraint sourceNode targetNode edtConstraintName.text pos:chkPos.checked rot:chkRot.checked scl:chkScale.checked keepPos:chkKeepPos.checked keepRot:chkKeepRot.checked keepScl:chkKeepScale.checked) then
					lb.message.show "target must have it's transforms frozen" type:#message pos:undefined size:[300,75] modal:true
				else
					lb.message.show "Constraints applied" type:#message pos:undefined size:[300,75] modal:true
			)
			else
			(
				if sourceNode != undefined or targetNode != undefined then
				(
					sourceNode = undefined
					targetNode = undefined
					
					pckSource.caption = "Pick Source"
					pckTarget.caption = "Pick Target"

					lb.message.show "At least one of the objects is not a valid node" type:#message pos:undefined size:[300,75] modal:true
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
		on rollRTconstraintsDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTconstraintsDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTconstraintsDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTconstraintsDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTAddProxyModifiersDef | Contiene la herramienta Add Proxy Modifiers.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTAddProxyModifiersDef "Add Proxy Modifiers"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnAddProxy "Add Proxy" pos:[5,5] width:90 height:25 tooltip:"Add Proxy to selected assets" -- Boton añadir proxy
		button btnRemoveProxy "Remove Proxy" pos:[110,5] width:90 height:25 tooltip:"Remove Proxy to selected objects" -- Boton eliminar proxy
		checkBox chkSelectProxy "Browse file" pos:[5,35]
		checkBox chkOnlySelected "Only selected" pos:[115,35]
		progressBar pbProgress "" pos:[5,55] width:195 height:10 color:(color 30 10 190) -- Barra de progreso
		
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
		--@fn: undefined | mergeProxy | Funcion para mergear el proxy, busca el archivo del modelo en baja (modelo en proxy)
		------------------------------------------------
		fn mergeProxy selectedObjects:undefined file:undefined = 
		(		
			_success = true -- Creamos un estado para comprobar si mergea o no
			
			--Si no hay archivo obtendremos la última versión
			if file == undefined then
			(
				--Sacamos el criterio de búsqueda de las distintas versiones de max.
				--Primero guardamos el nombre del archivo actual con el nombre de proxy en vez de anim
				_wildcard = substituteString maxfilename lb.nc.NC_AnimFileName lb.nc.NC_ProxyFileName
				--Quitamos la ultima parte correspondiente a la version y el tipo de archivo.
				_wildcard = substituteString _wildcard (filterString _wildcard "_")[4] ""
				--Terminaremos el criterio añadiendo la ruta y la parte final del wildcard.
				_wildcard = maxfilepath + _wildcard + "v*.max"
				
				--Cogeremos la lista de archivos de tipo proxy y entre ellos la última versión
				_files = getFiles _wildcard
				
				if _files.count > 0 then
				(
					--Me creo una variable para almacenar el indice de la ultima version (ponemos de inicio el primer archivo
					_latestVersionName = _files[1]
					--Sacaremos la última versión
					for i=1 to _files.count do
					(
						--Parseamos los nombres de los archivos para sacar sus numeros y sustituir el nombre que tenemos en caso de ser mayor
						if ((substring (filterString (getfilenamefile _files[i]) "_")[4] 2 2) As Integer) > ((substring (filterString (getfilenamefile _latestVersionName) "_")[4] 2 2) As Integer) then
							_latestVersionName = _files[i]
					)
					
					--Hacemos el merge del archivo en la escena--
					--Si hemos recibido un array de nodos sacamos sus nombres.
					if selectedObjects != undefined then
					(
						_namesArray = (for i=1 to selectedObjects.count collect substituteString selectedObjects[i].name lb.nc.NC_MeshFileName lb.nc.NC_ProxyFileName)
						
						--Hacemos un merge con los nombres obtenidos
						if doesFileExist _latestVersionName then 
							mergeMaxFile _latestVersionName _namesArray #useSceneMtlDups -- Mergea el proxy con los materiales de la escena
						else
							_success = false
					)
					else --Si no hemos recibido lista de nombres sacamos hacemos un merge de todos.
					(
						if doesFileExist _latestVersionName then 
							mergeMaxFile _latestVersionName #useSceneMtlDups -- Mergea el proxy con los materiales de la escena
						else
							_success = false
					)
				)
				else
				(
					_success = false
				)
			)
			else
			(
				--Si hemos recibido un array de nodos sacamos sus nombres.
				if selectedObjects != undefined then
				(
					_namesArray = (for i=1 to selectedObjects.count collect substituteString selectedObjects[i].name lb.nc.NC_MeshFileName lb.nc.NC_ProxyFileName)
					
					--Hacemos un merge con los nombres obtenidos
					if doesFileExist file then 
						mergeMaxFile file _namesArray #useSceneMtlDups -- Mergea el proxy con los materiales de la escena
					else
						_success = false
				)
				else --Si no hemos recibido lista de nombres sacamos hacemos un merge de todos.
				(
					if doesFileExist file then 
						mergeMaxFile file #useSceneMtlDups -- Mergea el proxy con los materiales de la escena
					else
						_success = false
				)
			)
			_success
		)

		------------------------------------------------
		--@fn: undefined | addProxyToXrefObject | Añade el proxy al objeto que le pasemos (como requisito ha de ser un xref)
		------------------------------------------------		
		fn addProxyToXrefObject obj =
		(
			--Me creo un flag que dice si ha sido correcta la aplicación del proxy
			_success = true
			
			obj.isfrozen = false -- Descongela el objeto
			nombre = obj.name -- Coje el nombre del objeto
			nombre = substituteString nombre ("_" + lb.nc.NC_classMesh + "_") ("_" + lb.nc.NC_classProxy + "_") -- Cambia el nombre de "mesh" a "proxy"
			source = (execute("$'" + nombre + "'")) -- Convierte el string del nuevo nombre en nombre de objeto
			
			if source == undefined then
				_success = false
			else if obj.modifiers[#ProxyDelete] == undefined then -- Si el objeto proxy existe y el objeto no tiene modificador ProxyDelete entra en el loop
			(
				-- Eliminamos los turboSmooth porque algunos estan corruptos y no funciona cuando hacemos el attach
				-- Capturar las propiedades del turbosmooth------------------------------------------------------------------------------------
				-- Definimos las propiedades del modificador turbosmooth como undefined
				nameTB = undefined
				iterationsTB = undefined
				useRenderIterationsTB = undefined
				renderIterationsTB = undefined
				isolineDisplayTB = undefined
				explicitNormalsTB = undefined
				smoothResultTB = undefined
				sepByMatsTB = undefined
				sepBySmGroupsTB = undefined
				updateTB = undefined
				position = undefined
				
				for i=1 to obj.modifiers.count where (classof obj.modifiers[i] == TurboSmooth) do -- Si el objeto tiene modoficador turbosmooth guardamos sus propiedades y lo eliminamos
				(
					nameTB = obj.modifiers[i].name
					iterationsTB = obj.modifiers[i].iterations
					useRenderIterationsTB = obj.modifiers[i].useRenderIterations
					renderIterationsTB = obj.modifiers[i].renderIterations
					isolineDisplayTB = obj.modifiers[i].isolineDisplay
					explicitNormalsTB = obj.modifiers[i].explicitNormals
					smoothResultTB = obj.modifiers[i].smoothResult
					sepByMatsTB = obj.modifiers[i].sepByMats
					sepBySmGroupsTB = obj.modifiers[i].sepBySmGroups
					updateTB = obj.modifiers[i].update
					position = i
					deleteModifier obj i
				)
				-----------------------------------------------------------------------------------------------------------------------------------
				
				--añadir los proxys--------------------------------------------------------------------------------------------------------------
				addModifier obj (edit_poly ()) before:obj.modifiers.count -- Añade un modificador editpoly por encima de la base
				obj.modifiers[obj.modifiers.count].name="ProxyDelete" -- Llama al editpoly "ProxyDelete"
				setCommandPanelTaskMode mode:#modify -- Activa el commandPanel
				modPanel.setCurrentObject obj.modifiers[#ProxyDelete] -- Entra en el modificador
				subObjectLevel = 1 -- Entra en modo subobjeto de vertices
				obj.modifiers[#ProxyDelete].select #Vertex #{1..obj.mesh.verts.count} -- Selecciona todos los vertices
				obj.modifiers[#ProxyDelete].ButtonOp #DeleteVertex -- Borra todos los vertices
				subobjectLevel = 0 -- Sale del modificador
				
				addModifier obj (Edit_Poly ()) before:(obj.modifiers.count-1) -- Añade un modificador editpoly
				obj.modifiers[(obj.modifiers.count-1)].name="ProxyLow" -- Llama el editpoly "ProxyLow"
				
				modPanel.setCurrentObject obj.modifiers[#ProxyLow]	-- Entra en el modificador
				obj.modifiers[#ProxyLow].Attach source editPolyNode:obj -- Hace un attach del objeto draft
				-----------------------------------------------------------------------------------------------------------------------------------
					
				--aplicar turbosmooth con sus propiedades-------------------------------------------------------------------------------------
				if nameTB != undefined do -- Si el objeto tenia tutbosmooth se lo volvemos a aplicar con las propiedades que tenia
				(
					position = position-1
					addModifier obj (TurboSmooth ()) before:position
					obj.modifiers[position+1].enabledInViews = false
					obj.modifiers[position+1].name = nameTB
					obj.modifiers[position+1].iterations = iterationsTB
					obj.modifiers[position+1].useRenderIterations = useRenderIterationsTB
					obj.modifiers[position+1].renderIterations = renderIterationsTB
					obj.modifiers[position+1].isolineDisplay = isolineDisplayTB
					obj.modifiers[position+1].explicitNormals = explicitNormalsTB
					obj.modifiers[position+1].smoothResult = smoothResultTB
					obj.modifiers[position+1].sepByMats = sepByMatsTB
					obj.modifiers[position+1].sepBySmGroups = sepBySmGroupsTB
					obj.modifiers[position+1].update = updateTB
					obj.modifiers[position+1].update = updateTB
				)
				-----------------------------------------------------------------------------------------------------------------------------------
			)--if source
			
			obj.isfrozen = true -- Congela el objeto
			
			--Devolvemos el valor del resultado
			_success
		)
		
		------------------------------------------------
		--@fn: undefined | addProxies | Funcion para añadir las piezas de baja (del modelo proxy) al modelo en alta, via modificador proxy
		------------------------------------------------		
		fn addProxies selectedObjects:undefined = 
		(
			
			objNoProxy = #() -- Array vacio donde meteremos los objetos sin proxy
			
			--Si no hemos mandado una selección en concreto.
			if selectedObjects == undefined then
			(
				currentAssets = lb.asset.getSceneAssets() -- Coge los nodos de los assets de la escena
				for ast in currentAssets do --Recorre los assets
				(
					cont = 1 -- Creamos un contador para la barra de progreso
					
					for obj in ast.meshNodesAll where (classof obj.baseobject == XRefObject) do -- Los objetos recorridos que sean de tipo mesh y que tengan proxy los mete en el array
					(
						--Si el objeto no tenia proxy entonces lo que haremos será apilarlo en los erroneos
						if not (addProxyToXrefObject obj) do
							append objNoProxy obj.name -- Hace un print de los objetos que no encuentra el proxy
						pbProgress.value = cont * 100 / (ast.meshNodesAll.count * 1.0) -- Porcentaje actual del proceso
						cont += 1 -- Incrementamos el contador
					) -- for obj
				)
			)
			else -- Si hay seleccion la recorreremos
			(
				cont = 1 -- Creamos un contador para la barra de progreso
				for obj in selectedObjects where (classof obj.baseobject == XRefObject) do -- Los objetos recorridos que sean de tipo mesh y que tengan proxy los mete en el array
				(
					--Si el objeto no tenia proxy entonces lo que haremos será apilarlo en los erroneos
					if not (addProxyToXrefObject obj) do
						append objNoProxy obj.name -- Hace un print de los objetos que no encuentra el proxy
					pbProgress.value = cont * 100 / (selectedObjects.count * 1.0) -- Porcentaje actual del proceso
					cont += 1 -- Incrementamos el contador
				) -- for obj
			)
			
			objNoProxy -- Sacamos objNoProxy
		)

		------------------------------------------------
		--@fn: undefined | removeProxies | Funcion para eliminar el proxy
		------------------------------------------------			
		fn removeProxies = 
		(
			--Si hemos seleccionado alguno borramos ese.
			if chkOnlySelected.checked then
			(
				objetos = getCurrentSelection() -- Coge los objetos seleccionados y los guarda en un array
				cont = 1 -- Usamos un contador para la barra de progreso
				
				for i=1 to objetos.count do 
				(
					try 
					(
						deleteModifier objetos[i] objetos[i].modifiers[#ProxyDelete] -- Elimina el modificador ProxyDelete
						deleteModifier objetos[i] objetos[i].modifiers[#ProxyLow] -- Elimina el modificador ProxyLow
					) catch ()
					
					pbProgress.value = cont * 100 / (objetos.count * 1.0) -- Porcentaje actual del proceso
					cont += 1 -- Incrementamos el contador
				)
			)
			else --Si no hay selección borramos todos
			(
				--Cojo todos los assets de la escena
				_currentAssets = lb.asset.getSceneAssets()
				
				--Los recorro
				for ast in _currentAssets do
				(
					--Saco los objetos de mesh de cada asset
					objetos = ast.meshNodesAll
					cont = 1 -- Usamos un contador para la barra de progreso
					for i=1 to objetos.count do 
					(
						try 
						(
							deleteModifier objetos[i] objetos[i].modifiers[#ProxyDelete] -- Elimina el modificador ProxyDelete
							deleteModifier objetos[i] objetos[i].modifiers[#ProxyLow] -- Elimina el modificador ProxyLow
						) catch ()
						
						pbProgress.value = cont * 100 / (objetos.count * 1.0) -- Porcentaje actual del proceso
						cont += 1 -- Incrementamos el contador
					)
				)
			)
		)

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
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTAddProxyModifiersDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTAddProxyModifiersDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		on btnAddProxy pressed do 
		(
			setWaitCursor()
			
			selectionBckp = getCurrentSelection()
			
			zeroLayer = LayerManager.getLayerFromName "0" -- Definimos como la capa 0
			
			auxProxyLayer = LayerManager.getLayerFromName "_auxProxy_" --Miramos si la capa auxiliar está creada
			if auxProxyLayer == undefined do auxProxyLayer = LayerManager.newLayerFromName "_auxProxy_" -- Creamos una capa vacia
			
			auxNodes = #()
			objNoProxy = #() -- Array vacio donde meteremos los objetos sin proxy
			
			pbProgress.value = 0 -- Establece el valor de la barra de progreso
			pbProgress.color = blue -- Pone la barra de progreso en azul
			
			--Si hemos marcado la opcion de seleccion de proxy por parte del usuario.
			if chkSelectProxy.checked then
			(
				--Mostramos una ventana para que el usuario coja el archivo de proxies que proceda.
				fileName = getOpenFileName caption:"Get proxy file" filename:maxfilepath
				--Si hemos marcado que haga los proxies de los seleccionados, le pasaremos la seleccion
				if chkOnlySelected.checked then
					success = mergeProxy selectedObjects: selectionBckp file:fileName
				else --Si no, no le pasamos seleccion
					success = mergeProxy file:fileName
			)
			else --El usuario no ha seleccionado archivo
			(
				--Si hemos marcado que haga los proxies de los seleccionados, le pasaremos la seleccion
				if chkOnlySelected.checked then
					success = mergeProxy selectedObjects: selectionBckp
				else --Sino no se la pasaremos
					success = mergeProxy()
			)
			
			if not success then --Si no los encuentra, pide un archivo de donde cogerlos
			(
				fileName = getOpenFileName caption:"Get proxy file" filename:maxfilepath
				if chkOnlySelected.checked then
					success = mergeProxy selectedObjects: selectionBckp file:fileName
				else --Si no, no le pasamos seleccion
					success = mergeProxy file:fileName
			)
			
			if success then
			(
				--Si hemos marcado que cargue los seleccionados.
				if chkOnlySelected.checked then
					objNoProxy = addProxies selectedObjects:selectionBckp -- Metemos en objNoProxy lo que salga de la funcion
				else
					objNoProxy = addProxies()
				clearselection()
			)
			
			--draft = $'*_draft_*' -- Metemos en un array los objetos que hay de draft
			proxy = (execute("$'*_" + lb.nc.NC_classProxy + "_*'"))
			for i = 1 to proxy.count do
			(
				-- Movemos a la capa auxProxyLayer los objetos de draft
				auxProxyLayer.addnode proxy[i]
			)
			
			auxProxyLayer.nodes &auxNodes -- Metemos en auxNodes los nodos que hay en la capa
			zeroLayer.current = true -- Definimos como capa activa la capa 0
			delete auxNodes -- Borramos los objetos que queden de draft
			LayerManager.deleteLayerByName "_auxProxy_" -- Borramos la capa "_auxProxy_"
			
			pbProgress.value = 100 -- Establece el valor de la barra de progreso
			pbProgress.color = green -- Pone la barra de progreso en verde
			
			if objNoProxy.count != 0 then -- Si hay objetos sin proxy
			(
				enableNotifications() -- Activa la ventana de notificacion
				rollNotifications.btnClearNotifications.pressed() -- Limpia la ventana de notificacion
				addnotification "Proxy doesn't found for the following objects:" -- Imprime
				
				for i = 1 to objNoProxy.count do -- Imprime los nombres de los objetos
				(
				addnotification objNoProxy[i]
				)
				disableNotifications = true -- Desactiva la ventana de notificacion
			)
			
			--Hacemos un garbage collector para limpiar la memoria que se haya quedado pillada
			gc()
			
			select selectionBckp
			setArrowCursor()
		)
		
		on btnRemoveProxy pressed do 
		(
			setWaitCursor()
			selectionBckp = getCurrentSelection()
			
			pbProgress.value = 0 -- Establece el valor de la barra de progreso
			pbProgress.color = blue -- Pone la barra de progreso en azul
			
			removeProxies()
			
			pbProgress.color = green -- Pone la barra de progreso en verde
			
			selectionBckp
			setArrowCursor()
		)		

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTAddProxyModifiersDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTAddProxyModifiersDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTAddProxyModifiersDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTAddProxyModifiersDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTAddProxyXrefObjectsDef | Contiene la herramienta Add Proxy XrefObjects.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTChangeMaterialIdDef "Change Material Id"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label lblNumberId "Material Number Id" pos:[5,5] width:120
		spinner spnNumberId "" pos:[150,5] width:50 height:25 tooltip:"Número de Id del material a cambiar" align:#right type:#integer -- Boton eliminar proxy
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTChangeMaterialIdDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTChangeMaterialIdDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: undefined | Cambia el número del ID del material.
		------------------------------------------------
		on spnNumberId changed value do
		(
			lb.geometry.changeMaterialId (getCurrentSelection()) value
		)
		
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTChangeMaterialIdDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTChangeMaterialIdDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTChangeMaterialIdDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTAddProxyXrefObjectsDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTflipNormalsDef | Contiene la herramienta Flip Normals.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTflipNormalsDef "Flip Normals"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnFlipNormals "Flip selected objects normals" pos:[5,5] width:195 height:20 tooltip:"Flips selected nodes normals. Affects poly modifiers if can, else affects base object"
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTflipNormalsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTflipNormalsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | invierte las normales de la seleccion
		------------------------------------------------
		on btnFlipNormals pressed do
		(
			selBckp = getCurrentSelection()
			lb.geometry.flipNormals (getCurrentSelection())
			select selBckp	
			gc light:true
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollRTflipNormalsDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTflipNormalsDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTflipNormalsDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTflipNormalsDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRTffdToolsDef | Contiene la herramienta FFD tools.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollRTffdToolsDef "FFD tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 350	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 100	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		persistent global lastPath = undefined

		local iconpath = lb.config.getIconsPath()

		local FFDtarget = undefined --FFD al que copiar otro ffd
		local FFDorigin = undefined --FFD del que copiar un los puntos de control

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpCopyFFD "Copy FFD" pos:[5,80] width:195 height:115
		pickbutton pckFFDoriginal "FFD original" pos:[10,95] width:185 height:20 
		pickbutton pckFFDtarget "FFD target" pos:[10,120] width:185 height:20 
		button btnFFDcopy "Copy FFD" pos:[10,170] width:65 height:20
		checkbox chkInvertX "invert  X" pos:[11,150] width:64 height:15
		checkbox chkInvertY "invert Y" pos:[75,150] width:60 height:15
		checkbox chkInvertZ "invert Z" pos:[135,150] width:60 height:15
		
		groupBox grpLoadSaveFFD "Load/Save Selected" pos:[5,5] width:195 height:70
		button btnLoad "Load" pos:[40,20] width:25 height:25 images:#(iconpath + "bip_general_i.bmp", undefined, 30, 5, 5, 6, 6,true)
		button btnSave "Save" pos:[10,20] width:25 height:25 images:#(iconpath + "bip_general_i.bmp", undefined, 30, 7, 7, 8, 8,true)
		checkbox chkLoadInvertedX "load inverted in X" pos:[80,25] width:110 height:15
		checkbox chkLoadInvertedY "load inverted in Y" pos:[80,40] width:110 height:15
		checkbox chkLoadInvertedZ "load inverted in Z" pos:[80,55] width:110 height:15
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollRTffdToolsDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollRTffdToolsDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | carga un ffd de un fichero		
		------------------------------------------------
		on btnLoad pressed do
		(
			if lastPath == undefined then lastPath = "C:\\"
			
			file = getOpenFileName caption:"Load FFD points" filename:(lastPath + "\\FFDpoints.ffd") types:"FFD(*.ffd)\*.ffd"
			
			if file != undefined then
			(
				lastPath = substituteString file ("\\" + ((filterString file "\\")[(filterString file "\\").count])) ""
				
				if selection.count == 1 then
				(
					obj = selection[1]
					
					if classof obj == SpaceFFDBox then
					(
						lb.ffdFunctions.loadFFD obj file
						
						if chkLoadInvertedX.checked or chkLoadInvertedY.checked or chkLoadInvertedZ.checked then
							lb.ffdFunctions.SWffdCopy obj obj invertX:chkLoadInvertedX.checked invertY:chkLoadInvertedY.checked invertZ:chkLoadInvertedZ.checked
					)
				)
				else
					lb.message.show "only one object must be selected" type:#message pos:undefined size:[300,75] modal:true			
			)
			
		)

		------------------------------------------------
		--@event: pressed | salva un ffd en un fichero	
		------------------------------------------------
		on btnSave pressed do
		(
			if lastPath != undefined then
				lastUsed = lastPath
			else
				lastUsed = GetDir #maxroot
				
			folder = getSavePath caption:"Save FFD points" initialDir:lastUsed --obtiene el nuevo path
			
			if folder != undefined then
			(
				lastPath = folder
				
				setWaitCursor()
				
				--recorre la seleccion para guardar los ffd 
				if selection.count == 1 then
				(
					obj = selection[1]
					
					if classof obj == SpaceFFDBox then
					(
						file = folder + "\\" + obj.name + ".ffd"
						lb.ffdFunctions.saveFFD obj file
					)
				)
				else
					lb.message.show "only one object must be selected" type:#message pos:undefined size:[300,75] modal:true
				setArrowCursor()
				
			)
		)

		------------------------------------------------
		--@event: picked | almacena el objeto con el FFD original	
		------------------------------------------------
		on pckFFDoriginal picked obj do
		(
			if FFDtarget != undefined then
			(
				if obj.name != FFDtarget.name then
				(
					if classof obj == SpaceFFDBox or classof obj == SpaceFFDCyl then
					(
						FFDorigin = obj
						pckFFDoriginal.caption = "FFD original: " + obj.name
					)
					else
						lb.message.show "picked object is not a SpaceFFDBox" type:#message pos:undefined size:[300,75] modal:true
				)
			)
			else
			(
				if classof obj == SpaceFFDBox or classof obj == SpaceFFDCyl then
				(
					FFDorigin = obj
					pckFFDoriginal.caption = "FFD original: " + obj.name
				)
				else
					lb.message.show "picked object is not a SpaceFFDBox" type:#message pos:undefined size:[300,75] modal:true
			)
		)

		------------------------------------------------
		--@event: picked | almacena el objeto al que copiar el ffd
		------------------------------------------------
		on pckFFDtarget picked obj do
		(
			if FFDorigin != undefined then
			(
				if obj.name != FFDorigin.name then
				(
					if classof obj == SpaceFFDBox or classof obj == SpaceFFDCyl then
					(
						FFDtarget = obj
						pckFFDtarget.caption = "FFD target: " + obj.name
					)
					else
						lb.message.show "picked object is not a SpaceFFDBox" type:#message pos:undefined size:[300,75] modal:true
				)
			)
			else
			(
				if classof obj == SpaceFFDBox or classof obj == SpaceFFDCyl then
				(
					FFDtarget = obj
					pckFFDtarget.caption = "FFD target: " + obj.name
				)
				else
					lb.message.show "picked object is not a SpaceFFDBox" type:#message pos:undefined size:[300,75] modal:true
			)
		)

		------------------------------------------------
		--@event: pressed | copia un ffd en otro
		------------------------------------------------
		on btnFFDcopy pressed do
		(
			if FFDorigin != undefined and FFDtarget != undefined then
			(
				lb.ffdFunctions.SWffdCopy FFDorigin FFDtarget invertX:chkInvertX.checked invertY:chkInvertY.checked invertZ:chkInvertZ.checked
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
		on rollRTffdToolsDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTffdToolsDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollRTffdToolsDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollRTffdToolsDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Rigging Tools"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 220	--@var: minRollWidth | Minimun tool width.
		local minRollHeight = 600	--@var: minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local opening = false --@var: opening | Flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		dotNetControl tbTabs "DevExpress.XtraTab.XtraTabControl" pos:[0,5] width:350 height:21 --25
	
		------------------------------------------------------------------------------------------------
		--SUBROLLOUTS
		------------------------------------------------------------------------------------------------

		subrollout subRollContainer "subRollouts" pos:[0,26] width:minRollWidth height:574 --@control | subRollContainer | SubRollouts container.

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
		--@fn: undefined | initUI | Inicializa los controles del UI.
		------------------------------------------------
		fn initUI =
		(	
			tbTabs.paintstylename = "PropertyView"
			tbTabs.borderStyle = (dotnetclass "DevExpress.XtraEditors.Controls.BorderStyles").noBorder
			tbTabs.TabPageWidth = 100			
			
			tbTabs.Appearance.BackColor = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbTabs.Appearance.BackColor2 = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbTabs.Appearance.BorderColor = (dotnetclass "system.drawing.color").fromArgb 100 100 100
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
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

			--aplica el tab seleccionado
			parent.selectedTabIndex = (lb.xml.getAttribute parent.cfgFile "rollMain/options" "selectedTabIndex") as integer
			if parent.selectedTabIndex == 0 then parent.selectedTabIndex = 1
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

			--almacena las opciones de UI
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "selectedTabIndex" (parent.selectedTabIndex as string)
		)

		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks de este rollout.
		------------------------------------------------
		fn createSceneEvents =
		(
			--sin operaciones
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Elimina los callbacks de este rollout.
		------------------------------------------------
		fn removeSceneEvents =
		(
			--sin operaciones
		)

		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si el tamaño es menor que el minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento de tamaño
			_increment = [size.x - minRollWidth, size.y - minRollHeight]

			------------------------------------------------------------------------------
			--redimension en horizonal
			if _increment.x != 0 then --si hay incremento
			(				
				tbTabs.width = 350 + _increment.x
				if tbTabs.tabPages.count != 0 then tbTabs.TabPageWidth = (minRollWidth + _increment.x)/(tbTabs.tabPages.count) - 17
				subRollContainer.width = size.x
			)--if
			------------------------------------------------------------------------------

			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				--zona de subRollouts
				subRollContainer.height = 574 + _increment.y				
			)--if
			------------------------------------------------------------------------------

			parent.addTabRollouts()
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: selectedPageChanged | Evento que se lanza al cambiar de tab.
		--@control: DevExpress.XtraTab.XtraTabControl | tbTabs | Tabs.
		--@gets: event | events | Objeto devuelto por el evento.
		------------------------------------------------
		on tbTabs selectedPageChanged events do
		(
			if not opening then
			(
				parent.selectedTabIndex = tbTabs.selectedTabPageIndex + 1
				parent.addTabRollouts()
			)--if
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMainDef | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			opening = true --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg

			initUI() --inicializa el UI
			loadSettings()
			parent.fillTabsRolloutsDefs()
			parent.addTabs()
			createSceneEvents()		
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			opening = false --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(				
			removeSceneEvents()
			saveSettings()

			parent.opened = false
			updateToolbarButtons()		
		)	
	)--rollMainDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: riggingTools | Contiene la herramienta riggingTools.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_riggingTools
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Rigging Tools",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
		
		minWidth = 220,		--@var: minWidth | Ancho mínimo de la herramienta.
		minHeight = 600,		--@var: minHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		tabForeColor = (dotnetclass "system.drawing.color").fromArgb 189 189 189,
		tabBorderColor = (dotnetclass "system.drawing.color").fromArgb 30 30 30,
		tabBackColor = (dotnetclass "system.drawing.color").fromArgb 60 60 60,
		tabBackColorActive = (dotnetclass "system.drawing.color").fromArgb 90 90 90,
		tabBackColor2 = (dotnetclass "system.drawing.color").fromArgb 55 55 55,
		tabBackColorActive2 = (dotnetclass "system.drawing.color").fromArgb 60 60 60,


		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------

		rollRTVirtualParent = rollRTVirtualParentDef,
		rollRTPuppet = rollRTPuppetDef,
		rollRTlocksManager = rollRTlocksManagerDef,
		rollRThierarchyGradient = rollRThierarchyGradientDef,
		rollRTbonesFromToPoints = rollRTbonesFromToPointsDef,
		rollRTstretchBoneChain = rollRTstretchBoneChainDef,
		rollRTskinConnectionInfoCheck = rollRTskinConnectionInfoCheckDef,
		rollRTskinConnectionInfo = rollRTskinConnectionInfoDef,
		rollRTBoneTools = rollRTBoneToolsDef,
		rollRTfinAdjustmentTools = rollRTfinAdjustmentToolsDef,
		rollRTboneProperties = rollRTbonePropertiesDef,
		rollRTBoneOffsets = rollRTBoneOffsetsDef,
		rollRTPointConstraint = rollRTPointConstraintDef,
		rollRTpathConstraint = rollRTpathConstraintDef,
		rollRTlinkConstraint = rollRTlinkConstraintDef,
		rollRTconstraints = rollRTconstraintsDef,
		rollRTAddProxyModifiers = rollRTAddProxyModifiersDef,
		rollRTChangeMaterialId = rollRTChangeMaterialIdDef,
		rollRTflipNormals = rollRTflipNormalsDef,
		rollRTffdTools = rollRTffdToolsDef,
		
		rollMain = rollMainDef,	--@var: rollMain | Main tool rollout.
		
		subRolloutsContainer = this.rollMain.subRollContainer, --@var: subRolloutsContainer | contenedor de subrollouts.

		--estos arrays se rellenan en la funcion fillTabsRolloutsDefs, que se llama al abrir la herramienta.
		--esto es solo la defincion de las variables y una ejemplo de estructura que luego se sobrescribe.
		tabNames = #("", "", ""), --@var: tambNames | Nombres de los tabs.
		tabRollouts = #(#(undefined), #(undefined), #(undefined), #(undefined)), --@var: mentalrayTabNames | Rollots de cada tab.
		tabRolloutsRolledUp = #(#(true), #(true), #(true), #(true)), --@var: tabRolloutsRolledUp | Estado de desplegado/plegado de cada rollout de cada tab.

		selectedTabIndex = 1, --@var: selectedTabIndex | Tab seleccionado. Para usar al abrir y cerrar la herramienta

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
		--@fn: undefined | updateTabsColor | Actualiza el color de los tabs.
		------------------------------------------------
		fn updateTabsColor =
		(
			--actualiza los tabs
			for i=1 to this.tabNames.count do
			(
				--configura los colores de los tabs
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.ForeColor = this.tabForeColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BackColor = this.tabBackColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BackColor2 = this.tabBackColor2
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BorderColor = this.tabBorderColor
				
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 8
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.ForeColor = this.tabForeColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor = this.tabBackColorActive
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor2 = this.tabBackColorActive2
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BorderColor = this.tabBorderColor
			)--for
		),

		------------------------------------------------
		--@fn: undefined | fillTabsRolloutsDefs | Añade los tabs y las definiciones de los rollouts a los arrays correspondientes para que la herremienta sepa donde están.
		------------------------------------------------
		fn fillTabsRolloutsDefs =
		(
			this.tabNames = #("Misc", "Bones", "Conn", "Geom")
			this.tabRollouts = #(#(lb.riggingTools.rollRTVirtualParent, lb.riggingTools.rollRTPuppet, lb.riggingTools.rollRTlocksManager, lb.riggingTools.rollRThierarchyGradient), #(lb.riggingTools.rollRTbonesFromToPoints, lb.riggingTools.rollRTstretchBoneChain, lb.riggingTools.rollRTskinConnectionInfo, lb.riggingTools.rollRTBoneTools, lb.riggingTools.rollRTfinAdjustmentTools, lb.riggingTools.rollRTboneProperties, lb.riggingTools.rollRTBoneOffsets), #(lb.riggingTools.rollRTPointConstraint, lb.riggingTools.rollRTpathConstraint,lb.riggingTools.rollRTlinkConstraint, lb.riggingTools.rollRTconstraints), #(lb.riggingTools.rollRTAddProxyModifiers, rollRTChangeMaterialId, lb.riggingTools.rollRTflipNormals, lb.riggingTools.rollRTffdTools))
			this.tabRolloutsRolledUp = #(#(false, false, false, false), #(false, false, false, false, true, true, true), #(false, false, false, false), #(false, false, false,  true))
		),

		------------------------------------------------
		--@fn: undefined | addTabs | Añade los tabs.
		------------------------------------------------
		fn addTabs =
		(
			--elimina los tabs actuales
			this.rollMain.tbTabs.tabPages.clear()

			--añade los tabs
			for i=1 to this.tabNames.count do
				this.rollMain.tbTabs.tabPages.add this.tabNames[i] --añade el tab
			
			if this.rollMain.tbTabs.tabPages.count != 0 then this.rollMain.tbTabs.TabPageWidth = (this.rollMain.width)/(this.rollMain.tbTabs.tabPages.count) - 17

			--selecciona el tab que estaba seleccionado la ultima vez que se abrio el override
			if this.rollMain.tbTabs.tabPages.count >= this.selectedTabIndex then
				this.rollMain.tbTabs.SelectedTabPage = this.rollMain.tbTabs.tabPages.item[this.selectedTabIndex - 1]
			
			this.updateTabsColor() --actualiza los colores de los tabs
			
			this.addTabRollouts()			
		),

		------------------------------------------------
		--@fn: undefined | removeAllTabRollouts | Elimina todos los subrollouts actuales
		------------------------------------------------
		fn removeAllTabRollouts =
		(
			--elimina los subRollouts actuales
			while this.subRolloutsContainer.rollouts.count != 0 do RemoveSubRollout this.subRolloutsContainer this.subRolloutsContainer.rollouts[1]
		),

		------------------------------------------------
		--@fn: undefined | addTabRollouts | Añade los rollouts del tab actual.
		------------------------------------------------
		fn addTabRollouts =
		(
			--elimina los subRollouts actuales
			this.removeAllTabRollouts()

			--añade los subRollouts
			for i=1 to this.tabRollouts[this.selectedTabIndex].count where this.tabRollouts[this.selectedTabIndex][i] != undefined do
			(
				AddSubRollout this.subRolloutsContainer this.tabRollouts[this.selectedTabIndex][i] rolledUp:this.tabRolloutsRolledUp[this.selectedTabIndex][i]
				this.tabRollouts[this.selectedTabIndex][i].resize [this.rollMain.width, this.rollMain.height]
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
	)--tl_riggingTools

	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_riggingTools() --crea la herramienta
)