//
//  CancelBag.swift
//  iTamin
//
//  Created by Tabber on 2022/09/23.
//

import Combine
import UIKit

public final class CancelBag: Cancellable {

  private let lock: NSLock = NSLock()
  private var cancellables: [Cancellable] = []

  public init() {
  }

  internal func add(_ cancellable: Cancellable) {
    self.lock.lock()
    defer { self.lock.unlock() }
    self.cancellables.append(cancellable)
  }

  public func cancel() {
    self.lock.lock()
    let cancellables = self.cancellables
    self.cancellables.removeAll()
    self.lock.unlock()

    for cancellable in cancellables {
      cancellable.cancel()
    }
  }

  deinit {
    self.cancel()
  }
}


public extension Cancellable {
  func cancel(with cancellable: CancelBag) {
    cancellable.add(self)
  }
}
