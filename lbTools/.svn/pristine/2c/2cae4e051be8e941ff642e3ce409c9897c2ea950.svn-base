------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Tool Manager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta carga del resto de herramientas.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Tool Manager"
	(
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 400		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 400		--@var: minRollHeight | Alto mínimo de la herramienta.
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupbox grpOptions "" pos:[5,0] width:390 height:95
		
		label lblPreset "Preset:" pos:[10,12] width:75
		button btnDelete "" pos:[85,10] width:20 height:20 border:false tooltip:"Delete current preset" images:#(((lb.config.getIconsPath()) + "ramplayer_i.bmp"), undefined, 40, 6, 6, 6, 6, true) --@control: btnDelete | Boton para eliminar el preset actual.
		button btnAdd "" pos:[105,10] width:20 height:20 border:false tooltip:"Add new preset" images:#(((lb.config.getIconsPath()) + "AddPreset_16i.bmp"), undefined, 1, 1, 1, 1, 1, true) --@control: btnAdd | Boton para añadir un nuevo preset.
		button btnSave "" pos:[125,10] width:20 height:20 border:false tooltip:"Save current preset" images:#(((lb.config.getIconsPath()) + "ramplayer_i.bmp"), undefined, 40, 7, 7, 7, 7, true) --@control: btnSave | Boton para guardar el preset actual.
		dropdownlist ddlPreset "" pos:[145,10] width:245 --@control: ddlPreset | Lista desplegable con los presets disponibles.
		
		label lblOrder "Order by:" pos:[10,34] width:75
		dropdownlist ddlOrderBy "" pos:[145,32] width:245 --@control: ddlOrderBy | Lista desplegable con los tipos de ordenación para el listado de tools.
		
		label lblFilter "Filter:" pos:[10,56] width:75
		radiobuttons rdoFilter "" pos:[70,56] labels:#("and","or") default:2
		button btnFilter "" pos:[370,54] width:20 height:20 border:false tooltip:"Apply current filters" images:#(((lb.config.getIconsPath()) + "bip_mflgraph_i.bmp"), undefined, 40, 35, 35, 35, 35, true) --@control: btnFilter | Boton para aplicar los filtros actuales.
		edittext edtFilter "" pos:[143,54] width:225 --@control: edtFilter | Campo editable para los filtros de búsqueda de tools.
		
		label lblShow "Show:" pos:[10,78] width:75
		checkbox chkShowTools "Tools" pos:[85,76] checked:true --@control: chkShowTools | Checkbox para indicar que el listado tiene que mostrar las tools.
		checkbox chkShowScripts "Scripts" pos:[135,76] checked:true --@control: chkShowScripts | Checkbox para indicar que el listado tiene que mostrar los scripts.
		label lblVerticalSeparator01 "|" pos:[193,77] width:5 enabled:false
		checkbox chkShowHidden "Show hidden" pos:[205,76] --@control: chkShowHidden | Checkbox para indicar que el listado tiene que mostrar tambien las tools que se han marcado como ocultas.
		checkbox chkShowFavouritesOnly "Favourites Only" pos:[290,76] --@control: chkShowFavouritesOnly | Checkbox para indicar que el listado tiene que mostrar solo las tools y scripts favoritos.
		
		button btnReloadTools "" pos:[5,100] width:20 height:20 border:false tooltip:"Reload all tools/scripts to memory" images:#(((lb.config.getIconsPath()) + "UVWUnwrapModes_16i.bmp"), undefined, 27, 4, 4, 4, 4, true) --@control: btnReloadTools | Boton para recargar en memoria todas las herramientas y scripts.
		button btnCloseAll "Close All" pos:[296,100] width:60 height:20 border:true tooltip:"Close all opened tools" --@control: btnCloseAll | Boton para cerrar todas las herramientas abiertas.
		--button btnFavourites "" pos:[360,100] width:20 height:20 border:false tooltip:"Add/quit selected to favourites" images:#(((lb.config.getIconsPath()) + "UVWUnwrapView_16i.bmp"), undefined, 27, 15, 15, 15, 15, true) --@control: btnFavourites | Boton para añadir o quitar de favoritos las tools y los scripts seleccionadas.
		dotNetControl dgToolList "System.Windows.Forms.DataGridView" pos:[5,120] width:390 height:275 --@control: dgToolList | DataGridView para visualizar el listado de tools y scripts.
		
		timer tmrRefresh interval:1000 active:true

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
			
			lb.xml.setAttribute parent.cfgFile ("rollMain/options/ddlPreset") "value" (ddlPreset.selected)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options/ddlOrderBy") "value" (ddlOrderBy.selected)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options/rdoFilter") "value" (rdoFilter.state as string)			
			lb.xml.setAttribute parent.cfgFile ("rollMain/options/edtFilter") "value" (edtFilter.text)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options/chkShowTools") "value" (chkShowTools.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options/chkShowScripts") "value" (chkShowScripts.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options/chkShowHidden") "value" (chkShowHidden.checked as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options/chkShowFavouritesOnly") "value" (chkShowFavouritesOnly.checked as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta del documento de configuración de la misma.
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
				
			--carga el listado de presets
			ddlPreset.items = for p in parent.presets collect ((p.getNode "preset/name").getText())
			
			--estado de los controles
			--ddlPreset.selected = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/ddlPreset") "value")
			--ddlOrderBy.selected = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/ddlOrderBy") "value")
			rdoFilter.state = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/rdoFilter") "value") as integer
			edtFilter.text = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/edtFilter") "value")
			chkShowTools.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/chkShowTools") "value") != "false"
			chkShowScripts.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/chkShowScripts") "value") != "false"
			chkShowHidden.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/chkShowHidden") "value") == "true"
			chkShowFavouritesOnly.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/chkShowFavouritesOnly") "value") == "true"
 			
			if rdoFilter.state == 0 then rdoFilter.state = 2
			
 			--establece el preset actual. Si hay alguno almacenado en settings usa ese.
 			_currentPreset = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/ddlPreset") "value")
			_index = findItem ddlPreset.items _currentPreset
			if _index != 0 then ddlPreset.selection = _index
			if _index != 0 then parent.currentPreset = parent.presets[_index]
					
			--carga el listado de formas de ordenación
			_orderByOptions = #("name-asc", "name-desc", "category + name-asc", "category + name-desc", "type + name-asc", "type + name-desc")
			ddlOrderBy.items = _orderByOptions
			_currentOrder = (lb.xml.getAttribute parent.cfgFile ("rollMain/options/ddlOrderBy") "value")
			_index = findItem ddlOrderBy.items _currentOrder
			if _index != 0 then ddlOrderBy.selection = _index

			--aplica los valores de tamaño y posicion
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]		
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event | tick | Evento cada vez que el timer sobrepasa el periodo del intervalo.
		--@control: timer | tmrRefresh | Timer que se ejecuta.
		------------------------------------------------
		on tmrRefresh tick do
		(
			parent.refreshToolList()
		)

		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el preset de tools actual.
		--@control: dropdownlist | ddlPreset | Listado desplegable con los presets existentes.
		--@gets: integer | value | Indice del nuevo elemento seleccionado.
		------------------------------------------------
		on ddlPreset selected value do
		(
			setWaitCursor()
			parent.setCurrentPresetByIndex value --establece como actual el nuevo preset seleccionado
			parent.calculateToolList()			--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()				--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: selected | Evento que se lanza al cambiar el preset de tools actual.
		--@control: dropdownlist | ddlOrderBy | Listado desplegable con las opciones de ordenación.
		--@gets: integer | value | Indice del nuevo elemento de ordenacion seleccionado.
		------------------------------------------------
		on ddlOrderBy selected value do
		(
			setWaitCursor()
			parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()		--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar la opcion de filtrado seleccionada.
		--@control: radiobuttons | rdoFilter | Opciones de filtrado de tools.
		--@gets: integer | state | Indice del nuevo estado seleccionado.
		------------------------------------------------
		on rdoFilter changed state do
		(
			if edtFilter.text != "" then --solo actualiza el listado si hay filtros
			(
				setWaitCursor()
				parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
				parent.fillToolList()		--rellena el listado visible de tools
				setArrowCursor()
			)
		)
		
		------------------------------------------------
		--@event: entered | Evento que se lanza al cambiar los filtros por nombre de listado de tools.
		--@control: edittext | edtFilter | Texto con los filtros de nombre que usar en el listado de tools.
		--@gets: string | value | Filtros de listado de tools nuevos.
		------------------------------------------------
		on edtFilter entered value do
		(
			setWaitCursor()
			parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()		--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton de filtrar por nombre el listado de tools.
		--@control: button | btnFilter | Boton para aceptar los cambios en los filtros.
		------------------------------------------------
		on btnFilter pressed do
		(
			setWaitCursor()
			parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()		--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar la opcion de listar tools o no.
		--@control: checkbox | chkShowTools | Opcion de listar las tools o no.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkShowTools changed state do
		(
			setWaitCursor()
			--parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()	--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar la opcion de listar scripts o no.
		--@control: checkbox | chkShowScripts | Opcion de listar los scripts o no.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkShowScripts changed state do
		(
			setWaitCursor()
			--parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()	--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar la opcion de listar las tools ocultas o no.
		--@control: checkbox | chkShowHidden | Opcion de listar las tools ocultas o no.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkShowHidden changed state do
		(
			setWaitCursor()
			--parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()	--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar la opcion de listar solo los favoritos.
		--@control: checkbox | chkShowFavouritesOnly | Opcion de listar solo los favoritos.
		--@gets: boolean | state | Estado nuevo. TRUE pulsado, FALSE no pulsado.
		------------------------------------------------
		on chkShowFavouritesOnly changed state do
		(
			setWaitCursor()
			--parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()	--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton de recargar en memoria todas las tools y scripts.
		--@control: button | btnReloadTools | Boton para recargar en memoria todas las tools y scripts.
		------------------------------------------------
		on btnReloadTools pressed do
		(
			setWaitCursor()
			tmrRefresh.active = false
			parent.closeAllTools()	--cierra todas las herramientas abiertas
			lb.utilities.reloadScripts()	--recarga en memoria todas las tools y scripts	
			parent.calculateToolList()		--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()			--rellena el listado visible de tools
			tmrRefresh.active = true
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton de cerrar todas las herramientas excepto esta.
		--@control: button | btnCloseAll | Boton para cerrar todas las herramientas abiertas excepto esta.
		------------------------------------------------
		on btnCloseAll pressed do
		(
			setWaitCursor()
			parent.closeAllTools()	--cierra todas las herramientas abiertas
			parent.fillToolList()	--rellena el listado visible de tools
			setArrowCursor()
		)
		
		------------------------------------------------
		--@event: pressed | Elimina el preset actual.
		--@control: button | btnDelete | Boton para eliminar el preset actual.
		------------------------------------------------
		on btnDelete pressed do
		(
			setWaitCursor()
			_success = parent.removeCurrentPreset()
			if _success then
			(
				ddlPreset.items = for p in parent.presets collect ((p.getNode "preset/name").getText()) --actualiza el desplegable de presets
				if parent.presets.count != 0 then ddlPreset.selection = 1
				parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
				parent.fillToolList()		--rellena el listado visible de tools
			)
			setArrowCursor()
			
			if _success then messageBox "Current preset successfully removed."
			else messageBox "Process canceled or not completed (read only presets cannot be removed)."
		)

		------------------------------------------------
		--@event: pressed | Crea un nuevo presset.
		--@control: button | btnAdd | Boton para crear un nuevo presset.
		------------------------------------------------
		on btnAdd pressed do
		(
			setWaitCursor()
			_success = parent.duplicateCurrentPreset() --duplica el preset actual
			if _success then
			(
				ddlPreset.items = for p in parent.presets collect ((p.getNode "preset/name").getText()) --actualiza el desplegable de presets
				ddlPreset.selection = parent.presets.count
				parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
				parent.fillToolList()		--rellena el listado visible de tools
			)
			setArrowCursor()

			if _success then messageBox "New preset successfully created and saved."
			else messageBox "Process canceled or not completed."
		)

		------------------------------------------------
		--@event: pressed | Salva todos los cambios en el preset actual.
		--@control: button | btnSave | Boton para salvar los cambios en el presset actual.
		------------------------------------------------
		on btnSave pressed do
		(
			setWaitCursor()
			_success = parent.saveCurrentPreset()
			setArrowCursor()

			if _success then messageBox "Preset successfully saved."
			else messageBox "Process canceled or not completed (read only presets cannot be saved)."
		)

		------------------------------------------------
		--@event: CellMouseDoubleClick | Evento que se lanza al hacer doble click en una celda del listado.
		--@control: System.Windows.Forms.DataGridView | dgToolList | Listado de tools y scripts.
		--@gets: event: events | Evento de dotnet lanzado.
		------------------------------------------------
		on dgToolList CellMouseDoubleClick events do
		(
			_index = events.rowIndex + 1	--indice de la fila donde se ha hecho doble click
					
			parent.toggleToolState _index	--cierra/abre la herramienta que se ha pulsado o ejecuta el script que se ha pulsado
			parent.refreshToolList()			--rellena el listado visible de tools
		)
		
		------------------------------------------------
		--@event: MouseUp | Evento que se lanza al levantar el raton despues de hacer click o click derecho.
		--@control: System.Windows.Forms.DataGridView | dgToolList | Listado de tools y scripts.
		--@gets: event: events | Evento de dotnet lanzado.
		------------------------------------------------
		on dgToolList MouseUp events do
		(
			_button = events.button.ToString() --averigua si es boton izquierdo, derecho o central
				
			--en función del boton pulsado ha de realizar unas operaciones u otras
			case _button of
			(
				"Right": parent.toolListRightClick() --lanza el menu de boton derecho
			)--case			
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
				grpOptions.width = 390 + _increment.x
				ddlPreset.width = 245 + _increment.x
				ddlOrderBy.width = 245 + _increment.x
				edtFilter.width = 222 + _increment.x
				dgToolList.width = 390 + _increment.x
				if dgToolList.columns.count > 2 then dgToolList.columns.item[2].width = 190 + _increment.x
				
				btnFilter.pos.x = 370 + _increment.x
				chkShowHidden.pos.x = 200 + _increment.x
				chkShowFavouritesOnly.pos.x = 290 + _increment.x
				btnCloseAll.pos.x = 296 + _increment.x
				--btnFavourites.pos.x = 360 + _increment.x
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				dgToolList.height = 275 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)
			
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			parent.fillPresets()		--carga los presets
			loadSettings()				--carga los settings
			parent.initToolList()		--inicializa el listado de tools con las opciones por defecto
			parent.calculateToolList()	--rellena el listado de tools teniendo en cuenta las opciones elegidas
			parent.fillToolList()		--rellena el listado visible de tools
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
		
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: toolManager | Contiene la herramienta carga del resto de herramientas.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_toolManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool de gestion de tools",	--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		presets = #(),				--@var: presets | Array de presets de la harramienta procesados como arboles de nodos xml.
		currentPreset = undefined,	--@var: currentPreset | Preset activo.
		toolsList = #(),			--@var: toolsList | Array con las tools listadas en el momento actual, en el orden de muestra. Almacena un struct con la categoria de la tool y la tool en si.
		listedTools = #(),			--@var: listedTools | Array con las tools listadas en el momento actual, en el orden de muestra y solo las visibles
			
		dgSelBackColor = (dotNetClass "System.Drawing.Color").midnightblue,	-- fondo de items seleccionados
		dgSelForeColor = (dotNetClass "System.Drawing.Color").white,		-- texto de items seleccionados
		
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
		--@fn: undefined | setCurrentPresetByIndex | Establece un nuevo preset como el actual.
		--@gets: integer | thePresetIndex | Indice del preset que se tiene que colocar como actual.
		------------------------------------------------
		fn setCurrentPresetByIndex thePresetIndex =
		(
			this.currentPreset = this.presets[thePresetIndex]
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | initToolList | Inicializa el listado de tools con las opciones por defecto.
		------------------------------------------------
		fn initToolList =
		(
			_dg = this.rollMain.dgToolList
			
			_dg.rows.clear()
			_dg.columns.clear()
			
			_dg.allowUsertoaddRows = false
			_dg.allowUserToResizeRows = false
			_dg.allowUserToResizeColumns = true
			
			_dg.columnHeadersVisible = false	--para que las colunas tengan titulo
			_dg.rowheadersvisible = false		--para que las filas no tengan titulo
			
			_dg.readonly = true
			_dg.showCellTooltips = false
			
			_dg.selectionMode = (dotnetClass "System.Windows.Forms.DataGridViewSelectionMode").FullRowSelect
			
			--establece los colores por defecto del listado
			_dg.foreColor = (dotNetClass "System.Drawing.Color").lightgray
			_dg.backgroundcolor = (dotNetClass "System.Drawing.Color").fromargb 20 20 20
			_dg.rowsdefaultcellstyle.backcolor = (dotNetClass "System.Drawing.Color").gray
			_dg.gridColor = (dotNetClass "System.Drawing.Color").black
			
			--establece la fuente del listado
			_dg.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 8
			
			--crea las columnas
			_dg.columns.add "" "type"
			_dg.columns.add "" "category"
			_dg.columns.add "" "tool"
			_dg.columns.add "" "state"
			_dg.columns.add "" "favourite"
			
			--esstablece los anchos de columna por defecto
			_dg.columns.item[0].width = 18
			_dg.columns.item[1].width = 82
			_dg.columns.item[2].width = 190
			_dg.columns.item[3].width = 60
			_dg.columns.item[4].width = 20
		),
		
		------------------------------------------------
		--@fn: undefined | fillPresets | Lee los archivos de presets de la herramienta y almacena la información internamente.
		------------------------------------------------
		fn fillPresets =
		(
			--obtiene los archivos de presets
			_presetsPath = lb.config.getToolsIniPath() + ((filterString this.className "_")[1]) + "\\"
			_presetFiles = lb.io.getFilesFromSubFolders _presetsPath extension:".prst"
			sort _presetFiles
			print _presetFiles
			this.presets = #() --vacía el array de presets
			for pf in _presetFiles do append this.presets (lb.xml.load pf) --rellena el array de presets
			this.currentPreset = this.presets[1] --establece el primer preset como el actual
		),
		
		------------------------------------------------
		--@fn: undefined | openSelected | Abre las herramientas no abiertas y seleccionadas en el listado. Ejecuta los scripts seleccionados.
		------------------------------------------------
		fn openSelectedTools =
		(
			_selection = this.rollMain.dgToolList.selectedRows
			_selection = for i=1 to _selection.count collect _selection.item[i-1].index
				
			--recorre las herramientas seleccionadas
			for i=1 to _selection.count do
			(
				_index = _selection[i] --obtiene el indice del listado
				
				--obtiene la categoria y el nombre de la herramienta o script
				_category = (this.rollMain.dgToolList.item 1 _index).value
				_name = (this.rollMain.dgToolList.item 2 _index).value
				_type = if (this.rollMain.dgToolList.item 3 _index).value == "execute" then "script" else "tool"
				
				--indica por que tool empezar a buscar
				_toolIterationIndexStart = (_index + 1)
					
				_stop = false --flag de parada
				for j=_toolIterationIndexStart to this.listedTools.count where not _stop do
				(
					if (tolower (this.listedTools[j].category as string) == tolower _category) and this.listedTools[j].theTool.className == _name and this.listedTools[j].type == _type then
					(
						--si es tool y no esta abierta la abre. Si es script lo ejecuta
						case this.listedTools[j].type of
						(
							"tool": if not this.listedTools[j].theTool.isOpen() then this.listedTools[j].theTool.run()
							"script": this.listedTools[j].theTool.run()
						)--case
						
						_stop = true --para la búsqueda
					)--if
				)--for j
			)--for i
		),
		
		------------------------------------------------
		--@fn: undefined | closeAllTools | Cierra todas las tools listadas que estén abiertas.
		------------------------------------------------
		fn closeAllTools =
		(
			--recorre todas las herramientas excepto esta y las que estén abiertas las cierra
			for tl in this.toolsList where tl.type == "tool" and tl.theTool.isOpen() and tl.theTool.className != ((filterString this.className "_")[1]) do
			(
				tl.theTool.close()
			)--for
		),
		
		------------------------------------------------
		--@fn: undefined | openSelected | Abre las herramientas no abiertas y seleccionadas en el listado. Ejecuta los scripts seleccionados.
		------------------------------------------------
		fn closeSelectedTools =
		(
			_selection = this.rollMain.dgToolList.selectedRows
			_selection = for i=1 to _selection.count collect _selection.item[i-1].index
				
			--recorre las herramientas seleccionadas
			for i=1 to _selection.count do
			(
				_index = _selection[i] --obtiene el indice del listado
				
				--obtiene la categoria y el nombre de la herramienta o script
				_category = (this.rollMain.dgToolList.item 1 _index).value
				_name = (this.rollMain.dgToolList.item 2 _index).value
				_type = if (this.rollMain.dgToolList.item 3 _index).value == "execute" then "script" else "tool"
				
				--indica por que tool empezar a buscar
				_toolIterationIndexStart = (_index + 1)
					
				_stop = false --flag de parada
				for j=_toolIterationIndexStart to this.listedTools.count where not _stop do
				(
					if (tolower (this.listedTools[j].category as string) == tolower _category) and this.listedTools[j].theTool.className == _name and this.listedTools[j].type == "tool" then
					(
						if this.listedTools[j].theTool.className != ((filterString this.className "_")[1]) and this.listedTools[j].theTool.isOpen() then this.listedTools[j].theTool.close()
						_stop = true --para la búsqueda
					)--if
				)--for j
			)--for i
		),
		
		------------------------------------------------
		--@fn | toggleToolState | Abre/cierra la herramienta con el indice solicitado o ejecuta el script con el indice solicitado.
		--@gets: integer | index | Indice de la herramienta o script solicitada/o.
		------------------------------------------------
		fn toggleToolState index =
		(
			--si es la herramienta actual no hace nada, si no, hace el cambio o la ejecucion.
			if this.listedTools[index].theTool.className != ((filterString this.className "_")[1]) then
			(
				--hay que distinguir si es tool o script
				case this.listedTools[index].type of
				(
					"tool":
					(
						if this.listedTools[index].theTool.isOpen() then this.listedTools[index].theTool.close()
						else this.listedTools[index].theTool.run()
					)--tool
					
					"script":
					(
						this.listedTools[index].theTool.run()
					)--script
				)--case
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | hideSelectedTools | Oculta en el listado las tools/scripts seleccionados.
		--@opt: boolean | invert | false | Indica si en lugar de ocultar tiene que desocultar.
		--@opt: boolean | invertSelection | false | Indica si ocultar los seleccionados o los no seleccionados.
		------------------------------------------------
		fn hideSelectedTools invert:false invertSelection:false =
		(
			_selection = this.rollMain.dgToolList.selectedRows
			_selection = for i=1 to _selection.count collect _selection.item[i-1].index
			
			if invertSelection then _selection = for i=1 to this.rollMain.dgToolList.rows.count where findItem _selection (i-1) == 0 collect (i-1)
			
			--recorre las herramientas seleccionadas
			for i=1 to _selection.count do
			(
				_index = _selection[i] --obtiene el indice del listado
				
				--obtiene la categoria y el nombre de la herramienta o script
				_category = (this.rollMain.dgToolList.item 1 _index).value
				_name = (this.rollMain.dgToolList.item 2 _index).value
				_type = if (this.rollMain.dgToolList.item 3 _index).value == "execute" then "script" else "tool"
				
				--indica por que tool empezar a buscar
				_toolIterationIndexStart = (_index + 1)
					
				_stop = false --flag de parada
				for j=_toolIterationIndexStart to this.listedTools.count where not _stop do
				(
					if (tolower (this.listedTools[j].category as string) == tolower _category) and this.listedTools[j].theTool.className == _name and this.listedTools[j].type == _type then
					(
						this.listedTools[j].hidden = not invert --oculta o desoculta
						_stop = true --para la búsqueda
					)--if
				)--for j
			)--for i
		),
			
		------------------------------------------------
		--@fn: undefined | favouriteSelectedTools | Hace favoritas en el listado las tools/scripts seleccionados.
		--@opt: boolean | invert | false | Indica si en lugar de hacer favorito tiene que quitarlo.
		--@opt: boolean | invertSelection | false | Indica si hacer favoritos los seleccionados o los no seleccionados.
		------------------------------------------------
		fn favouriteSelectedTools invert:false invertSelection:false =
		(
			_selection = this.rollMain.dgToolList.selectedRows
			_selection = for i=1 to _selection.count collect _selection.item[i-1].index
			
			if invertSelection then _selection = for i=1 to this.rollMain.dgToolList.rows.count where findItem _selection (i-1) == 0 collect (i-1)
			
			--recorre las herramientas seleccionadas
			for i=1 to _selection.count do
			(
				_index = _selection[i] --obtiene el indice del listado
				
				--obtiene la categoria y el nombre de la herramienta o script
				_category = (this.rollMain.dgToolList.item 1 _index).value
				_name = (this.rollMain.dgToolList.item 2 _index).value
				_type = if (this.rollMain.dgToolList.item 3 _index).value == "execute" then "script" else "tool"
				
				--indica por que tool empezar a buscar
				_toolIterationIndexStart = (_index + 1)
					
				_stop = false --flag de parada
				for j=_toolIterationIndexStart to this.listedTools.count where not _stop do
				(
					if (tolower (this.listedTools[j].category as string) == tolower _category) and this.listedTools[j].theTool.className == _name and this.listedTools[j].type == _type then
					(
						this.listedTools[j].favourite = not invert --hace favorito o no
						_stop = true --para la búsqueda
					)--if
				)--for j
			)--for i
		),
		
		------------------------------------------------
		--@fn: undefined | unhideAllTools | Desoculta todas las tools listadas que estén ocultas.
		------------------------------------------------
		fn unhideAllTools =
		(
			--recorre todas las herramientas y las desoculta
			for i=1 to this.toolsList.count do this.toolsList[i].hidden = false
		),
		
		------------------------------------------------
		--@fn: undefined | unhideAllTools | Desoculta todas las tools listadas que estén ocultas.
		------------------------------------------------
		fn unfavouriteAllTools =
		(
			--recorre todas las herramientas y las desoculta
			for i=1 to this.toolsList.count do this.toolsList[i].favourite = false
		),
		
		------------------------------------------------
		--@fn: undefined | toolLostRightClick | Abre el menu de boton derecho del listado de tools.
		------------------------------------------------
		fn toolListRightClick =
		(
			--menu de boton derecho para el listado de tools
			rcmenu _toolListRCmenu
			(
				local this --variable para almacenar la tool que contiene el menu
				
				------------------------------------------------
				--MENU ELEMENTS
				------------------------------------------------
				
				menuItem openSelected "Open/Execute selected"
				menuItem closeSelected "Close selected"
				separator sep01
				menuItem hideSelected "Hide selected"
				menuItem hideUnselected "Hide unselected"
				menuItem unhideSelected "Unhide selected"
				menuItem unhideAll "Unhide all"
				separator sep02
				menuItem favouriteSelected "Favourite selected"
				menuItem unfavouriteSelected "Unfavourite selected"
				menuItem unfavouriteAll "Unfavourite all"
				
				------------------------------------------------
				--EVENTOS
				------------------------------------------------
				
				------------------------------------------------
				--abre/ejecuta las herramientas/scripts seleccionados
				on openSelected picked do
				(
					this.openSelectedTools()
					this.fillToolList()
				)
				
				------------------------------------------------
				--cierra las herramientas seleccionadas
				on closeSelected picked do
				(
					this.closeSelectedTools()
					this.fillToolList()
				)
				
				------------------------------------------------
				--oculta las herramientas/scripts seleccionados
				on hideSelected picked do
				(
					this.hideSelectedTools()
					this.fillToolList()
				)
				
				------------------------------------------------
				--oculta las herramientas/scripts no seleccionados
				on hideUnselected picked do
				(
					this.hideSelectedTools invertSelection:true
					this.fillToolList()
				)
				
				------------------------------------------------
				--desoculta las herramientas/scripts seleccionados
				on unhideSelected picked do
				(
					this.hideSelectedTools invert:true
					this.fillToolList()
				)
				
				------------------------------------------------
				--desoculta todas las herramientas/scripts
				on unhideAll picked do
				(
					this.unhideAllTools()
					this.fillToolList()
				)
				
				------------------------------------------------
				--hace favoritas las herramientas/scripts seleccionados
				on favouriteSelected picked do
				(
					this.favouriteSelectedTools()
					this.fillToolList()
				)
				
				------------------------------------------------
				--quita de favoritos las herramientas/scripts seleccionados
				on unfavouriteSelected picked do
				(
					this.favouriteSelectedTools invert:true
					this.fillToolList()
				)
				
				------------------------------------------------
				--quita de favoritos todas las herramientas/scripts
				on unfavouriteAll picked do
				(
					this.unfavouriteAllTools()
					this.fillToolList()
				)
			)
			
			popUpMenu _toolListRCmenu --ejecuta el menu
			_toolListRCmenu.this = this
		),
		
		------------------------------------------------
		--@fn: undefined | calculateToolList | Rellena el listado de herramientas en funcion de las opciones marcadas en el interface.
		------------------------------------------------
		fn calculateToolList =
		(
			this.toolsList = #() --vacía el array de tools/scripts actual			
			_prst = this.currentPreset --preset actual
			
			--obtiene las categorias de tools que permite mostrar ese preset
			_categories = _prst.getNodes "preset/categories/category"
			_categories = for ct in _categories collect ct.getText()
			
			-------------------------------------------------------------
			--struct temporal para trabajar de forma interna en la función
			--almacena la categoria de la tool y la tool en si misma
			struct _tool
			(
				category = "",			--nombre de la categoria
				theTool = undefined,	--herramienta/script
				
				type = "tool",			--indica si es una herramienta o un script
				hidden = false,			--indica si se muestra en el listado o no
				favourite = false		--indica si la herramienta esta marcada como favorita
			)
			-------------------------------------------------------------
			
			_tools = #() --array para almacenar las tools a mostrar
			
			if _categories.count != 0 then --si el preset tiene categorías o todas las categorías, lista sus tools
			(
				--recopila del preset los nombres de las herramientas que por defecto vayan ocultas
				_hiddenTools = for hd in (_prst.getNodes "preset/hidden/tool") collect hd.getText()
				_hiddenScripts = for hd in (_prst.getNodes "preset/hidden/script") collect hd.getText()
				
				--recopila del preset los nombres de las herramientas que por defecto sean favoritas
				_favTools = for fv in (_prst.getNodes "preset/favourites/tool") collect fv.getText()
				_favScripts = for fv in (_prst.getNodes "preset/favourites/script") collect fv.getText()
				
				if _categories.count == 1 and _categories[1] == "#all" then --si hay que obtener todas las categorias
					_categories = lb.getToolCategories() --obtiene las categorias existentes
				
				for ct in _categories do --recorre las categorias y sus tools
				(
					_catTools = lb.getToolsByCategory ct --obtiene las tools de esa categoria
					for tl in _catTools do --los almacena con sus opciones leidas del preset
					(
						_newTool = _tool category:ct theTool:tl hidden:(findItem _hiddenTools tl.className != 0) favourite:(findItem _favTools tl.className != 0)
						append _tools _newTool
					)
					
					_catScripts = lb.getScriptsByCategory ct --obtiene los scripts de esa categoria
					for sc in _catScripts do --los almacena con sus opciones leidas del preset
					(
						_newScript = _tool category:ct theTool:sc type:"script" hidden:(findItem _hiddenScripts sc.className != 0) favourite:(findItem _favScripts sc.className != 0)
						append _tools _newScript
					)
				)--for
				
				--si hay filtros de nombre de tool/script, recorre las tools almacenadas y elimina las que no cumplan los filtros
				if this.rollMain.edtFilter.text != "" then
				(
					--obtiene los filtros de nombre
					_filters = filterString this.rollMain.edtFilter.text " ,;"
					
					--si es AND o OR tiene que filtrar de manra diferente
					case this.rollMain.rdoFilter.state of
					(
						1:--AND
						(
							--recorre las tools y si no encuentra alguno de los filtros la elimina del listado
							for i=_tools.count to 1 by -1 do
							(
								_stop = false
								for fltr in _filters where not _stop and (findString _tools[i].theTool.className fltr) == undefined do
								(
									deleteItem _tools i
									_stop = true
								)--for
							)--for
						)--AND
						
						2:--OR
						(
							--recorre las tools y si no encuentra ninguno de los filtros la elimina del listado
							for i=_tools.count to 1 by -1 do
							(
								_found = false
								for fltr in _filters where not _found and (findString _tools[i].theTool.className fltr) != undefined do
									_found = true
								
								if not _found do deleteItem _tools i
							)--for
						)--OR
					)--case
				)--if
			)--if 
			
			-------------------------------------------------------------
			--funcion interna temporal para comparar tools por nombre
			fn _compareToolsByName tl1 tl2 invert:false keepType:false =
			(
				_toolNames = #(tl1.theTool.className, tl2.theTool.className) --crea un array con los nombres de las dos tools
				sort _toolNames --lo ordena por nombre
				
				--mira cual de los dos nombres queda primero para decidir el orden
				if not keepType then
				(
					if tl1.theTool.className == tl2.theTool.className then 1
					else if tl1.theTool.className == _toolNames[1] then (if not invert then -1 else 1) else (if not invert then 1 else -1)
				)
				else
				(
					if tl1.type == "tool" and tl2.type == "script" then -1
					else if tl1.type == "script" and tl2.type == "tool" then 1
					else if tl1.type == tl2.type then
					(
						if tl1.theTool.className == tl2.theTool.className then 1
						else if tl1.theTool.className == _toolNames[1] then (if not invert then -1 else 1) else (if not invert then 1 else -1)
					)						
				)
			)
			-------------------------------------------------------------
			
			-------------------------------------------------------------
			--funcion interna temporal para comparar tools por su categoria
			fn _compareToolsByCategory tl1 tl2 invert:false =
			(				
				if tl1.category == tl2.category then
				(
					_toolNames = #(tl1.theTool.className, tl2.theTool.className) --crea un array con los nombres de las dos tools --AQUI. esta mal, hay que hacerlo con category
					sort _toolNames --lo ordena por nombre
					
					--mira cual de los dos nombres queda primero para decidir el orden
					if tl1.theTool.className == tl2.theTool.className then 1
					else if tl1.theTool.className == _toolNames[1] then (if not invert then -1 else 1) else (if not invert then 1 else -1)
				)
				else 1
			)
			-------------------------------------------------------------
			
			--ordena el listado de tools en funcion de la opcion de orden elegida
			case this.rollMain.ddlOrderBy.selected of
			(
				"name-asc": qsort _tools _compareToolsByName
				"name-desc": qsort _tools _compareToolsByName invert:true
				"category + name-asc": qsort _tools _compareToolsByCategory
				"category + name-desc": qsort _tools _compareToolsByCategory invert:true
				"type + name-asc": qsort _tools _compareToolsByName keepType:true
				"type + name-desc": qsort _tools _compareToolsByName invert:true keepType:true
			)--case
			
			this.toolsList = _tools --sobrescribe el listado de tools actual con el recien calculado
		),		
		
		------------------------------------------------
		--@fn: undefined | fillToolList | Rellena el listado de herramientas visible en el interface.
		------------------------------------------------
		fn fillToolList =
		(
			--hay que almacenar el numero de tools y los indices seleccionados para poder repintar la seleccion tras el dibujado
			_toolCountBckp = this.rollMain.dgToolList.rows.count --almacena el numero de tools representado antes de dibujar
			_toolSelectionBckp = for i=1 to this.rollMain.dgToolList.rows.count where (this.rollMain.dgToolList.item 1 (i-1)).selected collect i --almacena los indices seleccionados
			-----------------------------------------------------------
				
			this.rollMain.dgToolList.rows.clear() --vacía el listado antes de rellenarlo de nuevo
			
			_bgColor = (dotNetClass "System.Drawing.Color").fromargb 50 50 50 --color del fondo de las celdas
			_textColor = (dotNetClass "System.Drawing.Color").lightgray --color de texto de las celdas
			_typeToolColor = (dotNetClass "System.Drawing.Color").fromargb 50 50 50 --color para la celda de tipo herramienta
			_typeScriptColor = (dotNetClass "System.Drawing.Color").fromargb 70 70 70 --color para la celda de tipo script
			
			_hiddenToolColor = (dotNetClass "System.Drawing.Color").fromargb 50 50 70 --color para las tools ocultas
			_hiddenScriptColor = (dotNetClass "System.Drawing.Color").fromargb 70 70 90 --color para los scripts ocultos

			_openedColor = (dotNetClass "System.Drawing.Color").fromargb 80 225 115 --color para la celda de herramienta abierta
			_closedColor = (dotNetClass "System.Drawing.Color").fromargb 225 150 100 --color para la celda de herramienta cerrada
			_executeColor = (dotNetClass "System.Drawing.Color").fromargb 0 110 220 --color para la celda de ejecutar script
			
			_openedClosedTextColor = (dotNetClass "System.Drawing.Color").fromargb 0 0 0 --color del texto de la celda de herramienta abierta
			
			_favouriteColor = (dotNetClass "System.Drawing.Color").fromargb 255 255 50 --color del texto de la celda de herramienta favorita
			
			this.listedTools = #() --vacia el listado de tools visibles	
				
			--recorre las tools rellenando el listado en el grid
			_index = 0
			for i=1 to this.toolsList.count do
			(
				_show = true --flag para indicar si la tool se tiene que mostrar o no.
				
				if not this.rollMain.chkShowTools.checked then _show = (this.toolsList[i].type != "tool")
				if _show and not this.rollMain.chkShowScripts.checked then _show = (this.toolsList[i].type != "script")
				if _show and not this.rollMain.chkShowHidden.checked then _show = not this.toolsList[i].hidden --si está oculta no se muestra
				if _show and this.rollMain.chkShowFavouritesOnly.checked then _show = this.toolsList[i].favourite --si no es favorita no se muestra
					
				if _show then --si no hay ningun motivo para no mostrarla, muestra la herramienta
				(
					append (this.listedTools) (this.toolsList[i]) --añade la tool al listado de visibles
					
					_index += 1 --incrementa el contador de filas añadidas
					
					--crea una nueva fila----------------------------------------------------------------------------------------------------
					_row = (dotnetobject "System.Windows.Forms.DataGridViewRow")
					_row.height = 18
					_row.defaultCellStyle.BackColor = _bgColor
					---------------------------------------------------------------------------------------------------------------------------------
					
					--añade la fila al listado-----------------------------------------------------------------------------------------------
					this.rollMain.dgToolList.rows.add _row
					---------------------------------------------------------------------------------------------------------------------------------
					
					--rellena la fila-------------------------------------------------------------------------------------------------------------
					(this.rollMain.dgToolList.item 1 (_index-1)).value = (tolower (this.toolsList[i].category as string))
					(this.rollMain.dgToolList.item 2 (_index-1)).value = this.toolsList[i].theTool.className
					if this.toolsList[i].type == "script" then (this.rollMain.dgToolList.item 3 (_index-1)).value = "execute"
					else ((this.rollMain.dgToolList.item 3 (_index-1)).value = if this.toolsList[i].theTool.opened then "opened" else "closed")
					if this.toolsList[i].favourite then (this.rollMain.dgToolList.item 4 (_index-1)).value = "+"
					--establece colores personalizados para los estados y tipos de algunas tools -----------------
					
					--establece el color segun el tipo: tool o script----------
					_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"

					if this.toolsList[i].type == "tool" then
						_cellStyle.backColor = if not this.toolsList[i].hidden then _typeToolColor else _hiddenToolColor

					if this.toolsList[i].type == "script" then
						_cellStyle.backColor = if not this.toolsList[i].hidden then _typeScriptColor else _hiddenScriptColor

					(this.rollMain.dgToolList.item 0 (_index-1)).style = _cellStyle
					(this.rollMain.dgToolList.item 1 (_index-1)).style = _cellStyle
					(this.rollMain.dgToolList.item 2 (_index-1)).style = _cellStyle
					----------------------------------------------------------------------------
					
					--establece el color segun sea favorita o no--------------	
					_cellStyle2 = dotnetObject "system.windows.forms.dataGridViewCellStyle"
					_cellStyle2.backColor = if this.toolsList[i].favourite then _favouriteColor else _cellStyle.backColor --si es favorita, se usa otro color
					if this.toolsList[i].favourite then _cellStyle2.foreColor = _openedClosedTextColor
					_alignment = (dotnetClass "System.Windows.Forms.DataGridViewContentAlignment")
					_cellStyle2.Alignment = _alignment.MiddleCenter
					(this.rollMain.dgToolList.item 4 (_index-1)).style = _cellStyle2
					----------------------------------------------------------------------------
					
					--establece  el color de las herramientas abiertas-----
					_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"					
					if this.toolsList[i].type == "script" then _cellStyle.backColor = _executeColor
					else (_cellStyle.backColor = if this.toolsList[i].theTool.opened then _openedColor else _closedColor)
					_cellStyle.foreColor = _openedClosedTextColor
					(this.rollMain.dgToolList.item 3 (_index-1)).style = _cellStyle
					----------------------------------------------------------------------------
						
					---------------------------------------------------------------------------------------------------------------------------------
				)--if
			)--for
			
			--si hay el  mismo numero de tools listadas que antes intenta mantener la selección inicial
			if _toolCountBckp == this.rollMain.dgToolList.rows.count then
			(
				for i=1 to this.rollMain.dgToolList.rows.count do
				(
					if findItem _toolSelectionBckp i != 0 then (this.rollMain.dgToolList.item 1 (i-1)).selected = true
					else (this.rollMain.dgToolList.item 1 (i-1)).selected = false
				)
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | refreshToolList | Actualza el estado del listado de herramientas visible en el interface.
		------------------------------------------------
		fn refreshToolList =
		(
			_openedColor = (dotNetClass "System.Drawing.Color").fromargb 80 225 115 --color para la celda de herramienta abierta
			_closedColor = (dotNetClass "System.Drawing.Color").fromargb 225 150 100 --color para la celda de herramienta cerrada
			_openedClosedTextColor = (dotNetClass "System.Drawing.Color").fromargb 0 0 0 --color del texto de la celda de herramienta 

			for i=1 to this.listedTools.count where this.listedTools[i].type == "tool" do
			(
				_state = ((this.rollMain.dgToolList.item 3 (i-1)).value) == "opened"
				_realState = (this.listedTools[i].theTool.isOpen())
				if _state != _realState then
				(
					(this.rollMain.dgToolList.item 3 (i-1)).value = if _realState then "opened" else "closed"
					_cellStyle = dotnetObject "system.windows.forms.dataGridViewCellStyle"					
					_cellStyle.backColor = if _realState then _openedColor else _closedColor
					_cellStyle.foreColor = _openedClosedTextColor
					(this.rollMain.dgToolList.item 3 (i-1)).style = _cellStyle
				)--if				
			)--for
		),

		------------------------------------------------
		--@fn: boolean | saveCurrentPreset | Sobrescribe el preset actual y devuelve TRUE si lo consigue y FALSE si no.
		------------------------------------------------
		fn saveCurrentPreset =
		(
			_success = false 

			_currentPressetFile = this.currentPreset.getPath()
			_presetName = (this.currentPreset.getNode "preset/name").getText()
			_presetReadOnly = (this.currentPreset.getNode "preset/readOnly").getText() == "true"

			--solo lo salva si el preset es editable y tiene archivo asociado
			if not _presetReadOnly and _currentPressetFile != undefined then
			(
				--establece las categorias
				_categories = this.currentPreset.getNode "preset/categories"
				_categories.removeChildren()
				_category = _categories.newChild "category"
				_category.setText "#all"

				--vacia los favoritos
				_favs = this.currentPreset.getNode "preset/favourites"
				_favs.removeChildren()
				_newFav = _favs.newChild "aux"
				_newFav.setText "empty"

				--vacia los ocultos
				_hidden = this.currentPreset.getNode "preset/hidden"
				_hidden.removeChildren()
				_newHid = _hidden.newChild "aux"
				_newHid.setText "empty"

				--recorre el listado almacenando los favoritos y los ocultos actuales
				for i=1 to this.toolsList.count do
				(
					_type = this.toolsList[i].type
					_fav = this.toolsList[i].favourite
					_hid = this.toolsList[i].hidden
					
					if _fav then
					(
						_newFav = _favs.newChild _type
						_newFav.setText this.toolsList[i].theTool.className
					)

					if _hid then
					(
						_newHid = _hidden.newChild _type
						_newHid.setText this.toolsList[i].theTool.className
					)
				)--for

				this.currentPreset.save() --salva el preset

				_success = true
			)--if
						
			_success
		),

		------------------------------------------------
		--@fn: boolean | duplicateCurrentPreset | Devuelve TRUE si consigue crear el nuevo preset, FALSE si no.
		------------------------------------------------
		fn duplicateCurrentPreset =
		(
			_success = false

			------------------------------------------------
			--rollout para elegir el nombre del nuevo preset
			global _newPresetName = undefined

			rollout _rollNewPresetName "New preset name"
			(
				edittext edtNewPresetName "" pos:[5,5] width:290

				on edtNewPresetName entered newText do
				(
					_process = true
					_allowedChars = "1234567890qwertyuiopasdfghjklzxcvbnm-_"; _allowedChars = for i=1 to _allowedChars.count collect _allowedChars[i]
					for i=1 to newText.count where _process and findItem _allowedChars (tolower newText[i]) == 0 do _process = false
					
					if _process then (_newPresetName = newText; destroyDialog _rollNewPresetName)
					else (edtNewPresetName.text = ""; messageBox "Some name symbols are not allowed. You must use leters and/or numbers without spaces"; setFocus edtNewPresetName)
				)

				on _rollNewPresetName open do setFocus edtNewPresetName
			)

			_size = [300,25]
			_pos = ((getDialogPos this.rollMain) + [this.rollMain.width, 130]/2) - (_size/2)
			--_pos = ((getDialogPos this.rollMain) + [this.rollMain.width, this.rollMain.height]/2) - (_size/2)
			createDialog _rollNewPresetName pos:_pos width:_size[1] height:_size[2] modal:true

			_rollNewPresetName = undefined
			------------------------------------------------

			if _newPresetName != undefined and _newPresetName != "" then
			(
				--crea el nuevo preset, lo renombra y lo salva
				_newPreset = copy this.currentPreset
				(_newPreset.getNode "preset/name").setText _newPresetName
				(_newPreset.getNode "preset/readOnly").setText "false"
				_newPreset.setPath ((getFileNamePath (_newPreset.getPath())) + _newPresetName + ".prst")
				_newPreset.save()

				this.currentPreset = _newPreset --hace que el nuevo preset sea el actual
				append this.presets _newPreset --almacena el nuevo preset				

				_success = true
			)--if

			_success
		),
		
		------------------------------------------------
		--@fn: boolean | removeCurrentPreset | Devuelve TRUE si consigue eliminar el preset actual, FALSE si no.
		------------------------------------------------
		fn removeCurrentPreset =
		(
			_success = false

			_currentPressetFile = this.currentPreset.getPath()			
			_presetReadOnly = (this.currentPreset.getNode "preset/readOnly").getText() == "true"

			--solo deja eliminarlo si no es readOnly y nos pregunta antes si estamos seguros
			if not _presetReadOnly and (queryBox "You are going to remove current preset. This operation has no undo. Do you want to continue?") then
			(
				if deleteFile _currentPressetFile then
				(
					deleteItem this.presets this.rollMain.ddlPreset.selection
					this.currentPreset = if this.presets.count != 0 then this.presets[1] else undefined

					_success = true
				)--if
			)--if

			_success
		),

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
			this.opened = true --indica que la herramienta está abierta
			this.createInterface() --crea el interface.			
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
			--this.run()
		)
		
	)--tl_toolManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	--try(lb.toolManager.close())catch()
	tl_toolManager() --crea la herramienta
)