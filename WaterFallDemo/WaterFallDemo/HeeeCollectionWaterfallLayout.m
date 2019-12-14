//
//  HeeeCollectionWaterfallLayout.m
//  WaterFallDemo
//
//  Created by Heee on 2019/12/15.
//  Copyright © 2019 Heee. All rights reserved.
//

#import "HeeeCollectionWaterfallLayout.h"
@interface HeeeCollectionWaterfallLayout ()
@property (nonatomic,strong) NSMutableArray <NSMutableArray *>*contentLengthArray;//所有section的内容长度数组
@property (nonatomic,strong) NSMutableArray *cellAttsArray;//cell属性数组
@property (nonatomic,strong) NSMutableArray *headerAttsArray;//header属性数组
@property (nonatomic,strong) NSMutableArray *footerAttsArray;//footer属性数组

@end

@implementation HeeeCollectionWaterfallLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    if (self.numberLine == 0) {
        return;
    }
    
    self.contentLengthArray = [NSMutableArray array];
    self.headerAttsArray = [NSMutableArray array];
    self.footerAttsArray = [NSMutableArray array];
    self.cellAttsArray = [NSMutableArray array];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        [self p_prepareVerticalData];
    }else{
        [self p_prepareHorizontalData];
    }
}

- (void)p_prepareVerticalData {
    CGFloat cellWidth = (self.collectionView.bounds.size.width - self.contentInsets.left - self.contentInsets.right - (self.numberLine-1)*self.interitemSpacing)/self.numberLine;
    
    //section个数
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (NSUInteger i = 0; i < sectionsCount; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSUInteger j = 0; j < self.numberLine; j++) {
            [array addObject:@"0"];
        }
        [self.contentLengthArray addObject:array];
    }
    
    CGFloat sectionBottom = 0;
    for (NSUInteger section = 0; section < sectionsCount; section++) {
        //处理section的header属性
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerHeightWithLayout:indexPath:)]) {
            CGFloat headerHeight = [self.delegate headerHeightWithLayout:self indexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attribute.frame = CGRectMake(0, sectionBottom, self.collectionView.bounds.size.width, headerHeight);
            sectionBottom+=headerHeight;
            [self.headerAttsArray addObject:attribute];
        }
        
        //某个section的row个数
        NSMutableArray *sectionContentLengthArray = self.contentLengthArray[section];
        NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
        for (NSUInteger row = 0; row < rowsCount; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:row inSection:section];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cellHeightWithLayout:indexPath:)]) {
                CGFloat cellHeight = [self.delegate cellHeightWithLayout:self indexPath:cellIndexPath];
                
                //寻找内容最短的那列
                CGFloat shortContent = ((NSString *)sectionContentLengthArray.firstObject).floatValue;
                NSUInteger currentLine = 0;
                for (NSUInteger j = 1; j < sectionContentLengthArray.count; j++) {
                    NSString *bottomStr = sectionContentLengthArray[j];
                    CGFloat bottom = bottomStr.floatValue;
                    if (bottom < shortContent) {
                        shortContent = bottom;
                        currentLine = j;
                    }
                }
                
                //拿到属性设置frame
                UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
                CGFloat top = shortContent==0?(sectionBottom+self.contentInsets.top):(shortContent+self.lineSpacing);
                attribute.frame = CGRectMake(self.contentInsets.left+currentLine*(cellWidth+self.interitemSpacing), top, cellWidth, cellHeight);
                [self.cellAttsArray addObject:attribute];
                
                //更新内容长度数组
                [sectionContentLengthArray replaceObjectAtIndex:currentLine withObject:[NSString stringWithFormat:@"%f",top + cellHeight]];
            }
        }
        
        //寻找最高列的数据
        for (NSString *str in sectionContentLengthArray) {
            if (sectionBottom < str.floatValue) {
                sectionBottom = str.floatValue;
            }
        }
        
        sectionBottom+=self.contentInsets.bottom;
        
        //处理section的footer属性
        if (self.delegate && [self.delegate respondsToSelector:@selector(footerHeightWithLayout:indexPath:)]) {
            CGFloat footerHeight = [self.delegate footerHeightWithLayout:self indexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attribute.frame = CGRectMake(0, sectionBottom, self.collectionView.bounds.size.width, footerHeight);
            sectionBottom+=footerHeight;
            [self.footerAttsArray addObject:attribute];
        }
    }
}

- (void)p_prepareHorizontalData {
    CGFloat cellHeight = (self.collectionView.bounds.size.height - self.contentInsets.top - self.contentInsets.bottom - (self.numberLine-1)*self.lineSpacing)/self.numberLine;
    
    //section个数
    NSInteger sectionsCount = [self.collectionView numberOfSections];
    for (NSUInteger i = 0; i < sectionsCount; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSUInteger j = 0; j < self.numberLine; j++) {
            [array addObject:@"0"];
        }
        [self.contentLengthArray addObject:array];
    }
    
    CGFloat sectionRight = 0;
    for (NSUInteger section = 0; section < sectionsCount; section++) {
        //处理section的header属性
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerHeightWithLayout:indexPath:)]) {
            CGFloat headerWidth = [self.delegate headerHeightWithLayout:self indexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attribute.frame = CGRectMake(sectionRight, 0, headerWidth, self.collectionView.bounds.size.height);
            sectionRight+=headerWidth;
            [self.headerAttsArray addObject:attribute];
        }
        
        //某个section的row个数
        NSMutableArray *sectionContentLengthArray = self.contentLengthArray[section];
        NSInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
        for (NSUInteger row = 0; row < rowsCount; row++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:row inSection:section];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cellHeightWithLayout:indexPath:)]) {
                CGFloat cellWidth = [self.delegate cellHeightWithLayout:self indexPath:cellIndexPath];
                
                //寻找内容最短的那列
                CGFloat shortContent = ((NSString *)sectionContentLengthArray.firstObject).floatValue;
                NSUInteger currentLine = 0;
                for (NSUInteger j = 1; j < sectionContentLengthArray.count; j++) {
                    NSString *bottomStr = sectionContentLengthArray[j];
                    CGFloat bottom = bottomStr.floatValue;
                    if (bottom < shortContent) {
                        shortContent = bottom;
                        currentLine = j;
                    }
                }
                
                //拿到属性设置frame
                UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
                CGFloat left = shortContent==0?(sectionRight+self.contentInsets.left):(shortContent+self.lineSpacing);
                attribute.frame = CGRectMake(left, self.contentInsets.top+currentLine*(cellHeight+self.interitemSpacing), cellWidth, cellHeight);
                [self.cellAttsArray addObject:attribute];
                
                //更新内容长度数组
                [sectionContentLengthArray replaceObjectAtIndex:currentLine withObject:[NSString stringWithFormat:@"%f",left + cellWidth]];
            }
        }
        
        //寻找最高列的数据
        for (NSString *str in sectionContentLengthArray) {
            if (sectionRight < str.floatValue) {
                sectionRight = str.floatValue;
            }
        }
        
        sectionRight+=self.contentInsets.right;
        
        //处理section的footer属性
        if (self.delegate && [self.delegate respondsToSelector:@selector(footerHeightWithLayout:indexPath:)]) {
            CGFloat footerWidth = [self.delegate footerHeightWithLayout:self indexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            attribute.frame = CGRectMake(0, sectionRight, footerWidth, self.collectionView.bounds.size.height);
            sectionRight+=footerWidth;
            [self.footerAttsArray addObject:attribute];
        }
    }
}

- (CGSize)collectionViewContentSize {
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat width = 0;
        UICollectionViewLayoutAttributes *attribute = self.footerAttsArray.lastObject;
        width+=attribute.frame.size.width;
        
        CGFloat maxWidth = 0;
        for (NSString *bottomValue in self.contentLengthArray.lastObject) {
            if (bottomValue.floatValue > maxWidth) {
                maxWidth = bottomValue.floatValue;
            }
        }
        
        width+=(maxWidth + self.contentInsets.left);
        
        return CGSizeMake(width, self.collectionView.bounds.size.height);
    }else{
        CGFloat height = 0;
        UICollectionViewLayoutAttributes *attribute = self.footerAttsArray.lastObject;
        height+=attribute.frame.size.height;
        
        CGFloat maxHeight = 0;
        for (NSString *bottomValue in self.contentLengthArray.lastObject) {
            if (bottomValue.floatValue > maxHeight) {
                maxHeight = bottomValue.floatValue;
            }
        }
        
        height+=(maxHeight + self.contentInsets.bottom);
        
        return CGSizeMake(self.collectionView.bounds.size.width, height);
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *elementsArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.headerAttsArray) {
        if (attribute.frame.size.height > 0 || attribute.frame.size.width > 0) {
            [elementsArray addObject:attribute];
        }
    }
    
    for (UICollectionViewLayoutAttributes *attribute in self.footerAttsArray) {
        if (attribute.frame.size.height > 0 || attribute.frame.size.width > 0) {
            [elementsArray addObject:attribute];
        }
    }
    
    [elementsArray addObjectsFromArray:self.cellAttsArray];
    
    //计算header悬浮位置
    if (self.headerViewFixedTop)  {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            [self p_calculateVerticalFixHeader];
        }else{
            [self p_calculateHorizontalFixHeader];
        }
    }
    
    return elementsArray;
}

- (void)p_calculateVerticalFixHeader {
    NSMutableArray *allHeaderAttriArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.headerAttsArray) {
        attribute.zIndex = 7;
        if (attribute.frame.size.height > 0) {
            [allHeaderAttriArray addObject:attribute];
        }
    }
    
    CGFloat contentInsetTop = self.collectionView.contentInset.top;
    if (@available(iOS 11.0, *)) {
        contentInsetTop = self.collectionView.adjustedContentInset.top;
    }
    
    for (int i = (int)allHeaderAttriArray.count - 1; i >= 0; i--) {
        UICollectionViewLayoutAttributes *attribute = allHeaderAttriArray[i];
        if (attribute.frame.origin.y <= self.collectionView.contentOffset.y + contentInsetTop) {
            attribute.frame = CGRectMake(attribute.frame.origin.x, self.collectionView.contentOffset.y+contentInsetTop, attribute.frame.size.width, attribute.frame.size.height);
            
            //下一个开始顶当前固定header的时候
            if (i != allHeaderAttriArray.count - 1) {
                UICollectionViewLayoutAttributes *nextAttribute = allHeaderAttriArray[i+1];
                if (nextAttribute.frame.origin.y < attribute.frame.origin.y + attribute.frame.size.height) {
                    attribute.frame = CGRectMake(attribute.frame.origin.x, nextAttribute.frame.origin.y - attribute.frame.size.height, attribute.frame.size.width, attribute.frame.size.height);
                }
            }
        }
    }
}

- (void)p_calculateHorizontalFixHeader {
    NSMutableArray *allHeaderAttriArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.headerAttsArray) {
        attribute.zIndex = 7;
        if (attribute.frame.size.height > 0) {
            [allHeaderAttriArray addObject:attribute];
        }
    }
    
    CGFloat contentInsetLeft = self.collectionView.contentInset.left;
    if (@available(iOS 11.0, *)) {
        contentInsetLeft = self.collectionView.adjustedContentInset.left;
    }
    
    for (int i = (int)allHeaderAttriArray.count - 1; i >= 0; i--) {
        UICollectionViewLayoutAttributes *attribute = allHeaderAttriArray[i];
        if (attribute.frame.origin.x <= self.collectionView.contentOffset.x + contentInsetLeft) {
            attribute.frame = CGRectMake(self.collectionView.contentOffset.x + contentInsetLeft ,attribute.frame.origin.y, attribute.frame.size.width, attribute.frame.size.height);
            
            //下一个开始顶当前固定header的时候
            if (i != allHeaderAttriArray.count - 1) {
                UICollectionViewLayoutAttributes *nextAttribute = allHeaderAttriArray[i+1];
                if (nextAttribute.frame.origin.x < attribute.frame.origin.x + attribute.frame.size.width) {
                    attribute.frame = CGRectMake(nextAttribute.frame.origin.x - attribute.frame.size.width, attribute.frame.origin.y, attribute.frame.size.width, attribute.frame.size.height);
                }
            }
        }
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
