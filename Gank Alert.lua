--[[ARGB(255,255,255,255) --White
    ARGB(255,0,255,0), -- Yellow
    ARGB(255,255,0,0), -- Red
    ARGB(255,0,0,255), -- Blue]]

function OnLoad()
    Print("Loaded")

	enemys = GetEnemyHeroes()
	menu = scriptConfig("Gank Alert", "gankalert")

	menu:addParam("range", "Max Range", SCRIPT_PARAM_SLICE, 5000,50,10000,0)
	menu:addParam("On", "Turn ON/OFF", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey('K'))
	menu:addSubMenu("Blacklist", "black")
	for _, v in pairs(enemys) do
		menu.black:addParam("bl"..v.charName,v.charName, SCRIPT_PARAM_ONOFF,false)
	end
	menu:addSubMenu("Visual", "visual")
	menu.visual:addParam("wide", "Line width", SCRIPT_PARAM_SLICE, 4, 1, 8, 0)
	menu.visual:addParam("text", "Text Size", SCRIPT_PARAM_SLICE, 20, 1, 40, 0)
	menu.visual:addParam("lineonly", "Draw Lines only", SCRIPT_PARAM_ONOFF,false)
end

function Print(message)
        print("<font color=\"#8affff\"><b>Gank Alert:</font> </b><font color=\"#FFFFFF\">".. message.."</font>")
end

function CalcVector(source,target)
	local V = Vector(source.x, source.y, source.z)
	local V2 = Vector(target.x, target.y, target.z)
	local vec = V-V2
	local vec2 = vec:normalized()
	return vec2
end

function OnDraw()

	if not enemys or not menu or not menu.On then return end
	for _,v in pairs(enemys) do
    if GetDistance(v) > 4001 then
			color = ARGB(255, 0, 255, 0)
		elseif GetDistance(v) > 2500  then
			color = ARGB(255, 255, 215, 0)
		elseif GetDistance(v) < 2500  then
			color = ARGB(255,255,0,0)
		end	
		if v and v.valid and not v.dead and v.visible and not menu.black["bl"..v.charName] and GetDistance(v) <= menu.range then
			DrawLine3D2(v.x,v.y,v.z,myHero.x,myHero.y,myHero.z,menu.visual.wide,color)

			local V = CalcVector(myHero,v)*-250
  if not menu.visual.lineonly then
			DrawText3D(v.charName..": "..math.round(GetDistance(v,myHero)),V.x+myHero.x,V.y+myHero.y,V.z+myHero.z,menu.visual.text,color) end
		end
	end
end

function DrawLine3D2(x1, y1, z1, x2, y2, z2, width, color)
    local p = WorldToScreen(D3DXVECTOR3(x1, y1, z1))
    local px, py = p.x, p.y
    local c = WorldToScreen(D3DXVECTOR3(x2, y2, z2))
    local cx, cy = c.x, c.y
    DrawLine(cx, cy, px, py, width or 1, color or 4294967295)
end
