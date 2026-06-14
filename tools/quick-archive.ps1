param(
    [Parameter(Mandatory=$true)][string]$ProjectPath,
    [string[]]$Exclude = @("node_modules", ".git", "__pycache__", "dist", "build", ".venv", "venv")
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

<<<<<<< HEAD
# 自动推导仓库根目录（脚本位于 tools/，父目录为仓库根）
$repoRoot = Split-Path $PSScriptRoot -Parent
$fullProjectPath = Join-Path $repoRoot $ProjectPath
=======
$basePath = "E:\obsidian-codex"
$fullProjectPath = $basePath + "\" + $ProjectPath
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68

if (-not (Test-Path $fullProjectPath)) {
    Write-Error ("项目路径不存在: " + $fullProjectPath)
    exit 1
}

$projectName = Split-Path $ProjectPath -Leaf
$yearMonth = Get-Date -Format "yyyyMM"
<<<<<<< HEAD
$archiveDir = Join-Path $repoRoot ("archive\" + (Get-Date).Year + "_tech\archives")
if (-not (Test-Path $archiveDir)) {
    New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
}
$archivePath = Join-Path $archiveDir ($projectName + "_" + $yearMonth + ".zip")

$actualExclude = @()
foreach ($x in $Exclude) {
    if (Test-Path (Join-Path $fullProjectPath $x)) { $actualExclude += $x }
=======
$archiveDir = $basePath + "\archive\" + (Get-Date).Year + "_tech\archives"
if (-not (Test-Path $archiveDir)) {
    New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
}
$archivePath = $archiveDir + "\" + $projectName + "_" + $yearMonth + ".zip"

$actualExclude = @()
foreach ($x in $Exclude) {
    if (Test-Path ($fullProjectPath + "\" + $x)) { $actualExclude += $x }
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
}

Write-Host "## 快速打包确认清单" -ForegroundColor Cyan
Write-Host ""
Write-Host ("项目路径: " + $ProjectPath)
Write-Host ("项目名: " + $projectName)
Write-Host ("打包路径: " + $archivePath)
Write-Host ("排除项: " + ($actualExclude -join ", "))

$sensitivePatterns = @("*.key", "*.pem", "*.env", "*credentials*.json", "*secrets*.json")
$sensitiveFiles = New-Object System.Collections.Generic.List[string]
foreach ($pattern in $sensitivePatterns) {
    Get-ChildItem -Path $fullProjectPath -Recurse -Filter $pattern -ErrorAction SilentlyContinue | ForEach-Object {
<<<<<<< HEAD
        $sensitiveFiles.Add($_.FullName.Replace($repoRoot + "\", ""))
=======
        $sensitiveFiles.Add($_.FullName.Replace($basePath + "\", ""))
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
    }
}
if ($sensitiveFiles.Count -gt 0) {
    Write-Host ""
    Write-Host ("[警告] 检测到 " + $sensitiveFiles.Count + " 个敏感文件:") -ForegroundColor Red
    foreach ($f in $sensitiveFiles) {
        Write-Host ("  - " + $f) -ForegroundColor Yellow
    }
    Write-Host ""
<<<<<<< HEAD
    Write-Host "建议打包前移除敏感文件，或确认已脱敏" -ForegroundColor Yellow
=======
    Write-Host "建议打包前移除敏感文件, 或确认已脱敏" -ForegroundColor Yellow
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
}

Write-Host ""
Write-Host "### 执行前检查" -ForegroundColor Cyan
Write-Host "- [ ] 已提取核心 concept 到 wiki/concepts/"
Write-Host "- [ ] 已确认无敏感信息或已脱敏"
Write-Host "- [ ] 确认原始项目可归档"
Write-Host ""
Write-Host "是否执行打包? (y/n)" -ForegroundColor Red -NoNewline
$confirm = Read-Host
if ($confirm -ne "y") {
    Write-Host "已取消" -ForegroundColor Gray
    exit 0
}

try {
    if (Test-Path $archivePath) { Remove-Item $archivePath -Force }
    if ($actualExclude.Count -gt 0) {
<<<<<<< HEAD
        Write-Host ("[提示] PowerShell Compress-Archive 不支持细粒度排除，以下目录不会被自动跳过:") -ForegroundColor Yellow
        foreach ($ex in $actualExclude) { Write-Host ("  - " + $ex) -ForegroundColor Yellow }
        Write-Host "[提示] 如需排除，请手动清理后再执行" -ForegroundColor Yellow
=======
        Write-Host ("[提示] PowerShell Compress-Archive 不支持细粒度排除, 以下目录不会被自动跳过:") -ForegroundColor Yellow
        foreach ($ex in $actualExclude) { Write-Host ("  - " + $ex) -ForegroundColor Yellow }
        Write-Host "[提示] 如需排除, 请手动清理后再执行" -ForegroundColor Yellow
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
    }
    Compress-Archive -Path ($fullProjectPath + "\*") -DestinationPath $archivePath -CompressionLevel Optimal
    $zipSize = (Get-Item $archivePath).Length / 1KB
    Write-Host ""
    Write-Host "[成功] 打包完成" -ForegroundColor Green
    Write-Host ("- 路径: " + $archivePath) -ForegroundColor White
    Write-Host ("- 大小: " + [math]::Round($zipSize, 2) + " KB") -ForegroundColor White
} catch {
    Write-Error ("打包失败: " + $_)
    exit 1
}
