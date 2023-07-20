import SwiftUI

extension View {
    func ifNeeded<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        condition ? AnyView(content(self)) : AnyView(self)
    }
}
