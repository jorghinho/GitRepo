(
	--Incrementa el espacio de memoria reservado de max ----------------
	try (heapSize = 400000000) catch()

	---------------------------------------------------------------------------
	-------------------- VARIABLES GLOBALES y LOCALES ------------
	---------------------------------------------------------------------------
	
	global toolsCfgPath			= "$plugins\\stdscripts\\lbTools\\toolsCfg"
	global toolsLogPath			= "$plugins\\stdscripts\\lbTools\\log"
	global toolsMacrosPath	= (getDir #ui) + "macroscripts\\lbTools\\"
	if (maxVersion())[1] >= 15000 then toolsMacrosPath = (getDir #maxroot) + "Macroscripts\\lbTools\\"
	global chrShapesPath		= "Z:\\resource\\technical\\max\\rigging\\animation controls\\chrShapes.max"
	global riggingShapesPath	= "Z:\\resource\\technical\\max\\rigging\\animation controls\\riggingShapes.max"
	global rigSolutionsPath		= "$plugins\\stdscripts\\lbTools\\RS"
	global exePath				= "$plugins\\stdscripts\\lbTools\\exe"
	
	global lastUsedPath --ultimo path usado en una herramienta, para que te abra los dialogos en la ultima ruta usada
	
	global iconsPath				= (getDir #ui) + "/macroscripts/lbTools/icons/"
	if (maxVersion())[1] >= 15000 then iconsPath = (getDir #maxroot) + "Macroscripts\\lbTools\\icons\\"
	global imagesPath			= "$plugins\\stdscripts\\lbTools\\image"
	
	
	global LB_VARs_aaa001reservedWords	= #(#toolsCfgPath,#rigSolutionsPath,#iconsPath)

	-------------------------------------------
	--rollouts globales
	-------------------------------------------
	
	--stdscripts
	global rollAssetBrowser
	global rollNotifications
	
	--assetChecker
	global rollAssetChecker
	
	--assetList
	global rollAssetList
	
	--assetManager
	global rollAssetManagerMini
	global rollFltAssetManager
	global rollAMassets, rollAMtabs, rollAManimation, rollAMprepareAnimation, rollAMcopies, rollAMcacheExtras, rollAMcache, rollAMcloth, rollAMhair, rollAssetManagerFlags
	
	--cameraManager
	global rollFltCameraManager
	global rollCMcontainer, rollCMmain, rollCMpreview, rollCMinfo, rollCMcameraGrid
	
	--cameraGrid
	global rollCameraGrid
	
	--channelBox
	global rollCBID
	global rollCBtools
	global rollCBconfigure
	global rollCBvalueEdit
	global rollChannelBox
	global rollCBkeyTangents
	
	--eyeRigger
	global rollFltEyeRigger, rollEReyeRigger
	
	--freezeTransforms
	global rollFltFreezeTransforms
	global rollFreezeTransforms
	global rollFreezePose
	global rollFTsettings
	
	--fxSpringSolvers
	global rollSpringSolvers
	
	--meatSlicer
	global rollMeatSlicer
	
	--messageBox
	global rollMessageBox
	global rollQueryBox
	
	--miscellaneous
	global rollResetXForm
	
	--morpherManager
	global rollMorpherManager
	global rollMaskConnection
	
	--namingConventionChecking
	global rollNC, rollNChelp, rollNCflagsManage, rollNamingConventionInfo

	--nodeInfoManager
	global rollNodeInfo
	
	--poseManager
	global rollPoseManager
	
	--renamer
	global rollRenamer
	
	--renderLayers
	global rollRenderLayersOverridesManager
	global rollRenderLayers
	
	--renderManager
	global rollFltRenderManager
	global rollRMGtabs
	
	global rollRMGocclusionPreview
	global rollRMGgammaCorrection
	
	global rollRMGpathRedirect, rollRMGpathRedirectList

	--rigging manager
	global rollFltRiggingManager
	global rollRMtabs
	
	global rollRMxrefMeshManager
	global rollRMfigureMode, rollRMskinConnectionInfo, rollRMtwistManager, rollRMstretchBoneChain --rollouts de skin rig
	global rollRMextraDuplicator, rollRMautoRig, rollRMmeatSlicer, rollRMpuppetAttachDetach, rollRMrootCircle, rollRMpuppetPropGenerator, rollRMfootstepPivots, rollRMvirtualParents --rollouts de anim rig
	global rollRMmergeFacialRig, rollRMheadSystemModifier
	global rollRMskinModifier, rollRMskinBones, rollRMskinVertexTools, rollRMskinMorphModifier
		
	--riggingTools
	global rollFltRiggingTools
	global rollRTtabs
	
	global rollRTVirtualParent, rollRTPuppet, rollRTskinConnectionInfoCheck, rollRTlocksManager, rollRThierarchyGradient
	global rollRTflipNormals, rollRTffdTools
	global rollRTbonesFromToPoints, rollRTBoneTools, rollRTBoneOffsets
	global rollRTlinkConstraint, rollRTconstraints, rollRTpathConstraint
	
	--teethRigger
	global rollTeethRigger
	
	--vertexColorManager
	global rollVCmanager
	
	-------------------------------------------
	-------------------------------------------
	
	-----------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------
	--GLOBALES DE LPM
	-----------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------
	--VARIABLES
	---------------------------------------------------------------------------------------------------------------
	
	--custom attributes-----------------------------------------
	global rootCA
	global LPM_shotRootCA
	global LPM_shotCA
	global LPM_PassGroupCA
	global passCA
	global labelSeparatorCA
	global renderPropsCA
	global LPM_XrefSceneCA
	global commonPropsCA
	global envEffectCA
	global lodSetCA --para sets de objetos a los que cambiar los niveles de detalle de texturas, turbosmooth...
	global objectSetCA
	global lightSetCA
	global photoStudio_DataCA
	global LPM_scriptCA
	global LPM_emptyCA
	global LPM_genericCA
	
	global customPassCA --para pases especiales como Y, Z, AO
	global LPM_noOutputCA --para indicarle a un pase que no debe sacar output del mismo
	global renderPropertiesBackupCA --para indicar que se trata del nodo temporal donde se almacenan la propiedades actuales de render para hacer backup
	global mentalRayRenderPropsCA --para almacenar las propiedades de mental ray
	global scanlineRenderPropsCA --para almacenar las propiedades de scanline
	global vueRenderPropsCA --para almacenar las propiedades de vue
	
	global LPM_customAttributesArray = #(rootCA, LPM_shotRootCA, LPM_shotCA, LPM_PassGroupCA, passCA, renderPropsCA, labelSeparatorCA, \
		LPM_XrefSceneCA, commonPropsCA, envEffectCA, lodSetCA, objectSetCA, lightSetCA, photoStudio_DataCA, LPM_scriptCA, LPM_emptyCA, LPM_genericCA, \
		customPassCA, LPM_noOutputCA, renderPropertiesBackupCA, mentalRayRenderPropsCA, scanlineRenderPropsCA, vueRenderPropsCA)
	---------------------------------------------------------------
	
	--structs de funciones---------------------------------------
	--en estas variables se almacenaran los structs con las funciones generales y de render, pero no son la definicion de los structs en si
	global LPM_Fun
	global LPM_Render
	
	--variables para la definicion de los structs en si
	global LPM_Fun_Struct
	global LPM_RenderAPI
	---------------------------------------------------------------
	
	--funciones accesibles en toda la herramienta--------------
	global LPM_hardwareRender
	global LPM_renderPass
	global LPM_renderer_closed --se la llama desde el callback que salta al cerrarse el cuadro de dialogo de render
		
	global redefineLPMCustAttribute
	global redefineLPMCustAttributes
	global callbacRedefineLPMCustomAttributes
		
	global resetUI --funcion que resetea el interface, se usa cuando se cambia de escena, par ano tener que reiniciar la herramienta
	---------------------------------------------------------------
	
	--menus de boton derecho-----------------------------------
	global rc_MainMenu
	global rc_RootMenu
	global rc_shotRootMenu
	global rc_PassGroup
	global rc_shotMenu
	global rc_shotPassMenu
	global rc_PassMenu
	global rc_ObjectSetMenu
	global rc_LodSetMenu
	global rc_matMenu
	global rc_objectMenu
	global rc_layerMenu
	global rc_wildCardMenu
	global rc_namedSetMenu
	global rc_xrefScene
	global rc_customPassMenu --menu para los pases especiales Y, Z y AO
	global rc_noOutputMenu --menu de los nodos de tipo noOutput
	global rc_photoStudioMenu
	global rc_scriptMenu
	global rc_atmPropsMenu
	global rc_RenderPropsMenu
	global rc_commonPropsMenu
	---------------------------------------------------------------
	
	--plugins-----------------------------------------------------
	global LPM_NetworkPlugins = #() --array donde se almacenaran los plugins
	
	global LPM_BackburnerAPI
	global LPM_DeadlineAPI
	global LPM_EnFuzionSubmitAPI
	global LPM_MaxFileSubmitAPI
	
	--variables necesarias como globales en LPM_DeadlineAPI
	global SMTDSettings
	global SMTDFunctions
	---------------------------------------------------------------
	
	--otras variables---------------------------------------------
	global LPM_Root --variable para almacenar el nodo root de LPM
	--global LPM_multiCameraRo --no se usa??
	--global LPM_Data --no se usa???
	global LPM_activePass --almacena el pase activo actualmente
	global LPM_LoadingPreset --flag para saber si hay que cargar/salvar un preset o no
	global LPM_oldRenderSettings --almacena la ultima configuracion de render utilizada
	--------------------------------------------------------------
	
	--operators--------------------------------------------------
	global LPM_Operators --variable para almacenar el struct del api de operadores
	global LPM_operatorAPI --struct del api de operadores
	
	--operadores
	global LPM_modifyObjectOperator --operador de modificadores de objetos
	---------------------------------------------------------------
	
	--rollouts-----------------------------------------------------
	
	--añadidos por ESERNA como globales
	global LPM_RenderRo --rollout de dialogo de render. se lanza desde rc_MainMenu
	global LPM_BackburnerSubmitRo --rollout de gestion de envio de render a backburner, se lanza desde el struct LPM_BackburnerAPI
	global LPM_Error --rollout de error de envio de un trabajo al backburner, se lanza desde el struct LPM_Backburner
	global LPM_DeadlineSubmitRo --rollout de gestion de envio de render a deadline, se lanza desde el struct LPM_DeadlineAPI
	global LPM_EnFuzionSubmit_Ro --rollout de gestion de envio de render a enfuzion, se lanza desde el struct LPM_EnFuzionSubmitAPI
	global LPM_MaxFileSubmit_Ro --rollout de gestion de envio de render por archivos max, se lanza desde el struct LPM_MaxFileSubmitAPI
	
	global LPM_rendererPicker --rollout para elegir el motor de render para el override, se lanza desde el menu de boton derecho de render override
	
	global AboutRO
	global lightSetProps
	global objectSetProps
	global lodSetProps
	global wildCardRO
	global LPM_scriptRO
	global atmRollout
	global commonRollout
	global customPassProps
	
	global LPM_treeview_rollout --rollout principal
	---------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------
	
	-------------------------------------------
	--animationFunctions
	-------------------------------------------
	global setKeysTangents
	global deleteAnimation
	global getSelectedKeys
	global getAnimRange
	global setTrackLocks
	global collapseObjectControllersByTransform
	global collapseObjectControllers
	global isObjectAnimated
	global isLinkConstraintAnimated
	
	-------------------------------------------
	--animInfo functions
	-------------------------------------------
	global strAnimTrack
	global isTrackKeyable

	global hasAnimTracks
	global getAnimTracks
	global renameAnimTracksSeparators
	global getSelectedKeys
	global setKeysTangents
	global deleteAnimation
	global getTracks
	global getTracksCustAttributes
	global getTracksFromBipedObject
	global getnumtracks
	global getnumtracksCustAttributes
	global totalNumTracks
	global tracksCount
	global getTracksFromObject
	global initAnimTracks
	global removeAnimTracks
	global setAnimTracks
	global setAnimTracksDefaults
	global setDefaultAnimTrackValue
	global replaceAnimTracks
	global isAnimTrack
	global animTracksReady
	global hasAnimTracksKey
	global createAnimTracksKey
	global createAnimTracksKeyToSet
	global removeAnimTracksKey
	global setTracksValue
	global setAnimTracksValue

	--global LB_FNs_animInfo functions = #(#hasAnimTracks,#getAnimTracks,#renameAnimTracksSeparators,#getSelectedKeys,#setKeysTangents,#deleteAnimation,#getTracks,#getTracksCustAttributes,#getTracksFromBipedObject,#getnumtracks,#getnumtracksCustAttributes,#totalNumTracks,#tracksCount,#getTracksFromObject,#initAnimTracks,#removeAnimTracks,#setAnimTracks,#setAnimTracksDefaults,#setDefaultAnimTrackValue,#replaceAnimTracks,#isAnimTrack,#animTracksReady,#createAnimTracksKey,#createAnimTracksKeyToSet,#removeAnimTracksKey,#setTracksValue,#setAnimTracksValue)
	global LB_FNs_animInfoFunctions = #(#hasAnimTracks,#getAnimTracks,#renameAnimTracksSeparators,#getSelectedKeys,#setKeysTangents,#deleteAnimation,#getTracks,#getTracksCustAttributes,#getTracksFromBipedObject,#getnumtracks,#getnumtracksCustAttributes,#totalNumTracks,#tracksCount,#getTracksFromObject,#initAnimTracks,#removeAnimTracks,#setAnimTracks,#setAnimTracksDefaults,#setDefaultAnimTrackValue,#replaceAnimTracks,#isAnimTrack,#animTracksReady,#createAnimTracksKey,#createAnimTracksKeyToSet,#removeAnimTracksKey,#setTracksValue,#setAnimTracksValue)
	-------------------------------------------

	-------------------------------------------
	--asset management
	-------------------------------------------
	global sceneAssets
	--global sceneAssetsNames
	global listedAssets
	global selAsset
	global selAssets
	global assetFilters --= #(NC_chrPrefix, NC_prpPerfix, NC_sprPrefix, NC_setPrefix)
	-------------------------------------------

	-------------------------------------------
	--asset browser
	-------------------------------------------
	--rollouts
	global rollAssetBrowser
	-------------------------------------------

	-------------------------------------------
	--AssetListFunctions
	-------------------------------------------
	global showAssetList
	global hideAssetList
	-------------------------------------------

	-------------------------------------------
	--AssetFunctions
	-------------------------------------------
	--Structs
	global asset
	global sceneAssetInfo
	
	--Arrays
	global fxParticleFlowClasses
	--Functions
	global getSceneLayers
	global sortAssets
	global getAssetXRefScene
	global getAssetNodesFromXrefScenes
	global getMainAsset
	global getDependentAssets
	global getDependencyGroup
	global getAssetDependentLinkedObjects
	global getAssetParentLinkedObjects
	global setAssetDependencies
	global fillAssetInfo
	global getSceneAssets
	global getSceneAnimAssets
	global getAssetsFromNodes
	global getAssetNodes
	global getAssetNodesByType
	global getAssetAnimNodes
	global getAssetRootNode
	global getSPRrootNodes
	global getAssetPosition
	global getAssetRotation
	global getAssetScale
	global getNewAssetCopyNumber
	global setAssetCopyNumber
	global copyAsset
	global copyObjects
	global getHiddenPercent
	global getFrozenPercent
	global getNodesState
	global getAssetNodesState
	global setHiddenState
	global setFrozenState
-- 	global isSkinConnected
	global setSkinConnection
-- 	global toggleSkinConnection
	global hideAsset
	global isolateAsset
	global isolateAssets
	global hasPuppet
	global selectAssetRigObjs
	global selectAssetPiecesByFlag
	global setBoxMode
	global findPuppet
	global hideSecPuppets
	global showSecPuppets
	global enableAssetTurbosmooths
	global disableAssetTurbosmooths
	global fillAssetVisModeArrays
	global showExtraControls
	global hideExtraControls
	global showHeadSystem
	global setAssetSkinConnectionMode
	global setAssetPuppetMode
	global setAssetPuppetHeadMode
	global setAssetHeadMode
	global setAssetSkinMode
	global setAssetSkinBoxMode
	global setAssetBoxMode
	global setAssetClothMode
	global setAssetSkinClothMode
	global setAssetHairMode
	global setAssetSkinHairMode
	global setAssetConnectAllMode
	global resetAsset
	global getAssetVisMode
	global findAssetByName
	global getAssetFolder
	global getAssetIconFiles
	global getAssetIcon
	global getDuplicatedNameNodes
	global deleteAsset
	global loadAsset
	global saveAnimation
	global getAssetAnimRange
	global loadAnimation
	global getSelSetObjects
	global addObjectsToSelectionSet
	global getAssetFileName
	global readSceneAssetInfo
	global saveSceneAssetInfo
	global getAssetMaterials
	global renameAsset
	global getCamAssetsFromProdFile
	global isAssetVisible
	
	--global LB_FNs_Asset Functions = #(#getSceneLayers,#sortAssets,#getAssetXRefScene,#getAssetNodesFromXrefScenes,#getMainAsset,#getDependentAssets,#setAssetDependencies,#getSceneAssets,#getSceneAnimAssets,#getAssetsFromNodes,#getAssetNodes,#getAssetNodesByType,#getAssetAnimNodes,#getAssetRootNode,#getAssetPosition,#getNewAssetCopyNumber,#setAssetCopyNumber,#copyAsset,#getHiddenPercent,#getFrozenPercent,#getNodesState,#getAssetNodesState,#setHiddenState,#setFrozenState,#isSkinConnected,#setSkinConnection,#toggleSkinConnection,#hideAsset,#isolateAsset,#selectAssetRigObjs,#selectAssetPiecesByFlag,#setBoxMode,#setAssetPuppetMode,#setAssetPuppetHeadMode,#setAssetHeadMode,#setAssetSkinMode,#setAssetSkinBoxMode,#resetAsset,#getAssetVisMode,#findAssetByName,#getAssetFolder,#getAssetIconFiles,#getDuplicatedNameNodes,#deleteAsset,#loadAsset,#saveAnimation,#loadAnimation,#getSelSetObjects,#addObjectsToSelectionSet,#getAssetFileName,#readSceneAssetInfo,#saveSceneAssetInfo)
	global LB_FNs_assetFunctions = #(#getSceneLayers,#sortAssets,#getAssetXRefScene,#getAssetNodesFromXrefScenes,#getMainAsset,#getDependentAssets,#getDependencyGroup,#setAssetDependencies,#getSceneAssets,#getSceneAnimAssets,#getAssetsFromNodes,#getAssetNodes,#getAssetNodesByType,#getAssetAnimNodes,#getAssetRootNode,#getSPRrootNodes,#getAssetPosition,#getNewAssetCopyNumber,#setAssetCopyNumber,#copyAsset,#copyObjects,#getHiddenPercent,#getFrozenPercent,#getNodesState,#getAssetNodesState,#setHiddenState,#setFrozenState,#isSkinConnected,#setSkinConnection,#toggleSkinConnection,#hideAsset,#isolateAsset,#isolateAssets,#hasPuppet,#selectAssetRigObjs,#selectAssetPiecesByFlag,#setBoxMode,#setAssetPuppetMode,#setAssetPuppetHeadMode,#setAssetHeadMode,#setAssetSkinMode,#setAssetSkinBoxMode,#resetAsset,#getAssetVisMode,#findAssetByName,#getAssetFolder,#getAssetIconFiles,#getDuplicatedNameNodes,#deleteAsset,#loadAsset,#saveAnimation,#loadAnimation,#getSelSetObjects,#addObjectsToSelectionSet,#getAssetFileName,#readSceneAssetInfo,#saveSceneAssetInfo)
	-------------------------------------------

	-------------------------------------------
	--attachObjectToFaceFunctions
	-------------------------------------------
	global CA_attachPro
	global strAttachPro
	global attachProPosControllerName
	global attachProRotControllerName
	global getAttachProControllers
	global deleteAttachProAnimation
	global getAttachProInfo
	global createAnimFromVertex
	global AOTFsubdivisionMods
	global AOTFattachModName
	global AOTFattachMode
	global attachProPosControllerName
	global attachProRotControllerName
	-------------------------------------------
	--batchFunctions
	-------------------------------------------
	global batchFunctionsArray
	
	global getFilesFromFolder
	global batchFile
	global batchFiles
	
	-------------------------------------------
	--Cache Functions
	-------------------------------------------
	--vars
	global cacheModClasses
	global modifiersOnTopOfCache
	global modifiersToKeepInCache
	global modifiersToDisableInCache
	global modifiersToCollapseInCache
	
	--functions
	global isCacheMod
	global getCacheMods
	global getCacheTypeFromName
	global addCacheModByName
	global setTCobjectControllers
	global removeCacheMods
	global resetCache
	global setCacheEnabled
	global setCachePlaybackData
	global loadCache
	global recordCache
	global recordCacheFromObject
	global reloadCache
	global convertSceneToCaches
	global disableClothModifierFromObjects
	global restoreClothModifierStateFromObjects
	global remoteBatchCacheExport
	
	--global LB_FNs_Cache Functions = #(#isCacheMod,#getCacheMods,#getCacheTypeFromName,#addCacheModByName,#setTCobjectControllers,#removeCacheMods,#resetCache,#setCacheEnabled,#setCachePlaybackData,#loadCache,#recordCache,#recordCacheFromObject,#reloadCache,#convertSceneToCaches)
	global LB_FNs_cacheFunctions = #(#isCacheMod,#getCacheMods,#getCacheTypeFromName,#addCacheModByName,#setTCobjectControllers,#removeCacheMods,#resetCache,#setCacheEnabled,#setCachePlaybackData,#loadCache,#recordCache,#recordCacheFromObject,#reloadCache,#convertSceneToCaches)
	-------------------------------------------


	-------------------------------------------
	--Camera Functions
	-------------------------------------------
	global cameraRange
	
	global hasCamInfo
	global removeCamInfo
	global addCamInfo
	global compareCameraNames
	global getSceneCameras
	global setCameraRange
	global getCameraRange
	global getCamerasRange
	global setAnimRangeFromCamera
	global setAnimRangeFromCameras
	global setViewportCamera

	--global LB_FNs_Camera Functions = #(#hasCamInfo,#removeCamInfo,#addCamInfo,#compareCameraNames,#getSceneCameras,#setCameraRange,#getCameraRange,#getCamerasRange,#setAnimRangeFromCamera,#setAnimRangeFromCameras,#setViewportCamera)
	global LB_FNs_cameraFunctions = #(#hasCamInfo,#removeCamInfo,#addCamInfo,#compareCameraNames,#getSceneCameras,#setCameraRange,#getCameraRange,#getCamerasRange,#setAnimRangeFromCamera,#setAnimRangeFromCameras,#setViewportCamera)
	-------------------------------------------


	-------------------------------------------
	--controllers functions
	-------------------------------------------
	--global setControllerKeyable
	--global setTrackKeyableState
	--global getControllerIndex
	--global isTransformFrozen
	--global freezeTransform
	--global unFreezeTransform
	--global transformToZero
	--global freezePose
	--global transformPoseZero
	--global unFreezePose
	--global isTransformFrozenPose
	--global setActiveController
	--global createTrackController
	--global makeKeyable
	--global getObjControllers
	--global copyPasteAnimation
	--global isNodeInZeroPose
	--global isNodeInZeroTransform

	--global LB_FNs_controllers functions = #(#setControllerKeyable,#getControllerIndex,#isTransformFrozen,#freezeTransform,#unFreezeTransform,#transformToZero,#freezePose,#transformPoseZero,#unFreezePose,#isTransformFrozenPose,#setActiveController,#createTrackController,#makeKeyable,#copyPasteAnimation)
	--global LB_FNs_controllersFunctions = #(#setControllerKeyable,#getControllerIndex,#isTransformFrozen,#freezeTransform,#unFreezeTransform,#transformToZero,#freezePose,#transformPoseZero,#unFreezePose,#isTransformFrozenPose,#setActiveController,#createTrackController,#makeKeyable,#copyPasteAnimation,#isNodeInZeroPose,#isNodeInZeroTransform)
	-------------------------------------------

	-------------------------------------------
	--copyPasteFunctions
	-------------------------------------------
	global cpyBufferObjects 				-- 	Objetos de los que se copian valores
	global cpyBufferTracksPerObject 	--	Todas las pistas de cada objeto del que se copia
	global cpyBufferValuesPerObject 	--	Todos los valores de las pistas de cada objeto del que se copia
	global cpyBufferLinksPerObject		--	Si la pieza tiene un link constraint, guarda a quien esta lincado en ese punto
	
	global copyTracks						--funcion que rellena los buffers
	global pasteTracks						--funcion que pega los valores de los buffers en las piezas
	global bufferToFile						--pasa el buffer a un fichero
	global fileToBuffer						--recupera el buffer de un fichero
	-------------------------------------------

	-------------------------------------------
	--dynamicRolloutFunctions
	-------------------------------------------
	global createDynamicRollout

	-------------------------------------------
	--ffd functions
	-------------------------------------------
	global SWffdAnimateAll
	global SWffdNumCPs
	global SWffdGetCPpos
	global SWffdSetCPpos
	global SWffdInvert
	global SWffdCopy
	global saveFFD
	global loadFFD

	--global LB_FNs_ffd functions = #(#SWffdAnimateAll,#SWffdNumCPs,#SWffdGetCPpos,#SWffdSetCPpos,#SWffdInvert,#SWffdCopy,#saveFFD,#loadFFD)
	global LB_FNs_ffdFunctions = #(#SWffdAnimateAll,#SWffdNumCPs,#SWffdGetCPpos,#SWffdSetCPpos,#SWffdInvert,#SWffdCopy,#saveFFD,#loadFFD)
	-------------------------------------------


	-------------------------------------------
	--fixFunctions
	-------------------------------------------
	global fixFunctions --array con todas las funciones de fix
	global fixFunctionsDesc --array con la descripcion de las funciones de fix
	
	global fixFunctionTemplate--funcion de plantilla

	-------------------------------------------
	--License Manager
	-------------------------------------------
	--vars
	global rollLMID
	global rollLicenseManager

	--global checkPassword

	--global LB_FNs_License Manager = #(#checkPassword)
	--global LB_FNs_licenseManager = #(#checkPassword)
	-------------------------------------------


	-------------------------------------------
	--link constraint data
	-------------------------------------------
	global LC_chrNeedsLC
	
	global LC_chrNeedsVW
	global LC_chrNoNeedsVW
	
	global LC_chrNeedsKeyToW 
	global LC_chrNeedsKeyToVW
	
	
	global LC_prpNeedsLC 
	
	global LC_prpNeedsVW
	global LC_prpNoNeedsVW
	
	global LC_prpNeedsKeyToW
	global LC_prpNeedsKeyToVW
	
	
	global LC_fxNeedsLC 
	
	global LC_fxNeedsVW
	global LC_fxNoNeedsVW
	
	global LC_fxNeedsKeyToW
	global LC_fxNeedsKeyToVW
	
	
	global LC_sprNeedsLC
	
	global LC_sprNeedsVW
	global LC_sprNoNeedsVW
	
	global LC_sprNeedsKeyToW
	global LC_sprNeedsKeyToVW
	-------------------------------------------

	-------------------------------------------
	--link constraint functions
	-------------------------------------------
	global getMainObject
	global getLCcontroller
	global existLCcontroller
	global initListView
	global fillListView
	global initControls

	--global LB_FNs_link constraint functions = #(#getMainObject,#getLCcontroller,#existLCcontroller,#initListView,#fillListView,#initControls)
	global LB_FNs_linkConstraintFunctions = #(#getMainObject,#getLCcontroller,#existLCcontroller,#initListView,#fillListView,#initControls)
	-------------------------------------------

	-------------------------------------------
	--mathFunctions
	-------------------------------------------
	global mathRound
	-------------------------------------------
	
	-------------------------------------------
	--maxKeyWordGather
	-------------------------------------------
	global gatherMaxscriptKeyword
	-------------------------------------------

	-------------------------------------------
	--messageBox
	-------------------------------------------
	global messageBoxMessage
	global messageType
	global lbMessageBox
	
	global queryBoxAnswer
	global queryBoxMessage
	global lbQueryBox
	
	global lbScrollMessageBox
	global scrollMessageBoxMessage
	
	-------------------------------------------
	--Modifier Functions
	-------------------------------------------
	global setModifierState
	global isTurbosmoothDisabled
	global setTurbosmoothState
	global checkTurbosmooth
	global hasDuplicatedModifiers
	global getDuplicatedModifiersIndex
	global deleteDuplicatedModifiers
	
	--global LB_FNs_Modifier Functions = #(#setModifierState,#isTurbosmoothDisabled,#setTurbosmoothState)
	global LB_FNs_modifierFunctions = #(#setModifierState,#isTurbosmoothDisabled,#setTurbosmoothState,#checkTurbosmooth)
	-------------------------------------------

	-------------------------------------------
	--Naming Convention Functions
	-------------------------------------------
	global ncOK
	global showNChelp
	global getNameWithNoPrefix
	global getNameWithNoCopyData
	global getNameWithNoFlags
	global getSimpleObjectName
	global getOppositeObjectName
	global getObjectType
	global sortFlags
	global getFlags
	global getModifierFlags
	global addFlag
	global removeFlag
	global removeAllFlags
	global setFlags
	global hasFlag
	global swapUnit
	global convertAnyTagToPattern
	global convertPatternToAnyTag
	
	--global LB_FNs_Naming Convention Functions = #(#ncOK,#getNameWithNoPrefix,#getNameWithNoCopyData,#getNameWithNoFlags,#getSimpleObjectName,#getObjectType,#sortFlags,#getFlags,#addFlag,#removeFlag,#removeAllFlags,#setFlags,#hasFlag)
	global LB_FNs_namingConventionFunctions = #(#ncOK,#getNameWithNoPrefix,#getNameWithNoCopyData,#getNameWithNoFlags,#getSimpleObjectName,#getOppositeObjectName,#getObjectType,#sortFlags,#getFlags,#addFlag,#removeFlag,#removeAllFlags,#setFlags,#hasFlag,#swapUnit,#convertAnyTagToPattern,#convertPatternToAnyTag)
	-------------------------------------------

	-------------------------------------------
	--geometryFucntions
	-------------------------------------------
	global createBoxFromNodes
	global createBoxFromBoundingBox

	-------------------------------------------
	--nodeFunctions
	-------------------------------------------
	global getNodesBoundingBox
	global getBoundingBoxFaceCenters
	global getBoundingBoxCorners
	global compareDistanceToCamera
	global isPointInBoundingBox
	global isPointInCameraField
	global isBoundingBoxVisible
	global isNodeVisible
	
	-------------------------------------------
	--Renamer
	-------------------------------------------
	global findText
	global replaceText
	global initListView
	global round
	global sortListNamesAlphabetical
	global fillBeforeList
	global fillAfterList
	global setRowColor
	global resetListView
	global ApplyChanges
	global clearControls
	global checkChangedSelection
	global selectItems

	--global LB_FNs_Renamer = #(#findText,#replaceText,#initListView,#round,#sortListNamesAlphabetical,#fillBeforeList,#fillAfterList,#setRowColor,#resetListView,#ApplyChanges,#clearControls,#checkChangedSelection,#selectItems)
	global LB_FNs_renamer = #(#findText,#replaceText,#initListView,#round,#sortListNamesAlphabetical,#fillBeforeList,#fillAfterList,#setRowColor,#resetListView,#ApplyChanges,#clearControls,#checkChangedSelection,#selectItems)
	-------------------------------------------


	-------------------------------------------
	--finishingFunctions
	-------------------------------------------
	global strRenderLayerManager
	global strRenderLayerProperties
	global strNodeOverrides
	global strRenderPropertiesOverrides
	global strRenderCommonPropertiesOverrides
	global strRenderScanlinePropertiesOverrides
	global strRenderMentalrayPropertiesOverrides
	
	global CA_renderLayersMaterials
	
	global updateRenderLayerNodesOverrides
	global restoreRenderLayerNodesOverrides
	global removeNotInRenderLayerObjectsNodeOverrides
	global setRenderLayerNodeOverride
	global breakMaterialEditorReferencesNonUsedInRenderLayer
	global getAllRenderLayersMaterials
	global overwriteRenderLayersMaterialsGlobalTrack
	global disableNotInRenderLayerLights
	global updateSceneState
	global syncronizeRenderLayersSceneStates
	global getRenderers
	global getRenderersNames
	global getCurrentRendererName
	global getRenderLayerRenderEngine
	global setRenderLayerRenderEngine
	global setRenderLayerNextRenderEngine
	global getRenderLayerOutputSize
	global setRenderLayerOutputSize
	global fillRenderLayerRenderProperties
	global restoreRenderLayerRenderProperties
	global hasSameRenderLayersRenderProperties
	global hasRenderLayerOverrides
	global areRenderLayerRenderPropertiesDifferentFromScene
	
	global getSceneLights
	global getLightTarget
	global getVerticalfov
	global genThumbnailCam
	global genThumbnailRender
	global genThumbnailViewport
	
	global storeRenderJobInfo
	
	-------------------------------------------


	-------------------------------------------
	--Security functions
	-------------------------------------------
	--vars
	global hardwareId
	global computerName
	global numCPUs
	global encryptKey
	
	--functions
	global getHexaCode
	global getLicenseCode
	global isValidLicenseCode
	global saveEncryptedScript
	global saveEncryptedFile
	global createLicenseFile
	global readLicenseFile
	global checkLicenseFile

	--global LB_FNs_Security functions = #(#getHexaCode,#getLicenseCode,#isValidLicenseCode,#saveEncryptedScript,#saveEncryptedFile,#createLicenseFile,#readLicenseFile,#checkLicenseFile)
	global LB_FNs_securityFunctions = #(#getHexaCode,#getLicenseCode,#isValidLicenseCode,#saveEncryptedScript,#saveEncryptedFile,#createLicenseFile,#readLicenseFile,#checkLicenseFile)
	-------------------------------------------


	-------------------------------------------
	--Skin functions
	-------------------------------------------
	--Structs
-- 	global skinVertData
-- 	global skinCrossSectionData
-- 	global skinEnvData
	
	--Funcs
-- 	global resetSkinAlwaysDeform
-- 	global addSkinModifier
-- 	global addSkinMorphModifier
-- 	global addSkinBonesSelected
-- 	global getSkinModifier
-- 	global isWeightNormalized
-- 	global selectSkinObject
-- 	global findClosestVertex
-- 	global findBonesInScene
-- 	global setSkinBones
-- 	global setSkinNumBonesPerVertex
-- 	global setSkinEnvelopes
-- 	global setSkinWeights
-- 	global loadSkin
-- 	global saveSkin
-- 	global reloadSkinMorph
-- 	global getSkinMorphModifier
-- 	global getSkinMorphModifierIndex
-- 	global saveSkinMorph
-- 	global loadSkinMorph
-- 	global jumpToParentSkinBone
-- 	global jumpToChildrenSkinBone
-- 	global jumpToBrotherSkinBoneR
-- 	global jumpToBrotherSkinBoneL
-- 	global jumpToOppositeSkinBone

-- 	global LB_FNs_skinFunctions = #(#addSkinModifier,#addSkinMorphModifier,#addSkinBonesSelected,#getSkinModifier,#isWeightNormalized,#selectSkinObject,#findClosestVertex,#findBonesInScene,#setSkinBones,#setSkinNumBonesPerVertex,#setSkinEnvelopes,#setSkinWeights,#loadSkinData, #saveSkin,#getSkinMorphModifier,#getSkinMorphModifierIndex,#saveSkinMorph,#loadSkinMorph)
	-------------------------------------------


	-------------------------------------------
	--Vertex Color functions
	-------------------------------------------
	global hasVertexColorChannel
	global createVertexColorChannel
	global deleteVertexColorChannel
	global setVertexColor
	global setMultipleVertexColors
	global vertexColorsNormalized
	global normalizeVertexColors
	global loadVertexColors
	global saveVertexColors

	--global LB_FNs_Vertex Color functions = #(#hasVertexColorChannel,#createVertexColorChannel,#deleteVertexColorChannel,#setVertexColor,#setMultipleVertexColors,#vertexColorsNormalized,#normalizeVertexColors,#loadVertexColors,#saveVertexColors)
	global LB_FNs_vertexColorFunctions = #(#hasVertexColorChannel,#createVertexColorChannel,#deleteVertexColorChannel,#setVertexColor,#setMultipleVertexColors,#vertexColorsNormalized,#normalizeVertexColors,#loadVertexColors,#saveVertexColors)
	-------------------------------------------
	
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------

	-------------------------------------------
	--ARS_facialFunctions
	-------------------------------------------
	global hasFixEyes
	global removeFixEyes
	global addFixEyes

	global LB_FNs_ARS_facialFunctions = #(#hasFixEyes,#removeFixEyes,#addFixEyes)
	-------------------------------------------

	-------------------------------------------
	--callbacks
	-------------------------------------------
	
	--vars
	global CAsRedefineAtEnd			= false			--flag para indicar que solo se tienen que hacer
																	--los redefine CAs en el postopenprocess
	global saveFromAssetChecker	= false			--flag para saver si se esta haciendo un save desde la herramienta de Asset checked o no
	global preMergeAssets				= #()			--array con los assets de la escena antes del merge
	global postMergeAssets			= #()			--array con los assets despues del merge
	
	global LB_VARs_callbacks	= #(#CAsRedefineAtEnd, #saveFromAssetChecker, #preMergeAssets, #postMergeAssets)
	
	--functs
	global replaceXrefControllers
	global testFunction
	global callbackLPMbatchRender
	--global checkAssetsState
	global preOpenProcess
	global preMergeProcess
	global postMergeProcess
	global postOpenProcess
	
	global saveFileInfo
	global preSaveProcess
	global postSaveProcess
	global setTransformCoordCenterToLocal
	global preSystemShutdownProcess
	global cacheExportProcess
	global initCallbacks

	global LB_FNs_callbacks = #(#replaceXrefControllers,#checkAssetsState,#preOpenProcess,#preMergeProcess,#postMergeProcess,#postOpenProcess,#saveFileInfo,#preSaveProcess,#postSaveProcess,#setTransformCoordCenterToLocal,#initCallbacks)
	-------------------------------------------


	-------------------------------------------
	--customAttributes
	-------------------------------------------
	
	--CAs
	global CA_camInfo 					--	informacion de cámara
	global CA_animTracks 				--	informacion de las pistas de animacion
	global CA_virtualNodes 			--	padre e hijos virtuales
	global CA_skinConnectionInfo 	--	informacion de conexion entre rig de skin y de animacion
	global CA_skinRigInfo 				--	informacion de soluciones de skin aplicadas
	global CA_animRigInfo 				--	informacion de soluciones de rig aplicadas
	global CA_morphInfo				--	informacion de mophs de gestos
	--global CA_materialBackup
	global CA_testAttrib 				--	custom attribute de pruebas
	
	--CAs de ARS (Animation Rig Solutions)
	global CA_ARS_fixEyes				--	Eyes Fix Snap custom attribute
	global CA_ARS_linkConstraint	--	Link constraint custom attribute
	global CA_ARS_pointConstraint	--	Point constraint custom attribute
	
	--CAs de SRS (Skin Rig Solutions)
	global CA_SRS_twistInfo			--	Informacion necesaria para la creacion de twists
	
	--global CA_attachPro
	
	--vars
	global customAttributes = #(CA_camInfo, CA_animTracks, CA_virtualNodes,\
										CA_skinConnectionInfo, CA_skinRigInfo, CA_animRigInfo, /* CA_materialBackup, */ CA_testAttrib,\
										CA_ARS_fixEyes, CA_ARS_linkConstraint, CA_SRS_twistInfo, CA_ARS_pointConstraint)
	
	--functs
	global redefineCustAttribute
	global redefineCustAttributes
	global makeUniqueCustAttributes

	global LB_CAs_customAttributes	= #(#customAttributes)
	global LB_FNs_customAttributes = #(#toString,#setEyesLookAtControl,#setEyesFixControl,#setEyesExpose,#setMultiplier,#snapFixEyes_LookAtToFix,#snapFixEyes_FixToLookAt,#snapFixEyes,#getMainObject,#getLCcontroller,#existLCcontroller,#initListView,#fillListView,#initControls,#redefineCustAttribute,#redefineCustAttributes,#makeUniqueCustAttributes,#renameCustattributes)
	-------------------------------------------


	-------------------------------------------
	--customAttributesFunctions
	-------------------------------------------
	global hasAttribute
	
	global LB_FNs_customAttributesFunctions = #(#hasAttribute,#addTwistInfo)
	-------------------------------------------

	-------------------------------------------
	--layerFunctions
	-------------------------------------------
	global newLayer
	global getLayer
	global activeLayer
	global nodesToLayer
	
	global LB_FNs_customAttributesFunctions = #(#newLayer,#getLayer,#activeLayer,#nodesToLayer)
	-------------------------------------------
	
	-------------------------------------------
	--lbGlobalsFunctions
	-------------------------------------------
	global getVars
	global getFuncs
	global getCAs
	global getRollouts

	global LB_FNs_lbGlobalsFunctions = #(#getVars,#getFuncs,#getCAs,#getRollouts)
	-------------------------------------------


	-------------------------------------------
	--miscellaneousFunctions
	-------------------------------------------
	global cloneNode
	global meshFilter
	global boneFilter
	global pointFilter
	global splineFilter
	global renameFromObj
	global searchInArrayByString
	global flipNormals
	global compareNodesByName
	global compareNodesByClassof
	global sortNodesByName
	global sortNodesByClassof
	global getNodesBoundingBox
	global AlignObjectPivot
	global isNumeric
	global areArraysEqual
	global getNodeInheritanceFlags
	global setNodeInheritanceFlags
	
	global LB_FNs_miscellaneousFunctions = #(#cloneNode,#meshFilter,#boneFilter,#pointFilter,#splineFilter,#renameFromObj,#searchInArrayByString,#flipNormals,#compareNodesByName,#sortNodesByName,#getNodesBoundingBox)
	-------------------------------------------


	-------------------------------------------
	--notificationFunctions
	-------------------------------------------
	--vars
	global notificationsString = "" --texto de las notificaciones
	global disableNotifications --indica si se deben mostrar las notificaciones o no
	global autoCloseNotifications --indica si se deben cerra las notificaciones uan vez mostradas
	
	global LB_VARs_notificationFunctions		= #(#notificationsString, #disableNotifications, #autoCloseNotifications)
	
	--rolls
	global rollNotifications --rollout de notificaciones
	
	global LB_ROLLs_notificationFunctions		= #(#rollNotifications)
	
	--functs
	global createNotificationsDialog
	global addNotification
	global endNotificationsBlock
	global enableNotifications

	global LB_FNs_notificationFunctions = #(#addStringText,#loadSettings,#saveSettings,#createNotificationsDialog,#addNotification,#endNotificationsBlock,#enableNotifications)
	-------------------------------------------

	-------------------------------------------
	--proxyFunctions
	-------------------------------------------
	global disableProxy
	global enableProxy
	global removeProxy
	
	-------------------------------------------
	--progressBarFunctions
	-------------------------------------------
	global rollProgressBar
	global rollProgressBarExecute
	
	global progressBarExecuteGeneration
	global progressBarOpen
	global progressBarClose
	global setProgressBarCaption
	global setProgressBarValue
	
	-------------------------------------------
	--qualityMessage
	-------------------------------------------
	--rolls
	global rollQualityMessage
	
	global LB_ROLLs_QualityMessage	= #(#rollQualityMessage)
	
	--functs
	global launchQualityMessage

	global LB_FNs_qualityMessage = #(#launchQualityMessage,#setImage)
	-------------------------------------------

	-------------------------------------------
	--fileIOfunctions
	-------------------------------------------
	
	global resaveMaxFile
	global resaveMaxFiles
	global getAllSubfolders
	global getAllFilesFromSubFolders
	
	-------------------------------------------

	-------------------------------------------
	--riggingFunctions
	-------------------------------------------
	global createNewBone
	global createConstraint
	global createPointFromObj
	global createBoneFromPoint
	global getHierarchySubLevelsFromNode
	global getHierarchiesFromNodes
	global createPointsFromHierarchy
	global createBonesFromPointHierarchy
	global addPathConstraint
	
	global initVirtualParent
	global linkVirtualParent
	global unlinkVirtualParent
	global getVirtualParent
	global jumpToVirtualParent
	global getVirtualChildren
	global jumpToVirtualChildren
	global getAllBrothers
	global jumpToVirtualBrotherR
	global jumpToVirtualBrotherL
	global jumpToAllBrothers
	global jumpToChildrenHierarchy
	global hideShowPuppet
-- 	global getLayer
-- 	global createLayer
-- 	global activeLayer
-- 	global nodesToLayer
	global applyGradient
	global applyGradientRamp
	global getOppositeObject
	global flipVis
	global flipAxis
	global SmartCreateEnd
	global fixIKplane
	global checkOffset
	global getEndPoint
	global UnMirror
	global MirrorSelectedBones
	global CallMirror
	global setPivotPos
	global hasSkinconnectionInfo
	global setSCIposConstraint
	global setSCIrotConstraint
	global setSCIscaleConstraint
	global setSCIheadSystem
	global setSCIkeepConnected
	global removeSkinConnectionInfo
	global addSkinConnectionInfo
	global mergeFacialSystem

	global LB_FNs_riggingFunctions = #(#createNewBone,#createConstraint,#createPointFromObj,#createBoneFromPoint,#getHierarchiesFromNodes,#createPointsFromHierarchy,#createBonesFromPointHierarchy,#addPathConstraint,#initVirtualParent,#linkVirtualParent,#unlinkVirtualParent,#jumpToVirtualParent,#getVirtualChildren,#jumpToVirtualChildren,#getAllBrothers,#jumpToVirtualBrotherR,#jumpToVirtualBrotherL,#jumpToAllBrothers,#jumpToChildrenHierarchy,#hideShowPuppet,#applyGradient,#applyGradientRamp,#getOppositeObject,#flipVis,#flipAxis,#SmartCreateEnd,#fixIKplane,#checkOffset,#getEndPoint,#UnMirror,#MirrorSelectedBones,#CallMirror,#setPivotPos,#hasSkinconnectionInfo,#setSCIposConstraint,#setSCIrotConstraint,#setSCIscaleConstraint,#setSCIheadSystem,#setSCIkeepConnected,#removeSkinConnectionInfo,#addSkinConnectionInfo,#mergeFacialSystem)
	-------------------------------------------

	-------------------------------------------
	--RS_functions
	-------------------------------------------
	global unloadRigSolutions
	global loadRigSolution

	global LB_FNs_RS_functions = #(#unloadRigSolutions,#loadRigSolution)
	-------------------------------------------
	-------------------------------------------
	--searchFunctions
	-------------------------------------------
	global getFunctionFromString
	global getFunctionsFromFile
	global getMSfileName
	global getFormatedFunctionsFromFile
	global getFilesRecursive
	global compareFileNames
	global getFormatedFunctionsFromFolder

	global LB_FNs_searchFunctions = #(#getFunctionFromString,#getFunctionsFromFile,#getMSfileName,#getFormatedFunctionsFromFile,#getFilesRecursive,#compareFileNames,#getFormatedFunctionsFromFolder)
	-------------------------------------------


	-------------------------------------------
	--SRS_functions
	-------------------------------------------
	global getSkinRootBone
	global addTwistInfo
	
	global LB_FNs_SRS_functions = #(#addTwistInfo,#getSkinRootBone)
	-------------------------------------------

	-------------------------------------------
	--PreviewFunctions
	-------------------------------------------
	global createStamps
	global deleteStamps
	global makeViewportPreview
	-------------------------------------------



	-------------------------------------------
	--svnFunctions
	-------------------------------------------
	global svnRepositoryPath
	global svnInfo
	
	global svnFolderCleanup
	global svnIsFolderVersioned
	global svnIsFileVersioned
	global svnGetFolderStatus
	global svnGetFileStatus
 	global svnIsFileUpdated
	global svnLockFile
	global svnUnlockFile
	global svnCommit
	global svnUpdate
	global svnAdd
	global svnDelete
	global svnRename
	
	
	-------------------------------------------
	--AnimInfo Functions
	------------------------------------------
	global copyAnimTracks
	global pasteAnimTracks
	global pasteOppositeAnimTracks
	
	-------------------------------------------
	--Rig Solutions
	-------------------------------------------
	global solutionNodes
	
	global clearSolutionMemory
	global removeSolution
	global getSolutionNodes
	global generateSolution

	global LB_FNs_ARS_animalLegPaw001 = #(#solutionNodes,#getSolutionNodes,#clearSolutionMemory,#removeSolution,#generateSolution)
	global LB_FNs_SRS_twist001 = #(#solutionNodes,#getSolutionNodes,#clearSolutionMemory,#removeSolution,#generateSolution)
	global LB_FNs_SRS_stretchBoneChain001 = #(#solutionNodes,#getSolutionNodes,#clearSolutionMemory,#removeSolution,#generateSolution)
	-------------------------------------------


	/*-------------------------------------------
	--transformCache
	-------------------------------------------
	global recordCache
	global loadfilename
	global reloadCache
	global unloadCache
	global resetCache
	global removeEaseAndMultiplierCurves
	global getMultiplierCurve
	global createMultiplierCurves
	global getEaseCurve
	global createEaseCurves
	global controllersOK
	global refreshState
	global getAnimationRange
	global updateKeys
	global updateControls

	global LB_FNs_transformCache = #(#recordCache,#loadfilename,#reloadCache,#unloadCache,#resetCache,#removeEaseAndMultiplierCurves,#getMultiplierCurve,#createMultiplierCurves,#getEaseCurve,#createEaseCurves,#controllersOK,#refreshState,#getAnimationRange,#updateKeys,#updateControls)
	-------------------------------------------*/
	
	-------------------------------------------
	--xmlFunctions
	-------------------------------------------
	global loadXMLassembly
	global newXMLfile
	global loadXMLfile
	global getXMLRootElement
	global getXMLelementChildrenAsArray
	global getXMLelementsByName
	-------------------------------------------
	
	
	-------------------------------------------
	--xrefFunctions
	-------------------------------------------
	global getNameFromFile
	global getPathFromFile
	global getXrefMeshNodesFromAssets
	global getLoadedXrefFileFromNode
	global addXrefNodesFromFile
	global removeXrefNodes
	global mergeXrefNodesControllers
	global retargetXrefNodesToFile
	global refreshXrefNodes
	global getXrefLastLevelRecords
	global getXrefSceneRootRecords
	global getXrefSourceItemByName
	global mergeXrefSceneTree
	
	global LB_FNs_xrefFunctions = #(#getNameFromFile,#getPathFromFile,#getXrefMeshNodesFromAssets,#getLoadedXrefFileFromNode,#addXrefNodesFromFile,#removeXrefNodes,#mergeXrefNodesControllers,#retargetXrefNodesToFile,#refreshXrefNodes,#getXrefSourceItemByName,#getXrefSceneRootRecords,#getXrefLastLevelRecords)
	-------------------------------------------
	
	
	
)