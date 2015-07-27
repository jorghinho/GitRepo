------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: Herramienta anim_deform, usada para realizar fixes de animación.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	--@attributes: ca_containerInfo | Variable que contiene el customAttribute containerInfo 
	ca_containerInfo = attributes containerInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0 											--@var: float | CA_version | Versión del customAttribute
			CA_description	type:#string	default:"Almacena la informacion de Modificaciones de morph de animacion." 	--@var: string | CA_description | Nombre del target del morph

			------------------------------------------------
			--informacion sobre el contenido almacenado en el container
			meshNode type:#string default:"" 						--@var: string | meshNode | Nombre del target del morph
			focus type:#time default:0  							--@var: time | focus | Fotograma en el que la deformación tiene su valor maximo
			percentage type:#integer default:-1  					--@var: integer | percentage | El porcentaje que se aplica el morph.
			------------------------------------------------
		)
	)
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene el rollout principal de la herramienta anim_deform.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "anim deform"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) 	--@var: string | parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 230															--@var: integer | minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 375															--@var: integer | minRollHeight | Alto mínimo de la herramienta.

		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		local _meshCopies = #() 															--@var: array{nodes} | meshCopies | Array que contiene las meshes modificadas usadas en los morphos.
		local _baseMeshes = #() 															--@var: array{nodes} | _baseMeshes | Array que contiene las referencias a la mesh original antes de ser modificada
		local _selection = #() 																--@var: array{nodes} | _selection | Array que contiene los nodos seleccionados.
		local _saveSelection = #() 															--@var: array{boolean} | _saveSelection | Array de booleanos que indica si se debe de realizar la operación del procesado de la modificación para las piezas.
		local _internalIndex = 1 															--@var: integer | _internalIndex | Indice que contiene un control de los elementos que hay en las arrays temporales
		local _auxLayer = undefined  														--@var: layer | _auxLayer | Referencia a la capa que contiene los objetos con los fixes.
		local editCA = undefined  															--@var: attributes | editCA | Custom Attribute que contiene la información de las deformaciones de mallas.
		local _tempLVSelection = undefined  												--@var: nodes | _tempLVSelection | Array que contiene el nodo al que hace referencia el elemento del listview.
		local _appendOnce = #() 															--@var: array{nodes} | _appendOnce | Array que contiene los nodos que hay que monitorizar para mostrar la información en el panel del manager.


		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--MENU PRINCIPAL--
		groupBox gbxControl "Controls"  pos:[5,10] width:216 height:205 
		checkbutton chbrun "Edit pose" pos:[13,25] width:200 height:50 align:#center enabled:false
		button btnPrev "<< Prev Mesh" pos:[13,80] width:95 height:30 enabled:false
		button btnNext "Next Mesh >>" pos:[115,80] width:98 height:30 enabled:false
		button btnMoveTool "Move" pos:[30,115] width:45 height:45 enabled:false
		button btnPushTool "Push" pos:[85,115] width:45 height:45 enabled:false
		button btnRelaxTool "Relax" pos:[140,115] width:45 height:45 enabled:false
		spinner spnRange "Modification Range" width:200 height:100 range:[1,1000,1] pos:[7,165] type:#integer enabled:false
		checkbutton chbSaveInfo "Mesh Save Info" pos:[13,185] width:200 height:25 align:#center enabled:false
		groupbox bgxPose "Pose Management" pos:[5,215] width:216 height:155 
		button btnCommit "Add Skin Fix" width:200 height:45  pos:[13,230] enabled:false
		button btnDelete "Delete Skin Fix" width:200 height:45  pos:[13,280] enabled:false
		checkbutton btnTrackView ">> Expand Manager >>" pos:[13,330] width:200 height:30
		--MENU DESPLEGABLE--
		groupBox grpManager "" pos:[240,10] width:500 height:35
		label lblAsset "Filter:" pos:[250,22] height:15
		edittext edtFilter "" pos:[280,22] width:450 height:15
		dotNetControl lvInfo "System.Windows.Forms.ListView" pos:[240,55] width:500 height:310

		
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
		--El rollout que se desplega al hacer doble click en un item del listview
		--@var: rollout| deformRollout | Contiene el rollout de la ventana que se abre para editar los fixes del listview.\\**_sel**: Variable que contiene la selección actual al abrir el rollout.
		rollout deformRollout "Edit Deformations" width:220 						
		(
			local _sel = getCurrentSelection()

			button _btnMoveTool "Move" pos:[30,10] width:45 height:45
			button _btnPushTool "Push" pos:[90,10] width:45 height:45 
			button _btnRelaxTool "Relax" pos:[150,10] width:45 height:45 
			checkbutton chbediting "Editing" width:200 height:50 align:#center checked:true

			-----------------------------------------------
			--@event: pressed | Evento que se lanza al pulsar el boton.
			--@control: button | btnMoveTool | El elemento que dispara el evento.
			------------------------------------------------
			on _btnMoveTool pressed do 
			(
				macros.run "PolyTools" "PolyDrawDrag"
				macros.run "PolyTools" "PolyShiftMove"
			)
	
			-----------------------------------------------
			--@event: pressed | Evento que se lanza al pulsar el boton.
			--@control: button | btnPushTool | El elemento que dispara el evento.
			------------------------------------------------
			on _btnPushTool pressed do 
			(
				macros.run "PolyTools" "PolyDrawDrag"
				macros.run "PolyTools" "PaintDeformPushPull"
			)
	
			-----------------------------------------------
			--@event: pressed | Evento que se lanza al pulsar el boton.
			--@control: button | btnPushTool | El elemento que dispara el evento.
			------------------------------------------------
			on _btnRelaxTool pressed do 
			(
				macros.run "PolyTools" "PolyDrawDrag"
				macros.run "PolyTools" "PaintDeformRelax"
			)

			-----------------------------------------------
			--@event: changed | Evento que se lanza al cambiar el estado del boton.
			--@control: checkbutton | chbediting | El elemento que dispara el evento.
			------------------------------------------------
			on chbediting changed state do 
			(
				--recibe una variable local dentro del contexto de la tool, _sel, que hace referencia al elemento seleccionado en el listview
				if state == false do
				(	
					--Ocultamos la pieza auxiliar de mesh
					_sel[1].ishidden = true
					IsolateSelection.ExitIsolateSelectionMode()
					clearSelection()
					lb.animDeform.rollMain.btnDelete.enabled = false
				 	destroyDialog (lb.animDeform.rollMain.deformRollout)
				)
			)

			-----------------------------------------------
			--@event: open | Evento que se lanza abrir el rollout
			--@control: rollout | deformRollout | El elemento que dispara el evento.
			------------------------------------------------
			on deformRollout open do 
			(
				--Al abrir el rollout hay que poner el focus en el modificador de edit poly para editarlo con las polytools 
				setArrowCursor()
				modPanel.setCurrentObject _sel[1].modifiers[#Edit_P_Anim_Fix]
				--Hacemos un set del nivel de deformación a puntos
				subobjectLevel = 1
				macros.run "PolyTools" "PolyDrawDrag"
				macros.run "PolyTools" "PolyShiftMove"
			) 

			-----------------------------------------------
			--@event: close | Evento que se lanza cerrar el rollout
			--@control: rollout | deformRollout | El elemento que dispara el evento.
			------------------------------------------------			
			on deformRollout close do 
			(
				--Al cerrar el rollout se oculta la pieza auxiliar de deformación y se sale del modo de isolación	
				_sel[1].ishidden = true
				IsolateSelection.ExitIsolateSelectionMode()
				clearSelection()
				lb.animDeform.rollMain.btnDelete.enabled = false
				destroyDialog (lb.animDeform.rollMain.deformRollout)
			)
		)
		------------------------------------------------
		--@fn: undefined | initInfoListView | Funcion que inicializa los parametros de configuración de la listview
		------------------------------------------------
		fn initInfoListView =
		(
			lv = lvInfo
			lv.columns.clear()
			lv.multiSelect = false
			lv.gridLines = true
			lv.View = (dotNetClass "System.Windows.Forms.View").details
			lv.borderstyle = (dotnetclass "System.Windows.Forms.BorderStyle").fixedSingle
			lv.fullRowSelect = true
			lv.backColor = colorBackUnselected
			lv.foreColor = colorFore
			lv.scrollable = true
			lv.labelEdit = false

			lv.columns.add "Mesh" 350
			lv.columns.add "Focus Action Frame" 75
			lv.columns.add "Percentage" 75

			lv.HeaderStyle = (dotNetClass "System.Windows.Forms.ColumnHeaderStyle").nonClickable
		)

		------------------------------------------------
		--@fn: undefined | updateContainerInfo | Funcion que actualiza el custom attributes con la información del frame focus y el valor maximo del morpher.
		--@gets: node | copynode | la pieza de mesh auxiliar que contiene las modificaciones de edit poly
		--@gets: node | _originalNode | la pieza de mesh original que contiene el morpher
		------------------------------------------------
		fn updateContainerInfo _copyNode _originalNode=
		(
			_timeValue = undefined 
			_amountValue =  undefined
			_topValue = 0 
			_focusValue = undefined
			--Quitamos el flag de hidden del originalNode para hacer las comparaciones.
			_originalNode[_originalNode.count] = substituteString _originalNode[_originalNode.count] _originalNode[_originalNode.count] ""
			_originalNode = getNodeByName _originalNode
			if _copyNode != undefined and _originalNode != undefined do 
			(
				--Si el objeto tiene el modificador de morpher específico de la tool.
				if isProperty _originalNode #Morph_Anim_Fix do
				(

					_keep = true
					_index = 1
					_finalIndex = 0
					--Este bucle devuelve el primer indice vacío dentro del modificador de morpher facilitado.
					for n=1 to 100 do
					(
						--Keep == true si hay data en la posición del indice especificado.
						keep = WM3_MC_HasData _originalNode.Morph_Anim_Fix n
						if keep do _index = n + 1	
					)
					--Se recorren todos los canales llenos del morpher y recogemos en la variable el indice del canal de morph con el mismo nombre de la pieza auxiliar.
					for i = 1 to _index do 
					(
						_target = (wm3_mc_getname _originalNode.Morph_Anim_Fix i)
						if _target == _copyNode.name then 
						(
							_finalIndex = i
						)
					)
					--Se recorren todas las llaves asociadas al canal de morph
					for i = 1 to (_originalNode.Morph_Anim_Fix[_finalIndex].keys.count) do 
					(	
						--Nos quedamos con el valor mas alto de % de morph. (en caso de ser iguales se queda el primero.) junto al tiempo en el que se aplica este factor.
						if (_originalNode.Morph_Anim_Fix[_finalIndex].keys[i].value) > _topValue do 
						(
							_topValue = (_originalNode.Morph_Anim_Fix[_finalIndex].keys[i].value)
							_focusValue =  (_originalNode.Morph_Anim_Fix[_finalIndex].keys[i].time)
						)
					)
					--Actualizamos el valor del custAttributes de la pieza copia con los valores obtenidos anteriormente.
					_editCa = _copyNode.custAttributes[#containerInfo]
					try (_editCa.focus = _focusValue) catch ()
					try (_editCa.percentage = _topValue) catch ()

					--Actualizamos el listview con la visualización de los nuevos valores.
					lb.animDeform.rollMain.updateListView()
				)
			)
		)
		------------------------------------------------
		--@fn: undefined | createObjChangeHandler | Función que dado un nodo, crea un listener que captura cualquier evento que le suceda al nodo. y ante modificaciones actualiza la UI de la tool.
		--@gets: node | _node | El nodo a monitorizar
		------------------------------------------------
		fn createObjChangeHandler _node=
		(
			if _node != undefined then
				parametersCH = when parameters _node changes id:#animDeformCH val do lb.animDeform.rollMain.updateUILVcontent() 
		)

		fn addListenerToCurrentSceneObjects = 
		(	
			_auxNodes = lb.layer.getLayerNodes _auxLayer
			for i = 1 to _auxNodes.count do 
			(
				editCA = _auxNodes[i].custAttributes[#containerInfo]
				if editCA != undefined then 
				(
					tmpName = editCA.meshNode
					tmpName[tmpName.count] = substituteString tmpName[tmpName.count] tmpName[tmpName.count] ""
					_node =  (getNodeByNAme tmpName)
					if appendIfUnique _appendOnce _node do 
					(
						createObjChangeHandler _node
					)

				)
			)
		)

		------------------------------------------------
		--@fn: undefined | updateListView | Funcion que repinta el contenido de la listview con las piezas de fix de mesh de la escena.
		------------------------------------------------
		fn updateListView =
		(
			lvInfo.items.clear()	
			--Obtenemos los objetos de la capa auxiliar donde se guardan las copias.
			_auxNodes = lb.layer.getLayerNodes _auxLayer
			for i = 1 to _auxNodes.count do 
			(
				--Si la pieza no tiene CustAttributes con la info del morph lo crea y lo pone a undefined (por precaución.)
				_editCa = _auxNodes[i].custAttributes[#containerInfo]
				if _editCa == undefined then
				(
					lvInfo.items.add (_auxNodes[i].name)
					lvInfo.items.item[i-1].SubItems.add ("undefined")
					lvInfo.items.item[i-1].SubItems.add ("undefined")
				)
				else 
				(
					--pintamos las columnas con el contenido del CustAttrib
					lvInfo.items.add (_auxNodes[i].name)
					lvInfo.items.item[i-1].SubItems.add ((_editCa.focus) as string)
					lvInfo.items.item[i-1].SubItems.add ((_editCa.percentage)as string)
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | updateUILVcontent | Función para el callback. Actualiza la información de controladores 
		------------------------------------------------
		fn updateUILVcontent =
		(
			_tmp = lb.layer.getLayerbyName "_auxAnimFix_"
			_auxNodes = lb.layer.getLayerNodes _tmp
			if _auxNodes != undefined do 
			(
				for i = 1 to _auxNodes.count do 
				(
					if _auxNodes[i] != undefined do 
					(
						editCa = _auxNodes[i].custAttributes[#containerInfo]
						if editCa != undefined do 
						(
							_origin = editCa.meshNode 
							if _origin != "" do 
							(
								updateContainerInfo _auxNodes[i] _origin
							)
						)
					)
				)
				updateListView()
			)
		)

		------------------------------------------------
		--@fn: undefined | filterListView | Función que filtra los elementos mostrados en el listview, mostrándolos en función de un caption.
		--@gets: string | _string | La cadena que realiza de patrón para el filtrado.
		------------------------------------------------
		fn filterListView _string=
		(
			lvInfo.items.clear()	
			_auxNodes = lb.layer.getLayerNodes _auxLayer
			_addedItems = 1
			for i = 1 to _auxNodes.count do 
			(
				_editCa = _auxNodes[i].custAttributes[#containerInfo]
				if _editCa == undefined then
				(
					if matchpattern (_auxNodes[i].name) pattern:("*"+ _string +"*") then
					(
						lvInfo.items.add (_auxNodes[i].name)
						lvInfo.items.item[_addedItems-1].SubItems.add ("undefined")
						lvInfo.items.item[_addedItems-1].SubItems.add ("undefined")
						_addedItems+=1
					)
				)
				else 
				(
					if matchpattern (_auxNodes[i].name) pattern:("*"+ _string +"*") then
					(
						lvInfo.items.add (_auxNodes[i].name)
						lvInfo.items.item[_addedItems-1].SubItems.add ((_editCa.focus) as string)
						lvInfo.items.item[_addedItems-1].SubItems.add ((_editCa.percentage)as string)
						_addedItems+=1
					)
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | renameObj | Funcion para renombrar el objeto siguiendo unos patrones de naming.
		--@gets: node | _obj | el objeto a renombrar 
		--@gets: node | _ref | la referencia del objeto base.
		------------------------------------------------
		fn renameObj _obj _ref =
		(
			_tmpName = _ref.name
			_tmpNameParts = FilterString _tmpName "_"
			 _tmpNameParts[5] = substituteString _tmpNameParts[5] _tmpNameParts[5] ("fix-"+_tmpNameParts[5])
			_tmpName = lb.str.join _tmpNameParts "_"
			
			_auxNodes = lb.layer.getLayerNodes _auxLayer

			_topIndex = -1
			for _auxNode in _auxNodes do 
			(
				if matchpattern _auxNode.name pattern:("*"+_tmpNameParts[5]+"*") do 
				(
					_tmpPart5 = (filterString _auxNode.name "_")[5]
					_tmpIndex = (filterString _tmpPart5 "#")
					if _tmpIndex.count == 1 then 
					(
						if (_topIndex as integer ) < 1 do _topIndex = 0 
					)
					else 
					(
						if (_topIndex as integer ) < (_tmpIndex[2] as integer) do _topIndex = (_tmpIndex[2] as integer )
					)
				)
			)
			_finalNameParts = filterString _tmpName "_"

			if _topIndex != -1 then
			(
				_topIndex += 1
				if _topIndex <= 9 then
				(
					_topIndex = "#00" + (_topIndex as string)
				)
				else if  _topIndex <= 99 then
				(
					_topIndex = "#0" + (_topIndex as string)
				)
				else _topIndex ="#" + (_topIndex as string)

				_finalNameParts[5] = _finalNameParts[5] + _topIndex
			)
			_finalName = lb.str.join _finalNameParts "_"
			_finalName += "h"

			_obj.name = _finalName
		)

		------------------------------------------------
		--@fn: undefined | layerInit | Funcion para inicializar las layers auxiliares donde se guardan los objetos
		------------------------------------------------
		fn layerInit =
		(
			_tmp = lb.layer.getLayerbyName "_auxAnimFix_"
			if _tmp == undefined then 
			(
				_tmp = lb.layer.newLayer name:"_auxAnimFix_"
			)
			_auxLayer = _tmp
		)

		------------------------------------------------
		--@fn: undefined | enableRunButton | Función usada en callback de cambió de selseccion para activar o desactivar el boton de edit pose si hay algun objeto usable en la seleccion
		------------------------------------------------
		fn enableRunButton = 
		(
			chbrun.enabled = false
			if selection.count > 0 do 
			(
				for _obj in selection do
				(
					if ((filterString _obj.name "_")[3] == lb.nc.NC_classMesh) or ((filterString _obj.name "_")[3] == lb.nc.NC_classCloth) do 
					(
						chbrun.enabled = true
					)	
				)
			)
		)
		

		------------------------------------------------
		--@fn: undefined | updateButtonsUI | Actualiza la interfaz grafica con el prev y siguiente, desabilitandolos cuando la seleccion interna esta a 1 o al max.
		--@gets: integer | _internalIndex | indice del controlador interno de las mallas isoladas
		--@gets: array | _meshCopies | las mallas isoladas
		------------------------------------------------
		fn updateButtonsUI _internalIndex _meshCopies = 
		(
			if chbrun.enabled == true then 
			(
				btnPrev.enabled = true 
				btnNext.enabled = true

				if _saveSelection[_internalIndex] == true then 
				(
					chbSaveInfo.text = "Save this piece"
					chbSaveInfo.checked = true
				)
				else 
				(
					chbSaveInfo.text = "DON'T Save this piece"
					chbSaveInfo.checked = false 
				)
				

				if _internalIndex == 1 then 
				(
					btnPrev.enabled = false 
				)
				if _internalIndex == _meshCopies.count then 
				(
					btnNext.enabled = false 
				)
			)
			else 
			(
				btnPrev.enabled = false 
				btnNext.enabled = false 
				chbSaveInfo.text = "DON'T Save this piece"
			)
		)

		------------------------------------------------
		
		--@fn: undefined | getObjToPaint | Refresca en el visor el ciclo entre objetos de deformación.
		--@gets: integer | _internalIndex | indice del controlador interno de las mallas isoladas
		--@gets: array | _meshCopies | las mallas isoladas
		------------------------------------------------

		fn getObjToPaint _internalIndex _meshCopies = 
		(
			for _meshCopy in _meshCopies do 
			(
				_meshCopy.ishidden = false 
			)
			setArrowCursor()
			select _meshCopies[_internalIndex]
			modPanel.setCurrentObject _meshCopies[_internalIndex].modifiers[#Edit_P_Anim_Fix]
			subobjectLevel = 1
			macros.run "PolyTools" "PolyDrawDrag"
			macros.run "PolyTools" "PolyShiftMove"
		)

		------------------------------------------------
		--@fn: undefined | addEditPolyBeforeTurbos | Añade un modificador edit poly o morpher antes del modificador turbosmooth
		--@gets: array | _meshes | las meshes a las que añadir el modificador.
		--@gets: _mode | string | #Edit_Poly ó #Morpher
		------------------------------------------------

		fn addEditPolyBeforeTurbos _meshes _mode = 
		(
			_lowestTurbo = 0 
			for _mesh in _meshes do 
			(
				_mymod = undefined 
				case _mode of
				(
					#Edit_Poly: _mymod = Edit_poly name:"Edit_P_Anim_Fix"
					#Morpher: _mymod = Morpher name:"Morph_Anim_Fix"
				)
				
				for i = 1 to _mesh.modifiers.count do 
				(
					if classOf _mesh.modifiers[i] == TurboSmooth or classOf _mesh.modifiers[i] == Shell do _lowestTurbo = i
					if classOf _mesh.modifiers[i] == Shell do _mesh.modifiers[i].enabled = false 
				)
				if _lowestTurbo == 0 then 
				(
					addModifier _mesh _mymod
				)
				else 
				(
					addModifier _mesh _mymod before:_lowestTurbo 
				)
			)
		)

		------------------------------------------------
		--@fn: undefined | createIsolateObjects | Crea una copia de edición de los objetos seleccionados y las isola.
		------------------------------------------------
		fn createIsolateObjects = 
		(
			_selection = #()
			_saveSelection = #()
			_baseMeshes = #()
			_meshCopies = #()
			for _obj in selection where ((filterString _obj.name "_")[3] == lb.nc.NC_classMesh) or ((filterString _obj.name "_")[3] == lb.nc.NC_classCloth) do 
			(
				_copy = copy _obj
				_auxLayer.addNode _copy
				renameObj _copy _obj
				for i = _copy.modifiers.count to 1 by -1 do 
				(
					if _copy.modifiers[i].name == "Morph_Anim_Fix" do deletemodifier _copy _copy.modifiers[i]
				)
				append 	_meshCopies _copy
				append _baseMeshes _obj
				append _selection _copy
				append _saveSelection true
			)
			addListenerToCurrentSceneObjects()
			select _selection
			IsolateSelection.EnterIsolateSelectionMode()
		)	

		------------------------------------------------
		--@fn: boolean | isEmptyMorpher | Función que consulta si un modificador de morph tiene todos sus canales vacíos.
		--@gets: modifier | _morpher | El modificador al que realizar la consulta.
		------------------------------------------------
		fn isEmptyMorpher _morpher =
		(
			_keep = true
			_index = 0

			for n=1 to 100 do
			(
				keep = WM3_MC_HasData _morpher n
				if keep do _index += 1	
			)
			if _index == 0 then return true 
			else return false
		)
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
			layerInit()
			callbacks.addscript #selectionSetChanged "lb.animDeform.rollMain.enableRunButton()" id:#buttonListener
			callbacks.addscript #selectionSetChanged "lb.animDeform.rollMain.updateUILVcontent()" id:#lvRedrawer
			--addListenerToCurrentSceneObjects()
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
			callbacks.removescripts id:#buttonListener
			callbacks.removescripts id:#lvRedrawer
			--deleteAllChangeHandlers id:#animDeformCH
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
				
			)--if
			------------------------------------------------------------------------------
		)

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
			resize size
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			parent.rollMain.width = 230
			createSceneEvents() --crea los callbacks
			initInfoListView()
			updateListView()

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
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)

		-----------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del boton.
		--@control: checkbutton | chbSaveInfo | El elemento que dispara el evento.
		------------------------------------------------		
		on chbSaveInfo changed state do 
		(
			if state then 
			(
				chbSaveInfo.text = "Save this piece"
				_saveSelection[_internalIndex] = true
			)
			else
			(
				chbSaveInfo.text = "DON'T Save this piece"
				_saveSelection[_internalIndex] = false
			)
		)
		-----------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del boton.
		--@control: checkbutton | btnTrackView | El elemento que dispara el evento.
		------------------------------------------------
		on btnTrackView changed state do 
		(
			updateListView()
			if state == true then 
			(
				btnTrackView.caption = "<< Shrink Manager <<"
				parent.rollMain.width = 750
			)
			else
			(
				btnTrackView.caption = ">> Expand Manager >>"
				parent.rollMain.width = 230
				btnDelete.enabled = false
			)
		)
 
		-----------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el estado del boton.
		--@control: checkbutton | chbrun | El elemento que dispara el evento.
		------------------------------------------------
		on chbrun changed state do 
		(
			if state then 
			(
				btnPrev.enabled = true 
				btnNext.enabled = true
				btnMoveTool.enabled = true 
				btnPushTool.enabled = true
				btnRelaxTool.enabled = true
				spnRange.enabled = true
				chbSaveInfo.enabled = true
				btnCommit.enabled = true
				createIsolateObjects()
				for _node in _selection do lb.animDeform.addCustAttrib _node
				addEditPolyBeforeTurbos _selection #Edit_poly
				updateButtonsUI _internalIndex _selection
				getObjToPaint _internalIndex _selection 
				updateListView()
			)
			else 
			(
				for i = _selection.count to 1 by -1 do 
				(
					delete _selection[i]
				)
				_selection = #()
				_saveSelection = #()
				_internalIndex = 1
				btnPrev.enabled = false 
				btnNext.enabled = false
				btnMoveTool.enabled = false 
				btnCommit.enabled = false 
				btnPushTool.enabled = false
				btnRelaxTool.enabled = false
				spnRange.enabled = false
				chbSaveInfo.enabled = false
				chbSaveInfo.text =  "Mesh Save Info"
				chbSaveInfo.checked = false 
				updateListView()
			)
		)

		-----------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnMoveTool | El elemento que dispara el evento.
		------------------------------------------------

		on btnMoveTool pressed do 
		(
			macros.run "PolyTools" "PolyDrawDrag"
			macros.run "PolyTools" "PolyShiftMove"
		)

		-----------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnPushTool | El elemento que dispara el evento.
		------------------------------------------------

		on btnPushTool pressed do 
		(
			macros.run "PolyTools" "PolyDrawDrag"
			macros.run "PolyTools" "PaintDeformPushPull"
		)

		-----------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnPushTool | El elemento que dispara el evento.
		------------------------------------------------

		on btnRelaxTool pressed do 
		(
			macros.run "PolyTools" "PolyDrawDrag"
			macros.run "PolyTools" "PaintDeformRelax"
		)

		-----------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnPrev | El elemento que dispara el evento.
		------------------------------------------------

		on btnPrev pressed do 
		(
			_internalIndex -=1
			updateButtonsUI _internalIndex _selection
			getObjToPaint _internalIndex _selection 
		)

		-----------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnNext | El elemento que dispara el evento.
		------------------------------------------------
	
		on btnNext pressed do 
		(
			_internalIndex +=1
			updateButtonsUI _internalIndex _selection
			getObjToPaint _internalIndex _selection 
		)
		-----------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnCommit | El elemento que dispara el evento.
		------------------------------------------------
	
		on btnCommit pressed do 
		(
			for i = _baseMeshes.count to 1 by -1 do 
			(
				if _saveSelection[i] == true then 
				(
					_theIndex = undefined
					for j = _baseMeshes[i].modifiers.count to 1 by -1 do 
					(
						if _baseMeshes[i].modifiers[j].name == "Morph_Anim_Fix" do _theIndex = j
					)
					if _theIndex == undefined do  
					(
						addEditPolyBeforeTurbos _baseMeshes[i] #Morpher
						for j = _baseMeshes[i].modifiers.count to 1 by -1 do 
						(
							if _baseMeshes[i].modifiers[j].name == "Morph_Anim_Fix" do _theIndex = j
						)
					)

					_keep = true
					_index = 1

					select _baseMeshes[i]

					for n=1 to 100 do
					(
						keep = WM3_MC_HasData _baseMeshes[i].modifiers[_theIndex] n
						if keep do _index = n + 1	
					)


					_morphChannelNames = #()
					for j = 1 to _index do 
					(
						append _morphChannelNames (wm3_mc_getname _baseMeshes[i].modifiers[_theIndex] j)
					)

					_baseMeshes[i].modifiers[_theIndex].Autoload_of_targets = 1

					_addToMorph = true 
					for j = 1 to _morphChannelNames.count do 
					(
						if _meshCopies[i].name == _morphChannelNames[j] do _addtoMorph = false
					)

					if _addToMorph == true do 
					(
						WM3_MC_BuildFromNode _baseMeshes[i].modifiers[_theIndex] _index _meshCopies[i]
						WM3_MC_Rebuild _baseMeshes[i].modifiers[_theIndex] _index

						with animate on 
						(
							t = currentTime
							_baseMeshes[i].modifiers[_theIndex][_index].value = 100
							sliderTime = (t-spnRange.value)
							_baseMeshes[i].modifiers[_theIndex][_index].value = 0
							sliderTime = (t+spnRange.value)
							_baseMeshes[i].modifiers[_theIndex][_index].value = 0
							sliderTime = t
						)
					)
					animButtonState = false
					lb.animDeform.setCustAttribInfo _meshCopies[i]
					_meshCopies[i].ishidden = true
					updateListView()
				)
				else
				(
					delete _meshCopies[i]
				) 
			)
			IsolateSelection.ExitIsolateSelectionMode()
			chbrun.checked = false
			_internalIndex = 1
			btnPrev.enabled = false 
			btnNext.enabled = false
			btnMoveTool.enabled = false 
			btnPushTool.enabled = false
			btnRelaxTool.enabled = false
			spnRange.enabled = false
			chbSaveInfo.text =  "Mesh Save Info"
			chbSaveInfo.checked = false 
			chbSaveInfo.enabled = false
			btnCommit.enabled = false 
		)

		-----------------------------------------------
		--@event: changed | Evento que se lanza al modificar el contenido del editText
		--@control: button | edtFilter | El elemento que dispara el evento.
		------------------------------------------------
		on edtFilter changed state do
		(
			filterListView edtFilter.text
		)

		-----------------------------------------------
		--@event: mouseUp | Evento que se lanza al dejar de pulsar el botón del mouse.
		--@control: listView | lvInfo | El elemento que dispara el evento.
		------------------------------------------------
		on lvInfo MouseUp events do 
		(
			_button = events.button.ToString() --averigua si es boton izquierdo, derecho o central
			case _button of
			(
			/*	"Right": --boton derecho
				(
					try (_node = getNodeByName lvInfo.selectedItems.item[0].text) catch ()
					if _node != undefined do 
					(
						_target = getNodeByName (_node.custAttributes[#containerInfo].meshNode)
						_tempLVSelection = _node
						select _target
						try (DestroyDialog editRollout) catch ()
						createDialog editRollout
					)

				)--Right*/

				default:
				(
		 			if lvInfo.selectedItems.count != 0 then
					(
						try (_node = getNodeByName lvInfo.selectedItems.item[0].text) catch ()
						if _node != undefined do 
						(
							_target = getNodeByName (_node.custAttributes[#containerInfo].meshNode)
							_tempLVSelection = _node
						)
						btnDelete.enabled = true
					)
					else 
					(
						btnDelete.enabled = false
					)
				)
			)--case		
		)

		-----------------------------------------------
		--@event: pressed | Evento que se lanza al pulsar el boton.
		--@control: button | btnDelete | El elemento que dispara el evento.
		------------------------------------------------
		on btnDelete pressed do 
		(
			process = lb.message.show ("Are you sure you want to delete:\n "+_tempLVSelection.name+" deformation?") type:#query
			if process do 
			(
				tmpName = (_tempLVSelection.custAttributes[#containerInfo].meshNode)
				tmpName[tmpName.count] = substituteString tmpName[tmpName.count] tmpName[tmpName.count] ""
				_node = getNodeByName (tmpName)
				select _node

				if isProperty _node #Morph_Anim_Fix do
				(
					_keep = true
					_index = 1
					_finalIndex = 0

					for n=1 to 100 do
					(
						keep = WM3_MC_HasData _node.Morph_Anim_Fix n
						if keep do _index = n + 1	
					)
					for i = 1 to _index do 
					(
						_target = (wm3_mc_getname _node.Morph_Anim_Fix i)
						if _target == _tempLVSelection.name then 
						(
							_finalIndex = i
						)
					)
					WM3_MC_Delete _node.Morph_Anim_Fix _finalIndex
					for i = (_finalIndex+1) to _index do 
	 				(
	 					WM3_MoveMorph _node.Morph_Anim_Fix i (i-1)
	 				)
	 				delete _tempLVSelection

	 				updateListView()

	 				for i = _node.modifiers.count to 1 by -1 do 
	 				(
	 					if classOf _node.modifiers[i] == Morpher do 
	 					(
	 						if isEmptyMorpher _node.modifiers[i] do 
	 						(
	 							deleteModifier _node i
	 						)
	 					)
	 				)
				)
			)
		)

		-----------------------------------------------
		--@event: MouseDoubleClick | Evento que se lanza al hacer dobleClick sobre una celda del listview.
		--@control: listView | lvInfo | El elemento que dispara el evento.
		------------------------------------------------
		on lvInfo MouseDoubleClick events do
		(
			_button = events.button.ToString() --averigua si es boton izquierdo, derecho o central
			case _button of
			(
				"Left": --boton derecho
				(
					if lvInfo.selectedItems.count != 0 then
					(
						_node = getNodeByName lvInfo.selectedItems.item[0].text
						if _node.ishidden == true then
						(
							_node.ishidden = false
							select _node
							IsolateSelection.EnterIsolateSelectionMode()

							_editCa = _node.custAttributes[#containerInfo]
							if _editCa != undefined then
							(
								slidertime =((_editCa.focus) as time)
							)
							createDialog deformRollout
						)
						else 
						(
							try (destroydialog deformRollout) catch ()
							_node.ishidden = true
							IsolateSelection.ExitIsolateSelectionMode()
							clearSelection()
						)
					)
				)
			)
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta anim_deform.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_animDeform
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,													--@var: name | category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la tool.
		description = "Tool anim_deform",									--@var: string | description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: string | cfgFile | Archivo de configuracion de la tool.
			
		opened = false,														--@var: boolean | opened | Indica si la herramienta está abierta.

		containerInfo = ca_containerInfo, 									--@var: attribute | containerInfo | Variable que guarda la información de un customAttribute de tipo containerInfo.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,												--@var: rollout | rollMain | Almacena el rollout principal de la herramienta.
			
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------

		------------------------------------------------
		--@fn: undefined | addCustAttrib | Añade un customAttribute de tipo containerInfo, con los valores sin inicializar por defecto, al nodo seleccionado
		--@gets: node | _Node | Nodo al que aplicar el custAttribute. 
		------------------------------------------------		
		fn addCustAttrib _Node =
		(
			_editCa = _Node.custAttributes[#containerInfo]
			if _editCa == undefined then
			(
				custAttributes.add _Node (this.containerInfo) #unique baseobject:false --le añade el atributo
			)
		),

		------------------------------------------------
		--@fn: undefined | setCustAttribInfo | Inicializa los valores del customAttribute de tipo containerInfo del nodo seleccionado.
		--@gets: node | _node | Nodo al que aplicar el custAttribute. 
		------------------------------------------------
		fn setCustAttribInfo _node = 
		(
			_tmp = (substituteString _Node.name "fix-" "")
			_tmpParts = filterstring _tmp "_"
			if ((filterstring _tmpParts[5] "#").count) == 2 do 
			(
				_tmpParts[5] = (filterstring _tmpParts[5] "#")[1]
				_tmp = lb.str.join _tmpParts "_"
			)
			
			_editCa = _Node.custAttributes[#containerInfo]
			if _editCa == undefined then
			(
				custAttributes.add _node (this.containerInfo) #unique baseobject:false --le añade el atributo
				_editCa = _Node.custAttributes[#containerInfo]
			)
			_editCa.meshNode = _tmp
			_editCa.focus = sliderTime
			_editCa.percentage = 100
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
		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
		--@returns: boolean | undefined | Devuelve True si la herramienta está abierta.
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
		
	)--tl_animDeform
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_animDeform() --crea la herramienta
)