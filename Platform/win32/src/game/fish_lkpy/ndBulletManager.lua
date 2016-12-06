-- 子弹管理节点
local NDBulletManager = class("NDBulletManager", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDBulletManager:onCreate()
	--
end
--进入游戏
function NDBulletManager:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDBulletManager:onExit()
    cc.Node:onExit()
end

return NDBulletManager