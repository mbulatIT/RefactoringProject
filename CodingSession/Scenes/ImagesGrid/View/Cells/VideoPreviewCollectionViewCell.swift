import UIKit
import RxCocoa
import RxSwift

final class VideoPreviewCollectionViewCell: UICollectionViewCell {
    
    private enum Constants {
        static let defaultInset: Int = 8
    }
    
    // MARK: - UI elements
    
    private lazy var previewImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .lightText.withAlphaComponent(0.3)
        label.textAlignment = .center
        return label
    }()
    private lazy var imageObserver: BehaviorSubject<UIImage?> = createImageObserver()
    private let disposeBag = DisposeBag()

    // MARK: - Public methods

    func populate(title: String?, imageObserver: BehaviorSubject<UIImage?>) {
        durationLabel.text = title
        imageObserver
            .observe(on: MainScheduler.instance)
            .bind(to: self.imageObserver)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Lifecycle

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        durationLabel.text = nil
        imageObserver.dispose()
        imageObserver = createImageObserver()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        setupThumbImageView()
        setupDurationLabel()
    }
    
    private func setupThumbImageView() {
        contentView.addSubview(previewImageView)
        previewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDurationLabel() {
        contentView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.defaultInset)
            make.bottom.equalToSuperview()
        }
    }
    
    private func createImageObserver() -> BehaviorSubject<UIImage?> {
        let subject = BehaviorSubject<UIImage?>(value: nil)
        subject.bind(to: previewImageView.rx.image).disposed(by: disposeBag)
        return subject
    }
}
