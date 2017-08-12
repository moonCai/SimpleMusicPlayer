//
//  NSDateFormatter+shared.m
//  CYMusic
//
//  Created by 蔡钰 on 2017/8/13.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import "NSDateFormatter+shared.h"

@implementation NSDateFormatter (shared)

+ (instancetype)sharedDateFormatter {
    static NSDateFormatter * instancetype;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instancetype = [[NSDateFormatter alloc] init];
    });
    return instancetype;
}

@end
