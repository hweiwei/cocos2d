#ifndef CMD_LOAD_HEAD_FILE
#define CMD_LOAD_HEAD_FILE

//////////////////////////////////////////////////////////////////////////
//�����궨��
#define KIND_ID							GK_HL_ErShiYiD						//��Ϸ I D

#define	GAME_PLAYER						5									//���������
#define GAME_NAME						TEXT("21��")						//��Ϸ����

//��Ϸ״̬
#define GS_WK_FREE						0									//�ȴ���ʼ
#define GS_WK_PLAYING					100									//��Ϸ����

//���û�����(���ɳ��ӿ�)
#define SETCELL_ASK						0x01								//Ҫ������
#define SETCELL_ALLOW					0x02								//�������
#define SETCELL_NOSET					0x03								//δ���ú�


//ʱ��
#define TIMER_CHIP					    15500								//��עʱ��
#define TIMER_DEAL_POKER_A0				 300								//����ʱ��a0
#define TIMER_DEAL_POKER_D				 200								//����ʱ��d
#define TIMER_DEAL_POKER_OFFSET			 500								//����ʱ��offset
#define	TIMER_INSURACE					 5500								//����ʱ��
#define	TIMER_LOOK_ZJ_BLACK_JACK		 2500								//�鿴ׯ���Ƿ�ڽܿ�ʱ��
#define TIMER_NORMAL_OPERATE			10500								//�����ͨ����ʱ��
#define	TIMER_GAME_END					 6500								//��Ϸ����ʱ��
#define TIMER_START_OPERATE				 1000								//��ʼ����
#define	TIMER_LOOK_ZJ_SECOND_POKER		 2500								//�鿴ׯ�ҵڶ����˿�
#define TIMER_ZJ_HIT_POKER				 2500								//ׯ������
#define TIMER_AUTO_ADD_POKER			 2500								//�Զ�����

#define TIMER_AUTO_ADD_POKER_STAND		 2500								//��������ֹͣ

#define TIMER_SERVER_OR_CLIENT_TIME		 2500								//�ӳ�ʱ��



const			INT32					C_CHIP_IN_GAME_TIME = 8000;//��ע״̬������Ϸʱ��


//��Ϸ����
const			BYTE					C_ROOM_COUNT = 4;//��������
const			INT32					C_CELL_SCORE[C_ROOM_COUNT] = {1000,1000,1000,1000};//���������
const			BYTE					C_CELL_RATE = 1;//����

const			BYTE					C_ERROR_CHAIR_ID = 100;//�������Ӻ�

const			BYTE					C_CHIP_TYPE_NUM = 6;//��ע������
const			INT32					C_CHIP_GAME_GOLD[C_CHIP_TYPE_NUM] = {1000,10000,100000,1000000,5000000,10000000};//��ע��Ϸ���

const			BYTE					C_OPERATE_BUTTON_NUM = 5;//������ť����

const			BYTE					C_ONE_POKER_COUNT = 52;//һ���˿�����
const			BYTE					C_POKERS_COUNT = 8;//8���˿�
const			INT32					C_TOTAL_POKER_COUNT = C_ONE_POKER_COUNT * C_POKERS_COUNT;//�����˿���
const			INT32					C_LAST_POKER_COUNT = 170;//ʣ���˿�������ϴ��

const			BYTE					C_SPLIT_POKER_COUNT = 4;//������
const			BYTE					C_GROUP_MAX_POKER_COUNT = 8;//ÿ������˿�����

const			BYTE					C_ZJ_MID_POINT = 18;//ׯ���ٽ�ֵ

const			BYTE					C_MIN_DRAGON	= 5;//��С��
const			BYTE					C_MAX_DRAGON	= 8;//�����

const			float					C_LOST_RATE_BLACK_JACK	= 2.0f;//�ڽܿ� ����
const			float					C_LOST_RATE_INSURANCE	= 1.0f;//���� ����
const			float					C_LOST_RATE_DRAGON		= 1.5f;//�� ����
const			float					C_LOST_RATE_OTHER		= 1.0f;//���� ����

const			INT32					C_SMALL_TIP				= 100;//����С��

const			BYTE					C_MID_POINT				= 11;//�е�
const			BYTE					C_MOST_GOOD_MIN			= 18;//������С����
const			BYTE					C_MOST_GOOD_MAX			= 21;//����������

const			BYTE					C_NOT_CHIP_COUNT		= 3;//����ע����




//ö������ �� �ṹ��
enum enGameRunState//��Ϸ����״̬
{
	E_GAME_RUN_STATE_NULL = -1,//δ֪
	E_GAME_RUN_STATE_START,//��ʼ״̬
	E_GAME_RUN_STATE_CHIP,//��ע״̬
	E_GAME_RUN_STATE_NOT_CHIP,//������ע״̬
	E_GAME_RUN_STATE_OFFLINE//��������
};

enum enPlayerOperateState//��Ҳ���״̬
{
	E_PLAYER_OPERATE_STATE_NULL = -1,//δ֪
	E_PLAYER_OPERATE_STATE_CHIP,//��ע״̬
	E_PLAYER_OPERATE_STATE_DEAL_POKER,//����״̬
	E_PLAYER_OPERATE_STATE_INSURANCE,//����״̬
	E_PLAYER_OPERATE_STATE_PRE_LOOK_ZJ_BLACK_JACK,//�鿴ׯ���Ƿ�ڽܿ�ǰ
	E_PLAYER_OPERATE_STATE_AFT_LOOK_ZJ_BLACK_JACK,//�鿴ׯ���Ƿ�ڽܿ˺�
	E_PLAYER_OPERATE_STATE_PRE_LOOK_ZJ_SECOND_POKER,//�鿴ׯ�ҵڶ����˿�ǰ
	E_PLAYER_OPERATE_STATE_AFT_LOOK_ZJ_SECOND_POKER,//�鿴ׯ�ҵڶ����˿˺�
	E_PLAYER_OPERATE_STATE_NORMAL_OPERATE,//��ͨ����
	E_PLAYER_OPERATE_STATE_AUTO_ADD_POKER//�Զ����Ʋ���
};

struct stDealPoker//��������
{
	BYTE byPokerData1;//��һ�� 
	BYTE byPokerData2;//�ڶ���

	bool bHelp[2];//��λ�ֽڶ���
};

enum enPlayerNormalOperate//�����ͨ����
{
	E_PLAYER_NORMAL_OPERATE_NULL = -1,//δ֪
	E_PLAYER_NORMAL_OPERATE_SURRENDER,//Ͷ��
	E_PLAYER_NORMAL_OPERATE_SPLIT_POKER,//����
	E_PLAYER_NORMAL_OPERATE_DOUBLE_CHIP,//˫��
	E_PLAYER_NORMAL_OPERATE_STAND_POKER,//ͣ��
	E_PLAYER_NORMAL_OPERATE_HIT_POKER,//����
	E_PLAYER_NORMAL_OPERATE_AUTO_ADD_POKER//�Զ�����
};

enum enGameEndType//��Ϸ��������
{
	E_GAME_END_TYPE_NULL = -1,//δ֪
	E_GAME_END_TYPE_ZJ_BLACK_JACK,//ׯ�Һڽܿ�
	E_GAME_END_TYPE_NORMAL//��������
};

enum enPlayerWin//�����Ӯ
{
	E_PLAYER_WIN_NULL = -1,//δ֪
	E_PLAYER_WIN_WIN,//Ӯ��
	E_PLAYER_WIN_EVEN,//ƽ��	
	E_PLAYER_WIN_LOST//����
};

struct stGameResult//��Ϸ���
{
	enPlayerWin bPlayerWin;//�����Ӯ

	bool bBlackJack;//�Ƿ�ڽܿ�
	bool bDragon;//�Ƿ���

	bool bHelp[2];//��λ�ֽڶ���

	INT32 iWinGameGold;//Ӯ����Ϸ���
};


struct stServerPlayerData//���������Ϣ
{
	INT32 m_iChip;//��ע
	INT32 m_iChipList[C_SPLIT_POKER_COUNT];//��ע�б�

	BYTE  m_byGroupIndex;//������
	BYTE  m_byGroupCount;//������

	bool  bHelp1[2];//��λ�ֽڶ���

	BYTE  m_byPokerData[C_SPLIT_POKER_COUNT][C_GROUP_MAX_POKER_COUNT];//�˿�����

	BYTE  m_byPokerCount[C_SPLIT_POKER_COUNT];//�˿�����
	bool  m_bSurrender[C_SPLIT_POKER_COUNT];//�Ƿ�Ͷ��

	bool  m_bInsurance;//�Ƿ�����
	bool  m_bPlaying;//�Ƿ���Ϸ��

	bool  bHelp2[2];//��λ�ֽڶ���

	bool  m_bHasOperatePoker[C_SPLIT_POKER_COUNT];//�Ƿ��Ѿ������˿�

	BYTE  m_byNotChipCount;//����ע����

	bool  bHelp3[3];//��λ

	enPlayerOperateState m_enPlayerOperateState;//��Ҳ���״̬
};

enum eCHEAT_WIN_LOST//��Ӯ
{
	CHEAT_TO_WIN,					
	CHEAT_TO_LOST
};

struct	_SYS_CHEAT//ϵͳѪ�ظ���
{
	eCHEAT_WIN_LOST	eCheatRlt;	
	float			fCoeff;
};

struct	_SYS_PARAM_CONFIG//��������������
{
	int		PlayerWinMoneyPerRevenue;	//���˰��
	int		SysWinMoneyPerRevenue;		//ϵͳ˰��
	int		SysCheatBeginToWin;			//����ʤ���
	int		SysCheatEndToWin;			//����ʤ�յ�
	int		SysCheatBeginToLost;		//���������
	int		SysCheatEndToLost;			//�������յ�
	int		SysCurWinGold;				//ϵͳ��ǰ��Ǯ
	int		UserMaxLost;				//��������Ǯ
	int     UserMaxWin;					//�������Ǯ
};

struct stHistoryScore//�ɼ�
{
	bool	bValid;//�Ƿ���Ч
	BYTE	byChairID;//��λ��

	bool	bHelp1[2];//��λ�ֽڶ���

	INT32	iLastWinGameGold;//���ֳɼ�
	INT32	iTotalWinGameGold;//�ܳɼ�
};


//������ ��Ϣ ����
#define			SUB_SC_SMALL_TIP				0		//����С��

#define			SUB_SC_CHIP						1		//��ע
#define			SUB_SC_PLAYER_CHIP				2		//�����ע
#define			SUB_SC_DEAL_POKER				3		//����
#define			SUB_SC_INSURANCE				4		//����
#define			SUB_SC_PLAYER_INSURANCE			5		//��ұ���
#define			SUB_SC_LOOK_ZJ_BLACK_JACK		6		//�鿴ׯ���Ƿ�ڽܿ�
#define			SUB_SC_PLAYER_BLACK_JACK		7		//��Һڽܿ�
#define			SUB_SC_NORMAL_OPERATE			8		//��ͨ����
#define			SUB_SC_PLAYER_NORMAL_OPERATE	9		//�����ͨ����
#define			SUB_SC_LOOK_ZJ_SECOND_POKER		10		//�鿴ׯ�ҵڶ�����
#define			SUB_SC_NEW_PALYER_ENTER_AT_CHIP	11		//��ע״̬�������


#define			SUB_SC_GAME_END					20		//��Ϸ����


//�ͻ��� ��Ϣ ����
#define			SUB_CS_SET_CELLSCORE			0		//���ɳ�
#define			SUB_CS_SMALL_TIP				1		//����С��

#define			SUB_CS_PLAYER_CHIP				2		//�����ע
#define			SUB_CS_PLAYER_INSURANCE			3		//��ұ���
#define			SUB_CS_PLAYER_NORMAL_OPERATE	4		//�����ͨ����
#define			SUB_CS_TE_SHU_CHU_LI			5		//���⴦��

#define			SUB_CS_STOP_CHIP				6		//ֹͣ��ע


//���������ͽṹ��
struct CMD_SC_GAME_FREE//��Ϸ����
{
	LONG lCellScore;//��������
	BYTE cbSetCellStatus;//���ɳ�״̬

	BYTE byCurrentOperateChairID;//��ǰ������λ��

	bool bHelp1[2];//��λ�ֽڶ���

	enGameRunState gameRunState;//��Ϸ����״̬

	enPlayerOperateState zjOperateState;//ׯ�Ҳ���״̬

	INT32 iLeftTime;//��עʣ��ʱ��
	INT32 iChip[GAME_PLAYER];//��עֵ

	stServerPlayerData serverPlayerData[GAME_PLAYER + 1];//�������

	stHistoryScore historyScore[GAME_PLAYER];//�ɼ�

};


struct CMD_SC_SMALL_TIP//����С��
{
	BYTE byChairID;//��λ��

	bool bHelp[3];//��λ�ֽڶ���
};

struct CMD_SC_PLAYER_CHIP//�����ע
{
	INT32 iChip;//��עֵ
	BYTE byChairID;//��λ��

	bool bHelp[3];//��λ�ֽڶ���
};

struct CMD_SC_DEAL_POKER//����
{
	stDealPoker pokerData[GAME_PLAYER + 1];//�˿�����
};

struct CMD_SC_PLAYER_INSURANCE//��ұ���
{
	BYTE byChairID;//��λ��
	bool bInsurance;//�Ƿ�����

	bool bHelp[2];//��λ�ֽڶ���
};

struct CMD_SC_LOOK_ZJ_BLAKC_JACK//�鿴ׯ���Ƿ�ڽܿ�
{
	bool bZJBlackJack;//ׯ���Ƿ�ڽܿ�
	BYTE byPokerData;//�˿�����

	bool bHelp[2];//��λ�ֽڶ���
};

struct CMD_SC_GAME_END//��Ϸ����
{
	enGameEndType gameEndType;//��Ϸ��������

	stGameResult gameResult[GAME_PLAYER][C_SPLIT_POKER_COUNT];//�����Ӯ

	stHistoryScore historyScore[GAME_PLAYER];//�ɼ�
};

struct CMD_SC_PLAYER_BLACK_JACK//��Һڽܿ�
{
	BYTE byChairID;//��λ��

	bool bHelp[3];//��λ�ֽڶ���
};

struct CMD_SC_NORMAL_OPERATE//��ͨ����
{
	BYTE byChairID;//��λ��
	bool bCanSplitPoker;//�Ƿ��ܹ�����

	bool bHelp[2];//��λ�ֽڶ���
};

struct CMD_SC_PLAYER_NORMAL_OPERATE//�����ͨ����
{
	enPlayerNormalOperate playerNormalOperate;//�����ͨ����
	stDealPoker pokerData;//�˿�����

	BYTE byChairID;//��λ��
	bool bBustPoker;//����
	bool b21;//21��

	bool bSelfStopPoker;//�Լ�ͣ��

	//bool bHelp;//��λ�ֽڶ���
};

struct CMD_SC_LOOK_ZJ_SECOND_POKER//�鿴ׯ�ҵڶ�����
{
	BYTE byPokerData;//�˿�����
};

struct CMD_SC_NEW_PLAYER_ENTER_AT_CHIP//���������ע״̬ʱ���� 
{
	BYTE byChairID;//��λ��
};



//�ͷ��˷��ͽṹ��
struct CMD_CS_PLAYER_CELLSCORE//������
{
	LONG lCellScore;//������
};

struct CMD_CS_PLAYER_CHIP//�����ע
{
	INT32 iChip;//��עֵ
};

struct CMD_CS_PLAYER_INSURANCE//��ұ���
{
	bool bInsurance;//�Ƿ�����

	bool bHelp[3];//��λ�ֽڶ���
};

struct CMD_CS_PLAYER_NORMAL_OPERATE//�����ͨ����
{
	enPlayerNormalOperate playerNormalOperate;//�����ͨ����
};

struct CMD_CS_TE_SHU_CHU_LI//���⴦��
{
	BYTE byChairID;//��λ��
	bool bWinLost;//��Ӯ

	bool bHelp[2];//��λ�ֽڶ���
};



#endif