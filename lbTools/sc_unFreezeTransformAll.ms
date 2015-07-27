------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script unFreezeTransformAll.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: unFreezeTransformAll | Contiene el struct del script unFreezeTransformAll.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_unFreezeTransformAll
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Un Freeze Transform All",	--@var: description | Descripcion del script.
		
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
			suspendEditing()
			undo "UnFreeze all transforms" on
			(
				--Comprobamos que no haya objetos con attachObjectToFace.
				_attachProObjects = #()
				
				--Recorro toda la seleccion apilando en un array todos los objetos que tengamos con attachObjectToFace
				for o in selection do
				(
					_attachProControllers = #()
					_attachProControllers = lb.attachObjectToFaceFunctions.getAttachProControllers o
					if _attachProControllers[1] != undefined and _attachProControllers[2] != undefined and _attachProControllers[3] != undefined then
					(
						append _attachProObjects o
					)
				)
				
				--Creo un flag para almacenar si vamos a preservar los attachObjectToFace.
				_preserveAttachs = false
				
				--Si hay objetos de attach object to face  miraremos si hay un solo tick (de posicion o rotación) marcado para preguntar, si estan los dos guardaremos sin preguntar 
				--y si no hay ninguno haremos override sin preguntar tampoco
				if _attachProObjects.count > 0 then
				(	
					_preserveAttachs = lb.message.show "There are some nodes with attach object to face controllers. To preserve them, keep position is needed. Do you want to activate them for these objects?" type:#query pos:undefined size:[300,75] modal:true
				)
				
				--Si hemos decidido preservar, para todos los objetos que tengan attachObjectToFace tendremos que forzar el keep de posicion y de rotacion.
				for o in selection do 
				(
					if _preserveAttachs and finditem _attachProObjects o != 0 then
					(
						lb.controller.unFreezeTransform o #all keepPos:true keepRot:true 
					)
					else
					(
						lb.controller.unFreezeTransform o #all keepPos:false keepRot:false keepSca:false
					)
				)
			)
			
			if rollchannelbox != undefined and rollchannelbox.open then rollchannelbox.resetlistview()
			
			resumeEditing()
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
		
	)--sc_unFreezeTransformAll
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_unFreezeTransformAll() --crea el script
)