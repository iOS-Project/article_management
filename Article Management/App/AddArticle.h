//
//  AddArticle.h
//  Article Management
//
//  Created by Lun Sovathana on 12/1/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddArticle : UIViewController
- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSave;

- (IBAction)browseImage:(id)sender;

@end
