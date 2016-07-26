@if exist tsc.ptn del tsc.ptn
@sbc.exe -vertsc=%1
@if not exist sbptn.001 goto ERROR

@AddHeader.pl %1

@authmd5.exe sbptn.001 tsc.ptn

@if not exist tsc.ptn goto ERROR
@rem del sbptn.001 >nul

@echo Build tsc.ptn (pattern version %1) success!
@goto END

:ERROR
@echo Build tsc.ptn (pattern version %1) failed!

:END