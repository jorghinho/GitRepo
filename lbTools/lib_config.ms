------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: librería que contiene funcionalidades de configuración. Asi como metodos para acceder a ubicaciones de la producción.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: lib_config | Contiene todas las funciones de configuración.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_config
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),												--@var: string | def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),									--@var: string | defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,													--@var: name | category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: string | className | Nombre de la libreria.
		description = "Libreria de configuracion",							--@var: string | description | Descripcion de la libreria.
		
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
		--@fn: string | getIconsPath | Consulta el directorio donde se encuentran los iconos estandar de max.
		--@returns: string | undefined | Devuelve el path de iconos estandar
		------------------------------------------------
		fn getIconsPath =
		(
			if (maxVersion())[1] < 15000 then ((getDir #ui) + "icons\\")
			else ((getDir #maxroot) + "UI_ln\\Icons\\")
		),
		
		------------------------------------------------
		--@fn: string | getCustomIconsPath | Consulta el directorio donde se encuentran los iconos personalizados.
		--@returns: string | undefined | Devuelve el path de iconos personalizados
		------------------------------------------------		
		fn getCustomIconsPath =
		(
			_pathParts = FilterString (getFilenamePath this.defFile) "\\"
			_lastPart = _pathParts[_pathParts.count]
			
			if (maxVersion())[1] < 15000 then ((getDir #maxroot) + "ui\\macroscripts\\" + _lastPart + "\\icons\\")
			else ((getDir #maxroot) + "MacroScripts\\" + _lastPart + "\\icons\\")
		),
		
		------------------------------------------------
		--@fn: string | getToolsIconsPath | Consulta el directorio donde se encuentran los iconos personalizados de las herramientas.
		--@returns: string | undefined | Devuelve el path de iconos personalizados de las herramientas.
		------------------------------------------------		
		fn getToolsIconsPath =
		(
			_pathParts = FilterString (getFilenamePath this.defFile) "\\"
			_lastPart = _pathParts[_pathParts.count]
			
			((getDir #maxroot) + "stdplugs\\stdscripts\\" + _lastPart + "\\icon\\")
		),
		

		------------------------------------------------
		--@fn: string | getScriptsPath | Consulta el directorio donde se encuentran las scripts de las herramientas
		--@returns: string | undefined | Devuelve el path de scripts de las herramientas.
		------------------------------------------------		
		fn getScriptsPath =
		(
			/*((getDir #maxroot) + @"stdplugs\stdscripts\lbtools\")*/
			(getFilenamePath this.defFile)
		),
		
		------------------------------------------------
		--@fn: string | getMacrosPath | Consulta el directorio donde se encuentran las macros de las herramientas
		--@returns: string | undefined | Devuelve el path de macros de las herramientas.
		------------------------------------------------			
		fn getMacrosPath =
		(
			/*((getDir #maxroot) + @"ui\macroscripts\lbtools\")*/
			_pathParts = FilterString (getFilenamePath this.defFile) "\\"
			_lastPart = _pathParts[_pathParts.count]
			
			if (maxVersion())[1] < 15000 then ((getDir #maxroot) + "ui\\macroscripts\\" + _lastPart + "\\")
			else ((getDir #maxroot) + "MacroScripts\\" + _lastPart + "\\")
		),

		------------------------------------------------
		--@fn: string | getToolsConfigPath | Consulta el directorio donde se encuentran los archivos y subcarpetas de configuracion.
		--@returns: string | undefined | Devuelve el path de los archivos y subcarpetas de configuracion.
		------------------------------------------------		
		fn getToolsConfigPath =
		(
			/*((getDir #maxroot) + @"stdplugs\stdscripts\lbtools\cnfg\")*/
			((getFilenamePath this.defFile) + "cnfg\\")
		),
		
		------------------------------------------------
		--@fn: string | getToolsDocPath | Consulta el directorio donde se encuentran los archivos de documentacion de las tools
		--@returns: string | undefined | Devuelve el path de los archivos de documentacion de las tools
		------------------------------------------------		
		fn getToolsDocPath =
		(
			/*((getDir #maxroot) + @"stdplugs\stdscripts\lbtools\toolsDoc\")*/
			((getFilenamePath this.defFile) + "toolsDoc\\")
		),	

		------------------------------------------------
		--@fn: string | getToolsIniPath | Consulta el directorio donde se encuentran los archivos .ini de las configuraciones de las herramientas.
		--@returns: string | undefined | Devuelve el path de los archivos .ini de las configuraciones de las herramientas.
		------------------------------------------------		
		fn getToolsIniPath =
		(
			/*((getDir #maxroot) + @"stdplugs\stdscripts\lbtools\cnfg\ini\")*/
			((getFilenamePath this.defFile) + "cnfg\\ini\\")
		),
		
		------------------------------------------------
		--@fn: string | getAssembliesPath | Consulta el directorio donde se encuentran los archivos .dll que necesiten las herramientas.
		--@returns: string | undefined | Devuelve el path de los archivos .dll que necesiten las herramientas.
		------------------------------------------------			
		fn getAssembliesPath =
		(
			/*((getDir #maxroot) + @"stdplugs\stdscripts\lbtools\cnfg\ini\")*/
			((getFilenamePath this.defFile) + "dll\\")
		),
		
		------------------------------------------------
		--@fn: string | getExePath | Consulta el directorio donde se encuentran los archivos .exe que necesiten las herramientas.
		--@returns: string | undefined | Devuelve el path de los archivos .exe que necesiten las herramientas.
		------------------------------------------------		
		fn getExePath =
		(
			/*((getDir #maxroot) + @"stdplugs\stdscripts\lbtools\exe\")*/
			((getFilenamePath this.defFile) + "exe\\")
		),
		
		------------------------------------------------
		--@fn: string | getTempPath | Consulta el directorio donde se encuentran los archivos temporales para las herramientas.
		--@returns: string | undefined | Devuelve el path de los archivos temporales para las herramientas.
		------------------------------------------------				
		fn getTempPath =
		(			
			((getFilenamePath this.defFile) + "tmp\\")
		),
		
		------------------------------------------------
		--@fn: string | getNamingConventionPath | Consulta el directorio donde se encuentran los archivos de configuracion de namingConvention.
		--@returns: string | undefined | Devuelve el path de los archivos de configuracion de namingConvention.
		------------------------------------------------		
		fn getNamingConventionPath =
		(
			/*((getDir #maxroot) + @"stdplugs\stdscripts\lbtools\cnfg\projectInfo\")*/
			((getFilenamePath this.defFile) + "cnfg\\projectInfo\\")
		),
		
		------------------------------------------------
		--@fn: string | getLogPath | Consulta el directorio donde se encuentran los archivos de logs de las herramientas.
		--@returns: string | undefined | Devuelve el path de los archivos de logs de las herramientas.
		------------------------------------------------		
		fn getLogPath =
		(			
			((getFilenamePath this.defFile) + "log\\")
		),

		------------------------------------------------
		--@fn: string | getAnimationStampsFilePath | Consulta el directorio donde se encuentran el archivo de donde leer los stamps de animacion
		--@returns: string | undefined | Devuelve el path al archivo de donde leer los stamps de animacion
		------------------------------------------------			
		fn getAnimationStampsFilePath =
		(
			"\\\\lbdata001\\y\\sequence\\doc\\ctf_stamp_animation.txt"
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | copyPlugQtimeConfig | Copia la configuracion correcta de qtime h264 a la carpeta de configuracion de plugins de cada usuario
		------------------------------------------------			
		fn copyPlugQtimeConfig =
		(
			--path del archivo viejo y el nuevo
			_newCfgFile = this.getToolsConfigPath() + "qtime\\QTime.cfg"
			_oldCfgFile = (getDir #plugcfg ) + "\\QTime.cfg"
			
			--sobrescribe la configuracion de qtime
			if doesFileExist _oldCfgFile then deleteFile _oldCfgFile
			if not doesFileExist _oldCfgFile and doesFileExist _newCfgFile then copyFile _newCfgFile _oldCfgFile
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | loadAssemblies | Carga archivos dll necesarios para algunas herramientas antes de que éstas se inicialicen.
		------------------------------------------------
		fn loadAssemblies =
		(
			_dllFiles = getFiles (this.getAssembliesPath() + "*.dll") --busca los archivos dll
			for _dll in _dllFiles do dotnet.loadAssembly _dll --carga los encontrados
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
			this.loadAssemblies() --en el momento de crearse, carga los assemblies que necesitarán las tools
			
			lb.addLibrary this --añade la libreria a la principal
		)
		
	)--lib_template
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	lib_config() --crea la libreria	
)