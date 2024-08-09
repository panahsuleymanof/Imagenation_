//
//  Coordinator.swift
//  Imagenation
//
//  Created by Panah Suleymanli on 09.08.24.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
