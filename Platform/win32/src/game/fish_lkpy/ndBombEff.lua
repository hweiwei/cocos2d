-- 炸弹特效节点
local NDBombEff = class("NDBombEff", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDBombEff:onCreate()
    --
end
--进入游戏
function NDBombEff:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDBombEff:onExit()
    cc.Node:onExit()
end

--创建动画 (产生炸弹特效动画)
function NDBombEff:BornBombEff( effType, xx, yy )
    --效验参数
    if effType>2 or effType<=0 then return end

    --创建动画节点
    local ndBomb = require("game.fish_lkpy.ndBombItem"):new("NDBombItem")
    self:addChild(ndBomb)
    ndBomb:BornBombEff(effType)
    ndBomb:setPosition(xx, yy)
end

return NDBombEff