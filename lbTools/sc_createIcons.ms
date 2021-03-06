------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateScript | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_createIcons
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "create Icons",	--@var: description | Descripcion del script.
		
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
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(
			_asset = lb.asset.getSceneAssets()
			
			if _asset[1] != undefined then
			(
				lb.assetbrowser.close()		--cierra el assetBrowser.
				--Genera c�mara seg�n el viewport.
				macros.run "Lights and Cameras" "Camera_CreateFromView"
				_camera = cameras[1]	--Seleccionamos c�mara en variable.
				
				--Obtener la ruta y nombre de archivo para pasarlo mas adelante.
				_folder = _asset[1].folder
				_folderImage = "\\image\\sample"
				_filePath = _asset[1].filepath
				_fileName = filterString _filePath "\\"
				_filePart = filterString _fileName[_fileName.count] "."
				_filePartName = filterString _filePart[1] "_"
				
				if _filePartName[3] == lb.nc.NC_layoutFileName then
					for o in _asset[1].animNodesAll do o.renderable = on	--pasar los anim a renderer si es para layout.
				
				if _fileName[1] == "w:" then
				(
					_folderlightRig = (@"W:\resource\art\lightRig\chr\" + _filePartName[1] + "_lightRig(std-std)_" + _filePartName[3] "_v01.max")
					_folderCompRig = (@"W:\resource\art\lightRig\chr\" + _filePartName[1] + "_lightRig(std-std)_" + _filePartName[3] + "_v01.rps")
				)
				else
				(
					_folderlightRig = (@"Y:\resource\art\lightRig\chr_lightRig\chr_lightRigSetUp-turnAround.max")
					_folderCompRig = (@"Y:\resource\art\lightRig\chr_lightRig\chr_lightRig-setUp.rps")
				)
				--Mergea el Set de luces.
				_mergeFile = mergeMAXFile _folderlightRig
				
				--Cambia motor de render a mentalRay.
				_renderClass = RendererClass.classes
				
				_index = 0
				for i = 1 to _renderClass.count where _renderClass[i] == mental_ray_renderer do
					_index = i
				
				if _index != 0 then 
					renderers.current = RendererClass.classes[_index]()
				
				--Carga el preset "chr_lightRig-setUp" y carga sus categorias.
				renderPresets.Load 0 _folderCompRig #{32}
				_category = renderPresets.LoadCategories _folderCompRig
				renderPresets.Load 0 _folderCompRig _category
				
				--opciones Render Setup.
				renderWidth = 136
				renderHeight = 136
				
				--Crear el render y configurar TAMA�O, RUTA y NOMBRE.
				tif.itifio.setAlpha #true
				tif.itifio.setType #color
				tif.itifio.setCompression #none
				_renderIcono = render _camera outputwidth:136 outputheight:136 gamma:1.84 outputfile:(_folder + _folderImage + "\\" + _filePartName[1] + "_" + _filePartName[2] + "_sample.tif") --vfb:off
				
				delete _camera  --Eliminar c�mara.
				
				--Delete objetos mergeados, junto con el layer.
				_layer = lb.layer.getLayerbyName ("_" + lb.nc.NC_classLight + "_")
				_objLayer = lb.layer.getLayerNodes _layer
				delete _objLayer
				lb.layer.deleteLayerByName ("_" + lb.nc.NC_classLight + "_")
				
				if displaySafeFrames == off then	--Activa la opci�n de viewport de show safe Frames.
					displaySafeFrames = on
				
				lb.message.show "Sample Save" type:#message pos:undefined size:[300,75] modal:true
			)
			else
			(
				lb.message.show "No Asset" type:#message pos:undefined size:[300,75] modal:true
			)
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
			lb.addScript this --a�ade el script a la libreria principal
		)
		
	)--sc_templateScript
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_createIcons() --crea el script
)