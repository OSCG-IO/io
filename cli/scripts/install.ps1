$VER = "6.71"
$REPO = "https://oscg-io-download.s3.amazonaws.com/REPO"


function downloadFile ([string]$pURL, [string]$pFile) {

  $wc = New-Object System.Net.WebClient
  try {

    $wc.DownloadFile($pURL, $pFile)
  } catch [System.Net.WebException] {
    if ($_.Exception.InnerException.Message) {
      write-host($($_.Exception.InnerException.Message))
    } else {
      write-host($($_.Exception.Message))
    }
    exit 1
  }

}


function unzipFile ([string]$pFile) {
  $shell = New-Object -ComObject shell.application
  try {
    $zip = $shell.NameSpace($pFile)
    foreach ($item in $zip.items()) {
      ## overlay each file with prompting
      $shell.NameSpace($cwd).CopyHere($item, 0x14)
    }
  } catch {
    write-host($($_.Exception.Message))
    write-host("FATAL ERROR: unzipping")
    exit 1
  }
}


######################################################################
######                        MAINLINE                          ######
######################################################################

$cwd = (Get-Item -Path ".\" -Verbose).FullName
$bigsql_dir = ($($cwd) + "\bigsql")
$is_bigsql_exists = (Test-Path ($bigsql_dir))
if ($is_bigsql_exists){
  write-host("ERROR: Cannot install over an existing 'bigsql' directory.")
  exit 1
}

$envVER = $env:VER
if ($envVER) {
  write-host("Using IO_VER Environment variable: " + $($envVER))
  $IO_VER = $envVER
}

$ioFile = ("oscg-io-" + $($IO_VER) + ".zip")

$url = ($($IO_REPO) + "/" + $($ioFile))


write-host $("`r`n" + "Downloading OSCG IO " + $($IO_VER) + " ...")
downloadFile $url $ioFile

write-host $("`r`n" + "Unpacking ...")
$qualifiedFile = $($cwd) + "\" + $ioFile
unzipFile $qualifiedFile
Remove-Item $qualifiedFile


$io_cmd = "oscg\io"

write-host("`r`n" + "Setting REPO to " + $($IO_REPO))
$repoCmd = $($io_cmd) + " set GLOBAL REPO " + $($IO_REPO)
Invoke-Expression -Command:$repoCmd

write-host("`r`n" + "Updating Metadata")
$updateCmd = $($io_cmd) + " update --silent"
Invoke-Expression -Command:$updateCmd

$rc = $LastExitCode
if (-not $rc) {
  write-host $("`r`n" + "OSCG IO installed.")
  write-host $("  Try '" + $($io_cmd) + " help' to get started." + "`r`n")
}

exit $rc

