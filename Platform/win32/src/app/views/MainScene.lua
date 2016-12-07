-- 定义为首页log类
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
MainScene.RESOURCE_FILENAME = "res/Logo/Layer_Logo.csb"

-- 变量申明
local clDown            -- 下载类
local curLayer          -- 当前层节点
local nDownStatus       -- 下载状态
local nRunFrame         -- 运行帧数
local bUpdateOver       -- 更新完成

function MainScene:onCreate()
    -- 下载类
    nRunFrame = 0
    nDownStatus = -1
    bUpdateOver = false
    clDown = lc.LCDownLoad_cl:GetInstance()

    -- 保存当前使用层
    curLayer = self:getChildByName("Layer")
    curLayer:getChildByName("Text_Update"):setString("正在检测更新，请稍后...")

    -- 启动循环
    self:scheduleUpdateWithPriorityLua(handler(self,self.updateLogo), 0)
end

-- 进入场景层
function MainScene:onEnter()
    cc.Node:onEnter()
    LCLog("进入场景_Logo场景")
end
 
 -- 离开场景层
function MainScene:onExit()
    cc.Node:onExit()
    LCLog("离开场景_Logo场景")
end

-- 更新LOGO场景层
function MainScene:updateLogo(delta)  
    -- 统计运行帧
    nRunFrame=nRunFrame+1

    --更新完成即转换场景
    if bUpdateOver then
        self:onTurnHallSence() 
        return
    end

    -- 更新进度
    local nPrg = clDown:UpdateRes(nDownStatus)
    
    -- 更新失败
    if nPrg < 0 then
        -- 显示文字
        curLayer:getChildByName("Text_Update"):setString("服务器正在维护中...")
    end

    -- 主MD5更新
    if nDownStatus < 0 then
        -- 主MD5更新完成，开始更新大厅
        if nPrg == 101 then
            -- 检测是否需要更新大厅
            if(clDown:IsNeedUpdate(0)) then 
                nDownStatus = 0
                LCLog("大厅需更新 ~ 继续更新大厅")
            else
                if nRunFrame > 45 then 
                    LCLog("大厅无需更新 ~ 转下一个场景")
                    self:onTurnHallSence()  
                end
            end
        end 
    else
        if nPrg == 101 then
            -- 转换场景
            LCLog("更新完成 ~ 转下一个场景")
            self:onReloadLua()
            bUpdateOver = true 
        elseif nPrg > 1 then
            -- 显示文字
            curLayer:getChildByName("Text_Update"):setString("正在更新文件[ "..tostring(nPrg).."% ]请耐心等候...")
        end
    end
end

-- 转换游戏场景
function MainScene:onReloadLua()
    --重新加载脚本文件
    LCLog("重载文件完成===[ 1 ]===>")
    --reload_script_files()
    LCLog("重载文件完成===[ 2 ]===>")
end

-- 转换游戏场景
function MainScene:onTurnHallSence()
    LCLog("准备转换场景")

    -- TransitionFade:TransitionCrossFade
    local layer = require("app.views.scene.HallScene"):new("HallScene")
    
    --检验加载,显示场景
    if layer == nil then return end
    layer:showWithScene() 

    LCLog("转到大厅场景去===[ 3 ]===>")
end

return MainScene


