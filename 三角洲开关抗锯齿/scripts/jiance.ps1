# 搜索 GameUserSettings.ini 文件
# 在所有驱动器中搜索可能的路径

$found = $null

# 获取所有可用驱动器
$drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 }

foreach ($drive in $drives) {
    $driveRoot = $drive.Root
    
    # 搜索路径模式：*WeGameApps*\rail_apps\DeltaForce*\DeltaForce\Saved\Config\WindowsClient\GameUserSettings.ini
    $searchPattern = Join-Path $driveRoot "*WeGameApps*\rail_apps\DeltaForce*\DeltaForce\Saved\Config\WindowsClient\GameUserSettings.ini"
    
    # 尝试查找文件
    $result = Get-ChildItem -Path $searchPattern -ErrorAction SilentlyContinue
    
    if ($result) {
        $found = $result
        break
    }
}

# 如果找到文件，检查是否包含指定文本
if ($found) {
    try {
        # 读取文件内容
        $content = Get-Content -Path $found.FullName -Raw -ErrorAction Stop
        
        # 检查是否同时包含两行文本
        $hasScalabilityGroups = $content -match '\[ScalabilityGroups\]'
        $hasAntiAliasingQuality = $content -match 'sg\.AntiAliasingQuality=0'
        
        # 如果两行都存在，返回0；否则返回1
        if ($hasScalabilityGroups -and $hasAntiAliasingQuality) {
            exit 0
        } else {
            exit 1
        }
    } catch {
        # 如果读取文件失败，返回1
        exit 1
    }
} else {
    # 如果没找到文件，返回1
    exit 2
}

