<#
Java Development Environment Setup Script
Version: 2.0
Author: Shiburaj
#>

function Show-Menu {
    param (
        [string]$Title = 'Development Environment Setup'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    Write-Host "1. Install Chocolatey (Required)"
    Write-Host "2. Install Microsoft OpenJDK 21"
    Write-Host "3. Install Maven"
    Write-Host "4. Install VS Code"
    Write-Host "5. Install MySQL Server & MySQL Workbench"
    Write-Host "6. Install HeidiSQL"
    Write-Host "7. Install DBeaver Community"
    Write-Host "8. Install Eclipse IDE for Enterprise Java"
    Write-Host "9. Install IntelliJ IDEA Community Edition"
    Write-Host "10. Install Apache Tomcat v10 + Configure"
    Write-Host "11. Set Environment Variables"
    Write-Host "13. Install Shiburaj's Recommended Tools (Chocolatey, OpenJDK 21, Maven, VS Code, MySQL and MySQL Workbench, Tomcat and Set-EnvVariables)"
    Write-Host "14. Install ALL Components"
    Write-Host "Q. Quit"
    Write-Host "========================================"
}

function Install-Chocolatey {
    Write-Host "`n[1/14] Installing Chocolatey package manager..."
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    choco upgrade chocolatey -y
    Write-Host "✅ Chocolatey installed and updated successfully!" -ForegroundColor Green
}

function Install-Java {
    Write-Host "`n[2/14] Installing Microsoft OpenJDK 21..."
    choco install microsoft-openjdk-21 -y
    Write-Host "✅ Java installed successfully!" -ForegroundColor Green
}

function Install-Maven {
    Write-Host "`n[3/14] Installing Maven..."
    choco install maven -y
    Write-Host "✅ Maven installed successfully!" -ForegroundColor Green
}

function Install-VSCode {
    Write-Host "`n[4/14] Installing VS Code..."
    choco install vscode -y
    Write-Host "✅ VS Code installed successfully!" -ForegroundColor Green

    # sleep for 10 secs
    Start-Sleep -Seconds 10

    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + 
                [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    # Install extensions
    $vscodePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin"
    if (-not ($env:Path -like "*$vscodePath*")) {
        $env:Path += ";$vscodePath"
    }
    
    if (Get-Command code -ErrorAction SilentlyContinue) {
        # Proceed with extension installation if 'code' is available
        $extensions = @(
            "vscjava.vscode-java-pack",
            "redhat.vscode-community-server-connector",
            "pivotal.vscode-spring-boot",
            "vmware.vscode-spring-boot-dashboard",
            "vscjava.vscode-spring-initializr",
            "vscjava.vscode-spring-boot-tools",
            "mtxr.sqltools",
            "mtxr.sqltools-driver-mysql"
        )

        foreach ($extension in $extensions) {
            code --install-extension $extension
            Start-Sleep -Seconds 2
        }
    } else {
        Write-Host "⚠️ Could not find 'code' command. Please restart and try again." -ForegroundColor Yellow
    } 
    
    Write-Host "✅ VS Code extensions installed!" -ForegroundColor Green
}

function Install-MySQL {
    Write-Host "`n[5/14] Installing MySQL Server..."
    choco install mysql -y
    Write-Host "✅ MySQL Server installed successfully!" -ForegroundColor Green
    Write-Host "`n[5/14] Installing MySQL Workbench..."
    choco install mysql-workbench -y
    Write-Host "✅ MySQL Workbench installed successfully!" -ForegroundColor Green
}

function Install-HeidiSQL {
    Write-Host "`n[6/14] Installing HeidiSQL..."
    choco install heidisql -y
    Write-Host "✅ HeidiSQL installed successfully!" -ForegroundColor Green
}

function Install-DBeaver {
    Write-Host "`n[7/14] Installing DBeaver Community..."
    choco install dbeaver-community -y
    Write-Host "✅ DBeaver Community installed successfully!" -ForegroundColor Green
}

function Install-Eclipse {
    Write-Host "`n[8/14] Installing Eclipse IDE for Enterprise Java..."
    choco install eclipse-jee -y
    Write-Host "✅ Eclipse IDE installed successfully!" -ForegroundColor Green
}

function Install-IntelliJ {
    Write-Host "`n[9/14] Installing IntelliJ IDEA Community Edition..."
    choco install intellijidea-community -y
    Write-Host "✅ IntelliJ IDEA installed successfully!" -ForegroundColor Green
}

function Install-Tomcat {
    Write-Host "`n[10/14] Installing Apache Tomcat v10..."
    choco install tomcat -y
    
    $tomcatPath = (Get-ChildItem "C:\Program Files\Apache Software Foundation\tomcat-*" | 
                  Sort-Object LastWriteTime -Descending | 
                  Select-Object -First 1).FullName
    
    if (-not $tomcatPath) {
        Write-Host "⚠️ Tomcat installation path not found" -ForegroundColor Yellow
        return
    }
    
    
    
    # Configure server connector
    $serverConfig = @{
        name       = "Tomcat 10"
        host       = "localhost"
        port       = 8080
        serverType = "tomcat"
        path       = $tomcatPath
        deployPath = "$tomcatPath\webapps"
        user       = "admin"
        password   = "admin"
    }
    
    $settingsPath = "$env:APPDATA\Code\User\settings.json"
    $settings = if (Test-Path $settingsPath) {
        Get-Content $settingsPath | ConvertFrom-Json -AsHashtable
    } else {
        @{}
    }
    
    if (-not $settings.ContainsKey('communityServerConnector.servers')) {
        $settings['communityServerConnector.servers'] = @()
    }
    
    $settings['communityServerConnector.servers'] += $serverConfig
    $settings | ConvertTo-Json -Depth 10 | Out-File $settingsPath -Force
    
    Write-Host "✅ Tomcat installed and configured successfully!" -ForegroundColor Green
}

function Set-EnvVariables {
    Write-Host "`n[11/14] Setting environment variables..."
    
    # Set JAVA_HOME
    $jdkPath = (Get-ChildItem "C:\Program Files\Microsoft\jdk-21*" | Select-Object -First 1).FullName
    if ($jdkPath) {
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "Machine")
        Write-Host "✅ JAVA_HOME set to: $jdkPath" -ForegroundColor Green
    }
    
    # Set MAVEN_HOME
    $mavenPath = (Get-ChildItem "C:\ProgramData\chocolatey\lib\maven" | 
                 Select-Object -First 1).FullName + "\apache-maven-*"
    if ($mavenPath) {
        $mavenResolvedPath = (Resolve-Path $mavenPath).Path
        [Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenResolvedPath, "Machine")
        Write-Host "✅ MAVEN_HOME set to: $mavenResolvedPath" -ForegroundColor Green
    }
    
    # Update PATH
    $envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($jdkPath -and $envPath -notlike "*$jdkPath\bin*") {
        $envPath += ";$jdkPath\bin"
    }
    if ($mavenPath -and $envPath -notlike "*$mavenResolvedPath\bin*") {
        $envPath += ";$mavenResolvedPath\bin"
    }
    [Environment]::SetEnvironmentVariable("Path", $envPath, "Machine")
    
    Write-Host "✅ Environment variables configured" -ForegroundColor Green
}

function Install-Recommended {
    Write-Host "`n[13/14] Installing recommended tools..."
    Install-Chocolatey
    Install-Java
    Install-Maven
    Install-VSCode
    Install-MySQL
    Install-Tomcat
    Set-EnvVariables
    Write-Host "✅ Shiburaj's Recommended tools installed successfully!" -ForegroundColor Green
}

function Install-All {
    Write-Host "`n[14/14] Installing ALL components..."
    Install-Chocolatey
    Install-Java
    Install-Maven
    Install-VSCode
    Install-MySQL
    Install-HeidiSQL
    Install-DBeaver
    Install-Eclipse
    Install-IntelliJ
    Install-Tomcat
    Set-EnvVariables
    Write-Host "✅ ALL components installed successfully!" -ForegroundColor Green
}

# Main program
do {
    Show-Menu
    $selection = Read-Host "`nPlease make a selection (1-14 or Q to quit)"
    
    switch ($selection) {
        '1' { Install-Chocolatey }
        '2' { Install-Java }
        '3' { Install-Maven }
        '4' { Install-VSCode }
        '5' { Install-MySQL }
        '6' { Install-HeidiSQL }
        '7' { Install-DBeaver }
        '8' { Install-Eclipse }
        '9' { Install-IntelliJ }
        '10' { Install-Tomcat }
        '11' { Set-EnvVariables }
        '13' { Install-Recommended }
        '14' { Install-All }
        'Q' { 
            Write-Host "`n✅ Setup completed! Please restart your system." -ForegroundColor Green
            exit 
        }
        default { 
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
        }
    }
    
    if ($selection -ne 'Q') {
        pause
    }
}
until ($selection -eq 'Q')
