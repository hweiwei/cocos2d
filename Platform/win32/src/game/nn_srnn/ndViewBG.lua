-- 背景视图节点
local NDViewBG = class("NDViewBG", cc.load("mvc").ViewBase)

--框架体
local tbFrames = g_Global.Hall.tbFrames				--框架接口

--创建游戏视图
function NDViewBG:onCreate()
	self.ndViewBG = nil
	self.csbViewBG = "Game/Srnn/Layer_Game.csb"

	--创建图层，并将层添加到场景
	self.ndViewBG = cc.CSLoader:createNode(self.csbViewBG)
	self:addChild(self.ndViewBG)

	local btnExit = self.ndViewBG:getChildByName("goback_btn")
	LCLog("进入GameViewBG onCreate   ------")

	if btnExit ~= nil then
	btnExit:addClickEventListener(handler(self, self.OnEventBtnExit))
	else
	LCLog("出问题啦   ------")
	end
end

--进入游戏
function NDViewBG:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDViewBG:onExit()
    cc.Node:onExit()
end

--离开按钮事件
function NDViewBG:OnEventBtnExit()
	--返回上层
	LCLog("按钮事件 - 离开游戏")
	tbFrames:TurnBackToHall()
end

return NDViewBG