//
//  JHGifCell.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/14.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifItem.h"

typedef void(^itemBlock)(NSInteger itemH);

@interface JHGifCell : UICollectionViewCell

/** VideoItem*/
@property (nonatomic, strong) GifItem * model;

/** block*/
@property (nonatomic, copy) itemBlock block;

@end
