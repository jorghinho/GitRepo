------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Preview Renderfarm Client"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 164		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 220		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local iniFile = (toolsCfgPath + "\\quicktimePreview.ini")
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles
		MultiListBox mlbCameras "Render cameras:" height:8
		checkbox chkShowStamps "Show stamps" height:15 across:2
		button btnSetupStamps "Setup" width:45 height:20 offset:[10,-2]
		progressBar pbProgress height:5 offset:[0,10]
		label labStatus offset:[0,-5]
		button btnSendToFarm "Render in farm" width:136 height:30 offset:[-1,-15]
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@fn: undefined | updateProgress | Actualiza el label de status y la barra de progreso
		------------------------------------------------
		fn updateStatus percent:undefined txt:undefined =
		(
			if percent != undefined do
			(
				pbProgress.value = percent
				if percent == 100 do
				(
					pbProgress.color = green
					btnSendToFarm.visible = false
				)
			)
			if txt != undefined do labStatus.text = txt
		)
		
		fn populateCameraList =
		(
			cams = lb.previewRenderfarm.getSequencerCamerasData()
			camList = #()
			sel = #()
			for i=1 to cams.count do
			(
				append camList cams[i].cam.name
				append sel i
			)
			mlbCameras.items = camList
			mlbCameras.selection = sel
		)
		
		fn cameraIsSelectedInList cam =
		(
			cameraIsSelected = false
			i = 1
			while not cameraIsSelected and i <= mlbCameras.items.count do
			(
				camItem = mlbCameras.items[i]
				if (findItem mlbCameras.selection i) != 0 and camItem == cam do cameraIsSelected = true
				i += 1
			)
			return cameraIsSelected
		)
		
		fn saveStarted =
		(
			labStatus.visible = true
			btnSendToFarm.visible = false
		)
		
		fn loadTimestampStatus =
		(
			_showStampsEnabled = execute (getINIsetting iniFile "stamps" "enabled")
			
			btnSetupStamps.enabled = chkShowStamps.checked = if _showStampsEnabled != ok then _showStampsEnabled else false
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
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMai/size") "height") as integer
				
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
			
			--cargar status de los timestamps
			loadTimestampStatus()
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		on chkShowStamps changed state do
		(
			setINISetting iniFile "stamps" "enabled" (chkShowStamps.checked as string)
			btnSetupStamps.enabled = if state == on then true else false
		)
		
		on btnSetupStamps pressed do (lb.getTool "timestampSetup").run()
		
		on btnSendToFarm pressed do
		(
			if not mlbCameras.selection.isEmpty then
			(
				parent.saveToFarm()
			) else
			(
				lb.message.show "Select at least one camera to render." type:#message pos:undefined size:[300,75] modal:true
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
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			populateCameraList()
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
	--@struct: passManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_previewRenderfarmClient
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #layout,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Sends file to render preview on external computer.",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		iniSettingsKeys = #("animatorName", "frameNumbersStampEnabled", "cameraStampEnabled", "customStamp", "textSize", "textColor"),
		
		------------------------------------------------------------------------------------------------
		--FUNCIONES
		------------------------------------------------------------------------------------------------
		fn fullTimeStamp =
		(
			t = getLocalTime()
			for i=1 to t.count do t[i] = formattedPrint t[i] format:"02d"
			return t[1]+t[2]+t[4]+t[5]+t[6]+t[7]
		),
		
		fn mergeReferences =
		(
			-- mergear xref scenes
			for n=1 to xrefs.getXRefFileCount() do
			(
				merge(xrefs.getXRefFile n)
			)
			
			-- mergear xref objects
			objRefs = #()
			for i=1 to objXRefMgr.recordCount do
			(
				ref = objXRefMgr.GetRecord i
				if not ref.nested do append objRefs ref
			)
			for o in objRefs do objXRefMgr.MergeRecordIntoScene o
		),
		
		fn saveBitmaps folder =
		(
			bm = lb.previewRenderfarm.getAllBitmapsFromScene()
			dst = folder + lb.previewRenderfarm.texturesFolder
			makeDir(dst)
			for i = 1 to bm.count do
			(
				in_file = bm[i]
				out_file = dst + (filenameFromPath in_file)
				result = copyfile in_file out_file
				if result == false then print("could not copy: "+out_file)
				this.rollMain.updateStatus percent:((40.0*i/bm.count)+50)
			)
		),
		
		fn createFarmJobFolder =
		(
			folder = lb.previewRenderfarm.renderFarmFolder + lb.previewRenderfarm.jobsFolder + fullTimeStamp()
			result = makeDir(folder)
			print folder
			if result then (folder+"\\") else false
		),
		
		fn saveStatusLog jobFolder =
		(
			dst = jobFolder + lb.previewRenderfarm.logFile
			f = openFile dst mode:"a"
			print lb.previewRenderfarm.STATUS_READY_TO_RENDER to:f
			close f
		),
		
		fn saveInfoLog jobFolder maxFile =
		(
			-- obtener id del trabajo a partir de la carpeta donde se creará
			p = filterString jobFolder "\\" -- \\render00\renderFolder\jobId --> #(render00, renderFolder, jobId)
			jobId = p[p.count]
			
			-- crear fichero XML con toda la info del trabajo de render
			xml = lb.xml.newXmlDoc()
			xml.setPath(jobFolder+lb.previewRenderfarm.jobInfoFile)
			root = xml.getRoot()
			job = root.newChild "job"
			id = job.newChild("id")
			id.setText jobId -- el identificador de trabajo es la fecha codificada en formato YYYYMMDDhhmmss
			sender = job.newChild "sender"
			sender.setText sysinfo.username
			file = job.newChild "file"
			file.setText maxFile
			
			-- generar XML para cada cámara
			cams = job.newChild "cameras"
			for c in lb.previewRenderfarm.getSequencerCamerasData() do
			(
				if this.rollMain.cameraIsSelectedInList(c.cam.name) do
				(
					cam = cams.newChild("camera")
					cam.SetPropNames #("name", "start", "end")
					cam.SetPropValues #(c.cam.name, c.recStart, c.recEnd)
				)
			)
			
			-- generar XML de los settings de timestamp
			timest = job.newChild "timestamp"
			if this.rollMain.chkShowStamps.checked then
			(
				for key in this.iniSettingsKeys do
				(
					val = getINISetting this.rollMain.iniFile "stamps" key
					timest.setProperty key val
				)
			)
			
			-- guardar XML
			xml.save()
		),
		
		fn sceneIsReady =
		(
			ready = true
			if getSaveRequired() then
			(
				result = yesNoCancelBox "Scene needs to be saved before continuing.\nSave now?" title:"Scene needs saving"
				if result == #yes then
				(
					savemaxfile (maxfilepath+maxfilename) quiet:true
				) else if result == #no then
				(
					if queryBox "All changes made to the file will be lost.\nAre you sure?" title:"Continue without saving" == false do ready = false
				) else
				(
					ready = false
				)
			)
			return ready
		),
		
		fn saveJob =
		(
			setWaitCursor()
			this.rollMain.saveStarted()
			this.rollMain.updateStatus txt:"Merging references..."
			this.mergeReferences()
			this.rollMain.updateStatus percent:15 txt:"Saving file to farm..."
			originalPath = maxfilepath
			jobFolder = createFarmJobFolder()
			if (jobFolder != false) then 
			(
				savemaxfile(jobFolder+maxfilename) quiet:true
				this.rollMain.updateStatus percent:40 txt:"Saving textures..."
				saveBitmaps(jobFolder)
				this.rollMain.updateStatus txt:"Saving job info..."
				saveInfoLog jobFolder (originalPath+maxfilename)
				saveStatusLog(jobFolder)
				this.rollMain.updateStatus txt:"Reverting to original file..."
				loadMaxFile (originalPath+maxfilename) quiet:true
				this.rollMain.updateStatus percent:100 txt:"Done!"
			) else (
				messageBox("Could not create job in farm")
			)
			setArrowCursor()
		),
		
		fn saveToFarm =	(if this.sceneIsReady() do this.saveJob()),
		
		
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
		
	)--tl_previewRenderfarmClient
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_previewRenderfarmClient() --crea la herramienta
)