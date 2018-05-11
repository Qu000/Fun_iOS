//
//  JHVideoCell.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHVideoCell.h"

#import <MediaPlayer/MediaPlayer.h>
/*
 block绑定btn事件，控制器的cell里模导出播放器！//16:9是主流媒体的样式
 */
@interface JHVideoCell()

@property (nonatomic, weak)UIView *thumbView;
@property (nonatomic, assign)CGFloat thumbH;
@property (nonatomic, assign)CGFloat thumbW;
@property (nonatomic, assign)NSInteger videoLength;
/** 播放器*/
@property (nonatomic, strong) MPMoviePlayerController * MPPlayer;
@property (nonatomic, weak) UIButton *playBtn;
@property (nonatomic, weak) UIImageView *playImage;

@property (nonatomic, weak)UILabel *timeLab;
@property (nonatomic, weak)UILabel *shareLab;

@property (nonatomic, weak)UIButton *hotBtn;
@property (nonatomic, weak)UILabel *hotLab;
@property (nonatomic, weak)UIButton *commentBtn;
@property (nonatomic, weak)UILabel *commentLab;
@property (nonatomic, weak)UIButton *praiseBtn;
@property (nonatomic, weak)UILabel *praiseLab;
@property (nonatomic, weak)UIButton *shareBtn;
@property (nonatomic, weak)UILabel *shareLab2;

@property (nonatomic, weak)UILabel *contentLab;

@property (nonatomic, weak)UIImageView *spHeadImage;
@property (nonatomic, weak)UILabel *spNickNameLab;
@property (nonatomic, weak)UILabel *spContentLab;
@property (nonatomic, weak)UIButton *spPraiseBtn;

@property (nonatomic, weak)UIView *spContentView;

@end

@implementation JHVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    
    // Initialization code
}

- (void)setupUI{
    UIView *thumbView = [[UIView alloc]init];
    thumbView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:thumbView];
    [thumbView setBackgroundColor:[UIColor clearColor]];
    self.thumbView = thumbView;
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc]init];
    [self.thumbView addSubview:player.view];
    self.MPPlayer = player;
    //playImage
    UIImageView *playImage= [[UIImageView alloc]init];
    [self.MPPlayer.view addSubview:playImage];
    self.playImage = playImage;
    //playBtn
    UIButton *playerBtn = [[UIButton alloc]init];
    [playerBtn setImage:[UIImage imageNamed:@"player_start_iphone_fullscreen"] forState:UIControlStateNormal];
    [playerBtn setBackgroundColor:[UIColor clearColor]];
    [playerBtn addTarget:self action:@selector(clickToPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.MPPlayer.view addSubview:playerBtn];
    self.playBtn = playerBtn;
    //监听播放状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateChange) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //监听播放完成
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishedPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    UILabel *timeLab= [[UILabel alloc]init];
    [timeLab setTextColor:JHRGB(0, 158, 156)];//JHRGB(57, 185, 170)
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.numberOfLines = 0;
    [timeLab setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:timeLab];
    self.timeLab = timeLab;
    
    UILabel *shareLab= [[UILabel alloc]init];
    [shareLab setTextColor:JHRGB(0, 158, 156)];
    shareLab.textAlignment = NSTextAlignmentRight;
    shareLab.numberOfLines = 0;
    [shareLab setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:shareLab];
    self.shareLab = shareLab;
    
    self.hotBtn = [self createButton];
    [self.hotBtn setImage:[UIImage imageNamed:@"fire"] forState:UIControlStateNormal];
    self.commentBtn = [self createButton];
    [self.commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    self.praiseBtn = [self createButton];
    [self.praiseBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
    self.shareBtn = [self createButton];
    [self.shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    
    self.hotLab = [self createBtnTitle];
    self.commentLab = [self createBtnTitle];
    self.praiseLab = [self createBtnTitle];
    self.shareLab2 = [self createBtnTitle];
    
    UILabel *contentLab = [[UILabel alloc]init];
    [contentLab setTextColor:JHRGB(0, 158, 156)];
//    [contentLab setBackgroundColor:JHRGB(255, 205, 237)];
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.numberOfLines = 0;
    [self addSubview:contentLab];
    self.contentLab = contentLab;
    
    UIView *SPContentView = [[UIView alloc]init];
    [SPContentView setBackgroundColor:JHRGB(255, 205, 237)];
    [self addSubview:SPContentView];
    self.spContentView = SPContentView;

    UIImageView *spHeadImage = [[UIImageView alloc]init];
    [self.spContentView addSubview:spHeadImage];
    self.spHeadImage = spHeadImage;

    self.spNickNameLab = [self createLabel];
    self.spContentLab = [self createLabel];

    UIButton *SPPraiseBtn = [[UIButton alloc]init];
    [SPPraiseBtn setTitleColor:JHRGB(0, 158, 156) forState:UIControlStateNormal];
    SPPraiseBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    SPPraiseBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [SPPraiseBtn setImage:[UIImage imageNamed:@"praise2"] forState:UIControlStateNormal];
    [self.spContentView addSubview:SPPraiseBtn];
    self.spPraiseBtn = SPPraiseBtn;
    
    self.spContentView.layer.cornerRadius = 14;
    self.spContentView.layer.masksToBounds = YES;
    
    self.spHeadImage.layer.cornerRadius = 25;
    self.spHeadImage.layer.masksToBounds = YES;
    
}

- (void)setModel:(VideoItem *)model{
    _model = model;
    
    model.videoModel = [Video mj_objectWithKeyValues:model.videos.firstObject];

    [self.playImage downloadImage:model.videoModel.thumbUrl placeholder:@"placeHolderHead"];
    self.MPPlayer.contentURL = [NSURL URLWithString:model.videoModel.url];
    
//    NSLog(@"model.videoModel.url=%@",model.videoModel.url);
    
    self.timeLab.text = [self getTimeToTimeStr:model.postTime];
    self.contentLab.text = model.content;
    self.shareLab.text = [NSString stringWithFormat:@"%@人分享",[self changeNumberToStr:model.share]];

    
    self.hotLab.text = [self changeNumberToStr:model.hotDegree];
    self.commentLab.text = [self changeNumberToStr:model.comment];
    self.praiseLab.text = [self changeNumberToStr:model.praise];
    self.shareLab2.text = @"分享";

    
    model.niceModel = [NiceComment mj_objectWithKeyValues:model.niceComments.firstObject];
//    NSLog(@"userName=%@",model.niceModel.userName);
    if (model.niceModel.userName) {
        [self.spHeadImage downloadImage:model.niceModel.avatar placeholder:@"placeHolderHead"];
        self.spContentView.hidden = NO;
    }else{
        self.spContentView.hidden = YES;
    }
    
    self.spNickNameLab.text = model.niceModel.userName;
    self.spContentLab.text = model.niceModel.content;
    [self.spPraiseBtn setTitle:[NSString stringWithFormat:@"  %@",[self changeNumberToStr:model.niceModel.praise]] forState:UIControlStateNormal];
    
    
    
}
- (void)layoutSubviews{

    self.timeLab.frame = CGRectMake(10, 10, 150, 18);
    
    CGFloat shareLabX = CGRectGetMaxX(self.timeLab.frame)+10;
    self.shareLab.frame = CGRectMake(shareLabX, 10, 100, 18);
    
    self.thumbW = 300;
    self.thumbH = 300;
    self.thumbView.frame = CGRectMake(0, CGRectGetMaxY(self.shareLab.frame), self.thumbW, self.thumbH);
    self.MPPlayer.view.frame = self.thumbView.frame;
    self.playImage.frame = self.thumbView.frame;
    self.playBtn.frame = CGRectMake(self.MPPlayer.view.centerX-25, self.MPPlayer.view.centerY-25, 50, 50);
//    self.playBtn.frame = self.thumbImage.frame;
    
//    300/4=75
    CGFloat btnWH = 50;
    CGFloat labH = 20;
    CGFloat M = 5;
    self.hotBtn.frame = CGRectMake(self.thumbW, 0, btnWH, btnWH);
    self.hotLab.frame = CGRectMake(self.thumbW, CGRectGetMaxY(self.hotBtn.frame), btnWH, labH);
    
    self.commentBtn.frame = CGRectMake(self.thumbW, CGRectGetMaxY(self.hotLab.frame)+M, btnWH, btnWH);
    self.commentLab.frame = CGRectMake(self.thumbW, CGRectGetMaxY(self.commentBtn.frame), btnWH, labH);
    
    self.praiseBtn.frame = CGRectMake(self.thumbW, CGRectGetMaxY(self.commentLab.frame)+M, btnWH, btnWH);
    self.praiseLab.frame = CGRectMake(self.thumbW, CGRectGetMaxY(self.praiseBtn.frame), btnWH, labH);
    
    self.shareBtn.frame = CGRectMake(self.thumbW, CGRectGetMaxY(self.praiseLab.frame)+M, btnWH, btnWH);
    self.shareLab2.frame = CGRectMake(self.thumbW, CGRectGetMaxY(self.shareBtn.frame), btnWH, labH);
    
    CGSize size = CGSizeMake(self.frame.size.width, 1000);
    UIFont *contentLabFont = [UIFont fontWithName:@"Arial" size:14];
    CGSize contentLabSize = [self.contentLab.text sizeWithFont:contentLabFont constrainedToSize:size];
    self.contentLab.frame = CGRectMake(0, CGRectGetMaxY(self.shareBtn.frame)+120, self.frame.size.width, contentLabSize.height);
    
    //spContentView
    if (self.spNickNameLab.text.length == 0) {
        self.spContentView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLab.frame)+10, self.frame.size.width, 20);
    }else{
        CGFloat spContentViewH = 50;
        self.spContentView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLab.frame)+10, self.frame.size.width, spContentViewH);
        
        self.spHeadImage.frame = CGRectMake(0, 0, 50, 50);
        self.spNickNameLab.frame = CGRectMake(CGRectGetMaxX(self.spHeadImage.frame)+5, 5, 80, 18);
        self.spContentLab.frame = CGRectMake(CGRectGetMaxX(self.spHeadImage.frame)+5, CGRectGetMaxY(self.spNickNameLab.frame)+5, self.frame.size.width-CGRectGetMaxX(self.spHeadImage.frame)-5-5, 18);
        
        CGFloat spPraiseBtnX = 80+5+CGRectGetMaxX(self.spNickNameLab.frame);
        self.spPraiseBtn.frame = CGRectMake(spPraiseBtnX, 5, 80, 18);
    }
    CGFloat itemH = CGRectGetMaxY(self.spContentView.frame)+20;
    self.block(itemH);
    
}



- (UIButton *)createButton{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitleColor:JHRGB(0, 158, 156) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:btn];
    return btn;
}
- (UILabel *)createBtnTitle{
    UILabel *lab = [[UILabel alloc]init];
    [lab setTextColor:JHRGB(0, 158, 156)];
    [lab setFont:[UIFont systemFontOfSize:11]];
    lab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab];
    return lab;
}
- (UILabel *)createLabel{
    UILabel *lab= [[UILabel alloc]init];
    [lab setTextColor:JHRGB(0, 158, 156)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.numberOfLines = 0;
    [lab setFont:[UIFont systemFontOfSize:11]];
    [self.spContentView addSubview:lab];
    return lab;
}


#pragma mark --- 播放视频
- (void)clickToPlay:(UIButton *)btn{
    [self.MPPlayer prepareToPlay];
    [self.MPPlayer play];
    [self.playImage removeFromSuperview];
}
#pragma mark -播放器事件监听
- (void)stateChange{
    switch (self.MPPlayer.playbackState) {
        case MPMoviePlaybackStatePaused:
        {
            self.playBtn.hidden = NO;
//            [self.playBtn removeFromSuperview];
            NSLog(@"暂停");
            break;
        }
        case MPMoviePlaybackStatePlaying:
        {
//            [self.playBtn removeFromSuperview];
            self.playBtn.hidden = YES;
            NSLog(@"播放");
            break;
        }
        case MPMoviePlaybackStateStopped:
        {
            //注意：正常播放完成，是不会触发MPMoviePlaybackStateStopped事件的。
            
            //调用[self.player stop];方法可以触发此事件
            self.playBtn.hidden = NO;
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
#pragma mark --- 监听移除
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"--dealloc--");
}

#pragma mark --- 时间戳转为时间串
- (NSString *)getTimeToTimeStr:(NSInteger)nowTime{
    CGFloat time = nowTime/1000.0;
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [dateFormatter stringFromDate:detailDate];
    return timeStr;
}

#pragma mark --- 转换点赞，评论，热门，转发 数
- (NSString *)changeNumberToStr:(NSInteger)number{
    if (number > 10000) {
        NSMutableString *hotStr =  [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%ld",number]];
        NSInteger index = number/10000;
        
        //假定百万为顶级
        if (index>=10) {
            [hotStr insertString:@"." atIndex:2];
        }else if (index>100) {
            [hotStr insertString:@"." atIndex:3];
        }else if (index < 10 || index > 1000){
            [hotStr insertString:@"." atIndex:1];
        }
        
        NSRange range = [hotStr rangeOfString:@"."];
        NSUInteger idx = range.location;
        //显示小数点后两位
        NSString *needStr = [NSString stringWithFormat:@"%@万",[hotStr substringToIndex:idx+3]];
        
        return needStr;
        
    }else {
        NSString *needStr = [NSString stringWithFormat:@"%ld",number];
        return needStr;
    }
}


@end
