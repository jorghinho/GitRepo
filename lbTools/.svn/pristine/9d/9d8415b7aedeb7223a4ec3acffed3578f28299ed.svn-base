------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script createPointsFromObjects.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script createPointsFromObjects.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_createPointsFromObjects
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Create Points From Objects",	--@var: description | Descripcion del script.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		pointsLayerExist = false, --flag para saber si existe la capa de objetos auxiliares
		hierarchyList = #(), --array donde almacenar las jerarquias de la seleccion
		pointList = #(), --listado de points creados

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

		-----------------------------------------------------------------------------------------------
		--crea un point en el objeto pasado por parametro CURRENTOBJECT
		--devuelve el POINT creado
		-----------------------------------------------------------------------------------------------
		fn createPoint currentObject =
		(
			p = point()
			nameArray = undefined --variable para almacenar las partes del nombre en caso de cumplir el NC
			if lb.nc.ncOK currentObject.name then --si cumple el NC
			(
				nameArray = filterString currentObject.name "_" --obtiene las partes
				
				--modifica la parte 5
				_pointName = "aux_" + (substituteString currentObject.name ("_" + nameArray[5] + "_") ("_" + nameArray[5] + "#Point_"))
			)
			else
				_pointName = currentObject.name + "#Point"
			
			-------------------------------------------------------------------------------------------------------------------------
			--Buscamos las coincidencias de nombres de esos puntos.
			_pointNo = 0
			_numbers = #()
			
			for h in helpers where findString h.name "#Point" != undefined do --recorre los helpers que lleven #Point en el nombre
			(
				_process = false
				
				--decide si el point esta relacionado con CURRENTOBJECT si lleva parte de su nombre dentro del nombre del point 
				if lb.nc.ncOK currentObject.name then --si cumple el NC
					_process = (findString h.name (lb.nc.getSimpleObjectName currentObject.name) != undefined)
				else
					_process = (findString h.name currentObject.name != undefined)
				
				--si CURRENTOBJECT esta relacionado con el point actual
				if _process then
				(
					_index = findString h.name "#Point" --devuelve el indice del nombre donde se encuentra el string #Point
					_number = (substring h.name (_index + 6) 3) --parte numerica del point
					
					if (lb.math.isNumeric _number) then --si es numerico lo añade como entero al array de indices
						appendIfUnique _numbers (_number as integer)
				)		
			)--for
			
			for n in _numbers where n > _pointNo do _pointNo = n --se queda con el indice mas alto
			_pointNo += 1 --añade 1 para incrementar el indice del point que se va a crear
			
			-------------------------------------------------------------------------------------------------------------------------
			
			--ESTE METODO YA NO VALE PORQUE EL INDICE NUMERICO DEL POINT PUEDE NO IR AL FINAL
			-- 			--Si encuentro un punto que empieza por mi mismo nombre
			-- 			if (findString h.name _pointName) != undefined and (findString h.name _pointName) == 1 then
			-- 			(
			-- 				--Si además las ultimas 3 cifras son numéricas
			-- 				if lb.math.isNumeric(substring h.name (h.name.count - 2) 3) do
			-- 				(
			-- 					--Y además tenemos que son mayores que el nombre que le quiero poner al punto entonces
			-- 					if ((substring h.name (h.name.count - 2) 3) As Number) >= _pointNo do
			-- 						_pointNo = ((substring h.name (h.name.count - 2) 3) As Number) + 1
			-- 				)
			-- 			)
				
			--Una vez tengamos el numero de punto correcto lo que haremos será ponerlo en forma de string rellenando de ceros hasta las 3 cifras
			if _pointNo < 10 then
				_pointName = substituteString _pointName "#Point" ("#Point00" + (_pointNo As String))
			else if _pointNo < 100 then
				_pointName = substituteString _pointName "#Point" ("#Point0" + (_pointNo As String))
			else
				_pointName = substituteString _pointName "#Point" ("#Point" + (_pointNo As String))
			
			p.name = _pointName
			
			--cambia el valor de algunos parametros del point y lo mete en la capa _auxObj_
			p.wireColor = currentObject.wireColor
			p.box = true
			p.size = 20
			p.transform = currentObject.transform
			(layerManager.getLayerFromName lb.nc.NC_layerAuxObj).addNode p
			
			p
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(
			this.pointsLayerExist = false --flag para saber si existe la capa de objetos auxiliares
			this.hierarchyList = #() --array donde almacenar las jerarquias de la seleccion
			this.pointList = #() --listado de points creados
			if selection.count !=0 then --si hay algo seleccionado
			(
				sel = getCurrentSelection() --obtenemos la seleccion actual
				
				--Si no existe dicha capa la creamos.
				if layermanager.getLayerFromName lb.nc.NC_layerAuxObj == undefined then
					layermanager.newLayerFromName lb.nc.NC_layerAuxObj
				
				--Buscamos en la selección aquellos objetos que no tienen padre dentro de ella (los que son comienzo de jerarquía)
				for o in sel where (findItem sel o.parent)==0 do
					append hierarchyList #(o)
					
				--Apilamos los objetos en hierarchy list seguidos de sus hijos.
				for arr in hierarchyList do
					for obj in arr do
						for ch in obj.children where (findItem sel ch) !=0 do
							append arr ch
				
				--Creamos un array igual que el de puntos para luego mirar la herencia en este.
				for arr in hierarchyList do
				(
					tempArray = #()
					append pointList tempArray
					
					for obj in arr do
						append tempArray (createPoint obj)
				)
				
				--Ahora que tenemos ambos arrays, sacamos la herencia de los puntos a partir de la herencia de los objetos del otro array
				--Limpiamos la seleccion para dejar seleccionados los puntos que acabamos de crear.
				clearSelection()
				for i=1 to pointList.count do
				(
					--Los vamos seleccionando mientras
					selectMore pointList[i]	
					for j=1 to pointList[i].count do
					(
						--Miramos si en la lista de objetos tiene padre dentro de la lista.
						searchIndex = findItem hierarchyList[i] hierarchyList[i][j].parent
						
						if searchIndex !=0 then
							pointList[i][j].parent = pointList[i][searchIndex]
					)
				)
				
				--Vuelvo a recorrer el array de puntos para hacer un freeze en todos los puntos que he creado
				for i=1 to pointList.count do
					for j=1 to pointList[i].count do
						lb.controller.freezeTransform pointList[i][j] #all
				
				completeRedraw()
			)--if selection
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
		
	)--sc_createPointsFromObjects
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_createPointsFromObjects() --crea el script
)