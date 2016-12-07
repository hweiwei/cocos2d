---------------------------------------------------------------------------
--游戏房间消息
---------------------------------------------------------------------------
--消息定义
g_Global.Hall.msgRoom = {
	-------------------------------------------------------
	--房间登陆
	-------------------------------------------------------
 	MDM_GR_LOGON				= 1,		--房间登录

	SUB_GR_LOGON_ACCOUNTS		= 1,		--帐户登录
	SUB_GR_LOGON_USERID			= 2,		--I D 登录

	SUB_GR_LOGON_SUCCESS		= 100,		--登录成功
	SUB_GR_LOGON_ERROR			= 101,		--登录失败
	SUB_GR_LOGON_FINISH			= 102,		--登录完成
	-------------------------------------------------------
	--房间请求
	-------------------------------------------------------
	MDM_GR_USER					= 2,		--用户信息

	SUB_GR_USER_SIT_REQ			= 1,		--坐下请求
	SUB_GR_USER_LOOKON_REQ		= 2,		--旁观请求
	SUB_GR_USER_STANDUP_REQ		= 3,		--起立请求
	SUB_GR_USER_LEFT_GAME_REQ	= 4,		--离开游戏

	SUB_GR_USER_COME			= 100,		--用户进入
	SUB_GR_USER_STATUS			= 101,		--用户状态
	SUB_GR_USER_SCORE			= 102,		--用户分数
	SUB_GR_SIT_FAILED			= 103,		--坐下失败
	SUB_GR_USER_RIGHT			= 104,		--用户权限
	SUB_GR_MEMBER_ORDER			= 105,		--会员等级
	SUB_GR_MATCHUSER_COME		= 106,		--用户进入

	SUB_GR_USER_CHAT			= 200,		--聊天消息
	SUB_GR_USER_WISPER			= 201,		--私语消息
	SUB_GR_USER_RULE			= 202,		--用户规则

	SUB_GR_USER_INVITE			= 300,		--邀请消息
	SUB_GR_USER_INVITE_REQ		= 301,		--邀请请求
	-------------------------------------------------------
	--配置信息
	-------------------------------------------------------
	MDM_GR_INFO					= 3,		--配置信息

	SUB_GR_SERVER_INFO			= 100,		--房间配置
	SUB_GR_ORDER_INFO			= 101,		--等级配置
	SUB_GR_MEMBER_INFO			= 102,		--会员配置
	SUB_GR_COLUMN_INFO			= 103,		--列表配置
	SUB_GR_CONFIG_FINISH		= 104,		--配置完成
	-------------------------------------------------------
	--桌子信息
	-------------------------------------------------------
	MDM_GR_STATUS				= 4,		--状态信息

	SUB_GR_TABLE_INFO			= 100,		--桌子信息
	SUB_GR_TABLE_STATUS			= 101,		--桌子状态
	-------------------------------------------------------
	--游戏消息,框架消息
	-------------------------------------------------------
	MDM_GF_GAME					= 100,		--游戏消息
	MDM_GF_FRAME				= 101,		--框架消息
	MDM_GF_PRESENT				= 102,		--礼物消息
	MDM_GF_BANK					= 103,		--银行消息

	SUB_GF_INFO					= 1,		--游戏信息
	SUB_GF_USER_READY			= 2,		--用户同意
	SUB_GF_LOOKON_CONTROL		= 3,		--旁观控制
	SUB_GF_KICK_TABLE_USER		= 4,		--踢走用户

	SUB_GF_OPTION				= 100,		--游戏配置
	SUB_GF_SCENE				= 101,		--场景信息

	SUB_GF_USER_CHAT			= 200,		--用户聊天

	SUB_GF_MESSAGE				= 300,		--系统消息
}




