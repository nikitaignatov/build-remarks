param (
    [Parameter(Mandatory)]
    [ValidateSet('pre_build', 'post_build')]
    $Type, 
    $Remarks = ".\remarks\"  ,
    [ValidateSet("es", "fr", "pl", "ru", "da", "no", "sv", "de", "en", "it", "fi", "et", "tr","en-UK", "en-AU")]
    $Language     
)

Write-Host "Let's build this in style!"

function Hash {
    param (
        $phrase, $language
    )

    $k = new-object System.Security.Cryptography.SHA256Managed | ForEach-Object { 
        $_.ComputeHash([System.Text.Encoding]::UTF8.GetBytes("$language.$phrase")) 
    }  

    [System.BitConverter]::ToString($k).Replace("-", "")
}

function Download {
    param (
        $phrase, $language
    )

    $sha256 = (Hash  $phrase $language)
    $file = "$env:LOCALAPPDATA/$language.$sha256.mpeg"
    
    Write-Host "file $file"
    if (Test-Path $file) {
        return $file
    }

    $http = New-Object System.Net.WebClient
    $phrase = [System.Net.WebUtility]::UrlEncode($phrase)
    $language = [System.Net.WebUtility]::UrlEncode($language)
    $url = ("https://translate.google.com.vn/translate_tts?ie=UTF-8&q={0}&tl={1}&client=tw-ob" -f $phrase, $language)

    Start-Sleep 1
    Write-Host $url

    $http.DownloadFile($url, $file)
    $http.Dispose()
    return $file    
}

function Play {
    param (
        $file
    )
    Write-Host "k $file"
    Add-Type -AssemblyName presentationCore
    $mediaPlayer = New-Object System.Windows.Media.MediaPlayer
    $mediaPlayer.open($file)
    Start-Sleep 1
    $duration = $mediaPlayer.NaturalDuration.TimeSpan.TotalSeconds
    $mediaPlayer.Play()
    # Write-Host $duration
    Start-Sleep ([math]::max(2, $duration ))
    $mediaPlayer.Stop()
    $mediaPlayer.Close()
    
}

# $langs = "es", "fr", "pl", "it"
$langs = "es", "fr", "pl", "ru", "da", "sv", "de", "en", "it", "en-UK", "en-AU"
$doc = "$Remarks$Type.txt" 

$list = Import-Csv -LiteralPath $doc -Header "phrase" -Delimiter "|"
$index = Get-Random -Minimum 0 -Maximum $list.Count
$lang_index = Get-Random -Minimum 0 -Maximum $langs.Count
$phrase = $list.phrase[$index]
$lang = if ($null -eq $Language) { $langs[$lang_index] } else { $Language }

$FileName = Download -phrase $phrase -language $lang
Play -file $FileName

Write-Host "kthxbye"
