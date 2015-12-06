//
//  AddArticle.m
//  Article Management
//
//  Created by Lun Sovathana on 12/1/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "AddArticle.h"
#import "ConnectionManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "LSTToast.h"

@interface AddArticle()<ConnectionManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    ConnectionManager *cm;
    
    // toast
    UIActivityIndicatorView *indicator;
    UIView *view;
    
    UIImagePickerController *imagePicker;
    
    NSMutableDictionary *article;
}

@end

@implementation AddArticle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    cm = [[ConnectionManager alloc] init];
    cm.delegate = self;
    
    // initialize image picker
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //indicator.hidesWhenStopped = YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
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
    article = [[NSMutableDictionary alloc] initWithObjects:@[title, desc] forKeys:@[@"title", @"description"]];
    
    // confirm user before save
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure want to save this article?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"SAVE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // add indicator
        [self addIndicator:indicator withMessage:@"Saving..."];
        
        // disable cance and save button
        self.buttonCancel.enabled = false;
        self.buttonSave.enabled = false;
        
        // upload image first
        [cm uploadImage:self.articleImage.image withKey:@"/api/article/upload_image"];
        
        // add text to dictionary
        //[cm requestData:article withKey:@"/api/article/hrd_c001"];
        
        // hide keyboard
        [self.titleTF resignFirstResponder];
        [self.descriptionTV resignFirstResponder];
        [self.view endEditing:YES];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:save];
    [alert addAction:cancel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
    
}

-(BOOL)checkStringIsEmpty:(NSString*)string withFieldName:(NSString*)fieldName{
    
    NSString *message = [NSString stringWithFormat:@"%@ cannot empty.", fieldName];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
    if ([string isEqualToString:@""]) {
        [self presentViewController:alert animated:YES completion:nil];
        return false;
    }
    
    return true;
}

#pragma mark - response data
-(void)responseData:(NSDictionary *)dataDictionary{
    if ([[dataDictionary objectForKey:@"MESSAGE"] isEqualToString:@"ARTICLE HAS BEEN INSERTED"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Article has been inserted." preferredStyle:UIAlertControllerStyleAlert];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self presentViewController:alert animated:YES completion:nil];
            
            [self presentViewController:alert animated:YES completion:^{
                [view removeFromSuperview];
                [self performSelector:@selector(dismissViewController) withObject:self afterDelay:1.0];
            }];
            
        });
        
        
        
    
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Cannot add article." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/*
 * Response when image upload successful
 */
-(void)responseImage:(NSDictionary *)dataDictionary{
    NSLog(@"%@", dataDictionary);
    // if image has been upload then upload article
    if ([[dataDictionary objectForKey:@"MESSAGE"] isEqualToString:@"IMAGE HAS BEEN INSERTED"]) {
        NSLog(@"upload complete");
        // insert image to dictionary
        [article setObject:[NSString stringWithFormat:@"%@/%@", cm.basedUrl, [dataDictionary objectForKey:@"ART_IMG"]] forKey:@"image"];
        [cm requestData:article withKey:@"/api/article/hrd_c001"];
    }
}

-(void)dismissAlert{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addIndicator:(UIActivityIndicatorView*)indicatorView withMessage:(NSString *)message{
    //NSLog(@"add");
    view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, self.view.frame.size.width-100.0, 50.0)];
    view.center = self.view.center;
    view.backgroundColor = [UIColor colorWithRed:(22/255.0) green:(144/255.0) blue:(67/255.0) alpha:1];
    view.layer.cornerRadius = view.frame.size.height/2;
    // activity indicator
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = CGRectMake(view.frame.origin.x+10.0, view.frame.size.height/2-15, 30.0, 30.0);
    indicatorView.hidesWhenStopped = YES;
    
    [view addSubview:indicatorView];
    
    // add message
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(indicatorView.frame.origin.x + 40, indicatorView.frame.origin.y-5, view.frame.size.width-(indicatorView.frame.size.width + 10), 40.0)];
    label.textColor = [UIColor whiteColor];
    label.text = message;
    [view addSubview:label];
    
    //[self.view addSubview:view];
    [self.view addSubview:view];
    [indicatorView startAnimating];
}


- (void)dismissViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - browse image
- (IBAction)browseImage:(id)sender {
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        // Do something with imageToUse
        self.articleImage.image = imageToUse;
        
    }
    //[[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
