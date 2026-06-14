param(
    [Parameter(Mandatory=$true)][string]$Path,
    [string]$OutputDir = "raw/articles",
    [string]$OutputFile = "",
    [switch]$Overwrite
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

<<<<<<< HEAD
# 自动推导仓库根目录（脚本位于 tools/，父目录为仓库根）
$repoRoot = Split-Path $PSScriptRoot -Parent
$pyScript = Join-Path $PSScriptRoot "_convert_doc.py"

# 尝试在仓库根目录或脚本同目录下寻找 .venv
$venvPython = Join-Path $repoRoot ".venv\Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
    # 也检查脚本同级的 .venv
    $altVenv = Join-Path $PSScriptRoot ".venv\Scripts\python.exe"
    if (Test-Path $altVenv) {
        $venvPython = $altVenv
    } else {
        Write-Warning "未找到 .venv 的 Python 解释器，尝试使用系统 python"
        $venvPython = "python"
    }
}

$resolvedInput = $null
if (Test-Path -LiteralPath $Path -PathType Leaf) {
    $resolvedInput = Resolve-Path -LiteralPath $Path
} elseif (Test-Path (Join-Path $repoRoot $Path)) {
    $resolvedInput = Resolve-Path -LiteralPath (Join-Path $repoRoot $Path)
} else {
    Write-Error ("找不到输入文件: " + $Path)
    exit 1
=======
$basePath = "E:\obsidian-codex"
$venvPython = $basePath + "\.venv\Scripts\python.exe"
$toolsDir = "C:\Users\ROG\.trae-cn\skills\knowledge-base-curator\tools"
$pyScript = $toolsDir + "\_convert_doc.py"

if (-not (Test-Path $venvPython)) {
    Write-Error ("找不到 .venv 的 Python 解释器: " + $venvPython)
    exit 1
}

$resolvedInput = (Resolve-Path -LiteralPath $Path -ErrorAction SilentlyContinue).Path
if (-not $resolvedInput) {
    if (Test-Path (Join-Path $basePath $Path)) {
        $resolvedInput = Resolve-Path -LiteralPath (Join-Path $basePath $Path)
    } else {
        Write-Error ("找不到输入文件: " + $Path)
        exit 1
    }
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
}

$fileInfo = Get-Item $resolvedInput
$extension = $fileInfo.Extension.ToLower()

$supported = @(".pdf", ".pptx", ".docx", ".xlsx", ".xls", ".html", ".htm", ".csv", ".json", ".xml", ".epub", ".txt", ".md", ".png", ".jpg", ".jpeg", ".bmp", ".gif", ".tif", ".tiff")

if ($supported -notcontains $extension) {
    Write-Error ("暂不支持的格式: " + $extension)
    exit 1
}

if ($OutputFile -eq "") { $OutputFile = $fileInfo.BaseName + ".md" }

<<<<<<< HEAD
$outputDirPath = Join-Path $repoRoot $OutputDir
=======
$outputDirPath = Join-Path $basePath $OutputDir
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
if (-not (Test-Path $outputDirPath)) { New-Item -ItemType Directory -Path $outputDirPath -Force | Out-Null }
$fullOutput = Join-Path $outputDirPath $OutputFile

if ((Test-Path $fullOutput) -and (-not $Overwrite)) {
    Write-Warning ("输出文件已存在: " + $fullOutput)
    Write-Host "使用 -Overwrite 参数强制覆盖" -ForegroundColor Yellow
    exit 0
}

Write-Host "========================================" -ForegroundColor Cyan
<<<<<<< HEAD
Write-Host "  文件转换" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ("输入: " + $resolvedInput)
Write-Host ("输出: " + $fullOutput)
Write-Host ("格式: " + $extension)
Write-Host ""

if ($extension -in @(".png", ".jpg", ".jpeg", ".bmp", ".gif", ".tif", ".tiff")) {
    Write-Host "[图片模式] 使用 markitdown 处理..." -ForegroundColor Yellow
} else {
    Write-Host "[文档模式] 使用 markitdown 处理..." -ForegroundColor Yellow
}

try {
    $tempOutput = [System.IO.Path]::GetTempFileName() + ".md"
    $argsArray = @($pyScript, $resolvedInput, $tempOutput)

    if ($venvPython -eq "python") {
        $process = Start-Process -FilePath "python" -ArgumentList $argsArray -NoNewWindow -Wait -PassThru
    } else {
        $process = Start-Process -FilePath $venvPython -ArgumentList $argsArray -NoNewWindow -Wait -PassThru
    }

    if ($process.ExitCode -ne 0 -and $process.ExitCode -ne $null) {
        Write-Error "转换失败，退出码: $($process.ExitCode)"
        exit 1
    }

    if (Test-Path $tempOutput) {
        Move-Item -Path $tempOutput -Destination $fullOutput -Force
        $charCount = (Get-Item $fullOutput).Length
        Write-Host ""
        Write-Host "[成功] 转换完成" -ForegroundColor Green
        Write-Host ("输出: " + $fullOutput) -ForegroundColor White
        Write-Host ("大小: " + $charCount + " 字符") -ForegroundColor White
    } else {
        Write-Error "未能生成输出文件"
        exit 1
    }
} catch {
    Write-Error ("转换出错: " + $_)
    if (Test-Path $tempOutput) { Remove-Item $tempOutput -Force -ErrorAction SilentlyContinue }
    exit 1
=======
Write-Host (" 文件: " + $fileInfo.Name) -ForegroundColor White
Write-Host (" 格式: " + $extension) -ForegroundColor White
Write-Host (" 输出: " + $OutputDir + "/" + $OutputFile) -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$tempId = Get-Date -Format "yyyyMMdd_HHmmss_ffff"
$tempOutput = Join-Path $env:TEMP ("markitdown_" + $tempId + ".md")
$tempStdout = Join-Path $env:TEMP ("markitdown_" + $tempId + ".stdout")
$tempStderr = Join-Path $env:TEMP ("markitdown_" + $tempId + ".stderr")

try {
    Write-Host "[转换中] 使用 markitdown 处理..." -ForegroundColor Gray

    $argsArray = @($pyScript, $resolvedInput, $tempOutput)
    $process = Start-Process -FilePath $venvPython -ArgumentList $argsArray -Wait -NoNewWindow -PassThru -RedirectStandardOutput $tempStdout -RedirectStandardError $tempStderr

    $stdout = ""
    $stderr = ""
    if (Test-Path $tempStdout) { $stdout = [System.IO.File]::ReadAllText($tempStdout, [System.Text.Encoding]::UTF8) }
    if (Test-Path $tempStderr) { $stderr = [System.IO.File]::ReadAllText($tempStderr, [System.Text.Encoding]::UTF8) }

    if ($process.ExitCode -ne 0 -or -not (Test-Path $tempOutput)) {
        if ($stdout -ne "") { Write-Host ("stdout: " + $stdout) -ForegroundColor Gray }
        if ($stderr -ne "") { Write-Host ("stderr: " + $stderr) -ForegroundColor Red }
        Write-Error ("转换失败 (exit code: " + $process.ExitCode + ")")
        exit 1
    }

    Write-Host ("[完成] " + $stdout) -ForegroundColor Green
    Copy-Item -Path $tempOutput -Destination $fullOutput -Force

    $content = [System.IO.File]::ReadAllText($tempOutput, [System.Text.Encoding]::UTF8)
    $lineCount = ($content -split "`r?`n").Count
    $charCount = $content.Length

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host (" 输出文件: " + $OutputDir + "/" + $OutputFile) -ForegroundColor Green
    Write-Host (" 行数: " + $lineCount) -ForegroundColor White
    Write-Host (" 字符数: " + $charCount) -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Cyan
} catch {
    Write-Error ("转换过程出错: " + $_)
    exit 1
} finally {
    if (Test-Path $tempOutput) { Remove-Item $tempOutput -ErrorAction SilentlyContinue }
    if (Test-Path $tempStdout) { Remove-Item $tempStdout -ErrorAction SilentlyContinue }
    if (Test-Path $tempStderr) { Remove-Item $tempStderr -ErrorAction SilentlyContinue }
>>>>>>> 07964905b73a354e8878854a2d94467b215e7a68
}
