------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script fixFreezePoseCacheMeshObjects.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: fixFreezePoseCacheMeshObjects | Contiene el struct del script fixFreezePoseCacheMeshObjects.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fixFreezePoseCacheMeshObjects
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Fix Freeze Pose Cache Mesh Objects",	--@var: description | Descripcion del script.
		
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
		--@fn: undefined | fix | arregla el freezePose de objetos de escala.
		------------------------------------------------
		fn fix =
		(
			_selObjects = getCurrentSelection() --obtiene la seleccion actual y actua sobre ellas
				
			if _selObjects.count != 0 then --si hay algo seleccionado
			(
				if querybox "this process will modify objects transforms to fix the problem, do you want to continue?" then
				(
					_parentBckp = #() --array de backup de padres de los objetos
								
					for obj in _selObjects do append _parentBckp obj.parent --recolecta los padres
					_selObjects.parent = undefined --desconecta los objetos de sus padres
					
					_parentBckpUnique = makeUniqueArray (deepcopy _parentBckp) --hace el array unico para trabajar
					
					--pone la escala de los padres a 1.0
					for obj in _parentBckpUnique do
					(
						_parent = obj
						while _parent != undefined do
						(
							if lb.controller.isTransformFrozen _parent #scale then
							(						
								for i=1 to _parent.scale.controller.count do
								(
									_parent.scale.controller[i].controller.value = [1.000, 1.000, 1.000]
									if findstring _parent.name "basePoint" != undefined then _parent.position.controller[i].controller.value = [0,0,0]
								)
							)
							else
								_parent.scale = [1,1,1]
							
							_parent = _parent.parent
						)--while				
					)--for
					
					--restaura los padres y hace un freezePose
					for i=1 to _selObjects.count do
					(
						_selObjects[i].parent = _parentBckp[i]
						lb.controller.freezePose _selObjects[i] #all
					)--for
				)--if
			)--if
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(
			this.fix()
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
			lb.addScript this --añade el script a la libreria principal
		)
		
	)--sc_fixFreezePoseCacheMeshObjects
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_fixFreezePoseCacheMeshObjects() --crea el script
)