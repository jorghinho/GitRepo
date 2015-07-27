------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta morpherManager.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta rollMaskConnectionDef.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMaskConnectionDef "Morpher manager: Monkey Face"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 400		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 600		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local iconpath = if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/"		-- ruta de los iconos de Max.
		
		local morphNames = #() --array para ak¡lmacenar los nombres de los canales de morph
		local maskShapes = #() --array para almacenar los shapes (conectados/desconectados) correspondientes al morpher
		local maskShapesName = #() --array para almacenar el nombre abreviado de los shapes
		local maskMultipliers = #() --array para almacenar el multiplicador de conexion de cada shape
		local maskOffsets = #() --array para almacenar el offset de conexion de cada shape
		local maskExpression = #() --array para almacenar la expression de conexion de cada shape
		local maskConditionExpr = #() --array para almacenar la parte condicional de la expression de conexion de cada shape
		local maskSignExpr1 = #() --array para almacenar la parte del signo de la expresion
		local maskSignExpr2 = #() --array para almacenar la parte del signo de la expresion para el partial
		local maskSignExpr3 = #() --array para almacenar la parte del signo de la expresion para el full
		local maskController = #() --array para almacenar el controlador al que esta conectado cada shape
		local maskConnection = #() --array para almacenar el flag que permite saber si un shape esta conectado
		
		--local maskShapeControls = #() --array para los shapes de la careta cuando conectan con los huesos de la cara
			
		local lvSelectedListItems = #()	-- Índices de los objetos seleccionados en el list view
		
		local cursor = dotNetClass "Windows.Forms.Cursor" -- almacena el cursor para poder moverlo libremente
		local dnKeys=dotnetclass "System.Windows.Forms.Keys"
		
		local leftDragging = false --flag para saber si estamos haciendo drag con el boton izquierdo del raton
		local dragged = false --flag para saber si se acaba de hacer drag con algun boton
		
		local dnBackColor = (dotNetClass "System.Drawing.Color").Silver  --color del fondo del listview 
		local dnNonNCcolor = (dotNetClass "System.Drawing.Color").Red  --color del fondo del listview 
		local dnForeColor = (dotNetClass "System.Drawing.Color").Black  --color de la letra del listview
		local dnConnectColor = (dotNetClass "System.Drawing.Color").fromargb 7 233 82  --color de los shapes conectados
		local dnUpdateColor = (dotNetClass "System.Drawing.Color").fromargb 255 234 0  --color de los shapes conectados pendientes de update
		local dnUnconnectColor = (dotNetClass "System.Drawing.Color").fromargb 242 62 7  --color de los shapes desconectados

		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------

		dotNetControl lvMaskList "System.Windows.Forms.ListView" pos:[140,60] width:235 height:530
		
		dotNetControl txtMaskToChannelMorph "System.Windows.Forms.TextBox" pos:[5,5] width:370 height:20 toolTip:"<Mask Shape> -> <Morph Channel>"		
		
		label lblExpressionTitle "Expr:" pos:[7,33] width:75 height:15
		dotNetControl rchTxtExpression "System.Windows.Forms.TextBox" pos:[35,30] width:340 height:20 toolTip:"Must be a valid expression"
		dotNetControl rchTxtInvisible "System.Windows.Forms.TextBox" pos:[5,30] width:370 height:20
		
		label lblAux2 "____________________" pos:[11,133] width:115 height:15 enabled:false
		
		groupBox grpExpression "" pos:[5,54] width:130 height:215
		label lblMultiplier "Multiplier:" pos:[10,68] width:45 height:15		
		spinner spnMultiplier "" pos:[60,68] width:65 height:16 range:[-10000,10000,40] type:#integer	
		label lblOffset "Offset:" pos:[20,87] width:35 height:15		
		spinner spnOffset "" pos:[60,87] width:65 height:16 range:[-10000,10000,0] type:#integer
		label lblSign1 "Sign1:" pos:[10,106] width:35 height:15		
		spinner spnSign1 "" pos:[10,125] width:30 height:16 range:[-1,1,1] type:#integer scale:2
		label lblSign2 "Sign2:" pos:[45,106] width:35 height:15		
		spinner spnsign2 "" pos:[45,125] width:30 height:16 range:[-1,1,1] type:#integer scale:2
		label lblSign3 "Sign3:" pos:[80,106] width:35 height:15		
		spinner spnsign3 "" pos:[80,125] width:30 height:16 range:[-1,1,1] type:#integer scale:2

		label lblAux1 "____________________" pos:[11,202] width:115 height:15 enabled:false
		
		radiobuttons rdoController "Controller:" pos:[10,150] width:75 height:45 labels:#("Position", "Rotation", "Scale") default:1 columns:1		
		radiobuttons rdoAxis "Axis:" pos:[85,150] width:75 height:45 labels:#("X", "Y", "Z") default:1 columns:1		

		pickbutton pckPartialShape "partial: - empty -" pos:[10,220] width:118 height:20 toolTip:"Pick new partial shape"
		pickbutton pckFullShape "full: - empty -" pos:[10,244] width:118 height:20 toolTip:"Pick new full shape"

		groupBox grpConnection "" pos:[5,270] width:130 height:90
		progressBar pbConnection "ProgressBar" pos:[10,280] width:118 height:15 visible:true
		button btnConnect "Connect" pos:[10,300] width:55 height:20 toolTip:"Connect/Update the conection betwen Shape and Morph"
		button btnDisConnect "Disconnect" pos:[70,300] width:60 height:20 toolTip:"Breaks the conection"
		radiobuttons rdoConnection "" pos:[15,325] width:104 height:32 labels:#("All Shapes", "Selected Shapes") default:1 columns:1		
		
		groupBox grpSaveLoad "Save/Load Connections" pos:[5,365] width:130 height:90
		checkbox chkDelConnections "Replace connections" pos:[10,410] width:120 height:15 checked:true toolTip:"Save/Load vertex colors"
		button btnLoad "Load" pos:[10,380] width:25 height:25 images:#(iconpath + "bip_general_i.bmp", undefined, 30, 5, 5, 6, 6,true)
		button btnSave "Save" pos:[40,380] width:25 height:25 images:#(iconpath + "bip_general_i.bmp", undefined, 30, 7, 7, 8, 8,true)
		progressBar pbSaveLoad "" pos:[10,435] width:120 height:15 visible:true

		colorPicker clrUnconnected "" pos:[5,465] width:20 height:15 enabled:false color:[242,62,7]
		label lblUnconnected "Unconnected" pos:[30,465] width:100 height:15
		colorPicker clrUpdate "" pos:[5,485] width:20 height:15 enabled:false color:[255,234,0]
		label lblUpdate "Update pending" pos:[30,485] width:100 height:15
		colorPicker clrConnected "" pos:[5,505] width:20 height:15 enabled:false color:[7,233,82]
		label lblConnected "Connected" pos:[30,505] width:100 height:15
		
		button btnClose "Close" pos:[5,565] width:130 height:25 toolTip:"Close the tool"
		
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
		--@fn: undefined | deactivateUIcontrols | desactiva los controles de UI innecesarios en el modo huesos
		------------------------------------------------
		fn deactivateUIcontrols =
		(
			txtMaskToChannelMorph.enabled = false
			
			rchTxtExpression.enabled = false
			
			spnMultiplier.enabled = false
			spnOffset.enabled = false
			spnSign1.enabled = false
			spnsign2.enabled = false
			spnsign3.enabled = false
			
			rdoController.enabled = false
			rdoAxis.enabled = false

			pckPartialShape.enabled = false
			pckFullShape.enabled = false

			grpSaveLoad.enabled = false
			chkDelConnections.enabled = false
			btnLoad.enabled = false
			btnSave.enabled = false
			pbSaveLoad.enabled = false

			clrUnconnected.enabled = false
			clrUpdate.enabled = false
			clrConnected.enabled = false
		)--fn deactivateUIcontrols
		
		------------------------------------------------
		--@fn: undefined | initTXTs | inicializa el label con la relacion Shape - Morph Channel
		------------------------------------------------		
		fn initTXTs = 
		(
			txtMaskToChannelMorph.text = "<Mask Shape> -> <Morph Channel>"
			txtMaskToChannelMorph.ReadOnly = true
			txtMaskToChannelMorph.TextAlign = (dotNetClass "System.Windows.Forms.HorizontalAlignment").Center 
			txtMaskToChannelMorph.backColor = dnBackColor
			
			rchTxtExpression.text = "<Connection Expression>"
			rchTxtExpression.ReadOnly = true
			rchTxtExpression.TextAlign = (dotNetClass "System.Windows.Forms.HorizontalAlignment").Center 
			rchTxtExpression.backColor = dnBackColor
			
			rchTxtInvisible.Visible = false
		)--fn initMaskToChannelMorph

		------------------------------------------------
		--@fn: undefined | initListView | Inicia el listView pasado por parámetro
		------------------------------------------------
		fn initListView lv =
		(
			lv.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = dnBackColor
			lv.foreColor = dnForeColor
			lv.scrollable = true
			lv.labelEdit = true
			--lv.hideSelection = false
			lv.labelEdit = false

			lv.columns.add "n" (lv.width/9)
			lv.columns.add "Specific Shape" (lv.width/2.6)
			lv.columns.add "Global Shape" (lv.width/2.9)			
			lv.columns.add ">" (lv.width/13)				
		)--fn initListView

		------------------------------------------------
		--@fn: undefined | findMatchingShapes | busca el shape correspondiente a cada morph pasado por parametro
		------------------------------------------------		
		fn findMatchingShapes mName shapesArray =
		(
			posibleShapes = #() --array para guardar los posibles shapes correspondientes
			matchingShapes = #() --variable para guardar los shapes que se correspondan
			
			--exception para los morphs en los que se ha metido el signo de no negativo ()
			mName = (substituteString ((substituteString mName ")" "")) "(" "")
			
			--averigua el archivo abierto a que proyecto pertenece, ya que la forma de encontrar el shape adecuando para cada gesto es diferente
			_currFileProject = lb.project.getCurrentFileProject()
			_currProjectId = if _currFileProject != undefined then _currFileProject.getId() else "tdj"
			if _currProjectId == "myf" then _currProjectId = "tdj"
			
			case _currProjectId of
			(
				"ctf": --proyecto de capture the flag
				(
					--recorre el array de shapes y decide que shapes controlan cada gesto
					for i=1 to shapesArray.count do
					(
						flag = false
						shName = filterString shapesArray[i].name "_"
						shName = (shName[4] + "_" + shName[5])
						
						--si un shape comparte su nombre con parte o todo el nombre de un gesto, asume que ese shape lo controla
						if (findstring mName shName) != undefined then
						(
							flag = true
								
							--excepcion para que bend no tenga a jaw-all como shape que lo controle
							if findstring mName "bend" != undefined then
								if findstring shName "jaw-all" != undefined then
									flag = false

							--excepcion para que jaw-all-break solo tenga un shape que lo controle	
							if findstring mName "jaw-all-break" != undefined then
								if findstring shName "jaw-all-break" == undefined then
									flag = false
								
							--excepcion para que lip-upperAll no sea controllado por el shape lip-upper sino por lip-upperAll
							if findstring mName "lip-upperAll" != undefined and shName == "m_lip-upper" then
								flag = false
							
							--excepcion para que lip-upperAll no sea controllado por el shape lip-upper sino por lip-upperAll
							if findstring mName "lip-lowerAll" != undefined and shName == "m_lip-lower" then
								flag = false
							
							--excepcion para que chb-all-inflate no sea controllado por el shape chb-all sino por chb-all-inflate
							if findstring mName "chb-all-inflate" != undefined and findstring shName "chb-all-inflate" == undefined then
								flag = false
						)
						else
						(
							flag = false
							
							--excepcion para que bend tenga stretch como shape que lo controle	
							if (findstring mName "ffdjaw-all-bend" != undefined) then
								if findstring shName "ffdjaw-all-stretch" != undefined then
									flag = true
									
							if (findstring mName "_eye-all" != undefined) then
								if (findString shName "m_eye" != undefined) then
									flag = true
								
							--excepcion para cuando se necesiten mover partes del pelo de los personajes junto con su inflate	
							if (findstring mName "r_hair-all-inflate" != undefined) then
								if findstring shName "r_chb-all-inflate" != undefined then
									flag = true
								
							--excepcion para cuando se necesiten mover partes del pelo de los personajes junto con su inflate
							if (findstring mName "l_hair-all-inflate" != undefined) then
								if findstring shName "l_chb-all-inflate" != undefined then
									flag = true
						)
						
						--si es un shape que tiene que controlar ese gesto, lo añade a la lista de posibles
						if flag then
							append posibleShapes shapesArray[i]
					)--for que recorre el array de shapes
					
					if posibleShapes != undefined and posibleShapes.count != 0 then --si ha encontrado algun shape posible
					(
						if posibleShapes.count > 1 then
						(
							if posibleShapes[2].name.count > posibleShapes[1].name.count then
								posibleShapes = #(posibleShapes[2],posibleShapes[1])
							
							if findstring posibleShapes[1].name "all" != undefined then
								posibleShapes = #(posibleShapes[2],posibleShapes[1])
							
							posibleShapes[2] = 0 as float
						)
						else if posibleShapes.count == 1 then
						(
							posibleShapes[2] = 0 as float
						)
						
						--rellena el array de shapes a devolver
						matchingShapes = posibleShapes
					)--if not undefined
				) --proyecto de capture the flag
				
				"tdj": --proyecto de tadeo jones
				(
					--recorre el array de shapes y decide que shapes controlan cada gesto
					for i=1 to shapesArray.count do
					(
						flag = false
						shName = filterString shapesArray[i].name "_"
						shName = (shName[4] + "_" + shName[5])
						
						--si un shape comparte su nombre con parte o todo el nombre de un gesto, asume que ese shape lo controla
						if (findstring mName shName) != undefined then
						(
							flag = true
							
							--excepcion para que stretch solo tenga un shape que lo controle
							--if findstring mName "stretch" != undefined then
							--	if (findstring shName "stretch" == undefined) and (findstring shName "tongue" == undefined) then
							--		flag = false
								
							--excepcion para que bend no tenga a jaw-all como shape que lo controle
							if findstring mName "bend" != undefined then
								if findstring shName "jaw-all" != undefined then
									flag = false
								
							--excepcion para que snout solo tenga un shape que lo controle	
							if findstring mName "snout" != undefined then
								if findstring shName "snout" == undefined then
									flag = false
								
							--excepcion para que jaw-hz-fr solo tenga un shape que lo controle	
							if findstring mName "hz-fr" != undefined then
								if findstring shName "hz-fr" == undefined then
									flag = false
								
							--excepcion para que ebw-int-hz solo tenga un shape que lo controle	
			-- 					if findstring mName "ebw-int-hz" != undefined then
			-- 						if findstring shName "ebw-int" == undefined then
			-- 							flag = false
								
							--excepcion para que jaw-all-break solo tenga un shape que lo controle	
							if findstring mName "jaw-all-break" != undefined then
								if findstring shName "jaw-all-break" == undefined then
									flag = false
							
			-- 					if findstring mName "ffdskl-all-stretch-fr" != undefined then
			-- 						if  shName == "m_ffdskl-all" then
			-- 							flag = false	
								
							--excepcion para que lip-upper-rot-out solo tenga un shape que lo controle	
							if findstring mName "lip-upper-rot-out" != undefined then
								if findstring shName "lip-upper-snout" == undefined then
									flag = false
								
							--excepcion para que lip-lower-rot-out solo tenga un shape que lo controle	
							if findstring mName "lip-lower-rot-out" != undefined then
								if findstring shName "lip-lower-snout" == undefined then
									flag = false
							
							--------------------------------------------------------------------------------------	
							--excepcion para que en los objetos que sean de párpado, como forma independiente, no conecte los gestos individuales con el shape principal
							--ya que esto se hace por rig directo
							if findString parent.rollMain.morphObj.name "_eyelidUpper_" != undefined then
								if findString mName "eld-upper" != undefined then
									if matchPattern shName pattern:"?_eld-upper" then
										flag = false
									
							if findString parent.rollMain.morphObj.name "_eyelidLower_" != undefined then
								if findString mName "eld-lower" != undefined then
									if matchPattern shName pattern:"?_eld-lower" then
										flag = false
							--------------------------------------------------------------------------------------
						)
						else
						(
							flag = false
							
							--excepcion para que x_lip-upper-hz y compañia tengan x_lip-all como shape que lo controle	
							if (findstring mName "m_lip-upper-hz" != undefined) or (findstring mName "m_lip-lower-hz" != undefined) or (findstring mName "lip-ext-hz" != undefined)then
								if shName == "m_lip-all" then
									flag = true
								
							--excepcion para que lip-upper-vt-up y compañia tengan lip-upperAll como shape que lo controle	
							if (findstring mName "lip-upper-vt-up" != undefined) or (matchPattern mName pattern:"?_lip-upperMid?-vt-up") then
								if findstring shName "lip-upperAll" != undefined then
									flag = true
								
							--excepcion para que lip-lower-vt-dw y compañia tengam lip-lowerAll como shape que lo controle	
							if (findstring mName "lip-lower-vt-dw" != undefined) or (matchPattern mName pattern:"?_lip-lowerMid?-vt-dw") then
								if findstring shName "lip-lowerAll" != undefined then
									flag = true
								
							--excepcion para que bend tenga stretch como shape que lo controle	
							if (findstring mName "ffdjaw-all-bend" != undefined) then
								if findstring shName "ffdjaw-all-stretch" != undefined then
									flag = true
									
							if (findstring mName "_eye-all" != undefined) then
								if (findString shName "m_eye" != undefined) then
									flag = true
								
							--excepcion para que el lip-upperInt y Ext tenga tenga como shape que lo controle lip-upperAll
							if (findstring mName "r_lip-upperInt" != undefined) or (findstring mName "r_lip-upperExt" != undefined) or (findstring mName "l_lip-upperInt" != undefined) or (findstring mName "l_lip-upperExt" != undefined) then
								if findstring shName "lip-upperAll" != undefined then
									flag = true	
								
							--excepcion para que el lip-upperInt y Ext tenga tenga como shape que lo controle lip-upperAll
							if (findstring mName "r_lip-lowerInt" != undefined) or (findstring mName "r_lip-lowerExt" != undefined) or (findstring mName "l_lip-lowerInt" != undefined) or (findstring mName "l_lip-lowerExt" != undefined) then
								if findstring shName "lip-lowerAll" != undefined then
									flag = true
								
							--excepcion para que el lip-upper-snout y lip-lower-snout tenga como shape que lo controle lip-all-snout
							if (findstring mName "lip-lower-snout" != undefined) or (findstring mName "lip-upper-snout" != undefined) then
								if findstring shName "lip-all-snout" != undefined then
									flag = true
								
							--excepcion para que el lip-upper-snou y lip-lower-snot tenga como shape que lo controle lip-all-snout
							if (findstring mName "ffdeye-all" != undefined) then
								if findstring shName "m_ffdeye-all" != undefined then
									flag = true
								
							--excepcion para que el lip-upper-snou y lip-lower-snot tenga como shape que lo controle lip-all-snout
							if (findstring mName "ffdebw-all" != undefined) then
								if findstring shName "m_ffdskl" != undefined then
									flag = true
								
							--excepcion para cuando se necesiten mover partes del pelo de los personajes junto con su inflate	
							if (findstring mName "r_hair-all-inflate" != undefined) then
								if findstring shName "r_chb-all-inflate" != undefined then
									flag = true
								
							--excepcion para cuando se necesiten mover partes del pelo de los personajes junto con su inflate
							if (findstring mName "l_hair-all-inflate" != undefined) then
								if findstring shName "l_chb-all-inflate" != undefined then
									flag = true
							
							--excepcion para controles de ajuste de pelo
							if (findstring mName "_hair-int" != undefined) or (findstring mName "_hair-mid1" != undefined) or (findstring mName "_hair-mid2" != undefined) or (findstring mName "_hair-ext" != undefined) then
								if findstring shName "m_hair-all" != undefined then
									flag = true
								
							--excepcion para que lip-upper-rot-out lo controle el shape de snout
							if findstring mName "lip-upper-rot-out" != undefined then
								if findstring shName "lip-upper-snout" != undefined then
									flag = true
								
							--excepcion para que lip-lower-rot-out lo controle el shape de snout
							if findstring mName "lip-lower-rot-out" != undefined then
								if findstring shName "lip-lower-snout" != undefined then
									flag = true
								
							--excepcion para que los gestos de nariz se controlen tambien desde un control central
							if findstring mName "nose-ext" != undefined then
								if findstring shName "m_nose-all" != undefined then
									flag = true
						)
						
						--si es un shape que tiene que controlar ese gesto, lo añade a la lista de posibles
						if flag then
							append posibleShapes shapesArray[i]
					)--for que recorre el array de shapes
						
					if posibleShapes != undefined and posibleShapes.count != 0 then --si ha encontrado algun shape posible
					(
						if posibleShapes.count == 1 then --si solo hay un shape posible
						(
							--rellena el array de shapes a devolver
							matchingShapes[1] = posibleShapes[1]
							matchingShapes[2] = 0 as float
						)
						else --si hay varios posibles
						(
							--coloca el especifico en primera posicion y el general en segunda posicion
							if posibleShapes[2].name.count > posibleShapes[1].name.count then
								posibleShapes = #(posibleShapes[2],posibleShapes[1])
							else
								if findstring posibleShapes[1].name "all" != undefined then
									posibleShapes = #(posibleShapes[2],posibleShapes[1])
							
							--rellena el array de shapes a devolver
							matchingShapes = posibleShapes
						)

					)--if not undefined
				) --proyecto de tadeo jones
			)--case
			
			--devuleve los shapes que lo controlan
			matchingShapes		
		) --fn findMatchingShape

		------------------------------------------------
		--@fn: undefined | findNegative | busca un gesto negativo y si lo encuentra devuelve true
		------------------------------------------------		
		fn findNegative mName constrDir morphModifier =
		(
			found = false
			
			_hasNoNegativeSymbol = ((findString constrDir "(" != undefined) or (findString constrDir ")" != undefined))
			if _hasNoNegativeSymbol then constrDir = substituteString (substituteString constrDir ")" "") "(" ""
			
			oppositeDir = ""
			case constrDir of --nombre del negativo para cada tipo de direccion de contruccion
			(
				"up": oppositeDir = "dw"
				"dw": oppositeDir = "up"
				"r": oppositeDir = "l"
				"l": oppositeDir = "r"
				"fr": oppositeDir = "bk"
				"bk": oppositeDir = "fr"
				"in": oppositeDir = "out"
				"out": oppositeDir = "in"
			)
			
			--contruye el nombre que tendria su negativo
			
			nameParts = filterString mName "_-"
			nameToFind = ""
			
			if oppositeDir != "" then
			(
				if _hasNoNegativeSymbol then oppositeDir = "(" + oppositeDir + ")"
				nameToFind = nameParts[1] + "_" + nameParts[2] + "-" + nameParts[3] + "-" + nameParts[4] + "-" + oppositeDir
				if nameParts.count == 6 then
					nameToFind = nameToFind + "-" + nameParts[5]
			)
			
			--nameToFind = (substituteString mName ("-" + constrDir) ("-" + oppositeDir))
			
			-- 			if mName == "x_lip-all-vt-up" then
			-- 			(
			-- 				print constrDir
			-- 				print oppositeDir
			-- 				print nameToFind
			-- 			)
				
			--recorre los canales de morph buscando el posible negativo
			case classof morphModifier of
			(
				morpher:
				(
					for i=1 to 100 do
					(
						if findString (WM3_MC_GetName morphModifier i) nameToFind != undefined then
						(
							found = true
							i=100
						)
					)
				)
				
				Morph_O_Matic:
				(
					for i=1 to (MOM_GetNumChannels morphModifier) do
					(
						if findString (morphModifier[i].name) nameToFind != undefined then
						(
							found = true
							i=100000
						)
					)
				)
			)--case			
			
			found --devuelve true si ha encontrado el negativo
		)

		------------------------------------------------
		--@fn: undefined | fillMaskExpressionArrays | rellena los arrays de expression con el contenido correspondiente
		------------------------------------------------						
		fn fillMaskExpressionArrays index morphModifier shapesArray connected =
		(
						
			maskExpression[index] = #()
			
			--averigua el archivo abierto a que proyecto pertenece, ya que la forma de encontrar el shape adecuando para cada gesto es diferente
			_currFileProject = lb.project.getCurrentFileProject()
			_currProjectId = if _currFileProject != undefined then _currFileProject.getId() else "tdj"
			if _currProjectId == "myf" then _currProjectId = "tdj"
			
			case _currProjectId of
			(
				"ctf": --proyecto de capture the flag
				(
					--expresion estandar
					--if( condicion , (sign1*((sign2*partial + full)*multiplier) + offset) , 0 )
					
					maskExpression[index][1] = "if( " --inicio de la expression
					--en medio va la condicion de la expresion
					maskExpression[index][2] = " , (sign1*((sign2*partial + sign3*full)*multiplier) + offset) , 0 )" --parte 2 de la expresion"
					
					maskSignExpr1[index] = 1
					maskSignExpr2[index] = 1
					maskSignExpr3[index] = 1
					maskMultipliers[index] = 40
					maskOffsets[index] = 0
					
					if shapesArray == undefined then
						shapesArray = #()
					
					if shapesArray.count != 0 then
					(		
						--si no esta conectado ya
						if not connected then
						(
							--inicializa el multiplicador, el offset y los signos de conexion
							maskMultipliers[index] = 40
							maskOffsets[index] = 0
							maskSignExpr1[index] = 1
							maskSignExpr2[index] = 1
							maskSignExpr3[index] = 1
							maskConditionExpr[index] = "always"
							
							--obtiene el nombre del canal de morph y sus partes para poder calcular los controladores y la condicion de la expresion
							case classof morphModifier of
							(
								morpher: mName = WM3_MC_GetName morphModifier index
								Morph_O_Matic: mName = morphModifier[index].name
							)							
							
							--averigua si el morph tiene el simbolo de no negativo
							_hasNoNegativeSymbol = ((findString mName "(" != undefined) or (findString mName ")" != undefined))
							mName = (substituteString (substituteString mName ")" "") "(" "")
							
							mNameParts = filterString mName "_"
							mNameParts = #(mNameParts[1]) + (filterString mNameParts[2] "-")
							
							subanim2 = 1
							--calcula si tiene que controlar posicion, rotacion o escala
							case mNameParts[4] of
							(
								"twist": subanim2 = 2
								"stretch": (if mNameParts[2] == "tongue" then subanim2 = 3)
								
								"rot":
								(
									subanim2 = 2
									maskMultipliers[index] = 160
								)
								
								"scale": 
								(
									subanim2 = 3
									maskMultipliers[index] = 80
									maskOffsets[index] = -160
								)
								
								"inflate": 
								(
									subanim2 = 3
									maskMultipliers[index] = 100
									maskOffsets[index] = 0
								)
								
								default: subanim2 = 1
							)
							
							subanimXYZ = 1
							--calcula si tiene que controlar X Y o Z
							case mNameParts[4] of
							(
								"vt": subanimXYZ = 3
								"open": subanimXYZ = 3
								"stretch": subanimXYZ = 3
								"twist": subanimXYZ = 2
								"rot": subanimXYZ = 1
								"break":
								(
									case mNameParts[5] of
									(
										"dw": subanimXYZ = 3
									)
								)
								"bend":
								(
									if mNameParts[5] == "up" or mNameParts[5] == "dw" then
									(
										subanimXYZ = 3
									)

									if mNameParts[5] == "fr" or mNameParts[5] == "bk" then
									(
										subanimXYZ = 2
									)
								)
								"hz": 
								(
									if mNameParts[1] == "r" and mNameParts[2] == "ebw" then
									(
										maskSignExpr3[index] = -1
									)
									
									--si es horizontal hacia delante debe conectarse con el eje Y
									if mNameParts[5] == "fr" or mNameParts[5] == "bk" then
									(
										subanimXYZ = 2										
									)
								)
								"inflate": subanimXYZ = 3
								
								default: subanimXYZ = 1
							)
							
							if mNameParts[3] == "smooth" and mNameParts[2] == "eld" then
								maskMultipliers[index] = 80
							
							if mNameParts[2] == "frown" then
								maskMultipliers[index] = 80
							
							--almacena los calculos
							maskController[index] = #(subanim2, subanimXYZ)
							
							--busca si el gesto tiene negativo para poner una condicion o dejarla en blanco
							neg = findNegative mName mNameParts[5] morphModifier
							
							if neg then --si el gesto tiene negativo
							(
								caseFlag = 1 --flag para saber como dividir el movimiento del shape entre un gesto y su negativo
								
								--calcula el caso para la condicion de la expresion
								case mNameParts[5] of
								(
									"up": caseFlag = 1
									"dw":	caseFlag = 2

									"r": 
									(
										caseFlag = 2
										if mNameParts[1] == "r" then
										(
											caseFlag = 1
											maskSignExpr3[index] = -1
										)
									)
									
									"l": 
									(
										caseFlag = 1
										if mNameParts[1] == "r" then
										(
											caseFlag = 2
											maskSignExpr3[index] = -1
										)
									)
									
									"fr": caseFlag = 2
									"bk": caseFlag = 1
									
									"in": caseFlag = 2
									"out": caseFlag = 1
									
									default:caseFlag = 1
								)
								
								--calcula la expresion de conexion en funcion del caso
								case caseFlag of
								(
									1:
									(
										if mNameParts[4] == "scale" then
										(
											maskConditionExpr[index] = "(sign2*partial * sign3*full)>1"
											maskExpression[index][2] = " , (sign1*((sign2*partial * sign3*full)*multiplier) - multiplier) , 0)" --parte 2 de la expresion"
										)
										else
											maskConditionExpr[index] = "(sign2*partial + sign3*full)>0"
									)
									
									2:
									(
										if mNameParts[4] == "scale" then
										(
											maskConditionExpr[index] = "(sign2*partial * sign3*full)<1"
											maskExpression[index][2] = " , (sign1*((sign2*(1-partial) + sign3*(1-full))*multiplier*2)) , 0)" --parte 2 de la expresion"
										)
										else
										(
											maskConditionExpr[index] = "(sign2*partial + sign3*full)<0"
											maskSignExpr1[index] = -1
										)
									)
								)
								
							)
							else --si el gesto no tiene negativo
							(
								caseFlag = 2
								_nonNegativeFlag = 1
								
								--calcula el caso para el signo de la expresion
								case mNameParts[5] of
								(
									"dw":
									(
										if _hasNoNegativeSymbol then _nonNegativeFlag = 2
										case mNameParts[3] of
										(
											"all":
											(
												if mNameParts[2] == "ffdjaw" then caseFlag = 1
												else if mNameParts[2] == "ffdskl" then caseFlag = 1
												else if mNameParts[2] == "jaw" and mNameParts[3] != "break" then caseFlag = 1
												else if _hasNoNegativeSymbol and mNameParts[2] == "ebw" then caseFlag = 1
											)
											
											"upper":		caseFlag = 1
											
											"upperAll":
											(
												caseFlag = 1
												
												if mNameParts[2] == "eld" and mNameParts[4] == "vt" then
													maskMultipliers[index] = 30
											)
											
											"upperExt":	caseFlag = 1
											"upperInt":	caseFlag = 1
											"upperMid":	caseFlag = 1
											"upperMid1":	if mNameParts[2] == "eld" then caseFlag = 1
											"upperMid2":	if mNameParts[2] == "eld" then caseFlag = 1
											"upperMid3":	if mNameParts[2] == "eld" then caseFlag = 1
											"smooth": if mNameParts[2] == "eld" then caseFlag = 1
										)
									)
									
									"up":
									(
										case mNameParts[3] of
										(
											"lower":		caseFlag = 1
											
											"lowerAll":
											(
												caseFlag = 1
												
												if mNameParts[2] == "eld" and mNameParts[4] == "vt" then
													maskMultipliers[index] = 60
											)
											
											"lowerExt":	caseFlag = 1
											"lowerInt":	caseFlag = 1
											"lowerMid":	caseFlag = 1
											"lowerMid1": if mNameParts[2] == "eld" then caseFlag = 1
											"lowerMid2": if mNameParts[2] == "eld" then caseFlag = 1
											"lowerMid3": if mNameParts[2] == "eld" then caseFlag = 1
											--"all":			if mNameParts[2] == "ffdskl" then caseFlag = 1
										)
									)
									
									"l":
									(
										if mNameParts[1] == "r" then
										(
											if _hasNoNegativeSymbol then _nonNegativeFlag = 2
											
											caseFlag = 1
											
											if mNameParts[1] == "r" and mNameParts[2] == "eye" and mNameParts[3] == "fix" then
												caseFlag = 2
										)
									)
									
									"r":
									(
										if mNameParts[1] == "l" then
										(
											if _hasNoNegativeSymbol then _nonNegativeFlag = 2
											
											caseFlag = 1
											
											if mNameParts[1] == "l" and mNameParts[2] == "eye" and mNameParts[3] == "fix" then
												caseFlag = 2
										)
										
										if mNameParts[1] == "r" and mNameParts[2] == "lip" and (findString mNameParts[3] "Mid" != undefined) then
											caseFlag = 1
										
										if mNameParts[1] == "r" and mNameParts[2] == "eld" and mNameParts[4] == "hz" then
											caseFlag = 1
										
										if mNameParts[1] == "m" then
											caseFlag = 1
									)
									
									"bk":
									(
										if _hasNoNegativeSymbol then _nonNegativeFlag = 2
										
										if mNameParts[2] == "ffdskl" then
											caseFlag = 2
										else
											caseFlag = 1
									)
									
									"fr":
									(
										if mNameParts[4] == "stretch" then caseFlag = 1
										if mNameParts[4] == "hz" then caseFlag = 1
									)
															
									"in": if mNameParts[4] == "rot" then caseFlag = 1
									"out": if mNameParts[4] == "rot" then caseFlag = 1
										
									default:caseFlag = 2
								)
								
								if mNameParts[2] == "ebw" and mNameParts[6] != undefined then
									caseFlag = 1
								
								if (mNameParts[4] == "inflate") then caseFlag = 1
								
								--caso especial si se ha indicado mediante un simbolo especial que el gesto no tiene negativo
								if _hasNoNegativeSymbol then
								(
									case _nonNegativeFlag of
									(
										1:
										(
											maskConditionExpr[index] = "(sign2*partial + sign3*full)>0"
										)
										
										2:
										(
											maskConditionExpr[index] = "(sign2*partial + sign3*full)<0"
										)
									)--case
								)--if
								
								--calcula el signo de la expresion segun el caso
								case caseFlag of
								(
									1:
									(
										maskSignExpr1[index] = -1
										
										if (mNameParts[4] == "inflate") then
										(
											--maskExpression[index][2] = " , (sign1*((sign2*partial * sign3*full)*multiplier) -multiplier) , 0)" --parte 2 de la expresion"
											maskExpression[index][2] = " , (sign1*sign2*(1-partial)*multiplier) , 0)" --parte 2 de la expresion"
										)
									)
									
									2:
									(
										maskSignExpr1[index] = 1
										
										if (mNameParts[4] == "scale") then
										(											
											--maskExpression[index][2] = " , (sign1*((sign2*partial * sign3*full)*multiplier) -multiplier) , 0)" --parte 2 de la expresion"
											maskExpression[index][2] = " , (sign1*sign2*(1-partial)*multiplier) , 0)" --parte 2 de la expresion"
										)	
									)
								)
								
								progOffset = false
								
								if mNameParts.count == 6 then
								(
									if (findString mName "eld-upper" != undefined) /*or (findString mName "ebw-" != undefined)*/ then
										progOffset = true
								)
								
								if progOffset then
								(
									parts = filterString mName "-"
									if parts.count == 5 then
									(
										_projectUnit = "z"
										_pathParts = filterstring maxfilepath "\\:"
										if _pathParts.count != 0 then _projectUnit = tolower _pathParts[1]
										
										parts = filterString parts[5] "po"
										
										if _projectUnit != "x" then
											if parts[2] != undefined then
												maskOffsets[index] = parts[2] as float
									)
								)
							)
						)
					)
					else --si el canal esta vacio o ya conectado
					(
						if connected then --si esta conectado
						(
							--extrae los valores necesarios del float expression	
							case classof morphModifier of
							(
								morpher: floatExpr = morphModifier[index].controller
								Morph_O_Matic: floatExpr = morphModifier[index][2].controller
							)							
							
							--extrae los valores de conexion del float expression
							
							maskMultipliers[index] = floatExpr.GetScalarConstant "multiplier" as integer
							maskOffsets[index] = floatExpr.GetScalarConstant "offset" as integer
							maskSignExpr1[index] = floatExpr.GetScalarConstant "sign1" as integer
							maskSignExpr2[index] = floatExpr.GetScalarConstant "sign2" as integer
							maskSignExpr3[index] = floatExpr.GetScalarConstant "sign3" as integer
							
							--extrae los shapes de control
							maskShapes[index] = #()
							maskShapes[index][1] = (refs.dependentnodes (floatExpr.GetScalarTarget "partial" asController:false))[2]
							
							-------------------------------------------
							--esto es para que no se confunda y coja la dependencia que corresponda, a veces se equivoca porque hay mas nodos dependientes en el rig interno.
							_dependencies = (refs.dependentnodes (floatExpr.GetScalarTarget "partial" asController:false))
							_dependenciesNames = for _dep in _dependencies collect _dep.name
							_morphName = (parent.rollMain.lvMorphList.items.item[index-1].subItems.item[1].text)
							
							_stop = false
							for i=1 to _dependenciesNames.count where not _stop do
							(
								_sepShapeName = (filterString _dependenciesNames[i] "_")[4] + "_" + (filterString _dependenciesNames[i] "_")[5]
								if findString _morphName _sepShapeName != undefined then maskShapes[index][1] = _dependencies[i]
							)--for
							-------------------------------------------
							
							if findString maskShapes[index][1].name "_facial_" == undefined then
								maskShapes[index][1] = (refs.dependentnodes (floatExpr.GetScalarTarget "partial" asController:false))[1]
								
								
							if (floatExpr.GetScalarType "full") == #scalarTarget then
							(
								maskShapes[index][2] = (refs.dependentnodes (floatExpr.GetScalarTarget "full" asController:false))[2]
									
								if findString maskShapes[index][2].name "_facial_" == undefined then
									maskShapes[index][2] = (refs.dependentnodes (floatExpr.GetScalarTarget "full" asController:false))[1]
							)
							else
								maskShapes[index][2] = 0
								
							controller = (floatExpr.GetScalarTarget "partial" asController:false) as string
							controller = substituteString controller "SubAnim:" ""
							controller = filterString controller "_"
							
							--calcula si tiene que controlar X Y o Z
							subanimXYZ = undefined
							case controller[1] of
							(
								"X": subanimXYZ = 1
								"Y": subanimXYZ = 2
								"Z": subanimXYZ = 3
							)
							
							--calcula si tiene que usar posicion, rotacion o escala
							subanim2 = undefined
							case controller[2] of
							(
								"Position": subanim2 = 1
								"Rotation": subanim2 = 2
								"Scale": subanim2 = 3
							)
							
							--almacena los calculos
							maskController[index] = #(subanim2,subanimXYZ)

							expression = floatExpr.GetExpression()
							
							--busca la expresion de conexion
							if (findString expression "always") != undefined then
								maskConditionExpr[index] = "always"
							else
								if (findString expression "<") != undefined then
									maskConditionExpr[index] = "(sign2*partial + sign3*full)<0"
								else
									maskConditionExpr[index] = "(sign2*partial + sign3*full)>0"
							
							--calcula el nombre abreviado de los shapes de conexion
							maskShapesName[index] = #()
							
							parts = filterString maskShapes[index][1].name "_"
							maskShapesName[index][1] = parts[4] + "_" + parts[5]
							
							if maskShapes[index][2] != 0 then
							(
								parts = filterString maskShapes[index][2].name "_"
								maskShapesName[index][2] = parts[4] + "_" + parts[5]
							)
								
						)
						else --si el canal esta vacio
						(
							maskMultipliers[index] = 40
							maskOffsets[index] = 0
							
							maskController[index] = #(1, 1)
							maskConditionExpr[index] = "always"
							maskSignExpr1[index] = 1
							maskSignExpr2[index] = 1
						)
					)
				) --proyecto de capture the flag
				
				"tdj": --proyecto de tadeo jones
				(
					--expresion estandar
					--if( condicion , (sign1*((sign2*partial + full)*multiplier) + offset) , 0 )
					
					maskExpression[index][1] = "if( " --inicio de la expression
					--en medio va la condicion de la expresion
					maskExpression[index][2] = " , (sign1*((sign2*partial + sign3*full)*multiplier) + offset) , 0 )" --parte 2 de la expresion"
					
					maskSignExpr1[index] = 1
					maskSignExpr2[index] = 1
					maskSignExpr3[index] = 1
					maskMultipliers[index] = 40
					maskOffsets[index] = 0
					
					if shapesArray == undefined then
						shapesArray = #()
					
					if shapesArray.count != 0 then
					(		
						--si no esta conectado ya
						if not connected then
						(
							--inicializa el multiplicador, el offset y los signos de conexion
							maskMultipliers[index] = 40
							maskOffsets[index] = 0
							maskSignExpr1[index] = 1
							maskSignExpr2[index] = 1
							maskSignExpr3[index] = 1
							maskConditionExpr[index] = "always"
							
							--obtiene el nombre del canal de morph y sus partes para poder calcular los controladores y la condicion de la expresion
							case classof morphModifier of
							(
								morpher: mName = WM3_MC_GetName morphModifier index
								Morph_O_Matic: mName = morphModifier[index].name
							)	
							
							mNameParts = filterString mName "_"
							mNameParts = #(mNameParts[1]) + (filterString mNameParts[2] "-")
							
							subanim2 = 1
							--calcula si tiene que controlar posicion, rotacion o escala
							case mNameParts[4] of
							(
								"twist": subanim2 = 2
								"stretch": (if mNameParts[2] == "tongue" then subanim2 = 3)
								
								"rot":
								(
									subanim2 = 2
									maskMultipliers[index] = 160
								)
								
								"scale": 
								(
									subanim2 = 3
									maskMultipliers[index] = 80
									maskOffsets[index] = -160
								)
								default: subanim2 = 1
							)
							
							subanimXYZ = 1
							--calcula si tiene que controlar X Y o Z
							case mNameParts[4] of
							(
								"vt": subanimXYZ = 3
								"open": subanimXYZ = 3
								"stretch": subanimXYZ = 3
								"twist": subanimXYZ = 2
								"rot": subanimXYZ = 2
								"break":
								(
									case mNameParts[5] of
									(
										"dw": subanimXYZ = 3
									)
								)
								"bend": if mNameParts[5] == "up" or mNameParts[5] == "dw" then subanimXYZ = 3
								"hz": 
								(
									if mNameParts[1] == "r" and mNameParts[2] == "ebw" then
									(
										maskSignExpr3[index] = -1
										
			-- 								if findString mNameParts[3] "mid" != undefined then
			-- 									maskSignExpr2[index] = -1
										)
																	
			-- 							if mNameParts[1] == "r" and (findString mNameParts[3] "Mid" != undefined) then
			-- 							(
			-- 								maskSignExpr1[index] = -1
			-- 							)
								)
								
								default: subanimXYZ = 1
							)
							
							if mNameParts[3] == "smooth" and mNameParts[2] == "eld" then
								maskMultipliers[index] = 80
							
							if mNameParts[2] == "frown" then
								maskMultipliers[index] = 80
							
							--almacena los calculos
							maskController[index] = #(subanim2, subanimXYZ)
							
							--busca si el gesto tiene negativo para poner una condicion o dejarla en blanco
							neg = findNegative mName mNameParts[5] morphModifier
							
							if neg then --si el gesto tiene negativo
							(
								caseFlag = 1 --flag para saber como dividir el movimiento del shape entre un gesto y su negativo
								
								--calcula el caso para la condicion de la expresion
								case mNameParts[5] of
								(
									"up": caseFlag = 1
									"dw":	caseFlag = 2

									"r": 
									(
										caseFlag = 2
										if mNameParts[1] == "r" then
										(
											caseFlag = 1
											maskSignExpr3[index] = -1
										)
									)
									
									"l": 
									(
										caseFlag = 1
										if mNameParts[1] == "r" then
										(
											caseFlag = 2
											maskSignExpr3[index] = -1
										)
									)
									
									"fr": caseFlag = 2
									"bk": caseFlag = 1
									
									"in": caseFlag = 2
									"out": caseFlag = 1
									
									default:caseFlag = 1
								)
								
								--calcula la expresion de conexion en funcion del caso
								case caseFlag of
								(
									1:
									(
										if mNameParts[4] == "scale" then
										(
											maskConditionExpr[index] = "(sign2*partial * sign3*full)>1"
											maskExpression[index][2] = " , (sign1*((sign2*partial * sign3*full)*multiplier) - multiplier) , 0)" --parte 2 de la expresion"
										)
										else
											maskConditionExpr[index] = "(sign2*partial + sign3*full)>0"
									)
									
									2:
									(
										if mNameParts[4] == "scale" then
										(
											maskConditionExpr[index] = "(sign2*partial * sign3*full)<1"
											maskExpression[index][2] = " , (sign1*((sign2*(1-partial) + sign3*(1-full))*multiplier*2)) , 0)" --parte 2 de la expresion"
										)
										else
										(
											maskConditionExpr[index] = "(sign2*partial + sign3*full)<0"
											maskSignExpr1[index] = -1
										)
									)
								)
								
							)
							else --si el gesto no tiene negativo
							(
								caseFlag = 2
								
								--calcula el caso para el signo de la expresion
								case mNameParts[5] of
								(
									"dw":
									(
										case mNameParts[3] of
										(
											"all":
											(
												if mNameParts[2] == "ffdjaw" then caseFlag = 1
												else if mNameParts[2] == "ffdskl" then caseFlag = 1
												else if mNameParts[2] == "jaw" and mNameParts[3] != "break" then
													caseFlag = 1
											)
											"upper":		caseFlag = 1
											"upperAll":	caseFlag = 1
											"upperExt":	caseFlag = 1
											"upperInt":	caseFlag = 1
											"upperMid":	caseFlag = 1
											"upperMid1":	if mNameParts[2] == "eld" then caseFlag = 1
											"upperMid2":	if mNameParts[2] == "eld" then caseFlag = 1
											"upperMid3":	if mNameParts[2] == "eld" then caseFlag = 1
											"smooth": if mNameParts[2] == "eld" then caseFlag = 1
										)
									)
									
									"up":
									(
										case mNameParts[3] of
										(
											"lower":		caseFlag = 1
											"lowerAll":	caseFlag = 1
											"lowerExt":	caseFlag = 1
											"lowerInt":	caseFlag = 1
											"lowerMid":	caseFlag = 1
											"lowerMid1": if mNameParts[2] == "eld" then caseFlag = 1
											"lowerMid2": if mNameParts[2] == "eld" then caseFlag = 1
											"lowerMid3": if mNameParts[2] == "eld" then caseFlag = 1
											--"all":			if mNameParts[2] == "ffdskl" then caseFlag = 1
										)
									)
									
									"l":
									(
										if mNameParts[1] == "r" then
										(
											caseFlag = 1
											
											if mNameParts[1] == "r" and mNameParts[2] == "eye" and mNameParts[3] == "fix" then
												caseFlag = 2
										)
									)
									
									"r":
									(
										if mNameParts[1] == "l" then
										(
											caseFlag = 1
											
											if mNameParts[1] == "l" and mNameParts[2] == "eye" and mNameParts[3] == "fix" then
												caseFlag = 2
										)
										
										if mNameParts[1] == "r" and mNameParts[2] == "lip" and (findString mNameParts[3] "Mid" != undefined) then
											caseFlag = 1
										
										if mNameParts[1] == "r" and mNameParts[2] == "eld" and mNameParts[4] == "hz" then
											caseFlag = 1
										
									)
									
									"bk":
									(
										if mNameParts[2] == "ffdskl" then
											caseFlag = 2
										else
											caseFlag = 1
									)
									
									"fr": if mNameParts[4] == "stretch" then caseFlag = 1
															
									"in": if mNameParts[4] == "rot" then caseFlag = 1
									"out": if mNameParts[4] == "rot" then caseFlag = 1
										
									default:caseFlag = 2
								)
								
								if mNameParts[2] == "ebw" and mNameParts[6] != undefined then
									caseFlag = 1
								
								--calcula el signo de la expresion segun el caso
								case caseFlag of
								(
									1: maskSignExpr1[index] = -1
									2:
									(
										maskSignExpr1[index] = 1
										
										if mNameParts[4] == "scale" then
											maskExpression[index][2] = " , (sign1*((sign2*partial * sign3*full)*multiplier) -multiplier) , 0)" --parte 2 de la expresion"
									)
								)
								
								progOffset = false
								
								if mNameParts.count == 6 then
								(
									if (findString mName "eld-upper" != undefined) /*or (findString mName "ebw-" != undefined)*/ then
										progOffset = true
								)
								
								if progOffset then
								(
									parts = filterString mName "-"
									if parts.count == 5 then
									(
										_projectUnit = "z"
										_pathParts = filterstring maxfilepath "\\:"
										if _pathParts.count != 0 then _projectUnit = tolower _pathParts[1]
										
										parts = filterString parts[5] "po"
										
										if _projectUnit != "x" then
											if parts[2] != undefined then
												maskOffsets[index] = parts[2] as float
									)
								)
							)
						)
					)
					else --si el canal esta vacio o ya conectado
					(
						if connected then --si esta conectado
						(
							--extrae los valores necesarios del float expression
							case classof morphModifier of
							(
								morpher: floatExpr = morphModifier[index].controller
								Morph_O_Matic: floatExpr = morphModifier[index][2].controller
							)							
								
							--extrae los valores de conexion del float expression
							
							maskMultipliers[index] = floatExpr.GetScalarConstant "multiplier" as integer
							maskOffsets[index] = floatExpr.GetScalarConstant "offset" as integer
							maskSignExpr1[index] = floatExpr.GetScalarConstant "sign1" as integer
							maskSignExpr2[index] = floatExpr.GetScalarConstant "sign2" as integer
							maskSignExpr3[index] = floatExpr.GetScalarConstant "sign3" as integer
							
							--extrae los shapes de control
							maskShapes[index] = #()
							maskShapes[index][1] = (refs.dependentnodes (floatExpr.GetScalarTarget "partial" asController:false))[2]
							
							if findString maskShapes[index][1].name "_facial_" == undefined then
								maskShapes[index][1] = (refs.dependentnodes (floatExpr.GetScalarTarget "partial" asController:false))[1]
								
								
							if (floatExpr.GetScalarType "full") == #scalarTarget then
							(
								maskShapes[index][2] = (refs.dependentnodes (floatExpr.GetScalarTarget "full" asController:false))[2]
									
								if findString maskShapes[index][2].name "_facial_" == undefined then
									maskShapes[index][2] = (refs.dependentnodes (floatExpr.GetScalarTarget "full" asController:false))[1]
							)
							else
								maskShapes[index][2] = 0
								
							controller = (floatExpr.GetScalarTarget "partial" asController:false) as string
							controller = substituteString controller "SubAnim:" ""
							controller = filterString controller "_"
							
							--calcula si tiene que controlar X Y o Z
							subanimXYZ = undefined
							case controller[1] of
							(
								"X": subanimXYZ = 1
								"Y": subanimXYZ = 2
								"Z": subanimXYZ = 3
							)
							
							--calcula si tiene que usar posicion, rotacion o escala
							subanim2 = undefined
							case controller[2] of
							(
								"Position": subanim2 = 1
								"Rotation": subanim2 = 2
								"Scale": subanim2 = 3
							)
							
							--almacena los calculos
							maskController[index] = #(subanim2,subanimXYZ)

							expression = floatExpr.GetExpression()
							
							--busca la expresion de conexion
							if (findString expression "always") != undefined then
								maskConditionExpr[index] = "always"
							else
								if (findString expression "<") != undefined then
									maskConditionExpr[index] = "(sign2*partial + sign3*full)<0"
								else
									maskConditionExpr[index] = "(sign2*partial + sign3*full)>0"
							
							--calcula el nombre abreviado de los shapes de conexion
							maskShapesName[index] = #()
							
							parts = filterString maskShapes[index][1].name "_"
							maskShapesName[index][1] = parts[4] + "_" + parts[5]
							
							if maskShapes[index][2] != 0 then
							(
								parts = filterString maskShapes[index][2].name "_"
								maskShapesName[index][2] = parts[4] + "_" + parts[5]
							)
								
						)
						else --si el canal esta vacio
						(
							maskMultipliers[index] = 40
							maskOffsets[index] = 0
							
							maskController[index] = #(1, 1)
							maskConditionExpr[index] = "always"
							maskSignExpr1[index] = 1
							maskSignExpr2[index] = 1
						)
					)
				) --proyecto de tadeo jones
			)--case			
		)

		------------------------------------------------
		--@fn: undefined | getMaskShapeControls | obtiene los shapes de la careta
		------------------------------------------------							
		fn getMaskShapeControls =
		(
			_maskShapePattern = "_facial_?_*_x_c"
			_chrName = (filterString parent.rollMain.chrNode.name "_")[1] + "_" + (filterString parent.rollMain.chrNode.name "_")[2]
			_completePattern = "$'" + _chrName + _maskShapePattern + "'"
			
			_maskShapeControls = (execute _completePattern) as array
			
			_maskShapeControls
		)

		------------------------------------------------
		--@fn: undefined | fillMaskArrays | rellena los arrays con el contenido correspondiente
		------------------------------------------------		
		fn fillMaskArrays = 
		(
			tempShapes = #() --array temporal para almacenar los objetos la escena que sean Shapes faciales
				
			if parent.rollMain.ckbMorphMode.checked then --modo morphs
			(
				morphMod = parent.rollMain.morphMod --modificador morpher que estamos manejando
				objName = parent.rollMain.morphObj.name --nombre del objeto con el morpher
				objNameParts = filterstring objName "_" --partes del nombre
				
				--parte inicial de todos los shapes faciales del personaje
				shapeNameInitialPart = objNameParts[1] + "_" + objNameParts[2] + "_facial"
				
				--recorre los objetos de la escena buscando shapes faciales
				for i=1 to objects.count do
					if (findstring objects[i].name shapeNameInitialPart) != undefined and
					(findstring objects[i].name "aux") == undefined and
					(findstring objects[i].name "invert") == undefined then
					(
						--para mantener compatibilidad con el proyecto de Tadeo y para no mantener los prefijos invert en los nuevos proyectos se programa esta excepcion
						--hay que excluir los shapes que no sean controles de animación, es decir los no acabados en "_c"
						if matchPattern objects[i].name pattern:"*_*_*_*_*_*_c*" then
							append tempShapes objects[i]
					)
					
				_limit = 100
				if classof morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels morphMod
				
				--obtiene el nombre de los canales de morph que tiene el modificador
				for i=1 to _limit do
				(
					case classof morphMod of
					(
						morpher: morphNames[i] = WM3_MC_GetName morphMod i
						Morph_O_Matic: morphNames[i] = morphMod[i].name
					)
				)
				
				--recorre el morpher intentado encontrar el shape adecuado para cada canal
				for i=1 to _limit do
				(
					mName = morphNames[i]
					
					_theController = undefined
					
					case classof morphMod of
					(
						morpher: _theController = morphMod[i].controller
						Morph_O_Matic: _theController = morphMod[i][2].controller
					)--case
					
					if _theController != undefined then
					(
						connected = false
						
						--averigua si el canal esta conectado y si la conexion es correcta, es decir, que contiene las 
						--variables necesarias y los nodos a los que hacen referencia existen
						
						case classof morphMod of
						(
							morpher: auxController = morphMod[i].controller
							Morph_O_Matic: auxController = morphMod[i][2].controller
						)--case
						
						if (auxController as string) == "Controller:Float_Expression" then
						(
							isCorrect = true
							
							if not auxController.VariableExists "sign1" then isCorrect = false
							if not auxController.VariableExists "sign2" then isCorrect = false
							if not auxController.VariableExists "always" then isCorrect = false
							if not auxController.VariableExists "multiplier" then isCorrect = false
							if not auxController.VariableExists "offset" then isCorrect = false
							if not auxController.VariableExists "full" then isCorrect = false
							if not auxController.VariableExists "partial" then isCorrect = false
							
							shapeNodePartial = undefined
							shapeNodeFull = undefined
							
							if isCorrect then
							(
								if (auxController.GetScalarType "partial") == #scalarTarget then
									shapeNodePartial = (refs.dependentnodes (auxController.GetScalarTarget "partial" asController:false))[2]
							)
							
							if (not isValidNode shapeNodePartial) then
								isCorrect = false
							
							if isCorrect then
								connected = true
							
						)
						
						--si el canal de morph no esta conectado ya con un shape, busca los candidatos
						if not connected then
						(
							maskShapesName[i] = #()
							maskConnection[i] = "x"
							
							--almacena en channelShapes los shapes que van a controlar ese shape
							channelShapes = findMatchingShapes mName tempShapes
							
							--si ha conseguido encontrar shapes de control
							if channelShapes.count != 0 then
							(
								--almacena los shapes de control para cada gesto
								maskShapes[i] = channelShapes
								
								--obtiene los nombres abreviados de los shapes para mostrarlos en el listview
								shNameParts = filterString channelShapes[1].name "_"
								shapeNames = #((shNameParts[4] + "_" + shNameParts[5]) as string)
								if channelShapes[2] != 0 then
								(
									shNameParts = filterString channelShapes[2].name "_"
									append shapeNames ((shNameParts[4] + "_" + shNameParts[5]) as string)
								)
								
								maskShapesName[i] = shapeNames
							)
							else --si no hay shapes de control
							(
								maskShapes[i] = #()
								maskShapesName[i] = #("- not found -")
							)
							
							--calcula la expression de conexion y los controladores de cada shape que accionan cada gesto
							fillMaskExpressionArrays i morphMod maskShapes[i] false
						)
						else
						(
							maskConnection[i] = "v"
							fillMaskExpressionArrays i morphMod maskShapes[i] true
						)
						
					)
					else --if controller is undefined
					(
						maskShapes[i] = #()
						maskShapesName[i] = #("- empty -")
						maskConnection[i] = "x"
						
						fillMaskExpressionArrays i morphMod maskShapes[i] false
					)--if
									
				)--for morph channels
			)
			else if parent.rollMain.ckbBonesMode.checked then --modo huesos
			(
				_chrNode = parent.rollMain.chrNode
				_chrName = (filterString _chrNode.name "_")[1] + "_" + (filterString _chrNode.name "_")[2]
				
				tempShapes = getMaskShapeControls()
				tempShapesNames = for tmps in tempShapes collect ((filterstring tmps.name "_")[4] + "_" + (filterstring tmps.name "_")[5])
				
				--aprovechamos 
				morphNames = for i=1 to parent.rollMain.lvMorphList.items.count collect parent.rollMain.lvMorphList.items.item[i-1].subitems.item[1].text
				
				--recorre los shapes temporales y los shapes de la cara buscando la correspondencia
				for i = 1 to morphNames.count do
				(
					_index = findItem tempShapesNames (substituteString (substituteString morphNames[i] "-shp" "") "ce" "c")
					
					if _index != 0 then
					(
						maskShapes[i] = tempShapes[_index]
						maskShapesName[i] = tempShapesNames[_index]
						maskConnection[i] = "x"
						
						---------------------------------------------------
						--averigua si ya está conectado
						
						_faceShape = parent.rollMain.faceShapeControls[i]	
						
						if classof _faceShape.position.controller == position_list and classof maskShapes[i].position.controller == position_list then
						(
							if _faceShape.position.controller["Zero_Pos_XYZ"] != undefined and maskShapes[i].position.controller["Zero_Pos_XYZ"] != undefined then
								if _faceShape.position.controller["Zero_Pos_XYZ"].controller == maskShapes[i].position.controller["Zero_Pos_XYZ"].controller then
									maskConnection[i] = "v"
								
							if maskConnection[i] == "x" then
								if _faceShape.position.controller["Influence"] != undefined and maskShapes[i].position.controller["Influence"] != undefined then
									if _faceShape.position.controller["Influence"].controller == maskShapes[i].position.controller["Influence"].controller then
										maskConnection[i] = "v"
						)
						
						if maskConnection[i] == "x" and classof _faceShape.rotation.controller == rotation_list and classof maskShapes[i].rotation.controller == rotation_list then
						(
							if _faceShape.rotation.controller["Zero_Euler_XYZ"] != undefined and maskShapes[i].rotation.controller["Zero_Euler_XYZ"] != undefined then
								if _faceShape.rotation.controller["Zero_Euler_XYZ"].controller == maskShapes[i].rotation.controller["Zero_Euler_XYZ"].controller then
									maskConnection[i] = "v"
								
							if maskConnection[i] == "x" then
								if _faceShape.rotation.controller["Influence"] != undefined and maskShapes[i].rotation.controller["Influence"] != undefined then
									if _faceShape.rotation.controller["Influence"].controller == maskShapes[i].rotation.controller["Influence"].controller then
										maskConnection[i] = "v"
						)
						
						if maskConnection[i] == "x" and classof _faceShape.scale.controller == scale_list and classof maskShapes[i].scale.controller == scale_list then
						(
							if _faceShape.scale.controller["Zero_Scale_XYZ"] != undefined and maskShapes[i].scale.controller["Zero_Scale_XYZ"] != undefined then
								if _faceShape.scale.controller["Zero_Scale_XYZ"].controller == maskShapes[i].scale.controller["Zero_Scale_XYZ"].controller then
									maskConnection[i] = "v"
								
							if maskConnection[i] == "x" then
								if _faceShape.scale.controller["Influence"] != undefined and maskShapes[i].scale.controller["Influence"] != undefined then
									if _faceShape.scale.controller["Influence"].controller == maskShapes[i].scale.controller["Influence"].controller then
										maskConnection[i] = "v"
						)
						---------------------------------------------------
					)--if
					else
					(
						maskShapes[i] = undefined
						maskShapesName[i] = "- empty -"
						maskConnection[i] = "x"
					)
				)--for
				
			)
		)--fn fillShapeArrays
 
		------------------------------------------------
		--@fn: undefined | fillMaskListView | Rellena el listview según el Asset seleccionado
		------------------------------------------------
		fn fillMaskListView =
		(
			if parent.rollMain.ckbMorphMode.checked then
			(				
				--llena los arrays de conexion
				fillMaskArrays()
				
				_limit = 100
				if classof parent.rollMain.morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels parent.rollMain.morphMod
				
				--recorre todos los canales rellenando las lista con los valores calculados con anterioridad
				for i = 1 to _limit do
				(
					--rellena la fila
					row = dotNetObject "System.Windows.Forms.ListViewItem" (i as string)
					row.UseItemStyleForSubItems = false
					
					row.SubItems.add (maskShapesName[i][1] as string)
					if maskShapesName[i].count == 2 then
						row.SubItems.add (maskShapesName[i][2] as string)
					else
						row.SubItems.add ""
					
					row.SubItems.add ""
					
					lvMaskList.items.add row
				
					--coloca el color de la celda en funcion de si el canal esta conectado o no
					if maskConnection[i] == "v" then
					(	
						lvMaskList.items.item[i-1].subitems.item[3].backcolor = dnConnectColor
					) 
					else if maskShapesName[i][1] != "- empty -" then
					(
						lvMaskList.items.item[i-1].subitems.item[3].backcolor = dnUnconnectColor
					)
					else
					(
						lvMaskList.items.item[i-1].subitems.item[3].backcolor = dnBackColor
					)
					
				)
			)
			else if parent.rollMain.ckbBonesMode.checked then
			(
				--llena los arrays de conexion
				fillMaskArrays()				
				
				for i=1 to maskShapes.count do
				(
					--rellena la fila
					row = dotNetObject "System.Windows.Forms.ListViewItem" (i as string)
					row.UseItemStyleForSubItems = false
					
					row.SubItems.add (maskShapesName[i] as string)
					row.SubItems.add ""
					row.SubItems.add ""
										
					lvMaskList.items.add row
					
					--coloca el color de la celda en funcion de si el canal esta conectado o no
					if maskConnection[i] == "v" then
					(	
						lvMaskList.items.item[i-1].subitems.item[3].backcolor = dnConnectColor
					) 
					else if maskShapesName[i][1] != "- empty -" then
					(
						lvMaskList.items.item[i-1].subitems.item[3].backcolor = dnUnconnectColor
					)
					else
					(
						lvMaskList.items.item[i-1].subitems.item[3].backcolor = dnBackColor
					)
				)
			)	
		)--fn fillMaskListView

		------------------------------------------------
		--@fn: undefined | fillMaskListView | actualiza los controles de la herramienta con los valores correspondientes al shape seleccionado
		------------------------------------------------
		fn updateShapeValues index =
		(
			if parent.rollMain.ckbMorphMode.checked then --modo morpher
			(
				if maskShapesName[index][1] != "- empty -" then --si hay algun shape de conexion
				(
					--rellena los campos del shape parcial
					txtMaskToChannelMorph.text = maskShapesName[index][1]
					pckPartialShape.caption = "partial: " + maskShapesName[index][1]
					
					--si hay un shape global, rellena los campos del shape full
					if maskShapesName[index][2] != undefined then
					(
						txtMaskToChannelMorph.text = txtMaskToChannelMorph.text + " &" + maskShapesName[index][2]
						pckFullShape.caption = "full: " + maskShapesName[index][2]
					)
					else
						pckFullShape.caption = "full: - empty -"
					
					--completa el titulo de la conexion
					txtMaskToChannelMorph.text = txtMaskToChannelMorph.text + " -> " + parent.rollMain.lvMorphList.items.item[index-1].subitems.item[1].text
				)
				else --si no hay shapes de conexion, deja los campos por defecto
				(
					txtMaskToChannelMorph.text = "<Mask Shapes> -> <Morph Channel>"
					pckPartialShape.caption = "partial: - empty -"
					pckFullShape.caption = "full: - empty -"
				)
				
				--rellena el resto de controles de la herramienta con los valores de la conexion del canal seleccionado
				rdoController.state = maskController[index][1]
				rdoAxis.state = maskController[index][2]
				
				spnMultiplier.value = maskMultipliers[index] as integer
				spnOffset.value = maskOffsets[index] as integer
				spnSign1.value = maskSignExpr1[index] as integer
				spnSign2.value = maskSignExpr2[index] as integer
				spnSign3.value = maskSignExpr3[index] as integer
				
				--rellena la expresion de conexion
				rchTxtExpression.text = (maskExpression[index][1] + maskConditionExpr[index] + maskExpression[index][2])
				
				if maskConnection[index] == "v" or maskConnection[index] == "u" then
					btnConnect.caption = "Update"
				else
					btnConnect.caption = "Connect"
			)
			else --modo huesos
			(
				if maskConnection[index] == "v" or maskConnection[index] == "u" then
					btnConnect.caption = "Update"
				else
					btnConnect.caption = "Connect"
			)			
		)

		------------------------------------------------
		--@fn: undefined | getLvSelectedListItems | Anota en la variable lvSelectedListItems los elementos actualmente seleccionados
		------------------------------------------------
		fn getLvSelectedListItems =
		(
			lvSelectedListItems = #()
			for i = 1 to lvMaskList.selectedItems.count do
				append lvSelectedListItems i
		)--fn getLvSelectedListItems

		------------------------------------------------
		--@fn: undefined | restoreLvSelectedItems | Restablece la antigua seleccion de items
		------------------------------------------------
		fn restoreLvSelectedItems =
		(
			for i=1 to lvMaskList.items.count do
				lvMaskList.items.item[i-1].selected = false

			for i=1 to lvSelectedListItems.count do
				lvMaskList.items.item[lvSelectedListItems[i]].selected = true
		)--fn restoreLvSelectedItems

		------------------------------------------------
		--@fn: undefined | lvSelectRange | selecciona el rango de items entre los dos indices
		------------------------------------------------	
		fn lvSelectRange index1 index2 =
		(
			i1 = index1 ; i2 = index2
			if index1 > index2 then (i1 = index2; i2 = index1)
			
			lvSelectedListItems = #()
			for i = i1 to i2 do append lvSelectedListItems i
			restoreLvSelectedItems()
		)--fn lvSelectRange

		------------------------------------------------
		--@fn: undefined | updateRowsColor | cambia el color de las filas en funcion de si el listview esta en focus o no
		------------------------------------------------			
		fn updateRowsColor i listViewFocused =
		(
			--for i=1 to 100 do
			--(
				item = lvMaskList.items.item[i-1]
				if item.selected and not listViewFocused then --si el item esta seleccionado y la lista no esta seleccionada
				(
					--si el color de fondo no es azul oscuro
					if item.backColor != (dotNetClass "System.Drawing.Color").midnightblue then
					(
						item.backColor = (dotNetClass "System.Drawing.Color").midnightblue
						item.subitems.item[1].backcolor = (dotNetClass "System.Drawing.Color").midnightblue
						item.subitems.item[2].backcolor = (dotNetClass "System.Drawing.Color").midnightblue
						--item.subitems.item[3].backcolor = (dotNetClass "System.Drawing.Color").midnightblue
					)
					
					--si el color de las lineas no es blanco
					if item.foreColor != (dotNetClass "System.Drawing.Color").white then
					(
						item.foreColor = (dotNetClass "System.Drawing.Color").white
						item.subitems.item[1].foreColor = (dotNetClass "System.Drawing.Color").white
						item.subitems.item[2].foreColor = (dotNetClass "System.Drawing.Color").white
						--item.subitems.item[3].foreColor = (dotNetClass "System.Drawing.Color").white
					)
				)
				else --si esta seleccionado el item o la lista
				(
					--si el color de fondo es diferente de dnBackColor
					if item.backColor != dnBackColor then
					(
						item.backColor = dnBackColor
						item.subitems.item[1].backcolor = dnBackColor
						item.subitems.item[2].backcolor = dnBackColor
					)
					
					--si el color de la linea es diferente de negro
					if item.foreColor != (dotNetClass "System.Drawing.Color").black then
					(
						item.foreColor = (dotNetClass "System.Drawing.Color").black
						item.subitems.item[1].foreColor = (dotNetClass "System.Drawing.Color").black
						item.subitems.item[2].foreColor = (dotNetClass "System.Drawing.Color").black						
					)
				)

				if maskConnection[i] == "v" then --si esta conectado
					item.subitems.item[3].backcolor = dnConnectColor
				else if maskConnection[i] == "u" then --si esta pendiente de actualizacion
					item.subitems.item[3].backcolor = dnUpdateColor
				else if maskShapesName[i][1] != "- empty -" then --si no esta vacio
					item.subitems.item[3].backcolor = dnUnconnectColor
				else --si esta vacio
					item.subitems.item[3].backcolor = dnBackColor				
			--)				
		)

		------------------------------------------------
		--@fn: undefined | connectShapeMorph | conecta el shape con el morph si no estan conectados ya, sino actualiza la expression de conexion
		------------------------------------------------	
		fn connectShapeMorph index = 
		(
			morphMod = parent.rollMain.morphMod
			
			--si no esta conectado ya o esta pendiente de actualizacion
			if (maskConnection[index] == "x" or maskConnection[index] == "u") and (maskShapesName[index][1] != "- not found -") and (maskShapesName[index][1] != "- empty -") then
			(
				--crea el controlador
				floatExpr = Float_Expression()
				
				case classof morphMod of
				(
					morpher: morphMod[index].controller =  floatExpr
					Morph_O_Matic: morphMod[index][2].controller =  floatExpr
				)
				
				--crea la expresion
				expression = (maskExpression[index][1] + maskConditionExpr[index] + maskExpression[index][2])
				
				--añande las variables escalares con el valor precalculado anteriormente----------------
				
				if findString maskShapes[index][1].name "m_ffdskl" != undefined and findString morphMod[index].name "_ffdebw" != undefined then
				(--caso del ffd de cejas-ojos del loro
					floatExpr.AddScalarTarget "partial" maskShapes[index][1][3][2].controller[2].controller[2].controller
					
					if findString morphMod[index].name "l_ffdebw" != undefined then
						maskSignExpr2[index] = -4
					else if findString morphMod[index].name "r_ffdebw" != undefined then
						maskSignExpr2[index] = 4
				)
				else --caso normal
					floatExpr.AddScalarTarget "partial" maskShapes[index][1][3][maskController[index][1]].controller[2].controller[maskController[index][2]].controller
				
				if maskShapesName[index][2] != undefined then
				(
					if findString maskShapes[index][2].name "m_ffdskl" != undefined and findString morphMod[index].name "_ffdebw" != undefined then
					(--caso del ffd de cejas-ojos del loro
						floatExpr.AddScalarTarget "full" maskShapes[index][2][3][2].controller[2].controller[2].controller
						
						if findString morphMod[index].name "l_ffdebw" != undefined then
							maskSignExpr3[index] = -4
						else if findString morphMod[index].name "r_ffdebw" != undefined then
							maskSignExpr3[index] = 4
					)
					else --caso normal
						floatExpr.AddScalarTarget "full" maskShapes[index][2][3][maskController[index][1]].controller[2].controller[maskController[index][2]].controller
				)
				else
					floatExpr.AddScalarConstant "full" 0
				
				----------------------------------------------------------------------------------------------
				
				--cambia la expresion para el caso concreto del ffd especia de ebw (el del loro vamos)----------
			-- 				if findString maskShapes[index][1].name "m_ffdskl" != undefined then
			-- 				(
			-- 					maskSignExpr2[index] = -1
			-- 				)
			-- 				
			-- 				if findString maskShapes[index][2].name "m_ffdskl" != undefined then
			-- 				(
			-- 					maskSignExpr3[index] = -1
			-- 				)
				---------------------------------------------------------------------------------------------------------
				
				floatExpr.AddScalarConstant "always" 100000
				floatExpr.AddScalarConstant "sign1" maskSignExpr1[index]
				floatExpr.AddScalarConstant "sign2" maskSignExpr2[index]
				floatExpr.AddScalarConstant "sign3" maskSignExpr3[index]
				floatExpr.AddScalarConstant "multiplier" maskMultipliers[index]
				floatExpr.AddScalarConstant "offset" maskOffsets[index]
				
				--añande la expresion
				floatExpr.SetExpression expression
				
				--pone el canal como conectado
				maskConnection[index] = "v"
			)
			
			updateRowsColor index false
		)

		------------------------------------------------
		--@fn: undefined | changeShape | cambia el shape asociado a un canal por otro pasado por parametro
		------------------------------------------------
		fn changeShape newShape pos:1 =
		(
			index = parent.rollMain.indexSelected
			
			--si cumple el namingo convention y es un shape
			if (lb.nc.ncOK newShape.name) and (ClassOf newShape == SplineShape) then
			(
				flag = true
				
				if pos == 2 then --comprueba que cumple lsa condiciones para ser añadido
					if (maskShapesName[index][1] == undefined or maskShapesName[index][1] == "- empty -" or maskShapesName[index][1] == "- not found -" ) then
					(
						flag = false
						lb.message.show "Cannot add full shape if there is not a partial shape" type:#message pos:undefined size:[300,75] modal:true
					)
					else if maskShapes[index][1].name == newShape.name then
					(	
						flag = false
						lb.message.show ("Partial Shape and Full Shape cannot be the same") type:#message pos:undefined size:[300,75] modal:true
					)
				
				if flag then --si cumple las condiciones
				(
					maskShapes[index][pos] = newShape --añade el shape
					
					nameParts = filterString newShape.name "_"
					maskShapesName[index][pos] = nameParts[4] + "_" + nameParts[5] --calcula el nombre abreviado
					
					lvMaskList.items.item[index-1].subitems.item[pos].text = maskShapesName[index][pos] --actualiza la lista
					
					--actualiza el texto de los botones
					if pos != 2 then
						pckPartialShape.caption = "partial: " + maskShapesName[index][pos]
					else
						pckFullShape.caption = "full: " + maskShapesName[index][pos]
				)
				
			)
			else --si no cumple el naming convention o no es un shape
				lb.message.show (newShape.name + " doesn't match Naming Convention or is not a Shape") type:#message pos:undefined size:[300,75] modal:true
		)

		------------------------------------------------
		--@fn: undefined | saveConnections | guarda la informacion de los vertex colors
		------------------------------------------------
		fn saveConnections filename = 
		(
			if filename != undefined then --si tiene un path definido
			(
-- 				filename = folder + "\\" + parent.rollMain.morphObj.name + ".conn"
				
				try (deleteFile filename) catch () --intenta eliminar el fichero si ya existe
				
				--guarda el nombre del objeto que lleva el morpher
				setINISetting filename "morphInfo" "morphObj" parent.rollMain.morphObj.name
				setINISetting filename "morphInfo" "sectionEnd" "-------------------------------------------------------------"
				
				messageText = "File \""  + filename + "\" created successfully\n"
				
				--almacena la informacion de conexion de los 100 canales en el fichero
				success = false
				pbSaveLoad.value = 0
				for i=1 to 100 do
				(
					if maskShapesName[i][1] != "- empty -" and maskShapesName[i][1] != "- not found -" then
					(
						setINISetting filename ("channel_" + i as string) "specificShape" maskShapes[i][1].name
						setINISetting filename ("channel_" + i as string) "globalShape" (if maskShapes[i][2] != 0 then maskShapes[i][2].name else "undefined")
						setINISetting filename ("channel_" + i as string) "specificShapeName" maskShapesName[i][1]
						setINISetting filename ("channel_" + i as string) "globalShapeName" (if maskShapesName[i][2] != undefined then maskShapesName[i][2] else "- empty -")
						setINISetting filename ("channel_" + i as string) "morphChannel" parent.rollMain.lvMorphList.items.item[i-1].subitems.item[1].text	
							
						setINISetting filename ("channel_" + i as string) "connected" (if maskConnection[i] == "v" or maskConnection[i] == "u" then "true" else "false")
						setINISetting filename ("channel_" + i as string) "expressionPart1" maskExpression[i][1]
						setINISetting filename ("channel_" + i as string) "expressionCondition" maskConditionExpr[i]
						setINISetting filename ("channel_" + i as string) "expressionPart2" maskExpression[i][2]
						
						setINISetting filename ("channel_" + i as string) "sign1" (maskSignExpr1[i] as string)
						setINISetting filename ("channel_" + i as string) "sign2" (maskSignExpr2[i] as string)
						setINISetting filename ("channel_" + i as string) "sign3" (maskSignExpr3[i] as string)
						setINISetting filename ("channel_" + i as string) "multiplier" (maskMultipliers[i] as string)
						setINISetting filename ("channel_" + i as string) "offset" (maskOffsets[i] as string)
						
						setINISetting filename ("channel_" + i as string) "controller" (maskController[i][1] as string)
						setINISetting filename ("channel_" + i as string) "subcontroller" (maskController[i][2] as string)
						
						success = setINISetting filename ("channel_" + i as string) "sectionEnd" "-------------------------------------------------------------"
					)
					pbSaveLoad.value = i
				)--for 1 to 100
				pbSaveLoad.value = 0
								
				if messageText.count != 0 and success then
					lb.message.show messageText type:#message pos:undefined size:[400,100] modal:true
				else
					lb.message.show "Error, information couldn't be saved" type:#message pos:undefined size:[400,100] modal:true
				
			)--if folder	
		)

		------------------------------------------------
		--@fn: undefined | loadConnections | carga la informacion de los vertex colors
		------------------------------------------------
		fn loadConnections file overwrite:false = 
		(
			_ast = (lb.asset.getSceneAssets())[1]
			
			-- Obtenemos la información de disco y de la escena y omitimos la segunda parte para poderlo cargar a cualaquier personaje.
			_morphObjInfoPart = lb.nc.replaceNamePart (getINISetting file "morphInfo" "morphObj") 2 "*"
			_morphObjInfo = (execute ("$'" + _morphObjInfoPart + "'"))[1]
				
			_morphObjPart = lb.nc.replaceNamePart parent.rollMain.morphObj.name 2 "*"
			_morphObj = (execute ("$'" + _morphObjPart + "'"))[1]
			
			--si tiene un nombre de fichero con el que trabajar
			if file != undefined then
			(			
				--si el fichero existe y
				--si el fichero guarda las conexiones del objeto con el cal estamos trabajando
				if (_morphObj == _morphObjInfo) then
				(
					selIndex = parent.rollMain.indexSelected --bckp del canal seleccionado actualmente
					
					--almacena los canales del morphe del objeto con el que trabajamos
					morphTargets = #()					
					for i=1 to 100 do
						morphTargets[i] = parent.rollMain.lvMorphList.items.item[i-1].subitems.item[1].text
					
					--carga los shapes de la escena que pertenecen a la mascara
					sceneShapes = #()
					sceneShapesName = #()
					
					-- Obtenemos los nodos de tipo facial
					for _obj in _ast.facialNodesAll do
					(
						append sceneShapes _obj
						append sceneShapesName _obj.name
					)
					
					loadedChannels = #() --almacena el numero de los canales a los que ha cargado informacion
					
					--recorre el fichero extrayendo la informacion de los 100 canales de morph
					pbSaveLoad.value = 0
					for i=1 to 100 do
					(
						morphChannel = getINISetting file ("channel_" + i as string) "morphChannel"
						
						--si ha encontrado informacion guardada de ese canal
						if morphChannel != "" then
						(
							index = findItem morphTargets morphChannel
							
							--si el target existe en el morph del objeto con el que trabajamos
							if index != 0 then
							(
								--carga el resto de informacion de ese canal
								
								--carga la informacion del shape especifico, se obtiene la informacion de disco y se selecciona los objetos
								specificShape = (execute ("$'" + ((lb.nc.replaceNamePart (getINISetting file ("channel_" + i as string) "specificShape") 2 "*")) + ""))[1]
									
								if specificShape != undefined then
								(									
									shapeIndex = findItem sceneShapesName specificShape.name
								
									--si el shape especifico exsite en la escena, puede continuar cargando la informacion y conectando el shape con el canal
									if shapeIndex != 0 then
									(
										--carga los shapes especifico y global, y sus nombres
										maskShapes[index] = #(sceneShapes[shapeIndex],0)
										maskShapesName[index] = #((getINISetting file ("channel_" + i as string) "specificShapeName"))
										
										globalShape = getINISetting file ("channel_" + i as string) "globalShape"
										if globalShape != "undefined" then
										(
											shapeIndex = findItem sceneShapesName globalShape
											if shapeIndex != 0 then
											(
												maskShapes[index][2] = sceneShapes[shapeIndex]
												maskShapesName[index][2] = getINISetting file ("channel_" + i as string) "globalShapeName"
											)
										)
										
										--carga el resto de informaciones
										connectChannel = if (getINISetting file ("channel_" + i as string) "connected") == "true" then true else false
										maskConnection[index] = "x"
										maskExpression[index] = #((getINISetting file ("channel_" + i as string) "expressionPart1"),(getINISetting file ("channel_" + i as string) "expressionPart2"))
										maskConditionExpr[index] = getINISetting file ("channel_" + i as string) "expressionCondition"
										maskSignExpr1[index] = (getINISetting file ("channel_" + i as string) "sign1") as integer
										maskSignExpr2[index] = (getINISetting file ("channel_" + i as string) "sign2") as integer
										maskSignExpr3[index] = (getINISetting file ("channel_" + i as string) "sign3") as integer
										maskMultipliers[index] = (getINISetting file ("channel_" + i as string) "multiplier") as integer
										maskOffsets[index] = (getINISetting file ("channel_" + i as string) "offset") as integer
										maskController[index] = #((getINISetting file ("channel_" + i as string) "controller") as integer, (getINISetting file ("channel_" + i as string) "subcontroller") as integer)
										
										--conecta los hapes y el canal
										if connectChannel then
											connectShapeMorph index
										else
											parent.rollMain.morphMod[index].controller = Bezier_Float()
										
										--almacena el canal como cargado
										append loadedChannels index
										
										pbSaveLoad.value = i
									)
								)
							)
						)
						
						
					)--for	
					pbSaveLoad.value = 0
					
					--si hay que resetear los canales de los que no hay infomracion en el fichero
					if overwrite then
					(
						--recorre los canales y si tiene que resetear alguno, le pone los valores por defecto
						for i=1 to 100 do
							if findItem loadedChannels i == 0 then
							(
								if (WM3_MC_HasData parent.rollMain.morphMod i) then
									parent.rollMain.morphMod[i].controller = Bezier_Float()
									
								maskShapes[i] = #()
								maskShapesName[i] = #("- empty -")
								maskConnection[i] = "x"
								maskExpression[i] = #("if( "," , (sign1*((sign2*partial + full)*multiplier) + offset) , 0 )")
								maskConditionExpr[i] = "always"
								maskSignExpr1[i] = 1
								maskSignExpr2[i] = 1
								maskMultipliers[i] = 40
								maskOffsets[i] = 0
								maskController[i] = #(1,1)
							)
					)
					
					--Actualiza los valores de Channel Settings segun el canal seleccionado
					parent.rollMain.SelChannel selIndex
					parent.rollMain.indexSelected = selIndex
					parent.rollMain.updateChannelSettings selIndex
					updateShapeValues selIndex
					
					for i=1 to 100 do
						updateRowsColor i false
					
					if loadedChannels.count != 0 then
						lb.message.show ((loadedChannels.count as string) + " channel connections loaded successfully") type:#message pos:undefined size:[300,75] modal:true
					else
						lb.message.show "No channel connections info to load" type:#message pos:undefined size:[300,75] modal:true			
				)--if
				else
					lb.message.show "file info doesn't match with actual object" type:#message pos:undefined size:[300,75] modal:true
			)--if file
			else
				lb.message.show "there is no file to work with" type:#message pos:undefined size:[300,75] modal:true	
		)

		------------------------------------------------
		--@fn: undefined | connectMaskWithFaceShapes | conecta la mascara de animacion con los controles de animacion facial de la cara
		------------------------------------------------
		fn connectMaskWithFaceShapes =
		(
			_indexes = #() --array de indices a conectar
			
			if rdoConnection.state == 1 then
			(
				_indexes = for i=1 to maskShapes.count collect i
			)
			else if rdoConnection.state == 2 then
			(
				selList = parent.rollMain.lvSelListItems
				for j = 1 to selList.count do
					if maskShapesName[selList.item[j-1].index + 1] != "- empty -" and maskShapesName[selList.item[j-1].index + 1] != "- not found -" then
						appendifunique _indexes (selList.item[j-1].index + 1)
			)
				
			--recorre los shapes de la mascara conectandolos con los de la cara
			for k=1 to _indexes.count where maskShapes[(_indexes[k])] != undefined do
			(
				i = _indexes[k]
				maskShape = maskShapes[(_indexes[k])]
				
				------------------------------------------------------------------------------------------------
				--instanciación de la posicion
				_zeroController = undefined
				_influenceController = undefined
				
				_faceShape = parent.rollMain.faceShapeControls[i]
				if classof _faceShape.position.controller == position_list then
				(
					for j=1 to _faceShape.position.controller.count do
					(
						case (_faceShape.position.controller[j].name) of
						(	
							"Zero Pos XYZ": _zeroController = _faceShape.position.controller[j].controller
							"Influence": _influenceController = _faceShape.position.controller[j].controller
						)--case
					)--for			
				)--if
				
				if classof maskShape.position.controller == position_list then
				(
					_influenceFound = false --para saber, en caso de que ya estuviese conectado, si tenía conexion de influencia
					
					for j=1 to maskShape.position.controller.count do
					(
						case maskShape.position.controller[j].name of
						(	
							"Zero Pos XYZ":
							(
								if _zeroController != undefined then
								(
									maskShape.position.controller[j].controller = _zeroController
									maskShape.position.controller.setName j "Zero Pos XYZ"
								)
							)
							
							"Influence":
							(
								if _influenceController != undefined then
								(
									maskShape.position.controller[j].controller = _influenceController
									maskShape.position.controller.setName j "Influence"
									_influenceFound = true
								)
							)
						)--case						
					)--for
					
					if not _influenceFound and _influenceController != undefined then
					(
						maskShape.position.controller.available.controller = _influenceController
						maskShape.position.controller.setName (maskShape.position.controller.count) "Influence"
					)
				)--if				
				------------------------------------------------------------------------------------------------
				
				------------------------------------------------------------------------------------------------
				--instanciación de la rotacion
				_zeroController = undefined
				_influenceController = undefined
				
				_faceShape = parent.rollMain.faceShapeControls[i]
				if classof _faceShape.rotation.controller == rotation_list then
				(
					for j=1 to _faceShape.rotation.controller.count do
					(
						case (_faceShape.rotation.controller[j].name) of
						(	
							"Zero Euler XYZ": _zeroController = _faceShape.rotation.controller[j].controller
							"Influence": _influenceController = _faceShape.rotation.controller[j].controller
						)--case
					)--for			
				)--if
				
				if classof maskShape.rotation.controller == rotation_list then
				(
					_influenceFound = false --para saber, en caso de que ya estuviese conectado, si tenía conexion de influencia
					
					for j=1 to maskShape.rotation.controller.count do
					(
						case maskShape.rotation.controller[j].name of
						(	
							"Zero Euler XYZ":
							(
								if _zeroController != undefined then
								(
									maskShape.rotation.controller[j].controller = _zeroController
									maskShape.rotation.controller.setName j "Zero Euler XYZ"
								)
							)
							
							"Influence":
							(
								if _influenceController != undefined then
								(
									maskShape.rotation.controller[j].controller = _influenceController
									maskShape.rotation.controller.setName j "Influence"
									_influenceFound = true
								)
							)
						)--case						
					)--for
					
					if not _influenceFound and _influenceController != undefined then
					(
						maskShape.rotation.controller.available.controller = _influenceController
						maskShape.rotation.controller.setName (maskShape.rotation.controller.count) "Influence"
					)
				)--if				
				------------------------------------------------------------------------------------------------
				
				------------------------------------------------------------------------------------------------
				--instanciación de la escala
				_zeroController = undefined
				_influenceController = undefined
				
				_faceShape = parent.rollMain.faceShapeControls[i]
				if classof _faceShape.scale.controller == scale_list then
				(
					for j=1 to _faceShape.scale.controller.count do
					(
						case (_faceShape.scale.controller[j].name) of
						(	
							"Zero Scale XYZ": _zeroController = _faceShape.scale.controller[j].controller
							"Influence": _influenceController = _faceShape.scale.controller[j].controller
						)--case
					)--for			
				)--if
				
				if classof maskShape.scale.controller == scale_list then
				(
					_influenceFound = false --para saber, en caso de que ya estuviese conectado, si tenía conexion de influencia
					
					for j=1 to maskShape.scale.controller.count do
					(
						case maskShape.scale.controller[j].name of
						(	
							"Zero Scale XYZ":
							(
								if _zeroController != undefined then
								(
									maskShape.scale.controller[j].controller = _zeroController
									maskShape.scale.controller.setName j "Zero Scale XYZ"
								)
							)
							
							"Influence":
							(
								if _influenceController != undefined then
								(
									maskShape.scale.controller[j].controller = _influenceController
									maskShape.scale.controller.setName j "Influence"
									_influenceFound = true
								)
							)
						)--case						
					)--for
					
					if not _influenceFound and _influenceController != undefined then
					(
						maskShape.scale.controller.available.controller = _influenceController
						maskShape.scale.controller.setName (maskShape.scale.controller.count) "Influence"
					)
				)--if				
				------------------------------------------------------------------------------------------------
				
				maskConnection[i] ="v"
				updateRowsColor i false
				updateShapeValues i
				
				pbConnection.value = (k*100)/(_indexes.count)
			)--for
			
			pbConnection.value = 0
		)

		------------------------------------------------
		--@fn: undefined | unconnectMaskWithFaceShapes | desconecta la mascara de animacion de los controles de animacion facial de la cara
		------------------------------------------------
		fn unconnectMaskWithFaceShapes =
		(
			_indexes = #() --array de indices a conectar
			
			if rdoConnection.state == 1 then
			(
				_indexes = for i=1 to maskShapes.count collect i
			)
			else if rdoConnection.state == 2 then
			(
				selList = parent.rollMain.lvSelListItems
				for j = 1 to selList.count do
					if maskShapesName[selList.item[j-1].index + 1] != "- empty -" and maskShapesName[selList.item[j-1].index + 1] != "- not found -" then
						appendifunique _indexes (selList.item[j-1].index + 1)
			)
			
			--recorre los shapes de la mascara conectandolos con los de la cara
			for k=1 to _indexes.count where maskShapes[(_indexes[k])] != undefined do
			(
				i = _indexes[k]
				maskShape = maskShapes[(_indexes[k])]
				
				------------------------------------------------------------------------------------------------
				--desconexion de posicion
				if classof maskShape.position.controller == position_list then
				(
					_influenceControllerIndex = -1
					
					for j=1 to maskShape.position.controller.count do
					(
						case (maskShape.position.controller[j].name) of
						(	
							"Zero Pos XYZ":
							(
								maskShape.position.controller[j].controller = copy maskShape.position.controller[j].controller
								maskShape.position.controller.setName j "Zero Pos XYZ"
							)
							
							"Influence": _influenceControllerIndex = j
						)--case
					)--for
					
					if _influenceControllerIndex > 0 then
						maskShape.position.controller.delete _influenceControllerIndex
				)
				------------------------------------------------------------------------------------------------
				
				------------------------------------------------------------------------------------------------
				--desconexion de rotacion
				if classof maskShape.rotation.controller == rotation_list then
				(
					_influenceControllerIndex = -1
					
					for j=1 to maskShape.rotation.controller.count do
					(
						case (maskShape.rotation.controller[j].name) of
						(	
							"Zero Euler XYZ":
							(
								maskShape.rotation.controller[j].controller = copy maskShape.rotation.controller[j].controller
								maskShape.rotation.controller.setName j "Zero Euler XYZ"
							)
							
							"Influence": _influenceControllerIndex = j
						)--case
					)--for
					
					if _influenceControllerIndex > 0 then
						maskShape.rotation.controller.delete _influenceControllerIndex
				)
				------------------------------------------------------------------------------------------------
				
				------------------------------------------------------------------------------------------------
				--desconexion de escala
				if classof maskShape.scale.controller == scale_list then
				(
					_influenceControllerIndex = -1
					
					for j=1 to maskShape.scale.controller.count do
					(
						case (maskShape.scale.controller[j].name) of
						(	
							"Zero Scale XYZ":
							(
								maskShape.scale.controller[j].controller = copy maskShape.scale.controller[j].controller
								maskShape.scale.controller.setName j "Zero Scale XYZ"
							)
							
							"Influence": _influenceControllerIndex = j
						)--case
					)--for
					
					if _influenceControllerIndex > 0 then
						maskShape.scale.controller.delete _influenceControllerIndex
				)
				------------------------------------------------------------------------------------------------
				
				maskConnection[i] ="x"
				updateRowsColor i false
				updateShapeValues i
				
				pbConnection.value = (k*100)/_indexes.count
			)--for
			
			pbConnection.value = 0
		)

		------------------------------------------------
		--COMMON
		------------------------------------------------

		------------------------------------------------
		--@event: pressed | carga la informacion de la conexion entre la mascara  y los canales de morpher
		------------------------------------------------
		on btnLoad pressed do
		(
			--obtiene el path inicial donde buscar el archivo
			_ast = (lb.asset.getSceneAssets())[1]
			
			_astFolder = _ast.folder + @"rig\"
								
			--carpeta de donde coger los archivos
			_file = getOpenFileName caption:"Load connections Info" filename:_astFolder
				
			--almacena el path usado para usarlo en el futuro
			if _file != undefined then
			(
-- 				_filename = undefined
-- 				
-- 				if _folder != undefined then --si tiene un path definido
-- 					_filename = _folder + "\\" + parent.rollMain.morphObj.name + ".conn"
				
				setWaitCursor()
				
				if _file != undefined then
					loadConnections _file overwrite:chkDelConnections.checked
				
				setArrowCursor()						
			)
			else
				lb.message.show "Morhper connection don´t loaded" type:#message pos:undefined size:[300,75] modal:true
		)

		------------------------------------------------
		--@event: pressed | guarda la informacion de la conexion entre la mascara  y los canales de morpher
		------------------------------------------------		
		on btnSave pressed do
		(
			
			--obtiene el path inicial donde buscar el archivo
			_ast = (lb.asset.getSceneAssets())[1]
			
			_astFolder = _ast.folder + "rig\\"
			_fileName = (parent.rollMain.morphObj.nodeInfo.nameHistory[parent.rollMain.morphObj.nodeInfo.nameHistory.count] + ".conn")

			_file = getSaveFileName caption:"Save Connections Info" fileName: (_astFolder + _fileName) --obtiene el nuevo path
			
			if _file != undefined then
			(
				lastPath = folder
				
				setWaitCursor()
				
				saveConnections _file
					
				setArrowCursor()
			)		
		)

		------------------------------------------------
		--@event: MouseDown | detecta si se pulsa algun boton del raton sobre el listview
		------------------------------------------------		
		on lvMaskList MouseDown events do
		(
			parent.rollMain.deleteModChangeHandler() --destruye el handler
			
			parent.rollMain.lvSelListItemsOld = parent.rollMain.lvSelListItems
			
			--guarda la seleccion actual para deseleccionarla y cambiar los colores de la misma
			selChannels = #()
			for i = 1 to parent.rollMain.lvSelListItems.count do
				appendifunique selChannels (parent.rollMain.lvSelListItems.item[i-1].index + 1)
			sort selChannels
			
			btn = events.button.toString() --almacena que boton se ha pulsado
			item = (lvMaskList.getItemAt 5 events.y) --almacena el item sobre el que se ha pulsado
						
			if btn == "Left" then --si es el boton izquierdo
			(	
				leftDragging = true --activa el flag de leftdragging
			)

			if item != undefined then
			(
				(parent.rollMain.selStartIndex = item.index; parent.rollMain.selEndIndex = item.index)  --inicializa los indices de seleccion
				
				--lvSelectRange parent.rollMain.selStartIndex parent.rollMain.selEndIndex
				--parent.rollMain.lvSelectRange parent.rollMain.selStartIndex parent.rollMain.selEndIndex
			)
		
			--actualizacion de los colores de los lisviews
			
			if item != undefined then
			(
				(parent.rollMain.selStartIndex = item.index; parent.rollMain.selEndIndex = item.index)  --inicializa los indices de seleccion
				parent.rollMain.lvSelectRange parent.rollMain.selStartIndex parent.rollMain.selEndIndex
				lvSelectRange parent.rollMain.selStartIndex parent.rollMain.selEndIndex
				parent.rollMain.updateRowsColor parent.rollMain.lvMorphList (item.index +1) false
				
				--Actualiza los valores del shape seleccionado
				updateShapeValues (item.index + 1)
				--Actualiza los valores de Channel Settings segun el canal seleccionado
				if parent.rollMain.ckbMorphMode.checked then parent.rollMain.SelChannel (item.index + 1)
				parent.rollMain.indexSelected = (item.index + 1)
				if parent.rollMain.ckbMorphMode.checked then parent.rollMain.updateChannelSettings (item.index + 1)
			)
			
			for i=1 to selChannels.count do
			(
				parent.rollMain.updateRowsColor parent.rollMain.lvMorphList selChannels[i] true
				updateRowsColor selChannels[i] false
			)

			-----------------------------------------------------
			
			getLvSelectedListItems() --actualiza la seleccion
		)--on lvMorphList
		
		------------------------------------------------
		--@event: MouseUp | detecta si se suelta algun boton del raton sobre el listview
		------------------------------------------------
		on lvMaskList MouseUp events do
		(
			btn = events.button.toString()
			item = (lvMaskList.getItemAt 5 events.y)
			updateIndex = parent.rollMain.selStartIndex
			
			if btn == "Middle" then
			(
				--lvSelectRange item.Index item.Index
				dragged = false
			)
			
			if item != undefined then
			(
				if not dragged and btn == "Left" then
				(
					parent.rollMain.lvSelectRange item.Index item.Index
					updateIndex = item.Index
				)				
							
				if leftDragging then --si se esta haciendo leftdragging
				(
					leftDragging = false --desactiva el flag de leftdragging
					updateIndex = item.Index
				)
			)
			
			dragged = false
			
			getLvSelectedListItems() --actualiza la seleccion
			
			--seleccionar el canal de morpher correspondiente al item del listview seleccionado
			--if btn == "Left" then
				if item != undefined then
				(
					if parent.rollMain.ckbMorphMode.checked then parent.rollMain.SelChannel (updateIndex + 1)
					parent.rollMain.indexSelected = (updateIndex + 1)
					--Actualiza los valores de Channel Settings segun el canal seleccionado
					if parent.rollMain.ckbMorphMode.checked then parent.rollMain.updateChannelSettings (updateIndex + 1)
					updateShapeValues (updateIndex + 1)
				)
				else
				(
					lvMaskList.items.item[parent.rollMain.indexSelected-1].selected = true
					parent.rollMain.lvSelectRange (parent.rollMain.indexSelected-1) (parent.rollMain.indexSelected-1)
				)
			
			--actualizacion de los colores de los lisviews
			
			selChannels = #()
			for i = 1 to parent.rollMain.lvSelListItems.count do
				appendifunique selChannels (parent.rollMain.lvSelListItems.item[i-1].index + 1)
			sort selChannels
				
			for i=1 to selChannels.count do
				parent.rollMain.updateRowsColor parent.rollMain.lvMorphList selChannels[i] false
			
			-----------------------------------------------------	
			
			parent.rollMain.createModChangeHandler() --crea el handler
		)--on lvMorphList

		------------------------------------------------
		--@event: MouseMove | detecta si el cursor del raton se esta moviendo
		------------------------------------------------
		on lvMaskList MouseMove events do
		(
			if leftDragging then --si se esta haciendo leftdragging
			(
				item = (lvMaskList.getItemAt 5 events.y) --almacena el elemento del listview sobre el que se encuentra el cursor
				--actualiza los limites de seleccion y selecciona el rango
				if item != undefined and parent.rollMain.selEndIndex != item.index then
				(
					parent.rollMain.selEndIndex = item.index
					lvSelectRange parent.rollMain.selStartIndex parent.rollMain.selEndIndex
					parent.rollMain.lvSelectRange parent.rollMain.selStartIndex parent.rollMain.selEndIndex
					dragged = true
				)
			)		
		)--on lvMorphList

		------------------------------------------------
		--@event: MouseWheel | detecta si se esta moviendo por la lista con la rueda del raton
		------------------------------------------------	
		on lvMaskList MouseWheel events do
		(
			if parent.rollMain.ckbMorphMode.checked then
			(
				parent.rollMain.deleteModChangeHandler()
			
				_endLimit = 100
				if parent.rollMain.ckbBonesMode.checked then _endLimit = parent.rollMain.lvMorphList.items.count
				
				--calcula el primer y ultimo elemento visible
				if events.delta < 0 then
				(
					parent.rollMain.initIndex += 3
					parent.rollMain.endIndex += 3
					
					if parent.rollMain.endIndex > _endLimit then
					(
						parent.rollMain.endIndex = (_endLimit + 1)
						parent.rollMain.initIndex = parent.rollMain.endIndex - parent.rollMain.visibleItems + 1
					)
				)
				else
				(
					parent.rollMain.initIndex -= 3
					parent.rollMain.endIndex -= 3
					
					if parent.rollMain.initIndex < 1 then
					(
						parent.rollMain.initIndex = 1
						parent.rollMain.endIndex = parent.rollMain.initIndex + parent.rollMain.visibleItems - 1
					)
				)
				------------------------------------------------
			
				parent.rollMain.lvMorphList.ensurevisible (if (parent.rollMain.initIndex-2) < 0 then 0 else (parent.rollMain.initIndex-2))
				parent.rollMain.lvMorphList.ensurevisible (parent.rollMain.endIndex-2)
								
				parent.rollMain.createModChangeHandler()
			)	
		)

		------------------------------------------------
		--@event: GotFocus | detecta si el listview ha perdido el foco
		------------------------------------------------		
		on lvMaskList GotFocus events do
		(
			if parent.rollMain.ckbMorphMode.checked then
			(
				_limit = 100
				if classof parent.rollMain.morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels parent.rollMain.morphMod
				for i=1 to _limit do
				(
					updateRowsColor i true
					parent.rollMain.updateRowsColor parent.rollMain.lvMorphList i false
				)
			)
			else if parent.rollMain.ckbBonesMode.checked then 
			(
				for i=1 to parent.rollMain.lvMorphList.items.count do
				(
					updateRowsColor i true
					parent.rollMain.updateRowsColor parent.rollMain.lvMorphList i false
				)
			)
		)

		------------------------------------------------
		--@event: LostFocus | detecta si el listview ha perdido el foco
		------------------------------------------------		
		on lvMaskList LostFocus events do
		(
			if parent.rollMain.ckbMorphMode.checked then
			(
				_limit = 100
				if classof parent.rollMain.morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels parent.rollMain.morphMod
				for i=1 to _limit do
				(
					updateRowsColor i false
					parent.rollMain.updateRowsColor parent.rollMain.lvMorphList i false
				)
			)
			else if parent.rollMain.ckbBonesMode.checked then 
			(
				for i=1 to parent.rollMain.lvMorphList.items.count do
				(
					updateRowsColor i false
					parent.rollMain.updateRowsColor parent.rollMain.lvMorphList i false
				)
			)
		)

		------------------------------------------------
		--@event: changed | actualiza el multipicador
		------------------------------------------------
		on spnMultiplier changed value do
		(
			i = parent.rollMain.indexSelected
			maskMultipliers[i] = value
			updateShapeValues i
			
			--si ha habido cambios deja el canal pendiente de actualizar
			if maskConnection[i] == "v" then
			(
				maskConnection[i] = "u"
				updateRowsColor i false
			)
		)

		------------------------------------------------
		--@event: changed | actualiza el offset
		------------------------------------------------
		on spnOffset changed value do
		(
			i = parent.rollMain.indexSelected
			maskOffsets[i] = value
			updateShapeValues i
			
			--si ha habido cambios deja el canal pendiente de actualizar
			if maskConnection[i] == "v" then
			(
				maskConnection[i] = "u"
				updateRowsColor i false
			)
		)

		------------------------------------------------
		--@event: changed | actualiza el signo1
		------------------------------------------------
		on spnSign1 changed value do
		(
			i = parent.rollMain.indexSelected
			
			if value == 0 then spnSign1.value = -1
			
			maskSignExpr1[i] = spnSign1.value as integer
			
			--si ha habido cambios deja el canal pendiente de actualizar
			if maskConnection[i] == "v" then
			(
				maskConnection[i] = "u"
				updateRowsColor i false
			)
		)

		------------------------------------------------
		--@event: changed | actualiza el signo2
		------------------------------------------------
		on spnSign2 changed value do
		(
			i = parent.rollMain.indexSelected
			
			if value == 0 then spnSign2.value = -1
			
			maskSignExpr2[i] = spnSign2.value as integer
			
			--si ha habido cambios deja el canal pendiente de actualizar
			if maskConnection[i] == "v" then
			(
				maskConnection[i] = "u"
				updateRowsColor i false
			)
		)

		------------------------------------------------
		--@event: changed | actualiza el signo3
		------------------------------------------------
		--actualiza el signo3
		on spnSign3 changed value do
		(
			i = parent.rollMain.indexSelected
			
			if value == 0 then spnSign3.value = -1
			
			maskSignExpr3[i] = spnSign3.value as integer
			
			--si ha habido cambios deja el canal pendiente de actualizar
			if maskConnection[i] == "v" then
			(
				maskConnection[i] = "u"
				updateRowsColor i false
			)
		)

		------------------------------------------------
		--@event: changed | actualiza el controlador
		------------------------------------------------		
		on rdoController changed state do
		(
			i = parent.rollMain.indexSelected
			maskController[i][1] = state
			
			--si ha habido cambios deja el canal pendiente de actualizar
			if maskConnection[i] == "v" then
			(
				maskConnection[i] = "u"
				updateRowsColor i false
			)
		)

		------------------------------------------------
		--@event: changed | actualiza el axis
		------------------------------------------------		
		on rdoAxis changed state do
		(
			i = parent.rollMain.indexSelected
			maskController[i][2] = state
			
			--si ha habido cambios deja el canal pendiente de actualizar
			if maskConnection[i] == "v" then
			(
				maskConnection[i] = "u"
				updateRowsColor i false
			)
		)

		------------------------------------------------
		--@event: pressed | desconecta los shapes de los canales de morpher
		------------------------------------------------				
		on btnDisConnect pressed do
		(
			if parent.rollMain.ckbMorphMode.checked then --modo morpher
			(				
				i = parent.rollMain.indexSelected
				
				positions = #() --array para almacenar las posiciones de los canales a desconectar
				
				if rdoConnection.state == 1 then --caso para todos los canales
				(
					_limit = 100
					if classof parent.rollMain.morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels parent.rollMain.morphMod
					for j = 1 to _limit do
						if maskShapesName[j][1] != "- empty -" and maskShapesName[j][1] != "- Not found -" then
							append positions j
				)
				else --caso para los canales seleccionados
				(
					selList = parent.rollMain.lvSelListItems
					for j = 1 to selList.count do
						if maskShapesName[selList.item[j-1].index + 1][1] != "- empty -" and maskShapesName[selList.item[j-1].index + 1][1] != "- not found -" then
							appendifunique positions (selList.item[j-1].index + 1)
				)
				
				setWaitCursor()
				
				--deconecta los canales poniendo un controlador nuevo Bezier_Float
				for j=1 to positions.count do
				(
					if maskConnection[positions[j]] != "x" then
					(
						case classof parent.rollMain.morphMod of
						(
							morpher: parent.rollMain.morphMod[positions[j]].controller = Bezier_Float()
							Morph_O_Matic: parent.rollMain.morphMod[positions[j]][2].controller = Bezier_Float()
						)
						
						maskConnection[positions[j]] = "x"
						updateRowsColor positions[j] false
					)
				)
				
				setArrowCursor()
			)
			else if parent.rollMain.ckbBonesMode.checked then --modo huesos
			(
				max create mode
				unconnectMaskWithFaceShapes()
			)
		)

		------------------------------------------------
		--@event: pressed | conecta los shapes a los canales de morpher
		------------------------------------------------
		on btnConnect pressed do
		(
			if parent.rollMain.ckbMorphMode.checked then --modo morpher
			(
				i = parent.rollMain.indexSelected

				positions = #() --array para almacenar las posiciones de los canales a desconectar
				
				if rdoConnection.state == 1 then --caso para todos los canales
				(
					_limit = 100
					if classof parent.rollMain.morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels parent.rollMain.morphMod
					for j = 1 to _limit do
						if maskShapesName[j][1] != "- empty -" and maskShapesName[j][1] != "- not found -" then
							append positions j
				)
				else --caso para los canales seleccionados
				(
					selList = parent.rollMain.lvSelListItems
					for j = 1 to selList.count do
						if maskShapesName[selList.item[j-1].index + 1][1] != "- empty -" and maskShapesName[selList.item[j-1].index + 1][1] != "- not found -" then
							appendifunique positions (selList.item[j-1].index + 1)
						
				)
				
				setWaitCursor()
				
				pbConnection.value = 0
				
				--conecxion
				for j=1 to positions.count do
				(
					connectShapeMorph positions[j] --conecta cada shape/s con el canal de morph
					pbConnection.value = (j*100)/positions.count
				)
				
				pbConnection.value = 0
			
				setArrowCursor()
				
				updateShapeValues i
				
				for j=1 to positions.count do
					updateRowsColor positions[j] false
			)
			else if parent.rollMain.ckbBonesMode.checked then --modo huesos
			(
				max create mode
				connectMaskWithFaceShapes()
			)			
		)
				
		------------------------------------------------
		--@event: picked | cambia el shape parcial
		------------------------------------------------		
		on pckPartialShape picked obj do
		(
			changeShape obj
		)

		------------------------------------------------
		--@event: picked | cambia el shape parcial
		------------------------------------------------		
		on pckFullShape picked obj do
		(
			changeShape obj pos:2
		)

		------------------------------------------------
		--@event: moved | mueve los rollouts al mismo tiempo
		------------------------------------------------				
		on rollMaskConnectionDef moved pos do
		(
			SetDialogPos parent.rollMain [((getDialogPos rollMaskConnectionDef).x + ((parent.rollMain.width) + 8)),(getDialogPos rollMaskConnectionDef).y]
		)--on parent.rollMain

		------------------------------------------------
		--@event: pressed | ejecucion al presionar el boton de cerrar
		------------------------------------------------			
		on btnClose pressed do
		(
			parent.rollMain.rollMaskConnectionOpen = false
			parent.rollMain.chkbtnMaskConnection.checked = false
			destroyDialog rollMaskConnectionDef
		)--on btnClose

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
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMaskConnectionDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMaskConnectionDef.height = size.y)
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
				lvMaskList.height = 530 + _increment.y
				btnClose.pos.y = 565 + _increment.y

				parent.rollMain.height = parent.rollMaskConnection.height + 3
			)--if
		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("tool/rollMaskConnection/pos") "x" (((getDialogPos rollMaskConnectionDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollMaskConnection/pos") "y" (((getDialogPos rollMaskConnectionDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("tool/rollMaskConnection/size") "width" (rollMaskConnectionDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollMaskConnection/size") "height" (rollMaskConnectionDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("tool/rollMaskConnection/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("tool/rollMaskConnection/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("tool/rollMaskConnection/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("tool/rollMaskConnection/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMaskConnectionDef.width = _width
			rollMaskConnectionDef.height = _height
			setDialogPos rollMaskConnectionDef [_posX,_posY]
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
		on rollMaskConnectionDef resized size do
		(	
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMaskConnectionDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
			initTXTs()
			initListView lvMaskList
			fillMaskListView()
			
			lvSelectRange (parent.rollMain.indexSelected-1) (parent.rollMain.indexSelected-1)
			updateShapeValues (parent.rollMain.indexSelected)
			
			if parent.rollMain.ckbMorphMode.checked then
			(
				_limit = 100
				if classof parent.rollMain.morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels parent.rollMain.morphMod
				for i=1 to _limit do updateRowsColor i false
			)
			else if parent.rollMain.ckbBonesMode.checked then
			(
				for i=1 to parent.rollMain.faceShapeControls.count do updateRowsColor i false
				deactivateUIcontrols()
			)			
			if parent.rollMain != undefined then resize [parent.rollMain.width, parent.rollMain.height]
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMaskConnectionDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()

			parent.rollMain.rollMaskConnectionOpen = false
			parent.rollMain.chkbtnMaskConnection.checked = false
			parent.rollMain.buttonsEnableDisable()
			
			parent.rollMain.ckbMorphMode.enabled = true
			parent.rollMain.ckbBonesMode.enabled = true
			parent.rollMain.btnPickObject.enabled = true
			parent.rollMain.btnGetTargets.enabled = true
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMaskConnection
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta morpherManager.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Morpher manager: Monkey Face"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 400		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 600		--@var: minRollHeight | Alto mínimo de la herramienta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		local rollMaskConnectionOpen = false --flag para saber si el rollout de conexion de caretas esta abierto
		
		local dialogHeight = 415		-- altura del interface
		
		local morphMod = undefined		--	modificador Morph que se está tratando
		local morphObj = undefined		--	objeto al que pertenece el Morph que se está tratando
		local oMorphObj = undefined		--	objeto auxiliar que almacena el morph progresivo sin modificaciones
		local lvSelListItems = undefined		--	Selección del listado
		local lvSelListItemsOld = undefined		--	Selección del listado
		
		local modifierCH = undefined --almacena un callback para ver si hay cambios en el modificador Morpher
		
		local iconpath = if (maxVersion())[1] >= 15000 then (getDir #maxRoot) + "UI_ln\\Icons\\" else (getDir #ui) + "/icons/"		-- ruta de los iconos de Max.
		
		local rolloutOpen = false
				
		local dragCoords = #()	-- indica las coordenadas en las que hemos hecho click sobre el listado
		local dragValue = 0		-- valor inicial del dragging al hacer click and drag con el MMB
		local indexSelected = 0 -- valor del indice del canal seleccionado
		local targetSelected = 1 -- valor del indice del canal seleccionado
		local selStartIndex = 0		-- Selección por click y arrastre: inicio selección
		local selEndIndex = 0		-- Selección por click y arrastre: fin selección		
		local lvSelectedListItems = #()	-- Índices de los objetos seleccionados en el list view
		local lvSelectedListItemsOld = #()	-- Índices de los objetos anteriormente seleccionados en el list view
		
		local initialValues = #() --valores iniciales de cada canal de morph
		
		local cursor = dotNetClass "Windows.Forms.Cursor" -- almacena el cursor para poder moverlo libremente

		local midDragging = false --flag para saber si estamos haciendo drag con el boton central del raton
		local leftDragging = false --flag para saber si estamos haciendo drag con el boton izquierdo del raton
		local dragged = false --flag para saber si se acaba de hacer drag con algun boton
		
		local keyBuffer = ""		-- buffer de texto insertado por teclado al editar el valor de una pista
		
		local oldValues 		= #()		-- array de valores antes de empezar a hacer click and drag
		local oldValues 		= #()		-- array de los nuevos valores al terminar de hacer click and drag
		local changingItems = #()		-- array de elementos del listado que están cambiando
		
		local pendingChanges = false		-- indica si hay que actualizar el listado por cambios que vengan de fuera.
		
		local mNodes = undefined --array auxiliar con los nodos que se tienen que reconectar
		local extractedMorphs = #() --array auxiliar con los nodos que se extraen y autoreconectan antes de borrar uno
		
		local ncBackColor = (dotNetClass "System.Drawing.Color").Silver  --color del fondo del listview
		local ncForeColor = (dotNetClass "System.Drawing.Color").Black  --color de delante del listview
		local ncConnectColor = (dotNetClass "System.Drawing.Color").fromargb 7 233 82  --color de los shapes conectados
		local ncUnconnectColor = (dotNetClass "System.Drawing.Color").fromargb 242 62 7  --color de los shapes desconectados		
		
		local ncNcOKfailColor = (dotNetClass "System.Drawing.Color").fromargb 255 100 100  --color del fondo si falla el lb.nc.ncOK 
		local ncTargetExist = (dotNetClass "System.Drawing.Color").fromargb 100 255 100  --color de los canales con target en escena
		local ncTargetNotExist = (dotNetClass "System.Drawing.Color").fromargb 100 100 255  --color de los canales sin target en escena
				
		local oldListviewHeight = 0 --anterior altura del listview
		local visibleItems = 36 --numero de items visibles en el listview
		local initIndex = 1 --indice del primer elemento visible del lisview
		local endIndex = 36 --indice del último elemento visible del lisview
		
		persistent global lastPath = undefined --ultimo path usado para guardar o cargar un fichero
		
		--variables para el modo de conexion mascara-huesos
		local chrNode = undefined		--objeto representativo del personaje para poder saber su nombre.
		local faceShapeControls = #()	--array para almacenar los shapes que manejan los huesos faciales.
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		
		dotNetControl lvMorphList "System.Windows.Forms.ListView" pos:[5,60] width:200 height:530 
		
		checkbutton chkbtnMaskConnection "Mask Connection" pos:[5,5] width:24 height:24 highlightColor:[255,255,0] toolTip:"Mask Connection Rollout" images:#(iconpath+"mergeAnim_24i.bmp",undefined,4,4,4,4,4,true)
		
		label lblWorkMode "Mode:" pos:[35,10] width:47 height:13
		checkbutton ckbMorphMode "Morph" pos:[70,5] width:40 height:24 toolTip:"Morpher working mode" checked:true
		checkbutton ckbBonesMode "Bones" pos:[110,5] width:35 height:24 toolTip:"Bones working mode"
		
		--label lblNumberOfChannelsUsed "Channels:" pos:[334,40] width:47 height:13
		--label lblNumChannels "0" pos:[383,40] width:15 height:13
		label lblNumberOfChannelsUsed "Channels:" pos:[35,43] width:47 height:13
		label lblNumChannels "0" pos:[85,43] width:15 height:13
		
		--label lblMorphObject "Morph object:" pos:[45,13] width:70 height:15
		--pickbutton btnPickObject "<no object defined>" pos:[112,10] width:180 height:20 filter:rollMainDef.pickObjTest autoDisplay:true
		label lblMorphObject "Morph object:" pos:[153,13] width:70 height:15
		pickbutton btnPickObject "<no object defined>" pos:[220,10] width:180 height:20 filter:rollMainDef.pickObjTest autoDisplay:true
		
		--button btnGetTargets "Get Scene Targets" pos:[300,10] width:100 height:20 tooltip:"Get Targets from Scene"

		--checkbutton ckbRelativeAbsolute "Rel" pos:[5,40] width:30 height:20
		--button btnEdit "Edit" pos:[79,40] width:40 height:20
		--button btnZero "Zero" pos:[119,40] width:40 height:20
		--button btnZeroAll "Zero All" pos:[159,40] width:45 height:20
		checkbutton ckbRelativeAbsolute "Rel" pos:[5,40] width:25 height:20
		button btnEdit "Edit" pos:[108,40] width:27 height:20
		button btnZero "Zero" pos:[135,40] width:27 height:20
		button btnZeroAll "Zero All" pos:[162,40] width:42 height:20
		dotNetControl edtValue "System.Windows.Forms.richtextbox" pos:[80,340] width:30 height:10

		groupBox grpSortTracks "Sort tracks" pos:[210,55] width:190 height:70
		button btnMoveUp "Up" pos:[217,70] width:24 height:24 toolTip:"Move Channel Up" images:#(iconpath+"mergeAnim_24i.bmp",undefined,4,1,1,1,1,true)
		button btnMoveDown "Down" pos:[217,96] width:24 height:24 toolTip:"Move Channel Down" images:#(iconpath+"mergeAnim_24i.bmp",undefined,4,2,2,2,2,true)
		label lblMoveTo "Move to" pos:[310,75] width:45 height:15		
		spinner spnTargetChannel "" pos:[355,74] width:40 height:16 range:[1,100,1] type:#integer
		button btnMoveTo "Move" pos:[310,99] width:85 height:20 toolTip:"Move Channel to Specific Position"
		
		--lo ponemos aqui para que se dibuje por encima del sort tracks
		button btnGetTargets "Get Scene Targets" pos:[300,40] width:100 height:20 tooltip:"Get Targets from Scene"
		
		groupBox grpGlobalSettings "Global settings" pos:[209,125] width:191 height:55
		checkbox chkUseLimits "Use Limits" pos:[325,143] width:72 height:15
		checkbox chkRenameTargets "Autorename targets" pos:[214,160] width:120 height:15 checked:false
		checkbox chkReloadTargets "Autoreload targets" pos:[214,143] width:110 height:15 checked:true
		groupBox grpChannelSettings "Channel settings" pos:[209,185] width:190 height:215
		dotNetControl lvChannelList "System.Windows.Forms.ListView" pos:[215,220] width:180 height:76 
		edittext edtChannelName "" pos:[211,205] width:184 height:15 toolTip:"Channel Name" 
		button btnSetNewWeight "New %" pos:[214,302] width:50 height:20 toolTip:"Only works when the target exists on scene"
		spinner spnNewWeight "" pos:[267,304] width:50 height:16 range:[-100000,100000,0] type:#integer
					
		button btnMoveUpT "Up" pos:[344,300] width:24 height:24 toolTip:"Move Progressive Target Up" images:#(iconpath+"mergeAnim_24i.bmp",undefined,4,1,1,1,1,true)
		button btnMoveDownT "Down" pos:[369,300] width:24 height:24 toolTip:"Move Progressive Target Down" images:#(iconpath+"mergeAnim_24i.bmp",undefined,4,2,2,2,2,true)
		checkbox chkUseLimitsP "Use Limits" pos:[219,340] width:72 height:15
		label lblMinimum "Min." pos:[219,361] width:25 height:15		
		spinner spnMinimum "" pos:[244,360] width:55 height:16 enabled:false range:[-100000,100000,0] type:#integer
		label lblMaximum "Max." pos:[219,381] width:25 height:15		
		spinner spnMaximum "" pos:[244,380] width:55 height:16 enabled:false range:[-100000,100000,100] type:#integer
		pickbutton pckAddTarget "Add Target" pos:[320,350] width:75 height:20 toolTip:"Add new target to the channel"
		button btnDeleteTarget "Del. Channel" pos:[320,375] width:75 height:20 toolTip:"Delete all the channel targets"
						
		groupBox grpExtract "Extract Heads" pos:[209,405] width:190 height:55
		radiobuttons rdoSelection "" pos:[219,420] width:65 height:32 labels:#("All", "Selected") columns:1
		checkbox chkAutoreconnect "Autoreconnect" pos:[305,415] width:90 height:15
		button btnExtract "Extract" pos:[305,435] width:90 height:20 toolTip:"Extracts the targets"
		
		--SL = SaveLoad
		groupBox grpSaveLoad "Save/Load" pos:[210,465] width:190 height:95
		checkbox chkSLsettings "Global Settings" pos:[215,510] width:90 height:15 checked:true tooltip:"Save/Load morpher gloabal settings"
		checkbox chkSLchannel "Channel Info" pos:[215,526] width:90 height:15 checked:true tooltip:"Save/Load channels info"
		checkbox chkSLvertexColors "Vertex Colors" pos:[215,542] width:90 height:15 checked:true tooltip:"Save/Load vertex colors"
		radiobuttons rdoSLoptions "" pos:[310,512] width:95 height:48 labels:#("All channels", /*"Sel. geometry", */"Sel. channels") columns:1
		button btnLoad "Load" pos:[215,480] width:25 height:25 images:#(iconpath + "bip_general_i.bmp", undefined, 30, 5, 5, 6, 6,true)
		button btnSave "Save" pos:[245,480] width:25 height:25 images:#(iconpath + "bip_general_i.bmp", undefined, 30, 7, 7, 8, 8,true)
		progressBar pbSaveLoad "" pos:[282,485] width:103 height:15 visible:true
		
		button btnRefresh "Refresh" pos:[210,565] width:90 height:25 toolTip:"Update the tool"
		button btnClose "Close" pos:[310,565] width:90 height:25 toolTip:"Close the tool"
					
		Timer clock "reloj" pos:[44,160] width:24 height:24 interval:250

		
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
		--@fn: undefined | getMorphName | obtiene el nombre del morph sin los prefijos de personaje y tipo de pieza, y sin los sufijos de point cache ni flags si no cumple el naming convention devuelve el nombre pasado tal cual
		------------------------------------------------
		fn getMorphName completeName =
		(
			mName = completeName
			
			if lb.nc.ncOK completeName then
			(
				mParts = filterString completeName "_"
				mName = mParts[4] + "_" + mParts[5]
			)
			
			mName
		)

		------------------------------------------------
		--@fn: undefined | showTextBox | muestra e inicia la caja de texto donde se escriben los valores
		------------------------------------------------
		fn showTextBox =
		(
			-- buscamos un elemento que no sea un separador
			i = lvSelListItems.count
			
			index = undefined
			encontrado = false
			while i >= 1 and not encontrado do
			(
				index = lvSelListItems.item[i-1].index
				case classof morphMod of
				(
					morpher: if (WM3_MC_HasData morphMod index) then encontrado = true
					Morph_O_Matic: encontrado = true
				)--case
				
				i -= 1
			)
			
			if encontrado then
			(
				edtValue.visible = true
				edtValue.text = ""
				setfocus lvMorphList
				
				y = (lvMorphList.getItemRect index).location.y + lvMorphList.pos.y 
				x = lvMorphList.columns.item[0].width + lvMorphList.columns.item[1].width + 3
				borderStyle = (dotNetClass "System.Windows.Forms.BorderStyle").none
				edtValue.borderStyle = borderStyle
				
				edtValue.pos = [x,y]
				edtValue.height = 15
				edtValue.width = lvMorphList.columns.item[2].width - 2
				edtValue.show()
			)
		)

		-----------------------------------------------
		--@fn: undefined | updateEditValues | actualiza los valores del listview que se están editando
		------------------------------------------------
		fn updateEditValues =
		(
			edtValue.text = keyBuffer
			
			case classof morphMod of
			(
				morpher:
				(				
					for i = 1 to lvSelListItems.count where (WM3_MC_HasData morphMod (lvSelListItems.item[i-1].index + 1)) do
						lvSelListItems.item[i-1].subitems.item[2].text = keyBuffer
				)
				
				Morph_O_Matic:
				(
					for i = 1 to lvSelListItems.count do
					(
						_update = false
						_index = (lvSelListItems.item[i-1].index + 1)
						if (MOM_MC_GetNumTargets morphMod[_index]) > 1 then _update = true
						else if (MOM_MC_GetNumTargets morphMod[_index]) == 1 and ((MOM_MC_TARG_GetName morphMod[_index] 1) == "Original") then _update = true
						lvSelListItems.item[i-1].subitems.item[2].text = keyBuffer
					)
				)
			)--case
		)

		-----------------------------------------------
		--@fn: undefined | morphNameParts | devuelve un array con el nombre de un morph separado en sus partes
		------------------------------------------------
		fn morphNameParts morphName =
		(
			nameParts = undefined 
			nameParts = #() -- guarda en un array cada parte del nombre	

			tempName = morphName
		
			mname = filterstring tempName "_" --separa el nombre en dos partes mediante el guion bajo

			if morphName == "x_original" then
				append nameParts morphName			
			else if mname.count == 2 then
			(
				mname2 = filterstring mname[2] "-" --separa la segunda parte en varias mediante el guion
				
				if mname2.count > 3 and mname2.count < 6 then
				(
					append nameParts mname[1]
					append nameParts mname2[1]
					append nameParts mname2[2]
					append nameParts mname2[3]
					append nameParts mname2[4]
					
					if mname2.count > 4 then
						append nameParts mname2[5]					
				)--if2
			)

			nameParts --devuelve el nombre en partes en un array
		)--fn morphNameParts

		-----------------------------------------------
		--@fn: undefined | checkNamingConvention | combrueba que un morph cumple la convencion de nombres para los morph
		------------------------------------------------
		fn checkNamingConvention mName =
		(
			checkResult = false --inicialmente se supone que no cumple la convencion
			
			if ckbMorphMode.checked then				
			(			
				auxParts = filterString morphObj.name "_"
				tempName = getMorphName mName
				nameParts = morphNameParts tempName --obtiene las partes del nombre
				
				if nameParts.count != 0 then
				(
					--se da un valor nuemerico a cada parte para poder compararla
					---------------------------------------------------------------------
					case nameParts[1] of
					(
						"x" :		pos = 1
						"m" :		pos = 2
						"r" :		pos = 3
						"l" :		pos = 4
						default:	pos = -1
					)
					
					part = 1 --de momento aceptamos todos los morphs da igual de la parte que sea
					
			-- 				case nameParts[2] of
			-- 				(
			-- 					--prefijos de cabeza
			-- 					"ebw" :		part = 1
			-- 					"eld" :		part = 2
			-- 					"chb":		part = 3
			-- 					"nose" :		part = 4
			-- 					"lip" : 		part = 5
			-- 					"lipsync" :	part = 6
			-- 					"jaw" :		part = 7
			-- 					"eye":		part = 8
			-- 					
			-- 					--prefijo de lengua
			-- 					"tongue":	part = 9
			-- 					
			-- 					--prefijo de pelo
			-- 					"hair":		part = 10
			-- 					
			-- 					--prefijos del FFD
			-- 					"ffdskl":		part = 11
			-- 					"ffdjaw":		part = 12
			-- 					
			-- 					default:		part = -1
			-- 				)
					
					case nameParts[3] of
					(
						"all" :				partPos = 1
						"int" :				partPos = 2
						"mid" :			partPos = 3
						"mid1" :			partPos = 4
						"mid2" :			partPos = 5
						"mid3" :			partPos = 6
						"ext" : 			partPos = 7
						"upperAll" :		partPos = 8
						"upper" :			partPos = 9
						"upperInt" :		partPos = 10
						"upperMid" :	partPos = 11
						"upperMid1" :	partPos = 12
						"upperMid2" :	partPos = 13
						"upperMid3" :	partPos = 14
						"upperExt" :	partPos = 15
						"lowerAll" :		partPos = 16
						"lower" :			partPos = 17
						"lowerInt" :		partPos = 18
						"lowerMid" :		partPos = 19
						"lowerMid1" :	partPos = 20
						"lowerMid2" :	partPos = 21
						"lowerMid3" :	partPos = 22
						"lowerExt" :		partPos = 23
						"side" :		partPos = 24
						"sideInt" :		partPos = 25
						"sideExt" :		partPos = 26
						"tip":				partPos = 27 --parte de la punta de la lengua
						"hair":			partPos = 28
						"smooth":		partPos = 29
						"fix":				partPos = 30
						"adjust":			partPos = 31
						default:			partPos = 32
						default:			partPos = -1
					)
					
					case nameParts[4] of
					(
						"x" :			dir = 1
						"hz" :			dir = 2
						"vt" :			dir = 3
						"open":		dir = 4
						"stretch" :	dir = 5
						"bend" :		dir = 6
						"snout" :		dir = 7
						"inflate" :	dir = 8
						"a" :			dir = 9
						"o" :			dir = 10
						"f" :			dir = 11
						"twist":		dir = 12 --gesto de torsion de lengua
						"rot":			dir = 13 --gesto de rotacion
						"scale":		dir = 14
						"break":		dir = 15
						default:	dir = -1
					)
					
					nameParts[5] = (filterstring nameParts[5] "()")[1]
					case nameParts[5] of
					(
						"x" :			constrDir = 1
						"up" :			constrDir = 2
						"dw" :		constrDir = 3
						"r" :			constrDir = 4
						"l" : 			constrDir = 5
						"out" :		constrDir = 6
						"in" :			constrDir = 7	
						"fr":			constrDir = 8
						"bk"	:		constrDir = 9	
						default:		constrDir = -1
					)
					---------------------------------------------------------------------
					
					--comprobar que si el nombre tiene 6 partes, se corresponde con la nomenclatura de un progresivo
					progressive = 1
					if nameParts[6] != undefined then
						if nameParts[6][1] != "p" then progressive = -1
					
					--Chequeo para saber si cumple la convencion
					if (pos>0 and part>0 and partPos>0 and dir>0 and constrDir>0 and progressive>0) or (mName == "- empty -") or (tempName == "x_original") then
						checkResult = true
					-------------------------------------------------
				)
			)
			else if ckbBonesMode.checked then
			(
				checkResult = true
			)
			
			checkResult --devuelve el resultado del Chequeo
		)--fn checkNamingConvention

		-----------------------------------------------
		--@fn: undefined | getFaceShapeControls | obtiene los controles animables de la cara
		------------------------------------------------
		fn getFaceShapeControls =
		(
			_faceShapesPattern = "_facial_?_*-shp_x_ce"
			_chrName = (filterString chrNode.name "_")[1] + "_" + (filterString chrNode.name "_")[2]
			_completePattern = "$'" + _chrName + _faceShapesPattern + "'"
			
			_faceShapeControls = (execute _completePattern) as array
			
			_faceShapeControls
		)--fn getFaceShapeControls

		-----------------------------------------------
		--@fn: undefined | updateRowsColor | cambia el color de las filas en funcion de si el listview esta en focus o no
		------------------------------------------------
		fn updateRowsColor lv index listViewFocused =
		(
			if lv.items.count != 0 then
			(
				item = lv.items.item[index-1]
					
				exists = ncBackColor
				num = 0
				
				if ckbMorphMode.checked then
				(
					case (classof morphMod) of
					(
						morpher:
						(
							num = WM3_NumberOfProgressiveMorphs morphMod index
							
							--comprueba que todos los targets del canal existen para poner el color correcto al canal
							if	num != 0 then
							(
								if num == 1 and WM3_MC_HasTarget morphMod index then
								(
									exists = ncTargetExist
								)
								else
								(
									flag = true
									
									for j=1 to num do
									(
										morphAux = WM3_GetProgressiveMorphNode morphMod index j
										if morphAux == undefined then flag = false
									)
									
									if flag then
										exists = ncTargetExist
									else
										exists = ncTargetNotExist
								)
							)--if
						)--morpher
						
						Morph_O_Matic:
						(
							num = MOM_MC_GetNumTargets morphMod[index]
							
							--comprueba que todos los targets del canal existen para poner el color correcto al canal
							if	num != 0 then
							(
								if num == 1 then
								(
									if (MOM_MC_TARG_GetName morphMod[index] 1) == "Original" then exists = ncBackColor
									else if (MOM_MC_TARG_GetNode morphMod[index] 1) != undefined then exists = ncTargetExist
								)
								else
								(
									flag = true
										
									for j=1 to num where (MOM_MC_TARG_GetName morphMod[index] j != "Original") do
									(
										morphAux = MOM_MC_TARG_GetNode morphMod[index] j
										if morphAux == undefined then flag = false
									)
									
									if flag then
										exists = ncTargetExist
									else
										exists = ncTargetNotExist
								)
							)--if
						)--Morph_O_Matic
					)--case
				)--if
				
				if lv != lvChannelList then --asigna el color al canal en fucion de si los targets existen o no
					item.backcolor = exists
				
				--asigna el color al resto de celdas del canal
				if item.selected and not listViewFocused then --caso para cuando el canal esta seleccionado y el foco no esta en el listview
				(
					if item.subitems.item[1].backColor != (dotNetClass "System.Drawing.Color").midnightblue then item.subitems.item[1].backColor = (dotNetClass "System.Drawing.Color").midnightblue
					if item.subitems.item[2].backColor != (dotNetClass "System.Drawing.Color").midnightblue then item.subitems.item[2].backColor = (dotNetClass "System.Drawing.Color").midnightblue
					if item.subitems.item[1].foreColor != (dotNetClass "System.Drawing.Color").white then item.subitems.item[1].foreColor = (dotNetClass "System.Drawing.Color").white
					if item.subitems.item[2].foreColor != (dotNetClass "System.Drawing.Color").white then item.subitems.item[2].foreColor = (dotNetClass "System.Drawing.Color").white
				)
				else --si no esta seleccionado, o tiene el foco
				(
					-- Backcolor: Si el canal cumple el Naming convention le ponemos el fondo por defecto, si no lo marcamos en rojo
					if ((item.subitems.item[1].text != "- empty -") and (item.subitems.item[1].text != "No name")) and not checkNamingConvention (item.subitems.item[1].text) then
					(
						item.subitems.item[1].backColor = ncNcOKfailColor
						item.subitems.item[2].backColor = ncBackColor
					)
					else
					(
						if item.subitems.item[1].backColor != ncBackColor then
						(
							item.subitems.item[1].backColor = ncBackColor
							item.subitems.item[2].backColor = ncBackColor
						)
					)
					
					-- Forecolor: si no tenemos el color por defecto lo restauramos
					if item.subitems.item[1].foreColor != (dotNetClass "System.Drawing.Color").black then
					(
						item.subitems.item[1].foreColor = (dotNetClass "System.Drawing.Color").black
						item.subitems.item[2].foreColor = (dotNetClass "System.Drawing.Color").black
					)
				)
			)		
		)

		-----------------------------------------------
		--@fn: undefined | initListView | Inicia el listView pasado por parámetro
		------------------------------------------------
		fn initListView lv =
		(
			lv.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = ncBackColor
			lv.foreColor = ncForeColor
			lv.scrollable = true
			lv.labelEdit = true
			--lv.hideSelection = false
			lv.labelEdit = false
			
			lv.columns.add "n" (13*lv.width/100)
			lv.columns.add "Channel Name" (58*lv.width/100)
			lv.columns.add "%" (20*lv.width/100)
		)--fn initListView

		-----------------------------------------------
		--@fn: undefined | fillListView | Rellena el listview según el Asset seleccionado
		------------------------------------------------
		fn fillListView =
		(
			lvMorphList.items.clear()
			numChannels = 0
			items = #()
			
			if ckbMorphMode.checked then
			(
				if morphMod != undefined then
				(
					case (classof morphMod) of
					(
						morpher:
						(
							--llena el listview con los canales del morpher
							for i = 1 to 100 do
							(
								mName = (if morphMod[i] == false then "- empty -" else (wm3_mc_getname morphMod i))
								mWeight = (if (WM3_MC_HasData morphMod i) == false then "" else (WM3_MC_GetValue  morphMod i))
								initialValues[i] = 0				
								initialValues[i] = mWeight
									
								row = dotNetObject "System.Windows.Forms.ListViewItem" (i as string)
								
								row.SubItems.add (mName as string)
								row.SubItems.add (mWeight as string)
								
								row.UseItemStyleForSubItems = false --hace que el color de cada celda pueda ser diferente
								
								lvMorphList.items.add row
								
								if morphMod[i].value != undefined then numChannels += 1
							)--for
						)--moprher
						
						Morph_O_Matic:
						(
							_limit = MOM_GetNumChannels morphMod --obtiene el numero de canales
							
							--llena el listview con los canales del morpher
							for i = 1 to _limit do
							(
								_numTargets = MOM_MC_GetNumTargets morphMod[i]
								
								if _numTargets != 0 then
								(
									if _numTargets >= 1 then
									(
										mName = morphMod[i].name
										if _numTargets==1 and ((MOM_MC_TARG_GetName morphMod[i] 1) == "Original")then mName = "- empty -"
										mWeight = morphMod[i][2].controller.value
										initialValues[i] = 0
										initialValues[i] = mWeight
										
										row = dotNetObject "System.Windows.Forms.ListViewItem" (i as string)
										row.SubItems.add (mName as string)
										row.SubItems.add (mWeight as string)
										
										row.UseItemStyleForSubItems = false --hace que el color de cada celda pueda ser diferente
										
										lvMorphList.items.add row
										
										numChannels += 1
									)--if
								)--if
							)--for
						)--Morph_O_Matic
					)
				)
			)
			else if ckbBonesMode.checked then
			(
				if faceShapeControls.count != 0 then
				(
					for i=1 to faceShapeControls.count do
					(
						_shapeName = (filterString faceShapeControls[i].name "_")[4] + "_" + (filterString faceShapeControls[i].name "_")[5]
						
						row = dotNetObject "System.Windows.Forms.ListViewItem" (i as string)
							
						row.SubItems.add (_shapeName as string)
						row.SubItems.add "0"
						
						row.UseItemStyleForSubItems = false --hace que el color de cada celda pueda ser diferente
								
						lvMorphList.items.add row
						
						numChannels += 1
					)--for
				)
			)
			
			--lvMorphList.items.addRange items
			lblNumChannels.caption = numChannels as string			
		)--fn fillListView

		-----------------------------------------------
		--@fn: undefined | updateListView | Actualiza el listview según el Asset seleccionado
		------------------------------------------------
		fn updateListView =
		(
			pendingChanges = true
		)--fn updateListView

		-----------------------------------------------
		--@fn: undefined | initChannelList | Inicia el listView del canal
		------------------------------------------------
		fn initChannelList lv =
		(
			lv.font = dotnetobject "system.drawing.font" (dotnetobject "System.Drawing.FontFamily" "Arial") 7.5
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = ncBackColor
			lv.foreColor = foreColor
			lv.scrollable = true
			lv.labelEdit = true
			--lv.hideSelection = false
			lv.labelEdit = false

			lv.columns.add "" (lv.width/14)
			lv.columns.add "Target" (lv.width/1.3)
			lv.columns.add "%" (lv.width/6)
		)--fn initChannelList

		-----------------------------------------------
		--@fn: undefined | fillChannelList | Llena la lista según el Canal seleccionado
		------------------------------------------------
		fn fillChannelList index =
		(
			if morphMod != undefined then
 			(
				lvChannelList.clear() --limpia la lista
				initChannelList lvChannelList --inicializa la lista de nuevo
				mNames = #() --array para guardar los nombres de los targets
				mWeights = #() --array para guardar los pesos de los targets
				mExistence = #() --array para almacenar si cada target esta en escena o no
				--targetSelected = 0 --indice del target selecionado actualmente
				
				case classof morphMod of
				(
					morpher:
					(
						--si tiene target/s
						if (WM3_MC_HasData morphMod index) then
						(
							
							m = morphMod[index] --se almacena en m el canal que queremos mostrar
							mName = WM3_MC_GetName morphMod index --obtiene el nombre del canal
							mNameParts = morphNameParts mName --separa el nombre en partes
							
							--obtiene el numero de targets del canal
							nProgs = WM3_NumberOfProgressiveMorphs morphMod indexSelected
							
							--obtiene los nombres de los targets y rellena el listview
							for i=1 to nProgs do
							(
								target = WM3_GetProgressiveMorphNode morphMod indexSelected i
								mNames[i] = mName + "_target_" + i as string
								mWeights[i] = "x"
								
								mExistence[i] = "x"
								if target != undefined then
								(
									mExistence[i] = "v"
									mNames[i] = target.name
									mWeights[i] = (WM3_GetProgressiveMorphWeight morphMod index target) as integer
								)
								
								row = dotNetObject "System.Windows.Forms.ListViewItem" ""
								row.UseItemStyleForSubItems = false
								row.SubItems.add (mNames[i] as string)
								row.SubItems.add (mWeights[i] as string)
								lvChannelList.items.add row
								
								if mExistence[i] == "x" then
									lvChannelList.items.item[i-1].backcolor = ncTargetNotExist
								else
									lvChannelList.items.item[i-1].backcolor = ncTargetExist
								
							)--for

							if targetSelected == 0 or targetSelected == undefined then
								targetSelected = 1
							
							lvChannelList.items.item[targetSelected-1].selected = true
							
							for i=1 to lvChannelList.items.count do
								updateRowsColor lvChannelList i false

						)--if hasData
					)--morpher
					
					Morph_O_Matic:
					(
						--si tiene target/s
						if (lvMorphList.items.item[index-1].subitems.item[1].text != "- empty -") then
						(
							m = morphMod[index] --se almacena en m el canal que queremos mostrar
							mName = m.name --obtiene el nombre del canal
							mNameParts = morphNameParts mName --separa el nombre en partes
							
							--obtiene el numero de targets del canal
							nProgs = MOM_MC_GetNumTargets m
							
							--obtiene los nombres de los targets y rellena el listview
							for i=1 to nProgs do
							(
								target = MOM_MC_TARG_GetNode m i
								mNames[i] = MOM_MC_TARG_GetName m i
								mWeights[i] = "x"
								
								mExistence[i] = "x"
								if target != undefined or mNames[i] == "Original" then
								(
									mExistence[i] = "v"
									if mNames[i] != "Original" then mNames[i] = target.name
									mWeights[i] = (MOM_MC_TARG_GetProgressive m i) as integer
								)
								
								row = dotNetObject "System.Windows.Forms.ListViewItem" ""
								row.UseItemStyleForSubItems = false
								row.SubItems.add (mNames[i] as string)
								row.SubItems.add (mWeights[i] as string)
								lvChannelList.items.add row
								
								if mExistence[i] == "x" then
									lvChannelList.items.item[i-1].backcolor = ncTargetNotExist
								else
									lvChannelList.items.item[i-1].backcolor = ncTargetExist
								
							)--for

							if targetSelected == 0 or targetSelected == undefined then
								targetSelected = 1
							
							lvChannelList.items.item[targetSelected-1].selected = true
							
							for i=1 to lvChannelList.items.count do
								updateRowsColor lvChannelList i false

						)--if hasData
					)--Morph_O_Matic
				)--case
				
 				
			)--if morph not undefined		
		)--fn fillChannelList

		-----------------------------------------------
		--@fn: undefined | updateChannelSettings | Actualiza los valores de Channel Settings segun el canal seleccionado
		------------------------------------------------
		fn updateChannelSettings index = 
		(
			if morphMod != undefined then
 			(
			
				fillChannelList index --resetea la lista y la llena de nuevo
				
				--actualiza los controles del interfaz con los valores del canal seleccionado
				case classof morphMod of
				(
					morpher:
					(
						edtChannelName.text = WM3_MC_GetName morphMod index
						chkUseLimitsP.checked = WM3_MC_GetUseLimits morphMod index
						spnMinimum.value = WM3_MC_GetLimitMIN morphMod index
						spnMaximum.value = WM3_MC_GetLimitMAX morphMod index
					)--morpher
					
					Morph_O_Matic:
					(
						edtChannelName.text = morphMod[index].name
						chkUseLimitsP.checked = morphMod[index].useLimits
						spnMinimum.value = morphMod[index].minLimit
						spnMaximum.value = morphMod[index].maxLimit
					)--Morph_O_Matic
				)--case
				
				if lvChannelList.items.count > 0 then
					targetSelected = 1
				
				--actualiza los campos de la herramienta con los nuevos valores
				
				if not chkUseLimits.checked and chkUseLimitsP.checked and not rollMaskConnectionOpen then
				(
					spnMinimum.enabled = true
					spnMaximum.enabled = true				
				)
				else
				(
					spnMinimum.enabled = false
					spnMaximum.enabled = false
				)
				
				_numTargets = 0
				case classof morphMod of
				(
					morpher: _numTargets = WM3_NumberOfProgressiveMorphs morphMod index
					
					Morph_O_Matic:
					(
						_numTargets = MOM_MC_GetNumTargets morphMod[index]
						--for i=_numTargets to 1 by -1 where MOM_MC_TARG_GetName morphMod[index] i == "Original" do _numTargets-=1
					)--Morph_O_Matic
				)--case
				
				if _numTargets > 1 then
				(
					btnSetNewWeight.enabled = true
					spnNewWeight.enabled = true
					btnMoveDownT.enabled = true
					btnMoveUpT.enabled = true
				)
				else
				(
					btnSetNewWeight.enabled = false
					spnNewWeight.enabled = false
					btnMoveDownT.enabled = false
					btnMoveUpT.enabled = false
				)
				
			-- 				spnMinimum.value = WM3_MC_GetLimitMIN morphMod index
			-- 				spnMaximum.value = WM3_MC_GetLimitMAX morphMod index
				
				--updateSetNewWeight()
			)
		)--fn updateChannelSettings

		-----------------------------------------------
		--@fn: undefined | buttonsEnableDisable | habilita/deshabilita los botones de gestion de mophs
		------------------------------------------------
		fn buttonsEnableDisable = 
		(
			if chkbtnMaskConnection.checked then
			(	
				flagEnableDisable = false
				
				lblMorphObject.enabled =		flagEnableDisable
				btnPickObject.enabled =			flagEnableDisable
				btnMoveUp.enabled =				flagEnableDisable
				btnMoveDown.enabled =			flagEnableDisable
				lblMoveTo.enabled =				flagEnableDisable
				spnTargetChannel.enabled =		flagEnableDisable
				btnMoveTo.enabled =				flagEnableDisable
				chkUseLimits.enabled =			flagEnableDisable
				chkReloadTargets.enabled =		flagEnableDisable
				lvChannelList.enabled =			flagEnableDisable
				edtChannelName.enabled =		flagEnableDisable
				lblMinimum.enabled =			flagEnableDisable
				lblMaximum.enabled =			flagEnableDisable
				btnSetNewWeight.enabled =		flagEnableDisable
				spnNewWeight.enabled =			flagEnableDisable
				btnMoveDownT.enabled =			flagEnableDisable
				btnMoveUpT.enabled =			flagEnableDisable
				pckAddTarget.enabled =			flagEnableDisable
				btnDeleteTarget.enabled =		flagEnableDisable
				rdoSelection.enabled =			flagEnableDisable
				chkAutoreconnect.enabled =		flagEnableDisable
				btnExtract.enabled =			flagEnableDisable
				btnRefresh.enabled =			flagEnableDisable
				btnClose.enabled =				flagEnableDisable
				btnGetTargets.enabled =			flagEnableDisable
				btnZero.enabled =				flagEnableDisable
				btnZeroAll.enabled =			flagEnableDisable
				btnEdit.enabled =				flagEnableDisable
				ckbRelativeAbsolute.enabled =	flagEnableDisable
				btnLoad.enabled =				flagEnableDisable
				btnSave.enabled =				flagEnableDisable
				chkSLsettings.enabled =			flagEnableDisable
				chkSLchannel.enabled =			flagEnableDisable
				chkSLvertexColors.enabled =		flagEnableDisable
				rdoSLoptions.enabled =			flagEnableDisable
				chkRenameTargets.enabled = 		flagEnableDisable
				
				ckbMorphMode.enabled =			flagEnableDisable
				ckbBonesMode.enabled =			flagEnableDisable
				
				if not chkUseLimits.checked then
				(
					chkUseLimitsP.enabled = true
					if chkUseLimitsP.checked then
					(
						spnMinimum.enabled = true
						spnMaximum.enabled = true				
					)else(
						spnMinimum.enabled = false
						spnMaximum.enabled = false
					)			
				)
				else
				(
					spnMinimum.enabled = false
					spnMaximum.enabled = false
					chkUseLimitsP.enabled = false
				)
			
				if flagEnableDisable then updateChannelSettings indexSelected			
			)
			else
			(
				flagEnableDisable = if ckbMorphMode.checked then true else if ckbBonesMode.checked then false else false
				
				--lblMorphObject.enabled =		flagEnableDisable
				--btnPickObject.enabled =			flagEnableDisable
				btnMoveUp.enabled =				flagEnableDisable
				btnMoveDown.enabled =			flagEnableDisable
				lblMoveTo.enabled =				flagEnableDisable
				spnTargetChannel.enabled =		flagEnableDisable
				btnMoveTo.enabled =				flagEnableDisable
				chkUseLimits.enabled =			flagEnableDisable
				chkReloadTargets.enabled =		flagEnableDisable
				lvChannelList.enabled =			flagEnableDisable
				edtChannelName.enabled =		flagEnableDisable
				lblMinimum.enabled =			flagEnableDisable
				lblMaximum.enabled =			flagEnableDisable
				btnSetNewWeight.enabled =		flagEnableDisable
				spnNewWeight.enabled =			flagEnableDisable
				btnMoveDownT.enabled =			flagEnableDisable
				btnMoveUpT.enabled =			flagEnableDisable
				pckAddTarget.enabled =			flagEnableDisable
				btnDeleteTarget.enabled =		flagEnableDisable
				rdoSelection.enabled =			flagEnableDisable
				chkAutoreconnect.enabled =		flagEnableDisable
				btnExtract.enabled =			flagEnableDisable
				--btnRefresh.enabled =			flagEnableDisable
				--btnClose.enabled =				flagEnableDisable
				--btnGetTargets.enabled =			flagEnableDisable
				btnZero.enabled =				flagEnableDisable
				btnZeroAll.enabled =			flagEnableDisable
				btnEdit.enabled =				flagEnableDisable
				ckbRelativeAbsolute.enabled =	flagEnableDisable
				btnLoad.enabled =				flagEnableDisable
				btnSave.enabled =				flagEnableDisable
				chkSLsettings.enabled =			flagEnableDisable
				chkSLchannel.enabled =			flagEnableDisable
				chkSLvertexColors.enabled =		flagEnableDisable
				rdoSLoptions.enabled =			flagEnableDisable
				chkRenameTargets.enabled = 		flagEnableDisable
					
				if flagEnableDisable then
				(
					lblMorphObject.text = "Morph object:"
					btnPickObject.caption = if isValidNode morphObj then morphObj.name else "<no object defined>"
					btnGetTargets.caption = "Get Scene Targets"
				)
				else
				(
					lblMorphObject.text = "     Character:"
					if isValidNode chrNode then
					(
						_chrParts = filterString chrNode.name "_"
						btnPickObject.caption = (_chrParts[1] + "_" + _chrParts[2])
					)
					else
					(
						btnPickObject.caption =  "<no object defined>"
					)
					btnGetTargets.caption = "Get Face Controls"
				)
				
				if not chkUseLimits.checked then
				(
					chkUseLimitsP.enabled = true
					if chkUseLimitsP.checked then
					(
						spnMinimum.enabled = true
						spnMaximum.enabled = true				
					)else(
						spnMinimum.enabled = false
						spnMaximum.enabled = false
					)			
				)
				else
				(
					spnMinimum.enabled = false
					spnMaximum.enabled = false
					chkUseLimitsP.enabled = false
				)
			
				if flagEnableDisable then updateChannelSettings indexSelected
			)
		)--fn buttonsEnableDisable

		-----------------------------------------------
		--@fn: undefined | pickObjTest | Comprueba que el objeto pasado por parametro tiene aplicado un modificador morpher
		------------------------------------------------
		fn pickObjTest obj =
		(
			test = false
			
			if rollMainDef.ckbMorphMode.checked then
			(
				for m in obj.modifiers do if classof m == morpher or classof m == Morph_O_Matic then test = true
			)
			else if rollMainDef.ckbBonesMode.checked then
			(
				if lb.nc.ncOK obj.name type:#object then test = true
			)
					
			test
		)--fn pickObjTest

		-----------------------------------------------
		--@fn: undefined | createModChangeHandler | crea el change handler que vigila los cambios en el objeto
		------------------------------------------------		
		fn createModChangeHandler =
		(
 			if morphObj != undefined then
 				modifierCH = when parameters morphMod changes id:#MorpherManagerCH val do
				(
						rollMainDef.updateListView()
				)
 		)--fn createModChangeHandler

		-----------------------------------------------
		--@fn: undefined | deleteModChangeHandler | destruye el change handler que vigila los cambios en el objet
		------------------------------------------------
		fn deleteModChangeHandler =
		(
			deleteAllChangeHandlers id:#MorpherManagerCH
		)--fn deleteModChangeHandler

		-----------------------------------------------
		--@fn: undefined | SelChannel | Selecciona en el modificador el canal de morpher correspondiente al item del listview seleccionado
		------------------------------------------------
		fn SelChannel index =
		(
			if index > 10 then
			(
				desp = (index)/10 as integer
				sel = index - (desp*10) + 1
			)else(
				desp = 0
				sel = index
			)
			
			if desp==10 then sel = 10

			WM3_SetChannelPos morphMod (desp*10)
			WM3_SetChannelSel morphMod sel
		)--fn SelChannel

		-----------------------------------------------
		--@fn: undefined | moveTargetsUp | Mueve los morph targets una posición hacia arriba siempre que sea posible
		------------------------------------------------
		fn moveTargetsUp numPos:1 =
		(
			if morphMod != undefined and classof morphMod == morpher then
 			(
				deleteModChangeHandler()
				positions = #()
				items = #()
				for i = 1 to lvSelListItems.count do
					appendifunique positions (lvSelListItems.item[i-1].index + 1)
					-- Como se seleccionan dos celdas por fila (por la opción fullRowSelect)
					-- tenemos que comprobar que no añadimos posiciones ya almacenadas.

				auxIndex = findItem positions indexSelected --guardamos el valor que tenia indexSelected
				
				sort positions	-- el array viene desordenado. Lo ordenamos
				
				undo "Move Targets Up" on
				(
					for i = 1 to positions.count do
					(
						newPos = (positions[i] - numPos)
						if newPos > 0 and (finditem positions newpos == 0) then
						(
							wm3_SwapMorph morphMod positions[i] newPos
							positions[i] = newPos
						)
					)
				)
				updateListView()
				
				-- restablecemos la selección de casillas
				for i = 1 to 100 do
					lvMorphList.items.item[i-1].selected = ((finditem positions i) != 0)
				
				indexSelected = positions[auxIndex] --restauramos el valor de indexSelected pero actualizado
				WM3_RefreshChannelListUI morphMod
				SelChannel indexSelected
				createModChangeHandler()
			)
		)--fn moveTargetsUp		

		-----------------------------------------------
		--@fn: undefined | moveTargetsDown | Mueve los morph targets una posición hacia abajo siempre que sea posible
		------------------------------------------------
		fn moveTargetsDown numPos:1 =
		(
			if morphMod != undefined and classof morphMod == morpher then
 			(
				deleteModChangeHandler()
				positions = #()
				items = #()
				for i = 1 to lvSelListItems.count do
					appendifunique positions (lvSelListItems.item[i-1].index + 1)
					-- Como se seleccionan dos celdas por fila (por la opción fullRowSelect)
					-- tenemos que comprobar que no añadimos posiciones ya almacenadas.
				
				auxIndex = findItem positions indexSelected --guardamos el valor que tenia indexSelected
				
				sort positions	-- el array viene desordenado. Lo ordenamos
				
				undo "Move Targets Down" on
				(
					for i = positions.count to 1 by -1 do
					(
						newPos = (positions[i] + numPos)
						if newPos <= 100 and (finditem positions newpos == 0) then
						(
							wm3_SwapMorph morphMod positions[i] newPos
							positions[i] = newPos
						)
					)
				)
				updateListView()
				
				-- restablecemos la selección de casillas
				for i = 1 to 100 do
					lvMorphList.items.item[i-1].selected = ((finditem positions i) != 0)
				
				indexSelected = positions[auxIndex] --restauramos el valor de indexSelected pero actualizado
				WM3_RefreshChannelListUI morphMod
				SelChannel indexSelected
				createModChangeHandler()
				)
		)--fn moveTargetsDown

		-----------------------------------------------
		--@fn: undefined | setTargetsValue | pone el valor pasado por parametro a los canales seleccionado o a todos
		------------------------------------------------
		fn setTargetsValue val allTargets:false =
		(
			deleteModChangeHandler()
			v = val as float
			items = if not allTargets then lvSelListItems else lvMorphList.items
			
			case classof morphMod of
			(
				morpher:
				(
					for i = 1 to items.count do
					(				
						index = items.item[i-1].index  + 1
						if WM3_MC_HasData morphMod index then
						(
							WM3_MC_SetValue morphMod index v
							items.item[i-1].subitems.item[2].text = (v as string)
						)
					)
				)
				
				Morph_O_Matic:
				(
					for i = 1 to items.count do
					(				
						index = items.item[i-1].index  + 1
						morphMod[index][2].controller.value = v
						items.item[i-1].subitems.item[2].text = (v as string)						
					)
				)
			)
			createModChangeHandler()
		)

		-----------------------------------------------
		--@fn: undefined | progTargetDeleted | comprueba que no se ha borrado ningun target progressivo previo
		------------------------------------------------
		fn progTargetDeleted morphModifier index =
		(
			auxNodes = #()
			notExists = false
			
			case classof morphMod of
			(
				morpher:
				(
					nProgs = WM3_NumberOfProgressiveMorphs morphModifier index
					for i=1 to nProgs do
					(
						append auxNodes (WM3_GetProgressiveMorphNode morphModifier index i)
						if not isValidNode auxNodes[i] then --si no esta definido activa el flag de borrado
							notExists = true
					)
				)
				
				Morph_O_Matic:
				(
					nProgs = MOM_MC_GetNumTargets morphModifier[index]
					for i=1 to nProgs where not (MOM_MC_TARG_IsOriginal morphModifier[index] i) do
					(
						_tmpNode = (MOM_MC_TARG_GetNode morphModifier[index] i)
						if not isValidNode _tmpNode then --si no esta definido activa el flag de borrado
							notExists = true
					)
				)
			)
			
			notExists --devuelve el resultado de la comprobacion
		)--fn progTargetDeleted	

		-----------------------------------------------
		--@fn: undefined | ncOKprogTarget | comprueba que un target tiene nomenclatura de progresivo
		------------------------------------------------
		fn ncOKprogTarget progTargetName = 
		(
			
			tempName = progTargetName
			if lb.nc.ncOK tempName then
				tempName = (filterString tempName "_")[4] + "_" + (filterString tempName "_")[5]

			--si el nombre del morph tiene 6 partes y cumple la convencionde nombres
			if ((morphNameParts tempName).count == 6) and (checkNamingConvention progTargetName) then
				true
			else if tempName == "x_original" then --si es la cabeza original
				true
			else
				false
		)

		-----------------------------------------------
		--@fn: undefined | updateProgName | Calcula el nombre del canal en funcion de sus progresivos
		------------------------------------------------
		fn updateProgName morphModifier index autoRenameTargets:false =
		(
 			auxNodesWeight = #() --array para guardar los pesos de los targets
			progNames = #() --array para guardar los nombres de los targets
 			nProgs = 0
			
 			--obtiene el numero de targets del canal
			case classof morphModifier of
			(
				morpher: nProgs = WM3_NumberOfProgressiveMorphs morphModifier index
				Morph_O_Matic: nProgs = MOM_MC_GetNumTargets morphModifier[index]
			)
				
			ncFlag = true --flag para saber si todos los progs cumplen el ncOK de progresivos
			progBaseName = undefined
			
 			--obtiene los nombres de los targets y sus pesos, y averigua si todos los targets tienen nomenclatura de progresivo
 			for i=1 to nProgs do
 			(
				case classof morphModifier of
				(
					morpher:
					(
						append progNames (WM3_GetProgressiveMorphNode morphMod index i)
						append auxNodesWeight (if progNames[i] != undefined then (WM3_GetProgressiveMorphWeight morphMod index progNames[i]) else 100)
						
						progNames[i] = (if progNames[i] == undefined then "unknown" else progNames[i].name)
						if not ncOKprogTarget progNames[i] then
							ncFlag = false
						else if findstring progNames[i] "x_original" == undefined then
							progBaseName = progNames[i]
					)
					
					Morph_O_Matic:
					(
						append progNames (MOM_MC_TARG_GetName morphMod[index] i)
						append auxNodesWeight (MOM_MC_TARG_GetProgressive morphMod[index] i)
						
						if not ncOKprogTarget progNames[i] then
							ncFlag = false
						else if findstring progNames[i] "x_original" == undefined then
							progBaseName = progNames[i]
					)
				)
 				
				
 			)
 			
 			--si es pogresivo
 			if nProgs > 1 and progBaseName != undefined then
 			(
				--calcula el nombre que va a tener el canal en funcion de los progresivos
				tempName = progParts = progBaseName
				if lb.nc.ncOK progParts then
				(
					progParts = (filterString progBaseName "_")
					tempName = progParts[4] + "_" + progParts[5]
				)
				
				mNameParts = morphNameParts tempName
				initNamePart = mNameParts[1] + "_" + mNameParts[2] + "-" + mNameParts[3] + "-" + mNameParts[4] + "-" + mNameParts[5] + "-"
				channelName = initNamePart
				for i=1 to auxNodesWeight.count do
				(
					channelName = channelName + "p"
					if findstring progNames[i] "x_original" != undefined then channelName = channelName + "o"
					channelName = channelName + ((auxNodesWeight[i] as integer) as string)
					
					if autoRenameTargets then
					(
						case classof morphModifier of
						(
							morpher: (WM3_GetProgressiveMorphNode morphMod index i).name = (progParts[1] + "_" + progParts[2] + "_" + progParts[3] + "_" + (initNamePart + "p" + ((auxNodesWeight[i] as integer) as string)) + "_" + progParts[6] + "_" + progParts[7])
							Morph_O_Matic:
							(
								_node = MOM_MC_TARG_GetNode morphMod[index] i
								_name = (progParts[1] + "_" + progParts[2] + "_" + progParts[3] + "_" + (initNamePart + "p" + ((auxNodesWeight[i] as integer) as string)) + "_" + progParts[6] + "_" + progParts[7])
								if isValidNode _node then _node.name = _name
								MOM_MC_TARG_SetName morphMod[index] _name i
							)
						)						
					)
				)
				
				case classof morphModifier of
				(
					morpher:
					(
						WM3_MC_SetName morphModifier index channelName
						WM3_RefreshChannelParamsUI morphModifier
						WM3_RefreshChannelListUI morphModifier
					)
					
					Morph_O_Matic:
					(
						MOM_SetChannelName morphModifier index channelName
					)
				)
				
				
			)		
		)--fn updateProgName

		-----------------------------------------------
		--@fn: undefined | updateProgWeights | pone a cada progresivo el peso que indica su nombre si este cumple el naming convention
		------------------------------------------------
		fn updateProgWeights morphModifier channelIndex originalWeight:undefined =
		(
			case classof morphModifier of
			(
				morpher:
				(
					numProgs = WM3_NumberOfProgressiveMorphs morphModifier channelIndex
					progNodes = #()
					weights = #()
					
					if not progTargetDeleted morphModifier channelIndex then --si los targets existen
					(
						for i=1 to numProgs do --recorre los targets
						(
							progNodes[i] = WM3_GetProgressiveMorphNode morphModifier channelIndex i
							
							if ncOKprogTarget progNodes[i].name then --si cumple el ncOK de progresivos
							(
								weights[i] = 0
								
								if findString progNodes[i].name "x_original" != undefined then
								(
									weights[i] = 10									
								)
								else
								(
									tempName = progNodes[i].name
									if lb.nc.ncOK tempName then
									(
										tempName = (filterString tempName "_")[4] + "_" + (filterString tempName "_")[5]
									)
									weights[i] = (filterString (morphNameParts tempName)[6] "po")[1] as float
								)
							)
							else --si no cumple el ncOK de progresivos
							(
								if i > 1 then
								(
									weights[i] = weights[i-1] + 2
									if weights[i] >= 100 then weights[i] = 100
								)
								else
									weights[i] = 0
							)							
						)
					)
						
					--asigna los nuevos pesos
					for i=1 to numProgs do
						WM3_SetProgressiveMorphWeight morphModifier channelIndex progNodes[i] (weights[i] as float)
				)
				
				Morph_O_Matic:
				(
					numProgs = MOM_MC_GetNumTargets morphModifier[channelIndex]
					progNodes = #()
					weights = #()
					
					if not progTargetDeleted morphModifier channelIndex then --si los targets existen
					(
						for i=1 to numProgs do --recorre los targets
						(
							progNodes[i] = MOM_MC_TARG_GetNode morphModifier[channelIndex] i
							
							if (MOM_MC_TARG_IsOriginal morphModifier[channelIndex] i) or ncOKprogTarget progNodes[i].name then --si cumple el ncOK de progresivos
							(
								weights[i] = 0
								
								if (MOM_MC_TARG_IsOriginal morphModifier[channelIndex] i) then
								(
									if originalWeight != undefined then
									(
										weights[i] = originalWeight
									)
									else
									(
										if i!= 1 then weights[i] = 10
										else weights[i] = 0
									)
								)
								else
								(
									tempName = progNodes[i].name
									if lb.nc.ncOK tempName then
									(
										tempName = (filterString tempName "_")[4] + "_" + (filterString tempName "_")[5]
									)
									weights[i] = (filterString (morphNameParts tempName)[6] "po")[1] as float
								)
							)
							else --si no cumple el ncOK de progresivos
							(
								weights[i] = (i-1)*100
							)
						)
					)
						
					--asigna los nuevos pesos
					for i=1 to numProgs do
						MOM_MC_TARG_SetProgressive morphModifier[channelIndex] (weights[i] as float) i
				)
			)	
		)

		-----------------------------------------------
		--@fn: undefined | setNewProgWeight | pone un nuevo peso (%) al target progresivo seleccionado
		------------------------------------------------
		fn setNewProgWeight morphModifier channelIndex progIndex newWeight autoRenameTargets:false =
		(
			
			case classof morphModifier of
			(
				morpher:
				(
					if not progTargetDeleted morphModifier channelIndex then --si los progresivos estan en escena
					(
						progNode = WM3_GetProgressiveMorphNode morphModifier channelIndex progIndex
						WM3_SetProgressiveMorphWeight morphModifier channelIndex progNode (newWeight as float)
						
						fillChannelList channelIndex --actualiza la lista 
						
						for i=1 to lvChannelList.items.count do
							if lvChannelList.items.item[i-1].subitems.item[2].text as integer == newWeight then
								targetSelected = i
						
						for i=1 to lvChannelList.items.count do
							lvChannelList.items.item[i-1].selected = false
						
						lvChannelList.items.item[targetSelected-1].selected = true
						
						--actualiza el nombre del canal y de los targets si se da el caso
						updateProgName morphModifier channelIndex autoRenameTargets:autoRenameTargets
						
						fillChannelList channelIndex --actualiza la lista 
						
						for i=1 to lvChannelList.items.count do
							updateRowsColor lvChannelList i true
						
						lvChannelList.Focus()
					)				
					else
					(
						lb.message.show "All Progressive Targets must exist in scene" type:#message pos:undefined size:[300,75] modal:true
					)--if targets exists
				)
				
				Morph_O_Matic:
				(
					MOM_MC_TARG_SetProgressive morphModifier[channelIndex] (newWeight as float) progIndex
					
					fillChannelList channelIndex --actualiza la lista 
					
					for i=1 to lvChannelList.items.count do
						if lvChannelList.items.item[i-1].subitems.item[2].text as integer == newWeight then
							targetSelected = i
					
					for i=1 to lvChannelList.items.count do
						lvChannelList.items.item[i-1].selected = false
					
					lvChannelList.items.item[targetSelected-1].selected = true
					
					--actualiza el nombre del canal y de los targets si se da el caso
					updateProgName morphModifier channelIndex autoRenameTargets:autoRenameTargets
					
					fillChannelList channelIndex --actualiza la lista 
					
					for i=1 to lvChannelList.items.count do
						updateRowsColor lvChannelList i true
					
					lvChannelList.Focus()
				)
			)--case	
		)--fn setNewWeight

		-----------------------------------------------
		--@fn: undefined | addTarget | Añade el target seleccionado ya sea simple o progresivo, al canal actual
		------------------------------------------------
		fn addTarget morphModifier index target autoRenameTargets:false =
		(
			case classof morphModifier of
			(
				morpher:
				(
					--comprueba si el canal esta vacio, y si no esta vacio, si el target esta en escena
					hasTarget = WM3_MC_HasData morphModifier index --si el canal esta vacio
					hasSceneTarget = WM3_MC_HasTarget morphModifier index --si el target existe en escena
					
					if hasTarget then --si el canal no esta vacio
					(
						--si el canal tiene un target pero no esta en escena, borra el canal y lo reconstruye con el target
						if not hasSceneTarget then --si el target no exsite en escena
						(
							WM3_MC_Delete morphModifier index --vacia el canal
							WM3_MC_BuildFromNode morphModifier index target --reconstruye el canal segun el target pasado
							if not checkNamingConvention target.name then
								updateRowsColor lvMorphList index false
						)
						else --si el target existe en escena, añade el nuevo como target progresivo
						(
							WM3_AddProgressiveMorphNode morphModifier index target --añade el target al canal
							updateProgWeights morphModifier index
							updateProgName morphModifier index autoRenameTargets:autoRenameTargets
						)
					)
					else --si el canal esta vacio
					(
						--construye el canal con el target
						WM3_MC_BuildFromNode morphModifier index target --construye el canal segun el obj pasado
						
						auxParts = filterString morphObj.name "_"
						
						tempName = getMorphName (WM3_MC_GetName morphModifier index)
						
						WM3_MC_SetName morphModifier index tempName
						if not checkNamingConvention target.name then
							updateRowsColor lvMorphList index false
					)
				)
				
				Morph_O_Matic:
				(
					_numTargets = MOM_MC_GetNumTargets morphMod[index]
					
					--comprueba si el canal esta vacio, y si no esta vacio, si el target esta en escena
					hasTarget = false
					hasSceneTarget = true
					
					if _numTargets > 1 then hasTarget = true
					if _numTargets == 1 and (MOM_MC_TARG_GetName morphModifier[index] 1) != "Original" then hasTarget = true
					
					if hasTarget then --si el canal no esta vacio
					(
						for i=1 to _numTargets where not MOM_MC_TARG_IsOriginal morphModifier[index] i do
							if not isValidNode (MOM_MC_TARG_GetNode morphModifier[index] i) then hasSceneTarget = false
						
						--si el canal tiene un target pero no esta en escena, borra el canal y lo reconstruye con el target
						if not hasSceneTarget then --si el target no exsite en escena
						(
							MOM_ClearChannel morphModifier index --vacia el canal
							MOM_MC_InsertTarget morphModifier[index] 2 target --reconstruye el canal segun el target pasado
							
							tempName = getMorphName target.name
							MOM_SetChannelName morphModifier index tempName
							
							if not checkNamingConvention target.name then
								updateRowsColor lvMorphList index false
						)
						else --si el target existe en escena, añade el nuevo como target progresivo
						(
							_weight = undefined
							_useOriginal = false
							if lb.nc.ncOK (target.name) then
							(
								_nParts = filterString target.name "_"
								_n5Parts = filterString _nParts[5] "-"
								
								if findString _n5Parts[_n5Parts.count] "po" != undefined then
								(
									_weight = (substring _n5Parts[_n5Parts.count] 3 _n5Parts[_n5Parts.count].count) as integer
									_useOriginal = true
								)
							)
							
							if not _useOriginal then MOM_MC_InsertTarget morphModifier[index] (_numTargets+1) target --añade el target al canal
							updateProgWeights morphModifier index originalWeight:_weight
							updateProgName morphModifier index autoRenameTargets:autoRenameTargets
						)
					)
					else --si el canal esta vacio
					(
						--construye el canal con el target
						MOM_MC_InsertTarget morphModifier[index] 2 target --construye el canal segun el obj pasado
						
						auxParts = filterString morphObj.name "_"
						
						tempName = getMorphName target.name
						
						MOM_SetChannelName morphModifier index tempName
						if not checkNamingConvention target.name then
							updateRowsColor lvMorphList index false
					)
				)
			)	
		)--fn addTarget

		-----------------------------------------------
		--@fn: undefined | channelNumericValues | devuelve una rray con el valor numerico de cada parte del nombre del morph channel
		------------------------------------------------
		fn channelNumericValues morphChannel =
		(	
			numericValues = #()
			
			auxParts = filterString morphObj.name "_"
			tempName = getMorphName morphChannel.name

			m1name = morphNameParts tempName --obtiene las partes del nombre de m1
		
			if m1name.count != 0 then
			(
				--m1---------------------------------------
				case m1name[1] of
				(
					"x" :		pos = 1
					"m" :		pos = 2
					"r" :		pos = 3
					"l" :		pos = 4
					default:	pos = 5
				)
				
				case m1name[2] of
				(
					--partes para la cabeza
					"ebw" :		part = 1
					"eld" :		part = 2
					"chb":		part = 3
					"nose" :		part = 4
					"lip" : 		part = 5
					"lipsync" :	part = 6
					"jaw" :		part = 7
					"eye":		part = 8
					--partes para la lengua
					"tongue":	part = 9
					--partes para el pelo
					"hair":		part = 10
					--partes del FFD
					"ffdskl":		part = 11
					"ffdjaw":		part = 12
					
					default:		part = 13
				)
				
				case m1name[3] of
				(
					"all" :				partPos = 1
					"int" :				partPos = 2
					"mid" :			partPos = 3
					"mid1" :			partPos = 4
					"mid2" :			partPos = 5
					"mid3" :			partPos = 6
					"ext" : 			partPos = 7
					"upperAll" :		partPos = 8
					"upper" :			partPos = 9
					"upperInt" :		partPos = 10
					"upperMid" :	partPos = 11
					"upperMid1" :	partPos = 12
					"upperMid2" :	partPos = 13
					"upperMid3" :	partPos = 14
					"upperExt" :	partPos = 15
					"lowerAll" :		partPos = 16
					"lower" :			partPos = 17
					"lowerInt" :		partPos = 18
					"lowerMid" :		partPos = 19
					"lowerMid1" :	partPos = 20
					"lowerMid2" :	partPos = 21
					"lowerMid3" :	partPos = 22
					"lowerExt" :		partPos = 23
					"side" :		partPos = 24
					"sideInt" :		partPos = 25
					"sideExt" :		partPos = 26
					"tip":				partPos = 27 --parte de la punta de la lengua
					"hair":			partPos = 28
					"smooth":		partPos = 29
					"fix":				partPos = 30
					"adjust":			partPos = 31
					default:			partPos = 32
				)
				
				case m1name[4] of
				(
					"x" :			dir = 1
					"hz" :			dir = 2
					"vt" :			dir = 3
					"open":		dir= 4
					"stretch" :	dir = 5
					"bend" :		dir = 6
					"snout" :		dir = 7
					"inflate" :	dir = 8
					"a" :			dir = 9
					"o" :			dir = 10
					"f" :			dir = 11
					"twist":		dir = 12 --torsion de la lengua
					"scale":		dir = 13
					"break":		dir = 14
					default:		dir = 15
				)
				
				case m1name[5] of
				(
					"x" :			constrDir = 1
					"up" :			constrDir = 2
					"dw" :		constrDir = 3
					"r" :			constrDir = 4
					"l" : 			constrDir = 5
					"out" :		constrDir = 6
					"in" :			constrDir = 7	
					"fr":			constrDir = 8
					"bk"	:		constrDir = 9	
					default:		constrDir = 10	
				)
				
				numericValues = #(pos,part,partPos,dir,constrDir)
				if m1name[6] != undefined then
					append numericValues m1name[6]
			
			)
				
			numericValues
		)

		-----------------------------------------------
		--@fn: undefined | compareMorphs | Compara dos morphs y deduce en funcion de su nombre cual va antes o después
		------------------------------------------------
		fn compareMorphs m1 m2 =
		(
			
			numericVals1 = channelNumericValues m1
			numericVals2 = channelNumericValues m2
			
			if numericVals1.count != 0 and numericVals2.count != 0 then
			(--comparaciones entre las partes del nombre
				case of--part-----------------------------------------------------------------------------------
				(
					(numericVals1[2] < numericVals2[2]): -1
					(numericVals1[2] > numericVals2[2]): 1
					default:
						(
							case of--pos------------------------------------------------------------------------
							(
								(numericVals1[1] < numericVals2[1]): -1
								(numericVals1[1] > numericVals2[1]): 1
								default:
									(
										case of--partPos-------------------------------------------------------
										(
											(numericVals1[5] < numericVals2[5]): -1
											(numericVals1[5] > numericVals2[5]): 1
											default:
												(
													case of--dir-------------------------------------------------
													(
														(numericVals1[4] < numericVals2[4]): -1
														(numericVals1[4] > numericVals2[4]): 1
														default:
															(
																case of--constrDir-----------------------------
																(
																	(numericVals1[3] < numericVals2[3]): -1
																	(numericVals1[3] > numericVals2[3]): 1
																	default:
																	(
																		if numericVals1[6] != undefined and numericVals2[6] != undefined then
																		(
																			m1p = filterString numericVals1[6] "po"
																			m2p = filterString numericVals2[6] "po"
																			
																			if m1p.count == 1 and m2p.count == 1 then
																			(
																				if m1p[1] as integer < m2p[1] as integer then
																					-1
																				else if m1p[1] as integer > m2p[1] as integer then
																					1
																				else
																					0
																			)
																			else
																				0
																		)
																		else
																			0
																	)--case p%
																)--case of constrDir
															)--default				
													)--case of dir
												)--default				
										)--case of partPos
									)--default				
							)--case of pos
						)--default				
				)--case of part
				
			)--si son comparables
			else
			(
				0
			)	
		)--fn compareMorphs

		-----------------------------------------------
		--@fn: undefined | orderMorphs | Coloca los morph targets en la posicion adecuada del espacio y los ordena en la escena
		------------------------------------------------
		fn orderMorphs morphsArray=
		(
			qsort morphsArray compareMorphs --ordena el array de morphs
			clearselection()
			
			if morphsArray.count > 0 then
			(
				bb = nodeLocalBoundingBox morphsArray[1] --calcula los puntos maximo y minimo del bounding box de la cabeza
				
				bb_width = abs(bb[2].x - bb[1].x) --calcula el ancho del bounding box
				bb_length = abs(bb[2].y - bb[1].y) --calcula la profundidad del bounding box
				bb_height = abs(bb[2].z - bb[1].z) --calcula la altura del bounding box
			)--if
			
			x_originalOffset = bb_width*20 --establece el offset inicial en x
			z_originalOffset = bb_height*20 -- establece el offset inicial en z
			x_offset = 0 --offset en x para ir colocando las cabezas
			z_offset = 0 --offset en z para ir colocando las cabezas
			rl_offset = bb_width/2 --offset para separar del centro las cabezas que sean R o L
			rl_sign = 1 --signo para saber donde colocar las cabezas dependiendo de si son R(-1) o L(1)
			posneg = 0 --variable para saber si una cabeza es el gesto negativo de otro y poder colocarla debajo
			aux_z_offset = 0 --offset en z para poner los gestos negativos debajo del positivo
			partChangeFlag = true --flag para saber si se ha cambiado de conjunto de gestos
			createRectangle = false --flag para saber si se tiene que crear un recangulo delimitador de gestos
			partFisrtMorph = 1 --almacena la posicion en el array del primer gestod e cada conjunto de gestos
			partHighestMorph = 1 --almacena la posicion en el array del gesto que este mas alto en z
			partLowestMorph = 1 --almacena la posicion en el array del gesto que este mas bajo en z
			centerMorphsFlag = false --flag para centrar las cabezas que son X
			
			----------------------------------------------------------------------------------------------------------------
			--coloca el morph original en caso de que exista, en la posicion adecuada
			if oMorphObj != undefined then
			(
				if (not isDeleted oMorphObj) then
				(
				oMorphObj.pos.x = morphsArray[1].pos.x + x_originalOffset
				oMorphObj.pos.z = morphsArray[1].pos.z + z_originalOffset + bb_height*2
				oMorphObj.mat = undefined
				oMorphObj.wirecolor = [255,255,0]
				selectMore oMorphObj
				)
			)
			----------------------------------------------------------------------------------------------------------------
			
			for i=1 to morphsArray.count do
			(--loop que recorre el array de morphs y los va colocando en su posicion
				m = morphsArray[i] -- almacena el gesto actual en una variable
				mName = morphNameParts m.name --extrae las partes del nombre del gesto
				m.mat = undefined --deja el gesto sin material
				selectMore m --selecciona el gesto para que al final esten todos seleccionados
				
				x_offset += 1 --aumenta el offset en x para que el gesto se separe del anterior
				if mName[1] == "x" then --si el gesto es de tipo X
				(
					if partChangeFlag then --si se pasa a un nuevo conjunto de gestos
					(
						x_offset -= 1 --quita el offset en x para el primer gesto del conjunto
						partChangeFlag = false
						partFisrtMorph = i --almacena cual es el primer gesto del conjunto
					)
					rl_offset = 0 --el offset de RL es cero porque el gesto es de tipo X
					rl_sign = 1 --el signo de RL es positivo porque el gesto es de tipo X
					m.wirecolor = [88,144,225] --pone al gesto el color de tipo X
				)else(
					rl_offset = bb_width/2 -- establece un offset RL
					if mName[1] == "r" then --si es de tipo R
					(
						rl_sign = -1 --signo del offset RL negativo para los gestos de la derecha
						m.wirecolor = [0,255,0] --pone al gesto el color de tipo R
					)else(-- si es de tipo L
						rl_sign = 1 --signo del offset RL positivo para los gestos de la derecha
						m.wirecolor = [0,0,255] --pone al gesto el color de tipo L
					)
				)--if
				
				--colocar el gesto en su respectiva posicion en X y Z
				m.pos.x = (m.pos.x + x_originalOffset + rl_sign*(rl_offset + x_offset*(bb_width + bb_width/2)))
				m.pos.z = (m.pos.z + z_originalOffset - z_offset*(bb_height + bb_height/2) - posneg*(bb_height + bb_height/2))
				-----------------------------------------------------------
				
				--si la posicion en z de este gesto es mas baja que la del gesto anterior guarda este como el mas bajo					
				if m.pos.z < morphsArray[partLowestMorph].pos.z then partLowestMorph = i
					
				if i<morphsArray.count then --comprueba que no sea el ultimo gesto
				(
					mNext = morphsArray[i+1] --almacena el siguiente gesto
					mNextName = morphNameParts mNext.name --extrae las partes del nombre del gesto
					posneg = 0 
					
					if mName[2]!=mNextName[2] then----------------------------------------------------------
					(--comprueba que se va a cambiar de grupo de gestos
						z_offset = z_offset + 1.5 + aux_z_offset --calcula el offset en z para el siguiente gesto
						aux_z_offset = 0 --si cambiamos de grupo de gestos, el primer gesto no va a ser negativo
						x_offset = 0 --inicializa el offset en x
						partChangeFlag = true --pone a verdadero el flag de cambio de grupo de gestos
						createRectangle = true --pone a verdadero el flag para crear un rectangulo delimitador
						if mName[1]=="x" then centerMorphsFlag = true --si el gesto es de tipo X pone el flag a verdadero para centrar las cabezas
					)else(--si se continua mismo grupo
						if mName[1]!=mNextName[1] then------------------------------------------------------
						(--comprueba que se va a cambiar entre tipo de gesto X(central), R(Derecho) y L(Izquierdo)
							x_offset = 0 --inicializa el offset en x
							if mName[1]!="r" then --si no es de tipo R
							(
								z_offset = z_offset + 1 + aux_z_offset --calcula el offset en z
								aux_z_offset = 0 --si cambiamos de tipo de gesto, el primer gesto no va a ser negativo
							)
							if mName[1]=="x" then centerMorphsFlag = true --si son gestos de tipo X activa el flag para centrarlos
						)else(--si se continua en el mismo tipo de gestos
							if mName[3]==mNextName[3] and mName[4]==mNextName[4] and mNextName[6]==undefined then------
							(--si la tercera y cuarta parte de nombre son iguales comprueba la ultima para detectar gestos negativos
								auxflag = false
								case mNextName[5] of-----------------------------------------------
								(
									"dw" :		auxflag = true
									"l" :			auxflag = true
									"in" :			auxflag = true			
									"bendL" :	auxflag = true	
									"back" :		auxflag = true	
									default: 		posneg = 0
								)--case
								if auxflag then
								(
									posneg = 1
									x_offset-=1
									aux_z_offset = 1
								)--if4
							)else(--si la tercera y cuarta parte del nombre no son iguales, no puede haber gesto negativo
								posneg = 0 --el flag de gesto negativo se pone a cero
							)--if3
						)--if2
					)--if1
				)else(--si es el ultimo gesto del array
					if mName[1]=="x" then centerMorphsFlag = true --si es de tipo x, pone el flag de cetrar gestos a verdadero
					createRectangle = true --pone el flag de crear rectangulo delimitador a verdadero		
				)--if count
					
				if centerMorphsFlag then --centra los gestos de tipo X
				(
					x1 = morphsArray[partFisrtMorph].pos.x - x_originalOffset
					x2 = m.pos.x - x_originalOffset
					desp = -(x1 +x2)/2 --calcula cuanto desplazar los gestos hacia la izquierda
					for j=partFisrtMorph to i do
					(--loop que mueve los gestos
						move morphsArray[j] [desp,0,0]
					)
					centerMorphsFlag = false --desactiva el flag de centrar los gestos
				)

				--crear el rectangulo que rodea los morphs de la misma parte			
				if createRectangle then
				(
					rz1 = morphsArray[partHighestMorph].pos.z
					rz2 = morphsArray[partLowestMorph].pos.z
					rLength = abs(rz1-rz2) + bb_height*2 --calcula la longitud del rectangulo
					rzPos = ((rz1+rz2)/2) --calcula la posicion en z del rectangulo
										
					rx = m.pos.x
					rWidth = rx - (rx - (rx - x_originalOffset)*2) + bb_width*2 --calcula en ancho del rectangulo
					rxPos = rx - (rx - x_originalOffset) --calcula la posicion en x del rectangulo
					
					--creacion del rectanculo y colocacion del mismo
					rect = Rectangle length:rLength width:rWidth cornerRadius:0
					rect.pos.x = rxPos
					rect.pos.y = 0
					rect.pos.z = rzPos
					rect.wirecolor = [255,255,0]
					rotate rect (eulerangles 90 0 0)
					ResetXform rect
					collapseStack rect
					-----------------------------------------------------
					
					--creacion de un titulo por cada grupo de gestos
					rText = text size:100 kerning:0 leading:0
					rText.size = bb_height/2
					rText.wirecolor = [255,255,0]
					rText.text = 
					case mName[2] of
					(
						"eld" :		rText.text = "Eyelids"
						"ebw" :		rText.text = "Eyebrowns"
						"lip" :			rText.text = "Lips"
						"chb" : 		rText.text = "Cheekbones"
						"lipsync" :	rText.text = "Lipsync"
						"jaw" :		rText.text = "Jaw"
					)
					rText_bb = nodeLocalBoundingBox rText
					rotate rText (eulerangles 90 0 0)
					rText.pivot = [rText_bb[2].x, rText.pos.y, rText_bb[1].z]
					
					rect_bb = nodeLocalBoundingBox rect
					
					rText.pos.x = rect_bb[2].x - (bb_width/10)
					rText.pos.z = rect_bb[1].z + (bb_height/10)
					-----------------------------------------------------
					
					partHighestMorph = i+1 --pone como gesto situado mas alto del siguiento grupo al primero de ellos
					partLowestMorph = i+1 --pone como gesto situado mas bajo del siguiento grupo al primero de ellos
					createRectangle = false --desactiva el flag de crear rectangulo
					
					selectMore rect --añade a la seleccion el rectangulo
					selectMore rText --añade a la seleccion el titulo
				)
				-------------------------------------------------------------------
			)--for	
		)--fn orderMorphs

		-----------------------------------------------
		--@fn: undefined | extractMorphs | Extrae los morph targets del modificador a geometrias
		------------------------------------------------
		fn extractMorphs =
		(
			auxObj = undefined --objeto auxiliar para copiar la cabeza original
			auxMorphMod = undefined --modificador auxiliar para meter una copia del morpher original
			originPercent = undefined --peso del morph original en los progresivos
			itemsToExtract = #() --array donde almacenar los ids de los canales de morph que se desean extraer
			Targets = #() --array con los targets extraidos
			
			/*(se puede querer aumentar la memoria cuando queremos incluir muchos cambios en un UNDO
			y con la memoria inicial no es suficiente para almacenarlos)*/
			
			--if heapSize < 15000000 then 
			--	heapSize = 15000000 --aumenta la memoria del programa a 15 megas
						
			case rdoSelection.state of
			(
				1 : --caso para extraer todos los canales de morph que sean extraibles
					(
						for i=1 to 100 do
							append itemsToExtract i
					)
				2 : --caso para extraer todos los canales de morph seleccionados
					(
						for i = 1 to lvSelListItems.count do
						(
							appendifunique itemsToExtract (lvSelListItems.item[i-1].index + 1)
						)
						sort itemsToExtract
					)
			)--case
			
			auxObj = copy morphObj --copia de la cabeza original
			--elimina todos los modificadores de la copia excepto el morpher
			for i=auxObj.modifiers.count to 1 by -1 do
			(
				if classof auxObj.modifiers[i] != Morpher then
					deleteModifier auxObj i
			)--for
			auxMorphMod = auxObj.modifiers[1] --almacena el modificador morpher de la copia
			
			if itemsToExtract.count > 0 then
			(
				--undo "Extract Targets" on
				--(
					j=1 --contador de targets extraidos
					for i=1 to itemsToExtract.count do
					(--loop que pasa por todos los morphs que se deben extraer
						
						if WM3_MC_HasData auxMorphMod itemsToExtract[i] then
						(--comprueba que sea un morph extraible
							nProgs = WM3_NumberOfProgressiveMorphs auxMorphMod itemsToExtract[i]
							auxMorphMod[itemsToExtract[i]].controller = Bezier_Float()
							auxName = tempNAME = WM3_MC_GetName auxMorphMod itemsToExtract[i]

							if nProgs > 1 then
							(--si es un morph progresivo
								
								aux = filterString tempNAME "-"
								aux2 = filterString aux[5] "p"

								initialValue = WM3_MC_GetValue morphMod itemsToExtract[i]
								mNodes = #()
								if chkAutoreconnect.checked then WM3_MC_Delete morphMod itemsToExtract[i]

								for k in 1 to aux2.count do
								(--loop que extrae los morphs progresivos excepto si uno de ellos es la cabeza original

									if aux2[k][1] != "o" then
									(--si no es el morph original
										tempNAME = aux[1] + "-" + aux[2] + "-" + aux[3] + "-" + aux[4] + "-p" + aux2[k]
										auxMorphMod[itemsToExtract[i]].value = (aux2[k] as float)
										append Targets (copy auxObj)
										Targets[j].name = tempNAME as string
										collapseStack Targets[j]
										Targets[j].wirecolor = [0,50,50]
										auxMorphMod[itemsToExtract[i]].value = (initialValue as float)
										
										if chkAutoreconnect.checked then
										(--si hay que reconectar
											append mNodes Targets[j]
											addTarget morphMod itemsToExtract[i] Targets[j]
										)
										
										j+=1 --aumenta el contador de targets extraidos
									)
									else --si es el morph original
									(
										--obtiene el peso del morph original
										originPercent = ((substring aux2[k] 2 aux2[k].count) as float)
										notExists = false
										
										-----------------------------------------------------------------
										--extrae el morph original si no existe ya en la escena
										if oMorphObj == undefined then
											notExists = true
										else
										(
											if (isDeleted oMorphObj) then
												notExists = true
											else
												notExists = false
										)--if undefined
										
										if notExists then
										(
											auxMorphMod[itemsToExtract[i]].value = originPercent
											oMorphObj = copy auxObj
											collapseStack oMorphObj
											oMorphObj.wirecolor = [255,90,0]
											oMorphObj.name = "originalMorph"
											auxMorphMod[itemsToExtract[i]].value = (initialValue as float)
										)
										--if no exite ya
										------------------------------------------------------------------
										
										if chkAutoreconnect.checked then
										(--si hay que reconectar
											append mNodes oMorphObj
											addTarget morphMod itemsToExtract[i] oMorphObj
										)
									)--if cabeza original 

								)--for k
								
								--poner a los progresivos el porcentaje adecuado
								if chkAutoreconnect.checked then
								(
									for k=1 to aux2.count do
									(
										if aux2[k][1] == "o" then aux2[k] = (substring aux2[k] 2 aux2[k].count)
										WM3_SetProgressiveMorphWeight morphMod itemsToExtract[i] mNodes[k] (aux2[k] as float)
									)--for
								)--if
								
								auxMorphMod[itemsToExtract[i]].value = (initialValue as float)
								WM3_MC_SetValue morphMod itemsToExtract[i] (initialValue  as float)
								if chkAutoreconnect.checked then (WM3_MC_SetName morphMod itemsToExtract[i] auxName)
							)
							else --si no es un morph progresivo
							(
								auxMorphMod[itemsToExtract[i]].value = 100
								append Targets (copy auxObj)
								auxMorphMod[itemsToExtract[i]].value = 0		
								Targets[j].name = tempNAME as string
								collapseStack Targets[j]
								Targets[j].wirecolor = [0,100,100]
																
								--reconectar  el canal con el morpher extraido, si la opcion de reconectar esta activa
								if chkAutoreconnect.checked then
								(
									WM3_MC_Delete morphMod itemsToExtract[i]
									WM3_MC_BuildFromNode morphMod itemsToExtract[i] Targets[j]
								)
								----------------------------------------------------------------------------------------------
								j+=1
							)--if progresivo
						)--if hasdata
					)--for

					orderMorphs Targets	 --ordena los morphs extraidos
				--)--undo
			)--if count
			
			delete auxObj
		)--fn extractMorphs

		-----------------------------------------------
		--@fn: undefined | startValueChange | Comienza la edición de los parámetros seleccionados, anotando los valores que hay en este momento en oldValues e indicando si las pistas tenían claves o no
		------------------------------------------------
		fn startValueChange =
		(
			deleteModChangeHandler()
			oldValues = #()
			
			case classof morphMod of
			(
				morpher:
				(
					changingItems = for i = 1 to lvSelListItems.count where (WM3_MC_hasdata morphMod (lvSelListItems.item[i-1].index + 1)) collect lvSelListItems.item[i-1]
					
					for i =1 to changingItems.count do
					(
						index = changingItems[i].index + 1
						append oldValues (WM3_MC_GetValue morphMod index)
					)
				)--morpher
				
				Morph_O_Matic:
				(
					changingItems = for i = 1 to lvSelListItems.count where (lvSelListItems.item[i-1].subItems.item[1].text != "- empty -") collect lvSelListItems.item[i-1]
						
					for i =1 to changingItems.count do
					(
						index = changingItems[i].index + 1
						append oldValues (morphMod[index][2].value)
					)
				)--Morph_O_Matic
			)--case
		)

		-----------------------------------------------
		--@fn: undefined | valueChange | cambia los valores al hacer drag con el MMD
		------------------------------------------------
		fn valueChange val absolute:ckbRelativeAbsolute.checked = 
		(
			for i = 1 to changingItems.count do
			(
				index = changingItems[i].index + 1
				newVal = if absolute then val else (oldValues[i] + val)
				
				case classof morphMod of
				(
					morpher:
					(
						-- si el canal tiene límites, comprobamos que el nuevo valor no los rebasa
						if WM3_MC_GetUseLimits morphMod index then
						(
							minVal = WM3_MC_GetLimitMIN morphMod index
							maxVal = WM3_MC_GetLimitMAX morphMod index
							if newVal > maxVal then newVal = maxVal
							if newVal < minVal then newVal = minVal
						)
						
						WM3_MC_SetValue morphMod index newVal
					)
					
					Morph_O_Matic:
					(
						-- si el canal tiene límites, comprobamos que el nuevo valor no los rebasa
						if morphMod[index].useLimits then
						(
							minVal = morphMod[index].minLimit
							maxVal = morphMod[index].maxLimit
							if newVal > maxVal then newVal = maxVal
							if newVal < minVal then newVal = minVal
						)
						
						morphMod[index][2].controller.value = newVal
					)
				)--case
				
				
				lvMorphList.items.item[index-1].subitems.item[2].text = newVal as string
			)
		)--fn valueChange

		-----------------------------------------------
		--@fn: undefined | stopValueChange | restablece los valores originales y luego pone los nuevos, para poder hacer undo
		------------------------------------------------
		fn stopValueChange = 
		(
			newValues = #()
			
			case classof morphMod of
			(
				morpher:
				(
					--restablece los valores originales
					for i = 1 to changingItems.count do
					(
						index = changingItems[i].index + 1
						append newValues (WM3_MC_GetValue morphMod index)
						lvMorphList.items.item[index-1].subitems.item[2].text = oldValues[i] as string
						WM3_MC_SetValue morphMod index oldValues[i]
					)
					
					--pone los valores nuevos, pero con posibilidad de hacer undo
					undo "Morph Value Change" on
					(
						for i = 1 to changingItems.count do
						(
							index = changingItems[i].index + 1
							WM3_MC_SetValue morphMod index newValues[i]
							lvMorphList.items.item[index-1].subitems.item[2].text = newValues[i] as string
						)
					)--undo
				)
				
				Morph_O_Matic:
				(
					--restablece los valores originales
					for i = 1 to changingItems.count do
					(
						index = changingItems[i].index + 1
						append newValues (morphMod[index][2].controller.value)
						lvMorphList.items.item[index-1].subitems.item[2].text = oldValues[i] as string
						morphMod[index][2].controller.value = oldValues[i]
					)
					
					--pone los valores nuevos, pero con posibilidad de hacer undo
					undo "Morph Value Change" on
					(
						for i = 1 to changingItems.count do
						(
							index = changingItems[i].index + 1
							morphMod[index][2].controller.value = newValues[i]
							lvMorphList.items.item[index-1].subitems.item[2].text = newValues[i] as string
						)
					)--undo
				)
			)--case
			
			createModChangeHandler()
		)--fn stopValueChange

		-----------------------------------------------
		--@fn: undefined | getLvSelectedListItems | Anota en la variable lvSelectedListItems los elementos actualmente seleccionados
		------------------------------------------------
		fn getLvSelectedListItems =
		(
			lvSelectedListItems = #()
			for i = 1 to lvMorphList.selectedItems.count do
				append lvSelectedListItems i
		)--fn getLvSelectedListItems

		-----------------------------------------------
		--@fn: undefined | restoreLvSelectedItems | Restablece la antigua seleccion de items
		------------------------------------------------
		fn restoreLvSelectedItems =
		(
			for i=1 to lvMorphList.items.count do
				lvMorphList.items.item[i-1].selected = false

			for i=1 to lvSelectedListItems.count do
				lvMorphList.items.item[lvSelectedListItems[i]].selected = true
		)--fn restoreLvSelectedItems

		-----------------------------------------------
		--@fn: undefined | lvSelectRange | selecciona el rango de items entre los dos indices
		------------------------------------------------
		fn lvSelectRange index1 index2 =
		(
			i1 = index1 ; i2 = index2
			if index1 > index2 then (i1 = index2; i2 = index1)
			
			lvSelectedListItems = #()
			for i = i1 to i2 do append lvSelectedListItems i
			restoreLvSelectedItems()
		)--fn lvSelectRange

		-----------------------------------------------
		--@fn: undefined | delTarget | borra el target seleccionado ya sea simple o progresivo
		------------------------------------------------
		fn delTarget =
		(
			case classof morphMod of
			(
				morpher:
				(
					--obtiene el numero de targets del canal
					nProgs = WM3_NumberOfProgressiveMorphs morphMod indexSelected
					
					--borra el canal de morpher seleccionado
					if nProgs > 0 then
					(
						WM3_MC_Delete morphMod indexSelected
						initialValues[indexSelected] = 0
					)
				)
				
				Morph_O_Matic:
				(
					MOM_ClearChannel morphMod indexSelected
					MOM_SetChannelName morphMod indexSelected "No name"
					morphMod[indexSelected][2].controller.value = 0.0
				)
			)			
		)--fn delTarget

		-----------------------------------------------
		--@fn: undefined | reallocateControls | recoloca los controles cuando se redimensiona la herramienta
		------------------------------------------------
		fn reallocateControls =
		(
			lvMorphList.height = rollMainDef.height - 68
			btnRefresh.pos.y = rollMainDef.height - 33
			btnClose.pos.y = rollMainDef.height - 33
			
			visibleItems = (((lvMorphList.height - 7.075)/14.15) as integer)
			endIndex = initIndex + visibleItems
		)--fn reallocateControls

		-----------------------------------------------
		--@fn: undefined | getOperateObjects | captura los objetos con los que hay que operar para grabar o cargar vertex Colors en función de la opción marcada en los radiobuttons
		------------------------------------------------
		fn getOperateObjects =
		(
			OBJs = #()
			
			case rdoSLoptions.state of 
			(
				1: ""
				2: OBJs = selection
				3: ""
			)
			
			OBJs
		)

		----------------------------------------------
		--@fn: undefined | saveTargetsVertexColors | guarda la informacion de los vertex colors
		------------------------------------------------
		fn saveTargetsVertexColors folder selectionOption = 
		(

			if folder != undefined then --si tiene un path definido
			(
				
				selChannels = #()
					
				--obtiene los canales de los que tiene que almacenar informacion
				case selectionOption of
				(
					1: for i=1 to 100 do append selChannels i
					2: 
					(
						for i = 1 to lvSelListItems.count do
						(
							appendifunique selChannels (lvSelListItems.item[i-1].index + 1)
						)
						sort selChannels
					)
				)
				
				targets = #() --array para guardar las cabezas
				targetsChannel = #() --array para guardar el canal al que pertenecia cada cabeza
				
				--si hay canales de los que guardar informacion busca las cabezas de las que guardar los vertex colors
				if selChannels.count != 0 then
				(
					cont = 1
					for ch in selChannels do --recorre los canales de los que guardar informacion
					(
						if WM3_MC_HasData morphMod ch then --si el canal tiene informacion de morph
						(
							numProgs = WM3_NumberOfProgressiveMorphs morphMod ch
							
							if numProgs != 0 then
							(
								for i=1 to numProgs do
								(
									targetNode = WM3_GetProgressiveMorphNode morphMod ch i
									if isValidNode targetNode then
									(
										append targets targetNode
										append targetsChannel ch
									)
								)--for
								
							)--if numProgs
						)
						cont += 1
					)--for
				)--if selChannels
				
				--si hay cabezas de las que extraer vertex colors
				if targets.count != 0 then
				(
					failedChannels = #()
					successChannels = #()
					
					pbSaveLoad.value = 0
					
					for t=1 to targets.count do
					(
						fileName = folder + "\\" + targets[t].name + ".vc"
						pbSaveLoad.value = (t*100)/targets.count
						if not lb.vertexColor.saveVertexColors targets[t] fileName then --salva el fichero de vertex colors
							appendIfunique failedChannels targetsChannel[t]
						else
							appendIfunique successChannels targetsChannel[t]
					)
					
					pbSaveLoad.value = 0
					
					--imprime un mensaje diciendo los ficheros que ha guardado y los que no ha podido guardar
					if failedChannels.count != 0 or successChannels.count != 0 then
					(
						messageText = ""
						messageText = messageText + (successChannels.count as string) + " vertex colors files saved.\n"
						if failedChannels.count != 0 then
							messageText = messageText + ("\nChannels " + ((failedChannels as bitArray) as string) + " couldn't be saved, probably they don't have vertex colors")
						lb.message.show messageText type:#message pos:undefined size:[300,75] modal:true
					)
						
				)--if targets
				
				
			)--if folder
		)

		----------------------------------------------
		--@fn: undefined | loadTargetsVertexColors | salva la informacion de los vertex colors
		------------------------------------------------
		fn loadTargetsVertexColors folder selectionOption = 
		(
			if folder != undefined then --si tiene un path definido
			(
				
				selChannels = #()
					
				--obtiene los canales de los que tiene que almacenar informacion
				case selectionOption of
				(
					1: for i=1 to 100 do append selChannels i
					2: 
					(
						for i = 1 to lvSelListItems.count do
						(
							appendifunique selChannels (lvSelListItems.item[i-1].index + 1)
						)
						sort selChannels
					)
				)
				
				targets = #() --array para guardar las cabezas
				targetsChannel = #() --array para guardar el canal al que pertenecia cada cabeza
				
				--si hay canales de los que guardar informacion busca las cabezas de las que guardar los vertex colors
				if selChannels.count != 0 then
				(
					cont = 1
					for ch in selChannels do --recorre los canales de los que guardar informacion
					(
						if WM3_MC_HasData morphMod ch then --si el canal tiene informacion de morph
						(
							numProgs = WM3_NumberOfProgressiveMorphs morphMod ch
							
							if numProgs != 0 then
							(
								for i=1 to numProgs do
								(
									targetNode = WM3_GetProgressiveMorphNode morphMod ch i
									if isValidNode targetNode then
									(
										append targets targetNode
										append targetsChannel ch
									)
								)--for
								
							)--if numProgs
						)
						cont += 1
					)--for
				)--if selChannels
				
				--si hay cabezas de las que extraer vertex colors
				if targets.count != 0 then
				(
					failedChannels = #()
					successChannels = #()
					
					pbSaveLoad.value = 0
					
					for t=1 to targets.count do
					(
						fileName = folder + "\\" + targets[t].name + ".vc"
						pbSaveLoad.value = (t*100)/targets.count
						if not lb.vertexColor.loadVertexColors targets[t] fileName then --salva el fichero de vertex colors
							appendIfunique failedChannels targetsChannel[t]
						else
							appendIfunique successChannels targetsChannel[t]
					)
					
					pbSaveLoad.value = 0
					
					--imprime un mensaje diciendo los ficheros que ha guardado y los que no ha podido guardar
					if failedChannels.count != 0 or successChannels.count != 0 then
					(
						messageText = ""
						messageText = messageText + (successChannels.count as string) + " vertex colors files loaded.\n"
						if failedChannels.count != 0 then
							messageText = messageText + ("\nChannels " + ((failedChannels as bitArray) as string) + " couldn't be loaded, probably they don't have vertex colors file asociated")
						lb.message.show messageText type:#message pos:undefined size:[300,75] modal:true
					)
						
				)--if targets
				
				
			)--if folder
		)

		----------------------------------------------
		--@fn: undefined | saveMorphInfo | salva la informacion del morph y de los canles en un fichero
		------------------------------------------------
		fn saveMorphInfo chkSettings chkChannels selectionOption folder =
		(
			
			if folder != undefined then --si tiene un path definido
			(
				--lastPath = folder --almacena el path para que la proxima vez salga por defecto
				filename = folder + "\\" + morphObj.name + ".mrphi"
				
				try (deleteFile filename) catch () --intenta eliminar el fichero si ya existe
				
				--guarda el nombre del objeto que lleva el morpher
				setINISetting filename "morpherInfo" "morphObj" morphObj.name
				setINISetting filename "morpherInfo" "sectionEnd" "-------------------------------------------------------------"
				
				messageText = "File \""  + filename + "\" created successfully\n"
				
				if chkSettings then --guarda los global settings
				(
					setINISetting filename "globalSettings" "useLimits" (morphMod.Use_Limits as string)
					setINISetting filename "globalSettings" "autoReload" (morphMod.Autoload_of_targets as string)
					setINISetting filename "globalSettings" "autoRename" (chkRenameTargets.checked as string)
					setINISetting filename "globalSettings" "extractSel" (rdoSelection.state as string)
					setINISetting filename "globalSettings" "autoReconnect" (chkAutoreconnect.checked as string)
					setINISetting filename "globalSettings" "sectionEnd" "-------------------------------------------------------------"
					
					messageText = messageText + "\nGlobal settings saved successfully\n"
				)
				
				if chkChannels then --guarda la informacion de los canales
				(
					selChannels = #()
					
					--obtiene los canales de los que tiene que almacenar informacion
					case selectionOption of
					(
						1: for i=1 to 100 do append selChannels i
						2: 
						(
							for i = 1 to lvSelListItems.count do
							(
								appendifunique selChannels (lvSelListItems.item[i-1].index + 1)
							)
							sort selChannels
						)
					)
					
					--si hay canales de los que guardar informacion
					if selChannels.count != 0 then
					(
						pbSaveLoad.value = 0
						cont = 1
						success = 0 --flag par aalmacenar en numero de canales guardados con exito
						for ch in selChannels do --recorre los canles
							if lvMorphList.items.item[ch - 1].subitems.item[1].text != "- empty -" then
							(
								category = ("channel_" + (ch as string))
								
								--guarda la informacion de cada canal
								setINISetting filename category "name" lvMorphList.items.item[ch - 1].subitems.item[1].text
								setINISetting filename category "value" lvMorphList.items.item[ch - 1].subitems.item[2].text
								
								if not progTargetDeleted morphMod ch then
								(
									headNames = #()
									headWeights = #()
									
									numProgs = WM3_NumberOfProgressiveMorphs morphMod ch
									for i=1 to numProgs do
									(
										append headNames (WM3_GetProgressiveMorphNode morphMod ch i).name
										append headWeights (WM3_GetProgressiveMorphWeight morphMod ch (WM3_GetProgressiveMorphNode morphMod ch i))
									)
									
									setINISetting filename category "morphs" (headNames as string)
									setINISetting filename category "weights" (headWeights as string)
								)
								
								setINISetting filename category "uselimits" ((WM3_MC_GetUseLimits morphMod ch) as string)
								setINISetting filename category "minLimit" ((WM3_MC_GetLimitMIN morphMod ch) as string)
								setINISetting filename category "maxLimit" ((WM3_MC_GetLimitMAX morphMod ch) as string)
								setINISetting filename category "end" "--------------------------------------------"
								
								pbSaveLoad.value = (cont*100)/selChannels.count
								cont +=1
								success += 1
							)
							
						pbSaveLoad.value = 0
						
						--indica que ha terminado con ese canal y pasa al siguiente
						setINISetting filename "EOF" "end" "-------------------------------------------------------------"
							
						if success != 0 then
							messageText = messageText + "\n" + success as string + " channels info saved successfully"
					)--if channels
									
				)--if chkChannels
				
				if messageText.count != 0 then
						lb.message.show messageText type:#message pos:undefined size:[300,75] modal:true				
			)--if folder
		)

		----------------------------------------------
		--@fn: undefined | loadMorphInfo | carga desde un fichero, la informacion de los canales y de los settings del morpher
		------------------------------------------------
		fn loadMorphInfo chkSettings chkChannels selectionOption file =
		(
			lastUsed = undefined
			
			if chkSettings or chkChannels then --comprueba si hay un path ya definido
			(

				sceneTargets = #()
				originalTarget = undefined
				
				emptyMorpher = true --flag para saber si el morpher esta vacio y hay que añadir canales o no
				
				if (lblNumChannels.caption as integer) != 0 then
					emptyMorpher = queryBox "Morpher modifier is not empty. Some channels will be overwritten. Do you want to continue?" title:"Morpher modifier"
							
				if emptyMorpher then --se cargan los canales desde el fichero
				(
					if file != undefined then --si hay fichero
					(
						--obtiene el nombre del objeto que llevaba el morpher al guardar el fichero
						fileMorphObj = getINISetting file "morpherInfo" "morphObj"
						
						if fileMorphObj.count != 0 then --si el fichero guarda informacion de morpher
						(
							--si el objeto que llevaba el morpher al guardar el fichero y el objeto que lleva el morpher ahora se llaman igual
							if morphObj.name == fileMorphObj then
							(
								--comprueba que el fichero tiene almacenadas global settings
								if chkSettings and ((getINISetting file "globalSettings" "sectionEnd").count != 0) then --carga los global settings
								(
									--carga los valores de global settings y valores comunes, y los asigna al morpher y a la herramienta
									
									--use limits-----------------------------------------------------------
									morphMod.Use_Limits = (getINISetting file "globalSettings" "useLimits") as integer
									chkUseLimits.checked = if morphMod.Use_Limits == 1 then true else false
									
									if not chkUseLimits.checked then
									(
										chkUseLimitsP.enabled = true
										if chkUseLimitsP.checked then
										(
											spnMinimum.enabled = true
											spnMaximum.enabled = true				
										)else(
											spnMinimum.enabled = false
											spnMaximum.enabled = false
										)			
									)else(
										spnMinimum.enabled = false
										spnMaximum.enabled = false
										chkUseLimitsP.enabled = false
									)
									-------------------------------------------------------------------------
									
									morphMod.Autoload_of_targets = (getINISetting file "globalSettings" "autoReload") as integer
									chkReloadTargets.checked = if morphMod.Autoload_of_targets == 1 then true else false
									
									chkRenameTargets.checked = (getINISetting file "globalSettings" "autoRename") as booleanClass
									
									rdoSelection.state = (getINISetting file "globalSettings" "extractSel") as integer
									chkAutoreconnect.checked = (getINISetting file "globalSettings" "autoReconnect") as booleanClass
									
									WM3_RefreshChannelListUI morphMod
									WM3_MC_SetUseLimits morphMod indexSelected chkUseLimitsP.checked
									WM3_RefreshChannelParamsUI  morphMod
								)---------------------------------------------------------------------------
								
								--para cada canal almacenado en el fichero
								if chkChannels then--------------------------------------------------
								(
									selChannels = #()
																		
									case selectionOption of --obtiene los canales para los que operar
									(
										1: for i=1 to 100 do append selChannels i --caso para todos
										2: --caso para los seleccionados
										(
											for i = 1 to lvSelListItems.count do
											(
												appendifunique selChannels (lvSelListItems.item[i-1].index + 1)
											)
											sort selChannels
										)
									)
									
									--arrays donde almacenar los targets que hay en escena y sus nombres
									sceneTargets = #()
									sceneTargetNames = #()
									
									--busca todas los targets posibles en la escena
									for obj in objects do
									(
										if  (obj.name == "originalMorph") or (checkNamingConvention obj.name) then
										(
											append sceneTargets obj
											append sceneTargetNames obj.name
										)
									)
									
									--si hay targets en la escena
									if sceneTargets.count != 0 then
									(
									
										fails = #() --array para almacenar los canales cuya carga haya fallado
										success = 0 --flag para almacenar los canales cuya carga ha sido exitosa
										
										pbSaveLoad.value = 0
																				
										for i=1 to selChannels.count do --recorre los canales a cargar
										(
											channelTag = "channel_" + selChannels[i] as string
											
											channelName =		(getINISetting file channelTag "name") as string
																					
											--si hay informacion del canal, obtiene el resto de campos
											if channelName.count != 0 then
											(
												channelValue =		(getINISetting file channelTag "value") as float
												channelMorphs =		(getINISetting file channelTag "morphs") as string
												channelWeights =	(getINISetting file channelTag "weights") as string
												channelUseLimits =	(getINISetting file channelTag "uselimits") as booleanClass
												channelMinLimit =	(getINISetting file channelTag "minLimit") as float
												channelMaxLimit =	(getINISetting file channelTag "maxLimit") as float
												
												channelMorphs = filterString channelMorphs "#(\", )"
												channelWeights = filterString channelWeights "#(\", )"
												
												--busca los nodos de la escena que sean los que tiene que cargar
												nodes = #()
												for mph in channelMorphs do
												(
													index = findItem sceneTargetNames mph
													if index != 0 then
													(
														append nodes sceneTargets[index]
														
													)
													else
														appendifunique fails selChannels[i]
												)
												
												--si ha encontrado los nodos adecuados de la escena, añade los targets al canal y rellena el resto de campos
												if nodes.count == channelMorphs.count then
												(
													WM3_MC_Delete morphMod selChannels[i]
													
													for j=1 to nodes.count do
														addTarget morphMod selChannels[i] nodes[j]
													
													for j=1 to nodes.count do
														WM3_SetProgressiveMorphWeight morphMod selChannels[i] nodes[j] (channelWeights[j] as float)
													
													WM3_MC_SetName morphMod selChannels[i] channelName
													WM3_MC_SetValue morphMod selChannels[i] channelValue
													WM3_MC_SetUseLimits morphMod selChannels[i] channelUseLimits
													WM3_MC_SetLimitMIN morphMod selChannels[i] channelMinLimit
													WM3_MC_SetLimitMAX morphMod selChannels[i] channelMaxLimit
													
													success +=1
												)
												
											)
											else
												WM3_MC_Delete morphMod selChannels[i]
											
											pbSaveLoad.value = (i*100)/selChannels.count
										)
										
										pbSaveLoad.value = 0
										
										messageText = success as string + " channels loaded successfully"
										
										--si ha fallado alguna carga, lo avisa
										if fails.count != 0 then
										(
											messageText = messageText + "\nchannels"
											for i=1 to fails.count do
												messageText = messageText + ", " + (fails[i] as string)
											messageText = messageText + ", failed at loading"
										)
										lb.message.show messageText type:#message pos:undefined size:[300,75] modal:true
										
									)--if sceneTargets
									else
										lb.message.show "There are no targets to load in scene" type:#message pos:undefined size:[300,75] modal:true				
								)----------------------------------------------------------------------------								
								
							)
							else
								lb.message.show "Loaded info doesn't match morpher name" type:#message pos:undefined size:[300,75] modal:true
						)
						else
							lb.message.show "No morpher info found" type:#message pos:undefined size:[300,75] modal:true
					)
				)
			
			)--if chks	
		)

		----------------------------------------------
		--@fn: undefined | getTargets | llena los canales de morph con los targets que haya en escena, necesita que se le pase un modificador morph que rellenar
		------------------------------------------------
		fn getTargets morphModifier morphObject numChannels=
		(
			sceneTargets = #()
			originalTarget = undefined
			
			side = (filterString morphObject.name "_")[4] --para saber si es r, l, m o x
			type = (filterString morphObject.name "_")[5] --para saber si es de tipo head, hair o tongue
			
			emptyMorpher = true --flag para saber si el morpher esta vacio y hay que añadir canales o no
			
			if numChannels != 0 then
				emptyMorpher = queryBox "Morpher modifier is not empty. Do you want to reset it?" title:"Morpher modifier"
			
			_foundVariations = false
			if emptyMorpher then
			(
				for n=1 to 100 do
				(
					_name = WM3_MC_GetName morphModifier n
					if _name != undefined then
					(
						if MatchPattern _name pattern: lb.nc.NC_morphVariationPattern then 
						(
							_foundVariations = true 
						)
					)
				)

				_keepVariations = false
				if _foundVariations then
				(
					_keepVariations = lb.message.show "Variations found, wanna keep them?" type:#query
				)
			)

			--si el modificador esta vacio o hay que vaciarlo
			if emptyMorpher then
			(
				auxParts = filterString morphObject.name "_"

				--busca todas los targets posibles en la escena
				for obj in objects do
				(
					tempName = getMorphName obj.name
					
					if  (tempName == "x_original") then
						originalTarget = obj
					else if (checkNamingConvention obj.name) and findString obj.name ("_" + lb.nc.NC_classMorph + "_") != undefined then
					(
			-- 						if obj.name == "chr_mummy_morph_r_bandage-all-vt-up_x_x" then
			-- 							print type
						
						flag = false
						
						mNameParts = morphNameParts tempName
						
						case type of --mira de que tipo es el objeto que lleva el morph y solo busca morphs acordes a el
						(
							"hair":
							(
								case mNameParts[2] of
								(
									"hair":		flag = true
								)
							)
							
							"tongue":
							(
								case mNameParts[2] of
								(
									"tongue":	flag = true
								)
							)
							
							"headFFD":
							(
								case mNameParts[2] of
								(
									"ffdskl":		flag = true
									"ffdjaw":		flag = true
									"ffdnose":	flag = true
								)
								
								if flag then
									case mNameParts[3] of
									(
										"hair":	flag = false
									)
							)
							
							"headFFD-upper":
							(
								case mNameParts[2] of
								(
									"ffdskl":		flag = true
								)
								
								if flag then
									case mNameParts[3] of
									(
										"hair":	flag = false
									)
							)
							
							"headFFD-lower":
							(
								case mNameParts[2] of
								(
									"ffdjaw":		flag = true
								)
								
								if flag then
									case mNameParts[3] of
									(
										"hair":	flag = false
									)
							)
							
							"hairFFD":
							(
								case mNameParts[2] of
								(
									"ffdskl":		flag = true
									"ffdjaw":		flag = true
								)
								
								if flag then
									case mNameParts[3] of
									(
										"all":	flag = false
									)
							)
							
							"ebwFFD":
							(
								case mNameParts[2] of
								(
									"ffdebw":	flag = true
								)
							)
							
							"eyeFFD":
							(
								case mNameParts[2] of
								(
									"ffdeye":	if side == mNameParts[1] then flag = true
								)
							)
							
							"head":
							(
								case mNameParts[2] of
								(
									"ebw":		flag = true
									"frown":		flag = true
									"eld":			flag = true
									"chb":		flag = true
									"nose":		flag = true
									"lip":			flag = true
									"lipsync":	flag = true
									"beak":		flag = true
									"jaw":		flag = true
									"eye":		flag = true
									"bandage":	flag = true
								)
							)
							
							"eyelidUpper":
							(
								case mNameParts[2] of
								(
									"eld": if side == mNameParts[1] and (findString mNameParts[3] "upper" != undefined) then flag = true
								)
							)
							
							"eyelidLower":
							(
								case mNameParts[2] of
								(
									"eld": if side == mNameParts[1] and (findString mNameParts[3] "lower" != undefined) then flag = true
								)
							)
							
							"eye":
							(
								case mNameParts[2] of
								(
									"eye": if side == mNameParts[1] then flag = true
								)
							)
							
							"teethLower":
							(
								case mNameParts[2] of
								(
									"teethLower": flag = true
								)
							)
						)------------------------------------------------------------------
						
						if flag then append sceneTargets obj
					)--if namingconvention
				)--for objects
				
				--ordena por nombre los targets encontrados
				qsort sceneTargets compareMorphs
				
				if sceneTargets.count == 0 then
				(
					emptyMorpher = false
					lb.message.show "No morpher targets found in scene" type:#message pos:undefined size:[300,75] modal:true
				)
				
			)--if emptyMorpher
			
			--si el modificador esta vacio o hay que vaciarlo
			if emptyMorpher then
			(
				_limit = 100
				if classof morphModifier == Morph_O_Matic then _limit = MOM_GetNumChannels morphModifier
				
				--vacia todos los canales del modificador
				for i=1 to _limit do
				(
					case classof morphModifier of
					(
						morpher: 
						(
							_name = WM3_MC_GetName morphModifier i
							if _name != undefined then
							(
								if MatchPattern _name pattern: lb.nc.NC_morphVariationPattern then 
								(
									if not _keepVariations then
										WM3_MC_Delete morphModifier i
								)
								else
								(
									WM3_MC_Delete morphModifier i
								)
							)
						)
						Morph_O_Matic: MOM_ClearChannel morphModifier i
					)
				)--for
				
				--primer canal donde introducir un target
				channelIndex = 1
				
				--flag para saber si se ha introducido la cabeza original como target
				flagOriginalMorph = false
				
				numChannels = 0 --variable para almacenar los canales que se van llenando
				
				auxParts = filterString morphObject.name "_"
				
				--si el modificador es de tipo Morph_O_Matic establece el numero exactod e canales que necesita.
				if classof morphModifier == Morph_O_Matic then MOM_SetNumChannels morphModifier (sceneTargets.count)
				
				--recorre los targets introduciendolos en orden
				for i=1 to sceneTargets.count do
				(
					--obtiene las partes del nombre
					
					tempName = getMorphName sceneTargets[i].name
					
					mNameParts = morphNameParts tempName
					mNamePartsBefore = undefined
					
					--si no es el primer target, obtiene las partes del anterior para comparar
					if i > 1 then
					(
						tempName = getMorphName sceneTargets[i-1].name

						mNamePartsBefore = morphNameParts tempName
					)
					
					--si tiene partes con las que comaprar
					if mNamePartsBefore != undefined then
						if mNameParts.count != 0 and mNamePartsBefore.count != 0 then
						(
							--si hay cambio de parte de la cara
							if mNameParts[2] != mNamePartsBefore[2] then
							(
								channelIndex += 0 --1 --2 --deja dos canales libres
								flagOriginalMorph = false
							)
							else --si no hay cambio de parte de la cara
							(
								if mNameParts[5] != mNamePartsBefore[5] then
								(
									--casos en los que no debe dejar espacio
			-- 									case mNameParts[3] of
			-- 									(
			-- 										"upperMid": channelIndex -= 1
			-- 										"upperExt": channelIndex -= 1
			-- 										"lowerMid": channelIndex -= 1
			-- 										"lowerExt": channelIndex -= 1
			-- 									)
									
									if mNameParts[1] != mNamePartsBefore[1] then
										channelIndex += 0 --1 --deja un canal libre
									
									flagOriginalMorph = false
								)
							)
						)
					
					--flag para almacenar si es o no progresivo
					flag = false
					
					--si es progresivo añade los targets al mismo canal
					if mNameParts[6] != undefined then
					(
						mPercent = filterString mNameParts[6] "po"
						
						if mPercent.count == 1 then
						(
							if mNamePartsBefore != undefined then
							(
								if (mNameParts[2] == mNamePartsBefore[2]) and (mNameParts[3] == mNamePartsBefore[3]) and (mNamePartsBefore[6] != undefined) then
								(
									flag = true
									channelIndex -= 1
								)
							)
							else
								flag = true
						)										
					)
					
					--añade los targets
					if flag then
					(
						addTarget morphMod channelIndex sceneTargets[i]
						--WM3_MC_SetValue morphModifier channelIndex 10.0
					)
					else
					(
						case classof morphModifier of
						(
							morpher:
							(
								--flagOriginalMorph = false
								WM3_MC_BuildFromNode morphModifier channelIndex sceneTargets[i]
								
								tempName = getMorphName (WM3_MC_GetName morphModifier channelIndex)
													
								WM3_MC_SetName morphModifier channelIndex tempName
								numChannels += 1
							)
							
							Morph_O_Matic:
							(
								MOM_MC_InsertTarget morphModifier[channelIndex] 2 sceneTargets[i]
								
								tempName = getMorphName sceneTargets[i].name
								
								MOM_SetChannelName morphModifier channelIndex tempName
								numChannels += 1
							)
						)--case
					)
					
					--incrementa el contador
					channelIndex += 1					
				)--for para añadir los canales al morph
				
				--elimina todas las filas del listado y lo redibuja
				if classof morphModifier == Morph_O_Matic then
				(
					MOM_SetNumChannels morphModifier numChannels 					
					fillListView()
				)
				lb.message.show (numChannels as string + " channels filled") type:#message pos:undefined size:[300,75] modal:true
			)--if emptyMorpher	
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
		--@gets: point2 | size | Tamaño nuevo del rollout
		------------------------------------------------
		fn resize size =
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
				lvMorphList.height = 530 + _increment.y
				btnRefresh.pos.y = 565 + _increment.y
				btnClose.pos.y = 565 + _increment.y
			
				visibleItems = (((lvMorphList.height - 7.075)/14.15) as integer)
				endIndex = initIndex + visibleItems

				parent.rollMaskConnection.height = parent.rollMain.height - 3
		
			)--if

		)

		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("tool/rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("tool/rollMain/pos") "y") as integer
				
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

		on btnGetTargets pressed do
		(
			setWaitCursor()
			
			if ckbMorphMode.checked then
				getTargets morphMod morphObj (lblNumChannels.caption as integer)
			else if ckbBonesMode.checked then
			(
				faceShapeControls = getFaceShapeControls()
				numChannels = faceShapeControls.count
				fillListView()
				lb.message.show (numChannels as string + " channels filled") type:#message pos:undefined size:[300,75] modal:true
			)			
			
			setArrowCursor()
		)

		on btnEdit pressed do showTextBox()

		on btnZero pressed do setTargetsValue 0
		
		on btnZeroAll pressed do setTargetsValue 0 allTargets:true

		------------------------------------------------
		--@event: MouseDown | detecta si se pulsa algun boton del raton sobre el listview
		------------------------------------------------
		on lvMorphList MouseDown events do
		(
			btn = events.button.toString() --almacena que boton se ha pulsado
			item = (lvMorphList.getItemAt 5 events.y) --almacena el item sobre el que se ha pulsado
			lvSelListItemsOld = lvSelListItems
			
			--guarda la seleccion actual para deseleccionarla y cambiar los colores de la misma
			selChannels = #()
			for i = 1 to lvSelListItems.count do
				appendifunique selChannels (lvSelListItems.item[i-1].index + 1)
			sort selChannels
			
			deleteModChangeHandler() --destruye el handler
			
			if ckbMorphMode.checked then
			(
				if btn == "Left" then --si es el boton izquierdo
				(
					if not midDragging then --si no se esta haciendo middragging
					(
						leftDragging = true --activa el flag de leftdragging
						if item != undefined then
						(
							(selStartIndex = item.index; selEndIndex = item.index)  --inicializa los indices de seleccion
						)
					)
					else -- si se esta haciendo middragging
					(
						stopValueChange true --para el cambio de valores
						midDragging = false --desactiva el flag de middragging
						--restaura los limites de accion del cursor
						cursor.clip = dotnetobject "system.drawing.rectangle" 0 0 (systemtools.getscreenwidth()) (systemtools.getscreenheight())
					)
				)
				
				if btn == "Middle" then --si es el boton central
				(	
					-- si hacemos MMB sobre un item no seleccionado, borramos la selección
					-- y seleccionamos solo ese item
					i = 1
					encontrado = false
					while not encontrado and i <= lvSelListItems.count do
					(
						if lvSelListItems.item[i-1] == item then encontrado = true
						i += 1
					)
					
					if not encontrado then
					(
						lvSelListItems.clear()
						if item != undefined then item.selected = true					
					)
					
					if not rollMaskConnectionOpen then
					(
						case classof morphMod of
						(
							morpher:
							(
								--si el canal seleccionado no esta vacio
								if (WM3_MC_HasData morphMod (item.index + 1)) != false then
								(
									-- inicia el modo midDragging
									midDragging = true
									dragCoords = [(cursor.position).x,(cursor.position).y]--calcula las coordenadas del dragging
									dragValue = 0
									--restringe los limites de accion del raton
									cursor.clip = dotnetobject "system.drawing.rectangle" ((getDialogPos rollMainDef).x + lvMorphList.pos.x + 5) ((cursor.position).y) (lvMorphList.width - 25) 1
									startValueChange()
								)
							)
							
							Morph_O_Matic:
							(
								_process = false
								_numTargets = MOM_MC_GetNumTargets morphMod[(item.index + 1)]
								if _numTargets > 1 then _process = true
								if not _process and _numTargets == 1 and (MOM_MC_TARG_GetName morphMod[(item.index + 1)] 1) != "Original" and (MOM_MC_TARG_GetName morphMod[(item.index + 1)] 1) != "O" then _process = true
								if _process then
								(
									-- inicia el modo midDragging
									midDragging = true
									dragCoords = [(cursor.position).x,(cursor.position).y]--calcula las coordenadas del dragging
									dragValue = 0
									--restringe los limites de accion del raton
									cursor.clip = dotnetobject "system.drawing.rectangle" ((getDialogPos rollMainDef).x + lvMorphList.pos.x + 5) ((cursor.position).y) (lvMorphList.width - 25) 1
									startValueChange()
								)
							)
						)
					)
				)
				
				if btn == "Right" then
				(
					if item != undefined and item.subitems.item[1].text != "- empty -" then
					(
						if midDragging then --si se esta haciendo middragging
						(
							midDragging = false --desactiva el flag de middragging
							--restaura los limites de accion del cursor
							cursor.clip = dotnetobject "system.drawing.rectangle" 0 0 (systemtools.getscreenwidth()) (systemtools.getscreenheight())
							--stopValueChange true --para el cambio de valores
							
							case classof morphMod of
							(
								morpher:
								(
									for i = 1 to changingItems.count do
									(
										index = changingItems[i].index + 1
										WM3_MC_SetValue morphMod index oldValues[i]
									)
								)
								
								Morph_O_Matic:
								(
									for i = 1 to changingItems.count do
									(
										index = changingItems[i].index + 1
										morphMod[index].controller.value = oldValues[i]
									)
								)
							)--case
							
							updateListView()
						)
					)
				)--if btn
			)
			
			--actualizacion de los colores de los listviews
			if item != undefined then
			(
				if rollMaskConnectionOpen then
				(
					(selStartIndex = item.index; selEndIndex = item.index)  --inicializa los indices de seleccion
					lvSelectRange selStartIndex selEndIndex
					parent.rollMaskConnection.lvSelectRange selStartIndex selEndIndex
					parent.rollMaskConnection.updateRowsColor (item.index +1) false
					
					--Actualiza los calores del shaoe seleccionado
					parent.rollMaskConnection.updateShapeValues (item.index + 1)
				)
				
				--Actualiza los valores de Channel Settings segun el canal seleccionado
				if ckbMorphMode.checked then
				(
					SelChannel (item.index + 1)
					indexSelected = (item.index + 1)
					updateChannelSettings (item.index + 1)
				)
			)
			
			for i=1 to selChannels.count do
			(
				updateRowsColor lvMorphList selChannels[i] true
				if rollMaskConnectionOpen then parent.rollMaskConnection.updateRowsColor selChannels[i] false
			)			
			-----------------------------------------------------
			
			getLvSelectedListItems() --actualiza la seleccion
		)--on lvMorphList

		------------------------------------------------
		--@event: mouseUp | detecta si se suelta algun boton del raton sobre el listview
		------------------------------------------------
		on lvMorphList mouseUp events do
		(
			btn = events.button.toString()
			item = (lvMorphList.getItemAt 5 events.y)
			
			if rollMaskConnectionOpen and dragged and btn != "Middle" then
				parent.rollMaskConnection.lvSelectRange selStartIndex selEndIndex
			
			if ckbMorphMode.checked then
			(
				dragged = false
				
				if leftDragging then --si se esta haciendo leftdragging
				(
					leftDragging = false --desactiva el flag de leftdragging
				)
				
				if midDragging and btn == "Middle" then --si se esta haciendo middragging
				(
					midDragging = false --desactiva el flag de middragging
					--restaura los limites de accion del cursor
					cursor.clip = dotnetobject "system.drawing.rectangle" 0 0 (systemtools.getscreenwidth()) (systemtools.getscreenheight())
					stopValueChange() --para de hacer cambios de valor
				)
			)
			
			getLvSelectedListItems() --actualiza la seleccion
			
			--seleccionar el canal de morpher correspondiente al item del listview seleccionado
			if item != undefined then
			(
				if ckbMorphMode.checked then
					SelChannel (item.Index + 1)
				indexSelected = (item.Index + 1)
				
				--Actualiza los valores de Channel Settings segun el canal seleccionado
				if ckbMorphMode.checked then
					updateChannelSettings (item.Index + 1)
				
				if rollMaskConnectionOpen then
					parent.rollMaskConnection.updateShapeValues (item.Index + 1)
			)
			else
			(
				lvMorphList.items.item[indexSelected-1].selected = true
				if rollMaskConnectionOpen then
					parent.rollMaskConnection.lvSelectRange (indexSelected-1) (indexSelected-1)
			)
			
			--actualizacion de los colores de los lisviews
			
			if rollMaskConnectionOpen then
			(
				selChannels = #()
				for i = 1 to lvSelListItems.count do
					appendifunique selChannels (lvSelListItems.item[i-1].index + 1)
				sort selChannels
				
				for i=1 to selChannels.count do
					parent.rollMaskConnection.updateRowsColor selChannels[i] false
			)
			
			-----------------------------------------------------	
			
			createModChangeHandler() --crea el handler
		)--on lvMorphList

		------------------------------------------------
		--@event: mouseMove | detecta si el cursor del raton se esta moviendo
		------------------------------------------------
		on lvMorphList mouseMove events do
		(
			item = (lvMorphList.getItemAt 5 events.y) --almacena el elemento del listview sobre el que se encuentra el cursor
			
			if ckbMorphMode.checked then
			(
				if leftDragging then --si se esta haciendo leftdragging
				(
					--item = (lvMorphList.getItemAt 5 events.y) --almacena el elemento del listview sobre el que se encuentra el cursor
					--actualiza los limites de seleccion y selecciona el rango
					if item != undefined and selEndIndex != item.index then
					(
						selEndIndex = item.index
						lvSelectRange selStartIndex selEndIndex
						
						if rollMaskConnectionOpen then
							parent.rollMaskConnection.lvSelectRange selStartIndex selEndIndex
						dragged = true
					)
				)
				
				if midDragging then --si se esta haciendo middragging
				(
					dragged = true
					
					cursor.current = (dotnetclass "System.Windows.Forms.Cursors").sizeWE 
					--obtiene la posicion actual del cursor
					mousePos = dotNetobject "System.Drawing.Point" 	(cursor.position).x (cursor.position).y
					
					offset = 25
					
					multiplier = if keyboard.altPressed then 0.2 else if keyboard.controlPressed then 10 else 1
					inc = (mousePos.x - dragCoords.x) --calcula el valor de cambio
					dragValue += inc
					
					---------------------------------------------------------------
					--si el cursor sale de los limites, reaparece al otro lado
					if mousePos.x > (getDialogPos rollMainDef).x + lvMorphList.width + lvMorphList.pos.x - offset then 
					(
						mousePos.x = (getDialogPos rollMainDef).x + (lvMorphList.pos.x + offset) 
						cursor.position = mousePos
					)
					
					if mousePos.x < (getDialogPos rollMainDef).x + lvMorphList.pos.x + offset then 
					(
						mousePos.x = (getDialogPos rollMainDef).x + (lvMorphList.pos.x + lvMorphList.width - offset) 
						cursor.position = mousePos
					)
					
					dragCoords.x = mousePos.x
					---------------------------------------------------------------
					
					if inc != 0 then
						valueChange (dragValue * multiplier) --cambia el valor
				)
			)
		)

		------------------------------------------------
		--@event: MouseWheel | detecta si se esta moviendo por la lista con la rueda del raton
		------------------------------------------------
		on lvMorphList MouseWheel events do
		(
			if rollMainDef.ckbMorphMode.checked then
			(
				deleteModChangeHandler()
			
				_endLimit = 100
				if ckbBonesMode.checked then _endLimit = lvMorphList.items.count
				
				--calcula el primer y ultimo elemento visible
				if events.delta < 0 then
				(
					initIndex += 3
					endIndex += 3
					
					if endIndex > _endLimit then
					(
						endIndex = (_endLimit + 1)
						initIndex = endIndex - visibleItems + 1
					)
				)
				else
				(
					initIndex -= 3
					endIndex -= 3

					if initIndex < 1 then
					(
						initIndex = 1
						endIndex = initIndex + visibleItems - 1
					)
				)
				
				if rollMaskConnectionOpen then
				(
					parent.rollMaskConnection.lvMaskList.ensurevisible (if (initIndex-2) < 0 then 0 else (initIndex-2))
					parent.rollMaskConnection.lvMaskList.ensurevisible (endIndex-2)
				)
				
				createModChangeHandler()
			)
		)

		------------------------------------------------
		--@event: lostfocus | ejecucion al perder el foco
		------------------------------------------------	
		on lvMorphList lostfocus do
		(
			if edtValue.visible then
			(
				keyBuffer = ""
				edtValue.visible = false
				updateListView()
			)
		)

		------------------------------------------------
		--@event: keyDown | ejecucion al presionar una tecla
		------------------------------------------------			
		on lvMorphList keyDown events do
		(
			key = events.keydata.tostring()
			
 			case key of
 			(
				"ShiftKey, Shift" : (ckbRelativeAbsolute.checked = true; ckbRelativeAbsolute.caption = "Abs")
				"NumPad0": 	if not edtValue.visible then setTargetsValue 0
				"E": (if (lvSelListItems.count > 0) and not edtValue.visible then showTextBox())
 			)
		)

		------------------------------------------------
		--@event: keypress | si se presiona una tecla el el listado
		------------------------------------------------			
		on lvMorphList keypress events do 
		(
			
			events.handled = true	-- activar esta propiedad evita que el listado busque pistas cuyo
											-- nombre comience por la tecla pulsada
			key = events.keychar
			
			if 	(lvSelListItems.count > 0) and edtValue.visible then
					if (key >= "0" and key <= "9") or 
					((key == "." or key == ",") and not (findstring keyBuffer "." != undefined)) or
					(key == "-" and (keyBuffer == "")) then
					(
						if key == "," then key = "."
						append keyBuffer key
						updateEditValues()
					)			
		)

		------------------------------------------------
		--@event: keyUp | si se levanta una tecla en el listado
		------------------------------------------------			
		on lvMorphList keyUp events do
		(
			events.handled = true	-- no permitimos que el listview maneje este evento para evitar problemas
											-- como que al pulsar alt se pierda el foco del control

			key = events.keydata.tostring()
			
			case key of
			(
				"ShiftKey" : (ckbRelativeAbsolute.checked = false; ckbRelativeAbsolute.caption = "Rel")
				"Return":
				(
					edtValue.hide()
					edtValue.pos += [1,1]
					if keyBuffer != "" then
					(
						startValueChange()
						valueChange (keyBuffer as float) absolute:true
						stopValueChange()
						keyBuffer = ""
					)
				)
				"Escape":
				(
					edtValue.hide()
					edtValue.pos.x += 1
					keyBuffer = ""
				)
			)
		)

		------------------------------------------------
		--@event: mouseUp | detecta si se ha soltado el raton sobre el listview de targets
		------------------------------------------------			
		on lvChannelList mouseUp events do
		(
			btn = events.button.toString()
			item = undefined
			item = (lvChannelList.getItemAt 5 events.y)

			--seleccionar el canal de morpher correspondiente al item del listview seleccionado
			targetSelected = 1
			if item != undefined then
			(
				targetSelected = (item.Index + 1)
				
				--updateSetNewWeight()
			)						
		)--on lvChannelList

		------------------------------------------------
		--@event: ItemSelectionChanged | actualiza la seleccion de items
		------------------------------------------------			
		on  lvMorphList ItemSelectionChanged do
		(
			lvSelListItems = lvMorphList.SelectedItems
		)

		------------------------------------------------
		--@event: GotFocus | detecta si el listview ha recuperado el focus
		------------------------------------------------
		on lvMorphList GotFocus events do
		(
			if ckbMorphMode.checked then
			(
				_limit = 100
				if classof morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels morphMod
				for i=1 to _limit do (updateRowsColor lvMorphList i true)
			)
			else if ckbBonesMode.checked then
			(
				for i=1 to lvMorphList.items.count do (updateRowsColor lvMorphList i true)
			)
		)

		------------------------------------------------
		--@event: LostFocus | detecta si el listview ha perdido el foco
		------------------------------------------------
		on lvMorphList LostFocus events do
		(
			if ckbMorphMode.checked then
			(
				_limit = 100
				if classof morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels morphMod
				for i=1 to _limit do (updateRowsColor lvMorphList i false)
			)
			else if ckbBonesMode.checked then
			(
				for i=1 to lvMorphList.items.count do (updateRowsColor lvMorphList i false)
			)
		)

		------------------------------------------------
		--@event: GotFocus | detecta si el listview ha recuperado el foco
		------------------------------------------------
		on lvChannelList GotFocus events do
			for i=1 to lvChannelList.items.count do (updateRowsColor lvChannelList i true)

		------------------------------------------------
		--@event: LostFocus | detecta si el listview ha perdido el foco
		------------------------------------------------
		on lvChannelList LostFocus events do
			for i=1 to lvChannelList.items.count do (updateRowsColor lvChannelList i false)

		------------------------------------------------
		--@event: picked | seleccion de un objeto de la escena con morpher
		------------------------------------------------
		on btnPickObject picked obj do 
		(
			if ckbMorphMode.checked then
			(
				deleteModChangeHandler()
				
				morphMod = undefined
				morphObj = undefined
				chrNode = undefined
				
				_limit = 100
				
				for m in obj.modifiers do
				(
					if classof m == morpher or classof m == Morph_O_Matic then 
					(
						if classof m == Morph_O_Matic then _limit = MOM_GetNumChannels m
						
						morphMod = m
						morphObj = obj
						chrNode = obj
						createModChangeHandler()
						chkbtnMaskConnection.enabled = true
					)
				)--for
					
				if morphMod != undefined then
				(
					lvMorphList.Clear()
					initListView lvMorphList
					fillListView()
					if lvMorphList.items.count > 0 then
					(
						lvMorphList.items.item[0].selected = true
						indexSelected = 1
						for i=1 to _limit do (updateRowsColor lvMorphList i false)
						lvChannelList.Clear()
						fillChannelList indexSelected
						for i=1 to lvChannelList.items.count do (updateRowsColor lvChannelList i false)
					)
					lvMorphList.enabled = true
					lvChannelList.enabled = true
					
					----------------------------------------------------------------------------------------------------
					case classof morphMod of
					(
						morpher:
						(
							chkReloadTargets.checked = if morphMod.Autoload_of_targets == 1 then true else false
							chkUseLimits.checked = if morphMod.Use_Limits == 1 then true else false
						)
						
						Morph_O_Matic:
						(
							chkReloadTargets.checked = morphMod.autoloadTargets
							chkUseLimits.checked = morphMod.useLimits
						)				
					)
					
					if not chkUseLimits.checked then
					(
						chkUseLimitsP.enabled = true
						if chkUseLimitsP.checked then
						(
							spnMinimum.enabled = true
							spnMaximum.enabled = true				
						)else(
							spnMinimum.enabled = false
							spnMaximum.enabled = false
						)			
					)else(
						spnMinimum.enabled = false
						spnMaximum.enabled = false
						chkUseLimitsP.enabled = false
					)
					-------------------------------------------------------------------------

					createModChangeHandler()
				)
				else
				(
					chkbtnMaskConnection.enabled = true
					lvMorphList.enabled = false
					lvChannelList.enabled = false
				)
			)
			else if ckbBonesMode.checked then
			(
				deleteModChangeHandler()
				
				morphMod = undefined
				morphObj = undefined
				chrNode = undefined
				
				createModChangeHandler()
				
				if lb.nc.ncOK obj.name type:#object then
				(
					chrNode = obj
					_chrParts = filterString chrNode.name "_"
					btnPickObject.caption = ""
					btnPickObject.caption = (_chrParts[1] + "_" + _chrParts[2])
					faceShapeControls = getFaceShapeControls()
					fillListView()
					lvMorphList.enabled = true
					
					if lvMorphList.items.count > 0 then
					(
						lvMorphList.items.item[0].selected = true
						indexSelected = 1
						for i=1 to lvMorphList.items.count do (updateRowsColor lvMorphList i false)
					)
					
					chkbtnMaskConnection.enabled = true
					createModChangeHandler()
				)
				else
				(
					chkbtnMaskConnection.enabled = true
					lvMorphList.enabled = false
				)
			)		
		)--on btnPickObject

		------------------------------------------------
		--@event: pressed | mover los canales hacia arriba
		------------------------------------------------
		on btnMoveUp pressed do 
		(
			if morphMod != undefined then
 			(
				moveTargetsUp()
				
				_limit = 100
				if classof morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels morphMod
				for i=1 to _limit do (updateRowsColor lvMorphList i false)
			)
		)

		------------------------------------------------
		--@event: pressed | mover los canales hacia abajo
		------------------------------------------------
		on btnMoveDown pressed do 
		(
			if morphMod != undefined then
 			(
				moveTargetsDown()
				
				_limit = 100
				if classof morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels morphMod
				for i=1 to _limit do (updateRowsColor lvMorphList i false)
			)
		)	

		------------------------------------------------
		--@event: pressed | mover los canales a la posicion indicada
		------------------------------------------------
		on btnMoveTo pressed do
		(
			if morphMod != undefined then
 			(
				_limit = 100
				if classof morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels morphMod
					
				maxPos = 1
				minPos = 100
				if classof morphMod == Morph_O_Matic then minPos = MOM_GetNumChannels morphMod
				newPos = spnTargetChannel.value
				
				for i = 1 to lvSelListItems.count do
				(
					index = lvSelListItems.item[i-1].index + 1
					if index > maxPos then maxPos = index
					if index < minPos then minPos = index
				)
				
				dif = newPos - minPos
				
				if newPos > minPos then 
					if (maxPos + dif) <= _limit then
						moveTargetsDown numPos:dif
				
				if newPos < minPos then
					moveTargetsUp numPos:-dif
				
				for i=1 to _limit do
				(
					updateRowsColor lvMorphList i false
					if rollMaskConnectionOpen then
						parent.rollMaskConnection.updateRowsColor i false
				)
									
			)				
		)--on btnMoveTo

		------------------------------------------------
		--@event: changed | habilita o deshabilita los spinners de limite en funcion de un estado u otro
		------------------------------------------------
		on chkUseLimitsP changed State do
		(
			if morphMod != undefined then
 			(
				if chkUseLimitsP.checked then
				(
					spnMinimum.enabled = true
					spnMaximum.enabled = true				
				)else(
					spnMinimum.enabled = false
					spnMaximum.enabled = false
				)
				
				--refresca el modificador
				case classof morphMod of
				(
					morpher:
					(
						WM3_MC_SetUseLimits morphMod indexSelected chkUseLimitsP.checked
						WM3_RefreshChannelParamsUI  morphMod
					)
					
					Morph_O_Matic:
					(
						morphMod[indexSelected].useLimits = chkUseLimitsP.checked
					)
				)--case
			)
		)--on chkUseLimitsP

		------------------------------------------------
		--@event: changed | habilita o deshabilita los spinners de limite y el check de limite de canal, en funcion de un estado u otro
		------------------------------------------------
		on chkUseLimits changed State do
		(
			if morphMod != undefined then
 			(
				case classof morphMod of
				(
					morpher:
					(
						morphMod.Use_Limits = (if chkUseLimits.checked then 1 else 0)
						--refresca el modificador
						WM3_RefreshChannelListUI morphMod
					)
					
					Morph_O_Matic:
					(
						morphMod.useLimits = chkUseLimits.checked
					)
				)--case
				
				if not chkUseLimits.checked then
				(
					chkUseLimitsP.enabled = true
					if chkUseLimitsP.checked then
					(
						spnMinimum.enabled = true
						spnMaximum.enabled = true				
					)else(
						spnMinimum.enabled = false
						spnMaximum.enabled = false
					)			
				)else(
					spnMinimum.enabled = false
					spnMaximum.enabled = false
					chkUseLimitsP.enabled = false
				)
			)
		)--on chkUseLimits

		------------------------------------------------
		--@event: changed | habilita/deshabilita UtoreloadTargets
		------------------------------------------------
		on chkReloadTargets changed State do
		(
			if morphMod != undefined then
 			(
				case classof morphMod of
				(
					morpher:
					(
						morphMod.Autoload_of_targets = (if chkReloadTargets.checked then 1 else 0)
						--refresca el modificador
						WM3_RefreshChannelListUI morphMod
					)
					
					Morph_O_Matic:
					(
						morphMod.autoloadTargets = chkReloadTargets.checked
					)
				)--case
				
				
			)
		)--on chkReloadTargets

		------------------------------------------------
		--@event: picked | Añade un target al canal seleccionado
		------------------------------------------------
		on pckAddTarget picked obj do
		(
			if morphMod != undefined then
 			(
				deleteModChangeHandler() --destruye el handler
				
				addTarget morphMod indexSelected obj autoRenameTargets:(chkRenameTargets.checked) --añade el target
				
				updateListView() --actualiza el listview
				updateChannelSettings indexSelected --actualiza el listview del canal
				createModChangeHandler() --crea el handler
			)
		)--on pckAddTarget

		------------------------------------------------
		--@event: pressed | elimina un target del canal seleccionado
		------------------------------------------------
		on btnDeleteTarget pressed do
		(
			if morphMod != undefined then
			(
				deleteModChangeHandler() --destruye el handler
				
				clearSelection()
				select morphObj
				max modify mode
				modPanel.setCurrentObject morphMod
				
				delTarget() --elimina el target
				
				updateListView() --actualiza el listview
				updateChannelSettings indexSelected --actualiza el listview del canal
				createModChangeHandler() --crea el handler
			)
		)--on btnDeleteTarget

		------------------------------------------------
		--@event: pressed | extrae targets
		------------------------------------------------
		on btnExtract pressed do
		(
			-- 			if morphMod != undefined then
			--  			(
			-- 				deleteModChangeHandler() --destruye el handler
			-- 				
			-- 				clearSelection()
			-- 				select morphObj
			-- 				max modify mode
			-- 				modPanel.setCurrentObject morphMod
			-- 				
			-- 				extractMorphs() --extrae los targets

			-- 				updateListView() --actualiza el listview
			-- 				updateChannelSettings indexSelected --actualiza el listview del canal
			-- 				createModChangeHandler() --crea el handler
			-- 			)
		)--on btnExtract

		------------------------------------------------
		--@event: pressed | carga la informacion de morpher almacenada en un fichero, carga los vertex colors en las cabezas
		------------------------------------------------
		on btnLoad pressed do
		(
			deleteModChangeHandler() --destruye el handler
			
			--obtiene el path inicial donde buscar el archivo
			if lastPath != undefined then
				lastUsed = lastPath
			else
				lastUsed = GetDir #maxroot
			
			--carpeta de donde coger los archivos
			folder = getSavePath caption:"Load Morph Info" initialDir:lastUsed --obtiene el nuevo path

			--almacena el path usado para usarlo en el futuro
			if folder != undefined then
			(
				lastPath = folder --substituteString file (filterString file "\\")[(filterString file "\\").count] ""
				
				file = folder + "\\" + morphObj.name + ".mrphi"
				
				setWaitCursor()
				
				if  (chkSLsettings.checked and chkSLsettings.enabled) or (chkSLchannel.checked and chkSLchannel.enabled) then
					loadMorphInfo (chkSLsettings.checked and chkSLsettings.enabled) (chkSLchannel.checked and chkSLchannel.enabled) rdoSLoptions.state file
				
				if chkSLvertexColors.checked then
					loadTargetsVertexColors folder rdoSLoptions.state
				
				setArrowCursor()					
				
			)
			else
				lb.message.show "Folder is not correct" type:#message pos:undefined size:[300,75] modal:true

			updateListView()
			
			createModChangeHandler() --crea el handler
		)

		------------------------------------------------
		--@event: pressed | guarda la informacion del morpher en un fichero, guarda la informacion de vertex colors
		------------------------------------------------
		on btnSave pressed do
		(
			deleteModChangeHandler() --destruye el handler
			
			if lastPath != undefined then
				lastUsed = lastPath
			else
				lastUsed = GetDir #maxroot
				
			folder = getSavePath caption:"Save Morph Info" initialDir:lastUsed --obtiene el nuevo path
			
			if folder != undefined then
			(
				lastPath = folder
				
				setWaitCursor()
				
				if  (chkSLsettings.checked and chkSLsettings.enabled) or (chkSLchannel.checked and chkSLchannel.enabled) then
					saveMorphInfo (chkSLsettings.checked and chkSLsettings.enabled) (chkSLchannel.checked and chkSLchannel.enabled) rdoSLoptions.state folder
				
				if chkSLvertexColors.checked then
					saveTargetsVertexColors folder rdoSLoptions.state
				
				setArrowCursor()
				
			)
			
			createModChangeHandler() --crea el handler
		)

		------------------------------------------------
		--@event: pressed | actualiza el interface
		------------------------------------------------
		on rdoSLoptions changed state do
		(
			-- 			if state == 2 then
			-- 			(
			-- 				chkSLsettings.enabled = false
			-- 				chkSLchannel.enabled = false
			-- 			)
			-- 			else
			-- 			(
			-- 				chkSLsettings.enabled = true
			-- 				chkSLchannel.enabled = true
			-- 			)
		)

		------------------------------------------------
		--@event: changed | actualiza el valor en el morpher
		------------------------------------------------
		on spnMinimum changed value do
		(
			if morphMod != undefined then
 			(
				case classof morphMod of
				(
					morpher:
					(
						if value < 0 then spnMinimum.value = 0
						if value >= spnMaximum.value then spnMinimum.value = (spnMaximum.value - 1)
						
						WM3_MC_SetLimitMIN morphMod indexSelected (spnMinimum.value as float)
						WM3_RefreshChannelParamsUI morphMod
					)
					
					Morph_O_Matic:
					(
						if value >= spnMaximum.value then spnMinimum.value = (spnMaximum.value - 1)
						morphMod[indexSelected].minLimit = spnMinimum.value
					)
				)--case
			)
		)--on spnMinimum

		------------------------------------------------
		--@event: changed | actualiza el valor en el morpher
		------------------------------------------------
		on spnMaximum changed value do
		(
			if morphMod != undefined then
 			(
				case classof morphMod of
				(
					morpher:
					(
						if value > 100 then spnMaximum.value = 100
						if value <= spnMinimum.value then spnMaximum.value = (spnMinimum.value + 1)
						
						WM3_MC_SetLimitMIN morphMod indexSelected (spnMinimum.value as float)
						WM3_RefreshChannelParamsUI morphMod
					)
					
					Morph_O_Matic:
					(
						if value <= spnMinimum.value then spnMaximum.value = (spnMinimum.value + 1)
						morphMod[indexSelected].maxLimit = spnMaximum.value
					)
				)--case
			)
		)--on spnMaximum

		------------------------------------------------
		--@event: changed | pone al target progresivo un nuevo peso (%)
		------------------------------------------------
		on btnSetNewWeight pressed do
		(
			if morphMod != undefined then
			(
				newWeight = spnNewWeight.value
				setNewProgWeight morphMod indexSelected targetSelected newWeight autoRenameTargets:(chkRenameTargets.checked)
			)
		)
		
		on spnNewWeight changed value do
		(
			if classof morphMod == morpher then
			(
				if value > 100 then spnNewWeight.value = 100
				if value < 0 then spnNewWeight.value = 0
			)
		)

		------------------------------------------------
		--@event: pressed | intercambia el target progresivo con su anterior
		------------------------------------------------
		on btnMoveUpT pressed do
		(
			if morphMod != undefined and targetSelected != 1 then
			(
				oldWeight = lvChannelList.items.item[targetSelected-1].subitems.item[2].text as integer
				newWeight = lvChannelList.items.item[targetSelected-2].subitems.item[2].text as integer
				
				setNewProgWeight morphMod indexSelected targetSelected (newWeight - 1) autoRenameTargets:(chkRenameTargets.checked)
				setNewProgWeight morphMod indexSelected (targetSelected+1) oldWeight autoRenameTargets:(chkRenameTargets.checked)
				setNewProgWeight morphMod indexSelected (targetSelected-1) newWeight autoRenameTargets:(chkRenameTargets.checked)
			)
		)

		------------------------------------------------
		--@event: pressed | intercambia el target progresivo con el siguiente
		------------------------------------------------
		on btnMoveDownT pressed do
		(
			if morphMod != undefined and targetSelected != lvChannelList.items.count then
			(
				oldWeight = lvChannelList.items.item[targetSelected-1].subitems.item[2].text as integer
				newWeight = lvChannelList.items.item[targetSelected].subitems.item[2].text as integer
				
				setNewProgWeight morphMod indexSelected targetSelected (newWeight + 1) autoRenameTargets:(chkRenameTargets.checked)
				setNewProgWeight morphMod indexSelected (targetSelected-1) oldWeight autoRenameTargets:(chkRenameTargets.checked)
				setNewProgWeight morphMod indexSelected (targetSelected+1) newWeight autoRenameTargets:(chkRenameTargets.checked)
			)		
		)

		------------------------------------------------
		--@event: entered | si se introduce un nuevo nombre de canal, lo cambia siempre que sea un nombre valido
		------------------------------------------------
		on edtChannelName entered newName do
		(
			if morphMod != undefined then
			(
				if checkNamingConvention newName and newName != "originalMorph" then
				(
					case classof morphMod of
					(
						morpher: WM3_MC_SetName morphMod indexSelected newName
						Morph_O_Matic: MOM_SetChannelName morphMod indexSelected newName
					)					
					
					edtChannelName.text = newName
					updateListView()
					updateChannelSettings indexSelected
				)
				else
				(	
					case classof morphMod of
					(
						morpher: edtChannelName.text = WM3_MC_GetName morphMod indexSelected
						Morph_O_Matic: edtChannelName.text = morphMod[indexSelected].name
					)					
					lb.message.show "Invalid Name: Naming Convention Fail" type:#message pos:undefined size:[300,75] modal:true
				)
			)
		)

		------------------------------------------------
		--@event: pressed | refresca el listview
		------------------------------------------------
		on btnRefresh pressed do
			if morphMod != undefined then
 				updateListView()

		------------------------------------------------
		--@event: pressed | cierra el rollout
		------------------------------------------------
		on btnClose pressed do
			destroyDialog rollMainDef

		------------------------------------------------
		--@event: changed | abre o cierra el rollout de conexion de caretas
		------------------------------------------------
		on chkbtnMaskConnection changed state do
		(
			if not rollMaskConnectionOpen then
			(
				if ckbMorphMode.checked then
				(
					if morphMod != undefined then	--crea el rollout Mask Connection
					(
						if lb.nc.ncOK morphObj.name then
						(
							createDialog parent.rollMaskConnection style:#(#style_border,#style_resizing,#style_titlebar,#style_minimizebox,#style_maximizebox, #style_sysmenu) lockwidth:true pos:[((getDialogPos rollMainDef).x - ((parent.rollMaskConnection.width) + 8)),(getDialogPos rollMainDef).y]
							parent.rollMaskConnection.height = rollMainDef.height
							rollMaskConnectionOpen = true
							buttonsEnableDisable()
						)
						else
							lb.message.show "current object doesn't match naming convention" type:#message pos:undefined size:[300,75] modal:true
					)
				)
				else if ckbBonesMode.checked then
				(
					if faceShapeControls.count != 0 then
					(
						createDialog parent.rollMaskConnection style:#(#style_border,#style_resizing,#style_titlebar,#style_minimizebox,#style_maximizebox, #style_sysmenu) lockwidth:true pos:[((getDialogPos rollMainDef).x - ((parent.rollMaskConnection.width) + 8)),(getDialogPos rollMainDef).y]
						parent.rollMaskConnection.height = rollMainDef.height
						rollMaskConnectionOpen = true
						buttonsEnableDisable()
					)
					else
					(
						lb.message.show "there are no face shapes in scene" type:#message pos:undefined size:[300,75] modal:true
						chkbtnMaskConnection.checked = false
					)
				)
			)
			else --destruye el rollout Mask Connection
			(
				destroyDialog parent.rollMaskConnection
				rollMaskConnectionOpen = false
				buttonsEnableDisable()				
			)
		)--on btnMaskConnection
		
		on ckbMorphMode changed state do
		(
			ckbBonesMode.checked = not state
			buttonsEnableDisable()
			
			if not state then
			(
				if isValidNode chrNode then
				(
					deleteModChangeHandler()
					_chrParts = filterString chrNode.name "_"
					btnPickObject.caption = (_chrParts[1] + "_" + _chrParts[2])
					faceShapeControls = getFaceShapeControls()
					fillListView()
					lvMorphList.enabled = true
					
					if lvMorphList.items.count > 0 then
					(
						lvMorphList.items.item[0].selected = true
						indexSelected = 1
						for i=1 to lvMorphList.items.count do (updateRowsColor lvMorphList i false)
					)
					
					createModChangeHandler()
				)
				else
				(
					deleteModChangeHandler()
					lvMorphList.clear()
					initListView lvMorphList
					lvMorphList.enabled = false
				)
			)
			else
			(
				if morphMod != undefined then
				(
					deleteModChangeHandler()
					
					_limit = 100
					
					lvMorphList.Clear()
					initListView lvMorphList
					fillListView()
					
					if lvMorphList.items.count > 0 then
					(
						lvMorphList.items.item[0].selected = true
						indexSelected = 1
						for i=1 to _limit do (updateRowsColor lvMorphList i false)
						lvChannelList.Clear()
						fillChannelList indexSelected
						for i=1 to lvChannelList.items.count do (updateRowsColor lvChannelList i false)
					)
					
					lvMorphList.enabled = true
					lvChannelList.enabled = true
					
					----------------------------------------------------------------------------------------------------
					case classof morphMod of
					(
						morpher:
						(
							chkReloadTargets.checked = if morphMod.Autoload_of_targets == 1 then true else false
							chkUseLimits.checked = if morphMod.Use_Limits == 1 then true else false
						)
						
						Morph_O_Matic:
						(
							chkReloadTargets.checked = morphMod.autoloadTargets
							chkUseLimits.checked = morphMod.useLimits
						)				
					)
					
					if not chkUseLimits.checked then
					(
						chkUseLimitsP.enabled = true
						if chkUseLimitsP.checked then
						(
							spnMinimum.enabled = true
							spnMaximum.enabled = true				
						)else(
							spnMinimum.enabled = false
							spnMaximum.enabled = false
						)			
					)else(
						spnMinimum.enabled = false
						spnMaximum.enabled = false
						chkUseLimitsP.enabled = false
					)
					-------------------------------------------------------------------------
					
					createModChangeHandler()
				)
				else
				(
					deleteModChangeHandler()
					lvMorphList.clear()
					initListView lvMorphList
					lvMorphList.enabled = false
					lvChannelList.enabled = false
				)				
			)
		)
		
		on ckbBonesMode changed state do
		(
			ckbMorphMode.checked = not state
			buttonsEnableDisable()
			
			if state then
			(
				if not isValidNode chrNode then
				(
					if lb.asset.sceneAssets == undefined then lb.asset.sceneAssets = lb.asset.getSceneAssets()
					if lb.asset.sceneAssets.count != 0 then chrNode = lb.asset.sceneAssets[1].nodes[1]
				)
				
				if isValidNode chrNode then
				(
					deleteModChangeHandler()
					_chrParts = filterString chrNode.name "_"
					btnPickObject.caption = (_chrParts[1] + "_" + _chrParts[2])
					faceShapeControls = getFaceShapeControls()
					fillListView()
					lvMorphList.enabled = true
					
					if lvMorphList.items.count > 0 then
					(
						lvMorphList.items.item[0].selected = true
						indexSelected = 1
						for i=1 to lvMorphList.items.count do (updateRowsColor lvMorphList i false)
					)
					
					createModChangeHandler()
				)
				else
				(
					deleteModChangeHandler()
					lvMorphList.clear()
					initListView lvMorphList
					lvMorphList.enabled = false
				)
			)
			else
			(
				if morphMod != undefined then
				(
					deleteModChangeHandler()
					
					_limit = 100
					
					lvMorphList.Clear()
					initListView lvMorphList
					fillListView()
					
					if lvMorphList.items.count > 0 then
					(
						lvMorphList.items.item[0].selected = true
						indexSelected = 1
						for i=1 to _limit do (updateRowsColor lvMorphList i false)
						lvChannelList.Clear()
						fillChannelList indexSelected
						for i=1 to lvChannelList.items.count do (updateRowsColor lvChannelList i false)
					)
					
					lvMorphList.enabled = true
					lvChannelList.enabled = true
					
					----------------------------------------------------------------------------------------------------
					case classof morphMod of
					(
						morpher:
						(
							chkReloadTargets.checked = if morphMod.Autoload_of_targets == 1 then true else false
							chkUseLimits.checked = if morphMod.Use_Limits == 1 then true else false
						)
						
						Morph_O_Matic:
						(
							chkReloadTargets.checked = morphMod.autoloadTargets
							chkUseLimits.checked = morphMod.useLimits
						)				
					)
					
					if not chkUseLimits.checked then
					(
						chkUseLimitsP.enabled = true
						if chkUseLimitsP.checked then
						(
							spnMinimum.enabled = true
							spnMaximum.enabled = true				
						)else(
							spnMinimum.enabled = false
							spnMaximum.enabled = false
						)			
					)else(
						spnMinimum.enabled = false
						spnMaximum.enabled = false
						chkUseLimitsP.enabled = false
					)
					-------------------------------------------------------------------------
					
					createModChangeHandler()
				)
				else
				(
					deleteModChangeHandler()
					lvMorphList.clear()
					initListView lvMorphList
					lvMorphList.enabled = false
					lvChannelList.enabled = false
				)				
			)
		)

		------------------------------------------------
		--@event: moved | mueve los rollouts al mismo tiempo
		------------------------------------------------
		on rollMainDef moved pos do
		(
			if rollMaskConnectionOpen then
			(
				SetDialogPos parent.rollMaskConnection [((getDialogPos rollMainDef).x - ((parent.rollMaskConnection.width) + 8)),(getDialogPos rollMainDef).y]
			)
		)--on rollMainDef

		------------------------------------------------
		--@event: tick | cada tick de tiempo comprueba si hay cambios que actualizar y si los hay los actualiza
		------------------------------------------------
		on clock tick do
		(
			if pendingChanges then  
			(
				numChannels = 0
				if morphMod != undefined then
				(
					_limit = 100
					if classof morphMod == Morph_O_Matic then _limit = MOM_GetNumChannels morphMod
					
					--actualizamos las filas que hayan podido cambiar de nombre o valor
					for i = 1 to _limit do
					(
						case (classof morphMod) of
						(
							morpher:
							(
								mName = (if morphMod[i] == false then "- empty -" else (wm3_mc_getname morphMod i))
								mWeight = (if (WM3_MC_HasData morphMod i) == false then "" else (WM3_MC_GetValue  morphMod i) as string)
								if morphMod[i].value != undefined then numChannels += 1
							)--morpher
							
							Morph_O_Matic:
							(
								mName = morphMod[i].name
								if (MOM_MC_GetNumTargets morphMod[i] == 1) and ((MOM_MC_TARG_GetName morphMod[i] 1) == "Original") then mName = "- empty -"
								mWeight = morphMod[i][2].value
								if mName != "- empty -" then numChannels += 1
							)
						)--case
						
						if lvMorphList.items.item[i-1].subitems.item[1].text != mName	then
							lvMorphList.items.item[i-1].subitems.item[1].text = mName
						
						if lvMorphList.items.item[i-1].subitems.item[2].text != mWeight then	
							lvMorphList.items.item[i-1].subitems.item[2].text = mWeight as string
						
						updateRowsColor lvMorphList i false						
					)
				
					lblNumChannels.caption = numChannels as string
					
					-------------------------------------------------------------------------------------------------------
					if classof morphMod == morpher then
					(
						chkUseLimits.checked = (if morphMod.Use_Limits==1 then true else false)
						chkReloadTargets.checked = (if morphMod.Autoload_of_targets==1 then true else false)
					)
					else if classof morphMod == Morph_O_Matic then
					(
						chkUseLimits.checked = morphMod.uselimits
						chkReloadTargets.checked = morphMod.autoloadTargets
					)
					
					if not chkUseLimits.checked then
					(
						chkUseLimitsP.enabled = true
						if chkUseLimitsP.checked then
						(
							spnMinimum.enabled = true
							spnMaximum.enabled = true				
						)else(
							spnMinimum.enabled = false
							spnMaximum.enabled = false
						)			
					)else(
						spnMinimum.enabled = false
						spnMaximum.enabled = false
						chkUseLimitsP.enabled = false
					)				
					-------------------------------------------------------------------
					
					rollMainDef.updateChannelSettings rollMainDef.indexSelected
					
				)
			)
			pendingChanges = false
		)

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

			dialogHeight = rollMainDef.height
			
			edtValue.visible = false
			-- buscamos alguna pieza con el modificador morpher
			for o in objects do
				if (filterString o.name "_")[5] == "head" then
					for m in o.modifiers do
						if classof m == morpher or classof m == Morph_O_Matic then
						(
							morphMod = m
							morphObj = o
						)
			
			if morphObj	== undefined then
				for o in objects do
					for m in o.modifiers do
						if classof m == morpher or classof m == Morph_O_Matic then
						(
							morphMod = m
							morphObj = o
						)
			
			if morphMod != undefined then
			(
				chkbtnMaskConnection.enabled = true
				btnPickObject.caption = btnPickObject.tooltip = (refs.dependentnodes morphMod)[1].name
					
				initListView lvMorphList --inicializa el listview
				fillListView() --rellena el listview
				
				initChannelList lvChannelList --inicializa el listview del canal seleccionado
				
				lvSelListItems = lvMorphList.selectedItems --actualiza la seleccion
				
				getLvSelectedListItems() --actualiza la seleccion
				
				indexSelected = 1
				lvSelectRange (indexSelected-1) (indexSelected-1)
				
				_limit = if classof morphMod == morpher then 100 else if classof morphMod == Morph_O_Matic then MOM_GetNumChannels morphMod
				for i=1 to _limit do (updateRowsColor lvMorphList i false)
				
				updateChannelSettings indexSelected
				--fillChannelList indexSelected
				for i=1 to lvChannelList.items.count do (updateRowsColor lvChannelList i false)
				
				oldListviewHeight = lvMorphList.height
				
				lvMorphList.enabled = true
				lvChannelList.enabled = true
				
				--use limits----------------------------------------------------
				if classof morphMod == morpher then
				(
					chkUseLimits.checked = if morphMod.Use_Limits == 1 then true else false
					chkReloadTargets.checked = (if morphMod.Autoload_of_targets==1 then true else false)
				)
				else if classof morphMod == Morph_O_Matic then
				(
					chkUseLimits.checked = morphMod.useLimits
					chkReloadTargets.checked = morphMod.autoloadTargets
				)
				
				if not chkUseLimits.checked then
				(
					chkUseLimitsP.enabled = true
					if chkUseLimitsP.checked then
					(
						spnMinimum.enabled = true
						spnMaximum.enabled = true				
					)else(
						spnMinimum.enabled = false
						spnMaximum.enabled = false
					)			
				)else(
					spnMinimum.enabled = false
					spnMaximum.enabled = false
					chkUseLimitsP.enabled = false
				)
				-------------------------------------------------------------------
				
				createModChangeHandler()
			)
			else
			(
				initListView lvMorphList --inicializa el listview
				lvMorphList.enabled = false
				lvChannelList.enabled = false
				chkbtnMaskConnection.enabled = false
			)
			
			updateToolbarButtons() --actualiza los botones de la barra de herramientas	
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

			if rollMaskConnectionOpen then destroyDialog parent.rollMaskConnection --destruye el rollout del conexion de caretas
				
			deleteModChangeHandler() --destruye el handler

			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: morpherManager | Contiene la herramienta plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_morpherManager
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Morpher Manager",		--@var: description | Descripcion de la tool.
		
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

		rollMaskConnection = rollMaskConnectionDef,
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
			createDialog this.rollMain lockwidth:true lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
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
	)--tl_morpherManager
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_morpherManager() --crea la herramienta
)