------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta lightIncludeExcludeManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta lightIncludeExcludeManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Light Include/Exclude Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 550		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 350		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		--colors------------------------------------------------------------------------------
		local dgBackColor = (dotNetClass "System.Drawing.Color").beige--fondo
		local dgForeColor = (dotNetClass "System.Drawing.Color").gray--texto
		local dgSelBackColor = (dotNetClass "System.Drawing.Color").midnightblue--fondo de items seleccionados
		local dgSelForeColor = (dotNetClass "System.Drawing.Color").white--texto de items seleccionados	
		local dgAffectedItemBackColor = (dotNetClass "System.Drawing.Color").fromargb 100 215 185--color para los elementos afectados del listado de la derecha
		local dgAffectedBySomeBackColor = (dotNetClass "System.Drawing.Color").fromargb 195 230 160
		local dgNoExcludePropertyColor = (dotNetClass "System.Drawing.Color").fromargb 200 200 200
		
		---------------------------------------------------------------------------------------
		
		local lastLightsCount = 0--backup del numero de luces de la escena
		local firstListNodes = #()--array para almacenar los nodos de la primera lista
		local secondListNodes = #()--array para almacenar los nodos de la segunda lista

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		---------------------------------------------------------------------------
		--@control | groupBox | grpGeneralOptions | Groupbox que contiene las opciones generales.
		--@control | dropDownList | ddlOrderFilter | Contiene 2 opciones para elegir si queremos hacer el include/exclude de lights a geometry o al reves.
		--@control | button | btnRefresh | Sirve para refrescar el interfaz de la tool.
		--@control | groupBox | grpFirstGridOptions | Groupbox que contiene las opciones de la primera tabla.
		--@control | button | btnSelect | Boton que utilizamos para seleccionar en la escena los objetos que tenemos seleccionados en la lista.
		--@control | button | btnGetSelected | Boton que utilizamos para seleccionar en la lista los objetos que tenemos seleccionados en la escena.
		--@control | chekbox | chkAutoSelect | CheckButton que utilizamos para seleccionar automaticamente.
		--@control | dotNetControl | dgListFirst | Se utiliza para rellenar la primera tabla.
		--@control | gropuBox | grpSecondGridOptions | Groupbox que contiene las opciones de la primera tabla.
		--@control | colorpicker | clrAffectedItems | Color que nos sirve para identificar los items afectados.
		--@control | label | lblAffectedItems | Contiene el texto indicandonos que significa el color.
		--@control | colorpicker | clrSomeAffectedItems | Color que nos sirve para identificar los items afectados por diferentes sulces.
		--@control | label | lblSomeAffectedItems | Contiene el texto indicandonos que significa el color.
		--@control | dotNetControl | dgListSecond | Se utiliza para rellenar la segunda tabla.
		---------------------------------------------------------------------------

		groupbox grpGeneralOptions "" pos:[5,-1] width:540 height:28
		dropdownList ddlOrderFilter "" pos:[5,5] width:130 height:15 items:#("Lights >> Geometry", "Geometry >> Lights") default:1
		button btnRefresh "Refresh" pos:[495,6] width:50 height:20

		groupbox grpFirstGridOptions "" pos:[5,30] width:267 height:30
		button btnSelect "Select" pos:[10,40] width:50 height:20 toolTip:"Selects in scene the selected list items."
		button btnGetSelected "Get selected" pos:[65,40] width:80 height:20 toolTip:"Selects in the list selected scene items."
		checkbox chkAutoSelect "Autoselect" pos:[165,42] width:80 toolTip:"Selects automatically listed selected items."
		dotNetControl dgListFirst "System.Windows.Forms.DataGridView" pos:[5,60] width:268 height:285

		groupbox grpSecondGridOptions "" pos:[277,30] width:267 height:30
		colorpicker clrAffectedItems "" color:[100,215,185] pos:[278,40] width:20 height:15 enabled:false
		label lblAffectedItems "Affected items" pos:[302,42]
		colorpicker clrSomeAffectedItems "" color:[195,230,160] pos:[378,40] width:20 height:15 enabled:false
		label lblSomeAffectedItems "Affected by some items" pos:[402,42]
		dotNetControl dgListSecond "System.Windows.Forms.DataGridView" pos:[277,60] width:268 height:285
		
		timer tmClock interval:500 active:false

		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------


		------------------------------------------------
		--@fn: undefined | initGridView | Inicia el grid para poder rellenarlo.
		------------------------------------------------
		fn initGridView dg =
		(
			dg.rows.clear()
			dg.columns.clear()
			
			dg.allowUsertoaddRows = false
			dg.allowUserToResizeRows = false
			dg.allowUserToResizeColumns = true
			
			dg.columnHeadersVisible = true --para que las colunas tengan titulo
			dg.rowheadersvisible = false --para que las filas no tengan titulo
			
			dg.foreColor = (dotNetClass "System.Drawing.Color").black
			dg.backgroundcolor = dgForeColor -- color del fondo
			dg.rowsdefaultcellstyle.backcolor = dgForeColor --color por defecto de las celdas
			dg.GridColor = dgForeColor
			
			dg.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5					
			
			dg.readonly = true
			dg.showCellTooltips = false
			
			dg.selectionMode = (dotnetClass "System.Windows.Forms.DataGridViewSelectionMode").FullRowSelect
			
			dg.columns.add "" "Name" --pone una columna
			dg.columns.item[0].width = dg.width - 22 --hace la columna del ancho del listado
		)


		------------------------------------------------
		--@fn: undefined | fillGridView | Rellena el grid con los nombres pasados en el parametro nodes, detecta si los nodos son luces o geometria. La variable gridSide nos indica si es el grid de la izquiera o el de la derecha.
		------------------------------------------------
		fn fillGridView dg nodes gridSide:#left =
		(
			dg.rows.clear()--borra las filas
			areLights = if superClassOf nodes[1] == light then true else false --averigua si los nodos son luces
			
			if gridSide == #left then
			(
				if areLights then dg.columns.item[0].HeaderText = "Scene Lights"
				else dg.columns.item[0].HeaderText = "Scene Objects"
			)
			else
			(
				if areLights then dg.columns.item[0].HeaderText = "Scene Lights"
				else dg.columns.item[0].HeaderText = "Scene Objects"
			)
			
			for i=1 to nodes.count do --rocorre nodes rellenando con su nombre cada fila
			(
				row = (dotnetobject "System.Windows.Forms.DataGridViewRow") --crea una nueva fila
				row.height = 15
				bgColor = dgBackColor
				if areLights and not isProperty nodes[i] "excludeList" then
					bgColor = dgNoExcludePropertyColor
				
				row.defaultCellStyle.BackColor = bgColor
				
				dg.rows.add row--añade la fila

				rowText = nodes[i].name --pone el nombre del nodo
				
				if areLights and not isProperty nodes[i] "excludeList" then --si son luces hay que añadir al texto si no tiene propiedad include/exclude
					rowText += " <<No include/exclude property>>"				
				
				(dg.item 0 (i-1)).value = rowText
						
				if gridSide != #left then --si es el grid derecho
					(dg.item 0 (i-1)).selected = false --deselecciona la fila inicialmente
			) --for nodes
		)


		------------------------------------------------
		--@fn: undefined | updateAffectedItemsColor | Actualiza el color de las filas del listado de la derecha en funcion de si son afectados o no por los elementos de la derecha.
		------------------------------------------------
		fn updateAffectedItemsColor =
		(
			currentSelRows = #()
			currentSelRows = for i=1 to dgListFirst.selectedRows.count collect (rollMainDef.dgListFirst.selectedRows.item[i-1].index + 1) --obtiene los elementos seleccionados del listado de la izquierda (solo los indices)
			sort currentSelRows
			
			affectedItemsIndex = #() --array para almacenar los elementos del listado de la derecha que son afectados por los de la izquierda
			nonAffectedItemsIndex = #() --array para almacenar los elementos de la derecha que no son afectados por alguno de los elementos seleccionados de la izquierda
			affectedBySomeIndex = #() --array para almacenar los elementos del listado de la derecha que son afectados por alguno de los seleccionados a la izquierda
			
			if currentSelRows.count != 0 then --si hay elementos seleccionados en el listado de la izquierda
			(
				nonAffectedStyle = dotnetObject "System.Windows.Forms.DataGridViewCellStyle" --estilo de elementos no afectados
				nonAffectedStyle.backColor = dgBackColor
				
				someAffectedStyle = dotnetObject "System.Windows.Forms.DataGridViewCellStyle" --estilo de elementos afectados solo por alguno de los seleccionados a la izquierda
				someAffectedStyle.backColor = dgAffectedBySomeBackColor
				
				areLights = if superClassOf firstListNodes[currentSelRows[1]] == light then true else false --averigua si los elementos del listado de la izquierda son luces
				
				for i in currentSelRows do --recorre los elementos seleccionados en el listado de la izquierda
				(
					currentLeftNode = firstListNodes[i]
					
					if areLights then --si el listado de la izquierda es de luces 
					(
						if isProperty currentLeftNode "excludeList" then --si la luz tiene propiedad exclude
						(
							if currentLeftNode.excludeList != undefined then --si la luz está en estado exclude
							(
								for j=1 to secondListNodes.count do --recorre los nodos de la derecha
								(
									index = findItem currentLeftNode.excludeList secondListNodes[j] --mira a ver si esta en el listado de exclude
									
									if index == 0 then --si no esta en el listado de excludes quiere decir que es afectado
										appendIfUnique affectedItemsIndex j
									else --si no esta afectado lo almacenamos en el listado de no afectados
										appendIfUnique nonAffectedItemsIndex j
								) --for secondListNodes
							)
							else if currentLeftNode.includeList != undefined then --si la luz está en estado include
							(
								for j=1 to secondListNodes.count do
								(
									index = findItem currentLeftNode.includeList secondListNodes[j]
									
									if index != 0 then --si esta en el listado de includes, es decir que está afectado
										appendIfUnique affectedItemsIndex j
									else --si no esta afectado lo almacenamos en el listado de no afectados
										appendIfUnique nonAffectedItemsIndex j
								) --for secondListNodes
							) --if else currentLeftNode
						) --if isProperty
						else --si no es propiedad afecta a todos los objetos
						(
							affectedItemsIndex = for i=1 to secondListNodes.count collect i
						) --if isProperty
					)
					else --si el listado de la izquierda es de geometria 
					(
						for i=1 to secondListNodes.count do --recorre los elementos del listado de la derecha mirando en cuales está incluido el objeto de la izquierda
						(
							if isProperty secondListNodes[i] "excludeList" then --si la luz tiene propiedad exclude
							(
								if secondListNodes[i].excludeList != undefined then --si la luz está en estado exclude
								(
									if findItem secondListNodes[i].excludeList currentLeftNode == 0 then
										appendIfUnique affectedItemsIndex i
									else --si no esta afectado lo almacenamos en el listado de no afectados
										appendIfUnique nonAffectedItemsIndex i
								)
								else if secondListNodes[i].includeList != undefined then --si la luz está en estado include
								(
									if findItem secondListNodes[i].includeList currentLeftNode != 0 then
										appendIfUnique affectedItemsIndex i
									else --si no esta afectado lo almacenamos en el listado de no afectados
										appendIfUnique nonAffectedItemsIndex i
								) --if else		
							) --if isProperty
							else --si no tiene propiedad exclude debe representarla en verde porque si que le afecta a los objetos
							(
								appendIfUnique affectedItemsIndex i
							) --if isProperty
						) --for
					) --if else areLights
				) --for currentSelRows
				
				sort affectedItemsIndex --ordena el listado de indices a colorear
				sort nonAffectedItemsIndex --ordena el listado de indices de elementos no afectados
				
				for i=1 to nonAffectedItemsIndex.count where findItem affectedItemsIndex nonAffectedItemsIndex[i] != 0 do --averigua que elementos estan afectados por unas y por otras no
					appendIfUnique affectedBySomeIndex nonAffectedItemsIndex[i]
				
				for i=1 to dgListSecond.rows.count do --bucle para poner el color por defectoa las filas del listado de la derecha
				(
					dgListSecond.rows.item[i - 1].selected = false
					dgListSecond.rows.item[i - 1].defaultCellStyle.backColor = dgAffectedItemBackColor --affectedStyle
					
					if findItem affectedBySomeIndex i != 0 then
						dgListSecond.rows.item[i - 1].defaultCellStyle = someAffectedStyle
					else if findItem affectedItemsIndex i == 0 then
						dgListSecond.rows.item[i - 1].defaultCellStyle = nonAffectedStyle
				) --for
			) --if currentSelRows
		)


		------------------------------------------------
		--@fn: undefined | resetGridViews | Resetea los listados y los rellena.
		------------------------------------------------
		fn resetGridViews =
		(
			allLights = lb.lights.getSceneLights orderFilter:#name --obtiene las luces
			allGeometry = geometry as array --obtiene toda la geometria de la escena
			
			_bones = getClassInstances BoneGeometry --obtiene los huesos de la escena
			_bones = for b in _bones collect (refs.dependentnodes b firstOnly:true)
			
			for b in _bones do --elimina del array de geometria los huesos
			(
				_index = findItem allGeometry b
				if _index != 0 then deleteItem allGeometry _index
			)--for
			
			allGeometry = lb.misc.sortNodesByName allGeometry --ordena los nodos por nombre
			
			case ddlOrderFilter.selection of
			(
				1: --Luces Primero (Luces>>Geometria)
				(
					firstListNodes = allLights --almacena los nodos del primer listado
					secondListNodes = allGeometry --almacena los nodos del segundo listado
					
					fillGridView dgListFirst allLights --llena el listado de la izquierda
					fillGridView dgListSecond allGeometry gridSide:#right --llena el listado de la derecha
					updateAffectedItemsColor() --colorea los elementos afectados del listado de la derecha
				)--1
				
				2: --Geometria Primero (Geometria>>Luces)
				(
					firstListNodes = allGeometry --almacena los nodos del primer listado
					secondListNodes = allLights --almacena los nodos del segundo listado
					
					fillGridView dgListFirst allGeometry --llena el listado de la izquierda
					fillGridView dgListSecond allLights gridSide:#right --llena el listado de la derecha
					updateAffectedItemsColor() --colorea los elementos afectados del listado de la derecha
				)--2
			)--case
		)

		------------------------------------------------
		--@fn: undefined | toggleSelItemsAffectedState | Cambia el estado de los elementos seleccionados (si el elemento estaba excluido pasa a estar incluido y viceversa).
		------------------------------------------------
		fn toggleSelItemsAffectedState =
		(
			firstListSelIndexes = #()
			firstListSelIndexes = for i=1 to dgListFirst.selectedRows.count collect (rollMainDef.dgListFirst.selectedRows.item[i-1].index + 1) --obtiene los elementos seleccionados del listado de la izquierda (solo los indices)
			sort firstListSelIndexes
			
			if firstListSelIndexes.count != 0 then --si hay elementos seleccionados en el listado de la izquierda
			(
				secondtListSelIndexes = #()
				secondtListSelIndexes = for i=1 to dgListSecond.selectedRows.count collect (rollMainDef.dgListSecond.selectedRows.item[i-1].index + 1) --obtiene los elementos seleccionados del listado de la derecha
				sort secondtListSelIndexes
				
				areLights = if superClassOf firstListNodes[firstListSelIndexes[1]] == light then true else false --averigua si los elementos del listado de la izquierda son luces
				
				newState = undefined --nuevo estado al que poner los objetos del listado de la derecha
				
				if areLights then --si el listado de la izquierda es de luces
				(
					for i=1 to secondtListSelIndexes.count do --recorre los elementos del listado de la derecha cambiando su estado de include a exclude en los elementos de la izquierda, o viceversa
					(
						currRightItem = secondListNodes[secondtListSelIndexes[i]] --obtiene el elemento actual del listado de la derecha
						
						for j=1 to firstListSelIndexes.count do --recorre los elementos del listado de la izquierda
						(
							currLeftItem = firstListNodes[firstListSelIndexes[j]] --obtiene el elemento actual del listado de la izquierda
							
							if isProperty currLeftItem "excludeList" then
							(
								if currLeftItem.excludeList != undefined then --si esta en modo exclude
								(
									if newState == undefined then --si aun no sabemos si hay que incluir o excluir el objeto
										newState = if (findItem currLeftItem.excludeList currRightItem) != 0 then #include else #exclude
									
									case newState of --introduce o saca el objeto de la lista de exclusion
									(
										#exclude: --añade el elemento del listado derecho a la exclusion
										(
											templist = currLeftItem.excludeList
											appendIfUnique templist currRightItem
											currLeftItem.excludeList = templist
										)--#exclude
										
										#include:
										(
											templist = currLeftItem.excludeList
											index = findItem templist currRightItem
											if index != 0 then
											(
												deleteItem templist index
												currLeftItem.excludeList = templist
											)--if index
										)--#include
									)--case newState
								)
								else if currLeftItem.includeList != undefined then --si esta en modo include
								(
									if newState == undefined then --si aun no sabemos si hay que incluir o excluir el objeto
										newState = if (findItem currLeftItem.includeList currRightItem) != 0 then #exclude else #include
									
									case newState of --introduce o saca el objeto de la lista de inclusion
									(
										#include:
										(
											templist = currLeftItem.includeList
											appendIfUnique templist currRightItem
											currLeftItem.includeList = templist
										) --#exclude
										
										#exclude:
										(
											templist = currLeftItem.includeList
											index = findItem templist currRightItem
											if index != 0 then 
											(
												deleteItem templist index
												currLeftItem.includeList = templist
											)--if index
										)--#include
									)--case newState
								)--if else
							)--if isProperty
						)--for firstListSelIndexes
					)--for secondtListSelIndexes
				)
				else --si el listado de la izquierda es de geometria
				(
					for i=1 to firstListSelIndexes.count do --recorre los elementos del listado de la izquierda cambiando su estado de include a exclude en los elementos de la derecha, o viceversa
					(
						currLeftItem = firstListNodes[firstListSelIndexes[i]] --obtiene el elemento actual del listado de la izquierda
						
						for j=1 to secondtListSelIndexes.count do --recorre los elementos del listado de la derecha
						(
							currRightItem = secondListNodes[secondtListSelIndexes[j]] --obtiene el elemento actual del listado de la derecha
							
							if isProperty currRightItem "excludeList" then
							(
								if currRightItem.excludeList != undefined then --si esta en modo exclude
								(
									if newState == undefined then --si aun no sabemos si hay que incluir o excluir el objeto
										newState = if (findItem currRightItem.excludeList currLeftItem) != 0 then #include else #exclude
									
									case newState of --introduce o saca el objeto de la lista de exclusion
									(
										#exclude: --añade el elemento del listado derecho a la exclusion
										(
											templist = currRightItem.excludeList
											appendIfUnique templist currLeftItem
											currRightItem.excludeList = templist
										)--#exclude
										
										#include: --quita el elemento del listado de la derecha a la exclusion
										(
											templist = currRightItem.excludeList
											index = findItem templist currLeftItem
											if index != 0 then 
											(
												deleteItem templist index
												currRightItem.excludeList = templist
											)--if index
										)--#include
									)--case newState
								)
								else if currRightItem.includeList != undefined then --si esta en modo include
								(
									if newState == undefined then --si aun no sabemos si hay que incluir o excluir el objeto
										newState = if (findItem currRightItem.includeList currLeftItem) != 0 then #exclude else #include
									
									case newState of --introduce o saca el objeto de la lista de inclusion
									(
										#include: --añade el elemento del listado derecho a la inclusion
										(
											templist = currRightItem.includeList
											appendIfUnique templist currLeftItem
											currRightItem.includeList = templist
										)--#exclude
										
										#exclude: --quita el elemento del listado de la derecha a la inclusion
										(
											templist = currRightItem.includeList
											index = findItem templist currLeftItem
											if index != 0 then
											(
												deleteItem templist index
												currRightItem.includeList = templist
											)--if index
										)--#include
									)--case newState
								)--if else
							)--if isProperty
						)--for secondtListSelIndexes
					)--for firstListSelIndexes
				)--if areLights
			)--if firstListSelIndexes
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
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.addscript #filePostOpenProcess 	"lb.lightIncludeExcludeManager.rollMain.resetGridViews()" id:_id
			callbacks.addscript #filePostMerge 				"lb.lightIncludeExcludeManager.rollMain.resetGridViews()" id:_id
			callbacks.addscript #systemPostReset 		"lb.lightIncludeExcludeManager.rollMain.resetGridViews()" id:_id
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.removescripts id:_id
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
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)

			--almacena settings
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "listOrder" (ddlOrderFilter.selection as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "autoSelect" (chkAutoSelect.checked as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(	
			--tamaño
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
			
			--options
			ddlOrderFilter.selection = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "listOrder") as integer
			if ddlOrderFilter.selection == 0 then ddlOrderFilter.selection = 1

			chkAutoSelect.checked = (lb.xml.getAttribute parent.cfgFile ("rollMain/options") "autoSelect") == "true"	

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
		--@event: tick | Si el numero de luces de la escena ha cambiado resetea los listados.
		------------------------------------------------	
		on tmClock tick do
		(
			if lights.count != lastLightsCount do
			(
				lastLightsCount = lights.count
				resetGridViews()
			)
		)
		
		------------------------------------------------
		--@event: cellMouseUp | Actualiza el coloreado de los elementos del listado de la derecha en funcion de la selecion de la lista de la izquierda.
		------------------------------------------------
		on dgListFirst cellMouseUp events do
		(
			updateAffectedItemsColor()--actualiza el color de los elementos afectados
			
			if chkAutoSelect.checked then --solo si está activada la opcion de autoselect
			(
				currentSelRows = #() --selecciona en la escena los elementos seleccionados en el listado de la izquierda
				currentSelRows = for i=1 to dgListFirst.selectedRows.count collect (rollMainDef.dgListFirst.selectedRows.item[i-1].index + 1)--obtiene los elementos seleccionados del listado de la izquierda (solo los indices)
				sort currentSelRows
				
				_objsToSelect = for i in currentSelRows collect firstListNodes[i]
				select _objsToSelect
			)
			------------------------------------------------------------------------------------------------------------------------------
		)
		
		------------------------------------------------
		--@event: cellMouseUp | Actualiza el estado de la exclusion o inclusion de los elementos del listado de la derecha segun la seleccion, si seleccionas algun elemento del listado de la derecha invierte su estado de include/exclude.
		------------------------------------------------
		on dgListSecond cellMouseUp events do
		(
			toggleSelItemsAffectedState() --cambia el estado de los objetos del listado de la derecha de include a exclude o viceversa
			
			updateAffectedItemsColor() --actualiza el color de las celdas
			completeRedraw() --redibuja el viewport
		)

		------------------------------------------------
		--@event: selected |Cambio de opcion de representacion de los listados.
		------------------------------------------------		
		on ddlOrderFilter selected item do
			resetGridViews()
		
		------------------------------------------------
		--@event: pressed | Selecciona en la escena los elementos seleccionados del listado de la izquierda.
		--@control | button | btnSelect | Boton que utilizamos para seleccionar en la escena los objetos que tenemos seleccionados en la lista.
		------------------------------------------------
		on btnSelect pressed do
		(
			undo "Select: Include/Exclude Manager" on
			(
				clearSelection() --limpia la seleccion de la escena
				
				for i=1 to dgListFirst.rows.count where dgListFirst.rows.item[i-1].selected do--recorre el listado de la izquierda seleccionando los objetos de la ecena que esten seleccionados en el listado
					selectMore firstListNodes[i]
			)
			updateAffectedItemsColor() --actualiza el color de las celdas
		)
		
		------------------------------------------------
		--@event: pressed | Selecciona en el listado de la izquierda los elementos seleccionados en el viewport.
		--@control | button | btnGetSelected | Boton que utilizamos para seleccionar en la lista los objetos que tenemos seleccionados en la escena.
		------------------------------------------------
		on btnGetSelected pressed do
		(
			if selection.count != 0 then --si hay elementos seleccionados en el viewport
			(
				for i=1 to dgListFirst.rows.count do --deselecciona todos los elementos del listado de la izquierda
					dgListFirst.rows.item[i-1].selected = false
				
				for obj in selection do --recorre los elementos seleccionados
				(
					index = findItem firstListNodes obj --busca el objeto en el listado de la izqiuerda
					if index != 0 then --si lo encuentra lo selecciona y se asegura que está visible
					(
						dgListFirst.rows.item[index-1].selected = true
						dgListFirst.FirstDisplayedCell = dgListFirst.item 0 (index-1)
					)--if
				)--for
				
				updateAffectedItemsColor() --actualiza el color de las celdas
			)--if selection
		)
		
		------------------------------------------------
		--@event: pressed | Refresca la herramienta.
		--@control | button | btnRefresh | Sirve para refrescar el interfaz de la tool.
		------------------------------------------------
		on btnRefresh pressed do
		(
			completeRedraw() --redibuja los viewports para ver los cambios
			resetGridViews() --resetea los listados y los rellena	
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
				grpGeneralOptions.width = size.x - 10
				btnRefresh.pos.x = size.x - 55
				
				grpFirstGridOptions.width = grpSecondGridOptions.width = size.x/2.0 - 8
				dgListFirst.width = dgListSecond.width = size.x/2.0 - 8
							
				dgListSecond.pos.x = grpSecondGridOptions.pos.x = size.x/2.0 + 2
				clrAffectedItems.pos.x = size.x/2.0 + 7
				lblAffectedItems.pos.x = size.x/2.0 + 27
				clrSomeAffectedItems.pos.x = size.x/2.0 + 110
				lblSomeAffectedItems.pos.x = size.x/2.0 + 130
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				dgListFirst.height = dgListSecond.height = size.y - 65
			)--if
			------------------------------------------------------------------------------
		)

	
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			initGridView dgListFirst
			initGridView dgListSecond
			loadSettings()
			resetGridViews()
			--createSceneEvents() --crea los callbacks
			--tmClock.active = true
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
	--@struct: lightIncludeExcludeManager | Contiene la herramienta lightIncludeExcludeManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_lightIncludeExcludeManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #lighting,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool lightIncludeExcludeManager",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_lightIncludeExcludeManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_lightIncludeExcludeManager() --crea la herramienta
)