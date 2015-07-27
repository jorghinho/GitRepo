------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta rCameraMerger.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta rCameraMerger.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "R Camera Merger"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual

		local minRollWidth = 180		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 146		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupBox grpOptions "" pos:[5,0] width:170 height:90
		checkbox chkDeleteOldR "Delete old R camera" pos:[10,10] width:160 height:15 checked:true
		checkbox chkReparent "Parent R camera to L one" pos:[10,30] width:160 height:15 checked:true
		checkbox chkSaveAsR "Save as R camera file" pos:[10,50] width:160 height:15 checked:true
		checkbox chkConfigureLPM "Change LPM settings" pos:[10,70] width:160 height:15 checked:true
		
		button btnMergeCamera "Merge" pos:[5,95] width:170 height:45
		
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

		----------------------------------------------------------------------------------
		--obtiene la camara de la escena correspondiente al ojo derecho.
		----------------------------------------------------------------------------------
		fn getSceneRightEyeCamera =
		(
			_rEyeCamera = undefined
			
			for cam in cameras where superclassof cam == camera do
			(
				_camParts = filterstring cam.name "_"
				
				if _camParts.count == 3 and _camParts[3] == "R" then
				(
					_rEyeCamera = cam
				)--if _camParts
			)--for
			
			_rEyeCamera
		)--fn getSceneRightEyeCamera	

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
		--COMMON
		------------------------------------------------
		
		---------------------------------------------------------------------------------------------------------------
		--hace merge de la camara y completa el resto de operaciones
		---------------------------------------------------------------------------------------------------------------
		on btnMergeCamera pressed do
		(
			if LPM_Treeview_rollout == undefined then 
			(
				macros.run "lbPassManager" "lbTools: Lighting"
				destroyDialog LPM_Treeview_rollout
			)
			
			_message = ""
			_type = #warning
			_width = 500
			_process = true

			_stereoCamPath = ""
			_nameParts = filterString maxfilename "()"
			if _nameParts.count == 3 then _stereoCamPath = maxFilePath + (substituteString maxfileName _nameParts[2] "stereoSetup")

			setWaitCursor() --cursor de espera

			if doesFileExist _stereoCamPath then
			(
				--si hay que salvarlo como camara R y ya existe, comprueba que se pueda sobreescribir antes de hacer nada
				if chkSaveAsR.checked then
				(
					if(matchPattern (maxFilePath + maxfileName) pattern:((lb.nc.swapUnit lb.nc.NC_seqRenderPathPattern "*") + lb.nc.NC_seqRenderNamePattern)) or
					(matchPattern (maxFilePath + maxfileName) pattern:((lb.nc.swapUnit lb.nc.NC_seqRenderPathPattern "*") + lb.nc.NC_seqRenderFxNamePattern)) then
					(
						_newFilePath = maxFilePath + "R_" + maxfileName
						if doesFileExist _newFilePath then
						(
							_isReadOnly = getFileAttribute _newFilePath #readOnly
							
							if _isReadOnly then
							(
								_message = (_newFilePath + "-> Already exists and it's readOnly (It could need a GET LOCK)")
								_type = #error
								_process = false
							)--if
						)--if
					)--if
					else
					(
						_message = ((maxFilePath + maxfileName) + "-> Current file doesn't match L eye pattern.\nSo camera wont be merged and R eye file wont be saved. Rename it first as L eye file.\n")
						_message += "\nRight render pattern: " + ((lb.nc.swapUnit lb.nc.NC_seqRenderPathPattern "*") + lb.nc.NC_seqRenderNamePattern)
						_message += "\nRight renderFx pattern: " + ((lb.nc.swapUnit lb.nc.NC_seqRenderPathPattern "*") + lb.nc.NC_seqRenderFxNamePattern)
						_width = 700
						_process = false
					)
				)
				
				if _process then
				(
					_fileObjNames = getMAXFileObjectNames _stereoCamPath
					_camObjName = undefined
					
					for obj in _fileObjNames where matchPattern obj pattern:"cam_???_R" do _camObjName = obj
						
					--si hay camara prepara
					if _camObjName != undefined then
					(
						--se coloca al inicio del rango para que la camara se mergee en el lugar correcto.
						slidertime = animationRange.start
						
						--modifica las opciones de merge--------------------------------------------------------
						_dupsOption = #deleteOldDups
						_matOption = #useSceneMtlDups
						_reparentOption = #alwaysReparent
						
						if not chkDeleteOldR.checked do _dupsOption = #promptDups
						if not chkReparent.checked do _reparentOption = #promptReparent
						
						--intenta hacer el merge de la cámara.
						if mergeMaxFile _stereoCamPath #(_camObjName) #select _dupsOption _matOption _reparentOption then
						(
							------------------------------------------------------------------------
							--si hay que cambiar las propiedades de LPM lo hace.
							if chkConfigureLPM.checked then
							(
								_camObj = (getCurrentSelection())[1]
								_lpmRoot = $'LPM_Root'
									
								--si hay configuración de LPM
								if isValidNode _lpmRoot then
								(
									--si LPM tiene configurado por defecto lbdata001 en lugar de lbdata002 como salida, se lo cambia primero al 2
									_veryOldLbbackupPath = @"Z:\sequence\seq_???*\cam\cam???\frame\"
									_oldLbbackupPath = @"\\lbdata001\Z\frame\seq_???*\cam\cam???\"
									_optPath = _lpmRoot.rootDir
									
									if matchPattern (_lpmRoot.rootDir) pattern:_veryOldLbbackupPath then
									(
										_optPath = substituteString _optPath "\\frame\\" "\\"
										
										_optPath = substituteString _optPath "z:\\sequence" "\\\\lbdata002\\z\\frame"
										_optPath = substituteString _optPath "Z:\\sequence" "\\\\lbdata002\\z\\frame"
									)
									
									if matchPattern (_lpmRoot.rootDir) pattern:_oldLbbackupPath then
									(
										_optPath = substituteString _optPath "\\\\lbdata001\\" "\\\\lbdata002\\"
										_optPath = substituteString _optPath "\\\\lbdata001\\" "\\\\lbdata002\\"
									)									

									--cambia el path de salida
									if matchPattern _optPath pattern:((lb.nc.swapUnit (substituteString lb.nc.NC_seqFramePathNewPattern "\\cam\\" "\\") "*") + "*") then
									(
										--_defPath = (_optPath + "R\\") ESTA LETRA ES SOLO PARA LA PRODUCCION DE TADEO
										_defPath = _optPath
										_defPath = substituteString _defPath "\\frame\\" "\\frameR\\" --para que cambie de ruta de salida
										
										makeDir _defPath --crea la ruta si no existe
										makeDir (_defPath + "final\\") --crea la ruta si no existe para final
										makeDir (_defPath + "pass\\") --crea la ruta si no existe para final
										
										_lpmRoot.rootDir = _defPath --cambia la ruta
									)
									else
										_message = ("LPM output directory doesn't match L eye frames output folder, so R output folder cannot be configured.")
									
									----------------------------------------------------------
									_lpmRoot.renderCamera = _camObj
									
									--obtiene los common properties
									_lpmNodes = $'LPM_*'
									_commonPropsNodes = for o in _lpmNodes where o.type == "commonProps" collect o
									
									--Pone la camara R en todos los common properties.
									for cp in _commonPropsNodes do cp._camera = _camObj
									----------------------------------------------------------
									
									if LPM_Treeview_rollout.open then LPM_Treeview_rollout.updateTV() --actualiza el arbol
								)
								else
								(
									_message = ("There is no LPM information. LPM settings will not be changed.")
								)
							)
							------------------------------------------------------------------------
							
							------------------------------------------------------------------------
							--si hay que salvarlo como camara de ojo R lo intenta.
							if chkSaveAsR.checked then
							(
								--si al archivo cumple el patron de camara L intenta guardarlo como camra R
								if (matchPattern (maxFilePath + maxfileName) pattern:((lb.nc.swapUnit lb.nc.NC_seqRenderPathPattern "*") + lb.nc.NC_seqRenderNamePattern)) or
								(matchPattern (maxFilePath + maxfileName) pattern:((lb.nc.swapUnit lb.nc.NC_seqRenderPathPattern "*") + lb.nc.NC_seqRenderFxNamePattern)) then
								(
									_newFilePath = maxFilePath + "R_" + maxfileName
									if not saveMaxFile _newFilePath then _message = ("Merge Success but File couldn't be saved as R eye file. Try to save it")
								)
								else --si no cumple el patron
								(
									_message = ("File doesn't match L eye pattern and can't be saved as R eye file.")
								)
							)
							------------------------------------------------------------------------
						)
						else --si no consigue mergear
						(
							_message = ("Merge failed")
						)
						-------------------------------------------------------------------------------------------
					)
					else --si no hay camara que mergear
					(
						_message = ("There is not R camera in source file -> " + _stereoCamPath)
					)
					
					 -------------------------------------------------------------------------------------------------------------------
				)--if _process				
			)
			else --si el archivo desde el que mergear la camara no existe 
			(
				_message = ("R camera source file doesn't exist -> " + _stereoCamPath)
			)--if

			setArrowCursor() --cursor normal

			if _message != "" then lb.message.show _message type:#message pos:undefined size:[_width,75] modal:true 
			else
			(
				_message = "R camera merged\n"
				if chkSaveAsR.checked then _message += "File saved as R camera"
				lb.message.show _message type:#message pos:undefined size:[300,75] modal:true
			)	
		)

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
	--@struct: rCameraMerger | Contiene la herramienta rCameraMerger.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_rCameraMerger
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "R Camera Merger",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_rCameraMerger
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_rCameraMerger() --crea la herramienta
)