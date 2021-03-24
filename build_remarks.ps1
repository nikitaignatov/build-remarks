param (
    [Parameter(Mandatory)]
    [ValidateSet('pre_build', 'post_build')]
    $Type, 
    $Remarks = ".\remarks\"  ,
    [ValidateSet("es", "fr", "pl", "ru", "da", "sv", "de", "en", "it")]
    $Language     
)

Write-Host "Let's build this in style!"

$FileName = "$env:LOCALAPPDATA\told_you.mpeg"

if (Test-Path $FileName) {
    Remove-Item $FileName
}

function Download {
    param (
        $phrase, $language
    )
    $http = New-Object System.Net.WebClient
    $phrase = [System.Net.WebUtility]::UrlEncode($phrase)
    $language = [System.Net.WebUtility]::UrlEncode($language)
    $url = ("https://translate.google.com.vn/translate_tts?ie=UTF-8&q={0}&tl={1}&client=tw-ob" -f $phrase, $language)

    Start-Sleep 1
    Write-Host $url

    $http.DownloadFile($url, $FileName)
    $http.Dispose()
    
}

function Play {
    param (
        $file
    )
    Add-Type -AssemblyName presentationCore
    $mediaPlayer = New-Object System.Windows.Media.MediaPlayer
    $mediaPlayer.open($file)
    Start-Sleep 2
    $duration = $mediaPlayer.NaturalDuration.TimeSpan.TotalSeconds
    $mediaPlayer.Play()
    # Write-Host $duration
    Start-Sleep ([math]::max(2, $duration ))
    $mediaPlayer.Stop()
    $mediaPlayer.Close()
    
}

# $langs = "es", "fr", "pl", "it"
$langs = "es", "fr", "pl", "ru", "da", "sv", "de", "en", "it"
$doc = "$Remarks$Type.txt" 

$list = Import-Csv -LiteralPath $doc -Header "phrase" -Delimiter "|"
$index = Get-Random -Minimum 0 -Maximum $list.Count
$lang_index = Get-Random -Minimum 0 -Maximum $langs.Count
$phrase = $list.phrase[$index]
$lang = if ($null -eq $Language) { $langs[$lang_index] } else { $Language }

Download -phrase $phrase -language $lang
Play -file $FileName

# Write-Host "kthxbye"
