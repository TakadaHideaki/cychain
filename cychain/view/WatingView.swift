import UIKit

class WatingView: UIView {

    let indicatorView = UIActivityIndicatorView.init(style: .whiteLarge)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    private func setUp() {
        backgroundColor = .red
        alpha = 0.5
        indicatorView.color = .white
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

}
