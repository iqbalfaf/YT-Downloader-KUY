#!/bin/bash

# Warna untuk output Terminal
GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m' # No Color (Kembali ke warna asli)

# =========================================
# SETUP FOLDER PENYIMPANAN INTERNAL (TERMUX)
# =========================================
BASE_DIR="$HOME/storage/shared/YTDownloaderKUY"

if [ ! -d "$HOME/storage/shared" ]; then
    echo -e "${RED}[ERROR] Akses penyimpanan internal belum diizinkan!${NC}"
    echo "Meminta izin penyimpanan... (Silakan klik 'Allow/Izinkan' pada popup di layar HP)"
    termux-setup-storage
    echo -e "${YELLOW}Setelah Anda mengizinkan popup, silakan jalankan ulang script ini.${NC}"
    exit 1
fi

# Buat dan pindah ke direktori YTDownloaderKUY di memori internal
mkdir -p "$BASE_DIR"
cd "$BASE_DIR" || exit

# =========================================
# SETUP COOKIES DEFAULT (CEK cookies.txt)
# =========================================
COOKIE_ARG=""
COOKIE_NAME="Tidak Aktif"
if [ -f "cookies.txt" ]; then
    COOKIE_ARG="--cookies cookies.txt"
    COOKIE_NAME="File cookies.txt (Otomatis)"
fi

# =========================================
# PENGECEKAN DEPENDENCY (yt-dlp, ffmpeg, deno)
# =========================================
check_dependencies() {
    echo ""
    # Cek yt-dlp
    if ! command -v yt-dlp >/dev/null 2>&1; then
        echo -e "${RED}[ERROR] yt-dlp tidak ditemukan!${NC}"
        echo "Silakan install yt-dlp terlebih dahulu."
        echo "Termux: pkg install yt-dlp"
        read -p "Tekan Enter untuk keluar..."
        exit 1
    fi
    
    # Cek ffmpeg
    if ! command -v ffmpeg >/dev/null 2>&1; then
        echo -e "${RED}[ERROR] ffmpeg tidak ditemukan!${NC}"
        echo "ffmpeg WAJIB ada untuk convert audio ke MP3 dan gabung video 1080p+."
        echo "Termux: pkg install ffmpeg"
        read -p "Tekan Enter untuk keluar..."
        exit 1
    fi

    # Cek deno (opsional tapi disarankan)
    if ! command -v deno >/dev/null 2>&1 && ! command -v node >/dev/null 2>&1; then
        echo -e "${YELLOW}[WARNING] deno / node.js tidak ditemukan!${NC}"
        echo "Beberapa bypass YouTube (seperti batasan umur/bot) mungkin gagal tanpa Deno/Node."
        echo "Termux: pkg install nodejs ATAU pkg install deno"
        read -p "Tekan Enter untuk tetap melanjutkan..."
    fi
}

# =========================================
# FUNGSI CEK & BUAT FOLDER
# =========================================
check_folder() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo -e "${CYAN}[+] Folder \"$1\" belum ada, membuat folder baru...${NC}"
    else
        echo -e "${GREEN}[*] Folder \"$1\" sudah ada.${NC}"
    fi
    echo ""
}

# Jalankan pengecekan di awal
check_dependencies

# =========================================
# MENU UTAMA
# =========================================
while true; do
    clear
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}       YT DOWNLOAD iBay KUY (Termux)${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo -e "Status Cookies : ${YELLOW}${COOKIE_NAME}${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo "1. Download Audio"
    echo "2. Download Video"
    echo "3. Download Playlist"
    echo "4. Pengaturan Cookies (Bypass Bot / Sign In)"
    echo "5. Update YT-DLP"
    echo "0. Keluar"
    echo -e "${GREEN}=========================================${NC}"
    read -p "Pilih menu (1-5, 0 untuk keluar): " main_choice

    case "$main_choice" in
        1) # MENU AUDIO
            while true; do
                clear
                echo -e "${GREEN}=========================================${NC}"
                echo -e "${GREEN}             DOWNLOAD AUDIO${NC}"
                echo -e "${GREEN}=========================================${NC}"
                echo "1. MP3 (Kualitas Terbaik)"
                echo "2. WAV (Lossless)"
                echo "0. Kembali ke Menu Utama"
                echo -e "${GREEN}=========================================${NC}"
                read -p "Pilih format (1-2, 0 untuk kembali): " audio_choice

                if [ "$audio_choice" == "0" ]; then
                    break
                elif [ "$audio_choice" != "1" ] && [ "$audio_choice" != "2" ]; then
                    continue
                fi

                read -p "Masukkan Link atau ID YouTube (Ketik 0 untuk batal): " link
                if [ "$link" == "0" ]; then
                    break
                elif [ -z "$link" ]; then
                    continue
                fi

                check_folder "AUDIO"

                if [ "$audio_choice" == "1" ]; then
                    yt-dlp $COOKIE_ARG --no-check-certificate --extractor-args "youtube:player_client=default,web,android" --retries 10 --fragment-retries 10 -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata -o "AUDIO/%(title)s.%(ext)s" "$link"
                elif [ "$audio_choice" == "2" ]; then
                    yt-dlp $COOKIE_ARG --no-check-certificate --extractor-args "youtube:player_client=default,web,android" --retries 10 --fragment-retries 10 -x --audio-format wav --embed-thumbnail --embed-metadata -o "AUDIO/%(title)s.%(ext)s" "$link"
                fi
                echo ""
                read -p "Tekan Enter untuk melanjutkan..."
                break
            done
            ;;
        2) # MENU VIDEO
            while true; do
                clear
                echo -e "${GREEN}=========================================${NC}"
                echo -e "${GREEN}             DOWNLOAD VIDEO (MP4)${NC}"
                echo -e "${GREEN}=========================================${NC}"
                echo "1. 480p"
                echo "2. 720p"
                echo "3. 1080p"
                echo "4. 4K"
                echo "0. Kembali ke Menu Utama"
                echo -e "${GREEN}=========================================${NC}"
                read -p "Pilih resolusi (1-4, 0 untuk kembali): " video_choice

                if [ "$video_choice" == "0" ]; then
                    break
                fi

                res=480
                case "$video_choice" in
                    1) res=480 ;;
                    2) res=720 ;;
                    3) res=1080 ;;
                    4) res=2160 ;;
                    *) continue ;;
                esac

                read -p "Masukkan Link atau ID YouTube (Ketik 0 untuk batal): " link
                if [ "$link" == "0" ]; then
                    break
                elif [ -z "$link" ]; then
                    continue
                fi

                check_folder "VIDEO"

                yt-dlp $COOKIE_ARG --no-check-certificate --extractor-args "youtube:player_client=default,web,android" --retries 10 --fragment-retries 10 -f "bv*[vcodec^=avc][ext=mp4][height<=${res}]+ba[ext=m4a]/bv*[ext=mp4][height<=${res}]+ba[ext=m4a]/bv*[height<=${res}]+ba/b[height<=${res}]/best" --merge-output-format mp4 --embed-thumbnail --embed-metadata -o "VIDEO/%(title)s.%(ext)s" "$link"
                
                echo ""
                read -p "Tekan Enter untuk melanjutkan..."
                break
            done
            ;;
        3) # MENU PLAYLIST
            while true; do
                clear
                echo -e "${GREEN}=========================================${NC}"
                echo -e "${GREEN}            DOWNLOAD PLAYLIST${NC}"
                echo -e "${GREEN}=========================================${NC}"
                echo "1. Playlist Audio (MP3)"
                echo "2. Playlist Video (MP4)"
                echo "0. Kembali ke Menu Utama"
                echo -e "${GREEN}=========================================${NC}"
                read -p "Pilih tipe (1-2, 0 untuk kembali): " play_choice

                if [ "$play_choice" == "0" ]; then
                    break
                fi

                if [ "$play_choice" == "1" ]; then
                    read -p "Masukkan Link Playlist YouTube (Ketik 0 untuk batal): " link
                    if [ "$link" == "0" ]; then
                        break
                    elif [ -z "$link" ]; then
                        continue
                    fi
                    
                    check_folder "PLAYLIST"
                    yt-dlp $COOKIE_ARG --no-check-certificate --extractor-args "youtube:player_client=default,web,android" --compat-options no-youtube-unavailable-videos --ignore-errors --retries 10 --fragment-retries 10 -x --audio-format mp3 --audio-quality 0 --embed-thumbnail --embed-metadata --yes-playlist -o "PLAYLIST/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "$link"
                    echo ""
                    read -p "Tekan Enter untuk melanjutkan..."
                    break
                
                elif [ "$play_choice" == "2" ]; then
                    # Menu Playlist Video
                    while true; do
                        clear
                        echo -e "${GREEN}=========================================${NC}"
                        echo -e "${GREEN}         DOWNLOAD PLAYLIST VIDEO${NC}"
                        echo -e "${GREEN}=========================================${NC}"
                        echo "1. 480p"
                        echo "2. 720p"
                        echo "3. 1080p"
                        echo "4. 4K"
                        echo "0. Kembali ke Menu Playlist"
                        echo -e "${GREEN}=========================================${NC}"
                        read -p "Pilih resolusi (1-4, 0 untuk kembali): " play_vid_choice

                        if [ "$play_vid_choice" == "0" ]; then
                            break
                        fi

                        res=480
                        case "$play_vid_choice" in
                            1) res=480 ;;
                            2) res=720 ;;
                            3) res=1080 ;;
                            4) res=2160 ;;
                            *) continue ;;
                        esac

                        read -p "Masukkan Link Playlist YouTube (Ketik 0 untuk batal): " link
                        if [ "$link" == "0" ]; then
                            break
                        elif [ -z "$link" ]; then
                            continue
                        fi

                        check_folder "PLAYLIST"
                        yt-dlp $COOKIE_ARG --no-check-certificate --extractor-args "youtube:player_client=default,web,android" --compat-options no-youtube-unavailable-videos --ignore-errors --retries 10 --fragment-retries 10 -f "bv*[vcodec^=avc][ext=mp4][height<=${res}]+ba[ext=m4a]/bv*[ext=mp4][height<=${res}]+ba[ext=m4a]/bv*[height<=${res}]+ba/b[height<=${res}]/best" --merge-output-format mp4 --embed-thumbnail --embed-metadata --yes-playlist -o "PLAYLIST/%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" "$link"
                        
                        echo ""
                        read -p "Tekan Enter untuk melanjutkan..."
                        break 2
                    done
                fi
            done
            ;;
        4) # MENU COOKIES
            while true; do
                clear
                echo -e "${GREEN}=========================================${NC}"
                echo -e "${GREEN}       PENGATURAN COOKIES (BYPASS BOT)${NC}"
                echo -e "${GREEN}=========================================${NC}"
                echo "Jika muncul error \"Sign in to confirm you're not a bot\","
                echo "Anda dapat meletakkan file cookies.txt di folder YTDownloaderKUY."
                echo ""
                echo -e "Status Saat Ini: ${YELLOW}${COOKIE_NAME}${NC}"
                echo -e "${GREEN}=========================================${NC}"
                echo "1. Gunakan file cookies.txt"
                echo "2. Nonaktifkan Cookies"
                echo "0. Kembali ke Menu Utama"
                echo -e "${GREEN}=========================================${NC}"
                read -p "Pilih opsi (1-2, 0 untuk kembali): " cookie_choice

                if [ "$cookie_choice" == "0" ]; then
                    break
                elif [ "$cookie_choice" == "1" ]; then
                    if [ ! -f "cookies.txt" ]; then
                        echo -e "\n${RED}[!] File cookies.txt tidak ditemukan di folder YTDownloaderKUY!${NC}"
                        read -p "Tekan Enter untuk melanjutkan..."
                        continue
                    fi
                    COOKIE_ARG="--cookies cookies.txt"
                    COOKIE_NAME="File cookies.txt"
                    echo -e "\n${GREEN}[+] Cookies disetel: File cookies.txt${NC}"
                    read -p "Tekan Enter untuk kembali ke Menu Utama..."
                    break
                elif [ "$cookie_choice" == "2" ]; then
                    COOKIE_ARG=""
                    COOKIE_NAME="Tidak Aktif"
                    echo -e "\n${YELLOW}[*] Cookies dinonaktifkan.${NC}"
                    read -p "Tekan Enter untuk kembali ke Menu Utama..."
                    break
                fi
            done
            ;;
        5) # UPDATE YTDLP
            while true; do
                clear
                echo -e "${GREEN}=========================================${NC}"
                echo -e "${GREEN}             MEMPERBARUI YT-DLP${NC}"
                echo -e "${GREEN}=========================================${NC}"
                echo "1. Update ke Versi Stabil (Rilis Resmi)"
                echo "2. Update ke Versi Nightly (Fix Bug YouTube Terbaru)"
                echo "3. Bersihkan Cache yt-dlp"
                echo "0. Kembali ke Menu Utama"
                echo -e "${GREEN}=========================================${NC}"
                read -p "Pilih opsi (1-3, 0 untuk kembali): " update_choice

                if [ "$update_choice" == "0" ]; then
                    break
                elif [ "$update_choice" == "1" ]; then
                    echo ""
                    echo "[*] Mengupdate yt-dlp ke versi stabil..."
                    yt-dlp -U || echo -e "\nJika gagal (Permission Denied/Error), jalankan manual via terminal:\npkg install yt-dlp"
                    echo ""
                    read -p "Tekan Enter untuk kembali..."
                    break
                elif [ "$update_choice" == "2" ]; then
                    echo ""
                    echo "[*] Mengupdate yt-dlp ke versi nightly terbaru..."
                    yt-dlp --update-to nightly || echo -e "\nJika gagal, coba: pip install --upgrade --pre yt-dlp"
                    echo ""
                    read -p "Tekan Enter untuk kembali..."
                    break
                elif [ "$update_choice" == "3" ]; then
                    echo ""
                    echo "[*] Membersihkan cache yt-dlp..."
                    yt-dlp --rm-cache-dir
                    echo ""
                    read -p "Tekan Enter untuk kembali..."
                    break
                fi
            done
            ;;
        0) # EXIT
            clear
            exit 0
            ;;
        *)
            ;;
    esac
done
