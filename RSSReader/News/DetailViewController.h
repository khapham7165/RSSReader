//
//  DetailViewController.h
//  RSSReader
//
//  Created by Kha Pham on 9/23/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savebtn;

- (IBAction)SaveBtnTap:(id)sender;

@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *imgurl;
@property (copy, nonatomic) NSString *date;

@end

NS_ASSUME_NONNULL_END
