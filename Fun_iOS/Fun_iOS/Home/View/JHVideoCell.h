//
//  JHVideoCell.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoItem.h"

typedef void(^itemBlock)(NSInteger itemH);

@interface JHVideoCell : UICollectionViewCell

/** VideoItem*/
@property (nonatomic, strong) VideoItem * model;

/** block*/
@property (nonatomic, copy) itemBlock block;
@end
