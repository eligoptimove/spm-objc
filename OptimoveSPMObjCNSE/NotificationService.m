//  Copyright © 2020 Optimove. All rights reserved.

#import "NotificationService.h"
@import OptimoveNotificationServiceExtension;

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@property (nonatomic, strong) OptimoveNotificationServiceExtension *optimoveExtension;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {

    self.optimoveExtension = [[OptimoveNotificationServiceExtension alloc] init];
    BOOL isOptimoveNotificaiton = [self.optimoveExtension didReceive:request withContentHandler:contentHandler];
    if (!isOptimoveNotificaiton) {
        self.contentHandler = contentHandler;
        self.bestAttemptContent = [request.content mutableCopy];

        // Modify the notification content here...
        self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];

        self.contentHandler(self.bestAttemptContent);
    }
}

- (void)serviceExtensionTimeWillExpire {
    if ([self.optimoveExtension isHandledByOptimove]) {
        [self.optimoveExtension serviceExtensionTimeWillExpire];
        return;
    }
    self.contentHandler(self.bestAttemptContent);
}

@end
