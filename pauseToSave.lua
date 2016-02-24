
function descriptor()
  return {
    title = "Pause to Save",
    version = "0.1" ;
    author = "Theo Hauser, Jimmy Klein " ;
    capabilities = { "playing-listener" }
  }
end

function activate()
  started = false
  input = ""
  item = vlc.input.item()
  name = item:name()
  vlc.msg.dbg("name =".. name)
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
  if vlc.playlist.status()=="stopped" then
    save_file()
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
    d:show()
  end
end

function log()
  d:delete()
  if started then
    d = vlc.dialog("Enter Label")
    d:set_title("Enter Label: ")
    w = d:add_text_input(text)
    w1 = d:add_button("Save Label", getText)
    started = false
  else
    started = true
  end
end

function getText()
  input = w:get_text(text)
  vlc.msg.dbg("Time: " ..  input)
  d:delete()
end

function hide_ui()
  d:delete()
end

function save_file()
  
end

function get_time()
  
end
