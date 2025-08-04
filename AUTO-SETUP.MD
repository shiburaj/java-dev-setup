# Chocolatey Script to Setup Java Dev Environment

## Script 1. `java-vscode-maven-spring.ps1`
This script does the following:

1. Checks and installs Chocolatey
2. Updates chocolatey
3. Install Java JDK
4. Install Maven
5. Install Visual Studio Code
6. Install Mysql Server
7. Install HeidiSQL 
8. Sets the JAVA_HOME environment variable
9. Sets Java PATH
10. Sets Maven PATH
11. Install following vscode extensions
    - Extension Pack for Java (vscjava.vscode-java-pack)
    - Community Server Connectors (redhat.vscode-community-server-connector)
    - Spring Boot Extension Pack (pivotal.vscode-spring-boot)

### How to Use this Script
1. Download the `java-vscode-maven-spring.ps1` file from this repo to your computer
2. Run Powershell as Administrator
3. Go to the directory where you have downloaded the file from the Powershell.
4. Run following command to run the script
```
powershell -ExecutionPolicy Bypass -File java-vscode-maven-spring.ps1
```