//
//  ProjectFrameUtil.swift
//  DownloadingView
//
//  Created by alaattinbulut on 3.06.2021.
//

import UIKit

class ProjectFramesUtil {

    class func createProjectFramesOutput(_ node2Location: Int = 1, _ node1Speed: Double = 1, _ node2Speed: Double = 1, _ node3Speed: Double = 1) -> [Int] {
        let firstTan = (node2Speed - node1Speed) / Double((node2Location - Constants.NODE1_LOCATION))
        let secondTan = (node3Speed - node2Speed) / Double((Constants.NODE3_LOCATION - node2Location))
                
        var time:[Double] = Array(repeating: 0, count: Constants.NUMBER_OF_FRAMES)
        for i in Constants.NODE1_LOCATION...node2Location {
            time[i] = (1.0 / (node1Speed + firstTan * Double(i))).roundTwoDecimalPlace()
        }
        
        for i in (node2Location + 1)...Constants.NODE3_LOCATION {
            time[i] = (1.0 / (node2Speed + secondTan * Double((i - node2Location)))).roundTwoDecimalPlace()
        }
        
        var cumulativePassedTime: Double = 0
        var frame:[Int] = []
        for (imageIndex, durationOnScreen) in time.enumerated() {
            let remainder = cumulativePassedTime.truncatingRemainder(dividingBy: 1).roundTwoDecimalPlace()
            var temp = remainder + durationOnScreen
            if remainder == 0 {
                temp.round(.up)
            } else if(temp >= 1) {
                temp -= 1
                temp.round(.up)
            } else {
                temp.round(.down)
            }
            frame.append(contentsOf: repeatElement(imageIndex, count: Int(temp)))
            cumulativePassedTime += durationOnScreen
            cumulativePassedTime = cumulativePassedTime.roundTwoDecimalPlace()
        }
        return frame
    }
    
    class func prepareImageArray(node2Location: Int, node1Speed: Double, node2Speed: Double, node3Speed: Double) -> [UIImage] {
        let frameIndexArray = createProjectFramesOutput(node2Location, node1Speed, node2Speed, node3Speed)
        var animationArray: [UIImage] = []
        frameIndexArray.forEach ({
            guard let image = UIImage(named: String("\($0)")) else { return }
            animationArray.append(image)
        })
        return animationArray
    }
    
    class func prepareImageArrayFromIndexArray(frameIndexArray: [Int]) -> [UIImage] {
        var animationArray: [UIImage] = []
        frameIndexArray.forEach ({
            guard let image = UIImage(named: String("\($0)")) else { return }
            animationArray.append(image)
        })
        return animationArray
    }


}
