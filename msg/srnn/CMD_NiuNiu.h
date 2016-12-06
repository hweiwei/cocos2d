#ifndef CMD_LAND_HEAD_FILE
#define CMD_LAND_HEAD_FILE

//////////////////////////////////////////////////////////////////////////
//公共宏定义
#define KIND_ID						GK_Puke_Srnn				//游戏 I D
#define GAME_PLAYER					4								//游戏人数
#define GAME_NAME					TEXT("四人牛牛")				//游戏名字

//游戏状态
#define GS_WK_FREE					0								//等待开始
#define GS_WK_PLAYING				100								//游戏进行

//////////////////////////////////////////////////////////////////////////
//游戏宏定义
#define FULL_COUNT					52								//最大牌数
#define MAX_COUNT					5								//扑克数目
#define ROB_LOOK_COUNT				3								//抢庄时看牌数量
#define CHIP_SELECT_COUNT			4								//下注选项数量
#define CHIP_MUL_MAX				99								//最大下注倍数

//////////////////////////////////////////////////////////////////////////
//等待时长
#define TIMER_FREE_DELAY			3								//空闲时长
#define TIMER_ROB_DELAY				8								//抢庄时长
#define TIMER_CHIP_DELAY			8								//下注等待
#define TIMER_USEROPEN_DELAY		15								//玩家凑牌
#define	TIMER_SYSOPEN_DELAY			6								//系统开牌
#define TIMER_ENDSCORE_DELAY		6								//结算时长

//////////////////////////////////////////////////////////////////////////
//无牛，牛一-牛九，牛牛，炸弹，五花牛，五小牛
//结果类型
enum eTypeNiuGame
{
	TYPE_NIU_NULL = 0,					//无牛
	TYPE_NIU_1,							//有牛
	TYPE_NIU_2,							//有牛
	TYPE_NIU_3,							//有牛
	TYPE_NIU_4,							//有牛
	TYPE_NIU_5,							//有牛
	TYPE_NIU_6,							//有牛
	TYPE_NIU_7,							//有牛
	TYPE_NIU_8,							//有牛
	TYPE_NIU_9,							//有牛
	TYPE_NIU_NIU,						//牛牛
	TYPE_NIU_ZZN,						//至尊牛（5张点数总和50）
	TYPE_NIU_BOMB,						//炸弹牛（有4张相同）
	TYPE_NIU_WXN,						//五小牛（5张总和小于10）
};

///////////////////////////////////////////////////////////////////////////////
//空闲场境
struct CMD_S_StatusFree
{
	LONG						nWaitTime;			//等待时间（秒）
};

//游戏状态
struct CMD_S_StatusPlay
{
	//状态信息
	WORD						wRunStatus;			//运行状态
	WORD						wBankerUser;		//庄家用户
	LONG						nWaitTime;			//等待时间（秒）
	bool						bHaveDoing[GAME_PLAYER];//是否有操作
	bool						bJoinUser[GAME_PLAYER];//参与玩家
	LONGLONG					lChipMul[GAME_PLAYER];//下注倍数
	LONGLONG					lAllowChipMul[GAME_PLAYER][CHIP_SELECT_COUNT];//下注倍数
	BYTE						byCardInfo[GAME_PLAYER][MAX_COUNT];//牌信息——用于抢庄看前面几张牌
	LONGLONG					lWinScore[GAME_PLAYER];//输赢状况
	LONG						nRevenue;              //税收
};

//////////////////////////////////////////////////////////////////////////
//服务器命令结构
#define CMD_SC_WaitReady_P				1			//准备等待（3秒）
#define CMD_SC_GameStart_P				2			//游戏开始
#define CMD_SC_ChipStart_P				3			//下注开始（下注开始）
#define CMD_SC_UserChip_P				4			//玩家下注
#define CMD_SC_DispatchCard_P			5			//系统发牌（凑牌开始）
#define CMD_SC_UserOpenCard_P			6			//玩家凑牌
#define CMD_SC_SysOpenCard_P			7			//系统开牌（开牌开始）
#define CMD_SC_EndScore_P				8			//游戏结算（结算开始）
#define CMD_SC_UserRob_P				9			//玩家抢庄
#define CMD_SC_NotifyUserRob_P			10			//通知玩家抢庄

//准备等待（3秒）
struct CMD_SC_WaitReady
{
	LONG						nWaitTime;			//等待时间（秒），2个字节
};

//游戏开始
struct CMD_SC_GameStart
{
	bool						bJoinUser[GAME_PLAYER];//参与玩家
};

//通知抢庄玩家
struct CMD_SC_NotifyUserRob
{
	LONG						nDelayTime;			//间隔时间（秒）
	WORD						wCurChairID;		//当前玩家，4个字节
};

//下注开始
struct CMD_SC_ChipStart
{
	LONG						nDelayTime;			//间隔时间（秒）——下注时间
	WORD						wBankerUser;		//通知庄家
	LONGLONG					lChipMul[CHIP_SELECT_COUNT];//下注金币，4个字节
};

//玩家抢庄
struct CMD_SC_UserRob
{
	WORD						wChairID;			//玩家位置
	bool						bRobBanker;			//是否抢庄，1个字节
};

//玩家下注
struct CMD_SC_UserChip
{
	WORD						wChairID;			//玩家位置
	LONGLONG					lChipMul;			//下注金币
};

//系统发牌
struct CMD_SC_DispatchCard
{
	LONG						nDelayTime;			//间隔时间（秒）——开牌时间
	BYTE						byAryCard[GAME_PLAYER][MAX_COUNT];//玩家扑克
};

struct CMD_SC_UserOpenCard
{
	WORD						wOpenUser;			//开牌玩家
	BYTE						byAryCardF[3];		//玩家扑克
	BYTE						byAryCardB[2];		//玩家扑克
};

struct CMD_SC_SysOpenCard
{
	WORD						wCardType[GAME_PLAYER];//牌类型
	BYTE						byAryCardF[GAME_PLAYER][3];//玩家扑克
	BYTE						byAryCardB[GAME_PLAYER][2];//玩家扑克
};

//游戏结算
struct CMD_SC_EndScore
{
	LONGLONG					lAryWinScore[GAME_PLAYER];//赢取分数
	LONGLONG					lRevenue[GAME_PLAYER];//扣除税收
};

//////////////////////////////////////////////////////////////////////////
//客户端命令结构
#define CMD_CS_RobBanker_P				1			//玩家抢庄
#define CMD_CS_UserChip_P				2			//玩家下注
#define CMD_CS_OperateCard_P			3			//玩家操作

//玩家抢庄
struct CMD_CS_RobBanker
{
	bool						bRobBanker;			//是否抢庄
};

//玩家下注
struct CMD_CS_UserChip
{
	LONGLONG					lChipMul;			//下注倍数
};

//玩家操作
struct CMD_CS_OperateCard
{
	BYTE						byAryCardF[3];		//前三张凑牌
	BYTE						byAryCardB[2];		//后两张组点
};

#endif



