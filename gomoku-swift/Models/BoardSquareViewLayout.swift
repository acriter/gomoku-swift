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
                            
                            cellAttributes.zIndex = 1
                            
                            // Save the attributes.
                            cellAttrsDictionary[cellIndex] = cellAttributes
                        }
                    }
                }
                
            }
        }
    }
    
//    override func prepare() {
//        // Only update header cells.
//        if !dataSourceDidUpdate {
//
//            // Determine current content offsets.
//            let xOffset = collectionView!.contentOffset.x
//            let yOffset = collectionView!.contentOffset.y
//
//            if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
//                for section in 0...sectionCount-1 {
//
//                    // Confirm the section has items.
//                    if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
//
//                        // Update all items in the first row.
//                        if section == 0 {
//                            for item in 0...rowCount-1 {
//
//                                // Build indexPath to get attributes from dictionary.
//                                let indexPath = IndexPath(item: item, section: section)
//
//                                // Update y-position to follow user.
//                                if let attrs = cellAttrsDictionary[indexPath] {
//                                    var frame = attrs.frame
//
//                                    // Also update x-position for corner cell.
//                                    if item == 0 {
//                                        frame.origin.x = xOffset
//                                    }
//
//                                    frame.origin.y = yOffset
//                                    attrs.frame = frame
//                                }
//
//                            }
//
//                            // For all other sections, we only need to update
//                            // the x-position for the first item.
//                        } else {
//
//                            // Build indexPath to get attributes from dictionary.
//                            let indexPath = IndexPath(item: 0, section: section)
//
//                            // Update y-position to follow user.
//                            if let attrs = cellAttrsDictionary[indexPath] {
//                                var frame = attrs.frame
//                                frame.origin.x = xOffset
//                                attrs.frame = frame
//                            }
//
//                        } // else
//                    } // num of items in section > 0
//                } // sections for loop
//            } // num of sections > 0
//
//
//            // Do not run attribute generation code
//            // unless data source has been updated.
//            return
//        }
//
//        // Acknowledge data source change, and disable for next time.
//        dataSourceDidUpdate = false
//
//        // Cycle through each section of the data source.
//        if let sectionCount = collectionView?.numberOfSections, sectionCount > 0 {
//            for section in 0...sectionCount-1 {
//
//                // Cycle through each item in the section.
//                if let rowCount = collectionView?.numberOfItems(inSection: section), rowCount > 0 {
//                    for item in 0...rowCount-1 {
//
//                        // Build the UICollectionViewLayoutAttributes for the cell.
//                        let cellIndex = IndexPath(item: item, section: section)
//                        let xPos = Double(item) * width
//                        let yPos = Double(section) * height
//
//                        let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex)
//                        cellAttributes.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
//
//                        // Determine zIndex based on cell type.
//                        if section == 0 && item == 0 {
//                            cellAttributes.zIndex = 4
//                        } else if section == 0 {
//                            cellAttributes.zIndex = 3
//                        } else if item == 0 {
//                            cellAttributes.zIndex = 2
//                        } else {
//                            cellAttributes.zIndex = 1
//                        }
//
//                        // Save the attributes.
//                        cellAttrsDictionary[cellIndex] = cellAttributes
//
//                    }
//                }
//
//            }
//        }
//
//        // Update content size.
//        let contentWidth = Double(collectionView!.numberOfItems(inSection: 0)) * width
//        let contentHeight = Double(collectionView!.numberOfSections) * height
//        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
//
//    }
//
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
