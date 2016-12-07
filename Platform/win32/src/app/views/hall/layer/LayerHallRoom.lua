
--加载层
local LayerHallRoom = class("LayerHallRoom", cc.load("mvc").ViewBase)
LayerHallRoom.RESOURCE_FILENAME = "HallMain/Layer_RoomPage.csb"

--局部成员变量
local clSocketHelper			--大厅网络处理
local msgHall					--消息层

--创建回调
function LayerHallRoom:onCreate()
	--大厅网络接口
	clSocketHelper = g_Global.Hall.SocketHelper
	msgHall = g_Global.Hall.msgHall

	--查找主节点
	local layerNode = self:getChildByName("Layer")
	if (layerNode==nil) then
		LCLog("LayerMainHall:onCreate() 主图层节点未能找到")
		return
	end
	
	--游戏种类
	self.kindID = nil

	--添加按钮控制
	self.PanelItem = {}

	--页面控件
	self.BtnBack = layerNode:getChildByName("btn_Back")
	self.TxtRoomName = layerNode:getChildByName("Text_RoomName")

	--房间面板
	self.PanelItem[1] = layerNode:getChildByName("Panel_Room1")
	self.PanelItem[2] = layerNode:getChildByName("Panel_Room2")
	self.PanelItem[3] = layerNode:getChildByName("Panel_Room3")
	self.PanelItem[4] = layerNode:getChildByName("Panel_Room4")
	self.PanelItem[5] = layerNode:getChildByName("Panel_Room5")

	--返回按钮的响应
	self.BtnBack:addClickEventListener(handler(self, self.backBtnCliCallBack))

	--初始数据
	self.TxtRoomName:setString("游戏房间")
	self.PanelItem[1]:setVisible(false)
	self.PanelItem[2]:setVisible(false)
	self.PanelItem[3]:setVisible(false)
	self.PanelItem[4]:setVisible(false)
	self.PanelItem[5]:setVisible(false)

	--添加按钮响应
	for i=1,5 do
		local btnGame = self.PanelItem[i]:getChildByName("btnItem")
		btnGame:setTag(i)
		btnGame:addClickEventListener(handler(self, self.gameBtnCliCallBack))
	end

	--添加网络读取
	clSocketHelper:RegisterHanderSink(3,handler(self,LayerHallRoom.OnEventRead))
end

function LayerHallRoom:onExit()
    cc.Node:onExit()
    
    --关闭网络读取
	clSocketHelper:DelRegHanderSink(3,handler(self,LayerHallRoom.OnEventRead))
end

function LayerHallRoom:OnEventRead(socketID,mainID,subID,packetInfo)
	LCLog("收到房间消息：main="..tostring(mainID)..' sub='..tostring(subID))
	--大厅服务器信息
	if mainID==msgHall.MOB_LM_HALL then
		if subID==msgHall.CMD_LS_ReqRoomRltInfo then
			LCLog("读取房间信息：")
			local wKindID = packetInfo:read2Byte()
			local wSrvPort = packetInfo:read2Byte()
			LCLog("读取房间信息：kind="..tostring(wKindID).." port="..tostring(wSrvPort))
			--启动游戏场景
			g_Global.Hall.tbFrames:ReSetGame(wKindID,wSrvPort)
			local gameScene = require("app.views.scene.GameScene"):new("GameScene")
			gameScene:showGameScene(wKindID)

			LCLog("读取房间信息："..tostring(wKindID).." 端口："..tostring(wSrvPort))
		elseif subID==msgHall.CMD_LS_ReqRoomRltFail then
			LCLog("未能读取到【房间】信息")
		end
	end
end

--点击选择房间
function LayerHallRoom:gameBtnCliCallBack(btnItem)
	-- body
	local nIndex = btnItem:getTag()
	local gameRoom = ListGameKind[self.kindID].aryRoom

	LCLog("选择房间："..tostring(nIndex)..' kindid='..tostring(self.kindID))

	-- 请求房间
	local pakSend = lc.PacketAide:GetInstance()
	pakSend:setPosition(0)
	pakSend:write2Byte(self.kindID)
	pakSend:write4Byte(gameRoom[nIndex].nCellScore)
	pakSend:write4Byte(gameRoom[nIndex].nLessScore)
	clSocketHelper:SendData(msgHall.MOB_LM_HALL,msgHall.CMD_LC_ReqGameRoom,pakSend)

	LCLog("选择===》"..tostring(self.kindID)..' '..tostring(gameRoom[nIndex].nCellScore)..' '..tostring(gameRoom[nIndex].nLessScore))

end

--点击返回大厅
function LayerHallRoom:backBtnCliCallBack(btnItem)
	-- 返回大厅面板
	local nodeParent = self:getParent()
    nodeParent:removeChild(self)

    LCLog("返回大厅面板成功！")
end

function LayerHallRoom:SetGameItem(wKindID)
	--查询该游戏
	local gameKind = ListGameKind[wKindID]
	local gameRoom = gameKind.aryRoom
	if gameRoom == nil then 
		LCLog("竟然没有找到该游戏: "..tostring(wKindID))
		return
	end

	--记录游戏种类
	self.kindID = wKindID

	--房间设置
	for i=1,gameKind.wRoomCount do
		--查找面板节点
		local nodePanel = self.PanelItem[i]
		if nodePanel==nil then return end

		--设置面板数据
		nodePanel:setVisible(true)
		local textName = nodePanel:getChildByName("Text_Name")
		local textScore = nodePanel:getChildByName("Text_Score")
		if (textName~=nil and textScore~=nil) then
			textName:setString("底分:"..tostring(gameRoom[i].nCellScore))
			textScore:setString("入场:"..tostring(gameRoom[i].nLessScore))
		end
	end

	--房间名字
	self.TxtRoomName:setString(gameKind.szKindName)

end

return LayerHallRoom

