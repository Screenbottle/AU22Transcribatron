//
//  CalendarView.swift
//  AU22Transcribatron
//
//  Created by Arvid Rydh on 2023-02-14.
//

import SwiftUI
import FSCalendar
import UIKit

struct CalendarView: View {

    @State var selectedDate: Date = Date()

    var body: some View {
        CalendarViewRepresentable(selectedDate: $selectedDate)
        .padding(.bottom)
        .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
        /*
        .background {
            AsyncImage(url: URL(string: "https://images.pexels.com/photos/1939485/pexels-photo-1939485.jpeg"))
            { img in
                img.resizable(resizingMode: .stretch)
                    .blur(radius: 4, opaque: true)
            }
            placeholder: {
                LinearGradient(colors: [.red.opacity(0.4), .green.opacity(0.4)], startPoint: .top, endPoint: .bottom)
            }
        }
        */
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct CalendarViewRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar

    fileprivate var calendar = FSCalendar()
    
    @Binding var selectedDate: Date

    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator

        // Added the below code to change calendar appearance
        
        calendar.appearance.todayColor = UIColor(displayP3Red: 0,
                                                  green: 0,
                                                  blue: 0, alpha: 0)
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.selectionColor = .orange
        calendar.appearance.eventDefaultColor = .red
        calendar.appearance.titleTodayColor = .blue
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 24)
        calendar.appearance.titleWeekendColor = .systemOrange
        calendar.appearance.headerMinimumDissolvedAlpha = 0.12
        calendar.appearance.headerTitleFont = .systemFont(
                                                ofSize: 30,
                                                weight: .black)
        calendar.appearance.headerTitleColor = .darkGray
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        calendar.clipsToBounds = false

        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject,
          FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarViewRepresentable

        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar,
                      didSelect date: Date,
                      at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }

        func calendar(_ calendar: FSCalendar,
                  imageFor date: Date) -> UIImage? {
            if isWeekend(date: date) {
                return UIImage(systemName: "sparkles")
            }
            return nil
        }

        func calendar(_ calendar: FSCalendar,
                      numberOfEventsFor date: Date) -> Int {
            let eventDates: [Date] = []
            var eventCount = 0
            eventDates.forEach { eventDate in
                if eventDate.formatted(date: .complete,
                              time: .omitted) == date.formatted(
                                date: .complete, time: .omitted){
                    eventCount += 1;
                }
            }
            return eventCount
        }

        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            if isWeekend(date: date) {
                return false
            }
            return true
        }

        func maximumDate(for calendar: FSCalendar) -> Date {
            Date.now.addingTimeInterval(86400 * 30)
        }

        func minimumDate(for calendar: FSCalendar) -> Date {
            Date.now.addingTimeInterval(-86400 * 30)
        }
    }
}

func isWeekend(date: Date) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let day: String = dateFormatter.string(from: date)
    if day == "Saturday" || day == "Sunday" {
        return true
    }
    return false
}
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
