------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de skin de fkIk
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strSkinNodes | Contiene las piezas de anim de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strSkinNodes
	(
		armSolutionHLP			= undefined,				-- Helper del cual colgará toda la estructura
		clavicle 				= undefined,				-- Nodo de rig de la clavicula.
		upperarm 				= undefined,				-- Nodo de rig del upperArm.
		forearm					= undefined,				-- Nodo de rig del forearm.
		hand 					= undefined,				-- Nodo de rig de la mano.
		fingers					= #(),						-- Nodos de los dedos de la mano.
		fingersEnd				= #()						-- Nodos de los dedos de la mano.
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rss_fkikArm | Contiene la solución de plantilla
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rss_stdArm
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		solutionParameters = lb.rig.solutions.params, 		--@var | self | Almacena el ca especifico de la solución.
		
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #arm,					--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #skin,				--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,								--@var: index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de brazo de skin fkIk",										--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		skinNodes 					= strSkinNodes(),			--@var: rigNodes | Nodos de la cadena de hueso de rig.
		side						= lb.nc.NC_locationLeft,
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
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
		
		------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Función para rellenar los arrays y nodos de la solución "strRigSolutionArmFkIk". Busca en la escena todos los huesos de tipo rig
		-- para ir rellenando los nodos de RIG, FK, IK, y sus variables dependientes de cada uno.
		------------------------------------------------------------------------------------------------------------------------------------------------------
		fn fillStructNodes =
		(
			-- Vaciamos los arrays para evitar que se acumulen nodos invalidos.
			this.skinNodes.fingers = #()
			this.skinNodes.fingersEnd = #()
			
			-- Recorremos las cadenas almacenadas de rig, Fk, Ik, para almacenarlas en los structs de las cadenas.
			for o in objects do
			(
				_filterParts = filterString o.name "_"
				
				-- Filtramos para obtener solo las piezas de tipo rig
				if _filterParts[3] == lb.nc.NC_classSkin then
				(
					-- Recorremos los structs y determinanos si es el lado dercho o el izquierdo
					-- para más adelante capturar los nodos de cada cadena e ir rellenando las variables.
					if _filterParts[4] == this.side then
					(
						case _filterParts[5] of
						(
							"clavicle": this.skinNodes.clavicle = o
							"upperarm": this.skinNodes.upperarm = o
							"forearm": this.skinNodes.forearm = o
							"hand": this.skinNodes.hand = o
							
							-- Para  obtener todas los dedos  indexadas.
							default:
							(
								if (matchpattern _filterParts[5] pattern:"finger??" != false) then
									append this.skinNodes.fingers o
							
								if (matchpattern _filterParts[5] pattern:"finger??End" != false) then
									append this.skinNodes.fingersEnd o
							)
						) -- case
					)-- if filter 5
				)-- if filter 4
			)--for
		),
				
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn createConnections side = 
		(
			_baseAnimEdit = lb.rig.solutions.getBaseNode type:#AnimEdit
			
			this.skinNodes.armSolutionHLP = lb.rig.createPointFromObj this.skinNodes.clavicle
			
			-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
			this.skinNodes.armSolutionHLP.name = lb.nc.replaceNamePart this.skinNodes.armSolutionHLP.name 5 "arm-solution-root"
			this.skinNodes.armSolutionHLP.name = lb.nc.replaceNamePart this.skinNodes.armSolutionHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			this.skinNodes.armSolutionHLP.size = 15 * _baseAnimEdit.scale[1]
			this.skinNodes.armSolutionHLP.cross = false
			this.skinNodes.armSolutionHLP.wirecolor = red
			
			for b in this.skinNodes.fingersEnd do 
			(
				b.name = lb.nc.replaceNamePart b.name 7 (lb.nc.NC_inheritFlag + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			)
			
			lb.controller.freezeTransform  this.skinNodes.armSolutionHLP #all
			
			this.skinNodes.clavicle.parent = this.skinNodes.armSolutionHLP
			
			-- Obtenemos todos los nodos necesarios para la solución y los guardamos, recorriendo la jerarquia creada por virtual parents.
			_skinNodesAll = lb.rig.getAllChildren this.skinNodes.armSolutionHLP
			
			for _b in _skinNodesAll do lb.controller.freezeTransform _b #all
			
			_skinNodesAll.sideFins = false
			_skinNodesAll.backFin = false
			_skinNodesAll.frontFin = false
			
			-------------------------------------------------------
			-- SKIN_CONNECTION_INFO
			-------------------------------------------------------			
			lb.skinConnectionInfo.add _skinNodesAll #connectionPos true replace:true
			lb.skinConnectionInfo.add _skinNodesAll #connectionRot true
			lb.skinConnectionInfo.add _skinNodesAll #connectionSca true
			
			lb.skinConnectionInfo.add this.skinNodes.clavicle #headSystem true
			lb.skinConnectionInfo.add this.skinNodes.upperarm #headSystem true			
			
			setInheritanceFlags _skinNodesAll #{1..6}	
			
			-------------------------------------------------------
			-- CAPAS, LOCKS DE EJES DE PIEZAS, VIRTUAL PARENTS,  Y PROPIEDADES, 
			-------------------------------------------------------
			(
				-- Array para almacenar los nodos creados.
				_chrNodes = #()
				
				--*****************/CAPAS/******************** --
				(
					if (LayerManager.getLayer 1) == undefined then _chrLayer = lb.layer.newAssetLayer "chrName" else _chrLayer = (LayerManager.getLayer 1)
					
					lb.layer.activeLayer _chrLayer
					
					-- Renombramos los objetos a la capa chrName y los añadimos.
					for o in (_skinNodesAll + this.skinNodes.armSolutionHLP) do 
					(
						o.name = lb.nc.replaceNamePart o.name 2 "chrName"
						_chrLayer.addNode o
					)
							
					_chrLayer.nodes &_chrNodes
					
					-- Borramos la capa antiguo del esqueleto de rig
					LayerManager.deleteLayerByName "chr_animEdit"
				)
				
				--*****************/PROPIEDADES/******************** --
				(
					_chrNodes.showFrozenInGray = false
					_chrNodes.renderable = false
		
					clearSelection()
				)
			)-- LOCKS DE PIEZAS Y PROPIEDADES
		),
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@opt: string | side | Lado del cual queremos crear la solucion.
		------------------------------------------------
		fn create solutionRoot side:lb.nc.NC_locationLeft =
		(
			-- Le pasamos el lado del brazo para crear la solución necesaria.
			this.side = side
			
			undo off
			(
				-- Obtenemos los huesos de skin para más tarde crear las cadenas de huesos de fkIk.
				_armTemp = solutionRoot.solutionInfo.params.createBones()
				lb.rig.solutions.createFkIkChains _armTemp chainType:#skin
				
				this.fillStructNodes()				
				createConnections side
				
				lb.rig.solutions.addSolutionInfo this.skinNodes.armSolutionHLP (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	 solutionParameters 1.0
				
				delete _armTemp
			)
		),						

		------------------------------------------------
		--@fn: boolean | remove | Elimina la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn remove solutionRoot =
		(
			-- Elimina la solución respecto al padre de la solución.

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
			lb.rig.solutions.addSolution this --añade la solución a la principal
		)
		
	)--rss_fkikArm
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rss_stdArm() --crea la libreria
)