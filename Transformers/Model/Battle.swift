
//
//  Battle.swift
//  Transformers
//
//  Created by Haspinder Gill on 2020-07-12.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import Foundation

enum Winner {
    case TeamA
    case TeamD
    case Tie
}

enum Result {
    case GameTie(numberOfBattles: Int)
    case GameEnd
    case TeamA(numberOfBattles: Int,aTeamSurvivors: [String],dTeamSurvivors: [String])
    case TeamD(numberOfBattles: Int,aTeamSurvivors: [String],dTeamSurvivors: [String])
}

class Battle {
    
    var battles = 0
    
    //Transformers With special powers
    let specialTransformers = ["Optimus Prime", "Predaking"]

    func battle(list: [Transformer]) -> Result {
        
        //init values before each battle
        self.battles = 0
        
        //Filters list of transformers into teams and sort them according to rank
        let aTeam = list.filter({$0.team == "A"}).sorted(by: {$0.rank < $1.rank})
        let dTeam = list.filter({$0.team == "D"}).sorted(by: {$0.rank < $1.rank})

        var autoBotSurvivors = aTeam
        var decepticonsSurvivors = dTeam
        
        for index in 0..<min(aTeam.count, dTeam.count){
            let aTeamInvade = aTeam[index]
            let dTeamInvade = dTeam[index]
            self.battles += 1

            //Following condition reflects a special rule if any special Transformer face each , it results into game end
            if specialTransformers.contains(aTeamInvade.name) && specialTransformers.contains(dTeamInvade.name)  {
                return .GameEnd
            }
            switch self.calculateWinner(aTeamInvade: aTeamInvade, dTeamInvade: dTeamInvade) {
            case .TeamA:
                decepticonsSurvivors.removeAll(where: {$0.id == dTeamInvade.id})
            case .TeamD:
                autoBotSurvivors.removeAll(where: {$0.id == aTeamInvade.id})
            default:
                autoBotSurvivors.removeAll(where: {$0.id == aTeamInvade.id})
                decepticonsSurvivors.removeAll(where: {$0.id == dTeamInvade.id})
            }
        }
        
        
        if (aTeam.count - autoBotSurvivors.count) == (dTeam.count - decepticonsSurvivors.count) {
            return .GameTie(numberOfBattles: battles)
        } else if (aTeam.count - autoBotSurvivors.count) < (dTeam.count - decepticonsSurvivors.count){
            return .TeamA(numberOfBattles: battles, aTeamSurvivors: autoBotSurvivors.compactMap({$0.name}), dTeamSurvivors: decepticonsSurvivors.compactMap({$0.name}))
        } else {
            return .TeamD(numberOfBattles: battles, aTeamSurvivors: autoBotSurvivors.compactMap({$0.name}), dTeamSurvivors: decepticonsSurvivors.compactMap({$0.name}))
        }
    }
    
    
    
    
    // Following Method calcultes winner of each faceoff
    func calculateWinner(aTeamInvade: Transformer, dTeamInvade: Transformer) -> Winner{
        
        if specialTransformers.contains(aTeamInvade.name) {
            return .TeamA
        } else if specialTransformers.contains(dTeamInvade.name) {
            return .TeamD
        }
        else if (aTeamInvade.courage - dTeamInvade.courage) >= 4 &&  (aTeamInvade.strength - dTeamInvade.strength) >= 3 {
            return .TeamA
                
        } else if (dTeamInvade.courage - aTeamInvade.courage) >= 4 &&  (dTeamInvade.strength - aTeamInvade.strength) >= 3 {
            return .TeamD
        }
        else if abs(aTeamInvade.skill - dTeamInvade.skill) >= 3 {
            if aTeamInvade.skill > dTeamInvade.skill {
                return .TeamA
            } else {
                return .TeamD
            }
        } else {
                //Overall Rating = Strength + Intelligence + Speed + Endurance + Firepower
            let aTeamInvadeOverallrating = aTeamInvade.strength + aTeamInvade.intelligence + aTeamInvade.speed + aTeamInvade.endurance + aTeamInvade.firepower
            let dTeamInvadeOverallrating = dTeamInvade.strength + dTeamInvade.intelligence + dTeamInvade.speed + dTeamInvade.endurance + dTeamInvade.firepower
            if aTeamInvadeOverallrating > dTeamInvadeOverallrating {
                return .TeamA
            } else if aTeamInvadeOverallrating < dTeamInvadeOverallrating{
                return .TeamD
            } else {
                return .Tie
            }
        }
    }
}

