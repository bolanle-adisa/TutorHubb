//
//  MailComposerView.swift
//  TutorHubb
//
//  Created by Bolanle Adisa on 11/13/23.
//

import SwiftUI
import MessageUI

struct MailComposerView: View {
    var userEmail: String
    var username: String
    var tutor: Tutor
    var date: Date
    var time: Date

    var body: some View {
        MailComposer(
            subject: "Appointment Confirmation with \(tutor.firstName) \(tutor.lastName)",
            recipients: [userEmail],
            body: emailBody(),
            tutor: tutor,
            date: date,
            time: time
        )
    }

    func emailBody() -> String {
        let formattedDate = dateFormatter.string(from: date)
        let formattedTime = timeFormatter.string(from: time)

        return """
        <html>
        <body>
        <p>Dear <strong>\(username)</strong>,</p>
        <p>You have scheduled an appointment with <strong>\(tutor.firstName) \(tutor.lastName)</strong>.</p>
        <p><strong>Appointment Details:</strong><br>
        Date: \(formattedDate)<br>
        Time: \(formattedTime)</p>
        <p>Please add this event to your calendar to receive a reminder.</p>
        <p>If you need to reschedule or cancel, please use the app or contact us at <a href="mailto:support@tutorhubb.com">support@tutorhubb.com</a>.</p>
        <p>Best regards,<br>The TutorHubb Team</p>
        </body>
        </html>
        """
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

// UIViewControllerRepresentable for handling the mail composer
struct MailComposer: UIViewControllerRepresentable {
    var subject: String
    var recipients: [String]
    var body: String
    var tutor: Tutor
    var date: Date
    var time: Date

    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposer

        init(_ parent: MailComposer) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(subject)
        vc.setToRecipients(recipients)
        vc.setMessageBody(body, isHTML: true) // Set to true for HTML content

        attachICSEvent(mailComposer: vc, tutor: tutor, date: date, time: time)

        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func attachICSEvent(mailComposer: MFMailComposeViewController, tutor: Tutor, date: Date, time: Date) {
        let icsString = createICSEvent(tutor: tutor, date: date, time: time)
        if let icsData = icsString.data(using: .utf8) {
            mailComposer.addAttachmentData(icsData, mimeType: "text/calendar", fileName: "appointment.ics")
        }
    }

    private func createICSEvent(tutor: Tutor, date: Date, time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let startDate = combine(date: date, time: time)
        let endDate = startDate.addingTimeInterval(3600)

        return """
        BEGIN:VCALENDAR
        VERSION:2.0
        CALSCALE:GREGORIAN
        BEGIN:VEVENT
        DTSTART:\(dateFormatter.string(from: startDate))
        DTEND:\(dateFormatter.string(from: endDate))
        SUMMARY:Appointment with \(tutor.firstName) \(tutor.lastName)
        DESCRIPTION:Tutoring session
        END:VEVENT
        END:VCALENDAR
        """
    }

    private func combine(date: Date, time: Date) -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        return calendar.date(from: DateComponents(year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: timeComponents.hour, minute: timeComponents.minute))!
    }
}

// Preview Provider
struct MailComposerView_Previews: PreviewProvider {
    static var previews: some View {
        // Simple text view to represent the Mail Composer in previews
        Text("Mail Composer Preview")
    }
}
