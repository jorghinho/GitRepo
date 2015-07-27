------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de OutputPath
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideOutputPathInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideOutputPathInfo = attributes overrideOutputPathInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.2
			CA_description	type:#string	default:"Almacena la informacion de un override de OutputPath."
				
			--informacion específica del override
			type		type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType		type:#string	default:"outputPath"	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			-------------------------------------------------------------
			-- Parámetros de backup
			
			-------------------------------------------------------------
			-- Parámetros de backup y apply
			------------------------------------------------
			--informacion sobre el contenido almacenado en el override
			outputPath	type:#string	default:"" --@var | outputPath | Path de salida del render.	
			------------------------------------------------
			
			-------------------------------------------------------------
			-- Parámetros de apply
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | UI para modificar los parametros del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "OutputPath Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		local editCA = undefined --@var: editCA | Variable de atajo para el CA de edición
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local iconpath = if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/"		-- ruta de los iconos de Max.

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		edittext edtPath "" pos:[2,5] width:450 --@control | edtPath | Path de salida para el render.
		button btnPath "..." pos:[456,5] width:17 height:17--@control | btnPath | Para elegir el path de salida.
		button btnOpen "Open" pos:[478,5] width:17 height:17 images:#(iconpath + "bip_copycol_i.bmp", undefined, 16, 3, 3, 4, 4, true)--@control | btnOpen | Para abrir el directorio en el explorador.
		--label lblPath "" pos:[25,5] width:500 border:true --@control | lblPath | Path de salida para el render.
		
		button btnOk "OK" pos:[5,25] width:245 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[250,25] width:245 --@control | btnCancel | Cancela los cambios y cierra.
		
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
			edtPath.text = editCA.outputPath
			if edtPath.text == "" then edtPath.text = "<not defined>"
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			--TO DO
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--no carga settings
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
		--@event: pressed | Evento que se lanza al presionar el boton. Cambia el path.
		--@control: button | btnPath | Boton presionado.
		------------------------------------------------
		on btnPath pressed do
		(
			--abre el cuadro de dialogo de eleccion de ruta en la actual
			_newPath = getSavePath initialDir:(editCA.outputPath)
			
			--si se ha elegido un nuevo path y no es igual que el actual
			if _newPath != undefined and _newPath != (editCA.outputPath) then
			(
				if _newPath[_newPath.count] != "\\" then _newPath[_newPath.count] += "\\"
				editCA.outputPath = _newPath
				edtPath.text = _newPath
			)--if
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Abre el path en el explorador
		--@control: button | btnPath | Boton presionado.
		------------------------------------------------
		on btnOpen pressed do
		(
			HiddenDOSCommand ("explorer \"" + edtPath.text + "\"") --no compruebo si existe porque ya se hace antes
		)
		
		------------------------------------------------
		--@event: entered | Evento que se lanza al presionar el enter o tab.
		--@control: edittext | edtPath | control que cambia su valor.
		--@gets: string | newText | nuevo texto.
		------------------------------------------------
		on edtPath entered newText do
		(
			if doesFileExist newText then
			(
				editCA.outputPath = newText
			)
			else
			(
				messageBox "Chosen path doesn't exist. Previous path will be restored."
				edtPath.text = editCA.outputPath
				if edtPath.text == "" then edtPath.text = "<not defined>"
			)
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			if lb.passmanagerui.mode != #idi then
			(
				_m = lb.re.matchObj maxfilepath lb.nc.NC_seqRenderPathRegExp
				if _m.success then
				(
					--Si podemos obtener los datos de la ruta de la escena exigimos que tenga el path correcto
					_replaces = dotNetObject "System.Collections.Hashtable"
					for _group in #("unit", "group", "seqnum", "seqlet", "seqdesc", "camnum") do
					(
						_replaces.add _group ((_m.Groups.Item(_group)).value)
					)
					_suggested = (lb.re.replaceGroupsInPattern (lb.nc.NC_PMoutputPathRegExp) _replaces)
					if toLower editCA.outputPath != toLower _suggested then
					(
						if queryBox ("Chosen path doesn't match name convention.\nSuggested: " + _suggested + "\nApply it?") do
							editCA.outputPath = _suggested
					)
					if toLower editCA.outputPath == toLower _suggested do
					(
						parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
						destroyDialog parent.rollMain
					)

				)
				else
				(
					--Si no podemos obtener los datos del path de la escena exigimos que siga el patrón
					if (matchpattern (toLower editCA.outputPath) pattern:lb.nc.NC_PMoutputPathPattern) or (matchpattern (toLower editCA.outputPath) pattern:lb.nc.NC_PMoutputPathPatternPromo) then
					(
						parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
						destroyDialog parent.rollMain
					)
					else
					(
						messageBox "Chosen path doesn't match name convention."
					)
				)
			)
			else
			(
				parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
				destroyDialog parent.rollMain
			)
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
			editCA = parent.editBackupNode.custAttributes[#overrideOutputPathInfo]
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
	--@struct: overrideOutputPath | Contiene todas las funciones de un override de OutputPath.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideOutputPath
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
		infoNodeCA,						--@var | infoNodeCA | Variable de atajo para el CA de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideOutputPathInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideOutputPathInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			this.infoNodeCA.outputPath
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok
			
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
			if saveLogs then lb.log.add ("BACKUP process started.") sender: ("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideOutputPathInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				if rendOutputFileName != "" then backupNode.custAttributes[#overrideOutputPathInfo].outputPath = getFileNamePath rendOutputFileName
				else backupNode.custAttributes[#overrideOutputPathInfo].outputPath = ""
				
				--print ("backup path: " + backupNode.custAttributes[#overrideOutputPathInfo].outputPath)
				
				if saveLogs then lb.log.add ("BACKUP process completed.") sender: ("override." + (this.getSubType())) type:#ok level:logLevel
				true
			)--if
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup Node not valid.") sender: ("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D" + "BACKUP process error. Backup Node not valid.")
				false
			)
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("RESTORE process started.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(	
				if (backupNode.custAttributes[#overrideOutputPathInfo] != undefined) then
				(
					if (backupNode.custAttributes[#overrideOutputPathInfo].outputPath) != "" then
						rendOutputFileName = substituteString rendOutputFileName (getFileNamePath rendOutputFileName) (backupNode.custAttributes[#overrideOutputPathInfo].outputPath)
					else
						rendOutputFileName = ""

					--print ("restore path: " + rendOutputFileName)
					 
					if saveLogs then lb.log.add ("RESTORE process completed.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
					true
				)
				else
				(
					if saveLogs then lb.log.add ("RESTORE process error. CA #overrideOuputPathInfo does not exist.") sender:("override." + (this.getSubType())) type:#error level:logLevel
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. CA #overrideOuputPathInfo does not exist.")
					false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("RESTORE process error. Backup Node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup Node not valid.")
				false
			)
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("APPLY process completed.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			_success = true

			if (this.infoNodeCA.outputPath) != "" then
			(
				--si no tiene le añade una barra al final
				if this.infoNodeCA.outputPath[this.infoNodeCA.outputPath.count] != "\\" then (this.infoNodeCA.outputPath = this.infoNodeCA.outputPath + "\\")

				if (getFileNamePath rendOutputFileName) != "" then rendOutputFileName = substituteString rendOutputFileName (getFileNamePath rendOutputFileName) (this.infoNodeCA.outputPath)
				else rendOutputFileName = (this.infoNodeCA.outputPath) + "\\" + rendOutputFileName

				--print ("apply path: " + rendOutputFileName)
			)
			else
				rendOutputFileName = ""
			
			_path = (getFileNamePath rendOutputFileName)
			--si el path en el que se va a hacer render no existe y no es un previo, se intenta crear
			if not doesFileExist _path and (not lb.passManager.getPreviewRenderMode()) then 
			(
				makeDir _path
			)
			--si no se ha conseguido crear, no se continúa
			if not doesFileExist _path and (not lb.passManager.getPreviewRenderMode()) then 
			(
				if saveLogs then lb.log.add ("APPLY process error. Output path doesn't exist." + _path) sender:("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"APPLY process error. Output path doesn't exist." + _path)
				_success = false
			)
			else
			(
				if saveLogs then lb.log.add ("APPLY process completed.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
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
				if this.editBackupNode.custAttributes[#overrideOutputPathInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideOutputPathInfo]) _prop))
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
						--le quita el CA del override si lo tuviera
						if this.editBackupNode.custAttributes[#overrideOutputPathInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideOutputPathInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideOutputPathInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [500,50]
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
			_m = lb.re.matchObj maxfilepath lb.nc.NC_seqRenderPathRegExp
			if _m.success then
			(
				_replaces = dotNetObject "System.Collections.Hashtable"
				for _group in #("unit", "group", "seqnum", "seqlet", "seqdesc", "camnum") do
				(
					_replaces.add _group ((_m.Groups.Item(_group)).value)
				)
				this.infoNodeCA.outputPath = lb.re.replaceGroupsInPattern (lb.nc.NC_PMoutputPathRegExp) _replaces
			)
			else
			(
				this.infoNodeCA.outputPath = getFileNamePath rendOutputFileName
			)
		),

		------------------------------------------------
		--@fn: undefined | upgrade | Actualiza la version del override
		--@opt: float | previousVersion | Versión en la que se encontraba previamente
		------------------------------------------------
		fn upgrade previousVersion:0.0 =
		(
			if previousVersion < 1.2 do
			(
				this.infoNodeCA.outputPath = toLower this.infoNodeCA.outputPath
				this.infoNodeCA.outputPath = substituteString this.infoNodeCA.outputPath "lbbackup2" "lbdata002"
				this.infoNodeCA.outputPath = substituteString this.infoNodeCA.outputPath "lbbackup" "lbdata001"
			)
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideOutputPathInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideOutputPathInfo]

					this.storeSceneValues()									
				)--if

				--Rellenamos la variable de atajo del CATBone
				this.infoNodeCA = this.infoNode.custAttributes[#overrideOutputPathInfo]
				
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
		
	)--str_overrideOutputPath
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideOutputPath --añade el override al listado de overrides disponibles
	
	ok
)