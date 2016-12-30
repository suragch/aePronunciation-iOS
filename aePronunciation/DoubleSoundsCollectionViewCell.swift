import UIKit

class DoubleSoundsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                self.layer.opacity = 0.6;
            } else {
                self.layer.opacity = 1.0;
            }
        }
    }
}
