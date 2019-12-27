import Foundation

class CellStateStore {
    var cellStates: Dictionary<String, CellState> = Dictionary<String, CellState>()

    func getCellState(cellIdentifier: String, createIfNotFound: Bool) -> CellState? {
        if createIfNotFound && cellStates[cellIdentifier] == nil {
            cellStates[cellIdentifier] = CellState()
        }

        return cellStates[cellIdentifier]
    }
    
    func saveCellState(cellIdentifier: String, newCellState: CellState?) {
        cellStates[cellIdentifier] = newCellState
    }
}
