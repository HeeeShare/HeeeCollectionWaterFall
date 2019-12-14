//
//  HeeeCollectionWaterfallLayout.h
//  WaterFallDemo
//
//  Created by Heee on 2019/12/15.
//  Copyright © 2019 Heee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeeeCollectionWaterfallLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol HeeeCollectionWaterfallLayoutDelegate <NSObject>
- (CGFloat)cellHeightWithLayout:(HeeeCollectionWaterfallLayout*)layout indexPath:(NSIndexPath*)indexPath;

@optional
- (CGFloat)headerHeightWithLayout:(HeeeCollectionWaterfallLayout*)layout indexPath:(NSIndexPath*)indexPath;
- (CGFloat)footerHeightWithLayout:(HeeeCollectionWaterfallLayout*)layout indexPath:(NSIndexPath*)indexPath;

@end

@interface HeeeCollectionWaterfallLayout : UICollectionViewLayout
@property (nonatomic,assign) NSUInteger numberLine;//行数、列数
@property (nonatomic,assign) UIEdgeInsets contentInsets;//每个section的边距
@property (nonatomic,assign) CGFloat lineSpacing;//行间距
@property (nonatomic,assign) CGFloat interitemSpacing;//列间距
@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection;//滚动方向
@property (nonatomic,assign) BOOL headerViewFixedTop;//headerView是否悬浮固定在顶部
@property (nonatomic,weak) id<HeeeCollectionWaterfallLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
