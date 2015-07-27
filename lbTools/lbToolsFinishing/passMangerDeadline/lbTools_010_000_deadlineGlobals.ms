(
	----------------------------------------------------------------------------------------
	--plugins
	global SMTD_RegionRendering
	global SMTD_TilesRendering
	----------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------
	--funciones
	global SMTD_MainRollout		--contains the main rollout (dialog)
	global SMTDFunctions			--contains the structure of functions 
	global SMTDPaths				--contains the structure of paths
	global SMTDSettings 			--contains the structure of settings
	global SMTD_SceneMaterials = #()	--used to collect all scene materials for custom shader rendering
	global SMTD_LastMessage = ""
	global SMTD_objsToBake
	global sfs						-- makes sure the brazil structure is predefined
	
	global SMTDExternalRefsArray
	----------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------
	--sanitycheck
	global SMTD_PerformSanityCheck 

	global SMTD_SanityCheck_errorReportRollout
	global SMTD_SanityCheck_actionsArray = #()
	global SMTD_ErrorMessagesArray = #()	
	global SMTD_SanityCheck_errorReportIndexArray = #()

	global SMTD_SanityCheckFunctions
	global SMTD_RepairFunctions 
	global SMTD_SanityChecksToPerform

	global SMTD_Private_SanityCheckFunctions
	global SMTD_Private_RepairFunctions 
	global SMTD_Private_SanityChecksToPerform
	----------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------
	--sanitycheck general
	global SMTD_SanityCheckFunctions
	global SMTD_RepairFunctions 
	global SMTD_SanityChecksToPerform
	global SMTD_SanityCheck_errorReportRollout
	
	global SMTD_SanityChecksToPerform 
	----------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------
	--sanitycheck private
	global SMTD_Private_SanityCheckFunctions
	global SMTD_Private_SanityChecksToPerform
	global SMTD_Private_RepairFunctions 

	global SMTD_RepairFunctions
	global SMTD_SanityChecksToPerform
	global SMTD_SanityCheckFunctions
	----------------------------------------------------------------------------------------
)