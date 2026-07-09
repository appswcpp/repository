[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceXml = Join-Path $repoRoot 'input\application.xml'
$logoSource = Join-Path $repoRoot 'review_artifacts\appsw-itc-logo.png'
$generatedOutput = Join-Path $repoRoot 'output'
$workDirectory = Join-Path $repoRoot 'tmp\base-review-pdf-build'
$renderDirectory = Join-Path $workDirectory 'render'
$profileDirectory = Join-Path $workDirectory 'browser-profiles'

function Replace-RegexOnce {
    param(
        [string]$Text,
        [string]$Pattern,
        [System.Text.RegularExpressions.MatchEvaluator]$Evaluator,
        [string]$Label
    )

    $regex = [regex]::new($Pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $matches = $regex.Matches($Text)
    if ($matches.Count -ne 1) {
        throw "Expected exactly one $Label match; found $($matches.Count)."
    }
    return $regex.Replace($Text, $Evaluator, 1)
}

function Replace-LiteralOnce {
    param(
        [string]$Text,
        [string]$Search,
        [string]$Replacement,
        [string]$Label
    )

    $index = $Text.IndexOf($Search, [System.StringComparison]::Ordinal)
    if ($index -lt 0) {
        throw "Missing expected $Label text."
    }
    if ($Text.IndexOf($Search, $index + $Search.Length, [System.StringComparison]::Ordinal) -ge 0) {
        throw "Found duplicate $Label text."
    }
    return $Text.Substring(0, $index) + $Replacement + $Text.Substring($index + $Search.Length)
}

function Find-Browser {
    $candidates = @(
        'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe',
        'C:\Program Files\Microsoft\Edge\Application\msedge.exe',
        'C:\Program Files\Google\Chrome\Application\chrome.exe'
    )
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }
    throw 'Microsoft Edge or Google Chrome is required to render the review PDFs.'
}

function Write-Pdf {
    param(
        [string]$Browser,
        [string]$HtmlPath,
        [string]$PdfPath,
        [string]$ProfilePath
    )

    New-Item -ItemType Directory -Force -Path $ProfilePath | Out-Null
    $arguments = @(
        '--headless',
        '--disable-gpu',
        '--no-first-run',
        '--disable-extensions',
        '--no-pdf-header-footer',
        "--user-data-dir=$ProfilePath",
        "--print-to-pdf=$PdfPath",
        ([System.Uri]$HtmlPath).AbsoluteUri
    )
    $process = Start-Process -FilePath $Browser -ArgumentList $arguments -WindowStyle Hidden -Wait -PassThru
    if (-not (Test-Path -LiteralPath $PdfPath)) {
        throw "Browser exited $($process.ExitCode) without creating $PdfPath."
    }
    $item = Get-Item -LiteralPath $PdfPath
    if ($item.Length -lt 50000) {
        throw "Generated PDF is unexpectedly small: $PdfPath"
    }
    $stream = [System.IO.File]::OpenRead($PdfPath)
    try {
        $signature = New-Object byte[] 5
        [void]$stream.Read($signature, 0, $signature.Length)
    }
    finally {
        $stream.Dispose()
    }
    if ([System.Text.Encoding]::ASCII.GetString($signature) -ne '%PDF-') {
        throw "Generated file is not a PDF: $PdfPath"
    }
}

$xml = Get-Content -LiteralPath $sourceXml -Raw -Encoding utf8
if ($xml -notmatch '<cPP\s*/>') {
    throw 'The source is not marked as a collaborative PP (<cPP/>).'
}
if ($xml -notmatch '<suppress-niap-logo\s*/>') {
    throw 'The source must suppress NIAP branding for the AppSW-iTC publication.'
}
if (-not (Test-Path -LiteralPath $logoSource)) {
    throw "Missing AppSW-iTC logo: $logoSource"
}

$resolvedRepoRoot = [System.IO.Path]::GetFullPath($repoRoot)
$driveLetter = $resolvedRepoRoot.Substring(0, 1).ToLowerInvariant()
$repoRootWsl = "/mnt/$driveLetter" + $resolvedRepoRoot.Substring(2).Replace('\', '/')
& wsl.exe --cd $repoRootWsl make cpp-target
if ($LASTEXITCODE -ne 0) {
    throw "NIAP transform build failed with exit code $LASTEXITCODE."
}

if (Test-Path -LiteralPath $workDirectory) {
    Remove-Item -LiteralPath $workDirectory -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $renderDirectory, $profileDirectory | Out-Null
Copy-Item -LiteralPath (Join-Path $generatedOutput 'images') -Destination $renderDirectory -Recurse
Copy-Item -LiteralPath $logoSource -Destination (Join-Path $renderDirectory 'images\appsw-itc-logo.png')

$logoMarkup = '<img src="images/appsw-itc-logo.png" alt="AppSW-iTC Logo" style="display:block; max-width:520px; width:70%; height:auto; margin:1.25rem auto 0.75rem auto;"/>'

$cpp = Get-Content -LiteralPath (Join-Path $generatedOutput 'application-release.html') -Raw -Encoding utf8
$cpp = Replace-RegexOnce -Text $cpp -Pattern '(<div class="center">)\s*(?:<br\s*/?>\s*){5}' -Evaluator {
    param($match)
    return $match.Groups[1].Value + $logoMarkup + '<br/>'
} -Label 'cPP cover'

$sd = Get-Content -LiteralPath (Join-Path $generatedOutput 'application-sd.html') -Raw -Encoding utf8
$sd = Replace-LiteralOnce -Text $sd -Search '<div style="text-align: center; margin-left: auto; margin-right: auto;">' -Replacement '<div style="text-align: center; margin-left: auto; margin-right: auto; page-break-after: always;">' -Label 'SD title-page container'
$sd = Replace-RegexOnce -Text $sd -Pattern '(Mandatory Technical Document</h1>)\s*(?:<br\s*/?>\s*){4}(?=<hr\s+width="50%")' -Evaluator {
    param($match)
    return $match.Groups[1].Value + $logoMarkup
} -Label 'SD cover'
$sd = Replace-LiteralOnce -Text $sd -Search 'National Information Assurance Partnership (NIAP)' -Replacement 'Application Software International Technical Community (AppSW-iTC)' -Label 'SD technical editor'
$sd = Replace-RegexOnce -Text $sd -Pattern 'This SD was developed with support from NIAP\s+Technical Community members, with representatives from industry, government\s+agencies, Common Criteria Test Laboratories, and members of academia\.' -Evaluator {
    return 'This SD was developed by the Application Software International Technical Community (AppSW-iTC), with representatives from industry, government agencies, Common Criteria Test Laboratories, and academia.'
} -Label 'SD acknowledgment'

foreach ($document in @(@{ Name = 'cPP'; Html = $cpp }, @{ Name = 'SD'; Html = $sd })) {
    if ($document.Html -match 'images/niaplogo\.png|alt="NIAP Logo"') {
        throw "$($document.Name) HTML unexpectedly contains NIAP logo markup."
    }
    if (([regex]::Matches($document.Html, 'id="toc"')).Count -ne 1) {
        throw "$($document.Name) HTML does not contain exactly one transform-generated table of contents."
    }
    if (([regex]::Matches($document.Html, 'images/appsw-itc-logo\.png')).Count -ne 1) {
        throw "$($document.Name) HTML does not contain exactly one AppSW-iTC logo."
    }
}

$cppHtml = Join-Path $renderDirectory 'application-release-review.html'
$sdHtml = Join-Path $renderDirectory 'application-sd-review.html'
Set-Content -LiteralPath $cppHtml -Value $cpp -Encoding utf8 -NoNewline
Set-Content -LiteralPath $sdHtml -Value $sd -Encoding utf8 -NoNewline

$outputPath = [System.IO.Path]::GetFullPath($OutputDirectory)
New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
$browser = Find-Browser
$cppPdf = Join-Path $outputPath 'cPP-Application-Software-v2.0-draft-review.pdf'
$sdPdf = Join-Path $outputPath 'SD-Application-Software-v2.0-draft-review.pdf'
Write-Pdf -Browser $browser -HtmlPath $cppHtml -PdfPath $cppPdf -ProfilePath (Join-Path $profileDirectory 'cpp')
Write-Pdf -Browser $browser -HtmlPath $sdHtml -PdfPath $sdPdf -ProfilePath (Join-Path $profileDirectory 'sd')

Get-Item -LiteralPath $cppPdf, $sdPdf | Select-Object Name, Length, LastWriteTime
