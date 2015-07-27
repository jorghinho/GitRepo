------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: libreria que contiene las funciones principales para la generación y procesado de archivos de cache.
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attributes: CA_LPMauxData | Guarda la descripcion y su version.
	------------------------------------------------------------------------------------------------------------------------------------------------
	CA_LPMauxData = attributes LPM_auxData
	(
		parameters main
		(
			--guarda la descripcion del CA y su version
			CA_description	type:#string 		animatable:false	default:"Información auxiliar del LPM"		--@var: string | CA_description | Descripción general del CA
			CA_version		type:#integer 		animatable:false	default:1 									--@var: integer | CA_version | El numero de versión  del CA
			
			nodeNames		type:#stringTab	animatable:false	tabSizeVariable:true							--@var: stringTab | nodeNames | Nombres de los nodos a los que afecta el objectSet/lightSet de LPM. 
		)
	)

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attributes: CA_light_auxData | Contiene las listas de exclusion y inclusion de los nodos de luz.
	------------------------------------------------------------------------------------------------------------------------------------------------
	CA_light_auxData = attributes light_auxData
	(
		parameters main
		(
			--guarda la descripcion del CA y su version
			CA_description		type:#string 		animatable:false	default:"Información auxiliar del LPM" 	--@var: string | CA_description | Descripción general del CA
			CA_version			type:#integer 		animatable:false	default:1 								--@var: integer | CA_version | El numero de versión  del CA
			
			includeListNames	type:#stringTab	animatable:false	tabSizeVariable:true						--@var: stringTab | includeListNames | Nombres de los nodos incluídos de la luz
			excludeListNames	type:#stringTab	animatable:false	tabSizeVariable:true						--@var: stringTab | excludeListNames | Nombres de los nodos excluidos de la luz
		)
	)

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lib_cache | Contiene la libreria de caches.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_cache
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,													--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Libreria cache",										--@var: string | description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		--Todos los arrays de modificadores los rellenamos en el onCreate porque si no hay hairfarm instalado da error.
		hairFarmClasses = #(),  															--@var: array | hairFarmClasses | Array que contiene los modificadores de hairFarm
		alembicModClasses = #(), 															--@var: array | alembicModClasses | Array que contiene los modificadores de alembic
		cacheModClasses = #(point_cache, point_cacheSpacewarpModifier, transform_cache),	--@var: array | cacheModClasses | Array que contiene los modificadores de tipo cache
		modifiersOnTopOfCache = #(turbosmooth, meshSmooth, tessellate, optimize, proOptimizer, Unwrap_UVW, shell, sweep, symmetry),	--@var: array | modifiersOnTopOfCache | Array que contiene los modificadores que irán sobre el Point_Cache y Transform_Cache
		modifiersToKeepInCache = #(edit_mesh, edit_poly, edit_patch,/* xform,*/ sweep, Materialmodifier, Normalmodifier, symmetry), --@var: array | modifiersToKeepInCache | Array que contiene los modificadores que se conservarán en las geometrías de cache
		modifiersToDisableInCache = #(Unwrap_UVW, shell, sweep, symmetry),					--@var: array | modifiersToDisableInCache | Array que contiene los modificadores que hay que desabilitar en el proceso de generación de cache
		modifiersToCollapseInCache = #(), 													--@var: array | modifiersToCollapseInCache | Array que contiene los modificadores que se colapsarán con la geometría de caches	

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
		--@fn: array | getCacheMods | Consulta los modificadores de tipo cache que tiene el objeto pasado por parámetros.
		--@gets: node | obj | Nodo al que realizar la consulta.
		--@returns: array | cacheMods | Array de modificadores de tipo caché.
		------------------------------------------------		
		fn getCacheMods obj =	
		(
			cacheMods = #()
			
			if obj.modifiers != undefined then
			(
				for m in obj.modifiers do
				(
					if this.isCacheMod m then
						append cacheMods m
				)
			)
			
			cacheMods
		),

		------------------------------------------------
		--@fn: string | getCacheMods | Consulta la sexta parte del nombre del objeto para obtener el tipo de cacheado del objeto.
		--@gets: node | obj | Nodo al que realizar la consulta.
		--@returns: string | cacheMods | El valor devuelto es un string con el tipo de caché que tiene el objeto; puede valer "pc"(Point Cache), "tc"(Transform Cache) o "x"(No tiene modificadores de Cache)
		------------------------------------------------			
		fn getCacheTypeFromName obj = 
		(
			cacheType = undefined
			
			if lb.nc.ncOK obj.name then
			(
				nameParts = filterstring obj.name "_"
				if (finditem lb.nc.NC_specialTypes nameParts[6] != 0) then
					cacheType = nameParts[6]
			)
				
			cacheType
		),

		------------------------------------------------
		--@fn: integer | getPC2fileVertexCount | Consulta el numero de vertices de la geometria cacheada. El proceso se debe realizar sobre archivos de extensión PC2
		--@gets: string | pcFile | Path al fichero de pc2
		--@returns: integer | _numVerts | Numero de vertices de la geometria almacenada en el cacheado de la pieza
		------------------------------------------------			
		fn getPC2fileVertexCount pcFile =
		(
			_numVerts = 0

			_pc2Utils = dotnetObject "pc2Utils.PointCache2Utils" pcFile
			_numVerts = _pc2Utils.getPointCache2vertexCount()

			_numVerts
		),

		------------------------------------------------
		--SETS
		------------------------------------------------
		------------------------------------------------
		--@fn: undefined | setCacheEnabled | Activa o desactiva los modificadores de cache del objeto pasado por parámetro sin perder nunca la referencia del fichero que contenía cada modificador
		--@gets: node | obj | Nodo sobre el que realizar las acciones.
		--@gets: boolean | state | Si vale true, indica que hay que activar los modificadores, false los deshabilita.
		------------------------------------------------		
		fn setCacheEnabled obj state =
		(
			mods = this.getCacheMods obj
			for m in mods do 
			(
				c = classof m
				
				if c == point_cache or c == point_cacheSpacewarpModifier then 
					m.enabled = state
				
				if c == transform_cache then
				(
					if state then
						m.reloadCache()
					else
						m.unloadCache()
					
					m.enabled = state
				)
			)
		),

		------------------------------------------------
		--@fn: undefined | setCachePlaybackData | Establece los valores de configuración de cache pasados por parámetro en los modificadores de cache del objeto suministrado. 
		--@gets: node | obj | Nodo sobre el que realizar las acciones.
		--@gets: (opt)integer | playbackType | Indica el tipo playback; 0 (Original Range), 1 (Custom Start), 2 (Custom Range), 3 (Loop Range). Por defecto undefined.
		--@gets: (opt)integer | playbackStart | Valor con el que configurar el parámetro Start del loop, Usado en el modo 1,2,3. Por defecto undefined.
		--@gets: (opt)integer | playbackEnd | Valor con el que configurar el parámetro End del loop, Usado en el modo 2,3 Por defecto undefined.
		--@gets: (opt)integer | strength | Valor con el que configurar el parámetro strength. Por defecto undefined.
		--@gets: (opt)boolean | relativeOffset | Si vale true, aplica un offset relativo en el playback. Por defecto undefined.
		--@gets: (opt)boolean | cacheLoop | Se activa el playbackGraph y se pone en loop. Por defecto undefined.
		------------------------------------------------		
		fn setCachePlaybackData obj playbackType:undefined playbackStart:undefined playbackEnd:undefined strength:undefined relativeOffset:undefined cacheLoop:undefined  =
		(
			mods = this.getCacheMods obj
							
			for m in mods do
			(
				if playbackType 	!= undefined then	m.playbackType = playbackType
				if playbackStart 	!= undefined then m.playbackStart = playbackStart
				if playbackEnd 		!= undefined then m.playbackEnd = playbackEnd
				if strength 			!= undefined then m.strength = strength
				if relativeOffset 	!= undefined then m.relativeOffset = relativeOffset
				
				--	gestión del loop
				--	Para Transform Cache se soporta internamente
				--	Para Point Cache se activa el playbackGraph y se pone en loop.
				if cacheLoop 	!= undefined then
				(
					if classOf m == transform_cache then
						m.loop = cacheLoop
					else if cacheLoop then
					(
						m.playbackType = 3
						c = bezier_float()
						setBeforeORT c #loop
						setAfterORT c #loop
						addNewKey c playbackStart
						addNewKey c playbackEnd
						c.keys[1].value = 0
						c.keys[2].value = m.recordEnd
						c.keys[1].inTangentType = c.keys[1].outTangentType = #linear
						c.keys[2].inTangentType = c.keys[2].outTangentType = #linear
						
						m[#Playback_Frame].controller = c
					)
				)
			)
		),

		------------------------------------------------
		--OTHER
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | redirectPointCacheSources | Redirecciona todos los paths de point cache, sustituyendo la una parte de las rutas (Un patrón pasado por parámetros), por otra.
		--@gets: string | sourcePattern | Parte de los paths que sustituir.
		--@gets: string | mappedPattern | Cadena de texto con la que sustituir los cachés que cumplan el patrón
		------------------------------------------------		
		fn redirectPointCacheSources sourcePattern mappedPattern =
		(
			for i=1 to objects.count do --recorre los objetos
				for m in objects[i].modifiers where (classof m == Point_Cache) and (m.filename != undefined) do --recorre los modificadores buscando point caches
				(
					--hace backup del rango de caches
					_playbackStartBckp = m.playbackstart
					_playbackEnd = m.playbackend
					
					m.filename = substituteString ((tolower (getfilenamepath m.filename)) + (getfilenamefile m.filename) + (getfilenametype m.filename)) (tolower sourcePattern) (tolower mappedPattern)
										
					--restaura el rango de caches
					m.playbackstart = _playbackStartBckp
					m.playbackend = _playbackEnd
				)--if
		),

		------------------------------------------------
		--@fn: undefined | redirectTransformCacheSources | Redirecciona todos los paths de point cache, sustituyendo la una parte de las rutas (Un patrón pasado por parámetros), por otra.
		--@gets: string | sourcePattern | Parte de los paths que sustituir.
		--@gets: string | mappedPattern | Cadena de texto con la que sustituir los cachés que cumplan el patrón
		------------------------------------------------			
		fn redirectTransformCacheSources sourcePattern mappedPattern =
		(
			for i=1 to objects.count do --recorre los objetos
				for m in objects[i].modifiers where (classof m == Transform_Cache) and (m.filename != undefined) do --recorre los modificadores buscando transform caches
				(
					--hace backup del rango de caches
					_playbackStartBckp = m.playbackstart
					_playbackEnd = m.playbackend
					
					m.filename = substituteString ((tolower (getfilenamepath m.filename)) + (getfilenamefile m.filename) + (getfilenametype m.filename)) (tolower sourcePattern) (tolower mappedPattern)
										
					--restaura el rango de caches
					m.playbackstart = _playbackStartBckp
					m.playbackend = _playbackEnd
				)--if
		),

		------------------------------------------------
		--@fn: boolean | isCacheMod | Indica si el modificador pasado por parámetros es de tipo Cache
		--@gets: modifier | m | Modificador al que realizar la consulta.
		--@returns: boolean | _numVerts | Devuelve True si el modificador es de tipo caché. 
		------------------------------------------------		
		fn isCacheMod m =
		(
			(finditem this.cacheModClasses (classof m) != 0)
		),

		------------------------------------------------
		--@fn: undefined | addCacheModByName | Añade al objeto pasado por parámetros el modificador de cache que le corresponda según lo que tenga especificado en su nombre y el tipo de escena.
		--@gets: node | obj | Nodo al que añadir el modificador.
		--@gets: (opt)name | sceneType | Tipo de escena, puede valer #anim o #cache. Para #anim añade un PC_WSM o TC, en #cache añade PC o TC
		--@gets: (opt)boolean | forceTC | Para tipos de escena de #caché. Si vale True fuerza que haya un modificador de TransformCaché.
		------------------------------------------------		
		fn addCacheModByName obj sceneType:#anim forceTC:false = 
		(
			cacheType = this.getCacheTypeFromName obj
			
			if sceneType == #anim then
			(
				case cacheType of 
				(
					(lb.nc.NC_pcCache): lb.modifiers.insertModifier obj (point_cacheSpacewarpModifier())
					(lb.nc.NC_tcCache): lb.modifiers.insertModifier obj (transform_cache())
				)
			)
			
			if sceneType == #cache then
			(
				i = 1
				modIndex = 0
				
				while i <= obj.modifiers.count do
				(
					if (finditem this.modifiersOnTopOfCache (classof obj.modifiers[i]) != 0) then modIndex = i
					
					i += 1
				)
				
				if forceTC then
				(
					_found = false
					for m in obj.modifiers where classof m == transform_cache do _found = true
					
					if not _found then lb.modifiers.insertModifier obj (transform_cache()) before:modIndex
				)
				else
				(
					case cacheType of 
					(
						(lb.nc.NC_pcCache): (lb.modifiers.insertModifier obj (point_cache()) before:modIndex)
						(lb.nc.NC_tcCache):	(lb.modifiers.insertModifier obj (transform_cache()) before:modIndex)
					)
				)
			)
		),

		------------------------------------------------
		--@fn: undefined | removeCacheMods | Elimina del objeto pasado por parametros el modificador de cache que tenga asignado
		--@gets: node | obj | Nodo al que eliminarle el modificador.
		------------------------------------------------			
		fn removeCacheMods obj = 
		(
			cacheMods = (this.getCacheMods obj)
			for m in cacheMods do
				deleteModifier obj m
		),

		------------------------------------------------
		--@fn: undefined | resetCache | Elimina la referencia del fichero que tenía cada modificador de cache que tiene el objeto pasado por parametros, dejando las geometrías en su estado por defecto
		--@gets: node | obj | Nodo al que resetearle las referencias.
		------------------------------------------------			
		fn resetCache obj =
		(
			mods = this.getCacheMods obj
			for m in mods do m.filename = ""
		),

		------------------------------------------------
		--@fn: undefined | loadCache | Carga el fichero de cache especificado en los modificadores de cache del objeto pasado por parámetros.
		--@gets: node | obj | Nodo al que cargarle el fichero de cache
		--@gets: string | filename | Path al fichero de caché, solo debe contener hasta el nombre del fichero, no la extensión (que la gestiona la función según el tipo de cache).
		------------------------------------------------		
		fn loadCache obj filename =
		(
			--print "load"
			if (getFilenameType filename) == ".abc" then
			(
				_importJob = "filename=" + filename + ";"
				--_importJob += "attachToExisting=true;"
				--print _importJob
				ExocortexAlembic.createImportJob(_importJob);
				_allObjects = execute("$'" + (getFilenameFile filename) + "*'")
				_targetObj = undefined
				_alembicObj = undefined
				print _importJob
				--Si lo ha creado igualmente entonces copiamos el modificador al objeto que toca
				if _allObjects.count == 2 then
				(
					if _allObjects[1] != obj then
					(
						_targetObj = _allObjects[1]
						_alembicObj = _allObjects[2]
					)
					else if _allObjects[2] != obj then
					(
						_targetObj = _allObjects[2]
						_alembicObj = _allObjects[1]
					)
					
					if _targetObj != undefined then
					(
						_alembicMods = #()
						for m in alembicObj.modifiers do
						(
							if (finditem this.alembicModClasses m) != 0 then
								append _alembicMods m
						)
						delete _alembicObj
						
						
						--Obtenemos el lugar donde insertar el modificador.
						_index = 1
						for i=1 to _targetObj.modifiers.count do
						(
							if (finditem this.modifiersOnTopOfCache _targetObj.modifiers[i]) != 0 then
								_index = i + 1
						)
						
						for i = _alembicMods.count to 1 by -1 do
						(
							lb.modifiers.insertModifier _targetObj _alembicMods[i] before:_index
						)		
					)
				)
			)
			else
			(
				cacheMods = this.getCacheMods obj
				_modifiersToDelete = #()

				_errorMessage = ""
				for i = cacheMods.count to 1 by -1 do 
				(
					c = classof cacheMods[i]
					
					if c == point_cache or c == point_cacheSpacewarpModifier then 
					(
						f = filename + ".pc2"
						if not doesFileExist f then 
						(
							if doesFileExist (filename + ".xml") then
							(
								f = filename + ".xml"  		--	si no se encuentra el fichero pc2 se prueba con el .xml
							)
							else
							(
								cacheMods[i].filename = ""
								_errorMessage += (obj.name + " has a point cache and cannot find the .pc2 or .xml file for it\n")
							)
						)
						else cacheMods[i].filename = f
					)
					
					if c == transform_cache then
					(
						if doesFileExist (filename + ".pc2") then 
						(
							_str = obj.name
							_strPts = filterString _str "_"
							if _strPts[6]!= lb.nc.NC_pcCache do _strPts[6]=lb.nc.NC_pcCache
							lb.str.join _strPts "_"
							obj.name = _str
							
							deleteModifier obj cacheMods[i]
							_pc = Point_Cache()
							_pc.filename = (filename + ".pc2")
							addModifier obj _pc before:(i+1)
						)
						else 
						(
							if doesFileExist (filename + ".xaf") then
							(
								cacheMods[i].filename = (filename + ".xaf")
							)
							else 
							(
								cacheMods[i].filename = ""
								_errorMessage += (obj.name + " has a transform cache and cannot find the .xaf file for it\n")
							)
						)
					)
				)
			)
			if _errorMessage != "" then return _errorMessage else return ""
		),

		------------------------------------------------
		--@fn: undefined | recordCache | Graba en el fichero pasado por parametros la información de cache del objeto
		--@gets: node | obj | Nodo al que grabarle el fichero de cache
		--@gets: string | filename | Path en el que generar el fichero de cache, solo debe contener hasta el nombre del fichero, no la extensión (que la gestiona la función según el tipo de cache).
		--@gets: time | startTime | Frame en el que iniciar la grabación de cache
		--@gets: time | endTime | Frame en el que finalizar la grabación de cache
		--@gets: (opt)string | pcFormat | Extensión del fichero de caché. Puede ser ".pc2", ".xaf", ".abc", ".xml". Por defecto ".pc2"
		--@gets: (opt)string | newCacheFile | Si vale true indica que si filename ya existía lo tiene que borrar primero. Por defecto false
		--Esto es para evitar que se cargue en el modificador información que ya estaba guardada previamente, lo que provocaría que nunca conseguiríamos guardar la nueva animación.
		--@gets: (opt)boolean | ignoreTransforms | Si vale true se ignoran las transformaciones del objeto. Por defecto false.
		------------------------------------------------
		fn recordCache obj filename startTime endTime pcFormat:".pc2" newCacheFile:false ignoreTransforms:false =
		(
			cacheMods = this.getCacheMods obj
			for m in cacheMods do 
			(
				c = classof m
				
				if c == point_cache or c == point_cacheSpacewarpModifier then 
				(
					f = filename + pcFormat
					if newCacheFile and (doesFileExist f) then deleteFile f
					
					m.filename = f
					m.recordStart =startTime
					m.recordEnd = endTime
					
					-- Cuando no hay animación de ningún vértice en el rango (startTime - endTime)
					-- el Point Cache no es capaz de almacenar claves. Añadimos un bend con una animación
					-- invisible que soluciona el problema 
					numModifier = 0
					for i = 1 to obj.modifiers.count where obj.modifiers[i] == m do numModifier = i
					auxMod = bend()
					lb.modifiers.insertModifier obj auxMod before:numModifier
					with animate on
					(
						at time (startTime + 0.15) auxMod.angle = 1
						at time (startTime + 0.14) auxMod.angle = 0
						at time (startTime + 0.16) auxMod.angle = 0
					)
					
					cacheOps.recordCache m
					deleteModifier obj auxMod
				)
				
				if c == transform_cache then
				(
					f = filename + ".xaf"
					
					if newCacheFile and (doesFileExist f) then deleteFile f
					
					--m.filename = f
					m.recordStart = startTime
					m.recordEnd = endTime
					m.recordCache saveFile:f ignoreTransforms:ignoreTransforms
				)
			)
		),

		------------------------------------------------
		--@fn: undefined | recordCacheFromObject | Guarda la información de Point Cache y Transform Cache del objeto pasado por parametros y lo almacena en la carpeta suministrada. El nombre del fichero generado es el del propio objeto sin los sufijos de flags.
		--@gets: node | obj | Nodo al que grabarle el fichero de cache
		--@gets: string | folder | Path a la carpeta en la que generar el fichero de cache.
		--@gets: time | startFrame | Frame en el que iniciar la grabación de cache
		--@gets: time | endFrame | Frame en el que finalizar la grabación de cache
		--@gets: (opt)string | pcFormat | Extensión del fichero de caché. Puede ser ".pc2", ".xaf", ".abc", ".xml". Por defecto ".pc2"
		--@gets: (opt)boolean | forceTC | Se fuerza la grabación como Transform Cache. Por defecto false
		--@gets: (opt)boolean | ignoreTransforms | Si vale true se ignoran las transformaciones del objeto. Por defecto false.
		------------------------------------------------		
 		fn recordCacheFromObject obj folder startFrame endFrame pcFormat:".pc2" forceTC:false ignoreTransforms:false =
		(
			if pcFormat == ".abc" then
			(
				
				lb.proxy.disableProxy obj --desactiva el proxy si lo tuviera
				
				--	desactivamos los modificadores que no pueden estar activos en el guardado de caches
				for m in obj.modifiers do
				(
					if findItem this.modifiersToDisableInCache (classOf m) != 0 then
					(	
-- 						print m.name
						lb.modifiers.setModifierState m #disabled
					)
				)
				
				clearSelection()
				Select obj
-- 				lb.message "ojete" type:#message
-- 				_copy = copy obj
-- 				_copy.name += "_before"
-- 				append _objects_before _copy
				
-- 				abcPrepareModifiers
				--Parámetro de nombre de archivo
				_jobParams = "filename=" + folder + obj.name + ".abc;"
				--Parámetro de exportar sólo los seleccionados
				_jobParams += "exportSelected=true;"
				--Parámetro de frame de inicio y fin
				_jobParams += "in=" + (substituteString (startFrame As String) "f" "") + ";"
				_jobParams += "out=" + (substituteString (endFrame As String) "f" "") + ";"
				--Step y substep de frames 
				_jobParams += "step=1;"
				_jobParams += "subStep=1;"
				--Mesh Topology = 2 que es point cache
				_jobParams += "meshTopology=2;"
				--Transformar emisores de partículas en objetos bakeados (no por defecto)
-- 				_jobParams += "particleSystemToMeshConversion=false;"
				--Instancias de partículas creadas en un archivo externo (no)
-- 				_jobParams += "automaticinstancing=false;"
				--Exportar facesets (para maya y houdini) todos
-- 				_jobParams += "partitioningFacesetsOnly=All;"
				
				--Exportar normales (no)
-- 				_jobParams += "normals=false;"
				--Exportar uvs
-- 				_jobParams += "uvs=false;"
				--Exportar ids de materiales (no)
-- 				_jobParams += "materialIDs=false;"
				--Colapsar jerarquías de transformación, nos da un poco igual así que ponemos que sí para que ocupe menos.
				_jobParams += "flattenHierarchy=true;"
				
				--Si es una cámara no se puede forzar el tc porque no guarda el resto de parámetros
				if superclassof obj == camera then
				(	
					_jobParams += "transformCache=false;"
				)
				else
				(
-- 					append _mierder (copy obj)
					if forceTC then
					(
						_jobParams += "transformCache=true;"
					)
					else
					(
						--Exportar únicamente point cachés puros (sin geometría) lo activamos
						_jobParams += "purePointCache=true;"
					)
				)
				
				--Validar la topología de la malla (no vamos a exportar malla así que no)
-- 				_jobParams += "validateMeshTopology=false;"
				
				--Tipo de almacenamiento
				_jobParams += "storageFormat=ogawa;"
				--_jobParams += "storageFormat=ogawa;"
				
				--Metemos el objeto que vamos a sacar por nombre.
-- 				_jobParams += "objects=" + obj.name + ";"
				ExocortexAlembic.createExportJobs(_jobParams)
				
				clearSelection()
				
				--print _jobParams
			)
			else
			(
				-- Añadimos temporalmente el modificador de cache que corresponda a cada objeto
				if forceTC then --si hay que forzar a que sea TC
					lb.modifiers.insertModifier obj (transform_cache())
				else --si no se fuerza se elige por el tipo
				(
					if superClassOf obj != camera then
						this.addCacheModByName obj --sceneType:#cache		
					else
						lb.modifiers.insertModifier obj (transform_cache())
				)
				
				filename = folder + "\\" + (lb.nc.getSimpleObjectName obj.name)
				
				lb.proxy.disableProxy obj --desactiva el proxy si lo tuviera
				
				--	desactivamos los modificadores que no pueden estar activos en el guardado de caches
				for m in obj.modifiers do
					if findItem this.modifiersToDisableInCache (classOf m) != 0 then
						lb.modifiers.setModifierState m #disabled
				
				this.recordCache obj filename startFrame endFrame pcFormat:pcFormat newCacheFile:true ignoreTransforms:ignoreTransforms
				
				this.removeCacheMods obj -- Eliminamos los modificadores de cache de cada objeto		
				
				--	restablecemos los modificadores que no pueden estar activos en el guardado de caches
				for m in obj.modifiers do
					if findItem this.modifiersToDisableInCache (classOf m) != 0 then
						lb.modifiers.setModifierState m #enabled
				
				--gc light:true
			)
		),

		------------------------------------------------
		--@fn: undefined | reloadCache | Vuelve a cargar el fichero de cache que tenga especificado cada modificador de cache del objeto pasado por parametros.
		--@gets: node | obj | Nodo al que recargar los caches
		------------------------------------------------		
		fn reloadCache obj =
		(
			mods = this.getCacheMods obj
			for m in mods do 
			(
				c = classof m
				
				if c == point_cache or c == point_cacheSpacewarpModifier then 
				(
					--cacheOps.reload m		-- No se puede usar este comando directamente porque obliga 
												-- a tener seleccionado el modificador en el panel de modificadores
					
					-- guardamos los valores actuales
					pt = m.playbackType
					ps = m.playbackStart
					pe = m.playbackEnd
					st = m.strength
					ro = m.relativeOffset
					
					-- cargamos el fichero de nuevo
					m.filename = m.filename
					
					-- reasignamos los valores iniciales
					m.playbackType = pt
					m.playbackStart = ps
					m.playbackEnd = pe
					m.strength = st
					m.relativeOffset = ro
				)
				
				if c == transform_cache  then
					m.reloadCache()
			)
		),

		------------------------------------------------
		--@fn: undefined | convertSceneToCaches | Convierte la escena de animación actual a una escena de caches.
		--@gets: boolean | processAssets | Si vale True indica que hay que convertir los assets a caches
		--@gets: boolean | processCaches | Si vale True indica si hay que guardar los ficheros de cache de cada pieza
		--@gets: (opt)string | cachesFolder | Path que indica dónde hay que guardar los ficheros de datos de cache
		--@gets: (opt)string | pcFormat | Extensión del fichero de caché. Puede ser ".pc2", ".xaf", ".abc", ".xml". Por defecto ".pc2"
		--@gets: (opt)boolean | deleteOldCacheFiles | Si vale True se borrarán los archivos existentes de caché, Si vale false se reaprovechan y no se vuelven a generar. Por defecto true
		--@gets: (opt)boolean | mergeXrefs | Si vale True indica que hay que deshacer las referencias externas y mergear sus piezas. Por defecto false
		--@gets: (opt)boolean | disableCloth | Si vale True indica que hay que deshabilitar los modificadores de cloth para la generación de caché. Por defecto false

		--	Se realiza el siguiente proceso:
		--	-	Merge de todas las escenas cargadas por xRef y xRefObjects
		--	-	Borrado de todas las piezas de tipo mesh
		--	-	Borrado de todos los modificadores de las piezas de tipo mesh que no es necesario conservar (skin, skin Morph, etc)
		--	-	Se añaden los modificadores de cache a las piezas de tipo mesh. A las piezas de tipo TC se le cambian además los controladores de animación
		--	-	Se crean las piezas root con sus animTracks para cada asset y se lincan todas sus piezas mesh a su root
		--	-	Borrado de las luces de la escena
		--	-	Se colapsa la animación de las cámaras
		------------------------------------------------		
		fn convertSceneToCaches processAssets processCaches cachesFolder:undefined pcFormat:".pc2" deleteOldCacheFiles:true mergeXrefs:false disableCloth:false =
		(
			local assets = #()							--	Assets de la escena
			local meshObjs = #()						--	Todas las piezas de tipo mesh de todos los assets
			local meshForceTC = #()					--	Todos los mesh a los que hay que forzar a que llevn un TC, por parametros adicionales como visibility, etc.
			local meshObjsByAsset = #()			--	Array con subarrays que contienen las piezas de cada asset
			local cacheAssetNodes = #()			--	Array con los objetos de los asset de cache que no se pueden borrar
			local assetsObjects = #()				--	Todas las piezas de todos los assets
			local assetsObjectsToDelete = #()		--	Objetos a borrar de la escena
			local assetsRootTransforms = #()		--	Transformaciones del root node de cada asset.
			local assetsAnimRanges = #()			--	Rangos de animación de cada asset
			local assetsParentsNames	= #()		--	Indica para cada asset si es dependiente de otro
			
			--	capturamos la ruta en la que se van a guardar los cachés
			local sourceFolder = if cachesFolder != undefined then cachesFolder else ((getFileNamePath maxFilePath) + "source\\")
			
			setWaitCursor()
			
			----------------------------------------------------------------------------------------
			--		BORRADO DE LUCES Y COLAPSADO DE ANIMACIÓN DE CÁMARA
			----------------------------------------------------------------------------------------
			--	Todas las luces auxiliares que pueda haber en la escena se eliminan.
			--	En cuanto a las cámaras, se colapsan sus controladores de animación para
			--	no tener problemas con controladores como noise, que se reproduce de forma
			--	distinta en cada PC.
			----------------------------------------------------------------------------------------
				
			--	borramos luces y su capa
			delete lights
			layerManager.deleteLayerByName lb.nc.NC_layerLight
			
			-- borramos el layer auxiliar de layout		
			layerManager.deleteLayerByName lb.nc.NC_layerLayout
			

			----------------------------------------------------------------------------------------
			--		PREPROCESO DE ASSETS: SE DESHACEN LOS XREFS
			----------------------------------------------------------------------------------------
			--	Todas las escenas de tipo xRefScenes o xRefObjects se mergean para
			--	eliminar cualquier dependencia del fichero hacia el exterior.
			----------------------------------------------------------------------------------------
			if processAssets and mergeXrefs then
			(
 				--print "Mergeamos xrefs"
				--	deshacemos las referencias XRefObjs
				xRefRecords = (for i = 1 to objXRefMgr.recordCount collect objXrefMgr.getRecord i)
				for x in xRefRecords do try objXRefMgr.mergeRecordIntoScene x catch()		--	cuando un xRef depende de otro, al mergear el principal también se mergea el dependiente, 
																														--	por lo que ese xRefRecord desaparece y no se podrá mergear cuando le llegue el momento. Por eso el TRY.
				--	deshacemos las referencias XRefScenes
				for i = (xrefs.getXrefFileCount()) to 1 by -1 do merge (xRefs.getXRefFile i)
			)
			
			----------------------------------------------------------------------------------------
			--		RECOPILACIÓN DE ASSETS Y ROOT/BASE NODES
			----------------------------------------------------------------------------------------
			--	Obtenemos los assets que quedan en la escena y recopilamos
			--	Toda la información general necesaria
			----------------------------------------------------------------------------------------
			
			--	capturamos los assets ahora que se ha hecho el merge de todo (en el caso de que estuviera
			-- 	indicado que había que procesar los assets) y recopilamos todos los objetos de tipo mesh y cache
			assets = lb.asset.getSceneAssets()

			for a in assets where a.type != lb.nc.NC_setPrefix do
			(
				setWaitCursor()

				--si no tiene nodos connect el asset, se los crea
				if a.connectNodesAll.count == 0 then lb.asset.createConnectNodesInAsset a

				setArrowCursor()
			)

			assets = lb.asset.getSceneAssets()
			
			for a in assets where a.type != lb.nc.NC_setPrefix do
			(
				setWaitCursor()
							
				--	recopilamos los mesh de todos los asset y las piezas que no son de mesh y se tienen que exportar a cache
				objs = for o in a.nodes where (((lb.nc.getObjectType o == lb.nc.NC_classMesh) or (lb.nc.getObjectType o == lb.nc.NC_classHair) or (lb.nc.getObjectType o == lb.nc.NC_classConnect)) and (not lb.nc.hasFlag o lb.nc.NC_cacheFlag)) collect o
				join meshObjs objs
				
				--recopila todos los mesh que tengan la pista visibility animada			
				for o in meshObjs where (o[1].controller != undefined or o.visibility == false) do
				(
					_stop = false
					for i=animationRange.start to animationRange.end where not _stop do
					(
						at time i
						(						
							--el primer subanim de un objeto es la visibilidad
							if o[1].controller != undefined then
							(
								if o[1].controller.value != 1.0 then
								(
									appendIfUnique meshForceTC o
									_stop = true
								)
							)
							else if o.visibility == false then
							(
								appendIfUnique meshForceTC o
								_stop = true
							)
						)
					)
				)--for
				
				--print "llega2"
				
				--	recopilamos los mesh de cada asset
				assetMeshObjs = (for o in a.nodes where (((lb.nc.getObjectType o == lb.nc.NC_classMesh) or (lb.nc.getObjectType o == lb.nc.NC_classHair) or (lb.nc.getObjectType o == lb.nc.NC_classConnect)) and (not lb.nc.hasFlag o lb.nc.NC_cacheFlag)) collect o)
				append meshObjsByAsset assetMeshObjs
				
				--print "llega3"
				
				--	Los nodos de assets de tipo cache no deben borrarse. Los anotamos
				--	???? Unicamente agrega aquellos que tengan flag de cachés :/ ????
				cacheObjs = for o in a.nodes where (lb.nc.hasFlag o lb.nc.NC_cacheFlag) collect o
				if cacheObjs.count != 0 then join cacheAssetNodes (lb.asset.getAssetNodes a)
				
				--print "llega4"
				
				-- Recopilamos el rango en el que está animado el asset
				animRange = lb.asset.getAssetAnimRange a timeRange:animationRange
				
				-- Si no hay animación exportamos el primer frame del rango
				if animRange.start == animRange.end then animRange.end = animRange.start + 1
				
				--print "llega5"
				
				append assetsAnimRanges animRange
				
				--	Obtenemos la transformación de los root nodes de cada asset.
				--	Si el asset es dependiente se coge el root del padre
				--	Si no hay root node se anota la matriz unidad
				assetRootNode = lb.asset.getAssetRootNode a
				assetParentName = undefined
				
				--print "llega6"
				
				if a.isDependent then	--	Si es un asset dependiente indicamos que el root node es el del asset padre
				(
					assetIndex = lb.asset.findAssetByName assets a.mainAsset
					if  assetIndex != 0 then
					(
						assetRootNode = lb.asset.getAssetRootNode assets[assetIndex]
						if assetRootNode != undefined then assetParentName = assetRootNode.name
					)
				)
				else 
				(
					if assetRootNode != undefined then
					(
						-- Si el root tiene un linkConstraint asignamos como root node al padre en el fotograma inicial de animación
						if (classof assetRootNode.controller == link_constraint) then
						(
							for i = 1 to assetRootNode.controller.getNumTargets() do
							(
								frameNo = assetRootNode.controller.getFrameNo i
								
								if frameNo <= animationRange.start then
								(
									rootNodeTMP = undefined
									assetTMP = undefined
									parentNode = assetRootNode.controller.getNode i
									
									if parentNode != undefined then
										assetTMP = (lb.asset.getAssetsFromNodes #(parentNode))[1]
										
									if assetTMP != undefined then
										rootNodeTMP = lb.asset.getAssetRootNode assetTMP
									
									if rootNodeTMP != undefined then
									(
										assetRootNode = rootNodeTMP 
										assetParentName = rootNodeTMP.name
									)
								)
							)--if
						)
						else
						(
							--si no está por link constraint, comprobamos si está por point constraint

							if (classof assetRootNode.position.controller == position_list) and (classof assetRootNode.rotation.controller == rotation_list) then
							(
								_pcController = undefined
								_ocController = undefined

								--busca los controladores de point constraint
								for i=1 to assetRootNode.position.controller.count where (tolower assetRootNode.position.controller[i].name) == "pc_pointconstraint" do _pcController = assetRootNode.position.controller[i]
								for i=1 to assetRootNode.rotation.controller.count where (tolower assetRootNode.rotation.controller[i].name) == "oc_pointconstraint" do _ocController = assetRootNode.rotation.controller[i]

								--si tiene point constraint recorre los targets y los almacena para ver a que assets pertenecen (solo recorre el _pcController ya que los targets son los mismos que _ocController)
								if _pcController != undefined and _ocController != undefined then
								(
									_pcData = lb.links.pointConstraint.getPointData assetRootNode
									
									--print assetRootNode
									--print _pcData.pointLinks.count

									_lastFrameCandidate = -1000000
									for i=1 to _pcData.pointLinks.count do
									(
										frameNo = _pcData.pointLinks[i][1]

										if frameNo > _lastFrameCandidate and frameNo <= animationRange.start and _pcData.pointLinks[i][2] != "World" then
										(
											_lastFrameCandidate = frameNo

											rootNodeTMP = undefined
											assetTMP = undefined
											parentNode = getNodeByName _pcData.pointLinks[i][2]
											
											if parentNode != undefined then
												assetTMP = (lb.asset.getAssetsFromNodes #(parentNode))[1]
												
											if assetTMP != undefined then
												rootNodeTMP = lb.asset.getAssetRootNode assetTMP
											
											if rootNodeTMP != undefined then
											(
												--print assetRootNode

												assetRootNode = rootNodeTMP 
												assetParentName = rootNodeTMP.name
												
												--print assetRootNode
												--print _pcData.pointLinks[i][2]
												--print "-----------------------------"
											)
										)--if
									)--for
								)--if			
							)--for
						)--if else
					)--if
				)
				
				--print "llega7"
				
				if assetRootNode != undefined then 
					append assetsRootTransforms (at time animationRange.start assetRootNode.transform)
				else
					append assetsRootTransforms (matrix3 1)
				
				--print "llega8"
				
				append assetsParentsNames assetParentName
				
				--print "llega9"
				
				--print "---------------------------------"
			)
			
			----------------------------------------------------------------------------------------
			--		GRABACIÓN DE CACHÉS
			----------------------------------------------------------------------------------------
			--	Para cada pieza de tipo mesh se graba su cache en la carpeta source a través 
			--	del modificador transform_cache o point_cache, el cual se añade y se quita de 
			--	forma automática. No se deja puesto porque puede que solo queramos grabar 
			--	los cachés, pero no convertir la escena.
			
			--	Si ya existían piezas de tipo cache, se dejan tal cual y se redirigen sus
			--	ficheros de cache a la carpeta Source
			----------------------------------------------------------------------------------------
			
			--desactiva los cloth de la escena pero antes almacena el estado
			_states = #() --array de estados de los cloth
			if disableCloth then
			(
				_states = this.disableClothModifierFromObjects (objects as array)
			)
			
			--	si está indicado, grabamos todos los cachés de todas las escenas.
			if processCaches then
			(
				makeDir sourceFolder
				
				--	borramos todos los ficheros de la carpeta sourceFolder si se ha indicado así
				oldFiles = getFiles (sourceFolder + "*.*")
				
				for f in oldFiles do
				(
					if lb.str.endswith f ".mat" do continue --evitamos borrar el archivo de material
					setFileAttribute f #readOnly false
					if deleteOldCacheFiles then deleteFile f
				)
				
				--	Grabamos el cache de cada cámara y sus targets
				for c in cameras do
				(
					this.recordCacheFromObject c sourceFolder animationRange.start animationRange.end pcFormat:pcFormat
				)

				completeredraw()

				--	grabamos el cache de cada objeto mesh
				for i = 1 to meshObjsByAsset.count do
				(
					for o in meshObjsByAsset[i] do
					(
						_cacheType = (filterString o.name "_")[6]
						_createCache = (_cacheType != lb.nc.NC_icCache) and (_cacheType != lb.nc.NC_ncCache)
						
						-- Grabación del caché
						if _createCache then
						(
							animRange = assetsAnimRanges[i]	--	Sólo guardamos el rango de anim
							--Para alembic renombramos primero
							if pcFormat == ".abc" then
							(
-- 								print ("BEFORE: " + o.name) 
								if (lb.nc.removeFlag o "f") then _hasFrozenFlag = true else _hasFrozenFlag = false
								if (lb.nc.removeFlag o "h") then _hasHiddenFlag = true else _hasHiddenFlag = false
								lb.nc.addFlag o lb.nc.NC_cacheFlag
-- 								print ("AFTER: " + o.name)
							)
							--???? dos veces ????
							if findItem meshForceTC o != 0 then
								this.recordCacheFromObject o sourceFolder animRange.start animRange.end pcFormat:pcFormat forceTC:true ignoreTransforms:true
							
							this.recordCacheFromObject o sourceFolder animRange.start animRange.end pcFormat:pcFormat
							
							--Y luego dejamos el nombre como antes por si acaso.
							if pcFormat == ".abc" then
							(
								lb.nc.removeFlag o lb.nc.NC_cacheFlag
								if _hasFrozenFlag then lb.nc.addFlag o "f"
								if _hasHiddenFlag then lb.nc.addFlag o "h"								
							)
							
							--Si tiene pelo, generamos su caché
							if lb.hair.hasHairGenerator o do
							(
								lb.hair.exportHairSimulation o sourceFolder
							)
						)
						
						setWaitCursor()
					)
				)
				
				-- ???? supongo que esto será para sacar cachés a piezas que ya tenían cachés ????
				--	a las piezas de cache que ya existían las redirigimos los ficheros de 
				--	cache a la carpeta source haciendo una copia de sus ficheros .mc y .tc
				if(pcFormat != ".abc") then
				(
					for o in cacheAssetNodes where not isDeleted o do
					(
						if this.getCacheTypeFromName o != lb.nc.NC_nonSpecifiedCache then
						(
							m = (this.getCacheMods o)[1]
							
							if m != undefined and doesFileExist m.filename then
							(
								newFileName = sourceFolder + (getFileNameFile m.filename) + (getFileNameType m.filename)
								
								-- ???? se supone que llegados a este punto no debería haber piezas con el mismo nombre ????
								--	evitamos que piezas con nombres duplicados lean del mismo fichero. Creamos un nombre nuevo si el que intentamos usar ya existe.
								i = 0
								alternativeFileName = newFileName
								while (doesFileExist alternativeFileName) do
								(
									alternativeFileName = (getFileNamePath newFileName) + (getFileNameFile newFileName)+ (formattedprint i format:"03d") + (getFileNameType newFileName)
									i += 1
								)
								
								newFileName = alternativeFileName					
								
								--	hacemos una copia del fichero de cache a la nueva ruta. En el caso de point caches copiamos también el .mc
								copyfile m.filename newFileName
								
								if classOf m == point_cache or classOf m == point_cacheSpacewarpModifier then
								(
									mcFileName = (getFileNamePath m.filename) + (getFileNameFile m.filename) + ".mc"
									newMcFileName = (getFileNamePath newFileName) + (getFileNameFile newFileName) + ".mc"
									
									copyFile mcFileName newMcFileName
								)
								
								oldPlaybackType 	= m.playbackType
								oldPlaybackStart 	= m.playbackStart
								oldPlaybackEnd 	= m.playbackEnd
								
								m.filename = newFileName
								
								m.playbackType 	= oldPlaybackType
								m.playbackStart 	= oldPlaybackStart
								m.playbackEnd 	= oldPlaybackEnd
							)
						)
						
						setWaitCursor()
					)
				)
				
				--despues de sacar los caches, debe poner a todas las mallas que tienen visibility animado, un controlador bezier_float a 1.0
				for o in meshForceTC do
				(
					if o[1].controller != undefined then
					(
						o[1].controller = bezier_float()
						o[1].controller.value = 1.0
					)
					else
					(
						o.visibility = bezier_Float()
						o[1].controller.value = 1.0
					)
				)
			)
			
			--restarua el estado original de los cloth
			-- 		if disableCloth then
			-- 		(
			-- 			this.restoreClothModifierStateFromObjects (objects as array) _states
			-- 		)
			
			gc()
			
			----------------------------------------------------------------------------------------
			--		LIMPIEZA DE ESCENA: BORRADO DE PIEZAS Y MODIFICADORES
			--		INÚTILES Y DE ASSETS DE TIPO SET.
			----------------------------------------------------------------------------------------
			--	En las escenas de tipo cache solo valen las piezas de tipo mesh. Las demás
			--	ya no sirven, así que se eliminan. Lo mismo sucede con todos los modificadores
			-- 	de deformación (skin, skin morph, ffd, etc). Ninguno sirve aquí, así que también
			--	se eliminan.
			
			--	En cuanto a los assets de tipo set, no son necesarios porque se añaden 
			--	después en el proceso de lighting, así que también se borran.
			----------------------------------------------------------------------------------------
			
			if processAssets then
			(
				--	Con los assets de tipo set no hay que hacer nada. Los excluimos de las operaciones.
				assetsTMP = lb.asset.getSceneAssets()
				assets = for a in assetsTMP where a.type != lb.nc.NC_setPrefix collect a
				lockedtracksman.unLockOverride = true 			
				
				--	eliminamos todos los modificadores que no es necesario guardar y colapsamos
				--	los que hagan falta con la geometría
				for o in meshObjs do
				(
					modsToDelete = #()
					modsToKeep = #()
					modsToCollapse = #()
					
					-- eliminamos obligatoriamente los proxies
					lb.proxy.removeProxy o
					
					for m in o.modifiers do
					(
						c = classof m
						
						if (findItem this.modifiersToCollapseInCache c != 0) then
							append modsToCollapse m
						else if (findItem this.modifiersToKeepInCache c != 0) or (findItem (lb.nc.getModifierFlags m) lb.nc.NC_pointCacheModifierFlag != 0) then
							append modsToKeep (copy m)
						else 
							append modsToDelete m
					)
					
					--	borrado de modificadores
					for m in modsToDelete do
						deleteModifier o m
					
				)
				
				--	borramos todas las piezas que no son de tipo mesh o cache de cada asset
				assetsObjectsToDelete = #()
				
				for a in assets do join assetsObjects (lb.asset.getAssetNodes a)
				for o in assetsObjects do
					if (finditem meshObjs o == 0) and (finditem cacheAssetNodes o == 0) do appendIfUnique assetsObjectsToDelete o
				
				for i=assetsObjectsToDelete.count to 1 by -1 where not isValidNode assetsObjectsToDelete[i] do deleteItem assetsObjectsToDelete i
				
				assetsObjectsToDelete = makeUniqueArray assetsObjectsToDelete
				
				--delete assetsObjectsToDelete
				_cont = 1
				while _cont < 10 and assetsObjectsToDelete.count != 0 do
				(
					try delete assetsObjectsToDelete
					catch for i=assetsObjectsToDelete.count to 1 by -1 where not isValidNode assetsObjectsToDelete[i] do deleteItem assetsObjectsToDelete i
					_cont +=1
				)--while
				
				gc()
				
				--Antes de borrar auxobj ponemos como activa la capa 0 para poder hacerlo.
				(LayerManager.getLayerFromName "0").current = true
			   
				-- borramos todas las piezas de la capa de objetos auxiliares _auxObj_
				if (layermanager.getLayerFromName lb.nc.NC_layerAuxObj) != undefined then
				(
					(layermanager.getLayerFromName lb.nc.NC_layerAuxObj).nodes &auxNodes
					
					--elimina los objetos que no sean validos de auxNodes
					--elimina del array el objeto corrupto que provoca el Error Loading
					auxNodes = for o in auxNodes where (isValidNode o) and not (o.name == "" and classof o == Dummy) collect o
					
					delete auxNodes
					layerManager.deleteLayerByName lb.nc.NC_layerAuxObj
				)
				
				--	añadimos los modificadores de cache a cada pieza.
				--	Si hay piezas de tipo TC nos aseguramos de que tiene bien los controladores de animación.
				-- ???? Esto no tiene sentido para alembic.????
				if pcFormat != ".abc" then
				(
					for o in meshObjs do
					(
						--para saber si deben llevar cache o no
						_cacheType = (filterString o.name "_")[6]
						_addCacheMod = (_cacheType != lb.nc.NC_icCache) and (_cacheType != lb.nc.NC_ncCache)
						
						if _addCacheMod then
						(
							this.addCacheModByName o sceneType:#cache 
							
							if findItem meshForceTC o != 0 then this.addCacheModByName o sceneType:#cache forceTC:true
						)
					)
				)
				setWaitCursor()
				
				--	lincamos todas las piezas a un point que está en el centro del mundo y éste a
				--	una pieza base. Después llevamos todas las piezas a su posición original
				for i = 1 to meshObjsByAsset.count where meshObjsByAsset[i].count > 0 do
				(
					--	iniciamos las propiedades de la base de rig
					assetName = filterstring meshObjsByAsset[i][1].name "_"
					assetBaseName = assetName[1] + "_" + assetName[2] + "_" + lb.nc.NC_classAnim + "_x_base_x_c"
					
					--	calculamos el tamaño de la pieza base y la creamos. Si depende de 
					--	algún otro asset lo lincamos a su base.
					assetBaseSize = 35
					for j = 1 to i where assetsParentsNames[i] != undefined do 
						if assetsParentsNames[i] == assetsParentsNames[j] then assetBaseSize -= 5
					
					assetBase = Ngon radius:assetBaseSize cornerRadius:0 nsides:3 name:assetBaseName
					assetBase.showFrozenInGray = false
					assetBase.renderable = false
					
					selSetName = assetName[1] + "_" + assetName[2] + "_" + lb.nc.NC_classAnim + "_x_base"
					selectionSets[selSetName] = #(assetBase)
					
					--	creamos el point al que irá lincado todo
					assetRigPoint = point box:true isHidden:true 
					assetRigPoint.name = (substituteString assetBaseName "_base_x_c" "_basePoint_x_h")
					
					--	colocamos las nuevas piezas en su capa y les asignamos un color según el tipo de asset
					meshObjsByAsset[i][1].layer.addNode assetBase
					meshObjsByAsset[i][1].layer.addNode assetRigPoint
					assetType = (filterstring assetBase.name "_")[1]
					case assetType of
					(
						(lb.nc.NC_chrPrefix): assetBase.wirecolor = assetRigPoint.wirecolor = [0,255,0]
						(lb.nc.NC_prpPrefix): assetBase.wirecolor = assetRigPoint.wirecolor = [0,0,255]
						(lb.nc.NC_sprPrefix): assetBase.wirecolor = assetRigPoint.wirecolor = [255,0,255]
					)
					
					--	rotamos la pieza para que apunte hacia el frente y la reseteamos
					assetBase.rotation = eulerangles 0 0 90
					resetXform assetBase
					collapseStack assetBase
					
					--	colocamos la pieza en la base del asset
					assetBase.transform = assetsRootTransforms[i]
					assetBase.scale = [1,1,1] --se pone la escala de los controles a 1, para evitar escalados accidentales.
					
					--	preparamos el point padre y la pieza base. Si el asset es
					--	hijo de otro lincamos su base a la del asset padre
					assetRigPoint.parent = assetBase
					if assetsParentsNames[i] != undefined then 
					(
						assetParentName = filterstring assetsParentsNames[i] "_"
						baseParent = (execute ("$'" + assetParentName[1] + "_" + assetParentName[2] + "_" + lb.nc.NC_classAnim + "*_base_*"))[1]
						if baseParent != undefined then assetBase.parent = baseParent
					)
					lb.controller.freezeTransform assetRigPoint #all
					lb.controller.freezeTransform assetBase #all 
					
					gc()
					
					--	creamos los animTracks de las piezas de rig
					tracks = #(	\
					#(#separator, "Separator01", false, "Transforms"),	\
					#(assetBase[#transform][#position][#Zero_Pos_XYZ][#x_position], "transform:position:Zero_Pos_XYZ:x_position", true, undefined, 0.0),	\
					#(assetBase[#transform][#position][#Zero_Pos_XYZ][#y_position], "transform:position:Zero_Pos_XYZ:y_position", true, undefined, 0.0),	\
					#(assetBase[#transform][#position][#Zero_Pos_XYZ][#z_position], "transform:position:Zero_Pos_XYZ:z_position", true, undefined, 0.0),	\
					#(#separator, "Separator02", false),	\
					#(assetBase[#transform][#rotation][#Zero_Euler_XYZ][#x_rotation], "transform:rotation:Zero_Euler_XYZ:x_rotation", true, undefined, 0.0),	\
					#(assetBase[#transform][#rotation][#Zero_Euler_XYZ][#y_rotation], "transform:rotation:Zero_Euler_XYZ:y_rotation", true, undefined, 0.0),	\
					#(assetBase[#transform][#rotation][#Zero_Euler_XYZ][#z_rotation], "transform:rotation:Zero_Euler_XYZ:z_rotation", true, undefined, 0.0),	\
					#(#separator, "Separator03", false),	\
					#(assetBase[#transform][#scale], "transform:scale", true, undefined, 100.0))
					
					lb.animInfo.setAnimTracks assetBase tracks
					
					--	Emparentamos y reiniciamos transformaciones de las piezas de mesh.
					for o in meshObjsByAsset[i] do
					(
						--para saber si deben llevar cache o no
						_cacheType = (filterString o.name "_")[6]
						_reemparent = (_cacheType != lb.nc.NC_ncCache) --and (_cacheType != lb.nc.NC_icCache)
						
						if _reemparent then
						(
							if (classof o != XRef_Controller) then lb.controller.unFreezeTransform o #all
							
							_newParent = assetRigPoint
							
							if (_cacheType == lb.nc.NC_icCache) and hasattribute o #virtualNodes and o.custAttributes[#virtualNodes].vParentNode != undefined then
								if isValidNode o.custAttributes[#virtualNodes].vParentNode.node then
									_newParent = o.custAttributes[#virtualNodes].vParentNode.node
								
							o.parent = _newParent
							
							if _newParent == assetRigPoint then
							(
								o.position = [0,0,0]
								o.rotation = quat 1
								o.scale = [1,1,1]
								o.controller = prs()
							)--if
							
							--	Eliminamos los flags FH de los mesh y añadimos el de cache
							lb.nc.removeFlag o "f"
							lb.nc.removeFlag o "h"
							lb.nc.addFlag o lb.nc.NC_cacheFlag
							
 							--if pcFormat == ".abc" then
 							--(
 							--	--Nombre del alembic que vamos a importar
 							--	_importJob = "filename=" + sourceFolder + o.name + ".abc;"
 							--	--Si vamos a traer normales
 							--	_importJob += "normals=false;"
 							--	--UVs tampoco traemos;
 							--	_importJob += "UVs=false;"
 							--	--Ids de materiales tampoco
 							--	_importJob += "materialIDs=false;"
 							--	--Ponemos que se aplique a los objetos que toquen
 							--	_importJob += "attach=true;"
 							--	--Cargar la geometría en modificador de topología
 							--	_importJob += "loadGeometryInTopologyModifier=false;"
 							--	--Cargamos el control de tiempo? nor
 							--	_importJob += "loadTimeControl=false;"
 							--	--Cargamos las curvas como nurbs? nein
 							--	_importJob += "loadCurvesAsNURBS=false;"
 							--	--Cargamos el meshsmooth en objetos, niet!
 							--	_importJob += "meshSmoothModifiers=false;"
 								
 							--	--Si cargamos objetos duplicados, como queremos que se muestren (nos da un poco igual)
 							--	--_importJob += "objectDuplication=false;"
 							--	--Filtros de nombres para aplicar a múltiples objetos
 							--	--_importJob += "filters=;"
 								
 							--	--Include children, no porque cada objeto se importa y exporta individualmente
 							--	_importJob += "includeChildren=false;"
 							--	--Fallar si hay un objeto no está soportado por alembic, parámetro de debug, debería estar desactivado.
 							--	_importJob += "failOnUnsupported=false;"
 							--	print _importJob
 							--	ExocortexAlembic.createImportJob(_importJob)
 							--)
							
-- 							if (classof o.controller != XRef_Controller) then lb.controller.freezeTransform o #all

						)
					)
				)

				----------------------------------------------------------------------------------
				--elimina los points de point constraint y su capa

				_pcLayer = lb.layer.getLayerbyName "_auxObj-pointConstraint_"
				if _pcLayer != undefined then
				(
					_pcNodes = lb.layer.getLayerNodes _pcLayer
					if _pcNodes.count != 0 then delete _pcNodes
					_zeroLayer = lb.layer.getLayerbyName "0"
					_zeroLayer.current = true
					lb.layer.deleteLayerByName "_auxObj-pointConstraint_"
				)--if

				----------------------------------------------------------------------------------
				
				----------------------------------------------------------------------------------
				--hace un lb.controller.freezePose en todos los objetos de mesh de cada asset
				sliderTimeBckp = sliderTime
				sliderTime = animationRange.start
				
				for a in assets where a.type != lb.nc.NC_setPrefix do --reocrre los assets
					for o in (a.meshNodesAll + a.hairNodesAll) do --recorre los objetos de mesh
						lb.controller.freezePose o #all --hace un lb.controller.freezePose a cada objeto
					
				sliderTime = sliderTimeBckp
				----------------------------------------------------------------------------------	
				
				setArrowCursor()
				
			)	-- processAssets
			
			gc()
			
			
			----------------------------------------------------------------------------------------
			--		LIMPIEZA DE ESCENA: BORRADO DE PIEZAS Y MODIFICADORES
			--		INÚTILES Y DE ASSETS DE TIPO SET.
			----------------------------------------------------------------------------------------
			--	Cargamos en cada pieza de tipo mesh el fichero de cachés que le corresponda
			--	a través del modificador transform_cache o point_cache, que se añade de 
			--	forma automática.
			----------------------------------------------------------------------------------------
			print ("processCaches: " + (processCaches As String))
			print ("processAssets: " + (processAssets As String))
			--	Cargamos los ficheros de cache en las piezas mesh
			if processCaches and processAssets then
			(
				--	Primero cargamos los caches de las cámaras
				for c in cameras do
				(
					print "loadCaches de cámaras"
					_hasTC = false
					for m in c.modifiers where classOf m == Transform_Cache do _hasTC = true
					
					if not _hasTC then lb.modifiers.insertModifier c (transform_cache())

					cacheFile = sourceFolder + (lb.nc.getSimpleObjectName c.name)
					this.loadCache c cacheFile
				)
				_errorMessageCache = ""
				--	Ahora cargamos el cache de todos los objetos
				for o in meshObjs do
				(
					
					--para saber si deben llevar cache o no
					_cacheType = (filterString o.name "_")[6]
					_loadCache = (_cacheType != lb.nc.NC_icCache) and (_cacheType != lb.nc.NC_ncCache)
					
					if _loadCache then
					(
						print "loadCaches de objetos"
						if pcFormat == ".abc" then
							cacheFile = sourceFolder + o.name + ".abc"
						else
							cacheFile = sourceFolder + (lb.nc.getSimpleObjectName o.name)
						
						print cacheFile
						_errorMessageCache += this.loadCache o cacheFile
					)
				)--for
				if _errorMessageCache != "" do lb.message.show _errorMessageCache 

				sliderTime = animationRange.start
				for o in meshObjs do lb.controller.freezePose o #all --hace freeze pose de los objetos de mesh

				_assets = lb.asset.getSceneAssets() --recopila de nuevo los assets
				for _asset in _assets do
				(
					lb.asset.setAssetSkinBoxMode _asset --pone el modo skin+box al asset
					_asset.connectNodesAll.ishidden = true --deja los connect points ocultos
					_asset.connectNodesAll.isfrozen = false --dela los connect points descongelados
				)
				
				-- actualizamos el rango de fotogramas de la escena
			-- 		if meshObjs.count > 0 then
			-- 		(
			-- 			m = (this.getCacheMods meshObjs[1])[1]
			-- 			if m != undefined then
			-- 				animationRange = interval m.recordStart m.recordEnd
			-- 		)
			)
			
			lockedtracksman.unLockOverride = false
			
			gc()
		),

		------------------------------------------------
		--@fn: array | disableClothModifierFromObjects | Desactiva los cloth de los objetos pasados por parametro
		--@gets: array | nodes | Array que contiene los nodos a los que deshabilitar el cloth
		--@returns: array | _states | array de booleanos que contiene los estados de los cloth de los objetos antes de la desactivación
		------------------------------------------------
		fn disableClothModifierFromObjects nodes =
		(
			_states = #() --array para los estados de los cloth de los objetos
			
			for n in nodes do --recorre los nodos
			(
				--indican si el objeto tiene cloth y el estado de este
				_hasCloth = false
				_enabled = false
				_enabledViews = false
				_enabledInRenders = falseç
				
				_state = #() --un objeto puede tener varios cloths, en cuyo caso habrá que almacenar varios estados
				
				for m in n.modifiers where classof m == Cloth do --recorre los cloth del objeto
				(
					_hasCloth = true --si que tiene cloth
					_enabled = if m.enabled then #enabled else #disabled --indica si esta activo
					_enabledViews = if m.enabledInViews then #enabledInViews else #disabledInViews --indica si esta activo en viewport
					_enabledInRenders = if m.enabledInRenders then #enabledInRenders else #disabledInRenders --indica si esta activo en viewport
						
					append _state #(_enabled, _enabledViews, _enabledInRenders) --añade los estados
					
					--desactiva el cloth
					m.enabled = false
					m.enabledInViews = false
				)
				
				if not _hasCloth then _state = undefined --si no tiene cloth no guarda estados
					
				append _states _state --almacena en el array de estados, los estados de ese objeto con cloth
			)
			
			_states
		),
		
		------------------------------------------------
		--@fn: undefined | disableClothModifierFromObjects | Restaura los estados de los cloth de los objetos pasados por parametro, en función de una array de estados.
		--@gets: array | nodes | Array que contiene los nodos a los que deshabilitar el cloth
		--@gets: array | states |  array de booleanos que contiene los estados de los cloth para su restauración.
		------------------------------------------------		
		fn restoreClothModifierStateFromObjects nodes states =
		(
			for i=1 to nodes.count where states[i] != undefined do --recorre los nodos restaurando el estado de sus cloth
			(
				cont = 1 --contador de cloths
				for m in nodes[i].modifiers where classof m == Cloth do --recorre los cloth del objeto
				(
					m.enabled = if states[i][cont][1] == #enabled then true else false --restaura el estado
					m.enabledInViews = if states[i][cont][2] == #enabledInViews then true else false --restaura el estado
					m.enabledInRenders = if states[i][cont][3] == #enabledInRenders then true else false --restaura el estado
						
					cont += 1 --aumenta el contador
				)
			)
		),

		------------------------------------------------
		--@fn: undefined | remoteBatchCacheExport | Realiza un exportado remoto de los cachés.
		--@gets: (opt)string | cachesFolder | Path al directorio donde se debe realizar la exportación. Por defecto undefined.
		--@gets: (opt)boolean | saveNewMaxFile |  Si vale True se guardará el fichero de max después de realizar el export. Por defecto true
		--@gets: (opt)boolean | enableCloth | Si vale true se habilitará el cloth en la secuencia. Por defecto false
		--@gets: (opt)boolean | processAssets | Si vale True indica que hay que convertir los assets a caches. Por defecto true
		--@gets: (opt)boolean | processCachesOnly | Si vale True, no se va a guardar un nuevo .max pero sí se van a tratar los caches. Por defecto true
		--@gets: (opt)boolean | convertToPC2 | Si vale true el formato de salida sera ".pc2", para False se guardará como xml. Por defecto true 
		--@gets: (opt)boolean | deleteOld | Si vale true se borraran los ficheros de caché viejos antes de realizar el guardado. Por defecto false
		--@gets: (opt)boolean | mergeXRefs | Si vale true se romperan los Xrefs mergeando las referencias en escena. Por defecto false
		------------------------------------------------			
		fn remoteBatchCacheExport cachesFolder:undefined saveNewMaxFile:true enableCloth:false processAssets:true processCachesOnly:true convertToPC2:true deleteOld:false mergeXRefs:false =
		(
				local meshObjs = #()						--	Todas las piezas de tipo mesh de todos los assets
				local _cacheFileName 	= undefined	--	Fichero de caches donde se almacena el resultado
				local _cachesFolder		= cachesFolder	--	Carpeta donde se almacenarán los ficheros de point cache
				local continueProcess = true				--	Indica si se puede realizar o no la conversión
				
					-- 			if (queryBox "Assets will be set to (CONNECT ALL) mode and Turbosmooths will be disabled in viewports. Do you want to continue?") 		then
					-- 			(
					disableSceneRedraw()
					suspendEditing()
					setWaitCursor()
					
					--	apagamos Turbosmooths y colocamos cada asset en el modo de visualizacion skin+box
					assetsToProcess = lb.asset.getSceneAssets()
					
					for a in assetsToProcess do
					(
						--Si el asset no está en modo CONNECTALL se lo activamos.
						_modeToBe = "CA" 
							
						if lb.asset.getAssetVisMode a != _modeToBe then
							lb.asset.setAssetConnectAllMode a enableCloth:enableCloth
						
						--	desactivamos los turbosmooth de las piezas mesh
						for o in (a.meshNodesAll + a.hairNodesAll) do lb.modifiers.setTurbosmoothState o #disabledInViews
					)
					
					resumeEditing()
					enableSceneRedraw()
					completeRedraw()
				
					--	si se va a guardar un nuevo fichero .max, pedimo un nombre para él y asumimos que, si
					--	se van a grabar también los ficheros de datos de caché, irán a parar a la misma ruta
					--	que el fichero .max pero dentro de una carpeta \source
					
					if findString maxFileName "_anim" != undefined then
						_newName = (substituteString maxFileName "_anim" "_cache")
					else if findString maxFileName "_cloth" != undefined then
						_newName = (substituteString maxFileName "_cloth" "_cache")
					else if findString maxFileName "_fx" != undefined then
						_newName = (substituteString maxFileName "_fx" "_cache")
					else if findString maxFileName "_hair" != undefined then
						_newName = (substituteString maxFileName "_hair" "_cache")
					else if findString maxFileName "_cache" != undefined then
						_newName = (substituteString maxFileName "_cache" "_cache")
					else
						_newName = maxFileName
					
					
					if _cachesFolder == undefined then
					(
						--Por defecto pondremos la carpeta en la que esta el archivo que hemos mandao
						_currentPath = maxfilepath + _newName + "\\"
						_cacheFileName = _currentPath + _newName
						_cachesFolder = (getFileNamePath _cacheFileName) 
					)
					else
					(
						_cacheFileName = _cachesFolder + _newName
					)
					
					if _cachesFolder == undefined then
						_cachesFolder = (getFileNamePath _cacheFileName) 
					
					_cachesSourceFolder = _cachesFolder + "source\\" 
					
					makeDir _cachesSourceFolder all:true
					
					--	Si no se va a guardar un nuevo .max pero sí se van a tratar los caches pedimos una ruta
					--	donde almacenar los ficheros de datos de cache.
				-- 				else if processCachesOnly then
				-- 				(
				-- 					_cachesFolder = getSavePath caption:"Select Caches SOURCE Folder" initialDir:maxFilePath
				-- 					_cachesFolder = _cachesFolder
				-- 					
				-- 					--  Si no se especifica una ruta de salida no se puede continuar
				-- 					if _cachesFolder == undefined then continueProcess = false
				-- 				)
								
				-- 				--	si no existían ficheros de cache en la carpeta SOURCE comprobamos que 
				-- 				--	el formato de exportación elegido sea PC2, que es más óptimo.
				-- 				if _cachesFolder != undefined and (getFiles (_cachesFolder + "*.*")).count == 0 and _fileType != ".pc2" then
				-- 					if (queryBox "No previous cache files in SOURCE folder. Cache format should be PC2.\nDo you want to change to PC2 format?") 	then
				-- 							ddlCacheFormat.selection = 1
								
				-- 				if _cachesFolder != undefined and (getFiles (_cachesFolder + "*.*")).count > 0 then
				-- 				(
				-- 					_oldCacheFiles = (getFiles (_cachesFolder + "*.*"))
				-- 					_oldCacheFilesType = undefined
				-- 					
				-- 					--	revisamos el formato de los ficheros de cache que pudieran existir anteriormente
				-- 					for f in _oldCacheFiles where _oldCacheFilesType == undefined do
				-- 					(
				-- 						_fileType = (toLower (getFileNameType f))
				-- 						
				-- 						if _fileType == ".xml" then
				-- 							_oldCacheFilesType = _fileType
				-- 						else if _fileType == ".pc2" then
				-- 							_oldCacheFilesType = _fileType
				-- 					)
				-- 					 
				-- 					--	Si existían ficheros miramos si el formato que vamos a crear es el mismo que ya existía
				-- 					--	Si no coinciden lanzamos un Warning
				-- 					_showFormatWarning = false
				-- 					
				-- 					if _oldCacheFilesType != undefined then
				-- 						_showFormatWarning = 	((_oldCacheFilesType == ".xml" and convertToPC2 /*ddlCacheFormat.selected == ".pc2"*/) or \
				-- 															(_oldCacheFilesType == ".pc2" and not convertToPC2 /*ddlCacheFormat.selected == ".	xml"*/))
				-- 					
				-- 					if _showFormatWarning then
				-- 					(
				-- 						messageBox ("Destination SOURCE folder contains " + (toUpper _oldCacheFilesType) + " files and you selected to export " 	+ (		toUpper ddlCacheFormat.selected) + " cache files. Can't continue.")
				-- 						continueProcess = false
				-- 					)
				-- 					
									--	Si la carpeta SOURCE no está vacía pedimos confirmación de borrado o sobreescritura de los ficheros.
				-- 					if continueProcess then
				-- 					(
				-- 						if deleteOld then
				-- 						(
				-- 							if not queryBox "Destination SOURCE folder to save caches is not empty. Files will be deleted. Do you want to 	continue?" 		then continueProcess = false
				-- 						)
				-- 						else
				-- 						(
				-- 							if not queryBox "Destination SOURCE folder to save caches is not empty. Files will be overwriten. Do you want to 	continue?" 		then continueProcess = false
				-- 						)
				-- 					)
				-- 				)
									
								--	Si todos los pasos han sido correctos realizamos la conversión
				-- 				if continueProcess then
				-- 				(
									--	si solo vamos a convertir ciertos assets, el resto los borramos.
				-- 					for a in sceneAssets where findItem assetsToProcess a == 0 do
				-- 						lb.asset.deleteAsset a includeDependents:false
						
						if convertToPC2 then _cacheFormat = ".pc2"
						else _cacheFormat =".xml"
						
						--	conversión de la escena a caches
						-- se ha añadido de parametro desactivar cloth, para que no saque los caches de los objetos con cloth como tick en el ui
						this.convertSceneToCaches processAssets processCachesOnly cachesFolder:_cachesSourceFolder pcFormat:_cacheFormat deleteOldCacheFiles:deleteOld mergeXrefs:mergeXRefs --disableCloth:enableCloth
						
						--	guardamos el nuevo fichero .max si se ha indicado
						if saveNewMaxFile then saveMaxFile  _cacheFileName 
							
				-- 				)
				-- 			)
				
				setArrowCursor()
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | getSelectionSets | Devuelve un array con structs con la información del nombre de cada selectionSet de la escena y un array de nombres de objetos que componen cada selectionSet
		--@returns: array | _selSets | Devuelve una array de arrays, con la siguiente cofiguracion: #( tipo de selectionSet name:#nombreSelectionSet objNames#(nodes))
		-----------------------------------------------------------------------------------------------------

		fn getSelectionSets =
		(
			_selSets = #()
			
			struct strSelSet
			(
				name,
				objNames = #()
			)
			
			for s in selectionSets do 
			(
				_objNames = #()
				
				for o in s do append _objNames o.name
				
				append _selSets (strSelSet name:(s.name as name) objNames:_objNames)
			)
			
			_selSets
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | restoreSelectionSets | reconstruye los selectionSets tal cual están 
		--@gets: array | selSets | array de selection sets que restaurar.
		-----------------------------------------------------------------------------------------------------		
		fn restoreSelectionSets selSets =
		(
			for s in selSets do
			(
				_objsToAdd = #()
				_selSetObjs = if selectionSets[s.name] != undefined then (for o in selectionSets[s.name] collect o) else #()
				
				--	primero vaciamos el selectionSet por si ya existía
				selectionSets[s.name] = #()
				
				--	buscamos en la escena por nombre las piezas que nos interesan.
				for n in s.objNames do
				(
					_obj = execute ("$'" + n + "'")
					if _obj != undefined then append _objsToAdd _obj
				)
				
				--	añadimos el nuevo contenido al selectionSet
				selectionSets[s.name] = (_selSetObjs + _objsToAdd)
			)
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | deleteLPMauxCA | elimina, si existe, el custom attribute de información extra del objeto pasado por parametros 
		--@gets: node | obj | Objeto del que eliminar el custom attribute.
		-----------------------------------------------------------------------------------------------------
		fn deleteLPMauxCA obj =
		(
			if lb.customAttributes.hasAttribute obj.baseobject #LPM_auxData then
				custAttributes.delete obj (custAttributes.getdef obj.baseobject.LPM_auxData) baseobject:true
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | deleteLightAuxCA | elimina, si existe, el custom attribute de información extra de luces del objeto pasad por parametros
		--@gets: node | obj | Objeto del que eliminar el custom attribute. 
		-----------------------------------------------------------------------------------------------------
		fn deleteLightAuxCA obj =
		(
			if lb.customAttributes.hasAttribute obj.baseobject #light_auxData then
				custAttributes.delete obj (custAttributes.getdef obj.baseobject.light_auxData) baseobject:true
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | addLPMauxCA | añade el atributo de información extra de LPM al objeto pasado por parámetros.
		--@gets: node | obj | Objeto al que añadir el custom attribute.
		-----------------------------------------------------------------------------------------------------
		fn addLPMauxCA obj =
		(
			lb.cache.deleteLPMauxCA obj
			
			custAttributes.add obj CA_LPMauxData #unique baseobject:true
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | addLPMauxData | Añade la información auxiliar necesaria en el nodo LPM del objeto pasado por parametros.
		--@gets: node | obj | Objeto al que añadir el custom attribute.
		-----------------------------------------------------------------------------------------------------
		fn addLPMauxData obj =
		(
			LPM_properties = getPropNames obj.baseobject.custattributes[1]
			
			--	eliminamos la información previa que pudiera tener para no duplicar el custAttribute
			lb.cache.removeLPMauxData obj
			
			for propName in LPM_properties do
			(
				propValue = (getProperty obj propName)
				
				--	Sólo se añade el custAttribute si existe la propiedad #nodes, que es lo que se pierde de una escena a otra.
				if propName == #nodes then
				(
					lb.cache.addLPMauxCA obj
					
					if isProperty obj #nodesNames then
					(
						--HAY QUE BUSCAR LOS NODOS QUE SE HAN BORRADO POR NOMBRE POR SI SE HAN VUELTO A METER EN LA ESCENA			
						--si la varaiable nodes está vacía o hay mas nodesnames que nodes, lo intenta recomponer.
						_limit = obj.nodes.count
						if obj.nodesNames.count > _limit then _limit = obj.nodesNames.count
							
						for i=1 to _limit do
						(
							if not isValidNode obj.nodes[i] and obj.nodesNames[i] != undefined and obj.nodesNames[i] != "" then
							(
								if findString obj.nodesNames[i] "\n" != undefined then obj.nodesNames[i] = substituteString obj.nodesNames[i] "\n" ""
								_tempNode = execute ("$'" + obj.nodesNames[i] +"'")
								if isValidNode _tempNode then obj.nodes[i] = _tempNode
							)
							else if isValidNode obj.nodes[i] then
							(
								if obj.nodes[i].name != obj.nodesNames[i] then
									obj.nodesNames[i] = obj.nodes[i].name
							)
						)--for	
					)--if
					
					for i = 1 to propValue.count where propValue[i] != undefined do 
						append obj.baseobject.custattributes[#LPM_auxData].nodeNames propValue[i].name
					
					obj.nodes = #()
					if isProperty obj #nodesNames then obj.nodesNames = #()
				)
				else if propName == #node then
				(
					lb.cache.addLPMauxCA obj
					
					obj.baseobject.custattributes[#LPM_auxData].nodeNames[1] = #(obj.node.name)
					obj.node = undefined
				)
			)
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | addLightAuxCA | añade el atributo de información extra de LPM al objeto pasado por parametros.
		--@gets: node | obj | Objeto al que añadir el custom attribute.
		-----------------------------------------------------------------------------------------------------
		fn addLightAuxCA obj =
		(
			lb.cache.deleteLightAuxCA obj
			
			custAttributes.add obj CA_light_auxData #unique baseobject:true
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: array | getLPMobjects | Obtiene los objetos que se usan en el LPM
		--@returns: node | LPMobjs | Array de nodos con los objetos.
		-----------------------------------------------------------------------------------------------------
		fn getLPMobjects =
		(
			LPMobjs = #()
			
			LPMlayer = (layerManager.getLayerFromName "zz-LPM")
			if LPMlayer != undefined then LPMlayer.nodes &LPMobjs
			
			LPMobjs
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | removeLPMauxData | Elimina la información auxiliar del nodo LPM pasado en el objeto pasado por parámetro
		--@gets: node | obj | Objeto al que eliminar el custom attribute.
		-----------------------------------------------------------------------------------------------------
		fn removeLPMauxData obj =
		(
			lb.cache.deleteLPMauxCA obj
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | removeLightauxData | Elimina la información auxiliar de las luces del objeto pasado por parametros 
		--@gets: node | obj | Objeto al que eliminar el custom attribute.
		-----------------------------------------------------------------------------------------------------
		fn removeLightauxData obj =
		(
			lb.cache.deleteLightAuxCA obj
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | restoreLPMnodes | Restaura la propiedad Node o Nodes del objeto LPM pasado en el parámetro OBJ. Esta función es necesaria porque la propiedad Node y Nodes se queda vacía al exportar los datos de LPM. Se consigue restaurar mediante el custom attribute LPM_auxData que se añade en el proceso de exportación en cada nodo LPM. Devuelve TRUE o FALSE indicando si ha conseguido restaurar los nodos.
		--@gets: node | obj | El objeto a restaurar.
		-----------------------------------------------------------------------------------------------------
		fn restoreLPMnodes obj =
		(
			if isProperty obj #nodeNames then
			(
				LPM_properties = getPropNames obj.baseobject.custattributes[1]
				
				for propName in LPM_properties do
				(
					propValue = (getProperty obj propName)
					
					
					if propName == #nodes then
					(
						obj.nodes = #()
						
						for n in obj.nodeNames do 
						(
							scnObj = execute ("$'" + n + "'")
							
							if scnObj != undefined then 
								append obj.nodes scnObj
						)
						
						if isProperty obj #nodesNames then
						(
							obj.nodesNames = #()
							for i=1 to obj.nodes.count do
								obj.nodesNames[i] = obj.nodes[i].name
						)
					)
					else if propName == #node then
					(
						obj.node = undefined
						scnObj = execute ("$'" + o.baseobject.custattributes[#LPM_auxData].nodeNames[1] + "'")
						if scnObj != undefined then 
							obj.node = scnObj
					)
				)
				
				true
			)
			else
				false
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | cameraCacheExport | exporta el cache de las camaras presentes en la escena
		-----------------------------------------------------------------------------------------------------				
		fn cameraCacheExport =
		(
			_cameraExported = false

			_archive = maxfilename
			_parts= filterstring _archive "_"

			for c in objects where ((classof c == freecamera) or (classof c == targetcamera)) and (_parts[3]  == (substituteString c.name "_" "")) do
			(
				_newMod = transform_cache()
				lb.modifiers.insertModifier c _newMod
				_newMod.newCacheFile()
				_newMod.rollTC.btnRecord.pressed()

				_cameraExported = true
			)--for

			if _cameraExported then messageBox "Camera cache exported successfully"
			else messageBox "There are no cameras in scene or they dont match file name"
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | addLightauxData | Añade la información auxiliar necesaria en la luz pasada en el objeto pasado por parametros.
		--@gets: node | obj | Objeto al que añadir el custom attribute.
		-----------------------------------------------------------------------------------------------------
		fn addLightauxData obj =
		(
			sceneLights = lb.lights.getSceneLights()
			
			--	eliminamos la información previa que pudiera tener para no duplicar el custAttribute
			lb.cache.removeLightauxData obj
			
			for l in sceneLights do
			(
				lb.cache.addLightAuxCA l
				
				if isProperty l #includeList and l.includeList != undefined then
				(
					nodeNames = #()
					for o in l.includeList do
						append nodeNames o.name
					
					l.baseobject.custattributes[#light_auxData].includeListNames = nodeNames
				)
				
				if isProperty l #excludeList and l.excludeList != undefined then
				(
					nodeNames = #()
					
					for o in l.excludeList do
						append nodeNames o.name
					
					l.baseobject.custattributes[#light_auxData].excludeListNames = nodeNames
				)
			)
		),

		-----------------------------------------------------------------------------------------------------
		--@fn: undefined | restoreLightIncludeExcludeList | Restaura los nodos a los que incluía o excluía la luz. Los restaura mediante el custom attribute light_auxData que se añadió a cada luz en el proceso de exportación
		--@gets: node | obj | Objeto que se debe restaurar.
		-----------------------------------------------------------------------------------------------------
		fn restoreLightIncludeExcludeList obj =
		(
			sceneLights = lb.lights.getSceneLights()
			
			for l in sceneLights do
			(
				if isProperty l #includeList and l.baseobject.custAttributes[#light_auxData].includeListNames.count > 0 then
				(
					includeObjs = #()
					for n in l.baseobject.custattributes[#light_auxData].includeListNames do
					(
						scnObj = execute ("$'" + n + "'")
						if scnObj != undefined then 
							append includeObjs scnObj
					)
					
					l.includeList = includeObjs
				)
				
				if isProperty l #excludeList and l.baseobject.custAttributes[#light_auxData].excludeListNames.count > 0 then
				(
					excludeObjs = #()
					for n in l.baseobject.custattributes[#light_auxData].excludeListNames do
					(
						scnObj = execute ("$'" + n + "'")
						if scnObj != undefined then 
							append excludeObjs scnObj
					)
					
					l.excludeList = excludeObjs
				)
			)
		),

		------------------------------------------------
		--@fn: boolean | fixClothCaches | Intenta introducir un turbosmooth para ajustar a la cache de telas si el numero de vértices no coincide
		--@gets: node | nodeObj | nodo en el que se ha cargado la cache
		--@gets: string | cachePath | Ruta a la caché que se le ha cargado
		--@returns: boolean | bResult | Devuelve true si la operación se ha realizado satisfactoriamente.
		------------------------------------------------
		fn fixClothCaches nodeObj cachePath= 
		(
			bResult = true

			if not (lb.str.endswith cachePath ".pc2") do
				cachePath = cachePath+".pc2"

			-- solo si la caché es pc2
			if doesFileExist cachePath do
			(
				_meshVertices = nodeObj.baseObject.mesh.vertices.count
				_cacheVertices = lb.cache.getPC2fileVertexCount cachePath
				-- Distinto número de vértices en el objeto base y la caché
				if _meshVertices != _cacheVertices do
				(
					bResult = false

					_modEnabled = #() --Estado de los modificadores anteriores al point cache
					_pointCacheIndex = 0
					_turboSmoothBeforePC = undefined

					--Buscamos el point caché, deshabilitamos todos los modificadores por encima suya y buscamos si después tiene un turbosmooth
					for m=1 to nodeObj.modifiers.count do
					(
						if _pointCacheIndex == 0 then
						(
							if (classOf nodeObj.modifiers[m]) == Point_Cache then
							(
								_pointCacheIndex = m
							)
							else
							(
								append _modEnabled nodeObj.modifiers[m].enabled
								nodeObj.modifiers[m].enabled = false
							)
						)
						else
						(
							if (classOf nodeObj.modifiers[m]) == TurboSmooth then
							(
								_turboSmoothBeforePC = nodeObj.modifiers[m]
							)
						)
					)

					-- Si encontramos el PC
					if _pointCacheIndex > 0 do
					(
						-- Si no tiene Turbo, lo añade después del PC
						if _turboSmoothBeforePC == undefined do
						(
							addModifier nodeObj (TurboSmooth()) before:_pointCacheIndex
							_turboSmoothBeforePC = nodeObj.modifiers[_pointCacheIndex+1]
						)

						-- Probramos tres niveles de iteración
						for _iter=1 to 3 where bResult == false do
						(
							_turboSmoothBeforePC.iterations = _iter

							-- Si coincide el número de vétices, lo mantiene
							if nodeObj.vertices.count == _cacheVertices do
								bResult = true
						)

						-- Si no coinciden los vértices, borrará el TurboSmooth
						if not bResult do
							deleteModifier nodeObj _turboSmoothBeforePC

					)

					--Dejamos todos los modificadores como estaban
					for m=1 to _modEnabled.count do
						nodeObj.modifiers[m].enabled = _modEnabled[m]
				)
			)

			return bResult
		),

		
		------------------------------------------------
		--@fn: array | fixAssetClothCaches | Intenta introducir un turbosmooth para ajustar a la cache de telas si el numero de vértices no coincide
		--@gets: (opt)array | assets | Array de assets para arreglar
		--@returns: array | _lDifferentPointObjs | Array con los objetos que no se han podido fixear.
		------------------------------------------------
		fn fixAssetClothCaches assets:undefined= 
		(
			if assets == undefined do
				assets = lb.asset.getSceneAssets()
			_lDifferentPointObjs = #()

			for asset in assets do
			(
				_meshObjs = asset.meshNodesAll --lb.asset.getAssetNodesByType a lb.nc.NC_classMesh
				
				for o in _meshObjs do
				(
					if (classof o) == XRefObject do
						continue

					_pointCacheMod = o.modifiers[PointCache]
					if _pointCacheMod == undefined do
						continue
					if not doesFileExist _pointCacheMod.filename do
						continue

					if not (lb.cache.fixClothCaches o _pointCacheMod.filename) do
						append _lDifferentPointObjs o
				)
			)

			_lDifferentPointObjs

			--if _lDifferentPointObjs.count > 0 do
			--(
			--	_sMessage = "Point count differs from cache in this assets:\n"
			--	_sMessage = _sMessage + (lb.str.join (for _a in (lb.asset.getAssetsFromNodes _lDifferentPointObjs) collect _a.name) ",\n")
			--	lb.message.show (_sMessage) type:#message size:[650,75] modal:true
			--)
		),

		------------------------------------------------
		--@fn: undefined | loadCachesFromScene | Carga la cámara y los cachés del fichero pasado por parámetros en la cámara actual
		--@gets: string | filename | Path al fichero de caché que cargar.
		--@gets: array | assetMappingList | Array con el mapeado de las accriones a aplicar a los assets. 
		--@gets: (opt)boolean | importCamera | Si vale true se importara la camara incluida en el archivo de caches. Por defecto true
		--@gets: (opt)boolean | deleteOldCameras | Si vale true, se borraran las camaras existentes en la escena antes de cargar los cachés. Por defecto a true
		--@gets: (opt)boolean | loadMatLib | Si vale true, una vez cargado los cachés se cargaran las librerías de los materiales contenidos en la escena.
		------------------------------------------------
		fn loadCachesFromScene filename assetMappingList importCamera:true deleteOldCameras:true loadMatLib:false = 
		(
			disableSceneRedraw()

			--obtiene los nombres de los objetos del max del que cargar los caches
			_targetScnObjectNames = getmaxfileobjectnames filename quiet:true
			_cam = undefined --para almacenar la camara cargada en caso de haberse solicitado

			_errorMessageCache = ""
			
			--si esta el passManager abierto lo cierra para que no ralentice
			if (lb.passManagerUI.isOpen()) then lb.passManagerUI.close()

			---------------------------------------
			--	Carga de la nueva cámara
			---------------------------------------

			if importCamera then
			(
				_camObjName = undefined
				
				for n in _targetScnObjectNames do
				(
					_nameParts = filterstring n "_"
					
					if _nameParts.count == 2 and (toLower _nameParts[1]) == lb.nc.NC_classCam then
						_camObjName = #(n)
				)
				
				if _camObjName != undefined then
				(
					if deleteOldCameras then delete cameras
					
					mergeMaxFile filename _camObjName
					
					_cam = execute ("$'" + _camObjName[1] +"'")
					lb.cameraFunctions.setViewportCamera viewport.activeViewport _cam
					lb.cameraFunctions.setAnimRangeFromCamera _cam goToStart:true
				)
			)
			
			---------------------------------------
			--	Procesado de los assets
			---------------------------------------
			
			setWaitCursor()
			_oldSelection = getCurrentSelection()
			
			undo off
			(
				_LPM_objs = lb.cache.getLPMobjects()
				_sceneLights = lb.lights.getSceneLights()
				_selSetsTMP = lb.cache.getSelectionSets()
				
				--	Generamos en los nodos de LPM la información auxiliar que se necesita para poder
				--	restaurarla en los casos que hagamos un Replace
				for o in _LPM_objs do lb.cache.addLPMauxData o
				for l in _sceneLights do lb.cache.addLightauxData l
				
				------- DELETE -------
				--	Borramos todos los assets en los que hayamos indicado la operación Delete o Replace
				for _amItem in assetMappingList where _amItem.action == #delete or _amItem.action == #replace do
					lb.asset.deleteAsset _amItem.sceneAsset
				

				------- LOAD -------
				for _amItem in assetMappingList where _amItem.action == #load do
				(
					_meshObjs = _amItem.sceneAsset.meshNodesAll --lb.asset.getAssetNodesByType a lb.nc.NC_classMesh
					_newPrefixParts = (filterString _amItem.targetAssetName "_")
					_newPrefix = _newPrefixParts[1] + "_" + _newPrefixParts[2]
					
					for o in _meshObjs where isValidNode o do
					(
						_objNameParts = (filterString (lb.nc.getSimpleObjectName o.name) "_")
						_targetFileName = _newPrefix + "_" + _objNameParts[3] + "_" + _objNameParts[4] + "_" + _objNameParts[5]
						_cacheFileName = (getFileNamePath filename) + "\\source\\" + _targetFileName

						_errorMessageCache += lb.cache.loadCache o _cacheFileName
					)
				)

				------- LOAD NEW OBJECTS -------
				for _amItem in assetMappingList where _amItem.action == #loadNewObjects do
				(
					mergeMaxFile filename _amItem.newObjectsNames #useSceneMtlDups  #alwaysReparent #noRedraw #select
						
					--	Deshacemos las referencias, borramos modificadores duplicados y recolocamos los assets.
					for n in _amItem.newObjectsNames do
					(
						obj = getNodeByName n
						
						if obj != undefined and classof obj == xRefObject then
						(
							_prevModifiers = for _mod in obj.modifiers collect _mod --guardamos los modificadores

							objxrefmgr.mergerecordintoscene (obj.xrefRecord)

							for _mod in obj.modifiers where (findItem _prevModifiers _mod) == 0 do deleteModifier obj _mod --borramos los modificadores que se hayan creado por error
							
							--	recolocamos el point del asset de cache en transform 0 para que todo vaya a su sitio
							if obj.parent != undefined and superclassof obj.parent == helper then obj.parent.transform = matrix3 1
						)--if
					)--for

					objXrefMgr.UpdateAllRecords() --lo hacemos después para poder borrar los modificadores duplicados

					_meshObjs = _amItem.sceneAsset.meshNodesAll --lb.asset.getAssetNodesByType a lb.nc.NC_classMesh
					_newPrefixParts = (filterString _amItem.targetAssetName "_")
					_newPrefix = _newPrefixParts[1] + "_" + _newPrefixParts[2]
					
					for o in _meshObjs do
					(
						_objNameParts = (filterString (lb.nc.getSimpleObjectName o.name) "_")
						_targetFileName = _newPrefix + "_" + _objNameParts[3] + "_" + _objNameParts[4] + "_" + _objNameParts[5]
						_cacheFileName = (getFileNamePath filename) + "\\source\\" + _targetFileName
						
						_errorMessageCache += lb.cache.loadCache o _cacheFileName
					)--for
				)
				
				------- MERGE & REPLACE -------
				for _amItem in assetMappingList where _amItem.action == #merge or _amItem.action == #replace do
				(
					_assetObjsToMerge = #()
					
					-- Calculamos las piezas del fichero que hay que mergear correspondientes al asset que indica _amItem.targetAssetName
					for n in _targetScnObjectNames do
					(
						_targetNameParts = filterString _amItem.targetAssetName "_"
						_targetPrefix = _targetNameParts[1] + "_" + _targetNameParts[2]
						
						_objNameParts = filterString n "_"
						_objPrefix = _objNameParts[1] + "_" + _objNameParts[2]
						
						if _targetPrefix == _objPrefix then append _assetObjsToMerge n
					)
					
					--	Mergeamos las piezas
					if _assetObjsToMerge.count > 0 then 
					(
						mergeMaxFile filename _assetObjsToMerge #useSceneMtlDups #alwaysReparent #noRedraw #select
						
						--	Deshacemos las referencias, borramos modificadores duplicados y recolocamos los assets.
						for n in _assetObjsToMerge do
						(
							obj = getNodeByName n
							
							if obj != undefined and classof obj == xRefObject then
							(
								_prevModifiers = for _mod in obj.modifiers collect _mod --guardamos los modificadores

								objxrefmgr.mergerecordintoscene (obj.xrefRecord)

								for _mod in obj.modifiers where (findItem _prevModifiers _mod) == 0 do deleteModifier obj _mod --borramos los modificadores que se hayan creado por error
								
								--	recolocamos el point del asset de cache en transform 0 para que todo vaya a su sitio
								if obj.parent != undefined and superclassof obj.parent == helper then obj.parent.transform = matrix3 1
							)
						)

						objXrefMgr.UpdateAllRecords() --lo hacemos después para poder borrar los modificadores duplicados
					)
				)

				------- LOAD DE CONNECT OBJECTS-------
				if importCamera do --Solo si estamos cargando otra camara
				(
					_assetObjsToMerge = #()

					for _amItem in assetMappingList where _amItem.action == #load or _amItem.action == #loadNewObjects do
					(
						_connectObjs = _amItem.sceneAsset.connectNodesAll
						_newPrefixParts = (filterString _amItem.targetAssetName "_")
						_newPrefix = _newPrefixParts[1] + "_" + _newPrefixParts[2]
						
						for o in _connectObjs do
						(
							if o.modifiers[Transform_Cache] != undefined then
							(
								-- Si tiene caché de transformación, actualiza el fichero
								_objNameParts = (filterString (lb.nc.getSimpleObjectName o.name) "_")
								_targetFileName = _newPrefix + "_" + _objNameParts[3] + "_" + _objNameParts[4] + "_" + _objNameParts[5]
								_cacheFileName = (getFileNamePath filename) + "\\source\\" + _targetFileName

								_errorMessageCache += lb.cache.loadCache o _cacheFileName
							)
							else
							(
								-- Si no la tiene lo marca para reemplazar el objeto con un merge
								append _assetObjsToMerge o.name
							)
						)
					)

					if _assetObjsToMerge.count > 0 do
					(
						mergeMaxFile filename _assetObjsToMerge #deleteOldDups #useSceneMtlDups #alwaysReparent #noRedraw #select
					)
				)
				

				------- LOAD DE PELO-------
				-- Lo hacemos por separado porque necesitamos el scene redraw habilitado y así evitamos muchos parpadeos
				enableSceneRedraw()

				for _amItem in assetMappingList where _amItem.action == #load or _amItem.action == #loadNewObjects do
				(
					_hairObjs = _amItem.sceneAsset.hairNodesAll
					if _amItem.action == #loadNewObjects do
						_hairObjs = for o in _hairObjs where (findItem _amItem.newObjectsNames o) == 0 collect o --filtramos los objetos que se hayan importado por merge
					_newPrefixParts = (filterString _amItem.targetAssetName "_")
					_newPrefix = _newPrefixParts[1] + "_" + _newPrefixParts[2]
					
					for o in _hairObjs do
					(
						_objNameParts = (filterString (lb.nc.getSimpleObjectName o.name) "_")
						_targetFileName = _newPrefix + "_" + _objNameParts[3] + "_" + _objNameParts[4] + "_" + _objNameParts[5]
						_cacheDirName = (getFileNamePath filename) + "source\\"
						_cacheFileName = _cacheDirName + _targetFileName

						_errorMessageCache += lb.cache.loadCache o _cacheFileName

						--Si tiene pelo, buscamos su caché
						if lb.hair.hasHairGenerator o do
						(

							_hairCacheFileName = _cacheDirName + (lb.nc.getSimpleObjectName o.name) + ".hsb"

							if doesFileExist _hairCacheFileName then
							(
								lb.hair.importHairSimulation o _hairCacheFileName
							)
							else
							(
								lb.hair.clearHairSimulation o
							)
						)
					)
				)
				if _errorMessageCache != "" do lb.message.show _errorMessageCache 
				disableSceneRedraw()
				
				---------------------------------------
				--RESTORE

				-- Al añadir LPMauxData a un nodo se elimina su información real de los nodos a los 
				--	que afecta. La restaruamos y finalmente eliminamos la información auxiliar.
				for o in _LPM_objs do (lb.cache.restoreLPMnodes o; lb.cache.removeLPMauxData o)
				
				for l in _sceneLights do lb.cache.restoreLightIncludeExcludeList l
				for l in _sceneLights do lb.cache.removeLightauxData l
				
				lb.cache.restoreSelectionSets _selSetsTMP
				---------------------------------------	
			)
			
			--	restauramos la selección cuidando de no intentar reseleccionar objetos borrados.
			for i = _oldSelection.count to 1 by -1 where _oldSelection[i].isDeleted do deleteItem _oldSelection i
			select _oldSelection
			
			---------------------------------------
			--REFRESCO DEL ATTACH OBJECT TO FACE
			---------------------------------------

			--Refrescamos todos los objetos con attachObjectToFace
			_aotfObjects = #()
			
			for o in Objects do 
			(
				_aotfControllers = lb.attachObjectToFaceFunctions.getAttachProControllers o
				if _aotfControllers[1] != undefined and _aotfControllers[2] != undefined and _aotfControllers[3] != undefined then
				(
					append _aotfObjects o
				)
			)
			
			--Primero moveremos aquellos que sean independientes o pertenecientes a assets no dependientes.
			for i=_aotfObjects.count to 1 by -1 do
			(
				_aotfAsset = (lb.asset.getAssetsFromNodes #(_aotfObjects[i]))[1]
				
				--Si el objeto es de un asset principal o no es de ningún asset en especial, lo refrescaremos y lo quitaremos de la lista.
				if _aotfAsset == undefined or _aotfAsset.mainAsset == "" then
				(
					--Una vez está todo bien nombrado sacaremos el struct de attachObjectToFace
					_attachPro = lb.attachObjectToFaceFunctions.getAttachProInfo _aotfObjects[i]
					
					--Si no encontramos el objeto no le haremos attach
					if _attachPro.targetObj != undefined then
					(
						undo off
						(
							case _attachPro.AOTFattachMode of 
							(
								#animBake:
									lb.attachObjectToFaceFunctions.createAnimFromVertex _aotfObjects[i] _attachPro.targetObj _attachPro.face barCoords:_attachPro.barCoords initialOffset:_attachPro.initialOffset inheritRotation:_attachPro.inheritRotation keepOffset:_attachPro.keepOffset alignToFace:_attachPro.alignToFace flipAxis:_attachPro.flipAxis xAxis:_attachPro.xAxis
								
								#attach:
									_attachPro.posController.update()
							)
							gc()
						)
						deleteItem _aotfObjects i
					)
				)
			)
			
			--Luego moveremos los dependientes.
			for i=_aotfObjects.count to 1 by -1 do
			(
				--Una vez está todo bien nombrado sacaremos el struct de attachObjectToFace
				_attachPro = lb.attachObjectToFaceFunctions.getAttachProInfo _aotfObjects[i]
				
				--Si no encontramos el objeto no le haremos attach
				if _attachPro.targetObj != undefined then
				(
					undo off
					(
						case _attachPro.AOTFattachMode of 
						(
							#animBake:
								lb.attachObjectToFaceFunctions.createAnimFromVertex _aotfObjects[i] _attachPro.targetObj _attachPro.face barCoords:_attachPro.barCoords initialOffset:_attachPro.initialOffset inheritRotation:_attachPro.inheritRotation keepOffset:_attachPro.keepOffset alignToFace:_attachPro.alignToFace flipAxis:_attachPro.flipAxis xAxis:_attachPro.xAxis
							
							#attach:
								_attachPro.posController.update()
						)
						gc()
					)
				)
			)

			---------------------------------------
			--PASS MANAGER
			
			_passTrees = lb.passManager.getContainerTrees() --obtiene los arboles (solo deberia haber 1)
			_outputPathCA = undefined
			_outputFileCA = undefined
			_camOverrideCA = undefined
			_timeOutputCA = undefined

			if _passTrees.count != 0 then
			(
				_children = _passTrees[1].getChildren()

				for _ch in _children where (_ch.getSubType()) == #overrides do
				(	
					_overrides = _ch.getOverrides()

					for _ov in _overrides do
					(
						case (_ov.getSubtype()) of
						(
							"outputPath": _outputPathCA = _ov.customOverride.infoNode.custAttributes["overrideOutputPathInfo"]
							"outputFile": _outputFileCA = _ov.customOverride.infoNode.custAttributes["overrideOutputFileInfo"]
							"timeOutput": _timeOutputCA = _ov.customOverride.infoNode.custAttributes["overrideTimeOutputInfo"]
							"camera": _camOverrideCA = _ov.customOverride.infoNode.custAttributes["overrideCameraInfo"]
						)--case
					)--for
				)--for
			)--if

			if importCamera and _cam != undefined then
			(
				--cambia el path de render a la nueva camara
				if _outputPathCA != undefined then
				(
					_camName = substituteString _cam.name "_" ""
					_pathParts = filterString (_outputPathCA.outputPath) "\\"
					_outputPathCA.outputPath = substituteString _outputPathCA.outputPath _pathParts[_pathParts.count - 1] _camName
				)--if

				--cambia el file de render a la nueva camara
				if _outputFileCA != undefined then
				(
					_camName = substituteString _cam.name "cam_" "c"
					_fileParts = filterString _outputFileCA.outputFile "_"
					_outputFileCA.outputFile = substituteString _outputFileCA.outputFile _fileParts[2] _camName
				)--if

				--cambia la camara a la nueva
				if _camOverrideCA != undefined then
				(
					_camOverrideCA.cameraNode = _cam
					_camOverrideCA.cameraName = _cam.name
					_camOverrideCA.useRcamera = false
				)--if

				--cambia el rango de render a la nueva camara
				if _timeOutputCA != undefined and _cam.custattributes["camInfo"] != undefined then
				(
					_timeOutputCA.renderTimeType = 3
					_timeOutputCA.renderStart = _cam.custattributes["camInfo"].recStart
					_timeOutputCA.renderEnd = _cam.custattributes["camInfo"].recEnd
				)--if
			)

			---------------------------------------
			-- LIBRERIA DE MATERIALES

			if loadMatLib == true do
			(
				fileDir = lb.io.getDirName filename
				fileBase = lb.io.getBaseName filename
				materialFileName = fileDir + "\\source\\" + (lb.materials.materialLibName fileBase)

				lb.materials.loadLib materialFileName
			)

			---------------------------------------

			---------------------------------------
			-- REAPLICAMOS VARIACIONES

			lb.variations.updateSceneStoredMatVariations()
			---------------------------------------

			---------------------------------------
			-- ROMPEMOS REFERENCIAS

			for r = 1 to objXrefMgr.recordCount where objXrefMgr.recordCount > 0 do --while limitado
			(
				record = objXRefMgr.getRecord 1
				objXRefMgr.MergeRecordIntoScene record
			)
			---------------------------------------

			---------------------------------------
			-- SIMPLIFICAMOS MULTIMATERIALES

			for mat in lb.materials.getSceneMaterials() do
				lb.materials.simplifyMultiMaterial mat
			---------------------------------------

			---------------------------------------
			-- RECOLECTAMOS RECURSOS

			lb.render.resourceCollector()
			---------------------------------------

			---------------------------------------
			-- INFORMAMOS DE CANTIDAD INCONGRUENTE DE PUNTOS
			_lDifferentPointObjs = lb.cache.fixAssetClothCaches()

			if _lDifferentPointObjs.count > 0 do
			(
				_sMessage = "Point count differs from cache in this assets:\n"
				_sMessage = _sMessage + (lb.str.join (for _a in (lb.asset.getAssetsFromNodes _lDifferentPointObjs) collect _a.name) ",\n")
				lb.message.show (_sMessage) type:#message size:[650,75] modal:true
			)
			---------------------------------------

			---------------------------------------
			-- CARGAMOS LAS VARIACIONES DEL SET
			--leemos los sets cargados

			-------------------
			--Comprobamos si es un replacement set, construyendo el nombre
			_loadedSets = lb.asset.getSceneAssets type:lb.nc.NC_setPrefix 
			_isReplacementSet = false 

			_fParts = filterString (getFilenameFile maxfilename) "_"
			_seq = (filterString _fParts[2] "-")[1]
			_cam = substituteString _fParts[3] "cam" ""
			_seqCamAssetPart = "s" + _seq + "-c" + _cam

			-------------------
			--cargamos en modo mesh
			for _set in _loadedSets do
			(
				_assetPath = lb.str.join #(_set.type, _set.namePrefix + "?std-std." + _seqCamAssetPart + "-replacement?", "*" , "v??.max") "_"
				_folderPath = substituteString maxfilepath lb.nc.NC_renderFileName lb.nc.NC_camAssetFolder
				_camAssetFiles = getFiles (_folderPath + _assetPath)
				if (_camAssetFiles.count != 0) do (_isReplacementSet = true)


				_assetPath = lb.str.join #(_set.type, _set.namePrefix + "?" + _set.part + "." + _seqCamAssetPart + "-replacement?", "*" , "v??.max") "_"
				_folderPath = substituteString maxfilepath lb.nc.NC_renderFileName lb.nc.NC_camAssetFolder
				_camAssetFiles = getFiles (_folderPath + _assetPath)
				if (_camAssetFiles.count != 0) do (_isReplacementSet = true)

				_assetPath = lb.str.join #(_set.type, _set.namePrefix + "?" + _set.partPrefix + "-*." + _seqCamAssetPart + "-replacement?", "*" , "v??.max") "_"
				_folderPath = substituteString maxfilepath lb.nc.NC_renderFileName lb.nc.NC_camAssetFolder
				_camAssetFiles = getFiles (_folderPath +  _assetPath)
				if (_camAssetFiles.count != 0) do (_isReplacementSet = true)

				_assetPath = lb.str.join #(_set.type, _set.namePrefix + "?main-std." + _seqCamAssetPart + "-replacement?", "*" , "v??.max") "_"
				_folderPath = substituteString maxfilepath lb.nc.NC_renderFileName lb.nc.NC_camAssetFolder
				_camAssetFiles = getFiles (_folderPath + _assetPath)
				if (_camAssetFiles.count != 0) do (_isReplacementSet = true)

				if (not _isReplacementSet) do
				(
					lb.asset.removeAssetCameraVariations _set
				) 
				lb.asset.loadAssetCameraVariations _set
			)
			---------------------------------------

			--ESTADO DE LAS PIEZAS DE LIGHTING
			lb.misc.passAssetCheck CHK_assetsAnimFrozenHidden type:#sequenceCache fix:true	
			lb.misc.passAssetCheck CHK_assetsMeshUnfrozenUnhidden type:#sequenceCache fix:true
			lb.misc.passAssetCheck CHK_assetsMeshMotionBlurNone type:#sequenceCache fix:true	
			lb.misc.passAssetCheck CHK_hairNiceProperties type:#sequenceCache fix:true
			lb.misc.passAssetCheck CHK_connectNodesAllProperties type:#sequenceCache fix:true

			--LIMPIEZA TURBOSMOOTH
			for obj in objects do
			(
				if (superclassOf obj == GeometryClass) then
				(
					_turboArray = #()
					for m in obj.modifiers do
					(
						if (classOf m == TurboSmooth) then
						(
							append _turboArray m
						)
					)
					
					if (_turboArray.count > 1) then
					(
						_countTurbos = 1
						for _modifier in _turboArray do
						(
							if _modifier.name != "TurboSmooth:k" then
							(
								if(_countTurbos > 1) then
								(
									deleteModifier obj _modifier
								)
								_countTurbos =_countTurbos + 1
							)
						)
					)
				)
			)	
			
			setArrowCursor()
			
			enableSceneRedraw()
			completeRedraw()
		),
		
		------------------------------------------------
		--@fn: undefined | _convertToCacheFromLinkedPoint | Realiza los procedimientos de cacheado de la camara y las bases de los objetos seleccionados en el assetManager. Para camaras linkadas a points.
		------------------------------------------------
		fn convertToCacheFromLinkedPoint =
		(
			cam = undefined
			for i=1 to viewport.numViews do (
				cam = viewport.getCamera index:i
				if cam != undefined do (
					select cam
					hideByCategory.cameras = false
					exit
				)
			)
			--Seleccionaremos la camara para bakearla
			if cam != undefined then 
			(
				--obtenemos el nodo padre de la camara. 
				_camParent = cam.parent
				_selection = select cam
				--Bakeamos la camra
				lb.progressBar.progressBarOpen() 
				lb.bakeAnimation.rollMain.bakeAnimation (getCurrentSelection())
				lb.progressBar.progressBarClose()	
				--Ahora se debe crear el punto linkado 
				if _camParent != undefined then
				(
					--Alineamos el nuevo punto al punto padre y lo linkamos
					_auxPoint = point()
					_auxPoint.transform = _camParent.transform
					_auxPoint.parent = _camParent
					select _auxPoint
					--Bakeamos la animacion del punto nuevo.
					lb.bakeSelectionAnimation.run()
					clearSelection()

					unhide objects
					unfreeze objects
					--Cambiaremos el point constraint de los assets al nuevo objeto auxiliar.
					_allAssets = lb.assetManager.getSelectedAssets()
					for _asset in _allAssets do 
					(
						for _node in _asset.nodes do
						(
							_nodeInformation = #()
							if MatchPattern ((FilterString _node.name "_")[5]) pattern: lb.nc.NC_ANIM_base do 
							(
		 						for _mod in _node.modifiers do 
		 						(
		 							if lb.links.pointConstraint.hasPCattribute _mod do
		 							(
		 								select _node 
		 								lb.links.pointConstraint.snapLink _node 2 way:#prevToThis
		 								lb.links.pointConstraint.addTarget _node _auxPoint 
		 								lb.bakeSelectionAnimation.run()
		 								clearSelection()
		 							)
		 						)
							)
						)
					)
					delete _auxPoint
				)
				else 
				(
					lb.message.show "Cam parent object not found, proceeding to abort"
				)

			)
			else
			(
				lb.message.show "Cam not found on scene"
			)
		),
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
			this.hairFarmClasses = #(HairStyle_Uncomb, HairTo_SplinesSpacewarpModifier, HairTo_PolySpacewarpModifier, HairTo_InstancesSpacewarpModifier, HairStyle_PushOutSpacewarpModifier, HairStyle_Forces, Hair_Display, HairTo_Splines, HairTo_Poly, HairTo_Instances, HairStyle_Wisps, HairStyle_Spiral, HairStyle_Scale, HairStyle_PushOut, HairStyle_Length, HairStyle_Kink, HairStyle_Gravity, HairStyle_Frizz, HairStyle_Displace, HairStyle_Curves, HairStyle_Cluster, HairMesh_to_Poly, HairMesh_Smooth, HairMesh_Sim, HairMesh_Mirror, HairMesh_Link, HairMesh_Extrude, HairMesh_Edit, HairMesh_Brush, Hair_Generate, Hair_Direction_on_Poly)
			this.alembicModClasses = #(Alembic_Mesh_Topology,Alembic_Mesh_Normals,Alembic_Mesh_Geometry,Alembic_Mesh_UVW, EmptyModifier)
			this.cacheModClasses += this.alembicModClasses
			this.modifiersOnTopOfCache = this.hairFarmClasses + this.modifiersOnTopOfCache
			this.modifiersToKeepInCache = this.modifiersOnTopOfCache + this.modifiersToKeepInCache 
			this.modifiersToDisableInCache = this.hairFarmClasses + this.modifiersToDisableInCache

			lb.addLibrary this --añade la libreria a la principal
		)		
	)--lib_cache
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_cache() --crea la libreria
)