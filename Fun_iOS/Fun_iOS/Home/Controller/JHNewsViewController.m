//
//  JHNewsViewController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHNewsViewController.h"
#import "JHNewsCell.h"

@interface JHNewsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHNewsViewController

static NSString * const reuseIdentifier = @"JHNewsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDefault];
}

- (void)setupDefault{
    
    CGFloat itemWidth = (SCREEN_WIDTH - 40 ) / 4.5;
    CGFloat itemHeight = 100;
    UICollectionViewFlowLayout *shareflowLayout = [[UICollectionViewFlowLayout alloc] init];
    shareflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    shareflowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 15);
    shareflowLayout.itemSize =CGSizeMake(itemWidth, itemHeight);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) collectionViewLayout:shareflowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JHNewsCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    collectionView.delegate = self;
    collectionView.delaysContentTouches = NO;
    collectionView.scrollEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHNewsCell *cell = (JHNewsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
