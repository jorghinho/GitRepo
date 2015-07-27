------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de plantilla
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: misc | Contiene todas las funciones de miscellaneous.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_misc
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria miscalanea",--@var: description | Descripcion de la libreria.
		
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
		--@fn: integer | findItemByName | Busca un nombre en un array de nodos y devuelve el indice que ocupa si está y 0 si no. 
		--@gets: array{node} | nodeArray | Array de nodos donde buscar.
		--@gets: string | nameToFind | Nombre que buscar en el array de nodos
		------------------------------------------------
		fn findItemByName nodeArray nameToFind =
		(
			_names = for _n in nodeArray collect _n.name
			
			(findItem _names nameToFind)
		),
		
		------------------------------------------------
		--@fn: integer | findItemByPattern | Busca un patron en un array de nodos y devuelve el indice que ocupa si está y 0 si no. 
		--@gets: array{node} | nodeArray | Array de nodos donde buscar.
		--@gets: string | pattern | Patron que buscar en el array de nodos
		------------------------------------------------
		fn findItemByPattern nodeArray pattern =
		(
			_index = 0
			
			for i=1 to nodeArray.count where _index == 0 and matchPattern nodeArray[i].name pattern:pattern do _index = i
			
			_index
		),
		
		------------------------------------------------
		--@fn: integer | compareNodesByName | Compara dos nodos por nombre. Devuelve 0 si tienen el mismo nombre, -1 si el nombre del primero va antes que el del segundo, 1 si el nombre del segundo va antes. 
		--@gets: node | node1 | Primer nodo a comparar.
		--@gets: node | node2 | Segundo nodo a comparar.
		--@opt: boolean | invert | false | Indica si devolver el resultado invertido, para ordenaciones inversas.
		--@opt: boolean | ignoreCase | false | Indica si tener en cuenta mayusculas y minusculas.
		------------------------------------------------
		fn compareNodesByName node1 node2 invert:false ignoreCase:false =
		(
			--si alguno de los nodos es un NodeTransformMonitor se trabaja con el contenido
			if classOf node1 == NodeTransformMonitor and isValidNode node1.node then node1 = node1.node
			if classOf node2 == NodeTransformMonitor and isValidNode node2.node then node2 = node2.node
			
			if (isProperty node1 #name) and (isProperty node2 #name) then --solo si los nodos son validos
			(
				--obtiene los nombres de los dos nodos
				name1 = node1.name
				name2 = node2.name
				
				--si no tiene en cuenta mayusculas y minusculas lo pasa todo a minusculas
				if ignoreCase then
				(
					name1 = tolower node1.name
					name2 = tolower node2.name
				)--if
				
				--realiza las comparaciones
				if name1 == name2 then --si los nombres son iguales devuelve 0
					0
				else --si nos osn iguales los compara
				(
					auxArray = sort #(name1, name2)					
					if name1 == auxArray[1] then (if invert then 1 else -1)
					else (if invert then -1 else 1)
				)--if else
			)
			else 0 --si nos son validos
		),
			
		------------------------------------------------
		--@fn: integer | compareNodesByClassof | Compara dos nodos por classof de forma alfabética. Devuelve 0 si tienen el mismo nombre, -1 si el classof del primero va antes que el del segundo, 1 si el classof del segundo va antes.
		--@gets: node | node1 | Primer nodo a comparar.
		--@gets: node | node2 | Segundo nodo a comparar.
		--@opt: boolean | invert | false | Indica si devolver el resultado invertido, para ordenaciones inversas.
		--@opt: boolean | baseObject | false | Indica si comparar con el classof del objeto o el del objeto base ignorando modificadores.
		------------------------------------------------
		fn compareNodesByClassof node1 node2 invert:false baseObject:true =
		(
			--si alguno de los nodos es un NodeTransformMonitor se trabaja con el contenido
			if classOf node1 == NodeTransformMonitor and isValidNode node1.node then node1 = node1.node
			if classOf node2 == NodeTransformMonitor and isValidNode node2.node then node2 = node2.node
			
			if isValidNode node1 and isValidNode node2 then --solo si los nodos son validos
			(
				--obtiene los nombres de los classof
				name1 = (classof node1.baseObject) as string
				name2 = (classof node2.baseObject) as string
				
				--si el classof hay que obtenerlo del objeto base
				if not baseObject then
				(
					name1 = (classof node1) as string
					name2 = (classof node2) as string
				)--if
				
				--realiza las comparaciones
				if name1 == name2 then --si los nombres son iguales devuelve 0
					0
				else
				(
					auxArray = sort #(name1, name2)
					if name1 == auxArray[1] then (if invert then 1 else -1)
					else (if invert then -1 else 1)
				)--if else
			)
			else 0 --si nos son validos
		),
		
		------------------------------------------------
		--@fn: array{nodes} | sortNodesByName | Ordena los nodos de un array de forma alfabética y lo devuelve.
		--@gets: array{node} | nodes | Array de nodos a ordenar.
		--@opt: boolean | invert | false | Indica si devolver el resultado invertido, para ordenaciones inversas.
		--@opt: boolean | ignoreCase | false | Indica si tener en cuenta mayusculas y minusculas.
		--@returns: array{nodes} | Array de nodos ordenados.
		------------------------------------------------
		fn sortNodesByName nodes invert:false ignoreCase:false =
		(
			qsort nodes this.compareNodesByName invert:invert ignoreCase:ignoreCase
			
			nodes
		),
		
		------------------------------------------------
		--@fn: array{nodes} | sortNodesByClassof | Ordena los nodos de un array de forma alfabética por sus classof y lo devuelve.
		--@gets: array{node} | nodes | Array de nodos a ordenar.
		--@opt: boolean | invert | false | Indica si devolver el resultado invertido, para ordenaciones inversas.
		--@opt: boolean | baseObject | false | Indica si comparar con el classof del objeto o el del objeto base ignorando modificadores.
		------------------------------------------------
		fn sortNodesByClassof nodes invert:false baseObject:true =
		(
			qsort nodes this.compareNodesByClassof invert:invert baseObject:baseObject
			
			nodes
		),

		----------------------------------------------------------------------------------------------------------------
		-- función para renombrar y cambiar de color objToRename, tomando como referencia sourceName, cambia el tipo de objeto por classType, cambia la parte descriptiva del objeto por nameSufix y cambia los flags por otros
		-- objToRename: Objeto a renombrar.
		-- sourceName: string con el nombre que debe poner al Objeto
		-- classType: Tipo de objeto, parte 3 del nombre.
		-- nameSufix: sufijo que añadir a continuacion de la parte 5 del nombre
		-- flags: letra del último flag.
		----------------------------------------------------------------------------------------------------------------
		fn renameFromObj objToRename sourceName classType prefix:"" sufix:"" flags:"" =
		(
			
			if (sourceName != undefined) and (classof sourceName == String) and (lb.nc.ncOK sourceName) then
			(
				finalName = sourceName
				
				originalNameParts = filterString sourceName "_" -- Separa las partes del nombre por los guiones bajos "_".
				
				-- Comprueba que se ha pasado el parametro classType y sustituye en sourceName la parte 3 por classType.
				if classType != undefined then
					finalName = substituteString finalName ("_" + originalNameParts[3] + "_") ("_" + classType + "_")
				
				-- comprueba que se ha pasado el parametro prefix y sustituye en finalName la parte 5 del nombre original por esa misma parte + en contenido de sufix.
				if prefix != "" then
				(
					capName = toUpper originalNameParts[5][1] + (substring originalNameParts[5] 2 100 )
					finalName = substituteString finalName ( "_" + originalNameParts[5]) ("_" + prefix + capName) 
				)
				
				-- comprueba que se ha pasado el parametro sufix y sustituye en finalName la parte 5 del nombre original por esa misma parte + en contenido de sufix.
				if sufix != "" then
					finalName = substituteString finalName ( "_" + originalNameParts[5]) ("_" + originalNameParts[5] + sufix) 
				
				-- Comprueba que se ha pasado flags y sustituye la parte 7 del nombre original por el contenido de flags.
				if flags != "" then
					finalName = substituteString finalName (lb.nc.NC_specialTypes[1] + "_" + originalNameParts[7]) (lb.nc.NC_specialTypes[1] + "_" + flags)
				
				objToRename.name = finalName -- sustituye el nombre del objeto a renombrar, objToRename por el nombre final guardado en finalName.
				
				-- cambio de color por lado del cuerpo.
				if originalNameParts[5] == "root" then
					objToRename.wirecolor = color 255 0 0 -- Red
				else	if  originalNameParts[4] == lb.nc.NC_locationMiddle  then
					objToRename.wirecolor = color 255 255 0 -- Yellow
				else	if originalNameParts[4] == lb.nc.NC_locationLeft then
					objToRename.wirecolor = color 0 0 255 -- Blue
				else	if originalNameParts[4] == lb.nc.NC_locationRight then
					objToRename.wirecolor = color 0 255 0 -- Green
			)
		),

		----------------------------------------------------------------------------------------------------------------
		-- función para buscar un texto en el nombre de los objetos de un array y devuelve los objetos con ese texto en el array RETURNARRAY.
		-- ARRAYOBJ: array donde busca los objetos.
		-- TEXTPART: string que debe aparecer en el nombre de los objetos retornados
		-- Devuelve RETURNARRAY.
		----------------------------------------------------------------------------------------------------------------
		fn searchInArrayByString arrayObj textPart =
		(
			returnArray = #()
			
			for i=1 to arrayObj.count do
				if (findString arrayObj[i].name textPart) != undefined then -- busca el texto textPart en el nombre de los objetos del array arrayObj
					append returnArray arrayObj[i]
					
			returnArray
		),

		---------------------------------------------------------------------------
		--funcion que te dice si dos arrays son iguales
		--devuelve true si son iguales y false si no
		---------------------------------------------------------------------------
		fn areArraysEqual array1 array2 =
		(
			_areEqual = true --incialmente supone que sn iguales
			
			if array1.count != array2.count then --si no tienen el mismo numero de lementos no son iguales
				_areEqual = false
			else
				for i=1 to array1.count where _areEqual do --recorre los elementos
				(
					if classof array1[i] == array and classof array2[i] == array then --si son arrays llama recursivamente
						_areEqual = areArraysEqual array1[i] array2[i]
					else if classof array1[i] == Matrix3 and classof array2[i] == Matrix3 then --si es una matriz de transformacion se compara fila a fila
						_areEqual = ((array1[i][1] == array2[i][1]) and (array1[i][2] == array2[i][2]) and (array1[i][3] == array2[i][3]) and (array1[i][4] == array2[i][4]))
					else --el resto se compara tal cual
						_areEqual = (array1[i] == array2[i])
				)--for
				
			_areEqual
		),

		----------------------------------------------------------------------------------------------------------------
		-- función para buscar la posición en un array del objeto con el nombre especificado.
		-- ARRAYNAME: Array donde busca el objeto.
		-- SEARCHNAME: Nombre del objeto que busca en el array.
		-- Devuelve INDEX.
		----------------------------------------------------------------------------------------------------------------
		fn findObjectByName arrayName searchName =
		(
			index = 0
			for i = 1 to arrayName.count do
			(
				if (findString arrayName[i].name searchName) != undefined then
				(
					index = i
				)
			)
			index
		),

		----------------------------------------------------------------------------------------------------------------
		-- funcion para devolver todos los descendientes de un objeto
		-- necesita un nodo OBJ
		--devuevle un array de objetos
		----------------------------------------------------------------------------------------------------------------
		fn getNodeAndDescendants obj =
		(
			execute ("$'"+obj.name+"'/...* as array")
		),

		----------------------------------------------------------------------------------------------------------------
		-- funcion para devolver los flags de herencia
		-- necesita un nodo OBJ
		--devuevle un bitArray
		----------------------------------------------------------------------------------------------------------------
		fn getNodeInheritanceFlags obj =
		(
			_flags = #{} --bitarray para almacenar los flags
			
			--si el objeto no lleva link constraint devuelve los flags tal cual
			--existe un problema cuando un objeto tiene link constraint, siempre te devuelve los flags vacios, por lo tanto hay que tratarlo como caso especial.
			if (classof obj.controller == XRef_Controller) or (classof obj.transform.controller != Link_Constraint)  then
				_flags = getInheritanceFlags obj
			else --si el objeto tiene link constraint
			(
				--hay que crear un objeto auxiliar, pegarle el link params y preguntarle a el los flags
				
				--coge el lik params y se lo pega a un dummy auxiliar
				_linkParams = obj.transform.controller[1].controller
				_auxObj = Dummy()
				_auxObj.transform.controller = _linkParams
				
				_flags = getInheritanceFlags _auxObj --obtiene los flags
				
				delete _auxObj --elimina el objeto auxiliar
				_auxObj = undefined
			)
			
			_flags --devuelve los flags
		),

		----------------------------------------------------------------------------------------------------------------
		-- funcion para sobreescibir los flags de herencia
		-- necesita un nodo OBJ
		-- necesita un bitarray de flags o #none o #all
		----------------------------------------------------------------------------------------------------------------
		fn setNodeInheritanceFlags obj flags =
		(
			--si el objeto no lleva link constraint devuelve los flags tal cual
			--existe un problema cuando un objeto tiene link constraint, siempre te devuelve los flags vacios, por lo tanto hay que tratarlo como caso especial.
			if (classof obj.controller == XRef_Controller) or (classof obj.transform.controller != Link_Constraint)  then
				setInheritanceFlags obj flags
			else --si el objeto tiene link constraint
			(
				--hay que crear un objeto auxiliar, pegarle el link params y ponerle a el los flags
				
				--coge el lik params y se lo pega a un dummy auxiliar
				_linkParams = obj.transform.controller[1].controller
				_auxObj = Dummy()
				_auxObj.transform.controller = _linkParams
				
				setInheritanceFlags _auxObj flags --obtiene los flags
				
				delete _auxObj --elimina el objeto auxiliar
				_auxObj = undefined
			)
		),

		-------------------------------------------------------------------
		-- Pasamos un patrón de nombre y retorna un listado de nodos
		-------------------------------------------------------------------
		fn getNodesByPattern pattern =
		(
			_result = #()
			for o in Objects do
			(
				if matchPattern o.name pattern:pattern ignoreCase:true then
				(
					append _result o
				)
			)
			_result
		),

		-------------------------------------------------------------------
		-- Pasamos un patrón y nos retorna un nodo
		-------------------------------------------------------------------
		fn getNodeByPattern pattern = 
		(
			_nodes = getNodesByPattern pattern
			if _nodes.count > 0 then
			(
				_result = _nodes[1]
			)
			else
			(
				_result = undefined
			)
			_result
		),


		-------------------------------------------------------------------
		-- Pasa un check
		-- #assetMesh: tipo de tareas para los assets de mesh
		-- #assetProxy: tipo de tareas para los assets de proxy
		-- #assetDraft: tipo de tareas para los assets de draft
		-- #assetFacial: tipo de tareas para los assets de facial
		-- #assetLayout: tipo de tareas para los assets de Layout
		-- #assetAnim: tipo de tareas para los assets de Anim
		-- #assetCloth: tipo de tareas para los assets de Cloth
		-- #assetHair: tipo de tareas para los assets de Hair
		-- #assetMisc: tipo de tareas para los assets misceláneos o de tipos no reconocidos.
		-- #assetSset: tipo de tareas para los sets de secuencia
		-- #assetFx: tipo de tareas para los sets de secuencia
		-- #sequenceLayout: tipo de tareas para las secuencias de layout
		-- #sequenceAnim: tipo de tareas para las secuencias de animacion
		-- #sequenceCloth: tipo de tareas para las secuencias de cloth
		-- #sequenceFx: tipo de tareas para las secuencias de fx
		-- #sequenceCacheFx: tipo de tareas para las secuencias de cachéFx
		-- #sequenceCache: tipo de tareas para las secuencias de caché
		-- #sequenceHair: tipo de tareas para las secuencias de Hair
		-- #sequenceRender: tipo de tareas para las secuencias de Render.
		-- #sequenceRenderFx: tipo de tareas para las secuencias de Render Fx.
		-------------------------------------------------------------------
		fn passAssetCheck check type:undefined fix:false = 
		(
			rollAssetChecker.fillAssetArrays()
			rollAssetChecker.createTasksList type:type
			taskIndex = (findItem rollAssetChecker.taskList check)
			rollAssetChecker.makeTest taskIndex fix:fix

			for _result in rollAssetChecker.checkTasks[taskIndex].state where _result != rollAssetChecker.okMessage do
				return false
			return true
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
		
	)--lib_misc
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_misc() --crea la libreria
)