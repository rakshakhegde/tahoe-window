import SwiftUI
import AppKit

@main
struct TahoeLiquidGlassDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(.clear)
                .frame(minWidth: 220, minHeight: 80)
                .modifier(TahoeWindowConfigurator())
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 220, height: 80)
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            // Dark, translucent container to match Liquid Glass appearance.
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.black.opacity(0.55))
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.white.opacity(0.14), lineWidth: 0.5)
                )

            Text("25%")
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundStyle(.white.opacity(0.94))
                .padding(8)
        }
        .padding(10)
        .compositingGroup()
    }
}

/// Removes titlebar chrome and tunes the NSWindow for a glass-like floating panel look.
struct TahoeWindowConfigurator: ViewModifier {
    func body(content: Content) -> some View {
        content.background(WindowAccessor { window in
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.styleMask.insert(.fullSizeContentView)
            window.isOpaque = false
            window.backgroundColor = .clear
            window.hasShadow = true

            window.standardWindowButton(.closeButton)?.isHidden = true
            window.standardWindowButton(.miniaturizeButton)?.isHidden = true
            window.standardWindowButton(.zoomButton)?.isHidden = true
        })
    }
}

private struct WindowAccessor: NSViewRepresentable {
    let onResolve: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        DispatchQueue.main.async {
            if let window = view.window {
                onResolve(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            if let window = nsView.window {
                onResolve(window)
            }
        }
    }
}
