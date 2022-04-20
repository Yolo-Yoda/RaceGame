import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: FirstViewControllerDelegate?

    var obstaclesArray : [String] = []
    
    var variationsOfObstacles : [Int] = [1, 2]
    
    var variationsOfRoads : [Int] = [1, 2, 3]
    
    var score = 0
    
    let gameSpeed : [Double] = [0]
    
    var gameEnds = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var road: UIImageView!
    
    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var obstacleImage: UIImageView!
    
    @IBOutlet weak var secondObstacleImage: UIImageView!
    
    @IBOutlet weak var crash: UIImageView!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
    }
    // MARK: - Public methods
    
    func scoreCount() {
        score += 1
        scoreLabel.text = "SCORE: \(score)"
    }
    
    func makeObstacklesArrayOfSettings() {
        if AppSettings.shared.obstacles.smallCar == "Yes" {
            obstaclesArray.append("ObstacleSmallCar")
        }
        if AppSettings.shared.obstacles.bigcar == "Yes" {
            obstaclesArray.append("ObstacleBigCar")
        }
        if AppSettings.shared.obstacles.motocycle == "Yes" {
            obstaclesArray.append("ObstacleMotocycle")
        }
        if AppSettings.shared.obstacles.tree == "Yes" {
            obstaclesArray.append("ObstacleTree")
        }
        if AppSettings.shared.obstacles.conus == "Yes" {
            obstaclesArray.append("ObstacleConus")
        }
        if AppSettings.shared.obstacles.rock == "Yes" {
            obstaclesArray.append("ObstacleRock")
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
        choseCountAndRoadsObstaclesAndMakeAnimation()
    }
    
    func choseCountAndRoadsObstaclesAndMakeAnimation() {
        let countOfObstacles = variationsOfObstacles.randomElement()
        if countOfObstacles == 1{
            let road1 = variationsOfRoads.randomElement()
            let coordinatesRoad = MakeRoad(road1 ?? 1)
            makeFirstPartFalingAnimationOneObstacle(coordinatesRoad)
        } else if countOfObstacles == 2 {
            let road1 = variationsOfRoads.randomElement()
            let road2 = variationsOfRoads.filter { $0 != road1 }.randomElement()!
            let coordinatesRoad1 = MakeRoad(road1 ?? 1)
            let coordinatesRoad2 = MakeRoad(road2)
            makeFirstDoubleFalingAnimation(coordinatesRoad1, coordinatesRoad2)
        }
    }
    
    func mainSettings() -> (screenWidght: CGFloat, widthObstacle: CGFloat,heightObstacle: CGFloat,
                            checkCarDamage: CGFloat,screenHeight: CGFloat, widthCar: CGFloat,
                            heightCar: CGFloat, widthCrash: CGFloat, heightCrash: CGFloat) {
        let screenWidght = view.frame.width
        let screenHeight = view.frame.height
        let widthCar = (screenWidght - 80) / 3
        let heightCar = widthCar * 2.15
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let widthCrash = (screenWidght - 100) / 3
        let heightCrash = widthCrash * 0.75
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        return (screenWidght, widthObstacle, heightObstacle, checkCarDamage,
                screenHeight,widthCar, heightCar, widthCrash, heightCrash)
    }
    
    func MakeRoad(_ countRoadCoordinates: Int) -> CGFloat {
        let mainSettings = mainSettings()
        if countRoadCoordinates == 1 {
            return (mainSettings.screenWidght/3)/2 - mainSettings.widthObstacle/2
        }else if countRoadCoordinates == 2 {
            return mainSettings.screenWidght/2 - mainSettings.widthObstacle/2
        } else {
            return mainSettings.screenWidght - (mainSettings.screenWidght/3)/2 - mainSettings.widthObstacle/2
        }
    }
    
    func makeRandomObstacles(_ count: Int) {
        let obstackleName = obstaclesArray.randomElement()
        obstacleImage.image = UIImage(named: obstackleName ?? "ObstacleRock")
        self.view.addSubview(obstacleImage)
        if count == 2 {
            let obstackleName = obstaclesArray.randomElement()
            secondObstacleImage.image = UIImage(named: obstackleName ?? "ObstacleRock")
            self.view.addSubview(secondObstacleImage)
        }
    }
    func makeCar() {
        let mainSettings = mainSettings()
        carImage.frame = CGRect(x: mainSettings.screenWidght/2 - mainSettings.widthCar/2,
                                y: mainSettings.screenHeight - mainSettings.heightCar - 20,
                                width: mainSettings.widthCar,
                                height: mainSettings.heightCar)
        let carImageInAssets = takeCarColor()
        carImage.image = UIImage(named: carImageInAssets)
        self.view.addSubview(carImage)
    }
    
    func makeCrash(_ x: CGFloat, _ y: CGFloat) {
        let mainSettings = mainSettings()
        crash.frame = CGRect(x: x - mainSettings.widthCrash/2, y: y - mainSettings.heightCrash/2,
                             width: mainSettings.widthCrash, height: mainSettings.heightCrash)
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
    func makeFirstPartFalingAnimationOneObstacle(_ cordinatesX: CGFloat) {
        let speedOfTheGame = takeCarSpeed()
        let mainSettings = mainSettings()
        makeRandomObstacles(1)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX,
                                              y: 0 - mainSettings.heightObstacle - 20,
                                              width: mainSettings.widthObstacle,
                                              height: mainSettings.heightObstacle)
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: speedOfTheGame[0], delay: 0, options: .curveLinear) {
                self.obstacleImage.frame = CGRect(x: cordinatesX,
                                                  y: mainSettings.checkCarDamage,
                                                  width: mainSettings.widthObstacle,
                                                  height: mainSettings.heightObstacle)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.checkDamage(cordinatesX: cordinatesX)
            }
        }
    }

    func makeSecondPartFalingAnimationOneObstacle(_ cordinatesX: CGFloat) {
        let speedOfTheGame = takeCarSpeed()
        let mainSettings = mainSettings()
        firstCheckOnBoardCrash(1)
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX,
                                              y: mainSettings.checkCarDamage,
                                              width: mainSettings.widthObstacle,
                                              height: mainSettings.heightObstacle)
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: speedOfTheGame[1], delay: 0, options: .curveLinear) {
                self.obstacleImage.frame = CGRect(x: cordinatesX,
                                                  y: self.carImage.frame.maxY + 10,
                                                  width: mainSettings.widthObstacle,
                                                  height: mainSettings.heightObstacle)
                self.view.layoutIfNeeded()
            } completion: { _ in
                if !self.gameEnds {
                    self.scoreCount()
                    self.choseCountAndRoadsObstaclesAndMakeAnimation()
                }
            }
        }
    }
    
    // MARK: -AnimationOf2Falls
    func makeFirstDoubleFalingAnimation(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat) {
        let speedOfTheGame = takeCarSpeed()
        let mainSettings = mainSettings()
        makeRandomObstacles(2)
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX1,
                                              y: 0 - mainSettings.heightObstacle - 20,
                                              width: mainSettings.widthObstacle,
                                              height: mainSettings.heightObstacle)
            self.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                    y: 0 - mainSettings.heightObstacle - 20,
                                                    width: mainSettings.widthObstacle,
                                                    height: mainSettings.heightObstacle)
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: speedOfTheGame[0], delay: 0, options: .curveLinear) {
                self.obstacleImage.frame = CGRect(x: cordinatesX1,
                                                  y: mainSettings.checkCarDamage,
                                                  width: mainSettings.widthObstacle,
                                                  height: mainSettings.heightObstacle)
                self.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                        y: mainSettings.checkCarDamage,
                                                        width: mainSettings.widthObstacle,
                                                        height: mainSettings.heightObstacle)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.checkDamage(cordinatesX1: cordinatesX1, cordinatesX2: cordinatesX2, isTwoObstacle: true)
            }
        }
    }
    
    func makeSecondPartFalingAnimationTwoObstacle(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat) {
        let speedOfTheGame = takeCarSpeed()
        let mainSettings = mainSettings()
        firstCheckOnBoardCrash(2)
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) { [weak self] in
            self?.obstacleImage.frame = CGRect(x: cordinatesX1,
                                               y: mainSettings.checkCarDamage,
                                               width: mainSettings.widthObstacle,
                                               height: mainSettings.heightObstacle)
            self?.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                     y: mainSettings.checkCarDamage,
                                                     width: mainSettings.widthObstacle,
                                                     height: mainSettings.heightObstacle)
            self?.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: speedOfTheGame[1], delay: 0, options: .curveLinear) { [weak self] in
                self?.obstacleImage.frame = CGRect(x: cordinatesX1,
                                                   y: self?.view.frame.height ?? 0,
                                                   width: mainSettings.widthObstacle,
                                                   height: mainSettings.heightObstacle)
                self?.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                         y: self?.view.frame.height ?? 0,
                                                         width: mainSettings.widthObstacle,
                                                         height: mainSettings.heightObstacle)
                self?.view.layoutIfNeeded()
            } completion: { _ in
                if !self.gameEnds {
                    self.choseCountAndRoadsObstaclesAndMakeAnimation()
                    self.scoreCount()
                }
            }
        }
    }
    
    // MARK: - Private methods
    private func sequeExit() {
        dismiss(animated: true, completion: nil)
        let a = ResultRace(name: AppSettings.shared.name, score: score, date: .now)
        AppSettings.shared.countGames += 1
        AppSettings.shared.lastScore = score
        AppSettings.shared.timeOfLastRecord = a.getStringFromDate()
        delegate?.updateCountGames(text: AppSettings.shared.countGames)
        delegate?.updateScore(text: score)
        delegate?.addTestTime(time: AppSettings.shared.timeOfLastRecord, score: AppSettings.shared.lastScore)
    }
    
    private func checkDamage(
        cordinatesX: CGFloat = 0,
        cordinatesX1: CGFloat = 0,
        cordinatesX2: CGFloat = 0,
        isTwoObstacle: Bool = false
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
                makeSecondPartFalingAnimationTwoObstacle(cordinatesX1, cordinatesX2)
            } else {
                makeSecondPartFalingAnimationOneObstacle(cordinatesX)
            }
        }
    }
    
    private func firstCheckOnBoardCrash (_ countOfObstackles: Int) {
        let speedOfTheGame = takeCarSpeed()
        if countOfObstackles == 1{
            DispatchQueue.main.asyncAfter(deadline: .now() + speedOfTheGame[2]) { [weak self] in
                let epsX = ((self?.carImage.frame.midX) ?? 0) - ((self?.obstacleImage.frame.midX) ?? 0)
                if epsX < 1 && epsX > -1 {
                    self?.lose()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + speedOfTheGame[2]) { [weak self] in
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
        makeFirstDoubleFalingAnimation(MakeRoad(1), MakeRoad(3))
        delegate?.updateScore(text: score)
        score = 0
        scoreLabel.text = "SCORE: \(score)"
    }
    
    @objc private func leftswipedByUser (_ gesture:UISwipeGestureRecognizer) {
        let mainSettings = mainSettings()
        if carImage.frame.origin.x > 0 + mainSettings.widthCar { carImage.frame = CGRect(
            x: carImage.frame.origin.x - mainSettings.screenWidght/3, y: carImage.frame.origin.y,
            width: mainSettings.widthCar, height: mainSettings.heightCar)
        }
    }
    
    @objc private func rightswipedByUser (_ gesture:UISwipeGestureRecognizer) {
        let mainSettings = mainSettings()
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
        self.present(alert, animated: true, completion: nil)
    }
}
