------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de skin de fkIk
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strSkinNodes | Contiene las piezas de anim de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strSkinNodes
	(
		headSolutionHLP					= undefined,				--  Nodo de rig padre de la solución.
		head 							= undefined,				--	Nodo de rig de la cabeza.
		neck  							= undefined					--	Nodo de rig del hueso del cuello.	
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rss_fkHead | Contiene la solución de plantilla
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rss_stdHead
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		solutionParameters = lb.rig.solutions.params, 		--@var | self | Almacena el ca especifico de la solución.
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #head,					--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #skin,				--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,							--@var: index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de cabeza de skin standard",										--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		skinNodes 					= strSkinNodes(),			--@var: skinNodes | Nodos de la cadena de hueso de rig.
		side						= lb.nc.NC_locationMiddle,
		
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
							"head": this.skinNodes.head = o
							"neck": this.skinNodes.neck = o
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
			
			this.skinNodes.headSolutionHLP = lb.rig.createPointFromObj this.skinNodes.neck
		
			-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
			this.skinNodes.headSolutionHLP.name = lb.nc.replaceNamePart this.skinNodes.headSolutionHLP.name 5 "head-solution-root"
			this.skinNodes.headSolutionHLP.name = lb.nc.replaceNamePart this.skinNodes.headSolutionHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			this.skinNodes.headSolutionHLP.size = 15 * _baseAnimEdit.scale[1]
			this.skinNodes.headSolutionHLP.cross = false
			this.skinNodes.headSolutionHLP.wirecolor = red
			
			lb.controller.freezeTransform  this.skinNodes.headSolutionHLP #all
			
			this.skinNodes.neck.parent = this.skinNodes.headSolutionHLP
			lb.controller.freezeTransform this.skinNodes.neck #all
		
			_skinNodesAll =#(this.skinNodes.head, this.skinNodes.neck)
			
			-------------------------------------------------------
			-- SKIN_CONNECTION_INFO
			-------------------------------------------------------
			lb.skinConnectionInfo.add  _skinNodesAll #headSystem true replace:true
			lb.skinConnectionInfo.add  _skinNodesAll #headSystem true
			
			lb.skinConnectionInfo.add _skinNodesAll #connectionPos true 
			lb.skinConnectionInfo.add _skinNodesAll #connectionRot true 
			lb.skinConnectionInfo.add _skinNodesAll #connectionSca true 
			
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
					for o in (_skinNodesAll + this.skinNodes.headSolutionHLP) do 
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
		fn create solutionRoot side:lb.nc.NC_locationMiddle =
		(
			-- Le pasamos el lado del brazo para crear la solución necesaria.
			this.side = side
			
			undo off
			(
				-- Obtenemos los huesos de skin para más tarde crear las cadenas de huesos de fkIk.
				_headSolTemp = solutionRoot.solutionInfo.params.createBones()
				lb.rig.solutions.createFkIkChains _headSolTemp chainType:#skin
-- 				
				this.fillStructNodes()				
				createConnections side
-- 				
				lb.rig.solutions.addSolutionInfo this.skinNodes.headSolutionHLP (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	 solutionParameters 1.0
				
				delete _headSolTemp
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
		
	)--rss_fkSpine
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rss_stdHead() --crea la libreria
)