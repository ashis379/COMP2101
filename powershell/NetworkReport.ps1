# Script to generate a report of network adapter IP configuration

# Get network adapter configuration objects
$adapters = Get-CimInstance -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }

# Define custom properties for the output
$customProperties = @{
    Name = 'Adapter Description'
    Expression = { $_.Description }
}

$customProperties += @{
    Name = 'Index'
    Expression = { $_.Index }
}

$customProperties += @{
    Name = 'IP Address(es)'
    Expression = { $_.IPAddress -join ', ' }
}

$customProperties += @{
    Name = 'Subnet Mask(s)'
    Expression = { $_.IPSubnet -join ', ' }
}

$customProperties += @{
    Name = 'DNS Domain Name'
    Expression = { $_.DNSDomain }
}

$customProperties += @{
    Name = 'DNS Server(s)'
    Expression = { $_.DNSServerSearchOrder -join ', ' }
}

# Create the report
$report = $adapters | Select-Object $customProperties

# Format the output as a table
$report | Format-Table -AutoSize

# Export the report to a CSV file
$report | Export-Csv -Path "NetworkAdapterReport.csv" -NoTypeInformation
