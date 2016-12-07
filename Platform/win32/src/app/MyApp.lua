
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
	--加载LOGO资源
    cc.SpriteFrameCache:getInstance():addSpriteFrames("res/Logo/logoImg.plist") 
    math.randomseed(os.time())
end

return MyApp
