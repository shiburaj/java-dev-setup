# Guide to Manually Setup JAVA Dev Environment
Comming Soon

# Chocolatey Script to Automatically Setup Java Dev Environment

## Script 1. `java-vscode.ps1`
This script does the following:

1. Checks and installs Chocolatey
2. Install Java JDK
3. Install Visual Studio Code
4. Sets the JAVA_HOME environment variable
5. Sets Java PATH
6. Install following vscode extensions
    - Extension Pack for Java (vscjava.vscode-java-pack)

## Script 2. `java-vscode-maven-mysql-sqltools.ps1`
This script does the following:

1. Everything in `java-vscode.ps1` and
2. Install Maven
3. Install Mysql Server
4. Sets Maven PATH
5. Install following vscode extensions
    - Extension Pack for Java (vscjava.vscode-java-pack)
    - Community Server Connectors (redhat.vscode-community-server-connector)
    - Spring Boot Extension Pack (pivotal.vscode-spring-boot)
    - SQLTools + SQLTools Mysql Driver + SQLTools Sqlite Driver

## Script 3. `java-vscode-maven-mysql-heidisql.ps1`
This script does the following:

1. Everything in `java-vscode.ps1` and
2. Install Maven
3. Install Mysql Server
4. Install HeidiSQL
5. Sets Maven PATH
6. Install following vscode extensions
    - Extension Pack for Java (vscjava.vscode-java-pack)
    - Community Server Connectors (redhat.vscode-community-server-connector)
    - Spring Boot Extension Pack (pivotal.vscode-spring-boot)

## Script 4. `java-vscode-maven-mysql-dbeaver.ps1`
This script does the following:

1. Everything in `java-vscode.ps1` and
2. Install Maven
3. Install Mysql Server
4. Install DBeaver Community Edition
5. Sets Maven PATH
6. Install following vscode extensions
    - Extension Pack for Java (vscjava.vscode-java-pack)
    - Community Server Connectors (redhat.vscode-community-server-connector)
    - Spring Boot Extension Pack (pivotal.vscode-spring-boot)
    - SQLTools + SQLTools Mysql Driver + SQLTools Sqlite Driver

### How to Use this Scripts
1. Download the `<select-one-filename>.ps1` file from this repo to your computer. There are many different `.ps1` files select the file which suits you.
2. Run Powershell as Administrator
3. Go to the directory where you have downloaded the file from the Powershell.
4. Run following command to run the script
```
powershell -ExecutionPolicy Bypass -File java-dev-setup.ps1
```
