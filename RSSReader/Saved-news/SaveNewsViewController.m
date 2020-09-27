//
//  SaveNewsViewController.m
//  RSSReader
//
//  Created by Kha Pham on 9/26/20.
//

#import "SaveNewsViewController.h"
#import "AppDelegate.h"

@interface SaveNewsViewController (){
    AppDelegate *appDelegate;
    NSArray *result;
    NSManagedObject *item;
}

@end

@implementation SaveNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    result = [self->appDelegate fetchArrayFromCoreData:@"RSS"]; //data goes to result
    item = (NSManagedObject *)[self->result objectAtIndex:self.indexPath.row];
    
    [self.webView loadData:[item valueForKey:@"webdata"] MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:nil];

}

- (IBAction)unsaveBtnTap:(id)sender {
    
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Delete from saved-news!" message:@"Are you sure about that?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *saveOK = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        NSManagedObjectContext *context = self->appDelegate.persistentContainer.viewContext;
        [context deleteObject:self->item];
        
        NSError *deleteError = nil;
         
        if (![self->item.managedObjectContext save:&deleteError]) {
            NSLog(@"Unable to save managed object context.");
            NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
        }
        
        [self->_unsaveBtn setEnabled: NO];
        
        
    }];
    
    UIAlertAction *saveCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        
    }];
    
    [saveAlert addAction:saveCancel];
    [saveAlert addAction:saveOK];
    
    //show alert
    [self presentViewController:saveAlert animated:YES completion:nil];
}
@end
