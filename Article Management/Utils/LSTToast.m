//
//  LSTToast.m
//  Article Management
//
//  Created by Lun Sovathana on 12/2/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "LSTToast.h"

@interface LSTToast()<LSToastDelegate>{
    
    UIView* toastView;
    UIActivityIndicatorView* toastIndicatorView;
}

@end

@implementation LSTToast
-(void)showToast:(UIView*)target withMessage:(NSString *)message{
    //self.delegate = self;
    toastView = [[UIView alloc] initWithFrame:CGRectMake(target.frame.size.width/2, target.frame.size.height/2, target.frame.size.width-100.0, 50.0)];
    toastView.center = target.center;
    toastView.backgroundColor = [UIColor colorWithRed:(22/255.0) green:(144/255.0) blue:(67/255.0) alpha:1];
    toastView.layer.cornerRadius = target.frame.size.height/2;
    // activity indicator
    toastIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    toastIndicatorView.frame = CGRectMake(target.frame.origin.x+10.0, target.frame.size.height/2-15, 30.0, 30.0);
    toastIndicatorView.hidesWhenStopped = YES;
    
    [toastView addSubview:toastIndicatorView];
    
    // add message
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(toastIndicatorView.frame.origin.x + 40, toastIndicatorView.frame.origin.y-5, toastView.frame.size.width-(toastIndicatorView.frame.size.width + 10), 40.0)];
    label.textColor = [UIColor whiteColor];
    label.text = message;
    [toastView addSubview:label];
    
    //[self.view addSubview:view];
    [target addSubview:toastView];
    [toastIndicatorView startAnimating];
}
@end
