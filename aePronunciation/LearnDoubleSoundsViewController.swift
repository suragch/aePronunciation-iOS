import UIKit
import AudioToolbox

class LearnDoubleSoundsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var ipa: String?
    fileprivate let player = Player()
    let reuseIdentifier = "cell"
    var doubleSound = DoubleSound()
    private let timer = StudyTimer.sharedInstance
    
    @IBOutlet weak var titleNavBar: UINavigationItem!
    
    // MARK:- Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocalizedStrings()
        
        guard let singleSound = ipa else {return}
        doubleSound.restrictListToAllOrderedPairsContaining(ipa: singleSound)
        
        // listen for if the user leaves the app
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer.start(type: .learnDouble)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.stop()
    }
    
    @objc func appWillEnterForeground() {
        if self.viewIfLoaded?.window != nil {
            timer.start(type: .learnDouble)
        }
    }
    
    @objc func appDidEnterBackground() {
        if self.viewIfLoaded?.window != nil {
            timer.stop()
        }
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
        
        playSound(at: indexPath)
    }
    
    // MARK:- Other
    
    private func setLocalizedStrings() {
        guard let currentIpa = ipa else {return}
        titleNavBar.title = String.localizedStringWithFormat("title_activity_learn_double".localized, currentIpa)
    }
    
    private func playSound(at indexPath: IndexPath) {
        let ipa = doubleSound.getSounds()[indexPath.item]
        if let soundFile = DoubleSound.getSoundFileName(doubleSoundIpa: ipa) {
            player.playSoundFrom(file: soundFile)
        }
    }
}
