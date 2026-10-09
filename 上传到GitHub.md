# 🚀 把本仓库推到你的 GitHub（5 步复制粘贴就行）

> 前提：你已在本机登录过 GitHub（`gh auth login` / SSH Key / 或 HTTPS + token 任一都可以）。
> 如果是第一次用 GitHub，先去 https://github.com/new 创建个仓库：
>   - 仓库名：`compositor汉化版-通用`
>   - 选 **Public**（想分享给别人就公开）或 **Private**
>   - ⚠️ **不要** 勾选「Add a README」「Add .gitignore」「Choose a license」，保持空仓库。

## 方式 A · 命令行上传（最快，推荐）

打开 macOS「终端.app」或 iTerm2，依次复制粘贴执行（最后一行**请把 `<你的用户名>` 换成你自己的 GitHub 用户名**，比如 `git push -u origin main` 里的 origin 已经被第 2 行设好）：

```bash
cd "/Users/liu/Downloads/compositor汉化版-通用"
# 1. 把远程仓库地址改成你自己的（请替换 <你的用户名>，例如 git remote add origin https://github.com/JohnDoe/compositor汉化版-通用.git ）
git remote add origin "https://github.com/<你的用户名>/compositor汉化版-通用.git"

# 2. 设置分支名 main
git branch -M main

# 3. 推送本地上传
git push -u origin main
```

> 💡 如果要求输入 GitHub 密码，**不要输入登录密码**！请用「Personal Access Token」：
>   打开 https://github.com/settings/tokens → Generate new token (classic) →
>   勾选 **repo**、**workflow**、**delete_repo** → 生成后复制到「密码」处粘贴即可。
>
> 💡 如果你之前用 SSH 的方式：把 remote URL 换成 `git@github.com:<你的用户名>/compositor汉化版-通用.git` 即可。

## 方式 B · 还没建仓库？一行代码连建带推（已登录 gh 的话）

```bash
cd "/Users/liu/Downloads/compositor汉化版-通用"
gh repo create "compositor汉化版-通用" --public --description "Compositor 1.4.7 简体中文语言包 · 通用兼容所有版本（一键汉化脚本 + 源码补丁）" --source=. --remote=origin --push
```

就这么两行了。

## 方式 C · 纯网页上传（不用命令行）

1. 打开 https://github.com/new
2. Repository name 填 `compositor汉化版-通用`，选择 **Public**，
   **不要** 勾 README / .gitignore / License，点击 **Create repository**。
3. 跳到下一页，在「Quick setup — if you’ve done this kind of thing before」下面
   点 **uploading an existing file** 链接。
4. 打开 Finder 进入 `/Users/liu/Downloads/compositor汉化版-通用/`，
   把里面所有文件（README.md、.gitignore、LICENSE、resources/、scripts/、source-patches/）一次性拖进去。
5. 页面底部点 **Commit changes**。
6. 完成！在浏览器地址栏就可以拿到仓库 URL 发给朋友了。

---

推完以后，把本目录里的 `README.md` 顶部会自动变成你仓库的首页；
如果要改翻译，直接编辑 `resources/zh-Hans.lproj/Localizable.strings` 提交 commit 即可。

祝顺利！
