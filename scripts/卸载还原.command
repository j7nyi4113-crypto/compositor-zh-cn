#!/bin/bash
set -e
echo ""
echo "Compositor 汉化还原工具（删除 zh-Hans.lproj 并恢复 en + Base）"
echo ""
CANDS=("/Applications/Compositor.app" "$HOME/Downloads/Compositor.app" "$HOME/Desktop/Compositor.app")
APP=""
for c in "${CANDS[@]}"; do [ -d "$c" ] && { APP="$c"; break; }; done
if [ -z "$APP" ]; then
  read -erp "未找到 Compositor.app，请拖入路径后回车：  " inp
  APP="$(echo "$inp" | sed -E 's/^[[:space:]]*//;s/[[:space:]]*$//;s/\\//g')"
fi
[ -d "$APP/Contents/Resources" ] || { echo "✗ 无效应用。"; read _; exit 1; }
rm -rf "$APP/Contents/Resources/zh-Hans.lproj" 2>/dev/null || true
PLIST="$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Delete :CFBundleLocalizations" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations: string en" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations: string Base" "$PLIST"
codesign --force --deep -s - "$APP" >/dev/null 2>&1 || true
echo ""
echo "✅  已还原为英文版。请重启 Compositor。"
echo ""
read -rp "按 Enter 退出…" _bye
