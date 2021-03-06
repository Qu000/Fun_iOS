//
//  JHNewsCell.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/4.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuanziItem.h"

typedef void(^itemBlock)(NSInteger itemH);

@interface JHNewsCell : UICollectionViewCell

/** Duanzi*/
@property (nonatomic, strong) DuanziItem * model;

/** block*/
@property (nonatomic, copy) itemBlock block;
@end
