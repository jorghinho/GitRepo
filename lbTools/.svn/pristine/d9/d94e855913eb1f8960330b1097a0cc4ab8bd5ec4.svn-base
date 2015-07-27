------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: neopreneAllDryMatsFix | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_neopreneAllDryMatsFix
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Pone los materiales secos en Marty, Mike y Amy para la secuencia ",	--@var: description | Descripcion del script.
		
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
			if (matchPattern maxfilename pattern: "seq_190b-sneak(lau)_cam???_*") then
			(
				_asts = lb.asset.getSceneAssets()
				_validAssets = #("chr_mike{neoprene-windsurfShoes}","chr_amy{neoprene-windsurfShoes}")
				

				for _ast in _asts where (finditem _validAssets _ast.fullname) != 0 do
				(
					_materialsProcessed = #()
					for _mesh in _ast.meshNodesAll do
					(
						--Primero miramos si tiene una variación en su custom attribute
						if lb.customAttributes.hasAttribute _mesh #matVariationInfo then
						(
							--Cambiamos todos aquellos donde pone "wet" por "dry"
							for i=1 to _mesh.matVariationInfo.subMatNames.count do
							(
								if (findString _mesh.matVariationInfo.subMatNames[i] "wet") == 1 then
								(
									_mesh.matVariationInfo.subMatNames[i] = "dry" + (substring _mesh.matVariationInfo.subMatNames[i] 4 _mesh.matVariationInfo.subMatNames[i].count) 
								)
							)
							
							if not (appendIfUnique _materialsProcessed _mesh.material) then
							(
								lb.variations.setStoredMatVariation _mesh
							) 
						)

						--Aparte hay que modificar el nodeinfo del mesh que llama al pelo para que coja el seco
						if matchPattern _mesh.name pattern: (_ast.fullname + "_mesh_?_draft-head-hair-*_*_*") then
						(
							for i=1 to _mesh.nodeInfo.fileHistory.count do
							(
								--Si por un casual apunta al pelo mojado, haremos que apunte al seco.
								if matchPattern (getFilenameFile _mesh.nodeInfo.fileHistory[i]) pattern: ("*_*(headHair-wet)_" + lb.nc.NC_draftFileName + "_v??") then
								(
									_mesh.nodeInfo.fileHistory[i] = substituteString _mesh.nodeInfo.fileHistory[i] "(headHair-wet)" "(headHair-std)"
								)
							)
						)
					)
				)
				lb.message.show ("Fix aplicado.")
			)
			else
			(
				lb.message.show ("Fix sólo aplicable a cámaras de seq_190b-sneak(lau).")
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
		
	)--sc_neopreneAllDryMatsFix
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_neopreneAllDryMatsFix() --crea el script
)