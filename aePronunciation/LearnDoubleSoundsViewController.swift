import UIKit
import AudioToolbox

class LearnDoubleSoundsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var ipa: String?
    fileprivate let player = Player()
    let reuseIdentifier = "cell"
    var doubleSound = DoubleSound()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let singleSound = ipa else {return}
        doubleSound.restrictListToAllPairsContaining(ipa: singleSound)
    }

    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doubleSound.getSoundCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DoubleSoundsCollectionViewCell
        
        cell.cellLabel.text = doubleSound.getSounds()[indexPath.item]
        cell.cellLabel.textColor = self.view.tintColor
        cell.layer.borderColor = self.view.tintColor.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // play sound
        let ipa = doubleSound.getSounds()[indexPath.item]
        if let soundFile = DoubleSound.getSoundFileName(doubleSoundIpa: ipa) {
            player.playSoundFrom(file: soundFile)
        }
    }
}
