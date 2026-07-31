# YT Download iBay KUY 🚀

Sebuah script interaktif berbasis CLI (Command Line Interface) yang memudahkan Anda untuk mendownload Audio (MP3/WAV), Video (MP4 hingga 4K), maupun Playlist secara utuh dari YouTube!

Script ini menggunakan **yt-dlp** sebagai mesin utama dan didesain secara *cross-platform* agar bisa berjalan mulus di Windows, Linux, macOS, hingga Termux Android.

## 🌟 Fitur Utama
- **Multi-Platform:** Terdapat versi yang sudah disesuaikan untuk Windows (`.bat`), Linux, macOS, dan Termux (`.sh`).
- **Download Audio Kualitas Terbaik:** Konversi otomatis ke MP3 (Best Quality / Variable Bitrate 0) atau WAV (Lossless).
- **Download Video Kualitas Tinggi:** Mendukung resolusi 480p, 720p, 1080p, hingga 4K. Menggunakan codec AVC / H.264 agar file MP4 kompatibel diputar di hampir semua media player atau TV.
- **Dukungan Playlist:** Bisa mendownload seluruh isi playlist YouTube dengan sekali klik (bisa berupa Playlist Audio atau Video), dan akan diurutkan secara otomatis.
- **Auto Metadata & Thumbnail:** Gambar sampul (Cover Art) dan informasi bawaan dari video YouTube otomatis disematkan (embed) ke dalam file MP3/MP4 yang didownload.
- **Manajemen Folder Otomatis:** Script akan secara otomatis membuat folder `AUDIO`, `VIDEO`, dan `PLAYLIST` agar file Anda tidak berantakan.

---

## 🛠️ Persyaratan Wajib (Dependencies)
Sebelum menggunakan script ini, pastikan sistem/perangkat Anda sudah terinstall program berikut:
1. **[yt-dlp](https://github.com/yt-dlp/yt-dlp)**: Engine utama untuk mengunduh.
2. **[FFmpeg](https://ffmpeg.org/)**: **Sangat Wajib** ada, karena digunakan untuk mengkonversi Audio menjadi MP3 dan menggabungkan Video + Audio pada resolusi 1080p ke atas.
3. **[Deno](https://deno.land/) atau Node.js**: *(Opsional namun sangat disarankan)* Digunakan oleh yt-dlp untuk membypass bot-protection atau pembatasan usia YouTube.

---

## 🚀 Cara Install & Penggunaan

Pilih panduan di bawah ini sesuai dengan Sistem Operasi atau perangkat yang Anda gunakan:

### 🪟 Windows
1. Pastikan Anda telah mendownload file `.exe` mandiri untuk `yt-dlp.exe`, `ffmpeg.exe`, dan `deno.exe`.
2. Letakkan ketiga file executable tersebut **di dalam folder yang sama** dengan file `YT-Manager.bat`.
3. Klik dua kali (*double click*) pada file `YT-Manager.bat`.
4. Script akan mengecek ketersediaan file tersebut. Jika lengkap, menu utama akan terbuka dan siap digunakan!

### 🐧 Linux (Ubuntu / Debian / Linux Mint)
1. Buka Terminal dan install semua dependensi melalui `apt` dan `pip`:
   ```bash
   sudo apt update
   sudo apt install ffmpeg nodejs python3-pip
   pip install yt-dlp
   ```
2. Berikan hak akses eksekusi pada script agar bisa dijalankan:
   ```bash
   chmod +x yt-manager-linux.sh
   ```
3. Jalankan script:
   ```bash
   ./yt-manager-linux.sh
   ```

### 🍎 macOS
1. Buka Terminal dan install dependensi menggunakan **Homebrew**:
   ```bash
   brew update
   brew install yt-dlp ffmpeg deno
   ```
2. Berikan hak akses eksekusi pada script:
   ```bash
   chmod +x yt-manager-mac.sh
   ```
3. Jalankan script:
   ```bash
   ./yt-manager-mac.sh
   ```

### 📱 Android (Termux)
1. Buka aplikasi Termux dan **izinkan akses penyimpanan internal** (Wajib dilakukan agar file hasil download tidak hilang dan bisa diakses lewat File Manager HP Anda):
   ```bash
   termux-setup-storage
   ```
2. Install semua aplikasi pendukungnya:
   ```bash
   pkg update
   pkg install python ffmpeg nodejs
   pip install yt-dlp
   ```
   *(Alternatif: Anda juga bisa menggunakan `pkg install yt-dlp` jika sudah tersedia di repository bawaan).*
3. Berikan hak akses pada file script Termux:
   ```bash
   chmod +x yt-manager-termux.sh
   ```
4. Jalankan script:
   ```bash
   ./yt-manager-termux.sh
   ```

---

## 📂 Struktur Penyimpanan
Apapun sistem operasi yang Anda gunakan, script ini akan secara otomatis merapikan semua hasil download Anda dan memasukkannya ke dalam folder-folder berikut (dibuat bersebelahan dengan script):

- 🎵 **`AUDIO/`**  — Tempat berkumpulnya lagu MP3 dan file WAV.
- 🎬 **`VIDEO/`**  — Tempat hasil download video format MP4.
- 🗂️ **`PLAYLIST/`** — Tempat hasil unduhan Playlist (Akan dibuatkan sub-folder sendiri menggunakan nama asli playlist YouTube-nya, file diurutkan dengan nomor urut).

---

### 💡 Catatan Tambahan
- **Error saat memasukkan link?** Pastikan link yang Anda salin utuh. Apabila Anda berubah pikiran dan ingin kembali ke Menu Utama saat dimintai link, Anda cukup **mengetik angka `0`** lalu tekan Enter.
- **Selalu Update yt-dlp!** Karena YouTube sering mengubah sistem perlindungannya, pastikan `yt-dlp` Anda selalu berada dalam versi terbaru agar tidak gagal download. Anda dapat mengupdatenya secara langsung melalui opsi **Update YT-DLP** di dalam aplikasi (Menu No. 4).
