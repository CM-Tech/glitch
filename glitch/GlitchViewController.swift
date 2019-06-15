import Cocoa

class GlitchViewController: NSViewController {
    @IBOutlet var imageView: PictureView!

    let filters = Filter.all

    var currentFilterIndex: Int = 0 {
        didSet {
            update()
        }
    }

    var enabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
        currentFilterIndex = 0
    }

    func update() {
        imageView.enabled = enabled
        imageView.currentFilterIndex = currentFilterIndex
        imageView.setNeedsDisplay(imageView.visibleRect)
        if enabled {
            CGSetDisplayTransferByTable(CGMainDisplayID(), 2, filters[currentFilterIndex].r, filters[currentFilterIndex].g, filters[currentFilterIndex].b)
        } else {
            CGSetDisplayTransferByTable(CGMainDisplayID(), 2, [0, 1], [0, 1], [0, 1])
        }
    }
}

extension GlitchViewController {
    static func create() -> GlitchViewController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let identifier = "GlitchViewController"
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? GlitchViewController else {
            fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

extension GlitchViewController {
    @IBAction func previous(_ sender: NSButton) {
        currentFilterIndex = (currentFilterIndex - 1 + filters.count) % filters.count
    }

    @IBAction func next(_ sender: NSButton) {
        currentFilterIndex = (currentFilterIndex + 1) % filters.count
    }

    @IBAction func toggle(_ sender: NSButton) {
        enabled = sender.state.rawValue == 1
        update()
    }

    @IBAction func rainbow(_ sender: NSButton) {
        DispatchQueue.global(qos: .background).async {
            for x in 1...200 {
                let r = Float(sin(.pi * Double(x) / 50 + 0) + 1) / 2
                let g = Float(sin(.pi * Double(x) / 50 + 2) + 1) / 2
                let b = Float(sin(.pi * Double(x) / 50 + 4) + 1) / 2
                CGSetDisplayTransferByTable(CGMainDisplayID(), 2, [r, 1 - r], [g, 1 - g], [b, 1 - b])
                usleep(5_000)
            }
            CGSetDisplayTransferByTable(CGMainDisplayID(), 2, [0, 1], [0, 1], [0, 1])
        }
    }

    @IBAction func quit(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
}

class PictureView: NSView {
    let filters = Filter.all

    var currentFilterIndex: Int = 0

    var enabled = false

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if !enabled {
            NSColor(red: CGFloat(filters[currentFilterIndex].r[0]), green: CGFloat(filters[currentFilterIndex].g[0]),
                blue: CGFloat(filters[currentFilterIndex].b[0]), alpha: 1).setFill()
        } else {
            NSColor.black.setFill()
        }
        NSRect(x: 0, y: 0, width: dirtyRect.width / 2, height: dirtyRect.height).fill()
        if !enabled {
            NSColor(red: CGFloat(filters[currentFilterIndex].r[1]), green: CGFloat(filters[currentFilterIndex].g[1]),
                blue: CGFloat(filters[currentFilterIndex].b[1]), alpha: 1).setFill()
        } else {
            NSColor.white.setFill()
        }
        NSRect(x: dirtyRect.width / 2, y: 0, width: dirtyRect.width / 2, height: dirtyRect.height).fill()
    }

}
