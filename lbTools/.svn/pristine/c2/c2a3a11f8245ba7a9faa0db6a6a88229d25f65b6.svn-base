------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script next Camera.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: nextCamera | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_nextCamera
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "View Next Camera",	--@var: description | Descripcion del script.
		
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
			-- Guardar todas las cámaras en un array y ordenarlas. Evitar guardar los targets de cámara
			all_cams = sort(for cam in cameras where (findString cam.name ".Target") == undefined collect cam.name)
			n_cams = all_cams.count

			-- Ejecutar el script sólo si hay más de una cámara
			if n_cams > 1 then
			(
				-- Recorrer todos los viewports buscando el que tenga una cámara activa
				for i=1 to viewport.numViews where (current_cam = viewport.getCamera index:i) != undefined do
				(
					-- Recorrer todas las cámaras buscando la que se llame como la cámara del viewport
					for j=1 to n_cams do 
					(
						if all_cams[j] == current_cam.name do 
						(
							-- Si no estamos en la última cámara de la lista saltamos a la siguiente, si no, vamos a la primera
							if (j < all_cams.count) then 
							(
								new_cam_name = all_cams[j+1]
							) 
							else 
							(
								new_cam_name = all_cams[1]
							)
							
							disableSceneRedraw()
							
							-- Asignar al viewport la nueva cámara
							new_cam = getnodebyname new_cam_name
							viewport.activeViewport = i
							viewport.setCamera new_cam
								
							-- Poner el rango de tiempo de la nueva cámara
							animationRange = interval new_cam.recStart new_cam.recEnd
							sliderTime = new_cam.recStart
							
							enableSceneRedraw()
							completeRedraw()
						) -- if all_cams[j] == current_cam.name do 
					) -- for j=1 to n_cams do 
				) -- for i=1 to viewport.numViews do
			)  else  -- if n_cams > 1 do
			(
				-- Poner el rango de tiempo de la única cámara
				animationRange = interval cameras[1].recStart cameras[1].recEnd
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
	
	sc_nextCamera() --crea el script
)