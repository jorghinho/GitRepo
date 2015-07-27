------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script xrefMaterialsCorrectName.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script xrefMaterialsCorrectName.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_xrefMaterialsCorrectName
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "xref Material Correct Name",	--@var: description | Descripcion del script.
		
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
		--@fn: undefined | changeName | Ejecuta el script.
		------------------------------------------------
		fn changeName =
		(
			sel = getCurrentSelection() --selecciono los objetos que son unos copias de otros	
			if sel.count != 0 then --solo entra si hay algo seleccinado
			(
				sel.ishidden = false --los desoculto por si no lo estuvieran ya
					
				--cogemos el nombre del objeto
				auxName = if classof sel[1] == XrefObject then sel[1].objectName else sel[1].name
				
				if lb.nc.ncOK auxName then --si elnombre cumple el NC
				(
					--montamos el nombre del material	
					auxNameParts = filterString auxName "_"
					defMatName = auxNameParts[1] + "_" + auxNameParts[2] + "_" + auxNameParts[5]
					
					--cambiamos el nombre al material
					firstMat = sel[1].mat
					firstMat.name = defMatName
					
					--sustituimos el material de todos los objetos con el material del primer objeto ya renombrado.
					for obj in sel do obj.mat = firstMat
				)
				else
					messageBox "Hay algun objeto que no cumple el naming convention."		
			)--if sel.count	
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
			this.changeName()
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
	)--sc_xrefMaterialsCorrectName
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_xrefMaterialsCorrectName() --crea el script
)