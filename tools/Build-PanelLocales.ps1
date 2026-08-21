$ErrorActionPreference = 'Stop'

$english = [ordered]@{
    'LT Ayarları' = 'LT Settings'
    'Dil' = 'Language'
    'Genel Ayarlar (Discord vb.)' = 'General Settings (Discord, etc.)'
    'Bağlantı Durumu' = 'Connection Status'
    'Kontrol ediliyor...' = 'Checking...'
    'LT Güçleri' = 'LT Powers'
    'Kameraman Modu' = 'Cameraman Mode'
    'Admin Etiketini Gizle' = 'Hide Administrator Tag'
    'Market' = 'Market'
    'Oyuncular' = 'Players'
    'Gizleme ayarları' = 'Visibility settings'
    'Çevrimiçi / Çevrimdışı' = 'Online / Offline'
    'Kullanıcı' = 'User'
    'Grup' = 'Group'
    'Aktif LP' = 'Active LP'
    'Kelledeki LP' = 'Bounty LP'
    'Ölüm' = 'Deaths'
    'Yetki' = 'Role'
    'Konum' = 'Location'
    'Yönet' = 'Manage'
    'Şu an bağlı oyuncu yok ya da oyun henüz veri yazmadı.' = 'No players are connected, or the game has not written any data yet.'
    'Kalıcı Ölüm' = 'Permanent Death'
    'Ban eşiği (kaç ölümde banlanır)' = 'Ban threshold (number of deaths)'
    'Ek hak ver (kullanıcıya özel +1/-1)' = 'Adjust extra lives for a specific user (+1/-1)'
    'Kaydet' = 'Save'
    'Kullanıcı adı' = 'Username'
    'Ölüm Sayısı' = 'Death Count'
    'Ek Hak' = 'Extra Lives'
    'Durum' = 'Status'
    'Henüz veri yok.' = 'No data yet.'
    'Hasar Logu' = 'Damage Log'
    'Göster:' = 'Show:'
    'Son 5' = 'Last 5'
    'Son 10' = 'Last 10'
    'Son 20' = 'Last 20'
    'Son 50' = 'Last 50'
    'Tümü' = 'All'
    'Kayıtları Temizle' = 'Clear Records'
    'Zaman' = 'Time'
    'Hedef' = 'Target'
    'Kimden' = 'Source'
    'Sebep' = 'Cause'
    'Can %' = 'Health %'
    'Açıklama' = 'Description'
    'Henüz hasar kaydı yok.' = 'No damage records yet.'
    'Karşılama / Kurallar' = 'Welcome / Rules'
    'Göster' = 'Show'
    'Market Yönetici Ayarları' = 'Market Administration Settings'
    'Market verisi bekleniyor...' = 'Waiting for market data...'
    'Market Açık' = 'Market Enabled'
    'Başlangıç LP' = 'Starting LP'
    'Komisyon (0.5 = %50)' = 'Commission (0.5 = 50%)'
    'Stok Yenileme (gün)' = 'Restock Interval (days)'
    'Şimdi Yenile' = 'Restock Now'
    'Elektrik (LP/gün)' = 'Electricity (LP/day)'
    'Satış Lisansı Zorunlu' = 'Sales License Required'
    'Satış Lisansı Fiyatı' = 'Sales License Price'
    'Ürün Bilgisi Fiyatı' = 'Product Information Price'
    'Beceri Şartı' = 'Skill Requirement'
    'Yönetici LP Ver' = 'Grant LP as Administrator'
    'Ver' = 'Grant'
    'Yükseltme Kademeleri' = 'Upgrade Tiers'
    'Depo' = 'Storage'
    'İndirim' = 'Discount'
    'Dondurucu' = 'Freezer'
    'Genel Ayarlar' = 'General Settings'
    'Discord Webhook' = 'Discord Webhook'
    'Test Mesajı Gönder' = 'Send Test Message'
    'Kapat' = 'Close'
    'Gizlenecek Roller' = 'Roles to Hide'
    'admin' = 'Administrator'
    'moderator' = 'Moderator'
    'user' = 'User'
    'Gizlenecek Kullanıcılar' = 'Users to Hide'
    "Kullanıcı adı yaz, Enter'a bas" = 'Enter a username and press Enter'
    'Kaydedildi.' = 'Saved.'
    'Kaydedilemedi.' = 'Could not save.'
    'Gönderiliyor...' = 'Sending...'
    'Test mesajı gönderildi, Discord kanalını kontrol et.' = 'Test message sent. Check the Discord channel.'
    'Gönderilemedi.' = 'Could not send.'
    'LT Panel Bridge ile bağlantı kurulamadı.' = 'Could not connect to LT Panel Bridge.'
    'Sunucu kapalı (ya da oyun/LT modu şu an çalışmıyor)' = 'Server offline (or the game/LT mod is not currently running)'
    'Sunucu açık - bu hesap yönetici değil, paneller gizli' = 'Server online - this account is not an administrator, panels are hidden'
    'Sunucu açık - canlı (%1 oyuncu)' = 'Server online - live (%1 players)'
    'İzlemeyi Bırak' = 'Stop Spectating'
    'İzle' = 'Spectate'
    'Işınlan' = 'Teleport'
    'Sunucudan At' = 'Kick from Server'
    'Banı Kaldır' = 'Unban'
    'Banla' = 'Ban'
    'Çevrimiçi' = 'Online'
    'Çevrimdışı' = 'Offline'
    'LT Panel Bridge ile bağlantı kurulamadı (uygulama çalışıyor mu?)' = 'Could not connect to LT Panel Bridge. Is the application running?'
    'Oyuncular - Gizleme Ayarları' = 'Players - Visibility Settings'
    'Hasar Logu - Gizleme Ayarları' = 'Damage Log - Visibility Settings'
    'Kaldır' = 'Remove'
    'ÖLÜ' = 'DEAD'
    'Banlı' = 'Banned'
    'Aktif' = 'Active'
    'oran' = 'rate'
    'Kademe %1' = 'Tier %1'
    'Maliyet (LP)' = 'Cost (LP)'
    'Kademe verisi yok.' = 'No tier data.'
}

function Invoke-PanelTranslationBatch {
    param([string[]]$Texts, [string]$TargetLanguage)
    $protected = @()
    $placeholders = @{}
    $placeholderIndex = 0
    foreach ($text in $Texts) {
        $protected += [regex]::Replace($text, '(%\d+|<[^>]+>)', {
            param($match)
            $token = 'ZXQPH{0:D4}ZXQ' -f $placeholderIndex
            $placeholderIndex++
            $placeholders[$token] = $match.Value
            return $token
        })
    }
    $parts = @()
    for ($i = 0; $i -lt $protected.Count; $i++) {
        if ($i -gt 0) { $parts += ('ZXQSEP{0:D4}ZXQ' -f $i) }
        $parts += $protected[$i]
    }
    $payload = $parts -join "`n"
    $uri = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=' + $TargetLanguage + '&dt=t&q=' + [uri]::EscapeDataString($payload)
    $response = Invoke-RestMethod -Uri $uri -Method Get -TimeoutSec 30
    $translated = ($response[0] | ForEach-Object { $_[0] }) -join ''
    $segments = [regex]::Split($translated, '\s*ZXQSEP\d{4}ZXQ\s*')
    if ($segments.Count -ne $Texts.Count) { throw "Locale batch split failed for $TargetLanguage." }
    return @($segments | ForEach-Object {
        $value = $_.Trim()
        foreach ($token in $placeholders.Keys) { $value = $value.Replace($token, $placeholders[$token]) }
        $value
    })
}

$outputDirectory = Join-Path (Split-Path $PSScriptRoot -Parent) 'public\locales'
New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null

$turkish = [ordered]@{}
foreach ($key in $english.Keys) { $turkish[$key] = $key }
Set-Content -LiteralPath (Join-Path $outputDirectory 'en.json') -Value ($english | ConvertTo-Json -Depth 4) -Encoding utf8
Set-Content -LiteralPath (Join-Path $outputDirectory 'tr.json') -Value ($turkish | ConvertTo-Json -Depth 4) -Encoding utf8

$targets = [ordered]@{ 'es' = 'es'; 'pt-BR' = 'pt'; 'ru' = 'ru'; 'zh-CN' = 'zh-CN' }
foreach ($fileCode in $targets.Keys) {
    Write-Host "Building $fileCode panel locale..."
    $locale = [ordered]@{}
    $keys = @($english.Keys)
    for ($offset = 0; $offset -lt $keys.Count; $offset += 12) {
        $end = [Math]::Min($offset + 11, $keys.Count - 1)
        $batchKeys = @($keys[$offset..$end])
        $batchValues = @($batchKeys | ForEach-Object { $english[$_] })
        $translated = Invoke-PanelTranslationBatch -Texts $batchValues -TargetLanguage $targets[$fileCode]
        for ($i = 0; $i -lt $batchKeys.Count; $i++) { $locale[$batchKeys[$i]] = $translated[$i] }
    }
    Set-Content -LiteralPath (Join-Path $outputDirectory "$fileCode.json") -Value ($locale | ConvertTo-Json -Depth 4) -Encoding utf8
}

Write-Host "Created $($targets.Count + 2) locales with $($english.Count) strings each."
