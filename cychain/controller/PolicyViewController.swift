import UIKit

class PolicyViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.navigationBar.shadowImage = UIImage()

//        customNavigationBar(color: .orange)
                 self.navigationController?.navigationBar.barTintColor = .white
    }
}
