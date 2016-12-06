-- 背景视图节点
local NDViewBG = class("NDViewBG", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDViewBG:onCreate()
	self.ndViewBG = nil
	self.ndTmpBG = nil
	self.indexBG = 1
	self.csbViewBG = {
		"Game/Lkpy/Layer_ViewBG1.csb",
		"Game/Lkpy/Layer_ViewBG2.csb",
		"Game/Lkpy/Layer_ViewBG3.csb",
		"Game/Lkpy/Layer_ViewBG4.csb",
		"Game/Lkpy/Layer_ViewBG5.csb",
	}

	--创建底图
	self.ndViewBG = cc.CSLoader:createNode(self.csbViewBG[self.indexBG])
	self:addChild(self.ndViewBG)
end

--进入游戏
function NDViewBG:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDViewBG:onExit()
    cc.Node:onExit()
end

--潮水来袭
function NDViewBG:TurnBGByTideWater()
	--设置索引
	self.indexBG = self.indexBG + 1
	if self.indexBG > 5 then self.indexBG = 1 end

	--创建新底图
	self.ndTmpBG = cc.CSLoader:createNode(self.csbViewBG[self.indexBG])
	self:addChild(self.ndTmpBG)

	--启动动作
	self.ndTmpBG:setPosition(cc.p(1366,0))
	self:fly_func(self.ndTmpBG, 0, 0, 3)
end

--------------------------------  
-- @param node 要移动的对象  
-- @param x 横向坐标  
-- @param y 纵向坐标  
-- end --  
function NDViewBG:fly_func(node, x, y, time)  
    if node then  
        local move = {}  
        move[#move + 1] = cc.MoveTo:create(time, cc.p(x, y))  
        move[#move + 1] = cc.CallFunc:create(function(event)  
            --清除节点
            self:removeChild(self.ndViewBG)
            self.ndViewBG = self.ndTmpBG
        end)  
  
        local sequence = transition.sequence(move)  
        node:runAction(sequence)  
    end  
end  

return NDViewBG