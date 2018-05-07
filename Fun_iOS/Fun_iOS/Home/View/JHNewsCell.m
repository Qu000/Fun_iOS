//
//  JHNewsCell.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHNewsCell.h"

@interface JHNewsCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *shareLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIImageView *spHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *spNickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *spContentLab;
@property (weak, nonatomic) IBOutlet UIButton *spPraiseBtn;

@property (weak, nonatomic) IBOutlet UIStackView *SPStackView;
@property (weak, nonatomic) IBOutlet UIView *SPContentView;

@end

@implementation JHNewsCell

-(void)setModel:(DuanziItem *)model{
    _model = model;
    
    self.timeLab.text = [self getTimeToTimeStr:model.postTime];
    self.contentLab.text = model.content;
    self.shareLab.text = [NSString stringWithFormat:@"%@人分享",[self changeNumberToStr:model.share]];
    

    [self.hotBtn setTitle:[self changeNumberToStr:model.hotDegree] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[self changeNumberToStr:model.comment] forState:UIControlStateNormal];
    [self.praiseBtn setTitle:[self changeNumberToStr:model.praise] forState:UIControlStateNormal];
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    
    if (model.niceComments.userName) {
        [self.spHeadImage downloadImage:model.niceComments.avatar placeholder:@"placeHolderHead"];
    }else{
        self.SPStackView.hidden = YES;
    }
    
    self.spNickNameLab.text = model.niceComments.userName;
    self.spContentLab.text = model.niceComments.content;
    [self.spPraiseBtn setTitle:[NSString stringWithFormat:@"  %@",[self changeNumberToStr:model.niceComments.praise]] forState:UIControlStateNormal];
    
    self.SPContentView.layer.cornerRadius = 20;
    self.SPContentView.layer.masksToBounds = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark --- 时间戳转为时间串
- (NSString *)getTimeToTimeStr:(NSInteger)nowTime{
    CGFloat time = nowTime/1000;
    NSDate * detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [dateFormatter stringFromDate:detailDate];
    return timeStr;
}

#pragma mark --- 转换点赞，评论，热门，转发 数
- (NSString *)changeNumberToStr:(NSInteger)number{
    if (number > 10000) {
        NSMutableString *hotStr =  [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%ld",number]];
        NSInteger index = number%10000;
        
        //假定百万为顶级
        if (index>10) {
            [hotStr insertString:@"." atIndex:2];
        }else if (index>100) {
            [hotStr insertString:@"." atIndex:3];
        }else {
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
