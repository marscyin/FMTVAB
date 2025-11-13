#!/bin/bash
# 只改应用名，别的全部不动
APP_NAME="光之芙蓉"

# ① strings.xml 里的 app_name
find . -name "strings.xml" -exec sed -i "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">$APP_NAME<\/string>/g" {} +

# ② AndroidManifest.xml 桌面 banner 文字（TV 启动器下方标题）
sed -i "s/android:label=\"@string\/app_name\"/android:label=\"$APP_NAME\"/" app/src/main/AndroidManifest.xml

echo "✅ 应用名已改为：$APP_NAME"
