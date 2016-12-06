-- 子弹管理节点
local NDFishItem = class("NDFishItem", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDFishItem:onCreate()
	self.blife = false
	self.nFishID = 0
	self.nType = 0
	self.nSpeed = 0
	self.nStatus = 0
	self.nMul = 0
	self.ndFish = nil
	self.actFish = nil
end

--进入游戏
function NDFishItem:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDFishItem:onExit()
    cc.Node:onExit()
end

--激活鱼
function NDFishItem:ActiveFish( fishID, fishType, nPosCount, aryX, aryY )
	--为鱼配置参数
	self.nFishID = fishID
	self.nType = fishType
	self.blife = true
	--鱼动画及位置
	--self:setPosition(aryX[1],aryY[1])
	self:setPosition(600,350)
	
	--设置动作
LCLog(" 111 ")
	--删除函数
	local function RemoveFish()
		--移除该鱼
		self:removeFromParent()
		LCLog("移除该鱼 ---")
	end

LCLog(" 222 ")
	--设置移动
	-- local movAct = nil
	-- if nPosCount == 2 then
	-- 	movAct = cc.MoveTo:create(15,cc.p(aryX[2], aryY[2]))
	-- elseif nPosCount == 3 then
	-- 	movAct = cc.MoveTo:create(15,cc.p(aryX[3], aryY[3]))
	-- else
	-- 	return
	-- end
	local movAct = cc.MoveTo:create(10,cc.p(aryX[2], aryY[2]))
LCLog(" 333 ")	
	--创建简单的延迟，0.25秒  
	--local delayAct = cc.DelayTime:create(0.25)
	--local funcAct = cc.CallFunc:create(RemoveFish)
	--local sqeAct = cc.Sequence:create(movAct,funcAct)
	--local speedAct = cc.Speed:create(movAct,0.8)				--//鱼游动的速度
	self:runAction(movAct)
LCLog(" 444 ")

	self:CreateFish(fishType)

LCLog(" 555 ")
end

function NDFishItem:CreateFish(fishType)
	local  szFileCSB = "Game/Lkpy/Node_M_FishActEx.csb"

	--创建动画节点
	self.ndFish = cc.CSLoader:createNode(szFileCSB)
	self:addChild(self.ndFish)

	--创建时间线
	self.actFish = cc.CSLoader:createTimeline(szFileCSB)
	if self.actFish~=nil then
		self.ndFish:runAction(self.actFish)
	end

	self:PlayFish(fishType)
end

function NDFishItem:PlayFish(fishType)
    if fishType == 1 then self.actFish:play("fishmov01", true)
	elseif fishType == 2 then self.actFish:play("fishmov02", true)
	elseif fishType == 3 then self.actFish:play("fishmov03", true)
	elseif fishType == 4 then self.actFish:play("fishmov04", true)
	elseif fishType == 5 then self.actFish:play("fishmov05", true)
	elseif fishType == 6 then self.actFish:play("fishmov06", true)
	elseif fishType == 7 then self.actFish:play("fishmov07", true)
	elseif fishType == 8 then self.actFish:play("fishmov08", true)
	elseif fishType == 9 then self.actFish:play("fishmov09", true)
	elseif fishType == 10 then self.actFish:play("fishmov10", true)
	elseif fishType == 11 then self.actFish:play("fishmov11", true)
	elseif fishType == 12 then self.actFish:play("fishmov12", true)
	elseif fishType == 13 then self.actFish:play("fishmov13", true)
	elseif fishType == 14 then self.actFish:play("fishmov14", true)
	elseif fishType == 15 then self.actFish:play("fishmov15", true)
	elseif fishType == 16 then self.actFish:play("fishmov16", true)
	elseif fishType == 17 then self.actFish:play("fishmov17", true)
	elseif fishType == 18 then self.actFish:play("fishmov18", true)
	elseif fishType == 19 then self.actFish:play("fishmov19", true)
	elseif fishType == 20 then self.actFish:play("fishmov20", true)
	elseif fishType == 21 then self.actFish:play("fishmov21", true)
	elseif fishType == 22 then self.actFish:play("fishmov22", true)
	elseif fishType == 23 then self.actFish:play("fishmov23", true)
	elseif fishType == 24 then self.actFish:play("fishmov24", true)
	end
end

return NDFishItem