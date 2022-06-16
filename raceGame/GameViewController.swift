import UIKit
import CoreMotion
import FirebaseCrashlytics
import FirebaseAnalytics

class GameViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: FirstViewControllerDelegate?
    
    var obstaclesArray : [String] = []
    
    var variationsOfObstacles : [Int] = [1, 2]
    
    var variationsOfRoads : [Int] = [1, 2, 3]
    
    let speedArray : [Double] = [0]
    
    var score = 0
    
    let gameSpeed : [Double] = [0]
    
    var gameEnds = false
    
    var isMainSettingsSets = false
    
    lazy var mainSettings: MainSettings = updateMainSettings()

    var speedOfAnimation : [Double] = []
    
    let motionManager = CMMotionManager()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var road: UIImageView!
    
    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var obstacleImage: UIImageView!
    
    @IBOutlet weak var secondObstacleImage: UIImageView!
    
    @IBOutlet weak var crash: UIImageView!
    
    var imageNames = [
        "ObstacleSmallCar",
        "ObstacleBigCar",
        "ObstacleMotocycle",
        "ObstacleTree",
        "ObstacleConus",
        "ObstacleRock"
    ]
    
    let viewModel = RecordViewModel()
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
        speedOfAnimation = takeCarSpeed()
        motion()
    }
    
   
    
    func leftTurn () {
        guard carImage.frame.origin.x > 0 + mainSettings.widthCar else {
            let userInfo = [
              NSLocalizedDescriptionKey: NSLocalizedString("Left turn failed", comment: ""),
              NSLocalizedFailureReasonErrorKey: NSLocalizedString("Car break left screen view", comment: ""),
              "ProductID": "Bundle version: \(Bundle.version())",
              "View": "GameView"
            ]
            let error = NSError.init(domain: NSCocoaErrorDomain,
                                     code: -1001,
                                     userInfo: userInfo)
            Crashlytics.crashlytics().record(error: error)
            return }
        carImage.frame = CGRect(
            x: carImage.frame.origin.x - mainSettings.screenWidght/3,
            y: carImage.frame.origin.y,
            width: mainSettings.widthCar,
            height: mainSettings.heightCar)
    }
    
    func rightTurn() {
        guard carImage.frame.origin.x < mainSettings.screenWidght - mainSettings.widthCar - 40 else {
            let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Right turn failed", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Car break right screen view", comment: ""),
            "ProductID": "Bundle version: \(Bundle.version())",
            "View": "GameView"
          ]
          let error = NSError.init(domain: NSCocoaErrorDomain,
                                   code: -1001,
                                   userInfo: userInfo)
          Crashlytics.crashlytics().record(error: error)
          return }
        carImage.frame = CGRect(
            x: carImage.frame.origin.x + mainSettings.screenWidght/3,
            y: carImage.frame.origin.y,
            width: mainSettings.widthCar,
            height: mainSettings.heightCar)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isMainSettingsSets {
            obstacleImage.layoutIfNeeded()
            self.mainSettings = updateMainSettings()
            isMainSettingsSets = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        choseCountAndRoadsObstaclesAndMakeAnimation()
    }
    // MARK: - Public methods
    
    func scoreCount() {
        score += 1
        scoreLabel.text = "SCORE: \(score)"
    }
    
    func makeObstacklesArrayOfSettings() {
        for index in 0..<imageNames.count {
            if AppSettings.shared.obstaclesArray[index] {
                obstaclesArray.append(imageNames[index])
            }
        }
    }
    
    func takeCarColor() -> String {
        let changedColor = AppSettings.shared.carColor
        switch changedColor {
        case "white":
            return "whiteCar"
        case "red":
            return "redCar"
        case "yellow":
            return "yellowCar"
        default:
            return "whiteCar"
        }
    }
    
    func takeCarSpeed() -> [Double] {
        let changedChangedSpeed = AppSettings.shared.speed
        switch changedChangedSpeed {
        case 60 :
            return [3, 1.5, 1.2]
        case 120 :
            return [2, 1, 0.8]
        case 180 :
            return [1, 0.5, 0.4]
        default:
            return [2, 1, 0.8]
        }
    }
    
    func defaultSettings() {
        makeCar()
        leftSwipe()
        rightSwipe()
        makeObstacklesArrayOfSettings()
    }
    
    func choseCountAndRoadsObstaclesAndMakeAnimation() {
        let countOfObstacles = variationsOfObstacles.randomElement()
        
        let road1 = variationsOfRoads.randomElement()
        let coordinatesRoad1 = MakeRoad(road1 ?? 1)
        for index in 0..<speedOfAnimation.count{
            speedOfAnimation[index] = max(0.1, speedOfAnimation[index] * 0.95)
        }
        switch countOfObstacles {
        case 1:
            makeFirstPartFalingAnimationOneObstacle(coordinatesRoad1, speedOfAnimation)
        case 2:
            let road2 = variationsOfRoads.filter { $0 != road1 }.randomElement()!
            let coordinatesRoad2 = MakeRoad(road2)
            makeFirstDoubleFalingAnimation(coordinatesRoad1, coordinatesRoad2, speedOfAnimation)
        default:
            break
        }
    }
    
    func MakeRoad(_ countRoadCoordinates: Int) -> CGFloat {
        switch countRoadCoordinates {
        case 1:
            return (mainSettings.screenWidght / 3) / 2
                    - mainSettings.widthObstacle / 2
        case 2:
            return mainSettings.screenWidght / 2
                    - mainSettings.widthObstacle / 2
        default:
            return mainSettings.screenWidght
                    - (mainSettings.screenWidght / 3) / 2
                    - mainSettings.widthObstacle / 2
        }
    }
    
    func makeRandomObstacles(_ count: Int) {
        obstacleImage.image = getRandomObstacle()
        self.view.addSubview(obstacleImage)
        if count == 2 {
            secondObstacleImage.image = getRandomObstacle()
            self.view.addSubview(secondObstacleImage)
        }
    }
    
    func makeCar() {
        carImage.frame = CGRect(x: mainSettings.screenWidght/2 - mainSettings.widthCar/2,
                                y: mainSettings.screenHeight - mainSettings.heightCar - 20,
                                width: mainSettings.widthCar,
                                height: mainSettings.heightCar)
        let carImageInAssets = takeCarColor()
        carImage.image = UIImage(named: carImageInAssets)
        self.view.addSubview(carImage)
    }
    
    func makeCrash(_ x: CGFloat, _ y: CGFloat) {
        crash.frame = CGRect(
            x: x - mainSettings.widthCrash / 2,
            y: y - mainSettings.heightCrash / 2,
            width: mainSettings.widthCrash,
            height: mainSettings.heightCrash
        )
        
        crash.image = UIImage(named: "crash")
        self.view.addSubview(crash)
    }
    
    func leftSwipe() {
        let leftswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(leftswipedByUser(_:)))
        leftswipeGesture.direction = .left
        self.view.addGestureRecognizer(leftswipeGesture)
    }
    
    func rightSwipe() {
        let rightswipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(rightswipedByUser(_:)))
        rightswipeGesture.direction = .right
        self.view.addGestureRecognizer(rightswipeGesture)
    }
    
    // MARK: -AnimationOf1Fall
    
    func makeFirstPartFalingAnimationOneObstacle(_ cordinatesX: CGFloat, _ speedOfAnimation: [Double]) {
        let mainSettings = mainSettings
        makeRandomObstacles(1)
        setupFrameOnFirstAnimation(for: &obstacleImage, coordinates: cordinatesX)
        view.layoutIfNeeded()
        UIView.animate(withDuration: speedOfAnimation[0], delay: 0, options: .curveLinear) { [weak self] in
            guard let `self` = self else { return }
            self.animateFrameOnFirstAnimation(for: &self.obstacleImage, coordinates: cordinatesX, mainSettings: mainSettings)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.checkDamage(cordinatesX: cordinatesX, speedOfAnimation: speedOfAnimation)
        }
    }

    func makeSecondPartFalingAnimationOneObstacle(_ cordinatesX: CGFloat, _ speedOfAnimation: [Double]) {
        let mainSettings = mainSettings
        firstCheckOnBoardCrash(1, speedOfAnimation)
        setupSecondFrameOnFirstAnimation(for: &self.obstacleImage, coordinates: cordinatesX)
        view.layoutIfNeeded()
        UIView.animate(withDuration: speedOfAnimation[1], delay: 0, options: .curveLinear) {
            self.animateSecondFrameOnFirstAnimation(for: &self.obstacleImage, coordinates: cordinatesX, mainSettings: mainSettings)
            self.view.layoutIfNeeded()
        } completion: { _ in
            if !self.gameEnds {
                self.scoreCount()
                self.choseCountAndRoadsObstaclesAndMakeAnimation()
            }
        }
    }
    
    // MARK: -AnimationOf2Falls
    func makeFirstDoubleFalingAnimation(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat, _ speedOfAnimation: [Double]) {
        let mainSettings = mainSettings
        makeRandomObstacles(2)
        setupFrameOnFirstAnimation(for: &obstacleImage, coordinates: cordinatesX1)
        setupFrameOnFirstAnimation(for: &secondObstacleImage, coordinates: cordinatesX2)
        view.layoutIfNeeded()
        UIView.animate(withDuration: speedOfAnimation[0], delay: 0, options: .curveLinear) { [weak self] in
            guard let `self` = self else { return }
            self.animateFrameOnFirstAnimation(for: &self.obstacleImage, coordinates: cordinatesX1, mainSettings: mainSettings)
            self.animateFrameOnFirstAnimation(for: &self.secondObstacleImage, coordinates: cordinatesX2, mainSettings: mainSettings)
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.checkDamage(cordinatesX1: cordinatesX1, cordinatesX2: cordinatesX2, isTwoObstacle: true, speedOfAnimation: speedOfAnimation)
        }
    }
    
    func makeSecondPartFalingAnimationTwoObstacle(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat, _ speedOfAnimation: [Double]) {
        let mainSettings = mainSettings
        firstCheckOnBoardCrash(2, speedOfAnimation)
        setupSecondFrameOnFirstAnimation(for: &obstacleImage, coordinates: cordinatesX1)
        setupSecondFrameOnFirstAnimation(for: &secondObstacleImage, coordinates: cordinatesX2)
        view.layoutIfNeeded()
        UIView.animate(withDuration: speedOfAnimation[1], delay: 0, options: .curveLinear) { [weak self] in
            guard let `self` = self else { return }
            self.animateSecondFrameOnFirstAnimation(for: &self.obstacleImage, coordinates: cordinatesX1, mainSettings: mainSettings)
            self.animateSecondFrameOnFirstAnimation(for: &self.secondObstacleImage, coordinates: cordinatesX2, mainSettings: mainSettings)
            self.view.layoutIfNeeded()
        } completion: { _ in
            if !self.gameEnds {
                self.choseCountAndRoadsObstaclesAndMakeAnimation()
                self.scoreCount()
            }
        }
    }

    
    // MARK: - Private methods
    private func getRandomObstacle() -> UIImage? {
        let obstacleName = obstaclesArray.randomElement() ?? "ObstacleRock"
        return UIImage(named: obstacleName)
    }
    
    private func motion() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 0.3
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else { return }
            guard error == nil else {
                Crashlytics.crashlytics().record(error: error!)
                return }
            if data.attitude.roll < -0.3 {
                self?.leftswipedByUser(nil)
            } else if data.attitude.roll > 0.3 {
                self?.rightswipedByUser(nil)
            }
        }
    }
    
    private func updateMainSettings() -> MainSettings {
        let screenWidght = view.frame.width
        let screenHeight = view.frame.height
        let widthCar = (screenWidght - 80) / 3
        let heightCar = widthCar * 2.15
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let widthCrash = (screenWidght - 100) / 3
        let heightCrash = widthCrash * 0.75
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height/2
        
        return MainSettings(
            screenWidght: screenWidght,
            widthObstacle: widthObstacle,
            heightObstacle: heightObstacle,
            checkCarDamage: checkCarDamage,
            screenHeight: screenHeight,
            widthCar: widthCar,
            heightCar: heightCar,
            widthCrash: widthCrash,
            heightCrash: heightCrash
        )
    }
    
    private func setupFrameOnFirstAnimation(for image: inout UIImageView, coordinates: CGFloat) {
        image.frame = CGRect(x: coordinates,
                             y: 0 - mainSettings.heightObstacle - 20,
                             width: mainSettings.widthObstacle,
                             height: mainSettings.heightObstacle)
    }
    
    private func animateFrameOnFirstAnimation(for image: inout UIImageView?, coordinates: CGFloat, mainSettings: MainSettings) {
        image?.frame = CGRect(x: coordinates,
                             y: mainSettings.checkCarDamage,
                             width: mainSettings.widthObstacle,
                             height: mainSettings.heightObstacle)
    }
    private func setupSecondFrameOnFirstAnimation(for image: inout UIImageView, coordinates: CGFloat) {
        image.frame = CGRect(x: coordinates,
                             y: mainSettings.checkCarDamage,
                             width: mainSettings.widthObstacle,
                             height: mainSettings.heightObstacle)
    }
    private func animateSecondFrameOnFirstAnimation(for image: inout UIImageView?, coordinates: CGFloat, mainSettings: MainSettings) {
        image?.frame = CGRect(x: coordinates,
                             y: self.view.frame.height,
                             width: mainSettings.widthObstacle,
                             height: mainSettings.heightObstacle)}
    
    private func sequeExit() {
        dismiss(animated: true, completion: nil)
        
        AppSettings.shared.countGames += 1
        delegate?.addingToArray(resultOfRace: ResultRace(name: AppSettings.shared.name,
                                                         score: score,
                                                         date: .now))
        delegate?.updateCountGames(text: AppSettings.shared.countGames)
        delegate?.updateScore(text: score)
        //getMyResult()
        viewModel.subresults.append(.resultRace(info: ResultRace(name: AppSettings.shared.name,
                                                                 score: score,
                                                                 date: .now)))
        viewModel.dataArrayNew.onNext([ResultRaces(model: .main, items: viewModel.subresults)])
    }
    
    func getMyResult() {
        
        var subResults = [TableViewItem]()
        
        subResults = ([
            .resultRace(info: ResultRace(name: AppSettings.shared.name,score: score,date: .now))
        ])
        viewModel.dataArrayNew.onNext([ResultRaces(model: .main, items: subResults)])

    }
 
    
    private func analyticsManager(ivent: Int) {
        if ivent == 1 {
            Analytics.logEvent("Game_End", parameters: [
              AnalyticsParameterItemID: "Record_of_user",
              AnalyticsParameterItemName: "Record \(score) points",
              AnalyticsParameterContentType: score as Int,
            ])
            
        }
    }
    
    private func checkDamage(
        cordinatesX: CGFloat = 0,
        cordinatesX1: CGFloat = 0,
        cordinatesX2: CGFloat = 0,
        isTwoObstacle: Bool = false,
        speedOfAnimation: [Double]
    ) {
        if Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) - 1 ||
            Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) ||
            Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) + 1 &&
            Int(self.carImage.frame.minY) == Int(self.obstacleImage.frame.maxY) {
            makeCrash(self.carImage.frame.midX, obstacleImage.frame.maxY)
            self.crash.isHidden = false
            self.secondObstacleImage.isHidden = true
            self.loseAllert()
            self.view.layoutIfNeeded()
        } else if isTwoObstacle,
                  Int(self.carImage.frame.midX) == Int(self.secondObstacleImage.frame.midX) - 1 ||
                    Int(self.carImage.frame.midX) == Int(self.secondObstacleImage.frame.midX) ||
                    Int(self.carImage.frame.midX) == Int(self.secondObstacleImage.frame.midX) + 1 &&
                    Int(self.carImage.frame.minY) == Int(self.secondObstacleImage.frame.maxY) {
            makeCrash(self.carImage.frame.midX, self.secondObstacleImage.frame.maxY)
            self.crash.isHidden = false
            self.obstacleImage.isHidden = true
            self.loseAllert()
            self.view.layoutIfNeeded()
        } else {
            if isTwoObstacle {
                makeSecondPartFalingAnimationTwoObstacle(cordinatesX1, cordinatesX2, speedOfAnimation)
            } else {
                makeSecondPartFalingAnimationOneObstacle(cordinatesX, speedOfAnimation)
            }
        }
    }
    
    private func firstCheckOnBoardCrash (_ countOfObstackles: Int,_ speedOfAnimation: [Double]) {
        if countOfObstackles == 1{
            DispatchQueue.main.asyncAfter(deadline: .now() + speedOfAnimation[2]) { [weak self] in
                let epsX = ((self?.carImage.frame.midX) ?? 0) - ((self?.obstacleImage.frame.midX) ?? 0)
                if epsX < 1 && epsX > -1 {
                    self?.lose()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + speedOfAnimation[2]) { [weak self] in
                let epsX = ((self?.carImage.frame.midX) ?? 0) - ((self?.obstacleImage.frame.midX) ?? 0)
                let epsX2 = ((self?.carImage.frame.midX) ?? 0) - ((self?.secondObstacleImage.frame.midX) ?? 0)
                if epsX < 1 && epsX > -1 || epsX2 < 1 && epsX2 > -1 {
                    self?.lose()
                } else if epsX2 < 1 && epsX2 > -1 {
                    self?.lose()
                }
            }
        }
    }
 
    private func lose() {
        self.crash.isHidden = true
        self.carImage.isHidden = true
        self.obstacleImage.isHidden = true
        self.secondObstacleImage.isHidden = true
        self.loseAllert()
        self.gameEnds = true
    }
    
    private func countinueAfterLose() {
        gameEnds = false
        self.carImage.isHidden = false
        self.crash.isHidden = true
        self.obstacleImage.isHidden = false
        self.secondObstacleImage.isHidden = false
        speedOfAnimation = takeCarSpeed()
        makeFirstDoubleFalingAnimation(MakeRoad(1), MakeRoad(3), speedOfAnimation)
        delegate?.updateScore(text: score)
        score = 0
        scoreLabel.text = "SCORE: \(score)"
    }
    
    @objc private func leftswipedByUser (_ gesture:UISwipeGestureRecognizer?) {
        if carImage.frame.origin.x > 0 + mainSettings.widthCar { carImage.frame = CGRect(
            x: carImage.frame.origin.x - mainSettings.screenWidght/3, y: carImage.frame.origin.y,
            width: mainSettings.widthCar, height: mainSettings.heightCar)
        }
    }
    
    @objc private func rightswipedByUser (_ gesture:UISwipeGestureRecognizer?) {
        if carImage.frame.origin.x < mainSettings.screenWidght - mainSettings.widthCar - 40 {
            carImage.frame = CGRect(
                x: carImage.frame.origin.x + mainSettings.screenWidght/3, y: carImage.frame.origin.y,
                width: mainSettings.widthCar, height: mainSettings.heightCar)
        }
    }
    
    // MARK: - IBActions
    @IBAction func backAction(_ sender: Any) {
        sequeExit()
    }
    
    func loseAllert() {
        let alert = UIAlertController(title: "You Lose",
                                      message: "Score: \(score)",
                                      preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "Try again",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
            self.countinueAfterLose()
        }))
        alert.addAction(UIAlertAction(title: "Back to menu",
                                      style: UIAlertAction.Style.destructive,
                                      handler: { _ in
            self.sequeExit()
        }))
        analyticsManager(ivent: 1)
        self.present(alert, animated: true, completion: nil)
    }
}
