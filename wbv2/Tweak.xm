#import "wb.h"

%hook WBPageInfoVideoContentView

- (void)playButtonPressed:(id)arg1 {
    
    if(self.pageInfo){
        NSString *mmurlstr = [self.pageInfo.videoItem.urlItem.itemURL absoluteString];
        NSLog(@"=== 009 : url : %@", mmurlstr);
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		pasteboard.string = mmurlstr;
    }

    %orig;

}

%end
 