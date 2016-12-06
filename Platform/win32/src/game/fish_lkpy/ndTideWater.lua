-- 潮水节点
local NDTideWater = class("NDTideWater", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDTideWater:onCreate()
	LCLog("潮水类")
	--创建动画节点
	local ndMovie = cc.CSLoader:createNode("res/Game/Lkpy/Node_M_TideWater.csb")

	--创建潮水动画
	self.ndTideWater = cc.Node:create()
	self:addChild(self.ndTideWater)
	self.ndTideWater:addChild(ndMovie)
	self.ndTideWater:setVisible(false)

	--创建时间线
	local antAction = cc.CSLoader:createTimeline("res/Game/Lkpy/Node_M_TideWater.csb")
	if antAction~=nil then
		ndMovie:runAction(antAction)
		antAction:gotoFrameAndPlay(0, true)
		LCLog("潮水添加动画时间线")
	end	
end
--进入游戏
function NDTideWater:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDTideWater:onExit()
    cc.Node:onExit()
end

--潮水来袭
function NDTideWater:TurnBGByTideWater()
	--显示视图
	self.ndTideWater:setVisible(true)

	--启动动作
	self.ndTideWater:setPosition(cc.p(1366-100,0))
	self:fly_func(self.ndTideWater, 0-100, 0, 3)
end

--------------------------------  
-- @param node 要移动的对象  
-- @param x 横向坐标  
-- @param y 纵向坐标  
-- end --  
function NDTideWater:fly_func(node, x, y, time)  
    if node then  
        local move = {}  
        move[#move + 1] = cc.MoveTo:create(time, cc.p(x, y))  
        move[#move + 1] = cc.CallFunc:create(function(event)  
            --隐藏视图
			self.ndTideWater:setVisible(false)
			--LCLog("潮水动画关闭")
        end)  
  
        local sequence = transition.sequence(move)  
        node:runAction(sequence)  
    end  
end  

return NDTideWater