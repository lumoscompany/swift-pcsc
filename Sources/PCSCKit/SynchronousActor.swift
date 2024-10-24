//
//  Created by Adam Stragner
//

import Essentials

// MARK: - SynchronousActor

@globalActor
public actor SynchronousActor {
    public static let shared = SynchronousActor()
    public static let sharedUnownedExecutor = Executor.shared.asUnownedSerialExecutor()

    public static func run<T, E>(
        _ operation: @SynchronousActor @Sendable () throws (E) -> T
    ) async rethrows -> T where T: Sendable {
        try await operation()
    }

    public static func runDetached<T, E>(
        _ operation: @SynchronousActor @Sendable @escaping () throws (E) -> T
    ) where T: Sendable {
        Task.detached(operation: operation)
    }
}

// MARK: SynchronousActor.Executor

extension SynchronousActor {
    final class Executor: SerialExecutor, @unchecked Sendable {
        // MARK: Internal

        static let shared = Executor()

        func enqueue(_ job: consuming ExecutorJob) {
            let unownedJob = UnownedJob(job)
            queue.async(execute: { [unowned self] in
                unownedJob.runSynchronously(on: asUnownedSerialExecutor())
            })
        }

        func asUnownedSerialExecutor() -> UnownedSerialExecutor {
            UnownedSerialExecutor(ordinary: self)
        }

        // MARK: Private

        private let queue = DispatchQueue(label: "pcsc-kit")
    }
}
