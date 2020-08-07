import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import RSKImageCropper

class EditViewController: UIViewController, UINavigationControllerDelegate,UITextFieldDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UIScrollViewDelegate, ScrollKeyBoard {
    
    
    @IBOutlet weak var myNameTextField: UITextField!
    @IBOutlet weak var targetNameTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dataSendButton: UIButton!
    @IBOutlet weak var iconRegistButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    

    
    
    var editUserData: [String: Any]?
    var iconImage: UIImage?
    var iconSet: ImagePickerController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialazeUI()
        userDataSet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // TextViewフォーカス外す　＆キーボード閉じる＋View戻す
        messageTextView.resignFirstResponder()
        configureObserver()
    }
    
    func initialazeUI() {
        myNameTextField.delegate = self
        targetNameTextField.delegate = self
        messageTextView.delegate = self
        tabBarController?.tabBar.isHidden = true
        messageTextView.keyBoardtoolBar(textView: messageTextView)
        customNavigationBar()
        iconSet = ImagePickerController()
//        iconSet?.delegate = self as? (UIViewController & IconSetDelegate)
        iconSet?.delegate = self

    }
    
    //UserDataを表示
    func userDataSet() {
        
        guard let userData = EditData.sharedInstance.SingletonUserData else { return }
        
        editUserData = userData
        
        guard let myName = userData["my"] as? String,
            let targetName = userData["target"] as? String
            else { return }
        
        myNameTextField.text = myName
        targetNameTextField.text = targetName
        
        
        if let message = userData["message"] as? String {
            if message != "" {
                messageLabel.isHidden = true
                messageTextView.text = message
            } else {
                messageLabel.isHidden = false
            }
        } else {
            messageLabel.isHidden = false
        }
        
        
        if let imageUrl = userData["image"] {
            let url = URL(string: imageUrl as! String)
            // image変換
            do {
                let imageData = try Data(contentsOf: url!)
                let image = UIImage(data:imageData as Data)
                iconRegistButton.setImage(image, for: .normal)
                iconImage = image
                editUserData?["image"] = image
            } catch {
                log.debug("error")
            }
        } else {
            iconRegistButton.setImage(R.image.user10(), for: .normal)
        }
    }
    
    
    @IBAction func iconButtonTapped(_ sender: Any) {
//        iconSet?.iconButtonTapped()
    }
    
    
    @IBAction func senderData(_ sender: Any) {
        
        editUserData!["message"] = messageTextView.text ?? ""
        editUserData?["image"]  = iconRegistButton.currentImage ?? R.image.user10()
        
//        let userDataModel = UserDataModel.sharead
        
//        userDataModel.setData(userData: editUserData!)// modelへ["message":メッセージ, "image" アイコンイメージ]
//        userDataModel.setFirebase()//firebase更新
        pushVC(vc: R.storyboard.main.inputResultVC()!, animation: true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        configureObserver()
        messageLabel.isHidden = true
        return  true
    }
    
    
    let maxLength = 6
    var previousText = ""
    var lastReplaceRange: NSRange!
    var lastReplacementString = ""
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.previousText = myNameTextField.text!
        self.lastReplaceRange = range
        self.lastReplacementString = text
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if myNameTextField.markedTextRange != nil {
            return
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText: String = (messageTextView.text! as NSString).replacingCharacters(in: range, with: text)
        return numberOfLines(orgTextView: textView, newText: newText) <= 6
    }
    
    
    func numberOfLines(orgTextView: UITextView, newText: String) -> Int {
        
        let cloneTextView = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(try! NSKeyedArchiver.archivedData(withRootObject: orgTextView, requiringSecureCoding: false)) as! UITextView
        
        cloneTextView.text = newText + " "
        
        let layoutManager = cloneTextView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        return numberOfLines
    }
    
}

//extension EditViewController: IconSetDelegate {
//
//    func buttonSetDidCropImage(image: UIImage) {
//        iconRegistButton?.setImage(image, for: .normal)
//    }
//}
 


