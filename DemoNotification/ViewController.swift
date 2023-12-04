import UIKit

class ViewController: UIViewController {
    let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        textView.textAlignment = .center
        textView.contentInset = .init(top: 100, left: 0, bottom: 50, right: 0)
        textView.text = "Loading..."
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateText(notification:)), name: Notification.Name("RemoteNotification"), object: nil)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .provisional]) { granted, error in
            var message = ""
            if let error = error {
                // Handle the error here.
                message = error.localizedDescription
            } else {
                if granted {
                    message = "Registering..."
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    message = "Permission denied"
                }
            }
            let dict:[String: String] = ["result": message]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RemoteNotification"), object: nil, userInfo: dict)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    @objc func updateText(notification: Notification) {
        if let result = notification.userInfo?["result"] as? String {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                textView.text = result
            }
        }
    }
}
