//
//  SavedRSSTableViewController.h
//  RSSReader
//
//  Created by Kha Pham on 10/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SavedRSSTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *delAllBtn;
- (IBAction)delAllBtnTap:(id)sender;

@end

NS_ASSUME_NONNULL_END
