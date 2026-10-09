//
//  LocalizationHelpers.swift
//  Compositor 1.4.7 简体中文本地化辅助
//
//  对 String-backed 枚举添加 localized 访问器，使其在 UI 中显示时
//  自动从 Localizable.strings 表查找对应翻译。
//

import SwiftUI
import AppKit

// MARK: - 通用枚举本地化

extension RawRepresentable where RawValue == String {
    /// 在 SwiftUI 中使用：Text(e.l) → 自动查找 Localizable.strings
    var l: LocalizedStringKey { LocalizedStringKey(rawValue) }

    /// 在 AppKit / Tooltip / Accessibility / UndoName / NSAlert 字符串拼接中使用
    var ns: String { NSLocalizedString(rawValue, bundle: .main, comment: "") }
}

// MARK: - String 辅助（便于把动态 String 包装成本地化的 LocalizedStringKey）

extension String {
    /// 将原始字符串包装为 LocalizedStringKey，使其通过 Localizable.strings 解析
    var l: LocalizedStringKey { LocalizedStringKey(self) }

    /// 便捷 NSLocalizedString 访问器
    var ns: String { NSLocalizedString(self, bundle: .main, comment: "") }
}

// MARK: - ForEach 中 Text($0.l) 的简写：Text($0.l)

extension StringProtocol {
    var l: LocalizedStringKey { LocalizedStringKey(String(self)) }
    var ns: String { NSLocalizedString(String(self), bundle: .main, comment: "") }
}

// MARK: - 公共本地化字符串拼接

/// 生成形如 "上次滤镜：高斯模糊" 的本地化描述字符串
public func LLastFilterTitle(_ rawName: String?) -> String {
    guard let rawName else { return "Last Filter".ns }
    return String(format: "%@：%@", "Last Filter: ".dropLast(2).ns, rawName.ns)
}

/// 生成形如 "删除 Drop Shadow" 的按钮标题
public func LDeleteEffectTitle(_ rawKind: String) -> String {
    return "Delete ".ns + rawKind.ns
}

/// 生成 "显示/隐藏 + 图层名称/效果名称" 的辅助方法
public func LToggleVisibleTitle(visible: Bool, name: String) -> String {
    return (visible ? "Hide " : "Show ").ns + name
}

/// 图层效果的 accessibility 标签
public func LEffectAccessibilityLabel(_ rawKind: String) -> String {
    rawKind.ns + " effect".ns
}
