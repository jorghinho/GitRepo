------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fixFacial_V01
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
		--@fn: undefined | fixRigV01 | Ejecuta el script.
		------------------------------------------------	
		fn fix =
		(
			-- Hueso de cabeza.
			_tongueShapes = (lb.rig.getAnimNode "tongue*-shp" type:lb.nc.NC_classFacial)
			
			_exprPartInit = "if base != undefined then "
			_exprPartEnd = " else 0"

			for o in _tongueShapes do
			(
				-- X Scale
				_floatScript = o.scale.controller[2].x_scale.controller[#Float_script].controller
				_floatScriptExpression = _floatScript.GetExpression()
				
				
				_floatScript.setExpression ("base = (lb.rig.getAnimNode lb.nc.NC_ANIM_base)[1]\n" + "\n" + "if base != undefined then ((scale.value + base.scale.x) - 2) else 0")

				-- Y Scale
				_floatScript = o.scale.controller[2].y_scale.controller[#Float_script].controller
				_floatScriptExpression = _floatScript.GetExpression()
				
				
				_floatScript.setExpression ("base = (lb.rig.getAnimNode lb.nc.NC_ANIM_base)[1]\n" + "\n" + "if base != undefined then ((scale.value + base.scale.y) - 2) else 0")
				
				-- Z Scale
				_floatScript = o.scale.controller[2].z_scale.controller[#Float_script].controller
				_floatScriptExpression = _floatScript.GetExpression()
				
				
				_floatScript.setExpression ("base = (lb.rig.getAnimNode lb.nc.NC_ANIM_base)[1]\n" + "\n" + "if base != undefined then ((scale.value + base.scale.z) - 2) else 0")
			)
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
			this.fix()
			
			--ejecución del script
			messageBox "Fix Rig V01 executed"
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
		
	)--sc_templateScript
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_fixFacial_V01() --crea el script
)