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
@property (copy, nonatomic) NSString *url;

@end

NS_ASSUME_NONNULL_END
