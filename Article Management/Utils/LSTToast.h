//
//  LSTToast.h
//  Article Management
//
//  Created by Lun Sovathana on 12/2/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LSToastDelegate;

@protocol LSToastDelegate <NSObject>

@end

@interface LSTToast : UIView<NSObject>

@property(strong, nonatomic)id<LSToastDelegate>delegate;

-(void)showToast:(UIView*)target withMessage:(NSString*)message;

@end
