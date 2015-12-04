//
//  Article.m
//  Article Management
//
//  Created by Lun Sovathana on 11/30/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "Article.h"

@implementation Article

-(id)initWithObject:(NSArray *)array{
    self = [super init];
    if (self != nil) {
        self.artID = [array valueForKey:@"id"];
        self.artTitle = [array valueForKey:@"title"];
        self.artDescription = [array valueForKey:@"description"];
        self.artPublishDate = [array valueForKey:@"publishDate"];
        self.artImageURL = [NSString stringWithFormat:@"http://hrdams.herokuapp.com/%@", [array valueForKey:@"image"]];
        self.userID = [array valueForKey:@"userId"];
        self.enable = [array valueForKey:@"enable"];
    }
    return self;
}

@end
