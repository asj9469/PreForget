//
//  PopoverViews.swift
//  PreForget
//
//  Created by Anson Goo on 5/5/23.
//

import SwiftUI

struct CompletedPopoverView: View {
    var body: some View {
        Label("Done!", systemImage: "checkmark")
            .font(.system(.title3, design: .rounded).bold())
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct AddedPopoverView: View {
    var body: some View {
        Label("Added!", systemImage: "checkmark")
            .font(.system(.title3, design: .rounded).bold())
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct NotifOnPopoverView: View {
    var body: some View {
        Label("Reminder On!", systemImage: "bell.fill")
            .font(.system(.title3, design: .rounded).bold())
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct NotifOffPopoverView: View{
    var body: some View {
        Label("Reminder Off!", systemImage: "bell")
            .font(.system(.title3, design: .rounded).bold())
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct CheckmarkPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedPopoverView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.blue)
        AddedPopoverView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.blue)
        NotifOnPopoverView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.blue)
        NotifOffPopoverView()
            .previewLayout(.sizeThatFits)
            .padding()
            .background(.blue)
    }
}

