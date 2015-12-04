//
//  LSTToast.m
//  Article Management
//
//  Created by Lun Sovathana on 12/2/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "LSTToast.h"

@implementation LSTToast
-(void)showToast:(UIView*)target withMessage:(NSString *)message{
    NSLog(@"add");
    self.toastView = [[UIView alloc] initWithFrame:CGRectMake(target.frame.size.width/2, target.frame.size.height/2, target.frame.size.width-100.0, 50.0)];
    self.toastView.center = target.center;
    self.toastView.backgroundColor = [UIColor colorWithRed:(22/255.0) green:(144/255.0) blue:(67/255.0) alpha:1];
    self.toastView.layer.cornerRadius = target.frame.size.height/2;
    // activity indicator
    self.toastIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.toastIndicatorView.frame = CGRectMake(target.frame.origin.x+10.0, target.frame.size.height/2-15, 30.0, 30.0);
    self.toastIndicatorView.hidesWhenStopped = YES;
    
    [self.toastView addSubview:self.toastIndicatorView];
    
    // add message
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.toastIndicatorView.frame.origin.x + 40, self.toastIndicatorView.frame.origin.y-5, self.toastView.frame.size.width-(self.toastIndicatorView.frame.size.width + 10), 40.0)];
    label.textColor = [UIColor whiteColor];
    label.text = message;
    [self.toastView addSubview:label];
    
    //[self.view addSubview:view];
    [target addSubview:self.toastView];
    [self.toastIndicatorView startAnimating];
}
@end
