------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script removeCameraNoise.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: removeCameraNoise | Contiene el struct del script removeCameraNoise.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_removeCameraNoise
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Remove camera noise",	--@var: description | Descripcion del script.
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(
			-- Obtener el tipo de controlador actual. Si la cámara tiene noise su controlador será de tipo "Rotation_List"
			controller_type = (filterstring ($.rotation.controller as string) ":")[2]
			if controller_type == "Rotation_List" do 
			(
				-- Recorrer todos los controladores subanim buscando el Euler_XYZ que tiene la animación de rotación de cámara
				for i=1 to $.rotation.controller.count do 
				(
					subanim_controller = $.rotation.controller[i]
					subanim_type = (filterstring (subanim_controller as string) ":")[2]
					if subanim_type == "Euler_XYZ" do 
					(
						-- Crear un dummy temporal y copiarle las keys de rotación
						temp_dummy = Dummy()
						temp_dummy.rotation.controller = copy subanim_controller
						
						-- Devolverle la animación antigua que ahora tiene el dummy temporal y borrar este último
						$.rotation.controller = copy temp_dummy.rotation.controller
						delete temp_dummy
					)
				)
			)
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
		
	)--sc_removeCameraNoise
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_removeCameraNoise() --crea el script
)