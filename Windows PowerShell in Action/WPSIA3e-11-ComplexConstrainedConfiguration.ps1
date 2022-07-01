New-PSSessionConfigurationFile `
-Path .\ComplexConstrainedConfiguration.pssc `
-Schema '1.0.0.0' `
-Author 'Richard' `
-Copyright '(c) PowerShell in Action Third Edition. All rights reserved.' `
-CompanyName 'PowerShell in Action' `
-Description 'Complex Constrained Configuration.' `
-ExecutionPolicy RemoteSigned `
-PowerShellVersion '5.0' `
-LanguageMode NoLanguage `
-SessionType RestrictedRemoteServer `
-FunctionDefinitions @{Name='Get-HealthModel';ScriptBlock={@{
            Date = Get-Date
            FreeSpace = (Get-PSDrive c).Free
            PageFaults = (Get-WmiObject Win32_PerfRawData_PerfOS_Memory).PageFaultsPersec
            TopCPU = Get-Process | Sort-Object -Descending CPU 
            TopWS = Get-Process | Sort-Object -Descending WS 
    }};Options='None'} `
-VisibleProviders 'FileSystem','Function','Variable'