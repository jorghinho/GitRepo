------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Herramienta para automatizar el proceso de creación y edición de referencias.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Preset Importer Reference Manager Tool"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 600															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 550															--@var: integer | minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		groupbox _gbxFilter "Filter" pos:[10,5] width:580 height:38
		edittext _edtFilter "" pos:[15,20] width:565
		groupbox _gbxAssets "Asset List" pos:[10,45] width:370 height:420
		dotNetControl _charTreeView "System.Windows.Forms.TreeView" pos:[20,65] width:350 height:390 
		groupbox _gbxPreview "Preview" pos:[390,45] width:200 height:210
		button btnCreateRef "Create Reference" pos:[390,260] width:130 height:65
		groupbox gbxFakeButton "" pos:[525,255] width:65 height:70
		spinner spnAmountCopy "x:" pos:[540,285] type:#integer width:45 range:[1,999,1]
		button btnEditRef "Edit Reference" pos:[390,330] width:200 height:65
		button btnUpdateRef "SVN Update Reference Asset" pos:[390,400] width:200 height:65
		bitmap btmShowIcon "" pos:[400,65] width:180 height:180 fileName:"R:\\resource\\technical\\max\\lbTools\\stdplugs\\stdscripts\\lbTools\\image\\lbImages_folder.tif"
		groupbox gbxRandomizer "Randomize Selected References:" pos:[10,470] width:580 height:70
		checkBox cbxPosition "Rnd Pos" pos:[40,490] width:70 checked:false
		checkBox cbxPosX ":X" pos:[110,490] enabled:false
		checkBox cbxPosY ":Y" pos:[145,490] enabled:false
		checkBox cbxPosZ ":Z" pos:[180,490] enabled:false
 		spinner spnPosVariationSt "From" pos:[65,515] enabled:false width:70 range:[-99999,99999,1] type:#float
 		spinner spnPosVariationEnd "To" pos:[145,515] enabled:false width:70 range:[-99999,99999,1] type:#float
		checkBox cbxRotation "Rnd Rot:" pos:[250,490] checked:false
		checkBox cbxRotX ":X" pos:[320,490] enabled:false
		checkBox cbxRotY ":Y" pos:[355,490] enabled:false
		checkBox cbxRotZ ":Z" pos:[390,490] enabled:false
 		spinner spnRotVariationSt "From"  pos:[275,515] enabled:false width:70 range:[-99999,99999,1] type:#float
 		spinner spnRotVariationEnd "To"  pos:[355,515] enabled:false width:70 range:[-99999,99999,1] type:#float
		button btnRandom "Random!" pos:[455,483] width:125 height:50



		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@fn: undefined | updatePreview | Actualiza el bitmap que muestra el sample del asset
		------------------------------------------------	
		fn updatePreview = 
		(
			_selNodeInfo = #()
			if _charTreeView.selectedNode != undefined then 
			(
				--Obtenemos el nodo selecccionado y revisamos su jerarquia en ascendente.
				_theNode = _charTreeView.selectedNode
				append _selNodeInfo _theNode.name			
				--Mientras encontremos padres iremos subiendo en la jerarquia y asi sabremos el nivel en el que nos encontramos, y los sucesivos datos que se almacenan en selnodeinfo.	
				while _theNode.parent != undefined do 
				(
					_theNode = _theNode.parent
					append _selNodeInfo _theNode.name		
				)
				if _selNodeInfo.count > 2 then 
				(
					_assetPath = "y:\\asset\\"
					--Segun se trate de un character o un prop construiremos la siguiente parte.
					case _selNodeInfo[_selNodeInfo.count] of 
					(
						"Characters": _assetPath += "chr\\"
						"Props": _assetPath += "prp\\"
					)
					--Después le sumaremos el subdirectorio, main, secondary...
					_assetPath += _selNodeInfo[(_selNodeInfo.count)-1] + "\\"
					--Aqui viene el nombre principal del asset.
					_assetPath += _selNodeInfo[(_selNodeInfo.count)-2] + "\\"
					--Construimos la ruta al sample de la imagen. (del preset)
					_assetSample = (_assetPath + "image\\sample\\" + _charTreeView.selectedNode.name + "_sample.tif")
					--Si lo encuentra en disco, configuraramos el filename del bitmap al fichero.
					if doesFileExist _assetSample then 
					(
						btmShowIcon.filename = _assetSample
					)
					--Si no hay icono para el preset, buscamos el icono del asset generico.
					else  
					(
						_assetNameParts = FilterString _assetSample "\\"
						_sampleRef = (_assetPath + "image\\sample\\" + _assetNameParts[_assetNameParts.count] + "_sample.tif" )
						if doesFileExist _sampleRef then 
						(
							btmShowIcon.filename = _sampleRef
						)
						else
						(
							--Finalmente si no encontramos nada, pondremos el icono generico para la falta de iconos.
							_sampleRef = "R:\\resource\\technical\\max\\lbTools\\stdplugs\\stdscripts\\lbTools\\image\\lbImages_assetIcons.tif"
							btmShowIcon.filename = _sampleRef
						)
					)
				)
				else btmShowIcon.filename = "R:\\resource\\technical\\max\\lbTools\\stdplugs\\stdscripts\\lbTools\\image\\lbImages_folder.tif"		
			)
			--print btmShowIcon.filename
		)

		------------------------------------------------
		--@fn: array | getCharAssets | Consulta todos los assets de tipo de personaje que hay en y
		--@returns: array | _readAssets |  Array con la información de los assets en disco; Sigue el patrón #(tipo de asset ("main","secondary" o "extra"), #(#(nombreGenericoAsset,#(nombre del preset,Path del prt del asset))))
		------------------------------------------------		
		fn getCharAssets = 
		(
			--Variable en la que almacenaremos los personajes leídos de disco.
			_readAssets = #()
			_animPath = "Y:\\asset\\chr\\"
			_assetTypes = #("main","secondary","extra")
			--Por cada uno de los 3 tipos construiremos los paths respectivos.
			for _assetType in _assetTypes do 
			(
				_readLine = #()
				--En esta array se almacenaran todos los datos de 1 asset leído , nombre del asset y el path al fichero prt
				_readAssetsLine = #()
				--Le sumamos el tipo de asset al path para su ruta.
				_tmpAnimPath = _animPath + _assetType + "\\*"
				--Conseguimos todas las carpetas que cuelgan del tipo de asset (Que seran todos los personajes de ese tipo, la estructura principal.)
				_folders = getDirectories _tmpAnimPath
				for _folder in _folders do 
				(
					folderNameParts = FilterString _folder "\\"
					--Obtenemos el nombre del asset. se construye como tipo del nombre de personaje, por ejemplo chr_amy
					_currChar = folderNameParts[folderNameParts.count]
					--Bucamos todos los presets de animación de cada una de las carpetas.
					_doubleTmpAnimPath = _folder + "\\version\\preset\\*_anim_*.prt"
					_files = getFiles _doubleTmpAnimPath
					_filePresets = #()
					_appendOneElements = #()
					for _file in _files do 
					(
						_readLine = #()
						_fileNameParts = FilterString _file "\\"
						_fileNameFile = FilterString _fileNameParts[_fileNameParts.count] "_"
						--El nombre de la referencia, se construye con el tipo de nombre y el nombre del  preset. por ejemplo chr_amy{astronaut-noBagNoGlove}
						_theFile = _fileNameFile[1] + "_" + _fileNameFile[2] 
						if appendIfUnique _appendOneElements _theFile do 
						(
							append _readLine _theFile
							append _readLine _file
							append _filePresets _readLine
							--Primera array #(nombrePreset,pathPreset)
						)
					)
					append _readAssetsLine #( _currChar , _filePresets)
					--Segunda array #(nombreGenericoPersonaje,#(primera Array))
				)
				append _readAssets #(_assetType,_readAssetsLine)
				--Tercera array #(tipo de personaje,#(segunda Array))
			)
			--Devolvemos los assets consultados.
			_readAssets
		)

		------------------------------------------------
		--@fn: array | getPrpAssets | Consulta todos los assets de tipo prop que hay en y
		--@returns: array | _readAssets |  Array con la información de los assets en disco; Sigue el patrón #(tipo de asset ("main","secondary" o "extra"), #(#(nombreGenericoAsset,#(nombre del preset,Path del prt del asset))))
		------------------------------------------------	
		fn getPrpAssets = 
		(
			--Variable en la que almacenaremos los personajes leídos de disco.
			_readAssets = #()
			_animPath = "Y:\\asset\\prp\\"
			_assetTypes = #("misc","miscChr","vehicle","weapon")
			--Por cada uno de los 4 tipos construiremos los paths respectivos.
			for _assetType in _assetTypes do 
			(
				_readLine = #()
				--En esta array se almacenaran todos los datos de 1 asset leído , nombre del asset y el path al fichero prt
				_readAssetsLine = #()
				--Le sumamos el tipo de asset al path para su ruta.
				_tmpAnimPath = _animPath + _assetType + "\\*"
				--Conseguimos todas las carpetas que cuelgan del tipo de asset (Que seran todos los personajes de ese tipo, la estructura principal.)
				_folders = getDirectories _tmpAnimPath
				for _folder in _folders do 
				(
					folderNameParts = FilterString _folder "\\"
					--Obtenemos el nombre del asset. se construye como tipo del nombre de personaje, por ejemplo prp_brush
					_currChar = folderNameParts[folderNameParts.count]
					--Bucamos todos los presets de animación de cada una de las carpetas.
					_doubleTmpAnimPath = _folder + "\\version\\preset\\*_anim_*.prt"
					_files = getFiles _doubleTmpAnimPath
					_filePresets = #()
					_appendOneElements = #()
					for _file in _files do 
					(
						_readLine = #()
						_fileNameParts = FilterString _file "\\"
						_fileNameFile = FilterString _fileNameParts[_fileNameParts.count] "_"
						--El nombre de la referencia, se construye con el tipo de nombre y el nombre del  preset. por ejemplo prp_brush{std-std}
						_theFile = _fileNameFile[1] + "_" + _fileNameFile[2] 
						if appendIfUnique _appendOneElements _theFile do 
						(
							append _readLine _theFile
							append _readLine _file
							append _filePresets _readLine
							--Primera array #(nombrePreset,pathPreset)
						)
					)
					append _readAssetsLine #( _currChar , _filePresets)
					--Segunda array #(nombreGenericoPersonaje,#(primera Array))
				)
				append _readAssets #(_assetType,_readAssetsLine)
				--Tercera array #(tipo de personaje,#(segunda Array))
			)
			--Devolvemos los assets consultados.
			_readAssets
		)

		------------------------------------------------
		--@fn: undefined | updateAssetList | Variable que repinta el contenido del treeView con los assets en el disco.
		--@gets: name | mode | Modo de update #initialize: se rellena la lista completa, #filter: se rellan solo los elementos que siguen el patron del campo filtro.
		------------------------------------------------
		fn updateAssetList mode:#initialize=
		(
			--Buscamos todos los presets de anim de la producción!
			--Characters
			_allCharAssets = getCharAssets()
			--Props
			_allProp = getPrpAssets()

			--Limpiamos los nodos del árbol para poder volver a rellenarlos
			_charTreeView.nodes.clear()
			--En el caso que el editText este vacío, no buscaremos coincidencias con él, sinó que consultaremos todos los ficheros.
			if _edtFilter.text == "" do mode = #initialize

			case mode of 
			(
				#initialize:
				(
					--Construimos el nodo del que colgarán todos los personajes
					_char = dotnetObject "System.Windows.Forms.TreeNode" "Characters"
					--Asignamos un nombre al nodo.
					_char.name = "Characters"
					--Lo añadimos a la jerarquia, colgando del root.
					_charTreeView.nodes.add _char

					for _assetGroup in _allCharAssets do 
					(
						--Por Cada tipo de asset _assetGroup ("main","secondary","extra"), generamos un nodo, con el tipo.
						_charType = dotnetObject "System.Windows.Forms.TreeNode" _assetGroup[1]
						_charType.name = _assetGroup[1]
						--Añadimos el nodo al anterior de personajes.
						_char.nodes.add _charType
						for _character in _assetGroup[2] do 
						(
							--Por Cada carpeta de asset en _assetGroup, generamos un nodo, con el nombre simple del asset.
							_charName = dotnetObject "System.Windows.Forms.TreeNode" _character[1]
							_charName.name = _character[1]
							--Añadimos el nodo al anterior de tipos.
							_charType.nodes.add _charName
							for _preset in  _character[2] do 
							(
								--Por Cada preset de anim _assetGroup, generamos un nodo, con el nombre del preset del asset.
								_charPreset = dotnetObject "System.Windows.Forms.TreeNode" _preset[1]
								_charPreset.name = _preset[1]
								--Añadimos el nodo al anterior de carpetas de personajes.
								_charName.nodes.add _charPreset
							)
						)
					)
					
					--Construimos el nodo del que colgarán todos los props
					_prop = dotnetObject "System.Windows.Forms.TreeNode" "Props"
					--Asignamos un nombre al nodo.
					_prop.name = "Props"
					--Lo añadimos a la jerarquia, colgando del root.
					_charTreeView.nodes.add _prop

					for _assetGroup in _allProp do 
					(
						--Por Cada tipo de asset _assetGroup ("vehicle","weapon","misc","miscChr"), generamos un nodo, con el tipo.
						_propType = dotnetObject "System.Windows.Forms.TreeNode" _assetGroup[1]
						_propType.name = _assetGroup[1]
						--Añadimos el nodo al anterior de personajes.
						_prop.nodes.add _propType
						for _theProp in _assetGroup[2] do 
						(
							--Por Cada carpeta de asset en _assetGroup, generamos un nodo, con el nombre simple del asset.
							_propName = dotnetObject "System.Windows.Forms.TreeNode" _theProp[1]
							_propName.name = _theProp[1]
							--Añadimos el nodo al anterior de tipos.
							_propType.nodes.add _propName
							for _preset in  _theProp[2] do 
							(
								--Por Cada preset de anim _assetGroup, generamos un nodo, con el nombre del preset del asset.
								_propPreset = dotnetObject "System.Windows.Forms.TreeNode" _preset[1]
								_propPreset.name = _preset[1]
								--Añadimos el nodo al anterior de carpetas de personajes.
								_propName.nodes.add _propPreset
							)
						)
					)
				)
				#filter: 
				(
					--Hay que realizar el mismo proceso filtrando los assets, si no hay ninguna concordancia de preset, no escribiremos el registro, la estructura de character/prop, main ... la mantendremos.
					_char = dotnetObject "System.Windows.Forms.TreeNode" "Characters"
					_char.name = "Characters"
					_charTreeView.nodes.add _char

					_tmpAssets = #()
					for _assetGroup in _allCharAssets do 
					(
						_tmpAssets = #()
						_charType = dotnetObject "System.Windows.Forms.TreeNode" _assetGroup[1]
						_charType.name = _assetGroup[1]
						_char.nodes.add _charType
						for _character in _assetGroup[2] do 
						(
							_charName = dotnetObject "System.Windows.Forms.TreeNode" _character[1]
							_charName.name = _character[1]
			
							for _preset in  _character[2] do 
							(
								_charPreset = dotnetObject "System.Windows.Forms.TreeNode" _preset[1]
								_charPreset.name = _preset[1]
								--Si el nombre del registro del preset cumple el patrón del filtro lo añadiremos a la jerarquia.
								if matchpattern _charPreset.name pattern: ("*"+_edtFilter.text+"*") do 
								(
									_charName.nodes.add _charPreset
								)
							)
							if _charName.nodes.count > 0 do _charType.nodes.add _charName
						)
					)

					_prop = dotnetObject "System.Windows.Forms.TreeNode" "Props"
					_prop.name = "Props"
					_charTreeView.nodes.add _prop

					for _assetGroup in _allProp do 
					(
						_propType = dotnetObject "System.Windows.Forms.TreeNode" _assetGroup[1]
						_propType.name = _assetGroup[1]
						_prop.nodes.add _propType
						for _theProp in _assetGroup[2] do 
						(
							_propName = dotnetObject "System.Windows.Forms.TreeNode" _theProp[1]
							_propName.name = _theProp[1]

							for _preset in  _theProp[2] do 
							(
								_propPreset = dotnetObject "System.Windows.Forms.TreeNode" _preset[1]
								_propPreset.name = _preset[1]
								--Si el nombre del registro del preset cumple el patrón del filtro lo añadiremos a la jerarquia.
								if matchpattern _propPreset.name pattern: ("*"+_edtFilter.text+"*") do 
								(
									_propName.nodes.add _propPreset
								)
							)
							if _propName.nodes.count > 0 do _propType.nodes.add _propName
						)
					)
					--Para agilizar la busqueda y no tener que ir expandiendo dejamos todos los nodos filtrados expandidos accesibles.
					_charTreeView.expandAll()
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | createShape | Se crea una nueva referencia dado un asset detereninado.
		--@gets: string | assetName | El nombre del asset, que será el del shape de referencia.
		--@gets: string | assetPath | El path al asset.
		------------------------------------------------
		fn createShape assetName assetPath = 
		(
			for i = 1 to spnAmountCopy.value do 
			(
				--Creación del shape, en el 0 del mundo.
				sp = splineShape()
				addnewSpline sp
				--Todos los shapes tendran las mismas dimensiones.
				addKnot sp 1 #corner #line [-45,-60,0]
				addKnot sp 1 #corner #line [-45,60,0]
				addKnot sp 1 #corner #line [90,0,0]
				--Cerramos el spline
				close sp 1
				--Actualizamos el shape en viewport.
				updateShape sp
				--Dejamos el shape de color amarillo.
				sp.wirecolor = (color 255 255 0)
				--Configuramos el nombre de la referencia con el nombre del asset (van a haber duplicados, no hay problema)
				sp.name = assetName
				--Añadimos un modificador XForm a la mezcla
				_xform = XForm()
				addModifier sp _xform
				--Creación del plano, Con la textura vinculado al shape.
				thePlane = plane()
				thePlane.length = 180
				thePlane.width = 180
				--Rotamos el plano para que las texturas se apliquen correctamente.
				thePlane.rotation = (eulerAngles -90 -90 0)
				--Levantamos el plano para que quede a nivel del shape.
				thePlane.position.z = 180/2
				--Le añadimos otro modificador Xform al plano.
				_xform = XForm()
				addModifier thePlane _xform
				--Vinculamos el plano al spline de referencia.
				thePlane.parent = sp
				--Renombramos el plano
				thePlane.name = assetName + "_plane"
				--Hacemos que no se vean los planos en gris cuando se freezean
				thePlane.showFrozenInGray = off
				--freezeamos el plano
				thePlane.isFrozen = true 

				--Configuraremos el material para que se vea en el sample.
				planeMaterial =  standard()
				planeMaterial.name = assetName
				--Configurar el show shaded material in viewport 
				planeMaterial.showInViewport = on
				--Asignamos el material al plano.
				thePlane.material = planeMaterial
				--Primero Buscamos el sample para el preset.
				_sampleRef = (assetPath + "image\\sample\\" + assetName )
				_sampleRef += "_sample.tif"
				--Si no hay icono para el preset, buscamos el icono del asset generico.
				if not doesFileExist _sampleRef do 
				(
					_assetNameParts = FilterString assetpath "\\"
					_sampleRef = (assetPath + "image\\sample\\" + _assetNameParts[_assetNameParts.count] + "_sample.tif" )
				)
				--Si no generamos un plano con el icono por defecto de falta de asset.
				if not doesFileExist _sampleRef do 
				(
					_sampleRef = "R:\\resource\\technical\\max\\lbTools\\stdplugs\\stdscripts\\lbTools\\image\\lbImages_assetIcons.tif"
				)
				--Configuramos los canales de difusa y opacidad para que tengan un bitmaptexture, que sera el sample.
				planeMaterial.diffuseMap = Bitmaptexture fileName: _sampleRef
				planeMaterial.opacityMap = Bitmaptexture fileName: _sampleRef

				--Configurar el rgb CHannel output del canal de opacidad a alpha as gray
				planeMaterial.maps[7].rgbOutput = 1
			)
		)

		------------------------------------------------
		--@fn: undefined | editRef | Permite intercambiar una referencia a un elemento por otra, actualizando la información de nombre y el plano.
		------------------------------------------------
		fn editRef =
		(
			--La edición se hace solo de un elemento.
			if selection.count == 1 then 
			(
				_selectedNode = selection[1]
				_shapeNameParts = FilterString _selectedNode.name "_"
				--Las referencias seleccionadas deben tener 2 partes, tener al menos un hijo (el plano), y empezar por chr, o prp, sinó no se efectua la operación de actualizado.
				if _selectedNode.children.count >= 1 and _shapeNameParts.count == 2  and ((_shapeNameParts[1]==lb.nc.NC_chrPrefix) or (_shapeNameParts[1]==lb.nc.NC_prpPrefix)) then 
				(
					_theNode = _charTreeView.selectedNode
					if _theNode != undefined then 
					(
						_selNodeInfo = #()
						
						--Obtenemos el nodo selecccionado y revisamos su jerarquia en ascendente.
						append _selNodeInfo _theNode.name			
						--Mientras encontremos padres iremos subiendo en la jerarquia y asi sabremos el nivel en el que nos encontramos, y los sucesivos datos que se almacenan en selnodeinfo.	
						while _theNode.parent != undefined do 
						(
							_theNode = _theNode.parent
							append _selNodeInfo _theNode.name		
						)
						if _selNodeInfo.count == 4 then 
						(
							_assetPath = "y:\\asset\\"
							--Segun se trate de un character o un prop construiremos la siguiente parte.
							case _selNodeInfo[_selNodeInfo.count] of 
							(
								"Characters": _assetPath += "chr\\"
								"Props": _assetPath += "prp\\"
							)
							--Después le sumaremos el subdirectorio, main, secondary...
							_assetPath += _selNodeInfo[(_selNodeInfo.count)-1] + "\\"
							--Aqui viene el nombre principal del asset.
							_assetPath += _selNodeInfo[(_selNodeInfo.count)-2] + "\\"
							--Si actualizamos un asset solamente
							_assetSample = (_assetPath + "image\\sample\\" + _charTreeView.selectedNode.name + "_sample.tif")

							--Si no hay icono para el preset, buscamos el icono del asset generico.
							if not doesFileExist _assetSample then 
							(
								_assetNameParts = FilterString _assetSample "\\"
								_assetSample = (_assetPath + "image\\sample\\" + _assetNameParts[_assetNameParts.count] + "_sample.tif" )
							)
							--Si no hay icono para el generico, cargamos el icono de asset generico.
							if not doesFileExist _assetSample then 
							(
								_assetSample = "R:\\resource\\technical\\max\\lbTools\\stdplugs\\stdscripts\\lbTools\\image\\lbImages_assetIcons.tif"
							)
							
							--Finalmente, configuramos el nuevo nombre del shape de refencia.
							_selectedNode.name = _selNodeInfo[1]
							--Configuramos el nuevo nombre del plano asociado. 
							_selectedNode.children[1].name = _selectedNode.name + "_plane"
							_mat = _selectedNode.children[1].material
							--Configuramos los nuevos paths de los mapas de difusa y opacidad. 
							_mat.diffuseMap = Bitmaptexture fileName: _assetSample
							_mat.opacityMap = Bitmaptexture fileName: _assetSample
							--Configuramos el alpha para que se vea transparente el plano.
							_mat.maps[7].rgbOutput = 1

						)
						else lb.message.show "Select a preset to edit the reference."
					)
					else lb.message.show "You must select the new Reference on the treeView."
				)
				else lb.message.show "Incorrect element, select the Reference Shape to edit."
			)
			else 
			(
				lb.message.show "You must select a reference to edit it."
			)
		)
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
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = undefined 
			_height = undefined 
			_posX = undefined 
			_posY = undefined

			if doesFileExist parent.cfgFile do 
			(
				--------------------------------------------------------------------------------
				--Los parametros de la tool leídos del xml de config van aqui

				-- ancho y alto del rollout
				_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
				_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
					
				--posicion
				_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
				_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer


				--------------------------------------------------------------------------------
			)	
			
			--establece minimos
			if _width == undefined then _width = minRollWidth
			else if _width < minRollWidth then _width = minRollWidth
			
			if _height == undefined then _height = minRollHeight
			else if _height < minRollHeight then _height = minRollHeight
			
			if _posX == undefined then _posX = 0
			else if _posX < 0 then _posX = 0
			
			if _posY == undefined then _posY = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnCreateRef | El elemento dispara el evento
		------------------------------------------------
		on btnCreateRef pressed do 
		(
			_selNodeInfo = #()
			if _charTreeView.selectedNode != undefined then 
			(
				--Obtenemos el nodo selecccionado y revisamos su jerarquia en ascendente.
				_theNode = _charTreeView.selectedNode
				append _selNodeInfo _theNode.name			
				--Mientras encontremos padres iremos subiendo en la jerarquia y asi sabremos el nivel en el que nos encontramos, y los sucesivos datos que se almacenan en selnodeinfo.	
				while _theNode.parent != undefined do 
				(
					_theNode = _theNode.parent
					append _selNodeInfo _theNode.name		
				)
				if _selNodeInfo.count == 4 then 
				(
					_assetPath = "y:\\asset\\"
					--Segun se trate de un character o un prop construiremos la siguiente parte.
					case _selNodeInfo[_selNodeInfo.count] of 
					(
						"Characters": _assetPath += "chr\\"
						"Props": _assetPath += "prp\\"
					)
					--Después le sumaremos el subdirectorio, main, secondary...
					_assetPath += _selNodeInfo[(_selNodeInfo.count)-1] + "\\"
					--Aqui viene el nombre principal del asset.
					_assetPath += _selNodeInfo[(_selNodeInfo.count)-2] + "\\"
					
					--print _assetPath
					--print _selNodeInfo[1]
					createShape _selNodeInfo[1] _assetPath
					if lb.presetImporter.isOpen() do 
					(
						lb.presetImporter.rollMain.updateSceneAssetsList _initarray:true
					)
				)	
				else 
				(
					lb.message.show "Select a tree view node representing a Preset."
				)	
			)
		)

		------------------------------------------------
		--@event: chenged | Evento que se lanza cambiar el estado del boton.
		--@control: checkbutton | cbxPosition | El elemento dispara el evento
		------------------------------------------------
		on cbxPosition changed state do 
		(
			spnPosVariationSt.enabled = state
			spnPosVariationEnd.enabled = state
			cbxPosX.enabled = state
			cbxPosY.enabled = state
			cbxPosZ.enabled = state
		)

		------------------------------------------------
		--@event: chenged | Evento que se lanza cambiar el estado del boton.
		--@control: checkbutton | cbxRotation | El elemento dispara el evento
		------------------------------------------------		
		on cbxRotation changed state do 
		(
			spnRotVariationSt.enabled = state
			spnRotVariationEnd.enabled = state
			cbxRotX.enabled = state
			cbxRotY.enabled = state
			cbxRotZ.enabled = state			
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnRandom | El elemento dispara el evento
		------------------------------------------------
		on btnRandom pressed do 
		(
			_selection = getCurrentSelection()
			if _selection.count != 0 then 
			(
				for _obj in selection do 
				(
					if spnRotVariationSt.enabled and spnRotVariationEnd.enabled do  
					(
						_rot = eulerAngles _obj.rotation.x _obj.rotation.y _obj.rotation.z
						if cbxRotX.enabled and cbxRotX.checked then 
						(
							_rot.x = random spnRotVariationSt.value spnRotVariationEnd.value 
						)
						if cbxRotY.enabled and cbxRotY.checked then 
						(
							_rot.y = random spnRotVariationSt.value spnRotVariationEnd.value 
						)
						if cbxRotZ.enabled and cbxRotZ.checked then 
						(
							_rot.z = random spnRotVariationSt.value spnRotVariationEnd.value 
						)
						_obj.rotation = _rot
					)	
					if spnPosVariationSt.enabled and spnPosVariationEnd.enabled do  
					(
						_pos = [_obj.position.x, _obj.position.y, _obj.position.z]
						if cbxPosX.enabled and cbxPosX.checked then 
						(
							_pos.x = random spnPosVariationSt.value spnPosVariationEnd.value 
						)
						if cbxPosY.enabled and cbxPosY.checked then 
						(
							_pos.y = random spnPosVariationSt.value spnPosVariationEnd.value 
						)
						if cbxPosZ.enabled and cbxPosZ.checked then 
						(
							_pos.z = random spnPosVariationSt.value spnPosVariationEnd.value 
						)
						_obj.position = _pos
					)	
				)
			)
			else
			(
				lb.message.show "No reference nodes selected."
			)
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnEditRef | El elemento dispara el evento
		------------------------------------------------
		on btnEditRef pressed do 
		(
			editRef()
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnUpdateRef | El elemento dispara el evento
		------------------------------------------------
		on btnUpdateRef pressed do 
		(
			_selNodeInfo = #()
			if _charTreeView.selectedNode != undefined then 
			(
				--Obtenemos el nodo selecccionado y revisamos su jerarquia en ascendente.
				_theNode = _charTreeView.selectedNode
				append _selNodeInfo _theNode.name			
				--Mientras encontremos padres iremos subiendo en la jerarquia y asi sabremos el nivel en el que nos encontramos, y los sucesivos datos que se almacenan en selnodeinfo.	
				while _theNode.parent != undefined do 
				(
					_theNode = _theNode.parent
					append _selNodeInfo _theNode.name		
				)
				if _selNodeInfo.count > 2 then 
				(
					_assetPath = "y:\\asset\\"
					--Segun se trate de un character o un prop construiremos la siguiente parte.
					case _selNodeInfo[_selNodeInfo.count] of 
					(
						"Characters": _assetPath += "chr\\"
						"Props": _assetPath += "prp\\"
					)
					--Después le sumaremos el subdirectorio, main, secondary...
					_assetPath += _selNodeInfo[(_selNodeInfo.count)-1] + "\\"
					--Aqui viene el nombre principal del asset.
					_assetPath += _selNodeInfo[(_selNodeInfo.count)-2] + "\\"
					--Generamos los paths para lo imprescindible del asset, la carpeta de rig, version y los samples.
					_assetRig = _assetPath + "rig\\"
					_assetVersion = _assetPath + "version\\"
					_assetSample = _assetPath + "image\\sample\\"

					_svnCommand = "/command:update /path:\""
					_svnCommand += _assetSample + "*" + _assetVersion + "*" + _assetRig
				
					_svnCommand += "\""
					_svnCommand += " /closeonend:1"
					------------------------------------------------
				
					--actualiza los paths seleccionados
					shellLaunch "TortoiseProc" _svnCommand
					--Actualizaremos la lista del treeview para ver los cambios.

					updateAssetList()
				)		
			)
		)

		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar un campo del control
		--@control: editText | _edtFilter | El elemento dispara el evento
		------------------------------------------------
		on _edtFilter changed value do 
		(
			updateAssetList mode:#filter
		)

		------------------------------------------------
		--@event: afterSelect | Evento que se lanza al seleccionar un control del treeview
		--@control: DotNet Treeview | _charTreeView | El elemento dispara el evento
		------------------------------------------------		
		on _charTreeView afterSelect events do 
		(
			updatePreview()
		)

		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
			--Actualizamos la lista del treeview
			updateAssetList()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_presetImporterRefManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la tool.
		description = "Tool plantilla",		--@var: string | description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string | cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: boolean | opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollout | rollMain | Almacena el rollout principal de la herramienta.
			
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
		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
		------------------------------------------------
		fn isOpen =
		(
			this.opened
		),
		
		------------------------------------------------
		--@fn: undefined | refreshInterface | Refresca el interface inicial de la herramienta
		------------------------------------------------
		fn refreshInterface =
		(
			--refresca el interface de la herramienta
		),
		
		------------------------------------------------
		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
		------------------------------------------------
		fn createInterface =
		(
			--crea el interface, lo redimensiona y lo reposiciona
			createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
		------------------------------------------------
		fn destroyInterface =
		(
			destroyDialog this.rollMain --cierra la herramienta.			
		),--destroyInterface
		
		------------------------------------------------
		--@fn: undefined | run | Lanza la herramienta.
		------------------------------------------------
		fn run =
		(
			this.createInterface() --crea el interface.
			this.opened = true --indica que la herramienta está abierta
		),--execute
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
		------------------------------------------------
		fn close =
		(
			this.destroyInterface() --destruye el interface.
			this.opened = false --indica que la herramienta está cerrada.
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
			lb.addTool this --añade la tool a la libreria principal	
		)		
		
	)--tl_templateTool
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_presetImporterRefManager() --crea la herramienta
)