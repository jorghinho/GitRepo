-- global SMTD_RegionRendering

plugin simpleManipulator DLRegionManipulator
name:"RegionManip"
classID:#(0x7c427c83, 0xc28852d)
category:"Manipulators"
invisible:true
(
	local greenColor =  colorMan.getColor #manipulatorsActive
	local redColor =    colorMan.getColor #manipulatorsSelected
	local yellowColor = colorMan.getColor #manipulatorsInactive

	parameters main rollout:paramRollout
	( 
		cornerX type:#float animatable:false ui:spn_cornerX default:0.0
		cornerY type:#float animatable:false ui:spn_cornerY default:0.0
		cornerX2 type:#float animatable:false ui:spn_cornerX2 default:0.0
		cornerY2 type:#float animatable:false ui:spn_cornerY2 default:0.0
	)

	rollout paramRollout "Region"
	(
		Spinner  spn_cornerX "X:"	range:[0,1,0]  type:#float
		Spinner  spn_cornerY "Y:"	range:[0,1,0]  type:#float
		Spinner  spn_cornerX2 "X2:"	range:[0,1,0]  type:#float
		Spinner  spn_cornerY2 "Y2:"	range:[0,1,0]  type:#float
	)

	on canManipulate target  return (classOf target) == DLRegionManipulator
	tool create
	(
		on mousePoint click do
		   case click of
		   (
			  1: #stop 
		   )
	)

	on updateGizmos do
	(
		this.clearGizmos()
		if (target != undefined) then 
		(
		   this.cornerX= target.cornerX
		   this.cornerY= target.cornerY
		   this.cornerX2= target.cornerX2
		   this.cornerY2= target.cornerY2
		   unselColor  = greenColor
		) 
		else
		(
		   unselColor  = yellowColor
		)

		-- These flags are used for all the gizmos
		local flags = (gizmoUseScreenSpace + gizmoActiveViewportOnly)

		local xSize = gw.getWinSizeX()-1
		local ySize = gw.getWinSizeY()-1
		
		local vpAspect = gw.getWinSizeX() as float / gw.getWinSizeY() as float
		local rAspect = RenderWidth as float / RenderHeight * renderPixelAspect
		
		if rAspect > vpAspect then
		(
			ySize = gw.getWinSizeX() / rAspect
			xDiff = 0
			yDiff = (gw.getWinSizeY() - ySize)/2
		)	
		else
		(
			xSize = gw.getWinSizeY() * rAspect
			xDiff = 0.5*(gw.getWinSizeX() - xSize)
			yDiff = 0
		)	
		
		local corner1 = [cornerX*xSize+xDiff,cornerY*ySize+yDiff,0]
		local corner2 = [cornerX2*xSize+xDiff,cornerY*ySize+yDiff ,0]
		local corner3 = [cornerX2*xSize+xDiff,cornerY2*ySize+yDiff ,0]
		local corner4 = [cornerX*xSize+xDiff,cornerY2*ySize+yDiff ,0]
		
		-- Create a polyline gizmo 0
		local giz = manip.makeGizmoShape()
		giz.AddPoint corner1
		giz.AddPoint corner2
		this.addGizmoShape giz flags unselColor redColor

		-- Create a polyline gizmo 1
		local giz = manip.makeGizmoShape()
		giz.AddPoint corner2
		giz.AddPoint corner3
		this.addGizmoShape giz flags unselColor redColor

		-- Create a polyline gizmo 2
		local giz = manip.makeGizmoShape()
		giz.AddPoint corner3
		giz.AddPoint corner4
		this.addGizmoShape giz flags unselColor redColor

		-- Create a polyline gizmo 3
		local giz = manip.makeGizmoShape()
		giz.AddPoint corner4
		giz.AddPoint corner1
		this.addGizmoShape giz flags unselColor redColor

		--Gizmo 4		
		this.addGizmoMarker #circle [((cornerX+cornerX2)/2)*xSize+xDiff,((cornerY+cornerY2)/2)*ySize+yDiff,0] flags unselColor redColor --4
		
--		local theMesh = manip.makeBox [((cornerX+cornerX2)/2)*xSize+xDiff,((cornerY+cornerY2)/2)*ySize+yDiff,0] (cornerX2-cornerX) (cornerY2-cornerY) 0 3 3 1 
--		this.addGizmoMesh theMesh flags unselColor redColor
--		delete theMesh
		
		this.addGizmoMarker #bigBox corner1 flags unselColor redColor --5
		this.addGizmoMarker #bigBox corner2 flags unselColor redColor --6
		this.addGizmoMarker #bigBox corner3 flags unselColor redColor --7
		this.addGizmoMarker #bigBox corner4 flags unselColor redColor --8
		
		-- return an empty string so no tool tip is displayed
		return ""
	)

	-- mouseMove is called on every mouse move when dragging the manip
	-- It needs to convert the mouse position 'm' into a new value for the slider
	on mouseMove m which do
	(
		local xSize = gw.getWinSizeX()-1
		local ySize = gw.getWinSizeY()-1
		
		local vpAspect = gw.getWinSizeX() as float / gw.getWinSizeY() as float
		local rAspect = RenderWidth as float / RenderHeight * renderPixelAspect
		
		if rAspect > vpAspect then
		(
			ySize = gw.getWinSizeX() / rAspect
			yDiff = 0.5 * (gw.getWinSizeY() - ySize)
			xDiff = 0
		)	
		else
		(
			xSize = gw.getWinSizeY() * rAspect
			xDiff = 0.5 * (gw.getWinSizeX() - xSize)
			yDiff = 0
		)		
		
		case which of
		(
			0:
			(
				local y = (m.y-yDiff) / ySize
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if y < 0 do y = 0
					if y > cornerY2 do y = cornerY2
				)
				target.cornerY = y
			)
			1:
			(
				local x = (m.x-xDiff) / xSize
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if x > 1.0 do x = 1.0
					if x < cornerX do x = cornerX
				)
				target.cornerX2 = x
			)	
			2:
			(
				local y = (m.y-yDiff) / ySize
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if y > 1.0 do y = 1.0
					if y < cornerY do y = cornerY
				)
				target.cornerY2 = y
			)		
			3:
			(
				local x = (m.x-xDiff) / xSize
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if x < 0 do x = 0
					if x > cornerX2 do x = cornerX2
				)
				target.cornerX = x
			)		
			4:
			(
				local width = cornerX2 - cornerX
				local height = cornerY2 - cornerY
				local x = (m.x-xDiff) / xSize
				local y = (m.y-yDiff) / ySize
				
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if x + width/2 > 1.0 do x = 1.0 - width/2
					if y + height/2 > 1.0 do y = 1.0 - height/2
					if x - width/2 < 0.0 do x = width/2
					if y - height/2 < 0.0 do y = height/2
				)
				
				target.cornerX = x-width/2
				target.cornerX2 = x+width/2
				target.cornerY = y-height /2
				target.cornerY2 = y+height /2
			)		
			5:
			(
				local x = (m.x-xDiff) / xSize
				local y = (m.y-yDiff) / ySize
				
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if x < 0 do x = 0
					if y < 0 do y = 0
					if x > cornerX2 do x = cornerX2
					if y > cornerY2 do y = cornerY2
				)
				
				target.cornerX = x
				target.cornerY = y
			)
			6:
			(
				local x = (m.x-xDiff) / xSize
				local y = (m.y-yDiff) / ySize
				
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if x > 1.0 do x = 1.0
					if y < 0 do y = 0
					if x < cornerX do x = cornerX
					if y > cornerY2 do y = cornerY2
				)
				
				target.cornerX2 = x
				target.cornerY = y
			)	
			7:
			(
				local x = (m.x-xDiff) / xSize
				local y = (m.y-yDiff) / ySize
				
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if x > 1.0 do x = 1.0
					if y > 1.0 do y = 1.0
					if x < cornerX do x = cornerX
					if y < cornerY do y = cornerY
				)
				
				target.cornerX2 = x
				target.cornerY2 = y
			)	
			8:
			(
				local x = (m.x-xDiff) / xSize
				local y = (m.y-yDiff) / ySize
				
				if SMTD_RegionRendering.ddl_regionType.selected != "Blowup" then
				(
					if x < 0 do x = 0
					if y > 1.0 do y = 1.0
					if x > cornerX2 do x = cornerX2
					if y < cornerY do y = cornerY
				)
				
				target.cornerX = x
				target.cornerY2 = y
			)	
		)
		try
		(
			SMTD_RegionRendering.updateFromRegionGizmo()
--			SMTD_RegionRendering.spn_regionLeft.changed (SMTD_RegionRendering.spn_regionLeft.value = ceil (target.cornerX*RenderWidth) )
--			SMTD_RegionRendering.spn_regionTop.changed (SMTD_RegionRendering.spn_regionTop.value = ceil (target.cornerY*RenderHeight))
--			SMTD_RegionRendering.spn_regionWidth.changed (SMTD_RegionRendering.spn_regionWidth.value = ceil ((target.cornerX2-target.cornerX)*RenderWidth))
--			SMTD_RegionRendering.spn_regionHeight.changed (SMTD_RegionRendering.spn_regionHeight.value = ceil ((target.cornerY2-target.cornerY)*RenderHeight))
		)catch()
		
	)
)
