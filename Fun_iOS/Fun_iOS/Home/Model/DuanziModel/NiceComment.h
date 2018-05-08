#import <Foundation/Foundation.h>

@interface NiceComment : NSObject

///神评头像
@property (nonatomic, strong) NSString * avatar;

///神评nickname
@property (nonatomic, strong) NSString * userName;

///神评内容
@property (nonatomic, strong) NSString * content;

///
@property (nonatomic, assign) NSInteger NewId;

///是否为神评
@property (nonatomic, assign) BOOL isNice;

///
@property (nonatomic, assign) NSInteger postTime;

///神评获赞数
@property (nonatomic, assign) NSInteger praise;

@end
