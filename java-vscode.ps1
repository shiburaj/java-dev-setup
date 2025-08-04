#----------------------------
# 0. Install Chocolatey
#----------------------------
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Update Chocolatey
choco upgrade chocolatey -y

#----------------------------
# 1. Install Tools
#----------------------------
choco install microsoft-openjdk-21 -y
choco install vscode -y

#----------------------------
# 2. Set Environment Variables
#----------------------------
$jdkPath = (Get-ChildItem "C:\Program Files\Microsoft\jdk-21*" | Select-Object -First 1).FullName

# JAVA_HOME
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "Machine")

# Update PATH
$envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$jdkPath\bin*") {
    $envPath += ";$jdkPath\bin"
}


#----------------------------
# 3. VS Code Extensions
#----------------------------
# Wait a bit to ensure VS Code is fully installed
Start-Sleep -Seconds 10

# Core Java & Spring Extensions
code --install-extension vscjava.vscode-java-pack

#----------------------------
# 4. Completion Message
#----------------------------
Write-Host "`n✅ Development environment setup completed successfully!"
Write-Host "`n✅ JDK-21 and VS Code have been installed. with the Java extensions."
Write-Host "👉 Please restart your terminal or system to apply environment variables."
