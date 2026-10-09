import SwiftUI
import AppKit

struct BlendModePicker: NSViewRepresentable {
    let session: EditorSession
    func makeCoordinator() -> Coordinator { Coordinator(session: session) }
    func makeNSView(context: Context) -> NSPopUpButton {
        let button = NSPopUpButton(frame: .zero, pullsDown: false)
        // 按 Photoshop 的分组顺序排列：变暗 / 变亮 / 对比 / 差值 / 分量
        // 每组之间加分隔线，长列表保持可读性
        for (index, group) in LayerBlendMode.groups.enumerated() {
            if index > 0 { button.menu?.addItem(.separator()) }
            for mode in group {
                let item = NSMenuItem(title: mode.ns, action: nil, keyEquivalent: "")
                item.representedObject = mode
                button.menu?.addItem(item)
            }
        }
        button.menu?.delegate = context.coordinator
        button.target = context.coordinator
        button.action = #selector(Coordinator.choose(_:))
        button.setAccessibilityLabel("Blend mode".ns)
        // 与 SwiftUI 的按钮和菜单一致的胶囊外形（roundedControls 无法应用到这个 AppKit 弹层）
        button.borderShape = .capsule
        return button
    }
    func updateNSView(_ button: NSPopUpButton, context: Context) {
        button.isEnabled = session.canEditAppearance
        if !context.coordinator.tracking {
            let wanted = session.activeLayer?.blendMode ?? .normal
            if let item = button.itemArray.first(where: { ($0.representedObject as? LayerBlendMode) == wanted }) {
                button.select(item)
            }
        }
    }
    static func dismantleNSView(_ button: NSPopUpButton, coordinator: Coordinator) {
        if coordinator.tracking { coordinator.session.previewBlendMode(nil, for: nil) }
        button.menu?.delegate = nil
    }
    final class Coordinator: NSObject, NSMenuDelegate {
        let session: EditorSession
        var tracking = false
        private var layerID: UUID?
        private var highlightedMode: LayerBlendMode?
        init(session: EditorSession) { self.session = session }
        func menuWillOpen(_ menu: NSMenu) {
            tracking = true
            layerID = session.activeLayerID
            highlightedMode = nil
        }
        func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {
            // AppKit 在关闭菜单时会短暂报告没有高亮项。
            // 保持上一次预览，直到选择动作真正提交，
            // 这样画布不会在提交前闪回图层的旧模式。
            guard let mode = item?.representedObject as? LayerBlendMode else { return }
            highlightedMode = mode
            session.previewBlendMode(mode, for: layerID)
        }
        func menuDidClose(_ menu: NSMenu) {
            tracking = false
            // 菜单项的选中动作会在菜单关闭完毕后执行。
            // 下一轮再清理，让动作可以把预览替换为真正的提交模式；
            // 取消时则直接恢复原来的模式。
            DispatchQueue.main.async { [weak self] in
                guard let self, !self.tracking else { return }
                self.session.previewBlendMode(nil, for: nil)
            }
        }
        @objc func choose(_ button: NSPopUpButton) {
            guard session.activeLayerID == layerID,
                  let mode = highlightedMode ?? button.selectedItem?.representedObject as? LayerBlendMode else { return }
            session.setLayerBlendMode(mode)
            if let item = button.itemArray.first(where: { ($0.representedObject as? LayerBlendMode) == mode }) {
                button.select(item)
            }
            highlightedMode = nil
            session.refreshCanvasPreview?()
        }
    }
}
