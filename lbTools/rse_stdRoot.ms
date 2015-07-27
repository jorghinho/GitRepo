------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solución de spine de edición standard Fk
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rse_standardLeg | Contiene la solución del brazo de anim.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rse_stdRoot
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #root,					--@var: category | Categoria de la solución. Puede valer, #arm, #leg, #spine...
		subCategory = #AnimEdit,				--@var: subCategory | Subcategoria de la solución, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la solución, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,							--@var: index | Indice para ordenar
		
		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la solución.
		description = "Solución de spine de rig de ediciíon Fk",							--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		solutionParameters = lb.rig.solutions.params,
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		-----------------------------------------------------------------------------------------------
			
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
		--@fn: array{nodes} | createSolution | Añadimos la informacion de los nodos de la parte de la solucion para crear el esqueleto de skin, o de rig.
		------------------------------------------------
		fn createAuxChain nodes root excludeIndexBones:false =
		(
			-- Array donde guaradaremos todos los bons creados.
			_AnimEditBones = #()
			
			-- Base del personaje si existe
			_base = lb.rig.solutions.getBaseNode type:#AnimEdit
			
			-- Variables para guardar los helpers del rig de edición, para construir los huesos.
			_pelvisEndHLP = undefined
			_rootHLP = undefined
			
			_rootBON = undefined
			_pelvisBON = undefined
			
			-- Recorremos los nombres de todos los objetos para filtrar y guardarlo en variables.
			for o in nodes do
			(
				_namePart = filterString o.node.name "_"
				
				for p in _namePart do
				(
					_filterPart5 = filterString _namePart[5] "-"

					case _filterPart5[1] of
					(	
						"root": _rootHLP = o.node
						"pelvisEnd": _pelvisEndHLP = o.node
					)--case p of
							
				)--for p in _namePart do 
			)--for o in
			
			-- Creamos la cadena de huesos y cambiamos de nombre.
			(
				-- ROOT
				_rootBON = lb.rig.createNewBone _rootHLP.pos _rootHLP.pos _rootHLP
				_rootBON.name = _rootHLP.name
				_rootBON.rotation.controller.x_rotation = 0
				_rootBON.rotation.controller.z_rotation = -90
-- 				
				_rootBON.name = lb.nc.replaceNamePart _rootBON.name 5 lb.nc.NC_ANIM_root
				_rootBON.name = lb.nc.replaceNamePart _rootBON.name 7 lb.nc.NC_frozenFlag
-- 								
				append _AnimEditBones _rootBON
				
				-- PELVIS
				_pelvisBON = lb.rig.createNewBone _rootHLP.pos _pelvisEndHLP.pos _pelvisEndHLP
				_pelvisBON.name = _pelvisEndHLP.name
				
				_pelvisBON.name = lb.nc.replaceNamePart _pelvisBON.name 5 lb.nc.NC_ANIM_pelvis
				_pelvisBON.name = lb.nc.replaceNamePart _pelvisBON.name 7 lb.nc.NC_frozenFlag
				
				lb.rig.flipAxis #(_pelvisBON)  true true false	
				lb.rig.flipVis #(_pelvisBON)  true true false	
				
				_pelvisBON.parent = _rootBON
				
				append _AnimEditBones _pelvisBON			
			)
			
			-- Cambio de propiedades de tamaño, y emparentamientos
			(
				-- SPINE
-- 				-- Multiplicamos un tamaño por defecto de huesos para si escalamos el personaje se mantenga.	
				_AnimEditBones.width = (2 * _base.scale[1])
				_AnimEditBones.height = (2 * _base.scale[1])
				_AnimEditBones.taper = 90
-- 				
				_rootBON.width = (3 * _base.scale[1])
				_rootBON.height = (3 * _base.scale[1])
				_rootBON.length = (3 * _base.scale[1])
				_rootBON.taper = 90 
-- 				
				_AnimEditBones.wirecolor = red
-- 								
-- 				-- Quitamos todas las aletas.
				_AnimEditBones.frontFin = false
				_AnimEditBones.sideFins = false
				_AnimEditBones.backFin = false
			)	
								
			-- Freezeamos todas los huesos nuevos y quitamos los sideFins.
			for b in _AnimEditBones do lb.controller.freezeTransform b #all				
			
			_AnimEditBones
		),
		
		------------------------------------------------
		--@fn: boolean | create | Crea la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn addSolutionInfo solutionRoot =
		(
			if solutionRoot.custAttributes[#solutionInfo] != undefined then 
				custAttributes.delete solutionRoot (custAttributes.getdef solutionRoot.solutionInfo) baseobject:false
			
			custAttributes.add solutionRoot (lb.rig.solutions.ca_solutionInfo()) #unique baseobject:false
			
			custAttributes.add solutionRoot.solutionInfo solutionParameters #unique baseobject:false
			
			-- Rellenamos los parametros expecificos, nombre de solución, y connectionID
			solutionRoot.solutionInfo.solutionName = (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	
			solutionRoot.solutionInfo.connectionId = "anthropomorphic"	
				
			-- Los inicializamos con los parametros que puede rellenar	
			solutionRoot.solutionInfo.init()
			solutionRoot.solutionInfo.params.init()
		),			

		------------------------------------------------
		--@fn: boolean | remove | Elimina la solución. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la solución de la categoria.
		------------------------------------------------
		fn create solutionRoot =
		(
			-- Elimina la solución respecto al padre de la solución.
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
		
	)--rse_standardSpine
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rse_stdRoot() --crea la libreria
)