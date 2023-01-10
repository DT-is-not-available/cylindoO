@echo off

title launching cylindoO

echo Checking installation...
if exist "C:\Program Files (x86)\Steam\steamapps\common\circloO\circloo2.exe" (
	echo Steam installation found
	echo Patching data.win
	if not exist ".\umtcli\" (
		echo utmcli/ folder not found
		exit 1
	)
	if not exist ".\umtcli\UndertaleModCLI.exe" (
		echo utmcli/UndertaleModCLI.exe not found
		exit 1
	)
	if not exist ".\main.csx" (
		echo main.csx not found
		exit 1
	)
	umtcli\UndertaleModCLI.exe load "C:\Program Files (x86)\Steam\steamapps\common\circloO\data.win" -s "main.csx" -o "data.win"
	exit 0
) else (
	echo No installation found
	exit 1
)
exit 0