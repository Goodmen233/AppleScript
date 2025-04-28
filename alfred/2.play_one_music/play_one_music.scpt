-- note: 模糊匹配播放列表到候选项, 然后精确匹配到曲目

-- 第一步

on run(argv)
    -- 获取播放列表名称
    set playlistName to item 1 of argv
    try
        -- 获取音乐列表
        tell application "Music"
            set musicTracks to name of every track in playlist playlistName
        end tell

        -- 输出 Alfred 结果 XML
        set xmlOutput to "<?xml version='1.0'?><items>"
        repeat with track in musicTracks
            set xmlOutput to xmlOutput & "<item uid='" & track & "' arg='" & track & "' valid='yes'><title>" & track & "</title><subtitle>播放此音乐</subtitle></item>"
        end repeat
        set xmlOutput to xmlOutput & "</items>"

        -- 输出结果
        return xmlOutput
    on error errMsg number errNum
        -- 处理错误
        set xmlOutput to "<?xml version='1.0'?><items><item uid='error' arg='' valid='no'><title>无法精确找到播放列表</title></item></items>"
        return xmlOutput
    end try
end run

-- 第二步


on run (argv)
	set trackName to argv
	log "trackName:" & trackName
	tell application "Music"
    -- 检查音乐应用是否正在运行，如果没有则启动它
    if it is not running then
        launch
    end if
    set allTracks to every track
    set foundTrack to false
    -- 遍历所有曲目，查找与指定名称匹配的曲目
    repeat with aTrack in allTracks
		set currentTrackName to name of aTrack
        if currentTrackName contains trackName then
            play aTrack
            set foundTrack to true
            exit repeat
        end if
    end repeat
    -- 如果未找到匹配的曲目，弹出提示对话框
    -- if not foundTrack then
    --    display dialog "未找到名为 " & trackName & " 的曲目。"
    -- end if
	end tell
end run