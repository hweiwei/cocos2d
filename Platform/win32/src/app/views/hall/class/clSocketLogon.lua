----------------------------------------------------------------------------------
-- 登陆服务器网络类（ 1 主要是自动获取网络地址和大厅端口 ）
-- 1 链接登录服务器，提取大厅端口
----------------------------------------------------------------------------------
local SocketLogon_cl = class("SocketLogon_cl")

--局部定义
local clSocketHelper			--网络层
local msgHall					--消息层

--创建类
function SocketLogon_cl:ctor()
	self.dwPort = 0
	self.szAddr = ""
	self.bComplete = false

	clSocketHelper = lc.SocketHelper:new()
	msgHall = g_Global.Hall.msgHall
end

function SocketLogon_cl:Update()
	--循环网络
    clSocketHelper:RunSocket()
end

function SocketLogon_cl:IsComplete()
	return self.bComplete
end

function SocketLogon_cl:StartService()
	--链接登陆服务器
	self.dwPort = PORT_LOGON
	self.szAddr = g_GlobalConfig.szSrvIP
	self:ConnToSrv(self.szAddr, self.dwPort)
end

function SocketLogon_cl:StopService()
	-- body
	clSocketHelper:CloseSocket()
end
----------------------------------------------------------------------------------
--网络相关
function SocketLogon_cl:ConnToSrv(addr,port)
	-- 创建网络
    clSocketHelper:SetHanderSink(1,handler(self,SocketLogon_cl.OnEventLink))
    clSocketHelper:SetHanderSink(2,handler(self,SocketLogon_cl.OnEventShut))
    clSocketHelper:SetHanderSink(3,handler(self,SocketLogon_cl.OnEventRead))
    clSocketHelper:SetSocket(addr,port,0)
    clSocketHelper:Connect()
end

function SocketLogon_cl:OnEventLink(socketID,err)
    --网络消息-链接
    LCLog("网络消息--链接！")
    self:SendKeyToLogon()
end

function SocketLogon_cl:OnEventShut(socketID,err)
	--网络消息-关闭
	LCLog("网络消息--关闭！")
end

function SocketLogon_cl:OnEventRead(socketID,mainID,subID,packetInfo)
	LCLog("网络消息--读取:"..tostring(msgHall.MOB_LM_LOGON))
	--登陆服务器信息
	if mainID==msgHall.MOB_LM_LOGON then
		self:OnSocketMainLogon(socketID,mainID,subID,packetInfo)
	else
		LCLog("SocketLogon_cl：收到未知的命令=%d")
	end
end
----------------------------------------------------------------------------------
function SocketLogon_cl:SendKeyToLogon()
	-- body
	local pakSend = lc.PacketAide:GetInstance()
	pakSend:setPosition(0)
	pakSend:write2Byte(1)
	pakSend:write4Byte(2)
	pakSend:writeString("128-43234-456-7683-453",33)
	pakSend:write4Byte(752307)
	pakSend:writeString("你大爷的，填写空白的文字！",21)
	clSocketHelper:SendData(msgHall.MOB_LM_LOGON,msgHall.CMD_LC_Logon_Key,pakSend)
	LCLog("发送数据")
end

function SocketLogon_cl:OnSocketMainLogon(socketID,mainID,subID,packetInfo)
	LCLog("处理登陆消息")
	-- body
	if mainID==msgHall.MOB_LM_LOGON and subID==msgHall.CMD_LS_Logon_Key then
		--收到登陆回答KEY
		local nVersion = packetInfo:read4Byte()
		local lSKeyValue = packetInfo:read8Byte()
		local nPort = packetInfo:read4Byte()

		g_GlobalConfig.nVersion = nVersion
		g_GlobalConfig.nHallPort = nPort
		g_GlobalConfig.lHallKey = lSKeyValue

		self.bComplete = true

		LCLog("设置登陆结果")

		local ss = string.format("服务器返回：ver=%08x, Key=%i, nPort=%d",nVersion,lSKeyValue,nPort)
		LCLog(ss)
	end
end

return SocketLogon_cl
----------------------------------------------------------------------------------

