------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta MorpherButton.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta MorpherButton.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "MorpherButton" width:220 height:110
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 110		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--@control | controlName | Plantilla de comentario para controles
		groupBox grp2MorpherButton "Morpher Button" pos:[5,5] width:210 height:100
		
		button btnAddModifiersMorpher "Add Modifiers Morpher" pos:[45,25] width:130 height:25
		button btnMergeMorphers "Merge Morphers" pos:[10,70] width:90 height:25
		button btnDeleteMorphers "Delete Morphers" pos:[120,70] width:90 height:25
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		--@fn: undefined | addMorpher | añade el modificador morpher en el sitio correcto.
		--@gets: node | obj |  pasar el objeto.
		------------------------------------------------------------------------------
		mapped fn addMorpher obj =
		(
			_tempModifiers = #() --Array para rellenar con los modificadores FFD.
			
			--Recorre los modificadores buscando  FFDs, lo añade al array y lo elimina, para añadirlo mas adelante y evitar petes.
			for j = obj.modifiers.count to 1 by -1 where (classof obj.modifiers[j]) == FFD_Binding  do
			(
				append _tempModifiers obj.modifiers[j] --Añade al array.
				deleteModifier obj obj.modifiers[j]	--Elimina el FFD.
			)
			
			if lb.modifiers.getNodeModifierIndex obj skin == 0 then	--Si no tiene modificador skin lo añade abajo del todo.
				addModifier obj (Morpher()) before:20
			else
				addModifier obj (Morpher()) before:(lb.modifiers.getNodeModifierIndex obj skin)	--Si tiene modificador skin los añade debajo.
			
			-- Añadimos el FFD eliminado anteriormente, equivale a un cortar y pegar.
			for m in _tempModifiers do addModifier obj m
				
			_tempModifiers = #()
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | mergeMorpher | mergea las piezas de la carpeta morpher.
		--@gets: string | file |  pasar la dirección del carpetas.
		--@gets: struct | ast |  pasa el asset.
		------------------------------------------------------------------------------
		fn mergeMorpherNodes file ast:undefined =
		(
			_fileObjectNames = getMAXFileObjectNames file --Obtiene los nombres de las piezas que contiene el archivo que le pasemos.
			_objectMorphNamesToMerge = #()		--Variable contendra los nombres de los objetos de tipo morph.
			_objectHeadFFDNamesToMerge = #()	--Variable contendra lo nombres de los objetos de tipo headFFD.
					
			--Filtramos los nombres para separarlos por morph o headFFD.
			for n in _fileObjectNames do 
			(
				_parts = filterstring n "_"
				
				if _parts.count == 7 then
				(
					if _parts[3] == lb.nc.NC_classMorph then	--Morph.
						append _objectMorphNamesToMerge n
					
					if _parts[5] == "headFFD" then				--headFFD.
						append _objectHeadFFDNamesToMerge n
				)
			)
			
			--Mergeamos los archivos necesarios de tipo morph.
			mergeMAXFile file _objectMorphNamesToMerge #select
			
			_mergeMorph = getcurrentselection()	--Seleccionamos los objetos mergeados
			
			if ast != undefined then	--Si se le pasa el asset.
			(
				for _o in _mergeMorph do	--Recorremos los objetos de tipo morph.
				(
					--Cambio Naming.
					_o.name = lb.nc.replaceNamePart _o.name 2 ast.name 
					
					--Mete las partes mergeadas en la capa del asset que corresponde.
					_typeLayer = ast.layer.name
					lyChr = layermanager.getLayerFromName _typeLayer
					lyChr.addNode _o
				)
			)
			
			--Mensaje para elegir si se quiere mergear el headFFD y mergeo del mismo si es #yes.
			_messageMorph = lb.message.show "Merge HeadFFD" type:#yesNoCancel pos:undefined size:[300,75] modal:true	
			if _messageMorph == #yes then
			(
				_objectFacialParent = #() --Variable donde ira el objeto facialParent.
				
				mergeMAXFile file _objectHeadFFDNamesToMerge #select
				
				_mergeHeadFFD = select (getNodeByName _objectHeadFFDNamesToMerge[1])
				_selectHeadFFD = getCurrentSelection()
				
				for n in ast.facialNodesAll do 
				(
					_parts = filterstring n.name "_"
				
					if _parts[5] == "facialParent" then
						append _objectFacialParent n
				)
				
				if ast != undefined then	--Si se le pasa el asset.
				(
					--Cambio Naming.
					_selectHeadFFD[1].name = lb.nc.replaceNamePart _selectHeadFFD[1].name 2 ast.name
					
					--Mete las partes mergeadas en la capa del asset que corresponde.
					_typeLayer = ast.layer.name
					lyChr = layermanager.getLayerFromName _typeLayer
					lyChr.addNode _selectHeadFFD[1]
					
					_selectHeadFFD[1].parent = _objectFacialParent[1]	--Linkar el objeto FFD al FacialParent.
					
					lb.controller.freezeTransform _selectHeadFFD[1] #all	--freezear el objeto FFD.
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
		--COMMON
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
		mapped fn loadSettings =
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
		--Crea los huesos según la selección hecha
		---------------------------------------------------------------------------------------------------------------
		on btnAddModifiersMorpher pressed do 
		(
			_node = (getCurrentSelection())
			
			addMorpher _node
		)
		
		---------------------------------------------------------------------------------------------------------------
		--mergea los morphers.
		---------------------------------------------------------------------------------------------------------------
		on btnMergeMorphers pressed do 
		(
			_assets = (lb.asset.getSceneAssets()) --Selección del asset.
			
			--Sacar la ruta donde esta el archivo morph.
			_assetPath = if _assets.count > 0 then _assets[1].folder else ""
			_morpherFilePath = if _assetPath != "" then _morpherFilePath = _assetPath + @"version\part\"
			
			_ast = _assets[1]	
			_filename = getOpenFileName filename:_morpherFilePath  --Abrir el menú para seleccionar el archivo que queramos.
			
			if _filename != undefined then
				mergeMorpherNodes _filename ast:_ast
		)
		
		---------------------------------------------------------------------------------------------------------------
		--Borra los morpher del asset seleccionado.
		---------------------------------------------------------------------------------------------------------------
		on btnDeleteMorphers pressed do 
		(
			_assets = (lb.asset.getSceneAssets()) --Selección del asset.
			_ast = _assets[1]
				
			_morphAll = _ast.morphNodesAll
			delete _morphAll	--Borrado de morph.
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
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
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
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_MorpherButton
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "MorpherButton",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_MorpherButton
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_MorpherButton() --crea la herramienta
)