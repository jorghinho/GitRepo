------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: librería de naming convention
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: nc | Contiene todas las funciones de naming convention.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_nc
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria naming convention",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		ncDocFilePath = "", --se rellena al leerse la libreria por primera vez
		ncDocFileName = "nc.xml",
		ncRoot = undefined,

		-- NC general para presets
		NC_standardPreset = "std", -- Este es el código de 3 letras para los presets estándar.

		-- tipos de asset. Siempre son el primer prefijo de cualquier fichero o pieza de un asset (ejemplo: chr_tadeo_anim)
		NC_chrPrefix		=	"chr",	-- assets de tipo character
		NC_prpPrefix		=	"prp",	-- assets de tipo prop
		NC_setPrefix		=	"set",	-- assets de tipo scenery
		NC_sprPrefix		=	"spr",	-- assets de tipo setProp (partes móviles de un escenario)
		NC_seqPrefix		=	"seq",	-- fichero de tipo secuencia
		NC_fxPrefix			=	"fx",	-- assets de tipo fx
		NC_litPrefix		=	"lit",	-- assets de tipo light
		NC_libPrefix		=	"lib",	-- prefijo para carpetas de libreria y objetos de libreria
		NC_matPrefix		=	"mat",	-- prefijo para materiales auxiliares
		NC_camPrefix		=	"cam",	-- prefijo para cámaras

		NC_assetTypes	=	#(NC_chrPrefix, NC_prpPrefix, NC_litPrefix, NC_fxPrefix, NC_sprPrefix, NC_setPrefix),

		NC_chrPrefixDesc		=	"para personajes",
		NC_prpPrefixDesc		=	"para props",
		NC_setPrefixDesc		=	"para escenarios",
		NC_sprPrefixDesc		=	"para setProps (partes moviles de los escenarios)",	-- assets de tipo setProp (partes móviles de un escenario)
		NC_seqPrefixDesc		=	"para ficheros de secuencia",	-- fichero de tipo secuencia
		NC_fxPrefixDesc			=	"para assets de fx",
		NC_litPrefixDesc		=	"para assets de light",
		NC_matPrefixDesc		=	"para materiales auxiliares",

		NC_assetTypesDesc	=	#(NC_chrPrefixDesc, NC_prpPrefixDesc, NC_litPrefixDesc, NC_fxPrefixDesc, NC_sprPrefixDesc, NC_setPrefixDesc),

		-- longitudes de los nombres de fichero según el tipo de asset
		NC_assetFolderNameLength	= 2,
		NC_seqFolderNameLength	= 2,
		NC_assetFileNameLength		= 4,
		NC_chrFileNameLength			= 4,
		NC_prpFileNameLength			= 4,
		NC_litFileNameLength			= 4,
		NC_setFileNameLength			= 4,
		NC_sprFileNameLength			= 4,
		NC_fxFileNameLength			= 4,
		NC_seqFileNameLength			= 4,
		NC_seqLayoutFileNameLength	= 4,
		NC_seqAnimFileNameLength		= 4,
		NC_seqHairFileNameLength		= 4,
		NC_seqPCFileNameLength		= 4,
		NC_seqClothFileNameLength		= 4,
		NC_seqFxFileNameLength			= 5,
		NC_seqRenderFileNameLength	= 5,
		NC_seqRenderFileNameLastPartLength = 2,
		NC_objectNamesLength			= 7,
		NC_layerNamesLength				= 2,
		NC_matNamesLength				= 3,
		NC_bitmapNamesLength			= 5,
		NC_camNamesLength				= 2,
		NC_stereocamNamesLength			= 3,
		NC_lpmPassesNamesLength		= 4,

		--nombres de capas auxiliares
		NC_layerAux							=	"_auxObj-", --capas que no tiene que contemplar como assets el getSceneAssets
		NC_layerAuxObj						=	"_auxObj_",		--capa para los objetos auxiliares
		NC_layerAuxCloth					=	"_auxCloth_",	--capa para los objetos auxiliares
		NC_layerAuxFx						=	"_auxFx_",		--capa para los objetos auxiliares
		NC_layerAuxObjPointConstraint		=	"_auxObj-pointConstraint_", --capa para los point constraints
		NC_layerCam							=	"_cam_",		--capa para las camaras
		NC_layerLight						=	"_light_",		--capa para las luces
		NC_layerLayout						=	"_layout_",	--capa para todo el conjunto de piezas de una escena de layout, que van a cargar los animadores entes de empezar a animar
		NC_layerLPM 						=	"zz-LPM", 	--capa auxiliar de objetos de LPM

		NC_layoutAuxPrefix = "LAY",

		--Nombres especiales de objetos.
		NC_projectionCameraName = "CMAP",


		--nombres de carpetas de version de asset
		NC_assetFolderName = "asset",
		NC_seqFolderName = "sequence",

		--para nombres de carpetas dentro de un asset
		NC_rigFolderName		= "rig",
		NC_versionFolderName	= "version",
		NC_textureFolderName 	= "texture",

		--nombres de carpetas de version de asset
		NC_presetFolderName = "preset",
		NC_baseFolderName = "base",
		NC_partFolderName = "part",
		NC_animBaseFolderName = "animBase",

		--carpetas de una camara de secuencia
		NC_camFolder = "cam",
		NC_camAnimFolder = "anim",
		NC_camAssetFolder = "asset",
		NC_camCacheFolder = "cache",
		NC_camCacheSourceFolder = "source",
		NC_camPostFolder = "post",
		NC_camRenderFolder = "render",
		NC_camRenderSourceFolder = "source",
		NC_camSimulationFolder = "simulation",
		NC_camVideoFolder = "video",
		NC_camVideoReferenceFolder = "reference",
		NC_camStereoFolder = "stereo",

		-- sufijos de los nombres de fichero según el tipo de asset
		NC_layoutFileName		= "layout",
		NC_animFileName			= "anim",
		NC_animEditFileName		= "animEdit",
		NC_connectFileName		= "connect",
		NC_PCfileName 			= "cache",
		NC_renderFileName 		= "render",
		NC_meshFileName 		= "mesh",
		NC_morphFileName 		= "morph",
		NC_facialFileName		= "facial",
		NC_facialEditFileName	= "facialEdit",
		NC_draftFileName		= "draft",
		NC_proxyFileName		= "proxy",
		NC_clothFileName		= "cloth",
		NC_cacheClothFileName	= "cacheCloth",
		NC_fxFileName			= "fx",
		NC_lightFileName		= "light",
		NC_puppetFileName		= "puppet",
		NC_hairFileName			= "hair",
		NC_cacheFxFileName		= "cacheFx",
		NC_renderFXFileName 	= "renderFx",
		NC_productionFileName 	= "production",
		NC_StereoFilename		= "stereo",

		-- Tipos de fichero
		NC_fileTypes = #(NC_layoutFileName, NC_animFileName, NC_connectFileName, NC_PCfileName, NC_renderFileName, NC_renderFXFileName, NC_meshFileName, NC_morphFileName, NC_facialFileName, NC_facialEditFileName, NC_draftFileName, NC_proxyFileName, NC_clothFileName, NC_fxFileName, NC_lightFileName, NC_animEditFileName, NC_puppetFileName, NC_hairFileName, NC_cacheFxFileName, NC_cacheClothFileName, NC_productionFileName, NC_StereoFilename),
		NC_assetFileTypes = #(NC_layoutFileName, NC_animFileName, NC_connectFileName, NC_meshFileName, NC_morphFileName, NC_facialFileName, NC_draftFileName, NC_proxyFileName, NC_clothFileName, NC_fxFileName, NC_lightFileName, NC_puppetFileName, NC_hairFileName),
		NC_seqFileTypes = #(NC_layoutFileName, NC_animFileName, NC_clothFileName, NC_fxFileName, NC_PCfileName, NC_renderFileName, NC_renderFXFileName, NC_hairFileName,NC_cacheFxFileName,NC_cacheClothFileName,NC_productionFileName, NC_StereoFilename),
		NC_versionFolderTypes = #(NC_meshFileName, NC_connectFileName, NC_morphFileName, NC_facialFileName,NC_draftFileName,NC_proxyFileName,NC_animFileName,NC_layoutFileName),
		NC_nonVersionFolderTypes = #(NC_clothFileName, NC_fxFileName, NC_lightFileName, NC_puppetFileName),

		NC_animFileNameDesc			= "para archivos de animación",
		NC_PCfileNameDesc			= "para archivos de cache",
		NC_renderFileNameDesc		= "para archivos de render",
		NC_meshFileNameDesc			= "para archivos de geometria",
		NC_facialFileNameDesc		= "para archivos de anim facial",
		NC_connectFileNameDesc		= "para archivos de piezas de tipo connect",
		NC_morphFileNameDesc		= "para archivos de morphers del facial",
		NC_draftFileNameDesc		= "para archivos de draft",
		NC_proxyFileNameDesc		= "para archivos de proxy",
		NC_clothFileNameDesc		= "para archivos de cloth",
		NC_fxFileNameDesc			= "para archivos de fx",
		NC_lightFileNameDesc		= "para archivos de luces",
		NC_animEditFileDesc			= "para archivos con el rig elástico del personaje",
		NC_puppetFileDesc			= "para archivos con el puppet del personaje",
		NC_hairFileDesc				= "para archivos con el pelo de personajes",
		NC_cacheFxFileDesc			= "para archivos de cachés de efectos y partículas",
		NC_cacheClothFileDesc		= "para archivos de cachés de cloth",
		NC_renderFXFileNameDesc		= "para archivos de render con fx",
		NC_productionFileNameDesc	= "para archivos de producción",
		NC_stereoFileNameDesc		= "para archivos de estereoscopia",

		NC_fileTypesDesc = #(NC_animFileNameDesc, NC_PCfileNameDesc, NC_renderFileNameDesc, NC_meshFileNameDesc, NC_facialFileNameDesc, NC_connectFileNameDesc, NC_draftFileNameDesc, NC_proxyFileNameDesc, NC_clothFileNameDesc, NC_fxFileNameDesc, NC_lightFileNameDesc, NC_animEditFileDesc, NC_puppetFileDesc, NC_hairFileDesc, NC_cacheFxFileDesc, NC_cacheClothFileDesc ,NC_renderFXFileNameDesc, NC_productionFileNameDesc, NC_stereoFileNameDesc),

		-- tipos de clase de una pieza en la escena.
		NC_classMesh		=	"mesh",		-- objetos de tipo mesh
		NC_classMorph		=	"morph",	-- objetos de tipo morph
		--NC_classDraft		=	"draft",	-- objetos de tipo draft --ELIMINADA
		NC_classProxy		=	"proxy",	-- objetos de tipo draft
		--NC_classBip			=	"bip",		-- objetos de tipo bip --ELIMINADA
		NC_classConnect		=	"connect",	-- objetos de tipo conexión
		NC_classFacial		=	"facial",	-- objetos de tipo facial
		NC_classFacialEdit	=	"facialEdit",	-- objetos de tipo facial
		NC_classAnim		=	"anim",		-- objetos de tipo rig de animacion
		NC_classAnimEdit	=	"animEdit",	-- objetos de tipo rig de animacion
		NC_classPuppet		=	"puppet",	-- objetos auxiliares y temporales de tipo puppet
		NC_classSkin		=	"skin",		-- objetos de tipo skin
		NC_classHair		=	"hair",		-- objetos de tipo hair
		NC_classCloth		=	"cloth",	-- objetos de tipo cloth
		NC_classDynamic		=	"dyn",		-- objetos de tipo dyn
		NC_classFx			=	"fx",		--objetos de tipo fx
		NC_classLight		=	"light",	--objetos de tipo light
		NC_classAddonsRig	=	"addons",	--objetos de tipo addons de rig
		NC_classSkeletonRig	=	"skeleton",	--objetos de tipo skeleton de rig
		NC_classCam			= "cam",		--objetos de tipo camara

		-- tipos de clase de una pieza en la escena.
		NC_classTypes	=	#(NC_classMesh, NC_classMorph, /*NC_classDraft,*/ NC_classProxy, NC_classConnect, NC_classFacial, NC_classFacialEdit, /*NC_classBip,*/ NC_classAnim, NC_classAnimEdit, NC_classPuppet, NC_classSkin, NC_classHair, NC_classCloth, NC_classDynamic, NC_classFx, NC_classLight),	
			
		-- tipos de clase para geometria
		NC_classGeometry = #(/*NC_classCache, NC_classDraft,*/ NC_classMesh),

		-- tipos de clase animables
		NC_classAnimatable = #(NC_classAnim, NC_classFacial),
		
		NC_classMeshDesc		=	"para objetos de geometria (mesh)",
		NC_classMorphDesc	=	"para los gestos del sistema facial",
		--NC_classDraftDesc		=	"para objetos de tipo draft (mallas de baja)",
		NC_classProxyDesc	=	"para objetos de tipo proxy",
		--NC_classBipDesc		=	"para objetos de biped",
		NC_classConnectDesc	=	"para objetos de tipo de conexión",
		NC_classFacialDesc	=	"para objetos del sistema de rig facial",
		NC_classFacialEditDesc	=	"para objetos del sistema de edición facial",
		NC_classAnimEditDesc	=	"para objetos del sistema de rig de edición",
		NC_classAnimDesc		=	"para objetos del sistema de rig de animación",
		NC_classPuppetDesc	=	"para objetos de adecuacion de volumen del rig con la maya",
		NC_classSkinDesc		=	"para objetos del sistema de rig de skin",
		NC_classHairDesc		=	"para objetos de tipo pelo",
		NC_classClothDesc		=	"para objetos de tipo tela",
		NC_classDynamicDesc	=	"para objetos dinamicos de simulación",
		NC_classFxDesc			=	"para objetos de efectos",
		NC_classLightDesc			=	"para objetos de luces",
		
		NC_classTypesDesc	=	#(NC_classMeshDesc, NC_classMorphDesc, /*NC_classDraftDesc,*/ NC_classProxyDesc, NC_classConnectDesc, NC_classFacialDesc, NC_classFacialEditDesc, /*NC_classBipDesc,*/ NC_classAnimDesc, NC_classAnimEditDesc, NC_classPuppetDesc, NC_classSkinDesc, NC_classHairDesc, NC_classClothDesc, NC_classDynamicDesc, NC_classFxDesc, NC_classLightDesc),
		
		-- tipos de localización de piezas en la escena (left, right, middle, front, back. top, bottom, notSpecified)
		NC_locationNotSpecified		=	"x",		-- sin especificar
		NC_locationLeft				=	"l",		-- localizacion izquierda
		NC_locationRight			=	"r",		-- localizacion derecha
		NC_locationMiddle			=	"m",		-- localizacion media
		NC_locationFront			=	"f",		-- localizacion frontal
		NC_locationBack				=	"k",		-- localizacion trasera
		NC_locationTop				=	"t",		-- localizacion superior
		NC_locationBottom			=	"b",		-- localizacion inferior
	
		NC_locationTypes = #(NC_locationNotSpecified, NC_locationLeft, NC_locationRight, NC_locationMiddle, NC_locationFront, NC_locationBack, NC_locationTop, NC_locationBottom),
	
		NC_locationNotSpecifiedDesc	=	"sin especificar",
		NC_locationLeftDesc			=	"localizacion izquierda",
		NC_locationRightDesc		=	"localizacion derecha",
		NC_locationMiddleDesc		=	"localizacion media",
		NC_locationFrontDesc		=	"localizacion frontal",
		NC_locationBackDesc			=	"localizacion trasera",
		NC_locationTopDesc			=	"localizacion superior",
		NC_locationBottomDesc		=	"localizacion inferior",
		
		NC_locationTypesDesc = #(NC_locationNotSpecifiedDesc, NC_locationLeftDesc, NC_locationRightDesc, NC_locationMiddleDesc, \
								NC_locationFrontDesc, NC_locationBackDesc, NC_locationTopDesc, NC_locationBottomDesc),

		-- tipos especiales. Actualmente se aplican solo a geometrías de tipo mesh e indican si la pieza usa Point Cache (pc) o Transform Point Cache (tpc)
		NC_nonSpecifiedCache	=	"x",
		NC_pcCache				=	"pc",
		NC_tcCache				=	"tc",
		NC_icCache				=  "ic",
		NC_ncCache				=  "nc",
		
		NC_specialTypes			=	#(NC_nonSpecifiedCache, NC_pcCache, NC_tcCache, NC_icCache, NC_ncCache),
		
		NC_nonSpecifiedCacheDesc	=	"sin especificar",
		NC_pcCacheDesc				=	"point cache (cache de vertices)",
		NC_tcCacheDesc				=	"transform cache (cache de transformaciones)",
		NC_icCacheDesc				=  "inherited cache (cache heredado)",
		NC_ncCacheDesc				=  "no cache (sin cache)",
		
		NC_specialTypesDesc		=	#(NC_nonSpecifiedCacheDesc, NC_pcCacheDesc, NC_tcCacheDesc, NC_icCacheDesc, NC_ncCacheDesc),

		-- flags adicionales (para propiedades de los objetos)
		NC_notSpecifiedFlag				= "x",	--sin especificar
		NC_skinFlag						= "s",	--para huesos de skin que van a ser pesados en skin del personaje
		NC_extraFlag					= "e", --para huesos de tipo extra, ya sean de skin o de animacion
		NC_automaticFlag				= "a", --para huesos de mecanismo automatico, como musculos...
		NC_controlFlag					= "c",	--para los shapes que se usan como controles en los rigs
		NC_hiddenFlag					= "h",	--para objetos que deban estar ocultos
		NC_frozenFlag					= "f",--para objetos que deban estar congelados
		NC_inheritFlag					= "i", --para objetos que puedan tener desactivada la herencia de escala.
		NC_cacheFlag					= "p",--para objetos de tipo mesh que sean de cache
		NC_draftFlag					= "l0", --para objetos de tipo mesh en resolucion draft
		NC_lowResFlag					= "l1", --indica nivel bajo de modelado
		NC_middleResFlag				= "l2", --indica nivel medio de modelado
		NC_highResFlag					= "l3", --indica nivel alto de modelado
		NC_dynamicFlag					= "y", --indica si el objeto puede pertenecer a un sistema de dinámicas

		-- descripcion de los flags adicionales (para propiedades de los objetos)
		NC_notSpecifiedFlagDesc		= "sin especificar",
		NC_skinFlagDesc				= "para huesos de skin que van a ser pesados en skin del personaje",
		NC_extraFlagDesc				= "para huesos de tipo extra, ya sean de skin o de animacion",
		NC_automaticFlagDesc		= "para huesos u objetos de mecanismo automatico, como musculos...",
		NC_controlFlagDesc			= "para los objetos que se usan como controles en los rigs",
		NC_hiddenFlagDesc				= "para objetos que deban estar ocultos",
		NC_frozenFlagDesc				= "para objetos que deban estar congelados",
		NC_inheritFlagDesc				= "para objetos que puedan tener desactivada la herencia de escala",
		NC_cacheFlagDesc				= "para objetos de tipo mesh que sean de cache",
		NC_draftFlagDesc				= "indica nivel draft de modelado",
		NC_lowResDesc					= "indica nivel bajo de modelado",
		NC_middleResDesc				= "indica nivel medio de modelado",
		NC_highResDesc					= "indica nivel alto de modelado",
		NC_dynamicFlagDesc			= "para objetos con sistema de dinámicas (spring, reactor...)",
		
		NC_flagsDetailLevels = #(NC_notSpecifiedFlag, NC_cacheFlag, NC_draftFlag, NC_draftFlag, NC_lowResFlag, NC_middleResFlag, NC_highResFlag),
		
		NC_flags	= #(NC_notSpecifiedFlag, NC_skinFlag, NC_controlFlag, NC_extraFlag, NC_automaticFlag, NC_dynamicFlag, NC_hiddenFlag, NC_frozenFlag,  \
						NC_inheritFlag, NC_cacheFlag, NC_draftFlag, NC_lowResFlag, NC_middleResFlag, NC_highResFlag),
		
		NC_flagsDesc = #(NC_notSpecifiedFlagDesc, NC_skinFlagDesc, NC_controlFlagDesc, NC_extraFlagDesc, NC_automaticFlagDesc, NC_dynamicFlagDesc, \
						NC_hiddenFlagDesc, NC_frozenFlagDesc, NC_inheritFlagDesc, NC_cacheFlagDesc, NC_draftFlagDesc, NC_lowResDesc, NC_middleResDesc, NC_highResDesc),

		--flags que puede llevar cada tipo de pieza
		NC_classMeshFlags					=	#(NC_cacheFlag, NC_draftFlag, NC_lowResFlag, NC_middleResFlag, NC_highResFlag, NC_frozenFlag, 		NC_hiddenFlag),
		NC_classConnectFlags				=	#(NC_extraFlag, NC_cacheFlag),						
		NC_classFacialFlags					=	#(NC_controlFlag, NC_extraFlag, NC_automaticFlag, NC_frozenFlag, NC_hiddenFlag, NC_skinFlag, NC_inheritFlag),
		NC_classFacialEditFlags				=	#(NC_automaticFlag, NC_controlFlag, NC_extraFlag, NC_frozenFlag, NC_hiddenFlag),
		NC_classFacialEditNotFlags			=	#(NC_automaticFlag, NC_frozenFlag, NC_hiddenFlag, NC_skinFlag, NC_inheritFlag),
		NC_classMorphFlags					=	#(NC_notSpecifiedFlag),
		NC_classBipFlags					=	#(NC_notSpecifiedFlag),
		NC_classProxyFlags					=	#(NC_frozenFlag, NC_hiddenFlag),
		NC_classAnimEditFlags				=	#(NC_automaticFlag, NC_controlFlag, NC_extraFlag, NC_frozenFlag, NC_hiddenFlag),
		NC_classAnimFlags					=	#(NC_automaticFlag, NC_controlFlag, NC_extraFlag, NC_frozenFlag, NC_hiddenFlag, NC_dynamicFlag,NC_inheritFlag),
		NC_classSkinFlags					=	#(NC_automaticFlag, NC_controlFlag, NC_extraFlag, NC_frozenFlag, NC_hiddenFlag, NC_skinFlag, 	NC_inheritFlag),
		NC_classCamFlags					=	#(NC_notSpecifiedFlag),
		NC_classHairFlags					=	#(NC_frozenFlag,NC_hiddenFlag),
		NC_classClothFlags					=	#(NC_frozenFlag,NC_hiddenFlag),
		NC_classDynFlags					=	#(NC_notSpecifiedFlag, NC_automaticFlag, NC_frozenFlag, NC_hiddenFlag),
		NC_classFxFlags						=	#(NC_notSpecifiedFlag, NC_hiddenFlag, NC_frozenFlag),
		NC_classLightFlags     				= #(NC_notSpecifiedFlag, NC_hiddenFlag, NC_frozenFlag),

		--flags para modificadores
		NC_keepConnectedModifierFlag		=	"k", --flag para no desconectar un modificador
		NC_pointCacheModifierFlag			=	"p", --flag para no eliminar un modificador al sacar los caches

		--descripcion de flags para modificadores
		NC_keepConnectedModifierFlagDesc		=	"flag para no desconectar un modificador",
		NC_pointCacheModifierFlagDesc			=	"flag para no eliminar un modificador al sacar los caches",

		--flags de modificadores
		NC_modifierFlags = #(NC_keepConnectedModifierFlag, NC_pointCacheModifierFlag),

		--descripcion de los flags de modificadores
		NC_modifierFlagsDesc = #(NC_keepConnectedModifierFlagDesc, NC_pointCacheModifierFlagDesc),

		--tipos de bitmap para la parte 4 del nombre de las texturas
		NC_mapBump				= "b", -- Bump
		NC_mapDiffuse			= "d", -- Diffuse
		NC_mapMask				= "m", -- Mask
		NC_mapOpacity			= "o", -- Mask
		NC_mapNormal			= "n", -- Normal
		NC_mapDisplace			= "p", -- Displace
		NC_mapReflection		= "r",	-- Reflection
		NC_mapSpecular		= "s", -- Specular
		NC_mapTranslucency	= "t", -- Translucency

		--tipos de fichero
		NC_mapTypes = #(NC_mapBump, NC_mapDiffuse, NC_mapMask, NC_mapOpacity, NC_mapNormal, NC_mapDisplace, NC_mapReflection, NC_mapSpecular, NC_mapTranslucency),

		NC_mapBumpDesc				= "para mapas de bump",
		NC_mapDiffuseDesc			= "para mapas de diffuse",
		NC_mapMaskDesc				= "para mapas de máscara",
		NC_mapOpacitykDesc			= "para mapas de opacidad",
		NC_mapNormalDesc			= "para mapas de normales",
		NC_mapDisplaceDesc			= "para mapas de desplazamiento",
		NC_mapReflectionDesc		= "para mapas de reflexion",
		NC_mapSpecularDesc			= "para mapas de specular",
		NC_mapTranslucencyDesc	= "para mapas de translucencia",

		NC_mapTypesDesc = #(NC_mapBumpDesc, NC_mapDiffuseDesc, NC_mapMaskDesc, NC_mapOpacitykDesc, NC_mapNormalDesc, NC_mapDisplaceDesc, NC_mapReflectionDesc, NC_mapSpecularDesc, NC_mapTranslucencyDesc),

		--niveles de detalle en los bitmaps
		NC_mapDetailLevel0 = "x",
		NC_mapDetailLevel1 = "l1",
		NC_mapDetailLevel2 = "l2",

		NC_mapDetailLevels = #(NC_mapDetailLevel0, NC_mapDetailLevel1, NC_mapDetailLevel2),

		NC_mapDetailLevel0Desc = "sin especificar",
		NC_mapDetailLevel1Desc = "para nivel bajo de detalle",
		NC_mapDetailLevel2Desc = "para nivel alto de detalle",

		NC_mapDetailLevelsDesc = #(NC_mapDetailLevel0Desc, NC_mapDetailLevel1Desc, NC_mapDetailLevel2Desc),

		--subpartes finales del nombre de archivos de render y renderFx
		NC_seqRenderFileTypeTemp				= "temp",
		NC_seqRenderFileTypeCmap				= "cmap",
		NC_seqRenderFileTypeCmapSource	= "cmapSource",
		NC_seqRenderFileTypeSource			= "source",
		NC_seqRenderFileTypePass				= "pass",
		
		NC_seqRenderFileTypes = #(NC_seqRenderFileTypeTemp, NC_seqRenderFileTypeCmap, NC_seqRenderFileTypeCmapSource, NC_seqRenderFileTypeSource, 		NC_seqRenderFileTypePass),
		
		--descripciones
		NC_seqRenderFileTypeTempDesc				= "Para archivos temporales pero que hay que versionar por si hay que retocar algo y se debe partir de ellos",
		NC_seqRenderFileTypeCmapDesc				= "Para archivos de proyeccion de camaras",
		NC_seqRenderFileTypeCmapSourceDesc		= "Para archivos de precálculos GI de proyeccion de camaras",
		NC_seqRenderFileTypeSourceDesc				= "Para archivos de precálculos de GI",
		NC_seqRenderFileTypePassDesc				= "Para archivos de pases de render normales",
		
		NC_seqRenderFileTypesDesc = #(NC_seqRenderFileTypeTempDesc, NC_seqRenderFileTypeCmapDesc, NC_seqRenderFileTypeCmapSourceDesc, NC_seqRenderFileTypeSourceDesc, NC_seqRenderFileTypePassDesc),

		-- Nombre de shapes procedentes del archivo de chrShapes.
		NC_ANIM_mergeBase = "base",	
									
		NC_ANIM_mergeHandIk = "handIk",
		NC_ANIM_mergeElbow = "sphereShape",									
		NC_ANIM_mergeBreakElbow = "circleShape",
									
		NC_ANIM_mergeFootStep = "footStep",
		NC_ANIM_mergeKnee = "sphereShape",
		NC_ANIM_mergefkIk = "fkIk",
									
		-- Nombre de nodos de rig utilizados.
		-- SHP
		NC_ANIM_handIk = "handIk",
		NC_ANIM_elbow = "elbow",
		NC_ANIM_breakElbow = "breakElbow",

		NC_ANIM_footStep = "footStep",
		NC_ANIM_knee = "knee",
		NC_ANIM_breakKnee = "breakKnee",
		NC_ANIM_fkIk = "fkIk",
		NC_ANIM_fkIkArm = "fkIkArm",

		-- Nombre de piezas especificas del rig
		-- BON
		NC_ANIM_head = "head",
		NC_ANIM_neck = "neck",
		NC_ANIM_arm = "arm",
		NC_ANIM_hand = "hand",
		NC_ANIM_upperarm = "upperArm",
		NC_ANIM_forearm = "forearm",
		NC_ANIM_clavicle = "clavicle",
		NC_ANIM_spine = "spine",
		NC_ANIM_spineFkIk = "spineFkIk",
		NC_ANIM_root = "root",
		NC_ANIM_pelvis = "pelvis",
		NC_ANIM_leg = "leg",
		NC_ANIM_thigh = "thigh",
		NC_ANIM_calf = "calf",
		NC_ANIM_foot = "foot",
		NC_ANIM_base = "base",
		NC_ANIM_instep = "instep",
		NC_ANIM_toeCap = "toeCap",
		NC_ANIM_finger = "finger",

		--HLP
		NC_ANIM_pivotInside = "pivotInside",
		NC_ANIM_pivotOutside = "pivotOutside",
		NC_ANIM_pivotFootHeel = "pivotFootHeel",	
		NC_ANIM_pointScripts = "pointScripts",
		NC_ANIM_facialParent = "facialParent",

		--Facial
		NC_facialParent = "facialParent",

		--Cloth
		NC_CLOTH_drv = "drv",
		NC_CLOTH_drvPattern = "drv-*_*",
		NC_CLOTH_colPattern = "col-*_*",

		--Hair
		NC_HAIR_ref = "ref",
		NC_HAIR_draft = "draft",
		NC_HAIR_drv = "drv",
		NC_HAIR_scalp = "scalp",
		NC_HAIR_shadow = "shadow",
		NC_HAIR_wrap = "wrap",

		NC_HAIR_refPattern = "ref-*-*-*",
		NC_HAIR_draftPattern = "draft-*-*-*",
		NC_HAIR_drvPattern = "drv-*-*-*",
		NC_HAIR_scalpPattern = "scalp-*-*-*",
		NC_HAIR_shadowPattern = "shadow-*-*-*",
		NC_HAIR_wrapPattern = "wrap-*-*-*",		

		NC_HAIR_hair = "hair",
		NC_HAIR_fringe = "fringe",
		NC_HAIR_sideBurns = "sideBurns",
		NC_HAIR_nape = "nape",
		NC_HAIR_eyebrow = "eyebrow",
		NC_HAIR_eyebrows = "eyebrows",
		NC_HAIR_beard = "beard",
		NC_HAIR_moustache = "moustache",
		NC_HAIR_arms = "arms",
		NC_HAIR_arm = "arm",
				

		--DynConnectInfo
		NC_anyTag = "<any>",

		--Morph
		NC_morphVariationPattern = "var-*",

		--Puppet
		NC_puppetModName = "Puppet",
		NC_puppetPattern = "Puppet*",
		NC_puppetPresetPattern = "Puppet{*-*}",
		NC_puppetPresetGenericPattern = "*{*-*}",

		--Cheats
		NC_CheatModifierPattern	= "s????-c???",
		NC_SetReplacementPattern = "s????-c???-replacement",

		NC_assetRootPattern = "?:*\\asset\\",
		NC_sequenceRootPattern = "?:*\\sequence\\",

		--Patrones de rutas para usar en asset checker y otras
		NC_seqGenericPathPattern = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\*\\",
		NC_seqGenericNamePattern = "seq_????-*_cam???_*.max",

		NC_seqTexturePathPattern = "?:*\\sequence\\*\\seq_????-*\\texture\\",
		NC_seqPromoTexturePathPattern = "?:*\\sequence\\marketing\\promo\\seq_*-*\\texture\\",

		NC_seqLayoutPathPattern = "?:*\\sequence\\*\\seq_????-*\\layout\\",
		NC_seqLayoutNamePattern = "seq_????-*_layout.max",
		NC_seqLayoutCameraNamePattern = "seq_????-*_cam???_layout.max",
		NC_seqLayoutCamerasNamePattern = "seq_????-*_cam???-???_layout.max",

		NC_seqAnimPathPattern = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\anim\\",
		NC_seqAnimNamePattern = "seq_????-*_cam???_anim.max",
		NC_seqAnimExtrasNamePattern = "seq_????-*_cam???_anim(*).max",

		NC_seqCachePath = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\cache\\",
		NC_seqCacheSubfolderSourcePath = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\cache\\*\\source\\",
		NC_seqCacheSourcePath = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\cache\\source\\",
		NC_seqCacheNamePattern = "seq_????-*_cam???_cache.max",
		NC_seqCacheFxNamePattern = "seq_????-*_cam???_cacheFx.max",
		NC_seqCacheExtrasNamePattern = "seq_????-*_cam???_cache(*).max",

		NC_seqRenderPathPattern = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\render\\",
		NC_seqPromoPathPattern = "?:\\sequence\\marketing\\promo\\*\\cam\\cam???\\render\\",								
		NC_seqRenderPathRegExp = "^(?'unit'.):\\\\sequence\\\\(?'group'.*)\\\\seq_(?'seqnum'...)(?'seqlet'.)-(?'seqdesc'.*)\\\\cam\\\\cam(?'camnum'...)\\\\render\\\\$",
		NC_seqRenderNamePattern = "seq_????-*_cam???_render_*(*).max",
		NC_seqRenderNameNewPattern = "seq_????-*_cam???_render_(*-*).max",

		NC_seqStereoPathPattern = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\stereo\\",
		NC_seqStereoPathRegExp = "^(?'unit'.):\\\\sequence\\\\(?'group'.*)\\\\seq_(?'seqnum'...)(?'seqlet'.)-(?'seqdesc'.*)\\\\cam\\\\cam(?'camnum'...)\\\\stereo\\\\$",
		NC_seqStereoNamePattern = "seq_????-*_cam???_stereo.max",
		
		NC_seqRenderFxPathPattern = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\render\\",
		NC_seqRenderFxNamePattern = "seq_????-*_cam???_renderFx_*(*).max",
		NC_seqRenderFxNameNewPattern = "seq_????-*_cam???_renderFx_(*-*).max",

		NC_seqRenderGIpathPattern = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\render\\source\\",

		NC_seqPostPathPattern = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\post\\",
		NC_seqPostNamePattern = "seq_????-*_cam???_post_v??.*",
		NC_seqPostFusionNamePattern = "seq_????-*_cam???_post_v??.comp",
		NC_seqPostNukeNamePattern = "seq_????-*_cam???_post_v??.nk",
	
		NC_seqFramePathNewPattern = "\\\\lbdata002\\?\\frame\\*\\seq_????-*\\cam???\\",
		NC_seqFramePathPattern = "?:*\\sequence\\*\\seq_????-*\\cam\\cam???\\frame\\",
		NC_seqFrameNamePattern = "s????-*_c???_*(*)_????.*",
		NC_seqFrameNameNewPattern = "s????-*_c???_*(*-*-*)_????.*",
		NC_seqFrameFxNamePattern = "s????-*_c???_*(*)_????.*",
		NC_seqFrameFxNameNewPattern = "s????-*_c???_*(*-*-*)_????.*",
		NC_seqFrameFinalPattern = "s????-*_c???_????.tif*",
		NC_seqFrameRefFinalPattern = "ref-s????-*_c???_????.tif*",

		NC_assetPerSeqProdFilesPath= "\\\\lbdata001\\?\\documentation\\general\\assetsPerSequence\\",


		--Patrones de ficheros
								
		NC_filePresetRegExp = "chr_(?'name'.+){(?'presetPrefix'.+)-(?'presetSuffix'.+)}_(?'subtype'.+)_v(?'version'\\d\\d).prt",

		NC_presetFileName = "*_*{*-*}_anim_v??.prt",
		
		-------------------------------
		-------------------------------
		--LPM

		NC_lpmPassPattern = "*(*-*-*)", --patron para pases de LPM

		--partes del nombre de las capas de LPM del departamento de render y renderFx
		NC_LPMpassContentBG				= "bg",
		NC_LPMpassContentFG				= "fg",
		NC_LPMpassContentALL			= "all",
		NC_LPMpassContentFX				= "fx",
	
		NC_LPMpassContents				= #(NC_LPMpassContentBG, NC_LPMpassContentFG, NC_LPMpassContentALL, NC_LPMpassContentFX),
	
		NC_LPMpassTypeLIT				= "lit",
		NC_LPMpassTypePASS				= "pass",
	
		NC_LPMpassTypes					= #(NC_LPMpassTypeLIT, NC_LPMpassTypePASS),
	
		NC_LPMpassSubtypeGI				= "GI",
		NC_LPMpassSubtypeNoGI			= "noGI",
	
		NC_LPMpassSubtypeAO				= "AO",
		NC_LPMpassSubtypeZ				= "Z",
		NC_LPMpassSubtypeY				= "Y",
		NC_LPMpassSubtypeXYZ			= "XYZ",
		NC_LPMpassSubtypeETS			= "ETS",
		NC_LPMpassSubtypePupil			= "PUPIL",
		NC_LPMpassSubtypeMask			= "mask",
		NC_LPMpassSubtypeMatte			= "matte",
		NC_LPMpassSubtypeSelfi			= "selfilum",
		NC_LPMpassSubtypeVol			= "vol",
		NC_LPMpassSubtypeVel			= "vel",
		NC_LPMpassSubtypeRefl			= "reflec",
		NC_LPMpassSubtypeCmap			= "cmap",
		NC_LPMpassSubtypeElement		= "element",

		NC_LPMpassTypeLITsubtypes		= #(NC_LPMpassSubtypeGI, NC_LPMpassSubtypeNoGI),
		NC_LPMpassTypePASSsubtypes		= #(NC_LPMpassSubtypeAO, NC_LPMpassSubtypeZ, NC_LPMpassSubtypeY, NC_LPMpassSubtypeXYZ, NC_LPMpassSubtypeETS, NC_LPMpassSubtypePupil, NC_LPMpassSubtypeMask, NC_LPMpassSubtypeMatte,NC_LPMpassSubtypeSelfi, NC_LPMpassSubtypeVol, NC_LPMpassSubtypeVel, NC_LPMpassSubtypeRefl, NC_LPMpassSubtypeCmap, NC_LPMpassSubtypeElement),
		NC_LPMpassTypeSubtypes			= (NC_LPMpassTypeLITsubtypes + NC_LPMpassTypePASSsubtypes),

		--descripciones
		NC_LPMpassContentBGdesc			= "Para pases de Background",
		NC_LPMpassContentFGdesc			= "Para pases de Foregound",
		NC_LPMpassContentALLdesc		= "Para pases de Background y Foregound (Mixtos o indefinidos)",
	
		NC_LPMpassTypeLITdesc			= "Para pases con luces",
		NC_LPMpassTypePASSdesc			= "Para pases sin luces",
	
		NC_LPMpassSubtypeGIdesc			= "Para pases con GI",
		NC_LPMpassSubtypeNoGIdesc		= "Para pases sin GI",
	
		NC_LPMpassSubtypeAOdesc			= "Para pases de Ambient Occlusion",
		NC_LPMpassSubtypeZdesc			= "Para pases de Z depth",
		NC_LPMpassSubtypeYdesc			= "Para pases de Y depth",
		NC_LPMpassSubtypeMaskDesc		= "Para pases de máscaras",
		NC_LPMpassSubtypeMatteDesc		= "Para pases de mátte",
		NC_LPMpassSubtypeSelfiDesc		= "Para pases de materiales con autoiluminacion",
		NC_LPMpassSubtypeVelDesc		= "Para pases de información de velocidad",
		NC_LPMpassSubtypeReflDesc		= "Para pases de reflejos",
		NC_LPMpassSubtypeCmapDesc		= "Para pases de proyección de cámaras",
		NC_LPMpassSubtypeElementDesc	= "Para pases de render elements",

		NC_LPMpassTypeLITsubtypesDesc	= #(NC_LPMpassSubtypeGIdesc, NC_LPMpassSubtypeNoGIdesc),
		NC_LPMpassTypePASSsubtypesDesc	= #(NC_LPMpassSubtypeAOdesc, NC_LPMpassSubtypeZdesc, NC_LPMpassSubtypeYdesc, NC_LPMpassSubtypeMaskDesc, NC_LPMpassSubtypeMatteDesc, NC_LPMpassSubtypeSelfiDesc, NC_LPMpassSubtypeVelDesc, NC_LPMpassSubtypeReflDesc, NC_LPMpassSubtypeCmapDesc, NC_LPMpassSubtypeElementDesc),
		NC_LPMpassTypeSubtypesDesc		= (NC_LPMpassTypeLITsubtypesDesc + NC_LPMpassTypePASSsubtypesDesc),

		-------------------------------
		-------------------------------

		-------------------------------
		-------------------------------
		--PM pass manager
		NC_PMlayerName = "aux-passManager",
		NC_PMoverridesLayerName = "aux-overrides",
		NC_PMnodeSetsLayerName = "aux-nodeSets",

		NC_nonAssetLayers = #(NC_layerAuxObj, /*NC_layerAuxCloth, NC_layerAuxFx, */NC_layerAuxObjPointConstraint, NC_layerCam, NC_layerLight, NC_layerLayout, NC_layerLPM, NC_PMlayerName, NC_PMoverridesLayerName, NC_PMnodeSetsLayerName),
		
		NC_PMoutputPathPattern	= "\\\\lbdata002\\?\\frame\\*\\seq_????-*\\cam???\\pass\\",
		NC_PMoutputPathPatternPromo = "\\\\lbdata002\\?\\frame\\marketing\\*\\*\\*\\pass\\",
		NC_PMoutputPathRegExp	= "\\\\lbdata002\\(?'unit')\\frame\\(?'group')\\seq_(?'seqnum'...)(?'seqlet'.)-(?'seqdesc'.*)\\cam(?'camnum'...)\\pass\\",
									
		NC_PMoutputFilePattern	= "s????-*_c???_[pass]_",
		NC_PMoutputFilePatternPromo	= "*_c???_[pass]_",
		NC_PMoutputFileRegExp	= "s(?'seqnum'...)(?'seqlet'.)-(?'seqdesc'.*)_c(?'camnum'...)_[pass]_",

		NC_PMpassGroupPattern = "*-*", --patron para grupos de pases de PM

		--partes del nombre de los grupos de pases de PM
		NC_PMpassGroupContentBG		= "BG",
		NC_PMpassGroupContentFG		= "FG",
		NC_PMpassGroupContentALL	= "ALL",
		NC_PMpassGroupContentFX		= "FX",
		NC_PMpassGroupContentSOURCE	= "SOURCE",

		-- Patrones para grupos de pases
		NC_PMpassGroupBGnamePattern = "*BG-*",

		NC_PMpassGroupContents = #(NC_PMpassGroupContentBG, NC_PMpassGroupContentFG, NC_PMpassGroupContentALL, NC_PMpassGroupContentFX, NC_PMpassGroupContentSOURCE),

		NC_PMpassPattern		= "*(*-*-*)", --patron para pases de PM
		NC_PMpassRegExp		= "(?'contents'.*)((?'type'.*)-(?'subtype'.*)-(?'free'.*))",

		--partes del nombre de las capas de PM del departamento de render y renderFx
		NC_PMpassContentBG				= "bg",
		NC_PMpassContentFG				= "fg",
		NC_PMpassContentALL				= "all",
		NC_PMpassContentFX				= "fx",
	
		NC_PMpassContents				= #(NC_PMpassContentBG, NC_PMpassContentFG, NC_PMpassContentALL, NC_PMpassContentFX),
	
		NC_PMpassTypeLIT				= "lit",
		NC_PMpassTypePASS				= "pass",
	
		NC_PMpassTypes					= #(NC_PMpassTypeLIT, NC_PMpassTypePASS),
	
		NC_PMpassSubtypeGI				= "GI",
		NC_PMpassSubtypeNoGI			= "noGI",
	
		NC_PMpassSubtypeAO				= "AO",
		NC_PMpassSubtypeZ				= "Z",
		NC_PMpassSubtypeY				= "Y",
		NC_PMpassSubtypeXYZ				= "XYZ",
		NC_PMpassSubtypeETS				= "ETS",
		NC_PMpassSubtypePupil			= "PUPIL",
		NC_PMpassSubtypeMask			= "mask",
		NC_PMpassSubtypeMatte			= "matte",
		NC_PMpassSubtypeSelfi			= "selfilum",
		NC_PMpassSubtypeVel				= "vel",
		NC_PMpassSubtypeMotionVector	= "MVEC",
		NC_PMpassSubtypeRefl			= "reflect",
		NC_PMpassSubtypeCmap			= "cmap",
		NC_PMpassSubtypeElement			= "element",
		NC_PMpassSubtypeUV				= "UV",

		NC_PMpassTypeLITsubtypes		= #(NC_PMpassSubtypeGI, NC_PMpassSubtypeNoGI),
		NC_PMpassTypePASSsubtypes		= #(NC_PMpassSubtypeAO, NC_PMpassSubtypeZ, NC_PMpassSubtypeY, NC_PMpassSubtypeXYZ, NC_PMpassSubtypeETS, NC_PMpassSubtypePupil, NC_PMpassSubtypeMask, NC_PMpassSubtypeMatte,NC_PMpassSubtypeSelfi, NC_PMpassSubtypeVel, NC_PMpassSubtypeMotionVector, NC_PMpassSubtypeRefl, NC_PMpassSubtypeCmap, NC_PMpassSubtypeElement, NC_PMpassSubtypeUV),
		NC_PMpassTypeSubtypes			= (NC_PMpassTypeLITsubtypes + NC_PMpassTypePASSsubtypes),

		--descripciones
		NC_PMpassContentBGdesc			= "Para pases de Background",
		NC_PMpassContentFGdesc			= "Para pases de Foregound",
		NC_PMpassContentALLdesc			= "Para pases de Background y Foregound (Mixtos o indefinidos)",
	
		NC_PMpassTypeLITdesc			= "Para pases con luces",
		NC_PMpassTypePASSdesc			= "Para pases sin luces",
	
		NC_PMpassSubtypeGIdesc			= "Para pases con GI",
		NC_PMpassSubtypeNoGIdesc		= "Para pases sin GI",
	
		NC_PMpassSubtypeAOdesc			= "Para pases de Ambient Occlusion",
		NC_PMpassSubtypeZdesc			= "Para pases de Z depth",
		NC_PMpassSubtypeYdesc			= "Para pases de Y depth",
		NC_PMpassSubtypeXYZdesc			= "Para pases de XYZ mask",
		NC_PMpassSubtypeETSdesc			= "Para pases de ETS mask",
		NC_PMpassSubtypePupildesc		= "Para pases de máscaras de pupilas",
		NC_PMpassSubtypeMaskDesc		= "Para pases de máscaras",
		NC_PMpassSubtypeMatteDesc		= "Para pases de mátte",
		NC_PMpassSubtypeSelfiDesc		= "Para pases de materiales con autoiluminacion",
		NC_PMpassSubtypeVelDesc			= "Para pases de información de velocidad",
		NC_PMpassSubtypeMotionVectorDesc = "Para pases de información de motion vector",
		NC_PMpassSubtypeReflDesc		= "Para pases de reflejos",
		NC_PMpassSubtypeCmapDesc		= "Para pases de proyección de cámaras",
		NC_PMpassSubtypeElementDesc		= "Para pases de render elements",

		NC_PMpassTypeLITsubtypesDesc	= #(NC_PMpassSubtypeGIdesc, NC_PMpassSubtypeNoGIdesc),
		NC_PMpassTypePASSsubtypesDesc	= #(NC_PMpassSubtypeAOdesc, NC_PMpassSubtypeZdesc, NC_PMpassSubtypeYdesc, NC_PMpassSubtypeXYZdesc, NC_PMpassSubtypeETSdesc, NC_PMpassSubtypePupildesc, NC_PMpassSubtypeMaskDesc, NC_PMpassSubtypeMatteDesc, NC_PMpassSubtypeSelfiDesc, NC_PMpassSubtypeVelDesc, NC_PMpassSubtypeMotionVectorDesc,  NC_PMpassSubtypeReflDesc, NC_PMpassSubtypeCmapDesc, NC_PMpassSubtypeElementDesc),
		NC_PMpassTypeSubtypesDesc		= (NC_PMpassTypeLITsubtypesDesc + NC_PMpassTypePASSsubtypesDesc),

		NC_PMpassFreeNameObjectID = "objectID",
		-------------------------------
		-------------------------------


		-------------------------------
				
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------

		----------------------------------------------------------------------------------------------
		--	Devuelve el nombre real del objeto eliminando prefijos de asset. Si NOFLAGS vale
		--	true, entonces se eliminan también los sufijos de flags.
		--	Si el objeto no cumple el Naming Convention se devuelve el nombre completo sin 
		--	eliminar ninguna parte.
		--	Ejemplo: "chr_tadeo_skin_r_calf_x_x". El nombre devuelto será "skin_r_calf_x_x".
		--	Si NOFLAGS vale true, entonces se devolvería "skin_r_calf_x" eliminando la última
		--	parte del nombre
		----------------------------------------------------------------------------------------------
		fn getNameWithNoPrefix objName noCaches:false noFlags:true =
		(
			noPrefixName = objName
			
			if (this.ncOk objName) then
			(
				p = (filterstring objName "_")
				noPrefixName = p[3] + "_" + p[4] + "_" + p[5] + (if noCaches then "" else ("_" + p[6])) + (if noFlags then "" else ("_" + p[7]))
			)
			
			noPrefixName
		),

		----------------------------------------------------------------------------------------------
		--	Devuelve el nombre de la pieza eliminando los flags
		----------------------------------------------------------------------------------------------
		fn getNameWithNoFlags objName =
		(
			noFlagsName = objName
			
			if (this.ncOk objName) then
			(
				p = (filterstring objName "_")
				noFlagsName = p[1] + "_" + p[2] + "_" + p[3] + "_" + p[4] + "_" + p[5] + "_" + p[6] 
			)
			
			noFlagsName
		),

		----------------------------------------------------------------------------------------------
		--	Devuelve el nombre de la pieza eliminando los dos últimos sufijos (el de tipo de 
		--	cache y el de flags)
		----------------------------------------------------------------------------------------------
		fn getSimpleObjectName objName =
		(
			simpleObjName = objName
			
			if (this.ncOk objName) then
			(
				p = (filterstring objName "_")
				simpleObjName = p[1] + "_" + p[2] + "_" + p[3] + "_" + p[4] + "_" + p[5]
			)
			
			simpleObjName
		),

		----------------------------------------------------------------------------------------------
		-- devuelve el nombre del objeto opuesto al nombre pasado
		-- si no consigue crear el nombre opuesto, devuelve el original
		----------------------------------------------------------------------------------------------
		fn getOppositeObjectName objName = 
		(
			_oppositeObjName = undefined
			
			-- Es necesario que se cumpla en Naming Convention para poder encontrar el opuesto
			if this.ncOK objName then
			(
				_nameParts = (filterstring objName "_")
				_oppositePart = ""
				case _nameParts[4] of 
				(
					"l": _oppositePart = "r" 
					"r": _oppositePart = "l"
					"f": _oppositePart = "k"
					"k": _oppositePart = "f"
					"t": _oppositePart = "b"
					"b": _oppositePart = "t"
					"m": _oppositePart = "m"
				)
				
				-- si se ha encontrado opuesto recopilamos el original y el opuesto
				if _oppositePart != "" then
					_oppositeObjName = _nameParts[1] + "_" + _nameParts[2] + "_" + _nameParts[3] + "_" + _oppositePart + "_" + _nameParts[5] + "_" + _nameParts[6] + "_" + _nameParts[7]
			)
			
			_oppositeObjName
		),

		----------------------------------------------------------------------------------------------
		--	Devuelve el tipo de la pieza OBJ obteniéndolo a través de su nombre (anim, skin...)
		----------------------------------------------------------------------------------------------
		fn getObjectType obj =
		(
			objType = undefined 
			
			if this.ncOK obj.name then
			(
				parts = filterstring obj.name "_"
				objType = parts[3]
			)
			
			objType
		),


		--------------------------------------------------------------------------------------------------------
		-- Devuelve los FLAGS de un OBJ ordenados alfabeticamente en un array
		-- si no lo consigue devuelve un array vacio
		-- ALL: si está a TRUE devuelve tambien los flags que no están en el array de flags NC_flags
		--------------------------------------------------------------------------------------------------------
		fn getFlags obj all:false =
		(
			flags = #()
			
			if isValidNode obj and this.ncOK obj.name then
			(
				nameParts = filterString obj.name "_"
				
				for f in NC_flags do
				(
					if findString nameParts[7] f != undefined then
					(
						append flags f
						nameParts[7] = substituteString nameParts[7] f ""
					)
				)
				
				if all and nameParts[7].count != 0 then
					append flags nameParts[7]
				
				sort flags
				--for i=1 to nameParts[7].count do
				--append flags nameParts[7][i]
			)
			
			flags
		),

		--------------------------------------------------------------------------------------------------------
		-- Devuelve los FLAGS de un MODIFICADOR ordenados alfabeticamente en un array
		-- si no lo consigue devuelve un array vacio
		-- ALL: si está a TRUE devuelve tambien los flags que no están en el array de flags NC_modifierFlags
		--------------------------------------------------------------------------------------------------------
		fn getModifierFlags mod all:false =
		(
			flags = #()
			
			if superClassof mod == modifier and (findString mod.name ":") != undefined then
			(
				nameParts = filterString mod.name ":"
				
				for f in NC_modifierFlags do
				(
					if findString nameParts[2] f != undefined then
					(
						append flags f
						nameParts[2] = substituteString nameParts[2] f ""
					)
				)
				
				if all and nameParts[2].count != 0 then
					append flags nameParts[2]
				
				sort flags
			)
			
			flags
		),

		------------------------------------------------
		--Devuelve la parte solicitada de un nombre.
		--originalName: Nombre del que extraer la parte.
		--partIndex: Indice de la parte que se solicita.
		--type: Tipo de nombre que se está pasando, por defecto #object, pero puede ser: #object, ...
		------------------------------------------------
		fn getNamePart originalName partIndex type:#object separator:"_" checkNC:true = 
		(
			_namePart = undefined
			
			-- Solo hace la comprobacion del NC si checkNC esta activado (por defecto)
			if not checkNC or (this.ncOK originalName) then
			(
				case type of
				(
					#object:
					(
						_nameParts = filterstring originalName separator

						if (_nameParts.count > (partIndex-1)) do
							_namePart = _nameParts[partIndex]
					)
				)--case
			)
				
			_namePart
		),


		------------------------------------------------
		--Devuelve un array con todos los flags disponibles de la categoria indicada
		--type: String o name con el tipo
		--category: Categoria de flags que se solicita, por defecto #object
		------------------------------------------------
		fn getTypes type category:undefined =
		(
			_types = #()

			if this.ncRoot != undefined then --si se ha cargado el NC
			(
				_nodes = #()

				if category != undefined then _nodes = this.ncRoot.getNodes ("types/" + (type as string) + "/type") propertyName:"category" propertyValue:(category as string)
				else _nodes = this.ncRoot.getNodes ("types/" + (type as string) + "/type")

				_types = for n in _nodes collect n.getProperty "value"
			)--if

			_types
		),		

		------------------------------------------------
		--Devuelve un array con todos los tipos de assets
		------------------------------------------------
		fn getAssetTypes =
		(
			(this.getTypes "asset")
		),

		------------------------------------------------
		--Devuelve un array con todos los tipos de pieza
		------------------------------------------------
		fn getClasses =
		(
			(this.getTypes "class")
		),

		------------------------------------------------
		--Devuelve un array con todos los tipos de localizacion de una pieza
		------------------------------------------------
		fn getLocations =
		(
			(this.getTypes "location")
		),

		------------------------------------------------
		--Devuelve un array con todos los tipos de localizacion de una pieza
		------------------------------------------------
		fn getCacheTypes =
		(
			(this.getTypes "cache")
		),

		------------------------------------------------
		--Devuelve un array con todos los flags disponibles de la categoria indicada
		--category: Categoria de flags que se solicita, por defecto #object
		------------------------------------------------
		fn getFlagTypes category:#object =
		(
			(this.getTypes "flag" category:category)
		),

		------------------------------------------------
		--Devuelve un array con todos los tipos de contenido de un pase de render
		------------------------------------------------
		fn getPassContentTypes =
		(
			(this.getTypes "passContent")
		),

		------------------------------------------------
		--Devuelve un array con todos los tipos de pase de render
		------------------------------------------------
		fn getPassTypes =
		(
			(this.getTypes "passType")
		),

		--------------------------------------------------
		----Devuelve un array con todos los tipos de uso de de un pase de render segun su categoria
		----category: Categoria de pases que se solicita, por defecto undefined para que devuelva todos
		--------------------------------------------------
		fn getPassUse category:undefined =
		(
			(this.getTypes "passUse" category:category)
		),

		------------------------------------------------
		--Devuelve un array con todos los tipos de pase de render con luces
		------------------------------------------------
		fn getLightPassTypes =
		(
			(this.getPassUse category:#light)
		),

		------------------------------------------------
		--Devuelve un array con todos los tipos de pase de render especiales y sin luces
		------------------------------------------------
		fn getCustomPassTypes =
		(
			(this.getPassUse category:#pass)
		),

		------------------------------------------------
		--Devuelve un string con el tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn getPatterns category =
		(
			_patterns = #()

			if this.ncRoot != undefined then --si se ha cargado el NC
			(
				_nodes = this.ncRoot.getNodes ("patterns/pattern/") propertyName:"category" propertyValue:(category as string) --obtiene los nodos con esa categoria
				
				_patterns = for _node in _nodes collect _node.getProperty "value"
			)--if

			_patterns
		),

		------------------------------------------------
		--Devuelve un string con el tipo solicitado
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn getPattern id category:undefined =
		(
			_pattern = undefined

			if this.ncRoot != undefined then --si se ha cargado el NC
			(
				_nodes = this.ncRoot.getNodes ("patterns/pattern/") propertyName:"id" propertyValue:(id as string) --obtiene los nodos con ese id
				
				if _nodes.count != 0 and category != undefined then --si hay mas de uno lo filtra por categoria si se ha indicado
					for i = _nodes.count to 1 by -1 where (_nodes[i].getProperty "category") != (category as string) do deleteItem _nodes i
				
				if _nodes.count != 0 then _pattern = _nodes[1].getProperty "value"
			)--if

			_pattern
		),

		------------------------------------------------
		--Devuelve un entero con el numero de partes del tipo de nombre solicitado
		--id: String o Name con el tipo de nombre del que se busca su numero de partes
		--category: String o Name con la categoria del nombre del que se busca su numero de partes
		------------------------------------------------
		fn partCount id category:undefined =
		(
			_partsCount = 0

			if this.ncRoot != undefined then --si se ha cargado el NC
			(
				_nodes = this.ncRoot.getNodes "partsCount/count" propertyName:"id" propertyValue:(id as string) --obtiene los nodos con ese id
				
				if _nodes.count != 0 and category != undefined then --si hay mas de uno lo filtra por categoria si se ha indicado
					for i = _nodes.count to 1 by -1 where (_nodes[i].getProperty "category") != (category as string) do deleteItem _nodes i
				
				if _nodes.count != 0 then _partsCount = (_nodes[1].getProperty "value") as integer				
			)--if

			_partsCount
		),

		------------------------------------------------
		--Devuelve un string con el prefijo solicitado
		--id: String o Name con el tipo de prefijo que se busca
		------------------------------------------------
		fn prefix id =
		(
			_prefix = 0

			if this.ncRoot != undefined then --si se ha cargado el NC
			(
				_nodes = this.ncRoot.getNodes "prefixes/prefix" propertyName:"id" propertyValue:(id as string) --obtiene los nodos con ese 	id
				if _nodes.count != 0 then _prefix = _nodes[1].getProperty "value"
			)--if

			_prefix
		),

		------------------------------------------------
		--Devuelve un string con el tipo solicitado
		--subtype: String o Name con el subtipo solicitado
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn type subtype id category:undefined =
		(
			_type = undefined

			if this.ncRoot != undefined then --si se ha cargado el NC
			(
				_nodes = this.ncRoot.getNodes ("types/" + (subtype as string) + "/type/") propertyName:"id" propertyValue:(id as string) --obtiene los nodos con ese id
				
				if _nodes.count != 0 and category != undefined then --si hay mas de uno lo filtra por categoria si se ha indicado
					for i = _nodes.count to 1 by -1 where (_nodes[i].getProperty "category") != (category as string) do deleteItem _nodes i
				
				if _nodes.count != 0 then _type = _nodes[1].getProperty "value"
			)--if

			_type
		),

		------------------------------------------------
		--Devuelve un string con el tipo de archivo solicitado
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn fileType id category:undefined =
		(
			this.type "file" id category:category
		),

		------------------------------------------------
		--Devuelve un string con el tipo de archivo solicitado
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn fileType id category:undefined =
		(
			this.type "file" id category:category
		),

		------------------------------------------------
		--Devuelve un string con el tipo de pieza solicitado
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn assetType id category:undefined =
		(
			this.type "asset" id category:category
		),

		------------------------------------------------
		--Devuelve un string con el tipo de pieza solicitado
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn class id category:undefined =
		(
			this.type "class" id category:category
		),

		------------------------------------------------
		--Devuelve un string con tipo de localizacion solicitada
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn location id category:undefined =
		(
			this.type "location" id category:category
		),

		------------------------------------------------
		--Devuelve un string con tipo de cache solicitado
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn cacheType id category:undefined =
		(
			this.type "cache" id category:category
		),

		------------------------------------------------
		--Devuelve un string con tipo de flag de objeto solicitado
		--id: String o Name con el identificador del tipo solicitado
		------------------------------------------------
		fn objFlag id =
		(
			this.type "flag" id category:"object"
		),

		------------------------------------------------
		--Devuelve un string con tipo de flag de modificador solicitado
		--id: String o Name con el identificador del tipo solicitado
		------------------------------------------------
		fn modFlag id =
		(
			this.type "flag" id category:"modifier"
		),

		------------------------------------------------
		--Devuelve un string con tipo de flag de bitmap solicitado
		--id: String o Name con el identificador del tipo solicitado
		------------------------------------------------
		fn bitmapFlag id =
		(
			this.type "flag" id category:"bitmap"
		),

		------------------------------------------------
		--Devuelve un string con el tipo de contenido de un pase de iluminacion
		--id: String o Name con el tipo de prefijo que se busca
		------------------------------------------------
		fn passContent id =
		(
			this.type "passContent" id
		),

		------------------------------------------------
		--Devuelve un string con el tipo de un pase de iluminacion
		--id: String o Name con el tipo de prefijo que se busca
		------------------------------------------------
		fn passType id =
		(
			this.type "passType" id
		),

		------------------------------------------------
		--Devuelve un string con el tipo de uso de un pase de iluminacion
		--id: String o Name con el tipo de prefijo que se busca
		------------------------------------------------
		fn passUse id category:undefined =
		(
			this.type "passUse" id category:category
		),

		------------------------------------------------
		--Devuelve un string con el tipo de uso de un pase de iluminacion con luces
		--id: String o Name con el tipo de prefijo que se busca
		------------------------------------------------
		fn passLightUse id =
		(
			this.type "passUse" id category:"light"
		),

		------------------------------------------------
		--Devuelve un string con el tipo de uso de un pase de iluminacion especial
		--id: String o Name con el tipo de prefijo que se busca
		------------------------------------------------
		fn passCustomUse id =
		(
			this.type "passUse" id category:"pass"
		),

		------------------------------------------------
		--Devuelve un string con tipo de rig solicitado
		--id: String o Name con el identificador del tipo solicitado
		--category: String o Name con la categoria del tipo solicitado
		------------------------------------------------
		fn rigType id category:undefined =
		(
			this.type "rig" id category:category
		),

		----------------------------------------------------------------------------------------------
		-- Devuelve el nombre objeto a partir del nombre del nodo pasado o del string pasado. Devuelve el string vacio en cualquier error.
		-- No comprueba si es correcto el naming convention pero fallará si no se puede obtener la parte adecuada del string
		----------------------------------------------------------------------------------------------
		fn getObjectNameFromNodeName _nodeOrString =
		(
			-- Si le pasamos el nodo, obtenemos el nombre. Si no, tenemos ya el nombre
			if classof _nodeOrString != string do
			( 	
				if (isProperty _nodeOrString "name") then
					_nodeOrString = _nodeOrString.name
				else 
					_nodeOrString = ""
			)

			objType = getNamePart _nodeOrString 5 checkNC:False
			if objType == undefined do objType = ""
			
			objType
		),

		----------------------------------------------------------------------------------------------
		-- Devuelve el nombre del asset a partir del nombre del nodo completo (pasado nodo o string directamente), eliminando todos los flags
		-- No comprueba si es correcto el naming convention pero fallará si no se puede obtener la parte adecuada del string
		----------------------------------------------------------------------------------------------
		fn getAssetNameFromNodeName _nodeOrString =
		(
			-- Si le pasamos el nodo, obtenemos el nombre. Si no, tenemos ya el nombre
			if classof _nodeOrString != string do
			( 	
				if (isProperty _nodeOrString "name") then
					_nodeOrString = _nodeOrString.name
				else 
					_nodeOrString = ""
			)

			objType = getNamePart _nodeOrString 2 checkNC:False
			if objType == undefined do objType = ""

			objType
		),

		-------------------------------------------------------------
		-- Obtiene un nombre de nodo siguiendo las convenciones para la pieza indicada del personaje. Despues podemos utilizar getNodeByName para obtener el nodo.
		-- charName Nombre del personaje (ejemplo: chr_mike{std-std} o mike{std-std})
		-- location Pasar un item del naming convention que sea para especificar izquierda, derecha, centro... (location) de la lista disponible.
		-- objectName El nombre de la parte (head, calfIk...).
		-- specialFlag Definido, point cache, transform cache, ic...nc...
		-- aditionalFlags Contiene un grupo de flags combinados. No se realiza la combinacion aquí. (ejemplo: fh, c...)
		-- className Tipo del nodo. Puede ser Mesh, Anim, facial...
		-------------------------------------------------------------
		fn getCharNodeName charName className objectName aditionalFlags location:NC_locationNotSpecified specialFlag:NC_notSpecifiedFlag  = 
		( 
			_itemList = #()
			_name = ""

			-- Si no empieza por chr_ , añadirlo
			if not ( matchpattern charName pattern: (NC_chrPrefix	+ "*") ) do 
				append _itemList NC_chrPrefix

			-- TODO: comprobar que cada item existe en la lista disponible, para evitar posibles errores de ejecucion
			--if (findItem NC_locationTypes location) do 
			--(
			append _itemList charName 
			append _itemList className 
			append _itemList location 
			append _itemList objectName 
			append _itemList specialFlag 
			append _itemList aditionalFlags
			--)

			_name = lb.str.join _itemList "_"

			_name
		),


		------------------------------------------------------------------------
		-- Compara en la parte que define el nombre de asset si contiene el nombre pasado. 
		-- El nombre puede tener más contenido, esto compara si el tipo contiene esta parte simplemente.
		-- Ejemplo: legIkGoal -> le preguntamos si es de tipo leg devuelve true.
		------------------------------------------------------------------------
		fn objectNameMatchesString nodeName compareString = 
		(	
			-- Obtenemos el nombre de la pieza
			_objectName = getObjectNameFromNodeName nodeName

			-- Comprobamos si contiene el string que hemos pasado
			_ok = matchpattern _objectName pattern:("*"+ compareString +"*")
			_ok
		),

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		------------------------------------------------
		--Sustituye partes de un nombre que cumpla el naming convention. Devuelve undefined si no consigue hacer la sustitución y el string del nombre completo cambiado si lo consigue.
		--originalName: Nombre que cumple el naming convention.
		--partNum: Número de parte que vamos a sustituir.
		--newPart: Nuevo texto para esa parte
		--separator: Separador que usar al filtrar las partes de un nombre
		------------------------------------------------
		fn replaceNamePart originalName partNum newPart separator:"_" =
		(
			_newName = undefined

			_nameParts = FilterString originalName separator
			if _nameParts.count >= partNum then
			(
				_nameParts[partNum] = newPart

				_newName = ""
				for i=1 to _nameParts.count do _newName += _nameParts[i] + separator
				_newName = substring _newName 1 (_newName.count - 1)

				--ESTO NO SE PUEDE HACER ASI PORQUE PUEDE SUSTITUIR PARTES QUE NO DEBE
				--if partNum == 1 then _newName = substituteString originalName (_nameParts[1] + separator) (newPart + separator)
				--else if partNum == _nameParts.count then _newName = substituteString originalName (separator + _nameParts[partNum]) (separator + newPart)
				--else _newName = substituteString originalName (separator + _nameParts[partNum] + separator) (separator + newPart + separator)
			)

			_newName
		),

		------------------------------------------------
		--Comprueba si un nombre cumple el naming convention
		--nameToCheck: String con el nombre que comprobar
		--type: String o name con el tipo que comprobar: #object, #layer, #cam...
		--subtype: String o name con el subtipo que comprobar. Por ejemplo si type es #sequence, podemos comprobar subtype de #anim, #cache, #render...
		--separator: Separador que usar al filtrar las partes de un nombre
		------------------------------------------------
		fn isOkMessage nameToCheck type &errorMessage subtype:undefined separator:"_" =
		(
			_matchNC = false
			errorMessage = ""

			case (type as string) of
			(
				------------------------------------------------
				"object":
				(
					------------------------------------------------
					--comprueba el patron general

					_pfAuxNodePattern = this.getPattern "pFlowAuxNode" category:type
					_assetNodePattern = this.getPattern "asset" category:type
					
					_matchNCasset = MatchPattern nameToCheck pattern:_assetNodePattern
					_matchNCpf = MatchPattern nameToCheck pattern:_pfAuxNodePattern
					
					if _matchNCasset or _matchNCpf then _matchNC = true

					if not _matchNC then
					(
						errorMessage += "Error: The name does not match object naming convention\n"
						errorMessage += "The name must match the pattern: " + _assetNodePattern + " or " + _pfAuxNodePattern + "\n"
					)
					------------------------------------------------

					_nParts = filterstring nameToCheck separator

					------------------------------------------------
					--comrpueba los tipos de asset

					if _matchNCasset then
					(
						_types = this.getAssetTypes()
						_matchNCasset = _matchNC = (findItem _types _nParts[1]) != 0

						if not _matchNC then
						(
							errorMessage += "Error: The name match object pattern '" + _assetNodePattern + "' but the asset type is not recognized.\n"
							errorMessage += "Asset types:\n"
							for _type in _types do errorMessage += _type + "\n"
						)
					)--if
					------------------------------------------------

					------------------------------------------------
					--comrpueba los tipos de pieza

					if _matchNCasset then
					(
						_types = this.getClasses()
						_matchNCasset = _matchNC = (findItem _types _nParts[3]) != 0

						if not _matchNC then
						(
							errorMessage += "Error: The name match object pattern '" + _assetNodePattern + "' but the object type is not recognized.\n"
							errorMessage += "Object types:\n"
							for _type in _types do errorMessage += _type + "\n"
						)
					)--if
					------------------------------------------------

					------------------------------------------------
					--comprueba las localizaciones

					if _matchNCasset then
					(
						_types = this.getLocations()
						_matchNCasset = _matchNC = (findItem _types _nParts[4]) != 0

						if not _matchNC then
						(
							errorMessage += "Error: The name match object pattern '" + _assetNodePattern + "' but the location type is not recognized.\n"
							errorMessage += "Locations:\n"
							for _type in _types do errorMessage += _type + "\n"
						)
					)--if
					------------------------------------------------

					------------------------------------------------
					--comrpueba los tipos de cache

					if _matchNCasset then
					(
						_types = this.getCacheTypes()
						_matchNCasset = _matchNC = (findItem _types _nParts[6]) != 0

						if not _matchNC then
						(
							errorMessage += "Error: The name match object pattern '" + _assetNodePattern + "' but the cache type is not recognized.\n"
							errorMessage += "Cache types:\n"
							for _type in _types do errorMessage += _type + "\n"
						)
					)--if
					------------------------------------------------

					------------------------------------------------
					--comprueba los flags

					if _matchNCasset then
					(
						_flags = this.getFlags category:type						
						_nameFlags = _nParts[7]

						for _fl in _flags where findString _nameFlags _fl != undefined do _nameFlags = substituteString _nameFlags _fl ""

						if _nameFlags != "" then _matchNCasset = _matchNC = false

						if not _matchNC then
						(
							errorMessage += "Error: The name match object pattern '" + _assetNodePattern + "' but the object one or more of the flags are not recognized.\n"
							errorMessage += "Allowed Flags:\n"
							for _flag in _flags do errorMessage += _flag + "\n"
						)
					)--if
					------------------------------------------------
				)--object
				------------------------------------------------

				------------------------------------------------
				"camera":
				(
					------------------------------------------------
					--comprueba el patron general

					_cameraNodePattern = this.getPattern "camera" category:#object
					
					if MatchPattern nameToCheck pattern:_cameraNodePattern then _matchNC = true
					------------------------------------------------

					------------------------------------------------
					--comrpueba si es numerica la segunda parte de la camara

					if _matchNC then
					(
						_nParts = filterstring nameToCheck separator
						_matchNC = lb.math.isNumeric _nParts[2]

						if not _matchNC then
						(
							errorMessage += "Error: The name match material pattern '" + _cameraNodePattern + "' but the second part of the name must be numeric.\n"
						)--if
					)
					else
					(
						errorMessage += "Error: The name does not match camera naming convention\n"
						errorMessage += "The name must match the pattern: " + _cameraNodePattern + "\n"
					)--if else
					------------------------------------------------
				)--camera
				------------------------------------------------

				------------------------------------------------
				"layer":
				(
					------------------------------------------------
					--comprueba los patrones generales

					_assetLayerPattern = this.getPattern "asset" category:#layer
					_layerPatterns = this.getPatterns #layer
					_index = findItem _layerPatterns _assetLayerPattern
					if _index != 0 then deleteItem _layerPatterns _index

					--comprueba si cumple algun patron de capa especial
					for _lp in _layerPatterns where not _matchNC and MatchPattern nameToCheck pattern:_lp do _matchNC = true

					--si no es una capa especial mira a ver si es una capa de asset
					if not _matchNC then
					(
						_matchNC = MatchPattern nameToCheck pattern:_assetLayerPattern

						if _matchNC then
						(
							_nParts = filterstring nameToCheck separator

							------------------------------------------------
							--comrpueba los tipos de asset
							
							_types = this.getAssetTypes()
							_matchNC = (findItem _types _nParts[1]) != 0
							
							if not _matchNC then
							(
								errorMessage += "Error: The name match asset layer pattern '" + _assetLayerPattern + "' but the asset type is not recognized.\n"
								errorMessage += "Asset layers:\n"
								for _type in _types do errorMessage += _type + "\n"
								
							)
							------------------------------------------------
						)
						else --no cumple ningun patron, por tanto, se rellena el mensaje de error
						(
							errorMessage += "Error: The name does not match layer naming convention.\n"
							errorMessage += "The name must match one of this patterns:\n"
							errorMessage += _assetLayerPattern + "\n"
							for _ptrn in _layerPatterns do errorMessage += _ptrn + "\n"
						)
					)--if
					------------------------------------------------
				)--layer
				------------------------------------------------

				------------------------------------------------
				"material":
				(
					------------------------------------------------
					--comprueba el patron general

					_assetMatPattern = this.getPattern "asset" category:#material

					if MatchPattern nameToCheck pattern:_assetMatPattern then _matchNC = true
					------------------------------------------------

					_nParts = filterstring nameToCheck separator

					------------------------------------------------
					--comrpueba los tipos de asset

					if _matchNC then
					(
						_types = this.getAssetTypes()
						_matchNC = (findItem _types _nParts[1]) != 0

						if not _matchNC then
						(
							errorMessage += "Error: The name match material pattern '" + _assetMatPattern + "' but the asset type is not recognized.\n"
							errorMessage += "Asset types:\n"
							for _type in _types do errorMessage += _type + "\n"
						)
					)
					else
					(
						errorMessage += "Error: The name does not match material naming convention\n"
						errorMessage += "The name must match the pattern: " + _assetMatPattern + "\n"
					)--if else
					------------------------------------------------
				)--material
				------------------------------------------------

				------------------------------------------------
				"bitmap":
				(
					------------------------------------------------
					--comprueba el patron general

					_assetBitmapPattern = this.getPattern "asset" category:type
					
					_matchNC = MatchPattern nameToCheck pattern:_assetBitmapPattern
					
					if not _matchNC then
					(
						errorMessage += "Error: The name does not match bitmap naming convention\n"
						errorMessage += "The name must match the pattern: " + _assetBitmapPattern + "\n"
					)
					------------------------------------------------

					_nParts = filterstring nameToCheck separator

					------------------------------------------------
					--comrpueba los tipos de asset

					if _matchNC then
					(
						_types = this.getAssetTypes()
						_matchNC = (findItem _types _nParts[1]) != 0

						if not _matchNC then
						(
							errorMessage += "Error: The name match bitmap pattern '" + _assetBitmapPattern + "' but the asset type is not recognized.\n"
							errorMessage += "Asset types:\n"
							for _type in _types do errorMessage += _type + "\n"
						)
					)--if
					------------------------------------------------

					------------------------------------------------
					--comrpueba los tipos de asset

					if _matchNC then
					(
						_flags = this.getFlags category:#bitmap
						_matchNC = (findItem _flags _nParts[4]) != 0

						if not _matchNC then
						(
							errorMessage += "Error: The name match bitmap pattern '" + _assetBitmapPattern + "' but the bitmap type flag is not recognized.\n"
							errorMessage += "Bitmaps type flag:\n"
							for _flag in _flags do errorMessage += _flag + "\n"
						)
					)--if
					------------------------------------------------
				)--bitmap
				------------------------------------------------
			)--case

			_matchNC
		),

		------------------------------------------------
		--Comprueba si un nombre cumple el naming convention
		--nameToCheck: String con el nombre que comprobar
		--type: String o name con el tipo que comprobar: #object, #layer, #cam...
		--subtype: String o name con el subtipo que comprobar. Por ejemplo si type es #sequence, podemos comprobar subtype de #anim, #cache, #render...
		--separator: Separador que usar al filtrar las partes de un nombre
		------------------------------------------------
		fn isOk nameToCheck type subtype:undefined separator:"_" =
		(
			this.isOkMessage nameToCheck type &errorMessage subtype:subtype separator:separator
		),

		--------------------------------------------------------------------------------------------------------
		-- función que indica si el nombre pasado cumple el Naming Convention
		--type:
		--#object - para piezas
		--#layer - para capas
		--#material - para materiales
		--#bitmap - para nombre de bitmaps
		--#cam - para camaras
		--#assetFile- para archivos de asset
		--#seqFile - para archivos de secuencia
		--------------------------------------------------------------------------------------------------------
		fn ncOK n type:#object =
		(
			originName = n
			n = filterstring n "_"
			
			cumpleNC = false
			
			case type of
			(
				#object:
				(
					--Excepción para los objetos del particle flow que se nombran automaticamente.
					if not matchPattern originName pattern:"fx_*->fx_*" then
					(
						if (n.count == NC_objectNamesLength) then
						(
							cumpleNC = true
							-- comprobamos que el tipo, la clase y localización son correctos
							if   (finditem NC_assetTypes n[1] == 0) or (finditem NC_classTypes n[3] == 0) or (finditem NC_locationTypes n[4] == 0) then cumpleNC = false 
							
							if cumpleNC then  	-- comprobamos los flags
								for i=1 to n[7].count do if (finditem NC_flags i) == 0 then cumpleNC == false
						)
						else
							cumpleNC = false
					)
					else
					(
						cumpleNC = true
					)
				)--object
				
				#cam:
				(
					if (n.count == NC_camNamesLength) or (n.count ==NC_stereocamNamesLength) then
					(
						cumpleNC = true
						-- comprobamos que el tipo, la clase y localización son correctos
						if n[1] != NC_classCam then cumpleNC = false 
					)
					--Si es una cámara de proyección
					else if originName == NC_projectionCameraName then
						cumpleNC = true
					else
						cumpleNC = false
				)--cam
				
				#layer:
				(
					if (n.count == NC_layerNamesLength) and not (finditem NC_assetTypes n[1] == 0) then
					(
						cumpleNC = true
					)
					else if (findItem NC_nonAssetLayers originName) != 0 or originName == "0" then --si es la capa 0 o una capa auxiliar: "_auxObj_", "_cam_", "_light_"
					(
						cumpleNC = true
					)
					--Si la capa es del tipo "_auxObj-xxxxxx_", compruebo que la primera parte antes del guion es "_auxObj" y que el último caracter es "_"
					else if ((originName == NC_layerAuxObj) or (matchPattern originName pattern:((substring NC_layerAuxObj 1 (NC_layerAuxObj.count-1)) + "-?*")))  then
					(
						cumpleNC = true
					)
					--Si la capa es del LPM (zz-LPM) entonces está correcto
					else if originName == "zz-LPM" then
					(
						cumpleNC = true
					)
					else
						cumpleNC = false
				)--layer
				
				#material:
				(
					if (n.count == NC_matNamesLength) then
					(
						cumpleNC = true
						if (finditem NC_assetTypes n[1] == 0) and n[1] != NC_matPrefix then cumpleNC = false 
					)
					else
						cumpleNC = false
				)
				
				#bitmap:
				(
					if (n.count == NC_bitmapNamesLength) then
					(
						cumpleNC = true
						if (finditem NC_assetTypes n[1] == 0) then cumpleNC = false
						if (findItem NC_mapTypes n[4] == 0) then cumpleNC = false
						if ((findItem NC_mapDetailLevels n[5]) == 0) then cumpleNC = false
					)
					else
						cumpleNC = false 
				)--bitmap
				
				#assetFile:
				(
					--Tomamos el nombre y le quitamos la extension
					_filename = getFilenameFile originName
					--Primero miramos que la secuencia del nombre de archivo cuadre con el patrón de un archivo de asset.
					if matchPattern _filename pattern:"*_*_*_v??" then
					(
						--Dividiremos el nombre del archivo por sus "_"
						_nameArray = filterString _filename "_"
						
						if _nameArray.count == this.NC_assetFileNameLength then --se asegura de que tiene el numero correcto de partes
						(
							--Comprobaremos que la primera parte sea parte de los tipos de assets conocidos
							if (findItem NC_assetTypes _nameArray[1]) != 0 then
							(
								--Ahora miraremos que el tipo de archivo pertenezca a los subtipos de assets conocidos.
								if (findItem NC_assetFileTypes (filterString _nameArray[3] "-")[1]) != 0 then
								(
									--Por último miraremos que los dos ultimos dígitos son un número.
									if lb.math.isNumeric(substring _nameArray[4] (_nameArray[4].count-1) 2) then
									(
										--Miramos si es un set de secuencia
										if matchPattern _filename pattern:"set_???_mesh-seq???(cam???)_v??.max" then
										(
											--Miro si los tres digitos tras seq y cam son numéricos.
											if lb.math.isNumeric (substring (filterString _nameArray[3] "-")[2] 4 3) and lb.math.isNumeric (substring (filterString _nameArray[3] "-")[2] 11 3) then
												cumpleNC = true
											else
												cumpleNC = false
										)
										else
											-- Cumple el naming convention
											cumpleNC = true
									) -- if de si es numérico el numero de versión.
									else
										cumpleNC = false
									
								) --if de subtipo de archivo de asset
								else
									cumpleNC = false
							)--if de tipo de asset
							else
								cumpleNC = false
						)
						else
							cumpleNC = false
					)--if de matchpattern inicial
					else
						cumpleNC = false
					
				)--assetFile
				
				#seqFile:
				(
					--Tomamos el nombre y le quitamos la extension
					_filename = getFilenameFile originName
					
					--Dividiremos el nombre del archivo por sus "_"
					_nameArray = filterString _filename "_"
						
					--Primero miramos que la secuencia del nombre de archivo cuadre con el patrón de un archivo de secuencia
					if matchPattern _filename pattern:"seq_???*_cam???_*" then
					(
						_seqNumberParts = filterString _nameArray[2] "-"
						
						--Miraremos que el número de secuencia es el correcto. 
						--if lb.math.isNumeric _nameArray[2]  or (_nameArray[2].count == 4 and lb.math.isNumeric(substring _nameArray[2] 1 3)) then
						
						_continue = true
						
						if lb.math.isNumeric _nameArray[2] then
							_continue = true
						else
						(
							if not lb.math.isNumeric(substring _seqNumberParts[1] 1 3) then
								_continue = false
							else
							(
								if _seqNumberParts[1].count < 3 or _seqNumberParts[1].count > 4 then _continue = false
									
								--	La siguiente línea se elimina porque ahora se permiten etiquetas junto al número de secuencia que pueden tener cualquier tamaño y contenido
			-- 							if _continue and _seqNumberParts.count == 2 and _seqNumberParts[2].count != 3 then _continue = false
							)
						)
						
						if _continue then
						(
							--Ahora miraremos que la cámara tenga un número correcto
							if lb.math.isNumeric (substring _nameArray[3] (_nameArray[3].count - 2) 3) then
							(
								--Miraremos que el tipo de archivo pertenezca a los subtipos de secuencia conocidos.
								if (findItem NC_seqFileTypes (filterString _nameArray[4] "-()")[1]) != 0 then
								(
									--Si en este punto el archivo no es de render ya habría pasado en naming convention
									if (filterString _nameArray[4] "-")[1] != NC_renderFileName then
									(
										cumpleNC = true
									)
									--Al ser de render tendremos que mirar el tipo de pase y su nomenclatura
									else
									(
										--Miramos si tiene cinco partes el nombre
										if _nameArray.count == 5 then
											cumpleNC = true
										else
											cumpleNC = false
									)
								) --if de subtipo de archivo de secuencia
								else
									cumpleNC = false 
							)-- Numero de cámara correcto.
							else
								cumpleNC = false 
						) -- if de si es numérico el numero de secuencia.
						else
							cumpleNC = false
					)
					--Si encaja con el tipo de secuencia de render completa
					else if matchPattern _filename pattern:(NC_seqPrefix + "_???*_cam???*_render_*") then
					(
						--Miraremos que el número de secuencia es el correcto. 
						if lb.math.isNumeric _nameArray[2]  or (_nameArray[2].count == 4 and lb.math.isNumeric(substring _nameArray[2] 1 3))then
						(
							--Miraremos que el número de secuencia es el correcto. 
							if lb.math.isNumeric _nameArray[2] then
							(
								--Miramos que tenga 4 partes.
								if _nameArray.count == 4 then 
									cumpleNC = true
								else
									cumpleNC = false
							)
							else
								cumpleNC = false
						)
						else
							cumpleNC = false
					)
					else if matchPattern _filename pattern:(NC_seqPrefix + "_???*_cam???*_" + NC_layoutFileName) then
					(
						cumpleNC = true
						--if not ((matchPattern _nameArray[3] pattern:"cam???") or (matchPattern _nameArray[3] pattern:"cam????") or (matchPattern _nameArray[3] pattern:"cam???*-cam???*")) then
						--cumpleNC = false
					)
					else if matchPattern _filename pattern:(NC_seqPrefix + "_???*_" + NC_layoutFileName) then
					(
						cumpleNC = true
					)
					else
					(
						cumpleNC = false
					)
				)
			
				#atmospheric:
				(
					if n.count == 3 and n[1] == NC_fxPrefix then
						cumpleNC = true
					else
						cumpleNC = false
				)
				
			)
				
			cumpleNC
		),		

		------------------------------------------------
		--Rellena toda la información de naming convention
		------------------------------------------------
		fn fillInfo =
		(
			this.ncDocFilePath = lb.project.getProjectInfoLocalFolder()
			_ncFile = this.ncDocFilePath + this.ncDocFileName
			
			if doesFileExist _ncFile then --si el archivo de naming conventions exite lo procesa.
			(
				_xmlDoc = lb.xml.load _ncFile --lee el archivo de configuracion de NCs
				this.ncRoot = (_xmlDoc.getNodes "namingConvention")[1] --array de nodos del xml que son raiz de un naming convention. coge el primero			
			)--if
		),

		--------------------------------------------------------------------------------------------------------
		-- ordena los flags en el nombre de un OBJ
		-- devuelve UNDEFINED si no consigue realizar la operacion
		--------------------------------------------------------------------------------------------------------
		fn sortFlags obj = 
		(
			success = false
			
			if isValidNode obj and this.ncOK obj.name then
			(		
				nameParts = filterString obj.name "_"
				tempFlags = nameParts[7]
				flags = #()
				--for i=1 to tempFlags.count do append flags tempFlags[i]
				for f in NC_flags do
				(
					if findString nameParts[7] f != undefined then
					(
						append flags f
						nameParts[7] = substituteString nameParts[7] f ""
					)
				)
				sort flags
				if flags.count != 0 then
				(
					tempFlags = ""
					for f in flags do
						append tempFlags f
				)			
				
				newName = undefined
				if tempFlags.count != 0 then
					newName = nameParts[1] + "_" + nameParts[2] + "_" + nameParts[3] + "_" + nameParts[4] + "_" + nameParts[5] + "_" + nameParts[6] + "_" + tempFlags
				if newName != undefined then
				(
					obj.name = newName
					success = true
				)
			)

			success
		),

		--------------------------------------------------------------------------------------------------------
		-- añade al nombre del objeto OBJ el FLAG indicado en el parámetro. Devuelve 
		-- TRUE o FALSE dependiendo de si se consiguió o no añadir el flag
		--------------------------------------------------------------------------------------------------------
		fn addFlag obj flag removeFlags:false =
		(
			flagsUpdated = false
			
			if (this.ncOK obj.name) and (finditem NC_flags flag != 0) and (flag != NC_notSpecifiedFlag) then
			(
				nameParts = (filterstring obj.name "_")					
				f = nameParts[7]
				if removeFlags or (f == NC_notSpecifiedFlag) then f = ""
				if (findString f flag) == undefined and (finditem NC_flags flag) != 0 then
					f = append f flag
				flags = f	
				
				-- cambiamos el nombre del objeto por el nuevo con los flags actualizados
				obj.name = nameParts[1] + "_" + nameParts[2] + "_" + nameParts[3] + "_" + nameParts[4] + "_" + nameParts[5] + "_" + nameParts[6] + "_" + flags
				this.sortFlags obj
				
				flagsUpdated = true
			)
			
			flagsUpdated
		),

		--------------------------------------------------------------------------------------------------------
		-- añade al nombre del objeto OBJ el FLAG indicado en el parámetro. Devuelve 
		-- TRUE o FALSE dependiendo de si se consiguió o no añadir el flag
		--------------------------------------------------------------------------------------------------------
		fn removeFlag obj flag =
		(
			flagsUpdated = false
			
			if (this.ncOK obj.name) and (finditem NC_flags flag != 0) and (flag != NC_notSpecifiedFlag) then
			(
				nameParts = (filterstring obj.name "_") -- capturamos el flag antiguo
				_flagsPart = nameParts[7]
				
				if findString nameParts[7] flag != undefined then
				(
					_flagsPartLength = _flagsPart.count
					_flagsPart = substituteString _flagsPart flag ""
					
					if _flagsPart == "" then _flagsPart = NC_notSpecifiedFlag
					obj.name = (substring obj.name 1 (obj.name.count - _flagsPartLength)) + _flagsPart
					flagsUpdated = true
				)
			-- 		flags = nameParts[7]
			-- 		flagPos = findString flags flag
			-- 		if flagPos != undefined then
			-- 		(
			-- 			flagsTMP = ""		-- nuevos flags que le vamos a poner al objeto
			-- 			for i = 1 to flags.count where i != flagPos do append flagsTMP flags[i]	-- añadimos todos los flags menos el que queremos quitar
			-- 			if flagsTMP.count == 0 then flagsTMP = NC_notSpecifiedFlag					-- si hemos borrado el único flag que quedaba lo sustituimos por el no especificado
			-- 			-- cambiamos el nombre del objeto por el nuevo con los flags actualizados
			-- 			obj.name = nameParts[1] + "_" + nameParts[2] + "_" + nameParts[3] + "_" + nameParts[4] + "_" + nameParts[5] + "_" + nameParts[6] + "_" + flagsTMP
			-- 			
			-- 			flagsUpdated = true
			-- 		)
			)
			
			flagsUpdated
		),	

		--------------------------------------------------------------------------------------------------------
		-- Elimina todos los flags del objeto. Devuelve 
		-- TRUE o FALSE dependiendo de si se consiguió o no aborrar los flags
		--------------------------------------------------------------------------------------------------------
		fn removeAllFlags obj =
		(
			flagsUpdated = false
			
			if isValidNode obj and (this.ncOK obj.name) then
			(
				nameParts = (filterstring obj.name "_") -- capturamos el flag antiguo
				nameParts[7] = NC_notSpecifiedFlag -- sustituimos los flags por el No Especificado
				obj.name = nameParts[1] + "_" + nameParts[2] + "_" + nameParts[3] + "_" + nameParts[4] + "_" + nameParts[5] + "_" + nameParts[6] + "_" + nameParts[7]
				
				flagsUpdated = true
			)
			
			flagsUpdated
		),

		--------------------------------------------------------------------------------------------------------
		-- sustituye al nombre del objeto OBJ los FLAGS indicados en el array indicado como parámetro. 
		-- Devuelve TRUE o FALSE dependiendo de si se consiguió o no añadir los flags
		--------------------------------------------------------------------------------------------------------
		fn setFlags obj flags =
		(
			flagsUpdated = true
			
			removeAllFlags obj
			for f in flags do 
				if not (this.addFlag obj f) then flagsUpdated = false
			
			flagsUpdated
		),

		--------------------------------------------------------------------------------------------------------
		--devuelve TRUE si el ITEM tiene el FLAG, FALSE sino
		--el ITEM puede ser un objeto o un modificador
		--si es un modificador pregunta por los flags de modificadores
		--si es un objeto pregunta por los flags de objetos
		--------------------------------------------------------------------------------------------------------
		fn hasFlag item flag =
		(
			flags = #() --flags del item

			if superclassof item == modifier then --si es un modificador obtiene los flags de modificador
				flags = getModifierFlags item
			else --si es un objeto obtiene los de objeto
				flags = getFlags item
				
			(findItem flags flag != 0)
		),

		--------------------------------------------------------------------------------------------------------
		--Sustituye la unidad de una ruta de red o local por otra
		-- targetString: la cadena donde vamos a buscar
		-- newUnit: la unidad que vamos a poner nueva.
		-- oldUnit: la unidad vieja que vamos a sustituir (por defecto z)
		--------------------------------------------------------------------------------------------------------
		fn swapUnit targetString newUnit oldUnit:"z" =
		(
			targetString = toLower targetString
			--Limpiamos los parametros dejando solo la letra de unidad.
			oldUnit = toLower (substituteString (substituteString oldUnit "\\" "") ":" "")
			newUnit = toLower (substituteString (substituteString newUnit "\\" "") ":" "")
			result = targetString
			
			if oldUnit.count == 1 and newUnit.count == 1 then
			(
				--Miramos si es una ruta de red
				if findString targetString ("\\" + oldUnit + "\\") != undefined then
				(
					result = substituteString targetString ("\\" + oldUnit + "\\") ("\\" + newUnit + "\\")
				)
				else if findString targetString (oldUnit + ":\\") != undefined then
				(
					result = substituteString targetString (oldUnit + ":\\") (newUnit + ":\\")
				)
			)
			result
		),

		--------------------------------------------------------------------------------------------------------
		-- Sustituye la parte <any> del nombre por asterisco
		--------------------------------------------------------------------------------------------------------
		fn convertAnyTagToPattern objName patternSymbol:"*" =
		(
			substituteString objName NC_anyTag patternSymbol
		),

		--------------------------------------------------------------------------------------------------------
		-- Sustituye la parte del nombre por  <any> 
		--------------------------------------------------------------------------------------------------------
		fn convertPatternToAnyTag objName patternSymbol:"*" =
		(
			substituteString objName patternSymbol NC_anyTag 
		),
		--------------------------------------------------------------------------------------------------------
		-- función devuelve el indice de los elementos en la escena (cuenta copias) , recibe el nombre del objeto
		-- Devuelve -1 si el nombre no puede ser tratado. 
		-- Si se trata del objeto nº 0 devuelve 0
		-- Cualquier otra copia devuelve la versión entera de su numeración #005 -> 5
		--------------------------------------------------------------------------------------------------------
		fn getAssetNamingIndex _assetName =
		(
			
			_index = undefined
			_assetNameParts = filterstring _assetName "_"
			_notFoundResult = true
			for _part in _assetNameParts where _notFoundResult do
			(
				if (matchpattern _part pattern:("*(*)*") or matchpattern _part pattern:("*{*}*")) then
				(
					if matchpattern _part pattern:("*(*)*") then
					(
						_notFoundResult = false
						_index = filterstring _part ")"
					) 
					if matchpattern _part pattern:("*{*}*") then
					(
						_notFoundResult = false
						_index = filterstring _part "}"
					) 
				)
			)
			if _index != undefined then
			(
				if (_index.count >1) then 
				(
					_index = filterstring _index[_index.count] "#"
					_index = (_index[_index.count] as integer)
				)
				else _index = 0
			)
			else _index = -1
			return _index
		),	
		------------------------------------------------
		--@fn: string | removeAssetNumber | devuelve el nombre de un asset sin indice
		--@gets: str | _assetName | nombre del asset
		--Si el nombre no cumple el NC devuelve el propio nombre y un aviso
		------------------------------------------------
		fn removeAssetNumber _assetName =
		(
			_assetNameParts = filterstring _assetName "_"
			_notFoundResult = true
			_workingString = undefined
			_stringPart = undefined
			for _part in _assetNameParts where _notFoundResult do
			(
				if (matchpattern _part pattern:("*(*)*") or matchpattern _part pattern:("*{*}*")) then
				(
					if matchpattern _part pattern:("*(*)*") then
					(
						_notFoundResult = false
						_workingString = filterstring _part "#"
						_stringPart = _part
					) 
					if matchpattern _part pattern:("*{*}*") then
					(
						_notFoundResult = false
						_workingString = filterstring _part "#"
						_stringPart = _part
					) 
				)
			)
			if not _notFoundResult then	_assetName = substitutestring _assetName _stringPart _workingString[1]
			return _assetName
		),	
		------------------------------------------------
		--@fn: string | removeAssetNumber | Cambia el numero de un asset por otro siguiendo el formato
		--@gets: str | _assetName | nombre del asset , int | _number | nuevo numero
		------------------------------------------------
		fn setAssetNameNumber _assetName _number = 
		(
			if _number <= 999 then
			(
				_assetName = lb.nc.removeAssetNumber _assetName 
				if _number != 0 then
				(
					_assetNameParts = filterString _assetName "_"
					if _number <= 9 then
					(
						_assetNameParts[2] = _assetNameParts[2] + "#00" + (_number as string)
					)
					else if  _number <= 99 then
					(
						_assetNameParts[2] = _assetNameParts[2] + "#0" + (_number as string)
					)
					else _assetNameParts[2] = _assetNameParts[2] + "#" + (_number as string)
					_newName = _assetNameParts[1]
					for i = 2 to _assetNameParts.count do
					(
						_newName = _newName + "_" + _assetNameParts[i]
					)
				)
				else _newName = _assetName
				return _newName
			)
			else 
			(
				lb.message.show "El indice no debe exceder 000"
				return _assetName
			)
		),
			
		------------------------------------------------
		--COMMON
		------------------------------------------------
			
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
			this.fillInfo()
		),
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: create | Ejecución al crearse la instancia del struct.
		------------------------------------------------
		on create do
		(
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_nc
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	_ncRootBckp = if (lb != undefined) and (isProperty lb #nc) and (lb.nc != undefined) and (lb.nc.ncRoot != undefined) then lb.nc.ncRoot else undefined

	lib_nc() --crea la libreria	

	if _ncRootBckp != undefined then lb.nc.ncRoot = _ncRootBckp

	if (lb != undefined) and (isProperty lb #xml) and (lb.xml != undefined) then lb.nc.init()
)