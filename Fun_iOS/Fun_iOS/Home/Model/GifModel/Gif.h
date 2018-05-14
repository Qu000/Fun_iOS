//
//  Gif.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/14.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gif : NSObject

///height
@property (nonatomic, assign) NSInteger height;

///width
@property (nonatomic, assign) NSInteger width;

///时长 秒
@property (nonatomic, assign) BOOL isGif;

///封面Icon
@property (nonatomic, strong) NSString * thumbUrl;

///gif
@property (nonatomic, strong) NSString * url;

@end
