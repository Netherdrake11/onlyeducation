@echo off
setlocal enabledelayedexpansion

:: Указываем папку для резервной копии
set backup_folder=C:\Cookies_Backup
set zip_file=C:\Cookies_Backup.zip

:: Создаем папку для резервной копии, если её нет
if not exist "%backup_folder%" mkdir "%backup_folder%"

:: Определяем пути к файлам куки для разных браузеров
set "browsers=Chrome Edge Firefox Opera IE"

set "Chrome=%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cookies"
set "Edge=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cookies"
set "Firefox=%APPDATA%\Mozilla\Firefox\Profiles"
set "Opera=%APPDATA%\Opera Software\Opera Stable\Cookies"
set "IE=%APPDATA%\Microsoft\Windows\Cookies"

:: Создаем лог-файл
set log_file=%backup_folder%\cookies_list.txt
echo Список сохраненных куки-файлов: > "%log_file%"

:: Копируем файлы, если они существуют
for %%B in (%browsers%) do (
    set "path=!%%B!"
    if exist "!path!" (
        xcopy /Y /I "!path!" "%backup_folder%\%%B_Cookies"
        echo %%B - Файл сохранен: "!path!" >> "%log_file%"
    ) else (
        echo %%B - Файл не найден >> "%log_file%"
    )
)

:: Архивация папки с куками
echo Архивация папки...
powershell Compress-Archive -Path "%backup_folder%" -DestinationPath "%zip_file%" -Force

:: Удаление временной папки после архивации
rmdir /s /q "%backup_folder%"

echo Архивация завершена! Файл сохранен как %zip_file%.
pause
