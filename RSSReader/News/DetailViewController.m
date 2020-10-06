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
    NSArray *results;
    NSData *myPagedata;
    NSURL *myURL;
    NSURL *myImgURL;
    
    //things for alert
    NSMutableString *Title;
    NSMutableString *Des;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //convert string url to url
    NSString* webStringURL = [NSString stringWithFormat:@"%@", self.url];
    myURL = [NSURL URLWithString:[webStringURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSLog(@"url = %@",myURL);
    
    //show url content on webview
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [self.detailWebView loadRequest:request];
    
    //disable save if already save
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    results = [appDelegate fetchArrayFromCoreData:@"RSS"];
    if (results.count > 0){
        //compare 2 urls
        for(unsigned int i = 0; i < [results count]; i++){
            NSManagedObject *item = (NSManagedObject *)[results objectAtIndex:i];
            //NSLog(@"self url: %@\ncompare : %@", self.url, [item valueForKey:@"url"]);
            if([[item valueForKey:@"url"] isEqualToString:self.url]){
                [self->_savebtn setImage:[UIImage systemImageNamed:@"heart.fill"]];
                break;
            } else {
                [self->_savebtn setImage:[UIImage systemImageNamed:@"heart"]];
            }
        }
    }
}

//save button action
- (IBAction)SaveBtnTap:(id)sender {
    if(_savebtn.image == [UIImage systemImageNamed:@"heart"]){
        Title = [NSMutableString stringWithFormat:@"Save"];
        Des = [NSMutableString stringWithFormat:@"Do you want to save this news?"];
    }else{
        Title = [NSMutableString stringWithFormat:@"Unsave"];
        Des = [NSMutableString stringWithFormat:@"Do you want to unsave this news?"];
    }
    
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:Title message: Des preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        //disable button because already saved
        //[self->_savebtn setEnabled:NO];
        
        //get context
        self->appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        self->context = self->appDelegate.persistentContainer.viewContext;
        
        //refresh results
        self->results = [self->appDelegate fetchArrayFromCoreData:@"RSS"];
        
        if(self->_savebtn.image == [UIImage systemImageNamed:@"heart"]){
        // Create a new object
            NSManagedObject *newrss = [NSEntityDescription insertNewObjectForEntityForName:@"RSS" inManagedObjectContext:self->context];
            [newrss setValue:self.url forKey:@"url"];
            self->myImgURL = [NSURL URLWithString:self.imgurl];
            [newrss setValue:[NSData dataWithContentsOfURL: self->myImgURL] forKey:@"imgdata"];
            [newrss setValue:self.date forKey:@"date"];
            [newrss setValue:self.title forKey: @"title"];
            [newrss setValue:[NSData dataWithContentsOfURL: self->myURL] forKey:@"webdata"];
            // Save the object into core data
            [self->appDelegate saveContext];
            
            [self->_savebtn setImage:[UIImage systemImageNamed:@"heart.fill"]];

            NSLog(@"News saved!");
        } else {
            
            
            NSManagedObject *delItem;
            
            //find index for deleting
            int delIndex = -1;
            for(unsigned int i = 0; i < self->results.count; i++){
                NSManagedObject *item = (NSManagedObject *)[self->results objectAtIndex:i];
                //NSLog(@"self url: %@\ncompare : %@", self.url, [item valueForKey:@"url"]);
                if([[item valueForKey:@"url"] isEqualToString: self->_url]){
                    delIndex = i;
                    break;
                }
            }
            if(delIndex == -1){
                NSLog(@"Del error");
                [self->_savebtn setImage:[UIImage systemImageNamed:@"heart"]];
            }
            else{
                delItem = (NSManagedObject *)[self->results objectAtIndex:delIndex];
                [self->context deleteObject:delItem];
                
                NSError *deleteError = nil;
                
                if (![delItem.managedObjectContext save:&deleteError]) {
                    NSLog(@"Unable to delete managed object context.");
                    NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
                }
                
                //set icon back to star - unsave yet!
                [self->_savebtn setImage:[UIImage systemImageNamed:@"heart"]];
                
                NSLog(@"News removed");
            }
        }
    }];
    
    UIAlertAction *saveCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    
    [saveAlert addAction:saveCancel];
    [saveAlert addAction:saveOK];
    
    //show allert
    [self presentViewController:saveAlert animated:YES completion:nil];
    
}
@end
