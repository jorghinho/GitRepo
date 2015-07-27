@echo ##### #   # ##### ##### ####  ##### #   # #####
@echo #     ##  # #     #   # #   #   #   ##  # #
@echo ###   # # # #     #   # #   #   #   # # # # ###
@echo #     #  ## #     #   # #   #   #   #  ## #   #
@echo ##### #   # ##### ##### ####  ##### #   # ##### ## ## ##
@"C:\winapp\3D\3ds Max 2014\stdplugs\stdscripts\lbTools\exe\ffmpeg.exe" -y -loglevel panic -i "%1" -acodec pcm_s16le -vcodec libx264 -preset fast -profile:v baseline -pix_fmt yuv420p "%~dp1%~n1.mov"
start %~dp1%~n1.mov