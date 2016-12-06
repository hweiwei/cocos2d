-- 金币管理节点
local NDCoinManager = class("NDCoinManager", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDCoinManager:onCreate()
	--
end
--进入游戏
function NDCoinManager:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDCoinManager:onExit()
    cc.Node:onExit()
end

return NDCoinManager