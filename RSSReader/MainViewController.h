//
//  MainViewController.h
//  RSSReader
//
//  Created by Kha Pham on 9/24/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *RSSTextField;
@property (strong, nonatomic) IBOutlet UIButton *ReadRSSButton;
- (IBAction)vnetouch:(UIButton*)sender;

@end

NS_ASSUME_NONNULL_END
