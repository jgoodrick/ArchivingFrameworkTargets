// The Swift Programming Language
// https://docs.swift.org/swift-book

import ComposableArchitecture
import SwiftUI

public struct LibraryReducer: Reducer {
    public init(property: String = "Some Property") {
        self.property = property
    }
    
    public var property: String = "Some Property"
    
    public struct State: Equatable {
        @BindingState var stateA: String = "initial field value"
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case task
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
    }
}

public struct LibraryView: View {
    public init(store: StoreOf<LibraryReducer>) {
        self.store = store
    }
    
    let store: StoreOf<LibraryReducer>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TextField("Property Text Field", text: viewStore.$stateA)
        }
    }
}
