-- 游戏帮助节点
local NDGameHelper = class("NDGameHelper", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDGameHelper:onCreate()
	--
end
--进入游戏
function NDGameHelper:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDGameHelper:onExit()
    cc.Node:onExit()
end

return NDGameHelper