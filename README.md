# LT Panel Bridge

Current version: **v1.0.2**

LightTune mod paketinin web panelini yerelde sunan companion uygulama.
**Bu bir Workshop mod'u değildir ve `Zomboid/mods` klasörüne kopyalanmamalıdır.**
Oyunun dışında, admin'in kendi bilgisayarında ayrı bir process olarak çalışır ve
**Steam Workshop'tan indirilemez** - Workshop sadece PZ'nin kendi yüklediği mod
içeriğini dağıtabilir, ayrı bir program değil.

## İlk defa kuruyorsan (yeni bir bilgisayarda) sırasıyla ne yapman lazım

1. **Node.js kur.** [nodejs.org](https://nodejs.org/) adresinden **LTS** sürümünü
   indirip kur (v18 veya üzeri). Ekstra bir paket kurulumuna gerek yok, bu klasördeki
   dosyalar hazır.
2. **Bu `LTPanelBridge` klasörünü** o bilgisayara kopyala - USB, bulut depolama (Google
   Drive/OneDrive vb.) veya GitHub Releases üzerinden. Workshop'tan gelmez, elle
   taşınması gerekir.
3. **LT Workshop mod'larını da o bilgisayara kur** (Mods menüsünden etkinleştir) ve
   sunucuya **admin hesabınla** giriş yap. Panel, `LightTuneLib`'in o bilgisayarın kendi
   diskine (`Zomboid/Lua/LightTune/state/`) yazdığı dosyaları okur - bu yüzden panel ile
   oyunun **aynı bilgisayarda** çalışması gerekiyor; biri PC'de biri başka bir cihazda
   olmaz.
4. Bu klasördeki `start-lt-panel.bat` dosyasına çift tıkla (ya da terminalde
   `node server.js`).
5. Terminalde şunu görünce hazırdır:
   ```
   LT Ayarlari paneli calisiyor: http://localhost:4242/
   ```
6. Tarayıcıda (yan monitörde) `http://localhost:4242` adresini aç.
7. Oyun içinde admin panelden **"LT Ayarlari"** butonuna bas - LightTuneLib bağlı
   olduğunu `/api/ping` üzerinden bildirir, sayfadaki durum noktası yeşile döner.

## Nasıl çalışır

`LightTuneLib` (PZ mod'u) oyun içindeki durumu şu klasöre JSON dosyaları olarak yazar:

```
%UserProfile%\Zomboid\Lua\LightTune\state\
```

Bu uygulama o klasörü okuyup `http://localhost:4242` adresinde bir web sayfası olarak
sunar - Kameraman Modu, İzleyici Ayarları, Hasar Logu, Toplist, Kalıcı Ölüm gibi tüm
bölümleri içerir.

## Kalıcı kurulum

Bilgisayar her açıldığında elle çalıştırmak istemiyorsan, Windows Görev Zamanlayıcısı'na
(Task Scheduler) `start-lt-panel.bat`'ı "oturum açılışında çalıştır" olarak ekleyebilirsin.

## GitHub üzerinden yayınlama

Depo GitHub'a gönderildikten sonra `v1.0.2` gibi bir sürüm etiketi gönderildiğinde
`.github/workflows/release.yml` otomatik olarak taşınabilir `LTPanelBridge.zip` dosyasını
ve SHA-256 doğrulama dosyasını üretip GitHub Releases bölümüne ekler. Workshop açıklamalarındaki
MediaFire bağlantıları, gerçek GitHub depo adresi belli olduktan sonra bu Release indirme
bağlantısıyla değiştirilmelidir.
