
function descriptor()
  return {
    title = "VLC Dummy Extension",
    capabilities = { "playing-listener" }
  }
end

function activate()
end

function deactivate()
end

function meta_changed()
end

function playing_changed()
  vlc.msg.dbg("[Dummy] Status: " .. vlc.playlist.status())
end
