-- note: 模糊匹配播放列表到候选项, 然后播放播放列表

-- 第一步

on run(q)
    -- 去除 "play " 前缀，提取要搜索的播放列表名称关键词
	set keyword to item 1 of q
    tell application "Music"
        set allPlaylists to every playlist
        set xmlOutput to "<?xml version='1.0'?><items>"
        repeat with aPlaylist in allPlaylists
            set playlistName to name of aPlaylist
            -- 进行模糊匹配
            if playlistName contains keyword then
                set xmlOutput to xmlOutput & "<item uid='" & playlistName & "' arg='" & playlistName & "' valid='yes'><title>" & playlistName & "</title><subtitle>播放此播放列表</subtitle></item>"
            end if
        end repeat
        set xmlOutput to xmlOutput & "</items>"
        return xmlOutput
    end tell
end run

-- 第二步

on run(q)
    tell application "Music"
        -- 检查音乐应用是否正在运行，如果没有则启动它
        if it is not running then
            launch
        end if
        try
            -- 获取指定名称的播放列表
            set targetPlaylist to some playlist whose name is q
            -- 播放该播放列表
            play targetPlaylist
        on error
            -- 若出现错误，如播放列表不存在，弹出错误提示对话框
            display dialog "未找到名为 " & q & " 的播放列表。"
        end try
    end tell
end run