import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UICollectionView {
    public func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
        (cellType: Cell.Type = Cell.self)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable where Source.Element == Sequence {
            items(cellIdentifier: Cell.reuseIdentifier, cellType: cellType)
    }
}
