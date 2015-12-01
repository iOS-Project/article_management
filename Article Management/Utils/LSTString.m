//
//  LSTString.m
//  Article Management
//
//  Created by Lun Sovathana on 12/1/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "LSTString.h"

@implementation LSTString

+(BOOL)isStringEmpty:(NSString *)string withAlertMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:ok];
    
    if ([message isEqualToString:@""]) {
        return true;
    }
    
    return false;
}

@end
