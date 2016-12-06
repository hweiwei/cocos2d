//////////////////////////////////////////////////////////////////////////
// 全局数据（函数）定义
#ifndef GLOBAL_DEFINE_FILE
#define GLOBAL_DEFINE_FILE

//////////////////////////////////////////////////////////////////////////
// 状态控制
#define IDI_CHECK_STATUS			0x01								//状态定时器
#define IDI_LOADGAME				0x02								//加载游戏

#define	IDI_GAME_START				0x03								//开始游戏（开始下注） 
#define	IDI_STOP_CHIP				0x04								//停止下注 
#define	IDI_RUN_START				0x05								//开始比赛 
#define	IDI_MATCH_OVER				0x06								//比赛结束 
#define IDI_CHIP_UPDATA				0x07								//刷新下注

#define IDI_ANDROID_CHAT			0x08								//机器人聊天

#define TIMER_CHECK_STATUS			1500								//状态定时
#define TIMER_LOADGAME				3000								//加载游戏

#define TIMER_START_BASE			1000								//开始基础时间
#define TIMER_GAMESTART				20000								//开始游戏（开始下注） 
#define TIMER_STOP_CHIP				2000								//停止下注
#define TIMER_MATCH_START			20000								//开始比赛（比赛时长）
#define TIMER_MATCH_OVER			5000								//比赛结束（中途休息）
#define TIMER_CHIP_UPDATA			1000								//更新下注

//////////////////////////////////////////////////////////////////////////
#define TIMER_NET_DELAY				1000								//预估网络延时

//////////////////////////////////////////////////////////////////////////
//出现几率
#define APPEAR_ODDS_ONE				80					//一号出现次数
#define APPEAR_ODDS_TWO				66					//二号出现次数
#define APPEAR_ODDS_THREE			55					//三号出现次数
#define APPEAR_ODDS_FOUR			40					//四号出现次数
#define APPEAR_ODDS_FIVE			15					//五号出现次数
#define APPEAR_ODDS_SIX				4					//六号出现次数

#define APPEAR_ODDS_MAX			(APPEAR_ODDS_ONE+APPEAR_ODDS_TWO+APPEAR_ODDS_THREE+APPEAR_ODDS_FOUR+APPEAR_ODDS_FIVE+APPEAR_ODDS_SIX)

//////////////////////////////////////////////////////////////////////////
//马儿数量
#define		HORSE_MAX				6					//马儿数量

//////////////////////////////////////////////////////////////////////////
//马儿速度段
#define		SPEED_SEGMENT			6					//马儿速度段

//////////////////////////////////////////////////////////////////////////
//倍率表
#define		MULTIPLE_MAX			15					//倍率数量

//////////////////////////////////////////////////////////////////////////
//最大历史组合保留
#define		HISTORYWEAV_MAX			15					//最大历史组合

//////////////////////////////////////////////////////////////////////////
//最大庄家显示
#define		SHOWZHUANG_MAX			6		

//////////////////////////////////////////////////////////////////////////
//最小当庄资金
#define		ZJNEEDMONEY_MIN			20000000


struct tagMultipleTable
{
	WORD		wNumber;			//数字
	WORD		wMultiple;			//倍率
};

static tagMultipleTable g_wMultipleTable[MULTIPLE_MAX] = 
{
	{0x16, 16}, {0x15, 11}, {0x14, 8},  {0x13, 5},  {0x12, 4},
	{0x26, 23}, {0x25, 16}, {0x24, 11}, {0x23, 8},
	{0x36, 32}, {0x35, 23}, {0x34, 16}, 
	{0x46, 40}, {0x45, 32}, 
	{0x56, 80}, 
};


static WORD GetDoubleByNumber(BYTE _byFirst, BYTE _bySecond)
{
	if(_byFirst>HORSE_MAX || 0==_byFirst || _bySecond>HORSE_MAX || 0==_bySecond) return 0;

	BYTE byFront = _byFirst, byBack = _bySecond;
	if(byFront > byBack) 
	{
		byFront = _bySecond; 
		byBack = _byFirst;
	}

	WORD wNumber = byFront*0x10 + byBack;

	for(int i=0; i<MULTIPLE_MAX; i++) 
		if(g_wMultipleTable[i].wNumber == wNumber) return g_wMultipleTable[i].wMultiple;

	return 0;
}

static BYTE GetIndexByNumber(BYTE _byFirst, BYTE _bySecond)
{
	if(_byFirst>HORSE_MAX || 0==_byFirst || _bySecond>HORSE_MAX || 0==_bySecond) return 0;

	BYTE byFront = _byFirst, byBack = _bySecond;
	if(byFront > byBack) 
	{
		byFront = _bySecond; 
		byBack = _byFirst;
	}

	WORD wNumber = byFront*0x10 + byBack;

	for(int i=0; i<MULTIPLE_MAX; i++) 
		if(g_wMultipleTable[i].wNumber == wNumber) return i;

	return 0xFF;
}

static int g_iPeiLv[MULTIPLE_MAX] =
{
	//785, 1142, 1570, 2512 , 3140,
	//546, 785,  1142, 1570 ,
	//392, 546,  785,
	//314, 392,
	//157,

	//498, 724,  995, 1592, 1990,
	//346, 498,  724, 995,
	//249, 346,  498,
	//199, 249,
	//100,

	2031,2955,4063,6500,8125,
	1413,2031,2955,4063,
	1016,1413,2031,
	813,1016,
	406,
};

static int g_iUserPeiLv[15] =
{
	2100, 3054, 3360, 3733, 4200,
	1460, 2100, 3360, 3360,
	1050, 1460, 2100,
	840,  1050,
	420,
};

static int RandInt(int iMax, int iMin = 0)
{
	//效验参数
	if (iMax - iMin <= 0) return 0;

	//产生随机数
	double dbTmp = 1.0f * rand() / (RAND_MAX + 1);

	int iRNum = int((iMax - iMin) * dbTmp + iMin);

	return iRNum;
}

static BYTE GetIndexByRand()
{
	BYTE byIndex = 0;
	int total = 0;
	for(int i=0; i<15; i++) total+=g_iPeiLv[i];

	int iRand = RandInt(total);

	for(int i=0; i<15; i++)
	{
		if(iRand > g_iPeiLv[i])
		{
			iRand -= g_iPeiLv[i];
			continue;
		}
		byIndex = i;
		break;
	}

	return byIndex;
}

static DWORD GetUserWinByChip(BYTE _byIndex, DWORD _dwChip[MULTIPLE_MAX])
{
	if(_byIndex >= MULTIPLE_MAX) return 0;
	return _dwChip[_byIndex]*g_wMultipleTable[_byIndex].wMultiple;
}







//////////////////////////////////////////////////////////////////////////

#endif




