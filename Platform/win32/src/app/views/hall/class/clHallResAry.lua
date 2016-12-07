----------------------------------------------------------------------------------
--大厅资源类
-- 1 用于加载大厅资源的管理
----------------------------------------------------------------------------------
local HallResAry_cl = class("HallResAry_cl")

function HallResAry_cl:ctor()
	self.nResIndex = 0					--资源所有
	self.nResTotal = 0					--资源数量
	self.hallResAry =					--资源数组
	{
		
		"res/HallMain/HallMainPage.plist",
		"res/HallMain/HallGameImgA.plist",
		"res/HallMain/HallGameImgB.plist",
		"res/HallMain/HallFace.plist",
		"res/HallMain/HallRoom.plist",
	}
end

function HallResAry_cl:InitLoadRes()
	--初始化数据
	self.nResIndex = 0
	self.nResTotal = table.getn(self.hallResAry)
end

function HallResAry_cl:LoadHallRes()
	-- 效验资源数量
	if self.nResTotal == 0 then return 100 end
	if self.nResIndex >= self.nResTotal then return 100 end

	-- 加载资源
	self.nResIndex = self.nResIndex + 1
	cc.SpriteFrameCache:getInstance():addSpriteFrames(self.hallResAry[self.nResIndex]) 

	-- 返回进度
	return self.nResIndex * 100 / (self.nResTotal+1)
end

return HallResAry_cl



