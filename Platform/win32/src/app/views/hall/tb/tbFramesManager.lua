----------------------------------------------------------------------------------
--框架管理类
-- 1 链接游戏服务
-- 2 响应游戏接口
----------------------------------------------------------------------------------
local FramesManager_tb = {
	SocketHelper = nil,					--网络类
	wKindID = 0,						--游戏ID
	wSrvPort = 0,						--游戏端口
	nodeView = nil,						--游戏视图
	nTimerDealy = 0,					--延时网络
}

------------------------------------------------------
--视图接口 nodeView
-- OnEventSceneMessage(cbGameStatus, bLookonUser, packet)
-- OnEventGameMessage(wSubCmdID, packet)
	
-- OnEventUserEnter(wChairID,clUserItem,bLookonUser)
-- OnEventUserLeave(wChairID,clUserItem,bLookonUser)
-- OnEventUserScore(wChairID,clUserItem,bLookonUser)
-- OnEventUserStatus(wChairID,clUserItem,bLookonUser)

--功能函数
-- SendGameData(wSubCmdID, pakSend)
------------------------------------------------------

--运行状态
local EFramesStatus = {
	NULL = 0,			--无状况
}

--房间消息
local msgRoom = g_Global.Hall.msgRoom

--宏
local defStatus = g_Global.Hall.UserStatus
local defInvalid = g_Global.Hall.Invalid
local tbKindDef = g_Global.Hall.GameKind

--设置游戏
function FramesManager_tb:ReSetGame(wKindID, wSrvPort)
	self.wKindID = wKindID
	self.wSrvPort = wSrvPort
	self.wStatus = EFramesStatus.Null		--运行状态
	if self.SocketHelper == nil then
		self.SocketHelper = lc.SocketHelper:new()
	end
	--清理桌子用户
	ListTableUser = {}
end

--创建游戏层
function FramesManager_tb:CreateGameView()
	LCLog("创建游戏视图： "..tostring(self.wKindID))
	--李逵劈鱼
	if self.wKindID == tbKindDef.GK_Fish_Lkpy then
		self.nodeView = require("game.fish_lkpy.lyGameView"):new("LayerGameView")
	--大闹天宫
	elseif self.wKindID == tbKindDef.GK_Fish_Dntg then
		self.nodeView = require("game.fish_dntg.lyGameView"):new("LayerGameView")
	--四人牛牛
	elseif self.wKindID == tbKindDef.GK_Puke_Srnn then
		self.nodeView = require("game.nn_srnn.lyGameView"):new("LayerGameView")
	--欢乐牛牛
	elseif self.wKindID == tbKindDef.GK_HL_NiuNiu then
		self.nodeView = require("game.hl_niuniu.lyGameView"):new("LayerGameView")
	--二十一点
	elseif self.wKindID == tbKindDef.GK_HL_ErShiYiD then
		self.nodeView = require("game.hl_esyd.lyGameView"):new("LayerGameView")
	--百家乐
	elseif self.wKindID == tbKindDef.GK_JieJi_BJL then
		self.nodeView = require("game.hl_bjl.lyGameView"):new("LayerGameView")
	end
	LCLog("创建游戏视图： "..tostring(self.wKindID).." 成功")
	return self.nodeView
end

--游戏循环
function FramesManager_tb:Update(delta)
	--控制网络处理函数的频率
	self.nTimerDealy = self.nTimerDealy + delta
	-- body
	if self.SocketHelper ~= nil and self.nTimerDealy>0.1 then
		self.SocketHelper:RunSocket()
		self.nTimerDealy = 0
	end
end

--启动游戏
function FramesManager_tb:StartService()
	if self.SocketHelper == nil then
		self.SocketHelper = lc.SocketHelper:new()
	end

    -- 创建网络
    self.SocketHelper:SetHanderSink(1,handler(self,FramesManager_tb.OnEventLink))
    self.SocketHelper:SetHanderSink(2,handler(self,FramesManager_tb.OnEventShut))
    self.SocketHelper:SetHanderSink(3,handler(self,FramesManager_tb.OnEventRead))
    self.SocketHelper:SetSocket(g_GlobalConfig.szSrvIP,self.wSrvPort,0)
    self.SocketHelper:Connect()
end

--接收网络
function FramesManager_tb:OnEventLink(socketID,err)
	LCLog("网络消息-【游戏】-链接")
	self:SendLogonPacket()
end

--关闭网络
function FramesManager_tb:OnEventShut(socketID,err)
	LCLog("网络消息-【游戏】-关闭")
end

--网络读取
function FramesManager_tb:OnEventRead(socketID,mainID,subID,packetInfo)
    --LCLog("网络消息-【游戏】-读取 主命令："..tostring(mainID).."  子命令："..tostring(subID))

    --登陆信息
    if mainID==msgRoom.MDM_GR_LOGON then
    	--登陆成功
	    if subID==msgRoom.SUB_GR_LOGON_SUCCESS then
	    	LCLog("登陆成功")
	    --登陆失败
		elseif subID==msgRoom.SUB_GR_LOGON_ERROR then
			LCLog("登陆失败")
			local nErr = packetInfo:read4Byte()
	    	local wServerID = packetInfo:read2Byte()
	    	local strDescrib = packetInfo:readStringEx(128)
	    	LCLog("登陆失败: "..tostring(nErr).." "..tostring(wServerID)..strDescrib)
	    --登陆完成
	    elseif subID==msgRoom.SUB_GR_LOGON_FINISH then
	    	LCLog("登陆房间完成")
	    	self:SendSitDownPacket(defInvalid.INVALID_TABLE,defInvalid.INVALID_CHAIR)
	    	LCLog("登陆房间完成，请求坐下")
	    end
	--用户信息
   	elseif mainID==msgRoom.MDM_GR_USER then
   		--用户进入
   		if subID==msgRoom.SUB_GR_USER_COME then
   			self:OnSubUserCome(packetInfo)
   		--用户状态
   		elseif subID==msgRoom.SUB_GR_USER_STATUS then
   			self:OnSubUserStatus(packetInfo)
   		--用户分数
   		elseif subID==msgRoom.SUB_GR_USER_SCORE then
   			self:OnSubUserScore(packetInfo)
   		--坐下失败
		elseif subID==msgRoom.SUB_GR_SIT_FAILED then
			local szErr = packetInfo:readStringEx(256)
			LCLog("坐下失败"..szErr)
		--用户规则
		elseif subID==msgRoom.SUB_GR_USER_RULE then
   		end
   	--配置信息
   	elseif mainID==msgRoom.MDM_GR_USER then
   		--房间配置
   		if subID==msgRoom.SUB_GR_SERVER_INFO then
   		--配置完成
   		elseif subID==msgRoom.SUB_GR_CONFIG_FINISH then
   		end
   	--桌子信息
   	elseif mainID==msgRoom.MDM_GR_USER then
   		--房间配置
   		if subID==msgRoom.SUB_GR_SERVER_INFO then
   		--配置完成
   		elseif subID==msgRoom.SUB_GR_CONFIG_FINISH then
   		end
	--框架信息
   	elseif mainID==msgRoom.MDM_GF_FRAME then
   		--场景信息
   		if subID==msgRoom.SUB_GF_SCENE then
			if self.nodeView~=nil then
				self.nodeView:OnEventSceneMessage(0,false,packetInfo)
			end
   		--系统消息
   		elseif subID==msgRoom.SUB_GF_MESSAGE then
   		end
	--游戏信息
   	elseif mainID==msgRoom.MDM_GF_GAME then
   		if self.nodeView~=nil then
			self.nodeView:OnEventGameMessage(subID, packetInfo)
		end
    end
end

--发送登陆
function FramesManager_tb:SendLogonPacket()
	local pakSend = lc.PacketAide:GetInstance()
	pakSend:setPosition(0)
	pakSend:write2Byte(1)
	pakSend:write4Byte(g_GlobalUserData.dwUserID)
	pakSend:writeString(lc.MD5:Encrypt(g_GlobalUserData.szPassword),33)
	pakSend:write4Byte(0)
	self.SocketHelper:SendData(msgRoom.MDM_GR_LOGON,msgRoom.SUB_GR_LOGON_USERID,pakSend)
	LCLog("发送登陆房间数据:"..g_GlobalUserData.szPassword)
end

--发送坐下
function FramesManager_tb:SendSitDownPacket(wTableID, wChairID)
	local pakSend = lc.PacketAide:GetInstance()
	LCLog("准备发送坐下请求")
	pakSend:setPosition(0)
	pakSend:write2Byte(wTableID)
	pakSend:write2Byte(wChairID)
	pakSend:writeByte(0)
	self.SocketHelper:SendData(msgRoom.MDM_GR_USER,msgRoom.SUB_GR_USER_SIT_REQ,pakSend)
	LCLog("发送坐下请求")
end

--发送配置
function FramesManager_tb:SendOptionPacket()
	local pakSend = lc.PacketAide:GetInstance()
	pakSend:setPosition(0)
	pakSend:writeByte(0)
	self.SocketHelper:SendData(msgRoom.MDM_GF_FRAME,msgRoom.SUB_GF_INFO,pakSend)
	LCLog("发送房间配置===>")
end

--发送准备
function FramesManager_tb:SendReadyPacket()
	local pakSend = lc.PacketAide:GetInstance()
	pakSend:setPosition(0)
	self.SocketHelper:SendData(msgRoom.MDM_GF_FRAME,msgRoom.SUB_GF_USER_READY,pakSend)
	LCLog("发送准备请求")
end

--用户进入
function FramesManager_tb:OnSubUserCome(packetInfo)
	-- body
	local userItem = require("common.clUserItem"):new("UserItem_cl")
	if userItem==nil then return end

	--读取基本信息
	userItem.wFaceID = packetInfo:read2Byte()
	userItem.dwUserID = packetInfo:read4Byte()
	userItem.dwGameID = packetInfo:read4Byte()
	local dwGroupID = packetInfo:read4Byte()
	local dwUserRight = packetInfo:read4Byte()
	local lLoveliness = packetInfo:read4Byte()
	local dwMasterRight = packetInfo:read4Byte()

	--读取性别，会员等
	userItem.cbGender = packetInfo:readByte()
	local cbMemberOrder = packetInfo:readByte()
	local cbMasterOrder = packetInfo:readByte()

	--读取桌子
	userItem.wTableID = packetInfo:read2Byte()
	userItem.wChairID = packetInfo:read2Byte()
	userItem.cbUserStatus = packetInfo:readByte()

	--读取分数
	userItem.lScore = packetInfo:read8Byte()
	local lGameGold = packetInfo:read8Byte()
	local lInsureScore = packetInfo:read8Byte()
	local lWinCount = packetInfo:read4Byte()
	local lLostCount = packetInfo:read4Byte()
	local lDrawCount = packetInfo:read4Byte()
	local lFleeCount = packetInfo:read4Byte()
	local lExperience = packetInfo:read4Byte()

	--读取扩展信息
	local dwCustomFaceVer = packetInfo:read4Byte()
	for i=1,15 do
		local dwPropResidualTime = packetInfo:read4Byte()
	end
	
	--读取字符信息
	for i=1,5 do
		local nLength = packetInfo:getLeftLenth()
		if nLength <= 4 then break end
 		local wLenDes = packetInfo:read2Byte()
		local wSubDes = packetInfo:read2Byte()
		local strTmpInfo = packetInfo:readStringEx(wLenDes)
		--LCLog("读取到字符："..strTmpInfo)
		if wSubDes==3 then			--账号
			userItem.szAccounts = strTmpInfo
		elseif wSubDes==4 then		--昵称
			userItem.szNickName = strTmpInfo
		elseif wSubDes==12 then		--地域
			userItem.szArea = strTmpInfo
		end
	end

	--添加玩家
	ListRoomUser[userItem.dwUserID] = userItem

	LCLog("添加玩家："..tostring(userItem.dwUserID).." 昵称："..userItem.szNickName.." 来自："..userItem.szArea)
end

--用户状态
function FramesManager_tb:OnSubUserStatus(packetInfo)
	--读取数据
	local dwUserID = packetInfo:read4Byte()
	local wTableID = packetInfo:read2Byte()
	local wChairID = packetInfo:read2Byte()
	local cbUserStatus = packetInfo:readByte()
	
	--查找玩家
	local userItem = ListRoomUser[dwUserID]
	if userItem==nil then return end

	--原信息
	local wOldTableID = userItem.wTableID
	local wOldChairID = userItem.wChairID
	local cbOldStatus = userItem.cbUserStatus

	--更新信息
	userItem.wTableID = wTableID
	userItem.wChairID = wChairID
	userItem.cbUserStatus = cbUserStatus

	--判断自己
	if g_GlobalUserData.dwUserID == userItem.dwUserID then
		--如果是自己,更新全局数据
		g_GlobalUserData.wTableID = wTableID
		g_GlobalUserData.wChairID = wChairID
		g_GlobalUserData.cbUserStatus = cbUserStatus
		--效验节点
		if self.nodeView == nil then return end
		--如果原来不在位置上，现在在位置上，则响应进入消息
		if cbOldStatus<defStatus.US_SIT and  cbUserStatus>=defStatus.US_SIT then
			--组建桌子
			self:JoinTable(userItem)
		elseif cbUserStatus>=defStatus.US_SIT then
			--响应自己的状态改变信息
			self.nodeView:OnEventUserStatus(userItem,false)
		end
	--其他玩家
	else
		--效验节点
		if self.nodeView == nil then return end
		--原来与我同桌
		if wOldTableID~=defInvalid.INVALID_TABLE and wOldTableID==g_GlobalUserData.wTableID then
			--玩家离开
			if cbUserStatus <= defStatus.US_FREE then
				--如果玩家跟自己同桌，则响应离开消息
				self.nodeView:OnEventUserLeave(wOldChairID,userItem,false)	
				ListTableUser[userItem.dwUserID] = nil
			end
		end
		--现在与我同桌
		if wTableID~=defInvalid.INVALID_TABLE and wTableID==g_GlobalUserData.wTableID then
			--玩家进入
			if cbOldStatus <= defStatus.US_FREE then
				--如果玩家跟自己同桌，则响应进入消息
				self.nodeView:OnEventUserEnter(wChairID,userItem,false)	
				ListTableUser[userItem.dwUserID] = userItem
			else
				--响应状态变化
				self.nodeView:OnEventUserStatus(wTableID,userItem,false)	
			end
		end
		--玩家坐下
		if wOldTableID==defInvalid.INVALID_TABLE and wTableID~=defInvalid.INVALID_TABLE then
			LCLog("玩家【"..userItem.szNickName.."】坐下，tableID = "..tostring(wTableID))
		end
		--删除玩家
		if cbUserStatus==defStatus.US_NULL then 
			ListRoomUser[dwUserID] = nil
			ListTableUser[dwUserID] = nil
		end
	end
end

--用户分数
function FramesManager_tb:OnSubUserScore(packetInfo)
	local lLoveliness = packetInfo:read4Byte()
	local dwUserID = packetInfo:read4Byte()
	local lScore = packetInfo:read8Byte()

	--查找玩家
	local userItem = ListRoomUser[dwUserID]
	if userItem==nil then return end
	userItem.lScore = lScore

	--判断自己是否在桌子上
	if g_GlobalUserData.wTableID == defInvalid.INVALID_TABLE then return end

	--判断事件响应
	if g_GlobalUserData.wTableID == userItem.wTableID then
		if self.nodeView ~= nil then
			self.nodeView:OnEventUserScore(wChairID,userItem,false)
		end
	end
end

--组建桌子，响应进入
function FramesManager_tb:JoinTable(userItem)
	--效验接口
	if self.nodeView == nil then return end

	--响应自己进入消息
	self.nodeView:OnEventUserEnter(userItem.wChairID,userItem,false)
	ListTableUser[userItem.dwUserID] = userItem

	LCLog("我的桌子ID: "..tostring(userItem.wTableID).." wChairID="..tostring(userItem.wChairID))

	--查找同桌玩家，响应进入消息
	for k,v in pairs(ListRoomUser) do
		--LCLog("轮询玩家: "..v.szNickName.." 桌子:"..tostring(v.wTableID).." wChairID="..tostring(v.wChairID))
		if k==g_GlobalUserData.dwUserID then
			--查询是自己
		elseif v.wTableID == g_GlobalUserData.wTableID then
			LCLog("玩家与我同桌 ====> "..v.szNickName)
			--与我同桌的玩家
			self.nodeView:OnEventUserEnter(v.wChairID,v,false)
			ListTableUser[k] = v
		end
	end
	--发送配置信息
	self:SendOptionPacket()
end

--发送游戏数据
function FramesManager_tb:SendGameData(wSubCmdID, pakSend)
	self.SocketHelper:SendData(msgRoom.MDM_GF_GAME,wSubCmdID,pakSend)
end

--返回大厅
function FramesManager_tb:TurnBackToHall()
	--关闭网络
	self.SocketHelper:CloseSocket()
	--检验加载,显示场景
	local layer = require("app.views.scene.HallScene"):new("HallScene") 
    if layer == nil then return end
    layer:showWithScene() 
end

return FramesManager_tb


