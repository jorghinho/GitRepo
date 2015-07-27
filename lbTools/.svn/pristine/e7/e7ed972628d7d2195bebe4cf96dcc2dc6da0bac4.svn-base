------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Script para buscar en escena copias de un objeto seleccionado. 
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: sc_selectCopiedElements | Contiene el struct del script sc_selectCopiedElements.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_selectCopiedElements
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: name | category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: string | className | Nombre del script.
		description = "Script selectCopiedElements",	--@var: string | description | Descripcion del script.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		
		fn selectAllConcurrentObjects = 
		(
			--Nos saltaremos el primer objeto, ya que este script esta destinado a usarse con la tool CopyAlignScript 
			_selection = getCurrentSelection()
			if _selection.count > 1 then 
			(
				for _obj in objects do 
				(
					for i = 2 to _selection.count do 
					(
						_patternName = ""
						_patternNameParts = FilterString _selection[i].name "_"
						_patternNameParts[2] = (FilterString _patternNameParts[2] "#")[1] + "*"
						_patternNameParts[5] = (FilterString _patternNameParts[5] "-")[1] + "-*"
						_patternName += _patternNameParts[1]
						for j = 2 to _patternNameParts.count do 
						(
							_patternName += "_" + _patternNameParts[j]
						)
						if matchpattern _obj.name pattern: _patternName do 
						(
							appendIfUnique _selection _obj
						)
					)
				)
				select _selection
			)
			else lb.message.show "Select at least 2 objects to operate this script."
		),

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
			selectAllConcurrentObjects()
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
		
	)--sc_selectCopiedElements
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_selectCopiedElements() --crea el script
)