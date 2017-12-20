import UIKit

class BoardSquareViewLayout: UICollectionViewLayout {
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let maxHeight = UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height
    let maxWidth = UIScreen.main.bounds.width
    let minHeightPerCell = 50.0
    let minWidthPerCell = 50.0
    
    var cellWidth: Double?
    var cellHeight: Double?
    
    var cellAttrsDictionary = Dictionary<IndexPath, UICollectionViewLayoutAttributes>()
    var contentSize = CGSize.zero
    
    override var collectionViewContentSize : CGSize {
        return self.contentSize
    }
    
    override func prepare() {
        if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
            if let rowCount = collectionView?.numberOfItems(inSection: 0) {
                let cellWidth = max(minWidthPerCell, (Double(maxWidth / CGFloat(sectionCount))))
                let cellHeight = max(minHeightPerCell, (Double(maxHeight / CGFloat(rowCount))))
                let dimension = min(cellWidth, cellHeight)
                self.cellWidth = dimension
                self.cellHeight = dimension
                self.contentSize = CGSize(width: dimension * Double(sectionCount), height: dimension * Double(rowCount))
                for section in 0...sectionCount - 1 {
                    if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
                        for item in 0...rowCount - 1 {
                            let cellIndex = IndexPath(item: item, section: section)
                            let xPos = Double(section) * dimension
                            let yPos = Double(item) * dimension
                            
                            let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
                            cellAttributes.frame = CGRect(x: xPos, y: yPos, width: dimension, height: dimension)
                            
                            cellAttrsDictionary[cellIndex] = cellAttributes
                        }
                    }
                }
                
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        // Create an array to hold all elements found in our current view.
        var attributesInRect = [UICollectionViewLayoutAttributes]()

        // Check each element to see if it should be returned.
        for cellAttributes in cellAttrsDictionary.values {
            if rect.intersects(cellAttributes.frame) {
                attributesInRect.append(cellAttributes)
            }
        }

        // Return list of elements.
        return attributesInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDictionary[indexPath]!
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
