#ifndef CMD_SPARROW_HEAD_FILE
#define CMD_SPARROW_HEAD_FILE

#include "GlobalDefine.h"
//////////////////////////////////////////////////////////////////////////
//�����궨��
#define KIND_ID						GK_JieJi_PaoMaJi			//��Ϸ I D

#define GAME_PLAYER					100							//��Ϸ����
#define GAME_NAME					TEXT("��������")			//��Ϸ����
#define GAME_GENRE					(GAME_GENRE_SCORE|GAME_GENRE_MATCH|GAME_GENRE_GOLD)	//��Ϸ����

//��Ϸ״̬
#define GS_MJ_FREE					GS_FREE						//����״̬
#define GS_MJ_PLAY					(GS_PLAYING+1)				//��Ϸ״̬

//��������
//////////////////////////////////////////////////////////////////////////
/*                          ȫ����Ϣ                                    */
#define CMD_GLOBAL_GameStart			0x0010			//��Ϸ��ʼ
#define CMD_GLOBAL_StopChip				0x0011			//ֹͣ��ע
#define CMD_GLOBAL_MatchStart			0x0012			//������ʼ
#define CMD_GLOBAL_MatchOver			0x0013			//��������
#define CMD_GLOBAL_UpdataChip			0x0014			//������ע
#define CMD_GLOBAL_PlayerChip			0x0015			//������ע
#define CMD_GLOBAL_HistoryWeav			0x0016			//��ʷ���
#define CMD_GLOBAL_PlayerWin			0x0017			//���Ӯȡ

struct tagMatchStart
{
	//�������
	BYTE byHorseNum[HORSE_MAX];						
	//����ٶȶ�
	WORD wHorseSpeed[HORSE_MAX][SPEED_SEGMENT];		
};

//////////////////////////////////////////////////////////////////////////
/*  ͨѶ��Ϣ  */
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
//��ʷ��¼
struct CMD_HistoryScore
{
	LONG							lTurnScore;			//�Ͼֻ���
	LONG							lCollectScore;		//�ܻ���
};

//////////////////////////////////////////////////////////////////////////
struct CMD_S_GameStart
{
	DWORD				dwZJUserID;
};

struct CMD_S_MatchStart
{
	tagMatchStart		matchStart;			//������Ϣ
	DWORD				dwPlayerWin;		//���ӮǮ
	DWORD				dwZJUserID;			//ׯ��GameID
};

struct CMD_S_ChipSucc
{
	BYTE		byIndex;
	DWORD		dwChipMoney;
};

struct CMD_S_ChipUpdata
{
	DWORD				m_dwCurrentChip[MULTIPLE_MAX];			//��ǰ��ע״��
	DWORD				m_dwZJCanChip[MULTIPLE_MAX];			//ׯ�ҳ�������״��
};

struct CMD_S_HistoryWeav
{
	int			m_iHistoryWeav[HISTORYWEAV_MAX];				//��ʷ��ϼ�¼
	BYTE		m_byStatus;										//��ǰ��Ϸ״̬
};

//�ϴ�Ӯ���������
struct CMD_S_LastTimePlayerWin
{
	char		m_szPlayer[5][32];
	DWORD		m_dwWinValue[5];
};

//ׯ����Ϣ
struct CMD_S_ZhuangInfo
{
	DWORD		dwBankerUserID;						//ׯ��UserID
	DWORD		dwWaitUserID[SHOWZHUANG_MAX];		//�Ŷ����UserID
	DWORD		dwCount;							//����ׯ�������
};

//����״̬
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
	BYTE			byRequest;						//��ׯ1   ��ׯ0
};

//////////////////////////////////////////////////////////////////////////


#endif



