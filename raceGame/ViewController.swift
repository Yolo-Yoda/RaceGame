import UIKit
import FirebaseCrashlytics
import FirebaseAnalytics
import RxSwift
import RxCocoa
import RxDataSources


class ViewController: UIViewController, FirstViewControllerDelegate, UIScrollViewDelegate {
    
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
    
    let viewModel = RecordViewModel()
    // MARK: - RXMod
    
    
    
    let bag = DisposeBag()
    
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
    
    
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ResultRaces>(configureCell: configureCell)
    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<ResultRaces>.ConfigureCell = {
        [unowned self] (dataSource, tableView, indexPath, item) in
        switch item {
        case .resultRace(let info):
            return self.configreResultCell(result: info, atIndex: indexPath)}
        }
            
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
        tapActionRecognizer()
        setupRxCollectionView()
    }
    
    func configreResultCell(result: ResultRace, atIndex: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: atIndex) as? ScoreTableViewCell else {
            return UITableViewCell()
        }
        cell.setupCell(_With: result)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let destination = segue.destination as? SettingsViewController {
            destination.delegate = self
        }
        else if  let destination = segue.destination as? GameViewController {
            destination.delegate = self
        }
    }
    
    func setupRxCollectionView(){
        tableView.rx.setDelegate(self).disposed(by: bag)
        self.tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: "ScoreCell")
        viewModel.dataArrayNew
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.dataArrayNew.onNext([ResultRaces(model: .main, items: viewModel.subresults)])
        //viewModel.getInformation()
        tableView.backgroundColor = .clear
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
            let userInfo = [
              NSLocalizedDescriptionKey: NSLocalizedString("Enter user name failed", comment: ""),
              NSLocalizedFailureReasonErrorKey: NSLocalizedString("User enter empty name", comment: ""),
              "ProductID": "Bundle version: \(Bundle.version())",
              "View": "StartView"
            ]
            let error = NSError.init(domain: NSCocoaErrorDomain,
                                     code: -1001,
                                     userInfo: userInfo)
            Crashlytics.crashlytics().record(error: error)
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
        Analytics.logEvent("User_start_game", parameters: nil)
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

