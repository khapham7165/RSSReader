//
//  SaveNewsViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/26/20.
//

#import "SaveNewsViewController.h"

@interface SaveNewsViewController ()

@end

@implementation SaveNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Url: %@", self.url);
    NSString* webStringURL = [NSString stringWithFormat:@"%@", self.url];
    NSURL *myURL = [NSURL URLWithString:[webStringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"After copied url = %@",myURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
