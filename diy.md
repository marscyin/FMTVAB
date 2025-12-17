#!/bin/bash
# 脚本运行于 src 目录下

echo "🚀 开始个性化定制..."

# --- 1. 修改应用名称 ---
if [ ! -z "$INPUT_APP_NAME" ]; then
    echo "🏷️ 修改应用名称为: $INPUT_APP_NAME"
    # 替换中文和默认资源中的名称
    find app/src/main/res/values* -name "strings.xml" -exec sed -i "s/>FongMi</>$INPUT_APP_NAME</g" {} +
fi

# --- 2. 修改应用包名 (Application ID) ---
if [ ! -z "$INPUT_APP_ID" ]; then
    echo "📦 修改包名为: $INPUT_APP_ID"
    sed -i "s/applicationId \"com.fongmi.android.tv\"/applicationId \"$INPUT_APP_ID\"/g" app/build.gradle
fi

# --- 3. 替换应用图标 ---
# 假设你在主仓库放了 icon.png
if [ -f "../icon.png" ]; then
    echo "🎨 正在替换多分辨率图标..."
    # 定义所有图标路径
    ICONS=(
        "app/src/main/res/mipmap-hdpi"
        "app/src/main/res/mipmap-mdpi"
        "app/src/main/res/mipmap-xhdpi"
        "app/src/main/res/mipmap-xxhdpi"
        "app/src/main/res/mipmap-xxxhdpi"
    )
    for path in "${ICONS[@]}"; do
        mkdir -p "$path"
        cp ../icon.png "$path/ic_launcher.png"
        cp ../icon.png "$path/ic_launcher_round.png"
    done
fi

# --- 4. 修改版本号 (加上编译日期) ---
DATE=$(date +%Y%m%d)
echo "🔢 注入版本后缀: $DATE"
sed -i "s/versionName .*/versionName \"2.1.0-DIY-$DATE\"/g" app/build.gradle

# --- 5. 修改更新链接 (劫持更新检测) ---
# 将代码中的原作者仓库地址替换为你自己的，实现自建更新推送
MY_USER=$(echo "${{ github.repository }}" | cut -d'/' -f1)
MY_REPO=$(echo "${{ github.repository }}" | cut -d'/' -f2)
echo "🌐 劫持更新检测至: $MY_USER/$MY_REPO"
find app/src/main/java -name "Github.java" -exec sed -i "s/FongMi/$MY_USER/g" {} +
find app/src/main/java -name "Github.java" -exec sed -i "s/TV/$MY_REPO/g" {} +

# --- 6. 内置 API 地址 ---
if [ ! -z "$INPUT_API_URL" ]; then
    echo "🔗 内置 API 接口: $INPUT_API_URL"
    find app/src/main/java -name "ApiConfig.java" -exec sed -i "s|String url = \".*\";|String url = \"$INPUT_API_URL\";|g" {} +
fi

echo "✅ 定制化完成！"
