//
//  AddArticle.m
//  Article Management
//
//  Created by Lun Sovathana on 12/1/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "AddArticle.h"
#import "ConnectionManager.h"

@interface AddArticle()<ConnectionManagerDelegate>{
    ConnectionManager *cm;
}

@end

@implementation AddArticle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    cm = [[ConnectionManager alloc] init];
    cm.delegate = self;
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAction:(id)sender {
    
    NSString* title = self.titleTF.text;
    NSString* desc = self.descriptionTV.text;
    
    // check if empty
    if (![self checkStringIsEmpty:title withFieldName:@"Title"]) {
        return;
    }
    
    if (![self checkStringIsEmpty:desc withFieldName:@"Description"]) {
        return;
    }
    
    // create dictionary to hold data
    NSDictionary *article;
    
    // confirm user before save
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure want to save this article?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"SAVE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       // add text to dictionary
        NSLog(@"Save");
    }];
    
    [alert addAction:save];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(BOOL)checkStringIsEmpty:(NSString*)string withFieldName:(NSString*)fieldName{
    
    NSString *message = [NSString stringWithFormat:@"%@ cannot empty.", fieldName];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    if ([string isEqualToString:@""]) {
        [self presentViewController:alert animated:YES completion:nil];
        //return false;
    }else{
        return true;
    }
    
    return false;
}

-(void)responseData:(NSDictionary *)dataDictionary{
    
}

@end
