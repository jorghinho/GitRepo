------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Herramienta para atachar objetos a vertices, attach Point Vertex
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la interfaz de la herramienta attach Point Vertex
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Attach Point Vertex" width:160 height:80
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 160															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 80															--@var: integer | minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		Local _selectVertex = #() 															--@var: array{integer} | _selectVertex | Array que contiene los indices de los vertices seleccionados de un objeto.
		Local _infuenceBone = #() 															--@var: array{integer} | _infuenceBone | Array que contiene las influencias de cada uno de los huesos del vertice seleccionado.
		Local _nameBone = #() 																--@var: array{_nameBone} | _nameBone | Array que contiene los nombres de los huesos que estan influenciando con el vertex.
		Local _PointBone = #() 																--@var: array{nodes} | _PointBone | Array que contiene una coleccion de los puntos creamodos por la tool que llevaran constraint.
		Local _PointConstraint = #() 														--@var: array{nodes} | _PointConstraint | Array que contiene los puntos que son padre de la jerarquia creada por la tool.

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		groupBox grp1SpineCuadrupedo "Attach Point To Skin Vertex" pos:[8,8] width:145 height:60
		button btnCreateSpineCuadrupedo "Attach Point Vertex" pos:[25,30] width:110 height:24
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		--@fn: array{node} |  GetListBone  | Función para obtener el listado de huesos.
		--@returns: array{node} | _listBoneOrder | Los huesos usados en la tool.
		------------------------------------------------------------------------------
		fn getListBone =
		(	
			m = $.modifiers[#skin]
			
			_listBone = #()
			_listBoneOrder = #()
			_numBones = 0
			
			for k=1 to m.numSubs do
			(
				--Accedemos a los nombres de los huesos por subanims, filtrando los nombres.
				if (substring m[k].name 1 5) == "Start" then
				(
					_numBones += 1
					--Tienen que ser piezas válidas
					if (filterString (filterString m[k].name "()")[2] "_").count == 7 then
					(
						append _listBone (filterString m[k].name "()")[2]
					)
				)--if de subanim de nombre de hueso
			)--for que recorre los subanims del modificador de skin
			_listBoneOrder = sort _listBone
			_listBoneOrder
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | GetNumberVertex | Función que rellena las variables internas de la tool que controlan el numero de vertice seleccionado, la influencia y la cantidad de huesos que tienen influencia.
		--@gets: node | Obj | El objeto del que se quiere sacar la solucion.
		------------------------------------------------------------------------------
		fn GetAll obj =
		(
			--recorremos por indice todos los vertices del objeto.
			for _o=1 to (skinOps.GetNumbervertices obj[1].modifiers[#Skin]) do
			(
				--Si el vertice devuelve 1 quiere decir que este seleccionado y lo obtenemos, metiendolo en un array.
				if skinOps.IsVertexSelected obj[1].modifiers[#Skin] _o == 1 then
				(
					append _selectVertex _o
					
					--obtengo el numero de huesos que influyen en el vertice seleccionado.
					_numberBone = skinOps.GetVertexWeightCount obj[1].modifiers[#Skin] _o
					
					--Obtenemos las influencias de cada uno de los huesos del vertice seleccionado.
					for _i=1 to _numberBone do
					(
						_influence = skinOps.GetVertexWeight obj[1].modifiers[#Skin] _o _i
						append _infuenceBone _influence
					)
					
					--obtenemos el nombre de los huesos que estan influenciando con el vertex.
					for _i=1 to _numberBone do 
		 			(
						_listBoneOrder = getListBone()
						_number = skinOps.GetVertexWeightBoneID obj[1].modifiers[#Skin] _o _i
						_name = _listBoneOrder[_number]
						append _nameBone _name
					)
				)
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreatePoints  | Función para crear los point necesarios para el funcionamiento de la tool.
		--@gets: node | Obj | El objeto del que se quiere sacar la solucion.
		------------------------------------------------------------------------------
		fn CreatePoints obj =
		(
			_ast = lb.asset.getSceneAssets()
			_root = lb.rig.solutions.getRootNode()
			
			_numberModifier = (modPanel.getModifierIndex obj[1] (obj[1].modifiers [#skin])) - 1
			addmodifier obj (Edit_Poly()) before:_numberModifier --añadimos el modificador edit poly para poder capturar la posicion del vertex seleccionado.
			
			for _o in _selectVertex do 
			(
				modPanel.setCurrentObject obj[1].modifiers[#Edit_Poly]
				_position = obj[1].modifiers[#Edit_Poly].GetVertex _o --capturamos la posicion del vertex.
				deleteModifier obj[1] (_numberModifier + 1)
				
				modPanel.setCurrentObject obj[1].modifiers[#Skin]  --activar el modificador skin.
				subobjectLevel = 1
				
				--obtengo el numero de huesos que influyen en el vertice seleccionado.
				_numberBone = skinOps.GetVertexWeightCount obj[1].modifiers[#Skin] _o
				subobjectLevel = 0
				
				for _i=1 to _numberBone do 
				(
					_tempHlp = lb.rig.createPointFromObj obj[1]  --creamos los point que llevaran constraint.
					_tempHlp.pos = _position  --colocamos en posición según la posicion capturada de los vertex.
					_tempHlp.cross = off
					_tempHlp.wirecolor = yellow
					
					--Recorremos los nodos de skin del asset seleccionado para buscar la pieza semejante al nombre y hacer los emparentamientos.
					for _j in _ast[1].skinNodesAll do 
					(
						if _nameBone[_i] == _j.name then _tempHlp.parent = _j
					)
					lb.controller.freezeTransform _tempHlp #all --frezear el hueso primero
					
					append _PointBone _tempHlp  --añadimos en un array.
					
					--NC.
					_tempHlp.name = _nameBone[_i]
					_filterName = filterString _tempHlp.name "_"
					_tempHlp.name = lb.nc.replaceNamePart _tempHlp.name 5 (_filterName[5] + "-x-hlp-attach")
					_tempHlp.name = lb.nc.replaceNamePart _tempHlp.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				)
				
				for _i=1 to _PointBone.count do 
				(
					_PointBone[_i].size = 3 + _i  --configuramos el tamaño de los point.
				)
				
				_tempHlpConstraint = lb.rig.createPointFromObj obj[1]  --creamos el point padre de la jerarquia.
				_tempHlpConstraint.pos = _position  --colocamos en posición según la posicion capturada de los vertex.
				_tempHlpConstraint.cross = off
				_tempHlpConstraint.wirecolor = green
				_tempHlpConstraint.size = 3 * _numberBone  --configuramos el tamaño del point parent.
				_tempHlpConstraint.parent = _root
				lb.controller.freezeTransform _tempHlpConstraint #all --frezear el hueso primero
				
				append _PointConstraint _tempHlpConstraint  --añadimos en un array.
				
				--NC.
				_PointConstraint[1].name = lb.nc.replaceNamePart _PointConstraint[1].name 3 (lb.nc.NC_classSkin)
				_PointConstraint[1].name = lb.nc.replaceNamePart _PointConstraint[1].name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				_tempHlpConstraint.pos.controller.Available.controller = Position_Constraint ()
				_tempHlpConstraint.rotation.controller.Available.controller = Orientation_Constraint ()
				
				for _i=1 to _PointBone.count do 
				(
					_tempHlpConstraint.pos.controller.Position_Constraint.controller.appendTarget _PointBone[_i] 100
					_tempHlpConstraint.rotation.controller.Orientation_Constraint.controller.appendTarget _PointBone[_i] 100
					
					_tempHlpConstraint.pos.controller.Position_Constraint.controller.weight[_i] = _infuenceBone[_i]
					_tempHlpConstraint.rotation.controller.Orientation_Constraint.controller.weight[_i] = _infuenceBone[_i]
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

		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton
		--@control: button | btnCreateSpineCuadrupedo | Evento para crear la solución de rig de Attach Point To Vertex.
		------------------------------------------------		
		on btnCreateSpineCuadrupedo pressed do
		(
			_selectObject = getCurrentSelection() --seleccionado el objeto al que accedemos al skin.
			
			if classof _selectObject[1] == XRefObject then	--Si no hay ningún objeto seleccionado saca mensaje o ejecuta la tool.
			(
				if modPanel.getCurrentObject() == (_selectObject[1].modifiers [#skin]) then		--Si el modificador skin no esta seleccionado saca mensaje o ejecuta la tool.
				(
					GetAll _selectObject
					
					if _selectVertex != 0 then	--Si no hay ningun vertice seleccionado saca un mensaje o ejecuta la tool.
					(
						CreatePoints _selectObject
						messageBox "Attach Correct, Link object to green point"
					)
					else
					(
						messageBox "Select An Vertex in skin modifiers"
					)
				)
				else
				(
					messageBox "Select An Vertex in skin modifiers"
				)
			)
			else
			(
				messageBox "Select An object mesh"
			)
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
	--@struct: templateTool | Contiene la herramienta tl_attachPointVertex.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_attachPointVertex
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),													--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),										--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,														--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),		--@var: string | className | Nombre de la tool.
		description = "Tool plantilla",											--@var: string | description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string | cfgFile | Archivo de configuracion de la tool.
			
		opened = false,															--@var: boolean | opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,													--@var: rollout | rollMain | Almacena el rollout principal de la herramienta.
			
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
		--@fn: boolean | isOpen | Consulta si la herramienta esta abierta.
		--@returns: boolean | undefined | Devuelve **TRUE** si la herramienta esta abierta
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
		
	)--tl_attachPointVertex
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_attachPointVertex() --crea la herramienta
)