@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title YT DOWNLOAD iBay KUY
color 0A

:: =========================================
:: SETUP COOKIES DEFAULT (CEK cookies.txt)
:: =========================================
set "COOKIE_ARG="
set "COOKIE_NAME=Tidak Aktif"
if exist "cookies.txt" (
    set "COOKIE_ARG=--cookies cookies.txt"
    set "COOKIE_NAME=File cookies.txt (Otomatis)"
)

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
    pause >nul
)
:: =========================================

:MainMenu
cls
echo =========================================
echo       YT DOWNLOAD iBay KUY
echo =========================================
echo Status Cookies : %COOKIE_NAME%
echo =========================================
echo 1. Download Audio
echo 2. Download Video
echo 3. Download Playlist
echo 4. Pengaturan Cookies (Bypass Bot / Sign In)
echo 5. Update YT-DLP
echo 0. Keluar
echo =========================================
set "main_choice="
set /p main_choice="Pilih menu (1-5, 0 untuk keluar): "

if "%main_choice%"=="1" goto MenuAudio
if "%main_choice%"=="2" goto MenuVideo
if "%main_choice%"=="3" goto MenuPlaylist
if "%main_choice%"=="4" goto MenuCookies
if "%main_choice%"=="5" goto UpdateYTDLP
if "%main_choice%"=="0" exit
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
echo 1. MP3 (Kualitas Terbaik)
echo 2. WAV (Lossless)
echo 0. Kembali ke Menu Utama
echo =========================================
set "audio_choice="
set /p audio_choice="Pilih format (1-2, 0 untuk kembali): "
if "%audio_choice%"=="0" goto MainMenu
if "%audio_choice%"=="" goto MenuAudio

set "link="
set /p link="Masukkan Link atau ID YouTube (Ketik 0 untuk batal): "
if "%link%"=="0" goto MainMenu
if "%link%"=="" goto MenuAudio

call :CheckFolder "AUDIO"

if "%audio_choice%"=="1" (
    yt-dlp %COOKIE_ARG% --js-runtimes "deno:.\deno.exe" --no-check-certificate --extractor-args "youtube:player_client=android,web" --retries 10 --fragment-retries 10 -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata -o "AUDIO\%%(title)s.%%(ext)s" "%link%"
)
if "%audio_choice%"=="2" (
    yt-dlp %COOKIE_ARG% --js-runtimes "deno:.\deno.exe" --no-check-certificate --extractor-args "youtube:player_client=android,web" --retries 10 --fragment-retries 10 -x --audio-format wav --embed-thumbnail --embed-metadata -o "AUDIO\%%(title)s.%%(ext)s" "%link%"
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
echo 0. Kembali ke Menu Utama
echo =========================================
set "video_choice="
set /p video_choice="Pilih resolusi (1-4, 0 untuk kembali): "
if "%video_choice%"=="0" goto MainMenu

set res=
if "%video_choice%"=="1" set res=480
if "%video_choice%"=="2" set res=720
if "%video_choice%"=="3" set res=1080
if "%video_choice%"=="4" set res=2160
if "%res%"=="" goto MenuVideo

set "link="
set /p link="Masukkan Link atau ID YouTube (Ketik 0 untuk batal): "
if "%link%"=="0" goto MainMenu
if "%link%"=="" goto MenuVideo

call :CheckFolder "VIDEO"

:: Memprioritaskan codec AVC (H.264) yang didukung semua player dengan fallback otomatis
yt-dlp %COOKIE_ARG% --js-runtimes "deno:.\deno.exe" --no-check-certificate --extractor-args "youtube:player_client=android,web" --retries 10 --fragment-retries 10 -f "bv*[vcodec^=avc][ext=mp4][height<=%res%]+ba[ext=m4a]/bv*[ext=mp4][height<=%res%]+ba[ext=m4a]/bv*[height<=%res%]+ba/b[height<=%res%]/best" --merge-output-format mp4 --embed-thumbnail --embed-metadata -o "VIDEO\%%(title)s.%%(ext)s" "%link%"
echo.
pause
goto MainMenu

:MenuPlaylist
cls
echo =========================================
echo            DOWNLOAD PLAYLIST
echo =========================================
echo 1. Playlist Audio (MP3)
echo 2. Playlist Video (MP4)
echo 0. Kembali ke Menu Utama
echo =========================================
set "play_choice="
set /p play_choice="Pilih tipe (1-2, 0 untuk kembali): "
if "%play_choice%"=="0" goto MainMenu
if "%play_choice%"=="1" goto MenuPlaylistAudio
if "%play_choice%"=="2" goto MenuPlaylistVideo
goto MenuPlaylist

:MenuPlaylistAudio
cls
echo =========================================
echo        DOWNLOAD PLAYLIST AUDIO (MP3)
echo =========================================
set "link="
set /p link="Masukkan Link Playlist YouTube (Ketik 0 untuk batal): "
if "%link%"=="0" goto MainMenu
if "%link%"=="" goto MenuPlaylistAudio

call :CheckFolder "PLAYLIST"

yt-dlp %COOKIE_ARG% --js-runtimes "deno:.\deno.exe" --no-check-certificate --extractor-args "youtube:player_client=android,web" --compat-options no-youtube-unavailable-videos --ignore-errors --retries 10 --fragment-retries 10 -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata --yes-playlist -o "PLAYLIST\%%(playlist)s\%%(playlist_index)s - %%(title)s.%%(ext)s" "%link%"
echo.
pause
goto MainMenu

:MenuPlaylistVideo
cls
echo =========================================
echo         DOWNLOAD PLAYLIST VIDEO
echo =========================================
echo 1. 480p
echo 2. 720p
echo 3. 1080p
echo 4. 4K
echo 0. Kembali ke Menu Playlist
echo =========================================
set "play_vid_choice="
set /p play_vid_choice="Pilih resolusi (1-4, 0 untuk kembali): "
if "%play_vid_choice%"=="0" goto MenuPlaylist

set res=
if "%play_vid_choice%"=="1" set res=480
if "%play_vid_choice%"=="2" set res=720
if "%play_vid_choice%"=="3" set res=1080
if "%play_vid_choice%"=="4" set res=2160
if "%res%"=="" goto MenuPlaylistVideo

set "link="
set /p link="Masukkan Link Playlist YouTube (Ketik 0 untuk batal): "
if "%link%"=="0" goto MainMenu
if "%link%"=="" goto MenuPlaylistVideo

call :CheckFolder "PLAYLIST"

:: Memprioritaskan codec AVC (H.264) untuk playlist dengan fallback otomatis
yt-dlp %COOKIE_ARG% --js-runtimes "deno:.\deno.exe" --no-check-certificate --extractor-args "youtube:player_client=android,web" --compat-options no-youtube-unavailable-videos --ignore-errors --retries 10 --fragment-retries 10 -f "bv*[vcodec^=avc][ext=mp4][height<=%res%]+ba[ext=m4a]/bv*[ext=mp4][height<=%res%]+ba[ext=m4a]/bv*[height<=%res%]+ba/b[height<=%res%]/best" --merge-output-format mp4 --embed-thumbnail --embed-metadata --yes-playlist -o "PLAYLIST\%%(playlist)s\%%(playlist_index)s - %%(title)s.%%(ext)s" "%link%"
echo.
pause
goto MainMenu

:MenuCookies
cls
echo =========================================
echo       PENGATURAN COOKIES (BYPASS BOT)
echo =========================================
echo Jika muncul error "Sign in to confirm you're not a bot",
echo Anda bisa menghubungkan cookies dari browser Anda atau file cookies.txt.
echo.
echo Status Saat Ini: %COOKIE_NAME%
echo =========================================
echo 1. Ambil Cookies dari Google Chrome
echo 2. Ambil Cookies dari Mozilla Firefox
echo 3. Ambil Cookies dari Microsoft Edge
echo 4. Ambil Cookies dari Brave Browser
echo 5. Gunakan file cookies.txt (di folder script)
echo 6. Nonaktifkan Cookies
echo 0. Kembali ke Menu Utama
echo =========================================
set "cookie_choice="
set /p cookie_choice="Pilih opsi (1-6, 0 untuk kembali): "

if "%cookie_choice%"=="0" goto MainMenu
if "%cookie_choice%"=="1" (
    set "COOKIE_ARG=--cookies-from-browser chrome"
    set "COOKIE_NAME=Google Chrome"
    echo.
    echo [+] Cookies disetel: Google Chrome
    pause
    goto MainMenu
)
if "%cookie_choice%"=="2" (
    set "COOKIE_ARG=--cookies-from-browser firefox"
    set "COOKIE_NAME=Mozilla Firefox"
    echo.
    echo [+] Cookies disetel: Mozilla Firefox
    pause
    goto MainMenu
)
if "%cookie_choice%"=="3" (
    set "COOKIE_ARG=--cookies-from-browser edge"
    set "COOKIE_NAME=Microsoft Edge"
    echo.
    echo [+] Cookies disetel: Microsoft Edge
    pause
    goto MainMenu
)
if "%cookie_choice%"=="4" (
    set "COOKIE_ARG=--cookies-from-browser brave"
    set "COOKIE_NAME=Brave Browser"
    echo.
    echo [+] Cookies disetel: Brave Browser
    pause
    goto MainMenu
)
if "%cookie_choice%"=="5" (
    if not exist "cookies.txt" (
        echo.
        echo [!] File cookies.txt tidak ditemukan di folder script!
        echo Letakkan file cookies.txt di folder yang sama dengan script ini.
        pause
        goto MenuCookies
    )
    set "COOKIE_ARG=--cookies cookies.txt"
    set "COOKIE_NAME=File cookies.txt"
    echo.
    echo [+] Cookies disetel: File cookies.txt
    pause
    goto MainMenu
)
if "%cookie_choice%"=="6" (
    set "COOKIE_ARG="
    set "COOKIE_NAME=Tidak Aktif"
    echo.
    echo [*] Cookies dinonaktifkan.
    pause
    goto MainMenu
)
goto MenuCookies

:UpdateYTDLP
cls
echo =========================================
echo             MEMPERBARUI YT-DLP
echo =========================================
echo 1. Update ke Versi Stabil (Rilis Resmi)
echo 2. Update ke Versi Nightly (Fix Bug YouTube Terbaru)
echo 3. Bersihkan Cache yt-dlp
echo 0. Kembali ke Menu Utama
echo =========================================
set "upd_choice="
set /p upd_choice="Pilih opsi (1-3, 0 untuk kembali): "
if "%upd_choice%"=="0" goto MainMenu
if "%upd_choice%"=="1" (
    echo.
    echo [*] Mengupdate yt-dlp ke versi stabil...
    yt-dlp -U
)
if "%upd_choice%"=="2" (
    echo.
    echo [*] Mengupdate yt-dlp ke versi nightly terbaru...
    yt-dlp --update-to nightly
)
if "%upd_choice%"=="3" (
    echo.
    echo [*] Membersihkan cache yt-dlp...
    yt-dlp --rm-cache-dir
)
echo.
pause
goto MainMenu