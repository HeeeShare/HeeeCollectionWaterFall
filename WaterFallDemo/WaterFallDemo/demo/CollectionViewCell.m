//
//  CollectionViewCell.m
//  WaterFallDemo
//
//  Created by Heee on 2019/12/15.
//  Copyright © 2019 Heee. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Model.h"

@implementation CollectionViewCell
- (void)setModel:(Model *)model {
    _model = model;
    self.contentView.backgroundColor = model.bgColor;
}

@end
