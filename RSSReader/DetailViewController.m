//
//  DetailViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/23/20.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Url: %@", self.url);
    NSString* webStringURL = [NSString stringWithFormat:@"%@", self.url];
    NSURL *myURL = [NSURL URLWithString:[webStringURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSLog(@"After copied url = %@",myURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.detailWebView loadRequest:request];
}


@end
