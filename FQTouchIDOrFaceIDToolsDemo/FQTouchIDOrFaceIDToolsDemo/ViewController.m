//
//  ViewController.m
//  FQTouchIDOrFaceIDToolsDemo
//
//  Created by owen on 2019/10/17.
//  Copyright © 2019 owen. All rights reserved.
//

#import "ViewController.h"
#import "FQTouchIDOrFaceIDManage/FQTouchIDOrFaceIDManage.h"
#import "NewViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"生物验证";
    
    UIButton *touchIDButton = [[UIButton alloc] init];
    [touchIDButton addTarget:self action:@selector(touchVerification) forControlEvents:UIControlEventTouchDown];
    touchIDButton.frame = CGRectMake((self.view.frame.size.width / 2) - 30, (self.view.frame.size.height / 2) - 30, 60, 60);
    [self.view addSubview:touchIDButton];
    
    //判断是否支持生物验证(此处根据不同类型来显示不同的图标)
    FQVerifySupportType type = [[FQTouchIDOrFaceIDManage verifyInstance] fq_canSupportVerifyType];
    switch (type) {
        case FQVerifySupportTypeFaceID:
            NSLog(@"支持FaceID");
            [touchIDButton setBackgroundImage:[UIImage imageNamed:@"faceID"] forState:UIControlStateNormal];
            break;
        case FQVerifySupportTypeTouchID:
            NSLog(@"支持TouchID");
            [touchIDButton setBackgroundImage:[UIImage imageNamed:@"touchID"] forState:UIControlStateNormal];
            break;
        case FQVerifySupportTypeNone:
            NSLog(@"不支持生物验证");
            [touchIDButton setBackgroundImage:[UIImage imageNamed:@"touchID"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
}

/// 验证 生物识别
- (void)touchVerification {
    
    [[FQTouchIDOrFaceIDManage verifyInstance] fq_showVerifyTouchIDDesp:@"TouchID支持验证" FaceIDDescribe:@"FaceID支持验证" verifyResult:^(FQVerifyResultState state, NSError * _Nonnull error) {
        if (state == FQVerifyResultStateNotSupport) {
            //  不支持TouchID/FaceID
            NSLog(@"不支持生物验证");
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"当前设备不支持生物验证" message:@"请输入密码来验证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertview.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alertview show];
            
        } else if (state == FQVerifyResultStateSuccess) {
            //  TouchID/FaceID验证成功
            NSLog(@"验证成功");
            NewViewController *homeVc = [[NewViewController alloc] init];
            [self.navigationController pushViewController:homeVc animated:YES];
            
        } else if (state == FQVerifyResultStateInputPassword) {
            //用户选择手动输入密码
            NSLog(@"需要输入密码");
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertview.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alertview show];
            
        } else if(state == FQVerifyResultStateTouchIDLockout){
            NSLog(@"多次生物验证失败 需要输入密码");
            
        }
        
    }];
    
}

@end
