//
//  ResultViewController.m
//  demo
//
//  Created by ayy on 2018/10/25.
//  Copyright © 2018年 Test. All rights reserved.
//

#import "ResultViewController.h"
#import "JVERIFICATIONService.h"
#import "MyNavigationController.h"
@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstrait;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    if (self.resultType == VerifyType) {
        //设置label文字,设置高度约束
        self.resultLabel.text = self.isSuccess ? @"认证一致!":@"认证失败";
        self.alertLabel.text = self.isSuccess ? @"该界面仅做展示":@"可用短信验证码补充";
        self.tipsImageView.image = self.isSuccess? [UIImage imageNamed:@"提示_成功"]:[UIImage imageNamed:@"提示_失败"];
        self.alertView.hidden = self.isSuccess;
        if (self.erroMsg) {
            self.msgLabel.text = self.erroMsg;
        }
        
    }else if(self.resultType == LoginType){
        self.resultLabel.text = self.isSuccess ? @"登录成功!":@"登录失败";
        self.alertLabel.text = self.isSuccess ? @"该界面仅做展示":@"可用短信验证码补充";
        self.tipsImageView.image = self.isSuccess? [UIImage imageNamed:@"提示_成功"]:[UIImage imageNamed:@"提示_失败"];
        self.alertView.hidden = self.isSuccess;
        if (self.erroMsg) {
            self.msgLabel.text = self.erroMsg;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [super viewWillAppear:animated];
}

- (IBAction)backClick:(id)sender {
    [self backToHomeBtnClick:sender];
}


- (IBAction)backToHomeBtnClick:(id)sender {
    if (![self.navigationController isKindOfClass:[MyNavigationController class]]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [JVERIFICATIONService dismissLoginController];
        }];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLayoutSubviews{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.logoTopConstrait.constant = 121;
    }else {
        self.logoTopConstrait.constant = 60;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
