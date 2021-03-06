------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Ram Player Loader"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 520		--@var: minRollWidth | Ancho m�nimo de la herramienta.
		local minRollHeight = 300		--@var: minRollHeight | Alto m�nimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles
		groupBox grpFolderToLoad "Cam To Load" pos:[10,5] width:500 height:50
		editText edtText "Folder:" pos:[20,25] width:380 height:20
		button btnLoad "Load" pos:[410,25] width:90 height:20
			
		groupBox grpVideosToLoad "Videos To Load" pos:[10,60] width:500 height:50
		checkbox chkVideoAnim "Anim" pos:[20,80] checked:true
		checkbox chkVideoCache "Cache" pos:[90,80] checked:true
		checkbox chkVideoCloth "Cloth" pos:[160,80] enabled:true
		checkbox chkVideoLayout "Layout" pos:[230,80] enabled:true
			
		groupBox grpFolderOptions "Folder Options" pos:[10,115] width:500 height:50
		button btnOpenLoad "Open Video Folder" pos:[20,135] width:110 height:20
		button btnUpdateVideoFolder "Update Video Folder" pos:[140,135] width:110 height:20
		checkbox chkAutoUpdateFolder "Auto Update Folder" pos:[270,140] checked:true
			
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		fn updateUi =
		(
			-- Guardamos en un array los checkbox
			_chkBtnVideos = #(chkVideoAnim, chkVideoCache, chkVideoCloth, chkVideoLayout)
			_checkedVideos = #()
			
			-- Recorremos los botones y donde encontramos una casilla marcada la guardamos.
			for i = 1 to _chkBtnVideos.count where _chkBtnVideos[i].checked do
				append _checkedVideos _chkBtnVideos[i].checked

			-- Si hay dos marcado deshabilitamos el resto sino los habilitamos.
			if _checkedVideos.count == 2 then
				for i = 1 to _chkBtnVideos.count where not _chkBtnVideos[i].checked do 
					_chkBtnVideos[i].enabled = false
			else
				for i = 1 to _chkBtnVideos.count where not _chkBtnVideos[i].checked do
					_chkBtnVideos[i].enabled = true
		)
		

		
		------------------------------------------------
		--GETS
		------------------------------------------------
		--@fn | getFolder | Obtenemos el folder de la carpeta que le pasamos.
		fn getFolder pathFolder subFolder:#video =
		(
			_filterPath = filterString pathFolder "_"
			_finalPath = undefined
			
			-- Filtramos por si se le pasa el nombre directamente del folder
			if _filterPath.count > 2 then
			(
				-- Filtramos con el nombre de las tarjetas del trello, si son lit son 4 partes, si normales son 3.
				if _filterPath.count == 4 then
				(
					_pathSeq = _filterPath[2] + "_" + _filterPath[3]
					_pathCam = _filterPath[4]
				)
				else if _filterPath.count == 3 then
				(
					_pathSeq = _filterPath[1] + "_" + _filterPath[2]
					_pathCam = _filterPath[3]
				)
				
				_finalPath = @"Y:\sequence\movie\" + _pathSeq + @"\cam\" + _pathCam + @"\" + (toLower (subFolder as string))
			)
			else
			(
				_finalPath = pathFolder
-- 				print _filterPath
			)
			
			_finalPath
		)
		
		
		--@fn | getVideoByType | Obtenemos los tipo de archivos de video que le indicamos.
		fn getVideoByType folder type:#anim =
		(
			_filesToLoad = lb.io.getFilesFromSubFolders folder
			
-- 			print folder
			
			-- Files
			_video = ""
			
			-- Bucle para revisar el tipo de archivo.
			for f in _filesToLoad do
			(
				_filesFilter = (filterString f "\\")
				_filesFilterName = _filesFilter[_filesFilter.count]
				_fileNameFilter = filterString  _filesFilterName "_"
				_fileNameFilter = _fileNameFilter[_fileNameFilter.count]
				
-- 				print "entra"
				
				case type of
				(
					#anim:	if (if (findstring _fileNameFilter lb.nc.NC_animFileName) != undefined do (findstring _fileNameFilter (lb.nc.NC_animFileName + ".mov")) != undefined) != undefined then _video = f
					#cache: if (if (findstring _fileNameFilter lb.nc.NC_PCfileName) != undefined do (findstring _fileNameFilter (lb.nc.NC_PCfileName + ".mov")) != undefined) != undefined then _video = f
					#cloth: if (if (findstring _fileNameFilter lb.nc.NC_ClothFileName) != undefined do (findstring _fileNameFilter (lb.nc.NC_ClothFileName + ".mov")) != undefined) != undefined then _video = f
					#layout: if (if (findstring _fileNameFilter lb.nc.NC_layoutFileName) != undefined do (findstring _fileNameFilter (lb.nc.NC_layoutFileName + ".mov")) != undefined) != undefined then _video = f
				)
			)
			
			_video
		)
		
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
		--@gets: point2 | size | Tama�o nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona m�s peque�a que el m�nimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al m�nimo.
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
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuraci�n de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tama�o
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
			
			--almacena �ltimo nombre de folder.
			lb.xml.setAttribute parent.cfgFile ("rollMain/editTextFolder") "text" (rollMainDef.edtText.text)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuraci�n de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = undefined 
			_height = undefined 
			_posX = undefined 
			_posY = undefined

			if doesFileExist parent.cfgFile do 
			(
				--------------------------------------------------------------------------------
				--Los parametros de la tool le�dos del xml de config van aqui

				-- ancho y alto del rollout
				_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
				_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
					
				--posicion
				_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
				_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				_editText = (lb.xml.getAttribute parent.cfgFile ("rollMain/editTextFolder") "text")

				--------------------------------------------------------------------------------
			)	
			
			--establece minimos
			if _width == undefined then _width = minRollWidth
			else if _width < minRollWidth then _width = minRollWidth
			
			if _height == undefined then _height = minRollHeight
			else if _height < minRollHeight then _height = minRollHeight
			
			if _posX == undefined then _posX = 0
			else if _posX < 0 then _posX = 0
			
			if _posY == undefined then _posY = 0
			if _posY < 0 then _posY = 0
				
			if _editText != undefined then rollMainDef.edtText.text = _editText
				
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
		
		on btnLoad pressed do
		(
			_video01 = ""
			_video02 = ""
			_chkBtnVideos = #(chkVideoAnim, chkVideoCache, chkVideoCloth, chkVideoLayout)
			_filesToCheck = #()
			_folder = getFolder edtText.text
			
			-- Revisamos si la ventana del ramPlayer esta abierta y si es asi la cerramos. Tenemos
			-- que hacerlo con UI accessor porque no hay funci�n d max para cazarlo.
			_desktopHWND = windows.getDesktopHWND()
			_desktopChildren = windows.getChildrenHWND _desktopHWND
			_ramPlayerDialog = undefined
			
			_stop = false
			for child in _desktopChildren where not _stop do
			(
				if matchPattern child[5] pattern:"Frame:*" do 
				(
					_ramPlayerDialog = child
					_stop = true
				)
			)
			
			if _ramPlayerDialog != undefined then UIAccessor.CloseDialog _ramPlayerDialog[1]
			
			-- Recorremos los checkBox que est�an marcados para saber que video tenemos que cargar
			for chk in _chkBtnVideos where chk.checked do
				append _filesToCheck (chk.caption as name)

			if _filesToCheck.count == 1 then
			(	
				if chkAutoUpdateFolder.checked then lb.svn.svnUpdate _folder type:#fullRecursive
				
				_video01 = getVideoByType _folder type:_filesToCheck[1]
			)
			else if _filesToCheck.count > 1 then
			(
				if chkAutoUpdateFolder.checked then lb.svn.svnUpdate _folder type:#fullRecursive
					
				_video01 = getVideoByType _folder type:_filesToCheck[1]
				_video02 = getVideoByType _folder type:_filesToCheck[2]
			)
			
			if _video01.count > 1 and _video02.count > 1  then
			(
				ramplayer _video01 _video02
-- 				copyFile _video01
			)
			else
				lb.message.show "Don�t founded videos" type:#message
		)
		
		
		on btnOpenLoad pressed do
		(
			
			_folder = (getFolder edtText.text)
			
			if _folder != undefined then
				ShellLaunch _folder ""
		)
		
		on btnUpdateVideoFolder pressed do
		(
			_folder = getFolder edtText.text
			
			if _folder != undefined do
				lb.svn.svnUpdate _folder type:#fullRecursive
			
-- 			print "entra"
		)
		
		on chkVideoAnim changed state do
			updateUi()
		
		on chkVideoCache changed state do
			updateUi()
				
		on chkVideoCloth changed state do
			updateUi()
						
		on chkVideoLayout changed state do
			updateUi()
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensi�n. El rollout principal de la herramienta.
		--@gets: point2 | size | tama�o al que se ha redimensionado el rollout
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
			updateUi()
-- 			print parent
-- 			print "entra"
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
			
			parent.opened = false --indica que la herramienta est� cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_ramPlayerLoader
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
			
		opened = false,			--@var: opened | Indica si la herramienta est� abierta.
			
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
		--@fn: boolean | isOpen | Devuelve informaci�n true o false, si la herramienta est� abierta o cerrada.
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
			this.opened = true --indica que la herramienta est� abierta
		),--execute
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
		------------------------------------------------
		fn close =
		(
			this.destroyInterface() --destruye el interface.
			this.opened = false --indica que la herramienta est� cerrada.
		),
		
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrer�as en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librer�a.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librer�as hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecuci�n al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addTool this --a�ade la tool a la libreria principal	
		)		
		
	)--tl_ramPlayerLoader
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_ramPlayerLoader() --crea la herramienta
)