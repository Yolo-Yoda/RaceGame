import Foundation
import RxSwift
import RxCocoa
import Differentiator
import RxDataSources


typealias ResultRaces = SectionModel<TableViewSection,TableViewItem>

enum TableViewSection {
    case main
}

enum TableViewItem {
    case resultRace(info: ResultRace)
}

class RecordViewModel {
    
    var dataArrayNew = PublishSubject<[ResultRaces]>()
    
    var subresults : [TableViewItem] =  [.resultRace(info: AppSettings.shared.lastScores)]
    
    func getInformation() {
        var subResults = [TableViewItem]()
        
        subResults = ([
            .resultRace(info: AppSettings.shared.lastScores)
        ])
        
        dataArrayNew.onNext([ResultRaces(model: .main, items: subResults)])
        
    }
   
}



