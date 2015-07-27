----------------------------------------------------------------------------------------------------------------------------
--plugin LPM_RenderSwitcher
----------------------------------------------------------------------------------------------------------------------------
plugin material LPM_RenderSwitcher
name:"LPM Render Switcher"
classID:#(0x276f75b6, 0x26693070)
extends:Shellac
replaceUI:true
(
	parameters main rollout:params
	(
		scanlineMat type:#material ui:scanlineUI
		mentalRayMat type:#material ui:mentalRayUI
		vrayMat type:#material ui:vrayUI
		fallBackInt type:#integer ui:renderFallBack default:1
		backUpInt type:#integer default:1
		on scanlineMat set value do if(fallBackInt==1) then delegate.shellacMtl1=value
		on mentalRay set value do if(fallBackInt==2) then delegate.shellacMtl1=value
		on vrayMat set value do if(fallBackInt==3) then delegate.shellacMtl1=value
		on fallBackInt Set value do 
		(
			case value of
			(
				1: delegate.shellacMtl1=scanlineMat
				2: delegate.shellacMtl1=mentalRayMat
				3: delegate.shellacMtl1=vrayMat
			)			
		)
	)
	
	rollout params "LPM Render Switcher"
	(
		label sLabel "Scanline" pos:[6,8] width:41 height:13
		materialButton scanlineUI "" pos:[70,4] width:200 height:21 
		label mLabel "Mental Ray" pos:[5,29] width:54 height:13
		materialButton mentalRayUI "" pos:[70,26] width:200 height:21 
		label vLabel "Vray" pos:[6,51] width:21 height:13
		materialButton vrayUI "" pos:[70,48] width:200 height:21 

		radiobuttons renderFallBack "Render Fallback" pos:[4,76] width:77 height:62 labels:#("Scanline", "Mental Ray", "Vray")
		GroupBox grp1 "Note" pos:[3,115] width:155 height:63
		label lbl1 "When LPM is not used to render the Render Fallback will be used as the material." pos:[12,130] width:133 height:45
	)
	
	on create do
	(
		scanlineMat=standard()
		theOldMat=meditMaterials[activeMeditSlot]
		print theOldMat
		
		ans=false
		
		if(MatEditor.isOpen() and (superclassof theOldMat) == material) then
			ans=queryBox "Keep Old Material?"
		if ans then scanlineMat=theOldMat
		
		mentalRayMat=standard()
		vrayMat=standard()
		delegate.shellacMtl1=scanlineMat
		delegate.shellacMtl2=undefined
	)		
)