//////////////////////////////////////////////////////////////////////////
// ȫ�����ݣ�����������
#ifndef GLOBAL_DEFINE_FILE
#define GLOBAL_DEFINE_FILE

//////////////////////////////////////////////////////////////////////////
// ״̬����
#define IDI_CHECK_STATUS			0x01								//״̬��ʱ��
#define IDI_LOADGAME				0x02								//������Ϸ

#define	IDI_GAME_START				0x03								//��ʼ��Ϸ����ʼ��ע�� 
#define	IDI_STOP_CHIP				0x04								//ֹͣ��ע 
#define	IDI_RUN_START				0x05								//��ʼ���� 
#define	IDI_MATCH_OVER				0x06								//�������� 
#define IDI_CHIP_UPDATA				0x07								//ˢ����ע

#define IDI_ANDROID_CHAT			0x08								//����������

#define TIMER_CHECK_STATUS			1500								//״̬��ʱ
#define TIMER_LOADGAME				3000								//������Ϸ

#define TIMER_START_BASE			1000								//��ʼ����ʱ��
#define TIMER_GAMESTART				20000								//��ʼ��Ϸ����ʼ��ע�� 
#define TIMER_STOP_CHIP				2000								//ֹͣ��ע
#define TIMER_MATCH_START			20000								//��ʼ����������ʱ����
#define TIMER_MATCH_OVER			5000								//������������;��Ϣ��
#define TIMER_CHIP_UPDATA			1000								//������ע

//////////////////////////////////////////////////////////////////////////
#define TIMER_NET_DELAY				1000								//Ԥ��������ʱ

//////////////////////////////////////////////////////////////////////////
//���ּ���
#define APPEAR_ODDS_ONE				80					//һ�ų��ִ���
#define APPEAR_ODDS_TWO				66					//���ų��ִ���
#define APPEAR_ODDS_THREE			55					//���ų��ִ���
#define APPEAR_ODDS_FOUR			40					//�ĺų��ִ���
#define APPEAR_ODDS_FIVE			15					//��ų��ִ���
#define APPEAR_ODDS_SIX				4					//���ų��ִ���

#define APPEAR_ODDS_MAX			(APPEAR_ODDS_ONE+APPEAR_ODDS_TWO+APPEAR_ODDS_THREE+APPEAR_ODDS_FOUR+APPEAR_ODDS_FIVE+APPEAR_ODDS_SIX)

//////////////////////////////////////////////////////////////////////////
//�������
#define		HORSE_MAX				6					//�������

//////////////////////////////////////////////////////////////////////////
//����ٶȶ�
#define		SPEED_SEGMENT			6					//����ٶȶ�

//////////////////////////////////////////////////////////////////////////
//���ʱ�
#define		MULTIPLE_MAX			15					//��������

//////////////////////////////////////////////////////////////////////////
//�����ʷ��ϱ���
#define		HISTORYWEAV_MAX			15					//�����ʷ���

//////////////////////////////////////////////////////////////////////////
//���ׯ����ʾ
#define		SHOWZHUANG_MAX			6		

//////////////////////////////////////////////////////////////////////////
//��С��ׯ�ʽ�
#define		ZJNEEDMONEY_MIN			20000000


struct tagMultipleTable
{
	WORD		wNumber;			//����
	WORD		wMultiple;			//����
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
	//Ч�����
	if (iMax - iMin <= 0) return 0;

	//���������
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




