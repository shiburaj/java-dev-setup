#----------------------------
# Menu-Driven Development Environment Setup
#----------------------------

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
    Write-Host "5. Install MySQL Server"
    Write-Host "6. Install HeidiSQL"
    Write-Host "7. Install DBeaver Community"
    Write-Host "8. Install Eclipse IDE for Enterprise Java"
    Write-Host "9. Install IntelliJ IDEA Community Edition"
    Write-Host "10. Install Apache Tomcat v10 + Configure"
    Write-Host "11. Set Environment Variables"
    Write-Host "12. Install VS Code Extensions (Java, Spring, SQLTools)"
    Write-Host "13. Install Shiburaj Sir's Suggested Tools (1,2,3,4,5,6,10,11,12)"
    Write-Host "14. Install ALL"
    Write-Host "Q. Quit"
}

function Install-Chocolatey {
    Write-Host "`nInstalling Chocolatey..."
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    
    # Update Chocolatey
    choco upgrade chocolatey -y
    Write-Host "✅ Chocolatey installed and updated successfully!"
}

function Install-Java {
    Write-Host "`nInstalling Microsoft OpenJDK 21..."
    choco install microsoft-openjdk-21 -y
    Write-Host "✅ Java installed successfully!"
}

function Install-Maven {
    Write-Host "`nInstalling Maven..."
    choco install maven -y
    Write-Host "✅ Maven installed successfully!"
}

function Install-VSCode {
    Write-Host "`nInstalling VS Code..."
    choco install vscode -y
    Write-Host "✅ VS Code installed successfully!"
}

function Install-MySQL {
    Write-Host "`nInstalling MySQL Server..."
    choco install mysql -y
    Write-Host "✅ MySQL Server installed successfully!"
}

function Install-HeidiSQL {
    Write-Host "`nInstalling HeidiSQL..."
    choco install heidisql -y
    Write-Host "✅ HeidiSQL installed successfully!"
}

function Install-DBeaver {
    Write-Host "`nInstalling DBeaver Community..."
    choco install dbeaver-community -y
    Write-Host "✅ DBeaver Community installed successfully!"
}

function Install-Eclipse {
    Write-Host "`nInstalling Eclipse IDE for Enterprise Java..."
    choco install eclipse-jee -y
    Write-Host "✅ Eclipse IDE installed successfully!"
}

function Install-IntelliJ {
    Write-Host "`nInstalling IntelliJ IDEA Community Edition..."
    choco install intellijidea-community -y
    Write-Host "✅ IntelliJ IDEA installed successfully!"
}

function Install-Tomcat {
    Write-Host "`nInstalling Apache Tomcat v10 and Configuring VS Code Connector..."
    
    # 1. Install Tomcat
    choco install tomcat -version 10.0.27 -y
    
    # Find Tomcat installation path
    $tomcatPath = (Get-ChildItem "C:\Program Files\Apache Software Foundation\tomcat-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
    
    if (-not $tomcatPath) {
        Write-Host "⚠️ Tomcat installation path not found"
        return
    }
    
    Write-Host "✅ Tomcat installed at $tomcatPath"
    
    # 2. Install Community Server Connector extension
    Write-Host "Installing VS Code Community Server Connector extension..."
    code --install-extension redhat.vscode-community-server-connector
    Start-Sleep -Seconds 5  # Wait for extension to install
    
    # 3. Set Environment Variables
    [Environment]::SetEnvironmentVariable("CATALINA_HOME", $tomcatPath, "Machine")
    $envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($envPath -notlike "*$tomcatPath\bin*") {
        $envPath += ";$tomcatPath\bin"
        [Environment]::SetEnvironmentVariable("Path", $envPath, "Machine")
    }
    
    # 4. Configure VS Code Community Server Connector
    $vscodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
    $tomcatServerConfig = @{
        "name" = "Tomcat 10"
        "host" = "localhost"
        "port" = 8080
        "serverType" = "tomcat"
        "path" = $tomcatPath
        "deployPath" = "$tomcatPath\webapps"
        "user" = "admin"
        "password" = "admin"
    }
    
    # Create or update VS Code settings
    if (Test-Path $vscodeSettingsPath) {
        $settings = Get-Content $vscodeSettingsPath | ConvertFrom-Json -AsHashtable
    } else {
        $settings = @{}
    }
    
    if (-not $settings.ContainsKey('communityServerConnector.servers')) {
        $settings['communityServerConnector.servers'] = @()
    }
    
    $settings['communityServerConnector.servers'] += $tomcatServerConfig
    $settings | ConvertTo-Json -Depth 10 | Out-File $vscodeSettingsPath -Force
    
    # 5. Create default admin user if not exists
    $tomcatUsersPath = "$tomcatPath\conf\tomcat-users.xml"
    if (Test-Path $tomcatUsersPath) {
        $tomcatUsers = Get-Content $tomcatUsersPath
        if ($tomcatUsers -notmatch '<user username="admin" password="admin" roles="manager-gui,admin-gui"/>') {
            $tomcatUsers = $tomcatUsers -replace '</tomcat-users>', '  <user username="admin" password="admin" roles="manager-gui,admin-gui"/></tomcat-users>'
            $tomcatUsers | Out-File $tomcatUsersPath -Force
            Write-Host "✅ Created default admin user (admin/admin)"
        }
    }
    
    Write-Host "✅ Tomcat installation and VS Code configuration complete"
    Write-Host "ℹ️ You can now manage Tomcat from VS Code's Servers view (Ctrl+Shift+P > 'Show Servers')"
}

function Set-EnvVariables {
    Write-Host "`nSetting environment variables..."
    
    # Set JAVA_HOME
    $jdkPath = (Get-ChildItem "C:\Program Files\Microsoft\jdk-21*" | Select-Object -First 1).FullName
    if ($jdkPath) {
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "Machine")
        Write-Host "✅ JAVA_HOME set to $jdkPath"
    } else {
        Write-Host "⚠️ Java not found. Please install Java first."
    }
    
    # Set MAVEN_HOME
    $mavenPath = (Get-ChildItem "C:\ProgramData\chocolatey\lib\maven" | Select-Object -First 1).FullName + "\apache-maven-*"
    if ($mavenPath) {
        $mavenResolvedPath = (Resolve-Path $mavenPath).Path
        [Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenResolvedPath, "Machine")
        Write-Host "✅ MAVEN_HOME set to $mavenResolvedPath"
    } else {
        Write-Host "⚠️ Maven not found. Please install Maven first."
    }
    
    # Update PATH with Java and Maven
    $envPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($jdkPath -and $envPath -notlike "*$jdkPath\bin*") {
        $envPath += ";$jdkPath\bin"
    }
    if ($mavenPath -and $envPath -notlike "*$mavenResolvedPath\bin*") {
        $envPath += ";$mavenResolvedPath\bin"
    }
    [Environment]::SetEnvironmentVariable("Path", $envPath, "Machine")
    Write-Host "✅ PATH updated with Java and Maven binaries"
}

# Remove the Community Server Connector from the Install-VSCodeExtensions function
function Install-VSCodeExtensions {
    Write-Host "`nInstalling VS Code extensions..."
    
    # Wait a bit to ensure VS Code is fully installed
    Start-Sleep -Seconds 10
    
    # Java extensions
    code --install-extension vscjava.vscode-java-pack
    
    # Spring extensions
    code --install-extension pivotal.vscode-spring-boot
    code --install-extension vmware.vscode-spring-boot-dashboard
    code --install-extension vscjava.vscode-spring-initializr
    code --install-extension vscjava.vscode-spring-boot-tools
    
    # SQL Tools
    code --install-extension mtxr.sqltools
    code --install-extension mtxr.sqltools-driver-mysql
    
    Write-Host "✅ VS Code extensions installed successfully!"
}

function Install-ShiburajTools {
    Write-Host "`nInstalling Shiburaj Sir's Suggested Tools..."
    Install-Chocolatey
    Install-Java
    Install-Maven
    Install-VSCode
    Install-MySQL
    Install-HeidiSQL
    Install-Tomcat
    Set-EnvVariables
    Install-VSCodeExtensions
    Write-Host "✅ Shiburaj Sir's Suggested Tools installed successfully!"
}

function Install-All {
    Write-Host "`nInstalling ALL components..."
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
    Install-VSCodeExtensions
    Write-Host "✅ ALL components installed successfully!"
}

# Main program
do {
    Show-Menu
    $selection = Read-Host "`nPlease make a selection"
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
        '12' { Install-VSCodeExtensions }
        '13' { Install-ShiburajTools }
        '14' { Install-All }
        'Q' { 
            Write-Host "`n✅ Development environment setup completed!" 
            Write-Host "👉 Please restart your terminal or system to apply environment variables."
            exit 
        }
        default { 
            Write-Host "Invalid selection. Please try again." 
        }
    }
    pause
}
until ($selection -eq 'Q')
