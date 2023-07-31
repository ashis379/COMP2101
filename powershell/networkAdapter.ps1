function Get-NetworkInfo {
    Write-Host "Network Adapter Configuration Report:"
    $networkAdapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

    $networkReport = $networkAdapters | ForEach-Object {
        $dnsServers = $_.DnsServerSearchOrder -join ', '
        [PSCustomObject]@{
            "Adapter Description" = $_.Description
            "Index" = $_.Index
            "IP Address(es)" = $_.IPAddress -join ', '
            "Subnet Mask(s)" = $_.IPSubnet -join ', '
            "Default Gateway(s)" = $_.DefaultIPGateway -join ', '
            "DNS Domain Name" = $_.DNSDomain
            "DNS Server(s)" = $dnsServers
        }
    }

    $networkReport | Format-Table -AutoSize
}

# Call the function to get the Network Adapter Configuration Report
Get-NetworkInfo