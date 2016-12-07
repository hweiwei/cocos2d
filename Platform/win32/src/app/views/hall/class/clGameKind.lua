
local GameKind_cl = class("GameKind_cl")

function GameKind_cl:ctor()
	--基本信息
	self.wKindID = 0			--游戏类型
	self.wSortID = 0			--排序索引
	self.szKindName = ""		--游戏名字
	self.wRoomCount = 0
	self.aryRoom = {}			--房间数组
	for i=1,6 do
		self.aryRoom[i] = {}
		self.aryRoom[i].nCellScore = 0
		self.aryRoom[i].nLessScore = 0
	end	
end

return GameKind_cl

