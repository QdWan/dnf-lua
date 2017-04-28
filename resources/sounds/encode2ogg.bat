@ffmpeg -i %1 -ab 64k -ar 44100 -map_metadata 0 -id3v2_version 3 "%~n1.ogg" -y
)
