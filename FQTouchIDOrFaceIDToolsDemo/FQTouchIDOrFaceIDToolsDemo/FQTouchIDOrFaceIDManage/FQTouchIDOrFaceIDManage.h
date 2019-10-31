//
//  FQTouchIDOrFaceIDManage.h
//  FQTouchIDOrFaceIDToolsDemo
//
//  Created by owen on 2019/10/31.
//  Copyright © 2019 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, FQVerifySupportType) {
    /// 验证方式支持 TouchID验证
    FQVerifySupportTypeTouchID,
    /// 验证方式支持 FaceID验证
    FQVerifySupportTypeFaceID,
    /// 验证方式  不支持验证
    FQVerifySupportTypeNone
};

typedef NS_ENUM(NSUInteger, FQVerifyResultState) {
    /// 当前设备不支持生物验证
    FQVerifyResultStateNotSupport = 1,
    
    /// 生物验证 验证成功
    FQVerifyResultStateSuccess,
    
    /// 生物验证 验证失败
    FQVerifyResultStateFail,
    
    /// 生物验证 被用户手动取消
    FQVerifyResultStateUserCancel,
    
    /// 用户不使用生物验证,选择手动输入密码
    FQVerifyResultStateInputPassword,
    
    /// 生物验证 被系统取消 (如遇到来电,锁屏,按了Home键等)
    FQVerifyResultStateSystemCancel,
    
    /// 生物验证 无法启动,因为用户没有设置密码
    FQVerifyResultStatePasswordNotSet,
    
    /// 生物验证 无法启动,因为用户没有设置生物验证
    FQVerifyResultStateTouchIDNotSet,

    /// 生物验证 无效
    FQVerifyResultStateTouchIDNotAvailable,

    /// 生物验证 被锁定(连续多次验证生物验证失败,系统需要用户手动输入密码)
    FQVerifyResultStateTouchIDLockout,

    /// 当前软件被挂起并取消了授权 (如App进入了后台等)
    FQVerifyResultStateAppCancel,

    /// 当前软件被挂起并取消了授权 (LAContext对象无效)
    FQVerifyResultStateInvalidContext,

    /// 系统版本不支持生物验证 (必须高于iOS 8.0才能使用)
    FQVerifyResultStateVersionNotSupport,
    
};

/// 回调结果
typedef void (^FQResultStateBlock)(FQVerifyResultState state,NSError *error);

@interface FQTouchIDOrFaceIDManage : LAContext

+ (instancetype)verifyInstance;

- (void)fq_showVerifyTouchIDDesp:(NSString *)desp verifyResult:(FQResultStateBlock)block;

- (void)fq_showVerifyTouchIDDesp:(NSString *)desp FaceIDDescribe:(NSString *)faceDesc verifyResult:(FQResultStateBlock)block;

// 判断设备支持哪种认证方式 FQVerifySupportType TouchID & FaceID
- (FQVerifySupportType)fq_canSupportVerifyType;

@end

NS_ASSUME_NONNULL_END
