------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: libreria de funciones de copy paste.
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lib_copyPasteFunctions | Contiene la libreria de copyPasteFunctions.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_copyPasteFunctions
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #controller,												--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Libreria Copy Paste Functions",	--@var: string | description | Descripcion de la libreria.
		
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

		----------------------------------------------------------------------------------------
		--@fn: integer | copyTracks |  Copia los valores de las piezas seleccionadas en los buffers
		----------------------------------------------------------------------------------------
		fn copyTracks =
		(
			cpyBufferObjects = #()				-- 	nombres de los Objetos de los que se copian valores
			cpyBufferTracksPerObject = #()		--	Todas las pistas de cada objeto del que se copia
			cpyBufferValuesPerObject = #()		--	Todos valores de las pistas de cada objeto del que se copia
			cpyBufferLinksPerObject = #()		--	nombre del objeto al que hay hecho link constraint en el frame que copiamos
			
			contObjs = 1
			-- Creamos el array de objetos seleccionados
			for i = 1 to selection.count do 
			(
				obj = selection[i] --objeto seleccionado
				
				--intentemos conseguir los animTracks de cada objeto
				objTracks = #()
				if lb.customAttributes.hasAttribute obj lb.customAttributes.animTracksCA.name then
					objTracks = lb.animInfo.getAnimTracks obj
				
				if objTracks.count != 0 then --si se han podido obtener los animtracks
				(
					cpyBufferObjects[contObjs] = obj.name --almacena el objeto
					
					tracksObjTMP = #() --array temporal de tracks
					valuesObjTMP = #() --array temporal de valores de los tracks
					linkObj = undefined	--objeto al que pueda estar lincado obj
					
					-- recopilamos los valores actuales de cada pista
					--for j = 1 to objTracks.count where objTracks[j][1] != #separator do
					for j = 1 to objTracks.count where objTracks[j].type != #separator do
					(
						append tracksObjTMP objTracks[j]
						--append valuesObjTMP objTracks[j][1].value
						append valuesObjTMP objTracks[j].track.value
					)
					
					if classof obj.transform.controller == Link_Constraint then --si tiene un link constraint debemos averiguar a que esta lincado en ese instante
					(
						linkC = obj.transform.controller --almacena el controlador en una variable
						numTargets = linkC.getNumTargets() --obtiene el numero de lincajes que tiene el objeto
						
						if numTargets > 0 then --si hay targets
						(
							targetToStore = undefined
							frActual = currentTime.frame as integer
							
							stop = false
							cont = 1
							while (cont <= numTargets and not stop) do
							(
								fr = linkC.getFrameNo cont
								frNext = if cont < numTargets then (linkC.getFrameNo (cont + 1 )) else 100000
									
								if (frActual == fr) or (frActual > fr and frActual < frNext) then
								(
									targetToStore = cont
									stop = true
								)
								
								cont+=1
							)--wile
							
							if targetToStore != undefined then
							(
								targetToStore = linkC.getNode targetToStore
								if targetToStore != undefined then
									cpyBufferLinksPerObject[contObjs] = targetToStore.name
								else
									cpyBufferLinksPerObject[contObjs] = "World"
								
							)
						)					
					)--link
					
					cpyBufferTracksPerObject[contObjs] = tracksObjTMP
					cpyBufferValuesPerObject[contObjs] = valuesObjTMP
					
					contObjs += 1 --incrementa el contador
				)--if
			)
		),

		------------------------------------------------
		--@fn: integer | pasteTracks | Pega los valores de los buffers en las piezas seleccionadas.
		--@gets: array{tracks} | assets | Assets a los que pegar los tracks.
		--@gets: (opt)boolean | applyToSelectionOnly | Indica si solo se van a pegar a la seleccion. Por defecto false.
		--@gets: (opt)boolean | applyToOpposite | Indica si se van a pegar al lado opuesto. Por defecto false.
		--@gets: (opt)boolean | ignoreRootAndBase | Indica si se van a ignorar el root y el base. Por defecto false 
		------------------------------------------------
		fn pasteTracks assets:#() applyToSelectionOnly:false applyToOpposite:false ignoreRootAndBase:false =
		(
			local nPaste = 0
			local originalObjects = #()				-- objetos de los que se copiaron valores que son válidos para pegar en los opuestos.
			local originalTracksPerObject = #()	-- tracks originales de los objetos
			local objectsToPaste = #()				-- objetos a los que pegar la animacion. Es un array de arrays donde
																-- cada elemento del array almacena los objetos equivalentes en todos los assets seleccionados
			
			local selectedAssets = #() --assets para trabajar con ellos y pegarles la pose
			
			if assets.count != 0 then
				selectedAssets = assets
			else
				selectedAssets = lb.asset.getAssetsFromNodes selection --obtiene los assets a los que pertenece la seleccion
			
			for i = 1 to cpyBufferObjects.count do --busca los objetos a los que tiene que pegar las claves
			(
				objName = cpyBufferObjects[i]
				objectsToPaste[i] = #()
				
				-- si existe el objeto añadimos el objeto a los listados para tratarlo
				if objName != undefined then
				(
					append originalObjects objName
					append originalTracksPerObject cpyBufferTracksPerObject[i]

					if applyToOpposite do --si hay que aplicarlo al opuesto obtiene el nombre del objeto opuesto
						objName = lb.nc.getOppositeObjectName objName

					if objName != undefined then --puede que el objeto no tenga opuesto y por tanto no tener que aplicar la pose
					(
						searchName = lb.nc.getNameWithNoPrefix objName --obtiene la parte comun del nombre para varios assets (copias u otros personajes)
						
						for ast in selectedAssets do --recorre los assets buscando los objetos equivalentes
						(
							objs = #()
							hasToApply = true
							
							if ignoreRootAndBase and ast.type == lb.nc.NC_chrPrefix then
							(	
								if findString searchName "base" != undefined and findString searchName lb.nc.NC_classAnim != undefined then
									hasToApply = false
								else if findString searchName "root" != undefined and findString searchName lb.nc.NC_classFacial != undefined then
									hasToApply = false
							)
							
							if applyToSelectionOnly and hasToApply then
								hasToApply = ((lb.misc.searchInArrayByString (getCurrentSelection()) searchName).count != 0)
												
							if hasToApply then
								objs = execute ("$'" + (ast.fullname + "_" + searchName) + "_*'")
							
							if objs != undefined and objs.count != 0 then
								join objectsToPaste[i] objs
						)
					)
				)
			)--for
			
			frActual = currentTime.frame as integer
			
			undo "Paste Pose" on
				for i = 1 to originalTracksPerObject.count do
				(
					--coloca los valores
					for j = 1 to objectsToPaste[i].count do
					(
						t = lb.animInfo.getTracksFromObject objectsToPaste[i][j] -- capturamos los tracks de los objetos donde pegar la pose
						
						-- para cada objeto original buscamos sus pistas
						for k = 1 to originalTracksPerObject[i].count do
						(
							l = 1
							found = false
							while not found and (l <= t.count) do
							(
								--if (originalTracksPerObject[i][k][2] == t[l][2]) then -- si encontramos una pista pegamos valores o tracks
								if (originalTracksPerObject[i][k][2] == t[l].name) then -- si encontramos una pista pegamos valores o tracks
								(
									found = true
									
									newVal = cpyBufferValuesPerObject[i][k] 
									
									if applyToOpposite then --si hay que aplicar al opuesto y es una pieza central, invierte el valor de ciertos ejes
									(
										nameParts = filterString objectsToPaste[i][j].name "_"
										
										case nameParts[4] of
										(
											"m":
											(
												invertValue = false
												actualTrackParts = filterString originalTracksPerObject[i][k][2] ":"
												trackFinalPart = actualTrackParts[actualTrackParts.count]
												
												if nameParts[3] != lb.nc.NC_classFacial then --si no es parte del rig facial
													case trackFinalPart of
													(
														"x_rotation":	invertValue = true
														"y_rotation":	if nameParts[5] != "root" then invertValue = true
														"z_rotation":	if nameParts[5] == "root" then invertValue = true
														
														"z_position":	if nameParts[5] != "root" then invertValue = true
														"x_position":	if nameParts[5] == "root" then invertValue = true												
													)--case trackFinalPart
												else --si es parte del rig facial
													case trackFinalPart of
													(
														"y_rotation":	invertValue = true
														
														"x_position":
														(
															case nameParts[5] of 
															(
																"jaw-all-hz-fr": break;
																"lip-all-snout":	break;
																"teethUpper-all-hz-fr":	break;
																"teethLower-all-hz-fr":	break;
																default:	invertValue = true
															)--case x_position
														)--x_position
														
													)--case trackFinalPart
												
												if invertValue then
													newVal = -newVal
											)--case m
											
										)--case
										
									)--if applyToOpposite
									
									--try t[l][1].value = newVal catch(print "incompatible values") -- algunas veces los tipos de datos de las pistas son imcompatibles. Por eso usamos el TRY.
									try 
									(
										if classof t[l].track.value == BooleanClass then
										(
											if newVal == 1.0 then newVal = true
											else if newVal == 0.0 then newVal = false
										)
										
										t[l].track.value = newVal
									)
									catch
									(
										print "incompatible values"
									) -- algunas veces los tipos de datos de las pistas son imcompatibles. Por eso usamos el TRY.
								)
								l+=1
							)--while
						)--for k
						
						--si el objeto al que pegar la pose tiene un link constraint, intentamos colocarle como target el que tenia del que copiamos
						if classof objectsToPaste[i][j].transform.controller == Link_Constraint then
						(
							linkC = objectsToPaste[i][j].transform.controller
							
							targetToPaste = undefined
							
							if cpyBufferLinksPerObject[i] != undefined then
							(
								targetName = cpyBufferLinksPerObject[i]
								
								if applyToOpposite do --si hay que aplicarlo al opuesto obtiene el nombre del target opuesto
									targetName = lb.nc.getOppositeObjectName targetName
								
								--si el target cumple el naming convention y es una pieza de otro asset intenta obtener la equivalente del actual
								if lb.nc.ncOK targetName and lb.nc.ncOK objectsToPaste[i][j].name then
								(
									tParts = filterString targetName "_"
										
									oParts = filterString objectsToPaste[i][j].name "_"
									oPrefix = oParts[1] + "_" + oParts[2]
									
									targetDefName = oPrefix + "_" + tParts[3] + "_" + tParts[4] + "_" + tParts[5] + "_" + tParts[6] + "_" + tParts[7]
									
									targetToPaste = execute ("$'" + targetDefName + "'")
									
									if not isValidNode targetToPaste then
										targetToPaste = execute ("$'" + targetName+ "'")
								)								
								else
									targetToPaste = execute ("$'" + targetName+ "'")
							)
							
							if targetToPaste != undefined and isValidNode targetToPaste then
							(
								if classof targetToPaste == String then
									linkC.addWorld	frameNo:frActual
								else							
									linkC.addTarget targetToPaste frActual
							)
						)
						
						--)--if hasToApply
					)--for j
				)--for i			
		),--fn

		------------------------------------------------
		--@fn: string | bufferToFile | Almacena los buffers de copia de pose en fichero.
		--@gets: string | file | Contiene el fichero del que sacarle el buffer de copia.		
		------------------------------------------------
		fn bufferToFile file =
		(
			success = false
			
			f = createfile file
			
			if f != undefined then
			(
				close f --primero cierra el fichero recien creado
				f = fopen file "wb" --abre el fichero para almacenar la informacion
				
				if f != undefined then
				(
					writestring f "version=2" --version
					
					numObjs = cpyBufferObjects.count
					numTracks = cpyBufferTracksPerObject.count
					
					writeShort f numObjs #unsigned		-- escribimos el número total de objetos del buffer de objetos
					writeShort f numTracks #unsigned	-- escribimos el número total de tracks, values y link constraints
					
					--almacena el nombre de todos los objetos del buffer
					for i=1 to numObjs do
						writestring f (cpyBufferObjects[i])
					
					--almacena los tracks de cada objeto
					for i=1 to numTracks do
					(
						numObjsTracks = cpyBufferTracksPerObject[i].count
						
						writeShort f numObjsTracks #unsigned --escribimos el numero de tracks de ese objeto
						
						for j=1 to numObjsTracks do
							writestring f (cpyBufferTracksPerObject[i][j].name)
							--writestring f (cpyBufferTracksPerObject[i][j][2])
					)
					
					--almacena los valores de los tracks de cada objeto
					for i=1 to numTracks do
					(
						numObjsValues = cpyBufferValuesPerObject[i].count
						
						writeShort f numObjsValues #unsigned --escribimos el numero de valores de ese objeto
						
						for j=1 to numObjsValues do
						(
							_value = cpyBufferValuesPerObject[i][j]
							
							if classof _value == BooleanClass then
							(
								if _value == true then
									_value = 1.0
								else if  _value == false then
									_value = 0.0
							)--if
							
							writefloat f _value
						)
					)
					
					--almacena los links de cada objeto
					for i=1 to numTracks do
						writestring f (if cpyBufferLinksPerObject[i] != undefined then cpyBufferLinksPerObject[i] else "undefined")
					
					success = fclose f
				)--if2
			)--if1
				
			success
		),

		------------------------------------------------
		--@fn: string | fileToBuffer | Recupera la informacion de un fichero y rellena con ella los buffers.
		--@gets: string | file | Contiene la informacion del buffer.		
		------------------------------------------------
		fn fileToBuffer file = 
		(
			success = false
				
			cpyBufferObjects = #()				-- 	nombres de los Objetos de los que se copian valores
			cpyBufferTracksPerObject = #()		--	Todas las pistas de cada objeto del que se copia
			cpyBufferValuesPerObject = #()		--	Todos valores de las pistas de cada objeto del que se copia
			cpyBufferLinksPerObject = #()		--	nombre del objeto al que hay hecho link constraint en el frame que copiamos
			
			f = fopen file "rb"
			
			if f != undefined then
			(
				version = readstring f
				
				if version == "version=1" then
				(
					numObjs = readbyte f #unsigned		-- obtenemos el número total de objetos del buffer de objetos
					numTracks = readbyte f #unsigned		-- obtenemos el número total de tracks, values y link constraints
					
					--almacena el nombre de todos los objetos del buffer
					for i=1 to numObjs do
						cpyBufferObjects[i] = readstring f
					
					--almacena los tracks de cada objeto
					for i=1 to numTracks do
					(
						numObjsTracks = readbyte f #unsigned --obtenemos el numero de tracks de ese objeto
						
						cpyBufferTracksPerObject[i] = #()
						for j=1 to numObjsTracks do
						(
							cpyBufferTracksPerObject[i][j] = #()
							cpyBufferTracksPerObject[i][j][2] = readstring f
						)
					)
					
					--almacena los valores de los tracks de cada objeto
					for i=1 to numTracks do
					(
						numObjsValues = readbyte f #unsigned --obtenemos el numero de valores de ese objeto
						
						cpyBufferValuesPerObject[i] = #()
						for j=1 to numObjsValues do
							cpyBufferValuesPerObject[i][j] = readfloat f
					)
					
					--almacena los links de cada objeto
					for i=1 to numTracks do
					(
						target = readstring f
						if target != "undefined" then cpyBufferLinksPerObject[i] = target
					)
					
					success = fclose f
				)
				else if version == "version=2" then
				(
					numObjs = readShort f #unsigned		-- obtenemos el número total de objetos del buffer de objetos
					numTracks = readShort f #unsigned		-- obtenemos el número total de tracks, values y link constraints
					
					--almacena el nombre de todos los objetos del buffer
					for i=1 to numObjs do
						cpyBufferObjects[i] = readstring f
					
					--almacena los tracks de cada objeto
					for i=1 to numTracks do
					(
						numObjsTracks = readShort f #unsigned --obtenemos el numero de tracks de ese objeto
						
						cpyBufferTracksPerObject[i] = #()
						for j=1 to numObjsTracks do
						(
							cpyBufferTracksPerObject[i][j] = #()
							cpyBufferTracksPerObject[i][j][2] = readstring f
						)
					)
					
					--almacena los valores de los tracks de cada objeto
					for i=1 to numTracks do
					(
						numObjsValues = readShort f #unsigned --obtenemos el numero de valores de ese objeto
						
						cpyBufferValuesPerObject[i] = #()
						for j=1 to numObjsValues do
							cpyBufferValuesPerObject[i][j] = readfloat f
					)
					
					--almacena los links de cada objeto
					for i=1 to numTracks do
					(
						target = readstring f
						if target != "undefined" then cpyBufferLinksPerObject[i] = target
					)
					
					success = fclose f
				)	
				else
				(
					fclose f
				)--if2
			)--if 1
			
			success
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
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_copyPasteFunctions
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_copyPasteFunctions() --crea la libreria
)