------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Script para exportar el draft de hair a partir del shadows.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: hairDraftExport | Contiene el struct del script plantilla.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct sc_hairDraftExport
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileScriptName (getThisScriptFilename() as string),	--@var: className | Nombre del script.
		description = "Script plantilla",	--@var: description | Script para exportar el draft de hair a partir del shadows.
		
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
		
		------------------------------------------------
		--exporta la geometria de shadows como draft
		------------------------------------------------
		fn hairShadowsExporter =
		(
			if _originalPathNameFile != "" then 
			(
				--obtiene el objeto de shadows que exportar como draft
				_shadowNode = lb.misc.getNodeByPattern (lb.nc.NC_chrPrefix + "_" + "*(headHair-*)_" + lb.nc.NC_meshFileName + "_*_" + lb.nc.NC_HAIR_shadow + "-*-*-*_*_*" )

				--si existe el nodo de shadows
				if _shadowNode != undefined then
				(
					setWaitCursor()

					----------------------------------------------
					--hace un backup del nombre del objeto y prepara el nombre que tendra al exportar

					_nameBackup = _shadowNode.name
					_newName = substituteString _shadowNode.name ("_" + lb.nc.NC_HAIR_shadow + "-") ("_" + lb.nc.NC_draftFileName + "-")
					
					----------------------------------------------

					----------------------------------------------
					--ahora debe crear un material paralelo al del pelo pero con standard mats
					
					_mat = _shadowNode.material
					_newMat = copy _shadowNode.material
					
					for j=1 to _mat.materialList.count do
					(
						for k=1 to _mat.materialList[j].materialList.count where classof _mat.materialList[j].materialList[k] == Hair_Realistic do
						(
							_standMat = Standardmaterial()
							_standMat.diffuse = _mat.materialList[j].materialList[k].transmittanceColor

							if _mat.materialList[j].materialList[k].diffuseMap != undefined then
							(
								if classof _mat.materialList[j].materialList[k].diffuseMap == Hair_Color_Variation then
								(
									_standMat.diffuse = _mat.materialList[j].materialList[k].diffuseMap.color
									if classof _mat.materialList[j].materialList[k].diffuseMap.map == Gradient_Ramp then
									(
										_standMat.diffuse = _mat.materialList[j].materialList[k].diffuseMap.map.Gradient_Ramp.Flag__2.color
									)--if
								)--if
							)--if

							_newMat.materialList[j].materialList[k] = _standMat
						)--for	
					)--for

					meditMaterials[1] = _newMat
					
					----------------------------------------------

					----------------------------------------------
					--ahora aplica el nombre y el material al objeto y lo salva como draft en una escena de hair draft

					_newFileNameParts = filterString maxfilename "_"
					_newFileName = maxfilename
					_newFileName = substituteString _newFileName ("_" + _newFileNameParts[3] + "_") ("_" + lb.nc.NC_draftFileName + "_")
					_newFileName = maxfilepath + _newFileName

					if doesFileExist _newFileName then
					(
						setFileAttribute _newFileName #readOnly false
						deleteFile _newFileName
					)--if

					_shadowNode.name = _newName
					_shadowNode.material = _newMat
					_newFileSaved = saveNodes _shadowNode _newFileName quiet:true
					
					----------------------------------------------

					----------------------------------------------
					--despues vuelve a ponerle el nombre que tenía al objeto y su material original

					_shadowNode.name = _nameBackup
					_shadowNode.material = _mat

					----------------------------------------------

					setArrowCursor()

					if (_newFileSaved == OK) then lb.message.show "Hair exported correctly." type:#message 
				)
				else
				(
					lb.message.show "Object shadow doesn't fullfill namingConvention: lb.nc.NC_chrPrefix_*(head*Hair-*)_lb.nc.NC_meshFileName_*_lb.nc.NC_HAIR_shadow-*-*-*_*_*"
				)			
			)
			else
			(
				lb.message.show "This file has been never saved. Save it first"
			)		
		),

		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | run | Ejecuta el script.
		------------------------------------------------
		fn run =
		(
			this.hairShadowsExporter()
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
			lb.addScript this --añade el script a la libreria principal
		)
		
	)--sc_hairDraftExport
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	sc_hairDraftExport() --crea el script
)