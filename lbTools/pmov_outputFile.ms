------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de OutputPath
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideOutputFileInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideOutputFileInfo = attributes overrideOutputFileInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de OutputFile."
				
			--informacion específica del override
			type		type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType		type:#string	default:"outputFile"	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			-----------------------------------------------------------
			-- Parámetros de backup
			
			-----------------------------------------------------------
			-- Parámetros de backup y apply
			------------------------------------------------
			--informacion sobre el contenido almacenado en el override
			outputFile	type:#string	default:"" --@var | outputFile | Path de salida del render.	
			------------------------------------------------
			
			-----------------------------------------------------------
			-- Parámetros de apply
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | UI para modificar los parametros del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "OutputFile Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var : editCA | Parámetro de override
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--button btnPath "..." pos:[5,5] width:15 height:15--@control | btnPath | Para elegir el path de salida.
		label lblInfo	"Pattern '[pass]' will be replaced with each pass name in render time." pos:[5,5] --@control | lblInfo | Información de palabras reservadas en el nombre de salida de render.
		edittext edtFile "" pos:[2,25] width:495 border:true --@control | edtFile | Path de salida para el render.
		
		button btnOk "OK" pos:[5,45] width:245 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[250,45] width:245 --@control | btnCancel | Cancela los cambios y cierra.
		
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
			edtFile.text = editCA.outputFile
			if edtFile.text == "" then
			(
				if(getFilenameFile rendOutputFileName) == "" then
				(
					if (getFilenameFile maxFilename == "") then
						edtFile.text = "frame_name"
					else
						edtFile.text = (getFilenameFile maxFilename)
				)
				else
					edtFile.text = (filenameFile rendOutputFileName)
			)
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
		
		on edtFile changed newText do
		(
			_forbiddenChars = #("\\", " ", "/", ":","*","?","|")
			for i=1 to _forbiddenChars.count do
			(
				if (findString newText _forbiddenChars[i]) != undefined then
				(
					edtFile.text = substituteString newText _forbiddenChars[i] "" --Eliminamos el caracter no valido
					messageBox "Los espacios y los siguientes caracteres no están permitidos: \\ / : * ? |" title:"Caracter incorrecto"
				)
			)
			
			
			editCA.outputFile = edtFile.text
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			--Si se han olvidado el _[pass]_ se lo añadiremos al final.
			if (findString editCA.outputFile "[pass]") == undefined then
			(
				lb.message.show "There is no \"[pass]\" token on file name, will be added at the end of it." type:#message pos:undefined size:[300,75] modal:true
				editCA.outputFile += "_[pass]_"
			)
			if lb.passmanagerui.mode != #idi then
			(
				_m = lb.re.matchObj maxfilepath lb.nc.NC_seqRenderPathRegExp
				if _m.success then
				(
					--Si podemos obtener los datos de la ruta de la escena exigimos que tenga el nombre correcto
					_replaces = dotNetObject "System.Collections.Hashtable"
					for _group in #("unit", "group", "seqnum", "seqlet", "seqdesc", "camnum") do
					(
						_replaces.add _group ((_m.Groups.Item(_group)).value)
					)
					_suggested = (lb.re.replaceGroupsInPattern (lb.nc.NC_PMoutputFileRegExp) _replaces)
					if toLower editCA.outputFile != toLower _suggested then
					(
						if queryBox ("Chosen file name doesn't match name convention.\nSuggested: " + _suggested + "\nApply it?") do
							editCA.outputFile = _suggested
					)
					if toLower editCA.outputFile == toLower _suggested do
					(
						parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
						destroyDialog parent.rollMain
					)
				)
				else
				(
					--Si no podemos obtener los datos del path de la escena exigimos que siga el patrón
					if (matchpattern editCA.outputFile pattern:lb.nc.NC_PMoutputFilePattern) or (matchpattern editCA.outputFile pattern:lb.nc.NC_PMoutputFilePatternPromo) then
					(
						parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
						destroyDialog parent.rollMain
					)
					else
					(
						messageBox "Chosen file name doesn't match name convention."
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
			editCA = parent.editBackupNode.custAttributes[#overrideOutputFileInfo]
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
	--@struct: overrideOutputFile | Contiene todas las funciones de un override de OutputFile.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideOutputFile
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
		infoNodeCA,							--@var | infoNodeCA | Variable de atajo para el CA de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideOutputFileInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideOutputFileInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			this.infoNodeCA.outputFile
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
		--@fn: undefined | createBackup | Crea el backup de este override antes de aplicarse
		--@gets: node | backupNode | Objeto en el que hacer el backup.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1=
		(
			if saveLogs then lb.log.add ("BACKUP process started.") sender: ("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideOutputFileInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				backupNode.custAttributes[#overrideOutputFileInfo].outputFile = (lb.io.getFileName rendOutputFileName)
				
				--print ("file backup: " + backupNode.custAttributes[#overrideOutputFileInfo].outputFile)
				
				if saveLogs then lb.log.add ("BACKUP process completed.") sender: ("override." + (this.getSubType())) type:#ok level:logLevel
				true
			)--if
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup Node not valid.") sender: ("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup Node not valid.")
				false
			)
		),
		
		------------------------------------------------
		--@fn: undefined | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("RESTORE process started.") sender: ("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(	
				if backupNode.custAttributes[#overrideOutputFileInfo] != undefined then
				(
					if backupNode.custAttributes[#overrideOutputFileInfo].outputFile != "" then
					(
						rendOutputFileName = (getFilenamePath rendOutputFileName) + "\\" + backupNode.custAttributes[#overrideOutputFileInfo].outputFile + (lb.io.getFileType rendOutputFileName)
					)
					else rendOutputFileName = ""

					--print ("file restore: " + rendOutputFileName)

					if saveLogs then lb.log.add ("RESTORE process completed.") sender: ("override." + (this.getSubType())) type:#ok level:logLevel
					true
				)
				else
				(
					if saveLogs then lb.log.add ("RESTORE process error. CA #overrideOutputFileInfo is undefined.") sender: ("override." + (this.getSubType())) type:#error level:logLevel
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Custom Attribute is undefined.")
					false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("RESTORE process error. Backup Node not valid.") sender: ("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup Node not valid.")
				false
			)
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false loglevel:1 =
		(
			if saveLogs then lb.log.add ("APPLY process started.") sender: ("override." + (this.getSubType())) type:#info level:logLevel

			if this.infoNodeCA.outputFile != "" then
			(
				rendOutputFileName =  (getFilenamePath rendOutputFileName) + "\\" + (this.infoNodeCA.outputFile) + (lb.io.getFileType rendOutputFileName)
			)
			else rendOutputFileName = ""

			--print ("file apply: " + rendOutputFileName)
			
			if saveLogs then lb.log.add ("APPLY process completed.") sender: ("override." + (this.getSubType())) type:#ok level:logLevel
			true
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
				if this.editBackupNode.custAttributes[#overrideOutputFileInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideOutputFileInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideOutputFileInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideOutputFileInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideOutputFileInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [500,70]
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
			--intenta generar el nombre del fichero de salida a partir de la ruta de entrada
			_m = lb.re.matchObj maxfilepath lb.nc.NC_seqRenderPathRegExp
			if _m.success then
			(
				_replaces = dotNetObject "System.Collections.Hashtable"
				for _group in #("seqnum", "seqlet", "seqdesc", "camnum") do
				(
					_replaces.add _group ((_m.Groups.Item(_group)).value)
				)
				this.infoNodeCA.outputFile = lb.re.replaceGroupsInPattern (lb.nc.NC_PMoutputFileRegExp) _replaces
			)
			else
			(
				--almacena los valores actuales de tamaño de render de la escena
				if(rendOutputFileName == "") then
				(
					if maxFilename == "" then this.infoNodeCA.outputFile = "frameName"
					else this.infoNodeCA.outputFile = getFilenameFile maxFileName
				)
				else this.infoNodeCA.outputFile = (getFilenameFile rendOutputFileName)
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideOutputFileInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideOutputFileInfo]

					this.storeSceneValues()
				)--if			
				
				--Rellenamos la variable de atajo
				this.infoNodeCA = this.infoNode.custAttributes[#overrideOutputFileInfo]
				
				this.purge() --primero mira si hay cambios en la escena que afecten al override y lo limpia
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
		
	)--str_overrideOutputFile
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideOutputFile --añade el override al listado de overrides disponibles
	
	ok
)