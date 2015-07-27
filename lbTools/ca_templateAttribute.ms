------------------------------------------------------------------------------------------------------------------------------------------------
--@Desc: custom attribute Plantilla
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------
	--@attributes: CA_templateAttribute | Variable que contiene el customAttribute
	------------------------------------------------
	CA_templateAttribute = attributes templateAttirubte
	(
		------------------------------------------------------------------------------------------------
		--PARAMETERS
		------------------------------------------------------------------------------------------------
		
		parameters main
		(
			------------------------------------------------------------------------------------------------
			--COMMON
			------------------------------------------------------------------------------------------------

			CA_version 			type:#float  		animatable:false default: 1.0									--@var: float | CA_version | Control de versiones.
			CA_description 		type:#string 		animatable:false default: "Información del customAttribute"  	--@var: string | CA_description | Descripción del CustomAttribute

			------------------------------------------------------------------------------------------------
			--VARIABLES
			------------------------------------------------------------------------------------------------
			
			templateParam 	type:#float 			animatable:false default: 1.0									--@var: float | templateParam | Parametro de ejemplo								
		)
	)
)