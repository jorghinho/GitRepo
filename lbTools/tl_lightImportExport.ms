------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta lightImportExport.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta lightImportExport.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "lightImportExport"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		

		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 220		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 175		--@var: minRollHeight | Alto mínimo de la herramienta.
		local iconpath =  if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/"


		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		

		--@control | controlName | Plantilla de comentario para controles
		button btnLoadLights "Load" pos:[5,5] width:25 height:25 images:#(iconpath + "bip_general_i.bmp", undefined, 30, 5, 5, 6, 6,true)
		button btnSaveLights "Save" pos:[35,5] width:25 height:25 images:#(iconpath + "bip_general_i.bmp", undefined, 30, 7, 7, 8, 8,true)
				
		groupBox grpExportImport "" pos:[65,-1] width:150 height:31
		radiobuttons rdoExportImportOptions "" pos:[70,10] width:180 height:20 labels:#("Selected", "All Lights") columns:2
		
		groupBox grpExportOptions "ExportOptions" pos:[5,35] width:210 height:35
		checkbox chkReopen "Reload file after save" pos:[10,50] checked:false tooltip:"Optionally reopens file after exporting lights, because scenes with rigged non point cache characters crash during the export."
		
		groupBox grpImportOptions "ImportOptions" pos:[5,70] width:210 height:80
		checkbox chkLightProperties "Light Properties" pos:[10,85] checked:true enabled:false
		checkbox chkTransforms "Light Transform" pos:[10,100] checked:true
		checkbox chkIncludeExclude "Include/Exclude" pos:[10,115] checked:true
		checkbox chkXrefLights "Overwrite Xref Lights" pos:[10,130] checked:false tooltip:"Current Xref lights will be replaced with imported Xref lights"
		
		label lblFeedback "" pos:[5,155] width:210 height:15 style_sunkenedge:true
		

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
		--@event: pressed | Evento que salta al presionar el boton Export Lights.
		--@control: button | btnSaveLights | Boton para exportar las luces de la escena. Salta una ventana para elegir donde guardar.
		------------------------------------------------
		on btnSaveLights pressed do
		(
			success = false
			nodesToExport = #() --nodos a exportar (luces, sistemas de luces, targets y compass)
				
			if lastUsedPath == undefined then
			(
				lastUsedPath = maxFilePath
				
				if lastUsedPath == "" then
					lastUsedPath = getDir #scene
			)--if
			
			proccess = true --flag para saber si hay que salvar las luces o no
			
			--si hay que salvar el archivo antes de exportar las luces nos lo pregunta
			if getSaveRequired() and chkReopen.checked then
			(
				proccess = yesNoCancelBox "The current .max file has been changed. It should be saved before light export. Do yo want to save it? if you dont changes will be lost."
				
				if proccess == #yes then
					proccess = saveMaxFile (maxFilePath + maxFileName) clearNeedSaveFlag:true
				else
					proccess = (proccess != #cancel)
			)--if getSaveRequired
				
			--pregunta que nombre queremos darle al archivo de luces exportadas-------------------------------------
			file = undefined
			if proccess then 
				file = getSaveFileName caption:"Export Lights" filename:(lastUsedPath+ "\\" + (getFilenameFile  maxFileName) + ".lght") types:"LIGHT(*.lght)\*.lght"
			
			if file != undefined then --si se ha obtenido un nombre de fichero que guardar
			(
				lastUsedPath = getFilenamePath file --almacena el ultimo path usado
				
				setWaitCursor() --pone el cursor de espera
				
				--si el archivo existe previamente lo elimina-------------------------------------------------------------------------------------------
				if doesFileExist file then deleteFile file
				--------------------------------------------------------------------------------------------------------------------------------------------
				
				--------------------------------------------------------------------------------------------------------------------------------------------
			)--if
			
			_result = lb.lights.exportLights file (rdoExportImportOptions.state == 1) chkReopen.checked

			--da feedback de si se ha conseguido realizar la operacion correctamente
			lblFeedback.text = if _result == #success then "Lights export OK." else if _result == #error then "Lights NOT exported."

			if _result == noLights then
			(
				lblFeedback.text += "No lights selected or no lights in scene."
				messageBox "Lights not exported. There are no lights selected or no lights in scene."
			)
		)

		------------------------------------------------
		--@event: pressed | Evento que salta al presionar el boton Import Lights.
		--@control: button | btnLoadLights | Boton para importar el archivo .lghts. Se abre una ventana para poder elegir el archivo deseado.
		------------------------------------------------
		on btnLoadLights pressed do
		(
			success = false
			nodesToImport = #() --nodos a importar (luces, sistemas de luces, targets y compass)
			
			if lastUsedPath == undefined then
			(
				lastUsedPath = maxFilePath
				
				if lastUsedPath == "" then
					lastUsedPath = getDir #scene
			)--if
				
			--pregunta que nombre queremos darle al archivo de luces exportadas
			file = getOpenFileName caption:"Import Lights" filename:lastUsedPath types:"LIGHT(*.lght)\*.lght"
			
			if file != undefined and doesFileExist file then --si se ha obtenido un archivo del que importar
			(
			 _result = lb.lights.importLights file (rdoExportImportOptions.state == 1) properties:chkLightProperties.checked transform:chkTransforms.checked includeExclude:chkIncludeExclude.checked overWriteXref:chkXrefLights.checked 
			)--if
			
			--da feedback de si se ha conseguido realizar la operacion correctamente
			lblFeedback.text = if success then "Lights import OK." else "Lights NOT imported."
			if rdoExportImportOptions.state == 1 and nodesToImport.count == 0 and (lb.lights.getSceneLights()).count != 0 then
			(
				lblFeedback.text += "No lights selected."
				lb.message.show "Lights not imported. There is no lights selected." type:#message pos:undefined size:[300,75] modal:true
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
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
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
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
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
	--@struct: lightImportExport | Contiene la herramienta lightImportExport.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_lightImportExport
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #lighting,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool plantilla",		--@var: description | Descripcion de la tool.
		
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
		
	)--tl_lightImportExport
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_lightImportExport() --crea la herramienta
)