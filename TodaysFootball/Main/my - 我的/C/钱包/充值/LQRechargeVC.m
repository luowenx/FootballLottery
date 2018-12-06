//
//  LQRechargeVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/27.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQRechargeVC.h"
#import "LQStaticWebViewCtrl.h"

#import "MoneyOptionCell.h"
#import "LQBeanView.h"

#import "LQGoodsListReq.h"

#import "AppUtils.h"
#import "LQPriceObj.h"
#import "LQOptionManager.h"
#import <LequPay/LequPay.h>
//#import "LequPay.h"

@interface LQRechargeVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel * balanceLabel;
@property (nonatomic, strong) UICollectionView *moneyOptionView;

@property (nonatomic, strong) NSArray * moneyOptionArray;
@property (nonatomic) NSInteger selectedIndex;

@end

@implementation LQRechargeVC{
    UIButton *payBtn;
}

-(instancetype)initWithCommitPop:(BOOL)pop
{
    self = [super init];
    if (self) {
        _needPop = pop;
        [self initRegiste];
    }
    return self;
}

-(instancetype)init
{
    return [self initWithCommitPop:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"充值";
    
    self.selectedIndex = -1;
    
    [self creatUI];
    [self getGoods];
}

- (void)initRegiste{

    [[LequSDKMgr getInstance] openRegist:@"5b5537c7e7798966e136fa22"
                                        :@"f4099f7eab976135ff4eb3fdd9eb381a"
                                        :self];
    [[LequSDKMgr getInstance] setStyleName:@"sdk_1"];
    [[LequSDKMgr getInstance] setStatusBarColorWithHexString:@"#ff0000" alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePayMessage:) name:LequPaytNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveErrorMessage:) name:LequErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveExitMessage:) name:LequExitNotification object:nil];
}

- (void)creatUI
{
    self.navigationController.navigationBar.hidden = NO;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UIView *userView = [UIView newAutoLayoutView];
    userView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:userView];
    [userView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [userView autoSetDimension:ALDimensionHeight toSize:51];

    UILabel *userLabel = [UILabel newAutoLayoutView];
    userLabel.textColor = UIColorFromRGB(0x404040);
    userLabel.font = [UIFont lqsFontOfSize:30];
    userLabel.text = @"当前用户";
    [userView addSubview:userLabel];
    [userLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [userLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    
    UILabel *nameLabel = [UILabel newAutoLayoutView];
    nameLabel.textColor = UIColorFromRGB(0x7a7a7a);
    nameLabel.font = [UIFont lqsFontOfSize:26];
    nameLabel.text = stringNotNil(userManager.currentUser.nickName);
    [userView addSubview:nameLabel];
    [nameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:userLabel];
    [nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userLabel withOffset:8];
    
    UILabel *balanceTipsLabel = [UILabel newAutoLayoutView];
    balanceTipsLabel.text = @"余额";
    balanceTipsLabel.font = [UIFont lqsFontOfSize:30];
    balanceTipsLabel.textColor = UIColorFromRGB(0x404040);
    [userView addSubview:balanceTipsLabel];
    [balanceTipsLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [balanceTipsLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:110];
    
    LQBeanView *beanView = [LQBeanView newAutoLayoutView];
    beanView.beanLabel.text = @"乐豆";
    [userView addSubview:beanView];
    [beanView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
    [beanView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:balanceTipsLabel withOffset:-2];
    
    self.balanceLabel = [UILabel newAutoLayoutView];
    self.balanceLabel.textColor = [UIColor flsMainColor];
    self.balanceLabel.font = [UIFont lqsFontOfSize:32 isBold:YES];
    self.balanceLabel.text = @(userManager.currentUser.colorbean).stringValue;
    [userView addSubview:self.balanceLabel];
    [self.balanceLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView: beanView withOffset: -3];
    [self.balanceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    UIView *tipsBgView = [UIView newAutoLayoutView];
    tipsBgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:tipsBgView];
    [tipsBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [tipsBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [tipsBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userView withOffset:17];
    [tipsBgView autoSetDimension:ALDimensionHeight toSize:40];
    
    UILabel *moneyLabel = [UILabel newAutoLayoutView];
    moneyLabel.textColor = UIColorFromRGB(0x404040);
    moneyLabel.font = [UIFont lqsFontOfSize:30];
    moneyLabel.text = @"充值金额";
    [tipsBgView addSubview:moneyLabel];
    [moneyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [moneyLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    UIView *tipsLine = [UIView newAutoLayoutView];
    tipsLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [tipsBgView addSubview:tipsLine];
    [tipsLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [tipsLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [tipsLine autoSetDimension:ALDimensionHeight toSize:.5];
    [tipsLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 30;
    layout.minimumInteritemSpacing = 18;
    layout.sectionInset = UIEdgeInsetsMake(14, 17, 20, 20);
    CGFloat itemWidth = (UIDeviceScreenWidth - layout.sectionInset.left -layout.sectionInset.right -layout.minimumInteritemSpacing *2)/3;
    layout.itemSize = CGSizeMake(floor(itemWidth), 50);

    _moneyOptionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _moneyOptionView.delegate = self;
    _moneyOptionView.dataSource = self;
    _moneyOptionView.scrollEnabled = NO;
    _moneyOptionView.backgroundColor = [UIColor whiteColor];
    [_moneyOptionView registerClass:[MoneyOptionCell class] forCellWithReuseIdentifier:@"MoneyOptionCellid"];
    [self.contentView addSubview:_moneyOptionView];
    [_moneyOptionView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_moneyOptionView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_moneyOptionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipsBgView withOffset:0];
    [_moneyOptionView autoSetDimension:ALDimensionHeight toSize:160];
    
    payBtn = [UIButton newAutoLayoutView];
    payBtn.enabled = NO;
    payBtn.backgroundColor = UIColorFromRGB(0xcccccc);
    payBtn.titleLabel.font = [UIFont lqsFontOfSize:36];
    [payBtn setTitle:@"支付" forState:(UIControlStateNormal)];
    [payBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.view addSubview:payBtn];
    [payBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [payBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [payBtn autoSetDimension:ALDimensionHeight toSize:50];
    if (is_iPhoneX) {
        [payBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLQSafeBottomHeight];
        UIView *iphoneX = [UIView newAutoLayoutView];
        [self.view addSubview:iphoneX];
        [iphoneX autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [iphoneX autoSetDimension:ALDimensionHeight toSize:kLQSafeBottomHeight];
        RAC(iphoneX, backgroundColor) = RACObserve(payBtn, backgroundColor);
    }else{
        [payBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    }
    
    UILabel *tipsLabel = [UILabel newAutoLayoutView];
    tipsLabel.text = @"温馨提示：";
    tipsLabel.font = [UIFont lqsFontOfSize:24];
    tipsLabel.textColor = UIColorFromRGB(0x525252);
    [self.contentView addSubview:tipsLabel];
    [tipsLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [tipsLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_moneyOptionView withOffset:20];
    
    UILabel *tipsLabel2 = [UILabel newAutoLayoutView];
    tipsLabel2.font = [UIFont lqsFontOfSize:22];
    tipsLabel2.numberOfLines = 0;
    tipsLabel2.textColor = UIColorFromRGB(0x7a7a7a);
    
    NSString *appName = [AppUtils bundleName];
    NSString *text =
    @"1、%@非购彩平台，乐豆一经充值成功，只可用于购买专家方案，不支持提现、购彩等操作；\n"
    @"2、乐豆充值和消费过程中遇到问题，请及时联系%@客服或提交反馈。\n"
    @"客服 QQ：252284919\n"
    @"客服邮箱：chenyaxian@lequwuxian.cn";
    
    text = [NSString stringWithFormat:text, appName, appName];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor flsMainColor2]
                            range:[text rangeOfString:@"非购彩平台"]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor flsMainColor2]
                            range:[text rangeOfString:@"App Store绑定支付宝"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    tipsLabel2.attributedText = attributeString;

    [self.contentView addSubview:tipsLabel2];
    [tipsLabel2 autoPinEdgeToSuperviewEdge:ALEdgeLeft   withInset:15];
    [tipsLabel2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    [tipsLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipsLabel withOffset:10];
    
    UIImageView * circleImageView = [UIImageView newAutoLayoutView];
    circleImageView.image = imageWithName(@"勾选框");
    [self.contentView addSubview:circleImageView];
    [circleImageView autoSetDimensionsToSize:CGSizeMake(13, 13)];
    [circleImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
    [circleImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tipsLabel2 withOffset:20];
    
    UIButton *agreeImage = [UIButton newAutoLayoutView];
    [agreeImage setImage:imageWithName(@"对勾") forState:UIControlStateSelected];
    [agreeImage setImage:nil forState:UIControlStateNormal];
    agreeImage.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.contentView addSubview:agreeImage];
    agreeImage.selected = YES;
    [agreeImage autoSetDimensionsToSize:CGSizeMake(29, 29)];  // (13, 13)
    [agreeImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:circleImageView];
    [agreeImage autoAlignAxis:ALAxisVertical toSameAxisOfView:circleImageView];
    [agreeImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:(kLQSPaddingSuper + kLQSafeBottomHeight + 50 /*购买按钮高度*/) relation:(NSLayoutRelationGreaterThanOrEqual)];
    
    UILabel *agreeLabel = [UILabel newAutoLayoutView];
    agreeLabel.font = [UIFont lqsFontOfSize:24];
    agreeLabel.text = @"支付即视为同意";
    agreeLabel.textColor = UIColorFromRGB(0x7a7a7a);
    [self.contentView addSubview:agreeLabel];
    [agreeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:agreeImage];
    [agreeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:agreeImage];
    
    UIButton *agreeBtn = [UIButton newAutoLayoutView];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"《%@用户充值协议》", [AppUtils bundleName]]];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor flsMainColor] range:strRange];
    [agreeBtn setAttributedTitle:str forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor flsMainColor] forState:(UIControlStateNormal)];
    agreeBtn.titleLabel.font = [UIFont lqsFontOfSize:24];
    
    [self.contentView addSubview:agreeBtn];
    [agreeBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:agreeLabel];
    [agreeBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:agreeImage];

    @weakify(self)
    [[agreeImage rac_signalForControlEvents:(UIControlEventTouchUpInside)]subscribeNext:^(id x) {
        // agreement
        UIButton *agreeBtn_ = (UIButton* )x;
        agreeBtn_.selected = !agreeBtn_.isSelected;
    }];
    
    [[agreeBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {
        LQStaticWebViewCtrl *webViewCtrl = [[LQStaticWebViewCtrl alloc] init];
        webViewCtrl.showWebTitle = YES;
        webViewCtrl.requestURL = [NSString stringWithFormat:@"%@/pay/agreement%@", LQWebURL, LQWebPramSuffix];
        [self_weak_.navigationController pushViewController:webViewCtrl animated:YES];
    }];
    
    [RACObserve(userManager, currentUser) subscribeNext:^(id x) {
        self_weak_.balanceLabel.text = @(userManager.currentUser.colorbean).stringValue;
    }];
    
    @weakify(agreeImage)
    [[payBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(id x) {

        if (!agreeImage_weak_.isSelected) {
            [LQJargon hiddenJargon:@"请先阅读充值协议"];
            return ;
        }
        
        // 支付
        LQPriceObj *goodsObj = [self_weak_.moneyOptionArray safeObjectAtIndex:self_weak_.selectedIndex];
        if (!goodsObj) {
            return ;
        }

        NSString *josnStr = @{@"tk": userManager.authorizeToken}.jsonString;
        if (@available(iOS 9.0, *)) {
            josnStr = [josnStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
        }else{
            josnStr =[josnStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        [[LequSDKMgr getInstance] openPay:@"1"
                                         :userManager.currentUser.nickName
                                         :@(goodsObj.goodsPrice)
                                         :josnStr
                                         :self];
    }];
}

-(void)getGoods
{
    LQGoodsListReq *req = [[LQGoodsListReq alloc] init];
    [self.view showActivityViewWithTitle:nil];
    [req requestWithCompletion:^(id response) {
        [self.view hiddenActivity];
        LQGoodsListRes *res = (LQGoodsListRes *)response;
        self.moneyOptionArray = [LQPriceObj objArrayWithDics:res.data];
        
        [self.moneyOptionView reloadData];

    } error:^(NSError *error) {
        [self.view hiddenActivityWithTitle:@"加载失败"];
    }];
}

-(void)__needPop
{
    if (_needPop) {
        [super onBack];
    }
}

#pragma mark  === UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moneyOptionArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoneyOptionCellid" forIndexPath:indexPath];
    LQPriceObj *goodsObj = [self.moneyOptionArray safeObjectAtIndex:indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@元", @(goodsObj.goodsPrice)];
    cell.numberLabel.text = stringNotNil(goodsObj.goodsName);
    cell.cornerView.hidden = !goodsObj.hot;
    if (indexPath.row == self.selectedIndex) {
        cell.contentView.backgroundColor = [UIColor flsMainColor];
        cell.priceLabel.textColor = [UIColor whiteColor];
        cell.numberLabel.textColor = [UIColor whiteColor];
        cell.contentView.layer.borderWidth = 0;
    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.priceLabel.textColor = UIColorFromRGB(0x7a7a7a);
        cell.numberLabel.textColor = [UIColor flsMainColor2];
        cell.contentView.layer.borderWidth = 0.5;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [collectionView reloadData];
    payBtn.enabled = YES;
    payBtn.backgroundColor = [UIColor flsMainColor];
}


#pragma mark  === 支付回调
- (void)receivePayMessage:(NSNotification*)notification
{
    [LQOptionManager checkOrder];
    NSString *message=[notification object];
    NSLog(@"订单ID：%@",message);
}

- (void)receiveErrorMessage:(NSNotification*)notification
{
    NSString *message = [notification object];
    NSLog(@"出错：%@",message);
}

- (void)receiveExitMessage:(NSNotification*)notification{
    NSString *message=[notification object];
    NSLog(@"退出：%@",message);
}



@end
