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
choco install maven -y
choco install vscode -y
choco install mysql -y

#----------------------------
# 2. Set Environment Variables
#----------------------------
$jdkPath = (Get-ChildItem "C:\Program Files\Microsoft\jdk-21*" | Select-Object -First 1).FullName
$mavenPath = (Get-ChildItem "C:\ProgramData\chocolatey\lib\maven" | Select-Object -First 1).FullName + "\apache-maven-*"

# JAVA_HOME
[Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "Machine")
# MAVEN_HOME
$mavenResolvedPath = (Resolve-Path $mavenPath).Path
[Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenResolvedPath, "Machine")

# Update PATH
$envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if ($envPath -notlike "*$jdkPath\bin*") {
    $envPath += ";$jdkPath\bin"
}
if ($envPath -notlike "*$mavenResolvedPath\bin*") {
    $envPath += ";$mavenResolvedPath\bin"
}
[Environment]::SetEnvironmentVariable("Path", $envPath, "Machine")

#----------------------------
# 3. VS Code Extensions
#----------------------------
# Wait a bit to ensure VS Code is fully installed
Start-Sleep -Seconds 10

# Core Java & Spring Extensions
code --install-extension vscjava.vscode-java-pack
code --install-extension redhat.vscode-community-server-connector
code --install-extension pivotal.vscode-spring-boot
code --install-extension vmware.vscode-spring-boot-dashboard
code --install-extension vscjava.vscode-spring-initializr
code --install-extension vscjava.vscode-spring-boot-tools
code --install-extension mtxr.sqltools
code --install-extension mtxr.sqltools-driver-mysql
code --install-extension mtxr.sqltools-driver-sqlite
#----------------------------
# 4. Completion Message
#----------------------------
Write-Host "`n✅ Development environment setup completed successfully!"
Write-Host "`n✅ Java 21, Maven, MySQL, and SQLTools have been installed. Java extensions also installed."
Write-Host "👉 Please restart your terminal or system to apply environment variables."
