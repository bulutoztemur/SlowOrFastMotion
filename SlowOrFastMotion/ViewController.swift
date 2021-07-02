//
//  ViewController.swift
//  DownloadingView
//
//  Created by alaattinbulut on 25.05.2021.
//

import AVKit
import UIKit

class ViewController: UIViewController {

    let playerController = AVPlayerViewController()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.isScrollEnabled = true
        return sv
    }()

    let videoPreview: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let horizontalStackView: UIStackView = {
        let hsv = UIStackView()
        hsv.axis = NSLayoutConstraint.Axis.horizontal
        hsv.distribution  = UIStackView.Distribution.equalSpacing
        hsv.alignment = UIStackView.Alignment.center
        hsv.spacing   = 32.0
        hsv.translatesAutoresizingMaskIntoConstraints = false
        return hsv
    }()
    
    let playButton: PlayButton = {
        let button = PlayButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let uploadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        return button
    }()
        
    let speedCurve: SpeedCurveView = {
        let sc = SpeedCurveView()
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        horizontalStackView.addArrangedSubview(playButton)
        horizontalStackView.addArrangedSubview(uploadButton)
        scrollView.addSubview(videoPreview)
        scrollView.addSubview(horizontalStackView)
        scrollView.addSubview(speedCurve)
        view.addSubview(scrollView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calculateScrollViewContentSize()
    }
    
    private func calculateScrollViewContentSize() {
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = CGSize(width: contentRect.size.width, height: contentRect.size.height + 120)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             
             videoPreview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             videoPreview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             videoPreview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             videoPreview.heightAnchor.constraint(equalToConstant: 200),
             
             uploadButton.heightAnchor.constraint(equalToConstant: 40),
             uploadButton.widthAnchor.constraint(equalToConstant: 40),
             playButton.heightAnchor.constraint(equalToConstant: 40),
             playButton.widthAnchor.constraint(equalToConstant: 40),
             
             horizontalStackView.topAnchor.constraint(equalTo: videoPreview.bottomAnchor, constant: 20),
             horizontalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

             speedCurve.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
             speedCurve.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
             speedCurve.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            ])
    }
    
    @objc func uploadButtonTapped() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.mediaTypes = ["public.movie"]
        vc.delegate = self
        vc.allowsEditing = false
        present(vc, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[.mediaURL] as? NSURL {
            let player = AVPlayer(url: videoURL.absoluteURL!)
            playerController.player = player
            playerController.view.frame = videoPreview.bounds
            self.videoPreview.addSubview(playerController.view)
            
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                   object: self.playerController.player?.currentItem, queue: .main) { [weak self] _ in
                self?.playerController.player?.seek(to: CMTime.zero)
                self?.playerController.player?.play()
            }

        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
