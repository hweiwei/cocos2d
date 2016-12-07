----------------------------------------------------------------------------------
--大厅网络类（ 1 主要是自动获取网络地址和大厅端口 ）
-- 1 链接大厅服务器，登陆大厅获取玩家数据
----------------------------------------------------------------------------------
local SocketHall_cl = class("SocketHall_cl")

--局部变量
local msgHall

--创建类
function SocketHall_cl:ctor()
	--
	self.bComplete = false
	self.clSocketHelper = nil

	msgHall = g_Global.Hall.msgHall
end

--设置网络
function SocketHall_cl:SetHallSocket( socketHelper )
	-- body
	self.clSocketHelper = socketHelper
end

function SocketHall_cl:Update()
	--循环网络
    if self.clSocketHelper~=nil then 
    	self.clSocketHelper:RunSocket() 
    end
end

function SocketHall_cl:StartService()
	--链接大厅服务器
	LCLog("启动服务==>链接大厅服务器：IP="..g_GlobalConfig.szSrvIP.." 端口="..tostring(g_GlobalConfig.nHallPort))
	self:ConnToSrv(g_GlobalConfig.szSrvIP, g_GlobalConfig.nHallPort)
end

function SocketHall_cl:StopService()
	-- body
	self.clSocketHelper:CloseSocket()
end

function SocketHall_cl:IsComplete()
	return self.bComplete
end
----------------------------------------------------------------------------------
--网络相关
function SocketHall_cl:ConnToSrv(addr,port)
	-- 
    self.clSocketHelper:SetHanderSink(1,handler(self,SocketHall_cl.OnEventLink))
    self.clSocketHelper:SetHanderSink(2,handler(self,SocketHall_cl.OnEventShut))
    self.clSocketHelper:SetHanderSink(3,handler(self,SocketHall_cl.OnEventRead))
    self.clSocketHelper:SetSocket(addr,port,0)
    self.clSocketHelper:Connect()
end

function SocketHall_cl:OnEventLink(socketID,err)
    --网络消息-链接
    LCLog("大厅网络消息--链接！"..tostring(err))
    self:LogonToHall()
end

function SocketHall_cl:OnEventShut(socketID,err)
	--网络消息-关闭
	LCLog("大厅网络消息--关闭！"..tostring(err))
end

function SocketHall_cl:OnEventRead(socketID,mainID,subID,packetInfo)
	LCLog("收到大厅消息：main="..tostring(mainID)..' sub='..tostring(subID))
	--大厅服务器信息
	if mainID==msgHall.MOB_LM_HALL then
		self:OnSocketMainLogon(socketID,mainID,subID,packetInfo)
	end
end
----------------------------------------------------------------------------------
function SocketHall_cl:LogonToHall()
	--发包准备
	local pakSend = lc.PacketAide:GetInstance()
	pakSend:setPosition(0)

	--检测是否已有账号，没有就注册
	local defUser = cc.UserDefault:getInstance()

	--密码检测
	local strPwd = defUser:getStringForKey(STR_FK_PASSWORD)
	if strPwd == "" then
		local numA = math.ceil(math.random()*8000)+1000
		local numB = math.ceil(math.random()*8000)+1000
		local numC = math.ceil(math.random()*8000)+1000
		local numD = math.ceil(math.random()*8000)+1000
		strPwd = tostring(numA)..tostring(numB)..tostring(numC)..tostring(numD)
		defUser:setStringForKey(STR_FK_PASSWORD, strPwd)
	else
		LCLog("密码："..strPwd)
	end

	LCLog("密码："..lc.MD5:Encrypt(strPwd))

	--记录密码
	g_GlobalUserData.szPassword = strPwd

	--账号检测
	local strAcc = defUser:getStringForKey(STR_FK_ACCOUNTS, "")
	if strAcc == "" then
		--注册账号
		pakSend:write4Byte(6603)
		pakSend:write2Byte(2)
		pakSend:writeString(lc.MD5:Encrypt(strPwd),33)
		pakSend:write8Byte(752307)
		self.clSocketHelper:SendData(msgHall.MOB_LM_HALL,msgHall.CMD_LC_GuestRegister,pakSend)
		LCLog("发送注册数据")
	else
		--账号登陆
		pakSend:write4Byte(6603)
		pakSend:writeString(strAcc,32)
		pakSend:writeString(lc.MD5:Encrypt(strPwd),33)
		pakSend:write8Byte(752307)
		pakSend:write4Byte(752307)
		self.clSocketHelper:SendData(msgHall.MOB_LM_HALL,msgHall.CMD_LC_GuestLogon,pakSend)
		LCLog("发送登陆数据")
	end
end

function SocketHall_cl:OnSocketMainLogon(socketID,mainID,subID,packetInfo)
	--消息处理
	if subID==msgHall.CMD_LS_GuestRegSucc then
		--注册成功	
		local strAcc = packetInfo:readString(LEN_ACCOUNTS)
		local strPwd = packetInfo:readString(LEN_PASSWORD)
		local defUser = cc.UserDefault:getInstance()
		defUser:setStringForKey(STR_FK_ACCOUNTS, strAcc)
		LCLog("注册成功：acc="..strAcc.." pwd="..strPwd)
	elseif subID==msgHall.CMD_LS_GuestLogonSucc then
		--登陆成功
		g_GlobalUserData.dwUserID = packetInfo:read4Byte()
		g_GlobalUserData.dwGameID = packetInfo:read4Byte()
		g_GlobalUserData.szNickName = packetInfo:readString(LEN_NICKNAME)
		g_GlobalUserData.lScore = packetInfo:read8Byte()
		g_GlobalUserData.lBankGold = packetInfo:read8Byte()
		LCLog("登陆成功: UserID="..tostring(g_GlobalUserData.dwUserID)..g_GlobalUserData.szNickName)
	elseif subID==msgHall.CMD_LS_GuestLogonFail then
		LCLog("登陆失败")
		--登陆失败
	elseif subID==msgHall.CMD_LS_GameKind then
		--游戏信息
		local gameKind = require("app.views.hall.class.clGameKind"):new("GameKind_cl")
		gameKind.wKindID = packetInfo:read2Byte()
		gameKind.wSortID = packetInfo:read2Byte()
		gameKind.szKindName = packetInfo:readStringEx(LEN_KIND)
		ListGameKind[gameKind.wKindID] = gameKind
		LCLog("添加游戏："..tostring(gameKind.wKindID).." = "..gameKind.szKindName)
	elseif subID==msgHall.CMD_LS_GameRoom then
		--房间信息
		local wKindID = packetInfo:read2Byte()
		local wRoomCount = packetInfo:read2Byte()
		LCLog("添加房间："..tostring(wKindID).." 数量："..tostring(wRoomCount))
		--查询该游戏
		local gameKind = ListGameKind[wKindID]
		if gameKind == nil then 
			LCLog("竟然没有找到该游戏: "..tostring(wKindID))
			return
		end
		--设置房间信息
		gameKind.wRoomCount = wRoomCount
		for i=1,wRoomCount do
			local nCellScore = packetInfo:read4Byte()
			local nLessScore = packetInfo:read4Byte()
			--gameKind.aryRoom[nCellScore] = nLessScore	
			--gameKind.aryRoom[i] = {}
			gameKind.aryRoom[i].nCellScore = nCellScore	
			gameKind.aryRoom[i].nLessScore = nLessScore	
			LCLog("添加具体房间==> "..tostring(i))
		end
	elseif subID==msgHall.CMD_LS_LogonComplete then
		LCLog("玩家登陆完成！")
		for k,v in pairs(ListGameKind) do
			print("游戏类型：kind="..tostring(k))
			for kk,vv in pairs(v) do
				print("房间底分："..tostring(kk).." 房间限制："..tostring(vv))
			end
		end
		self.bComplete = true
	end
end

return SocketHall_cl
----------------------------------------------------------------------------------

