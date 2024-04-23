# Funktion zum Auslesen von Ereignissen aus der Ereignisanzeige basierend auf Ereignis-IDs
function Get-NetworkInterfaceEvents {
    # Liste von Event-IDs, die auf Netzwerkschnittstellenstörungen hinweisen
    $eventIDs = @(27, 32, 1014, 10400)

    # Datum für die Suche (z.B. letzten Tag)
    $startDate = (Get-Date).AddDays(-1)

    # Ereignisprotokoll für Netzwerkschnittstellen
    $eventLog = Get-WinEvent -LogName System -ErrorAction SilentlyContinue |
                Where-Object {
                    $_.TimeCreated -gt $startDate -and
                    $eventIDs -contains $_.Id
                }

    return $eventLog
}

# Bestimmen des Desktop-Pfads des Benutzers
$desktopPath = [Environment]::GetFolderPath("Desktop")

# Dateipfad für die Ausgabedatei auf dem Desktop
$outputFileName = "NetworkInterfaceEvents.txt"
$outputFilePath = Join-Path -Path $desktopPath -ChildPath $outputFileName

# Ausgabe der gefundenen Ereignisse in eine Textdatei
$networkInterfaceEvents = Get-NetworkInterfaceEvents
if ($networkInterfaceEvents) {
    $output = @()
    $networkInterfaceEvents | ForEach-Object {
        $output += "Ereignis-ID: $($_.Id)"
        $output += "Nachricht: $($_.Message)"
        $output += "Zeitpunkt: $($_.TimeCreated)"
        $output += "----------------------------------------------------------------------------------"
    }
    $output | Out-File -FilePath $outputFilePath -Encoding UTF8
    Write-Host "Ereignisse wurden in die Datei $outputFilePath auf dem Desktop geschrieben."
} else {
    Write-Host "Keine Ereignisse für Netzwerkschnittstellenstörungen gefunden."
}
