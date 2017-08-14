//
//  UIColorLabel.m
//  CYMusic
//
//  Created by 蔡钰 on 2017/8/13.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import "UIColorLabel.h"

@implementation UIColorLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //设置填充色
    [[UIColor colorWithRed:45/255.0 green:185/255.0 blue:105/255.0 alpha:1.0] setFill];
    //设置填充区域
    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * self.progress, rect.size.height);
    //渲染,在填充区域使用混个模式进行填充
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
    
}

-(void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


@end
