//
//  profileViewController2.swift
//  abcd
//
//  Created by takadahideaki007 on 2019/01/31.
//  Copyright © 2019 高田英明. All rights reserved.
//

import UIKit
import Firebase


class list: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    
    @IBOutlet var tableView: UITableView!
    var resultArray = [String]()
    var resultArray2 = [String]()
//    var userDefaults: [[String:String]]!
//    var name2: [[String:String]]!
//    var name3: [[String:String]]!
        var name2 = [[String:String]]()
        var name3 = [[String:String]]()
    var myNameArray = [String]()
    var targetNameArray = [String]()
    var ref:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
/*       if UserDefaults.standard.object(forKey: "myName") != nil{
            resultArray = UserDefaults.standard.object(forKey: "myName") as! [String]
        }
        if UserDefaults.standard.object(forKey: "targetName") != nil{
            resultArray2 = UserDefaults.standard.object(forKey: "targetName") as! [String]
        }
 */
        
        
        if UserDefaults.standard.object(forKey: "uniqueNmame") != nil{
//            userDefaults = UserDefaults.standard.object(forKey: "uniqueNmame") as? [[String : String]]
            if let name3 = UserDefaults.standard.array(forKey: "uniqueNmame"){
                name2 = (name3  as? [[String : String]])!
            }
            

        }
        
        tableView.reloadData()
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name2.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
      
        
        for (key, value) in name2[indexPath.row]{
            myNameArray.append(key)
            targetNameArray.append(value)
            cell.myName.text! = myNameArray[indexPath.row]
            cell.targetName.text! = targetNameArray[indexPath.row]
        }
        
  /*   for key in name2[indexPath.row].keys {
            myNameArray.append(key)
            cell.myName.text! = myNameArray[indexPath.row]}
        for value in name2[indexPath.row].values {
            targetNameArray.append(value)
            cell.targetName.text! = targetNameArray[indexPath.row]}
*/
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        let ref = Database.database().reference()
        if editingStyle == .delete {
            
        ref.child(myNameArray[indexPath.row]).child(targetNameArray[indexPath.row]).removeValue()
//            myNameArray.remove(at: indexPath.row)
//            targetNameArray.remove(at: indexPath.row)
            name2.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(name2, forKey: "uniqueNmame")

            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myName = myNameArray[indexPath.row]
        let searchName = targetNameArray[indexPath.row]
        let userid = Auth.auth().currentUser?.uid
        var keyArray: [String] = ["MyName", "TargetName"]
        var valueArray: [String] = [myName, searchName]
//        var dic: [String:String]!
//        let ref = Database.database().reference().child(myName).child(searchName).child(userid!)
//        let ref = Database.database().reference().child(myName).child(searchName)

        
      let ref = Database.database().reference().child("\(myName)/\(searchName)/\(userid!)")
//      if let userid = Auth.auth().currentUser?.uid {
//      let ref = Database.database().reference().child("\(myName)/\(searchName)/\(userid)")
//       var keyArray: [String] = ["MyName", "TargetName", "", "",]
//       var valuArray: [String] = ["", "", "", "",]

        
//        ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
//            for item in DataSnapshot.children{
//            let snap = item as! DataSnapshot
////            let dicts = snap.value as! [String:String]
//                keyArray.append(snap.key)
//                valueArray.append(snap.value as! String)
//////            values.append((snap.value as? [String:String])!)
////                values.append(snap.value)
////            }})}
//
//        ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
//            let value = DataSnapshot.value as? Dictionary
        
        ref.observeSingleEvent(of: .value, with: { (DataSnapshot) in
//            var dict = DataSnapshot.value as! [String:String]
            var dict = DataSnapshot.value as! [String:Any]
        
            
            
            dict["myName"] = myName
            dict["targetName"] = searchName
            let messege = dict["message"]!
            let url = URL(string: dict["image"] as! String)
            
//            image変換
            do {
                let imageData = try Data(contentsOf: url!)
                let image = UIImage(data:imageData as Data)
                let edit: edit = self.storyboard?.instantiateViewController(withIdentifier: "edit") as! edit
                edit.dict = dict as? [String:String]
                edit.image = image
                edit.imageData = imageData as NSData
                self.navigationController?.pushViewController(edit, animated: true)
            } catch {
                print(error)
         }})}


            //            var err: NSError?;
            //            var imageData :NSData = NSData(bytesNoCopy: url,length: NSData.ReadingOptions.DataReadingMappedIfSafe, freeWhenDone: &err)!;
//            var image = UIImage(data:imageData as Data)
            

//----------------------------------------------------------------------------------
//            if (dict["age"] != "") { keyArray.append("age") }
//            if (dict["name"] != "") { keyArray.append("name") }
//            if (dict["age"] != "") { valueArray.append(dict["age"]!) }
//            if (dict["name"] != "") { valueArray.append(dict["name"]!) }
//            valuArray.append(dict["MyName"]!)
//            valuArray.append(dict["TargetName"]!)
//            messege = dict["message"]!
// -----------------------------------------------------------------------------------
//            valuArray[0] = dict["MyName"]!
//            valuArray[1] = dict["TargetName"]!
//            if (dict["age"] != ""){keyArray[2] = "age"}
//            if (dict["name"] != ""){keyArray[3] = "name"}
//            if (dict["age"] != ""){valuArray[2] = dict["age"]!}
//            if (dict["name"] != nil){
//            if (dict["name"] != ""){valuArray[3] = dict["name"]!}


            
            //            profileDerails.profileArrayValue = valueArray
            //            profileDerails.profileArraykey = keyArray
            //            edit.message1 = messege
//
//            let edit: edit = self.storyboard?.instantiateViewController(withIdentifier: "edit") as! edit
//            edit.dict = dict as? [String:String]
//            edit.image = image
//            self.navigationController?.pushViewController(edit, animated: true)
}
