//
//  JHVideoViewController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHVideoViewController.h"
#import "JHVideoCell.h"

@interface JHVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHVideoViewController

static NSString * const reuseIdentifier = @"JHVideoCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDefault];
}

- (void)setupDefault{
    
    CGFloat itemWidth = 100;
    CGFloat itemHeight = 100;
    UICollectionViewFlowLayout *shareflowLayout = [[UICollectionViewFlowLayout alloc] init];
    shareflowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    shareflowLayout.itemSize =CGSizeMake(itemWidth, itemHeight);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) collectionViewLayout:shareflowLayout];
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JHVideoCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
//    collectionView.delaysContentTouches = NO;
//    collectionView.scrollEnabled = YES;
//    collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHVideoCell *cell = (JHVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>


@end
