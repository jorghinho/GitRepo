------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de modifiers
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: modifiers | Contiene todas las funciones de modifiers.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_modifiers
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de funciones modifiers",	--@var: description | Descripcion de la libreria.
		
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
		--fn: modifier{array} | getSceneModifiers | Devuelve un array con todos los modificadores aplicados a los objetos de la escena
		------------------------------------------------
		fn getSceneModifiers =
		(
			_modifiers = #()

			for o in objects do (for m in o.modifiers do appendIfUnique _modifiers m)

			_modifiers
		),

		------------------------------------------------
		--@fn: undefined | getNodeModifierNameByIndex | Le pasamos un objeto y un tipo de modificador y nos devuelve el index de este modificador en el stack.
		------------------------------------------------
		fn getNodeModifierNameByIndex node modname =
		(
			_modIndex = 0

			for i = 1 to node.modifiers.count where node.modifiers[i].name == modname do _modIndex = i 

			_modIndex 
		),

		------------------------------------------------
		--@fn: undefined | getNodeModifierIndex | Le pasamos un objeto y un tipo de modificador y nos devuelve la posicion que tiene en el stack de modificadores.
		------------------------------------------------
		fn getNodeModifierIndex node type =
		(
			_modifierIndex = 0

			for i = 1 to node.modifiers.count where classof node.modifiers[i] == type do _modifierIndex = i

			_modifierIndex
		),
		
		------------------------------------------------
		--@fn: undefined | getNodeModifier | Le pasamos un objeto y un tipo de modificador y nos devuelve el primer modificador de ese tipo.
		------------------------------------------------		
		fn getNodeModifier node type =
		(
			_stop = false
			_modifierToReturn = undefined

			for m in node.modifiers where (not _stop) and (classof m == type) do (_stop = true; _modifierToReturn = m)

			_modifierToReturn
		),

		------------------------------------------------
		--@fn: undefined | getNodeModifiersByPattern | Le pasamos un objeto y un patron y nos devuelve los modificadores cuyo nombre lo cumplen
		------------------------------------------------ 
		fn getNodeModifiersByPattern node modPattern =
		(
			_modifiersToReturn = #() 

			for m in node.modifiers where (matchPattern m.name pattern:modPattern) do append _modifiersToReturn m

			_modifiersToReturn
		),
		
		------------------------------------------------
		--@fn: undefined | getNodeModifierByName | Le pasamos un objeto y un nombre y nos devuelve el primer modificador con ese nombre.
		------------------------------------------------	
		fn getNodeModifierByName node modname =
		(
			_modifierNameToReturn = undefined 
			_stop = false

			for m in node.modifiers where (not _stop) and (m.name == modname) do (_stop = true; _modifierNameToReturn = m)

			_modifierNameToReturn
		),

		------------------------------------------------
		--@fn: undefined | selectNodeModifier | Le pasamos un objeto y un tipo de modificador recorre los modificadores y deja seleccionado el primero del type que buscamos.
		------------------------------------------------		
		fn selectNodeModifier node type =
		(
			_modifierToSelect = this.getNodeModifier node type 

 			modPanel.setCurrentObject _modifierToSelect
		),

		------------------------------------------------
		--@fn: undefined | selectNodeModifierByName | Se le pasa un nombre y tiene que seleccionar el primer modificador que tenga ese nombre.
		------------------------------------------------
		fn selectNodeModifierByName node modname =
		(
			_modifierToSelectByName = this.getNodeModifierByName node modname

			modPanel.setCurrentObject _modifierToSelectByName
		),

		------------------------------------------------
		--@fn: undefined | setBackFaceCull | Activa o desactiva el BackfaceCull de todos los objetos de la escena.
		--@gets: boolean | state | Estado activado o desactivado al que poner el BackFaceCull.
		------------------------------------------------
		fn setBackFaceCull state =
		(

			for _obj in objects do (
			if state == true then 
					(			
						_obj.backfacecull = true
					)
					else
					(
						_obj.backfacecull = false
					)--if else
				)--for
		),
		------------------------------------------------
		--@fn: undefined | setTurbosmoothsState | Activa o desactiva el turbosmooth de todos los objetos de la escena o de la selección.
		--@gets: boolean | state | Estado activado o desactivado al que poner los turbosmooths.
		------------------------------------------------
		fn setTurbosmoothsState state =
		(	
			-- Obtiene los objetos seleccionados y si no hay seleccion obtiene los de la escena.
			_objsToUse = getCurrentSelection()
			if _objsToUse.count == 0 then _objsToUse = (objects as array)

			-- Recorre todos los modificadores Turbosmooths de los objetos y les aplica el nuevo estado.
			for obj in _objsToUse do
				for m in obj.modifiers where classOf m == TurboSmooth or classOf m == meshSmooth do 
				(	
					if state then 
					(			
						m.enabledInViews = true
						m.enabledInRenders = true
						m.enabled = true
					)
					else
					(
						m.enabledInViews = false
						m.enabled = true 
					)--if else
				)--for
		),

		----------------------------------------------------------------------------------------------
		-- Comprueba que los turbosmooth de los objetos OBJs están apagados
		----------------------------------------------------------------------------------------------
		fn isTurbosmoothDisabled obj =
		(
			tsDisabled = true
			
			for m in obj.modifiers do
				if (classof m == turbosmooth or classof m == meshsmooth) and m.enabledinviews and m.enabled then
					tsDisabled = false
				
			tsDisabled
		),

		----------------------------------------------------------------------------------------------
		-- 	Actualiza el estado de los turbosmooth y meshsmooth del objeto OBJ según lo
		--	indicado en STATE, que puede valer #enabled, #disabled, #enabledInViews, 
		--	#disabledInViews, #enabledInRenders o #disabledInRenders
		----------------------------------------------------------------------------------------------
		fn setTurbosmoothState obj state =
		(
			for m in obj.modifiers do
				if (classof m == turbosmooth or classof m == meshsmooth) then 
					this.setModifierState m state
		),


		----------------------------------------------------------------------------------------------
		-- 	Realiza todo el proceso de comprobación y actualización del estado de los 
		--	turbosmooth de las piezas para dejarlos desactivados en viewport. Si no se
		--	desactivan todos devuelve False, si no True
		----------------------------------------------------------------------------------------------
		fn checkTurbosmooth =
		(
			tsOK = true
			for o in selection do
				if not isTurbosmoothDisabled o then tsOK = false
					
			if not tsOK then
				if queryBox "Turbosmooth must be disabled for this operation. Automatically disable turbosmooth?" then
				(
					for o in selection do setTurbosmoothState o #disabledInViews
					tsOk = true
					completeRedraw()
				)
						
			tsOk
		),

		------------------------------------------------
		--@fn: undefined | setMorpherState | Activa o desactiva el modificador morpher de todos los objetos de la escena o de la selección.
		--@gets: boolean | state | Estado activado o desactivado al que poner los morphers.
		------------------------------------------------
		fn setMorpherState state =
		(	
			-- Obtiene los objetos seleccionados y si no hay seleccion obtiene los de la escena.
			_objsToUse = getCurrentSelection()
			if _objsToUse.count == 0 then _objsToUse = (objects as array)
			-- Recorre todos los modificadores Morphers de los objetos y les aplica el nuevo estado.
			for obj in _objsToUse do 
				for m in obj.modifiers where classOf m == Morpher do m.enabled = state 
		),	

		------------------------------------------------
		--@fn: undefined | autoreloadMorphTargets | Activa o desactiva el autoreload del morpher.
		--@gets: boolean | state | Estado activado o desactivado al que poner el autoreload del morpher.
		--@note: Para que se refresce el panel de modificadores necesitas ejecutar: suspendediting(), resumeediting().
		------------------------------------------------
		fn setAutoreloadMorphTargets state =
		(
			-- Obtiene los objetos seleccionados y si no hay seleccion obtiene los de la escena.
			_objsToUse = getCurrentSelection()
			if _objsToUse.count == 0 then _objsToUse = (objects as array)
			
			-- Tip para pasar un boolean a integer
			if state then state = 1 else state = 0

			-- Recorre todos los modificadores Morphers de los objetos y les activa o desactiva el autoreload.
			for obj in _objsToUse do
				for m in obj.modifiers where classOf m == Morpher do m.Autoload_of_targets = state
		),

		----------------------------------------------------------------------------------------------
		--	Deja el modificador M en el estado de funcionamiento STATE pasado por parámetro,
		--	que puede valer #enabled, #disabled, #enabledInViews, #disabledInViews, 
		--	#enabledInRenders o #disabledInRenders
		----------------------------------------------------------------------------------------------
		fn setModifierState m state =
		(
			if not lb.nc.hasFlag m lb.nc.NC_keepConnectedModifierFlag then --si es un modificador que lleva el flag de mantener conectado no hay que tocarlo
				case state of
				(
					#enabled: (m.enabled = true; m.enabledInViews = true)
					#disabled: m.enabled = false
					#enabledInViews: (m.enabled = true; m.enabledInViews = true)
					#disabledInViews: (m.enabled = true; m.enabledInViews = false)
					#enabledInRenders: (m.enabled = true; m.enabledInRenders = true)
					#disabledInRenders: (m.enabled = true; m.enabledInRenders = false)
				)
		),

		----------------------------------------------------------------------------------------------
		-- pregunta si hay modificadores duplicados del objeto pasado por parametro
		--OBJ: objeto al que preguntar si tiene los modificadores duplicados
		--FORCEDELETE: array de clases de modificadores a eliminar (OPCIONAL)
		--FORCEKEEP: array de clases de modificadores que no se deben eliminar (OPCIONAL)
		--los dos parametros tienen que ser ARRAYS DE CLASSOF DE MODIFICADORES
		--si no se le pasa un array de FORCEDELETE elimina todos los duplicados que no esten en FORCEKEEP
		--si no se le pasa FORCEKEEP, se eliminan solo los que estan en FORCEDELETE
		--si no se le pasa ninguna de las dos, elimina cualquier duplicado
		----------------------------------------------------------------------------------------------
		fn hasDuplicatedModifiers obj forceDelete:#() forceKeep:#() =
		(
			_hasDuplicated = false
			
			_classFound = #() --a medida que recorremos los modificadores, almacena el classof de cada modificador encontrado
			_indexToDelete = #() --indice de los modificadores a eliminar
				
			--recorre los modificadores buscando los que eliminar
			for i=1 to obj.modifiers.count where not _hasDuplicated do
			(
				if not appendIfUnique _classFound (classof obj.modifiers[i]) then --si no puede añadir el classof al array es porque esta duplicado
				(
					if forceDelete.count != 0 then --en caso de que haya un array de clases de modificadores que sean los que haya de eliminar
					(
						if (findItem forceDelete (classof obj.modifiers[i])) != 0 then --si esta en los que eliminar
						(
							if forceKeep.count != 0 then --si hay modificadores que conservar
							(
								--si no esta en el array de los que conservar se guarda el indice para eliminarlo luego
								if (findItem forceKeep (classof obj.modifiers[i])) == 0 then _hasDuplicated = true
							)
							else
								_hasDuplicated = true --se almacena el indice para eliminar
						)
					)						
					else
					(
						if forceKeep.count != 0 then --si hay modificadores que conservar
						(
							--si no esta en el array de los que conservar se guarda el indice para eliminarlo luego
							if (findItem forceKeep (classof obj.modifiers[i])) == 0 then 
							(
								if (filterString obj.modifiers[i].name ":")[2] != undefined and (filterString obj.modifiers[i].name ":")[2] == "k" then
								(
									_hasDuplicated = false --se almacena el indice para eliminar
								)
								else
								(
									_hasDuplicated = true --se almacena el indice para eliminar
								)
							)
						)
						else
						(
							if (filterString obj.modifiers[i].name ":")[2] != undefined and (filterString obj.modifiers[i].name ":")[2] == "k" then
							(
								_hasDuplicated = false --se almacena el indice para eliminar
							)
							else
							(
								_hasDuplicated = true --se almacena el indice para eliminar
							)
						)
					)--if
				)--if
			)--for obj.modifiers
			
			_hasDuplicated
		),

		----------------------------------------------------------------------------------------------
		--Devuelve los indices de los modificadores duplicados del objeto pasado por parametro
		--OBJ: objeto al que eliminar los modificadores duplicados
		--FORCEDELETE: array de clases de modificadores a eliminar (OPCIONAL)
		--FORCEKEEP: array de clases de modificadores que no se deben eliminar (OPCIONAL)
		--los dos parametros tienen que ser ARRAYS DE CLASSOF DE MODIFICADORES
		--si no se le pasa un array de FORCEDELETE elimina todos los duplicados que no esten en FORCEKEEP
		--si no se le pasa FORCEKEEP, se eliminan solo los que estan en FORCEDELETE
		--si no se le pasa ninguna de las dos, elimina cualquier duplicado
		--devuelve un array vacio
		----------------------------------------------------------------------------------------------
		fn getDuplicatedModifiersIndex obj forceDelete:#() forceKeep:#() =
		(
			_success = true
			
			_classFound = #() --a medida que recorremos los modificadores, almacena el classof de cada modificador encontrado
			_indexToDelete = #() --indice de los modificadores a eliminar
				
			--recorre los modificadores buscando los que eliminar
			for i=1 to obj.modifiers.count do
			(
				if not appendIfUnique _classFound (classof obj.modifiers[i]) then --si no puede añadir el classof al array es porque esta duplicado
				(
					if forceDelete.count != 0 then --en caso de que haya un array de clases de modificadores que sean los que haya de eliminar
					(
						if (findItem forceDelete (classof obj.modifiers[i])) != 0 then --si esta en los que eliminar
						(
							if forceKeep.count != 0 then --si hay modificadores que conservar
							(
								--si no esta en el array de los que conservar se guarda el indice para eliminarlo luego
								if (findItem forceKeep (classof obj.modifiers[i])) == 0 then append _indexToDelete i
							)
							else
								append _indexToDelete i --se almacena el indice para eliminar
						)
					)						
					else
					(
						if forceKeep.count != 0 then --si hay modificadores que conservar
						(
							--si no esta en el array de los que conservar se guarda el indice para eliminarlo luego
							if (findItem forceKeep (classof obj.modifiers[i])) == 0 then append _indexToDelete i
						)
						else
							append _indexToDelete i --se almacena el indice para eliminar
					)--if
				)--if
			)--for obj.modifiers
			
			_indexToDelete
		),

		----------------------------------------------------------------------------------------------
		-- Elimina los modificadores duplicados del objeto pasado por parametro
		--OBJ: objeto al que eliminar los modificadores duplicados
		--FORCEDELETE: array de clases de modificadores a eliminar (OPCIONAL)
		--FORCEKEEP: array de clases de modificadores que no se deben eliminar (OPCIONAL)
		--los dos parametros tienen que ser ARRAYS DE CLASSOF DE MODIFICADORES
		--si no se le pasa un array de FORCEDELETE elimina todos los duplicados que no esten en FORCEKEEP
		--si no se le pasa FORCEKEEP, se eliminan solo los que estan en FORCEDELETE
		--si no se le pasa ninguna de las dos, elimina cualquier duplicado
		----------------------------------------------------------------------------------------------
		fn deleteDuplicatedModifiers obj forceDelete:#() forceKeep:#() =
		(
			_success = true
			
			_classFound = #() --a medida que recorremos los modificadores, almacena el classof de cada modificador encontrado
			_indexToDelete = #() --indice de los modificadores a eliminar
				
			--recorre los modificadores buscando los que eliminar
			for i=1 to obj.modifiers.count do
			(
				if not appendIfUnique _classFound (classof obj.modifiers[i]) then --si no puede añadir el classof al array es porque esta duplicado
				(
					if forceDelete.count != 0 then --en caso de que haya un array de clases de modificadores que sean los que haya de eliminar
					(
						if (findItem forceDelete (classof obj.modifiers[i])) != 0 then --si esta en los que eliminar
						(
							if forceKeep.count != 0 then --si hay modificadores que conservar
							(
								--si no esta en el array de los que conservar se guarda el indice para eliminarlo luego
								if (findItem forceKeep (classof obj.modifiers[i])) == 0 then append _indexToDelete i
							)
							else
								append _indexToDelete i --se almacena el indice para eliminar
						)
					)						
					else
					(
						if forceKeep.count != 0 then --si hay modificadores que conservar
						(
							--si no esta en el array de los que conservar se guarda el indice para eliminarlo luego
							if (findItem forceKeep (classof obj.modifiers[i])) == 0 then append _indexToDelete i
						)
						else
							append _indexToDelete i --se almacena el indice para eliminar
					)--if
				)--if
			)--for obj.modifiers

			if _indexToDelete.count != 0 then --si hay modificadores que eliminar
			(
				--recorre los modificadores hacia atrás eliminando los duplicados
				for i=_indexToDelete.count to 1 by -1 do
					deleteModifier obj _indexToDelete[i]
			)	
			
			_success
		),
		
		fn insertModifier targetNode mod before:0 =
		(
			--disableSceneRedraw()
			_wsmModifiers = #()

			if superclassof mod != SpacewarpModifier then
			(
				for _mod in targetNode.modifiers do
				(	
					--Guardamos los WSM en un array
					if superClassof _mod == SpacewarpModifier then
					(
						append _wsmModifiers _mod
					)
				)

				--Si hay WSM los quitaremos antes de agregar
				if _wsmModifiers.count > 0 then
				(
					--Si hay wsm siempre los pondremos por debajo, para eso lo pondremos a uno antes de cargar los wsm por encima
					if before <= _wsmModifiers.count then
					(
						before = 0
					)
					else
					(
						before -= (_wsmModifiers.count)
					)
					
					--Quitamos los modificadores WSM
					for i=1 to _wsmModifiers.count do
					(
						deleteModifier targetNode _wsmModifiers[i]
					)

					--Insertamos el modificador donde toque
					addModifier targetNode mod before:before

					--Volvemos a restaurar los modificadores de WSM
					for i=_wsmModifiers.count to 1 by -1 do
					(
						addModifier targetNode _wsmModifiers[i]
					)
				)
				--Si no hay WSM usamos el de max
				else
				(
					addModifier targetNode mod before:before
				)
			)
			else
			(
				addModifier targetNode mod before:before
			)
			resumeEditing()
			enablesceneredraw()
		),

		------------------------------------------------
		--OTHER
		------------------------------------------------
		
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
		
	)--lib_modifiers
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_modifiers() --crea la libreria
)