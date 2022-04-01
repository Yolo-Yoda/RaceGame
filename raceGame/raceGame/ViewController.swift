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
    
    @IBAction func pushingSettingsButton(_ sender: Any) {
        performSegue(withIdentifier: "goSettingsViewController", sender: nil)
        //showSettngsAllert()
    }
    
    @IBAction func startButton(_ sender: Any) {
        showMainAlertCheckingPassword()
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

protocol FirstViewControllerDelegate: AnyObject {
    func update(text: String)
}
