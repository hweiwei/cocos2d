---------------------------------------------------------------------------
--游戏大厅消息
---------------------------------------------------------------------------
--消息定义
g_Global.Hall.msgHall = {
	-------------------------------------------------------
	--登陆服务器
	-------------------------------------------------------
	MOB_LM_LOGON				= 100,		--移动登陆

	CMD_LC_Logon_Key			= 10,		--登陆键
	CMD_LS_Logon_Key			= 100,		--返回允许的登陆键


	-------------------------------------------------------
	--大厅服务器
	-------------------------------------------------------
	MOB_LM_HALL					= 1000,		--移动登陆

	CMD_LC_GuestRegister		= 1000,		--游客注册
	CMD_LC_GuestLogon			= 1001,		--游客登陆

	CMD_LC_ReqGameRoom			= 1010,		--请求游戏房间

	-------------------------------------------------------
	CMD_LS_GuestRegSucc			= 1000,		--游客注册成功
	CMD_LS_GuestLogonSucc		= 1001,		--游客登陆成功
	CMD_LS_GuestLogonFail		= 1002,		--游客登陆失败
	CMD_LS_LogonComplete		= 1003,		--登陆完成
	CMD_LS_GameKind				= 2000,		--游戏种类
	CMD_LS_GameRoom				= 2001,		--游戏房间

	CMD_LS_ReqRoomRltInfo		= 2010,		--请求结果
	CMD_LS_ReqRoomRltFail		= 2011,		--请求失败
}
	
-- //登陆键值
-- struct ST_LogonC_Key
-- {
-- 	WORD					wSign;				//标记值
-- 	DWORD					nUnknow;			//未知随机值
-- 	CHAR					szMachine[33];		//机器码 - UserID - 随机数 - 组合
-- 	DWORD					nCKeyValue;			//验证键值

-- 	void BronKeyValue()
-- 	{
-- 		nCKeyValue = rand()*rand();
-- 		BYTE * pBy = (BYTE *)&nCKeyValue;
-- 		pBy[0] = 179 - pBy[3] % 43;
-- 		pBy[1] = 133 - pBy[2] % 77;  
-- 	}
-- 	bool IsRightKey()
-- 	{
-- 		BYTE * pBy = (BYTE *)&nCKeyValue;
-- 		if (179 != pBy[0] + pBy[3] % 43) return false;
-- 		if (133 != pBy[1] + pBy[2] % 77) return false;
-- 		return true;
-- 	}
-- };

-- //登陆键值
-- union LC_Logon_Key
-- {
-- 	LBYTE					byTmp[64];			//空间大小
-- 	ST_LogonC_Key			logonKey;			//登陆键
-- };

-- //效验键值
-- struct ST_LogonS_Key
-- {
-- 	LDWORD					dwVersion;			//版本号
-- 	LINT64					lSKeyValue;			//登陆键值
-- 	LDWORD					dwHallPort;			//大厅端口
-- };

-- //登陆键值
-- union LS_Logon_Key
-- {
-- 	LBYTE					byTmp[64];			//空间大小
-- 	ST_LogonS_Key			logonKey;			//登陆键
-- };


---------------------------------------------------------------------------
--大厅服务器
---------------------------------------------------------------------------
-- //////////////////////////////////////////////////////////////////////////////////
-- // 大厅服务器：唯一机器码 - GUID 
-- // 登陆：	A.首次登陆——先返回机器码，再返回登陆
-- //			B.多次登陆——用机器码登陆。
-- //////////////////////////////////////////////////////////////////////////////////

--//////////////////////////////////////////////////////////////////////////////////
-- //失败通知结构
-- struct LC_FailNotify
-- {
-- 	LWORD				wFCode;
-- 	LCHAR				szFailDescribe[LLEN_NOTIFY];//通知消息
-- };

-- //游客注册
-- struct LC_GuestRegister
-- {
-- 	//系统信息
-- 	LDWORD				dwPlazaVersion;				//广场版本
-- 	LWORD				wDeviceType;				//设备类型
-- 	LCHAR				szGuestPwd[LLEN_PASSWORD];	//游客密码

-- 	LUINT64				lRegKey;					//注册键值
-- };

-- //注册成功
-- struct LC_GuestRegisterSucc
-- {
-- 	//系统信息
-- 	LCHAR				szGuestAcc[LLEN_ACCOUNTS];	//游客账户
-- 	LCHAR				szGuestPwd[LLEN_PASSWORD];	//游客密码
-- };

-- //游客登陆
-- struct LC_GuestLogon
-- {
-- 	//系统信息
-- 	LDWORD				dwPlazaVersion;				//广场版本

-- 	LCHAR				szGuestAcc[LLEN_ACCOUNTS];	//游客账户
-- 	LCHAR				szGuestPwd[LLEN_PASSWORD];	//游客密码

-- 	LUINT64				lLogonKey;					//登陆键值
-- 	LDWORD				lRoundNum;					//序列值
-- };

-- //账号登陆
-- struct LC_AccountsLogon
-- {
-- 	//系统信息
-- 	LDWORD				dwPlazaVersion;				//广场版本

-- 	LCHAR				szAccounts[LLEN_ACCOUNTS];	//用户账号
-- 	LCHAR				szPassword[LLEN_PASSWORD];	//用户密码

-- 	LUINT64				lLogonKey;					//登陆键值
-- 	LDWORD				lRoundNum;					//序列值
-- };

-- //游客登陆成功
-- struct LC_GuestLogonSucc
-- {
-- 	LDWORD				dwUserID;					//玩家ID
-- 	LDWORD				dwGameID;					//游戏ID
-- 	LCHAR				szNickName[LLEN_NICKNAME];	//玩家昵称

-- 	LINT64				lScore;						//身上分
-- 	LINT64				lInsure;					//银行分
-- };

-- //游戏种类
-- struct LC_GameKind
-- {
-- 	LWORD				wKindID;					//种类ID
-- 	LWORD				wSortID;					//排序索引
-- 	LCHAR				szKindName[LLEN_KIND];		//游戏名字
-- };

-- //房间子信息
-- struct LC_RoomInfo
-- {
-- 	LINT32				nCellScore;					//基础分
-- 	LINT32				nLessScore;					//最低分
-- };

-- //房间信息
-- struct LC_GameRoom
-- {
-- 	LWORD				wKindID;					//种类ID
-- 	LWORD				wRoomCount;					//房间数量
-- 	LC_RoomInfo			lcRoomInfo[LROOMCELL_MAX];	//房间信息
-- };

-- //请求房间
-- struct LC_ReqRoomForLogon
-- {
-- 	LWORD				wKindID;					//种类ID
-- 	LC_RoomInfo			lcRoomInfo;
-- };

-- //房间信息
-- struct LC_ReqRltRoomForLogon
-- {
-- 	LWORD				wKindID;					//游戏ID
-- 	LWORD				wSrvPort;					//房间端口
-- };












