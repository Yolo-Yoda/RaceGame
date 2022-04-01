import UIKit

extension UIViewController{
    
    // MARK: - Public methods
    
    func showPasswordCorrectAllert() {
        let alert = UIAlertController(title: "🥳 Congratulation's 🇺🇦🥳",
                                      message: "Password correct",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Menu",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Race",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPasswordIncorrectAllert() {
        let alert = UIAlertController(title: "😢 Shit happen's 😢",
                                      message: "Password incorrect",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Exit",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { _ in
            exit(0)
        }))
        alert.addAction(UIAlertAction(title: "Try again",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            self.showMainAlertCheckingPassword()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMainAlertCheckingPassword() {
        let alertController = UIAlertController(title: "Let's check password",
                                                message: "Enter you'r password",
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add",
                                          style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                if text == "1234"{
                    self.showPasswordCorrectAllert()
                } else {
                    self.showPasswordIncorrectAllert()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Tag"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showSettngsAllert() {
        let alert = UIAlertController(title: "At production",
                                      message: "♥️🤍♥️",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Exit",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
