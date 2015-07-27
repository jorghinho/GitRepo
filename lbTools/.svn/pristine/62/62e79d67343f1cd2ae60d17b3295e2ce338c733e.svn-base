------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: Herramienta Plantilla.
------------------------------------------------------------------------------------------------------------------------------------------------
(
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@rollout: rollMain | Contiene la herramienta spineCuadrupedo.
	------------------------------------------------------------------------------------------------------------------------------------------------
	rollout rollMainDef "spine Cuadrupedo" width:150 height:80
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		local parent = lb.getTool (lb.getFileToolName (getThisScriptFilename() as string)) --@var : parent | Herramienta o rolllout del que depende y/o contiene el rollout actual
		
		local minRollWidth = 150		--@var: minRollWidth | Ancho mínimo de la herramienta.
		local minRollHeight = 80		--@var: minRollHeight | Alto mínimo de la herramienta.
		
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
		Local _SpineBoneFKFront = #()		--contiene los huesos FK de la parte front.
		Local _SpineBoneFKBack = #()		--contiene los huesos FK de la parte Back.
		Local _SpineBoneIKFront = #()		--contiene los huesos IK de la parte Front.
		Local _SpineBoneIKBack =#()			--contiene los huesos IK de la parte Back.
		Local _newBoneRoot = #()			--contiene el root.
		Local _SpineBoneFKFrontEnd = #()	--contiene los huesos de la cadena FK finales de la parte Front.
		Local _SpineBoneFKBackEnd = #()		--contiene los huesos de la cadena FK finales de la parte Back.
		Local _SpineHlpFront = #()			--contiene los point verdes de la parte front.
		Local _SpineHlpBack = #()			--contiene los point verdes de la parte Back.
		Local _spineShpControl = #()		--contiene los shapes de control.
		Local _IKChainFront = #()			--contiene las IKChain de la parte Front.
		Local _IKChainBack = #()			--contiene las IKChain de la parte Back.
		Local _IKChainAll = #()				--contiene las IKChain de toda la cadena IK.
		Local _SpineHlpIKChain = #()		--contiene los point amarillos de la cadena IK.
		Local _SpineHlpPelvis = #()			--contiene los point de la pelvis.
			
		------------------------------------------------------------------------------------------------
		--CONTROLS
		------------------------------------------------------------------------------------------------
		--@control | controlName | Plantilla de comentario para controles
		groupBox grp1SpineCuadrupedo "Spine Cuadrupedo" pos:[8,8] width:135 height:60
		button btnCreateSpineCuadrupedo "Create Spine Cuad" pos:[20,30] width:110 height:24
		
		------------------------------------------------------------------------------------------------
		--FUNCTIONS
		------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------
		--@fn: undefined | CreateSpineBon | Función para crear los huesos FK necesarios para formar la spine dividida en 2 partes front y back.
		------------------------------------------------------------------------------
		fn CreateSpineBonFK =
		(
			_numberSpine = 2 --cantidad de huesos que forman la spine.
			
			_newBoneRoot = BoneSys.createBone [0,0,0] [5,0,0] [0,0,1] --creación del hueso del root.
			rotate _newBoneRoot (angleaxis 90 [0,1,0]) --rotamos el root para dejarlo bien colocado.
			
			_newBoneRoot.wirecolor = color 255 112 0 -- orange
			--NC.
			_newBoneRoot.name = "chr" + "_" + "spineCuadrupedo" + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + "root" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
			
			--creación de los huesos FK de la Spine Front y back y configuración.
			for _o=1 to (_numberSpine + 1) do 
			(
				_newBoneFront = BoneSys.createBone [0,0,0] [20,0,0] [0,0,1] --Creación huesos spine front.
				_newBoneBack = BoneSys.createBone [0,0,0] [-20,0,0] [0,0,1] --Creación huesos spine back.
				
				_newBoneFront.height =  10
				_newBoneBack.height =  10
				_newBoneFront.width =  10
				_newBoneBack.width =  10
				_newBoneFront.wirecolor = color 255 112 0 -- orange
				_newBoneBack.wirecolor = color 255 112 0 -- orange
				_newBoneFront.boxmode = on --visualización modo Box.
				_newBoneBack.boxmode = on --visualización modo Box.
				--NC
				_newBoneFront.name = "chr" + "_" + "spineCuadrupedo" + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + "spineFkFront-0" + (_o as String) + "-bon-x" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				_newBoneBack.name = "chr" + "_" + "spineCuadrupedo" + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + "spineFkBack-0" + (_o as String) + "-bon-x" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				
				--creación de los huesos extra de la spine FK y configuración.
				_tempBoneFrontEnd = lb.rig.smartCreateEnd _newBoneFront
				_tempBoneBackEnd = lb.rig.smartCreateEnd _newBoneBack
				
				--NC
				_tempBoneFrontEnd.name = "chr" + "_" + "spineCuadrupedo" + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + "spineFkFront-0" + (_o as String) + "-Bon-End" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				_tempBoneBackEnd.name = "chr" + "_" + "spineCuadrupedo" + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + "spineFkBack-0" + (_o as String) + "-Bon-End" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				_tempBoneFrontEnd.length =  _newBoneFront.height / 3
				_tempBoneBackEnd.length =  _newBoneBack.height / 3
				_tempBoneFrontEnd.height =  _newBoneFront.height / 4
				_tempBoneBackEnd.height =  _newBoneBack.height / 4
				_tempBoneFrontEnd.width =  _newBoneFront.height / 4
				_tempBoneBackEnd.width =  _newBoneBack.height / 4
				_tempBoneFrontEnd.sidefins = true
				_tempBoneBackEnd.sidefins = true
				
				append _SpineBoneFKFront _newBoneFront -- añade los huesos de twist en un array
				append _SpineBoneFKBack _newBoneBack -- añade los huesos de twist en un array
				append _SpineBoneFKFrontEnd _tempBoneFrontEnd -- añade los huesos de twist en un array
				append _SpineBoneFKBackEnd _tempBoneBackEnd -- añade los huesos de twist en un array
				
				--Colocamos los huesos en su sitio un seguido de otro.
				if _o > 1 then
				(
					_SpineBoneFKFront[_o].transform = _SpineBoneFKFront[_o-1].transform
					_SpineBoneFKFront[_o].pos = [(20*(_o-1)),0,0]
						
					_SpineBoneFKBack[_o].transform = _SpineBoneFKBack[_o-1].transform
					_SpineBoneFKBack[_o].pos = [(-20*(_o-1)),0,0]
				)
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreateSpineBon | Función para crear los huesos IK necesarios para formar la spine dividida en 2 partes front y back.
		------------------------------------------------------------------------------
		fn CreateSpineBonIK =
		(
			_numberSpine = 3 --cantidad de huesos que forman la spine IK.
			
			--creación de los huesos IK de la Spine Front y back y configuración.
			for _o=1 to (_numberSpine + 1) do 
			(
				_newBoneIKFront = BoneSys.createBone [0,0,0] [20,0,0] [0,0,1] --Creación huesos spine front IK.
				_newBoneIKBack = BoneSys.createBone [0,0,0] [-20,0,0] [0,0,1] --Creación huesos spine back IK.
				
				_newBoneIKFront.wirecolor = color 255 150 0 -- orange
				_newBoneIKBack.wirecolor = color 255 150 0 -- orange
				
				--NC
				_newBoneIKFront.name = "chr" + "_" + "spineCuadrupedo" + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + "spineIkFront-0" + (_o as String) + "-bon-x" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				_newBoneIKBack.name = "chr" + "_" + "spineCuadrupedo" + "_" + lb.nc.NC_classAnim + "_" + lb.nc.NC_locationMiddle + "_" + "spineIkBack-0" + (_o as String) + "-bon-x" + "_" + lb.nc.NC_nonSpecifiedCache + "_" + lb.nc.NC_controlFlag
				
				append _SpineBoneIKFront _newBoneIKFront -- añade los huesos de IKFront en un array
				append _SpineBoneIKBack _newBoneIKBack -- añade los huesos de IKBack en un array
				
				--coloca los huesos IK en su posición correcta, en orden de jerarquía.
				if _o > 1 then
				(
					_SpineBoneIKFront[_o].transform = _SpineBoneIKFront[_o-1].transform
					_SpineBoneIKFront[_o].pos = [(20*(_o-1)),0,0]
						
					_SpineBoneIKBack[_o].transform = _SpineBoneIKBack[_o-1].transform
					_SpineBoneIKBack[_o].pos = [(-20*(_o-1)),0,0]
				)
			)
			--configuramos el tamaño del ultimo hueso de la jerarquía para que tenga la forma de hueso fina.(que es su función).
			_SpineBoneIKFront[_SpineBoneIKFront.count].length = _SpineBoneIKFront[_SpineBoneIKFront.count].length /3
			_SpineBoneIKBack[_SpineBoneIKBack.count].length = _SpineBoneIKBack[_SpineBoneIKBack.count].length /3
			
			--Linka los huesos de IK entre si, formando la jerarquía correcta en la parte Front.
			for _o=1 to _SpineBoneIKFront.count do 
			(
				if _o > 1 then 
				(
					_SpineBoneIKFront[_o].parent = _SpineBoneIKFront[_o-1] 
					lb.controller.freezeTransform _SpineBoneIKFront[_o] #all
				)
			)
			
			--Linka los huesos de IK entre si, formando la jerarquía correcta en la parte Back.
			for _o=1 to _SpineBoneIKBack.count do 
			(
				if _o > 1 then 
				(	
					_SpineBoneIKBack[_o].parent = _SpineBoneIKBack[_o-1] 
					lb.controller.freezeTransform _SpineBoneIKFront[_o] #all
				)
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreateHelpers | Función para crear los point necesarios para formar la spine.
		------------------------------------------------------------------------------
		fn CreateHelpersFK =
		(
			--FRONT    creamos los point verdes para la cadena de FK para la parte Front.
			for _o in _SpineBoneFKFront do 
			(
				_tempHlpFront = lb.rig.createPointFromObj _o --crea los point para cadena FK.
				_tempHlpFront.cross = off
				_tempHlpFront.wirecolor = green --color verde
				_tempHlpFront.size = 12
				
				--NC.
				_tempHlpFront.name = _o.name
				_filterName = FilterString _tempHlpFront.name "_"
				_filterNamePart = FilterString _filterName[5] "-"
				_calculFilterName = (_filterNamePart[2] as integer)
				_restaFilterName = _calculFilterName - 1
				_tempHlpFront.name = lb.nc.replaceNamePart _tempHlpFront.name 5 (_filterNamePart[1] + "-" + (formattedprint _restaFilterName format:"02d") + "-" + "hlp-green")
				_tempHlpFront.name = lb.nc.replaceNamePart _tempHlpFront.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				append _SpineHlpFront _tempHlpFront --metemos los point verdes en un array.
			)
			
			--BACK    creamos los point verdes para la cadena de FK para la parte Back.
			for _o in _SpineBoneFKBack do 
			(
				_tempHlpBack = lb.rig.createPointFromObj _o --crea los point para cadena FK.
				_tempHlpBack.cross = off
				_tempHlpBack.wirecolor = green --color verde
				_tempHlpBack.size = 14
				
				--NC
				_tempHlpBack.name = _o.name
				_filterName = FilterString _tempHlpBack.name "_"
				_filterNamePart = FilterString _filterName[5] "-"
				_calculFilterName = (_filterNamePart[2] as integer)
				_restaFilterName = _calculFilterName - 1
				_tempHlpBack.name = lb.nc.replaceNamePart _tempHlpBack.name 5 (_filterNamePart[1] + "-" + (formattedprint _restaFilterName format:"02d") + "-" + "hlp-green")
				_tempHlpBack.name = lb.nc.replaceNamePart _tempHlpBack.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
				
				append _SpineHlpBack _tempHlpBack --metemos los point verdes en un array.
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreateShpControl | Función para crear los shapes de control de la spine.
		------------------------------------------------------------------------------
		fn CreateShpControl =
		(
			_shapeControl = 1 --Número de shapes (añade uno mas del valor).
			
			--creación del shape por medio de coordenadas y configuración.
			for _o=1 to (_shapeControl + 1) do 
			(
				_shp = splineShape()
				select _shp
				_spln = addNewSpline _shp
				addKnot _shp _spln  #Corner #Line [-10,-10,0] 
				addKnot _shp _spln  #Corner #Line  [-30,-10,0] 
				addKnot _shp _spln  #Corner #Line  [-30,-20,0]
				addKnot _shp _spln  #Corner #Line  [-50,0,0] 
				addKnot _shp _spln  #Corner #Line [-30,20,0] 
				addKnot _shp _spln  #Corner #Line  [-30,10,0] 
				addKnot _shp _spln  #Corner #Line  [-10,10,0]
				
				addKnot _shp _spln  #Corner #Line  [-10,30,0] 
				addKnot _shp _spln  #Corner #Line [-20,30,0] 
				addKnot _shp _spln  #Corner #Line  [0,50,0] 
				addKnot _shp _spln  #Corner #Line  [20,30,0]
				addKnot _shp _spln  #Corner #Line  [10,30,0] 
				addKnot _shp _spln  #Corner #Line [10,10,0] 
				
				addKnot _shp _spln  #Corner #Line  [30,10,0] 
				addKnot _shp _spln  #Corner #Line  [30,20,0]
				addKnot _shp _spln  #Corner #Line  [50,0,0]
				addKnot _shp _spln  #Corner #Line  [30,-20,0] 
				addKnot _shp _spln  #Corner #Line  [30,-10,0]
				addKnot _shp _spln  #Corner #Line  [10,-10,0] 
				
				addKnot _shp _spln  #Corner #Line  [10,-30,0] 
				addKnot _shp _spln  #Corner #Line  [20,-30,0]
				addKnot _shp _spln  #Corner #Line  [0,-50,0]
				addKnot _shp _spln  #Corner #Line  [-20,-30,0] 
				addKnot _shp _spln  #Corner #Line  [-10,-30,0]
				
				close _shp _spln
				_shp.steps=3
				_shp.displayRenderMesh=false
				_shp.wireColor = color 255 255 0 --color amarillo
				_shp.name = _newBoneRoot.name  --configuración de NC.
				
				_shp.scale = [_newBoneRoot.height/5, _newBoneRoot.height/5, _newBoneRoot.height/5] --escala el shape de control.
				ResetXForm _shp --meter un reset Xform para resetear la escala a [1,1,1]
				convertTo _shp SplineShape --convertir a edit Spline.
				
				append _spineShpControl _shp  --metemos estos shapes de control en un array.
			)
			
			_lengthTotalFront = 0
			for _o in _SpineBoneFKFront do _lengthTotalFront += _o.length  --obtención de la suma total de los length.
			
			_lengthTotalBack = 0
			for _o in _SpineBoneFKBack do _lengthTotalBack += _o.length  --obtención de la suma total de los length.
			
			--NC
			_spineShpControl[1].name = lb.nc.replaceNamePart _spineShpControl[1].name 5 ("spineControl-Front-shp-01")
			_spineShpControl[2].name = lb.nc.replaceNamePart _spineShpControl[2].name 5 ("spineControl-Back-shp-01")
			
			--colocación del shape de control en relación al front o back y configuración de punto pivote.			
			_spineShpControl[1].pos.x = _lengthTotalFront/2 	--posición.
			_spineShpControl[2].pos.x = -(_lengthTotalBack/2)	--posición.
			in coordSys Local move _spineShpControl[1] [0,0,20]  --mover en posZ.
			in coordSys Local move _spineShpControl[2] [0,0,20]  --mover en posZ.
			_spineShpControl[1].pivot = [(_lengthTotalFront/2), 0, 0]  --colocación de punto de pivote.
			_spineShpControl[2].pivot = [-(_lengthTotalFront/2), 0, 0]  --colocación de punto de pivote.
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreateSpineIKChain | Función para crear las IKs de la cadena de huesos IK.
		------------------------------------------------------------------------------
		fn CreateSpineIKChain =
		(
			for _o in _SpineBoneIKFront do 
			(
				if _o.children.count > 0 then
				(
					_CreateIkChainFront = iksys.ikchain _o _o.children[1] "IKHISolver"  --creación de las IKs de la cadena de huesos IK Spine.
					_CreateIkChainFront.transform.controller.goalSize = 10
					
					--NC.
					_CreateIkChainFront.name = _o.name
					_filterName = FilterString _CreateIkChainFront.name "_"
					_filterNamePart = FilterString _filterName[5] "-"
					_CreateIkChainFront.name = lb.nc.replaceNamePart _CreateIkChainFront.name 5 (_filterNamePart[1] + "-" + _filterNamePart[2] + "-IKChain-" + _filterNamePart[2])
					_CreateIkChainFront.name = lb.nc.replaceNamePart _CreateIkChainFront.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
					
					append _IKChainFront _CreateIkChainFront
					append _IKChainAll _CreateIkChainFront
				)
			)
			
			for _o in _SpineBoneIKBack do 
			(
				if _o != _SpineBoneIKBack[_SpineBoneIKBack.count] then
				(
					if _o != _SpineBoneIKBack[_SpineBoneIKBack.count-1] then
					(
						_CreateIkChainBack = iksys.ikchain _o _o.children[1] "IKHISolver"  --creación de las IKs de la cadena de huesos IK Spine.
						_CreateIkChainBack.transform.controller.goalSize = 10
						
						--NC.
						_CreateIkChainBack.name = _o.name
						_filterName = FilterString _CreateIkChainBack.name "_"
						_filterNamePart = FilterString _filterName[5] "-"
						_CreateIkChainBack.name = lb.nc.replaceNamePart _CreateIkChainBack.name 5 (_filterNamePart[1] + "-" + _filterNamePart[2] + "-IKChain-" + _filterNamePart[2])
						_CreateIkChainBack.name = lb.nc.replaceNamePart _CreateIkChainBack.name 7 (lb.nc.NC_frozenFlag + lb.nc.NC_hiddenFlag)
						
						append _IKChainBack _CreateIkChainBack
						append _IKChainAll _CreateIkChainBack
					)
				)
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreateHelpers | Función para crear los point necesarios para configurar la cadena IK.
		------------------------------------------------------------------------------
		fn CreateHelpersIK =
		(
			--creamos los point amarillos para la cadena de IK.
			for _o in _IKChainAll do 
			(
				_tempHlpIK = lb.rig.createPointFromObj _o --crea los point para cadena IK.
				_tempHlpIK.cross = off
				_tempHlpIK.wirecolor = yellow --color amarillo
				_tempHlpIK.size = 10
				
				--NC.
				_tempHlpIK.name = _o.name
				_filterName = FilterString _tempHlpIK.name "_"
				_filterNamePart = FilterString _filterName[5] "-"
				_calculFilterName = (_filterNamePart[2] as integer)
				_restaFilterName = _calculFilterName - 1
				_tempHlpIK.name = lb.nc.replaceNamePart _tempHlpIK.name 5 (_filterNamePart[1] + "-" + (formattedprint _restaFilterName format:"02d") + "-" + "hlp-yellow")
				
				append _SpineHlpIKChain _tempHlpIK --metemos los point amarillos en un array.
				
				_o.parent = _tempHlpIK  			--Linkar todos los cross de IKChain a su point amarillo.  
				_tempHlpIK.parent = _newBoneRoot	--Linkar los point amarillos al root.
				lb.controller.freezeTransform _o #all
				lb.controller.freezeTransform _tempHlpIK #all
			)
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreateHelpers | Función para crear los point necesarios para configurar la cadena IK.
		------------------------------------------------------------------------------
		fn CreateHelpersPelvis =
		(
			_tempHlpPelvis = lb.rig.createPointFromObj _IKChainBack[2] --crea los point para cadena IK.
			_tempHlpPelvis.cross = off
			_tempHlpPelvis.wirecolor = yellow --color amarillo
			_tempHlpPelvis.size = 20
			
			--NC.
			_tempHlpPelvis.name = _IKChainBack[2].name
			_filterName = FilterString _tempHlpPelvis.name "_"
			_filterNamePart = FilterString _filterName[5] "-"
			_calculFilterName = (_filterNamePart[2] as integer)
			_restaFilterName = _calculFilterName - 1
			_tempHlpPelvis.name = lb.nc.replaceNamePart _tempHlpPelvis.name 5 (_filterNamePart[1] + "-" + (formattedprint _restaFilterName format:"02d") + "-" + "hlp-pelvis")
			
			append _SpineHlpPelvis _tempHlpPelvis --metemos los point amarillos en un array.
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreateConnexions | Función para crear los diferentes linkajes, constraint y conections.
		------------------------------------------------------------------------------
		fn CreateConnections =
		(
			_SpineHlpFront[1].parent = _newBoneRoot --Linkael 1º HLp de FK Front con el root.
			_SpineHlpBack[1].parent = _newBoneRoot --Linka el 1º Hlp de FK Back con el root.
			lb.controller.freezeTransform _SpineHlpFront[1] #all
			lb.controller.freezeTransform _SpineHlpBack[1] #all
			
			_SpineBoneIKFront[1].parent = _newBoneRoot --Linkael 1º hueso de IK Front con el root.
			_SpineBoneIKBack[1].parent = _newBoneRoot --Linka el 1º hueso de IK Back con el root.
			lb.controller.freezeTransform _SpineBoneIKFront[1] #all
			lb.controller.freezeTransform _SpineBoneIKBack[1] #all
			
			_spineShpControl[1].parent = _newBoneRoot --Linkar el shapeCOntrol Front al root.
			lb.controller.freezeTransform _spineShpControl[1] #all
			
			--Linkar los point verdes a los huesos Fk correctos de la parte Front, para crear la jerarquia FK.
			for _o in _SpineBoneFKFront do 
			(
				_filterNameBon = (lb.nc.getNamePart _o.name 5)				--filtrar nombre para sacar la parte que queremos comparar mas adelante
				_filterNameBonPart = (filterString _filterNameBon "-")[2]
				
				for _p in _SpineHlpFront do 
				(
					_filterNameHlp  = (lb.nc.getNamePart _p.name 5)				--filtrar nombre para sacar la parte que queremos comparar mas adelante
					_filterNameHlpPart = (filterString _filterNameHlp "-")[2]
					
					_numberfilter = ((_filterNameHlpPart as integer) + 1)
					
					if _filterNameHlpPart == _filterNameBonPart then
					(
						_p.parent = _o  --Linkar Hlp verdes a los huesos inferiores FK.
						lb.controller.freezeTransform _p #all
					)
					
					if _filterNameBonPart == (formattedprint _numberfilter format:"02d") then
					(
						_o.parent = _p --Linkar los Bone FK a los Hlp inferiores verdes.
						lb.controller.freezeTransform _o #all
					)
				)
			)
			
			--Linkar los point verdes a los huesos Fk correctos de la parte Back.
			for _o in _SpineBoneFKBack do 
			(
				_filterNameBon = (lb.nc.getNamePart _o.name 5)				--filtrar nombre para sacar la parte que queremos comparar mas adelante
				_filterNameBonPart = (filterString _filterNameBon "-")[2]
				
				for _p in _SpineHlpBack do 
				(
					_filterNameHlp  = (lb.nc.getNamePart _p.name 5)				--filtrar nombre para sacar la parte que queremos comparar mas adelante
					_filterNameHlpPart = (filterString _filterNameHlp "-")[2]
					
					_numberfilter = ((_filterNameHlpPart as integer) + 1)
					
					if _filterNameHlpPart == _filterNameBonPart then
					(
						_p.parent = _o --Linkar Hlp verdes a los huesos inferiores FK.
						lb.controller.freezeTransform _p #all
					)
					
					if _filterNameBonPart == (formattedprint _numberfilter format:"02d") then
					(
						_o.parent = _p --Linkar los Bone FK a los Hlp inferiores verdes.
						lb.controller.freezeTransform _o #all
					)
				)
			)
			
			_SpineHlpIKChain[3].parent = _spineShpControl[1]	--Linkar el point amarillo 3, esta en la parte Front, al shape 01 Front.
			_SpineHlpIKChain[4].parent = _SpineHlpPelvis[1]		--Linkar el point amarillo 4, esta en la parte Back, al point pelvis.
			_SpineHlpPelvis[1].parent = _newBoneRoot			--Linkarel point pelvis al root.
			_SpineHlpIKChain[5].parent = _spineShpControl[2]	--Linkar el point amarillo 5, esta en la parte Back, al shape 02 Back.
			_spineShpControl[2].parent = _SpineHlpPelvis[1]		--Linkar el shape 02 Back, al point de la pelvis.
			
			lb.controller.freezeTransform _SpineHlpIKChain[3] #all
			lb.controller.freezeTransform _SpineHlpIKChain[4] #all
			lb.controller.freezeTransform _SpineHlpIKChain[1] #all
			lb.controller.freezeTransform _SpineHlpIKChain[5] #all
			lb.controller.freezeTransform _spineShpControl[2] #all
			
			--añade float expression a los swivelAngle para controlar el twist de la spine en la parte front.
			for _o in _IKChainFront do 
			(
				_FloatExprSwivel = _o.transform.controller.swivelAngle.controller = Float_Expression ()
				_FloatExprSwivel.AddScalarTarget "rot_swivelAngle" _spineShpControl[1].rotation.controller[#zero_Euler_XYZ][#X_rotation]
				_FloatExprSwivel.setExpression ("rot_swivelAngle")
			)
			
			--añade float expression a los swivelAngle para controlar el twist de la spine en la parte Back.
			for _o in _IKChainBack do 
			(
				_FloatExprSwivel = _o.transform.controller.swivelAngle.controller = Float_Expression ()
				_FloatExprSwivel.AddScalarTarget "rot_swivelAngle" _spineShpControl[2].rotation.controller[#zero_Euler_XYZ][#X_rotation]
				_FloatExprSwivel.setExpression ("-rot_swivelAngle")
			)
			
			--añade orientation constraint a los point verdes, como target los huesos de ik en la parte Front.
			for _o in _SpineHlpFront do 
			(
				_filterNameBon = (lb.nc.getNamePart _o.name 5)				--filtrar nombre para sacar la parte que queremos comparar mas adelante
				_filterNameBonPart = (filterString _filterNameBon "-")[2]
				
				for _p in _SpineBoneIKFront do 
				(
					_filterNameHlp  = (lb.nc.getNamePart _p.name 5)				--filtrar nombre para sacar la parte que queremos comparar mas adelante
					_filterNameHlpPart = (filterString _filterNameHlp "-")[2]
					
					_numberfilter = ((_filterNameHlpPart as integer) - 1)
					_numberFilterTotal = formattedprint _numberfilter format:"02d"
					
					if _filterNameBonPart == _numberFilterTotal then
					(
						_o.rotation.controller.Available.controller = Orientation_Constraint ()
						_o.rotation.controller.Orientation_Constraint.controller.appendTarget _p 100
					)
				)
			)
			--añade orientation constraint a los point verdes, como target los huesos de ik en la parte Back.
			for _o in _SpineHlpBack do 
			(
				_filterNameBon = (lb.nc.getNamePart _o.name 5)				--filtrar nombre para sacar la parte que queremos comparar mas adelante
				_filterNameBonPart = (filterString _filterNameBon "-")[2]
				
				for _p in _SpineBoneIKBack do 
				(
					_filterNameHlp  = (lb.nc.getNamePart _p.name 5)				--filtrar nombre para sacar la parte que queremos comparar mas adelante
					_filterNameHlpPart = (filterString _filterNameHlp "-")[2]
					
					_numberfilter = ((_filterNameHlpPart as integer) - 1)			--sacamos el número y lo restamos a 1.
					_numberFilterTotal = formattedprint _numberfilter format:"02d"	--ese número le añadimos los decimales para  que tengamos un string con 2 numeros para compararlo.
					
					if _filterNameBonPart == _numberFilterTotal then
					(
						_o.rotation.controller.Available.controller = Orientation_Constraint ()
						_o.rotation.controller.Orientation_Constraint.controller.appendTarget _p 100
					)
				)
			)
			
			--configuramos las instancias con los shapes de control, creamos los positionXYZ y los instanciamos.
			_SpineHlpIKChain[1].pos.controller.Available.controller = Position_XYZ ()
			_SpineHlpIKChain[1].pos.controller.position_xyz.controller = _spineShpControl[1].pos.controller[#zero_pos_xyz].controller
			_SpineHlpIKChain[1].pos.controller.weight[3] = 15
			_SpineHlpIKChain[2].pos.controller.Available.controller = Position_XYZ ()
			_SpineHlpIKChain[2].pos.controller.position_xyz.controller = _spineShpControl[1].pos.controller[#zero_pos_xyz].controller
			_SpineHlpIKChain[2].pos.controller.weight[3] = 50
			_SpineHlpIKChain[4].pos.controller.Available.controller = Position_XYZ ()
			_SpineHlpIKChain[4].pos.controller.position_xyz.controller = _spineShpControl[2].pos.controller[#zero_pos_xyz].controller
			_SpineHlpIKChain[4].pos.controller.weight[3] = 30
		)
		
		------------------------------------------------------------------------------------------------------------------------------------------------------
		--@fn: undefined | createAttribStrechSpine |  Función que contiene el customAttribute del snap de SpineStrech
		------------------------------------------------------------------------------------------------------------------------------------------------------
		fn createAttribStrechSpine =
		(
			CA_ARS_StrechSpine = attributes StrechSpine 
			(
				-- Parametros Ca
				parameters main rollout:rollStrech
				(
					-- Controles
					Strech type:#float ui:(snpStrech, sldStrech)
				)
				
				------------------------------------------------------------------------------
				----------------------------Rollout -----------------------------------------
				------------------------------------------------------------------------------
				rollout rollStrech "Strech Controls"
				(
					spinner snpStrech "Strech_Spine" range:[-100,100,0]
					slider sldStrech "" range:[-100,100,0]
				)
			)
			CA_ARS_StrechSpine
		)
		
		------------------------------------------------------------------------------
		--@fn: undefined | CreateStreching | Función para crear los streching en los huesos de FK.
		------------------------------------------------------------------------------
		fn CreateStreching =
		(
			_spineBoneFKAll = _SpineBoneFKFront + _SpineBoneFKBack 	--sumamos 2 arrays para manipularlos en uno.
			
			-- Creamos el modificador vacio, y añadimos el CA del Spine Strech.
			for _o in _spineBoneFKAll do 
			(
				_emptyModSpineStrech = emptyModifier()
				_emptyModSpineStrech.name = "Spine_Controls"
				
				addModifier _o _emptyModSpineStrech			--añadimos un modificador vacio.
				custAttributes.add  _o.modifiers[#Spine_Controls] (createAttribStrechSpine()) #unique	--rellenamos el modificador vacio con los parametros del customAtribute.
				
				_o.modifiers[#Spine_Controls].Strech.controller = bezier_float()		--añadimos un bezier a la pista para poder manipularla.
				_o.modifiers[#Spine_Controls].Strech.controller = float_limit upper_limit: 100 lower_limit: -100	--Añadimos un float limit para limitar la pista.
			)
			
			--añadimos el float Expression a los huesos finales del FK para configurar el streching por posicion en pista X. FRONT
			for _o in _SpineBoneFKFrontEnd do 
			(
				_parent = _o.parent
				_floatExpStrechEnd = _o.pos.controller.Zero_Pos_XYZ.controller.X_Position.controller = Float_Expression ()  --Añadimos el Float Expression.
				_floatExpStrechEnd.AddScalarTarget "StrechPosX" _parent.modifiers[#Spine_Controls].Strech.controller
				_floatExpStrechEnd.setExpression ("StrechPosX")
			)
			
			--añadimos el float Expression a los point verdes del FK para configurar el streching por posicion en pista X. FRONT
			for _o in _SpineHlpFront do 
			(
				if _o != _SpineHlpFront[1] do 
				(					
					_parent = _o.parent
					_floatExpStrechHlp = _o.pos.controller.Zero_Pos_XYZ.controller.X_Position.controller = Float_Expression ()  --Añadimos el Float Expression.
					_floatExpStrechHlp.AddScalarTarget "StrechPosX" _parent.modifiers[#Spine_Controls].Strech.controller
					_floatExpStrechHlp.setExpression ("StrechPosX")
				)
			)
			
			--añadimos el float Expression a los huesos finales del FK para configurar el streching por posicion en pista X. BACK
			for _o in _SpineBoneFKBackEnd do 
			(
				_parent = _o.parent
				_floatExpStrechEnd = _o.pos.controller.Zero_Pos_XYZ.controller.X_Position.controller = Float_Expression ()  --Añadimos el Float Expression.
				_floatExpStrechEnd.AddScalarTarget "StrechPosX" _parent.modifiers[#Spine_Controls].Strech.controller
				_floatExpStrechEnd.setExpression ("StrechPosX")
			)
			
			--añadimos el float Expression a los point verdes del FK para configurar el streching por posicion en pista X. BACK
			for _o in _SpineHlpBack do 
			(
				if _o != _SpineHlpBack[1] do 
				(					
					_parent = _o.parent
					_floatExpStrechHlp = _o.pos.controller.Zero_Pos_XYZ.controller.X_Position.controller = Float_Expression ()  --Añadimos el Float Expression.
					_floatExpStrechHlp.AddScalarTarget "StrechPosX" _parent.modifiers[#Spine_Controls].Strech.controller
					_floatExpStrechHlp.setExpression ("StrechPosX")
				)
			)
		)
		
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
		--@fn: undefined | createSceneEvents | Crea los callbacks relacionados con el rollout
		------------------------------------------------
		fn createSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--@fn: undefined | removeSceneEvents | Destruye los callbacks relacionados con el rollout
		------------------------------------------------
		fn removeSceneEvents =
		(
		
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@fn: undefined | saveSettings | Salva los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn saveSettings =
		(
			--almacena posicion
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "x" (((getDialogPos rollMainDef).x) as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/pos") "y" (((getDialogPos rollMainDef).y) as string)
			
			--almacena tamaño
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "width" (rollMainDef.width as string)
			lb.xml.setAttribute parent.cfgFile ("rollMain/size") "height" (rollMainDef.height as string)
		)
		
		------------------------------------------------
		--@fn: undefined | loadSettings | Carga los settings de la herramienta en el documento de configuración de la misma.
		------------------------------------------------
		fn loadSettings =
		(
			_width = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "width") as integer
			_height = (lb.xml.getAttribute parent.cfgFile ("rollMain/size") "height") as integer
				
			--posicion
			_posX = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "x") as integer
			_posY = (lb.xml.getAttribute parent.cfgFile ("rollMain/pos") "y") as integer
				
			--establece minimos
			if _width < minRollWidth then _width = minRollWidth
			if _height < minRollHeight then _height = minRollHeight
			if _posX < 0 then _posX = 0
			if _posY < 0 then _posY = 0
				
			--aplica los valores
			rollMainDef.width = _width
			rollMainDef.height = _height
			setDialogPos rollMainDef [_posX,_posY]
		)
		
		------------------------------------------------------------------------------------------------
		--EVENTS
		------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------
		--Evento para crear la spine cuadrupeda.
		---------------------------------------------------------------------------------------------------------------
		on btnCreateSpineCuadrupedo pressed do
		(
			CreateSpineBonFk()
			CreateSpineBonIk()
			CreateHelpersFK()
			CreateShpControl()
			CreateSpineIKChain()
			CreateHelpersIK()
			CreateHelpersPelvis()
			CreateConnections()
			CreateStreching()
		)
		
		------------------------------------------------
		--COMMON
		------------------------------------------------
		
		------------------------------------------------
		--@event: resized | Evento que se lanza al redimensionar el rollout.
		--@control: rollout | rollMain | El elemento que sufre la redimensión. El rollout principal de la herramienta.
		--@gets: point2 | size | tamaño al que se ha redimensionado el rollout
		------------------------------------------------
		on rollMainDef resized size do
		(
			------------------------------------------------------------------------------
			--si la herramienta se redimensiona más pequeña que el mínimo, lo limita al minimo
			if size.x < minRollWidth then (size.x = minRollWidth; rollMainDef.width = size.x)
			if size.y < minRollHeight then (size.y = minRollHeight; rollMainDef.height = size.y)
			------------------------------------------------------------------------------
			
			--calcula el incremento en ancho y alto, respecto al mínimo.
			_increment = [size.x - minRollWidth, size.y - minRollHeight]
			
			------------------------------------------------------------------------------
			--redimension en horizontal
			if _increment.x != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------
			--redimension en vertical
			if _increment.y != 0 then --si hay incremento
			(
				
			)--if
			------------------------------------------------------------------------------
		)
		
		------------------------------------------------
		--@event: open | Evento que se lanza al abrir el rollout.
		--@control: rollout | rollMain | El elemento que se abre. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef open do
		(
			loadSettings()
			createSceneEvents() --crea los callbacks
		)
		
		------------------------------------------------
		--@event: close | Evento que se lanza al cerrar el rollout.
		--@control: rollout | rollMain | El elemento que se cierra. El rollout principal de la herramienta.
		------------------------------------------------
		on rollMainDef close do
		(
			removeSceneEvents() --elimina los callbacks
			saveSettings()
			
			parent.opened = false --indica que la herramienta está cerrada.
			updateToolbarButtons()
		)
	)--rollMainDef
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateTool | Contiene la herramienta spineCuadrupedo.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct tl_spineCuadrupedo
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la tool.
		className = lb.getFileToolName (getThisScriptFilename() as string),	--@var: className | Nombre de la tool.
		description = "spine Cuadrupedo",		--@var: description | Descripcion de la tool.
		
		cfgFile = (lb.config.getToolsIniPath()) + (lb.getFileToolName (getThisScriptFilename() as string)) + ".cfg",	--@var: cfgFile | Archivo de configuracion de la tool.
			
		opened = false,			--@var: opened | Indica si la herramienta está abierta.
			
		------------------------------------------------------------------------------------------------
		--VARIABLES
		------------------------------------------------------------------------------------------------
			
		------------------------------------------------------------------------------------------------
		--LIBRARIES
		------------------------------------------------------------------------------------------------
		
		------------------------------------------------------------------------------------------------
		--ROLLOUTS
		------------------------------------------------------------------------------------------------
		
		rollMain = rollMainDef,	--@var: rollMain | Almacena el rollout principal de la herramienta.
			
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
		--@fn: boolean | isOpen | Devuelve información true o false, si la herramienta está abierta o cerrada.
		------------------------------------------------
		fn isOpen =
		(
			this.opened
		),
		
		------------------------------------------------
		--@fn: undefined | refreshInterface | Refresca el interface inicial de la herramienta
		------------------------------------------------
		fn refreshInterface =
		(
			--refresca el interface de la herramienta
		),
		
		------------------------------------------------
		--@fn: undefined | createInterface | Crea el interface inicial de la herramienta
		------------------------------------------------
		fn createInterface =
		(
			--crea el interface, lo redimensiona y lo reposiciona
			createDialog this.rollMain lockwidth:false lockheight:false pos:[-10000,0] style:#(#style_toolwindow, #style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		------------------------------------------------
		--@fn: undefined | destroyInterface | Destruye el interface de la herramienta.
		------------------------------------------------
		fn destroyInterface =
		(
			destroyDialog this.rollMain --cierra la herramienta.			
		),--destroyInterface
		
		------------------------------------------------
		--@fn: undefined | run | Lanza la herramienta.
		------------------------------------------------
		fn run =
		(
			this.createInterface() --crea el interface.
			this.opened = true --indica que la herramienta está abierta
		),--execute
		
		------------------------------------------------
		--@fn: undefined | close | Cierra la herramienta.
		------------------------------------------------
		fn close =
		(
			this.destroyInterface() --destruye el interface.
			this.opened = false --indica que la herramienta está cerrada.
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
			lb.addTool this --añade la tool a la libreria principal	
		)		
		
	)--tl_spineCuadrupedo
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------	
	
	tl_spineCuadrupedo() --crea la herramienta
)