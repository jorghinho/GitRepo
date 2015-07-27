------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: libreria de manejo de custom attributes
------------------------------------------------------------------------------------------------------------------------------------------------
(
	--------------------------------------------------------------------------------------------------------
	--@attributes: CA_camInfo | CAMINFO indica en las cámaras datos del rango de filmado.	
	--------------------------------------------------------------------------------------------------------
	CA_camInfo = attributes camInfo
	(
		parameters main
		(
			recStart							type:#integer		animatable:false	default:0		--@var: integer | recStart | Inicio del rango de camara.
			recEnd								type:#integer		animatable:false	default:100 	--@var: integer | recEnd | Final del rango de camara.
			similarCam						type:#string			animatable:false	default:""		--@var: string | similarCam | Camara parecida.
		)
	)
	
	------------------------------------------------
	--@attributes: CA_animTracks | ANIMINFO es un atributo definido como global, de forma que cada vez que se actualice su definición, ésta también se actualizará en todas las piezas que lo tengan asignado.
	------------------------------------------------
	CA_animTracks = attributes animInfo		
	(
		local animTracks = #()																					  --@var: array | animTracks | Variable que guarda todas las pistas animables de la pieza. Hay que iniciarla al cargar la escena.
		
		parameters main
		(
			CA_description type:#string	animatable:false	default:"Almacena las pistas animables de una pieza" --@var: string | CA_description | guarda la descripcion del CA.
			CA_version type:#integer		animatable:false	default:1 										 --@var: integer | CA_version | Guarda la version.
			trackIndex		type:#stringTab 	default:""	tabSizeVariable:true								 --@var: stringTab | trackIndex | Pistas de animación. Si valen UNDEFINED significa que son separadores.
			trackNames		type:#stringTab	default:""	tabSizeVariable:true									 --@var: stringTab | trackNames | Nombres completos de las pistas.

			keyable			type:#boolTab					tabSizeVariable:true								 --@var: boolTab | keyable | Propiedad keyable de las pistas. Si vale UNDEFINED significa que no hay controlador de animación.
			alias				type:#stringTab	default:""	tabSizeVariable:true								 --@var: stringTab | alias | Nombres que se mostrarán en el channel box. Si vale "" significa que no tiene alias.
			defaults			type:#stringTab	default:""	tabSizeVariable:true								 --@var: stringTab | defaults | Valores por defecto de cada pista. Se almacenan en strings que hay que ejecutar.
		)
	)

	------------------------------------------------
	--@attributes: CA_virtualNodes | Atributo que guarda el padre y el hijo virtual.
	------------------------------------------------	
	CA_virtualNodes = attributes virtualNodes
	(
		parameters main
		(
			CA_description type:#string	animatable:false	default:"Almacena el padre virtual y los hijos virtuales" --@var: string | CA_description | guarda la descripcion del CA.
			CA_version type:#integer		animatable:false	default:1 											  --@var: integer | CA_version | Guarda la version.
			vParentNode	type:#maxObject 																			  --@var: maxObject | vParentNode | Guarda el padre.
			vChildrenNode	type:#maxObjectTab tabSizeVariable:true 												  --@var: maxObjectTab | vChildrenNode | Guarda el hijo virtual.
		)
	)

	------------------------------------------------
	--@attributes: CA_skinRigInfo | skinRigInfoCA es un atributo definido como global, de forma que cada vez que se actualice su definición, ésta también se actualizará en todas las piezas que lo tengan asignado. Esto es útil para los casos en los que haga falta añadir nuevos parámetros a skinInfo.
	------------------------------------------------	
	CA_skinRigInfo = attributes skinRigInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version
			CA_description type:#string	animatable:false	default:"Almacena las soluciones de skin que lleva aplicadas la pieza." --@var: string | CA_description | guarda la descripcion del CA.
			CA_version type:#integer		animatable:false	default:1 															--@var: integer | CA_version | Guarda la version.			
			solutions type:#string default:"#()"  																					--@var: string | solutions | Almacena un string con una array de arrays. Cada array alamacena el nomdre de la solucion, el nombre del fichero de la solucion y los parametros especificos de esa solucion.
		)
	)

	------------------------------------------------
	--@attributes: CA_animRigInfo | animRigInfoCA es un atributo definido como global, de forma que cada vez que se actualice su definición, ésta también se actualizará en todas las piezas que lo tengan asignado. Esto es útil para los casos en los que haga falta añadir nuevos parámetros a skinInfo.
	------------------------------------------------		
	CA_animRigInfo = attributes animRigInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version
			CA_description type:#string	animatable:false	default:"Almacena las soluciones de skin que lleva aplicadas la pieza." --@var: string | CA_description | guarda la descripcion del CA.
			CA_version type:#integer		animatable:false	default:1 															--@var: integer | CA_version | Guarda la version.			
			solutions type:#string default:"#()"																					--@var: string | solutions | Almacena un string con una array de arrays. Cada array alamacena el nomdre de la solucion, el nombre del fichero de la solucion y los parametros especificos de esa solucion.
		)
	)

	------------------------------------------------
	--@attributes: CA_morphInfo | Custom attribute para la herramienta de morpher, el objetivo es definir la propiedades de cada gesto, para que la herramienta sepa lo que hacer con ellas.
	------------------------------------------------	
	CA_morphInfo = attributes morphInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version
			CA_description		type:#string				animatable:false	default:"Almacena las propiedades del morph." 		--@var: string | CA_description | guarda la descripcion del CA.
			CA_version				type:#integer				animatable:false	default:1 										--@var: integer | CA_version | Guarda la version.			
			
			morphName				type:#string 				animatable:false	default:""										--@var: string | morphName | almacena el nombre de morph.
			isProgressive			type:#boolean				animatable:false	default:false									--@var: boolean | isProgressive | indica si es o no un morph progresivo
			progressivePercent	type:#integer				animatable:false	default:0											--@var: integer | progressivePercent | el porcentage progresivo del morpher
			
			isFix						type:#boolean				animatable:false	dafault:false								--@var: boolean | isFix | indica si es un morph de correccion
			morphsToFix			type:#maxObjectTab	animatable:false																--@var: maxObjectTab | morphsToFix | almacena los morphs a corrregir.
			fixStartPercent		type:#integer				animatable:false	default:0											--@var: integer | fixStartPercent | indica el porcentaje en el cual empieza a actuar el fix.
		)
	)

	------------------------------------------------
	--@attributes: CA_testAttrib | Custom attribute de test.
	------------------------------------------------
	CA_testAttrib = attributes testAttrib -- attribID:#(0x90d88c8, 0x6ba78078)
	(
		parameters main
		(
			--guarda la descripcion del CA y su version
			CA_description type:#string	animatable:false	default:"Test." 														--@var: string | CA_description | Guarda la descripcion del CA.
			CA_version type:#integer		animatable:false	default:1 															--@var: integer | CA_version | Guarda la version.			
			
			param1 type:#string default:"nothing"																					--@var: string | param1 | test1.
			param2 type:#string default:"nothing"																					--@var: string | param2 | test2.			
		)
	)

	------------------------------------------------
	--@attributes: CA_ARS_fixEyes | Custom attribute para el snap del fix de los ojos.
	------------------------------------------------
	CA_ARS_fixEyes = attributes fixEyes
	(
		parameters main rollout:rollFixEyes
		(
			--guarda la descripcion del CA y su version
			CA_description		type:#string			animatable:false	default:"Almacena la informacion del fix de los ojos."	--@var: string | CA_description | Guarda la descripcion del CA.
			CA_version			type:#integer			animatable:false	default:1 												--@var: integer | CA_version | Guarda la version.			
			
			fixEyes				type:#float 			animatable:true		ui:(spnFixEyes, sldFixEyes)								--@var: float | fixEyes | almacena el valor del fix.
			eyesLookAtControl	type:#maxObject			animatable:false															--@var: maxObject | eyesLookAtControl | almacena el shape de lookAt de la mascara.
			eyesFixControl		type:#maxObject			animatable:false															--@var: maxObject | eyesFixControl | almacena el shape de fix de la mascara.
			eyesExpose			type:#maxObject			animatable:false															--@var: maxObject | eyesExpose | almacena el expose transform que calcula la direrencia de rotacion del fix.
			multiplier			type:#float 			animatable:false	default:10.0											--@var: float | multiplier | almacena el valor del multiplicador de la mascara.
		)
		
		---------------------------------------------------------------------------
		-------------------- FUNCIONES --------------------------------------
		---------------------------------------------------------------------------

		------------------------------------------------
		--@fn: undefined | setEyesLookAtControl | almacena el shape de control de lookat.
		--@gets: node | controlShape | Shape que hace la funcion de controlador.
		------------------------------------------------		
		fn setEyesLookAtControl controlShape =
		(
			eyesLookAtControl = nodeTransformMonitor node:controlShape forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false
		)

		------------------------------------------------
		--@fn: undefined | setEyesFixControl | almacena el shape de control del fix.
		--@gets: node | controlShape | Shape que hace la funcion de controlador.
		------------------------------------------------		
		fn setEyesFixControl controlShape = 
		(
			eyesFixControl = nodeTransformMonitor node:controlShape forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false
		)

		------------------------------------------------
		--@fn: undefined | setEyesExpose | almacena el nodo expose que calcula la diferencia de rotaciones.
		--@gets: node | exposeNode | Expose tiene el calculo de las rotaciones.
		------------------------------------------------		
		fn setEyesExpose exposeNode =
		(
			eyesExpose = nodeTransformMonitor node:exposeNode forwardTransformChangeMsgs:false forwardFlagNodesMessages:false forwardEnumDependents:false
		)

		------------------------------------------------
		--@fn: undefined | setMultiplier | almacena el valor del multiplicador.
		--@gets: integer | mult | valor del multiplicador.
		------------------------------------------------				
		fn setMultiplier mult =
		(
			multiplier = mult
		)

		------------------------------------------------
		--@fn: undefined | snapFixEyes_LookAtToFix | hace snap del fix de 0 a 1, mantiene la mirada en el punto donde se encuentra actualmente.
		------------------------------------------------			
		fn snapFixEyes_LookAtToFix =
		(
			
			if eyesExpose != undefined and eyesFixControl != undefined and eyesLookAtControl != undefined then
				if eyesExpose.node != undefined and eyesFixControl.node != undefined and eyesLookAtControl.node != undefined then
				(print "lookAtToFix"
					disableSceneRedraw()
					with animate on
					(	
						cont = 1
						flag = true
						limit = 10
						
						while flag and cont < limit do
						(
							rotX = eyesExpose.node.localEulerX
							print rotX	
							eyesFixControl.node.position.controller[2].controller[3].controller.value += (rotX/(multiplier as float))
							
							rotZ = eyesExpose.node.localEulerZ
							print rotZ
							eyesFixControl.node.position.controller[2].controller[1].controller.value -= (rotZ/(multiplier as float))
							
							rotZ = eyesExpose.node.localEulerZ
							rotX = eyesExpose.node.localEulerX
							
							if rotZ < 0.001 and rotZ > -0.001 and rotX < 0.001 and rotX > -0.001 then
								flag = false
							
							cont += 1
						)
							
						fixEyes = 1.0
						select eyesFixControl.node
					)
					--eyesFixControl.node.scale = [1,1,1]
					--eyesLookAtControl.node.scale = [0,0,0]
					enableSceneRedraw()
				)
		)

		------------------------------------------------
		--@fn: undefined | snapFixEyes_FixToLookAt | hace snap del fix de 1 a 0, mantiene la mirada en el punto donde se encuentra actualmente.
		------------------------------------------------		
		fn snapFixEyes_FixToLookAt =
		(
			if eyesExpose != undefined and eyesFixControl != undefined and eyesLookAtControl != undefined then
				if eyesExpose.node != undefined and eyesFixControl.node != undefined and eyesLookAtControl.node != undefined then
				(print "fixToLookAt"
					disableSceneRedraw()
					with animate on
					(
						fixEyes = 0.0		
						
						cont = 1
						flag = true
						limit = 10
						
						while flag and cont < limit do
						(
							rotZ = eyesExpose.node.localEulerZ
							print rotZ	
							eyesLookAtControl.node.rotation.controller[2].controller[2].controller.value += rotZ
							
							rotX = eyesExpose.node.localEulerX
							print rotX
							eyesLookAtControl.node.position.controller[2].controller[3].controller.value -= (rotX/(multiplier as float))
							
							rotZ = eyesExpose.node.localEulerZ
							rotX = eyesExpose.node.localEulerX
							
							if rotZ < 0.001 and rotZ > -0.001 and rotX < 0.001 and rotX > -0.001 then
								flag = false
							
							cont += 1
						)
						
						fixEyes = 0.0
							
						select eyesLookAtControl.node
					)
					--eyesFixControl.node.scale = [0,0,0]
					--eyesLookAtControl.node.scale = [1,1,1]
					enableSceneRedraw()
				)
		)

		------------------------------------------------
		--@fn: undefined | snapFixEyes | hace snap del fix de 0 a 1 y viceversa, mantiene la mirada en el punto donde se encuentra actualmente.
		------------------------------------------------		
		fn snapFixEyes =
		(
			if fixEyes > 0.99 then
				snapFixEyes_FixToLookAt()
			else if fixEyes < 0.01 then
				snapFixEyes_LookAtToFix()
		)
		
		---------------------------------------------------------------------------
		-------------------- ROLLOUTS ----------------------------------------
		---------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------------------------------------------------
		--@rollout: rollFixEyes | Contiene la Eyes Fix.
		------------------------------------------------------------------------------------------------------------------------------------------------		
		rollout rollFixEyes "Eyes Fix"
		(
			spinner	spnFixEyes	""	width:40 pos:[115,10] range:[0,1,1]	scale:0.1
			slider	sldFixEyes	""	width:120 pos:[3,5]	range:[0,1,1]	scale:0.1
			button	btnSnapFixEyes	"Snap: Fix/LookAt"	pos:[3,42] width:155 height:20 -- Boton de Snap del fix.
			
			on btnSnapFixEyes pressed do
				snapFixEyes()
		)		
	)--CA_ARS_fixEyes

	------------------------------------------------
	--@attributes: CA_ARS_linkConstraint | Custom attribute de link constraint.
	------------------------------------------------	
	CA_ARS_linkConstraint = attributes ARS_linkConstraint --attribID:#(0x40c8f423, 0x7496fb37)
	(
		---------------------------------------------------------------------------
		-------------------- VARIABLES ---------------------------------------
		---------------------------------------------------------------------------
		
		local rollLinkConstraint		--@var: rollout | rollLinkConstraint | Guarda el rollout del linkConstraint.
		local OBJ 						--@var: node | OBJ | objeto que tiene el atributo.
		local LCcontroller				--@var: controller | LCcontroller | controlador link constraint que lleva puesto el objeto.
		
		---------------------------------------------------------------------------
		-------------------- PARAMETROS -------------------------------------
		---------------------------------------------------------------------------
		
		parameters main rollout:rollLinkConstraint
		(
			--guarda la descripcion del CA y su version
			CA_description type:#string default:"Controla el link constraint para el rig de las piezas." --@var: string | CA_description | Guarda la descripcion del CA.
			CA_version type:#integer default:1 															 --@var: integer | CA_version | Guarda la version.
			
			worldParent type:#node 																		 --@var: node | worldParent | Guarda el padre del mundo.
		)
		
		---------------------------------------------------------------------------
		-------------------- FUNCIONES --------------------------------------
		---------------------------------------------------------------------------

		------------------------------------------------
		--@fn: undefined | getMainObject | inicia la variable OBJ, que contiene el objeto al que está vinculado este atributo.
		------------------------------------------------		
		fn getMainObject =
		(
			OBJ = (refs.dependentNodes (refs.dependents this)[1])[1]
		)

		------------------------------------------------
		--@fn: undefined | getLCcontroller | Inicia la variable LCcontroller, que contiene el controlador Link Constraint del objeto con el que estamos trabajando.
		------------------------------------------------		
		fn getLCcontroller =
		(
			LCcontroller = undefined
			if OBJ != undefined and (classof OBJ.controller == link_constraint) then
				LCcontroller = OBJ.controller
			
			LCcontroller
		)

		------------------------------------------------
		--@fn: boolean | existLCcontroller | Devuelve TRUE o FALSE dependiendo de si el objeto con el que trabajamos tiene o no un Link Constraint Controller.
		------------------------------------------------		
		fn existLCcontroller =
		(
			getLCcontroller() != undefined
		)
		
		---------------------------------------------------------------------------
		-------------------- ROLLOUTS ----------------------------------------
		---------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------------------------------------------------
		--@rollout: rollLinkConstraint | Contiene el rollout Link Constraint.
		------------------------------------------------------------------------------------------------------------------------------------------------			
		rollout rollLinkConstraint "Link Constraint"
		(
			---------------------------------------------------------------------------
			-------------------- VARIABLES ---------------------------------------
			---------------------------------------------------------------------------
			
			local selectedIndex = undefined 		--@var: integer | selectedIndex | Guarda el indice del rollout de Link Constraint.
			
			---------------------------------------------------------------------------
			-------------------- CONTROLES --------------------------------------
			---------------------------------------------------------------------------
			
			dotNetControl lvLinks "System.Windows.Forms.ListView" pos:[5,10] width:150 height:95
			
			spinner spnStartTime "Start Time: " pos:[45,110] width:80 height:15 fieldWidth:40 range:[-10000,10000,0] scale:1 type:#integer
			
			checkbutton btnAddLink "Add Link" pos:[5,130] width:75 height:20
			button btnLinkToWorld "Link to World" pos:[80,130] width:75 height:20
			button btnDeleteLink "Delete Link" pos:[5,155] width:150 height:20
				
			---------------------------------------------------------------------------
			-------------------- FUNCIONES --------------------------------------
			---------------------------------------------------------------------------

			------------------------------------------------
			--@fn: undefined | initListView | Inicia el estilo y columnas del listView.
			------------------------------------------------				
			fn initListView =
			(
				lvLinks.gridLines = true 
				lvLinks.View = (dotNetClass "System.Windows.Forms.View").details
				lvLinks.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
				lvLinks.headerStyle = (dotnetclass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
				
				lvLinks.showItemTooltips = true
				lvLinks.labelEdit = false
				lvLinks.fullRowSelect = true
				lvLinks.hideSelection = false
				lvLinks.scrollable = true
				lvLinks.gridlines = false
				
				lvLinks.Columns.add "Frame" 45
				lvLinks.Columns.add "Frame" 105
			)

			------------------------------------------------
			--@fn: undefined | fillListView | Rellena el listView con los targets del controlador linkConstraint que tiene el objeto. Si no tiene el controlador.
			------------------------------------------------				
			fn fillListView = 
			(
				if LCcontroller != undefined then
				(
					lvLinks.items.clear()
					
					for i = 1 to LCcontroller.getNumTargets() do
					(
						target = "World"
						
						if (LCcontroller.getNode i) != undefined then 
						(
							target = (LCcontroller.getNode i).name
							if worldParent != undefined and ((LCcontroller.getNode i).name == worldParent.name) then
								target = "Virtual World: " + target
						)						
						
						lvLinks.items.add (LCcontroller.getFrameNo i as string)
						lvLinks.items.item[i-1].subitems.add target
					)
				)
			)

			------------------------------------------------
			--@fn: undefined | initControls | Actualiza el estado de los controles del rollout, activándolos o desactivándolos dependiendo de si encuentra el controlador linkConstraint en la pieza
			------------------------------------------------			
			fn initControls = 
			(
				rollLinkConstraint.initListView()
				
				if existLCcontroller() then
				(
					fillListView()
					btnAddLink.enabled = btnDeleteLink.enabled = btnLinkToWorld.enabled = true
				)
				else
				(
					lvLinks.items.add ""
					lvLinks.items.item[0].subitems.add "No Link constraint found"
					btnAddLink.enabled = btnDeleteLink.enabled = btnLinkToWorld.enabled = false
				)
			)
			
			------------------------------------------------------------------------------------------------
			--EVENTS
			------------------------------------------------------------------------------------------------
			
			------------------------------------------------
			--COMMON
			------------------------------------------------

			------------------------------------------------
			--@event: open | Evento que se lanza al abrir el rollout.
			--@control: rollout | rollLinkConstraint | El elemento que se abre.
			------------------------------------------------			
			on rollLinkConstraint open do
			(
				getMainObject()		-- objeto al que pertenece el modificador
				getLCcontroller()
				initControls()
			)

			------------------------------------------------
			--@event: changed | Evento que se lanza al apretar el boton AddLink.
			--@control: button | btnAddLink | Elemento que dispara el evento.
			------------------------------------------------			
			on btnAddLink changed val do
			(
				if val and existLCcontroller() then
				(
					o = pickObject()
					
					if isValidNode o then
					(
						LCcontroller.addTarget o currentTime
						rollLinkConstraint.fillListView()
					)
					
					btnAddLink.checked = false
				)
			)
			
			------------------------------------------------
			--@event: pressed | Evento que se lanza al apretar el boton.
			--@control: button | btnLinkToWorld | Elemento que dispara el evento.
			------------------------------------------------
			on btnLinkToWorld pressed do
			(
				if existLCcontroller() then
				(
					if (OBJ.modifiers != undefined) then
					(
						nameParts = filterString OBJ.name "_"
						--prefix = (nameparts[1] + "_" + nameParts[2])
						baseObj = worldParent
						
						if baseObj != undefined then
						(
							LCcontroller.addTarget baseObj currentTime
						)
						else
							LCcontroller.addWorld frameNo:currentTime
					)
					else
						LCcontroller.addWorld frameNo:currentTime
					
					rollLinkConstraint.fillListView()
				)
			)
			
			------------------------------------------------
			--@event: pressed | Evento que se lanza al apretar el boton.
			--@control: button | btnDeleteLink | Elemento que dispara el evento.
			------------------------------------------------
			on btnDeleteLink pressed do
			(
				if existLCcontroller() then
				(
					
					for i = lvLinks.selectedItems.count to 1 by -1 do
					(
						index = (lvLinks.selectedItems.item[i-1].index + 1)
						LCcontroller.deleteTarget index
					)
					rollLinkConstraint.fillListView()
				)
			)
			
			------------------------------------------------
			--@event: SelectedIndexChanged | Evento que se lanza al cambiar el indice.
			--@control: listView | lvLinks | Elemento que dispara el evento.
			------------------------------------------------
			on lvLinks SelectedIndexChanged e do
			(
				if (lvLinks.SelectedIndices.count) != 0 then
				(
					selectedIndex = ((lvLinks.SelectedIndices.item[0] + 1))
					spnStartTime.value = LCcontroller.getFrameNo selectedIndex
				)
			)
			
			------------------------------------------------
			--@event: changed | Evento que se lanza al cambiar el valor del spinner.
			--@control: spinner | spnStartTime | Elemento que dispara el evento.
			------------------------------------------------
			on spnStartTime changed value do
			(
				if selectedIndex != undefined then
				(
					LCcontroller.setFrameNo selectedIndex value
					rollLinkConstraint.fillListView()
				)
			)
			
		)	-- rollout rollLinkConstraint	
	)-- ARS_linkConstraint

	------------------------------------------------
	--@attributes: CA_SRS_twistInfo | TWISTINFO es un atributo definido como global, de forma que cada vez que se actualice su definición, ésta también se actualizará en todas las piezas que lo tengan asignado. Esto es útil para los casos en los que haga falta añadir nuevos parámetros a twistInfo.
	------------------------------------------------	
	CA_SRS_twistInfo = attributes SRS_twistInfo
	(
		
		parameters main
		(
			twistNumber type:#integer default:4 					--@var: integer | twistNumber | indica el numero de huesos del twist. 
			autoStretch type:#boolean default:false 				--@var: boolean | autoStretch | indica si el sistema se estira automaticamente.
			upperRef type:#boolean default:false 					--@var: boolean | upperRef | indica si el sistema requiere objeto de referencia en su parte superior.
			lowerRef type:#boolean default:false 					--@var: boolean | lowerRef | indica si el sistema requiere objeto de referencia en su parte inferior.
		)
	)--twistInfo
	
	customAttributes = #( CA_camInfo, CA_animTracks, CA_virtualNodes, CA_skinRigInfo, CA_animRigInfo, CA_testAttrib, CA_ARS_fixEyes, CA_ARS_linkConstraint, CA_SRS_twistInfo) --@var: array | customAttributes | Almacena los CA.

	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: customAttributes | Contiene todas las funciones de custom attributes.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_customAttributes
	(	
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #controller,												--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Libreria de manejo de custom attributes",			--@var: string | description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		camInfoCA = CA_camInfo,							--@var: customAttribute | camInfoCA | Array que contiene los controladores de tipo lista.
		animTracksCA = CA_animTracks,					--@var: customAttribute | animTracksCA | Array que contiene los controladores de tipo lista.
		virtualNodesCA = CA_virtualNodes,				--@var: customAttribute | virtualNodesCA | Array que contiene los controladores de tipo lista.
		skinRigInfoCA = CA_skinRigInfo,					--@var: customAttribute | skinRigInfoCA | Array que contiene los controladores de tipo lista.
		animRigInfoCA = CA_animRigInfo,					--@var: customAttribute | animRigInfoCA | Array que contiene los controladores de tipo lista.
		morphInfoCA = CA_morphInfo,						--@var: customAttribute | morphInfoCA | Array que contiene los controladores de tipo lista.
		testAttribCA = CA_testAttrib,					--@var: customAttribute | testAttribCA | Array que contiene los controladores de tipo lista.
		fixEyesARSCA = CA_ARS_fixEyes,					--@var: customAttribute | fixEyesARSCA | Array que contiene los controladores de tipo lista.
		linkConstraintARSCA = CA_ARS_linkConstraint, 	--@var: customAttribute | linkConstraintARSCA | Array que contiene los controladores de tipo lista.
		twistInfoSRSCA = CA_SRS_twistInfo,				--@var: customAttribute | twistInfoSRSCA | Array que contiene los controladores de tipo lista.
		customAttributesCA = customAttributes,			--@var: customAttribute | customAttributesCA | Array que contiene los controladores de tipo lista.

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
		--@fn: boolean | hasAttribute | Averigua si un objeto tiene un atributo concreto. Devuelve TRUE si el objeto tiene el atributo, FALSE si no.
		--@gets: node | obj | Objeto en el cual queremos comprobar la existencia de un atributo.
		--@gets: name | attributeName | nombre del atributo que se busca.
		------------------------------------------------
		fn hasAttribute obj attributeName =
		(
			if obj != undefined then
				obj.custAttributes[attributeName] != undefined
			else
				false
		),
		
		------------------------------------------------
		--@fn: undefined | deleteAttribute | Elimina todos los atributos de un objeto. Si se le pasa el nombre del atributo, solo elimina ese atributo concreto.
		--@gets: node | obj | Objeto en el cual queremos eliminar los atributos.
		--@opt: name | attributeName | undefined | Nombre del atributo a eliminar. Si no se especifica, se eliminan todos.
		------------------------------------------------
		fn deleteAttribute obj attributeName:undefined =
		(
			-- Si le pasamos el nombre borramos el custom concreto, sino se borran todos.
			if attributeName != undefined then
				custAttributes.delete obj (custAttributes.getDef obj.custAttributes[attributeName]) baseObject:false
			else
			(
				-- Borramos todos los customAttributes hacia atrás para evitar que de error de recorrido.
				for i = obj.custAttributes.count to 1 by -1 do
					custAttributes.delete obj (custAttributes.getDef obj.custAttributes[i]) baseObject:false
			)

		),

		------------------------------------------------
		--@fn: float | getCurrentCAversion | Devuelve el número de versión actual de la definición del customAttribute
		--@gets: string | custAttributeDef | Definicion del customAttribute.
		------------------------------------------------
		fn getAttributeCAversion custAttributeDef =
		(
			_attributeVersion = undefined
			_pBlocks = (custattributes.getPBlockDefs custAttributeDef)[1]
			
			for _block in _pBlocks where (classOf _block == array) and (_block[1] == #CA_version) do 
			(
				_defaultValIndex = undefined
				for i = 1 to _block[2].count where _block[2][i] == #default do _defaultValIndex = i + 1
					
				if _defaultValIndex != undefined then
					_attributeVersion = _block[2][_defaultValIndex]
			)
				
			_attributeVersion
		),

		------------------------------------------------
		--@fn: undefined | redefineCustAttribute | Redefine el ATTRIB pasado por parametro con la nueva definicion NEWDEF
		--@gets: string | def | String con la definicion.
		--@gets: string | newDef | Sstring con la nueva definicion.
		------------------------------------------------										
		fn redefineCustAttribute def newDef =
		(
			custattributes.redefine def newDef
		),

		------------------------------------------------
		--@fn: undefined | redefineCustAttributes | redefine los custom attributes de los objetos de la escena y les pone a todos la nueva definicion		
		------------------------------------------------
		fn redefineCustAttributes =
		(
			local cont = 0 --contador de CAs redefinidos
			local CAsNames = #() --array para almacenar los nombres de los CAs globales definidos
			local CAsDefSource = #() --array para alacenar los source de los CAs globales definidos
			
			for i=1 to customAttributes.count	do --recorre los CAs globales obteniendo su nombre y su definicion
			(
				CAsNAmes[i] = tolower (substituteString customAttributes[i].name "\#" "")		--	quitamos la almohadilla inicial que devuelve el nombre del atributo
				CAsDefSource[i] = custattributes.getDefSource customAttributes[i]
			)

			--recorre los nodos de la escena
			setWaitCursor()
			for obj in objects do
			(
				local objCAs = for CA in obj.custattributes collect CA --obtiene los Custom Attriburtes del objeto
				
	 			for m in obj.modifiers do
	 				for CA in m.custattributes do
						append objCAs CA
				
				for CA in objCAs do --recorre los Custom atributes de cada nodo
				(
					index = findItem CAsNAmes (tolower CA.name) --mira a ver si ese CA pertenece a los CAs Globales
					if index != 0 then --si ese CA pertenece a los CAs globales
						if (custAttributes.getDefSource (custAttributes.getDef CA)) != CAsDefSource[index] then
						(
							--addNotification obj.name
							redefineCustAttribute (custAttributes.getDef CA) CAsDefSource[index]
							cont +=1
						)
				)
				
				-- El nodeInfo lo comprobamos y redefinimos a mano hasta que se conviertan todos los customAttributes a librería
				-- Borrar este trozo de código cuando se genere lib_custAttributes y se haga ahí la operación
				if (lb.nodeInfo.hasNodeInfo obj) then
				(
					_lastNodeInfoDefCAversion = (getAttributeCAversion lb.nodeInfo.CA_nodeInfoDef)
					_nodeInfoCAversion = getAttributeCAversion (custAttributes.getDef obj.custAttributes[#nodeInfo]) --ESTO ESTABA MAL, no lo cogia del objeto sino del la definicion -> lb.nodeInfo.CA_nodeInfoDef
					
					--si el CA es el viejo, del proyectod e Tadeo, hay que eliminarlo
					if (_nodeInfoCAversion < 2) then 
					(
						print ("Borrado nodeInfo en: " + obj.name)
						lb.nodeInfo.removeAttribute obj
					)
					else if _nodeInfoCAversion < _lastNodeInfoDefCAversion then
					(--si el el CA nuevo pero hay una version mas actual, hay que cambiarlo por esa, pero manteniendo el contenido.
						print ("Actualizado nodeInfo a la ultima version: " + obj.name)
						lb.nodeInfo.updateAttribute obj
					)
				)
			)--for obj
			gc light:true
			setArrowCursor()
			
			cont --devuelve el numero de CAs redefinidos
		),

		------------------------------------------------
		--@fn: undefined | makeUniqueCustAttributes | hace que las instancias de custom attributes dejen de serlo y sean unicas		
		------------------------------------------------		
		fn makeUniqueCustAttributes =
		(
			local sceneAssets = lb.asset.getSceneAssets() --obtiene los assets de la escena
			
			--recorre los nodos de la escena eliminando las instancias
			setWaitCursor()
			for obj in objects do
			(
				local objCAs = obj.custattributes --obtiene los Custom Attriburtes de el objeto
				local objModCAs = if obj.modifiers[1] != undefined then obj.modifiers[1].custAttributes else #()
							
				for CA in objCAs do --recorre los Custom atributes buscando cuales son instancias de otros
					custAttributes.makeUnique obj (custAttributes.getDef CA) baseObject:false
				
				for CA in objModCAs do --recorre los Custom atributes buscando cuales son instancias de otros
					custAttributes.makeUnique obj (custAttributes.getDef CA) baseObject:false
				
			)--for1
			gc light:true
			setArrowCursor()
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
	)--lb_customAttributes
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_customAttributes() --crea la libreria
)