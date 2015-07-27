------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Conjunto de herramientas para el uso de lighting, agrupadas en un manager para un facil acceso.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollTurboClothDef | Contiene la herramienta rollTurboClothDef.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollTurboClothDef "Cloth TurboSmooth"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 			--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 225																	--@var: integer | minRollWidth | Minimun tool width.
		local minRollHeight = 100																	--@var: integer | minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnAddTurbo "Add TurboSmooth:k" pos:[10,10] width:195 height:21
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollTurboClothDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollTurboClothDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar un boton
		--@control: button | btnAddTurbo | El botón que se pulsa
		------------------------------------------------
		on btnAddTurbo pressed do 
		(
			_objToUse = getCurrentSelection()
			if _objToUse.count != 0 then
			(
				turboCloth = TurboSmooth()
				turboCloth.name = "TurboSmooth:k"
				for i=1 to _objToUse.count do
				(
					addmodifier _objToUse[i] turboCloth before:20
				)
			)
			else lb.message.show "Tienes que tener algun obj seleccionado."
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollTurboClothDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollTurboClothDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollTurboClothDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollTurboClothDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollReplaceHairDef | Contiene la herramienta Replace Hair..
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollReplaceHairDef "Hair"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 			--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 225																	--@var: integer | minRollWidth | Minimun tool width.
		local minRollHeight = 100																	--@var: integer | minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnReplaceHair "Replace Hair" pos:[10,10] width:195 height:21
		
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
		--@fn: undefined | hairReplace | Trae a escena los ficheros de pelo asociados con los personajes de escena
		------------------------------------------------
		fn hairReplace = 
		(

			_nodes = for o in objects where (matchPattern o.name pattern: ("*" + "_" + lb.nc.NC_classMesh + "_*_" + lb.nc.NC_HAIR_draftPattern + "_*_*")) or (matchPattern o.name pattern: ("*" + "_" + lb.nc.NC_classMesh + "_*_" + lb.nc.NC_HAIR_drvPattern + "_*_*")) or (matchPattern o.name pattern: ("*" + "_" + lb.nc.NC_classMesh + "_*_" + lb.nc.NC_HAIR_shadowPattern + "_*_*")) or (matchPattern o.name pattern: ("*" + "_" + lb.nc.NC_classHair + "_*_" + lb.nc.NC_HAIR_scalpPattern + "_*_*")) collect o

			-- replace file has to be in the same directory and has the name of object to replace
			_cacheNameParts = filterString maxfilename "_"
			_cacheName = _cacheNameParts[1] + "_" + _cacheNameParts[2] + "_" + _cacheNameParts[3] + "_" + lb.nc.NC_PCfileName
			_cachePathParts = filterString maxfilepath "\\"
			_cachePath = _cachePathParts[1] + "\\" + _cachePathParts[2] + "\\" + _cachePathParts[3] + "\\" + _cachePathParts[4] + "\\" + _cachePathParts[5] + "\\" + _cachePathParts[6] + "\\" + lb.nc.NC_camCacheFolder + "\\"
			_cachefile = _cachePath + _cacheName + ".max"

			if _nodes.count > 0 and doesfileexist _cachefile do
			(
				clearSelection()
				-- merge only object with the name
				_nodesNames = #()
				for i=1 to _nodes.count do
				(
					append _nodesNames _nodes[i].name
				)
				mergeMaxFile _cachefile _nodesNames #select #deleteOldDups #neverReparent #useMergedMtlDups quiet:on
			)
		)	
			
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollReplaceHairDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollReplaceHairDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		on btnReplaceHair pressed do 
		(
			hairReplace()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollReplaceHairDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollReplaceHairDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollReplaceHairDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollReplaceHairDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMaterialsListDef | Contiene la herramienta Material Library List.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMaterialsListDef "Material Library List"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 				--@var : string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 375																		--@var: integer | minRollWidth | Minimun tool width.
		local minRollHeight = 400																		--@var: integer | minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		button btnSelAll "Select All" pos:[10,15] width:105 height:25
		button btnSelNone "Select None" pos:[133,15] width:105 height:25 
		button btnSelInvert "Select Invert" pos:[255,15] width:105 height:25 

		dotNetControl lvMats "System.Windows.Forms.ListView" pos:[10,50] width:350 height:300

		button btnOk "Ok" pos:[105,360] width:70 height:25
		button btnCancel "Cancel" pos:[185,360] width:70 height:25	

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
		--@fn: undefined | initMaterialsListView | Inicializa las propiedades de la listview de materiales.
		------------------------------------------------		
		fn initMaterialsListView =
		(
			lv = lvMats
			lv.columns.clear()
			lv.multiSelect = false
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = colorBackUnselected
			lv.foreColor = colorFore
			lv.scrollable = true
			lv.labelEdit = false
			lv.MultiSelect = true
			lv.hideselection = false

			lv.columns.add "Materials Library" 330

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		------------------------------------------------
		--@fn: undefined | fillMaterialListView | Llena la listview de materiales de la tool con los nombres de los materiales en escena.
		------------------------------------------------	
		fn fillMaterialListView  =
		(
			lvMats.items.clear()
			for i=1 to parent._materialsNames.count do
			(
				lvMats.items.add (parent._materialsNames[i])
				lvMats.items.item[i-1].SubItems.add
			)

			for i=1 to lvMats.items.count do 
			(
				lvMats.items.item[i-1].selected = true
			)
			setFocus lvMats
		) 

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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMaterialsListDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMaterialsListDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnSelAll | El botón que dispara el evento.
		------------------------------------------------
		on btnSelAll pressed do
		(
			for i=1 to lvMats.items.count do 
			(
				lvMats.items.item[i-1].selected = true
			)
			setFocus lvMats
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnSelNone | El botón que dispara el evento.
		------------------------------------------------
		on btnSelNone pressed do
		(
			for i=1 to lvMats.items.count do 
			(
				lvMats.items.item[i-1].selected = false
			)
			setFocus lvMats
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnSelInvert | El botón que dispara el evento.
		------------------------------------------------
		on btnSelInvert pressed do
		(
			for i=1 to lvMats.items.count do lvMats.items.item[i-1].selected = not lvMats.items.item[i-1].selected 
			setFocus lvMats
		) 

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnOk | El botón que dispara el evento.
		------------------------------------------------
		on btnOk pressed do
		(
			_materialsToReplace = #()
			if lvMats.items.count != 0 then
			(
				for i=1 to lvMats.items.count where lvMats.items.item[i-1].selected == true do 
				(
					appendIfUnique _materialsToReplace lvMats.items.item[i-1].text
				) 
			)

			if _materialsToReplace.count != 0 then
			(
				_xmlDoc = lb.materials.loadMatInfo lb.lightingManager.rollMatReplacer._matLibFile
				_tmpMatLib = loadTempMaterialLibrary (lb.lightingManager.rollMatReplacer._matLibFile)
				if _xmlDoc != undefined do
				(
					_rootNode = _xmlDoc.getRoot()

					_nodesMaterials = _rootNode.getNodes "nodesMaterials/nodeMaterial"

					for _newNodeMaterial in _nodesMaterials do
					(
						_matName = _newNodeMaterial.getProperty "matName"
						_objName = _newNodeMaterial.getProperty "objName"

						if (findItem _materialsToReplace _matName) != 0 then
						(
							_objPatt = lb.nc.replaceNamePart _objName 6 "*"
							_objPatt = lb.nc.replaceNamePart _objPatt 7	"?"

							_matches = for o in objects where matchpattern o.name pattern:_objPatt collect o
							
							_obj = _matches[1]
							_mat = _tmpMatLib[_matName]

							if _obj	!= undefined and _mat != undefined then
							(
								_obj.material = _mat
							)
						)
					)
				)
			)
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnCancel | El botón que dispara el evento.
		------------------------------------------------
		on btnCancel pressed do
		(
			destroyDialog rollMaterialsListDef
		)

		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMaterialsListDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMaterialsListDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			initMaterialsListView()
			fillMaterialListView()
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMaterialsListDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollMaterialsListDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene la tool Lighting manager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Lighting Manager"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 				--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 230																		--@var: integer | minRollWidth | Minimun tool width.
		local minRollHeight = 435																		--@var: integer | minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local opening = false 																			--@var: boolean | opening | Flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		dotNetControl tbTabs "DevExpress.XtraTab.XtraTabControl" pos:[0,5] width:350 height:21 --25
	
		------------------------------------------------------------------------------------------------
		--SUBROLLOUTS
		------------------------------------------------------------------------------------------------

		subrollout subRollContainer "subRollouts" pos:[0,26] width:minRollWidth height:574 

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
		--@fn: undefined | initUI | Inicializa los controles del UI.
		------------------------------------------------
		fn initUI =
		(	
			tbTabs.paintstylename = "PropertyView"
			tbTabs.borderStyle = (dotnetclass "DevExpress.XtraEditors.Controls.BorderStyles").noBorder
			tbTabs.TabPageWidth = 100			
			
			tbTabs.Appearance.BackColor = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbTabs.Appearance.BackColor2 = (dotnetclass "system.drawing.color").fromArgb 68 68 68
			tbTabs.Appearance.BorderColor = (dotnetclass "system.drawing.color").fromArgb 100 100 100
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]

			--aplica el tab seleccionado
			parent.selectedTabIndex = (lb.xml.getAttribute parent.cfgFile "rollMain/options" "selectedTabIndex") as integer
			if parent.selectedTabIndex == 0 then parent.selectedTabIndex = 1
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

			--almacena las opciones de UI
			lb.xml.setAttribute parent.cfgFile ("rollMain/options") "selectedTabIndex" (parent.selectedTabIndex as string)
		)

		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks de este rollout.
		------------------------------------------------
		fn createSceneEvents =
		(
			--sin operaciones
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Elimina los callbacks de este rollout.
		------------------------------------------------
		fn removeSceneEvents =
		(
			--sin operaciones
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: selectedPageChanged | Evento que se lanza al cambiar de tab.
		--@control: DevExpress.XtraTab.XtraTabControl | tbTabs | Tabs.
		--@gets: event | events | Objeto devuelto por el evento.
		------------------------------------------------
		on tbTabs selectedPageChanged events do
		(
			if not opening then
			(
				parent.selectedTabIndex = tbTabs.selectedTabPageIndex + 1
				parent.addTabRollouts()
			)--if
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMainDef | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			------------------------------------------------------------------------------
			--si el tamaño es menor que el minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento de tamaño
			_increment = [size.x - minRollWidth, size.y - minRollHeight]

			------------------------------------------------------------------------------
			--redimension en horizonal
			if _increment.x != 0 then --si hay incremento
			(				
				tbTabs.width = 350 + _increment.x
				if tbTabs.tabPages.count != 0 then tbTabs.TabPageWidth = (minRollWidth + _increment.x)/(tbTabs.tabPages.count) - 17
				subRollContainer.width = size.x
			)--if
			------------------------------------------------------------------------------

			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				--zona de subRollouts
				subRollContainer.height = 574 + _increment.y				
			)--if
			------------------------------------------------------------------------------

			parent.addTabRollouts()
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			opening = true --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg

			initUI() --inicializa el UI
			loadSettings()
			parent.fillTabsRolloutsDefs()
			parent.addTabs()
			createSceneEvents()			

			opening = false --flag para que no salte el evento de cambio de tab y no pise el valor cargado del archivo .cfg
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(				
			removeSceneEvents()
			saveSettings()
			if parent.rollMaterialsList.open == true then destroyDialog parent.rollMaterialsList
			parent.opened = false
			updateToolbarButtons()		
		)	
	)--rollMainDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMatReplacerDef | Contiene la herramienta Material Replacer.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMatReplacerDef "Material Replacer"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 			--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350																	--@var: integer | minRollWidth | Minimun tool width.
		local minRollHeight = 100																	--@var: integer | minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local lastUsedPath = undefined
		local _matLibFile = undefined 
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnExport "Export materials to Library" pos:[20,5] width:180 height:25 border:true visible:true tooltip:"Save lib"
		button btnReplace "Replace materials from Library" pos:[20,40] width:180 height:25 border:true visible:true tooltip:"Load lib"
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMatReplacerDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMatReplacerDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnExport | El botón que dispara el evento.
		------------------------------------------------
		on btnExport pressed do
		(
			setWaitCursor()
			disableSceneRedraw()
			suspendEditing()

			if lastUsedPath == undefined then
			(
				lastUsedPath = maxFilePath
				
				if lastUsedPath == "" then
					lastUsedPath = getDir #scene
			)--if

			_fileName = getFilenameFile  maxFileName
			_fileNameParts = filterString _fileName "_"
			_fileName = _fileNameParts[1] + "_" + _fileNameParts[2] + "_" + _fileNameParts[3] + "_material.mat"
			
			_file = getSaveFileName caption:"Export materials to library" filename:(lastUsedPath + "\\" + (_fileName))
			if _file != undefined then
			(
				lb.materials.saveLib _file																													
				lb.message.show "Materials exported correctly!" type:#message pos:undefined size:[300,75] modal:true
			)

			enableSceneRedraw()
			resumeEditing()
			setArrowCursor()
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnReplace | El botón que dispara el evento.
		------------------------------------------------
		on btnReplace pressed do
		(
			setWaitCursor()
			disableSceneRedraw()
			suspendEditing()

			if lastUsedPath == undefined then
			(
				lastUsedPath = maxFilePath
				
				if lastUsedPath == "" then
					lastUsedPath = getDir #scene
			)--if

			_matLibFile = getOpenFileName filename:lastUsedPath 
			if _matLibFile != undefined then
			(
				_loadTmp = loadTempMaterialLibrary _matLibFile
				for i=1 to _loadTmp.count do
				(
					appendIfUnique parent._materialsNames _loadTmp[i].name
				)

				createDialog parent.rollMaterialsList lockwidth:true lockheight:true pos:[(getDialogPos parent.rollMain).x+238,(getDialogPos parent.rollMain).y] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
			)
			
			enableSceneRedraw()
			resumeEditing()
			setArrowCursor()
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMatReplacerDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMatReplacerDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMatReplacerDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollMatReplacerDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollExample1Def | Contiene la herramienta de librerias temporales de materiales.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMatLibDef "Temp Library Util"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 				--@var : string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual		
		
		local minRollWidth = 350																		--@var: integer | minRollWidth | Minimun tool width.
		local minRollHeight = 100																		--@var: integer | minRollHeight | Minimun tool height.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnSave "Save Library" pos:[20,5] width:70 height:25 border:true visible:true tooltip:"Save lib"
		button btnLoad "Load Library" pos:[125,5] width:70 height:25 border:true visible:true tooltip:"Load lib"
		
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
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | resize | Redimensiona el UI.
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMatLibDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMatLibDef.height = size.y)
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
			--lb.xml.setAttribute parent.cfgFile ("rollExample1/cateagory") "paramName" "paramValue"
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--_param = (lb.xml.getAttribute parent.cfgFile ("rollExample1/category") "paramName") as <value type>
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnSave | El botón que dispara el evento.
		------------------------------------------------
		on btnSave pressed do
		(
			lb.materials.saveTmpLib()
			lb.message.show "Temp library saved correctly!" type:#message pos:undefined size:[300,75] modal:true
		)

		------------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton
		--@control: button | btnLoad | El botón que dispara el evento.
		------------------------------------------------
		on btnLoad pressed do
		(
			setWaitCursor()
			disableSceneRedraw()
			suspendEditing()

			_loadLibrary = lb.message.show "Do you want load temp library?" type:#yesnocancel pos:undefined size:[300,75] modal:true

			if _loadLibrary == #yes then 
			(
				lb.materials.loadTmpLib()
			)
			
			enableSceneRedraw()
			resumeEditing()
			setArrowCursor()
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMatLibDef resized size do
		(
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMatLibDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMatLibDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
		)
	)--rollMatLibDef

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTabTool | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_lightingManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),																							--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),																				--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,																								--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),												--@var: string | className | Nombre de la tool.
		description = "Tool plantilla",																					--@var: string | description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string | cfgFile | Archivo de configuracion de la tool.
			
		opened = false,																									--@var: boolean | opened | Indica si la herramienta está abierta.
		
		minWidth = 400,																									--@var: integer | minWidth | Ancho mínimo de la herramienta.
		minHeight = 600,																								--@var: integer | minHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		tabForeColor = (dotnetclass "system.drawing.color").fromArgb 189 189 189,
		tabBorderColor = (dotnetclass "system.drawing.color").fromArgb 30 30 30,
		tabBackColor = (dotnetclass "system.drawing.color").fromArgb 60 60 60,
		tabBackColorActive = (dotnetclass "system.drawing.color").fromArgb 90 90 90,
		tabBackColor2 = (dotnetclass "system.drawing.color").fromArgb 55 55 55,
		tabBackColorActive2 = (dotnetclass "system.drawing.color").fromArgb 60 60 60,		

		_materialsNames = #(),

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,																				--@var: rollout | rollMain | Main tool rollout.
		rollMatLib = rollMatLibDef,																			--@var: rollout | rollMatLib | Rollout de la libreria de materiales
		rollMatReplacer = rollMatReplacerDef,																--@var: rollout | rollMatReplacer | Rollout de la tool mat replacer
		rollMaterialsList = rollMaterialsListDef,															--@var: rollout | rollMaterialsList | Rollout de la Lista de materiales											
		rollTurboCloth = rollTurboClothDef,																	--@var: rollout | rollTurboCloth | Rollout de la tool Turbosmooth2k		
		rollReplaceHair = rollReplaceHairDef,																--@var: rollout | rollReplaceHair | Rollout de la tool replace hair	
		subRolloutsContainer = this.rollMain.subRollContainer, 												--@var: container | subRolloutsContainer | contenedor de subrollouts.

		--estos arrays se rellenan en la funcion fillTabsRolloutsDefs, que se llama al abrir la herramienta.
		--esto es solo la defincion de las variables y una ejemplo de estructura que luego se sobrescribe.
		tabNames = #("", "", "", ""), 																		--@var: array | tabNames | Nombres de los tabs.
		tabRollouts = #(#(undefined), #(undefined), #(undefined, undefined), #(undefined,undefined)), 		--@var: array | mentalrayTabNames | Rollots de cada tab.
		tabRolloutsRolledUp = #(#(true), #(true), #(false, true), #(true,true)), 							--@var: array | tabRolloutsRolledUp | Estado de desplegado/plegado de cada rollout de cada tab.

		selectedTabIndex = 1, 																				--@var: integer | selectedTabIndex | Tab seleccionado. Para usar al abrir y cerrar la herramienta

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
		--@fn: undefined | updateTabsColor | Actualiza el color de los tabs.
		------------------------------------------------
		fn updateTabsColor =
		(
			--actualiza los tabs
			for i=1 to this.tabNames.count do
			(
				--configura los colores de los tabs
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.ForeColor = this.tabForeColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BackColor = this.tabBackColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BackColor2 = this.tabBackColor2
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.Header.BorderColor = this.tabBorderColor
				
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.Font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 8
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.ForeColor = this.tabForeColor
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor = this.tabBackColorActive
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BackColor2 = this.tabBackColorActive2
				this.rollMain.tbTabs.tabPages.item[i-1].Appearance.HeaderActive.BorderColor = this.tabBorderColor
			)--for
		),
		
		------------------------------------------------
		--@fn: undefined | fillTabsRolloutsDefs | Añade los tabs y las definiciones de los rollouts a los arrays correspondientes para que la herremienta sepa donde están.
		------------------------------------------------
		fn fillTabsRolloutsDefs =
		(
			this.tabNames = #("Cache", "Materials", "Lights", "Misc")
			this.tabRollouts = #(#(lb.lightingManagerMini.rollCacheLoader,lb.lightingManager.rollTurboCloth, lb.lightingManager.rollReplaceHair), #(lb.idsManager.rollMain, lb.lightingManager.rollMatReplacer, lb.lightingManager.rollMatLib), #(lb.lightingManagerMini.rollLightImpExp, lb.lightingManagerMini.rollLightContrainer), #(lb.xrefBreaker.rollMain, lb.resourceCollector.rollMain, lb.exportFBX.rollMain, lb.lightingManagerMini.rollSetLockUnlock))
			this.tabRolloutsRolledUp = #(#(false,false,false,false), #(true, false, false), #(false, false), #(false,false,false,false))
		),

		------------------------------------------------
		--@fn: undefined | addTabs | Añade los tabs.
		------------------------------------------------
		fn addTabs =
		(
			--elimina los tabs actuales
			this.rollMain.tbTabs.tabPages.clear()

			--añade los tabs
			for i=1 to this.tabNames.count do
				this.rollMain.tbTabs.tabPages.add this.tabNames[i] --añade el tab
			
			if this.rollMain.tbTabs.tabPages.count != 0 then this.rollMain.tbTabs.TabPageWidth = (this.rollMain.width)/(this.rollMain.tbTabs.tabPages.count) - 17

			--selecciona el tab que estaba seleccionado la ultima vez que se abrio el override
			if this.rollMain.tbTabs.tabPages.count >= this.selectedTabIndex then
				this.rollMain.tbTabs.SelectedTabPage = this.rollMain.tbTabs.tabPages.item[this.selectedTabIndex - 1]
			
			this.updateTabsColor() --actualiza los colores de los tabs
			
			this.addTabRollouts()			
		),

		------------------------------------------------
		--@fn: undefined | removeAllTabRollouts | Elimina todos los subrollouts actuales
		------------------------------------------------
		fn removeAllTabRollouts =
		(
			--elimina los subRollouts actuales
			while this.subRolloutsContainer.rollouts.count != 0 do RemoveSubRollout this.subRolloutsContainer this.subRolloutsContainer.rollouts[1]
		),

		------------------------------------------------
		--@fn: undefined | addTabRollouts | Añade los rollouts del tab actual.
		------------------------------------------------
		fn addTabRollouts =
		(
			--elimina los subRollouts actuales
			this.removeAllTabRollouts()

			--añade los subRollouts
			for i=1 to this.tabRollouts[this.selectedTabIndex].count where this.tabRollouts[this.selectedTabIndex][i] != undefined do
			(
				AddSubRollout this.subRolloutsContainer this.tabRollouts[this.selectedTabIndex][i] rolledUp:this.tabRolloutsRolledUp[this.selectedTabIndex][i]
				this.tabRollouts[this.selectedTabIndex][i].resize [this.rollMain.width, this.rollMain.height]
			)
		),

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
			createDialog this.rollMain lockwidth:true lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
	)--tl_lightingManager

	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_lightingManager() --crea la herramienta
)