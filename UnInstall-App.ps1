function UnInstall-App {
    param($SoftwareDisplayName ## return the full name if the software is installed
    ) 

    $app = Get-WmiObject -Class Win32_Product `
                        -Filter "Name = '$SoftwareDisplayName'"
    if($app -ne $null){ 
        Write-Output $app
        $exitcode = ($app.Uninstall()).ReturnValue   
        #Write-Output $exitcode

            if($exitcode -ne 0 ) {
                return "##vso[task.LogIssue type=warning;]$SoftwareDisplayName did NOT un-install correctly on $env:computername, please check, return code = $exitcode" 
            } else { 
                return "$SoftwareDisplayName is un-installed on $env:computername" 
                }    
    }ELSE{
    return "$SoftwareDisplayName was not installed on $env:computername, no action taken" 
    }     
}
