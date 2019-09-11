//
//  NSLayoutConstraint+Tools.m
//  demo
//
//  Created by ayy on 2018/10/22.
//  Copyright © 2018年 Test. All rights reserved.
//

#define  C_WIDTH(WIDTH) WIDTH * [UIScreen mainScreen].bounds.size.width/360.0
#define  C_HEIGHT(HEIGHT) HEIGHT * [UIScreen mainScreen].bounds.size.height/640.0

#import "NSLayoutConstraint+Tools.h"

@implementation NSLayoutConstraint (Tools)
-(void)setWidthScreen:(BOOL)widthScreen{
    if (widthScreen) {
        self.constant = C_WIDTH(self.constant);
    }else{
        self.constant = self.constant;
    }
}

-(BOOL)widthScreen{
    return self.widthScreen;
}

-(void)setHeightScreen:(BOOL)heightScreen{
    if (heightScreen) {
        self.constant = C_HEIGHT(self.constant);
    }else{
        self.constant = self.constant;
    }
}

-(BOOL)heightScreen{
    return self.heightScreen;
}

@end
