//
//  Created by Adam Stragner
//

import Essentials

@globalActor
public actor SynchronousActor: GlobalActor {
    public static var shared = DispatchActor(.init(label: "pcsc-kit"))
}
