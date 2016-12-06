-- 捕鱼分数节点
local NDCatchNum = class("NDCatchNum", cc.load("mvc").ViewBase)

--框架体
--g_Global.Hall.tbFrames

--创建游戏视图
function NDCatchNum:onCreate()
	--
end
--进入游戏
function NDCatchNum:onEnter()
    cc.Node:onEnter()
end

--离开游戏
function NDCatchNum:onExit()
    cc.Node:onExit()
end

return NDCatchNum