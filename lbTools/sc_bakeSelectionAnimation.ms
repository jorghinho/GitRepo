------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script bakeSelectionAnimation.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: sc_bakeSelectionAnimation | Contiene el struct del script bakeSelectionAnimation.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_bakeSelectionAnimation
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),														--@var: string |def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),											--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,															--@var: name | category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),		--@var: string |className | Nombre del script.
		description = "Script plantilla",											--@var: string |description | Descripcion del script.
		
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
			_objects = getCurrentSelection()
			(
				for _obj in _objects do 
				(
					select _obj 

					_currSel = getCurrentSelection()
			
					lb.bakeAnimToPoint.run()

					_points = getCurrentSelection()

					select _currSel
					
					if _currSel.count != 0 then
					(
						for _obj in _currSel do
						(
							_pcFrame = #()
							_transformValues = for i=animationRange.start to animationRange.end collect (at time i (in coordsys world (_obj.transform)))

							--si tiene PC lo quitamos
							if lb.links.pointConstraint.hasPCAttribute _obj then
							(
								_pdata = lb.links.pointConstraint.getPointData _obj

								if _pdata.pointLinks.count != 0 then
								(
									while _pdata.pointLinks.count != 0 do lb.links.pointConstraint.deleteTarget _obj 1
								)
							)
								
							with animate on
							(
								_cont = 1
								for i=animationRange.start to animationRange.end do
								(
									at time i (in coordsys world (_obj.transform = _transformValues[_cont]))
									_cont += 1
								)
							)
							_baseObj = virtualWorld
							
							if lb.links.pointConstraint.hasPCAttribute _obj then
							(
								lb.links.pointConstraint.addTarget _obj _baseObj frameNo:0
							)	
						)
					)
					else
					(
						lb.message.show "Shit!!! you must select at least one object stupid. OMG!! WTF!!!"
					)

					for i = _points.count to 1 by -1 where matchpattern _points[i].name pattern:"*_baked" do delete _points[i]
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
		
	)--sc_bakeSelectionAnimation
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_bakeSelectionAnimation() --crea el script
)