cd c:\HCTest

c:\HCTest\HCTestDCE.exe HCSCAN C:\HCTest\scanresult.txt

if not exist c:\HCTest\scanresult.txt goto END

c:\HCTest\HCTestDCE.exe HCCLEAN C:\HCTest\scanresult.txt C:\HCTest\cleanresult.txt

:END
ping 127.0.0.1 -n 15 -w 1000
"c:\program files\7-zip\7z.exe" a c:\HCTest\HCTestResult.zip c:\HCTest\scanresult.txt
"c:\program files\7-zip\7z.exe" a c:\HCTest\HCTestResult.zip c:\HCTest\cleanresult.txt
"c:\program files\7-zip\7z.exe" a c:\HCTest\HCTestResult.zip c:\HCTest\report