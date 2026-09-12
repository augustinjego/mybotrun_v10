@echo off
rem Lance MyBot depuis les sources corrigees (pas depuis MyBot.run.exe, qui est la
rem version compilee d'origine et ne contient aucun des correctifs BlueStacks 5.22).
rem Ajouter /autostart a la fin de la ligne start pour demarrer le run automatiquement.

cd /d "D:\VSCode\MyBot-MBR_v8.2.0"

start "" "C:\Program Files (x86)\AutoIt3\AutoIt3.exe" "D:\VSCode\MyBot-MBR_v8.2.0\MyBot.run.au3" MyVillage BlueStacks5 Pie64
