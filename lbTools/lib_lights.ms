------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria Lights
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lights | Contiene la libreria de lights.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_lights
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria con funciones para lights",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		silhouetteToggleVisualStyleModeBackup = #Shaded,
		silhouetteToggleLightOptionBackup = #SceneLight,	

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------

		---------------------------------------------------------------------------
		--devuelve un array con todas las luces de la escena
		--el orden el el array será por tipo de luz por defecto. ORDERFILTER:#classof
		--si ORDERFILTER es #name, las devuelve ordenadas por nombre
		--si IGNORETARGETS es TRUE no incluye los targets en el array
		---------------------------------------------------------------------------
		fn getSceneLights orderFilter:#classof ignoreTargets:true ignoreXrefLights:false ignoreLightSystems:true =
		(
			sceneLights = #() --aray para almacenar las luces
			auxLights = lights as array --obtiene las luces de la escena
			
			if ignoreTargets then --si hay que ignorar los targets
				for i = auxLights.count to 1 by -1 where classof auxLights[i] == Targetobject do --elimina los targets
					deleteItem auxLights i		
			
			if ignoreXrefLights then --si hay que ignorar los targets
				for i = auxLights.count to 1 by -1 where classof auxLights[i] == XrefObject do --elimina las luces Xref
					deleteItem auxLights i	
			
			if not ignoreLightSystems then
			(
				for o in objects do
				(
					--Buscamos los compass
					if classof o == Compass then
					(
						_lightCompass = false
						for i=1 to o.children.count do
						(
							--Si mi compass forma parte de un sistema lo añadiré junto con sus hijos 
							if classof o.children[i] == DaylightAssemblyHead or superclassof o.children[i] == light then
							(
								_lightCompass = true
								append auxLights o.children[i]
								for j=1 to o.children[i].children.count do
									if superclassof o.children[i].children[j] == light then
										append auxLights o.children[i].children[j]
							)
						)
						if _lightCompass then
							append auxLights o
					)
				)
				auxLights = makeUniqueArray auxLights
			)
			case orderFilter of
			(
				#classof:	sceneLights = lb.misc.sortNodesByClassof auxLights
				#name:		sceneLights = lb.misc.sortNodesByName auxLights
			)
			
			sceneLights --devuelve el array
		),--fn getSceneLights	

		------------------------------------------------
		--SETS
		------------------------------------------------

		------------------------------------------------
		--OTHER
		------------------------------------------------

		fn deleteAllLights = 
		(
			-- variables y arrays
			lightsInScene = #()
			
			-- selecciona los objetos de la escena y si son luces lo mete en el array
			for o in objects do if (superclassof o) == light do 
			(
				append lightsInScene o
				print ("Deleted light: " + o.name)
			)
			-- eliminamos las luces de la escena
			delete lightsInScene
		),

		------------------------------------------------
		--@fn: undefined | exportLights | Exporta todas las luces(o las selecionadas) a un arhivo .lght.
		--@gets: string | file | Archivo donde se va a guardar la exportacion.
		--@gets: boolean | selected | Indica si usar la seleccion de la escena o todas las luces de la misma.
		--@gets: string | reOpen | Re abre el archivo para recuperar lo eliminado.
		------------------------------------------------
		fn exportLights file selected reOpen =
		(	
			_result = #error
			selObjs = getCurrentSelection() --almacena la seleccion actual
			nodesToExport = this.getSceneLights ignoreTargets:false --obtiene las luces de la escena con sus targets
			
			--si solo hay que exportar las luces seleccionadas, elimina las no seleccionadas del array
			if selected then
			(
				--elimina las luces no seleccionadas del array
				for i=nodesToExport.count to 1 by -1 where (findItem selObjs nodesToExport[i]) == 0 do
					deleteItem nodesToExport i
				
				--si hay alguna luz en el array cuyo padre sea un DaylightAssemblyHead, lo añade al array
				for n in nodesToExport where n.parent != undefined and classof n.parent == DaylightAssemblyHead do
					append nodesToExport n.parent
				
				--si hay alguna luz en el array cuyo padre sea un compass, lo añade al array
				for n in nodesToExport where n.parent != undefined and classof n.parent == Compass do
					append nodesToExport n.parent
					
				--si hay algun compass seleccionado cuyos hijos son luces, añade el compass y sus hijos al array
				for obj in selObjs where classof obj == Compass and obj.children.count != 0 do
				(
					added = false --indica si se ha añadido alguno de los hijos del compass al array
					
					for ch in obj.children where (superClassOf ch == light) or (classof ch == DaylightAssemblyHead) do
					(
						appendIfUnique nodesToExport ch --añade la luz o el sistema al array
						added = true
						
						--si es un sistema hay que añadir todas las luces de ese sistema al array
						if classof ch == DaylightAssemblyHead then
							for chl in ch.children where superClassOf chl == light do
								appendIfUnique nodesToExport chl
					)--for				
					
					--si se ha añadido alguno de los hijos del compass al array entonces añadimos el compas al array en caso de que no estuviera ya.
					if added then appendIfUnique nodesToExport obj
				)--for
				
				--para cada luz que está en el array, si tiene target y no está en array lo añade
				for n in nodesToExport where superClassOf n == light and n.target != undefined do
					appendIfUnique nodesToExport n.target
				
				--si hay algun target seleccionado y su luz no está en el array, añade los dos al array
				for obj in selObjs where (findString obj.name ".Target" != undefined) and (findItem nodesToExport (refs.dependentNodes obj firstOnly:true) == 0) do
				(
					appendIfUnique nodesToExport obj
					append nodesToExport (refs.dependentNodes obj firstOnly:true)
				)--for
				
			) --if rdoExportImportOptions == 1 ----------------------------------------------------------
			else --if rdoExportImportOptions == 2 -----------------------------------------------------
			(
				--añade los compass de sistemas de luces
				compasObjs = getClassInstances Compass
				for cp in compasObjs do
				(
					aux = refs.dependentNodes cp firstOnly:true
					if aux.children.count == 1 and ((superclassof aux.children[1] == light) or (classof aux.children[1] == DaylightAssemblyHead)) then
						appendIfUnique nodesToExport aux
				)
				
				--añade los sistemas que aún no estén
				dayLights = getClassInstances DaylightAssemblyHead
				for dl in dayLights do
					appendIfUnique nodesToExport (refs.dependentNodes dl firstOnly:true)
			)--if rdoExportImportOptions == 2
			--------------------------------------------------------------------------------------------------------------------------------------------
				
			--------------------------------------------------------------------------------------------------------------------------------------------
			--almacena las propiedades especiales de la luz, como Include/Excludes, que se pierden al guardar la luz aislada, para restarurarlo al importar
			
			--recorre los nodos a exportar y salva esas propiedades
			for n in nodesToExport where isproperty n #excludeList do
			(
				--obtiene el tipo de include/exclude y si tiene objetos en incluidos o excluidos los aisla
				includeExcludeType = if n.excludeList != undefined then "Exclude" else "Include"
				includeExcludeObjs = if includeExcludeType != "Include" then n.excludeList else n.includeList
				if includeExcludeObjs.count != 0 then includeExcludeObjs = for ieo in includeExcludeObjs collect ieo.name
				
				--almacena el tipo de include/exclude y los nombres de los objetos excluidos/incluidos
				setUserProp n "includeExcludeType" includeExcludeType
				with printAllElements on setUserProp n "includeExcludeObjs" (includeExcludeObjs as string)
			)
			--------------------------------------------------------------------------------------------------------------------------------------------
			
			--------------------------------------------------------------------------------------------------------------------------------------------
			--elimina de la escena cualquier objeto que no se vaya a exportar, porque se ha visto que con
			--personajes en la escena, sus piezas de rig hacen que se bloquee MAX en el savenodes. El motivo no
			--se ha conseguido deducir, por eso primero eliminamos todo
			
			--recopila lo nodos a eliminar
			if reOpen then
			(
				nodesToDelete = for o in objects where (findItem nodesToExport o) == 0 collect o
				delete nodesToDelete --elimina los nodos
			)
			--------------------------------------------------------------------------------------------------------------------------------------------
			
			--------------------------------------------------------------------------------------------------------------------------------------------
			--exporta las luces en el archivo
			_result = if ((saveNodes nodesToExport file) == OK) then #success else #error
			if (_result == #success) and (nodesToExport.count == 0) then _result = #noLights

			--------------------------------------------------------------------------------------------------------------------------------------------
			
			--reabre el mismo archivo actual para recuperar lo eliminado-----------------------------
			if reOpen then loadMaxFile (maxFilePath + maxFileName)
			-----------------------------------------------------------------------------------------------
			
			--------------------------------------------------------------------------------------------------------------------------------------------
			--borra las propiedades que hemos almacenado antes de forma temporal
			
			--recorre los nodos a exportar y salva esas propiedades
			for n in nodesToExport where isproperty n #excludeList do
			(
				--almacena el tipo de include/exclude y los nombres de los objetos excluidos/incluidos
				setUserProp n "includeExcludeType" ""
				setUserProp n "includeExcludeObjs" ""
			)
			--------------------------------------------------------------------------------------------------------------------------------------------
			
			setArrowCursor() --pone el cursor de flecha
			_result
		),

		------------------------------------------------
		--@fn: undefined | exportLights | Exporta todas las luces(o las selecionadas) a un arhivo .lght.
		--@gets: string | file | Archivo donde se va a guardar la exportacion.
		--@gets: boolean | selected | Indica si usar la seleccion de la escena o todas las luces de la misma.
		--@opt: boolean | properties | true | Contiene las lights properties de las luces a importar/exportar.
		--@opt: boolean | transform | true | Contiene la propiedad transform de las luces de la escena.
		--@opt: boolean | includeExclude | true | Esta propiedad tiene guarado los includes excludes de las luces y objetos.
		--@opt: boolean | overwriteXref | false | Sobreescribe las luces si hay algunas importadas con xRef.
		------------------------------------------------
		fn importLights file selected properties:true transform:true includeExclude:true overwriteXref:false  = 
		(	
			_result = #error
			lastUsedPath = getFilenamePath file --almacena el ultimo path usado
			setWaitCursor() --pone el cursor de espera
			selObjs = getCurrentSelection() --almacena la seleccion actual
			
			--------------------------------------------------------------------------------------------------------------------------------------------
			--almacena algunos valores de las luces antes de cargar la nuevas por si no hay que sobreescribirlos
			--almacena la transformacion de cada luz y cada target
			--almacena los includes y excludes de cada target
			
			--transformaciones------------------------------------------------------------------------------------
			lightsTransforms = #() --array para almacenar las transformaciones de cada luz. Almacena por pares el nombre de la luz y su transform
			
			--recopila las luces----------------------------------------------------
			sceneLights = this.getSceneLights ignoreTargets:false --obtiene las luces de la escena con sus targets
			
			--añade los compass de sistemas de luces
			compasObjs = getClassInstances Compass
			for cp in compasObjs do
			(
				aux = refs.dependentNodes cp firstOnly:true
				if aux.children.count == 1 and ((superclassof aux.children[1] == light) or (classof aux.children[1] == DaylightAssemblyHead)) then
					appendIfUnique sceneLights aux
			)--for
			
			--añade los sistemas que aún no estén
			dayLights = getClassInstances DaylightAssemblyHead
			for dl in dayLights do
				appendIfUnique sceneLights (refs.dependentNodes dl firstOnly:true)
			-------------------------------------------------------------------------
			
			--almacena cada par #(nombreLuz, matrix3)
			for sl in sceneLights where (classof sl.parent != DaylightAssemblyHead) do
				append lightsTransforms #(sl.name, sl.transform)
			
			---------------------------------------------------------------------------------------------------------
			
			--includes----------------------------------------------------------------------------------------------
			lightsIncludeExcludes = #() --array donde almacenar los includes actuales de las luces
			sceneLights = this.getSceneLights() --recopila las luces
			
			for sl in sceneLights where isproperty sl #excludeList do --recorre las luces almacenando los include/excludes
				append lightsIncludeExcludes #(sl.name, (if sl.excludeList != undefined then "Exclude" else "Include"), (if sl.excludeList != undefined then sl.excludeList else sl.includeList))
			---------------------------------------------------------------------------------------------------------
			
			--------------------------------------------------------------------------------------------------------------------------------------------
			--obtiene los objetos de Xref antes de importar ninguna luz para poder compararlos luego y actualizarlos o no
			xrefObjectsBefore = getClassInstances XRefObject
			for i= 1 to xrefObjectsBefore.count do xrefObjectsBefore[i] = refs.dependentNodes xrefObjectsBefore[i] firstOnly:true
					
			--------------------------------------------------------------------------------------------------------------------------------------------
			--si solo hay que importar las luces seleccionadas, elimina las no seleccionadas del array
			if selected then
			(
				--obtiene los nombres de los nodos a importar, para que solo traiga esas luces
				-----------------------------------------------------------------------------------------------------------
				
				selObjs = getCurrentSelection() --almacena la seleccion actual
				nodesToImport = this.getSceneLights ignoreTargets:false --obtiene las luces de la escena con sus targets
				
				--elimina las luces no seleccionadas del array
				for i=nodesToImport.count to 1 by -1 where (findItem selObjs nodesToImport[i]) == 0 do
					deleteItem nodesToImport i
				
				--si hay alguna luz en el array cuyo padre sea un DaylightAssemblyHead, lo añade al array
				for n in nodesToImport where n.parent != undefined and classof n.parent == DaylightAssemblyHead do
					append nodesToImport n.parent
				
				--si hay alguna luz en el array cuyo padre sea un compass, lo añade al array
				for n in nodesToImport where n.parent != undefined and classof n.parent == Compass do
					append nodesToImport n.parent
					
				--si hay algun compass seleccionado cuyos hijos son luces, añade el compass y sus hijos al array
				for obj in selObjs where classof obj == Compass and obj.children.count != 0 do
				(
					added = false --indica si se ha añadido alguno de los hijos del compass al array
					
					for ch in obj.children where (superClassOf ch == light) or (classof ch == DaylightAssemblyHead) do
					(
						appendIfUnique nodesToImport ch --añade la luz o el sistema al array
						added = true
						
						--si es un sistema hay que añadir todas las luces de ese sistema al array
						if classof ch == DaylightAssemblyHead then
							for chl in ch.children where superClassOf chl == light do
								appendIfUnique nodesToImport chl
					)--for				
					
					--si se ha añadido alguno de los hijos del compass al array entonces añadimos el compas al array en caso de que no estuviera ya.
					if added then appendIfUnique nodesToImport obj
				)--for
				
				--para cada luz que está en el array, si tiene target y no está en array lo añade
				for n in nodesToImport where superClassOf n == light and n.target != undefined do
					appendIfUnique nodesToImport n.target
				
				--si hay algun target seleccionado y su luz no está en el array, añade los dos al array
				for obj in selObjs where (findString obj.name ".Target" != undefined) and (findItem nodesToImport (refs.dependentNodes obj firstOnly:true) == 0) do
				(
					appendIfUnique nodesToImport obj
					append nodesToImport (refs.dependentNodes obj firstOnly:true)
				)--for
				--------------------------------------------------------------------------------------------------------
			
				if not overwriteXref then --si no hay que importar las luces de xref
					for i=nodesToImport.count to 1 by -1 where classof nodesToImport[i] == XRefObject do
					(
						deleteItem nodesToImport i
					)--for
				
				--------------------------------------------------------------------------------------------------------
				--mergea en la escena las luces que se correspondan con las seleccionadas
				
				if nodesToImport.count != 0 then --si hay nodos seleccionados intenta importar
				(
					--recopila los nombres de los objetos
					nodesToImportNames = for n in nodesToImport collect n.name
					
					_result = mergeMAXfile file nodesToImportNames #deleteOldDups #useSceneMtlDups #alwaysReparent quiet:true
				)--if --deleteOldDups
				
			) --if rdoExportImportOptions == 1 ----------------------------------------------------------
			else --if rdoExportImportOptions == 2 -----------------------------------------------------
			(
				fileNames = getMaxFileObjectNames file quiet:true --obtiene los nombres de los objetos del archivo
				
				if not overWriteXref then --si no hay que importar las luces de xref
				(
					xrefClassInstances = getClassInstances XRefObject --obtiene las instancias de xref que haya en la escena
					print xrefClassInstances.count
					for xr in xrefClassInstances do --recorre las instancias de xref
					(
						xr = refs.dependentNodes xr firstOnly:true --obtiene el objeto xref
						
						if xr != undefined then --si ha conseguido obtener el objeto xref
						(
							index = findItem fileNames xr.name --mira a ver si hay un objeto con el mismo nombre en el archivo a importar
							if index != 0 then deleteItem fileNames index --si hay uno elimina ese objeto de la lsita de carga
						)--if
					)--for
				)--if
				
				--importa las luces del archivo y pregunta si sustituir si hay coincidencias
				_result = mergeMAXfile file fileNames #deleteOldDups #deleteOldDups #alwaysReparent quiet:true
				
			)--if rdoExportImportOptions == 2
			--------------------------------------------------------------------------------------------------------------------------------------------
			
			--A veces al importar, los DaylightAssemblyHead no se sustituyen bien, por lo tanto tenemos que eliminar los viejos
			dayLights = getClassInstances DaylightAssemblyHead
			for i=1 to dayLights.count do dayLights[i] = (refs.dependentNodes dayLights[i] firstOnly:true)
			for i=dayLights.count to 1 by -1 where dayLights[i].parent == undefined and dayLights[i].children.count == 0 do
				delete dayLights[i]
			--------------------------------------------------------------------------------------------------------------------------------------------
			
			--------------------------------------------------------------------------------------------------------------------------------------------
			--si se cargan luces que estuviesen por Xref, al hacerlo se quedan como aspas en el 0,0,0 sin actualizar
			--if chkXrefLights.checked then --si no habia que importar luces de Xref, no hay que actualizarlas
			--(
				xrefClassInstances = getClassInstances XRefObject --obtiene las instancias de xref que haya en la escena
				max modify mode --se coloca en el panel de modificadores
				
				if xrefClassInstances.count != 0 then --si ha obtenido instacias de xref
				(
					stop = false --flag de parada
					
					avBckp = viewport.activeViewport --obtiene el viewport activo
					
					--desactiva el hardware shading de todos los viewports porque si no max se cierra con las luces Xref
					for i=1 to viewport.numViews do
					(
						viewport.activeViewport = i
						vss = maxops.getViewportShadingSettings()
						vss.ActivateViewportShading = false
					)--for
					
					for xr in xrefClassInstances where not stop do --recorre las instancias de xref
					(
						xr = refs.dependentNodes xr firstOnly:true --obtiene el objeto xref
						
						if superClassOf xr == System then --si es un xref de luz lo actualiza
						(
							select xr
							updateXRef xr
							stop = true
						)--if
					)--for
					
					viewport.activeViewport = avBckp
				)--if
			--------------------------------------------------------------------------------------------------------------------------------------------
			
			--------------------------------------------------------------------------------------------------------------------------------------------
			--restauramos los objetos que estuvieran en el listado de Include/Exclude si así se ha decidido
			--si no, le dejamos lo que tuviera
			if includeExclude then
			(
				--obtenemos las luces de la escena, sin targets para realizar unas operaciones despues del merge
				sceneLights = this.getSceneLights() 
				
				--recorre las luces para restaurarle las propiedades
				for n in sceneLights where isproperty n #excludeList do
				(
					includeExcludeType = getUserProp n "includeExcludeType" --obtiene el tipo de Include/Exclude
					includeExcludeObjs = #() --objetos del listado
					
					if includeExcludeType != undefined and includeExcludeType != "" then --si no está vacío
					(
						auxObjs = getUserProp n "includeExcludeObjs" --obtiene el listado de objetos
						if auxObjs != "#()" then
						(
							--filtra el string del array--------------------------------
							auxObjs = substituteString auxObjs "#(" ""
							auxObjs = substituteString auxObjs ")" ""
							auxObjs = filterString auxObjs ", \""
							
							for aux in auxObjs do
							(
								--si el nombre cumple el naming convention, le quitamos las dos ultimas partes para evitar cambios en los flags
								--esto es porque al exportar a caches, se pone el flag p al final de los nombres, con lo cual los objetos pueden no ser encontrados.
								if lb.nc.ncOK aux then
								(
									nParts = filterString aux "_"
									aux = substituteString aux (nParts[6] + "_" + nParts[7]) "*_*"
								)--if
								
								sceneObj = ((execute ("$'" + aux + "'")) as array)[1] --obtiene el objeto
								
								if isValidNode sceneObj then --si ha encontrado el objeto lo añade al array
									append includeExcludeObjs sceneObj
							)--for
						)--if
						
						--quita la informacion especial de la pieza
						setUserProp n "includeExcludeType" ""
						setUserProp n "includeExcludeObjs" ""
					)--if
					
					case includeExcludeType of
					(
						"Exclude":	n.excludeList = includeExcludeObjs
						"Include":	n.includeList = includeExcludeObjs
					)--case
				)--for sceneLights
			)--if chkIncludeExclude
			else --si no, restaura los include/exludes que pudiera tener la pieza
			(
				for lie in lightsIncludeExcludes do
				(
					lightObj = (execute ("$'" + lie[1] + "'")) --obtiene la luz
						
					case lie[2] of --mira si es include o exclude
					(
						"Exclude": lightObj.excludeList = lie[3]
						"Include": lightObj.includeList = lie[3]
					)--case lie[2]
				)
			)--if chkIncludeExclude
			--------------------------------------------------------------------------------------------------------------------------------------------
			
			--------------------------------------------------------------------------------------------------------------------------------------------
			--si no hay que sobreescribir las transformaciones de las luces, sino que hay que mantenerlas, se las restaura
			if not transform then
				for lt in lightsTransforms do
				(
					lightObj = (execute ("$'" + lt[1] + "'")) --obtiene la luz
					lightObj.transform = lt[2] --restaura la transformacion
				)--for lightsTransforms				
			--------------------------------------------------------------------------------------------------------------------------------------------
				
			setArrowCursor()
			_result
		),


		------------------------------------------------
		--@fn: undefined | setLightsToggleOn | Activa todas las luces de la escena o de la selección.
		--@gets: boolean | state | Estado activado o desactivado al que poner las luces de la escena o de la selección.
		------------------------------------------------
		fn setLightsToggleState state =
		(	
			selObjs = getCurrentSelection() --obtiene la seleccion
			sceneLights = this.getSceneLights() --obtiene las luces de la escena

			if selObjs.count != 0 then --si hay seleccion eliminamos del array de luces las que estén seleccionadas
				for i = sceneLights.count to 1 by -1 where findItem selObjs sceneLights[i] == 0 do
					deleteItem sceneLights i		
			
			if sceneLights.count == 0 then --si no hay ninguna luz seleccionada, lo hacemos para todas
				sceneLights = this.getSceneLights() --obtiene las luces de la escena
				
			if keyboard.shiftPressed then --si CTRL está presionado trabaja con las luces no seleccionadas
			(
				defSceneLights = this.getSceneLights() --obtiene las luces de la escena
				
				for sl in sceneLights do --elimina las luces seleccionadas de defSceneLights
				(
					index = findItem defSceneLights sl --busca el indice
					if index != 0 then deleteItem defSceneLights index --si la luz esta seleccionada la elimina del array
				)--for
				
				sceneLights = defSceneLights --sobreescribe el array
			)--if
				
				--ESTO SE UTILIZABA EN MAX 2010 CUANDO EL REALISTIC NO ESTABA DESAROLLADO.
				--si se van a encender luces y hay más de 5 luces desactiva el hardware shading de todos los viewports
			if sceneLights.count > 5 then
				for i=1 to viewport.numViews do
				(
					viewport.activeViewport = i
					vss = maxops.getViewportShadingSettings()
					vss.ActivateViewportShading = false
				)--for*/
			
			for sl in sceneLights do --recorre las luces y las enciende o apaga
				if classof sl == XrefObject then (sl.GetSrcItem resolveNested:true).on = state
				else sl.on = state
		),

		------------------------------------------------
		--@fn: undefined | silhouetteToggle | Cambia el modo de visualizacion de silueta a modo normal
		------------------------------------------------
		fn silhouetteToggle =
		(
			silhouetteLight = execute "$'silhouetteLight'" --busca en la escena la luz de siluetas
			setAssets = lb.asset.getSceneAssets type:lb.nc.NC_setPrefix --busca los assets de tipo set
			
			afterLights = NitrousGraphicsManager.GetActiveViewportSetting()

			if (silhouetteLight == undefined) or (not isValidNode silhouetteLight) then --crea la luz de siluetas y oculta los sets
			(
				this.silhouetteToggleVisualStyleModeBackup = afterLights.VisualStyleMode
				this.silhouetteToggleLightOptionBackup = afterLights.LightOption

				afterLights.VisualStyleMode = #Realistic
				afterLights.LightOption = #SceneLight

				--almacena las propiedades de las luces antes de desactivarlas
				global lightsStateBckp = #()

				for l in lights where isproperty l #on do
				(
					append lightsStateBckp #(l.name, l.on)
					l.on = false
				)

				silhouetteLight = Omnilight rgb:(color 255 255 255) pos:[0,0,0]
				silhouetteLight.enabled = false
				silhouetteLight.ishidden = true
				silhouetteLight.name = "silhouetteLight"
				
				for ast in setAssets do
					lb.asset.hideAsset ast
			)
			else --elimina la luz de siluetas y muestra de nuevo los sets
			(
				delete silhouetteLight
				
				for ast in setAssets do
					lb.asset.resetAsset ast
				
				--restaura las propiedades de las luces
				if lightsStateBckp != undefined then
					for l in lightsStateBckp do
					(
						obj = execute ("$'" + l[1] + "'")
						if obj != undefined then obj.on = l[2]
					)

				afterLights.VisualStyleMode = this.silhouetteToggleVisualStyleModeBackup
				afterLights.LightOption = this.silhouetteToggleLightOptionBackup
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
		
	)--lib_lights
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_lights() --crea la libreria
)