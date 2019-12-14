//
//  HeaderView.m
//  WaterFallDemo
//
//  Created by Heee on 2019/12/15.
//  Copyright © 2019 Heee. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()
@property (nonatomic,strong) UILabel *label;

@end

@implementation HeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(arc4random()%225)/225.0 green:(arc4random()%225)/225.0 blue:(arc4random()%225)/225.0 alpha:1.0];
        [self addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.label sizeToFit];
    self.label.frame = CGRectMake((self.bounds.size.width - self.label.bounds.size.width)/2, (self.bounds.size.height - self.label.bounds.size.height)/2, self.label.bounds.size.width, self.label.bounds.size.height);
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor redColor];
        label.text = @"Header";
        label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        
        _label = label;
    }
    
    return _label;
}

@end
