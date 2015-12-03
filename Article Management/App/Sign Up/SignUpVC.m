//
//  SignUpVC.m
//  Article Management
//
//  Created by Lun Sovathana on 12/3/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "SignUpVC.h"
#import "ConnectionManager.h"

@interface SignUpVC ()<ConnectionManagerDelegate>{
    ConnectionManager *cm;
}

@end

@implementation SignUpVC

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

-(void)responseData:(NSDictionary *)dataDictionary{
    if ([[dataDictionary objectForKey:@"MESSAGE"] isEqualToString:@
         "USER HAS BEEN INSERTED"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Your account has been created." preferredStyle:UIAlertControllerStyleAlert];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.signUpIndicator stopAnimating];
            // change set login button text to default
            [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
            // clear text field
            [self.usernameTF setText:@""];
            [self.passwordTF setText:@""];
            [self presentViewController:alert animated:YES completion:^{
                [self performSelector:@selector(dismissViewController) withObject:self afterDelay:1.0];
            }];
            
        });

    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.signUpIndicator stopAnimating];
            // change set login button text to default
            [self.signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
            // enable login button
            self.signUpButton.enabled = YES;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign Up Failed!" message:@"Cannot Sign Up." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }
}

-(void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self signUp];
}

- (IBAction)signUpAction:(id)sender {
    [self signUp];
}

-(void)signUp{
    [self.passwordTF resignFirstResponder];
    // start indicator
    [self.signUpIndicator startAnimating];
    // set login button text to empty
    [self.signUpButton setTitle:@"" forState:UIControlStateNormal];
    // disable login button
    self.signUpButton.enabled = NO;
    
    // sent data to server
    NSDictionary *data = [[NSDictionary alloc] initWithObjects:@[self.usernameTF.text, self.passwordTF.text, @"User", @""] forKeys:@[@"username", @"password", @"roles", @"photo"]];
    [cm requestData:data withKey:@"/api/user/hrd_c001"];
}

- (IBAction)backToLogin:(id)sender {
    [self performSegueWithIdentifier:@"backToLogin" sender:nil];
}
@end
