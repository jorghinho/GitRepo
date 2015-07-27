------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Herramienta assetTextureResourceCollector.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | Contiene la herramienta assetTextureResourceCollector.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Asset Texture Resource Collector"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 160															--@var: integer | minRollWidth | Ancho m�nimo de la herramienta.
		local minRollHeight = 70															--@var: integer | minRollHeight | Alto m�nimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		button btnTextureCollector "Collect textures" pos:[5,10] width:150 height:50 highlightColor:(color 255 195 0) enabled:true 
		
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
		--@fn: undefined | textureCollector | El proceso consulta que los materiales usados en los objetos de escena, si no se encuentran enrutados en la carpeta actual, los direcciona a la carpeta texture de la escena; si no existen en la carpeta de la escena los copia all� y los reenruta.
		------------------------------------------------		
		fn textureCollector =
		(
			setWaitCursor()
			_process = lb.message.show "Proccess doesn't have undo. Do you want to continue?" type:#query

			if _process then
			(
				_filePathOrg = maxfilepath
				_filePathParts = filterString _filePathOrg "\\"

				_fileName = maxfilename
				_fileNameParts = filterString _fileName "("

				if (_filePathParts[_filePathParts.count] != lb.nc.NC_baseFolderName) and (_filePathParts[_filePathParts.count] != lb.nc.NC_partFolderName) then
					lb.message.show "Asset should stay in part or base folder. Process will not continue." type:#message
				else
				(
					_objMats = lb.materials.getSceneMaterials()
					for j=1 to _objMats.count do
					(
						_objBitmaps = (lb.materials.getBitmaps _objMats[j])

						_filePath = (lb.io.getDirName (lb.io.getDirName _filePathOrg)) + "\\" + lb.nc.NC_textureFolderName + "\\"

						for i=1 to _objBitmaps.count do
						(
							_bmpPath = getFilenamePath _objBitmaps[i]
							if (tolower _filePath) != (tolower _bmpPath) then 
							(	
								_currBitmapName = getFilenameFile _objBitmaps[i]
								_currExt = getFilenameType _objBitmaps[i]
								_objBitmapsNameParts = filterString _currBitmapName "_"
								_defName = ""

								if _objBitmapsNameParts.count == 3 then
								(
									if findItem lb.nc.NC_mapTypes _objBitmapsNameParts[2] == 0 then
									(
										_objBitmapsNameParts[2] = lb.nc.NC_mapDiffuse
									)		

									if findItem lb.nc.NC_flagsDetailLevels _objBitmapsNameParts[3] == 0 then
									(
										_objBitmapsNameParts[3] = lb.nc.NC_notSpecifiedFlag
									)
									--Montar la parte de nameparts que hemos cambiado seaprado por guiones bajos.
									_defName = _fileNameParts[1] + "_" + _objBitmapsNameParts[1] + "_" + _objBitmapsNameParts[2] + "_" + _objBitmapsNameParts[3]
								)
								else if _objBitmapsNameParts.count == 5 then
								(
									_tempFileNameParts = filterString _fileNameParts[1] "_"
									_objBitmapsNameParts[1] = _tempFileNameParts[1]
									_objBitmapsNameParts[2] = _tempFileNameParts[2]

									_defName = _objBitmapsNameParts[1] + "_" + _objBitmapsNameParts[2] + "_" + _objBitmapsNameParts[3] + "_" + _objBitmapsNameParts[4] + "_" + _objBitmapsNameParts[5]
								)
								else
								(
									_newName = _currBitmapName
									_newNameParts = filterString _newName "_"
									_finalName = ""
									for i=1 to _newNameParts.count do
									(
										_newNameParts[i][1] = if i==1 then toLower _newNameParts[i][1] else toUpper _newNameParts[i][1]
										_finalName += _newNameParts[i]
									)
									_defName = _fileNameParts[1] + "_" + _finalName + "_" + lb.nc.NC_mapDiffuse + "_" + lb.nc.NC_notSpecifiedFlag 
								)
								print _objBitmaps
								print _filePath
								print _defName 
								print _currExt
								
								copyFile _objBitmaps[i] (_filePath + _defName + _currExt)
								lb.materials.redirectMatBitmaps _objMats[j] (_bmpPath + _currBitmapName) (_filePath + _defName) lower:false
							)
						)

						--RENOMBRAMOS EL MATERIAL
						_prpName = maxfilename
						_prpNameParts = filterString _prpName "_"
						_matName = _objMats[j].name
						_matNameParts = filterString _matName "_"

						if _matNameParts.count == 3 then
						(
							if (tolower _matNameParts[1]) != (tolower _prpNameParts[1]) or (tolower _matNameParts[2]) != (tolower _prpNameParts[2]) then	
								_matName = _prpNameParts[1] + "_" + _prpNameParts[2] + "_" + _matNameParts[3]

								_objMats[j].name = _matName
						)
						else if _matNameParts.count == 0 then
						(
							_matName = _prpNameParts[1] + "_" + _prpNameParts[2] + "_" + "noName"
							_objMats[j].name = _matName
						)
						else
						(
							_newMatName = _objMats[j].name
							_newMatNameParts = filterString _newMatName "_"
							_finalMatName = ""
							for i=1 to _newMatNameParts.count do
							(
								_newMatNameParts[i][1] = if i==1 then toLower _newMatNameParts[i][1] else toUpper _newMatNameParts[i][1]
								_finalMatName += _newMatNameParts[i]
							)
							_defMatName = _prpNameParts[1] + "_" + _prpNameParts[2] + "_" + _finalMatName 
							_objMats[j].name = _defMatName
						)
					)
				)
			)
			lb.message.show "The process has been completed successfully." type:#message
			setArrowCursor()
		)		
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
		--@gets: point2 | size | Tama�o nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona m�s peque�a que el m�nimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al m�nimo.
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
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuraci�n de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tama�o
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuraci�n de la misma.
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

		on btnTextureCollector pressed do
		(
			textureCollector()
		)

		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensi�n. El rollout principal de la herramienta.
		--@gets: point2 | size | tama�o al que se ha redimensionado el rollout
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
			
			parent.opened = false --indica que la herramienta est� cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: assetTextureResourceCollector | Contiene la interfaz de la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_assetTextureResourceCollector
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),														--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),											--@var: string |defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,															--@var: name |category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),			--@var: string |className | Nombre de la tool.
		description = "assetTextureResourceCollector",								--@var: string |description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string |cfgFile | Archivo de configuracion de la tool.
			
		opened = false,																--@var: boolean |opened | Indica si la herramienta est� abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,														--@var: rollout | rollMain | Almacena el rollout principal de la herramienta.
			
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
		--@fn: boolean | isOpen | Devuelve informaci�n true o false, si la herramienta est� abierta o cerrada.
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
			this.opened = true --indica que la herramienta est� abierta
		),--execute
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
		------------------------------------------------
		fn close =
		(
			this.destroyInterface() --destruye el interface.
			this.opened = false --indica que la herramienta est� cerrada.
		),
		
		------------------------------------------------
		--@fn: undefined | initSubLibraries | Inicializa todas las sublibrer�as en el orden establecido.
		------------------------------------------------
		fn initSubLibraries =
		(
			_subLibraries = #()
			
			for sl in _subLibraries do sl.init()
		),
		
		------------------------------------------------
		--@fn: undefined | init | Inicializa la librer�a.
		------------------------------------------------
		fn init =
		(		
			this.initSubLibraries() --inicialza las librer�as hijas
		),		
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecuci�n al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addTool this --a�ade la tool a la libreria principal	
		)		
		
	)--tl_assetTextureResourceCollector
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_assetTextureResourceCollector() --crea la herramienta
)