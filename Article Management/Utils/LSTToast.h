//
//  LSTToast.h
//  Article Management
//
//  Created by Lun Sovathana on 12/2/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LSTToast : NSObject

@property(strong, nonatomic)UIView* toastView;
@property(strong, nonatomic)UIActivityIndicatorView* toastIndicatorView;

-(void)showToast:(UIView*)target withMessage:(NSString*)message;
@end
