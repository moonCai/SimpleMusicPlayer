//
//  CYMusicManager.m
//  CYMusic
//
//  Created by 蔡钰 on 2017/6/7.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import "CYMusicManager.h"
#import <AVFoundation/AVFoundation.h>

@interface CYMusicManager ()
//播放器
@property (nonatomic,strong) AVAudioPlayer *player;
//当前曲目名
@property (nonatomic,copy) NSString *fileName;

@end

@implementation CYMusicManager

+(instancetype)sharedManager {
    static CYMusicManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

//开始播放/继续播放
-(void)playMusicWithFileName:(NSString *)fileName {
    
    if (![self.fileName isEqualToString:fileName]) {
        //获取文件路径
        NSString *pathStr = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        //初始化播放器
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathStr] error:nil];
        //记录当前曲目名
        self.fileName = fileName;
        
        //开始缓存
        [self.player prepareToPlay];
    }
    
    
    // 延时一秒,给缓冲预留更充足的时间
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //开始播放
        [self.player play];
    });
    

}

//暂停
-(void)pause {
    
    [self.player pause];

}
//当前播放时长
-(NSTimeInterval)currentTime {
    
    return self.player.currentTime;

}

-(void)setCurrentTime:(NSTimeInterval)currentTime {
     //拖动播放进度条时改变当前播放时长
    self.player.currentTime = currentTime;

}
//曲目总时长
-(NSTimeInterval)duration {
   
    return self.player.duration;

}

@end
