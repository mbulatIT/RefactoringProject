import RxSwift
import Photos
import UIKit

typealias VideoPreviewsGridViewModel = VideoPreviewsGridViewModelInput&VideoPreviewsGridViewModelOutput

protocol VideoPreviewsGridViewModelInput {
    func viewDidLoad()
}

protocol VideoPreviewsGridViewModelOutput {
    var rowItemsCount: BehaviorSubject<Int> { get }
    var collectionViewData: BehaviorSubject<[PHAsset]> { get }

    func fetchImages(from asset: PHAsset, withSize size: CGSize) -> BehaviorSubject<UIImage?>
}

final class DefaultImagesGridViewModel: VideoPreviewsGridViewModel {
    
    private lazy var imageManager = PHImageManager.default()
    private lazy var requestOptions: PHImageRequestOptions = {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        return requestOptions
    }()
    private var cache: [String: [CGFloat: BehaviorSubject<UIImage?>]] = [:]
    
    // MARK: - VideoPreviewsGridViewModelOutput
    
    let rowItemsCount = BehaviorSubject<Int>(value: 3)
    let collectionViewData = BehaviorSubject<[PHAsset]>(value: [])
    
    func fetchImages(from asset: PHAsset, withSize size: CGSize) -> BehaviorSubject<UIImage?> {
        if let publisher = cache[asset.localIdentifier]?[size.width] {
            return publisher
        }
        let publisher = BehaviorSubject<UIImage?>(value: nil)
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) {  (image, _) in
            publisher.on(.next(image))
        }
        cache[asset.localIdentifier]?[size.width] = publisher
        return publisher
    }

    // MARK: - Private methods

    private func fetchAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue)
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        var videoAssets: [PHAsset] = []
        
        fetchResult.enumerateObjects { (asset, _, _) in
            videoAssets.append(asset)
        }
        videoAssets.forEach { cache[$0.localIdentifier] = cache[$0.localIdentifier] ?? [:] }
        collectionViewData.on(.next(videoAssets))
    }
}

// MARK: - VideoPreviewsGridViewModelInput
extension DefaultImagesGridViewModel {
    func viewDidLoad() {
        fetchAssets()
    }
}
