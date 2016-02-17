
function descriptor()
  return {
    title = "Pause To Save",
    capabilities = { "playing-listener" }
  }
end

function activate()
  started = false
end

function deactivate()
end

function meta_changed()
end

function playing_changed()
  vlc.msg.dbg("[Dummy] Status: " .. vlc.playlist.status())
  if vlc.playlist.status()=="paused" then
    show_ui()  
  end
end

function show_ui()
  d = vlc.dialog("would you like to save this spot")
  if not started then
    d:set_title("Start?")
    d:add_button("Start", log)
    d:add_button("Do Nothing", hide_ui)
    d:show()
  else
    d:set_title("Stop?")
    d:add_button("Stop", log)
    d:add_button("Do Nothing", hide_ui)
    w1 = d:add_text_input( text )
    d:show()
  end
end

function log()
  d:delete();
  if started then
    input = w1:get_text()
    vlc.msg.dbg("Time: " ..  input)
    started = false
  else
    started = true
  end
end

function hide_ui()
  d:delete()
end
