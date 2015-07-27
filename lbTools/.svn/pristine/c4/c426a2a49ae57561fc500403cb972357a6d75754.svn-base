------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta morphVariationLoader.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta morphVariationLoader.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Morph Variation Loader"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 100		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local _pckObj = undefined	--@var: modifiedObj | Almacena el objeto original.	
		local _newName = #()

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		pickbutton pckPickObject "Pick Object" pos:[35,15] width:150 height:30 toolTip:"Pick object to load variations"
		button btnLoadVariations "Load Variations" pos:[35,55] width:150 height:30 toolTip:"Load Variations"

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
		--@fn: undefined | updateUI | Actualiza los valores de los controles del interface.
		------------------------------------------------
		fn updateUI =
		(
			if _pckObj != undefined then --activa los controles del UI
			(
				if isValidNode _pckObj then pckPickObject.caption = _pckObj.name
			)
			else --desactiva los controles del UI
			(
				pckPickObject.caption = "Pick Object"
			)--if else		
		)	

		------------------------------------------------
		--@fn: undefined | reset | Hace un reset de la herramienta.
		------------------------------------------------
		fn reset =
		(
			--vacia las variables
			_pckObj = undefined

			updateUI()
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.addscript #filePostOpenProcess "lb.morphVariationLoader.rollMain.reset()" id:_id			
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			_id = ((parent.className + "_" + (substituteString parent.rollMain.name "Def" "")) as name)

			callbacks.removescripts id:_id			
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
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--COMMON
		------------------------------------------------

		------------------------------------------------
		--@event | picked | Evento que se lanza al elegir un objeto como modificado.
		--@control: pickButton | pckPickObject | pickButton para elegir el objeto modificado.
		--@gets: node | obj | Nodo de la escena elegido como objeto modificado.
		------------------------------------------------
		on pckPickObject picked obj do
		(	
			_pckObj = undefined
			--desactiva el boton de copiar y vacia el listado

			if isValidNode obj and ((classof obj.baseObject == PolyMeshObject) or (classof obj.baseObject == Editable_Poly)) then
				_pckObj = obj 
			else
				messageBox "Object must be an Editable_Poly"	
			updateUI()
		)	

		
		on btnLoadVariations pressed do
		(
			if _pckObj != undefined then
			(
				_nodeInfo = lb.nodeInfo.hasNodeInfo _pckObj

				if _nodeInfo then
				(
					_fileHistory = _pckObj.nodeInfo.fileHistory
					
					for i=1 to _fileHistory.count do
					(
						_fileName = getFileNameFile _fileHistory[i]
						_fileNameParts = filterString _fileName "_"
						if _fileNameParts[3] == lb.nc.NC_meshFileName then
						(
							_orgPath = getFileNamePath _fileHistory[i]
							_morphFileName = ""
							_morphFileName = (getFileNamePath _fileHistory[i]) + _fileNameParts[1] + "_" + _fileNameParts[2] + "_" + lb.nc.NC_morphFileName + "_" + _fileNameParts[4] + ".max"
							
							if not doesFileExist _morphFileName then
							(
								_searchFile = lb.message.show "This object dont have variations, Do you want to select a file ?" type:#query
								if _searchFile then
								(
									_morphFileName = getOpenFileName filename:_orgPath
								)
							)

							_targetMorpher = undefined
							if _morphFileName != undefined then
							(	
								for m in _pckObj.modifiers do
								(
									if classof m == Morpher then
									(
										_targetMorpher = m
									)
								)
							)--for de modificadores

							--Si no tengo morpher me lo creo
							if _targetMorpher == undefined then
							(
								--USAR FUNCION DE JUAN
								lb.modifiers.insertModifier _pckObj (Morpher()) before:20
								for m in _pckObj.modifiers do
								(
									if classof m == Morpher then
									(
										_targetMorpher = m
									)
								)
							)

							--Si hay variacioens le usuario elige si se borran o no
							_varLoaded = #()
							_foundVariations = false
							_deleteVariations = false
							for n=1 to 100 do
							(
								_name = WM3_MC_GetName _targetMorpher n
								if _name != undefined then
								(
									if MatchPattern _name pattern: lb.nc.NC_morphVariationPattern then 
									(
										_foundVariations = true 
										append _varLoaded (WM3_MC_GetName _targetMorpher n)
									)
								)
							)

							if _foundVariations then 
							(
								_deleteVariations = lb.message.show "There are morph variations loaded. Do you want to delete them first? If you press NO, only new ones will be added." type:#query
								if _deleteVariations then
								(
									for n=1 to 100 do
									(
										_index = findItem _varLoaded (WM3_MC_GetName _targetMorpher n)

										if _index != 0 then
										(
											WM3_MC_Delete _targetMorpher n
											deleteItem _varLoaded _index	
										)	
									)
								)
							)

							--Mergeamos los objetos del archivo exterior
							_objsToMerge = getMAXFileObjectNames _morphFileName
							_merge = #()
							for j=1 to _objsToMerge.count do
							(
								_findVar = findItem _varLoaded (filterString _objsToMerge[j] "_")[5]
								if _findVar == 0 then 
								(
									_objsToMergeParts = filterString _objsToMerge[j] "_"
									if matchpattern _objsToMergeParts[5] pattern: lb.nc.NC_morphVariationPattern then
									(
										append _merge _objsToMerge[j]
									)
								)
							)

							mergeMAXFile _morphFileName _merge #useMergedMtlDups quiet:true	

							--MIRARPORQUENOCONECTAELCANAL100

							--Conectamos al morpher las variaciones
							_startingIndex = 101
							while (_startingIndex > 0) and (WM3_MC_HasData _targetMorpher _startingIndex) do _startingIndex -= 1
							--print "1"
							--print _startingIndex
							if _startingIndex > 0 then
							(
								--print "2"
								--print _startingIndex
								for v=1 to _merge.count do --recorre los nombres de variaciones a añadir
								(
									--obtiene el nodo de la variacion y lo intenta añadir en los huecos libres del morpher al final
									_varNode = getNodeByName _merge[v]
									if _varNode != undefined then
									(
										--print "3"
										--print _startingIndex
										--averiguo donde insertar la variacion
										while (_startingIndex > 0) and (WM3_MC_HasData _targetMorpher _startingIndex) do _startingIndex -= 1

										--print "4"
										--print _startingIndex
										if _startingIndex > 0 then
										(
											if WM3_MC_BuildFromNode _targetMorpher _startingIndex _varNode then
											(
												--print "5"
												--print _startingIndex
												_startingIndex -= 1
											)
										)--if
									)--if
								)--for
								lb.message.show "Variations loaded!"
							)
							else
							(
								lb.message.show "All channels are in use. Cannot add new variations."
							)

							for n=1 to 100 do
							(
								--dejar de nombre var-*
								_nameS = WM3_MC_GetName _targetMorpher n
								_nameSParts = filterString _nameS "_"
								if _nameSParts.count == 7 then
								(
									if WM3_MC_HasData _targetMorpher n then
									(
										WM3_MC_SetName _targetMorpher n _nameSParts[5]
										append _newName (WM3_MC_GetName _targetMorpher n)
									)
								)
							)

							for node in _merge do delete (getNodeByName node)
						)
					)		
				)
				else
				(
					lb.message.show "Object picked doesn't have nodeInfo!" type:#message
				)
			)
			else
			(
				lb.message.show "You must pick an object!" type:#message
			)
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
	--@struct: morphVariationLoader | Contiene la herramienta morphVariationLoader.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_morphVariationLoader
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Morph Variation Loader",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollMain | Almacena el rollout principal de la herramienta.
			
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
		
	)--tl_morphVariationLoader
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_morphVariationLoader() --crea la herramienta
)