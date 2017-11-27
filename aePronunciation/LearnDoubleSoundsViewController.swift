import UIKit
import AudioToolbox

class LearnDoubleSoundsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var ipa: String?
    fileprivate let player = Player()
    let reuseIdentifier = "cell"
    let doubleSound = DoubleSound()

    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doubleSound.ipaStringList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DoubleSoundsCollectionViewCell
        
        cell.cellLabel.text = doubleSound.ipaStringList[indexPath.item]
        cell.cellLabel.textColor = self.view.tintColor
        //cell.backgroundColor = UIColor.yellowColor()
        cell.layer.borderColor = self.view.tintColor.cgColor //  UIColor.blueColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // play sound
        let ipa = doubleSound.ipaStringList[indexPath.item]
        if let soundFile = doubleSound.fileNameForIpa(ipa) {
            player.playSoundFromFile(soundFile)
        }
    }
}
