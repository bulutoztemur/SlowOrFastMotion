//
//  PlayButton.swift
//  DownloadingView
//
//  Created by alaattinbulut on 1.06.2021.
//

import UIKit

class PlayButton: UIButton {
    
    enum ButtonImageState {
        case play
        case pause
    }
    
    var buttonImageState: ButtonImageState = .play
    
    override func draw(_ rect: CGRect) {
        setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
    }
    
    @objc func onPress() {        
        switch buttonImageState {
        case .play:
            setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            buttonImageState = .pause
        case .pause:
            setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            buttonImageState = .play
        }
    }

}
