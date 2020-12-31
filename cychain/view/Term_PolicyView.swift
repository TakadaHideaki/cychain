import UIKit

class Term_PolicyView: UIView {
    
    var height: CGFloat?
    var sentence: String?
    
    init(height: CGFloat, sentence: String) {
        super.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        self.height = height
        self.sentence = sentence
        setView()

    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func setView() {
        setBackGroundView()
        setTextView()
    }
    
    func setBackGroundView() {
        let view: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            return view
        }()
        self.addSubview(view)
        view.topAnchor.constraint(equalTo: self.topAnchor, constant:0).isActive = true
        view.leftAnchor.constraint(equalTo: self.leftAnchor, constant:0).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant:0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:0).isActive = true
    }
    
    func setTextView() {
        let textView: UITextView = {
            let textView = UITextView()
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.text = sentence
            textView.backgroundColor = .white
            return textView
        }()
        self.addSubview(textView)
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant:40 + height!).isActive = true
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant:15).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-15).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:-20).isActive = true
        }

}
