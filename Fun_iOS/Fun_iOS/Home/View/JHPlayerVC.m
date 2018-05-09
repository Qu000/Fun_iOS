//
//  JHPlayerVC.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/9.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHPlayerVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface JHPlayerVC ()
/** 播放器*/
@property (nonatomic, strong) MPMoviePlayerController *MPPlayer;

/** playBtn */
@property(nonatomic, weak) UIButton *playBtn;
/** image */
@property(nonatomic, weak) UIImageView *imageView;
/** index */
@property(nonatomic, assign) NSInteger index;
@end

@implementation JHPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupToPlay];
    
    [self setupUI];
}

- (void)setupToPlay{
    //根据URL创建播放器
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"testMovie.mp4" withExtension:nil];
    
    NSURL *url = [NSURL URLWithString:self.url];//127.0.0.1
    
    
    MPMoviePlayerController *MPPlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    
    //设置播放器的视图
    [self.view addSubview:MPPlayer.view];
    MPPlayer.view.frame = self.view.bounds;
    self.MPPlayer = MPPlayer;
    
    //适配播放器View，实现旋转
    [self.MPPlayer.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.MPPlayer.view}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:@{@"view":self.MPPlayer.view}]];
    
    
    
    //准备播放
    [self.MPPlayer prepareToPlay];
    [self.MPPlayer play];
    
}

- (void)setupUI{
    
//    UIButton *playBtn = [[UIButton alloc]init];
//    [playBtn setBackgroundColor:[UIColor clearColor]];
//    [playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    [playBtn addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
//    playBtn.frame = CGRectMake(self.view.centerX, self.view.centerY, 50, 50);
//    [self.view addSubview:playBtn];
//    self.playBtn = playBtn;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [imageView setImage:[UIImage imageNamed:self.thumbImage]];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
}
- (void)clickPlayBtn:(UIButton *)btn{
    if (btn.selected) {
        [self.MPPlayer play];
        [btn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        btn.hidden = YES;
        self.imageView.hidden = YES;
    }else{
        [self.MPPlayer pause];
        [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        btn.hidden = NO;
//        self.imageView.hidden = NO;
    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.imageView.hidden = YES;
    if (self.index%2==0) {
        [self.MPPlayer pause];
    }else{
        [self.MPPlayer play];
    }
    
    self.index++;
}
@end
