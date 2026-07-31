@echo off
cd /d "%~dp0"
title YT DOWNLOAD iBay KUY
color 0A

:: =========================================
:: PENGECEKAN FILE DEPENDENCY WAJIB
:: =========================================
if not exist "yt-dlp.exe" (
    echo.
    echo [ERROR] yt-dlp.exe tidak ditemukan!
    echo Pastikan yt-dlp.exe ada di folder yang sama dengan script ini.
    pause
    exit
)
if not exist "ffmpeg.exe" (
    echo.
    echo [ERROR] ffmpeg.exe tidak ditemukan!
    echo ffmpeg.exe WAJIB ada untuk convert audio ke MP3 dan gabung video 1080p+.
    pause
    exit
)
if not exist "deno.exe" (
    echo.
    echo [WARNING] deno.exe tidak ditemukan!
    echo Beberapa bypass YouTube mungkin tidak bekerja optimal tanpa deno.exe.
    echo Tekan tombol apa saja untuk tetap melanjutkan...
    pause ^>nul
)
:: =========================================

:MainMenu
cls
echo =========================================
echo       YT DOWNLOAD iBay KUY
echo =========================================
echo 1. Download Audio
echo 2. Download Video
echo 3. Download Playlist
echo 4. Update YT-DLP
echo 5. Keluar
echo =========================================
set /p main_choice="Pilih menu (1-5): "

if "%main_choice%"=="1" goto MenuAudio
if "%main_choice%"=="2" goto MenuVideo
if "%main_choice%"=="3" goto MenuPlaylist
if "%main_choice%"=="4" goto UpdateYTDLP
if "%main_choice%"=="5" exit
goto MainMenu

:: =========================================
:: FUNGSI CEK & BUAT FOLDER
:: =========================================
:CheckFolder
if not exist "%~1" (
    mkdir "%~1"
    echo [+] Folder "%~1" belum ada, membuat folder baru...
) else (
    echo [*] Folder "%~1" sudah ada.
)
echo.
exit /b
:: =========================================

:MenuAudio
cls
echo =========================================
echo             DOWNLOAD AUDIO
echo =========================================
echo 1. MP3
echo 2. Wav
echo 3. Kembali ke Menu Utama
echo =========================================
set /p audio_choice="Pilih format (1-3): "
if "%audio_choice%"=="3" goto MainMenu
set /p link="Masukkan Link atau ID YouTube (Ketik 0 untuk batal): "
if "%link%"=="0" goto MainMenu
if "%link%"=="" goto MenuAudio

call :CheckFolder "AUDIO"

if "%audio_choice%"=="1" (
    yt-dlp --js-runtimes "deno:.\deno.exe" --no-check-certificate -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata -o "AUDIO\%%(title)s.%%(ext)s" "%link%"
)
if "%audio_choice%"=="2" (
    yt-dlp --js-runtimes "deno:.\deno.exe" --no-check-certificate -x --audio-format wav --embed-thumbnail --embed-metadata -o "AUDIO\%%(title)s.%%(ext)s" "%link%"
)
echo.
pause
goto MainMenu

:MenuVideo
cls
echo =========================================
echo             DOWNLOAD VIDEO (MP4)
echo =========================================
echo 1. 480p
echo 2. 720p
echo 3. 1080p
echo 4. 4K
echo 5. Kembali ke Menu Utama
echo =========================================
set /p video_choice="Pilih resolusi (1-5): "
if "%video_choice%"=="5" goto MainMenu
set /p link="Masukkan Link atau ID YouTube (Ketik 0 untuk batal): "
if "%link%"=="0" goto MainMenu
if "%link%"=="" goto MenuVideo

if "%video_choice%"=="1" set res=480
if "%video_choice%"=="2" set res=720
if "%video_choice%"=="3" set res=1080
if "%video_choice%"=="4" set res=2160

call :CheckFolder "VIDEO"

:: Memprioritaskan codec AVC (H.264) yang didukung semua player
yt-dlp --js-runtimes "deno:.\deno.exe" --no-check-certificate -f "bv*[vcodec^=avc][ext=mp4][height<=%res%]+ba[ext=m4a]/bv*[ext=mp4][height<=%res%]+ba[ext=m4a]/b[ext=mp4][height<=%res%]" --merge-output-format mp4 --embed-thumbnail --embed-metadata -o "VIDEO\%%(title)s.%%(ext)s" "%link%"
echo.
pause
goto MainMenu

:MenuPlaylist
cls
echo =========================================
echo            DOWNLOAD PLAYLIST
echo =========================================
echo 1. Playlist Audio (MP3 192k)
echo 2. Playlist Video (MP4)
echo 3. Kembali ke Menu Utama
echo =========================================
set /p play_choice="Pilih tipe (1-3): "
if "%play_choice%"=="3" goto MainMenu

if "%play_choice%"=="1" (
    set /p link="Masukkan Link Playlist YouTube (Ketik 0 untuk batal): "
    if "%link%"=="0" goto MainMenu
    if "%link%"=="" goto MenuPlaylist
    call :CheckFolder "PLAYLIST"
    yt-dlp --js-runtimes "deno:.\deno.exe" --no-check-certificate -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata --yes-playlist -o "PLAYLIST\%%(playlist)s\%%(playlist_index)s - %%(title)s.%%(ext)s" "%link%"
    echo.
    pause
    goto MainMenu
)
if "%play_choice%"=="2" goto MenuPlaylistVideo
goto MenuPlaylist

:MenuPlaylistVideo
cls
echo =========================================
echo         DOWNLOAD PLAYLIST VIDEO
echo =========================================
echo 1. 480p
echo 2. 720p
echo 3. 1080p
echo 4. 4K
echo 5. Kembali
echo =========================================
set /p play_vid_choice="Pilih resolusi (1-5): "
if "%play_vid_choice%"=="5" goto MenuPlaylist
set /p link="Masukkan Link Playlist YouTube (Ketik 0 untuk batal): "
if "%link%"=="0" goto MainMenu
if "%link%"=="" goto MenuPlaylistVideo

if "%play_vid_choice%"=="1" set res=480
if "%play_vid_choice%"=="2" set res=720
if "%play_vid_choice%"=="3" set res=1080
if "%play_vid_choice%"=="4" set res=2160

call :CheckFolder "PLAYLIST"

:: Memprioritaskan codec AVC (H.264) untuk playlist
yt-dlp --js-runtimes "deno:.\deno.exe" --no-check-certificate --ignore-errors -f "bv*[vcodec^=avc][ext=mp4][height<=%res%]+ba[ext=m4a]/bv*[ext=mp4][height<=%res%]+ba[ext=m4a]/b[ext=mp4][height<=%res%]" --merge-output-format mp4 --embed-thumbnail --embed-metadata --yes-playlist -o "PLAYLIST\%%(playlist)s\%%(playlist_index)s - %%(title)s.%%(ext)s" "%link%"
echo.
pause
goto MainMenu

:UpdateYTDLP
cls
echo =========================================
echo             MEMPERBARUI YT-DLP
echo =========================================
yt-dlp -U
echo.
pause
goto MainMenu