//
//  Pixel.swift
//  Pong
//
//  Created by Anand Gogoi on 11/30/21.
//

import SwiftUI

struct Pixel : View {
    let pwidth : CGFloat // width
    let pheight : CGFloat // height
    let color : Color // color
    
    // constructor
    var body: some View{
        Rectangle().frame(width: pwidth, height: pheight)
        .foregroundColor(color)
    }
    
}
