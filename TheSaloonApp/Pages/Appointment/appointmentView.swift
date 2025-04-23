import SwiftUI

struct Booking: Identifiable {
    let id = UUID()
    let startTime: Date
    let endTime: Date
}

struct AvailableTimeSlotsView: View {
    let stylistWorkingHours: (start: Date, end: Date) = (
        Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!,
        Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
    )

    let existingBookings: [Booking] = [
        Booking(
            startTime: Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 11, minute: 30, second: 0, of: Date())!
        ),
        Booking(
            startTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!
        )
    ]

    let serviceDurationMinutes: Int = 60 // Example total service time
    let intervalMinutes: Int = 15

    var availableSlots: [Date] {
        getAvailableTimeSlots(
            existingBookings: existingBookings,
            totalDuration: serviceDurationMinutes,
            workingHours: stylistWorkingHours,
            interval: intervalMinutes
        )
    }

    var body: some View {
        NavigationView {
            List(availableSlots, id: \.self) { slot in
                Text(dateFormatter.string(from: slot))
            }
            .navigationTitle("Available Slots")
        }
    }

    func getAvailableTimeSlots(
        existingBookings: [Booking],
        totalDuration: Int,
        workingHours: (start: Date, end: Date),
        interval: Int = 15
    ) -> [Date] {
        var slots: [Date] = []
        var current = workingHours.start

        while current.addingTimeInterval(TimeInterval(totalDuration * 60)) <= workingHours.end {
            let proposedEnd = current.addingTimeInterval(TimeInterval(totalDuration * 60))

            let conflict = existingBookings.contains { booking in
                booking.startTime < proposedEnd && booking.endTime > current
            }

            if !conflict {
                slots.append(current)
            }

            current = current.addingTimeInterval(TimeInterval(interval * 60))
        }

        return slots
    }

    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    AvailableTimeSlotsView()
}
