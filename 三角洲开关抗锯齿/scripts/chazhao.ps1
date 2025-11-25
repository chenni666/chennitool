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

if ($found) {
    # 文件存在，退出码 0
    exit 0

} else {
    # 文件不存在，输出 1 
    exit 1
}

