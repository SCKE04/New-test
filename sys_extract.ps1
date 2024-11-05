# Directory where .exe driver files are located
$driverFolder = "C:\Users\user\Downloads\exe"
# Directory where extracted .sys files will be saved
$outputFolder = "C:\Users\user\Downloads\sys"

# Ensure output folder exists
if (!(Test-Path -Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder
}

# Path to 7-Zip executable
$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"

# Loop through each .exe file in the driver folder
Get-ChildItem -Path $driverFolder -Filter *.exe | ForEach-Object {
    $driverFile = $_.FullName
    Write-Output "Processing $driverFile..."

    # Create a temporary extraction folder for each .exe file
    $tempExtractFolder = Join-Path -Path $driverFolder -ChildPath "TempExtract"
    if (!(Test-Path -Path $tempExtractFolder)) {
        New-Item -ItemType Directory -Path $tempExtractFolder
    }

    # Run 7-Zip to extract the driver file
    Start-Process -FilePath $sevenZipPath -ArgumentList "x", "`"$driverFile`"", "-o`"$tempExtractFolder`"" -Wait

    # Look for .sys files in the extracted contents
    $sysFiles = Get-ChildItem -Path $tempExtractFolder -Filter *.sys -Recurse

    # Move each .sys file to the output folder
    foreach ($sysFile in $sysFiles) {
        $destinationPath = Join-Path -Path $outputFolder -ChildPath $sysFile.Name
        Move-Item -Path $sysFile.FullName -Destination $destinationPath -Force
        Write-Output "Extracted and moved $($sysFile.Name) to $outputFolder"
    }

    # Clean up the temporary extraction folder
    Remove-Item -Path $tempExtractFolder -Recurse -Force
}

Write-Output "Driver extraction completed."
