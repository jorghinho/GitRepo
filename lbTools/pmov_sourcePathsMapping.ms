------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de sourcePathsMapping
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideSourcePathsMappingInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideSourcePathsMappingInfo = attributes overrideSourcePathsMappingInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.1
			CA_description	type:#string	default:"Almacena la informacion de un override de OutputPath."
				
			--informacion específica del override
			type		type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType		type:#string	default:"sourcePathsMapping"	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			-------------------------------------------------------------
			-- Parámetros de backup
			
			-------------------------------------------------------------
			-- Parámetros de backup y apply
			------------------------------------------------
			--informacion sobre el contenido almacenado en el override
			sourcePaths		type:#stringTab		tabSizeVariable:true --@var | sourcePaths | Array de partes a ser sustituidas.
			mappingPaths	type:#stringTab		tabSizeVariable:true --@var | mappingPaths | Array de partes por las cuales seran sustituidas.
			------------------------------------------------
			
			-------------------------------------------------------------
			-- Parámetros de apply
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | UI para modificar los parametros del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Source Paths Mapping Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		local editCA = undefined --@var: editCA | Variable de atajo para el CA de edición
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local generalBackColor = (dotNetClass "System.drawing.color").fromArgb 50 50 50 --@var : generalBackColor | Color de fondo general.
		local generalForeColor = (dotNetClass "System.drawing.color").fromArgb 230 230 230 --@var : generalForeColor | Color de letra general.
		
		local selectedBackColor = (dotNetClass "System.Drawing.Color").midnightblue --@var : selectedBackColor | Color de fondo de la seleccion.

		local cellColor1 = (dotNetClass "System.drawing.color").fromArgb 40 40 40 --@var : cellColor1 | Color de celda general.
		local cellColor2 = (dotNetClass "System.drawing.color").fromArgb 45 45 45 --@var : cellColor2 | Color de celda general.

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--button btnPath "..." pos:[5,5] width:17 height:17--@control | btnPath | Para elegir el path de salida.
		--edittext edtPath "" pos:[20,5] width:475 --@control | edtPath | Path de salida para el render.
		--label lblPath "" pos:[25,5] width:500 border:true --@control | lblPath | Path de salida para el render.
		
		edittext edtSourcePath "" pos:[0,5] width:182 --@control | edtSourcePath | Nuevo Path a mapear.
		edittext edtMappedPath "" pos:[182,5] width:175 --@control | edtMappedPath | Nuevo Path al que será mapeado.
		button btnSearchFolder "..." pos:[359,4] width:18 height:18--@control | btnSearchFolder| Para buscar una carpeta.
		button btnAdd "+" pos:[377,4] width:18 height:18--@control | btnAdd | Para añadir los nuevos paths.

		label lblSource "Source Map" pos:[10,32]
		label lblMapped "Mapped To:" pos:[208,32]
		button btnMoveUp "Up" pos:[339,32] width:18 height:18 toolTip:"Move Channel Up" images:#(((lb.config.getIconsPath()) + "bip_layer_i.bmp"), undefined, 24, 1, 1, 1, 1, true)
		button btnMoveDown "Down" pos:[357,32] width:18 height:18 toolTip:"Move Channel Down" images:#(((lb.config.getIconsPath()) + "bip_layer_i.bmp"), undefined, 24, 3, 3, 3, 3, true)
		button btnDelete "-" pos:[377,32] width:18 height:18 --@control | btnDelete | Para eliminar los nuevos paths.
		dotNetControl lvPaths "System.Windows.Forms.ListView" pos:[5,50] width:390 height:170 --@control | lvPaths | Listado de Paths.

		button btnOk "OK" pos:[5,225] width:195 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[200,225] width:195 --@control | btnCancel | Cancela los cambios y cierra.
		
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
		--@fn: undefined | initListView | Establece los parametros y aspecto inicial del listado.
		------------------------------------------------
		fn initListView =
		(
			--configura el aspecto del listado
			lvPaths.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 9
			lvPaths.view = (dotNetClass "System.Windows.Forms.View").details
			lvPaths.headerStyle = (dotnetclass "System.Windows.Forms.ColumnHeaderStyle").none
			lvPaths.gridLines = false
			lvPaths.MultiSelect = false
			lvPaths.fullRowSelect = true
			lvPaths.backColor = generalBackColor
			lvPaths.foreColor = generalForeColor
			lvPaths.labelEdit = false
			
			lvPaths.columns.add "Source Map" (lvPaths.width/2.0)
			lvPaths.columns.add "Mapped to" ((lvPaths.width/2.0) - 20)

			lvPaths.enabled = false
			lvPaths.enabled = true
		)

		------------------------------------------------
		--@fn: undefined | updateRowsColor | Actualzia el color de las filas del listado.
		--@opt: boolean | focus | true | Indica si se ha perdido o no el foco.
		------------------------------------------------
		fn updateRowsColor focus:true =
		(
			for i=1 to lvPaths.items.count do
			(
				if lvPaths.items.item[i-1].selected and not focus then
					lvPaths.items.item[i-1].subItems.item[0].backColor = lvPaths.items.item[i-1].subItems.item[1].backColor = selectedBackColor
				else
					lvPaths.items.item[i-1].subItems.item[0].backColor = lvPaths.items.item[i-1].subItems.item[1].backColor = if (mod i 2) == 0 then cellColor1 else cellColor2
			)--for
		)

		------------------------------------------------
		--@fn: undefined | fillPathsList | Rellena el listado con los overrides permitidos.
		------------------------------------------------
		fn fillPathsList =
		(
			lvPaths.items.clear() --vacia el listado
			
			for i=1 to editCA.sourcePaths.count do
			(
				--crea la fila del listado
				_row = dotNetObject "System.Windows.Forms.ListViewItem" editCA.sourcePaths[i]
				_row.subItems.add editCA.mappingPaths[i]
				_row.UseItemStyleForSubItems = false --hace que el color de cada celda pueda ser diferente

				lvPaths.items.add _row --añade la fila				
			)--for

			updateRowsColor()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			fillPathsList()
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
		--@event: pressed | Evento que se lanza al presionar el boton. Añade un path.
		--@control: button | btnSearchFolder | Boton presionado.
		------------------------------------------------
		on btnSearchFolder pressed do
		(
			if doesDirectoryExist edtMappedPath.text then
			(
				_path = getSavePath initialDir:edtMappedPath.text
				 
			)
			else
			(
				_path = getSavePath initialDir:"C:\\"
			)
			
			if _path != undefined then
				edtMappedPath.text = _path
		)
		
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Añade un path.
		--@control: button | btnAdd | Boton presionado.
		------------------------------------------------
		on btnAdd pressed do
		(
			if findItem editCA.sourcePaths edtSourcePath.text == 0 and findItem editCA.mappingPaths edtMappedPath.text == 0 then
			(
				append editCA.sourcePaths edtSourcePath.text
				append editCA.mappingPaths edtMappedPath.text

				fillPathsList()
			)
			else
			(
				messageBox "One of the paths is already added to de list"
			)--if else
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Elimina un path.
		--@control: button | btnDelete | Boton presionado.
		------------------------------------------------
		on btnDelete pressed do
		(
			if lvPaths.selectedItems.count != 0 then
			(
				_index = (lvPaths.selectedItems.item[0].index)
				lvPaths.items.RemoveAt _index
				deleteItem editCA.sourcePaths (_index + 1)
				deleteItem editCA.mappingPaths (_index + 1)
			)--if
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Mueve un path hacia arriba.
		--@control: button | btnMoveUp | Boton presionado.
		------------------------------------------------
		on btnMoveUp pressed do
		(
			if lvPaths.selectedItems.count != 0 then
			(
				_index = (lvPaths.selectedItems.item[0].index)
				
				--si no es el primer elemento se permite reordenar
				if _index > 0 then
				(
					------------------------------------------------
					--intercambio de posiciones en el listado

					_tmpSourceText = lvPaths.items.item[_index].subItems.item[0].text
					_tmpMappedText = lvPaths.items.item[_index].subItems.item[1].text

					lvPaths.items.item[_index].subItems.item[0].text = lvPaths.items.item[_index - 1].subItems.item[0].text
					lvPaths.items.item[_index].subItems.item[1].text = lvPaths.items.item[_index - 1].subItems.item[1].text

					lvPaths.items.item[_index - 1].subItems.item[0].text = _tmpSourceText
					lvPaths.items.item[_index - 1].subItems.item[1].text = _tmpMappedText

					lvPaths.items.item[_index].selected = false
					lvPaths.items.item[_index - 1].selected = true					
					------------------------------------------------

					------------------------------------------------
					--intercambio de posiciones en el Array del CA

					_tmpSourcePath = editCA.sourcePaths[_index + 1]
					_tmpMappedPath = editCA.mappingPaths[_index + 1]

					editCA.sourcePaths[_index + 1] = editCA.sourcePaths[_index]
					editCA.mappingPaths[_index + 1] = editCA.mappingPaths[_index]

					editCA.sourcePaths[_index] = _tmpSourcePath
					editCA.mappingPaths[_index] = _tmpMappedPath
					------------------------------------------------
				)

				lvPaths.Focus() --devuelve el foco al listado
			)--if
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Mueve un path hacia abajo.
		--@control: button | btnMoveDown | Boton presionado.
		------------------------------------------------
		on btnMoveDown pressed do
		(
			if lvPaths.selectedItems.count != 0 then
			(
				_index = (lvPaths.selectedItems.item[0].index)
				
				--si no es el ultimo elemento se permite reordenar
				if _index < (lvPaths.items.count - 1) then
				(
					------------------------------------------------
					--intercambio de posiciones en el listado

					_tmpSourceText = lvPaths.items.item[_index].subItems.item[0].text
					_tmpMappedText = lvPaths.items.item[_index].subItems.item[1].text

					lvPaths.items.item[_index].subItems.item[0].text = lvPaths.items.item[_index + 1].subItems.item[0].text
					lvPaths.items.item[_index].subItems.item[1].text = lvPaths.items.item[_index + 1].subItems.item[1].text

					lvPaths.items.item[_index + 1].subItems.item[0].text = _tmpSourceText
					lvPaths.items.item[_index + 1].subItems.item[1].text = _tmpMappedText

					lvPaths.items.item[_index].selected = false
					lvPaths.items.item[_index + 1].selected = true					
					------------------------------------------------

					------------------------------------------------
					--intercambio de posiciones en el Array del CA

					_tmpSourcePath = editCA.sourcePaths[_index + 1]
					_tmpMappedPath = editCA.mappingPaths[_index + 1]

					editCA.sourcePaths[_index + 1] = editCA.sourcePaths[_index + 2]
					editCA.mappingPaths[_index + 1] = editCA.mappingPaths[_index + 2]

					editCA.sourcePaths[_index + 2] = _tmpSourcePath
					editCA.mappingPaths[_index + 2] = _tmpMappedPath
					------------------------------------------------
				)

				lvPaths.Focus() --devuelve el foco al listado
			)--if
		)

		------------------------------------------------
		--@event: entered | Evento que se lanza al presionar el enter o tab.
		--@control: edittext | edtSourcePath | control que cambia su valor.
		--@gets: string | newText | nuevo texto.
		------------------------------------------------
		on edtSourcePath entered newText do
		(
			--solo actua si hay un path seleccionado
			if lvPaths.selectedItems.count != 0 then
			(
				if doesFileExist newText then
				(
					_index = lvPaths.selectedItems.item[0].index
					editCA.sourcePaths[_index + 1] = newText
					lvPaths.items.item[_index].subItems.item[0].text = newText
				)
				else
				(
					messageBox "Chosen path doesn't exist. Previous path will be restored."
					edtSourcePath.text = editCA.sourcePaths[lvPaths.selectedItems.item[0].index + 1]					
				)
			)
		)

		------------------------------------------------
		--@event: entered | Evento que se lanza al presionar el enter o tab.
		--@control: edittext | edtMappedPath | control que cambia su valor.
		--@gets: string | newText | nuevo texto.
		------------------------------------------------
		on edtMappedPath entered newText do
		(
			--solo actua si hay un path seleccionado
			if lvPaths.selectedItems.count != 0 then
			(
				_index = lvPaths.selectedItems.item[0].index
				editCA.mappingPaths[_index + 1] = newText
				lvPaths.items.item[_index].subItems.item[1].text = newText
			)
		)
		
		------------------------------------------------
		--@event: itemSelectionChanged | Evento que salta al cambiar la seleccion del listado.
		--@control: System.Windows.Forms.ListView | lvPaths | Listado que cambia su seleccion.
		--@gets: event | events | Evento lanzado.
		------------------------------------------------
		on lvPaths itemSelectionChanged events do
		(
			--solo actua si hay un path seleccionado
			if lvPaths.selectedItems.count != 0 then
			(
				_index = lvPaths.selectedItems.item[0].index
				edtSourcePath.text = lvPaths.items.item[_index].subItems.item[0].text
				edtMappedPath.text = lvPaths.items.item[_index].subItems.item[1].text
			)
			else
			(
				edtSourcePath.text = edtMappedPath.text = ""
			)
		)

		------------------------------------------------
		--@event: lostFocus | Evento que salta al perder el foco del listado.
		--@control: System.Windows.Forms.ListView | lvPaths | Listado que pierde el foco.
		--@gets: event | events | Evento lanzado.
		------------------------------------------------
		on lvPaths lostFocus events do
		(
			updateRowsColor focus:false
		)

		------------------------------------------------
		--@event: gotFocus | Evento que salta al obtener el foco del listado.
		--@control: System.Windows.Forms.ListView | lvPaths | Listado que obtiene el foco.
		--@gets: event | events | Evento lanzado.
		------------------------------------------------
		on lvPaths gotFocus events do
		(
			updateRowsColor focus:true
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
			editCA = parent.editBackupNode.custAttributes[#overrideSourcePathsMappingInfo]
			initListView()
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
	--@struct: overrideSourcePathsMapping | Contiene todas las funciones de un override de OutputPath.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideSourcePathsMapping
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
		
		overrideInfo = ca_overrideSourcePathsMappingInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideSourcePathsMappingInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
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
			"(" + (this.infoNodeCA.sourcePaths.count as string) + ") mapping paths"
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
			_success = false
			
			if saveLogs then lb.log.add ("BACKUP process start") sender:("override." + (this.getSubType())) type:#info level:logLevel

			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideSourcePathsMappingInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				------------------------------------------------
				--este override es especial ya que no tiene que hacer un backup, sino que el restore hace el proceso de apply pero a la inversa.
				--por eso esta parte se deja vacía
				------------------------------------------------
				
				_success = true
			)--if
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)					
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup Node is not valid.")
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
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			DisableSceneRedraw()

			if saveLogs then lb.log.add ("RESTORE process start") sender:("override." + (this.getSubType())) type:#info level:logLevel
			
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(
				if backupNode.custAttributes[#overrideSourcePathsMappingInfo] != undefined then
				(
					------------------------------------------------
					--Se trata de un override especial en el que el restore no se hace a partir del CA de backup, sino haciendo el apply a la inversa.
					------------------------------------------------

					if lb.passManager.getNetworkRenderMode() then
					(
						if saveLogs then lb.log.add ("Network render, sources redirection restore started ") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)

						------------------------------------------------
						--redireccion de las texturas de los materiales de la escena

						_sceneMats = lb.materials.getSceneMaterials() --obtiene los materiales de la escena
						for i=this.infoNodeCA.sourcePaths.count to 1 by -1 do
							for _mat in _sceneMats do lb.materials.redirectMatBitmaps _mat (this.infoNodeCA.mappingPaths[i]) (this.infoNodeCA.sourcePaths[i])
						------------------------------------------------

						------------------------------------------------
						--redireccion de los mapas de las luces de la escena

						_sceneLights = lb.lights.getSceneLights ignoreLightSystems:false
						for i=this.infoNodeCA.sourcePaths.count to 1 by -1 do
							for _light in _sceneLights do lb.materials.redirectMatBitmaps _light (this.infoNodeCA.mappingPaths[i]) (this.infoNodeCA.sourcePaths[i])
						------------------------------------------------

						------------------------------------------------
						--redireccion de point caches y de transform caches

						for i=this.infoNodeCA.sourcePaths.count to 1 by -1 do
						(
							lb.cache.redirectPointCacheSources (this.infoNodeCA.mappingPaths[i]) (this.infoNodeCA.sourcePaths[i])
							lb.cache.redirectTransformCacheSources (this.infoNodeCA.mappingPaths[i]) (this.infoNodeCA.sourcePaths[i])
						)--for
						------------------------------------------------

						------------------------------------------------
						--redireccion de los mapas de los modificadores de la escena

						_sceneModifiers = lb.modifiers.getSceneModifiers()
						for i=this.infoNodeCA.sourcePaths.count to 1 by -1 do
							for _mod in _sceneModifiers do lb.materials.redirectMatBitmaps _mod (this.infoNodeCA.mappingPaths[i]) (this.infoNodeCA.sourcePaths[i])
						------------------------------------------------

						------------------------------------------------
						--redirección de los mr_proxies
						for i=1 to this.infoNodeCA.sourcePaths.count do
						(
							for o in Objects where classof o == mr_Proxy do
							(
								lb.geometry.redirectMrProxies o (this.infoNodeCA.mappingPaths[i]) (this.infoNodeCA.sourcePaths[i]) 
							)
						)

						------------------------------------------------
						--redireccion de los overrides. Como por ejemplo de materiales y de final gather.
						
						_parentContainer = this.getParentContainer() --primero hay que averiguar el contenedor de overrides del que cuelga

						if _parentContainer != undefined then
						(				
							_rootContainer = _parentContainer.getParent() --se necesita es el container inmedietamente superior, que será el contenedor de pases
							_rootContainerAllOverrides = lb.passManager.getAllSubcontainersOverrides _rootContainer --obtiene todos los overrides de forma recursiva

							--recorre los overrides llamando a su funcion de redireccion. En cada caso hará unas operaciones diferentes si es que la funcion redirect existe
							for _ov in _rootContainerAllOverrides do
								for i=this.infoNodeCA.sourcePaths.count to 1 by -1 do
									_ov.redirect (this.infoNodeCA.mappingPaths[i]) (this.infoNodeCA.sourcePaths[i])
						)
						else
						(
							if saveLogs then lb.log.add ("RESTORE process error. There is no parent container") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
							lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. There is not parent container.")
							_success = false
						)--if else

						------------------------------------------------
					)
					else
					(
						if saveLogs then lb.log.add ("Not network render, sources redirection restore not needed ") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)
					)

					_success = true
				)
				else
				(
					if saveLogs then lb.log.add ("Backup node with no custom attribute") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					_success = false
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("Backup node is not valid") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
				_success = false
			)
			
			if saveLogs then
			(
				if _success then lb.log.add ("RESTORE process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("RESTORE process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)
			
			EnableSceneRedraw()

			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			_success = false

			DisableSceneRedraw()

			if saveLogs then lb.log.add ("APPLY process start") sender:("override." + (this.getSubType())) type:#info level:logLevel

			if lb.passManager.getNetworkRenderMode() then
			(
				if saveLogs then lb.log.add ("Network render, sources redirection started ") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)
			
				------------------------------------------------
				--redireccion de las texturas de los materiales de la escena

				_sceneMats = lb.materials.getSceneMaterials() --obtiene los materiales de la escena

				for i=1 to this.infoNodeCA.sourcePaths.count do
					for _mat in _sceneMats do lb.materials.redirectMatBitmaps _mat (this.infoNodeCA.sourcePaths[i]) (this.infoNodeCA.mappingPaths[i])
				------------------------------------------------

				------------------------------------------------
				--redireccion de los mapas de las luces de la escena

				_sceneLights = lb.lights.getSceneLights ignoreLightSystems:false
				for i=this.infoNodeCA.sourcePaths.count to 1 by -1 do
					for _light in _sceneLights do lb.materials.redirectMatBitmaps _light (this.infoNodeCA.sourcePaths[i]) (this.infoNodeCA.mappingPaths[i])
				------------------------------------------------
						
				------------------------------------------------
				--redireccion de point caches y de transform caches

				for i=1 to this.infoNodeCA.sourcePaths.count do
				(
					lb.cache.redirectPointCacheSources (this.infoNodeCA.sourcePaths[i]) (this.infoNodeCA.mappingPaths[i])
					lb.cache.redirectTransformCacheSources (this.infoNodeCA.sourcePaths[i]) (this.infoNodeCA.mappingPaths[i])
				)--for
				------------------------------------------------

				------------------------------------------------
				--redireccion de los mapas de los modificadores de la escena

				_sceneModifiers = lb.modifiers.getSceneModifiers()
				for i=this.infoNodeCA.sourcePaths.count to 1 by -1 do
					for _mod in _sceneModifiers do lb.materials.redirectMatBitmaps _mod (this.infoNodeCA.sourcePaths[i]) (this.infoNodeCA.mappingPaths[i])
				------------------------------------------------

				------------------------------------------------
				--redirección de los mr_proxies
				for i=1 to this.infoNodeCA.sourcePaths.count do
				(
					for o in Objects where classof o == mr_Proxy do
					(
						lb.geometry.redirectMrProxies o (this.infoNodeCA.sourcePaths[i]) (this.infoNodeCA.mappingPaths[i])
						print o.filename
					)
				)

				------------------------------------------------
				--redireccion de los overrides. Como por ejemplo de materiales y de final gather.
				
				_parentContainer = this.getParentContainer() --primero hay que averiguar el contenedor de overrides del que cuelga

				if _parentContainer != undefined then
				(				
					_rootContainer = _parentContainer.getParent() --se necesita es el container inmedietamente superior, que será el contenedor de pases
					_rootContainerAllOverrides = lb.passManager.getAllSubcontainersOverrides _rootContainer --obtiene todos los overrides de forma recursiva

					--recorre los overrides llamando a su funcion de redireccion. En cada caso hará unas operaciones diferentes si es que la funcion redirect existe
					for _ov in _rootContainerAllOverrides do
						for i=1 to this.infoNodeCA.sourcePaths.count do
							_ov.redirect (this.infoNodeCA.sourcePaths[i]) (this.infoNodeCA.mappingPaths[i])
				)
				else
				(
					if saveLogs then lb.log.add ("APPLY process error. There is no parent container") sender:("override." + (this.getSubType())) type:#error level:(logLevel + 1)
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"APPLY process error. There is no parent container.")
					_success = false
				)--if else

				------------------------------------------------
			)
			else
			(
				if saveLogs then lb.log.add ("Not network render, sources redirection not needed ") sender:("override." + (this.getSubType())) type:#info level:(logLevel + 1)
			)

			_success = true
			
			if saveLogs then
			(
				if _success then lb.log.add ("APPLY process completed") sender:("override." + (this.getSubType())) type:#ok level:logLevel
				else lb.log.add ("APPLY process error") sender:("override." + (this.getSubType())) type:#error level:logLevel
			)

			EnableSceneRedraw()

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
				if this.editBackupNode.custAttributes[#overrideSourcePathsMappingInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideSourcePathsMappingInfo]) _prop))
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
						if this.editBackupNode.custAttributes[#overrideSourcePathsMappingInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideSourcePathsMappingInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideSourcePathsMappingInfo]) _prop (getProperty (this.infoNodeCA) _prop))
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
			
			_size = [400,250]
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
			this.infoNodeCA.sourcePaths = #("z:\\", "y:\\")
			this.infoNodeCA.mappingPaths = #("\\\\lbdata001\\z\\", "\\\\lbdata001\\y\\")
		),
		
		------------------------------------------------
		--@fn: undefined | upgrade | Actualiza la version del override
		--@opt: float | previousVersion | Versión en la que se encontraba previamente
		------------------------------------------------
		fn upgrade previousVersion:0.0 =
		(
			if previousVersion < 1.1 do
			(
				for i=1 to this.infoNodeCA.mappingPaths.count do
				(
					this.infoNodeCA.mappingPaths[i] = toLower this.infoNodeCA.mappingPaths[i]
					this.infoNodeCA.mappingPaths[i] = substituteString this.infoNodeCA.mappingPaths[i] "lbbackup2" "lbdata002"
					this.infoNodeCA.mappingPaths[i] = substituteString this.infoNodeCA.mappingPaths[i] "lbbackup" "lbdata001"
				)
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
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideSourcePathsMappingInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideSourcePathsMappingInfo]

					this.storeSceneValues()
				)--if

				--Rellenamos la variable de atajo del CA
				this.infoNodeCA = this.infoNode.custAttributes[#overrideSourcePathsMappingInfo]
				
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
		
	)--str_overrideSourcePathsMapping
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideSourcePathsMapping --añade el override al listado de overrides disponibles
	
	ok
)