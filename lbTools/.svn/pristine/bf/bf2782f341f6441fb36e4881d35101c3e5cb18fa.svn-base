------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta objectSetManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollFindAndReplace | Contiene el rollout para renombrar.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollFindAndReplaceDef "Find And Replace"
	(
		-----------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual	

		local minRollWidth = 500		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 85		--@var: minRollHeight | Alto mínimo de la herramienta.
	
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		label lblfind "Find:" pos:[10,5]
		edittext edtFind "" pos:[55,5] width:440 height:15
		label lblreplace "Replace:" pos:[10,30]
		edittext edtReplace "" pos:[55,30] width:440 height:15
		button btnApply "Apply" pos:[200,55] width:80 height:21

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
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		fn resize size =
		(

		)
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(

		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			----establece minimos
			if rollFindAndReplaceDef.width < minRollWidth then rollFindAndReplaceDef.width = minRollWidth
			if rollFindAndReplaceDef.height < minRollHeight then rollFindAndReplaceDef.height = minRollHeight
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		-----------------------------------------------
		--@event: changed | Controla que los caracteres introducidos sean validos.
		------------------------------------------------
		on edtFind changed newText do  
		(	
			_process = true
			_forbiddenChar = ""
	
			for i=1 to newText.count where _process and findItem parent.allowedChars newText[i] == 0 do --Si el caracter introducido no esta en nuestro array de _allowedChars hacemos saltar un mensaje.
			(
				_process = false
				_forbiddenChar = newText[i]
			)
			if not _process then
			(
				_textSubsti = substituteString newText _forbiddenChar "" --Borramos el ultimo caracter introducido en el edittext del find.
				edtFind.text = _textSubsti --Substituimos la nueva palabra sin el ultimo valor en el editFind.
			)
		) --europeanChildFemale

		-----------------------------------------------
		--@event: changed | Controla que los caracteres introducidos sean validos.
		------------------------------------------------
		on edtReplace changed newText do  
		(	
			_process = true
			_forbiddenChar = ""

			for i=1 to newText.count where _process and findItem parent.allowedChars newText[i] == 0 do --Si el caracter introducido no esta en nuestro array de _allowedChars hacemos saltar un mensaje.
			(
				_process = false
				_forbiddenChar = newText[i]
			)
			if not _process then 
			(
				_textSubsti = substituteString newText newText[i] ""  --Borramos el ultimo caracter introducido en el edittext del find.
				edtReplace.text = _textSubsti --Substituimos la nueva palabra sin el ultimo valor en el editFind.
			)
		)

		------------------------------------------------
		--@event: pressed | Aplica los cambios al texto dandole al intro.
		------------------------------------------------
		on edtReplace entered text do --Usamos el intro para que aplique los cambios.
		(	
			parent.replaceNameInSelected edtFind.text edtReplace.text --Utilizamos la funcion replaceNameInSelected y le pasamos los dos edittext. 
			destroyDialog parent.rollFindAndReplace --Cerramos el rollout.
		)

		------------------------------------------------
		--@event: pressed | Aplica los cambios al texto.
		------------------------------------------------
		on btnApply pressed do
		(	
			parent.replaceNameInSelected edtFind.text edtReplace.text  --Utilizamos la funcion replaceNameInSelected y le pasamos los dos edittext.
			destroyDialog parent.rollFindAndReplace --Cerramos el rollout.
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rolloutchkImportCamera | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollFindAndReplaceDef resized size do
		(
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollFindAndReplaceDef open do
		(			
			loadSettings()
			createSceneEvents() --crea los callbacks
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollFindAndReplaceDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollFindAndReplaceDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta object set manager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Object Set Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 350		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 400		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------3------------------------

		--local multiSelectTreeview = dotnet.loadAssembly (lb.config.getAssembliesPath() + "CodersLab.Windows.Controls.TreeView.dll")
		local iconpath = lb.config.getIconsPath() --@var : iconpath | Ruta de iconos de las herramientas
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		--@control | controlName | Plantilla de comentario para controles

		local rMenu = dotnetObject "System.Windows.Forms.ContextMenuStrip" --@control: rMenu | Menu de boton derecho para las opciones del arbol de objectSets.
			
		button btnSeparator01 "|" pos:[50,1] width:20 height:20 border:false enabled:false
		button btnSeparator02 "|" pos:[105,1] width:20 height:20 border:false enabled:false
		button btnSeparator03 "|" pos:[160,1] width:20 height:20 border:false enabled:false
		button btnSeparator04 "|" pos:[265,1] width:20 height:20 border:false enabled:false	

		button btnNewObjectSetSelObjects "" pos:[10,3] width:20 height:20 border:false toolTip:"New ObjectSet with selected objects" images:#(iconPath + "AnimLayerToolbar_16i.bmp", undefined, 12, 2, 2, 2, 2, true) --@control: btnNewObjectSetSelObjects | Boton para crear un nuevo ObjectSet con los objetos seleccionados.
		button btnDeleteSelObjectSets "" pos:[35,3] width:20 height:20 border:false toolTip:"Delete selected ObjectSets" images:#(iconPath + "AnimLayerToolbar_16i.bmp", undefined, 12, 6, 6, 6, 6, true) --@control: btnDeleteSelObjectSets | Boton para eliminar ObjectSets
			
		button btnAddSelObjectsToSelObjectSets "" pos:[65,3] width:20 height:20 border:false toolTip:"Add selected objets" images:#(iconPath + "Containers_16i.bmp", undefined, 17, 2, 2, 2, 2, true) --@control: btnAddSelObjectsToSelObjectSets | Boton para añadir los objetos seleccionados a los ObjectSets seleccionados.
		button btnRemoveSelObjectsFromSelObjectSets "" pos:[90,3] width:20 height:20 border:false toolTip:"Remove selected objets" images:#(iconPath + "Containers_16i.bmp", undefined, 17, 12, 12, 12, 12, true) --@control: btnRemoveSelObjectsFromSelObjectSets | Boton para eliminar los objetos seleccionados de los ObjectSets seleccionados.
			
		button btnHighlightSelObjectSetsObjects "" pos:[120,3] width:20 height:20 border:false toolTip:"Select Objects in scene" images:#(iconPath + "LayerManager_i.bmp", undefined, 13, 4, 4, 4, 4, true) --@control: btnHighlightSelObjectSetsObjects | Boton para seleccionar los objetos de los ObjectSets seleccionados.
		button btnHighlightSelObjectsObjectSets "" pos:[145,3] width:20 height:20 border:false toolTip:"Highlight objectSets by selection" images:#(iconPath + "LayerManager_i.bmp", undefined, 13, 8, 8, 8, 8, true) --@control: btnHighlightSelObjectsObjectSets | Boton seleccionar los ObjectSets donde están los objetos seleccionados.
		
		button btnLoadObjectSets "Load" pos:[175,3] width:20 height:20 border:false images:#(iconpath + "bip_general_i.bmp", undefined, 30, 5, 5, 6, 6,true) tooltip:"Load ObjectSets" --@control: btnLoadObjectSets | Boton para cargar ObjectSets de otro archivo
		button btnSaveObjectSets "Save" pos:[200,3] width:20 height:20 border:false images:#(iconpath + "bip_general_i.bmp", undefined, 30, 7, 7, 8, 8,true) tooltip:"Save ObjectSets" --@control: btnSaveObjectSets | Boton para salvar ObjectSets en un archivo.
		button btnImportFromSelSets "ImportFromSelSets" pos:[225,3] width:20 height:20 border:false images:#(iconpath + "ParameterCollector_i.bmp", undefined, 28, 11, 11, 11, 11, true) tooltip:"Import from selection sets" --@control: btnImportFromSelSets | Boton para importar los selection sets como ObjectSets.
		button btnExportToSelSets "ExportToSelSets" pos:[250,3] width:20 height:20 border:false images:#(iconpath + "ParameterCollector_i.bmp", undefined, 28, 10, 10, 10, 10,true) tooltip:"Export to selection sets" --@control: btnExportToSelSets | Boton para exportar los ObjectSets a selection sets.
		button btnRefresh "Refresh" pos:[280,3] width:20 height:20 border:false images:#(iconpath + "UVWUnwrapModes_16i.bmp", undefined, 28, 4, 4, 4, 4,true) tooltip:"Refresh" --@control: btnLoadObjectSets | Boton para cargar ObjectSets de otro archivo

		timer tmrRefresh interval:500 active:true

		local rtbCaptionEditor = dotNetObject "System.Windows.Forms.richtextbox" --@control: rtbCaptionEditor | Cuadro de edicion para los nombres de los ObjectSets

		dotNetControl trvObjectSets "CodersLab.Windows.Controls.TreeView" pos:[5,25] width:340 height:350 --@control: trvObjectSets | Arbol de representación de ObjectSets.
		edittext edtObjectSetName "" pos:[1,377] width:344 enabled:false --@control: edtObjectSetName | Cuadro de edicion para renombrar ObjectSets.
			
		--dotNetControl rMenu "System.Windows.Forms.ContextMenuStrip" pos:[0,0] width:60 height:14 --@control: rMenu | Menu de boton derecho para las opciones del arbol de ObjectSets.
		
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
			trvObjectSets.selectionMode = trvObjectSets.selectionMode.MultiSelectSameLevel --habilita la multiseleccion
			trvObjectSets.LabelEdit = false --true --habilita la opción de modificar los labels de los nodos
			trvObjectSets.AllowDrop = true --habilita el drag & drop
			
			--establece los colores por defecto de fondo y elementos
			trvObjectSets.backColor = (dotNetClass "System.Drawing.Color").fromargb 50 50 50
			trvObjectSets.foreColor = (dotNetClass "System.Drawing.Color").lightgray
			
			--establece la fuente del treeview
			trvObjectSets.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 9
			
			--añade el evento al menu
			dotnet.addEventHandler rMenu "itemClicked" rollMainDef.rMenuItemclickedEvent

			------------------------------------------------
			--cuadro de edicion de nombres de ObjectSets
			
			--establece las propiedades iniciales del cuadro de edicion de nombres de contenedores
			rtbCaptionEditor.readonly = false
			rtbCaptionEditor.backcolor = (dotNetClass "System.Drawing.Color").white
			rtbCaptionEditor.parent = trvObjectSets
			
			global _tempParentNameObjectSetManager = parent.className
			dotnet.removeAllEventHandlers rtbCaptionEditor
			dotnet.addEventHandler rtbCaptionEditor "lostFocus" (fn lostFocusEvent self events = ((lb.getTool _tempParentNameObjectSetManager).rtbCaptionEditorLostFocusEvent self events))
			dotnet.addEventHandler rtbCaptionEditor "keyUp" (fn keyUpEvent self events = ((lb.getTool _tempParentNameObjectSetManager).rtbCaptionEditorKeyUpEvent self events))
				
			rtbCaptionEditor.hide()
			------------------------------------------------
		)

		------------------------------------------------
		--@fn: undefined | fillTrvObjectSets | Rellena el arbol de objectSets
		------------------------------------------------
		fn fillTrvObjectSets =
		(
			trvObjectSets.nodes.clear() --vacía el arbol
			
			--recorre los objectSets de la escena y los añade al árbol
			for os in parent.sceneObjectSets do
			(
				--añade el objectSet actual al árbol
				_objectSet = trvObjectSets.nodes.add (os.caption)
				_objectSet.backColor = (dotNetClass "System.Drawing.Color").fromargb 70 70 70
				
				--si el objectSet tiene objetos almacenados, los añade al arbol
				for osn in (os.nodes) do _objectSet.nodes.add osn.name
			)--for
		)

		------------------------------------------------
		--@fn: undefined | rMenuItemclickedEvent | Utilizamos esta funcion para el rMenu.
		------------------------------------------------
		fn rMenuItemclickedEvent self events =
		(
			_itemName = (events.clickeditem.tostring())
			parent.menuItemClickedProcess _itemName
		)

		------------------------------------------------
		--@fn: undefined | fillInfo | Rellena la información necesaria para trabajar y pinta el interface con esos datos
		------------------------------------------------
		fn fillInfo =
		(
			parent.fillSceneObjectSets() --obtiene los objectsets de la escena y los almacena en la herramienta
			fillTrvObjectSets() --rellena el arbol de objectsets 
		)

		------------------------------------------------
		--@fn: undefined | createRMenu | Rellena el menu de boton derecho en función de la opcion.
		--@gets: point2 | pos | Posición en la que debe dibujarse el menu.
		--@gets: name | menuType | Tipo de menu, que marca cuales serán los elementos internos del menu. Opciones -> #objectSets, #nodes, #default
		------------------------------------------------
		fn createRMenu pos menuType =
		(
			_rMenuItems = #() --array para almacenar los items del menu
			
			rMenu.items.clear() --vacía el menú
			rMenu.rendermode = (dotnetclass "System.Windows.Forms.ToolStripRenderMode").system --elige el modo de dibujado del menu
			
			case menuType of
			(
				#objectSets:
				(
					--rellena el array de items con todas las opciones
					append _rMenuItems "Rename objectSet"
					append _rMenuItems "Find and Replace"	
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")			
					append _rMenuItems "Expand Selected"					
					append _rMenuItems "Collapse Selected"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")				
					append _rMenuItems "Add selected scene objects"
					append _rMenuItems "Select objects in scene" 					
					append _rMenuItems "Remove selected scene objects"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")				
					append _rMenuItems "Remove objectSets"
					
					--añade todos los items al menú
					for i = 1 to _rMenuItems.count do rMenu.items.add _rMenuItems[i]
									
				)
				
				#nodes:
				(
					--rellena el array de items con todas las opciones
					append _rMenuItems "Select in scene"
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
					append _rMenuItems "New objectSet with selected objects"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")
					append _rMenuItems "Highlight objectSets by selection"
					append _rMenuItems (dotnetobject "System.Windows.Forms.ToolStripSeparator")
					append _rMenuItems "Import selection sets"
					append _rMenuItems "Export to selection sets"
					append _rMenuItems "Load objectSets from file"
					append _rMenuItems "Save objectSets to file"
					
					--añade todos los items al menú
					for i = 1 to _rMenuItems.count do rMenu.items.add _rMenuItems[i]	
				)--default
			)
			
			rMenu.Show pos.x pos.y --muestra el menú
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)
			
			callbacks.addscript #filePostMerge "lb.objectSetManager.rollMain.fillInfo()" id:_id --Callback que despues de mergear vuelve a rellenar la informacion del treeview
			callbacks.addscript #filePostOpenProcess "lb.objectSetManager.rollMain.fillInfo()" id:_id --Callback que despues de abrir el archivo vuelve a rellenar la informacion del treeview
			callbacks.addscript #nodeRenamed "lb.objectSetManager.refreshObjectSetsNodesNamesOnClockTick = true" id:_id --Callback que despues de renombrar un objectSet actualiza el treeview.
			callbacks.addscript #nodePostDelete "lb.objectSetManager.removeDeletedNodesOnClockTick = true" id:_id --Callback que despues de borrar un objectSet actualiza el treeview.
			callbacks.addscript #sceneNodeAdded "lb.objectSetManager.addNewNodesOnClockTick = true" id:_id --Callback que añade al treeview los nodos que traemos des de otra escena.
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
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
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
				trvObjectSets.width = size.x - 10
				edtObjectSetName.width = 340 + _increment.x 
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				trvObjectSets.height = size.y - 50
				edtObjectSetName.pos.y = 377 + _increment.y
			)--if
			------------------------------------------------------------------------------
		)

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
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
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
				if parent.refreshObjectSetsNodesNamesOnClockTick then --print "rename"
				(
					parent.refreshObjectSetsNodesNamesOnClockTick = false
					removeSceneEvents()
					parent.refreshTreeObjectSetNodes()
					createSceneEvents()
				)
				else if parent.removeDeletedNodesOnClockTick then --print "remove"
				(
					parent.removeDeletedNodesOnClockTick = false
					removeSceneEvents()
					parent.refreshTreeObjectSetNodes()
					createSceneEvents()
				)
				else if parent.addNewNodesOnClockTick then
				(	
					parent.addNewNodesOnClockTick = false
					removeSceneEvents()
					parent.refreshTreeObjectSetNodes()
					createSceneEvents()
				)
				/*else
				(
					_objectSetInfoNodes = lb.objectSets.getAll() --obtiene los objetos de la escena que contienen información de objectSet

					if _objectSetInfoNodes.count != parent.sceneObjectSets.count then --si el numero cambia es que se ha/n recuperado un/os objectSet/s
					(
						removeSceneEvents()
						parent.rollMain.fillInfo() --redibuja el arbol
						createSceneEvents()
					)
				)--else*/
			)
		)

		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnNewObjectSetSelObjects | Boton para crear un objectSet con los objetos seleccionados.
		------------------------------------------------
		on btnNewObjectSetSelObjects pressed do
		(
			parent.menuItemClickedProcess "New objectSet with selected objects"
		)

		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnDeleteSelObjectSets | Boton para eliminar los objectSets seleccionados.
		------------------------------------------------
		on btnDeleteSelObjectSets pressed do
		(
			parent.menuItemClickedProcess "Remove objectSets"
		)

		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnAddSelObjectsToSelObjectSets | Boton para añadir los objetos seleccionados de la escena a los objectSets seleccionados.
		------------------------------------------------
		on btnAddSelObjectsToSelObjectSets pressed do
		(	
			parent.menuItemClickedProcess "Add selected scene objects"
		)

		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnRemoveSelObjectsFromSelObjectSets | Boton para añadir los objetos seleccionados de la escena a los objectSets seleccionados.
		------------------------------------------------
		on btnRemoveSelObjectsFromSelObjectSets pressed do
		(	
			parent.menuItemClickedProcess "Remove selected scene objects"
		)

		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnHighlightSelObjectSetsObjects | Boton para seleccionar los objetos de los objectSets.
		------------------------------------------------
		on btnHighlightSelObjectSetsObjects pressed do
		(
			--si hay nodos seleccionados, comprueba de que nivel son para mostrar un menu u otro
			if trvObjectSets.selectedNodes.count != 0 then 
			(
				_level = (trvObjectSets.selectedNodes.item[0]).level

				case _level of
				(
					0: parent.menuItemClickedProcess "Select objects in scene"
					1: parent.menuItemClickedProcess "Select in scene"
				)--case
			)--if
		)

		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnHighlightSelObjectsObjectSets | Boton para seleccionar los objectSets donde se encuetran los objetos seleccionados.
		------------------------------------------------
		on btnHighlightSelObjectsObjectSets pressed do
		(
			parent.menuItemClickedProcess "Highlight objectSets by selection"
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
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnRefresh | Boton para refrescar el triview.
		------------------------------------------------
		on btnRefresh pressed do
		(
			fillInfo()
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
		--@control: button | btnSaveObjectSets | Boton para salvar los objectSets el una archivo aparte.
		------------------------------------------------
		on btnSaveObjectSets pressed do
		(
			parent.menuItemClickedProcess "Save objectSets to file"
		)

		------------------------------------------------
		--@event | pressed | Evento del boton presionado.
		--@control: button | btnLoadObjectSets | Boton para cargar los objectSets de otra escena.
		------------------------------------------------
		on btnLoadObjectSets pressed do
		(
			parent.menuItemClickedProcess "Load objectSets from file"
		)

		------------------------------------------------
		--@event | MouseUp | Evento que se lanza al levantar el raton despues de hacer click o click derecho.
		--@control: CodersLab.Windows.Controls.TreeView | trvObjectSets | Arbol de objectSets.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		on trvObjectSets MouseUp events do
		(
			_button = events.button.ToString() --averigua si es boton izquierdo, derecho o central
			
			--en función del boton pulsado ha de realizar unas operaciones u otras
			case _button of
			(
				"Right": --boton derecho
				(
					_level = -1 --nivel del arbol en el que se han seleccionado nodos
					
					_clickedNode = trvObjectSets.GetNodeAt events.Location --mira en que nodo se ha hecho click
					if _clickedNode != undefined then --si se ha hecho click en un nodo averigua el nivel del nodo
					(
						--si hay nodos seleccionados, comprueba de que nivel son para mostrar un menu u otro
						if trvObjectSets.selectedNodes.count != 0 then 
						(
							if trvObjectSets.selectedNodes.count == 1 then --si solo hay uno seleccionado comprueba que se ha hecho click en el y no fuera
							(
								if _clickedNode.text == (trvObjectSets.selectedNodes.item[0]).text then --si es el mismo
									_level = (trvObjectSets.selectedNodes.item[0]).level								
							)
							else --si hay varios seleccionados averigua el nivel de la seleccion
							(
								_level = (trvObjectSets.selectedNodes.item[0]).level
							)--if
						)--if
					)--if					
					
					case _level of
					(
						0: createRMenu mouse.screenPos #objectSets --lanza el menu de boton derecho de objectSets
						1: createRMenu mouse.screenPos #nodes --lanza el menu de boton derecho de nodos en los objectSets
						default: createRMenu mouse.screenPos #default --lanza el menu de boton derecho general
					)--case
				)--Right
			)--case			
		)

		------------------------------------------------
		--@event | AfterLabelEdit | Evento que se lanza al terminar de editar el nombre de un nodo
		--@control: CodersLab.Windows.Controls.TreeView | trvObjectSets | Arbol de objectSet.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		on trvObjectSets AfterLabelEdit events do
		(
			parent.endEditing (events.Label)
		)

		------------------------------------------------
		--@event | AfterLabelEdit | Evento que se lanza al presionar una tecla sobre el arbol. Es para atajos de teclado
		--@control: CodersLab.Windows.Controls.TreeView | trvObjectSets | Arbol de objectSet.
		--@gets: event | events | Evento de dotnet lanzado.
		------------------------------------------------
		on trvObjectSets KeyDown events do
		(
			_key = events.keyData.tostring()
			
			case _key of 
			(
				"F2":
				(				
					if not parent.nameEditing and trvObjectSets.selectedNodes.count == 1 then
					(
						if trvObjectSets.selectedNodes.item[0].Level == 0 then
						(
							parent.menuItemClickedProcess "Rename objectSet"
						)
					)--if
				)--f2
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
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			initControls() --inicializa los controles del UI
			fillInfo()
			createSceneEvents() --crea los callbacks
			resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			parent.destroyInterface()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: objectSetManager | Contiene el struct de la tool objectSetManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_objectSetManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "objectSetManager",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		sceneObjectSets = #(),	--@var: sceneObjectSets | Todos los objectSets de la escena.
		lastPath = "",			--@var: lastPath | Ultimo path usado para cargar o salvar objectSets.
		nameEditing = false,	--@var : nameEditing | Indica si se está editando un nombre o no
		allowedChars = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM-_#(){}.:1234567890", --@var : allowedNameChars | Caracteres permitidos para los nombres de objectSets
		allowCharsMessage = "You can only use: letters a-z, numbers 0-9, and symbols - _ # () {} . :",

		refreshOnClockTick = false, --@var : refreshonClockTick | Indica si se tiene que actualizar el UI en el siguiente intervalo del reloj
		refreshObjectSetsNodesNamesOnClockTick = false, --@var : refreshObjectSetsNodesNamesOnClockTick | Indica si se tienen que actualizar los nombres de los objetos de los objectsets en el UI en el siguiente intervalo del reloj
		removeDeletedNodesOnClockTick = false, --@var : removeDeletedNodesOnClockTick | Indica si se tienen que eliminar los nombres de los objetos de los objectSets que hayan sido borrados de la escena en el siguiente intervalo del reloj
		addNewNodesOnClockTick = false, --@var : addNewNNodesOnClockTick | Indica si hay que volver a añadir los objetos a los objectSets de antes(CTRL+Z) 
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------

		rollFindAndReplace = rollFindAndReplaceDef, --@var: rollFindAndReplace | Almacena el rollout findAndReplace de la herramienta.
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
		--@fn: undefined | fillSceneObjectSets | Alamacena los sceneObjectSets de la escena.
		------------------------------------------------
		fn fillSceneObjectSets =
		(
			this.sceneObjectSets = #()
			this.sceneObjectSets = lb.objectSets.getAll()
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
				"Find and Replace": this.findReplace()
				"Rename objectSet": this.beginEditing()
				"Select objects in scene": this.selectSelectedObjectSetsNodes()
				"Add selected scene objects": this.addSelectedObjects()
				"Remove selected scene objects": this.removeSelectedObjectsToSelectedObjectSets()
				"Remove objectSets": this.removeSelectedObjectSets()
				
				"Select in scene": this.selectSelectedObjects()
				"Rename object": this.beginEditing()
				"Remove objects": this.removeSelectedNodesFromObjectSets()
				
				"Expand All": this.expandAll()
				"Collapse All": this.expandAll invert:true
				"New objectSet with selected objects": this.newObjectSetWithSelectedObjects()
				"Highlight objectSets by selection": this.selectsObjectSetsBySceneSelection()
				"Import selection sets": this.importFromSelSets()
				"Export to selection sets": this.exportToSelSets()
				"Load objectSets from file": this.loadObjectSetsFromFile()
				"Save objectSets to file": this.saveObjectSetsToFile()
			)
		),

		------------------------------------------------
		--@fn: undefined | newObjectSetWithSelectedObjects | Crea un nuevo objectSet con los objetos seleccionados de la escena
		------------------------------------------------
		fn newObjectSetWithSelectedObjects =
		(
			lb.objectSets.newObjectSet()
			this.rollMain.fillInfo() --redibuja el arbol de nodos
		),

		------------------------------------------------
		--@fn: undefined | removeSelectedObjectSets | Elimina de la escena los objectSets seleccionados.
		------------------------------------------------
		fn removeSelectedObjectSets =
		(
			if this.rollMain.trvObjectSets.selectedNodes.count != 0 then
			(	
				for i=1 to this.rollMain.trvObjectSets.selectedNodes.count where (this.rollMain.trvObjectSets.selectedNodes.item[i-1]).level == 0 do
					lb.objectSets.removeByCaption this.rollMain.trvObjectSets.selectedNodes.item[i-1].text
			)

			this.rollMain.fillInfo()	
		),
		
		------------------------------------------------
		--@fn: undefined | addSelectedObjects | Añade a los objectSets seleccionados los objetos seleccionados de la escena.
		------------------------------------------------
		fn addSelectedObjects =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvObjectSets.selectedNodes.count != 0 then
			(
					for i=1 to this.rollMain.trvObjectSets.selectedNodes.count where (this.rollMain.trvObjectSets.selectedNodes.item[i-1]).level == 0 do 
					(
						_objsToAdd = getCurrentSelection()
						for obj in _objsToAdd do lb.objectSets.add obj #(this.rollMain.trvObjectSets.selectedNodes.item[i-1].text) replace:true 
					)--for
			)--if
			this.rollMain.fillInfo() --redibuja el arbol de nodos
		),

		------------------------------------------------
		--@fn: undefined | removeSelectedObjectsToSelectedObjectSets | Quita de los objectSets seleccionados los objetos seleccionados en la escena.
		------------------------------------------------
		fn removeSelectedObjectsToSelectedObjectSets =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvObjectSets.selectedNodes.count != 0 then
			(
					--recorre los objectSets eliminando los nodos seleccionados de la escena
					for i=1 to this.rollMain.trvObjectSets.selectedNodes.count where (this.rollMain.trvObjectSets.selectedNodes.item[i-1]).level == 0 do
					(				
						_objsToDel = getCurrentSelection()
						for obj in _objsToDel do  
						(	
							lb.objectSets.remove obj #(this.rollMain.trvObjectSets.selectedNodes.item[i-1].text) 
							_objSets = lb.objectSets.get obj  
			  				if _objSets.count == 0 then lb.objectSets.removeAttribute obj --Si los objetos que llevaban el objectSet eliminado no estan en otro objectSets eliminamos el Attribute.  
						)
					)--for
			)--if
			this.rollMain.fillInfo() --redibuja el arbol de nodos
		),

		------------------------------------------------
		--@fn: undefined | selectSelectedObjectSetsNodes | Selecciona en la escena los objetos de los objectsSets seleccionados en el arbol.
		------------------------------------------------
		fn selectSelectedObjectSetsNodes =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvObjectSets.selectedNodes.count != 0 then
			(
				_objectsToSelect = #()
				
				clearSelection() --limpia la seleccion de la escena
					
				--recorre los objectSets añadiendo sus nodos al array de nodos a seleccionar
				for i=1 to this.rollMain.trvObjectSets.selectedNodes.count where (this.rollMain.trvObjectSets.selectedNodes.item[i-1]).level == 0 do
				(
					_index = this.rollMain.trvObjectSets.selectedNodes.item[i-1].index + 1 --indice del objectSet
					_objectsToSelect += this.sceneObjectSets[_index].nodes
				)--for
				
				--si hay nodos que seleccionar lo hace
				if _objectsToSelect.count != 0 then select _objectsToSelect
			)--if
		),

		------------------------------------------------
		--@fn: undefined | removeSelectedNodesFromObjectSets | Selecciona en la escena los objetos de los objectsSets seleccionados en el arbol.
		------------------------------------------------
		fn removeSelectedNodesFromObjectSets = 
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvObjectSets.selectedNodes.count != 0 then
			(
				_objectsToRemove = #()
				
				--recorre los objectSets añadiendo sus nodos al array de nodos a seleccionar
				for i=1 to this.rollMain.trvObjectSets.selectedNodes.count where (this.rollMain.trvObjectSets.selectedNodes.item[i-1]).level == 1 do
				(
					_objName = this.rollMain.trvObjectSets.selectedNodes.item[i-1].text

					for obj in objects where obj.name == _objName do append _objectsToRemove obj

				)--for

				if _objectsToRemove.count != 0 then lb.objectSets.removeAttribute _objectsToRemove
			)
			this.rollMain.fillInfo()
		),

		------------------------------------------------
		--@fn: undefined | selectsObjectSetsBySceneSelection | Selecciona los objectSets en los que se encuentran los objetos seleccionados de la escena
		------------------------------------------------
		fn selectsObjectSetsBySceneSelection =
		(
			_selection = getCurrentSelection() as array --coge la seleccion actual de la escena
			_indexesToSelect = #() --array de indices de objectSets que hay que seleccionar
			this.rollMain.trvObjectSets.selectedNodes.clear()
			--solo si hay nodos seleccionados en la escena
			if _selection.count != 0 then
			(
				--recorre los objectSets buscando en ellos los objetos seleccionados de la escena. Si encuentra uno para de buscar y almacena su indice
				_objectCaption = #()
				for obj in _selection do _objectCaption += lb.objectSets.get obj 
				_objectCaption = makeUniqueArray _objectCaption

				for i=1 to this.sceneObjectSets.count do 
				(
					if (findItem _objectCaption this.sceneObjectSets[i].caption ) !=0 then append _indexesToSelect (i-1) 
				) 
				--una vez encontrados los objectSets, hay que dejarlos seleccionados en el arbol
				
				if _indexesToSelect.count != 0 then
				(
					--recorre los indices y los deja seleccionados
					for _index in _indexesToSelect do
					(
						this.rollMain.trvObjectSets.selectedNodes.Add (this.rollMain.trvObjectSets.nodes.item[_index])
					)--for
				)--if
			)--if			
		),

		------------------------------------------------
		--@fn: undefined | exportToSelSets | Exporta los objectSets a selection sets.
		------------------------------------------------
		fn exportToSelSets =
		(
			lb.objectSets.exportObjectSetsToSelectionSets()			
		),

		------------------------------------------------
		--@fn: undefined | importFromSelSets | Carga los selection sets como objectSets.
		------------------------------------------------
		fn importFromSelSets =
		(
			this.rollMain.removeSceneEvents()
			_success = lb.objectSets.importObjectSetsFromSelectionSets()
			if _success then this.rollMain.fillInfo()
			this.rollMain.createSceneEvents()
		),

		------------------------------------------------
		--@fn: undefined | saveObjectSetsToFile | Salva los objectSets en otro archivo aparte.
		--@opt: array{objectSet} | objectSetsToSave | #() | Array de objectSets que salvar en un archivo aparte.
		------------------------------------------------
		fn saveObjectSetsToFile objectSetsToSave:#() =
		(
			if objectSetsToSave.count == 0 then objectSetsToSave = lb.objectSets.getAll() --si no se le han pasado objectSets con los que trabajar, coge todos los de la escena
			_file = getSaveFileName filename:this.lastPath types:"ObjectSets(*.objs)|*.objs|" --selecciona un nombre de archivo donde almacenar los objectSets
			if _file != undefined then 
			(
				_xmlDoc = lb.xml.new _file --Funcion de la libreria de xml para crear un nuevo archivo .xml 
				_rootNode = _xmlDoc.getRoot() --Lo utilizamos para saber la raiz de nuestro .xml
				_objsNode = _rootNode.newChild "objectSets" --Lo utilizamos para crear una nueva raiz que sea hija de nuestro root.
				
				for os in objectSetsToSave do --Recorremos los objetos que queremos guardar en el .obj
				(
					_os = _objsNode.newChild "objectSet" --Creamos otra raiz dentro de la de antes (objectSets)
					_os.setProperty "caption" os.caption --Añadimos caption a nuestro archivo xml 
					
					for n in os.nodes do
					(
						_node = _os.newChild "node" --Creamos la raiz node en el .xml 
						_node.setProperty "name" n.name --Añadimos la propiedad name a los nodes 
					)

				)	

				_xmlDoc.save() --Guardamos el xml exportado.

				messageBox "ObjectSets successfully saved."
			)
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
					setfocus this.rollMain.trvObjectSets
				)

				default:
				(	
					_newText = this.rollMain.rtbCaptionEditor.text --obtiene el nuevo nombre que aplicar
					_process = true
					_forbiddenChar = ""
					_cursorIndex = 0

					--Si el caracter introducido no esta en nuestro array de _allowedChars hacemos saltar un mensaje.
					for i=1 to _newText.count where _process and findItem this.allowedChars _newText[i] == 0 do
					(
						_process = false
						_forbiddenChar = _newText[i]
						_cursorIndex = i-1
					)--for

					if not _process then
					(
						_textSubsti = substituteString _newText _forbiddenChar "" --Borramos el ultimo caracter introducido en el edittext del find.
						this.rollMain.rtbCaptionEditor.text = _textSubsti --Substituimos la nueva palabra sin el ultimo valor en el editFind.

						this.rollMain.rtbCaptionEditor.SelectionStart = _cursorIndex
					)--if
				)
			)
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
				
				_level = this.rollMain.trvObjectSets.selectedNodes.item[0].level --nivel de profundidad del nodo del arbol.

				--hay que averiguar si es un nombre válido o no. Se descartan los nombres con espacios y simbolos prohibidos.

				if _level == 1 then this.allowedChars += #("{","}") --si es un objeto lo que se renombra, tambien puede llevar mas simbolos
				for i=1 to _newCaption.count where _process and findItem this.allowedChars (tolower _newCaption[i]) == 0 do 
				(
					_posGen = getDialogPos this.rollMain
					_posX = _posGen.x+10  
					_posY = _posGen.y*1.5 

					_process = false
					lb.message.show  this.allowCharsMessage pos:[_posX,_posY] size:[325,75]
				)

				if _process then
				(
					_trvSel = this.rollMain.trvObjectSets.selectedNodes --obtiene los nodos seleccionados
					_oldName = this.rollMain.trvObjectSets.selectedNodes.item[0].text --nombre original
					
					if (_newCaption != "") and (_newCaption != _oldName) then
					(
						case _level of
						(
							--si lo que se renombra es un objectSet
							0:
							(		
								--averigua que objectSet se debe renombrar
								_index = _trvSel.item[0].index + 1

								--si cumple todos los requisitos para ser renombrado
								if _process then
								(
									_capIndex = 0
									_newCaptionParts = FilterString _newCaption "#"

									for j=1 to this.sceneObjectSets.count do
									(										
										_objSetParts = FilterString this.sceneObjectSets[j].caption "#"
										if ((toLower _newCaptionParts[1]) == (toLower _objSetParts[1])) do
										(
											if _objSetParts.count == 1 then _capIndex += 1
											else if ((_objSetParts[2] as integer) >= _capIndex) then _capIndex = (_objSetParts[2] as integer) + 1
										)--if
									)--for

									if _capIndex > 0 then _newCaption = _newCaptionParts[1] + "#" + (formattedprint _capIndex format:"03d")

									this.sceneObjectSets[_index].caption = _newCaption --renombra el objectSet
									lb.objectSets.add this.sceneObjectSets[_index].nodes #(_newCaption) replace:true
									_trvSel.item[0].text = _newCaption
								)--if
							)--case 0
						)--case
					)--if
				)--if

				--oculta el editor  devuelve el foco al arbol
				this.rollMain.rtbCaptionEditor.hide()
				setfocus this.rollMain.trvObjectSets
			)--if
		),

		------------------------------------------------
		--@fn: undefined | loadObjectSetsFromFile | Carga los objectSets de otra escena.
		------------------------------------------------
		fn loadObjectSetsFromFile =
		(
			this.rollMain.removeSceneEvents() --elimina temporalmente los callbacks mientras hace el merge
			
			lb.objectSetMergeManager.run() --llama al la herramienta de mergeado de objectSets
			this.lastPath = lb.objectSetMergeManager.lastPath
			
			this.rollMain.createSceneEvents() --reactiva los callbacks
		),

		------------------------------------------------
		--@fn: undefined | expandSelected | Expande los objectSets seleccionados en el arbol.
		------------------------------------------------
		fn expandSelected invert:false =
		(
			this.rollMain.removeSceneEvents()

			--solo actua si hay nodos seleccionados
			if this.rollMain.trvObjectSets.selectedNodes.count != 0 then
			(			
				--recorre los objectSets expandiendo los seleccionados
				for i=1 to this.rollMain.trvObjectSets.selectedNodes.count where (this.rollMain.trvObjectSets.selectedNodes.item[i-1]).level == 0 do
				(
					if not invert then this.rollMain.trvObjectSets.selectedNodes.item[i-1].Expand()
					else this.rollMain.trvObjectSets.selectedNodes.item[i-1].Collapse()
				)--for			
			)--if

			this.rollMain.createSceneEvents
		),

		------------------------------------------------
		--@fn: undefined | expandSelected | Expande los objectSets seleccionados en el arbol.
		------------------------------------------------
		fn expandAll invert:false =
		(
			this.rollMain.removeSceneEvents()
			
			if not invert then this.rollMain.trvObjectSets.ExpandAll()
			else this.rollMain.trvObjectSets.CollapseAll()

			this.rollMain.createSceneEvents
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
		--@fn: undefined | findReplace | Busca la palabra y la reemplaza por la elegida.
		------------------------------------------------
		fn findReplace =
		(
			_posGen = (getDialogPos this.rollMain) + [(this.rollMain.width + 8),0]
			
			createDialog this.rollFindAndReplace pos:_posGen lockwidth:false lockheight:false minsize:[500,100] style:#(#style_border,#style_resizing,#style_titlebar, #style_sysmenu) modal:true
		),

		------------------------------------------------
		--@fn: undefined | rtbCaptionEditorShow | Muestra el cuadro de edicion de nombres de contenedores.
		------------------------------------------------
		fn rtbCaptionEditorShow =
		(
			--obtiene los nodos seleccionados
			_trvSel = this.rollMain.trvObjectSets.selectedNodes
			
			--si hay mas de un elemento seleccionado no deja renombrar
			if _trvSel.count == 1 then
			(
				--averigua las propiedades de dibujado de la celda pulsada
				_rectangle = this.rollMain.trvObjectSets.selectedNodes.item[0].Bounds
									
				this.rollMain.rtbCaptionEditor.location = dotnetObject "System.Drawing.Point" _rectangle.x _rectangle.y
				this.rollMain.rtbCaptionEditor.width = this.rollMain.trvObjectSets.width
				this.rollMain.rtbCaptionEditor.height = _rectangle.height + 1
				
				--abre el cuadro de edicion con el nombre original
				this.rollMain.rtbCaptionEditor.text = this.rollMain.trvObjectSets.selectedNodes.item[0].text
				
				this.rollMain.rtbCaptionEditor.show()
				this.rollMain.rtbCaptionEditor.selectAll()
				setfocus this.rollMain.trvObjectSets
				this.rollMain.rtbCaptionEditor.focus()
			)--if
		),

		------------------------------------------------
		--@fn: undefined | selectSelectedObjects | Selecciona en la escena los nodos de los objectSets seleccionados en el arbol.
		------------------------------------------------
		fn selectSelectedObjects =
		(
			--solo actua si hay nodos seleccionados
			if this.rollMain.trvObjectSets.selectedNodes.count != 0 then
			(
				_objectsToSelect = #()
				
				clearSelection() --limpia la seleccion de la escena
					
				--recorre los objectSets añadiendo sus nodos al array de nodos a seleccionar
				for i=1 to this.rollMain.trvObjectSets.selectedNodes.count where (this.rollMain.trvObjectSets.selectedNodes.item[i-1]).level == 1 do
				(
					_objName = this.rollMain.trvObjectSets.selectedNodes.item[i-1].text
					for obj in objects where obj.name == _objName do append _objectsToSelect obj
				)--for

				--si hay nodos que seleccionar lo hace
				if _objectsToSelect.count != 0 then select _objectsToSelect
			)--if
		),

		------------------------------------------------
		--@fn: undefined | refreshTreeObjectSetNodes | Refresca los nombres de los nodos de los objectSet.
		------------------------------------------------
		fn refreshTreeObjectSetNodes = 
		(
			for i = 1 to this.sceneObjectSets.count do  --Recorremos los objectSets de la escena.
			(
				_osNodes =	this.sceneObjectSets[i].nodes
				_treeNodes = this.rollMain.trvObjectSets.nodes.item[i-1].nodes 

				_deletedNodes = false
				for _osn in _osNodes where not isValidNode _osn do _deletedNodes = true --Usamos la funcion de max isValidNode para saber si hay objetos que hemos borrado de la escena pero se quedan en memoria.

				if (_osNodes.count == _treeNodes.count) and not _deletedNodes then --Comparamos los objetSets de la escena con los del treeview.
				(
					for j=1 to _osNodes.count where (_osNodes[j] != undefined) and (_osNodes[j].name != _treeNodes.item[j-1].text) do --recorremos los objetSets de la escena
					(
						_treeNodes.item[j-1].text = _osNodes[j].name --Aplicamos el nombre que tenemos en el treeview al name dentro del objetSet.
					)
				)
				else
				(
					this.rollMain.trvObjectSets.nodes.item[i-1].nodes.clear()
					for osn in (this.sceneObjectSets[i].nodes) where isValidNode osn do this.rollMain.trvObjectSets.nodes.item[i-1].nodes.add osn.name --Recorremos los objectSets de la escena comprobamos si son validos, y si lo son les agregamos con la funcion de libreria add el name.
				)
			)
		),

		------------------------------------------------
		--@fn: undefined | replace | funcion a la que le pasamos el nombre que buscar y el nombre por la que lo queremos substituir.
		------------------------------------------------
		fn replaceNameInSelected textToFind textToReplace =
		(	
			_trvSel = this.rollMain.trvObjectSets.selectedNodes --obtiene los nodos seleccionados
			for i=1 to _trvSel.count where findString _trvSel.item[i-1].text textToFind != undefined do --Recorremos los elementos selecionados del treeview. 
			(
				_newText = substituteString _trvSel.item[i-1].text textToFind textToReplace --Guardamos el nuevo nombre en _newText para despues poder aplicarla en todos los sitios donde la tenemos que cambiar.

				_index = _trvSel.item[i-1].index
				this.rollMain.trvObjectSets.nodes.item[_index].text = _newText --Aplicamos el nombre al treeview
				this.sceneObjectSets[(_index+1)].caption = _newText --Aplicamos el nombre al caption del ObjectSet
				lb.objectSets.add this.sceneObjectSets[_index+1].nodes #(_newText) replace:true --Aplicamos el nombre al CA utilizando la funcion add de nuestra libreria de objectSets.
			)
		),

		------------------------------------------------
		--@fn: undefined | initAllowChars | Caracteres que se pueden usar para renombrar.
		------------------------------------------------
		fn initAllowChars =
		(
			this.allowedChars = for i=1 to this.allowedChars.count collect this.allowedChars[i] --Recolectamos todos los caracteres permitidos en un array.
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
			destroyDialog this.rollFindAndReplace			
		),--destroyInterface
		
		------------------------------------------------
		--@fn: undefined | run | Lanza la herramienta.
		------------------------------------------------
		fn run =
		(
			this.initAllowChars() --inicia 
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
		
	)--tl_objectSetManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_objectSetManager() --crea la herramienta
)