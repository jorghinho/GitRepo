------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script hideOtherCameras.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: hideOtherCameras | Contiene el struct del script hideOtherCameras.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_hideOtherCameras
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Hide Other Cameras",	--@var: description | Descripcion del script.
		
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

		fn anyCameraIsVisible =
		(
			camera_visible = false
			for c in cameras where c.isHidden == false do camera_visible = true
			return camera_visible
		),	
		
		fn anyCameraIsHidden =
		(
			camera_hidden = false
			for c in cameras where c.isHidden == true do camera_hidden = true
			return camera_hidden
		),		
		
		fn showAllCams = 
		(
			for c in cameras do c.isHidden = false
		),
				
		fn hideAllCams skip:undefined = 
		(
			cams = cameras as array
			if skip != undefined do
			(
				for i=1 to cams.count where cams[i].name == skip.name do deleteItem cams i
			)
			hide cams
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(
			selected_cam = undefined
			if selection.count > 0 then
			(
				if superclassof(selection[1]) == camera do selected_cam = selection[1]
			)
			
			case __cameras_hidden of
			(
				undefined: (
					if anyCameraIsHidden() then	(
						showAllCams()
						__cameras_hidden = false
					) else if selected_cam then (
						hideAllCams skip:selected_cam
						__cameras_hidden = true
					) else (
						hideAllCams()
						__cameras_hidden = true
					)
				)
				true: (
					showAllCams()
					__cameras_hidden = false
				)
				false: (
					hideAllCams skip:selected_cam
					__cameras_hidden = true
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
		
	)--sc_hideOtherCameras
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_hideOtherCameras() --crea el script
)