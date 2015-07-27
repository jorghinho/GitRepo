------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta CMD Launcher.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta CMD Launcher.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Console Deadline launcher Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 390		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 625		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		edittext _edt_user "User Name:" pos:[20,25] fieldwidth:110 
		edittext _edt_comment " Comment:" fieldwidth:300 offset:[10,0]
		groupBox _gbJobDescription "Job Description:" pos:[10,5] width:375 height:65


		label _lbl_pools "Pool:" pos:[30,97]
		dropdownList _ddl_poollist "" width:320 pos:[55,95]
		
		label _lbl_group "Group:" pos:[20,127]
		dropdownlist _ddl_group items:#() width:320 height:20 pos:[55,125]

		label _lbl_priority "Priority:" pos:[20,155]
		progressbar _sld_priority width:270 height:18 range:[0,100,50] type:#integer pos:[60,155]
		spinner _spn_priority "" type:#integer fieldwidth:35 pos:[330,155]
		groupBox _gbPoolGroupPriorDescription "Pool, Group, And Priority:" pos:[10,75] width:375 height:110

		label _lbl_chunk "Render Task Chunk Size (Frames Per Task):" pos:[20,210]
		spinner _spn_chunkSize "Frames: " range:[1,1000,1] type:#integer fieldwidth:35 pos:[290,210]
		checkbox _chk_limitEnabled "Concurrent Machine Rendering Limit  " pos:[20,230]
		spinner _spn_machineLimit "Machines: " range:[1,1000,1] type:#integer  fieldwidth:35 pos:[281,230] enabled:false
		--checkbox _chk_RenderFramesPreviewJob "Preview Job First  " pos:[20,250]
		--spinner _spn_PreviewJobPriorityOffset "Priority+: " range:[-100,100,0] type:#integer pos:[175,250] fieldwidth:35 enabled:false
		--spinner _spn_PreviewJobFrameCount  "# Frames: " range:[2,100,3] type:#integer fieldwidth:35 pos:[279,250] enabled:false
		checkbox _chk_submitAsSuspended "Submit Job As Suspended  "  pos:[20,250]
		groupBox _gbJobInfo "Job:" pos:[10,190] width:375 height:90

		checkbox _chkEnabled "Enable Limits" pos:[25,305]
		button btn_selectAllSlaves "A" width:22 height:18 pos:[25,325] tooltip:"Select All"
		button btn_selectInvertSlaves "I" width:22 height:18 pos:[50,325] tooltip:"Invert Current Selection"
		button btn_moveToList "> > >" width:125 height:18 pos:[75,325] tooltip:"Move selected Slaves to Blacklist"
		button btn_moveToSlaves "< < <" width:125 height:18 pos:[205,325] tooltip:"Move selected Slaves to the Slaves List."
		button btn_selectAllList "A" width:22 height:18 pos:[333,325] tooltip:"Select All"
		button btn_selectInvertList "I" width:22 height:18 pos:[358,325] tooltip:"Invert Current Selection"
		multiListbox mlb_slavesList "Blacklisted Slaves (Not Render):  " width:175 height:13 pos:[25,345]
		multiListbox mlb_blackList  "Whitelisted Slaves (May Render):       " width:175 height:13 pos:[205,345]
		edittext edt_whiteFilter "" text:"" fieldwidth:140 pos:[22,540]
		edittext edt_blackFilter "" text:"" fieldwidth:140 pos:[235,540]
		radiobuttons rad_blackList labels:#("Blacklist","Whitelist") columns:2 pos:[250,565] default:2
		groupBox _gbLimitsInfo "Limits" pos:[10,285] width:375 height:300

		button _renderSubmit "Submit to Render" width:200 height:30 pos:[100,588]	
		
		--@control | controlName | CMD Launcher de comentario para controles
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | displayPoolsList | Actualiza la info de la list de pools a traves de las funciones de SMTD
		------------------------------------------------
		fn displayPoolsList =
		(
			--SMTDFunctions.CollectPools()
			_ddl_poollist.items = SMTDSettings.Pools
			
			local theIndex = findItem _ddl_poollist.items SMTDSettings.PoolName
			if theIndex > 0 then 
				_ddl_poollist.selection = theIndex 
			else
			(
				theIndex = findItem _ddl_poollist.items "none"
				if theIndex > 0 do
				(
					_ddl_poollist.selection = theIndex
					SMTDSettings.PoolName = "none"
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | displayGroupsList | Actualiza la info de la list de groups a traves de las funciones de SMTD
		------------------------------------------------		
		fn displayGroupsList =
		(
			_ddl_group.items = SMTDSettings.Groups
			
			local theIndex = findItem _ddl_group.items SMTDSettings.Group
			if theIndex > 0 then 
				_ddl_group.selection = theIndex 
			else
			(
				theIndex = findItem _ddl_group.items "none"
				if theIndex > 0 do
				(
					_ddl_group.selection = theIndex 
					SMTDSettings.Group = "none"
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | job_priority_update | Actualiza el valor de la barra de prioridad y el color en funcion de la proporcion de prioridad
		--@gets: integer | val | valor en base 100 del tanto por ciento
		------------------------------------------------
		fn job_priority_update val =
		(
			if val <= 100 do
			(
				theRed = (255.0 - 255.0*val/100.0)*2.0
				if theRed > 255 do theRed = 255
				theGreen = 512.0*val/100.0
				if theGreen > 255 do theGreen = 255
				_sld_priority.color = [theRed, theGreen, 0]
				_sld_priority.value = _spn_priority.value = val
			)
			val
		)

		------------------------------------------------
		--@fn: undefined | storeSlaveList | Guarda la colección de whitelisted slaves para enviar a render
		------------------------------------------------
		fn storeSlaveList = 
		(
			local theListString = "#("
			if SMTDSettings.SlavesList.count > 0 do
			(
				for i = 1 to SMTDSettings.SlavesList.count-1 do theListString += "\"" + SMTDSettings.SlavesList[i] + "\","
				theListString += "\"" + SMTDSettings.SlavesList[SMTDSettings.SlavesList.count] 
			)	
			theListString += "\")"
			setIniSetting SMTDPaths.InIFile "Blacklist"  "SlavesList" theListString		
		)

		------------------------------------------------
		--@fn: undefined | updateSlaveList | Actualiza las listas de Blacklisted y Whitelisted slaves
		--@gets: boolean | forceUpdate | se rehace la coleccion de slaves
		------------------------------------------------
		fn updateSlaveList forceUpdate:false=
		(
			if SMTDSettings.Slaves.count == 0 or forceUpdate do
			(
				SMTDFunctions.CollectSlaves()
			)
			
			mlb_slavesList.items = for i in (sort SMTDSettings.Slaves) where findItem SMTDSettings.SlavesList i == 0 collect i
			mlb_blackList.items = for i in (sort (SMTDSettings.SlavesList as array)) collect i
			--storeSlaveList()
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
		--COMMON
		------------------------------------------------
		
		fn initializeInfo = 
		(
			lb.cmdLauncher.isSinglePass = false
			lb.cmdLauncher.passesToRender = ""
			_edt_user.text = SMTDFunctions.GetDeadlineUser()
			SMTDFunctions.CollectPools()
			displayPoolsList()
			SMTDFunctions.CollectGroups()
			displayGroupsList()
			updateSlaveList()
			job_priority_update 0
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

			lb.xml.setAttribute  parent.cfgFile ("rollMain/limitsEnabled") "chkBox" (_chkEnabled.checked as string)

			lb.xml.setAttribute  parent.cfgFile ("rollMain/BLimits") "BlackListed" (lb.cmdLauncher.rollMain.getListOneSlaves())
			lb.xml.setAttribute  parent.cfgFile ("rollMain/Wlimits") "WhiteListed" (lb.cmdLauncher.rollMain.getListTwoSlaves())

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

			_LimitsCheck = (lb.xml.getAttribute parent.cfgFile ("rollMain/limitsEnabled") "chkBox")

			_blist = (lb.xml.getAttribute parent.cfgFile ("rollMain/BLimits") "BlackListed")
			_wlist = (lb.xml.getAttribute parent.cfgFile ("rollMain/Wlimits") "WhiteListed")
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]
			case _LimitsCheck of
			(
				("true"):
				(
					_chkEnabled.checked = true
					lb.cmdLauncher.rollMain.switchLimitUI true
				)
				("false"):
				(
					_chkEnabled.checked = false
					lb.cmdLauncher.rollMain.switchLimitUI false
				)
				default: 
				(
					_chkEnabled.checked = false
					lb.cmdLauncher.rollMain.switchLimitUI false
				)
			)
			_blist = execute _blist 
			_wlist = execute _wlist 

			_selection = #() 
			for _name in _wlist do 
			(
				for i = 1 to mlb_slavesList.items.count where matchPattern mlb_slavesList.items[i] pattern:(_name) do 
				(
					append _selection i as bitarray
				)
			)
			mlb_slavesList.selection = _selection
			lb.cmdLauncher.rollMain.btn_moveToList.pressed()
		)

		------------------------------------------------
		--@fn: string | getRenderSlaves | Devuelve una string con los slaves que se tienen que renderizar
		--@gets: string[] | theSlaves | array con los slaves 
		--@gets: integer | _renderMode | se determina si el modo de render es whitelist o blacklist
		------------------------------------------------	
		fn getRenderSlaves  =
		( 
			_slavesString = ""
			case rad_blackList.state of
			(
				1:
				(
					_slavesString = "Blacklist="
					for i = 1 to mlb_slavesList.items.count do 
					(
						if i != mlb_slavesList.items.count then
						(
							_slavesString = _slavesString + (mlb_slavesList.items[i] as string ) + ","
						)
						else 
						(
							_slavesString = _slavesString + (mlb_slavesList.items[i] as string ) 
						)
					)
				)
				2:
				(
					_slavesString = "Whitelist="
					for i = 1 to mlb_blackList.items.count do 
					(
						if i != mlb_blackList.items.count then
						(
							_slavesString = _slavesString + (mlb_blackList.items[i] as string ) + ","
						)
						else 
						(
							_slavesString = _slavesString + (mlb_blackList.items[i] as string ) 
						)
					)					
				)
			)
			--print _slavesString
			return _slavesString
		)

		------------------------------------------------
		--@fn: string | getRenderSlaves | Devuelve una string con los slaves que se tienen que renderizar
		--@gets: string[] | theSlaves | array con los slaves 
		--@gets: integer | _renderMode | se determina si el modo de render es whitelist o blacklist
		------------------------------------------------	
		fn getListOneSlaves  =
		( 
			_slavesString = "#("
			
			for i = 1 to mlb_slavesList.items.count do 
			(
				if i != mlb_slavesList.items.count then
				(
					_slavesString = _slavesString + "\"" + (mlb_slavesList.items[i] as string ) + "\","
				)
				else 
				(
					_slavesString = _slavesString + "\"" + (mlb_slavesList.items[i] as string ) + "\""
				)
			)

			_slavesString += ")"
			return _slavesString
		)

		------------------------------------------------
		--@fn: string | getRenderSlaves | Devuelve una string con los slaves que se tienen que renderizar
		--@gets: string[] | theSlaves | array con los slaves 
		--@gets: integer | _renderMode | se determina si el modo de render es whitelist o blacklist
		------------------------------------------------	
		fn getListTwoSlaves  =
		( 
			_slavesString = "#("
			
			for i = 1 to mlb_blackList.items.count do 
			(
				if i != mlb_blackList.items.count then
				(
					_slavesString = _slavesString + "\"" + (mlb_blackList.items[i] as string ) + "\","
				)
				else 
				(
					_slavesString = _slavesString + "\"" + (mlb_blackList.items[i] as string ) + "\""
				)
			)			
			_slavesString += ")"
			return _slavesString
		)

		------------------------------------------------
		--@fn: string | switchLimitUI | Activa/Desactiva la UI de Limits
		--@gets: boolean | _state | estado del checkbox
		------------------------------------------------	
		fn switchLimitUI _state =
		(
			btn_selectAllSlaves.enabled = _state
			btn_selectInvertSlaves.enabled = _state
			btn_moveToList.enabled = _state
			btn_moveToSlaves.enabled = _state
			btn_selectAllList.enabled = _state
			btn_selectInvertList.enabled = _state
			mlb_slavesList.enabled = _state
			mlb_blackList.enabled = _state
			edt_whiteFilter.enabled = _state
			edt_blackFilter.enabled = _state
			rad_blackList.enabled = _state
		)

		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		on _chkEnabled changed theState  do
		(
			switchLimitUI theState
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al seleccionar el elemento del dropdownlist
		--@control: dropDownList | _ddl_poollist | El elemento que dispara el evento. 
		--@gets: int | itm | el indice en el ddlist del objeto que actualizaremos en la info.
		------------------------------------------------
		on _ddl_poollist selected itm do 
		(
			_pool = _ddl_poollist.selected as string 
		)

		------------------------------------------------
		--@event: selected | Evento que se lanza al seleccionar el elemento del dropdownlist
		--@control: dropDownList | _ddl_group | El elemento que dispara el evento. 
		--@gets: int | itm | el indice en el ddlist del objeto que actualizaremos en la info.
		------------------------------------------------		
		on _ddl_group selected itm do 
		(
			_group = _ddl_group.selected as string
		)

		------------------------------------------------
		--@event: clicked | Evento que se lanza al pulsar encima de la barra de progreso
		--@control: progressBar | _sld_priority | El elemento que dispara el evento. 
		--@gets: int | value | el valor del % de la barra en base 100
		------------------------------------------------
		on _sld_priority clicked value do 
		(
			(job_priority_update value) as string 
			_priority = value as string 
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al realizar un cambio en el valor del spinner
		--@control: spinner | _spn_priority | El elemento que dispara el evento. 
		--@gets: int | value | el valor del % en base 100
		------------------------------------------------	
		on _spn_priority changed value do 
		(	
			(job_priority_update value) as string 
			_priority = value as string 
		)	

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del checkbutton
		--@control: checkbutton | _chk_limitEnabled | El estado del checkbutton.
		--@gets: boolean | theState | estado checked/unchecked del checkbutton
		------------------------------------------------
		on _chk_limitEnabled changed theState  do
		(
			_spn_machineLimit.enabled = theState
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del checkbutton
		--@control: checkbutton | _chk_RenderFramesPreviewJob | El estado del checkbutton.
		--@gets: boolean | theState | estado checked/unchecked del checkbutton
		------------------------------------------------
		/*on _chk_RenderFramesPreviewJob changed theState  do
		(
			_spn_PreviewJobPriorityOffset.enabled = theState
			_spn_PreviewJobFrameCount.enabled = theState
		)*/

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton
		--@control: button | btn_selectAllSlaves | El boton que lanza el evento de selección de todos los slaves
		------------------------------------------------
		on btn_selectAllSlaves pressed do
			mlb_slavesList.selection = #{1..mlb_slavesList.items.count}
			
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton
		--@control: button | btn_selectInvertSlaves | El boton que lanza el evento de invertir la selección de slaves
		------------------------------------------------			
		on btn_selectInvertSlaves pressed do
			mlb_slavesList.selection = -mlb_slavesList.selection

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton
		--@control: button | btn_selectAllList | El boton que lanza el evento de selección de todos los slaves
		------------------------------------------------			
		on btn_selectAllList pressed do
			mlb_blackList.selection = #{1..mlb_blackList.items.count}

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton
		--@control: button | btn_selectInvertList | El boton que lanza el evento de invertir la selección de slaves
		------------------------------------------------			
		on btn_selectInvertList pressed do
			mlb_blackList.selection = -mlb_blackList.selection

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton
		--@control: button | btn_moveToList | El boton que lanza el evento de mover la seleccion a la pool blacklisted
		------------------------------------------------	
		on btn_moveToList pressed do
		(
			theSel = mlb_slavesList.selection as array
			tempArray = mlb_blackList.items
			for i in theSel do 
				append tempArray mlb_slavesList.items[i]
			mlb_blackList.items = sort tempArray 
			SMTDSettings.SlavesList = for i in tempArray collect i
			tempArray = mlb_slavesList.items
			for i = theSel.count to 1 by -1 do deleteItem tempArray theSel[i]
			mlb_slavesList.items = sort tempArray
			mlb_slavesList.selection = mlb_blackList.selection = #{}
			--storeSlaveList()
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton
		--@control: button | btn_moveToSlaves | El boton que lanza el evento de mover la seleccion a la pool whitelisted
		------------------------------------------------			
		on btn_moveToSlaves pressed do
		(
			theSel = mlb_blackList.selection as array
			tempArray = mlb_slavesList.items
			for i in theSel do 
				append tempArray mlb_blackList.items[i]
			mlb_slavesList.items = sort tempArray 
			tempArray = mlb_blackList.items
			for i = theSel.count to 1 by -1 do deleteItem tempArray theSel[i]
			mlb_blackList.items = sort tempArray
			SMTDSettings.SlavesList = for i in tempArray collect i
			mlb_slavesList.selection = mlb_blackList.selection = #{}
			--storeSlaveList()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el contenido del edittext
		--@control: none | edt_whiteFilter | El boton que lanza el evento de mover la seleccion a la pool whitelisted
		--@gets: string | txt | El texto para actualizar el edittext
		------------------------------------------------			
		on edt_whiteFilter changed txt do
		(	
			if txt != "" then
				mlb_slavesList.selection = (for i = 1 to mlb_slavesList.items.count where matchPattern mlb_slavesList.items[i] pattern:(txt+"*") collect i) as bitarray
			else	
				mlb_slavesList.selection = #{}
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el contenido del edittext
		--@control: none | edt_blackFilter | El boton que lanza el evento de mover la seleccion a la pool whitelisted
		--@gets: string | txt | El texto para actualizar el edittext
		------------------------------------------------			
		on edt_blackFilter changed txt do
		(	
			if txt != "" then
				mlb_blackList.selection = (for i = 1 to mlb_blackList.items.count where matchPattern mlb_blackList.items[i] pattern:(txt+"*") collect i) as bitarray
			else	
				mlb_blackList.selection = #{}
		)	

		------------------------------------------------
		--@event: doubleClicked | Evento que se lanza al cambiar pulsar dos veces sobre el elemento
		--@gets: multilistbox item | itm | El elemento de la lista
		------------------------------------------------
		on mlb_slavesList doubleClicked itm do btn_moveToList.pressed()

		------------------------------------------------
		--@event: doubleClicked | Evento que se lanza al cambiar pulsar dos veces sobre el elemento
		--@gets: multilistbox item | itm | El elemento de la lista
		------------------------------------------------
		on mlb_blackList doubleClicked itm do btn_moveToSlaves.pressed()

		------------------------------------------------
		--@event: selected | Evento que se lanza al seleccionar un elemento de la multilistbox
		--@gets: multilistbox item | itm | El elemento de la lista
		------------------------------------------------			
		on mlb_slavesList selected itm do
		(	
			local tempArray = (for i in mlb_slavesList.selection collect mlb_slavesList.items[i])
			join tempArray (for i in mlb_blackList .selection collect mlb_blackList.items[i])		
		)	

		------------------------------------------------
		--@event: selected | Evento que se lanza al seleccionar un elemento de la multilistbox
		--@gets: multilistbox item | itm | El elemento de la lista
		------------------------------------------------		
		on mlb_blackList selected itm do
		(	
			local tempArray =(for i in mlb_blackList .selection collect mlb_blackList.items[i])
			join tempArray  (for i in mlb_slavesList.selection collect mlb_slavesList.items[i])
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del boton
		--@gets: integer | val | El estado del radiobutton
		------------------------------------------------
		on rad_blackList changed val do 
		(
			case rad_blackList.state of
			(
				1:
				(
					mlb_slavesList.caption = "Whitelisted Slaves(May Render):" 
					mlb_blackList.caption = "Blacklisted Slaves (Not Render):" 
				)
				2:
				(
					mlb_slavesList.caption = "Blacklisted Slaves (Not Render):" 
					mlb_blackList.caption = "Whitelisted Slaves (May Render):"  
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
			createSceneEvents() --crea los callbacks
			switchLimitUI _chkEnabled.checked
			initializeInfo()
			loadSettings()
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

		------------------------------------------------
		--@event: close | Evento que se lanza al pulsar el boton.
		--@control: rollout | rollMain | Se lanza a render con la configuración de la herramienta
		------------------------------------------------
		on _renderSubmit pressed do
		(
			struct submissionInfo 
			(
				_userName = "",
				_comment = "",
				_pool = "",
				_group = "",
				_priority = "",
				_rewritePlugin = false,
				_taskChunkSize = 0,
				_concurrentMachines = 0,
				_suspended = false,
				_enableLimits = false,
				_limitedRender = "",

				fn initializeValues = 
				(
					_userName = rollMainDef._edt_user.text
					if rollMainDef._edt_comment.text != "" do _comment = rollMainDef._edt_comment.text
					_pool = _ddl_poollist.selected as string 
					_group = _ddl_group.selected as string 
					_priority = _sld_priority.value
					_taskChunkSize = _spn_chunkSize.value
					if _chk_limitEnabled.checked do _concurrentMachines = _spn_machineLimit.value
					if _chk_submitAsSuspended.checked do _suspended = true
					if (_taskChunkSize>1) or (_concurrentMachines>0) or (_suspended == true) do _rewritePlugin = true
					_enableLimits = _chkEnabled.checked
					if (_chkEnabled.checked) do  _limitedRender = getRenderSlaves()
				),

				_init = initializeValues()
			)
			_submissionJobInfo = submissionInfo()
			if lb.cmdLauncher.isSinglePass then 
			(
				lb.passManagerUI.rollMain.submitCommandRenderNetwork _submissionJobInfo lb.cmdLauncher.isSinglePass _passesList:lb.cmdLauncher.passesToRender
			)
			else
			(
				lb.passManagerUI.rollMain.submitCommandRenderNetwork _submissionJobInfo lb.cmdLauncher.isSinglePass
			)
		)

	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta CMD Launcher.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_cmdLauncher
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool CMD Launcher",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		isSinglePass = false,
		passesToRender = "",
			
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
		
	)--tl_cmdLauncher
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_cmdLauncher() --crea la herramienta
)