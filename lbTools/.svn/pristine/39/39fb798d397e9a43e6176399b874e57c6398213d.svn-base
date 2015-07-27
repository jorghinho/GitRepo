--------------------------
-- TAREAS PENDIENTES
-------------------------


------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de skin
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@custAttribute: undefined | skinConnectionInfo | Custom Attribute que indica que tipo de transformación tiene que conectarse con el esqueleto de animación.
	------------------------------------------------------------------------------------------------------------------------------------------------
	CA_skinConnectionInfo = attributes skinConnectionInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_description	type:#string	animatable:false	default: "Almacena informacion sobre la conexion entre rig de animacion y rig de skin, asi como si pertenece al sistema de cabeza."
			CA_version		type:#integer	animatable:false	default: 2.0
			
			--indica si el hueso se conecta con otro de animacion.
			connectionPos	type:#boolean	animatable:false	default:false		-- indica si el hueso de skin tiene asignado un constraint de posición al objeto correspondiente en el esqueleto de animación.
			connectionRot	type:#boolean	animatable:false	default:false		-- indica si el hueso de skin tiene asignado un constraint de rotación al objeto correspondiente en el esqueleto de animación.
			connectionSca	type:#boolean	animatable:false	default:false		-- indica si el hueso de skin tiene asignado un constraint de escala al objeto correspondiente en el esqueleto de animación.
			
			--indica si pertenece al sistema de cabeza del personaje
			headSystem		type:#boolean	animatable:false	default:false		--indica si es hueso pertenece al sistema de cabeza del personaje.
			
			--indica si un hueso o control se debe deconectar o no en modo puppet.
			keepConnected	type:#boolean	animatable:false	default:false		--indica si un hueso o control se debe deconectar o no en modo puppet.
		)
		
		------------------------------------------------------------------------------------------------------------------------------------------------
		--@fn: boolean | connect | Llama a la función de conectar, para conectarse con su hueso correspondiente en las tranformaciones indicadas.
		------------------------------------------------------------------------------------------------------------------------------------------------
		fn connect =
		(
			_obj = (nodeTransformMonitor node:(refs.dependentNodes this immediateOnly:true)[1] forwardTransformChangeMsgs:false)
			
			lb.skinConnectionInfo.connect _obj.node true
		)
		
		fn disConnect =
		(
			_obj = (nodeTransformMonitor node:(refs.dependentNodes this immediateOnly:true)[1] forwardTransformChangeMsgs:false)
			
			lb.skinConnectionInfo.connect _obj.node false
		)
		
		----------------------------------------------------------------------
		--devuelve los valores de los parametros del CA en un string
		----------------------------------------------------------------------
		fn toString =
		(
			("pos:" + (connectionPos as String) + " rot:" + (connectionRot as String) + " scale:" + (connectionSca as String) + " headSystem:" + (headSystem as String) + " keepConnected:" + (keepConnected as String))
		)
		
		--------------------------------------------------
		on load do
		(
		)
		
		--------------------------------------------------
		on create do
		(
		)
	)	
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: skins | Contiene la libreria de skins.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_skinConnectionInfo
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Librería de skin",	--@var: description | Descripcion de la libreria.
		
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
		--@fn: boolean | hasSkinconnectionInfo | Indica si el fichero especificado tiene skins
		--@gets: node | obj | Nodo al que comprobamos si tiene el attributo.
		------------------------------------------------
		fn hasSkinConnectionInfo obj = 
		(
			lb.customAttributes.hasAttribute obj #skinConnectionInfo
		),

		------------------------------------------------
		--@fn: boolean | add | Añade el skins al fichero pasado por parámetro. Devuelve true o false dependiendo si ha conseguido crearlo
		--@gets: node | obj | nodo al que hay que iniciarle el skins
		--@opt: boolean | replace | Indica si hay que reemplazar el skins anterior o simplemente incrementar su información
		------------------------------------------------
		mapped fn addAttribute obj =
		(
			_added = false
			
			-- Eliminamos primero el customAttribute de la pieza si ya lo tenía y creamos uno nuevo
			this.removeAttribute obj
			custAttributes.add obj CA_skinConnectionInfo #unique baseobject:false
				
			_added = true
			
			_added
		),
		
		------------------------------------------------
		--@fn: boolean | removeAttribute | Elimina el skins al fichero pasado por parámetro
		--@gets: node | obj | nodo al que hay que iniciarle el skins
		------------------------------------------------
		mapped fn removeAttribute obj =
		(
			_removed = false
			
			if this.hasSkinconnectionInfo obj then 
			(
				custAttributes.delete obj (custAttributes.getdef obj.skinConnectionInfo) baseobject:false
				_removed = true
			)
			
			_removed
		),
		
		------------------------------------------------
		--@fn: boolean | setSkinConnectionInfo | Establece las propiedades del skinConnectionInfo
		--@gets: node | obj | Nodo donde se va a establecer las propiedades.
		--@gets: node | connectionType | Parametro que queremos establecer. Puede valer: #connectionPos, connectionRot, connectionSca, headSystem, keepConnected
		--@gets: boolean | state | Establece a true o false el estado: Puede valer true o false.
		------------------------------------------------
		mapped fn setSkinConnectionInfo obj connectionType state =
		(
			case connectionType of
			(
				#connectionPos: obj.skinConnectionInfo.connectionPos = state
				#connectionRot: obj.skinConnectionInfo.connectionRot = state
				#connectionSca: obj.skinConnectionInfo.connectionSca = state
				#headSystem: 	obj.skinConnectionInfo.headSystem = state
				#keepConnected: obj.skinConnectionInfo.keepConnected = state
			)
		),
		
		------------------------------------------------
		--@fn:  undefined | setConnection | Conecta los huesos con su hueso correspondiente.
		--@gets: node | obj | nodo al que hay que iniciarle el skins
		------------------------------------------------
		mapped fn setConnection obj connection =
		(
			case connection of
			(
				true: obj.skinConnectionInfo.connect()
				false: obj.skinConnectionInfo.disconnect()
			)
		),	
			
		------------------------------------------------
		--@fn: boolean | isConnected | Comprueba si el hueso está conectado
		--@gets: node | obj |  Nodo del cual comprueba la conexión.
		------------------------------------------------
		fn isConnected obj =
		(
			connected = false

			if (lb.customAttributes.hasAttribute obj #skinConnectionInfo) and (lb.controller.isTransformFrozen obj #all) then --si tiene informacion de conexion o desconexion
			(
				if not connected and obj.skinConnectionInfo.connectionPos then --si tiene informacion de conexion de posicion
					if obj.position.controller["ConnectionPos"] != undefined then
						connected = true
				
				if obj.skinConnectionInfo.connectionRot then --si tiene informacion de conexion de rotacion
					if obj.rotation.controller["ConnectionRot"] != undefined then
						connected = true
					
				if not connected and obj.skinConnectionInfo.connectionSca then --si tiene informacion de conexion de escala
					if classof obj.scale.controller == scale_list then
						if obj.scale.controller["ConnectionSca"] != undefined then
							connected = true
			)
			
			connected
		),
		
		------------------------------------------------
		--@fn:  string array | add | Añade el skins al fichero pasado por parámetro. Si no existía el custom attribute lo crea
		--@gets: node | obj | nodo al que hay que iniciarle el skins
		--@opt: boolean | replace | Indica si hay que reemplazar el skins anterior o simplemente incrementar su información
		------------------------------------------------
		mapped fn add obj connectionType state replace:false =
		(
			-- si la pieza no tiene skins creamos un nuevo custom attribute
			if not (this.hasSkinconnectionInfo obj) or replace then
				this.addAttribute obj
			
			this.setSkinConnectionInfo obj connectionType state
		),
		
		------------------------------------------------
		--@fn: boolean | connect | Conecta el hueso de skin con su correspondiene.
		--@gets: node | obj | Nodo donde se va a establecer las propiedades.
		--@gets: node | connectionType | Parametro que queremos establecer. Puede valer: #connectionPos, connectionRot, connectionSca, headSystem, keepConnected
		--@gets: boolean | state | Establece a true o false el estado: Puede valer true o false.
		------------------------------------------------
		mapped fn connect obj state =
		(
			if state then
			(
			
				-- filtramos el nombre para obtener la 3 parte y sustituirla por rig y guardarnos el nuevo nodo como target para los constraints.				
				_objName = lb.nc.replaceNamePart obj.name 3 lb.nc.NC_classAnim
				_objName = lb.nc.getSimpleObjectName _objName
				
				_target = ((execute ("$'" + _objName + "_*'"))[1])
-- 					_base = lb.rig.solutions.getBaseNode()

				if _target != undefined then
				(
					--realiza la conexion o desconexion
					if state then
					( 
						
						--#POS si debe llevar position constraint y no tiene dicho controlador, se lo pone
						if obj.skinConnectionInfo.connectionPos and obj.position.controller[obj.position.controller.count].name != "ConnectionPos" then
						(
							obj.position.controller.available.controller = position_Constraint()
							obj.position.controller.setName (obj.position.controller.count) "ConnectionPos"
						)
						
						--#ROT si debe llevar orientation constraint y no tiene dicho controlador, se lo pone
						if obj.skinConnectionInfo.connectionRot and obj.rotation.controller[obj.rotation.controller.count].name != "ConnectionRot" then
						(
							obj.rotation.controller.available.controller = orientation_Constraint()
							obj.rotation.controller.setName (obj.rotation.controller.count) "ConnectionRot"
						)

						--#SCA si debe llevar scale constraint y no tiene dicho controlador, se lo pone
						if classof obj.scale.controller == scale_list then
							if obj.skinConnectionInfo.connectionSca and obj.scale.controller[obj.scale.controller.count].name != "ConnectionScale" then
							(
								obj.scale.controller.available.controller = scale_Script() --scaleXYZ()
								obj.scale.controller.setName (obj.scale.controller.count) "ConnectionScale"
							)
						
						--conecta la rotacion y la posicion
						if obj.skinConnectionInfo.connectionPos then obj.position.controller["ConnectionPos"].appendTarget _target 100
						if obj.skinConnectionInfo.connectionRot then obj.rotation.controller["ConnectionRot"].appendTarget _target 100
						
						--conecta la escala
						if obj.skinConnectionInfo.connectionSca then
							if classof obj.scale.controller == scale_list then
							(
								obj.scale.controller["ConnectionScale"].controller.AddNode "target" _target
-- 									obj.scale.controller["ConnectionScale"].controller.AddNode "base" _base
-- 									obj.scale.controller["ConnectionScale"].controller.SetExpression "target.scale/base.scale"
								obj.scale.controller["ConnectionScale"].controller.SetExpression "target.scale"
							)
					)--if state
				)-- _target
			)
			else
			(
				_stop = false
				
				--quita el controlador de conexion de posicion
				if classof obj.position.controller == position_List then
					for i=1 to obj.position.controller.count where not _stop do
						if obj.position.controller[i].name == "ConnectionPos" then
						(
							obj.position.controller.delete i
							_stop = true
						)
						
				_stop = false		
						
				--quita el controlador de conexion de rotacion
				if classof obj.rotation.controller == rotation_List then
					for i=1 to obj.rotation.controller.count where not _stop do
						if obj.rotation.controller[i].name == "ConnectionRot" then
						(
							obj.rotation.controller.delete i
							_stop = true
						)
				
				_stop = false
						
				--quita el controlador de conexion de escala
				if classof obj.scale.controller == scale_list then
					for i=1 to obj.scale.controller.count where not _stop do
						if obj.scale.controller[i].name == "ConnectionScale" then
						(
							obj.scale.controller.delete i
							_stop = true
						)
					
				_stop = false	
			)-- else
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
	)

	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_skinConnectionInfo() --crea la libreria
)