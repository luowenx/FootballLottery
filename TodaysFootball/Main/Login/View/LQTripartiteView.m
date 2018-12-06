//
//  LQTripartiteView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/11.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQTripartiteView.h"

@interface LQTripartiteView()

@property (nonatomic, strong) NSArray * channels;

@end

@implementation LQTripartiteView

-(instancetype)initWithFrame:(CGRect)frame channels:(NSArray*)channels
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self updataWithChannels:channels];
    }
    return self;
}

- (void)updataWithChannels:(NSArray*)channels
{
    if (_channels.count > 0) {
        for (int i = 100; i<_channels.count + 100; i++) {
            UIButton *scrapBtn = [self viewWithTag:i];
            [scrapBtn removeFromSuperview];
            scrapBtn = nil;
        }
    }
    
    CGFloat channelWidth = 77;
    CGFloat sp = (UIDeviceScreenWidth - channels.count * channelWidth)/(channels.count+1);
    
    __block UIButton *previous = nil;
    [channels enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIButton *channelBtn = [UIButton newAutoLayoutView];
        [channelBtn setBackgroundImage:imageWithName(obj[@"image"]) forState:(UIControlStateNormal)];
//        [channelBtn roundedRectWith:channelWidth * 0.5];
        [self addSubview:channelBtn];
        if (idx == 0) {
            [channelBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:sp];
        }else{
            [channelBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previous withOffset:sp];
        }
        channelBtn.tag = idx + 100;
        [channelBtn autoSetDimensionsToSize:CGSizeMake(channelWidth, channelWidth)];
        [channelBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [channelBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [channelBtn addTarget:self action:@selector(selectedChannel:) forControlEvents:(UIControlEventTouchUpInside)];
        
        previous = channelBtn;
    }];
    
    _channels = channels;
}

- (void)selectedChannel:(UIButton *)channelBtn
{
    if (self.selectedLogin) {
        self.selectedLogin(_channels[channelBtn.tag-100]);
    }
}

@end
