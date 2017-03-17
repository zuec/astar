---------------------------------------------------------------------------------------------
--[[
	LuAstar - Pathfinding A-Star Library For Lua
    Copyright (C) 2011.
	Written by Roland Yonaba - E-mail: roland[dot]yonaba[at]gmail[dot]com
	Demo Test File
--]]
----------------------------------------------------------------------------------------------


-- Creating Colors 
local WHITE = Color.new(255,255,255)
local GREEN = Color.new(0,255,0)
local GREY = Color.new(100,100,100)
local BLUE = Color.new(0,0,255)
local YELLOW = Color.new(255,255,0)

-- Cursor parameters
local x,y =100,100
local orderMove=false -- May the player move ?
local xInterval=30 -- Blocks X size
local yInterval=30 -- Blocks Y size

-- Player parameters
local player={x=0, y=0, xmove=0, ymove=0, speed=5, path={}, cur=1, pathLength=0, move=false }
player.img = Image.createEmpty(xInterval-1, yInterval-1)
player.img:clear(GREEN)

-- Defining the map
local map={}
	for i=1,(272/yInterval) do map[i]={}
		for j=1,(480/xInterval) do map[i][j]= 0 end
	end

-- Function for map grid rendering
local function drawGrid(map,xInterval,yInterval,color)
         local w=table.getn(map[1])
         local h=table.getn(map)
         for n=1,w do
             if n*xInterval<480 then
                screen:drawLine(n*xInterval,0,n*xInterval,h*yInterval,color)
             end
         end
         for n=1,h do
             if n*yInterval<272 then
                screen:drawLine(0,n*yInterval,w*xInterval,n*yInterval,color)
             end
         end
end

-- Function for blocks rendering
function drawBlock(map,xInterval,yInterval,color)
         local w=table.getn(map[1])
         local h=table.getn(map)
         for n=1,w do
             for i=1,h do
             	 if map[i][n]==1 then
             	    screen:fillRect((n-1)*xInterval+1, (i-1)*yInterval+1, xInterval-1, yInterval-1, color)
	     	 end
	     end
	 end
end

-- Loading the library
local Astar = require 'Lib.Astar'
Astar(map,1) -- Inits the library, sets the OBST_VALUE to 1
-- We set an area of 2 blocks around the final destination where another 
-- new final location will be picked in case final location is unreachabale
Astar:enableDiagonalMove()
Astar:setSearchDepth(2)

-- Main Loop
local oldpad = Controls.read()
while true do
	local pad = Controls.read()
	
	-- On wich block is the cursor ?
	local mapx=math.floor(x/xInterval)+1
	local mapy=math.floor(y/yInterval)+1
	
	local fX,fY,sX,sY
	
		-- Moves the cursor
		if pad:left() and x > 0 then x = x - 2 end
		if pad:right() and x < 480 then x = x + 2 end
		if pad:up() and y > 0 then y = y - 2 end
		if pad:down() and y < 272 then y = y + 2 end

		if pad~=oldpad then
			if pad:cross() then  -- We order the move
			orderMove=true
			fY = math.floor(y/yInterval)+1
			fX = math.floor(x/xInterval)+1
			sY = math.floor(player.y/yInterval)+1
			sX = math.floor(player.x/xInterval)+1
			Astar:setInitialNode(sX,sY)  -- sets initialNode
			Astar:setFinalNode(fX,fY)  -- sets finalNode
			end
			-- sets blocks walkable/unwalkable
			if pad:square() then
			map[mapy][mapx] = (map[mapy][mapx]==0 and 1 or 0)
			end
			if pad:start() then break  end  -- Exits demo
		end	
	
		if orderMove==true then
		player.path = Astar:getPath()   -- Computes and returns the path
			if player.path==nil then  
			orderMove=false
			end
			-- Moves the player
			if player.path~=nil then
				for k,v in ipairs(player.path) do
				print(v.x,v.y)
				end
			player.pathLength=table.getn(player.path)
			player.cur=1
			player.xmove=(player.path[player.cur].x*xInterval)-xInterval
			player.ymove=(player.path[player.cur].y*yInterval)-yInterval
			orderMove=false
			player.move=true
			end
		end

	-- Player Smooth animated Movement (for better visuals)
	if player.move==true then
		if player.xmove>player.x then
		player.x=player.x+player.speed
		elseif player.xmove<player.x then
		player.x=player.x-player.speed
		end
		if player.ymove>player.y then
		player.y=player.y+player.speed
		elseif player.ymove<player.y then
		player.y=player.y-player.speed
		end

		-- Custom accuracy for temporary target reaching
		if (math.abs(player.y-player.ymove)<3) and (math.abs(player.x-player.xmove)<3) and player.cur<player.pathLength then
		player.cur=player.cur+1
		player.xmove=(player.path[player.cur].x*xInterval)-xInterval
		player.ymove=(player.path[player.cur].y*yInterval)-yInterval
		end
		if (math.abs(player.y-player.ymove)<3) and (math.abs(player.x-player.xmove)<3) and player.cur>=player.pathLength then
		player.move=false
		player.cur = 0
		player.x = (player.path[player.pathLength].x*xInterval)-xInterval
		player.y = (player.path[player.pathLength].y*yInterval)-yInterval
		player.pathLength = 0
		player.path = {}
		end
	end
	
	-- Now we draw the entire scene
	screen:clear()
	drawGrid(map,xInterval,yInterval,GREY) -- we draw the grid
	drawBlock(map,xInterval,yInterval,BLUE) -- we draw all blocks
	screen:blit(player.x+1,player.y+1,player.img)  -- we draw the player
	-- we draw the cursor
	screen:drawLine(x-5, y, x+5, y, WHITE)
	screen:drawLine(x, y-5, x, y+5, WHITE)
	screen:print(290,240,'D-Pad: Move Cursor',YELLOW) 
	screen:print(290,250,'Square: Set an obstacle',YELLOW)
	screen:print(290,260,'Cross: Move!',YELLOW)
	screen.waitVblankStart()
	screen:flip()
	oldpad = pad
end