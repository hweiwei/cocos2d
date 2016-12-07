
local GameScene = class("GameScene", cc.load("mvc").ViewBase)

local tbKindDef = g_Global.Hall.GameKind

--创建游戏场景
function GameScene:onCreate()
    local function updateTest(delta)
        --游戏循环
        g_Global.Hall.tbFrames:Update(delta)
    end

    -- 启动循环
    self:scheduleUpdateWithPriorityLua(updateTest,0)
 
    --获取游戏层
    local gameView = g_Global.Hall.tbFrames:CreateGameView()
    if gameView ~= nil then
        self:addChild(gameView)
    else
        LCLog("没找到游戏视图")
    end

    --启动游戏
    g_Global.Hall.tbFrames:StartService()

    --[[ you can create scene with following comment code instead of using csb file.
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)
    ]]
end

--进入游戏场景
function GameScene:onEnter()
    cc.Node:onEnter()
    LCLog("进入游戏场景开始处理：")
end

--离开游戏场景
function GameScene:onExit()
    cc.Node:onExit()
    LCLog("离开游戏场景")
end

--展示游戏场景
function GameScene:showGameScene(wKindID)
    if wKindID==tbKindDef.GK_Fish_Lkpy then
        self:showWithPhysicsScene()
        LCLog("————创建【物理引擎】场景————")
    else
        self:showWithScene()
        LCLog("————创建【普通】场景————")
    end
end

--使用物理引擎
function GameScene:showWithPhysicsScene(transition, time, more)
    self:setVisible(true)
    local scene = display.newScene(self.name_,{physics=true})
    scene:addChild(self)
    --scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL) 
    display.runScene(scene, transition, time, more)
    return self
end


return GameScene


