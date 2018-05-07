#import <UIKit/UIKit.h>
#import "NiceComment.h"

@interface DuanziItem : NSObject

///评论数
@property (nonatomic, assign) NSInteger comment;

///段子内容
@property (nonatomic, strong) NSString * content;


@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger postTime;

@property (nonatomic, assign) NSInteger NewId;

///神评(若不为空，则展示在item里)
@property (nonatomic, strong) NiceComment * niceComments;

///热门数
@property (nonatomic, assign) NSInteger hotDegree;

///获赞数
@property (nonatomic, assign) NSInteger praise;

///分享数
@property (nonatomic, assign) NSInteger share;

///type=1
@property (nonatomic, assign) NSInteger type;
@end
