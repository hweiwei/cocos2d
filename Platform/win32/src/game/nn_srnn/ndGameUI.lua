-- 游戏UI节点
local NDGameUI = class("NDGameUI", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDGameUI:onCreate()
	--创建UI节点
	self.ndUI = cc.CSLoader:createNode("Game/Srnn/Layer_Game.csb")
	self:addChild(self.ndUI)
	--记录位置
	self:InitUserPos()
	--初始关闭面板
	for i=1,4 do
		self:UserLeave(i-1)
	end
end

--进入游戏
function NDGameUI:onEnter()
    cc.Node:onEnter()
end
--离开游戏
function NDGameUI:onExit()
    cc.Node:onExit()
end
--记录位置
function NDGameUI:InitUserPos()
 	--玩家位置
 	local userPos = g_Global.Game.Srnn.UserPos
 	--提取位置
 	for i=0,3 do
 		--获取面板
		local szPanel = "Panel_UI_"..tostring(i)
		local ndPanel = self.ndUI:getChildByName(szPanel)
		if ndPanel~=nil then
			local sprGun = ndPanel:getChildByName("nn_gamebg")
			if sprGun~=nil then
				local xx,yy = sprGun:getPosition()
				local worldpp = ndPanel:convertToWorldSpace(cc.p(xx,yy)) 
				--local xx,yy = sprGun:getPosition()
				userPos[i*2] = worldpp.x
				userPos[i*2+1] = worldpp.y
				LCLog(" 玩家坐标： num="..tostring(i).." x="..tostring(xx).." y="..tostring(yy)
					.." wx="..tostring(worldpp.x).." wy="..tostring(worldpp.y))
			end
		end
 	end
 end

--玩家进入
function NDGameUI:UserEnter(pos,userItem)
	--效验参数
	if pos > 4 or pos < 0 then return end
	--获取面板
	local szPanel = "Panel_UI_"..tostring(pos)
	local ndPanel = self.ndUI:getChildByName(szPanel)
	if ndPanel==nil then return end
	ndPanel:setVisible(true)
	--玩家昵称
	self:SetNameInPanel(ndPanel,userItem.szNickName)
	--玩家金币数
	self:SetChipInPanel(ndPanel,0)
	--按钮控制
	self:SetGunBtnInPanel(ndPanel,false)
	--如果是自己
	if userItem.dwUserID == g_GlobalUserData.dwUserID then
		--按钮控制
		self:SetGunBtnInPanel(ndPanel,true)
	end
end
--玩家离开
function NDGameUI:UserLeave(pos)
	--效验参数
	if pos > 4 or pos < 0 then return end
	--获取面板
	local szPanel = "Panel_UI_"..tostring(pos)
	local ndPanel = self.ndUI:getChildByName(szPanel)
	if ndPanel~=nil then
		ndPanel:setVisible(false)
	end
end
--面板控制
function NDGameUI:SetNameInPanel(ndPanel,szNickName)
	--获取名字
	local ndNickName = ndPanel:getChildByName("Text_Name")
	if ndNickName~=nil then
		ndNickName:setString(szNickName)
	end
end
--面板控制
function NDGameUI:SetChipInPanel(ndPanel,lScore)
	--获取分数
	local ndChip = ndPanel:getChildByName("Text_Score")
	if ndChip~=nil then
		ndChip:setString(tostring(lScore))
	end
end

--面板控制
function NDGameUI:SetGunBtnInPanel(ndPanel,isVisible)
	--获取换炮按钮
	local btnAdd = ndPanel:getChildByName("btnAdd")
	if btnAdd~=nil then
		btnAdd:setVisible(isVisible)
	end
	local btnDec = ndPanel:getChildByName("btnDec")
	if btnDec~=nil then
		btnDec:setVisible(isVisible)
	end
	local function cliAddCallBack(item)
		LCLog("添加炮数")
	end
	local function cliDecCallBack(item)
		LCLog("减少炮数")
	end
	if isVisible then
		btnAdd:addClickEventListener(cliAddCallBack)
		btnDec:addClickEventListener(cliDecCallBack)
	end
end
--设置玩家分数
function NDGameUI:SetUserFishScore(pos, lScore)
	--效验参数
	if pos > 4 or pos < 0 then return end
	--获取面板
	local szPanel = "Panel_UI_"..tostring(pos)
	local ndPanel = self.ndUI:getChildByName(szPanel)
	if ndPanel~=nil then
		self:SetFishScoreInPanel(ndPanel,lScore)
	end
end

return NDGameUI


