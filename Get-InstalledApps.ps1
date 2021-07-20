function Get-InstalledApps {
    param($Software ##the display name of the software in apps & features
    , [Switch]$AzDO ##determines if the output variables for AzDO need to be set
    ) 
     
           if ([IntPtr]::Size -eq 4) {
                $regpath = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
            }
            else {
                $regpath = @(
                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
                    'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
                )
            }
     
    $result1 = Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} | Select DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString |Sort DisplayName
        
    if ($Software -eq $null) {
        return $result1
        } else   {
        $result2 = $result1 | where {$_.DisplayName -EQ $Software}
            #return $result2

            IF ($result2 -EQ $null) { 
                     if ($AzDO -eq $True) {
                    return "'$software' IS NOT installed ON $env:computername","##vso[task.setvariable variable=INSTALL_SOFTWARE_Y_N;isSecret=false;isOutput=true;]TRUE"

                    }  ELSE {return "'$software' IS NOT installed ON $env:computername"  }                
                            
            } else {
               
               return $result2, "'$software' IS installed ON $env:computername"}
                
            } 
    }



