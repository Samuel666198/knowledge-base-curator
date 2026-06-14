param([string]$WikiPath = "wiki")

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

<<<<<<< HEAD
# 自动推导仓库根目录（脚本位于 tools/，父目录为仓库根）
$repoRoot = Split-Path $PSScriptRoot -Parent
$fullWikiPath = Join-Path $repoRoot $WikiPath
=======
$basePath = "E:\obsidian-codex"
$fullWikiPath = $basePath + "\" + $WikiPath
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
$bt = [char]96

if (-not (Test-Path $fullWikiPath)) {
    Write-Error ("Wiki 路径不存在: " + $fullWikiPath)
    exit 1
}

Write-Host ("## 链接健康检查 - " + (Get-Date -Format "yyyy-MM-dd")) -ForegroundColor Cyan
Write-Host ""

$brokenLinks = New-Object System.Collections.Generic.List[PSCustomObject]
$externalLinks = New-Object System.Collections.Generic.List[PSCustomObject]
$mdFiles = Get-ChildItem -Path $fullWikiPath -Recurse -Filter "*.md"

<<<<<<< HEAD
Write-Host ("扫描 " + $mdFiles.Count + " 个 Markdown 文件...") -ForegroundColor Gray
Write-Host ""

foreach ($mdFile in $mdFiles) {
    $content = Get-Content -Path $mdFile.FullName -Encoding UTF8 -Raw
    $relativePath = $mdFile.FullName.Replace($repoRoot + "\", "")

    # 检测内部链接 [[文件名]]
    $wikiLinkPattern = '\[\[([^\]]+)\]\]'
    $wikiLinks = [regex]::Matches($content, $wikiLinkPattern)
    foreach ($link in $wikiLinks) {
        $linkTarget = $link.Groups[1].Value
        $linkClean = $linkTarget -replace '#.*$', ''
        if ([string]::IsNullOrWhiteSpace($linkClean)) { continue }
        if ($linkClean -notlike "*.md") { $linkClean += ".md" }
        $found = $false
        foreach ($w in $mdFiles) {
            if ($w.Name -eq $linkClean) { $found = $true; break }
        }
        if (-not $found) {
            $brokenLinks.Add([PSCustomObject]@{
                File = $relativePath
                Link = $linkTarget
                Type = "Wiki链接"
=======
foreach ($file in $mdFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)

    $cleaned = [regex]::Replace($content, "(?s)" + $bt + $bt + $bt + ".*?" + $bt + $bt + $bt, "")
    $cleaned = [regex]::Replace($cleaned, $bt + "[^" + $bt + "\n]*" + $bt, "")

    $internalRegex = "\[\[([^\[\]\n#\|]+?)(?:[#\|][^\[\]\n]*?)?\]\]"
    $internalMatches = [regex]::Matches($cleaned, $internalRegex)
    foreach ($m in $internalMatches) {
        $target = $m.Groups[1].Value.Trim()
        $p1 = $file.DirectoryName + "\" + $target + ".md"
        $p2 = $file.DirectoryName + "\" + $target
        $p3 = $fullWikiPath + "\" + $target + ".md"
        $p4 = $fullWikiPath + "\concepts\" + $target + ".md"
        $p5 = $fullWikiPath + "\sources\" + $target + ".md"
        $found = (Test-Path $p1) -or (Test-Path $p2) -or (Test-Path $p3) -or (Test-Path $p4) -or (Test-Path $p5)
        if (-not $found) {
            $brokenLinks.Add([PSCustomObject]@{
                File = $file.FullName.Replace($basePath + "\", "")
                Link = $target
                Type = "内部"
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
            })
        }
    }

<<<<<<< HEAD
    # 检测外部链接
    $extLinkPattern = '\[([^\]]*)\]\((https?://[^\)]+)\)'
    $extLinks = [regex]::Matches($content, $extLinkPattern)
    foreach ($link in $extLinks) {
        $externalLinks.Add([PSCustomObject]@{
            File = $relativePath
            Text = $link.Groups[1].Value
            Url = $link.Groups[2].Value
=======
    $fileUriRegex = "file:///([^\s\)\]\}\>]" + $bt + """]+)"
    $fileUriMatches = [regex]::Matches($cleaned, $fileUriRegex)
    foreach ($m in $fileUriMatches) {
        $raw = $m.Groups[1].Value
        try { $decoded = [System.Uri]::UnescapeDataString($raw) } catch { $decoded = $raw }
        $normalized = $decoded -replace "^/+","" -replace "/","\"
        if (-not (Test-Path $normalized)) {
            $brokenLinks.Add([PSCustomObject]@{
                File = $file.FullName.Replace($basePath + "\", "")
                Link = "file:///" + $raw
                Type = "本地文件"
            })
        }
    }

    $extRegex = "\[([^\]]+)\]\((https?://[^)]+)\)"
    $extMatches = [regex]::Matches($content, $extRegex)
    foreach ($m in $extMatches) {
        $externalLinks.Add([PSCustomObject]@{
            File = $file.FullName.Replace($basePath + "\", "")
            Text = $m.Groups[1].Value
            URL = $m.Groups[2].Value
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
        })
    }
}

<<<<<<< HEAD
Write-Host "### 死链检测结果" -ForegroundColor Cyan
if ($brokenLinks.Count -eq 0) {
    Write-Host "✓ 未发现死链" -ForegroundColor Green
} else {
    Write-Host ("发现 " + $brokenLinks.Count + " 个死链:") -ForegroundColor Red
    Write-Host "| 文件 | 链接 | 类型 |"
    Write-Host "|------|------|------|"
    foreach ($bl in $brokenLinks) {
        Write-Host ("| " + $bl.File + " | " + $bl.Link + " | " + $bl.Type + " |")
=======
$uniqueBroken = @()
$seenBroken = @{}
foreach ($x in $brokenLinks) {
    $key = $x.File + "||" + $x.Link
    if (-not $seenBroken.ContainsKey($key)) {
        $seenBroken[$key] = $true
        $uniqueBroken += $x
    }
}

$uniqueExt = @()
$seenExt = @{}
foreach ($x in $externalLinks) {
    if (-not $seenExt.ContainsKey($x.URL)) {
        $seenExt[$x.URL] = $true
        $uniqueExt += $x
    }
}

if ($uniqueBroken.Count -eq 0) {
    Write-Host "### 内部链接 OK - 全部正常" -ForegroundColor Green
} else {
    Write-Host ("### 内部链接 FAIL - 发现 " + $uniqueBroken.Count + " 个死链") -ForegroundColor Red
    Write-Host ""
    Write-Host "| 文件 | 失效链接 | 类型 |"
    Write-Host "|------|---------|------|"
    foreach ($link in $uniqueBroken) {
        Write-Host ("| " + $link.File + " | " + $link.Link + " | " + $link.Type + " |") -ForegroundColor Yellow
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
    }
}

Write-Host ""
<<<<<<< HEAD
Write-Host "### 外部链接汇总" -ForegroundColor Cyan
if ($externalLinks.Count -eq 0) {
    Write-Host "无外部链接" -ForegroundColor Gray
} else {
    Write-Host ("共 " + $externalLinks.Count + " 个外部链接:") -ForegroundColor Yellow
    Write-Host "| 文件 | 文字 | URL |"
    Write-Host "|------|------|-----|"
    foreach ($el in $externalLinks) {
        Write-Host ("| " + $el.File + " | " + $el.Text + " | " + $el.Url + " |")
=======
Write-Host "### 外部链接" -ForegroundColor Cyan
Write-Host ""
if ($uniqueExt.Count -eq 0) {
    Write-Host "无外部链接" -ForegroundColor Gray
} else {
    Write-Host ("共 " + $uniqueExt.Count + " 个外部链接, 建议定期验证可用性") -ForegroundColor White
    Write-Host ""
    Write-Host "| 文件 | 链接文本 | URL |"
    Write-Host "|------|---------|-----|"
    $shown = 0
    foreach ($link in $uniqueExt) {
        if ($shown -lt 20) {
            Write-Host ("| " + $link.File + " | " + $link.Text + " | " + $link.URL + " |")
        }
        $shown++
    }
    if ($uniqueExt.Count -gt 20) {
        Write-Host ""
        Write-Host ("... 还有 " + ($uniqueExt.Count - 20) + " 个链接未显示") -ForegroundColor Gray
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
    }
}

Write-Host ""
<<<<<<< HEAD
Write-Host ("### 统计")
Write-Host ("- 扫描文件: " + $mdFiles.Count)
Write-Host ("- 死链: " + $brokenLinks.Count)
Write-Host ("- 外部链接: " + $externalLinks.Count)
=======
Write-Host "## 汇总" -ForegroundColor Cyan
Write-Host ("- 扫描文件数: " + $mdFiles.Count) -ForegroundColor White
Write-Host ("- 死链数: " + $uniqueBroken.Count) -ForegroundColor $(if ($uniqueBroken.Count -eq 0) { "Green" } else { "Red" })
Write-Host ("- 外部链接: " + $uniqueExt.Count) -ForegroundColor White

if ($uniqueBroken.Count -gt 0) { exit 1 }
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
