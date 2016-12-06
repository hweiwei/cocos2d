
--关闭置顶通知
cc.FileUtils:getInstance():setPopupNotify(false)

--全局定义
require "common.GlobalHeader"

--引擎及配置定义
require "config"
require "cocos.init"

--主函数
local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
