------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script xrefMaterialsCorrectName.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script xrefMaterialsCorrectName.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_wetHairFix
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Adding wet hair fix, replace in nodeInfo",	--@var: description | Descripcion del script.
		
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
			if matchPattern maxFileName pattern:"seq_020b-igor(bea)_*" then
			(

				_draftHairNodes = #()
				_log = ""
				_nodeCount = 0
				_validChars = #("chr_amy","chr_mike","chr_marty","chr_blondie","chr_ray","chr_surfBoy")
				for _validChar in _validChars do
				(
					_foundHairNode = lb.misc.getNodeByPattern (_validChar + "*_mesh_?_draft-head-hair-*_*_*")
					if _foundHairNode != undefined then
						append _draftHairNodes _foundHairNode
				)

				for _node in _draftHairNodes where lb.nodeInfo.hasNodeInfo _node do
				(
					--print ("Nodo: " + _node.name)
					--Accedemos al nodeInfo
					_exit = false
					for i=1 to _node.nodeInfo.fileHistory.count where not _exit do
					(
						--print _node.nodeInfo.fileHistory[i]
						if matchPattern (getFilenameFile _node.nodeInfo.fileHistory[i]) pattern: ("*_*(headHair-std)_" + lb.nc.NC_draftFileName + "_v??") then
						(
							_node.nodeInfo.fileHistory[i] = substituteString _node.nodeInfo.fileHistory[i] "(headHair-std)" "(headHair-wet)"
							
							--------------------------------------------------------------------
							--------------------------------------------------------------------
							_node.nodeInfo.fileHistory[i] = substituteString _node.nodeInfo.fileHistory[i] "v02" "v01" --esto no deberia ser necesario pero es porque no hay version 2 de pelo mojado en amy. 
							--------------------------------------------------------------------
							--------------------------------------------------------------------
							
							_log += _node.name + "\n"
							_nodeCount += 1
							_exit = true
						)
					)
				)
				_log = "Fix applied to " + (_nodeCount As String) + " nodes:\n\n" + _log
				lb.message.show _log type:#message modal:true
			)
			else
			(
				lb.message.show ("Fix específico para seq_020b-igor(bea). No se puede aplicar a " + (getFilenameFile maxfilename))
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
	)--sc_wetHairFix
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_wetHairFix() --crea el script
)