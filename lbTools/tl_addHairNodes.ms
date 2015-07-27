------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Herramienta para cargar los objetos del pelo
------------------------------------------------------------------------------------------------------------------------------------------------
(
	-- Esto es un apaño, cuando se transformen todas las herramientas dejará de pasar porque se pasará a una libreria.
	global getSelectedAssets
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene el rollout de la herramienta addHairNodes
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "addHairNodes" width:160 height:70
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		-------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 160															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 70															--@var: integer | minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		local _filename = #() 																--@var: array{string} | _filename | Array para rellenar con el nombre del archivo a mergear pasando lo a mano.
		local _partAnimation = #()  														--@var: array{string} | _partAnimation | Array para rellenar con las partes de anim y facial que sean animables.
		local _asset  = #()	 																--@var: array{struct} | _asset | Array para rellenar con los asset seleccionados.
		local _hairDrv = #()  																--@var: array{nodes} | _hairDrv | Array para rellenar con las partes de hair que tengan la parte drv en su NC 5ºparte.
		local _meshHead = #()  																--@var: array{nodes} | _meshHead | Array para rellenar con la cabeza del mesh para añadir en el skin Wrap.
		local _hairNodes = #() 																--@var: array{nodes} | _hairNodes | Array para rellenar con las piezas mergeadas de hair.
		local _hairArm = #() 																--@var: array{nodes} | _hairArm | Array para rellenar con las piezas mergeadas de hair que sean diferentes de head.
		local _meshArm = #() 																--@var: array{nodes} | _meshArm | Array para rellenar con los mesh "arm" para el skinWrap.
		local _mergeFolder = #() 															--@var: array{string} | _mergeFolder | Array para rellenarlo con la ruta del merge.
		local _stop = false 																--@var: boolean | _stop | Booleano para control de loops.
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		groupBox grp1HairDriver "hair driver" pos:[8,8] width:144 height:50
		button btnHairApply "hair apply" pos:[32,25] width:96 height:24
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		--@fn: undefined | setInitialAssetPose | Obtener todas las piezas animables del anim y facial, meterlas en un array, y crear claves en fotograma inical y hacer un transform to zero 15 frames antes del inicial y crear clave.
		------------------------------------------------------------------------------
		fn setInitialAssetPose =
		(
			_assetSelection = lb.assetManager.getSelectedAssets() --obtengo el asset seleccionado
			
			for _a in _assetSelection do
			(
				_partAnimation = #()
				
				--Array con todas las piezas animables del asset seleccionado, tanto de anim como de facial.
				_partAnimation = lb.asset.getAssetAnimNodes _a #all excludeExtras:false
				
				max tool animmode --activa el auto key
				
				--crear claves en todas las piezas animables en el fotograma inicial y 15f menos.
				for _o in _partAnimation do	lb.animInfo.createAnimTracksKey _o time:currentTime

				sliderTime = animationRange.start
				
				for _o in _partAnimation do
				(
					lb.controller.transformToZero _o #all
					lb.animInfo.createAnimTracksKey _o time:currentTime
				)
				max tool animmode --desactiva el auto key
			)
		)--End Fn setInitialAssetPose
		
		------------------------------------------------------------------------------
		--@fn: array{nodes} | mergeHairNodes | mergea las piezas de hair en la escena y las configura, nombre, etz.
		--@gets: struct | ast | El asset al que mergearle las piezas de pelo.
		--@returns: array{nodes} | _hairNodes | Devuelve una array con los assets nmergeados en escena.
		------------------------------------------------------------------------------
		fn mergeHairNodes ast =
		(
			--Obtenemos el asset seleccionado y lo filtramos para obtener su ruta con su archivo .max para mergear las piezas de hair.
			_selectAsset = ast
			_mergeFolder = _selectAsset.folder + @"version\part\"
			
			--Mergeamos los archivos necesarios pasandole a mano el archivo a mergear.
			_filename = getOpenFileName filename:_mergeFolder
			_hairNodes = undefined
			
			if _filename != undefined then
			(
				_success = mergeMAXFile _filename #select
				
				--metemos en un array las partes mergeadas de hair, asi podemos acceder a ellas.
				_hairNodes = getcurrentselection()
				
				--captura la capa para eliminarla mas tarde
				_layerHair = _hairNodes[1].layer.name
				
				--recorremos el array de Hair para cambiar el NC de estos acorde al archivo y meterlos en su capa.
				for _o in _hairNodes do
				(
					--cambio nombre de los elementos mergeados acorde al personaje.
					_filterPart = filterstring _o.name "_"
					_o.name = _filterPart[1] + "_" + ast.name + "_" + _filterPart[3] + "_" + _filterPart[4] + "_" + _filterPart[5] + "_" + _filterPart[6] + "_" + _filterPart[7]
					
					--mete las partes de Hair en la capa del asset que corresponde.
					_typeLayer  = ast.layer.name
					lyChr = layermanager.getLayerFromName _typeLayer
					lyChr.addNode _o
					
					--Filtra el nombre de los objetos mergeados y busca las piezas con "DRV".
					--Si las encuentra, la saca del array de hair y lo mete en otro para gestionarlo por separado.
					_filterPartName = filterstring _filterPart[5] "-"
					
					for _n in _filterPartName do
					(
						if _n == lb.nc.NC_CLOTH_drv then --detecta las piezas drv y las mete en un array.
						(
							append _hairDrv _o
						)
					)
				)
				
				--elimina las piezas drv del array _hairNodes para tener 2 arrays, uno de piezas de cloth para skinWrap y otro para skin.
				for _i = _hairNodes.count to 1 by -1 do
				(
					_filterPart = filterstring _hairNodes[_i].name "_"
					_filterPartName = filterstring _filterPart[5] "-"
					
					if _filterPartName[2] == lb.nc.NC_CLOTH_drv then deleteitem _hairNodes _i
				)
				
				--detecta piezas de hair que no sean de la cabeza y las mete en otro array.
				for _o in _hairNodes do
				(
					_filterPart = filterstring _o.name "_"
					_filterPartName = filterstring _filterPart[5] "-"
					
					if _filterPartName[1] == "arm" then
					(
						append _hairArm _o
					)
				)
				
				--Elimina del array _hairNodes las piezas de hair que no sean de la cabeza, como las partes de brazos.
				for _i = _hairNodes.count to 1 by -1 do
				(
					_filterPart = filterstring _hairNodes[_i].name "_"
					_filterPartName = filterstring _filterPart[5] "-"
					
					if _filterPartName[1] != "head" then deleteitem _hairNodes _i
				)
				
				--filtramos el asset seleccionado para obtener su ruta con su archivo skn.para el modificador skin.
				_skinFolder = _selectAsset.folder + @"rig\skin\v01\"
				_fileName = getFiles (_skinFolder + "*" + "_" + "*" + "_" + lb.nc.NC_classMesh + "_" + "*" + "_" + "head-hair-proxy" + "_" + "*" + "_" + "*" + ".skn")
				
				--Añadimos el modificador skin a las piezas con drv y le cargamos la influencia de vertex automaticamente.
				for _o in _hairDrv do
				(
					--Metemos el modificador skin en las partes con Drv y cargamos la información de vértices y configuramos los valores.
					_modSkin = lb.skin.addSkinModifier _o
					if (_fileName[1] != undefined) then
					(
						lb.skin.loadSkin _fileName[1] _modSkin loadVertexData:true loadEnvelopeData:true replaceBones:true loadVertexType:#byVertexNumber loadSelectedVertsOnly:false
						
						_timeLine = sliderTime
						_o.modifiers[#Skin].ref_frame = _timeLine
						_o.modifiers[#Skin].always_deform = false
						_o.modifiers[#Skin].always_deform = true
					)
				)
				
				--Obtenemos la pieza de mesh "head" y "arm" para pasarsela mas adelante en los skinWrap.
				_assetMesh = _selectAsset.meshnodesall
				for _o in _assetMesh do
				(
					_filterPart = filterstring _o.name "_"
					if _filterPart[5] == "head" then
					(
						append _meshHead _o
					)
					
					if _filterPart[5] == "arm" then
					(
						append _meshArm _o
					)
				)
				
				--Añadimos el skinWrap a las piezas de cloth q sean Head y lo configuramos.
				for _o in _hairNodes do
				(
					_mod = _o.modifiers
					skinW = Skin_Wrap ()
					_swm = #()
					for _m = _mod.count to 1 by -1 do
					(
						--Comparamos los modificadores para eliminar los WSM, ya que dan error al añadir el skinWrap, antes de eliminar lo metemos en un array.
						if superClassof _mod[_m] == SpacewarpModifier then
						(
							append _swm _mod[_m]
							deleteModifier _o _m
						)
					)
					addModifier _o skinW before:(_mod.count)
					_o.modifiers[#Skin_Wrap].meshlist = _meshHead
					_o.modifiers[#Skin_Wrap].engine = 0
					_o.modifiers[#Skin_Wrap].weightAllVerts = on
					for _m in _swm do
					(
						addModifier _o _m
					)
				)
				
				--Añadimos el skinWrap a las piezas de cloth q sean Arm, y lo configuramos.
				for _o in _hairArm do
				(
					_mod = _o.modifiers
					skinW = Skin_Wrap ()
					_swm = #()
					for _m = _mod.count to 1 by -1 do
					(
						--Comparamos los modificadores para eliminar los WSM, ya que dan error al añadir el skinWrap, antes de eliminar lo metemos en un array.
						if superClassof _mod[_m] == SpacewarpModifier then
						(
							append _swm _mod[_m]
							deleteModifier _o _m
						)
					)
					addModifier _o skinW before:(_mod.count)
					_o.modifiers[#Skin_Wrap].meshlist = _meshArm
					_o.modifiers[#Skin_Wrap].engine = 0
					_o.modifiers[#Skin_Wrap].weightAllVerts = on
					for _m in _swm do
					(
						addModifier _o _m
					)
				)
				layermanager.deleteLayerByName _layerHair		--Elimina la capa
				_meshHead = #()
				_swm = #()
				_hairDrv = #()
				_meshArm = #()
				_hairArm = #()
			)

			
			_hairNodes
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | addHairNodes | añade las partes del pelo usando la Fn mergeHairNodes y termina dejando el personaje como estaba al principio.
		--@gets: node | asts |  pasa los asset seleccionados en el asset Manager
		------------------------------------------------------------------------------
		fn addHairNodes asts = 
		(
			for _asset in asts where not _stop do
			(
				--Cambiar el modo de visualización a modo skin
				lb.asset.setAssetSkinMode _asset
				
				if _asset.hairNodesAll.count != 0 then
				(
					reloadHair = yesNoCancelBox "do you want reload hair?"
					if reloadHair == #yes then
					(
						delete _asset.hairNodesAll --Elimina todas las partes de hair.
						
						mergeHairNodes _asset --función para la carga de las piezas de hair.
					)
					else if reloadHair == #no then	_stop = true
					else if reloadHair == #cancel then _stop = true
				)
				else
				(		
					_success = mergeHairNodes _asset --función para la carga de las piezas de hair.
					if _success == undefined then _stop = true
				)
			)
			
			animationRange = (interval (animationRange.start + 15f) animationRange.end)	--deja el timeLine como estaba en principio.
			if lb.assetManager.isOpen() then lb.assetManager.rollAdvanced.btnRefresh.pressed() --refresca el menu asset manager para actualizarlo.
			
			if _stop then MessageBox "Hair cancelled"
			
			if not _stop then
				MessageBox "Hair Add in selection assets."
		)--End fn addHairNodes
		
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
		---------------------------------------------------------------------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el botón
		--@control: button | btnHairApply | Revisa el assetManager, si no hay asset saca mensaje, si detecta algún asset ejecuta la función addHairNodes.
		---------------------------------------------------------------------------------------------------------------
		on btnHairApply pressed do
		(
			--Si el asset manager no esta abierto, lo abrimos para que nos rellene sceneAssets
			if not lb.assetManager.isOpen() then
			(
				_tool = (lb.getTool "assetManager")
				_tool.run() --lanza la herramienta.
			)
			
			--Si no encuentra ningun asest devuelve el mensaje, pero si tiene algún asset ejecuta la tool.
			_stop = false
			if lb.asset.sceneAssets.count == 0 then
			(
				MessageBox "There are no assets in scene."
			)
			else
			(
				if keyboard.escPressed then _stop = queryBox "Do you want cancel and remove hair nodes?"  
				(getClassInstances turboSmooth).enabledInViews  = false
				animationRange = (interval (animationRange.start - 15f) animationRange.end)
				setInitialAssetPose()
				addHairNodes (lb.assetManager.getSelectedAssets())	--getSelectedAssets obtiene los asset seleccionados, esta en el assetManager.
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
	--@struct: templateTool | Contiene la herramienta addHairNodes
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_addHairNodes
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,													--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la tool.
		description = "Tool plantilla",										--@var: string | description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string | cfgFile | Archivo de configuracion de la tool.
			
		opened = false,														--@var: boolean | opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,												--@var: rollout | rollMain | Almacena el rollout principal de la herramienta.
			
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
	
	tl_addHairNodes() --crea la herramienta
)