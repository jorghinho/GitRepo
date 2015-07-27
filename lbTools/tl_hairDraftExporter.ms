------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta hairDraftExporter.
------------------------------------------------------------------------------------------------------------------------------------------------
--(
--	------------------------------------------------------------------------------------------------------------------------------------------------
--	--@rollout: rollMain | Contiene la herramienta hairDraftExporter.
--	------------------------------------------------------------------------------------------------------------------------------------------------
--	rollout rollMainDef "Hair Draft Exporter"
--	(
--		------------------------------------------------------------------------------------------------
--		--COMMON
--		------------------------------------------------------------------------------------------------
		
--		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
--		local minRollWidth = 160		--@var: minRollWidth | Ancho mínimo de la herramienta.
--		local minRollHeight = 70		--@var: minRollHeight | Alto mínimo de la herramienta.
		
--		------------------------------------------------------------------------------------------------
--		--VARIABLES
--		------------------------------------------------------------------------------------------------
		
--		------------------------------------------------------------------------------------------------
--		--CONTROLS
--		------------------------------------------------------------------------------------------------
		
--		button btnHairExport "Hair Export" pos:[5,10] width:150 height:50 highlightColor:(color 255 195 0) enabled:true tooltip:"Hair Export" 
		
--		------------------------------------------------------------------------------------------------
--		--FUNCTIONS
--		------------------------------------------------------------------------------------------------
		
--		------------------------------------------------
--		--GETS
--		------------------------------------------------
		
--		------------------------------------------------
--		--SETS
--		------------------------------------------------
--		------------------------------------------------
--		--OTHER
--		------------------------------------------------
		
--		fn hairShadowsExporter =
--		(
--			_saveRequired = getSaveRequired()
--			_saved = true
--			_originalPathNameFile = maxfilepath + maxfilename

--			if _saveRequired then 
--			(
--				_process = lb.message.show "File has changes. Do you want to save it now?" type:#query--si hay cambios en el 

--				if _process then 
--				(  
--					_saved = saveMaxFile _originalPathNameFile
--					if not _saved then lb.message.show "File couldn't be saved, check if the file is readOnly. Process will not continue." type:#message
--				) 
--				else _saved = false
--			)

--			if _saved then 
--			(		
--				if lb.misc.getNodeByPattern (lb.nc.NC_chrPrefix + "_" + "*(head*Hair-*)_" + lb.nc.NC_meshFileName + "_*_" + lb.nc.NC_HAIR_shadow + "-*-*-*_*_*" ) != undefined then
--				(
--					for i=objects.count to 1 by -1 where not matchPattern objects[i].name pattern: (lb.nc.NC_chrPrefix + "_" + "*(head*Hair-*)_" + lb.nc.NC_meshFileName + "_*_" + lb.nc.NC_HAIR_shadow + "-*-*-*_*_*") do 
--					(
--						delete objects[i]
--					)
--					if objects.count == 0 then lb.message.show "The scene is empty. Process will not continue." type:#message 
--					else _objToWork = objects[1]

--					_objNameParts = filterString _objToWork.name "_-()"
--					_objToWork.name = substituteString _objToWork.name _objNameParts[7] lb.nc.NC_draftFileName 

--					--SECCION MATERIALES

--					--Pillar el material del objShadow
--					for _obj in objects where matchPattern _obj.name pattern: (lb.nc.NC_chrPrefix + "_" + "*(head*Hair-*)_" + lb.nc.NC_meshFileName + "_*_" + lb.nc.NC_draftFileName + "-*-*-*_*_*") do
--					(
--						_mat = _obj.material
--						_matCopy = copy _mat
--						for j=1 to _mat.materialList.count do
--						(
--							for k=1 to _mat.materialList[j].materialList.count where classof _mat.materialList[j].materialList[k] == Hair_Realistic do
--							(
--								_standMat = Standardmaterial()
--								_standMat.diffuse = _mat.materialList[j].materialList[k].transmittanceColor

--								if _mat.materialList[j].materialList[k].diffuseMap != undefined then
--								(
--									if classof _mat.materialList[j].materialList[k].diffuseMap == Hair_Color_Variation then
--									(
--										_standMat.diffuse = _mat.materialList[j].materialList[k].diffuseMap.color
--										if classof _mat.materialList[j].materialList[k].diffuseMap.map == Gradient_Ramp then
--										(
--											_standMat.diffuse = _mat.materialList[j].materialList[k].diffuseMap.map.Gradient_Ramp.Flag__2.color
--										)
--									)
--									/*else --Comentado porque si el mapa no es de tipo hair color variation, y dentro tiene un composite con un mapa de hair lo copia tambien, y las licencias petaran en animacion.
--									(
--										_standMat.diffuseMap = _mat.materialList[j].materialList[k].diffuseMap
--									)*/
--								)
--								_matCopy.materialList[j].materialList[k] = _standMat
--							)			
--						)
						
--						_obj.material = _matCopy
--					)
					
--					setWaitCursor()
--					_newFileNameParts = filterString maxfilename "_"
--					_newFileName = maxfilename
--					_newFileName = substituteString _newFileName _newFileNameParts[3] lb.nc.NC_draftFileName 
--					_newFileName = maxfilepath + _newFileName 

--					if doesFileExist _newFileName then
--					(
--						setFileAttribute _newFileName #readOnly false
--						deleteFile _newFileName
--					)

--					_newFileSaved = saveMaxFile _newFileName useNewFile:true quiet:true
--					loadMaxFile _originalPathNameFile useFileUnits:true quiet:true --Cargamos el archivo _original
--					setArrowCursor()

--					if _newFileSaved then lb.message.show "Hair exported correctly." type:#message 
--				)
--				else
--				(
--					lb.message.show "Object shadow doesn't fullfill namingConvention: lb.nc.NC_chrPrefix_*(head*Hair-*)_lb.nc.NC_meshFileName_*_lb.nc.NC_HAIR_shadow-*-*-*_*_*"
--				)			
--			)		
--		)	
		
--		------------------------------------------------
--		--COMMON
--		------------------------------------------------
		
--		------------------------------------------------
--		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
--		------------------------------------------------
--		fn createSceneEvents =
--		(
		
--		)
		
--		------------------------------------------------
--		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
--		------------------------------------------------
--		fn removeSceneEvents =
--		(
		
--		)
		
--		------------------------------------------------
--		--@fn: undefined | resize | Redimensiona el UI.
--		--@gets: point2 | size | Tamaño nuevo del rollout
--		------------------------------------------------
--		fn resize size =
--		(
--			------------------------------------------------------------------------------
--			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
--			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
--			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
--			------------------------------------------------------------------------------
			
--			--calcula el incremento en ancho y alto, respecto al mínimo.
--			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
--			------------------------------------------------------------------------------
--			--redimension en horizontal
--			if _increment.x != 0 then --si hay incremento
--			(
				
--			)--if
--			------------------------------------------------------------------------------
			
--			------------------------------------------------------------------------------
--			--redimension en vertical
--			if _increment.y != 0 then --si hay incremento
--			(
				
--			)--if
--			------------------------------------------------------------------------------
--		)

--		------------------------------------------------
--		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
--		------------------------------------------------
--		fn saveSettings =
--		(
--			--almacena posicion
--			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
--			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
--			--almacena tamaño
--			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
--			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
--		)
		
--		------------------------------------------------
--		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
--		------------------------------------------------
--		fn loadSettings =
--		(
--			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
--			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
--			--posicion
--			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
--			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
--			--establece minimos
--			if _width < minRollWidth then _width = minRollWidth
--			if _height < minRollHeight then _height = minRollHeight
--			if _posX < 0 then _posX = 0
--			if _posY < 0 then _posY = 0
				
--			--aplica los valores
--			rollMainDef.width = _width
--			rollMainDef.height = _height
--			setDialogPos rollMainDef [_posX,_posY]
--		)
		
--		------------------------------------------------------------------------------------------------
--		--EVENTS
--		------------------------------------------------------------------------------------------------
		
--		------------------------------------------------
--		--COMMON
--		------------------------------------------------

--		on btnHairExport pressed do
--		(
--			hairShadowsExporter()
--		)

--		------------------------------------------------
--		--@event: resized | Evento que se lanza al redimensionar el rollout.
--		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
--		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
--		------------------------------------------------
--		on rollMainDef resized size do
--		(
--			resize size
--		)
		
--		------------------------------------------------
--		--@event: open | Evento que se lanza al abrir el rollout.
--		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
--		------------------------------------------------
--		on rollMainDef open do
--		(
--			loadSettings()
--			createSceneEvents() --crea los callbacks
--			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
--		)
		
--		------------------------------------------------
--		--@event: close | Evento que se lanza al cerrar el rollout.
--		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
--		------------------------------------------------
--		on rollMainDef close do
--		(
--			removeSceneEvents() --elimina los callbacks
--			saveSettings()
			
--			parent.opened = false --indica que la herramienta está cerrada.
--			updateToolbarButtons()
--		)
--	)--rollMainDef
	
--	------------------------------------------------------------------------------------------------------------------------------------------------
--	--@struct: templateTool | Contiene la herramienta plantilla.
--	------------------------------------------------------------------------------------------------------------------------------------------------
--	struct tl_hairDraftExporter
--	(
--		------------------------------------------------------------------------------------------------
--		--COMMON
--		------------------------------------------------------------------------------------------------
		
--		def = (classof this),				--@var: def | Almacena la definicion del struct.
--		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
--		category = #main,					--@var: category | Categoria de la tool.
--		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
--		description = "hairDraftExporter",		--@var: description | Descripcion de la tool.
		
--		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
--		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
--		------------------------------------------------------------------------------------------------
--		--VARIABLES
--		------------------------------------------------------------------------------------------------
			
--		------------------------------------------------------------------------------------------------
--		--LIBRARIES
--		------------------------------------------------------------------------------------------------
		
--		------------------------------------------------------------------------------------------------
--		--ROLLOUTS
--		------------------------------------------------------------------------------------------------
		
--		rollMain = rollMainDef,	--@var: rollMain | Almacena el rollout principal de la herramienta.
			
--		------------------------------------------------------------------------------------------------
--		--FUNCTIONS
--		------------------------------------------------------------------------------------------------
			
--		------------------------------------------------
--		--GETS
--		------------------------------------------------
		
--		------------------------------------------------
--		--SETS
--		------------------------------------------------
		
--		------------------------------------------------
--		--OTHER
--		------------------------------------------------
		
--		------------------------------------------------
--		--COMMON
--		------------------------------------------------
		
--		------------------------------------------------
--		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
--		------------------------------------------------
--		fn isOpen =
--		(
--			this.opened
--		),
		
--		------------------------------------------------
--		--@fn: undefined | refreshInterface | Refresca el interface inicial de la herramienta
--		------------------------------------------------
--		fn refreshInterface =
--		(
--			--refresca el interface de la herramienta
--		),
		
--		------------------------------------------------
--		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
--		------------------------------------------------
--		fn createInterface =
--		(
--			--crea el interface, lo redimensiona y lo reposiciona
--			createDialog this.rollMain lockwidth:true lockheight:true pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
--		),
		
--		------------------------------------------------
--		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
--		------------------------------------------------
--		fn destroyInterface =
--		(
--			destroyDialog this.rollMain --cierra la herramienta.			
--		),--destroyInterface
		
--		------------------------------------------------
--		--@fn: undefined | run | Lanza la herramienta.
--		------------------------------------------------
--		fn run =
--		(
--			this.createInterface() --crea el interface.
--			this.opened = true --indica que la herramienta está abierta
--		),--execute
		
--		------------------------------------------------
--		--@fn: undefined | close | Cierra la herramienta.
--		------------------------------------------------
--		fn close =
--		(
--			this.destroyInterface() --destruye el interface.
--			this.opened = false --indica que la herramienta está cerrada.
--		),
		
--		------------------------------------------------
--		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrerías en el orden establecido.
--		------------------------------------------------
--		fn initSubLibraries =
--		(
--			_subLibraries = #()
			
--			for sl in _subLibraries do sl.init()
--		),
		
--		------------------------------------------------
--		--@fn: undefined | init | Inicializa la librería.
--		------------------------------------------------
--		fn init =
--		(		
--			this.initSubLibraries() --inicialza las librerías hijas
--		),		
		
--		------------------------------------------------------------------------------------------------
--		--EVENTS
--		------------------------------------------------------------------------------------------------
		
--		------------------------------------------------
--		--@event: create | Ejecución al crearse la instancia del struct.
--		------------------------------------------------
--		on create do
--		(
--			lb.addTool this --añade la tool a la libreria principal	
--		)		
		
--	)--tl_hairDraftExporter
	
--	------------------------------------------------------------------------------------------------------------------------------------------------
--	--EXECUTION
--	------------------------------------------------------------------------------------------------------------------------------------------------	
	
--	tl_hairDraftExporter() --crea la herramienta
--)