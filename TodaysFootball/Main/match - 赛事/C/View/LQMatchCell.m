//
//  LQMatchCell.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/21.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQMatchCell.h"
#import "LQMatchShowView.h"
#import "LQAppConfiger.h"

@implementation LQMatchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = UIColorFromRGB(0xa2a2a2);
        [self.contentView addSubview:line];
        [line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
        [line autoSetDimensionsToSize:CGSizeMake(.5, 11)];
        
        _timeLabel = [UILabel newAutoLayoutView];
        _timeLabel.font = [UIFont lqsFontOfSize:24];
        _timeLabel.textColor = UIColorFromRGB(0x7a7a7a);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timeLabel];
//        [_timeLabel autoSetDimension:ALDimensionWidth toSize:58];
        [_timeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [_timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:line withOffset:-10];
        [_timeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:line];
        
        _leagueLabel = [UILabel newAutoLayoutView];
        _leagueLabel.textColor = UIColorFromRGB(0x7a7a7a);
        _leagueLabel.font = [UIFont lqsFontOfSize:24];
        [self.contentView addSubview:_leagueLabel];
        [_leagueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:line];
        [_leagueLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:line withOffset:10];
        
        _statusLabel = [UILabel newAutoLayoutView];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.font = [UIFont lqsFontOfSize:22];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [_statusLabel roundedRectWith:3];
        [self.contentView addSubview:_statusLabel];
        [_statusLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [_statusLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:line];
        
        _matchShowView = [LQMatchShowView newAutoLayoutView];
        [self.contentView addSubview:_matchShowView];
        [_matchShowView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:38];
        [_matchShowView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_matchShowView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        
        _recordLabel = [UILabel newAutoLayoutView];
        _recordLabel.textColor = UIColorFromRGB(0xa2a2a2);
        _recordLabel.font = [UIFont lqsFontOfSize:20];
        [self.contentView addSubview:_recordLabel];
        [_recordLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [_recordLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:14];
        
        _arrowView = [UIImageView newAutoLayoutView];
        _arrowView.image = imageWithName(@"more");
        [self.contentView addSubview:_arrowView];
        [_arrowView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_recordLabel];
        [_arrowView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [_arrowView autoSetDimensionsToSize:CGSizeMake(5, 10)];
        
        _planCountLabel = [UILabel newAutoLayoutView];
        _planCountLabel.textColor = [UIColor flsMainColor3];
        _planCountLabel.font = [UIFont lqsFontOfSize:22];
        [self.contentView addSubview:_planCountLabel];
        [_planCountLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_arrowView];
        [_planCountLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_arrowView withOffset:-2];
        
        {
            UIView *line = [UIView newAutoLayoutView];
            line.backgroundColor =UIColorFromRGB(0xcccccc);
            [self.contentView addSubview:line];
            [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
            [line autoSetDimension:ALDimensionHeight toSize:.5];
        }
        
    }
    return self;
}

+ (CGFloat)selfHeight
{
    return  [LQAppConfiger shareInstance].appStatus ? 105 : 80;
}

- (void)cheackStatus
{
    BOOL hidden = ! [LQAppConfiger shareInstance].appStatus;
    
    _planCountLabel.hidden = hidden;
    _arrowView.hidden = hidden;
    _recordLabel.hidden = hidden;
}

@end
