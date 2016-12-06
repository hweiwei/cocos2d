-- 炸弹特效节点
local NDBombItem = class("NDBombItem", cc.load("mvc").ViewBase)

--创建游戏视图
function NDBombItem:onCreate()
    self.ndBomb = nil
    self.antAction = nil

    --文件名
    local szEffFileName = "res/Game/Lkpy/Node_M_BombEff.csb"
    
	--创建动画节点
    self.ndBomb = cc.CSLoader:createNode(szEffFileName)
    self:addChild(self.ndBomb)

    --创建时间线
    self.antAction = cc.CSLoader:createTimeline(szEffFileName)
    if self.antAction~=nil then
        self.ndBomb:runAction(self.antAction)
        self.antAction:setFrameEventCallFunc(handler(self,self.onFrameEvent))
    end
end

--创建动画 (产生炸弹特效动画)
function NDBombItem:BornBombEff( effType )
    --效验参数
    if effType>2 or effType<=0 then return end

    --产生动画
    local szMovieName = {"bombFire","bombIce"}
    if self.antAction~=nil then
        self.antAction:play(szMovieName[effType], false)
    end
end

function NDBombItem:onFrameEvent()
    -- body
    self:removeFromParent()
    --LCLog("动画结束------------------------->")
end

return NDBombItem