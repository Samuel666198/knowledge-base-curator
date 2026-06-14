param(
    [int]$Days = 7,
    [string]$OutputPath = "wiki/pending.md"
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

<<<<<<< HEAD
# 自动推导仓库根目录（脚本位于 tools/，父目录为仓库根）
$repoRoot = Split-Path $PSScriptRoot -Parent
=======
$basePath = "E:\obsidian-codex"
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68

$items = New-Object System.Collections.Generic.List[PSCustomObject]

$scanDirs = @(
    "raw\articles",
    "raw\notes",
    "raw\video",
    "raw\assets",
    "projects"
)

$cutoff = (Get-Date).AddDays(-$Days)

foreach ($dir in $scanDirs) {
<<<<<<< HEAD
    $fullDir = Join-Path $repoRoot $dir
    if (-not (Test-Path $fullDir)) { continue }
    $files = Get-ChildItem -Path $fullDir -File | Where-Object { $_.LastWriteTime -ge $cutoff }
    foreach ($file in $files) {
        $relativePath = $file.FullName.Replace($repoRoot + "\", "")
        $items.Add([PSCustomObject]@{
            Type = $dir
            Name = $file.Name
            Path = $relativePath
            Modified = $file.LastWriteTime.ToString("yyyy-MM-dd")
=======
    $full = $basePath + "\" + $dir
    if (-not (Test-Path $full)) { continue }
    Get-ChildItem -Path $full -Recurse -File | Where-Object {
        $_.LastWriteTime -gt $cutoff
    } | ForEach-Object {
        $relativePath = $_.FullName.Replace($basePath + "\", "")
        $items.Add([PSCustomObject]@{
            Type = $dir
            Name = $_.Name
            Path = $relativePath
            Modified = $_.LastWriteTime.ToString("yyyy-MM-dd")
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
        })
    }
}

$report = "## 待处理清单 -- " + (Get-Date -Format "yyyy-MM-dd") + "`r`n`r`n"
$report += "> 自动生成 | 扫描范围: 最近 " + $Days + " 天`r`n`r`n"

if ($items.Count -eq 0) {
    $report += "### 无待处理项目`r`n"
    Write-Host "无待处理内容" -ForegroundColor Gray
} else {
    $grouped = $items | Group-Object Type
    foreach ($group in $grouped) {
        $report += "### " + $group.Name + " (" + $group.Count + " 项)`r`n`r`n"
        $report += "| 文件名 | 路径 | 修改日期 |`r`n"
        $report += "|--------|------|----------|`r`n"
        foreach ($item in $group.Group) {
            $report += "| " + $item.Name + " | " + $item.Path + " | " + $item.Modified + " |`r`n"
        }
        $report += "`r`n"
    }
    Write-Host ("共找到 " + $items.Count + " 项待处理内容") -ForegroundColor Cyan
}

<<<<<<< HEAD
[System.IO.File]::WriteAllText((Join-Path $repoRoot $OutputPath), $report, (New-Object System.Text.UTF8Encoding $true))
Write-Host ("清单已保存至: " + (Join-Path $repoRoot $OutputPath)) -ForegroundColor Green
=======
[System.IO.File]::WriteAllText($basePath + "\" + $OutputPath, $report, (New-Object System.Text.UTF8Encoding $true))
Write-Host ("清单已保存至: " + $OutputPath) -ForegroundColor Green
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
