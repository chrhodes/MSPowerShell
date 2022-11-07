$outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-06\us-west-2"
Set-Location $outputfolder

$files = @(get-item *.csv)

$file = $files[0]

$parts = @($file.Name -split "_")
$ec2Instance = $parts[0]
$ec2Instance

if (!(Test-Path -Path $ec2Instance)) { New-Item -Name $ec2Instance -ItemType Directory }

Move-Item $file $ec2Instance

# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-06\us-west-2"
$outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-06\us-east-2"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-06\eu-west-1"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-06\eu-central-1"

# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-07\us-west-2"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-07\us-east-2"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-07\eu-west-1"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-07\eu-central-1"

# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-06\us-west-2"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-06\us-east-2"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-06\eu-west-1"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-06\eu-central-1"

# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-07\us-west-2"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-07\us-east-2"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-07\eu-west-1"
# $outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-07\eu-central-1"

Set-Location $outputFolder

$files = @(get-item *.csv)

foreach ($file in $files)
{
    $parts = @($file.Name -split "_")
    $ec2Instance = $parts[0]
    $ec2Instance
    
    if (!(Test-Path -Path $ec2Instance))
    {
        New-Item -Name $ec2Instance -ItemType Directory
        Move-Item $file $ec2Instance
    }
    else
    {
        Move-Item $file $ec2Instance
    }
}

$outputFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Staging\EC2_Utilization\2022-07"

Set-Location $outputFolder

$reportFolder = "C:\Users\crhodes\My Drive\Budget & Costs\Reports\Staging\2022-07\EC2"

$unprocessedFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-06\eu-central-1"

$csvFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-10\eu-central-1"

Set-Location $csvFolder
$csvFolders = @(Get-Item *)
$csvFolders.Count

$processedFolder = "C:\Users\crhodes\My Drive\Budget & Costs\CSV Files\Production\EC2_Utilization\2022-10\Processed\eu-central-1"

Set-Location $processedFolder
$processedFolders = @(Get-Item *)
$processedFolders.Count

$processedCount = 0

foreach ($folder in $processedFolders)
{
    $i = 0
    $targetFolder = "$($csvFolder)\$($folder.Name)"

    # $targetFolder

    if ((Test-Path -Path $targetFolder))
    {
        $targetFolder + " has been processed, removing"
        Remove-Item $targetFolder -Recurse -Force
        $processedCount++     
    }
}

"$processedCount Files Removed"

foreach ($folder in $folders)
{
    $targetOutputFolder = "$($processedFolder)\$($folder.Name)"

    # $targetOutputFolder

    if ((Test-Path -Path $targetOutputFolder))
    {
        $folder.Name + " has been processed, removing"
        Remove-Item $folder -Recurse       
    }
    else
    {
        $folder.Name + " has not been processed"
    }
}

Set-Location $csvFolder
$region = "us-west-2"
$region = "eu-central-1"
Set-Location $region

    $folders = @(Get-Item *)
    $folder = $folders[0]

foreach ($folder in $folders)
{
    if($folder.Name -eq "Processed") {continue}

    $targetOutputFile = "$($reportFolder)\EC2_$($folder.Name)_$($region).xlsx"

    if ((Test-Path -Path $targetOutputFile))
    {
        Move-Item $folder "Processed" 
    }
}

    Set-Location $outputFolder

$regions = @(Get-Item *)

foreach ($region in $regions)
{
    Set-Location $region

    $folders = @(Get-Item *)

    foreach ($folder in $folders)
    {
        if($folder.Name -eq "Processed") {continue}


        Set-Location $folder
        $folder
        fixFilesInFolder $folder
    }

    Set-Location $outputFolder
}

function fixFilesInFolder([String]$folder)
{
    Set-Location $folder

    $files = @(Get-Item *.csv)

    foreach ($file in $files)
    {
        fixFile $file
    }
}

function fixFile($file)
{
    $fileNameParts = $file.Name -Split "_"
    $ec2Instance = $fileNameParts[0]
    $metricName = $fileNameParts[1]
    $region = $fileNameParts[2] -replace ".{4}$"

    $firstLine = (Get-Content $file -First 1)
    $firstLineDates = $firstLine -Split ","

    $startDate = $firstLineDates[1]
    $endDate = $firstLineDates[2]

    $file.Name + " pieces:"
    $ec2Instance
    $metricName
    $region
    $startDate
    $endDate

    $fileContent = (Get-Content $file | Select-Object -Skip 1)
    
    $newFile = "xxxTEMPxxx"
    
    "Region,$($region)" > $newFile
    "ec2Instance,$($ec2Instance)" >> $newFile
    "Metric,$($metricName)" >> $newFile
    "StartTime,,$($startDate)" >> $newFile
    "EndTime,,$($endDate)" >> $newFile
    $fileContent >> $newFile

    Move-Item $newFile $file -Force
}

