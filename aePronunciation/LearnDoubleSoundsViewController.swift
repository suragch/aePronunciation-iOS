import UIKit
import AudioToolbox

class LearnDoubleSoundsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    private let player = Player()
    let reuseIdentifier = "cell"
    let doubleSound = DoubleSound()

    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return doubleSound.ipaStringList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DoubleSoundsCollectionViewCell
        
        cell.cellLabel.text = doubleSound.ipaStringList[indexPath.item]
        cell.cellLabel.textColor = self.view.tintColor
        //cell.backgroundColor = UIColor.yellowColor()
        cell.layer.borderColor = self.view.tintColor.CGColor //  UIColor.blueColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // play sound
        let ipa = doubleSound.ipaStringList[indexPath.item]
        if let soundFile = doubleSound.fileNameForIpa(ipa) {
            player.playSoundFromFile(soundFile)
        }
    }
}
