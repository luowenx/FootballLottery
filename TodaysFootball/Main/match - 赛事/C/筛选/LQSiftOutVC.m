//
//  LQSiftOutVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQSiftOutVC.h"
#import "LQFilterConfiger.h"
#import "LQFilterListReq.h"
#import "LQLeagueObj.h"

@class __OddsTextContainer;
@interface LQSiftOutVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIButton *allChooseButton;
@property (nonatomic, strong) UICollectionView *optionView;

//@property (nonatomic, strong) __OddsTextContainer * minOdds;
//@property (nonatomic, strong) __OddsTextContainer * maxOdds;

@end

@implementation LQSiftOutVC
{
    NSLayoutConstraint *heightCons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赛事筛选";

    [self initUI];
    [self getData];
}

-(void)getData
{
    LQFilterListReq *req = [[LQFilterListReq alloc] init];
    [req apendRelativeUrlWith:@(self.configer.page).stringValue];
    [req requestWithCompletion:^(id response) {
        LQNetResponse *res = (LQNetResponse *)response;
        self.configer.showOptions = [LQLeagueObj objArrayWithDics:res.data].mutableCopy;
        [self.configer check];
        [self updateView];
    } error:nil];
    
}

-(void)initUI
{
    UIView *tipsView = [UIView newAutoLayoutView];
    [self.view addSubview:tipsView];
    [tipsView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [tipsView autoSetDimension:ALDimensionHeight toSize:45];
    
    UIView *tipsLine = [UIView newAutoLayoutView];
    tipsLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [tipsView addSubview:tipsLine];
    [tipsLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [tipsLine autoSetDimension:ALDimensionHeight toSize:.5];
    
    UILabel *tipsLabel = [UILabel newAutoLayoutView];
    tipsLabel.font = [UIFont lqsFontOfSize:28];
    tipsLabel.textColor = UIColorFromRGB(0x404040);
    tipsLabel.text = @"赛事";
    [tipsView addSubview:tipsLabel];
    [tipsLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [tipsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
    
    _allChooseButton = [UIButton newAutoLayoutView];
    [_allChooseButton setTitle:@"全选" forState:(UIControlStateNormal)];
    [_allChooseButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_allChooseButton setTitle:@"取消全选" forState:(UIControlStateSelected)];
    [_allChooseButton setBackgroundColor:[UIColor flsMainColor]];
    [_allChooseButton roundedRectWith:2];
    _allChooseButton.titleLabel.font = [UIFont lqsFontOfSize:22];
    _allChooseButton.enabled = YES;
    [_allChooseButton addTarget:self action:@selector(selectedAll:) forControlEvents:(UIControlEventTouchUpInside)];
    [tipsView addSubview:_allChooseButton];
    [_allChooseButton autoSetDimensionsToSize:CGSizeMake(53, 25)];
    [_allChooseButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_allChooseButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(15, lqPointConvertInScreenWidth4EQScale(18), 15, lqPointConvertInScreenWidth4EQScale(18));
    layout.itemSize = CGSizeMake(lqPointConvertInScreenWidth4EQScale(74), 31);
    layout.minimumInteritemSpacing = 12;
    layout.minimumLineSpacing = (int)((UIDeviceScreenWidth - layout.itemSize.width * 4 - layout.sectionInset.left - layout.sectionInset.right)/3);
    _optionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _optionView.dataSource = self;
    _optionView.delegate = self;
    _optionView.backgroundColor = [UIColor whiteColor];
    _optionView.scrollEnabled = NO;
    [_optionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"optionCellid"];
    [self.view addSubview:_optionView];
    [_optionView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_optionView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_optionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipsView];
    heightCons =  [_optionView autoSetDimension:ALDimensionHeight toSize:0];
    
    /*
    UILabel *oddsLabel = [UILabel newAutoLayoutView];
    oddsLabel.text = @"赔率";
    oddsLabel.font = [UIFont lqsFontOfSize:28];
    oddsLabel.textColor = UIColorFromRGB(0x404040);
    [self.view addSubview:oddsLabel];
    [oddsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_optionView withOffset:15];
    [oddsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
    
    UIView *oddsLine = [UIView newAutoLayoutView];
    oddsLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.view addSubview:oddsLine];
    [oddsLine autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [oddsLine autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [oddsLine autoSetDimension:ALDimensionHeight toSize:.5];
    [oddsLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:oddsLabel withOffset:12];

    UIView *oddsLine_ = [UIView newAutoLayoutView];
    oddsLine_.backgroundColor = UIColorFromRGB(0xcccccc);
    [self.view addSubview:oddsLine_];
    [oddsLine_ autoSetDimensionsToSize:CGSizeMake(18, .5)];
    [oddsLine_ autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [oddsLine_ autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:oddsLine withOffset:30];
    
    _minOdds = [__OddsTextContainer newAutoLayoutView];
    _minOdds.textField.placeholder = @"最小赔率";
    [self.view addSubview:_minOdds];
    [_minOdds autoAlignAxis:ALAxisHorizontal toSameAxisOfView:oddsLine_];
    [_minOdds autoSetDimension:ALDimensionHeight toSize:31];
    [_minOdds autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
    [_minOdds autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:oddsLine_ withOffset:-6];
    
    _maxOdds = [__OddsTextContainer newAutoLayoutView];
    _maxOdds.textField.placeholder = @"最大赔率";
    [self.view addSubview:_maxOdds];
    [_maxOdds autoAlignAxis:ALAxisHorizontal toSameAxisOfView:oddsLine_];
    [_maxOdds autoSetDimension:ALDimensionHeight toSize:31];
    [_maxOdds autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
    [_maxOdds autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:oddsLine_ withOffset:6];
    
    UILabel *tipsLabel_ = [UILabel newAutoLayoutView];
    tipsLabel_.font = [UIFont lqsFontOfSize:18];
    tipsLabel_.textColor = UIColorFromRGB(0x404040);
    tipsLabel_.numberOfLines = 0;
    tipsLabel_.text = @"说明：\n您可以动手输入竞彩赔率区间，系统会为您筛选符合赔率的比赛";
    [self.view addSubview:tipsLabel_];
    [tipsLabel_ autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_minOdds withOffset:44];
    [tipsLabel_ autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
     [tipsLabel_ autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18];
     
     */
    
    UIButton *resetButton = [UIButton newAutoLayoutView];
    resetButton.titleLabel.font = [UIFont lqsFontOfSize:30];
    [resetButton setTitle:@"重置" forState:(UIControlStateNormal)];
    [resetButton setTitleColor:UIColorFromRGB(0x404040) forState:(UIControlStateNormal)];
    [resetButton setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
    [resetButton addTarget:self action:@selector(resetConfiger) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:resetButton];
    [resetButton autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [resetButton autoSetDimensionsToSize:CGSizeMake(UIDeviceScreenWidth *.5, 51)];
    if (is_iPhoneX) {
        UIView *spaceView = [UIView newAutoLayoutView];
        spaceView.backgroundColor = resetButton.backgroundColor;
        [self.view addSubview:spaceView];
        [spaceView autoSetDimensionsToSize:CGSizeMake(UIDeviceScreenWidth *.5, kLQSafeBottomHeight)];
        [spaceView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [spaceView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [resetButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:spaceView];
    }else{
        [resetButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    
    UIButton *confirmButton = [UIButton newAutoLayoutView];
    confirmButton.titleLabel.font = [UIFont lqsFontOfSize:30];
    [confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [confirmButton setBackgroundColor:[UIColor flsMainColor]];
    [confirmButton addTarget:self action:@selector(confirm) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:confirmButton];
    [confirmButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [confirmButton autoSetDimensionsToSize:CGSizeMake(UIDeviceScreenWidth *.5, 51)];
    if (is_iPhoneX) {
        UIView *spaceView = [UIView newAutoLayoutView];
        spaceView.backgroundColor = confirmButton.backgroundColor;
        [self.view addSubview:spaceView];
        [spaceView autoSetDimensionsToSize:CGSizeMake(UIDeviceScreenWidth *.5, kLQSafeBottomHeight)];
        [spaceView autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [spaceView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [confirmButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:spaceView];
    }else{
        [confirmButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    
    [self updateView];
}

-(void)updateView
{
    if (self.configer.showOptions.count <= 0) {
        heightCons.constant = 0;
    }else{
        UIEdgeInsets sectionInset = UIEdgeInsetsMake(15, 18, 15, 18);
        CGSize itemSize = CGSizeMake(lqPointConvertInScreenWidth4EQScale(74), 31);
        int minimumLineSpacing = (int)((UIDeviceScreenWidth - itemSize.width * 4 - sectionInset.left - sectionInset.right)/3);

        NSInteger line = self.configer.showOptions.count/4 + ((self.configer.showOptions.count%4 == 0)?0 : 1);
        heightCons.constant = line * itemSize.height + (line -1) * minimumLineSpacing + sectionInset.top + sectionInset.bottom;
    }
    
    if (self.configer.selectedOptions.count == self.configer.showOptions.count) {
        self.allChooseButton.selected = YES;
    }
    
    if (self.configer.showOptions.count == 0) {
        self.allChooseButton.selected = NO;
        [self.allChooseButton setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
        self.allChooseButton.enabled = NO;
    }else{
        self.allChooseButton.enabled = YES;
        [self.allChooseButton setBackgroundColor:[UIColor flsMainColor]];
    }
    
    [self.optionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.configer.showOptions.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"optionCellid" forIndexPath:indexPath];
    UILabel *titelLabel = [cell.contentView viewWithTag:999];
    if (!titelLabel) {
        cell.contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell.contentView roundedRectWith:3];
        titelLabel = [UILabel newAutoLayoutView];
        titelLabel.textColor = UIColorFromRGB(0x7f7f7f);
        titelLabel.textAlignment = NSTextAlignmentCenter;
        titelLabel.font = [UIFont lqsFontOfSize:22];
        titelLabel.tag = 999;
        [cell.contentView addSubview:titelLabel];
        [titelLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    }
    LQLeagueObj *league =[self.configer.showOptions safeObjectAtIndex:indexPath.row];
    titelLabel.text = league.leagueName;
    
    if ([self.configer isSelectedObject:league]) {
        titelLabel.textColor = [UIColor flsMainColor];
        [cell.contentView setCornerRadius:3 borderColor:[UIColor flsMainColor] borderWidth:1];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }else{
        titelLabel.textColor = UIColorFromRGB(0x7f7f7f);
        [cell.contentView setCornerRadius:3 borderColor:[UIColor flsMainColor] borderWidth:0];
        cell.contentView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LQLeagueObj *league =[self.configer.showOptions safeObjectAtIndex:indexPath.row];

    [self.configer selectedObject:league];

    if (self.configer.selectedOptions.count == self.configer.showOptions.count) {
        self.allChooseButton.selected = YES;
    }else{
        self.allChooseButton.selected = NO;
    }
    
    [collectionView reloadData];
}

#pragma mark ===
-(void) selectedAll:(UIButton *)sender
{
    if (sender.isSelected) {
        self.configer.selectedOptions = nil;
    }else{
        self.configer.selectedOptions = self.configer.showOptions;
    }
    sender.selected = !sender.isSelected;
    [self.optionView reloadData];
}

- (void)confirm
{
    if (self.confirmFilter) {
        self.confirmFilter(self.configer);
    }
    [self onBack];
}

-(void)resetConfiger
{
    self.allChooseButton.selected = NO;
    self.configer.selectedOptions = nil;
    [self.optionView reloadData];
}


@end

@interface __OddsTextContainer : UIView

@property (nonatomic, strong) UITextField * textField;

@end
@implementation __OddsTextContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self roundedRectWith:3];
        
        _textField = [UITextField newAutoLayoutView];
        _textField.font = [UIFont lqsFontOfSize:22];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_textField];
        [_textField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_textField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [_textField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
        [_textField autoSetDimension:ALDimensionHeight toSize:27];
    }
    return self;
}

@end
