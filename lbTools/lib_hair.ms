------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de pelo
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: hair | Contiene la libreria de pelo.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_hair
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria pelo",	--@var: description | Descripcion de la libreria.
		
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
		--@fn: string | hasHairGenerator | Consulta si tiene modificador de pelo
		--@gets: node | node | Nodo a consultar
		--@returns: boolean
		------------------------------------------------
		fn hasHairGenerator node =
		(
			--Buscamos entre todos los subanims del de modificadores el que sea de Hair_Generate
			for i=1 to node[4].numsubs where (classof node[4][i].value) == Hair_Generate do
			(
				return true
			)
			return false
		),

		------------------------------------------------
		--@fn: string | exportHairSimulation | Exporta la simulaci�n de pelo 
		--@gets: node | node | Nodo con el Modificador de pelo
		--@gets: string | outputDir | Ruta del directorio de simulaci�n
		--@returns: boolean | �Preparado para c�digo del infierno? **Habr� que comprobar cuando actualicemos el HairFarm
		------------------------------------------------
		fn exportHairSimulation node outputDir =
		(
			--global para poder leer el par�metro desde dentro del Callback
			global _path

			_bIsDisabled = isSceneRedrawDisabled()	--Guardamos el estado del scene redraw
			if _bIsDisabled do enableSceneRedraw()	--Habilitamos el scene redraw porque lo necesitamos para hacer guarradas

			--Para automatizar el di�logo de exportar simulaci�n
			fn ExportCallback =
			(
				BM_CLICK = 245	--Constante del mensaje de windows de click

				hWND = DialogMonitorOPS.GetWindowHandle()	--Obtenemos el handler de la ventana
				windowTitle = UIAccessor.GetWindowText hWND	--Obtenemos el t�tulo de la ventana

				--Si es la ventana de exportar simulaci�n...
				if windowTitle != undefined and findString windowTitle "Export Simulation Data for " != undefined then
				(
					arHwnd = UIAccessor.getChildWindows hWND	--Obtenemos todos los hijos
					UIAccessor.SetWindowText arHwnd[5] _path	--Al de la ruta de salida le seteamos el texto con la ruta deseada **
					UIAccessor.pressButtonByName hWND "&Save"	--Pulsamos el bot�n de guardado
				)
				--Si es la ventana de confirmar guardado (si existe ya el fichero)...
				else if windowTitle == "Confirm Save As" do
				(
					--...pues le decimos que si
					--UIAccessor.pressButtonByName hWND "&Yes" --No funciona aqu�, adivina t� por qu�
					--Como el m�todo anterior no funciona, recorremos todos los elementos hasta que damos con el bot�n
					for k in (UIAccessor.getChildWindows hWND) where (UIAccessor.GetWindowText k) == "&Yes" do
					(
						windows.sendMessage k BM_CLICK 0 0 --Le mandamos un mensaje de click
						exit --Rompemos el bucle (vaya a ser que haya dos botones)
					)
				)

				true --Devolvemos true porque si no, llora
			)

			--Aqu� empieza la funci�n

			bSuccess = false

			--Los nodos de pelo tienen no pueden estar frezzeados
			_wasFrozen = node.isFrozen
			node.isFrozen = false

			--Buscamos entre todos los subanims del de modificadores el que sea de HairMesh_Sim
			_hairGenerates = for i=1 to node[4].numsubs where (classof node[4][i].value) == Hair_Generate collect node[4][i].value
			
			for i=1 to node[4].numsubs where (classof node[4][i].value) == HairMesh_Sim do
			(
				_hairMeshSim = node[4][i].value
				_hairGenerate = node[4][i-1].value
				if (classof _hairGenerate) != Hair_Generate do
					continue
				_hairGenerateIndex = findItem _hairGenerates _hairGenerate
				if _hairGenerateIndex == 0 do
					continue
				_path = outputDir + (lb.nc.getSimpleObjectName node.name) + "_generate-" + (if _hairGenerateIndex < 10 then "0" else "") + _hairGenerateIndex as string + ".hsb"
				_path = (dotnetclass "System.IO.Path").GetFullPath(_path)

				--Empieza lo bueno... (todo esto simula lo que har�a un usuario en con la interfaz)
				select node								--Seleccionamos el objeto
				max modify mode							--Pasamos al control panel
				modPanel.setCurrentObject _hairMeshSim	--Seleccionamos el modificador

				arHwnd = windows.getChildrenHWND #max	--Obtenemos todos los controles visibles de windows

				--Buscamos un clavo ardiendo al que asirnos, vamos un texto que conozcamos su relatividad** con respecto al resto de controles
				hellIndex = 0
				for h=1 to arHwnd.count where arHwnd[h][5] == "Simulated:" do hellIndex = h

				--Los que est�n en estos �ndices** son tres etiquetas que indican los frames de simulaci�n generada
				--si alguno est� en "---", significa que no hay simulaci�n generada
				--if arHwnd[hellIndex+7][5] == "---" or arHwnd[hellIndex+14][5] == "---" or arHwnd[hellIndex+21][5] == "---" do
				--(
				--	_hairMeshSim.StartSimulation()	--Generamos la simulaci�n si no est� creada (oh, mira una funci�n de la api)
				--)
				
				--solo exportamos si tiene simulaci�n hecha
				if arHwnd[hellIndex+7][5] != "---" or arHwnd[hellIndex+14][5] != "---" or arHwnd[hellIndex+21][5] != "---" do
				(
					--Registramos el callback que se encargar� de gestionar el di�logo de exportaci�n
					DialogMonitorOPS.RegisterNotification ExportCallback id:#exportCallback
					DialogMonitorOPS.Enabled = true	
					
					--Llamamos al bot�n de guardar simulaci�n
					UIAccessor.PressButton arHwnd[hellIndex+33][1] --Si hijo, si, otro �ndice** (la edad de cristo... curioso �eh?)

					--Desregistramos el callback
					DialogMonitorOPS.unRegisterNotification id:#exportCallback
					DialogMonitorOPS.Enabled = false

					bSuccess = true
				)
			)

			-- Dejamos su estado frozen anterior
			node.isFrozen = _wasFrozen

			if _bIsDisabled do disableSceneRedraw()	--Dejamos el SceneRedraw como estaba

			_path = undefined --para que lo coja el gc

			return bSuccess
		),

		------------------------------------------------
		--@fn: string | importHairSimulation | Importa una simulaci�n de pelo 
		--@gets: node | node | Nodo con el Modificador de pelo
		--@gets: string | inputDir | Ruta del directorio de simulaci�n
		--@returns: boolean | �Preparado para c�digo del infierno? **Habr� que comprobar cuando actualicemos el HairFarm
		------------------------------------------------
		fn importHairSimulation node inputDir =
		(
			bSuccess = true
			--global para poder leer el par�metro desde dentro del Callback
			global _path

			_bIsDisabled = isSceneRedrawDisabled()	--Guardamos el estado del scene redraw
			if _bIsDisabled do enableSceneRedraw()	--Habilitamos el scene redraw porque lo necesitamos para hacer guarradas

			--Para automatizar el di�logo de exportar simulaci�n
			fn ImportCallback =
			(
				BM_CLICK = 245	--Constante del mensaje de windows de click

				hWND = DialogMonitorOPS.GetWindowHandle()	--Obtenemos el handler de la ventana
				windowTitle = UIAccessor.GetWindowText hWND	--Obtenemos el t�tulo de la ventana

				--Si es la ventana de exportar simulaci�n...
				if windowTitle != undefined and findString windowTitle "Import Simulation Data for " != undefined then
				(
					arHwnd = UIAccessor.getChildWindows hWND	--Obtenemos todos los hijos
					UIAccessor.SetWindowText arHwnd[17] _path	--Al de la ruta de salida le seteamos el texto con la ruta deseada **
					UIAccessor.pressButtonByName hWND "&Open"	--Pulsamos el bot�n de guardado
				)

				true --Devolvemos true porque si no, llora
			)

			--Aqu� empieza la funci�n

			_pathPattern = inputDir + (if lb.str.endswith inputDir "\\" then "" else "\\") + (lb.nc.getSimpleObjectName node.name) + "_generate-??.hsb"
			_files = getFiles _pathPattern
			if _files.count == 0 then
			(
				bSuccess = false
			)
			else
			(
				_hairGenerates = for i=1 to node[4].numsubs where (classof node[4][i].value) == Hair_Generate collect node[4][i].value

				for _file in _files do
				(
					_hairGenerateIndex = (substring _file (_file.count-5) 2) as integer
					_hairGenerate = _hairGenerates[_hairGenerateIndex]
					if _hairGenerate == undefined do
					(
						bSuccess = false
						continue
					)

					_hairMeshSim = undefined
					--Buscamos entre todos los subanims del de modificadores el que sea de HairMesh_Sim que vaya a continuaci�n del Hair_Generate
					for i=1 to node[4].numsubs where (classof node[4][i].value) == HairMesh_Sim and node[4][i-1].value == _hairGenerate do
					(
						_hairMeshSim = node[4][i].value
						exit --Rompemos el bucle
					)

					-- Si no lo hemos encontrado, lo a�adimos
					if _hairMeshSim == undefined do
					(
						--Buscamos entre todos los subanims del de modificadores el Hair_Generate correspondiente
						for i=1 to node[4].numsubs where node[4][i].value == _hairGenerate do
						(
							_hairMeshSim = HairMesh_Sim()
							lb.modifiers.insertModifier node _hairMeshSim before:(i+1)
							exit --Rompemos el bucle porque solo lo hacemos una vez
						)
					)

					-- Imposible
					if _hairMeshSim == undefined do
					(
						bSuccess = false
						continue
					)

					_path = (dotnetclass "System.IO.Path").GetFullPath(_file)

					--Empieza lo bueno... (todo esto simula lo que har�a un usuario en con la interfaz)
					select node								--Seleccionamos el objeto
					max modify mode							--Pasamos al control panel
					modPanel.setCurrentObject _hairMeshSim	--Seleccionamos el modificador

					commandPanelFloatin = windows.getchildhwnd 0 "Command Panel"
					parent = if commandPanelFloatin == undefined then #max else commandPanelFloatin[1]

					arHwnd = windows.getChildrenHWND parent	--Obtenemos todos los controles visibles de windows

					--Buscamos un clavo ardiendo al que asirnos, vamos un texto que conozcamos su relatividad** con respecto al resto de controles
					hellIndex = 0
					for h=1 to arHwnd.count where arHwnd[h][5] == "Simulated:" do hellIndex = h

					--Registramos el callback que se encargar� de gestionar el di�logo de exportaci�n
					DialogMonitorOPS.RegisterNotification ImportCallback id:#importCallback
					DialogMonitorOPS.Enabled = true	
					
					--Llamamos al bot�n de cargar simulaci�n
					UIAccessor.PressButton arHwnd[hellIndex+32][1] --Si hijo, si, otro �ndice** (la edad de cristo menos uno... mas curioso a�n �eh?)

					--Desregistramos el callback
					DialogMonitorOPS.unRegisterNotification id:#importCallback
					DialogMonitorOPS.Enabled = false
				)
			)


			if _bIsDisabled do disableSceneRedraw()	--Dejamos el SceneRedraw como estaba

			_path = undefined --para que lo coja el gc

			return bSuccess
		),

		------------------------------------------------
		--@fn: string | clearHairSimulation | Borra la simulaci�n de pelo que haya cargada
		--@gets: node | node | Nodo con el Modificador de pelo
		--@returns: undefined | �Preparado para c�digo del infierno? **Habr� que comprobar cuando actualicemos el HairFarm
		------------------------------------------------
		fn clearHairSimulation node =
		(
			_hairMeshSim = undefined

			_bIsDisabled = isSceneRedrawDisabled()	--Guardamos el estado del scene redraw
			if _bIsDisabled do enableSceneRedraw()	--Habilitamos el scene redraw porque lo necesitamos para hacer guarradas

			--Buscamos entre todos los subanims del nodo modificadores el que sea de HairMesh_Sim
			for i=1 to node[4].numsubs where (classof node[4][i].value) == HairMesh_Sim do
			(
				_hairMeshSim = node[4][i].value
				
				--Empieza lo bueno... (todo esto simula lo que har�a un usuario en con la interfaz)
				select node								--Seleccionamos el objeto
				max modify mode							--Pasamos al control panel
				modPanel.setCurrentObject _hairMeshSim	--Seleccionamos el modificador

				arHwnd = windows.getChildrenHWND #max	--Obtenemos todos los controles visibles de windows

				--Buscamos un clavo ardiendo al que asirnos, vamos un texto que conozcamos su relatividad** con respecto al resto de controles
				hellIndex = 0
				for h=1 to arHwnd.count where arHwnd[h][5] == "Simulated:" do hellIndex = h

				--Llamamos al bot�n de limpiar simulaci�n
				UIAccessor.PressButton arHwnd[hellIndex+34][1] --Si hijo, si, otro �ndice** (la edad de cristo mas uno... super curioso �eh?)
			)

			if _bIsDisabled do disableSceneRedraw()	--Dejamos el SceneRedraw como estaba

		),

		------------------------------------------------
		--@fn: string | loadHairSimulation | Busca, para los assets por par�metro que tengan pelo, si existe cach� de �ste en disco y la carga
		--@gets: array | assets | Assets en los que cargar la cach�
		--@returns: undefined
		------------------------------------------------
		fn loadHairSimulation assets =
		(
			sourceFolder = maxFilePath + "..\\cache\\source\\"
			for _asset in assets do
			(
				for _hairNode in _asset.nodes where (this.hasHairGenerator _hairNode) do
				(
					this.importHairSimulation _hairNode sourceFolder
				)
			)
		),
			
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
			lb.addLibrary this --a�ade la libreria a la principal
		)
		
	)--lib_hair
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_hair() --crea la libreria
)