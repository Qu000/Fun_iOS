//
//  JHBrightnessAndVolumeView.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBrightnessAndVolumeView : UIView
@property (nonatomic, copy) void(^progressChangeHandle)(CGFloat);
@property (nonatomic, copy) void(^progressLandscapeEnd)(void);
@property (nonatomic, copy) void(^progressPortraitEnd)(void);
+ (instancetype)sharedBrightnessAndAudioView;
@end
