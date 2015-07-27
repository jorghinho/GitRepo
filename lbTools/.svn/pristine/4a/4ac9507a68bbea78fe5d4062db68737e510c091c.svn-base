------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: fixRestorePointPropertiesFromFakeBones | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_fixRestorePointPropertiesFromFakeBones
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
			_currSel = getCurrentSelection()

			if _currSel.count != 0 then
			(
				_fakeBoneNodes = for _node in _currSel where classof _node.baseObject == BoneGeometry collect _node
				
				if _fakeBoneNodes.count != 0 then
				(
					_process = lb.message.show "This operation will transform all the selected fake bones in points. Do you want to continue?" type:#query

					if _process then
					(
						_tmpPoint = Point size:5 box:on cross:off axistripod:off centermarker:off
						_pointBaseObject = copy _tmpPoint[4]
						delete _tmpPoint
						
						for _fb in _fakeBoneNodes do setProperty _fb "baseObject" _pointBaseObject
					)--if else
				)
				else
				(
					lb.message.show "There are no fake bones in your selection"
				)--if else
			)
			else
			(
				lb.message.show "You must select at least one fake bone object"
			)--if else
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
		
	)--sc_fixRestorePointPropertiesFromFakeBones
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_fixRestorePointPropertiesFromFakeBones() --crea el script
)