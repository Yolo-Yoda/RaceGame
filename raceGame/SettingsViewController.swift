import UIKit
import FirebaseCrashlytics
import FirebaseAnalytics

class SettingsViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: FirstViewControllerDelegate?
    
    var defSpeedNewSpeed : [Int] = []
    
    var defColorNewColor : [String] = []
    
    let colorsArray = ["white", "red", "yellow"]
    
    var obstacles: [Bool] = AppSettings.shared.obstaclesArray
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var enterName: UITextField!
    
    @IBOutlet var speedtagcollection: [UIButton]!
    
    @IBOutlet var colorTagCollection: [UIButton]!
    
    @IBOutlet var obstaclesTagCollection: [UIButton]!
    
    @IBOutlet var obstacles2TagCollection: [UIButton]!
    
    @IBOutlet weak var speed60: UIButton!
    
    @IBOutlet weak var speed120: UIButton!
    
    @IBOutlet weak var speed180: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
        analyticsManager(ivent: 1)
    }
    
    // MARK: - Public methods
    
    func defaultSettings() {
        addingBackgroudText()
        defaultRoudingSpeed()
        setDefaultSpeedStatus()
        roundingColorButtons()
        saveDefaultColor()
        roundingObstaclesButtons()
        saveDefaultObstacles()
        registerKeybordNotification()
    }
    
    func defaultRoudingSpeed() {
        for speedtag in speedtagcollection{
            speedtag.layoutIfNeeded()
            speedtag.layer.cornerRadius = speedtag.frame.height / 2
            speedtag.layer.borderColor = UIColor.black.cgColor
            speedtag.layer.borderWidth = 5
            speedtag.layer.masksToBounds = true
        }
    }
    
    func setDefaultSpeedStatus() {
        for speedTag in speedtagcollection {
            if speedTag.tag == AppSettings.shared.speed {
                speedTag.layer.borderColor = UIColor.green.cgColor
                speedTag.layer.borderWidth = 5
            }
        }
        defSpeedNewSpeed.append(AppSettings.shared.speed)
    }
    
    func sequeExit() {
        analyticsManager(ivent: 2)
        dismiss(animated: true, completion: nil)
    }
    
    func addindSpeedtoArray(sendertag: Int, speedArray: inout [Int]) -> [Int] {
        if speedArray.count == 1{
            speedArray.append(60)
        } else {
            speedArray.removeLast()
            speedArray.append(sendertag)
        }
        return speedArray
    }
    
    func addindColortoArray(newColor: String, colorArray: inout [String]) -> [String] {
        if colorArray.count == 1{
            colorArray.append(newColor)
        } else {
            colorArray.removeLast()
            colorArray.append(newColor)
        }
        return colorArray
    }
    
    func settingsDoneObstacles() {
        AppSettings.shared.obstacles = Obstacles(smallCar: obstacles[0] ,
                                                 bigcar: obstacles[1] ,
                                                 motocycle: obstacles[2] ,
                                                 tree: obstacles[3] ,
                                                 conus: obstacles[4] ,
                                                 rock: obstacles[5] )
    }
    
    func switcherSpeeds(){
        let changedSpeed = AppSettings.shared.speed
        switch changedSpeed {
        case 60:
            speed60.layer.borderColor = UIColor.green.cgColor
            speed120.layer.borderColor = UIColor.black.cgColor
            speed180.layer.borderColor = UIColor.black.cgColor
            defSpeedNewSpeed = addindSpeedtoArray(sendertag: speed60.tag,
                                                  speedArray: &defSpeedNewSpeed)
        case 120:
            speed60.layer.borderColor = UIColor.black.cgColor
            speed120.layer.borderColor = UIColor.green.cgColor
            speed180.layer.borderColor = UIColor.black.cgColor
            
            defSpeedNewSpeed = addindSpeedtoArray(sendertag: speed120.tag,
                                                  speedArray: &defSpeedNewSpeed)
        case 180:
            speed60.layer.borderColor = UIColor.black.cgColor
            speed120.layer.borderColor = UIColor.black.cgColor
            speed180.layer.borderColor = UIColor.green.cgColor
            
            defSpeedNewSpeed = addindSpeedtoArray(sendertag: speed180.tag,
                                                  speedArray: &defSpeedNewSpeed)
        default:
            return
        }
    }
    
    func roundingColorButtons() {
        for index in 0..<colorsArray.count{
            colorTagCollection[index].layoutIfNeeded()
            colorTagCollection[index].layer.cornerRadius = colorTagCollection[index].frame.height / 2
            colorTagCollection[index].layer.borderColor = UIColor.black.cgColor
            colorTagCollection[index].layer.borderWidth = 5
            colorTagCollection[index].layer.masksToBounds = true
        }
    }
    
    func saveDefaultColor() {
        for index in 0..<colorsArray.count {
            if colorsArray[index] == AppSettings.shared.carColor{
                colorTagCollection[index].layer.borderColor = UIColor.green.cgColor
            }
        }
        defColorNewColor.append(AppSettings.shared.carColor)
    }
    
    func addingBackgroudText() {
        enterName.placeholder = "\(AppSettings.shared.name)"
        enterName.delegate = self
        enterName.keyboardAppearance = UIKeyboardAppearance.dark
    }
    
    func roundingObstaclesButtons() {
        for index in 0..<obstaclesTagCollection.count{
            roundingButtons(index, &obstaclesTagCollection)
        }
        for index in 0..<obstacles2TagCollection.count{
            roundingButtons(index, &obstacles2TagCollection)
        }
    }
    
    func roundingButtons(_ index: Int,_ obstaclesCollection: inout [UIButton]) {
        obstaclesCollection[index].layoutIfNeeded()
        obstaclesCollection[index].layer.cornerRadius = obstaclesCollection[index].frame.height / 2
        obstaclesCollection[index].layer.borderColor = UIColor.black.cgColor
        obstaclesCollection[index].layer.borderWidth = 5
        obstaclesCollection[index].layer.masksToBounds = true
    }
    
    func saveDefaultObstacles() {
        let finalObstaclesTagCollection = obstaclesTagCollection + obstacles2TagCollection
        for index in 0..<obstacles.count {
            
            if obstacles[index] {
                finalObstaclesTagCollection[index].layer.borderColor = UIColor.green.cgColor
            }
        }
    }
    
    func switcherObstacles(_ index: Int) {
        let finalObstaclesTagCollection = obstaclesTagCollection + obstacles2TagCollection
        if obstacles[index] {
            guard getObstaclesCount() > 1 else {
                let userInfo = [
                  NSLocalizedDescriptionKey: NSLocalizedString("Obstacles collection failed", comment: ""),
                  NSLocalizedFailureReasonErrorKey: NSLocalizedString("Obstacles collection empty", comment: ""),
                  "ProductID": "Bundle version: \(Bundle.version())",
                  "View": "SettingsView"
                ]
                let error = NSError.init(domain: NSCocoaErrorDomain,
                                         code: -1001,
                                         userInfo: userInfo)
                Crashlytics.crashlytics().record(error: error)
                return }
            finalObstaclesTagCollection[index].layer.borderColor = UIColor.black.cgColor
            obstacles[index] = false
        } else {
            finalObstaclesTagCollection[index].layer.borderColor = UIColor.green.cgColor
            obstacles[index] = true
        }
    }
    
    // MARK: - Private methods
    
    private func analyticsManager(ivent: Int) {
        var iventName = ""
        var obstacles = ""
        if ivent == 1 {
            iventName = "Old_Settings"
            obstacles = "Old_Obstacles"
        } else if ivent == 2 {
            iventName = "New_Settings"
            obstacles = "New_Obstacles"
        }
        Analytics.logEvent(iventName, parameters: [
            "name": AppSettings.shared.name as String,
            "speed": AppSettings.shared.speed as Int,
            "color": AppSettings.shared.carColor as String,
            "count_games": AppSettings.shared.countGames as Int,
            "record": AppSettings.shared.recordOfGame as Int,
        ])
        Analytics.logEvent(obstacles, parameters: [
            "smallcar": AppSettings.shared.obstacles.smallCar as Bool,
            "bigcar": AppSettings.shared.obstacles.bigcar as Bool,
            "motorcycle": AppSettings.shared.obstacles.motocycle as Bool,
            "tree": AppSettings.shared.obstacles.tree as Bool,
            "conus": AppSettings.shared.obstacles.conus as Bool,
            "rock": AppSettings.shared.obstacles.rock as Bool,
        ])
    }
    
    private func getObstaclesCount() -> Int {
        obstacles.reduce(0) { counter, current in
            if current {
                return counter + 1
            }
            return counter
        }
    }
    
    private func switcherColors(){
        let changedColor = AppSettings.shared.carColor
        switch changedColor {
        case "white":
            colorTagCollection[0].layer.borderColor = UIColor.green.cgColor
            colorTagCollection[1].layer.borderColor = UIColor.black.cgColor
            colorTagCollection[2].layer.borderColor = UIColor.black.cgColor
            defColorNewColor = addindColortoArray(newColor: AppSettings.shared.carColor, colorArray: &defColorNewColor)
        case "red":
            colorTagCollection[0].layer.borderColor = UIColor.black.cgColor
            colorTagCollection[1].layer.borderColor = UIColor.green.cgColor
            colorTagCollection[2].layer.borderColor = UIColor.black.cgColor
            defColorNewColor = addindColortoArray(newColor: AppSettings.shared.carColor, colorArray: &defColorNewColor)
        case "yellow":
            colorTagCollection[0].layer.borderColor = UIColor.black.cgColor
            colorTagCollection[1].layer.borderColor = UIColor.black.cgColor
            colorTagCollection[2].layer.borderColor = UIColor.green.cgColor
            defColorNewColor = addindColortoArray(newColor: AppSettings.shared.carColor, colorArray: &defColorNewColor)
        default:
            return
        }
    }
    
    private func registerKeybordNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeybord(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(offKeybord(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    func onKeybord(_ nofication: NSNotification) {
        guard let info = nofication.userInfo,
              let keybordSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keybordSize.height, right: 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    @objc
    func offKeybord(_ nofication: NSNotification) {
        guard let info = nofication.userInfo,
              let _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func speed60Action(_ sender: Any) {
        AppSettings.shared.speed = 60
        switcherSpeeds()
    }
    
    @IBAction func speed120Action(_ sender: Any) {
        AppSettings.shared.speed = 120
        switcherSpeeds()
    }
    
    @IBAction func speed180Action(_ sender: Any) {
        AppSettings.shared.speed = 180
        switcherSpeeds()
    }
    
    @IBAction func exitAction(_ sender: Any) {
        AppSettings.shared.speed = defSpeedNewSpeed[0]
        AppSettings.shared.carColor = defColorNewColor[0]
        sequeExit()
    }
    
    @IBAction func bottomExitAction(_ sender: Any) {
        AppSettings.shared.speed = defSpeedNewSpeed[0]
        AppSettings.shared.carColor = defColorNewColor[0]
        sequeExit()
    }
    
    @IBAction func settingsDoneAction(_ sender: Any) {
        if (enterName.text ?? "").count > 0 {
            AppSettings.shared.name = enterName.text ?? AppSettings.shared.name
        }
        settingsDoneObstacles()
        delegate?.update(text: AppSettings.shared.name)
        
        sequeExit()
    }
    
    @IBAction func whiteColor(_ sender: Any) {
        AppSettings.shared.carColor = "white"
        switcherColors()
    }
    
    @IBAction func greenColor(_ sender: Any) {
        AppSettings.shared.carColor = "red"
        switcherColors()
    }
    
    @IBAction func redColor(_ sender: Any) {
        AppSettings.shared.carColor = "yellow"
        switcherColors()
    }
    
    @IBAction func smallCarObstacle(_ sender: Any) {
        switcherObstacles(0)
    }
    @IBAction func bigCarObstacle(_ sender: Any) {
        switcherObstacles(1)
    }
    
    @IBAction func motocycleObstacle(_ sender: Any) {
        switcherObstacles(2)
    }
    @IBAction func treeObstacle(_ sender: Any) {
        switcherObstacles(3)
    }
    @IBAction func conusObstacle(_ sender: Any) {
        switcherObstacles(4)
    }
    @IBAction func rockObstacle(_ sender: Any) {
        switcherObstacles(5)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(false)
    }
}

