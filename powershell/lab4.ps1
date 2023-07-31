function Get-SystemInformation {
    # Function to format memory size in human-friendly format
    function Format-MemorySize {
        param([int64]$Size)
        $units = "GB", "MB", "KB", "Bytes"
        $index = 0
        while ($Size -ge 1024 -and $index -lt $units.Length) {
            $Size /= 1024
            $index++
        }
        "{0:N2} {1}" -f $Size, $units[$index]
    }

    # Get system hardware description
    $hardware = Get-CimInstance Win32_ComputerSystem
    $os = Get-CimInstance Win32_OperatingSystem
    $processor = Get-CimInstance Win32_Processor
    $memory = Get-CimInstance Win32_PhysicalMemory
    $diskDrives = Get-CimInstance Win32_DiskDrive

    # Processor information
    Write-Host "Processor Information:"
    Write-Output "Description: $($processor[0].Description)"
    Write-Output "Speed (MHz): $($processor[0].MaxClockSpeed)"
    Write-Output "Number of Cores: $($processor[0].NumberOfCores)"
    Write-Output "L1 Cache Size: $(Format-MemorySize $processor[0].L1CacheSize)"
    Write-Output "L2 Cache Size: $(Format-MemorySize $processor[0].L2CacheSize)"
    Write-Output "L3 Cache Size: $(Format-MemorySize $processor[0].L3CacheSize)"

    # System hardware description
    Write-Host "System Hardware Description:"
    Write-Output "Manufacturer: $($hardware.Manufacturer)"
    Write-Output "Model: $($hardware.Model)"
    Write-Output "Total Physical Memory: $(Format-MemorySize $hardware.TotalPhysicalMemory)"

    # Operating system information
    Write-Host "Operating System Information:"
    Write-Output "Name: $($os.Caption)"
    Write-Output "Version: $($os.Version)"

    # Memory information
    Write-Host "Memory Information:"
    $memoryReport = $memory | ForEach-Object {
        [PSCustomObject]@{
            Vendor = $_.Manufacturer
            Description = $_.Caption
            Size = Format-MemorySize $_.Capacity
            Bank = $_.BankLabel
            Slot = $_.DeviceLocator
        }
    }
    $memoryReport | Format-Table -AutoSize

    # Disk drive information
    Write-Host "Disk Drive Information:"
    $diskReport = foreach ($disk in $diskDrives) {
        $partitions = $disk | Get-CimAssociatedInstance -ResultClassName CIM_DiskPartition
        foreach ($partition in $partitions) {
            $logicalDisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_LogicalDisk
            foreach ($logicalDisk in $logicalDisks) {
                [PSCustomObject]@{
                    Vendor = $disk.Manufacturer
                    Model = $disk.Model
                    "Drive Letter" = $logicalDisk.DeviceID
                    "Size(GB)" = [math]::Round($logicalDisk.Size / 1GB, 2)
                    "Free Space(GB)" = [math]::Round($logicalDisk.FreeSpace / 1GB, 2)
                    "% Free" = [math]::Round(($logicalDisk.FreeSpace / $logicalDisk.Size) * 100, 2)
                }
            }
        }
    }
    $diskReport | Format-Table -AutoSize

    # Network adapter configuration report from Lab 3
    Write-Host "Network Adapter Configuration Report:"
    $networkAdapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $networkAdapters | ForEach-Object {
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
    } | Format-Table -AutoSize

    # Video card information
    Write-Host "Video Card Information:"
    $videoController = Get-CimInstance Win32_VideoController
    Write-Output "Vendor: $($videoController[0].AdapterCompatibility)"
    Write-Output "Description: $($videoController[0].Description)"
    Write-Output "Current Resolution: $($videoController[0].CurrentHorizontalResolution) x $($videoController[0].CurrentVerticalResolution)"
}

# Generate the system information report
Get-SystemInformation