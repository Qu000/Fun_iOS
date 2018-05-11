//
//  JHSeeViewController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/2.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHSeeViewController.h"
#import "JHVideoPlayerView.h"
#import "JHVideoTool.h"
#import "VideoItem.h"

@interface JHSeeViewController ()

@property (nonatomic, strong) NSMutableArray * dataList;

@end

@implementation JHSeeViewController

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

// 初始化播放器View
- (void)setupPlayerView
{
    JHVideoPlayerView *playerView = [[[NSBundle mainBundle] loadNibNamed:@"JHVideoPlayerView" owner:nil options:nil] lastObject];
    playerView.dataList = self.dataList;
    [self.view addSubview:playerView];
    VideoItem *videoInfos = [self.dataList firstObject];
    [playerView playWithVideoInfo:videoInfos];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
