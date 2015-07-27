------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de Background
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideCustomMaterialInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideCustomMaterialInfo = attributes overrideCustomMaterialInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.4
			CA_description	type:#string	default:"Almacena la informacion de un override de efectos."
				
			--informacion específica del override
			type	type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType	type:#string	default:"customMaterial" --@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.*/
			
			------------------------------------------------
			--Parámetros de backup
			nodesBackup			type:#nodeTab		tabsizevariable:true --@var | nodes | objetos de la escena de los que se hace backup de los materiales.
			materialsBackup		type:#materialTab	tabsizevariable:true --@var | materials | materiales de la escena de los que se hace backup por cada objeto.
			subAnimChainsBackup	type:#stringTab		tabsizevariable:true --@var | subAnimChains | String con la cadena de subanims a seguir para llegar donde se encuentra almacenado el material
			propertiesBackup	type:#stringTab		tabsizevariable:true --@var | properties | Nombre de la propiedad en la que se encuentra almacenado el material.
			
			------------------------------------------------
			--Parámetros de apply y backup
			
			-- Common --
			customMaterialOverrideType type:#string default:""
			
			-- Pass Y --
			passY_gradientCenterHeight type:#float
			passY_gradientDistance type:#float
			passY_keepPosition type:#boolean
			passY_keepOpacity type:#boolean

			-- Pass Z --
			passZ_nearDistance type:#float
			passZ_farDistance type:#float
			passZ_keepDisplacement type:#boolean
			passZ_keepOpacity type:#boolean

			-- Pass AO --
			passAO_aoColor type:#color
			passAO_nSamples type:#float
			passAO_calcDistance type:#float
			passAO_nonSelfID type:#integer
			passAO_keepOpacity type:#boolean
			passAO_keepDisplacement type:#boolean
			passAO_preserveEyeMaterial type:#boolean
			passAO_keepTransparency type:#boolean
			passAO_forceTransparencyValue type:#boolean
			passAO_transparencyValue type:#integer

			-- Pass Flat Color --

			passFC_flatColor type:#color
			passFC_keepOpacity type:#boolean
			passFC_keepDisplacement type:#boolean

			-- Pass Mask XYZ --
			passMXYZ_keepDisplacement type:#boolean
			passMXYZ_keepOpacity type:#boolean

			-- Pass ETS --

			passETS_eyesColor type:#color
			passETS_teethColor type:#color
			passETS_skinColor type:#color
			passETS_keepOpacity type:#boolean
			passETS_keepDisplacement type:#boolean

			--Pass MD --
			passMD_keepDisplacement type:#boolean

			------------------------------------------------
			--Parámetros de apply
			
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el UI de edicion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Custom Material Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var: editCA | Variable que almacena el custom attribute de edición
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local sectionsIds = #() --@var: sectionsIds | Variable que almacena un id para asociar un nombre a cada valor del array de sectionsControls
		local sectionsControls = #() --@var: sectionsControls | Array de arrays que almacena los controles de cada sección para agruparlos y ocultarlos/desocultarlos con facilidad.
		local sectionsSizes = #() --@var: sectionsSizes | Array con los altos de cada sección (sin incluir los botones de OK y CANCEL, 20 píxeles más.)
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		-- Common controls --
		label lblSelectPass "Select Pass:" pos:[5,5] width:60
		dropdownlist ddlSelectPass pos:[70,2] width:125
		button btnOk "OK" pos:[5,165] width:94
		button btnCancel "Cancel" pos:[99,165] width:94
		
		-- Pass Flat Color --
		groupBox grpPassFC "Pass FLAT COLOR" pos:[5,25] width:189 height:70
		colorpicker clpPassFCColor "Flat Color" pos:[12,45] width:175
		checkbox chkPassFCKeepOpacity "keep opacity" pos:[12,73]
		checkbox chkPassFCKeepDisplacement "keep displcmnt" pos:[97,73]

		-- Pass Y --
		groupBox grpPassY "Pass Y" pos:[5,25] width:189 height:80
		label lblPassYCenterHeight "Gradient center height" pos:[12,40]
		spinner spnPassYCenterHeight range:[-100000,100000,100] type:#float scale:1.0 pos:[133,40] fieldWidth:40 
		label lblPassYDistance "Gradient distance" pos:[12,60]
		spinner spnPassYDistance range:[-100000,100000,100] type:#float scale:1.0 pos:[133,60] fieldWidth:40
		checkbox chkPassYKeepOpacity "keep opacity" pos:[12,80]
		checkbox chkPassYKeepDisplacement "keep displcmnt" pos:[97,80]
		
		-- Pass Z --
		groupBox grpPassZ "Pass Z" pos:[5,25] width:189 height:80
		label lblPassZNearDistance "Near distance" pos:[12,40]
		spinner spnPassZNearDistance range:[-300000,300000,0] type:#float scale:1.0 pos:[123,40] fieldWidth:50
		label lblPassZFarDistance "Far distance" pos:[12,60]
		spinner spnPassZFarDistance range:[-300000,300000,1000] type:#float scale:1.0 pos:[123,60] fieldWidth:50
		checkbox chkPassZKeepOpacity "keep opacity" pos:[12,80]
		checkbox chkPassZKeepDisplacement "keep displcmnt" pos:[97,80]

		-- Pass AO --
		groupBox grpPassAO "Pass AO" pos:[5,25] width:189 height:180
		label lblPassAOColor "Color" pos:[12,40]
		colorpicker clpPassAOColor pos:[133,40]	fieldWidth:50 height:16
		label lblPassAOSamples "Samples" pos:[12,60]
		spinner spnPassAOSamples range:[-100000,100000,128] type:#float scale:1.0 pos:[135,60] fieldWidth:40
		label lblPassAOMaxDistance "Max distance" pos:[12,80]
		spinner spnPassAOMaxDistance range:[-100000,100000,150] type:#float scale:1.0 pos:[135,80] fieldWidth:40 
		label lblPassAONonSOOID "Non self occluding obj ID" pos:[12,100]
		spinner spnPassAONonSOOID range:[0,100000,0] type:#integer scale:1 pos:[135,100] fieldWidth:40
		checkbox chkPassAOKeepOpacity "keep opacity" pos:[12,120]
		checkbox chkPassAOKeepDisplacement "keep displcmnt" pos:[97,120]
		checkbox chkPassAOKeepEyesMaterial "keep eyes material" pos:[12,140]
		checkbox chkPassAOKeepTransparency "keep transparency" pos:[12,160]
		checkbox chkPassAOForceValue "Force Value" pos:[12,180]
		spinner spnPassAOForceValue pos:[135,180] range:[0,100,10] type:#integer scale:1 fieldWidth:40

		-- Pass Mask XYZ --
		groupBox grpPassMXYZ "Pass Mask XYZ" pos:[5,25] width:189 height:40
		checkbox chkPassMXYZKeepOpacity "keep opacity" pos:[12,40]
		checkbox chkPassMXYZKeepDisplacement "keep displcmnt" pos:[97,40]

		-- Pass ETS --
		groupBox grpPassETS "Pass ETS" pos:[5,25] width:189 height:130
		colorpicker clpPassETSeyesColor "Eyes Color" pos:[12,45] width:175
		colorpicker clpPassETSteethColor "Teeth Color" pos:[12,73] width:175
		colorpicker clpPassETSskinColor "Skin Color" pos:[12,101] width:175
		checkbox chkPassETSKeepOpacity "keep opacity" pos:[12,129]
		checkbox chkPassETSKeepDisplacement "keep displcmnt" pos:[97,129]

		-- Pass Matte Displace --
		checkbox chkPassMDKeepDisplacement "keep displcmnt" pos:[60,27] 

		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@fn: undefined | createUIGroup | Crea una id de ui en el array de secciones, un array vacío en el de controles y su altura en el de alturas.
		------------------------------------------------
		fn createUISection uid uiheight =
		(
			--Si no lo encuentra lo agrega
			if (finditem sectionsIds uid) == 0 then
			(
				append sectionsIds uid
				append sectionsControls #()
				append sectionsSizes uiheight
			)
			else
				print ("Section " + uid + " already created, aborting.")
		)

		------------------------------------------------
		--@fn: undefined | addToUISection | Añade un control al array de controles para un grupo dado.
		------------------------------------------------
		fn addToUISection uid uisArray =
		(	
			--Si no existe no hacemos nada
			if (finditem sectionsIds uid) != 0 then
			(
				join sectionsControls[(finditem sectionsIds uid)] uisArray
				sectionsControls[(finditem sectionsIds uid)] = makeUniqueArray sectionsControls[(finditem sectionsIds uid)] 
			)
			else
				print ("Section " + uid + " not found, aborting.")
		)

		------------------------------------------------
		--@fn: undefined | addToUISection | Añade un control al array de controles para un grupo dado.
		------------------------------------------------
		fn showUISection uid =
		(
			if (finditem sectionsIds uid) != 0 then
			(
				for i=1 to sectionsControls.count do
				(
					if(sectionsIds[i] == uid) then
					(
						sectionsControls[i].visible = true
						rollMainDef.height = sectionsSizes[i]
						btnOk.pos.y = sectionsSizes[i] - 25
						btnCancel.pos.y = sectionsSizes[i] - 25
					)
					else
					(
						sectionsControls[i].visible = false
					)
				)
			)
			else
				print ("Section " + uid + "not found, nothing to show.")
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
		
		------------------------------------------------
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			--Controles de la sección de pass FLAT COLOR
			createUISection "Pass Flat Color" 125
			addToUISection "Pass Flat Color" #(grpPassFC,clpPassFCColor,chkPassFCKeepOpacity,chkPassFCKeepDisplacement)

			--Controles de la sección de pass Y
			createUISection "Pass Y" 135
			addToUISection "Pass Y" #(grpPassY,spnPassYDistance,spnPassYCenterHeight,chkPassYKeepOpacity,chkPassYKeepDisplacement,lblPassYCenterHeight,lblPassYDistance)

			--Controles de la sección de pass Z
			createUISection "Pass Z" 135
			addToUISection "Pass Z" #(grpPassZ,lblPassZNearDistance,spnPassZNearDistance,lblPassZFarDistance,spnPassZFarDistance,chkPassZKeepOpacity,chkPassZKeepDisplacement)
			
			--Controles de la sección de pass AO
			createUISection "Pass AO" 235
			addToUISection "Pass AO" #(grpPassAO,lblPassAOColor,clpPassAOColor,lblPassAOSamples,spnPassAOSamples,lblPassAONonSOOID,spnPassAONonSOOID,lblPassAOMaxDistance,spnPassAOMaxDistance,chkPassAOKeepOpacity,chkPassAOKeepDisplacement,chkPassAOKeepTransparency,chkPassAOForceValue, spnPassAOForceValue, chkPassAOKeepEyesMaterial)

			--Controles de la sección de pass Mask XYZ
			createUISection "Pass Mask XYZ" 100
			addToUISection "Pass Mask XYZ" #(grpPassMXYZ,chkPassMXYZKeepOpacity,chkPassMXYZKeepDisplacement)

			--Controles de la sección de pass ETS
			createUISection "Pass ETS" 190
			addToUISection "Pass ETS" #(grpPassETS,clpPassETSeyesColor,clpPassETSteethColor,clpPassETSskinColor,chkPassETSKeepOpacity,chkPassETSKeepDisplacement)

			--Controles de la sección de pass Pupil
			createUISection "Pass Pupil" 50
			--addToUISection "Pass Pupil" #()

			--Controles de la sección de pass Hair RGB
			createUISection "Pass Matte Shadow" 50
			--addToUISection "Pass Hair RGB" #()

			--Controles de la sección de pass Hair RGB
			createUISection "Pass Hair RGB" 50
			--addToUISection "Pass Hair RGB" #()

			--Controles de la sección de pass Matte Displace
			createUISection "Pass Matte Displace" 75
			addToUISection "Pass Matte Displace" #(chkPassMDKeepDisplacement)
			--addToUISection "Matte Displace" #()

			--Rellenamos los valores del custom attribute en el interfaz

			-- Pass Flat Color --
			clpPassFCColor.color = editCA.passFC_flatColor 
			chkPassFCKeepOpacity.checked = editCA.passFC_keepOpacity 
			chkPassFCKeepDisplacement.checked = editCA.passFC_keepDisplacement 
			
			-- Pass Y --
			spnPassYCenterHeight.value = editCA.passY_gradientCenterHeight
			spnPassYDistance.value = editCA.passY_gradientDistance
			chkPassYKeepDisplacement.checked = editCA.passY_keepPosition
			chkPassYKeepOpacity.checked = editCA.passY_keepOpacity

			-- Pass Z --
			spnPassZNearDistance.value = editCA.passZ_nearDistance
			spnPassZFarDistance.value = editCA.passZ_farDistance
			chkPassZKeepOpacity.checked = editCA.passZ_keepDisplacement
			chkPassZKeepDisplacement.checked = editCA.passZ_keepOpacity

			-- Pass AO --
			clpPassAOColor.color = editCA.passAO_aoColor
			spnPassAOSamples.value = editCA.passAO_nSamples
			spnPassAOMaxDistance.value = editCA.passAO_calcDistance
			spnPassAONonSOOID.value = editCA.passAO_nonSelfID
			chkPassAOKeepOpacity.checked = editCA.passAO_keepOpacity
			chkPassAOKeepDisplacement.checked = editCA.passAO_keepDisplacement
			chkPassAOKeepEyesMaterial.checked = editCA.passAO_preserveEyeMaterial
			chkPassAOKeepTransparency.checked = editCA.passAO_keepTransparency
			chkPassAOForceValue.checked = editCA.passAO_forceTransparencyValue
			chkPassAOForceValue.enabled = chkPassAOKeepTransparency.checked
			spnPassAOForceValue.value = editCA.passAO_transparencyValue
			spnPassAOForceValue.enabled = chkPassAOKeepTransparency.checked and chkPassAOForceValue.checked

			-- Pass Mask XYZ --
			chkPassMXYZKeepOpacity.checked = editCA.passMXYZ_keepDisplacement
			chkPassMXYZKeepDisplacement.checked = editCA.passMXYZ_keepOpacity

			-- Pass ETS --
			clpPassETSeyesColor.color = editCA.passETS_eyesColor 
			clpPassETSteethColor.color = editCA.passETS_teethColor 
			clpPassETSskinColor.color = editCA.passETS_skinColor 
			chkPassETSKeepOpacity.checked = editCA.passETS_keepOpacity 
			chkPassETSKeepDisplacement.checked = editCA.passETS_keepDisplacement 

			-- Pass MD -- 
			chkPassMDKeepDisplacement.checked = editCA.passMD_keepDisplacement
			
			--Agregamos la lista de secciones al desplegable de selección
			ddlSelectPass.items = sectionsIds
			
			--Finalmente ocultaremos el interfaz en función de lo seleccionado por el usuario.
			for i=1 to ddlSelectPass.items.count do
			(
				if ddlSelectPass.items[i] == editCA.customMaterialOverrideType then
				(
					ddlSelectPass.selection = i
					showUISection editCA.customMaterialOverrideType
				)
			)
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--No carga settings
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
		--@event: changed | Control de valor de fuerza en el pass ao, activa o desactiva el spinner.
		--@control: checkButton | chkPassAOForceValue | Checkbutton cambiado.
		------------------------------------------------
		on chkPassAOForceValue changed state do
		(
			spnPassAOForceValue.enabled = state
		)

		------------------------------------------------
		--@event: changed | Evento del control de transparencia en el passAO, activa o desactiva los controles de fuerza
		--@control: checkButton | chkPassAOKeepTransparency | Checkbutton cambiado.
		------------------------------------------------
		on chkPassAOKeepTransparency changed state do
		(
			chkPassAOForceValue.enabled = state
			spnPassAOForceValue.enabled = (chkPassAOForceValue.checked and state)
		)


		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on ddlSelectPass selected selection do
		(
			showUISection ddlSelectPass.items[selection]
		) 
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			--Salvamos los valores del interfaz en el custom attribute
			-- Pass Flat Color --
			editCA.passFC_flatColor = clpPassFCColor.color
			editCA.passFC_keepOpacity = chkPassFCKeepOpacity.checked 
			editCA.passFC_keepDisplacement = chkPassFCKeepDisplacement.checked
			
			-- Pass Y --
			editCA.passY_gradientCenterHeight = spnPassYCenterHeight.value
			editCA.passY_gradientDistance = spnPassYDistance.value
			editCA.passY_keepPosition = chkPassYKeepDisplacement.checked
			editCA.passY_keepOpacity = chkPassYKeepOpacity.checked

			-- Pass Z --
			editCA.passZ_nearDistance = spnPassZNearDistance.value
			editCA.passZ_farDistance = spnPassZFarDistance.value
			editCA.passZ_keepDisplacement = chkPassZKeepOpacity.checked
			editCA.passZ_keepOpacity = chkPassZKeepDisplacement.checked 

			-- Pass AO --
			editCA.passAO_aoColor = clpPassAOColor.color
			editCA.passAO_nSamples = spnPassAOSamples.value
			editCA.passAO_calcDistance = spnPassAOMaxDistance.value 
			editCA.passAO_nonSelfID = spnPassAONonSOOID.value
			editCA.passAO_keepOpacity = chkPassAOKeepOpacity.checked
			editCA.passAO_keepDisplacement = chkPassAOKeepDisplacement.checked
			editCA.passAO_preserveEyeMaterial = chkPassAOKeepEyesMaterial.checked
			editCA.passAO_keepTransparency = chkPassAOKeepTransparency.checked
			editCA.passAO_forceTransparencyValue = chkPassAOForceValue.checked 
			editCA.passAO_transparencyValue = spnPassAOForceValue.value

			-- Pass Mask XYZ --
			editCA.passMXYZ_keepDisplacement = chkPassMXYZKeepOpacity.checked
			editCA.passMXYZ_keepOpacity = chkPassMXYZKeepDisplacement.checked 

			-- Pass ETS --
			editCA.passETS_eyesColor = clpPassETSeyesColor.color
			editCA.passETS_teethColor = clpPassETSteethColor.color
			editCA.passETS_skinColor = clpPassETSskinColor.color
			editCA.passETS_keepOpacity = chkPassETSKeepOpacity.checked
			editCA.passETS_keepDisplacement = chkPassETSKeepDisplacement.checked

			-- Pass MD --
			editCA.passMD_keepDisplacement = chkPassMDKeepDisplacement.checked
			
			--Agregamos la lista de secciones al desplegable de selección
			editCA.customMaterialOverrideType = ddlSelectPass.selected

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
			
			editCA = parent.editBackupNode.custAttributes[#overrideCustomMaterialInfo]
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
	struct str_overrideEffects
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
		
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,							--@var | infoCA | Variable que almacena el custom attribute de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideCustomMaterialInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideCustomMaterialInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			--función que devuelve el texto del override
			this.infoNodeCA.customMaterialOverrideType
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
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("BACKUP process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideCustomMaterialInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo

				_ancestor = ((this.getParentContainer()).getParent())
				_objects = #()
				
				case (_ancestor.getSubType()) of
				(
					#pass:
					(
						for i=1 to (_ancestor.getChildren()).count do
						(
							if ((_ancestor.getChildren())[i].getSubType()) == #ObjectSet then
							(
								_nodeSets = (_ancestor.getChildren())[i].getNodeSets()
								for _n in _nodeSets do
								(
									join _objects (_n.getNodes())
								)
							)
						)
					)--pass

					#ObjectSet:
					(
						_nodeSets = _ancestor.getNodeSets()
						for _n in _nodeSets do
						(
							join _objects (_n.getNodes())
						)
					)--ObjectSet
					#flatColorObjectSet:
					(
						_nodeSets = _ancestor.getNodeSets()
						for _n in _nodeSets do
						(
							join _objects (_n.getNodes())
						)
						_nodes = _ancestor.getNodes()
						for _n in _nodes do
						(
							join _objects _n
						)
					)--ObjectSet
				)--case

				_objects = makeUniqueArray _objects

				backupNode.custAttributes[#overrideCustomMaterialInfo].nodesBackup = #()
				backupNode.custAttributes[#overrideCustomMaterialInfo].materialsBackup = #()
				backupNode.custAttributes[#overrideCustomMaterialInfo].subAnimChainsBackup = #()
				backupNode.custAttributes[#overrideCustomMaterialInfo].propertiesBackup = #()

				--almacena los nodos y sus materiales
				for o in objects where (o != backupNode) do
				(
					for _matInfo in (lb.materials.getMaterialsRecursiveExt o) do
					(
						_node = _matInfo.rootNode
						_subAnimChain = #()
						if (lb.misc.areArraysEqual _matInfo.subAnimChain #(5)) and _matInfo.property == #value then
						(
							_property = #material
						)
						else
						(
							for subAnimIndex in _matInfo.subAnimChain do
							(
								_node = _node[subAnimIndex]
								append _subAnimChain (subAnimIndex as string)
							)
							_property = _matInfo.property
						)
						append backupNode.custAttributes[#overrideCustomMaterialInfo].nodesBackup (_matInfo.rootNode)
						append backupNode.custAttributes[#overrideCustomMaterialInfo].materialsBackup (getProperty _node _property)
						append backupNode.custAttributes[#overrideCustomMaterialInfo].subAnimChainsBackup (lb.str.join _subAnimChain ",")
						append backupNode.custAttributes[#overrideCustomMaterialInfo].propertiesBackup (_property as string)
					)
				)--for		

				_success = true
			)
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)					
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup node is not valid.")
				_success = false
			)
			
			if saveLogs then
			(
				if _success then lb.log.add ("BACKUP process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("BACKUP process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("RESTORE process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(
				if backupNode.custAttributes[#overrideCustomMaterialInfo] != undefined then
				(
					--Aquí hacemos restore de los valores de la escena
					for i=1 to backupNode.custAttributes[#overrideCustomMaterialInfo].nodesBackup.count do
					(
						_node = backupNode.custAttributes[#overrideCustomMaterialInfo].nodesBackup[i]
						_subAnimChains = backupNode.custAttributes[#overrideCustomMaterialInfo].subAnimChainsBackup[i]
						_property = backupNode.custAttributes[#overrideCustomMaterialInfo].propertiesBackup[i] as name
						_material = backupNode.custAttributes[#overrideCustomMaterialInfo].materialsBackup[i]

						_subAnimChains = lb.str.split _subAnimChains ","
						_subAnimChains = for i=1 to _subAnimChains.count collect (_subAnimChains[i] as integer)

						for _sa in _subAnimChains do
							_node = _node[_sa]

						setProperty _node _property _material
					)
					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("Backup node with no custom attribute") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node with no custom attribute.")
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup node is not valid.")
				_success = false
			)
			
			if saveLogs then
			(
				if _success then lb.log.add ("RESTORE process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("RESTORE process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | apply | Aplica el override a los objetos o parametros correspondientes.
		--@opt: boolean | saveLogs | false | Indica si salvar logs.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			_success = false
			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--Aquí aplicamos los valores de nuestro override a los de la escena
			_ancestor = ((this.getParentContainer()).getParent())
			_objects = #()

			case (_ancestor.getSubType()) of
			(
				#pass:
				(
					for i=1 to (_ancestor.getChildren()).count do
					(
						if ((_ancestor.getChildren())[i].getSubType()) == #ObjectSet then
						(
							_nodeSets = (_ancestor.getChildren())[i].getNodeSets()
							for _n in _nodeSets do
							(
								join _objects (_n.getNodes())
							)
						)
					)
				)--pass

				#ObjectSet:
				(
					_nodeSets = _ancestor.getNodeSets()
					for _n in _nodeSets do
					(
						join _objects (_n.getNodes())
					)
				)--ObjectSet
				#flatColorObjectSet:
				(
					_nodeSets = _ancestor.getNodeSets()
					for _n in _nodeSets do
					(
						join _objects (_n.getNodes())
					)
					_nodes = _ancestor.getNodes()
					for _n in _nodes do
					(
						join _objects _n
					)
				)--ObjectSet
			)--case

			if _objects.count != 0 then
			(
				_objects = makeUniqueArray _objects

				case this.infoNodeCA.customMaterialOverrideType of
				(
					"Pass Flat Color":
					(
						lb.materials.passFmaterialConversion _objects this.infoNodeCA.passFC_flatColor keepOpacity:this.infoNodeCA.passFC_keepOpacity keepDisplacement:this.infoNodeCA.passFC_keepDisplacement 
					)

					"Pass Y":
					(
						lb.materials.passYmaterialConversion _objects this.infoNodeCA.passY_gradientCenterHeight this.infoNodeCA.passY_gradientDistance keepOpacity:this.infoNodeCA.passY_keepOpacity keepDisplacement:this.infoNodeCA.passY_keepPosition
					)

					"Pass Z":
					(
						lb.materials.passZmaterialConversion _objects this.infoNodeCA.passZ_nearDistance this.infoNodeCA.passZ_farDistance  keepOpacity:this.infoNodeCA.passZ_keepOpacity keepDisplacement:this.infoNodeCA.passZ_keepDisplacement
					)
					
					"Pass AO":
					(
						lb.materials.passAOmaterialConversion _objects this.infoNodeCA.passAO_nSamples this.infoNodeCA.passAO_calcDistance this.infoNodeCA.passAO_nonSelfID keepOpacity:this.infoNodeCA.passAO_keepOpacity keepDisplacement:this.infoNodeCA.passAO_keepDisplacement keepTransparency:this.infoNodeCA.passAO_keepTransparency forceTransparencyValue:this.infoNodeCA.passAO_forceTransparencyValue transparencyValue:this.infoNodeCA.passAO_transparencyValue preserveEyeMaterial:this.infoNodeCA.passAO_preserveEyeMaterial aoColor:this.infoNodeCA.passAO_aoColor
					)

					"Pass Mask XYZ":
					(
						lb.materials.passMXYZmaterialConversion _objects keepOpacity:this.infoNodeCA.passMXYZ_keepOpacity keepDisplacement:this.infoNodeCA.passMXYZ_keepDisplacement
					)

					"Pass ETS":
					(
						lb.materials.passETSmaterialConversion _objects this.infoNodeCA.passETS_eyesColor this.infoNodeCA.passETS_teethColor this.infoNodeCA.passETS_skinColor keepOpacity:this.infoNodeCA.passETS_keepOpacity keepDisplacement:this.infoNodeCA.passETS_keepDisplacement 
					)

					"Pass Pupil":
					(
						lb.materials.passPupilmaterialConversion _objects
					)

					"Pass Hair RGB":
					(
						lb.materials.passHairRGBmaterialConversion _objects
					)

					"Pass Matte Shadow":
					(
						lb.materials.passMatteShadowMaterialConversion _objects
					)
					"Pass Matte Displace":
					(
						lb.materials.passMatteDisplaceMaterialConversion _objects keepDisplacement:this.infoNodeCA.passMD_keepDisplacement
					)
				)--case
			)--if

			_success = true
			if saveLogs then
			(
				if _success then lb.log.add ("APPLY process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("APPLY process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
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
				if this.editBackupNode.custAttributes[#overrideCustomMaterialInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideCustomMaterialInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideCustomMaterialInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideCustomMaterialInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideCustomMaterialInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			--_size = [300, 130]
			_size = [200, 300]
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
			--Aquí rellenamos los parámetros del override al principio (todos con los que vienen en la escena)

			-- Common --
			this.infoNodeCA.customMaterialOverrideType = "Pass Flat Color"
			
			-- Pass Flat Color --
			this.infoNodeCA.passFC_flatColor = color 255 0 0 0
			this.infoNodeCA.passFC_keepOpacity = true
			this.infoNodeCA.passFC_keepDisplacement = true
			
			-- Pass Y --
			this.infoNodeCA.passY_gradientCenterHeight = 100.0
			this.infoNodeCA.passY_gradientDistance = 100.0
			this.infoNodeCA.passY_keepPosition = true
			this.infoNodeCA.passY_keepOpacity = true

			-- Pass Z --
			this.infoNodeCA.passZ_nearDistance = 0.0
			this.infoNodeCA.passZ_farDistance = 1000.0
			this.infoNodeCA.passZ_keepDisplacement = true
			this.infoNodeCA.passZ_keepOpacity = true

			-- Pass AO --
			this.infoNodeCA.passAO_aoColor = color 255 255 255
			this.infoNodeCA.passAO_nSamples = 128.0
			this.infoNodeCA.passAO_calcDistance = 150.0
			this.infoNodeCA.passAO_nonSelfID = 0
			this.infoNodeCA.passAO_keepOpacity = true
			this.infoNodeCA.passAO_keepDisplacement = true
			this.infoNodeCA.passAO_preserveEyeMaterial = false
			this.infoNodeCA.passAO_keepTransparency = false
			this.infoNodeCA.passAO_forceTransparencyValue = true
			this.infoNodeCA.passAO_transparencyValue = 10

			-- Pass Mask XYZ --
			this.infoNodeCA.passMXYZ_keepDisplacement = true
			this.infoNodeCA.passMXYZ_keepOpacity = true

			-- Pass ETS --
			this.infoNodeCA.passETS_eyesColor = color  0 255 0 0
			this.infoNodeCA.passETS_teethColor = color 0 0 255 0
			this.infoNodeCA.passETS_skinColor = color 255 0 0 0
			this.infoNodeCA.passETS_keepOpacity = true
			this.infoNodeCA.passETS_keepDisplacement = true

			-- Pass MD -- 
			this.infoNodeCA.passMD_keepDisplacement = true

			-- Backup --
			this.infoNodeCA.nodesBackup = #()
			this.infoNodeCA.materialsBackup = #()
			this.infoNodeCA.subAnimChainsBackup = #()
			this.infoNodeCA.propertiesBackup = #()
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideCustomMaterialInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					
					--Almacenamos el custom attribute de info en la variable infoNodeCA
					this.infoNodeCA = this.infoNode.custAttributes[#overrideCustomMaterialInfo]

					this.storeSceneValues()
				)
				else
				(
					--Almacenamos el custom attribute de info en la variable infoNodeCA
					this.infoNodeCA = this.infoNode.custAttributes[#overrideCustomMaterialInfo]
				)
				
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
		
	)--str_overrideEffects
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideEffects --añade el override al listado de overrides disponibles
	
	ok
)