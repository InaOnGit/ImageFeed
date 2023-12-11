//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Ina on 13/05/2023.
//
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var image: URL? {
        didSet {
            guard isViewLoaded else { return }
            loadImage(url: image)
        }
    }
    
    var photo: Photo?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBAction private func backwardButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        if let image = image {
            let share = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil
            )
            share.overrideUserInterfaceStyle = .dark
            self.present(share, animated: true, completion: nil)
        }
    }
    
    private let placeholder = UIImage(named: "image_stub")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        loadImage(url: image)
    }
    
    private func loadImage(url: URL?) {
        guard url != nil else {
            showAlert()
            return
        }
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: url) { [weak self] result in // a не (with: url)
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showAlert()
            }
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось загрузить изображение", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x:x, y:y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
