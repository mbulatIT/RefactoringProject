import UIKit
import SnapKit

final class VideoPreviewsGridView: UIView {
    
    // MARK: - UI elements

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.registerCell(VideoPreviewCollectionViewCell.self)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setupDelegate(_ delegate: UICollectionViewDelegate&UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = delegate
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
