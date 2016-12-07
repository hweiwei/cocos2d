-- 定义为大厅类
local HallScene = class("HallScene", cc.load("mvc").ViewBase)

--加载网络消息
require("app.views.hall.msg.msgHallDef")
require("app.views.hall.msg.msgRoomDef")
require("app.views.hall.msg.GameDef")

--全局变量定义
g_Global.Hall.SocketHelper = lc.SocketHelper:new()
g_Global.Hall.tbSocketManager = require("app.views.hall.tb.tbSocketManager")
g_Global.Hall.tbFrames = require("app.views.hall.tb.tbFramesManager")
                                                    
--缩写
local tbSocketMG = g_Global.Hall.tbSocketManager

function HallScene:onCreate()
    LCLog("HallScene:onCreate()")
    --加载loading资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("HallLoading/HLoading.plist")  
end

-- 进入场景层
function HallScene:onEnter()
    cc.Node:onEnter()
    LCLog("HallScene:onEnter()")

    --初始化大厅网络管理
    tbSocketMG:Init()

    --网络循环
    local function updateHallSocketRun(delta)
        --循环网络
        tbSocketMG:Update()
    end

    -- 启动循环
    self:scheduleUpdateWithPriorityLua(updateHallSocketRun,0)

    -- 创建加载层
    local layer_HLoading = require("app.views.hall.layer.LayerLoading"):new("LayerHallLoading")
    self:addChild(layer_HLoading)
end
 
 -- 离开场景层
function HallScene:onExit()
    cc.Node:onExit()

end

return HallScene


