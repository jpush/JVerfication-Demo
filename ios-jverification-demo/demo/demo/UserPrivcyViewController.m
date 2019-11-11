//
//  UserPrivcyViewController.m
//  demo
//
//  Created by Allan on 2019/11/5.
//  Copyright © 2019 Test. All rights reserved.
//

#import "UserPrivcyViewController.h"
#import "JVERIFICATIONService.h"
#import <Masonry/Masonry.h>
@interface UserPrivcyViewController ()<UITextViewDelegate>

@end

@implementation UserPrivcyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
}

- (void)viewDidLayoutSubviews{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        [self showPrivacyWindow:NO];
    }else{
        [self showPrivacyWindow:YES];
    }
}
/*
用户协议弹窗
*/
- (void)showPrivacyWindow:(BOOL)isLandscape{
    
    CGFloat bgWidth = 300;
    CGFloat heigh = 408;
    CGFloat bgViewPaddingX = 36;
    CGFloat bgViewPaddingY = 150;
    if (isLandscape) {
        bgWidth = 480;
        heigh = 270;
        bgViewPaddingX = 110;
        bgViewPaddingY = 36;
    }
    UIView *bgView = [self.view viewWithTag:1000];
    if(bgView){
        [bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(bgViewPaddingY);
            make.bottom.equalTo(self.view.mas_bottom).offset(-bgViewPaddingY);
            make.left.equalTo(self.view).offset(bgViewPaddingX);
            make.right.equalTo(self.view).offset(-bgViewPaddingX);
        }];
        return;
    }
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 6;
    bgView.tag = 1000;
    UILabel *title = [[UILabel alloc] init];
    title.text = @"用户协议示例";
    title.font = [UIFont boldSystemFontOfSize:18];
    
    title.textColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1/1.0];
    [bgView addSubview:title];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.textColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1/1.0];
    textView.font = [UIFont systemFontOfSize:13];
    textView.delegate = self;
    textView.text =@"本处仅作为示例使用，非强制弹窗。开发者在使用时可根据自身实际情况选择是否需要在此页面增加用户协议弹窗，如选择增加此弹窗可填写自己应用的用户协议。\n\n极光认证优势：\n1.覆盖全面：整合三大运营商，覆盖99.9%以上的用户。\n2.提升体验：一键认证，用户无需输入手机号码、无需输入验证码，一键点击即可快速完成注册/登录流  程，提高转化率优化用户体验。\n3.安全保障：告别明文短信验证码，降低被劫持风险。\n4.稳定高效 ：依托亿级推送业务技术架构，高并发处理认证请求 。\n5.便捷接入：快速完成SDK集成，无需额外开发成本。\n如果您想要快速地测试、请参考文档https://docs.jiguang.cn/jverification/client/android_guide/在几分钟内跑通Demo。\n极光认证文档网站上，有相关的所有指南、API、教程等全部的文档。包括本文档的更新版本，都会及时地发布到该网站上。";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    [bgView addSubview:textView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(privacyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 1;
    [leftBtn setTitle:@"不同意" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    leftBtn.layer.masksToBounds = YES;
    leftBtn.layer.cornerRadius = 3;
    leftBtn.layer.borderWidth = 1;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    leftBtn.layer.borderColor = [UIColor colorWithRed:216/255.0 green:219/255.0 blue:230/255.0 alpha:1].CGColor;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"同意" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = 3;
    rightBtn.backgroundColor = [UIColor colorWithRed:75/255.0 green:109/255.0 blue:248/255.0 alpha:1/1.0];
    [rightBtn addTarget:self action:@selector(privacyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.tag = 2;
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:leftBtn];
    [bgView addSubview:rightBtn];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(bgViewPaddingY);
        make.bottom.equalTo(self.view.mas_bottom).offset(-bgViewPaddingY);
        make.left.equalTo(self.view).offset(bgViewPaddingX);
        make.right.equalTo(self.view).offset(-bgViewPaddingX);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_top).offset(15);
        make.centerX.equalTo(bgView);
    }];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(12);
        make.left.mas_equalTo(bgView.mas_left).offset(18);
        make.right.mas_equalTo(bgView).offset(-18);
        make.bottom.equalTo(bgView).offset(-53);
    }];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom).offset(10);
        make.right.mas_equalTo(bgView.mas_centerX).offset(-10);
        make.width.equalTo(@(110));
        make.bottom.mas_equalTo(bgView).offset(-10);
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textView.mas_bottom).offset(10);
        make.left.mas_equalTo(bgView.mas_centerX).offset(10);
        make.width.equalTo(@(110));
        make.bottom.mas_equalTo(bgView).offset(-10);
    }];

    NSLog(@"%@",bgView);
}
- (void)privacyBtnClick:(UIButton*)btn{
    if (btn.tag == 1) {
        [self dismissViewControllerAnimated:NO completion:^{
            [JVERIFICATIONService dismissLoginController];
        }];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

@end
