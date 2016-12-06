-- 外部库 登记
local package_list = package_list or {
    bit = true,
    lfs = true,
    cjson = true,
    pb = true,
    socket = true,
}
 
-- 全局性质类/或禁止重新加载的文件记录
local ignored_file_list = ignored_file_list or {
    global = true ,
}
 
--已重新加载的文件记录
local loaded_file_list = loaded_file_list or {}
 
--视图排版控制
function leading_tag( indent )
    -- body
    if indent < 1 then
        return ''
    else
        return string.rep( '    |',  indent - 1  ) .. '    '
    end
end
 
function reload_module(mName)
LCLog("reload_ 111")
    local old_module = _G[mName]
LCLog("reload_ 222")
    if(old_module == nil) then
        LCLog("没有重载模块！")
        return
    end
LCLog("reload_ 333")
    package.loaded[mName] = nil
LCLog("reload_ 444")
    require (mName)
LCLog("reload_ 555")
    local new_module = _G[mName]
LCLog("reload_ 666")
    for k, v in pairs(new_module) do
        LCLog("reload_ 777")
        old_module[k] = v
    end
LCLog("reload_ 888")
    package.loaded[mName] = old_module
LCLog("reload_ 999")
end

--关键递归重新加载函数
--filename 文件名
--indent   递归深度, 用于控制排版显示
function recursive_reload( filename, indent )
    -- body
    if package_list[filename] then 
        --对于 外部库, 只进行重新加载, 不做递归子文件
        --卸载旧文件
        package.loaded[filename] = nil
 
        --装载新文件
        require(filename)
 
        --标记"已被重新加载"
        loaded_file_list[filename] = true
 
        LCLog("--- 重载文件 ---")
        LCLog( leading_tag(indent) .. filename .. "... done" )
        return true
    end
 
    --普通文件
    --进行 "已被重新加载" 检测
    if loaded_file_list[ filename] then 
        LCLog("--- 重载检测 ---")
        LCLog( leading_tag(indent) .. filename .. "...already been reloaded IGNORED" )
        return true
    end
 
    local fullPath = cc.FileUtils:getInstance():fullPathForFilename(string.gsub(filename, '%.', '/') .. '.lua');
    if fullPath == "" then
        LCLog("无此路径:==>"..filename)
        return true
    end

    -- --排除自己
    -- if filename=="app.views.common.ReloadCode" then
    --     LCLog("排除【自己】不被再加载 fileName => "..filename)
    --     return true
    -- end 

    --排除cocos2dx的文件
    if filename=="config" or filename=="cocos.init" then
        LCLog("排除cocos2dx的文件 fileName => "..filename)
        return true
    end

    LCLog("io.open => "..fullPath)
    --读取当前文件内容, 以进行子文件递归重新加载
    local file, err = io.open( fullPath )
    if file == nil then 
        LCLog("递归文件时出错！")
        LCLog( string.format("failed to reaload file(%s), with error:%s", fullPath, err or "unknown" ) )
        return false
    end
 
    LCLog( leading_tag(indent) .. filename .. "<===>")
 
    -- 缓存文件内容，及时关闭文件，否则文件不可写入
    local data = {}
    local comment = false
    for line in file:lines() do
        line = string.trim(line);
        if string.find(line, '%-%-%[%[%-%-') ~= nil then
            comment = true;
        end
 
        if comment and (string.find(line, '%]%]') ~= nil or string.find(line, '%-%-%]%]%-%-') ~= nil) then
            comment = false;
        end
 
        -- 被注释掉的，和持有特殊标志的require文件不重新加载
        local linecomment = (line[1] == '-' and line[2] == '-')
        if not comment and not linecomment and string.find(line, '%-%- Ignore Reload') == nil  then
            table.insert(data, line);
        end
    end

    io.close(file)
 
    local function getFileName(line)
        local begIndex = string.find(line, "'");
        local endIndex = string.find(line, "'", (begIndex or 1) + 1)
        if begIndex == nil or endIndex == nil then
            begIndex = string.find(line, '"');
            endIndex = string.find(line, '"', (begIndex or 1) + 1)
        end
 
        if begIndex == nil or endIndex == nil then
            return nil;
        end
 
        return string.sub(line, begIndex + 1, endIndex - 1)
    end

    -- 先解析文件，加载里面的子文件
    for _,line in ipairs(data) do
        -- 去除空白符
        --line = string.gsub( line, '%s', '' )
        local subFileName = nil 
        if string.find(line, 'require') ~= nil then
            subFileName = getFileName(line);
        elseif string.find(line, 'import') ~= nil then
            -- TODO 兼容import 通过fullPath进行解析
            subFileName = nil
        end
 
        if subFileName then
            --LCLogInfo('file: %s     subFile: %s', line, subFileName)
            --进行递归 
            local success = recursive_reload( subFileName, indent + 1 )
            if not success then 
                LCLog( string.format( "failed to reload sub file of (%s)", filename ) )
                return false
            end
 
        end
    end    

    -- "后序" 处理当前文件...
    if ignored_file_list[ filename] then
        --忽略 "禁止被重新加载"的文件
        LCLog( leading_tag(indent) .. filename .. "... IGNORED" )
        return true
    else
        -- --已加载检测
        -- if package.loaded[filename]==nil then
        --     LCLog("该文件还没被加载："..filename)
        --     return true
        -- end
        
        --重装载函数
        --local lmName = filename
        --reload_module(lmName)

        LCLog("准备重载："..filename)

        --卸载旧文件
        package.loaded[filename] = nil

        LCLog("重载==>"..filename)

        --装载新文件
        require(filename)
 
        LCLog("重载><完成==>"..filename)

        --设置"已被重新加载" 标记
        loaded_file_list[filename] = true
        LCLog(leading_tag(indent) .. filename .. " ... done" )
        return true
    end
end
 
--主入口函数
function reload_script_files()
     
    LCLog("[reload_script_files...]")
 
    loaded_file_list = {}
 
    --本项目是以 main.lua 为主文件
    --recursive_reload( "MainController", 0 )
    recursive_reload( "main", 0 )

    LCLog("[reload_script_files...done]")
 
    return "reload ok"
end