- note: tab自动补全

-- 1、模糊匹配播放列表

on run(q)
	set keyword to item 1 of q
    tell application "Music"
        set allPlaylists to every playlist
        set xmlOutput to "<?xml version='1.0'?><items>"
        repeat with aPlaylist in allPlaylists
            set playlistName to name of aPlaylist
            -- 进行模糊匹配
            if playlistName contains keyword then
				set xmlOutput to xmlOutput & "<item relevance='80' uid='" & playlistName & "' arg='playlist:" & playlistName & "' valid='yes' autocomplete='" & playlistName & "'><title>" & playlistName & "</title><subtitle>[按Tab自动补齐]播放此播放列表</subtitle></item>"
            end if
        end repeat
        set xmlOutput to xmlOutput & "</items>"
        return xmlOutput
    end tell
end run

-- 2、获取播放列表里的所有歌曲, 转义防止xml解析失败

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
            set escapedTrack to xmlEscape(track)
			set xmlOutput to xmlOutput & "<item relevance='30' uid='" & track & "' arg='" & track & "' valid='yes'><title>" & track & "</title><subtitle>播放此音乐</subtitle></item>"
        end repeat
        set xmlOutput to xmlOutput & "</items>"

        -- 输出结果
        return xmlOutput
    on error errMsg number errNum
        -- 处理错误
        log "General error: " & errMsg & " (Error number: " & errNum & ")"
        set xmlOutput to "<?xml version='1.0'?><items><item uid='error' arg='' valid='no'><title>无法精确找到播放列表</title></item></items>"
        return xmlOutput
    end try
end run


-- 定义 XML 转义函数
on xmlEscape(str)
	log str
	set result0 to str
	set replacements to {{"&", "&amp;"}, {"<", "&lt;"}, {">", "&gt;"}, {"\"", "&quot;"}, {"'", "&apos;"}}
	repeat with replacement in replacements
		set searchStr to item 1 of replacement
		set replaceStr to item 2 of replacement
		try
			set oldDelimiters to AppleScript's text item delimiters
			set AppleScript's text item delimiters to searchStr
			set parts to text items of result0
			set AppleScript's text item delimiters to replaceStr
			set result0 to parts as string
			set AppleScript's text item delimiters to oldDelimiters
		on error errMsg number errNum
			log "Error replacing " & searchStr & " with " & replaceStr & ": " & errMsg & " (Error number: " & errNum & ")"
		end try
	end repeat
	log "xmlEscape result: " & result0
	return result0
end xmlEscape

-- 3、conditonal进行判断
通过argv是否以playlist:开头来进行分支处理

-- 4、播放播放列表
on run (argv)
	log "argv: " & argv
	set inputText to item 1 of argv
	-- 提取播放列表名称
	set playlistName to text ((offset of ":" in inputText) + 1) thru -1 of inputText
	tell application "Music"
		play playlist playlistName
	end tell
end run


-- 5、播放歌曲
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