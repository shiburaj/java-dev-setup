# Menu-Driven Installer Script with IDEs, Tomcat v10, SQLTools Extensions, and Suggested Tools Menu

function Install-ChocoIfNeeded {
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    choco upgrade chocolatey -y
}

function Set-EnvVars {
    $jdkPath = (Get-ChildItem "C:\Program Files\Microsoft\jdk-21*" | Select-Object -First 1).FullName
    $mavenPath = (Get-ChildItem "C:\ProgramData\chocolatey\lib\maven" | Select-Object -First 1).FullName + "\apache-maven-*"
    
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "Machine")
    $mavenResolvedPath = (Resolve-Path $mavenPath).Path
    [Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenResolvedPath, "Machine")

    $envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($envPath -notlike "*$jdkPath\bin*") { $envPath += ";$jdkPath\bin" }
    if ($envPath -notlike "*$mavenResolvedPath\bin*") { $envPath += ";$mavenResolvedPath\bin" }
    [Environment]::SetEnvironmentVariable("Path", $envPath, "Machine")
}

function Install-Extensions {
    # Java & Spring
    code --install-extension vscjava.vscode-java-pack
    code --install-extension redhat.vscode-community-server-connector
    code --install-extension pivotal.vscode-spring-boot
    code --install-extension vmware.vscode-spring-boot-dashboard
    code --install-extension vscjava.vscode-spring-initializr
    code --install-extension vscjava.vscode-spring-boot-tools

    # SQLTools
    code --install-extension mtxr.sqltools
    code --install-extension mtxr.sqltools-driver-mysql
    code --install-extension mtxr.sqltools-driver-sqlite
}

function Setup-Tomcat-Connector {
    $serverDir = "$env:USERPROFILE\.vscode\servers\apache-tomcat-10"
    if (-Not (Test-Path $serverDir)) {
        New-Item -ItemType Directory -Path $serverDir -Force | Out-Null
    }

    # Install Apache Tomcat v10
    choco install tomcat -y

    # VS Code Community Server Connector config
    $serverConfig = @{
        "type" = "tomcat";
        "name" = "Tomcat v10 Server";
        "home" = "C:\\Program Files\\Apache Software Foundation\\Tomcat 10.0";
        "java_home" = (Get-ChildItem "C:\Program Files\Microsoft\jdk-21*" | Select-Object -First 1).FullName;
    }

    $jsonPath = "$serverDir\server.json"
    $serverConfig | ConvertTo-Json | Out-File $jsonPath -Encoding UTF8

    Write-Host "✅ Tomcat v10 installed and Community Server Connector configured!"
    Write-Host "👉 Restart VS Code and check the 'Servers' view to start Tomcat."
}

function Show-Menu {
    Clear-Host
    Write-Host "========== Development Environment Setup =========="
    Write-Host "1. Install Chocolatey"
    Write-Host "2. Install Microsoft OpenJDK 21"
    Write-Host "3. Install Maven"
    Write-Host "4. Install VS Code"
    Write-Host "5. Install MySQL Server"
    Write-Host "6. Install HeidiSQL"
    Write-Host "7. Install DBeaver Community"
    Write-Host "8. Install Eclipse IDE for Enterprise Java and Web Developers"
    Write-Host "9. Install IntelliJ IDEA Community Edition"
    Write-Host "10. Install Apache Tomcat v10 and Configure Server Connector"
    Write-Host "11. Set Environment Variables"
    Write-Host "12. Install VS Code Extensions (Java, Spring, SQLTools)"
    Write-Host "13. Install Shiburaj Sir's Suggested Tools (1,2,3,4,5,6,10,11,12)"
    Write-Host "14. Install ALL"
    Write-Host "0. Exit"
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice (comma-separated for multiple)"
    $choices = $choice -split ","

    foreach ($c in $choices) {
        switch ($c.Trim()) {
            "1"  { Install-ChocoIfNeeded }
            "2"  { choco install microsoft-openjdk-21 -y }
            "3"  { choco install maven -y }
            "4"  { choco install vscode -y }
            "5"  { choco install mysql -y }
            "6"  { choco install heidisql -y }
            "7"  { choco install dbeaver -y }
            "8"  { choco install eclipse --params "'/Product:jee'" -y }
            "9"  { choco install intellijidea-community -y }
            "10" { Setup-Tomcat-Connector }
            "11" { Set-EnvVars }
            "12" { Install-Extensions }
            "13" {
                Install-ChocoIfNeeded
                choco install microsoft-openjdk-21 -y
                choco install maven -y
                choco install vscode -y
                choco install mysql -y
                choco install heidisql -y
                Setup-Tomcat-Connector
                Set-EnvVars
                Install-Extensions
            }
            "14" {
                Install-ChocoIfNeeded
                choco install microsoft-openjdk-21 -y
                choco install maven -y
                choco install vscode -y
                choco install mysql -y
                choco install heidisql -y
                choco install dbeaver -y
                choco install eclipse --params "'/Product:jee'" -y
                choco install intellijidea-community -y
                Setup-Tomcat-Connector
                Set-EnvVars
                Install-Extensions
            }
            "0"  { exit }
            default { Write-Host "❌ Invalid choice: $c" }
        }
    }
    Pause
} while ($true)
