-- 背景视图节点
local NDViewBG = class("NDViewBG", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDViewBG:onCreate()
	self.ndViewBG = nil
	self.csbViewBG = "Game/Srnn/Layer_Game.csb"

	--创建底图
	self.ndViewBG = cc.CSLoader:createNode(self.csbViewBG)
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

return NDViewBG