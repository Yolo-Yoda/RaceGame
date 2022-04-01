import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: FirstViewControllerDelegate?
    
    var defSpeedNewSpeed : [Int] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var enterName: UITextField!
    
    @IBOutlet var speedtagcollection: [UIButton]!
    
    @IBOutlet weak var speed60: UIButton!
    
    @IBOutlet weak var speed120: UIButton!
    
    @IBOutlet weak var speed180: UIButton!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
    }
    
    // MARK: - Public methods
    
    func defaultSettings() {
        setDefaultSpeedStatus()
        
    }
    
    func setDefaultSpeedStatus() {
        for speedTag in speedtagcollection {
            if speedTag.tag == AppSettings.shared.speed {
                speedTag.backgroundColor = .darkGray
            }
        }
        defSpeedNewSpeed.append(AppSettings.shared.speed)
    }
    
    func sequeExit() {
        
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
    
    // MARK: - IBActions
    
    @IBAction func speed60Action(_ sender: Any) {
        speed60.backgroundColor = .darkGray
        speed120.backgroundColor = .lightGray
        speed180.backgroundColor = .lightGray
        AppSettings.shared.speed = 60
        defSpeedNewSpeed = addindSpeedtoArray(sendertag: speed60.tag,
                                              speedArray: &defSpeedNewSpeed)
    }
    
    @IBAction func speed120Action(_ sender: Any) {
        speed60.backgroundColor = .lightGray
        speed120.backgroundColor = .darkGray
        speed180.backgroundColor = .lightGray
        AppSettings.shared.speed = 120
        defSpeedNewSpeed = addindSpeedtoArray(sendertag: speed120.tag,
                                              speedArray: &defSpeedNewSpeed)
    }
    
    @IBAction func speed180Action(_ sender: Any) {
        speed60.backgroundColor = .lightGray
        speed120.backgroundColor = .lightGray
        speed180.backgroundColor = .darkGray
        AppSettings.shared.speed = 180
        defSpeedNewSpeed = addindSpeedtoArray(sendertag: speed180.tag,
                                              speedArray: &defSpeedNewSpeed)
    }
    
    @IBAction func exitAction(_ sender: Any) {
        AppSettings.shared.speed = defSpeedNewSpeed[0]
        sequeExit()
    }
    
    @IBAction func bottomExitAction(_ sender: Any) {
        AppSettings.shared.speed = defSpeedNewSpeed[0]
        sequeExit()
    }

    @IBAction func settingsDoneAction(_ sender: Any) {
        if enterName.text == "" {
            AppSettings.shared.name = AppSettings.shared.name
        } else {
            AppSettings.shared.name = enterName.text ?? AppSettings.shared.name
        }
        delegate?.update(text: AppSettings.shared.name)
        sequeExit()
    }
    
}
