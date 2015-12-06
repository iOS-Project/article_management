//
//  LoginVC.m
//  Article Management
//
//  Created by Lun Sovathana on 12/3/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "LoginVC.h"
#import "ConnectionManager.h"
#import "User.h"
#import "UIView+Toast.h"

@interface LoginVC ()<ConnectionManagerDelegate>{
    ConnectionManager *cm;
    NSUserDefaults *login;
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // set padding for textField
    self.usernameTF.edgeInsets = UIEdgeInsetsMake(5, 20, 5, 10);
    self.passwordTF.edgeInsets = UIEdgeInsetsMake(5, 20, 5, 10);
    
    // set border for textField
    //self.usernameTF.layer.cornerRadius = self.usernameTF.frame.size.height/2;
    //self.passwordTF.layer.cornerRadius = self.passwordTF.frame.size.height/2;
    
    // set border for button
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    self.signUpButton.layer.cornerRadius = self.signUpButton.frame.size.height/2;
    
    // instantiate connection object
    cm = [[ConnectionManager alloc] init];
    // set delegate
    cm.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated{
    // check if user has been login so go to home screen directly
    login = [NSUserDefaults standardUserDefaults];
    NSString *user = [[login objectForKey:@"userLogin"] objectForKey:@"username"];
    
    if (user != nil){
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
}

-(void)responseData:(NSDictionary *)dataDictionary{
    
    if ([[dataDictionary objectForKey:@"MESSAGE"] isEqualToString:@
         "LOGIN SUCCESS"]) {
        // set session of logined user
        NSArray *arrUser = [dataDictionary objectForKey:@"RES_DATA"];
        
        [login setObject:arrUser forKey:@"userLogin"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loginIndicator stopAnimating];
            // change set login button text to default
            [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
            // enable login button
            self.loginButton.enabled = YES;
            // go to home
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        });
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loginIndicator stopAnimating];
            // change set login button text to default
            [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
            // enable login button
            self.loginButton.enabled = YES;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Failed!" message:@"Invalid Username or Password." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        });
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginAction:(id)sender {
    
    [self login];
    
}

-(void)login{
    [self.passwordTF resignFirstResponder];
    // start indicator
    [self.loginIndicator startAnimating];
    // set login button text to empty
    [self.loginButton setTitle:@"" forState:UIControlStateNormal];
    // disable login button
    self.loginButton.enabled = NO;
    
    // sent data to server
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:@[self.usernameTF.text, self.passwordTF.text] forKeys:@[@"username", @"password"]];
    [cm requestData:data withKey:@"/api/login"];
}

- (IBAction)signUpAction:(id)sender {
    
    [self performSegueWithIdentifier:@"gotoSignUp" sender:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)usernameDidEndOnExit:(id)sender {
    [self.passwordTF becomeFirstResponder];
}
- (IBAction)passwordDidEndOnExit:(id)sender {
    [self login];
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}
@end
