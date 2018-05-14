//
//  JHVideoPlayerView.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoItem.h"

@interface JHVideoPlayerView : UIView

- (void)playWithVideoInfo:(VideoItem *)VideoInfo;

///视频播放器
@property (nonatomic, strong) AVPlayer *player;

///视频Model数据源 playInfos
@property (nonatomic, strong) NSMutableArray *dataList;

/** url*/
@property (nonatomic, strong) NSString *url;

@end
