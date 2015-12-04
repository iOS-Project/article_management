//
//  DetailArticleVC.m
//  Article Management
//
//  Created by Lun Sovathana on 11/29/15.
//  Copyright © 2015 Lun Sovathana. All rights reserved.
//

#import "DetailArticleVC.h"
#import "ConnectionManager.h"

@interface DetailArticleVC ()<ConnectionManagerDelegate>{
    ConnectionManager *cm;
    // toast
    UIActivityIndicatorView *indicator;
    UIView *view;
}
@end

@implementation DetailArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set data
    self.titleLabel.text = [self.data artTitle];
    self.publishDate.text = [self.data artPublishDate];
    self.descriptionLabel.text = [self.data artDescription];
    self.articleImage.image = [self.data artImage];
    
    cm = [[ConnectionManager alloc] init];
    cm.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)responseData:(NSDictionary *)dataDictionary{
    NSString *message = [dataDictionary valueForKeyPath:@"MESSAGE"];
    if ([message isEqualToString:@"ARTICLE HAS BEEN DELETED."]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Article has been deleted." preferredStyle:UIAlertControllerStyleAlert];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self presentViewController:alert animated:YES completion:nil];
            
            [self presentViewController:alert animated:YES completion:^{
                [view removeFromSuperview];
                [self performSelector:@selector(dismissViewController) withObject:self afterDelay:1.0];
            }];
            
        });
        
    }
    
    //NSLog(@"MESSAGE: %@", message);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)moreAction:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose Action" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Edit");
    }];
    
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        
        UIAlertController *alertDelete = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure want to delete this article?" preferredStyle:UIAlertControllerStyleAlert];
        // add delete action
        [alertDelete addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            NSDictionary *obj = [[NSDictionary alloc] initWithObjects:@[[self.data artID]] forKeys:@[@"id"]];
            
            // display toast
            [self addIndicator:indicator withMessage:@"Deleting..."];
            
            [cm requestData:obj withKey:@"/api/article/hrd_d001"];
        }]];
        
        [alertDelete addAction:[UIAlertAction actionWithTitle:@"Canel" style:UIAlertActionStyleCancel handler:nil]];
        
        // show delete confirm
        [self presentViewController:alertDelete animated:YES completion:nil];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    // add action to alert
    [alert addAction:edit];
    [alert addAction:delete];
    [alert addAction:cancel];
    
    // present alert
    [self presentViewController:alert animated:YES completion:nil];
    
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
@end
