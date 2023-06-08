# Remove all three -dryRun cmd's from each function to run without 
function Backup-Files {
  param (
    [switch]$dryRun
  )

  try {
    # Prompt the user to enter the destination path
    Write-Host "Enter path like: C:\User\backuppath"
    $destination = Read-Host -Prompt "Enter the path (folder) where you want to store the backup files"

    # Validate the destination path
    if (!(Test-Path -Path $destination -PathType Container)) {
      throw "Invalid destination path. Please enter a valid path."
    }

    # Prompt the user to enter file paths to back up
    $filePaths = @()
    do {
      $filePath = Read-Host -Prompt "Enter the path to a file to backup (or enter 'done' to finish)"
      if ($filePath -ne "done") {
        # Validate the file path
        if (!(Test-Path -Path $filePath -PathType Leaf)) {
          throw "Invalid file path. Please enter a valid path."
        } else {
          $filePaths += $filePath
        }
      }
    } while ($filePath -ne "done")

    # Backup each file
    $successfulBackups = 0
    $totalFiles = 0
    foreach ($filePath in $filePaths) {
      $fileName = Split-Path -Path $filePath -Leaf
      $backupPath = Join-Path -Path $destination -ChildPath $fileName

      if ($dryRun) {
        $dryRunOutput = "Dry run: $($totalFiles+1) out of $($filePaths.Count) files would be backed up"
        Write-Host $dryRunOutput -ForegroundColor Yellow
      } else {
        try {
          Copy-Item -Path $filePath -Destination $backupPath -ErrorAction Stop
          $successfulBackups++
        } catch {
          throw "Error backing up file '$filePath': $_"
        }
      }
      $totalFiles++
    }

    # Notify the user of the backup results
    if ($dryRun) {
      Write-Host "Dry run complete: $($totalFiles) files would be backed up to '$destination'." -ForegroundColor Green
    } elseif ($successfulBackups -eq $filePaths.Count) {
      Write-Host "All files have been backed up to '$destination'." -ForegroundColor Green

      # Open the backup destination folder in File Explorer
      Invoke-Item -Path $destination
    } else {
      Write-Host "$successfulBackups out of $($filePaths.Count) files have been successfully backed up to '$destination'." -ForegroundColor Yellow
    }

    # Prompt the user to proceed
    $response = Read-Host "Press any key to continue. Press 'q' to quit."
    if ($response -eq "q") {
      exit
    }
  } catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    Read-Host "Press any key to exit."
    exit
  }
}
      Backup-Files -dryRun #remove -dryRun to run without
function SageDotComXConnectdll {
  param(
    [switch]$DryRun
  )

  try {
    # Prompt the user for a file to copy
    
    $filePath = Read-Host -Prompt "Enter the path to SageDotCom.XConnect.dll"

    # Validate the file path
    if (!(Test-Path -Path $filePath -PathType Leaf)) {
      throw "Invalid file path. Please enter a valid path."
    }

    # Define the destination directories
    $newDestinations = @()
    while ($true) {
      $newDestination = Read-Host -Prompt "Enter the destination directory to copy the file to (or enter 'done' to finish)"
      if ($newDestination -eq "done") {
        break
      }
      if (!(Test-Path -Path $newDestination -PathType Container)) {
        throw "Invalid destination path. Please enter a valid path."
      }
      $newDestinations += $newDestination
    }

    # Perform the copy operation in dry-run mode or regular mode
    $copyResults = foreach ($newDestination in $newDestinations) {
      # Copy the file to the destination directory
      $newFileName = Split-Path -Path $filePath -Leaf
      $newDestinationPath = Join-Path -Path $newDestination -ChildPath $newFileName

      if (Test-Path -Path $newDestinationPath) {
        # If the file already exists, prompt the user to overwrite it
        $response = Read-Host "File '$newFileName' already exists in '$newDestination'. Do you want to overwrite it? (y/n)"
        if ($response -ne "y") {
          continue
        }
      }

      if ($DryRun) {
        # In dry-run mode, output the file copy operation without actually copying the file
        [pscustomobject]@{
          Source = $filePath
          Destination = $newDestinationPath
          Result = 'Dry run: File would be copied to destination'
        }
      }
      else {
        # In regular mode, copy the file to the destination directory
        try {
          Copy-Item -Path $filePath -Destination $newDestinationPath -Force -ErrorAction Stop
          [pscustomobject]@{
            Source = $filePath
            Destination = $newDestinationPath
            Result = 'Success'
          }
        } catch {
          [pscustomobject]@{
            Source = $filePath
            Destination = $newDestinationPath
            Result = "Error copying file to destination '$newDestination': $_"
          }
        }
      }
    }

    # Output the copy results
    if ($DryRun) {
      Write-Host "Dry run: The following file copy operations would be performed:" -ForegroundColor Yellow
      $copyResults | Format-Table -AutoSize
    }
    else {
      Write-Host "The following file copy operations were performed:" -ForegroundColor Green
      $copyResults | Format-Table -AutoSize
    }

    # Prompt the user to proceed
    if (!$DryRun) {
      $newResponse = Read-Host "Press any key to continue. Press 'q' to quit."
      if ($newResponse -eq "q") {
        exit
      }
    }
  } catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    Read-Host "Press any key to exit."
    exit
  }
}
      SageDotComXConnectdll -dryRun #remove -dryRun to run without
function SageDotComCustomRulesxml {
  param(
    [switch]$DryRun
  )

  try {
    # Prompt the user for a file to copy
    $filePath = Read-Host -Prompt "Enter the path to SageDotCom.CustomRules.xml"

    # Validate the file path
    if (!(Test-Path -Path $filePath -PathType Leaf)) {
      throw "Invalid file path. Please enter a valid path."
    }

    # Define the destination directories
    $newDestinations = @()
    while ($true) {
      $newDestination = Read-Host -Prompt "Enter the destination directory to copy the file to (or enter 'done' to finish)"
      if ($newDestination -eq "done") {
        break
      }
      if (!(Test-Path -Path $newDestination -PathType Container)) {
        throw "Invalid destination path. Please enter a valid path."
      }
      $newDestinations += $newDestination
    }

    # Perform the copy operation in dry-run mode or regular mode
    $copyResults = foreach ($newDestination in $newDestinations) {
      # Copy the file to the destination directory
      $newFileName = Split-Path -Path $filePath -Leaf
      $newDestinationPath = Join-Path -Path $newDestination -ChildPath $newFileName

      if (Test-Path -Path $newDestinationPath) {
        # If the file already exists, prompt the user to overwrite it
        $response = Read-Host "File '$newFileName' already exists in '$newDestination'. Do you want to overwrite it? (y/n)"
        if ($response -ne "y") {
          continue
        }
      }

      if ($DryRun) {
        # In dry-run mode, output the file copy operation without actually copying the file
        [pscustomobject]@{
          Source = $filePath
          Destination = $newDestinationPath
          Result = 'Dry run: File would be copied to destination'
        }
      }
      else {
        # In regular mode, copy the file to the destination directory
        try {
          Copy-Item -Path $filePath -Destination $newDestinationPath -Force -ErrorAction Stop
          [pscustomobject]@{
            Source = $filePath
            Destination = $newDestinationPath
            Result = 'Success'
          }
        } catch {
          [pscustomobject]@{
            Source = $filePath
            Destination = $newDestinationPath
            Result = "Error copying file to destination '$newDestination': $_"
          }
        }
      }
    }

    # Output the copy results
    if ($DryRun) {
      Write-Host "Dry run: The following file copy operations would be performed:" -ForegroundColor Yellow
      $copyResults | Format-Table -AutoSize
    }
    else {
      Write-Host "The following file copy operations were performed:" -ForegroundColor Green
      $copyResults | Format-Table -AutoSize
    }

    # Prompt the user to proceed
    if (!$DryRun) {
      $newResponse = Read-Host "Press any key to continue. Press 'q' to quit."
      if ($newResponse -eq "q") {
        exit
      }
    }
  } catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    Read-Host "Press any key to exit."
    exit
  }
  Write-Host "Script finished"
}
    SageDotComCustomRulesxml -dryRun #remove -dryRun to run without