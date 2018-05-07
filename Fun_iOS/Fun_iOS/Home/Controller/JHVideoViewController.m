//
//  JHVideoViewController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHVideoViewController.h"
#import "JHVideoCell.h"
#import "customLayout.h"

#import "VideoItem.h"

@interface JHVideoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray * dataList;
@property (nonatomic, strong)NSMutableArray * tempArr;

@end

@implementation JHVideoViewController

static NSString * const reuseIdentifier = @"JHVideoCell";

-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
-(NSMutableArray *)tempArr{
    if (!_tempArr) {
        _tempArr = [[NSMutableArray alloc]init];
    }
    return _tempArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDefault];
    
    [self loadNewData];
}

#pragma mark --- 获取数据
- (void)loadNewData{
    NSString * timeSp = [self getNowTime];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramer = @{@"_ts":timeSp,
                              @"offset":@"0"
                              };
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,API_Video];
    //接收参数类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 15;
    [manager GET:url parameters:paramer progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSArray *newData = [VideoItem mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
        
        //将最新的数据，添加到总数组的最  前 面
        NSRange range = NSMakeRange(0, newData.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataList insertObjects:newData atIndexes:set];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
    }];
}

#pragma mark --- 获取当前时间戳
- (NSString *)getNowTime{
    // 获取时间（非本地时区，需转换）
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    // 转换成当地时间
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];//@"1517468580"
    return timeSp;
}


- (void)setupDefault{
    
    customLayout *layout = [[customLayout alloc]initWithType:LayoutTypeLinear];
    layout.itemSize = CGSizeMake(250, 250);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) collectionViewLayout:layout];
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JHVideoCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.dataList.count != 0) {
        return self.dataList.count;
    }else{
        return 4;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHVideoCell *cell = (JHVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *curIndexPath = [self curIndexPath];
    if (indexPath.row == curIndexPath.row) {
        return YES;
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    return NO;
}




#pragma mark -- 控制导航栏的显示与隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //拿到scroll的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    
    //获得拖拽的速度 >0 向下拖动  <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity < -5) {
        //向上,隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else if(velocity > 5){
        //向下,显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else if(velocity == 0){
        //停止拖拽
    }
}
@end
