//
//  JHSeeViewController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/2.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHSeeViewController.h"
#import "JHVideoPlayerView.h"
//#import "JHVideoTool.h"
#import "VideoItem.h"

@interface JHSeeViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 播放器*/
@property (nonatomic, strong) JHVideoPlayerView * videoPlayer;

/** tableView*/
@property (nonatomic, strong) UITableView *tableView;

/**
 * 数据源
 * 需要将该数据源传至播放器里
 */
@property (nonatomic, strong) NSMutableArray * dataList;

@end

@implementation JHSeeViewController

#pragma mark --- 横屏竖屏检测
- (void)viewWillLayoutSubviews{
    
    [self shouldRotateToOrientation:(UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation];
    
}

-(void)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    
    if (orientation == UIDeviceOrientationPortrait ||orientation ==
        UIDeviceOrientationPortraitUpsideDown) { // 竖屏
        
        self.navigationController.navigationBar.hidden = NO;
        self.tabBarController.tabBar.hidden = NO;
        
    } else { // 横屏
        
        self.navigationController.navigationBar.hidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        
    }

}



-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadNewData];
    
}

#pragma mark --- 初始化播放器View
- (void)setupPlayerView
{
    JHVideoPlayerView *playerView = [[[NSBundle mainBundle] loadNibNamed:@"JHVideoPlayerView" owner:nil options:nil] lastObject];
    playerView.dataList = self.dataList;
    [self.view addSubview:playerView];
    VideoItem *videoInfos = [self.dataList firstObject];
    [playerView playWithVideoInfo:videoInfos];
    self.videoPlayer = playerView;
    
    CGFloat tableViewH = SCREEN_HEIGHT - playerView.height - 64 - 49;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(playerView.frame), SCREEN_WIDTH, tableViewH)];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;

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
        
        NSArray *newData = [VideoItem mj_objectArrayWithKeyValuesArray:responseObject[@"items"]];
        
        //将最新的数据，添加到总数组的最  前 面
        NSRange range = NSMakeRange(0, newData.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataList insertObjects:newData atIndexes:set];
        
        [self setupPlayerView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error);
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

#pragma mark - UITableView DataSource 实现数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"videoInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.backgroundColor = JHRGB(136, 73, 253);
    
    VideoItem *videoInfo = self.dataList[indexPath.row];
    videoInfo.videoModel = [Video mj_objectWithKeyValues:videoInfo.videos.firstObject];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentPlayingUrl = [defaults objectForKey:@"currentPlayingUrl"];
    if ([currentPlayingUrl isEqualToString:videoInfo.videoModel.url]) {
        cell.textLabel.textColor = [UIColor orangeColor];
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = videoInfo.content;
    
//    cell.imageView.layer.cornerRadius = 25;
//    cell.imageView.layer.masksToBounds = YES;
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:videoInfo.videoModel.thumbUrl] placeholderImage:[UIImage imageNamed:@"placeHolderHead"]];
    
    return cell;
}

#pragma mark - UITableView Delegate 实现代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.videoPlayer.player pause];
    
    VideoItem *videoInfo = self.dataList[indexPath.row];
    
    [self.videoPlayer playWithVideoInfo:videoInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
