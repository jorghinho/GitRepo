------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script replaceAnimationCharsWithLayoutChars.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script replaceAnimationCharsWithLayoutChars.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_replaceAnimationCharsWithLayoutChars
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Replace Animation Chars With Layout Chars",	--@var: description | Descripcion del script.
		
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
			for asset in lb.asset.getSceneAssets() where asset.type == "chr" do 
			(
				layout_folder = asset.folder + "\\version\\"
				layout_files = getFiles (layout_folder+"*layout*.max")
				sort layout_files
				file_to_load = layout_files[layout_files.count]
				lb.asset.loadAsset file_to_load #merge
				
				-- Copiar posición y rotación de cada nodo de tipo rig del personaje
				for source_node in asset.rigNodesAll do
				(
					parts = filterstring source_node.name "_" -- Ej: chr_tadeo_rig_r_footStep_x_c  -->  #("chr", "tadeo", "rig", "r", "footStep", "x", "c")
					target_node_name = parts[1] + "_" + parts[2] + ":layout"
					for i=3 to parts.count do target_node_name += "_" + parts[i]
					target_node = getnodebyname target_node_name
					if target_node != undefined do 
					(		
						try target_node.rotation.controller[2].controller = copy source_node.rotation.controller[2] catch ()
						try target_node.position.controller[2].controller = copy source_node.position.controller[2] catch ()
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
		
	)--sc_replaceAnimationCharsWithLayoutChars
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_replaceAnimationCharsWithLayoutChars() --crea el script
)