//  HealthManager.swift
//  Health_FinalProject
//
//  Created by Rehnuma Taskin on 08/04/2025.
//

import SwiftUI
import HealthKit

enum MetricType: String, CaseIterable, Identifiable {
    case steps, calories, heartRate, sleep
    var id: String { rawValue }

    var icon: String {
        switch self {
        case .steps:     return "figure.walk"
        case .calories:  return "flame.fill"
        case .heartRate: return "heart.fill"
        case .sleep:     return "bed.double.fill"
        }
    }

    var label: String {
        switch self {
        case .steps:     return "Steps"
        case .calories:  return "Calories"
        case .heartRate: return "Heart Rate"
        case .sleep:     return "Sleep"
        }
    }

    func defaultGoal() -> Double {
        switch self {
        case .steps:     return 10_000
        case .calories:  return 500
        case .heartRate: return 120
        case .sleep:     return 8
        }
    }
}

class HealthManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var steps: Double = 0
    @Published var calories: Double = 0
    @Published var heartRate: Double = 0
    @Published var sleepHours: Double = 0

    private var timer: Timer?

    init() {
        requestAuthorization { ok, _ in
            if ok {
                DispatchQueue.main.async { self.startPolling(every: 5) }
            }
        }
    }

    func requestAuthorization(_ completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable(),
              let s = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let e = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned),
              let h = HKQuantityType.quantityType(forIdentifier: .heartRate),
              let sl = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        else {
            completion(false, nil)
            return
        }
        healthStore.requestAuthorization(toShare: [], read: [s,e,h,sl], completion: completion)
    }

    private func startPolling(every sec: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: sec, repeats: true) { _ in
            self.fetchSteps()
            self.fetchCalories()
            self.fetchHeartRate()
            self.fetchSleep()
        }
        timer?.fire()
    }

    private func fetchSteps() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let pred  = HKQuery.predicateForSamples(
            withStart: start, end: Date(), options: .strictStartDate)
        let qry   = HKStatisticsQuery(
            quantityType: type,
            quantitySamplePredicate: pred,
            options: .cumulativeSum
        ) { _, res, _ in
            let v = res?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async { self.steps = v
                if v < 2000 {
                    NotificationManager.shared.scheduleOneTimeReminder(
                        id: "lowSteps", title: "Time to Move! 🚶‍♀️",
                        body: "You've walked only \(Int(v)) steps so far today.",
                        after: 1
                    )
                }
            }
        }
        healthStore.execute(qry)
    }

    private func fetchCalories() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let pred  = HKQuery.predicateForSamples(
            withStart: start, end: Date(), options: .strictStartDate)
        let qry   = HKStatisticsQuery(
            quantityType: type,
            quantitySamplePredicate: pred,
            options: .cumulativeSum
        ) { _, res, _ in
            let v = res?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            DispatchQueue.main.async { self.calories = v }
        }
        healthStore.execute(qry)
    }

    private func fetchHeartRate() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let qry  = HKSampleQuery(
            sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]
        ) { _, res, _ in
            let v = (res?.first as? HKQuantitySample)?
                .quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            DispatchQueue.main.async { self.heartRate = v }
        }
        healthStore.execute(qry)
    }

    private func fetchSleep() {
        guard let type = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else { return }
        let start = Calendar.current.startOfDay(for: Date())
        let pred  = HKQuery.predicateForSamples(
            withStart: start, end: Date(), options: .strictStartDate)
        let qry   = HKSampleQuery(
            sampleType: type, predicate: pred,
            limit: HKObjectQueryNoLimit, sortDescriptors: nil
        ) { _, res, _ in
            let secs = (res as? [HKCategorySample])?.reduce(0) { acc, s in
                s.value == HKCategoryValueSleepAnalysis.asleep.rawValue
                  ? acc + s.endDate.timeIntervalSince(s.startDate)
                  : acc
            } ?? 0
            DispatchQueue.main.async { self.sleepHours = secs / 3600 }
        }
        healthStore.execute(qry)
    }
}
