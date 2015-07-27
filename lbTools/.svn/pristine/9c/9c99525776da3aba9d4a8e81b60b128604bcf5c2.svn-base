(
	----------------------------------------------------------------------------
	--SUBMIT MAX TO DEADLINE FUNCTIONS
	--Started: 2005/09/23
	--Edited:  2010/06/11
	--Code by 
	--	bobo.petrov@primefocusworld.com
	--	ryan.russell@primefocusworld.com
	----------------------------------------------------------------------------
	--Copyright (c) 2005-2010 Prime Focus
	--All rights reserved.
	----------------------------------------------------------------------------	

--  
-- 	global SMTD_MainRollout		--contains the main rollout (dialog)
-- 	global SMTDFunctions			--contains the structure of functions 
-- 	global SMTDPaths				--contains the structure of paths
-- 	global SMTDSettings 			--contains the structure of settings
-- 	global SMTD_SceneMaterials = #()	--used to collect all scene materials for custom shader rendering
-- 	global SMTD_LastMessage = ""
-- 	global SMTD_objsToBake
-- 	global sfs						-- makes sure the brazil structure is predefined
	
	---------------------------------------------------------------------------
	--Struct de paths de deadline
	---------------------------------------------------------------------------
	struct SMTDPathsStruct			--the structure of system paths used by the submitter
	(
		HomeDir,
		UserHomeDir,
		BinDir,
		LogsDir,
		TempDir,
		SettingsDir,
		DeadlineExec,
		DeadlineBGExec,
		SubmitInfofile,
		JobInfofile ,
		ResultFile,
		BitmapList,
		RestoreTempMaxFile,
		SubmitOutput ,
		SubmitExitCode,
		IniFile,
		ImsqVbscriptFile,
		NetworkRoot
	)--SMTDPathsStruct
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	--crea la instancia global del struct de paths
	SMTDPaths = SMTDPathsStruct()					--the global instance of the paths structure storing the actual paths.
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	--inicializa el path del directorio bin de deadline como vacio
	SMTDPaths.BinDir = ""
	
	--intenta rellenar esa propiedad en el struct leyendo los valores de los archivos de deadline
	try
	(
		local result = -2 --variable de resultado
		
		--ficheros de output temporales, supongo que para logs
		local submitOutputFile = sysInfo.tempdir + "submitOutput.txt"
		local submitExitCodeFile = sysInfo.tempdir + "submitExitCode.txt"
		
		--elimina dichos ficheros
		deleteFile submitOutputFile
		deleteFile submitExitCodeFile
		
		--rellena la variable de argumentos para la ejecución de deadline y lo lanza
		local commandArguments = "-outputfiles \"" + submitOutputFile + "\" \"" + submitExitCodeFile + "\" -getbindirectory"
		local _launch = ShellLaunch "deadlinecommandbg.exe" commandArguments
		if not _launch then _launch = ShellLaunch @"C:\winapp\3D\Deadline\bin\deadlinecommandbg.exe" commandArguments
		---------------------------------------------------------------------------------
		
		---------------------------------------------------------------------------------
		local startTimeStamp = timestamp() --comienza a contar el tiempo
		local ready = false --flag de parada del bucle
		
		while not ready do --mientras no este preparado
		(
			sleep 0.15 --añade un retardo
			
			--si existe en archivo de  submitExitCodeFile
			--suponemos que  "deadlinecommandbg.exe" los vuelve a crear tras haberlos eliminado nosotros
			if doesFileExist submitExitCodeFile do
			(
				local theFile = openFile submitExitCodeFile --abre el archivo
				try(result = readValue theFile)catch(result = -2) --intenta leer el resultado del archivo y si no puede toma como resultado -2
				try(close theFile)catch() --intenta cerrar el archivo
				ready = true --asume que esta preparado, activa el flag de parada
			)--if
			
			--si le lleva más de 10 segundos hacer el proceso, lo para
			if timestamp() - startTimeStamp > 60000 then
			(
				result = -3
				ready = true
			)--if
		)--while not ready
		---------------------------------------------------------------------------------
		
		---------------------------------------------------------------------------------
		if result == 0 then --si ha tenido exito al ller el valor y todo esta correcto
		(
			local resultFile = OpenFile submitOutputFile --abre el otro archivo
			local resultMsg = "" --inicializa el mensaje
			
			if (resultFile != undefined) do --si ha conseguido abrir el archivo
			(
				try(resultMsg = readLine resultFile)catch() --lee el mensaje del fichero
				try(close resultFile)catch() --intenta cerrar el archivo
			)--if
			
			SMTDPaths.BinDir = resultMsg + "\\" --rellena el path con el resultado
		)--if result
		---------------------------------------------------------------------------------
	)
	catch() --intenta rellenar esa propiedad en el struct leyendo los valores de los archivos de deadline
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	--inicializa el path del directorio bin de deadline como vacio
	SMTDPaths.HomeDir = ""
	
	--intenta rellenar esa propiedad en el struct leyendo los valores de los archivos de deadline
	try
	(
		local result = -2 --variable de resultado
		
		--archivos de output generados por deadline
		local submitOutputFile = sysInfo.tempdir + "submitOutput.txt"
		local submitExitCodeFile = sysInfo.tempdir + "submitExitCode.txt"
		
		--elimina los archivos
		deleteFile submitOutputFile
		deleteFile submitExitCodeFile
		
		--lanza el proceso de deadliney genera los archivos
		local commandArguments = "-outputfiles \"" + submitOutputFile + "\" \"" + submitExitCodeFile + "\" -gethomedirectory"
		local _launch = ShellLaunch "deadlinecommandbg.exe" commandArguments
		if not _launch then _launch = ShellLaunch @"C:\winapp\3D\Deadline\bin\deadlinecommandbg.exe" commandArguments
		
		---------------------------------------------------------------------------------		
		local startTimeStamp = timestamp() --comienza a contar el tiempo
		local ready = false
		
		--busca el resultado
		while not ready do
		(
			sleep 0.15 --añade un retardo
			
			if doesFileExist submitExitCodeFile do --si el archivo existe
			(
				local theFile = openFile submitExitCodeFile --abre el archivo
				try(result = readValue theFile)catch(result = -2) --lee el valor
				try(close theFile)catch() --cierra el archivo
				ready = true --asume que está listo
			)--if
			
			if timestamp() - startTimeStamp > 60000 then --si el tiempo supera los 10 segundos para
			(
				result = -3
				ready = true
			)--if
		)
		---------------------------------------------------------------------------------
		
		---------------------------------------------------------------------------------
		if( result == 0 ) then --si el resultado es correcto
		(
			local resultFile = OpenFile submitOutputFile --aber el otro archivo
			local resultMsg = "" --incia el mensaje
			
			if (resultFile != undefined) do --si consigue abrir el archivo
			(
				try(resultMsg = readLine resultFile)catch() --intenta leer el mensaje
				try(close resultFile)catch() --intenta cerrar el archivo
			)
			
			SMTDPaths.HomeDir = resultMsg + "\\" --rellena el path con el resultado
		)--if result
		---------------------------------------------------------------------------------
	)
	catch() --intenta rellenar esa propiedad en el struct leyendo los valores de los archivos de deadline
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	--inicializa el path del directorio bin de deadline como vacio
	SMTDPaths.UserHomeDir = ""
	
	--intenta rellenar esa propiedad en el struct leyendo los valores de los archivos de deadline
	try
	(
		local result = -2 --variable de resultado
		
		--archivos de info generados por deadline
		local submitOutputFile = sysInfo.tempdir + "submitOutput.txt"
		local submitExitCodeFile = sysInfo.tempdir + "submitExitCode.txt"
		
		--elimina los archivos
		deleteFile submitOutputFile
		deleteFile submitExitCodeFile
		
		--lanza el comando de deadline para generar los archivos
		local commandArguments = "-outputfiles \"" + submitOutputFile + "\" \"" + submitExitCodeFile + "\" -GetCurrentUserHomeDirectory"
		local _launch = ShellLaunch "deadlinecommandbg.exe" commandArguments
		if not _launch then _launch = ShellLaunch @"C:\winapp\3D\Deadline\bin\deadlinecommandbg.exe" commandArguments
		
		---------------------------------------------------------------------------		
		local startTimeStamp = timestamp() --empieza a contar el tiempo
		local ready = false --falg de parada
		
		--busca el resultado en los archivos de deadline
		while not ready do
		(
			sleep 0.15 --añade un retardo
			
			if doesFileExist submitExitCodeFile do --si el archivo existe
			(
				local theFile = openFile submitExitCodeFile --abre el archivo
				try(result = readValue theFile)catch(result = -2) --intenta leer el resultado
				try(close theFile)catch() --intenta cerrar el archivo
				ready = true --asume que esta preparado
			)--if
			
			if timestamp() - startTimeStamp > 60000 then --si le lleva mas de 10 segundos, para
			(
				result = -3
				ready = true
			)--if
		)--while
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		if( result == 0 ) then --si el resultado es correcto
		(
			local resultFile = OpenFile submitOutputFile --aber el archivos de mensajes
			local resultMsg = "" --inicia el mensaje
			
			if (resultFile != undefined) do --si consigue abrir el archivo
			(
				try(resultMsg = readLine resultFile)catch() --intenta leer el mensaje
				try(close resultFile)catch() --intenta cerrar el archivo
			)--if
			
			SMTDPaths.UserHomeDir = resultMsg + "\\"
		)--if result
		---------------------------------------------------------------------------
	)
	catch() --intenta rellenar esa propiedad en el struct leyendo los valores de los archivos de deadline
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	--el resto de paths se rellena de forma específica
	
	SMTDPaths.TempDir					= SMTDPaths.UserHomeDir + "temp\\"
	SMTDPaths.LogsDir					= SMTDPaths.HomeDir + "logs\\"
	SMTDPaths.SettingsDir				= SMTDPaths.UserHomeDir + "settings\\"
	
	SMTDPaths.DeadlineExec			= SMTDPaths.BinDir + "DeadlineCommand.exe"
	SMTDPaths.DeadlineBGExec		= SMTDPaths.BinDir + "DeadlineCommandBG.exe"
	SMTDPaths.SubmitInfofile			= SMTDPaths.TempDir + "max_submit_info.job"
	SMTDPaths.JobInfofile				= SMTDPaths.TempDir + "max_job_info.job"
	SMTDPaths.ResultFile				= SMTDPaths.TempDir + "max_output.txt"
	SMTDPaths.BitmapList				= SMTDPaths.TempDir + "max_sceneBitmaps.txt"
	SMTDPaths.RestoreTempMaxFile	= SMTDPaths.TempDir + "max_backup_file.mx"
	
	SMTDPaths.SubmitOutput			= sysInfo.tempdir + "submitOutput.txt"
	SMTDPaths.SubmitExitCode		= sysInfo.tempdir + "submitExitCode.txt"
	
	SMTDPaths.InIFile					= GetDir #plugcfg + "\\SubmitMaxToDeadline.ini"
	SMTDPaths.ImsqVbscriptFile		= SMTDPaths.TempDir + "copyImsq.py"
	SMTDPaths.NetworkRoot			= ""
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	--Struct de arrays de referencias externas
	struct SMTDExternalRefsArrayStruct 
	(
		totalSubsArray = #(),
		storeBitmapPath = #(),
		StoreSceneXRefs = #(),
		StoreObjectXRefs = #(),
		StoreSceneVrayProxies = #(),
		StoreSceneMRProxies = #(),
		StoreRendererPaths = #(),
		StoreBrazilv2RendererPaths = #()		
	)--SMTDExternalRefsArrayStruct
	
	--global SMTDExternalRefsArray
	SMTDExternalRefsArray = SMTDExternalRefsArrayStruct() --inicial el struct
	---------------------------------------------------------------------------
	---------------------------------------------------------------------------
	--STRUCT DE SETTINGS
	--The global structure of settings
	--This structure holds ALL settings needed by the submit function,
	--thus there is no need for the actual UI to be ever opened in order to submit a Max scene job
	--Just set the desired settings in this structure or keep the defaults and call the submit function.
	struct SMTDSettingsStructure 						
	(
		JobName = "3ds Max Deadline Job",
		Comment = "",
		UserName = sysinfo.username,
		Department = "",
		Group = "none",
		Groups = #(),
		
		Category = "", --obsolete, left for backwards compatibility 
		Categories = #(), --obsolete, left for backwards compatibility 
		
		theIniFiles = #(),
		theIniFilenames = #(),
		
		RepositoryList = #("DISABLED"),
		RepositoryListActual = #(),
		
		CurrentRepository= "",
		CurrentRepository2= "",
		Pools = #(),
		PoolExclusive = false,
		PoolName = "none",
		SubmitScene = true,
		LocalRendering = true,
		PoolsSort = false, --obsolete, left for backwards compatibility
		Priority = 50,
		LimitEnabled = false,
		MachineLimit = 0,
		RenderOutOfOrder = false,
		OutOfOrderMethod = #normal,
		OutOfOrderStep = 10,
		SubmitAsSuspended = false,
		SubmitAsDependent = false,
		AutoDelete = false,
		OnComplete = "Nothing",
		ChunkSize = 1,
		SequentialJob = false,
		MaxVersionToForce = "none",
		MaxVersionToForceSticky = false,
		
		OverrideFailOnExistingMaxProcess=false,
		FailOnExistingMaxProcess=false,
		
		DisableProgressUpdateTimeout = false,
		JobIsInterruptible = false,
		
		MaxTasksPerSlave = 1,
		LimitTasksToNumberOfCpus = true,
		
		JobsArray = #(),
		FullJobsArray = #(),
		DependencyJobItems = #{},
		ResumeOnDeletedDependencies = false,
		
		TilesInX = 1,
		TilesInY = 1,
		TilesRendering = false,
		TileBlowupMode = false,
		SingleTileJob = true,
		SingleTileJobDependent = true,
		SingleTileJobCleanup = false,
		SingleTileJobLeft = "",
		SingleTileJobRight = "",
		SingleTileJobTop = "",
		SingleTileJobBottom = "",
		SingleTileJobFilename = "",
		SingleTileJobReFilename = "",
		SingleTileJobTileCount = 0,
		SingleTileJobFrameList = "",
		--TilesSubmissionMode = #local,
		TilesPadding = 0,
		TilesSubmissionJobIDs = #(),
		RegionRendering = false,
		RegionLeft=0,
		RegionTop=0,
		RegionRight=100,
		RegionBottom=100,
		RegionType=1,
		RegionUseMaxValues = false,
		CustomTiles = #(),
		UseCustomTiles = false,
		MachineLimitTileJobs = false,
		
		LimitGroups = #(),
		LimitGroupsToUse = #(),
		LimitGroupAutoBrazil = false,
		LimitGroupAutoWorkstation = false,
				
		DropSubmission = false,
		BgSubmission = false,
		UseJpegOutput = false,
		JpegOutputPath = "",
		AlternateEmails = "",
		NotificationNote = "",
		
		TransferPool = "none",
		TransferGroup = "none",
		TransferPriority = 50,
		TransferDeleteOnComplete = true,
		TransferJobAsSuspended = false,
		TransferCompressed = false,
		
		UseAltPluginIni = false,
		AutoSuggestIni = false,
		AltINISelection = 1, 
		AltPluginIni = "",
		AltIniPath = "c:\\",
		
		EnableFailOnBlackFrames = false,
		BlackPixelPercentage = 1,
		BlackPixelThreshold = 0.1,
		BlackFramesCheckRenderElements = false,
		
		RemovePadding = false,
		
		IgnoreMissingExternalFiles = true,
		IgnoreMissingUVWs = true,
		IgnoreMissingXREFs = true,
		IgnoreMissingDLLs = false,
		DisableMultipass = false,
		MergeXRefsOnSubmission = false,
		MergeSceneXRefsOnSubmission = false,
		
		ForceWorkstationMode = false,
		UseSilentMode = true,
		
		RestartRenderer = false,
		StrictOutput = false,
		ShowFrameBuffer = true,
		
		OverrideBitmapPager = false,
		BitmapPager = false,
		
		SubmitExternalFiles = false,
		SubmitExternalFilesMode = 1,
		
		PerformSanityCheck = true,
		DeadlineSubmissionSuccessful = false,
		DeadlineSubmissionLastJobID = "none",
		
		CloseAfterSubmission = false,
		SubmitVisibleObjectsOnly = false,
		
		CopyVbscriptFile = false,
		CreateImsqFile = false,
		CopyImsqFile = false,
		ImsqOutputPath = "",
		
		UsePathConfigFile = false,
		PathConfigFile = "",
		
		RunPreLoadScript = false,
		RunPostLoadScript = false,
		RunPreFrameScript = false,
		RunPostFrameScript = false,
		
		PreLoadScriptFile = "",
		PostLoadScriptFile = "",
		PreFrameScriptFile = "",
		PostFrameScriptFile = "",
		
		RunPreJobScript = false,
		RunPostJobScript = false,
		RunPreTaskScript = false,
		RunPostTaskScript = false,
		
		PreJobScriptFile = "",
		PostJobScriptFile = "",
		PreTaskScriptFile = "",
		PostTaskScriptFile = "",
		
		SubmitAsMXSJob = false,
		MAXScriptFile = "",
		SingleTaskJob = false,
		
		UseCustomShader = false,
		CustomShaderMode = 1,
		--AutoSuggestCategory = true,
		
		UseBatchRender = false,
		
		RenderFramesPreviewJob = false,
		PreviewJobFrameCount  = 3,
		PreviewJobPriorityOffset = 1,
		
		RenderElementsUpdatePaths = true,
		RenderElementsUpdateFilenames = true,
		RenderElementsPermanentChanges = true,
		IgnoreRenderElements = false,
		
		QuicktimeGenerate = false,
		QuicktimeUseGenerator = 1,
		QuicktimeSettingsFile = "",
		QuicktimePoolName = "none",
		QuicktimePoolExclusive = true,
		QuicktimeGroup = "none",
		QuicktimeGamma = 1.0,
		QuicktimeQuality = 75,
		QuicktimeExposure = 0.0,
		QuicktimeProxy = 1,
		QuicktimeFusionVersion = 1,
		QuicktimeCodec = #("Motion JPEG A","Motion JPEG A_mjpa","","",""),
		QuicktimeFusionTemplates = #(#(),#(),#(),#(),#()),
		QuicktimeTemplate = #("","","","",""),
		QuicktimeUseTemplate = #(false,false,false,false,false),
		QuicktimeFilenameMode = 1,
		QuicktimeCustomFilename = "quicktime_animation",
		
		Slaves = #(),
		SlavesList = #(),
		SlavesBlackList = true,
		SlavesNamedSet = "",
		SlaveSettingsSticky = true,
		SlaveInfo = #(),
		SlaveInfoCollected = false,
		
		TimeoutSubmission = 3600,
		TimeoutQTSubmission = 120,
		TimeoutCollectData = 60,
		
		AutomaticallyUpdateJobName = false,
		OverrideLowPriorityThread = true,
		MeditMaterialsStorage = #(),
		ClearMaterialEditorOnSubmission = true,
		
		ExportAdvancedRenderInfoScanline = true,
		ExportAdvancedRenderInfoMentalRay = true,
		ExportAdvancedRenderInfoBrazil = true,
		ExportAdvancedRenderInfoBrazil2 = true,
		ExportAdvancedRenderInfoVRay = true,
		ExportAdvancedRenderInfoKrakatoa = true,
		ExportAdvancedRenderInfoAmaretto = true,
		ExportAdvancedRenderInfoFinalRender = true,
		ExportAdvancedRenderInfoMaxwell = true,
		
		MissingFiles = #(),
		WarnAboutMissingExternalFiles = true,
		
		ScheduledType=#none,  --None/Once/Daily
		ScheduledDays=1,		
		ScheduledStartDateTime="", --dd/MM/yyyy HH:mm
		
		TaskTimeoutEnabled = false,
		TaskTimeout = 0,
		AutoTaskTimeout = false,
		RestartMax = false,
		
		IsBakeJob = false
	)--SETTINGS
		
	SMTDSettings = SMTDSettingsStructure()
	---------------------------------------------------------------------------
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	--LO DESACTIVAMOS PORQUE NOSOTROS LO PONEMOS A 100
	--Increase heal size to 64 MB just in case.
	if heapSize < 67108864 do heapSize = 67108864
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	---------------------------------------------------------------------------
	--STRUCT DE FUNCIONES
	---------------------------------------------------------------------------
	struct SMTDFunctions
	(
		---------------------------------------------------------------------------
		--Returns the name of the plugin to use based on the current max version
		fn getPluginToUse =
		(
			"3dsmax"
		),
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--obtiene la version de max
		fn getMaxVersion =
		(
			_version = "12"
			
			if( ((maxVersion())[1]/1000 as integer) > 9 ) then
			(
				_version = ((((maxVersion())[1]/1000 as integer) + 1998) as string)
				
				--excepcion que hay que tener en cuenta si la version de max es posterior a 2010
				--if (maxVersion())[1] > 12000 then _version = ((12 + 1998) as string)
			)
			else
				_version = (((maxVersion())[1]/1000 as integer) as string)			
				
			_version
		),
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--averigua si un valor de una categoria es STIKY o no
		--devuelve TRUE si lo está
		fn IsSettingSticky theCategory theKey =
		( 
			local theStickyFile = SMTDPaths.NetworkRoot + "\\submission\\3dsmax\\SubmitMaxToDeadline_StickySettings.ini"  
			local theLocalStickyFile = SMTDPaths.SettingsDir + "\\SubmitMaxToDeadline_StickySettings.ini"  
			
			local isSticky = true --If INI key is not set, we assume the setting is sticky
			
			--if there is such a global entry, see whether it is false or not. 
			local theValue = (getINISetting theStickyFile theCategory theKey) --obitiene el valor de la categoria
			if theValue != "" then isSticky = (theValue != "false")
			
			--if there is such a local entry, see whether it is false or not
			local theValue = (getINISetting theLocalStickyFile theCategory theKey)
			if theValue != "" then isSticky = (theValue != "false")
			
			isSticky  --devuelve la respuesta
		),
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--Obtiene el valor por defecto de un valor de una categoria
		fn getGlobalDefault theCategory theKey theDefault executeIt:true =
		(
			local theDefaultFile = SMTDPaths.NetworkRoot + "\\submission\\3dsmax\\SubmitMaxToDeadline_Defaults.ini"  --this is the global defaults file.
			local theKeys = getIniSetting theDefaultFile theCategory  --get all keys from the category in the file
			local result = theDefault --initialize the result to the factory default
			
			if findItem theKeys theKey > 0 do --if a global default exists, 
			(
				local theResult = getIniSetting theDefaultFile theCategory theKey  --get the value from the file
				
				if executeIt then --if necessary, convert to MAXScript value
				(
					result = try(execute theResult)catch(OK)
					if result == OK do result = theDefault --if conversion failed, use the factory default.	
				)
				else
					result = theResult --if no conversion necessary, use the result as is - it will remain a string
			)
			result  --return the global default
		),
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--IMPOSIBLE DEDUCIR QUE LECHES HACE ESTO. YA SE DEDUCIRA
		fn getStickyCaption theCategory theKey theCaption =
		(
			if not (SMTDFunctions.IsSettingSticky theCategory theKey) then
			(
				theCaption
				theCaption[theCaption.count] = "*"
			)--if
			
			theCaption
		),
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--Devuelve el valor de una categoria especifica y clave
		
		--Returns the value of the specified category and key, or the default value if the key is empty.
		--If the executeIt optional keyword is passed as false, the result will be returned as string
		--If true or not specified, the value will be converted to a MAXScript value via execute() call, for example for Integers, Booleans etc.
		fn getINI theCategory theKey theDefault executeIt:true useStickyFile:true =
		(
			local theDefault = SMTDFunctions.getGlobalDefault theCategory theKey theDefault executeIt:executeIt --set the default to global if available
			local result = theDefault --rellena el resultado con el valor por defecto global
			local isSticky = true --coloca el flag de Sticky inicialmente a true
			
			if useStickyFile do isSticky = SMTDFunctions.IsSettingSticky theCategory theKey --averigua si es stycky
			
			if isSticky do --to disable stickyness, enter "false" for the given key. 
			(
				if executeIt then
				(
					result = try(execute (getIniSetting SMTDPaths.InIFile theCategory theKey))catch(OK) --if sticky, try to load from local file.
					if result == OK do result = theDefault --if the value was not in the local file, assume default.
				)
				else 
				(
					result = (getIniSetting SMTDPaths.IniFile theCategory theKey) --if sticky, load from local file without executing.
				)--if else
			)--if isSticky
			
			result --devuelve el resultado
		),
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--Carga los settings almacenadoa en el archivo ini local
		
		--This function loads the STICKY settings from the local INI file and stuffs them into the SMTDSettings structure.
		--After calling this function, all settings that are not marked with * in the UI will be set to the last settings from the UI
		--If you are calling the submit function from an outside script without the UI, you might want to call this function first to
		--replace the factory defaults with the user defaults before submitting...
		fn loadSettings =
		(
			SMTDFunctions.GetNetworkRoot() --obtiene el root de render,supongo que el repositorio
			
			---------------------------------------------------------------------------
			--Rellena propiedades de los settings a partir de los almacenados en el ini
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--JOB SETTINGS			
			
			--obtiene el nombre de job
			SMTDSettings.JobName = SMTDFunctions.getInI "JobSettings" "JobName" SMTDSettings.JobName executeIt:false
			
			--------------------------------------------
			--si el nombre del job esta vacio
			if SMTDSettings.JobName == "" then
			(
				if getfilenamefile maxfilename != "" then --obtiene el nombre del archivo y lo usa como nombre de trabajo
					SMTDSettings.JobName = getfilenamefile maxfilename
				else --si no tiene nombre el archivo, le pone untitled
					SMTDSettings.JobName = "Untitled 3ds Max Job"
			)--if
			--------------------------------------------
			
			SMTDSettings.Comment = SMTDFunctions.getInI "JobSettings" "Comment" SMTDSettings.Comment executeIt:false
			
			SMTDSettings.Department = SMTDFunctions.getInI "JobSettings" "Department" SMTDSettings.Department executeIt:false
			--SMTDSettings.PoolExclusive = SMTDFunctions.getInI "JobSettings" "PoolExclusive" SMTDSettings.PoolExclusive
			SMTDSettings.Priority = SMTDFunctions.getInI "JobSettings" "Priority" SMTDSettings.Priority
			SMTDSettings.limitEnabled = SMTDFunctions.getInI "JobSettings" "LimitEnabled" SMTDSettings.LimitEnabled
			SMTDSettings.MachineLimit = SMTDFunctions.getInI "JobSettings" "MachineLimit" SMTDSettings.MachineLimit 
			SMTDSettings.RenderOutOfOrder = SMTDFunctions.getInI "JobSettings" "RenderOutOfOrder" SMTDSettings.RenderOutOfOrder
			SMTDSettings.OutOfOrderStep = SMTDFunctions.getInI "JobSettings" "OutOfOrderStep" SMTDSettings.OutOfOrderStep
			
			local theVal = SMTDFunctions.getInI "JobSettings" "OutOfOrderMethod" SMTDSettings.OutOfOrderMethod executeIt:false
			if theVal == "" then
				SMTDSettings.OutOfOrderMethod = #normal
			else	
				SMTDSettings.OutOfOrderMethod = theVal as name
			
			SMTDSettings.PoolName = SMTDFunctions.getInI "JobSettings" "PoolName" SMTDSettings.PoolName executeIt:false
			SMTDSettings.Group = SMTDFunctions.getInI "JobSettings" "Group" SMTDSettings.Group executeIt:false
			
			SMTDSettings.ChunkSize = SMTDFunctions.getInI "JobSettings" "ChunkSize" SMTDSettings.ChunkSize 
			SMTDSettings.SubmitVisibleObjectsOnly  = SMTDFunctions.getInI "JobSettings" "SubmitVisibleObjectsOnly" SMTDSettings.SubmitVisibleObjectsOnly 
			
			SMTDSettings.RenderFramesPreviewJob = SMTDFunctions.getInI "JobSettings" "RenderFramesPreviewJob" SMTDSettings.RenderFramesPreviewJob 
			SMTDSettings.PreviewJobFrameCount = SMTDFunctions.getInI "JobSettings" "PreviewJobFrameCount" SMTDSettings.PreviewJobFrameCount
			SMTDSettings.PreviewJobPriorityOffset = SMTDFunctions.getInI "JobSettings" "PreviewJobPriorityOffset" SMTDSettings.PreviewJobPriorityOffset
			SMTDSettings.SequentialJob= SMTDFunctions.getInI "JobSettings" "SequentialJob" SMTDSettings.SequentialJob
			SMTDSettings.SubmitAsSuspended = SMTDFunctions.getInI "JobSettings" "SubmitAsSuspended" SMTDSettings.SubmitAsSuspended 
			SMTDSettings.AutoDelete = SMTDFunctions.getInI "JobSettings" "AutoDelete" SMTDSettings.AutoDelete 
			SMTDSettings.OnComplete = SMTDFunctions.getInI "JobSettings" "OnComplete" SMTDSettings.OnComplete executeIt:false 

			SMTDSettings.TaskTimeoutEnabled = SMTDFunctions.getInI "JobSettings" "TaskTimeoutEnabled" SMTDSettings.TaskTimeoutEnabled
			SMTDSettings.TaskTimeout = SMTDFunctions.getInI "JobSettings" "TaskTimeout" SMTDSettings.TaskTimeout
			SMTDSettings.AutoTaskTimeout = SMTDFunctions.getInI "JobSettings" "AutoTaskTimeout" SMTDSettings.AutoTaskTimeout
			SMTDSettings.RestartMax = SMTDFunctions.getInI "JobSettings" "RestartMax" SMTDSettings.RestartMax
			
			SMTDSettings.MaxVersionToForceSticky = SMTDFunctions.getInI "JobSettings" "MaxVersionToForceSticky" SMTDSettings.MaxVersionToForceSticky useStickyFile:false
			
			if SMTDSettings.MaxVersionToForceSticky then --si hay que forzar a usar los valores sticky de version
				SMTDSettings.MaxVersionToForce = SMTDFunctions.getInI "JobSettings" "MaxVersionToForce" SMTDSettings.MaxVersionToForce executeIt:false
			else --si no, mira si es de 64 o de 32 bits
			(
				if is64bitApplication() then
					SMTDSettings.MaxVersionToForce = "64bit"
				else
					SMTDSettings.MaxVersionToForce = "32bit"
			)
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--REMOTE SUBMISSION OPTIONS
			SMTDSettings.DropSubmission = SMTDFunctions.getInI "RemoteSubmission" "DropSubmission" SMTDSettings.DropSubmission
			SMTDSettings.BgSubmission = SMTDFunctions.getInI "RemoteSubmission" "BgSubmission" SMTDSettings.BgSubmission
			
			SMTDSettings.TransferPool = SMTDFunctions.getInI "RemoteSubmission" "TransferPool" SMTDSettings.TransferPool executeIt:false
			SMTDSettings.TransferGroup = SMTDFunctions.getInI "RemoteSubmission" "TransferGroup" SMTDSettings.TransferGroup executeIt:false
			SMTDSettings.TransferPriority = SMTDFunctions.getInI "RemoteSubmission" "TransferPriority" SMTDSettings.TransferPriority
			SMTDSettings.TransferDeleteOnComplete = SMTDFunctions.getInI "RemoteSubmission" "TransferDeleteOnComplete" SMTDSettings.TransferDeleteOnComplete
			SMTDSettings.TransferJobAsSuspended = SMTDFunctions.getInI "RemoteSubmission" "TransferJobAsSuspended" SMTDSettings.TransferJobAsSuspended
			SMTDSettings.TransferCompressed = SMTDFunctions.getInI "RemoteSubmission" "TransferCompressed" SMTDSettings.TransferCompressed
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--RENDERING OPTIONS
			SMTDSettings.UseAltPluginIni = SMTDFunctions.getInI "RenderingOptions" "UseAltPluginIni" SMTDSettings.UseAltPluginIni 
			SMTDSettings.AutoSuggestIni = SMTDFunctions.getInI "RenderingOptions" "AutoSuggest" SMTDSettings.AutoSuggestIni
			SMTDSettings.AltPluginIni = SMTDFunctions.getInI "RenderingOptions" "AltPluginIni" SMTDSettings.AltPluginIni executeIt:false
			
			local rendererID = case (renderers.current.classid as string) of
			(
				"#(1, 0)": "scanline"
				"#(1387076610, 288174012)": "brazil"
				"#(95494396, 474502030)": "brmax"
				"#(1492548972, 1338981315)": "mentalray"
				"#(1941615238, 2012806412)": "vray"
				default: ""
			)
			
			if rendererID == "brazil" or rendererID == "vray" or rendererID == "brmax" then
				SMTDSettings.RestartRenderer = true 
			else
				SMTDSettings.RestartRenderer= SMTDFunctions.getInI "RenderingOptions" "RestartRenderer" SMTDSettings.RestartRenderer
			
			--SMTDSettings.RestartRenderer= SMTDFunctions.getInI "RenderingOptions" "RestartRenderer" SMTDSettings.RestartRenderer
			SMTDSettings.EnableFailOnBlackFrames= SMTDFunctions.getInI "RenderingOptions" "EnableFailOnBlackFrames" SMTDSettings.EnableFailOnBlackFrames
			
			SMTDSettings.BlackPixelPercentage = SMTDFunctions.getInI "RenderingOptions" "BlackPixelPercentage" SMTDSettings.BlackPixelPercentage
			SMTDSettings.BlackPixelThreshold = SMTDFunctions.getInI "RenderingOptions" "BlackPixelThreshold" SMTDSettings.BlackPixelThreshold
			SMTDSettings.BlackFramesCheckRenderElements= SMTDFunctions.getInI "RenderingOptions" "BlackFramesCheckRenderElements" SMTDSettings.BlackFramesCheckRenderElements
			
			SMTDSettings.RenderElementsUpdatePaths = SMTDFunctions.getInI "RenderingOptions" "RenderElementsUpdatePaths" SMTDSettings.RenderElementsUpdatePaths 
			SMTDSettings.RenderElementsUpdateFilenames = SMTDFunctions.getInI "RenderingOptions" "RenderElementsUpdateFilenames" SMTDSettings.RenderElementsUpdateFilenames 
			SMTDSettings.RenderElementsPermanentChanges = SMTDFunctions.getInI "RenderingOptions" "RenderElementsPermanentChanges" SMTDSettings.RenderElementsPermanentChanges 
			SMTDSettings.IgnoreRenderElements = SMTDFunctions.getInI "RenderingOptions" "IgnoreRenderElements" SMTDSettings.IgnoreRenderElements 

			SMTDSettings.OverrideBitmapPager= SMTDFunctions.getInI "RenderingOptions" "OverrideBitmapPager" SMTDSettings.OverrideBitmapPager
			SMTDSettings.BitmapPager= SMTDFunctions.getInI "RenderingOptions" "BitmapPager" SMTDSettings.BitmapPager

			--SMTDSettings.SubmitExternalFiles= SMTDFunctions.getInI "RenderingOptions" "SubmitExternalFiles" SMTDSettings.SubmitExternalFiles
			SMTDSettings.SubmitExternalFilesMode = SMTDFunctions.getInI "RenderingOptions" "SubmitExternalFilesMode" SMTDSettings.SubmitExternalFilesMode
			
			SMTDSettings.ShowFrameBuffer= SMTDFunctions.getInI "RenderingOptions" "ShowFrameBuffer" SMTDSettings.ShowFrameBuffer

			SMTDSettings.MergeXRefsOnSubmission = SMTDFunctions.getInI "RenderingOptions" "MergeXRefsOnSubmission" SMTDSettings.MergeXRefsOnSubmission
			SMTDSettings.MergeSceneXRefsOnSubmission= SMTDFunctions.getInI "RenderingOptions" "MergeSceneXRefsOnSubmission" SMTDSettings.MergeSceneXRefsOnSubmission
			
			SMTDSettings.ForceWorkstationMode= SMTDFunctions.getInI "RenderingOptions" "ForceWorkstationMode" SMTDSettings.ForceWorkstationMode
			SMTDSettings.UseSilentMode= SMTDFunctions.getInI "RenderingOptions" "UseSilentMode" SMTDSettings.UseSilentMode
			
			SMTDSettings.RemovePadding= SMTDFunctions.getInI "RenderingOptions" "RemovePadding" SMTDSettings.RemovePadding
			SMTDSettings.StrictOutput= SMTDFunctions.getInI "RenderingOptions" "StrictOutput" SMTDSettings.StrictOutput

			SMTDSettings.IgnoreMissingExternalFiles = SMTDFunctions.getInI "RenderingOptions" "IgnoreMissingExternalFiles" SMTDSettings.IgnoreMissingExternalFiles
			SMTDSettings.IgnoreMissingUVWs= SMTDFunctions.getInI "RenderingOptions" "IgnoreMissingUVWs" SMTDSettings.IgnoreMissingUVWs

			SMTDSettings.IgnoreMissingDLLs= SMTDFunctions.getInI "RenderingOptions" "IgnoreMissingDLLs" SMTDSettings.IgnoreMissingDLLs
			SMTDSettings.IgnoreMissingXREFs= SMTDFunctions.getInI "RenderingOptions" "IgnoreMissingXREFs" SMTDSettings.IgnoreMissingXREFs
			
			SMTDSettings.DisableMultipass= SMTDFunctions.getInI "RenderingOptions" "DisableMultipass" SMTDSettings.DisableMultipass
			SMTDSettings.RestartRenderer= SMTDFunctions.getInI "RenderingOptions" "RestartRenderer" SMTDSettings.RestartRenderer
			SMTDSettings.DisableProgressUpdateTimeout= SMTDFunctions.getInI "RenderingOptions" "DisableProgressUpdateTimeout" SMTDSettings.DisableProgressUpdateTimeout
			SMTDSettings.JobIsInterruptible= SMTDFunctions.getInI "RenderingOptions" "JobIsInterruptible" SMTDSettings.JobIsInterruptible
			
			SMTDSettings.UseCustomShader = SMTDFunctions.getInI "RenderingOptions" "UseCustomShader " SMTDSettings.UseCustomShader 
			SMTDSettings.CustomShaderMode= SMTDFunctions.getInI "RenderingOptions" "CustomShaderMode" SMTDSettings.CustomShaderMode

			
			SMTDSettings.CreateImsqFile = SMTDFunctions.getInI "RenderingOptions" "CreateImsqFile" SMTDSettings.CreateImsqFile
			SMTDSettings.CopyImsqFile = SMTDFunctions.getInI "RenderingOptions" "CopyImsqFile" SMTDSettings.CopyImsqFile
			SMTDSettings.ImsqOutputPath = SMTDFunctions.getInI "RenderingOptions" "ImsqOutputPath" SMTDSettings.ImsqOutputPath executeIt:false
			
			SMTDSettings.UsePathConfigFile = SMTDFunctions.getInI "RenderingOptions" "UsePathConfigFile" SMTDSettings.UsePathConfigFile
			SMTDSettings.PathConfigFile = SMTDFunctions.getInI "RenderingOptions" "PathConfigFile" SMTDSettings.PathConfigFile executeIt:false
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--SCRIPT OPTIONS
			SMTDSettings.RunPreLoadScript = SMTDFunctions.getInI "Scripts" "RunPreLoadScript" SMTDSettings.RunPreLoadScript
			SMTDSettings.PreLoadScriptFile = SMTDFunctions.getInI "Scripts" "PreLoadScriptFile" SMTDSettings.PreLoadScriptFile executeIt:false
			SMTDSettings.RunPostLoadScript = SMTDFunctions.getInI "Scripts" "RunPostLoadScript" SMTDSettings.RunPostLoadScript
			SMTDSettings.PostLoadScriptFile = SMTDFunctions.getInI "Scripts" "PostLoadScriptFile" SMTDSettings.PostLoadScriptFile executeIt:false
			SMTDSettings.RunPreFrameScript = SMTDFunctions.getInI "Scripts" "RunPreFrameScript" SMTDSettings.RunPreFrameScript
			SMTDSettings.PreFrameScriptFile = SMTDFunctions.getInI "Scripts" "PreFrameScriptFile" SMTDSettings.PreFrameScriptFile executeIt:false
			SMTDSettings.RunPostFrameScript = SMTDFunctions.getInI "Scripts" "RunPostFrameScript" SMTDSettings.RunPostFrameScript
			SMTDSettings.PostFrameScriptFile = SMTDFunctions.getInI "Scripts" "PostFrameScriptFile" SMTDSettings.PostFrameScriptFile executeIt:false
			
			SMTDSettings.RunPreJobScript = SMTDFunctions.getInI "Scripts" "RunPreJobScript" SMTDSettings.RunPreJobScript
			SMTDSettings.PreJobScriptFile = SMTDFunctions.getInI "Scripts" "PreJobScriptFile" SMTDSettings.PreJobScriptFile executeIt:false
			SMTDSettings.RunPostJobScript = SMTDFunctions.getInI "Scripts" "RunPostJobScript" SMTDSettings.RunPostJobScript
			SMTDSettings.PostJobScriptFile = SMTDFunctions.getInI "Scripts" "PostJobScriptFile" SMTDSettings.PostJobScriptFile executeIt:false
			SMTDSettings.RunPreTaskScript = SMTDFunctions.getInI "Scripts" "RunPreTaskScript" SMTDSettings.RunPreTaskScript
			SMTDSettings.PreTaskScriptFile = SMTDFunctions.getInI "Scripts" "PreTaskScriptFile" SMTDSettings.PreTaskScriptFile executeIt:false
			SMTDSettings.RunPostTaskScript = SMTDFunctions.getInI "Scripts" "RunPostTaskScript" SMTDSettings.RunPostTaskScript
			SMTDSettings.PostTaskScriptFile = SMTDFunctions.getInI "Scripts" "PostTaskScriptFile" SMTDSettings.PostTaskScriptFile executeIt:false
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--USER OPTIONS
			SMTDSettings.PerformSanityCheck = SMTDFunctions.getInI "UserOptions" "PerformSanityCheck" SMTDSettings.PerformSanityCheck
			SMTDSettings.SubmitScene = SMTDFunctions.getInI "UserOptions" "SubmitScene" SMTDSettings.SubmitScene
			SMTDSettings.LocalRendering = SMTDFunctions.getInI "UserOptions" "LocalRendering" SMTDSettings.LocalRendering
			
			--SMTDSettings.PoolsSort= SMTDFunctions.getInI "UserOptions" "PoolsSort" SMTDSettings.PoolsSort
--			SMTDSettings.CloseAfterSubmission = SMTDFunctions.getInI "UserOptions" "CloseAfterSubmission" SMTDSettings.CloseAfterSubmission
			--SMTDSettings.AutoSuggestCategory = SMTDFunctions.getInI  "UserOptions"  "AutoSuggestCategory" SMTDSettings.AutoSuggestCategory 
			SMTDSettings.OverrideLowPriorityThread = SMTDFunctions.getInI "UserOptions" "OverrideLowPriorityThread" SMTDSettings.OverrideLowPriorityThread
			SMTDSettings.ClearMaterialEditorOnSubmission = SMTDFunctions.getInI "UserOptions" "ClearMaterialEditorOnSubmission" SMTDSettings.ClearMaterialEditorOnSubmission
			SMTDSettings.AutomaticallyUpdateJobName = SMTDFunctions.getInI "UserOptions" "AutomaticallyUpdateJobName" SMTDSettings.AutomaticallyUpdateJobName
			
			SMTDSettings.TimeoutSubmission = SMTDFunctions.getInI "UserOptions" "TimeoutSubmission" SMTDSettings.TimeoutSubmission
			SMTDSettings.TimeoutQTSubmission= SMTDFunctions.getInI "UserOptions" "TimeoutQTSubmission" SMTDSettings.TimeoutQTSubmission
			SMTDSettings.TimeoutCollectData= SMTDFunctions.getInI "UserOptions" "TimeoutCollectData" SMTDSettings.TimeoutCollectData
			
			SMTDSettings.ExportAdvancedRenderInfoScanline = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoScanline" SMTDSettings.ExportAdvancedRenderInfoScanline
			SMTDSettings.ExportAdvancedRenderInfoMentalRay = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoMentalRay" SMTDSettings.ExportAdvancedRenderInfoMentalRay 
			SMTDSettings.ExportAdvancedRenderInfoBrazil = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoBrazil" SMTDSettings.ExportAdvancedRenderInfoBrazil 
			SMTDSettings.ExportAdvancedRenderInfoBrazil2 = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoBrazil2" SMTDSettings.ExportAdvancedRenderInfoBrazil2 
			SMTDSettings.ExportAdvancedRenderInfoVRay = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoVRay" SMTDSettings.ExportAdvancedRenderInfoVRay 
			SMTDSettings.ExportAdvancedRenderInfoKrakatoa = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoKrakatoa" SMTDSettings.ExportAdvancedRenderInfoKrakatoa
			SMTDSettings.ExportAdvancedRenderInfoAmaretto = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoAmaretto" SMTDSettings.ExportAdvancedRenderInfoAmaretto
			SMTDSettings.ExportAdvancedRenderInfoFinalRender = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoFinalRender" SMTDSettings.ExportAdvancedRenderInfoFinalRender
			SMTDSettings.ExportAdvancedRenderInfoMaxwell = SMTDFunctions.getInI "UserOptions" "ExportAdvancedRenderInfoMaxwell" SMTDSettings.ExportAdvancedRenderInfoMaxwell 
			
			SMTDSettings.WarnAboutMissingExternalFiles = SMTDFunctions.getInI "UserOptions" "WarnAboutMissingExternalFiles" SMTDSettings.WarnAboutMissingExternalFiles 
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--LIMIT GROUPS
			SMTDSettings.LimitGroups = SMTDFunctions.getInI "LimitGroups" "LimitGroups" SMTDSettings.LimitGroups
			SMTDSettings.LimitGroups = for i in SMTDSettings.LimitGroups where i != "" collect i --clear empty names
			
			SMTDSettings.LimitGroupsToUse = SMTDFunctions.getInI "LimitGroups" "LimitGroupsToUse" SMTDSettings.LimitGroupsToUse 
			SMTDSettings.LimitGroupsToUse = for i in SMTDSettings.LimitGroupsToUse where i != "" collect i --clear empty names

			SMTDSettings.LimitGroupAutoBrazil = SMTDFunctions.getInI "LimitGroups" "LimitGroupAutoBrazil" SMTDSettings.LimitGroupAutoBrazil
			SMTDSettings.LimitGroupAutoWorkstation = SMTDFunctions.getInI "LimitGroups" "LimitGroupAutoWorkstation" SMTDSettings.LimitGroupAutoWorkstation
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--TILES RENDERING
			SMTDSettings.TilesRendering = SMTDFunctions.getInI "TilesRendering" "TilesRendering" SMTDSettings.TilesRendering
			SMTDSettings.TilesInX = SMTDFunctions.getInI "TilesRendering" "TilesInX" SMTDSettings.TilesInX
			SMTDSettings.TilesInY = SMTDFunctions.getInI "TilesRendering" "TilesInY" SMTDSettings.TilesInY
			SMTDSettings.TilesPadding = SMTDFunctions.getInI "TilesRendering" "TilesPadding" SMTDSettings.TilesPadding
			SMTDSettings.TileBlowupMode = SMTDFunctions.getInI "TilesRendering" "TileBlowupMode" SMTDSettings.TileBlowupMode
			SMTDSettings.SingleTileJob = SMTDFunctions.getInI "TilesRendering" "SingleTileJob" SMTDSettings.SingleTileJob
			SMTDSettings.SingleTileJobDependent = SMTDFunctions.getInI "TilesRendering" "SingleTileJobDependent" SMTDSettings.SingleTileJobDependent
			SMTDSettings.SingleTileJobCleanup = SMTDFunctions.getInI "TilesRendering" "SingleTileJobCleanup" SMTDSettings.SingleTileJobCleanup
			SMTDSettings.MachineLimitTileJobs = SMTDFunctions.getInI "TilesRendering" "MachineLimitTileJobs" SMTDSettings.MachineLimitTileJobs
			SMTDSettings.RegionType = SMTDFunctions.getInI "TilesRendering" "RegionType" SMTDSettings.RegionType
			SMTDSettings.RegionUseMaxValues = SMTDFunctions.getInI "TilesRendering" "RegionUseMaxValues" SMTDSettings.RegionUseMaxValues
			
			--SMTDSettings.TilesSubmissionMode = SMTDFunctions.getInI "TilesRendering" "TilesSubmissionMode" SMTDSettings.TilesSubmissionMode executeIt:false
			--if SMTDSettings.TilesSubmissionMode != "" then 
			--	SMTDSettings.TilesSubmissionMode = SMTDSettings.TilesSubmissionMode as name
			--else	
			--	SMTDSettings.TilesSubmissionMode = #local
			
			--SMTDSettings.TilesRendering = SMTDFunctions.getInI "TilesRendering" "TilesRendering" SMTDSettings.TilesRendering
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--QUICKTIME GENERATION
			SMTDSettings.QuicktimeGenerate = SMTDFunctions.getInI "QuickTime" "Generate" SMTDSettings.QuicktimeGenerate 
			SMTDSettings.QuicktimeUseGenerator = SMTDFunctions.getInI "QuickTime" "UseGenerator" SMTDSettings.QuicktimeUseGenerator 
			SMTDSettings.QuicktimeSettingsFile = SMTDFunctions.getInI "QuickTime" "QuicktimeSettingsFile" SMTDSettings.QuicktimeSettingsFile executeIt:false
			SMTDSettings.QuicktimePoolName = SMTDFunctions.getInI "QuickTime" "QuicktimePoolName" SMTDSettings.QuicktimePoolName executeIt:false
			--SMTDSettings.QuicktimePoolExclusive = SMTDFunctions.getInI "QuickTime" "QuicktimePoolExclusive" SMTDSettings.QuicktimePoolExclusive
			SMTDSettings.QuicktimeGroup = SMTDFunctions.getInI "QuickTime" "QuicktimeGroup" SMTDSettings.QuicktimeGroup executeIt:false
			SMTDSettings.QuicktimeQuality = SMTDFunctions.getInI "QuickTime" "Quality" SMTDSettings.QuicktimeQuality
			SMTDSettings.QuicktimeGamma = SMTDFunctions.getInI "QuickTime" "Gamma" SMTDSettings.QuicktimeGamma
			SMTDSettings.QuicktimeProxy = SMTDFunctions.getInI "QuickTime" "Proxy" SMTDSettings.QuicktimeProxy
			SMTDSettings.QuicktimeExposure = SMTDFunctions.getInI "QuickTime" "Exposure" SMTDSettings.QuicktimeExposure

			SMTDSettings.QuicktimeFusionVersion = SMTDFunctions.getInI "QuickTime" "FusionVersion" SMTDSettings.QuicktimeFusionVersion
			SMTDSettings.QuicktimeCodec = SMTDFunctions.getInI "QuickTime" "Codec" SMTDSettings.QuicktimeCodec
			SMTDSettings.QuicktimeUseTemplate = SMTDFunctions.getInI "QuickTime" "QuicktimeUseTemplate" SMTDSettings.QuicktimeUseTemplate
			SMTDSettings.QuicktimeTemplate = SMTDFunctions.getInI "QuickTime" "QuicktimeTemplate" SMTDSettings.QuicktimeTemplate
			
			SMTDSettings.QuicktimeFilenameMode = SMTDFunctions.getInI "QuickTime" "FilenameMode" SMTDSettings.QuicktimeFilenameMode
			SMTDSettings.QuicktimeCustomFilename = SMTDFunctions.getInI "QuickTime" "CustomFilename" SMTDSettings.QuicktimeCustomFilename executeIt:false
			---------------------------------------------------------------------------
			
			---------------------------------------------------------------------------
			--BLACKLIST
			SMTDSettings.SlaveSettingsSticky = SMTDFunctions.getInI "Blacklist" "SlaveSettingsSticky" SMTDSettings.SlaveSettingsSticky useStickyFile:false
			if SMTDSettings.SlaveSettingsSticky then --if settings are sticky, load the last settings
			(
				SMTDSettings.SlavesBlackList = SMTDFunctions.getInI "Blacklist" "BlackOrWhite" SMTDSettings.SlavesBlackList useStickyFile:false
				SMTDSettings.SlavesList = SMTDFunctions.getInI "Blacklist" "SlavesList" SMTDSettings.SlavesList useStickyFile:false
				SMTDSettings.SlavesNamedSet = SMTDFunctions.getInI "Blacklist" "SlavesNamedSet" SMTDSettings.SlavesNamedSet executeIt:false useStickyFile:false
			)	
			else --if not sticky, make sure the settings in the INI file are reset to defaults
			(
				setIniSetting SMTDPaths.InIFile "Blacklist"  "SlavesNamedSet"  SMTDSettings.SlavesNamedSet 
				setIniSetting SMTDPaths.InIFile "Blacklist"  "BlackOrWhite" (SMTDSettings.SlavesBlackList as string) 
				setIniSetting SMTDPaths.InIFile "Blacklist"  "SlavesList" "#()" 
			)
			---------------------------------------------------------------------------
			
		),--loadSettings
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--carga los settings 
		---------------------------------------------------------------------------
		fn loadSettingsFromBatchNode batchNode loadNotStiky:false =
		(
			_success = true
			
			if lb.customAttributes.hasAttribute batchNode #LPMbatchInfo then --si el nodo tiene informacion de batch
			with printAllelements on (
				_propNames = getPropNames SMTDsettings --obtiene los nombres de las propiedades de Deadline
				
				for exec in batchNode.deadlineSettingsExecutes do --recorre los nombres de las propiedades almacenandolo junto con su valor
					execute exec
				
				--hay algunas propiedades que hay que cargar de forma especifica para que en los trabajos desglosados sean diferentes que en el de desglose
				SMTDsettings.SubmitAsSuspended = batchNode._jobsSuspended
				SMTDsettings.PoolName = batchNode._jobsPool
				SMTDsettings.Group = batchNode._jobsGroup
				SMTDsettings.Priority = batchNode._jobsPriority
				SMTDsettings.SlavesBlackList = if batchNode._jobsBlacklistOption == "blacklisted" then true else false
				SMTDsettings.SlavesList = deepcopy (batchNode._jobsBlacklistSlaves as array)
			)
			else _success = false
			
			_success
		),
		
		---------------------------------------------------------------------------
		--anima el ultimo estado de envío
		fn AnimateLastSubmissionState =
		(
			try
			(
				SMTD_MainRollout.sld_lastSubmissionState.value += 1 
				if SMTD_MainRollout.sld_lastSubmissionState.value >= 100 do SMTD_MainRollout.sld_lastSubmissionState.value = 50
			)
			catch()
		),
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--sustituye espacios por barras bajas en el nombre. Traducción: CHAPUZA, esto se hace con substitutestring
		fn purifyFileName theFileName =
		(
			for i = 1 to theFileName.count do if theFileName[i] == " " do theFileName[i] = "_"
			
			theFileName	
		),
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--obtiene el path del root de render, supongo que el repositorio
		fn GetNetworkRoot =
		(			
			/*--SMTDPaths.NetworkRoot = ""
			--try 
			--(
			--	local fileHandle = openFile( "c:/deadline/deadline.ini" )
			--	if fileHandle != undefined then
			--	(
			--		while not eof fileHandle do
			--		(
			--			local fileLine = readLine fileHandle 
			--			local index = findString fileLine "NetworkRoot="
			--			if index == 1 do SMTDPaths.NetworkRoot = (substring fileLine 13 (fileLine.count-1)) 
			--		)
			--		close fileHandle 
			--	)
			--) catch()
			--SMTDPaths.NetworkRoot*/
			
			--si el path esta vacio
			if SMTDPaths.NetworkRoot == "" do
			(
				try --por si falla, porque no existe el archivo
				(
					local result = SMTDFunctions.waitForCommandToComplete "-getrepositoryroot" 10
					
					if result == #success then
					(
						local resultFile = OpenFile submitOutputFile --abre el archivo de output
						local resultMsg = "" --para el mensaje
						
						if (resultFile != undefined) do --si ha conseguido abrir el fichero
						(
							try(resultMsg = readLine resultFile)catch() --lee el mensaje
							try(close resultFile)catch() --intenta cerrar el archivo
						)
						
						SMTDPaths.NetworkRoot = resultMsg --utiliza el resultaod obtenido como path root
					)
				)
				catch()
			)--if
			
			SMTDPaths.NetworkRoot --lo devuelve
		),--GetNetworkRoot
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--Llama al ejecutable de Deadline con los parametros que necesite y un tiempo de timeOut
		
		--This function calls the deadline executable with the supplied parameters and waits for a specified time in SECONDS for the execution to complete
		--If the result is not returned in the given time, a #timeout result is returned.
		fn waitForCommandToComplete params timeOutInSec =
		(
			local result = -2 --resultado
			
			--elimina los archivos de los logs de submit
			deleteFile SMTDPaths.SubmitExitCode
			deleteFile SMTDPaths.SubmitOutput
			
			--print ("-outputfiles \"" + SMTDPaths.SubmitOutput + "\" \"" + SMTDPaths.SubmitExitCode + "\" " + params)
			--print params
			
			--llama al proceso de Deadline con las opciones correctas
			ShellLaunch SMTDPaths.DeadlineBGExec ("-outputfiles \"" + SMTDPaths.SubmitOutput + "\" \"" + SMTDPaths.SubmitExitCode + "\" " + params)
			
			local startTimeStamp = timestamp() --empieza a contar tiempo
			local ready = false --flag de parada
			
			while not ready do
			(
				sleep 0.15 --añade un retardo
				
				SMTDFunctions.AnimateLastSubmissionState() --anima el ultimo envío
				
				if doesFileExist SMTDPaths.SubmitExitCode do --si existe el log de salida de envio
				(
					local theFile = openFile SMTDPaths.SubmitExitCode --lo abre
					try(result = readValue theFile)catch(result = -2) --obtiene el resultado
					try(close theFile)catch() --lo cierra
					ready = true --para el bucle
				)--if	
				
				if timestamp() - startTimeStamp > timeOutInSec*1000 then --si supera los 10 segundos para
				(
					result = -3
					ready = true
				)--if	
			)--while
			
			
			local _return = #success
			
			case result of
			(
				0: _return = #success
				(-1): _return = #failed
				(-2): _return = #readerror
				(-3): _return = #timeout
			)--case
			
			_return --devuelve el resultado
		),--waitForCommandToComplete
		---------------------------------------------------------------------------
		
		---------------------------------------------------------------------------
		--lee el contenido de un archivo y lo guarda linea a linea en un array
		--This function reads the content of a file into the supplied array.
		fn ReadFileIntoArray theFilename theArray =
		(
			local theFile = OpenFile theFilename 
			local result = #failure
			
			if theFile != undefined then
			(
				try 
				(
					while not eof theFile do append theArray (ReadLine theFile )
					result = #success
				)
				catch()
				
				close theFile 
			)
			else
				result = #fileNotFound
			
			result
		),
		---------------------------------------------------------------------------
		
		--Reads the list of available repositories.
		fn getRepositoryList =
		(
			try(SMTD_MainRollout.Ui_report (">Collecting Repository Networks..."))catch()
			
			local result = #success
			local tempArray = #("DISABLED")
			--SMTDFunctions.ReadFileIntoArray "Y:\\Winnipeg\\Deadline\\RemoteSubmissionRepositories.ini" tempArray
			SMTDFunctions.ReadFileIntoArray "V:\\deadline_synch\\RemoteSubmissionRepositories.ini" tempArray
			
			local tempRepositoryList = #()
			local tempRepositoryListActual = #()
			for i in tempArray do
			(
				local parts = filterString i ","
				append tempRepositoryList parts[1]
				append tempRepositoryListActual parts[2]
			)
			SMTDSettings.RepositoryList = tempRepositoryList
			SMTDSettings.RepositoryListActual = tempRepositoryListActual
			result
		),
		
		fn getRepositoryListFilename =
		(
			local path = GetNetworkRoot() + "\\submission\\3dsmax\\RemoteSubmissionRepositories.ini"
			path
		),
		
		fn getZeros theNumber =
		(
			theCount = (theNumber as string).count
			if theCount < 9999 then
				substring "0000" 1 (4-theCount)
			else
				""	
		),
		
		--Reads the list of available pools
		fn CollectPools =
		(
			try(SMTD_MainRollout.Ui_report (">Collecting Pools..."))catch()
			--local tempArray = #("")
			local tempArray = #()
			local st = timestamp()
			local result = SMTDFunctions.waitForCommandToComplete ("-pools " + SMTDSettings.CurrentRepository ) SMTDSettings.TimeoutCollectData
			if  result == #success then			
			(
				SMTDFunctions.ReadFileIntoArray SMTDPaths.SubmitOutput tempArray
				SMTDSettings.Pools = tempArray
				try(SMTD_MainRollout.Ui_report ("+"+ tempArray.count as string +" Pools Collected in "+ ((timestamp()-st)/1000.0) as string +" sec. " ))catch()
			)
			else
				if result == #timeout then
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Pools in " + SMTDSettings.TimeoutCollectData as string + " seconds.\nConsider Increasing the Data Collection Timeout in the User Options tab."))catch()
				else
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Pools."))catch()
			result 	
		),
		
		--Reads the list of available slaves
		fn CollectSlaves=
		(
			try(SMTD_MainRollout.Ui_report (">Collecting Slaves..."))catch()
			local tempArray = #("")
			local st = timestamp()
			local result = SMTDFunctions.waitForCommandToComplete ("-slaves " + SMTDSettings.CurrentRepository ) SMTDSettings.TimeoutCollectData
			if  result == #success then			
			(
				SMTDFunctions.ReadFileIntoArray SMTDPaths.SubmitOutput tempArray
				SMTDSettings.Slaves = for i in tempArray where i != "" collect i
				try(SMTD_MainRollout.Ui_report ("+"+ tempArray.count as string +" Slaves Collected in "+ ((timestamp()-st)/1000.0) as string +" sec. " ))catch()
				try(SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
			)
			else
				if result == #timeout then
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Slaves in " + SMTDSettings.TimeoutCollectData as string + " seconds.\nConsider Increasing the Data Collection Timeout in the User Options tab."))catch()
				else
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Slaves."))catch()
			result 	
		),	

		--Reads the slave info
		fn CollectSlaveInfo theSlaveName =
		(
			try(SMTD_MainRollout.Ui_report (">Getting Slave Info for [" + theSlaveName + "]"))catch()
			local tempArray = #("")
			local st = timestamp()
			local result = SMTDFunctions.waitForCommandToComplete ("-getslave "+ theSlaveName +" "+ SMTDSettings.CurrentRepository ) SMTDSettings.TimeoutCollectData
			if  result == #success then			
			(
				SMTDFunctions.ReadFileIntoArray SMTDPaths.SubmitOutput tempArray
				SMTDSettings.SlaveInfo = for i in tempArray where i != "" collect i
				try(SMTD_MainRollout.Ui_report ("+"+ tempArray.count as string +" Slave Info collected in "+ ((timestamp()-st)/1000.0) as string +" sec. " ))catch()
				try(SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
			)
			else
				if result == #timeout then
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Slave Info in " + SMTDSettings.TimeoutCollectData as string + " seconds.\nConsider Increasing the Data Collection Timeout in the User Options tab."))catch()
				else
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Slave Info."))catch()
			result 	
		),		
		
		fn CollectSlavesInfo =
		(
			try(SMTD_MainRollout.Ui_report (">Collecting Info on all Slaves"))catch()
			local tempArray = #("")
			local st = timestamp()
			local result = SMTDFunctions.waitForCommandToComplete ("-getslaves "+ SMTDSettings.CurrentRepository ) SMTDSettings.TimeoutCollectData
			if  result == #success then			
			(
				local theSlaveInfoFile = (SMTDPaths.SettingsDir + "slaveselectionsets\\slavesinfo.ini" )
				local theSlaveInfo = createFile theSlaveInfoFile 
				SMTDFunctions.ReadFileIntoArray SMTDPaths.SubmitOutput tempArray
				local currentSlave = #()
				local currentName = ""
				for i in tempArray do
				(
					if matchPattern i pattern:"MachineName*" then currentName = substring i ((findstring i "=")+1) -1
					if i == "" then 
					(
						format "[%]\n" currentName to:theSlaveInfo
						for o in currentSlave do
							format "%\n" o to:theSlaveInfo
						currentName = ""
						currentSlave = #()
					)
					else
						append currentSlave i
				)--end i loop
				close theSlaveInfo
--				edit theSlaveInfoFile 
				try(SMTD_MainRollout.Ui_report ("+"+ tempArray.count as string +" Slave Info Lines collected in "+ ((timestamp()-st)/1000.0) as string +" sec. " ))catch()
				try(SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
			)
			else
				if result == #timeout then
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Slaves Info in " + SMTDSettings.TimeoutCollectData as string + " seconds.\nConsider Increasing the Data Collection Timeout in the User Options tab."))catch()
				else
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Slaves Info."))catch()
			result 		
		),
				
		fn unregisterCallbacks =
		(
			callbacks.removeScripts id:#SubmitMaxToDeadline
		),
		
		fn registerAutoSuggestCallbacks =
		(
			SMTDFunctions.unregisterCallbacks()
			callbacks.addScript #FilePostOpen "try(SMTDFunctions.SuggestAltIni())catch()" id:#SubmitMaxToDeadline
			if (maxVersion())[1]/1000 >= 6 do
				callbacks.addScript #PostRendererChange "try(SMTDFunctions.SuggestAltIni())catch()" id:#SubmitMaxToDeadline
		),
		
		fn CollectAltIni =
		(
			try
			(
				/*
				fileHandle = openFile("c:/deadline/deadline.ini" )
				if fileHandle != undefined then
				(
					while not eof fileHandle do
					(
						fileLine = readLine fileHandle
						index = findString fileLine "NetworkRoot="
						if index == 1 then
						(
							SMTDSettings.AltIniPath = (substring fileLine 13 (fileLine.count-1)) + "\\plugins\\" + SMTDFunctions.getPluginToUse()
							SMTDSettings.theIniFiles = getFiles (SMTDSettings.AltIniPath+ "\\plugin*.ini")
							sort SMTDSettings.theIniFiles
							theFileNames = for i in SMTDSettings.theIniFiles collect getFileNameFile i
							insertItem  "[Default]" theFileNames 1
							SMTDSettings.theIniFilenames = theFileNames
						)
					)
				)
				close fileHandle
				*/
				
				if SMTDPaths.NetworkRoot != "" then
				(
					SMTDSettings.AltIniPath = SMTDPaths.NetworkRoot + "\\plugins\\" + SMTDFunctions.getPluginToUse()
					SMTDSettings.theIniFiles = getFiles (SMTDSettings.AltIniPath+ "\\plugin*.ini")
					sort SMTDSettings.theIniFiles
					theFileNames = for i in SMTDSettings.theIniFiles collect getFileNameFile i
					insertItem  "[Default]" theFileNames 1
					SMTDSettings.theIniFilenames = theFileNames
				)
			) 
			catch
			(
				format "Error Collecting Alternative Plugin.Ini\n"
				SMTDSettings.theIniFiles = #()
				SMTDSettings.theIniFilenames = #("[Default]")
			)
		),
		
		fn SuggestAltIni =
		(
			theRenderClass = substring ((classof renderers.current) as string) 1 3
			case theRenderClass of
			(
				"Def" : SMTDSettings.AltPluginIni = SMTDSettings.theIniFilenames[1]
				"Bra" : for i = 2 to SMTDSettings.theIniFilenames.count do if findstring SMTDSettings.theIniFilenames[i] "brazil" != undefined do SMTDSettings.AltPluginIni = SMTDSettings.theIniFilenames[i]
				"Ent" : for i = 2 to SMTDSettings.theIniFilenames.count do if findstring SMTDSettings.theIniFilenames[i] "entropy" != undefined do SMTDSettings.AltPluginIni = SMTDSettings.theIniFilenames[i]
				"fin" : for i = 2 to SMTDSettings.theIniFilenames.count do if findstring SMTDSettings.theIniFilenames[i] "fr" != undefined or findstring SMTDSettings.theIniFilenames[i] "final" != undefined  do SMTDSettings.AltPluginIni = SMTDSettings.theIniFilenames[i]
				"men" : for i = 2 to SMTDSettings.theIniFilenames.count do if findstring SMTDSettings.theIniFilenames[i] "mr" != undefined or findstring SMTDSettings.theIniFilenames[i] "mental" != undefined  do SMTDSettings.AltPluginIni = SMTDSettings.theIniFilenames[i]
				"VRa" : for i = 2 to SMTDSettings.theIniFilenames.count do if findstring SMTDSettings.theIniFilenames[i] "vray" != undefined do SMTDSettings.AltPluginIni = SMTDSettings.theIniFilenames[i]
				"Max" : for i = 2 to SMTDSettings.theIniFilenames.count do if findstring SMTDSettings.theIniFilenames[i] "maxman" != undefined do SMTDSettings.AltPluginIni = SMTDSettings.theIniFilenames[i]
				default: SMTDSettings.AltPluginIni = SMTDSettings.theIniFilenames[1]
			)
		),


		--Reads the list of existing jobs and their IDs.
		fn CollectJobs userOnly:false=
		(
			try(SMTD_MainRollout.Ui_report (">Collecting Jobs - This operation can take a long time..."))catch()
			local st = timestamp()
			local tempArray= #()
			local result 
			if userOnly then
				result = SMTDFunctions.waitForCommandToComplete ("-getjobs -user "+SMTDSettings.UserName ) SMTDSettings.TimeoutCollectData
			else	
				result = SMTDFunctions.waitForCommandToComplete ("-getjobs" ) SMTDSettings.TimeoutCollectData
			try(SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
			if  result == #success then			
			(
				try
				(
					theFile = openFile SMTDPaths.SubmitOutput 
					while not eof theFile do
					(
						theName = theID = thePlugin = theUser = theDept = theGroup = theStatus = ""
						str = readLine theFile
						if str != "" do
						(
							while str != "" do
							(
								if matchPattern str pattern:"Name=*" do theName = substring str 6 -1
								if matchPattern str pattern:"JobID=*" do theID = substring str 7 -1
								if matchPattern str pattern:"PluginName=*" do thePlugin = substring str 12 -1
								if matchPattern str pattern:"UserName=*" do theUser = substring str 10 -1
								if matchPattern str pattern:"Department=*" do theDept= substring str 12 -1
								if matchPattern str pattern:"Group=*" do theGroup = substring str 7 -1
								if matchPattern str pattern:"Status=*" do theStatus= substring str 8 -1
								str = readLine theFile
							)
							append tempArray #(theName,theID,thePlugin,theUser,theDept,theGroup, theStatus)
						)
					)
					close theFile
				)catch()	
				SMTDSettings.JobsArray = tempArray	
				try(SMTD_MainRollout.Ui_report ("+"+ tempArray.count as string +" Jobs Collected in " + ((timestamp()-st)/1000.0) as string +" sec. " ))catch()
			)
			else
				if result == #timeout then
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Jobs in " + SMTDSettings.TimeoutCollectData as string + " seconds.\nConsider Increasing the Data Collection Timeout in the User Options tab."))catch()
				else
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Jobs."))catch()
			result 	
		),
				
		-- Returns the current user in the deadline.ini file
		fn GetDeadlineUser =
		(
			local user = "";
			try
			(
				--fileHandle = openFile("c:/deadline/deadline.ini" )
				deadlineIniFile = SMTDPaths.UserHomeDir + "deadline.ini"
				fileHandle = openFile( deadlineIniFile )
				if fileHandle != undefined then
				(
					while not eof fileHandle do
					(
						fileLine = readLine fileHandle 
						index = findString fileLine "User="
						if index == 1 then
						user = (substring fileLine 6 (fileLine.count-1))
					)
				)
				close fileHandle 
			)
			catch
			(
				user = ""
			)
						
			user
		),
		
		fn collectSubAnims theObj =
		(
			local theSubsArray = #()
			for i = 1 to theObj.numsubs do
			(
				append theSubsArray (subAnim = theObj[i])
				local theClass = try(classof subAnim.object)catch(undefined)
				if theClass != Unwrap_UVW AND theClass != Master_Point_Controller do
					join SMTDExternalRefsArray.totalSubsArray (SMTDFunctions.collectSubAnims subAnim)
			)	
			theSubsArray
		),

		/*
		fn collectSubAnims theObj =
		(
			local theSubsArray = #()
			append SMTDExternalRefsArray.totalSubsArray theObj
			for i = 1 to theObj.numsubs do
			(
				append theSubsArray (theSubAnim = theObj[i])
				local theClass = try(classof theSubAnim.object)catch(undefined)
				if theClass != Unwrap_UVW AND theClass != Master_Point_Controller do 
					join SMTDExternalRefsArray.totalSubsArray (SMTDFunctions.collectSubAnims theSubAnim)
				if theClass == VRayBump2Normal do
					join SMTDExternalRefsArray.totalSubsArray (SMTDFunctions.collectSubAnims theSubAnim.object.bump_map) 
				if theClass == Unwrap_UVW do 
					for j in theSubAnim.object.texMapList do 
						join SMTDExternalRefsArray.totalSubsArray (SMTDFunctions.collectSubAnims j) 
			)	
			theSubsArray
		),
		*/
		
		
		--Reads the list of available LimitGroups
		fn CollectLimitGroups =
		(
			try(SMTD_MainRollout.Ui_report (">Collecting Limit Groups...Please wait."))catch()
			local tempArray = #("")
			local st = timestamp()
			local result = SMTDFunctions.waitForCommandToComplete ("-limitgroups " + SMTDSettings.CurrentRepository ) SMTDSettings.TimeoutCollectData
			try(SMTD_MainRollout.sld_lastSubmissionState.value = 100)catch()
			if  result == #success then			
			(
				SMTDFunctions.ReadFileIntoArray SMTDPaths.SubmitOutput tempArray
				SMTDSettings.LimitGroups = for i in tempArray where i != "" collect i
				theString = "#("
				for i in SMTDSettings.LimitGroups do (theString += "\"" + i as string + "\",")
				theString += "\"\")"
				setIniSetting SMTDPaths.iniFile "LimitGroups" "LimitGroups" theString 
				
				try(SMTD_MainRollout.Ui_report ("+"+ tempArray.count as string +" Limit Groups Collected in "+ ((timestamp()-st)/1000.0) as string +" sec. " ))catch()
			)
			else
				if result == #timeout then
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Limit Groups  in " + SMTDSettings.TimeoutCollectData as string + " seconds.\nConsider Increasing the Data Collection Timeout in the User Options tab."))catch()
				else
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Limit Groups."))catch()
			result 	
		),		
		
		fn CollectCategories = (), --obsolete, left for backwards compatibility

		
		fn CollectGroups =
		(
			try(SMTD_MainRollout.Ui_report (">Collecting Groups..."))catch()
			--local tempArray = #("")
			local tempArray = #()
			local st = timestamp()
			local result = SMTDFunctions.waitForCommandToComplete ("-groups " + SMTDSettings.CurrentRepository ) SMTDSettings.TimeoutCollectData
			try(SMTD_MainRollout.sld_lastSubmissionState.value = 100)catch()		
			if  result == #success then			
			(
				SMTDFunctions.ReadFileIntoArray SMTDPaths.SubmitOutput tempArray
				SMTDSettings.Groups = tempArray
				try(SMTD_MainRollout.Ui_report ("+"+ tempArray.count as string +" Groups Collected in "+ ((timestamp()-st)/1000.0) as string +" sec. " ))catch()
			)
			else
				if result == #timeout then
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Groups in " + SMTDSettings.TimeoutCollectData as string + " seconds.\nConsider Increasing the Data Collection Timeout in the User Options tab."))catch()
				else
					try(SMTD_MainRollout.Ui_report ("--Failed To Collect Groups."))catch()
			result 	
		),
		
		fn collectMissingFile o = 
		(
			append SMTDSettings.MissingFiles o
		),	
		
		fn checkForMissingMaps =
		(
			SMTDSettings.MissingFiles = #()
			enumerateFiles SMTDFunctions.collectMissingFile #missing
		),

		fn IsLocalPath thePath =
		(
			local localDrives = "abcdefABCDEF"
			if thePath.count > 0 then
				if (maxVersion())[1]/1000 <= 9 then
					if matchPattern thePath pattern:"*:*" AND findString localDrives (substring thePath  1 1) != undefined then
						true
					else
						false
				 --AVG Max2008+ feature which handles UNC paths --more robust :-)
				else if (maxVersion())[1]/1000 >= 10 then
					if pathIsNetworkPath thePath then
						false
					else
						true
			else
				false
		),

		fn convertPathToLocal TextureCacheFolder thePath =
		(
			local newName = copy thePath
			if pathConfig.isUncPath thePath then
			(
				newName[1] = "_"
				newName[2] = "_"
			)
			else
				newName = substituteString newName ":" "_"
			TextureCacheFolder + newName
		),
		
		fn convertPathToRemote TextureCacheFolder thePath =
		(
			local newName = copy thePath 
			newName = substring newName (TextureCacheFolder.count+1) -1
			if newName[1] != "_" and newName[2] == "_" then 
				newName[2] = ":"
			else if newName[1] == "_" and newName[2] == "_" do
			(
				newName[1] = "\\"
				newName[2] = "\\"
			)		
			newName
		),		
		
		fn isPathInLocalCache TextureCacheFolder thePath =
		(
			matchPattern thePath pattern:(TextureCacheFolder+"*")		
		),		

		fn isPropertyOKForSubmissionToRepository thePropName =
		(
			local result = false
			--VRay properties:
			if (renderers.current.classid as string == "#(1941615238, 2012806412)") do
			(
				vr = renderers.current
				if thePropName == #adv_irradmap_loadFileName AND vr.gi_primary_type == 0 AND vr.adv_irradmap_mode == 2 do result = true
				if thePropName == #caustics_loadFileName AND vr.caustics_on == true AND vr.caustics_mode == 1 do result = true
				if thePropName == #photonMap_loadFileName AND (vr.gi_primary_type == 1 OR vr.gi_secondary_type == 1) AND vr.photonMap_mode == 1 do result = true
				if thePropName == #lightcache_loadFileName AND (vr.gi_primary_type == 3 OR vr.gi_secondary_type == 3) AND vr.lightcache_mode == 2 do result = true
			)
			--Mental Ray properties:
			if (renderers.current.classid as string == "#(1492548972, 1338981315)") do 
			(
				mr = renderers.current
				if thePropName == #FinalGatherFilename AND mr.UseFinalGatherFile == true AND mr.FinalGatherFreeze == true do result = true
				--Max2010+ only feature: mr.PhotonFreeze
				if (maxVersion())[1]/1000 >= 12 then
					(if thePropName == #PhotonMapFilename AND (mr.CausticsEnable == true OR mr.GlobalIllumEnable == true) AND mr.PhotonMapUseFile  == true AND mr.PhotonFreeze  == true do result = true)
				else
					(if thePropName == #PhotonMapFilename AND (mr.CausticsEnable == true OR mr.GlobalIllumEnable == true) AND mr.PhotonMapUseFile  == true do result = true)
				if thePropName == #ShadowMapFilename AND mr.EnableShadowMaps  == true AND mr.UseShadowMapFile == true AND mr.ShadowMapRebuild == false do result = true
			)
			--Brazil v1 properties:
			if (renderers.current.classid as string == "#(1387076610, 288174012)") do
			(
				br = renderers.current
				if thePropName == #global_path_filename AND br.global_active == true AND br.global_file_mode == 2 do result = true
				if thePropName == #caustic_path_filename AND br.caustic_active == true AND br.caustic_file_mode == 2 do result = true
			)
			--Brazil 2 properties:
			if (renderers.current.classid as string == "#(95494396, 474502030)") do
			(
				local brazilRenderer = ::sfs.b2_lib.getActiveB2() --Force global scope to access SplutterFish Script libraries!
				local blockNames = #("System_Options_Parameter_Block_Holder","Sampling_Parameter_Block_Holder","Motion_Blur_Parameter_Block_Holder","Ray_Server_Parameter_Block_Holder","Luma_Server_Parameter_Block_Holder","Render_Cache_Parameter_Block_Holder","Photon_Server_Parameter_Block_Holder","Render_Pass_Parameter_Block_Holder")
				if thePropName == #user_filename and brazilRenderer["Render_Cache_Parameter_Block_Holder"].file_mode == 2 do result = true
			)
			result
		),

		fn returnAllBitmaps =
		(
			--print "Collecting Bitmaps..."
			local allBitmaps = #()
			local bitmapsArray = #()
			local theMaterials = #()	

			SMTDExternalRefsArray.totalSubsArray = #()
			SMTDExternalRefsArray.storeBitmapPath = #()
			SMTDExternalRefsArray.StoreObjectXRefs = #()
			SMTDExternalRefsArray.StoreSceneXRefs = #()
			SMTDExternalRefsArray.StoreSceneVrayProxies = #()
			SMTDExternalRefsArray.StoreSceneMRProxies = #()
			SMTDExternalRefsArray.StoreRendererPaths = #()
			SMTDExternalRefsArray.StoreBrazilv2RendererPaths = #()

			local collisions = 0
			local fileNamesForCollisionCheck = #()
			local pathNamesForCollisionCheck = #()
			
			st1 = timestamp()
			for o in objects do 
			(
				SMTDFunctions.collectSubAnims o
			)	
			try(SMTD_MainRollout.Ui_report ("+Traversed " + objects.count as string +" Objects and Collected "+ SMTDExternalRefsArray.totalSubsArray.count as string +" SubAnims in "+ ((timestamp()-st1)/1000.0) as string  + " sec."))catch()
			
			local theRenderer = renderers.current
			local theProps = try(getPropNames theRenderer)catch(#())

			--DEALING WITH RENDERER PROPERTIES FOR BRAZIL 2:
			if theRenderer.classid as string == "#(95494396, 474502030)" then
			(
				local brCounter = 0
				SMTDExternalRefsArray.StoreRendererPaths = #()
				local brazilRenderer = ::sfs.b2_lib.getActiveB2() --Force global scope to access SplutterFish Script libraries!
				local blockNames = #("System_Options_Parameter_Block_Holder","Sampling_Parameter_Block_Holder","Motion_Blur_Parameter_Block_Holder","Ray_Server_Parameter_Block_Holder","Luma_Server_Parameter_Block_Holder","Render_Cache_Parameter_Block_Holder","Photon_Server_Parameter_Block_Holder","Render_Pass_Parameter_Block_Holder")
				for blockName in blockNames do
				(
					local theBlock = brazilRenderer[blockName]
					if theBlock != undefined then
					(
						local propNames = getPropNames theBlock.object
						if propNames != undefined then
						(
							for p in propNames do
							(
								local theProp = (getProperty theBlock.object p)
								if superclassof theProp == TextureMap do
								(
									append theMaterials theProp
									brCounter += 1
								)
							)
						)
					)
				)--end blockName loop
				try(SMTD_MainRollout.Ui_report "")catch()
				case brCounter of
				(
					default: try(SMTD_MainRollout.Ui_report ("+Found "+ brCounter as string+ " Populated Brazil r/s v2 Texture Map Slots.") )catch()
					0: try(SMTD_MainRollout.Ui_report ("--No Populated Brazil r/s v2 Texture Map Slots Found."))catch()
					1: try(SMTD_MainRollout.Ui_report ("+Found One Populated Brazil r/s v2 Texture Map Slot."))catch()
				)					
				
				
				theProp = brazilRenderer["Render_Cache_Parameter_Block_Holder"].user_filename
				if doesFileExist theProp and brazilRenderer["Render_Cache_Parameter_Block_Holder"].file_mode == 2 do 
				(
					if (SMTDSettings.SubmitExternalFilesMode == 2 and SMTDFunctions.IsLocalPath theProp) or (SMTDSettings.SubmitExternalFilesMode == 3) do 
					(
						append SMTDExternalRefsArray.StoreRendererPaths #(theProp, theProp)
						append SMTDExternalRefsArray.StoreBrazilv2RendererPaths #(brazilRenderer["Render_Cache_Parameter_Block_Holder"], #user_filename, theProp)
					)
				)	

				theProp = brazilRenderer["Photon_Server_Parameter_Block_Holder"].gi_user_filename
				if doesFileExist theProp and brazilRenderer["Photon_Server_Parameter_Block_Holder"].gi_file_mode == 2 do 
				(
					if (SMTDSettings.SubmitExternalFilesMode == 2 and SMTDFunctions.IsLocalPath theProp) or (SMTDSettings.SubmitExternalFilesMode == 3) do 
					(
						append SMTDExternalRefsArray.StoreRendererPaths #(theProp, theProp)
						append SMTDExternalRefsArray.StoreBrazilv2RendererPaths #(brazilRenderer["Photon_Server_Parameter_Block_Holder"], #gi_user_filename, theProp)
					)
				)	
				
				theProp = brazilRenderer["Photon_Server_Parameter_Block_Holder"].cst_user_filename
				if doesFileExist theProp and brazilRenderer["Photon_Server_Parameter_Block_Holder"].cst_file_mode == 2 do 
				(
					if (SMTDSettings.SubmitExternalFilesMode == 2 and SMTDFunctions.IsLocalPath theProp) or (SMTDSettings.SubmitExternalFilesMode == 3) do 
					(
						append SMTDExternalRefsArray.StoreRendererPaths #(theProp, theProp)
						append SMTDExternalRefsArray.StoreBrazilv2RendererPaths #(brazilRenderer["Photon_Server_Parameter_Block_Holder"], #cst_user_filename, theProp)
					)
				)	
				
			)
			else			 --DEALING WITH RENDERER PROPERTIES FOR VRAY, MENTAL RAY, BRAZIL V1
			(
				SMTDExternalRefsArray.StoreRendererPaths = for p in theProps collect 
				(
					local theProp = try(getProperty theRenderer p)catch(undefined)
					if (p != undefined) AND (classof theProp == String and doesFileExist theProp) AND (SMTDFunctions.isPropertyOKForSubmissionToRepository p) then
					(
						if SMTDSettings.SubmitExternalFilesMode == 2 then --if locals only, check and append if local.
							if SMTDFunctions.IsLocalPath theProp then #(p, theProp) else dontcollect
						else
							#(p, theProp)
					)
					else dontcollect
				)

				for p in SMTDExternalRefsArray.StoreRendererPaths do
				(
					append SMTDExternalRefsArray.storeBitmapPath #(undefined, p[2], filenameFromPath p[2])
					setProperty theRenderer p[1] (filenameFromPath p[2]) --remove the path
				)
			)
			
			local theRendererName = case theRenderer.classid as string of
			(
				default: (classof theRenderer) as string
				"#(1, 0)": "Default Scanline Renderer"
				"#(95494396, 474502030)": "Brazil r/s v2 Renderer"
				"#(1492548972, 1338981315)": "mental ray Renderer"
				"#(1941615238, 2012806412)": "V-Ray Renderer"
				"#(-1204370534, -399920359)": "Krakatoa Renderer"
			)
			local thePathType = case SMTDSettings.SubmitExternalFilesMode of
			(
				default: "Path"
				2: "Local Path"
			)
			try(SMTD_MainRollout.Ui_report "")catch()
			if SMTDExternalRefsArray.StoreRendererPaths.count == 0 then
				try(SMTD_MainRollout.Ui_report ("--No "+ theRendererName + " " + thePathType + "s Collected." ))catch()
			else
				try(SMTD_MainRollout.Ui_report ("+Collected "+ SMTDExternalRefsArray.StoreRendererPaths.count as string + " "+ theRendererName + " " + thePathType + (if SMTDExternalRefsArray.StoreRendererPaths.count != 1 then "s." else ".")  ))catch()
			for o in SMTDExternalRefsArray.StoreRendererPaths do	
				try(SMTD_MainRollout.Ui_report ("\t["+o[2]+"] >> ["+ fileNameFromPath o[2] +"]") LogFileOnly:true )catch()

			for p in theProps where \
				(try(superclassof (getProperty theRenderer p) == textureMap)catch(false)) OR \
				(try(superclassof (getProperty theRenderer p) == material)catch(false)) \
				do append theMaterials (getProperty theRenderer p)
			for m in theMaterials do SMTDFunctions.collectSubAnims m
			
			for o in SMTDExternalRefsArray.totalSubsArray where classof o !=Point_Cache AND classof o != Point_CacheSpacewarpModifier AND classof o.object !=Point_Cache AND classof o.object != Point_CacheSpacewarpModifier AND (isProperty o #filename or isProperty o.object #filename) and findItem bitmapsArray o.object == 0 do append bitmapsArray o.object
			for m in theMaterials where isProperty m #filename and findItem bitmapsArray m == 0 do append bitmapsArray m
			--now go through all bitmaps and collect unique bitmaps and IFL contents for copying
			local bitmapsArrayToProcess = #()
			for o in bitmapsArray do
			(
				if findItem allBitmaps o.filename == 0 do  --if not on the list yet,
				(
					if SMTDSettings.SubmitExternalFilesMode == 2 then --if locals only, check and append if local.
					(
						if SMTDFunctions.IsLocalPath o.filename do 
						(
							append allBitmaps o.filename
							append bitmapsArrayToProcess o
						)	
					)	
					else
					(
						append allBitmaps o.filename --if all, append every single one
						append bitmapsArrayToProcess o
					)
				)	
				if matchPattern (getFileNameType o.filename) pattern:"*IFL" do
				(
					local thePath = getFileNamePath o.filename
					goOn = SMTDFunctions.IsLocalPath o.filename
					if SMTDSettings.SubmitExternalFilesMode >= 3 do goOn = true
					if goOn do
					(
						local theIFLFile = openFile o.filename	
						if theIFLFile != undefined do
						(
							while not eof theIFLFile do
							(
								local theLine = readline theIFLFile
								if getFileNamePath theLine == ""  then theLine = thePath + theLine
								if findItem allBitmaps theLine == 0 do 
								(
									append allBitmaps theLine 
								)
								append SMTDExternalRefsArray.storeBitmapPath #(undefined, theLine, fileNameFromPath theLine)
								if findItem fileNamesForCollisionCheck (fileNameFromPath theLine) == 0 do 
									append fileNamesForCollisionCheck (fileNameFromPath theLine)
							)
							close theIFLFile
						)	
					)	
				)
			)
			
			local TextureCacheFolder = (dotnetclass "System.Environment").GetFolderPath (dotnetclass "System.Environment+SpecialFolder").CommonApplicationData + "\\PF_LocalVFXCache\\LocalTexturesCache\\"
			
	
			
			--Store original texture object and filename, then reset to filename only, no path:
			for o in bitmapsArrayToProcess do
			(
				local theTargetFilename = o.filename
				local theFilename = filenameFromPath theTargetFilename 
				local theIndex1 = findItem fileNamesForCollisionCheck theFilename 
				local theIndex2 = findItem pathNamesForCollisionCheck o.filename

				if theIndex1 > 0 and theIndex2 == 0 then --if the file name exists on the list but the whole path does not, we can assume this is a collision!
				(
					collisions += 1
					theTargetFilename = getFileNameFile theTargetFilename + "_" + collisions as string + getFileNameType theTargetFilename 
				)
				
				if theIndex1 == 0 and theIndex2 == 0 then --if both don't know the file, then it must be new, add it to both lists!
				(
					append fileNamesForCollisionCheck theFilename 
					append pathNamesForCollisionCheck o.filename
				)
				
				append SMTDExternalRefsArray.storeBitmapPath #(o, o.filename, fileNameFromPath theTargetFilename)
				if SMTDSettings.SubmitExternalFilesMode > 1 and SMTDSettings.SubmitExternalFilesMode < 4 do o.filename = fileNameFromPath theTargetFilename
				if SMTDSettings.SubmitExternalFilesMode == 4 do o.filename = SMTDFunctions.convertPathToLocal TextureCacheFolder theTargetFilename
			)
			
			--Report the result of the collection
			try(SMTD_MainRollout.Ui_report "")catch()
			local theLocalString = if SMTDSettings.SubmitExternalFilesMode == 2 then " Local" else ""
			case bitmapsArrayToProcess.count of
			(
				default: try(SMTD_MainRollout.Ui_report ("+Collected "+ bitmapsArrayToProcess.count as string+ theLocalString +" Scene Bitmaps with " + pathNamesForCollisionCheck.count as string + " unique "+(if pathNamesForCollisionCheck.count == 1 then "filename" else "filenames")+" and "+ collisions as string + " file name "+(if collisions == 1 then "collision." else "collisions.")  ))catch()
				0: try(SMTD_MainRollout.Ui_report ("--No"+ theLocalString+" Scene Bitmaps Collected."))catch()
				1: try(SMTD_MainRollout.Ui_report ("+Collected One"+theLocalString+" Scene Bitmap."))catch()
			)
			
			--Dump All Bitmap Names to the Log File
			for o in SMTDExternalRefsArray.storeBitmapPath do 
				try(SMTD_MainRollout.Ui_report ("\t["+o[2]+"] >> ["+ fileNameFromPath o[3] +"]") LogFileOnly:true )catch()
			/*
			for o in SMTDExternalRefsArray.storeBitmapPath do 
				try(SMTD_MainRollout.Ui_report ("\t["+o[2]+"] >> ["+ fileNameFromPath o[3] +"]") LogFileOnly:true )catch()
			*/
			
			for o in SMTDExternalRefsArray.StoreBrazilv2RendererPaths do
			(
				append SMTDExternalRefsArray.storeBitmapPath #(undefined, o[3], filenameFromPath o[3])
				setProperty o[1] o[2] (filenameFromPath o[3])
			)
			
			if VRayProxy != undefined and SMTDSettings.SubmitExternalFilesMode > 1 and (theRenderer.classid) as string == "#(1941615238, 2012806412)" do
			(
				SMTDExternalRefsArray.StoreSceneVrayProxies = #()
				local uniqueVRayProxyFiles = #()
				local uniqueVRayProxyPaths = #()
				local VRaycollisions = 0
				for o in getClassInstances VRayProxy do
				(
					if (SMTDSettings.SubmitExternalFilesMode == 2 AND SMTDFunctions.IsLocalPath o.filename) OR SMTDSettings.SubmitExternalFilesMode == 3 do 
					(
						local theTargetFilename = o.filename
						local theFilename = filenameFromPath theTargetFilename 
						local theIndex1 = findItem uniqueVRayProxyFiles theFilename
						local theIndex2 = findItem uniqueVRayProxyPaths o.filename
						if theIndex1 > 0 and theIndex2 == 0 then --if the file name appears on the file list but not on the paths list, then it is a duplicate with different path = collision!
						(
							VRaycollisions += 1
							theTargetFilename = getFileNameFile theTargetFilename + "_" + VRaycollisions as string + "_" + getFileNameType theTargetFilename 
							append allBitmaps o.filename
							append uniqueVRayProxyPaths o.filename
							append SMTDExternalRefsArray.StoreSceneVrayProxies #(o, o.filename, theTargetFilename)
						)
						else if theIndex1 == 0 and theIndex2 == 0 then --if it is on neither lists, then it is a new unique path to add
						(
							append uniqueVRayProxyFiles theFilename 
							append uniqueVRayProxyPaths o.filename
							append allBitmaps o.filename
							append SMTDExternalRefsArray.StoreSceneVrayProxies #(o, o.filename, theFilename)
						)
						else --if it is not a new or a collision, it is existing already, but we have to collect the file name for restoring 
						(
							append SMTDExternalRefsArray.StoreSceneVrayProxies #(o, o.filename, o.filename)
						)
						--append SMTDExternalRefsArray.storeBitmapPath #(o, o.filename, fileNameFromPath theTargetFilename)
						o.filename = fileNameFromPath theTargetFilename
					)--end copy to repository
					if SMTDSettings.SubmitExternalFilesMode == 4 do
					(
						theNetworkFileName = if SMTDFunctions.isPathInLocalCache TextureCacheFolder o.filename then
							SMTDFunctions.convertPathToRemote TextureCacheFolder o.filename
						else
							o.filename
						if findItem allBitmaps theNetworkFileName == 0 do append allBitmaps theNetworkFileName
						if not (SMTDFunctions.isPathInLocalCache TextureCacheFolder o.filename) do 
						(
							local theLocalPath = SMTDFunctions.convertPathToLocal TextureCacheFolder o.filename
							append SMTDExternalRefsArray.StoreSceneVrayProxies #(o, o.filename, theLocalPath)
							o.filename = theLocalPath 
						)
					)--end local cache on slave
				)--end o loop
				try(SMTD_MainRollout.Ui_report "")catch()
				case uniqueVRayProxyPaths.count of
				(
					0:	try(SMTD_MainRollout.Ui_report ("--No"+ (if SMTDSettings.SubmitExternalFilesMode == 2 then " Local " else " ")+ "V-Ray Proxies Collected." ))catch()
					1: try(SMTD_MainRollout.Ui_report ("+Collected One"+ (if SMTDSettings.SubmitExternalFilesMode == 2 then " Local " else " ")+ "V-Ray Proxy." ))catch()
					default: try(SMTD_MainRollout.Ui_report ("+Collected "+ uniqueVRayProxyPaths.count as string + " Unique" + (if SMTDSettings.SubmitExternalFilesMode == 2 then " Local " else " ")+ "V-Ray Proxies from "+ SMTDExternalRefsArray.StoreSceneVrayProxies.count as string +" Proxy Objects."  ))catch()
				)
				for o in SMTDExternalRefsArray.StoreSceneVrayProxies do	
					try(SMTD_MainRollout.Ui_report ("\t["+o[2]+"] >> ["+ fileNameFromPath o[3] +"]") LogFileOnly:true )catch()
			)		

			-- Collect Mental Ray Proxy Objects
			if mr_Proxy != undefined and SMTDSettings.SubmitExternalFilesMode > 1 and (theRenderer.classid) as string == "#(1492548972, 1338981315)" do
			(
				SMTDExternalRefsArray.StoreSceneMRProxies = #()
				local uniqueMRProxyFiles = #()
				local uniqueMRProxyPaths = #()
				local mrcollisions = 0
				for o in getClassInstances mr_Proxy do
				(
					if (SMTDSettings.SubmitExternalFilesMode == 2 AND SMTDFunctions.IsLocalPath o.filename) OR SMTDSettings.SubmitExternalFilesMode == 3 do 
					(
						local theTargetFilename = o.filename
						local theFilename = filenameFromPath theTargetFilename 
						local theIndex1 = findItem uniqueMRProxyFiles theFilename
						local theIndex2 = findItem uniqueMRProxyPaths o.filename
						if theIndex1 > 0 and theIndex2 == 0 then --if the file name appears on the file list but not on the paths list, then it is a duplicate with different path = collision!
						(
							mrcollisions += 1
							theTargetFilename = getFileNameFile theTargetFilename + "_" + mrcollisions as string + "_" + getFileNameType theTargetFilename 
							if o.animated == true then
							(
								local theAnimationFiles = SMTDFunctions.GetAnimationFiles o.filename
								for f in theAnimationFiles do
								(
									append allBitmaps f
									append uniqueMRProxyPaths f
								)
								append SMTDExternalRefsArray.StoreSceneMRProxies #(o, o.filename, theTargetFilename)
							)
							else
							(
								append allBitmaps o.filename
								append uniqueMRProxyPaths o.filename
								append SMTDExternalRefsArray.StoreSceneMRProxies #(o, o.filename, theTargetFilename)
							)
						)
						else if theIndex1 == 0 and theIndex2 == 0 then --if it is on neither lists, then it is a new unique path to add
						(
							if o.animated == true then
							(
								local theAnimationFiles = SMTDFunctions.GetAnimationFiles o.filename
								for f in theAnimationFiles do
								(
									append uniqueMRProxyFiles (filenameFromPath f) 
									append uniqueMRProxyPaths f
									append allBitmaps f
								)
								append SMTDExternalRefsArray.StoreSceneMRProxies #(o, o.filename, theFilename)
							)
							else
							(
								append uniqueMRProxyFiles theFilename 
								append uniqueMRProxyPaths o.filename
								append allBitmaps o.filename
								append SMTDExternalRefsArray.StoreSceneMRProxies #(o, o.filename, theFilename)
							)
						)
						else --if it is not a new or a collision, it is existing already, but we have to collect the file name for restoring 
						(
							append SMTDExternalRefsArray.StoreSceneMRProxies #(o, o.filename, o.filename)
						)
						o.filename = fileNameFromPath theTargetFilename
					)--end copy to repository
					if SMTDSettings.SubmitExternalFilesMode == 4 do
					(
						theNetworkFileName = if SMTDFunctions.isPathInLocalCache TextureCacheFolder o.filename then
							SMTDFunctions.convertPathToRemote TextureCacheFolder o.filename
						else
							o.filename
						if findItem allBitmaps theNetworkFileName == 0 do append allBitmaps theNetworkFileName
						if not (SMTDFunctions.isPathInLocalCache TextureCacheFolder o.filename) do 
						(
							local theLocalPath = SMTDFunctions.convertPathToLocal TextureCacheFolder o.filename
							append SMTDExternalRefsArray.StoreSceneMRProxies #(o, o.filename, theLocalPath)
							o.filename = theLocalPath 
						)
					)--end local cache on slave
				)--end o loop
				try(SMTD_MainRollout.Ui_report "")catch()
				case uniqueMRProxyPaths.count of
				(
					0:	try(SMTD_MainRollout.Ui_report ("--No"+ (if SMTDSettings.SubmitExternalFilesMode == 2 then " Local " else " ")+ "mental ray Proxy Files Collected." ))catch()
					1: try(SMTD_MainRollout.Ui_report ("+Collected One"+ (if SMTDSettings.SubmitExternalFilesMode == 2 then " Local " else " ")+ "mental ray Proxy File." ))catch()
					default: try(SMTD_MainRollout.Ui_report ("+Collected "+ uniqueMRProxyPaths.count as string + " Unique" + (if SMTDSettings.SubmitExternalFilesMode == 2 then " Local " else " ")+ "mental ray Proxy Files from "+ SMTDExternalRefsArray.StoreSceneMRProxies.count as string +" Proxy Objects."  ))catch()
				)
				for o in SMTDExternalRefsArray.StoreSceneMRProxies do	
					try(SMTD_MainRollout.Ui_report ("\t["+o[2]+"] >> ["+ fileNameFromPath o[3] +"]") LogFileOnly:true )catch()
			)		

			
			
			--Do the same for XRefs
			SMTDExternalRefsArray.StoreSceneXRefs = #()
			if not SMTDSettings.MergeSceneXRefsOnSubmission then
			(
				for i = 1 to (xrefs.getXRefFileCount()) do
				(
					o = (xrefs.getXRefFile i)
					local shouldBeCollected = (not o.disabled) AND (doesfileexist o.filename) AND ((SMTDSettings.SubmitExternalFilesMode == 2 AND SMTDFunctions.IsLocalPath o.filename) OR SMTDSettings.SubmitExternalFilesMode == 3)
					append SMTDExternalRefsArray.StoreSceneXRefs #(o, o.filename, fileNameFromPath o.filename, shouldBeCollected)
					if shouldBeCollected do --only collect if not disabled and the Scene XREF actually exists!
					(
						append allBitmaps o.filename
						o.filename = fileNameFromPath o.filename
					)
				)
				try(SMTD_MainRollout.Ui_report "")catch()
				local activeXRefsCount = (for o in SMTDExternalRefsArray.StoreSceneXRefs where o[4] collect o).count
				case activeXRefsCount of
				(
					default: try(SMTD_MainRollout.Ui_report ("+Collected "+ activeXRefsCount as string +" Scene XREFs."))catch()
					0: try(SMTD_MainRollout.Ui_report ("--No Scene XREFs Collected."))catch()
					1: try(SMTD_MainRollout.Ui_report ("+Collected One Scene XREF."))catch()
				)

				for o in SMTDExternalRefsArray.StoreSceneXRefs where o[4] do
					try(SMTD_MainRollout.Ui_report ("\t["+o[2]+"] >> "+"["+o[3]+"]") LogFileOnly:true )catch()
			)
			else
				try(SMTD_MainRollout.Ui_report ("--Merge Scene XREF Requested, Collecting Skipped."))catch()
			
			if not SMTDSettings.MergeXRefsOnSubmission then 
			(
				SMTDExternalRefsArray.StoreObjectXRefs = #()
				for o in (objXrefs.getAllXRefObjects()) do
				(
					if (SMTDSettings.SubmitExternalFilesMode == 2 AND SMTDFunctions.IsLocalPath o.filename) OR SMTDSettings.SubmitExternalFilesMode == 3 do --if local and locals only, or if all paths wanted
					(
						append SMTDExternalRefsArray.StoreObjectXRefs #(o, o.filename, fileNameFromPath o.filename)
						o.filename = fileNameFromPath o.filename
					)
				)	
				
				local uniquePaths = #()
				for o in SMTDExternalRefsArray.StoreObjectXRefs where findItem uniquePaths o[2] == 0 do append uniquePaths o[2]
				for o in uniquePaths do append allBitmaps o
				
				try(SMTD_MainRollout.Ui_report "")catch()
				case SMTDExternalRefsArray.StoreObjectXRefs.count of
				(
					default: (
						if uniquePaths.count != 1 then
							try(SMTD_MainRollout.Ui_report ("+Collected "+ SMTDExternalRefsArray.StoreObjectXRefs.count as string +" Object XREFs with "+ uniquePaths.count as string + " Unique Paths."))catch()
						else
							try(SMTD_MainRollout.Ui_report ("+Collected "+ SMTDExternalRefsArray.StoreObjectXRefs.count as string +" Object XREFs with One Unique Path."))catch()
					)
					0: try(SMTD_MainRollout.Ui_report ("--No Object XREFs Collected."))catch()
					1: try(SMTD_MainRollout.Ui_report ("+Collected One Object XREF."))catch()
				)
				
				for o in uniquePaths do
				(
					try(SMTD_MainRollout.Ui_report ("\t["+o+"] >> ["+fileNameFromPath o +"]") LogFileOnly:true )catch()
					for i in SMTDExternalRefsArray.StoreObjectXRefs where i[2] == o do
						--try(
							SMTD_MainRollout.Ui_report ("\t\t["+i[1].objectName +"]") LogFileOnly:true 
						--)catch()
				)
			)
			else
				try(SMTD_MainRollout.Ui_report ("--Merge Object XREF Requested, Collecting Skipped."))catch()
			try(SMTD_MainRollout.Ui_report "")catch()
					
			allBitmaps
		),
		
		fn restoreExternalReferencePaths =
		(
			--Restore Bitmaps
			for o in SMTDExternalRefsArray.storeBitmapPath where o[1] != undefined do o[1].filename = o[2]
				
			--Restore Scene XRefs
			for i = 1 to (xrefs.getXRefFileCount()) do
			(
				local o = (xrefs.getXRefFile i)
				o.filename = SMTDExternalRefsArray.StoreSceneXRefs[i][2]
			)
			
			--Restore Object XRefs
			for o in SMTDExternalRefsArray.StoreObjectXRefs do o[1].filename = o[2]
			
			--Restore VRay Proxies
			if VRayProxy != undefined and SMTDSettings.SubmitExternalFilesMode > 1 do
				for o in SMTDExternalRefsArray.StoreSceneVrayProxies do o[1].filename = o[2]

			--Restore mr Proxies
			if mr_Proxy != undefined and SMTDSettings.SubmitExternalFilesMode > 1 do
				for o in SMTDExternalRefsArray.StoreSceneMRProxies do o[1].filename = o[2]
				
			--Restore Renderer Paths
			for o in SMTDExternalRefsArray.StoreRendererPaths do
				try(setProperty renderers.current o[1] o[2])catch()
			
			--Restore Brazil 2 Paths
			for o in SMTDExternalRefsArray.StoreBrazilv2RendererPaths do
			(
				setProperty o[1] o[2] o[3]
			)			
		),
		
		fn createExternalFilesList allBitmaps=
		(
			local ExternalFilesListName = SMTDPaths.TempDir + "\\ExternalFilesList.txt"
			local theListOfExternalFiles = createFile ExternalFilesListName
			for aFile in allBitmaps do
			(
				format "%\n" aFile to:theListOfExternalFiles 
			)
			close theListOfExternalFiles
			ExternalFilesListName
		),
		
		fn GetAnimationBaseCount theBaseName =
		(
			local lastDigit = 0
			for i = theBaseName.count to 1 by -1 do
			(
				if findString "1234567890" theBaseName[i] == undefined do 
				(
					lastDigit = i
					exit
				)
			)--end i loop
			lastDigit
		),
		
		fn GetAnimationFiles theFilePath =
		(
			local theBaseName = getFileNameFile theFilePath 
			local lastDigit = SMTDFunctions.GetAnimationBaseCount theBaseName
			getFiles (thePathPattern = getFileNamePath theFilePath + substring theBaseName 1 lastDigit + "*" + getFileNameType theFilePath)
		),
		
		fn RenameTargetAnimationFile theSource theTarget =
		(
			local theBaseName1 = getFileNameFile theSource 
			local lastDigit1 = SMTDFunctions.GetAnimationBaseCount theBaseName1
			local theBaseName2 = getFileNameFile theTarget 
			local lastDigit2 = SMTDFunctions.GetAnimationBaseCount theBaseName2
			local theNumber = if lastDigit1 < theBaseName1.count then 
				(substring theBaseName1 (lastDigit1+1) -1 )
			else 
				""
			getFileNamePath theTarget + (substring theBaseName2 1 lastDigit2)  + theNumber + getFileNameType theTarget
		),		
		
		fn copyExternalReferences jobID BitmapsCopyData =
		(
			local txt = if BitmapsCopyData.count == 1 then "File" else "Files"
			try(SMTD_MainRollout.Ui_report (">Copying "+ BitmapsCopyData.count as string +" External "+txt+" To Repository..." ) )catch()
			local theNetworkPath = SMTDFunctions.GetNetworkRoot()
			local thePathToCopyTo = theNetworkPath + "\\jobs\\" + jobID + "\\"
			try(SMTD_MainRollout.sld_lastSubmissionState.color = color 200 255 255)catch()			
			local failedToCopy = 0
			local copyCounter = 0
			local ExternalFilesListName = thePathToCopyTo + "\\ExternalFilesList.txt"
			local theListOfExternalFiles = createFile ExternalFilesListName
			for aFile in BitmapsCopyData do
			(
				copyCounter += 1
				result = copyFile aFile[1] (thePathToCopyTo + aFile[2])
				if result then
				(
					try(SMTD_MainRollout.Ui_report ("+Copied File "+ copyCounter as string +": ["+ aFile[1] +"] to ["+thePathToCopyTo+"]") )catch()
					format "%\n" (thePathToCopyTo + aFile[2]) to:theListOfExternalFiles 
				)	
				else	
				(
					try(SMTD_MainRollout.Ui_report ("--Failed to copy File "+ copyCounter as string +": ["+ aFile[1] +"] to ["+thePathToCopyTo+"]") )catch()
					failedToCopy += 1
				)	
				try
				(
					SMTD_MainRollout.sld_lastSubmissionState.value += 1
					if SMTD_MainRollout.sld_lastSubmissionState.value == 100 do SMTD_MainRollout.sld_lastSubmissionState.value = 50
				)catch()			
			)
			
			close theListOfExternalFiles
			local theOldXML = openFile (thePathToCopyTo + jobID + ".job")
			local theNewXML = createFile (thePathToCopyTo + jobID + ".tmp")
			while not eof theOldXML do
			(
				local theLine = readLine theOldXML 
				if matchPattern theLine pattern:"*</AuxillarySubmissionFileNames>*" then
				(
					for aFile in BitmapsCopyData do
						format "    <string>%</string>\n" aFile[2] to:theNewXML
					format "    <string>%</string>\n" "ExternalFilesList.txt" to:theNewXML
				)
				format "%\n" theLine to:theNewXML
			)
			close theOldXML
			close theNewXML
			renameFile (thePathToCopyTo + jobID + ".job") (thePathToCopyTo + jobID + ".old")
			renameFile (thePathToCopyTo + jobID + ".tmp") (thePathToCopyTo + jobID + ".job")
			failedToCopy 
		),

		--Returns the frame sequence string
		fn GetSequenceString frameNumbers =
		(
			local seqString = StringStream ""
			local curIndex = 1
			while (curIndex <= frameNumbers.count) do
			(
				local baseNumber = frameNumbers[curIndex]
				local baseIndex = curIndex
				local runLen = 1
				while (curIndex < frameNumbers.count) and (baseNumber+runLen) == frameNumbers[curIndex+1] do 
				(
					runLen += 1
					curIndex += 1
				)
				case runLen of
				(
					1:		format "%" frameNumbers[curIndex] to:seqString
					2:		format "%,%" frameNumbers[baseIndex] frameNumbers[curIndex] to:seqString
					default:	format "%-%" frameNumbers[baseIndex] frameNumbers[curIndex] to:seqString
				)
				if (curIndex != frameNumbers.count) do format "," to:seqString
				curIndex += 1
			)
			--try(SMTD_MainRollout.Ui_report ">Sequence String:" )catch()
			--try(SMTD_MainRollout.Ui_report (seqString as string) )catch()
			seqString as string
		),
		
		--Returns the out of order sequence
		fn outOfOrderSequence theFramesArray mode:#both =
		(
			local startArray = #()
			
			local step = if mode != #both then
				1.0*(theFramesArray.count-1) / (SMTDSettings.PreviewJobFrameCount - 1)
			else
				SMTDSettings.outOfOrderStep
				
			for i = 1 to theFramesArray.count by step do
				append startArray theFramesArray[i]
			local endArray = for i = 1 to theFramesArray.count where findItem startArray theFramesArray[i] == 0 collect theFramesArray[i]
			case mode of
			(
				#both: startArray + endArray 
				#nth: startArray 
				#rest: endArray 
			)	
		),
		
		fn outOfOrderMethod theFramesArray theMethod:#normal =
		(
			case theMethod of
			(
				default: theFramesArray
				#normal: theFramesArray
				#reverse: for i = theFramesArray.count to 1 by -1 collect theFramesArray[i]
				#lastAndFirst:
				(
					if theFramesArray.count < 3 then
						theFramesArray
					else
					(
						local temp = #()
						append temp theFramesArray[1]
						append temp theFramesArray[theFramesArray.count]
						for i = 2 to (theFramesArray.count - 1) do
							append temp theFramesArray[i]
						temp
					)
				)
				#nth:
				(
					local startArray = #()
					local theStep = SMTDSettings.outOfOrderStep
					for i = 1 to theFramesArray.count by theStep do
						append startArray theFramesArray[i]
					local endArray = for i = 1 to theFramesArray.count where findItem startArray theFramesArray[i] == 0 collect theFramesArray[i]
					startArray + endArray 
				)
				#fromBothEnds: 
				(
					local temp = #()
					for i = 1 to theFramesArray.count / 2 do 
					(
						append temp theFramesArray[i]
						append temp theFramesArray[theFramesArray.count - i + 1]
					)	
					for i in theFramesArray where findItem temp i == 0 do append temp i --make sure nothing was left behind
					temp
				)
				#fromBothEndsAndCenter:
				(
					local temp = #()
					for i = 1 to theFramesArray.count / 4 do 
					(
						append temp theFramesArray[i]
						append temp theFramesArray[theFramesArray.count - i + 1]
						append temp theFramesArray[theFramesArray.count / 2 - i + 1]
						append temp theFramesArray[theFramesArray.count / 2 + i]
					)	
					for i in theFramesArray where findItem temp i == 0 do append temp i --make sure nothing was left behind
					temp
				)
				#fromCenter:
				(
					local temp = #()
					for i = theFramesArray.count / 2 to 1 by -1 do 
					(
						append temp theFramesArray[i]
						append temp theFramesArray[theFramesArray.count - i + 1]
					)	
					for i in theFramesArray where findItem temp i == 0 do append temp i --make sure nothing was left behind
					temp					
				)
				#NthBlock: 
				(
					local temp = #()
					theStep = SMTDSettings.outOfOrderStep
					theBlockSize = theFramesArray.count/theStep
					for i = 1 to theBlockSize do
						for j = 0 to theStep-1  do
							append temp theFramesArray[i+j*theBlockSize]
					for i in theFramesArray where findItem temp i == 0 do append temp i --make sure nothing was left behind	
					temp 
				)
				#NthRasterRefine:
				(
					local temp = #()
					local theStep = SMTDSettings.outOfOrderStep
					while theStep > 1 do
					(
						for i = 1 to theFramesArray.count by theStep where findItem temp theFramesArray[i] == 0 do
							append temp theFramesArray[i]
						theStep /=	 2
					)		
					for i = 1 to theFramesArray.count where findItem temp theFramesArray[i] == 0 do append temp theFramesArray[i]
					temp 
				)
				#random:
				(
					local temp = #()
					local temp2 = for i in theFramesArray collect i
					--seed 12345
					while temp2.count > 0 do 
					(
						theIndex = random 1 temp2.count
						append temp temp2[theIndex]
						deleteItem temp2 theIndex
					)
					temp
				)
			)--end case
		),
		
		fn SaveMaxFileCopy destFileName isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			try(SMTD_MainRollout.sld_lastSubmissionState.value = 50)catch()
			local holdMaxDir = (GetDir #autoback) + "\\"
			local holdFileName = if maxOps.productAppID == #max then 
				holdMaxDir + "maxhold.mx"
			else
				holdMaxDir + "vizhold.mx"
	
			local holdTempFileName = holdMaxDir + "maxhold.tmp"
			local holdExists = doesFileExist holdFileName
			
			if holdExists then 
			(
				deleteFile holdTempFileName
				renameFile holdFileName holdTempFileName
			)
				
			--obtiene el  nombre del dominio de red en el que esta la maquina
			_domainName = (dotnetClass "System.Windows.Forms.SystemInformation").UserDomainName
			
			if isLPMjob and (_domainName == "LBOX" or (findstring _domainName "summus" != undefined)) then --si es un trabajo de LPM y el dominio es LBOX
			(--print "SaveMaxFileCopy - LPM 1"
				_unit = (lb.project.getCurrentFileProject()).getRoot()
				_netUnit = (lb.project.getCurrentFileProject()).getNetworkRoot()
				
				--paths de redireccion
				_localPath = LPM_Fun.getIni "Settings" "localPath" string _unit --"z:\\"
				_networkPath = LPM_Fun.getIni "Settings" "networkPath" string _netUnit --"\\\\lbdata001\\z\\"
				
				--DESACTIVAR PARA QUE NO REDIRECCIONE A lbdata001 EN LA POSTPO
				LPM_fun.redirectExternalSources #localToNetwork _localPath _networkPath				
			)
			else if isPMjob and (_domainName == "LBOX" or (findstring _domainName "summus" != undefined)) then --si es un trabajo de PM y el dominio es LBOX
			(
				print "TO DO: Redirect external sources to network"
			)--if
			
			--Hay que tener en cuenta si es un trabajo de LPM, si es un trabajo de batch, entonces hay que guardar los settings de deadline en
			--el nod auxiliar
			--salva los settings de Deadline en el nodo auxiliar para transmitirselo al trabajo de desglose
			if isLPMjob then
			(
				local _LPMbatchInfo = $'LPM_batchRenderInfo' --obtiene el nodo de informacion de batch de render
				local _isBatchRender = (isValidNode _LPMbatchInfo)
				
				if _isBatchRender then
				(
					if matchPattern lpmJobName pattern:"*(LPM-BATCH)*" then -- si se esta creando un trabajo para desgloses
						SMTDFunctions.saveSettingsToBatchNode _LPMbatchInfo saveNotStiky:true
				)
			)
			
			--salva el estado actual de la escena
			--holdMaxFile()
			saveMaxFile holdFileName useNewFile:false quiet:true
			
			--archivo temporal de version 2010
			_holdMaxFile2010 = (getFileNamePath holdFileName) + (getFileNameFile holdFileName) + "2010.max"
			--print _holdMaxFile2010
			
			--si se esta ejecutando en una version posterior a 2010, hay que salvar el archivo como version 2010
			/*if (maxVersion())[1] > 12000 then --and (maxVersion())[1] < 16000 then
			(
				--print "version superior a 2010"
				if doesFileExist _holdMaxFile2010 then deleteFile _holdMaxFile2010
				--if doesFileExist _holdMaxFile2010 then print "pues no ha borrado bien el _holdMaxFile2010"
				_created = saveMaxFile _holdMaxFile2010 saveAsVersion:2010 useNewFile:false quiet:true
				--print _created
				
				if not (doesFileExist holdFileName) do 
					return ("Saving the file as ["+ holdFileName +"] via hold() did not work.")
				
				if not (renameFile holdFileName destFileName) do
					if not (copyFile holdFileName destFileName) do
						return ("Could not copy the saved scene file to " + destFileName)
				
				if not (doesFileExist _holdMaxFile2010) do 
					return ("Saving the file as ["+ _holdMaxFile2010 +"] via hold() did not work.")
				
				--if doesFileExist destFileName then print "ya existia el archivo destino"					
				if doesFileExist destFileName then deleteFile destFileName
				--if doesFileExist destFileName then print "pues no lo ha borrado"
				
				--ESTO ERA PARA PROBAR QUE GUARDABA EN 2010
				--_holdMaxFileTmp = (getFileNamePath holdFileName) + (getFileNameFile holdFileName) + "_TMP.max"
				--if doesFileExist _holdMaxFileTmp then deleteFile _holdMaxFileTmp
				--(copyFile _holdMaxFile2010 _holdMaxFileTmp)
				
				if not (renameFile _holdMaxFile2010 destFileName) do
					if not (copyFile _holdMaxFile2010 destFileName) do
						return ("Could not copy the saved scene file to " + destFileName)
				
				--if not doesFileExist destFileName then print "no ha copiado bien el archivo destino"
				--print destFileName
			)
			else*/ --if (maxVersion())[1] < 12000 then --si es version 2010 o anterior
			(
				if not (doesFileExist holdFileName) do 
					return ("Saving the file as ["+ holdFileName +"] via hold() did not work.")
				
				if not (renameFile holdFileName destFileName) do
					if not (copyFile holdFileName destFileName) do
						return ("Could not copy the saved scene file to " + destFileName)
			)
			
			--DESACTIVAR PARA QUE NO REDIRECCIONE A lbdata001 EN LA POSTPO	
			if isLPMjob and (_domainName == "LBOX" or (findstring _domainName "summus" != undefined)) and doesFileExist destFileName then --redirecciona mediante el metadata
			(--print "SaveMaxFileCopy - LPM 2"
				_metaData = getMAXFileAssetMetadata destFileName --obtiene el meta data del archivo
				
				_unit = (lb.project.getCurrentFileProject()).getRoot()
				_netUnit = (lb.project.getCurrentFileProject()).getNetworkRoot()
				
				for i = 1 to _metaData.count where (matchpattern (tolower _metaData[i].filename) pattern:(_unit + "*")) do
				(
					_filename = ((tolower (getfilenamepath _metaData[i].filename)) + (getfilenamefile _metaData[i].filename) + (getfilenametype _metaData[i].filename))
					_metaData[i].filename = substituteString _filename _localPath _networkPath --"z:" "\\\\lbdata001\\z"
				)
				
				setMAXFileAssetMetadata destFileName _metaData --almacena el metadata modificado
			)--if
			else if isPMjob and (_domainName == "LBOX" or (findstring _domainName "summus" != undefined)) and doesFileExist destFileName then --redirecciona mediante el metadata
			(
				print "TO DO: metadata redirect to network"
			)
			-------------------------------------------------------------------------------------------------
			
			if isLPMjob and (_domainName == "LBOX" or (findstring _domainName "summus" != undefined)) then --si es un trabajo de LPM y el dominio es LBOX
			(--print "SaveMaxFileCopy - LPM 3"
				_unit = (lb.project.getCurrentFileProject()).getRoot()
				_netUnit = (lb.project.getCurrentFileProject()).getNetworkRoot()
				
				--paths de redireccion
				_localPath = LPM_Fun.getIni "Settings" "localPath" string _unit --"z:\\"
				_networkPath = LPM_Fun.getIni "Settings" "networkPath" string _netUnit --"\\\\lbdata001\\z\\"
				
				--DESACTIVAR PARA QUE NO REDIRECCIONE A lbdata001 EN LA POSTPO
				
				fetchMaxFile quiet:true --devuelve el estado original a la escena
				
				LPM_fun.redirectExternalSources #networkToLocal _localPath _networkPath
				
				--holdMaxFile()
				saveMaxFile holdFileName useNewFile:false quiet:true
					
				-------------------------------------------------------------------
				-------------------------------------------------------------------
				--NO SE SI ESTO ESTA BIEN
				-------------------------------------------------------------------
				--si se esta ejecutando en una version posterior a 2010, hay que salvar el archivo como version 2010
-- 				if (maxVersion())[1] > 12000 then
-- 				(
-- 					saveMaxFile _holdMaxFile2010 saveAsVersion:2010 useNewFile:false quiet:true
-- 					
-- 					if not (doesFileExist _holdMaxFile2010) do 
-- 						return ("Saving the file as ["+ _holdMaxFile2010 +"] via hold() did not work.")
-- 					
-- 					if not (renameFile _holdMaxFile2010 destFileName) do
-- 						if not (copyFile _holdMaxFile2010 destFileName) do
-- 							return ("Could not copy the saved scene file to " + destFileName)
-- 				)
-- 				else --si es version 2010
-- 				(
-- 					if not (doesFileExist holdFileName) do 
-- 						return ("Saving the file as ["+ holdFileName +"] via hold() did not work.")
-- 					
-- 					if not (renameFile holdFileName destFileName) do
-- 						if not (copyFile holdFileName destFileName) do
-- 							return ("Could not copy the saved scene file to " + destFileName)
-- 				)
				-------------------------------------------------------------------
				-------------------------------------------------------------------
				-------------------------------------------------------------------
			)
			else if isPMjob and (_domainName == "LBOX" or (findstring _domainName "summus" != undefined)) then --si es un trabajo de PM y el dominio es LBOX
			(				
				--DESACTIVAR PARA QUE NO REDIRECCIONE A lbdata001 EN LA POSTPO
				
				print "TO DO: Redirect external sources to network"
			)			
			
			if doesFileExist _holdMaxFile2010 then deleteFile _holdMaxFile2010
			
			if holdExists do
			(			
				deleteFile holdFileName
				renameFile holdTempFileName holdFileName
			)
			
			return undefined
		),

		fn RestoreMaxFileCopy sourceFileName =
		(
			local holdMaxDir = (GetDir #autoback) + "/"
			local holdFileName = if maxOps.productAppID == #max then 
				holdMaxDir + "maxhold.mx"
			else
				holdMaxDir + "vizhold.mx"			
			local holdTempFileName = holdMaxDir + "maxhold.tmp"
			local holdExists = doesFileExist holdFileName
			
			if holdExists then
			(
				deleteFile holdTempFileName
				renameFile holdFileName holdTempFileName
			)
			
			renameFile sourceFileName holdFileName
			if not (doesFileExist holdFileName) do return "Restoring the file via fetch() did not work." 
			
			fetchMaxFile quiet:true
			
			if holdExists do
			(
				deleteFile holdFileName
				renameFile holdTempFileName holdFileName
			)
			
			return undefined
		),	
		
		fn collectSceneMaterials =
		(
			SMTD_MainRollout.Ui_report (">Enumerating Scene Objects and Materials")
			SMTD_SceneMaterials = for o in objects collect #(o, o.material, o.colorByLayer)
		),
		
		fn assignCustomShaders =
		(
			case SMTDSettings.CustomShaderMode of
			(
				1: (
					objects.material = standard()
					shaderType = "Standard Grayscale Shader"
				)	
				2: (
					objects.material = undefined
					shaderType = "Object Wireframe Colors"
				)
				3: (
					objects.material = undefined
					objects.colorByLayer = true
					shaderType = "Layer Colors"
				)	
				4: (
					if superclassof meditmaterials[1] == Material then 
					(
						objects.material = meditmaterials[1] 
						shaderType = "Material Editor Slot 1"
					)
					else 
					(
						objects.material = standard()
						shaderType = "Standard Grayscale Material Instead Of Medit Slot 1"
					)	
				)	
			)	
			SMTD_MainRollout.Ui_report ("+Assigned "+ shaderType +" To Scene Objects")
		),
		
		fn restoreSceneMaterials =
		(
			for o in SMTD_SceneMaterials do 
			(
				o[1].material = o[2]
				o[1].colorByLayer = o[3]
			)	
			SMTD_SceneMaterials =#()
			SMTD_MainRollout.Ui_reportreport ("+Restored Materials Of Scene Objects")
		),
		fn clearMaterialEditor =
		(
			global SMTDSettings_MeditMaterialsStorage = for i = 1 to 24 collect meditMaterials[i]
			for i = 1 to 24 do meditMaterials[i] = standard()
		),
		
		fn restoreMaterialEditor =
		(
			for i = 1 to 24 do try(meditMaterials[i] = SMTDSettings_MeditMaterialsStorage[i])catch()
		),
		
		fn HasActiveSceneXRefs =
		(
			theCount = xrefs.getXRefFileCount()
			(for i = 1 to theCount where not (xrefs.getXRefFile i).disabled collect i).count > 0
		),
		
		fn SaveMaxFileVisibleOnly destFileName =
		(
			try(SMTD_MainRollout.sld_lastSubmissionState.value = 50)catch()
			--COLLECT ALL GEOMETRY THAT IS VISIBLE TO CAMERA OR REFLECTIONS
			local theNodesToSave = for o in geometry where not o.isHiddenInVpt and o.renderable and (o.primaryVisibility or o.secondaryVisibility)  collect o
			format "Submitting Geometry: % of %\n" theNodesToSave.count geometry.count
			--ADD ALL LIGHTS,CAMERAS, HELPERS AND RENDERABLE SHAPES
			join theNodesToSave (Lights as array) --always needed
			join theNodesToSave (Cameras as array) --always needed
			join theNodesToSave (Helpers as array) --might be needed for atmospheric gizmos
			join theNodesToSave (for o in Shapes where try(o.baseobject.renderable)catch(true) collect o)
			format "Submitting TOTAL: % of %\n" theNodesToSave.count objects.count
			--SAVE THE COLLECTED OBJECTS - ANY DEPENDENTS WILL ALSO BE SAVED AUTOMATICALLY
			saveNodes theNodesToSave destFileName
			if doesFileExist destFileName then 
				undefined 
			else 
				"Saving Of Visible Objects Only Failed."
		),
		
		fn RenderElementsStoreVrayVFB =
		(
			global SMTD_RenderElementVrayVFB = #()
			
			local reManager = maxOps.GetCurRenderElementMgr()
			local reCount = reManager.NumRenderElements()
			for i = 0 to reCount - 1 do
			(
				local reCurr = (reManager.GetRenderElement i)
				if hasProperty reCurr "vrayVFB" then
					append SMTD_RenderElementVrayVFB reCurr.vrayVFB
				else
					append SMTD_RenderElementVrayVFB false --Just a place holder!
			)
		),
		
		fn RenderElementsUpdateVrayVFB =
		(
			local reManager = maxOps.GetCurRenderElementMgr()
			if reManager.GetElementsActive() then 
			(
				local reCount = reManager.NumRenderElements()
				for i = 0 to reCount - 1 do
				(
					local reCurr = (reManager.GetRenderElement i)
					if hasProperty reCurr "vrayVFB" do
					(
						if reCurr.vrayVFB do
						(
							SMTD_MainRollout.Ui_report ("+Disabling V-Ray Frame Buffer for render element " + reCurr.elementName)
							reCurr.vrayVFB = false
						)
					)
				)
			)
		),
		
		fn RenderElementsRestoreVrayVFB =
		(
			if classof SMTD_RenderElementVrayVFB == Array do
			(
				local reManager = maxOps.GetCurRenderElementMgr()
				local reCount = reManager.NumRenderElements()
				for i = 0 to reCount - 1 do
				(
					local reCurr = (reManager.GetRenderElement i)
					if hasProperty reCurr "vrayVFB" do
					(
						local currVrayVFB = SMTD_RenderElementVrayVFB[ i + 1 ]
						if currVrayVFB do
						(
							SMTD_MainRollout.Ui_report ("+Reenabling V-Ray Frame Buffer for render element " + reCurr.elementName)
							reCurr.vrayVFB = true
						)
					)
				)
			)
		),
		
		fn RenderElementsStorePaths =
		(
			local reManager = maxOps.GetCurRenderElementMgr()
			local reCount = reManager.NumRenderElements()
			global SMTD_RenderElementPaths = #()
			for i = 0 to reCount - 1 do
				append SMTD_RenderElementPaths (reManager.GetRenderElementFilename i)
		),		
		
		fn RenderElementsUpdatePaths =
		(
			outputFilename = rendOutputFilename
			-- only update RE paths if the output filename isn't empty
			if (outputFilename != undefined and outputFilename != "") then
			(
				local reManager = maxOps.GetCurRenderElementMgr()
				if reManager.GetElementsActive() then 
				(
					local reCount = reManager.NumRenderElements()
					for i = 0 to reCount - 1 do
					(
						local reFilename = reManager.GetRenderElementFilename i
						local theElement = reManager.GetRenderElement i
						local theElementFolder = theElement.elementName 
						theElementFolder += "_" +  (classof theElement) as string 
						
						local newPath = (getFileNamePath outputFilename + theElementFolder)
						if theElement.enabled do
							makeDir newPath all:true
						
						if SMTDSettings.RenderElementsUpdateFilenames then
						(
							reManager.SetRenderElementFilename i (newPath +"\\" + getFileNameFile outputFilename + "_" + ((classof theElement) as string) + getFileNameType outputFilename)
						)
						else
						(
							if reFilename != undefined and reFilename != "" then
								reManager.SetRenderElementFilename i (newPath +"\\" + getFileNameFile reFilename + getFileNameType outputFilename)
							else
								reManager.SetRenderElementFilename i (newPath +"\\" + theElementFolder + getFileNameType outputFilename)
						)
					)--end i loop
				)--end if
			)
			else
			(
				-- if output file is empty, check if rendering with vray and saving a raw image, and clear RE paths if so
				if (renderers.current.classid as string == "#(1941615238, 2012806412)") and renderers.current.output_on and renderers.current.output_saveRawFile then
				(
					local reManager = maxOps.GetCurRenderElementMgr()
					if reManager.GetElementsActive() then 
					(
						local reCount = reManager.NumRenderElements()
						for i = 0 to reCount - 1 do
						(
							reManager.SetRenderElementFilename i ""
						)
					)
				)
			)
		),
		
		fn RenderElementsRestorePaths =
		(
			local reManager = maxOps.GetCurRenderElementMgr()
			local reCount = reManager.NumRenderElements()
			if classof SMTD_RenderElementPaths == Array do
			(
				for i = 0 to reCount - 1 do
				(
					if SMTD_RenderElementPaths[i+1] == undefined then
						reManager.SetRenderElementFilename i ""
					else
						reManager.SetRenderElementFilename i (SMTD_RenderElementPaths[i+1])
				)
			)	
		),
		
		
		fn IsSettingSticky theCategory theKey =
		( 
			local theStickyFile = SMTDPaths.NetworkRoot + "\\submission\\3dsmax\\SubmitMaxToDeadline_StickySettings.ini"  
			local theLocalStickyFile = SMTDPaths.SettingsDir + "\\SubmitMaxToDeadline_StickySettings.ini"  
			local isSticky = true --If INI key is not set, we assume the setting is sticky
			local theValue = (getINISetting theStickyFile theCategory theKey) 
			--if there is such a global entry, see whether it is false or not. 
			if theValue != "" then isSticky = theValue != "false"
			--if there is such a local entry, see whether it is false or not
			local theValue = (getINISetting theLocalStickyFile theCategory theKey)
			if theValue != "" then isSticky = theValue != "false"
			isSticky 
		),
		
		--eserna modificada
		fn FormatJobName currJobName isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			local nameFormats = #()
			
			-- if a local version of the file exists, use that instead
			local nameFormatFilename = SMTDPaths.SettingsDir + "\\SubmitMaxToDeadline_NameFormats.ini"
			if not doesFileExist nameFormatFilename then
				nameFormatFilename = SMTDPaths.NetworkRoot + "\\submission\\3dsmax\\SubmitMaxToDeadline_NameFormats.ini"
			
			local nameFormatFile = openFile nameFormatFilename
			if (nameFormatFile != undefined) then
			(
				try
				(
					while not eof nameFormatFile do
					(
						local fileLine = readLine nameFormatFile 
						local index = findString fileLine "="
						if (index != undefined and index < fileLine.count) then
						(
							nameFormats = append nameFormats #( (substring fileLine 1 (index-1)), (substring fileLine (index+1) -1) )
						)
					)
				)
				catch ()
				try(close nameFormatFile)catch()
			)
			
			for currNameFormat in nameFormats do
			(
				local searchVars = findstring currJobName currNameFormat[1]   
				if searchVars != undefined do
					currJobName = replace currJobName searchVars currNameFormat[1].count (execute currNameFormat[2])
			)
			
			--si se ha enviado el trabajo desde LPM, hay que poner el nombre de trabajo específico
			--eserna
			if isLPMjob and lpmJobName != "" then
				currJobName = lpmJobName
			else if isPMjob and pmJobName != "" then
				currJobName = pmJobName
			
			currJobName
		),
		
		fn FormatComment currComment =
		(
			local commentFormats = #()
			
			-- if a local version of the file exists, use that instead
			local commentFormatFilename = SMTDPaths.SettingsDir + "\\SubmitMaxToDeadline_CommentFormats.ini"
			if not doesFileExist commentFormatFilename then
				commentFormatFilename = SMTDPaths.NetworkRoot + "\\submission\\3dsmax\\SubmitMaxToDeadline_CommentFormats.ini"
			
			local commentFormatFile = openFile commentFormatFilename
			if (commentFormatFile != undefined) then
			(
				try
				(
					while not eof commentFormatFile do
					(
						local fileLine = readLine commentFormatFile 
						local index = findString fileLine "="
						if (index != undefined and index < fileLine.count) then
						(
							commentFormats = append commentFormats #( (substring fileLine 1 (index-1)), (substring fileLine (index+1) -1) )
						)
					)
				)
				catch ()
				try(close commentFormatFile)catch()
			)
			
			for currCommentFormat in commentFormats do
			(
				local searchVars = findstring currComment currCommentFormat[1]   
				if searchVars != undefined do
					currComment = replace currComment searchVars currCommentFormat[1].count (execute currCommentFormat[2])
			)
			currComment
		),
		
		--eserna modificada
		fn QTCreateSubmitInfoFile filename outputFileName isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			local formattedJobName = (SMTDFunctions.FormatJobName SMTDSettings.JobName isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName)
			local formattedComment = (SMTDFunctions.FormatComment SMTDSettings.Comment)
			
			--if rendNthFrame == 1
			local submitInfoFile = CreateFile filename
			if (submitInfoFile != undefined) then
			(
				StartFrame = EndFrame = 0
				case rendTimeType of
				(
					2: (
						StartFrame = animationRange.start.frame as integer
						EndFrame = animationRange.end.frame as integer
					)	
					3: (
						StartFrame = rendStart.frame as integer
						EndFrame = rendEnd.frame as integer
					)	
				)
				
				local PluginToUse = case SMTDSettings.QuicktimeUseGenerator of
				(
					1: "Quicktime"
					2: "QuicktimeFusion"
				)

				local NameToShow = case SMTDSettings.QuicktimeUseGenerator of
				(
					1: "QuicktimeGenerator"
					2: (
						case SMTDSettings.QuicktimeFusionVersion of
						(
							1: "DFusion4 Quicktime"
							2: "Fusion5 Quicktime"
						)	
					)	
				)				
				format "Plugin=%\n" PluginToUse to:submitInfoFile
				
				if PluginToUse == "QuicktimeFusion" do
					format "LimitGroups=fusion\n" to:submitInfoFile
				
				if SMTDSettings.TilesRendering then
				(
					if SMTDSettings.TilesSubmissionJobIDs.count > 0 do
					(
						local theDependencies = ""
						for i = 1 to SMTDSettings.TilesSubmissionJobIDs.count-1 do theDependencies+= SMTDSettings.TilesSubmissionJobIDs[i] + ","
						theDependencies+= SMTDSettings.TilesSubmissionJobIDs[SMTDSettings.TilesSubmissionJobIDs.count] 
						format "JobDependencies=%\n" 	theDependencies  to:submitInfoFile
						format "ResumeOnDeletedDependencies=%\n" SMTDSettings.ResumeOnDeletedDependencies to:submitInfoFile
					)	
				)
				else
				(
					format "JobDependencies=%\n" 	SMTDSettings.DeadlineSubmissionLastJobID  to:submitInfoFile
					format "ResumeOnDeletedDependencies=%\n" SMTDSettings.ResumeOnDeletedDependencies to:submitInfoFile
				)	

				
				format "Priority=%\n" 			SMTDSettings.Priority 	 				to:submitInfoFile
				format "Pool=%\n" 				SMTDSettings.QuicktimePoolName			to:submitInfoFile
				--format "PoolMachinesOnly=%\n" 	SMTDSettings.QuicktimePoolExclusive		to:submitInfoFile
				format "Group=%\n" 				SMTDSettings.QuicktimeGroup			to:submitInfoFile
				
				format "Name=% [%]\n" 			formattedJobName NameToShow			to:submitInfoFile
				
				format "UserName=%\n"			SMTDSettings.UserName				to:submitInfoFile
				format "Comment=%\n" 			formattedComment					to:submitInfoFile
				
				format "Department=%\n" 		SMTDSettings.Department 				to:submitInfoFile				
				--format "Group=%\n" 			SMTDSettings.Group 					to:submitInfoFile					
				format "Frames=%\n" ((StartFrame as string) + "-" + (EndFrame as string))	to:submitInfoFile
				format "ChunkSize=100000\n" 											to:submitInfoFile
				
				format "OutputDirectory0=%\n" (getFileNamePath outputFileName) 				to:submitInfoFile
				format "OutputFilename0=%\n" (filenameFromPath outputFileName) 			to:submitInfoFile
				
				close submitInfoFile
				true
			)
			else
				false
		),
		
		fn QTCreateJobInfoFile filename inputImages outputFileName =
		(
			local JobInfoFile = CreateFile filename
			if (JobInfoFile != undefined) then
			(
			
				StartFrame = EndFrame = 0
				case rendTimeType of
				(
					2: (
						StartFrame = animationRange.start.frame as integer
						EndFrame = animationRange.end.frame as integer
					)	
					3: (
						StartFrame = rendStart.frame as integer
						EndFrame = rendEnd.frame as integer
					)	
				)
			
				theBaseFile = getFileNameFile inputImages
				theSource = if superclassof (try(execute (substring theBaseFile (theBaseFile.count-3) 4))catch()) == Number then
					inputImages 
				else
					getFileNamePath inputImages + theBaseFile  + SMTDFunctions.getZeros StartFrame + StartFrame as string +getFileNameType inputImages 

				format "InputImages=%\n" theSource  to:JobInfoFile
				format "OutputFile=%\n" outputFileName to:JobInfoFile
				format "FrameRate=%\n" FrameRate to:JobInfoFile
				
				--if SMTDSettings.QuicktimeUseGenerator == 1 do 
				--	format "ExportSettingsFile=%%.xml\n" "c:\\Deadline\\slave\\jobsData\\" SMTDSettings.QuicktimeSettingsFile to:JobInfoFile

				if SMTDSettings.QuicktimeUseGenerator == 2 do
				(
					format "Version=%\n" #("4","5")[SMTDSettings.QuicktimeFusionVersion] to:JobInfoFile
					
					format "Codec=%\n" SMTDSettings.QuicktimeCodec[SMTDSettings.QuicktimeFusionVersion] to:JobInfoFile
					format "Quality=%\n" SMTDSettings.QuicktimeQuality to:JobInfoFile
					format "MissingFrames=2\n" to:JobInfoFile
					format "Proxy=%\n" SMTDSettings.QuicktimeProxy to:JobInfoFile
				
					if SMTDSettings.QuicktimeUseTemplate[SMTDSettings.QuicktimeFusionVersion] then
						format "Template=%\n" SMTDSettings.QuicktimeTemplate[SMTDSettings.QuicktimeFusionVersion] to:JobInfoFile
					else
						format "Template=\n"  to:JobInfoFile
	
					format "Gamma=%\n" SMTDSettings.QuicktimeGamma to:JobInfoFile
					format "ExpCompensation=%\n" SMTDSettings.QuicktimeExposure to:JobInfoFile
					format "CurveCorrect=false\n" to:JobInfoFile
					format "BackgroundPlate=\n" to:JobInfoFile
					
					format "ArtistName=%\n" SMTDSettings.UserName to:JobInfoFile
					format "Department=%\n" SMTDSettings.Department to:JobInfoFile
					format "ProjectTitle=%\n" "" to:JobInfoFile
					format "Comment=%\n" "" to:JobInfoFile
				)
				
				Close JobInfoFile
				true
			)
			else
				false
		
		),
		
		--eserna modificada
		fn AutomaticQuicktimeGeneration overrideOutputPath:"" overrideInput:"" isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			local goOn = true
			if rendTimeType == 1 do (goOn = false; SMTD_MainRollout.Ui_report "--No Automatic Quicktime Generation for Single Frames.\n" )
			if rendTimeType == 4 do (goOn = false; SMTD_MainRollout.Ui_report "--No Automatic Quicktime Generation for User Frames because of potential gaps in frame numbering.\n" )
			
			-- if SMTDSettings.TilesRendering and SMTDSettings.TilesSubmissionMode == #Deadline do (goOn = false; SMTD_MainRollout.Ui_report "--No Quicktime Generation for Tiles Rendering Jobs Spawning On Deadline.\n--Use [Submit All Tile Jobs From This Workstation] Mode instead.\n" )
			
			if SMTDSettings.SubmitAsMXSJob do (goOn = false; SMTD_MainRollout.Ui_report "--No Automatic Quicktime Generation for MAXScript Jobs.\n" )
			if SMTDSettings.UseBatchRender do (goOn = false; SMTD_MainRollout.Ui_report "--No Automatic Quicktime Generation for Batch Rendering Jobs.\n" )
			
			if goOn then
			(
				SMTD_MainRollout.Ui_report ">Submitting Quicktime Job."
				
				local submitInfo = SMTDPaths.TempDir + "QT_max_submit_info.job"
				local jobInfo = SMTDPaths.TempDir + "QT_max_job_info.job"
				local theMOVfile = if overrideOutputPath == "" then
					getFileNamePath rendOutputFilename 
				else	
					overrideOutputPath
					
				local theInputPath = if overrideInput == "" then
					rendOutputFilename 
				else
					overrideInput
					
				theMOVfile += case SMTDSettings.QuicktimeFilenameMode of
				(
					1: getFileNameFile rendOutputFilename 
					2: SMTDSettings.JobName
					3: SMTDSettings.QuicktimeCustomFilename
				)	
				theMOVfile +=  ".mov"
				
				SMTDFunctions.QTCreateSubmitInfoFile submitInfo theMOVfile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
				SMTDFunctions.QTCreateJobInfoFile jobinfo theInputPath theMOVfile 
				local initialArgs = ""
				initialArgs += "\"" + submitInfo + "\" \"" + jobInfo + "\""
				if SMTDSettings.QuicktimeUseGenerator == 1 do
					initialArgs += " \"" + SMTDPaths.SettingsDir + "qt\\" + SMTDSettings.QuicktimeSettingsFile + ".xml\" "			
				local retCode = SMTDFunctions.waitForCommandToComplete initialArgs SMTDSettings.TimeoutQTSubmission
				if retCode == #success then
				(
					renderMsg = SMTDFunctions.getRenderMessage()				
					try(SMTD_MainRollout.Ui_report ("Quicktime Job submitted successfully.\n\n" + renderMsg))catch()					
					try(SMTD_MainRollout.sld_lastSubmissionState.color = green)catch()		
				)	
				else	
				(
					try(SMTD_MainRollout.sld_lastSubmissionState.color = red*0.7)catch()
					if result == #timeout then
						try(SMTD_MainRollout.Ui_report ("--Failed To Submit Quicktime Job in " + SMTDSettings.TimeoutQTSubmission as string + " seconds.\nConsider Increasing the Quicktime Submission Timeout in the User Options tab."))catch()
					else	
						try(SMTD_MainRollout.Ui_report ("--Failed To Submit Quicktime Job."))catch()
				)
							
			)	
		),
		
		--eserna modificada
		fn CreateSubmitInfoFile filename customPlugin: customOutputFile: includeBothOutputs:false frameMode:#both customFrameSequence:"" isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(

			local formattedJobName = (SMTDFunctions.FormatJobName SMTDSettings.JobName isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName)
			local formattedComment = (SMTDFunctions.FormatComment SMTDSettings.Comment)
			
			local submitInfoFile = CreateFile filename
			if (submitInfoFile != undefined) then
			(
				if customPlugin == unsupplied then 
				(
					local pluginToUse = SMTDFunctions.getPluginToUse()
					format "Plugin=%\n" pluginToUse to:submitInfoFile
				)
				 else 
				(
					format "Plugin=%\n" customPlugin to:submitInfoFile
				)
				
				if SMTDSettings.CurrentRepository != "" then  
					format "NetworkRoot=%\n" SMTDSettings.CurrentRepository  to:submitInfoFile
				else
				(
					if SMTDSettings.CurrentRepository2 != "" do
					(
						--format "TransferJobToRepository=%\n" SMTDSettings.CurrentRepository2  to:submitInfoFile
						--format "TransferJobAsSuspended=%\n" SMTDSettings.TransferJobAsSuspended to:submitInfoFile
						
						format "NotificationEmails=%\n" SMTDSettings.AlternateEmails to:submitInfoFile
						
						local notificationNote = substituteString SMTDSettings.NotificationNote "\r" ""
						notificationNote = substituteString notificationNote "\n" "[EOL]"
						format "NotificationNote=%\n" notificationNote to:submitInfoFile
					)
				)

				if SMTDSettings.SlavesList.count > 0 do
				(
					local theKeyword = if SMTDSettings.SlavesBlackList then "Blacklist" else "Whitelist"
					local theSlaveListString = ""
					for i = 1 to SMTDSettings.SlavesList.count-1 do 
						theSlaveListString += SMTDSettings.SlavesList[i] + ","
					theSlaveListString += SMTDSettings.SlavesList[SMTDSettings.SlavesList.count]
					format "%=%\n" theKeyword theSlaveListString to:submitInfoFile
				)

				
				if SMTDSettings.SubmitAsDependent and frameMode != #rest do
				(
					depJobIds = ""
					theJobs = SMTDSettings.DependencyJobItems as array
					for i = 1 to theJobs.count do
					(
						depJobIds += SMTDSettings.JobsArray[theJobs[i]][2] 
						if i < theJobs.count do depJobIds += ","
					)	
					format "JobDependencies=%\n" depJobIds  to:submitInfoFile
					format "ResumeOnDeletedDependencies=%\n" SMTDSettings.ResumeOnDeletedDependencies to:submitInfoFile
				)	
				if  frameMode == #rest do
				(
					format "JobDependencies=%\n" SMTDSettings.DeadlineSubmissionLastJobID  to:submitInfoFile
					format "ResumeOnDeletedDependencies=%\n" SMTDSettings.ResumeOnDeletedDependencies to:submitInfoFile
				)
						
				if SMTDSettings.submitAsSuspended OR SMTDSettings.CurrentRepository2 != "" OR (SMTDSettings.SubmitExternalFilesMode > 1 AND SMTDSettings.SubmitExternalFilesMode < 4 ) do
					format "InitialStatus=Suspended\n" to:submitInfoFile	
				
				if SMTDSettings.SequentialJob do
					format "SequentialJob=1\n" to:submitInfoFile	

				local frames = "1"	
				
				if not SMTDSettings.UseBatchRender do
				(
					frames = case rendTimeType of
					(
						1: SMTDFunctions.GetSequenceString #(currentTime.frame as integer)
						2: (
							local currentSequence = for t in animationRange.start to animationRange.end by rendNthFrame collect (t.frame as integer)
							if frameMode == #both then 
								currentSequence = SMTDFunctions.outOfOrderMethod currentSequence theMethod:SMTDSettings.outOfOrderMethod
							else	
							(
								currentSequence = SMTDFunctions.outOfOrderSequence currentSequence mode:frameMode
								currentSequence = SMTDFunctions.outOfOrderMethod currentSequence theMethod:SMTDSettings.outOfOrderMethod
							)	
							SMTDFunctions.GetSequenceString currentSequence 
						)	
						3: (
							local currentSequence = for t in rendStart to rendEnd by rendNthFrame collect (t.frame as integer)
							if frameMode == #both then 
								currentSequence = SMTDFunctions.outOfOrderMethod currentSequence theMethod:SMTDSettings.outOfOrderMethod
							else	
							(
								currentSequence = SMTDFunctions.outOfOrderSequence currentSequence mode:frameMode
								currentSequence = SMTDFunctions.outOfOrderMethod currentSequence theMethod:SMTDSettings.outOfOrderMethod
							)	
							SMTDFunctions.GetSequenceString currentSequence 
						)	
						4: rendPickupFrames
					)
					--format "%\n" frames 
				)	
				--if SMTDSettings.TilesRendering AND SMTDSettings.TilesSubmissionMode == #deadline do frames = "1"
				if SMTDSettings.SubmitAsMXSJob AND SMTDSettings.SingleTaskJob do frames = "1"
				if customFrameSequence != "" do frames = customFrameSequence
				
				if SMTDSettings.TilesRendering and SMTDSettings.SingleTileJob then
				(
					if SMTDSettings.UseCustomTiles then
						format "Frames=%\n"			SMTDSettings.SingleTileJobFrameList			to:submitInfoFile
					else
						format "Frames=0-%\n" 		(SMTDSettings.SingleTileJobTileCount-1)		to:submitInfoFile
					format "ChunkSize=1\n"														to:submitInfoFile
					format "TileJob=True\n"														to:submitInfoFile
					format "TileJobFrame=%\n"		(currentTime.frame as integer)				to:submitInfoFile
					format "TileJobTilesInX=%\n"	SMTDSettings.TilesInX						to:submitInfoFile
					format "TileJobTilesInY=%\n"	SMTDSettings.TilesInY						to:submitInfoFile
				)
				else
				(
					format "Frames=%\n" 				frames 						to:submitInfoFile
					format "ChunkSize=%\n" 				SMTDSettings.ChunkSize		to:submitInfoFile
				)
				
				--format "ReorderFrames=%\n" 			(rendTimeType == 4)			to:submitInfoFile
				format "Priority=%\n" 				SMTDSettings.Priority 	 		to:submitInfoFile
				format "Pool=%\n" 					SMTDSettings.PoolName		to:submitInfoFile
				
				if SMTDSettings.TaskTimeoutEnabled then
					format "TaskTimeoutSeconds=%\n" 		SMTDSettings.TaskTimeout 		to:submitInfoFile
				else
					format "TaskTimeoutSeconds=0\n" 									to:submitInfoFile
				format "EnableAutoTimeout=%\n"			SMTDSettings.AutoTaskTimeout				to:submitInfoFile
				
				--format "ForceReloadPlugin=false\n" to:submitInfoFile
				format "ForceReloadPlugin=%\n"			SMTDSettings.RestartMax						to:submitInfoFile

				format "MaxTasksPerSlave=%\n" 			SMTDSettings.MaxTasksPerSlave				to:submitInfoFile
				format "LimitTasksToNumberOfCpus=%\n" 	SMTDSettings.LimitTasksToNumberOfCpus		to:submitInfoFile
				
				local theSpecialLabel = ""
				if SMTDSettings.SubmitAsMXSJob then
					theSpecialLabel = "[MAXSCRIPT]"
				else
				(
					if SMTDSettings.TilesRendering then
					(
						--theSpecialLabel = if SMTDSettings.TilesSubmissionMode == #deadline then "[TILE MASTER]"
						--theSpecialLabel = ""
						if SMTDSettings.SingleTileJob then
							theSpecialLabel = " (Frame " + ((currentTime.frame as integer) as string) + " - " + ((SMTDSettings.TilesInX * SMTDSettings.TilesInY) as string) + " Tiles)"
					)
					else
					(
						if SMTDSettings.UseBatchRender then
							theSpecialLabel = "[BATCH MASTER]"
						else
							theSpecialLabel =case frameMode of
							(
								#both: ""
								#nth: "[PREVIEW FRAMES]" 
								#rest: "[REST OF FRAMES]" 	
							)
					)
				)
				
				format "Name=% %\n" 				formattedJobName theSpecialLabel 	to:submitInfoFile
				
				format "UserName=%\n"				SMTDSettings.UserName		to:submitInfoFile
				format "Comment=%\n" 				formattedComment			to:submitInfoFile
				
				format "Department=%\n" 			SMTDSettings.Department 		to:submitInfoFile				
				format "Group=%\n" 				SMTDSettings.Group 			to:submitInfoFile				
				
				if SMTDSettings.RunPreJobScript do
					format "PreJobScript=%\n" SMTDSettings.PreJobScriptFile to:submitInfoFile
				if SMTDSettings.RunPostJobScript do
					format "PostJobScript=%\n" SMTDSettings.PostJobScriptFile to:submitInfoFile
				if SMTDSettings.RunPostTaskScript then
					format "PostTaskScript=%\n" SMTDSettings.PostTaskScriptFile to:submitInfoFile
				if SMTDSettings.RunPreTaskScript do
					format "PreTaskScript=%\n" SMTDSettings.PreTaskScriptFile to:submitInfoFile
				
				case SMTDSettings.ScheduledType of
				(
					#None: (format "ScheduledType=None\n" to:submitInfoFile	)
					#Once: 
					(
						format "ScheduledType=Once\n" to:submitInfoFile	
						format "ScheduledStartDateTime=%\n" SMTDSettings.ScheduledStartDateTime to:submitInfoFile	
					)
					#Daily: 
					(
						format "ScheduledType=Daily\n" to:submitInfoFile	
						format "ScheduledDays=%\n" SMTDSettings.ScheduledDays to:submitInfoFile	
						format "ScheduledStartDateTime=%\n" SMTDSettings.ScheduledStartDateTime to:submitInfoFile	
					)
				)
								
				local outputFilenameIndex = 0
				-- If an output filename is specified, include it in the submit info file for accessing through the Monitor's RC Menu 
				
				local theRenderOutput = rendOutputFilename
				
				local outputOriginalFilename = true
				if not includeBothOutputs and customOutputFile != unsupplied do outputOriginalFilename = false
				
				if outputOriginalFilename and rendSaveFile and theRenderOutput != "" then
				(
					format "OutputDirectory%=%\n" outputFilenameIndex	(getFilenamePath theRenderOutput) 	to:submitInfoFile
					if SMTDSettings.RemovePadding and rendTimeType == 1 then
						format "OutputFilename%=%\n" outputFilenameIndex (filenameFromPath theRenderOutput) to:submitInfoFile
					else
					(
						-- Need to watch out for the special case where the output filename already ends in 4 digits.
						-- In this case, we need to strip the 4 digits before adding the "####" part.
						filenameOnly = getFilenameFile theRenderOutput
						if rendTimeType != 1 and filenameOnly.count > 4 and filenameOnly[filenameOnly.count] != "." then
						(
							try
							(
								padding = (substring filenameOnly (filenameOnly.count - 3) -1) as integer
								if padding != undefined then
									filenameOnly = substring filenameOnly 1 (filenameOnly.count - 4)
							)
							catch()
						)
						
						local paddingString = "####"
						if SMTDSettings.TilesRendering and SMTDSettings.SingleTileJob then
						(
							paddingString = formattedPrint (currentTime.frame as integer) format:"04i"
						)
						
						format "OutputFilename%=%\n" outputFilenameIndex (filenameOnly + paddingString + (getFilenameType theRenderOutput)) to:submitInfoFile
					)
					outputFilenameIndex += 1
				)
				
				--if customOutputFile != unsupplied and rendSaveFile and theRenderOutput != "" do 
				if customOutputFile != unsupplied do 
				(
					theRenderOutput = customOutputFile
					format "OutputDirectory%=%\n" outputFilenameIndex	(getFilenamePath theRenderOutput) 	to:submitInfoFile
					if SMTDSettings.RemovePadding and rendTimeType == 1 then
						format "OutputFilename%=%\n" outputFilenameIndex (filenameFromPath theRenderOutput) to:submitInfoFile
					else
					(
						-- Need to watch out for the special case where the output filename already ends in 4 digits.
						-- In this case, we need to strip the 4 digits before adding the "####" part.
						filenameOnly = getFilenameFile theRenderOutput
						if rendTimeType != 1 and filenameOnly.count > 4 and filenameOnly[filenameOnly.count] != "." then
						(
							try
							(
								padding = (substring filenameOnly (filenameOnly.count - 3) -1) as integer
								if padding != undefined then
									filenameOnly = substring filenameOnly 1 (filenameOnly.count - 4)
							)
							catch()
						)
						
						local paddingString = "####"
						if SMTDSettings.TilesRendering and SMTDSettings.SingleTileJob then
						(
							paddingString = formattedPrint (currentTime.frame as integer) format:"04i"
						)
						
						format "OutputFilename%=%\n" outputFilenameIndex (filenameOnly + paddingString + (getFilenameType theRenderOutput)) to:submitInfoFile
					)
					outputFilenameIndex += 1					
				)	
				
				-- If any render elements are specified, include them too (max of 6 files including
				-- main output filename)
				local reManager = maxOps.GetCurRenderElementMgr()
				--eserna modificada - solo prepara la informacion para render elements si no se ha llamado desde lpm
				--if not isLPMjobreManager.GetElementsActive() then --only write paths if the Render Elements are globally enabled
				if reManager.GetElementsActive() then --only write paths if the Render Elements are globally enabled
				(
					local reCount = reManager.NumRenderElements()
					for i = 0 to reCount - 1 do
					(
						-- We don't need to cap this at 6 filenames anymore!
						--if outputFilenameIndex >= 6 then exit
						
						reObject = reManager.GetRenderElement i
						if reObject.enabled then
						(
							reFilename = reManager.GetRenderElementFilename i
							if reFilename != undefined and reFilename != "" then
							(
								format "OutputDirectory%=%\n" outputFilenameIndex (getFilenamePath reFilename) to:submitInfoFile
								if SMTDSettings.RemovePadding and rendTimeType == 1 then
									format "OutputFilename%=%\n" outputFilenameIndex ((getFilenameFile reFilename) + (getFilenameType reFilename)) to:submitInfoFile
								else
								(
									reFilenameOnly = (getFilenameFile reFilename)
									if rendTimeType != 1 and reFilenameOnly.count > 4 and reFilenameOnly[reFilenameOnly.count] != "."  then
									(
										try
										(
											padding = (substring reFilenameOnly (reFilenameOnly.count - 3) -1) as integer
											if padding != undefined then
												reFilenameOnly = substring reFilenameOnly 1 (reFilenameOnly.count - 4)
										)
										catch()
									)
									
									local paddingString = "####"
									if SMTDSettings.TilesRendering and SMTDSettings.SingleTileJob then
									(
										paddingString = formattedPrint (currentTime.frame as integer) format:"04i"
									)
									
									format "OutputFilename%=%\n" outputFilenameIndex (reFilenameOnly + paddingString + (getFilenameType reFilename)) to:submitInfoFile
									--format "OutputFilename%=%\n" outputFilenameIndex ((getFilenameFile reFilename) + paddingString + (getFilenameType reFilename)) to:submitInfoFile
								)
								outputFilenameIndex = outputFilenameIndex + 1
							)
						)--end if enabled	
					)--end i loop
				)--end if REs active
	
				local rendererClass = (classOf renderers.current) as string --get the class of the current renderer as string
				local limitGroups = ""	--initialize limit groups to empty string
				local limitGroupsToUseArray = for i in SMTDSettings.LimitGroupsToUse collect i
				
				--if the renderer is mental ray and Max is a version below 8, or if the workstation mode is forced, add the limit group for the current plugin
				if SMTDSettings.LimitGroupAutoWorkstation == true do
				(
					if SMTDSettings.forceWorkstationMode OR SMTDSettings.SubmitAsMXSJob do  
						append limitGroupsToUseArray (pluginToUse + "Workstation")
				)
				
				--if the renderer is brazil, add the brazil limit group to the string
				if SMTDSettings.LimitGroupAutoBrazil==true AND matchPattern rendererClass pattern:"*brazil*" AND findItem limitGroupsToUseArray "Brazil" == 0 do  
					append limitGroupsToUseArray "Brazil"
				
				for i = 1 to limitGroupsToUseArray.count do
				(
					limitGroups += limitGroupsToUseArray [i] 
					if i < limitGroupsToUseArray.count do limitGroups += ","
				)	
										
				--if any limit groups have been collected, output them						
				if limitGroups != "" do format "LimitGroups=%\n" limitGroups to:submitInfoFile
				
				--if limit is requested, set it, otherwise output 0 (no limit)
				if SMTDSettings.limitEnabled then
					format "MachineLimit=%\n" SMTDSettings.machineLimit 	to:submitInfoFile
				else	
					format "MachineLimit=0\n" to:submitInfoFile

				--format "DeleteOnComplete=%\n" SMTDSettings.autoDelete to:submitInfoFile
				format "OnJobComplete=%\n" SMTDSettings.OnComplete to:submitInfoFile
				
				format "Interruptible=%\n" SMTDSettings.JobIsInterruptible to:submitInfoFile
				
				if SMTDSettings.CopyVbscriptFile do
					--format "PostJobScript=c:/deadline/slave/jobsData/copyImsq.vbs\n" to:submitInfoFile
					format "PostJobScript=copyImsq.py\n" to:submitInfoFile
				
				
				close submitInfoFile
				true
			)
			else
				false
		),
	
		--eserna modified
		--THIS IS NOW CALLED PLUGIN INFO FILE!
		fn CreateJobInfoFile filename renderOutputOverride:"" tileString:"" forceCamera:"" isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			local JobInfoFile = CreateFile filename
			if (JobInfoFile != undefined) then
			(
				local maxVersionToUse = SMTDFunctions.getMaxVersion()
				format "Version=%\n" maxVersionToUse to:JobInfoFile
				
				if( ((maxVersion())[1]/1000 as integer) >= 12 ) then
					if( maxOps.productID == #3dsMaxDesign ) then
						format "IsMaxDesign=1\n" to:JobInfoFile
					else
						format "IsMaxDesign=0\n" to:JobInfoFile
				else
					format "IsMaxDesign=0\n" to:JobInfoFile
				
				if( not SMTDSettings.SubmitScene ) then
					format "SceneFile=%\n" (maxFilePath + maxFileName) to:JobInfoFile
				
				format "Padding=%\n" 4 to:JobInfoFile
				format "RemovePadding=%\n" (if SMTDSettings.RemovePadding and rendTimeType == 1 then 1 else 0) to:JobInfoFile
				
				format "IgnoreMissingExternalFiles=%\n" (if SMTDSettings.IgnoreMissingExternalFiles then 1 else 0) to:JobInfoFile
				format "IgnoreMissingUVWs=%\n" (if SMTDSettings.IgnoreMissingUVWs then 1 else 0) to:JobInfoFile
				format "IgnoreMissingDLLs=%\n" (if SMTDSettings.IgnoreMissingDLLs then 1 else 0) to:JobInfoFile
				format "IgnoreMissingXREFs=%\n" (if SMTDSettings.IgnoreMissingXREFs then 1 else 0) to:JobInfoFile
				format "DisableMultipass=%\n" (if SMTDSettings.DisableMultipass then 1 else 0) to:JobInfoFile
				format "LocalRendering=%\n" (if SMTDSettings.LocalRendering then 1 else 0) to:JobInfoFile
				
				local rendererClass = (classOf renderers.current) as string --get the class of the current renderer as string
				if SMTDSettings.forceWorkstationMode OR SMTDSettings.UseBatchRender then
				(
					format "UseSlaveMode=0\n" to:JobInfoFile
					if SMTDSettings.UseSilentMode then
						format "UseSilentMode=1\n" to:JobInfoFile
					else
						format "UseSilentMode=0\n" to:JobInfoFile
				)
				else
				(
					format "UseSlaveMode=1\n" to:JobInfoFile
					format "UseSilentMode=0\n" to:JobInfoFile
				)
				
				if SMTDSettings.UsePathConfigFile then
					format "PathConfigFile=%\n" (FileNameFromPath SMTDSettings.PathConfigFile) to:JobInfoFile
				
				--FIX ME
				--format "FrameNumberBase=%\n" rendFileNumberBase to:JobInfoFile				
							
				format "RestartRendererMode=%\n" ( if SMTDSettings.RestartRenderer then 1 else 0 ) to:JobInfoFile
				format "DisableProgressUpdateTimeout=%\n" ( if SMTDSettings.DisableProgressUpdateTimeout then 1 else 0 ) to:JobInfoFile

				if SMTDSettings.MaxTasksPerSlave > 1 then 
				(
					format "OverrideFailOnExistingMaxProcess=true\n" to:JobInfoFile
					format "FailOnExistingMaxProcess=false\n" to:JobInfoFile
				)
				else
				(
					format "OverrideFailOnExistingMaxProcess=%\n" SMTDSettings.OverrideFailOnExistingMaxProcess to:JobInfoFile
					format "FailOnExistingMaxProcess=%\n" SMTDSettings.FailOnExistingMaxProcess to:JobInfoFile				
				)				
				  
				if SMTDSettings.IsBakeJob then
				(
					bakeString = "BakeObjs="
					
					for o in SMTD_objsToBake do 
						bakeString += o.name + ","
					
					bakeString[bakestring.count] = "\n"
					
					format bakeString to:JobInfoFile
				)
				

				if forceCamera == "" then --no forced camera
				(
					local theCam = viewport.getCamera() --get viewport camera
					if isValidNode theCam then --if it is valid, output it
						format "Camera=%\n" (theCam.name) to:JobInfoFile
					else                    
						format "Camera=\n" to:JobInfoFile --if viewport is not a camera, output no camera.
				)    
				else	
					format "Camera=%\n" forceCamera to:JobInfoFile --if camera was supplied, force output to it.
				
				format "Camera0=\n" to:JobInfoFile

				--Write out all cameras found in the current scene:                                
				local theCameras = for c in objects where findItem Camera.classes (classof c) > 0 collect c
				for c = 1 to theCameras.count do
					format "Camera%=%\n" c theCameras[c].name to:JobInfoFile
				
				if SMTDSettings.RunPreLoadScript do
					format "PreLoadScript=%\n" (FileNameFromPath SMTDSettings.PreLoadScriptFile) to:JobInfoFile
				if SMTDSettings.RunPostLoadScript do
					format "PostLoadScript=%\n" (FileNameFromPath SMTDSettings.PostLoadScriptFile) to:JobInfoFile
				if SMTDSettings.RunPostFrameScript then
					format "PostFrameScript=%\n" (FileNameFromPath SMTDSettings.PostFrameScriptFile) to:JobInfoFile
				if SMTDSettings.RunPreFrameScript do
					format "PreFrameScript=%\n" (FileNameFromPath SMTDSettings.PreFrameScriptFile) to:JobInfoFile
				
				if not (SMTDSettings.RunPostFrameScript or SMTDSettings.RunPreFrameScript) then (
					if (renderers.current.classid as string) == "#(1121714582, 90602926)" then
					(
						thePreScriptFile = "H:\\max9_synch\\Main\\synch_scripts\\RnD\\Amaretto\\VO_AmarettoPreFrameDataCollection.ms"
						thePostScriptFile = "H:\\max9_synch\\Main\\synch_scripts\\RnD\\Amaretto\\VO_AmarettoPostFrameDataCollection.ms"
						if (doesFileExist thePreScriptFile) and (doesFileExist thePostScriptFile) do (
							format "PreFrameScript=%\n" (fileNameFrompath thePreScriptFile) to:JobInfoFile
							format "PostFrameScript=%\n" (fileNameFrompath thePostScriptFile) to:JobInfoFile
						)
					)
				)
				
				format "MaxVersionToForce=%\n" SMTDSettings.MaxVersionToForce to:JobInfoFile
				format "MaxVersionToForce0=none\n" to:JobInfoFile
				format "MaxVersionToForce1=32bit\n" to:JobInfoFile
				format "MaxVersionToForce2=64bit\n" to:JobInfoFile
				
				if SMTDSettings.UseJpegOutput do
				(
					format "UseJpegOutput=1\n" to:JobInfoFile
					format "JpegOutputPath=%\n" SMTDSettings.JpegOutputPath to:JobInfoFile
				)
				
				if SMTDSettings.UseAltPluginIni and SMTDSettings.AltPluginIni != "" and SMTDSettings.AltPluginIni != "[Default]" do
					format "OverridePluginIni=%.ini\n" SMTDSettings.AltPluginIni to:JobInfoFile
				
				if SMTDSettings.enableFailOnBlackFrames then
					format "FailOnBlackFrames=1\n" to:JobInfoFile
				else
					format "FailOnBlackFrames=0\n" to:JobInfoFile
				format "BlackPixelPercentage=%\n" SMTDSettings.blackPixelPercentage to:JobInfoFile
				format "BlackPixelThreshold=%\n" SMTDSettings.blackPixelThreshold to:JobInfoFile
				if SMTDSettings.BlackFramesCheckRenderElements then
					format "BlackFramesCheckRenderElements=1\n" to:JobInfoFile
				else
					format "BlackFramesCheckRenderElements=0\n" to:JobInfoFile
				
				-- if output file is empty, check if rendering with vray and saving a raw image, and ignore render elements if so
				--if (renderers.current.classid as string == "#(-1204370534, -399920359)") or (renderers.current.classid as string == "#(1941615238, 2012806412)" and renderers.current.output_on and renderers.current.output_rawFileName != undefined and renderers.current.output_rawFileName != "" ) then
				if (renderers.current.classid as string == "#(1941615238, 2012806412)" and renderers.current.output_on and ((renderers.current.output_rawFileName != undefined and renderers.current.output_rawFileName != "") or (renderers.current.output_splitfilename != undefined and renderers.current.output_splitfilename != "")) ) then
					format "IgnoreRenderElements=1\n" to:JobInfoFile
				else
					format "IgnoreRenderElements=%\n" (if SMTDSettings.IgnoreRenderElements then 1 else 0) to:JobInfoFile
				
				--if Override == "" then
				if renderOutputOverride == "" then
					format "RenderOutput=%\n" rendOutputFilename to:JobInfoFile
				else	
					format "RenderOutput=%\n" renderOutputOverride to:JobInfoFile
				format "SaveFile=%\n" rendSaveFile to:JobInfoFile
				
				if tileString != "" do --if a tile string is passed as argument, we have to update render elements' filenames to include tile info:
				(
					format "RenderElementTiles=1\n" to:JobInfoFile
					-- If any render elements are specified, include them 
					local reManager = maxOps.GetCurRenderElementMgr()
					local outputFilenameIndex = 0
					if reManager.GetElementsActive() then 
					(
						local reCount = reManager.NumRenderElements()
						for i = 0 to reCount - 1 do
						(
							reObject = reManager.GetRenderElement i
							if reObject.enabled then
							(
								reFilename = reManager.GetRenderElementFilename i
								if reFilename != undefined and reFilename != "" then
								(
									/*
									if SMTDSettings.RemovePadding and rendTimeType == 1 then
										format "RenderElementOutputFilename%=%\n" outputFilenameIndex ((getFilenameFile reFilename) + (getFilenameType reFilename)) to:submitInfoFile
									else
									*/
									format "RenderElementOutputFilename%=%\n" outputFilenameIndex ((getFilenamePath reFilename) + (getFilenameFile reFilename) + "_" +  tileString +  (getFilenameType reFilename)) to:JobInfoFile -- + "####" +
									outputFilenameIndex = outputFilenameIndex + 1
								)
							)--end if enabled	
						)--end i loop
					)--end if REs active						
				)	
				
				format "ShowFrameBuffer=%\n" SMTDSettings.ShowFrameBuffer to:JobInfoFile
				
				format "OverrideBitmapPager=%\n" SMTDSettings.OverrideBitmapPager to:JobInfoFile
				format "BitmapPager=%\n" SMTDSettings.BitmapPager to:JobInfoFile

				--if (SMTDSettings.TilesRendering AND SMTDSettings.TilesSubmissionMode == #deadline )or SMTDSettings.SubmitAsMXSJob or SMTDSettings.UseBatchRender do
				if SMTDSettings.SubmitAsMXSJob or SMTDSettings.UseBatchRender do
					format "MAXScriptJob=1\n" to:JobInfoFile
				
				if SMTDSettings.RegionRendering do
				(
					format "RegionRendering=1\n" to:JobInfoFile
					
					if not SMTDSettings.TilesRendering or not SMTDSettings.SingleTileJob then
					(
						local tempLeft
						local tempTop
						local tempRight
						local tempBottom
						
						if (SMTDSettings.TilesRendering and not SMTDSettings.SingleTileJob) or (not SMTDSettings.RegionUseMaxValues) then
						(
							tempLeft = (SMTDSettings.RegionLeft as integer)
							tempTop = (SMTDSettings.RegionTop as integer)
							tempRight = (SMTDSettings.RegionRight as integer)
							tempBottom = (SMTDSettings.RegionBottom as integer)
						)
						else
						(
							if viewport.activeViewport > 0 then 
							(
								local theRect = viewport.getRegionRect (viewport.activeViewport)
								tempLeft = theRect.x
								tempTop = theRect.y
								tempRight = theRect.x + theRect.w
								tempBottom = theRect.y + theRect.h
							)
							else
							(
								tempLeft = 0
								tempTop = 0
								tempRight = RenderWidth
								tempBottom = RenderHeight
							)
						)
						
						format "RegionLeft=%\n" tempLeft to:JobInfoFile
						format "RegionTop=%\n" tempTop to:JobInfoFile
						format "RegionRight=%\n" tempRight to:JobInfoFile
						format "RegionBottom=%\n" tempBottom to:JobInfoFile
					)
					
					if SMTDSettings.TilesRendering then
					(
						format "RegionPadding=%\n" SMTDSettings.TilesPadding to:JobInfoFile
						
						if SMTDSettings.TileBlowupMode then
							format "RegionType=BLOWUP\n" to:JobInfoFile
						else
							format "RegionType=CROP\n" to:JobInfoFile
						
						if not SMTDSettings.SingleTileJob then
							format "PostFrameScript=\"maxTileAssemblerCommand.ms\"\n"  to:JobInfoFile
						else
						(
							format "RegionSingleJob=True\n" to:JobInfoFile
							format "RegionSingleFrame=%\n" (currentTime.frame as integer) to:JobInfoFile
							format "%\n" SMTDSettings.SingleTileJobLeft to:JobInfoFile
							format "%\n" SMTDSettings.SingleTileJobTop to:JobInfoFile
							format "%\n" SMTDSettings.SingleTileJobRight to:JobInfoFile
							format "%\n" SMTDSettings.SingleTileJobBottom to:JobInfoFile
							format "%\n" SMTDSettings.SingleTileJobFilename to:JobInfoFile
							format "%\n" SMTDSettings.SingleTileJobReFilename to:JobInfoFile
						)
					)
					else
					(
						format "RegionPadding=0\n" to:JobInfoFile
						format "RegionType=%\n" #("NOCROP","CROP","BLOWUP")[SMTDSETTINGS.RegionType] to:JobInfoFile
					)
				)
				
				if SMTDSettings.TilesRendering and SMTDSettings.TileBlowupMode then
				(
					--format "RenderWidth=%\n" ((ceil (1.0*RenderWidth/SMTDSettings.TilesInX)) as integer) to:JobInfoFile
					--format "RenderHeight=%\n" ((ceil (1.0*RenderHeight/SMTDSettings.TilesInY)) as integer) to:JobInfoFile
					format "RenderWidth=%\n" ((floor (1.0*RenderWidth/SMTDSettings.TilesInX)) as integer) to:JobInfoFile
					format "RenderHeight=%\n" ((floor (1.0*RenderHeight/SMTDSettings.TilesInY)) as integer) to:JobInfoFile
				)
				else
				(
					format "RenderWidth=%\n" renderWidth to:JobInfoFile
					format "RenderHeight=%\n" renderHeight to:JobInfoFile
				)
				
				--SCENE STATES
				/*
				format "SceneState=\n" to:JobInfoFile
				format "SceneState0=\n" to:JobInfoFile
				for i = 1 to sceneStateMgr.GetCount() do
					format "SceneState%=\n" i (sceneStateMgr.getSceneState i) to:JobInfoFile
				*/	
				
				format "renderPixelAspect=%\n" renderPixelAspect to:JobInfoFile

				format "rendAtmosphere=%\n" rendAtmosphere to:JobInfoFile
				format "renderEffects=%\n" renderEffects to:JobInfoFile
				format "renderDisplacements=%\n" renderDisplacements to:JobInfoFile
				format "rendSimplifyAreaLights=%\n" rendSimplifyAreaLights to:JobInfoFile
				format "rendForce2Side =%\n" rendForce2Side to:JobInfoFile
				format "rendHidden=%\n" rendHidden to:JobInfoFile
				format "rendColorCheck=%\n" rendColorCheck to:JobInfoFile
				format "rendSuperBlack =%\n" rendSuperBlack to:JobInfoFile
				format "rendFieldRender =%\n" rendFieldRender to:JobInfoFile

				format "SkipRenderedFrames =%\n" skipRenderedFrames to:JobInfoFile
				

				format "backgroundColor=%\n" backgroundColor to:JobInfoFile
				format "useEnvironmentMap=%\n" useEnvironmentMap to:JobInfoFile
				format "ambientColor=%\n" ambientColor to:JobInfoFile
				format "lightTintColor=%\n" lightTintColor to:JobInfoFile
				format "lightLevel=%\n" lightLevel to:JobInfoFile
				
				
				local rendererID = case (renderers.current.classid as string) of
				(
					"#(1, 0)": "scanline"
					"#(1387076610, 288174012)": "brazil"
					"#(95494396, 474502030)": "brmax"
					"#(1492548972, 1338981315)": "mentalray"
					"#(1941615238, 2012806412)": "vray"
					"#(-1204370534, -399920359)": "krakatoa"
					"#(1121714582, 90602926)": "amaretto"
					"#(217131703, 58075251)": "finalrender"
					"#(272052741, 712862621)": "maxwell"
					default: ""
				)	

				if rendererID == "scanline" AND SMTDSettings.ExportAdvancedRenderInfoScanline then
				(	
				
					for p in getPropNames renderers.current do
						try(format "%_%=%\n" rendererID (p as string) (getProperty renderers.current p) to:JobInfoFile)catch()
				
					format "scanline_globalSamplerClassByName0=Max 2.5 Star\n"  to:JobInfoFile
					format "scanline_globalSamplerClassByName1=Hammersley\n"  to:JobInfoFile
					format "scanline_globalSamplerClassByName2=Adaptive Halton\n"  to:JobInfoFile
					format "scanline_globalSamplerClassByName3=Adaptive Uniform\n"  to:JobInfoFile
					
					format "scanline_antialiasFilterClassByName=%\n" (classof scanlineRender.antiAliasFilter) to:JobInfoFile
					format "scanline_antialiasFilterClassByName0=Area\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName1=Quadratic\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName2=cubic\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName3=Catmull_Rom\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName4=Blackman\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName5=Video\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName6=Plate_Match_MAX_R2\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName7=Cook_Variable\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName8=Soften\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName9=Mitchell_Netravali\n" to:JobInfoFile
					format "scanline_antialiasFilterClassByName10=Blendfilter\n" to:JobInfoFile
					
					local theVal = if classof scanlineRender.antiAliasFilter == blend then scanlineRender.antiAliasFilter.blend else 0.3
					format "scanline_antialiasFilterBlend=%\n"  theVal to:JobInfoFile

					if classof scanlineRender.antiAliasFilter == Mitchell_Netravali then 
					(
						theVal1=scanlineRender.antiAliasFilter.Blur 
						theVal2=scanlineRender.antiAliasFilter.Ringing
					)	
					else	
						theVal1 = theVal2 = 0.3333
					format "scanline_antialiasFilterBlur=%\n"  theVal1 to:JobInfoFile	
					format "scanline_antialiasFilterRinging=%\n"  theVal2 to:JobInfoFile	
				)
				
				if rendererID == "brazil" AND SMTDSettings.ExportAdvancedRenderInfoBrazil then
				(
					for p in getPropNames renderers.current do
						try(format "%_%=%\n" rendererID (p as string) (getProperty renderers.current p) to:JobInfoFile)catch()
				
				
					local bucket_list = #("Random","Top to Bottom", "Left to Right", "Center Out")
					format "brazil_bucket_order_enums=%\n"  bucket_list[renderers.current.bucket_order+1] to:JobInfoFile
					for i = 0 to 3 do 
						format "brazil_bucket_order_enums%=%\n" i bucket_list[i+1] to:JobInfoFile

					bucket_list = #("16","32", "64", "128")
					format "brazil_bucket_size_enums=%\n"  bucket_list[renderers.current.bucket_size+1] to:JobInfoFile
					for i = 0 to 3 do 
						format "brazil_bucket_size_enums%=%\n" i bucket_list[i+1] to:JobInfoFile
				)
				
				if rendererID == "brmax" AND SMTDSettings.ExportAdvancedRenderInfoBrazil2 then
				(
					local brazilRenderer = ::sfs.b2_lib.getActiveB2() --Force global scope to access SplutterFish Script libraries!
					
					local blockNames = #("System_Options_Parameter_Block_Holder","Sampling_Parameter_Block_Holder","Motion_Blur_Parameter_Block_Holder","Ray_Server_Parameter_Block_Holder","Luma_Server_Parameter_Block_Holder","Render_Cache_Parameter_Block_Holder","Photon_Server_Parameter_Block_Holder","Render_Pass_Parameter_Block_Holder")
					for blockName in blockNames do
					(
						local block = brazilRenderer[blockName]
						if block != undefined then
						(
							local propNames = getPropNames block.object
							if propNames != undefined then
							(
								for p in propNames do
								(
									try(format "%_%=%\n" rendererID (p as string) (getProperty block.object p) to:JobInfoFile)catch()
								)
							)
						)
					)
					
					local block = brazilRenderer["System_Options_Parameter_Block_Holder"]
					if block != undefined then
					(
						local item_list = #("Hilbert","Top to Bottom","Left to Right","Center Out","Random")
						format "brmax_bucket_order_enums=%\n"  item_list[block.object.bucket_order+1] to:JobInfoFile
						for i = 0 to item_list.count-1 do 
							format "brmax_bucket_order_enums%=%\n" i item_list[i+1] to:JobInfoFile
						
						item_list = #("16","24","32","48","64")
						format "brmax_bucket_size_enums=%\n"  item_list[block.object.bucket_size+1] to:JobInfoFile
						for i = 0 to item_list.count-1 do 
							format "brmax_bucket_size_enums%=%\n" i item_list[i+1] to:JobInfoFile
						
						item_list = #("Disable","Automatic","Specify")
						format "brmax_rend_threading_mode_enums=%\n"  item_list[block.object.rend_threading_mode+1] to:JobInfoFile
						for i = 0 to item_list.count-1 do 
							format "brmax_rend_threading_mode_enums%=%\n" i item_list[i+1] to:JobInfoFile
					)
					
					block = brazilRenderer["Sampling_Parameter_Block_Holder"]
					if block != undefined then
					(
						local item_list = #("BrAreaFilter","BrMitNetFilter","BrCatmullRomFilter","BrCookVariableFilter","BrBlackmanFilter","BrVideoFilter","BrGaussianFilter")
						format "brmax_filter_name_enums=%\n"  block.object.filter_name to:JobInfoFile
						for i = 0 to item_list.count-1 do 
							format "brmax_filter_name_enums%=%\n" i item_list[i+1] to:JobInfoFile
					)
					
					block = brazilRenderer["Motion_Blur_Parameter_Block_Holder"]
					if block != undefined then
					(
						local item_list = #("Off","Image Motion Blur","3D Motion Blur")
						format "brmax_motion_blur_type_enums=%\n"  item_list[block.object.motion_blur_type+1] to:JobInfoFile
						for i = 0 to item_list.count-1 do 
							format "brmax_motion_blur_type_enums%=%\n" i item_list[i+1] to:JobInfoFile
						
						item_list = #("None","Basic")
						format "brmax_shutter_type_enums=%\n"  item_list[block.object.shutter_type+1] to:JobInfoFile
						for i = 0 to item_list.count-1 do 
							format "brmax_shutter_type_enums%=%\n" i item_list[i+1] to:JobInfoFile
					)
					
					block = brazilRenderer["Ray_Server_Parameter_Block_Holder"]
					if block != undefined then
					(
						local item_list = #("BrDefaultAccel","BrLDAccel","BrLDKDTreeAccelDesc")
						format "brmax_ray_accel_name_enums=%\n"  block.object.ray_accel_name to:JobInfoFile
						for i = 0 to item_list.count-1 do 
							format "brmax_ray_accel_name_enums%=%\n" i item_list[i+1] to:JobInfoFile
					)
					
					block = brazilRenderer["Luma_Server_Parameter_Block_Holder"]
					if block != undefined then
					(
						local item_list = #("No Enhancement","Auto-Occlusion","Retrace")
						format "brmax_rendercache_detail_mode_enums=%\n"  item_list[block.object.rendercache_detail_mode+1] to:JobInfoFile
						for i = 0 to item_list.count-1 do 
							format "brmax_rendercache_detail_mode_enums%=%\n" i item_list[i+1] to:JobInfoFile
					)
				)
				
				if rendererID == "amaretto" AND SMTDSettings.ExportAdvancedRenderInfoAmaretto then
				(
					propList = #(

						--MAIN CONTROLS > OPTIONS:
						#("ShowRenderInIV","Amaretto:ShowRenderInIV","Amaretto:ShowRenderInIV"),
						#("GrayOutVFB","Amaretto:GrayOutVFB","Amaretto:GrayOutVFB"),
						#("MultiThreading","Amaretto:MultiThreading","Amaretto:MultiThreading"),

						--GENERAL RENDERING PARAMETERS
						#("BucketWidth","Amaretto:BucketWidth","Amaretto:BucketWidth"),
						#("BucketHeight","Amaretto:BucketHeight","Amaretto:BucketHeight"),

						--SHADING,HIDING, INTERPOLATION
						#("ForceDoubleSided","Amaretto:ForceDoubleSided","Amaretto:ForceDoubleSided"),
						#("ForceCatmullClarkSDS","Amaretto:ForceCatmullClarkSDS","Amaretto:ForceCatmullClarkSDS"),
						#("dice_binary","dice:binary","dice:binary"),
						#("shading_rate","shadingquality","shadingquality"),
						#("hider","hider","hider"), --ENUM?

						--GEOMETRY EXPORT (ENUM!)
--						#("GeometryExport","Amaretto:GeometryExport","Amaretto:GeometryExport"),

						--ANTI-ALIASING
						#("SpatialQualityX","Amaretto:SpatialQualityX","Amaretto:SpatialQualityX"),
						#("SpatialQualityY","Amaretto:SpatialQualityY","Amaretto:SpatialQualityY"),

						--GLOBAL OVERRIDES
						#("DisableShadows","Amaretto:DisableShadows","Amaretto:DisableShadows"),
						#("DisableLights","Amaretto:DisableLights","Amaretto:DisableLights"),
						#("DontExportSurfaceShaders","Amaretto:DontExportSurfaceShaders","Amaretto:DontExportSurfaceShaders"),
						#("DontExportDisplacementShaders","Amaretto:DontExportDisplacementShaders","Amaretto:DontExportDisplacementShaders"),
						#("DontExportVolumeShaders","Amaretto:DontExportVolumeShaders","Amaretto:DontExportVolumeShaders"),
						#("displace_maxradius","displace:maxradius","displace:maxradius"),
						#("AddGlobalShader","Amaretto:AddGlobalShader","Amaretto:AddGlobalShader"),
						#("GlobalShaderType","Amaretto:GlobalShaderType","Amaretto:GlobalShaderType"), --ENUM?

						--PREVIEW MODE
						#("PreviewMode","Amaretto:PreviewMode","Amaretto:PreviewMode"),
						#("preview","preview","preview"),
						#("preview_temporalquality","preview:temporalquality","preview:temporalquality"),
						#("preview_dofquality","preview:dofquality","preview:dofquality"),
						#("preview_thincurves","preview:thincurves","preview:thincurves"),
						#("preview_thinpoints","preview:thinpoints","preview:thinpoints"),
						#("preview_limitpixelsize","preview:limitpixelsize","preview:limitpixelsize"),
						#("preview_limitdistance","preview:limitdistance","preview:limitdistance"),
						
						#("PreviewSpatialQuality","Amaretto:PreviewSpatialQuality","Amaretto:PreviewSpatialQuality"),
						#("PreviewBucketSize","Amaretto:PreviewBucketSize","Amaretto:PreviewBucketSize"),

						
						--PASSES
						#("FilterWidthX","Amaretto:FilterWidthX","Amaretto:FilterWidthX"),
						#("FilterWidthY","Amaretto:FilterWidthY","Amaretto:FilterWidthY"),
						#("filtertype","filtertype","filtertype"), --ENUMS!
						#("ShowPassesInIV","Amaretto:ShowPassesInIV","Amaretto:ShowPassesInIV"),
						#("gain","gain","gain"), 
						#("gamma","gamma","gamma"), 
						#("dither","dither","dither"), 
						#("ColorDepth","Amaretto:ColorDepth","Amaretto:ColorDepth"), --ENUMS!
						
						--LIGHTS AND SHADOWS
						
						#("shadow_opacitythreshold","shadow:opacitythreshold","shadow:opacitythreshold"),
						#("ForceShadowMaps","Amaretto:ForceShadowMaps","Amaretto:ForceShadowMaps"),
						#("RenderShadowMapsMode","Amaretto:RenderShadowMapsMode","Amaretto:RenderShadowMapsMode"),
						#("ForceRaytracedShadows","Amaretto:ForceRaytracedShadows","Amaretto:ForceRaytracedShadows"),
						#("DefaultShadowType","Amaretto:DefaultShadowType","Amaretto:DefaultShadowType"),
						#("UseGlobalShadowMaps","Amaretto:UseGlobalShadowMaps","Amaretto:UseGlobalShadowMaps"),
						#("GlobalShadowMapSize","Amaretto:GlobalShadowMapSize","Amaretto:GlobalShadowMapSize"),

						#("ShadowMapType","Amaretto:ShadowMapType","Amaretto:ShadowMapType"),
						#("GlobalShadowMapSamples","Amaretto:GlobalShadowMapSamples","Amaretto:GlobalShadowMapSamples"),
						#("GlobalShadowMapBlur","Amaretto:GlobalShadowMapBlur","Amaretto:GlobalShadowMapBlur"),
						#("GlobalShadowMapBias","Amaretto:GlobalShadowMapBias","Amaretto:GlobalShadowMapBias"),

						#("UseRaytracedShadowGlobals","Amaretto:UseRaytracedShadowGlobals","Amaretto:UseRaytracedShadowGlobals"),
						#("GlobalRaytracedShadowSpread","Amaretto:GlobalRaytracedShadowSpread","Amaretto:GlobalRaytracedShadowSpread"),
						#("GlobalRaytracedShadowBias","Amaretto:GlobalRaytracedShadowBias","Amaretto:GlobalRaytracedShadowBias"),
						#("GlobalRaytracedShadowQuality","Amaretto:GlobalRaytracedShadowQuality","Amaretto:GlobalRaytracedShadowQuality"),
						#("EnvLight_Enable","Amaretto:EnvLight:Enable","Amaretto:EnvLight:Enable"),
						#("EnvLight_Intensity","Amaretto:EnvLight:Intensity","Amaretto:EnvLight:Intensity"),
						#("EnvLight_Color","Amaretto:EnvLight:Color","Amaretto:EnvLight:Color"),
						#("EnvLight_NonSpecular","Amaretto:EnvLight:NonSpecular","Amaretto:EnvLight:NonSpecular"),
						#("EnvLight_EnvName","Amaretto:EnvLight:EnvName","Amaretto:EnvLight:EnvName"),
						#("EnvLight_EnvSpace","Amaretto:EnvLight:EnvSpace","Amaretto:EnvLight:EnvSpace"),
						#("EnvLight_Radius","Amaretto:EnvLight:Radius","Amaretto:EnvLight:Radius"),
						#("EnvLight_Blur","Amaretto:EnvLight:Blur","Amaretto:EnvLight:Blur"),
						
						--DOF	
						#("EnableDOF","Amaretto:EnableDOF","Amaretto:EnableDOF"),
						#("OverrideDOF","Amaretto:OverrideDOF","Amaretto:OverrideDOF"),
						#("dofquality","dofquality","dofquality"),
						#("FStop","Amaretto:FStop","Amaretto:FStop"),
						#("FocalLength","Amaretto:FocalLength","Amaretto:FocalLength"),
						#("FocalDistance","Amaretto:FocalDistance","Amaretto:FocalDistance"),

						--MBLUR	
						#("EnableMotionBlur","Amaretto:EnableMotionBlur","Amaretto:EnableMotionBlur"),
						#("EnableVertexMotionBlur","Amaretto:EnableVertexMotionBlur","Amaretto:EnableVertexMotionBlur"),
						#("temporalquality","temporalquality","temporalquality"),
						#("MotionBlurSegments","Amaretto:MotionBlurSegments","Amaretto:MotionBlurSegments"),
						#("ShutterType","Amaretto:ShutterType","Amaretto:ShutterType"),
						#("ShutterAngle","Amaretto:ShutterAngle","Amaretto:ShutterAngle"),
						#("dice_motionfactor","dice:motionfactor","dice:motionfactor"),
						
					-- STEREO
						#("EnableStereo","Amaretto:EnableStereo","Amaretto:EnableStereo"),
						#("RenderShadingCamera","Amaretto:RenderShadingCamera","Amaretto:RenderShadingCamera"),
						#("ShadingCamera","Amaretto:ShadingCamera","Amaretto:ShadingCamera"),

						--GI
						#("EnableGI","Amaretto:EnableGI","Amaretto:EnableGI"),
						#("Indirect_Samples","Amaretto:Indirect:Samples","Amaretto:Indirect:Samples"),
						#("Indirect_Bias","Amaretto:Indirect:Bias","Amaretto:Indirect:Bias"),
						#("Indirect_Adaptive","Amaretto:Indirect:Adaptive","Amaretto:Indirect:Adaptive"),
						#("indirect_minsamples","indirect:minsamples","indirect:minsamples"),
						#("indirect_maxpixeldist","indirect:maxpixeldist","indirect:maxpixeldist"),
						#("indirect_maxerror","indirect:maxerror","indirect:maxerror"),

						-- SUBSURFACE SCATTERING
						#("SSS_FOVMultiplier","Amaretto:SSS:FOVMultiplier","Amaretto:SSS:FOVMultiplier"),
						#("SSS_Resolution","Amaretto:SSS:Resolution","Amaretto:SSS:Resolution"),
						#("SSS_Disable","Amaretto:SSS:Disable","Amaretto:SSS:Disable"),
						
						--AMBIENT OCCULUSION
						#("occlusion_minsamples","occlusion:minsamples","occlusion:minsamples"),
						#("occlusion_maxpixeldist","occlusion:maxpixeldist","occlusion:maxpixeldist"),
						#("occlusion_maxerror","occlusion:maxerror","occlusion:maxerror"),
						
						#("GlobalShaderAmbientOcclusionSamples","Amaretto:GlobalShader:AmbientOcclusionSamples","Amaretto:GlobalShader:AmbientOcclusionSamples"),
						#("GlobalShaderAmbientOcclusionBias","Amaretto:GlobalShader:AmbientOcclusionBias","Amaretto:GlobalShader:AmbientOcclusionBias"),
						#("GlobalShaderAmbientOcclusionAdaptive","Amaretto:GlobalShader:AmbientOcclusionBias","Amaretto:GlobalShader:AmbientOcclusionBias"),
						
						#("ray_maxdepth","ray:maxdepth","ray:maxdepth"),
						#("ray_maxdepthcolor","ray:maxdepthcolor","ray:maxdepthcolor"),
						#("ray_displace","ray:displace","ray:displace"),
						#("ray_opaqueshadows","ray:opaqueshadows","ray:opaqueshadows"),						
						
					--PERFORMANCE						
						#("limits_gridsize","limits:gridsize","limits:gridsize"),
						#("limits_texturememory","limits:texturememory","limits:texturememory"),
						#("limits_texturefiles","limits:texturefiles","limits:texturefiles"),
						#("limits_trimcurvememory","limits:trimcurvememory","limits:trimcurvememory"),
						#("trimcurve_quality","trimcurve:quality","trimcurve:quality"),
						#("limits_opacitythreshold","limits:opacitythreshold","limits:opacitythreshold"),
						#("limits_transparentgrids","limits:transparentgrids","limits:transparentgrids"),
						#("dice_tracedisplacements","dice:tracedisplacements","dice:tracedisplacements")
					)
					
					for p in propList do
					(
						try
						(
							local theValue = (Amaretto.GetProperty p[2])
							if theValue != undefined do format "amaretto_%=%\n" p[1] theValue to:JobInfoFile
						)catch()
					)
					
					--CUSTOM ENUMS
					try(format "%_%=%\n" rendererID "bucketorder_enums" (Amaretto.GetProperty "bucketorder") to:JobInfoFile)catch()
					for i = 0 to 2 do 
						format "amaretto_bucketorder_enums%=%\n" i #("horizontal","vertical","spiral")[i+1] to:JobInfoFile
					
				)
				
				--KRAKATOA EXPORT
				
				if rendererID == "krakatoa" AND SMTDSettings.ExportAdvancedRenderInfoKrakatoa then
				(
					--Krakatoa - All Versions
					try(format "%_Version=%\n" rendererID FranticParticles.version to:JobInfoFile)catch()
					--Krakatoa 1.0.x and 1.1.x versions:
					if execute (substring FranticParticles.version 1 3) < 1.5 then
					(
						theArray = #("Volumetric Density","Additive Density","Constant Alpha")
						try(format "%_%=%\n" rendererID "Density_DensityMethod" (FranticParticles.GetProperty "Density:DensityMethod") to:JobInfoFile)catch()
						for i = 0 to theArray.count-1 do
							format "%_%%=%\n" rendererID "Density_DensityMethod" i theArray[i+1] to:JobInfoFile
						
						theArray = #("No Scaling", "Material Opacity")
						try(format "%_%=%\n" rendererID "DensityScalingSource" (FranticParticles.GetProperty "DensityScalingSource") to:JobInfoFile)catch()
						for i = 0 to theArray.count-1 do
							format "%_%%=%\n" rendererID "DensityScalingSource" i theArray[i+1] to:JobInfoFile
						
						theArray = #("Volumetric Density","Additive Density","Constant Alpha")
						try(format "%_%=%\n" rendererID "Lighting_Density_DensityMethod" (FranticParticles.GetProperty "Lighting:Density:DensityMethod") to:JobInfoFile)catch()
						for i = 0 to theArray.count-1 do
							format "%_%%=%\n" rendererID "Lighting_Density_DensityMethod" i theArray[i+1] to:JobInfoFile
						
						try(format "%_%=%\n" rendererID "UseGlobalColorOverride" (FranticParticles.GetProperty "UseGlobalColorOverride") to:JobInfoFile)catch()

						theArray = #("Choose Color", "Medit1", "No Material","Blended Z Depth","Blended Camera Distance")
						try(format "%_%=%\n" rendererID "ParticleColorSource"  (FranticParticles.GetProperty "ParticleColorSource") to:JobInfoFile)catch()
						for i = 0 to theArray.count-1 do
							format "%_%%=%\n" rendererID "ParticleColorSource" i theArray[i+1] to:JobInfoFile

						try(format "%_%=%\n" rendererID "ChosenColor" (FranticParticles.GetProperty "ChosenColor") to:JobInfoFile)catch()
						
						try(format "%_%=%\n" rendererID "UseLighting" (FranticParticles.GetProperty "UseLighting") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "Lighting_Specular_Enabled" (FranticParticles.GetProperty "Lighting:Specular:Enabled") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "Lighting_Specular_Glossiness" (FranticParticles.GetProperty "Lighting:Specular:Glossiness") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "Lighting_Specular_Level" (FranticParticles.GetProperty "Lighting:Specular:Level") to:JobInfoFile)catch()
						
						try(format "%_%=%\n" rendererID "RenderParticleFlowGeometry" (FranticParticles.GetProperty "RenderParticleFlowGeometry") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderParticleFlowBBox" (FranticParticles.GetProperty "RenderParticleFlowBBox") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderParticleFlowPhantom" (FranticParticles.GetProperty "RenderParticleFlowPhantom") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderParticleObjectExt" (FranticParticles.GetProperty "RenderParticleObjectExt") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "RenderMaxParticles" (FranticParticles.GetProperty "RenderMaxParticles") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderThinkingParticles" (FranticParticles.GetProperty "RenderThinkingParticles") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderGeometryVertices" (FranticParticles.GetProperty "RenderGeometryVertices") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderKrakatoaLoaders" (FranticParticles.GetProperty "RenderKrakatoaLoaders") to:JobInfoFile)catch()
					)
					else --Krakatoa 1.5.x+
					(
						try(format "%_%=%\n" rendererID "IgnoreSceneLights" (FranticParticles.GetProperty "IgnoreSceneLights") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "UseEnvironmentReflections" (FranticParticles.GetProperty "UseEnvironmentReflections") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "UseFilterColor" (FranticParticles.GetProperty "UseFilterColor") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "UseEmissionColor" (FranticParticles.GetProperty "UseEmissionColor") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "AdditiveMode" (FranticParticles.GetProperty "AdditiveMode") to:JobInfoFile)catch()
						
						try(format "%_%=%\n" rendererID "ColorOverride_Enabled" (FranticParticles.GetProperty "ColorOverride:Enabled") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "ColorOverride_Color" (FranticParticles.GetProperty "ColorOverride:Color") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "ColorOverride_BlendAmount" (FranticParticles.GetProperty "ColorOverride:BlendAmount") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "AbsorptionOverride_Enabled" (FranticParticles.GetProperty "AbsorptionOverride:Enabled") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "AbsorptionOverride_Color" (FranticParticles.GetProperty "AbsorptionOverride:Color") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "AbsorptionOverride_BlendAmount" (FranticParticles.GetProperty "AbsorptionOverride:BlendAmount") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "EmissionOverride_Enabled" (FranticParticles.GetProperty "EmissionOverride:Enabled") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "EmissionOverride_Color" (FranticParticles.GetProperty "EmissionOverride:Color") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "EmissionOverride_BlendAmount" (FranticParticles.GetProperty "EmissionOverride:BlendAmount") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "DensityOverride_Enabled" (FranticParticles.GetProperty "DensityOverride:Enabled") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "DensityOverride_Color" (FranticParticles.GetProperty "DensityOverride:Color") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "DensityOverride_BlendAmount" (FranticParticles.GetProperty "DensityOverride:BlendAmount") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "VoxelSize" (FranticParticles.GetProperty "VoxelSize") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "VoxelFilterRadius" (FranticParticles.GetProperty "VoxelFilterRadius") to:JobInfoFile)catch()
						
						try(format "%_%=%\n" rendererID "PhaseEccentricity" (FranticParticles.GetProperty "PhaseEccentricity") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "IgnoreMissingParticles" (FranticParticles.GetProperty "IgnoreMissingParticles") to:JobInfoFile)catch()

						theArray = #("Particle Rendering","Voxel Rendering")
						try(format "%_%=%\n" rendererID "RenderingMethod" (FranticParticles.GetProperty "RenderingMethod") to:JobInfoFile)catch()
						for i = 0 to theArray.count-1 do
							format "%_%%=%\n" rendererID "RenderingMethod" i theArray[i+1] to:JobInfoFile

						theArray = #("Isotropic","Phong Surface","Henyey-Greenstein","Schlick","Kajiya-Kay Hair") 
						try(format "%_%=%\n" rendererID "PhaseFunction" (FranticParticles.GetProperty "PhaseFunction") to:JobInfoFile)catch()
						for i = 0 to theArray.count-1 do
							format "%_%%=%\n" rendererID "PhaseFunction" i theArray[i+1] to:JobInfoFile
						
						try(format "%_%=%\n" rendererID "RenderParticleFlowGeometry" (FranticParticles.GetProperty "RenderParticleFlowGeometry") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderParticleFlowBBox" (FranticParticles.GetProperty "RenderParticleFlowBBox") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderParticleFlowPhantom" (FranticParticles.GetProperty "RenderParticleFlowPhantom") to:JobInfoFile)catch()
						
						try(format "%_%=%\n" rendererID "RenderFumeFX" (FranticParticles.GetProperty "RenderFumeFX") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderMaxParticles" (FranticParticles.GetProperty "RenderMaxParticles") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderThinkingParticles" (FranticParticles.GetProperty "RenderThinkingParticles") to:JobInfoFile)catch()
						
						try(format "%_%=%\n" rendererID "RenderGeometryVertices" (FranticParticles.GetProperty "RenderGeometryVertices") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderKrakatoaLoaders" (FranticParticles.GetProperty "RenderKrakatoaLoaders") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "RenderGeometryVolumes" (FranticParticles.GetProperty "RenderGeometryVolumes") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "GlobalParticlePercentage" (FranticParticles.GetProperty "GlobalParticlePercentage") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "Lighting_Specular_SpecularPower" (FranticParticles.GetProperty "Lighting:Specular:SpecularPower") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "Lighting_Specular_Level" (FranticParticles.GetProperty "Lighting:Specular:Level") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "Channel_Allocate_SpecularPower" (FranticParticles.GetProperty "Channel:Allocate:SpecularPower") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "Channel_Allocate_SpecularLevel" (FranticParticles.GetProperty "Channel:Allocate:SpecularLevel") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "Channel_Allocate_PhaseEccentricity" (FranticParticles.GetProperty "Channel:Allocate:PhaseEccentricity") to:JobInfoFile)catch()

						try(format "%_%=%\n" rendererID "Matte_RayDivisions" (FranticParticles.GetProperty "Matte:RayDivisions") to:JobInfoFile)catch()
						try(format "%_%=%\n" rendererID "Matte_SaveMultipleLayers" (FranticParticles.GetProperty "Matte:SaveMultipleLayers") to:JobInfoFile)catch()
					)
					
				
					try(format "%_%=%\n" rendererID "Density_LinkLightingAndRenderingDensity" (FranticParticles.GetProperty "Density:LinkLightingAndRenderingDensity") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "Density_DensityPerParticle" (FranticParticles.GetProperty "Density:DensityPerParticle") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "Density_DensityExponent" (FranticParticles.GetProperty "Density:DensityExponent") to:JobInfoFile)catch()

					try(format "%_%=%\n" rendererID "Lighting_Density_DensityPerParticle" (FranticParticles.GetProperty "Lighting:Density:DensityPerParticle") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "Lighting_Density_DensityExponent" (FranticParticles.GetProperty "Lighting:Density:DensityExponent") to:JobInfoFile)catch()

					try(format "%_%=%\n" rendererID "UseDepthMaps" (FranticParticles.GetProperty "UseDepthMaps") to:JobInfoFile)catch()
					
					theArray = #("Nearest Neighbor","Bilinear","Bicubic")
					try(format "%_%=%\n" rendererID "DrawPointFilter" (FranticParticles.GetProperty "DrawPointFilter") to:JobInfoFile)catch()
					for i = 0 to theArray.count-1 do
						format "%_%%=%\n" rendererID "DrawPointFilter" i theArray[i+1] to:JobInfoFile
					
					theArray = #("Nearest Neighbor","Bilinear","Bicubic")
					try(format "%_%=%\n" rendererID "AttenuationLookupFilter" (FranticParticles.GetProperty "AttenuationLookupFilter") to:JobInfoFile)catch()
					for i = 0 to theArray.count-1 do
						format "%_%%=%\n" rendererID "AttenuationLookupFilter" i theArray[i+1] to:JobInfoFile

					try(format "%_%=%\n" rendererID "EnableMotionBlur" (FranticParticles.GetProperty "EnableMotionBlur") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "EnableDepthOfField" (FranticParticles.GetProperty "EnableDepthOfField") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "EnableAttenuationMapSaving" (FranticParticles.GetProperty "EnableAttenuationMapSaving") to:JobInfoFile)catch()

					try(format "%_%=%\n" rendererID "MotionBlurSegments" (FranticParticles.GetProperty "MotionBlurSegments") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "JitteredMotionBlur" (FranticParticles.GetProperty "JitteredMotionBlur") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "DepthOfFieldSampleRate" (FranticParticles.GetProperty "DepthOfFieldSampleRate") to:JobInfoFile)catch()
					
					try(format "%_%=%\n" rendererID "BackgroundColor" (FranticParticles.GetProperty "BackgroundColor") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "UseEnvironmentColor" (FranticParticles.GetProperty "UseEnvironmentColor") to:JobInfoFile)catch()

					try(format "%_%=%\n" rendererID "PostDivideByAlpha" (FranticParticles.GetProperty "PostDivideByAlpha") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "ShutterAngleInDegrees" (FranticParticles.GetProperty "ShutterAngleInDegrees") to:JobInfoFile)catch()
					try(format "%_%=%\n" rendererID "ShutterBias" (FranticParticles.GetProperty "ShutterBias") to:JobInfoFile)catch()

					
					try(format "%_%=%\n" rendererID "Matte_UseMatteObjects" (FranticParticles.GetProperty "Matte:UseMatteObjects") to:JobInfoFile)catch()
				)
				
				
				--MENTAL RAY PROPERTIES
				
				if rendererID == "mentalray" AND SMTDSettings.ExportAdvancedRenderInfoMentalRay then
				(
				
					--ESERNA modified: se ha modificado para que cambie la ruta del final gather de z a lbdata001 si está en el dominio de LBOX
					for p in getPropNames renderers.current do
					(
						_value = (getProperty renderers.current p)
						
						if isLPMjob and p == #FinalGatherFilename then
						(
							--obtiene el  nombre del dominio de red en el que esta la maquina
							_domainName = (dotnetClass "System.Windows.Forms.SystemInformation").UserDomainName
							
							if _domainName == "LBOX" or (findstring _domainName "summus" != undefined) then --si es un trabajo de LPM y el dominio es LBOX
							(
								_unit = (lb.project.getCurrentFileProject()).getRoot()
								_netUnit = (lb.project.getCurrentFileProject()).getNetworkRoot()
								
								_localPath = LPM_Fun.getIni "Settings" "localPath" string _unit --"z:\\"
								_networkPath = LPM_Fun.getIni "Settings" "networkPath" string _netUnit --"\\\\lbdata001\\z\\"
								_value = substituteString (tolower _value) _localPath _networkPath
							)						
						)
						else if isPMjob and p == #FinalGatherFilename then
						(
							print "TO DO: Redirect final gather output to network"
						)
							
						try(format "%_%=%\n" rendererID (p as string) _value to:JobInfoFile)catch()
					)
					--ESERNA-------------------------------------------------------------------------------------------------------------------------------
					--lo original era
					--for p in getPropNames renderers.current do
					--	try(format "%_%=%\n" rendererID (p as string) (getProperty renderers.current p) to:JobInfoFile)catch()
				
					local samples_list = #("1/64","1/16", "1/4", "1", "4", "16", "64", "256", "1024" )
					format "mentalray_MinimumSamples_enums=%\n"  samples_list[renderers.current.MinimumSamples+4] to:JobInfoFile
					for i = 0 to samples_list.count-1 do 
						format "mentalray_MinimumSamples_enums%=%\n" i samples_list[i+1] to:JobInfoFile
						
					format "mentalray_MaximumSamples_enums=%\n"  samples_list[renderers.current.MaximumSamples+4] to:JobInfoFile
					for i = 0 to samples_list.count-1 do 
						format "mentalray_MaximumSamples_enums%=%\n" i samples_list[i+1] to:JobInfoFile
					
					local filter_list = #("Box", "Gauss", "Triangle", "Mitchell", "Lanczos")
					format "mentalray_filter_enums=%\n"  filter_list[renderers.current.filter+1] to:JobInfoFile
					for i = 0 to 4 do 
						format "mentalray_filter_enums%=%\n" i filter_list[i+1] to:JobInfoFile
						
					local order_list = #("Hilbert (best)", "Spiral", "Left to right", "Right to left", "Top-down", "Bottom-up")
					format "mentalray_TaskOrder_enums=%\n"  order_list[renderers.current.filter+1] to:JobInfoFile
					for i = 0 to 5 do 
						format "mentalray_TaskOrder_enums%=%\n" i order_list[i+1] to:JobInfoFile				

					local order_list = for i = 1 to 15 collect ((i*i) as string)
					format "mentalray_RapidCollectRate_enums=%\n"  order_list[renderers.current.RapidCollectRate] to:JobInfoFile
					for i = 0 to order_list.count-1 do 
						format "mentalray_RapidCollectRate_enums%=%\n" i order_list[i+1] to:JobInfoFile				
				)			
				
				if rendererID == "finalrender" AND SMTDSettings.ExportAdvancedRenderInfoFinalRender then
				(
					for p in getPropNames renderers.current do
						try(format "%_%=%\n" rendererID (p as string) (getProperty renderers.current p) to:JobInfoFile)catch()
					
					local filter_list = #("Area","Blackman","Blend","Catmull-Rom","Cook Variable","Cubic","Plate Match/MAX R2","Mitchell-Netravali","Quadratic", "Sharp Quadratic", "Soften", "VRayBoxFilter","VRayLanczosFilter","VRaySincFilter","VRayTriangleFilter","Video")
					for i = 0 to filter_list.count-1 do 
						format "finalrender_aaFilterName%=%\n" i filter_list[i+1] to:JobInfoFile
					
					local size_list = #("16","32","64","128","256")
					format "finalrender_bucketSize_enums=%\n"  size_list[renderers.current.bucketSize+1] to:JobInfoFile
					for i = 0 to size_list.count-1 do 
						format "finalrender_bucketSize_enums%=%\n" i size_list[i+1] to:JobInfoFile
						
					local order_list = #("Top to Bottom","Left to Right","Spiral","Random","Hilbert")
					format "finalrender_bucketOrder_enums=%\n"  order_list[renderers.current.bucketOrder+1] to:JobInfoFile
					for i = 0 to order_list.count-1 do 
						format "finalrender_bucketOrder_enums%=%\n" i order_list[i+1] to:JobInfoFile
					
					local clear_list = #("Nothing","Clear Buffer","Clear Grid","Darken")
					format "finalrender_clearOptions_enums=%\n"  clear_list[renderers.current.clearOptions+1] to:JobInfoFile
					for i = 0 to clear_list.count-1 do 
						format "finalrender_clearOptions_enums%=%\n" i clear_list[i+1] to:JobInfoFile
					
					local storage_list = #("int (8 bpc)","int (16 bpc)","float (32 bpc)")
					format "finalrender_storage_enums=%\n"  storage_list[renderers.current.storage+1] to:JobInfoFile
					for i = 0 to storage_list.count-1 do 
						format "finalrender_storage_enums%=%\n" i storage_list[i+1] to:JobInfoFile
					
					local mode_list = #("Intensity","Intensity Centered","Vector Local Space","Vector Camera Space","Vector World Space")
					format "finalrender_mtdMode_enums=%\n"  mode_list[renderers.current.mtdMode+1] to:JobInfoFile
					for i = 0 to mode_list.count-1 do 
						format "finalrender_mtdMode_enums%=%\n" i mode_list[i+1] to:JobInfoFile
						
					local lens_list = #("Circular","Rhombic","Hexagon","Octagon","Triangle","Pentagon","Heptagon","Nanogon")
					format "finalrender_lensType_enums=%\n"  lens_list[renderers.current.lensType+1] to:JobInfoFile
					for i = 0 to lens_list.count-1 do 
						format "finalrender_lensType_enums%=%\n" i lens_list[i+1] to:JobInfoFile
					
					local type_list = #("Linear","Exponential","HSV Exponential","Gamma")
					format "finalrender_colorMapType_enums=%\n"  type_list[renderers.current.colorMapType+1] to:JobInfoFile
					for i = 0 to type_list.count-1 do 
						format "finalrender_colorMapType_enums%=%\n" i type_list[i+1] to:JobInfoFile
					
					local sampling_list = #("Absolute","Relative","Automatic")
					format "finalrender_geomSmpMode_enums=%\n"  sampling_list[renderers.current.geomSmpMode+1] to:JobInfoFile
					for i = 0 to sampling_list.count-1 do 
						format "finalrender_geomSmpMode_enums%=%\n" i sampling_list[i+1] to:JobInfoFile
					
					local skylight_list = #("Simple Sky","Physical Sky")
					format "finalrender_skyType_enums=%\n"  skylight_list[renderers.current.skyType+1] to:JobInfoFile
					for i = 0 to skylight_list.count-1 do 
						format "finalrender_skyType_enums%=%\n" i skylight_list[i+1] to:JobInfoFile
				)
				
				
				if rendererID == "vray" AND SMTDSettings.ExportAdvancedRenderInfoVRay then
				(
					for p in getPropNames renderers.current do
						try(format "%_%=%\n" rendererID (p as string) (getProperty renderers.current p) to:JobInfoFile)catch()
					
					local enum_list = #("Fixed Rate","Adaptive QMC", "Adaptive Subdivision")
					format "vray_imageSampler_type_enums=%\n"  enum_list[renderers.current.imageSampler_type+1] to:JobInfoFile
					for i = 0 to enum_list.count-1 do 
						format "vray_imageSampler_type_enums%=%\n" i enum_list[i+1] to:JobInfoFile
						
					local enum_list = #("Irradiance Map","Photon Map", "Quasi-Monte Carlo","Light Cache")
					format "vray_gi_primary_type_enums=%\n"  enum_list[renderers.current.gi_primary_type+1] to:JobInfoFile
					for i = 0 to enum_list.count-1 do 
						format "vray_gi_primary_type_enums%=%\n" i enum_list[i+1] to:JobInfoFile

					local enum_list = #("None","Photon Map", "Quasi-Monte Carlo","Light Cache")
					format "vray_gi_secondary_type_enums=%\n"  enum_list[renderers.current.gi_secondary_type+1] to:JobInfoFile
					for i = 0 to enum_list.count-1 do 
						format "vray_gi_secondary_type_enums%=%\n" i enum_list[i+1] to:JobInfoFile

					local enum_list = #("Weighted Average (good/robust)","Least squares fit (good/smooth)", "Delaunay triangulation (good/exact)","Least squares w/ Voronoi weights")
					format "vray_adv_irradmap_interpolationType_enums=%\n"  enum_list[renderers.current.adv_irradmap_interpolationType+1] to:JobInfoFile
					for i = 0 to enum_list.count-1 do 
						format "vray_adv_irradmap_interpolationType_enums%=%\n" i enum_list[i+1] to:JobInfoFile
						
					local enum_list = #("Quad-balanced (good)","Nearest (draft)", "Overlapping (very good/fast)","Density-based (best)")
					format "vray_adv_irradmap_lookupType_enums=%\n"  enum_list[renderers.current.adv_irradmap_lookupType+1] to:JobInfoFile
					for i = 0 to enum_list.count-1 do 
						format "vray_adv_irradmap_lookupType_enums%=%\n" i enum_list[i+1] to:JobInfoFile	

					--IRRADIANCE MAP MODE REQUIRES SPECIAL HANDLING BOTH HERE AND WHEN CUSTOMIZING!
					--ONLY VRAY ADVANCED VERSIONS 1.4 and 1.5 ARE CURRENTLY HANDLED EXPLICITLY.
					--IN ANY OTHER VRAY ADVANCED VERSIONS, THIS PARAMETER WILL NOT BE CUSTOMIZABLE

					--SPECIAL CASE HANDLING FOR VRAY ADVANCED 1.4 - BUCKET MODE IS FIRST ENUM!
					if matchPattern ((classof renderers.current) as string) pattern:"*_1_4*" do
					(
						local enum_list = #("Bucket Mode","Single Frame", "Multiframe Incremental","From File","Add to Current Map","Incremental Add to Current Map")
						format "vray_adv_irradmap_mode_enums=%\n"  enum_list[renderers.current.adv_irradmap_mode+1] to:JobInfoFile
						for i = 0 to enum_list.count-1 do 
							format "vray_adv_irradmap_mode_enums%=%\n" i enum_list[i+1] to:JobInfoFile		
					)
					--SPECIAL CASE HANDLING FOR VRAY ADVANCED 1.5 - BUCKET MODE IS LAST ENUM!
					if matchPattern ((classof renderers.current) as string) pattern:"*_1_5*" do
					(
						local enum_list = #("Single Frame", "Multiframe Incremental","From File","Add to Current Map","Incremental Add to Current Map","Bucket Mode")
						format "vray_adv_irradmap_mode_enums=%\n"  enum_list[renderers.current.adv_irradmap_mode+1] to:JobInfoFile
						for i = 0 to enum_list.count-1 do 
							format "vray_adv_irradmap_mode_enums%=%\n" i enum_list[i+1] to:JobInfoFile
					)
					--SPECIAL CASE HANDLING FOR VRAY ADVANCED 1.6 - NEW ENUM FOR DEFAULT LIGHTS
					if matchPattern ((classof renderers.current) as string) pattern:"*_1_60*" then
					(
						if (classof( renderers.current.options_defaultLights ) as string) == "Integer" do
						(
							local enum_list = #("Off","On", "Off with GI")
							format "vray_options_defaultLights_enums=%\n"  enum_list[renderers.current.options_defaultLights+1] to:JobInfoFile
							for i = 0 to enum_list.count-1 do 
								format "vray_options_defaultLights_enums%=%\n" i enum_list[i+1] to:JobInfoFile
						)
					)
					
					local enum_list = #("Top->Bottom","Left->Right", "Checker","Spiral","Triangulation","Hilbert Curve")
					format "vray_system_region_sequence_enums=%\n"  enum_list[renderers.current.system_region_sequence+1] to:JobInfoFile
					for i = 0 to enum_list.count-1 do 
						format "vray_system_region_sequence_enums%=%\n" i enum_list[i+1] to:JobInfoFile						
						
					local enum_list = #("Left", "Center", "Right")
					format "vray_system_frameStamp_justify_enums=%\n"  enum_list[renderers.current.system_frameStamp_justify+1] to:JobInfoFile
					for i = 0 to enum_list.count-1 do 
						format "vray_system_frameStamp_justify_enums%=%\n" i enum_list[i+1] to:JobInfoFile								
						
				)
				
				if rendererID == "maxwell" AND SMTDSettings.ExportAdvancedRenderInfoMaxwell then
				(
					for p in getPropNames renderers.current do
					(
						try
						(
							p = (p as string)
							prop = (getProperty renderers.current p)
							
							-- Special case handling for string values - we need to strip off the leading #
							if p == "gsMXCLFlags" or p == "gsMXSOutputPath" or p == "gsMXIOutputPath" or p == "slApertureImagePath" or p == "slObscureImagePath" then
							(
								prop = (prop as string)
								if prop.count > 0 and prop[1] == "#" then
									prop = replace prop 1 1 ""
							)
							format "%_%=%\n" rendererID p prop to:JobInfoFile
						)
						catch ()
					)
					
					if renderers.current.version >= 20 then
					(
						/*
						local enum_list = #("Per Object","On", "Off")
						format "maxwell_gsMotionBlur_enums=%\n"  enum_list[renderers.current.gsMotionBlur+1] to:JobInfoFile
						for i = 0 to enum_list.count-1 do 
							format "maxwell_gsMotionBlur_enums%=%\n" i enum_list[i+1] to:JobInfoFile						
						*/
						
						local enum_list = #("sRGB","Adobe RGB 98", "Apple RGB / SGI","PAL / SECAM","NTSC 1953","NTSC 1979","Wide Gamut RGB","ProPhoto RGB (ROMM)","ECI RGB","CIE 1931","Bruce RGB","ColorMatch RGB","Best RGB","Don RGB 4")
						format "maxwell_gsColorSpace_enums=%\n"  enum_list[renderers.current.gsColorSpace+1] to:JobInfoFile
						for i = 0 to enum_list.count-1 do 
							format "maxwell_gsColorSpace_enums%=%\n" i enum_list[i+1] to:JobInfoFile						
						
						/*
						try
						(
							local enum_list = #("8","16", "32")
							format "maxwell_gsDepth_enums=%\n"  renderers.current.gsDepth to:JobInfoFile
							for i = 0 to enum_list.count-1 do 
								format "maxwell_gsDepth_enums%=%\n" i enum_list[i+1] to:JobInfoFile	
						)
						catch ()
						*/
						
						local enum_list = #("Diffuse+Reflection","Diffuse", "Reflection")
						format "maxwell_gsChannelRenderType_enums=%\n"  enum_list[renderers.current.gsChannelRenderType+1] to:JobInfoFile
						for i = 0 to enum_list.count-1 do 
							format "maxwell_gsChannelRenderType_enums%=%\n" i enum_list[i+1] to:JobInfoFile
					)
				)
				
				Close JobInfoFile
				true
			)
			else
				false
		),
		
		fn saveSettingsStructToMSFile theFileName =
		(
			theProps = getPropNames SMTDSettings 
			theFile = createFile theFileName
			options.printAllElements = true
			for p in theProps do
			(
				theVal = (getProperty SMTDSettings p)
				case classof theVal of
				(
					string: (
						theVal = "\"" + theVal + "\""
						newStr = ""
						for i = 1 to theVal.count do 
							newStr += (if theVal[i] == "\\" then "\\\\" else theVal[i] )
						theVal = newStr
					)
					array: (
						theVal = SMTDFunctions.formatValue theVal
					)
				)
				
				format "SMTDSettings.% = %\n" (p as string) theVal to:theFile 
			)	
			close theFile
		),
		
		----------------------------------------------------------------------------------
		--almacena todos los settings actuales de deadline en el objeto pasado por parametro
		--necesita BATCHNODE que es el objeto donde almacenar la informacion
		--se tiene la opcion de guardar tambien las opciones que no se almacenan de una sesion a otra SAVENOTSTIKY
		----------------------------------------------------------------------------------
		fn saveSettingsToBatchNode batchNode saveNotStiky:false =
		(
			_success = true
			
			if lb.customAttributes.hasAttribute batchNode #LPMbatchInfo then --si el nodo tiene informacion de batch
			with printAllelements on (
				_propNames = getPropNames SMTDsettings --obtiene los nombres de las propiedades de Deadline
				
				for prop in _propNames do --recorre los nombres de las propiedades almacenandolo junto con su valor
				(					
					_value = getProperty SMTDsettings prop --obtiene el valor de la propiedad
					_valueToAdd = _value as string --valor que añadir al nodo de batch
					
					if (classof _value) == name then _valueToAdd = "#" + (_value as string) --se asegura de que los name tengan #
					if (classof _value) == string then _valueToAdd = "\"" + (_value as string) +  "\""--se asegura de que los string vayan entre comillas
					if _valueToAdd == "" then _valueToAdd = "\"\""
					_valueToAdd = substituteString _valueToAdd "\\" "\\\\"
					
					_executeValue = "setProperty SMTDsettings #" + (prop as string) + " (" + _valueToAdd + ")" --monta el execute para restaurar los valores desde la funcion loadSettingsFromBatchNode
					
					append batchNode.deadlineSettingsNames (prop as string) --añade el nombre de la propiedad
					append batchNode.deadlineSettingsValues _valueToAdd --añade el valor de la propiedad
					append batchNode.deadlineSettingsExecutes _executeValue --añade el execute de la propiedad
				)--for
			)
			else _success = false
			
			_success
		),
		
		fn formatValue theVal =
		(
			case classof theVal of
			(
				string: (
					newStr = ""
					for i = 1 to theVal.count do 
						newStr += (if theVal[i] == "\\" then "\\\\" else theVal[i] )
					theVal = newStr
				)
				array: (
					for i = 1 to theVal.count do
						theVal[i] = (SMTDFunctions.formatValue theVal[i])
				)
			)
			theVal
		),
		
		fn CreateImsqFile imsqFilename =
		(
			startFrame = case (rendTimeType) of
			(
				1: SMTDFunctions.GetSequenceString #(currentTime)
				2: SMTDFunctions.GetSequenceString ( SMTDFunctions.outOfOrderSequence (for t in animationRange.start to animationRange.start by 1 collect t) )
				3: SMTDFunctions.GetSequenceString ( SMTDFunctions.outOfOrderSequence (for t in rendStart to rendStart by 1 collect t) )
				4: 0
			)
			
			endFrame = case (rendTimeType) of
			(
				1: SMTDFunctions.GetSequenceString #(currentTime)
				2: SMTDFunctions.GetSequenceString ( SMTDFunctions.outOfOrderSequence (for t in animationRange.end to animationRange.end by 1 collect t) )
				3: SMTDFunctions.GetSequenceString ( SMTDFunctions.outOfOrderSequence (for t in rendEnd to rendEnd by 1 collect t) )
				4: 0
			)
			
			local imsqFile = CreateFile imsqFilename
			if (imsqFile != undefined) then
			(
				path = getFilenamePath RendOutputFilename
				filename = getFilenameFile RendOutputFilename
				extension = getFilenameType RendOutputFilename
						
				format "<ImageSequence Pattern=\"%%[####]%\" " path filename extension to:imsqFile
				format "First=\"%\" Last=\"%\" " startFrame endFrame to:imsqFile
				format "FrameRate=\"%/1\" />\n" frameRate to:imsqFile
								
				Close imsqFile
				true
			)
			else
				false
		),
		
		
		
		fn CreateImsqVbscript imsqVbscript imsqFilename =
		(
			local scriptFile = CreateFile imsqVbscript
			if (scriptFile != undefined) then
			(
				filename = getFilenameFile imsqFilename
				extension = getFilenameType imsqFilename
			
				copyPath = SMTDSettings.ImsqOutputPath + "\\" + filename + extension
				
				--format "LogText \"Copying imsq file to %...\"\n" copyPath to:scriptFile
				--format "CopyFile \"%\", \"%\", True\n" imsqFilename copyPath to:scriptFile
				--format "LogText \"Copy complete.\"\n" to:scriptFile
				
				format ("from System.IO import *\n") to:scriptFile
				format ("from Deadline.Scripting import *\n") to:scriptFile
				format ("def __main__():\n") to:scriptFile
				format ("    ScriptUtils.LogText( r'Copying imsq file to " + copyPath + "...' )\n") to:scriptFile
				format ("    File.Copy( r'" + imsqFilename + "', r'" + copyPath + "', True )\n") to:scriptFile
				format ("    ScriptUtils.LogText( 'Copy complete.' )\n") to:scriptFile
				
				Close scriptFile
				true
			)
			else
				false
		),
		
		
		--SUBMIT TILE JOBS FROM A SLAVE TO DEADLINE
		--eserna mdificada
		fn spawnTileJobs forceMaxFile:"" isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			try(SMTD_MainRollout.Ui_report (">Spawning Tile Jobs."))catch()

			SMTDSettings.TilesSubmissionJobIDs = #()
			SMTDSettings.RegionRendering = true
			SMTDSettings.TilesRendering = true
			
			--local DeltaX = (ceil (1.0*RenderWidth/SMTDSettings.TilesInX)) as integer
			--local DeltaY = (ceil (1.0*RenderHeight/SMTDSettings.TilesInY)) as integer
			local DeltaX = (floor (1.0*RenderWidth/SMTDSettings.TilesInX)) as integer
			local DeltaY = (floor (1.0*RenderHeight/SMTDSettings.TilesInY)) as integer
			
			if SMTDSettings.TileBlowupMode then
			(
				--DeltaX = (ceil (1.0*(RenderWidth/SMTDSettings.TilesInX)/SMTDSettings.TilesInX)) as integer
				--DeltaY = (ceil (1.0*(RenderHeight/SMTDSettings.TilesInY)/SMTDSettings.TilesInY)) as integer
				DeltaX = (floor (1.0*(RenderWidth/SMTDSettings.TilesInX)/SMTDSettings.TilesInX)) as integer
				DeltaY = (floor (1.0*(RenderHeight/SMTDSettings.TilesInY)/SMTDSettings.TilesInY)) as integer
			)
			
			local theOutput = rendOutputFileName
			local theOutPath = getFileNamePath theOutput
			local theBaseName = getFileNameFile theOutput
			local theOutType = getFileNameType theOutput
			local theJobName = SMTDSettings.JobName
			
			local TempMaxFile 
			if forceMaxFile == "" then
				TempMaxFile = maxFilePath + maxFileName
			else	
				TempMaxFile = forceMaxFile

			local theNetworkPath = SMTDFunctions.GetNetworkRoot()
			theNetworkPath += "\\submission\\3dsmax\\" 

			local theExternalFilesToCopy = #()
			if SMTDSettings.CurrentRepository == "" and SMTDSettings.SubmitExternalFilesMode > 1 do
			(
				local ExternalFilesListName = maxFilePath + "\\ExternalFilesList.txt" 
				if doesFileExist ExternalFilesListName then
				(
					try(DeadlineUtil.logMessage "External File List Found!")catch()
					local theExternalFilesList = openFile ExternalFilesListName
					while not eof theExternalFilesList do
					(
						append theExternalFilesToCopy (readline theExternalFilesList)
					)
					close theExternalFilesList 
				)
				else
					try(DeadlineUtil.logMessage "External File List DOES NOT Exist!")catch()
			)
			
			local currentTile = 0
			if not SMTDSettings.SingleTileJob then
			(
				for y = 1 to SMTDSettings.TilesInY do
				(
					for x = 1 to SMTDSettings.TilesInX do
					(
						currentTile +=1
						if not SMTDSettings.UseCustomTiles or findItem SMTDSettings.CustomTiles (Point2 x y) > 0 do
						(
							try(DeadlineUtil.SetProgress (100.0*currentTile/(SMTDSettings.TilesInX * SMTDSettings.TilesInY)) )catch()
							SMTDSettings.RegionLeft = DeltaX*(x-1) 
							SMTDSettings.RegionTop = DeltaY*(y-1) 
							
							if x == SMTDSettings.TilesInX then
								SMTDSettings.RegionRight = RenderWidth
							else
								SMTDSettings.RegionRight = DeltaX*x
							
							if y == SMTDSettings.TilesInY then
								SMTDSettings.RegionBottom = RenderHeight
							else
								SMTDSettings.RegionBottom = DeltaY*y 
							
							SMTDSettings.JobName = theJobName + " (TILE " + currentTile as string+ " : "  + x as string + "x" + y as string + " of " + SMTDSettings.TilesInX as string + "x" + SMTDSettings.TilesInY as string + ")"
							try(DeadlineUtil.LogMessage ("Spawning Job " + SMTDSettings.JobName))catch()
							try(SMTD_MainRollout.Ui_report (">Submitting Tile Job [" + SMTDSettings.JobName + "]"))catch()
		
							local tileString = "_tile_" + x as string + "x" + y as string + "_" + SMTDSettings.TilesInX as string + "x" + SMTDSettings.TilesInY as string  + "_"
							local OutputFileName = theOutPath + theBaseName  + tileString + theOutType 
		
							/*
							local TempMaxFile = SMTDPaths.TempDir + maxFileName
							if maxFileName == "" do TempMaxFile += "untitled.max"
							if (doesFileExist TempMaxFile) do deleteFile TempMaxFile
							
							if SMTDSettings.SubmitVisibleObjectsOnly and not SMTDFunctions.HasActiveSceneXRefs() then
								result = SMTDFunctions.SaveMaxFileVisibleOnly TempMaxFile
							else
								result = SMTDFunctions.SaveMaxFileCopy TempMaxFile
							*/
							
							--eserna añadidos parametros
							SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile customOutputFile:OutputFileName includeBothOutputs:true isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
							SMTDFunctions.CreateJobInfoFile SMTDPaths.JobInfofile renderOutputOverride:OutputFileName tileString:tileString isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
							
							local initialArgs = ""
							if SMTDSettings.bgSubmission do initialArgs += "-background -notify "
							if SMTDSettings.dropSubmission do initialArgs += "-drop "
							
							if( SMTDSettings.SubmitScene ) then
								initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile + "\" \"" + TempMaxFile + "\" \"" + theNetworkPath + "maxTileAssemblerCommand.ms" +"\" "
							else
								initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile + "\" \"" + theNetworkPath + "maxTileAssemblerCommand.ms" +"\" "
							
							initialArgs += "\"" + theNetworkPath + "maxTileSubmitter.ms\" "
							
							if SMTDSettings.CopyVbscriptFile do initialArgs += "\"" + SMTDPaths.ImsqVbscriptFile + "\" "
							
							--print initialArgs
							retcode = SMTDFunctions.waitForCommandToComplete ( initialArgs ) SMTDSettings.TimeoutSubmission
							
							if retcode == #success then
							(
								SMTDFunctions.getJobIDFromMessage (SMTDFunctions.getRenderMessage())				
								append SMTDSettings.TilesSubmissionJobIDs SMTDSettings.DeadlineSubmissionLastJobID
								if theExternalFilesToCopy.count > 0 then
									SMTDFunctions.CopyExternalFilesWithinRepository theExternalFilesToCopy
								else
									SMTDFunctions.CopyExternalFilesToRepository()
								
								--eserna - parametros
								SMTDFunctions.SubmitTransferJob isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName -- submits a remote transfer job if necessary
							)
							else
							(
								SMTDSettings.RegionRendering = false
								SMTDSettings.JobName = theJobName
								return false
							)	
						)--end if custom tiles
					)--end x loop
				)--end y loop
				SMTDSettings.TilesRendering = true
				SMTDSettings.RegionRendering = false
				SMTDSettings.JobName = theJobName
				if SMTDSettings.QuicktimeGenerate do SMTDFunctions.AutomaticQuicktimeGeneration isLPMjob:isLPMjob lpmJobName:lpmJobName	isPMjob:isPMjob pmJobName:pmJobName		
				true
			)
			else
			(
				SMTDSettings.SingleTileJobLeft = ""
				SMTDSettings.SingleTileJobRight = ""
				SMTDSettings.SingleTileJobTop = ""
				SMTDSettings.SingleTileJobBottom = ""
				SMTDSettings.SingleTileJobFilename = ""
				SMTDSettings.SingleTileJobReFilename = ""
				
				local currentFrame = 0
				local currentFrameList = ""
				for y = 1 to SMTDSettings.TilesInY do
				(
					for x = 1 to SMTDSettings.TilesInX do
					(
						if not SMTDSettings.UseCustomTiles or findItem SMTDSettings.CustomTiles (Point2 x y) > 0 do
						(
							local tempRight = DeltaX*x
							if x == SMTDSettings.TilesInX then
							(
								tempRight = RenderWidth
								if SMTDSettings.TileBlowupMode then
									tempRight = (floor (1.0*(RenderWidth/SMTDSettings.TilesInX))) as integer
							)
							
							local tempBottom = DeltaY*y 
							if y == SMTDSettings.TilesInY then
							(
								tempBottom = RenderHeight
								if SMTDSettings.TileBlowupMode then
									tempBottom = (floor (1.0*(RenderHeight/SMTDSettings.TilesInY))) as integer
							)
							
							local currentIndex = currentTile
							if SMTDSettings.UseCustomTiles do
								currentIndex = currentFrame
							
							SMTDSettings.SingleTileJobLeft = SMTDSettings.SingleTileJobLeft + "RegionLeft" + (currentIndex as string) + "=" + (((DeltaX*(x-1)) as integer) as string) + "\n"
							SMTDSettings.SingleTileJobTop = SMTDSettings.SingleTileJobTop + "RegionTop" + (currentIndex as string) + "=" + (((DeltaY*(y-1)) as integer) as string) + "\n"
							SMTDSettings.SingleTileJobRight = SMTDSettings.SingleTileJobRight + "RegionRight" + (currentIndex as string) + "=" + ((tempRight as integer) as string) + "\n"
							SMTDSettings.SingleTileJobBottom = SMTDSettings.SingleTileJobBottom + "RegionBottom" + (currentIndex as string) + "=" + ((tempBottom as integer) as string) + "\n"
							
							local tileString = "_tile_" + x as string + "x" + y as string + "_" + SMTDSettings.TilesInX as string + "x" + SMTDSettings.TilesInY as string  + "_"
							local regionFileName = theOutPath + theBaseName  + tileString + theOutType 
							SMTDSettings.SingleTileJobFilename = SMTDSettings.SingleTileJobFilename + "RegionFilename" + (currentIndex as string) + "=" + regionFileName + "\n"
							
							-- If any render elements are specified, include them 
							local reManager = maxOps.GetCurRenderElementMgr()
							local outputFilenameIndex = 0
							if reManager.GetElementsActive() then 
							(
								local reCount = reManager.NumRenderElements()
								for i = 0 to reCount - 1 do
								(
									reObject = reManager.GetRenderElement i
									if reObject.enabled then
									(
										reFilename = reManager.GetRenderElementFilename i
										if reFilename != undefined and reFilename != "" then
										(
											local regionReFileName = (getFilenamePath reFilename) + (getFilenameFile reFilename) + tileString + (getFilenameType reFilename)
											SMTDSettings.SingleTileJobReFilename = SMTDSettings.SingleTileJobReFilename + "RegionReFilename" + (currentIndex as string) + "_" + (outputFilenameIndex as string) + "=" + regionReFileName + "\n"
											outputFilenameIndex = outputFilenameIndex + 1
										)
									)
								)
							)
							
							currentTile +=1
							if currentFrameList == "" then
								currentFrameList = (currentFrame as string)
							else
								currentFrameList = currentFrameList + "," + (currentFrame as string) 
						)
						
						currentFrame += 1
					)
				)
				
				SMTDSettings.SingleTileJobTileCount = currentTile
				
				SMTDSettings.SingleTileJobFrameList = ""
				if SMTDSettings.UseCustomTiles do
					SMTDSettings.SingleTileJobFrameList = currentFrameList
				
				--eserna añadidos parametros
				SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
				SMTDFunctions.CreateJobInfoFile SMTDPaths.JobInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
				
				local initialArgs = ""
				if SMTDSettings.bgSubmission do initialArgs += "-background -notify "
				if SMTDSettings.dropSubmission do initialArgs += "-drop "
				
				if( SMTDSettings.SubmitScene ) then
					initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile + "\" \"" + TempMaxFile + "\" "
				else
					initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile + "\" "
				
				if SMTDSettings.CopyVbscriptFile do initialArgs += "\"" + SMTDPaths.ImsqVbscriptFile + "\" "
				
				--print initialArgs
				retcode = SMTDFunctions.waitForCommandToComplete ( initialArgs ) SMTDSettings.TimeoutSubmission
				
				if retcode == #success then
				(
					SMTDFunctions.getJobIDFromMessage (SMTDFunctions.getRenderMessage())
					
					if theExternalFilesToCopy.count > 0 then
						SMTDFunctions.CopyExternalFilesWithinRepository theExternalFilesToCopy
					else
						SMTDFunctions.CopyExternalFilesToRepository()
					
					--eserna - parametros
					SMTDFunctions.SubmitTransferJob isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName -- submits a remote transfer job if necessary
					
					-- SUBMIT DEPENDENT JOB HERE
					if SMTDSettings.SingleTileJobDependent then
					(
						local jobId = SMTDSettings.DeadlineSubmissionLastJobID
						local tileInfo = "(Frame " + ((currentTime.frame as integer) as string) + " - Tile Assembly Job)"
						local jobName = SMTDSettings.JobName + " " + tileInfo
						
						local tileString = "_tile_1x1_" + SMTDSettings.TilesInX as string + "x" + SMTDSettings.TilesInY as string + "_"
						local paddingString = ""
						if not SMTDSettings.RemovePadding do
						(
							paddingString = formattedPrint (currentTime.frame as integer) format:"04i"
						)
						
						local outputImageFilename = theOutPath + theBaseName + paddingString + theOutType
						local inputImageFilename = theOutPath + theBaseName + tileString + paddingString + theOutType
						
						--eserna - parametros
						local tileResult = SMTDFunctions.SubmitTileAssemblerJob jobId jobName outputImageFilename inputImageFilename isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
						if not tileResult then
							return false
						
						-- If any render elements are specified, include them 
						local reManager = maxOps.GetCurRenderElementMgr()
						if reManager.GetElementsActive() then 
						(
							local reCount = reManager.NumRenderElements()
							for i = 0 to reCount - 1 do
							(
								local reObject = reManager.GetRenderElement i
								if reObject.enabled then
								(
									local reFilename = reManager.GetRenderElementFilename i
									if reFilename != undefined and reFilename != "" then
									(
										local reJobName = SMTDSettings.JobName + " - " + reObject.elementName  + " - " + tileInfo
										
										local reOutputPath = (getFilenamePath reFilename)
										local reBaseName = (getFilenameFile reFilename)
										local reOutputType = (getFilenameType reFilename)
										
										local reOutputImageFilename = reOutputPath + reBaseName + paddingString + reOutputType
										local reImputImageFilename = reOutputPath + reBaseName + tileString + paddingString + reOutputType
										
										--eserna - parametros
										local reTileResult = SMTDFunctions.SubmitTileAssemblerJob jobId reJobName reOutputImageFilename reImputImageFilename isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
										if not reTileResult then
											return false
									)
								)
							)
						)
					)
				)
				else
					return false
				
				true
			)
		),
		
		--eserna modificada
		fn SubmitTileAssemblerJob jobId jobName outputImageFilename inputImageFilename isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			local formattedJobName = (SMTDFunctions.FormatJobName jobName isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName)
			local formattedComment = (SMTDFunctions.FormatComment SMTDSettings.Comment)
			
			local tileJobInfoFile = CreateFile SMTDPaths.SubmitInfofile
			if (tileJobInfoFile != undefined) then
			(
				format "Plugin=TileAssembler\n" to:tileJobInfoFile
				format "Name=%\n" formattedJobName to:tileJobInfoFile
				format "UserName=%\n" SMTDSettings.UserName to:tileJobInfoFile
				format "Comment=%\n" formattedComment to:tileJobInfoFile
				format "Department=%\n" SMTDSettings.Department to:tileJobInfoFile		
				format "Priority=%\n" SMTDSettings.Priority to:tileJobInfoFile
				format "Pool=%\n" SMTDSettings.PoolName to:tileJobInfoFile
				format "Group=%\n" SMTDSettings.Group to:tileJobInfoFile
				format "OnJobComplete=%\n" SMTDSettings.OnComplete to:tileJobInfoFile
				format "JobDependencies=%\n" jobId to:tileJobInfoFile
				format "ResumeOnDeletedDependencies=%\n" SMTDSettings.ResumeOnDeletedDependencies to:tileJobInfoFile
				format "OutputFilename0=%\n" outputImageFilename to:tileJobInfoFile
				format "Frames=0\n" to:tileJobInfoFile
				format "ChunkSize=1\n" to:tileJobInfoFile
				format "MachineLimit=1\n" to:tileJobInfoFile
				Close tileJobInfoFile
			)
			else
				return false

			local tileJobPluginFile = CreateFile SMTDPaths.JobInfofile
			if (tileJobPluginFile != undefined) then
			(
				format "InputImages=%\n" inputImageFilename to:tileJobPluginFile
				format "CleanupTiles=%\n" SMTDSettings.SingleTileJobCleanup to:tileJobPluginFile
				format "NotCropped=False\n" to:tileJobPluginFile
				format "IgnoreOverlap=False\n" to:tileJobPluginFile
				Close tileJobPluginFile
			)
			else
				return false
			
			local tileArgs = ""
			if SMTDSettings.bgSubmission do tileArgs += "-background -notify "
			if SMTDSettings.dropSubmission do tileArgs += "-drop "
			tileArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile + "\" "
			
			retcode = SMTDFunctions.waitForCommandToComplete ( tileArgs ) SMTDSettings.TimeoutSubmission
			if retcode != #success then
				return false
			
			true
		),
		
		fn CopyExternalFilesWithinRepository theExternalFilesToCopy =
		(
			try(deadlineUtil.LogMessage (">Copy External Files Within Repository..." ) )catch()
		
			local theNetworkPath = SMTDFunctions.GetNetworkRoot()
			local theTargetPath = theNetworkPath + "\\jobs\\" + SMTDSettings.DeadlineSubmissionLastJobID + "\\"
			for f in theExternalFilesToCopy do
			(
				local result = copyFile f ( theTargetPath + (filenameFromPath f))
				try(du.LogMessage ("Copying " + f + " to " + ( theTargetPath + (filenameFromPath f)) ))catch()
			)

			try(deadlineUtil.LogMessage (">Adding External Files To .JOB XML File..." ) )catch()
			local theOldXML = openFile (theTargetPath + SMTDSettings.DeadlineSubmissionLastJobID+ ".job")
			local theNewXML = createFile (theTargetPath + SMTDSettings.DeadlineSubmissionLastJobID+ ".tmp")
			while not eof theOldXML do
			(
				local theLine = readLine theOldXML 
				if matchPattern theLine pattern:"*</AuxillarySubmissionFileNames>*" then
				(
					for aFile in theExternalFilesToCopy do
						format "    <string>%</string>\n" (filenameFromPath aFile) to:theNewXML
				)
				format "%\n" theLine to:theNewXML
			)
			close theOldXML
			close theNewXML
			renameFile (theTargetPath + SMTDSettings.DeadlineSubmissionLastJobID + ".job") (theTargetPath + SMTDSettings.DeadlineSubmissionLastJobID + ".old")
			renameFile (theTargetPath + SMTDSettings.DeadlineSubmissionLastJobID + ".tmp") (theTargetPath + SMTDSettings.DeadlineSubmissionLastJobID + ".job")			
			try(SMTD_MainRollout.Ui_report (">Job was submitted as Suspended to allow External Files transfer. Resuming Job..." ) )catch()
			try(deadlineUtil.LogMessage (">Job was submitted as Suspended to allow External Files transfer. Resuming Job..." ) )catch()
			SMTDFunctions.waitForCommandToComplete ( " -ResumeJob "+ SMTDSettings.DeadlineSubmissionLastJobID ) SMTDSettings.TimeoutCollectData
			true
		),
		

		--SUBMIT BATCH JOBS FROM A SLAVE TO DEADLINE
		--eserna modificada
		fn spawnBatchJobs isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			SMTDSettings.UseBatchRender = false --before spawning new jobs, make sure they don't become batch masters
			
			local def_RenderWidth = RenderWidth 
			local def_RenderHeight = RenderHeight
			local def_RenderPixelAspect = RenderPixelAspect
			local def_Camera = viewport.getCamera()
			local def_rendOutputFileName = rendOutputFileName 
			local def_rendSaveFile = rendSaveFile
			local def_rendTimeType = rendTimeType 
			local def_rendStart = rendStart
			local def_rendEnd = rendEnd
			
			local theJobName = SMTDSettings.JobName
			local currentJob = 0
			local numViews = batchRenderMgr.numViews 
			local views = (for i = 1 to numViews collect (batchRenderMgr.getView i))
			local numberOfBatchJobs =  (for i = 1 to numViews where (batchRenderMgr.getView i).enabled collect i).count
			
			local needMaxReload = false
			
			local theExternalFilesToCopy = #()
			if SMTDSettings.CurrentRepository == "" and SMTDSettings.SubmitExternalFilesMode > 1 do
			(
				local ExternalFilesListName = maxFilePath + "\\ExternalFilesList.txt"  
				if doesFileExist ExternalFilesListName then
				(
					try(DeadlineUtil.logMessage "External File List Found!")catch()
					local theExternalFilesList = openFile ExternalFilesListName
					while not eof theExternalFilesList do
					(
						append theExternalFilesToCopy (readline theExternalFilesList)
					)
					close theExternalFilesList 
				)
				else
					try(DeadlineUtil.logMessage "External File List DOES NOT Exist!")catch()
			)
			
			for i = 1 to numViews do
			(
				local theView = views[i]
				if theView.enabled then 
				(
					if needMaxReload then
					(
						DeadlineUtil.LogMessage (">Reloading original scene...")
						loadMaxFile (maxFilePath + maxFileName) quiet:true
						needMaxReload = false
					)	
					else
					(
						RenderWidth = def_RenderWidth 
						RenderHeight = def_RenderHeight 
						RenderPixelAspect = def_RenderPixelAspect 
						if (def_Camera != undefined) and (IsValidNode def_Camera) do viewport.setCamera def_Camera
						rendOutputFileName = def_rendOutputFileName 
						rendSaveFile = def_rendSaveFile
						rendTimeType = def_rendTimeType 
						rendStart = def_rendStart 
						rendEnd = def_rendEnd 
					)
					
					if theView.outputFilename != "" then
					(
						currentJob+=1
						try(DeadlineUtil.SetProgress (100.0*i/numViews) )catch()
						try(DeadlineUtil.LogMessage (">Processing View Definition ["+ theView.name +"] ..."))catch()	
						SMTDSettings.JobName = theJobName + " (BATCH " + currentJob as string+ " of " + numberOfBatchJobs as string + ")"
						
						--Load Scene State
						if theView.sceneStateName == "" then
							DeadlineUtil.LogMessage ("--No Scene State Defined For This View")
						else
						(
							DeadlineUtil.LogMessage (">Restoring Scene State [" + theView.sceneStateName + "]")
							result = sceneStateMgr.RestoreAllParts theView.sceneStateName
							if result then
							(
								DeadlineUtil.LogMessage ("+Scene State Manager Successfully Restored the Scene State.")
								needMaxReload = true
							)	
							else
								DeadlineUtil.LogMessage ("--Scene State Manager FAILED to Restore the Scene State")
						)		
						
						--Load Render Preset
						if (fileNameFromPath theView.presetFile) == "" then
							DeadlineUtil.LogMessage ("--No Render Preset Defined For This View")
						else
						(
							DeadlineUtil.LogMessage (">Loading Render Preset [" + (fileNameFromPath theView.presetFile) + "]")
							result = renderpresets.LoadAll 0 (maxFilePath + (fileNameFromPath theView.presetFile))
							if result then
							(
								DeadlineUtil.LogMessage ("+Render Presets Manager Successfully Loaded the Render Preset.")
								needMaxReload = true
							)	
							else
								DeadlineUtil.LogMessage ("--Render Presets Manager FAILED to Load the Render Preset For This View")
						)	
						
						--Set Camera if specified
						if isValidNode theView.camera then
						(
							viewport.setCamera theView.camera
							if def_Camera == undefined do needMaxReload = true
						)	
						
						--Set New Output File
						rendOutputFileName = theView.outputFilename --get path from Batch Render Dialog
						rendSaveFile = true
						
						--Set Alternative Resolution and Pixel Aspect if Override Preset is on
						--Set Alternative Frame Range is Override Preset is on
						if theView.overridePreset 	then
						(
							RenderWidth = theView.width
							RenderHeight = theView.height
							RenderPixelAspect = theView.pixelAspect
							rendTimeType = 3
							rendStart = theView.startFrame
							rendEnd = theView.endFrame
						)	
						
						try(DeadlineUtil.LogMessage ("Spawning Job " + SMTDSettings.JobName))catch()
						
						local theNetworkPath = SMTDFunctions.GetNetworkRoot()
						
						local TempMaxFile = SMTDPaths.TempDir + maxFileName
						if (doesFileExist TempMaxFile) do deleteFile TempMaxFile
						result = SMTDFunctions.SaveMaxFileCopy TempMaxFile
						
						--eserna añadidos parametros
						SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
						SMTDFunctions.CreateJobInfoFile SMTDPaths.JobInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
						
						local initialArgs = ""
						if SMTDSettings.bgSubmission do initialArgs += "-background -notify "
						if SMTDSettings.dropSubmission do initialArgs += "-drop "
						
						theNetworkPath += "\\submission\\3dsmax\\"
						initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile  + "\" \"" + TempMaxFile + "\"  \"" + theNetworkPath + "maxTileAssemblerCommand.ms" +"\" "					
						if SMTDSettings.CopyVbscriptFile do initialArgs += "\"" + SMTDPaths.ImsqVbscriptFile + "\" "
						retcode = SMTDFunctions.waitForCommandToComplete ( initialArgs ) SMTDSettings.TimeoutSubmission
						SMTDFunctions.getJobIDFromMessage (SMTDFunctions.getRenderMessage())
						if retcode == #success and theExternalFilesToCopy.count > 0 then
							SMTDFunctions.CopyExternalFilesWithinRepository theExternalFilesToCopy
					)
					else
						try(DeadlineUtil.LogMessage ("--View Definition ["+ theView.name +"] has not Output File Name - Skipping..."))catch()
				)
				else
					try(DeadlineUtil.LogMessage ("--View Definition ["+ theView.name +"] is disabled - Skipping..."))catch()				
			)--end batch loop
			true
		),

		
		fn getJobIDFromMessage renderMsg =
		(
			SMTDSettings.DeadlineSubmissionLastJobID = "failed"
			theStringStream = renderMsg as stringStream
			skipToString theStringStream "JobID="
			try(SMTDSettings.DeadlineSubmissionLastJobID = readline theStringStream)catch()
			close theStringStream 
		),

		fn getRenderMessage =
		(
			local resultFile = OpenFile SMTDPaths.SubmitOutput
			local renderMsg = "No message."
			if (resultFile != undefined) do
			(
				seek resultFile #eof
				local fileSize = filepos resultFile
				seek resultFile 0
				renderMsg = readChars resultFile fileSize errorAtEOF:false
				close resultFile
			)
			renderMsg 
		),
		
		fn GetExternalFilesToCopy =
		(
			local uniquenamedata = #()
			local BitmapsCopyData = #()
			if SMTDSettings.CurrentRepository == "" AND SMTDSettings.SubmitExternalFilesMode > 1 AND SMTDSettings.SubmitExternalFilesMode < 4  do
			(
				for o in SMTDExternalRefsArray.storeBitmapPath where findItem uniquenamedata o[2] == 0 do 
				(
					append uniquenamedata o[2]
					append BitmapsCopyData #(o[2],o[3])
				)	
				for o in SMTDExternalRefsArray.StoreSceneXRefs where o[4] AND findItem uniquenamedata o[2] == 0 do 
				(
					append uniquenamedata o[2]
					append BitmapsCopyData #(o[2],o[3])
				)	
				for o in SMTDExternalRefsArray.StoreObjectXRefs where findItem uniquenamedata o[2] == 0 do 
				(
					append uniquenamedata o[2]
					append BitmapsCopyData #(o[2],o[3])
				)	
				for o in SMTDExternalRefsArray.StoreSceneVrayProxies where findItem uniquenamedata o[2] == 0 do 
				(
					append uniquenamedata o[2]
					append BitmapsCopyData #(o[2],o[3])
				)			
				for o in SMTDExternalRefsArray.StoreSceneMRProxies where findItem uniquenamedata o[2] == 0 do 
				(
					if o[1].animated then
					(
						local theAnimationFiles = SMTDFunctions.GetAnimationFiles o[2]
						for f in theAnimationFiles do
						(
							append uniquenamedata f
							append BitmapsCopyData #(f, SMTDFunctions.RenameTargetAnimationFile f o[3])
						)
					)
					else
					(
						append uniquenamedata o[2]
						append BitmapsCopyData #(o[2],o[3])
					)
				)					
				
				if SMTDSettings.UseBatchRender then
				(
					local numViews = batchRenderMgr.numViews 
					local numberOfBatchJobs =  (for i = 1 to numViews where (batchRenderMgr.getView i).enabled collect i).count
					for i = 1 to numViews do
					(
						local theView = batchRenderMgr.getView i
						if theView.enabled and theView.presetFile != "" then 
							append BitmapsCopyData #(theView.presetFile, fileNameFromPath theView.presetFile)
					)	
				)	
			)
			BitmapsCopyData
		),
		
		fn CopyExternalFilesToRepository =
		(
			if SMTDSettings.CurrentRepository == "" AND SMTDSettings.SubmitExternalFilesMode > 1 AND SMTDSettings.SubmitExternalFilesMode < 4  do
			(
				local BitmapsCopyData = SMTDFunctions.GetExternalFilesToCopy()
				local copyResult = SMTDFunctions.CopyExternalReferences SMTDSettings.DeadlineSubmissionLastJobID BitmapsCopyData 
				if not SMTDSettings.SubmitAsSuspended do 
				(
					if copyResult == 0 then
					(
						try(SMTD_MainRollout.Ui_report (">Job was submitted as Suspended to allow External Files transfer. Resuming Job..." ) )catch()
						SMTDFunctions.waitForCommandToComplete ( " -ResumeJob "+ SMTDSettings.DeadlineSubmissionLastJobID ) SMTDSettings.TimeoutCollectData
					)	
					else
					(
						if copyResult == 1 then
							try(SMTD_MainRollout.Ui_report ("--One External File FAILED to transfer! Job Left Suspended!" ) )catch()
						else
							try(SMTD_MainRollout.Ui_report ("--" + copyResult  as string +" External Files FAILED to transfer! Job Left Suspended!" ) )catch()
					)	
				)	
			)
		),
		
		--eserna modificada
		fn SubmitTransferJob isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			-- Only submit a transfer job if a remote repository has been selected.
			if SMTDSettings.CurrentRepository2 != "" do
			(
				SMTD_MainRollout.Ui_report ">Submitting Transfer Job."
				
				local transferJobID = SMTDSettings.DeadlineSubmissionLastJobID
				local transferJobRepository = SMTDSettings.CurrentRepository2
				local transferAsSuspended = SMTDSettings.TransferJobAsSuspended
				local transferCompress = SMTDSettings.TransferCompressed
				local transferEmailResults = true
				local transferRemoveLocal = true
				
				local transferJobName = ("Transfer of " + (SMTDFunctions.FormatJobName SMTDSettings.JobName isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName) + " (" + transferJobID + ")")
				local transferDepartment = SMTDSettings.Department
				local transferPool = SMTDSettings.TransferPool
				local transferGroup = SMTDSettings.TransferGroup
				local transferPriority = SMTDSettings.TransferPriority
				local transferDeleteOnComplete = SMTDSettings.TransferDeleteOnComplete
				
				local jobInfoFilename = SMTDPaths.TempDir + "job_transfer_info.job"
				local pluginInfoFilename = SMTDPaths.TempDir + "job_transfer_plugin.job"
				
				-- Create job info file
				local jobInfoFile = CreateFile jobInfoFilename
				if (jobInfoFile != undefined) then
				(
					format "Plugin=JobTransfer\n"										to:jobInfoFile
					format "Name=%\n" 						transferJobName				to:jobInfoFile
					format "UserName=%\n"					SMTDSettings.UserName		to:jobInfoFile
					format "Department=%\n" 				transferDepartment		 	to:jobInfoFile
					format "Pool=%\n" 						transferPool				to:jobInfoFile
					format "Group=%\n" 						transferGroup				to:jobInfoFile
					format "Priority=%\n" 					transferPriority 	 		to:jobInfoFile
					format "Frames=0\n"													to:jobInfoFile
					format "ChunkSize=1\n" 												to:jobInfoFile
					if transferDeleteOnComplete do
						format "OnJobComplete=Delete\n"									to:jobInfoFile
					close jobInfoFile
				)
				
				-- Create the plugin info file
				local pluginInfoFile = CreateFile pluginInfoFilename
				if (pluginInfoFile != undefined) then
				(
					format "TransferJobID=%\n" 				transferJobID				to:pluginInfoFile
					format "TransferRepository=%\n"			transferJobRepository		to:pluginInfoFile
					format "SuspendedAfterTransfer=%\n" 	transferAsSuspended			to:pluginInfoFile
					format "RemoveLocalAfterTransfer=%\n" 	transferRemoveLocal			to:pluginInfoFile
					format "EmailResultsAfterTransfer=%\n" 	transferEmailResults		to:pluginInfoFile
					format "CompressFiles=%\n" 				transferCompress 	 		to:pluginInfoFile
					
					format "TransferJobFrames=\n"										to:pluginInfoFile
					format "TransferJobChunkSize=\n"									to:pluginInfoFile
					
					close pluginInfoFile
				)
				
				-- Submit the transfer job
				local initialArgs = "\"" + jobInfoFilename + "\" \"" + pluginInfoFilename + "\""
				local retCode = SMTDFunctions.waitForCommandToComplete initialArgs SMTDSettings.TimeoutSubmission
				if retCode == #success then
				(
					renderMsg = SMTDFunctions.getRenderMessage()
					try(SMTD_MainRollout.Ui_report ("Transfer Job submitted successfully.\n\n" + renderMsg))catch()
					try(SMTD_MainRollout.sld_lastSubmissionState.color = green)catch()
				)	
				else	
				(
					try(SMTD_MainRollout.sld_lastSubmissionState.color = red*0.7)catch()
					if result == #timeout then
						try(SMTD_MainRollout.Ui_report ("--Failed To Submit Transfer Job in " + SMTDSettings.TimeoutSubmission as string + " seconds.\nConsider Increasing the Job Submission Timeout in the User Options tab."))catch()
					else	
						try(SMTD_MainRollout.Ui_report ("--Failed To Submit Transfer Job."))catch()
				)
			)
		),
		
		--eserna modificada
		fn SubmitJob createJobInfo:true createSubmitInfo:true timeout:3600 isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:"" =
		(
			SMTDSettings.DeadlineSubmissionSuccessful = false
			SMTDSettings.DeadlineSubmissionLastJobID = "failed"
			renderSceneDialog.Commit()
			try(SMTD_TilesRendering.chk_showRegionGizmo.changed (SMTD_TilesRendering.chk_showRegionGizmo.state = false))catch()
			
			local TempMaxFile = ""
			if( SMTDSettings.SubmitScene ) then
			(
				TempMaxFile = SMTDPaths.TempDir + maxFileName
				if maxFileName == "" do TempMaxFile += "untitled.max"
				if (doesFileExist TempMaxFile) do deleteFile TempMaxFile
				result = SMTDFunctions.SaveMaxFileCopy TempMaxFile
				if result != undefined do return result
			)
			else
			(
				if maxFileName == "" then
				(
					filename = getMAXSaveFileName()
					if filename == undefined do return ""
					
					TempMaxFile = filename
				)
				else
					TempMaxFile = maxFilePath + maxFileName
				saveMaxFile TempMaxFile
			)
				
			local initialArgs = ""
			if SMTDSettings.bgSubmission do initialArgs += "-background -notify "
			if SMTDSettings.dropSubmission do initialArgs += "-drop "
			
			--eserna modificada - parametros
			if createSubmitInfo do
				if ((SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName) != true) do return #SubmitInfoFileCreationFailed
			
			if createJobInfo do
				if ((SMTDFunctions.CreateJobInfoFile SMTDPaths.JobInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName) != true) do return #JobInfoFileCreationFailed
			
			if not doesFileExist SMTDPaths.SubmitInfofile do return #SubmitInfoFileMissing
			if not doesFileExist SMTDPaths.JobInfofile do return #JobInfoFileMissing
			
			if( SMTDSettings.SubmitScene ) then
				initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile  + "\" \"" + TempMaxFile  + "\" "
			else
				initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile  + "\" "
			
			if SMTDSettings.SubmitAsMXSJob do initialArgs += "\"" + SMTDSettings.MAXScriptFile + "\" "
			
			local retCode = SMTDFunctions.waitForCommandToComplete initialArgs timeout

			SMTD_LastMessage = SMTDFunctions.getRenderMessage()
			if retCode == #success then
			(
				SMTDSettings.DeadlineSubmissionSuccessful = true
				SMTDFunctions.getJobIDFromMessage SMTD_LastMessage
				SMTDFunctions.CopyExternalFilesToRepository() --try to copy external bitmaps
				--eserna - parametros
				SMTDFunctions.SubmitTransferJob isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName -- submits a remote transfer job if necessary
				try(FF_AssetTracker_Functions.TrackDeadlineRender SMTDSettings.DeadlineSubmissionLastJobID)catch()
			)	
			retCode 
		),

		--los dos parametros opcionales isLPMjob y jobName son debidos a la necesidad de envio desde LPM
		--eserna modificada
		fn SubmitJobFromUI isLPMjob:false lpmJobName:"" isPMjob:false pmJobName:""=
		(
			try(SMTD_MainRollout.Ui_report ">Job Submission Started...")catch()
			SMTDSettings.DeadlineSubmissionSuccessful = false
			try(SMTD_MainRollout.sld_lastSubmissionState.color = red)catch()
			SMTDSettings.DeadlineSubmissionLastJobID = "failed"
			
			try(SMTD_RegionRendering.chk_showRegionGizmo.changed (SMTD_RegionRendering.chk_showRegionGizmo.state = false))catch()
			try(SMTD_TilesRendering.chk_showTilesGizmo.changed (SMTD_TilesRendering.chk_showTilesGizmo.state = false))catch()
			
			local theXRefObjects = #()
			local theSceneXRefsCount = 0
			local renderMsg = ""
			local oldMatEditorOpenState = false
			local oldVRayVFBState = false
			
			local oldSubmitMaxScript = false
			local oldMaxScriptFile = ""
			
			SMTDSettings.CopyVbscriptFile = false
				
			-- If merging of XRefs is requested, try to save a temp. copy of the scene and then merge the xrefs into the scene.
			-- This was moved up here to allow the bitmaps of xrefs to be collected, too.
				
			--if SMTDSettings.CurrentRepository == "" then ( --Bobo:Not sure why this would matter, if we are merging, we are merging regardless of target repository
			if SMTDSettings.MergeXRefsOnSubmission or SMTDSettings.MergeSceneXRefsOnSubmission do
			(
				--theXRefObjects = (for o in objects where objXRefMgr.IsNodeXRefed o != undefined collect o)
				theXRefObjects = for i = 1 to objXRefMgr.recordCount where (objXRefMgr.GetRecord i).enabled collect (objXRefMgr.GetRecord i)
				
				theSceneXRefsCount = xrefs.getXRefFileCount()
				if theXRefObjects.count > 0 or  theSceneXRefsCount > 0 do
				(
					if (doesFileExist SMTDPaths.RestoreTempMaxFile) do deleteFile SMTDPaths.RestoreTempMaxFile
					if (result = SMTDFunctions.SaveMaxFileCopy SMTDPaths.RestoreTempMaxFile) != undefined do
						return ("SAVING BACKUP FILE:\n" + result)
					if theXRefObjects.count > 0 do 
					(
						for o in theXRefObjects do objXRefMgr.MergeRecordIntoScene o
					)
					if theSceneXRefsCount > 0 do 
					(
						for i = theSceneXRefsCount to 1 by -1 do
							if not (xrefs.getXRefFile i).disabled do 
								merge (xrefs.getXRefFile i)
					)
				)	
			)	
			
			SMTD_MainRollout.Ui_report ">Checking For Missing External Files..."	
			SMTDFunctions.checkForMissingMaps()
			if SMTDSettings.MissingFiles.count > 0 then
			(
				SMTD_MainRollout.Ui_report ">Missing Files:"
				for i in SMTDSettings.MissingFiles do 
					SMTD_MainRollout.Ui_report ("   " + i )
				local txt = if SMTDSettings.MissingFiles.count == 1 then "File" else "Files"
				local theMessage = "The Scene Contains "+  SMTDSettings.MissingFiles.count as string +" Missing External "+ txt + ".\n\n"
				if SMTDSettings.WarnAboutMissingExternalFiles then
				(
					if SMTDSettings.IgnoreMissingExternalFiles then
					(
						theMessage += "The 'Ignore Missing External File Errors' option is checked - \n"
						theMessage += "The job will render successfully but incorrectly!\n\n"
					)
					else
					(	
						theMessage += "The 'Ignore Missing External File Errors' option is NOT checked -\n"
						theMessage += "The job will not render correctly. It is suggested to cancel the submission\n\n!"
					)	
					
					theMessage += "Press Yes to Continue Submission.\nPress No to Cancel Submission and Correct the Problems."
					local theAnswer = querybox theMessage title:"SMTD: Missing External Files"
					if not theAnswer do return "--Submission Cancelled by User - Missing External Files Found!"
				)
			)				

			queryExternalFiles = true
			local theBitmapsFileName = ""
			if SMTDSettings.CurrentRepository == "" do
			(
				if SMTDSettings.SubmitExternalFilesMode > 1 do
				(
					SMTD_MainRollout.Ui_report ">Collecting External Files..."	
					if maxfilepath != "" do sysinfo.currentdir = maxfilepath --this sets the current directory to the location of the MAX file, so if the bitmaps are stripped of paths, it would resolve them using the MAX source directory
					bitmapFilenames = SMTDFunctions.returnAllBitmaps()
					local BitmapsCopyData = SMTDFunctions.GetExternalFilesToCopy()
					if SMTDSettings.SubmitExternalFilesMode == 4 then
					(
						theBitmapsFileName = SMTDFunctions.createExternalFilesList bitmapFilenames
					)
					else
					(
						local sizeInMB = 0.0
						for b in BitmapsCopyData do
							sizeInMB += getFileSize b[1]
						sizeInMB /= 1024.0*1024.0
						local txt = if BitmapsCopyData.count == 1 then "File" else "Files"
						try(SMTD_MainRollout.Ui_report ("+Found "+ BitmapsCopyData.count as string +" External "+ txt +" with "+ sizeInMB as string +"MB."))catch()
						if BitmapsCopyData.count > 1 or sizeInMB > 10 do
							queryExternalFiles = querybox (BitmapsCopyData.count as string + " External "+txt+" (" + sizeInMB as string + " MB) Found In The Scene.\nYou have requested to submit External Files to the Repository.\nDo you want to continue?") title:"Submit To Deadline: External Files Found"
					)	
				)
			)
			
			if not queryExternalFiles then
			(
				try(SMTD_MainRollout.sld_lastSubmissionState.color = red*0.5; SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
				if (SMTDSettings.MergeXRefsOnSubmission and theXRefObjects.count > 0) or (SMTDSettings.MergeSceneXRefsOnSubmission and theSceneXRefsCount > 0 ) then
				(
					SMTD_MainRollout.Ui_report ">Restoring Original Scene From Backup File..."	
					SMTDFunctions.RestoreMaxFileCopy SMTDPaths.RestoreTempMaxFile
				)				
				else
				(
					SMTD_MainRollout.Ui_report ">Restoring Original External File Paths..."	
					SMTDFunctions.restoreExternalReferencePaths()
				)
				return ("DEADLINE JOB SUBMISSION:\n\nExternal Files Submission Cancelled by User.")				
			)			
			
			local oldRenderDialogState = renderSceneDialog.isOpen()
			renderSceneDialog.Close()
			
			if oldRenderDialogState do
			(
				try(SMTD_MainRollout.Ui_report "+Render Dialog Closed.")catch()
			)	
			
			-- need to close scene explorers to workaround a problem (2008 and later)
			local oldSceneExplorerStates = #()
			if (maxVersion())[1] >= 10000 do
			(
				SceneExplorerManager.CloseManageInstancesDialog()
				for i = 1 to SceneExplorerManager.GetExplorerCount() do
				(
					local name = SceneExplorerManager.GetExplorerName i
					local visible = SceneExplorerManager.ExplorerIsOpen name
					append oldSceneExplorerStates visible
					if visible do SceneExplorerManager.CloseExplorer name
				)
			)
			
			local oldMeditLockedState = renderers.medit_locked --get the locked state of the Medit renderer
			if oldMeditLockedState == true do 
			(
				renderers.medit_locked = false --if locked, unlock it. This was requested by Jon Reynolds to fix problems with VRay 1.5, might not be needed in general but does not hurt either.
				SMTD_MainRollout.Ui_report "+Unlocked the Material Editor Renderer."	
			)	
			if SMTDSettings.ClearMaterialEditorOnSubmission do 
			(
				oldMatEditorOpenState = MatEditor.isOpen()
				if oldMatEditorOpenState do MatEditor.Close()
				SMTD_MainRollout.Ui_report "+Closed Material Editor..."	
				SMTDFunctions.clearMaterialEditor()
				SMTD_MainRollout.Ui_report "+Cleared Material Editor..."	
			)	
			
			
			if renderers.current.classid as string == "#(1121714582, 90602926)" then
			(
				oldAmarettoExportMode = Amaretto.getProperty "Amaretto:PygExportMode" 
				if oldAmarettoExportMode != "5" and oldAmarettoExportMode != "1" then
				(
					SMTD_MainRollout.Ui_report (">Overriding Amaretto Submission Mode with [Direct To Gelato]" )
					Amaretto.setProperty "Amaretto:PygExportMode" "1"
				)	
				else
					if oldAmarettoExportMode == "1" then
						SMTD_MainRollout.Ui_report (">Amaretto Submission Mode is already [Direct To Gelato]." )
					else
						SMTD_MainRollout.Ui_report (">Amaretto Submission Mode is already [Export And Render Direct]" )
			)	
			
			-- CHECK VRAY VFB if not bake job
			if not SMTDSettings.IsBakeJob then
			(
				if renderers.current.classid as string == "#(1941615238, 2012806412)" do
				(
					if renderers.current.output_on and renderers.current.output_saveRawFile then
					(
						-- If tiled exrs are being rendered, automatically disable the memory frame buffer
						oldVRayVFBState = renderers.current.output_useram
						renderers.current.output_useram = false
						SMTD_MainRollout.Ui_report "+Disabled V-Ray Frame Buffer rendering to RAM."
					)
					else
					(
						-- Otherwise, just disable the vray vfb entirely
						oldVRayVFBState = renderers.current.output_on
						renderers.current.output_on = false
						SMTD_MainRollout.Ui_report "+Disabled V-Ray Frame Buffer."
						
						SMTDFunctions.RenderElementsStoreVrayVFB()
						SMTDFunctions.RenderElementsUpdateVrayVFB()
					)
				)
			)
			else
			(
				oldMaxScriptFile = SMTDSettings.SubmitAsMXSJob
				oldSubmitMaxScript = SMTDSettings.MAXScriptFile
				
				SMTDSettings.SubmitAsMXSJob = true
				SMTDSettings.MAXScriptFile = SMTDFunctions.GetNetworkRoot() + "\\submission\\3dsmax\\TextureBake.ms"
				
				SMTD_MainRollout.Ui_report "+Overwriting MaxScript Job Settings."
			)
			
			--FORCE HIGH PRIORITY THREAD
			if SMTDSettings.OverrideLowPriorityThread do
			(
				try (
					VRAY_lowThreadPriority = renderers.current.system_lowThreadPriority
					if VRAY_lowThreadPriority do  (
					renderers.current.system_lowThreadPriority = false
					SMTD_MainRollout.Ui_report ("+Forcing V-Ray Low Thread Priority to [false].")
					)
				)catch() 
				try (
					BRAZIL_lowThreadPriority = renderers.current.low_priority_thread_on
					if BRAZIL_lowThreadPriority do (
					renderers.current.low_priority_thread_on = false
					SMTD_MainRollout.Ui_report ("+Forcing Brazil r/s Low Thread Priority to [false].")
					)
				)catch() 
			)

			
			
			local retcode = #success		
			
			if SMTDSettings.StrictOutput then
			(
				if RendOutputFilename != "" then
				(                           
					SMTD_MainRollout.Ui_report ">Strict Output Check..."	
					local path = getFilenamePath RendOutputFilename
					local directory = getFilenameFile maxFilename
					local filename = getFilenameFile maxFilename
					local extension = getFilenameType RendOutputFilename
								
					-- if the output path already contains the max filename, assume that
					-- it already contains the correct directory structure, so we don't keep
					-- appending directories everytime the job is submitted
					if findString path directory != undefined then
						RendOutputFilename = path + filename + extension
					else
						RendOutputFilename = path + directory + "\\" + filename + extension
				)
			)--end strict output
			
			--si se esta lanzando desde lpm, no se deben cambiar los paths de los render elements
			if not (isLPMjob or lpmJobName != "" or isPMjob or pmJobName != "") then
				if SMTDSettings.RenderElementsUpdatePaths do
				(
					SMTD_MainRollout.Ui_report ">Updating Render Elements Paths..."	
					if not SMTDSettings.RenderElementsPermanentChanges do 
					(
						SMTDFunctions.RenderElementsStorePaths()
						SMTD_MainRollout.Ui_report "+Stored Render Elements Paths..."	
					)	
					SMTDFunctions.RenderElementsUpdatePaths()
					SMTD_MainRollout.Ui_report "+Updated Render Elements Paths..."	
				)				
			
			--Output Info about Repository being submitted to
			try
			(
				if SMTDSettings.CurrentRepository != "" then
				(
					SMTD_MainRollout.Ui_report (">Submitting "+ SMTDFunctions.getPluginToUse() +" Render Job to Remote Repository:")
					SMTD_MainRollout.Ui_report ("["+ SMTDSettings.CurrentRepository +"]...")
				)	
				else
					SMTD_MainRollout.Ui_report (">Submitting "+ SMTDFunctions.getPluginToUse() +" Render Job to Local Repository...")
			)catch()		
			
			---------------------------------------------------------------------------------------------
			--eserna
			---------------------------------------------------------------------------------------------
			--crea el nombre que tendrá el trabajo de render
			
			local TempMaxFile = SMTDPaths.TempDir + maxFileName
			if maxFileName == "" do TempMaxFile += "untitled.max"
				
			--si se ha enviado desde LPM, se usará el nombre pasado por parametro
			if isLPMjob then TempMaxFile = SMTDPaths.TempDir + lpmJobName + ".max"
			else if isPMjob then TempMaxFile = SMTDPaths.TempDir + pmJobName + ".max"
			
			if (doesFileExist TempMaxFile) do deleteFile TempMaxFile
			---------------------------------------------------------------------------------------------
			---------------------------------------------------------------------------------------------
			
			if SMTDSettings.UseCustomShader do
			(
				SMTD_MainRollout.Ui_report ">Applying Custom Shaders..."	
				SMTDFunctions.CollectSceneMaterials()
				SMTDFunctions.assignCustomShaders()
			)
			
			if SMTDSettings.SubmitVisibleObjectsOnly and not SMTDFunctions.HasActiveSceneXRefs() then
			(
				SMTD_MainRollout.Ui_report ">Saving Visible Objects For Submission..."	
				result = SMTDFunctions.SaveMaxFileVisibleOnly TempMaxFile
			)	
			else
			(
				SMTD_MainRollout.Ui_report ">Saving Scene For Submission..."	
				result = SMTDFunctions.SaveMaxFileCopy TempMaxFile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
			)	
				
			if SMTDSettings.UseCustomShader do
			(
				SMTD_MainRollout.Ui_report ">Restoring Scene Shaders..."
				SMTDFunctions.restoreSceneMaterials()
			)
			
			if result != undefined do return result
			
			if RendOutputFilename != "" and SMTDSettings.CreateImsqFile then
			(
				SMTD_MainRollout.Ui_report ">Creating Image Sequence File..."
				path = getFilenamePath RendOutputFilename
				filename = getFilenameFile RendOutputFilename
				imsqFilename = path + filename + ".imsq"
				if ((SMTDFunctions.CreateImsqFile imsqFilename) != true) do return "DEADLINE JOB SUBMISSION:\n\nCould not create Image Sequence file"
				
				if SMTDSettings.CopyImsqFile and SMTDSettings.ImsqOutputPath != "" then
				(
					if ((SMTDFunctions.CreateImsqVbscript SMTDPaths.ImsqVbscriptFile imsqFilename) != true) do return "DEADLINE JOB SUBMISSION:\n\nCould not create Image Sequence Vbscript file"
					SMTDSettings.CopyVbscriptFile = true
				)                                           
			)
			
			try(SMTD_MainRollout.sld_lastSubmissionState.color = yellow)catch()
			
			--TILE SUBMISSION FROM THE LOCAL MACHINE!
			--if SMTDSettings.TilesRendering AND SMTDSettings.TilesSubmissionMode == #local  then
			if SMTDSettings.TilesRendering then
			(
				SMTD_MainRollout.Ui_report ">Initiating Local Tiles Submission..."
				result = SMTDFunctions.spawnTileJobs forceMaxFile:TempMaxFile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
				if result then retCode = #success else retCode = #tileFailure
			)	
			else --REGULAR SUBMISSION
			(
				SMTD_MainRollout.Ui_report ">Initiating Regular Job Submission..."
				local initialArgs = ""
				if SMTDSettings.bgSubmission do initialArgs += "-background -notify "
				if SMTDSettings.dropSubmission do initialArgs += "-drop "
				
				if( SMTDSettings.SubmitScene ) then
					initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile  + "\" \"" + TempMaxFile  + "\" "
				else
					initialArgs += "\"" + SMTDPaths.SubmitInfofile + "\" \"" + SMTDPaths.JobInfofile  + "\" "
				
				--If scripts enabled, send the script files as aux. files:
				if SMTDSettings.SubmitAsMXSJob then
				(
					initialArgs += "\"" + SMTDSettings.MAXScriptFile + "\" "
					SMTD_MainRollout.Ui_report "+This is a MAXScript Job!"
				)
				else
				(
					if SMTDSettings.SubmitExternalFilesMode == 4 then
					(
						initialArgs += "\"" + theBitmapsFileName + "\" " 
						SMTDSettings.RunPreLoadScript = true
						SMTDSettings.PreLoadScriptFile = SMTDFunctions.GetNetworkRoot() + "\\submission\\3dsmax\\DeadlineMaxCacheTexturesOnSlave_PreLoad.ms"
						--initialArgs += "\"" +SMTDSettings.PreLoadScriptFile+ "\" " 
					)	
					
					if SMTDSettings.RunPreLoadScript do initialArgs += "\"" + SMTDSettings.PreLoadScriptFile + "\" "
					if SMTDSettings.RunPostLoadScript do initialArgs += "\"" + SMTDSettings.PostLoadScriptFile + "\" "
					if SMTDSettings.RunPreFrameScript do initialArgs += "\"" + SMTDSettings.PreFrameScriptFile+ "\" "
					if SMTDSettings.RunPostFrameScript do initialArgs += "\"" + SMTDSettings.PostFrameScriptFile + "\" "
					if SMTDSettings.UsePathConfigFile do initialArgs += "\"" + SMTDSettings.PathConfigFile + "\" "
					
					if not (SMTDSettings.RunPostFrameScript or SMTDSettings.RunPreFrameScript) then (
						if (renderers.current.classid as string) == "#(1121714582, 90602926)" then (
							thePreScriptFile = "H:\\max9_synch\\Main\\synch_scripts\\RnD\\Amaretto\\VO_AmarettoPreFrameDataCollection.ms"
							thePostScriptFile = "H:\\max9_synch\\Main\\synch_scripts\\RnD\\Amaretto\\VO_AmarettoPostFrameDataCollection.ms"
							if (doesFileExist thePreScriptFile) and (doesFileExist thePostScriptFile) do (
								initialArgs += "\"" + thePreScriptFile + "\" \"" + thePostScriptFile + "\" "
							)
						)
					)
					
					--SUBMITTING A TILES MASTER JOB OR A REGION RENDERING
					if SMTDSettings.TilesRendering do 
					(
						SMTD_MainRollout.Ui_report ">Tiles Master Job - Adding Tile Submitter Script to Auxiliary Files..."
						local theNetworkPath = SMTDFunctions.GetNetworkRoot()
						theNetworkPath += "\\submission\\3dsmax\\"
						initialArgs += "\"" + theNetworkPath + "maxTileSubmitter.ms\" " 
					)	
					if SMTDSettings.RegionRendering do 
					(
						SMTD_MainRollout.Ui_report ">Region Rendering - Adding Tile Assembler Command to Auxiliary Files For Compatibility..."
						local theNetworkPath = SMTDFunctions.GetNetworkRoot()
						theNetworkPath += "\\submission\\3dsmax\\"
						initialArgs += "\"" + theNetworkPath + "maxTileAssemblerCommand.ms\" " 
					)					
					if SMTDSettings.UseBatchRender do 
					(
						SMTD_MainRollout.Ui_report ">Batch Master Job - Saving SMTD Struct Settings To Auxiliary File"
						local theNetworkPath = SMTDFunctions.GetNetworkRoot()
						theNetworkPath += "\\submission\\3dsmax\\"
						initialArgs += "\"" + theNetworkPath + "maxBatchSubmitter.ms\" "
					)	
					if SMTDSettings.TilesRendering or SMTDSettings.UseBatchRender do 
					(
						SMTD_MainRollout.Ui_report ">Master Job - Saving SMTD Struct Settings To Auxiliary File..."
						SMTDFunctions.saveSettingsStructToMSFile (SMTDPaths.TempDir+ "SubmitterSettingsStruct.ms")
						initialArgs += "\"" + (SMTDPaths.TempDir+ "SubmitterSettingsStruct.ms") + "\" "
					)
					
					if SMTDSettings.CopyVbscriptFile do initialArgs += "\"" + SMTDPaths.ImsqVbscriptFile + "\" "
				)	
				
				--IF FRAMES PREVIEW JOB REQUESTED, SUBMIT TWO JOBS - ONE FOR EVERY NTH, ONE FOR THE REST
				if not SMTDSettings.SubmitAsMXSJob AND SMTDSettings.RenderFramesPreviewJob AND (rendTimeType == 2 or rendTimeType == 3) and NOT SMTDSettings.TilesRendering then
				(
					SMTD_MainRollout.Ui_report ">Submitting Two Jobs: Frame Preview and Remaining Frames..."
					oldPriority = SMTDSettings.Priority
					SMTDSettings.Priority += SMTDSettings.PreviewJobPriorityOffset
					if SMTDSettings.Priority > 100 do SMTDSettings.Priority = 100
					if SMTDSettings.Priority < 0 do SMTDSettings.Priority = 0
					
					--if ((SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile frameMode:#nth) != true) do return "DEADLINE JOB SUBMISSION:\n\nCould not create Submit Info file"
					local result = false
					--eserna modificada - parametros
					if (renderers.current.classid as string == "#(1941615238, 2012806412)" and renderers.current.output_on and renderers.current.output_rawFileName != undefined and renderers.current.output_rawFileName != "" ) then
						result = SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile customOutputFile:renderers.current.output_rawFileName includeBothOutputs:true frameMode:#nth isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
					else
						result = SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile frameMode:#nth isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
					if not result do return "DEADLINE JOB SUBMISSION:\n\nCould not create Submit Info file"
					
					if ((SMTDFunctions.CreateJobInfoFile SMTDPaths.JobInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName) != true) do return "DEADLINE JOB SUBMISSION:\n\nCould not create Job Info file"
					SMTD_MainRollout.Ui_report ">Submitting Frame Preview Job..."
					retcode = SMTDFunctions.waitForCommandToComplete ( initialArgs ) SMTDSettings.TimeoutSubmission
					SMTDSettings.Priority = oldPriority 
					renderMsg = SMTDFunctions.getRenderMessage()
					SMTDFunctions.getJobIDFromMessage renderMsg
					if retCode == #success then
					(
						SMTD_MainRollout.Ui_report ("Frames Preview Job Submitted Successfully.\n\n" + renderMsg) 
						SMTDFunctions.CopyExternalFilesToRepository() --copy files to preview job
						--eserna  - parametros
						SMTDFunctions.SubmitTransferJob isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName -- submits a remote transfer job if necessary
						
						--if ((SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile frameMode:#rest) != true) do return "DEADLINE JOB SUBMISSION:\n\nCould not create Submit Info file"
						local result = false
						if (renderers.current.classid as string == "#(1941615238, 2012806412)" and renderers.current.output_on and renderers.current.output_rawFileName != undefined and renderers.current.output_rawFileName != "" ) then
							result = SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile customOutputFile:renderers.current.output_rawFileName includeBothOutputs:true frameMode:#rest isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
						else
							result = SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile frameMode:#rest isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
						if not result do return "DEADLINE JOB SUBMISSION:\n\nCould not create Submit Info file"
						
						SMTD_MainRollout.Ui_report ">Submitting Remaining Frames Job..."
						retcode = SMTDFunctions.waitForCommandToComplete ( initialArgs ) SMTDSettings.TimeoutSubmission
						renderMsg = SMTDFunctions.getRenderMessage()
						SMTDFunctions.getJobIDFromMessage renderMsg
						if retCode == #success then
						(
							SMTD_MainRollout.Ui_report ("Remaining Frames Job submitted successfully.\n\n" + renderMsg) 
							SMTDFunctions.CopyExternalFilesToRepository() --copy files to main job
							--eserna  - parametros
							SMTDFunctions.SubmitTransferJob isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName -- submits a remote transfer job if necessary
						)	
						else
						(
							SMTD_MainRollout.Ui_report ("Remaining Frames Job Submission FAILED.\n\n" + renderMsg) 
						)
					)	
					else
					(
						SMTD_MainRollout.Ui_report ("Frames Preview Job Submission FAILED.\n\n" + renderMsg) 
					)
				)
				else  --otherwise submit just one job
				(
					SMTD_MainRollout.Ui_report ">Submitting All Frames In One Job..."
					
					--if ((SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile) != true) do return "DEADLINE JOB SUBMISSION:\n\nCould not create Submit Info file"
					local result = false
					if (renderers.current.classid as string == "#(1941615238, 2012806412)" and renderers.current.output_on and renderers.current.output_rawFileName != undefined and renderers.current.output_rawFileName != "" ) then
						result = SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile customOutputFile:renderers.current.output_rawFileName includeBothOutputs:true isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
					else
						result = SMTDFunctions.CreateSubmitInfoFile SMTDPaths.SubmitInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
					if not result do return "DEADLINE JOB SUBMISSION:\n\nCould not create Submit Info file"
					
					if ((SMTDFunctions.CreateJobInfoFile SMTDPaths.JobInfofile isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName) != true) do return "DEADLINE JOB SUBMISSION:\n\nCould not create Job Info file"
					retCode = SMTDFunctions.waitForCommandToComplete ( initialArgs ) SMTDSettings.TimeoutSubmission
					renderMsg = SMTDFunctions.getRenderMessage()
					SMTDFunctions.getJobIDFromMessage renderMsg 
					
					if retCode == #success do
					(
						SMTDFunctions.CopyExternalFilesToRepository()
						--eserna  - parametros
						SMTDFunctions.SubmitTransferJob isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName -- submits a remote transfer job if necessary
					)
				)	
				
			)--end if not local tiles submission		

			---------------------------------------------------------------------------------
			--eserna
			---------------------------------------------------------------------------------
			--renombra el trabajo de render si se está lanzando desde LPM
			if isLPMjob then SMTDSettings.JobName = lpmJobName
			else if isPMjob then SMTDSettings.JobName = pmJobName
			---------------------------------------------------------------------------------
			---------------------------------------------------------------------------------
			
			--If the merging of XRef objects was requested and there were any, restore the copy of the scene from the temp. file
			if (SMTDSettings.MergeXRefsOnSubmission and theXRefObjects.count > 0) or (SMTDSettings.MergeSceneXRefsOnSubmission and theSceneXRefsCount > 0) then
			(
				SMTD_MainRollout.Ui_report ">Restoring Original Scene From Backup File..."	
				SMTDFunctions.RestoreMaxFileCopy SMTDPaths.RestoreTempMaxFile
			)
			else --we only need to restore the paths if the scene was not restored from a temp. file
			(
				if SMTDSettings.SubmitExternalFilesMode > 1  do --and SMTDSettings.SubmitExternalFilesMode < 4
				(
					SMTD_MainRollout.Ui_report ">Restoring Original External File Paths..."	
					SMTDFunctions.restoreExternalReferencePaths()
				)	
			)
			
			if not SMTDSettings.BgSubmission do deleteFile TempMaxFile
			if renderers.current.classid as string == "#(1121714582, 90602926)" then
			(
				SMTD_MainRollout.Ui_report (">Restoring Amaretto Submission Mode to [" + oldAmarettoExportMode+"]" )
				Amaretto.setProperty "Amaretto:PygExportMode" oldAmarettoExportMode 
			)			
			if oldMeditLockedState == true do 
			(
				renderers.medit_locked = true --if the MEdit renderer was previously locked, lock it again.
				SMTD_MainRollout.Ui_report "+Restored the Locked State of the Material Editor Renderer..."
			)
			
			if (maxVersion())[1] >= 10000 do
			(
				for i = 1 to SceneExplorerManager.GetExplorerCount() do
				(
					if oldSceneExplorerStates[i] do
					(
						local name = SceneExplorerManager.GetExplorerName i
						SceneExplorerManager.OpenExplorer name
					)
				)
			)
			
			if oldRenderDialogState do 
			(
				renderSceneDialog.Open() 
				SMTD_MainRollout.Ui_report "+Restored the Open State of the Render Scene Dialog..."
			)	
			if SMTDSettings.ClearMaterialEditorOnSubmission do 
			(
				SMTDFunctions.restoreMaterialEditor()
				SMTD_MainRollout.Ui_report "+Restored the Material Editor Samples..."
				if oldMatEditorOpenState do 
				(
					MatEditor.Open()
					SMTD_MainRollout.Ui_report "+Restored the Material Editor open state..."	
				)	
			)	
			
			if not SMTDSettings.IsBakeJob then
			(
				if renderers.current.classid as string == "#(1941615238, 2012806412)" do
				(
					if renderers.current.output_on and renderers.current.output_saveRawFile then
					(
						if oldVRayVFBState do
						(
							renderers.current.output_useram = true
							SMTD_MainRollout.Ui_report "+Reenabled V-Ray Frame Buffer rendering to RAM."
						)
					)
					else
					(
						if oldVRayVFBState do
						(
							renderers.current.output_on = true
							SMTD_MainRollout.Ui_report "+Reenabled V-Ray Frame Buffer."
						)
						
						SMTDFunctions.RenderElementsRestoreVrayVFB()
					)
				)
			)
			else
			(
				SMTDSettings.SubmitAsMXSJob = oldMaxScriptFile
				SMTDSettings.MAXScriptFile = oldSubmitMaxScript
				SMTD_MainRollout.Ui_report "+Restored MaxScript Job Settings."
			)
			
			if SMTDSettings.OverrideLowPriorityThread do
			(
				try (
					if VRAY_lowThreadPriority do (
					renderers.current.system_lowThreadPriority = true
					SMTD_MainRollout.Ui_report ("+Restored V-Ray Low Thread Priority to [true].")
					)
				)catch()
				try (
					if BRAZIL_lowThreadPriority do (
					renderers.current.low_priority_thread_on = true
					SMTD_MainRollout.Ui_report ("+Restored Brazil Low Thread Priority to [true].")
					)
				)catch()
			)
			
			--si se esta lanzando desde lpm, no se deben cambiar los paths de los render elements
			if not (isLPMjob or lpmJobName != "" or isPMjob or pmJobName != "") then
				if SMTDSettings.RenderElementsUpdatePaths do
				(
					if not SMTDSettings.RenderElementsPermanentChanges do 
					(
						SMTDFunctions.RenderElementsRestorePaths()
						SMTD_MainRollout.Ui_report ">Restored the Render Elements Paths..."
					)	
				)	
				
			case retCode of
			(
				#success:
				(
					local copyResult = 0
					SMTDSettings.DeadlineSubmissionSuccessful = true
					try(FF_AssetTracker_Functions.TrackDeadlineRender SMTDSettings.DeadlineSubmissionLastJobID)catch()
					
					--PRIME FOCUS INTERNAL: Output Camera Info Data to Render Output Folder:
					if PFPPL_RenderPassFunctions != undefined and rendOutputFilename != "" do 
					(
						local theViewCamera = viewport.getCamera()
						if theViewCamera != undefined do
						(	
							local frameList = for t = (animationrange.start.frame as integer)  to (animationrange.end.frame as integer) collect t							
							PFPPL_RenderPassFunctions.saveCameraInfoFiles (getFileNamePath rendOutputFilename+ "camData\\") theViewCamera frameList
						)
					)					
					
					if SMTDSettings.QuicktimeGenerate AND not SMTDSettings.TilesRendering do SMTDFunctions.AutomaticQuicktimeGeneration isLPMjob:isLPMjob lpmJobName:lpmJobName isPMjob:isPMjob pmJobName:pmJobName
					
					if copyResult == 0 then
						try(SMTD_MainRollout.sld_lastSubmissionState.color = green; SMTD_MainRollout.sld_lastSubmissionState.value = 100)catch()
					else	
						try(SMTD_MainRollout.sld_lastSubmissionState.color = red*0.75 + green*0.5; SMTD_MainRollout.sld_lastSubmissionState.value = 100)catch()
						
					try
					(
						local theFn =  (getIniSetting SMTDPaths.InIFile "Scripts"  "PostSubmissionFunction")
						if theFn != "" then
						(
							execute theFn
							try(SMTD_MainRollout.Ui_report ("+Executed Post-Submission Function: "+  theFn) )catch()
						)
					)
					catch
					(
						try(SMTD_MainRollout.Ui_report ("--Failed To Execute Post-Submission Function: "+  theFn) )catch()
					)	
						
					("+JOB SUBMITTED SUCCESSFULLY.\n\n" + renderMsg)
				)--end success	
				#failed:
				(
					try(SMTD_MainRollout.sld_lastSubmissionState.color = red; SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
					("--DEADLINE JOB SUBMISSION FAILED:\n\nFailed to submit job.\n\n" + renderMsg)
				)--end failed	
				#readerror:
				(
					try(SMTD_MainRollout.sld_lastSubmissionState.color = red; SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
					("--DEADLINE JOB SUBMISSION FAILED:\n\nRead Error.\n\n" + renderMsg)
				)--end read error
				#timeout:
				(
					try(SMTD_MainRollout.sld_lastSubmissionState.color = red; SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
					("--DEADLINE JOB SUBMISSION TIMED OUT AFTER "+ SMTDSettings.TimeoutSubmission as string +" SECONDS!\nConsider increasing the Job Submission Timeout in the User Options tab.\n\n")
				)
				default: 
				(
					try(SMTD_MainRollout.sld_lastSubmissionState.color = red; SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
					("--DEADLINE JOB SUBMISSION FAILED FOR UNKNOWN REASON.\n\n")			
				)
				#tileFailure: 
				(
					try(SMTD_MainRollout.sld_lastSubmissionState.color = red; SMTD_MainRollout.sld_lastSubmissionState.value = 100.0)catch()
					("--DEADLINE DISTRIBUTED TILES JOB SUBMISSION FAILED.\n\n" + renderMsg)			
				)
			)--end retCode case
			
		)--end submit job fn	
	)--SMTDFunctions
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
)
