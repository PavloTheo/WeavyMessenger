//
//  AvatarView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-22.
//

import SwiftUI
import Kingfisher

struct AvatarView: View {
    
    let url: URL
    var size: CGSize
    
    var body: some View {
        KFImage(url)
            .setProcessor(DownsamplingImageProcessor(size: size))
            .placeholder {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
                    .opacity(0.3)
            }
            .resizable()
            .frame(width: size.width, height: size.height)
            .background(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .opacity(0.3)
                        )
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(url: URL(string: "https://en.wikipedia.org/wiki/Joseph_Stalin#/media/File:Stalin_Full_Image.jpg")!, size: CGSize(width: 30, height: 30))
    }
}
