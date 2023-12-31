$env:path += ";$home/documents/github/comp2101/powershell"
$env:path += ";$home/documents/github/comp2101/powershell"
$env:path += ";$home/documents/github/comp2101/powershell"
Set-Alias -Name np -Value notepad


# Lab 2 COMP2101 welcome script for profile
#

write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."

function get-cpuinfo {
    $processors = Get-CimInstance -ClassName Win32_Processor
    foreach ($processor in $processors) {
        "CPU Manufacturer: $($processor.Manufacturer)"
        "Model: $($processor.Name)"
        "Current Speed: $($processor.CurrentClockSpeed) MHz"
        "Maximum Speed: $($processor.MaxClockSpeed) MHz"
        "Number of Cores: $($processor.NumberOfCores)"
        ""
    }
}


get-cpuinfo





function get-mydisks {
    $disks = Get-CimInstance -ClassName Win32_DiskDrive
    $diskInfo = foreach ($disk in $disks) {
        [PSCustomObject]@{
            Manufacturer = $disk.Manufacturer
            Model = $disk.Model
            SerialNumber = $disk.SerialNumber
            FirmwareRevision = $disk.FirmwareRevision
            Size = [math]::Round($disk.Size / 1GB, 2)
        }
    }

    $diskInfo | Format-Table Manufacturer, Model, SerialNumber, FirmwareRevision, Size -AutoSize
}

get-mydisks



