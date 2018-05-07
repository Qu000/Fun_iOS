#import <UIKit/UIKit.h>
#import "Video.h"
#import "NiceComment.h"

@interface VideoItem : NSObject
///评论数
@property (nonatomic, assign) NSInteger comment;

///视频介绍内容
@property (nonatomic, strong) NSString * content;


@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger postTime;

@property (nonatomic, assign) NSInteger NewId;

///热门数
@property (nonatomic, assign) NSInteger hotDegree;

///神评(如果存在，就展示到item里)
@property (nonatomic, strong) NiceComment * niceComments;

///该评论获赞数
@property (nonatomic, assign) NSInteger praise;

///该评论分享数
@property (nonatomic, assign) NSInteger share;

///该评论所属type3-视频
@property (nonatomic, assign) NSInteger type;

///视频信息
@property (nonatomic, strong) Video * videos;
@end
