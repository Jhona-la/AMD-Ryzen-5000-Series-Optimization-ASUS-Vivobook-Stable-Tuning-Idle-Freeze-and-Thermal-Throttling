<#
.SYNOPSIS
    Desbloquea menús ocultos de energía para procesadores AMD Ryzen en Windows.
    
.DESCRIPTION
    Este script cambia el atributo de visibilidad (Attributes = 2) en el registro para:
    1. Modo de impulso de rendimiento (Boost)
    2. Deshabilitar inactividad del procesador (Idle Disable / Fix Freeze)
    3. Estado mínimo/máximo del procesador
#>

# 1. Verificar privilegios de Administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Debes ejecutar este script como ADMINISTRADOR." -ForegroundColor Red
    Pause
    exit
}

$basePath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00"

# Definición de las sub-llaves (GUIDs)
$keys = @{
    "Modo de Impulso (Boost)"     = "be337238-0d82-4146-a960-4f3749d470c7"
    "Inactividad (Idle Disable)"  = "5d76a2ca-e8c0-402f-a133-2158492d58ad"
    "Estados Mín/Máx"             = "893df05d-c4c1-471f-bc54-a0f633516508"
}

Write-Host "--- Iniciando Desbloqueo de Opciones de Energía Ryzen ---" -ForegroundColor Cyan

foreach ($name in $keys.Keys) {
    $guid = $keys[$name]
    $fullPath = "$basePath\$guid"
    
    try {
        if (Test-Path $fullPath) {
            Set-ItemProperty -Path $fullPath -Name "Attributes" -Value 2
            Write-Host "[OK] $name desbloqueado correctamente." -ForegroundColor Green
        } else {
            Write-Host "[ERROR] No se encontró la ruta para $name." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[ERROR] Falló el cambio en $name : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nConfiguración completada. Ahora puedes ver estas opciones en:" -ForegroundColor Cyan
Write-Host "Panel de Control > Opciones de Energía > Cambiar configuración del plan > Cambiar configuración avanzada de energía." -ForegroundColor White

Write-Host "`nRECUERDA:" -ForegroundColor Yellow
Write-Host "1. Poner el Estado Mínimo en 20%."
Write-Host "2. Poner el Estado Máximo en 99%."
Write-Host "3. Poner 'Deshabilitar inactividad del procesador' en DESHABILITAR INACTIVIDAD."

Write-Host "`nPresiona cualquier tecla para salir..."
$null = [System.Console]::ReadKey()