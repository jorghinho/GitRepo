------------------------------------------------------------------------------------------------------------------------------------------------
--Descripcion: libreria de ffdFunctions
------------------------------------------------------------------------------------------------------------------------------------------------
(	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--@struct: templateLib | Contiene la libreria de ffdFunctions.
	------------------------------------------------------------------------------------------------------------------------------------------------
	struct lib_ffdFunctions
	(
		------------------------------------------------------------------------------------------------
		--COMMON
		------------------------------------------------------------------------------------------------
		
		def = (classof this),				--@var: def | Almacena la definicion del struct.
		defFile = getThisScriptFilename(),	--@var: defFile | Almacena la ruta del propio archivo de script que contiene la definicion.
		
		category = #main,					--@var: category | Categoria de la libreria.
		className = lb.getFileLibName (getThisScriptFilename() as string),	--@var: className | Nombre de la libreria.
		description = "Libreria FFD Functions",	--@var: description | Descripcion de la libreria.
		
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

		-------------------------------------------------------------------------------------------------
		--hace los puntos de un FFDspacewarp animables
		-------------------------------------------------------------------------------------------------
		fn SWffdAnimateAll o =
		(
			--si el objeto es un spaceFFD
			if classof o == SpaceFFDBox then
			(
				-- defines
				-- user interaction windows message
				local WM_USER = 1024
				-- changing a spinner message
				local CC_SPINNER_CHANGE = WM_USER + 600

				-- select the spacewarp
				select o

				-- change the command panel to modify mode
				max modify mode

				-- go to the control points sub-object level
				subObjectLevel = 1

				-- select all the control points
				max select all

				-- go into move transform mode
				max move

				-- open the 'transform type-in' dialog
				max tti

				-- find the tti dialog
				local desktopHWND = windows.getDesktopHWND()
				local desktopChildren = windows.getChildrenHWND desktopHWND
				local tti
				for child in desktopChildren do (
					if (child[5] == "Move Transform Type-In") then (
						tti = child
						exit
					)
				)
				if (tti == undefined) then ( return false )

				-- get the tti's handle
				local ttiHWND = tti[1]

				-- now find a spinner therein (don't care much which)
				local ttiChildren = windows.getChildrenHWND ttiHWND
				local anySpinner
				for child in ttiChildren do (
					if (child[4] == "SpinnerControl") then ( anySpinner = child; exit )
				)
				if (anySpinner == undefined) then ( return false )

				-- get the spinner's handle
				local anySpinnerHWND = anySpinner[1]
				-- get the spinner's dialog id
				local anySpinnerDlgID = uiaccessor.GetWindowResourceID anySpinnerHWND
				-- get the spinner's parent dialog
				local anySpinnerParent = uiaccessor.getparentwindow anySpinnerHWND

				-- go into animation (auto-key) mode
				animButtonState = true

				-- make sure we're not on frame zero
				-- store the old frame first
				local oldSliderTime = sliderTime
				-- now change it
				sliderTime = 1
				
				-- now let's make max think we changed the spinner's value.
				-- The SDK says there's an option to indicate that we're dragging the spinner
				-- we're not, so ignore any of that (bit.shift 1 16) stuff we'd otherwise have to add
				windows.sendmessage anySpinnerParent CC_SPINNER_CHANGE anySpinnerDlgID anySpinnerHWND
				
				-- with any luck, the points are now animated
				
				-- restore the frame we're on
				sliderTime = oldSliderTime
				
				-- go out of animation (auto-key) mode
				animButtonState = false
				
				-- close that tti dialog
				UIAccessor.CloseDialog ttiHWND
				
				-- go out from the control points sub-object level
				subObjectLevel = 0
			)
		),	

		--devuelve el numero de puntos de control
		fn SWffdNumCPs ffdObj = 
		(
			if classof ffdObj == SpaceFFDBox then
				ffdObj[4][8].numSubs
			else
				undefined
		),

		--obtiene la posicion local del punto i del ffd
		fn SWffdGetCPpos obj i =
		(
			if classof obj == SpaceFFDBox then		
			(
				n = SWffdNumCPs obj
				if n == undefined then SWffdAnimateAll obj
					
				obj[4][8][i].controller.value
			)
			else
				undefined		
		),
		
		--asigna la posicion local al punto i del ffd
		fn SWffdSetCPpos obj i pos =
		(
			if classof obj == SpaceFFDBox then		
			(
				n = SWffdNumCPs obj
				if n == undefined then SWffdAnimateAll obj
					
				obj[4][8][i].controller.value = pos
			)
		),
		
		--invierte la visualizacion del ffd
		fn SWffdInvert obj Xflag Yflag Zflag =
		(
			if not Xflag then
				obj.objectOffsetScale.x = 1
			else if obj.objectOffsetScale.x == -1 then
				Xflag = false
			
			if not Yflag then
				obj.objectOffsetScale.y = 1
			else if obj.objectOffsetScale.y == -1 then
				Yflag = false
			
			if not Zflag then
				obj.objectOffsetScale.z = 1
			else if obj.objectOffsetScale.z == -1 then
				Zflag = false
			
			lb.rig.flipVis #(obj) Xflag Yflag Zflag
		),

		--copia  la forma de un ffd a otro siempre que sean del mismo numero de puntos
		--puede copiarlo invertido
		fn SWffdCopy original target invertX:false invertY:false invertZ:false=
		(
			success = false --flag para saber si ha tenido exito
			
			n1 = n2 = undefined
			
			--obtiene el numeto de puntos de control de cada ffd
			n1 = SWffdNumCPs original
			n2 = SWffdNumCPs target
			
			--si hay puntos de control y los dos ffd tienen el mismo numero de ellos
			if n1 == n2 and n1 != undefined then
			(
				--comprueba que los ffd sean animables y si no lo son crea controladores para cada punto de control
				try 
					val = original[4][8][1].contoller.value
				catch
					SWffdAnimateAll original
				
				try 
					val = target[4][8][1].contoller.value
				catch
					SWffdAnimateAll target
				
				--copia los valores de un ffd a otro
				for i=1 to n1 do
				(
					SWffdSetCPpos target i (SWffdGetCPpos original i)
					
					success = true
				)
				
			)
			
			--if invertX or invertY or invertZ then
				SWffdInvert target invertX invertY invertZ
			
			success
		),
		
		fn saveFFD obj f =
		(
			fileSaved = false
			
			--si los parametros no estan vacios
			if f != undefined and obj != undefined then
			(
				limit = 0
				
				--mira a ver si el modificador es un ffd
				if classof obj == SpaceFFDBox then
				(
					limit = SWffdNumCPs obj
					
					try
						SWffdGetCPpos obj i
					catch
						SWffdAnimateAll obj

					--si es un ffd
					if limit != 0 then
					(
						fileSaved = setINISetting f "FFDinfo" "limit" (limit as string)
						fileSaved = setINISetting f "FFDinfo" "length" (obj.length as string)
						fileSaved = setINISetting f "FFDinfo" "width" (obj.width as string)
						fileSaved = setINISetting f "FFDinfo" "height" (obj.height as string)
						
						for i=1 to limit do
							fileSaved = setINISetting f "FFDcontrolPoints" (i as string) ((SWffdGetCPpos obj i) as string)
						
					)
				)
			)
			
			fileSaved
		),
		
		fn loadFFD obj f =
		(
			fileLoaded = false
			
			--si los parametros no estan vacios
			if f != undefined and obj != undefined then
			(
				limit = 0

				--mira a ver si el modificador es un ffd
				if classof obj == SpaceFFDBox then
				(
					limit = SWffdNumCPs obj
					
					try
						SWffdGetCPpos obj i
					catch
						SWffdAnimateAll obj

					--si es un ffd
					if limit != undefined then
					(
						limitLoaded = (getINISetting f "FFDinfo" "limit") as integer
						
						if limitLoaded == limit then
						(
							ffdLength = (getINISetting f "FFDinfo" "length") as float
							ffdWidth = (getINISetting f "FFDinfo" "width") as float
							ffdHeight = (getINISetting f "FFDinfo" "height") as float
							
							if ffdLength != "" then obj.length = ffdLength
							if ffdWidth != "" then obj.width = ffdWidth
							if ffdHeight != "" then obj.height = ffdHeight
							
							for i=1 to limit do
							(
								pos = (getINISetting f "FFDcontrolPoints" (i as string))
								pos = filterString pos "[],"
								if pos.count == 3 then
								(
									pos = [pos[1] as float, pos[2] as float, pos[3] as float]
									SWffdSetCPpos obj i pos
								)
							)
							
							fileLoaded = true
						
						)
					)
				)
			)
			
			fileLoaded
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
	)--lib_ffdFunctions
	
	------------------------------------------------------------------------------------------------------------------------------------------------
	--EXECUTION
	------------------------------------------------------------------------------------------------------------------------------------------------
	
	lib_ffdFunctions() --crea la libreria
)