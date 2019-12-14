//
//  ViewController.m
//  WaterFallDemo
//
//  Created by Heee on 2019/12/14.
//  Copyright © 2019 Heee. All rights reserved.
//

#import "ViewController.h"
#import "HeeeCollectionWaterfallLayout.h"
#import "CollectionViewCell.h"
#import "HeaderView.h"
#import "Model.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,HeeeCollectionWaterfallLayoutDelegate>
@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,strong) NSMutableArray <NSMutableArray <Model *>*>*dataArray;
@property (nonatomic,strong) HeeeCollectionWaterfallLayout *layout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    
    [self createData];
    [self.view addSubview:self.collection];
}

- (void)createData {
    NSUInteger sectionCount = 5;
    for (NSUInteger i = 0; i < sectionCount; i++) {
        NSMutableArray <Model *>*array = [NSMutableArray array];
        for (NSUInteger j = 0; j < 50; j++) {
            Model *model = [[Model alloc] init];
            model.bgColor = [UIColor colorWithRed:(arc4random()%225)/225.0 green:(arc4random()%225)/225.0 blue:(arc4random()%225)/225.0 alpha:1.0];
            model.contentSize = 40 + arc4random()%200;
            [array addObject:model];
        }
        
        [self.dataArray addObject:array];
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([HeaderView class]) forIndexPath:indexPath];
}

#pragma mark - HeeeCollectionWaterfallLayoutDelegate
- (CGFloat)cellHeightWithLayout:(HeeeCollectionWaterfallLayout *)layout indexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.section][indexPath.row].contentSize;
}

- (CGFloat)headerHeightWithLayout:(HeeeCollectionWaterfallLayout *)layout indexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - getter
- (HeeeCollectionWaterfallLayout *)layout {
    if (!_layout) {
        _layout = [[HeeeCollectionWaterfallLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.headerViewFixedTop = YES;
        _layout.delegate = self;
        _layout.numberLine = 4;
        _layout.lineSpacing = 8;
        _layout.interitemSpacing = 8;
        _layout.contentInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    
    return _layout;
}

- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        collection.backgroundColor = [UIColor whiteColor];
        collection.delegate = self;
        collection.dataSource = self;
        [collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CollectionViewCell class])];
        [collection registerClass:[HeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HeaderView class])];
        
        _collection = collection;
    }
    
    return _collection;
}

- (NSMutableArray<NSMutableArray<Model *> *> *)dataArray {
    if (!_dataArray) {
         _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

@end
