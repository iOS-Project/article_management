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
}
@end

@implementation DetailArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set data
    self.titleLabel.text = [self.data artTitle];
    self.publishDate.text = [self.data artPublishDate];
    self.descriptionLabel.text = [self.data artDescription];
    self.articleImage.image = [UIImage imageNamed:@"default.jpg"];
    
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
        //NSLog(@"SUCCESS");
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            UIAlertController *success = [UIAlertController alertControllerWithTitle:@"Message" message:@"Article has been deleted." preferredStyle:UIAlertControllerStyleAlert];
            [success addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                // go to home
                //[self performSegueWithIdentifier:@"goHome" sender:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self presentViewController:success animated:YES completion:nil];
        });
        
    }
    
    NSLog(@"MESSAGE: %@", message);
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
@end
