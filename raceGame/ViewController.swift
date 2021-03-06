import UIKit

class ViewController: UIViewController, FirstViewControllerDelegate {
    
    func update(text: String) {
        addingProfileName()
    }
    
    func updateScore(text: Int) {
        if text > AppSettings.shared.recordOfGame {
            AppSettings.shared.recordOfGame = text
            addingAccountRecord()
        }
        else {
            addingAccountRecord()
        }
    }
    
    func updateCountGames(text: Int) {
        addingAccountCountGames()
    }
    func addingToArray(resultOfRace: ResultRace) {
        addElementToDataArray(resultOfRace)
    }
    
    // MARK: - Public properties
    
    var profilePushed = false
    
    var dataArray: [ResultRace] = []
    
    var maxCountOfDataArray = 30
    
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
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
        tapActionRecognizer()
        self.tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.backgroundColor = .clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? SettingsViewController {
            destination.delegate = self
        }
        else if  let destination = segue.destination as? GameViewController {
            destination.delegate = self
        }
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
        makeScoreboardTableView()
    }
    
    func makeScoreboardTableView() {
        guard AppSettings.shared.lastScores.name != "" else {
            return
        }
        dataArray.append(AppSettings.shared.lastScores)
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
        let countPlayingGames = AppSettings.shared.countGames
        countGames.text = ("\(countPlayingGames) Games")
    }
    
    func addingAccountRecord() {
        let recordAccount = AppSettings.shared.recordOfGame
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
            UIView.animate(withDuration: 0.25) {
                self.blurOnPushedMenuTrue()
                self.blurOnPushedProfile.layoutIfNeeded()
            }
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
    
    func addElementToDataArray(_ result: ResultRace) {
        if dataArray.count > maxCountOfDataArray {
            dataArray.remove(at: 0)
            dataArray.append(result)
        } else {
            dataArray.append(result)
        }
        AppSettings.shared.lastScores = result
        tableView.reloadData()
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
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.",
                                           preferredStyle: .alert)
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

protocol FirstViewControllerDelegate: AnyObject {
    func update(text: String)
    func updateScore(text: Int)
    func updateCountGames(text: Int)
    func addingToArray(resultOfRace: ResultRace)
}

