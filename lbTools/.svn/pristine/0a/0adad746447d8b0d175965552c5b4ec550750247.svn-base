------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script next Camera.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: collapseCharacter | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_collapseCharacter
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Collapse Character",	--@var: description | Descripcion del script.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		objFile = (getdir #temp) + "\\temp.obj",
		
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
			-- Obtener assets seleccionados
			assets = (getAssetsFromNodes selection)

			-- Recorrer los assets
			for ast in assets do 
			(
				clearSelection()
				
				-- Seleccionar capa del asset
				ast.layer.select true
				exportFile this.objFile #noPrompt selectedOnly:true
				importFile this.objFile #noPrompt

				-- Crear capa nueva y añadir los objetos del OBJ
				l = LayerManager.newLayer()
				for obj in selection do l.addNode obj
				
				-- Ocultar layer del personaje original
				ast.layer.ishidden = true
				
				-- Tomar primer objeto contenido en el fichero OBJ y atacharle el resto de piezas
				firstMesh = selection[1]
				objs = for i=2 to selection.count collect selection[i]
				for obj in objs do meshop.attach firstMesh obj attachMat:#MatToID
				
				-- Centrar pivote
				firstMesh.pivot = firstMesh.center
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
	)--sc_nextCamera
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_collapseCharacter() --crea el script
)