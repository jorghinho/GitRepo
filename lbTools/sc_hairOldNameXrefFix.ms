------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script xrefMaterialsCorrectName.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script xrefMaterialsCorrectName.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_hairOldNameXrefFix
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Fixing old XRef hair name",	--@var: description | Descripcion del script.
		
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
		--@fn: undefined | fixNodeInfo | Corrije el nodeInfo para que cargue el pelo mojado.
		------------------------------------------------
		fn fixNodeInfo =
		(
			_badHairNodes = (lb.misc.getNodesByPattern "*_mesh_?_headHair-draft_*_*")
			_log = ""
			_nodeCount = 0
			for _node in _badHairNodes where _node.unresolved do
			(
				_node.srcItemName = substituteString _node.srcItemName "headHair-draft" "draft-head-hair-all"
				_log += _node.name + "\n"
				_nodeCount += 1
			)
			_log = "Fix applied to " + (_nodeCount As String) + " nodes:\n\n" + _log
			lb.message.show _log type:#message modal:true
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
			this.fixNodeInfo()
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
	)--sc_hairOldNameXrefFix
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_hairOldNameXrefFix() --crea el script
)