//
//  JHNewsViewController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHNewsViewController.h"
#import "JHNewsCell.h"
#import "customLayout.h"

#import "DuanziItem.h"

@interface JHNewsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray * dataList;
@property (nonatomic, strong)NSMutableArray * tempArr;
@property (nonatomic, assign)NSInteger offset;

/** layout*/
@property (nonatomic, strong) customLayout * layout;
//@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation JHNewsViewController

static NSString * const reuseIdentifier = @"JHNewsCell";

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
    self.offset = 0;
    [self setupCollectionDefault];
    
    [self refreshTop];

    [self refreshDowm];

    
}

#pragma mark --- 下拉刷新
- (void)refreshTop{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置不同状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i=1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gif%zd", i]];
        [idleImages addObject:image];
    }
    //普通状态
    [header setImages:idleImages forState:MJRefreshStateIdle];
    //即将刷新
    [header setImages:idleImages forState:MJRefreshStatePulling];
    //正在刷新
    [header setImages:idleImages forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置 header
    self.collectionView.mj_header = header;
    
    // 马上进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
    
    
}

#pragma mark --- 获取新数据
- (void)loadNewData{
    NSString * timeSp = [self getNowTime];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramer = @{@"_ts":timeSp,
                              @"offset":@"0"
                              };
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,API_DuanZi];
    //接收参数类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];

    //设置超时时间
    manager.requestSerializer.timeoutInterval = 15;
    [manager GET:url parameters:paramer progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"responseObject--items=%@",responseObject[@"items"]);
        NSArray *newData = [DuanziItem mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
        
        //将最新的数据，添加到总数组的最  前 面
        NSRange range = NSMakeRange(0, newData.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataList insertObjects:newData atIndexes:set];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        self.collectionView.mj_header.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        [self.collectionView.mj_header endRefreshing];
    }];
}
#pragma mark --- 上拉刷新
- (void)refreshDowm{
    
    // 设置回调（一旦进入刷新状态，就调用 target 的 action，即调用 self 的 loadOldData 方法）
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    
    // 设置不同状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gif%zd", i]];
        [idleImages addObject:image];
    }
    //普通状态
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    //即将刷新
    [footer setImages:idleImages forState:MJRefreshStatePulling];
    //正在刷新
    [footer setImages:idleImages forState:MJRefreshStateRefreshing];
    // 隐藏刷新状态文字
    footer.refreshingTitleHidden = YES;
    // 设置尾部
    self.collectionView.mj_footer = footer;
}
#pragma mark --- 获取旧数据
- (void)loadOldData{
    /*
     http://api.51touxiang.com/api/wuliao/getJoke?_ts=1525426116561&offset=16&time=1525407962000
     */
    NSString *timeSp = [self getNowTime];
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)self.offset];
    NSString *oldTimeSp = [self getOldTime:self.offset];//@"1525811592000"
    //time字段，当前时间-1小时，转为时间戳
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramer = @{@"_ts":timeSp,
                              @"offset":offsetStr,
                              @"time":oldTimeSp
                              };
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,API_DuanZi];
    //接收参数类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 15;
    [manager GET:url parameters:paramer progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSLog(@"responseObject--items=%@",responseObject[@"items"]);
        NSArray *oldData = [DuanziItem mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
     
        //将最新的数据，添加到总数组的 最  后 面
        [self.dataList addObjectsFromArray:oldData];
        
        
//        int i = (int)[self.dataList count]-1;
//        for(;i >= 0;i --){
//            //containsObject 判断元素是否存在于数组中(根据两者的内存地址判断，相同：YES  不同：NO）
//            if([oldData containsObject:[self.dataList objectAtIndex:i]]) {
//                [self.dataList removeObjectAtIndex:i];
//            }
//        }
        
        
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        self.collectionView.mj_footer.hidden = YES;
        self.offset = self.offset+8;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}
#pragma mark --- 获取当前时间戳
- (NSString *)getNowTime{
    
    //获取当前时间戳
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", time];
    
    return timeSp;
}

#pragma mark --- 获取1小时之前的时间戳
- (NSString *)getOldTime:(NSInteger)hours{
    //得到当前的时间
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //设置时间间隔（秒）
    NSInteger hoursTime = hours/8;
    NSTimeInterval time = hoursTime * 60 * 60;//小时的秒数
    //得到小时之前的当前时间
    NSDate * lastTime = [date dateByAddingTimeInterval:-time];
    NSLog(@"lastTime=%@",lastTime);
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[lastTime timeIntervalSince1970]*1000];
    return timeSp;
    
    //转化为字符串
//    NSString * startDate = [dateFormatter stringFromDate:lastTime];
}

- (void)setupCollectionDefault{
   
    customLayout *layout = [[customLayout alloc]initWithType:LayoutTypeNormal];
    layout.itemSize = CGSizeMake(300, 350);
    self.layout = layout;
    
//    UICollectionViewFlowLayout *layoutNormal = [[UICollectionViewFlowLayout alloc]init];
//    layoutNormal.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layoutNormal.itemSize = CGSizeMake(100, 100);
//    self.layout = layoutNormal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height) collectionViewLayout:self.layout];
    
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JHNewsCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    UIView *bgView = [[UIView alloc]init];
    [collectionView addSubview:bgView];
    bgView.frame = collectionView.frame;
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.frame = self.view.frame;
    [bgImage setImage:[UIImage imageNamed:@"bg-1"]];
    [bgView addSubview:bgImage];
    collectionView.backgroundView = bgView;
    
    
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

    return self.dataList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHNewsCell *cell = (JHNewsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.dataList[indexPath.row];
    cell.backgroundColor = JHRGB(249, 227, 228);
    cell.block = ^(NSInteger itemH) {
        self.layout.itemSize = CGSizeMake(350, itemH);
    };
    
    cell.layer.cornerRadius = 16;
    cell.layer.masksToBounds = YES;
    
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.row=%ld",(long)indexPath.row);
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
        
        self.collectionView.mj_header.hidden = YES;
        self.collectionView.mj_footer.hidden = NO;
    }else if(velocity > 5){
        //向下,显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        self.collectionView.mj_header.hidden = NO;
        self.collectionView.mj_footer.hidden = YES;
    }else if(velocity == 0){
        //停止拖拽
    }
}



@end
