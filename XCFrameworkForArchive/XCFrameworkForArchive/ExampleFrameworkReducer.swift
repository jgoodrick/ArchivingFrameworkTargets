
import Foundation
import AnExampleLibrary
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ExampleFrameworkReducer: Reducer {
    
    @ObservableState
    public struct State {
        public var libraryReducer: LibraryReducer.State
    }
    
    public enum Action {
        case libraryReducer(LibraryReducer.Action)
        
        case task
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.libraryReducer, action: \.libraryReducer) {
            LibraryReducer()
        }
    }
}

public struct ExampleFrameworkView: View {
    let store: StoreOf<ExampleFrameworkReducer>
    
    public var body: some View {
        LibraryView(store: store.scope(state: \.libraryReducer, action: \.libraryReducer))
    }
}
