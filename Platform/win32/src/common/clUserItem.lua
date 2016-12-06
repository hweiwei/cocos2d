
local UserItem_cl = class("UserItem_cl")

function UserItem_cl:ctor()
	--基本信息
	self.wFaceID = 0			--头像索引
	self.dwUserID = 0			--用户ID
	self.dwGameID = 0			--游戏ID
	self.cbGender = 0			--性别
	
	self.wTableID = 0			--桌子号码
	self.wChairID = 0			--椅子位置
	self.cbUserStatus = 0		--用户状态
			
	self.lScore = 0				--分数信息
	
	self.szAccounts = ""		--玩家账号
	self.szNickName = ""		--玩家昵称
	self.szArea = ""			--玩家地域
	self.szUnderWrite = ""		--玩家签名				
end

return UserItem_cl

