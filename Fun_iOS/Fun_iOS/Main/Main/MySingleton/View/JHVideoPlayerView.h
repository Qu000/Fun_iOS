//
//  JHVideoPlayerView.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoItem.h"

@interface JHVideoPlayerView : UIView

- (void)playWithVideoInfo:(VideoItem *)VideoInfo;

///视频Model数据源 playInfos
@property (nonatomic, strong)NSMutableArray *dataList;

@end
