# 🇨🇳 Compositor 汉化版 · 通用

> **基于 Compositor 1.4.7 原版工程开发的简体中文语言包与一键注入脚本**。
> 语言包**向后 + 向前兼容所有已发布的 Compositor 版本**（1.4.x / 1.5+ 都可直接套用），
> 缺失的字符串会自动回退到官方英文界面，不会出现空白或问号。

本仓库是 macOS 开源图像编辑器 [**Compositor**](https://robbietilton.com/compositor)（Robbie Tilton 出品，免费/开源）
的 **简体中文汉化工程**，不打包 / 重分发原版 `.app`，只提供：

| 目录 | 作用 |
|------|------|
| [resources/zh-Hans.lproj](resources/zh-Hans.lproj) | 简体中文语言包（Localizable.strings + InfoPlist.strings，共 **852 键**） |
| [resources/en.lproj](resources/en.lproj) | 英文基底语言包（与 zh-Hans 键名 1:1 对应，作为缺失回退源） |
| [scripts/一键汉化.command](scripts/一键汉化.command) | **双击即用**的安装脚本，自动搜索本机的 `Compositor.app` → 复制语言包 → 修改 Info.plist → ad-hoc 重新签名（Gatekeeper 可过）。 |
| [scripts/卸载还原.command](scripts/卸载还原.command) | 一键还原为英文默认界面。 |
| [source-patches/](source-patches) | 给**自己编译 Compositor 源码**的朋友：已知区域补丁、枚举本地化扩展、AppKit 混合模式菜单的中文显示修正。 |

---

## ⚡️ 10 秒上手（推荐）

1. **先装原版**：从官网 <https://robbietilton.com/compositor> 或 [GitHub Releases](https://github.com/robbietilton/Compositor/releases) 下载 Compositor，
   把它拖到「应用程序」文件夹。
2. **下载本仓库**：点击右侧绿色 **Code → Download ZIP**，解压到任意目录。
3. **双击 `scripts/一键汉化.command`**：
   - 首次 macOS 提示「无法打开，因无法验证开发者」时，**右键该文件 → 打开**即可。
   - 找不到应用时会提示你把 Compositor.app 拖进终端窗口（也支持从挂载的 DMG 里直接汉化）。
   - 脚本自动做 4 件事：
     ① 备份旧语言资源 → ② 复制 `zh-Hans.lproj + en.lproj` → ③ Info.plist 注册简体中文 → ④ `codesign --deep -s -` 重新签名。
4. **完全退出 Compositor 再重新打开** 就是中文界面。
   - 若系统语言不是中文、仍显示英文时：
     `系统设置 → 通用 → 语言与地区 →「应用」标签 → ＋ → 选择 Compositor → 首选语言「简体中文」`。

卸载 → 双击 `scripts/卸载还原.command` 或手动删除
`/Applications/Compositor.app/Contents/Resources/zh-Hans.lproj`。

---

## 🌐 汉化覆盖范围（852 键 · 核心 UI 100%）

| 区块 | 举例 |
|------|------|
| **主菜单** | Compositor / 文件 / 编辑 / 选择 / 图像 / 滤镜 / 图层 / 视图 / 窗口（含撤销动态名 `撤销 Gaussian Blur`、`重做 色阶` 等） |
| **工具栏** | 画笔、橡皮擦、渐变、裁剪、套索、魔棒、选框、仿制图章、污点修复、对象选择、文字、形状、吸管、抓手、缩放、Quick Mask、Eye Dropper、… |
| **图层面板** | 混合模式（正常/正片叠底/叠加/柔光/强光/差值/…全部 27 种）、图层效果（投影/内阴影/外发光/内发光/斜面浮雕/光泽/颜色叠加/渐变叠加/描边）、混合颜色带、剪贴蒙版、文件夹组、图层蒙版、删除 / 重命名 / 可见性 / 锁定 / 不透明度 / 填充 |
| **调整 & 滤镜面板** | 色阶 / 曲线 / 色相饱和度 / 颜色平衡 / 曝光 / 渐变映射 / 高斯模糊 / 动感模糊 / USM 锐化 / 颗粒 / 杂色 / 抖动（Atkinson / Floyd-Steinberg / Bayer 2~8x8 / 半色调网点 / 线条 / Mac 图案 / ASCII / CRT 扫描线 等）/ 暗角 / 镜头畸变 / 内容识别填充 / 液化 / … |
| **Camera Raw 全套** | 基本 / 色调曲线 / 细节（锐化 / 减少杂色） / HSL / 颜色混合器 / 颜色分级（阴影 / 中间调 / 高光 三轮） / 光学（色差 / 镜头配置文件校正） / 几何变换 / 校准（处理版本 2/3/4/5/6 + 红/绿/蓝原色）/ 颗粒 + 暗角（样式 / 中点 / 圆度 / 羽化 / 高光优先） |
| **对话框** | 新建画布 / 图像大小 / 画布大小 / 修剪 / JPEG/PNG 导出 / 网格设置 / 键盘快捷键 / 颜色范围 / PSD 导入转换 / RAW 显影 |
| **枚举显示** | Dither / Gradient / Shape / Smudge & Liquify Mode / Wand / Selection Mode / Filter / AdjustmentKind / Camera Raw 所有下拉项（不再出现英文 rawValue） |
| **应用元数据** | Dock / Launchpad 名称：`Compositor 合成器`；版权本地化。 |

### 版本兼容性

- **基准**：`Compositor v1.4.7`（本仓库汉化的原始 commit 来源）。
- **兼容更高版本**：只要新 UI 的字符串 key 没有被汉化表覆盖，`Bundle.preferredLocalizations` 会自动 fallback 到 `en.lproj`，界面仍然完整。
  > 这也是本仓库叫「**通用**」的原因：旧版本不会因为缺少翻译而出错，新版本可以在不修改旧语言包的前提下继续使用。
- **兼容更低版本**：旧版中不存在的 key，被 macOS 本地化系统直接忽略。

---

## 🛠️ 自己编译 Compositor 的汉化步骤

如果您克隆了 [官方源码](https://github.com/robbietilton/Compositor) 并希望在 Xcode 里直接跑出中文版本：

1. 把 [resources/en.lproj](resources/en.lproj) 与 [resources/zh-Hans.lproj](resources/zh-Hans.lproj) 两个文件夹
   复制到 `Compositor/Resources/` 下（如果原版目录不同，放到任意 `Resources` 位置即可，Xcode 会自动按 lproj 识别）。
2. 打开 `Compositor.xcodeproj` → 选择 Project → Info → `Localizations` →
   点 **＋** 选择 `Chinese (Simplified)` → 勾选 `Localizable.strings` 与 `InfoPlist.strings` 两个文件。
   （或直接使用 [project.pbxproj.patch](source-patches/project.pbxproj.patch) 给 `knownRegions` 加一行 `zh-Hans`）。
3. 把 [source-patches/LocalizationHelpers.swift](source-patches/LocalizationHelpers.swift) 加到
   `Compositor` target 中。它会给所有 `RawRepresentable where RawValue == String` 的枚举（Dither / BlendMode / Gradient …）
   加上 `.l`（SwiftUI 用） 和 `.ns`（AppKit 拼接字符串用）属性。
4. UI 代码批量替换：
   ```swift
   Text(kind.rawValue)           → Text(kind.l)
   Button(mode.rawValue) { … }   → Button(mode.l) { … }
   "Foo " + x.rawValue           → "Foo ".ns + x.ns
   ```
5. 把 [source-patches/BlendModePicker.swift](source-patches/BlendModePicker.swift) 替换掉原版同名文件（原版本
   用英文标题做反向 enum 查找，会导致中文界面上改完混合模式无法保存 — 新版用 `representedObject` 存原始枚举，
   标题直接本地化显示）。
6. 选择 `Compositor` scheme，按 `⌘R` 运行即可得到一个真正的「原生中文版」Compositor。

---

## 🗂 仓库结构

```
compositor汉化版-通用/
├── README.md                          ← 你正在看的文件
├── LICENSE                            ← MIT（与上游 Compositor 一致）
├── .gitignore
│
├── resources/
│   ├── en.lproj/                      ← 英文键表（852 键，fallback 用）
│   │   ├─ Localizable.strings
│   │   └─ InfoPlist.strings
│   └── zh-Hans.lproj/                 ← 简体中文翻译（852 键 · 100% 完成）
│       ├─ Localizable.strings
│       └─ InfoPlist.strings
│
├── scripts/
│   ├── 一键汉化.command                ← ⭐ 双击即可给本机 Compositor.app 装中文
│   └── 卸载还原.command                ← 一键还原英文
│
└── source-patches/                    ← 给源码编译用户使用
    ├── LocalizationHelpers.swift
    ├── BlendModePicker.swift
    └── project.pbxproj.patch
```

---

## 📜 许可证 / 致谢

- 上游项目：<https://github.com/robbietilton/Compositor> © Robbie Tilton（[MIT 协议](LICENSE)）。
- 本仓库的语言包、脚本与补丁以 **MIT License** 发布，欢迎自由分发 / 二次修改 / 提交 PR。
- 本仓库**不重分发** Compositor.app：请始终从官方渠道下载原版，
  并通过本仓库附带的 `一键汉化.command` 注入语言资源。

---

## 🧩 常见问题

**Q：运行脚本时提示「已损坏，移到废纸篓」？**
A：macOS Gatekeeper 把下载的脚本标成 quarantine。执行 `xattr -dr com.apple.quarantine scripts/一键汉化.command` 或直接右键 → 打开即可。

**Q：汉化后仍显示英文？**
A：① 确认已经把 `Compositor.app` 从 DMG 拖到「应用程序」再汉化；② 到系统设置的「语言与地区 → 应用」里单独指定 Compositor 首选语言为简体中文。

**Q：升级 Compositor 后需要重新汉化吗？**
A：是的，每次升级会把旧 .app 整个替换掉，只要重新双击一次 `一键汉化.command` 即可（2 秒钟）。
   新版本多出的 UI 会自动显示为英文不影响使用，欢迎提 PR 补翻译。

**Q：能汉化 1.3.x / 1.5.x / 2.0 吗？**
A：可以，脚本不检查版本号；没有的翻译项会自动显示英文，**不会导致界面坏掉**。
