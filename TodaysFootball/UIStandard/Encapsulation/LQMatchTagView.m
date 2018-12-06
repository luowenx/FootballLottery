//
//  LQMatchTagView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/26.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchTagView.h"

@interface LQMatchTagView()

@property (nonatomic, strong) NSMutableArray * tagLabels;

@end

@implementation LQMatchTagView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _tagLabels = [NSMutableArray array];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _tagLabels = [NSMutableArray array];
    }
    return self;
}

-(void)reloadTags:(nullable NSArray *)tags setTitle:(NSString * (^)(id obj))setTitle
{
    for (UIView *tagView in self.tagLabels) {
        [tagView removeFromSuperview];
    }
    [self.tagLabels removeAllObjects];
    
    if (tags.count <=0) {
        return;
    }
    
    __block UILabel *previous = nil;
    [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [UILabel newAutoLayoutView];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor flsMainColor];
        label.font = [UIFont lqsFontOfSize:22];
        [label setCornerRadius:9 borderColor:[UIColor flsMainColor] borderWidth:1];
        
        if (setTitle) {
            label.text = setTitle(obj);
        }
        
        [self addSubview:label];
        [label autoSetDimensionsToSize:CGSizeMake(53, 18)];
        
        if (!previous) {
            [label autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        }else{
            [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:previous withOffset:12];
        }
        [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        previous = label;
        [self.tagLabels addObject:label];
    }];

}

@end
