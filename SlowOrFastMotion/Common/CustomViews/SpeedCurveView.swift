//
//  SpeedCurveView.swift
//  DownloadingView
//
//  Created by alaattinbulut on 26.05.2021.
//

import UIKit

class SpeedCurveView: UIView {
    
    let topLine: SpeedLineView = {
        let line = SpeedLineView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.speedLabel.text = "5x"
        line.tag = 1
        return line
    }()
    
    let middleLine: SpeedLineView = {
        let line = SpeedLineView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.speedLabel.text = "1x"
        line.tag = 2
        return line
    }()
    
    let bottomLine: SpeedLineView = {
        let line = SpeedLineView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.speedLabel.text = "0.2x"
        line.tag = 3
        return line
    }()
    
    let leftBall: UIView = {
        let ball = UIView()
        ball.translatesAutoresizingMaskIntoConstraints = false
        ball.backgroundColor = .green
        ball.layer.cornerRadius = 20
        ball.tag = 1
        return ball
    }()
    
    let middleBall: UIView = {
        let ball = UIView()
        ball.translatesAutoresizingMaskIntoConstraints = false
        ball.backgroundColor = .green
        ball.layer.cornerRadius = 20
        ball.tag = 2
        return ball
    }()
    
    let rightBall: UIView = {
        let ball = UIView()
        ball.translatesAutoresizingMaskIntoConstraints = false
        ball.backgroundColor = .green
        ball.layer.cornerRadius = 20
        ball.tag = 3
        return ball
    }()
    
    var ballOneSpeed: Double = 1
    var ballTwoSpeed: Double = 1
    var ballThreeSpeed: Double = 1
    var frameNumberForBallTwo: Int = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    private func configureView() {
        addSubview(topLine)
        addSubview(middleLine)
        addSubview(bottomLine)
        addSubview(leftBall)
        addSubview(middleBall)
        addSubview(rightBall)
        addPanGesture(view: leftBall)
        addPanGesture(view: middleBall)
        addPanGesture(view: rightBall)
        setupConstraints()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLines(middleBall)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [topLine.topAnchor.constraint(equalTo: topAnchor),
             topLine.leadingAnchor.constraint(equalTo: leadingAnchor),
             topLine.trailingAnchor.constraint(equalTo: trailingAnchor),
             topLine.heightAnchor.constraint(equalToConstant: 31),
             
             middleLine.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 90),
             middleLine.leadingAnchor.constraint(equalTo: leadingAnchor),
             middleLine.trailingAnchor.constraint(equalTo: trailingAnchor),
             middleLine.heightAnchor.constraint(equalToConstant: 31),
             
             bottomLine.topAnchor.constraint(equalTo: middleLine.bottomAnchor, constant: 90),
             bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
             bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
             bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
             bottomLine.heightAnchor.constraint(equalToConstant: 31),
             
             leftBall.centerYAnchor.constraint(equalTo: middleLine.speedLine.centerYAnchor),
             leftBall.leadingAnchor.constraint(equalTo: leadingAnchor),
             leftBall.heightAnchor.constraint(equalToConstant: 40),
             leftBall.widthAnchor.constraint(equalToConstant: 40),
             
             middleBall.centerYAnchor.constraint(equalTo: middleLine.speedLine.centerYAnchor),
             middleBall.centerXAnchor.constraint(equalTo: middleLine.speedLine.centerXAnchor),
             middleBall.heightAnchor.constraint(equalToConstant: 40),
             middleBall.widthAnchor.constraint(equalToConstant: 40),
             
             rightBall.centerYAnchor.constraint(equalTo: middleLine.speedLine.centerYAnchor),
             rightBall.trailingAnchor.constraint(equalTo: trailingAnchor),
             rightBall.heightAnchor.constraint(equalToConstant: 40),
             rightBall.widthAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    func addPanGesture(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }
        
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let ballView = sender.view!
        let translation = sender.translation(in: self)
        switch sender.state {
        case .began, .changed:
            updateBallsAndLines(ballView, translation)
            sender.setTranslation(CGPoint.zero, in: self)
        case .ended:
            calculateLocations(ball: ballView)
        default:
            break
        }
    }
    
    private func updateBallsAndLines(_ ballView: UIView, _ translation: CGPoint) {
        updateBalls(ballView, translation)
        updateLines(ballView)
    }
    
    private func updateBalls(_ ballView: UIView, _ translation: CGPoint) {
        let newX = limitGestureXAxis(ballView, translation)
        let newY = limitGestureYAxis(ballView, translation)
        ballView.center = CGPoint(x: newX, y: newY)
    }
    
    private func updateLines(_ ballView: UIView) {
        switch ballView.tag {
        case 1:
            drawLine(ballA: leftBall, ballB: middleBall)
        case 2:
            drawLine(ballA: leftBall, ballB: middleBall)
            drawLine(ballA: middleBall, ballB: rightBall)
        case 3:
            drawLine(ballA: middleBall, ballB: rightBall)
        default:
            break
        }
    }

    private func limitGestureXAxis(_ ballView: UIView, _ translation: CGPoint) -> CGFloat {
        var newX: CGFloat = 0
        switch ballView.tag {
        case 2:
            newX = limitGestureXAxisFor2ndBall(ballView, translation)
        case 1,3:
            newX = limitGestureXAxisFor1stOr3rdBall(ballView)
        default:
            break
        }
        return newX
    }
    
    private func limitGestureXAxisFor1stOr3rdBall(_ ballView: UIView) -> CGFloat {
        return ballView.center.x
    }
    
    private func limitGestureXAxisFor2ndBall(_ ballView: UIView, _ translation: CGPoint) -> CGFloat {
        var newX = ballView.center.x + translation.x
        if newX < self.bounds.minX + 60 {
            newX = self.bounds.minX + 60
        } else if newX > self.bounds.maxX - 60 {
            newX = self.bounds.maxX - 60
        }
        return newX
    }
    
    private func limitGestureYAxis(_ ballView: UIView, _ translation: CGPoint) -> CGFloat {
        let topLineYPosition = getYPosition(view: topLine)
        let bottomLineYPosition = getYPosition(view: bottomLine)

        var newY = ballView.center.y + translation.y
        if newY < topLineYPosition {
            newY = topLineYPosition
        } else if newY > bottomLineYPosition {
            newY = bottomLineYPosition
        }
        return newY
    }
    
    private func prepareLine(_ ballA: UIView, _ ballB: UIView) -> CAShapeLayer {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: ballA.center.x, y: ballA.center.y))
        path.addLine(to: CGPoint(x: ballB.center.x, y: ballB.center.y))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.name = getLayerName(ballA)
        return shapeLayer
    }
    
    private func drawLine(ballA: UIView, ballB: UIView) {
        guard let sublayers = layer.sublayers else { return }

        for sublayer in sublayers {
            if sublayer.name == getLayerName(ballA) {
                layer.replaceSublayer(sublayer, with: prepareLine(ballA, ballB))
                return
            }
        }
        layer.insertSublayer(prepareLine(ballA, ballB), at: 0)
    }
        
    private func getLayerName(_ ballA: UIView) -> String {
        if ballA == leftBall {
            return "lineBetween1and2Layer"
        } else {
            return "lineBetween2and3Layer"
        }
    }
    
    private func calculateLocations(ball: UIView) {
        switch ball.tag {
        case 1:
            ballOneSpeed = calculateBallSpeed(ball: ball)
        case 2:
            ballTwoSpeed = calculateBallSpeed(ball: ball)
            frameNumberForBallTwo = calculateFrameNumberFor2ndBall()
        case 3:
            ballThreeSpeed = calculateBallSpeed(ball: ball)
        default:
            break
        }
    }
    
    private func calculateFrameNumberFor2ndBall() -> Int {
        let widthAreaFor2ndBall = frame.width - 30 * 2
        let frameNum = (((middleBall.center.x - 30)  / widthAreaFor2ndBall) * CGFloat(100 - 3))
        return Int(frameNum) + 1
    }
    
    private func calculateBallSpeed(ball: UIView) -> Double {
        let ballMidY = ball.center.y
        var ballSpeed: CGFloat = 1
        let topLineYPosition = getYPosition(view: topLine)
        let middleLineYPosition = getYPosition(view: middleLine)
        let bottomLineYPosition = getYPosition(view: bottomLine)
        if ballMidY > middleLineYPosition {
            ballSpeed = (bottomLineYPosition - ballMidY) / (bottomLineYPosition - middleLineYPosition) * (1 - 0.2) + 0.2
        } else {
            ballSpeed = (middleLineYPosition - ballMidY) / (middleLineYPosition - topLineYPosition) * (5 - 1) + 1
        }
        return Double(ballSpeed).roundTwoDecimalPlace()
    }
    
    private func getYPosition(view: SpeedLineView) -> CGFloat {
        switch view.tag {
        case 1:
            return topLine.speedLabel.frame.maxY + 5 + 0.5
        case 2:
            return topLine.speedLabel.frame.maxY + 5 + 1 + 90 + middleLine.speedLabel.frame.maxY + 5 + 0.5
        case 3:
            return topLine.speedLabel.frame.maxY + 5 + 1 + 90 + middleLine.speedLabel.frame.maxY + 5 + 1 + 90 + bottomLine.speedLabel.frame.maxY + 5 + 0.5
        default:
            break
        }
        
        return 0
    }
}

extension Double {
    func roundTwoDecimalPlace() -> Double {
        return (self * 100).rounded() / 100
    }
}
