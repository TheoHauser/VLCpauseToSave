    --[[
    INSTALLATION (create directories if they don't exist):
    - put the file in the VLC subdir /lua/extensions, by default:
    * Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\extensions\
    * Windows (current user): %APPDATA%\VLC\lua\extensions\
    - Restart VLC.
    ]]--

    --[[ Extension description ]]

    function descriptor()
       return {
          title = "Diskdelete for Windows" ;
          version = "0.1" ;
          author = "Caglar Yanik" ;
          shortdesc = "DELETE current playing FILE FROM DISK for WINDOWS";
          description = "<h1>Diskdelete</h1>"
          .. "Windows does not delete files because of write permissions. "
          .. "<br>This extension saves the paths of the files to be deleted in a text file,"
          .. "<br>then reads the batch file and deletes the files on CMD."
          .. "<br>It will not use the Recycle Bin, the file will be gone immediately!"
          .. "<br>This extension has been tested on Windows 7 64 bit with VLC 2.0.7."
          .. "<br>The author is not responsible for damage caused by this extension.";
          url = ""
       }
    end

    --[[ Hooks ]]

    -- Activation hook
    function activate()
       vlc.msg.dbg("[Diskdelete] Activated")
       d = vlc.dialog("Diskdelete")
       d:add_label("<b>Zum Löschen freigeben?</b>")
      d:add_button("JA, ZUM LÖSCHEN MARKIEREN!", mark)
      d:add_button("Next File!", nextFile)
       d:show()
      datei = io.open("C:/Users/ph/Desktop/VLC_toDelete.txt", "a+")
    end --activate

    -- Deactivation hook
    function deactivate()
      datei:close()
      vlc.msg.dbg("[Diskdelete for Windows] Deactivated")
      vlc.deactivate()
    end --deactivate

    function close()
       deactivate()
    end --close

    --[[ The file deletion routine ]]
    function mark()
       item = vlc.input.item() -- get the current playing file
       uri = item:uri() -- extract it's URI
       filename = vlc.strings.decode_uri(uri) -- decode %foo stuff from the URI
       filename = string.sub(filename,9) -- remove 'file://' prefix which is 8 chars long -- 9 on Windows
      filename = string.gsub(filename, "/", "\\")  -- / replace \ for batch-file
      vlc.msg.dbg("[Diskdelete] selected for deletion: " .. filename)
      
      
       retval, err = datei:write(filename .. "\n")
       if(retval == nil) -- if write failed, print why
       then
         vlc.msg.dbg("[Diskdelete] error: " .. err)
         errord = io.open("C:/Users/ph/Desktop/VLC_toDeleteERRORS.txt", "a+")
         errord:write(filename .. "\t" .. err .. "\n")
         errord:close()
      
      else 
     
         currentID = vlc.playlist.current()
         vlc.playlist.delete(currentID)
         
         nextFile()
         filename=nil
         currentID=nil
      
      end --if

    end --mark
   
   function nextFile() 
      vlc.playlist.skip(1)
   end --next

    -- This empty function is there, because vlc pested me otherwise
    function meta_changed()
    end