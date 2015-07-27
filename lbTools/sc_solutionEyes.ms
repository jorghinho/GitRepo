------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: solution Eyes.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del solution Eyes.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_solutionEyes
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "solution Eyes",	--@var: description | Descripcion del script.
		
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
			_eyeL = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_meshFileName + "_" + lb.nc.NC_locationLeft + "_" + "eye" + "_" + "*" + "_" + lb.nc.NC_frozenFlag))[1]
			_eyeR = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_meshFileName + "_" + lb.nc.NC_locationRight + "_" + "eye" + "_" + "*" + "_" + lb.nc.NC_frozenFlag))[1]
			_head = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_meshFileName + "_" + lb.nc.NC_locationNotSpecified + "_" + "head" + "_" +  "*"  + "_" + lb.nc.NC_frozenFlag))[1]
			_irisL = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_" + "eye" + "_" + "*" + "_" + lb.nc.NC_controlFlag))[1]
			_irisR = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_" + "eye" + "_" + "*" + "_" + lb.nc.NC_controlFlag))[1]
			_pupilaL = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_" + "pupil" + "_" + "*" + "_" + lb.nc.NC_controlFlag))[1]
			_pupilaR = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_" + "pupil" + "_" + "*" + "_" + lb.nc.NC_controlFlag))[1]
			_eyeLookL = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_" + "eyeLookAt" + "_" + "*" + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag))[1]
			_eyeLookR = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_" + "eyeLookAt" + "_" +  "*" + "_" + lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag))[1]
			_orbicularEyeL = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationLeft + "_" + "orbicularEye" + "_" + "*" + "_" + lb.nc.NC_controlFlag))[1]
			_orbicularEyeR = (execute ("$" + lb.nc.NC_chrPrefix + "_" + "*" + "_" + lb.nc.NC_classFacial + "_" + lb.nc.NC_locationRight + "_" + "orbicularEye" + "_" + "*" + "_" + lb.nc.NC_controlFlag))[1]
			
			--configura el ojo izquierdo con lo necesario para controlar el iris y la pupila.			
			_tempModifiers = #() --vaciamos el array.
			_eyes = #(_eyeR, _eyeL)
			_eyesLookAt = #(_eyeLookR, _eyeLookL)
			_pupil = #(_pupilaR, _pupilaL)
			_iris = #(_irisR, _irisL)
			_orbicular = #(_orbicularEyeR, _orbicularEyeL)
				
			--configura el ojo derecho con lo necesario para controlar el iris y la pupila.
			for i = 1 to _eyes.count do 
			(
				_o = _eyes[i]
				
				--recorre los modificadores buscando un FFD, lo añade al array y lo elimina, para añadirlo mas adelante y evitar petes.
				for j = _o.modifiers.count to 1 by -1 where (classof _o.modifiers[j]) == FFD_Binding  do
				(
					append _tempModifiers _o.modifiers[j] 
					deleteModifier _o _o.modifiers[j]
				)
				
				-- Añadimos los modificadores
				addModifier _o (Poly_Select()) before:_o.modifiers.count	
				_o.modifiers[#Poly_Select].name = "Clear_selection"
				
				addModifier _o (XForm()) before:_o.modifiers.count 
				_o.modifiers[#xForm].name = "Xform_iris"
				
				addModifier _o (Poly_Select()) before:_o.modifiers.count 
				_o.modifiers[#Poly_Select].name = "PolySelect_iris"					
				
				addModifier _o (XForm()) before:_o.modifiers.count
				_o.modifiers[#xForm].name = "Xform_pupil"	
				
				addModifier _o (Poly_Select()) before:_o.modifiers.count
				_o.modifiers[#Poly_Select].name = "PolySelect_pupil"	
					
				-- Instanciamos el pivote del hlp de ojo con el xForm para que se escale todo a la vez.
				for m = 1 to _o.modifiers.count where ((classof _o.modifiers[m]) == XForm) do
				(
					_o.modifiers[m].gizmo.position = _eyesLookAt[i].position		--configurmos la posicion del punto pivote del center.
					_o.modifiers[m].center = -(_eyesLookAt[i].position)
					
					_o.modifiers[m].Gizmo.controller.Scale.controller = ScaleXYZ ()	--la escal tiene un bezier por defecto, lo cambiamos po scaleXYZ.
					
					--PUPIL. Configuramos con float expresions las pistas X y Z de la escala.
					if _o.modifiers[m].name == "Xform_pupil" then
					(
						_FloatExprScale = _o.modifiers[m].Gizmo.controller.Scale.controller.X_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleX" _pupil[i].scale.controller.Zero_Scale_XYZ.controller.Z_Scale.controller
						_FloatExprScale.setExpression ("ScaleX")
							
						_FloatExprScale = _o.modifiers[m].Gizmo.controller.Scale.controller.Z_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleZ" _pupil[i].scale.controller.Zero_Scale_XYZ.controller.Z_Scale.controller
						_FloatExprScale.setExpression ("ScaleZ")
					)
					
					--IRIS. Configuramos con float expresions las pistas X y Z de la escala.
					if _o.modifiers[m].name == "Xform_iris" then
					(
						_FloatExprScale = _o.modifiers[m].Gizmo.controller.Scale.controller.X_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleX" _iris[i].scale.controller.Zero_Scale_XYZ.controller.Z_Scale.controller
						_FloatExprScale.setExpression ("ScaleX")
							
						_FloatExprScale = _o.modifiers[m].Gizmo.controller.Scale.controller.Z_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleZ" _iris[i].scale.controller.Zero_Scale_XYZ.controller.Z_Scale.controller
						_FloatExprScale.setExpression ("ScaleZ")
					)
				)
				
				-- Añadimos el FFD eliminado anteriormente, equivale a un cortar y pegar.
				for m in _tempModifiers do	addModifier _o m
					
				_tempModifiers = #()
			)
			
			-- Configuracion de la cabeza para el orbicular.
			_index = _head.modifiers.count
			
			for _i = _index to 1 by -1 do
			(
				if (classof _head.modifiers[_i]) == FFD_Binding then --detecta los modificadores con ffd y los mete en un array para añadirlos mas adelante. 
				(
					append _tempModifiers _head.modifiers[_i] 
					deleteModifier _head _head.modifiers[_i]
				)
				if _head.modifiers[_i].name == "Skin" then
					_index = _i
			)
			
			-- Añadimos los modificadores
			addModifier _head (Poly_Select()) before:(_index-1)
			_head.modifiers[#Poly_Select].name = "PolySelect_Orbi_L"
				
			addModifier _head (XForm()) before:(_index-1) 
			_head.modifiers[#xForm].name = "Xform_Orbi_L"
				
			--Añadimos los modificadores necesarios para controlar la pupila y el iris.	
			addModifier _head (Poly_Select()) before:(_index-1)
			_head.modifiers[#Poly_Select].name = "PolySelect_Orbi_R"
				
			addModifier _head (XForm()) before:(_index-1)
			_head.modifiers[#xForm].name = "Xform_Orbi_R"	
				
			addModifier _head (Poly_Select()) before:(_index-1)	
			_head.modifiers[#Poly_Select].name = "Clear_selection"
				
				for _m = 1 to _head.modifiers.count where ((classof _head.modifiers[_m]) == XForm) do
				(
					_head.modifiers[_m].Gizmo.controller.Scale.controller = ScaleXYZ ()	--la escal tiene un bezier por defecto, lo cambiamos por scaleXYZ.
					
					if _head.modifiers[_m].name == "Xform_Orbi_R" then
					(
						_head.modifiers[_m].gizmo.position = _eyesLookAt[1].position		--configuramos la posicion del punto pivote del center.
						_head.modifiers[_m].center = -(_eyesLookAt[1].position)
						
						_FloatList = _head.modifiers[_m].Gizmo.controller.Position.controller = position_list ()
						_FloatExprPos = _head.modifiers[_m].Gizmo.controller.Position.controller.Available.controller = Position_Expression ()
						_FloatExprPos.AddVectorTarget "orbicularEyePos" _orbicular[1].position.controller.Zero_pos_XYZ
						_FloatExprPos.setExpression ("[-orbicularEyePos.x, orbicularEyePos.y, orbicularEyePos.z]")
						
						_FloatExprRot = _head.modifiers[_m].Gizmo.controller.rotation.controller.Y_rotation.controller = Float_Expression ()
						_FloatExprRot.AddScalarTarget "orbicularEyeRotY" _orbicular[1].rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller
						_FloatExprRot.setExpression ("-orbicularEyeRotY")
						
						_FloatExprScale = _head.modifiers[_m].Gizmo.controller.Scale.controller.X_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleX" _orbicular[1].scale.controller.Zero_Scale_XYZ.controller.X_Scale.controller
						_FloatExprScale.setExpression ("ScaleX")
						
						_FloatExprScale = _head.modifiers[_m].Gizmo.controller.Scale.controller.Y_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleY" _orbicular[1].scale.controller.Zero_Scale_XYZ.controller.Y_Scale.controller
						_FloatExprScale.setExpression ("ScaleY")
						
						_FloatExprScale = _head.modifiers[_m].Gizmo.controller.Scale.controller.Z_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleZ" _orbicular[1].scale.controller.Zero_Scale_XYZ.controller.Z_Scale.controller
						_FloatExprScale.setExpression ("ScaleZ")
					)
					
					--Configuramos con float expresions las pistas X y Z de la escala.
					if _head.modifiers[_m].name == "Xform_Orbi_L" then
					(
						_head.modifiers[_m].gizmo.position = _eyesLookAt[2].position		--configuramos la posicion del punto pivote del center.
						_head.modifiers[_m].center = -(_eyesLookAt[2].position)
						
						_FloatList = _head.modifiers[_m].Gizmo.controller.Position.controller = position_list ()
						_FloatExprPos = _head.modifiers[_m].Gizmo.controller.Position.controller.Available.controller = Position_Expression ()
						_FloatExprPos.AddVectorTarget "orbicularEyePos" _orbicular[2].position.controller.Zero_pos_XYZ
						_FloatExprPos.setExpression ("[orbicularEyePos.x, orbicularEyePos.y, orbicularEyePos.z]")
						
						_FloatExprRot = _head.modifiers[_m].Gizmo.controller.rotation.controller.Y_rotation.controller = Float_Expression ()
						_FloatExprRot.AddScalarTarget "orbicularEyeRotY" _orbicular[2].rotation.controller.Zero_Euler_XYZ.controller.Y_rotation.controller
						_FloatExprRot.setExpression ("orbicularEyeRotY")
						
						_FloatExprScale = _head.modifiers[_m].Gizmo.controller.Scale.controller.X_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleX" _orbicular[2].scale.controller.Zero_Scale_XYZ.controller.X_Scale.controller
						_FloatExprScale.setExpression ("ScaleX")
						
						_FloatExprScale = _head.modifiers[_m].Gizmo.controller.Scale.controller.Y_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleY" _orbicular[2].scale.controller.Zero_Scale_XYZ.controller.Y_Scale.controller
						_FloatExprScale.setExpression ("ScaleY")
						
						_FloatExprScale = _head.modifiers[_m].Gizmo.controller.Scale.controller.Z_Scale.controller = Float_Expression ()
						_FloatExprScale.AddScalarTarget "ScaleZ" _orbicular[2].scale.controller.Zero_Scale_XYZ.controller.Z_Scale.controller
						_FloatExprScale.setExpression ("ScaleZ")
					)
				)
				
				for m = 1 to _head.modifiers.count where ((classof _head.modifiers[m]) == Poly_Select) do
				(
					_head.modifiers[m].useSoftSelection = on
					_head.modifiers[m].softselFalloff = 3
				)
			lb.message.show "Facial Modifier Added" type:#message pos:undefined size:[300,75] modal:true	
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
	
	sc_solutionEyes() --crea el script
)