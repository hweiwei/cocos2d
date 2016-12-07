-- 加载层
local LayerHallLoading = class("LayerHallLoading", cc.load("mvc").ViewBase)
LayerHallLoading.RESOURCE_FILENAME = "HallLoading/Layer_HLoading.csb"


local clResAry 			--大厅资源
local spr_Prg           --进度节点    
local rect_Prg          --进度图
local nPrgNum           --进度

local tbSocketMG        --网络登陆管理

function LayerHallLoading:onCreate()
	--设置加载资源
	clResAry = require("app.views.hall.class.clHallResAry"):new("HallResAry_cl")
	clResAry:InitLoadRes()

	-- 提取进度图片尺寸
    local nodeCsb = self:getChildByName("Layer")
    if nodeCsb==nil then LCLog("没找到加载图层") end
    spr_Prg = nodeCsb:getChildByName("prg_run")
    if spr_Prg==nil then LCLog("没找到图片精灵") end
    rect_Prg = spr_Prg:getTextureRect()

    --设置进度
    nPrgNum = 0
    self:SetProgress(nPrgNum)

	--启动循环
    self:scheduleUpdateWithPriorityLua(handler(self,self.updateLoadRes), 0)

    --启动网络登陆
    tbSocketMG = g_Global.Hall.tbSocketManager
    tbSocketMG:StartService()
end

function LayerHallLoading:updateLoadRes()
    if nPrgNum < 100 then
        --加载资源,设置进度
    	nPrgNum = clResAry:LoadHallRes()
        self:SetProgress(nPrgNum)
    elseif nPrgNum == 100 then
        --检测网络是否加载完毕
        if tbSocketMG:IsLogonOver() then
            nPrgNum = 101
        end
    elseif nPrgNum == 101 then
        --一次性转移到其他场景
        nPrgNum = 102
        self:TurnToMainLayer()
    end
end

function LayerHallLoading:SetProgress( prgNum )
    --计算区域
    local rectTmp = cc.rect(2,644,prgNum*rect_Prg.width/100,rect_Prg.height)

    --设置进度图
    spr_Prg:setTextureRect(rectTmp)
end

function LayerHallLoading:TurnToMainLayer()
    local nodeParent = self:getParent()
    nodeParent:removeAllChildren()
    nodeParent:addChild(require("app.views.hall.layer.LayerMainHall"):new("LayerMainHall"))
end

return LayerHallLoading


