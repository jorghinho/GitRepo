------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta ShapeCreator
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta ShapeCreator
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "ShapeCreator" width:285 height:205
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 285		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 205		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		Local _names = #()			--Array con los nombres de los shapes para la lista.
		local _listShapesName = #()	--Array de nombres de shapes que se van a mostrar en el droplist.
		local _nodes = #()			--Array de objetos temporales en la seleccion
		local _shapesTemp = #()		--Array de los shapes copiados en la escena.
		local _shapesNames = #() 	--Array que comprende los nombres de los shapes.
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--@control | controlName | Plantilla de comentario para controles
	    groupBox grp2ShapeCreator "Shapes Creator" pos:[5,5] width:275 height:195
		dropDownList ddlShapesList "Shapes List" pos:[10,20] width:265 height:40 enabled:true --items: #("shapeCircle", "shapeRectangle")
		
	    groupBox grp3EditShape "Edit Shape" pos:[10,65] width:115 height:88
	    checkbutton btnEditShapes "Edit Shape" pos:[20,85] width:96 height:32 enabled:false
		checkbox chkCenterPivot "Center Pivot" pos:[20,130] width:96 height:16 enabled:false checked:false
		
	    groupBox grp4Color "Color" pos:[140,65] width:136 height:88
		colorPicker cpYellowColor "" pos:[144,80] width:30 height:16 color:(color 252 252 0) enabled:false
    	colorPicker cpRedColor "" pos:[144,105] width:30 height:16 color:(color 252 0 0) enabled:false
    	colorPicker cpGreenColor "" pos:[144,130] width:30 height:16 color:(color 0 252 0) enabled:false
    	colorPicker cpAllColor "" pos:[220,95] width:45 height:40 color:(color 0 0 155) enabled:false
		
		button btnYellow "set" pos:[174,80] width:20 height:16 enabled:false
		button btnRed "set" pos:[174,105] width:20 height:16 enabled:false
		button btnGreen "set" pos:[174,130] width:20 height:16 enabled:false
		
     	checkbutton chkPreview "Preview" pos:[15,160] width:105 height:32
    	button btnCreate "Create" pos:[155,160] width:117 height:32 enabled:false
	   
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		--@fn: undefined | createPreResetCallBacks | crea el callback PreReset para cuando se resetea el max no pete.
		------------------------------------------------------------------------------
		fn createPreResetCallBacks =
		(
			callbacks.addscript #systemPreReset "lb.shapeCreator.rollMain.resetUi()" id: #shapesCreator
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | removePreResetCallBacks | elimina el callback PreReset
		------------------------------------------------------------------------------
		fn removePreResetCallBacks =
		(
			callbacks.removeScripts #systemPreReset id: #shapesCreator
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | createSelectionChangedCallBacks | crea el callback selectionSetChange para cuando haya un cambio de seleccion cree los shapes en esa seleccion
		------------------------------------------------------------------------------
		fn createSelectionChangedCallBacks =
		(
			callbacks.addscript #selectionSetChanged "lb.shapeCreator.rollMain.selectionChange()" id: #shapesCreator
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | removeSelectionChangedCallBacks | elimina el callback selectionSetChange
		------------------------------------------------------------------------------
		fn removeSelectionChangedCallBacks =
		(
			callbacks.removeScripts #selectionSetChanged id: #shapesCreator
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | createSelectionChangedSplineCallBacks | crea el callback selectionSetChange editSpline para que al cambiar de seleccion actualice el editor de spline
		------------------------------------------------------------------------------
		fn createSelectionChangedSplineCallBacks =
		(
			callbacks.addscript #selectionSetChanged "lb.shapeCreator.rollMain.updateUiShapes()" id: #editorSpline
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | removeSelectionChangedSplineCallBacks | elimina el callback selectionSetChange editSpline
		------------------------------------------------------------------------------
		fn removeSelectionChangedSplineCallBacks =
		(
			callbacks.removeScripts #selectionSetChanged id: #editorSpline
		)
		
		------------------------------------------------
		--@fn: undefined | getShapeNamesFromLibrary | Función que gestiona los nombres de los shapes y los mete en un array para listar los nombres mas adelante.
		------------------------------------------------
		fn getShapeNamesFromLibrary =
		(
			
			--filtra el string de las funciones, quitando la parte del struct, las comas, espacios, intros, etz.
			_membersList = filterString (substituteString (substituteString (filterString (lb.shapes As String) "()")[2] " " "") "\n" "") ","
			for _m in _membersList do
			(
				--recorre las partes del array para filtrarlos por nombre para quedarnos solo con las partes que empiecen por "Shape".
				if (substring (filterString _m ":")[1] 1 5) == "shape" then
				(
					_filterShapes = substituteString (filterString _m ":")[1] "shape" ""
					append _names _filterShapes
				)
			)
			_names
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | updateUi | función para activar y desactivar las pistas del cuadro segun si esta presionado el boton preview o no.
		------------------------------------------------------------------------------
		fn updateUi =
		(
			if chkPreview.state == true then
			(
				btnEditShapes.enabled = true
				chkCenterPivot.enabled = true
				btnCreate.enabled = true
			 
				cpYellowColor.enabled = false             --activa las opciones de la herramienta
				cpRedColor.enabled = false
				cpGreenColor.enabled = false
				cpAllColor.enabled = false
				
				btnYellow.enabled = false
				btnRed.enabled = false
				btnGreen.enabled = false
			)
			else
			(
				btnEditShapes.enabled = false
				chkCenterPivot.enabled = false
				btnCreate.enabled = false
				
				cpYellowColor.enabled = false             --desactiva las opciones de la herramienta
				cpRedColor.enabled = false
				cpGreenColor.enabled = false
				cpAllColor.enabled = false
				
				btnYellow.enabled = false
				btnRed.enabled = false
				btnGreen.enabled = false
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | updateUiShapes | función para activar y desactivar las pistas del cuadro edit Shape y color segun si se selecciona un objeto tipo shape
		------------------------------------------------------------------------------
		fn updateUiShapes =
		(
			for _o in selection do
				if (classof _o == SplineShape) then
				(
					btnEditShapes.enabled = true
					chkCenterPivot.enabled = false
					
					cpYellowColor.enabled = false             --activa las opciones de la herramienta
					cpRedColor.enabled = false
					cpGreenColor.enabled = false
					cpAllColor.enabled = false
					
					btnYellow.enabled =  false
					btnRed.enabled = false 
					btnGreen.enabled =  false
				)
				else
					updateUi()
					
			if selection.count == 0 then
				updateUi()
		) 
		
		------------------------------------------------------------------------------
		--@fn: undefined | createShape | función para mergear el shape seleccionado.
		--@gets: node | nodes |  pasa el objeto seleccionado
		------------------------------------------------------------------------------
		mapped fn createShape node =	
		(
			removeSelectionChangedSplineCallBacks()
			removeSelectionChangedCallBacks()
			
			if _nodes.count != 0 then --si el número de nodos(objetos selecionados) es diferente de 0 haz.
			(
				suspendEditing which: #modify    --deshabilita el command panel
				
				--mergea el shape seleccionado desde el archivo raiz, lo mete en el array.
				_createShape = execute ("lb.shapes.shape" + (_names[ddlShapesList.selection]) + "()")
				append _shapesTemp _createShape
				
				_createShape.transform = node.transform
				lb.controller.freezeTransform _createShape #all		--freezea el objeto.
				freeze _createShape						--congela el objeto para que no puedas seleccionarlo.
				_createShape.showFrozenInGray = off	--muestra el color del shape estando freeseado.
				
				--NC coje el nombre completo del objeto seleccionado y luego lo configura segun los parametros pasados
				_createShape.name = node.name
				_shapeName = filterstring _createShape.name "_"
				
				if lb.nc.ncOK node.name then 
					_createShape.name = _shapeName[1] + "_" + _shapeName[2] + "_" + lb.nc.NC_animFileName + "_" + _shapeName[4] + "_" + _shapeName[5] + "-x-shp-x" + "_" +  "x" + "_" + "c"
				
				--mete el shape en la capa del objeto al que se hace el shape.
				_typeLayer = node.layer.name
				_lyName = _typeLayer
				_lyChr = layermanager.getLayerFromName _lyName
				_lyChr.addNode _createShape	
			)	
			--sino mergea el shape, lo captura y lo coloca en la posicion [0,0,0]
			else
			(
				suspendEditing which: #modify    --deshabilita el command panel
				
				--mergea el shape seleccionado desde el archivo raiz, lo mete en el array.
				_createShape = execute ("lb.shapes.shape" + (_names[ddlShapesList.selection]) + "()")
				append _shapesTemp _createShape
				
				lb.controller.freezeTransform _createShape #all
				freeze _createShape
				_createShape.showFrozenInGray = off	--muestra el color del shape estando freeseado.
				
				chkCenterPivot.enabled = false		--deshabilita el center pivot.
			)
			
			deselect _shapesTemp              --deselecciona los shapes
			resumeEditing which: #modify   --habilita el command panel
			createSelectionChangedCallBacks()
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | editShape | función para controlar el boton Edit Shape y configurar los shapes, añade un modificador, cambia algunos parametros  y luego colapsa los modificadores y restaura los parametros
		------------------------------------------------------------------------------
		fn editShape =
		(
			removeSelectionChangedSplineCallBacks()
			removeSelectionChangedCallBacks()
			
-- 			if chkPreview.state == false then _shapesTemp = getCurrentSelection() --añade al array shapesTemp lo seleccionado para trabajar con ello.
						
			if btnEditShapes.state == true then
			(
				select _shapesTemp
				(
					ddlShapesList.enabled = false		--deshabilita el desplegable de shapes
					cpAllColor.enabled = true
					btnYellow.enabled =  true
					btnRed.enabled = true 
					btnGreen.enabled =  true
					chkCenterPivot.enabled = true
					max modify mode
					addmodifier _shapesTemp (Edit_Spline ()) --añade modificador editable spline.
					resumeEditing which: #modify   --habilita el command panel
					subobjectLevel = 3
					toolMode.coordsys #local
					max scale
					setCoordCenter #system
				)
			)
			else
			(
				ddlShapesList.enabled = true		--habilita el desplegable de shapes
				for _o in _shapesTemp do
				(
					cpAllColor.enabled = false
					btnYellow.enabled =  false
					btnRed.enabled = false
					btnGreen.enabled =  false
					chkCenterPivot.enabled = false
					subobjectLevel = 0
					for _y in _shapesTemp do
						maxOps.CollapseNode _y false
					toolMode.coordsys #local
				)
				deselect _shapesTemp
			)
			createSelectionChangedCallBacks()
			createSelectionChangedSplineCallBacks()
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | changeColor | función para cambiar el color del shape, hay que pasarle el color requerido en true, por defecto es false.
		--@opt: undefined | yellowClr | mantiene los colores apagados por defecto.
		--@opt: undefined | redClr | mantiene los colores apagados por defecto.
		--@opt: undefined | greenClr | mantiene los colores apagados por defecto.
		------------------------------------------------------------------------------
		fn changeColor yellowClr:false redClr:false greenClr:false =
		(
			if yellowClr then
			(
				for _o in _shapesTemp do
					_o.wirecolor = color 252 252 0			--amarillo
			)
			
			if redClr then
			(
				for _o in _shapesTemp do
					_o.wirecolor = color 252 0 0			--rojo
			)
			
			if greenClr then
			(
				for _o in _shapesTemp do
					_o.wirecolor = color 0 252 0			--verde
			)
			
			if (yellowClr != true) and (redClr != true) and (greenClr !=true) then
			(
				for _o in _shapesTemp do
					_o.wirecolor = cpAllColor.color			--color a elección
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | changedCenterPivot | función para cambiar el punto de pivote de los shapes.
		------------------------------------------------------------------------------
		fn changedCenterPivot =
		(
			if chkCenterPivot.checked == true then
			(
				for _i = 1 to _shapesTemp.count do				--si esta activado el punto pivote lo deja centrado
				(
					CenterPivot _shapesTemp[_i]
					lb.controller.freezeTransform (_shapesTemp[_i]) #all
				)
			)
			else
			(
				for _i = 1 to _shapesTemp.count do
				(
					ResetPivot _shapesTemp[_i]
				)
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | shapeDelete | función para eliminar la selección de objetos.
		------------------------------------------------------------------------------
		mapped fn shapeDelete =
		(
				delete _shapesTemp
				_shapesTemp = #()
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | resetUi | función para eliminar contenido de arrays de la herramienta.
		------------------------------------------------------------------------------
		fn resetUi =
		(
			destroyDialog rollShapeCreator
			
			local posX = (getINISetting (toolsCfgPath + "\\rollShapeCreator.ini" ) "pos" "x") as integer
			local posY = (getINISetting (toolsCfgPath + "\\rollShapeCreator.ini") "pos" "y") as integer
			
			--crea el rollout principal
			rollFltRolloutFloater = createDialog rollShapeCreator pos:[posX,posY]	
			
			rolloutOpen = true
			updateToolbarButtons()
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | selectionChange | función para cambiar las selecciones en cualquier momento.
		------------------------------------------------------------------------------
		fn selectionChange =
		(
			if chkPreview.checked then
			(
				_nodes = #()
				shapeDelete()
				_nodes = getCurrentSelection()
				createShape _nodes
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
		---------------------------------------------------------------------------------------------------------------
		--evento para selecionar un shape de la lista.
		---------------------------------------------------------------------------------------------------------------
		on ddlShapesList selected _i do
		(
			if chkPreview.checked == true then
			(
				if _nodes.count == 0 then
				(
					shapeDelete()
					updateUi()
					createShape nodes
				)
				else
				(
					shapeDelete()
					updateUi()
					
					for _o in _nodes do createShape _o
				)
			)
		)
		
		---------------------------------------------------------------------------------------------------------------
		--evento para previsualizar un shape de la lista.
		---------------------------------------------------------------------------------------------------------------
		on chkPreview changed state do
		(
			_nodes = getCurrentSelection()
			updateUi()
			btnEditShapes.state = off 
			
			if state then
			(
				if _nodes.count == 0 then
				(
					createShape nodes
				)
				else
				(
					for _o in _nodes do createShape _o
				)
			)
			else
			(
				shapeDelete()
			 	createSelectionChangedSplineCallBacks()
			)
		)
		
		---------------------------------------------------------------------------------------------------------------
		--evento para activar el boton edit Shape y sus opciones.
		---------------------------------------------------------------------------------------------------------------
		on btnEditShapes changed state do
		(
			editShape()
		)
		
		---------------------------------------------------------------------------------------------------------------
		--evento para cambiar el color del shape a Yellow
		---------------------------------------------------------------------------------------------------------------
		on btnYellow pressed do
		(
			changeColor yellowClr:true
		)			
		
		---------------------------------------------------------------------------------------------------------------
		--evento para cambiar el color del shape a Red
		---------------------------------------------------------------------------------------------------------------
		on btnRed pressed do
		(
			changeColor redClr:true
		)
		
		---------------------------------------------------------------------------------------------------------------
		--evento para cambiar el color del shape a Green.
		---------------------------------------------------------------------------------------------------------------
		on btnGreen pressed do
		(
			changeColor greenClr:true
		)
		
		---------------------------------------------------------------------------------------------------------------
		--evento para cambiar el color del shape a allColor.
		---------------------------------------------------------------------------------------------------------------
		on cpAllColor changed colorcete do
		(
			changeColor()
		)
		
		---------------------------------------------------------------------------------------------------------------
		--evento para crear shapes de la lista con las actualizaciones.
		---------------------------------------------------------------------------------------------------------------
		on btnCreate pressed do
		(
			unfreeze _shapesTemp doLayer:false
			chkPreview.state = off
			btnEditShapes.state = off
			editShape()
			changedCenterPivot()
			updateUi()
			_shapesTemp = #()
			_nodes = #()
			updateUi()
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
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			ddlShapesList.items = getShapeNamesFromLibrary() --los objetos del boton son la lista de nombres con el filtro de la 5º parte.
			
			createSelectionChangedSplineCallBacks()
			createPreResetCallBacks()
			updateToolbarButtons()
			updateUiShapes()
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
			
			removePreResetCallBacks()
			removeSelectionChangedCallBacks()
			removeSelectionChangedSplineCallBacks()
			shapeDelete()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta ShapeCreator
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_ShapeCreator
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool plantilla",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_templateTool
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_shapeCreator() --crea la herramienta
)