import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "title_activity_about".localized
        appTitleLabel.text = "about_app_name".localized
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = String.localizedStringWithFormat("about_app_version".localized, version)
        }
        
        
    }
    
    
}
