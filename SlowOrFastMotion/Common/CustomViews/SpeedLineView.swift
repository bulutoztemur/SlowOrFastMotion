//
//  SpeedLineView.swift
//  DownloadingView
//
//  Created by alaattinbulut on 27.05.2021.
//

import UIKit

class SpeedLineView: UIView {
        
    var speedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var speedLine: UIView = {
        var line = UIView()
        line.backgroundColor = .black
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    private func configureView() {
        addSubview(speedLine)
        addSubview(speedLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [speedLabel.topAnchor.constraint(equalTo: topAnchor),
             speedLabel.heightAnchor.constraint(equalToConstant: 25),
             speedLabel.bottomAnchor.constraint(equalTo: speedLine.topAnchor, constant: -5),
             speedLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
             
             speedLine.leadingAnchor.constraint(equalTo: leadingAnchor),
             speedLine.trailingAnchor.constraint(equalTo: trailingAnchor),
             speedLine.heightAnchor.constraint(equalToConstant: 1)])
    }
}
