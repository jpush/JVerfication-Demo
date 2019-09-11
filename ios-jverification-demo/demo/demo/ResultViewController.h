//
//  ResultViewController.h
//  demo
//
//  Created by ayy on 2018/10/25.
//  Copyright © 2018年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    LoginType,
    VerifyType,
    PayType,
} VerifyResultType;

@interface ResultViewController : UIViewController
@property (nonatomic, assign)VerifyResultType resultType;

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *erroMsg;

@property (nonatomic, assign) BOOL isSuccess;

@end

