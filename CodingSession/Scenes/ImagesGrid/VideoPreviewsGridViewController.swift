//
//  ViewController.swift
//  CodingSession
//
//  Created by Pavel Ilin on 01.11.2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Accelerate
import Photos

final class VideoPreviewsGridViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: VideoPreviewsGridViewModel
    private let disposeBag = DisposeBag()
    private lazy var rootView = VideoPreviewsGridView()
    private lazy var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        formatter.unitsStyle = .positional
        return formatter
    }()
    private var itemSize: CGSize {
        let itemsPerRow = (try? viewModel.rowItemsCount.value()) ?? 3
        let side = UIScreen.main.bounds.width / CGFloat(itemsPerRow)
        return CGSize(width: side, height: side)
    }
    
    // MARK: - Lifecycle
    
    init(viewModel: VideoPreviewsGridViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.viewDidLoad()
        rootView.collectionView
            .rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setupBindings() {
        Observable.combineLatest(viewModel.collectionViewData, viewModel.rowItemsCount)
            .map { $0.0 }
            .observe(on: MainScheduler.instance)
            .bind(to: rootView.collectionView.rx.items(
                cellType: VideoPreviewCollectionViewCell.self
            )) { [weak self] row, data, cell in
                guard let self else { return }
                let imageObserver = viewModel.fetchImages(from: data, withSize: itemSize)
                let title = durationFormatter.string(from: data.duration)
                cell.populate(title: title, imageObserver: imageObserver)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension VideoPreviewsGridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}


