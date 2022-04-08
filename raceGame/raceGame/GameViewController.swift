import UIKit

class GameViewController: UIViewController {
    
    // MARK: - Public properties
    
    var obstaclesArray : [String] = []
    
    var variationsOfObstacles : [Int] = [1, 2]
    
    var variationsOfRoads : [Int] = [1, 2, 3]
    
    var paused = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var road: UIImageView!
    
    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var obstacleImage: UIImageView!
    
    @IBOutlet weak var secondObstacleImage: UIImageView!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSettings()
        CheckingCarCrashes()
    }
    
    // MARK: - Public methods
    
    func defaultSettings() {
        makeCar()
        leftSwipe()
        rightSwipe()
        choseCountAndRoadsObstaclesAndMakeAnimation()
    }
    
    func choseCountAndRoadsObstaclesAndMakeAnimation() {
        let countOfObstacles = variationsOfObstacles.randomElement()
        if countOfObstacles == 1{
            let road1 = variationsOfRoads.randomElement()
            let coordinatesRoad = MakeRoad(road1 ?? 1)
            makeRandomObstacles()
            makeFalingAnimation(coordinatesRoad)
        } else if countOfObstacles == 2 {
            let road1 = variationsOfRoads.randomElement()
            let road2 = variationsOfRoads.filter { $0 != road1 }.randomElement()!
            let coordinatesRoad1 = MakeRoad(road1 ?? 1)
            let coordinatesRoad2 = MakeRoad(road2)
            makeRandomObstacles()
            makeSecondRandomObstacles()
            makeDoubleFalingAnimation(coordinatesRoad1, coordinatesRoad2)
        }
    }
    
    func makeFalingAnimation(_ cordinatesX: CGFloat) {
        let screenWidght = road.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        makeRandomObstacles()
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX,
                                              y: 0 - heightObstacle - 20,
                                              width: widthObstacle,
                                              height: heightObstacle)
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 5, delay: 0, options: .curveLinear) {
                self.obstacleImage.frame = CGRect(x: cordinatesX,
                                                  y: self.view.frame.height + heightObstacle + 10,
                                                  width: widthObstacle,
                                                  height: heightObstacle)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.choseCountAndRoadsObstaclesAndMakeAnimation()
            }
        }
    }
    
    func makeDoubleFalingAnimation(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat) {
        let screenWidght = road.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
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
            UIView.animate(withDuration: 5, delay: 0, options: .curveLinear) {
                
                self.obstacleImage.frame = CGRect(x: cordinatesX1,
                                                  y: self.view.frame.height + heightObstacle + 10,
                                                  width: widthObstacle,
                                                  height: heightObstacle)
                self.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                        y: self.view.frame.height + heightObstacle + 10,
                                                        width: widthObstacle,
                                                        height: heightObstacle)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.choseCountAndRoadsObstaclesAndMakeAnimation()
            }
        }
    }
    
    func makeCar () {
        let screenWidght = view.frame.width
        let screenHeight = view.frame.height
        let widthCar = (screenWidght - 80) / 3
        let heightCar = widthCar * 2.15
        
        carImage.frame = CGRect(x: screenWidght/2 - widthCar/2,
                                y: screenHeight - heightCar - 20,
                                width: widthCar,
                                height: heightCar)
        
        carImage.image = UIImage(named: "whiteCar")
        
        self.view.addSubview(carImage)
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
    
    func MakeRoad(_ countRoadCoordinates: Int) -> CGFloat {
        let screenWidght: CGFloat = road.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        //let heightObstacle = widthObstacle * 0.8
        if countRoadCoordinates == 1 {
            return (screenWidght/3)/2 - widthObstacle/2
        }else if countRoadCoordinates == 2 {
            return screenWidght/2 - widthObstacle/2
        } else {
            return screenWidght - (screenWidght/3)/2 - widthObstacle/2
        }
    }
    
    func getObstaclesArray() {
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
    
    func startCheking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.startCheking()
        }
    }
    
    func CheckingCarCrashes() {
        var stackofFrames: [CGFloat] = [carImage.frame.midX, carImage.frame.minY,
                                        obstacleImage.frame.midX, obstacleImage.frame.origin.y,
                                        secondObstacleImage.frame.midX, secondObstacleImage.frame.midY]
        if (stackofFrames[0] == stackofFrames[2] && stackofFrames[1] == stackofFrames[3]) || (stackofFrames[0] == stackofFrames[4] && stackofFrames[1] == stackofFrames[5]) {
            paused = true
        }
        
        print(stackofFrames)
        
        stackofFrames.removeAll()
        
        if paused {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.CheckingCarCrashes()
        }
    }
    
    
    // MARK: - Private methods
    
    private func sequeExit() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func leftswipedByUser (_ gesture:UISwipeGestureRecognizer) {
        
        let screenWidght = view.frame.width
        let widthCar = (screenWidght - 80) / 3
        let heightCar = widthCar * 2.15
        
        if carImage.frame.origin.x > 5 { carImage.frame = CGRect(
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
        
        if carImage.frame.origin.x < screenWidght - 55 { carImage.frame = CGRect(
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
}
