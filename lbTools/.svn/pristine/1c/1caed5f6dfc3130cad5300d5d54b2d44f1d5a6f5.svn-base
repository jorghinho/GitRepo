------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de plantilla
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de shapes.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_shapes
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #shapes,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria shapes",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------
		--@fn: undefined |  shapeArrowCurveCross  |  Creación del shape Arrow/Cross, la estrella en plano con Bend.
		------------------------------------------------------------------------------------------------
		fn shapeEyeLidMorphs =
		(
			_nGon = Ngon radius:3 cornerRadius:0 nsides:8 circular:on scribe:1 pos:[0,0,0] isSelected:on()

 			convertTo _nGon SplineShape

 			for i=1 to 8 do (setknottype _nGon 1 i #smooth)

 			setknottype _nGon 1 1 #bezierCorner
			setknottype _nGon 1 5 #bezierCorner

			_nGon.name = "eyeLidsMorphShape"
			_nGon.wirecolor = green

			deselect _nGon            --deselecciona el shape.

			lb.controller.freezeTransform _nGon #all

			_nGon
		),

		------------------------------------------------------------------------------------------------
		--@fn: undefined |  shapeArrowCross |  Creación del shape Arrow/Cross, la estrella en plano.
		------------------------------------------------------------------------------------------------
		fn shapeArrowCross =
		(
			_shp = splineShape()
			select _shp
			_spln = addNewSpline _shp
			addKnot _shp _spln  #Corner #Line [-10,-10,0] 
			addKnot _shp _spln  #Corner #Line  [-30,-10,0] 
			addKnot _shp _spln  #Corner #Line  [-30,-20,0]
			addKnot _shp _spln  #Corner #Line  [-50,0,0] 
			addKnot _shp _spln  #Corner #Line [-30,20,0] 
			addKnot _shp _spln  #Corner #Line  [-30,10,0] 
			addKnot _shp _spln  #Corner #Line  [-10,10,0]
			
			addKnot _shp _spln  #Corner #Line  [-10,30,0] 
			addKnot _shp _spln  #Corner #Line [-20,30,0] 
			addKnot _shp _spln  #Corner #Line  [0,50,0] 
			addKnot _shp _spln  #Corner #Line  [20,30,0]
			addKnot _shp _spln  #Corner #Line  [10,30,0] 
			addKnot _shp _spln  #Corner #Line [10,10,0] 
			
			addKnot _shp _spln  #Corner #Line  [30,10,0] 
			addKnot _shp _spln  #Corner #Line  [30,20,0]
			addKnot _shp _spln  #Corner #Line  [50,0,0]
			addKnot _shp _spln  #Corner #Line  [30,-20,0] 
			addKnot _shp _spln  #Corner #Line  [30,-10,0]
			addKnot _shp _spln  #Corner #Line  [10,-10,0] 
			
			addKnot _shp _spln  #Corner #Line  [10,-30,0] 
			addKnot _shp _spln  #Corner #Line  [20,-30,0]
			addKnot _shp _spln  #Corner #Line  [0,-50,0]
			addKnot _shp _spln  #Corner #Line  [-20,-30,0] 
			addKnot _shp _spln  #Corner #Line  [-10,-30,0]
			
			close _shp _spln
			_shp.steps = 2 
			_shp.wirecolor = red
			_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeArrowCross" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			deselect _shp            --deselecciona el shape.
			lb.controller.freezeTransform _shp #all
			
			_shp
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined |  shapeArrowCurveCross  |  Creación del shape Arrow/Cross, la estrella en plano con Bend.
		------------------------------------------------------------------------------------------------
		fn shapeArrowCurveCross =
		(
			_shp = splineShape()
			select _shp
			_spln = addNewSpline _shp
			addKnot _shp _spln  #Corner #Line [-10,-10,0] 
			addKnot _shp _spln  #Corner #Line  [-30,-10,0] 
			addKnot _shp _spln  #Corner #Line  [-30,-20,0]
			addKnot _shp _spln  #Corner #Line  [-50,0,0] 
			addKnot _shp _spln  #Corner #Line [-30,20,0] 
			addKnot _shp _spln  #Corner #Line  [-30,10,0] 
			addKnot _shp _spln  #Corner #Line  [-10,10,0]
			
			addKnot _shp _spln  #Corner #Line  [-10,30,0] 
			addKnot _shp _spln  #Corner #Line [-20,30,0] 
			addKnot _shp _spln  #Corner #Line  [0,50,0] 
			addKnot _shp _spln  #Corner #Line  [20,30,0]
			addKnot _shp _spln  #Corner #Line  [10,30,0] 
			addKnot _shp _spln  #Corner #Line [10,10,0] 
			
			addKnot _shp _spln  #Corner #Line  [30,10,0] 
			addKnot _shp _spln  #Corner #Line  [30,20,0]
			addKnot _shp _spln  #Corner #Line  [50,0,0]
			addKnot _shp _spln  #Corner #Line  [30,-20,0] 
			addKnot _shp _spln  #Corner #Line  [30,-10,0]
			addKnot _shp _spln  #Corner #Line  [10,-10,0] 
			
			addKnot _shp _spln  #Corner #Line  [10,-30,0] 
			addKnot _shp _spln  #Corner #Line  [20,-30,0]
			addKnot _shp _spln  #Corner #Line  [0,-50,0]
			addKnot _shp _spln  #Corner #Line  [-20,-30,0] 
			addKnot _shp _spln  #Corner #Line  [-10,-30,0]
			
			close _shp _spln
			_shp.steps = 2 
			_shp.wirecolor = red
			addmodifier _shp (bend())
			_shp.modifiers[#bend].angle = 100
			_shp.modifiers[#bend].axis = 0
			addmodifier _shp (bend())
			_shp.modifiers[#bend].angle = -100
			_shp.modifiers[#bend].direction = 100
			_shp.modifiers[#bend].axis = 1
			maxOps.CollapseNode _shp off
			_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeArrowCurveCross" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			deselect _shp            --deselecciona el shape.
			lb.controller.freezeTransform _shp #all
			
			_shp
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined |  shapeRectangle  |  Creación del rectangulo.
		------------------------------------------------------------------------------------------------
		fn shapeRectangle =
		(
			_rectangle = Rectangle length:50 width:50 cornerRadius:0 pos:[0, 0, 0]
			_rectangle.steps = 2 
			_rectangle.wirecolor = red
			convertTo _rectangle SplineShape
			_rectangle.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeRectangle" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _rectangle #all
			
			_rectangle
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeRectangleDouble  |  Creación del rectangulo con dos partes.  Rectangle/Double
		------------------------------------------------------------------------------------------------
		fn shapeRectangleDouble =
		(
			_rectangleBase = Rectangle length:50 width:50 cornerRadius:0 pos:[0, 0, 0]
			_rectangle02 = Rectangle length:50 width:50 cornerRadius:0 pos:[0, 0, 20]
			convertTo _rectangleBase SplineShape
			convertTo _rectangle02 SplineShape
			addAndWeld _rectangleBase _rectangle02 0
			_rectangleBase.wirecolor = red
			_rectangleBase.steps = 2 
			_rectangleBase.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeRectangleDouble" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _rectangleBase #all
			
			_rectangleBase
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeRectangleChamfer  |  Creación del rectangulo con chamfer.
		------------------------------------------------------------------------------------------------
		fn shapeRectangleChamfer =
		(
			_rectangle = Rectangle length:50 width:50 cornerRadius:10 pos:[0, 0, 0]
			_rectangle.wirecolor = red
			_rectangle.steps = 2 
			convertTo _rectangle SplineShape
			_rectangle.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeRectangleChamfer" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _rectangle #all
			
			_rectangle
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeCircle  |  Creación del circulo.
		------------------------------------------------------------------------------------------------
		fn shapeCircle =
		(
			_circle = circle radius:20 pos:[0, 0, 0]
			_circle.wirecolor = red
			_circle.steps = 2 
			convertTo _circle SplineShape
			_circle.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeCircle" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _circle #all
			
			_circle
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeCircleDouble  |  Creación del circulo doble.
		------------------------------------------------------------------------------------------------
		fn shapeCircleDouble =
		(
			_circleBase = circle radius:20 pos:[0, 0, 0]
			_circle02 = circle radius:20 pos:[0, 0, 20]
			convertTo _circleBase SplineShape
			convertTo _circle02 SplineShape
			addAndWeld _circleBase _circle02 0
			_circleBase.wirecolor = red
			_circleBase.steps = 2
			_circleBase.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeCircleDouble" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _circleBase #all
			
			_circleBase
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeCircleRefSphere  |  Creación del circulo con esfera en una parte
		------------------------------------------------------------------------------------------------
		fn shapeCircleRefSphere =
		(
			_circleSphere01 = circle radius:2 pos:[0, 0, 0]
			convertTo _circleSphere01 SplineShape
			_circleSphere02 = circle radius:2 pos:[0, 0, 0]
			rotate _circleSphere02 (angleaxis 90 [0,1,0])
			convertTo _circleSphere02 SplineShape
			addAndWeld _circleSphere01 _circleSphere02 0
			_circleSphere03 = circle radius:2 pos:[0, 0, 0]
			rotate _circleSphere03 (angleaxis 90 [1,0,0])
			convertTo _circleSphere03 SplineShape
			addAndWeld _circleSphere01 _circleSphere03 0
			_circleSphere04 = circle radius:2 pos:[0, 0, 0]
			rotate _circleSphere04 (angleaxis 45 [0,1,0])
			convertTo _circleSphere04 SplineShape
			addAndWeld _circleSphere01 _circleSphere04 0
			_circleSphere05 = circle radius:2 pos:[0, 0, 0]
			rotate _circleSphere05 (angleaxis 45 [1,0,0])
			convertTo _circleSphere05 SplineShape
			addAndWeld _circleSphere01 _circleSphere05 0
			_circleSphere06 = circle radius:2 pos:[0, 0, 0]
			rotate _circleSphere06 (angleaxis -45 [0,1,0])
			convertTo _circleSphere06 SplineShape
			addAndWeld _circleSphere01 _circleSphere06 0
			_circleSphere07 = circle radius:2 pos:[0, 0, 0]
			rotate _circleSphere07 (angleaxis -45 [1,0,0])
			convertTo _circleSphere07 SplineShape
			addAndWeld _circleSphere01 _circleSphere07 0
			_circleSphere01.pos.Y = -20
			
			_circle = circle radius:20 pos:[0, 0, 0]
			convertTo _circle SplineShape
			_circle.wirecolor = red
			_circle.steps = 2
			addAndWeld _circle _circleSphere01 0
			_circle.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeCircleRefSphere" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _circle #all
			
			_circle
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeSphere  |  Creación de la esfera.
		------------------------------------------------------------------------------------------------
		fn shapeSphere =
		(
			_circle01 = circle radius:20 pos:[0, 0, 0]
			convertTo _circle01 SplineShape
			_circle02 = circle radius:20 pos:[0, 0, 0]
			rotate _circle02 (angleaxis 90 [0,1,0])
			convertTo _circle02 SplineShape
			addAndWeld _circle01 _circle02 0
			_circle03 = circle radius:20 pos:[0, 0, 0]
			rotate _circle03 (angleaxis 90 [1,0,0])
			convertTo _circle03 SplineShape
			addAndWeld _circle01 _circle03 0
			_circle01.wirecolor = red
			_circle01.steps = 2
			_circle01.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeSphere" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _circle01 #all
			
			_circle01
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeSphereTipsRefSphere  |  Creación del disco radial con esfera.
		------------------------------------------------------------------------------------------------
		fn shapeSphereTipsRefSphere =
		(
			_circle01 = circle radius:3.5 pos:[0, 0, 0]
			convertTo _circle01 SplineShape
			_circle02 = circle radius:3.5 pos:[0, 0, 0]
			rotate _circle02 (angleaxis 90 [0,1,0])
			convertTo _circle02 SplineShape
			addAndWeld _circle01 _circle02 0
			_circle03 = circle radius:3.5 pos:[0, 0, 0]
			rotate _circle03 (angleaxis 90 [1,0,0])
			convertTo _circle03 SplineShape
			addAndWeld _circle01 _circle03 0
			_circle01.pos.Y = -25
			_circle01.pos.X = -10
			
			_star = Star radius1:16 radius2:30 numPoints:8 distort:25 pos:[0, 0, 0]
			convertTo _star SplineShape
			addAndWeld _star _circle01 0
			_star.wirecolor = red
			_star.steps = 2
			_star.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeSphereTipsRefSphere" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _star #all
			
			_star
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeArrow  |  Creación de flecha única.
		------------------------------------------------------------------------------------------------
		fn shapeArrow =
		(
			_shp = splineShape()
			select _shp
			_spln = addNewSpline _shp
			addKnot _shp _spln  #Corner #Line [10,-5,0] 
			addKnot _shp _spln  #Corner #Line  [0,-5,0] 
			addKnot _shp _spln  #Corner #Line  [0,-10,0]
			addKnot _shp _spln  #Corner #Line  [-10,0,0] 
			addKnot _shp _spln  #Corner #Line [0,10,0] 
			addKnot _shp _spln  #Corner #Line  [0,5,0] 
			addKnot _shp _spln  #Corner #Line  [10,5,0]
			close _shp _spln
			_shp.wirecolor = red
			_shp.steps = 2
			_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeArrow" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			deselect _shp            --deselecciona el shape.
			lb.controller.freezeTransform _shp #all
			
			_shp
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeArrowDouble  |  Creación de flecha doble.
		------------------------------------------------------------------------------------------------
		fn shapeArrowDouble =
		(
			_shpBase = splineShape()
			select _shpBase
			_spln = addNewSpline _shpBase
			addKnot _shpBase _spln  #Corner #Line [-1,-5,0] 
			addKnot _shpBase _spln  #Corner #Line  [-11,-5,0] 
			addKnot _shpBase _spln  #Corner #Line  [-11,-10,0]
			addKnot _shpBase _spln  #Corner #Line  [-21,0,0] 
			addKnot _shpBase _spln  #Corner #Line [-11,10,0] 
			addKnot _shpBase _spln  #Corner #Line  [-11,5,0] 
			addKnot _shpBase _spln  #Corner #Line  [-1,5,0]
			close _shpBase _spln
			convertTo _shpBase SplineShape
			_shpBase.wirecolor = red
			
			_shp = splineShape()
			select _shp
			_spln = addNewSpline _shp
			addKnot _shp _spln  #Corner #Line [10,-5,0] 
			addKnot _shp _spln  #Corner #Line  [0,-5,0] 
			addKnot _shp _spln  #Corner #Line  [0,-10,0]
			addKnot _shp _spln  #Corner #Line  [-10,0,0] 
			addKnot _shp _spln  #Corner #Line [0,10,0] 
			addKnot _shp _spln  #Corner #Line  [0,5,0] 
			addKnot _shp _spln  #Corner #Line  [10,5,0]
			close _shp _spln
			rotate _shp (angleaxis 180 [0,0,1])
			move _shp [11,0,0]
			convertTo _shp SplineShape
			addAndWeld _shpBase _shp 0
			
			_rectangle = Rectangle length:6 width:6 cornerRadius:0 pos:[0, 0, 0]
			convertTo _rectangle SplineShape
			move _rectangle [-4,2,0]
			addAndWeld _shpBase _rectangle 0
			
			_rectangle02 = Rectangle length:3 width:3 cornerRadius:0 pos:[0, 0, 0]
			convertTo _rectangle02 SplineShape
			move _rectangle02 [-5.5,0.5,0]
			addAndWeld _shpBase _rectangle02 0
			_shpBase.steps = 2
			_shpBase.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeArrowDouble" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			deselect _shpBase            --deselecciona el shape.
			lb.controller.freezeTransform _shpBase #all
			
			_shpBase
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeBox  |  Creación de cubo.
		------------------------------------------------------------------------------------------------
		fn shapeBox =
		(
			_rectangleBase = Rectangle length:20 width:20 cornerRadius:0 pos:[0, 0, -10]
			convertTo _rectangleBase SplineShape
			
			_rectangle02 = Rectangle length:20 width:20 cornerRadius:0 pos:[0, 0, 10]
			convertTo _rectangle02 SplineShape
			addAndWeld _rectangleBase _rectangle02 0
			
			_rectangle03 = Rectangle length:20 width:20 cornerRadius:0 pos:[0, 0, 10]
			convertTo _rectangle03 SplineShape
			rotate _rectangle03 (angleaxis 90 [1,0,0])
			move _rectangle03 [0,10,-10]
			addAndWeld _rectangleBase _rectangle03 0

			_rectangle04 = Rectangle length:20 width:20 cornerRadius:0 pos:[0, 0, 10]
			convertTo _rectangle04 SplineShape
			rotate _rectangle04 (angleaxis 90 [1,0,0])
			move _rectangle04 [0,-10,-10]
			addAndWeld _rectangleBase _rectangle04 0
			CenterPivot _rectangleBase
			_rectangleBase.wirecolor = red
			_rectangleBase.steps = 2
			_rectangleBase.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeBox" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			lb.controller.freezeTransform _rectangleBase #all
			
			_rectangleBase
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeArrowXYZ  |  Creación de flechas todas direcciones.
		------------------------------------------------------------------------------------------------
		fn shapeArrowXYZ =
		(
			_shpBase = #()
			_shpBase01 = #()
			_shpBase02 = #()
			(
				_shpBase = splineShape()
				select _shpBase
				_spln = addNewSpline _shpBase
				addKnot _shpBase _spln  #Corner #Line [-1,-5,0] 
				addKnot _shpBase _spln  #Corner #Line  [-11,-5,0] 
				addKnot _shpBase _spln  #Corner #Line  [-11,-10,0]
				addKnot _shpBase _spln  #Corner #Line  [-21,0,0] 
				addKnot _shpBase _spln  #Corner #Line [-11,10,0] 
				addKnot _shpBase _spln  #Corner #Line  [-11,5,0] 
				addKnot _shpBase _spln  #Corner #Line  [-1,5,0]
				close _shpBase _spln
				convertTo _shpBase SplineShape
				move _shpBase [-10,0,0]
				_shpBase.wirecolor = red
				
				_shp = splineShape()
				select _shp
				_spln = addNewSpline _shp
				addKnot _shp _spln  #Corner #Line [10,-5,0] 
				addKnot _shp _spln  #Corner #Line  [0,-5,0] 
				addKnot _shp _spln  #Corner #Line  [0,-10,0]
				addKnot _shp _spln  #Corner #Line  [-10,0,0] 
				addKnot _shp _spln  #Corner #Line [0,10,0] 
				addKnot _shp _spln  #Corner #Line  [0,5,0] 
				addKnot _shp _spln  #Corner #Line  [10,5,0]
				close _shp _spln
				rotate _shp (angleaxis 180 [0,0,1])
				convertTo _shp SplineShape
				move _shp [10,0,0]
				addAndWeld _shpBase _shp 0
				CenterPivot _shpBase
				_shpBase.pos = [0,0,0]
				
				_rectangle = Rectangle length:6 width:6 cornerRadius:0 pos:[0, 0, 0]
				convertTo _rectangle SplineShape
				move _rectangle [-8.5,2,0]
				addAndWeld _shpBase _rectangle 0
				
				_rectangle02 = Rectangle length:3 width:3 cornerRadius:0 pos:[0, 0, 0]
				convertTo _rectangle02 SplineShape
				move _rectangle02 [-10,0.5,0]
				addAndWeld _shpBase _rectangle02 0
			)
			
			(
				_shpBase01 = splineShape()
				select _shpBase01
				_spln01 = addNewSpline _shpBase01
				addKnot _shpBase01 _spln01  #Corner #Line [-1,-5,0] 
				addKnot _shpBase01 _spln01  #Corner #Line  [-11,-5,0] 
				addKnot _shpBase01 _spln01  #Corner #Line  [-11,-10,0]
				addKnot _shpBase01 _spln01  #Corner #Line  [-21,0,0] 
				addKnot _shpBase01 _spln01  #Corner #Line [-11,10,0] 
				addKnot _shpBase01 _spln01  #Corner #Line  [-11,5,0] 
				addKnot _shpBase01 _spln01  #Corner #Line  [-1,5,0]
				close _shpBase01 _spln01
				convertTo _shpBase01 SplineShape
				move _shpBase01 [-10,0,0]
				
				_shp01 = splineShape()
				select _shp01
				_spln01 = addNewSpline _shp01
				addKnot _shp01 _spln01  #Corner #Line [10,-5,0] 
				addKnot _shp01 _spln01  #Corner #Line  [0,-5,0] 
				addKnot _shp01 _spln01  #Corner #Line  [0,-10,0]
				addKnot _shp01 _spln01  #Corner #Line  [-10,0,0] 
				addKnot _shp01 _spln01  #Corner #Line [0,10,0] 
				addKnot _shp01 _spln01  #Corner #Line  [0,5,0] 
				addKnot _shp01 _spln01  #Corner #Line  [10,5,0]
				close _shp01 _spln01
				rotate _shp01 (angleaxis 180 [0,0,1])
				move _shp01 [10,0,0]
				convertTo _shp01 SplineShape
				addAndWeld _shpBase01 _shp01 0
				CenterPivot _shpBase01
				_shpBase01.pos = [0,0,0]
				
				_rectangle = Rectangle length:6 width:6 cornerRadius:0 pos:[0, 0, 0]
				convertTo _rectangle SplineShape
				move _rectangle [-8.5,2,0]
				addAndWeld _shpBase01 _rectangle 0
				
				_rectangle02 = Rectangle length:3 width:3 cornerRadius:0 pos:[0, 0, 0]
				convertTo _rectangle02 SplineShape
				move _rectangle02 [-10,0.5,0]
				addAndWeld _shpBase01 _rectangle02 0
				rotate _shpBase01 (angleaxis 90 [0,0,1])
			)
			
			(
				_shpBase02 = splineShape()
				select _shpBase02
				_spln = addNewSpline _shpBase02
				addKnot _shpBase02 _spln  #Corner #Line [-1,-5,0] 
				addKnot _shpBase02 _spln  #Corner #Line  [-11,-5,0] 
				addKnot _shpBase02 _spln  #Corner #Line  [-11,-10,0]
				addKnot _shpBase02 _spln  #Corner #Line  [-21,0,0] 
				addKnot _shpBase02 _spln  #Corner #Line [-11,10,0] 
				addKnot _shpBase02 _spln  #Corner #Line  [-11,5,0] 
				addKnot _shpBase02 _spln  #Corner #Line  [-1,5,0]
				close _shpBase02 _spln
				convertTo _shpBase02 SplineShape
				move _shpBase02 [-10,0,0]
				_shpBase02.wirecolor = red
				
				_shp = splineShape()
				select _shp
				_spln = addNewSpline _shp
				addKnot _shp _spln  #Corner #Line [10,-5,0] 
				addKnot _shp _spln  #Corner #Line  [0,-5,0] 
				addKnot _shp _spln  #Corner #Line  [0,-10,0]
				addKnot _shp _spln  #Corner #Line  [-10,0,0] 
				addKnot _shp _spln  #Corner #Line [0,10,0] 
				addKnot _shp _spln  #Corner #Line  [0,5,0] 
				addKnot _shp _spln  #Corner #Line  [10,5,0]
				close _shp _spln
				rotate _shp (angleaxis 180 [0,0,1])
				convertTo _shp SplineShape
				move _shp [10,0,0]
				addAndWeld _shpBase02 _shp 0
				CenterPivot _shpBase02
				_shpBase02.pos = [0,0,0]
				
				
				_rectangle = Rectangle length:6 width:6 cornerRadius:0 pos:[0, 0, 0]
				convertTo _rectangle SplineShape
				move _rectangle [-8.5,2,0]
				addAndWeld _shpBase02 _rectangle 0
				
				_rectangle02 = Rectangle length:3 width:3 cornerRadius:0 pos:[0, 0, 0]
				convertTo _rectangle02 SplineShape
				move _rectangle02 [-10,0.5,0]
				addAndWeld _shpBase02 _rectangle02 0
				rotate _shpBase02 (angleaxis 90 [0,1,0])
			)
			addAndWeld _shpBase _shpBase01 0
			addAndWeld _shpBase _shpBase02 0
			_shpBase.steps = 2
			_shpBase.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeArrowXYZ" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			deselect _shpBase            --deselecciona el shape.
			lb.controller.freezeTransform _shpBase #all
			
			_shpBase
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeArrowCircle  |  Creación de flecha circular en extremos.
		------------------------------------------------------------------------------------------------
		fn shapeArrowCircle =
		(
			_shp = splineShape()
			select _shp
			_spln = addNewSpline _shp
			addKnot _shp _spln  #Corner #curve [0.921799,-0.390183,0] [0.927848,-0.377209,0] [0.871157,-0.509798,0]
			addKnot _shp _spln  #bezier #curve [0.70692,-0.70692,0] [0.797433,-0.616406,0] [0.525893,-0.887946,0]
			addKnot _shp _spln  #bezier #curve [0.31134e-007,-1,0] [0.275893,-1,0] [-0.551786,-1,0]
			addKnot _shp _spln  #bezier #curve [-1,0,0] [-1,-0.551786,0] [-1,0.551786,0]
			addKnot _shp _spln  #bezier #curve [0,1,0] [-0.551786,1,0] [0.275893,1,0]
			addKnot _shp _spln  #bezier #curve [0.70692,0.70692,0] [0.525893,0.887946,0] [0.797433,0.616406,0]
			addKnot _shp _spln  #Corner #curve [0.9021798,0.390137,0] [0.871157,0.509752,0] [0.927848,0.377164,0]
			addKnot _shp _spln  #corner #curve [0.940401,0.352319,0] [0.934125,0.364741,0] [0.965003,0.363865,0]
			addKnot _shp _spln  #corner #curve [1.01421,0.386957,0] [0.989604,0.375411,0] [1.00695,0.282353,0]
			addKnot _shp _spln  #corner #curve [0.992431,0.0731435,0] [0.999689,0.177748,0] [0.907634,0.134822,0]
			addKnot _shp _spln  #corner #curve [0.738039,0.258179,0] [0.822837,0.196501,0] [0.762698,0.269603,0]
			addKnot _shp _spln  #corner #curve [0.812015,0.292452,0] [0.787356,0.281027,0] [0.805588,0.306225,0]
			addKnot _shp _spln  #Corner #curve [0.793111,0.332971,0] [0.799161,0.319998,0] [0.749559,0.43584,0]
			addKnot _shp _spln  #bezier #curve [0.607951,0.607951,0] [0.685793,0.53011,0] [0.452268,0.763634,0]
			addKnot _shp _spln  #bezier #curve [0,0.86,0] [0.237268,0.86,0] [-0.474536,0.86,0]
			addKnot _shp _spln  #bezier #curve [-0.86,0,0] [-0.86,0.474536,0] [-0.86,-0.474536,0]
			addKnot _shp _spln  #bezier #curve [0,-0.86,0] [-0.474536,-0.86,0] [0.237268,-0.86,0]
			addKnot _shp _spln  #bezier #curve [0.607951,-0.607951,0] [0.452268,-0.763634,0] [0.685793,-0.53011,0]
			addKnot _shp _spln  #Corner #curve [0.793111,-0.333016,0] [0.749559,-0.435885,0] [0.799161,-0.320043,0]
			addKnot _shp _spln  #corner #curve [0.812015,-0.292542,0] [0.805588,-0.306293,0] [0.787356,-0.281118,0]
			addKnot _shp _spln  #corner #curve [0.738039,-0.25827,0] [0.762698,-0.269694,0] [0.822837,-0.196591,0]
			addKnot _shp _spln  #corner #curve [0.992431,-0.0732344,0] [0.907634,-0.134913,0] [0.999689,-0.177839,0]
			addKnot _shp _spln  #corner #curve [1.01421,-0.387048,0] [1.00695,-0.282444,0] [0.989604,-0.375502,0]
			addKnot _shp _spln  #corner #curve [0.940401,-0.35241,0] [0.965003,-0.363956,0] [0.934125,-0.36481,0]
			close _shp _spln
			_shp.scale = [20,20,20]
			ResetXForm _shp
			maxOps.CollapseNode _shp off
			_shp.wirecolor = red
			_shp.steps = 2
			_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeArrowCircle" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			deselect _shp            --deselecciona el shape.
			lb.controller.freezeTransform _shp #all
			
			_shp
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeArrowLine  |  Creación de flecha curva pequeña.
		------------------------------------------------------------------------------------------------
		fn shapeArrowLine =
		(
			_shp = splineShape()
			select _shp
			_spln = addNewSpline _shp
			addKnot _shp _spln  #bezier #curve [30,-20,0] [15,-15,0] [-1,-20,0]
			addKnot _shp _spln  #bezier #curve [-20,30,0] [-22,-10,0] [-1,20,0]
			
			_shp01 = splineShape()
			select _shp01
			_spln01 = addNewSpline _shp01
			addKnot _shp01 _spln01  #Corner #Line [20,-10,0] 
			addKnot _shp01 _spln01  #Corner #Line [30,-20,0]
			addKnot _shp01 _spln01  #Corner #Line [20,-30,0]
			
			_shp02 = splineShape()
			select _shp02
			_spln02 = addNewSpline _shp02
			addKnot _shp02 _spln02  #Corner #Line [-10,20,0] 
			addKnot _shp02 _spln02  #Corner #Line [-20,30,0]
			addKnot _shp02 _spln02  #Corner #Line [-30,20,0]
			
			convertTo _shp SplineShape
			convertTo _shp01 SplineShape
			convertTo _shp02 SplineShape
			addAndWeld _shp _shp01 0
			addAndWeld _shp _shp02 0
			_shp.wirecolor = red
			_shp.steps = 2
			_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeArrowLine" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			deselect _shp            --deselecciona el shape.
			lb.controller.freezeTransform _shp #all
			
			_shp
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeBase |  Creación de la base.
		------------------------------------------------------------------------------------------------
		fn shapeBase =
		(
			_shp = splineShape()
			select _shp
			_spln = addNewSpline _shp
			addKnot _shp _spln  #bezier #curve [40,0,0] [40,20,0] [40,-20,0]
			addKnot _shp _spln  #bezier #curve [0,-54,0] [20,-54,0] [-20,-54,0]
			addKnot _shp _spln  #bezier #curve [-40,0,0] [-40,-20,0] [-40,20,0]
			addKnot _shp _spln  #bezier #curve [0,40,0] [-20,40,0] [20,40,0] 
			close _shp _spln
			
			_shp.wirecolor = red
			_shp.steps = 2 
			_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationNotSpecified + "_" + "shapeBase" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			deselect _shp            --deselecciona el shape.
			lb.controller.freezeTransform _shp #all
			
			_shp
		),
		
		------------------------------------------------------------------------------------------------
		--@fn: undefined | shapeBase |  Creación de la foot.
		--@gets: node |  side  | lb.nc.NC_locationLeft  /  lb.nc.NC_locationRight  /   lb.nc.NC_locationMiddle.   Pasarle el lado que queramos sacar.
		------------------------------------------------------------------------------------------------
		fn shapeFoot side:lb.nc.NC_locationMiddle =
		(
			if side == lb.nc.NC_locationLeft then
			(
				_shp = splineShape()
				select _shp
				_spln = addNewSpline _shp
				addKnot _shp _spln  #bezier #curve [13,-20,0] [15,10,0] [15,-30,0]
				addKnot _shp _spln  #bezier #curve [0,-40,0] [10,-40,0] [-10,-35,0]
				addKnot _shp _spln  #bezier #curve [-12,-20,0] [-12,-50,0] [-15,10,0]
				addKnot _shp _spln  #bezier #curve [0,10,0] [-5,5,0] [5,5,0] 
				close _shp _spln
				
				_shp.wirecolor = red
				_shp.steps = 2 
				_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationLeft + "_" + "shapeFoot" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				deselect _shp            --deselecciona el shape.
				lb.controller.freezeTransform _shp #all
				
				_shp
			)
			
			if side == lb.nc.NC_locationRight then
			(
				_shp = splineShape()
				select _shp
				_spln = addNewSpline _shp
				addKnot _shp _spln  #bezier #curve [12,-20,0] [15,10,0] [12,-50,0]
				addKnot _shp _spln  #bezier #curve [0,-40,0] [10,-35,0] [-10,-40,0] 
				addKnot _shp _spln  #bezier #curve [-13,-20,0] [-15,-30,0] [-15,10,0]
				addKnot _shp _spln  #bezier #curve [0,10,0] [-5,5,0] [5,5,0] 
				close _shp _spln
				
				_shp.wirecolor = red
				_shp.steps = 2 
				_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationRight + "_" + "shapeFoot" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				deselect _shp            --deselecciona el shape.
				lb.controller.freezeTransform _shp #all
				
				_shp
			)
			
			if side == lb.nc.NC_locationMiddle then
			(
				_shp = splineShape()
				select _shp
				_spln = addNewSpline _shp
				addKnot _shp _spln  #bezier #curve [15,-20,0] [15,10,0] [15,-30,0]
				addKnot _shp _spln  #bezier #curve [0,-40,0] [15,-40,0] [-15,-40,0]
				addKnot _shp _spln  #bezier #curve [-15,-20,0] [-15,-30,0] [-15,10,0]
				addKnot _shp _spln  #bezier #curve [0,10,0] [-5,5,0] [5,5,0] 
				close _shp _spln
				
				_shp.wirecolor = red
				_shp.steps = 2 
				_shp.name = lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_notSpecifiedFlag + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + "shapeFoot" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				deselect _shp            --deselecciona el shape.
				lb.controller.freezeTransform _shp #all
				
				_shp
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
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_shapes
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_shapes() --crea la libreria
)