//
//  LoginVC.h
//  Article Management
//
//  Created by Lun Sovathana on 12/3/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iTextField.h"

@interface LoginVC : UIViewController
@property (weak, nonatomic) IBOutlet iTextField *usernameTF;

- (IBAction)usernameDidEndOnExit:(id)sender;


@property (weak, nonatomic) IBOutlet iTextField *passwordTF;
- (IBAction)passwordDidEndOnExit:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
- (IBAction)signUpAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;

- (IBAction)dismissKeyboard:(id)sender;


@end
