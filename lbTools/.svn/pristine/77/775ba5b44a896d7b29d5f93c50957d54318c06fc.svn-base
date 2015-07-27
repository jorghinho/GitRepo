--------------------------
-- TAREAS PENDIENTES
-------------------------
-- Geenrar soluciones de edición de forma independiente, evitando tener que depender de un archivo externo.

------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	struct str_solution
	(
		root = undefined,
		uiObj = undefined,
		
		animSolutions = #(),
		skinSolutions = #(),

		animSolutionIndex = 0,
		skinSolutionIndex = 0,
		
		---------------------------------------------------------------------------
		--inicializa el gridview pasado por parametro
		---------------------------------------------------------------------------		
		fn isAvailableSolutions type =
		(
			_index = if type == #anim then 3 else 4
				
			this.uiObj.cells.item[_index].value
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollRigSolutionManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Rig Solution Manager - C| WARRIOR TANK GENERATOR |D" width:620 height:600
	(
		------------------------------------------------------------------------------------------------
		-- COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
	
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		--colors------------------------------------------------------------------------------
		local dgBackColor = (dotNetClass "System.Drawing.Color").beige						-- fondo
		local dgForeColor = (dotNetClass "System.Drawing.Color").white						-- texto
		local dgSelBackColor = (dotNetClass "System.Drawing.Color").midnightblue			-- fondo de items seleccionados
		local dgSelForeColor = (dotNetClass "System.Drawing.Color").white					-- texto de items seleccionados
		local dgDisabledColor = (dotNetClass "System.Drawing.Color").gray					-- color deshabilitado de la seleccion
		local dgEnabledColor = (dotNetClass "System.Drawing.Color").fromARGB 51 153 255		-- color habilitado de la seleccion
		---------------------------------------------------------------------------------------
		
		local sceneSolutions = #() 															-- @var : sceneSolutions | Obtenemos los roots de las soluciones de edition para rellenar las filas.
		local currentSolutions = #() 														-- @var : sceneSolutions | Obtenemos los roots de las soluciones de edition para rellenar las filas.	
		local solutionFilter = #animEdit 													-- FILTRO DE PESTAÑAS DE TIPO DE SOLUCION, RELLENAR EN EL EVENTO
		
		local recursiveEventAvoid = false
		------------------------------------------------------------------------------------------------
		-- CONTROLS
		------------------------------------------------------------------------------------------------
		
		checkbox chkAllSolAnim "All" pos:[220,10] width:40 height:15 checked:true
		checkbox chkAllSolSkin "All" pos:[260,10] width:40 height:15 checked:true
		
		label lblChrName "Chr_" pos:[10,235] width:25 height:25 
		edittext edtChrName "" pos:[32,233] width:141 height:15 text:"chrName" bold:true enabled:false
		
		button btnCreate "Create" pos:[5,255] width:141 height:25
		button btnDelete "Delete" pos:[147,255] width:141  height:25
		
		label lblCreateProcess "Process" pos:[310,240] width:100 height:20 
		progressbar pbCreateProcess pos:[360,235] width:255 height:20 color:green
		
		label lblCreateTemplates "Templates" pos:[310,260] width:100 height:20 
		dropDownList ddlTemplates "" pos:[360,255] width:255 height:20 items:#("Anim - FKIKSpine", "Layout - Simple")
		
		label lblVersion "v 2.0" pos:[585,5] width:100 height:20 
		
		groupBox lblOptions "Options" pos:[5,290] width:610 height:40
		
		checkbox chkAutoRename "" pos:[10,305] checked:true
		label lblAutoRename "Auto Rename" pos:[35,305]
		
		label lblAutoCreateTwistSystem "Auto Create Twist System" pos:[140,305]
		checkbox chkAutoTwistSystem "" pos:[115,305] checked:true
		
		label lblAutoExtraBones "Auto Create Extra Bones" pos:[310,305]
		checkbox chkAutoExtraBones "" pos:[285,305] checked:true
		
		label lblSeparator "_________________________________________________________________________________________________________________" pos:[5,340] width:610 enabled:false

		subrollout subRollEditionRig pos:[5,340] width:285 height:170 
		subrollout subRollFacialMask pos:[310,340] width:305 height:255
		
		dotNetControl dgSolutions "System.Windows.Forms.DataGridView" pos:[5,25] width:285 height:200
		dotNetControl tbSolutionTypes "DevExpress.XtraTab.XtraTabControl" pos:[5,5] width:215 height:20
		dotNetControl dgAnim "System.Windows.Forms.DataGridView" pos:[310,25] width:150 height:200
		dotNetControl dgSkin "System.Windows.Forms.DataGridView" pos:[465,25] width:150 height:200
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		
		------------------------------------------------
		--@fn: integer | compareSolution | Compara dos soluciones por nombre. Devuelve 0 si tienen el mismo nombre, -1 si el nombre del primero va antes que el del segundo, 1 si el nombre del segundo va antes. 
		--@gets: node | sol1 | Primer solución a comparar.
		--@gets: node | sol2 | Segunda solución a comparar.
		------------------------------------------------
		fn compareSolution sol1 sol2 =
		(
			_result = 0
			
			_solNameOrder = #("root", "spine", "arm", "leg")
			_solSideOrder = #(lb.nc.NC_locationMiddle, lb.nc.NC_locationLeft, lb.nc.NC_locationRight)
			
			_index1 = findItem _solNameOrder sol1.root.solutionInfo.solutionCategory
			_index2 = findItem _solNameOrder sol2.root.solutionInfo.solutionCategory
			
			_side1 = findItem _solSideOrder sol1.root.solutionInfo.solutionSide
			_side2 = findItem _solSideOrder sol2.root.solutionInfo.solutionSide
			
			if _index1 > _index2 then
				_result = 1
			else if _index1 < _index2 then
				_result = -1
			else
			(
				if _side1 > _side2 then
					_result = 1
				else if _side1 < _side2 then
					_result = -1
				else
					_result = 0
			)				
						
			_result 
		)
		
		------------------------------------------------
		--@fn: integer | sortSceneSolutions | Compara dos soluciones por nombre. Devuelve 0 si tienen el mismo nombre, -1 si el nombre del primero va antes que el del segundo, 1 si el nombre del segundo va antes. 
		--@gets: struct | sceneSolutions | Primer solución a comparar.
		--@gets: node | sol2 | Segunda solución a comparar.
		------------------------------------------------
		fn sortSceneSolutions sceneSolutions =
		(
			qsort sceneSolutions compareSolution
			
			sceneSolutions
		)	
		
		
		fn getSceneSolutions =
		(
			_solutionsRoots = lb.rig.solutions.getSceneSolutionRoots()
			_sceneSolutions = #()

			for _root in _solutionsRoots do 
			(
				_row = (dotnetobject "System.Windows.Forms.DataGridViewRow") 
				_row.height = 25
				
				_sceneSolution = str_solution()
				_sceneSolution.root = _root
				_sceneSolution.uiObj = _row
				_sceneSolution.animSolutions = (lb.rig.solutions.getSolutions category:(_root.solutionInfo.solutionCategory as name) subcategory:#anim)
				_sceneSolution.skinSolutions = (lb.rig.solutions.getSolutions category:(_root.solutionInfo.solutionCategory as name) subcategory:#skin)
				
				if _sceneSolution.animSolutions.count > 0 then _sceneSolution.animSolutionIndex = 1
				if _sceneSolution.skinSolutions.count > 0 then _sceneSolution.skinSolutionIndex = 1
				
				
				append _sceneSolutions _sceneSolution
			)
			
			_sceneSolutions = sortSceneSolutions _sceneSolutions
			
			_sceneSolutions
		)
		
		---------------------------------------------------------------------------
		--inicializa el gridview pasado por parametro
		---------------------------------------------------------------------------
		fn initUI =
		(	
			_dataGridViews = #(dgSolutions, dgAnim, dgSkin)
			
			for i = 1 to _dataGridViews.count do
			(
				_dataGridViews[i].AdvancedColumnHeadersBorderStyle.all = (dotnetclass "System.Windows.Forms.DataGridViewAdvancedCellBorderStyle").outset
				_dataGridViews[i].columnHeadersHeightSizeMode = (dotNetClass "System.Windows.Forms.dataGridViewColumnHeadersHeightSizeMode").disableResizing
				_dataGridViews[i].allowUsertoaddRows = false
				_dataGridViews[i].allowUserToResizeRows = false
				_dataGridViews[i].allowUserToResizeColumns = true
				_dataGridViews[i].AllowUserToOrderColumns = false
				
				_dataGridViews[i].columnHeadersVisible = true									--para que las columnas no tengan titulo
				_dataGridViews[i].rowheadersvisible = false									--para que las filas no tengan titulo
				
				_dataGridViews[i].foreColor = (dotNetClass "System.Drawing.Color").black
				_dataGridViews[i].backgroundcolor = dgForeColor								-- color del fondo
				_dataGridViews[i].rowsdefaultcellstyle.backcolor = dgForeColor					-- color por defecto de las celdas
				_dataGridViews[i].GridColor = dgForeColor
				
				_dataGridViews[i].font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5					
				
				_dataGridViews[i].readonly = false
				_dataGridViews[i].showCellTooltips = false
				
				_dataGridViews[i].selectionMode = (dotnetClass "System.Windows.Forms.DataGridViewSelectionMode").FullRowSelect
				
				_dataGridViews[i].multiSelect = false
			)
			
			-- Propiedades especificas del dgView de Edition Rig
			_chrName = (dotnetobject "System.Windows.Forms.DataGridViewTextBoxColumn")
			_chrName.width = 100		
			_chrName.ReadOnly = true
			_chrName.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_chrName.HeaderText = "ChrName"
			dgSolutions.columns.add _chrName

			_nameSolColumn = (dotnetobject "System.Windows.Forms.DataGridViewTextBoxColumn")
			_nameSolColumn.width = 60		
			_nameSolColumn.ReadOnly = true
			_nameSolColumn.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_nameSolColumn.HeaderText = "Solution"
			dgSolutions.columns.add _nameSolColumn
			
			_sideColumn = (dotnetobject "System.Windows.Forms.DataGridViewTextBoxColumn")
			_sideColumn.width = 40		
			_sideColumn.ReadOnly = true
			_sideColumn.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_sideColumn.HeaderText = "Side"
			dgSolutions.columns.add _sideColumn
			
			_animColumn = (dotnetobject "System.Windows.Forms.DataGridViewCheckBoxColumn")
			_animColumn.width = 40		
			_animColumn.ReadOnly = false
			_animColumn.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_animColumn.HeaderText = "Anim"
			dgSolutions.columns.add _animColumn
			
			_skinColumn = (dotnetobject "System.Windows.Forms.DataGridViewCheckBoxColumn")
			_skinColumn.width = 40		
			_skinColumn.ReadOnly = false
			_skinColumn.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_skinColumn.HeaderText = "Skin"
			dgSolutions.columns.add _skinColumn
			
			-- Propiedades especificas del dgView de Anim Rig
			_animColumn = (dotnetobject "System.Windows.Forms.DataGridViewTextBoxColumn")
			_animColumn.width = 147			
			_animColumn.ReadOnly = true
			_animColumn.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_animColumn.HeaderText = "Anim Rig"
			dgAnim.columns.add _animColumn
			
			-- Propiedades especificas del dgView de Skin Rig
			_skinColumn = (dotnetobject "System.Windows.Forms.DataGridViewTextBoxColumn")
			_skinColumn.width = 147			
			_skinColumn.ReadOnly = true
			_skinColumn.sortmode = (dotnetclass "System.Windows.Forms.DataGridViewColumnSortMode").notSortable
			_skinColumn.HeaderText = "Skin Rig"
			dgSkin.columns.add _skinColumn

			--	Tabs
			tbSolutionTypes.backColor = (dotnetclass "system.drawing.color").fromArgb 186 186 186
			tbSolutionTypes.paintstylename = "PropertyView"
			tbSolutionTypes.borderStyle = (dotnetclass "DevExpress.XtraEditors.Controls.BorderStyles").noBorder
			tbSolutionTypes.TabPageWidth = 50
			
			tbSolutionTypes.tabPages.clear()
			tbSolutionTypes.tabPages.add "Edition"
			tbSolutionTypes.tabPages.add "Anim"
			tbSolutionTypes.tabPages.add "Skin"
		)
		
		---------------------------------------------------------------------------------------------------------------
		--rellena el grid con la información de los
		---------------------------------------------------------------------------------------------------------------
		fn fillSceneSolutionsUI =
		(
			dgSolutions.rows.clear()
			
			_cont = 0
			
			currentSolutions = #()
			
			for i = 1 to sceneSolutions.count where (sceneSolutions[i].root.solutionInfo.solutionSubCategory as name) == solutionFilter do 
			(
				append currentSolutions sceneSolutions[i]
				dgSolutions.rows.add sceneSolutions[i].uiObj
				
				_filterName = filterString sceneSolutions[i].root.solutionInfo.params.root.node.name "_"
				
				(dgSolutions.item 0 (_cont)).value = toUpper _filterName[2]
					
				(dgSolutions.item 1 (_cont)).value = toUpper sceneSolutions[i].root.solutionInfo.solutionCategory
				(dgSolutions.item 2 (_cont)).value = toUpper sceneSolutions[i].root.solutionInfo.solutionSide
 				

				if solutionFilter == #animEdit then
				(	
					dgSolutions.columns.item[3].visible = dgSolutions.columns.item[4].visible = true	
					chkAllSolAnim.visible = true
					chkAllSolSkin.visible = true
					
					(dgSolutions.item 3 (_cont)).value = true
					(dgSolutions.item 4 (_cont)).value = true
				)
				
				_cont += 1
			)
			
			if dgSolutions.rows.count != 0 then (dgSolutions.item 0 0).selected = true
		)

		---------------------------------------------------------------------------------------------------------------
		-- rellena el grid con la información de los currRenderLayers
		---------------------------------------------------------------------------------------------------------------
		fn fillAvailableSolutions type:#all =
		(
			_currentSolutions = for _sol in currentSolutions where _sol.root.solutionInfo.solutionSubCategory == (solutionFilter as string) collect _sol

		
			if _currentSolutions.count > 0 and dgSolutions.selectedRows.count == 1 and solutionFilter == #animEdit then
			(			
				_index = dgSolutions.selectedRows.item[0].index + 1

				_dgControls = if type == #all then #(dgAnim, dgSkin) else if type == #anim then #(dgAnim) else #(dgSkin)
				
				for _dg in _dgControls do
				(
					_solutions =  if _dg == dgAnim then currentSolutions[_index].animSolutions else currentSolutions[_index].skinSolutions
					
					_selectedIndex = if _dg == dgAnim then currentSolutions[_index].animSolutionIndex else currentSolutions[_index].skinSolutionIndex
					
					_dg.rows.clear()
					
					for i = 1 to _solutions.count do
					(
						_row = (dotnetobject "System.Windows.Forms.DataGridViewRow") 
						_row.height = 25
						_dg.rows.add _row
						
						(_dg.item 0 (i-1)).value = toUpper _solutions[i].solName
							
						if 	i == _selectedIndex then _row.selected = true
					)
				)
			)
		)	
		
		fn refreshUI forceAll:false fillCurrentSols:false =
		(
			if not recursiveEventAvoid then
			(
				recursiveEventAvoid = true
				
				sceneSolutions = getSceneSolutions()
			
				if forceAll then fillSceneSolutionsUI()
					
				fillAvailableSolutions()
				
				recursiveEventAvoid = false
			)
			
		)
		
		fn updateUI =
		(
			if not recursiveEventAvoid then
			(
				recursiveEventAvoid = true
				
-- 				sceneSolutions = getSceneSolutions()
		
				_currentSolutions = for _sol in currentSolutions where _sol.root.solutionInfo.solutionSubCategory == (solutionFilter as string) collect _sol
				
				if not (_currentSolutions.count > 0 and dgSolutions.selectedRows.count == 1 and solutionFilter == #animEdit) then
				(
					dgAnim.rows.clear()
					dgSkin.rows.clear()
					dgAnim.backgroundcolor = dgDisabledColor
					dgSkin.backgroundcolor = dgDisabledColor
					
					btnCreate.enabled = false
					btnDelete.enabled = true
					
					dgSolutions.columns.item[3].visible = dgSolutions.columns.item[4].visible = false	
					chkAllSolAnim.visible = false
					chkAllSolSkin.visible = false
					dgSolutions.multiSelect = true
				)
				else
				(
					dgAnim.backgroundcolor = dgForeColor
					dgSkin.backgroundcolor = dgForeColor
					btnCreate.enabled = true
					chkAllSolAnim.checked = true
					btnDelete.enabled = false
					chkAllSolSkin.checked = true
					
					dgSolutions.columns.item[3].visible = dgSolutions.columns.item[4].visible = true	
					chkAllSolAnim.visible = true
					chkAllSolSkin.visible = true
					dgSolutions.multiSelect = false
				)

				_ast = (lb.asset.getSceneAssets())[1]
				
				if _ast != undefined then edtChrName.text = _ast.name
				pbCreateProcess.value = 0
				
				recursiveEventAvoid = false
			)
		)
		
		------------------------------------------------
		--@fn: integer | fillTemplates | Rellena el nombre de los templates predefinidos ya.
		------------------------------------------------
		fn setTemplates nameTemplate =
		(
			case nameTemplate of
			(
				-- Preset de anim.
				"Anim - FKIKSpine":
				(
-- 					-- Seleccionamos la solución del root simple.
					if dgSolutions.rows.count > 0 then
					(
						dgSolutions.rows.item[1].selected = true
						dgAnim.rows.item[0].Cells.item[0].Selected = true
	-- 					
	-- 					-- Seleccionamos la solución de la spine fkSpine
						dgSolutions.rows.item[2].selected = true
						dgAnim.rows.item[2].Cells.item[0].Selected = true
						
						-- Seleccionamos la solución de los brazos
						dgSolutions.rows.item[3].selected = true
						dgAnim.rows.item[0].Cells.item[0].Selected = true
						
						dgSolutions.rows.item[4].selected = true
						dgAnim.rows.item[0].Cells.item[0].Selected = true
						
						-- Seleccionamos la solución de las piernas
						dgSolutions.rows.item[5].selected = true
						dgAnim.rows.item[0].Cells.item[0].Selected = true
						
						dgSolutions.rows.item[6].selected = true
						dgAnim.rows.item[0].Cells.item[0].Selected = true
						
						dgSolutions.rows.item[0].selected = true
						
						-- Marcamos todas las opciones de las columna
						for _sol in currentSolutions do _sol.uiObj.cells.item[3].value = true
						for _sol in currentSolutions do _sol.uiObj.cells.item[4].value = true
					)
				)

				-- Preset de layout.
				"Layout - Simple":
				(
					if dgSolutions.rows.count > 0 then
					(
						-- Seleccionamos la solución del root simple.
						dgSolutions.rows.item[1].selected = true
						dgAnim.rows.item[1].Cells.item[0].Selected = true
						
						-- Seleccionamos la solución de la spine fkSpine
						dgSolutions.rows.item[2].selected = true
						dgAnim.rows.item[0].Cells.item[0].Selected = true
						
						-- Seleccionamos la solución de los brazos
						dgSolutions.rows.item[3].selected = true
						dgAnim.rows.item[1].Cells.item[0].Selected = true
						
						dgSolutions.rows.item[4].selected = true
						dgAnim.rows.item[1].Cells.item[0].Selected = true
						
						-- Seleccionamos la solución de las piernas
						dgSolutions.rows.item[5].selected = true
						dgAnim.rows.item[1].Cells.item[0].Selected = true
						
						dgSolutions.rows.item[6].selected = true
						dgAnim.rows.item[1].Cells.item[0].Selected = true
						
						dgSolutions.rows.item[0].selected = true
						
						-- Marcamos  todas las opciones solo de la columna de anim.
						for _sol in currentSolutions do _sol.uiObj.cells.item[3].value = true
						for _sol in currentSolutions do _sol.uiObj.cells.item[4].value = false

					)
				)				
			)
			
			
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
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			callbacks.addScript #filePostOpen "lb.rigSolutionManager.rollmain.refreshUI forceAll:true; lb.rigSolutionManager.rollmain.updateUI()" id:#tl_rigSolutionManager		
			callbacks.addScript #systemPostReset "lb.rigSolutionManager.rollmain.refreshUI forceAll:true; lb.rigSolutionManager.rollmain.updateUI()" id:#tl_rigSolutionManager

		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			callbacks.removeScripts id:#tl_rigSolutionManager
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile (rollMainDef.name + "/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile (rollMainDef.name + "/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile (rollMainDef.name + "/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile (rollMainDef.name + "/size") "height" (rollMainDef.height as string)
			
			--almacena pestaña seleccionada
			lb.xml.setAttribute parent.cfgFile (rollMainDef.name + "/tbSolutionTypes/selectedTab") "text" (rollMainDef.tbSolutionTypes.SelectedTabPage.Text)
				
			for i = 1 to rollMainDef.dgSolutions.rows.count do
			(
				_solName = (((rollMainDef.dgSolutions.item 1 (i-1)).value) as string)
				_solSide = (((rollMainDef.dgSolutions.item 2 (i-1)).value) as string)
				_createAnim = (((rollMainDef.dgSolutions.item 3 (i-1)).value) as string)
				_createSkin = (((rollMainDef.dgSolutions.item 4 (i-1)).value) as string)
				
				lb.xml.setAttribute parent.cfgFile (rollMainDef.name + "/dgSolutions/edition/" + _solName + "_" + _solSide) "anim" _createAnim 		
				lb.xml.setAttribute parent.cfgFile (rollMainDef.name + "/dgSolutions/edition/" + _solName + "_" + _solSide) "skin" _createSkin 		
			)		
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile (rollMainDef.name + "/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile (rollMainDef.name + "/pos") "y") as integer
				
			if _posX < 0 then _posX = 0
			
			setDialogPos rollMainDef [_posX,_posY]
			
			-- Carga el tab selecionado.
			_selTabPageName = (lb.xml.getAttribute parent.cfgFile (rollMainDef.name + "/tbSolutionTypes/selectedTab") "text")
			_selTabPage = undefined
			for i=1 to rollMainDef.tbSolutionTypes.TabPages.Count where rollMainDef.tbSolutionTypes.TabPages.item[i-1].text == _selTabPageName do
				_selTabPage = rollMainDef.tbSolutionTypes.TabPages.item[i-1]
			if _selTabPage != undefined then rollMainDef.tbSolutionTypes.SelectedTabPage = _selTabPage
				
			-- Cargado de checkBox seleccionados.
			for i = 1 to rollMainDef.dgSolutions.rows.count do
			(
				_solName = (((rollMainDef.dgSolutions.item 1 (i-1)).value) as string)
				_solSide = (((rollMainDef.dgSolutions.item 2 (i-1)).value) as string)

				_createAnim = (lb.xml.getAttribute parent.cfgFile (rollMainDef.name + "/dgSolutions/edition/" + _solName + "_" + _solSide) "anim") == "true" 		
				_createSkin = (lb.xml.getAttribute parent.cfgFile (rollMainDef.name + "/dgSolutions/edition/" + _solName + "_" + _solSide) "skin") == "true" 		
				
				((rollMainDef.dgSolutions.item 3 (i-1)).value) = _createAnim
				((rollMainDef.dgSolutions.item 4 (i-1)).value) = _createSkin
			)
		)
		
		on dgSolutions CellMouseUp events do
		(
			dgSolutions.endEdit()
		)
		 
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------		
		--@event: changed | 
		--@gets: boolean | events | 
		--@control: checkButton | tbSolutionTypes | 
		-----------------------------------------------
		on tbSolutionTypes selectedPageChanged events do
		(
			case events.page.text of
			(
				"Edition": solutionFilter = #animEdit
				"Anim": solutionFilter = #Anim
				"Skin": solutionFilter = #Skin	
			)
			
			refreshUI forceAll:true
			updateUI()
		)
		
		------------------------------------------------
		--@event: changed |
		--@gets: boolean | events | 
		--@control: checkButton | dgSolutions  |
		-----------------------------------------------
		on dgSolutions selectionChanged events do
		(
			refreshUI()
			updateUI()			
		)
		
		------------------------------------------------
		--@event: changed |
		--@gets: boolean | events | 
		--@control: checkButton | dgAnim  |
		-----------------------------------------------
		on dgAnim selectionChanged events do
		(
			if dgSolutions.selectedRows.count != 0 and dgAnim.selectedRows.count != 0 then
			(
				_selectedSolution = currentSolutions[dgSolutions.selectedRows.item[0].index + 1]
				_selectedSolution.animSolutionIndex = (dgAnim.selectedRows.item[0].index + 1)
			)
		)
		
		------------------------------------------------
		--@event: changed |
		--@gets: boolean | events | 
		--@control: checkButton | chkAllSolAnim  |
		-----------------------------------------------
		on chkAllSolAnim changed state do
		(
			if chkAllSolAnim.checked then 
				for _sol in currentSolutions do _sol.uiObj.cells.item[3].value = true
			else
				for _sol in currentSolutions do _sol.uiObj.cells.item[3].value = false
		)
		
		------------------------------------------------
		--@event: changed | Evento para borrar las soluciones
		--@gets: boolean | state | Activa o desactiva todas las opciones para crear las soluciones.
		--@control: checkButton | chkAllSolSkin | Activa o desactiva todas las opciones para crear las soluciones.
		------------------------------------------------
		on chkAllSolSkin changed state do
		(
			if chkAllSolSkin.checked then
				for _sol in currentSolutions do _sol.uiObj.cells.item[4].value = true
			else
				for _sol in currentSolutions do _sol.uiObj.cells.item[4].value = false
		)		
		
		------------------------------------------------
		--@event: pressed | Evento para borrar las soluciones
		--@control: button | btnCreate | Botón para crear las soluciones
		------------------------------------------------	
		on btnCreate pressed do 
		(
			disableSceneRedraw()
			SuspendEditing()
			
			_bckpCP = getCommandPanelTaskMode()
			setCommandPanelTaskMode #create 
			
			pbCreateProcess.value = 0
			_skinSol = false
			
			for i = 1 to currentSolutions.count do
			(
				if (currentSolutions[i].isAvailableSolutions #anim) then
				(
					_solution = (currentSolutions[i].animSolutions[currentSolutions[i].animSolutionIndex])
					
					_solution.create currentSolutions[i].root side:(currentSolutions[i].root.solutionInfo.solutionside)
				)
				
				if (currentSolutions[i].isAvailableSolutions #skin) then
				(
					_skinSol = true
					
					if currentSolutions[i].skinSolutions.count > 0 then
					(
						_solution = (currentSolutions[i].skinSolutions[currentSolutions[i].skinSolutionIndex])
						_solution.create currentSolutions[i].root side:(currentSolutions[i].root.solutionInfo.solutionside)							
					)
					
					if chkAutoTwistSystem.checked then
					(
						--Creación de los twist en relación al hueso creado de las piernas.
						if _solution.solName == "stdLeg" then
						(
							--En esta parte detecta si ya existen las soluciones twist. 
							_thighTwistL = lb.rig.solutions.getSceneSolutionRoots category:"thighTwist" side:lb.nc.NC_locationLeft
							_calfTwistL = lb.rig.solutions.getSceneSolutionRoots category:"calfTwist" side:lb.nc.NC_locationLeft
							_thighTwistR = lb.rig.solutions.getSceneSolutionRoots category:"thighTwist" side:lb.nc.NC_locationRight
							_calfTwistR = lb.rig.solutions.getSceneSolutionRoots category:"calfTwist" side:lb.nc.NC_locationRight
							
							_thighL = lb.rig.getSkinNode lb.nc.NC_ANIM_thigh side:lb.nc.NC_locationLeft
							_calfL = lb.rig.getSkinNode lb.nc.NC_ANIM_calf side:lb.nc.NC_locationLeft
							_thighR = lb.rig.getSkinNode lb.nc.NC_ANIM_thigh side:lb.nc.NC_locationRight
							_calfR = lb.rig.getSkinNode lb.nc.NC_ANIM_calf side:lb.nc.NC_locationRight
							
							_twistSol = (lb.rig.solutions.getSolutions category:#twist subCAtegory:#skin)[1]
							
							--Crea los twist siempre que exista el hueso al que va referido  y si no existen.
							if _thighL[1] != undefined then
							(
								if _thighTwistL[1] == undefined then
									_twistSol.create  _thighL[1] side:lb.nc.NC_locationLeft location:#upper numTwist:3
							)
							
							if _calfL[1] != undefined then
							(
								if _calfTwistL[1] == undefined then
									_twistSol.create _calfL[1] side:lb.nc.NC_locationLeft location:#lower numTwist:3
							)
							
							if _thighR[1] != undefined then
							(
								if _thighTwistR[1] == undefined then
									_twistSol.create _thighR[1] side:lb.nc.NC_locationRight location:#upper numTwist:3
							)
							
							if _calfR[1] != undefined then
							(
								if _calfTwistR[1] == undefined then
									_twistSol.create _calfR[1] side:lb.nc.NC_locationRight location:#lower numTwist:3
							)
						)
						

						--Creación de los twist en relación al hueso creado de las manos.
						if _solution.solName == "stdArm" then
						(
							--En esta parte detecta si ya existen las soluciones twist. 
							_upperarmTwistL = lb.rig.solutions.getSceneSolutionRoots category:"upperarmTwist" side:lb.nc.NC_locationLeft
							_forearmTwistL = lb.rig.solutions.getSceneSolutionRoots category:"forearmTwist" side:lb.nc.NC_locationLeft
							_upperarmTwistR = lb.rig.solutions.getSceneSolutionRoots category:"upperarmTwist" side:lb.nc.NC_locationRight
							_forearmTwistR = lb.rig.solutions.getSceneSolutionRoots category:"forearmTwist" side:lb.nc.NC_locationRight
							
							_upperarmL = lb.rig.getSkinNode lb.nc.NC_ANIM_upperarm side:lb.nc.NC_locationLeft
							_forearmL = lb.rig.getSkinNode lb.nc.NC_ANIM_forearm side:lb.nc.NC_locationLeft
							_upperarmR = lb.rig.getSkinNode lb.nc.NC_ANIM_upperarm side:lb.nc.NC_locationRight
							_forearmR = lb.rig.getSkinNode lb.nc.NC_ANIM_forearm side:lb.nc.NC_locationRight
							
							_twistSol = (lb.rig.solutions.getSolutions category:#twist subCAtegory:#skin)[1]
							
							--Crea los twist siempre que exista el hueso al que va referido  y si no existen.
							if _upperarmL[1] != undefined then
							(
								if _upperarmTwistL[1] == undefined then
									_twistSol.create _upperarmL[1] side:lb.nc.NC_locationLeft location:#upper numTwist:3
								
							)
							
							if _forearmL[1] != undefined then
							(
								if _forearmTwistL[1] == undefined then
									_twistSol.create _forearmL[1] side:lb.nc.NC_locationLeft location:#lower numTwist:3
							)
							
							if _upperarmR[1] != undefined then
							(
								if _upperarmTwistR[1] == undefined then
									_twistSol.create _upperarmR[1] side:lb.nc.NC_locationRight location:#upper numTwist:3	
								
							)
							
							if _forearmR[1] != undefined then
							(
								if _forearmTwistR[1] == undefined then
									_twistSol.create _forearmR[1] side:lb.nc.NC_locationRight location:#lower numTwist:3
							)

								
						)
					)

					
				)

				pbCreateProcess.value = i*100/currentSolutions.count
			)-- for
			
			if chkAutoExtraBones.checked then
				if _skinSol then
				(
					-- Generación de partes extras de skin.
					lb.rig.auxPart.createClavicle lb.nc.NC_locationLeft
					lb.rig.auxPart.createClavicle lb.nc.NC_locationRight
					
					lb.rig.auxPart.createShoulder lb.nc.NC_locationLeft
					lb.rig.auxPart.createShoulder lb.nc.NC_locationRight
					
					lb.rig.auxPart.createElbow	lb.nc.NC_locationLeft
					lb.rig.auxPart.createElbow	lb.nc.NC_locationRight
					
					lb.rig.auxPart.createFinger lb.nc.NC_locationLeft
					lb.rig.auxPart.createFinger lb.nc.NC_locationRight
					
					lb.rig.auxPart.createKnee lb.nc.NC_locationLeft
					lb.rig.auxPart.createKnee lb.nc.NC_locationRight
					
					lb.rig.auxPart.createToes lb.nc.NC_locationLeft
					lb.rig.auxPart.createToes lb.nc.NC_locationRight
					
					lb.rig.auxPart.createPelvis lb.nc.NC_locationLeft
					lb.rig.auxPart.createPelvis lb.nc.NC_locationRight
					
					lb.rig.auxPart.createDorsal lb.nc.NC_locationLeft
					lb.rig.auxPart.createDorsal lb.nc.NC_locationRight
					
					lb.rig.auxPart.createFingerAux lb.nc.NC_locationLeft
					lb.rig.auxPart.createFingerAux lb.nc.NC_locationRight
				)
			
			refreshUI()
			updateUI()
			
			-- Renombramos el asset entero con el nombre que le hayamos asignado.
			_assets = lb.asset.getSceneAssets()
			
			_ast = undefined
			
			for _a in _assets do
				if _a.name != "chrName" then
					_ast = _a
					
			if _ast != undefined then 
			(
				_name = if not chkAutoRename.checked then edtChrName.text else _ast.name
				
				lb.asset.renameAsset _ast _name

				_ast = (lb.asset.getSceneAssets())[1]

				_astAnimNodes = lb.asset.getAssetAnimNodes _ast lb.nc.NC_classAnim
				
				-- Renombramos los objectSets de las piezas de anim.	
				for o in _astAnimNodes where lb.objectSets.hasObjectSets o do
				(
					_newObjSets = #()
					
					for objSet in o.objectSets.names do
					(
						_filterObjSetName = filterString objSet "_"
						
						_newFilterObjSetName = _filterObjSetName[1] + "_" + _name + "_" + _filterObjSetName[3] + "_" +  _filterObjSetName[4] + "_" +  _filterObjSetName[5]
						
						append _newObjSets _newFilterObjSetName
					)
					
					o.objectSets.names = _newObjSets
				)
			)
					
			_ast = (lb.asset.getSceneAssets())[1]
			
			-- Conectamos las piezas con dynConnect y colapsamos la conexión
			for o in _ast.nodes where lb.dynConnect.hasDynConnectInfo o do
			(		
				o.dynConnectInfo.connect()
			)
				
			_nodesToHide = lb.asset.getAssetNodesByType _ast lb.nc.NC_classAnim flags:#(lb.nc.NC_hiddenFlag)
			_nodesToHide.isHidden = true
			
			gc()
			
			setCommandPanelTaskMode	_bckpCP
				
			enableSceneRedraw()
			ResumeEditing()
		)
		
		------------------------------------------------
		--@event: pressed | Evento para borrar las soluciones
		--@control: button | btnDelete | Botón para borrar las soluciones
		------------------------------------------------	
		on btnDelete pressed do 
		(
			SuspendEditing()
			
			_bckpCP = getCommandPanelTaskMode()
			setCommandPanelTaskMode #create
			
			_base = (lb.rig.solutions.getBaseNode merge:false)
			_ast = undefined
			
			if _base != undefined then _ast = (lb.asset.getAssetsFromNodes #(_base))[1]
			
			if _ast != undefined then
			(				
				lb.asset.setSkinConnection _ast false
			
				-- DEsconetamos las piezas con dynConnect y colapsamos la conexión
-- 				for o in _ast.nodes where (isValidNode o and (lb.dynConnect.hasDynConnectInfo o)) do
-- 					o.dynConnectInfo.disconnect()
			)
			
			-- Borrado de soluciones selecionadas.
			for i = 1 to dgSolutions.selectedRows.count do
			(
				_sceneSolution = currentSolutions[dgSolutions.selectedRows.item[i - 1].index + 1]

				_sceneSolution.root.solutionInfo.delete()
				
				pbCreateProcess.value = i*100/dgSolutions.selectedRows.count
			)
			
				
			if _ast != undefined then
			(		
				-- Conectamos las piezas con dynConnect y colapsamos la conexión
				for o in _ast.nodes where (isValidNode o and (lb.dynConnect.hasDynConnectInfo o)) do
					o.dynConnectInfo.connect()
					
					
				_nodesToHide = lb.asset.getAssetNodesByType _ast lb.nc.NC_classAnim flags:#(lb.nc.NC_hiddenFlag)
				_nodesToHide.isHidden = true		
			)		
			
			setCommandPanelTaskMode	_bckpCP
			ResumeEditing()
			redrawViews()
			
			refreshUI forceAll:true
			updateUI()
		)
		
		on chkAutoRename changed value do
		(
			if value then 
				edtChrName.enabled = false
			else
				edtChrName.enabled = true	
		)
		
		on ddlTemplates selected t do
		(
			setTemplates ddlTemplates.items[t]
				


		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			--inicializa el listado de propiedades y lo rellena con las que proceda
			initUI()
			refreshUI forceAll: true
			setTemplates ddlTemplates.items[1]
			updateUI()
			
			loadSettings()
			createSceneEvents() --crea los callbacks
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
	
	
	rollout rollEditionRig "Animation Edit Rig Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--@control | controlName | Controles para la gestión del EditionRig
		groupBox grpEditionRig "Anim Edition Rig" pos:[8,8] width:255 height:60
		button btnLoadEditionRig "Load Anim Edit Rig" pos:[20,30] width:110 height:24
		button btnDeleteEditionRig "Delete Anim Edit" pos:[140,30] width:110 height:24
		
		groupBox grpSveLoadOptions "Save/Load Options" pos:[8,75] width:255 height:60
		button btnSaveEditionRig "Save Anim Edit Data" pos:[20,97] width:110 height:24
		button btnLoadEditionRigData "Load Anim Edit Data" pos:[140,97] width:110 height:24
		
		------------------------------------------------------------------------------------------------
		-- FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@fn: undefined | DeleteEditionRig | borrar el asset del edition rig, sacando un mensaje para confirmar si o no.
		------------------------------------------------
		fn deleteEditionRig =
		(
			_assets = lb.asset.getSceneAssets()
			_success = false
			_baseAnimEdit = lb.rig.solutions.getBaseNode type:#animEdit
			_animEditAst = undefined
			
			--Obtiene las piezas del EditionRig y manda un mensaje preguntando si quieres borrar o no.
			if _baseAnimEdit != undefined then
				_animEditAst = (lb.asset.getAssetsFromNodes #(_baseAnimEdit))[1]
				
			if _AnimEditAst != undefined do
			(
				_partAnimEdit = _AnimEditAst.AnimEditNodesAll
				
				delete _partAnimEdit
				
				_chrLayer = (LayerManager.getLayerFromName "chr_chrName")
				
				if _chrLayer != undefined then
					LayerManager.deleteLayerByName _chrLayer.name
			)

			if (lb.assetManager.isOpen()) then lb.assetManager.rollAdvanced.btnRefresh.pressed() --refresca el menu asset manager para actualizarlo.
		)
		
		------------------------------------------------
		--@fn: undefined | LoadEditionRig | cargar el edition Rig desde el comienzo, mergea el archivo de editionRig que esta en Resource.
		------------------------------------------------
		fn loadEditionRig autoRename:true nameAst:"" =
		(
			_assets = lb.asset.getSceneAssets()
			_partAnimEdit = undefined
			_success = false
			
			--Obtención de la ruta donde se ubica el archivo EditionRig.
			_mergeFolder = @"R:\\resource\\technical\\max\\rigging\\chr_animEdit\\version\\base\\"
			_filename = getFiles (_mergeFolder + "chr_animEdit(biped-std)_anim_v01.max")
			
			--Obtenemos las piezas del EditionRig
			mergeMAXFile _filename[1]
			
			_baseAnimEdit = lb.rig.solutions.getBaseNode type:#AnimEdit
			
			if autoRename then
			(	
				_chrLayer = (LayerManager.getLayer 1)
				
				_partAnimEdit = (lb.asset.getAssetsFromNodes #(_baseAnimEdit))[1]

				-- Renombramos el asset entero con el nombre que le hayamos asignado.
				_ast = undefined
				
				for _a in _assets do
					if _a.name != undefined then
						if _a.name != "chrName" then
							_ast = _a	
						
				if _chrLayer != undefined then
					if _chrLayer.name != "chr_chrName" then
					(	
						if nameAst == "" then nameAst = _ast.name
						
						for _o in _partAnimEdit.nodes do
						(					
							_chrLayer.addNode _o
							 _o.name = lb.nc.replaceNamePart _o.name 2 nameAst
						)

						LayerManager.deleteLayerByName "chr_chrName"				
					)
			)

			if (lb.assetManager.isOpen()) then lb.assetManager.rollAdvanced.btnRefresh.pressed() --refresca el menu asset manager para actualizarlo.
		)
			
		------------------------------------------------
		--@fn: undefined | SaveEditionRig | Salvar los datos del editionRig, en formato .xaf de animación, devolviendo la ruta de salvado.
		------------------------------------------------
		fn saveEditionRig =
		(
			_assets = lb.asset.getSceneAssets()
			_partAnimEdit = undefined
			_astFolder = undefined
			_success = false
			
			--Obtiene la ruta para pasarla posteriormente en la parte donde se salva.
			for _a in _assets do
			(
				_partAnimEdit = _a.AnimEditNodesAll
		
				if _partAnimEdit.count != 0 then
				(
					
					if _a.name != "chrName" then
						_astFolder = _a.folder + @"rig\animEdit\"

					if _astFolder == undefined then 
						_astFolder = @"y:\"
					
					_fileName = getSaveFileName caption:("Save Data from EditionRig") fileName:_astFolder types:"editionRigData(*.xaf)|*.xaf|Todos los formatos (*.*)|*.*|"
					if _fileName != undefined then
						_success = lb.asset.saveAnimation _fileName _partAnimEdit _partAnimEdit saveSegment:true segInterval:(interval 0f 0f)
					else
						_success = true

				)

			)

			if not _success do MessageBox "There are not EditionRig in scene."
		)
		
		------------------------------------------------
		--@fn: undefined | LoadEditionRigData | cargar los datos del EditionRig., en formato .xaf de animación, devolviendo la ruta de carga.
		------------------------------------------------
		fn LoadEditionRigData =
		(
			_astFolder = undefined
			_partAnimEdit = undefined
			_success = false
			_assets = lb.asset.getSceneAssets()
			
			--Obtiene la ruta para pasarla posteriormente en la parte donde se carga.
			for _o in _assets do
			(

				_partAnimEdit = _o.AnimEditNodesAll

				if _partAnimEdit.count != 0 then
				(
					
					if _o.name != "chrName" then
						_astFolder = _o.folder + @"rig\animEdit\"

					if _astFolder == undefined then 
						_astFolder = @"y:\"

					
					_filename = getOpenFileName caption:("Load Edition Data") filename:_astFolder types:"editionRigData(*.xaf)|*.xaf|Todos los formatos (*.*)|*.*|"
					if _fileName != undefined then
						_success = lb.asset.loadAnimation _fileName _partAnimEdit _partAnimEdit
					else
						_success = true
				)
				
				-- Hacemos un compelte redraw para refrescar el viewport porque sino no carga la transformación del objeto xD
				completeRedraw()
				
				for o in _partAnimEdit do (deleteKeys o.transform.controller #allkeys)

			)
			
			if not _success do MessageBox "There are not EditionRig in scene."  --si no detecta piezas de EditionRig saca mensaje de avisando.
			if (lb.assetManager.isOpen()) then lb.assetManager.rollAdvanced.btnRefresh.pressed() --refresca el menu asset manager para actualizarlo.
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		--Evento para traer el EditionRig.
		---------------------------------------------------------------------------------------------------------------
	 	on btnLoadEditionRig pressed do
	 	(
			_baseAnimEdit = lb.rig.solutions.getBaseNode type:#AnimEdit
			_success = undefined
			
			if _baseAnimEdit != undefined then
			(
				
				_success = lb.message.show "Do you want replace Anim Edition rig?" type:#query pos:undefined size:[300,75] modal:true
				
				if _success then
				(				
					deleteEditionRig()
					
					if rollMainDef.chkAutoRename.checked then
						loadEditionRig()
					else
						loadEditionRig autoRename:false nameAst:rollMainDef.edtChrName.text
				)
			)
			else
				if rollMainDef.chkAutoRename.checked then
					loadEditionRig()
				else
					loadEditionRig autoRename:false nameAst:rollMainDef.edtChrName.text
			
			rollMainDef.refreshUI forceAll: true
			rollMainDef.updateUI()
			redrawViews()
	 	)			
		
		---------------------------------------------------------------------------------------------------------------
		--Evento para borrar el asset del EditionRig.
		---------------------------------------------------------------------------------------------------------------
		on btnDeleteEditionRig pressed do
	 	(
			_baseAnimEdit = lb.rig.solutions.getBaseNode type:#AnimEdit
						
			if _baseAnimEdit != undefined then
			(

				_success = lb.message.show "Do you want delete Anim Edition Rig?" type:#query pos:undefined size:[300,75] modal:true			
					
				if _success	then 
					deleteEditionRig()
			)
				
			rollMainDef.refreshUI forceAll: true
			rollMainDef.updateUI()
			redrawViews()
	 	)
		
		---------------------------------------------------------------------------------------------------------------
		--Evento para salvar los datos del EditionRig.
		---------------------------------------------------------------------------------------------------------------
		on btnSaveEditionRig pressed do
	 	(
			SaveEditionRig()
	 	)
		
		---------------------------------------------------------------------------------------------------------------
		--Evento para cargar los datos del EditionRig.
		---------------------------------------------------------------------------------------------------------------
		on btnLoadEditionRigData pressed do
	 	(
	 		LoadEditionRigData()
			redrawViews()
	 	)
	)
	
	rollout rollFacialMask "Facial Rig Manager"
	(
		--@control | controlName | Plantilla de comentario para controles
		groupBox gprEditionMask "Edition Mask" pos:[5,0] width:280 height:45
		button btnLoadEditMask "Load Edition Mask" pos:[10,15] width:130 height:25
		button btnDelEditMask "Delete Edition Mask" pos:[150,15] width:130  height:25
			
		groupBox gprAnimMask "Anim Mask" pos:[5,45] width:280 height:70
		button btnLoadAnimMask "Load Anim Mask" pos:[10,60] width:130 height:25
		button btnDelAnimMask "Delete Anim Mask" pos:[150,60] width:130  height:25
		checkBox chkAutoSnap "Auto Snap Mask" pos:[10,90] checked:true
		checkBox chkSimplifyRig "Morph Rig Only" pos:[150,90] checked:false
			
		groupBox gprOptions "Options Mask" pos:[5,115] width:280 height:105
		button btnMirrorPaste "Mirror Paste" pos:[10,130] width:130  height:25
		button btnSnapAnimMask "Snap Anim Mask" pos:[150,130] width:130  height:25
		button btnSaveEditMaskData "Save Edition Mask Data" pos:[10,160] width:130  height:25
		button btnLoadEditMaskData "Load Edition Mask Data" pos:[150,160] width:130  height:25
		button btnSelectSkinBones "Select Skin Bones" pos:[10,190] width:130  height:25
		button btnSimplifyRig "Morph Rig Conversion"pos:[150,190] width:130  height:25

		------------------------------------------------
		--@fn: undefined | loadFacialMask | Carga la careta standar de animacion o de edition.
		------------------------------------------------
		fn loadFacialMask category nameAst:"" =
		(	
			_facialMaskPath = undefined
			_astFacialMask = undefined
			_ast = undefined
			
			-- Snapeo de controles de animación a la careta de edición.
			_prjt = lb.project.getProjectById "cmn"
			_prjt.getRoot()
			
			if category == #anim then
				_facialMaskPath = (_prjt.getRoot()) + "\\resource\\technical\\max\\rigging\\chr_facialMask\\version\\base\\chr_facialMask_anim_v03.max"
			else if category == #facialEdit then
				_facialMaskPath = (_prjt.getRoot()) + "\\resource\\technical\\max\\rigging\\chr_facialMask\\version\\base\\chr_facialMask_facialEdit_v03.max"
					
			_facialMaskNodes = getMAXFileObjectNames _facialMaskPath
			
			_chrLayer = (LayerManager.getLayer 1)
					
			mergeMAXFile _facialMaskPath _facialMaskNodes #mergeDups

			_assets = lb.asset.getSceneAssets()		
							
			-- Capturamos el asset facialMask para operar con el.
			for _ast in _assets where _ast.name	== "facialMask" do _astFacialMask = _ast		
			
			-- Renombramos el asset entero con el nombre que le hayamos asignado.
			for _a in _assets do
				if _a.name != undefined then
					if _a.name != "facialMask" then
						_ast = _a
			
			if _chrLayer != undefined then 
				if _chrLayer.name != "chr_facialMask" then
				(	
					if nameAst == "" then nameAst = _ast.name
					
					for _o in _astFacialMask.nodes do
					(					
						_chrLayer.addNode _o
						 _o.name = lb.nc.replaceNamePart _o.name 2 _ast.name
					)
					
					LayerManager.deleteLayerByName "chr_facialMask"
				)	
				
		)
		
		------------------------------------------------
		--@fn: undefined | snapAnimMask | Ajusta los controles de animación con la careta de edición.
		------------------------------------------------
		fn snapAnimMask ast =
		(	
			_ast = ast
			
			if _ast != undefined then
			(
				_skinHead = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classSkin + "_" + lb.nc.NC_locationMiddle + "_head_x_*'"))[1]
				_eyeFacialParent = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationMiddle + "_eyeParent_x_fh'"))
				
				-- Nodos de mesh de ojos
				_eyesMesh = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classMesh + "_*_eye_*_f'")) as array
				_eyesCorneaMesh = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classMesh + "_*_eyeCornea_*_f'")) as array
				_eyesBrightnessMesh = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classMesh + "_*_eyeBrightness_*_fh'")) as array
				
				-- Nodes de rig de ojos
				_orbicularEyeL = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_orbicularEye-shp_x_ce'"))
				_orbicularEyeR = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_orbicularEye-shp_x_ce'"))
				
				-- Nodos de Facial de ojos
				_eyesLookAtHLP = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_eyeLookAt_x_fh'")) as array
				_eyesFFDs = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_ffd-eye_x_fh'")) as array
				_oribularEyes = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_orbicularEye_x_c'")) as array
			
				-- Nodos de nariz
				_noseFrontBon = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_nose-bon_*_fh'"))[1]
				_noseFrontBonEnd = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_nose-bonEnd_*_fhs'"))[1]
				_noseFrontHlpIk = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_nose-x-hlp-ik_*_fh'"))[1]
				_noseFrontHlp = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_noseFront-x-hlp-parent_*_fh'"))[1]
					
	
				-- Nodos de Lengua
				_tongueBonNodes = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_tongue*-bon_x_fh'")) as array
				_tongueShpNodes = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_tongue*-shp_x_ci'")) as array
				_tongueHlpNodes = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_tongue*-x-hlp-parent_x_fh*'")) as array
				
				-- Nodos de dientes
				_teethUpperMesh = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classMesh + "_*_teethUpper_*_f'"))[1]
				_teethLowerMesh = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classMesh + "_*_teethLower_*_f'"))[1]
				
				_teethUpperShp = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_teethUpper-all-shp_x_ce'"))[1]
				_teethLowerShp = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_teethLower-all-shp_x_ce'"))[1]
				
				
				-- Nodos parent de todo el sistema facial.
				_facialNodes = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_*-hlp-parent_x_fh*'")) as array
				
				-- Nodos ik de la boca
				_facialLipAllShapes = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationMiddle + "_lip-all-shp_x_ce'"))
				_facialLipIkNodes = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_ikChain0*-*-hlp_x_fh'")) as array
				_facialLipIkParentNodes = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_ikChain0*-*-hlp-parent_x_fh'")) as array
				
					
				_mouthRadialBonesEnd = lb.misc.sortNodesByName ((execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_mouthEnd*-*-bon_x_fh'")) as array)
				
				_bonEndLipExt = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_mouthEnd00-side-bon_x_fh'"))
				
				_facialEditLipExt = (execute ("$'chr_" + _ast.name + "_facialEdit_" + lb.nc.NC_locationLeft + "_ikChain00-side-shp_x_c'"))
				
				_animLipLExt = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-ext-shp_x_ce'"))
				_animLipRExt = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-ext-shp_x_ce'"))
				
				_animLipUpper = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationMiddle + "_lip-upper-shp_x_ce'"))
				_animLipLower = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationMiddle + "_lip-lower-shp_x_ce'"))
				
				_animLipLUpMid02 = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-upperMid2-shp_x_ce'"))
				_animLipRUpMid02 = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-upperMid2-shp_x_ce'"))
				
				_animLipLLowMid02 = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-lowerMid2-shp_x_ce'"))
				_animLipRLowMid02 = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-lowerMid2-shp_x_ce'"))
				
				_ikLipsShp = lb.misc.sortNodesByName ((execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacialEdit + "_*_ikChain*-*-shp_x_c'")) as array)
			
					
				-- Recorremos todos los objetos
				for i = 1 to _facialNodes.count do 
				(
					_filterName = filterString _facialNodes[i].name "_"
					_filterPart5 = filterString _filterName[5] "-"
					
					-- Buscamos la coincidencia con el shape en la careta de facialEdit
					_facialEditObj = _filterName[1] + "_" + _filterName[2] + "_" + lb.nc.NC_classfacialEdit + "_" + _filterName[4] + "_" + (_filterPart5[1] + "-" + _filterPart5[2] + "-" + "shp" ) + "_" + _filterName[6] + "_" + lb.nc.NC_controlflag
					_facialEditObj =  (execute ("$'" + _facialEditObj + "'"))				
						
					_facialParent = lb.rig.getFacialParent()
					_facialEditBase = lb.rig.getFacialBase category:lb.nc.NC_classfacialEdit
						
					--Vamos alineando con su correspondiente de edition.		
					if _facialEditObj != undefined then
					(
						lb.controller.setActiveController _facialNodes[i] #All #Frozen
						_bckpScale = _facialNodes[i].scale
						
						_facialNodes[i].transform = _facialEditObj.transform
						
						_facialNodes[i].scale = (lb.math.round _bckpScale)
						
						lb.controller.setActiveController _facialNodes[i] #All #Zero
					)
				)
												
				(-- SISTEMA DE OJOS, y FFDS.
					if _eyesMesh[1] != undefined then
					(	
						-- Desactivamos el turboSmooth antes de operar.
						for o in _eyesMesh where (getProperty o #turbosmooth) != undefined do						
							o.turboSmooth.enabled = false
							
						_eyesMesh = lb.misc.sortNodesByName _eyesMesh
						_eyesCorneaMesh = lb.misc.sortNodesByName _eyesCorneaMesh
						_eyesBrightnessMesh = lb.misc.sortNodesByName _eyesBrightnessMesh
						_eyesLookAtHLP = lb.misc.sortNodesByName _eyesLookAtHLP
						_eyesFFDs = lb.misc.sortNodesByName _eyesFFDs
						
						
						-- Alienamos primero el eyeParent con la vertical de uno de los dos ojos(el centro geometrico).
						lb.controller.setActiveController _eyeFacialParent #All #Frozen
						_eyeFacialParent.position.z = _eyesMesh[1].center[3] 
						lb.controller.setActiveController _eyeFacialParent #All #Zero
						
						-- Desvinculamos los mesh para evitar desplazamientos inecesarios.
						for _o in (_eyesMesh + _eyesCorneaMesh + _eyesBrightnessMesh) do _o.parent = undefined
						
						-- Alineamos cada hlp con su correspondiente de mesh, y emparentamos todos los objetos de mesh del ojo.
						for i = 1 to _eyesLookAtHLP.count do
						(
							_childsEyeLookAt = for _ch in _eyesLookAtHLP[i].children collect _ch 
							
							-- Desemparentamos los hijos para evitar desfases
							 for _o in _childsEyeLookAt do
							(
								lb.controller.setActiveController _o #All #Frozen
								_o.parent = undefined	
							)
							
							-- Calculamos el centro del loop del ojo para obetener el centro real del ojo.
							_verts = meshOp.getOpenEdges _eyesMesh[i].mesh
							_verts = _verts as array
							
							_tempVerts = #()
							_totalVerts = #()
							
							for j = 1 to _eyesMesh.count do
							(
								for k = 1 to _verts.count do 
								(
									appendIfUnique _tempVerts ((meshOp.getVertsUsingEdge _eyesMesh[i].mesh #{_verts[k]}) as array)[1]
									appendIfUnique _tempVerts ((meshOp.getVertsUsingEdge _eyesMesh[i].mesh #{_verts[k]}) as array)[2]
								)	
								
								
								for k = 1 to _tempVerts.count do
									if (( polyop.getVert _eyesMesh[j] _tempVerts[k])[2]) > _eyesMesh[j].center[2] then 
										append _totalVerts _tempVerts[k]			
										
								_vertsPos = [0,0,0]
								
								for h = 1 to _totalVerts.count do
									_vertsPos += _eyesMesh[i].verts[_totalVerts[h]].pos
	
								_centerEye = _vertsPos/_totalVerts.count
								
								lb.controller.setActiveController _eyesLookAtHLP[i] #All #Frozen						
								_eyesLookAtHLP[i].position = [_centerEye[1], (_centerEye[2]), _centerEye[3]]
								lb.controller.setActiveController _eyesLookAtHLP[i] #All #Zero
							)
							
							if _eyesMesh[i] != undefined then _eyesMesh[i].parent = _eyesLookAtHLP[i]
							if _eyesCorneaMesh[i] != undefined then _eyesCorneaMesh[i].parent = _eyesLookAtHLP[i]
							if _eyesBrightnessMesh[i] != undefined then _eyesBrightnessMesh[i].parent = _eyesLookAtHLP[i]
							
							
							-- Conectamos el control del ffd con la careta.
							if _eyesFFDs.count != 0 then
							(
								_eyesFFDParent = (execute "$'chr_*_facial_*_ffd-eye-parent_x_fh'")
								
								if _eyesFFDParent[i] == undefined then
								(
									_eyesFFDs[1].layer.current = true 
									
									_eyesFFDParent = lb.rig.createPointFromObj _eyesFFDs[i]

									_eyesFFDParent.wireColor = yellow
									_eyesFFDParent.name = substituteString _eyesFFDParent.name "#Point" "-parent"
									_eyesFFDParent.parent = lb.rig.getFacialParent()
									
									_eyesFFDParent.name = lb.nc.replaceNamePart _eyesFFDParent.name 2 _ast.name
									 
									_filterPart = filterString _eyesFFDParent.name  "_"
									
									lb.controller.freezeTransform _eyesFFDParent #all
									
									if _filterPart[4] == lb.nc.NC_locationRight then
										_eyesFFDParent.scale.controller[#Frozen_Scale].controller.value = [-1,1,1]	

									lb.controller.setActiveController _eyesFFDs[i] #All #Frozen	
									
									_eyesFFDs[i].parent = _eyesFFDParent
									_eyesFFDs[i].controller = prs()
									lb.controller.freezeTransform _eyesFFDs[i] #all
									
									-- Añadimos un float expression para la rotación en Y.
									_eyesFFDs[i].rotation.controller[#Zero_Euler_XYZ].rotation.controller.y_rotation.controller = Float_Expression()
									
									if _filterPart[4] == lb.nc.NC_locationRight then
										_eyesFFDs[i].rotation.controller[#Zero_Euler_XYZ].rotation.controller.y_rotation.controller.AddScalarTarget "orbicularEyeRotY" _orbicularEyeR.rotation.controller[#Zero_Euler_XYZ].y_rotation.controller
									else
										_eyesFFDs[i].rotation.controller[#Zero_Euler_XYZ].rotation.controller.y_rotation.controller.AddScalarTarget "orbicularEyeRotY" _orbicularEyeL.rotation.controller[#Zero_Euler_XYZ].y_rotation.controller
									
									if _filterPart[4] == lb.nc.NC_locationRight then
										_eyesFFDs[i].rotation.controller[#Zero_Euler_XYZ].rotation.controller.y_rotation.controller.setExpression "-orbicularEyeRotY"
									else
										_eyesFFDs[i].rotation.controller[#Zero_Euler_XYZ].rotation.controller.y_rotation.controller.setExpression "orbicularEyeRotY"
										
									-- Instanciamos controladores de escala y posición con el control de la careta para evitar fallos.
									_eyesFFDs[i].scale.controller[#Zero_Scale_XYZ].x_scale.controller = _oribularEyes[i].scale.controller[#Zero_Scale_XYZ].z_scale.controller
									_eyesFFDs[i].scale.controller[#Zero_Scale_XYZ].y_scale.controller = _oribularEyes[i].scale.controller[#Zero_Scale_XYZ].z_scale.controller
									_eyesFFDs[i].scale.controller[#Zero_Scale_XYZ].z_scale.controller = _oribularEyes[i].scale.controller[#Zero_Scale_XYZ].z_scale.controller
									
									_eyesFFDs[i].position.controller.available.controller = position_xyz()
									_eyesFFDs[i].position.controller.setName 3 "Influence"
									
									_eyesFFDs[i].position.controller[#Influence].controller = _oribularEyes[i].position.controller[#Zero_Pos_XYZ].controller
									
									_eyesFFDs[i].position.controller.setName 3 "Influence"
								
									-- Restauramos los emparentamientos.
									 for _o in _childsEyeLookAt do
									(
										_o.parent = _eyesLookAtHLP[i]
										lb.controller.setActiveController _o #All #Zero							
									)
								)
							)						
						)
					)-- Condicion para evitar que de error sino tenemos el mesh en la escena.
				)
				
				(-- Ajuste de hueso de nariz.
					--Vamos alineando con su correspondiente de edition.		
					_noseNodes = #(_noseFrontHlpIk, _noseFrontBonEnd)
					
					lb.controller.setActiveController _noseNodes #All #Frozen
					
					-- Ajustamos la nueva posición

					_bckpScale = _noseFrontHlpIk.scale
					
-- 					_noseFrontHlpIk.transform = _noseFrontHlp.transform
					_noseFrontBonEnd.position = _noseFrontHlp.position
					
					_noseFrontHlpIk.scale = (lb.math.round _bckpScale)
						
					lb.controller.setActiveController _noseNodes #All #Zero
					
-- 					_noseFrontBon.length = (distance _noseFrontBon _noseFrontHlp)
					
				)
				
				(-- SISTEMA DE LENGUA Y DIENTES 
-- 					lb.rig.solutions.addScaleControllerToTongueBones _ast

					
					-- Emparentamiento de dientes a shapes de animación.
					if _teethUpperMesh != undefined then _teethUpperMesh.parent = _teethUpperShp.children[1]
					if _teethLowerMesh != undefined then _teethLowerMesh.parent = _teethLowerShp.children[1]
				)
				
				-- Recorremos todos los objetos de nuevo para terminar de ajustar los ojos
				for i = 1 to _facialNodes.count do 
				(
					_filterName = filterString _facialNodes[i].name "_"
					_filterPart5 = filterString _filterName[5] "-"
					
					-- Buscamos la coincidencia con el shape en la careta de facialEdit
					_facialEditObj = _filterName[1] + "_" + _filterName[2] + "_" + lb.nc.NC_classfacialEdit + "_" + _filterName[4] + "_" + (_filterPart5[1] + "-" + _filterPart5[2] + "-" + "shp" ) + "_" + _filterName[6] + "_" + lb.nc.NC_controlflag
					_facialEditObj =  (execute ("$'" + _facialEditObj + "'"))
						
					_facialParent = lb.rig.getFacialParent()
					_facialEditBase = lb.rig.getFacialBase category:lb.nc.NC_classfacialEdit	

					-- Alienamos primero el facialparent con la Base_Layer
					lb.controller.setActiveController _facialParent #All #Frozen
						
-- 					_facialParent.transform = _facialEditBase.transform
					_facialParent.parent = _skinHead	
						
					lb.controller.setActiveController _facialParent #All #Zero
					
					--Vamos alineando con su correspondiente de edition.		
					if _facialEditObj != undefined then
					(
						lb.controller.setActiveController _facialNodes[i] #All #Frozen
						_bckpScale = _facialNodes[i].scale
						
						_facialNodes[i].transform = _facialEditObj.transform
						
						_facialNodes[i].scale = (lb.math.round _bckpScale)
						
						lb.controller.setActiveController _facialNodes[i] #All #Zero
					)
				)

				( -- CONTROLES LABIOS
					-- Calculamos la posición del control exterior para más tarde pasarla a todos los huesos y tener un radio perfecto para la rotación.
					for i = 1 to _mouthRadialBonesEnd.count do
					(
-- 						-- Obtenemos el lado correspondiente del objecto
						_side = lb.nc.getNamePart _mouthRadialBonesEnd[i].name 4
						
						-- Calculamos la distancia para alinear los huesos.
						_distToAlign = execute (lb.math.limitDigits (distance _ikLipsShp[i] _mouthRadialBonesEnd[i]) 1)
					
						-- Calculamos la dirección, es decir, si el control de edición está por delante del hueso a alienar o por detrás.
						_directionToAlign = lb.math.sign (_ikLipsShp[i].pos.y - _mouthRadialBonesEnd[i].pos.y)

						-- Dependiendo a la dirección cambiamos el signo.
						if 	_directionToAlign == 1 then
							_distToAlign = - _distToAlign
							
						-- Dependiendo del lado se cambia el signo de nuevo.
						if _side == lb.nc.NC_locationRight then
							_mouthRadialBonesEnd[i].position.controller[#Frozen_position].controller.x_position = _mouthRadialBonesEnd[i].position.controller[#Frozen_position].controller.x_position - _distToAlign
						else 
							_mouthRadialBonesEnd[i].position.controller[#Frozen_position].controller.x_position = _mouthRadialBonesEnd[i].position.controller[#Frozen_position].controller.x_position + _distToAlign
					)

					-- Para la parte de los controles de los labios inferioes hacemos alineaciones en un orden en concreto para evitar que se estropee el sistema.
					-- Primer nivel de jerarquia de iks de huesos.
					for i = 1 to _facialLipIkNodes.count do
					(
						_filterName = filterString _facialLipIkNodes[i].name "_"
						_filterPart5 = filterString _filterName[5] "-"

						-- Buscamos la coincidencia con el shape en la careta de facialEdit
						_facialEditObj = _filterName[1] + "_" + _filterName[2] + "_" + lb.nc.NC_classfacialEdit + "_" + _filterName[4] + "_" + (_filterPart5[1] + "-" + _filterPart5[2] + "-" + "shp" ) + "_" + _filterName[6] + "_" + lb.nc.NC_controlflag
						_facialEditObj =  (execute ("$'" + _facialEditObj + "'"))
 						

						--  Pasamos el valor obtenido del control exterior a los demás huesos y comprobamos el lado contrario para ponerlo en negativo.	
						_bonEndParent = _facialLipIkParentNodes[i].parent
						
						if _bonEndParent.name != "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_mouthEnd00-side-bon_x_fh" then
						(	
-- 							if (_bonEndParent.position.controller[#Frozen_position].controller.x_position) > 0 then
-- 								_bonEndParent.position.controller[#Frozen_position].controller.x_position = _posBonEnd
-- 							else 		
-- 								_bonEndParent.position.controller[#Frozen_position].controller.x_position = -_posBonEnd
						)
							
						-- Activamos el frozen de las ik	
						lb.controller.setActiveController _facialLipIkNodes[i] #All #Frozen
						_bckpScale = _facialLipIkNodes[i].scale
 						
						_shpParent = _facialLipIkNodes[i].parent.parent
						lb.controller.setActiveController _shpParent #All #Frozen	
						
						_shpParentRotYBckp = _shpParent.rotation.controller[#Frozen_rotation].controller.y_rotation
						_shpParentRotZBckp = _shpParent.rotation.controller[#Frozen_rotation].controller.z_rotation
						
						_shpParent.transform = _facialEditObj.transform
						
						-- Reseteamos los valores para que se nos queden los controles planos al shape principal de la boca.
						_shpParent.position.y = _facialLipAllShapes.position.y
						_shpParent.rotation.controller[#Frozen_rotation].controller.y_rotation = _shpParentRotYBckp
						_shpParent.rotation.controller[#Frozen_rotation].controller.z_rotation = _shpParentRotZBckp
						_facialLipIkNodes[i].transform = _facialEditObj.transform
														
						_facialLipIkNodes[i].scale = (lb.math.round _bckpScale)
							
						lb.controller.setActiveController _facialLipIkNodes[i] #All #Zero
						lb.controller.setActiveController _shpParent #All #Zero
					)
					

					for i = 1 to _facialLipIkParentNodes.count do
					(
-- 						print _facialLipIkParentNodes[i]
						
						_filterName = filterString _facialLipIkParentNodes[i].name "_"
						_filterPart5 = filterString _filterName[5] "-"

						-- Buscamos la coincidencia con el shape en la careta de facialEdit
						_facialEditObj = _filterName[1] + "_" + _filterName[2] + "_" + lb.nc.NC_classfacialEdit + "_" + _filterName[4] + "_" + (_filterPart5[1] + "-" + _filterPart5[2] + "-" + "shp" ) + "_" + _filterName[6] + "_" + lb.nc.NC_controlflag
						
						_facialEditObj =  (execute ("$'" + _facialEditObj + "'"))
							
						_parentMuscle = _facialLipIkParentNodes[i].parent.children[1]	
													
						lb.controller.setActiveController _facialLipIkParentNodes[i] #All #Frozen
						lb.controller.setActiveController _parentMuscle #All #Frozen

						_bckpScale = _facialLipIkParentNodes[i].scale
							
						_facialLipIkParentNodes[i].transform = _facialEditObj.transform
						_facialLipIkParentNodes[i].position = _facialLipIkParentNodes[i].parent.position
						_parentMuscle.transform = _facialEditObj.transform
							
						_facialLipIkParentNodes[i].scale = (lb.math.round _bckpScale)
							
						lb.controller.setActiveController _facialLipIkParentNodes[i] #All #Zero
						lb.controller.setActiveController _parentMuscle #All #Zero	
					)
					
					
					
					-- Actualizamos las distancias respecto a las nuevas posiciones.
					(
						_distTotalMidUp = distance _animLipUpper _animLipRExt
						_distTotalMidLower = distance _animLipLower _animLipRExt
						
						_distTotalMid02Up = distance _animLipUpper _animLipLUpMid02
						_distTotalMid02Low = distance _animLipLower _animLipLLowMid02
						
						for i = 1 to _facialLipIkNodes.count do
						(
							_shpParent = _facialLipIkNodes[i].parent
							_filterName = filterString _shpParent.name "_"
							
							if (_shpParent.name != "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-ext-shp_x_ce") and _filterName[4] == lb.nc.NC_locationLeft then
							(	
								-- Bellows Pos X
								(	
									-- lipExt
									if (findString _filterName[5] "lower") == undefined then
									(
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipUpper)
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.AddScalarConstant "legnthTOTAL" _distTotalMidUp
										
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.update()		
									) 
									else if (findString _filterName[5] "lower") != undefined then
									(
														
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLower)
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.AddScalarConstant "legnthTOTAL" _distTotalMidLower
										
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.update()		
									)
									
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.x_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.x_position.controller[i].name == "bellows_lipUpperMid" then
										(
											--lipMid
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLExt)
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid.controller.AddScalarConstant "legnthTOTAL" _distTotalMidUp
											
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid.controller.update()
										)
										else if	_shpParent.position.controller[#Influence].controller.x_position.controller[i].name == "bellows_lipLowerMid" do								
										(
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLExt)
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid.controller.AddScalarConstant "legnthTOTAL" _distTotalMidLower
											
											
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid.controller.update()
										)										
									)-- for
									
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.x_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.x_position.controller[i].name == "bellows_lipUpperMid2" then
										(
											--lipMid
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-upperMid1-shp_x_ce" then
											(
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthPARTIAL" (distance _shpParent _animLipUpper)
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipLUpMid02 _animLipUpper)
											)
											
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-upperMid3-shp_x_ce" then
											(
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthPARTIAL" (distance _shpParent _animLipLExt)
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipLUpMid02 _animLipLExt)
											)
											
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.update()
										)
										
										if	_shpParent.position.controller[#Influence].controller.x_position.controller[i].name == "bellows_lipLowerMid2" do								
										(
											--lipMid
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-lowerMid1-shp_x_ce" then
											(
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthPARTIAL" (distance _shpParent _animLipLower)
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipLLowMid02 _animLipLower)
											)
											
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-lowerMid3-shp_x_ce" then
											(
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthPARTIAL" (distance _shpParent _animLipLExt)
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipLLowMid02 _animLipLExt)
											)
											
											
											
											
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.update()
										)										
									)-- for
								)
								
								-- Bellows Pos Y
								(	
									-- lipExt
									_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipExt.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipUpper)
									_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipExt.controller.AddScalarConstant "legnthTOTAL" _distTotalMidUp
									
									_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipExt.controller.update()		
									
									
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.y_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.y_position.controller[i].name == "bellows_lipUpperMid" then
										(
											--lipMid
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLExt)
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid.controller.AddScalarConstant "legnthTOTAL" _distTotalMid02Up
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid.controller.update()
										)
										else if	_shpParent.position.controller[#Influence].controller.y_position.controller[i].name == "bellows_lipLowerMid" do								
										(
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLExt)
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid.controller.AddScalarConstant "legnthTOTAL" _distTotalMid02Low
											
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid.controller.update()
										)										
									)-- for
									
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.y_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.y_position.controller[i].name == "bellows_lipUpperMid2" then
										(
											--lipMid
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-upperMid1-shp_x_ce" then
												_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLUpMid02)
											
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-upperMid3-shp_x_ce" then
												_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLExt)
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipUpper _animLipLUpMid02)
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid2.controller.update()
										)
										else if	_shpParent.position.controller[#Influence].controller.y_position.controller[i].name == "bellows_lipLowerMid2" do								
										(
											--lipMid
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-lowerMid1-shp_x_ce" then
												_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLLowMid02)
											
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_lip-lowerMid3-shp_x_ce" then
												_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLExt)
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipLower _animLipLLowMid02)
											
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid2.controller.update()
										)										
									)-- for
								)
								
								-- Quadratic Pos Z
								(
									-- lipExt
									_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipExt.controller.AddScalarConstant  "lipExtRefPos_x" _facialEditLipExt.pos.x
									_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipExt.controller.AddScalarConstant "thisRefPos_x" _shpParent.pos.x
									
									_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipExt.controller.update()
									
									--lipMid
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.z_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.z_position.controller[i].name == "quadratic_lipUpperMid" then
										(
											--lipMid
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipUpperMid.controller.AddScalarConstant  "lipUpperMidZeroRefPos_x" _facialEditLipExt.pos.x
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipUpperMid.controller.AddScalarConstant "thisRefPos_x" _shpParent.pos.x
											
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipUpperMid.controller.update()
										)
										else if	_shpParent.position.controller[#Influence].controller.z_position.controller[i].name == "quadratic_lipLowerMid" do								
										(
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipLowerMid.controller.AddScalarConstant  "lipLowerMidZeroRefPos_x" _facialEditLipExt.pos.x
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipLowerMid.controller.AddScalarConstant "thisRefPos_x" _shpParent.pos.x
											
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipLowerMid.controller.update()
										)										
									)-- for
								)

							)-- if
							else if (_shpParent.name != "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-ext-shp_x_ce") and _filterName[4] == lb.nc.NC_locationRight then
							(	
								-- Bellows Pos X
								(	
									-- lipExt
									if (findString _filterName[5] "lower") == undefined then
									(
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipUpper)
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.AddScalarConstant "legnthTOTAL" _distTotalMidUp
										
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.update()		
									) 
									else if (findString _filterName[5] "lower") != undefined then
									(
														
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipLower)
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.AddScalarConstant "legnthTOTAL" _distTotalMidLower
										
										_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipExt.controller.update()		
									)
									
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.x_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.x_position.controller[i].name == "bellows_lipUpperMid" then
										(
											--lipMid
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipRExt)
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid.controller.AddScalarConstant "legnthTOTAL" _distTotalMidUp
											
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid.controller.update()
										)
										else if	_shpParent.position.controller[#Influence].controller.x_position.controller[i].name == "bellows_lipLowerMid" do								
										(
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipRExt)
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid.controller.AddScalarConstant "legnthTOTAL" _distTotalMidLower
											
											
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid.controller.update()
										)										
									)-- for
									
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.x_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.x_position.controller[i].name == "bellows_lipUpperMid2" then
										(
											--lipMid
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-upperMid1-shp_x_ce" then
											(
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthPARTIAL" (distance _shpParent _animLipUpper)
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipRUpMid02 _animLipUpper)
											)
											
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-upperMid3-shp_x_ce" then
											(
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthPARTIAL" (distance _shpParent _animLipRExt)
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipRUpMid02 _animLipRExt)
											)
											
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipUpperMid2.controller.update()
										)
										
										if	_shpParent.position.controller[#Influence].controller.x_position.controller[i].name == "bellows_lipLowerMid2" do								
										(
											--lipMid
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-lowerMid1-shp_x_ce" then
											(
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthPARTIAL" (distance _shpParent _animLipLower)
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipRLowMid02 _animLipLower)
											)
											
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-lowerMid3-shp_x_ce" then
											(
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthPARTIAL" (distance _shpParent _animLipRExt)
												_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipRLowMid02 _animLipRExt)
											)
											
											
											
											
											_shpParent.position.controller[#Influence].controller.x_position.controller.bellows_lipLowerMid2.controller.update()
										)										
									)-- for
								)
								
								-- Bellows Pos Y
								(	
									_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipExt.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipUpper)
									_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipExt.controller.AddScalarConstant "legnthTOTAL" _distTotalMidUp
									
									_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipExt.controller.update()		
									
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.y_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.y_position.controller[i].name == "bellows_lipUpperMid" then
										(
											--lipMid
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipRExt)
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid.controller.AddScalarConstant "legnthTOTAL" _distTotalMid02Up
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid.controller.update()
										)
										
										if	_shpParent.position.controller[#Influence].controller.y_position.controller[i].name == "bellows_lipLowerMid" do								
										(
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipRExt)
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid.controller.AddScalarConstant "legnthTOTAL" _distTotalMid02Low
											
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid.controller.update()
										)										
									)-- for
									
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.y_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.y_position.controller[i].name == "bellows_lipUpperMid2" then
										(
											--lipMid
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-upperMid1-shp_x_ce" then
												_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipUpper)
											
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-upperMid3-shp_x_ce" then
												_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipRExt)
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipUpper _animLipRUpMid02)
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipUpperMid2.controller.update()
										)
										
										if	_shpParent.position.controller[#Influence].controller.y_position.controller[i].name == "bellows_lipLowerMid2" do								
										(
											--lipMid
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-lowerMid1-shp_x_ce" then
												_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipUpper)
											
											if _shpParent.name == "chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_lip-lowerMid3-shp_x_ce" then
												_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant  "legnthPARTIAL" (distance _shpParent _animLipRExt)
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid2.controller.AddScalarConstant "legnthTOTAL" (distance _animLipLower _animLipRLowMid02)
											
											
											_shpParent.position.controller[#Influence].controller.y_position.controller.bellows_lipLowerMid2.controller.update()
										)										
									)-- for
								)
								
								-- Quadratic Pos Z
								(
									_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipExt.controller.AddScalarConstant  "lipExtRefPos_x" (-_facialEditLipExt.pos.x)
									_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipExt.controller.AddScalarConstant "thisRefPos_x" _shpParent.pos.x
									
									_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipExt.controller.update()
									
									--lipMid
									-- Recorremos los controladores del float list para ver capturar el mid superior o inferior
									for i = 1 to _shpParent.position.controller[#Influence].controller.z_position.controller.count do
									(
										if _shpParent.position.controller[#Influence].controller.z_position.controller[i].name == "quadratic_lipUpperMid" then
										(
											--lipMid
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipUpperMid.controller.AddScalarConstant  "lipUpperMidZeroRefPos_x" (-_facialEditLipExt.pos.x)
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipUpperMid.controller.AddScalarConstant "thisRefPos_x" _shpParent.pos.x
											
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipUpperMid.controller.update()
										)
										else if	_shpParent.position.controller[#Influence].controller.z_position.controller[i].name == "quadratic_lipLowerMid" do								
										(
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipLowerMid.controller.AddScalarConstant  "lipLowerMidZeroRefPos_x" (-_facialEditLipExt.pos.x)
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipLowerMid.controller.AddScalarConstant "thisRefPos_x" _shpParent.pos.x
											
											_shpParent.position.controller[#Influence].controller.z_position.controller.quadratic_lipLowerMid.controller.update()
										)										
									)-- for	
									
								)	
							)
						)
					)
					
				) -- CONTROLES LABIOS
			)		
		)-- fn snapAnimMask		
		
		------------------------------------------------
		--@fn: undefined | pastePostureSide | Pega la transformación de los controles de la cara izquieda al lado contrario.
		------------------------------------------------
		fn mirrorPaste =
		(
			_bckpSelection = getCurrentSelection()
			
			_assets = (lb.asset.getSceneAssets())
				
			_astFacialMask = undefined
			_facialControls = undefined
				
			-- Capturamos el asset facialMask para operar con el.
			for _ast in _assets where _ast.name	== "facialMask" do _astFacialMask = _ast
		
			-- Renombramos el asset entero con el nombre que le hayamos asignado.
			for _a in _assets do
				if _a.name != undefined then
					if _a.name != "facialMask" then
						_astFacialMask = _a
			
			if _bckpSelection.count == 0 then _facialControls = lb.asset.sceneAssets[1].facialEditNodesAll else _facialControls = _bckpSelection
			
			_filterSelection = #()
			
			for _o in _facialControls do
			(
				_filterPart = filterstring _o.name "_"
				if _filterPart[4] == lb.nc.NC_locationLeft then
					append _filterSelection _o
			)
			
			_facialControls  = _filterSelection

			select _facialControls
			
			lb.animInfo.copyAnimTracks()
			lb.animInfo.pasteOppositeAnimTracks()
			
			clearSelection()
			select _bckpSelection
		)	
		
		------------------------------------------------
		--@fn: undefined | pastePostureSide | Pega la transformación de los controles de la cara izquieda al lado contrario.
		------------------------------------------------
		fn selectSkinBones =
		(
			_bckpSelection = getCurrentSelection()
			
			_assets = (lb.asset.getSceneAssets())
				
			_astFacialMask = undefined
				
			-- Capturamos el asset facialMask para operar con el.
			_facialBones = for _o in _assets[1].facialNodesAll where (classOf _o == boneGeometry) collect _o
			
			_filterSelection = #()
			
			for _o in _facialBones do
			(
				_filterPart = filterstring _o.name "_"
				if _filterPart[7] == (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag + lb.nc.NC_skinFlag) then
					append _filterSelection _o
				
			)
			
			select _filterSelection
			
		)
		
		------------------------------------------------
		--@fn: undefined | saveEditionMaskData | Salva la transformación de la mascara de edition.
		------------------------------------------------
		fn saveEditionMaskData =
		(
			_assets = lb.asset.getSceneAssets()
			_partAnimEdit = undefined
			_astFolder = undefined
			_success = false
			
			--Obtiene la ruta para pasarla posteriormente en la parte donde se salva.
			for _a in _assets do
			(
				_partFacialEdit = _a.facialEditNodesAll
		
				if _partFacialEdit.count != 0 then
				(

					if _a.name != "chrName" then
						_astFolder = _a.folder + @"rig\animEdit\"

					if _astFolder == undefined then 
						_astFolder = @"y:\"
					
					_fileName = getSaveFileName caption:("Save Data from Faciel Edit Nodes") fileName:_astFolder types:"facialEditionData(*.xaf)|*.xaf|Todos los formatos (*.*)|*.*|"
					if _fileName != undefined then
						_success = lb.asset.saveAnimation _fileName _partFacialEdit _partFacialEdit saveSegment:true segInterval:(interval 0f 0f)
					else
						_success = true

				)

			)
			
			if not _success do MessageBox "There are not facial edit nodes in scene."
	
		)
		
		------------------------------------------------
		--@fn: undefined | saveEditionMaskData | Salva la transformación de la mascara de edition.
		------------------------------------------------
		fn loadEditionMaskData =
		(
			_astFolder = undefined
			_partAnimEdit = undefined
			_success = false
			_assets = lb.asset.getSceneAssets()
			
			--Obtiene la ruta para pasarla posteriormente en la parte donde se carga.
			for _a in _assets do
			(

				_partFacialEdit = _a.facialEditNodesAll
			
				if _partFacialEdit.count != 0 then
				(
					if _a.name != "chrName" then
						_astFolder = _a.folder + @"rig\animEdit\"

					if _astFolder == undefined then 
						_astFolder = @"y:\"

					
					_filename = getOpenFileName caption:("Load Facial Edition Data") filename:_astFolder types:"facialEditionData(*.xaf)|*.xaf|Todos los formatos (*.*)|*.*|"
					if _fileName != undefined then
						_success = lb.asset.loadAnimation _fileName _partFacialEdit _partFacialEdit
					else
						_success = true
				)
				
				if file != undefined then
				(
					loadEditionMaskData file
					
					if _astFacialMask != undefined and _astFacialMask.facialNodesAll.count != 0 then
						if chkAutoSnap.checked then snapAnimMask()

				)
				
				-- Hacemos un compelte redraw para refrescar el viewport porque sino no carga la transformación del objeto xD
				completeRedraw()
				for o in _partFacialEdit do (deleteKeys o.transform.controller #allkeys)
			)
			
			if not _success do MessageBox "There are not EditionRig in scene."  --si no detecta piezas de EditionRig saca mensaje de avisando.
			if (lb.assetManager.isOpen()) then lb.assetManager.rollAdvanced.btnRefresh.pressed() --refresca el menu asset manager para actualizarlo.
	
		)

		fn simplifyrig =
		(		
			_assets = (lb.asset.getSceneAssets())
				
			_facialBones = for _o in _assets[1].facialNodesAll where (classOf _o == boneGeometry) collect _o
			
			_boneSelection = #()

			---Selección de todos los huesos faciales excepto los de la lengua y la mandíbula
			for _o in _facialBones do
			(
				_filterPart = filterstring _o.name "_"
				if ((not matchPattern _o.name pattern: "*_jaw-bon_*" ) and (not matchPattern _o.name pattern: "*_tongue*")) then
					append _boneSelection _o
			)

			_bonesAndHelpers = #()
			_forbiddenNamePatterns = #("*eye*","*tongue*","*facialParent*","*jawBon*","*teethLower*","*mouth-x-hlp-parent*","*mask-hlp-parent*")
			--Seleccion de los helpers a borrar
			for _helper in _assets[1].facialNodesAll where classOf _helper == helper do
			(
				_children = _helper.children
				_copyNode = true
				--Buscamos todos los helpers cuyo padre no sea un shape 
				for _child in _children do if classOf _child == SplineShape then _copyNode = false
				--Buscamos aquellos helpers que sean excepción, de la array _forbiddenNamePatterns
				for _pattern in _forbiddenNamePatterns do if( matchPattern _helper.name pattern: _pattern) then  _copyNode = false
				--Añadimos los helpers que se han saltado las excepciones a la array
				if _copyNode then appendIfUnique _bonesAndHelpers _helper
			)
			
			for _obj in _boneSelection do appendIfUnique _bonesAndHelpers _obj
			
			_ikMouthHelpers = #()
			for _helper in _assets[1].facialNodesAll where ((classOf _helper == SplineShape) or (classOf _helper == Point) or (classOf _helper == IK_Chain_Object)) do
			(
				if matchpattern _helper.name pattern: "*ikChain*" do  append _ikMouthHelpers _helper
			)
			for _helper in _assets[1].facialNodesAll where ((matchpattern _helper.name pattern:"*_lipEnd*")) do appendIfUnique _ikMouthHelpers _helper
			for _helper in _assets[1].facialNodesAll where (matchpattern _helper.name pattern:"*facialMask_facial_l_lip02-up-hlp-parent_x_fh*") do appendIfUnique _ikMouthHelpers _helper
			for _helper in _assets[1].facialNodesAll where (matchpattern _helper.name pattern:"*frown-int*") do appendIfUnique _ikMouthHelpers _helper
			for _helper in _assets[1].facialNodesAll where (((matchpattern _helper.name pattern:"*_lip*") and (matchpattern _helper.name pattern:"*-up-*") and (matchpattern _helper.name pattern:"*-hlp*")and not (matchpattern _helper.name pattern:"*-01*")) or (matchpattern _helper.name pattern:"*orbLipEnd*") or ((matchpattern _helper.name pattern:"*chkEnd*") and not (matchpattern _helper.name pattern:"*parent*")) or ((matchpattern _helper.name pattern:"*nose-ext-hlp*") and not (matchpattern _helper.name pattern:"*parent*")) or ((matchpattern _helper.name pattern:"*chb-all-hlp*")and not (matchpattern _helper.name pattern:"*parent*")) or ((matchpattern _helper.name pattern:"*_ebw-facialMaskd*")and (matchpattern _helper.name pattern:"*-hlp*")and not (matchpattern _helper.name pattern:"*-mask*")) or ((matchpattern _helper.name pattern:"*ebw-int*") and (matchpattern _helper.name pattern:"*-hlp*")and not (matchpattern _helper.name pattern:"*parent*")and not (matchpattern _helper.name pattern:"*-mask*"))or (matchpattern _helper.name pattern:"*ebw03*")and not (matchpattern _helper.name pattern:"*parent*")) do appendIfUnique _ikMouthHelpers _helper
			
			for _obj in _ikMouthHelpers do appendIfUnique _bonesAndHelpers _obj


-- 			select _ikMouthHelpers
			delete _bonesAndHelpers
			
			--Renombrado de piezas con naming incorrecto
			_selection = #()
			_assets = (lb.asset.getSceneAssets())
			
			
			for _shape in _assets[1].facialNodesAll where classOf _shape == splineShape do 
				if (matchPattern _shape.name pattern:"*_ebw-facialMask*") then appendIfUnique _selection _shape

			for _shape in _selection do
			(
				auxString = substituteString _shape.name "facialMaskd" "mid"
				_shape.name = auxString			
			)
		)
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@event: btnLoadEditMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnLoadEditMask pressed do
		(
			_assets = (lb.asset.getSceneAssets())
				
			_astFacialMask = undefined
				
			-- Capturamos el asset facialMask para operar con el.
			for _ast in _assets where _ast.name	== "facialMask" do _astFacialMask = _ast

			
			-- Comprobamos que si existe el asset de tipo facialMask
			if _astFacialMask != undefined then
			(
				-- Revisamos que haya nodos de tipo facial, si no hay cargamos la careta y hacemos snap, si existe preguntamos para reemplazar.
				if _astFacialMask.facialEditNodesAll.count == 0 then 
					loadFacialMask #facialEdit
				else
				(	
					_success = lb.message.show "Edition Mask found in scene. Do you want replace it?" type:#query pos:undefined size:[300,75] modal:true
					
					if _success then 
					(
						delete _astFacialMask.facialEditNodesAll
						loadFacialMask #facialEdit
					)
				)-- if facialNodesAll
			)-- if _astFacialMask
			else loadFacialMask #facialEdit
-- 				if _astFacialMask.facialEditNodesAll.count == 0 then -- Revisamos que haya nodos de tipo facial, si no hay cargamos la careta y hacemos snap, si existe preguntamos para reemplazar.
			
				
		)
		
		------------------------------------------------
		--@event: btnLoadAnimMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnLoadAnimMask pressed do
		(
			_assets = (lb.asset.getSceneAssets())
				
			_astFacialMask = undefined
				
			-- Capturamos el asset facialMask para operar con el.
			for _ast in _assets where _ast.name	== "facialMask" do _astFacialMask = _ast
	
			-- Comprobamos que si existe el asset de tipo facialMask
			if _astFacialMask != undefined then
			(
				_chrLayer = (LayerManager.getLayer 1)
				
				-- Renombramos el asset entero con el nombre que le hayamos asignado.
				_ast = undefined
				
				_assets = lb.asset.getSceneAssets()		
							
				-- Capturamos el asset facialMask para operar con el.
				for _a in _assets where _a.name	== "facialMask" do _ast = _a
			
				-- Renombramos el asset entero con el nombre que le hayamos asignado.
				for _a in _assets do
					if _a.name != undefined then
						if _a.name != "facialMask" then
							_ast = _a
			
				if _chrLayer != undefined then 
					if _chrLayer.name != "chr_facialMask" then
					(	
						if nameAst == "" then nameAst = _ast.name
						
						for _o in _astFacialMask.nodes do
						(					
							_chrLayer.addNode _o
							 _o.name = lb.nc.replaceNamePart _o.name 2 _ast.name
						)
						
						LayerManager.deleteLayerByName "chr_facialMask"
					)	
				
				-- Revisamos que haya nodos de tipo facial, si no hay cargamos la careta y hacemos snap, si existe preguntamos para reemplazar.
				_animFacialParent = lb.rig.getFacialParent()
		
				if _ast != undefined or (_animFacialParent == undefined) then 
				(
					loadFacialMask #anim
					_assets = (lb.asset.getSceneAssets())

					if _ast.facialEditNodesAll.count != 0 then			
						if chkAutoSnap.checked then snapAnimMask _ast

				)
				else
				(	
					_success = lb.message.show "Anim Mask found in scene. Do you want replace it?" type:#query pos:undefined size:[300,75] modal:true
					
					if _success then 
					(
						delete _astFacialMask.facialNodesAll
						loadFacialMask #anim
					
						if chkAutoSnap.checked then snapAnimMask()
						
					)
				)-- if facialNodesAll
			)-- if _astFacialMask
			else
			(
				loadFacialMask #anim
	
				_assets = (lb.asset.getSceneAssets())
				
				_astFacialMask = undefined
					
				-- Capturamos el asset facialMask para operar con el.
								-- Capturamos el asset facialMask para operar con el.
				for _a in _assets where _a.name	== "facialMask" do _ast = _a
			
				-- Renombramos el asset entero con el nombre que le hayamos asignado.
				for _a in _assets do
					if _a.name != undefined then
						if _a.name != "facialMask" then
							_ast = _a


				_ast = _assets[1]				
						
				if chkAutoSnap.checked then snapAnimMask _ast
			)
			--El siguiente codigo generará si el tick de morph rig only esta activado un rig simplificado, con huesos de lengua y mandíbula, para ser llevado por morphs.
			if chkSimplifyRig.checked then
			(
				simplifyrig()
			)
		)

		------------------------------------------------
		--@event: btnSimplifyRig | Evento que se lanza para simplificar un rig a modo Morph y renombrar piezas inmcorrectas
		------------------------------------------------
		on btnSimplifyRig pressed do
		(
			_option = lb.message.show "Are you sure you want to convert your actual Skeleton?\nIt will become a morph type one." type:#query
			if (_option) then
			(
				simplifyrig()
			)
		)
		------------------------------------------------
		--@event: btnDelAnimMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnDelAnimMask pressed do
		(
			_assets = (lb.asset.getSceneAssets())
			_facialParent = lb.rig.getFacialParent()
				
			_astFacialMask = undefined
			_ast = undefined	
			
			-- Capturamos el asset facialMask para operar con el.
			for _a in _assets where _a.name	== "facialMask" do _ast = _a

			_assets = lb.asset.getSceneAssets()		
									
			-- Renombramos el asset entero con el nombre que le hayamos asignado.
			for _a in _assets do
				if _a.name != undefined then
					if _a.name != "facialMask" then
						_ast = _a
			
			if _ast != undefined and _facialParent != undefined then
			(	
				-- Capturamos los ffds para desemparentarlos de la forma correcta.
				_eyesFFDs = (execute ("$'chr_" + _ast.name + "_" + lb.nc.NC_classFacial + "_*_ffd-eye_x_fh'")) as array
					
					_success = lb.message.show "Are you sure delete anim facial mask?" type:#query pos:undefined size:[300,75] modal:true
					
					if _success	then
					(
							_nodesToDelete = for _o in _ast.facialNodesAll where superClassOf _o != SpacewarpObject collect _o
							
							-- Dememparentamos
							lb.controller.setActiveController _eyesFFDs #all #frozen
							_eyesFFDs.parent = undefined 
							
							delete 	_nodesToDelete	
							
							lb.controller.setActiveController _eyesFFDs #all #Zero
								
							if _ast.name == "facialMask" then LayerManager.deleteLayerByName "chr_facialMask"
					)					
			)
		)	
	
		------------------------------------------------
		--@event: btnDelEditMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnDelEditMask pressed do
		(
			_assets = (lb.asset.getSceneAssets())
				
			_astFacialMask = undefined
			_ast = undefined	
				
			-- Capturamos el asset facialMask para operar con el.
			for _a in _assets where _a.name	== "facialMask" do _ast = _a

			_assets = lb.asset.getSceneAssets()		
									
			-- Renombramos el asset entero con el nombre que le hayamos asignado.
			for _a in _assets do
				if _a.name != undefined then
					if _a.name != "facialMask" then
						_ast = _a
			
			if _ast != undefined then
			(	
				if _ast.facialEditNodesAll.count != 0 then
				(	
					_success = lb.message.show "Are you sure delete edition facial mask?" type:#query pos:undefined size:[300,75] modal:true
					
					if _success	then
					(
							delete _ast.facialEditNodesAll
								
							if _ast.name == "facialMask" then LayerManager.deleteLayerByName "chr_facialMask"
					)	
				)
				else
					lb.message.show "No facial edit nodes in scene" type:#message pos:undefined size:[300,75] modal:true
			)
		)
		
		------------------------------------------------
		--@event: btnSnapAnimMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnMirrorPaste pressed do
		(
			disableSceneRedraw()
			mirrorPaste()
			enableSceneRedraw()
		)
		
		------------------------------------------------
		--@event: btnSnapAnimMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnSnapAnimMask pressed do
		(
			_assets = (lb.asset.getSceneAssets())
			
			_ast = undefined
				
			-- Capturamos el asset facialMask para operar con el.
							-- Capturamos el asset facialMask para operar con el.
			for _a in _assets where _a.name	== "facialMask" do _ast = _a
		
			-- Renombramos el asset entero con el nombre que le hayamos asignado.
			for _a in _assets do
				if _a.name != undefined then
					if _a.name != "facialMask" then
						_ast = _a
				
			-- Capturamos el asset facialMask para operar con el.
			_ast = _assets[1]

			if _ast != undefined and _ast.facialNodesAll.count != 0 and _ast.facialEditNodesAll.count != 0 then
				snapAnimMask _ast
		)
		
		------------------------------------------------
		--@event: btnSnapAnimMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnSaveEditMaskData pressed do
		(
			saveEditionMaskData()
			redrawViews()
		)
		
		------------------------------------------------
		--@event: btnSnapAnimMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnLoadEditMaskData pressed do
		(
			loadEditionMaskData()
			redrawViews()
		)
		
		------------------------------------------------
		--@event: btnSnapAnimMask | Evento que se lanza al redimensionar el rollout.
		------------------------------------------------
		on btnSelectSkinBones pressed do
		(
			selectSkinBones()
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: passManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_rigSolutionManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Gestor de soluciones de rig",		--@var: description | Descripcion de la tool.
		
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
			AddSubRollout this.rollMain.subRollEditionRig rollEditionRig
			AddSubRollout this.rollMain.subRollFacialMask rollFacialMask
			
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
		
	)--tl_rigSolutionManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	tl_rigSolutionManager() --crea la herramienta
)