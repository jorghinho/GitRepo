(
	---------------------------------------------------------------------------
	-------------------- VARIABLES GLOBALES --------------------------
	---------------------------------------------------------------------------
	
	--Variables---------------------------------------------------------------
	
	--Rollouts----------------------------------------------------------------

	--Funciones--------------------------------------------------------------
	
-- 	global hasFixEyes		-- devuevle si tiene el atributo
-- 	global removeFixEyes	-- elimina si lo tiene el atributo
-- 	global addFixEyes		-- añade el atributo
		
	--LB arrays--------------------------------------------------------------
	
-- 	global LB_VARs_ARS_facialFunctions	= #()
-- 	global LB_FNs_ARS_facialFunctions	= #(#hasFixEyes, #removeFixEyes, #addFixEyes)
											
	---------------------------------------------------------------------------
	-------------------- INCLUDES ----------------------------------------
	---------------------------------------------------------------------------
	
	---------------------------------------------------------------------------
	-------------------- FUNCIONES --------------------------------------
	---------------------------------------------------------------------------

	---------------------------------------------------------------------------
	--devuelve true si el obejto tiene el atributo CA_ARS_fixEyes
	---------------------------------------------------------------------------
	fn hasFixEyes obj =
	(
		lb.customAttributes.hasAttribute obj lb.customAttributes.fixEyesARSCA.name
	)
	
	---------------------------------------------------------------------------
	--elimina el atributo CA_ARS_fixEyes
	---------------------------------------------------------------------------	
	fn removeFixEyes obj =
	(
		if lb.customAttributes.hasAttribute obj.modifiers[#fixEyes] lb.customAttributes.fixEyesARSCA.name then
		(
			custAttributes.delete obj.modifiers[#fixEyes] (custAttributes.getDef obj.modifiers[#fixEyes].fixEyes)
			deleteModifier obj obj.modifiers[#fixEyes]
		)
	)
	
	---------------------------------------------------------------------------
	--añade el atributo CA_ARS_fixEyes
	---------------------------------------------------------------------------
	fn addFixEyes obj = 
	(
		if isValidNode obj then
		(
			removeFixEyes obj
			
			addModifier obj (EmptyModifier ()) ui:on -- añade modificador attributeHolder vacio al objeto indicado en obj.
			obj.modifiers[#Attribute_Holder].name = "fixEyes" -- Renombra Attibute Holder
			modPanel.setCurrentObject obj.modifiers[#fixEyes] -- Marcamos el modicifador attributeHolder añadido como activo porque no se refresca el nombre en la lista.
			
			bckpSelection = getCurrentSelection()
			clearSelection() -- es necesario deseleccionar cualquier objeto en este momento para que puedan aplicarse los custom Attributes sin que salte un error.
			select bckpSelection
				
			custAttributes.add obj.modifiers[#fixEyes] lb.customAttributes.fixEyesARSCA #unique
		)
	)
	
	---------------------------------------------------------------------------
	-------------------- ROLLOUTS ----------------------------------------
	---------------------------------------------------------------------------

	---------------------------------------------------------------------------
	-------------------- MACROSCRIPTS -----------------------------------
	---------------------------------------------------------------------------

	---------------------------------------------------------------------------
	-------------------- EJECUCION ---------------------------------------
	---------------------------------------------------------------------------

)