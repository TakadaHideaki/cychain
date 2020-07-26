import UIKit
import GoogleMobileAds

class SeachResultListViewCOntroller: UIViewController, UINavigationControllerDelegate  {
    
    var names: [String]?
    var userID = [String]()
    var value = [[String:Any]]()
    var mutchingUserData: [String: [String: Any]]?
    var matchDataModel: MatchData?

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeUI()
        initializeTableView()
        userDataSet()
        tableView.reloadData()
    }
    
    func initalizeUI() {
        self.navigationItem.hidesBackButton = true
        customNavigationBar()
    }
    
    func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)  
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    
    func userDataSet() {
        matchDataModel = MatchData.shared
        guard let userName = matchDataModel?.names,
               let muchData = matchDataModel?.muchData
               else { return }
        
        names = userName
        muchData.forEach {
            userID += [$0.key]
            value += [$0.value]
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        _ = self.initViewLayout
    }
    lazy var initViewLayout : Void = {
        admob()
    }()
}

extension SeachResultListViewCOntroller: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userID.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = ("\([indexPath.row + 1])件目")
        return cell
    }
}

extension SeachResultListViewCOntroller: UITableViewDelegate {
    
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let SeachResultMultipleVC = self.storyboard?.instantiateViewController(withIdentifier: "SeachResultMultipleViewCOntroller") as! SeachResultMultipleViewCOntroller
        
        SeachResultMultipleVC.nameArray = names
        SeachResultMultipleVC.account = userID[indexPath.row]
        SeachResultMultipleVC.value = value[indexPath.row]
        self.navigationController?.pushViewController(SeachResultMultipleVC, animated: true)
    }
}

