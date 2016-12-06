
#ifndef CMD_FISH_H_
#define CMD_FISH_H_

#pragma pack(1)

//////////////////////////////////////////////////////////////////////////
// ������

#define KIND_ID               GK_Fish_Lkpy
#define GAME_NAME             TEXT("��������")
#define GAME_PLAYER           4
#define VERSION_SERVER        101056515       // PROCESS_VERSION(1,0,0)
#define VERSION_CLIENT        101056515       // PROCESS_VERSION(1,0,0)

// �򵥵İ汾���
// ����ͻ����и���Ӧ�ø������ֵ.���ֻ�޸�EXE�İ汾���������ݰ�û�޸ĵĻ������¿ͻ�����ûʲô����ģ���ΪEXE�İ汾�ǿ���ֱ�ӱ��޸ĵ�
// ֻҪ������ǰ��EXE�汾,������֮���ٻ���ȥ�������BUG�Ļ����ڻ���û�޸���
#define GAME_VERSION			30
#define CMD_VERSION_CHECK		0xAF09
//////////////////////////////////////////////////////////////////////////
//ը�����ը��
#define BOMB_KILL_MAX			100			//ը�����ɱ����Ŀ
#define SENCE_ID_MAX			300			//�����������

//��������ӵ���Ŀ
#define SPE_BULLET_MAX			200

//����Ƶ��
#define FIRE_INTERVAL_DEALY		350			//�����ӳ�

//////////////////////////////////////////////////////////////////////////

#ifndef SCORE
#define SCORE LONGLONG
#endif

const int kResolutionWidth = 1366;
const int kResolutionHeight = 768;

#ifndef M_PI
#define M_PI    3.14159265358979323846f
#define M_PI_2  1.57079632679489661923f
#define M_PI_4  0.785398163397448309616f
#define M_1_PI  0.318309886183790671538f
#define M_2_PI  0.636619772367581343076f
#endif
//const float kChairDefaultAngle[GAME_PLAYER] = { M_PI, M_PI, M_PI, -M_PI_2, 0, 0, 0, M_PI_2 };
//const float kChairDefaultAngle[GAME_PLAYER] = { M_PI, M_PI, M_PI,  0, 0, 0 };
const float kChairDefaultAngle[GAME_PLAYER] = { M_PI, M_PI, 0, 0 };

enum TraceType {
	TRACE_LINEAR = 0,
	TRACE_BEZIER
};

struct FPoint {
	float x;
	float y;
};

struct FPointAngle {
	float x;
	float y;
	float angle;
};

//////////////////////////////////////////////////////////////////////////
// ��Ϸ����

/*
// ��λ��
-------------
	0   1
	3	2
-------------
*/

enum SceneKind {
	SCENE_KIND_1 = 0,
	SCENE_KIND_2,
	SCENE_KIND_3,
	SCENE_KIND_4,
	SCENE_KIND_5,

	SCENE_KIND_COUNT
};

enum FishKind 
{
	FISH_KIND_1 = 0,
	FISH_KIND_2,
	FISH_KIND_3,
	FISH_KIND_4,
	FISH_KIND_5,
	FISH_KIND_6,
	FISH_KIND_7,
	FISH_KIND_8,
	FISH_KIND_9,
	FISH_KIND_10,
	FISH_KIND_11,
	FISH_KIND_12,
	FISH_KIND_13,
	FISH_KIND_14,
	FISH_KIND_15,
	FISH_KIND_16,
	FISH_KIND_17,
	FISH_KIND_18,
	FISH_KIND_19,
	FISH_KIND_20, // ���
	FISH_KIND_LK, // ����
	FISH_KIND_22, // ����ը��
	FISH_KIND_23, // �ֲ�ը��
	FISH_KIND_24, // ����ը��
	FISH_KIND_25, // ����Ԫ1
	FISH_KIND_26, // ����Ԫ2
	FISH_KIND_27, // ����Ԫ3
	FISH_KIND_28, // ����ϲ1
	FISH_KIND_29, // ����ϲ2
	FISH_KIND_30, // ����ϲ3
	FISH_KIND_31, // ����1
	FISH_KIND_32, // ����2
	FISH_KIND_33, // ����3
	FISH_KIND_34, // ����4
	FISH_KIND_35, // ����5
	FISH_KIND_36, // ����6
	FISH_KIND_37, // ����7
	FISH_KIND_38, // ����8
	FISH_KIND_39, // ����9
	FISH_KIND_40, // ����10

	FISH_KIND_COUNT
};

enum BulletKind {
	BULLET_KIND_1_NORMAL = 0,
	BULLET_KIND_2_NORMAL,
	BULLET_KIND_3_NORMAL,
	BULLET_KIND_4_NORMAL,
	BULLET_KIND_SPE_ION,

	BULLET_KIND_COUNT
};

const DWORD kBulletIonTime = 20;			//�����ӵ�ʱ��
const DWORD kLockTime = 10;					//����ʱ��
const int kMaxCatchFishCount = 1;			//��󲶻���Ŀ
const int kMaxFishGroup = 15;				//��Ⱥ�����Ŀ

//////////////////////////////////////////////////////////////////////////
// ���������

#define SUB_S_CATCH_SWEEP_FISH              202
#define SUB_S_BULLET_ION_TIMEOUT            203
#define SUB_S_USER_FIRE                     204
#define SUB_S_FISH_TRACE                    205
#define SUB_S_GAME_CONFIG                   206
#define SUB_S_EXCHANGE_FISHSCORE            207
#define SUB_S_CATCH_FISH                    208
#define SUB_S_LOCK_TIMEOUT                  209
#define SUB_S_CATCH_SWEEP_FISH_RESULT       210
#define SUB_S_HIT_FISH_LK                   211
#define SUB_S_SWITCH_SCENE                  212
#define SUB_S_SCENE_END                     213
#define SUB_ANDROID_FIRE					214			//������ר��
#define SUB_S_SITSCORESAME					215

#define SUB_S_NOTIFY						115			//����֪ͨ

struct CMD_S_Notify
{
	char			szNotify[128];
};

struct CMD_S_SetScoreSame
{
	WORD		wChairID;
	SCORE		fishScore;
};

struct CMD_S_GameStatus
{
	DWORD game_version;
	SCORE fish_score[GAME_PLAYER];
};

struct CMD_S_GameConfig
{
	int exchange_ratio_userscore;
	int exchange_ratio_fishscore;
	int exchange_count;

	int min_bullet_multiple;
	int max_bullet_multiple;

	int bomb_range_width;
	int bomb_range_height;

	WORD fish_multiple[FISH_KIND_COUNT];
	BYTE fish_speed[FISH_KIND_COUNT];
	WORD fish_bounding_box_width[FISH_KIND_COUNT];
	WORD fish_bounding_box_height[FISH_KIND_COUNT];
	WORD fish_hit_radius[FISH_KIND_COUNT];

	WORD bullet_speed[BULLET_KIND_COUNT];
	WORD net_radius[BULLET_KIND_COUNT];
};

struct CMD_S_FishTrace
{
	FPoint init_pos[5];
	BYTE init_count;
	BYTE fish_kind;
	int fish_id;
	BYTE trace_type;
};

struct CMD_S_ExchangeFishScore
{
	WORD		chair_id;					//���λ��
	SCORE		llFishScore;				//������
};

struct CMD_S_UserFire
{
	WORD			chair_id;				//λ��ID
	BulletKind		bullet_kind;			//�ӵ�����
	float			angle;					//�ӵ��Ƕ�
	int				lock_fishid;			//����ID
	SCORE			fish_score;				//������
};

struct CMD_S_CatchFish
{
	WORD		chair_id;
	int			fish_id;
	FishKind	fish_kind;
	bool		bullet_ion;
	SCORE		fish_score;					//�������
	SCORE		userScore;					//��ҷ���
};

struct CMD_S_BulletIonTimeout
{
	WORD		chair_id;
};

struct CMD_S_CatchSweepFish
{
	WORD		chair_id;
	int			fish_id;
	FishKind	fish_kind;
	SCORE		fish_score;					//�������
	SCORE		userScore;					//��ҷ���
};

struct CMD_S_CatchSweepFishResult
{
	WORD		chair_id;
	int			fish_id;
	SCORE		fish_score;
	SCORE		userScore;					//������
	int			catch_fish_count;
	int			catch_fish_id[BOMB_KILL_MAX];
};

struct CMD_S_HitFishLK
{
	WORD		chair_id;
	int			fish_id;
	int			fish_mulriple;
};

struct CMD_S_SwitchScene
{
	SceneKind	scene_kind;
	int			fish_count;
	FishKind	fish_kind[SENCE_ID_MAX];
	int			fish_id[SENCE_ID_MAX];
};

struct CMD_S_StockOperateResult
{
	BYTE		operate_code;
	SCORE		stock_score;
};

//////////////////////////////////////////////////////////////////////////
// �ͻ�������
#define SUB_C_HIT_FISH_I                    13
#define SUB_C_CATCH_FISH                    14
#define SUB_C_EXCHANGE_FISHSCORE            15
#define SUB_C_USER_FIRE                     16
#define SUB_C_CATCH_SWEEP_FISH              17
#define SUB_C_FISH20_CONFIG                 19
#define SUB_C_HEART_SET						20

struct CMD_C_ExchangeFishScore
{
	WORD		wVersion;				//�汾��
	bool		increase;				//�Ϸ�/�·�
};

struct CMD_C_UserFire
{
	BulletKind	bullet_kind;			//�ӵ�����
	float		angle;
	int			lock_fishid;
	DWORD		dwUnkTime;				//������ʱ
};

struct CMD_C_CatchFish
{
	WORD		chair_id;				//����ID
	int			fish_id;				//��ID
	BulletKind	bullet_kind;			//�ӵ�����
	int			iFishMutil;				//�㱶��
};

struct CMD_C_CatchSweepFish
{
	WORD		chair_id;
	int			fish_id;
	int			iTotalMutil;
	int			catch_fish_count;
	int			catch_fish_id[BOMB_KILL_MAX];
};

struct CMD_C_HitFishLK
{
	int			fish_id;
};

struct CMD_C_HeartSet
{
	WORD		wUnk;
};

#pragma pack()

#endif // CMD_FISH_H_

