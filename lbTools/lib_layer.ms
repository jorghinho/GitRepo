------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de plantilla
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: layer | Contiene todas las funciones de capas.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_layer
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria de manejo de capas",	--@var: description | Descripcion de la libreria.
		
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
		--@fn: LayerProperties | getLayerbyIndex | Devuelve la capa que ocupa el lugar del indice solicitado.
		--@gets: integer | index | Indice de la capa que se solicita.
		------------------------------------------------
		fn getLayerbyIndex index =
		(
			_theLayer
				
			_theLayer = LayerManager.getLayer index
				
			_theLayer
		),
		
		------------------------------------------------
		--@fn: LayerProperties | getLayerbyName | Devuelve la capa que tenga el nombre solicitado.
		--@gets: string | layerName | Nombre de la capa que se solicita.
		------------------------------------------------
		fn getLayerbyName layerName =
		(
			_theLayer
				
			_theLayer = LayerManager.getLayerFromName layerName
				
			_theLayer
		),
		
		------------------------------------------------
		--@fn: array{nodes} | getLayerNodes | Devuelve los nodos de la capa pasada por parámetro en un array.
		--@gets: LayerProperties | layer | Capa de la cual obtener los nodos.
		------------------------------------------------
		fn getLayerNodes layer =
		(
			_theNodes = #()
			
			layer.nodes &_theNodes
			
			_theNodes
		),

		------------------------------------------------
		--@fn: array{string} | getLayersNames | Devuelve los nombres de las capas
		------------------------------------------------
		fn getLayersNames =
		(
			_layerNames

			_layerNames = for i=1 to LayerManager.count collect (LayerManager.getLayer (i-1)).name
				
			_layerNames
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: LayerProperties | newLayer | Crea una nueva capa. Si se le pasa un nombre le pone ese, si no, le da uno por defecto. Devuelve la capa creada
		--@opt: string | name | undefined | Nombre para la nueva capa. Si una capa con ese nombre ya existe, no la crea y devuelve la existente.
		------------------------------------------------
		fn newLayer name:undefined =
		(
			_theLayer
			
			if name != undefined then
			(
				_theLayer = LayerManager.getLayerFromName name
				if _theLayer == undefined then _theLayer = LayerManager.newLayerFromName name
			)
			else
				_theLayer = LayerManager.newLayer()
				
			_theLayer
		),

		----------------------------------------------------------------------------------------------------------------
		-- función para crear una capa nueva especificando el nombre del personaje.
		-- CHARNAME: Nombre del personaje que aparecerá en la capa.
		-- Devuelve LAYERNEW.
		----------------------------------------------------------------------------------------------------------------
		fn newAssetLayer assetName assetType:lb.nc.NC_chrPrefix =
		(
			layerNew = undefined -- variable vacía donde se almacenará la nueva capa.
			
			if classof assetName == String then
			(
				end = layerManager.count-1 -- número de capas existentes menos la capa 0.
				
				for n = 1 to end do -- bucle para buscar si existe una capa que coincida con assetName.
				(
					layer =  layerManager.getLayer n -- variable donde se almacena cada una de las capas durante el bucle.
					layerName = filterstring layer.name "_" -- filtrado de nombre de la capa actual del bucle separado por "_".
					
					if layerName[2] == assetName and layerName[1] == assetType then -- comprobación si el tipo de la capa actual coincide con assetName.
						layerNew = layer -- la capa que se intenta crear ya existe. Se almacena en layerNew.
				)-- End of for.
				
				if layerNew == undefined then -- Comprueba que la capa no existe ya en la escena.
					layerNew = LayerManager.newLayerFromName (assetType + "_" + assetName) -- Creación de la nueva capa, con el nombre correcto para el personaje y el tipo de capa.
			)
			
			layerNew
		),	

		------------------------------------------------
		--@fn: undefined | deleteLayerByName | Elimina la capa que lleva el nombre solicitado.
		--@gets: string | layerName | Nombre de la capa a eliminar.
		------------------------------------------------
		fn deleteLayerByName layerName =
		(
			LayerManager.deleteLayerByName layerName
		),
		
		------------------------------------------------
		--@fn: undefined | deleteLayerByIndex | Elimina la capa que ocupa el lugar indicado.
		--@gets: integer | index | Indice de la capa a eliminar.
		------------------------------------------------
		fn deleteLayerByIndex index =
		(
			_layer = this.getLayerbyIndex index
			if _layer != undefined then LayerManager.deleteLayerByName _layer.name
		),

		------------------------------------------------
		--@fn: undefined | deleteEmptyLayers | Elimina las capas vacías.
		------------------------------------------------
		fn deleteEmptyLayers =
		(
			_layer0 = _theLayer = LayerManager.getLayerFromName "0"
			_layer0.current = true

			for l=(LayerManager.count-1) to 1 by -1 do
			(
				_layer =  LayerManager.getLayer l
				if _layer == _layer0 do continue

				if (lb.layer.getLayerNodes _layer).count == 0 do
					LayerManager.deleteLayerByName _layer.name
			)
		),

		----------------------------------------------------------------------------------------------------------------
		-- función para dejar una capa como la capa Activa especificando el tipo de capa.
		-- TYPE: Tipo de capa, indica el contenido de la capa.
		----------------------------------------------------------------------------------------------------------------
		fn activeLayer assetName assetType:lb.nc.NC_chrPrefix =
		(
			if classof assetName == String then
			(
				end = layerManager.count-1
				
				for n = 1 to end do
				(
					layer =  layerManager.getLayer n
					layerName = filterstring layer.name "_"
					if layerName[2] == assetName and layerName[1] == assetType then	
					(
						layer.current = true
						n = end
					)
				)
			)
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
		
	)--lib_layer
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_layer() --crea la libreria	
)