//
//  JHVideoCell.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHVideoCell.h"

/*
 block绑定btn事件，控制器的cell里模导出播放器！//16:9是主流媒体的样式
 */
@interface JHVideoCell()

///承载thumbImage的View
@property (weak, nonatomic) IBOutlet UIView *thumbView;
///thumbImage
@property (nonatomic, weak) UIImageView *thumbImage;
@property (nonatomic, assign)CGFloat thumbH;
@property (nonatomic, assign)CGFloat thumbW;
@property (nonatomic, assign)NSInteger videoLength;


@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *shareLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (nonatomic, weak)UILabel *hotLab;

@property (nonatomic, weak)UILabel *commentLab;

@property (nonatomic, weak)UILabel *praiseLab;

@property (nonatomic, weak)UILabel *shareLab2;

///神评
@property (weak, nonatomic) IBOutlet UIView *spView;
@property (weak, nonatomic) IBOutlet UIImageView *spHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *spNickNameLab;
@property (weak, nonatomic) IBOutlet UIButton *spPraiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *spContentLab;


@end

@implementation JHVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    
    // Initialization code
}

- (void)setupUI{
    
    self.spHeadImage.layer.cornerRadius = 25;
    self.spHeadImage.layer.masksToBounds = YES;
    
}

- (void)setModel:(VideoItem *)model{
    _model = model;
    
    model.videoModel = [Video mj_objectWithKeyValues:model.videos.firstObject];
    
    [self.thumbImage sd_setImageWithURL:[NSURL URLWithString:model.videoModel.thumbUrl] placeholderImage:[UIImage imageNamed:@"placeHolderHead"]];
    NSLog(@"model.videoModel.thumbUrl=%@",model.videoModel.thumbUrl);
    self.timeLab.text = [self getTimeToTimeStr:model.postTime];
    self.contentLab.text = model.content;
    self.shareLab.text = [NSString stringWithFormat:@"%@人分享",[self changeNumberToStr:model.share]];

    
    self.hotLab.text = [self changeNumberToStr:model.hotDegree];
    self.commentLab.text = [self changeNumberToStr:model.comment];
    self.praiseLab.text = [self changeNumberToStr:model.praise];
    self.shareLab2.text = @"分享";

    
    model.niceModel = [NiceComment mj_objectWithKeyValues:model.niceComments.firstObject];

    NSLog(@"model.niceModel.avatar=%@",model.niceModel.avatar);
    if (model.niceModel.content) {
        
        [self.spHeadImage sd_setImageWithURL:[NSURL URLWithString:model.niceModel.avatar] placeholderImage:[UIImage imageNamed:@"placeHolderHead"]];
        self.spView.hidden = NO;
    }else{
        self.spView.hidden = YES;
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
    self.thumbImage.frame = CGRectMake(0, 0, self.thumbW, self.thumbH);
    //CGRectGetMaxY(self.shareLab.frame)
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
        self.spView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLab.frame)+10, self.frame.size.width, 20);
    }else{
        CGFloat spContentViewH = 50;
        self.spView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLab.frame)+10, self.frame.size.width, spContentViewH);
        
        self.spHeadImage.frame = CGRectMake(0, 0, 50, 50);
        self.spNickNameLab.frame = CGRectMake(CGRectGetMaxX(self.spHeadImage.frame)+5, 5, 80, 18);
        self.spContentLab.frame = CGRectMake(CGRectGetMaxX(self.spHeadImage.frame)+5, CGRectGetMaxY(self.spNickNameLab.frame)+5, self.frame.size.width-CGRectGetMaxX(self.spHeadImage.frame)-5-5, 18);
        
        CGFloat spPraiseBtnX = 80+5+CGRectGetMaxX(self.spNickNameLab.frame);
        self.spPraiseBtn.frame = CGRectMake(spPraiseBtnX, 5, 80, 18);
    }
    CGFloat itemH = CGRectGetMaxY(self.spView.frame)+20;
    self.block(itemH);
    
}


#pragma mark --- 播放视频

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
