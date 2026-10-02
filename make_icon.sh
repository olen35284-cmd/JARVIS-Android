#!/bin/bash
echo "=== 1/4 Создаю colors.xml ==="
mkdir -p app/src/main/res/values
cat > app/src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#050810</color>
    <color name="jarvis_blue">#00D9FF</color>
</resources>
EOF

echo "=== 2/4 Создаю иконку ==="
mkdir -p app/src/main/res/drawable
cat > app/src/main/res/drawable/ic_launcher_foreground.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">

    <path android:strokeColor="#00D9FF" android:strokeWidth="2" android:fillColor="#00000000"
        android:pathData="M54,22 A32,32 0 1,1 53.99,22 Z" />
    <path android:strokeColor="#00D9FF" android:strokeWidth="1.5" android:fillColor="#00000000"
        android:pathData="M54,30 A24,24 0 1,1 53.99,30 Z" />
    <path android:strokeColor="#00D9FF" android:strokeWidth="1" android:fillColor="#00000000"
        android:pathData="M54,38 A16,16 0 1,1 53.99,38 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M54,50 A4,4 0 1,1 53.99,50 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M54,18 A2,2 0 1,1 53.99,18 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M90,54 A2,2 0 1,1 89.99,54 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M54,90 A2,2 0 1,1 53.99,90 Z" />
    <path android:fillColor="#00D9FF" android:pathData="M18,54 A2,2 0 1,1 17.99,54 Z" />
</vector>
EOF

echo "=== 3/4 Создаю adaptive-icon ==="
mkdir -p app/src/main/res/mipmap-anydpi-v26
cat > app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
EOF

cp app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml

echo "=== 4/4 Проверяю манифест ==="
MANIFEST="app/src/main/AndroidManifest.xml"
if ! grep -q 'android:icon="@mipmap/ic_launcher"' "$MANIFEST"; then
    sed -i 's|<application|<application\n        android:icon="@mipmap/ic_launcher"\n        android:roundIcon="@mipmap/ic_launcher_round"|' "$MANIFEST"
    echo "Иконка добавлена в манифест"
else
    echo "Иконка уже в манифесте"
fi

echo ""
echo "=== ГОТОВО! Иконка создана ==="
ls -la app/src/main/res/mipmap-anydpi-v26/
ls -la app/src/main/res/drawable/ic_launcher_foreground.xml
echo "=== Теперь: git add . && git commit -m 'Add icon' && git push origin main ==="
