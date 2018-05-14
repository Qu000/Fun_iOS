//
//  JHMediaViewController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/13.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHMediaViewController.h"

@interface JHMediaViewController ()
@property(nonatomic, weak) UIImageView *placeHolderView;
@property (nonatomic, weak) UIButton *goBackBtn;
@property (nonatomic, weak) UIButton *playBtn;




@end

@implementation JHMediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    
    UIButton *goBackBtn = [[UIButton alloc]init];
    [goBackBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    goBackBtn.frame = CGRectMake(10, 20, 20, 20);
    [goBackBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    
    UIButton *playBtn = [[UIButton alloc]init];
    playBtn.frame = CGRectMake(SCREEN_WIDTH-20-40, 20, 40, 40);
    [self.playBtn setImage:[UIImage imageNamed:@"player_start_iphone_fullscreen"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(clickToPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
   
}
- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI{
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] init];
    player.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, 600);
    player.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:player.view];
    self.MPPlayer = player;
    
    
    //监听播放状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateChange) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //监听播放完成
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
}
- (void)clickToPlay{
//    [self.MPPlayer play];
}
#pragma mark -播放器事件监听
- (void)stateChange{
    switch (self.MPPlayer.playbackState) {
        case MPMoviePlaybackStatePaused:
        {
            
            NSLog(@"暂停");
            [self.playBtn setImage:[UIImage imageNamed:@"player_start_iphone_fullscreen"] forState:UIControlStateNormal];
            break;
        }
        case MPMoviePlaybackStatePlaying:
        {
            
            NSLog(@"播放");
            [self.playBtn setImage:[UIImage imageNamed:@"player_pause_iphone_fullscreen"] forState:UIControlStateNormal];
            break;
        }
        case MPMoviePlaybackStateStopped:
        {
            //注意：正常播放完成，是不会触发MPMoviePlaybackStateStopped事件的。
            
            //调用[self.player stop];方法可以触发此事件
            
            NSLog(@"停止");
            break;
        }
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"中断");
            break;
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"快进");
            break;
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"快退");
            break;
        default:
            break;
    }
}
- (void)finishedPlay{
    
    NSLog(@"播放完成");
}

#pragma mark --- 纯MediaPlay
-(void)playWithVideoInfo:(VideoItem *)VideoInfo{
    VideoInfo.videoModel = [Video mj_objectWithKeyValues:VideoInfo.videos.firstObject];
    
    
    if (self.MPPlayer.playbackState == MPMoviePlaybackStatePlaying) {
        return;
    }
    
    self.placeHolderView.hidden = NO;
    [self.placeHolderView sd_setImageWithURL:[NSURL URLWithString:VideoInfo.videoModel.thumbUrl] placeholderImage:[UIImage imageNamed:@"placeHolderHead"]];
    self.MPPlayer.contentURL = [NSURL URLWithString:VideoInfo.videoModel.url];
    
    
    [self.MPPlayer prepareToPlay];
    [self.MPPlayer play];
    
}

-(void)dealloc{
    //移除所有通知监控
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end
