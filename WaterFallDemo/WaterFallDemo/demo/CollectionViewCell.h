//
//  CollectionViewCell.h
//  WaterFallDemo
//
//  Created by Heee on 2019/12/15.
//  Copyright © 2019 Heee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Model;

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) Model *model;

@end

NS_ASSUME_NONNULL_END
