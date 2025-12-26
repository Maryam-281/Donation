//
//  HomeViewController.swift
//  Donation
//
//  Created by BP-36-201-09 on 24/12/2025.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didApplyFilters(category: Category?, location: Location?, status: Status?)
}



