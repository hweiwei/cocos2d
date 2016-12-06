-- 加载层
local LyGameLoad = class("LyGameLoad", cc.load("mvc").ViewBase)

-----------------------------------
-- 父类接口
-- OnLoadingOver()
-----------------------------------

local spr_Prg           --进度节点    
local rect_Prg          --进度图
local nPrgNum           --进度

function LyGameLoad:onCreate()
	self.nResIndex = 0					--资源所有
	self.nResTotal = 0					--资源数量
	self.hallResAry = {}				--资源数组
end

--添加资源
function LyGameLoad:AddRes(resName)
	self.nResTotal = self.nResTotal + 1
	self.hallResAry[self.nResTotal] = resName
end

--设置加载
function LyGameLoad:StartLoading()
	-- 提取进度图片尺寸
    local nodeCsb = self:getChildByName("Layer")
    if nodeCsb==nil then LCLog("没找到加载图层") end
    spr_Prg = nodeCsb:getChildByName("prg_run")
    if spr_Prg==nil then LCLog("没找到图片精灵") end
    rect_Prg = spr_Prg:getTextureRect()

    LCLog("纹理："..tostring(rect_Prg.x).."/"..tostring(rect_Prg.y).."/"..tostring(rect_Prg.width).."/"..tostring(rect_Prg.height))

    --设置进度
    nPrgNum = 0
    self:SetProgress(nPrgNum)

	--启动循环
    self:scheduleUpdateWithPriorityLua(handler(self,self.updateLoadRes), 0)
end

--更新资源
function LyGameLoad:updateLoadRes()
    if nPrgNum < 100 then
        --加载资源,设置进度
    	nPrgNum = self:LoadPlistRes()
        self:SetProgress(nPrgNum)
    elseif nPrgNum == 100 then
        nPrgNum = 101
    elseif nPrgNum == 101 then
        --一次性转移到其他场景
        nPrgNum = 102
        self:TurnToLayerView()
    end
end

function LyGameLoad:SetProgress( prgNum )
    --计算区域
    local rectTmp = cc.rect(rect_Prg.x,rect_Prg.y,prgNum*rect_Prg.width/100,rect_Prg.height)

    --设置进度图
    spr_Prg:setTextureRect(rectTmp)
end

function LyGameLoad:TurnToLayerView()
    local nodeParent = self:getParent()
    nodeParent:removeChild(self)
	nodeParent:OnLoadingOver()
end

--加载资源
function LyGameLoad:LoadPlistRes()
	-- 效验资源数量
	if self.nResTotal == 0 then return 100 end
	if self.nResIndex >= self.nResTotal then return 100 end

	-- 加载资源
	self.nResIndex = self.nResIndex + 1
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.hallResAry[self.nResIndex]) 

    LCLog("缓存资源："..self.hallResAry[self.nResIndex])

	-- 返回进度
	return self.nResIndex * 100 / (self.nResTotal+1)
end

return LyGameLoad


