------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Override de ScanlineGeneralBackup
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@attribute: overrideScanlineGeneralBackupInfo | Custom attribute para almacenar la informacion del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	ca_overrideScanlineGeneralBackupInfo = attributes overrideScanlineGeneralBackupInfo
	(
		parameters main
		(
			--guarda la descripcion del CA y su version.
			CA_version		type:#float		animatable:false	default:1.0
			CA_description	type:#string	default:"Almacena la informacion de un override de ScanlineGeneralBackup."
				
			--informacion específica del override
			type		type:#string	default:"override"	--@var | type | Tipo del custom attribute. Override.
			subType		type:#string	default:"scanlineGeneralBackup"	--@var | subType| Indica que tipo de override es. En funcion de este subtipo el override tiene unas propiedades u otras.
			
			------------------------------------------------------------
			-- Parámetros de backup
			------------------------------------------------
			--informacion sobre el contenido almacenado en el override
			
			stored	type:#boolean default:false --@var | stored | Indica si se ha llegado a hacer backup alguna vez de las propiedades  del motor de render
				
			----------------------------
			--propiedades del motor de render scanline
			
			_mapping	type:#boolean	default:true
			_shadows	type:#boolean	default:true
			_autoReflect	type:#boolean	default:true
			_forceWireframe	type:#boolean	default:false
			_antiAliasing	type:#boolean	default:true
			_filterMaps	type:#boolean	default:true
			_objectMotionBlur	type:#boolean	default:true
			_imageMotionBlur	type:#boolean	default:true
			_imageBlurEnv	type:#boolean	default:false
			_imageBlurTrans	type:#boolean	default:false
			_conserveMemory	type:#boolean	default:false
			_enablePixelSampler	type:#boolean	default:true
			_enableSSE	type:#boolean	default:false
			_wireThickness	type:#float	default:1.0
			_objectBlurDuration	type:#float	default:0.5
			_imageBlurDuration	type:#float	default:0.5
			_antiAliasFilterSize	type:#float	default:1.5
			_objectBlurSamples	type:#integer	default:10
			_objectBlurSubdivisions	type:#integer	default:10
			_autoReflectLevels	type:#integer	default:1
			_colorClampType	type:#integer	default:0
			_antiAliasFilter	type:#maxObject	
			_globalSamplerEnabled	type:#boolean	default:false
			_globalSamplerClassByName	type:#string	default:"Max 2.5 Star"
			_globalSamplerSampleMaps	type:#boolean	default:true
			_globalSamplerQuality	type:#float	default:0.5
			_globalSamplerAdaptive	type:#boolean	default:true
			_globalSamplerAdaptiveThresh	type:#float	default:0.1
			----------------------------
			
			----------------------------
			--propiedades de Raytracer
			
			_excludeList	type:#maxObjectTab	tabSizeVariable:true	
			_includeList type:#maxObjectTab	tabSizeVariable:true
			_showMessages	type:#boolean	default:true
			_showProgressDlg	type:#boolean	default:true
			_max_ray_depth	type:#integer	default:9
			_max_levels_color_mode	type:#integer	default:1
			_max_levels_specify_color	type:#color	default:(color 0 0 0)
			_adaptive_antialiasing_enable_flag	type:#boolean	default:false
			_adaptive_antialiasing_threshold	type:#float	default:0.1
			_antialiasing_minimum_rays_to_fire	type:#integer	default:4
			_antialiasing_maximum_rays_to_fire	type:#integer	default:32
			_blurring_amount	type:#float	default:0.0
			_blurring_aspect_ratio	type:#float	default:1.0
			_defocusing_amount	type:#float	default:0.0
			_defocusing_aspect_ratio	type:#float	default:1.0
			_vox_maxdepth	type:#integer	default:8
			_vox_previs	type:#float	default:4.0
			_vox_dim	type:#integer	default:30
			_vox_face_limit	type:#integer	default:10
			_enable_raytracing	type:#boolean	default:true
			_enable_antialiasing	type:#boolean	default:true
			_enable_self_reflect_refract	type:#boolean	default:true
			_enable_atmosphere	type:#boolean	default:true
			_enable_objects_in_raytrace_objects	type:#boolean	default:true
			_enable_atmosphere_in_raytrace_objects	type:#boolean	default:true
			_enable_refract_special_effects	type:#boolean	default:true
			_enable_material_id_rendering_support	type:#boolean	default:true
			_adaptive_ray_depth_threshold	type:#float	default:0.05			
			----------------------------
			------------------------------------------------------------
			-- Parámetros de backup y apply
			------------------------------------------------
			------------------------------------------------------------
			-- Parámetros de apply
			------------------------------------------------
			--informacion sobre el contenido almacenado en el override
			sampleParam	type:#boolean	default:false --@var | sampleParam | Parametro de ejemplo.
			------------------------------------------------
		)
	)
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMainDef | UI para modificar los parametros del override.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "ScanlineGeneralBackup Override"
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = undefined --@var : parent | Instancia del override que esta manejando el rollout en ese momento
		
		local editCA = undefined --@var : editCA| Variable de atajo que almacena el CA de edit
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
			
		checkBox chkSampleParam "Sample Param" pos:[5,5] checked:false --@control | chkSampleParam| Idica si salver el render o no.
		
		button btnOk "OK" pos:[5,25] width:95 --@control | btnOk | Valida los cambios y cierra.
		button btnCancel "Cancel" pos:[100,25] width:95 --@control | btnCancel | Cancela los cambios y cierra.
		
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
		--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
		------------------------------------------------
		fn loadOverrideInfo =
		(
			chkSampleParam.checked = editCA.sampleParam			
		)
		
		------------------------------------------------
		--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
		------------------------------------------------
		fn onCloseOperations =
		(
			--TO DO
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			--no carga settings
		)
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--no guarda settings
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------
		--@event: changed | Evento que se lanza al cambiar el valor del checkbox.
		--@control: checkbox | chkSampleParam | Checkbox cuyo estado cambia.
		--@gets: boolean| state | Nuevo estado del checkbox.
		------------------------------------------------
		on chkSampleParam changed state do
		(
			editCA.sampleParam = state
		)
			
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnOk pressed do
		(
			parent.applyEditChanges() --aplica los cambios que se hayan hecho en el override
			
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--@event: pressed | Evento que se lanza al presionar el boton. Cambia los cambios.
		--@control: button | btnOk | Boton presionado.
		------------------------------------------------
		on btnCancel pressed do
		(
			destroyDialog parent.rollMain
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMainDef | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			--no se redimensiona
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMainDef | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			parent = lb.passManager.getCurrentEditInstance()
			editCA = parent.editBackupNode.custAttributes[#overrideScanlineGeneralBackupInfo]
			loadOverrideInfo()
			loadSettings()
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMainDef | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(	
			onCloseOperations()
			saveSettings()			
		)
		
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: overrideScanlineGeneralBackup | Contiene todas las funciones de un override de ScanlineGeneralBackup.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct str_overrideScanlineGeneralBackup
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		
		type = "override",		--@var | type | Indica que es un override.
		subType = lb.overrides.getFileOverrideName (getThisScriptFilename() as string),	--@var | subType | Indica que tipo de override concreto almacena.
		relatedTypes = #(), --@var | relatedTypes | Tipos de overrides relacionados.
		
		stateMessage = "", --@var | stateMessage | Mensaje del estado actual del override.	
		
		infoNode,						--@var | infoNode | Nodo de la escena que guarda la información del override de forma permanente.
		infoNodePrefix = "override-",		--@var | infoNodePrefix | Prefijo de los nodos de la escena que representan cada override.
		infoNodeCA,						--@var | infoNodeCA | Variable que almacena el CA de apply
		
		editBackupNode,	--@var | editBackupNode | Nodo de backup temporal donde se almacena una copia del CA durante la edicion para poder hacer undo de las operaciones
		
		uiObj = undefined,	--@var | uiObj | Objeto de interfaz equivalente a este override, para poder buscar la equivalencia de forma rápida entre un override y el objeto de interface que lo controla.
		
		overrideManager = undefined, --@var | overrideManager | override generico del que cuelga este override específico.
		
		overrideInfo = ca_overrideScanlineGeneralBackupInfo,		--@var | overrideInfo | Custom attribute para almacenar los datos de cada override en el objeto.
		overrideBackup = ca_overrideScanlineGeneralBackupInfo,	--@var | overrideBackup | Custom attribute para almacenar los datos de cada backup de override en el objeto de backup.
		
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef, --@var: rollMain | Almacena el rollout de edicion del override.
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------
		--GETS
		------------------------------------------------
			
		------------------------------------------------
		--@fn: string | getType | Devuelve el tipo del override.
		------------------------------------------------
		fn getType =
		(
			this.infoNodeCA.type
		),
			
		------------------------------------------------
		--@fn: string | getSubType | Devuelve el subtipo del override.
		------------------------------------------------
		fn getSubType =
		(
			this.infoNodeCA.subType
		),
		
		------------------------------------------------
		--@fn: node | getInfoNode | Devuelve el nodo físico de la escena que contiene la información del override.
		------------------------------------------------
		fn getInfoNode =
		(
			this.infoNode
		),
		
		------------------------------------------------
		--@fn: dotneObject | getUiObj | Devuelve el objeto de interface .net que controla este objeto.
		------------------------------------------------
		fn getUiObj =
		(
			this.uiObj
		),
		
		------------------------------------------------
		--@fn: override | getOverrideManager | Devuelve el override principal del que cuelga el especifico.
		------------------------------------------------
		fn getOverrideManager =
		(
			this.overrideManager
		),
		
		------------------------------------------------
		--@fn: container | getParentContainer | Devuelve el contenedor del que cuelga este override.
		------------------------------------------------
		fn getParentContainer =
		(
			if this.overrideManager != undefined then this.overrideManager.getParentContainer() else undefined
		),
		
		------------------------------------------------
		--@fn: string | getInfo | Devuelve la informacion que se debe mostrar en el UI.
		------------------------------------------------
		fn getInfo =
		(
			this.infoNodeCA.sampleParam as string
		),
		
		------------------------------------------------
		--@fn: name | getState | Devuelve el estado del override. Puede ser #ok, #error o #warning.
		------------------------------------------------
		fn getState =
		(
			_state = #ok
			
			_state
		),
		
		------------------------------------------------
		--@fn: name | getStateMessage | Devuelve el mensaje del estado actual del override.
		------------------------------------------------
		fn getStateMessage =
		(
			this.stateMessage
		),
		
		------------------------------------------------
		--SETS
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | setUiObj | Sustituye el objeto de interface relacionado con el override.
		--@gets: dotNetObject | newUiObj | Nuevo elemento de interface relacionado con el override.
		------------------------------------------------
		fn setUiObj newUiObj =
		(
			this.uiObj = newUiObj
		),
		
		------------------------------------------------
		--@fn: undefined | setOverrideManager | Sustituye el override principal del que cuelga el especifico.
		--@gets: override | newOverrideManager | Nuevo override principal.
		------------------------------------------------
		fn setOverrideManager newOverrideManager =
		(
			this.overrideManager = newOverrideManager
		),
		
		------------------------------------------------
		--OTHER
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | updateUIinfo | Actualiza la informacion del override en su objeto de UI si tuviera.		
		------------------------------------------------
		fn updateUIinfo =
		(
			--si hay nodo que actualizar
			if this.getUiObj() != undefined then
			(
				--actualiza los valores de las columnas
				(this.getUiObj()).setValue 1 (this.getInfo())
				(this.getUiObj()).setValue 5 (this.getState() as string)
					
				--actualiza el icono de estado
				lb.passManagerUI.rollMain.updateTrvContainerAppearance mode:#state node:(this.getUiObj())
					
				--actualiza los overrides relacionados
				for _relType in this.relatedTypes do
				(
					_relOverrides = (this.getOverrideManager()).getRelativeDescendantsOverride _relType
					for _relOv in _relOverrides do _relOv.updateUIinfo()
				)--for
			)
		),
		
		------------------------------------------------
		--@fn: boolean | createBackup | Crea el backup de este override antes de aplicarse
		--@gets: node | backupNode | Objeto en el que hacer el backup.
		------------------------------------------------
		fn createBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			
			if saveLogs then lb.log.add ("BACKUP process start.") sender: ("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha suministrado un nodo de backup
			if isValidNode backupNode then
			(
				--si el nodo de backup no tiene el CA de backup se lo pone
				if backupNode.custAttributes[#overrideScanlineGeneralBackupInfo] == undefined then
					custAttributes.add backupNode (this.overrideBackup) #unique baseobject:false --le añade el atributo
				
				--solo si el motor de render activo es mental ray
				if classof renderers.current == Default_Scanline_Renderer then
				(
					--hace global de forma temporal el CA del nodo de backup para poder accader a el
					global _tempBackupCA = backupNode.custAttributes[#overrideScanlineGeneralBackupInfo]
					global _raytracer = RaytraceGlobalSettings() --alamacena el raytracer
					
					_rendererProps = getPropNames renderers.current --obtiene las propiedades del render
					_raytracerProps = getPropNames _raytracer
					_executeString = "" --string para ejecutar					
					
					--prepara un string para obtener todas las propiedades
					for _rp in _rendererProps do
						_executeString += ("_tempBackupCA._" + (_rp as string) + " = getProperty renderers.current #" + (_rp as string)) + "\n"
					
					--prepara un string para obtener todas las propiedades
					for _rp in _raytracerProps do --prepara un string para obtener todas las propiedades
					(
						_store = true
						
						--si la propiedad es #excludeList o #includeList, y esta a undefined, no la almacena
						case _rp of
						(
							#excludeList: if _raytracer.excludeList == undefined then _store = false
							#includeList: if _raytracer.includeList == undefined then _store = false
						)--case
						
						if _store then _executeString += ("_tempBackupCA._" + (_rp as string) + " = getProperty _raytracer #" + (_rp as string)) + "\n"
					)--for
					
					execute _executeString
					backupNode.custAttributes[#overrideScanlineGeneralBackupInfo].stored = true
					_success = true
					if saveLogs then lb.log.add ("BACKUP process complete.") sender: ("override." + (this.getSubType())) type:#ok level:logLevel
					_tempBackupCA = undefined
					_raytracer = undefined
				)--if
				else
				(
					if saveLogs then lb.log.add ("BACKUP: Render engine is not Scanline") sender: ("override." + (this.getSubType())) type:#warning level:(logLevel+1)
					_success = true --si el motor de render es otro, debe continuar
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("BACKUP process error. Backup Node not valid.") sender: ("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"BACKUP process error. Backup Node not valid.")
			)
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | restoreBackup | Restaura los valores anteriores de este override a partir de su backup
		--@gets: node | backupNode | Objeto del que restaurar el backup.
		------------------------------------------------
		fn restoreBackup backupNode saveLogs:false logLevel:1 =
		(
			_success = false
			if saveLogs then lb.log.add ("RESTORE process start.") sender: ("override." + (this.getSubType())) type:#info level:logLevel
			--solo si se ha pasado un nodo de backup y este tiene backup de este tipo de override
			if isValidNode backupNode then
			(
				if backupNode.custAttributes[#overrideScanlineGeneralBackupInfo] != undefined then
				(
					--solo si el motor de render activo es mental ray
					if classof renderers.current == Default_Scanline_Renderer then
					(
						if backupNode.custAttributes[#overrideScanlineGeneralBackupInfo].stored then
						(
							--hace global de forma temporal el CA del nodo de backup para poder accader a el
							global _tempBackupCA = backupNode.custAttributes[#overrideScanlineGeneralBackupInfo]
							global _raytracer = RaytraceGlobalSettings() --alamacena el raytracer
							
							_rendererProps = getPropNames renderers.current --obtiene las propiedades del render
							_raytracerProps = getPropNames _raytracer
							_executeString = "" --string para ejecutar
							
							for _rp in _rendererProps do --prepara un string para obtener todas las propiedades del render
								_executeString += ("setProperty renderers.current #" + (_rp as string) + " _tempBackupCA._" + (_rp as string)) + "\n"
							
							for _rp in _raytracerProps do --prepara un string para obtener todas las propiedades del raytracer
							(
								_restore = true
								
								--los siguientes casos son para propiedades que son readOnly, por lo tanto no se pueden modificar, solo consultar
								--tambien --caso especial para #excludeList y para #includeList
								case _rp of
								(
									#excludeList:
									(
										if (_excludeList as string) == "#()" then _restore = false
										if _excludeList == undefined then _restore = false
									)
									
									#includeList:
									(
										if (_includeList as string) == "#()" then _restore = false
										if _includeList == undefined then _restore = false
									)
								)--case
								
								if _restore do _executeString += ("setProperty _raytracer #" + (_rp as string) + " _tempBackupCA._" + (_rp as string)) + "\n"
							)--for
							
							execute _executeString
							_success = true
							if saveLogs then lb.log.add ("RESTORE process complete.") sender: ("override." + (this.getSubType())) type:#ok level:logLevel
							_tempBackupCA = undefined
							_raytracer = undefined
						)
					)
					else
					(
						if saveLogs then lb.log.add ("RESTORE: Render engine is not Scanline") sender: ("override." + (this.getSubType())) type:#warning level:(logLevel+1)
						_success = true --si el motor de render es otro, debe continuar
					)
				)
				else
				(
					if saveLogs then lb.log.add ("RESTORE process error. CA #overrideScanlineGeneralBackupInfo is undefined.") sender: ("override." + (this.getSubType())) type:#error level:logLevel
					lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Custom Attribute is not defined.")
				)
			)--if
			else
			(
				if saveLogs then lb.log.add ("RESTORE process error. Backup node not valid.") sender: ("override." + (this.getSubType())) type:#error level:logLevel
				lb.passManager.addErrorMessage ((this.overrideManager.getOverrideTrace this) + "\x0D"+"RESTORE process error. Backup Node not valid.")
			)
			
			_success
		),
		
		------------------------------------------------
		--@fn: boolean | apply | Aplica el override a los objetos o parametros correspondientes.
		------------------------------------------------
		fn apply saveLogs:false logLevel:1 =
		(
			if saveLogs then lb.log.add ("APPLY process start.") sender: ("override." + (this.getSubType())) type:#info level:logLevel
			_sampleParam = this.infoNodeCA.sampleParam
			if saveLogs then lb.log.add ("APPLY process complete.") sender: ("override." + (this.getSubType())) type:#ok level:logLevel
			true
		),
		
		------------------------------------------------
		--@fn: undefined | applyEditChanges | Aplica los cambios que se han hecho en el override durante la edicion.
		------------------------------------------------
		fn applyEditChanges =
		(
			--solo si existe el nodo de backup de override puede hacerlo
			if this.editBackupNode != undefined then
			(
				--le quita el CA del override si lo tuviera
				if this.editBackupNode.custAttributes[#overrideScanlineGeneralBackupInfo] != undefined then
				(
					undo "Override Changes Applied" on
					(
						--copia  todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.infoNodeCA) _prop (getProperty (this.editBackupNode.custAttributes[#overrideScanlineGeneralBackupInfo]) _prop))
					)--undo
					
					this.editBackupNode = undefined --hace que el override no tenga backup de edicion almacenado
					
					this.updateUIinfo() --actualiza la infirmacion en el UI si ha cambiado
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello.		
		------------------------------------------------
		fn createEditBackup =
		(
			--solo si el override cuelga de un contenedor
			if (this.getParentContainer()) != undefined then
			(
				--obtiene el inicio de la jerarquia del arbol de contenedores
				_passTree = (this.getParentContainer()).getRootContainer()
				
				if _passTree != undefined then --si ha conseguido llegar a la raiz
				(
					--obtiene el nodo de backup de edicion de override
					this.editBackupNode = _passTree.getOverridesEditBackupNode()
					
					--solo si existe el nodo de backup de override puede hacerlo
					if this.editBackupNode != undefined then
					(
						--le quita el CA del override si lo tuviera
						if this.editBackupNode.custAttributes[#overrideScanlineGeneralBackupInfo] != undefined then
							custAttributes.delete this.editBackupNode (custAttributes.getDef this.editBackupNode.custAttributes[#overrideScanlineGeneralBackupInfo]) baseobject:false --elimina el viejo
						
						--le aplica el CA del override
						custAttributes.add this.editBackupNode (this.overrideInfo) #unique baseobject:false --le añade el atributo nuevo
						
						--copia todas las propiedades del CA
						_propNames = getPropNames (this.infoNodeCA)
						for _prop in _propNames do (setProperty (this.editBackupNode.custAttributes[#overrideScanlineGeneralBackupInfo]) _prop (getProperty (this.infoNodeCA) _prop))
					)--if
				)--if
			)--if
		),
		
		------------------------------------------------
		--@fn: undefined | edit | Muestra el dialogo de edicion del override.
		--@opt: Point2 | pos | [0,0] | Posicion en la que aparecera el rollout de edicion del override.
		------------------------------------------------
		fn edit pos:[0,0] =
		(
			this.createEditBackup() --crea el backup de edicion del override para que lo cambios se apliquen solo al aceptar y se pueda hacer undo de ello 			
			
			lb.passManager.setCurrentEditInstance this
			
			_size = [200,50]
			_pos = pos - (_size/2)
			
			createDialog this.rollMain lockwidth:true lockheight:true pos:_pos width:_size.x height:_size.y modal:true style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: boolean | purge | Limpia el override por si se ha cambiado informacion y hay que mantenerla coherente.
		------------------------------------------------
		fn purge =
		(
			_success = false
			
			--TO DO: Aqui hacer el codigo de purga
			
			_success = true
			
			_success
		),
		
		
		------------------------------------------------
		--@fn: undefined | reset | resetea los valores a los que tiene por defecto.
		------------------------------------------------
		fn reset =
		(
			--TO DO: Aqui restaurar los valores a los que tiene por defecto
		),

		------------------------------------------------
		--@fn: undefined | storeSceneValues | Almacena los valores de la escena en el override.
		------------------------------------------------
		fn storeSceneValues =
		(
			this.infoNodeCA.sampleParam = true					
		),
		
		------------------------------------------------
		--@fn: undefined | construct | Rellena la información del override y crea el objeto fisico en la escena que contendrá la información.
		------------------------------------------------
		fn construct =
		(
			--si existe el nodo de la escena con la información la coge de el.
			if isValidNode this.infoNode then
			(	
				--Si se esta construyendo el objeto no tendra el CA aplicado, con lo cual hay que ponerselo. Si ya lo tiene no.
				if not (lb.customAttributes.hasAttribute this.infoNode #overrideScanlineGeneralBackupInfo) then
				(
					custAttributes.add this.infoNode (this.overrideInfo) #unique baseobject:false --le añade el atributo
					this.infoNodeCA = this.infoNode.custAttributes[#overrideScanlineGeneralBackupInfo]
					
					this.storeSceneValues()					
				)--if			
				
				--Rellenamos la variable
				this.infoNodeCA = this.infoNode.custAttributes[#overrideScanlineGeneralBackupInfo]
				
				--primero mira si hay cambios en la escena que afecten al override y lo limpia
				this.purge()
			)--if				
		),
		
		------------------------------------------------
		--@fn: string | toString | Devuelve un string con la representacion del contenido del override.
		------------------------------------------------
		fn toString =
		(	
			--primero mira si hay cambios en la escena que afecten al override y lo limpia
			this.purge()
			
			_theString = ""
				
			--TO DO: Aqui falta todo el codigo del toString
			
			_theString
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
		--@event | create | Ejecución al crearse la instancia del struct.
		on create do
		(
			this.construct() --genera toda la información necesaria y el nodo de la escena donde almacenarla en paralelo, o lee el ya existente en la escena.
		)
		
	)--str_overrideScanlineGeneralBackup
	
	lb.overrides.add (lb.overrides.getFileOverrideName (getThisScriptFilename() as string)) str_overrideScanlineGeneralBackup --añade el override al listado de overrides disponibles
	
	ok
)