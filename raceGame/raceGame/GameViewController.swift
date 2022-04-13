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
        let screenWidght = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        makeRandomObstacles()
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX,
                                              y: 0 - heightObstacle - 20,
                                              width: widthObstacle,
                                              height: heightObstacle)
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
                self.obstacleImage.frame = CGRect(x: cordinatesX,
                                                  y: checkCarDamage,
                                                  width: widthObstacle,
                                                  height: heightObstacle)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                if Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) - 1 ||
                    Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) ||
                    Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) + 1 &&
                    Int(self.carImage.frame.minY) == Int(self.obstacleImage.frame.maxY) {
                    print("DAMAGE")
                    self.loseAllert()
                } else {
                    
                    self.makeSecondPartFalingAnimationOneObstacle(cordinatesX)
                }
            }
        }
    }
    func makeSecondPartFalingAnimationOneObstacle(_ cordinatesX: CGFloat) {
        let screenWidght = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if Int((self.carImage.frame.midX )) - 1 == Int((self.obstacleImage.frame.midX)) ||
                Int((self.carImage.frame.midX))  == Int((self.obstacleImage.frame.midX)) ||
                Int((self.carImage.frame.midX)) + 1 == Int((self.obstacleImage.frame.midX)) {
                print("damaged2")
                self.loseAllert()
            }
        }
        print(carImage.frame.midX, obstacleImage.frame.midX)
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
            self.obstacleImage.frame = CGRect(x: cordinatesX,
                                              y: checkCarDamage,
                                              width: widthObstacle,
                                              height: heightObstacle)
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
                self.obstacleImage.frame = CGRect(x: cordinatesX,
                                                  y: self.carImage.frame.maxY,
                                                  width: widthObstacle,
                                                  height: heightObstacle)
                
                self.view.layoutIfNeeded()
            } completion: { _ in
                
                self.choseCountAndRoadsObstaclesAndMakeAnimation()
                
            }
        }
    }
    
    func makeFirstDoubleFalingAnimation(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat) {
        let screenWidght = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        makeRandomObstacles()
        makeSecondRandomObstacles()
        
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
            UIView.animate(withDuration: 2, delay: 0, options: .curveLinear) {
                
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
                if Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) - 1 ||
                    Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) ||
                    Int(self.carImage.frame.midX) == Int(self.obstacleImage.frame.midX) + 1 &&
                    Int(self.carImage.frame.minY) == Int(self.obstacleImage.frame.maxY) {
                    print("DAMAGE")
                    self.loseAllert()
                } else if Int(self.carImage.frame.midX) == Int(self.secondObstacleImage.frame.midX) - 1 ||
                            Int(self.carImage.frame.midX) == Int(self.secondObstacleImage.frame.midX) ||
                            Int(self.carImage.frame.midX) == Int(self.secondObstacleImage.frame.midX) + 1 &&
                            Int(self.carImage.frame.minY) == Int(self.secondObstacleImage.frame.maxY) {
                    print("DAMAGE")
                    self.loseAllert()
                } else {
                    self.makeSecondPartFalingAnimationTwoObstacle(cordinatesX1, cordinatesX2)
                }
            }
        }
    }
    func makeSecondPartFalingAnimationTwoObstacle(_ cordinatesX1: CGFloat, _ cordinatesX2: CGFloat) {
        let screenWidght = view.frame.width
        let widthObstacle = (screenWidght - 80) / 3
        let heightObstacle = widthObstacle * 0.8
        let checkCarDamage = self.carImage.frame.minY - self.obstacleImage.frame.height + 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if Int((self.carImage.frame.midX )) - 1 == Int((self.obstacleImage.frame.midX)) ||
                Int((self.carImage.frame.midX))  == Int((self.obstacleImage.frame.midX)) ||
                Int((self.carImage.frame.midX)) + 1 == Int((self.obstacleImage.frame.midX)) {
                print("damaged2")
                self.loseAllert()
            } else if Int((self.carImage.frame.midX )) - 1 == Int((self.secondObstacleImage.frame.midX)) ||
                        Int((self.carImage.frame.midX))  == Int((self.secondObstacleImage.frame.midX)) ||
                        Int((self.carImage.frame.midX)) + 1 == Int((self.secondObstacleImage.frame.midX)) {
                print("damaged2")
                self.loseAllert()
            }
        }
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveLinear) {
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
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
                
                self.obstacleImage.frame = CGRect(x: cordinatesX1,
                                                  y: self.carImage.frame.maxY + 10,
                                                  width: widthObstacle,
                                                  height: heightObstacle)
                self.secondObstacleImage.frame = CGRect(x: cordinatesX2,
                                                        y: self.carImage.frame.maxY + 10,
                                                        width: widthObstacle,
                                                        height: heightObstacle)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.choseCountAndRoadsObstaclesAndMakeAnimation()
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
        
        carImage.image = UIImage(named: "whiteCar")
        self.view.addSubview(carImage)
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
}
