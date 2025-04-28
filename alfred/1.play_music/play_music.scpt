-- note: 模糊匹配播放列表, 第一个匹配的进行播放

on run(argv)
	set playlistName to item 1 of argv
    try
        tell application "Music"
            -- 若应用未运行则启动它
            if not (it is running) then
                launch
                -- 等待应用启动
                repeat until it is running
                    delay 0.1
                end repeat
            end if
            -- 查找指定名称的播放列表（模糊匹配）
            set allPlaylists to every user playlist
            set targetPlaylist to missing value
            repeat with aPlaylist in allPlaylists
                if playlistName is in name of aPlaylist then
                    set targetPlaylist to aPlaylist
                    exit repeat
                end if
            end repeat
            if targetPlaylist is not missing value then
                -- 播放该播放列表
                play targetPlaylist
				-- 显示成功的 HUD 通知
                display notification "已开始播放" with title "播放成功" subtitle "正在播放播放列表: " & (name of targetPlaylist) sound name "Glass"
                return "正在播放播放列表: " & (name of targetPlaylist)
            else
				-- 显示未找到的 HUD 通知
                display notification "请检查输入的名称" with title "未找到播放列表" subtitle "未找到匹配的播放列表: " & playlistName sound name "Basso"
                return "未找到匹配的播放列表: " & playlistName
            end if
        end tell
    on error errMsg
        return "发生错误: " & errMsg
    end try
end run