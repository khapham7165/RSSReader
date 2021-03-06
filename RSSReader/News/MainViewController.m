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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString *string = _RSSTextField.text;
    //link for each tap
    if([segue.identifier isEqualToString:@"showTableSegue"]) {
        string = _RSSTextField.text;
        [[segue destinationViewController] setRssurl:string];
        string = @"News";
        [[segue destinationViewController] setTitle:string];
    } else if ([segue.identifier
    isEqualToString:@"showVNE"]) {
        string = @"https://vnexpress.net/rss/thoi-su.rss";
        [[segue destinationViewController] setRssurl:string];
        string = @"VNExpress News";
        [[segue destinationViewController] setTitle:string];
    } else if ([segue.identifier
    isEqualToString:@"showYH"]) {
        string = @"https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en";
        [[segue destinationViewController] setRssurl:string];
        string = @"Google News";
        [[segue destinationViewController] setTitle:string];
    } else if ([segue.identifier
    isEqualToString:@"appleNews"]) {
        string = @"https://developer.apple.com/news/rss/news.rss";
        [[segue destinationViewController] setRssurl:string];
        string = @"Apple News";
        [[segue destinationViewController] setTitle:string];
    } else if ([segue.identifier isEqualToString:@"showHCMUS"]) {
        string = @"https://www.fit.hcmus.edu.vn/vn/feed.aspx";
        [[segue destinationViewController] setRssurl:string];
        string = @"HCMUS(fit) News";
        [[segue destinationViewController] setTitle:string];
    }
}
- (IBAction)vnetouch:(UIButton*)sender {
    
}

-(void)dismissKeyboard
{
    [_aTextField resignFirstResponder];
}
@end
