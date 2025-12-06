import UIKit

extension EmojiColorCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return EmojiColorSection.allCases.count
    }
    
    func collectionView(_  collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch EmojiColorSection(rawValue: section) {
        case .emoji:
            return EmojiColorMockData.emojis.count
        case .color:
            return EmojiColorMockData.colors.count
        case .none:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojiColorViewCell.identifier,
            for: indexPath
        ) as? EmojiColorViewCell else { return UICollectionViewCell()
        }
        
        guard let section = EmojiColorSection(rawValue: indexPath.section) else {
            return cell
        }
        
        switch section {
        case .emoji:
            let emoji = EmojiColorMockData.emojis[indexPath.item]
            
            let isSelected = (indexPath == selectedEmojiIndexPath)
            cell.configureAsEmoji(emoji, isSelected: isSelected)
            
        case .color:
            let color = EmojiColorMockData.colors[indexPath.item]
            
            let isSelected = (indexPath == selectedColorIndexPath)
            cell.configureAsColor(color, isSelected: isSelected)
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: EmojiColorHeaderView.identifier,
            for: indexPath
        ) as? EmojiColorHeaderView else {
            return UICollectionReusableView()
        }
        
        let title: String
        switch EmojiColorSection(rawValue: indexPath.section) {
        case .emoji:
            title = "Emoji"
        case .color:
            title = "Цвет"
        case .none:
            title = ""
        }
        
        header.configure(with: title)
        
        return header
    }
}
