import UIKit

// MARK: - EmojiColorSelectionDelegate Protocol

protocol EmojiColorSelectionDelegate: AnyObject {
    func emojiColorCollectionView(_ manager: EmojiColorCollectionView, didSelectEmoji emoji: String)
    
    func emojiColorCollectionView(_ manager: EmojiColorCollectionView, didSelectColor color: UIColor)
}


// MARK: - EmojiColorSection Enum

enum EmojiColorSection: Int, CaseIterable {
    
    case emoji
    case color
}

// MARK: - EmojiColorCollectionView

final class EmojiColorCollectionView: NSObject {
    
    // MARK: - Public Properties
    
    weak var selectionDelegate: EmojiColorSelectionDelegate?
    
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
    
    func setSelection(emoji: String?, color: UIColor?) {
        if let emoji,
           let item = EmojiColorMockData.emojis.firstIndex(of: emoji) {
            selectedEmojiIndexPath = IndexPath(item: item, section: EmojiColorSection.emoji.rawValue)
        } else {
            selectedEmojiIndexPath = nil
        }

        if let color,
           let item = EmojiColorMockData.colors.firstIndex(where: { $0 == color }) {
            selectedColorIndexPath = IndexPath(item: item, section: EmojiColorSection.color.rawValue)
        } else {
            selectedColorIndexPath = nil
        }

        collectionView.reloadData()
    }
}
