--数学函数表
local TBMathAide = {}

local M_PI = 3.14159265

--计算距离
function TBMathAide:CalcDistance(x1,y1,x2,y2)
	--返回距离绝对值
	return math.sqrtf((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
end

--计算角度
function TBMathAide:CalcAngle(x1,y1,x2,y2)
	--计算距离
	local distance = self:CalcDistance(x1, y1, x2, y2);
	if (distance == 0.f) return 0.f;

	--计算起点到终点的SIN值
	local sin_value = (x2 - x1) / distance;

	--计算反余弦值--角度
	local angle = math.acosf(sin_value);
	if (y1 > y2) angle = 2 * M_PI - angle;
	return angle;
end

--弧度转角度
float TBMathAide:TurnAngleTo(fAngle)
{
	return 360 - fAngle * 180 / M_PI;
}

return TBMathAide