//
//  PhoneNumberLoginViewController.m
//  demo
//
//  Created by Allan on 2019/8/19.
//  Copyright © 2019 Test. All rights reserved.
//

#import "PhoneNumberLoginViewController.h"
#import "ResultViewController.h"
@interface PhoneNumberLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstarit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceConstrait;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation PhoneNumberLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}
- (IBAction)loginClick:(id)sender {
    ResultViewController *resultVC =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"result"];
    resultVC.resultType = LoginType;
    resultVC.number = self.numberText.text;
    resultVC.isSuccess = YES;
    [self.navigationController pushViewController:resultVC animated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLayoutSubviews{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        self.topConstrait.constant = 110;
        self.leftConstarit.constant = 28;
        self.rightConstrait.constant = 28;
        self.distanceConstrait.constant = 87;
        self.rightBtn.hidden = YES;
        self.loginBtn.hidden = NO;
    }else {
        self.topConstrait.constant = 60;
        CGFloat constant = (self.view.frame.size.width - 260)/2;
        if(isIphoneX){
            constant = (self.view.frame.size.width - 260-74)/2;
            self.topConstrait.constant = 90;
        }
        self.leftConstarit.constant = constant;
        self.rightConstrait.constant = constant;
        
        self.distanceConstrait.constant = 37;
        self.rightBtn.hidden = NO;
        self.loginBtn.hidden = YES;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
