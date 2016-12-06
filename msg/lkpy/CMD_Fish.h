
#ifndef CMD_FISH_H_
#define CMD_FISH_H_

#pragma pack(1)

//////////////////////////////////////////////////////////////////////////
// 服务定义

#define KIND_ID               GK_Fish_Lkpy
#define GAME_NAME             TEXT("李逵劈鱼")
#define GAME_PLAYER           4
#define VERSION_SERVER        101056515       // PROCESS_VERSION(1,0,0)
#define VERSION_CLIENT        101056515       // PROCESS_VERSION(1,0,0)

// 简单的版本检测
// 如果客户端有更新应该更改这个值.如果只修改EXE的版本而网络数据包没修改的话，更新客户端是没什么意义的，因为EXE的版本是可以直接被修改的
// 只要保存以前的EXE版本,更新完之后再换回去，如果有BUG的话等于还是没修复。
#define GAME_VERSION			30
#define CMD_VERSION_CHECK		0xAF09
//////////////////////////////////////////////////////////////////////////
//炸弹最大炸死
#define BOMB_KILL_MAX			100			//炸弹最大杀死数目
#define SENCE_ID_MAX			300			//场景最大鱼量

//最大特殊子弹数目
#define SPE_BULLET_MAX			200

//开火频率
#define FIRE_INTERVAL_DEALY		350			//开火延迟

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
// 游戏定义

/*
// 座位号
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
	FISH_KIND_20, // 企鹅
	FISH_KIND_LK, // 李逵
	FISH_KIND_22, // 定屏炸弹
	FISH_KIND_23, // 局部炸弹
	FISH_KIND_24, // 超级炸弹
	FISH_KIND_25, // 大三元1
	FISH_KIND_26, // 大三元2
	FISH_KIND_27, // 大三元3
	FISH_KIND_28, // 大四喜1
	FISH_KIND_29, // 大四喜2
	FISH_KIND_30, // 大四喜3
	FISH_KIND_31, // 鱼王1
	FISH_KIND_32, // 鱼王2
	FISH_KIND_33, // 鱼王3
	FISH_KIND_34, // 鱼王4
	FISH_KIND_35, // 鱼王5
	FISH_KIND_36, // 鱼王6
	FISH_KIND_37, // 鱼王7
	FISH_KIND_38, // 鱼王8
	FISH_KIND_39, // 鱼王9
	FISH_KIND_40, // 鱼王10

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

const DWORD kBulletIonTime = 20;			//特殊子弹时间
const DWORD kLockTime = 10;					//锁屏时间
const int kMaxCatchFishCount = 1;			//最大捕获数目
const int kMaxFishGroup = 15;				//鱼群最大数目

//////////////////////////////////////////////////////////////////////////
// 服务端命令

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
#define SUB_ANDROID_FIRE					214			//机器人专用
#define SUB_S_SITSCORESAME					215

#define SUB_S_NOTIFY						115			//文字通知

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
	WORD		chair_id;					//玩家位置
	SCORE		llFishScore;				//玩家鱼分
};

struct CMD_S_UserFire
{
	WORD			chair_id;				//位置ID
	BulletKind		bullet_kind;			//子弹种类
	float			angle;					//子弹角度
	int				lock_fishid;			//锁鱼ID
	SCORE			fish_score;				//玩家鱼分
};

struct CMD_S_CatchFish
{
	WORD		chair_id;
	int			fish_id;
	FishKind	fish_kind;
	bool		bullet_ion;
	SCORE		fish_score;					//捕中鱼分
	SCORE		userScore;					//玩家分数
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
	SCORE		fish_score;					//捕中鱼分
	SCORE		userScore;					//玩家分数
};

struct CMD_S_CatchSweepFishResult
{
	WORD		chair_id;
	int			fish_id;
	SCORE		fish_score;
	SCORE		userScore;					//玩家鱼分
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
// 客户端命令
#define SUB_C_HIT_FISH_I                    13
#define SUB_C_CATCH_FISH                    14
#define SUB_C_EXCHANGE_FISHSCORE            15
#define SUB_C_USER_FIRE                     16
#define SUB_C_CATCH_SWEEP_FISH              17
#define SUB_C_FISH20_CONFIG                 19
#define SUB_C_HEART_SET						20

struct CMD_C_ExchangeFishScore
{
	WORD		wVersion;				//版本号
	bool		increase;				//上分/下分
};

struct CMD_C_UserFire
{
	BulletKind	bullet_kind;			//子弹种类
	float		angle;
	int			lock_fishid;
	DWORD		dwUnkTime;				//攻击计时
};

struct CMD_C_CatchFish
{
	WORD		chair_id;				//椅子ID
	int			fish_id;				//鱼ID
	BulletKind	bullet_kind;			//子弹种类
	int			iFishMutil;				//鱼倍数
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

