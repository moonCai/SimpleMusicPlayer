//
//  UILyricView.m
//  CYMusic
//
//  Created by 蔡钰 on 2017/8/13.
//  Copyright © 2017年 蔡钰. All rights reserved.
//

#import "UILyricView.h"
#import <Masonry.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kTopMargin self.center.y - labelHeight * 0.5

static CGFloat const labelHeight = 40.0;
@interface UILyricView () <UIScrollViewDelegate>
//竖向滚动scrollView
@property (nonatomic,strong) UIScrollView *verScrollView;
//横向滚动scrollView
@property (nonatomic,strong) UIScrollView *horScrollview;
//label数组
@property (nonatomic,strong) NSMutableArray<UILabel *> *labelArrM;

@end
@implementation UILyricView

//从xib加载
-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self prepareLyricView];
}

-(void)setLyricModels:(NSArray<CYLyricModel *> *)lyricModels {
    //切歌时清除上一首播放歌曲的歌词数据源
    [self.verScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_labelArrM removeAllObjects];

    _lyricModels = lyricModels;
    for (int i = 0; i < lyricModels.count; i++) {
        //获取歌词模型
        CYLyricModel *lyricModel = _lyricModels[i];
        UILabel *lyricLabel = [[UILabel alloc] init];
        [self.labelArrM addObject:lyricLabel];
        lyricLabel.textColor = [UIColor whiteColor];
        lyricLabel.text = lyricModel.lyricContent;
        [self.verScrollView addSubview:lyricLabel];
        [lyricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.mas_equalTo(labelHeight);
            make.top.mas_equalTo(i*labelHeight);
        }];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    //将上一个放大的label以正常字号显示
    UILabel *lastLabel = _labelArrM[_currentIndex];
    lastLabel.font = [UIFont systemFontOfSize:17];
    
    _currentIndex = currentIndex;
    //放大当前播放句的字体
    UILabel *currentLabel = _labelArrM[_currentIndex];
    currentLabel.font = [UIFont systemFontOfSize:25];
    //改变偏移量
    self.verScrollView.contentOffset = CGPointMake(0, -kTopMargin + currentIndex * labelHeight);

}

- (void)layoutSubviews {
    [super layoutSubviews];

    //    设置默认偏移量
     self.verScrollView.contentOffset = CGPointMake(0, -kTopMargin);
    //设置内边距
    self.verScrollView.contentInset = UIEdgeInsetsMake(kTopMargin, 0, kTopMargin, 0);
    //设置contentSize
    self.verScrollView.contentSize = CGSizeMake(0,  self.lyricModels.count *labelHeight);
}

- (void)prepareLyricView {
    //横向滚动的scrollView
    self.horScrollview = [[UIScrollView alloc] init];
    [self addSubview:self.horScrollview];
    [self.horScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
      //竖向滚动视图
    self.verScrollView = [[UIScrollView alloc] init];
    self.verScrollView.delegate = self;
    [self.horScrollview addSubview:self.verScrollView];
    [self.verScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.horScrollview);
        make.left.equalTo(self.horScrollview).offset(kScreenWidth);
        make.size.equalTo(self.horScrollview);
    }];

    self.horScrollview.bounces = NO;
    self.horScrollview.showsHorizontalScrollIndicator = NO;
    self.horScrollview.pagingEnabled = YES;
    
    //监听横向视图的滚动
    self.horScrollview.delegate = self;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //判断滚动的是否是横向视图
    if (scrollView == self.horScrollview) {
        CGFloat progress = scrollView.contentOffset.x / kScreenWidth;
        if ([self.delegate respondsToSelector:@selector(lyricView:andScrollProgress:)]) {
            [self.delegate lyricView:self andScrollProgress:progress];
        }
    }
    
}

- (NSMutableArray<UILabel *> *)labelArrM {
    if (_labelArrM == nil) {
        _labelArrM = [[NSMutableArray alloc] init];
    }
    return _labelArrM;
}

@end
