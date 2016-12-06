#ifndef CMD_LOAD_HEAD_FILE
#define CMD_LOAD_HEAD_FILE

//////////////////////////////////////////////////////////////////////////
//公共宏定义
#define KIND_ID							GK_HL_ErShiYiD						//游戏 I D

#define	GAME_PLAYER						5									//玩家总人数
#define GAME_NAME						TEXT("21点")						//游戏名字

//游戏状态
#define GS_WK_FREE						0									//等待开始
#define GS_WK_PLAYING					100									//游戏进行

//设置基础分(自由场接口)
#define SETCELL_ASK						0x01								//要求设置
#define SETCELL_ALLOW					0x02								//允许进入
#define SETCELL_NOSET					0x03								//未设置好


//时间
#define TIMER_CHIP					    15500								//下注时间
#define TIMER_DEAL_POKER_A0				 300								//发牌时间a0
#define TIMER_DEAL_POKER_D				 200								//发牌时间d
#define TIMER_DEAL_POKER_OFFSET			 500								//发牌时间offset
#define	TIMER_INSURACE					 5500								//保险时间
#define	TIMER_LOOK_ZJ_BLACK_JACK		 2500								//查看庄家是否黑杰克时间
#define TIMER_NORMAL_OPERATE			10500								//玩家普通操作时间
#define	TIMER_GAME_END					 6500								//游戏结束时间
#define TIMER_START_OPERATE				 1000								//开始操作
#define	TIMER_LOOK_ZJ_SECOND_POKER		 2500								//查看庄家第二张扑克
#define TIMER_ZJ_HIT_POKER				 2500								//庄家拿牌
#define TIMER_AUTO_ADD_POKER			 2500								//自动补牌

#define TIMER_AUTO_ADD_POKER_STAND		 2500								//动作补牌停止

#define TIMER_SERVER_OR_CLIENT_TIME		 2500								//延迟时间



const			INT32					C_CHIP_IN_GAME_TIME = 8000;//下注状态进入游戏时间


//游戏参数
const			BYTE					C_ROOM_COUNT = 4;//房间数量
const			INT32					C_CELL_SCORE[C_ROOM_COUNT] = {1000,1000,1000,1000};//房间基础金
const			BYTE					C_CELL_RATE = 1;//倍率

const			BYTE					C_ERROR_CHAIR_ID = 100;//错误椅子号

const			BYTE					C_CHIP_TYPE_NUM = 6;//下注类型数
const			INT32					C_CHIP_GAME_GOLD[C_CHIP_TYPE_NUM] = {1000,10000,100000,1000000,5000000,10000000};//下注游戏金币

const			BYTE					C_OPERATE_BUTTON_NUM = 5;//操作按钮数量

const			BYTE					C_ONE_POKER_COUNT = 52;//一副扑克数量
const			BYTE					C_POKERS_COUNT = 8;//8副扑克
const			INT32					C_TOTAL_POKER_COUNT = C_ONE_POKER_COUNT * C_POKERS_COUNT;//所有扑克数
const			INT32					C_LAST_POKER_COUNT = 170;//剩余扑克数量，洗牌

const			BYTE					C_SPLIT_POKER_COUNT = 4;//分牌数
const			BYTE					C_GROUP_MAX_POKER_COUNT = 8;//每组最大扑克数量

const			BYTE					C_ZJ_MID_POINT = 18;//庄家临界值

const			BYTE					C_MIN_DRAGON	= 5;//最小龙
const			BYTE					C_MAX_DRAGON	= 8;//最大龙

const			float					C_LOST_RATE_BLACK_JACK	= 2.0f;//黑杰克 赔率
const			float					C_LOST_RATE_INSURANCE	= 1.0f;//保险 赔率
const			float					C_LOST_RATE_DRAGON		= 1.5f;//龙 赔率
const			float					C_LOST_RATE_OTHER		= 1.0f;//其他 赔率

const			INT32					C_SMALL_TIP				= 100;//打赏小费

const			BYTE					C_MID_POINT				= 11;//中点
const			BYTE					C_MOST_GOOD_MIN			= 18;//最优最小点数
const			BYTE					C_MOST_GOOD_MAX			= 21;//最优最大点数

const			BYTE					C_NOT_CHIP_COUNT		= 3;//不下注次数




//枚举类型 和 结构体
enum enGameRunState//游戏运行状态
{
	E_GAME_RUN_STATE_NULL = -1,//未知
	E_GAME_RUN_STATE_START,//开始状态
	E_GAME_RUN_STATE_CHIP,//下注状态
	E_GAME_RUN_STATE_NOT_CHIP,//不是下注状态
	E_GAME_RUN_STATE_OFFLINE//断线重连
};

enum enPlayerOperateState//玩家操作状态
{
	E_PLAYER_OPERATE_STATE_NULL = -1,//未知
	E_PLAYER_OPERATE_STATE_CHIP,//下注状态
	E_PLAYER_OPERATE_STATE_DEAL_POKER,//发牌状态
	E_PLAYER_OPERATE_STATE_INSURANCE,//保险状态
	E_PLAYER_OPERATE_STATE_PRE_LOOK_ZJ_BLACK_JACK,//查看庄家是否黑杰克前
	E_PLAYER_OPERATE_STATE_AFT_LOOK_ZJ_BLACK_JACK,//查看庄家是否黑杰克后
	E_PLAYER_OPERATE_STATE_PRE_LOOK_ZJ_SECOND_POKER,//查看庄家第二张扑克前
	E_PLAYER_OPERATE_STATE_AFT_LOOK_ZJ_SECOND_POKER,//查看庄家第二张扑克后
	E_PLAYER_OPERATE_STATE_NORMAL_OPERATE,//普通操作
	E_PLAYER_OPERATE_STATE_AUTO_ADD_POKER//自动补牌操作
};

struct stDealPoker//发牌数据
{
	BYTE byPokerData1;//第一张 
	BYTE byPokerData2;//第二张

	bool bHelp[2];//补位字节对齐
};

enum enPlayerNormalOperate//玩家普通操作
{
	E_PLAYER_NORMAL_OPERATE_NULL = -1,//未知
	E_PLAYER_NORMAL_OPERATE_SURRENDER,//投降
	E_PLAYER_NORMAL_OPERATE_SPLIT_POKER,//分牌
	E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP,//双倍
	E_PLAYER_NORMAL_OPERATE_STAND_POKER,//停牌
	E_PLAYER_NORMAL_OPERATE_HIT_POKER,//拿牌
	E_PLAYER_NORMAL_OPERATE_AUTO_ADD_POKER//自动补牌
};

enum enGameEndType//游戏结束类型
{
	E_GAME_END_TYPE_NULL = -1,//未知
	E_GAME_END_TYPE_ZJ_BLACK_JACK,//庄家黑杰克
	E_GAME_END_TYPE_NORMAL//正常结束
};

enum enPlayerWin//玩家输赢
{
	E_PLAYER_WIN_NULL = -1,//未知
	E_PLAYER_WIN_WIN,//赢了
	E_PLAYER_WIN_EVEN,//平局	
	E_PLAYER_WIN_LOST//输了
};

struct stGameResult//游戏结果
{
	enPlayerWin bPlayerWin;//玩家输赢

	bool bBlackJack;//是否黑杰克
	bool bDragon;//是否龙

	bool bHelp[2];//补位字节对齐

	INT32 iWinGameGold;//赢的游戏金币
};


struct stServerPlayerData//玩家数据信息
{
	INT32 m_iChip;//下注
	INT32 m_iChipList[C_SPLIT_POKER_COUNT];//下注列表

	BYTE  m_byGroupIndex;//组索引
	BYTE  m_byGroupCount;//组数量

	bool  bHelp1[2];//补位字节对齐

	BYTE  m_byPokerData[C_SPLIT_POKER_COUNT][C_GROUP_MAX_POKER_COUNT];//扑克数据

	BYTE  m_byPokerCount[C_SPLIT_POKER_COUNT];//扑克数量
	bool  m_bSurrender[C_SPLIT_POKER_COUNT];//是否投降

	bool  m_bInsurance;//是否购买保险
	bool  m_bPlaying;//是否游戏中

	bool  bHelp2[2];//补位字节对齐

	bool  m_bHasOperatePoker[C_SPLIT_POKER_COUNT];//是否已经操作扑克

	BYTE  m_byNotChipCount;//不下注次数

	bool  bHelp3[3];//补位

	enPlayerOperateState m_enPlayerOperateState;//玩家操作状态
};

enum eCHEAT_WIN_LOST//输赢
{
	CHEAT_TO_WIN,					
	CHEAT_TO_LOST
};

struct	_SYS_CHEAT//系统血池概率
{
	eCHEAT_WIN_LOST	eCheatRlt;	
	float			fCoeff;
};

struct	_SYS_PARAM_CONFIG//服务器参数配置
{
	int		PlayerWinMoneyPerRevenue;	//玩家税收
	int		SysWinMoneyPerRevenue;		//系统税收
	int		SysCheatBeginToWin;			//概率胜起点
	int		SysCheatEndToWin;			//概率胜终点
	int		SysCheatBeginToLost;		//概率输起点
	int		SysCheatEndToLost;			//概率输终点
	int		SysCurWinGold;				//系统当前吃钱
	int		UserMaxLost;				//玩家最大输钱
	int     UserMaxWin;					//玩家最大吃钱
};

struct stHistoryScore//成绩
{
	bool	bValid;//是否有效
	BYTE	byChairID;//座位号

	bool	bHelp1[2];//补位字节对齐

	INT32	iLastWinGameGold;//上轮成绩
	INT32	iTotalWinGameGold;//总成绩
};


//服务器 消息 定义
#define			SUB_SC_SMALL_TIP				0		//打赏小费

#define			SUB_SC_CHIP						1		//下注
#define			SUB_SC_PLAYER_CHIP				2		//玩家下注
#define			SUB_SC_DEAL_POKER				3		//发牌
#define			SUB_SC_INSURANCE				4		//保险
#define			SUB_SC_PLAYER_INSURANCE			5		//玩家保险
#define			SUB_SC_LOOK_ZJ_BLACK_JACK		6		//查看庄家是否黑杰克
#define			SUB_SC_PLAYER_BLACK_JACK		7		//玩家黑杰克
#define			SUB_SC_NORMAL_OPERATE			8		//普通操作
#define			SUB_SC_PLAYER_NORMAL_OPERATE	9		//玩家普通操作
#define			SUB_SC_LOOK_ZJ_SECOND_POKER		10		//查看庄家第二张牌
#define			SUB_SC_NEW_PALYER_ENTER_AT_CHIP	11		//下注状态进入玩家


#define			SUB_SC_GAME_END					20		//游戏结束


//客户端 消息 定义
#define			SUB_CS_SET_CELLSCORE			0		//自由场
#define			SUB_CS_SMALL_TIP				1		//打赏小费

#define			SUB_CS_PLAYER_CHIP				2		//玩家下注
#define			SUB_CS_PLAYER_INSURANCE			3		//玩家保险
#define			SUB_CS_PLAYER_NORMAL_OPERATE	4		//玩家普通操作
#define			SUB_CS_TE_SHU_CHU_LI			5		//特殊处理

#define			SUB_CS_STOP_CHIP				6		//停止下注


//服务器发送结构体
struct CMD_SC_GAME_FREE//游戏空闲
{
	LONG lCellScore;//基础积分
	BYTE cbSetCellStatus;//自由场状态

	BYTE byCurrentOperateChairID;//当前操作座位号

	bool bHelp1[2];//补位字节对齐

	enGameRunState gameRunState;//游戏运行状态

	enPlayerOperateState zjOperateState;//庄家操作状态

	INT32 iLeftTime;//下注剩余时间
	INT32 iChip[GAME_PLAYER];//下注值

	stServerPlayerData serverPlayerData[GAME_PLAYER + 1];//玩家数据

	stHistoryScore historyScore[GAME_PLAYER];//成绩

};


struct CMD_SC_SMALL_TIP//打赏小费
{
	BYTE byChairID;//座位号

	bool bHelp[3];//补位字节对齐
};

struct CMD_SC_PLAYER_CHIP//玩家下注
{
	INT32 iChip;//下注值
	BYTE byChairID;//座位号

	bool bHelp[3];//补位字节对齐
};

struct CMD_SC_DEAL_POKER//发牌
{
	stDealPoker pokerData[GAME_PLAYER + 1];//扑克数据
};

struct CMD_SC_PLAYER_INSURANCE//玩家保险
{
	BYTE byChairID;//座位号
	bool bInsurance;//是否购买保险

	bool bHelp[2];//补位字节对齐
};

struct CMD_SC_LOOK_ZJ_BLAKC_JACK//查看庄家是否黑杰克
{
	bool bZJBlackJack;//庄家是否黑杰克
	BYTE byPokerData;//扑克数据

	bool bHelp[2];//补位字节对齐
};

struct CMD_SC_GAME_END//游戏结束
{
	enGameEndType gameEndType;//游戏结束类型

	stGameResult gameResult[GAME_PLAYER][C_SPLIT_POKER_COUNT];//玩家输赢

	stHistoryScore historyScore[GAME_PLAYER];//成绩
};

struct CMD_SC_PLAYER_BLACK_JACK//玩家黑杰克
{
	BYTE byChairID;//座位号

	bool bHelp[3];//补位字节对齐
};

struct CMD_SC_NORMAL_OPERATE//普通操作
{
	BYTE byChairID;//座位号
	bool bCanSplitPoker;//是否能够分牌

	bool bHelp[2];//补位字节对齐
};

struct CMD_SC_PLAYER_NORMAL_OPERATE//玩家普通操作
{
	enPlayerNormalOperate playerNormalOperate;//玩家普通操作
	stDealPoker pokerData;//扑克数据

	BYTE byChairID;//座位号
	bool bBustPoker;//爆牌
	bool b21;//21点

	bool bSelfStopPoker;//自己停牌

	//bool bHelp;//补位字节对齐
};

struct CMD_SC_LOOK_ZJ_SECOND_POKER//查看庄家第二张牌
{
	BYTE byPokerData;//扑克数据
};

struct CMD_SC_NEW_PLAYER_ENTER_AT_CHIP//新玩家在下注状态时进入 
{
	BYTE byChairID;//座位号
};



//客服端发送结构体
struct CMD_CS_PLAYER_CELLSCORE//基础分
{
	LONG lCellScore;//基础分
};

struct CMD_CS_PLAYER_CHIP//玩家下注
{
	INT32 iChip;//下注值
};

struct CMD_CS_PLAYER_INSURANCE//玩家保险
{
	bool bInsurance;//是否购买保险

	bool bHelp[3];//补位字节对齐
};

struct CMD_CS_PLAYER_NORMAL_OPERATE//玩家普通操作
{
	enPlayerNormalOperate playerNormalOperate;//玩家普通操作
};

struct CMD_CS_TE_SHU_CHU_LI//特殊处理
{
	BYTE byChairID;//座位号
	bool bWinLost;//输赢

	bool bHelp[2];//补位字节对齐
};



#endif