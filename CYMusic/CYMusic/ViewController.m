//
//  ViewController.m
//  CYMusic
//
//  Created by 蔡钰 on 2017/6/3.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "CYMusicModel.h"
#import "YYModel.h"
#import "CYMusicManager.h"
#import "CYLyricParser.h"

@interface ViewController ()
//模型数据数组
@property (nonatomic,strong) NSArray<CYMusicModel *> *modelArray;
//当前曲目索引
@property (nonatomic,assign) NSInteger currentIndex;
//定时器
@property (nonatomic,strong) CADisplayLink *linkTimer;

#pragma mark 公共视图
//背景视图
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
//当前时间
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
//进度条
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
//总时长
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
//上一曲
@property (weak, nonatomic) IBOutlet UIButton *preButton;
//播放按钮
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *playButton;
//下一曲
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

#pragma mark 竖屏视图
//歌手图片
@property (weak, nonatomic) IBOutlet UIImageView *singerImgView;
//专辑名
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
//歌词
@property (weak, nonatomic) IBOutlet UILabel *lyricsLabel;
//歌手名
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;

#pragma mark 横屏视图
//专辑图片
@property (weak, nonatomic) IBOutlet UIImageView *singerHoriImgView;
//横向歌词
@property (weak, nonatomic) IBOutlet UILabel *lyricsHorLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置界面
    [self setupUI];
    
    //加载数据
    [self loadMusicData];
    //根据数据 刷新UI
    [self setUpData];

    
}

#pragma mark - 设置数据
-(void)setUpData {
    
    //进度条
    self.progressSlider.value = 0;
    //歌手
    self.singerNameLabel.text = self.modelArray[self.currentIndex].singer;
    //背景图片
    self.backgroundImageView.image = [UIImage imageNamed:self.modelArray[self.currentIndex].image];
    //歌手图片
    self.singerImgView.image = [UIImage imageNamed:self.modelArray[self.currentIndex].image];
    //横屏歌手图片
    self.singerHoriImgView.image = [UIImage imageNamed:self.modelArray[self.currentIndex].image];
    //歌词
    [CYLyricParser parserLyricWithFileName:self.modelArray[self.currentIndex].lrc];
    
    //专辑
    self.albumLabel.text = self.modelArray[self.currentIndex].album;
    /*
     //歌词
     @property (nonatomic,copy) NSString *lrc;
     */
    //默认点击播放按钮
    [self playAction:self.playButton];
    
    //当前曲目索引
    [[CYMusicManager sharedManager] playMusicWithFileName: self.modelArray[self.currentIndex].mp3];
    //当前曲目时长
    self.totalTimeLabel.text = [self timeStrWithTimeInterval:[CYMusicManager sharedManager].duration];
}

#pragma mark 将NSTimeInterval转化为字符串
-(NSString *)timeStrWithTimeInterval:(NSTimeInterval)timeInterval {
    int minute = timeInterval / 60;
    int second = (int)timeInterval % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minute,second];
    
}

#pragma mark 定时器监听事件
-(void)updateTimeAction {
    //当前播放时长
    self.currentTimeLabel.text = [self timeStrWithTimeInterval:[CYMusicManager sharedManager].currentTime];
    
    //歌手图片旋转
    self.singerImgView.transform = CGAffineTransformRotate(self.singerImgView.transform, M_PI_4 / 60);
    
    //进度条
    self.progressSlider.value = [CYMusicManager sharedManager].currentTime / [CYMusicManager sharedManager].duration;
    
    if ([self.currentTimeLabel.text isEqualToString:self.totalTimeLabel.text]) {
        [self nextAction:self.nextButton];
    }
    
}

#pragma mark 滑动播放进度条,实现手动改变进度
- (IBAction)sliderAction:(UISlider *)sender {
    
    //NSLog(@"%f",sender.value/[CYMusicManager sharedManager].duration);
    
     [CYMusicManager sharedManager].currentTime = sender.value * [CYMusicManager sharedManager].duration;
}


//下一曲
- (IBAction)nextAction:(id)sender {
    //释放定时器
    [self.linkTimer invalidate];
    
    if (self.currentIndex == self.modelArray.count - 1) {
        self.currentIndex = 0;
    } else {
        self.currentIndex++;
    }
    
    self.playButton.selected = NO;
    
    [self setUpData];
    
}

//播放按钮的监听事件
- (IBAction)playAction:(UIButton *)sender {
    
    if (sender.selected) { //暂停
        [[CYMusicManager sharedManager] pause];
        sender.selected = NO;
        [self.linkTimer invalidate];
    } else { //播放
        sender.selected = YES;
        [[CYMusicManager sharedManager] playMusicWithFileName: self.modelArray[self.currentIndex].mp3];
        
        //定时器
        self.linkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimeAction)];
        [self.linkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
    }
}

//上一曲
- (IBAction)preItemAction:(id)sender {
    
    //释放定时器
    [self.linkTimer invalidate];
    
    if (self.currentIndex == 0) {
        self.currentIndex = self.modelArray.count - 1;
    } else {
        self.currentIndex--;
    }
    
    self.playButton.selected = NO;
    
    [self setUpData];
    
}

#pragma mark 加载音乐数据
- (void)loadMusicData {
    
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"mlist.plist" ofType:nil];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:pathStr];
    //字典数组转化为模型数组
    self.modelArray = [NSArray yy_modelArrayWithClass:[CYMusicModel class] json:dataArr];
    
    //NSLog(@"%@",self.modelArray);
}

#pragma mark 设置背景视图
- (void)setupUI {
    
    //给背景imageView添加模糊视图
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    [self.backgroundImageView addSubview:effectView];
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
