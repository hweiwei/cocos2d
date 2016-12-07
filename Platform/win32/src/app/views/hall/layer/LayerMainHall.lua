
--加载层
local LayerMainHall = class("LayerMainHall", cc.load("mvc").ViewBase)
LayerMainHall.RESOURCE_FILENAME = "HallMain/Layer_MainPage.csb"

--局部成员变量
local clSocketHelper			--大厅网络处理
local msgHall					--消息层

--创建回调
function LayerMainHall:onCreate()
	--大厅网络接口
	clSocketHelper = g_Global.Hall.SocketHelper
	msgHall = g_Global.Hall.msgHall

	--查找主节点
	local layerNode = self:getChildByName("Layer")
	if (layerNode==nil) then
		LCLog("LayerMainHall:onCreate() 主图层节点未能找到")
		return
	end
	
	--游戏按钮列表
	self.ItemBtn = {}

	--按钮移动位置
	self.moveTag = 0
	self.MoveX = 0
	self.TouchMoveX = 0
	self.MoveMax = 40 - 1366

	--成员按钮
	self.Btn_Bank = layerNode:getChildByName("Btn_Bank")
	self.Btn_Give = layerNode:getChildByName("Btn_Give")
	self.Btn_Value = layerNode:getChildByName("Btn_Value")
	self.Btn_Ranking = layerNode:getChildByName("Btn_Ranking")

	--成员节点
	self.txtGameID = layerNode:getChildByName("Text_GameID")
	self.txtNickname = layerNode:getChildByName("Text_Nickname")
	self.txtScore = layerNode:getChildByName("Text_Score")

	--初始赋值
	self.txtGameID:setString("游戏ID:"..tostring(g_GlobalUserData.dwGameID))
	self.txtNickname:setString("昵称:"..g_GlobalUserData.szNickName)
	self.txtScore:setString("分数:"..tostring(g_GlobalUserData.lScore))

	--设置按钮响应
	self:SetHallBtnListener(layerNode)

	--设置按钮监听响应
	self:SetGameItemBtnListener(layerNode)

	--头像显示
	--设置中心显示游戏项

	-----------------------------------------------------------------------------
	--这里测试下鱼类
    -- --添加鱼
    -- local clFishItem = require("game.fish_lkpy.ndFishItem"):new("NDFishItem")
    -- self:addChild(clFishItem)
    -- --激活鱼
    -- local nFishID = math.random(1000,5000)
    -- local nFishType = math.random(1,24)
    -- local nFishX = { 650, math.random(100,1020)}
    -- local nFishY = { 380, math.random(10,720)}
    -- clFishItem:ActiveFish(nFishID, nFishType, 2, nFishX, nFishY)
    -----------------------------------------------------------------------------
end

--网络链接
function LayerMainHall:OnEventLink(socketID,err)
	LCLog("网络消息--链接")
end

--网络关闭
function LayerMainHall:OnEventShut(socketID,err)
	LCLog("网络消息--关闭")
end

--网络读取
function LayerMainHall:OnEventRead(socketID,mainID,subID,packetInfo)
	LCLog("网络消息--读取 主命令："..tostring(mainID).."  子命令："..tostring(subID))
	if mainID==msgHall.MOB_LM_LOGON then
		--大厅消息处理
	end
end

--大厅按钮响应
function LayerMainHall:SetHallBtnListener(layerNode)
	--按钮监听写法
	--self.btn_login:addClickEventListener(handler(self, self.loginCallback))
	--排行榜按钮
	self.Btn_Ranking:addClickEventListener(function(sender)
		--你的按钮事件处理
		LCLog("排行榜按钮响应")
	end)

	--银行按钮
	self.Btn_Bank:addClickEventListener(function(sender)
		--你的按钮事件处理
		LCLog("银行按钮响应")
	end)
end

--大厅按钮响应
function LayerMainHall:SetGameItemBtnListener(layerNode)
	--游戏宏
	local kindDef = g_Global.Hall.GameKind
	--游戏列表
	local kindResList = {
		["Btn_Fish_Lkpy"] = kindDef.GK_Fish_Lkpy,
		["Btn_Fish_Dntg"] = kindDef.GK_Fish_Dntg,
		["Btn_Niu_Srnn"] = kindDef.GK_Puke_Srnn,
		["Btn_Niu_Hlnn"] = kindDef.GK_HL_NiuNiu,
		["Btn_Pk_Esyd"] = kindDef.GK_HL_ErShiYiD,
		["Btn_Hun_Bjl"] = kindDef.GK_JieJi_BJL,
		["Btn_Niu_Ernn"] = kindDef.GK_Puke_Ernn,
	}

	--为按钮设置监听
	for k,v in pairs(kindResList) do
		--缓存按钮
		local btnTmp = layerNode:getChildByName(k)

		--效验是否开启
		if ListGameKind[v]==nil then 
			btnTmp:setVisible(false)
		else
			--添加监听
			btnTmp:setTag(v)
			btnTmp:addClickEventListener(handler(self, self.gameBtnCliCallBack))
			btnTmp:addTouchEventListener(handler(self, self.gameBtnTouchCallBack))
			self.ItemBtn[v] = btnTmp

			--计算移动最大距离
			self.MoveMax = self.MoveMax + 360
		end
	end

	--为游戏按钮排序
	self:updateGameBtnPos()
end

function LayerMainHall:gameBtnCliCallBack(btnItem)
	-- body
	LCLog("点击游戏："..tostring(btnItem:getTag()))

	--创建游戏房间
	local itemGame = require("app.views.hall.layer.LayerHallRoom"):new("LayerHallRoom")
    self:addChild(itemGame)
    itemGame:SetGameItem(btnItem:getTag())
    LCLog("创建游戏房间成功！")
end

function LayerMainHall:gameBtnTouchCallBack(btnItem,touchType)
	-- body
	local beginPosX = btnItem:getTouchBeganPosition().x
	local movPosX = btnItem:getTouchMovePosition().x
	local endPosX = btnItem:getTouchEndPosition().x
		
	--记录移动目标
	if touchType == 0 then 			--起始点
		--记录移动目标
		if self.moveTag == 0 then 
			self.moveTag = btnItem:getTag()
		else 
			return
		end	
	elseif touchType == 1 then		--移动点
		--判断是否原始目标
		if self.moveTag ~= btnItem:getTag() then return end
		--缓冲位置
		self.TouchMoveX = movPosX - beginPosX
		--修正位置
		if self.MoveX+self.TouchMoveX > 0 then 
			self.TouchMoveX = -self.MoveX 
		elseif self.MoveX+self.TouchMoveX < -self.MoveMax then 
			self.TouchMoveX = -self.MoveX - self.MoveMax
		end
		if self.MoveX+self.TouchMoveX > 0 then self.TouchMoveX = 0 end
	elseif touchType == 2 then 		--终点
		--判断是否原始目标
		if self.moveTag ~= btnItem:getTag() then return end
		self.moveTag = 0
		--确定新位置
		self.MoveX = self.MoveX + endPosX - beginPosX
		self.TouchMoveX = 0
		--修正位置
		if self.MoveX < -self.MoveMax then self.MoveX = -self.MoveMax end
		if self.MoveX > 0 then self.MoveX = 0 end
	elseif touchType == 3 then 		--取消点
		--判断是否原始目标
		if self.moveTag ~= btnItem:getTag() then return end
		self.moveTag = 0
		--确定新位置
		self.MoveX = self.MoveX + movPosX - beginPosX
		self.TouchMoveX = 0
		-- --修正位置
		-- if self.MoveX > 0 then 
		-- 	self.MoveX = 0 
		-- elseif self.MoveX < -self.MoveMax then
		-- 	self.MoveX = -self.MoveMax
		-- end
		--修正位置
		if self.MoveX < -self.MoveMax then self.MoveX = -self.MoveMax end
		if self.MoveX > 0 then self.MoveX = 0 end
	end	

	--更新按钮位置
	self:updateGameBtnPos()
end

--更新游戏按钮位置
function LayerMainHall:updateGameBtnPos()
	local offX = 195		--第一张图位置
	local offY = 380		--第一张图位置
	local offSpace = 360	--两按钮间隔
	local num = 0			--第几个按钮
	for k,v in pairs(self.ItemBtn) do
		--计算X坐标，设置位置
		local xx = self.MoveX + self.TouchMoveX + offX + offSpace*num
		v:setPosition(xx,offY)
		num = num + 1
	end
end

return LayerMainHall

