------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de skin de fkIk
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strSkinNodes | Contiene las piezas de anim de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strSkinNodes
	(
		legSolutionHLP			= undefined,				-- Helper del cual colgará toda la estructura
		thigh 					= undefined,				-- Nodo de rig de la clavicula.
		calf 					= undefined,				-- Nodo de rig del upperArm.
		instep					= undefined,				-- Nodo de rig del forearm.
		toeCap 					= undefined,				-- Nodo de rig de la mano.
		toes					= #()						-- Nodos de los dedos de la mano.
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rss_fkikLeg | Contiene la solución de plantilla
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rss_stdLeg
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		solutionParameters = lb.rig.solutions.params, 		--@var | self | Almacena el ca especifico de la solución.
		
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #leg,					--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #skin,				--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,								--@var: index | Indice para ordenar

		
		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de brazo de skin fkIk",										--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		skinNodes 					= strSkinNodes(),			--@var: skinNodes | Nodos de la cadena de hueso de rig.
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
			this.skinNodes.toes = #()

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
							"thigh": this.skinNodes.thigh = o
							"calf": this.skinNodes.calf = o
							"instep": this.skinNodes.instep = o
							"toeCap": this.skinNodes.toeCap = o
							
							-- Para  obtener todas los dedos  indexadas.
							default:
							
								if (findstring _filterParts[5] "toe" != undefined) then
									append this.skinNodes.toes o
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
			
			this.skinNodes.legSolutionHLP = lb.rig.createPointFromObj this.skinNodes.thigh
			
			-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
			this.skinNodes.legSolutionHLP.name = lb.nc.replaceNamePart this.skinNodes.legSolutionHLP.name 5 "leg-solution-root"
			this.skinNodes.legSolutionHLP.name = lb.nc.replaceNamePart this.skinNodes.legSolutionHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			this.skinNodes.legSolutionHLP.size = 15 * _baseAnimEdit.scale[1]
			this.skinNodes.legSolutionHLP.cross = false
			this.skinNodes.legSolutionHLP.wirecolor = red
			
			lb.controller.freezeTransform  this.skinNodes.legSolutionHLP #all
			
			this.skinNodes.thigh.parent = this.skinNodes.legSolutionHLP
			
			-- Obtenemos todos los nodos necesarios para la solución y los guardamos, recorriendo la jerarquia creada por virtual parents.
			_skinNodesAll = lb.rig.getAllChildren this.skinNodes.legSolutionHLP
			
			for _b in _skinNodesAll do lb.controller.freezeTransform _b #all
				
			-------------------------------------------------------
			-- SKIN_CONNECTION_INFO
			-------------------------------------------------------		
			lb.skinConnectionInfo.add _skinNodesAll #connectionPos true replace:true
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
					for o in (_skinNodesAll + this.skinNodes.legSolutionHLP) do 
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
			
			-------------------------------------------------------
			-- CREACIÖN DE DYNCONNECTION
			-------------------------------------------------------
			(
				_pelvis = (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classSkin + "_" + lb.nc.NC_locationMiddle + "_" + lb.nc.NC_anim_pelvis + "_" + lb.nc.NC_nonSpecifiedCache + "_" + (lb.nc.NC_inheritFlag + lb.nc.NC_skinFlag))
				
				lb.dynConnect.addAttribute this.skinNodes.legSolutionHLP 
				lb.dynConnect.addTarget this.skinNodes.legSolutionHLP #link _pelvis alternateTargetNodes:#() connectOnLoad:false keepInitialOffset:true
			)
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
				_legTemp = solutionRoot.solutionInfo.params.createBones()
				lb.rig.solutions.createFkIkChains _legTemp chainType:#skin
				
				this.fillStructNodes()				
				createConnections side
				
				lb.rig.solutions.addSolutionInfo this.skinNodes.legSolutionHLP (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	 solutionParameters 1.0
				
					
					
				delete _legTemp
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
		
	)--rss_fkikLeg
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rss_stdLeg() --crea la libreria
)