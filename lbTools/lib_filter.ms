------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de filter
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: filter | Contiene la libreria de filter.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_filter
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria filter",	--@var: description | Descripcion de la libreria.
		
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

		----------------------------------------------------------------------------------------------
		-- devuelve TRUE si el objeto es de tipo Bone
		----------------------------------------------------------------------------------------------
		fn boneFilter obj = 
		(
			success = false
			
			if isValidNode obj then
				success = ((classof obj.baseObject) == BoneGeometry)
				
			success
		),

		----------------------------------------------------------------------------------------------
		-- devuelve TRUE si el objeto es de tipo Point
		----------------------------------------------------------------------------------------------
		fn pointFilter obj = 
		(
			success = false
			
			if isValidNode obj then
				success = ((classof obj.baseObject) == Point)
				
			success
		),
		
		--------------------------------------------------------------------------------------
		--	devuelve TRUE si el objeto es de tipo Spline
		--------------------------------------------------------------------------------------
		fn splineFilter obj = 
		(
			success = false
			
			if isValidNode obj then
				success = (classof obj.baseObject == line) or (classof obj.baseObject == Edit_spline) or (classof obj.baseObject == SplineShape)
			
			success
		),	

		------------------------------------------------
		--COMMON
		------------------------------------------------
			
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
			lb.addLibrary this --a�ade la libreria a la principal
		)
		
	)--lib_filter
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_filter() --crea la libreria
)