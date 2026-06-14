param(
    [Parameter(Mandatory=$true)][string]$SourcePath,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

<<<<<<< HEAD
# 自动推导仓库根目录（脚本位于 tools/，父目录为仓库根）
$repoRoot = Split-Path $PSScriptRoot -Parent
$fullSourcePath = Join-Path $repoRoot $SourcePath
=======
$basePath = "E:\obsidian-codex"
$fullSourcePath = $basePath + "\" + $SourcePath
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68

if (-not (Test-Path $fullSourcePath)) {
    Write-Error ("源路径不存在: " + $fullSourcePath)
    exit 1
}

function Get-TargetDirectory {
    param([System.IO.FileInfo]$File)
    $imageExts = @(".png", ".jpg", ".jpeg", ".gif", ".bmp", ".webp", ".svg")
    if ($imageExts -contains $File.Extension.ToLower()) { return "raw\assets" }
    if ($File.Extension -eq ".md") {
        $content = [System.IO.File]::ReadAllText($File.FullName, [System.Text.Encoding]::UTF8)
        if ($content -match "视频|文字稿|字幕|transcript") { return "raw\video" }
        return "raw\articles"
    }
    return "raw\assets"
}

function New-StandardName {
    param([System.IO.FileInfo]$File)
    $date = $File.LastWriteTime.ToString("yyyy-MM-dd")
    $baseName = $File.BaseName -replace '[\\/:*?"<>|]', ''
    if ($baseName.Length -gt 30) { $baseName = $baseName.Substring(0, 30) }
    return $date + "-" + $baseName + $File.Extension
}

$files = Get-ChildItem -Path $fullSourcePath -File
Write-Host "## 批量移动/重命名预览" -ForegroundColor Cyan
Write-Host ""
Write-Host ("源路径: " + $SourcePath) -ForegroundColor Gray
Write-Host ""

$operations = New-Object System.Collections.Generic.List[PSCustomObject]
foreach ($file in $files) {
    $targetDir = Get-TargetDirectory $file
    $newName = New-StandardName $file
    $operations.Add([PSCustomObject]@{
        Original = $file.Name
        TargetDir = $targetDir
        NewName = $newName
        FullPath = $file.FullName
    })
}

Write-Host ("| 原文件名 | 目标目录 | 新文件名 |")
Write-Host ("|----------|---------|----------|")
foreach ($op in $operations) {
    Write-Host ("| " + $op.Original + " | " + $op.TargetDir + " | " + $op.NewName + " |")
}
Write-Host ""
Write-Host ("共 " + $operations.Count + " 个文件") -ForegroundColor Yellow

if ($DryRun) {
    Write-Host ""
    Write-Host "[DryRun 模式] 未执行任何操作" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "是否执行移动? (y/n)" -ForegroundColor Red -NoNewline
$confirm = Read-Host
if ($confirm -ne "y") {
    Write-Host "已取消" -ForegroundColor Gray
    exit 0
}

$success = 0
$failed = 0
foreach ($op in $operations) {
    try {
<<<<<<< HEAD
        $targetDir = Join-Path $repoRoot $op.TargetDir
        if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
        Move-Item -Path $op.FullPath -Destination (Join-Path $targetDir $op.NewName) -Force
=======
        $targetDir = $basePath + "\" + $op.TargetDir
        if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
        Move-Item -Path $op.FullPath -Destination ($targetDir + "\" + $op.NewName) -Force
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
        Write-Host ("[OK] " + $op.Original + " -> " + $op.TargetDir) -ForegroundColor Green
        $success++
    } catch {
        Write-Host ("[FAIL] " + $op.Original + ": " + $_) -ForegroundColor Red
        $failed++
    }
}
Write-Host ""
Write-Host ("完成: " + $success + " 成功, " + $failed + " 失败") -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Yellow" })
