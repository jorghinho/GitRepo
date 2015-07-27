------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de security
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de security.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_security
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria security",	--@var: description | Descripcion de la libreria.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------

		hardwareId 		= hardwareLockID,				-- Identificador de HardwareLock del equpo
		computerName 	= sysinfo.computerName,		-- Nombre del equipo
		numCPUs 			= sysinfo.cpucount,				-- Número de procesadores del equipo
		encryptKey 		= 20080701,						-- Clave de encriptación de ficheros	

		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------

		-------------------------------------------------------------------------------------------
		-- Genera el código hexadecimal de la cadena de texto pasada por parámetro.
		-- Captura los caracteres de la cadena y los convierte a caracteres hexadecimales:
		-- 		- Si el caracter es un número lo almacena tal cual
		--		- Si el caracter es una letra y está entre la A y la F la almacena tal cual
		--		- Para el resto de caracteres devuelve F
		-------------------------------------------------------------------------------------------
		fn getHexaCode str = 
		(
			codeStr = ""			-- contiene los caracteres finales del código
			for i = 1 to str.count do
			(
				s = str[i]
				
				if s >= "0" and s <= "9" then 			-- número
					append codeStr s
				else if s >= "a" and s <= "f" then 	-- letra entre a y f
					append codeStr s 
				else append codeStr "f"					-- resto de caracteres
			)
			
			code = (("0x" + codeStr) as integer)
		),

		-------------------------------------------------------------------------------------------
		-- Crea el código de licencia usando el HardwareLodkId del ordenador, 
		-- su nombre y su número de procesadores
		-------------------------------------------------------------------------------------------
		fn getLicenseCode hardwareId computerName numCPUs = 
		(
			code = (hardwareId + (this.getHexaCode computerName)) * numCPUs
		),	

		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--OTHER
		------------------------------------------------

		-------------------------------------------------------------------------------------------
		-- Indica si el código de licencia es válido para el equipo actual
		-------------------------------------------------------------------------------------------
		fn isValidLicenseCode code = 
		(
			code == (this.getLicenseCode hardwareId computerName numCPUs)
		),

		-------------------------------------------------------------------------------------------
		-- Encripta el fichero SOURCEFILE con la clave de encriptación ENCRYPTKEY
		-- en un fichero nuevo especificado en TARGETFILE. Devuelve TRUE o FALSE
		-- dependiendo de si consigue o no guardar el fichero
		-------------------------------------------------------------------------------------------
		fn saveEncryptedScript sourceFile targetFolder = 
		(
			fileSaved = true
				
			-- Encriptamos. Si no se consigue se devuelve un error
			try 
			(
				encryptscript sourceFile
				encryptedFile = (getFileNamePath sourceFile) + (getFileNameFile sourceFile) + ".mse"
				targetFile = targetFolder + "\\" + (getFileNameFile sourceFile) + (getFileNameType sourceFile)
				copyFile encryptedFile targetFile 
				deleteFile encryptedFile
			)
			catch fileSaved = false
			
			fileSaved
		),

		-------------------------------------------------------------------------------------------
		-- Encripta el fichero SOURCEFILE con la clave de encriptación ENCRYPTKEY
		-- en un fichero nuevo especificado en TARGETFILE. Devuelve TRUE o FALSE
		-- dependiendo de si consigue o no guardar el fichero
		-------------------------------------------------------------------------------------------
		fn saveEncryptedFile sourceFile targetFile = 
		(
			fileSaved = true
			targetDir = (getFileNamePath targetFile)	-- Directorio de destino
			
			-- Si no existe el directorio de destino lo creamos
			if not doesfileexist targetDir then
				makeDir targetDir
			
			-- Encriptamos. Si no se consigue se devuelve un error
			try (encryptFile sourceFile targetFile encryptKey) catch fileSaved = false
			
			fileSaved
		),

		-------------------------------------------------------------------------------------------
		-- Crea el fichero con el código de licencia. Devuelve TRUE o FALSE
		-- dependiendo de si se consiguió o no generar el fichero
		-------------------------------------------------------------------------------------------
		fn createLicenseFile = 
		(
			licenseFileCreated = false
			
			licenseCode = this.getLicenseCode hardwareId computerName numCPUs
			
			tmpFile = "$macroscripts\\lbTools\\lbLicense.txt"				-- fichero temporal de texto donde se almacenará la clave
			if (maxVersion())[1] >= 15000 then tmpFile = (getDir #maxroot) + "Macroscripts\\lbTools\\lbLicense.txt"
			encryptedFile = "$macroscripts\\lbTools\\lbLicense.dat"		-- fichero encryptado con la clave
			if (maxVersion())[1] >= 15000 then encryptedFile = (getDir #maxroot) + "Macroscripts\\lbTools\\lbLicense.dat"
			
			f = createfile tmpFile
			
			if f != undefined then
			(
				print licenseCode to:f
				close f
				this.saveEncryptedFile tmpFile encryptedFile	-- encriptamos el fichero temporal
				deleteFile tmpFile		-- Borramos el fichero de texto temporal
				licenseFileCreated = true
			)
			print licenseFileCreated
			licenseFileCreated 
		),

		-------------------------------------------------------------------------------------------
		-- Devuelve el código de licencia almacenado en el fichero de licencia.
		-- Si no existe devuelve UNDEFINED.
		-------------------------------------------------------------------------------------------
		fn readLicenseFile = 
		(
			code = undefined
			
			_file = "$macroscripts\\lbTools\\lbLicense.dat"
			if (maxVersion())[1] >= 15000 then _file = (getDir #maxRoot) + "Macroscripts\\lbTools\\lbLicense.dat"
			
			f = openEncryptedFile  _file encryptKey
			
			if f != undefined then
			(
				try code = readvalue f catch()	-- usamos un TRY por si no se pudiera leer correctamente el fichero
				close f
			)
			
			code
		),

		-------------------------------------------------------------------------------------------
		-- Indica si la licencia del equipo es correcta para empezar a usar los programas
		-- Si NOMESSAGES vale TRUE se lanzará una ventana de error si no se encuentra la licencia
		-------------------------------------------------------------------------------------------
		fn checkLicenseFile noMessages:false =
		(
			validCode = false
			
			code = this.readLicenseFile()
			
			if code != undefined and (this.isValidLicenseCode code) then
				validCode = true
			
			-- si el código no es válido no permitimos continuar
			if not validCode and not noMessages then lb.message.show "No valid license found on this computer. Contact your administrator." type:#message pos:undefined size:[300,75] modal:true

			validCode
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
	)--lib_security
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_security() --crea la libreria
)