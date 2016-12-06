----------------------------------------------------------------------
-- 游戏视图层 | 框架体 ==> ( g_Global.Hall.tbFrames )
----------------------------------------------------------------------
local LayerGameView = class("LayerGameView", cc.load("mvc").ViewBase)

--载入游戏消息
require("game.fish_lkpy.msgFishLkpy")

--定义宏
local msgFish = g_Global.Game.msgFishLkpy		--游戏消息
local tbFrames = g_Global.Hall.tbFrames			--框架接口

--创建游戏视图
function LayerGameView:onCreate()
	self.ndLoading = nil
	self.ndViewBG = nil
	self.ndFishManager = nil
	self.ndSurfaceWater = nil
	self.ndBulletManager = nil
	self.ndBombEff = nil
	self.ndCoinManager = nil
	self.ndCatchNum = nil
	self.ndTideWater = nil
	self.ndGameUI = nil
	self.ndGameHelper = nil
	self.timer = 0

	--加载加载层资源
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Game/Lkpy/lkpy_logo.plist") 

	--加载loading层
	self.ndLoading = require("common.lyGameLoad"):new("LyGameLoad")
	if self.ndLoading ~= nil then
		--添加加载层节点
		self:addChild(self.ndLoading)

		--创建层图（加载层）
		self.ndLoading:createResoueceNode("Game/Lkpy/Layer_Loading_Lkpy.csb")

		--准备资源
		self.ndLoading:AddRes("Game/Lkpy/lkpy_scene.plist")
		self.ndLoading:AddRes("Game/Lkpy/Bomb.plist")
		self.ndLoading:AddRes("Game/Lkpy/fishNet.plist")
		self.ndLoading:AddRes("Game/Lkpy/waterMov.plist")
		self.ndLoading:AddRes("Game/Lkpy/lkpy_score.plist")
		self.ndLoading:AddRes("Game/Lkpy/lkpy_cannon.plist")
		self.ndLoading:AddRes("Game/Lkpy/fishMovA.plist")
		self.ndLoading:AddRes("Game/Lkpy/fishMovB.plist")
		self.ndLoading:AddRes("Game/Lkpy/fishMovC.plist")
		self.ndLoading:AddRes("Game/Lkpy/fishMovD.plist")

		--启动加载
		self.ndLoading:StartLoading()
	end
end

--进入游戏
function LayerGameView:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function LayerGameView:onExit()
    cc.Node:onExit()
end

--场景消息
function LayerGameView:OnEventSceneMessage(cbGameStatus, bLookonUser, packet)
	-- body
	LCLog("收到场景消息:")
end
--网络消息
function LayerGameView:OnEventGameMessage(wSubCmdID, packet)
	-- body
	--LCLog("收到游戏消息:"..tostring(wSubCmdID))
	--游戏配置
	if wSubCmdID==msgFish.SUB_S_GAME_CONFIG then
		self:hSubGameConfig(packet)
	--特殊鱼类
	elseif wSubCmdID==msgFish.SUB_S_CATCH_SWEEP_FISH then
		self:hSubCatchSweepFish(packet)
	--特殊子弹
	elseif wSubCmdID==msgFish.SUB_S_BULLET_ION_TIMEOUT then
		self:hSubBulletIonTimeOut(packet)
	--玩家开火
	elseif wSubCmdID==msgFish.SUB_S_USER_FIRE then
		self:hSubUserFire(packet)
	--产生鱼类
	elseif wSubCmdID==msgFish.SUB_S_FISH_TRACE then
		self:hSubFishTrace(packet)
	--鱼分改变
	elseif wSubCmdID==msgFish.SUB_S_EXCHANGE_FISHSCORE then
		self:hSubChangeFishScore(packet)
	--捕获鱼类
	elseif wSubCmdID==msgFish.SUB_S_CATCH_FISH then
		self:hSubCatchFish(packet)
	--定屏超时
	elseif wSubCmdID==msgFish.SUB_S_LOCK_TIMEOUT then
		self:hSubLockTimeOut(packet)
	--炸鱼结果
	elseif wSubCmdID==msgFish.SUB_S_CATCH_SWEEP_FISH_RESULT then
		self:hSubSweepFishRlt(packet)
	--击中李逵
	elseif wSubCmdID==msgFish.SUB_S_HIT_FISH_LK then
		self:hSubHitFishLK(packet)
	--改变场景
	elseif wSubCmdID==msgFish.SUB_S_SWITCH_SCENE then
		self:hSubSweepScene(packet)
	--场景结束
	elseif wSubCmdID==msgFish.SUB_S_SCENE_END then
		self:hSubSceneEnd(packet)
	--同步鱼分
	elseif wSubCmdID==msgFish.SUB_S_SITSCORESAME then
		self:hSubSitScoreSame(packet)
	--通知信息
	elseif wSubCmdID==msgFish.SUB_S_NOTIFY then
		self:hSubMsgNotify(packet)
	end
end
--用户事件
function LayerGameView:OnEventUserEnter(wChairID,clUserItem,bLookonUser)
	-- body
	LCLog("收到玩家【"..clUserItem.szNickName.."】进入桌子")
	--更新UI
	if self.ndGameUI~=nil then
		self.ndGameUI:UserEnter(clUserItem.wChairID,clUserItem)
	end
end
--用户事件
function LayerGameView:OnEventUserLeave(wChairID,clUserItem,bLookonUser)
	-- body
	LCLog("收到玩家【"..clUserItem.szNickName.."】离开桌子 wChairID="..tostring(wChairID))
	--更新UI
	if self.ndGameUI~=nil then
		self.ndGameUI:UserLeave(wChairID)
	end
end
--用户事件
function LayerGameView:OnEventUserScore(wChairID,clUserItem,bLookonUser)
	-- body
	LCLog("收到玩家【"..clUserItem.szNickName.."】分数信息==>"..tostring(clUserItem.lScore))
end

--用户事件
function LayerGameView:OnEventUserStatus(wChairID,clUserItem,bLookonUser)
	-- body
	LCLog("收到玩家【"..clUserItem.szNickName.."】状态信息==>"..tostring(clUserItem.cbUserStatus))
end

--加载资源完成
function LayerGameView:OnLoadingOver()
	-- body
	LCLog("游戏资源加载完毕！")

	--创建节点类
	self.ndViewBG = require("game.fish_lkpy.ndViewBG"):new("NDViewBG")
	self.ndFishManager = require("game.fish_lkpy.ndFishManager"):new("NDFishManager")
	self.ndSurfaceWater = require("game.fish_lkpy.ndSurfaceWater"):new("NDSurfaceWater")
	self.ndBulletManager = require("game.fish_lkpy.ndBulletManager"):new("NDBulletManager")
	self.ndBombEff = require("game.fish_lkpy.ndBombEff"):new("NDBombEff")
	self.ndCoinManager = require("game.fish_lkpy.ndCoinManager"):new("NDCoinManager")
	self.ndCatchNum = require("game.fish_lkpy.ndCatchNum"):new("NDCatchNum")
	self.ndTideWater = require("game.fish_lkpy.ndTideWater"):new("NDTideWater")
	self.ndGameUI = require("game.fish_lkpy.ndGameUI"):new("NDGameUI")
	self.ndGameHelper = require("game.fish_lkpy.ndGameUI"):new("NDGameUI")

	--添加节点类
	self:addChild(self.ndViewBG)
	self:addChild(self.ndFishManager)
	self:addChild(self.ndSurfaceWater)
	self:addChild(self.ndBulletManager)
	self:addChild(self.ndBombEff)
	self:addChild(self.ndCoinManager)
	self:addChild(self.ndCatchNum)
	self:addChild(self.ndTideWater)
	self:addChild(self.ndGameUI)
	self:addChild(self.ndGameHelper)

    --更新UI
	for k,v in pairs(ListTableUser) do
		LCLog("更新UI 桌子玩家==>"..tostring(v.wChairID).." 玩家："..v.szNickName)
		self.ndGameUI:UserEnter(v.wChairID,v)
	end

	--启动循环 （ 测试用，定时更换背景图 ）
    self:scheduleUpdateWithPriorityLua(handler(self,self.UpdateTurnBG), 0)
end

function LayerGameView:UpdateTurnBG(interval)
	-- body
	self.timer = self.timer + interval
	--LCLog("时间长："..tostring(self.timer))
	if self.timer > 8 then
		--切换背景图
		self:TurnBGByTideWater()
		self.timer = 0

		--产生特效
		self.ndBombEff:BornBombEff(math.random(1,2), math.random(200,1000),math.random(200,500))
	end
end

function LayerGameView:TurnBGByTideWater()
	--切换背景图
	self.ndViewBG:TurnBGByTideWater()
	self.ndTideWater:TurnBGByTideWater()
end

--游戏配置
function LayerGameView:hSubGameConfig(packet)
	--body
	local exchange_ratio_userscore = packet:read4Byte()
	local exchange_ratio_fishscore = packet:read4Byte()
	local exchange_count = packet:read4Byte()
	local min_bullet_multiple = packet:read4Byte()
	local max_bullet_multiple = packet:read4Byte()
	local bomb_range_width = packet:read4Byte()
	local bomb_range_height = packet:read4Byte()
	--鱼信息 （ 共40项 ）
	for i=1,41 do
		local fish_multiple = packet:read2Byte()
		local fish_speed = packet:readByte()
		local fish_bounding_box_width = packet:read2Byte()
		local fish_bounding_box_height = packet:read2Byte()
		local fish_hit_radius = packet:read2Byte()
	end
	--子弹信息 （ 共5项 ）
	for i=1,6 do
		local bullet_speed = packet:read2Byte()
		local net_radius = packet:read2Byte()
		LCLog("子弹速度："..tostring(bullet_speed).." 渔网半径："..tostring(net_radius))
	end
end

--特殊鱼类
function LayerGameView:hSubCatchSweepFish(packet)
-- body
end

--特殊子弹
function LayerGameView:hSubBulletIonTimeOut(packet)
-- body
end

--玩家开火
function LayerGameView:hSubUserFire(packet)
-- body
end

--产生鱼类
function LayerGameView:hSubFishTrace(packet)
	--效验成功加载
	if self.ndFishManager==nil then return end

	--添加鱼
	for i=1,100 do
		--判断是否还有鱼可以读取
		if packet:getLeftLenth() < 40 then break end
		--读取鱼类
		local ppx = {}
		local ppy = {}
		for j=1,5 do
			ppx[j] = packet:readFloat()
			ppy[j] = packet:readFloat()
			--LCLog("读取到鱼移动坐标："..tostring(j).." "..tostring(ppx[j]).." "..tostring(ppy[j]))
		end
		local nInitCount = packet:readByte()
		local nKind = packet:readByte()
		local nId = packet:read4Byte()
		local nTrace = packet:readByte()
		LCLog("鱼信息,Id="..tostring(nId).." kind="..tostring(nKind).." nInitCount="..tostring(nInitCount))
		self.ndFishManager:BornFishTrance(nId,nKind,nInitCount,ppx,ppy)
	end
end

--鱼分改变
function LayerGameView:hSubChangeFishScore(packet)
-- body
end

--捕获鱼类
function LayerGameView:hSubCatchFish(packet)
-- body
end

--定屏超时
function LayerGameView:hSubLockTimeOut(packet)
-- body
end
--炸鱼结果
function LayerGameView:hSubSweepFishRlt(packet)
-- body
end

--击中李逵
function LayerGameView:hSubHitFishLK(packet)
-- body
end

--改变场景
function LayerGameView:hSubSweepScene(packet)
-- body
end
--场景结束
function LayerGameView:hSubSceneEnd(packet)
-- body
end
--同步鱼分
function LayerGameView:hSubSitScoreSame(packet)
-- body
end
--通知信息
function LayerGameView:hSubMsgNotify(packet)
-- body
end

return LayerGameView


