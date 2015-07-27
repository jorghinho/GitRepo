------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: solución de animación de spine en fk.
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: strRigNodes | Contiene las piezas de anim de la solución.
	------------------------------------------------------------------------------------------------------------------------------------------------	
	struct strAnimNodes
	(
		headSolutionHLP					= undefined,				--@var: node | headSolutionHLP | Nodo de anim padre de la solución.
		head 							= undefined,				--@var: node | head | Nodo de anim de la cabeza.
		headEnd 						= undefined,				--@var: node | headEnd | Nodo de anim de la cabeza.
		headStructureHLP				= undefined,				--@var: node | headStructureHLP | Nodo de anim helper, estructura de la cabeza.
		neck  							= undefined,				--@var: node | neck | Nodo de anim del hueso del cuello.
		neckEnd							= undefined					--@var: node | neckEnd | Nodo de anim del hueso final del cuello.
		
	)	
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attributes: paramsCA | Contiene los parametros especficos de la solución que cuelgan del solutionInfo.
	------------------------------------------------------------------------------------------------------------------------------------------------	
	paramsCA = attributes params
	(
		------------------------------------------------------------------------------------------------
		--PARAMETERS
		------------------------------------------------------------------------------------------------
		
		parameters main
		(
			------------------------------------------------------------------------------------------------
			--PARAMETERS
			------------------------------------------------------------------------------------------------

			CA_version 			type:#float  		animatable:false default: 1.0													--@var: float | CA_version | Control de versiones.
			CA_description 		type:#string 		animatable:false default: "Información para crear solución del rig de anim"  	--@var: string | CA_description | Descripción.

			
			------------------------------------------------------------------------------------------------
			--COMMON
			------------------------------------------------------------------------------------------------
			root 		type:#maxObject 	animatable:false																		--@var: maxObject | root | Objeto raiz de la solución.
			nodes		type:#maxobjectTab 	animatable:false tabSizeVariable:true													--@var: Array | nodes | Array para guardar todos los nodos de la solución.
		)
		
		------------------------------------------------
		--@fn: init | undefined | Inicializa el custAttribute, rellenando todos los datos necesarios.
		------------------------------------------------
		fn init =
		(
			-- Obtenemos el solutionRoot que le hemos pasado al custAttribute, utilizando la función, refs.dependetNodes, y pasandoselo como referencia debil.
			this.root = (nodeTransformMonitor node:(refs.dependentNodes (refs.dependents this immediateOnly:true)[1])[1] forwardTransformChangeMsgs:false)
			
			-- Obtenemos todos los nodos necesarios para la solución y los guardamos, recorriendo la jerarquia creada por virtual parents.
			_arrayHierarchy = lb.rig.getAllChildren this.root.node
			
			-- Recorremos todos los array y los añadimos como referencia debil.
			for _o in _arrayHierarchy do append this.nodes (nodeTransformMonitor node:_o forwardTransformChangeMsgs:false)
		)
		
		------------------------------------------------
		--@fn: delete | undefined | Llama a la función general para borrar la solución.
		------------------------------------------------		
		fn delete =
		(
			lb.rig.solutions.deleteSolution this.root.node
			
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rs_fkSpine | Contiene la solución de animación para la espina
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rsa_fkSpine
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),																--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),													--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #head,																	--@var: name | category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #anim,																--@var: name | subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,														--@var: name | conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,																			--@var: integer | index | Indice para ordenar

		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: string | solName | Nombre de la solución.
		description = "Solución animación de spine de fk",									--@var: string | description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		solutionParameters = paramsCA, 														--@var: customAttribute | self | Almacena el ca especifico de la solución.
		
		self = undefined,																	--@var: struct | self | Almacena la definición del struct.
		selfFile = "",																		--@var: string | selfFile | Almacena la ruta del propio archivo de script que contiene la definición.
		
		side							= lb.nc.NC_locationMiddle,							--@var: string | side | Almacena la ubicación (L,R,M,X) de la solucion 
		
		animNodes 						= strAnimNodes(),									--@var: array | animNodes | Nodos de la cadena de hueso de anim.	
		
		rigNodesAll 					= #(),												--@var: array | rigNodesAll | Nodos de todos los objetos de la cadena de anim.		
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

		------------------------------------------------
		--@fn: undefined | fillStructNodes | Función para rellenar los arrays y nodos de la solución "strRigSolutionArmFkIk". Busca en la escena todos los huesos de tipo anim para ir rellenando los nodos de anim, FK, IK, y sus variables dependientes de cada uno.
		------------------------------------------------			
		fn fillStructNodes =
		(
			-- Recorremos las cadenas almacenadas de anim, Fk, Ik, para almacenarlas en los structs de las cadenas.
			for o in objects do
			(
				_filterParts = filterString o.name "_"
				
				-- Filtramos para obtener solo las piezas de tipo anim
				if _filterParts[3] == lb.nc.NC_classAnim then
				(
					-- Recorremos los structs y determinanos si es el lado dercho o el izquierdo
					-- para más adelante capturar los nodos de cada cadena e ir rellenando las variables.
					if _filterParts[4] == this.side then
					(
						case _filterParts[5] of
						(
							"head": this.animNodes.head = o
							"neck": this.animNodes.neck = o
						)
						
						-- Captura todos los nodos de anim
						append this.rigNodesAll o
						
					)
				)--if filter 3	
			)-- for o
			
		), -- fn fillStructNodes
		
		------------------------------------------------
		--@fn: undefined | createConnection | Función para crear constraints, conexiones de anim y la solución en si.
		--@gets: string | side |  puede valer lb.nc.NC_locationLeft, lb.nc.NC_locationRight lb.nc.NC_locationMiddle
		------------------------------------------------		
		fn createConnection side = 
		(			
			----------------------------------------------------
			--CREACIÓN DE BASE
			----------------------------------------------------
			-- Buscamos la base, sino existe se crea.
			_base = lb.rig.solutions.getBaseNode()
			_baseAnimEdit = lb.rig.solutions.getBaseNode type:#AnimEdit
			_rootNode = lb.rig.solutions.getRootNode()
			_spine03 = getNodeByName (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_spine03_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag)

			----------------------------------------------------
			--CREACIÓN DE HUESOS AUXILIARES
			----------------------------------------------------
			(
				--*****************/ANIM/******************** --
				-- Creación de hueso final para emparentar cabeza y mantener orientación con el root.
				this.animNodes.headEnd = lb.rig.smartCreateEnd this.animNodes.head
				this.animNodes.headEnd.sidefins = true
				this.animNodes.headEnd.sidefinssize = 2 * _baseAnimEdit.scale[1]
				
				this.animNodes.headEnd.name = lb.nc.replaceNamePart this.animNodes.headEnd.name 5 "headEnd"
				this.animNodes.headEnd.name = lb.nc.replaceNamePart this.animNodes.headEnd.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)

				this.animNodes.headEnd.wirecolor = yellow
				
				--*****************/ANIM/******************** --
				-- Creación de hueso final para emparentar cabeza y mantener orientación con el root.
				this.animNodes.neckEnd = lb.rig.smartCreateEnd this.animNodes.neck
				this.animNodes.neckEnd.sidefins = true
				this.animNodes.neckEnd.sidefinssize = 2 * _baseAnimEdit.scale[1]
				
				this.animNodes.neckEnd.name = lb.nc.replaceNamePart this.animNodes.neckEnd.name 5 "neckEnd"
				this.animNodes.neckEnd.name = lb.nc.replaceNamePart this.animNodes.neckEnd.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)

				this.animNodes.neckEnd.wirecolor = yellow
			)	--CREACIÓN DE HUESOS AUXILIARES
			
			----------------------------------------------------
			--CREACIÓN DE HELPERS AUXILIARES
			----------------------------------------------------
			(
 				--*****************/ANIM/******************** --
				-- Creamos el armSolutión, que es de donde colgará toda la solución de la estructura y llevará almacenada la información de versión de la solución.
				this.animNodes.headSolutionHLP = lb.rig.createPointFromObj this.animNodes.neck
				
				-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
				this.animNodes.headSolutionHLP.name = lb.nc.replaceNamePart this.animNodes.headSolutionHLP.name 5 "head-solution-root"
				this.animNodes.headSolutionHLP.name = lb.nc.replaceNamePart this.animNodes.headSolutionHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.headSolutionHLP.size = 10 * _baseAnimEdit.scale[1]
				this.animNodes.headSolutionHLP.wirecolor = red
				
				-- Creamos el armSolutión, que es de donde colgará toda la solución de la estructura y llevará almacenada la información de versión de la solución.
				this.animNodes.headStructureHLP = lb.rig.createPointFromObj this.animNodes.neckEnd
				
				-- Cambia sus propiedas de color, nombre y tamaño y lo dejamos freezeado.
				this.animNodes.headStructureHLP.name = lb.nc.replaceNamePart this.animNodes.headStructureHLP.name 5 "headStructure"
				this.animNodes.headStructureHLP.name = lb.nc.replaceNamePart this.animNodes.headStructureHLP.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				this.animNodes.headStructureHLP.size = 7 * _baseAnimEdit.scale[1]
				this.animNodes.headStructureHLP.wirecolor = clrHeadBone

			)--CREACIÓN DE HELPERS AUXILIARES
			
			----------------------------------------------------
			-- MERGEO DE SHAPES DE CONTROL
			----------------------------------------------------
			(

			)-- MERGEO DE SHAPES DE CONTROL
			
			-------------------------------------------------------
			-- CREACIÓN DE CONEXIONES
			-------------------------------------------------------
			(
				--*****************/ANIM/******************** --			
				-- Añadimos constraint de rotación al point padre de la cabeza para que siga la orientación de la cabeza.
				this.animNodes.headStructureHLP.parent = this.animNodes.neckEnd
				lb.controller.freezeTransform this.animNodes.headStructureHLP #all

				-- Emparentamos la cabeza con el pointHeadStructure, frezeamos y cambiamos su color.	
				this.animNodes.head.parent = this.animNodes.headStructureHLP
				lb.controller.freezeTransform this.animNodes.head #all
				this.animNodes.head.wirecolor = clrHeadBone
				
				-- Cambiamos el color del hueso del cuello.
				this.animNodes.neck.parent = this.animNodes.headSolutionHLP
				lb.controller.freezeTransform this.animNodes.neck #all				
				this.animNodes.neck.wirecolor = clrNeckBone
				
				this.animNodes.headSolutionHLP.parent = _base
				lb.controller.freezeTransform this.animNodes.headSolutionHLP #all
			
			)-- CREACIÓN DE CONEXIONES
			
			-------------------------------------------------------------------------------
			-- CREACIÓN DE STRECHING
			-------------------------------------------------------------------------------
			(
				-- Almacenamos
				_neckAndHead = #(this.animNodes.neck, this.animNodes.head)

				lb.rig.solutions.addStrechSystem _neckAndHead
				
				--************************* -- LIMITES DE ESCALA -- ************************* --
				-- Añadimos los limites a las escalas de las piezas e instanciamos con el hueso de anim. Reasignamos el target ya que se pierde en el float expression después de la instancia.
				--//////////////////////////- ANIM-////////////////////////// --
				for b in _neckAndHead do
					b.scale.controller[#Zero_Scale_XYZ][#X_Scale][#Bezier_float].controller = float_limit upper_limit: 1000000 lower_limit: 0
				
			)-- CREACIÓN DE STRECHING
			
			
			-------------------------------------------------------------------------------
			-- CREACIÓN DE CUSTOMS ATTRIBUTES Y WIREPARAMETERS
			-------------------------------------------------------------------------------
			(
 				--//////////////////////-LINK CONSTRAINT-////////////////////// --
		
 				--//////////////////////////-WIREPARAMETERS E INSTANCIAS-////////////////////////// --

			)-- CREACIÓN DE CUSTOMS ATTRIBUTES Y WIREPARAMETERS

			-------------------------------------------------------
			-- CREACIÓN DE POINT SCRIPT
			-------------------------------------------------------
			(
			)-- CREACIÓN DE POINT SCRIPT
			
			----------------------------------------------------
			--ORDENACIÓN DE EJES
			----------------------------------------------------
			(
 				--*****************/ANIM/******************** --
				this.animNodes.head.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 3
				this.animNodes.neck.rotation.controller[#Zero_Euler_XYZ].controller.axisOrder = 3
							
			)--ORDENACIÓN DE EJES
			
			
			-------------------------------------------------------
			-- CREACION DE ANIMTRACKS
			-------------------------------------------------------
			(
				_sepTransform = #(#(#separator, "Separator01", false, "Transform"))
				_sep = #(#(#separator, "Separator01", false, ""))
					
				--*****************/ANIM/******************** --
				-- Cabeza
				lb.animInfo.setAnimTracks this.animNodes.head (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.head.rotation.controller[#Zero_Euler_XYZ] #all) + _sep + #(#(this.animNodes.head[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
						
				-- Cuello
				lb.animInfo.setAnimTracks this.animNodes.neck (_sepTransform + (lb.rig.solutions.prepareAnimTracks this.animNodes.neck.rotation.controller[#Zero_Euler_XYZ] #all) + _sep + #(#(this.animNodes.neck[#Transform][#Scale][#Zero_Scale_XYZ][#X_scale][#Float_limit], "Transform:Scale:Zero_Scale_XYZ:X_scale:Float_limit", true, "X_Scale",1)))
										
			)-- CREACION DE ANIMTRACKS
			
			-------------------------------------------------------
			-- LOCKS DE EJES DE PIEZAS, CAPAS, Y PROPIEDADES, 
			-------------------------------------------------------
			(
				-- Array para almacenar los nodos creados.
				_chrNodes = (lb.rig.getAllChildren this.animNodes.headSolutionHLP) + this.animNodes.headSolutionHLP + _base
				
				--*****************/CAPAS/******************** --
				(
					if (LayerManager.getLayer 1) == undefined then _chrLayer = lb.layer.newAssetLayer "chrName" else _chrLayer = (LayerManager.getLayer 1)
					
					lb.layer.activeLayer _chrLayer
					
					-- Renombramos los objetos a la capa chrName y los añadimos.
					for o in _chrNodes do 
					(
						o.name = lb.nc.replaceNamePart o.name 2 "chrName"
						_chrLayer.addNode o
					)
							
					-- Borramos la capa antiguo del esqueleto de rig
					LayerManager.deleteLayerByName "chr_animEdit"
				)
						
				_chrLayer.nodes &_chrNodes
 				
 				--*****************/LOCKS DE EJES DE PIEZAS/******************** --
				-- Por defecto bloqueamos todos los ejes de todas las piezas, para después ir desbloqueando las piezas que queremos animar.
				_Pos = #{4..9}
				_Rot = #{1..3,7..9}
				_PosRot = #{7..9}
				
				for o in _chrNodes where (getTransformLockFlags o).isEmpty do
					setTransformLockFlags o #all
								
				-- Grupo de piezas que liberamos solo la rotación.
				setTransformLockFlags this.animNodes.head #{1..3,8..9} -- Eje x,y,z Libre
				setTransformLockFlags this.animNodes.neck #{1..3,8..9} -- Eje x,y,z Libre
								
				-- Grupo de piezas que liberamos todas las transform.
				setTransformLockFlags _base #none
				
				--*****************/VIRTUAL PARENTS/******************** --
				(
					lb.rig.linkVirtualParent #(this.animNodes.head) this.animNodes.neck
					if _spine03 != undefined then
						lb.rig.linkVirtualParent #(this.animNodes.neck) _spine03
					else
						lb.rig.linkVirtualParent #(this.animNodes.neck) _base
				)

				--*****************/PROPIEDADES/******************** --
				_chrNodes.showFrozenInGray = false
				_chrNodes.renderable = false

				-- Ajustamos los tamaños de los shapes.
				lb.rig.snapByShape _baseAnimEdit _base
				
				clearSelection()
			)-- LOCKS DE PIEZAS Y PROPIEDADES
			
			-------------------------------------------------------
			-- SKINCONNECTION INFO, 
			-------------------------------------------------------
			(
				lb.skinConnectionInfo.add  this.animNodes.head #headSystem true replace:true
				lb.skinConnectionInfo.add  this.animNodes.neck #headSystem true
				
			)
			
			-------------------------------------------------------
			-- SELECTION SETS, 
			-------------------------------------------------------
			(
				-- Montamos el nombre del selectionset de la cabeza-cuello, spine, pelvis, y root.
				_filterName = filterString this.animNodes.head.name "_"
				_selSetHead = _filterName[1] + "_" + _filterName[2] + "_" + _filterName[3] +"_" + _filterName[4] + "_" + (_filterName[5] + "-neck")
						
				-- Añadimos las piezas a su selection set correspondiente.
				lb.objectsets.add #(this.animNodes.head, this.animNodes.neck) _selSetHead
			)-- SELECTION SETS, 

			-------------------------------------------------------
			-- CREACIÖN DE DYNCONNECTION
			-------------------------------------------------------
			(
				_rootNode = (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + lb.nc.NC_ANIM_root + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag)
				_spine03End = (lb.nc.NC_chrPrefix + "_chrName_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_spine03End_" + lb.nc.NC_nonSpecifiedCache + "_" + (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag))
				
				--	Añadido dyn a padre de cuello
				lb.dynConnect.addAttribute this.animNodes.headSolutionHLP 
				lb.dynConnect.addTarget this.animNodes.headSolutionHLP #link _spine03End alternateTargetNodes:#(_rootNode, _base) connectOnLoad:false keepInitialOffset:true
				lb.dynConnect.addTarget this.animNodes.headSolutionHLP #orientationconstraint _rootNode alternateTargetNodes:#(_base) connectOnLoad:false keepInitialOffset:true

				--	Añadido dyn a padre de  la cabeza.			
				lb.dynConnect.addAttribute this.animNodes.headStructureHLP 
				lb.dynConnect.addTarget this.animNodes.headStructureHLP #orientationconstraint _rootNode alternateTargetNodes:#(_base) connectOnLoad:false keepInitialOffset:true
			)
		), -- fn createFkIkConnection
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Raiz de la solución de la categoria.
		--@gets: (opt)string | side |  La ubicación de la solución, por defecto lb.nc.NC_locationMiddle
		------------------------------------------------
		fn create editRoot side:lb.nc.NC_locationMiddle =
		(
			-- Le pasamos el lado del brazo para crear la solución necesaria.
			this.side = side
			
			undo off
			(
				-- Obtenemos los huesos de skin para más tarde crear las cadenas de huesos de fkIk.
				_headTemp = editRoot.solutionInfo.params.createBones()
				lb.rig.solutions.createFkIkChains _headTemp chainType:#anim
							
				-- Rellenamos el struct de la solución con las piezas que se han creado del duplicado.
				this.fillStructNodes()
				
				this.createConnection side
				
				lb.rig.solutions.addSolutionInfo this.animNodes.headSolutionHLP (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string)) solutionParameters 1.0
				
				delete _headTemp
				gc()
			)
		),			

		------------------------------------------------
		--@fn: boolean | remove | Elimina la solución. Devuelve true si lo consigo o false sino. 
		--@deprecated: this function is deprecated and is no longer used
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn remove solutionRoot =
		(

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
		
	)--rs_template
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rsa_fkSpine() --crea la libreria
)