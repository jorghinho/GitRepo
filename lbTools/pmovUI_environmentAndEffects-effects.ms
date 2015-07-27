------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc:  UI para el override de environment and effects. Environment. Common Properties.
------------------------------------------------------------------------------------------------------------------------------------------------
	
------------------------------------------------------------------------------------------------------------------------------------------------
--@rollout: rollEffectsDef | Rollout de Common Properties de Environment.
------------------------------------------------------------------------------------------------------------------------------------------------
rollout rollEffectsDef "Effects"
(
	------------------------------------------------------------------------------------------------
	--COMMON
	------------------------------------------------------------------------------------------------
	
	local parent = undefined --@var: string |  parent | Instancia del override que esta manejando el rollout en ese momento.
	
	local editCA = undefined --@var: CustomAttribute | editCA | Variable de atajo para el CA de edit.

	------------------------------------------------------------------------------------------------
	--VARIABLES
	------------------------------------------------------------------------------------------------

	------------------------------------------------------------------------------------------------
	--CONTROLS
	------------------------------------------------------------------------------------------------
	
	--override active
	checkbox chkOverrideEffects "override" pos:[5,5] checked:false 
	
	label lblInfo "Move Effects to right list to use them:" pos:[5,25] height:20
	label lblNotSelected "From scene:" pos:[7,45]
	label lblSelected "In use:" pos:[193,45]
	MultiListBox mlbNotSelected "" pos:[5,60] items:#() height:18 width:138 caption:"Select and click >> to apply to pass"
	MultiListBox mlbSelected "" pos:[193,60] items:#() height:18 width:138 caption:"Select and click >> to remove from pass"
	button btnAddEffect ">>" pos:[143,130] height:20 width:50
	button btnRemoveEffect "<<" pos:[143,150] height:20 width:50 
	

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
	--@fn: undefined | createSceneEvents | Crea los callbacks de este rollout.
	------------------------------------------------
	fn createSceneEvents =
	(
		--sin operaciones
	)
	
	------------------------------------------------
	--@fn: undefined | removeSceneEvents | Elimina los callbacks de este rollout.
	------------------------------------------------
	fn removeSceneEvents =
	(
		--sin operaciones
	)
	
	------------------------------------------------
	--@fn: undefined | updateUIControlsByOverrideEnabledState | habilita o deshabilita los controles del override en funcion de si est� activo o no.
	--@gets: (opt)boolean | disableOnly | Booleano, si esta a true permite deshabilitar o habilitar el override, en false solo se puede deshabilitar. Por defecto en false
	------------------------------------------------
	fn updateUIControlsByOverrideEnabledState disableOnly:false =
	(
		if not disableOnly then --si esta en el modo en que se permite habilitar y deshabilitar
		(
			for _cntrl in rollEffectsDef.controls where _cntrl.name != "chkOverrideEffects" do _cntrl.enabled = editCA.overrideEffects
			chkOverrideEffects.checked = editCA.overrideEffects
		)
		else if not editCA.overrideEffects then --so solo se permite desahbilitar. Solo entra si est� desactivado el override
		(
			for _cntrl in rollEffectsDef.controls where _cntrl.name != "chkOverrideEffects" do _cntrl.enabled = false
			chkOverrideEffects.checked = false
		)
	)

	------------------------------------------------
	--@fn: undefined | loadOverrideInfo | Carga los parametros del override en el UI de edicion del mismo.
	------------------------------------------------
	fn loadOverrideInfo =
	(
		mlbSelected.items = deepCopy(editCA.selectedEffects As Array)
		
		--Ahora los de la escena que no est�n en el de seleccionados, al array de no seleccionados.
		_notSelected = #()
		for i=1 to numEffects do
		(
			if (finditem editCA.selectedEffects (getEffect i).name) == 0 then
				append _notSelected (getEffect i).name
		)
		sort _notSelected
		mlbNotSelected.items = _notSelected
	)
	
	------------------------------------------------
	--@fn: undefined | updateUI | Establece el estado de los cotroles del UI.
	------------------------------------------------
	fn updateUI =
	(		
		chkOverrideEffects.checked = editCA.overrideEffects
		updateUIControlsByOverrideEnabledState()
		loadOverrideInfo()
		updateUIControlsByOverrideEnabledState disableOnly:true
	)

	------------------------------------------------
	--@fn: undefined | updateRelatedRollouts | Actualiza el estado de los controles de rollouts relacionados.
	------------------------------------------------
	fn updateRelatedRollouts =
	(
		--sin operaciones
	)

	------------------------------------------------
	--@fn: undefined | onCloseOperations | Operaciones necesarias cuando se cierra el rollout.
	------------------------------------------------
	fn onCloseOperations =
	(
		--sin operaciones
	)

	------------------------------------------------
	--@fn: undefined | resize | Redimensiona el rollout.
	------------------------------------------------
	fn resize =
	(
		--sin operaciones
	)

	------------------------------------------------
	--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuraci�n de la misma.
	------------------------------------------------
	fn loadSettings =
	(
		--sin operaciones
	)
	
	------------------------------------------------
	--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuraci�n de la misma.
	------------------------------------------------
	fn saveSettings =
	(
		--no guarda settings
	)
	
	------------------------------------------------------------------------------------------------
	--EVENTS
	------------------------------------------------------------------------------------------------
	------------------------------------------------
	--@event: pressed | Evento que se lanza al presionar el boton. Manda un elemento de la lista de no seleccionados a la de seleccionados.
	--@control: button | btnAddEffect | Boton presionado.
	------------------------------------------------
	on btnAddEffect pressed do
	(
		_notSelected = deepCopy mlbNotSelected.items
		_selected = deepCopy mlbSelected.items
		
		for i=mlbNotSelected.selection.count to 1 by -1 do
		(
			--Seleccionado se pasa a la otra lista
			if mlbNotSelected.selection[i] then
			(
				append _selected _notSelected[i]
				deleteItem _notSelected i
			)
		)
		
		sort _selected
		sort _notSelected
		mlbSelected.items = _selected
		mlbNotSelected.items = _notSelected
		
		editCA.selectedEffects = deepCopy(mlbSelected.items as Array)
	)
	
	------------------------------------------------
	--@event: pressed | Evento que se lanza al presionar el boton. Salva los cambios.
	--@control: button | btnRemoveEffect | Boton presionado.
	------------------------------------------------
	on btnRemoveEffect pressed do
	(
		_notSelected = deepCopy mlbNotSelected.items
		_selected = deepCopy mlbSelected.items
		
		for i=mlbSelected.selection.count to 1 by -1 do
		(
			--Seleccionado se pasa a la otra lista
			if mlbSelected.selection[i] then
			(
				append _notSelected _selected[i]
				deleteItem _selected i
			)
		)
		
		sort _selected
		sort _notSelected
		mlbSelected.items = _selected
		mlbNotSelected.items = _notSelected
		editCA.selectedEffects = deepCopy(mlbSelected.items as Array)
	)
	
	------------------------------------------------
	--@event: changed | Evento que se lanza al cambiar el estado.
	--@control: checkbox | chkOverrideMentalCameraEffects | Checkbox que cambia de estado.
	--@gets: boolean | state | Nuevo estado.
	------------------------------------------------
	on chkOverrideEffects changed state do
	(
		editCA.overrideEffects = state
		updateUI()
		parent.updateRendererTabsColor()
	)
	
	------------------------------------------------
	--COMMON
	------------------------------------------------
	

	------------------------------------------------
	--@event: open | Evento lanzado al abrirse el rollout.
	--@control: rollout | rollMentalCameraEffectsDef | rollout actual.
	------------------------------------------------
	on rollEffectsDef open do
	(
		parent = lb.passManager.getCurrentEditInstance()
		editCA = parent.editBackupNode.custAttributes[#overrideEnvironmentAndEffectsInfo]
		
		updateUI()
		
		loadSettings()
		createSceneEvents()
		
		resize() --redimensiona los componentes del UI una vez abierto
	)
	
	------------------------------------------------
	--@event: close | Evento lanzado al cerrarse el rollout.
	--@control: rollout | rollMentalCameraEffectsDef | rollout actual.
	------------------------------------------------
	on rollEffectsDef close do
	(
		removeSceneEvents()
		onCloseOperations()
		saveSettings()		
	)
)--rollEffectsDef