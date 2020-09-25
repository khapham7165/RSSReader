//
//  MainViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/24/20.
//

#import "MainViewController.h"
#import "TableViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSURL *rssurl = [NSURL URLWithString:_RSSTextField.text];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showTableSegue"]) {
        NSString *string = _RSSTextField.text;
        [[segue destinationViewController] setRssurl:string];
    } else if ([segue.identifier
    isEqualToString:@"showVNE"]) {
        NSString *string = @"https://vnexpress.net/rss/thoi-su.rss";
        [[segue destinationViewController] setRssurl:string];
    } else if ([segue.identifier
    isEqualToString:@"showYH"]) {
        NSString *string = @"https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en";
        [[segue destinationViewController] setRssurl:string];
    } else if ([segue.identifier
    isEqualToString:@"appleNews"]) {
        NSString *string = @"https://developer.apple.com/news/rss/news.rss";
        [[segue destinationViewController] setRssurl:string];
    }
}
- (IBAction)vnetouch:(UIButton*)sender {
    
}
@end
