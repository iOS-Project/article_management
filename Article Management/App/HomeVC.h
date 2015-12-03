//
//  HomeVC.h
//  Article Management
//
//  Created by Lun Sovathana on 11/28/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableArticle;
- (IBAction)openSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addArticle:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
