//
//  JHGifCell.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/14.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHGifCell.h"

@interface JHGifCell()

/** 测试图 */
@property(nonatomic, weak) UIImageView *imageView;

@end
@implementation JHGifCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}
-(void)setupUI{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    self.imageView = imageView;
}
-(void)layoutSubviews{
    
    self.imageView.frame = self.frame;
}
-(void)setModel:(GifItem *)model{
    _model = model;
    
    model.gifModel = [Gif mj_objectWithKeyValues:model.images.firstObject];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.gifModel.thumbUrl] placeholderImage:[UIImage imageNamed:@"placeHolderHead"]];
    
}
@end
