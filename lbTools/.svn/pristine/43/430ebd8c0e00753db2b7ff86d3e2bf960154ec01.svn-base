------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta vertexColorManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Vertex Color Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 287		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 375		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local multipleObjectsArray = #() 	-- almacena los objetos que queremos editar a la vez que el seleccionado
		local pickingObjects = false			-- indica si estamos en modo coger objetos
		local VCbuffer = #()					-- buffer de copy/paste de Vertex Colors

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--@control | controlName | Plantilla de comentario para controles

		colorPicker cpCol01 "" pos:[5,20] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol02 "" pos:[73,20] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol03 "" pos:[141,20] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol04 "" pos:[209,20] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol05 "" pos:[5,65] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol06 "" pos:[73,65] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol07 "" pos:[141,65] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol08 "" pos:[209,65] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol09 "" pos:[5,110] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol10 "" pos:[73,110] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol11 "" pos:[141,110] width:69 height:25 color:(color 0 0 155) modal:false
		colorPicker cpCol12 "" pos:[209,110] width:69 height:25 color:(color 0 0 155) modal:false
				
		edittext edtCol01 "" pos:[5,45] width:69 height:15
		edittext edtCol02 "" pos:[73,45] width:69 height:15
		edittext edtCol03 "" pos:[141,45] width:69 height:15
		edittext edtCol04 "" pos:[209,45] width:69 height:15
		edittext edtCol05 "" pos:[5,90] width:69 height:15
		edittext edtCol06 "" pos:[73,90] width:69 height:15
		edittext edtCol07 "" pos:[141,90] width:69 height:15
		edittext edtCol08 "" pos:[209,90] width:69 height:15
		edittext edtCol09 "" pos:[5,135] width:69 height:15
		edittext edtCol10 "" pos:[73,135] width:69 height:15
		edittext edtCol11 "" pos:[141,135] width:69 height:15
		edittext edtCol12 "" pos:[209,135] width:69 height:15
				
		button btnLoadPalette "Load" pos:[144,155] width:65 height:25
		button btnSavePalette "Save" pos:[213,155] width:65 height:25
				
		colorPicker cpColCurrent "" pos:[5,205] width:55 height:25 color:[0,0,0] modal:false
		spinner spnColCurrentR "" pos:[65,205] width:45 height:16 range:[0,1,0] type:#float
		spinner spnColCurrentG "" pos:[65,225] width:45 height:16 range:[0,1,0] type:#float
		spinner spnColCurrentB "" pos:[65,245] width:45 height:16 range:[0,1,0] type:#float
		GroupBox grpVertexColor "Vertex Color" pos:[5,190] width:277 height:100
		checkbox chkLockColor "Lock" pos:[65,265] width:45 height:15
		checkbutton ckbSyncVertexColor "Sync" pos:[10,235] width:50 height:20
		button btnApplyVertexColor "Apply" pos:[10,260] width:50 height:20
		dotNetControl lvMultiEdit "System.Windows.Forms.ListView" pos:[177,215] width:100 height:50
		checkbutton ckbMultiEditPick "Pick" pos:[177,265] width:33 height:20
		button btnMultiEditDelete "Del" pos:[210,265] width:33 height:20
		button btnMultiEditClear "Clear" pos:[243,265] width:33 height:20
		checkbox chkMultipleEdit "Multiple edit" pos:[177,200] width:85 height:15
		GroupBox grpClipboard "Clipboard" pos:[5,5] width:277 height:180
				
		GroupBox grpExtraTools "" pos:[5,285] width:277 height:75
		dropdownList ddlVCchannels "" pos:[10,300] width:80 height:21 items:#("Vertex color", "Vertex illumination", "Vertex alpha")
		button btnVCshow "Show" pos:[10,325] width:40 height:30
		button btnVChide "Hide" pos:[50,325] width:40 height:30
		button btnVCnormalize "Normalize" pos:[95,300] width:50 height:20
		button btnDeleteIsoVerts "Del.iso verts" pos:[147,300] width:65 height:20
		button btnVCcopy "Copy" pos:[214,300] width:30 height:20
		button btnVCpaste "Paste" pos:[245,300] width:32 height:20
		
		progressBar pbNormalize "" pos:[5,363] width:245 height:8 visible:false
		label lblLog "" pos:[95,325] width:182 height:30 style_sunkenedge:true
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		----------------------------------------------------------------------------------------
		--@fn: undefined | initListView | inicia el ListView con todas sus propiedades principales, sin introducir datos
		----------------------------------------------------------------------------------------
		fn initListView lv =
		(
			lv.gridLines = true 
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.labelEdit = false
			lv.headerStyle = none
			lv.fullRowSelect = true
			lv.hideSelection = false
			lv.backColor = (dotNetClass "System.Drawing.Color").white
			lv.scrollable = true
			lv.gridlines = false
			
			lv.Columns.add "Objects" (lv.width - 5)
		) 

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | loadPalette | carga una paleta de disco
		----------------------------------------------------------------------------------------------------------------
		fn loadPalette f =
		(
			paletteLoaded = false
			fs = openFile f mode:"rt"
			
			if fs != undefined then
			(
				cpCol01.color = readExpr fs 
				cpCol02.color = readExpr fs
				cpCol03.color = readExpr fs
				cpCol04.color = readExpr fs
				cpCol05.color = readExpr fs
				cpCol06.color = readExpr fs
				cpCol07.color = readExpr fs
				cpCol08.color = readExpr fs
				cpCol09.color = readExpr fs
				cpCol10.color = readExpr fs
				cpCol11.color = readExpr fs
				cpCol12.color = readExpr fs
				
				edtCol01.text = readExpr fs
				edtCol02.text = readExpr fs
				edtCol03.text = readExpr fs
				edtCol04.text = readExpr fs
				edtCol05.text = readExpr fs
				edtCol06.text = readExpr fs
				edtCol07.text = readExpr fs
				edtCol08.text = readExpr fs
				edtCol09.text = readExpr fs
				edtCol10.text = readExpr fs
				edtCol11.text = readExpr fs
				edtCol12.text = readExpr fs
				close fs
				
				paletteLoaded = true
			)--if
			
			paletteLoaded
		)
		

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | savePalette | graba la paleta actual en disco
		----------------------------------------------------------------------------------------------------------------
		fn savePalette f =
		(
			paletteSaved = false
			fs = openFile f mode:"wt"
			
			if fs != undefined then
			(
				-- escribimos los colores
				print cpCol01.color to:fs
				print cpCol02.color to:fs
				print cpCol03.color to:fs
				print cpCol04.color to:fs
				print cpCol05.color to:fs
				print cpCol06.color to:fs
				print cpCol07.color to:fs
				print cpCol08.color to:fs
				print cpCol09.color to:fs
				print cpCol10.color to:fs
				print cpCol11.color to:fs
				print cpCol12.color to:fs
				
				-- escribimos el texto
				print edtCol01.text to:fs
				print edtCol02.text to:fs
				print edtCol03.text to:fs
				print edtCol04.text to:fs
				print edtCol05.text to:fs
				print edtCol06.text to:fs
				print edtCol07.text to:fs
				print edtCol08.text to:fs
				print edtCol09.text to:fs
				print edtCol10.text to:fs
				print edtCol11.text to:fs
				print edtCol12.text to:fs
				close fs
				
				paletteSaved = true
			)--if
			
			paletteSaved
		)

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | limitDigits | limita el número de díginos de un float de 0 a 3, según indique nDigits
		----------------------------------------------------------------------------------------------------------------
		fn limitDigits val nDigits =
		(
 			v = formattedprint (val - (val as integer)) format:("." + (nDigits as string) + "f")
 			val = (val as integer)  + (v as float)
			val
		)

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | assignVCtoSelVerts | Asigna el color actual a los vértices seleccionados. Si está activado Multiple Edit hace setMultipleVertexColors con todos los objetos seleccionados.
		----------------------------------------------------------------------------------------------------------------
		fn assignVCtoSelVerts =
		(
			for o in selection do
			(
				selVerts = o.mesh.selectedVerts
				selVertsIndex = for v in selVerts collect v.index
				lb.vertexColor.setvertexcolor o selVerts cpColCurrent.color
				if chkMultipleEdit.checked then 
					for vertIndex in selVertsIndex do
						lb.vertexColor.setMultipleVertexColors multipleObjectsArray vertIndex cpColCurrent.color
			)--for
		)

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | setCurrentColor | actualiza el valor de los spinners según los valores pasados en COL
		--updateVertex: indica si hay que asignar el color a los vértices seleccionados
		----------------------------------------------------------------------------------------------------------------
		fn setCurrentColor col updateVertex:true =
		(
			r = (limitDigits (col.r / 255) 2) 
			g = (limitDigits (col.g / 255) 2)
			b = (limitDigits (col.b / 255) 2)
			
			spnColCurrentR.value = r
			spnColCurrentG.value = g
			spnColCurrentB.value = b
			

			if ckbSyncVertexColor.checked and (getSelectionLevel selection[1] == #vertex) and updateVertex then assignVCtoSelVerts()
				
		)

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | updateCurrentColor | actualiza los controles para indicar un nuevo color actual en uso. Si está activada la sincronización se lo asigna a los vértices seleccionados
		----------------------------------------------------------------------------------------------------------------
		fn updateCurrentColor val =
		(
			if chklockColor.checked then
			(
				spnColCurrentR.value = val
				spnColCurrentB.value = val
				spnColCurrentG.value = val
			)--if
			
			r = spnColCurrentR.value * 255
			g = spnColCurrentG.value * 255
			b = spnColCurrentB.value * 255
			cpColCurrent.color = (color r g b)
			
			if ckbSyncVertexColor.checked and (getSelectionLevel selection[1] == #vertex) then assignVCtoSelVerts() 
				
		)

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | removeSelChangeHandler | crea el change handler que comprueba si cambia la selección de vértices.
		----------------------------------------------------------------------------------------------------------------
		fn removeSelChangeHandler =
		(
			deleteAllChangeHandlers id:#VCmanager
		)

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | createSelChangeHandler | crea el change handler que comprueba si cambia la selección de vértices.
		----------------------------------------------------------------------------------------------------------------
		fn createSelChangeHandler =
		(
			removeSelChangeHandler()
			lblLog.caption = ""
			if selection.count != 0 then
			(
				if not (lb.vertexColor.vertexColorsNormalized selection[1]) then lblLog.caption = "VC not normalized. Errors could be found."
				
				when select $ changes id:#VCmanager sel do 
				( 
					parent.vertexSelection()
				)--when
			)--if
		)

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | selFn | filtro de selección del Pick Objects del Multiple Edit 
		----------------------------------------------------------------------------------------------------------------
		fn selFn obj = 
		(
			(finditem multipleObjectsArray obj == 0) and not obj.isSelected
		)

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | cancelPicking | filtro de selección del Pick Objects del Multiple Edit 
		----------------------------------------------------------------------------------------------------------------
		fn cancelPicking = 
		(
			if pickingObjects then
			(
				pickingObjects = false
				ckbMultiEditPick.checked = false
			)--if
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
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.addscript #selectionSetChanged "lb.vertexColorManager.rollMain.createSelChangeHandler()" id:_id
			-- forzamos una primera llamada al callback para que se actualicen los controles
			callbacks.broadcastCallback #selectionSetChanged
		
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
				
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				
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

		-----------------------------------------------
		--@event: pressed | Asigna el color actual a los vértices seleccionado.
		------------------------------------------------
		on btnApplyVertexColor pressed do
		(
			cancelPicking()
			assignVCtoSelVerts()			
		)

		-----------------------------------------------
		--@event: changed | Permite editar varios objetos a la vez.
		------------------------------------------------
		on ckbMultiEditPick changed state do
		(
			if state then 
			(
				pickingObjects = true
				while ckbMultiEditPick.checked do 
				(
					_obj = pickobject filter:selFn
					if _obj != undefined and pickingObjects then
					(
						if lb.vertexColor.vertexColorsNormalized _obj then
						(
							append multipleObjectsArray _obj
							lvMultiEdit.items.add _obj.name
						)--if
						else
							messageBox "Los vertex colors de este objeto no están normalizados.\nAplique la operación de normalizar primero."
					)--if
					else
						ckbMultiEditPick.checked = false
				)--while
			)--if
			else
				cancelPicking()
		)

		-----------------------------------------------
		--@event: changed | actualiza el valor de los spinners según los valores pasados en COL
		------------------------------------------------
		on cpColCurrent changed col do 
		(
			setCurrentColor col
		)

		-----------------------------------------------
		--@event: changed | actualiza los controles para indicar un nuevo color actual en uso. 
		------------------------------------------------
		on spnColCurrentR changed val do
		(
			cancelPicking()
			updateCurrentColor val
		)

		-----------------------------------------------
		--@event: changed | actualiza el valor de los spinners según los valores pasados en COL
		------------------------------------------------
		on spnColCurrentG changed val do
		(
			cancelPicking()
			updateCurrentColor val
		)

		-----------------------------------------------
		--@event: changed | actualiza el valor de los spinners según los valores pasados en COL
		------------------------------------------------
		on spnColCurrentB changed val do 
		(
			cancelPicking()
			updateCurrentColor val
		)

		-----------------------------------------------
		--@event: pressed | carga la paleta de colores.
		------------------------------------------------
		on btnLoadPalette pressed do
		(
			cancelPicking()
			f = getOpenFileName caption:"Load palette" types:"Color Clipboard (*.cc)|*.cc"
			if f != undefined then
				loadPalette f
		)

		-----------------------------------------------
		--@event: pressed | guarda la paleta de colores.
		------------------------------------------------
		on btnSavePalette pressed do
		(
			cancelPicking()
			f = getSaveFileName caption:"Save palette" types:"Color Clipboard (*.cc)|*.cc"
			if f != undefined then
				savePalette f
		)

		-----------------------------------------------
		--@event: changed | comprueba si cambia la selección de vértices para activar la sincronización.
		------------------------------------------------
		on ckbSyncVertexColor changed state do
		(
			cancelPicking()
			if state then 
			(
				createSelChangeHandler()
				
			)--if
			else
				removeSelChangeHandler()			
		)

		-----------------------------------------------
		--@event: pressed | Permite eliminar varios objetos agregados al multiEdit.
		------------------------------------------------
		on btnMultiEditDelete pressed do
		(
			cancelPicking()
			for i = lvMultiEdit.selectedItems.count to 1 by -1 do
			(
				index = lvMultiEdit.selectedItems.item[i-1].index + 1
				lvMultiEdit.items.removeAt (index - 1)
				deleteitem multipleObjectsArray index
			)--for
		)

		-----------------------------------------------
		--@event: pressed | Vacia el array de objetos que tenemos en el multiEdit.
		------------------------------------------------
		on btnMultiEditClear pressed do
		(
			cancelPicking()
			lvMultiEdit.items.clear()
			multipleObjectsArray = #()
		)

		-----------------------------------------------
		--@event: pressed | Nos permite ver el color de los vertices por defecto.
		------------------------------------------------
		on btnVCshow pressed do
		(
			cancelPicking()
			VCtype = ddlVCchannels.selection - 1
			for _obj in selection do
			(
				_obj.showVertexColors = on
				_obj.vertexColorType = VCtype
			)--for
			completeRedraw()
		)

		-----------------------------------------------
		--@event: pressed | Oculta el color de los vertices y nos muestra el wirecolor.
		------------------------------------------------
		on btnVChide pressed do
		(
			cancelPicking()
			for _obj in selection do _obj.showVertexColors = off
			completeRedraw()
		)

		-----------------------------------------------
		--@event: pressed | Normaliza el color de los vertices.
		------------------------------------------------
		on btnVCnormalize pressed do
		(
			numObjsNormalized = 0
			setWaitCursor()
			for _obj in selection do 
			(
				_objClass = classof _obj.baseobject
				if ((_objClass == editable_mesh) or (_objClass == editable_poly)) then --and not (lb.vertexColor.vertexColorsNormalized _obj) then 
				(
					lb.vertexColor.normalizeVertexColors _obj
					numObjsNormalized += 1
				)--if
			)--for
			setArrowCursor()
			
			-- forzamos una llamada al callback para que se actualicen los controles
			callbacks.broadcastCallback #selectionSetChanged
			
			messageBox (numObjsNormalized as string + " objects normalized.")
		)

		-----------------------------------------------
		--@event: pressed | Elimina los vertices que no son usados por una cara.
		------------------------------------------------
		on btnDeleteIsoVerts pressed do
		(
			numObjsCleaned = 0
			for i = 1 to selection.count do
			(
				sel = selection[i]
				_objClass = classof sel.baseobject
				try
				(
					if (meshop.getIsoVerts sel.mesh).numberset > 0 then
					(
						if _objClass == editable_mesh then (meshop.deleteIsoVerts sel.baseobject; numObjsCleaned +=1 )
						if _objClass == editable_poly then (sel.baseobject.deleteIsoVerts(); numObjsCleaned +=1 )
					)--if
				)--try
				catch()
			)--for
			messageBox (numObjsCleaned as string + " objects cleaned.")
		)

		-----------------------------------------------
		--@event: pressed | Copia el vertexColor de unos vertices a otros.
		------------------------------------------------
		on btnVCcopy pressed do
		(
			if selection.count == 1 then 
			(
				VCbuffer = #()
				numVerts = $.baseobject.mesh.verts.count
				
				pbNormalize.value = 0
				pbNormalize.visible = true
				
				for i = 1 to numVerts do
				(
					append VCbuffer (getvertcolor $.baseobject.mesh i)
					pbNormalize.value = i * 100 / numVerts 
				)--for
			)--if
			else
				messageBox "Debe seleccionar 1 objecto."
			
			pbNormalize.visible = false
			pbNormalize.value = 0
		)

		-----------------------------------------------
		--@event: pressed | Pega el vertexColor de unos vertices a otros.
		------------------------------------------------
		on btnVCpaste pressed do
		(
			pbNormalize.value = 0
			pbNormalize.visible = true
			
			for _obj in selection do
			(
				numVerts = _obj.baseobject.mesh.verts.count
				
				 for i = 1 to numVerts where VCbuffer[i] != undefined do 
				(
					lb.vertexColor.setvertexcolor _obj i VCbuffer[i] 
					pbNormalize.value = i * 100 / numVerts 
				)--for
			)--for
			
			pbNormalize.visible = false
			pbNormalize.value = 0
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
			initListView lvMultiEdit
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			cancelPicking()
			removeSelChangeHandler()
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta vertexColorManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_vertexColorManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Vertex Color Manager",		--@var: description | Descripcion de la tool.
		
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

		----------------------------------------------------------------------------------------------------------------
		--@fn: undefined | vertexSelection | Comprobamos la seleccion de los vertices.
		----------------------------------------------------------------------------------------------------------------
		fn vertexSelection =
		(
			sel = getCurrentSelection()

			if sel.count > 0 then
			(
				if (getSelectionLevel sel[1] == #vertex) and sel[1].mesh.selectedVerts.count != 0 then 
				(
					-- primero nos aseguramos de que el objeto actual tiene soporte para vertex colors
					_obj = classof sel[1]
					
					if (_obj == editable_mesh) or (_obj == editable_poly) then 
					(
						if not lb.vertexColor.hasVertexColorChannel sel[1] then lb.vertexColor.createVertexColorChannel sel[1]
						
						col = getVertColor sel[1].mesh sel[1].mesh.selectedVerts[1].index
						this.rollMain.cpColCurrent.color = col
						this.rollMain.setCurrentColor col updateVertex:false
					)--if
				)--if
			)--if
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
			createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
		
	)--tl_vertexColorManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_vertexColorManager() --crea la herramienta
)