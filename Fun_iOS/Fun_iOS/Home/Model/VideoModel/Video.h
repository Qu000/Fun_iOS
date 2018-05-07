#import <UIKit/UIKit.h>

@interface Video : NSObject

///height
@property (nonatomic, assign) NSInteger height;

///width
@property (nonatomic, assign) NSInteger width;

///时长 秒
@property (nonatomic, assign) NSInteger length;

///封面Icon
@property (nonatomic, strong) NSString * thumbUrl;

///视频url
@property (nonatomic, strong) NSString * url;



@end
