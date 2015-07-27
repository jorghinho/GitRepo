------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de selectionSets
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: selectionSets | Contiene la libreria de selectionSets.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_selectionSets
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria selectionSets",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
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
		--@fn: boolean | exportSelectionSets | Exporta el selection set a un archivo .ini que le hemos pasado con el parámetro iniFile. Devuelve True si exporta algun selection set y false si no.
		------------------------------------------------
		fn exportSelectionSets iniFile =
		(
			if  selectionSets.count != 0 do --Si hay algún selectionSet
			(
				setIniSetting iniFile "ssMain" "ssCount" (selectionSets.count as String) --Añadimos al principio en numero total de selectionSets que hay en el ini
				for i=1 to selectionSets.count do --Recorremos todos los selectionsets
				(
					setIniSetting iniFile ("ss"+(i as String)) "name" ((getNamedSelSetName i) as String) --Para cada uno le llamamos "ss" + el numero que le corresponda y dentro creamos una categoría nombre con el nombre del selection set
					setIniSetting iniFile ("ss"+(i as String)) "count" ((getNamedSelSetItemCount i) as String)
					for j=1 to (getNamedSelSetItemCount i) do --Luego agregamos todos los nombres de objetos pertenecientes al selection set. 
						setIniSetting iniFile ("ss"+(i as String)) ("obj"+(j as String)) ((getNamedSelSetItem i j).name)
				)--for
			)--if
			
			(selectionSets.count !=0)
		),


		------------------------------------------------
		--@fn: integer | importSelectionSets | Importa el selection set de un archivo .ini. 
		--@example: En funcion de lo que devuelve los posibles resultados son:
		--@example: (-1):El archivo no contiene informacion de selection sets.
		--@example: (0):El archivo no contiene selection sets.
		--@example: (1):No se encuentran archivos en la escena.
		--@example: (2):Todos los selection sets importados.
		--@example: (3):Selections sets importados, algunos objetos no estan en la escena.
		------------------------------------------------
		fn importSelectionSets iniFile =
		(
			_result = -1

			_ssCount = getINISetting iniFile "ssMain" "ssCount" --Obtengo el numero de selectionSets del archivo.Contador de sets que he logrado añadir.
			if _ssCount != "" do --Si el valor existe entonces seguimos.
			( 
				_ssCount = _ssCount as Integer --Convertimos el contador a entero
				if _ssCount != 0 then
				(
					_createdSets = 0 --Me creo un contador de los sets que he conseguido crear.
					_partialSets = false --Me creo un flag para indicar si hay assets parcialmente agregados.
					
					for i=1 to _ssCount do --Me recorro todos los elementos
					(	
						_ssName = getINISetting iniFile ("ss"+(i as String)) "name" --Recogemos el nombre del ss actual
						_nodesCount = (getINISetting iniFile ("ss"+(i as String)) "count") as Integer --Recogemos el numero de nodos del selection set
						_nodeNames = for j=1 to _nodesCount collect (getINISetting iniFile ("ss"+(i as String)) ("obj" + (j as String))) --Recogemos todos nombres de los nodos del selection set
						_nodes = #() --Me creo un array de nodos para montar el selectionSet
						for obj in Objects where (finditem _nodeNames obj.name) != 0 do append _nodes obj --Recorremos los objets cogiendo los que estén en mi lista de nombres y apilandolos en mi array de nodos.
						if _nodes.count == _nodesCount then --Si hemos encontrado algun objeto, creamos el selectionSet con el nombre que hemos obtenido y sus nodos correspondientes.
						(
							selectionSets[_ssName] = _nodes
							_createdSets +=1
						)--if
						else if _nodes.count > 1 then
						(
							selectionSets[_ssName] = _nodes
							_createdSets +=1
							_partialSets = true
						)--else if
					)-- for
					
					if _createdSets == 0 then --Si hemos añadido algún selection set
						_result = 1
					else if _createdSets == _ssCount and not _partialSets then
						_result = 2
					else --Si no hemos añadido ninguno al final.
						_result = 3
				)--if else
				else
					_result = 0
			)--if

			_result
		),
		------------------------------------------------
		--COMMON
		------------------------------------------------
			
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
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_selectionSets
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_selectionSets() --crea la libreria
)