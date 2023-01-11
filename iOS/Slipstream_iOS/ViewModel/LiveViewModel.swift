import SwiftUI

protocol LiveRepresentable: ObservableObject {
    
    var state: LiveViewModel.State { get }
    
    func checkPositions()
}


final class LiveViewModel: LiveRepresentable {
    
    enum State: Equatable {
        
        case loading([SessionResult])
        case results([SessionResult])
    }
    
    @Published var state: State = .loading(SessionResult.mock)
    
    
    @Published private var results = SessionResult.mock
    
    private var forceChange: Int = 0
    
    
    func checkPositions() {
        
        results = generateRandomTime()
        state = .results(results)
        
    }
    
    private func generateRandomTime() -> [SessionResult] {
        
        if forceChange == 10 {
            
            forceChange = 0
            
            var newResults = results.enumerated().map { index, result in
                var randomTime = Double.random(in: 1..<5)
                
                if index > 0 {
                    randomTime = results[index - 1].time - 3
                }
                
                return SessionResult(
                    id: result.id,
                    driver: result.driver,
                    points: result.points,
                    tirePitCount: result.tirePitCount,
                    startingGrid: result.startingGrid,
                    session: result.session,
                    tireName: result.tireName,
                    position: result.position,
                    time: randomTime < 0 ? Double.random(in: 1..<5) : randomTime,
                    lap: result.lap + 1
                )
                
            }
            .sorted(by: { $0.time < $1.time })
            
            
            let minimumTimeId = newResults.min { $0.time < $1.time }?.id ?? ""
            
            guard let index = newResults.firstIndex(where: { $0.id == minimumTimeId }) else { return [] }
            
            newResults[index].time = 0
            
            return newResults
        }
        
        forceChange += 1
        
        return results.enumerated().map { index, result in
            
            return SessionResult(
                id: result.id,
                driver: result.driver,
                points: result.points,
                tirePitCount: result.tirePitCount,
                startingGrid: result.startingGrid,
                session: result.session,
                tireName: result.tireName,
                position: result.position,
                time: index == 0 ? 0 : index < 0 ? Double.random(in: 1..<1.5) : result.time + Double.random(in: -0.05..<0.05),
                lap: result.lap
            )
            
        }
        .sorted(by: { $0.time < $1.time })
        
        
    }
}
