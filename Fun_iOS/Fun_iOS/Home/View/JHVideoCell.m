//
//  JHVideoCell.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHVideoCell.h"

@interface JHVideoCell()

@property (nonatomic, weak)UILabel *timeLab;
@property (nonatomic, weak)UILabel *shareLab;

@property (nonatomic, weak)UIButton *hotBtn;
@property (nonatomic, weak)UIButton *commentBtn;
@property (nonatomic, weak)UIButton *praiseBtn;
@property (nonatomic, weak)UIButton *shareBtn;

@property (nonatomic, weak)UILabel *contentLab;

@property (nonatomic, weak)UIImageView *SPHeadImage;
@property (nonatomic, weak)UILabel *SPNickNameLab;
@property (nonatomic, weak)UILabel *SPContentLab;
@property (nonatomic, weak)UIButton *SPPraiseBtn;

@property (nonatomic, weak)UIView *SPContentView;

@end

@implementation JHVideoCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    UILabel *timeLab= [[UILabel alloc]init];
    [timeLab setTextColor:JHRGB(57, 185, 170)];
    timeLab.textAlignment = NSTextAlignmentLeft;
    timeLab.numberOfLines = 0;
    [timeLab setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:timeLab];
    self.timeLab = timeLab;
    
    UILabel *shareLab= [[UILabel alloc]init];
    [shareLab setTextColor:JHRGB(255, 143, 0)];
    shareLab.textAlignment = NSTextAlignmentLeft;
    shareLab.numberOfLines = 0;
    [shareLab setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:shareLab];
    self.shareLab = shareLab;
    
    self.hotBtn = [self createButton];
    self.commentBtn = [self createButton];
    self.praiseBtn = [self createButton];
    self.shareBtn = [self createButton];
    
    UILabel *contentLab = [[UILabel alloc]init];
    [contentLab setTextColor:[UIColor orangeColor]];
    contentLab.textAlignment = NSTextAlignmentLeft;
    contentLab.numberOfLines = 0;
    [contentLab setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:contentLab];
    self.contentLab = contentLab;
    
    UIView *SPContentView = [[UIView alloc]init];
    [self addSubview:SPContentView];
    self.SPContentView = SPContentView;
    
    UIImageView *spHeadImage = [[UIImageView alloc]init];
    [self.SPContentView addSubview:spHeadImage];
    self.SPHeadImage = spHeadImage;
    
    self.SPNickNameLab = [self createLabel];
    self.SPContentLab = [self createLabel];
    
    UIButton *SPPraiseBtn = [[UIButton alloc]init];
    [SPPraiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SPPraiseBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    SPPraiseBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.SPContentView addSubview:SPPraiseBtn];
    self.SPPraiseBtn = SPPraiseBtn;
}

- (void)layoutSubviews{
    
}



- (UIButton *)createButton{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:btn];
    return btn;
}
- (UILabel *)createLabel{
    UILabel *lab= [[UILabel alloc]init];
    [lab setTextColor:[UIColor whiteColor]];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.numberOfLines = 0;
    [lab setFont:[UIFont systemFontOfSize:11]];
    [self.SPContentView addSubview:lab];
    return lab;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
