--------------------------------------------------------------
--游戏定义
g_Global.Hall.GameKind = {
	GK_Type_Hall			= 0,		--//大厅

	-- //游戏种类编号
	GK_JieJi_BJL			= 210,		--//百家乐
	GK_JieJi_DaBaiSha		= 220,		--//大白鲨	（ 百人、单机类游戏 ）
	GK_JieJi_PaoMaJi		= 230,		--//跑马机
	GK_JieJi_ShuiHuZhuan	= 240,		--//水浒传
	GK_JieJi_LaBa			= 250,		--//拉霸
	GK_JieJi_LMZ			= 260,		--//龙门镇
	GK_JieJi_ShuiGuoJi		= 270,		--//水果机

	GK_MJ_ErRenMJ			= 310,		--//二人麻将	（ 麻将类游戏 ）
	GK_MJ_XueZhanMJ			= 320,		--//血战麻将

	GK_Puke_Srnn			= 410,		--//四人牛牛 （ 扑克类游戏 ）
	GK_Puke_Ysz				= 420,		--//赢三张
	GK_Puke_MaGu			= 430,		--//马古
	GK_Puke_Ddz				= 440,		--//斗地主
	GK_Puke_Dzpk			= 450,		--//德州扑克
	GK_Puke_Ernn			= 460,		--//二人牛牛

	GK_HL_NiuNiu			= 510,		--//欢乐牛牛 （ 系统坐庄，玩家押注，系统赔多倍类游戏 ）
	GK_HL_SanZhang			= 520,		--//欢乐三张
	GK_HL_ErShiYiD			= 530,		--//二十一点

	GK_Fish_Lkpy			= 610,		--//李逵劈鱼 （ 16100——16110——16120——16130——16140——16150 ）
	GK_Fish_Jcby			= 620,		--//金蟾捕鱼
	GK_Fish_Dntg			= 630,		--//大闹天宫
	GK_Fish_Sstx			= 640,		--//神兽天下
}

--------------------------------------------------------------
--状态定义
g_Global.Hall.UserStatus = {
	US_NULL 				= 0,		--//没有状态
	US_FREE					= 1,		--//站立状态
	US_SIT					= 2,		--//坐下状态
	US_READY				= 3,		--//同意状态
	US_LOOKON				= 4,		--//旁观状态
	US_PLAY					= 5,		--//游戏状态
	US_OFFLINE				= 6,		--//断线状态
}

--------------------------------------------------------------
--无效定义
g_Global.Hall.Invalid = {
	INVALID_BYTE 			= 0xff,
	INVALID_WORD 			= 0xffff,
	INVALID_DWORD 			= 0xffffffff,		--表16进制(0xffffffff)
	INVALID_TABLE 			= 0xffff,
	INVALID_CHAIR 			= 0xffff,
}

--------------------------------------------------------------



