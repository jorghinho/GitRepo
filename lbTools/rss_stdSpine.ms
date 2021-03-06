------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: soluci�n de skin de fkIk
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strSkinNodes | Contiene las piezas de anim de la soluci�n.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct strSkinNodes
	(
		spineSolutionHLP				= undefined,				--  Nodo de rig padre de la soluci�n.
		spine							= #()		
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rss_fkSpine | Contiene la soluci�n de plantilla
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rss_stdSpine
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		solutionParameters = lb.rig.solutions.params, 		--@var | self | Almacena el ca especifico de la soluci�n.
		
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #spine,					--@var: category | Categoria de la soluci�n. Puede valer, #arm, #leg, #spine...
		subCategory = #skin,				--@var: subCategory | Subcategoria de la soluci�n, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la soluci�n, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,								--@var: index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la soluci�n.
		description = "Soluci�n de spine de skin standard",										--@var: description | Descripcion de la libreria.
		
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
		-- Funci�n para rellenar los arrays y nodos de la soluci�n "strRigSolutionArmFkIk". Busca en la escena todos los huesos de tipo rig
		-- para ir rellenando los nodos de RIG, FK, IK, y sus variables dependientes de cada uno.
		------------------------------------------------------------------------------------------------------------------------------------------------------
		fn fillStructNodes =
		(
			-- Vaciamos los arrays para evitar que se acumulen nodos invalidos.
			this.skinNodes.spine = #()

			-- Recorremos las cadenas almacenadas de rig, Fk, Ik, para almacenarlas en los structs de las cadenas.
			for o in objects do
			(
				_filterParts = filterString o.name "_"
				
				-- Filtramos para obtener solo las piezas de tipo rig
				if _filterParts[3] == lb.nc.NC_classSkin then
				(
					-- Recorremos los structs y determinanos si es el lado dercho o el izquierdo
					-- para m�s adelante capturar los nodos de cada cadena e ir rellenando las variables.
					if _filterParts[4] == this.side then
					(
						case _filterParts[5] of
						(
							-- Para  obtener todas los dedos  indexadas.
							default:
							
								if (findstring _filterParts[5] "spine" != undefined) then
									append this.skinNodes.spine o
						) -- case
					)-- if filter 5
				)-- if filter 4
			)--for
		),
				
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: boolean | create | Crea la soluci�n. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la soluci�n de la categoria.
		------------------------------------------------
		fn createConnections side = 
		(
			_baseAnimEdit = lb.rig.solutions.getBaseNode type:#AnimEdit
			
			this.skinNodes.spineSolutionHLP = lb.rig.createPointFromObj this.skinNodes.spine[1]
			
			-- Cambia sus propiedas de color, nombre y tama�o y lo dejamos freezeado.
			this.skinNodes.spineSolutionHLP.name = lb.nc.replaceNamePart this.skinNodes.spineSolutionHLP.name 5 "spine-solution-root"
			this.skinNodes.spineSolutionHLP.name = lb.nc.replaceNamePart this.skinNodes.spineSolutionHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
			this.skinNodes.spineSolutionHLP.size = 15 * _baseAnimEdit.scale[1]
			this.skinNodes.spineSolutionHLP.cross = false
			this.skinNodes.spineSolutionHLP.wirecolor = red
			
			lb.controller.freezeTransform  this.skinNodes.spineSolutionHLP #all
			
			this.skinNodes.spine[1].parent = this.skinNodes.spineSolutionHLP
			
			-- Obtenemos todos los nodos necesarios para la soluci�n y los guardamos, recorriendo la jerarquia creada por virtual parents.
			_skinNodesAll = lb.rig.getAllChildren this.skinNodes.spineSolutionHLP
			
			for _b in _skinNodesAll do lb.controller.freezeTransform _b #all
			
			-------------------------------------------------------
			-- SKIN_CONNECTION_INFO
			-------------------------------------------------------
			lb.skinConnectionInfo.add _skinNodesAll #connectionPos true replace:true
			lb.skinConnectionInfo.add _skinNodesAll #connectionRot true 
			lb.skinConnectionInfo.add _skinNodesAll #connectionSca true 
			lb.skinConnectionInfo.add _skinNodesAll[4] #headSystem true --a�adido headSystem en el hueso de spine.
			
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
					
					-- Renombramos los objetos a la capa chrName y los a�adimos.
					for o in (_skinNodesAll + this.skinNodes.spineSolutionHLP) do 
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
		--@fn: boolean | create | Crea la soluci�n. Devuelve true si lo consigo o false sino. 
		--@opt: string | side | Lado del cual queremos crear la solucion.
		------------------------------------------------
		fn create solutionRoot side:lb.nc.NC_locationMiddle =
		(
			-- Le pasamos el lado del brazo para crear la soluci�n necesaria.
			this.side = side
			
			undo off
			(
				-- Obtenemos los huesos de skin para m�s tarde crear las cadenas de huesos de fkIk.
				_spineTemp = solutionRoot.solutionInfo.params.createBones()
				lb.rig.solutions.createFkIkChains _spineTemp chainType:#skin
				
				this.fillStructNodes()				
				createConnections side
				
				lb.rig.solutions.addSolutionInfo this.skinNodes.spineSolutionHLP (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	 solutionParameters 1.0
				
				delete _spineTemp
			)
		),						
		
		------------------------------------------------
		--@fn: boolean | remove | Elimina la soluci�n. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la soluci�n de la categoria.
		------------------------------------------------
		fn remove solutionRoot =
		(
			-- Elimina la soluci�n respecto al padre de la soluci�n.

		),	
		
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrer�as en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librer�a.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librer�as hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecuci�n al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.rig.solutions.addSolution this --a�ade la soluci�n a la principal
		)
		
	)--rss_fkSpine
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rss_stdSpine() --crea la libreria
)