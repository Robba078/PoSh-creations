function Install-App {
    param($InstallExecutable ##the full path of the executable to be installed 
    , $CMDLineArguments ## the command line arguments like /q 
    , $SoftwareDisplayName ## return the full name if the software is installed
    , [Switch]$Java ##to facilitate setting the enviornment variables for the java installation used by FL
    ) 
     $exitcode = (Start-Process -FilePath $InstallExecutable -ArgumentList $CMDLineArguments -Wait -Passthru -Verbose).ExitCode
               
                if($exitcode -eq 3010) {
                    return "##vso[task.LogIssue type=warning;]$env:computername requires a reboot for the $SoftwareDisplayName installation finalize"
                     }
                elseif($exitcode -ne 0) {
                    return "##vso[task.LogIssue type=warning;]$SoftwareDisplayName did not install correctly on $env:computername, please check, return code = $exitcode " ,"##vso[task.complete result=SucceededWithIssues;]DONE"
                   } else { 
                        if ($Java -eq $True) {
                            $ENV_var_String = (get-ChildItem -directory 'C:\Program Files (x86)\Java'| Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) } | Select-Object -Last 1).FullName

                            setx JAVA_HOME "$ENV_var_String"
                            setx JVM_PATH "$ENV_var_String"
                            Write-output "Environment variables JAVA_HOME and JVM_PATH have been set as: $ENV_var_String" 

                            return "$SoftwareDisplayName is installed on $env:computername, and environment variables have been set" 
                             } else {
                        return "$SoftwareDisplayName is installed on $env:computername"  } 
                     }   
                }
