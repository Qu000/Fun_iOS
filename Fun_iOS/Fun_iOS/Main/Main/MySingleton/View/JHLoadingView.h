//
//  JHLoadingView.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHLoadingView : UIView
@property (nonatomic, assign) BOOL hidesWhenStopped;
- (void)startAnimating;
- (void)stopAnimating;
@end
