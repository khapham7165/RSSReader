//
//  DetailViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/23/20.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController (){
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    NSArray *dictionaties;
}
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

//save button action
- (IBAction)SaveBtnTap:(id)sender {
    
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Save !" message:@"Do you want to save this news?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        //disable button because already saved
        [self->_savebtn setEnabled:NO];
        
        //get context
        self->appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        self->context = self->appDelegate.persistentContainer.viewContext;
        
        // Create a new managed object
        NSManagedObject *newrss = [NSEntityDescription insertNewObjectForEntityForName:@"RSS" inManagedObjectContext:self->context];
        [newrss setValue:self.url forKey:@"url"];
        [newrss setValue:self.imgurl forKey:@"imgurl"];
        [newrss setValue:self.date forKey:@"date"];
        [newrss setValue:self.title forKey: @"title"];
        
        // Save the object
        [self->appDelegate saveContext];
        NSLog(@"News save!");
    }];
    
    UIAlertAction *saveCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    
    [saveAlert addAction:saveCancel];
    [saveAlert addAction:saveOK];
    
    [self presentViewController:saveAlert animated:YES completion:nil];
    
}
@end