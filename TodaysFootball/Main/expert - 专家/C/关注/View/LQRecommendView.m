//
//  LQRecommendView.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/12/20.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQRecommendView.h"

@interface LQRecommendView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@interface __RecommendViewCell : UICollectionViewCell

@property (nonatomic, strong) LQAvatarView *imageView;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation LQRecommendView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *spaceView = [UIView newAutoLayoutView];
        spaceView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:spaceView];
        [spaceView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
        [spaceView autoSetDimension:ALDimensionHeight toSize:4];
        
        UIImageView *iconView = [UIImageView newAutoLayoutView];
        iconView.image = imageWithName(@"精选");
        [self addSubview:iconView];
        [iconView autoSetDimensionsToSize:CGSizeMake(26, 26)];
        [iconView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:17];
        [iconView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        
        UILabel *recommendLabel = [UILabel newAutoLayoutView];
        recommendLabel.text = @"推荐专家";
        recommendLabel.font = [UIFont lqsFontOfSize:28];
        recommendLabel.textColor = [UIColor flsMainColor];
        [self addSubview:recommendLabel];
        [recommendLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:iconView];
        [recommendLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconView withOffset:8];
        
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:line];
        [line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [line autoSetDimension:ALDimensionHeight toSize:.5];
        [line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:iconView withOffset:7];

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (UIDeviceScreenWidth -17 -20) * 0.25;
        CGFloat itemHeight = 100;
        layout.itemSize = CGSizeMake((int)itemWidth, itemHeight);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[__RecommendViewCell class] forCellWithReuseIdentifier:@"__RecommendViewCellid"];
        [self addSubview:_collectionView];
        [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:17];
        [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [_collectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line];
        [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    return self;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(self.dataArray.count, 8);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __RecommendViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"__RecommendViewCellid" forIndexPath:indexPath];
    id dataObj = [self.dataArray safeObjectAtIndex:indexPath.row];
    if (self.title) {
        cell.titleLabel.text = self.title(dataObj);
    }
    
    if (self.setImage) {
        self.setImage(dataObj, cell.imageView);
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id dataObj = [self.dataArray safeObjectAtIndex:indexPath.row];
    self.selected?self.selected(dataObj):nil;
}


@end

@implementation __RecommendViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[LQAvatarView alloc] initWithLength:44 grade:(kLQAvatarViewGradeMini)];
        [self.contentView addSubview:_imageView];
        [_imageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15];
        [_imageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.textColor = UIColorFromRGB(0x404040);
        _titleLabel.font = [UIFont lqsFontOfSize:26];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
        [_titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_imageView withOffset:10];
    }
    return self;
}

@end

