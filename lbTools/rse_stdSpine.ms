------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: soluci�n de spine de edici�n standard Fk
------------------------------------------------------------------------------------------------------------------------------------------------
(		
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: rse_standardLeg | Contiene la soluci�n del brazo de anim.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct rse_stdSpine
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #spine,					--@var: category | Categoria de la soluci�n. Puede valer, #arm, #leg, #spine...
		subCategory = #AnimEdit,				--@var: subCategory | Subcategoria de la soluci�n, indica el tipo de esqueleto. Puede valer #skin, #anim, #AnimEdit
		conectionId = #anthropomorphic,		--@var: conectionId | Tipo de conexion que lleva la soluci�n, para saber si puede conectarse con otras soluciones. Puede valer, #anthropomorphic, #quadruped, ...
		index = 10,							--@var: index | Indice para ordenar
		
		solName = lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string),	--@var: solName | Nombre de la soluci�n.
		description = "Soluci�n de spine de rig de edici�on Fk",							--@var: description | Descripcion de la libreria.
		
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
		--@fn: array{nodes} | createSolution | A�adimos la informacion de los nodos de la parte de la solucion para crear el esqueleto de skin, o de rig.
		------------------------------------------------
		fn createAuxChain nodes root excludeIndexBones:false =
		(
			-- Array donde guaradaremos todos los bons creados.
			_AnimEditBones = #()
			
			-- Base del personaje si existe
			_base = lb.rig.solutions.getBaseNode type:#AnimEdit
			
			-- Variables para guardar los helpers del rig de edici�n, para construir los huesos.
			_spineHLP = #()
			
			-- Variables para guardar los huesos  genereados, del rig de edici�n.

			_spineBON = #()

			-- Recorremos los nombres de todos los objetos para filtrar y guardarlo en variables.
			for o in nodes do
			(
				_namePart = filterString o.node.name "_"
				
				for p in _namePart do
				(
					_filterPart5 = filterString _namePart[5] "-"

					-- Buscamos los inicios de jerarquias de los dedos del pie para a�adirlos al array de hlps toes y luego crearlos
					if not excludeIndexBones then 
						if (matchPattern p pattern:"spine*") then append _spineHLP o
					
				)--for p in _namePart do 
			)--for o in
			
			-- Creamos la cadena de huesos y cambiamos de nombre.
			(
				-- SPINE
				_spineHLP = lb.misc.sortNodesByName _spineHLP
				
				-- Creamos la spine desde el spine00 hacia os hijos, independientemente de las partes que la componan.
				for i = 1 to _spineHLP.count do
				(
					if i != _spineHLP.count then
					(
						_boneTemp = (lb.rig.createNewBone _spineHLP[i].node.pos _spineHLP[i+1].node.pos _spineHLP[i].node)
						_boneTemp.name = _spineHLP[i].node.name
						
						_boneTemp.name = lb.nc.replaceNamePart _boneTemp.name 7 lb.nc.NC_frozenFlag
						
						append _spineBON _boneTemp
					)
				)-- for _spineHLP
				
				
				-- Emparentamos la columna entre s�
				for i = _spineBON.count to 2 by -1 do
					_spineBON[i].parent = _spineBON[i - 1]
				
				_spineBON[1].parent = _rootBON
				
				_AnimEditBones = _AnimEditBones + _spineBON
			)
			
			-- Cambio de propiedades de tama�o, y emparentamientos
			(
				-- SPINE
				-- Multiplicamos un tama�o por defecto de huesos para si escalamos el personaje se mantenga.	
				_AnimEditBones.width = (2 * _base.scale[1])
				_AnimEditBones.height = (2 * _base.scale[1])
				_AnimEditBones.taper = 90
								
				_AnimEditBones.wirecolor = yellow
								
				-- Quitamos todas las aletas.
				_AnimEditBones.frontFin = false
				_AnimEditBones.sideFins = false
				_AnimEditBones.backFin = false
			)	
								
			-- Freezeamos todas los huesos nuevos y quitamos los sideFins.
			for b in _AnimEditBones do lb.controller.freezeTransform b #all				
			
			_AnimEditBones
		),
		
		------------------------------------------------
		--@fn: boolean | create | Crea la soluci�n. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la soluci�n de la categoria.
		------------------------------------------------
		fn addSolutionInfo solutionRoot =
		(
			if solutionRoot.custAttributes[#solutionInfo] != undefined then 
				custAttributes.delete solutionRoot (custAttributes.getdef solutionRoot.solutionInfo) baseobject:false
			
			custAttributes.add solutionRoot (lb.rig.solutions.ca_solutionInfo()) #unique baseobject:false
			
			custAttributes.add solutionRoot.solutionInfo solutionParameters #unique baseobject:false
			
			-- Rellenamos los parametros expecificos, nombre de soluci�n, y connectionID
			solutionRoot.solutionInfo.solutionName = (lb.rig.solutions.getFileSolutionName (getThisScriptFilename() as string))	
			solutionRoot.solutionInfo.connectionId = "anthropomorphic"	
				
			-- Los inicializamos con los parametros que puede rellenar	
			solutionRoot.solutionInfo.init()
			solutionRoot.solutionInfo.params.init()
		),			

		------------------------------------------------
		--@fn: boolean | remove | Elimina la soluci�n. Devuelve true si lo consigo o false sino. 
		--@gets: node | solutionRoot | Padre de la soluci�n de la categoria.
		------------------------------------------------
		fn create solutionRoot =
		(
			-- Elimina la soluci�n respecto al padre de la soluci�n.
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
		
	)--rse_standardSpine
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	rse_stdSpine() --crea la libreria
)