if (-not $env:ORIGINAL_PATH) {
    $env:ORIGINAL_PATH = $env:PATH
}

$env:DEVTOOLS_HOME = 'D:\development\devtools'

$env:JDK16 = "$env:DEVTOOLS_HOME\java\jdk-16.0.1"
$env:JDK21 = "$env:DEVTOOLS_HOME\java\jdk-21.0.7"
$env:JDK23 = "$env:DEVTOOLS_HOME\java\jdk-23.0.2"
$env:JDK24 = "$env:DEVTOOLS_HOME\java\jdk-24.0.1"

function Set-JavaPath {
    $env:PATH = "$env:JAVA_HOME\bin;$env:ORIGINAL_PATH"
}

function jdk16 {
    $env:JAVA_HOME = $env:JDK16
    Set-JavaPath
    Write-Host "Switched to JDK 16"
}

function jdk21 {
    $env:JAVA_HOME = $env:JDK21
    Set-JavaPath
    Write-Host "Switched to JDK 21"
}

function jdk23 {
    $env:JAVA_HOME = $env:JDK23
    Set-JavaPath
    Write-Host "Switched to JDK 23"
}

function jdk24 {
    $env:JAVA_HOME = $env:JDK24
    Set-JavaPath
    Write-Host "Switched to JDK 24"
}

function restorePath {
    $env:PATH = $env:ORIGINAL_PATH
    Write-Host "PATH restored to original."
}