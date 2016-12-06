#ifndef CMD_SPARROW_HEAD_FILE
#define CMD_SPARROW_HEAD_FILE

#include "GlobalDefine.h"
//////////////////////////////////////////////////////////////////////////
//公共宏定义
#define KIND_ID						GK_JieJi_PaoMaJi			//游戏 I D

#define GAME_PLAYER					100							//游戏人数
#define GAME_NAME					TEXT("动物赛跑")			//游戏名字
#define GAME_GENRE					(GAME_GENRE_SCORE|GAME_GENRE_MATCH|GAME_GENRE_GOLD)	//游戏类型

//游戏状态
#define GS_MJ_FREE					GS_FREE						//空闲状态
#define GS_MJ_PLAY					(GS_PLAYING+1)				//游戏状态

//常量定义
//////////////////////////////////////////////////////////////////////////
/*                          全局消息                                    */
#define CMD_GLOBAL_GameStart			0x0010			//游戏开始
#define CMD_GLOBAL_StopChip				0x0011			//停止下注
#define CMD_GLOBAL_MatchStart			0x0012			//比赛开始
#define CMD_GLOBAL_MatchOver			0x0013			//比赛结束
#define CMD_GLOBAL_UpdataChip			0x0014			//更新下注
#define CMD_GLOBAL_PlayerChip			0x0015			//更新下注
#define CMD_GLOBAL_HistoryWeav			0x0016			//历史组合
#define CMD_GLOBAL_PlayerWin			0x0017			//玩家赢取

struct tagMatchStart
{
	//马儿名次
	BYTE byHorseNum[HORSE_MAX];						
	//马儿速度段
	WORD wHorseSpeed[HORSE_MAX][SPEED_SEGMENT];		
};

//////////////////////////////////////////////////////////////////////////
/*  通讯消息  */
#define CMD_S_GameStart_P					0x0010
#define CMD_S_StopChip_P					0x0011
#define CMD_S_MatchStart_P					0x0012
#define CMD_S_MatchOver_P					0x0013

#define CMD_S_ChipSucc_P					0x0014
#define CMD_S_ChipUpdata_P					0x0015

#define CMD_S_HistoryWeav_P					0x0016
#define CMD_S_LastTimePlayerWin_P			0x0017
#define CMD_S_ZhuangInfo_P					0x0018

#define CMD_C_ChipIn_P						0x0010
#define CMD_C_RequestZhuang_P				0x0011

//////////////////////////////////////////////////////////////////////////
//历史记录
struct CMD_HistoryScore
{
	LONG							lTurnScore;			//上局积分
	LONG							lCollectScore;		//总积分
};

//////////////////////////////////////////////////////////////////////////
struct CMD_S_GameStart
{
	DWORD				dwZJUserID;
};

struct CMD_S_MatchStart
{
	tagMatchStart		matchStart;			//比赛信息
	DWORD				dwPlayerWin;		//玩家赢钱
	DWORD				dwZJUserID;			//庄家GameID
};

struct CMD_S_ChipSucc
{
	BYTE		byIndex;
	DWORD		dwChipMoney;
};

struct CMD_S_ChipUpdata
{
	DWORD				m_dwCurrentChip[MULTIPLE_MAX];			//当前下注状况
	DWORD				m_dwZJCanChip[MULTIPLE_MAX];			//庄家承受能力状况
};

struct CMD_S_HistoryWeav
{
	int			m_iHistoryWeav[HISTORYWEAV_MAX];				//历史组合记录
	BYTE		m_byStatus;										//当前游戏状态
};

//上次赢的玩家排名
struct CMD_S_LastTimePlayerWin
{
	char		m_szPlayer[5][32];
	DWORD		m_dwWinValue[5];
};

//庄家信息
struct CMD_S_ZhuangInfo
{
	DWORD		dwBankerUserID;						//庄家UserID
	DWORD		dwWaitUserID[SHOWZHUANG_MAX];		//排队玩家UserID
	DWORD		dwCount;							//请求当庄玩家总数
};

//场境状态
struct CMD_S_StatusFree
{
	DWORD						m_dwStartTime;
	BYTE						m_byStatus;
	CMD_S_HistoryWeav			m_HisWeav;
	CMD_S_LastTimePlayerWin		m_LastWin;
	CMD_S_ZhuangInfo			m_ZJInfo;

	DWORD						dwUserChip[MULTIPLE_MAX];
};
//////////////////////////////////////////////////////////////////////////
struct CMD_C_ChipIn
{
	BYTE		byIndex;
	DWORD		dwChipMoney;
};

struct CMD_C_RequestZhuang
{
	BYTE			byRequest;						//当庄1   下庄0
};

//////////////////////////////////////////////////////////////////////////


#endif



