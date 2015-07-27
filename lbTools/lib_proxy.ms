------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de proxy
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de proxy.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_proxy
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria proxy",	--@var: description | Descripcion de la libreria.
		
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
		--GETS
		------------------------------------------------
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		----------------------------------------------------------------------------------------
		--desactiva los proxys de un objeto
		----------------------------------------------------------------------------------------
		fn disableProxy obj =
		(
			proxyMod = obj.modifiers["ProxyLow"] --obtiene el modificador proxy
			proxyDeleteMod = obj.modifiers["ProxyDelete"] --obtiene el modificador que elimina la geomteria del objeto
			
			if proxyMod != undefined and proxyDeleteMod != undefined then --desactiva los modificadores
			(
				proxyDeleteMod.enabled = false
				proxyMod.enabled = false
			)
		),	

		----------------------------------------------------------------------------------------
		--activa los proxys de un objeto
		----------------------------------------------------------------------------------------
		fn enableProxy obj =
		(
			proxyMod = obj.modifiers["ProxyLow"] --obtiene el modificador proxy
			proxyDeleteMod = obj.modifiers["ProxyDelete"] --obtiene el modificador que elimina la geomteria del objeto
			
			if proxyMod != undefined and proxyDeleteMod != undefined then --activa los modificadores
			(
				proxyDeleteMod.enabled = true
				proxyMod.enabled = true
			)
		),
		
		----------------------------------------------------------------------------------------
		-- elimina los proxies del objeto OBJ
		----------------------------------------------------------------------------------------
		fn removeProxy obj =
		(
			proxyMod = obj.modifiers["ProxyLow"] --obtiene el modificador proxy
			proxyDeleteMod = obj.modifiers["ProxyDelete"] --obtiene el modificador que elimina la geomteria del objeto
			
			if proxyMod != undefined then deleteModifier obj proxyMod
			if proxyDeleteMod != undefined then deleteModifier obj proxyDeleteMod
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
	)--lib_proxy
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_proxy() --crea la libreria
)