
import UIKit

class MoreTableViewController: UITableViewController {
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var testsLabel: UILabel!
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setLocalizedStrings()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row after user lifts finger
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let ABOUT = 1
        let CONTACT = 1
        if indexPath.section == ABOUT && indexPath.row == CONTACT {
            let urlString = "about_contact_url".localized
            guard let url = URL(string: urlString) else {return}
            UIApplication.shared.openURL(url)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return "main_tab_more_history_section_title".localized
        case 1:
            return "main_tab_more_about_section_title".localized
        default:
            return ""
        }
    }
    
    private func setLocalizedStrings() {
        self.title = "main_tab_more".localized
        totalTimeLabel.text = "main_tab_more_total_time".localized
        testsLabel.text = "main_tab_more_tests".localized
        appLabel.text = "main_tab_more_app".localized
        contactLabel.text = "main_tab_more_contact".localized
    }
    
}
