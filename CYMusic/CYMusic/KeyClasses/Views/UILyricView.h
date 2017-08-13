//
//  UILyricView.h
//  CYMusic
//
//  Created by 蔡钰 on 2017/8/13.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLyricModel.h"

@class UILyricView;

@protocol UILyricViewDelegate <NSObject>

- (void)lyricView:(UILyricView *)lyricView andScrollProgress:(CGFloat )progress;

@end

@interface UILyricView : UIView

@property (nonatomic,weak) id<UILyricViewDelegate> delegate;
//当前播放歌曲歌词数据源
@property (nonatomic,strong) NSArray <CYLyricModel *> *lyricModels;
//当前播放歌词索引
@property (nonatomic,assign) NSInteger currentIndex;
//当前歌词播放进度
@property (nonatomic,assign) CGFloat lyricProgress;

@end
