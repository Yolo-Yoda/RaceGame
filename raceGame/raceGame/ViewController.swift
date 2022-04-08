import UIKit

class ViewController: UIViewController, FirstViewControllerDelegate {
    func update(text: String) {
        addingProfileName()
    }
    
    // MARK: - Public properties
    
    var profilePushed = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var countGames: UILabel!
    
    @IBOutlet weak var accountRecord: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var blurOnPushedProfile: UIVisualEffectView!
    
    @IBOutlet weak var profileTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
        tapActionRecognizer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SettingsViewController else { return }
        destination.delegate = self
    }
    
    // MARK: - Public methods
    
    func defaultSettings() {
        profileTrailingConstraint.constant = view.frame.width
        view.layoutIfNeeded()
        blurOnPushedProfile.isHidden = true
        view.layoutIfNeeded()
        makingProfileImage()
        addingProfileName()
        addingAccountCountGames()
        addingAccountRecord()
        
    }
    
    func makingProfileImage() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 5
        profileImage.clipsToBounds = true
    }
    
    func addingProfileName() {
        let accountName = AppSettings.shared.name
        profileName.text = accountName
    }
    
    func addingAccountCountGames() {
        let countPlayingGames = 0
        countGames.text = ("\(countPlayingGames) Games")
    }
    
    func addingAccountRecord() {
        let recordAccount = 0
        accountRecord.text = ("Record: \(recordAccount)")
    }
    
    func tapActionRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(tapProfileAction(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    func tapProfileAction(_ gestureRecognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.25) {
            self.profileTrailingConstraint.constant = self.view.frame.width
            self.profilePushed = false
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.blurOnPushedMenuTrue()
            self.blurOnPushedProfile.layoutIfNeeded()
        }
    }
    
    func changeImageAllert() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Galery", style: .default) {_ in
            self.openGalery()
        })
        alert.addAction(UIAlertAction(title: "Camera", style: .default) {_ in
            self.openCamera()
        })
        alert.addAction(UIAlertAction(title: "Set Default", style: .default) {_ in
            self.profileImage.image = UIImage(named: AppSettings.shared.image)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Private methods
    
    private func blurOnPushedMenuTrue() {
        blurOnPushedProfile.isHidden = true
        blurOnPushedProfile.isUserInteractionEnabled = true
        view.layoutIfNeeded()
    }
    
    private func blurOnPushedMenuFalse() {
        blurOnPushedProfile.isHidden = false
        blurOnPushedProfile.isUserInteractionEnabled = true
        view.layoutIfNeeded()
    }
    
    // MARK: - IBActions
    
    @IBAction func changeProfileImage(_ sender: Any) {
        changeImageAllert()
    }
    
    @IBAction func pushingSettingsButton(_ sender: Any) {
        performSegue(withIdentifier: "goSettingsViewController", sender: nil)
    }
    
    @IBAction func startButton(_ sender: Any) {
        //performSegue(withIdentifier: "goGameViewController", sender: nil)
        //showMainAlertCheckingPassword()
    }
    
    @IBAction func profileButtonPushed(_ sender: Any) {
        if profilePushed == false {
            UIView.animate(withDuration: 0.25) {
                self.profilePushed = true
                self.blurOnPushedMenuFalse()
                self.blurOnPushedProfile.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.25) {
                    self.profileTrailingConstraint.constant = 100
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.profileTrailingConstraint.constant = self.view.frame.width
                self.profilePushed = false
                self.view.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.25) {
                    self.blurOnPushedMenuTrue()
                    self.blurOnPushedProfile.layoutIfNeeded()
                }
            }
        }
    }
}

private extension ViewController {
    func openGalery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol FirstViewControllerDelegate: AnyObject {
    func update(text: String)
}
