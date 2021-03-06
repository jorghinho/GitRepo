------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de Camera
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideCameraInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideCameraInfo = attributes overrideCameraInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de Camera."
				
			--informacion espec�fica del override
			type		type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType		type:#string	default:"camera"	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------
			--parametros de backup
				
			viewportType type:#string default:"view_persp_user" --@var | viewportType | Tipo de viewport que estaba puesto.
			viewportCam type:#node --@var | viewportCam | Camara que estaba puesta en el viewport.
			------------------------------------------------	
			
			------------------------------------------------
			--parametros comunes de backup y apply	
			
			------------------------------------------------	
				
			------------------------------------------------
			--parametros de apply
				
			cameraNode	type:#node	--@var | cameraNode | Camara para el render.
			cameraName	type:#string default:"" --@var | cameraName | Nombre de la camara para el render.
				
			useRcamera	type:#boolean default:false --@var | useRcamera | Indica si usar la camara R equivalente a la elegida para el render.
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | UI para modificar los parametros del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Camera Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento.
		local editCA = undefined --@var : editCA | CA de edicion temporal del override.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		--patrones de nombres de camaras que cumplen el NC
		local cameraPattern = "cam_???" --@var | cameraPattern | Patron de camaras L
		local cameraRpattern = "cam_???-R" --@var | cameraRpattern | Patron de camaras R
		
		local sceneCameras = #() --@var | sceneCameras | Camaras actuales de la escena.
		local sceneCamerasNames = #() --@var | sceneCamerasNames | Nombres de las camaras actuales de la escena.
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		label lblCamera "Camera:" pos:[7,5]
		dropdownlist ddlCamera pos:[50,3] width:150 --@control: ddlCamera | Listado de camaras.
		checkbox chkRcamera "Use R (Right eye) camera" pos:[205,5] checked:false --@control | chkRcamera | Para que en render se use la camara R.
		
		button btnOk "OK" pos:[5,30] width:195 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[200,30] width:195 --@control | btnCancel | Cancela los cambios y cierra.
		
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
			--recopila las camaras que cumplen el NC, luego las normales y descarta las camaras R
			
			_sceneCameras = for _c in cameras where superClassOf _c == camera collect _c
			sceneCameras = for _c in _sceneCameras where MatchPattern _c.name pattern:cameraPattern collect _c
			sceneCameras = lb.misc.sortNodesByName sceneCameras --las ordena por nombre
			
			_nonNCcameras = for _c in _sceneCameras where not (MatchPattern _c.name pattern:cameraPattern) and not (MatchPattern _c.name pattern:cameraRpattern) collect _c
			
			sceneCameras += lb.misc.sortNodesByName _nonNCcameras --las ordena por nombre
			sceneCamerasNames = for _c in sceneCameras collect _c.name --recopila los nombres 
			------------------------------------------------
			
			------------------------------------------------
			--si todavia no se ha asignado ninguna camara

			if not isValidNode (editCA.cameraNode) and editCA.cameraName == "" and sceneCameras.count != 0 then
			(
				editCA.cameraNode = sceneCameras[1]
				editCA.cameraName = sceneCameras[1].name
			)--if
			------------------------------------------------

			------------------------------------------------
			--si la camara que tenia almacenada ya no existe o ha cambiado de nombre actualiza el valor del CA
			
			--si la camara no existe pero hay otra que se llama igual usa esa
			if not isValidNode (editCA.cameraNode) and editCA.cameraName != "" then
			(
				_index = findItem sceneCamerasNames editCA.cameraName
				if _index != 0 then editCA.cameraNode = sceneCameras[_index]
			)
			
			--si la camara ha cambiado de nombre
			if isValidNode (editCA.cameraNode) and
			editCA.cameraName != editCA.cameraNode.name then
			(
				editCA.cameraName = editCA.cameraNode.name
			)
			------------------------------------------------
			
			--rellena el listado
			ddlCamera.items = sceneCamerasNames
				
			--selecciona la camara del override en el listado
			_index = findItem sceneCamerasNames editCA.cameraName
			if _index != 0 then ddlCamera.selection = _index			
			
			--recupera el estado del uso de camara R
			chkRcamera.checked = editCA.useRcamera
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			--TO DO
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuraci�n de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--no carga settings
		)
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuraci�n de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--no guarda settings
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar la seleccion del listado.
		--@control: dropdownlist | ddlCamera | Dropdownlist que cambia de estado.
		--@gets: integer | index | Nuevo indice seleccionado.
		------------------------------------------------
		on ddlCamera selected index do
		(
			_selCameraName = ddlCamera.items[index]
			if _selCameraName != editCA.cameraName then
			(
				_index = findItem sceneCamerasNames _selCameraName
				if _index != 0 then
				(
					editCA.cameraName = _selCameraName
					editCA.cameraNode = sceneCameras[_index]

					--si se cambia de camara y esta activada la opcion de camara R y esta no existe se ha dedesactivar la opcion
					if chkRcamera.checked then
					(
						_rCameraCandidate = undefined
						_rCameraCandidateName = editCA.cameraName + "_R"
						for _c in cameras where superClassOf _c == camera and _c.name == _rCameraCandidateName do _rCameraCandidate = _c
							
						if not isValidNode _rCameraCandidate then chkRcamera.checked = false
					)
				)				
			)
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del check.
		--@control: checkbox | chkRcamera | Check que cambia de estado.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkRcamera changed state do
		(
			--solo deja activar si la camara R existe
			if state then
			(
				_rCameraCandidate = undefined
				_rCameraCandidateName = editCA.cameraName + "_R"
				for _c in cameras where superClassOf _c == camera and _c.name == _rCameraCandidateName do _rCameraCandidate = _c
				
				if isValidNode _rCameraCandidate then
				(
					editCA.useRcamera = state
				)--if
				else
					chkRcamera.checked = false --si no existe la camara no deja activar el modo
			)
			else --siempre deja desactivarlo
			(
				editCA.useRcamera = state
			)--if else			
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
		--@event: pressed | Evento que se lanza al presionar el boton. Cambia los cambios.
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
		--@control: rollout | rollMainDef | El elemento que sufre la redimensi�n. El rollout principal de la herramienta.
		--@gets: point2 | size | tama�o al que se ha redimensionado el rollout
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
			editCA = parent.editBackupNode.custAttributes[#overrideCameraInfo]
			
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
	--@struct: overrideCamera | Contiene todas las funciones de un override de Camera.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideCamera
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
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la informaci�n del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		
		infoNodeCA,		--@var | infoNodeCA | CA del override de donde obtener y donde salvar la informacion.
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma r�pida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override espec�fico.
		
		overrideInfo = ca_overrideCameraInfo,	--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		--overrideBackup = ca_overrideCameraBackup,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
		--patrones de nombres de camaras que cumplen el NC
		cameraPattern = "cam_???", --@var | cameraPattern | Patron de camaras L.
		cameraRpattern = "cam_???-R", --@var | cameraRpattern | Patron de camaras R.
		
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
		--@fn: node | getInfoNode | Devuelve el nodo f�sico de la escena que contiene la informaci�n del override.
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
			
			if isValidNode this.infoNodeCA.cameraNode then _info += this.infoNodeCA.cameraNode.name
			else if this.infoNodeCA.cameraName != "" then _info += this.infoNodeCA.cameraName
			else _info = "not defined"
			
			if this.infoNodeCA.useRcamera then _info += ", R Camera Mode"
			
			_info
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok
			
			if not isValidNode this.infoNodeCA.cameraNode then
			(
				if this.infoNodeCA.cameraName != "" then
				(
					if cameras.count != 0 then
					(
						_theCamera = undefined
						for _cam in cameras where this.infoNodeCA.cameraName == _cam.name do _theCamera = _cam
						
						if not isValidNode _theCamera then
						(
							_state = #error
							this.stateMessage = "Camera not found in scene"
						)
					)
					else
					(
						_state = #error
						this.stateMessage = "There are no cameras in scene"
					)--if  else
				)
				else
				(
					_state = #error
					this.stateMessage = "There is not selected camera"
				)--if else
			)--if
			
			_state
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
			
			if saveLogs then lb.log.add ("BACKUP process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				_backupCA = backupNode.custAttributes[#overrideCameraInfo]
				
				--si el nodo de backup no tiene el CA de backup se lo pone
				if _backupCA == undefined then
				(
					custAttributes.add backupNode (this.overrideInfo) #unique baseobject:false --le a�ade el atributo
					_backupCA = backupNode.custAttributes[#overrideCameraInfo]
				)
				
				_backupCA.viewportType = (viewport.getType() as string)
				_backupCA.viewportCam = viewport.getcamera()
				
				_success = true
			)--if
			else
			(
				_success = false
				if saveLogs then lb.log.add ("BACKUP process error. BackupNode is not valid.") sender:("override." + (this.getSubType())) type:#error
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node is not valid.")
			)
			
			if savelogs then
			(
				if _success then
					lb.log.add ("BACKUP process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else
					lb.log.add ("BACKUP process failed") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			if not _success then this.updateUIinfo() --si da error actualiza el UI
			
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
				_backupCA = backupNode.custAttributes[#overrideCameraInfo]
				
				if _backupCA != undefined then
				(
					if isValidNode (_backupCA.viewportCam) then
						viewport.setCamera (_backupCA.viewportCam)
					else	
						viewport.setType (_backupCA.viewportType as name)
					
					_success = true
				)--if
			)--if
			else
			(
				_success = false
				lb.log.add ("RESTORE process error. BackupNode is not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not valid.")					
			)

			if savelogs then
			(
				if _success then
					lb.log.add ("RESTORE process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else
					lb.log.add ("RESTORE process failed") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)

			if not _success then this.updateUIinfo() --si da error actualiza el UI

			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes. Defuelve TRUE si tiene exito y FALSE si no
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
				
			_success = false
			
			--si no hay camara o no es valida pero hay un nombre valido de camara que existe en la escena, usa esa.
			if not isValidNode (this.infoNodeCA.cameraNode) and (this.infoNodeCA.cameraName != "") then
			(
				------------------------------------------------
				--recopila las camaras que cumplen el NC, luego las normales y descarta las camaras R
				_sceneCameras = for _c in cameras where superClassOf _c == camera collect _c
				_defSceneCameras = for _c in _sceneCameras where MatchPattern _c.name pattern:this.cameraPattern collect _c
				_defSceneCameras = lb.misc.sortNodesByName _sceneCameras --las ordena por nombre
				
				_nonNCcameras = for _c in _sceneCameras where not (MatchPattern _c.name pattern:this.cameraPattern) and not (MatchPattern _c.name pattern:this.cameraRpattern) collect _c
				
				_defSceneCameras += lb.misc.sortNodesByName _nonNCcameras --las ordena por nombre
				_defSceneCamerasNames = for _c in _defSceneCameras collect _c.name --recopila los nombres 
				------------------------------------------------
				
				_index = findItem _defSceneCamerasNames (this.infoNodeCA.cameraName)
				if _index != 0 then this.infoNodeCA.cameraNode = _defSceneCameras[_index]
				
				if saveLogs then lb.log.add ("APPLY: Specified camera not found, searching by valid name.") sender:("override." + (this.getSubType())) type:#warning level:logLevel
			)
			
			
			if isValidNode (this.infoNodeCA.cameraNode) then
			(
				_camToUse = this.infoNodeCA.cameraNode
				
				--si tiene que aplicar la camara R
				if this.infoNodeCA.useRcamera then
				(
					_rCameraCandidate = undefined
					_rCameraCandidateName = this.infoNodeCA.cameraName + "_R"
					for _c in cameras where superClassOf _c == camera and _c.name == _rCameraCandidateName do _rCameraCandidate = _c

					if isValidNode _rCameraCandidate then --si encuentra la camara R
					(
						if saveLogs then lb.log.add ("APPLY: cameraR found.") sender:("override." + (this.getSubType())) type:#info level:(logLevel+1)
						viewport.setCamera _rCameraCandidate --aplica la camara
						
						--path actual de render
						_currentPath = getFileNamePath rendOutputFilename
						
						--sustituye el path por el de la camara R
						if _currentPath != "" then --si hay path de salida
						(
							if matchPattern _currentPath pattern:@"*\frame\*" then --si es un path de produccion
								rendOutputFilename = (substituteString _currentPath @"\frame\" @"\frameR\") + (getFilenameFile rendOutputFilename) + (getFilenameType rendOutputFilename)
							else --si es un path normal
								rendOutputFilename = _currentPath + "\\" + (getFilenameFile rendOutputFilename) + (getFilenameType rendOutputFilename)
								--anteriormente estaba asi: rendOutputFilename = _currentPath + "\\R\\" + (getFilenameFile rendOutputFilename) + (getFilenameType rendOutputFilename)
								--y ahora funciona 
						)--if
						
						_success = true

						--si el path en el que se va a hacer render no existe no se continua
						if not doesFileExist (getFileNamePath rendOutputFileName) then _success = false		
					
					)--if
				)
				else --si tiene que aplicar la camara L
				(
					if saveLogs then lb.log.add ("APPLY: cameraL found.") sender:("override." + (this.getSubType())) type:#info level:(logLevel+1)
					viewport.setCamera _camToUse
					_success = true
				)--if else
				
				if (_success) then
				(
					if saveLogs then lb.log.add ("APPLY process ok.") sender:("override." + (this.getSubType())) type:#ok level:(logLevel)
				)
				else
				(
					if saveLogs then lb.log.add ("APPLY process error.") sender:("override." + (this.getSubType())) type:#error level:(logLevel)
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("APPLY process error. Camera node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			if not _success then this.updateUIinfo() --si da error actualiza el UI
	
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
				_backupCA = this.editBackupNode.custAttributes[#overrideCameraInfo]
				
				--le quita el CA del override si lo tuviera
				if _backupCA != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames this.infoNodeCA
						for _prop in _propNames do (setProperty this.infoNodeCA _prop (getProperty _backupCA _prop))
					)--undo
					
					this.editBackupNode = undefined --hace que el override no tenga backup de edicion almacenado
					
					this.updateUIinfo() --actualiza la infirmacion en el UI si ha cambiado
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello.		
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
						_backupCA = this.editBackupNode.custAttributes[#overrideCameraInfo]
						
						--le quita el CA del override si lo tuviera
						if _backupCA != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef _backupCA) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le a�ade el atributo nuevo
						_backupCA = this.editBackupNode.custAttributes[#overrideCameraInfo]
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty _backupCA _prop (getProperty this.infoNodeCA _prop))
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
			
			_size = [400,55]
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
			--recopila las camaras que cumplen el NC, luego las normales y descarta las camaras R
			_sceneCameras = for _c in cameras where superClassOf _c == camera collect _c
			_defSceneCameras = for _c in _sceneCameras where MatchPattern _c.name pattern:this.cameraPattern collect _c
			_defSceneCameras = lb.misc.sortNodesByName _defSceneCameras --las ordena por nombre
			
			_nonNCcameras = for _c in _sceneCameras where not (MatchPattern _c.name pattern:this.cameraPattern) and not (MatchPattern _c.name pattern:this.cameraRPattern) collect _c
			
			_defSceneCameras += (lb.misc.sortNodesByName _nonNCcameras) --las ordena por nombre
			
			--almacena la primera camara del listado
			if _defSceneCameras.count != 0 then
			(
				this.infoNodeCA.cameraNode = _defSceneCameras[1]
				this.infoNodeCA.cameraName = _defSceneCameras[1].name
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | construct | Rellena la informaci�n del override y crea el objeto fisico en la escena que contendr� la informaci�n.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la informaci�n la coge de el.
			if isValidNode this.infoNode then
			(	
				--almacena el CA con la informacion en una varaible interna
				this.infoNodeCA = this.infoNode.custAttributes[#overrideCameraInfo]
					
				--Si se esta construyendo el objeto no tendra el CA aplicado, con lo cual hay que ponerselo. Si ya lo tiene no.
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideCameraInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le a�ade el atributo
					
					--almacena el CA con la informacion en una varaible interna
					this.infoNodeCA = this.infoNode.custAttributes[#overrideCameraInfo]			
					
					this.storeSceneValues()
				)--if
				
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
		--@event | create | Ejecuci�n al crearse la instancia del struct.
		on create do
		(
			this.construct() --genera toda la informaci�n necesaria y el nodo de la escena donde almacenarla en paralelo, o lee el ya existente en la escena.
		)
		
	)--str_overrideCamera
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideCamera --a�ade el override al listado de overrides disponibles
	
	ok
)