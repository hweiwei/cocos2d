----------------------------------------------------------------------------------
--大厅网络管理类
-- 1 链接WEB获取网络地址
-- 2 链接登录服务器，提取大厅端口
-- 3 登陆大厅读取数据
-- 4 状态管理：登陆中/登陆成功
----------------------------------------------------------------------------------
local SocketManager_tb = {}

--运行状态
local eStatus = { 
	Null = 0,			--无状态
	Start = 1,			--启动网络
	LogonWait = 2,		--登陆服务器响应状态 
	LogonOver = 3,		--登陆服务器完成状态
	HallWait = 4,		--大厅登陆响应状态
	HallOver = 5,		--大厅登陆完成状态
	Complete = 6		--登陆运行完毕
}

--创建类
function SocketManager_tb:Init()
	if self.bInit==nil then 
		self.bInit = true
		self.wStatus = eStatus.Null						--运行状态
		self.SocketHelper = g_Global.Hall.SocketHelper 	--大厅网络
		self.clSocketLogon = require("app.views.hall.class.clSocketLogon"):new("SocketLogon_cl")
		self.clSocketHall = require("app.views.hall.class.clSocketHall"):new("SocketHall_cl")
		self.clSocketHall:SetHallSocket(self.SocketHelper)
	end
end

function SocketManager_tb:Update()
	if self.wStatus==eStatus.Start then
		--启动登陆获取网关等信息
		self.wStatus=eStatus.LogonWait
		self.clSocketLogon:StartService()
	elseif self.wStatus==eStatus.LogonWait then
		--等待登陆获取结束
		self.clSocketLogon:Update()
		if self.clSocketLogon:IsComplete() then
			self.clSocketLogon:StopService()
			self.wStatus=eStatus.LogonOver
		end
	elseif self.wStatus==eStatus.LogonOver then
		--启动大厅登陆
		self.wStatus=eStatus.HallWait
		self.clSocketHall:StartService()
	elseif self.wStatus==eStatus.HallWait then
		--等待大厅登陆结束
		self.clSocketHall:Update()
		if self.clSocketHall:IsComplete() then
			self.wStatus=eStatus.HallOver
		end
	elseif self.wStatus==eStatus.HallOver then
		--已完成登陆
		self.wStatus=eStatus.Complete
    elseif self.wStatus==eStatus.Complete then
    	--完毕状态
    	self.SocketHelper:RunSocket()
	end
	--LCLog("网络状态："..tostring(self.wStatus))
end

--启动登陆服务器
function SocketManager_tb:StartService()
	self.wStatus=eStatus.Start
end

--是否登陆完成
function SocketManager_tb:IsLogonOver()
	return (self.wStatus==eStatus.Complete)
end

function SocketManager_tb:StopService()
	--停止登陆类
	--停止大厅类
	--完成状态
	self.wStatus=eStatus.Complete
end

return SocketManager_tb
----------------------------------------------------------------------------------

