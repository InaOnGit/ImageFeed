import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    private let placeholder = UIImage(named: "image_stub")
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask() // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
    }
    
    @IBAction private func likedButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func updateCell(from photos: Photo) {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
        
        let url = URL(string: photos.thumbImageURL)
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let image):
                self.cellImage.contentMode = .scaleToFill
                self.cellImage.image = image.image
            case .failure:
                self.cellImage.image = self.placeholder
            }
        }
        
        let photos = photos
        if let createdAt = photos.createdAt {
            dateLabel.text = dateFormatter.string(from: createdAt)
        } else {
            dateLabel.text = ""
        }
        setIsLiked(isLiked: photos.isLiked)
    }
    
    public func setIsLiked(isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "heart_active") : UIImage(named: "heart_not_active")
        likeButton.setImage(likeImage, for: .normal)
    }
}
