//
//  JHGifItem.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/14.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NiceComment.h"
#import "Gif.h"
@interface GifItem : NSObject

///评论数
@property (nonatomic, assign) NSInteger comment;

///段子内容
@property (nonatomic, strong) NSString * content;


@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger postTime;

@property (nonatomic, assign) NSInteger NewId;

///神评(若不为空，则展示在item里)niceComments
@property (nonatomic, strong) NSArray *niceComments;
@property (nonatomic, strong) NiceComment *niceModel;

///热门数
@property (nonatomic, assign) NSInteger hotDegree;

///获赞数
@property (nonatomic, assign) NSInteger praise;

///分享数
@property (nonatomic, assign) NSInteger share;

///type=1
@property (nonatomic, assign) NSInteger type;

///图片信息
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) Gif *gifModel;
@end
