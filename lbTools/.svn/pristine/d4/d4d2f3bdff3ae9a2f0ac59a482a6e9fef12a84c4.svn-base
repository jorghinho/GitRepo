------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: fxSceneScale | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fxSceneScale
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Script plantilla",	--@var: description | Descripcion del script.
		
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
			--ejecución del script
			--Buscamos la capa donde suele estar el dummy
			dummyRescaleLayer = LayerManager.getLayerFromName "_aux-fx_"
			if dummyRescaleLayer == undefined then
				dummyRescaleLayer = LayerManager.newLayerFromName "_aux-fx_"
			
			--Miramos si está creado (sino se crea)
			dummyRescale = $'fxRescaleDummy'
			if(dummyRescale == undefined) then
			(
				dummyRescale = Dummy()
				dummyRescale.name = uniquename "fxRescaleDummy"
				dummyRescale.boxsize = [15000,15000,15000]
				dummyRescale.pos = [0,0,0]
				dummyScale= [0.05,0.05,0.05]
			)
			else
			(
				--Si existe le ponemos escala a 1, y desemparentamos a todos sus hijos (haciendo backup de su escala anterior)
				dummyScale= dummyRescale.scale
				dummyRescale.scale = [1,1,1]
				for o in objects where (o.parent == dummyRescale) and (o != dummyRescale) do
					o.parent = undefined
			)
			dummyRescaleLayer.addNode dummyRescale



			if selection.count==0 then
			(
				print "no hay seleccion"
				for o in objects where (o.parent == undefined) and (o != dummyRescale) do 
					o.parent = dummyRescale
			)
			else
			(
				print "SELECCIONADOS"
				for o in selection where (o.parent == undefined) and (o != dummyRescale) do 
					o.parent = dummyRescale
			)



			dummyRescale.scale = dummyScale
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
		
	)--sc_fxSceneScale
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_fxSceneScale() --crea el script
)