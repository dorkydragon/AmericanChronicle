extension UICollectionView {

    var headerPaths: [IndexPath] {
        return indexPathsForVisibleSupplementaryElements(ofKind: UICollectionElementKindSectionHeader)
    }

    var lastVisibleHeaderPath: IndexPath? {
        return headerPaths.last
    }

    var minVisibleHeaderY: CGFloat? {
        guard let path = lastVisibleHeaderPath else { return nil }
        let header = headerAtIndexPath(path)
        return header.frame.origin.y - contentOffset.y
    }

    func headerAtIndexPath(_ indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: indexPath) else {
            fatalError("Missing header")
        }
        return header
    }

    func dequeueCellForItemAtIndexPath<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        let identifier = NSStringFromClass(T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Unexpected cell type")
        }
        return cell
    }

    func dequeueHeaderForIndexPath(_ indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                      withReuseIdentifier: "Header",
                                                      for: indexPath)
    }
}
