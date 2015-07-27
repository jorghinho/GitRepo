(
	------------------------------------------------
	--@attributes: attributes | CA_templateAttribute | 
	------------------------------------------------
	CA_visibility = attributes visibility
	(
		------------------------------------------------------------------------------------------------
		--PARAMETERS
		------------------------------------------------------------------------------------------------
		
		parameters main rollOut:rollVisibility
		(
			------------------------------------------------------------------------------------------------
			--COMMON
			------------------------------------------------------------------------------------------------

			CA_version 			type:#float  		animatable:false default: 1.0				-- Control de versiones.
			CA_description 		type:#string 		animatable:false default: "Información del customAttribute"  -- Descripción.

			------------------------------------------------------------------------------------------------
			--VARIABLES
			------------------------------------------------------------------------------------------------
			
			visibility type:#float ui:(spnVis, sldVis)
			
		)
		
		------------------------------------------------------------------------------
		----------------------------Rollout --------------------------------------
		------------------------------------------------------------------------------
		rollout rollVisibility "Visibility Controls"
		(
			spinner spnVis "Visibility" range:[0,1,1]
			slider sldVis "" range:[0,1,1]

			
		)
	)
	
	for o in selection do 
	(
		addModifier o (EmptyModifier())
		
		o.attributeHolder.name = "Visibility_Controls"
		custAttributes.add o.Visibility_Controls CA_visibility		
			
	)
)