$copilot_bin_folder = 'C:\MyPrograms\copilot'
$gpg_bin_folder="C:\Program Files (x86)\Gpg4win\bin"
if (-not (Test-Path -Path $copilot_bin_folder))
{
      New-Item -Path '$copilot_folder' -ItemType directory
      Invoke-WebRequest -OutFile '$copilot_folder\copilot.exe' https://github.com/aws/copilot-cli/releases/latest/download/copilot-windows.exe
      Invoke-WebRequest -OutFile '$copilot_folder\copilot.asc' https://github.com/aws/copilot-cli/releases/latest/download/copilot-windows.exe.asc
}

$current_system_path=[Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)
if(-not $current_system_path -like '*' + $gpg_bin_folder +'*') {
      $Env:PATH += $gpg_bin_folder
      [Environment]::SetEnvironmentVariable("Path", $current_system_path+ ";"+ $gpg_bin_folder, "Machine")
}
if(-not $current_system_path -like '*' + $copilot_bin_folder+'*') {
      $Env:PATH += $copilot_bin_folder
      [Environment]::SetEnvironmentVariable("Path", $current_system_path+ ";"+ $copilot_bin_folder, "Machine")
}

# gpg --import aws_ecs_public_key.txt
