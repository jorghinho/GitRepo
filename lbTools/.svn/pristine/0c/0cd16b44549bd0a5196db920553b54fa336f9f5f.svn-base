-----------------------------------------------------------------------------------------------------------------------------------------------
--THIS FILE CONTAINS THE GENERAL CHECKS TO BE PERFORMED AND THE FUNCTIONS
--TO BE USED TO CHECK AND REPAIR THE SCENE BEFORE SUBMISSION
-----------------------------------------------------------------------------------------------------------------------------------------------
--THIS FILE MAY BE UPDATED BY PRIME FOCUS WHEN DEADLINE IS UPDATED.
--MODIFY AT YOUR OWN RISK!
-----------------------------------------------------------------------------------------------------------------------------------------------
(
-- 	global SMTD_SanityCheckFunctions
-- 	global SMTD_RepairFunctions 
-- 	global SMTD_SanityChecksToPerform
-- 	global SMTD_SanityCheck_errorReportRollout

	struct SMTD_SanityCheckFunctions
	(
		fn CheckForEmptyScene = 
		(
			(objects as array).count > 0
		),
		fn CheckForLockedViewport =
		(
			-- option only available in 3dsmax 2009 and later
			if( ((maxVersion())[1]/1000 as integer) > 10 ) then
				rendUseActiveView
			else
				true
		),
		fn CheckForDuplicateCameraName =
		(
			duplicatesFound = false
			
			local theCameras = for o in objects where findItem Camera.classes (classof o) > 0 collect o
			local theObjects = for o in objects where findItem Camera.classes (classof o) == 0 collect o
			if (theCameras as array).count > 0 then
			(
				for i = 1 to theCameras.count do
				(
					cameraName = theCameras[i].name
					for j = (i + 1) to theCameras.count do
					(
						if cameraName == theCameras[j].name then
						(
							duplicatesFound = true
							exit
						)
					)
					
					if duplicatesFound then exit
					
					for j = 1 to theObjects.count do
					(
						if cameraName == theObjects[j].name then
						(
							duplicatesFound = true
							exit
						)
					)
					
					if duplicatesFound then exit
				)
			)
			
			duplicatesFound == false
		),
		fn CheckForCameraView =
		(
			if (renderers.current.classid as string) != "#(272052741, 712862621)" then
				viewport.getCamera() != undefined
			else
				true
		),
		fn CheckForMaxwellCameraView =
		(
			if (renderers.current.classid as string) == "#(272052741, 712862621)" then
				viewport.getCamera() != undefined
			else
				true
		),
		fn CheckForMPassRenderer =
		(
			rendClass = substring (( classof renderers.current) as string) 1 3
			rendClass == "Bra" or rendClass == "Def"
		),
		fn CheckForRenderingSingleFrame =
		(
			if ( not SMTDSettings.RemovePadding ) then
				rendTimeType > 1
			else
				true
		),
		fn CheckForRenderingMultiFrame =
		(
			if ( SMTDSettings.RemovePadding ) then
				rendTimeType == 1
			else
				true
		),
		fn CheckForRenderOutputPath =
		(
			rendOutputFilename != ""
		),
		fn CheckForRenderOutputSaveFlag =
		(
			rendOutputFilename == "" OR rendSaveFile 
		),		
		fn CheckForRestartRenderer =
		(
			local rendererID = case (renderers.current.classid as string) of
			(
				"#(1, 0)": "scanline"
				"#(1387076610, 288174012)": "brazil"
				"#(95494396, 474502030)": "brmax"
				"#(1492548972, 1338981315)": "mentalray"
				"#(1941615238, 2012806412)": "vray"
				default: ""
			)
			
			if ( not SMTDSettings.RestartRenderer ) and ( rendererID == "brazil" or rendererID == "vray" or rendererID == "brmax" ) then
				false
			else
				true
		),
		fn CheckForRenderOutputTrail =
		(
			if ( rendTimeType > 1 ) then
			(
				theFileName = getFileNameFile rendOutputFilename
				theFileType = getFileNameType rendOutputFilename
				if not matchPattern theFileType pattern:"*mov" and not matchPattern theFileType pattern:"*avi" then
				(
					if theFileName.count > 3 then
						not (try((classof (execute (substring theFileName theFileName.count 1)) == Integer and classof (execute (substring theFileName (theFileName.count-3) 4)) != Integer ))catch(false))
					else
						true
				)
				else true
			)
			else
				true
		),
		fn CheckForRenderOutputMovie =
		(
			theFileType = getFileNameType rendOutputFilename
			not (matchPattern theFileType pattern:"*mov" or matchPattern theFileType pattern:"*avi")
		),
		fn CheckForUntitledFile =
		(
			MaxFileName != ""
		),
        
		fn CheckForDistributedRendering =
		(
			try
			(
				theRenderClass = substring ((classof renderers.current) as string) 1 3
				case theRenderClass of
				(
					"men" : not (renderers.current.DistributedEnable)
					"VRa" : not (renderers.current.system_distributedRender)
					"V_R" : not (renderers.current.system_distributedRender)
					default: true
				)
			)catch(true)
		),
		
		fn CheckForKrakatoaCacheState =
		(
			if renderers.current.classid as string == "#(-1204370534, -399920359)" then
				not (FranticParticles.GetBoolProperty "EnableParticleCache")
			else
				true
		)		
	)
	
	struct SMTD_RepairFunctions
	(
		fn doNothing = 
		(
			true
		),
		fn cannotFix =
		(
			SMTD_SanityCheck_errorReportRollout.log_action "FATAL" (color 0 0 255) true  ("Please load a new MAX file or create/merge objects before submitting!")
		),	
		fn SuggestPossibleCamera = 
		(
			local theCameras = for o in objects where findItem Camera.classes (classof o) > 0 collect o
			if (theCameras as array).count > 0 then
			(
				possibleCamera = SelectByName single:true title:"Select Camera to Submit to Deadline:" filter:(fn filterCamera obj = (superclassof obj == Camera))
				if possibleCamera != undefined then
				(
					viewport.setCamera possibleCamera 
					SMTD_SanityCheck_errorReportRollout.log_action "Fixed" (color 0 155 0) true ("Camera ["+ possibleCamera.name +"] set in the current viewport.")
				)	
				else
					SMTD_SanityCheck_errorReportRollout.log_action "FAILED" (color 0 0 255) true "No Camera was selected."
			)	
			else
				SMTD_SanityCheck_errorReportRollout.log_action "FAILED" (color 0 0 0) true "There are NO CAMERAS in the scene."

		),
		fn EnableMPassMBlur = 
		(
			theCam = viewport.getCamera() 
			if theCam != undefined do 
			(
				if classof theCam.mpassEffect != Motion_BlurMPassCamEffect do 
					theCam.mpassEffect = Motion_BlurMPassCamEffect()
				theCam.mpassEnabled = true
				SMTD_SanityCheck_errorReportRollout.log_action "Fixed" (color 0 155 0) true ("Enabled MultiPass Motion Blur in Camera ["+theCam.name+"]")
			)	
		),
		fn FixLockedViewport =
		(
			-- option only available in 3dsmax 2009 and later
			if( ((maxVersion())[1]/1000 as integer) > 10 ) do
			(
				renderSceneDialog.close()
				rendUseActiveView = true
				renderSceneDialog.open()
				SMTD_SanityCheck_errorReportRollout.log_action "Fixed" (color 0 155 0) true "Locked viewport disabled"
			)
		),
		fn FixRenderingSingleFrame =
		(
			renderSceneDialog.close()
			rendTimeType = 2
			renderSceneDialog.open()
			SMTD_SanityCheck_errorReportRollout.log_action "Fixed" (color 0 155 0) true "Rendering Output Time changed to ACTIVE TIME SEGMENT"
		),
		fn FixRenderingMultiFrame =
		(
			renderSceneDialog.close()
			rendTimeType = 1
			renderSceneDialog.open()
			SMTD_SanityCheck_errorReportRollout.log_action "Fixed" (color 0 155 0) true "Rendering Output Time changed to SINGLE FRAME"
		),
		fn FixRenderOutputPath =
		(
			renderSceneDialog.open()
			SMTD_SanityCheck_errorReportRollout.log_action "Hint" (color 155 0 0) false "In the Render Scene Dialog, Pick a valid path, then re-test!"
		),
		fn FixRenderOutputSaveFlag =
		(
			renderSceneDialog.close()
			rendSaveFile = true
			renderSceneDialog.open()
		),
		fn FixRestartRenderer =
		(
			SMTDSettings.RestartRenderer = true
			setIniSetting SMTDPaths.InIFile "RenderingOptions"  "RestartRenderer" (SMTDSettings.RestartRenderer as string)
		),
		fn FixRenderOutputTrail =
		(
			rendOutputFilename = getFileNamePath rendOutputFilename + getFileNameFile rendOutputFilename + "_" + getFileNameType rendOutputFilename
		),
		fn FixRenderOutputMovie =
		(
			renderSceneDialog.open()
			SMTD_SanityCheck_errorReportRollout.log_action "Hint" (color 155 0 0) false "In the Render Scene Dialog, please select a single frame format, then re-test!"
		),
		fn SaveUntitledFile =
		(
			SMTD_SanityCheck_errorReportRollout.log_action "Hint" (color 155 0 0) false "File>Save As dialog is OPEN. Please save the scene to a file, then re-test!"
			max file save 
		),
		fn FixDistributedRendering =
		(           
			try
			(
				theRenderClass = substring ((classof renderers.current) as string) 1 3
				case theRenderClass of
				(
					"men" : renderers.current.DistributedEnable = false
					"VRa" : renderers.current.system_distributedRender = false
					"V_R" : renderers.current.system_distributedRender = false
		                )
			)
			catch()
		),
		fn FixKrakatoaCache =
		(
			try(
				FranticParticles.SetProperty "EnableParticleCache" "false"
				FranticParticles.SetProperty "EnableLightingCache" "false"
				SMTD_SanityCheck_errorReportRollout.log_action "Fixed" (color 0 155 0) true "Krakatoa PCache and LCache turned OFF."
				Krakatoa_GUI_Main.refresh_GUI()
			)catch()
		)
		
	)
	
	global SMTD_SanityChecksToPerform =
	#(
		#(SMTD_SanityCheckFunctions.CheckForEmptyScene, #fail, "The scene does not contain ANY objects!", SMTD_RepairFunctions.cannotFix, true ),
		#(SMTD_SanityCheckFunctions.CheckForDuplicateCameraName, #fail, "The scene contains objects or groups with the same name as a camera!", SMTD_RepairFunctions.cannotFix, true ),
		#(SMTD_SanityCheckFunctions.CheckForRenderOutputPath, #fix, "The Render Output Path is NOT DEFINED!", SMTD_RepairFunctions.FixRenderOutputPath, true),
		#(SMTD_SanityCheckFunctions.CheckForRenderOutputSaveFlag, #fix, "The Render Output Save File Checkbox is NOT CHECKED! No Frames Will Be Saved!", SMTD_RepairFunctions.FixRenderOutputSaveFlag, true),
		#(SMTD_SanityCheckFunctions.CheckForUntitledFile, #fix, "The current Scene Name is Untitled.", SMTD_RepairFunctions.SaveUntitledFile, true),
		#(SMTD_SanityCheckFunctions.CheckForDistributedRendering, #fix, "The Distributed Rendering option is enabled for this renderer.", SMTD_RepairFunctions.FixDistributedRendering, true),
		#(SMTD_SanityCheckFunctions.CheckForCameraView, #fix, "The current view is NOT a Camera.", SMTD_RepairFunctions.SuggestPossibleCamera, true),
		#(SMTD_SanityCheckFunctions.CheckForMaxwellCameraView, #fail, "Maxwell is the renderer and the current view is NOT a Camera.", SMTD_RepairFunctions.SuggestPossibleCamera, true),
		#(SMTD_SanityCheckFunctions.CheckForRenderingSingleFrame, #fix, "The Render Time Output is set to SINGLE FRAME!", SMTD_RepairFunctions.FixRenderingSingleFrame, true),
		#(SMTD_SanityCheckFunctions.CheckForRenderingMultiFrame, #fix, "The Render Time Output is NOT set to single frame, and Remove Filename Padding is enabled!", SMTD_RepairFunctions.FixRenderingMultiFrame, true),
		#(SMTD_SanityCheckFunctions.CheckForRenderOutputTrail, #fix, "The Render Output File Name ends with a DIGIT - trailing numbers might fail.", SMTD_RepairFunctions.FixRenderOutputTrail, true),
		#(SMTD_SanityCheckFunctions.CheckForKrakatoaCacheState, #fix, "The current Renderer is Krakatoa and Particle Cache is ON!", SMTD_RepairFunctions.FixKrakatoaCache , true),
		#(SMTD_SanityCheckFunctions.CheckForRenderOutputMovie, #warn, "The Render Output is set to a MOVIE format.", SMTD_RepairFunctions.FixRenderOutputMovie, true),
		#(SMTD_SanityCheckFunctions.CheckForRestartRenderer, #warn, "Restart Renderer Between Frames is disabled and VRay or Brazil is the selected renderer.", SMTD_RepairFunctions.FixRestartRenderer, true),
		#(SMTD_SanityCheckFunctions.CheckForLockedViewport, #warn, "Viewport is currently locked, which can result in incorrect renders with Deadline.", SMTD_RepairFunctions.FixLockedViewport, true)
	)	
)	