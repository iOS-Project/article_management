//
//  SignUpVC.h
//  Article Management
//
//  Created by Lun Sovathana on 12/3/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iTextField.h"

@interface SignUpVC : UIViewController
@property (weak, nonatomic) IBOutlet iTextField *usernameTF;
@property (weak, nonatomic) IBOutlet iTextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *signUpIndicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

// action
- (IBAction)usernameDidEndOnExit:(id)sender;
- (IBAction)passwordDidEndOnExit:(id)sender;
- (IBAction)signUpAction:(id)sender;
- (IBAction)backToLogin:(id)sender;

@end
