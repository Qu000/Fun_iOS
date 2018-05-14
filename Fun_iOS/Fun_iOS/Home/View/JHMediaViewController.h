//
//  JHMediaViewController.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/13.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "VideoItem.h"

@interface JHMediaViewController : UIViewController

- (void)playWithVideoInfo:(VideoItem *)VideoInfo;

/** 播放器*/
@property (nonatomic, strong) MPMoviePlayerController * MPPlayer;

//@property (nonatomic, copy) NSString *url;
@end
