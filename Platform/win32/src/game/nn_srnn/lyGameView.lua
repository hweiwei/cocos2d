----------------------------------------------------------------------
-- 游戏视图层 | 框架体 ==> ( g_Global.Hall.tbFrames )
----------------------------------------------------------------------
local LayerGameView = class("LayerGameView", cc.load("mvc").ViewBase)

--载入游戏消息
require("game.nn_srnn.msgPkSrnn")

--定义宏
local msgPkSrnn = g_Global.Game.Srnn.msgPkSrnn		--游戏消息
local tbConfig = g_Global.Game.Srnn.config 			--游戏设置
local tbFrames = g_Global.Hall.tbFrames				--框架接口


--创建游戏视图
function LayerGameView:onCreate()
	--游戏节点变量声明
	self.ndLoading = nil
	self.ndViewBG = nil

	--扑克管理
	self.ndPkManager = nil
	
	--筹码管理（上庄筹码）
	self.ndChipManager = nil
	
	--得分管理
	self.ndScoreManager = nil
	
	--游戏按钮
	self.ndGameBtn = nil
	
	--是否抢庄
	self.bRob = false
	
	--结果管理(无牛，牛一 XXX 牛牛，至尊牛，炸弹牛，五小牛)
	self.ndEndManager = nil

	self.ndGameUI = nil
	self.ndGameHelper = nil
	self.timer = 0
    LCLog(" LayerGameView:onCreate() 111")
	--加载加载层资源
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Game/Srnn/loading.plist") 

	--加载loading层
	self.ndLoading = require("common.lyGameLoad"):new("LyGameLoad")
	if self.ndLoading ~= nil then
		--添加加载层节点
		self:addChild(self.ndLoading)

		--创建图层（加载层）
		self.ndLoading:createResoueceNode("Game/Srnn/Layer_loading.csb")

		--准备资源
		self.ndLoading:AddRes("Game/Srnn/card.plist")
		self.ndLoading:AddRes("Game/Srnn/chip.plist")
		self.ndLoading:AddRes("Game/Srnn/chip_num.plist")
		self.ndLoading:AddRes("Game/Srnn/hn_dh.plist")
		self.ndLoading:AddRes("Game/Srnn/hn_txt.plist")
		self.ndLoading:AddRes("Game/Srnn/nngame.plist")
		self.ndLoading:AddRes("Game/Srnn/ptnn.plist")
		self.ndLoading:AddRes("Game/Srnn/time.plist")
		self.ndLoading:AddRes("Game/Srnn/whn.plist")
		self.ndLoading:AddRes("Game/Srnn/wxn_dh.plist")
		self.ndLoading:AddRes("Game/Srnn/zdn_dh.plist")
		self.ndLoading:AddRes("Game/Srnn/zdn_txt.plist")

		--启动加载
		self.ndLoading:StartLoading()
	end
	LCLog(" LayerGameView:onCreate() 222")
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
	LCLog("收到游戏消息:"..tostring(wSubCmdID))
    --准备等待
	if wSubCmdID==msgPkSrnn.CMD_SC_WaitReady_P then
		self:hSubWaitReady(packet)
	--游戏开始
	elseif wSubCmdID==msgPkSrnn.CMD_SC_GameStart_P then
		self:hSubGameStart(packet)
	--下注开始
	elseif wSubCmdID==msgPkSrnn.CMD_SC_ChipStart_P then
	 	self:hSubChipStart(packet)
	 --玩家下注
	elseif wSubCmdID==msgPkSrnn.CMD_SC_UserChip_P then
	 	self:hSubUserChip(packet)
	--系统发牌
	elseif wSubCmdID==msgPkSrnn.CMD_SC_DispatchCard_P then
		self:hSubDispatchCard(packet)
	--玩家凑牌
	elseif wSubCmdID==msgPkSrnn.CMD_SC_UserOpenCard_P then
	 	self:hSubUserOpenCard(packet)
	--系统开牌
	elseif wSubCmdID==msgPkSrnn.CMD_SC_SysOpenCard_P then
	 	self:hSubSysOpenCard(packet)
	--结束清算
	elseif wSubCmdID==msgPkSrnn.CMD_SC_EndScore_P then
	 	self:hSubEndScore(packet)
	--玩家抢庄
	elseif wSubCmdID==msgPkSrnn.CMD_SC_UserRob_P then
	 	self:hSubUserRob(packet)
	--通知玩家抢庄
	elseif wSubCmdID==msgPkSrnn.CMD_SC_NotifyUserRob_P then
	 	self:hSubNotifyUserRob(packet)
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
	self.ndViewBG = require("game.nn_srnn.ndViewBG"):new("NDViewBG")
	--self.ndFishManager = require("game.fish_Srnn.ndFishManager"):new("NDFishManager")
	--self.ndSurfaceWater = require("game.fish_Srnn.ndSurfaceWater"):new("NDSurfaceWater")
	--self.ndBulletManager = require("game.fish_Srnn.ndBulletManager"):new("NDBulletManager")
	--self.ndBombEff = require("game.fish_Srnn.ndBombEff"):new("NDBombEff")
	--self.ndCoinManager = require("game.fish_Srnn.ndCoinManager"):new("NDCoinManager")
	--self.ndCatchNum = require("game.fish_Srnn.ndCatchNum"):new("NDCatchNum")
	--self.ndTideWater = require("game.fish_Srnn.ndTideWater"):new("NDTideWater")
	self.ndGameUI = require("game.nn_srnn.ndGameUI"):new("NDGameUI")
	--self.ndGameHelper = require("game.fish_Srnn.ndGameUI"):new("NDGameUI")
	--添加节点类
	self:addChild(self.ndViewBG)
	--self:addChild(self.ndFishManager)
	--self:addChild(self.ndSurfaceWater)
	--self:addChild(self.ndBulletManager)
	--self:addChild(self.ndBombEff)
	--self:addChild(self.ndCoinManager)
	--self:addChild(self.ndCatchNum)
	--self:addChild(self.ndTideWater)
	self:addChild(self.ndGameUI)
	--self:addChild(self.ndGameHelper)
    --更新UI
	for k,v in pairs(ListTableUser) do
		LCLog("更新UI 桌子玩家==>"..tostring(v.wChairID).." 玩家："..v.szNickName)
		self.ndGameUI:UserEnter(v.wChairID,v)
	end
	--启动循环 （ 测试用，定时更换背景图 ）
    --self:scheduleUpdateWithPriorityLua(handler(self,self.UpdateTurnBG), 0)
end
--更新背景
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

--准备等待
function LayerGameView:hSubWaitReady(packet)
--body
end

--游戏开始
function LayerGameView:hSubGameStart(packet)
-- body
end

--下注开始
function LayerGameView:hSubChipStart(packet)
-- body
end

--玩家下注
function LayerGameView:hSubUserChip(packet)
--body
end

--系统发牌
function LayerGameView:hSubDispatchCard(packet)
-- body
end

--玩家凑牌
function LayerGameView:hSubUserOpenCard(packet)
-- body
end

--系统开牌
function LayerGameView:hSubSysOpenCard(packet)
-- body
end

--结束清算
function LayerGameView:hSubEndScore(packet)
--body
end

--玩家抢庄
function LayerGameView:hSubUserRob(packet)
-- body
end

--通知玩家抢庄
function LayerGameView:hSubNotifyUserRob(packet)
-- body
end

return LayerGameView


