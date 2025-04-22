import HealthKit

class HealthManager {
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
              let energy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            completion(false, nil)
            return
        }

        let readTypes: Set = [steps, energy, heartRate]
        healthStore.requestAuthorization(toShare: [], read: readTypes) { success, error in
            completion(success, error)
        }
    }

    func fetchSteps(completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let start = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let value = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            DispatchQueue.main.async { completion(value) }
        }

        healthStore.execute(query)
    }

    func fetchActiveEnergy(completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        let now = Date()
        let start = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            let value = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            DispatchQueue.main.async { completion(value) }
        }

        healthStore.execute(query)
    }

    func fetchLatestHeartRate(completion: @escaping (Double) -> Void) {
        guard let type = HKQuantityType.quantityType(forIdentifier: .heartRate) else { return }

        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, results, _ in
            if let sample = results?.first as? HKQuantitySample {
                let bpm = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                DispatchQueue.main.async { completion(bpm) }
            } else {
                DispatchQueue.main.async { completion(0) }
            }
        }

        healthStore.execute(query)
    }
}
