//
//  ViewController.m
//  demo
//
//  Created by ayy on 2018/10/21.
//  Copyright © 2018年 Test. All rights reserved.
//

#import "ViewController.h"
#import "RegisterOrLoginViewController.h"
#import "JVERIFICATIONService.h"
#import "ResultViewController.h"
#import "UIView+Toast.h"
#import "PhoneNumberLoginViewController.h"
#import <ImageIO/ImageIO.h>
#import <SDWebImage/SDWebImage.h>
#import "UIView+Tools.h"
#import "JSHAREService.h"
#import "UserPrivcyViewController.h"
@interface ViewController (){
    JVUIConfig * _config;
}

@property (strong, nonatomic) UIButton *phoneBtn;
@property (strong, nonatomic) UIButton *rightPhoneBtn;
@property (strong, nonatomic) UIView *bgBtsView;
@property (weak, nonatomic) UIView *customView;

@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;
@property (strong, nonatomic)  UIImageView *loadingImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTop;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

@property (weak, nonatomic) IBOutlet UIButton *windowBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberBtn;
@property (weak, nonatomic) IBOutlet UIButton *supportlandscape;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneBtn = phoneBtn;
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [phoneBtn setTitle:@"手机号登录" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor colorWithRed:143/255.0 green:143/255.0 blue:151/255.0 alpha:1/1.0] forState:UIControlStateNormal];

    self.rightPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightPhoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightPhoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.rightPhoneBtn setTitle:@"手机号登录" forState:UIControlStateNormal];
    [self.rightPhoneBtn setTitleColor:[UIColor colorWithRed:143/255.0 green:143/255.0 blue:151/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    [JVERIFICATIONService preLogin:3 completion:^(NSDictionary *result) {
        
    }];
    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource:@"首页动画@3x" withExtension:@"gif"];
    [self.animationImageView sd_setImageWithURL:gifImageUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"jv_showViewEdge"];

}

//- (BOOL)prefersStatusBarHidden{
//    return NO;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)deviceOrientationDidChange:(id)sender{
    [self caculateCustomUIFrame];
}

- (void)viewDidLayoutSubviews{
    if (self.view.frame.size.height > 677 && [UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
        CGFloat scale = (double)448/640.0;
        CGFloat height = 255;
        CGFloat width = height*scale;
        self.animationViewWidth.constant = width;
        self.animationViewHeight.constant = height;
        self.bottomViewHeight.constant = 290;
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.logoTop.constant = 50;
        [self.bgImageView setImage:[UIImage imageNamed:@"index_bg"]];
        self.animationImageView.hidden = NO;
        self.bottomBgView.backgroundColor = [UIColor whiteColor];
        self.bottomBgView.cornerRadius = 16;
        self.bottomBgView.borderColor = [UIColor whiteColor];

        [self.windowBtn setBackgroundImage:[UIImage imageNamed:@"btn_42px"] forState:UIControlStateNormal];
        [self.fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"btn_42px"] forState:UIControlStateNormal];
        [self.phoneNumberBtn setBackgroundImage:[UIImage imageNamed:@"btn_描边"] forState:UIControlStateNormal];
        [self.windowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.fullScreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.phoneNumberBtn setTitleColor:[UIColor colorWithRed:58/255.0 green:81/255.0 blue:255/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        self.supportlandscape.hidden = NO;
    }else{
        self.logoTop.constant = 38;
        self.animationImageView.hidden = YES;
        [self.bgImageView setImage:[UIImage imageNamed:@"01首页00"]];
        self.bottomBgView.backgroundColor = [UIColor clearColor];
        self.bottomBgView.cornerRadius = 0;
        self.bottomBgView.borderColor = [UIColor clearColor];

        [self.windowBtn setBackgroundImage:[UIImage imageNamed:@"btn_白色"] forState:UIControlStateNormal];
        [self.fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"btn_白色"] forState:UIControlStateNormal];
        [self.phoneNumberBtn setBackgroundImage:[UIImage imageNamed:@"btn_白色描边"] forState:UIControlStateNormal];

        [self.windowBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:46/255.0 blue:229/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [self.fullScreenBtn setTitleColor:[UIColor colorWithRed:23/255.0 green:46/255.0 blue:229/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [self.phoneNumberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.supportlandscape.hidden = YES;
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self caculateCustomUIFrame];
}

//一键登录
- (IBAction)loginBtnClicked:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 1){//全屏
        [self customUI];
    }else if(btn.tag == 2){//弹窗
        [self customWindow];
    }
    [UIView loadingAnimation];
    
    NSLog(@"orientation:%ld",(long)[UIDevice currentDevice].orientation);

    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(removLoading) userInfo:nil repeats:NO];
    
    [JVERIFICATIONService getAuthorizationWithController:self hide:NO completion:^(NSDictionary *result) {
        self.loadingImageView.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"一键登录 result:%@", result.description);
            NSString *token = result[@"loginToken"];
            NSInteger code = [result[@"code"] integerValue];
            if (token) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self verifyLoginToken:token];
                });
            }else if(code != 6002){
                [JVERIFICATIONService dismissLoginController];
                ResultViewController *resultVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"result"];
                resultVC.resultType = LoginType;
                resultVC.isSuccess = NO;
                
                resultVC.erroMsg = [NSString stringWithFormat:@"获取LoginToken失败code:%@,msg:%@",result[@"code"],result[@"content"]];
                [self.navigationController pushViewController:resultVC animated:YES];

//                [self showToast:[NSString stringWithFormat:@"极光认证Demo:获取Login Token失败,error: %@",result]];
            }
        });
    } actionBlock:^(NSInteger type, NSString *content) {
        if (type == 2 && btn.tag == 1) {
            UserPrivcyViewController *vc = [[UserPrivcyViewController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            UIViewController *topVC =  [self topViewController];
            topVC.modalPresentationStyle = UIModalPresentationCurrentContext;
            [topVC presentViewController:vc animated:NO completion:^{

            }];
        }
    }];
    
}
- (void)removLoading{
    [UIView removeLoadingAnimation];
}

- (void)showToast:(NSString *)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow hideToastActivity];
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageFont = [UIFont systemFontOfSize:13];
        style.messageAlignment = NSTextAlignmentCenter;
        CGPoint point = CGPointMake(self.view.center.x,  self.view.bounds.size.height - 100);
        [keyWindow makeToast:message duration:2 position:[NSValue valueWithCGPoint:point] style:style];
    });
}

-(void)hideToastActivity{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow hideToastActivity];
}

- (void)verifyLoginToken:(NSString *)loginToken{
    //这里功能仅做展示，如开发需要手机号登录功能，需要去极光官网申请
    ResultViewController *resultVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"result"];
    resultVC.resultType = LoginType;
    UIViewController *topVC = [self topViewController];
    resultVC.isSuccess = YES;
    [topVC.navigationController pushViewController:resultVC animated:YES];
}


//号码认证
- (IBAction)verfiyBtnClicked:(id)sender {
    RegisterOrLoginViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"registerOrLogin"];
    vc.type = verify;
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
}

- (void)customWindow{
    JVUIConfig *config = [[JVUIConfig alloc] init];
    config.navCustom = YES;
    config.autoLayout = YES;
    config.modalTransitionStyle =  UIModalTransitionStyleCrossDissolve;
    config.agreementNavReturnImage = [UIImage imageNamed:@"close"];

    //弹框
    config.showWindow = YES;

    config.windowBackgroundAlpha = 0.3;
    config.windowCornerRadius = 6;

    config.sloganTextColor = [UIColor colorWithRed:187/255.0 green:188/255.0 blue:197/255.0 alpha:1/1.0];
    config.privacyComponents = @[@"同意《",@"",@"",@"》并授权极光认证Demo获取本机号码"];
    CGFloat windowW = 320;
    CGFloat windowH = 250;
    JVLayoutConstraint *windowConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *windowConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    JVLayoutConstraint *windowConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowW];
    JVLayoutConstraint *windowConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowH];
    config.windowConstraints = @[windowConstraintY,windowConstraintH,windowConstraintX,windowConstraintW];
    
    JVLayoutConstraint *windowConstraintW1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:480];
    JVLayoutConstraint *windowConstraintH1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:250];

    
    config.windowHorizontalConstraints =@[windowConstraintY,windowConstraintH1,windowConstraintX,windowConstraintW1];
    
    //弹窗close按钮
    UIImage *window_close_nor_image = [UIImage imageNamed:@"close_icon"];
    UIImage *window_close_hig_image = [UIImage imageNamed:@"close_icon"];
    if (window_close_nor_image && window_close_hig_image) {
        config.windowCloseBtnImgs = @[window_close_nor_image, window_close_hig_image];
    }
    CGFloat windowCloseBtnWidth = 30;
    CGFloat windowCloseBtnHeight = 30;
    JVLayoutConstraint *windowCloseBtnConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-5];
    JVLayoutConstraint *windowCloseBtnConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:5];
    JVLayoutConstraint *windowCloseBtnConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowCloseBtnWidth];
    JVLayoutConstraint *windowCloseBtnConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowCloseBtnHeight];
    config.windowCloseBtnConstraints = @[windowCloseBtnConstraintX,windowCloseBtnConstraintY,windowCloseBtnConstraintW,windowCloseBtnConstraintH];
    
    
    //logo
    config.logoImg = [UIImage imageNamed:@"弹窗logo"];
    CGFloat logoWidth = 105;
    CGFloat logoHeight = 26;
    JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:40];
    JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
    JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
    config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
    
    JVLayoutConstraint *logoConstraintLeft = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:16];
    
    JVLayoutConstraint *logoConstraintTop = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:11];
    
    config.logoHorizontalConstraints = @[logoConstraintLeft,logoConstraintTop,logoConstraintW,logoConstraintH];
    
    
    //号码栏
    JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogo attribute:NSLayoutAttributeBottom multiplier:1 constant:14];

    JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:28];
    JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:200];

    JVLayoutConstraint *numberConstraintY1 = [JVLayoutConstraint constraintWithAttribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogo attribute:NSLayoutAttributeBottom multiplier:1 constant:39];

    config.numberConstraints = @[numberConstraintX,numberConstraintY,numberConstraintH,numberConstraintW];
    config.numberHorizontalConstraints = @[numberConstraintX,numberConstraintY1,numberConstraintH,numberConstraintW];

    //slogan展示
    JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumber attribute:NSLayoutAttributeBottom   multiplier:1 constant:4];
    JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:17];
    JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:200];

    config.sloganConstraints = @[sloganConstraintX,sloganConstraintY,sloganConstraintW,sloganConstraintH];
    
    //登录按钮
    UIImage *login_nor_image = [UIImage imageNamed:@"btn_38px"];
    UIImage *login_dis_image = [UIImage imageNamed:@"btn_38px_ull"];
    UIImage *login_hig_image = [UIImage imageNamed:@"btn_38px"];
    if (login_nor_image && login_dis_image && login_hig_image) {
        config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    }
    config.logBtnText = @"一键登录";
    CGFloat loginButtonWidth = 220;
    CGFloat loginButtonHeight = 38;
    JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
    JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    JVLayoutConstraint *loginConstraintY1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:13];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    config.logBtnHorizontalConstraints = @[loginConstraintX,loginConstraintY1,loginConstraintW,loginConstraintH];
    //勾选框
    config.checkViewHidden = YES;
    //隐私
    config.privacyState = YES;
    config.privacyTextFontSize = 10;
    config.privacyTextAlignment = NSTextAlignmentCenter;
    config.appPrivacyColor = @[[UIColor colorWithRed:187/255.0 green:188/255.0 blue:197/255.0 alpha:1/1.0],[UIColor colorWithRed:137/255.0 green:152/255.0 blue:255/255.0 alpha:1/1.0]];
    JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *privacyConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:180];
    JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-21];
    JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:32];
    JVLayoutConstraint *privacyConstraintY1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-23];
    JVLayoutConstraint *privacyConstraintH1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:14];
    JVLayoutConstraint *privacyConstraintW1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:400];
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintY,privacyConstraintH,privacyConstraintW];
    config.privacyHorizontalConstraints = @[privacyConstraintX,privacyConstraintY1,privacyConstraintH1,privacyConstraintW1];
    //loading
    JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
    
    [JVERIFICATIONService customUIWithConfig:config customViews:^(UIView *customAreaView) {
        
    }];
    
}

- (void)phoneBtnClick:(id)sender{
    UIViewController *vc =  [self topViewController];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PhoneNumberLoginViewController *phoneVC =  [story instantiateViewControllerWithIdentifier:@"PhoneNumberLoginViewController"];
    [vc.navigationController pushViewController:phoneVC animated:YES];
}
- (void)customUI{
    JVUIConfig *config = [[JVUIConfig alloc] init];
    config.navReturnImg = [UIImage imageNamed:@"back"];
    config.agreementNavReturnImage = [UIImage imageNamed:@"close"];
    config.autoLayout = YES;
    config.navText = @"";
    config.navDividingLineHidden = YES;
    config.prefersStatusBarHidden = NO;
    _config = config;
    _config.navControl = [[UIBarButtonItem alloc] initWithCustomView:self.rightPhoneBtn];
    config.privacyComponents = @[@"同意《",@"",@"",@"》并授权极光认证Demo获取本机号码"];

    config.navColor = [UIColor whiteColor];
    config.sloganTextColor = [UIColor colorWithRed:187/255.0 green:188/255.0 blue:197/255.0 alpha:1/1.0];
    //logo
    config.logoImg = [UIImage imageNamed:@"logo_icon"];
    CGFloat logoWidth = 76;
    CGFloat logoHeight = logoWidth;
    CGFloat windowW = self.view.frame.size.width;
    JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:76];
    JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
    JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
    config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
    
    //横屏
    JVLayoutConstraint *logoConstraintY1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:20];

    config.logoHorizontalConstraints = @[logoConstraintX,logoConstraintY1,logoConstraintH,logoConstraintW];
    
    
    //号码栏
    JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogo attribute:NSLayoutAttributeBottom multiplier:1 constant:16];
    JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];

    config.numberConstraints = @[numberConstraintX,numberConstraintY,numberConstraintW,numberConstraintH];
    
    //slogan展示
    JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumber attribute:NSLayoutAttributeBottom   multiplier:1 constant:8];
    JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
    
    config.sloganConstraints = @[sloganConstraintX,sloganConstraintY,sloganConstraintW,sloganConstraintH];
    
    
    //登录按钮
    UIImage *login_nor_image = [UIImage imageNamed:@"btn_42px"];
    UIImage *login_dis_image = [UIImage imageNamed:@"btn_42px_null"];
    UIImage *login_hig_image = [UIImage imageNamed:@"btn_42px"];
    if (login_nor_image && login_dis_image && login_hig_image) {
        config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
    }
    config.logBtnText = @"一键登录";
    CGFloat loginButtonWidth = 260;
    CGFloat loginButtonHeight = 42;
    JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:22];
    JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    
    //勾选框
    
    UIImage * uncheckedImg = [UIImage imageNamed:@"checkBox_unSelected"];
    UIImage * checkedImg = [UIImage imageNamed:@"checkBox_selected"];
    CGFloat checkViewWidth = 11;
    CGFloat checkViewHeight = 11;
    CGFloat spacing = (windowW - 300)/2;

    config.uncheckedImg = uncheckedImg;
    config.checkedImg = checkedImg;
    JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:spacing];
    JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
    
    JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
    JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
    config.checkViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
    //隐私
    config.privacyState = YES;
    config.privacyTextFontSize = 11;
    config.privacyTextAlignment = NSTextAlignmentCenter;
    config.appPrivacyColor = @[[UIColor colorWithRed:187/255.0 green:188/255.0 blue:197/255.0 alpha:1/1.0],[UIColor colorWithRed:137/255.0 green:152/255.0 blue:255/255.0 alpha:1/1.0]];
    
    JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *privacyConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:400];

    JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-25];
    JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:14];
    
    
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintW,privacyConstraintY,privacyConstraintH];
    
    JVLayoutConstraint *privacyConstraintY1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-16];

    config.privacyHorizontalConstraints = @[privacyConstraintX,privacyConstraintW,privacyConstraintH,privacyConstraintY1];
    
    //loading
    JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
    [JVERIFICATIONService customUIWithConfig:config customViews:^(UIView *customAreaView) {
        self.customView = customAreaView;
        UIView *btnsView = [self btnsView];
        self.bgBtsView = btnsView;
        [self caculateCustomUIFrame];
        [customAreaView addSubview:self.phoneBtn];
        [customAreaView addSubview:btnsView];
    }];
}

- (void)caculateCustomUIFrame{
    if (!self.customView) {
        return;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"customView:%@,orientation:%ld",self.customView,(long)[UIDevice currentDevice].orientation);
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        CGFloat x = (width - 78)/2;
        CGFloat y = height - 320;
        if(height > 736){
            y = height - 546;
        }else if(height == 736 ){
            y = height - 380;
        }
        CGFloat statBarItemHeight = 49+35;
        if (@available(iOS 11.0, *)) {
            statBarItemHeight  += self.view.safeAreaInsets.bottom;
        }
        self.phoneBtn.frame = CGRectMake(x, y,78 , 18);
        self.bgBtsView.frame = CGRectMake((width-300)/2, y+18+80, 300, 67);
        self.rightPhoneBtn.hidden = YES;
        self.phoneBtn.hidden = NO;

    }else{
        self.rightPhoneBtn.hidden = NO;
        self.phoneBtn.hidden = YES;
        self.phoneBtn.frame = CGRectMake(0, 0, 78, 18);
        self.bgBtsView.frame = CGRectMake((width-300)/2, height-67-65, 300, 67);
    }
}

- (UIView*)btnsView{
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 67)];
    NSArray *imgs = @[@"o_qq",@"o_wechat",@"o_weibo"];
    CGFloat width = 32 , height = 32;
    CGFloat padding = 21;
    CGFloat orgX = (300 - width *3 - padding*2)/2;
    for (int i = 0; i < imgs.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 10;
        [btn setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(orgX + i*width + i*padding, 0, width, height);
        [btn addTarget:self action:@selector(thirdPatyLogin:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
    }
    return btnView;
}

- (void)thirdPatyLogin:(UIButton*)sender{
//    [self showToast:@"功能暂未实现"];
    switch (sender.tag) {
        case 10: //qq
            {
                [self getUserInfoWithPlatform:JSHAREPlatformQQ];
            }
            break;
        case 11: //wechat
            {
                [self getUserInfoWithPlatform:JSHAREPlatformWechatSession];
            }
                break;
        case 12://weibo
            {
                [self getUserInfoWithPlatform:JSHAREPlatformSinaWeibo];
            }
                break;
        default:
            break;
    }
    
}
- (void)getUserInfoWithPlatform:(JSHAREPlatform)platfrom{
    [JSHAREService getSocialUserInfo:platfrom handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
        NSString *alertMessage;
        NSString *title;
        if (error) {
            title = @"失败";
            alertMessage = @"无法获取到用户信息";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *topVC = [self topViewController];
                [topVC presentViewController:alert animated:YES completion:nil];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                ResultViewController *resultVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"result"];
                UIViewController *topVC = [self topViewController];
                resultVC.resultType = LoginType;
                resultVC.isSuccess = YES;
                //此处为了演示需要才加这段代码，清除用户登录缓存，生产环境建议删除此行代码。
                [JSHAREService cancelAuthWithPlatform:platfrom];
                [topVC.navigationController pushViewController:resultVC animated:YES];
            });
        }
    }];
}

- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


@end
