------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de MentalReuseFG
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute:overrideMentalReuseFGInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideMentalReuseFGInfo = attributes overrideMentalReuseFGInfo   
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de MentalReuseFG."
			
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"mentalReuseFG"	--@var | subType | Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--Parámetros de backup
			
			------------------------------------------------
			--Parámetros de backup y apply
			_IlluminationCacheMode type:#integer default:0 --@var | _IlluminationCacheMode | modo de cache de iluminacion.
			_SkipFinalRender type:#boolean default:false
			
			_UseFinalGatherFile type:#boolean default:false
			_FinalGatherFreeze type:#boolean default:false
			_FGInterpolateNFrames type:#integer default:2
			_FinalGatherFilename type:#string default:""
			_FinalGatherTempFilename type:#string default:""
				
			_PhotonMapUseFile type:#boolean default:false
			_PhotonFreeze type:#boolean default:false			
			_PhotonMapFilename type:#string default:""
			_FinalGatherOnly type:#boolean default:false
			_PhotonsOnly type:#boolean default:false
			
			------------------------------------------------
			--Parámetros de apply
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el listado de overrides permitidos.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Global Tuning Parameters Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var : editCA | Almacena los custom attributes de edición.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
-- 		label lblSoftShadowsPrecision "Soft Shadows Precision (Multiplier)" pos:[5,5] width:200 --@control | lblSoftShadowsPrecision | Desplegable de precisión de sombras
-- 		dropdownList ddlSoftShadowsPrecision "" pos:[235,5] items:#("0,125","0,25","0,5","1","2","4","8","16") height:30 width:60 --@control | ddlSoftShadowsPrecision | Desplegable de precisión de sombras
-- 		label lblGlossyReflectionsPrecision "Glossy Reflections Precision (Multiplier)" width:200 pos:[5,35] --@control | lblGlossyReflectionsPrecision | Desplegable de precisión de sombras
-- 		spinner spnGlossyReflectionsPrecision "" height:30 pos:[232,35] range:[0.0,20.0,0.0] type:#float scale:0.01 fieldWidth:50  --@control | spnGlossyReflectionsPrecision | Desplegable de precisión de reflexión de glossy
-- 		label lblGlossyRefractionsPrecision "Glossy Refractions Precision (Multiplier)" width:200 pos:[5,65] --@control | lblGlossyRefractionsPrecision | Desplegable de precisión de sombras
-- 		spinner spnGlossyRefractionsPrecision "" height:30 pos:[232,65] range:[0.0,20.0,0.0] type:#float scale:0.01 fieldWidth:50 --@control | spnGlossyRefractionsPrecision | Desplegable de precisión de reflracción de glossy
		
		groupbox grpMode "Mode" pos:[5,5] width:290 height:60
		dropdownList ddlMode "" pos:[13,20] height:20 width:275 items:#("Single File Only (Best for Walkthrough and Stills", "One File Per Frame (Best For Animated Objects)")
		checkBox chkSkipFinalRender "Calculate FG/GI and Skip Final Rendering" pos:[15,45] checked:false
		
		groupbox grpFGmap "Final Gather Map" pos:[5,70] width:290 height:85
		dropdownList ddlFinalGatherMap "" pos:[13,85] height:20 width:275 items:#("Off (Do not Cache Map to Disk)", "Incrementally Add FG Points to FG Map Files", "Read FG Points Only from Existing FG Map Files")
		spinner spnInterpolateFrames "Interpolate Over N Frames" pos:[96,110] height:15 range:[1,1000000,2] type:#integer fieldWidth:50 enabled:false
		button btnFGmapChange "..." pos:[15,130] width:20 height:17 enabled:false
		edittext edtFGfile "" pos:[33,130] width:233 readOnly:true enabled:false
		button btnFGmapDelete "X" pos:[268,130] width:20 height:17 enabled:false
		
		groupbox grpCausticsMap "Caustics and Global Illumination Photon Map" pos:[5,160] width:290 height:65
		dropdownList ddlCausticsMap "" pos:[13,175] height:20 width:275 items:#("Off (Do not Cache Map to Disk)", "Read/Write Photons to Photon Map Files", "Read Photons Only from Existing Photon Map Files")
		button btnCusticsMapChange "..." pos:[15,200] width:20 height:17 enabled:false
		edittext edtCausticsFile "" pos:[33,200] width:233 readOnly:true enabled:false
		button btnCausticsDelete "X" pos:[268,200] width:20 height:17 enabled:false
		
		button btnOk "OK" pos:[5,235] width:145 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[150,235] width:145 --@control | btnCancel | Cancela los cambios y cierra.
		
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
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			------------------------------------------------
			ddlMode.selection = (editCA._IlluminationCacheMode + 1)
			chkSkipFinalRender.checked = editCA._SkipFinalRender
 			------------------------------------------------
			
			------------------------------------------------
			if not editCA._UseFinalGatherFile then
				ddlFinalGatherMap.selection = 1
			else if not editCA._FinalGatherFreeze then
				ddlFinalGatherMap.selection = 2
			else
				ddlFinalGatherMap.selection = 3
			
			spnInterpolateFrames.value = editCA._FGInterpolateNFrames
			edtFGfile.text = editCA._FinalGatherFilename
			
			spnInterpolateFrames.enabled = ddlFinalGatherMap.selection != 1
			btnFGmapChange.enabled = ddlFinalGatherMap.selection != 1
			edtFGfile.enabled = ddlFinalGatherMap.selection != 1
			btnFGmapDelete.enabled = ddlFinalGatherMap.selection != 1
			------------------------------------------------
			
			------------------------------------------------
			if not editCA._PhotonMapUseFile then
				ddlCausticsMap.selection = 1
			else if not editCA._PhotonFreeze then
				ddlCausticsMap.selection = 2
			else
				ddlCausticsMap.selection = 3
			
			edtCausticsFile.text = editCA._PhotonMapFilename
			
			btnCusticsMapChange.enabled = ddlCausticsMap.selection != 1
			edtCausticsFile.enabled = ddlCausticsMap.selection != 1
			btnCausticsDelete.enabled = ddlCausticsMap.selection != 1
			------------------------------------------------
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			--sin operaciones
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(			
			--sin operaciones
		)
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--no guarda settings
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | ddlMode | Dropdown que cambia de seleccion
		--@gets: integer | index | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlMode selected index do
		(
			editCA._IlluminationCacheMode = (index - 1)
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado.
		--@control: checkBox | chkSkipFinalRender | checkBox que cambia de estado
		--@gets: boolean | state | Nuevo estado.
		------------------------------------------------
		on chkSkipFinalRender changed state do
		(
			editCA._SkipFinalRender = state
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | ddlFinalGatherMap | Dropdown que cambia de seleccion
		--@gets: integer | index | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlFinalGatherMap selected index do
		(
			case index of
			(
				1:
				(
					editCA._UseFinalGatherFile = false
				)
				
				2:
				(
					editCA._UseFinalGatherFile = true
					editCA._FinalGatherFreeze = false
				)
				
				3:
				(
					editCA._UseFinalGatherFile = true
					editCA._FinalGatherFreeze = true
				)
			)--case
			
			spnInterpolateFrames.enabled = ddlFinalGatherMap.selection != 1
			btnFGmapChange.enabled = ddlFinalGatherMap.selection != 1
			edtFGfile.enabled = ddlFinalGatherMap.selection != 1
			btnFGmapDelete.enabled = ddlFinalGatherMap.selection != 1
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor.
		--@control: spinner | spnInterpolateFrames | spinner que cambia de valor.
		--@gets: integer | vale | Nuevo valor.
		------------------------------------------------
		on spnInterpolateFrames changed val do
		(
			editCA._FGInterpolateNFrames = val
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton.
		--@control: button | btnFGmapChange | Boton presionado.
		------------------------------------------------
		on btnFGmapChange pressed do
		(
			_fgMapFile = editCA._FinalGatherFilename
			if ddlFinalGatherMap.selection == 2 then _fgMapFile = getSaveFileName filename:_fgMapFile types:"Final Gather Maps (*.fgm)|*.fgm|"
			else _fgMapFile = getOpenFileName filename:_fgMapFile types:"Final Gather Maps (*.fgm)|*.fgm|"
			
			if _fgMapFile != undefined and _fgMapFile != "" then
			(
				editCA._FinalGatherFilename = _fgMapFile
				edtFGfile.text = _fgMapFile
			)--if
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton.
		--@control: button | btnFGmapDelete | Boton presionado.
		------------------------------------------------
		on btnFGmapDelete pressed do
		(
			editCA._FinalGatherFilename = ""
			edtFGfile.text = ""
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el spinner.
		--@control: dropdownlist | ddlFinalGatherMap | Dropdown que cambia de seleccion
		--@gets: integer | index | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlCausticsMap selected index do
		(
			case index of
			(
				1:
				(
					editCA._PhotonMapUseFile = false
				)
				
				2:
				(
					editCA._PhotonMapUseFile = true
					editCA._PhotonFreeze = false
				)
				
				3:
				(
					editCA._PhotonMapUseFile = true
					editCA._PhotonFreeze = true
				)
			)--case
			
			btnCusticsMapChange.enabled = ddlCausticsMap.selection != 1
			edtCausticsFile.enabled = ddlCausticsMap.selection != 1
			btnCausticsDelete.enabled = ddlCausticsMap.selection != 1
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton.
		--@control: button | btnCusticsMapChange | Boton presionado.
		------------------------------------------------
		on btnCusticsMapChange pressed do
		(
			_casuticsMap = editCA._PhotonMapFilename
			if ddlCausticsMap.selection == 2 then _casuticsMap = getSaveFileName filename:_casuticsMap types:"Photon Maps (*.pmap)|*.pmap|"
			else _casuticsMap = getOpenFileName filename:_casuticsMap types:"Photon Maps (*.pmap)|*.pmap|"
			
			if _casuticsMap != undefined and _casuticsMap != "" then
			(
				editCA._PhotonMapFilename = _casuticsMap
				edtCausticsFile.text = _casuticsMap
			)--if
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton.
		--@control: button | btnCausticsDelete | Boton presionado.
		------------------------------------------------
		on btnCausticsDelete pressed do
		(
			editCA._PhotonMapFilename = ""
			edtCausticsFile.text = ""
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Cancela los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnCancel pressed do
		(
			destroyDialog parent.rollMain
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
			--no se redimensiona
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			parent = lb.passManager.getCurrentEditInstance()
			editCA = parent.editBackupNode.custAttributes[#overrideMentalReuseFGInfo]
			loadOverrideInfo()
			loadSettings()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(	
			onCloseOperations()
			saveSettings()			
		)
		
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: override | Contiene todas las funciones de un override de Material.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideMentalReuseFG
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		type = "override",		--@var | type | Indica que es un override.
		subType = lb.overrides.getFileOverrideName (getThisScriptFilename() as string),	--@var | subType | Indica que tipo de override concreto almacena.
		relatedTypes = #(), --@var | relatedTypes | Tipos de overrides relacionados.
		
		stateMessage = "", --@var | stateMessage | Mensaje del estado actual del override.
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,						--@var | infoNodeCA | Almacena el customAttribute de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideMentalReuseFGInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideMentalReuseFGInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef, --@var: rollMain | Almacena el rollout de edicion del override.
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------
			
		------------------------------------------------
		--@fn: string | getType | Devuelve el tipo del override.
		------------------------------------------------
		fn getType =
		(
			this.infoNodeCA.type
		),
			
		------------------------------------------------
		--@fn: string | getSubType | Devuelve el subtipo del override.
		------------------------------------------------
		fn getSubType =
		(
			this.infoNodeCA.subType
		),
		
		------------------------------------------------
		--@fn: node | getInfoNode | Devuelve el nodo físico de la escena que contiene la información del override.
		------------------------------------------------
		fn getInfoNode =
		(
			this.infoNode
		),
		
		------------------------------------------------
		--@fn: dotneObject | getUiObj | Devuelve el objeto de interface .net que controla este objeto.
		------------------------------------------------
		fn getUiObj =
		(
			this.uiObj
		),
		
		------------------------------------------------
		--@fn: override | getOverrideManager | Devuelve el override principal del que cuelga el especifico.
		------------------------------------------------
		fn getOverrideManager =
		(
			this.overrideManager
		),
		
		------------------------------------------------
		--@fn: container | getParentContainer | Devuelve el contenedor del que cuelga este override.
		------------------------------------------------
		fn getParentContainer =
		(
			if this.overrideManager != undefined then this.overrideManager.getParentContainer() else undefined
		),
		
		
		------------------------------------------------
		--@fn: string | getInfo | Devuelve la informacion que se debe mostrar en el UI.
		------------------------------------------------
		fn getInfo =
		(
			_info = ""
			
			_info += if this.infoNodeCA._IlluminationCacheMode == 0 then "Single, " else "Per Frame, "
			_info += if this.infoNodeCA._SkipFinalRender then "Skip, " else ""
			
			if not this.infoNodeCA._UseFinalGatherFile then
				_info += "FG Off"
			else if not this.infoNodeCA._FinalGatherFreeze then
				_info += "FG Incremental"
			else
				_info += "FG Read"
			
			_info
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok
			
			--busca el override de render precedente obligatorio
			_rendererOverride = (this.getOverrideManager()).getRelativeAncestorOverride "renderer"
			
			if _rendererOverride != undefined then --si lo encuentra
			(
				--si el renderer no es mental ray, lo marca como erroneo ya que no va a poder aplicar los parametros
				_renderer = (_rendererOverride.customOverride.infoNodeCA.currentRenderer)
				if _renderer != "mental_ray_renderer" then
				(
					_state = #error
					this.stateMessage = "Previous 'renderer' override in the tree must be set to 'mental ray'"
				)
				else
				(
					--busca el override de final gather precedente obligatorio
					_mentalFinalGatherOverride = (this.getOverrideManager()).getRelativeAncestorOverride "mentalFinalGather"
					
					if _mentalFinalGatherOverride != undefined then --si lo encuentra
					(
						--si el renderer no es mental ray, lo marca como erroneo ya que no va a poder aplicar los parametros
						_enabled = (_mentalFinalGatherOverride.customOverride.infoNodeCA.FinalGatherEnable2)
						if not _enabled then
						(
							_state = #error
							this.stateMessage = "Final Gather must be enabled in the previous 'Final Gather' override"
						)
					)
					else --si no lo encuentra
					(
						this.stateMessage = "There must be a previows 'Final Gather' override in the tree"
						_state = #error
					)--if else
				)
			)
			else --si no lo encuentra
			(
				this.stateMessage = "There must be a previows 'renderer' override in the tree"
				_state = #error
			)--if else
			
			_state
		),
		
		------------------------------------------------
		--@fn: name | getStateMessage | Devuelve el mensaje del estado actual del override.
		------------------------------------------------
		fn getStateMessage =
		(
			this.stateMessage
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setUiObj | Sustituye el objeto de interface relacionado con el override.
		--@gets: dotNetObject | newUiObj | Nuevo elemento de interface relacionado con el override.
		------------------------------------------------
		fn setUiObj newUiObj =
		(
			this.uiObj = newUiObj
		),
		
		------------------------------------------------
		--@fn: undefined | setOverrideManager | Sustituye el override principal del que cuelga el especifico.
		--@gets: override | newOverrideManager | Nuevo override principal.
		------------------------------------------------
		fn setOverrideManager newOverrideManager =
		(
			this.overrideManager = newOverrideManager
		),
			
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | redirect | Realiza redireccion de sources en el override.
		--@gets: string | sourcePattern | Parte del path que sustituir.
		--@gets: string | mappedPattern | Parte del path por la cual sustituir.
		------------------------------------------------
		fn redirect sourcePattern mappedPattern =
		(
			this.infoNodeCA._FinalGatherFilename = substituteString ((tolower (getfilenamepath this.infoNodeCA._FinalGatherFilename)) + (getfilenamefile this.infoNodeCA._FinalGatherFilename) + (getfilenametype this.infoNodeCA._FinalGatherFilename)) (tolower sourcePattern) (tolower mappedPattern)
		),

		------------------------------------------------
		--@fn: undefined | updateUIinfo | Actualiza la informacion del override en su objeto de UI si tuviera.		
		------------------------------------------------
		fn updateUIinfo =
		(
			--si hay nodo que actualizar
			if this.getUiObj() != undefined then
			(
				--actualiza los valores de las columnas
				(this.getUiObj()).setValue 1 (this.getInfo())
				(this.getUiObj()).setValue 5 (this.getState() as string)
					
				--actualiza el icono de estado
				lb.passManagerUI.rollMain.updateTrvContainerAppearance mode:#state node:(this.getUiObj())
					
				--actualiza los overrides relacionados
				for _relType in this.relatedTypes do
				(
					_relOverrides = (this.getOverrideManager()).getRelativeDescendantsOverride _relType
					for _relOv in _relOverrides do _relOv.updateUIinfo()
				)--for
			)
		),
		
		------------------------------------------------
		--@fn: boolean | createBackup | Crea el backup de este override antes de aplicarse
		--@gets: node | backupNode | Objeto en el que hacer el backup.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			if saveLogs then lb.log.add ("BACKUP process started.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideMentalReuseFGInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				if (classof renderers.current) == mental_ray_renderer then
				(
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._IlluminationCacheMode = renderers.current.IlluminationCacheMode 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._SkipFinalRender = renderers.current.SkipFinalRender 
					
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._UseFinalGatherFile = renderers.current.UseFinalGatherFile 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._FinalGatherFreeze = renderers.current.FinalGatherFreeze 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._FGInterpolateNFrames = renderers.current.FGInterpolateNFrames 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._FinalGatherFilename = renderers.current.FinalGatherFilename 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._FinalGatherTempFilename = renderers.current.FinalGatherTempFilename 
						
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._PhotonMapUseFile = renderers.current.PhotonMapUseFile 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._PhotonFreeze = renderers.current.PhotonFreeze 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._PhotonMapFilename = renderers.current.PhotonMapFilename 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._FinalGatherOnly = renderers.current.FinalGatherOnly 
					backupNode.custAttributes[#overrideMentalReuseFGInfo]._PhotonsOnly = renderers.current.PhotonsOnly
					
					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("BACKUP: Mental ray is not the current renderer.") sender:("override." + (this.getSubType())) type:#warning level:(logLevel+1)
					_success = true
				)
			)--if
			else
			(
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node is not valid.")
				_success = false
			)
			
			if _success then
			(
				if saveLogs then lb.log.add ("BACKUP process complete.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
			)
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup Node is not correct.") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			if saveLogs then lb.log.add ("RESTORE process start.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			
			if isValidNode backupNode then
			(
				if backupNode.custAttributes[#overrideMentalReuseFGInfo] != undefined then
				(
					if (classof renderers.current) == mental_ray_renderer then
					(
						renderers.current.IlluminationCacheMode = backupNode.custAttributes[#overrideMentalReuseFGInfo]._IlluminationCacheMode
						renderers.current.SkipFinalRender = backupNode.custAttributes[#overrideMentalReuseFGInfo]._SkipFinalRender
						
						renderers.current.UseFinalGatherFile = backupNode.custAttributes[#overrideMentalReuseFGInfo]._UseFinalGatherFile
						renderers.current.FinalGatherFreeze = backupNode.custAttributes[#overrideMentalReuseFGInfo]._FinalGatherFreeze
						renderers.current.FGInterpolateNFrames = backupNode.custAttributes[#overrideMentalReuseFGInfo]._FGInterpolateNFrames
						renderers.current.FinalGatherFilename = backupNode.custAttributes[#overrideMentalReuseFGInfo]._FinalGatherFilename
						renderers.current.FinalGatherTempFilename = backupNode.custAttributes[#overrideMentalReuseFGInfo]._FinalGatherTempFilename
							
						renderers.current.PhotonMapUseFile = backupNode.custAttributes[#overrideMentalReuseFGInfo]._PhotonMapUseFile
						renderers.current.PhotonFreeze = backupNode.custAttributes[#overrideMentalReuseFGInfo]._PhotonFreeze
						renderers.current.PhotonMapFilename = backupNode.custAttributes[#overrideMentalReuseFGInfo]._PhotonMapFilename
						renderers.current.FinalGatherOnly = backupNode.custAttributes[#overrideMentalReuseFGInfo]._FinalGatherOnly
						renderers.current.PhotonsOnly = backupNode.custAttributes[#overrideMentalReuseFGInfo]._PhotonsOnly
						
						_success = true
					)
					else
					(
						if saveLogs then lb.log.add("RESTORE: Mental ray is not current renderer.") sender:("override." + (this.getSubType())) type:#warning level:(logLevel+1)
						_success = true
					)
				)
				else
				(
					if saveLogs then lb.log.add("RESTORE process error. CA #overrideMentalReuseFGInfo is undefined") sender:("override." + (this.getSubType())) type:#error level:(logLevel+1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Custom attribute is not defined.")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add("RESTORE process error. Backup node is not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not valid.")
				_success = false
			)
			if _success then
			(
				if saveLogs then lb.log.add ("RESTORE process complete.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
			)
			else
			(
				if saveLogs then lb.log.add("RESTORE process failed.") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			_success = false
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel 
			if (classof renderers.current) == mental_ray_renderer then
			(
				renderers.current.IlluminationCacheMode = this.infoNodeCA._IlluminationCacheMode
				renderers.current.SkipFinalRender = this.infoNodeCA._SkipFinalRender
				
				renderers.current.UseFinalGatherFile = this.infoNodeCA._UseFinalGatherFile
				renderers.current.FinalGatherFreeze = this.infoNodeCA._FinalGatherFreeze
				renderers.current.FGInterpolateNFrames = this.infoNodeCA._FGInterpolateNFrames
				renderers.current.FinalGatherFilename = this.infoNodeCA._FinalGatherFilename
				renderers.current.FinalGatherTempFilename = this.infoNodeCA._FinalGatherTempFilename
					
				renderers.current.PhotonMapUseFile = this.infoNodeCA._PhotonMapUseFile
				renderers.current.PhotonFreeze = this.infoNodeCA._PhotonFreeze
				renderers.current.PhotonMapFilename = this.infoNodeCA._PhotonMapFilename
				renderers.current.FinalGatherOnly = this.infoNodeCA._FinalGatherOnly
				renderers.current.PhotonsOnly = this.infoNodeCA._PhotonsOnly
				
				_success = true
			)
			else
			(
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"APPLY process error. Mental Ray is not the current renderer.")
				_success = false
			)
			
			if _success then
			(
				if saveLogs then lb.log.add ("APPLY process complete.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
			)
			else
			(
				if saveLogs then lb.log.add ("APPLY process error. Mental ray is not the current renderer.") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | applyEditChanges | Aplica los cambios que se han hecho en el override durante la edicion.
		------------------------------------------------
		fn applyEditChanges =
		(
			--solo si existe el nodo de backup de override puede hacerlo
			if this.editBackupNode != undefined then
			(
				--le quita el CA del override si lo tuviera
				if this.editBackupNode.custAttributes[#overrideMentalReuseFGInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideMentalReuseFGInfo]) _prop))
					)--undo
					
					this.editBackupNode = undefined --hace que el override no tenga backup de edicion almacenado
					
					this.updateUIinfo() --actualiza la infirmacion en el UI si ha cambiado
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | createEditBackup | Crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello.		
		------------------------------------------------
		fn createEditBackup =
		(
			--solo si el override cuelga de un contenedor
			if (this.getParentContainer()) != undefined then
			(
				--obtiene el inicio de la jerarquia del arbol de contenedores
				_passTree = (this.getParentContainer()).getRootContainer()
				
				if _passTree != undefined then --si ha conseguido llegar a la raiz
				(
					--obtiene el nodo de backup de edicion de override
					this.editBackupNode = _passTree.getOverridesEditBackupNode()
					
					--solo si existe el nodo de backup de override puede hacerlo
					if this.editBackupNode != undefined then
					(
						--le quita el CA del override si lo tuviera
						if this.editBackupNode.custAttributes[#overrideMentalReuseFGInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideMentalReuseFGInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideMentalReuseFGInfo]) _prop (getProperty (this.infoNodeCA) _prop))
					)--if
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Muestra el dialogo de edicion del override.
		--@opt: Point2 | pos | [0,0] | Posicion en la que aparecera el rollout de edicion del override.
		------------------------------------------------
		fn edit pos:[0,0] =
		(
			this.createEditBackup() --crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello 			
			
			lb.passManager.setCurrentEditInstance this
			
			_size = [300, 260]
			
			_pos = pos - (_size/2)
			
			createDialog this.rollMain lockwidth:true lockheight:true pos:_pos width:_size.x height:_size.y modal:true style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: boolean | purge | Limpia el override por si se ha cambiado informacion y hay que mantenerla coherente.
		------------------------------------------------
		fn purge =
		(
			_success = false
			
			--TO DO: Aqui hacer el codigo de purga
			
			_success = true
			
			_success
		),
		
		
		------------------------------------------------
		--@fn: undefined | reset | resetea los valores a los que tiene por defecto.
		------------------------------------------------
		fn reset =
		(
			--TO DO: Aqui restaurar los valores a los que tiene por defecto
		),

		------------------------------------------------
		--@fn: undefined | storeSceneValues | Almacena los valores de la escena en el override.
		------------------------------------------------
		fn storeSceneValues =
		(
			_renderer = if classof renderers.current ==  mental_ray_renderer then renderers.current else mental_ray_renderer()
					
			this.infoNodeCA._IlluminationCacheMode = _renderer.IlluminationCacheMode 
			this.infoNodeCA._SkipFinalRender = _renderer.SkipFinalRender
			
			this.infoNodeCA._UseFinalGatherFile = _renderer.UseFinalGatherFile 
			this.infoNodeCA._FinalGatherFreeze = _renderer.FinalGatherFreeze 
			this.infoNodeCA._FGInterpolateNFrames = _renderer.FGInterpolateNFrames 
			this.infoNodeCA._FinalGatherFilename = _renderer.FinalGatherFilename 
			this.infoNodeCA._FinalGatherTempFilename = _renderer.FinalGatherTempFilename 
				
			this.infoNodeCA._PhotonMapUseFile = _renderer.PhotonMapUseFile 
			this.infoNodeCA._PhotonFreeze = _renderer.PhotonFreeze 
			this.infoNodeCA._PhotonMapFilename = _renderer.PhotonMapFilename 
			this.infoNodeCA._FinalGatherOnly = _renderer.FinalGatherOnly 
			this.infoNodeCA._PhotonsOnly = _renderer.PhotonsOnly
		),
		
		------------------------------------------------
		--@fn: undefined | construct | Rellena la información del override y crea el objeto fisico en la escena que contendrá la información.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la información la coge de el.
			if isValidNode this.infoNode then
			(	
				--Si se esta construyendo el objeto no tendra el CA aplicado, con lo cual hay que ponerselo. Si ya lo tiene no.
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideMentalReuseFGInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalReuseFGInfo]

					this.storeSceneValues()
				)

				this.infoNodeCA = this.infoNode.custAttributes[#overrideMentalReuseFGInfo]

				--primero mira si hay cambios en la escena que afecten al override y lo limpia
				this.purge()
			)--if				
		),
		
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la representacion del contenido del override.
		------------------------------------------------
		fn toString =
		(	
			--primero mira si hay cambios en la escena que afecten al override y lo limpia
			this.purge()
			
			_theString = ""
				
			--TO DO: Aqui falta todo el codigo del toString
			
			_theString
		),
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
			
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
		--@event | create | Ejecución al crearse la instancia del struct.
		on create do
		(
			this.construct() --genera toda la información necesaria y el nodo de la escena donde almacenarla en paralelo, o lee el ya existente en la escena.
		)
		
	)--str_overrideGBuffer
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideMentalReuseFG --añade el override al listado de overrides disponibles
	
	ok
)