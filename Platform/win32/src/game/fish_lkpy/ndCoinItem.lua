-- 子弹管理节点
local NBulletManager = class("NBulletManager", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NBulletManager:onCreate()
	--
end
--进入游戏
function NBulletManager:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NBulletManager:onExit()
    cc.Node:onExit()
end

return NBulletManager