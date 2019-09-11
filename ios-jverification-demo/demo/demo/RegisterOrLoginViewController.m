//
//  RegisterOrLoginViewController.m
//  demo
//
//  Created by ayy on 2018/10/25.
//  Copyright © 2018年 Test. All rights reserved.
//

#import "RegisterOrLoginViewController.h"
#import "ResultViewController.h"
#import "UIView+Toast.h"
#import "JVERIFICATIONService.h"
#import "ResultViewController.h"
#import "UIView+Tools.h"

@interface RegisterOrLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginTitleButton;

@property (weak, nonatomic) IBOutlet UITextField *loginNumberTF;

@property (nonatomic, strong)NSString *token;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstrait;

@end

@implementation RegisterOrLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenAllView];
    //先获取token
    [UIView loadingAnimation];
    [JVERIFICATIONService getToken:^(NSDictionary *result) {
        NSLog(@"getToken result:%@", result);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            self.token = result[@"token"];
            [self removLoading];
            if ([self.token isKindOfClass:[NSString class]] && self.token.length > 0) {
                //获取token 成功
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageFont = [UIFont systemFontOfSize:13];
                style.messageAlignment = NSTextAlignmentCenter;
                CGPoint point = CGPointMake(self.view.center.x,  self.view.bounds.size.height - 140);
                [self.view makeToast:@"极光认证Demo:获取Token成功，可以继续使用极光认证" duration:3 position:[NSValue valueWithCGPoint:point] style:style];
            }else {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageFont = [UIFont systemFontOfSize:13];
                style.messageAlignment = NSTextAlignmentCenter;
                CGPoint point = CGPointMake(self.view.center.x,  self.view.bounds.size.height - 100);
                NSString * message= [NSString stringWithFormat:@"极光认证Demo:获取Token失败，请返回重试,error: %@",result];
                [self.view makeToast:message duration:3 position:[NSValue valueWithCGPoint:point] style:style];
            }
        });
    }];
}

- (void)removLoading{
    [UIView removeLoadingAnimation];
}

- (void)viewDidLayoutSubviews{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.logoTopConstrait.constant = 110;
        self.leftConstrait.constant = 28;
        self.rightConstrait.constant = 28;
    }else {
        CGFloat constant = (self.view.frame.size.width - 260)/2;
        if(isIphoneX){
            constant = (self.view.frame.size.width - 260-74)/2;
        }
        self.logoTopConstrait.constant = 50;
        self.leftConstrait.constant = constant;
        self.rightConstrait.constant = constant;
    }
}

//返回
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击验证
- (IBAction)loginBtnClick:(id)sender {
    if([self.loginNumberTF.text isEqualToString:@""]) {
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageFont = [UIFont systemFontOfSize:13];
        style.messageAlignment = NSTextAlignmentCenter;
        CGPoint point = CGPointMake(self.view.center.x,  self.view.bounds.size.height - 150);
        [self.view makeToast:@"极光认证Demo:输入号码不能为空" duration:3 position:[NSValue valueWithCGPoint:point] style:style];
        return;
    }
    //验证
    [self sendVerifyNumberRequest:self.loginNumberTF.text];
}

- (void)showToast:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view hideToastActivity];
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageFont = [UIFont systemFontOfSize:13];
        style.messageAlignment = NSTextAlignmentCenter;
        CGPoint point = CGPointMake(self.view.center.x,  self.view.bounds.size.height - 100);
        [self.view makeToast:message duration:2 position:[NSValue valueWithCGPoint:point] style:style];
    });
}

- (void)sendVerifyNumberRequest:(NSString *)phoneNumer{
    //这里功能仅做展示，如开发需要认证手机号功能，需要去极光官网申请
    if(!self.token){
        [self showToast:@"极光认证Demo:获取认证Token失败，请返回重试"];
        return;
    }
    ResultViewController *resultVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"result"];
    resultVC.resultType = VerifyType;
    resultVC.number = phoneNumer;
    resultVC.isSuccess = YES;
    [self.navigationController pushViewController:resultVC animated:YES];
}

//MARK: - private func

- (void)hiddenAllView {
    self.tipLabel.hidden = NO;
}
//- (BOOL)prefersStatusBarHidden{
//    return NO;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.loginNumberTF) {
        self.loginNumberTF.placeholder = @"";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self checkShowTitleLabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self checkShowTitleLabel];
}

- (void)checkShowTitleLabel {
    if (self.loginNumberTF.text.length) {
        self.loginNumberTF.placeholder = @"";
    }
}
@end
