# Adapted from: https://superuser.com/questions/1533291/how-do-i-change-the-dns-settings-for-wsl2
# Filename: dns.ps1
# 
# Get the DNS server of the Windows machine, save into variable nameserver
$ubuntu_path = "$env:LOCALAPPDATA\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState\rootfs"
$nameserver = Get-WmiObject -Namespace root\cimv2 -Query "Select dnsserversearchorder from win32_networkadapterconfiguration" | where {$_.DNSServerSEarchOrder -ne $null} | select -ExpandProperty DNSServerSearchOrder

# Convert nameserver object into a string
$nameserver = Out-String -InputObject $nameserver

$temp_resolv_file = 'c:\Users\Public\Documents\resolv.conf'

# Run Set-Contents (sc) to write the resolv.conf file in a public location as it has DOS formatted line endings written by PowerShell, not readable by Linux
sc -Path $temp_resolv_file -Value ('nameserver ' + $nameserver) -Encoding utf8

$resolv_file_name = $ubuntu_path + '\etc\resolv.conf'

Write-Output $nameserver

# Convert the DOS formatted file into UNIX format for WSL2 and write it in the proper place (\etc\resolv.conf, its primary location is \\wsl$\[distro_name] from Windows)
[string]::Join( "`n", (gc $temp_resolv_file)) | sc "$resolv_file_name"

Write-Output 'resolv.conf succesfully created at: ' $resolv_file_name

Remove-Item $temp_resolv_file

Write-Output 'Temporary resolv file: ' $temp_resolv_file ' deleted.'