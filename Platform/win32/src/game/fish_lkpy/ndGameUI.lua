-- 游戏UI节点
local NDGameUI = class("NDGameUI", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDGameUI:onCreate()
	--创建UI节点
	self.ndUI = cc.CSLoader:createNode("Game/Lkpy/Layer_FishUI.csb")
	self:addChild(self.ndUI)
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
	--玩家鱼分
	self:SetFishScoreInPanel(ndPanel,0)
	--玩家炮分
	self:SetGunNumInPanel(ndPanel,1000)
	--特殊子弹
	self:SetBulletIonInPanel(ndPanel,false)
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
function NDGameUI:SetFishScoreInPanel(ndPanel,lScore)
	--获取分数
	local ndFishScore = ndPanel:getChildByName("Text_Score")
	if ndFishScore~=nil then
		ndFishScore:setString(tostring(lScore))
	end
end
--面板控制
function NDGameUI:SetGunNumInPanel(ndPanel,nGunNum)
	--获取炮倍数
	local ndGunNum = ndPanel:getChildByName("Text_Gun")
	if ndGunNum~=nil then
		ndGunNum:setString(tostring(nGunNum))
	end
end
--面板控制
function NDGameUI:SetBulletIonInPanel(ndPanel,isVisible)
	--获取特殊子弹标记
	local ndIcon = ndPanel:getChildByName("card_ion")
	if ndIcon~=nil then
		ndIcon:setVisible(isVisible)
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
end
--设置玩家分数
function NDGameUI:SetUserFishScore(pos, lScore)
	--效验参数
	if pos > 4 or pos < 0 then return end
	--获取面板
	local szPanel = "Panel_UI_"..tostring(pos)
	local ndPanel = self.ndUI:getChildByName(szPanel)
	if ndPanel~=nil then
		ndPanel:SetFishScoreInPanel(lScore)
	end
end

return NDGameUI


