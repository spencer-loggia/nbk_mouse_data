
@echo off
set /P date=Enter date (DD-MonthCode-YYYY) ex. 01-Jan-2000 ::
echo %date%
cmd /k matlab -r -wait -log "addpath('F:\MysoreData\nbk\matlabcode'); calling_final('%date%',0);

