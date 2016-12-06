#ifndef CMD_LAND_HEAD_FILE
#define CMD_LAND_HEAD_FILE

//////////////////////////////////////////////////////////////////////////
//�����궨��
#define KIND_ID						GK_Puke_Srnn				//��Ϸ I D
#define GAME_PLAYER					4								//��Ϸ����
#define GAME_NAME					TEXT("����ţţ")				//��Ϸ����

//��Ϸ״̬
#define GS_WK_FREE					0								//�ȴ���ʼ
#define GS_WK_PLAYING				100								//��Ϸ����

//////////////////////////////////////////////////////////////////////////
//��Ϸ�궨��
#define FULL_COUNT					52								//�������
#define MAX_COUNT					5								//�˿���Ŀ
#define ROB_LOOK_COUNT				3								//��ׯʱ��������
#define CHIP_SELECT_COUNT			4								//��עѡ������
#define CHIP_MUL_MAX				99								//�����ע����

//////////////////////////////////////////////////////////////////////////
//�ȴ�ʱ��
#define TIMER_FREE_DELAY			3								//����ʱ��
#define TIMER_ROB_DELAY				8								//��ׯʱ��
#define TIMER_CHIP_DELAY			8								//��ע�ȴ�
#define TIMER_USEROPEN_DELAY		15								//��Ҵ���
#define	TIMER_SYSOPEN_DELAY			6								//ϵͳ����
#define TIMER_ENDSCORE_DELAY		6								//����ʱ��

//////////////////////////////////////////////////////////////////////////
//��ţ��ţһ-ţ�ţ�ţţ��ը�����廨ţ����Сţ
//�������
enum eTypeNiuGame
{
	TYPE_NIU_NULL = 0,					//��ţ
	TYPE_NIU_1,							//��ţ
	TYPE_NIU_2,							//��ţ
	TYPE_NIU_3,							//��ţ
	TYPE_NIU_4,							//��ţ
	TYPE_NIU_5,							//��ţ
	TYPE_NIU_6,							//��ţ
	TYPE_NIU_7,							//��ţ
	TYPE_NIU_8,							//��ţ
	TYPE_NIU_9,							//��ţ
	TYPE_NIU_NIU,						//ţţ
	TYPE_NIU_ZZN,						//����ţ��5�ŵ����ܺ�50��
	TYPE_NIU_BOMB,						//ը��ţ����4����ͬ��
	TYPE_NIU_WXN,						//��Сţ��5���ܺ�С��10��
};

///////////////////////////////////////////////////////////////////////////////
//���г���
struct CMD_S_StatusFree
{
	LONG						nWaitTime;			//�ȴ�ʱ�䣨�룩
};

//��Ϸ״̬
struct CMD_S_StatusPlay
{
	//״̬��Ϣ
	WORD						wRunStatus;			//����״̬
	WORD						wBankerUser;		//ׯ���û�
	LONG						nWaitTime;			//�ȴ�ʱ�䣨�룩
	bool						bHaveDoing[GAME_PLAYER];//�Ƿ��в���
	bool						bJoinUser[GAME_PLAYER];//�������
	LONGLONG					lChipMul[GAME_PLAYER];//��ע����
	LONGLONG					lAllowChipMul[GAME_PLAYER][CHIP_SELECT_COUNT];//��ע����
	BYTE						byCardInfo[GAME_PLAYER][MAX_COUNT];//����Ϣ����������ׯ��ǰ�漸����
	LONGLONG					lWinScore[GAME_PLAYER];//��Ӯ״��
	LONG						nRevenue;              //˰��
};

//////////////////////////////////////////////////////////////////////////
//����������ṹ
#define CMD_SC_WaitReady_P				1			//׼���ȴ���3�룩
#define CMD_SC_GameStart_P				2			//��Ϸ��ʼ
#define CMD_SC_ChipStart_P				3			//��ע��ʼ����ע��ʼ��
#define CMD_SC_UserChip_P				4			//�����ע
#define CMD_SC_DispatchCard_P			5			//ϵͳ���ƣ����ƿ�ʼ��
#define CMD_SC_UserOpenCard_P			6			//��Ҵ���
#define CMD_SC_SysOpenCard_P			7			//ϵͳ���ƣ����ƿ�ʼ��
#define CMD_SC_EndScore_P				8			//��Ϸ���㣨���㿪ʼ��
#define CMD_SC_UserRob_P				9			//�����ׯ
#define CMD_SC_NotifyUserRob_P			10			//֪ͨ�����ׯ

//׼���ȴ���3�룩
struct CMD_SC_WaitReady
{
	LONG						nWaitTime;			//�ȴ�ʱ�䣨�룩��2���ֽ�
};

//��Ϸ��ʼ
struct CMD_SC_GameStart
{
	bool						bJoinUser[GAME_PLAYER];//�������
};

//֪ͨ��ׯ���
struct CMD_SC_NotifyUserRob
{
	LONG						nDelayTime;			//���ʱ�䣨�룩
	WORD						wCurChairID;		//��ǰ��ң�4���ֽ�
};

//��ע��ʼ
struct CMD_SC_ChipStart
{
	LONG						nDelayTime;			//���ʱ�䣨�룩������עʱ��
	WORD						wBankerUser;		//֪ͨׯ��
	LONGLONG					lChipMul[CHIP_SELECT_COUNT];//��ע��ң�4���ֽ�
};

//�����ׯ
struct CMD_SC_UserRob
{
	WORD						wChairID;			//���λ��
	bool						bRobBanker;			//�Ƿ���ׯ��1���ֽ�
};

//�����ע
struct CMD_SC_UserChip
{
	WORD						wChairID;			//���λ��
	LONGLONG					lChipMul;			//��ע���
};

//ϵͳ����
struct CMD_SC_DispatchCard
{
	LONG						nDelayTime;			//���ʱ�䣨�룩��������ʱ��
	BYTE						byAryCard[GAME_PLAYER][MAX_COUNT];//����˿�
};

struct CMD_SC_UserOpenCard
{
	WORD						wOpenUser;			//�������
	BYTE						byAryCardF[3];		//����˿�
	BYTE						byAryCardB[2];		//����˿�
};

struct CMD_SC_SysOpenCard
{
	WORD						wCardType[GAME_PLAYER];//������
	BYTE						byAryCardF[GAME_PLAYER][3];//����˿�
	BYTE						byAryCardB[GAME_PLAYER][2];//����˿�
};

//��Ϸ����
struct CMD_SC_EndScore
{
	LONGLONG					lAryWinScore[GAME_PLAYER];//Ӯȡ����
	LONGLONG					lRevenue[GAME_PLAYER];//�۳�˰��
};

//////////////////////////////////////////////////////////////////////////
//�ͻ�������ṹ
#define CMD_CS_RobBanker_P				1			//�����ׯ
#define CMD_CS_UserChip_P				2			//�����ע
#define CMD_CS_OperateCard_P			3			//��Ҳ���

//�����ׯ
struct CMD_CS_RobBanker
{
	bool						bRobBanker;			//�Ƿ���ׯ
};

//�����ע
struct CMD_CS_UserChip
{
	LONGLONG					lChipMul;			//��ע����
};

//��Ҳ���
struct CMD_CS_OperateCard
{
	BYTE						byAryCardF[3];		//ǰ���Ŵ���
	BYTE						byAryCardB[2];		//���������
};

#endif



