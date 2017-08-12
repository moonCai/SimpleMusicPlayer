//
//  CYLyricParser.h
//  CYMusic
//
//  Created by 蔡钰 on 2017/8/12.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLyricModel.h"

@interface CYLyricParser : NSObject

+ (NSArray <CYLyricModel *>*)parserLyricWithFileName:(NSString *)fileName;

@end
