------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script quickSetLens.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: quickSetLens | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_quickSetLens
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Set camera prime lens",	--@var: description | Descripcion del script.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		rollName = "rollSetLens",
		lenses = #(10,14,17,21,24,27,35,40,50,65,85,100,150,200,300,500,1000),
		button_width = 20,
		gap = 2,

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

		fn fov2mm fov =
		(
			0.5*(GetRendApertureWidth()/tan(fov/2.0)) as integer
		),
		
		fn mm2fov mm =
		(
			2.0*atan(GetRendApertureWidth()/mm*0.5)
		),

		fn createRollout =
		(
			rollwidth = lenses.count*(button_width+gap)+10
			current_lens = if superclassof $ == camera then (floor((fov2mm $.fov)+0.5)) else viewport.getFOV()
			str = "rollout "+rollName+" \"Camera prime lenses\" width:"+rollwidth as string+" height:30 (\n"
			for i=1 to lenses.count do
			(
				t = lenses[i] as string
				fov = mm2fov lenses[i]
				button_x_pos = (i-1)*(button_width+gap)+5
				action_str = "(if superclassof $==camera then ($.fov="+fov as string+") else (if viewport.getType index:viewport.activeViewport==#view_persp_user do viewport.setFOV "+fov as string+")\nforceCompleteRedraw()\ndestroyDialog "+rollName+")"
				str += "button b"+t+" \""+t+"\" pos:["+button_x_pos as string+",5] width:20 height:20 "+(if current_lens == lenses[i] then "enabled:false\n" else "\n")
				str += "on b"+t+" pressed do "+action_str+"\n"
			)
			str += ")"
			execute str
			
			-- Posicionar rollout y abrirlo
			p = findItem lenses current_lens
			pos = mouse.screenpos
			if p != 0 then
			(
				ui_x_pos = int(pos[1]-(p*(button_width+gap)))
			) else
			(
				ui_x_pos = int(pos[1]-rollwidth/2)
			)
			execute ("createDialog "+rollName+" pos:["+ui_x_pos as string+", "+pos[2] as string+"-40]")
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(
			createRollout()
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
	)--sc_quickSetLens
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_quickSetLens() --crea el script
)