
import ComposableArchitecture
import SwiftUI

@Reducer
public struct LibraryReducer: Reducer {
    public init(property: String = "Some Property") {
        self.property = property
    }
    
    public var property: String = "Some Property"
    
    @ObservableState
    public struct State: Equatable {
        var stateA: String = "initial field value"
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
    
    @BindableStore var store: StoreOf<LibraryReducer>
    
    public var body: some View {
        WithPerceptionTracking {
            TextField("Property Text Field", text: $store.stateA)
        }
    }
}
