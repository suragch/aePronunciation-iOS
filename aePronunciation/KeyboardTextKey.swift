import UIKit

@IBDesignable
class KeyboardTextKey: KeyboardKey {
    
    private let primaryLayer = CATextLayer()
    private let secondaryLayer = CATextLayer()
    let secondaryLayerMargin: CGFloat = 5.0
    private var oldFrame = CGRect.zero
    private static let selectedTextColor = UIColor.white
    private static let disabledTextColor = UIColor.lightGray
    private static var normalTextColor = UIColor.systemDefaultTextColor
    
    // MARK: Primary input value
    
    @IBInspectable var primaryString: String = "" {
        didSet {
            updatePrimaryLayerFrame()
        }
    }
    @IBInspectable var primaryStringFontSize: CGFloat = 17 {
        didSet {
            updatePrimaryLayerFrame()
        }
    }
    var primaryStringFontColor: UIColor = normalTextColor {
        didSet {
            updatePrimaryLayerFrame()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                primaryStringFontColor = KeyboardTextKey.selectedTextColor
            } else {
                primaryStringFontColor = KeyboardTextKey.normalTextColor
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                primaryStringFontColor = KeyboardTextKey.normalTextColor
            } else {
                primaryStringFontColor = KeyboardTextKey.disabledTextColor
            }
        }
    }
    
    // MARK: Secondary (long press) input value
    
    @IBInspectable var secondaryString: String = "" {
        didSet {
            updateSecondaryLayerFrame()
        }
    }
    @IBInspectable var secondaryStringFontSize: CGFloat = 12 {
        didSet {
            updateSecondaryLayerFrame()
        }
    }
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override var frame: CGRect {
        didSet {
            // only update frames if non-zero and changed
            if frame != CGRect.zero && frame != oldFrame {
                updatePrimaryLayerFrame()
                updateSecondaryLayerFrame()
                oldFrame = frame
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                primaryStringFontColor = UIColor.systemDefaultTextColor
            }
        }
    }
    
    func setup() {
        // Primary text layer
        primaryLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(primaryLayer)
        
        // Secondary text layer
        secondaryLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(secondaryLayer)
    }
    
    func updatePrimaryLayerFrame() {
        
        let myAttribute: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: primaryStringFontSize),
            NSAttributedString.Key.foregroundColor: primaryStringFontColor ]
        let attrString = NSMutableAttributedString(string: primaryString, attributes: myAttribute )
        let size = dimensionsForAttributedString(attrString)
        
        let x = (layer.bounds.width - size.width) / 2
        let y = (layer.bounds.height - size.height) / 2
        primaryLayer.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        primaryLayer.string = attrString
    }
    
    func updateSecondaryLayerFrame() {
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: secondaryStringFontSize) ]
        let attrString = NSMutableAttributedString(string: secondaryString, attributes: myAttribute )
        let size = dimensionsForAttributedString(attrString)
        
        let x = layer.bounds.width - size.width - secondaryLayerMargin
        let y = layer.bounds.height - size.height - secondaryLayerMargin
        secondaryLayer.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        secondaryLayer.string = attrString
    }
    
    
    override func longPressBegun(_ guesture: UILongPressGestureRecognizer) {
        if self.secondaryString != "" {
            delegate?.keyTextEntered(sender: self, keyText: self.secondaryString)
        } else {
            // enter primary string if this key has no seconary string
            delegate?.keyTextEntered(sender: self, keyText: self.primaryString)
        }
    }
    
    // tap event (do when finger lifted)
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        delegate?.keyTextEntered(sender: self, keyText: self.primaryString)
        
    }
    
    func dimensionsForAttributedString(_ attrString: NSAttributedString) -> CGSize {
        
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var width: CGFloat = 0
        let line: CTLine = CTLineCreateWithAttributedString(attrString)
        width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, nil))
        
        // make width an even integer for better graphics rendering
        width = ceil(width)
        if Int(width)%2 == 1 {
            width += 1.0
        }
        
        return CGSize(width: width, height: ceil(ascent+descent))
    }
}


