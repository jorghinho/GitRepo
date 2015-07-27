------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de OutputSize
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideOutputSizeInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideOutputSizeInfo = attributes overrideOutputSizeInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:2.0
			CA_description	type:#string	default:"Almacena la informacion de un override de OutputSize."
				
			--informacion específica del override
			type		type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType		type:#string	default:"outputSize"	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			----------------------------------------------------------------
			-- Parámetros de backup
			
			----------------------------------------------------------------
			-- Parámetros de backup y apply
			------------------------------------------------
			--informacion sobre el contenido almacenado en el override
			width	type:#integer	default:640 --@var | width | Ancho de render.
			height	type:#integer	default:480 --@var | height | Height de render.
			pixelAspect	type:#float	default:1.0 --@var | pixelAspect | Proporción del pixel
			apertureWidth	type:#float	default:36.0 --@var | height | Apertura en milimetros
			presetName type:#string default:"Custom"
			------------------------------------------------
			
			----------------------------------------------------------------
			-- Parámetros de apply
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | UI para modificar los parametros del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "OutputSize Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var : editCA| Variable de atajo para el CA de edit
		
		local presetList = #()
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		struct preset (caption="",apertureWidth=0.0, preset01=[1,1], preset02=[1,1], preset03=[1,1], preset04=[1,1], pixelAspect=1.0)
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--checkbox chkRenderable "Renderable" pos:[5,5] checked:true --@control | chkRenderable | Para que los objetos sean renderizables o no.
		
		groupbox grpOutputSize "Output Size" pos:[5,0] width:305 height:140
		dropdownList ddlOutputs pos:[10,15] width:125
		label lblApertureWidth "Aperture Width(mm):" pos:[145,18]
		spinner spnApertureWidth "" pos:[250,18] width:55 range:[0.001,1000000.0,36.0] scale:0.01 type:#float --@control | spnApertureWidth | Ancho de apertura.
		
		label lblWidth "Width:" pos:[11,45]
		spinner spnWidth "" pos:[80,43] width:55 range:[1,1000000,640] type:#integer --@control | spnWidth | Ancho de render.
		label lblHeight "Height:" pos:[11,65]
		spinner spnHeight "" pos:[80,63] width:55 range:[1,1000000,480] type:#integer --@control | spnHeight | Ancho de render.
		
		button btnPreset01 "" pos:[155,43] width:72 height:17 --@control | btnPreset01 | Preset de resolución 01
		button btnPreset02 "" pos:[233,43] width:72 height:17 --@control | btnPreset02 | Preset de resolución 02
		button btnPreset03 "" pos:[155,63] width:72 height:17 --@control | btnPreset03 | Preset de resolución 03
		button btnPreset04 "" pos:[233,63] width:72 height:17 --@control | btnPreset04 | Preset de resolución 04
		
		label lblImageAspect "Image Aspect:" pos:[11,90]
		spinner spnImageAspect "" pos:[80,88] width:55 range:[0.001,1000000,0.001] scale:0.01 type:#float --@control | spnImageAspect | Proporción de imagen.
		checkbutton ckbLockImageAspect "x" pos:[135,88] width:16 height:16
		
		label lblPixeAspect "Pixel Aspect:" pos:[170,90]
		spinner spnPixelAspect "" pos:[234,88] width:55 range:[0.001,1000000,0.001] scale:0.01 type:#float --@control | spnPixelAspect | Proporción de pixel.
		checkbutton ckbLockPixelAspect "x" pos:[289,88] width:16 height:16
		
		button btnOk "OK" pos:[10,115] width:145 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[160,115] width:145 --@control | btnCancel | Cancela los cambios y cierra.
		
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
		--@fn: undefined | getCurrentPreset | retorna el preset actual consultando lo seleccionado en el dropdownlist
		------------------------------------------------
		fn getCurrentPreset =
		(
			_preset = undefined
			for p in presetList do
			(
				if p.caption == ddlOutputs.selected then
				(
					_preset = p
					break
				)
			)
			_preset
		)
		
		------------------------------------------------
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			spnWidth.value = editCA.width
			spnHeight.value = editCA.height
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			--TO DO
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | En este caso en vez de cargar settings de un documento, rellena los valores de 
		------------------------------------------------
		fn loadSettings =
		(
			--Custom
			append presetList (preset caption:"Custom" apertureWidth:36.0 preset01:[320,240] preset02:[720,486] preset03:[640,480] preset04:[800,600] pixelAspect:1.0)
			
			--35mm 1.316:1 Full Aperture (cine)
			append presetList (preset caption:"35mm 1.316:1 Full Aperture (cine)" apertureWidth:24.0 preset01:[512,389] preset02:[1536,1167] preset03:[2048,1556] preset04:[4096,3112] pixelAspect:1.0)
			
			--35mm 1.37:1 Academy (cine)
			append presetList (preset caption:"35mm 1.37:1 Academy (cine)" apertureWidth:20.955 preset01:[457,333] preset02:[1371,999] preset03:[1828,1332] preset04:[3656,2664] pixelAspect:1.0 )
			
			--35mm 1.66:1 (cine)
			append presetList (preset caption:"35mm 1.66:1 (cine)" apertureWidth:20.955 preset01:[250,150] preset02:[1024,614] preset03:[1536,921] preset04:[4096,2458] pixelAspect:1.0 )
			
			--35mm 1.75:1 (cine)
			append presetList (preset caption:"35mm 1.75:1 (cine)" apertureWidth:20.955 preset01:[350,200] preset02:[1120,640] preset03:[1575,900] preset04:[4096,2340] pixelAspect:1.0 )
			
			--35mm 1.85:1 (cine)
			append presetList (preset caption:"35mm 1.85:1 (cine)" apertureWidth:20.955 preset01:[370,200] preset02:[1024,554] preset03:[1536,830] preset04:[4096,2214] pixelAspect:1.0 )
			
			--35mm Anamorphic (2.35:1)
			append presetList (preset caption:"35mm Anamorphic (2.35:1)" apertureWidth:42.570 preset01:[256,109] preset02:[1024,436] preset03:[1828,778] preset04:[4096,1743] pixelAspect:1.0 )
				
			--35mm Anamorphic (2.35:1) (Squeezed)
			append presetList (preset caption:"35mm Anamorphic (2.35:1) (Squeezed)" apertureWidth:42.570 preset01:[256,218] preset02:[1024,871] preset03:[1828,1556] preset04:[4096,3486] pixelAspect:2.0 )
			
			--70mm Panavision (cine)
			append presetList (preset caption:"70mm Panavision (cine)" apertureWidth:48.590 preset01:[440,200] preset02:[1024,465] preset03:[1536,698] preset04:[4096,1862] pixelAspect:1.0 )
			
			--70mm IMAX (cine)
			append presetList (preset caption:"70mm IMAX (cine)" apertureWidth:48.590 preset01:[256,188] preset02:[1024,751] preset03:[1536,1126] preset04:[4096,3003] pixelAspect:1.0 )
			
			--VistaVision
			append presetList (preset caption:"VistaVision" apertureWidth:37.719 preset01:[360,240] preset02:[1024,683] preset03:[1536,1024] preset04:[4096,2731] pixelAspect:1.0 )
			
			--35mm (24mm X 36mm) (slide)
			append presetList (preset caption:"35mm (24mm X 36mm) (slide)" apertureWidth:34.200 preset01:[360,240] preset02:[1024,683] preset03:[1536,1024] preset04:[4096,2731] pixelAspect:1.0 )
			
			--6cm X 6cm (2 1/4\" x 2 1/4\") (slide)
			append presetList (preset caption:"6cm X 6cm (2 1/4\" x 2 1/4\") (slide)" apertureWidth:51.600 preset01:[256,256] preset02:[1024,1024] preset03:[1536,1536] preset04:[4096,4096] pixelAspect:1.0 )
			
			--4\" X 5\" or 8\" X 10\" (slide)
			append presetList (preset caption:"4\" X 5\" or 8\" X 10\" (slide)" apertureWidth:88.900 preset01:[512,410] preset02:[1024,819] preset03:[1536,1229] preset04:[4096,3277] pixelAspect:1.0 )
			
			--NTSC D-1 (video)
			append presetList (preset caption:"NTSC D-1 (video)" apertureWidth:20.120 preset01:[720,486] preset02:[200,135] preset03:[360,243] preset04:[512,346] pixelAspect:0.90000 )
				
			--NTSC DV (video)
			append presetList (preset caption:"NTSC DV (video)" apertureWidth:20.120 preset01:[720,480] preset02:[300,200] preset03:[360,240] preset04:[512,341] pixelAspect:0.90000 )
			
			--PAL (video)
			append presetList (preset caption:"PAL (video)" apertureWidth:20.120 preset01:[768,576] preset02:[180,135] preset03:[240,180] preset04:[480,360] pixelAspect:1.0 )
				
			--PAL D-1 (video)
			append presetList (preset caption:"PAL D-1 (video)" apertureWidth:20.120 preset01:[720,576] preset02:[180,144] preset03:[240,192] preset04:[480,384] pixelAspect:1.06667 )
			
			--HDTV
			append presetList (preset caption:"HDTV" apertureWidth:20.120 preset01:[1920,1080] preset02:[480,270] preset03:[1280,720] preset04:[320,180] pixelAspect:1.0 )
				
			--Metemos todos los valores del desplegable.
			_items = #()
			_initialSelectionIndex = 1	
			for _preset in presetList do
			(
				append _items _preset.caption
				--En cuanto detecte el que estaba puesto guardo su índice
				if _preset.caption == editCA.presetName then
					_initialSelectionIndex = _items.count
			)
			ddlOutputs.items = _items
			ddlOutputs.selection = _initialSelectionIndex
			
			--Inicializamos a custom
			_preset = getCurrentPreset()
			
			--Rellenamos controles
			spnApertureWidth.value = editCA.apertureWidth
			spnWidth.value = editCA.width
			spnHeight.value = editCA.height
			btnPreset01.caption = ((_preset.preset01.x As Integer) As String + "x" + (_preset.preset01.y As Integer) As String)
			btnPreset02.caption = ((_preset.preset02.x As Integer) As String + "x" + (_preset.preset02.y As Integer) As String)
			btnPreset03.caption = ((_preset.preset03.x As Integer) As String + "x" + (_preset.preset03.y As Integer) As String)
			btnPreset04.caption = ((_preset.preset04.x As Integer) As String + "x" + (_preset.preset04.y As Integer) As String)
			spnImageAspect.value = (editCA.width + 0.0)/(editCA.height) * editCA.pixelAspect
			spnPixelAspect.value = editCA.pixelAspect
			
			--Si es custom dejaremos tocar la apertura, image aspect y pixel aspect.
			spnApertureWidth.enabled = (_preset.caption == "Custom")
			spnImageAspect.enabled = (_preset.caption == "Custom")
			spnPixelAspect.enabled = (_preset.caption == "Custom")
			ckbLockImageAspect.checked = (_preset.caption != "Custom")
			ckbLockPixelAspect.checked = (_preset.caption != "Custom")
			ckbLockImageAspect.enabled = (_preset.caption == "Custom")
			ckbLockPixelAspect.enabled = (_preset.caption == "Custom")
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
		--@event: changed | Evento que se lanza al cambiar el valor del spinner.
		--@control: spinner | spnWidth | Spinner cuyo valor cambia.
		--@gets: float | val | Nuevo valor del spinner.
		------------------------------------------------
		on spnWidth changed val do
		(
			editCA.width = val
			if ckbLockImageAspect.checked then
			(
				spnHeight.value = lb.math.round((val + 0.0)/spnImageAspect.value * spnPixelAspect.value)
				editCA.height = spnHeight.value
			)
			else
				spnImageAspect.value = (val + 0.0)/spnHeight.value * spnPixelAspect.value
		)	
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor del spinner.
		--@control: spinner | spnHeight | Spinner cuyo valor cambia.
		--@gets: float | val | Nuevo valor del spinner.
		------------------------------------------------
		on spnHeight changed val do
		(
			editCA.height = val
			
			if ckbLockImageAspect.checked then
			(
				spnWidth.value = lb.math.round (spnImageAspect.value * (val + 0.0) / spnPixelAspect.value)
				editCA.width = spnWidth.value
			)
			else
				spnImageAspect.value = (spnWidth.value + 0.0)/val * spnPixelAspect.value
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor del spinner.
		--@control: spinner | spnImageAspect | Spinner cuyo valor cambia.
		--@gets: float | val | Nuevo valor del spinner.
		------------------------------------------------
		on spnImageAspect changed val do
		(
			spnHeight.value = lb.math.round((spnWidth.value + 0.0)/val * spnPixelAspect.value)
			editCA.height = spnHeight.value
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor del spinner.
		--@control: spinner | spnPixelAspect | Spinner cuyo valor cambia.
		--@gets: float | val | Nuevo valor del spinner.
		------------------------------------------------
		on spnPixelAspect changed val do
		(
			editCA.pixelAspect = spnPixelAspect.value
			spnImageAspect.value = (spnWidth.value + 0.0)/spnHeight.value * val
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor del dropdownlist
		--@control: dropdownlist | ddlOutputs | DropdownList cuyo valor cambia.
		--@gets: float | val | Nuevo valor del dropdownlist.
		------------------------------------------------
		on ddlOutputs selected arg do
		(
			
			_preset = getCurrentPreset()
			
			--Rellanamos el Custom Attribute
			editCA.presetName = _preset.caption
			editCA.width = _preset.preset01.x
			editCA.height = _preset.preset01.y
			editCA.pixelAspect = _preset.pixelAspect
			editCA.apertureWidth = _preset.apertureWidth
		
			--Si es custom dejaremos tocar la apertura, image aspect y pixel aspect.
			spnApertureWidth.enabled = (_preset.caption == "Custom")
			spnImageAspect.enabled = (_preset.caption == "Custom")
			spnPixelAspect.enabled = (_preset.caption == "Custom")
			ckbLockImageAspect.checked = (_preset.caption != "Custom")
			ckbLockPixelAspect.checked = (_preset.caption != "Custom")
			ckbLockImageAspect.enabled = (_preset.caption == "Custom")
			ckbLockPixelAspect.enabled = (_preset.caption == "Custom")
			
			--Rellenamos controles
			spnApertureWidth.value = _preset.apertureWidth
			spnWidth.value = _preset.preset01.x
			spnHeight.value = _preset.preset01.y
			btnPreset01.caption = ((_preset.preset01.x As Integer) As String + "x" + (_preset.preset01.y As Integer) As String)
			btnPreset02.caption = ((_preset.preset02.x As Integer) As String + "x" + (_preset.preset02.y As Integer) As String)
			btnPreset03.caption = ((_preset.preset03.x As Integer) As String + "x" + (_preset.preset03.y As Integer) As String)
			btnPreset04.caption = ((_preset.preset04.x As Integer) As String + "x" + (_preset.preset04.y As Integer) As String)
			spnImageAspect.value = (_preset.preset01.x + 0.0)/(_preset.preset01.y) * _preset.pixelAspect
			spnPixelAspect.value = _preset.pixelAspect
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton.  Aplica la resolución que aparece.
		--@control: button | btnPreset01 | Boton presionado.
		------------------------------------------------
		on btnPreset01 pressed do
		(
			_width = (filterString btnPreset01.caption "x")[1] as Integer
			_height = (filterString btnPreset01.caption "x")[2] as Integer
			
			spnWidth.value = _width
			spnHeight.value = _height
			editCA.width = _width
			editCA.height = _height
			
			spnImageAspect.value = (spnWidth.value + 0.0)/spnHeight.value * spnPixelAspect.value
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton.  Aplica la resolución que aparece.
		--@control: button | btnPreset02 | Boton presionado.
		------------------------------------------------
		on btnPreset02 pressed do
		(
			_width = (filterString btnPreset02.caption "x")[1] as Integer
			_height = (filterString btnPreset02.caption "x")[2] as Integer
			
			spnWidth.value = _width
			spnHeight.value = _height
			editCA.width = _width
			editCA.height = _height
			
			if ddlOutputs.selected == "Custom" and _width == 720 and _height == 486 then --Excepción para acceso directo a NTSC en Custom
			(
				spnPixelAspect.value = 0.9
				editCA.pixelAspect = 0.9
				spnImageAspect.value = (spnWidth.value + 0.0)/spnHeight.value * spnPixelAspect.value
			)
			else
				spnImageAspect.value = (spnWidth.value + 0.0)/spnHeight.value * spnPixelAspect.value
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton.  Aplica la resolución que aparece.
		--@control: button | btnPreset03 | Boton presionado.
		------------------------------------------------
		on btnPreset03 pressed do
		(
			_width = (filterString btnPreset03.caption "x")[1] as Integer
			_height = (filterString btnPreset03.caption "x")[2] as Integer
			
			spnWidth.value = _width
			spnHeight.value = _height
			editCA.width = _width
			editCA.height = _height
			
			spnImageAspect.value = (spnWidth.value + 0.0)/spnHeight.value * spnPixelAspect.value
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Aplica la resolución que aparece.
		--@control: button | btnPreset04 | Boton presionado.
		------------------------------------------------
		on btnPreset04 pressed do
		(
			_width = (filterString btnPreset04.caption "x")[1] as Integer
			_height = (filterString btnPreset04.caption "x")[2] as Integer
			
			spnWidth.value = _width
			spnHeight.value = _height
			editCA.width = _width
			editCA.height = _height
			
			spnImageAspect.value = (spnWidth.value + 0.0)/spnHeight.value * spnPixelAspect.value
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
			editCA = parent.editBackupNode.custAttributes[#overrideOutputSizeInfo]
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
	--@struct: overrideOutputSize | Contiene todas las funciones de un override de OutputSize.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideOutputSize
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
		infoNodeCA,						--@var  | infoNodeCA | Variable de atajo para el CA de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideOutputSizeInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideOutputSizeInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			(this.infoNodeCA.width as string) + " x " + (this.infoNodeCA.height as string)
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
			if saveLogs then lb.log.add("BACKUP process started.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideOutputSizeInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				backupNode.custAttributes[#overrideOutputSizeInfo].width = renderWidth
				backupNode.custAttributes[#overrideOutputSizeInfo].height = renderHeight
				backupNode.custAttributes[#overrideOutputSizeInfo].pixelAspect = renderPixelAspect
				backupNode.custAttributes[#overrideOutputSizeInfo].apertureWidth = GetRendApertureWidth()
				
				if saveLogs then lb.log.add("BACKUP process completed.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				true
			)--if
			else
			(
				if saveLogs then lb.log.add("BACKUP process error. Backup node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node not valid.")
				false
			)
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			if savelogs then lb.log.add ("RESTORE process start.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(				
				if backupNode.custAttributes[#overrideOutputSizeInfo] != undefined  then
				(
					renderWidth = backupNode.custAttributes[#overrideOutputSizeInfo].width
					renderHeight = backupNode.custAttributes[#overrideOutputSizeInfo].height
					renderPixelAspect = backupNode.custAttributes[#overrideOutputSizeInfo].pixelAspect
					SetRendApertureWidth backupNode.custAttributes[#overrideOutputSizeInfo].apertureWidth
					
					if savelogs then lb.log.add ("RESTORE process completed.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
					true
				)
				else
				(
					if savelogs then lb.log.add ("RESTORE process error. CA #overrideOutputSizeInfo is undefined.") sender:("override." + (this.getSubType())) type:#error level:logLevel
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Custom attribute not defined.")
					false
				)
			)--if
			else
			(
				if savelogs then lb.log.add ("RESTORE process error. Backup Node not valid.") sender:("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup Node not valid.")
				false
			)
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			if savelogs then lb.log.add ("APPLY process start.") sender:("override." + (this.getSubType())) type:#info level:logLevel
			renderWidth = this.infoNodeCA.width
			renderHeight = this.infoNodeCA.height
			renderPixelAspect = this.infoNodeCA.pixelAspect
			SetRendApertureWidth this.infoNodeCA.apertureWidth
				
			if savelogs then lb.log.add ("APPLY process completed.") sender:("override." + (this.getSubType())) type:#ok level:logLevel
			
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
				if this.editBackupNode.custAttributes[#overrideOutputSizeInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideOutputSizeInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideOutputSizeInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideOutputSizeInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideOutputSizeInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [315,145]
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
			--almacena los valores actuales de tamaño de render de la escena
			this.infoNodeCA.width = renderWidth
			this.infoNodeCA.height = renderHeight
			this.infoNodeCA.pixelAspect = renderPixelAspect
			this.infoNodeCA.apertureWidth = GetRendApertureWidth()
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideOutputSizeInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideOutputSizeInfo]

					this.storeSceneValues()		
				)--if

				--Rellenamos la variable de atajo para el CA de apply
				this.infoNodeCA = this.infoNode.custAttributes[#overrideOutputSizeInfo]

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
		
	)--str_overrideOutputSize
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideOutputSize --añade el override al listado de overrides disponibles
	
	ok
)