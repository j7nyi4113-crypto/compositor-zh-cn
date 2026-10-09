#!/bin/bash
# ============================================================
#  Compositor 汉化版 - 通用一键汉化脚本
#  仓库: https://github.com/<your-user>/compositor汉化版-通用
#  适用: 已发布的 Compositor.app（v1.x 所有版本 / 尤其 1.4.7）
# ============================================================
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
GREEN='\033[0;32m'; RED='\033[0;31m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; R='\033[0m'
[ -x "$0" ] || chmod +x "$0"
echo ""
echo "======================================================================"
echo "  Compositor 汉化版 - 通用一键汉化 (基于仓库语言包 v1.4.7)"
echo "======================================================================"
echo ""
APP=""
CANDS=(
  "/Applications/Compositor.app"
  "$HOME/Applications/Compositor.app"
  "$HOME/Downloads/Compositor.app"
  "$HOME/Desktop/Compositor.app"
)
for c in "${CANDS[@]}"; do [ -d "$c" ] && { APP="$c"; break; }; done
if [ -z "$APP" ]; then
  echo " 在常见位置 (/Applications、~/Desktop、~/Downloads) 未找到 Compositor.app。"
  echo " 请先去 https://robbietilton.com/compositor 下载最新版本并拖入应用程序。"
  echo " 也可以直接把 Compositor.app 拖入下方窗口后按回车："
  read -erp "  >  " inp
  APP="$(echo "$inp" | sed -E 's/^[[:space:]]*//;s/[[:space:]]*$//;s/\\//g')"
fi
[ -d "$APP/Contents/MacOS" ] || { echo -e "${RED}✗ 无效应用包：$APP${R}"; read -rp "回车退出…" _; exit 1; }
PLIST="$APP/Contents/Info.plist"
RES="$APP/Contents/Resources"
echo -e "${BLUE}[信息]${R} 应用路径   : $APP"
echo -e "${BLUE}[信息]${R} 版本号     : $(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$PLIST" 2>/dev/null || echo "未知")"
echo -e "${BLUE}[信息]${R} Bundle ID  : $(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$PLIST" 2>/dev/null || echo "未知")"

EN_SRC="$REPO_ROOT/resources/en.lproj"
ZH_SRC="$REPO_ROOT/resources/zh-Hans.lproj"
[ -d "$EN_SRC" ] || { echo -e "${RED}✗ 仓库中缺少 $EN_SRC${R}"; read _; exit 1; }
[ -d "$ZH_SRC" ] || { echo -e "${RED}✗ 仓库中缺少 $ZH_SRC${R}"; read _; exit 1; }

BAK="$RES/.compositor-zh-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BAK"
[ -d "$RES/zh-Hans.lproj" ] && cp -R "$RES/zh-Hans.lproj" "$BAK/zh-Hans.lproj.old" 2>/dev/null || true
touch "$BAK/.compositor-localization-backup"
echo -e "${BLUE}[备份]${R} $BAK"

echo ""
/usr/bin/ditto "$EN_SRC" "$RES/en.lproj"
/usr/bin/ditto "$ZH_SRC" "$RES/zh-Hans.lproj"
echo -e "${GREEN}[OK]${R} 已复制 en.lproj / zh-Hans.lproj 到应用内部。"

/usr/libexec/PlistBuddy -c "Delete :CFBundleLocalizations" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations: string en" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations: string zh-Hans" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :CFBundleLocalizations: string Base" "$PLIST"
echo -e "${GREEN}[OK]${R} Info.plist CFBundleLocalizations 已更新（zh-Hans + en + Base）。"

echo -e "${BLUE}[签名]${R} ad-hoc 重新签名应用以通过 Gatekeeper..."
if codesign --force --deep -s - "$APP" >/tmp/compositor_sign.log 2>&1; then
  echo -e "${GREEN}[OK]${R} 应用重新签名完成。"
else
  echo -e "${YELLOW}[!]${R} codesign 有告警，详情见 /tmp/compositor_sign.log"
  echo -e "${YELLOW}[!]${R} 大多数情况不影响运行。"
fi
touch "$APP"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP" >/dev/null 2>&1 || true

echo ""
echo "======================================================================"
echo -e "  ${GREEN}✅ 汉化安装完成！${R}"
echo "======================================================================"
echo "  下一步："
echo "   1. 在 Dock/Launchpad 中完全退出 Compositor，然后重新打开。"
echo "   2. 若系统语言非中文，仍显示英文时："
echo "        系统设置 → 通用 → 语言与地区 →「应用」标签 → ＋"
echo "        → 添加 Compositor → 首选语言设为「简体中文」。"
echo ""
echo "  想恢复英文时运行同目录下的「卸载还原.command」即可。"
echo ""
read -rp "按 Enter 退出…" _bye
exit 0
