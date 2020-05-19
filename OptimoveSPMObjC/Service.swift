//  Copyright © 2020 Optimove. All rights reserved.

import Foundation
import OptimoveSDK

@objc class Service: NSObject {
    @objc func doNothing() {
        Optimove.shared.enablePushCampaigns()
    }
}
