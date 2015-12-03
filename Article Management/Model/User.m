//
//  User.m
//  Article Management
//
//  Created by Lun Sovathana on 12/3/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "User.h"

@implementation User

-(id)initWithObject:(NSArray *)array{
    NSLog(@"%@", array);
    self = [super init];
    if (self != nil) {
        self.uID = [array valueForKey:@"id"];
        self.username = [array valueForKey:@"username"];
        self.password = [array valueForKey:@"password"];
        self.roles = [array valueForKey:@"roles"];
        self.enabled = [array valueForKey:@"enabled"];
        self.registerDate = [array valueForKey:@"registerDate"];
        self.photoUrl = [NSString stringWithFormat:@"http://hrdams.herokuapp.com/%@", [array valueForKey:@"photo"]];
    }
    return self;
}

@end
