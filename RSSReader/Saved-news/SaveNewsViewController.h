//
//  SaveNewsViewController.h
//  RSSReader
//
//  Created by Kha Pham on 9/26/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveNewsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *unsaveBtn;
- (IBAction)unsaveBtnTap:(id)sender;

@end

NS_ASSUME_NONNULL_END
