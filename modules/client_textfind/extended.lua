function init()

	connect(g_game, 'onTextMessage', serverComunication)
	connect(g_game, { onGameEnd = hide } )
end

function terminate()
	disconnect(g_game, { onGameEnd = hide })
	disconnect(g_game, 'onTextMessage', serverComunication)

end

function hide()
end

function serverComunication(mode, text)
	if not g_game.isOnline() then
		return
	end
	
	if mode == MessageModes.Failure then
		if text:find("##system##CTCH") then
		local param = text:explode(",")
		modules.game_healthinfo.onCaughtChange(0, tonumber(param[2]))
		return
		
		elseif text:find("##system##TORN") then
		local param = text:explode(",")
		modules.game_healthinfo.onTrophyChange(0, tonumber(param[2]))
			return
		end
	end
end
