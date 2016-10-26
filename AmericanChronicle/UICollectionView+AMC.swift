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
        return supplementaryView(forElementKind: UICollectionElementKindSectionHeader,
                                               at: indexPath)!
    }

    func dequeueCellForItemAtIndexPath<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        let identifier = NSStringFromClass(T.self)
        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell as! T
    }

    func dequeueHeaderForIndexPath(_ indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                      withReuseIdentifier: "Header",
                                                      for: indexPath)
    }
}
