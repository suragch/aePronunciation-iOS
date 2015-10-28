import UIKit

class DoubleSoundsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                self.layer.opacity = 0.6;
            } else {
                self.layer.opacity = 1.0;
            }
        }
    }
}
