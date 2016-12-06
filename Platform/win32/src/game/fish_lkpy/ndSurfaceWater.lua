-- 水表面节点
local NDSurfaceWater = class("NDSurfaceWater", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDSurfaceWater:onCreate()
	--创建动画节点
	local ndMovie = cc.CSLoader:createNode("res/Game/Lkpy/Layer_Surface.csb")
	self:addChild(ndMovie)

	--创建时间线
	local antAction = cc.CSLoader:createTimeline("res/Game/Lkpy/Layer_Surface.csb")
	if antAction~=nil then
		ndMovie:runAction(antAction)
		--antAction:play("surfacewater", true)
		antAction:gotoFrameAndPlay(0, true)
		LCLog("水表面添加动画时间线,并播放动画！")

		--antAction:setCurrentFrame(2)

		local spd = antAction:getTimeSpeed()
		local dur = antAction:getDuration()
		local sf = antAction:getStartFrame()
		local ef = antAction:getEndFrame()
		LCLog("spd="..tostring(spd).." dur="..tostring(dur).." sf="..tostring(sf).." ef="..tostring(ef))

		local run = antAction:isPlaying()
		local cur = antAction:getCurrentFrame()
		LCLog("running="..tostring(run).." cur="..tostring(cur))
	end		

	ndMovie:setPosition(0, 0)

	LCLog("self="..tostring(self:isVisible()).." ndMovie="..tostring(ndMovie:isVisible()))
										
	local spr = ndMovie:getChildByName("waterWave")
	LCLog("查询水资源")
	if spr~=nil then
		LCLog("spr="..tostring(spr:isVisible()))
	else
		LCLog("没有找到目标【水资源】")
	end
end

--进入游戏
function NDSurfaceWater:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDSurfaceWater:onExit()
    cc.Node:onExit()
end

return NDSurfaceWater