------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Geometry Modification Copy.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta de copia de modificaciones de geometría.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "Geometry modification copy"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
			
		local minRollWidth = 220	--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 365	--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		local originObj = undefined		--@var: originObj | Almacena el objeto original que tener como referencia.
		local originObjNumVerts = 0		--@var: originObjNumVerts | Almacena el numero de vertices del objeto original.
		
		local modifiedObj = undefined	--@var: modifiedObj | Almacena el objeto modificado para compararlo con el original.
		local modifiedObjNumVerts = 0	--@var: modifiedObjNumVerts | Almacena el numero de vertices del objeto modificado.
		
		local targets = #()				--@var: targets | Almacena los objetos en los que aplicar la modificación.
		
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
				
		label lblSeparator001 "______________________________________" pos:[5,37] width:210 height:15 enabled:false
		label lblSeparator002 "______________________________________" pos:[5,80] width:210 height:15 enabled:false
		label lblSeparator003 "______________________________________" pos:[5,273] width:210 height:15 enabled:false
			
		label lblOrigin "org:" pos:[5,8] width:20 height:15
		pickButton pckOrigin "original: <object>" pos:[25,5] width:190 height:20	--@control: pckOrigin | Pick button para elegir el objeto original.
		
		label lblModified "mdf:" pos:[5,28] width:20 height:15
		pickButton pckModified "modified: <object>" pos:[25,25] width:190 height:20	--@control: pckModified | Pick button para elegir el objeto modificado.
		
		label lblCopyMode "Apply geometry changes to:" pos:[6,55] width:210 height:15 enabled:false		
		radiobuttons rdoCopyMode "" pos:[5,72] width:210 height:20 labels:#("baseObj", "editPoly", "morpher") columns:3  enabled:false	--@control: rdoCopyMode | Radiobuttons para elegir el modo de propagación de la modificación de la geometría.
		
		listBox lbxTargets "Target Objects" pos:[5,96] width:210 height:11 enabled:false	--@control: lbxTargets | Listbox para los objetos que van a ser modificados.
		button btnGetSel "Add selected" pos:[5,260] width:70 height:20 enabled:false		--@control: btnGetSel | Botón para obtener como targets los objetos seleccionados.
		button btnAddByList "Add by list" pos:[75,260] width:70 height:20 enabled:false		--@control: btnAddByList | Botón para elegir como targets los objetos desde un listado.
		button btnClear "Clear" pos:[180,260] width:35 height:20 enabled:false				--@control: btnClear | Botón para limpiar el listado de targets.
		
		label lblName "New modifier name:" pos:[5,290] width:210 height:15 enabled:false
		editText edtName "" pos:[0,305] width:215 height:20 enabled:false		--@control: edtName | EditText para el nombre del modificador de los objetos una vez modificados, si se usa modificador.
				
		button btnApply "Apply" pos:[5,335] width:210 height:20 enabled:false	--@control: btnApply | Botón para propagar las modificaciones a los targets.
		progressBar pbProgress "" pos:[5,355] width:210 height:8 visible:false	--@control: pbProgress | Barra de progreso durante la aplicación de las modificaciones.
		
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
		--@fn: boolean | filterEditPoly | Filtra que los objetos sean de tipo editPoly y coincidan en numero de vertices con el objeto original. Devuele TRUE si el objeto a comprobar es editPoly y FALSE si no.
		--@gets: node | obj | Objeto de la escena que se va a comprobar si es editPoly.
		------------------------------------------------
		fn filterEditPoly obj =
		(
			_success = false
			
			if ((classof obj == PolyMeshObject) or (classof obj == Editable_Poly)) and obj != modifiedObj and obj != originObj then
			(
				--crea una copia temporal para obtener el numero de vertices del objeto.
				aux = copy obj
				collapseStack aux
				auxNumVerts = polyop.getNumVerts aux
				delete aux
				
				--si el número de vértices coincide es un objeto válido.
				if (auxNumVerts == modifiedObjNumVerts) and (obj != modifiedObj) then _success = true
			)--if
			
			_success
		)
			
		------------------------------------------------
		--@fn: undefined | updateUI | Actualiza los valores de los controles del interface.
		------------------------------------------------
		fn updateUI =
		(
			if originObj != undefined  and modifiedObj != undefined then --activa los controles del UI
			(
				
				lblCopyMode.enabled = true
				rdoCopyMode.enabled = true
				lbxTargets.enabled = true
				btnGetSel.enabled = true
				btnAddByList.enabled = true
				btnClear.enabled = true
				lblName.enabled = true
				edtName.enabled = true
				
				if targets.count != 0 then
				(
					lbxTargets.items = for o in targets collect o.name
					btnApply.enabled = true
				)--if
			)
			else --desactiva los controles del UI
			(
				if originObj == undefined  and modifiedObj == undefined then
				(
					pckOrigin.caption = "original: <object>"
					pckModified.caption = "modified: <object>"
					lbxTargets.items = #()
				)
				else
				(
					if isValidNode originObj then pckOrigin.caption = originObj.name
					if isValidNode modifiedObj then pckModified.caption = modifiedObj.name
				)--if else
				
				btnApply.enabled = false
				lblCopyMode.enabled = false
				rdoCopyMode.enabled = false
				lbxTargets.enabled = false
				btnGetSel.enabled = false
				btnAddByList.enabled = false
				btnClear.enabled = false
				lblName.enabled = false
				edtName.enabled = false
			)--if else			
		)
		
		------------------------------------------------
		--@fn: undefined | reset | Hace un reset de la herramienta.
		------------------------------------------------
		fn reset =
		(
			--vacia las variables-------------
			originObj = undefined
			originObjNumVerts = 0
			modifiedObj = undefined
			modifiedObjNumVerts = 0
			targets = #()
				
			updateUI()
		)
		
		------------------------------------------------
		--@fn: undefined | createCallbacks | Crea los callbacks de la herramienta
		------------------------------------------------
		fn createCallbacks =
		(
			--global _tmpGeometryModificationCopy = (lb.tools.getTool "geometryModificationCopy")
			callbacks.addscript #filePostOpenProcess "lb.geometryModificationCopy.rollMain.reset()" id:#geometryModificationCopy
		)
		
		------------------------------------------------
		--@fn: undefined | removeCallbacks | Elimina los callbacks de la herramienta
		------------------------------------------------
		fn removeCallbacks =
		(
			callbacks.removescripts id:#geometryModificationCopy
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
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMai/size") "height") as integer
				
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
		--@event | picked | Evento que se lanza al elegir un objeto como original.
		--@control: pickButton | pckOrigin | pickButton para elegir el objeto original.
		--@gets: node | obj | Nodo de la escena elegido como objeto original.
		------------------------------------------------
		on pckOrigin picked obj do
		(
			originObj = undefined
			
			--desactiva el boton de copiar y vacia el listado
			lbxTargets.items = #()
			targets = #()
				
			--comprueba que el objeto elegido sea editPoly
			if isValidNode obj and ((classof obj.baseObject == PolyMeshObject) or (classof obj.baseObject == Editable_Poly)) then originObj = obj
			else messageBox "Modified object must be an Editable_Poly"
				
			if isValidNode originObj then --si el objeto elegido es valido
			(
				--crea una copia temporal para obtener el numero de vertices del objeto original
				aux = copy originObj
				collapseStack aux
				originObjNumVerts = polyop.getNumVerts aux
				delete aux
				
				if isValidNode modifiedObj and modifiedObjNumVerts != originObjNumVerts then
				(
					messageBox "Picked object doesn't match modified object vertex number"
					originObj = undefined
					originObjNumVerts = 0					
				)--if					
			)--if
			
			updateUI()
		)
		
		------------------------------------------------
		--@event | picked | Evento que se lanza al elegir un objeto como modificado.
		--@control: pickButton | pckModified | pickButton para elegir el objeto modificado.
		--@gets: node | obj | Nodo de la escena elegido como objeto modificado.
		------------------------------------------------
		on pckModified picked obj do
		(
			modifiedObj = undefined
			
			--desactiva el boton de copiar y vacia el listado
			lbxTargets.items = #()
			targets = #()
				
			if isValidNode obj and ((classof obj.baseObject == PolyMeshObject) or (classof obj.baseObject == Editable_Poly)) then
				modifiedObj = obj
			else
				messageBox "Modified object must be an Editable_Poly"
				
			if modifiedObj != undefined then 
			(
				--crea una copia temporal para obtener el numero de vertices del objeto modificado
				aux = copy modifiedObj
				collapseStack aux
				modifiedObjNumVerts = polyop.getNumVerts aux
				delete aux
				
				if isValidNode originObj and modifiedObjNumVerts != originObjNumVerts then
				(
					messageBox "Picked object doesn't match origin object vertex number"
					modifiedObj = undefined
					modifiedObjNumVerts = 0					
				)--if				
			)--if
			
			updateUI()
		)
		
		------------------------------------------------
		--@event | pressed | Evento que se lanza al presionar el boton btnGetSel para obtener los nodos seleccionados de la escena como targets.
		--@control: button | btnGetSel | Botón para elegir la selección de nodos de la escena y usarlos como targets.
		------------------------------------------------
		on btnGetSel pressed do
		(
			targets = #()			--objetos a los que copiar el modificador
			_targetNames = #()		--nombres de los targets
			
			_failObjects = #()					--objetos que no tienen el mismo numero de vertices
				
			for obj in selection where (((classof obj == PolyMeshObject) or (classof obj == Editable_Poly))) and (obj != modifiedObj) and (obj != originObj) do
			(
				--crea una copia temporal para obtener el numero de vertices del objeto
				_aux = copy obj
				collapseStack _aux
				_auxNumVerts = polyop.getNumVerts _aux
				delete _aux
				
				if _auxNumVerts == modifiedObjNumVerts then
				(
					append targets obj
					append _targetNames obj.name
				)
				else append _failObjects ("\n" + (obj.name) + " >> " + _auxNumVerts as string + " verts")					
				
				aux = undefined --limpia la memoria del objeto temporal	
			)--for
				
			if _failObjects.count != 0 then
			(
				_message = "some selected objects vertex count don't match modified object:"
				for obj in _failObjects do _message += obj
				messageBox _message
			)--if
			
			updateUI()
		)
		
		------------------------------------------------
		--@event | pressed | Evento que se lanza al presionar el boton btnAddByList para obtener nodos de la escena como targets a partir de un listado.
		--@control: button | btnAddByList | Botón para elegir a partir de un listado los nodos de la escena que usar como targets.
		------------------------------------------------
		on btnAddByList pressed do
		(
			clearSelection()
			_objs = selectByName filter:filterEditPoly --obtiene los objetos de un listado de la escena
			
			if _objs != undefined and _objs.count != 0 then --si hay objetos seleccionados
			(
				targets = #()				--objetos a los que copiar el modificador
				_targetNames = #()		--nombres de los targets
				
				for obj in _objs do
				(
					append targets obj
					append _targetNames (obj.name)
				)--for
			)
			
			updateUI()
		)
		
		------------------------------------------------
		--@event | pressed | Evento que se lanza al presionar el boton btnClear para limpiar el listado de targets.
		--@control: button | btnClear | Botón para limpiar el listado de targets.
		------------------------------------------------
		on btnClear pressed do
		(
			targets = #()
			lbxTargets.items = #()
			updateUI()
		)

		---------------------------------------------------------------------------------------------------------------
		--@event | pressed | Evento que se lanza al presionar el boton btnApply para propagar las modificaciones en los targets.
		--@control: button | btnApply | Botón para aplicar las modificaciones en los targets.
		---------------------------------------------------------------------------------------------------------------
		on btnApply pressed do
		(
			_selBckp = getCurrentSelection() --hace un backup de la seleccion
			
			_relativeVertPositions = #() --posicion relativa de cada vertice de SOURCE respecto de cada vertice de ORIGIN
			_originVertPositions = #() --array para almacenar las posiciones de los vertices en el objeto original
			_sourceVertPositions = #() --array para almacenar las posiciones de los vertices en el objeto modificado
			 			
			_modName = ("geomMod" + (if edtName.text != "" then "_" else "") + edtName.text) --nombre del nuevo modificadores
 			
			_org = copy originObj
			collapseStack _org
			
 			_mdf = copy modifiedObj
 			collapseStack _mdf
			
			--metemos la operacion de obtener el vertice de un editpoly en una variable local para evitar la perdida de memoria y la lentitud (no se porque ocurre pero es asi)
			local _getOrg = _org.getVertex
			local _getSrc = _mdf.getVertex
 			
 			--obtenemos las posiciones de los vertices
			for i=1 to modifiedObjNumVerts do 
			(
				_originVertPositions[i] = _getOrg i
				_sourceVertPositions[i] = _getSrc i
				_relativeVertPositions[i] = (_getSrc i) - (_getOrg i)
			)--for
			
			delete _mdf --elimina el objeto temporal
			delete _org --elimina el objeto temporal
			_mdf = undefined --limpia de la memoria el objeto borrado
			_org = undefined --limpia de la memoria el objeto borrado
			
			pbProgress.visible = true --hace visible la barra de progreso
			pbProgress.value = 0 --valor a cero en la barra de progreso
			cont = 0 --contador para la barra de progreso
			
			_vertList = #{1..(_sourceVertPositions.count)} --lista de los vertices a los que mover sus posiciones, para las opciones 1 y 3
			
			---------------------------------------------------------------------------------------------------------------
			case rdoCopyMode.state of --en funcion del modo de copia
			(
				1: --modo de copia en el objeto base-------------------------------------------------------
				(
					_stop = false
					
					undo "EditPoly copy to baseObject" on
					(
						--recorre los targets aplicandoles las nuevas posiciones de vertices
						for t in targets where not _stop and ((classof t.baseObject == PolyMeshObject) or (classof t.baseObject == Editable_Poly)) do
						(
							polyop.moveVert t _vertList _relativeVertPositions
							cont += 1
							
							if keyboard.escPressed then _stop = queryBox "Do you want to cancel?"
							
							pbProgress.value = 100/targets.count*cont				
						)--for
						
						select _selBckp --recupera la seleccion
					)--undo
				)--modo de copia en el objeto base---------------------------------------------------------
				
				2: --modo de copia en un modificador editPoly---------------------------------------------
				(
					max modify mode --se coloca en el panel de modificadores
					
					with undo off
					(
						--recorre los targets aplicandoles las nuevas posiciones de vertices
						for t in targets where ((classof t.baseObject == PolyMeshObject) or (classof t.baseObject == Editable_Poly)) do
						(
							_ep = edit_poly() --crea el nuevo modificador editPoly
							_ep.name = _modName --cambia el nombre del modificador de acuedo al lo elegido por el usuario
							addModifier t _ep before:(t.modifiers.count + 1) --añade el modificador encima de la pila de modificadores
							
							local _moveSel = _ep.MoveSelection --almacena la operacion de mover la seleccion de vertices
							
							_theMatrixParent = transMatrix t.position
							
							modPanel.setCurrentObject t.modifiers[_modName]
							subobjectLevel = 1
								
							for i=1 to _sourceVertPositions.count do --aplica la nueva posicion de los vertices
							(
								_ep.SetSelection #Vertex #{}
								_ep.Select #Vertex #{i}
								_ep.SetOperation #Transform
								_moveSel _relativeVertPositions[i] parent:_theMatrixParent axis:(transMatrix _sourceVertPositions[i])
								_ep.Commit() --elimina las operaciones del editPoly para que no ocupen
							)--for
							
							subobjectLevel = 0
							cont += 1
							pbProgress.value = 100/targets.count*cont				
						)--for
						
						select _selBckp --recupera la seleccion
					)--undo
				)--modo de copia en un modificador editPoly----------------------------------------------
				
				3: --modo de copia en un modificador morpher--------------------------------------------
				(
					max modify mode --se coloca en el panel de modificadores
					
					_mphName = "morphMod" + (if edtName.text != "" then "_" else "") + edtName.text
					
					_morphModifiers = #() --array donde almacenar los morphs que aplicar a los targets
					_stop = false --flag de parada
					
					--recorre los targets, creando una copia, aplicandoles las nuevas posiciones de vertices y poniendolos como morpher
					for t in targets where not _stop and ((classof t.baseObject == PolyMeshObject) or (classof t.baseObject == Editable_Poly)) do
					(
						_tCopy = copy t --hace una copia del target
						while _tCopy.modifiers.count != 0 do deleteModifier _tCopy 1 --elimina todos sus modificadores
						
						polyop.moveVert _tCopy _vertList _relativeVertPositions
						
						_mph = morpher()--crea el nuevo modificador morpher
						_mph.name = _mphName
						addModifier t _mph before:(t.modifiers.count + 1) --añade el modificador justo sobre el objeto base
						modPanel.setCurrentObject _mph
						append _morphModifiers _mph
						deleteModifier t _mph
						WM3_MC_BuildFromNode _mph 1 _tCopy --añade la copia del target al inicio del morpher
						WM3_MC_SetValue _mph 1 100.0 --coloca el valor del morph a 100
						
						delete _tCopy --elimina el target de la escena
						
						if keyboard.escPressed then _stop = queryBox "Do you want to cancel?"
						
						cont += 1
						pbProgress.value = 100/targets.count*cont	
					)--for
					
					_tCopy = undefined --limpia la memoria del objeto borrado
					pbProgress.value = 0
					cont = 0
					
					if not _stop then
					(
						undo "EditPoly copy to morpher modifier" on
						(
							--recorre los targets aplicando el morpher
							for t in targets do
							(
								if _morphModifiers[cont + 1] != undefined then
									addModifier t _morphModifiers[cont + 1] before:(t.modifiers.count + 1) --añade el modificador justo sobre el objeto base
								
								cont += 1
								pbProgress.value = 100.0/targets.count*cont				
							)--for
							
							select _selBckp --recupera la seleccion
						)--undo
					)--if not stop
				)--modo de copia en un modificador morpher----------------------------------------------
			)--case
			----------------------------------------------------------------------------------------------------------
			
			pbProgress.value = 0
			pbProgress.visible = false
			
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
		--@event | open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createCallbacks()
		)
		
		------------------------------------------------
		--@event | close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeCallbacks()
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: geometryModificationCopy | Contiene la herramienta de modificaciones de geometría.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_geometryModificationCopy
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "Tool para propagar modificaciones de geometria en varios objetos",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,						--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
			
		rollMain = rollMainDef,				--@var: rollMain | Almacena el rollout principal de la herramienta.
		
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
		--@fn: undefined | init | Inicializa la herramienta.
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
			--this.run()
		)
		
	)--tl_geometryModificationCopy
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	--try(lb.geometryModificationCopy.close())catch()
	tl_geometryModificationCopy() --crea la herramienta
)