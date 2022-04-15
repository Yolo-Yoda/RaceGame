import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Public properties
    
    weak var delegate: FirstViewControllerDelegate?
    
    var obstaclesArray : [String] = []
    
    var variationsOfObstacles : [Int] = [1, 2]
    
    var variationsOfRoads : [Int] = [1, 2, 3]
    
    var paused = false
    
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
    
    func makeFirstPartFalingAnimationOneObstacle(_ cordinatesX: CGFloat) {
        let speedOfTheGame = takeCarSpeed()
        let screenWidght = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        makeRandomObstacles()
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX,
                                              y: 0 - heightObstacle - 20,
                                              width: widthObstacle,
                                              height: heightObstacle)
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: speedOfTheGame[0], delay: 0, options: .curveLinear) {
                self.obstacleImage.frame = CGRect(x: cordinatesX,
                                                  y: checkCarDamage,
                                                  width: widthObstacle,
                                                  height: heightObstacle)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.checkDamage(cordinatesX: cordinatesX)
            }
        }
    }
    
    func makeSecondPartFalingAnimationOneObstacle(_ cordinatesX: CGFloat) {
        let speedOfTheGame = takeCarSpeed()
        let screenWidght = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speedOfTheGame[2]) { [weak self] in
            if Int((self?.carImage.frame.midX ?? 0 )) - 1 == Int((self?.obstacleImage.frame.midX ?? 0)) ||
                Int((self?.carImage.frame.midX ?? 0))  == Int((self?.obstacleImage.frame.midX ?? 0)) ||
                Int((self?.carImage.frame.midX ?? 0)) + 1 == Int((self?.obstacleImage.frame.midX ?? 0)) {
                self?.lose1()
                self?.loseAllert()
                self?.gameEnds = true
            }
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX,
                                              y: checkCarDamage,
                                              width: widthObstacle,
                                              height: heightObstacle)
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: speedOfTheGame[1], delay: 0, options: .curveLinear) {
                self.obstacleImage.frame = CGRect(x: cordinatesX,
                                                  y: self.carImage.frame.maxY + 10,
                                                  width: widthObstacle,
                                                  height: heightObstacle)
                self.view.layoutIfNeeded()
            } completion: { _ in
                if !self.gameEnds {
                    self.scoreCount()
                    self.choseCountAndRoadsObstaclesAndMakeAnimation()
                }
            }
        }
    }
    
    func makeFirstDoubleFalingAnimation(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat) {
        let speedOfTheGame = takeCarSpeed()
        let screenWidght = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        makeRandomObstacles()
        makeSecondRandomObstacles()
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX1,
                                              y: 0 - heightObstacle - 20,
                                              width: widthObstacle,
                                              height: heightObstacle)
            self.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                    y: 0 - heightObstacle - 20,
                                                    width: widthObstacle,
                                                    height: heightObstacle)
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: speedOfTheGame[0], delay: 0, options: .curveLinear) {
                
                self.obstacleImage.frame = CGRect(x: cordinatesX1,
                                                  y: checkCarDamage,
                                                  width: widthObstacle,
                                                  height: heightObstacle)
                self.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                        y: checkCarDamage,
                                                        width: widthObstacle,
                                                        height: heightObstacle)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.checkDamage(cordinatesX1: cordinatesX1, cordinatesX2: cordinatesX2, isTwoObstacle: true)
            }
        }
    }
    
    func makeSecondPartFalingAnimationTwoObstacle(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat) {
        let speedOfTheGame = takeCarSpeed()
        let screenWidght = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        DispatchQueue.main.asyncAfter(deadline: .now() + speedOfTheGame[2]) { [weak self] in
            if Int((self?.carImage.frame.midX ?? 0 )) - 1 == Int((self?.obstacleImage.frame.midX ?? 0)) ||
                Int((self?.carImage.frame.midX ?? 0))  == Int((self?.obstacleImage.frame.midX ?? 0)) ||
                Int((self?.carImage.frame.midX ?? 0)) + 1 == Int((self?.obstacleImage.frame.midX ?? 0)) {
                self?.lose1()
                self?.loseAllert()
                self?.gameEnds = true
            } else if Int((self?.carImage.frame.midX ?? 0)) - 1 == Int((self?.secondObstacleImage.frame.midX ?? 0)) ||
                        Int((self?.carImage.frame.midX ?? 0))  == Int((self?.secondObstacleImage.frame.midX ?? 0)) ||
                        Int((self?.carImage.frame.midX ?? 0)) + 1 == Int((self?.secondObstacleImage.frame.midX ?? 0)) {
                self?.lose1()
                self?.loseAllert()
                self?.gameEnds = true
            }
        }
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) { [weak self] in
            self?.obstacleImage.frame = CGRect(x: cordinatesX1,
                                               y: checkCarDamage,
                                               width: widthObstacle,
                                               height: heightObstacle)
            self?.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                     y: checkCarDamage,
                                                     width: widthObstacle,
                                                     height: heightObstacle)
            self?.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: speedOfTheGame[1], delay: 0, options: .curveLinear) { [weak self] in
                
                self?.obstacleImage.frame = CGRect(x: cordinatesX1,
                                                   y: self?.carImage.frame.maxY ?? 0 + 10,
                                                   width: widthObstacle,
                                                   height: heightObstacle)
                self?.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                         y: self?.carImage.frame.maxY ?? 0 + 10,
                                                         width: widthObstacle,
                                                         height: heightObstacle)
                self?.view.layoutIfNeeded()
            } completion: { _ in
                if !self.gameEnds {
                    self.choseCountAndRoadsObstaclesAndMakeAnimation()
                    self.scoreCount()
                }
            }
        }
    }
    
    func MakeRoad(_ countRoadCoordinates: Int) -> CGFloat {
        let screenWidght: CGFloat = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        if countRoadCoordinates == 1 {
            return (screenWidght/3)/2 - widthObstacle/2
        }else if countRoadCoordinates == 2 {
            return screenWidght/2 - widthObstacle/2
        } else {
            return screenWidght - (screenWidght/3)/2 - widthObstacle/2
        }
    }
    
    func makeRandomObstacles() {
        let obstackleName = obstaclesArray.randomElement()
        obstacleImage.image = UIImage(named: obstackleName ?? "ObstacleRock")
        self.view.addSubview(obstacleImage)
    }
    
    func makeSecondRandomObstacles() {
        let obstackleName = obstaclesArray.randomElement()
        secondObstacleImage.image = UIImage(named: obstackleName ?? "ObstacleRock")
        self.view.addSubview(secondObstacleImage)
    }
    
    func makeCar() {
        let screenWidght = view.frame.width
        let screenHeight = view.frame.height
        let widthCar = (screenWidght - 80) / 3
        let heightCar = widthCar * 2.15
        carImage.frame = CGRect(x: screenWidght/2 - widthCar/2,
                                y: screenHeight - heightCar - 20,
                                width: widthCar,
                                height: heightCar)
        let carImageInAssets = takeCarColor()
        carImage.image = UIImage(named: carImageInAssets)
        self.view.addSubview(carImage)
    }
    
    func makeCrash(_ x: CGFloat, _ y: CGFloat) {
        let screenWidght = view.frame.width
        let widthCrash = (screenWidght - 100) / 3
        let heightCrash = widthCrash * 0.75
        crash.frame = CGRect(x: x - widthCrash/2,
                             y: y - heightCrash/2,
                             width: widthCrash,
                             height: heightCrash)
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
    
    // MARK: - Private methods
    
    private func sequeExit() {
        dismiss(animated: true, completion: nil)
        AppSettings.shared.countGames += 1
        delegate?.updateCountGames(text: AppSettings.shared.countGames)
        delegate?.updateScore(text: score)
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
            self.carImage.isHidden = false
            self.obstacleImage.isHidden = false
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
            self.carImage.isHidden = false
            self.obstacleImage.isHidden = true
            self.secondObstacleImage.isHidden = false
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
    
    private func lose() {
        self.crash.isHidden = false
        self.carImage.isHidden = false
        self.obstacleImage.isHidden = true
        self.secondObstacleImage.isHidden = true
        self.loseAllert()
    }
    
    private func lose1() {
        self.crash.isHidden = true
        self.carImage.isHidden = true
        self.obstacleImage.isHidden = true
        self.secondObstacleImage.isHidden = true
        self.loseAllert()
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
        let screenWidght = view.frame.width
        let widthCar = (screenWidght - 80) / 3
        let heightCar = widthCar * 2.15
        if carImage.frame.origin.x > 0 + widthCar { carImage.frame = CGRect(
            x: carImage.frame.origin.x - screenWidght/3,
            y: carImage.frame.origin.y,
            width: widthCar,
            height: heightCar)
        }
    }
    
    @objc private func rightswipedByUser (_ gesture:UISwipeGestureRecognizer) {
        let screenWidght = view.frame.width
        let widthCar = (screenWidght - 80) / 3
        let heightCar = widthCar * 2.15
        if carImage.frame.origin.x < screenWidght - widthCar - 40 { carImage.frame = CGRect(
            x: carImage.frame.origin.x + screenWidght/3,
            y: carImage.frame.origin.y,
            width: widthCar,
            height: heightCar)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func backAction(_ sender: Any) {
        paused = true
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
