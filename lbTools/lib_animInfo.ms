------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: libreria de animInfo
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: str_animTrack | Struct para almacenar el contenido de un animtracks.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_animTrack 
	(
		type,			--@var: name | type | Tipo de animTrack. Puede ser #separator o #track
		name,			--@var: string | name |Nombre de la pista. Está compuesto por los nombres de todos los controladores separados por ':'
		alias,			--@var: string | alias | Nombre alternativo que se le da a la pista
		track,			--@var: track | track |El track en sí.
		defaultVal		--@var: integer | defaultVal | Valor por defecto que se le asigna al track
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de animInfo.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_animInfo
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,													--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Libreria animInfo",									--@var: string | description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		animTrack = str_animTrack,											--@var: struct | animTrack | Struct de tipo str_animTrack

		animCopyBuffer_ObjectNames = #(),									--@var: array | animCopyBuffer_ObjectNames | objetos de los que se copian valores
		animCopyBuffer_TracksPerObject = #(),								--@var: array | animCopyBuffer_TracksPerObject | tracks independientes de cada objeto seleccionado al copiar
		animCopyBuffer_ValuesPerObject = #(),								--@var: array | animCopyBuffer_ValuesPerObject |	valores de cada pista de cada objeto seleccionado al copiar
		animCopyBuffer_Tracks = #(),										--@var: array | animCopyBuffer_Tracks | almacena los tracks copiados
		animCopyBuffer_Values = #(),										--@var: array | animCopyBuffer_Values | almacena los valores de tracks copiados. Necesario para almacenar de forma permanente los valores.

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
		--@fn: array | getAnimTracks | Devuelve los animtracks del objeto.
		--@gets: node | obj | El nodo a consultar los animtracks.
		--@returns: array | animTracks |  Array con la información de los animTracks, devuelve undefined si no hay, o #ERROR si hay algun error en ellos.
		------------------------------------------------
		fn getAnimTracks obj =
		(
			local animTracksError = false
			local noAnimTracks = false
			local animTracks = undefined
			
			if this.hasAnimTracks obj then
			(
				-- Si no está iniciado animTracks lo iniciamos
				if obj.animInfo.animTracks.count != obj.animInfo.trackIndex.count then
				(
					obj.animInfo.animTracks = #()
					t = obj.animInfo
					for i = 1 to obj.animInfo.trackIndex.count where not animTracksError do
					(
						-- creamos animTracks[1]: subanim
						obj.animInfo.animtracks[i] = #()
						
						tIndex = execute t.trackIndex[i]			-- recuperamos del array de índices el índice de la pista actual
						tNamesString = ("filterstring \"" + t.trackNames[i] + "\" \":\"")
						
						tNames = execute tNamesString	-- recuperamos del array de nombres el nombre de la pista actual
						subAnimIndex = "(maxops.getnodebyhandle " + (obj.inode.handle as string) + ")"
						
						trackTMP = undefined		--	pista actual que se está procesando
						trackType = #track		--	indica el tipo de animTrack actual
						
						if tIndex != undefined then	-- Pistas que no son separadores
						(
-- 								-- 	Accedemos por nombre de subanims a las pistas.
-- 								--	Este bucle puede sustituirse por el siguiente si hay problemas.
-- 								for i in tNames do 
-- 								(
-- 									if findString i "custAttributes" == undefined then --	subAnims
-- 										append subAnimIndex ("[#" + i as string + "]")
-- 									else 	-- Custom Attributes
-- 										append subAnimIndex ("." + i)							
-- 								)
							
								--	Método alternativo de acceso por índices en vez de por nombres.
								--	Descomentar y comentar el bloque anterior si da problemas.
							for i in tIndex do 
							(
								if superclassof i == number then --	subAnims
									append subAnimIndex ("[" + i as string + "]")
								else 	-- Custom Attributes
									append subAnimIndex ("." + i)							
							)
							
							trackTMP = try execute subAnimIndex catch ()
						)
						else 	-- Separadores
							trackType = trackTMP = #separator
						
						--	Solo generamos el animTrack
						if trackTMP != undefined then
						(
							obj.animInfo.animtracks[i] = this.animTrack()
							obj.animInfo.animtracks[i].type = trackType					--	creamos el tipo de pista
							obj.animInfo.animtracks[i].track = if trackType != #separator then trackTMP else undefined	--	creamos el track
							obj.animInfo.animTracks[i].name = t.trackNames[i]		--	creamos el trackName
			-- 						obj.animInfo.animTracks[i].keyable = t.keyable[i]			-- 	creamos keyable track
							obj.animInfo.animTracks[i].alias = if (t.alias[i] == "" or t.alias[i] == undefined) then undefined else t.alias[i] 	-- creamos el alias
							obj.animInfo.animTracks[i].defaultVal = if (t.defaults[i] == "" 	or t.defaults[i] == undefined) then undefined else (execute t.defaults[i])	-- creamos el valor por defecto
						)
						else
						(
							obj.animInfo.animTracks = #()
							animTracksError = true
						)
					)
				)
			)
			else
			(
				noAnimTracks = true
			)
			
			-- Si no ha habido errores devolvemos los animTracks. Si no devolvemos UNDEFINED
			if noAnimTracks then
				animTracks = undefined
			else if not animTracksError then
				animTracks = obj.animInfo.animTracks
			else
				animTracks = #error
			
			animTracks
		),

		------------------------------------------------
		--@fn: array | getTracks | función que extrae todas las pistas del controlador que se pasa por parametros.
		--@gets: node | obj | El nodo a consultar los animtracks.
		--@gets: boolean | keyable | indica si queremos extraer solo las pistas animables
		--@gets: (opt)boolean | showSeparators | indica si queremos añadir las pistas que son separadores en la recopilación. Por defecto en TRUE
		--@gets: (opt)boolean | fullTree | indica si queremos mostrar todo el árbol, recopilando el controlador del que cuelgan otros subanims. Por defecto en FALSE
		--@gets: (opt)String | name | indica si queremos extraer un tipo de track en particular, su nombre. Por defecto ""
		--@returns: array | t |  Array con la información de los Tracks
		------------------------------------------------
		fn getTracks obj keyable showSeparators:true fullTree:false name:"" =
		(
			local t = #()
			
			-- si la pista tiene descendentes relanzamos la función para buscarlos salvo
			-- que sea un controlador de tipo float_limit
			if (obj.numsubs) > 0 then
			(
				-- 	Si se especifica que queremos mostrar todo el árbol recopilamos el
				-- 	controlador del que cuelgan otros subanims
				--	Tenemos en cuenta también que puede ser una pista que a pesar de tener subAnims éstas son de tipo
				--	ease_curve o multiplier_curve. En ese caso las recopilamos también aunque no esté FULLTREE activado.
				if (fullTree and (isproperty obj #value) and (superclassof obj.value != modifier)) or \
					(isProperty obj #ease_curve or isProperty obj #multiplier_curve) then
				(	
					c = obj.controller
					if ((keyable and c != undefined and c.keyable) or not keyable) then
					(
						--	las pistas principales de custom attributes no tienen propiedades #parent ni #value, y
						--	dan problemas en muchas funciones para procesarlas. Evitamos añadirlas.
						if isproperty obj #parent then
						(
							trackTMP = this.animTrack()
							trackTMP.type = #track
							trackTMP.track = obj
							trackTMP.name = name
							trackTMP.alias = undefined
							trackTMP.defaultVal = undefined
							append t trackTMP
						)
					)
				)
				
				for i = 1 to obj.numsubs do
				(
					-- Dependiendo de si el siguiente subAnim es final o no enlazamos 
					-- elementos en el array de tracks de una forma u otra
					n = name
					nNew = (getSubAnimName obj i) as string
					
					if n != "" then n = n + ":" + nNew else n = nNew
				
					-- para el limit controller anotamos sus valores sin entrar en sus subniveles
			-- 			if (obj[i].controller != undefined and classOf obj[i].controller == float_limit) then
			-- 			(
			-- 				c = obj[i].controller[1]
			-- 				if ((keyable and c.controller != undefined and c.controller.keyable) or (c.controller != undefined and not keyable)) then
			-- 				(
			-- 					trackTMP = this.animTrack()
			-- 					trackTMP.type = #track
			-- 					trackTMP.track = obj[i]
			-- 					trackTMP.name = if name != "" then (name + ":" + (getSubAnimName obj i)) else (getSubAnimName obj i)
			-- 					trackTMP.alias = undefined
			-- 					trackTMP.defaultVal = c.value
			-- 					append t trackTMP
			-- 				)
			-- 			)
			-- 			else	-- para el resto de controladores buscamos subpistas
					(
						join t (this.getTracks obj[i] keyable showSeparators:showSeparators fullTree:fullTree name:n)
					)
				)
				
				if showSeparators and (t.count > 0 and t[t.count].type != #separator) then	
					append t (this.animTrack type:#separator name:"Separator")
			)
			else  -- si la pista es un track sin descendentes recopilamos sus valores
			(
				if obj.controller != undefined and ((keyable and obj.controller.keyable) or not keyable) then
				(
					newTrack = (this.animTrack type:#track track:obj name:name defaultVal:obj.value)
					append t newTrack
				)
				else 
				(
					-- si la pista no tiene controlador lo marcamos en la tercera propiedad
					-- Como excepción comprobamos que no estemos en el EmptyModifier:AttributeHolder
					if (isProperty obj #value) and (superClassOf obj.value != modifier) then
						if not keyable then 
						(
							newTrack = (this.animTrack type:#track track:obj name:name defaultVal:obj.value)
							append t newTrack
						)
				)
			)
			
			t
		),

		------------------------------------------------
		--@fn: array | getTracksCustAttributes | función que devuelve todos los custom attributes incluidos en el objeto que se pasa por parametros.
		--@gets: node | obj | El nodo a consultar los Custom Attributes.
		--@gets: boolean | keyable | indica si queremos extraer solo las pistas animables
		--@gets: (opt)String | objName | Si se especifica un nombre, devuelve la información con dicho nombre. Por defecto undefined.
		--@gets: (opt)boolean | fullTree | indica si queremos mostrar todo el árbol, recopilando el controlador del que cuelgan otros subanims. Por defecto en FALSE
		--@gets: (opt)boolean | showSeparators | indica si queremos añadir las pistas que son separadores en la recopilación. Por defecto en TRUE
		--@returns: array | TRKs |  Array con los tracks de los customAttributes.
		------------------------------------------------
		fn getTracksCustAttributes obj keyable objName:undefined fullTree:false showSeparators:true =
		(
			TRKs = #()
			if objName == undefined then objName = obj.name as string

			if obj.custAttributes != undefined then
			(
				for j = 1 to obj.custAttributes.count do
				(
					
					if fullTree then
					(	
						c = obj.controller
						if ((keyable and c != undefined and c.keyable) or not keyable) then
						(
			-- 					--	las pistas principales de custom attributes no tienen propiedades #parent ni #value, y
			-- 					--	dan problemas en muchas funciones para procesarlas. Evitamos añadirlas.
							if isproperty obj #parent then
							(
								newTrack = (this.animTrack type:#track track:obj name:(objName + ":custAttributes[" + (j as string) + "]"))
								append TRKs newTrack
							)
						)
					)
					
					c = obj.custAttributes[j]
					if c != undefined then
					(
						tTMP =  (this.getTracks c keyable showSeparators:showSeparators fullTree:fullTree)
						for i = 1 to tTMP.count do
						(
							if tTMP[i].type != #separator then
							(
								tTMP[i].name = objName + ":custAttributes[" + (j as string) + "]:" + tTMP[i].name
							)
						)
						join TRKs tTMP
					)
				)
			)

			TRKs
		),

		------------------------------------------------
		--@fn: integer | getnumtracks | función que muestra el número total de pistas del elemento inspeccionado
		--@gets: node | obj | El nodo a consultar el numero de pistas.
		--@gets: boolean | keyable | indica si queremos extraer solo las pistas animables
		--@gets: (opt)boolean | fullTree | indica si queremos mostrar todo el árbol, recopilando el controlador del que cuelgan otros subanims. Por defecto en FALSE
		--@returns: integer | n | El numero de pistas.
		------------------------------------------------		
		fn getnumtracks obj Keyable fullTree:false =
		(
			local n = 0
			
			if obj.numsubs > 0 then
			(
				if fullTree and not keyable then n += 1
				for i = 1 to obj.numsubs do n += this.getnumtracks obj[i] keyable fullTree:fullTree 
			)
			else
				if obj.controller != undefined then
					if keyable then
					(
						if obj.controller.keyable then	n += 1
					)
					else 
						n += 1
				else
					if classof obj != EmptyModifier and not keyable then
						n +=1
				
			n
		),

		------------------------------------------------
		--@fn: integer | getnumtracksCustAttributes | función que devuelve el número de pistas de los custom attributes 
		--@gets: node | obj | El nodo a consultar el numero de pistas.
		--@gets: boolean | keyable | indica si queremos extraer solo las pistas animables
		--@gets: (opt)boolean | fullTree | indica si queremos mostrar todo el árbol, recopilando el controlador del que cuelgan otros subanims. Por defecto en FALSE
		--@returns: integer | n | El numero de pistas.
		------------------------------------------------		
		fn getnumtracksCustAttributes obj keyable fullTree:false =
		(
			n = 0
			o = obj.custAttributes
			
			for i = 1 to o.count do
				n += this.getnumtracks o[i] keyable fullTree:fullTree

			n
		),		

		------------------------------------------------
		--@fn: integer | getTracksFromBipedObject | función que devuelve las pistas de un objeto de tipo bipedo.
		--@gets: node | obj | El nodo a consultar el numero de pistas.
		--@gets: boolean | keyable | indica si queremos extraer solo las pistas animables
		--@returns: array | t | Los tracks del objeto.
		------------------------------------------------				
		fn getTracksFromBipedObject obj keyable =
		(
			t = #()
			c = mod.custAttributes[1]
			i = 1
			try
				while c[i] != undefined do
				(
					k = if (c[i].controller != undefined) then c[i].controller.keyable else undefined
					e = #(c[i], (mod.custAttributes[1][i].name), k)
					if not keyable then 
						append t e
					else	if k then append t e
					
					i += 1
				)
			catch()
			t
		),

		------------------------------------------------
		--@fn: array | getTracksFromObject | devuelve un listado con todas las pistas que se han encontrado en el objeto proporcionado según los filtros especificados
		--@gets: node | OBJ | El nodo a consultar las pistas.
		--@gets: (opt)boolean | showPRS | Mostrar los tracks de Position Rotation Scale entre los tracks capturados. Por defecto en TRUE
		--@gets: (opt)boolean | showMods | Mostrar los tracks de los modificadores entre los tracks capturados. Por defecto en FALSE
		--@gets: (opt)boolean | showMats | Mostrar los tracks de los materiales entre los tracks capturados. Por defecto en FALSE
		--@gets: (opt)boolean | showTitleSeparators | Mostrar los tracks de los separadores de tipo titulo entre los tracks capturados. Por defecto en TRUE
		--@gets: (opt)boolean | showSeparators | Mostrar los tracks de los separadores entre los tracks capturados. Por defecto en TRUE
		--@gets: (opt)boolean | fullTree | indica si queremos mostrar todo el árbol, recopilando el controlador del que cuelgan otros subanims. Por defecto en FALSE
		--@gets: (opt)boolean | filterKeyable | indica si queremos añadir solamente los tracks keyable. Por defecto en TRUE
		--@gets: (opt)boolean | ignoreAnimTracks | indica que aunque el objeto tenga animTracks se ignoren para buscar todos los tracks del objeto.
		--@returns: array | t | Los tracks del objeto.
		------------------------------------------------		
		fn getTracksFromObject OBJ  showPRS:true showMods:false showMats:false showTitleSeparators:true showSeparators:true fullTree:false filterKeyable:true ignoreAnimTracks:false =
		(
			local getTracksError = false	-- Indica si ha habido errores recuperando los animTracks
			local t = #()						-- almacena todos los tracks del objecto. Contendrá los animTracks si están definidos, y si no todas las pistas del objeto según los filtros indicados.
			
			if OBJ != undefined then
			(
				if not ignoreAnimTracks and this.hasAnimTracks OBJ then	-- tiene ANIMTRACKS definidas
				(
					objAnimTracks = this.getAnimTracks OBJ
					
					if objAnimTracks != #error then
					(
						if showTitleSeparators and showSeparators then
							t = for a in objAnimTracks collect a	
						else
							for a in objAnimTracks do 
							(
								if a.type != #separator then
									append t a
								else
								(
									if showTitleSeparators and (a.alias != undefined) then append t a
									if showSeparators and a.alias == undefined then append t a
								)
							)
					)
					else	
						getTracksError = true
				)
				else -- no tiene ANIMTRACKS. Seleccionamos según los filtros
				(
					----------------------------------------------
					-- PRS
					----------------------------------------------
					if (showPRS) then 	
					(
						
						if showTitleSeparators then append t (this.animTrack type:#separator name:"SeparatorPRS"  alias:"Transforms")
						n = (getSubAnimName OBJ 3) as string
						join t (this.getTracks OBJ[3] filterKeyable showSeparators:showSeparators fullTree:fullTree name:n)		-- el subanim [3] es el controlador de animación
						
						-- si solo tenemos el separador de título como animtrack significa que no se han encontrado pistas. Lo borramos.
						-- Si no añadimos un separador al final para que no se junte con el siguiente bloque
						if t.count > 0 and t[t.count].type == "SeparatorPRS" then deleteitem t t.count
					)
					
					
					----------------------------------------------
					-- pista de visibilidad
					----------------------------------------------
					if OBJ[1].controller != undefined then
					(
						n = (getSubAnimName OBJ 1) as string
						
						--	Si se encuentran pistas de visibilidad se añade el bloque 
						if showTitleSeparators then append t (this.animTrack type:#separator name:"SeparatorVisibility"  alias:"Visibility")
						join t (this.getTracks OBJ[1] filterKeyable showSeparators:showSeparators fullTree:fullTree name:n)
						if showSeparators then append t (this.animTrack type:#separator name:"SeparatorPostVisibility")
					)
					
					----------------------------------------------
					-- Modifiers (contenidos en OBJ[4]). Muestran también sus customAttributes
					----------------------------------------------
					if (showMods) then	
					(
						--	Buscamos los World Space Modifiers
						if (OBJ.baseobject != OBJ[2]) then	-- Si baseObject y OBJ[4] son distintos significa que hay modificadores
						(
							prefix = (getSubAnimName OBJ 2 as string) + ":"
							for i=1 to OBJ[2].numSubs do
							(
								modName = (getSubAnimName OBJ[2] i)
								titleName = if OBJ[2][i].value != OBJ.baseobject then (getSubAnimName OBJ[2] i) as string else (OBJ[2][i].value as string)
								
								if showTitleSeparators then append t (this.animTrack type:#separator name:"SeparatorMods" alias:titleName)
								
								join t (this.getTracks (OBJ[2][i]) filterKeyable showSeparators:showSeparators fullTree:fullTree name:(prefix + modName))
								join t (this.getTracksCustAttributes OBJ[2][i] filterKeyable fullTree:fullTree showSeparators:showSeparators objName:(prefix + modName))
								
								--	Si no se han añadido pistas para el BaseObject añadimos un espacio de separación
								if t.count > 0 and showSeparators and t[t.count].alias == titleName then 
									append t (this.animTrack type:#separator name:"Separator")
							)
						)
						
						--	Buscamos los modificadores
						if (OBJ.baseobject != OBJ[4]) then	-- Si baseObject y OBJ[4] son distintos significa que hay modificadores
						(
							prefix = (getSubAnimName OBJ 4 as string) + ":"
							for i=1 to OBJ[4].numSubs do
							(
								modName = (getSubAnimName OBJ[4] i)
								titleName = if OBJ[4][i].value != OBJ.baseobject then (getSubAnimName OBJ[4] i) as string else (OBJ[4][i].value as string)
								
								if showTitleSeparators then append t (this.animTrack type:#separator name:"SeparatorMods" alias:titleName)
								
								join t (this.getTracks (OBJ[4][i]) filterKeyable showSeparators:showSeparators fullTree:fullTree name:(prefix + modName))
								join t (this.getTracksCustAttributes OBJ[4][i] filterKeyable fullTree:fullTree showSeparators:showSeparators objName:(prefix + modName))
								
								--	Si no se han añadido pistas para el BaseObject añadimos un espacio de separación
								if t.count > 0 and showSeparators and t[t.count].alias == titleName then 
									append t (this.animTrack type:#separator name:"Separator")
							)
						)
						else	-- Si no hay modificadores. Añadimos el base object.
						(
							n = (getSubAnimName OBJ 4) as string
							titleName = (OBJ[4].value as string)
							
							if showTitleSeparators then append t (this.animTrack type:#separator name:"SeparatorBaseObject" alias:titleName)
							
							join t (this.getTracks (OBJ[4]) filterKeyable showSeparators:showSeparators fullTree:fullTree name:n)
							join t (this.getTracksCustAttributes OBJ[4] filterKeyable showSeparators:showSeparators fullTree:fullTree objName:n)
							
							--	Si no se han añadido pistas para el BaseObject añadimos un espacio de separación
							if t.count > 0 and showSeparators and t[t.count].alias == titleName then 
									append t (this.animTrack type:#separator name:"Separator")
						)
					)
					
					
					
					----------------------------------------------
					-- Materials (contenido en OBJ[5])
					----------------------------------------------
					if (showMats) then	
					(
						if showTitleSeparators then append t (this.animTrack type:#separator name:"SeparatorMats" alias:"Material")
						
						if OBJ.material != undefined then
						(
							n = (getSubAnimName OBJ 5) as string
						
							join t (this.getTracks OBJ[5] filterKeyable showSeparators:showSeparators fullTree:fullTree name:n)
						)	
						
						--	Si no se han añadido pistas para el BaseObject añadimos un espacio de separación
							if t.count > 0 and showSeparators and t[t.count].alias == "Material" then
								append t (this.animTrack type:#separator name:"Separator")
					)
					
					----------------------------------------------
					-- Custom Attributes del nodo
					----------------------------------------------
					for i = 1 to OBJ.custAttributes.count do
						join t (this.getTracks OBJ.custAttributes[i] filterKeyable fullTree:fullTree showSeparators:showSeparators name:("custAttributes[" + (i as string) + "]"))
					
					-- si el último track es un separador lo eliminamos
					if t.count > 0 and t[t.count].type == #separator then deleteitem t t.count 
					
					this.renameAnimTracksSeparators t
				)
			)
			
			-- 	Si no ha habido errores devolvemos los tracks encontrados.
			--	Si no devolvemos UNDEFINED
			if not getTracksError then
				t	-- tracks encontrados
			else
				undefined
		),

		------------------------------------------------
		--@fn: struct | getTrackByController | devuelve un track a partir de un controlador específico. Lo busca entre todos los tracks del objeto, y devuelve aquél cuyo controlador coincide con el pasado por parametros.
		--@gets: node | OBJ | El nodo a consultar las pistas.
		--@gets: controller | controller | El tipo de track del que queremos consultar su pista.
		--@returns: struct | tr | El track consultado, devuelve undefined si no se ha podido encontrar.
		------------------------------------------------	
		fn getTrackByController OBJ controller =
		(
			tr = undefined
			
			
			tracksTMP = this.getTracksFromObject OBJ showPRS:true showMods:true showMats:true showTitleSeparators:false showSeparators:false fullTree:true filterKeyable:false ignoreAnimTracks:true
			
			for t in tracksTMP where tr == undefined do
			(
				if t.track.controller == controller then tr = t 
			)
			
			tr
		),
		
		------------------------------------------------
		--@fn: struct | newSeparatorTrack | Devuelve un track de tipo separator, configurada segun los parametros de la función.
		--@gets: string | separatorName | El nombre del track
		--@gets: (opt)string | alias | Alias asociado al separador. Por defecto ""
		--@returns: struct | tr | El track generado.
		------------------------------------------------
		fn newSeparatorTrack separatorName alias:"" =
		(
			str_animTrack type:#separator name:separatorName alias:alias
		),
		
		------------------------------------------------
		--@fn: conntroller | getTrackController | Devuelve el controlador real del track TRK teniendo en cuenta si es un float limit, un animLayer o un controlador normal.
		--@gets: struct | trk | el track del cual consultar el controlador.
		--@returns: controller | _controller | El controlador asociado al track.
		------------------------------------------------
		fn getTrackController trk =
		(
			_controller = undefined --(items[i].track.controller != undefined) or (rollChannelBox.setKeyable true it:items[i])
			
			if classof trk.controller != float_limit then
				_controller = trk.controller
			else
				_controller = trk.controller[1].controller
			
			if _controller != undefined then
			(
				--	para animLayers capturamos el controlador activo
				if isProperty _controller #count then
					_controller = _controller[_controller.active].controller
			)
			
			_controller
		),

		------------------------------------------------
		--SETS
		------------------------------------------------

		------------------------------------------------
		--@fn: undefined | setAnimTracks | A cada objeto del array suministrada le crea como animTracks el valor correspondiente del array de tracks pasado por parámetros
		--@gets: array | OBJ | Array de los objetos a los que se le debe aplicar los tracks.
		--@gets: array | tracks | Array de structs de tipo track.
		------------------------------------------------
		fn setAnimTracks OBJ tracks = 
		(	
			-- Si el objeto tenía animTracks previamente, se las eliminamos
			if this.hasAnimTracks OBJ then this.removeAnimTracks OBJ
			
			--	si los tracks vienen en el formato antiguo los convertimos
			tracksTMP = #()
			
			for t in tracks do
			(
				if not (isProperty t #type) then
					append tracksTMP (this.animTrack 	type:(if t[1] == #separator then #separator else #track) \
																			track:(if t[1] != #separator then t[1]) \
																			name:t[2] \
																			alias:t[4] \
																			defaultVal:t[5])
				else
					append tracksTMP t
			)
			
			tracks = tracksTMP
			
			-- todas las pistas que no tienen controlador asignado se tratan como nonKeyable
			for t in tracks where t.type != #separator do
				if this.isTrackKeyable t.track == undefined then
					if (lb.controller.createTrackController t.track) then t.track.controller.keyable = true
				
			custAttributes.add OBJ lb.customAttributes.animTracksCA #unique baseobject:false
			this.initAnimTracks OBJ tracks		-- Iniciamos los custattributes del objeto
			
			-- hace todas las pistas del objeto bloqueadas
			lb.animation.setLocks OBJ true		
			
			-- hacemos que todas las pistas de animTracks queden sin bloquear
			for a in OBJ.animInfo.animTracks where a.type != #separator do
				lb.animation.setLocks a.track false affectChildren:false
			
			--	las pistas de weights de los Point Constraint también hay que desbloquearlas
			if lb.links.pointConstraint.hasPCattribute OBJ.modifiers[1] then
			(
				lb.animation.setLocks OBJ[#transform][#position][#weights][#weight__PC_pointConstraint] false affectChildren:false
				lb.animation.setLocks OBJ[#transform][#rotation][#weights][#weight__OC_pointConstraint] false affectChildren:false
			)
		),

		------------------------------------------------
		--@fn: undefined | setAnimTracksDefaults | asigna en los animtracks el valor por defecto que tienen actualmente
		--@gets: array | OBJ | Array de los objetos a los que se le debe aplicar la modificación.
		------------------------------------------------
		fn setAnimTracksDefaults OBJ = 
		(
			if (this.hasAnimTracks OBJ) and (try (OBJ.defaults; true) catch false) then
			(
				t = this.getTracksFromObject OBJ
				for i = 1 to t.count where t[i].type != #separator do
				(
					val = OBJ.animInfo.animtracks[i].track.value
					OBJ.animInfo.animtracks[i].defaultVal = val
					OBJ.animInfo.defaults[i] = val as string
				)
			)
		),

		------------------------------------------------
		--OTHER
		------------------------------------------------

		------------------------------------------------
		--@fn: boolean | hasAnimTracks | indica si el objeto pasado por parametros tiene animTracks definidas
		--@gets: node | OBJ | Objeto al que hacer la consulta.
		--@returns: boolean | undefined | El resultado de la consulta.
		------------------------------------------------
		fn hasAnimTracks obj =
		(
			(lb.customAttributes.hasAttribute obj #animInfo)
		),

		------------------------------------------------
		--@fn: undefined | renameAnimTracksSeparators | Cambia el nombre del animtrack de todos los separadores que se encuentren en los tracks suministrados haciendo que se llamen Separator01, Separator02,...SeparatorN. Esto es necesario para que se puedan recuperar las selecciones de las pistas.
		--@gets: array | trks | Array de tracks a los que cambiar el nombre.
		------------------------------------------------
		fn renameAnimTracksSeparators trks =
		(
			n = 1

			for t in trks where t.type == #separator do
			(
				t.name = "Separator" + (if (n as string).count == 1 then ("0" + (n as string)) else (n as string))
				n += 1
			)
		),

		-----------------------------------------------------------------------------------------------------
		-- función que devuelve el número total de pistas de un objeto
		-----------------------------------------------------------------------------------------------------
		------------------------------------------------
		--@fn: array | totalNumTracks | función que devuelve el número total de pistas de un objeto
		--@gets: node | OBJ | El nodo a consultar las pistas.
		--@gets: (opt)boolean | showPRS | Mostrar los tracks de Position Rotation Scale entre los tracks capturados. Por defecto en TRUE
		--@gets: (opt)boolean | showMods | Mostrar los tracks de los modificadores entre los tracks capturados. Por defecto en FALSE
		--@gets: (opt)boolean | showMats | Mostrar los tracks de los materiales entre los tracks capturados. Por defecto en FALSE
		--@gets: (opt)boolean | showTitleSeparators | Mostrar los tracks de los separadores de tipo titulo entre los tracks capturados. Por defecto en TRUE
		--@gets: (opt)boolean | showSeparators | Mostrar los tracks de los separadores entre los tracks capturados. Por defecto en TRUE
		--@gets: (opt)boolean | fullTree | indica si queremos mostrar todo el árbol, recopilando el controlador del que cuelgan otros subanims. Por defecto en FALSE
		--@gets: (opt)boolean | filterKeyable | indica si queremos añadir solamente los tracks keyable. Por defecto en TRUE
		--@gets: (opt)boolean | ignoreAnimTracks | indica que aunque el objeto tenga animTracks se ignoren para buscar todos los tracks del objeto. Por defecto en FALSE
		--@returns: integer | undefined | La cantidad de tracks del objeto.
		------------------------------------------------
		fn totalNumTracks obj showPRS:true showMods:false showMats:false showTitleSeparators:true showSeparators:true fullTree:false filterKeyable:true ignoreAnimTracks:false =
		(
			tracksTMP = #()
			tracksTMP = (this.getTracksFromObject OBJ  showPRS:showPRS showMods:showMods showMats:showMats showTitleSeparators:showTitleSeparators showSeparators:showSeparators fullTree:fullTree filterKeyable:filterKeyable ignoreAnimTracks:ignoreAnimTracks)
			
			tracksTMP.count
		),

		-----------------------------------------------------------------------------------------------------
		--  reemplaza los animTracks del nodo OBJ por los TRKS nuevos
		-----------------------------------------------------------------------------------------------------


		fn replaceAnimTracks OBJ trks = 
		(	
			this.removeAnimTracks OBJ
			this.setAnimTracks OBJ trks
		),

		------------------------------------------------
		--@fn: boolean | isAnimTrack | Indica si el track indicado es un animTrack 
		--@gets: struct | track | El track que queremos consultar
		--@returns: boolean | exist | El resultado de la consulta.
		------------------------------------------------		
		fn isAnimTrack track = 
		(
			exist = false
			obj = (refs.dependentnodes track)[1]
			
			if this.hasAnimTracks obj then
			(
				objAnimTracks = this.getAnimTracks obj
				
				if objAnimTracks !=  #error and objAnimTracks != undefined then
				(
					for t in obj.animInfo.animTracks do
						if t.track == track then exist = true
				)
			)
			
			exist
		),

		------------------------------------------------
		--@fn: boolean | animTracksReady | indica si el objeto tiene la propiedad animTracks lista para usarse, Si no la tiene intenta prepararla.
		--@gets: node | obj | El nodo a consultar los animtracks.
		--@returns: boolean | undefined | Devuelve si la propiedad animtracks está lista.
		------------------------------------------------	
		fn animTracksReady obj =
		(
			if this.hasAnimTracks obj then
			(
				t = this.getAnimTracks obj
				true
			)
			else
				false
		),

		------------------------------------------------
		--@fn: undefined | initAnimTracks | inicia las variable animTracks y objectTracks en el objeto proporcionado. 
		--@gets: node | obj | El nodo que contiene los animtracks.
		--@gets: array | tracks | Array que contiene los structs a inicializar
		------------------------------------------------
		fn initAnimTracks obj tracks = 
		(
			global objTMP = obj		-- necesitamos una variable global que contenga el objeto para poder hacer un execute 
													-- del string que construimos durante la construcción de los animTracks.
			
			obj.animInfo.animTracks = tracks

			obj.animInfo.trackIndex		= #()
			obj.animInfo.trackNames 	= #()
			obj.animInfo.keyable 		= #()
			obj.animInfo.alias 			= #()
			
			for i = 1 to tracks.count do
			(
				tIndex = #()
				if tracks[i].type != #separator then	-- pistas que no son separadores
				(
					-- 	Para extraer los índices que irán almacenados en animInfo.trackIndex miramos 
					--	las etiquetas almacenadas en tracks[i][2], que corresponden a los nombres de los subanims
					subAnimNames = filterstring tracks[i].name ":"
					subAnimObj = "objTMP"
					
					-- buscamos los índices de cada SubAnim
					for j = 1 to subAnimNames.count do
					(
						n = subAnimNames[j] as name
						
						if findstring subAnimNames[j] "custAttributes" != undefined then
						(
							append subAnimObj ("." + subAnimNames[j])
							append tIndex subAnimNames[j]
						)
						else
						(
							preTrack = (execute subAnimObj)
							append subAnimObj ("[#" + n + "]")
							track = (execute subAnimObj)
							
							--	En ocasiones el índice del track se devuelve mal. Si es así
							--	buscamos su índice a mano.
							if (getSubAnimName preTrack track.index == n) then 
								append tIndex track.index
							else
								for i = 1 to preTrack.numSubs where(getSubAnimName preTrack i == n) do
									append tIndex i
						)
					)
				)
				else
					tIndex = #separator
				
				obj.animInfo.trackIndex[i] 		= (tIndex as string)
				obj.animInfo.trackNames[i]		= tracks[i].name
				obj.animInfo.keyable[i]			= if tracks[i].track != undefined and this.isTrackKeyable tracks[i].track != undefined then this.isTrackKeyable tracks[i].track else false
				obj.animInfo.alias[i] 				= if (tracks[i].alias == undefined) then "" else tracks[i].alias	
				obj.animInfo.defaults[i] 			= if (tracks[i].defaultVal == undefined) then "" else (tracks[i].defaultVal as string)
			)
			
			objTMP = undefined 	-- como esta variable es global hay que limpiarla al final
			
			
			-- Antiguo algoritmo de iniciación de animTracks
			--	objTracks = #()
			-- 	for i = 1 to tracks.count do 
			-- 	(
			-- 		t = tracks[i]
			-- 		if tracks[i][1] != #separator then	-- pistas que no son separadores
			-- 		(
			-- 			tIndex = #()
			-- 			subAnimNames = filterstring t[2] ":"
			-- 			subAnimObj = "(maxops.getnodebyhandle " + (obj.inode.handle as string) + ")"
			-- 			
			-- 			-- buscamos los índices de cada SubAnim
			-- 			for i = 1 to subAnimNames.count do
			-- 			(
			-- 				n = subAnimNames[i] as name
			-- 				
			-- 				if findstring subAnimNames[i] "custAttributes" != undefined then
			-- 				(
			-- 					append subAnimObj ("." + subAnimNames[i])
			-- 					append tIndex subAnimNames[i]
			-- 				)
			-- 				else
			-- 				(
			-- 					append subAnimObj ("[#" + n + "]")
			-- 					append tIndex (execute subAnimObj).index
			-- 				)
			-- 			)
			-- 			objTracks[i] = (tIndex as string) + "|||" + t[2] + "|||" + (t[3] as string) + "|||" + (t[4] as string)
			-- 		)
			-- 		else	-- separadores
			-- 		(
			-- 			objTracks[i] = "#separator" + "|||" + t[2] + "|||" + "false" + "|||" + (t[4] as string)
			-- 		)
			-- 	)
			--	obj.animInfo.objectTracks = objTracks
		),

		------------------------------------------------
		--@fn: undefined | initAnimTracks | elimina la propiedad animTracks en el objeto proporcionado por parametros.
		--@gets: node | OBJ | El nodo del que se borraran los animtracks
		------------------------------------------------		
		fn removeAnimTracks OBJ = 
		(	
			if this.hasAnimTracks OBJ then
			(
				custAttributes.delete OBJ (custAttributes.getdef OBJ.animInfo) baseobject:false
				lb.animation.setLocks OBJ false
			)
		),

		------------------------------------------------
		--@fn: boolean | isTrackKeyable | Indica si el track pasado por parámetro es keyable o no. 
		--@gets: struct | trk | El track que queremos consultar
		--@returns: boolean | _isKeyable | El resultado de la consulta. devuelve TRUE si el track tiene controlador y además es animable, FALSE si el track tiene controlador pero no es animable o UNDEFINED si el track no tiene controlador
		------------------------------------------------
		fn isTrackKeyable trk =
		(
			_isKeyable = undefined
			
			if trk.controller != undefined then
			(
				_cont = this.getTrackController trk
				
				if _cont != undefined then
					_isKeyable = _cont.keyable
			)
			
			_isKeyable
		),

		------------------------------------------------
		--@fn: boolean | hasAnimTracksKey | Averigua si hay clave en todos los animtracks en el frame especificado para el objeto proporcionado por parámetros.
		--@gets: node | OBJ | El nodo a consultar	
		--@gets: (opt)time | time | El frame al que consultar si tiene animTracks. Por defecto el frame actual de la escena. 
		--@gets: (opt)boolean | ignoreLinkTimes | Se consulta a nivel genérico.
		--@returns: boolean | _isKeyable | El resultado de la consulta. devuelve TRUE si el track tiene controlador y además es animable, FALSE si el track tiene controlador pero no es animable o UNDEFINED si el track no tiene controlador
		------------------------------------------------		
		fn hasAnimTracksKey OBJ time:currentTime ignoreLinkTimes:false = 
		(
			hasAllKeys = true
			
			if this.animTracksReady OBJ then	-- comprobamos si el objeto tiene animTracks y si están listas para usarse
			(
				items = OBJ.animInfo.animTracks
				for i = 1 to items.count where items[i].type != #separator do 
				(
					if (this.isTrackKeyable items[i].track != false) then 
					(
						-- si la pista es keyable pero no tiene controlador no tiene key
						if items[i].track.controller == undefined then
							hasAllKeys = false
						else
						(
							auxController = this.getTrackController items[i].track
							
							if ignoreLinkTimes then
							(
								if classof auxController != LinkTimeControl and (getKeyIndex auxController time) == 0 then
									hasAllKeys = false
							)
							else if (getKeyIndex auxController time) == 0 then
								hasAllKeys = false
							
						)--if else
					)--if 
				)--for
			)
			else
				hasAllKeys = false
			
			hasAllKeys
		),

		------------------------------------------------
		--@fn: undefined | createAnimTracksKey | Crea una clave a todos los animTracks del objeto proporcionado.
		--@gets: node | OBJ | El nodo al que crear las keys.	
		--@gets: (opt)time | time | El frame en el que se crearán las keys. Por defecto el frame actual de la escena. 
		------------------------------------------------		
		mapped fn createAnimTracksKey OBJ time:currentTime = 
		(
			if this.animTracksReady OBJ then	-- comprobamos si el objeto tiene animTracks y si están listas para usarse
			(
				items = OBJ.animInfo.animTracks
				for i = 1 to items.count where items[i].type != #separator do 
				(
					if (this.isTrackKeyable items[i].track != false) then 
					(
						-- si la pista es keyable pero no tiene controlador, se lo creamos primero
						if items[i].track.controller == undefined then lb.controller.setControllerKeyable items[i].track.controller true
						
						_cont = this.getTrackController items[i].track
						if _cont != undefined then 
							addnewkey _cont time
					)
				)
			)
		),

		------------------------------------------------
		--@fn: undefined | createAnimTracksKeyToSet | Crea una clave a todos los objetos que forman parte de los sets a los que pertenecen los nodos del objeto proporcionado.
		--@gets: node | obj | Un nodo del set en el que crear las keys.	
		--@gets: (opt)time | time | El frame en el que se crearán las keys. Por defecto el frame actual de la escena. 
		------------------------------------------------			
		fn createAnimTracksKeyToSet obj time:currentTime = 
		(
			_objsInSets = lb.objectSets.getNodesInSameObjectSet obj
			
			for _o in _objsInSets do
				this.createAnimTracksKey o time
		),

		------------------------------------------------
		--@fn: undefined | removeAnimTracksKey | elimina la propiedad animTracks en el objeto proporcionado por parametros.
		--@gets: node | OBJ | El nodo del que se borraran los animtracks
		--@gets: (opt)time | time | El frame en el que se borrarán las keys. Por defecto el frame actual de la escena. 
		------------------------------------------------
		mapped fn removeAnimTracksKey obj time:currentTime = 
		(
			if this.animTracksReady obj then	-- comprobamos si el objeto tiene animTracks y si están listas para usarse
			(
				items = obj.animInfo.animTracks
				for i = 1 to items.count where items[i].type != #separator do 
				(
					_cont = this.getTrackController items[i].track
					
					try deletekey _cont (getkeyindex _cont time) catch()
				)
			)
		),
		

		------------------------------------------------
		--@fn: undefined | removeAnimTracksAnimation | Elimina las claves a todos los animTracks del objeto/objetos proporcionado
		--@gets: node/array | obj | Objeto o array de objetos de los que borrar las claves.
		--@gets: (opt)time | time | El frame en el que se borrarán las keys. Por defecto el frame actual de la escena.
		------------------------------------------------		
		mapped fn removeAnimTracksAnimation obj time:currentTime = 
		(
			_tracks = this.getTracksFromObject obj
			
			for _t in _tracks where _t.type != #separator do
			(
				_cont = lb.animInfo.getTrackController _t.track
				
				-- 	Las claves de tipo linkConstraint se borran de forma distinta
				--	al resto. Las detectamos para tratarlas aparte
				if classof _cont != linkTimeControl then
					try deletekeys _cont #allKeys catch()
				else
				(
					for j = _cont.keys.count to 2 by -1 do 
						_t.track.parent.deleteTarget j
				)
			)
		),
		
		------------------------------------------------
		--@fn: undefined | setTracksValue | Establece el valor indicado por parametros en todos los Tracks de la array sumisistrada.
		--@gets: array | animTracks | Array con los animtracks que se desea configurar su valor.
		--@gets: variable | val | El valor con el que se quiere configurar el track. Si VAL vale #DEFAULT se establece el valor por defecto de cada pista.
		------------------------------------------------				
		fn setTracksValue animTracks val = 
		(
			for i = 1 to animTracks.count where animTracks[i].type != #separator do 
			(
				_valueToAssign = undefined	-- valor que vamos a asignar a la pista
				_controller = animTracks[i].track.controller		-- controlador del track
				_animTrack = animTracks[i]
				
				_controllerClass = classOf _animTrack.track.value
				
				-- si hay que poner el valor por defecto miramos si la pista lo tiene asignado,
				-- si no le asignamos 0, [0,0,0], false ó [0,0,0,0] dependiendo del tipo de valor
				if val == #default then
				(
					if _animTrack.defaultVal != undefined then
					(
						_valueToAssign = _animTrack.defaultVal
					)
					else
					(
						if (_controllerClass == BooleanClass) then _valueToAssign = false
						if (_controllerClass == Float) or (_controllerClass == Integer) then _valueToAssign = 0
						if (_controllerClass == Point3) or (_controllerClass == Color) then _valueToAssign = [0,0,0]
						if (_controllerClass == Point4) then _valueToAssign = [0,0,0,0]
					)
					
					if _valueToAssign == #default then _valueToAssign = undefined
				)
				else
					_valueToAssign = val
				
				if _valueToAssign != undefined then
					try _animTrack.track.value = _valueToAssign catch ()
			)
		),

		------------------------------------------------
		--@fn: undefined | setAnimTracksValue | Establece el valor indicado por el parametro val en todos los animTracks del objeto obj
		--@gets: node | obj | el objeto al que configurar los animtracks.
		--@gets: variable | val | El valor con el que se quiere configurar el animtrack. Si VAL vale #DEFAULT se establece el valor por defecto de cada pista.
		------------------------------------------------			
		fn setAnimTracksValue obj val = 
		(
			if this.hasAnimTracks obj then
				this.setTracksValue obj.animInfo.animTracks val
		),	

		------------------------------------------------
		--@fn: undefined | copyAnimTracks | Copia los valores de las pistas seleccionadas en un buffer de una variable local de la libreria.
		--@gets: (opt)boolean | alltracks | Parámetro que no se usa en la función. Por defecto false
		------------------------------------------------
		fn copyAnimTracks allTracks:false =
		(
			this.animCopyBuffer_ObjectNames = #()	--	Todas las pistas de cada objeto del que se copia
			this.animCopyBuffer_TracksPerObject = #()	--	Todas las pistas de cada objeto del que se copia
			this.animCopyBuffer_ValuesPerObject = #()	--	Todas las pistas de cada objeto del que se copia
			this.animCopyBuffer_Tracks = #()				--	Tracks de cada objeto que se copian. Tiene estructura de tipo TracksMulti
			this.animCopyBuffer_Values = #()				--	Valores de cada track que se han copiado
			
			for _obj in (getCurrentSelection()) do 
			(
				_trackValues = #()
				_tracks = (this.getAnimTracks _obj)
				
				if _tracks == undefined then _tracks = this.getTracks _obj true
				
				if _tracks == undefined then _tracks = #()
				
				for _t in _tracks do
					if _t.type == #separator then
						append _trackValues #separator
					else
						append _trackValues _t.track.value
				
				append this.animCopyBuffer_ObjectNames _obj.name
				append this.animCopyBuffer_ValuesPerObject _trackValues
				append this.animCopyBuffer_TracksPerObject _tracks
			)
		),

		------------------------------------------------
		--@fn: undefined | pasteAnimTracks | Pega los valores copiados en las mismas pistas de las que se copió en este u otro objeto
		--@gets: (opt)name | type |  #posture, #track -- para pegar la animacion del track entero o solo de la pose. Por defecto #posture
		------------------------------------------------
		fn pasteAnimTracks type:#posture =
		(
			_pasteString = "Paste " + (type as string)
			_selAssets = lb.asset.getAssetsFromNodes (getCurrentSelection())
			
			undo _pasteString on
			(
				for _ast in _selAssets do
				(
					for i = 1 to this.animCopyBuffer_ObjectNames.count do
					(
						--	objeto origen
						_srcObjName = this.animCopyBuffer_ObjectNames[i]
						
						--	buscamos el objeto destino
						_targetObjName = _srcObjName
						_targetObjName = lb.nc.replaceNamePart _targetObjName 1 _ast.type
						_targetObjName = lb.nc.replaceNamePart _targetObjName 2 _ast.name
						_targetObjName = lb.nc.getSimpleObjectName _targetObjName
						_targetObj = (execute ("$'" + _targetObjName + "_*_*'"))[1]
						
						if _targetObj != undefined then
						(
							_targetObjTracks = this.getAnimTracks _targetObj
							if _targetObjTracks == undefined then _targetObjTracks = this.getTracks _targetObj true
							
							_trackValues = this.animCopyBuffer_ValuesPerObject[i]
							_originalObjTracks = this.animCopyBuffer_TracksPerObject[i]
							
							if (_targetObjTracks != undefined) and (_trackValues.count == _targetObjTracks.count) then
							(
								for j = 1 to _targetObjTracks.count where _targetObjTracks[j].type != #separator do
									case type of
									(
										#posture: _targetObjTracks[j].track.value = _trackValues[j]
										#track: lb.controller.copyPasteAnimation _originalObjTracks[j].track.controller _targetObjTracks[j].track.controller 
									)
							)
						)
					)
				)
			)
			
			
			completeRedraw()
		),

		------------------------------------------------
		--@fn: undefined | pasteOppositeAnimTracks | Pega los valores copiados en las mismas pistas de las que se copió en este u otro objeto, en el elemento simétrico opuesto del asset.
		--@gets: (opt)name | type |  #posture, #track -- para pegar la animacion del track entero o solo de la pose. Por defecto #posture
		------------------------------------------------
		fn pasteOppositeAnimTracks type:#posture =
		(
			_pasteString = "Paste " + (type as string)
			_selAssets = lb.asset.getAssetsFromNodes (getCurrentSelection())
			
			undo _pasteString on
			(
				for _ast in _selAssets do
				(
					for i = 1 to this.animCopyBuffer_ObjectNames.count do
					(
						_srcObjName = this.animCopyBuffer_ObjectNames[i]
						
						--	buscamos el objeto destino para el asset seleccionado
						_oppositeObjName = lb.nc.getOppositeObjectName _srcObjName
						
						if _oppositeObjName != undefined then
						(
							_oppositeObjName = lb.nc.replaceNamePart _oppositeObjName 1 _ast.type
							_oppositeObjName = lb.nc.replaceNamePart _oppositeObjName 2 _ast.name
							_oppositeObjName = lb.nc.getSimpleObjectName _oppositeObjName
							_oppositeObj = (execute ("$'" + _oppositeObjName + "_*_*'"))[1]
						)
						
						if _oppositeObj != undefined then
						(
							_targetObjTracks = this.getAnimTracks _oppositeObj
							if _targetObjTracks == undefined then _targetObjTracks = this.getTracks _oppositeObj true
							
							_trackValues = this.animCopyBuffer_ValuesPerObject[i]
							_originalObjTracks = this.animCopyBuffer_TracksPerObject[i]
							
							--	nos aseguramos de que el objeto tiene tracks
							if (_targetObjTracks != undefined) and (_trackValues.count == _targetObjTracks.count) then
							(
								for j = 1 to _targetObjTracks.count where _targetObjTracks[j].type != #separator do
								(
									_targetTrack = _targetObjTracks[j]
									
									-- Si el opuesto es una pieza central
									if lb.nc.getNamePart _oppositeObj.name 4 != lb.nc.NC_locationMiddle then
									(
										case type of
										(
											#posture:	_targetTrack.track.value = _trackValues[j]
											#track: lb.controller.copyPasteAnimation _originalObjTracks[j].track.controller _targetTrack.track.controller
										)
									)
									--	Si el opuesto es el mismo objeto estamos en una pieza central del cuerpo.
									--	En esete caso copiamos el valor negativo de algunos tracks
									else
									(
										--	Si no es el root, oponemos x_rotation e y_rotation
										if (lb.nc.getNamePart _oppositeObj.name 5 != lb.nc.NC_anim_root) then
										(
											if (matchPattern _targetTrack.name pattern:"transform:*:x_rotation") or (matchPattern _targetTrack.name pattern:"transform:*:y_rotation") then
											(
												case type of
												(
													#posture:	_targetTrack.track.value = -_trackValues[j]	
													#track: lb.controller.copyPasteAnimation _originalObjTracks[j].track.controller _targetTrack.track.controller negative:true
												)
											)
											else
												case type of
												(
													#posture: _targetTrack.track.value = _trackValues[j]
													#track: lb.controller.copyPasteAnimation _originalObjTracks[j].track.controller _targetTrack.track.controller
												)
										)
										else
										(
											if (matchPattern _targetTrack.name pattern:"transform:*:x_rotation") or (matchPattern _targetTrack.name pattern:"transform:*:z_rotation") then
												case type of
												(
													#posture: _targetTrack.track.value = -_trackValues[j]	
													#track: lb.controller.copyPasteAnimation _originalObjTracks[j].track.controller _targetTrack.track.controller negative:true
												)
											else if (matchPattern _targetTrack.name pattern:"transform:*:x_position") then
												case type of
												(
													#posture: _targetTrack.track.value = -_trackValues[j]	
													#track: lb.controller.copyPasteAnimation _originalObjTracks[j].track.controller _targetTrack.track.controller negative:true
												)
											else
												case type of
												(
													#posture: _targetTrack.track.value = _trackValues[j]
													#track: lb.controller.copyPasteAnimation _originalObjTracks[j].track.controller _targetTrack.track.controller
												)
										)
									)
								)
							)
						)
					)
				)
			)
			
			completeRedraw()
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
	)--lib_animInfo
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_animInfo() --crea la libreria
)