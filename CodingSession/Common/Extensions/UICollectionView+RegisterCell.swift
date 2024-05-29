import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
