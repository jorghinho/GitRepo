--ESTA LA VERSION MODIFICADA DE LIGHTBOX
--se ha cambiado la ruta del archivo .dat de la fuente

-- infoOverlay v0.91
-- for 3ds max 8+ - (c) 2006-08 by M. Breidt (martin@breidt.net)
--
-- This code is released under "Quote ware" license:
--      If you use this tool in a production environment with a group of more than two people,
--      or have used it in the past under such conditions, then you are obliged to tell 
--      me (martin@breidt.net) about it and allow me to list that project title and your 
--      company name as a reference on my website http://scripts.breidt.net
--
-- This scripted render effect will draw an overlay with additional scene
-- information (filename, date, framenumber etc.) onto your rendered image
-- After installation, you can find it under Rendering > Effects > Add
-- 
-- New in 0.91: hopefully fixed a crash bug when used in combination with mr
-- New in 0.9: X/Y Pos for additional text; scale for image overlay; new render time system (hopefully no more crashes with mr?)
-- New in 0.7: Fixed SMPTE bug, added Safe Frame, added Seconds time format, added center cross
-- New in 0.6: Image overlay (e.g. for watermarks)
-- New in 0.5: Camera Name element, option for short filename
-- New in 0.4: some UI cosmetics; new text element: render time of last frame
-- New in 0.3: SMPTE support; additional text in top center
-- New in 0.2: Font Scale option; better error handling when font is missing
--
-- Installation: 
-- Copy this script along with the font file "font32_127.dat" into the scripts 
-- startup directory (by default: <3dsmax>\scripts\startup) and restart 3ds max.
-- After a restart, there will be a new effect called "infoOverlay" that can be added 
-- to your scene; upon rendering, you will see some text overlay at the top and bottom
-- borders of your rendered image
--
-- Useage: Apply the effect to your scene and render
--     Check/uncheck the individual overlay items to show/hide them:
--
--     Frame:             Displays the current frame number, padded with zeros 
--          Format:       Format for time display: frame number, SMPTE or seconds
--          Padding:      Number of digits for the frame number or decimals for seconds
--     File Name:         Displays the full path and filename
--     Date/Time:         Displays the system time at rendering time (affected by
--                        your machine's country/language settings)
--     User/Machine Name: Displays the Windows user and computer name 
--     Render Time:       Displays the render time in seconds for the current frame
--     Camera Name:       Displays the name of the camera/view being rendered
--
--     Draw Frame:        Draw a rectangular frame (e.g. safe regions) using frame color
--       H/V:             Horizontal/vertical size of frame
--       L:               Lock vertical size to horizontal
--       Percent/Pixels:  Specifies whether the frame size H/V is a percentage of the image size or absolute pixels
--       Frame Color:     Line color of the frame
--       Mask Frame:      Darken image outside of frame (slow)
--       Draw Center:     Draw a center cross using the frame color
-- 
--     Bottom Text:       Displays any additional text you enter in the textbox next
--                        to the checkbox; if the "S" button at the end of the
--                        textbox is active, the entered text is evaluated as
--                        MAXScript and the result is displayed.
--                        Some useful MAXScript commands/expressions:
--                           frameRate	    -- displays the current FPS
--                           rendOutputFilename -- displays the current render file name
--                           renderWidth        -- width of the rendered image in pixels
--                           renderHeight       -- height of the rendered image in pixels
--                           renderPixelAspect  -- pixel aspect of the rendered image
--                           objects.count      -- number of objects in the scene
--                           fileProperties.getItems "Mesh Totals" -- returns vertex and face count (only works for saved scenes)
--     Top Text:          Displays additional text
--
--     Font Scale:        Simple maginification factor for the font, useful for highres renderings
--     Dim Background:    Controls whether the text is on a darkened backgroud
--     Alpha Blend:       Controls whether the text has transparent background.
--
--     Use Image Overlay: Enables simple image compositing, e.g. for watermarking
--       Image:           Lets you select the image file
--       X/Y Pos:         Shift the image by x/y pixels to the right/down
--       Transfer Mode:   Compositing style as in Photoshop
--       Opacity:         Total opacity of the image overlay
--
-- Useful comment by scriptspot user dmmd123:
-- -- If you are doing a sun study and want to put the time of day on the frame paste this code into the Additional text, bottom field:
-- (int($Daylight01[3].object.value/3600.0)) as string + ":" + formattedPrint (int(($Daylight01[3].object.value - int($Daylight01[3].object.value/3600.0)*3600.0)/60.0)) format:"02.2d"
-- -- Change all the Daylight01's to whatever you have named your sun.

plugin renderEffect infoOverlay
name:"infoOverlay"
classID:#(0x40de22c9, 0x930eb78)
version:2
(
	local functional

	local custCA = attributes renderTime (
	-- code snippet by James Haywood
		    parameters main (
		        renderStart type:#integer animatable:false
		        renderTime type:#float animatable:false
		    )
		    fn preRender = (
		        rootNode.renderTime.renderStart = (timeStamp())
		    )
		    fn postRender = (
		        rootNode.renderTime.renderTime = (timeStamp() - rootNode.renderTime.renderStart)
		        format "Render Time: % seconds\n" (rootNode.renderTime.renderTime/1000.0)
		    )
			/*
		    on load do (
		        callbacks.removeScripts id:#infoOverlayCB_persistent
		        callbacks.addScript #preRender "try(rootNode.renderTime.preRender())catch()" id:#infoOverlayCB_persistent
		        callbacks.addScript #postRender "try(rootNode.renderTime.postRender())catch()" id:#infoOverlayCB_persistent
		    )
			*/
	) -- end attributes


	fn checkFont = (
	-- check whether font is present and load if not
		global myLetter
		if myLetter==undefined then (
			format "infoOverlay: Loading font...\n"
			myLetter=undefined
			try (
				_scrpt = ((getDir #maxroot) + "stdplugs\\stdscripts\\lbTools\\toolsCfg\\font32_127.dat")
				myLetter = fileIn _scrpt
				--myLetter = fileIn "$startupScripts\\font32_127.dat"
			) catch (
				messageBox "Cannot find font file, please check installation!\nContinuing will cause improper function!" title:"infoOverlay error" beep:true
				return false
			)
			if (classof myLetter)!=array then (
				messageBox "Error loading font from file!\nContinuing will cause improper function!" title:"infoOverlay error" beep:true
				return false
			)
		)
		return true
	)
	
	fn padNum num padlen = (
	-- return num as string with zero padding
		local zeros = 10^padlen
		substring ((zeros+num) as string) 2 (padlen+1)
	)

	fn printLetter bm chPos ch alpha fontScale = (
	-- write letter 'ch' into bitmap 'bm' at position 'chPos' and return [width, height] of char
		if not checkFont() then return [0,0]
		charNum = bit.charAsInt ch
		if (charNum<1) or (charNum>myLetter.count) or (myLetter[charNum].count==0) then charNum = 127
		
		for ln = 1 to myLetter[charNum].count do (
			-- write letter line by line
			if alpha then (
				-- perform alpha blending
				sl = getPixels bm (chPos+([0,ln]*fontScale)) (myLetter[charNum][ln].count * fontScale)
				if sl==undefined then (
					format "infoOverlay error: getPixel out of bounds!\n"
				) else (
					for p = 1 to sl.count do (
						local pixl = ((p-1)/fontScale)+1
						local a = (myLetter[charNum][ln][pixl].alpha)/255.0
						sl[p] = (1 - a) * sl[p] + a * myLetter[charNum][ln][pixl]
					)
					-- write out scanline (repeat for multiple lines if needed by fontScale)
					for l = 0 to fontScale-1 do setPixels bm (chPos+([0,ln]*fontScale)+[0,l]) sl
				)
			) else (
				-- overwrite values; fast but no fontScale
				setPixels bm (chPos+[0,ln]) myLetter[charNum][ln]
			)
		)
		return [myLetter[charNum][1].count * fontScale, myLetter[charNum].count * fontScale]
	)

	fn printString bm strPos str alpha fontScale = (
	-- write entire string into bitmap
		for c = 1 to str.count do (
			chSize = printLetter bm strPos str[c] alpha fontScale
			strPos += [chSize.x, 0]
		)
	)

	fn getAlignedPos bm h_align v_align str fontScale = (
	-- return start position for aligned string 
		if not checkFont() then return [0,0]
		
		local myPos = [0,0]
		if str.count>0 then (
			-- calculate dimensions of string
			str_width = 0
			local cv = 127
			for c = 1 to str.count do (
				cv = bit.charAsInt str[c]
				if (cv<1) or (cv>myLetter.count) or (myLetter[cv].count==0) then cv = myLetter.count
				str_width += myLetter[cv][1].count
			)
			str_width *= fontScale
			str_height = (myLetter[myLetter.count].count * fontScale)
			
			-- calc aligned pos
			myPos.x = case h_align of (
				#left: fontScale
				#center: ((bm.width/2)-1) - (str_width/2)
				#right: bm.width - (1*fontScale) - str_width
			)
			myPos.y = case v_align of (
				#top: 0
				#center: ((bm.height/2)-1) - (str_width/2)
				#bottom: bm.height - 1 - str_height
			)
		)
		return myPos
	)

	fn dimBackground bitmp area = (
		-- dim down intensity on bitmap 'bitmp' in box2 'area'
		for i = area.top to area.bottom do (
			sl = getPixels bitmp [area.left, i] (area.right - area.left)
			for j=1 to sl.count do (
				local a = sl[j].alpha
				sl[j].value *= 0.5	-- bug: alpha value lost
				sl[j].alpha = a
			)
			setPixels bitmp [area.left, i] sl
		)
	)

	fn convertTime_SMTPE theTime = (
		-- convert time value into SMPTE string
		local tps = 4800
		local secs = theTime.ticks / tps
		local mins = secs / 60
		local frames = (mod theTime.frame frameRate) as integer
		((padNum mins 2) + ":" + (padNum secs 2) + ":" + (padNum frames 2))
	)

	fn convertTime_Seconds theTime numDecimals = (
		-- convert time value into seconds string
		local tps = 4800.0
		local secs = theTime.ticks / tps
		
		-- round off extra decimals but keep seconds
		-- not using formattedPrint to stay compatible to 3ds Max 8
		local dec = secs - (floor secs)			-- just decimal places
		local intsec = (secs - dec)	as integer 	-- just full seconds
		
		local divisor = 10^numDecimals
		decStr = ((ceil (dec*divisor))/divisor) as string	-- round off extra digits from decimals, maximum 6 decimals
		
		-- add extra zeros if needed to decimals (taking the leading "0." into account 
		if (decStr.count-2) < numDecimals then append decStr (subString "0000000000000000000000000" 1 (numDecimals - decStr.count + 2))
		
		((intsec as string) + (substring decStr 2 999) + " s")
	)

	fn installRenderCallbacks makeActive = (
		-- install render callbacks for render time calculation
				
		try (
			custAttributes.delete rootNode custCA
		) catch ( print "No CA found for deletion" )
		custAttributes.add rootNode custCA
		
		-- remove all infoOverlay callbacks...
		callbacks.removeScripts id:#infoOverlayCB_persistent
		if makeActive then (
			callbacks.addScript #preRenderFrame "try(rootNode.renderTime.preRender())catch()" id:#infoOverlayCB_persistent
			callbacks.addScript #postRenderFrame "try(rootNode.renderTime.postRender())catch()" id:#infoOverlayCB_persistent
		)
		
/*		local preRenderStr = "global infoOverlayGlobal_startRenderTime = timestamp()"
		local postRenderStr = "global infoOverlayGlobal_endRenderTime = timestamp()"
		
		-- remove all infoOverlay callbacks...
		callbacks.removeScripts id:#infoOverlayCB_persistent
		print "callbacks removed"
		if makeActive then (
			-- ... and install new ones if wanted
			callbacks.addscript #preRenderFrame preRenderStr id:#infoOverlayCB_persistent:true
			callbacks.addscript #postRenderFrame postRenderStr id:#infoOverlayCB_persistent:true
			print "callbacks installed"
		) */
	)

	fn getCameraName = (
		-- get camera name for rendered view
		local t = viewport.getType()
		local str = case t of (
			#view_top: "Top"
			#view_bottom: "Bottom"
			#view_right: "Right"
			#view_left: "Left"
			#view_front: "Front"
			#view_back: "Back"
			#view_persp_user: "Perspective"
			#view_iso_user: "User"
			#view_camera: (viewport.getcamera()).name
			#view_spot: "Light"
			#view_shape: "Shape"
			#view_grid: "Grid"
			default: "undefined"
		)	
	)
	
	fn clampColorMax c mx = (
		-- ensure that each channel in color 'c' is not larger than 'mx'
		if c.r > mx then c.r = mx 
		if c.g > mx then c.g = mx 
		if c.b > mx then c.b = mx
		if c.a > mx then c.a = mx
		c
	)

	fn clampColorMin c mn = (
		-- ensure that each channel in color 'c' is not smaller than 'mn'
		if c.r < mn then c.r = mn 
		if c.g < mn then c.g = mn 
		if c.b < mn then c.b = mn
		if c.a < mn then c.a = mn
		c
	)
	
	fn overlayImage bm fname px py mode op bmpscale = (
		-- composite image from file 'fname' into bitmap 'bm', scaling it by bmpscale, at position 'px'/'py' using transfer mode 'mode'
		
		-- 3ds Max 2008: this should use pasteBitmap for speed
		
		cont = true
		
		try (
			logo_bmp = openBitmap fname
		) catch (
			format "infoOverlay: Error opening bitmap %!\n" fname
			cont = false
		)
		if cont and (classof logo_bmp)==BitMap then (
			-- resize bitmap if needed
			-- for better quality, this could use a bitmapTexture map and renderMap
			if bmpscale!=1.0 then (
				if bmpscale>=0.0 then (
					try (
						local tmpBmp = bitmap (logo_bmp.width*bmpscale) (logo_bmp.height*bmpscale)
						copy logo_bmp tmpBmp
						logo_bmp = tmpBmp
						close tmpBmp
					) catch (
						format "infoOverlay: error scaling overlay bitmap!\n"
					)
				)
			)
			
			logo_w = logo_bmp.width - 1
			logo_h = logo_bmp.height - 1
			orig_w = bm.width - 1
			orig_h = bm.height - 1
			
			-- Note: pixel[0,0] is at the top-left of a bitmap
			
			logoY      = (amax -py 0)				-- ROW where to START reading pixels from logo bitmap
			logoYmax   = (amin (orig_h-py) logo_h)	-- row where to STOP reading pixels from logo bitmap
			logoX      = (amax -px 0)				-- COLUMN where to start reading pixels from logo bitmap
			logoXmax   = (amin (orig_w-px) logo_w)
			logoXCount = logoXmax - logoX + 1		-- Number of pixels to read from logo for each row

			if (logoYmax - logoY + 1)<1 or logoXCount < 1 then (
				format "infoOverlay: Image outside canvas, nothing to draw\n"
				return false
			)

			origX     = (amax 0 px)					-- Column where to start writing pixels to render bitmap
			
			for v = logoY to logoYmax do (
			-- for each row in the logo bitmap that is visible
				logo_pixels = getPixels logo_bmp [logoX, v] logoXCount
				
				origY           = py+v
				original_pixels = getPixels bm [origX, origY] logoXCount
				
				for h = 1 to logoXCount do (
					newCol = original_pixels[h]
					case mode of (
						1: ( -- Normal
							newCol = logo_pixels[h]
							)
						2: ( -- Alpha Compositing, wants un-pre-multiplied data
							newCol = original_pixels[h] * ((255-logo_pixels[h].alpha)/255.0) + logo_pixels[h]*(logo_pixels[h].alpha/255.0)
							)
						3: ( -- Add
							newCol = clampColorMax (original_pixels[h] + logo_pixels[h]) 255
							)
						4: ( -- Subtract
							newCol = clampColorMin (original_pixels[h] - logo_pixels[h]) 0
							)
						5: ( -- Multiply (white = neutral)
							newCol = clampColorMax (original_pixels[h] * logo_pixels[h]) 255
							)
						6: ( -- Screen (black = neutral)
							newCol = white - (white - logo_pixels[h]) * (white - original_pixels[h])
							)
						7: ( -- Stamp (grey = neutral)
							newCol = clampColorMax (original_pixels[h] + 2 * logo_pixels[h] - white) 255
							)
						8: ( -- Overlay
							newCol = clampColorMax (clampColorMin (original_pixels[h] + (logo_pixels[h] - (Color 128 128 128))) 0) 255
							)
						9: ( -- Luminosity
							newCol.value = logo_pixels[h].value
							)
					) -- end: case
					original_pixels[h] = original_pixels[h]*(1.0-(op/100.0)) + newCol*(op/100.0)
				) -- end: for h
				setPixels bm [origX, origY] original_pixels
			) -- end: for v
			true
		) -- end: if cont
	) -- end: fn overlayImage

	fn drawHLine bm x1 y1 x2 c = (
	-- draw horizontal line with color 'c' into bitmap 'bm' from pixels x1/y1 to x2/y1
		cols = for i = 0 to (x2-x1) collect c
		setPixels bm [x1, y1] cols
	)
	
	fn drawVLine bm x1 y1 y2 c = (
	-- draw vertical line with color 'c' into bitmap 'bm' from pixels x1/y1 to x1/y2
		for i = y1 to y2 do (
			setPixels bm [x1,i] #(c)	-- set single pixel :(
		)
	)

	-----------------------------------------

	parameters main rollout:params (
		useFrame type:#boolean default:true ui:useFrameCheck
		useSMPTE type:#boolean default:false -- ui:useSMPTECheck
		
		timeFormat type:#integer default:1 ui:timeFormatList		-- 1: frames, 2: SMTPE, 3: Seconds
		framePad type:#integer default:4 ui:framePadSpin
		
		useFName type:#boolean default:true ui:useFNameCheck
		shortFName type:#boolean default:false ui:shortFNameCheck
		useDate type:#boolean default:true ui:useDateCheck
		useUser type:#boolean default:true ui:useUserCheck

		useFrameBorder type:#boolean default:false ui:useFrameBorderCheck
		hFrameDim type:#integer default:10 ui:hFrameSpin
		frameLock type:#boolean default:true ui:frameLockCheck
		vFrameDim type:#integer default:10 ui:vFrameSpin
		borderScale type:#integer default:1 ui:borderScaleRB animateable:false
		borderCol type:#color default:(color 64 64 64) ui:frameColPick
		dimFrame type:#boolean default:false ui:dimFrameCheck
		drawCenter type:#boolean default:false ui:drawCenterCheck 
		drawRuleOfThirds type:#boolean default:false ui:drawThirdsCheck

		fontScale type:#integer default:1 ui:scaleSpin
		dimBG type:#boolean default:true ui:dimBGCheck
		alphaBlend type:#boolean default:true ui:blendCheck
		
		useExtra type:#boolean default:false ui:useExtraCheck
		extraString type:#string default:"frameRate" ui:extraString
		extraScript type:#boolean default:true ui:extraScriptCheck

		useExtraTop type:#boolean default:false ui:useExtraTopCheck
		extraTopString type:#string default:"(c) 2008" ui:extraTopString
		-- set x/y pos to center of current res
		extraTopPosX type:#integer default:(renderWidth/2) ui:extraTopPosXSpin
		extraTopPosY type:#integer default:(renderHeight/2) ui:extraTopPosYSpin

		useRendertime type:#boolean default:false ui:useRendertimeCheck
		useCamName type:#boolean default:false ui:useCamNameCheck
		
		-- image stuff
		useImage type:#boolean ui:useImageCheck default:false
		imageFName type:#string ui:imageNameTxt default:((getDir #image) + "\\logo.tga")
		image_x type:#integer ui:imagepos_x_spin default:0
		image_y type:#integer ui:imagepos_y_spin default:0
		imgOpacity type:#integer ui:opacity_spin default:100
		transfer_mode type:#integer ui:transfer_mode_list default:1
		imgScale type:#float ui:imgScaleSpin default:1.0 
	)
		
	rollout params "Overlay Settings" width:320 height:568
	(

		GroupBox grp1 "Overlay Items" pos:[4,4] width:310 height:140
		checkbox useFrameCheck "Frame" pos:[8,23] width:53 height:15
		label lt "Format:" pos:[90,24] width:35 height:13
		dropdownList timeFormatList "" pos:[135,21] width:90 height:21 items:#("Framenumber", "SMTPE", "seconds")
		spinner framePadSpin "Pad " pos:[240,23] width:69 height:16 range:[1,15,4] type:#integer fieldwidth:40				
		checkbox useFNameCheck "File Name" pos:[8,43] width:71 height:15
	
		checkbox shortFNameCheck "Short Name" pos:[90,43] width:80 height:15
		checkbox useDateCheck "Date && Time" pos:[8,63] width:85 height:15
		checkbox useUserCheck "User && Machine Name" pos:[8,83] width:128 height:15
		checkbox useRendertimeCheck "Render Time" pos:[8,103] width:85 height:15
		checkbox useCamNameCheck "Camera Name" pos:[8,123] 
		
		GroupBox grp2 "Safe Frame" pos:[4,149] width:310 height:80
		checkbox useFrameBorderCheck "Draw Frame" pos:[8,165] width:81 height:15
		spinner hFrameSpin "H: " pos:[104,165] width:51 height:16 range:[1,1000,10] type:#integer fieldwidth:40
		checkbutton frameLockCheck "L" pos:[160,176] width:14 height:18 enabled:true toolTip:"Lock V to H"
		radiobuttons borderScaleRB "" pos:[190,165] width:136 height:16 labels:#("Percent", "Pixels") columns:2
		spinner vFrameSpin "V: " pos:[104,186] width:51 height:16 enabled:false range:[1,1000,10] type:#integer fieldwidth:40
		colorPicker frameColPick "Frame Color: " pos:[190,183] width:106 height:20 alpha:false
		checkbox dimFrameCheck "Mask Frame" pos:[8,186] width:82 height:15
		
		checkbox drawCenterCheck "Center Cross" pos:[8,208] width:82 height:15 enabled:true
		checkbox drawThirdsCheck "Rule of Thirds" pos:[100,208] width:85 height:15 enabled:true

		GroupBox grp3 "Additional Text" pos:[4,250] width:310 height:65
		checkbox useExtraCheck "Bottom" pos:[8,269] width:53 height:15
		edittext extraString "" pos:[62,270] width:208 height:17 enabled:false
		checkbutton extraScriptCheck "MXS" pos:[275,269] width:30 height:21 enabled:false toolTip:"Evaluate text as MAXScript expression"	
		
		checkbox useExtraTopCheck "Free" pos:[8,292] width:50 height:15
		edittext extraTopString "" pos:[62,292] width:125 height:17 enabled:false   -- width:217
		spinner extraTopPosXSpin "x " range:[1,100000,1] type:#integer fieldwidth:35 pos:[193,292] enabled:false
		spinner extraTopPosYSpin "y " range:[1,100000,1] type:#integer fieldwidth:35 pos:[250,292] enabled:false

		GroupBox grp4 "Text Display Options" pos:[4,320] width:310 height:61
		spinner scaleSpin "Font Scale: " pos:[10,339] width:99 height:16 range:[1,10,1] type:#integer fieldwidth:30
		checkbox dimBGCheck "Dim Text Background" pos:[133,340] height:15
		checkbox blendCheck "Alpha Blend (no scale)" pos:[133,360] height:15

		GroupBox grp5 "Image Overlay" pos:[4,386] width:310 height:104
		checkbox useImageCheck "Use" pos:[8,404] height:15
		edittext imageNameTxt "" pos:[48,403] width:235 height:19 enabled:false
		button imageNameBtn "..." pos:[292,403] width:18 height:19 enabled:false tooltip:"Click to browse for image file"
		spinner imgScaleSpin "Scale: " pos:[17,428] width:96 height:16 enabled:false fieldwidth:35 range:[0,50,1]
		spinner imagepos_x_spin "X Pos: " pos:[17,448] width:96 height:16 enabled:false range:[-4000,4000,0] type:#integer fieldwidth:35
		spinner imagepos_y_spin "Y Pos: " pos:[17,470] width:96 height:16 enabled:false range:[-4000,4000,0] type:#integer fieldwidth:35 across:3
		dropdownList transfer_mode_list "Transfer mode" pos:[120,446] width:100 height:40 enabled:false items:#("Normal", "Alpha Compositing", "Add", "Subtract", "Multiply", "Screen", "Stamp", "Overlay", "Luminosity")
		spinner opacity_spin "Opacity" pos:[231,468] width:75 height:16 enabled:false range:[0,100,100] type:#integer
	
		on useImageCheck changed state do (
			imageNameBtn.enabled = imageNameTxt.enabled = imagepos_x_spin.enabled = imagepos_y_spin.enabled = transfer_mode_list.enabled = opacity_spin.enabled = imgScaleSpin.enabled = state
		)
		
		on imageNameBtn pressed do (
			new_img = selectBitmap caption:"Select overlay image"
			if new_img != undefined then (
				imageNameTxt.text = imageNameBtn.tooltip = new_img.filename
			)
		)
		
		on useFnameCheck changed state do (
			shortFNameCheck.enabled = state
		)
		
		on useExtraCheck changed state do (
			extraString.enabled = extraScriptCheck.enabled = state
		)

		on useExtraTopCheck changed state do (
			extraTopString.enabled = extraTopPosXSpin.enabled = extraTopPosYSpin.enabled = state
		)
		
		on useFrameCheck changed state do (
			timeFormatList.enabled = state
			if state and ((timeFormatList.selection==1) or (timeFormatList.selection==3)) then framePadSpin.enabled = true else framePadSpin.enabled = false
		)

		on timeFormatList selected arg do (
			framePadSpin.enabled = if (arg==1) or (arg==3) then useFrameCheck.enabled else false
		)
				
		on useFrameBorderCheck changed state do (
			hFrameSpin.enabled = frameLockCheck.enabled = borderScaleRB.enabled = dimFrameCheck.enabled = state
			vFrameSpin.enabled = state and not frameLockCheck.checked
		)
		
		on frameLockCheck changed state do (
			vFrameSpin.enabled = not state
			if state then vFrameSpin.value = hFrameSpin.value
		)
		
		on hFrameSpin changed val do (
			if frameLockCheck.checked then vFrameSpin.value = val
		)
		
		on useRendertimeCheck changed state do (
			installRenderCallbacks state
		)
				
		on params open do (			
			-- restore GUI enabled/disabled values
			extraString.enabled = useExtra
			extraScriptCheck.enabled = useExtra
			extraTopPosXSpin.enabled = extraTopPosYSpin.enabled = useExtraTop
			
			timeFormatList.enabled = useFrame
			if useFrame then (
				framePadSpin.enabled = ((timeFormat==1) or (timeFormat==3))
			) else framePadSpin.enabled = false

			shortFNameCheck.enabled = useFName
			
			hFrameSpin.enabled = frameLockCheck.enabled = borderScaleRB.enabled = dimFrameCheck.enabled = useFrameBorder
			vFrameSpin.enabled = useFrameBorder and not frameLockCheck.checked
			
			imageNameBtn.enabled = imageNameTxt.enabled = imagepos_x_spin.enabled = imagepos_y_spin.enabled = transfer_mode_list.enabled = opacity_spin.enabled = imgScaleSpin.enabled = useImage
			
			-- disable all UI elements if plugin is not functional
			if functional!=true then for c in params.controls do c.enabled = false
		)
		
		on scaleSpin changed val do if val>1 then blendCheck.checked = true
	)
	
	rollout aboutro "About..." rolledUp:true (
		label l1 "infoOverlay render effect v0.9"
		label l2 "(c) 2006-08 M. Breidt"
	)
	
	------------------------------------------

	on create do (
		--print "on create"
		functional = checkFont()
	)
	
	on update do (
		format "Updating infoOverlay defintion from v1 to v2\n"
		if version == 1 then (
			if useSMPTE then timeFormat=2 else timeFormat=1
		)
	)
	
	on load do (
		--print "on load"
		functional = checkFont()
		-- install rendertime callbacks if parameter is set
		if useRendertime then installRenderCallbacks true
	)
	
	on deleted do (
		-- remove callbacks
		--print "deleted"
		installRenderCallbacks false
	)
	
	on apply bm do (
		--print "on apply"
		if functional==true then (
			--print "functional=true"
			if not alphaBlend then fontScale = 1
			
			if dimBG then (
				-- darken background in top and bottom text area
				local w = (gw.getTextExtent "H")*fontScale
				dimBackground bm (box2 0 0 (bm.width+1) (w.y+2))
				dimBackground bm (box2 0 (bm.height-w.y-2) (bm.width+1) bm.height)
			)
			
			if useFrameBorder then (
				-- draw frame border
				local x1, x2, y1, y2
				if borderScale==1 then (
					-- border dimensions in percentage
					x1 = bm.width * (hFrameDim/100.0)
					y1 = bm.height * (vFrameDim/100.0)
				) else (
					-- border dimensions in pixels
					x1 = hFrameDim
					y1 = vFrameDim
				)
				x2 = bm.width - x1
				y2 = bm.height - y1
				
				if dimFrame then (
					-- dim top and bottom
					dimBackground bm (box2 0 0 (bm.width+1) y1 )
					dimBackground bm (box2 0 (y2+1) (bm.width+1) y1 )
					-- dim left and right
					dimBackground bm (box2 0 y1 (x1+1) ((bm.height-2*y1)+1) )
					dimBackground bm (box2 x2 y1 (x1+1) ((bm.height-2*y1)+1) )
				)
				
				-- draw horizontal lines
				drawHLine bm x1 y1 x2 borderCol
				drawHline bm x1 y2 x2 borderCol 
				-- draw vertical lines
				drawVLine bm x1 y1 y2 borderCol
				drawVline bm x2 y1 y2 borderCol 
			)
			
			if drawCenter then (
				local centerSize = 10
				-- draw image center cross
				hx1 = bm.width / 2 - centerSize
				hy1 = bm.height / 2
				hx2 = bm.width / 2 + centerSize
				
				vx1 = bm.width / 2
				vy1 = bm.height / 2 - centerSize
				vy2 = bm.height / 2 + centerSize
				
				-- draw first cross with inverted colors
				-- drawHLine bm hx1 (hy1+1) hx2 (white - borderCol)
				-- drawVline bm (vx1+1) vy1 vy2 (white - borderCol)
				
				drawHLine bm hx1 hy1 hx2 borderCol
				drawVline bm vx1 vy1 vy2 borderCol
			)
			
			if drawRuleOfThirds then (
				for x = 1 to 2 do (
					drawVline bm (x * (bm.width-1) / 3) 0 (bm.height-1) borderCol
				)
				for y = 1 to 2 do (
					drawHline bm 0 (y * (bm.height-1) / 3) (bm.width-1) borderCol
				)
			)
			
			if useImage then (
				-- overlay image
				if imgOpacity>0 then overlayImage bm imageFName image_x image_y transfer_mode imgOpacity imgScale
			)
			
			----------------------- printing text ----------------
			local txt=""
			if useFrame then (
				-- print frame time/number in lower left corner
				local myTime = case timeFormat of (
					1: (padNum (currentTime.frame as integer) framePad)
					2: (convertTime_SMTPE currentTime)
					3: (convertTime_seconds currentTime framePad)
					default: ""
				)
				txt = "t=" + (myTime as string)
				printString bm (getAlignedPos bm #left #bottom txt fontScale) txt alphaBlend fontScale
			)
			if useDate then (
				-- print date and time in lower right corner
				txt = localTime
				printString bm (getAlignedPos bm #right #bottom txt fontScale) txt alphaBlend fontScale
			)
			if useFName then (
				-- print scene file name in upper left corner
				txt = if shortFName then maxFilename else (maxFilepath + maxFilename)
				local dim = (gw.getTextExtent txt)*fontScale
				if dim.x>(200*fontScale) then txt = ("...\\" + maxFilename)
				if txt.count==0 then txt ="<none>"
				printString bm (getAlignedPos bm #left #top txt fontScale) txt alphaBlend fontScale
			)
			if useUser then (
				-- print user and machine name in upper right corner
				txt = (sysInfo.userName + "@" + sysInfo.computername)
				printString bm (getAlignedPos bm #right #top txt fontScale) txt alphaBlend fontScale
			)
			if useExtra then (
				-- print additional user text in lower center, possibly as MXS code
				txt = extraString
				if extraScript then (
					try ( txt = (execute txt) as string ) catch ( txt="<error>" )
				)
				printString bm (getAlignedPos bm #center #bottom txt fontScale) txt alphaBlend fontScale
			)
			if useExtraTop then (
				-- print additional user text in top center
--				printString bm (getAlignedPos bm #center #top extraTopString fontScale) extraTopString alphaBlend fontScale
				printString bm [extraTopPosX, extraTopPosY] extraTopString alphaBlend fontScale
			)
			if useRendertime then (
				-- print render time info from callbacks into top center
				
				/*
				-- hack with execute to get access to global variables
				global infoOverlayGlobal_startRenderTime = execute "infoOverlayGlobal_startRenderTime"
				global infoOverlayGlobal_endRenderTime = execute "infoOverlayGlobal_endRenderTime"
				
				if (infoOverlayGlobal_startRenderTime != undefined) and 
				(infoOverlayGlobal_endRenderTime != undefined) then (
					txt = (((infoOverlayGlobal_endRenderTime - infoOverlayGlobal_startRenderTime)/1000.0) as string) + " sec."
				) else (
					txt = "time not available - start = '"+ (infoOverlayGlobal_startRenderTime as string) +"' end = '"+ (infoOverlayGlobal_endRenderTime as string) +"'"
					print "infoOverlay: render time globals not defined"
				) */
				
				txt = if isProperty rootNode #renderTime then (((rootNode.renderTime.renderTime/1000.0) as string) + " sec.") else "renderTime custom attribute not found!"
				printString bm (getAlignedPos bm #center #top txt fontScale) txt alphaBlend fontScale				
			)
			if useCamName then (
				-- print camera name in bottom center
				txt = getCameraName()
				printString bm (getAlignedPos bm #center #bottom txt fontScale) txt alphaBlend fontScale
			)
			gc() -- light:true
		)
	)
)
