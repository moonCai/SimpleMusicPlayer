//
//  CYLyricParser.m
//  CYMusic
//
//  Created by 蔡钰 on 2017/8/12.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import "CYLyricParser.h"
#import "CYLyricModel.h"
#import "NSDateFormatter+shared.h"

@implementation CYLyricParser

+ (NSArray <CYLyricModel *>*)parserLyricWithFileName:(NSString *)fileName {
    //当前歌曲歌词的本地路径
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    NSString *lyricStr = [NSString stringWithContentsOfFile:pathStr encoding:NSUTF8StringEncoding error:nil];
    //分隔整首歌词
    NSArray *lyricArr = [lyricStr componentsSeparatedByString:@"\n"];
    //正则匹配时间字符串[**:**.**],遍历单句歌词组成的数组
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"\\[[0-9]{2}:[0-9]{2}.[0-9]{2}\\]" options:0 error:nil];
    
    //初始化临时歌词模型数组
    NSMutableArray *temArrM = [[NSMutableArray alloc] init];
    
    for(NSString *aLyric in lyricArr) {
      NSArray *resultArr = [expression matchesInString:aLyric options:0 range:NSMakeRange(0, aLyric.length)];
        //歌词内容
        NSTextCheckingResult *lastResult = resultArr.lastObject;
        NSString *aLyricStr =[aLyric substringFromIndex:(lastResult.range.location + lastResult.range.length)];
       
        for(NSTextCheckingResult *result in resultArr) {
            CYLyricModel *lyricModel = [[CYLyricModel alloc] init];
            //截取时间字符串
            NSString *timeStr = [aLyric substringWithRange:NSMakeRange(result.range.location, result.range.length)];
            NSTimeInterval timeInterval = [self transformStringToTimeIntervalWithTimeString:timeStr];
            //赋值模型
            lyricModel.initialTime = timeInterval;
            lyricModel.lyricContent = aLyricStr;
            
            [temArrM addObject:lyricModel];
        }
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"initialTime" ascending:true];
    NSArray *lyricSortedArr = [temArrM sortedArrayUsingDescriptors:@[descriptor]];
    
//    for(CYLyricModel *lyricModel in lyricSortedArr) {
//        NSLog(@"%f:%@",lyricModel.initialTime,lyricModel.lyricContent);
//    }
    
    return nil;
}

#pragma mark ---- 将时间字符串转换成时间间隔
+ (NSTimeInterval)transformStringToTimeIntervalWithTimeString:(NSString *)timeStr {
    //初始化时间格式对象
    NSDateFormatter *formatter = [NSDateFormatter sharedDateFormatter];
    formatter.dateFormat = @"[mm:ss.SS]";
    //转换日期格式对象
    NSDate *targetDate = [formatter dateFromString:timeStr];
    //初始化初始时间
    NSDate *initDate = [formatter dateFromString:@"[00:00.00"];
    
    return [targetDate timeIntervalSinceDate:initDate];
}

@end
