------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Node Set Manager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta del gestor de nodeSets.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "nodeSets Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 350	--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 400	--@var: minRollHeight | Alto mínimo de la herramienta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		--local multiSelectTreeview = dotnet.loadAssembly (lb.config.getAssembliesPath() + "CodersLab.Windows.Controls.TreeView.dll")
		local iconpath = lb.config.getIconsPath() --@var : iconpath | Ruta de iconos de las herramientas
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
			
		local rMenu = dotnetObject "System.Windows.Forms.ContextMenuStrip" --@control: rMenu | Menu de boton derecho para las opciones del arbol de nodeSets.
			
		button btnSeparator01 "|" pos:[100,1] width:20 height:20 border:false enabled:false
		button btnSeparator02 "|" pos:[180,1] width:20 height:20 border:false enabled:false
		button btnSeparator03 "|" pos:[235,1] width:20 height:20 border:false enabled:false
		
		button btnNewNodeSet "" pos:[10,3] width:20 height:20 border:false toolTip:"New empty nodeSet" images:#(iconPath + "AnimLayerToolbar_16i.bmp", undefined, 12, 1, 1, 1, 1, true) --@control: btnNewNodeSet | Boton para crear un nuevo nodeSet.
		button btnNewNodeSetSelObjects "" pos:[35,3] width:20 height:20 border:false toolTip:"New nodeSet with selected objects" images:#(iconPath + "AnimLayerToolbar_16i.bmp", undefined, 12, 2, 2, 2, 2, true) --@control: btnNewNodeSetSelObjects | Boton para crear un nuevo nodeSet con los objetos seleccionados.
		button btnDuplicateSelNodeSets "" pos:[60,3] width:20 height:20 border:false toolTip:"Duplicate nodeSets selected nodeSets" images:#(iconPath + "AnimLayerToolbar_16i.bmp", undefined, 12, 10, 10, 10, 10, true) --@control: btnDuplicateSelNodeSets | Boton para duplicar  nodeSets.
		button btnDeleteSelNodeSets "" pos:[85,3] width:20 height:20 border:false toolTip:"Delete selected nodeSets" images:#(iconPath + "AnimLayerToolbar_16i.bmp", undefined, 12, 6, 6, 6, 6, true) --@control: btnDeleteSelNodeSets | Boton para eliminar nodeSets
			
		button btnAddSelObjectsToSelNodeSets "" pos:[115,3] width:20 height:20 border:false toolTip:"Add selected objets" images:#(iconPath + "Containers_16i.bmp", undefined, 17, 2, 2, 2, 2, true) --@control: btnAddSelObjectsToSelNodeSets | Boton para añadir los objetos seleccionados a los nodeSets seleccionados.
		button btnRemoveSelObjectsFromSelNodeSets "" pos:[140,3] width:20 height:20 border:false toolTip:"Remove selected objets" images:#(iconPath + "Containers_16i.bmp", undefined, 17, 12, 12, 12, 12, true) --@control: btnRemoveSelObjectsFromSelNodeSets | Boton para eliminar los objetos seleccionados de los nodeSets seleccionados.
		button btnClearSelNodeSets "" pos:[165,3] width:20 height:20 border:false toolTip:"Clear selected nodeSets" images:#(iconPath + "Containers_16i.bmp", undefined, 17, 6, 6, 6, 6, true) --@control: btnClearSelNodeSets | Boton para eliminar todo el contenido de los nodeSets seleccionados.
			
		button btnHighlightSelNodeSetsObjects "" pos:[195,3] width:20 height:20 border:false toolTip:"Select Objects in scene" images:#(iconPath + "LayerManager_i.bmp", undefined, 13, 4, 4, 4, 4, true) --@control: btnHighlightSelNodeSetsObjects | Boton para seleccionar los objetos de los nodeSets seleccionados.
		button btnHighlightSelObjectsNodeSets "" pos:[220,3] width:20 height:20 border:false toolTip:"Highlight nodeSets by selection" images:#(iconPath + "LayerManager_i.bmp", undefined, 13, 8, 8, 8, 8, true) --@control: btnHighlightSelObjectsNodeSets | Boton seleccionar los nodeSets donde están los objetos seleccionados.
		
		button btnLoadNodeSets "Load" pos:[250,3] width:20 height:20 border:false images:#(iconpath + "bip_general_i.bmp", undefined, 30, 5, 5, 6, 6,true) tooltip:"Load nodeSets" --@control: btnLoadNodeSets | Boton para cargar nodeSets de otro archivo
		button btnSaveNodeSets "Save" pos:[275,3] width:20 height:20 border:false images:#(iconpath + "bip_general_i.bmp", undefined, 30, 7, 7, 8, 8,true) tooltip:"Save nodeSets" --@control: btnSaveNodeSets | Boton para salvar nodeSets en un archivo.
		button btnImportFromSelSets "ImportFromSelSets" pos:[300,3] width:20 height:20 border:false images:#(iconpath + "ParameterCollector_i.bmp", undefined, 28, 11, 11, 11, 11, true) tooltip:"Import from selection sets" --@control: btnImportFromSelSets | Boton para importar los selection sets como nodeSets.
		button btnExportToSelSets "ExportToSelSets" pos:[325,3] width:20 height:20 border:false images:#(iconpath + "ParameterCollector_i.bmp", undefined, 28, 10, 10, 10, 10,true) tooltip:"Export to selection sets" --@control: btnExportToSelSets | Boton para exportar los nodeSets a selection sets.

		timer tmrRefresh interval:500 active:true
		
		local rtbCaptionEditor = dotNetObject "System.Windows.Forms.richtextbox" --@control: rtbCaptionEditor | Cuadro de edicion para los nombres de los nodeSets

		dotNetControl trvNodeSets "CodersLab.Windows.Controls.TreeView" pos:[5,25] width:340 height:350 --@control: trvNodeSets | Arbol de representación de nodeSets.
		edittext edtNodeSetName "" pos:[1,377] width:344 enabled:false --@control: edtNodeSetName | Cuadro de edicion para renombrar nodeSets.
			
		--dotNetControl rMenu "System.Windows.Forms.ContextMenuStrip" pos:[0,0] width:60 height:14 --@control: rMenu | Menu de boton derecho para las opciones del arbol de nodeSets.
			
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
		--@fn: undefined | initControls | Rellena la información necesaria para trabajar y pinta el interface con esos datos
		------------------------------------------------
		fn initControls =
		(
			trvNodeSets.selectionMode = trvNodeSets.selectionMode.MultiSelectSameLevel --habilita la multiseleccion
			trvNodeSets.LabelEdit = false --true --habilita la opción de modificar los labels de los nodos
			trvNodeSets.AllowDrop = true --habilita el drag & drop
			
			--establece los colores por defecto de fondo y elementos
			trvNodeSets.backColor = (dotNetClass "System.Drawing.Color").fromargb 50 50 50
			trvNodeSets.foreColor = (dotNetClass "System.Drawing.Color").lightgray
			
			--establece la fuente del treeview
			trvNodeSets.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 9
			
			--añade el evento al menu
			dotnet.addEventHandler rMenu "itemClicked" rollMainDef.rMenuItemclickedEvent

			------------------------------------------------
			--cuadro de edicion de nombres de nodeSets
			
			--establece las propiedades iniciales del cuadro de edicion de nombres de contenedores
			rtbCaptionEditor.readonly = false
			rtbCaptionEditor.backcolor = (dotNetClass "System.Drawing.Color").white
			rtbCaptionEditor.parent = trvNodeSets
			
			global _tempParentNameNodeSetManager = parent.className
			dotnet.removeAllEventHandlers rtbCaptionEditor
			dotnet.addEventHandler rtbCaptionEditor "lostFocus" (fn losfFocusEvent self events = ((lb.getTool _tempParentNameNodeSetManager).rtbCaptionEditorLostFocusEvent self events))
			dotnet.addEventHandler rtbCaptionEditor "keyUp" (fn losfFocusEvent self events = ((lb.getTool _tempParentNameNodeSetManager).rtbCaptionEditorKeyUpEvent self events))
				
			rtbCaptionEditor.hide()
			------------------------------------------------
		)
		
		------------------------------------------------
		--@fn: undefined | fillTrvNodeSets | Rellena el arbol de nodeSets
		------------------------------------------------
		fn fillTrvNodeSets =
		(
			trvNodeSets.nodes.clear() --vacía el arbol
			
			--recorre los nodeSets de la escena y los añade al árbol
			for ns in parent.sceneNodeSets do
			(
				--añade el nodeSet actual al árbol
				_nodeSet = trvNodeSets.nodes.add (ns.getCaption())
				_nodeSet.backColor = (dotNetClass "System.Drawing.Color").fromargb 70 70 70
				ns.setUiObj(_nodeSet)
			
				--si el nodeSet tiene objetos almacenados, los añade al arbol
				for nsn in (ns.getNodesNames()) do _nodeSet.nodes.add nsn				
			)--for
		)
	
		------------------------------------------------
		--@fn: undefined | fillInfo | Rellena la información necesaria para trabajar y pinta el interface con esos datos
		------------------------------------------------
		fn fillInfo =
		(
			parent.fillSceneNodeSets() --obtiene los nodesets de la escena y los almacena en la herramienta
			fillTrvNodeSets() --rellena el arbol de nodeSets
		)
		
		------------------------------------------------
		--@event | itemclicked | Evento que se lanza al levantar el raton despues de hacer click o click derecho.
		--@control: System.Windows.Forms.ContextMenuStrip | rMenu | Menu de boton derecho.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		fn rMenuItemclickedEvent self events =
		(
			_itemName = (events.clickeditem.tostring())
			parent.menuItemClickedProcess _itemName
		)
		
		------------------------------------------------
		--@fn: undefined | createRMenu | Rellena el menu de boton derecho en función de la opcion.
		--@gets: point2 | pos | Posición en la que debe dibujarse el menu.
		--@gets: name | menuType | Tipo de menu, qugete marca cuales serán los elementos internos del menu. Opciones -> #nodeSets, #nodes, #default
		------------------------------------------------
		fn createRMenu pos menuType =
		(
			_rMenuItems = #() --array para almacenar los items del menu
			
			rMenu.items.clear() --vacía el menú
			rMenu.rendermode = (dotnetclass "System.Windows.Forms.ToolStripRenderMode").system --elige el modo de dibujado del menu
			
			case menuType of
			(
				#nodeSets:
				(
					--rellena el array de items con todas las opciones
					append _rMenuItems "Rename nodeSet"
					append _rMenuItems "Duplicate nodeSets"
					append _rMenuItems "Remove nodeSets"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")					
					append _rMenuItems "Expand Selected"					
					append _rMenuItems "Collapse Selected"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")				
					append _rMenuItems "Add selected scene objects"
					append _rMenuItems "Select objects in scene" 					
					append _rMenuItems "Remove selected scene objects"
					append _rMenuItems "Clear (empty selected nodeSets)"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")
					append _rMenuItems "Paste objects"
					
					--añade todos los items al menú
					for i = 1 to _rMenuItems.count do rMenu.items.add _rMenuItems[i]
					
					--Inhabilita las opciones que no puedan ser utilizadas
					--rMenu.items.item[0].enabled = (parent.rollMain.trvNodeSets.selectedNodes.count == 1)
					rMenu.items.item[12].enabled = (parent.copyBuffer.count != 0)					
				)--nodeSets
				
				#nodes:
				(
					--rellena el array de items con todas las opciones
					append _rMenuItems "Select in scene"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")
					append _rMenuItems "Copy objects"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")
					append _rMenuItems "Remove objects"
					
					--añade todos los items al menú
					for i = 1 to _rMenuItems.count do rMenu.items.add _rMenuItems[i]				
				)--nodes
				
				#default:
				(
					append _rMenuItems "Expand All"					
					append _rMenuItems "Collapse All"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")
					append _rMenuItems "New empty nodeSet"
					append _rMenuItems "New nodeSet with selected objects"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")
					append _rMenuItems "Highlight nodeSets by selection"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")
					append _rMenuItems "Import selection sets"
					append _rMenuItems "Export to selection sets"
					append _rMenuItems "Load nodeSets from file"
					append _rMenuItems "Save nodeSets to file"
					
					--añade todos los items al menú
					for i = 1 to _rMenuItems.count do rMenu.items.add _rMenuItems[i]	
				)--default
			)
			
			rMenu.Show pos.x pos.y --muestra el menú
		)
		
		--------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout.
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			
			callbacks.addscript #filePostMerge "lb.nodeSetManager.rollMain.fillInfo()" id:_id
			callbacks.addscript #filePostOpenProcess "lb.nodeSetManager.rollMain.fillInfo()" id:_id
			callbacks.addscript #nodeRenamed "lb.nodeSetManager.refreshNodeSetsNodesNamesOnClockTick = true" id:_id
			callbacks.addscript #nodePostDelete "lb.nodeSetManager.removeDeletedNodesOnClockTick = true" id:_id

			callbacks.addScript #sceneUndo "lb.nodeSetManager.undoManagement()" id:_id
			--callbacks.addScript #sceneRedo "rollCamSequencer.updateExistingClips()" id:#_id
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout.
		------------------------------------------------
		fn removeSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			callbacks.removescripts id:_id
		)
		
		------------------------------------------------
		--@fn: undefined | resetSceneEvents | Destruye los callbacks relacionados con el rollout y los vuelve a crear.
		------------------------------------------------
		fn resetSceneEvents =
		(
			removeSceneEvents()
			createSceneEvents()
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
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMai/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
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
		--@event | tick | Evento cada vez que el timer sobrepasa el periodo del intervalo.
		--@control: timer | tmrRefresh | Timer que se ejecuta.
		------------------------------------------------
		on tmrRefresh tick do
		(
			if parent != undefined then
			(
				if parent.refreshOnClockTick then
				(--print "refresh"
					parent.refreshOnClockTick = false
					removeSceneEvents()
					parent.refreshTreeNodeSetNames()
					createSceneEvents()
				)--if

				else if parent.refreshNodeSetsNodesNamesOnClockTick then
				(--print "rename"
					parent.refreshNodeSetsNodesNamesOnClockTick = false
					removeSceneEvents()
					parent.refreshTreeNodeSetNodes()
					createSceneEvents()
				)--if

				else if parent.removeDeletedNodesOnClockTick then
				(--print "remove"
					undo off
					(
						parent.removeDeletedNodesOnClockTick = false
						removeSceneEvents()
						parent.refreshTrvNodeSets()
						createSceneEvents()
					)
				)--if

				else
				(
					_nodeSetInfoNodes = lb.nodeSets.getAllInfoNodes() --obtiene los objetos de la escena que contienen información de nodeSets

					if _nodeSetInfoNodes.count != parent.sceneNodeSets.count then --si el numero cambia es que se ha/n recuperado un/os nodeSet/s
					(
						removeSceneEvents()
						with undo off parent.fullNodeSetsPurge() --limpia el array de nodesets de la tool
						with undo off parent.rollMain.fillInfo() --redibuja el arbol
						createSceneEvents()
					)
				)--else
			)
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnNewNodeSet | Boton para crear un nodeSet vacio.
		------------------------------------------------
		on btnNewNodeSet pressed do
		(
			parent.menuItemClickedProcess "New empty nodeSet"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnNewNodeSetSelObjects | Boton para crear un nodeSet con los objetos seleccionados.
		------------------------------------------------
		on btnNewNodeSetSelObjects pressed do
		(
			parent.menuItemClickedProcess "New nodeSet with selected objects"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnDuplicateSelNodeSets | Boton para duplicar los nodeSets seleccionados.
		------------------------------------------------
		on btnDuplicateSelNodeSets pressed do
		(
			parent.menuItemClickedProcess "Duplicate nodeSets"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnDeleteSelNodeSets | Boton para eliminar los nodeSets seleccionados.
		------------------------------------------------
		on btnDeleteSelNodeSets pressed do
		(
			parent.menuItemClickedProcess "Remove nodeSets"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnAddSelObjectsToSelNodeSets | Boton para añadir los objetos seleccionados de la escena a los nodeSets seleccionados.
		------------------------------------------------
		on btnAddSelObjectsToSelNodeSets pressed do
		(
			parent.menuItemClickedProcess "Add selected scene objects"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnRemoveSelObjectsFromSelNodeSets | Boton para quitar los objetos seleccionados de la escena de los nodeSets seleccionados.
		------------------------------------------------
		on btnRemoveSelObjectsFromSelNodeSets pressed do
		(
			parent.menuItemClickedProcess "Remove selected scene objects"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnClearSelNodeSets | Boton para vaciar los nodeSets seleccionados.
		------------------------------------------------
		on btnClearSelNodeSets pressed do
		(
			parent.menuItemClickedProcess "Clear (empty selected nodeSets)"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnHighlightSelNodeSetsObjects | Boton para seleccionar los objetos de los nodeSets.
		------------------------------------------------
		on btnHighlightSelNodeSetsObjects pressed do
		(
			--si hay nodos seleccionados, comprueba de que nivel son para mostrar un menu u otro
			if trvNodeSets.selectedNodes.count != 0 then 
			(
				_level = (trvNodeSets.selectedNodes.item[0]).level

				case _level of
				(
					0: parent.menuItemClickedProcess "Select objects in scene"
					1: parent.menuItemClickedProcess "Select in scene"
				)--case
			)--if
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnHighlightSelObjectsNodeSets | Boton para seleccionar los nodeSets donde se encuetran los objetos seleccionados.
		------------------------------------------------
		on btnHighlightSelObjectsNodeSets pressed do
		(
			parent.menuItemClickedProcess "Highlight nodeSets by selection"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnLoadNodeSets | Boton para cargar los nodeSets de otra escena.
		------------------------------------------------
		on btnLoadNodeSets pressed do
		(
			parent.menuItemClickedProcess "Load nodeSets from file"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnSaveNodeSets | Boton para salvar los nodeSets el una archivo aparte.
		------------------------------------------------
		on btnSaveNodeSets pressed do
		(
			parent.menuItemClickedProcess "Save nodeSets to file"
		)
		
		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnImportFromSelSets | Boton para importar los selection sets.
		------------------------------------------------
		on btnImportFromSelSets pressed do
		(
			parent.menuItemClickedProcess "Import selection sets"
		)

		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnExportToSelSets | Boton para exportar los selection sets.
		------------------------------------------------
		on btnExportToSelSets pressed do
		(
			parent.menuItemClickedProcess "Export to selection sets"
		)

		------------------------------------------------
		--@event | MouseUp | Evento que se lanza al levantar el raton despues de hacer click o click derecho.
		--@control: CodersLab.Windows.Controls.TreeView | trvNodeSets | Arbol de nodeSets.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		on trvNodeSets MouseUp events do
		(
			_button = events.button.ToString() --averigua si es boton izquierdo, derecho o central
			_tool = (lb.getTool "nodeSetManager" category:#common)
			
			--en función del boton pulsado ha de realizar unas operaciones u otras
			case _button of
			(
				"Right": --boton derecho
				(
					_level = -1 --nivel del arbol en el que se han seleccionado nodos
					
					_clickedNode = trvNodeSets.GetNodeAt events.Location --mira en que nodo se ha hecho click
					if _clickedNode != undefined then --si se ha hecho click en un nodo averigua el nivel del nodo
					(
						--si hay nodos seleccionados, comprueba de que nivel son para mostrar un menu u otro
						if trvNodeSets.selectedNodes.count != 0 then 
						(
							if trvNodeSets.selectedNodes.count == 1 then --si solo hay uno seleccionado comprueba que se ha hecho click en el y no fuera
							(
								if _clickedNode.text == (trvNodeSets.selectedNodes.item[0]).text then --si es el mismo
									_level = (trvNodeSets.selectedNodes.item[0]).level								
							)
							else --si hay varios seleccionados averigua el nivel de la seleccion
							(
								_level = (trvNodeSets.selectedNodes.item[0]).level
							)--if
						)--if
					)--if					
					
					case _level of
					(
						0: createRMenu mouse.screenPos #nodeSets --lanza el menu de boton derecho de nodeSets
						1: createRMenu mouse.screenPos #nodes --lanza el menu de boton derecho de nodos en los nodeSets
						default: createRMenu mouse.screenPos #default --lanza el menu de boton derecho general
					)--case
				)--Right
			)--case			
		)
		
		------------------------------------------------
		--@event | AfterLabelEdit | Evento que se lanza al terminar de editar el nombre de un nodo
		--@control: CodersLab.Windows.Controls.TreeView | trvNodeSets | Arbol de nodeSets.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		on trvNodeSets AfterLabelEdit events do
		(
			parent.endEditing (events.Label)
		)
		
		------------------------------------------------
		--@event | AfterLabelEdit | Evento que se lanza al presionar una tecla sobre el arbol. Es para atajos de teclado
		--@control: CodersLab.Windows.Controls.TreeView | trvNodeSets | Arbol de nodeSets.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		on trvNodeSets KeyDown events do
		(
			_key = events.keyData.tostring()
			
			case _key of 
			(
				"F2":
				(				
					if not parent.nameEditing and trvNodeSets.selectedNodes.count == 1 then
					(
						if trvNodeSets.selectedNodes.item[0].Level == 0 then
						(
							parent.menuItemClickedProcess "Rename nodeSet"
						)
						else if trvNodeSets.selectedNodes.item[0].Level == 1 then
						(
							parent.menuItemClickedProcess "Rename object"
						)
					)--if
				)--f2
			)--case
		)
		
		on trvNodeSets DoubleClick event do
		(
			if not parent.nameEditing and trvNodeSets.selectedNodes.count == 1 then
			(
				if trvNodeSets.selectedNodes.item[0].Level == 0 then
				(
					parent.menuItemClickedProcess "Rename nodeSet"
				)
				else if trvNodeSets.selectedNodes.item[0].Level == 1 then
				(
					parent.menuItemClickedProcess "Rename object"
				)
			)--if
		)

		------------------------------------------------
		--@event | selectionsChanged | Evento que se lanza al cambiar la seleccion del treeview
		--@control: CodersLab.Windows.Controls.TreeView | trvNodeSets | Arbol de nodeSets.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		on trvNodeSets selectionsChanged events do
		(
			parent.selectionChanged()
		)
		
		------------------------------------------------
		--@event | entered | Evento que se lanza al presionar Enter en el cuadro de texto.
		--@control: edittext | edtNodeSetName | Cuadro de texto para ???.
		--@gets: string | value | Nuevo texto del cuadro.
		------------------------------------------------
		on edtNodeSetName entered value do
		(
			/*if trvNodeSets.selectedNodes.count == 1 then
				parent.endEditing edtNodeSetName.text
			else
			(
				messageBox "Yo must select one node to rename."
				edtNodeSetName.text = ""
			)*/
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event | resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMainDef | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(			
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento
			_increment = size - [minRollWidth, minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				trvNodeSets.width = size.x - 10
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				trvNodeSets.height = size.y - 50
				edtNodeSetName.pos.y = 377 + _increment.y
			)--if
			------------------------------------------------------------------------------			
		)
		
		------------------------------------------------
		--@event | open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			initControls() --inicializa los controles del UI
			with undo off fillInfo() --rellena la información necesaria para dibujar el interface con los datos
			createSceneEvents() --crea los callbacks
		)
		
		------------------------------------------------
		--@event | close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(	
			removeSceneEvents() --elimina los callbacks
			with undo off parent.fullNodeSetsPurge() --limpia el array de nodesets de la tool
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: nodeSetManager | Contiene la herramienta del gestor de nodeSets personalizados.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_nodeSetManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Gestor de grupos de objetos personalizados.",  --@var: string | descripcion de la herramienta
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
				
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		sceneNodeSets = #(),	--@var: sceneNodeSets | Todos los nodeSets de la escena.
		copyBuffer = #(),		--@var: copyBuffer | Buffer de copia de nodos de los nodeSets.
		lastPath = "",			--@var: lastPath | Ultimo path usado para cargar o salvar nodeSets.
		
		nameEditing = false,	--@var : nameEditing | Indica si se está editando un nombre o no
		allowedNameChars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM-_#1234567890", --@var : allowedNameChars | Caracteres permitidos para los nombres de nodeSets
		
		refreshOnClockTick = false, --@var : refreshonClockTick | Indica si se tiene que actualizar el UI en el siguiente intervalo del reloj
		refreshNodeSetsNodesNamesOnClockTick = false, --@var : refreshNodeSetsNodesNamesOnClockTick | Indica si se tienen que actualizar los nombres de los objetos de los nodesets en el UI en el siguiente intervalo del reloj
		removeDeletedNodesOnClockTick = false, --@var : removeDeletedNodesOnClockTick | Indica si se tienen que eliminar los nombres de los objetos de los nodesets que hayan sido borrados de la escena en el siguiente intervalo del reloj

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
			
		rollMain = rollMainDef, --@var: rollMain | Almacena el rollout principal de la herramienta.
			
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: array{container} | getRelatedPassContainersBySelection | Devuelve los contenedores de pases en los que esten contenidos los nodeSets seleccionados.
		------------------------------------------------
		fn getRelatedPassContainersBySelection =
		(
			_containers =#()
			
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				_containerTrees = if lb.passManagerUI.isOpen() then lb.passManagerUI.containerTrees else lb.passManager.getContainerTrees()
				if _containerTrees.count != 0 then
				(
					--obtiene los nombres de los nodeSets seleccionados
					_selNodeSetsNames = for i=1 to this.rollMain.trvNodeSets.selectedNodes.count collect this.rollMain.trvNodeSets.selectedNodes.item[i-1].text
						
					--obtiene los contenedores que usan los nodeSets seleccionados
					_containers = #()
					for _contTree in _containerTrees do
						for _ns in _selNodeSetsNames do
							_containers += lb.passManager.getByNodeSetName _ns containerTree:_contTree				
				)--if
			)--if
			
			_containers
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		---------------------------------------------
		--@fn: undefined | fullNodeSetsPurge | Hace un a purga masiva de todos los nodeSets a fondo para evitar incoherencias en procesos.
		------------------------------------------------
		fn fullNodeSetsPurge =
		(
			for _ns in this.sceneNodeSets where isValidNode (_ns.getInfoNode()) do _ns.purge mode:#full --hace purga completa de cada nodeSet
			this.sceneNodeSets = #() --vacia el array de nodeSets
		),

		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorChangesApply | Aplica el cambio de nombre a la seleccion.
		------------------------------------------------
		fn rtbCaptionEditorChangesApply =
		(
			--solo si estaba en modo edicion lo aplica
			if this.nameEditing then
			(
				this.nameEditing = false
				
				_process = true
				_newCaption = this.rollMain.rtbCaptionEditor.text --obtiene el nuevo nombre que aplicar
				
				_level = this.rollMain.trvNodeSets.selectedNodes.item[0].level --nivel de profundidad del nodo del arbol.

				
				--hay que averiguar si es un nombre válido o no. Se descartan los nombres con espacios y simbolos prohibidos.
				_allowedChars = "1234567890qwertyuiopasdfghjklzxcvbnm-_()#"; _allowedChars = for i=1 to _allowedChars.count collect _allowedChars[i]
				if _level == 1 then _allowedChars += #("{","}") --si es un objeto lo que se renombra, tambien puede llevar mas simbolos
				for i=1 to _newCaption.count where _process and findItem _allowedChars (tolower _newCaption[i]) == 0 do _process = false
				
				if _process then
				(
					_trvSel = this.rollMain.trvNodeSets.selectedNodes --obtiene los nodos seleccionados
					_oldName = this.rollMain.trvNodeSets.selectedNodes.item[0].text --nombre original
					
					if (_newCaption != "") and (_newCaption != _oldName) then
					(
						case _level of
						(
							--si lo que se renombra es un nodeSet
							0:
							(
								--si ya existe un nodo con ese nombre marca la opcion para redibujar el arbol en el timer, ya que se renombrara con un indice
								if (lb.nodeSets.getByCaption _newCaption).count != 0 then this.refreshonClockTick = true
												
								--averigua que nodeSet se debe renombrar
								_index = _trvSel.item[0].index + 1
								

								------------------------------------------------
								--antes de renombrar debe comprobar si el nodeSet se esta usando en algun pase del Pass Manager y si es asi preguntar si renombrarlo y propagar el cambio o cancelar
								
								--obtiene los contenedores que usan el nodeSet y pregunta si actualizarlos. en caso afirmativo lo actualiza en el Pass Manager y luego le cambia el nombre al nodeSet.
								_containers = this.getRelatedPassContainersBySelection()					
								if _containers.count != 0 then _process = queryBox "Some passes in Pass Manager Tool are using this Node Set. If you continue, they will be updated too. Do you want to continue?"

								------------------------------------------------

								--si cumple todos los requisitos para ser renombrado
								if _process then
								(
									undo "Rename NodeSet" on
									(
										if _containers.count != 0 then this.updatePassManager oldName:_oldName newName:_newCaption mode:#update containersToUpdate:_containers --actualiza el passManager
										this.sceneNodeSets[_index].setCaption _newCaption --renombra el nodeSet
										_trvSel.item[0].text = _newCaption
										this.rollMain.fillInfo() --Reordena
									)--undo
								)--if
							)--case 0

							1:
							(
								_nodeSetIndex = _trvSel.item[0].Parent.index + 1
								_nodeSetCaption = _trvSel.item[0].Parent.text

								_objectIndex = _trvSel.item[0].index + 1

								_node = (this.sceneNodeSets[_nodeSetIndex].getNodes())[_objectIndex]
								if isValidNode _node then
								(
									undo "Rename Object" on
									(
										_node.name = _newCaption
										_trvSel.item[0].text = _newCaption
										this.sceneNodeSets[_nodeSetIndex].purge mode:#light
									)--undo
								)--if
							)--case 1
						)--case
					)--if
				)--if

				--oculta el editor  devuelve el foco al arbol
				this.rollMain.rtbCaptionEditor.hide()
				setfocus this.rollMain.trvNodeSets
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorLostFocusEvent | Se ejecuta cuando se pierde el foco del cuadro de edicion de nombres.
		------------------------------------------------
		fn rtbCaptionEditorLostFocusEvent self events =
		(
			this.rtbCaptionEditorchangesApply()
		),
		
		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorKeyUpEvent | Cada vez que se pulsa una tecla en el cuadro de edicion de nombres.
		------------------------------------------------
		fn rtbCaptionEditorKeyUpEvent self events =
		(
			events.handled = true --para evitar perder el control del foco con teclas especiales como Alt y que lo coja el treeview
			
			key = events.keydata.tostring()
			case key of
			(
				"Return":
				(
					this.rtbCaptionEditorChangesApply()
				)
				
				"Escape":
				(
					this.nameEditing = false
					this.rollMain.rtbCaptionEditor.hide()
					setfocus this.rollMain.trvNodeSets
				)
			)
		),
		
		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorShow | Muestra el cuadro de edicion de nombres de contenedores.
		------------------------------------------------
		fn rtbCaptionEditorShow =
		(
			--obtiene los nodos seleccionados
			_trvSel = this.rollMain.trvNodeSets.selectedNodes
			
			--si hay mas de un elemento seleccionado no deja renombrar
			if _trvSel.count == 1 then
			(
				--averigua las propiedades de dibujado de la celda pulsada
				_rectangle = this.rollMain.trvNodeSets.selectedNodes.item[0].Bounds
									
				this.rollMain.rtbCaptionEditor.location = dotnetObject "System.Drawing.Point" _rectangle.x _rectangle.y
				this.rollMain.rtbCaptionEditor.width = this.rollMain.trvNodeSets.width
				this.rollMain.rtbCaptionEditor.height = _rectangle.height + 1
				
				--abre el cuadro de edicion con el nombre original
				this.rollMain.rtbCaptionEditor.text = this.rollMain.trvNodeSets.selectedNodes.item[0].text
				
				this.rollMain.rtbCaptionEditor.show()
				this.rollMain.rtbCaptionEditor.selectAll()
				setfocus this.rollMain.trvNodeSets
				this.rollMain.rtbCaptionEditor.focus()
			)--if
		),

		------------------------------------------------
		--@fn: boolean | updatePassManager | Devuelve TRUE si se ha indicado porceder con la acualizacion y FALSE si no. Actualiza el nombre o la eliminación de nodeSets en el Pass Manager.
		--@opt: string | oldName | "" | Nombre del nodeSet antes de ser renombrado.
		--@opt: string | newName | "" | Nuevo nombre para el nodeSet..
		--@opt: name | mode | #update | Indica el modo de actualizacion para el Pass Manager, por si solo han variado nombres o por si se han eliminado nodeSets.
		--@opt: array{container} | containersToUpdate | undefined | contenedores del Pass Manager que actualizar.		
		------------------------------------------------
		fn updatePassManager oldName:"" newName:"" mode:#update containersToUpdate:undefined =
		(
			_success = false
			
			--solo actualiza si hay contenedores del gestor de pases que usen el nodeSet, en caso contrario continua saltando este paso
			if containersToUpdate != undefined and containersToUpdate.count != 0 then
			(				
				--recorre los contenedores sustituyendo el nombre y actualizando el interface en caso de que tengan
				for _cont in containersToUpdate do
				(
					case mode of
					(
						#update:
						(
							--cambia el nombre del nodeSet de contenedor
							_currentNames = _cont.getNodeSetNames()
							_index = findItem _currentNames oldName
							_currentNames[_index] = newName
							_cont.setNodeSetNames _currentNames
							
							--cambia el nombre en el UI
							if lb.passManagerUI.isOpen() and _cont.getUiObj() != undefined then
							(
								_uiObj = _cont.getUiObj()
								if _uiObj == undefined do
									return false
								for i=1 to _uiObj.nodes.count where _uiObj.nodes.item[i-1].item[0] == oldName and _uiObj.nodes.item[i-1].item[2] == "nodeSet" do
									_uiObj.nodes.item[i-1].setValue 0 newName
							)--if
						)--update

						#remove:
						(
							_currentNames = _cont.getNodeSetNames()
							_index = findItem _currentNames oldName

							_cont.removeNodeSetByName oldName
							_uiObj = _cont.getUiObj()

							if _uiObj == undefined do
								return false

							for i=_uiObj.nodes.count to 1 by -1 do
								if _uiObj.nodes.item[i-1].item[0] == oldName then
									lb.passManagerUI.rollMain.trvContainers.DeleteNode (lb.passManagerUI.rollMain.trvContainers.FindNodeByID (_uiObj.nodes.item[i-1].id))
						)--remove
					)--case
				)--for

				_success = true
			)--if
			
			_success
		),
		
		------------------------------------------------
		--@fn: undefined | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
		------------------------------------------------
		fn fillSceneNodeSets =
		(
			this.sceneNodeSets = #()
			this.sceneNodeSets = lb.nodeSets.getAll()
		),
			
		------------------------------------------------
		--@fn: undefined | newEmptyNodeSet | Crea un nuevo nodeSet vacío.
		------------------------------------------------
		fn newEmptyNodeSet =
		(
			undo "New empty nodeSet" on _newNodeSetName = ((lb.nodeSets.newNodeSet caption:undefined type:#default nodes:#() infoNode:undefined).getCaption())
			this.rollMain.fillInfo() --redibuja el arbol de nodos
			this.rollMain.trvNodeSets.selectedNodes.clear()
			for i=1 to this.rollMain.trvNodeSets.nodes.count \
				where (this.rollMain.trvNodeSets.nodes.item[i-1]).level == 0 and this.rollMain.trvNodeSets.nodes.item[i-1].Text == _newNodeSetName do
			(
				this.rollMain.trvNodeSets.selectedNodes.add this.rollMain.trvNodeSets.nodes.item[i-1]
				this.rollMain.trvNodeSets.nodes.item[i-1].EnsureVisible()
			)
			this.beginEditing()
		),
		
		------------------------------------------------
		--@fn: undefined | newNodeSetWithSelectedObjects | Crea un nuevo nodeSet con los objetos seleccionados de la escena
		------------------------------------------------
		fn newNodeSetWithSelectedObjects =
		(
			undo "New empty nodeSet" on _newNodeSetName = ((lb.nodeSets.newNodeSet caption:undefined type:#default nodes:(getCurrentSelection() as array) infoNode:undefined).getCaption())
			this.rollMain.fillInfo() --redibuja el arbol de nodos
			this.rollMain.trvNodeSets.selectedNodes.clear()
			for i=1 to this.rollMain.trvNodeSets.nodes.count \
				where (this.rollMain.trvNodeSets.nodes.item[i-1]).level == 0 and this.rollMain.trvNodeSets.nodes.item[i-1].Text == _newNodeSetName do
			(
				this.rollMain.trvNodeSets.selectedNodes.add this.rollMain.trvNodeSets.nodes.item[i-1]
				this.rollMain.trvNodeSets.nodes.item[i-1].EnsureVisible()
			)
			this.beginEditing()
		),
				
		------------------------------------------------
		--@fn: undefined | addSelectedObjectsToSelectedNodeSets | Añade a los nodeSets seleccionados los objetos seleccionados de la escena.
		------------------------------------------------
		fn addSelectedObjectsToSelectedNodeSets =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				undo "Add selection to nodeSets" on 
				(
					--recorre los nodeSets añadiendo los nodos seleccionados de la escena
					for i=1 to this.rollMain.trvNodeSets.selectedNodes.count where (this.rollMain.trvNodeSets.selectedNodes.item[i-1]).level == 0 do
					(
						_index = this.rollMain.trvNodeSets.selectedNodes.item[i-1].index + 1 --indice del nodeSet
						this.sceneNodeSets[_index].addNodes (getCurrentSelection() as array)
						
						--redibuja el nodo del treeview con el contenido nuevo
						this.rollMain.trvNodeSets.nodes.item[_index-1].nodes.clear()
						for nsn in (this.sceneNodeSets[_index].getNodesNames()) do (this.rollMain.trvNodeSets.nodes.item[_index-1]).nodes.add nsn
					)--for
				)--undo
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | removeSelectedObjectsToSelectedNodeSets | Quita de los nodeSets seleccionados los objetos seleccionados en la escena.
		------------------------------------------------
		fn removeSelectedObjectsToSelectedNodeSets =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				undo "Remove nodeSets objects" on
				(
					--recorre los nodeSets eliminando los nodos seleccionados de la escena
					for i=1 to this.rollMain.trvNodeSets.selectedNodes.count where (this.rollMain.trvNodeSets.selectedNodes.item[i-1]).level == 0 do
					(				
						_index = this.rollMain.trvNodeSets.selectedNodes.item[i-1].index + 1 --indice del nodeSet					
						this.sceneNodeSets[_index].removeNodes (getCurrentSelection() as array)
							
						--redibuja el nodo del treeview con el contenido nuevo
						this.rollMain.trvNodeSets.nodes.item[_index-1].nodes.clear()
						for nsn in (this.sceneNodeSets[_index].getNodesNames()) do (this.rollMain.trvNodeSets.nodes.item[_index-1]).nodes.add nsn
					)--for
				)--undo
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | clearSelectedNodeSets | Vacía los nodeSets seleccionados.
		------------------------------------------------
		fn clearSelectedNodeSets =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				undo "Clear NodeSets" on
				(
					--recorre los nodeSets vaciando sus nodos
					for i=1 to this.rollMain.trvNodeSets.selectedNodes.count where (this.rollMain.trvNodeSets.selectedNodes.item[i-1]).level == 0 do
					(
						_index = this.rollMain.trvNodeSets.selectedNodes.item[i-1].index + 1 --indice del nodeSet
						this.sceneNodeSets[_index].clear()
						
						--redibuja el nodo del treeview con el contenido nuevo
						this.rollMain.trvNodeSets.nodes.item[_index-1].nodes.clear()
						for nsn in (this.sceneNodeSets[_index].getNodesNames()) do (this.rollMain.trvNodeSets.nodes.item[_index-1]).nodes.add nsn
					)--for
				)--undo
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | selectSelectedNodeSetsNodes | Selecciona en la escena los nodos de los nodeSets seleccionados en el arbol.
		------------------------------------------------
		fn selectSelectedNodes =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				_nodesToSelect = #()
				
				clearSelection() --limpia la seleccion de la escena
					
				--recorre los nodeSets añadiendo sus nodos al array de nodos a seleccionar
				for i=1 to this.rollMain.trvNodeSets.selectedNodes.count where (this.rollMain.trvNodeSets.selectedNodes.item[i-1]).level == 1 do
				(
					_nodeName = this.rollMain.trvNodeSets.selectedNodes.item[i-1].text
					_parent = this.rollMain.trvNodeSets.selectedNodes.item[i-1].parent
					_index = _parent.index + 1 --indice del nodeSet

					_nodeIndex = this.sceneNodeSets[_index].findNodeByName _nodeName

					if _nodeIndex != 0 then _nodesToSelect += (this.sceneNodeSets[_index].geTNodes())[_nodeIndex]
				)--for
				
				--si hay nodos que seleccionar lo hace
				if _nodesToSelect.count != 0 then select _nodesToSelect
			)--if
		),

		------------------------------------------------
		--@fn: undefined | selectSelectedNodeSetsNodes | Selecciona en la escena los nodos de los nodeSets seleccionados en el arbol.
		------------------------------------------------
		fn selectSelectedNodeSetsNodes =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				_nodesToSelect = #()
				
				clearSelection() --limpia la seleccion de la escena
					
				--recorre los nodeSets añadiendo sus nodos al array de nodos a seleccionar
				for i=1 to this.rollMain.trvNodeSets.selectedNodes.count where (this.rollMain.trvNodeSets.selectedNodes.item[i-1]).level == 0 do
				(
					_index = this.rollMain.trvNodeSets.selectedNodes.item[i-1].index + 1 --indice del nodeSet
					_nodesToSelect += this.sceneNodeSets[_index].getNodes()
				)--for
				
				--si hay nodos que seleccionar lo hace
				if _nodesToSelect.count != 0 then select _nodesToSelect
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | selectsNodeSetsBySceneSelection | Selecciona los nodeSets en los que se encuentran los objetos seleccionados de la escena
		------------------------------------------------
		fn selectsNodeSetsBySceneSelection =
		(
			_selection = getCurrentSelection() as array --coge la seleccion actual de la escena
			_indexesToSelect = #() --array de indices de nodeSets que hay que seleccionar
			
			--solo si hay nodos seleccionados en la escena
			if _selection.count != 0 then
			(
				--recorre los nodesets buscando en ellos los objetos seleccionados de la escena. Si encuentra uno para de buscar y almacena su indice
				for i=1 to this.sceneNodeSets.count do
				(
					_stop = false
					for j=1 to _selection.count where not _stop do
					(
						if (this.sceneNodeSets[i].findNodeByName _selection[j].name) != 0 then
						(
							_stop = true
							append _indexesToSelect (i-1) --almacena el indice del nodeSet
						)--if
					)--for
				)--for
				
				--una vez encontrados los nodeSets, hay que dejarlos seleccionados en el arbol
				if _indexesToSelect.count != 0 then
				(
					this.rollMain.trvNodeSets.selectedNodes.clear() --primero limpia la seleccion
					
					--recorre los indices y los deja seleccionados
					for _index in _indexesToSelect do
					(
						this.rollMain.trvNodeSets.selectedNodes.Add (this.rollMain.trvNodeSets.nodes.item[_index])
					)--for
				)--if
			)--if			
		),
		
		------------------------------------------------
		--@fn: undefined | duplicateSelectedNodeSets | Duplica en la escena los nodeSets seleccionados.
		------------------------------------------------
		fn duplicateSelectedNodeSets =
		(
			this.rollMain.removeSceneEvents()

			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				undo "Duplicate NodeSets" on
				(
					--recorre los nodeSets duplicando los seleccionados
					for i=1 to this.rollMain.trvNodeSets.selectedNodes.count where (this.rollMain.trvNodeSets.selectedNodes.item[i-1]).level == 0 do
					(
						_index = this.rollMain.trvNodeSets.selectedNodes.item[i-1].index + 1 --indice del nodeSet
						lb.nodeSets.duplicateNodeSet (this.sceneNodeSets[_index])
					)--for
					
					this.rollMain.fillInfo() --redibuja el arbol de nodos
					lb.nodeSets.placeInScene() --reordena los nodeSets en la escena
				)--undo
			)--if

			this.rollMain.createSceneEvents
		),
		
		------------------------------------------------
		--@fn: undefined | removeSelectedNodeSets | Elimina de la escena los nodeSets seleccionados.
		------------------------------------------------
		fn removeSelectedNodeSets =
		(
			this.rollMain.removeSceneEvents()

			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				_process = true

				------------------------------------------------
				--antes de eliminar debe comprobar si el nodeSet se esta usando en algun pase del Pass Manager y si es asi preguntar si eliminarlo y propagar el cambio o cancelar
				
				--obtiene los contenedores que usan el nodeSet y pregunta si actualizarlos. en caso afirmativo lo actualiza en el Pass Manager y luego elimina el nodeSet.
				_containers = this.getRelatedPassContainersBySelection()					
				if _containers.count != 0 then _process = queryBox "Some passes in Pass Manager Tool are using this Node Set. If you continue, they will be removed too. Do you want to continue?"				
				------------------------------------------------

				if _process then
				(
					undo "Remove NodeSets" on
					(
						--recorre los nodeSets seleccionados y los va eliminando
						for i=1 to this.rollMain.trvNodeSets.selectedNodes.count where (this.rollMain.trvNodeSets.selectedNodes.item[i-1]).level == 0 do
						(
							if _containers.count != 0 then
							(
								_oldName = this.rollMain.trvNodeSets.selectedNodes.item[i-1].text
								this.updatePassManager oldName:_oldName mode:#remove containersToUpdate:_containers --actualiza el passManager
							)

							_index = this.rollMain.trvNodeSets.selectedNodes.item[i-1].index + 1 --indice del nodeSet
							lb.nodeSets.removeNodeSet (this.sceneNodeSets[_index])
						)--for
						
						this.rollMain.fillInfo() --redibuja el arbol de nodos
						lb.nodeSets.placeInScene() --reordena los nodeSets en la escena
					)--undo
				)--if
			)--if		

			this.rollMain.createSceneEvents()
		),
		
		------------------------------------------------
		--@fn: undefined | removeSelectedNodeSetsSelectedObjects | Quita de los nodeSets seleccionados los objetos seleccionados en la escena.
		------------------------------------------------
		fn removeSelectedNodeSetsSelectedObjects =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				_parents = #() --array para almacenar los nodeSets del arbol cuyos nodos hijos estan seleccionados
				_parentsIndex = #() --array de indices de los nodeSets del arbol cuyos nodos hijos estan seleccionados
				
				undo "Remove selected nodeSets objects" on
				(
					--recorre los nodos seleccionados de los nodeSets para eliminarlos
					for i=1 to this.rollMain.trvNodeSets.selectedNodes.count do
					(
						_nodeSet = this.rollMain.trvNodeSets.selectedNodes.item[i-1].parent --obtiene el nodeSet padre
						--almacena el nodeSet y su indice
						if appendIfUnique _parents _nodeSet then append _parentsIndex (_nodeSet.index + 1) --indice del nodeSet que contiene el nodo que se quiere eliminar
						
						_nodeName = this.rollMain.trvNodeSets.selectedNodes.item[i-1].text --nombre del nodo a eliminar

						this.sceneNodeSets[(_nodeSet.index + 1)].removeNodeByName _nodeName --elimina el nodo con ese nombre					
					)--for
				)--undo
				
				--recorre los nodeSets en los que se han eliminado nodos y repinta en el arbol su contenido
				for i=1 to _parents.count do
				(
					--redibuja el nodo del treeview con el contenido actualizado
					_parents[i].nodes.clear()
					for nsn in (this.sceneNodeSets[_parentsIndex[i]].getNodesNames()) do _parents[i].nodes.add nsn
				)--for
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | fillCopyBuffer | rellena el buffer de copia de nodos
		------------------------------------------------
		fn fillCopyBuffer =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				--recorre los nodos seleccionados de los nodeSets para eliminarlos
				for i=1 to this.rollMain.trvNodeSets.selectedNodes.count do
				(
					_nodeName = this.rollMain.trvNodeSets.selectedNodes.item[i-1].text --nombre del nodo a eliminar
					appendIfUnique (this.copyBuffer) _nodeName
				)--for
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | pasteBuffer | Pega el buffer de copia.
		------------------------------------------------
		fn pasteBuffer =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(
				undo "Copy/Paste nodeSets objects" on
				(
					--recorre los nodeSets eliminando los nodos seleccionados de la escena
					for i=1 to this.rollMain.trvNodeSets.selectedNodes.count do
					(
						_index = this.rollMain.trvNodeSets.selectedNodes.item[i-1].index + 1 --indice del nodeSet
						this.sceneNodeSets[_index].addNodesNames this.copyBuffer --pega los nodos nuevos
											
						--redibuja el nodo del treeview con el contenido nuevo
						this.rollMain.trvNodeSets.nodes.item[_index-1].nodes.clear()
						for nsn in (this.sceneNodeSets[_index].getNodesNames()) do (this.rollMain.trvNodeSets.nodes.item[_index-1]).nodes.add nsn
					)--for
					
					this.copyBuffer = #() --vacia el buffer de copia
				)--undo
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | loadNodeSetsFromFile | Carga los nodeSets de otra escena.
		------------------------------------------------
		fn loadNodeSetsFromFile =
		(
			this.rollMain.removeSceneEvents() --elimina temporalmente los callbacks mientras hace el merge
			
			lb.nodeSetMergeManager.run() --llama al la herramienta de mergeado de nodeSets
			this.lastPath = lb.nodeSetMergeManager.lastPath
			
			this.rollMain.createSceneEvents() --reactiva los callbacks
		),
		
		------------------------------------------------
		--@fn: undefined | pasteBuffer | Salva los nodeSets en otro archivo aparte.
		--@opt: array{nodeSet} | nodeSetsToSave | #() | Array de nodeSets que salvar en un archivo aparte.
		------------------------------------------------
		fn saveNodeSetsToFile nodeSetsToSave:#() =
		(
			--si no se le han pasado nodeSets con los que trabajar, coge todos los de la escena
			if nodeSetsToSave.count == 0 then nodeSetsToSave = lb.nodeSets.getAll()
			nodeSetsToSave = for _ns in nodeSetsToSave collect _ns.getInfoNode()
			
			--selecciona un nombre de archivo donde almacenar los nodeSets
			_file = getSaveFileName filename:this.lastPath types:"NodeSets(*.nds)|*.nds|"
			
			--salva los nodos en el nuevo archivo
			saveNodes nodeSetsToSave _file
		),
		
		------------------------------------------------
		--@fn: undefined | importFromSelSets | Carga los selection sets como nodeSets.
		------------------------------------------------
		fn importFromSelSets =
		(
			this.rollMain.removeSceneEvents()
			_success = lb.nodeSets.importNodeSetsFromSelectionSets()
			if _success then this.rollMain.fillInfo()
			this.rollMain.createSceneEvents()
		),

		--@fn: undefined | exportToSelSets | Exporta los nodeSets a selection sets.
		------------------------------------------------
		fn exportToSelSets =
		(
			lb.nodeSets.exportNodeSetsToSelectionSets()			
		),

		------------------------------------------------
		--@fn: undefined | refreshTreeNodeSetNames | Refresca los nombres de los nodeSets del treeview
		------------------------------------------------
		fn refreshTreeNodeSetNames =
		(
			for i=1 to this.sceneNodeSets.count do
			(
				this.rollMain.trvNodeSets.nodes.item[i-1].text = this.sceneNodeSets[i].getCaption()
			)--for
		),
		
		------------------------------------------------
		--@fn: undefined | refreshTreeNodeSetNodes | Refresca los nombres de los nodos de los nodesets.
		------------------------------------------------
		fn refreshTreeNodeSetNodes = 
		(
			for i=1 to this.sceneNodeSets.count do
			(
				_nsNodes = this.sceneNodeSets[i].getNodes purge:false
				_treeNodes = this.rollMain.trvNodeSets.nodes.item[i-1].nodes

				if _nsNodes.count == _treeNodes.count then
					for j=1 to _nsNodes.count where (_nsNodes[j] != undefined) and (_nsNodes[j].name != _treeNodes.item[j-1].text) do
					(
						_treeNodes.item[j-1].text = _nsNodes[j].name	
					)--for
				else
				(
					this.rollMain.trvNodeSets.nodes.item[i-1].nodes.clear()
					for nsn in (this.sceneNodeSets[i].getNodesNames purge:false) do this.rollMain.trvNodeSets.nodes.item[i-1].nodes.add nsn
				)--if else		
			)--for
		),


		------------------------------------------------
		--@fn: undefined | refreshTrvNodeSets | Actualiza el arbol de nodeSets
		------------------------------------------------
		fn refreshTrvNodeSets =
		(
			if this.sceneNodeSets.count != this.rollMain.trvNodeSets.nodes.count then
				this.rollMain.fillInfo()
			else
			(
				for i=1 to this.sceneNodeSets.count do
				(
					this.sceneNodeSets[i].purge mode:#light

					if this.rollMain.trvNodeSets.nodes.item[i-1].text != this.sceneNodeSets[i].getCaption() then
						this.rollMain.trvNodeSets.nodes.item[i-1] = this.sceneNodeSets[i].getCaption()

					_nsNodesNames = this.sceneNodeSets[i].getNodesNames purge:false
					_treeNodes = this.rollMain.trvNodeSets.nodes.item[i-1].nodes
					
					if _nsNodesNames.count == _treeNodes.count then
					(
						for j=1 to _nsNodesNames.count where _nsNodesNames[j] != _treeNodes.item[j-1].text do
							_treeNodes.item[j-1].text = _nsNodesNames[j]	
					)
					else
					(
						this.rollMain.trvNodeSets.nodes.item[i-1].nodes.clear()						
						for nsn in _nsNodesNames do this.rollMain.trvNodeSets.nodes.item[i-1].nodes.add nsn
					)
				)--for
			)
		),

		------------------------------------------------
		--@fn: undefined | undoManagement | Gestiona la operacion de undo, que puede deberse a muchos factores.
		------------------------------------------------
		fn undoManagement =
		(--print "Scene Undo"
			_nodeSetInfoNodes = lb.nodeSets.getAllInfoNodes() --obtiene los objetos de la escena que contienen información de nodeSets

			if _nodeSetInfoNodes.count != this.sceneNodeSets.count then --si el numero cambia es que se ha/n recuperado un/os nodeSet/s
			(
				this.rollMain.removeSceneEvents()
				with undo off this.fullNodeSetsPurge() --limpia el array de nodesets de la tool
				with undo off this.rollMain.fillInfo() --redibuja el arbol
				this.rollMain.createSceneEvents()
			)
			else --si el numero es el mismo, o se ha/n recuperado un/os objeto/s o se ha devuelvo el nombre original
			(
				this.refreshTreeNodeSetNames()
				this.refreshTreeNodeSetNodes()
			)
		),

		------------------------------------------------
		--@fn: undefined | beginEditing | Comienza la edicion del nodo seleccionado.
		------------------------------------------------
		fn beginEditing =
		(
			this.nameEditing = true
			this.rtbCaptionEditorShow()
		),
		
		------------------------------------------------
		--@fn: undefined | expandSelected | Expande los nodeSets seleccionados en el arbol.
		------------------------------------------------
		fn expandSelected invert:false =
		(
			this.rollMain.removeSceneEvents()

			--solo actua si hay nodos seleccionados
			if this.rollMain.trvNodeSets.selectedNodes.count != 0 then
			(			
				--recorre los nodeSets expandiendo los seleccionados
				for i=1 to this.rollMain.trvNodeSets.selectedNodes.count where (this.rollMain.trvNodeSets.selectedNodes.item[i-1]).level == 0 do
				(
					if not invert then this.rollMain.trvNodeSets.selectedNodes.item[i-1].Expand()
					else this.rollMain.trvNodeSets.selectedNodes.item[i-1].Collapse()
				)--for			
			)--if

			this.rollMain.createSceneEvents
		),

		------------------------------------------------
		--@fn: undefined | expandSelected | Expande los nodeSets seleccionados en el arbol.
		------------------------------------------------
		fn expandAll invert:false =
		(
			this.rollMain.removeSceneEvents()
			
			if not invert then this.rollMain.trvNodeSets.ExpandAll()
			else this.rollMain.trvNodeSets.CollapseAll()

			this.rollMain.createSceneEvents
		),

		------------------------------------------------
		--@fn: undefined | menuItemClickedProcess | Ejecuta las acciones todos los menús de la herramienta.
		------------------------------------------------
		fn menuItemClickedProcess menuText =
		(
			case menuText of
			(
				"Expand Selected": this.expandSelected()
				"Collapse Selected": this.expandSelected invert:true
				"Rename nodeSet": this.beginEditing()
				"Select objects in scene": this.selectSelectedNodeSetsNodes()
				"Add selected scene objects": this.addSelectedObjectsToSelectedNodeSets()
				"Remove selected scene objects": this.removeSelectedObjectsToSelectedNodeSets()
				"Clear (empty selected nodeSets)": this.clearSelectedNodeSets()
				"Paste objects": this.pasteBuffer()
				"Duplicate nodeSets": this.duplicateSelectedNodeSets()
				"Remove nodeSets": this.removeSelectedNodeSets()
				
				"Select in scene": this.selectSelectedNodes()
				"Rename object": this.beginEditing()
				"Copy objects": this.fillCopyBuffer()				
				"Remove objects": this.removeSelectedNodeSetsSelectedObjects()
				
				"Expand All": this.expandAll()
				"Collapse All": this.expandAll invert:true
				"New empty nodeSet": this.newEmptyNodeSet()
				"New nodeSet with selected objects": this.newNodeSetWithSelectedObjects()
				"Highlight nodeSets by selection": this.selectsNodeSetsBySceneSelection()
				"Import selection sets": this.importFromSelSets()
				"Export to selection sets": this.exportToSelSets()
				"Load nodeSets from file": this.loadNodeSetsFromFile()
				"Save nodeSets to file": this.saveNodeSetsToFile()
			)
		),
		
		------------------------------------------------
		--@fn: undefined | selectionChanged | Para realizar cambios en el interface cuando cambia la seleccion en el treeview.
		------------------------------------------------
		fn selectionChanged =
		(

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
			this.rollMain.removeSceneEvents()
			with undo off this.rollMain.fillInfo() --rellena la información necesaria para dibujar el interface con los datos
			this.rollMain.createSceneEvents()
		),
		
		------------------------------------------------
		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
		fn createInterface =
		(
			--crea el interface, lo redimensiona y lo reposiciona
			createDialog this.rollMain lockwidth:false lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
		fn destroyInterface =
		(
			destroyDialog this.rollMain --cierra la herramienta.			
		),--destroyInterface
		
		------------------------------------------------
		--@fn: undefined | run | Lanza la herramienta.
		fn run =
		(
			this.createInterface() --crea el interface.
			this.opened = true --indica que la herramienta está abierta
		),--execute
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
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
		
	)--tl_nodeSetManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
 	
	tl_nodeSetManager() --se crea la tool
	
	ok
)