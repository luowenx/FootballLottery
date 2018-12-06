//
//  LQSetupVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "AppUtils.h"
#import "LQSetupVC.h"
#import "LQPerSetupVC.h"
#import "LQLoginMainViewCtrl.h"
#import "LQContactViewCtrl.h"
#import "LQAboutViewCtrl.h"
#import "LQStaticWebViewCtrl.h"

@interface LQSetupVC ()<UINavigationControllerDelegate>

@end

@implementation LQSetupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = @"设置";
    [self initUI];
}


- (void)initUI
{
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIView *line = [UIView newAutoLayoutView];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell addSubview:line];
        [line autoSetDimension:ALDimensionHeight toSize:0.5];
        [line autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
        [line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.textLabel];
        line.hidden = !(indexPath.row == 1);
        
        UIImageView *imageView = [UIImageView newAutoLayoutView];
        imageView.image = imageWithName(@"更多");
        [cell addSubview:imageView];
        [imageView autoSetDimensionsToSize:CGSizeMake(5, 10)];
        [imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:17];
    }
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = @"个人设置";
            break;
        }
        case 1:{
            cell.textLabel.text = [NSString stringWithFormat:@"版本信息  v%@", [AppUtils bundleShortVersion]];
            break;
        }
        case 2:{
            if (indexPath.row == 0) {
                cell.textLabel.text = @"联系我们";
            }else{
                cell.textLabel.text = @"关于";
            }
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (!userManager.isLogin) {
                [self gotoLogin];return;
            }
            LQPerSetupVC *vc = [[LQPerSetupVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.app.com/"]];
            
            break;
        }
        case 2:{
            if (indexPath.row == 0) {
                LQStaticWebViewCtrl *contactVC = [[LQStaticWebViewCtrl alloc] init];
                contactVC.title = @"联系我们";
                contactVC.requestURL = [NSString stringWithFormat:@"%@/userCenter/contactUs%@", LQWebURL, LQWebPramSuffix];
                [self.navigationController pushViewController:contactVC animated:YES];
            }else{
                LQStaticWebViewCtrl *aboutVC = [[LQStaticWebViewCtrl alloc] init];
                aboutVC.title = @"关于";
                aboutVC.requestURL = [NSString stringWithFormat:@"%@/userCenter/aboutUs%@", LQWebURL, LQWebPramSuffix];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

-(void)gotoLogin
{
    LQLoginMainViewCtrl *logViewCtrl = [[LQLoginMainViewCtrl alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logViewCtrl];
    [self presentViewController:nav animated:YES completion:^{}];
}

@end
