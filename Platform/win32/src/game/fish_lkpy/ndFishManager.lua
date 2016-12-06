-- 鱼管理节点
local NDFishManager = class("NDFishManager", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDFishManager:onCreate()
	--申明变量
	self.timer = 0
	--启动循环
    --self:scheduleUpdateWithPriorityLua(handler(self,self.UpdateAddFish), 0)
end

--进入游戏
function NDFishManager:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDFishManager:onExit()
    cc.Node:onExit()
end

--测试加鱼
function NDFishManager:UpdateAddFish(interval)
	-- body
	self.timer = self.timer + interval
	if self.timer > 5 then
		self.timer = 0

		--添加鱼
		local clFishItem = require("game.fish_lkpy.ndFishItem"):new("NDFishItem")
		self:addChild(clFishItem)

		--激活鱼
		local nFishID = math.random(1000,5000)
		local nFishType = math.random(1,24)
		local nFishX = math.random(100,1020)
		local nFishY = math.random(10,720)

		clFishItem:ActiveFish(nFishID, nFishType, nFishX, nFishY)

		--LCLog("激活鱼 type="..tostring(nFishType).." x="..tostring(nFishX).." y="..tostring(nFishY))
	end
end

--产生鱼类
function NDFishManager:BornFishTrance(nId,nKind,nInitCount,aryX,aryY)
	--效验参数
	if nInitCount<2 or nInitCount>3 then return end

	--添加鱼
	local clFishItem = require("game.fish_lkpy.ndFishItem"):new("NDFishItem")
	self:addChild(clFishItem)
	
	--激活鱼
	clFishItem:ActiveFish(nId, nKind, nInitCount, aryX, aryY)

	--删除函数
	--local function RemoveFish(ndFish)
		----移除该鱼
		--ndFish:removeFromParent()
		--LCLog("移除该鱼 ---")
	--end

	--创建简单的延迟，0.25秒  
	--local delayAct = cc.DelayTime:create(0.25)
	--local funcAct = cc.CallFunc:create(RemoveFish,clFishItem)
	--local sqeAct = cc.Sequence:create(movAct,delayAct,funcAct)
	--local speedAct = cc.Speed:create(sqeAct,0.8)				--//鱼游动的速度
	--clFishItem:runAction(speedAct)

	--clFishItem:runAction(movAct)

	-- CCBezierTo * actionMove =CCBezierTo::create(dirTime, bezier);
	-- CCRotateTo * actionRotate =CCRotateTo::create(dirTime, endAngle);
	-- CCActionInterval * action =CCSpawn::create(actionMove,actionRotate,NULL);
	-- CCCallFunc *func =CCCallFunc::create(this,callfunc_selector(Fish::removeFish));
	-- CCSequence * actionSequence =CCSequence::create(action,func,NULL);
	-- path =CCSpeed::create(actionSequence,1.85f);//鱼游动的速度

	-- clFishItem:setRotation(2)

	LCLog("创建鱼：------")
end

function NDFishManager:RemoveFish(ndFish)
	--移除该鱼
	ndFish:removeFromParent()
	LCLog("移除该鱼 ---")
end

return NDFishManager