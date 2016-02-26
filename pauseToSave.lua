
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
  stringTime = ""
  fileCreated = false
  local item = vlc.input.item()
  if not (item==nil) then
    create_file()
  end
end

function deactivate()
  
end

function meta_changed()

end

function playing_changed()
  vlc.msg.dbg("[Dummy] Status: " .. vlc.playlist.status())
  if vlc.playlist.status()=="playing" then
    if not fileCreated then 
      create_file()
    end
  end
  if vlc.playlist.status()=="paused" then
    show_ui()  
  end
  if vlc.playlist.status()=="stopped" then
    close_file()
  end
end

function show_ui()
  d = vlc.dialog("would you like to save this spot")
  if not started then
    timest = get_time()
    d:set_title("Start?")
    d:add_button("Start", log)
    d:add_button("Do Nothing", hide_ui)
    d:show()
  else
    timend = get_time()
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
  --vlc.msg.dbg("Time: " ..  input)
  write_to_file()
  d:delete()
end

function hide_ui()
  d:delete()
end

function write_to_file()
  if not fileCreated then 
    create_file()
  end
  file:write(timest .. " to " .. timend .. " :" ..  input .. "\n")
  vlc.msg.dbg("Output time  = " .. timest .. "to " .. timend)
end

function close_file()
  file:write("\n")
  file:close()
  fileCreated = false
end

function create_file()
  vlc.msg.dbg("in createFile")
  fileCreated = true
  get_time()
  file = io.open("/home/hauser2016/Documents/VLCoutput/" .. os.date("%m-%d-%Y", time) .. ".txt","a+")
  file:write("Annotated on: " .. os.date() .. "\n------------------------------------------------\n\n")
end

function get_time()
  vid = vlc.input.item()
  obj = vlc.object.input()
  name = vid:name()

  timeList = {month=name:sub(9,10) , day=name:sub(11,12), year=name:sub(5,8), hour=name:sub(14,15), min=name:sub(16,17), sec = name:sub(18,19)}
  time = os.time(timeList) 
  currentTime = time + vlc.var.get(obj, "time")
  timestr = os.date("%H:%M:%S", currentTime)
  vlc.msg.dbg("Time = " .. timestr)

  return timestr
 
end
