------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Node Info Manager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Node Info Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local okColor = (dotNetClass "System.Drawing.Color").fromargb 80 255 80
		local errorColor = (dotNetClass "System.Drawing.Color").fromargb 255 80 80
		local missingColor = (dotNetClass "System.Drawing.Color").fromargb 255 112 0
		
		local minRollWidthOld = 1650		--@var: minRollWidthOld | Ancho mínimo de la herramienta.
		local minRollWidth = 500		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 315		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		button btnAdd "Add" pos:[12,8] width:65 height:25 tooltip:"adds node info. Only works with shift pressed to avoid errors"
		button btnRemove "Remove" pos:[77,8] width:60 height:25 tooltip:"removes node info. Only works with shift pressed to avoid errors"
		checkBox chkSVN "SVN Info" pos:[1330,13] width:60 height: 20
		
		groupBox grpInformation "" pos:[150,0] width:1495 height:35
		label lblDescription "Description: Información del nodo." pos:[250,13] width:180 height:15
		label lblVersion "Version: 2.1" pos:[160,13] width:70 height:15
		dotNetControl lvNodeInfo "System.Windows.Forms.ListView" pos:[10,40] width:1635 height:270

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

		fn initNodeInfoListView =
		(
			lv = lvNodeInfo
			lv.columns.clear()
			lv.multiSelect = false
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = colorBackUnselected
			lv.foreColor = colorFore
			lv.scrollable = true
			lv.labelEdit = false

			lv.columns.add "File" 450
			lv.columns.add "Name" 250
			lv.columns.add "Transform" 115
			lv.columns.add "Material" 150
			lv.columns.add "Layer" 150
			lv.columns.add "LoadMode" 80
			lv.columns.add "Save Date" 120
			lv.columns.add "SVN Load Review" 100
			lv.columns.add "SVN Last Review" 100
			lv.columns.add "SVN Updated" 100

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		------------------------------------------------
		--@fn: boolean | fillNodeInfo | Añade el atributo Node Info a la pieza obj
		------------------------------------------------
		fn fillNodeInfo =
		(
			setWaitCursor()

			lvNodeInfo.items.clear()

			if selection.count > 0 then
			(
				obj = selection[1]
				
				if lb.nodeInfo.hasNodeInfo obj then
				(
					for i=1 to obj.nodeInfo.fileHistory.count do
					(
						lvNodeInfo.items.add (obj.nodeInfo.fileHistory[i])
						lvNodeInfo.items.item[i-1].SubItems.add (obj.nodeInfo.nameHistory[i])
						lvNodeInfo.items.item[i-1].SubItems.add (obj.nodeInfo.transformHistory[i] as string)
						lvNodeInfo.items.item[i-1].SubItems.add (obj.nodeInfo.materialNameHistory[i])
						lvNodeInfo.items.item[i-1].SubItems.add (obj.nodeInfo.layerNameHistory[i])
						lvNodeInfo.items.item[i-1].SubItems.add (obj.nodeInfo.loadModeHistory[i])

						aSaveDate = undefined
						_m = lb.re.matchObj (obj.nodeInfo.subVersionHistory[i] as string) "(?'year'\d{4})(?'month'\d{2})(?'day'\d{2})\.(?'hours'\d{1,2})(?'minutes'\d{2})(?'seconds'\d{2})"
						if _m.success then
						(
							sSaveDay = _m.Groups.Item["day"].Value
							sSaveMonth = _m.Groups.Item["month"].Value
							sSaveYear = _m.Groups.Item["year"].Value
							sSaveHours = _m.Groups.Item["hours"].Value
							sSaveMinutes = _m.Groups.Item["minutes"].Value
							sSaveSeconds = _m.Groups.Item["seconds"].Value

							lvNodeInfo.items.item[i-1].SubItems.add (sSaveDay + "/" + sSaveMonth + "/" + sSaveYear + " " + sSaveHours + ":" + sSaveMinutes + ":" + sSaveSeconds)
							aSaveDate = #(sSaveYear as integer, sSaveMonth as integer, sSaveDay as integer, 0, sSaveHours as integer, sSaveMinutes as integer, sSaveSeconds as integer, 0)
						)

						if chkSVN.checked do
						(
							fileURL = lb.svn.fileURL (obj.nodeInfo.fileHistory[i])
							dInfo = lb.svn.svnGetInfo fileURL

							sLoadedReviewDate = "Not found"
							if aSaveDate != undefined do
							(
								lLog = lb.svn.svnLog fileURL
								bAnterior = false
								for i = lLog.count to 1 by -1 where not bAnterior do
								(
									sLoadedReviewDate = lLog[i][3][3] as string + "/" + lLog[i][3][2] as string  + "/" + lLog[i][3][1] as string + " " + lLog[i][3][5] as string + ":" + lLog[i][3][6] as string + ":" + lLog[i][3][7] as string
									for t = 1 to t = aSaveDate.Count where not bAnterior do
									(
										if aSaveDate[t] < lLog[i][3][t] then
										(
											bAnterior = true
											exit
										)
										else if aSaveDate[t] > lLog[i][3][t] then
										(
											exit
										)
									)
								)
							)
							lvNodeInfo.items.item[i-1].SubItems.add sLoadedReviewDate

							sLastChangedDate = "Not found"

							if dInfo.ContainsKey("Last Changed Date") then
							(
								sLastChangedDate = dInfo.Item("Last Changed Date")
								_m = lb.re.matchObj sLastChangedDate "(?'year'\d{4})-(?'month'\d{2})-(?'day'\d{2}) (?'hours'\d{1,2}):(?'minutes'\d{2}):(?'seconds'\d{2}).*"
								if _m.success then
								(
									sLastChangedDate = _m.Groups.Item["day"].Value + "/" + _m.Groups.Item["month"].Value + "/" + _m.Groups.Item["year"].Value + " " + _m.Groups.Item["hours"].Value + ":" + _m.Groups.Item["minutes"].Value + ":" + _m.Groups.Item["seconds"].Value
								)
							)

							lvNodeInfo.items.item[i-1].SubItems.add sLastChangedDate
							lvNodeInfo.items.item[i-1].UseItemStyleForSubItems = false
							if doesFileExist (obj.nodeInfo.fileHistory[i]) then
								if lb.svn.svnIsFileUpdated (obj.nodeInfo.fileHistory[i]) then
								(
									lvNodeInfo.items.item[i-1].SubItems.add "Updated"
									lvNodeInfo.items.item[i-1].SubItems.item[9].backColor = okColor
								)
								else
								(
									lvNodeInfo.items.item[i-1].SubItems.add "Outdated"
									lvNodeInfo.items.item[i-1].SubItems.item[9].backColor = errorColor
								)
							else
							(
								lvNodeInfo.items.item[i-1].SubItems.add "Missing"
								lvNodeInfo.items.item[i-1].SubItems.item[9].backColor = missingColor
							)
						)
					)
				)
			)

			setArrowCursor()
		)

		fn resetUI = 
		(
			fillNodeInfo()
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
			callbacks.addscript #selectionSetChanged "lb.nodeInfoManager.rollMain.fillNodeInfo()" id:_id
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
			if size.x < 500 then (size.x = 500; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidthOld, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				lvNodeInfo.width = 1635 + _increment.x
				grpInformation.width = _increment.x + 1495
				chkSVN.pos.x = _increment.x + 1570

				if lvNodeInfo.columns.count != 0 then
				(
					lvNodeInfo.Columns.Item[0].width = 450 + _increment.x/4.0
					lvNodeInfo.Columns.Item[1].width = 250 + _increment.x/4.0
					lvNodeInfo.Columns.Item[2].width = 115 + _increment.x/16.0
					lvNodeInfo.Columns.Item[3].width = 150 + _increment.x/16.0
					lvNodeInfo.Columns.Item[4].width = 150 + _increment.x/16.0
					lvNodeInfo.Columns.Item[5].width = 80 + _increment.x/16.0
					lvNodeInfo.Columns.Item[6].width = 120 + _increment.x/16.0
					lvNodeInfo.Columns.Item[7].width = 100 + _increment.x/16.0
					lvNodeInfo.Columns.Item[8].width = 100 + _increment.x/16.0
					lvNodeInfo.Columns.Item[9].width = 100 + _increment.x/16.0
				)
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				lvNodeInfo.height = 270 + _increment.y
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

		on btnAdd pressed do 
		(
			if keyboard.shiftPressed then
			(
				lb.nodeInfo.add (getCurrentSelection())
				fillNodeInfo()
			)
		)
		
		---------------------------------------------------------------
		on btnRemove pressed do 
		(
			if keyboard.shiftPressed then
			(
				lb.nodeInfo.removeAttribute (getCurrentSelection())
				fillNodeInfo()
			)
		)

		on chkSVN changed state do
		(
			fillNodeInfo()
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

			initNodeInfoListView()
			fillNodeInfo()

			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]

			resetUI()
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
	--@struct: nodeInfoManager | Contiene la herramienta nodeInfoManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_nodeInfoManager
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
		
	)--tl_nodeInfoManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_nodeInfoManager() --crea la herramienta
)