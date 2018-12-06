//
//  LQPerSetupVC.m
//  TodaysFootball
//
//  Created by lequwuxian1 on 2017/11/28.
//  Copyright © 2017年 lequwuxian. All rights reserved.
//

#import "LQPerSetupVC.h"
#import "TZImagePickerController.h"
#import "SCNavigationController.h"
#import "LQModifyTextViewCtrl.h"
#import "LQSelectorViewCtrl.h"
#import "LQBindingPhoneViewCtrl.h"

#import "LQPerSetupTableViewCell.h"

#import "AuthorizationManager.h"
#import "LQLogoutReq.h"
#import "LQUpdateUserReq.h"
#import "LQUploadAvatar.h"

const NSString *keyForSetDataTag = @"keyForSetDataTag";
const NSString *keyForSetDataTitle = @"keyForSetDataTitle";
const NSString *keyForSetSelecter = @"keyForSetSelecter";
const NSString *keyForSetRightTitle = @"keyForSetRightTitle";

typedef NS_ENUM(NSInteger, kSettingTag) {
    kSettingTagAvatar,
    kSettingTagNickName,
    kSettingTagGender,
    kSettingTagPhone,
};

@interface LQPerSetupVC ()<UINavigationControllerDelegate, TZImagePickerControllerDelegate>


@end

@implementation LQPerSetupVC{
    id imageData;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    @weakify(self)
    [[RACObserve(userManager, currentUser) combineLatestWith:RACObserve(userManager, currentUser.mobile)] subscribeNext:^(id x) {
        [self_weak_ reloadData];
    }];
}

- (void)reloadData
{
    [dataList_ removeAllObjects];
    [dataList_ addObject:@{keyForSetDataTag:@(kSettingTagAvatar),
                           keyForSetDataTitle:@"头像",
                           keyForSetRightTitle:@"",
                           keyForSetSelecter:NSStringFromSelector(@selector(selectedAvatar))
                           }];
    [dataList_ addObject:@{keyForSetDataTag:@(kSettingTagNickName),
                           keyForSetDataTitle:@"昵称",
                           keyForSetRightTitle:stringNotNil(userManager.currentUser.nickName),
                           keyForSetSelecter:NSStringFromSelector(@selector(modifyNickName))
                           }];
    [dataList_ addObject:@{keyForSetDataTag:@(kSettingTagGender),
                           keyForSetDataTitle:@"性别",
                           keyForSetRightTitle:[userManager.currentUser.gender isEqualToString:@"2"]?@"女":@"男",
                           keyForSetSelecter:NSStringFromSelector(@selector(modifyGender))
                           }];
    [dataList_ addObject:@{keyForSetDataTag:@(kSettingTagPhone),
                           keyForSetDataTitle:@"常用手机",
                           keyForSetRightTitle:({
        NSString *phone = @"未绑定";
        if (userManager.currentUser.mobile.length>10) {
            phone = [NSString stringWithFormat:@"%@****%@", [userManager.currentUser.mobile substringWithRange:NSMakeRange(0, 3)], [userManager.currentUser.mobile substringWithRange:NSMakeRange(7, 4)]];
        }
        phone;
    }),
                           keyForSetSelecter:NSStringFromSelector(@selector(bindingPhoneNumber))
                           }];
    [self.tableView reloadData];
}


- (void)initUI
{
    self.title = @"个人设置";

    @weakify(self)
    LQButton *outBtn = [LQButton buttonWithFrame:CGRectZero type:UIButtonTypeCustom title:@"退出账号" titleColor:nil backgroundImage:nil andBlock:^(LQButton *button) {
        
        [self_weak_ alertViewShowWithTitle:nil
                                   message:@"是否退出登录"
                                    cancel:@"取消"
                                     other:@"确定"
                              clickedBlock:^(BOOL isTrue) {
                                  if (!isTrue) {return ;}
                                  [[[LQLogoutReq alloc] init] requestWithCompletion:nil error:nil];
                                  [userManager logOut];
                                  [self_weak_.navigationController popToRootViewControllerAnimated:YES];
                              }];
    }];
    outBtn.backgroundColor = [UIColor flsMainColor];
    [self.view addSubview:outBtn];
    [outBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [outBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [outBtn autoSetDimension:ALDimensionHeight toSize:50];
    if (is_iPhoneX) {
        [outBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLQSafeBottomHeight];
        UIView *iphoneX = [UIView newAutoLayoutView];
        iphoneX.backgroundColor = [UIColor flsMainColor];
        [self.view addSubview:iphoneX];
        [iphoneX autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero  excludingEdge:ALEdgeTop];
        [iphoneX autoSetDimension:ALDimensionHeight toSize:kLQSafeBottomHeight];
    }else{
        [outBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    }
    self.tableView.bounces = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataList_.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LQPerSetupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"percell"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"LQPerSetupTableViewCell" owner:self options:nil].lastObject;
    }

    NSDictionary *dic = dataList_[indexPath.row];
    cell.titleL.text = dic[keyForSetDataTitle];
    cell.messL.text = dic[keyForSetRightTitle];
    cell.headIma.hidden = [dic[keyForSetDataTag] integerValue] != kSettingTagAvatar;
    if([dic[keyForSetDataTag] integerValue]== kSettingTagAvatar){
        if (imageData) {
            cell.headIma.image = imageData;
        }else{
            [cell.headIma sd_setImageWithURL:[NSURL URLWithString:userManager.currentUser.avatar] placeholderImage:LQPlaceholderIcon];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = dataList_[indexPath.row];
    
    SEL selector = NSSelectorFromString(dic[keyForSetSelecter]);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        [self performSelector:selector];
#pragma clang diagnostic pop
    }
}

#pragma mark -
// 相册相关
- (void)_openCamera {
    [[AuthorizationManager shareManager] authorizationWithType:AuthorizationTypeCamera
                                                       success:^(AuthorizationType type, BOOL result) {
                                                           if (result) {
                                                               SCNavigationController* ctrl = [[SCNavigationController alloc] init];
                                                               ctrl.completeBlock = ^(id value) {
                                                                   NSDictionary *dic = value;
                                                                   [self imagePickerController:nil didUploadImage:dic[@"image"] res:dic[@"res"]];
                                                               };
                                                               if (IOS7_OR_EARLIER) {
                                                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                       [ctrl showCameraWithParentController:self];
                                                                   });
                                                               } else {
                                                                   [ctrl showCameraWithParentController:self];
                                                               }
                                                           }
                                                       } faile:nil];
}

- (void)_openAlbum {
    [[AuthorizationManager shareManager] authorizationWithType:AuthorizationTypePhoto
                                                       success:^(AuthorizationType type, BOOL result) {
                                                           if (result) {
                                                               TZImagePickerController *ctrl = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self];
                                                               ctrl.allowTakePicture = NO;
                                                               ctrl.allowPickingVideo = NO;
                                                               ctrl.allowPickingOriginalPhoto = NO;
                                                               ctrl.autoDismiss = NO;
                                                               ctrl.photoWidth = 800;
                                                               ctrl.photoPreviewMaxWidth = 800;
                                                               [self presentViewController:ctrl animated:YES completion:nil];
                                                           }
                                                       } faile:nil];
}

// TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didUploadImage:(UIImage *)image res:(id)res
{
    // 上传头像
    LQUploadAvatarRes *avatarRes = (LQUploadAvatarRes *)res;
    LQUpdateUserReq *req = [[LQUpdateUserReq alloc] init];
    req.avatar = avatarRes.avatarUrl;
    [self.view showActivityViewWithTitle:nil];
    [req requestWithCompletion:^(id response) {
        [self.view hiddenActivityWithTitle:@"提交成功"];
        LQNetResponse *userRes = (LQNetResponse *)response;
        LQUserInfo *userInfo = [[LQUserInfo alloc] initWith:userRes.data];
        userManager.currentUser = userInfo;
        [userManager saveCurrentUser];
        imageData = image;
    } error:^(id error) {
        [self.view hiddenActivityWithTitle:@"提交失败"];
    }];
}

- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  === selector
- (void)selectedAvatar
{
   UIAlertController *alert =  [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机"
                                              style:(UIAlertActionStyleDefault)
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self _openCamera];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选取"
                                              style:(UIAlertActionStyleDefault)
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self _openAlbum];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:(UIAlertActionStyleCancel)
                                            handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)modifyNickName
{
    LQModifyTextViewCtrl *modifyViewCtrl = [[LQModifyTextViewCtrl alloc] init];
    modifyViewCtrl.title = @"昵称设置";
    modifyViewCtrl.initialText = userManager.currentUser.nickName;
    @weakify(self)
    modifyViewCtrl.save = ^(NSString *text) {
        [self_weak_ modifyNickName:text gender:nil];
    };
    [self.navigationController pushViewController:modifyViewCtrl animated:YES];
}

- (void)modifyGender
{
    LQSelectorViewCtrl *selectorViewCtrl = [[LQSelectorViewCtrl alloc] init];
    selectorViewCtrl.selectedIndex = [userManager.currentUser.gender integerValue]-1;
    selectorViewCtrl.dataArray = @[@"男", @"女"];
    @weakify(self)
    selectorViewCtrl.selecting = ^(NSInteger index) {
        [self_weak_ modifyNickName:nil gender:@(index+1).stringValue];
    };
    [self.navigationController pushViewController:selectorViewCtrl animated:YES];
}

-(void)modifyNickName:(NSString *)nickName gender:(NSString *)gender
{
    LQUpdateUserReq *req = [[LQUpdateUserReq alloc] init];
    req.nickname = nickName;
    req.gender = gender;
    [req requestWithCompletion:^(id response) {
        LQNetResponse *userRes = (LQNetResponse *)response;
        LQUserInfo *userInfo = [[LQUserInfo alloc] initWith:userRes.data];
        userManager.currentUser = userInfo;
        [userManager saveCurrentUser];
    } error:^(id error) {
    }];
}

-(void)bindingPhoneNumber
{
    LQBindingPhoneViewCtrl *bindingVC = [[LQBindingPhoneViewCtrl alloc] init];
    [self.navigationController pushViewController:bindingVC animated:YES];
}

@end
