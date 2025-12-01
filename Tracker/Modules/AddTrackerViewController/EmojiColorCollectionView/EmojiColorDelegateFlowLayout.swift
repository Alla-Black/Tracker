import UIKit

extension EmojiColorCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth = availableWidth / CGFloat(params.cellCount)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: params.leftInset, bottom: 24, right: params.leftInset)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpaсing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 34)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) -> Void {
        guard let section = EmojiColorSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .emoji:
            let oldIndexPath = selectedEmojiIndexPath
            selectEmoji(at: indexPath)
            var indexPathsToReload: [IndexPath] = [indexPath]
            if let old = oldIndexPath {
                indexPathsToReload.append(old)
            }
            collectionView.reloadItems(at: indexPathsToReload)
            
        case .color:
            let oldIndexPath = selectedColorIndexPath
            selectColor(at: indexPath)
            var indexPathsToReload: [IndexPath] = [indexPath]
            if let old = oldIndexPath {
                indexPathsToReload.append(old)
            }
            collectionView.reloadItems(at: indexPathsToReload)
        }
    }
}

