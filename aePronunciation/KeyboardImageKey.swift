import UIKit

@IBDesignable
class KeyboardImageKey: KeyboardKey {
    
    fileprivate let imageLayer = CALayer()
    fileprivate var oldFrame = CGRect.zero
    fileprivate var timer = Timer()
    
    var primaryString: String = ""
    var secondaryString: String = ""
    var repeatOnLongPress = false
    var repeatInterval = 0.1 // sec
    var keyType = KeyType.other
    
    enum KeyType {
        case backspace
        case other
    }
    
    
    @IBInspectable var image: UIImage?
        {
        didSet {
            imageLayer.contents = image?.cgImage
            updateImageLayerFrame()
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
                updateImageLayerFrame()
                oldFrame = frame
            }
        }
    }
    
    func setup() {
        
        // image layer
        imageLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(imageLayer)
        
    }
    
    func updateImageLayerFrame() {
        
        if let unwrappedImage = image {
            imageLayer.frame = bounds
            
            // shrink image if larger than bounds
            if unwrappedImage.size.height > bounds.height || unwrappedImage.size.width > bounds.width {
                imageLayer.contentsGravity = CALayerContentsGravity.resizeAspect
            } else {
                imageLayer.contentsGravity = CALayerContentsGravity.center
            }
            
        }
        
    }
    
    // long press
    override func longPressBegun(_ guesture: UILongPressGestureRecognizer) {
        if self.secondaryString != "" {
            delegate?.keyTextEntered(sender: self, keyText: self.secondaryString)
        } else {
            if keyType == KeyType.backspace {
                delegate?.keyBackspaceTapped()
            } else {
                delegate?.keyTextEntered(sender: self, keyText: self.primaryString)
            }
            
            if repeatOnLongPress {
                timer = Timer.scheduledTimer(timeInterval: repeatInterval, target: self, selector: #selector(repeatAction), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func longPressEnded() {
        timer.invalidate()
    }
    
    override func longPressCancelled() {
        timer.invalidate()
    }
    
    // tap event (do when finger lifted)
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        timer.invalidate()
        
        if keyType == KeyType.backspace {
            delegate?.keyBackspaceTapped()
        } else {
            delegate?.keyTextEntered(sender: self, keyText: self.primaryString)
        }
        
    }
    
    
    
    // do if repeating on long press
    @objc func repeatAction() {
        
        if keyType == KeyType.backspace {
            delegate?.keyBackspaceTapped()
        } else {
            delegate?.keyTextEntered(sender: self, keyText: self.primaryString)
        }
    }
    
}

