//
//  DevoteWidgetBundle.swift
//  DevoteWidget
//
//  Created by Michael Schmidt on 5/6/23.
//

import WidgetKit
import SwiftUI

@main
struct DevoteWidgetBundle: WidgetBundle {
    var body: some Widget {
        DevoteWidget()
        DevoteWidgetLiveActivity()
    }
}
