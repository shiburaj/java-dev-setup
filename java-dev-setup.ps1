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
    Write-Host "2. Install All Development Tools"
    Write-Host "3. Install Java (Microsoft OpenJDK 21)"
    Write-Host "4. Install Maven"
    Write-Host "5. Install VS Code"
    Write-Host "6. Install MySQL"
    Write-Host "7. Install HeidiSQL"
    Write-Host "8. Set Environment Variables"
    Write-Host "9. Install VS Code Extensions"
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

function Install-AllTools {
    Write-Host "`nInstalling all development tools..."
    choco install microsoft-openjdk-21 -y
    choco install maven -y
    choco install vscode -y
    choco install mysql -y
    choco install heidisql -y
    Write-Host "✅ All tools installed successfully!"
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
    Write-Host "`nInstalling MySQL..."
    choco install mysql -y
    Write-Host "✅ MySQL installed successfully!"
}

function Install-HeidiSQL {
    Write-Host "`nInstalling HeidiSQL..."
    choco install heidisql -y
    Write-Host "✅ HeidiSQL installed successfully!"
}

function Set-EnvVariables {
    Write-Host "`nSetting environment variables..."
    
    $jdkPath = (Get-ChildItem "C:\Program Files\Microsoft\jdk-21*" | Select-Object -First 1).FullName
    $mavenPath = (Get-ChildItem "C:\ProgramData\chocolatey\lib\maven" | Select-Object -First 1).FullName + "\apache-maven-*"
    
    # JAVA_HOME
    if ($jdkPath) {
        [Environment]::SetEnvironmentVariable("JAVA_HOME", $jdkPath, "Machine")
        Write-Host "✅ JAVA_HOME set to $jdkPath"
    } else {
        Write-Host "⚠️ Java not found. Please install Java first."
    }
    
    # MAVEN_HOME
    if ($mavenPath) {
        $mavenResolvedPath = (Resolve-Path $mavenPath).Path
        [Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenResolvedPath, "Machine")
        Write-Host "✅ MAVEN_HOME set to $mavenResolvedPath"
    } else {
        Write-Host "⚠️ Maven not found. Please install Maven first."
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
    Write-Host "✅ PATH updated with Java and Maven binaries"
}

function Install-VSCodeExtensions {
    Write-Host "`nInstalling VS Code extensions..."
    
    # Wait a bit to ensure VS Code is fully installed
    Start-Sleep -Seconds 10
    
    # Core Java & Spring Extensions
    code --install-extension vscjava.vscode-java-pack
    code --install-extension redhat.vscode-community-server-connector
    code --install-extension pivotal.vscode-spring-boot
    code --install-extension vmware.vscode-spring-boot-dashboard
    code --install-extension vscjava.vscode-spring-initializr
    code --install-extension vscjava.vscode-spring-boot-tools
    
    Write-Host "✅ VS Code extensions installed successfully!"
}

# Main program
do {
    Show-Menu
    $selection = Read-Host "`nPlease make a selection"
    switch ($selection) {
        '1' { Install-Chocolatey }
        '2' { Install-AllTools }
        '3' { Install-Java }
        '4' { Install-Maven }
        '5' { Install-VSCode }
        '6' { Install-MySQL }
        '7' { Install-HeidiSQL }
        '8' { Set-EnvVariables }
        '9' { Install-VSCodeExtensions }
        'Q' { 
            Write-Host "`n✅ Development environment setup completed!" 
            Write-Host "👉 Please restart your terminal or system to apply environment variables."
            exit 
        }
        default { Write-Host "Invalid selection. Please try again." }
    }
    pause
}
until ($selection -eq 'Q')
