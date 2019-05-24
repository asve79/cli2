set here=%CD%
set labels=uart-main.lab
set unreal_path=c:\zx-speccy\Unreal-cli
set unreal=%unreal_path%\unreal.exe

call create_img.bat

if exist %unreal%\%labels% (
 delete %unreal%\%labels%
)

cd %unreal_path%

if exist %unreal%\%labels% (
 %unreal% -l%here%\%labels%
) else (
 %unreal%
)

:1
