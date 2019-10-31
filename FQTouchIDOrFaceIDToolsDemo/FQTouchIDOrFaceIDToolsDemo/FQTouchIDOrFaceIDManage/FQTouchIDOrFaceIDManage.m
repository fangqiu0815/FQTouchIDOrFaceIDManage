//
//  FQTouchIDOrFaceIDManage.m
//  FQTouchIDOrFaceIDToolsDemo
//
//  Created by owen on 2019/10/31.
//  Copyright © 2019 owen. All rights reserved.
//

#import "FQTouchIDOrFaceIDManage.h"


@implementation FQTouchIDOrFaceIDManage

+ (instancetype)verifyInstance
{
    static FQTouchIDOrFaceIDManage *manage = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[FQTouchIDOrFaceIDManage alloc] init];
    });
    
    return manage;
}



- (void)fq_showVerifyTouchIDDesp:(NSString *)desp FaceIDDescribe:(NSString *)faceDesc verifyResult:(FQResultStateBlock)block
{
    FQVerifySupportType supperType = [self fq_canSupportVerifyType];
    
    NSString *descStr;
    if (supperType == FQVerifySupportTypeTouchID && desp.length == 0) {
        descStr = @"TouchID支持验证";
    }else{
        descStr = desp;
    }
    if (supperType == FQVerifySupportTypeFaceID && faceDesc.length == 0) {
        descStr = @"FaceID支持验证";
    }else{
        descStr = faceDesc;
    }
    
    NSError *error = nil;
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"系统版本不支持TouchID (必须高于iOS 8.0才能使用)");
            block(FQVerifyResultStateVersionNotSupport, error);
        });
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"输入密码验证";
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:descStr reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"TouchID 验证成功");
                    block(FQVerifyResultStateSuccess,error);
                });
            }else if(error){
                
                switch (error.code) {
                    case LAErrorAuthenticationFailed:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 验证失败");
                            block(FQVerifyResultStateFail,error);
                        });
                        break;
                    }
                    case LAErrorUserCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被用户手动取消");
                            block(FQVerifyResultStateUserCancel,error);
                        });
                    }
                        break;
                    case LAErrorUserFallback:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"用户不使用TouchID,选择手动输入密码");
                            block(FQVerifyResultStateInputPassword,error);
                        });
                    }
                        break;
                    case LAErrorSystemCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                            block(FQVerifyResultStateSystemCancel,error);
                        });
                    }
                        break;
                    case LAErrorPasscodeNotSet:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置密码");
                            block(FQVerifyResultStatePasswordNotSet,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无法启动,因为用户没有设置TouchID");
                            block(FQVerifyResultStateTouchIDNotSet,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 无效");
                            block(FQVerifyResultStateTouchIDNotAvailable,error);
                        });
                    }
                        break;
                    case LAErrorTouchIDLockout:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)");
                            block(FQVerifyResultStateTouchIDLockout,error);
                        });
                    }
                        break;
                    case LAErrorAppCancel:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                            block(FQVerifyResultStateAppCancel,error);
                        });
                    }
                        break;
                    case LAErrorInvalidContext:{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                            block(FQVerifyResultStateInvalidContext,error);
                        });
                    }
                        break;
                    default:
                        break;
                }
            }
        }];
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前设备不支持TouchID");
            block(FQVerifyResultStateNotSupport,error);
        });
        
    }
}


- (void)fq_showVerifyTouchIDDesp:(NSString *)desp verifyResult:(FQResultStateBlock)block
{
    [self fq_showVerifyTouchIDDesp:desp FaceIDDescribe:nil verifyResult:block];
}

// 判断设备支持哪种认证方式 FQVerifySupportType TouchID & FaceID
- (FQVerifySupportType)fq_canSupportVerifyType
{
    LAContext *context = [[LAContext alloc] init];
    NSError *error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        if (error != nil) {
            return FQVerifySupportTypeNone;
        }
        if (@available(iOS 11.0, *)) {
            return context.biometryType == LABiometryTypeFaceID ? FQVerifySupportTypeFaceID : FQVerifySupportTypeTouchID;
        }
    }
    return FQVerifySupportTypeNone;
    
}

@end
