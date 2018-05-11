//
//  JHVideoTool.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHVideoTool.h"

@implementation JHVideoTool

static id _instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+(instancetype)sharedVideoTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}
@end
