import UIKit

// MARK: - EmojiColorSection Enum

enum EmojiColorSection: Int, CaseIterable {
    
    case emoji
    case color
}

// MARK: - EmojiColorCollectionView

final class EmojiColorCollectionView: NSObject {
    
    // MARK: - Private Properties
    
    private let collectionView: UICollectionView
    private(set) var params: CollectionLayoutParams
    
    private(set) var selectedEmojiIndexPath: IndexPath?
    private(set) var selectedColorIndexPath: IndexPath?
    
    // MARK: - Initializers
    
    init(using params: CollectionLayoutParams, collectionView: UICollectionView) {
    
        self.params = params
        self.collectionView = collectionView
        
        super.init()
        
        collectionView.register(
            EmojiColorViewCell.self,
            forCellWithReuseIdentifier: EmojiColorViewCell.identifier
        )
        
        collectionView.register(
            EmojiColorHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmojiColorHeaderView.identifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Public Methods
    
    func selectEmoji(at indexPath: IndexPath?) {
        self.selectedEmojiIndexPath = indexPath
    }
    
    func selectColor(at indexPath: IndexPath?) {
        self.selectedColorIndexPath = indexPath
    }
}
